classdef MerchandiseDB < handle
    properties
        controller
    end
    properties(Access = private)
        merchandiseList
  
    end
    properties(Constant)
        merchandiseCapacity = 30;
    end
    methods
        % Init
        function obj=MerchandiseDB()
            obj.merchandiseList = [Merchandise('Coke', 3.5, 10) Merchandise('Fanta', 3, 10) Merchandise('Sprite', 3, 10) Merchandise('WangMilk', 5.5, 0)];
        end
        function list=retrieve(obj)
            list = obj.merchandiseList;
        end
        % Basic Function
        function addMerchandise(obj, name)
            merchandise = Merchandise(name, 5, 0);
            obj.merchandiseList = [obj.merchandiseList; merchandise];
        end
        function updateMerchandise(obj, name, price, quantity)
            for i=1:length(obj.merchandiseList)
                if strcmp(name, obj.merchandiseList(i).name)
                    obj.merchandiseList(i).price = price;
                    obj.merchandiseList(i).quantity = quantity;
                    break;
                end
            end
        end
        function sellMerchandise(obj, name)
            for i=1:length(obj.merchandiseList)
                if strcmp(name, obj.merchandiseList(i).name) && obj.merchandiseList(i).quantity > 0
                    obj.merchandiseList(i).quantity = obj.merchandiseList(i).quantity - 1;
                    break;
                end
            end
        end
        function merchandise=getMerchandise(obj, name)
            merchandise = [];
            for i=1:length(obj.merchandiseList)
                if strcmp(name, obj.merchandiseList(i).name)
                    merchandise = obj.merchandiseList(i);
                    break;
                end
            end
        end
        % Alert Message
        function msg=alertMessage(obj)
            msg = '';
            for i=1:length(obj.merchandiseList)
                if obj.merchandiseList(i).quantity == 0
                    msg = [sprintf('(++)Out of %s!', obj.merchandiseList(i).name) msg];
                else
                    if obj.merchandiseList(i).quantity/obj.merchandiseCapacity <= 0.1
                        msg = [sprintf('(+)Nearly out of %s!', obj.merchandiseList(i).name) msg];
                    end
                end
            end
        end
    end 
end