%% Copyright 2014 MERCIER David
function model_bec(OPTIONS)
%% Function used to calculate Young's modulus in bilayer system with
% the model of Bec et al. (2006)
gui = guidata(gcf);

x = gui.data.h;

bilayer_model = @(Ef_red_sol, x) ...
    (1e-9*(((2.*gui.results.ac)./(1+2.*(gui.results.t_corr)./(pi.*gui.results.ac))) .* ...
    (((gui.results.t_corr)./(pi.*gui.results.ac.^2.*1e9*Ef_red_sol) + ...
    (1./(2.*gui.results.ac.*gui.data.Es_red))))).^-1);

% Make a starting guess
gui.results.Ef_red_sol0 = ...
    str2double(get(gui.handles.value_youngfilm1_GUI, 'String')) / ...
    (1-gui.data.nuf.^2);

[gui.results.Ef_red_sol_fit, ...
    gui.results.resnorm, ...
    gui.results.residual, ...
    gui.results.exitflag, ...
    gui.results.output, ...
    gui.results.lambda, ...
    gui.results.jacobian] =...
    lsqcurvefit(bilayer_model, gui.results.Ef_red_sol0, x, ...
    gui.results.Esample_red, ...
    gui.config.numerics.Min_YoungModulus, ...
    gui.config.numerics.Max_YoungModulus, ...
	OPTIONS);

gui.results.Ef_sol_fit = gui.results.Ef_red_sol_fit * ...
    (1-gui.data.nuf^2);

gui.results.Em_red = 1e-9 * ...
    (((2.*gui.results.ac)./(1+2.*(gui.results.t_corr)./(pi.*gui.results.ac))) .* ...
    ((gui.results.t_corr./(pi.*gui.results.ac.^2.*(1e9*gui.results.Ef_red_sol_fit)) ...
    + (1./(2.*gui.results.ac*gui.data.Es_red))))).^-1;

gui.results.Ef_red = 1e-9 * ...
    (((pi.*gui.results.ac.^2)./(gui.results.t_corr)) .* ...
    (((1./(1e9.*gui.results.Esample_red)) .* ...
    (((1+2.*(gui.results.t_corr)./(pi.*gui.results.ac)))./(2.*gui.results.ac))) - ...
    (1./(2.*gui.results.ac.*gui.data.Es_red)))).^-1;

guidata(gcf, gui);

end