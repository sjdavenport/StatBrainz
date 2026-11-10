
#ifndef BATCH7CNF

#define BATCH7CNF \
"r=1;"\
"T=0.25;"\
"q=1.0;"\
"R=1;"\
"s=2;"\
"a=0.49;"\
"A=0.2;"\
"M=10000;"\
"e=3 ;"\
"continue=1;"\
"E=500;"\
"reducepool=1;"\
"insertclusteradv=0.2;"\
"poolreduction_threshold=0.5;"\
"poolreduction_eqthreshold=0.1;"\
"poolreduction_resetfittness=1;"\
"repeats=1000;"\
"PS:X0   a=0.1 A=0.1 q=0.0005;"\
"PS:X1   a=0.1 A=0.1 q=0.001;"\
"PS:X2   a=0.1 A=0.1 q=0.002;"\
"PS:X2   a=0.1 A=0.1 q=0.004;"\
"PS:X5   a=0.1 A=0.1 q=0.007;"\
"PS:X10  a=0.1 A=0.1 q=0.010;"\
"PS:X20  a=0.25 A=0.1 q=0.020;"\
"PS:X30  a=0.25 A=0.1 q=0.030;"\
"PS:X40  a=0.2  A=0.1 q=0.040;"\
"PS:X50  a=0.3  A=0.1 q=0.050;"\
"PS:X60  a=0.35 A=0.1 q=0.060;"\
"PS:X70  a=0.35 A=0.1 q=0.070;"\
"PS:X90  a=0.4  A=0.1 q=0.090;"\
"PS:X100 a=0.4  A=0.1 q=0.100;"\
"PS:X110 a=0.4  A=0.1 q=0.110;"\
"PS:X130 a=0.45 A=0.1 q=0.130;"\
"PS:X150 a=0.45 A=0.1 q=0.150;"\
"PS:X200 a=0.45 A=0.1 q=0.200;"\
"PS:X300 a=0.5 A=0.1 q=0.300;"\
"PS:X400 a=0.5 A=0.1 q=0.400;"\
"PS:X500 a=0.5 A=0.1 q=0.500;"\
"PS:X600 a=0.5 A=0.1 q=0.600;"\
"PS:X800 a=0.5 A=0.1 q=0.800;"\
"PS:X1002 k2sizeratio>0.2 a=0.1 A=0.05 s=1;"\
"PS:I60  initial=1 size>=0 size<60  repeats=10;"\
"PS:I300 initial=1 size>=60 size<300 repeats=20;"\
"PS:I400 initial=1 size>=300 size<400 repeats=50;"\
"PS:I600 initial=1 size>=400 size<600 repeats=500;"\
"PS:I1k  initial=1 size>=600 size<1999 repeats=500;"\
"PS:X1002 size<2000 k2sizeratio>0.2 a=0.1 A=0.05 s=1;"\
"PS:I2k initial=1 size>=2000 size<2999 repeats=500;"\
"PS:I3k initial=1 size>=3000 size<3999 repeats=500;"

#endif