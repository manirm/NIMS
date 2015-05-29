%% Copyright 2014 MERCIER David
function handles = set_GUI
%% Definition of the GUI and buttons
g = guidata(gcf);

%% Title of the GUI
handles.title_GUI_1 = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'text',...
    'Position', [0.31 0.96 0.6 0.04],...
    'String', ['Extraction of mechanical properties of thin film(s) ',...
    'on substrate by conical nanoindentation.'],...
    'FontWeight', 'bold',...
    'FontSize', 12,...
    'HorizontalAlignment', 'center',...
    'ForegroundColor', 'red');

handles.title_GUI_2 = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'text',...
    'Position', [0.31 0.93 0.6 0.03],...
    'String', strcat('Version_', ...
    g.config.version_toolbox, ' - Copyright 2014 MERCIER David'),...
    'FontWeight', 'bold',...
    'FontSize', 10,...
    'HorizontalAlignment', 'center',...
    'ForegroundColor', 'red');

%% Date / Time
handles.date_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'text',...
    'String', datestr(datenum(clock),'mmm.dd,yyyy HH:MM'),...
    'Position', [0.92 0.975 0.075 0.02]);

%% Buttons to browse in files
handles.opendata_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'pushbutton',...
    'Position', [0.018 0.93 0.06 0.05],...
    'String', 'Select file',...
    'FontSize', 10,...
    'FontWeight','bold',...
    'BackgroundColor', [0.745 0.745 0.745],...
    'Callback', 'openfile');

handles.opendata_str_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'edit',...
    'Position', [0.079 0.93 0.198 0.05],...
    'String', g.config.data.data_path,...
    'FontSize', 8,...
    'BackgroundColor', [0.9 0.9 0.9],...
    'HorizontalAlignment', 'left');

%% Units
% Unit definition for the load
handles.title_unitLoad_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'text',...
    'Position', [0.018 0.90 0.025 0.02],...
    'String', 'Load :',...
    'HorizontalAlignment', 'left');

handles.unitLoad_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'popupmenu',...
    'Position', [0.043 0.90 0.04 0.02],...
    'String', {'nN';'uN';'mN'},...
    'Value', 3,...
    'Callback', 'get_and_plot');

% Unit definition for the displacement
handles.title_unitDisp_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'text',...
    'Position', [0.093 0.90 0.055 0.02],...
    'String', 'Displacement :',...
    'HorizontalAlignment', 'left');

handles.unitDisp_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'popupmenu',...
    'Position', [0.148 0.90 0.04 0.02],...
    'String', {'nm';'um';'mm'},...
    'Value', 1,...
    'Callback', 'get_and_plot');

% Unit definition for the stiffness
handles.title_unitStif_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'text',...
    'Position', [0.198 0.90 0.04 0.02],...
    'String', 'Stiffness :',...
    'HorizontalAlignment', 'left');

handles.unitStif_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'popupmenu',...
    'Position', [0.238 0.90 0.04 0.02],...
    'String', {'N/m';'mN/um';'mN/nm'},...
    'Value', 1,...
    'Callback', 'get_and_plot');

%% Choice of the indenter (only conical indenters...)
handles.title_indentertype_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'text',...
    'Position', [0.02 0.86 0.1 0.02],...
    'String', 'Type of indenter',...
    'HorizontalAlignment', 'left');

for ii = 1:1:length(g.config.indenter.Indenter_IDs)
    if strcmp(g.config.indenter.Indenter_ID, g.config.indenter.Indenter_IDs(ii)) == 1
        ind_Indenter = ii;
    end
end

handles.value_indentertype_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'popupmenu',...
    'Position', [0.02 0.84 0.1 0.02],...
    'String', g.config.indenter.Indenter_IDs,...
    'Value', ind_Indenter,...
    'Callback', 'refresh_indenters_GUI');

% Indenter tip - Creation of button group
handles.bg_indenter_tip_GUI = uibuttongroup('Parent', gcf,...
    'Position', [0.02 0.73 0.255 0.1]);

%% Choice of the material indenter
handles.title_indentermaterial_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'text',...
    'Position', [0.14 0.86 0.1 0.02],...
    'String', 'Material of indenter',...
    'HorizontalAlignment', 'left');

handles.value_indentermaterial_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'popupmenu',...
    'Position', [0.14 0.84 0.1 0.02],...
    'String', g.config.indenter.Indenter_materials,...
    'Value', 1,...
    'Callback', 'refresh_indenters_GUI');

set(handles.value_indentermaterial_GUI, 'value', ...
    find(cell2mat(strfind(g.config.indenter.Indenter_materials, ...
    g.config.indenter.Indenter_material))));

%% Number of thin films
handles.title_numthinfilm_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'text',...
    'Position', [0.02 0.7 0.1 0.02],...
    'String', 'Number of thin films',...
    'HorizontalAlignment', 'left');

