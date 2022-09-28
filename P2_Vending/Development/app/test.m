classdef test < matlab.uitest.TestCase
    properties
        mb
        mdb
        ctrl
        uapp
        mapp
    end
    
    
    methods (TestMethodSetup)
        function launchApp(testCase)
            testCase.mb=MoneyBox;
            testCase.mdb=MerchandiseDB;
            testCase.ctrl=VenderController;
            testCase.uapp=UserUI;
            testCase.mapp=MaintainerUI;
            
            testCase.ctrl.userApp=testCase.uapp;
            testCase.ctrl.maintainerApp=testCase.mapp;
            testCase.ctrl.moneyBox=testCase.mb;
            testCase.ctrl.merchandiseDB=testCase.mdb;
            
            testCase.mb.controller=testCase.ctrl;
            testCase.mdb.controller=testCase.ctrl;
            testCase.uapp.Controller=testCase.ctrl;
            testCase.mapp.Controller=testCase.ctrl;
            
            testCase.mapp.Init;
            testCase.uapp.Init;
            testCase.addTeardown(@delete,testCase.ctrl);
        end
    end
    
    methods (Test)
        function test_SelectTarget(testCase)
            testCase.choose(testCase.uapp.MerchandiseSelection,'Fanta');
            testCase.verifyEqual(testCase.uapp.MerchandiseSelection.Value,'Fanta');
            testCase.press(testCase.uapp.ConfirmButton);
            testCase.choose(testCase.uapp.MerchandiseSelection,'Coke');
            testCase.verifyEqual(testCase.uapp.MerchandiseSelection.Value,'Coke');
            testCase.press(testCase.uapp.ConfirmButton);
            close all force;
        end
        
        function test_Target(testCase)
            testCase.choose(testCase.uapp.MerchandiseSelection,'Fanta');
            testCase.verifyEqual(testCase.uapp.MerchandiseSelection.Value,'Fanta');
            testCase.press(testCase.uapp.ConfirmButton);
            close all force;
        end
    end
    
end