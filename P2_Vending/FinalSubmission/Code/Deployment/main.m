close all
clear all 

mb=MoneyBox;
mdb=MerchandiseDB;
ctrl=VenderController;
uapp=UserUI;
mapp=MaintainerUI;

ctrl.userApp=uapp;
ctrl.maintainerApp=mapp;
ctrl.moneyBox=mb;
ctrl.merchandiseDB=mdb;

mb.controller=ctrl;
mdb.controller=ctrl;
uapp.Controller=ctrl;
mapp.Controller=ctrl;

mapp.Init;
uapp.Init;