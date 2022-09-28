classdef Payment_test < matlab.uitest.TestCase
    properties
        ctrl
        pm
        
    end
    
    
    methods (TestMethodSetup)
        function launchApp(testCase)
            testCase.ctrl = VenderController;
            testCase.pm = Payment(testCase.ctrl);
            testCase.pm.price = 3;
        end
    end
    
    methods (Test)
        function test_struct(testCase)
            testCase.verifyEqual(testCase.pm.status , 'Created');
            stop(timerfind);
            delete(timerfind);
            close all force;
        end
    end
    
end