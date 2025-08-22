%% Initialize Workspace and Parameters
clc; clear; close all;

% Set up directories and add paths
current_dirname = fileparts(matlab.desktop.editor.getActiveFilename);

cd(current_dirname)
pitch = 0.05;
%%
sio2_mie_data = load(fullfile(current_dirname, 'mie_diameter_plots', 'SiO2_cbs_mie_rayleigh.mat'));

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

SE = strel('cube',2);
for j1 =1:length(datadir_cylinder)
    spnames{j1} = datadir_cylinder(j1).name;
    data_opt = load(fullfile(datadir_cylinder(j1).folder,datadir_cylinder(j1).name));
    freqs_list(:,j1) = real(data_opt.Freqs_opt(1:3));
    etas_list(:,j1) = data_opt.Etas_opt(1:3);
    freqs_rot_list(:,j1) = real(data_opt.Freqs_rot_opt(1:3));
    etas_rot_list(:,j1) = data_opt.Etas_rot_opt(1:3);
    radius_list(j1) = (sum(data_opt.RI_f,'all')* 3 /4/pi)^(1/3) * 0.05;
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


%% Extended Figs
c =  colormap("sky");
close all
z00 = 225;
min_depth = 0;
max_depth = max(depth_list);

close all
z00 = 800;
figure('Renderer', 'painters', 'Position', [10 10 300 z00])
y0_list = [250 250 500];
rgb = 'rgb';


for j0 = 1:3
    subplot(3,1,j0), 
    plot(sio2_mie_data.radius_list*2, real(sio2_mie_data.Omega_mu_cbs(:,dim_list(j0))),rgb(j0),'LineWidth',1), hold on
    set(gca, 'linewidth',1), hold on
    clc,
    for j1 = 1:length(datadir_cylinder)
        data_opt = load(fullfile(datadir_cylinder(j1).folder,spnames{(j1)}));
        scatter(data_opt.radius_mie_lists(1)*2, data_opt.Freqs_opt(dim_list(j0)), 150, 'co', ...
          'MarkerEdgeColor','none',...
              'MarkerFaceColor',c(1+round((depth_list((j1))-min_depth)/(max_depth-min_depth)*255),:),...
            'LineWidth',1)
        data_opt.Freqs_opt(dim_list(j0)) / data_opt.Freqs_Mie(dim_list(j0))
    end
    set(gca,'TickLength',[0.02, 0.01])
    xlim([0.4 1.6])
    ylim([0,y0_list(j0)])
    set(gca,'XTick',linspace(0,2,3))
    set(gca,'YTick',linspace(0,y0_list(j0),3))
    set(gca,'XTickLabel',[]);
    set(gca,'YTickLabel',[]);

end
%%
figure('Renderer', 'painters', 'Position', [310 10 300 z00])
for j0 = 1:3
    subplot(3,1,j0), 
    plot(sio2_mie_data.radius_list*2, real(sio2_mie_data.Eta_cbs(:,dim_list(j0))),rgb(j0),'LineWidth',1), hold on
    set(gca, 'linewidth',1), hold on
    clc,

    for j1 = 1:length(datadir_cylinder)
        data_opt = load(fullfile(datadir_cylinder(j1).folder,spnames{(j1)}));
        scatter(data_opt.radius_mie_lists(1)*2, data_opt.Etas_opt(dim_list(j0)), 150, 'co', ...
          'MarkerEdgeColor','none',...
              'MarkerFaceColor',c(1+round((depth_list((j1))-min_depth)/(max_depth-min_depth)*255),:),...
            'LineWidth',1)
    end
    set(gca,'TickLength',[0.02, 0.01])
    xlim([0.4 1.6])
    ylim([0,1])
    set(gca,'XTick',linspace(0,2,3))
    set(gca,'YTick',linspace(0,1,3))
    set(gca,'XTickLabel',[]);
    set(gca,'YTickLabel',[]);
