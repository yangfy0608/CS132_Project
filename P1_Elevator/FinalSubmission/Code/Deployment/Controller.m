classdef Controller < handle
    properties
        Lui;
        Rui;
        F1;
        F2;
        F3;
        FB;
        elevators; % L can go to B
        timer;
        Version;   % see the state
        upRequest;
        downRequest;
    end
    
    properties(Constant)
        floorHeight = 3;
        dt = 0.1;
        maxSpeed = 1;
    end
    
    methods
        function delete(obj)
            stop(obj.timer);
            delete(obj.Lui) ;
            delete(obj.Rui) ;
            delete(obj.F1) ;
            delete(obj.F2) ;
            delete(obj.F3) ;
            delete(obj.FB) ;
            delete(obj.Version);
            delete(obj.timer);
        end
        
        function obj = Controller()
            obj.Lui = LctrlUI;
            obj.Rui = RctrlUI;
            obj.F1 = F1UI;
            obj.F2 = F2UI;
            obj.F3 = F3UI;
            obj.FB = FBUI;
            obj.Lui.Ctrl = obj;
            obj.Rui.Ctrl = obj;
            obj.F1.Ctrl = obj;
            obj.F2.Ctrl = obj;
            obj.F3.Ctrl = obj;
            obj.FB.Ctrl = obj;
            obj.elevators = [Elevator('L'),Elevator('R')];
            obj.timer = timer;
            obj.Version = EleVersion;
            obj.Version.Ctrl = obj;
            obj.upRequest = [0 0 0 0];
            obj.downRequest = [0 0 0 0];
            obj.timer.TimerFcn=@obj.update;
            obj.timer.ExecutionMode='fixedRate';
            obj.timer.Period=obj.dt; 
            start(obj.timer);
        end
        
        function update(obj, ~, ~)
            if strcmp(obj.elevators(1).doorState,'Closed') && strcmp(obj.elevators(2).doorState,'Closed')
                obj.elevators(1).move;  % elevator move
                obj.elevators(2).move;
                obj.getRequest;         % get and go to service target floor
                obj.getNextTarget(obj.elevators(1));
                obj.getNextTarget(obj.elevators(2));
                obj.goNextTarget(obj.elevators(1));
                obj.goNextTarget(obj.elevators(2));
                obj.elevators(1).update;% elevator update
                obj.elevators(2).update;
            elseif strcmp(obj.elevators(1).doorState,'Closed')
                obj.elevators(1).move;
                obj.OpenDoor(obj.elevators(2));
                obj.CloseDoor(obj.elevators(2));
                obj.getRequest;         % get and go to service target floor
                obj.getNextTarget(obj.elevators(1));
                obj.goNextTarget(obj.elevators(1));
                obj.elevators(1).update;% elevator update
            elseif strcmp(obj.elevators(2).doorState,'Closed')
                obj.elevators(2).move;
                obj.OpenDoor(obj.elevators(1));
                obj.CloseDoor(obj.elevators(1));
                obj.getRequest;         % get and go to service target floor
                obj.getNextTarget(obj.elevators(2));
                obj.goNextTarget(obj.elevators(2));
                obj.elevators(2).update;% elevator update
            else
                obj.OpenDoor(obj.elevators(2));
                obj.CloseDoor(obj.elevators(2));
                obj.OpenDoor(obj.elevators(1));
                obj.CloseDoor(obj.elevators(1));
            end
            
            obj.LoadUI;             % update the ele and loadui
            obj.Version.LoadUI;
        end
        
        function getRequest(obj)                    % from uprequest to elevetor
            cur1 = obj.elevators(1).y/obj.floorHeight;
            cur2 = obj.elevators(2).y/obj.floorHeight;
            for i = 1:2
                if obj.upRequest(i+1)~=0
                    if cur1 < i && cur2 < i && strcmp(obj.elevators(1).serviceState,'Up') && strcmp(obj.elevators(2).serviceState,'Up')
                        if cur1 <=cur2
                            obj.elevators(2).upService(i+1) = true;
                            obj.upRequest(i+1) = false;
                            return;
                        else
                            obj.elevators(1).upService(i+1) = true;
                            obj.upRequest(i+1) = false;
                            return;
                        end
                    elseif cur1 < i && strcmp(obj.elevators(1).serviceState,'Up')
                        obj.elevators(1).upService(i+1) = true;
                        obj.upRequest(i+1) = false;
                        return;
                    elseif cur2 < i && strcmp(obj.elevators(2).serviceState,'Up')
                        obj.elevators(2).upService(i+1) = true;
                        obj.upRequest(i+1) = false;
                        return;
                    elseif sum(obj.elevators(2).upService)==0 && sum(obj.elevators(2).downService)==0 
                        obj.elevators(2).serviceState = 'Up';
                        obj.elevators(2).upService(i+1) = true;
                        obj.upRequest(i+1) = false;
                        return;
                    elseif sum(obj.elevators(1).upService)==0 && sum(obj.elevators(1).downService)==0 
                        obj.elevators(1).serviceState = 'Up';
                        obj.elevators(1).upService(i+1) = true;
                        obj.upRequest(i+1) = false;
                        return;
                    elseif strcmp(obj.elevators(2).serviceState,'Up')
                        obj.elevators(2).upService(i+1) = true;
                        obj.upRequest(i+1) = false;
                        return;
                    end
                end
            end
            for i = 2:-1:1
                if obj.downRequest(i+1)
                    if cur1 > i && cur2 > i && strcmp(obj.elevators(1).serviceState,'Down') && strcmp(obj.elevators(2).serviceState,'Down')
                        if cur1 >= cur2
                            obj.elevators(2).downService(i+1) = true;
                            obj.downRequest(i+1) = false;
                            return;
                        else
                            obj.elevators(1).downService(i+1) = true;
                            obj.downRequest(i+1) = false;
                            return;
                        end
                     elseif cur1 > i && strcmp(obj.elevators(1).serviceState,'Down')
                        obj.elevators(1).downService(i+1) = true;
                        obj.downRequest(i+1) = false;
                        return;
                    elseif cur2 > i && strcmp(obj.elevators(2).serviceState,'Down')
                        obj.elevators(2).downService(i+1) = true;
                        obj.downRequest(i+1) = false;
                        return;
                    elseif sum(obj.elevators(2).upService)==0 && sum(obj.elevators(2).downService)==0 
                        obj.elevators(2).serviceState = 'Down';
                        obj.elevators(2).downService(i+1) = true;
                        obj.downRequest(i+1) = false;
                        return;
                    elseif sum(obj.elevators(1).upService)==0 && sum(obj.elevators(1).downService)==0 
                        obj.elevators(1).serviceState = 'Down';
                        obj.elevators(1).downService(i+1) = true;
                        obj.downRequest(i+1) = false;
                        return;
                    elseif strcmp(obj.elevators(2).serviceState,'Down')
                        obj.elevators(2).downService(i+1) = true;
                        obj.downRequest(i+1) = false;
                        return;
                    end
                end
            end
            
        end 
        
        function getNextTarget(obj, elevator)       % how to control the ele
            currentFloor = elevator.y / obj.floorHeight;
            if elevator.v == 0
                
                if strcmp(elevator.serviceState, 'Up') || strcmp(elevator.serviceState, 'Standby')
                    for i = 0 : 3 
                        if elevator.upService(i + 1) && currentFloor < i
                            elevator.moveState = 'Start';
                            elevator.vdir = +1;
                            elevator.nextTarget = i;
                            return;
                        end
                    end
                    elevator.serviceState= 'Down';
                    target = -1;
                    for i = 3 :-1: 0 
                        if elevator.downService(i + 1) 
                            target = i;
                            break;
                        end
                    end
                    if target ~= -1
                        if currentFloor < target
                            elevator.vdir = +1;
                            elevator.moveState = 'Start';
                            elevator.nextTarget = target;
                        elseif currentFloor > target
                            elevator.vdir = -1;
                            elevator.moveState = 'Start';
                            elevator.nextTarget = target;
                        else
                            % Open
                        end
                    end
                elseif strcmp(elevator.serviceState, 'Down')
                    for i = 3 :-1: 0 
                        if elevator.downService(i + 1) && currentFloor > i
                            elevator.moveState = 'Start';
                            elevator.vdir = -1;
                            elevator.nextTarget = i;
                            return;
                        end
                    end
                    elevator.serviceState= 'Up';
                    target = -1;
                    for i = 0 : 3
                        if elevator.upService(i + 1) 
                            target = i;
                            break;
                        end
                    end
                    if target ~= -1
                        if currentFloor < target
                            elevator.vdir = +1;
                            elevator.moveState = 'Start';
                            elevator.nextTarget = target;
                        elseif currentFloor > target
                            elevator.vdir = -1;
                            elevator.moveState = 'Start';
                            elevator.nextTarget = target;
                        else
                            % Open
                        end
                    end
                end
                
            elseif elevator.v ~= 0
                if strcmp(elevator.serviceState, 'Up')
                    for i = 0 : 3
                        if elevator.upService(i + 1) && currentFloor < i
                            elevator.moveState = 'Start';
                            elevator.vdir = +1;
                            elevator.nextTarget = i;
                            return;
                        end
                    end
                elseif strcmp(elevator.serviceState, 'Down')
                    for i = 3 :-1: 0 
                        if elevator.downService(i + 1) && currentFloor > i
                            elevator.moveState = 'Start';
                            elevator.vdir = -1;
                            elevator.nextTarget = i;
                            return;
                        end
                    end
                end
            end
        end 
        
        function goNextTarget(obj, elevator)        % how to start and stop
            if elevator.v > 0 && (abs(elevator.nextTarget*3-elevator.y) <= elevator.v*elevator.v)
                elevator.moveState = 'Stop';
                if abs(elevator.nextTarget*3-elevator.y) <= 0.01
                    if strcmp(elevator.serviceState, 'Down')
                        elevator.downService(elevator.nextTarget+1) = false;
                        obj.downRequest(elevator.nextTarget+1) = false;
                    end
                    if strcmp(elevator.serviceState, 'Up')
                        elevator.upService(elevator.nextTarget+1) = false;
                        obj.upRequest(elevator.nextTarget+1) = false;
                    end
                    switch elevator.nextTarget
                        case 0
                            obj.FB.Up.BackgroundColor = [0.96,0.96,0.96];
                        case 3
                            obj.F3.Down.BackgroundColor = [0.96,0.96,0.96];
                            if strcmp(elevator.id, 'L')
                                obj.F3.B.BackgroundColor = [0.96,0.96,0.96];
                            end
                        case 1
                            if strcmp(elevator.serviceState, 'Up')
                                obj.F1.Up.BackgroundColor = [0.96,0.96,0.96];
                            elseif strcmp(elevator.id, 'L')
                                obj.F1.B.BackgroundColor = [0.96,0.96,0.96];
                            end
                        case 2
                            if strcmp(elevator.serviceState, 'Up')
                                obj.F2.Up.BackgroundColor = [0.96,0.96,0.96];
                            else
                                obj.F2.Down.BackgroundColor = [0.96,0.96,0.96];
                                if strcmp(elevator.id, 'L')
                                    obj.F2.B.BackgroundColor = [0.96,0.96,0.96];
                                end
                            end
                    end
                    obj.lightPowerOff(elevator.id,elevator.nextTarget);
                    elevator.y = elevator.nextTarget*3;
                    elevator.moveState = 'Standby';
                    elevator.update;
                    obj.LoadUI;
                    obj.Version.LoadUI;
                    obj.getNextTarget(elevator);
                    elevator.doorState = 'Opening';
                end
            elseif elevator.v >= 1
                elevator.moveState = 'Run';
            end
        end
               
        function BRequest(obj,floor)                % B Button pushed
            currentFloor = obj.elevators(1).y / obj.floorHeight;
            if currentFloor ~= floor
                obj.elevators(1).downService(floor+1) = true;
            else
                obj.FloorLightoff(floor,0);
            end
        end
        
        function addFloorRequest(obj,requestFloor,state)% state = 1 means up,-1 means down
            if obj.elevators(1).y/obj.floorHeight == requestFloor || obj.elevators(2).y/obj.floorHeight == requestFloor
                if strcmp(obj.elevators(1).serviceState,'Up') && state == 1 && obj.elevators(1).y/obj.floorHeight == requestFloor
                    obj.FloorLightoff(requestFloor,1);
                    obj.elevators(1).doorState = 'Opening';
                    return;
                elseif strcmp(obj.elevators(2).serviceState,'Up') && state == 1 && obj.elevators(2).y/obj.floorHeight == requestFloor
                    obj.FloorLightoff(requestFloor,1);
                    obj.elevators(2).doorState = 'Opening';
                    return;
                elseif strcmp(obj.elevators(1).serviceState,'Down') && state == -1 && obj.elevators(1).y/obj.floorHeight == requestFloor
                    obj.FloorLightoff(requestFloor,-1);
                    obj.elevators(1).doorState = 'Opening';
                    return;
                elseif strcmp(obj.elevators(2).serviceState,'Down') && state == -1 && obj.elevators(2).y/obj.floorHeight == requestFloor
                    obj.FloorLightoff(requestFloor,-1);
                    obj.elevators(2).doorState = 'Opening';
                    return;
                elseif strcmp(obj.elevators(1).serviceState,'Up') && state == -1 && obj.elevators(1).y/obj.floorHeight == requestFloor
                    if obj.elevators(1).nextTarget == -1
                        obj.elevators(1).serviceState = 'Down';
                        obj.FloorLightoff(requestFloor,-1);
                        obj.elevators(1).doorState = 'Opening';
                        return;
                    elseif obj.elevators(2).nextTarget == -1
                        obj.elevators(2).downService(requestFloor+1) = true;
                        return;
                    end
                elseif strcmp(obj.elevators(2).serviceState,'Up') && state == -1 && obj.elevators(2).y/obj.floorHeight == requestFloor
                    if obj.elevators(2).nextTarget == -1
                        obj.elevators(2).serviceState = 'Down';
                        obj.FloorLightoff(requestFloor,-1);
                        obj.elevators(2).doorState = 'Opening';
                        return;
                    elseif obj.elevators(1).nextTarget == -1
                        obj.elevators(1).downService(requestFloor+1) = true;
                        return;
                    end
                elseif strcmp(obj.elevators(1).serviceState,'Down') && state == 1 && obj.elevators(1).y/obj.floorHeight == requestFloor
                    if obj.elevators(1).nextTarget == -1
                        obj.elevators(1).serviceState = 'Up';
                        obj.FloorLightoff(requestFloor,1);
                        obj.elevators(1).doorState = 'Opening';
                        return;
                    elseif obj.elevators(2).nextTarget == -1
                        obj.elevators(2).upService(requestFloor+1) = true;
                        return;
                    end
                elseif strcmp(obj.elevators(2).serviceState,'Down') && state == 1 && obj.elevators(2).y/obj.floorHeight == requestFloor
                    if obj.elevators(2).nextTarget == -1
                        obj.elevators(2).serviceState = 'Up';
                        obj.FloorLightoff(requestFloor,1);
                        obj.elevators(2).doorState = 'Opening';
                        return;
                    elseif obj.elevators(1).nextTarget == -1
                        obj.elevators(1).upService(requestFloor+1) = true;
                        return;
                    end
                end
            end
            if requestFloor == 0
                obj.elevators(1).upService(1)=true;
                return;
            end
            if requestFloor == 3
                if obj.elevators(1).vdir >= 0 && obj.elevators(2).vdir >= 0
                    if obj.elevators(1).y<=obj.elevators(2).y
                        obj.elevators(2).downService(4) = true;
                        return;
                    else
                        obj.elevators(1).downService(4) = true;
                        return;
                    end
                elseif obj.elevators(1).vdir >= 0
                    obj.elevators(1).downService(4) = true;
                    return;
                elseif obj.elevators(2).vdir >= 0
                    obj.elevators(2).downService(4) = true;
                    return;
                else
                    if obj.elevators(1).y<=obj.elevators(2).y
                        obj.elevators(2).downService(4) = true;
                        return;
                    else
                        obj.elevators(1).downService(4) = true;
                        return;
                    end
                end
            end
            
   
            switch state
                case 1
                    obj.upRequest(requestFloor+1) = true;
                case -1
                    obj.downRequest(requestFloor+1) = true;
            end
        end
        
        function lightPowerOff(obj,id,floor)        % turn the ele light off
            if strcmp(id,'L')
                switch floor
                    case 0
                        obj.Lui.L_B.BackgroundColor = [0.96,0.96,0.96];
                    case 1
                        obj.Lui.L_1.BackgroundColor = [0.96,0.96,0.96];
                    case 2
                        obj.Lui.L_2.BackgroundColor = [0.96,0.96,0.96];
                    case 3
                        obj.Lui.L_3.BackgroundColor = [0.96,0.96,0.96];
                end
            elseif strcmp(id,'R')
                switch floor
                    case 1
                        obj.Rui.R_1.BackgroundColor = [0.96,0.96,0.96];
                    case 2
                        obj.Rui.R_2.BackgroundColor = [0.96,0.96,0.96];
                    case 3
                        obj.Rui.R_3.BackgroundColor = [0.96,0.96,0.96];
                end
            end
        end
        
        function FloorLightoff(obj,floor,state)     % turn the floor light off
            switch floor
                case 0
                    obj.FB.Up.BackgroundColor = [0.96,0.96,0.96];
                case 1
                    if state == 1
                        obj.F1.Up.BackgroundColor = [0.96,0.96,0.96];
                    elseif state == 0
                        obj.F1.B.BackgroundColor = [0.96,0.96,0.96];
                    end
               case 2
                    if state == 1
                        obj.F2.Up.BackgroundColor = [0.96,0.96,0.96];
                    elseif state == 0
                        obj.F2.B.BackgroundColor = [0.96,0.96,0.96];
                    elseif state == -1
                        obj.F2.Down.BackgroundColor = [0.96,0.96,0.96];
                    end
               case 3
                    if state == 0
                        obj.F3.B.BackgroundColor = [0.96,0.96,0.96];
                    elseif state == -1
                        obj.F3.Down.BackgroundColor = [0.96,0.96,0.96];
                    end
            end
        end
        
        function addElevatorRequest(obj, requestElevator, requestFloor) %requestElevator 1-L 2-R
            elevator = obj.elevators(requestElevator);
            if  requestFloor * obj.floorHeight == elevator.y
                obj.lightPowerOff( elevator.id,requestFloor );
                return;
            end
            if  requestFloor * obj.floorHeight > elevator.y
                elevator.upService(requestFloor+1) = true;
            elseif requestFloor * obj.floorHeight < elevator.y
                elevator.downService(requestFloor+1) = true;              
            end
        end
        
        
        function OpenDoor(~,x) % open the door
            if x.doortimer == 20
                x.doorState = 'Closing';
                return;
            end
            if x.v == 0 && x.doorSize > 0 && strcmp(x.doorState, 'Opening')
                x.doorSize = x.doorSize - 1;
                x.moveState = 'Standby';
                x.update();
            end
            if x.v == 0 && x.doorSize == 0
                x.doorState = 'Opened';
                x.doortimer = x.doortimer + 1;
            end
        end 
        
        function CloseDoor(~,x) % close the door
            if x.v == 0 && x.doorSize < 45 && strcmp(x.doorState, 'Closing')
                x.doorSize = x.doorSize + 1;
            end
            if x.doorSize == 45
                x.doorState = 'Closed';
                x.doortimer = 0;
            end
        end
        
        function LoadUI(obj)
            if obj.elevators(1).v == 0 
                obj.FB.State.Value ='Standby';
                obj.F1.L_State.Value ='Standby';
                obj.F2.L_State.Value ='Standby';
                obj.F3.L_State.Value ='Standby';
                obj.Lui.State.Value = 'Standby';
            elseif obj.elevators(1).vdir > 0 
                obj.FB.State.Value ='Up';
                obj.F1.L_State.Value ='Up';
                obj.F2.L_State.Value ='Up';
                obj.F3.L_State.Value ='Up';
                obj.Lui.State.Value = 'Up';
            elseif obj.elevators(1).vdir < 0
                obj.FB.State.Value ='Down';
                obj.F1.L_State.Value ='Down';
                obj.F2.L_State.Value ='Down';
                obj.F3.L_State.Value ='Down';
                obj.Lui.State.Value = 'Down';
            end
            if obj.elevators(2).v == 0 
                obj.Rui.State.Value = 'Standby';
                obj.F1.R_State.Value ='Standby';
                obj.F2.R_State.Value ='Standby';
                obj.F3.R_State.Value ='Standby';
            elseif obj.elevators(2).vdir > 0 
                obj.Rui.State.Value = 'Up';
                obj.F1.R_State.Value ='Up';
                obj.F2.R_State.Value ='Up';
                obj.F3.R_State.Value ='Up';
            elseif obj.elevators(2).vdir < 0
                obj.Rui.State.Value = 'Down';
                obj.F1.R_State.Value ='Down';
                obj.F2.R_State.Value ='Down';
                obj.F3.R_State.Value ='Down';
            end
            if obj.elevators(1).y>=0 && obj.elevators(1).y < 1.5
                obj.F3.LD.Value ='B';
                obj.F2.LD.Value ='B';
                obj.F1.LD.Value ='B';
                obj.FB.LD.Value ='B';
                obj.Lui.LeftDisplayer.Value = 'B';
            elseif obj.elevators(1).y>= 1.5 && obj.elevators(1).y < 4.5
                obj.F3.LD.Value ='1';
                obj.F2.LD.Value ='1';
                obj.F1.LD.Value ='1';
                obj.FB.LD.Value ='1';
                obj.Lui.LeftDisplayer.Value = '1';
            elseif obj.elevators(1).y>= 4.5 && obj.elevators(1).y < 7.5
                obj.F3.LD.Value ='2';
                obj.F2.LD.Value ='2';
                obj.F1.LD.Value ='2';
                obj.FB.LD.Value ='2';
                obj.Lui.LeftDisplayer.Value = '2';
            elseif obj.elevators(1).y>=7.5 && obj.elevators(1).y <=9
                obj.F3.LD.Value ='3';
                obj.F2.LD.Value ='3';
                obj.F1.LD.Value ='3';
                obj.FB.LD.Value ='3';
                obj.Lui.LeftDisplayer.Value = '3';
            end
            if obj.elevators(2).y>= 3 && obj.elevators(2).y < 4.5
                obj.F3.RD.Value ='1';
                obj.F2.RD.Value ='1';
                obj.F1.RD.Value ='1';
                obj.Rui.RightDisplayer.Value = '1';
            elseif obj.elevators(2).y>= 4.5 && obj.elevators(2).y < 7.5
                obj.F3.RD.Value ='2';
                obj.F2.RD.Value ='2';
                obj.F1.RD.Value ='2';
                obj.Rui.RightDisplayer.Value = '2';
            elseif obj.elevators(2).y>=7.5 && obj.elevators(2).y <=9
                obj.F3.RD.Value ='3';
                obj.F2.RD.Value ='3';
                obj.F1.RD.Value ='3';
                obj.Rui.RightDisplayer.Value = '3';
            end
        end      % update the version
    end
end

