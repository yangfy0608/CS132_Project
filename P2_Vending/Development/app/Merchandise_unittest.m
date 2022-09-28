classdef Merchandise_unittest < matlab.uitest.TestCase
    properties
        Mer
    end
    
    
    methods (TestMethodSetup)
        function launchApp(testCase)
            testCase.Mer = Merchandise('coke',3,20);
        end
    end
    
    methods (Test)
        function test_struct(testCase)
            testCase.verifyEqual(testCase.Mer.name , 'coke');
            testCase.verifyEqual(testCase.Mer.price , 3);
            testCase.verifyEqual(testCase.Mer.quantity , 20);
            close all force;
        end
    end
    
end