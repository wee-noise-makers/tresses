package Tresses.Samples.Sample_909hh_close_half_rate
with Preelaborate
is
   pragma Style_Checks (Off);
   Sample : aliased constant S8_Array := (
-4,
13,
17,
4,
-10,
-9,
-15,
-26,
-7,
0,
8,
-9,
-21,
-4,
14,
11,
2,
13,
-4,
2,
-5,
-13,
12,
6,
3,
-14,
15,
-5,
-13,
-27,
-21,
-11,
-8,
4,
-4,
9,
2,
-3,
13,
25,
8,
0,
3,
-21,
1,
-15,
3,
20,
-1,
-6,
11,
4,
-21,
1,
-11,
-22,
-3,
1,
18,
9,
4,
-15,
-1,
9,
-7,
7,
-17,
-8,
-16,
5,
18,
5,
-10,
-30,
-8,
-10,
3,
7,
-10,
-14,
-9,
10,
0,
9,
3,
-13,
-3,
1,
-4,
-14,
-5,
-1,
-4,
-1,
4,
7,
-8,
-20,
2,
-19,
5,
13,
6,
10,
0,
-12,
4,
0,
-5,
3,
-7,
-6,
-11,
-12,
6,
-5,
-3,
0,
1,
15,
-5,
5,
-11,
-2,
0,
-7,
-8,
-11,
-13,
-30,
-1,
-11,
4,
3,
-13,
-4,
-4,
10,
1,
8,
5,
-1,
-6,
-8,
-9,
-7,
-5,
-27,
2,
-2,
-5,
-10,
-13,
-2,
18,
6,
0,
22,
2,
-2,
-7,
-9,
-12,
-16,
-6,
-11,
-7,
6,
4,
4,
11,
16,
6,
4,
-7,
-12,
2,
-1,
-4,
-10,
-12,
-13,
0,
-21,
-7,
5,
9,
7,
-2,
1,
-5,
-9,
3,
-3,
-3,
3,
-5,
11,
-7,
-10,
2,
-12,
-10,
5,
-12,
-9,
-1,
6,
18,
25,
-4,
12,
5,
-7,
9,
-11,
-13,
-15,
-12,
-10,
-6,
-4,
-3,
-2,
4,
13,
17,
10,
6,
-6,
-9,
-12,
-22,
-2,
2,
2,
-7,
3,
-4,
5,
10,
-4,
-8,
-8,
10,
-2,
0,
-10,
-2,
4,
-9,
-3,
14,
8,
5,
2,
2,
7,
12,
-14,
-3,
-7,
-1,
7,
-1,
-1,
5,
-5,
-14,
-12,
-4,
-7,
-4,
-2,
-11,
14,
8,
20,
6,
5,
7,
4,
-15,
-21,
-14,
-26,
-7,
-10,
-7,
7,
5,
9,
13,
11,
8,
19,
-2,
4,
-10,
-20,
-2,
-16,
-9,
-19,
0,
4,
-3,
10,
-1,
14,
14,
9,
-3,
3,
-5,
-16,
-1,
-6,
-10,
-4,
-1,
-3,
5,
9,
5,
19,
-10,
-17,
-10,
-25,
-10,
-14,
-4,
6,
7,
6,
-5,
-7,
-3,
6,
-13,
-10,
2,
-7,
6,
2,
4,
3,
-3,
-1,
-12,
-6,
-3,
7,
-6,
-9,
-7,
0,
8,
-3,
3,
8,
13,
10,
-12,
-4,
-7,
-6,
-4,
-11,
-12,
2,
-1,
-5,
-8,
0,
2,
-2,
-6,
-5,
4,
0,
-2,
-8,
0,
-3,
2,
-1,
-14,
9,
-2,
-8,
-6,
-10,
-11,
-7,
-5,
-16,
-2,
2,
-1,
4,
-7,
4,
-9,
-8,
-4,
-15,
-6,
-11,
-3,
1,
1,
4,
4,
-9,
3,
-1,
-10,
-4,
-8,
-5,
-10,
-5,
6,
-3,
9,
4,
6,
12,
-11,
0,
-1,
2,
-8,
-5,
-12,
-12,
4,
-9,
1,
0,
-5,
3,
-5,
-6,
-6,
-9,
9,
-6,
-6,
-1,
-6,
-2,
-2,
-10,
-2,
6,
-4,
-6,
-13,
-10,
0,
-8,
-8,
-3,
3,
4,
-5,
-4,
-9,
2,
-6,
-6,
-2,
-10,
-5,
-7,
-6,
-5,
5,
2,
-7,
-4,
-11,
-10,
2,
-7,
1,
5,
-11,
-7,
4,
1,
-1,
6,
-1,
-5,
-4,
-5,
-7,
-7,
-1,
-7,
-6,
-5,
-5,
-4,
-5,
2,
-5,
1,
-4,
-8,
-8,
-10,
-9,
-8,
-3,
-1,
0,
4,
-4,
-3,
-1,
-5,
-1,
0,
-5,
-11,
-3,
-6,
-2,
5,
2,
1,
0,
1,
-7,
-1,
2,
-3,
1,
-3,
-9,
-8,
-3,
-4,
3,
9,
8,
2,
1,
-2,
-5,
-4,
-3,
-3,
-2,
-3,
-5,
-2,
0,
-1,
4,
5,
1,
-2,
-5,
-7,
-10,
-8,
-1,
-5,
-1,
-3,
-9,
-3,
-3,
-2,
-1,
-2,
-5,
-6,
-5,
-6,
-3,
-2,
-1,
-4,
-1,
-4,
-6,
-4,
-3,
-2,
3,
3,
-3,
-2,
-1,
-1,
0,
3,
5,
2,
0,
-4,
-4,
-2,
-2,
1,
3,
2,
-1,
0,
-1,
-2,
3,
1,
2,
1,
-3,
-7,
-5,
-3,
-3,
1,
2,
0,
0,
-1,
-3,
-2,
-1,
-1,
-2,
-2,
-7,
-7,
-3,
-2,
1,
2,
2,
0,
-1,
-4,
-4,
-2,
-1,
-1,
-3,
-2,
-2,
-2,
-4,
0,
2,
2,
1,
-1,
-4,
-3,
-2,
0,
1,
1,
0,
-1,
-4,
-2,
2,
4,
2,
0,
-1,
-3,
-3,
-3,
-1,
0,
0,
0,
-2,
-2,
-2,
-2,
0,
1,
0,
-2,
-3,
-4,
-4,
-2,
0,
0,
1,
0,
-2,
-3,
-3,
-2,
0,
0,
-1,
-1,
-2,
-3,
-1,
1,
1,
0,
0,
-3,
-3,
-3,
-1,
0,
0,
0,
2,
0,
0,
0,
0,
2,
0,
0,
-2,
-2,
-2,
-1,
0,
1,
1,
-1,
0,
-1,
-1,
-1,
0,
0,
-1,
0,
-3,
-2,
-1,
-1,
0,
-1,
0,
-1,
-3,
-3,
-4,
-1,
-1,
-1,
-2,
-4,
-4,
-4,
-1,
-2,
-2,
-1,
-3,
-4,
-4,
-3,
-2,
-2,
-1,
-2,
-3,
-5,
-4,
-2,
0,
-1,
0,
-1,
-4,
-1,
0,
-1,
0,
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
-1,
0,
-1,
0,
0,
-1,
0,
0,
-1,
-3,
-3,
-3,
-2,
0,
-1,
0,
-1,
-3,
-5,
-2,
-2,
-3,
-1,
-1,
0,
-1,
0,
-1,
0,
-1,
-1,
0,
0);
end Tresses.Samples.Sample_909hh_close_half_rate;