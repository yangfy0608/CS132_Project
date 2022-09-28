classdef test < matlab.uitest.TestCase
    properties
        Eleversion
        F1UI
        F2UI
        F3UI
        FBUI
        LctrlUI
        RctrlUI
    end
    
    methods(TestMethodSetup)
        function launchApp(testCase)
            c = Controller;
            
            testCase.Eleversion.ctrl = c;
            testCase.F1UI.ctrl = c;
            testCase.F2UI.ctrl = c;
            testCase.F3UI.ctrl = c;
            testCase.FBUI.ctrl = c;
            testCase.LctrlUI.ctrl = c;
            testCase.RctrlUI.ctrl = c;
            
            testCase.addTeardown(@delete, testCase.Eleversion.ctrl);
        end
    end
    
    methods(Test)
        % T1.1.1: Test delete()
        function test_delete(testCase)
            testCase.Eleversion.ctrl.delete();
            
            pause(5);
            close all force;
        end
        
        %T1.1.2: Test controller()
        function test_controller(testCase)
            testCase.Eleversion.ctrl;
            pause(5);
            close all force;
        end
        
        %T1.1.3.1: Test update1()
        function test_update_1(testCase)
            testCase.Eleversion.ctrl.elevators(1).doorState = 'Closed';
            testCase.Eleversion.ctrl.elevators(2).doorState = 'Closed';
            testCase.Eleversion.ctrl.update();
            pause(5);
            close all force;
        end
        
        %T1.1.3.2: Test update2()
        function test_update_2(testCase)
            testCase.Eleversion.ctrl.elevators(1).doorState = 'Closed';
            %testCase.Eleversion.ctrl.elevators(2).doorState = 'Opened';
            testCase.Eleversion.ctrl.update();
            pause(5);
            close all force;
        end
        
        %T1.1.3.3: Test update3()
        function test_update_3(testCase)
            %testCase.Eleversion.ctrl.elevators(1).doorState = 'Closed';
            testCase.Eleversion.ctrl.elevators(2).doorState = 'Closed';
            testCase.Eleversion.ctrl.update();
            pause(5);
            close all force;
        end
        
        %T1.1.3.4: Test update4()
        function test_update_4(testCase)
            %testCase.Eleversion.ctrl.elevators(1).doorState = 'Closed';
            %testCase.Eleversion.ctrl.elevators(2).doorState = 'Closed';
            testCase.Eleversion.ctrl.update();
            pause(5);
            close all force;
        end
        
        %T1.1.4.1 Test getRequest1()
        function test_getRequest1(testCase)
            testCase.Eleversion.ctrl.elevators(1).serviceState = 'Up';
            testCase.Eleversion.ctrl.elevators(2).serviceState = 'Up';
            testCase.Eleversion.ctrl.upRequest(2) = 1;
            testCase.Eleversion.ctrl.elevators(1).y = 1;
            testCase.Eleversion.ctrl.elevators(2).y = 2;
            testCase.Eleversion.ctrl.getRequest();
            pause(5);
            testCase.Eleversion.ctrl.elevators(2).upService(2)
            testCase.Eleversion.ctrl.upRequest(2)
            close all force;
        end
        
        %T1.1.4.2 Test getRequest2()
        function test_getRequest2(testCase)
            testCase.Eleversion.ctrl.elevators(1).serviceState = 'Up';
            testCase.Eleversion.ctrl.elevators(2).serviceState = 'Up';
            testCase.Eleversion.ctrl.upRequest(2) = 1;
            testCase.Eleversion.ctrl.elevators(1).y = 2;
            testCase.Eleversion.ctrl.elevators(2).y = 1;
            testCase.Eleversion.ctrl.getRequest();
            pause(5);
            testCase.Eleversion.ctrl.elevators(1).upService(2)
            testCase.Eleversion.ctrl.upRequest(2)
            close all force;
        end
        
        %T1.1.4.3 Test getRequest3()
        function test_getRequest3(testCase)
            testCase.Eleversion.ctrl.elevators(1).serviceState = 'Up';
            %testCase.Eleversion.ctrl.elevators(2).serviceState = 'Up';
            testCase.Eleversion.ctrl.upRequest(2) = 1;
            testCase.Eleversion.ctrl.elevators(1).y = 2;
            %testCase.Eleversion.ctrl.elevators(2).y = 1;
            testCase.Eleversion.ctrl.getRequest();
            pause(5);
            testCase.Eleversion.ctrl.elevators(1).upService(2)
            testCase.Eleversion.ctrl.upRequest(2)
            close all force;
        end
        
        %T1.1.4.4 Test getRequest4()
        function test_getRequest4(testCase)
            %testCase.Eleversion.ctrl.elevators(1).serviceState = 'Up';
            testCase.Eleversion.ctrl.elevators(2).serviceState = 'Up';
            testCase.Eleversion.ctrl.upRequest(2) = 1;
            %testCase.Eleversion.ctrl.elevators(1).y = 2;
            testCase.Eleversion.ctrl.elevators(2).y = 1;
            testCase.Eleversion.ctrl.getRequest();
            pause(5);
            testCase.Eleversion.ctrl.elevators(2).upService(2)
            testCase.Eleversion.ctrl.upRequest(2)
            close all force;
        end
        
        %T1.1.4.5 Test getRequest5()
        function test_getRequest5(testCase)
            testCase.Eleversion.ctrl.elevators(2).upService = 0;
            testCase.Eleversion.ctrl.elevators(2).downService = 0;
            testCase.Eleversion.ctrl.upRequest(2) = 1;
            testCase.Eleversion.ctrl.getRequest();
            pause(5);
            
            testCase.Eleversion.ctrl.elevators(2).serviceState
            testCase.Eleversion.ctrl.elevators(2).upService(2)
            testCase.Eleversion.ctrl.upRequest(2)
            close all force;
        end
        
        %T1.1.4.6 Test getRequest6()
        function test_getRequest6(testCase)
            testCase.Eleversion.ctrl.elevators(1).upService = 0;
            testCase.Eleversion.ctrl.elevators(1).downService = 0;
            testCase.Eleversion.ctrl.upRequest(2) = 1;
            testCase.Eleversion.ctrl.getRequest();
            pause(5);
            
            testCase.Eleversion.ctrl.elevators(2).serviceState
            testCase.Eleversion.ctrl.elevators(2).upService(2)
            testCase.Eleversion.ctrl.upRequest(2)
            close all force;
        end
        
        %T1.1.4.7 Test getRequest7()
        function test_getRequest7(testCase)
            testCase.Eleversion.ctrl.elevators(2).serviceState = 'Up';
            testCase.Eleversion.ctrl.upRequest(2) = 1;
            testCase.Eleversion.ctrl.getRequest();
            pause(5);
            
            testCase.Eleversion.ctrl.elevators(2).upService(2)
            testCase.Eleversion.ctrl.upRequest(2)
            close all force;
        end
        
        %T1.1.4.8 Test getRequest8()
        function test_getRequest8(testCase)
            testCase.Eleversion.ctrl.elevators(1).serviceState = 'Down';
            testCase.Eleversion.ctrl.elevators(2).serviceState = 'Down';
            testCase.Eleversion.ctrl.downRequest(2) = 1;
            testCase.Eleversion.ctrl.elevators(1).y = 6;
            testCase.Eleversion.ctrl.elevators(2).y = 5 ;
            testCase.Eleversion.ctrl.getRequest();
            pause(5);
            
            testCase.Eleversion.ctrl.elevators(2).downService(2)
            testCase.Eleversion.ctrl.downRequest(2)
            close all force;
        end
        
        %T1.1.4.9 Test getRequest9()
        function test_getRequest9(testCase)
            testCase.Eleversion.ctrl.elevators(1).serviceState = 'Down';
            testCase.Eleversion.ctrl.elevators(2).serviceState = 'Down';
            testCase.Eleversion.ctrl.downRequest(2) = 1;
            testCase.Eleversion.ctrl.elevators(1).y = 5;
            testCase.Eleversion.ctrl.elevators(2).y = 6;
            testCase.Eleversion.ctrl.getRequest();
            pause(5);
            
            testCase.Eleversion.ctrl.elevators(1).downService(2)
            testCase.Eleversion.ctrl.downRequest(2)
            close all force;
        end
        
        %T1.1.4.10 Test getRequest10()
        function test_getRequest10(testCase)
            testCase.Eleversion.ctrl.elevators(1).serviceState = 'Down';
            testCase.Eleversion.ctrl.downRequest(2) = 1;
            testCase.Eleversion.ctrl.elevators(1).y = 6;
            testCase.Eleversion.ctrl.getRequest();
            pause(5);
            testCase.Eleversion.ctrl.elevators(1).downService(2)
            testCase.Eleversion.ctrl.downRequest(2)
            close all force;
        end
        
        %T1.1.4.11 Test getRequest11()
        function test_getRequest11(testCase)
            testCase.Eleversion.ctrl.elevators(2).serviceState = 'Down';
            testCase.Eleversion.ctrl.downRequest(2) = 1;
            testCase.Eleversion.ctrl.elevators(2).y = 6;
            testCase.Eleversion.ctrl.getRequest();
            pause(5);
            testCase.Eleversion.ctrl.elevators(2).downService(2)
            testCase.Eleversion.ctrl.downRequest(2)
            close all force;
        end
        
        %T1.1.4.12 Test getRequest12()
        function test_getRequest12(testCase)
            testCase.Eleversion.ctrl.elevators(2).upService = 0;
            testCase.Eleversion.ctrl.elevators(2).downService = 0;
            testCase.Eleversion.ctrl.downRequest(2) = 1;
            testCase.Eleversion.ctrl.getRequest();
            pause(5);
            
            testCase.Eleversion.ctrl.elevators(2).serviceState
            testCase.Eleversion.ctrl.elevators(2).downService(2)
            testCase.Eleversion.ctrl.upRequest(2)
            close all force;
        end
        
        %T1.1.4.13 Test getRequest13()
        function test_getRequest13(testCase)
            testCase.Eleversion.ctrl.elevators(1).upService = 0;
            testCase.Eleversion.ctrl.elevators(1).downService = 0;
            testCase.Eleversion.ctrl.downRequest(2) = 1;
            testCase.Eleversion.ctrl.getRequest();
            pause(5);
            
            testCase.Eleversion.ctrl.elevators(2).serviceState
            testCase.Eleversion.ctrl.elevators(2).downService(2)
            testCase.Eleversion.ctrl.downRequest(2)
            close all force;
        end
        
        %T1.1.4.14 Test getRequest14()
        function test_getRequest14(testCase)
            testCase.Eleversion.ctrl.elevators(2).serviceState = 'Down';
            testCase.Eleversion.ctrl.downRequest(2) = 1;
            testCase.Eleversion.ctrl.getRequest();
            pause(5);
            
            testCase.Eleversion.ctrl.elevators(2).downService(2)
            testCase.Eleversion.ctrl.downRequest(2)
            close all force;
        end
        
        %T1.1.5.1 Test getNextTarget1(elevator)
        function test_getNextTarget1(testCase)
            testCase.Eleversion.ctrl.elevators(1).v = 0;
            testCase.Eleversion.ctrl.elevators(1).serviceState = 'Up';
            testCase.Eleversion.ctrl.elevators(1).upService(2) = 1;
            testCase.Eleversion.ctrl.elevators(1).y = 1;
            testCase.Eleversion.ctrl.getNextTarget(testCase.Eleversion.ctrl.elevators(1));
            pause(5);
            
            testCase.Eleversion.ctrl.elevators(1).vdir
            testCase.Eleversion.ctrl.elevators(1).nextTarget
            close all force;
        end
        
        %T1.1.5.2 Test getNextTarget2(elevator)
        function test_getNextTarget2(testCase)
            testCase.Eleversion.ctrl.elevators(1).v = 0;
            testCase.Eleversion.ctrl.elevators(1).serviceState = 'Up';
            testCase.Eleversion.ctrl.elevators(1).downService(2) = 1;
            testCase.Eleversion.ctrl.elevators(1).y = 1;
            testCase.Eleversion.ctrl.getNextTarget(testCase.Eleversion.ctrl.elevators(1));
            pause(5);
            
            testCase.Eleversion.ctrl.elevators(1).vdir
            testCase.Eleversion.ctrl.elevators(1).nextTarget
            close all force;
        end
        
        %T1.1.5.3 Test getNextTarget2(elevator)
        function test_getNextTarget3(testCase)
            testCase.Eleversion.ctrl.elevators(1).v = 0;
            testCase.Eleversion.ctrl.elevators(1).serviceState = 'Up';
            testCase.Eleversion.ctrl.elevators(1).downService(2) = 1;
            testCase.Eleversion.ctrl.elevators(1).y = 6;
            testCase.Eleversion.ctrl.getNextTarget(testCase.Eleversion.ctrl.elevators(1));
            pause(5);
            
            testCase.Eleversion.ctrl.elevators(1).vdir
            testCase.Eleversion.ctrl.elevators(1).nextTarget
            close all force;
        end
        
        %T1.1.5.4 Test getNextTarget4(elevator)
        function test_getNextTarget4(testCase)
            testCase.Eleversion.ctrl.elevators(1).v = 0;
            testCase.Eleversion.ctrl.elevators(1).serviceState = 'Down';
            testCase.Eleversion.ctrl.elevators(1).downService(2) = 1;
            testCase.Eleversion.ctrl.elevators(1).y = 6;
            testCase.Eleversion.ctrl.getNextTarget(testCase.Eleversion.ctrl.elevators(1));
            pause(5);
            
            testCase.Eleversion.ctrl.elevators(1).vdir
            testCase.Eleversion.ctrl.elevators(1).nextTarget
            close all force;
        end
        
        %T1.1.5.5 Test getNextTarget5(elevator)
        function test_getNextTarget5(testCase)
            testCase.Eleversion.ctrl.elevators(1).v = 0;
            testCase.Eleversion.ctrl.elevators(1).serviceState = 'Down';
            testCase.Eleversion.ctrl.elevators(1).downService(2) = 1;
            testCase.Eleversion.ctrl.elevators(1).y = 1;
            testCase.Eleversion.ctrl.getNextTarget(testCase.Eleversion.ctrl.elevators(1));
            pause(5);
            
            testCase.Eleversion.ctrl.elevators(1).vdir
            testCase.Eleversion.ctrl.elevators(1).nextTarget
            close all force;
        end
        
        %T1.1.5.6 Test getNextTarget5(elevator)
        function test_getNextTarget6(testCase)
            testCase.Eleversion.ctrl.elevators(1).v = 0;
            testCase.Eleversion.ctrl.elevators(1).serviceState = 'Down';
            testCase.Eleversion.ctrl.elevators(1).downService(2) = 1;
            testCase.Eleversion.ctrl.elevators(1).y = 6;
            testCase.Eleversion.ctrl.getNextTarget(testCase.Eleversion.ctrl.elevators(1));
            pause(5);
            
            testCase.Eleversion.ctrl.elevators(1).vdir
            testCase.Eleversion.ctrl.elevators(1).nextTarget
            close all force;
        end
        
        %T1.1.5.7 Test getNextTarget7(elevator)
        function test_getNextTarget7(testCase)
            testCase.Eleversion.ctrl.elevators(1).v = 1;
            testCase.Eleversion.ctrl.elevators(1).serviceState = 'Up';
            testCase.Eleversion.ctrl.elevators(1).upService(2) = 1;
            testCase.Eleversion.ctrl.elevators(1).y = 1;
            testCase.Eleversion.ctrl.getNextTarget(testCase.Eleversion.ctrl.elevators(1));
            pause(5);
            
            testCase.Eleversion.ctrl.elevators(1).vdir
            testCase.Eleversion.ctrl.elevators(1).nextTarget
            close all force;
        end
        
         %T1.1.5.8 Test getNextTarget8(elevator)
        function test_getNextTarget8(testCase)
            testCase.Eleversion.ctrl.elevators(1).v = 1;
            testCase.Eleversion.ctrl.elevators(1).serviceState = 'Down';
            testCase.Eleversion.ctrl.elevators(1).downService(2) = 1;
            testCase.Eleversion.ctrl.elevators(1).y = 6;
            testCase.Eleversion.ctrl.getNextTarget(testCase.Eleversion.ctrl.elevators(1));
            pause(5);
            
            testCase.Eleversion.ctrl.elevators(1).vdir
            testCase.Eleversion.ctrl.elevators(1).nextTarget
            close all force;
        end
        
        %T1.1.6.1 Test goNextTarget1(elevator)
        function test_goNextTarget1(testCase)
            testCase.Eleversion.ctrl.elevators(1).v = 1;
            testCase.Eleversion.ctrl.elevators(1).nextTarget = 1;
            testCase.Eleversion.ctrl.elevators(1).y = 2.99;
            testCase.Eleversion.ctrl.elevators(1).serviceState = 'Down';
            pause(5);
            
            testCase.Eleversion.ctrl.elevators(1).downService(2)
            testCase.Eleversion.ctrl.downRequest(2)
            close all force;
        end
        
        %T1.1.6.2 Test goNextTarget2(elevator)
        function test_goNextTarget2(testCase)
            testCase.Eleversion.ctrl.elevators(1).v = 1;
            testCase.Eleversion.ctrl.elevators(1).nextTarget = 1;
            testCase.Eleversion.ctrl.elevators(1).y = 2.99;
            testCase.Eleversion.ctrl.elevators(1).serviceState = 'Up';
            pause(5);
            
            testCase.Eleversion.ctrl.elevators(1).upService(2)
            testCase.Eleversion.ctrl.upRequest(2)
            close all force;
        end
        
        %T1.1.6.3 Test goNextTarget3(elevator)
        function test_goNextTarget3(testCase)
            testCase.Eleversion.ctrl.elevators(1).v = 1;
            testCase.Eleversion.ctrl.elevators(1).y = 2.99;
            testCase.Eleversion.ctrl.elevators(1).nextTarget = 0;
            pause(5);
            
            testCase.Eleversion.ctrl.FB.Up.BackgroundColor
            close all force;
        end
        
        %T1.1.6.4 Test goNextTarget4(elevator)
        function test_goNextTarget4(testCase)
            testCase.Eleversion.ctrl.elevators(1).v = 1;
            testCase.Eleversion.ctrl.elevators(1).y = 2.99;
            testCase.Eleversion.ctrl.elevators(1).nextTarget = 3;
            testCase.Eleversion.ctrl.elevators(1).id
            pause(5);
            
            testCase.Eleversion.ctrl.F3.Down.BackgroundColor
            testCase.Eleversion.ctrl.F3.B.BackgroundColor
            close all force;
        end
        
        %T1.1.6.5 Test goNextTarget5(elevator)
        function test_goNextTarget5(testCase)
            testCase.Eleversion.ctrl.elevators(1).v = 1;
            testCase.Eleversion.ctrl.elevators(1).nextTarget = 1;
            testCase.Eleversion.ctrl.elevators(1).y = 2.99;
            testCase.Eleversion.ctrl.elevators(1).serviceState = 'Up';
            pause(5);
            
            testCase.Eleversion.ctrl.F1.Up.BackgroundColor
            close all force;
        end
        
         %T1.1.6.6 Test goNextTarget6(elevator)
        function test_goNextTarget6(testCase)
            testCase.Eleversion.ctrl.elevators(1).v = 1;
            testCase.Eleversion.ctrl.elevators(1).nextTarget = 1;
            testCase.Eleversion.ctrl.elevators(1).y = 2.99;
            testCase.Eleversion.ctrl.elevators(1).serviceState = 'Up';
            pause(5);
            
            testCase.Eleversion.ctrl.F1.B.BackgroundColor
            close all force;
        end
        
         %T1.1.6.7 Test goNextTarget7(elevator)
        function test_goNextTarget7(testCase)
            testCase.Eleversion.ctrl.elevators(1).v = 1;
            testCase.Eleversion.ctrl.elevators(1).nextTarget = 2;
            testCase.Eleversion.ctrl.elevators(1).y = 2.99;
            testCase.Eleversion.ctrl.elevators(1).serviceState = 'Up';
            pause(5);
            
            testCase.Eleversion.ctrl.F2.Up.BackgroundColor
            close all force;
        end
        
         %T1.1.6.8 Test goNextTarget8(elevator)
        function test_goNextTarget8(testCase)
            testCase.Eleversion.ctrl.elevators(1).v = 2;
            pause(5);
            
            testCase.Eleversion.ctrl.elevators(1).moveState
            close all force;
        end
        
        %T1.1.7.1 Test BRequest1(floor)
        function test_BRequest1(testCase)
            testCase.Eleversion.ctrl.elevators(1).y = 1;
            testCase.Eleversion.ctrl.BRequest(1);
            pause(5);
            
            testCase.Eleversion.ctrl.elevators(1).downService(2)
            close all force;
        end
        
        %T1.1.7.2 Test BRequest2(floor)
        function test_BRequest2(testCase)
            testCase.Eleversion.ctrl.elevators(1).y = 3;
            testCase.Eleversion.ctrl.BRequest(1);
            pause(5);
            
            testCase.Eleversion.ctrl.FB.Up.BackgroundColor
            close all force;
        end
        
        %T1.1.8.1 Test addFloorRequest1
        function test_addFloorRequest1(testCase)
            testCase.Eleversion.ctrl.elevators(1).y = 3;
            testCase.Eleversion.ctrl.elevators(1).serviceState = 'Up';
            testCase.Eleversion.ctrl.addFloorRequest(1,1);
            pause(5);
            
            testCase.Eleversion.ctrl.elevators(1).doorState
            testCase.Eleversion.ctrl.F1.Up.BackgroundColor
            close all force;
        end
        
        %T1.1.8.2 Test addFloorRequest2
        function test_addFloorRequest2(testCase)
            testCase.Eleversion.ctrl.elevators(2).y = 3;
            testCase.Eleversion.ctrl.elevators(2).serviceState = 'Up';
            testCase.Eleversion.ctrl.addFloorRequest(1,1);
            pause(5);
            
            testCase.Eleversion.ctrl.elevators(2).doorState
            testCase.Eleversion.ctrl.F1.Up.BackgroundColor
            close all force;
        end
        
        %T1.1.8.3 Test addFloorRequest3
        function test_addFloorRequest3(testCase)
            testCase.Eleversion.ctrl.elevators(1).y = 6;
            testCase.Eleversion.ctrl.elevators(1).serviceState = 'Down';
            testCase.Eleversion.ctrl.addFloorRequest(2,-1);
            pause(5);
            
            testCase.Eleversion.ctrl.elevators(1).doorState
            testCase.Eleversion.ctrl.F2.Down.BackgroundColor
            close all force;
        end
        
        %T1.1.8.4 Test addFloorRequest4
        function test_addFloorRequest4(testCase)
            testCase.Eleversion.ctrl.elevators(2).y = 6;
            testCase.Eleversion.ctrl.elevators(2).serviceState = 'Down';
            testCase.Eleversion.ctrl.addFloorRequest(2,-1);
            pause(5);
            
            testCase.Eleversion.ctrl.elevators(2).doorState
            testCase.Eleversion.ctrl.F2.Down.BackgroundColor
            close all force;
        end
        
        %T1.1.8.5 Test addFloorRequest5
        function test_addFloorRequest5(testCase)
            testCase.Eleversion.ctrl.elevators(1).y = 6;
            testCase.Eleversion.ctrl.elevators(1).serviceState = 'Up';
            testCase.Eleversion.ctrl.elevators(1).nextTarget = -1;
            testCase.Eleversion.ctrl.addFloorRequest(2,-1);
            pause(5);
            
            testCase.Eleversion.ctrl.elevators(1).doorState
            testCase.Eleversion.ctrl.F2.Down.BackgroundColor
            testCase.Eleversion.ctrl.elevators(1).serviceState
            close all force;
        end
        
        %T1.1.8.6 Test addFloorRequest6
        function test_addFloorRequest6(testCase)
            testCase.Eleversion.ctrl.elevators(1).y = 3;
            testCase.Eleversion.ctrl.elevators(1).serviceState = 'Up';
            testCase.Eleversion.ctrl.elevators(2).nextTarget = -1;
            testCase.Eleversion.ctrl.addFloorRequest(1,-1);
            pause(5);
            
            testCase.Eleversion.ctrl.elevators(2).downService(2)
            close all force;
        end
        
        %T1.1.8.7 Test addFloorRequest7
        function test_addFloorRequest7(testCase)
            testCase.Eleversion.ctrl.elevators(2).y = 6;
            testCase.Eleversion.ctrl.elevators(2).serviceState = 'Up';
            testCase.Eleversion.ctrl.elevators(2).nextTarget = -1;
            testCase.Eleversion.ctrl.addFloorRequest(2,-1);
            pause(5);
            
            testCase.Eleversion.ctrl.elevators(2).doorState
            testCase.Eleversion.ctrl.F2.Down.BackgroundColor
            testCase.Eleversion.ctrl.elevators(2).serviceState
            close all force;
        end
        
        %T1.1.8.8 Test addFloorRequest8
        function test_addFloorRequest8(testCase)
            testCase.Eleversion.ctrl.elevators(2).y = 3;
            testCase.Eleversion.ctrl.elevators(2).serviceState = 'Up';
            testCase.Eleversion.ctrl.elevators(1).nextTarget = -1;
            testCase.Eleversion.ctrl.addFloorRequest(1,-1);
            pause(5);
            
            testCase.Eleversion.ctrl.elevators(1).downService(2)
            close all force;
        end
        
        %T1.1.8.9 Test addFloorRequest9
        function test_addFloorRequest9(testCase)
            testCase.Eleversion.ctrl.elevators(1).y = 6;
            testCase.Eleversion.ctrl.elevators(1).serviceState = 'Down';
            testCase.Eleversion.ctrl.elevators(1).nextTarget = -1;
            testCase.Eleversion.ctrl.addFloorRequest(2,1);
            pause(5);
            
            testCase.Eleversion.ctrl.elevators(1).doorState
            testCase.Eleversion.ctrl.F2.Down.BackgroundColor
            testCase.Eleversion.ctrl.elevators(1).serviceState
            close all force;
        end
        
        %T1.1.8.10 Test addFloorRequest10
        function test_addFloorRequest10(testCase)
            testCase.Eleversion.ctrl.elevators(1).y = 3;
            testCase.Eleversion.ctrl.elevators(1).serviceState = 'Down';
            testCase.Eleversion.ctrl.elevators(2).nextTarget = -1;
            testCase.Eleversion.ctrl.addFloorRequest(1,-1);
            pause(5);
            
            testCase.Eleversion.ctrl.elevators(2).upService(2)
            close all force;
        end
        
        %T1.1.8.11 Test addFloorRequest11
        function test_addFloorRequest11(testCase)
            testCase.Eleversion.ctrl.elevators(2).y = 6;
            testCase.Eleversion.ctrl.elevators(2).serviceState = 'Down';
            testCase.Eleversion.ctrl.elevators(2).nextTarget = -1;
            testCase.Eleversion.ctrl.addFloorRequest(2,1);
            pause(5);
            
            testCase.Eleversion.ctrl.elevators(2).doorState
            testCase.Eleversion.ctrl.F2.Down.BackgroundColor
            testCase.Eleversion.ctrl.elevators(2).serviceState
            close all force;
        end
        
        %T1.1.8.12 Test addFloorRequest12
        function test_addFloorRequest12(testCase)
            testCase.Eleversion.ctrl.elevators(2).y = 3;
            testCase.Eleversion.ctrl.elevators(2).serviceState = 'Down';
            testCase.Eleversion.ctrl.elevators(1).nextTarget = -1;
            testCase.Eleversion.ctrl.addFloorRequest(1,-1);
            pause(5);
            
            testCase.Eleversion.ctrl.elevators(1).upService(2)
            close all force;
        end
        
        %T1.1.8.13 Test addFloorRequest13
        function test_addFloorRequest13(testCase)
            testCase.Eleversion.ctrl.elevators(1).y = 0;
            testCase.Eleversion.ctrl.addFloorRequest(0,1);
            pause(5);
            
            testCase.Eleversion.ctrl.elevators(1).upService(1)
            close all force;
        end
        
        %T1.1.8.14 Test addFloorRequest14
        function test_addFloorRequest14(testCase)
            testCase.Eleversion.ctrl.elevators(1).y = 9;
            testCase.Eleversion.ctrl.elevators(1).vdir = 2;
            testCase.Eleversion.ctrl.elevators(2).vdir = 3;
            testCase.Eleversion.ctrl.addFloorRequest(3,-1);
            pause(5);
            
            testCase.Eleversion.ctrl.elevators(2).downService(4)
            close all force;
        end
        
        %T1.1.8.15 Test addFloorRequest15
        function test_addFloorRequest15(testCase)
            testCase.Eleversion.ctrl.elevators(1).y = 9;
            testCase.Eleversion.ctrl.elevators(1).vdir = 3;
            testCase.Eleversion.ctrl.elevators(2).vdir = 2;
            testCase.Eleversion.ctrl.addFloorRequest(3,-1);
            pause(5);
            
            testCase.Eleversion.ctrl.elevators(1).downService(4)
            close all force;
        end
        
        %T1.1.8.16 Test addFloorRequest16
        function test_addFloorRequest16(testCase)
            testCase.Eleversion.ctrl.elevators(1).y = 9;
            testCase.Eleversion.ctrl.elevators(1).vdir = 3;
            testCase.Eleversion.ctrl.elevators(2).vdir = -1;
            testCase.Eleversion.ctrl.addFloorRequest(3,-1);
            pause(5);
            
            testCase.Eleversion.ctrl.elevators(1).downService(4)
            close all force;
        end
        
        %T1.1.8.17 Test addFloorRequest17
        function test_addFloorRequest17(testCase)
            testCase.Eleversion.ctrl.elevators(1).y = 9;
            testCase.Eleversion.ctrl.elevators(2).vdir = 3;
            testCase.Eleversion.ctrl.elevators(1).vdir = -1;
            testCase.Eleversion.ctrl.addFloorRequest(3,-1);
            pause(5);
            
            testCase.Eleversion.ctrl.elevators(2).downService(4)
            close all force;
        end
        
        %T1.1.8.18 Test addFloorRequest18
        function test_addFloorRequest18(testCase)
            testCase.Eleversion.ctrl.elevators(1).y = 6;
            testCase.Eleversion.ctrl.elevators(2).y = 9;
            testCase.Eleversion.ctrl.elevators(2).vdir = -1;
            testCase.Eleversion.ctrl.elevators(1).vdir = -1;
            testCase.Eleversion.ctrl.addFloorRequest(3,-1);
            pause(5);
            
            testCase.Eleversion.ctrl.elevators(2).downService(4)
            close all force;
        end
        
        %T1.1.8.19 Test addFloorRequest19
        function test_addFloorRequest19(testCase)
            testCase.Eleversion.ctrl.elevators(1).y = 9;
            testCase.Eleversion.ctrl.elevators(2).y = 6;
            testCase.Eleversion.ctrl.elevators(2).vdir = -1;
            testCase.Eleversion.ctrl.elevators(1).vdir = -1;
            testCase.Eleversion.ctrl.addFloorRequest(3,-1);
            pause(5);
            
            testCase.Eleversion.ctrl.elevators(1).downService(4)
            close all force;
        end
        
        %T1.1.8.20 Test addFloorRequest20
        function test_addFloorRequest20(testCase)
            testCase.Eleversion.ctrl.addFloorRequest(1,1);
            pause(5);
            
            testCase.Eleversion.ctrl.upRequest(2)
            close all force;
        end
        
        %T1.1.8.21 Test addFloorRequest21
        function test_addFloorRequest21(testCase)
            testCase.Eleversion.ctrl.addFloorRequest(1,-1);
            pause(5);
            
            testCase.Eleversion.ctrl.downRequest(2)
            close all force;
        end
        
        %T1.1.9.1 Test lightPowerOff1()
        function test_lighpoweroff1(testCase)
            testCase.Eleversion.ctrl.lightPowerOff('L',0);
            pause(5);
            
            testCase.Eleversion.ctrl.Lui.L_B.BackgroundColor
            close all force;
        end
        
        %T1.1.9.2 Test lightPowerOff2()
        function test_lighpoweroff2(testCase)
            testCase.Eleversion.ctrl.lightPowerOff('L',1);
            pause(5);
            
            testCase.Eleversion.ctrl.Lui.L_1.BackgroundColor
            close all force;
        end
        
        %T1.1.9.3 Test lightPowerOff3()
        function test_lighpoweroff3(testCase)
            testCase.Eleversion.ctrl.lightPowerOff('L',2);
            pause(5);
            
            testCase.Eleversion.ctrl.Lui.L_2.BackgroundColor
            close all force;
        end
        
        %T1.1.9.4 Test lightPowerOff4()
        function test_lighpoweroff4(testCase)
            testCase.Eleversion.ctrl.lightPowerOff('L',3);
            pause(5);
            
            testCase.Eleversion.ctrl.Lui.L_3.BackgroundColor
            close all force;
        end
        
        %T1.1.9.5 Test lightPowerOff5()
        function test_lighpoweroff5(testCase)
            testCase.Eleversion.ctrl.lightPowerOff('R',1);
            pause(5);
            
            testCase.Eleversion.ctrl.Rui.R_1.BackgroundColor
            close all force;
        end
        
        %T1.1.9.6 Test lightPowerOff6()
        function test_lighpoweroff6(testCase)
            testCase.Eleversion.ctrl.lightPowerOff('R',2);
            pause(5);
            
            testCase.Eleversion.ctrl.Rui.R_2.BackgroundColor
            close all force;
        end
        
        %T1.1.9.7 Test lightPowerOff7()
        function test_lighpoweroff7(testCase)
            testCase.Eleversion.ctrl.lightPowerOff('R',3);
            pause(5);
            
            testCase.Eleversion.ctrl.Rui.R_3.BackgroundColor
            close all force;
        end
        
        %T1.1.10.1 Test FloorLightoff1()
        function test_FloorLightoff1(testCase)
            testCase.Eleversion.ctrl.lightPowerOff(0,1);
            pause(5);
            
            testCase.Eleversion.ctrl.FB.Up.BackgroundColor
            close all force;
        end
        
        %T1.1.10.2 Test FloorLightoff2()
        function test_FloorLightoff2(testCase)
            testCase.Eleversion.ctrl.lightPowerOff(1,1);
            pause(5);
            
            testCase.Eleversion.ctrl.F1.Up.BackgroundColor
            close all force;
        end
        
        %T1.1.10.3 Test FloorLightoff3()
        function test_FloorLightoff3(testCase)
            testCase.Eleversion.ctrl.lightPowerOff(1,0);
            pause(5);
            
            testCase.Eleversion.ctrl.F1.B.BackgroundColor
            close all force;
        end
        
        %T1.1.10.4 Test FloorLightoff4()
        function test_FloorLightoff4(testCase)
            testCase.Eleversion.ctrl.lightPowerOff(2,1);
            pause(5);
            
            testCase.Eleversion.ctrl.F2.Up.BackgroundColor
            close all force;
        end
        
        %T1.1.10.5 Test FloorLightoff5()
        function test_FloorLightoff5(testCase)
            testCase.Eleversion.ctrl.lightPowerOff(2,0);
            pause(5);
            
            testCase.Eleversion.ctrl.F2.B.BackgroundColor
            close all force;
        end
        
        %T1.1.10.6 Test FloorLightoff6()
        function test_FloorLightoff6(testCase)
            testCase.Eleversion.ctrl.lightPowerOff(2,-1);
            pause(5);
            
            testCase.Eleversion.ctrl.F2.Down.BackgroundColor
            close all force;
        end
        
        %T1.1.10.7 Test FloorLightoff7()
        function test_FloorLightoff7(testCase)
            testCase.Eleversion.ctrl.lightPowerOff(3,0);
            pause(5);
            
            testCase.Eleversion.ctrl.F3.B.BackgroundColor
            close all force;
        end
        
        %T1.1.10.8 Test FloorLightoff8()
        function test_FloorLightoff8(testCase)
            testCase.Eleversion.ctrl.lightPowerOff(3,-1);
            pause(5);
            
            testCase.Eleversion.ctrl.F3.Down.BackgroundColor
            close all force;
        end
        
        %T1.1.11.1 Test addElevatorRequest1()
        function test_addElevatorRequest1(testCase)
            testCase.Eleversion.ctrl.elevators(1).y = 3;
            testCase.Eleversion.ctrl.addElevatorRequest(1,1);
            pause(5);
            
            testCase.Eleversion.ctrl.Lui.L_1.BackgroundColor
            close all force;
        end
        
        %T1.1.11.2 Test addElevatorRequest2()
        function test_addElevatorRequest2(testCase)
            testCase.Eleversion.ctrl.elevators(1).y = 2;
            testCase.Eleversion.ctrl.addElevatorRequest(1,1);
            pause(5);
            
            testCase.Eleversion.ctrl.elevators(1).upService(2)
            close all force;
        end
        
        %T1.1.11.3 Test addElevatorRequest3()
        function test_addElevatorRequest3(testCase)
            testCase.Eleversion.ctrl.elevators(1).y = 4;
            testCase.Eleversion.ctrl.addElevatorRequest(1,1);
            pause(5);
            
            testCase.Eleversion.ctrl.elevators(1).downService(2)
            close all force;
        end
        
        %T1.1.12.1 Test OpenDoor1()
        function test_OpenDoor1(testCase)
            testCase.Eleversion.ctrl.elevators(1).doortimer = 20;
            testCase.Eleversion.ctrl.OpenDoor(testCase.Eleversion.ctrl.elevators(1));
            pause(5);
            
            testCase.Eleversion.ctrl.elevators(1).doorState
            close all force;
        end
        
        %T1.1.12.2 Test OpenDoor2()
        function test_OpenDoor2(testCase)
            testCase.Eleversion.ctrl.elevators(1).doortimer = 10;
            testCase.Eleversion.ctrl.elevators(1).v = 0;
            testCase.Eleversion.ctrl.elevators(1).doorSize = 25;
            testCase.Eleversion.ctrl.elevators(1).doorState = 'Opening';
            testCase.Eleversion.ctrl.OpenDoor(testCase.Eleversion.ctrl.elevators(1));
            pause(5);
            
            testCase.Eleversion.ctrl.elevators(1).doorSize
            close all force;
        end
        
        %T1.1.12.3 Test OpenDoor3()
        function test_OpenDoor3(testCase)
            testCase.Eleversion.ctrl.elevators(1).doortimer = 10;
            testCase.Eleversion.ctrl.elevators(1).v = 0;
            testCase.Eleversion.ctrl.elevators(1).doorSize = 0;
            testCase.Eleversion.ctrl.OpenDoor(testCase.Eleversion.ctrl.elevators(1));
            pause(5);
            
            testCase.Eleversion.ctrl.elevators(1).doorState
            testCase.Eleversion.ctrl.elevators(1).doortimer
            close all force;
        end
        
        %T1.1.13.1 Test CloseDoor1()
        function test_CloseDoor1(testCase)
            testCase.Eleversion.ctrl.elevators(1).doorState = 'Closing';
            testCase.Eleversion.ctrl.elevators(1).v = 0;
            testCase.Eleversion.ctrl.elevators(1).doorSize = 25;
            testCase.Eleversion.ctrl.OpenDoor(testCase.Eleversion.ctrl.elevators(1));
            pause(5);
            
            testCase.Eleversion.ctrl.elevators(1).doorSize
            close all force;
        end
        
        %T1.1.13.2 Test CloseDoor2()
        function test_CloseDoor2(testCase)
            testCase.Eleversion.ctrl.elevators(1).doorSize = 45;
            testCase.Eleversion.ctrl.OpenDoor(testCase.Eleversion.ctrl.elevators(1));
            pause(5);
            
            testCase.Eleversion.ctrl.elevators(1).doorState
            testCase.Eleversion.ctrl.elevators(1).doortimer
            close all force;
        end
        
        %T1.1.14.1 Test LoadUI1()
        function test_LoudUI1(testCase)
            testCase.Eleversion.ctrl.elevators(1).v = 0;
            testCase.Eleversion.ctrl.LoadUI();
            pause(5);
            
            testCase.Eleversion.ctrl.FB.State.Value
            testCase.Eleversion.ctrl.F1.L_State.Value
            testCase.Eleversion.ctrl.F2.L_State.Value
            testCase.Eleversion.ctrl.F3.L_State.Value
            testCase.Eleversion.ctrl.Lui.State.Value
            close all force;
        end
        
        %T1.1.14.2 Test LoadUI2()
        function test_LoudUI2(testCase)
            testCase.Eleversion.ctrl.elevators(1).v = 1;
            testCase.Eleversion.ctrl.elevators(1).vdir = 2;
            testCase.Eleversion.ctrl.LoadUI();
            pause(5);
            
            testCase.Eleversion.ctrl.FB.State.Value
            testCase.Eleversion.ctrl.F1.L_State.Value
            testCase.Eleversion.ctrl.F2.L_State.Value
            testCase.Eleversion.ctrl.F3.L_State.Value
            testCase.Eleversion.ctrl.Lui.State.Value
            close all force;
        end
        
         %T1.1.14.3 Test LoadUI3()
        function test_LoudUI3(testCase)
            testCase.Eleversion.ctrl.elevators(1).v = 1;
            testCase.Eleversion.ctrl.elevators(1).vdir = -2;
            testCase.Eleversion.ctrl.LoadUI();
            pause(5);
            
            testCase.Eleversion.ctrl.FB.State.Value
            testCase.Eleversion.ctrl.F1.L_State.Value
            testCase.Eleversion.ctrl.F2.L_State.Value
            testCase.Eleversion.ctrl.F3.L_State.Value
            testCase.Eleversion.ctrl.Lui.State.Value
            close all force;
        end
        
        %T1.1.14.4 Test LoadUI4()
        function test_LoudUI4(testCase)
            testCase.Eleversion.ctrl.elevators(2).v = 0;
            testCase.Eleversion.ctrl.LoadUI();
            pause(5);
            
            testCase.Eleversion.ctrl.FB.State.Value
            testCase.Eleversion.ctrl.F1.R_State.Value
            testCase.Eleversion.ctrl.F2.R_State.Value
            testCase.Eleversion.ctrl.F3.R_State.Value
            testCase.Eleversion.ctrl.Rui.State.Value
            close all force;
        end
        
        %T1.1.14.5 Test LoadUI5()
        function test_LoudUI5(testCase)
            testCase.Eleversion.ctrl.elevators(2).v = 1;
            testCase.Eleversion.ctrl.elevators(2).vdir = 2;
            testCase.Eleversion.ctrl.LoadUI();
            pause(5);
            
            testCase.Eleversion.ctrl.FB.State.Value
            testCase.Eleversion.ctrl.F1.R_State.Value
            testCase.Eleversion.ctrl.F2.R_State.Value
            testCase.Eleversion.ctrl.F3.R_State.Value
            testCase.Eleversion.ctrl.Rui.State.Value
            close all force;
        end
        
        %T1.1.14.6 Test LoadUI6()
        function test_LoudUI6(testCase)
            testCase.Eleversion.ctrl.elevators(2).v = 1;
            testCase.Eleversion.ctrl.elevators(2).vdir = -2;
            testCase.Eleversion.ctrl.LoadUI();
            pause(5);
            
            testCase.Eleversion.ctrl.FB.State.Value
            testCase.Eleversion.ctrl.F1.R_State.Value
            testCase.Eleversion.ctrl.F2.R_State.Value
            testCase.Eleversion.ctrl.F3.R_State.Value
            testCase.Eleversion.ctrl.Rui.State.Value
            close all force;
        end
        
        %T1.1.14.7 Test LoadUI7()
        function test_LoudUI7(testCase)
            testCase.Eleversion.ctrl.elevators(1).y = 1;
            testCase.Eleversion.ctrl.LoadUI();
            pause(5);
            
            testCase.Eleversion.ctrl.F3.LD.Value
            testCase.Eleversion.ctrl.F2.LD.Value
            testCase.Eleversion.ctrl.F1.LD.Value
            testCase.Eleversion.ctrl.FB.LD.Value
            testCase.Eleversion.ctrl.Lui.LeftDisplayer.Value
            close all force;
        end
        
        %T1.1.14.8 Test LoadUI8()
        function test_LoudUI8(testCase)
            testCase.Eleversion.ctrl.elevators(1).y = 2;
            testCase.Eleversion.ctrl.LoadUI();
            pause(5);
            
            testCase.Eleversion.ctrl.F3.LD.Value
            testCase.Eleversion.ctrl.F2.LD.Value
            testCase.Eleversion.ctrl.F1.LD.Value
            testCase.Eleversion.ctrl.FB.LD.Value
            testCase.Eleversion.ctrl.Lui.LeftDisplayer.Value
            close all force;
        end
        
        %T1.1.14.9 Test LoadUI9()
        function test_LoudUI9(testCase)
            testCase.Eleversion.ctrl.elevators(1).y = 6;
            testCase.Eleversion.ctrl.LoadUI();
            pause(5);
            
            testCase.Eleversion.ctrl.F3.LD.Value
            testCase.Eleversion.ctrl.F2.LD.Value
            testCase.Eleversion.ctrl.F1.LD.Value
            testCase.Eleversion.ctrl.FB.LD.Value
            testCase.Eleversion.ctrl.Lui.LeftDisplayer.Value
            close all force;
        end
        
        %T1.1.14.10 Test LoadUI10()
        function test_LoudUI10(testCase)
            testCase.Eleversion.ctrl.elevators(1).y = 8;
            testCase.Eleversion.ctrl.LoadUI();
            pause(5);
            
            testCase.Eleversion.ctrl.F3.LD.Value
            testCase.Eleversion.ctrl.F2.LD.Value
            testCase.Eleversion.ctrl.F1.LD.Value
            testCase.Eleversion.ctrl.FB.LD.Value
            testCase.Eleversion.ctrl.Lui.LeftDisplayer.Value
            close all force;
        end
        
        %T1.1.14.11 Test LoadUI11()
        function test_LoudUI11(testCase)
            testCase.Eleversion.ctrl.elevators(2).y = 4;
            testCase.Eleversion.ctrl.LoadUI();
            pause(5);
            
            testCase.Eleversion.ctrl.F3.RD.Value
            testCase.Eleversion.ctrl.F2.RD.Value
            testCase.Eleversion.ctrl.F1.RD.Value
            testCase.Eleversion.ctrl.Rui.RightDisplayer.Value
            close all force;
        end
        
        %T1.1.14.12 Test LoadUI12()
        function test_LoudUI12(testCase)
            testCase.Eleversion.ctrl.elevators(2).y = 6;
            testCase.Eleversion.ctrl.LoadUI();
            pause(5);
            
            testCase.Eleversion.ctrl.F3.RD.Value
            testCase.Eleversion.ctrl.F2.RD.Value
            testCase.Eleversion.ctrl.F1.RD.Value
            testCase.Eleversion.ctrl.Rui.RightDisplayer.Value
            close all force;
        end
        
        %T1.1.14.13 Test LoadUI13()
        function test_LoudUI13(testCase)
            testCase.Eleversion.ctrl.elevators(2).y = 8;
            testCase.Eleversion.ctrl.LoadUI();
            pause(5);
            
            testCase.Eleversion.ctrl.F3.RD.Value
            testCase.Eleversion.ctrl.F2.RD.Value
            testCase.Eleversion.ctrl.F1.RD.Value
            testCase.Eleversion.ctrl.Rui.RightDisplayer.Value
            close all force;
        end
        
        %T1.2.1 Test Elevator()
        function test_elevator(testCase)
            testCase.Eleversion.ctrl;
            pause(5);
            
            testCase.Eleversion.ctrl.elevators(2).id
            testCase.Eleversion.ctrl.elevators(2).y
            testCase.Eleversion.ctrl.elevators(2).v
            testCase.Eleversion.ctrl.elevators(2).vdir
            testCase.Eleversion.ctrl.elevators(2).adir
            testCase.Eleversion.ctrl.elevators(2).a 
            testCase.Eleversion.ctrl.elevators(2).floor 
            testCase.Eleversion.ctrl.elevators(2).nextTarget
            testCase.Eleversion.ctrl.elevators(2).moveState
            testCase.Eleversion.ctrl.elevators(2).serviceState
            testCase.Eleversion.ctrl.elevators(2).upService
            testCase.Eleversion.ctrl.elevators(2).downService
            testCase.Eleversion.ctrl.elevators(2).doorState
            testCase.Eleversion.ctrl.elevators(2).doorSize 
            testCase.Eleversion.ctrl.elevators(2).doortimer
            close all force;
        end
        
        %T1.2.2 Test move()
        function test_move(testCase)
            testCase.Eleversion.ctrl;
            testCase.Eleversion.ctrl.elevators(2).y = 3;
            testCase.Eleversion.ctrl.elevators(2).vdir = 1;
            testCase.Eleversion.ctrl.elevators(2).v = 1;
            testCase.Eleversion.ctrl.elevators(2).adir = 2;
            testCase.Eleversion.ctrl.elevators(2).a = 0.5;
            testCase.Eleversion.ctrl.elevators(2).move;
            pause(5);
            
            testCase.Eleversion.ctrl.elevators(2).y
            testCase.Eleversion.ctrl.elevators(2).v
            close all force;
        end
        
        %T1.2.3.1 Test update()
        function test_update1(testCase)
            testCase.Eleversion.ctrl;
            testCase.Eleversion.ctrl.elevators(2).moveState = 'Start';
            testCase.Eleversion.ctrl.elevators(2).vdir = 1;
            testCase.Eleversion.ctrl.elevators(2).update;
            pause(5);
            
            testCase.Eleversion.ctrl.elevators(2).adir
            testCase.Eleversion.ctrl.elevators(2).a
            close all force;
        end
        
        %T1.2.3.2 Test update2()
        function test_update2(testCase)
            testCase.Eleversion.ctrl;
            testCase.Eleversion.ctrl.elevators(2).moveState = 'Stop';
            testCase.Eleversion.ctrl.elevators(2).vdir = 1;
            testCase.Eleversion.ctrl.elevators(2).update;
            pause(5);
            
            testCase.Eleversion.ctrl.elevators(2).adir
            testCase.Eleversion.ctrl.elevators(2).a
            close all force;
        end
        
        %T1.2.3.3 Test update3()
        function test_update3(testCase)
            testCase.Eleversion.ctrl;
            testCase.Eleversion.ctrl.elevators(2).moveState = 'Run';
            testCase.Eleversion.ctrl.elevators(2).update;
            pause(5);
            
            testCase.Eleversion.ctrl.elevators(2).v
            testCase.Eleversion.ctrl.elevators(2).a
            close all force;
        end
        
         %T1.2.3.4 Test update4()
        function test_update4z(testCase)
            testCase.Eleversion.ctrl;
            testCase.Eleversion.ctrl.elevators(2).moveState = 'Standby';
            testCase.Eleversion.ctrl.elevators(2).update;
            pause(5);
            
            testCase.Eleversion.ctrl.elevators(2).v
            testCase.Eleversion.ctrl.elevators(2).a
            close all force;
        end
        
         %T1.3.1.1 Test loadui()
        function test_eleloadui1(testCase)
            testCase.Eleversion.ctrl.elevators(1).y = 1;
            testCase.Eleversion.ctrl.Version.LoadUI;
            pause(5);
            
            testCase.Eleversion.ctrl.Version.LeftDisplayer.Value
            close all force;
        end
        
        %T1.3.1.2 Test loadui()
        function test_eleloadui2(testCase)
            testCase.Eleversion.ctrl.elevators(1).y = 3;
            testCase.Eleversion.ctrl.Version.LoadUI;
            pause(5);
            
            testCase.Eleversion.ctrl.Version.LeftDisplayer.Value
            close all force;
        end
        
        %T1.3.1.3 Test loadui()
        function test_eleloadui3(testCase)
            testCase.Eleversion.ctrl.elevators(1).y = 6;
            testCase.Eleversion.ctrl.Version.LoadUI;
            pause(5);
            
            testCase.Eleversion.ctrl.Version.LeftDisplayer.Value
            close all force;
        end
        
        %T1.3.1.4 Test loadui()
        function test_eleloadui4(testCase)
            testCase.Eleversion.ctrl.elevators(1).y = 8;
            testCase.Eleversion.ctrl.Version.LoadUI;
            pause(5);
            
            testCase.Eleversion.ctrl.Version.LeftDisplayer.Value
            close all force;
        end
        
        %T1.3.1.5 Test loadui()
        function test_eleloadui5(testCase)
            testCase.Eleversion.ctrl.elevators(2).y = 4;
            testCase.Eleversion.ctrl.Version.LoadUI;
            pause(5);
            
            testCase.Eleversion.ctrl.Version.RightDisplayer.Value
            close all force;
        end
        
        %T1.3.1.6 Test loadui()
        function test_eleloadui6(testCase)
            testCase.Eleversion.ctrl.elevators(2).y = 6;
            testCase.Eleversion.ctrl.Version.LoadUI;
            pause(5);
            
            testCase.Eleversion.ctrl.Version.RightDisplayer.Value
            close all force;
        end
        
        %T1.3.1.7 Test loadui()
        function test_eleloadui7(testCase)
            testCase.Eleversion.ctrl.elevators(2).y = 8;
            testCase.Eleversion.ctrl.Version.LoadUI;
            pause(5);
            
            testCase.Eleversion.ctrl.Version.RightDisplayer.Value
            close all force;
        end
        
        %T1.3.2 Test delete()
        function test_eledelete(testCase)
            testCase.Eleversion.ctrl;
            
            close all force;
        end
        
        %T1.4.1 Test bbuttonpush()
        function test_F1ui_bbutton(testCase)
            testCase.press(testCase.Eleversion.ctrl.F1.B);
            pause(5);
            
            testCase.Eleversion.ctrl.F1.B.BackgroundColor
            close all force;
        end
        
        %T1.4.2 Test upbuttonpush()
        function test_F1ui_upbutton(testCase)
            testCase.press(testCase.Eleversion.ctrl.F1.Up);
            pause(5);
            
            testCase.Eleversion.ctrl.F1.Up.BackgroundColor
            close all force;
        end
        
        %T1.5.1 Test bbuttonpush()
        function test_F2ui_bbutton(testCase)
            testCase.press(testCase.Eleversion.ctrl.F2.B);
            pause(5);
            
            testCase.Eleversion.ctrl.F2.B.BackgroundColor
            close all force;
        end
        
        %T1.5.2 Test upbuttonpush()
        function test_F2ui_ipbutton(testCase)
            testCase.press(testCase.Eleversion.ctrl.F2.Up);
            pause(5);
            
            testCase.Eleversion.ctrl.F2.Up.BackgroundColor
            close all force;
        end
        
        %T1.5.3 Test downbuttonpush()
        function test_F2ui_downbutton(testCase)
            testCase.press(testCase.Eleversion.ctrl.F2.Down);
            pause(5);
            
            testCase.Eleversion.ctrl.F2.Down.BackgroundColor
            close all force;
        end
        
        %T1.6.1 Test bbuttonpush()
        function test_F3ui_bbutton(testCase)
            testCase.press(testCase.Eleversion.ctrl.F3.B);
            pause(5);
            
            testCase.Eleversion.ctrl.F3.B.BackgroundColor
            close all force;
        end
        
        %T1.6.2 Test upbuttonpush()
        function test_F3ui_downbutton(testCase)
            testCase.press(testCase.Eleversion.ctrl.F3.Down);
            pause(5);
            
            testCase.Eleversion.ctrl.F3.Down.BackgroundColor
            close all force;
        end
        
        %T1.7.1 Test upbuttonpush()
        function test_Fbui_upbutton(testCase)
            testCase.press(testCase.Eleversion.ctrl.FB.Up);
            pause(5);
            
            testCase.Eleversion.ctrl.FB.Up.BackgroundColor
            close all force;
        end
        
        %T1.8.1 Test lobuttonpush()
        function test_lobutton(testCase)
            testCase.Eleversion.ctrl.elevators(1).v = 0;
            testCase.press(testCase.Eleversion.ctrl.Lui.L_O);
            pause(5);
            
            testCase.Eleversion.ctrl.elevators(1).doorState
            close all force;
        end
        
        %T1.8.2 Test lcbuttonpush()
        function test_lcbutton(testCase)
            testCase.Eleversion.ctrl.elevators(1).doorState = 'Opened';
            testCase.press(testCase.Eleversion.ctrl.Lui.L_C);
            pause(5);
            
            testCase.Eleversion.ctrl.elevators(1).doorState
            close all force;
        end
        
        %T1.8.3 Test l1buttonpush()
        function test_l1button(testCase)
            testCase.press(testCase.Eleversion.ctrl.Lui.L_1);
            pause(5);
            
            testCase.Eleversion.ctrl.Lui.L_1.BackgroundColor
            close all force;
        end
        
        %T1.8.4 Test l2buttonpush()
        function test_l2button(testCase)
            testCase.press(testCase.Eleversion.ctrl.Lui.L_2);
            pause(5);
            
            testCase.Eleversion.ctrl.Lui.L_2.BackgroundColor
            close all force;
        end
        
        %T1.8.5 Test l3buttonpush()
        function test_l3button(testCase)
            testCase.press(testCase.Eleversion.ctrl.Lui.L_3);
            pause(5);
            
            testCase.Eleversion.ctrl.Lui.L_3.BackgroundColor
            close all force;
        end
        
        %T1.8.6 Test lBbuttonpush()
        function test_lBbutton(testCase)
            testCase.press(testCase.Eleversion.ctrl.Lui.L_B);
            pause(5);
            
            testCase.Eleversion.ctrl.Lui.L_B.BackgroundColor
            close all force;
        end
        
        %T1.9.1 Test r3buttonpush()
        function test_r3button(testCase)
            testCase.press(testCase.Eleversion.ctrl.Rui.R_3);
            pause(5);
            
            testCase.Eleversion.ctrl.Lui.R_3.BackgroundColor
            close all force;
        end
        
        %T1.9.2 Test r2buttonpush()
        function test_r2button(testCase)
            testCase.press(testCase.Eleversion.ctrl.Rui.R_2);
            pause(5);
            
            testCase.Eleversion.ctrl.Lui.R_2.BackgroundColor
            close all force;
        end
        
        %T1.9.3 Test r1buttonpush()
        function test_r1button(testCase)
            testCase.press(testCase.Eleversion.ctrl.Rui.R_1);
            pause(5);
            
            testCase.Eleversion.ctrl.Lui.R_1.BackgroundColor
            close all force;
        end
       
         %T1.9.4 Test robuttonpush()
        function test_robutton(testCase)
            testCase.Eleversion.ctrl.elevators(2).v = 0;
            testCase.press(testCase.Eleversion.ctrl.Rui.R_O);
            pause(5);
            
            testCase.Eleversion.ctrl.elevators(2).doorState
            close all force;
        end
        
        %T1.9.5 Test rcbuttonpush()
        function test_rcbutton(testCase)
            testCase.Eleversion.ctrl.elevators(2).doorState = 'Opened';
            testCase.press(testCase.Eleversion.ctrl.Rui.R_C);
            pause(5);
            
            testCase.Eleversion.ctrl.elevators(2).doorState
            close all force;
        end
        
        %T2.1 Integration Test
        function inte_test(testCase)
            testCase.press(testCase.Eleversion.ctrl.FB.Up);
            testCase.press(testCase.Eleversion.ctrl.F3.Down);
            testCase.press(testCase.Eleversion.ctrl.F1.Up);
            testCase.press(testCase.Eleversion.ctrl.F1.B);
            testCase.press(testCase.Eleversion.ctrl.F2.Up);
            pause(40);

            close all force;
        end
        
        %T3.2.1 usecase Test
        function usecasetest21(testCase)
            testCase.press(testCase.Eleversion.ctrl.F2.B);
            pause(10);
            
            close all force;
        end
        
        %T3.2.2 usecase Test
        function usecasetest22(testCase)
            testCase.press(testCase.Eleversion.ctrl.F2.Up);
            pause(10);

            close all force;
        end
        
        %T3.2.3 usecase Test
        function usecasetest23(testCase)
            testCase.press(testCase.Eleversion.ctrl.F2.Down);
            pause(10);

            close all force;
        end
        
        %T3.3.1 usecase Test
        function usecasetest31(testCase)
            testCase.press(testCase.Eleversion.ctrl.Lui.L_B);
            pause(10);

            close all force;
        end
        
        %T3.3.2 usecase Test
        function usecasetest32(testCase)
            testCase.Eleversion.ctrl.elevators(1).y = 6;
            testCase.press(testCase.Eleversion.ctrl.Lui.L_1);
            pause(10);

            close all force;
        end
        
        %T3.3.3 usecase Test
        function usecasetest33(testCase)
            testCase.press(testCase.Eleversion.ctrl.Lui.L_2);
            pause(10);

            close all force;
        end
        
        %T3.3.4 usecase Test
        function usecasetest34(testCase)
            testCase.press(testCase.Eleversion.ctrl.Lui.L_3);
            pause(10);

            close all force;
        end
        
         %T3.4 usecase Test
        function usecasetest4(testCase)
            testCase.press(testCase.Eleversion.ctrl.Lui.L_O);
            pause(5);

            close all force;
        end
        
        %T3.4 usecase Test
        function usecasetest5(testCase)
            testCase.press(testCase.Eleversion.ctrl.Lui.L_O);
            pause(1);
            testCase.press(testCase.Eleversion.ctrl.Lui.L_C);
            pause(5);
            
            close all force;
        end
    end    
end