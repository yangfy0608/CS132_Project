classdef VenderController_test < matlab.uitest.TestCase
    properties
        ctrl
        mb
        mdb
        uapp
        mapp
    end
    
    
    methods (TestMethodSetup)
        function launchApp(testCase)
            testCase.ctrl = VenderController;
            testCase.mb=MoneyBox;
            testCase.mdb=MerchandiseDB;
            
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
        end
    end
    
    methods (Test)
        function test_createPayment(testCase)% testcase 1.5.1
            mer = Merchandise('Tea', 5, 10);
            testCase.ctrl.createPayment(mer);
            testCase.verifyEqual(testCase.ctrl.payment.name , 'Tea');
            testCase.verifyEqual(testCase.ctrl.payment.price , 5);
            testCase.verifyEqual(testCase.ctrl.payment.status , 'Created');
            stop(timerfind);
            delete(timerfind);
            close all force;
        end
        
        function test_cancelPayment(testCase)% testcase 1.5.2
            testCase.ctrl.cancelPayment;% testcase 1.5.2.1
            mer = Merchandise('Tea', 5, 10);
            testCase.ctrl.createPayment(mer);
            testCase.verifyEqual(testCase.ctrl.payment.status , 'Created');
            testCase.ctrl.cancelPayment; % testcase 1.5.2.2
            close all force;
        end
        
        function test_addPaymentRecord(testCase)
            mer = Merchandise('Tea', 5, 10);% testcase 1.5.3
            testCase.ctrl.createPayment(mer);
            testCase.ctrl.addPaymentRecord;
            testCase.verifyEqual(testCase.ctrl.maintainerApp.OrderRecordTable.Data(2),  {'Tea'});
            testCase.verifyEqual(testCase.ctrl.maintainerApp.OrderRecordTable.Data(3),  {'5.0'});
            testCase.verifyEqual(testCase.ctrl.maintainerApp.OrderRecordTable.Data(4),  {'Created'});
            stop(timerfind);
            delete(timerfind);
            pause(2);
            close all force;
        end
        
        function test_addMerchandise(testCase)
            mer = '';% testcase 1.5.4.1
            testCase.ctrl.addMerchandise(mer);
            mer = 'Tea';% testcase 1.5.4.2
            testCase.ctrl.addMerchandise(mer);
            list =retrieve(testCase.ctrl.merchandiseDB);
            testCase.verifyEqual(list(5).name,'Tea');
            pause(2);
            close all force;
        end
        
        function test_updateMerchandise(testCase)
            mer = 'Tea';% testcase 1.5.5
            testCase.ctrl.addMerchandise(mer);
            testCase.ctrl.updateMerchandise(mer, 15, 10);
            list =retrieve(testCase.ctrl.merchandiseDB);
            testCase.verifyEqual(list(5).name,'Tea');
            testCase.verifyEqual(list(5).price,15);
            testCase.verifyEqual(list(5).quantity,10);
            pause(2);
            close all force;
        end
        
        function test_sellMerchandise(testCase)
            mer = 'Tea';% testcase 1.5.6
            testCase.ctrl.addMerchandise(mer);
            testCase.ctrl.updateMerchandise(mer, 15, 10);
            testCase.ctrl.sellMerchandise(mer);
            list =retrieve(testCase.ctrl.merchandiseDB);
            testCase.verifyEqual(list(5).quantity,9);
            pause(2);
            close all force;
        end
        
        function test_updateCoins(testCase)
            testCase.ctrl.updateCoins([10 30]);% testcase 1.5.7
            testCase.verifyEqual(testCase.ctrl.moneyBox.getCoins,[10 30]);
            pause(2);
            close all force;
        end
        
        function test_addCoins(testCase)
            testCase.ctrl.addCoins([0 10]);% testcase 1.5.8
            testCase.verifyEqual(testCase.ctrl.moneyBox.getCoins,[50 60]);
            pause(2);
            close all force;
        end
        
        function test_updateCash(testCase)
            testCase.ctrl.updateCash([10 30 20 0]);% testcase 1.5.9
            testCase.verifyEqual(testCase.ctrl.moneyBox.getCash,[10 30 20 0]);
            pause(2);
            close all force;
        end
        
        function test_addCash(testCase)
            testCase.ctrl.addCash([10 10 5 5]);% testcase 1.5.10
            testCase.verifyEqual(testCase.ctrl.moneyBox.getCash,[40 40 35 5]);
            pause(2);
            close all force;
        end
        
        function test_giveChange(testCase)% testcase 1.5.11
            changeMoney =  testCase.ctrl.giveChange(2);% testcase 1.5.11.1
            testCase.verifyEqual(changeMoney,[0     2     0     0     0     0]);
            
            changeMoney =  testCase.ctrl.giveChange(7.5);% testcase 1.5.11.2
            testCase.verifyEqual(changeMoney,[1     2     0     1     0     0]);
            
            changeMoney =  testCase.ctrl.giveChange(18.5);% testcase 1.5.11.3
            testCase.verifyEqual(changeMoney,[1     3     0     1     1     0]);
            
            changeMoney =  testCase.ctrl.giveChange(12.5);% testcase 1.5.11.4
            testCase.verifyEqual(changeMoney,[1     2     0     0     1     0]);
            
            changeMoney =  testCase.ctrl.giveChange(15);% testcase 1.5.11.5
            testCase.verifyEqual(changeMoney,[0     0     0     1     1    0]);
            
            testCase.ctrl.addCash([0 0 5 20]);
            changeMoney =  testCase.ctrl.giveChange(3.5);% testcase 1.5.11.6
            testCase.verifyEqual(changeMoney,[1     3     0     0     0    0]);
            close all force;
        end
        
        function test_MerchandiseSelectionValueChanged(testCase)
            testCase.choose(testCase.ctrl.userApp.MerchandiseSelection,'Fanta');% testcase1.6.1 
            testCase.press(testCase.ctrl.userApp.ConfirmButton);
            testCase.verifyEqual(testCase.ctrl.payment.name,'Fanta');
            stop(timerfind);
            delete(timerfind);
            close all force;
        end
        function test_ConfirmButtonPushed(testCase)
            testCase.choose(testCase.ctrl.userApp.MerchandiseSelection,'Fanta');
            testCase.press(testCase.ctrl.userApp.ConfirmButton);% testcase1.6.2
            testCase.verifyEqual(testCase.ctrl.payment.name,'Fanta');
            stop(timerfind);
            delete(timerfind);
            close all force;
        end
        function test_CoinInsertButtonPushed_1(testCase)% testcase1.6.3.1
            testCase.choose(testCase.ctrl.userApp.MerchandiseSelection,'Fanta');
            testCase.press(testCase.ctrl.userApp.ConfirmButton);
            testCase.choose(testCase.ctrl.userApp.CoinSelection,'0.5￥');
            testCase.press(testCase.ctrl.userApp.CoinInsertButton);
            testCase.verifyEqual(testCase.ctrl.moneyBox.getCoins,[51 50]);
            stop(timerfind);
            delete(timerfind);
            close all force;
        end
        function test_CoinInsertButtonPushed_2(testCase)% testcase1.6.3.2
            testCase.choose(testCase.ctrl.userApp.MerchandiseSelection,'Fanta');
            testCase.press(testCase.ctrl.userApp.ConfirmButton);
            testCase.choose(testCase.ctrl.userApp.CoinSelection,'1￥');
            testCase.press(testCase.ctrl.userApp.CoinInsertButton);
            testCase.verifyEqual(testCase.ctrl.moneyBox.getCoins,[50 51]);
            stop(timerfind);
            delete(timerfind);
            close all force;
        end
        function test_CoinInsertButtonPushed_3(testCase)% testcase1.6.3.3
            testCase.choose(testCase.ctrl.userApp.MerchandiseSelection,'Fanta');
            testCase.press(testCase.ctrl.userApp.ConfirmButton);
            testCase.choose(testCase.ctrl.userApp.CoinSelection,'Fake Coin');
            testCase.press(testCase.ctrl.userApp.CoinInsertButton);
            testCase.verifyEqual(testCase.ctrl.userApp.ReturnButton.UserData(7),1);
            stop(timerfind);
            delete(timerfind);
            close all force;
        end
        function test_CashInsertButtonPushed_1(testCase)% testcase1.6.4.1
            testCase.choose(testCase.ctrl.userApp.MerchandiseSelection,'Fanta');
            testCase.press(testCase.ctrl.userApp.ConfirmButton);
            testCase.choose(testCase.ctrl.userApp.CashSelection,'1￥');
            testCase.press(testCase.ctrl.userApp.CashInsertButton);
            testCase.verifyEqual(testCase.ctrl.moneyBox.getCash,[31 30 30 0]);
            stop(timerfind);
            delete(timerfind);
            close all force;
        end
        function test_CashInsertButtonPushed_2(testCase)% testcase1.6.4.2
            testCase.choose(testCase.ctrl.userApp.MerchandiseSelection,'Fanta');
            testCase.press(testCase.ctrl.userApp.ConfirmButton);
            testCase.choose(testCase.ctrl.userApp.CashSelection,'5￥');
            testCase.press(testCase.ctrl.userApp.CashInsertButton);
            testCase.verifyEqual(testCase.ctrl.moneyBox.getCash,[30 31 30 0]);
            
            close all force;
        end
        function test_CashInsertButtonPushed_3(testCase)% testcase1.6.4.3
            testCase.choose(testCase.ctrl.userApp.MerchandiseSelection,'Fanta');
            testCase.press(testCase.ctrl.userApp.ConfirmButton);
            testCase.choose(testCase.ctrl.userApp.CashSelection,'10￥');
            testCase.press(testCase.ctrl.userApp.CashInsertButton);
            testCase.verifyEqual(testCase.ctrl.moneyBox.getCash,[30 29 31 0]);
            
            close all force;
        end
        function test_CashInsertButtonPushed_4(testCase)% testcase1.6.4.4
            testCase.choose(testCase.ctrl.userApp.MerchandiseSelection,'Fanta');
            testCase.press(testCase.ctrl.userApp.ConfirmButton);
            testCase.choose(testCase.ctrl.userApp.CashSelection,'20￥');
            testCase.press(testCase.ctrl.userApp.CashInsertButton);
            testCase.verifyEqual(testCase.ctrl.moneyBox.getCash,[30 29 29 1]);
            
            close all force;
        end
        function test_CashInsertButtonPushed_5(testCase)% testcase1.6.4.5
            testCase.choose(testCase.ctrl.userApp.MerchandiseSelection,'Fanta');
            testCase.press(testCase.ctrl.userApp.ConfirmButton);
            testCase.choose(testCase.ctrl.userApp.CashSelection,'Fake Cash');
            testCase.press(testCase.ctrl.userApp.CashInsertButton);
            testCase.verifyEqual(testCase.ctrl.userApp.ReturnButton.UserData(7),1);
            stop(timerfind);
            delete(timerfind);
            close all force;
        end
        function test_ReturnButtonPushed(testCase)% testcase1.6.5
            testCase.choose(testCase.ctrl.userApp.MerchandiseSelection,'Fanta');
            testCase.press(testCase.ctrl.userApp.ConfirmButton);
            testCase.choose(testCase.ctrl.userApp.CashSelection,'1￥');
            testCase.press(testCase.ctrl.userApp.CashInsertButton);
            testCase.press(testCase.ctrl.userApp.ReturnButton);
            testCase.verifyEqual(testCase.ctrl.moneyBox.getCash,[30 30 30 0]);
            
            close all force;
        end
        function test_AddButtonPushed(testCase)% testcase1.7.1
            testCase.type(testCase.ctrl.maintainerApp.AddEditField,'Tea');
            testCase.press(testCase.ctrl.maintainerApp.AddButton);
            list =retrieve(testCase.ctrl.merchandiseDB);
            testCase.verifyEqual(list(5).name,'Tea');
            close all force;
        end
        function test_MerchandiseTableCellEdit(testCase)% testcase1.7.2
            % for the matlab version problem, i can't directly change value in table
            testCase.ctrl.updateMerchandise('Fanta',4,18);
            list =retrieve(testCase.ctrl.merchandiseDB);
            testCase.verifyEqual(list(2).price,4);
            testCase.verifyEqual(list(2).quantity,18);
            pause(5);
            close all force;
        end
        
        
        
        
        
        function test_Integration_1(testCase)%testcase 2.1
            testCase.choose(testCase.ctrl.userApp.MerchandiseSelection,'Fanta');
            pause(2);
            testCase.press(testCase.ctrl.userApp.ConfirmButton);% testcase2.1
            pause(2);
            testCase.verifyEqual(testCase.ctrl.payment.name,'Fanta');
            testCase.choose(testCase.ctrl.userApp.MerchandiseSelection,'Coke');
            testCase.press(testCase.ctrl.userApp.ConfirmButton);
            testCase.verifyEqual(testCase.ctrl.maintainerApp.OrderRecordTable.Data(2),{'Fanta'});
            testCase.verifyEqual(testCase.ctrl.maintainerApp.OrderRecordTable.Data(4),{'Canceled'});
            pause(2);
            testCase.choose(testCase.ctrl.userApp.CashSelection,'5￥');
            testCase.press(testCase.ctrl.userApp.CashInsertButton);
            pause(2);
            testCase.press(testCase.ctrl.userApp.ReturnButton);
            testCase.verifyEqual(testCase.ctrl.moneyBox.getCoins,[49 49]);
            testCase.verifyEqual(testCase.ctrl.moneyBox.getCash,[30 31 30 0]);
            pause(2);
            close all force;
        end
        function test_Integration_2(testCase)%testcase 2.2
            pause(2);
            testCase.type(testCase.ctrl.maintainerApp.AddEditField,'Tea');
            pause(2);
            testCase.press(testCase.ctrl.maintainerApp.AddButton);
            list =retrieve(testCase.ctrl.merchandiseDB);
            testCase.verifyEqual(list(5).name,'Tea');
            pause(2);
            testCase.ctrl.updateMerchandise('Tea',4.5,31);
            list =retrieve(testCase.ctrl.merchandiseDB);
            testCase.verifyEqual(list(5).price,4.5);
            testCase.verifyEqual(list(5).quantity,30);
            pause(2);
            testCase.ctrl.addCoins([20 0]);
            pause(2)
            testCase.verifyEqual(testCase.ctrl.moneyBox.getCoins,[70 50]);
            testCase.ctrl.addCash([0 10 0 5] );
            pause(2);
            testCase.verifyEqual(testCase.ctrl.moneyBox.getCash,[30 40 30 5]);
            pause(2);
            close all force;
        end
        function test_Functional_1(testCase)%testcase 3.1
            testCase.choose(testCase.ctrl.userApp.MerchandiseSelection,'Fanta');
            pause(2);
            testCase.press(testCase.ctrl.userApp.ConfirmButton);% testcase2.1
            pause(2);
            testCase.verifyEqual(testCase.ctrl.payment.name,'Fanta');
            testCase.choose(testCase.ctrl.userApp.MerchandiseSelection,'Coke');
            testCase.press(testCase.ctrl.userApp.ConfirmButton);
            testCase.verifyEqual(testCase.ctrl.maintainerApp.OrderRecordTable.Data(2),{'Fanta'});
            testCase.verifyEqual(testCase.ctrl.maintainerApp.OrderRecordTable.Data(4),{'Canceled'});
            pause(2);
            stop(timerfind);
            delete(timerfind);
            close all force;
        end
        function test_Functional_2(testCase)%testcase 3.2
            testCase.choose(testCase.ctrl.userApp.MerchandiseSelection,'Coke');
            testCase.press(testCase.ctrl.userApp.ConfirmButton);
            pause(2);
            testCase.choose(testCase.ctrl.userApp.CoinSelection,'1￥');
            testCase.press(testCase.ctrl.userApp.CoinInsertButton);
            testCase.choose(testCase.ctrl.userApp.CashSelection,'5￥');
            testCase.press(testCase.ctrl.userApp.CashInsertButton);
            pause(2);
            testCase.press(testCase.ctrl.userApp.ReturnButton);
            testCase.verifyEqual(testCase.ctrl.moneyBox.getCoins,[49 49]);
            testCase.verifyEqual(testCase.ctrl.moneyBox.getCash,[30 31 30 0]);
            pause(2);
            close all force;
        end
        function test_Functional_3(testCase)%testcase 3.3
            pause(2);
            testCase.type(testCase.ctrl.maintainerApp.AddEditField,'Tea');
            pause(2);
            testCase.press(testCase.ctrl.maintainerApp.AddButton);
            list =retrieve(testCase.ctrl.merchandiseDB);
            testCase.verifyEqual(list(5).name,'Tea');
            pause(2);
            testCase.ctrl.updateMerchandise('Tea',4.5,30);
            list =retrieve(testCase.ctrl.merchandiseDB);
            testCase.verifyEqual(list(5).price,4.5);
            testCase.verifyEqual(list(5).quantity,30);
            pause(2);
            close all force;
        end
        function test_Functional_4(testCase)%testcase 3.4
            
            testCase.ctrl.addCoins([20 -40]);
            pause(2)
            testCase.verifyEqual(testCase.ctrl.moneyBox.getCoins,[70 10]);
            testCase.ctrl.addCash([20 10 -20 5] );
            pause(2);
            testCase.verifyEqual(testCase.ctrl.moneyBox.getCash,[50 40 10 5]);
            pause(2);
            close all force;
        end
    end
    
end