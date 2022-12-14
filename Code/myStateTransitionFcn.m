function x_k = myStateTransitionFcn_test(x, u)
m = 1.331;
g = 9.807;
Ixx = 1.03e-2;
Iyy = 9.02e-3;
Izz = 1.72e-2;
Ts = 0.01;

% Position Discretized Dynamics
x1_k = x(1) + x(2)*Ts;
x2_k = x(2) + ((1/m)*cos(x(9))*cos(x(11))*u(1) + (1/m)*(sin(x(9))*cos(x(11))*cos(x(7)) + sin(x(11))*sin(x(7)))*u(2))*Ts;
x3_k = x(3) + x(4)*Ts;
x4_k = x(4) + ((1/m)*cos(x(9))*sin(x(11))*u(1) + (1/m)*(sin(x(9))*sin(x(11))*cos(x(7)) - cos(x(11))*sin(x(7)))*u(2))*Ts;
x5_k = x(5) + x(6)*Ts;
x6_k = x(6) + (g - (1/m)*sin(x(9))*u(1) + (1/m)*cos(x(9))*cos(x(7))*u(2))*Ts;

% Rotations Discretized Dynamics
x7_k = x(7) + x(8)*Ts;
x8_k = x(8) + ((1/Ixx)*(Iyy - Izz)*x(10)*x(12) + (1/Ixx)*u(3))*Ts;
x9_k = x(9) + x(10)*Ts;
x10_k = x(10) + ((1/Iyy)*(Izz - Ixx)*x(8)*x(12) + (1/Iyy)*u(4))*Ts;
x11_k = x(11) + x(12)*Ts;
x12_k = x(12) + ((1/Izz)*(Ixx - Iyy)*x(8)*x(10) + (1/Izz)*u(5))*Ts;

% Discrete state dynamic x(k+1) = f(x(k), u(k)) + g(x(k))*u(k)
x_k = [x1_k; x2_k; x3_k; x4_k; x5_k; x6_k; x7_k; x8_k; x9_k; x10_k; x11_k; x12_k];

end


