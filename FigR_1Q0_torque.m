%% Initialize Workspace and Parameters
clc; clear; close all;

% Set up directories and add paths
current_dirname = fileparts(matlab.desktop.editor.getActiveFilename);

cd(current_dirname)
pitch = 0.05;

% SiO2
% spname = 'torque_summary_20250808_best_bingood_SiO2_dx_31_M0_4849_z0_40_step_1e-02_tm_5e-02_tr_3e-02';
% Si
spname = 'torque_summary_20250315_best_Si_dx_31_M0_4189_z0_35_bool_1110_step_1e-02_tm_5e-01_tr_3e-03_te_1e-02_smth_1_pbta_20_gam_105_cyl_fixz.mat';
if contains(spname, 'Si_')
    load(fullfile(current_dirname, 'Si_cylinder', spname(8:end)))
    load(fullfile(current_dirname, 'Supplementary_data', spname))
    
elseif contains(spname, 'SiO2_')
    load(fullfile(current_dirname, 'SiO2_cylinder', spname(8:end)))
    load(fullfile(current_dirname, 'Supplementary_data', spname))
end
Torque = Fs_rot_opt(3,3)* 1e12;
%%

m_g = 28.97 *1e-3 / (6.02214076*1e23); % air molecule mass
p_g = 400; % 4 mbar -> 400 Pa

T = 298;
k_b = 1.380649 * 1e-23;
% SiO2
l = max(sum(RI_f,1),[],'all')*pitch * 1e-6;
D = sqrt(sum(RI_f(floor(end/2),:,:),'all') / pi)*2*pitch*1e-6;
M = prms_raw.prms.mass;
Gamma_damp = l * D * p_g * sqrt(2*pi*m_g) * (6 + pi) / (8 * M * sqrt(k_b*T));
Iz= prms_raw.prms.I_principal(3);

Omega_est = Torque / (Iz * Gamma_damp) / (2*pi)



% depth_list = [];
j1_want = 1;
% 
% SiO2: 4,9,12 ->4,9,12
% Si: 1,3,5 -> 2, 4, 5
j1 = j1_want;
pitch = 0.05;
wavelength = 1.55;
NA = 0.8;

X = 21; Y = 21;
    RI_f_cut = squeeze(sum(RI_f,1))';
    RI_f_cut = ...
        RI_f_cut(floor(end/2)+1-X:floor(end/2)+1+X,floor(end/2)+1-Y:floor(end/2)+1+Y);

    subplot(221),imagesc(RI_f(floor(end/2)+1-X:floor(end/2)+1+X,floor(end/2)+1-Y:floor(end/2)+1+Y,floor(end/2)+1)), axis image off, colormap gray, colorbar
    subplot(223),imagesc(RI_f_cut), axis image off, colormap gray, colorbar

    RI_f = RI_f(floor(end/2)+1-X:floor(end/2)+1+X,floor(end/2)+1-X:floor(end/2)+1+X,floor(end/2)+1-X:floor(end/2)+1+X);
