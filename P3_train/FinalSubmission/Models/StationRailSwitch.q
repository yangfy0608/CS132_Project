//This file was generated from (Academic) UPPAAL 4.1.24 (rev. 29A3ECA4E5FB0808), November 2019

/*
Exactly one rail is switched or switching to at the same time
*/
A[] (not ctrl.Init) imply Rail0.Switched + Rail0.Switching + Rail1.Switched + Rail1.Switching + Rail2.Switched + Rail2.Switching == 1

/*
All locomotives can always eventually reach the destination
*/
A<> D1.Arrived and K1.Arrived and G1.Arrived

/*
Approaching locomotive can always eventually either pass by or arrive at S1
*/
A<> D1.PassByS1 or D1.ArriveS1

/*
Cumulated delay of all locomotives within deadline
*/
A[] not D1.TimeOut and not K1.TimeOut and not G1.TimeOut

/*
Departuring locomotives always eventually depart as scheduled through the corresponding rail
*/
A[] (K1.Departure imply currentRail==rail[1]) and (G1.Departure imply currentRail==rail[2])

/*
Passing-by D1 can always eventually cross S1 through the main rail
*/
A[] D1.PassByS1 imply currentRail==0 

/*
Arriving locmootive can eventually arrive at S1 at an empty rail
*/
A[] D1.ArriveS1 imply (currentRail==rail[0] and rails[currentRail]==-1)

/*
UPPAAL cannot handle deadlock predicate for models with guarded broadcast receivers.
*/
A[] not deadlock
