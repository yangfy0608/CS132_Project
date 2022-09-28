classdef MoneyBox < handle
    properties
        controller
    end
    properties(Access = private)
        coins = [50 50]; % [￥0.5, ￥1]
        cash = [30 30 30 0]; % [￥1, ￥5, ￥10, ￥20]
    end
    properties (Constant)
        coinCapacity = 80;
        cashCapacity = 60;
    end
    % Basic Function
    methods
        function updateCoins(obj, coins) 
            obj.coins = coins;
        end
        function coins=getCoins(obj)
            coins = obj.coins;
        end
        function updateCash(obj, cash) 
            obj.cash = cash;
        end
        function cash=getCash(obj)
            cash = obj.cash;
        end
        % Alert Message
        function msg=alertMessage(obj)
            msg = '';
            if obj.coins(1)/obj.coinCapacity >= 0.8
                msg = [msg '(-)￥0.5 Coin nearly FULL!'];
            end
            if obj.coins(1)/obj.coinCapacity < 0.2
                msg = [msg '(+)Nearly out of ￥0.5 Coin!'];
            end
            if obj.coins(2)/obj.coinCapacity >= 0.8
                msg = [msg '(-)￥1 Coin nearly FULL!'];
            end
            if obj.coins(2)/obj.coinCapacity < 0.15
                msg = [msg '(+)Nearly out of￥1 Coin!'];
            end
            if obj.cash(1)/obj.cashCapacity >= 0.8
                msg = [msg '(-)￥1 Cash nearly FULL!'];
            end
            if obj.cash(1)/obj.cashCapacity < 0.15
                msg = [msg '(+)Nearly out of ￥1 Cash!'];
            end
            if obj.cash(2)/obj.cashCapacity >= 0.8
                msg = [msg '(-)￥5 Cash nearly FULL!'];
            end
            if obj.cash(2)/obj.cashCapacity < 0.1
                msg = [msg '(+)Nearly out of ￥5 Cash!'];
            end
            if obj.cash(3)/obj.cashCapacity >= 0.8
                msg = [msg '(-)￥10 Cash nearly FULL!'];
            end
            if obj.cash(3)/obj.cashCapacity < 0.1
                msg = [msg '(+)Nearly out of ￥10 Cash!'];
            end
            if obj.cash(4)/obj.cashCapacity >= 0.8
                msg = [msg '(-)￥20 Cash nearly FULL!'];
            end
        end
    end
    
end