0: CPi 100 7 //1.loop pc
1: CPi 110 8 //2.loop pc
2: CPi 120 9 //3.loop pc
3: CPi 130 0 //1.loop counter
4: CPi 140 0 //2.loop counter
5: CPi 150 0 //3.loop counter
6: CPi 4111 1 //LED
7: ADDi 130 1
8: ADDi 140 1
9: ADDi 150 1
10: CP 151 150
11: CPi 200 4
12: LT 151 200
13: BZJ 100 151 //marks end of loop
14: CP 141 140
15: CPi 142 1249
16: LT 142 140
17: BZJ 110 142 //marks end of loop
18: MULi 4111 2
19: CPi 131 7
20: LT 131 130
21: BZJ 120 131
22: CPi 100 7 //1.loop pc
23: CPi 110 8 //2.loop pc
24: CPi 120 9 //3.loop pc
25: CPi 130 0 //1.loop counter
26: CPi 140 0 //2.loop counter
27: CPi 150 0 //3.loop counter
28: CPi 4111 1 //LED
29: ADDi 130 1
30: ADDi 140 1
31: ADDi 150 1
32: CP 151 150
33: CPi 200 4
34: LT 151 200
35: BZJ 120 151 //marks end of loop
36: CP 141 140
37: CPi 142 1249 
38: LT 142 140
39: BZJ 110 142 //marks end of loop
40: CPi 300 1
41: SRL 4111 300
42: CPi 131 7
43: LT 131 130
44: BZJ 100 131