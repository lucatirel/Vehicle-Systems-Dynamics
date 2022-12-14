s = tf('s')

%DC Motor Parameters 
R = 0.486;                                       %Armature Resistance in Ohm
La = 0.274*10^-3;                                 %Armature Inductance in Henri
Jm = 1.72 *10^-6;                                %Rotor in kg.m^2 
Km = 1.18*10^-3;                                %Motor Troque Constant in N.m/Amp
Bm = 7.33*10^-8/(2*pi);                         %Motor viscous friction constant in N.m/rpm
Ke=Km;

% OpenLoop Dynamics of FREE LOAD Velcoity Control Problem 
s = tf("s");
P_Armature= tf([Km],[La R]);                          %Armature Transfer Function
P_Rotor = tf([1],[Jm Bm]);                              %Rotor Transfer Function
motor= feedback(P_Armature*P_Rotor,Ke);               %Motor Transfer Function
LoopFunction = tf(motor)                             %OPEN loop Function
SIZE = size(LoopFunction);                             %Size of OPen loop Function 
Stability = allmargin(LoopFunction);
damp(motor)