end
%%
% Rotation Freq
y0_list = [700 1000 500];
figure('Renderer', 'painters', 'Position', [610 10 300 z00])
for j0 = 1:3
    subplot(3,1,j0), set(gca, 'linewidth',1), hold on
    clc,

    for j1 = 1:length(datadir_cylinder)
        data_opt = load(fullfile(datadir_cylinder(j1).folder,spnames{(j1)}));
        scatter(data_opt.radius_mie_lists*2, data_opt.Freqs_rot_opt(dim_list(j0)), 150, 'co', ...
          'MarkerEdgeColor','none',...
              'MarkerFaceColor',c(1+round((depth_list((j1))-min_depth)/(max_depth-min_depth)*255),:),...
            'LineWidth',1)
        
    end
    set(gca,'TickLength',[0.02, 0.01])
    xlim([0.4 1.6])
    ylim([0,y0_list(j0)])
    set(gca,'XTick',linspace(0,2,3))
    set(gca,'YTick',linspace(0,y0_list(j0),3))
    set(gca,'XTickLabel',[]);
    set(gca,'YTickLabel',[]);
end
%%
figure('Renderer', 'painters', 'Position', [910 10 300 z00])
for j0 = 1:3
    subplot(3,1,j0), 
    clc,
    for j1 = 1:length(datadir_cylinder)
        data_opt = load(fullfile(datadir_cylinder(j1).folder,spnames{(j1)}));
        scatter(data_opt.radius_mie_lists*2, data_opt.Etas_rot_opt(dim_list(j0)), 150, 'co', ...
          'MarkerEdgeColor','none',...
              'MarkerFaceColor',c(1+round((depth_list((j1))-min_depth)/(max_depth-min_depth)*255),:),...
            'LineWidth',1), hold on
    end
    xlim([0.4 1.6])
    ylim([0,1])
    set(gca,'XTick',linspace(0,2,3))
    set(gca,'YTick',linspace(0,1,3))
    set(gca,'XTickLabel',[]);
    set(gca,'YTickLabel',[]);

end

%%
%%
% %{
X = 21; Y = 21;
j1_want = 8;
% SiO2: 2, 9 / 8 (Sup for torque, rot)
% Si: 3, 5, 9
for j1 = j1_want%:sum(bools_good) % 1,3,7
    close all
    spnames{j1}
    load(fullfile(datadir_cylinder(j1).folder,spnames{j1}));

    data_opt = load(fullfile(datadir_cylinder(j1).folder,spnames{j1}));
    RI_f = data_opt.RI_f;
    RI_f = RI_f(floor(end/2)+1-X:floor(end/2)+1+X,floor(end/2)+1-Y:floor(end/2)+1+Y, floor(end/2)+1-X:floor(end/2)+1+X);

    RI_f_cut = squeeze(sum(RI_f,1))';
    RI_f_cut = ...
        RI_f_cut(floor(end/2)+1-X:floor(end/2)+1+X,floor(end/2)+1-Y:floor(end/2)+1+Y);

    subplot(221),imagesc(RI_f(:,:,floor(end/2)+1)), axis image off, colormap gray, colorbar
    subplot(223),imagesc(RI_f_cut), axis image off, colormap gray, colorbar
    
    I_opt_cut = sum(abs(data_opt.E).^2,4);
    I_opt_cut = I_opt_cut(floor(end/2)+1-X:floor(end/2)+1+X,floor(end/2)+1-Y:floor(end/2)+1+Y, floor(end/2)+1-X:floor(end/2)+1+X);
    I_opt_cut = squeeze(I_opt_cut(:,:,floor(end/2)+1));
    Imax = max(round(prctile(I_opt_cut(:),99) / 5) * 5,2.5);
    subplot(222), imagesc(I_opt_cut, [0, Imax]), axis image off, colorbar

    I_opt_cut = sum(abs(data_opt.E).^2,4);
    I_opt_cut = I_opt_cut(floor(end/2)+1-X:floor(end/2)+1+X,floor(end/2)+1-Y:floor(end/2)+1+Y, floor(end/2)+1-X:floor(end/2)+1+X);
    I_opt_cut = squeeze(I_opt_cut(floor(end/2)+1,:, :))';
    I_opt_cut = ...
        I_opt_cut(floor(end/2)+1-X:floor(end/2)+1+X,floor(end/2)+1-Y:floor(end/2)+1+Y);
    Imax = max(round(prctile(I_opt_cut(:),99) / 5) * 5,2.5);
    subplot(224), imagesc(I_opt_cut, [0, Imax]), axis image off, colorbar
    clc,data_opt.Freqs_opt([2,1,3]), data_opt.Freqs_rot_opt([2,1,3]), data_opt.Etas_opt([2,1,3]),  data_opt.Etas_rot_opt([2,1,3])
    sum(data_opt.RI_f,'all') * 0.05^3
end
%}
