%% Copyright 2014 MERCIER David
function plot_exp_vs_mod_setvariables
%% Function used to set variables for the plot exp. vs. mod.
gui = guidata(gcf);

if gui.flag.flag_data == 0
    helpdlg('Import data first !','!!!');
    
    %% Initialization
else
    set(gui.MainWindows, 'CurrentAxes', gui.handles.AxisPlot_GUI);
    gui.axis.title_str = '';
    gui.axis.title_str = strcat('Max displacement = ', ...
        num2str(round(max(gui.data.h))), char(gui.data.dispUnit));
    
    if gui.variables.num_thinfilm == 1 % Only a bulk material
        for ii = 1:1:length(gui.data.h)
            gui.results.Ef_red(ii) = 0;
            gui.results.Ef_red     = gui.results.Ef_red.';
            gui.results.Em_red(ii) = 0;
            gui.results.Em_red     = gui.results.Em_red.';
            gui.results.Hm(ii)     = 0;
            gui.results.Hf         = 0;
        end
        gui.data.t = max(gui.data.h)+1;
        gui.results.Ef_sol_fit = 0;
        gui.results.Ef_sol = 0;
    end
    
    if gui.variables.y_axis == 5
        for ii = 1:1:length(gui.data.h)
            if gui.data.h(ii) < gui.data.t && ...
                    gui.variables.num_thinfilm == 1
                gui.results.Ef_mean(ii) = gui.results.Ef_red(ii);
            elseif gui.data.h(ii) < gui.data.t && ...
                    gui.variables.num_thinfilm ~= 1
                gui.results.Ef_mean(ii) = gui.results.Ef(ii);
                
            end
        end
        gui.results.Ef_sol = mean(gui.results.Ef_mean);
    end
    
    %% Setting of the plot - Defintion of variables
    if gui.variables.x_axis == 1
        gui.axis.x2plot = gui.data.h;
        gui.axis.xlabelstr = ['Displacement ($h$) (', char(gui.data.dispUnit),')'];
        gui.axis.xmax = round(max(gui.data.h));
        gui.axis.xmin = 0;
    elseif gui.variables.x_axis == 2
        gui.axis.x2plot = gui.results.ac./gui.data.t;
        gui.axis.xlabelstr = 'Contact Radius ($a_c$) / Film Thickness ($t$)';
        if max(gui.results.ac./gui.data.t) < 1
            gui.axis.xmax = 1;
        else
            gui.axis.xmax = round(max(gui.results.ac./gui.data.t));
        end
        gui.axis.xmin = round(min(gui.results.ac./gui.data.t));
    elseif gui.variables.x_axis == 3
        gui.axis.x2plot = gui.data.h/gui.data.t;
        gui.axis.xlabelstr = 'Displ. ($h$) / Film Thickness ($t$)';
        if max(gui.data.h/gui.data.t) < 1
            gui.axis.xmax = 1;
        else
            gui.axis.xmax = round(max(gui.data.h/gui.data.t));
        end
        gui.axis.xmin = 0;
    end
    
    if gui.variables.y_axis == 1
        gui.axis.y2plot = gui.data.P;
        gui.axis.delta_y2plot = gui.data.delta_P;
        gui.axis.y2plot_2 = gui.results.P_fit;
        gui.axis.ylabelstr = ['Load ($L$) (', char(gui.data.loadUnit),')'];
        gui.axis.ymax = max(gui.data.P);
        gui.axis.title_str = strcat('Loading work ($W$) = ', ...
            num2str(gui.results.W_microJ), '$\mu$J / $k$(fit) = ', ...
            sprintf('%.2e', gui.results.fac_fit), ...
            ' / $n$(fit) = ', num2str(round(100*gui.results.exp_fit)/100), ...
            ' / $R^2$ = ', num2str(gui.results.rSquare));
    elseif gui.variables.y_axis == 2
        gui.axis.y2plot = gui.data.S;
        gui.axis.delta_y2plot = gui.data.delta_S;
        gui.axis.y2plot_2 = gui.results.S_fit;
        gui.axis.ylabelstr = ['Stiffness ($S$) (', char(gui.data.stifUnit),')'];
        gui.axis.ymax = max(gui.data.S);
        if gui.variables.val2 == 2
            gui.axis.title_str = strcat('$S$ = (', ...
                num2str(gui.results.linear_fit(1)), ')$h$ + (', ...
                num2str(gui.results.linear_fit(2)), ')', ...
                '/ $R^2 =$ ', num2str(gui.results.rSquare));
        elseif gui.variables.val2 == 3
            gui.axis.title_str = strcat('S = (', ...
                num2str(gui.results.linear_fit(1)), ')$h^2$ + (', ...
                num2str(gui.results.linear_fit(2)), ')$h$ + (', ...
                num2str(gui.results.linear_fit(3)), ')', ...
                '/ $R^2 =$ ', num2str(gui.results.rSquare));
        end
    elseif gui.variables.y_axis == 3
        gui.axis.y2plot = gui.results.LS2;
        gui.axis.delta_y2plot = gui.results.delta_LS2;
        gui.axis.y2plot_2 = gui.results.LS2_fit;
        gui.axis.ylabelstr = 'Load over Stiffness squared ($L/S^2$) (1/GPa)';
        gui.axis.ymax = max(gui.axis.y2plot);
        if gui.variables.val2 == 2
            gui.axis.title_str = strcat('$L/S^2$ = (', ...
                num2str(gui.results.linear_fit(1)), ')$h$ + (', ...
                num2str(gui.results.linear_fit(2)), ')', ...
                '/ $R^2 =$ ', num2str(gui.results.rSquare));
        end
    elseif gui.variables.y_axis == 4 || gui.variables.y_axis == 7
        gui.axis.y2plot = gui.results.Esample_red;
        gui.axis.delta_y2plot = gui.results.delta_E;
        gui.axis.y2plot_2 = gui.results.Em_red;
        gui.axis.ylabelstr = 'Reduced Young''s modulus ($E^*$) (GPa)';
        cleaned_Esample_red = gui.results.Esample_red;
        cleaned_Esample_red(isinf(cleaned_Esample_red)) = [];
        cleaned_Esample_red(isnan(cleaned_Esample_red)) = [];
        cleaned_Esample_red(cleaned_Esample_red < 0) = [];
        gui.results.cleaned_Esample_red = cleaned_Esample_red;
        if round(cleaned_Esample_red) == 0
            gui.axis.ymax = round(2*mean(10*cleaned_Esample_red))/10;
        else
            gui.axis.ymax = round(2*mean(cleaned_Esample_red));
        end
    elseif gui.variables.y_axis == 5
        gui.axis.y2plot = gui.results.Esample_red;
        gui.axis.delta_y2plot = gui.results.delta_E;
        gui.axis.y2plot_2 = gui.results.Ef_red;
        gui.axis.ylabelstr = ['Reduced Young''s modulus ($E^*$) (GPa)'];
        cleaned_Esample_red = gui.results.Esample_red;
        cleaned_Esample_red(isinf(cleaned_Esample_red)) = [];
        cleaned_Esample_red(isnan(cleaned_Esample_red)) = [];
        cleaned_Esample_red(cleaned_Esample_red < 0) = [];
        if round(cleaned_Esample_red) == 0
            gui.axis.ymax = round(2*mean(10*cleaned_Esample_red))/10;
        else
            gui.axis.ymax = round(2*mean(cleaned_Esample_red));
        end
        gui.results.cleaned_Esample_red = cleaned_Esample_red;
    elseif gui.variables.y_axis == 6
        gui.axis.y2plot = gui.results.H;
        gui.axis.delta_y2plot = gui.results.delta_H;
        gui.axis.y2plot_2 = gui.results.Hf;
        gui.axis.ylabelstr = 'Hardness ($H$) (GPa)';
        cleaned_H = gui.results.H;
        cleaned_H(isinf(cleaned_H)) = [];
        cleaned_H(isnan(cleaned_H)) = [];
        cleaned_H(cleaned_H < 0) = [];
        if round(cleaned_H) == 0
            gui.axis.ymax = round(2*mean(10*cleaned_H))/10;
        else
            gui.axis.ymax = round(2*mean(cleaned_H));
        end
        gui.results.cleaned_H = cleaned_H;
    elseif gui.variables.y_axis == 8
        gui.axis.y2plot = gui.results.H;
        gui.axis.delta_y2plot = gui.results.delta_H;
        gui.axis.y2plot_2 = gui.results.Hf;
        gui.axis.ylabelstr = 'Hardness ($H$) (GPa)';
        cleaned_H = gui.results.H;
        cleaned_H(isinf(cleaned_H)) = [];
        cleaned_H(isnan(cleaned_H)) = [];
        cleaned_H(cleaned_H < 0) = [];
        if round(cleaned_H) == 0
            gui.axis.ymax = round(2*mean(10*cleaned_H))/10;
        else
            gui.axis.ymax = round(2*mean(cleaned_H));
        end
        gui.results.cleaned_H = cleaned_H;
    end
end

guidata(gcf, gui);

end