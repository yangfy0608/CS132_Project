classdef Payment < handle
    properties
        controller
        name
        price
        createdTime
        status
    end
    
    properties(Access = private)
        paidMoney
        timer
        restTime
    end
    
    methods
        % Init
        function obj = Payment(controller)
            obj.controller = controller;
            obj.status = 'Created';
            obj.paidMoney = 0;
            obj.createdTime = datestr(now,'YYYY-mm-dd HH:MM:SS');
            obj.restTime = 30;
            obj.timer = timer;
            obj.timer.TimerFcn=@obj.checkPayment;
            obj.timer.ExecutionMode='fixedRate';
            obj.timer.Period=1; 
            start(obj.timer);
        end
        % Delete and add payment record
        function delete(obj)
            obj.controller.addPaymentRecord;
            obj.controller.payment = [];
            delete(obj.timer);
        end
        function updatePaidMoney(obj, money)
            obj.paidMoney = obj.paidMoney + money;
            if obj.paidMoney >= obj.price
               stop(obj.timer);
               change = obj.paidMoney - obj.price;
               changeMoney = obj.controller.giveChange(change);
               % Not enough coins to give change
               if isempty(changeMoney)
                   obj.status = 'Out of Money';
                   obj.controller.userApp.displayFailedPayment;
               % Payment success
               else
                   obj.status = 'Success'; 
                   obj.controller.sellMerchandise(obj.name);
                   obj.controller.userApp.displaySuccessPayment(changeMoney);
               end
               delete(obj);
            end
        end
        function cancelPayment(obj)
            stop(obj.timer);
            obj.status = 'Canceled';
            delete(obj);
        end
        % Timer function for payment checking
        function checkPayment(obj, ~, ~)
            obj.restTime = obj.restTime - 1;
            % Time out
            if(obj.restTime == 0)
                obj.status = 'Time Out';
                stop(obj.timer);
                obj.controller.userApp.displayTimeOutPayment;
                delete(obj);
            % Display Rest Time
            else
                obj.controller.userApp.displayPaymentMessage(obj.restTime);
            end
        end
    end
    
end