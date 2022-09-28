classdef MerchandiseDB_test < matlab.uitest.TestCase
    properties
        MDB
    end
    
    
    methods (TestMethodSetup)
        function launchApp(testCase)
            testCase.MDB = MerchandiseDB;
        end
    end
    
    methods (Test)
        function test_struct(testCase)% TestCase 1.2.1
            list = retrieve(testCase.MDB);
            testCase.verifyEqual(list(1).name , 'Coke');
            testCase.verifyEqual(list(2).name , 'Fanta');
            testCase.verifyEqual(list(3).name , 'Sprite');
            testCase.verifyEqual(list(4).name , 'WangMilk');
            testCase.verifyEqual(list(1).price , 3.5);
            testCase.verifyEqual(list(2).price , 3);
            testCase.verifyEqual(list(3).price , 3);
            testCase.verifyEqual(list(4).price , 5.5);
            testCase.verifyEqual(list(1).quantity , 10);
            testCase.verifyEqual(list(2).quantity , 10);
            testCase.verifyEqual(list(3).quantity , 10);
            testCase.verifyEqual(list(4).quantity , 0);
            close all force;
        end
        
        function test_addMerchandise(testCase)
            testCase.MDB.addMerchandise('tea');% TestCase 1.2.2
            list = retrieve(testCase.MDB);
            testCase.verifyEqual(list(5).name , 'tea');
            testCase.verifyEqual(list(5).price , 5);
            testCase.verifyEqual(list(5).quantity , 0);
            close all force;
        end
        
        function test_updateMerchandise(testCase)
            testCase.MDB.updateMerchandise('Coke',8,20);% TestCase 1.2.3.1
            testCase.MDB.updateMerchandise('Tea',8,20) ;% TestCase 1.2.3.2
            list = retrieve(testCase.MDB);
            testCase.verifyEqual(list(1).name , 'Coke');
            testCase.verifyEqual(list(1).price , 8);
            testCase.verifyEqual(list(1).quantity, 20);
            
            close all force;
        end
        
        function test_sellMerchandise(testCase)% TestCase 1.2.4
            testCase.MDB.sellMerchandise('Coke');
            list = retrieve(testCase.MDB);
            testCase.verifyEqual(list(1).quantity, 9);
            close all force;
        end
        
        function test_getMerchandise(testCase)% TestCase 1.2.5
            merchandise=testCase.MDB.getMerchandise('Coke');
            list = retrieve(testCase.MDB);
            testCase.verifyEqual(list(1), merchandise);
            close all force;
        end
        
         function test_alertMessage(testCase)% TestCase 1.2.6
            testCase.MDB.updateMerchandise('Coke',8,0);
            testCase.MDB.updateMerchandise('WangMilk',8,3);
            msg = alertMessage(testCase.MDB);
            testCase.verifyEqual(msg, '(+)Nearly out of WangMilk!(++)Out of Coke!');
            close all force;
        end
        
        
    end
    
end