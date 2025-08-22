%% Initialize Workspace and Parameters
clc; clear; close all;

% Set up directories and add paths
current_dirname = fileparts(matlab.desktop.editor.getActiveFilename);
cd(current_dirname)
%%
sio2_mie_data = load(fullfile(current_dirname, 'mie_diameter_plots', 'SiO2_cbs_mie_rayleigh.mat'));
dir_3D = fullfile(current_dirname, 'SiO2_3D');
cd(dir_3D)
%% Scan enhancement factors (freq & eta)
dim_list = [2,1,3];
datadir = dir(fullfile(dir_3D,'summary*.mat'));
cd(current_dirname)
%% Plot parameters(Diameter)
pitch = 0.05;
% %{
close all
z00 = 800;
figure('Renderer', 'painters', 'Position', [10 10 300 z00])
y0_list = [300 250 500];
rgb = 'rgb';
for j0 = 1:3
    subplot(3,1,j0), 
    plot(sio2_mie_data.radius_list*2, real(sio2_mie_data.Omega_mu_cbs(:,dim_list(j0))),rgb(j0),'LineWidth',1), hold on
    set(gca, 'linewidth',1), hold on
    for j1 = 1:length(datadir)
        data_opt = load(fullfile(datadir(j1).folder,datadir(j1).name));
        scatter(data_opt.radius_mie_lists(1)*2, data_opt.Freqs_1110(dim_list(j0)), 150, 'cs','LineWidth',1)
        scatter(data_opt.radius_mie_lists(2)*2, data_opt.Freqs_1111(dim_list(j0)), 150, 'm^','LineWidth',1)
        if j0 == 3
            data_opt.Freqs_1110(dim_list(j0)) / data_opt.Freqs_Mie(dim_list(j0))
        end
    end
    set(gca,'TickLength',[0.02, 0.01])
    xlim([0.4 1.6])
    ylim([0,y0_list(j0)])
    set(gca,'XTickLabel',[]);
    set(gca,'YTickLabel',[]);
    set(gca,'XTick',[])
    set(gca,'YTick',[])
end
%%
figure('Renderer', 'painters', 'Position', [310 10 300 z00])
for j0 = 1:3
    subplot(3,1,j0), 
    plot(sio2_mie_data.radius_list*2,...
        real(sio2_mie_data.Eta_cbs(:,dim_list(j0)))*100,rgb(j0),'LineWidth',1), hold on
    set(gca, 'linewidth',1), hold on
    for j1 = 1:length(datadir)
        data_opt = load(fullfile(datadir(j1).folder,datadir(j1).name));
        scatter(data_opt.radius_mie_lists(1)*2, data_opt.Etas_1110(dim_list(j0))*100, 150, 'cs','LineWidth',1)
        scatter(data_opt.radius_mie_lists(2)*2, data_opt.Etas_1111(dim_list(j0))*100, 150, 'm^','LineWidth',1)
        % if j0 == 3
            data_opt.Etas_1110(dim_list(j0)) / data_opt.Etas_Mie(dim_list(j0))
        % end
    end
    set(gca,'TickLength',[0.02, 0.01])
    xlim([0.4 1.6])
    ylim([0,100])
    set(gca,'XTickLabel',[]);
    set(gca,'YTickLabel',[]);
    set(gca,'XTick',[])
    set(gca,'YTick',[])
end
%%
% Rotation Freq
y0_list = [600 800 600];
figure('Renderer', 'painters', 'Position', [610 10 300 z00])
for j0 = 1:3
    subplot(3,1,j0), set(gca, 'linewidth',1), hold on
    for j1 = 1:length(datadir)
        data_opt = load(fullfile(datadir(j1).folder,datadir(j1).name));
        scatter(data_opt.radius_mie_lists(1)*2, data_opt.Freqs_rot_1110(dim_list(j0)), 150, 'cs','LineWidth',1)
        scatter(data_opt.radius_mie_lists(2)*2, data_opt.Freqs_rot_1111(dim_list(j0)), 150, 'm^','LineWidth',1)
    end
    set(gca,'TickLength',[0.02, 0.01])
    xlim([0.4 1.6])
    ylim([0,y0_list(j0)])
    set(gca,'XTickLabel',[]);
    set(gca,'YTickLabel',[]);
    set(gca,'XTick',[])
    set(gca,'YTick',[])
end

figure('Renderer', 'painters', 'Position', [910 10 300 z00])
for j0 = 1:3
    subplot(3,1,j0), set(gca, 'linewidth',1), hold on
    for j1 = 1:length(datadir)
        data_opt = load(fullfile(datadir(j1).folder,datadir(j1).name));
        scatter(data_opt.radius_mie_lists(1)*2, data_opt.Etas_rot_1110(dim_list(j0))*100, 150, 'cs','LineWidth',1)
        scatter(data_opt.radius_mie_lists(2)*2, data_opt.Etas_rot_1111(dim_list(j0))*100, 150, 'm^','LineWidth',1)
    end
    set(gca,'TickLength',[0.02, 0.01])
    xlim([0.4 1.6])
    ylim([0,100])
    set(gca,'XTickLabel',[]);
    set(gca,'YTickLabel',[]);
    set(gca,'XTick',[])
    set(gca,'YTick',[])
end
