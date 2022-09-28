classdef Locomotive < handle
    properties
        controller
        id
        name
        scheduleArrival
        scheduleDeparture
        maxDelay
        v_cruising
        v_max
        a_start % 0~v_cruising
        a_accelerate % 0~v_max
        a_braking % v_cruising~0
        a_decelerate % v_max~v_cruising
        distance_mustDecelerate
        arrivalTime
        departureTime
        x
        x_pre
        v
        a
        targetV
        mode % 'Auto'/'Manual'
        status % 'Stopped'/'Starting'/'Accelerating'/'Decelerating'/'Cruising'/'Max Speed'/'Braking'/'Constant'
        stationID
        nextStationID
        nearestID
        nearestDistance
        
    end
    
    methods
        function obj = Locomotive(id, name, scheduleArrival, scheduleDeparture)
            obj.id = id;
            obj.name = name;
            obj.arrivalTime = [-1 -1 -1 -1 -1 -1 -1 -1];
            obj.scheduleArrival = scheduleArrival;
            obj.scheduleDeparture = scheduleDeparture;
            obj.departureTime = scheduleDeparture;
            obj.stationID = 0;
            obj.nextStationID = 1;
            obj.nearestID = -1;
            obj.nearestDistance = 9999;
            while (obj.scheduleArrival(obj.nextStationID + 1) == -1)
                obj.nextStationID = obj.nextStationID + 1;
            end
            obj.status = 'Stopped';
            obj.mode = 'Auto';
            obj.targetV = 0;
            obj.x = 0;
            obj.x_pre = 0;
            obj.v = 0;
            obj.a = 0;
            switch name(1)
                case 'K'
                    obj.maxDelay = 30;
                    obj.v_cruising = 100;
                    obj.v_max = 120;
                    obj.a_start = 20;
                    obj.a_accelerate = 10;
                    obj.a_braking = -50;
                    obj.a_decelerate = -20;
                case 'D'
                    obj.maxDelay = 20;
                    obj.v_cruising = 200;
                    obj.v_max = 250;
                    obj.a_start = 50;
                    obj.a_accelerate = 25;
                    obj.a_braking = -100;
                    obj.a_decelerate = -25;
                case 'G'
                    obj.maxDelay = 10;
                    obj.v_cruising = 300;
                    obj.v_max = 350;
                    obj.a_start = 60;
                    obj.a_accelerate = 25;
                    obj.a_braking = -100;
                    obj.a_decelerate = -25;
            end
            
        end
        function obj = reset(obj)
            obj.arrivalTime = [-1 -1 -1 -1 -1 -1 -1 -1];
            obj.departureTime = obj.scheduleDeparture;
            obj.stationID = 0;
            obj.nextStationID = 1;
            obj.nearestID = -1;
            obj.nearestDistance = 9999;
            while (obj.scheduleArrival(obj.nextStationID + 1) == -1)
                obj.nextStationID = obj.nextStationID + 1;
            end
            obj.status = 'Stopped';
            obj.mode = 'Auto';
            obj.targetV = 0;
            obj.x = 0;
            obj.x_pre = 0;
            obj.v = 0;
            obj.a = 0;
        end
        function deg = getFlexibleDegree(obj) % Calculate realtime flexible degree of the locomotive
            stations = obj.controller.getStations;
            distance = stations(obj.nextStationID + 1).x - obj.x;
            brakingDistance = (obj.v_max^2 - obj.v_cruising^2) / (2 * abs(obj.a_decelerate)) + obj.v_cruising^2 / (2 * abs(obj.a_braking));
            if distance <= brakingDistance % Going to arrive, lowest flexible degree
                deg = -9999;
                return;
            end
            temptime = (obj.v_max - obj.v_cruising) / abs(obj.a_decelerate) + obj.v_cruising / abs(obj.a_braking);
            distance = distance - brakingDistance;
            if obj.v >= obj.v_cruising
                temptime = temptime + (obj.v_max - obj.v) / obj.a_accelerate;
                temptime = temptime + (distance - (obj.v_max^2 - obj.v^2) / (2 * obj.a_accelerate) ) / obj.v_max;
            else
                temptime = temptime + (obj.v_cruising - obj.v) / obj.a_start + (obj.v_max - obj.v_cruising) / obj.a_accelerate;
                temptime = temptime +  (distance - (obj.v_cruising^2 - obj.v^2) / (2 * obj.a_accelerate)-(obj.v_max^2 - obj.v_cruising^2) / (2 * obj.a_start) ) / obj.v_max;
            end
            temptime = ceil(temptime/obj.controller.dt) * obj.controller.dt;
            deg = obj.scheduleArrival(obj.nextStationID + 1) - obj.controller.t - temptime; 
            if obj.name(1) == 'K' && deg > 0
                deg = deg * obj.v_cruising / obj.v_max;
            end
        end
        
        % Command function
        function obj = accelerate(obj)
            obj.setTargetV(obj.v_max);
        end
        function obj = decelerate(obj)
            if obj.v > obj.v_cruising
                 obj.setTargetV(obj.v_cruising);
            else
                obj.setTargetV(obj.v /2);
            end
        end
        function obj = brake(obj)
             obj.setTargetV(0);
        end
        function obj = start(obj)
            obj.setTargetV(obj.v_max);
            obj.status = 'Starting';
        end
        function obj = move(obj)
            dt = obj.controller.dt;
            v0 = obj.v;
            obj.v = obj.v + obj.a * dt;
            if obj.v < 0
                obj.v = 0;
            end
            if obj.v > obj.v_max
                obj.v = obj.v_max;
            end
            obj.x_pre = obj.x;
            obj.x = obj.x_pre + 0.5 * (v0 + obj.v) * dt;
        end
        function obj = setTargetV(obj, targetV)
            if strcmp(obj.mode, 'Auto')
                obj.targetV = targetV;
            end
        end
        function obj = setMode(obj, mode)
            obj.mode = mode;
        end
        % Auto control function
        function obj = switchStatus(obj) % Auto status switch
            if abs(obj.v - obj.targetV) < (obj.controller.dt * abs(obj.a) / 2 + 0.01)  % Fix floating point number precision
                switch obj.targetV
                    case 0
                        obj.status = 'Stopped';
                    case obj.v_cruising
                        obj.status = 'Cruising';
                    case obj.v_max
                        obj.status = 'Max Speed';
                    otherwise
                        obj.status = 'Constant';
                end
                obj.v = obj.targetV;
                obj.a = 0;
            elseif obj.targetV > obj.v
                if obj.v >= obj.v_cruising
                    obj.a = obj.a_accelerate;
                    obj.status = 'Accelerating';
                else
                    obj.a = obj.a_start;
                    obj.status = 'Starting';
                end
            else % obj.targetV < obj.v
                if obj.v > obj.v_cruising
                    obj.a = obj.a_decelerate;
                    obj.status = 'Decelerating';
                else
                    obj.a = obj.a_braking;
                    obj.status = 'Braking';
                end
            end
        end
    end
end

