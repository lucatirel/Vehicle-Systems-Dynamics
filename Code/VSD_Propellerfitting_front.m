%% Import data
horizon = 13;
num_values = 30;

for n = 1:horizon
    a = importdata('PER3_5x45E_Frontrotor.txt', ' ', 17+(num_values + 7)*(n-1));
    table{n} = a.data;
end

% PRINT TO UNDERSTAND
%table{1}
%table{1}(:,3)




%% Creo matrices Ct e Cp of data in the table
vec_RPM = 1000*(1:horizon);     % RPM vector (lenght = horizon)
vec_J = table{1}(:,2)';         % Advance ratio vector (lenght = num_values)

for m = 1:num_values
    for n = 1:horizon
        Ct(m,n) = table{n}(m,4);   % 4 is Ct column
        Cp(m,n) = table{n}(m,5);   % 5 is Cp column
    end
end


% PRINT TO UNDERSTAND
%vec_RPM
%vec_J
%Cp
%Ct


%% Data reshaping for fitting 
[x_RPM, y_J, z_Ct] = prepareSurfaceData(vec_RPM, vec_J, Ct);
[x_RPM, y_J, z_Cp] = prepareSurfaceData(vec_RPM, vec_J, Cp);


% PRINT TO UNDERSTAND
% Input sizes
%size(Ct)
%length(vec_RPM)
%length(vec_J)
% Output sizes
%length(x_RPM)
%length(y_J)
%length(z_Ct)


%% Polynomial fitting
% fitted_Ct = fit([x_RPM, y_J], z_Ct , 'poly42');
% fitted_Cp = fit([x_RPM, y_J], z_Cp , 'poly42');

fitted_Ct_norm = fit([x_RPM, y_J], z_Ct , 'poly42', 'Normalize', 'on');
fitted_Cp_norm = fit([x_RPM, y_J], z_Cp , 'poly42', 'Normalize', 'on');


%% Plots
% figure(1)
% plot(fitted_Ct, [x_RPM y_J], z_Ct)
% title('Ct fitting')
% 
% figure(2)
% plot(fitted_Cp, [x_RPM y_J], z_Cp)
% title('Cp fitting')

figure(3)
plot(fitted_Ct_norm, [x_RPM y_J], z_Ct)
title('Ct fitting (Normalized)')

figure(4)
plot(fitted_Cp_norm, [x_RPM y_J], z_Cp)
title('Cp fitting (Normalized)')

