package Tresses.Samples.Sample_909hh_open_half_rate
with Preelaborate
is
   pragma Style_Checks (Off);
   Sample : aliased constant S8_Array := (
-12,
18,
4,
-2,
10,
3,
-18,
-1,
16,
1,
-12,
-8,
2,
10,
-7,
-4,
-8,
-14,
4,
7,
3,
-12,
3,
-4,
-9,
13,
-8,
-14,
-2,
-4,
-2,
-4,
5,
-13,
-3,
14,
2,
5,
-26,
7,
-7,
-2,
-9,
8,
-2,
-4,
13,
-6,
10,
-14,
-18,
-5,
-3,
4,
-10,
6,
-2,
5,
7,
-3,
-9,
-12,
-2,
3,
5,
-3,
2,
-1,
-9,
-3,
-10,
10,
-3,
-4,
-3,
3,
-2,
-8,
-3,
-14,
-5,
10,
7,
-15,
-1,
7,
-3,
0,
-2,
-1,
-10,
-13,
19,
7,
-11,
-4,
-6,
-12,
-7,
6,
-10,
-6,
-1,
18,
-8,
-4,
5,
-10,
5,
-8,
11,
-15,
-16,
8,
-9,
1,
-3,
20,
-4,
-3,
10,
-3,
-23,
-11,
0,
-18,
-4,
11,
2,
3,
2,
14,
-14,
-5,
-8,
-4,
-12,
-13,
-5,
6,
-5,
17,
5,
6,
3,
-3,
-1,
-24,
-1,
-3,
-16,
7,
4,
-6,
0,
9,
15,
-21,
-8,
2,
-17,
4,
6,
-8,
1,
-1,
23,
-11,
-6,
-4,
-15,
-4,
10,
11,
-8,
-1,
8,
-13,
-9,
-13,
-1,
-4,
10,
21,
-9,
-9,
-6,
9,
-12,
-11,
0,
-7,
9,
6,
-5,
-20,
-6,
12,
-6,
9,
1,
-4,
-10,
-4,
10,
-27,
-8,
12,
2,
2,
4,
6,
-13,
-11,
13,
-6,
-12,
-12,
22,
-2,
-12,
10,
-3,
-21,
-1,
9,
-4,
-3,
6,
7,
0,
-18,
16,
-15,
-10,
9,
1,
1,
-16,
18,
-5,
-9,
1,
-3,
2,
-11,
16,
0,
-24,
0,
4,
2,
-6,
13,
0,
-11,
-2,
3,
-14,
-14,
9,
0,
-3,
1,
9,
-5,
-13,
7,
-6,
-11,
-7,
14,
1,
-10,
9,
-4,
-15,
-5,
11,
-10,
-5,
4,
1,
4,
-6,
6,
-15,
-7,
8,
-2,
-5,
-3,
6,
-11,
2,
4,
-13,
0,
11,
7,
-9,
-15,
-1,
-3,
-5,
10,
6,
-8,
-3,
15,
-1,
-22,
-2,
3,
0,
0,
10,
-11,
-21,
7,
2,
-3,
-11,
11,
10,
-6,
1,
2,
-15,
-18,
4,
8,
-8,
2,
-2,
6,
-14,
5,
-4,
-11,
1,
-2,
3,
-3,
3,
-7,
-1,
0,
-2,
0,
-3,
4,
-5,
-3,
-1,
-2,
-4,
-2,
7,
-12,
-1,
-3,
5,
-1,
-3,
7,
-10,
-8,
4,
2,
-12,
-5,
13,
-7,
0,
9,
-2,
-15,
-9,
7,
-7,
-10,
1,
12,
0,
-9,
5,
-4,
-18,
-5,
14,
-9,
-13,
20,
5,
-8,
-2,
-5,
-7,
-15,
11,
2,
-11,
-5,
5,
1,
-12,
3,
4,
0,
-1,
4,
3,
-17,
-9,
2,
-13,
-2,
3,
7,
1,
3,
1,
-10,
-3,
-9,
-1,
-4,
7,
2,
-6,
6,
-8,
0,
4,
-1,
-7,
-7,
2,
-12,
0,
-12,
2,
7,
3,
9,
0,
-5,
-16,
1,
-11,
-14,
3,
6,
9,
-1,
12,
-13,
-14,
-4,
-4,
0,
-10,
8,
-1,
-1,
-7,
-6,
-6,
-10,
9,
13,
2,
-3,
0,
-3,
-25,
-10,
0,
-4,
7,
15,
3,
-13,
-2,
-1,
-10,
-7,
-2,
1,
1,
-1,
6,
-10,
-8,
1,
8,
-2,
-9,
-1,
-5,
-10,
-5,
1,
-1,
5,
8,
1,
-3,
-6,
-11,
-2,
3,
-6,
-4,
6,
-3,
-8,
2,
-3,
0,
-5,
5,
0,
-9,
-1,
-4,
-6,
-10,
7,
0,
0,
0,
8,
-7,
-14,
1,
-3,
-3,
-3,
8,
-2,
-14,
9,
-1,
1,
-15,
6,
-4,
-15,
8,
2,
-3,
-9,
7,
5,
-8,
-1,
-4,
-8,
-15,
3,
3,
-4,
5,
7,
3,
-12,
-7,
-3,
-13,
-7,
7,
3,
-2,
7,
6,
-11,
-2,
-8,
-4,
-15,
-4,
10,
-3,
-2,
0,
-8,
2,
7,
-6,
0,
-5,
-9,
-8,
0,
2,
-5,
3,
1,
4,
-7,
-11,
-2,
-8,
2,
5,
1,
-6,
-1,
1,
-7,
-11,
1,
4,
-2,
8,
5,
-10,
-14,
-3,
5,
-15,
0,
11,
3,
-9,
-2,
1,
-12,
-12,
-2,
6,
-8,
-1,
21,
10,
-22,
1,
7,
-11,
-11,
0,
0,
-18,
0,
12,
-1,
-8,
-3,
5,
4,
-9,
0,
-7,
-12,
4,
5,
1,
-10,
-3,
2,
5,
-1,
-3,
-15,
-8,
7,
-1,
-1,
-7,
-6,
1,
8,
3,
-12,
1,
1,
-6,
-2,
-4,
-9,
-5,
1,
8,
5,
-7,
-3,
-3,
0,
-11,
-3,
-2,
-10,
1,
5,
-4,
-6,
-2,
-2,
-1,
2,
2,
-5,
-3,
-1,
-4,
-2,
-3,
-2,
1,
-6,
-1,
-4,
-7,
-11,
9,
-4,
-3,
13,
-9,
-9,
-4,
4,
-8,
-7,
1,
1,
-4,
-2,
5,
5,
-9,
1,
5,
-5,
-8,
-5,
-8,
-12,
2,
11,
0,
-5,
3,
2,
-5,
-1,
-5,
-11,
-9,
1,
2,
0,
3,
-5,
1,
15,
-6,
-14,
-5,
-5,
-5,
-6,
-1,
3,
-3,
5,
8,
-2,
-10,
-8,
9,
-9,
-6,
2,
-2,
-10,
2,
8,
2,
-10,
9,
0,
-13,
0,
-11,
-4,
-7,
7,
9,
-4,
7,
-7,
-1,
-1,
-6,
-2,
-11,
-1,
-3,
2,
-8,
6,
-1,
-10,
7,
0,
-3,
-7,
3,
-3,
-9,
2,
2,
-7,
-5,
7,
-1,
-3,
-1,
3,
-8,
-10,
0,
3,
0,
-10,
7,
1,
-10,
-4,
7,
-4,
-3,
-2,
0,
-4,
-4,
-3,
-5,
6,
4,
4,
-4,
2,
-14,
-7,
-1,
-16,
3,
1,
5,
1,
-5,
3,
-13,
1,
0,
1,
3,
-6,
1,
-1,
-9,
-2,
0,
-4,
-3,
5,
2,
-12,
-8,
3,
-2,
-2,
4,
1,
-2,
-7,
1,
2,
-13,
-1,
6,
4,
-6,
-4,
-1,
-7,
-2,
5,
3,
-11,
0,
1,
-7,
-1,
-1,
0,
-6,
2,
4,
-4,
-6,
-3,
-1,
-3,
-1,
2,
3,
-2,
-2,
0,
-2,
-8,
-1,
-1,
-2,
-3,
-3,
1,
-2,
-1,
2,
-4,
-4,
-5,
0,
-4,
-1,
-3,
-3,
1,
-2,
3,
-1,
-3,
-1,
-2,
-3,
-4,
-1,
-4,
1,
-1,
6,
-3,
-5,
-10,
-2,
-1,
-7,
-3,
-3,
1,
3,
0,
3,
-6,
1,
3,
2,
-3,
-13,
-4,
-6,
-3,
4,
1,
-1,
-2,
0,
-1,
0,
-7,
-7,
1,
-7,
3,
-3,
-4,
10,
-2,
5,
-7,
-1,
-6,
-10,
1,
-3,
-6,
-6,
5,
3,
1,
1,
-4,
-4,
-2,
0,
-2,
-6,
-9,
-1,
1,
2,
-1,
-2,
3,
-1,
-1,
1,
-15,
-2,
-2,
3,
-1,
-1,
-3,
-3,
6,
-7,
-3,
-5,
-6,
8,
-3,
2,
-16,
-3,
1,
-5,
8,
-5,
1,
2,
4,
-1,
-10,
-3,
-14,
6,
4,
-5,
2,
-5,
4,
-5,
-3,
-7,
-7,
-2,
2,
5,
-1,
-7,
-5,
5,
1,
-7,
0,
-5,
-6,
2,
2,
-7,
-5,
4,
0,
3,
-7,
-7,
-8,
-3,
4,
-5,
0,
0,
-1,
1,
-7,
-8,
-1,
-1,
4,
5,
-4,
-8,
-1,
0,
-2,
-4,
-1,
-4,
3,
0,
-4,
-8,
-5,
-5,
3,
2,
1,
-6,
5,
-1,
-2,
-2,
-5,
-3,
1,
-2,
-3,
-7,
-5,
-1,
1,
0,
3,
-2,
1,
0,
-7,
-5,
-9,
-2,
-1,
-1,
3,
-3,
3,
-7,
-2,
1,
-13,
-2,
-5,
5,
-3,
-6,
6,
-4,
6,
-4,
-2,
0,
-11,
0,
-3,
-3,
-7,
-1,
4,
0,
2,
1,
-5,
-9,
-5,
1,
-7,
0,
0,
-1,
-2,
-1,
1,
-4,
2,
-1,
2,
-3,
-12,
1,
-5,
-1,
-3,
4,
1,
-5,
2,
-1,
-5,
-6,
-3,
-4,
4,
-1,
-4,
-2,
-1,
-3,
-2,
6,
-7,
-2,
2,
-7,
4,
-10,
-4,
1,
0,
0,
-4,
7,
-9,
-6,
-2,
-7,
2,
-3,
2,
-3,
-2,
2,
-6,
2,
-3,
-2,
-1,
1,
-2,
-8,
-3,
-7,
3,
-3,
2,
2,
-4,
0,
-5,
4,
-7,
-8,
0,
-2,
-1,
-3,
4,
-7,
-1,
5,
-1,
-4,
-1,
-8,
-3,
-3,
-7,
-2,
-3,
2,
4,
0,
-2,
-5,
1,
-7,
-4,
-2,
-5,
-4,
2,
0,
-2,
-3,
-2,
3,
-4,
0,
-7,
-5,
-3,
-3,
-2,
-3,
5,
-5,
0,
5,
-6,
-9,
-5,
-5,
4,
0,
-5,
2,
-2,
-8,
3,
0,
-6,
-6,
4,
0,
-7,
-3,
-5,
-4,
0,
2,
-1,
0,
5,
-8,
-2,
-6,
-5,
-2,
-4,
7,
-3,
0,
-5,
-2,
2,
-9,
-1,
-2,
1,
-8,
-1,
-2,
-8,
3,
-3,
2,
-1,
0,
-10,
2,
0,
-10,
-1,
-1,
4,
-9,
0,
0,
-8,
1,
-2,
5,
0,
-3,
-8,
-1,
-4,
-9,
3,
-6,
0,
3,
2,
-1,
0,
1,
-9,
1,
-3,
-6,
-3,
-2,
-1,
-5,
-2,
-2,
-1,
2,
-3,
1,
1,
-9,
-3,
5,
-4,
-6,
-3,
-2,
0,
0,
-1,
0,
-4,
-5,
-2,
-2,
-5,
-2,
-6,
3,
-3,
-4,
0,
-1,
1,
-2,
2,
-6,
0,
-5,
-5,
1,
-6,
-2,
-3,
6,
-2,
-5,
-2,
-2,
5,
-4,
-1,
-8,
-2,
-4,
-1,
-1,
-7,
3,
-2,
8,
-2,
-4,
-2,
-8,
5,
-4,
-1,
-6,
-3,
-3,
-3,
5,
-3,
-5,
-6,
5,
2,
-5,
-4,
-3,
2,
-5,
2,
-2,
-6,
-6,
-2,
6,
-3,
1,
-1,
-1,
-4,
-9,
1,
-7,
-3,
-3,
2,
-1,
1,
2,
-7,
3,
-4,
0,
-1,
-7,
1,
-7,
-2,
-5,
4,
-3,
-5,
2,
-3,
1,
-3,
1,
-4,
-3,
-3,
-1,
-1,
-4,
-3,
-4,
9,
-4,
0,
-1,
-7,
-4,
-6,
4,
-7,
-5,
1,
1,
0,
-5,
3,
-7,
-3,
-1,
-3,
-1,
-6,
2,
-2,
-2,
-5,
6,
-4,
-6,
3,
1,
-7,
-8,
6,
-4,
-7,
2,
-1,
-1,
-3,
4,
0,
-3,
-8,
1,
2,
-7,
-5,
3,
1,
-6,
-1,
-1,
-9,
0,
-1,
3,
-3,
-5,
-4,
0,
5,
-10,
-1,
-1,
-5,
-2,
0,
-7,
-2,
1,
2,
-1,
-3,
2,
-6,
-2,
-1,
-4,
2,
-6,
-2,
5,
-3,
-5,
1,
2,
-13,
0,
2,
-8,
-2,
1,
2,
-7,
1,
3,
0,
-6,
0,
-7,
-2,
-3,
-4,
1,
-4,
-3,
5,
2,
-9,
2,
-4,
-7,
2,
0,
-8,
-2,
0,
-1,
-1,
2,
-4,
-6,
1,
6,
-8,
-8,
-1,
-4,
-4,
-1,
0,
-3,
-3,
4,
4,
-6,
-7,
-1,
-2,
-5,
-4,
2,
-7,
-2,
6,
0,
-6,
0,
0,
-11,
3,
0,
-7,
-2,
0,
2,
1,
-3,
-5,
-3,
-3,
-2,
-4,
-4,
-2,
-1,
2,
-4,
0,
0,
-6,
2,
-1,
-6,
-7,
4,
-3,
-2,
0,
-3,
-3,
-2,
4,
-5,
-6,
1,
-4,
-3,
0,
3,
-8,
0,
0,
0,
0,
-6,
0,
0,
-5,
-3,
0,
-5,
-6,
3,
-2,
-3,
-5,
2,
-2,
-7,
3,
-2,
-3,
-3,
-1,
-1,
-5,
-6,
-3,
1,
-6,
-3,
3,
1,
-1,
-1,
-2,
-6,
-3,
0,
-3,
-5,
-4,
2,
-1,
0,
-3,
-1,
-5,
-2,
-2,
0,
-4,
-10,
0,
1,
2,
-2,
3,
1,
-10,
2,
-1,
-2,
-9,
-4,
4,
0,
-4,
-2,
1,
-4,
-3,
5,
-2,
-7,
-4,
2,
-5,
-7,
-2,
-1,
-2,
2,
1,
-3,
-6,
-2,
1,
-7,
1,
-5,
-3,
1,
-7,
-3,
-3,
-1,
0,
-1,
4,
-4,
-3,
-6,
-3,
3,
-7,
-6,
1,
2,
-3,
4,
-1,
-9,
0,
2,
-4,
-6,
0,
-7,
0,
0,
-1,
-3,
-5,
0,
2,
1,
-3,
-2,
-3,
-5,
2,
-4,
-2,
-8,
-2,
5,
-4,
0,
-4,
-4,
-5,
3,
-4,
-5,
-4,
-4,
6,
-2,
-1,
1,
0,
-5,
-4,
-4,
-5,
-7,
-2,
6,
-5,
0,
-1,
-4,
-4,
-2,
-2,
-7,
2,
-1,
-2,
-3,
-7,
1,
-1,
0,
-2,
-2,
1,
-6,
0,
-2,
-6,
-3,
3,
-4,
0,
-5,
-6,
5,
-2,
-2,
1,
0,
-5,
-4,
2,
-6,
-6,
0,
4,
-3,
-2,
2,
-7,
-3,
0,
-2,
-3,
-2,
1,
0,
-3,
-6,
0,
-7,
-6,
3,
-2,
-4,
-2,
6,
0,
-3,
0,
-2,
-8,
1,
-4,
-4,
-4,
-5,
2,
0,
-1,
-1,
1,
0,
-2,
1,
-7,
-2,
-8,
-5,
3,
-3,
0,
1,
-1,
1,
-2,
-4,
2,
-5,
-4,
1,
-6,
-4,
-4,
3,
-2,
3,
1,
-4,
-4,
-7,
2,
-11,
-4,
-2,
-1,
1,
0,
1,
-4,
-1,
-2,
-1,
-1,
-7,
-1,
-3,
-2,
-2,
-2,
1,
-5,
2,
-1,
-4,
-2,
-2,
-4,
0,
0,
-4,
-2,
-4,
-2,
-1,
-1,
-3,
-1,
1,
0,
-2,
-2,
-2,
-7,
-3,
1,
-7,
1,
-2,
0,
2,
-3,
-4,
-3,
0,
-9,
-2,
2,
-4,
-2,
0,
2,
-8,
-1,
-3,
0,
-4,
-2,
2,
-1,
-3,
-5,
2,
-3,
-7,
-1,
-2,
2,
-6,
2,
-5,
-1,
2,
-2,
-2,
-5,
1,
-5,
1,
-2,
-5,
2,
-2,
-3,
-4,
1,
-8,
-5,
1,
-2,
2,
-2,
-1,
-2,
-1,
-2,
-2,
-3,
-7,
4,
-1,
-4,
-5,
0,
-1,
-6,
1,
-3,
-3,
-3,
6,
-1,
-6,
3,
-6,
-2,
-4,
1,
-3,
-3,
0,
-2,
1,
-7,
-2,
0,
-2,
-2,
-2,
-2,
-6,
2,
-1,
-2,
-4,
2,
-4,
-2,
0,
-9,
-1,
-2,
-1,
-2,
-3,
-1,
-5,
1,
-1,
-3,
-3,
-1,
1,
-5,
2,
-8,
-2,
-2,
0,
2,
-5,
-2,
0,
1,
-4,
-1,
-4,
-4,
2,
-2,
0,
-9,
-2,
1,
3,
-3,
-3,
-5,
-5,
4,
-4,
-2,
-5,
-3,
4,
-3,
0,
-7,
-4,
0,
0,
1,
-5,
-3,
-3,
3,
-4,
-3,
-2,
-7,
4,
2,
-3,
-7,
-2,
-2,
0,
-1,
-5,
-2,
-4,
2,
0,
-6,
-1,
-3,
1,
0,
-3,
-4,
0,
-2,
1,
0,
-9,
-2,
3,
-2,
-1,
-4,
-5,
-4,
4,
1,
-2,
-3,
-1,
-2,
-1,
-1,
-8,
-3,
2,
-1,
1,
-2,
-6,
-1,
-2,
-2,
2,
-5,
-2,
2,
-5,
-2,
-2,
-5,
-6,
-1,
4,
1,
-5,
-2,
-1,
-6,
0,
0,
-5,
-1,
3,
-2,
-4,
-2,
0,
0,
-5,
-1,
-2,
-5,
1,
-3,
-7,
-2,
0,
2,
-1,
-5,
-2,
-1,
-6,
1,
0,
-6,
0,
-1,
0,
-6,
-1,
-2,
-4,
1,
1,
-3,
-5,
-3,
0,
-2,
0,
-5,
-1,
-1,
-2,
1,
-4,
-7,
-2,
1,
1,
-4,
-4,
-2,
-1,
-3,
0,
-7,
0,
0,
-1,
-1,
-1,
-6,
-5,
0,
-3,
-3,
-2,
-2,
-1,
1,
-3,
-4,
-3,
-2,
0,
2,
-2,
-5,
-1,
-3,
-4,
2,
-2,
-4,
-1,
1,
-4,
-3,
-2,
-3,
-4,
-1,
5,
-3,
-4,
-3,
1,
-6,
-3,
0,
-4,
-1,
-5,
3,
-4,
-5,
1,
2,
-3,
1,
1,
-6,
-6,
-1,
-2,
-4,
0,
-2,
-3,
-3,
-1,
1,
-7,
-4,
1,
-1,
0,
0,
-4,
-2,
-4,
0,
-1,
-6,
-4,
-2,
-2,
0,
-2,
-3,
-3,
1,
-3,
-2,
-2,
-3,
-3,
-2,
4,
-4,
-4,
1,
-2,
-1,
1,
-5,
-4,
-1,
-2,
2,
0,
-5,
-4,
-2,
-2,
1,
-2,
-2,
-4,
0,
-2,
-3,
-2,
-4,
-5,
0,
4,
-5,
-4,
-1,
-6,
-3,
-1,
-1,
0,
0,
-4,
4,
-4,
-6,
-2,
-3,
-1,
-2,
4,
-3,
-6,
0,
-1,
0,
-6,
1,
-4,
-2,
-1,
-4,
-3,
-5,
1,
-1,
-2,
-1,
0,
-5,
-5,
-2,
-3,
0,
-3,
2,
-3,
-5,
1,
-3,
-5,
-1,
0,
-2,
-2,
-3,
-2,
-2,
-2,
0,
-3,
-6,
0,
1,
-3,
-2,
-3,
-5,
2,
-1,
1,
-2,
-5,
1,
-3,
-2,
-3,
-4,
-1,
0,
2,
-3,
-2,
-3,
-2,
-6,
-1,
1,
-7,
-1,
4,
-3,
-4,
-3,
-3,
-4,
1,
-1,
0,
-6,
-1,
1,
-4,
-1,
-2,
-2,
-1,
-1,
-2,
-1,
-7,
2,
-2,
-8,
1,
0,
-5,
-4,
0,
-1,
-4,
0,
2,
-1,
-7,
-1,
-2,
-5,
0,
-1,
1,
-2,
-3,
-1,
0,
-4,
-2,
2,
-4,
0,
-1,
-5,
0,
-3,
0,
-3,
-3,
2,
-5,
0,
0,
-5,
-4,
0,
-1,
-2,
-1,
-4,
2,
-3,
-1,
-2,
-4,
0,
-1,
-2,
-4,
-1,
-2,
-3,
-2,
-1,
-4,
-7,
1,
1,
-6,
-4,
1,
-4,
-6,
4,
0,
-5,
-4,
2,
-2,
-4,
-2,
-1,
-2,
-3,
0,
-3,
-4,
-3,
2,
-2,
-4,
0,
-2,
-7,
0,
1,
-5,
-3,
4,
-3,
-2,
-1,
-3,
-4,
-6,
4,
-2,
-2,
2,
-4,
0,
-3,
-4,
0,
-2,
-3,
-1,
0,
-5,
1,
-2,
-5,
2,
0,
-2,
-2,
1,
-4,
-3,
0,
0,
-5,
-4,
4,
-4,
-1,
-2,
-4,
-1,
-2,
-2,
0,
-3,
-4,
2,
-2,
-3,
1,
-3,
-4,
0,
2,
-3,
-6,
2,
-2,
-5,
-2,
1,
-3,
-5,
0,
-1,
-2,
-4,
-4,
0,
-4,
-1,
0,
-4,
-2,
-1,
-2,
-3,
-2,
-2,
-2,
-1,
-1,
-2,
-6,
0,
-1,
-3,
-3,
3,
-7,
-3,
1,
-4,
-3,
-3,
-1,
-1,
-2,
2,
-3,
-4,
-2,
0,
-4,
-3,
-1,
-1,
-4,
0,
1,
-3,
-7,
2,
-1,
-7,
-1,
-1,
-3,
-3,
-1,
0,
-5,
-4,
2,
-4,
-2,
2,
-2,
-8,
0,
-2,
-2,
-2,
-3,
0,
-3,
-1,
1,
-2,
-4,
-1,
1,
-4,
-2,
-3,
-1,
-2,
0,
3,
-6,
-1,
-1,
-6,
0,
-2,
-4,
-2,
2,
-3,
-1,
0,
-3,
1,
-2,
-3,
-3,
-1,
2,
-2,
0,
-1,
-1,
-3,
-4,
0,
-4,
-1,
-2,
1,
-2,
0,
-1,
-4,
1,
-3,
0,
-2,
-4,
0,
-4,
-1,
-3,
2,
-3,
-2,
0,
-2,
0,
-2,
0,
-3,
-2,
-3,
-1,
-2,
-3,
-3,
-2,
4,
-3,
0,
-2,
-4,
-3,
-3,
2,
-5,
-2,
-1,
0,
-1,
-3,
0,
-5,
-2,
-2,
-1,
-2,
-3,
0,
-1,
-2,
-3,
2,
-3,
-3,
1,
-1,
-5,
-4,
3,
-4,
-4,
0,
-1,
-2,
-2,
1,
-1,
-3,
-5,
0,
0,
-4,
-3,
1,
0,
-4,
0,
-2,
-5,
0,
-1,
1,
-3,
-3,
-3,
0,
1,
-6,
-1,
-2,
-3,
-2,
-1,
-4,
-2,
0,
1,
-2,
-2,
0,
-4,
-2,
-2,
-3,
0,
-4,
-1,
2,
-2,
-3,
0,
-1,
-7,
0,
-1,
-5,
-2,
1,
0,
-4,
0,
1,
-2,
-4,
-1,
-4,
-1,
-3,
-3,
-1,
-3,
-2,
2,
-1,
-5,
0,
-3,
-4,
1,
-2,
-5,
-1,
-1,
-1,
-1,
0,
-3,
-3,
0,
2,
-6,
-4,
-1,
-3,
-2,
-1,
-1,
-2,
-2,
2,
1,
-5,
-4,
-1,
-2,
-3,
-3,
0,
-5,
-1,
3,
-2,
-4,
0,
-2,
-6,
1,
-2,
-4,
-2,
-1,
0,
0,
-3,
-3,
-2,
-2,
-2,
-3,
-2,
-2,
-1,
1,
-3,
-1,
-1,
-4,
0,
-2,
-5,
-4,
1,
-3,
-1,
-1,
-2,
-2,
-1,
1,
-4,
-3,
0,
-3,
-2,
0,
0,
-5,
0,
-1,
0,
-1,
-3,
-1,
-1,
-3,
-2,
-1,
-4,
-3,
1,
-2,
-2,
-3,
1,
-2,
-4,
1,
-2,
-2,
-2,
-1,
-2,
-4,
-4,
-2,
0,
-4,
-2,
1,
-1,
-2,
-1,
-2,
-4,
-2,
-1,
-2,
-3,
-2,
1,
-1,
-1,
-2,
-1,
-3,
-1,
-2,
-1,
-3,
-6,
0,
0,
0,
-2,
1,
-2,
-6,
0,
-1,
-2,
-6,
-2,
1,
-1,
-3,
-1,
0,
-3,
-2,
2,
-2,
-4,
-2,
1,
-4,
-4,
-2,
-1,
-2,
1,
-1,
-2,
-4,
-1,
0,
-4,
0,
-4,
-1,
0,
-4,
-2,
-2,
-1,
-1,
-1,
1,
-3,
-2,
-4,
-1,
0,
-5,
-3,
0,
0,
-2,
2,
-2,
-5,
0,
0,
-3,
-3,
-1,
-4,
0,
-1,
-1,
-2,
-3,
0,
0,
0,
-2,
-2,
-3,
-3,
0,
-3,
-2,
-5,
-1,
2,
-3,
-1,
-3,
-3,
-3,
1,
-4,
-3,
-3,
-2,
2,
-2,
-1,
-1,
-1,
-3,
-2,
-3,
-3,
-5,
-1,
2,
-3,
0,
-2,
-2,
-3,
-1,
-2,
-4,
1,
-1,
-1,
-3,
-4,
0,
-2,
0,
-2,
-1,
0,
-4,
0,
-2,
-4,
-2,
1,
-3,
0,
-4,
-3,
2,
-2,
-1,
0,
-1,
-4,
-2,
0,
-4,
-4,
-1,
1,
-3,
-1,
0,
-5,
-2,
-1,
-2,
-2,
-2,
0,
-1,
-2,
-4,
-1,
-5,
-3,
1,
-2,
-3,
-1,
3,
-1,
-2,
-1,
-2,
-5,
0,
-3,
-3,
-3,
-3,
0,
-1,
-1,
-1,
0,
-1,
-1,
-1,
-5,
-2,
-5,
-3,
1,
-2,
-1,
0,
-1,
0,
-2,
-3,
1,
-4,
-2,
-1,
-4,
-3,
-3,
1,
-2,
2,
-1,
-2,
-3,
-3,
0,
-7,
-2,
-2,
-1,
-1,
-1,
0,
-3,
-1,
-2,
-1,
-2,
-4,
-1,
-3,
-1,
-2,
-1,
-1,
-3,
1,
-1,
-3,
-2,
-2,
-3,
0,
-1,
-3,
-2,
-3,
-2,
-1,
-1,
-2,
-1,
0,
-1,
-2,
-2,
-2,
-5,
-2,
0,
-4,
0,
-2,
0,
0,
-3,
-3,
-2,
-1,
-6,
-1,
0,
-3,
-2,
0,
0,
-5,
-1,
-3,
-1,
-3,
-1,
0,
-2,
-2,
-3,
1,
-4,
-5,
-2,
-2,
-1,
-5,
0,
-4,
-1,
0,
-2,
-3,
-3,
-1,
-4,
0,
-3,
-3,
1,
-3,
-3,
-3,
-1,
-6,
-3,
-1,
-2,
0,
-3,
-1,
-2,
-2,
-2,
-2,
-3,
-5,
1,
-2,
-3,
-4,
-1,
-2,
-4,
-1,
-3,
-2,
-3,
3,
-3,
-4,
0,
-5,
-2,
-3,
-1,
-3,
-3,
-1,
-2,
-1,
-5,
-2,
-1,
-2,
-2,
-2,
-2,
-4,
0,
-2,
-2,
-3,
0,
-4,
-1,
-2,
-6,
-1,
-2,
-1,
-2,
-3,
-2,
-4,
0,
-2,
-3,
-3,
-1,
-1,
-3,
0,
-6,
-1,
-3,
-1,
0,
-3,
-2,
-1,
0,
-3,
-1,
-4,
-3,
0,
-2,
-1,
-6,
-1,
0,
1,
-3,
-3,
-4,
-3,
1,
-3,
-2,
-4,
-2,
1,
-3,
-1,
-5,
-2,
-1,
-1,
-1,
-4,
-3,
-3,
1,
-4,
-2,
-3,
-4,
1,
0,
-3,
-5,
-2,
-3,
-1,
-2,
-4,
-2,
-3,
0,
-2,
-4,
-2,
-3,
0,
-1,
-3,
-3,
-1,
-2,
0,
-2,
-6,
-1,
0,
-2,
-1,
-3,
-4,
-3,
1,
-1,
-3,
-3,
-2,
-2,
-1,
-2,
-6,
-3,
0,
-1,
-1,
-2,
-4,
-1,
-3,
-2,
0,
-4,
-1,
-1,
-4,
-2,
-3,
-4,
-5,
-1,
1,
-1,
-4,
-2,
-2,
-5,
-1,
-2,
-5,
-1,
0,
-3,
-4,
-2,
-1,
-1,
-4,
-1,
-3,
-4,
-1,
-4,
-5,
-2,
-1,
0,
-2,
-4,
-2,
-2,
-5,
0,
-2,
-4,
-1,
-1,
-1,
-5,
-1,
-3,
-3,
0,
-1,
-3,
-4,
-2,
-2,
-2,
-2,
-5,
-1,
-2,
-2,
0,
-5,
-5,
-2,
0,
-1,
-3,
-3,
-2,
-2,
-2,
-1,
-6,
0,
-1,
-2,
-1,
-2,
-5,
-4,
-1,
-3,
-3,
-2,
-2,
-1,
-1,
-3,
-3,
-3,
-3,
-1,
0,
-3,
-4,
-2,
-3,
-3,
1,
-3,
-3,
-1,
-1,
-4,
-2,
-3,
-3,
-4,
-1,
2,
-3,
-3,
-3,
-1,
-5,
-2,
-2,
-3,
-2,
-4,
1,
-4,
-4,
0,
0,
-3,
0,
-1,
-5,
-4,
-2,
-2,
-3,
-1,
-3,
-3,
-2,
-1,
-1,
-6,
-3,
-1,
-2,
-1,
-1,
-4,
-2,
-3,
0,
-2,
-5,
-3,
-2,
-2,
-1,
-2,
-3,
-2,
-1,
-3,
-2,
-3,
-3,
-2,
-2,
1,
-4,
-3,
-1,
-3,
-2,
-1,
-5,
-3,
-1,
-2,
1,
-2,
-5,
-3,
-3,
-2,
-1,
-3,
-2,
-3,
-1,
-3,
-3,
-3,
-4,
-4,
-1,
1,
-5,
-3,
-2,
-5,
-3,
-2,
-2,
-1,
-2,
-3,
2,
-5,
-5,
-3,
-3,
-2,
-2,
2,
-4,
-5,
-1,
-1,
-2,
-5,
0,
-4,
-1,
-2,
-3,
-4,
-4,
0,
-2,
-2,
-2,
-1,
-5,
-4,
-2,
-3,
-2,
-3,
1,
-4,
-4,
0,
-3,
-4,
-1,
-1,
-2,
-3,
-3,
-3,
-2,
-2,
-1,
-4,
-5,
-1,
0,
-4,
-2,
-4,
-4,
0,
-2,
0,
-3,
-4,
-1,
-3,
-2,
-3,
-3,
-1,
-1,
0,
-3,
-2,
-3,
-3,
-5,
-1,
-1,
-6,
-1,
2,
-3,
-4,
-3,
-3,
-4,
0,
-2,
-1,
-6,
-1,
-1,
-3,
-2,
-2,
-2,
-1,
-2,
-2,
-2,
-5,
2,
-4,
-6,
0,
-2,
-5,
-3,
-1,
-3,
-4,
0,
0,
-3,
-6,
-2,
-3,
-4,
-1,
-2,
0,
-2,
-3,
-2,
-1,
-4,
-2,
0,
-4,
-1,
-3,
-4,
-1,
-3,
-1,
-4,
-2,
0,
-5,
-1,
-2,
-5,
-4,
0,
-2,
-2,
-2,
-3,
1,
-3,
-1,
-3,
-3,
-1,
-2,
-3,
-4,
-2,
-3,
-3,
-2,
-2,
-4,
-6,
1,
-1,
-5,
-3,
0,
-4,
-4,
2,
-2,
-5,
-4,
1,
-3,
-3,
-2,
-2,
-3,
-3,
-1,
-3,
-4,
-4,
1,
-3,
-4,
-1,
-3,
-6,
0,
-1,
-5,
-3,
2,
-4,
-2,
-2,
-3,
-4,
-5,
1,
-4,
-1,
0,
-4,
-1,
-4,
-3,
-1,
-2,
-3,
-2,
-1,
-5,
0,
-4,
-4,
0,
-1,
-3,
-2,
0,
-5,
-2,
-1,
-1,
-5,
-3,
2,
-4,
-1,
-3,
-4,
-2,
-2,
-2,
-1,
-3,
-4,
0,
-3,
-3,
0,
-4,
-4,
0,
1,
-4,
-4,
0,
-3,
-5,
-2,
0,
-4,
-4,
-1,
-2,
-3,
-5,
-4,
-2,
-4,
-1,
-1,
-4,
-2,
-2,
-2,
-3,
-3,
-3,
-2,
-2,
-2,
-3,
-6,
-1,
-3,
-3,
-3,
0,
-7,
-3,
-1,
-4,
-3,
-4,
-2,
-2,
-2,
0,
-5,
-4,
-3,
-1,
-5,
-3,
-1,
-2,
-4,
-1,
-1,
-4,
-6,
0,
-1,
-3,
0,
-5,
-1,
-2,
-2,
-2,
-3,
-2,
-4,
-3,
-3,
-1,
-3,
-2,
-4,
-1,
1,
-3,
0,
-4,
-3,
-4,
-2,
-1,
-4,
-2,
-2,
-1,
-2,
-2,
-1,
-4,
-2,
-2,
-1,
-3,
-2,
-1,
-2,
-3,
-2,
0,
-4,
-2,
-1,
-2,
-4,
-2,
1,
-5,
-2,
-2,
-2,
-3,
-1,
-1,
-2,
-3,
-3,
0,
-2,
-4,
-1,
0,
-1,
-3,
-1,
-3,
-3,
-1,
-1,
-1,
-3,
-2,
-2,
0,
-2,
-3,
-1,
-3,
-2,
-1,
-2,
-3,
-1,
-1,
-1,
-2,
-1,
-2,
-3,
-1,
-2,
-2,
-2,
-3,
-1,
-1,
-2,
-2,
-1,
-2,
-3,
-1,
-2,
-2,
-1,
-1,
-1,
-2,
-1,
-1,
-1,
-2,
-1,
-2,
-1,
-2,
-1,
-1,
-1,
-1,
-1,
-1,
-1,
-1,
-1,
-1,
-1,
-1,
-1,
0,
-1,
0,
-1,
0,
-1,
0,
0,
0,
0,
0,
0,
0,
0,
0,
0,
0,
0,
0,
0,
0,
0,
0);
end Tresses.Samples.Sample_909hh_open_half_rate;
