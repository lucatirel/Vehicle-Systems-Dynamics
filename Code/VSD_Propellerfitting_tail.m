%% Import data
horizon = 15;
num_values = 30;

for n = 1:horizon
    a = importdata('PER3_6x5_Tailpropeller.txt', ' ', 17+(num_values + 7)*(n-1));
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
        Pe(m,n) = table{n}(m,3);   % 3 is Pe column
        Tl(m,n) = table{n}(m,7);   % 3 is Pe column
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
[x_RPM, y_J, z_Pe] = prepareSurfaceData(vec_RPM, vec_J, Pe);
[x_RPM, y_J, z_Tl] = prepareSurfaceData(vec_RPM, vec_J, Tl);

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
% fit_Ct_tail = @(u)feval(fitted_Ct_tail,u);
% fit_Cp_tail = @(u)feval(fitted_Cp_tail,u);
% fit_Pe_tail = @(u)feval(fitted_Pe_tail,u);
% fit_Tl_tail = @(u)feval(fitted_Tl_tail,u);
f_Ct_tail = fit([x_RPM, y_J], z_Ct , 'cubicinterp');
f_Cp_tail = fit([x_RPM, y_J], z_Cp , 'cubicinterp');
f_Pe_tail = fit([x_RPM, y_J], z_Pe , 'cubicinterp');
f_Tl_tail = fit([x_RPM, y_J], z_Tl , 'cubicinterp');

fit_Ct_tail = @(u)feval(f_Ct_tail,u);
fit_Cp_tail = @(u)feval(f_Cp_tail,u);
fit_Pe_tail = @(u)feval(f_Pe_tail,u);
fit_Tl_tail = @(u)feval(f_Tl_tail,u);

% function f_Ct_tail = fitted_Ct_tail(x_RPM, y_J, f_Ct_tail)
%     if x_RPM < 1000 | y_J < 0
%         f_Ct_tail = 0;
%     else
%         f_Ct_tail = f_Ct_tail(x_RPM, y_J);
%     end
% end
% 
% 
% function f_Cp_tail = fitted_Cp_tail(x_RPM, y_J)
%     if x_RPM < 1000 | y_J < 0
%         f_Cp_tail = 0;
%     else
%         f_Cp_tail = fit([x_RPM, y_J], z_Cp , 'cubicinterp');
%     end
% end

% fitted_Ct_tail = fit([x_RPM, y_J], z_Cp , 'cubicinterp');
% fitted_Cp_tail = fit([x_RPM, y_J], z_Cp , 'cubicinterp');
% fitted_Pe_tail = fit([x_RPM, y_J], z_Pe , 'cubicinterp');
% fitted_Tl_tail = fit([x_RPM, y_J], z_Tl , 'cubicinterp');

% fit_Ct_tail = @(u)feval(fitted_Ct_tail,u);
% fit_Cp_tail = @(u)feval(fitted_Cp_tail,u);
% fit_Pe_tail = @(u)feval(fitted_Pe_tail,u);
% fit_Tl_tail = @(u)feval(fitted_Tl_tail,u);



% %% Plots
% figure(1)
% plot(f_Ct_tail, [x_RPM y_J], z_Ct)
% title('Ct fitting - TAIL PROPELLER')
% 
% figure(2)
% plot(fitted_Cp_tail, [x_RPM y_J], z_Cp)
% title('Cp fitting - TAIL PROPELLER')

% 
% figure(3)
% plot(fitted_Pe_tail, [x_RPM y_J], z_Pe)
% title('Pe fitting - TAIL PROPELLER')
% 
% 
% figure(4)
% plot(fitted_Tl_tail, [x_RPM y_J], z_Tl)
% title('Tl fitting - TAIL PROPELLER')
% 
