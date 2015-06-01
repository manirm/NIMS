%% Copyright 2014 MERCIER David
function model_doerner_nix_king(OPTIONS)
%% Function used to calculate Young's modulus in bilayer system with
% the model of Doerner & Nix (1986) modified by King (1987)
gui = guidata(gcf);

x = gui.results.t_corr./gui.results.ac;
x = checkValues(x);

% A(1) = Ef_red
% A(2) = alpha
bilayer_model = @(A, x) ...
    (1e-9*(((1./(1e9*A(1)))*(1-exp(-A(2)*x))) + ...
    ((1./gui.data.Es_red)*(exp(-A(2)*x)))).^-1);
	
% Minimum and maximum boundaries for the constant alpha
min_alpha = gui.config.numerics.alpha_min_DoernerNix;
max_alpha = gui.config.numerics.alpha_max_DoernerNix;

% Make a starting guess
Ef_red = reduced_YM(...
    str2double(get(gui.handles.value_youngfilm1_GUI, 'String')),...
    gui.data.nuf);
gui.results.A0 = [Ef_red; (min_alpha + max_alpha)/2];

[gui.results.Ef_red_sol_fit, ...
    gui.results.resnorm, ...
    gui.results.residual, ...
    gui.results.exitflag, ...
    gui.results.output, ...
    gui.results.lambda, ...
    gui.results.jacobian] =...
    lsqcurvefit(bilayer_model, gui.results.A0, x, ...
    gui.results.Esample_red, ...
    [gui.config.numerics.Min_YoungModulus; min_alpha], ...
    [gui.config.numerics.Max_YoungModulus; max_alpha], ...
    OPTIONS);

gui.results.Ef_sol_fit = non_reduced_YM(gui.results.Ef_red_sol_fit(1), ...
    gui.data.nuf);

gui.results.Ef_sol_fit(2) = gui.results.Ef_red_sol_fit(2);

gui.results.Em_red = ...
    (1e-9*(((1./(1e9*gui.results.Ef_red_sol_fit(1)))*(1-exp(-gui.results.Ef_red_sol_fit(2)*x))) + ...
    ((1./gui.data.Es_red)*(exp(-gui.results.Ef_red_sol_fit(2)*x)))).^-1);

gui.results.Ef_red = 1e-9*(((1./(1e9.*gui.results.Esample_red)) - ...
    ((1./gui.data.Es_red)*(exp(-gui.results.Ef_red_sol_fit(2).*x))))./(1-exp(-gui.results.Ef_red_sol_fit(2).*x))).^-1;

guidata(gcf, gui);

end