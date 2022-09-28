classdef VenderController < handle
    
    properties
        userApp
        maintainerApp
        moneyBox
        merchandiseDB
        payment
    end
    
    methods
        % Payment function
        function createPayment(ctrl, merchandise)
            ctrl.payment = Payment(ctrl);
            ctrl.payment.name = merchandise.name;
            ctrl.payment.price = merchandise.price;
        end
        function cancelPayment(ctrl)
            if isempty(ctrl.payment)
                return;
            end
            if strcmp(ctrl.payment.status, 'Created')
                ctrl.payment.cancelPayment;
            end
        end
        function addPaymentRecord(ctrl)
            date = ctrl.payment.createdTime;
            merchandise = ctrl.payment.name;
            price = sprintf('%.1f',ctrl.payment.price);
            status = ctrl.payment.status;
            tempdata = ctrl.maintainerApp.OrderRecordTable.Data;
            tempdata = [{date, merchandise, price, status}; tempdata];
            ctrl.maintainerApp.OrderRecordTable.Data = tempdata;
        end
        % Merchandise function
        function addMerchandise(ctrl, merchandise)
            if isempty(merchandise)
                return;
            end
            ctrl.merchandiseDB.addMerchandise(merchandise);
            ctrl.userApp.LoadMerchandise;
            ctrl.maintainerApp.LoadMerchandise;
        end
        function updateMerchandise(ctrl, merchandise, price, quantity)
            ctrl.merchandiseDB.updateMerchandise(merchandise, price, quantity);
            ctrl.userApp.LoadMerchandise;
            ctrl.maintainerApp.LoadMerchandise;
        end
        function sellMerchandise(ctrl, merchandise)
            ctrl.merchandiseDB.sellMerchandise(merchandise);
            ctrl.userApp.LoadMerchandise;
            ctrl.maintainerApp.LoadMerchandise;
        end
        % Money function
        function updateCoins(ctrl, coins)
            ctrl.moneyBox.updateCoins(coins);
            ctrl.maintainerApp.LoadMoney;
        end
        function res=addCoins(ctrl, coins)
            tempcoins = ctrl.moneyBox.getCoins;
            tempcoins = tempcoins + coins;
            for i=1:length(tempcoins)
                if tempcoins(i) > ctrl.moneyBox.coinCapacity
                    res = 0;
                    return;
                end
            end
            res = 1;
            ctrl.updateCoins(tempcoins);
        end
        function updateCash(ctrl, cash)
            ctrl.moneyBox.updateCash(cash);
            ctrl.maintainerApp.LoadMoney;
        end
        function res=addCash(ctrl, cash)
            tempcash = ctrl.moneyBox.getCash;
            tempcash = tempcash + cash;
            for i=1:length(tempcash)
                if tempcash(i) > ctrl.moneyBox.cashCapacity
                    res = 0;
                    return;
                end
            end
            res = 1;
            ctrl.updateCash(tempcash);
        end
        function money=getMoney(ctrl)
            money = [ctrl.moneyBox.getCoins ctrl.moneyBox.getCash];
        end
        function changeMoney=giveChange(ctrl, change)
            tempMoney = ctrl.getMoney;
            tempCoins = tempMoney(1:2);
            tempCash = tempMoney(3:6);
            while change >= 10 && tempCash(3) > 0
                change = change - 10;
                tempCash(3) = tempCash(3) - 1;
            end
            while change >= 5 && tempCash(2) > 0
                change = change - 5;
                tempCash(2) = tempCash(2) - 1;
            end
            while tempCoins(2) >= tempCash(1) && change >= 1 && tempCoins(2) > 0
                change = change - 1;
                tempCoins(2) = tempCoins(2) - 1;
            end
            while change >= 1 && tempCash(1) > 0
                change = change - 1;
                tempCash(1) = tempCash(1) - 1;
            end
            while change >= 0.5 && tempCoins(1) > 0
                change = change - 0.5;
                tempCoins(1) = tempCoins(1) - 1;
            end
            changeMoney = tempMoney - [tempCoins tempCash];
            if change > 0
                changeMoney = [];
            else
                ctrl.moneyBox.updateCoins(tempCoins);
                ctrl.moneyBox.updateCash(tempCash);
                ctrl.maintainerApp.LoadMoney;
            end
        end
    end
    
    
end