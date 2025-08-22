%% Initialize Workspace and Parameters
clc; clear; close all;

% Set up directories and add paths
current_dirname = fileparts(matlab.desktop.editor.getActiveFilename);

cd(current_dirname)
pitch = 0.05;
%%
load(fullfile(current_dirname, 'Supplementary_data', 'FigR_offcenter.mat'));
close all

for j1 = [2 1 3]

    figure('Renderer', 'painters', 'Position', [10 10 300 250])
    yy = interp1(scan_range*1000,squeeze(Fs_Mie(j1,j1,:))*1e18,scan_range*1000,'cubic');
    plot(scan_range*1000,yy,'k'), hold on
    xlim([-1000 1000])
end
