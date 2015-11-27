%% Copyright 2014 MERCIER David
function model_mercier_2layers(OPTIONS)
%% Function used to calculate Young's modulus in multiilayer system with
% the model of Mercier et al. (2010)
gui = guidata(gcf);

x = gui.data.h;
x = checkValues(x);

ac1 = gui.results.ac1;
ac0 = gui.results.ac0;
t1 = gui.results.t1_corr;
t0 = gui.results.t0_corr;
E0 = gui.data.E0_red;
Es = gui.data.Es_red;
Esample = gui.results.Esample_red;

multilayer_model = @(Ef_red_sol, x) ...
    1e-9 .* (((2.*ac1.*((t1./(((pi.*ac1.^2)+(2.*ac1.*t1)).*1e9*Ef_red_sol)) + ...
    (t0./(((pi.*ac0.^2)+(2.*ac0.*t0)).*E0)) + ...
    (1./((2.*(ac0+((2.*t0)./pi))).*Es)))).^-1));

% Make a starting guess
gui.results.A0 = reduced_YM(...
    str2double(get(gui.handles.value_youngfilm1_GUI, 'String')),...
    gui.data.nuf);

[gui.results.Ef_red_sol_fit, ...
    gui.results.resnorm, ...
    gui.results.residual, ...
    gui.results.exitflag, ...
    gui.results.output, ...
    gui.results.lambda, ...
    gui.results.jacobian] =...
    minimizationProcess(multilayer_model, gui.results.A0, x, ...
    gui.results.Esample_red, ...
    gui.config.numerics.Min_YoungModulus, ...
    gui.config.numerics.Max_YoungModulus, ...
    OPTIONS);

Ef_red_sol_fit = gui.results.Ef_red_sol_fit;

gui.results.Ef_sol_fit = non_reduced_YM(Ef_red_sol_fit, gui.data.nuf);

gui.results.Em_red = 1e-9 .* ...
    ((2.*ac1.*((t1./(((pi.*ac1.^2)+(2.*ac1.*t1)).*1e9*Ef_red_sol_fit)) + ...
    (t0./(((pi.*ac0.^2)+(2.*ac0.*t0)).*E0)) + ...
    (1./((2.*(ac0+((2.*t0)./pi))).*Es)))).^-1);

gui.results.Ef_red = 1e-9.*(((((pi.*ac1.^2)+(2.*ac1.*t1))./t1).*...
    ((1./(2.*ac1.*(1e9.*Esample))) - ...
    ((t0./((pi.*(ac0.^2)+2.*t0.*ac0).*E0)) + ...
    (1./((2.*(ac0+((2.*t0)./pi))).*Es))))).^-1);

guidata(gcf, gui);

end