%% Initialize Workspace and Parameters
clc; clear; close all;

% Set up directories and add paths
current_dirname = fileparts(matlab.desktop.editor.getActiveFilename);
cd(current_dirname)

data_sio2 = load(fullfile(current_dirname, 'SiO2_cylinder',...
'summary_20250808_best_bingood_SiO2_dx_31_M0_4849_z0_40_step_1e-02_tm_5e-02_tr_3e-02.mat'));

data_sio2_ext_F = load(fullfile(current_dirname, 'Supplementary_data',...
'SiO2_extend_Fs_summary_20250808_best_bingood_SiO2_dx_31_M0_4849_z0_40_step_1e-02_tm_5e-02_tr_3e-02.mat'));
data_si = load(fullfile(current_dirname, 'Si_cylinder',...
    'summary_20250315_best_Si_dx_31_M0_4189_z0_55_bool_1110_step_1e-02_tm_1e-01_tr_3e-03_te_1e-02_smth_1_pbta_50_gam_105_cyl_fixz.mat'));
data_si_ext_F = load(fullfile(current_dirname, 'Supplementary_data',...
    'Si_extend_Fs_summary_20250315_best_Si_dx_31_M0_4189_z0_55_bool_1110_step_1e-02_tm_1e-01_tr_3e-03_te_1e-02_smth_1_pbta_50_gam_105_cyl_fixz.mat'));
%%
kb = 1.380649e-23;
scan_range_ext = (-0.05*45):0.05:(0.05*45);
% xx = linspace(min(data_SiO2.scan_range*1000),max(data_SiO2.scan_range*1000),101);
% axis_lists = [-4.5e-10 4.5e-10; -4.5e-10 4.5e-10;-4.5e-10 4.5e-10];
rgb = 'grb';
close all,
% clc
for j1 = [2 1 3]
    figure('Renderer', 'painters', 'Position', [10 10 300 250])
    plot(scan_range_ext*1000,squeeze(data_sio2_ext_F.Fs_opt(j1,j1,:))*1e18,'color', 'k', 'linewidth',2), hold on
    plot(scan_range_ext*1000,squeeze(data_si_ext_F.Fs_opt(j1,j1,:))*1e18,'color', rgb(j1), 'linewidth',2), hold on

    set(gca,'TickLength',[0.02, 0.01])
    hold on
    if j1 ~= 3
    % xlim([-1500 1500])
    else
    % xlim([-1000 1000])
    end
    ff_si = squeeze(data_si_ext_F.Fs_opt(j1,j1,:))*1e18*1e-12;
    U_si = ff_si(findClosestZeroCross(ff_si)+1:floor(end/2)+1) * 0.05 * 1e-6 / kb;
    (length(U_si)-1)*0.05, sum(U_si)
    ff_sio2 = squeeze(data_sio2_ext_F.Fs_opt(j1,j1,:))*1e18*1e-12;
    U_sio2 = ff_sio2(findClosestZeroCross(ff_sio2)+1:floor(end/2)+1) * 0.05 * 1e-6 / kb;
    (length(U_sio2)-1)*0.05, sum(U_sio2)
    pause
end

%%


for j1 = [2 1 3]
    figure('Renderer', 'painters', 'Position', [10 10 300 250])
    plot(data_sio2.scan_range_rot*180/pi,squeeze(data_sio2.Fs_rot_opt(j1,j1,:))*1e30,'color', 'k', 'linewidth',2), hold on
    plot(data_si.scan_range_rot*180/pi,squeeze(data_si.Fs_rot_opt(j1,j1,:))*1e30,'color', rgb(j1), 'linewidth',2), hold on

    xlim([-90 90])
    hold on
    drad = data_sio2.scan_range_rot(2) -data_sio2.scan_range_rot(1);
    ff_si = squeeze(data_si.Fs_rot_opt(j1,j1,:))*1e30*1e-18;
    U_si = ff_si(findClosestZeroCross(ff_si)+1:floor(end/2)+1) * drad/ kb;
    (length(U_si)-1)*drad*180/pi, sum(U_si)
    ff_sio2 = squeeze(data_sio2.Fs_rot_opt(j1,j1,:))*1e30*1e-18;
    U_sio2 = ff_sio2(findClosestZeroCross(ff_sio2)+1:floor(end/2)+1) * drad / kb;
    (length(U_sio2)-1)*drad*180/pi, sum(U_sio2)
    pause
end

%%
    % X = 18; Y = 18; Z = 24;
    X = 21; Y = 21;
    RI_f = data_sio2.RI_f;
    RI_f = RI_f(floor(end/2)+1-X:floor(end/2)+1+X,floor(end/2)+1-Y:floor(end/2)+1+Y, floor(end/2)+1-X:floor(end/2)+1+X);

    RI_f_cut = squeeze(sum(RI_f,1))';
    RI_f_cut = ...
        RI_f_cut(floor(end/2)+1-X:floor(end/2)+1+X,floor(end/2)+1-Y:floor(end/2)+1+Y);

    subplot(221),imagesc(RI_f(:,:,floor(end/2)+1)), axis image off, colormap gray, colorbar
    subplot(223),imagesc(RI_f_cut), axis image off, colormap gray, colorbar
    clc,data_sio2.Freqs_opt([2,1,3]), data_sio2.Freqs_rot_opt([2,1,3]), data_sio2.Etas_opt([2,1,3]),  data_sio2.Etas_rot_opt([2,1,3])
max(sum(data_si.RI_f,1),[],'all') * 0.05

function closest_idx = findClosestZeroCross(X)
    % X : (2N+1) x 1 벡터
    N = (length(X)-1)/2;

    % 1:N 구간에서 음수 -> 양수로 바뀌는 인덱스 찾기
    idx_candidates = find(X(1:N) < 0 & X(2:N+1) > 0);

    % N+1과 가장 가까운 인덱스 선택
    if isempty(idx_candidates)
        closest_idx = 1; % 후보가 없으면 1 반환
    else
        [~, min_idx] = min(abs(idx_candidates - (N+1)));
        closest_idx = idx_candidates(min_idx);
    end
end