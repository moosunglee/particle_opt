%% Initialize Workspace and Parameters
%% Initialize Workspace and Parameters
clc; clear; close all;

% Set up directories and add paths
current_dirname = fileparts(matlab.desktop.editor.getActiveFilename);

cd(current_dirname)
pitch = 0.05;

dim_list = [2,1,3];
%%



% Select material:
% spname = 'SiO2_cylinder';
spname = 'Si_cylinder';

% Used figures in Fig. 03:
folderdir = fullfile(current_dirname, spname);
cd(folderdir)

datadir = dir(fullfile(folderdir,'summary*.mat'));
spnames = cell(1, length(datadir));
for j1 =1:length(datadir)
    spnames{j1} = datadir(j1).name;
end
%% Generate cylinder of same volume with same height
%%
% %{
X = 21; Y = 21;
j1_want = 5;
% 
% SiO2: 4,9,12 ->4,9,12
% Si: 1,3,5 -> 2, 4, 5
j1 = j1_want;
pitch = 0.05;
wavelength = 1.55;
NA = 0.8;
%%
for j1 = j1_want%:sum(bools_good) % 1,3,7
    
    close all
    load(fullfile(datadir(j1).folder,spnames{j1}));

    data_opt = load(fullfile(datadir(j1).folder,spnames{j1}));
    RI_f = data_opt.RI_f;

    RI_f_cut = squeeze(sum(RI_f,1))';
    RI_f_cut = ...
        RI_f_cut(floor(end/2)+1-X:floor(end/2)+1+X,floor(end/2)+1-Y:floor(end/2)+1+Y);

    subplot(221),imagesc(RI_f(floor(end/2)+1-X:floor(end/2)+1+X,floor(end/2)+1-Y:floor(end/2)+1+Y,floor(end/2)+1)), axis image off, colormap gray, colorbar
    subplot(223),imagesc(RI_f_cut), axis image off, colormap gray, colorbar
    
    I_opt_cut = sum(abs(data_opt.E).^2,4);
    I_opt_cut = squeeze(I_opt_cut(floor(end/2)+1-X:floor(end/2)+1+X,floor(end/2)+1-Y:floor(end/2)+1+Y,floor(end/2)+1));
    Imax = max(round(prctile(I_opt_cut(:),99) / 5) * 5,2.5);
    subplot(222), imagesc(I_opt_cut, [0, Imax]), axis image off, colorbar

    I_opt_cut = sum(abs(data_opt.E).^2,4);
    I_opt_cut = squeeze(I_opt_cut(floor(end/2)+1,:, :))';
    I_opt_cut = ...
        I_opt_cut(floor(end/2)+1-X:floor(end/2)+1+X,floor(end/2)+1-Y:floor(end/2)+1+Y);
    Imax = max(round(prctile(I_opt_cut(:),99) / 5) * 5,2.5);
    subplot(224), imagesc(I_opt_cut, [0, Imax]), axis image off, colorbar
%%
    % Generate Cylinder of the same height & circular base
    num_pix_height = max(sum(RI_f,1), [], 'all');
    base_area = sum(sum(RI_f,1) > 2, 'all');
    base_radius = sqrt(base_area/pi);

%

     load(fullfile(datadir(j1).folder,['cyl_' spnames{j1}]))
     

     figure,
        RI_f_cut = squeeze(sum(RI_cylinder(floor(end/2)+1-X:floor(end/2)+1+X,floor(end/2)+1-Y:floor(end/2)+1+Y,floor(end/2)+1-Y:floor(end/2)+1+Y),1))';
        RI_f_cut = ...
            RI_f_cut(floor(end/2)+1-X:floor(end/2)+1+X,floor(end/2)+1-Y:floor(end/2)+1+Y);
    
        subplot(221),imagesc(RI_cylinder(floor(end/2)+1-X:floor(end/2)+1+X,floor(end/2)+1-Y:floor(end/2)+1+Y,floor(end/2)+1)), axis image off, colormap gray, colorbar
        subplot(223),imagesc(RI_f_cut), axis image off, colormap gray, colorbar

        I_opt_cut = sum(abs(E_cyl).^2,4);
        I_opt_cut = squeeze(I_opt_cut(floor(end/2)+1-X:floor(end/2)+1+X,floor(end/2)+1-Y:floor(end/2)+1+Y,floor(end/2)+1));
        Imax = max(round(prctile(I_opt_cut(:),99) / 5) * 5,2.5);
        subplot(222), imagesc(I_opt_cut, [0, Imax]), axis image off, colorbar
    
        I_opt_cut = sum(abs(E_cyl).^2,4);
        I_opt_cut = squeeze(I_opt_cut(floor(end/2)+1,floor(end/2)+1-X:floor(end/2)+1+X,floor(end/2)+1-Y:floor(end/2)+1+Y))';
        I_opt_cut = ...
            I_opt_cut(floor(end/2)+1-X:floor(end/2)+1+X,floor(end/2)+1-Y:floor(end/2)+1+Y);
        Imax = max(round(prctile(I_opt_cut(:),99) / 5) * 5,2.5);
        subplot(224), imagesc(I_opt_cut, [0, Imax]), axis image off, colorbar
        clc,Freqs_opt([2,1,3]), Freqs_rot_opt([2,1,3]), Etas_opt([2,1,3]),  Etas_rot_opt([2,1,3])
        Freqs_cyl([2,1,3]), Freqs_rot_cyl([2,1,3]), Etas_cyl([2,1,3]), Etas_rot_cyl([2,1,3])
        num_pix_height*0.05, base_area*0.05^2, sum(RI_f(:))* 0.05^3
end
%}