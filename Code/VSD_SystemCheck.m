syms m g Ixx Iyy Izz
syms x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 u1 u2 u3 u4 u5
syms u1 u2 u3 u4 u5

% Parameters
m = 1.331;
g = 9.807;
Ixx = 1.03e-2;
Iyy = 9.02e-3;
Izz = 1.72e-2;
    
% Dynamics
x = [x1; x2; x3; x4; x5; x6; x7; x8; x9; x10; x11; x12];
u = [u1; u2; u3; u4; u5];

% State dynamics
fx = [x2;
     0;
     x4;
     0;
     x6;
     g;
     x8;
     (1/Ixx)*(Iyy - Izz)*x10*x12;
     x10;
     (1/Iyy)*(Izz - Ixx)*x8*x12;
     x12;
     (1/Izz)*(Ixx - Iyy)*x8*x10];

% Control input 
gx = [0 0 0 0 0;
      (1/m)*cos(x9)*cos(x11) (1/m)*(sin(x9)*cos(x11)*cos(x7) + sin(x11)*sin(x7)) 0 0 0;
      0 0 0 0 0;
      (1/m)*cos(x9)*sin(x11) (1/m)*(sin(x9)*sin(x11)*cos(x7) - cos(x11)*sin(x7)) 0 0 0;
      0 0 0 0 0;
      -(1/m)*sin(x9) (1/m)*cos(x9)*cos(x7) 0 0 0;
      0 0 0 0 0;
      0 0 (1/Ixx) 0 0;
      0 0 0 0 0;
      0 0 0 (1/Iyy) 0;
      0 0 0 0 0;
      0 0 0 0 (1/Izz)];

g1x = gx(:,1);
g2x = gx(:,2);
g3x = gx(:,3);
g4x = gx(:,4);
g5x = gx(:,5);

% Output
% hx = [x1; x2; x3; x4; x5; x6; x7; x8; x9; x10; x11; x12];
% hx = x1 + x2 + x3 + x4 + x5 + x6 + x7 + x8 + x9 + 10 + x11 + x12;
hx = [x2; x4; x6; x8; x10; x12];
hx1 = hx(1);
hx2 = hx(2);
hx3 = hx(3);
xh4 = hx(4);
hx5 = hx(5);
hx6 = hx(6);

% Initial state
x0 = [0;0;0;0;0;0;0;0;0;0;0;0];

% Computing equilibrium points of the nonlinear system
fun = @(x0) double(subs(fx,x,x0))
xe = fsolve(fun, x0)  % (only the origin is an equilibrium)


% Compute Linear approximation
A = jacobian(fx, x);
A0 = subs(A, x, x0);

B = subs(gx, x, x0);

dh = jacobian(hx, x);
C = subs(dh, x0);

% Compute rank of R and O of lin. approx
Reach = ctrb(A0, B);
rR = rank(Reach);
Obsv = obsv(A0, C);
rC = rank(Obsv);

% Computing equilibrium points of the nonlinear system
fun = @(x0) double(subs(fx,x,x0));
xe = fsolve(fun, x0);
 
% O = []
% for i = 1:length(hx)
%     disp("Computing observability distribution for output: " + string(hx(i)))
%     
%     dh_i = jacobian(hx(i), x);
%     O_hi = [hx(i); 
%             dh_i*fx;
%             jacobian(dh_i*fx, x)*fx;
%             jacobian(jacobian(dh_i*fx, x)*fx, x)*fx;
%             jacobian(jacobian(jacobian(dh_i*fx, x)*fx, x)*fx, x)*fx;
%             jacobian(jacobian(jacobian(jacobian(dh_i*fx, x)*fx, x)*fx, x)*fx, x)*fx;
%             jacobian(jacobian(jacobian(jacobian(jacobian(dh_i*fx, x)*fx, x)*fx, x)*fx, x)*fx, x)*fx;
%             jacobian(jacobian(jacobian(jacobian(jacobian(jacobian(dh_i*fx, x)*fx, x)*fx, x)*fx, x)*fx, x)*fx, x)*fx;
%             jacobian(jacobian(jacobian(jacobian(jacobian(jacobian(jacobian(dh_i*fx, x)*fx, x)*fx, x)*fx, x)*fx, x)*fx, x)*fx, x)*fx;
%             jacobian(jacobian(jacobian(jacobian(jacobian(jacobian(jacobian(jacobian(dh_i*fx, x)*fx, x)*fx, x)*fx, x)*fx, x)*fx, x)*fx, x)*fx, x)*fx;
%             jacobian(jacobian(jacobian(jacobian(jacobian(jacobian(jacobian(jacobian(jacobian(dh_i*fx, x)*fx, x)*fx, x)*fx, x)*fx, x)*fx, x)*fx, x)*fx, x)*fx, x)*fx;
%             jacobian(jacobian(jacobian(jacobian(jacobian(jacobian(jacobian(jacobian(jacobian(jacobian(dh_i*fx, x)*fx, x)*fx, x)*fx, x)*fx, x)*fx, x)*fx, x)*fx, x)*fx, x)*fx, x)*fx;];
%     O = [O O_hi];
% end





