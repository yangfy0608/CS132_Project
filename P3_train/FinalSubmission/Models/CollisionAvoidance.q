//This file was generated from (Academic) UPPAAL 4.1.24 (rev. 29A3ECA4E5FB0808), November 2019

/*

*/
A[] not deadlock

/*
Obeys physical constraints
*/
A[] forall(i:id_t) v[i]>=0 and v[i]<=v_max[i]

/*
All locomotives eventually reach destination
*/
A<>  K1.Arrived and D1.Arrived and G1.Arrived

/*
No collision
*/
A[] forall(i:id_t) forall(j:id_t) x_pre[i]<x_pre[j] imply x[i]<=x[j]

/*
Cumulated delay within deadline

*/
A[] not K1.TimeOut and not D1.TimeOut and not G1.TimeOut