handles.value_numthinfilm_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'popup',...
    'Position', [0.02 0.68 0.1 0.02],...
    'String', '0|1|2|3',...
    'Value', 4,...
    'Callback', 'refresh_indenters_GUI');

%% Convention
handles.plot_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'pushbutton',...
    'Position', [0.122 0.675 0.153 0.045],...
    'String', 'Convention',...
    'FontSize', 12,...
    'BackgroundColor', [0.745 0.745 0.745],...
    'Callback', 'figure; imshow(''convention_multilayer.png'');');

%% Properties of each layers (thickness, Young's modulus, Poisson's ratio)
handles.bg_film2_properties_GUI = uibuttongroup(...
    'Parent', gcf, ...
    'Position', [0.02 0.6325 0.255 0.0375]);
handles.bg_film1_properties_GUI = uibuttongroup(...
    'Parent', gcf, ...
    'Position', [0.02 0.5950 0.255 0.0375]);
handles.bg_film0_properties_GUI = uibuttongroup(...
    'Parent', gcf, ...
    'Position', [0.02 0.5575 0.255 0.0375]);
handles.bg_substrat_properties_GUI = uibuttongroup(...
    'Parent', gcf, ...
    'Position', [0.02 0.5000 0.255 0.0575]);

%% Definition of the minimum/maximum depth
handles.title_mindepth_prop_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'text',...
    'Position', [0.02 0.465 0.07 0.02],...
    'String', 'Minimum depth :',...
    'HorizontalAlignment', 'left');

handles.value_mindepth_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'edit',...
    'Position', [0.08 0.465 0.03 0.02],...
    'String', '',...
    'Callback', 'get_and_plot');

handles.unit_mindepth_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'text',...
    'Position', [0.11 0.465 0.02 0.02],...
    'String', 'nm',...
    'HorizontalAlignment', 'center');

handles.title_maxdepth_prop_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'text',...
    'Position', [0.02 0.445 0.07 0.02],...
    'String', 'Maximum depth :',...
    'HorizontalAlignment', 'left');

handles.value_maxdepth_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'edit',...
    'Position', [0.08 0.445 0.03 0.02],...
    'String', '',...
    'Callback', 'get_and_plot');

handles.unit_maxdepth_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'text',...
    'Position', [0.11 0.445 0.02 0.02],...
    'String', 'nm',...
    'HorizontalAlignment', 'center');

%% Frame compliance correction
handles.title_frame_compliance_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'text',...
    'Position', [0.14 0.465 0.07 0.02],...
    'String', 'Frame compliance :',...
    'HorizontalAlignment', 'left');

handles.value_frame_compliance_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'edit',...
    'Position', [0.21 0.465 0.03 0.02],...
    'String', '0',...
    'Callback', 'get_and_plot');

handles.unit_frame_compliance_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'text',...
    'Position', [0.24 0.465 0.03 0.02],...
    'String', 'um/mN',...
    'HorizontalAlignment', 'center');

%% CSM corrections
handles.cb_CSM_corr_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'checkbox',...
    'Position', [0.02 0.415 0.2 0.02],...
    'String', 'CSM correction (only valide for Berkovich indenters)',...
    'Value', 0,...
    'Callback', 'get_and_plot');

%% Choice of the model for contact displacement calculation
handles.title_modeldisp_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'text',...
    'Position', [0.02 0.38 0.1 0.02],...
    'String', 'Model for contact displacement',...
    'HorizontalAlignment', 'left');

handles.value_modeldisp_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'popup',...
    'Position', [0.02 0.36 0.1 0.02],...
    'String', 'Doerner&Nix|Oliver&Pharr|Loubet',...
    'Value', 2,...
    'Callback', 'get_and_plot');

%% Correction parameters
handles.title_corr_King_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'text',...
    'Position', [0.13 0.38 0.1 0.02],...
    'String', 'Correction to apply',...
    'HorizontalAlignment', 'left');

handles.popup_corr_King_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'popup',...
    'Position', [0.13 0.36 0.1 0.02],...
    'String', 'beta King1987|beta Hay1999',...
    'Value', 1,...
    'Callback', 'get_and_plot');

handles.cb_corr_thickness_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'checkbox',...
    'Position', [0.13 0.31 0.1 0.02],...
    'String', 't_eff Mencik1997',...
    'Value', 1,...
    'Visible', 'off',...
    'Callback', 'get_and_plot');

%% Choice of the model to fit load-displacement curves
handles.title_model_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'text',...
    'Position', [0.02 0.33 0.1 0.02],...
    'HorizontalAlignment', 'left');

handles.value_model_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'popup',...
    'Position', [0.02 0.31 0.1 0.02],...
    'Value', 1,...
    'Callback', 'get_and_plot');

