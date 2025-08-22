%% Initialize Workspace and Parameters
clc; clear; close all;

% Set up directories and add paths
current_dirname = fileparts(matlab.desktop.editor.getActiveFilename);

cd(current_dirname)
pitch = 0.05;
%%
% spname = 'Si_cylinder';
spname = 'SiO2_cylinder';
if strcmp(spname, 'Si_cylinder')
    mie_data = load(fullfile(current_dirname, 'mie_diameter_plots', 'Si_cbs_mie_rayleigh.mat'));
    xrange0 = [0.8 1.3];
elseif strcmp(spname, 'SiO2_cylinder')
    mie_data = load(fullfile(current_dirname, 'mie_diameter_plots', 'SiO2_cbs_mie_rayleigh.mat'));
    xrange0 = [0.4 1.6];
end

% Scan enhancement factors (freq & eta)
dim_list = [2,1,3];


datadir_cylinder = dir(fullfile(current_dirname, 'SiO2_cylinder', 'summary*.mat'));

freqs_list = zeros(3, length(datadir_cylinder));
etas_list = zeros(3, length(datadir_cylinder));
freqs_rot_list = zeros(3, length(datadir_cylinder));
etas_rot_list = zeros(3, length(datadir_cylinder));
radius_list = zeros(1, length(datadir_cylinder));
depth_list = zeros(1, length(datadir_cylinder));
freqs_mie = zeros(3, length(datadir_cylinder));
etas_mie = zeros(3, length(datadir_cylinder));
spnames = cell(1, length(datadir_cylinder));
gammas_list = zeros(3, length(datadir_cylinder));
gammas_rot_list = zeros(3, length(datadir_cylinder));

SE = strel('cube',2);
for j1 =1:length(datadir_cylinder)
    spnames{j1} = datadir_cylinder(j1).name;
    data_opt = load(fullfile(datadir_cylinder(j1).folder,datadir_cylinder(j1).name));
    freqs_list(:,j1) = real(data_opt.Freqs_opt(1:3));
    etas_list(:,j1) = data_opt.Etas_opt(1:3);
    freqs_rot_list(:,j1) = real(data_opt.Freqs_rot_opt(1:3));
    etas_rot_list(:,j1) = data_opt.Etas_rot_opt(1:3);
    radius_list(j1) = (sum(data_opt.RI_f,'all')* 3 /4/pi)^(1/3) * 0.05;
    gammas_list(:,j1) = real(data_opt.Gammas_opt(1:3));
    gammas_rot_list(:,j1) = real(data_opt.Gammas_rot_opt(1:3));
    RI_f = data_opt.RI_f;
    z0 = max(sum(RI_f,1),[],'all');
    depth_list(j1) = z0 * 0.05;
end

[radius_list, Idx] = sort(radius_list);
spnames = spnames(Idx);
freqs_list = freqs_list(:, Idx);
etas_list = etas_list(:, Idx);
freqs_rot_list = freqs_rot_list(:, Idx);
etas_rot_list = etas_rot_list(:, Idx);
depth_list = depth_list(Idx);

%% Figure 1c - Draw all plots: Diameter vs Optimized parameters
c =  colormap("sky");
close all
min_depth = 0;
max_depth = max(depth_list);

% 1. Freqs
close all
z00 = 800;
figure('Renderer', 'painters', 'Position', [10 10 300 z00])
y0_list = [50 80 60];
rgb = 'rgb';
for j0 = 1:3
    subplot(3,1,j0), 
    plot(mie_data.radius_list*2, real(mie_data.Gamma_mu_cbs(:,dim_list(j0))),rgb(j0),'LineWidth',1), hold on
    set(gca, 'linewidth',1), hold on

    for j1 = 1:length(radius_list)
        scatter(radius_list(j1)*2, gammas_list(dim_list(j0),j1), 150, 'co', ...
              'MarkerEdgeColor','none',...
                  'MarkerFaceColor',c(1+round((depth_list((j1))-min_depth)/(max_depth-min_depth)*255),:),...
                'LineWidth',1)
    end
    set(gca,'TickLength',[0.02, 0.01])
    xlim(xrange0)
    ylim([0,y0_list(j0)])
end

figure('Renderer', 'painters', 'Position', [310 10 300 z00])
for j0 = 1:3
    subplot(3,1,j0), 
    semilogy(mie_data.radius_list*2, real(mie_data.Omega_mu_cbs(:,dim_list(j0)) ./ mie_data.Gamma_mu_cbs(:,dim_list(j0))),rgb(j0),'LineWidth',1), hold on
    set(gca, 'linewidth',1), hold on

    for j1 = 1:length(radius_list)
        scatter(radius_list(j1)*2, freqs_list(dim_list(j0),j1) ./ gammas_list(dim_list(j0),j1), 150, 'co', ...
              'MarkerEdgeColor','none',...
                  'MarkerFaceColor',c(1+round((depth_list((j1))-min_depth)/(max_depth-min_depth)*255),:),...
                'LineWidth',1)
    end
    set(gca,'TickLength',[0.02, 0.02])
    xlim(xrange0)
    ylim([1,y0_list(j0)])
end


% 3. Freqs rot
figure('Renderer', 'painters', 'Position', [610 10 300 z00])
y0_list = [60 60 40];
rgb = 'rgb';
for j0 = 1:3
    subplot(3,1,j0), 
    set(gca, 'linewidth',1), hold on
    for j1 = 1:length(radius_list)
        scatter(radius_list(j1)*2, gammas_rot_list(dim_list(j0),j1), 150, 'co', ...
              'MarkerEdgeColor','none',...
                  'MarkerFaceColor',c(1+round((depth_list((j1))-min_depth)/(max_depth-min_depth)*255),:),...
                'LineWidth',1)
    end
    xlim(xrange0)
    ylim([0,y0_list(j0)])
end

%
% 4. Eta_rot
figure('Renderer', 'painters', 'Position', [910 10 300 z00])
y0_list = [3000 200 200];
rgb = 'rgb';
for j0 = 1:3
    subplot(3,1,j0), 
    semilogy(mie_data.radius_list*2, real(mie_data.Omega_mu_cbs(:,dim_list(j0)) ./ mie_data.Gamma_mu_cbs(:,dim_list(j0))),rgb(j0),'LineWidth',1), hold on
    set(gca, 'linewidth',1), hold on
    for j1 = 1:length(radius_list)
        scatter(radius_list(j1)*2, freqs_rot_list(dim_list(j0),j1) ./ gammas_rot_list(dim_list(j0),j1), 150, 'o', ...
              'MarkerEdgeColor','none',...
                  'MarkerFaceColor',c(1+round((depth_list((j1))-min_depth)/(max_depth-min_depth)*255),:),...
                'LineWidth',1)
    end
    set(gca,'TickLength',[0.02, 0.02])
    xlim(xrange0)
    ylim([1,y0_list(j0)])
end