%% Linearization
% syms x10 x20 x30 x40 x50 x60 x70 x80 x90 x100 x110 x120 
x0_t = {x1; x2; x3; x4; x5; x6; x7; x8; x9; x10; x11; x12};

A0 = subs(A, x, x0_t);
B = subs(gx, x, x0_t);
C = dh;
D = [0 0 0 0 0;
     0 0 0 0 0; 
     0 0 0 0 0;
     0 0 0 0 0;
     0 0 0 0 0;
     0 0 0 0 0];

% define input shape
state = [x0_t{:}];

% Centralized
matlabFunction(B, 'File', 'Linearize_B', 'Vars', {transpose(state)});
matlabFunction(A0, 'File', 'Linearize_A', 'Vars', {transpose(state)});

% 
% Lg1_h1 = jacobian(hx1,x)*g1x;
% Lg1_Lf_h1 = jacobian(jacobian(hx1, x)*fx, x)*g1x;
% Lg1_Lf2_h1 = jacobian(jacobian(jacobian(hx1,x)*fx, x)*fx, x)*g1x;
% % Lg1_Lf3_h1 = jacobian(jacobian(jacobian(hx1,x)*fx, x)*fx, x)*g1x;

% dh = jacobian(hx1, x);
% Lg1_h1 = dh*g1x
% 
% Lf_h1 = dh*fx;
% Lg_Lf_h1 = jacobian(Lf_h1, x)*g1x
% 
% Lf2_h1 = jacobian(Lf_h1, x)*fx;
% Lg_Lf2_h1 = jacobian(Lf2_h1, x)*g1x
% 
% Lf3_h1 = jacobian(Lf2_h1, x)*fx;
% Lg_Lf3_h1 = jacobian(Lf3_h1, x)*g1x
% 
% Lf4_h1 = jacobian(Lf3_h1, x)*fx;
% Lg_Lf4_h1 = jacobian(Lf4_h1, x)*g1x
% 
% Lf5_h1 = jacobian(Lf4_h1, x)*fx;
% Lg_Lf5_h1 = jacobian(Lf5_h1, x)*g1x
% 
% Lf6_h1 = jacobian(Lf5_h1, x)*fx;
% Lg_Lf6_h1 = jacobian(Lf6_h1, x)*g1x
% 
% Lf7_h1 = jacobian(Lf6_h1, x)*fx;
% Lg_Lf7_h1 = jacobian(Lf7_h1, x)*g1x
% 
% Lf8_h1 = jacobian(Lf7_h1, x)*fx;
% Lg_Lf8_h1 = jacobian(Lf8_h1, x)*g1x
% 
% Lf9_h1 = jacobian(Lf8_h1, x)*fx;
% Lg_Lf9_h1 = jacobian(Lf9_h1, x)*g1x
% 
% Lf10_h1 = jacobian(Lf9_h1, x)*fx;
% Lg_Lf10_h1 = jacobian(Lf10_h1, x)*g1x
% 
% Lf11_h1 = jacobian(Lf10_h1, x)*fx;
% Lg_Lf11_h1 = jacobian(Lf11_h1, x)*g1x
% 
% Lf12_h1 = jacobian(Lf11_h1, x)*fx;
% Lg_Lf12_h1 = jacobian(Lf12_h1, x)*g1x
% 


% Lgh = dh*g1x;
% LgLfh = jacobian(dh*fx, x)*g1x;