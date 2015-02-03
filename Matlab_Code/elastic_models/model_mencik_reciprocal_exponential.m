%% Copyright 2014 MERCIER David
function model_mencik_reciprocal_exponential(OPTIONS)
%% Function used to calculate Young's modulus in bilayer system with
% the reciprocal exponential model of Mencik et al. (1997)
gui = guidata(gcf);

if get(gui.handles.cb_corr_thickness_GUI, 'Value') == 1
    set(gui.handles.cb_corr_thickness_GUI, 'Value', 0);
    commandwindow;
    warning(['The correction of the thickness can''t be used ', ...
        'with Mencik''s reciprocal exponential model']);
end

x = gui.results.ac./gui.data.t;

% Minimum and maximum boundaries for the constant alpha
min_alpha = gui.config.numerics.alpha_min_Mencik;
max_alpha = gui.config.numerics.alpha_max_Mencik;

% A(1) = ln(abs(1/Ef-1/Es))
% A(2) = -alpha
bilayer_model = @(A, x) (A(1) + A(2)*x);

Ef_red = str2double(get(gui.handles.value_youngfilm1_GUI, 'String')) / ...
    (1-gui.data.nuf.^2);

% Make a starting guess
gui.results.A0 = [log(abs((1/Ef_red)-(1/(gui.data.Es_red*1e-9)))); ...
    (min_alpha + max_alpha)/2];

[gui.results.A, ...
    gui.results.resnorm, ...
    gui.results.residual, ...
    gui.results.exitflag, ...
    gui.results.output, ...
    gui.results.lambda, ...
    gui.results.jacobian] =...
    lsqcurvefit(bilayer_model, gui.results.A0, x, ...
    log(abs((1./gui.results.Esample_red) - (1./(gui.data.Es_red*1e-9)))), ...
    [-100; min_alpha], ...
    [100; max_alpha], ...
    OPTIONS);

%TODO: Check this condition (not in agreement with Mencik's paper...)
if sum(gui.results.Esample_red - (gui.data.Es_red*1e-9)) < 0
    k = 1;
else
    k = -1;
end

gui.results.Ef_red_sol_fit(1) = 1/((1/(gui.data.Es_red*1e-9)) + ...
    k * exp(gui.results.A(1)));

gui.results.Ef_sol_fit(1) = gui.results.Ef_red_sol_fit(1) * ...
    (1-gui.data.nuf^2);

gui.results.Ef_sol_fit(2) = gui.results.A(2); % -alpha

gui.results.Em_red = (1/(gui.data.Es_red*1e-9) + ...
    (((1/gui.results.Ef_red_sol_fit(1)) - (1/(gui.data.Es_red*1e-9))) .* ...
    exp(gui.results.A(2) .* x))).^-1;

gui.results.Ef_red(1:length(x)) = gui.results.Ef_red_sol_fit(1);
gui.results.Ef_red = gui.results.Ef_red';

guidata(gcf, gui);

end