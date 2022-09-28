//This file was generated from (Academic) UPPAAL 4.1.25-5 (rev. 643E9477AA51E17F), April 2021

/*

*/
E<> (Elevator1.stairleft==0)

/*

*/
E<> (Elevator1.stairleft==1)

/*

*/
E<> (Elevator1.stairleft==2)

/*

*/
E<> (Elevator1.stairleft==3)

/*

*/
E<> (Elevator2.stairright==1)

/*

*/
E<> (Elevator2.stairright==2)

/*

*/
E<> (Elevator2.stairright==3)

/*

*/
A[] (Elevator2.stairright != 0)

/*

*/
A[] (Elevator2.stairright != 4)

/*

*/
A[] (Elevator1.stairleft != 4)

/*

*/
A[] !(Elevator1.downleft == 1 && Elevator1.upleft == 1)||(Elevator1.downleft==1 && Elevator1.stayleft==1)||(Elevator1.upleft==1 && Elevator1.stayleft==1)

/*

*/
A[] !(Elevator2.downright==1 && Elevator2.upright==1)||(Elevator2.downright==1 && Elevator2.stayright==1)||(Elevator2.upright==1 && Elevator2.stayright==1)

/*

*/
A[] !(FB.opendoor && F1.leftdooropen)||(FB.opendoor && F2.leftdooropen)||(FB.opendoor && F3.leftdooropen)||(F1.leftdooropen && F2.leftdooropen)||(F1.leftdooropen && F3.leftdooropen)||(F2.leftdooropen && F3.leftdooropen)

/*

*/
A[] !(F1.rightdooropen && F2.rightdooropen)||(F1.rightdooropen && F3.rightdooropen)||(F2.rightdooropen && F3.rightdooropen)
