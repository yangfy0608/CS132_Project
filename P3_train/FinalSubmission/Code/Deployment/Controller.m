classdef Controller < handle
    
    properties
        app
        locomotiveList
        stationList
        timer
        t
    end
    
    properties(Constant)
        dt = 0.5; 
        safeCoefficient = 0.15; % The higher, the safer
    end
    
    
    methods
        function ctrl = Controller()
            ctrl.timer = timer;
            ctrl.timer.Period = ctrl.dt;
            ctrl.timer.TimerFcn = @ctrl.update;
            ctrl.timer.ExecutionMode = 'fixedRate';
            ctrl.t = 0;
            ctrl.locomotiveList = [];
            ctrl.stationList = [Station(0,'Start',0,0), Station(1,'S1', 4800, 2), Station(2,'S2', 7200, 1), Station(3,'S3', 10200, 3), Station(4,'S4', 12000, 1), Station(5,'S5', 19200, 3), Station(6,'End', 21600, 0)];
            for i = 1:length(ctrl.stationList)
                ctrl.stationList(i).controller = ctrl;
            end
        end
        function ctrl = clear(ctrl)
            stop(ctrl.timer);
            ctrl.t = 0;
            ctrl.locomotiveList = [];
            for i = 1:length(ctrl.stationList)
                ctrl.stationList(i).clear;
            end
        end
        function ctrl = reset(ctrl)
            stop(ctrl.timer);
            ctrl.t = 0;
            for i = 1:length(ctrl.locomotiveList)
                ctrl.locomotiveList(i).reset;
            end
            for i = 1:length(ctrl.stationList)
                ctrl.stationList(i).reset;
            end
        end
        function time = getTime(ctrl)
            time = ctrl.t;
        end
        function pos = getPosition(ctrl, locomotive)
            if locomotive.stationID ~= -1
                pos = locomotive.stationID;
                return;
            end
            for i = 5:-1:0
                if locomotive.x >= ctrl.stationList(i+1).x
                    pos = i+0.5;
                    return;
                end
            end
            pos = 0;
        end
        % Locomotive function
        function locomotive = addLocomotive(ctrl, id, name, scheduleArrival, scheduleDeparture)
            locomotive = Locomotive(id, name, scheduleArrival, scheduleDeparture);
            locomotive.controller = ctrl;
            ctrl.locomotiveList = [ctrl.locomotiveList locomotive];
            ctrl.stationList(1).numRails = id;
            ctrl.stationList(1).rails = [ctrl.stationList(1).rails id];
            ctrl.stationList(7).numRails = id;
            ctrl.stationList(7).rails = [ctrl.stationList(7).rails 0];
        end
        function locomotives = getLocomotives(ctrl)
            locomotives = ctrl.locomotiveList;
        end
        function stations = getStations(ctrl)
            stations = ctrl.stationList;
        end
        % Helper function
        function safeV = calcSafeV(ctrl, loco1, loco2)
            if loco2.stationID ~= -1
                departureTime = loco2.departureTime(loco2.stationID + 1);
                temptime = departureTime - ctrl.t + loco1.v/loco2.a_start;
                temptime = ceil(temptime/ctrl.dt) * ctrl.dt;
                safeV = (loco1.nearestDistance + loco1.v^2/(2*loco2.a_start))/temptime;
            else
                anotherNextStationDistance = ctrl.stationList(ceil(ctrl.getPosition(loco2)) + 1).x - loco2.x;
                brakingDistance = loco2.v^2/(2*abs(loco2.a_braking));
                anotherNearestDistance = min(anotherNextStationDistance, loco2.nearestDistance);
                if anotherNearestDistance <= brakingDistance
                    temptime = loco2.v/abs(loco2.a_braking);
                    temptime = ceil(temptime/ctrl.dt) * ctrl.dt;
                    safeV = (loco1.nearestDistance + anotherNearestDistance) / temptime;
                else
                    if loco2.a > 0
                        safeV = fzero(@(v) (v - loco2.v)^2/(2 * loco2.a) - loco1.nearestDistance , loco1.v);
                    else
                        temptime = loco2.v/abs(loco2.a_braking) + (anotherNearestDistance-brakingDistance) / loco2.v;
                        temptime = ceil(temptime/ctrl.dt) * ctrl.dt;
                        safeV = (loco1.nearestDistance + anotherNearestDistance) / temptime;
                    end
                end
            end
        end
        % Auto control function
        function updateLocomotives(ctrl) 
            for i=1:length(ctrl.locomotiveList)
                ctrl.locomotiveList(i).move;
            end
        end
        function switchStatus(ctrl)
            for i=1:length(ctrl.locomotiveList)
                ctrl.locomotiveList(i).switchStatus;
            end
        end
        function handleArrival(ctrl)
            locomotives = ctrl.locomotiveList;
            for i=1:length(locomotives)
                locomotive = locomotives(i);
                if locomotive.stationID == 6
                    continue;
                end
                nextStation = ctrl.stationList(locomotive.nextStationID + 1);
                if locomotive.stationID == -1 && strcmp(locomotive.status, 'Stopped') && nextStation.x - locomotive.x < min(locomotive.nearestDistance, 100) && nextStation.rails(nextStation.currentRail+1) == 0 && nextStation.currentRail ~= 0
                       nextStation.handleArrival(locomotive);
                       % Set the next station of locomotive
                       locomotive.nextStationID = nextStation.id + 1;
                       if nextStation.id == 6
                           continue;
                       end
                       while locomotive.scheduleArrival(locomotive.nextStationID + 1) == -1
                            locomotive.nextStationID = locomotive.nextStationID + 1;
                       end
                end
            end
        end
        function checkDeparture(ctrl)
            for i=1:6 % Except end station
                ctrl.stationList(i).checkDeparture();
            end
        end
        function checkArrival(ctrl)
            for i=1:length(ctrl.locomotiveList)
               locomotive = ctrl.locomotiveList(i);
               if locomotive.stationID ~=-1 % Already arrive
                    continue;
               end
               nextStation = ctrl.stationList(locomotive.nextStationID + 1);
               % Predict v at t+dt
               if locomotive.v > locomotive.v_cruising
                   a = locomotive.a_decelerate;
               else
                   a = locomotive.a_braking;
               end
               v = locomotive.v -  a * ctrl.dt;
               x = locomotive.x + v * ctrl.dt + 0.5 * a * ctrl.dt^2;
               dis = nextStation.x - x;
               % If impossible to stop at station at t+dt, brake right now
               if v > locomotive.v_cruising % Check & send decelarate command
                   temptime1 = (v - locomotive.v_cruising)/abs(locomotive.a_decelerate);
                   temptime1 = ceil(temptime1/ctrl.dt)*ctrl.dt;
                   temptime2 = locomotive.v_cruising / abs(locomotive.a_braking);
                   temptime2 = ceil(temptime2/ctrl.dt)*ctrl.dt;
                   minDecelarateDis = 0.5 * abs(locomotive.a_braking) * temptime2^2 + locomotive.v_cruising * temptime1 + 0.5 * abs(locomotive.a_decelerate) * temptime1^2;
                    if dis < minDecelarateDis
                        locomotive.decelerate;
                    end
               else % Check & send brake command
                   temptime = v / abs(locomotive.a_braking);
                   temptime = ceil(temptime/ctrl.dt) * ctrl.dt;
                   minBrakingDis = 0.5 * abs(locomotive.a_braking) * temptime^2;
                    if dis < minBrakingDis
                        locomotive.brake;
                    end
               end
               
            end
        end
        function avoidCollision(ctrl)
            for i=1:length(ctrl.locomotiveList)
                locomotive = ctrl.locomotiveList(i);
                %position = ctrl.getPosition(locomotive);
                if locomotive.stationID ~= -1
                    continue;
                end
                nextStation = ctrl.stationList(locomotive.nextStationID + 1);
                nextStationDistance = nextStation.x - locomotive.x;
                if locomotive.nearestDistance <= nextStationDistance % Avoid collision
                    another = ctrl.locomotiveList(locomotive.nearestID);
                    if another.v >= locomotive.v
                        locomotive.accelerate; % Approach station as soon as possible
                    else
                        safeV = ctrl.calcSafeV(locomotive, another);
                        % safeV = safeV * (1 - ctrl.safeCoefficient);
                        locomotive.setTargetV(max(min(locomotive.v_max, safeV), another.v));
                        %fprintf('%s with safeV=%.5f\n', locomotive.name, safeV);
                    end
                else
                    locomotive.accelerate; % Approach station as soon as possible
                end
            end
        end
        function findNearest(ctrl)
            for i=1:length(ctrl.locomotiveList)
                locomotive = ctrl.locomotiveList(i);
                if locomotive.nearestID ~= -1
                    another = ctrl.locomotiveList(locomotive.nearestID);
                    if another.stationID ~= -1 && another.stationID ~= 6 && locomotive.nextStationID ~= another.stationID && locomotive.v_max < another.v_max && another.departureTime(another.stationID + 1) - ctrl.t <= locomotive.maxDelay
                        locomotive.nearestDistance = another.x - locomotive.x;
                        continue;
                    end
                end
                locomotive.nearestID = -1;
                locomotive.nearestDistance = 99999;
                for j=1:length(ctrl.locomotiveList) 
                    another = ctrl.locomotiveList(j);
                    % If a faster locomotive is going to departure ahead, consider it as an obstacle
                    if i == j || another.stationID == 6
                        continue;
                    end
                    if another.stationID ~= -1
                        if locomotive.nextStationID == another.stationID 
                            continue
                        end
                        anotherStation = ctrl.stationList(another.stationID + 1);
                        if anotherStation.rails(anotherStation.currentRail + 1) == 0 || strcmp(ctrl.stationList(another.stationID + 1).mode, 'Auto')
                            if locomotive.v_max >= another.v_max
                                continue;
                            end
                            departureTime = another.departureTime(another.stationID + 1);
                            temptime = (another.x - locomotive.x) / locomotive.v_max;
                            if departureTime - ctrl.t < temptime
                                continue;
                            end
                        end
                    end
                    dis = another.x - locomotive.x;
                    if dis <=0 || dis > locomotive.nearestDistance
                        continue;
                    end
                    locomotive.nearestDistance = dis;
                    locomotive.nearestID = j;
                end
            end
        end
        function switchRails(ctrl)
            locomotives = ctrl.locomotiveList;
            for i=1 : 6
                station = ctrl.stationList(i + 1);
                nearestID = 0;
                nearestDistance = 99999;
                for j = 1 : length(locomotives)
                     locomotive = locomotives(j);
                     if ceil(ctrl.getPosition(locomotive)) ~= i || strcmp(locomotive.status,'Stopped') 
                         continue;
                     end
                     distance = station.x - locomotive.x;
                     if distance < nearestDistance
                         nearestDistance = distance;
                         nearestID = j;
                     end
                end
                if nearestID ~= 0
                    locomotive = locomotives(nearestID);
                    if locomotive.nextStationID == i
                        station.switchToEmptyRail;
                    else
                        station.switchToRail(0);
                    end
                    if nearestDistance <= 0.5 * abs(locomotive.a_braking) * 1.5^2
                        continue;
                    end
                end
                earliestDepartureTime = 9999;
                targetRail = -1;
                for j = 0: station.numRails
                    if station.rails(j + 1) ~= 0 
                        locomotive = locomotives(station.rails(j + 1));
                        if locomotive.departureTime(i+1) == -1 % in manual control
                             continue;
                        end
                        departureTime = locomotive.departureTime(i + 1);
                        if departureTime <= earliestDepartureTime && ctrl.t >= departureTime - 1 && ctrl.t <= departureTime
                            targetRail = j;
                            earliestDepartureTime = departureTime;
                        end
                    end
                end
                % Check for appropriate departure time delay
                if targetRail ~= -1
                    locomotive =  locomotives(station.rails(targetRail + 1));
                    for j = 0 : station.numRails
                        if j ~= targetRail && station.rails(j + 1) ~= 0 
                            another = locomotives(station.rails(j + 1));
                            if another.departureTime(i+1) == -1 % another in manual control
                                continue;
                            end
                            if ((another.v_max > locomotive.v_max && another.departureTime(i+1) - locomotive.departureTime(i+1) <= 5)  || (another.v_max == locomotive.v_max && locomotive.getFlexibleDegree > max(another.departureTime(i + 1) - locomotive.departureTime(i + 1), another.getFlexibleDegree))) %&& another.departureTime(i + 1) <= locomotive.scheduleDeparture(i + 1) + locomotive.maxDelay / 2
                                if another.departureTime(i + 1) > another.scheduleDeparture(i + 1)
                                    another.departureTime(i + 1) = max(locomotive.departureTime(i + 1), another.scheduleDeparture(i + 1));
                                end
                                locomotive.departureTime(i + 1) = another.departureTime(i + 1) + 1;
                                targetRail = j;
                            end
                        end
                    end
                    station.switchToRail(targetRail);
                end
            end
        end
        function res = checkManualFault(ctrl)
            res = 0;
            locomotives = ctrl.locomotiveList;
            stations = ctrl.stationList;
            for i = 1:length(locomotives)
                locomotive = locomotives(i);
                if locomotive.x > stations(7).x
                    ctrl.app.displayWarning('OUT OF RAIL!');
                    res = 1;
                    continue;
                end
                if locomotive.stationID == 6
                    continue;
                end
                nextStation = stations(locomotive.nextStationID + 1);
                nextStationDistance = nextStation.x - locomotive.x;
                % Set temporaty next station if miss manually
                if nextStationDistance < 0
                    ctrl.app.displayWarning([locomotive.name ' MISS ' nextStation.name '!']);
                end
                while locomotive.x > nextStation.x 
                      locomotive.nextStationID = locomotive.nextStationID + 1;
                      nextStation = ctrl.stationList(locomotive.nextStationID + 1);
                end
                if locomotive.nearestID ~= -1
                   another = locomotives(locomotive.nearestID);
                   if locomotive.stationID == -1 && locomotive.x_pre >= another.x_pre
                       ctrl.app.displayWarning([locomotive.name '&' another.name ' COLLISION!']);
                       res = 1;
                       continue;
                   end
                end
            end
            if res
                stop(ctrl.timer);
                ctrl.app.DisplayButton.Enable = 0;
            end
        end
        % Automated Control function
        function update(ctrl,~,~)
            % Update parameters
            ctrl.updateLocomotives;
            % Update status
            ctrl.switchStatus;
            if ctrl.checkManualFault
                return;
            end
            ctrl.handleArrival;
            % Auto switch station rails
            ctrl.findNearest;
            ctrl.switchRails;
            if ctrl.checkManualFault
                return;
            end
            % Auto send targetV commands 
            ctrl.avoidCollision;
            ctrl.checkArrival;
            ctrl.checkDeparture;
            % Auto Switch status and change acceleration by targetV
            ctrl.switchStatus;
            % Load user interface
            if round(ctrl.t) == ctrl.t
                ctrl.app.loadUI;
            end
            ctrl.t = ctrl.t + ctrl.dt;
        end
    end
end

