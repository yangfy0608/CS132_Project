classdef Station < handle
    
    properties
        controller
        id
        name
        x
        numRails 
        currentRail % 0~numRails
        rails %1..numRails+1
        mode % 'Auto'/'Manual'
    end
    
    methods
        function obj = Station(id, name, x, numRails)
            obj.id = id;
            obj.name = name;
            obj.x = x;
            obj.currentRail = 0;
            obj.numRails = numRails;
            obj.rails = zeros(1, numRails+1);
            obj.mode = 'Auto';
        end
        function obj = clear(obj)
            obj.currentRail = 0;
            obj.mode = 'Auto';
            if obj.id == 0
                obj.numRails = 0;
                obj.rails = 0; 
            elseif obj.id == 6
                obj.numRails = 0;
                obj.rails = 0;
            else
                obj.rails = zeros(1, obj.numRails+1);
            end
        end
        function obj = reset(obj)
            obj.currentRail = 0;
            obj.mode = 'Auto';
            if obj.id == 0
                obj.numRails = length(obj.controller.locomotiveList);
                obj.rails = 0:obj.numRails;
            else
                obj.rails = zeros(1, obj.numRails+1);
            end
        end
        function obj = setMode(obj, mode)
            obj.mode = mode;
        end
        function obj = switchToRail(obj, targetRail)
            if strcmp(obj.mode, 'Auto')
                obj.currentRail = targetRail;
            end
        end
        function rail = switchToEmptyRail(obj)
            rail = 0;
            for i = 1 : obj.numRails
                if obj.rails(i+1) == 0
                    rail = i;
                    break;
                end
            end
            obj.switchToRail(rail);
        end
        function handleArrival(obj, locomotive)
            obj.rails(obj.currentRail+1) = locomotive.id;
            locomotive.x = obj.x; % Fix floating point number precision
            locomotive.v = 0;
            locomotive.a = 0;
            locomotive.status = 'Stopped';
            locomotive.stationID = obj.id;
            locomotive.arrivalTime(obj.id+1) = obj.controller.t;
        end
        
        function checkDeparture(obj)
            %stations = obj.controller.getStations;
            locomotives = obj.controller.getLocomotives;
            for i = 0 : obj.numRails
                if obj.rails(i+1)
                    locomotive = locomotives(obj.rails(i+1));
                    if locomotive.departureTime(obj.id+1) == -1 % another in manual control
                         continue;
                    end
                    if obj.id == 0 && obj.controller.t >= locomotive.departureTime(1)
                        locomotive.start;
                        locomotive.stationID = -1;
                        obj.numRails = obj.numRails - 1;
                        for j = i : obj.numRails
                            obj.rails(j+1) = obj.rails(j+2);
                        end
                        break;
                    end
                    if obj.controller.t > locomotive.departureTime(obj.id + 1)
                        locomotive.departureTime(obj.id + 1) = obj.controller.t + 1;
                    end
                    if  obj.controller.t >= locomotive.departureTime(obj.id + 1)
                        % Check for appropriate departure time delay
                        nearestID = 0;
                        nearestDistance = 99999;
                        for j = 1 : length(locomotives)
                            another = locomotives(j);
                            if locomotive.id ~= j && obj.controller.getPosition(another) < obj.id 
                                distance = obj.x - another.x;
                                if distance < nearestDistance
                                    nearestDistance = distance;
                                    nearestID = j;
                                end
                            end
                        end
                        if nearestID ~= 0 
                            another = locomotives(nearestID);
                            if another.nextStationID > obj.id && another.v_max > locomotive.v_max
                                delay = ceil(nearestDistance / another.v);
                                fprintf('%s of flexdeg %.5f faces potential delay %.5f\n', locomotive.name, locomotive.getFlexibleDegree, delay);
                                if delay <= max(locomotive.getFlexibleDegree+locomotive.maxDelay*0.1, min(10, locomotive.maxDelay*0.5))
                                    locomotive.departureTime(obj.id + 1) = locomotive.departureTime(obj.id + 1) + delay;
                                    obj.switchToRail(0);
                                end
                            end
                        end
                        % Departure as scheduled
                        if obj.controller.t >= locomotive.departureTime(obj.id + 1) && obj.currentRail == i
                            locomotive.start;
                            locomotive.stationID = -1;
                            obj.rails(i+1) = 0;
                        end
                    end
                end
            end
        end
    end
end