%% LoadDisp / Bilayer / Multilayer model
handles.title_load_disp_model = 'Load-Disp. Model';

handles.list_load_disp_model = {'No_load_Disp_model',...
    'Loubet', ...
    'Hainsworth'};

set(handles.title_model_GUI, 'String', handles.title_load_disp_model);
set(handles.value_model_GUI, 'String', handles.list_load_disp_model);

handles.title_bilayermodel = 'Bilayer Model (Y''s M calc.)';

handles.list_bilayermodel = {'No_Bilayer_Model', ...
    'Doerner&Nix_King',...
    'Chen_etal.',...
    'Gao_etal.',...
    'Bec_etal.',...
    'Hay_etal.',...
    'Jung_etal.',...
    'Perriot_etal.',...
    'Mencik_etal._linear',...
    'Mencik_etal._exponential',...
    'Mencik_etal._reciprocal_exp.'};

handles.title_multilayermodel = 'Multilayer Model (Y''s M calc.)';

handles.list_multilayermodel = {'No_Multilayer_Model', ...
    'Mercier_etal.'};

%% Parameter to plot
handles.title_param2plotinxaxis_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'text',...
    'Position', [0.02 0.26 0.1 0.02],...
    'String', 'Parameter to plot ==> x axis',...
    'HorizontalAlignment', 'left');

handles.value_param2plotinxaxis_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'popup',...
    'Position', [0.02 0.24 0.1 0.02],...
    'String', 'Displ.|Cont.rad./Thick.|Displ./Thick.',...
    'Value', 1,...
    'Callback', 'get_and_plot');

handles.title_param2plotinyaxis_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'text',...
    'Position', [0.13 0.26 0.1 0.02],...
    'String', 'Parameter to plot ==> y axis',...
    'HorizontalAlignment', 'left');

handles.value_param2plotinyaxis_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'popup',...
    'Position', [0.13 0.24 0.1 0.02],...
    'String', {'Load', ...
    'Stiffness', ...
    'Load oved Stiffness squared', ...
    'Red. Young''s modulus(film+sub)', ...
    'Red. Young''s modulus(film)', ...
    'Hardness'},...
    'Value', 1,...
    'Callback', 'get_and_plot');

%% Options of the plot
handles.cb_log_plot_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'checkbox',...
    'Position', [0.02 0.19 0.05 0.03],...
    'String', 'Log',...
    'Value', 0,...
    'Callback', 'get_and_plot');

handles.cb_grid_plot_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'checkbox',...
    'Position', [0.07 0.19 0.05 0.03],...
    'String', 'Grid',...
    'Value', 1,...
    'Callback', 'get_and_plot');

handles.pb_residual_plot_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'pushbutton',...
    'Position', [0.13 0.19 0.1 0.03],...
    'String', 'Residuals',...
    'Visible', 'off',...
    'Value', 0,...
    'Callback', 'plot_selection(2)');

%% Plot configuration
handles.AxisPlot_GUI = axes('Parent', gcf,...
    'Position', [0.33 0.1 0.65 0.75]);

set(gcf,'CurrentAxes', handles.AxisPlot_GUI);

%% Get values from plot
handles.cb_get_values_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'pushbutton',...
    'Position', [0.02 0.15 0.1 0.03],...
    'String', 'Get x and y values',...
    'Callback', 'plot_get_values');

handles.title_x_values_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'text',...
    'Position', [0.02 0.13 0.03 0.02],...
    'String', 'X value :',...
    'HorizontalAlignment', 'left');

handles.value_x_values_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'edit',...
    'Position', [0.05 0.13 0.03 0.02],...
    'String', '');

handles.title_y_values_prop_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'text',...
    'Position', [0.02 0.11 0.03 0.02],...
    'String', 'Y value :',...
    'HorizontalAlignment', 'left');

handles.value_y_values_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'edit',...
    'Position', [0.05 0.11 0.03 0.02],...
    'String', '');

%% Others buttons
% Python for FEM (Abaqus)
handles.python4fem = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'pushbutton',...
    'Position', [0.13 0.12 0.1 0.05],...
    'String', 'FEM',...
    'Callback', 'python4abaqus');

% Save
handles.save_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'pushbutton',...
    'Position', [0.13 0.05 0.1 0.05],...
    'String', 'SAVE',...
    'Callback', 'export_data_to_YAML_file');

% Quit
handles.quit_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'pushbutton',...
    'Position', [0.02 0.05 0.1 0.05],...
    'String', 'QUIT',...
    'Callback', 'close(gcf);clear all');

set([handles.python4fem, handles.save_GUI, handles.quit_GUI],...
    'FontSize', 12,...
    'BackgroundColor', [0.745 0.745 0.745]);

end