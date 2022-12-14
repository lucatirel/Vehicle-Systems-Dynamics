%Vehicle Dynamics Projects 2022
%Elham Honarvar, Ali Mohammad Ali Hassan Ali, Luca Tirel

clear all
close all

%% PARAMETERS AND VARIABLES
global k1 k2 k3 k4 k5 k6 k7 k8 k9 k10 k11 k12 g Ixx Iyy Izz l1 l2 l3 J a1 a2 a3 b1 b2 b3 m x0 eta1 eta2 eta3 
global ctr ctf cq

% [k1, k2, k3, k4, k5, k6, k7, k8, k9, k10, k11, k12, g, Ixx, Iyy, Izz, l1, l2, l3, J, a1, a2, a3, b1, b2, b3, m, x0, eta1, eta2, eta3, ctr, ctf, ctq]

% Define K
k1=1;
k2=2;
k3=2;
k4=3;
k5=1;
k6=3;
k7=2;
k8=5;
k9=3;
k10=7;
k11=5;
k12=3;

% Gravity
g = 9.807;

% Inertias and related quantities
Ixx = 1.03e-2;
Iyy = 9.02e-3;
Izz = 1.72e-2;

J = [Ixx 0 0;
     0 Iyy 0;
     0 0 Izz;];

a1 = 1/Ixx;
a2 = 1/Iyy;
a3 = 1/Izz;
b1=(Iyy-Izz)/Ixx;
b2=(Izz-Ixx)/Iyy;
b3=(Ixx-Iyy)/Izz;

% Adaptive parameters (bigger than disturbances)
eta1=1;
eta2=1;
eta3=1;

% Thrust and Drag coefficients
ctf = 1.63e-5;  %front
ctr = 9.6e-6;   %rear
cq = 2.4e-7;    %

% Internal lenghts
l1 = 0.240;
l2 = 0.078;
l3 = 0.151;

% Mass
m = 1.331;

% Drone initial position
x0 = [0,0,0,0,0,0,0,0,0,0,0,0];

% States bounds
ub = [inf; 10; inf; 10; inf; 10; 0.1; 0.5; 1; 2; 0.01; 0.1];
lb = -ub;

%% State Estimation
% Process noise covariance
Q = 1e-6;

% Measurement noise covariance
R = 1e-3;

% Sampling time (Sensors)
Ts = 1e-4; % [s] 
