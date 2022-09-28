classdef Merchandise < handle
    properties
        name
        price
        quantity
    end
    methods
        function obj=Merchandise(name, price, quantity)
            obj.name = name;
            obj.price = price;
            obj.quantity = quantity;
        end
    end
    
end