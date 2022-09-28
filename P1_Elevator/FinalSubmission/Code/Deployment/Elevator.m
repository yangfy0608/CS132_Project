classdef Elevator < handle
    %UNTITLED 此处显示有关此类的摘要
    %   此处显示详细说明
    
    properties
        controller
        id                          % left = 'L',right = 'R'
        y = 3;                      % y(B) = 0  
        floor
        nextTarget
        v
        a
        vdir                        % up = 1,down=-1,stop=0
        adir
        moveState                   % 'Stop' 'Start' 'Run'
        serviceState                % 'Standby' 'Up' 'Down'
        upService                   % (1) for B (2)for1F （3)for2F (4)For3F
        downService
        doorState                   % 'Closed' 'Closing' 'Opening' 'Opened'
        doorSize
        doortimer
    end
    
    properties(Constant)
        maxSpeed = 1;
        floorHeight=3;
        dt = 0.1;
    end
    
    methods
        function obj = Elevator(id)
            obj.id = id;
            obj.y = 3; % at 1F initially
            obj.v = 0;
            obj.vdir = 0;
            obj.adir = 0;
            obj.a = 0;
            obj.floor = 0;
            obj.nextTarget = -1;
            obj.moveState = 'Standby';
            obj.serviceState = 'Up';
            obj.upService = [false false false false];
            obj.downService = [false false false false];
            obj.doorState = 'Closed';
            obj.doorSize = 45;
            obj.doortimer = 0;
        end
        
        function move(obj)
            obj.y = obj.y + obj.vdir * obj.v * obj.dt;
            obj.v = obj.v + obj.adir * obj.a * obj.dt;
        end
        
        function update(obj)
            switch obj.moveState
                case 'Start'
                    obj.adir = obj.vdir;
                    obj.a = 0.5;
                    obj.adir = 1;
                case 'Stop'
                    obj.adir = -obj.vdir;
                    obj.a = 0.5;
                    obj.adir = -1;
                case 'Run'
                    obj.a = 0;
                    obj.v = 1;
                case 'Standby'
                    obj.a = 0;
                    obj.v = 0;
            end
        end
    end
end

