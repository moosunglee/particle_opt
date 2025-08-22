%% Initialize Workspace and Parameters
clc; clear; close all;

% Set up directories and add paths
current_dirname = fileparts(matlab.desktop.editor.getActiveFilename);

cd(current_dirname)
pitch = 0.05;
%%

datadir = dir(fullfile(current_dirname, 'Supplementary_data', 'localeq*.mat'));
spnames = cell(1, length(datadir));
for j1 =1:length(datadir)
    spnames{j1} = datadir(j1).name;
end
X = 21; Y = 21;
j1_want = 1;
j0 = j1_want;
pitch = 0.05;
wavelength = 1.55;
NA = 0.8;

    close all
    load(fullfile(datadir(j0).folder,spnames{j0}));

    figure,
pitch = 0.05;
wavelength = 1.55;
NA = 0.8;
    data_opt = load(fullfile(datadir(j0).folder,spnames{j0}));
    RI_f = RI_f(floor(end/2)+1-X:floor(end/2)+1+X,floor(end/2)+1-Y:floor(end/2)+1+Y, floor(end/2)+1-X:floor(end/2)+1+X);

    RI_f_cut = squeeze(sum(RI_f,1))';
    RI_f_cut = ...
        RI_f_cut(floor(end/2)+1-X:floor(end/2)+1+X,floor(end/2)+1-Y:floor(end/2)+1+Y);

    subplot(221),imagesc(RI_f(:,:,floor(end/2)+1)), axis image off, colormap gray, colorbar
    subplot(223),imagesc(RI_f_cut), axis image off, colormap gray, colorbar
    
    I_opt_cut = sum(abs(data_opt.E).^2,4);
    I_opt_cut = I_opt_cut(floor(end/2)+1-X:floor(end/2)+1+X,floor(end/2)+1-Y:floor(end/2)+1+Y, floor(end/2)+1-X:floor(end/2)+1+X);
    I_opt_cut = squeeze(I_opt_cut(:,:,floor(end/2)+1));
    subplot(222), imagesc(I_opt_cut, [0, 5]), axis image off, colorbar

    I_opt_cut = sum(abs(data_opt.E).^2,4);
    I_opt_cut = I_opt_cut(floor(end/2)+1-X:floor(end/2)+1+X,floor(end/2)+1-Y:floor(end/2)+1+Y, floor(end/2)+1-X:floor(end/2)+1+X);
    I_opt_cut = squeeze(I_opt_cut(floor(end/2)+1,:, :))';
    I_opt_cut = ...
        I_opt_cut(floor(end/2)+1-X:floor(end/2)+1+X,floor(end/2)+1-Y:floor(end/2)+1+Y);
    Imax = max(round(prctile(I_opt_cut(:),99) / 5) * 5,2.5);
    subplot(224), imagesc(I_opt_cut, [0, Imax]), axis image off, colorbar
    sum(data_opt.RI_f,'all') * 0.05^3


for j1 = [2 1 3]

    figure('Renderer', 'painters', 'Position', [10 10 300 250])
    yy = interp1(scan_range*1000,squeeze(Fs_opt(j1,j1,:))*1e18,scan_range*1000,'cubic');
    plot(scan_range*1000,yy,'k'), hold on
    xlim([-500 500])
end
