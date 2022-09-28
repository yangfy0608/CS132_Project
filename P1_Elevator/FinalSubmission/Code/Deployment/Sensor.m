classdef Sensor
    %SENSOR 此处显示有关此类的摘要
    %   此处显示详细说明
    
    properties
        doorState
        elevatorMoving
    end
    
    methods
        function obj = Sensor()
            %SENSOR 构造此类的实例
            %   此处显示详细说明
            obj.doorState = 0;%door is closed
        end
    end
end

