classdef MoneyBox_test < matlab.uitest.TestCase
    properties
        MB
    end
    
    
    methods (TestMethodSetup)
        function launchApp(testCase)
            testCase.MB = MoneyBox;
        end
    end
    
    methods (Test)
        function test_struct(testCase)% TestCase 1.3.1
            testCase.verifyEqual(testCase.MB.getCoins , [50 50]);
            testCase.verifyEqual(testCase.MB.getCash , [30 30 30 0]);
            close all force;
        end
        
        function test_updateCoins(testCase)% TestCase 1.3.2
            testCase.MB.updateCoins([40 40])
            testCase.verifyEqual(testCase.MB.getCoins , [40 40]);
            close all force;
        end
        
        function test_updateCash(testCase)% TestCase 1.3.3
            testCase.MB.updateCash([20 31 25 0])
            testCase.verifyEqual(testCase.MB.getCash , [20 31 25 0]);
            close all force;
        end
        
        function test_alertMessage(testCase)% TestCase 1.3.4
            testCase.MB.updateCoins([79 1])% TestCase 1.3.4.1
            msg = alertMessage(testCase.MB);
            testCase.verifyEqual(msg ,'(-)￥0.5 Coin nearly FULL!(+)Nearly out of￥1 Coin!')
            testCase.MB.updateCoins([60 60])
            testCase.MB.updateCash([60 55 5 0])% TestCase 1.3.4.2
            msg = alertMessage(testCase.MB);
            testCase.verifyEqual(msg ,  '(-)￥1 Cash nearly FULL!(-)￥5 Cash nearly FULL!(+)Nearly out of ￥10 Cash!')
            close all force;
        end
        
        
    end
    
end