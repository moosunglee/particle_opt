%% Initialize Workspace and Parameters
clc; clear; close all;

% Set up directories and add paths
current_dirname = fileparts(matlab.desktop.editor.getActiveFilename);
% main_dirname = (fileparts(fileparts(current_dirname)));

cd(current_dirname)
%%
sio2_mie_data = load(fullfile(current_dirname, 'mie_diameter_plots', 'SiO2_cbs_mie_rayleigh.mat'));
dir_3D = fullfile(current_dirname, 'SiO2_3D');
cd(dir_3D)

% Select which RI map you want to see:
j0_want = 1; % 1 ~ 4

sio2_mie_data.vols = sio2_mie_data.radius_list.^3 * 4 * pi / 3;

%% Scan enhancement factors (freq & eta)
dim_list = [2,1,3];
datadir = dir(fullfile(dir_3D,'summary*.mat'));

cd(current_dirname)
%% RI & E field draw
j0_want = 1;
% %{
data_opt = load(fullfile(datadir(j0_want).folder,datadir(j0_want).name));
close all
X = 18; Y = 18; Z = 24;

RI_f_cut = data_opt.RI_1110(floor(end/2)+1-X:floor(end/2)+1+X,floor(end/2)+1-Y:floor(end/2)+1+Y,floor(end/2)+1-Z:floor(end/2)+1+Z, :);
figure,
subplot(221), imagesc(RI_f_cut(:,:,floor(end/2)+1), [0 1]), axis image, colormap(gray), colorbar
subplot(222), imagesc(squeeze(RI_f_cut(:,floor(end/2)+1,:))', [0 1]), axis image, colorbar
subplot(223), imagesc(squeeze(RI_f_cut(floor(end/2)+1,:, :))', [0 1]), axis image, colorbar

E_opt_cut = data_opt.E_1110(floor(end/2)+1-X:floor(end/2)+1+X,floor(end/2)+1-Y:floor(end/2)+1+Y,floor(end/2)+1-Z:floor(end/2)+1+Z, :);
I_opt_cut = sum(abs(E_opt_cut).^2,4);
%
crange0 = [0, 2.5];
figure,
subplot(221), imagesc(I_opt_cut(:,:,floor(end/2)+1), crange0), axis image, colormap(gray), colorbar
subplot(222), imagesc(squeeze(I_opt_cut(:,floor(end/2)+1,:))', crange0), axis image, colorbar
subplot(223), imagesc(squeeze(I_opt_cut(floor(end/2)+1,:, :))', crange0), axis image, colorbar

RI_f_cut = data_opt.RI_1111(floor(end/2)+1-X:floor(end/2)+1+X,floor(end/2)+1-Y:floor(end/2)+1+Y,floor(end/2)+1-Z:floor(end/2)+1+Z, :);
figure,
subplot(221), imagesc(RI_f_cut(:,:,floor(end/2)+1), [0 1]), axis image, colormap(gray), colorbar
subplot(222), imagesc(squeeze(RI_f_cut(:,floor(end/2)+1,:))', [0 1]), axis image, colorbar
subplot(223), imagesc(squeeze(RI_f_cut(floor(end/2)+1,:, :))', [0 1]), axis image, colorbar

E_opt_cut = data_opt.E_1111(floor(end/2)+1-X:floor(end/2)+1+X,floor(end/2)+1-Y:floor(end/2)+1+Y,floor(end/2)+1-Z:floor(end/2)+1+Z, :);
I_opt_cut = sum(abs(E_opt_cut).^2,4);
%
crange0 = [0, 2.5];
figure,
subplot(221), imagesc(I_opt_cut(:,:,floor(end/2)+1), crange0), axis image, colormap(gray), colorbar
subplot(222), imagesc(squeeze(I_opt_cut(:,floor(end/2)+1,:))', crange0), axis image, colorbar
subplot(223), imagesc(squeeze(I_opt_cut(floor(end/2)+1,:, :))', crange0), axis image, colorbar


%%

xx = linspace(min(data_opt.scan_range*1000),max(data_opt.scan_range*1000),101);
c =  flip(sky,1); 
axis_lists = [-300 300; -400 400;-400 400];
close all,clc
for j1 = [2 1 3]

    figure('Renderer', 'painters', 'Position', [10 10 300 250])
    yy = interp1(data_opt.scan_range*1000,squeeze(data_opt.Fs_Mie(j1,j1,:))*1e18,xx,'cubic');
    plot(xx,yy,'k'), hold on
    axis([-500 500 axis_lists(j1,:)])
    set(gca,'XTick',linspace(-500,500,3))
    set(gca,'YTick',linspace(axis_lists(j1,1),axis_lists(j1,2),5))
    set(gca,'TickLength',[0.02, 0.01])

    yy = interp1(data_opt.scan_range*1000,squeeze(data_opt.Fs_1110(j1,j1,:))*1e18,xx,'cubic');
    plot(xx,yy,'color', 'c', 'linewidth',2)
    axis([-500 500 axis_lists(j1,:)])
    set(gca,'TickLength',[0.02, 0.01])

    yy = interp1(data_opt.scan_range*1000,squeeze(data_opt.Fs_1111(j1,j1,:))*1e18,xx,'cubic');
    plot(xx,yy,'color', 'm', 'linewidth',2)
    axis([-500 500 axis_lists(j1,:)])
    set(gca,'TickLength',[0.02, 0.01])

    set(gca,'XTickLabel',[]);
    set(gca,'YTickLabel',[]);
    set(gca,'XTick',[])
    set(gca,'YTick',[])

end

%% SI: Diagonal component only
% % % rgb = 'grb';
% % % axis_lists = [-3e-10 3e-10; -4e-10 4e-10;-4e-10 4e-10];
% % % close all
% % % for j1 = [2 1 3]
% % %     for j2 = [2,1,3]
% % %         yy = interp1(data_opt.scan_range*1000,squeeze(data_opt.Fs_1110(j1,j2,:))*1e6,xx,'cubic');
% % %         % scatter(data_opt.scan_range*1000, squeeze(data_opt.Fs_1110(j1,j1,:))*1e6,50,'b^'), xlabel('nm'), hold on
% % %         plot(xx,yy,rgb(j2), 'linewidth',2)
% % %         axis([-500 500 axis_lists(j1,:)])
% % %         set(gca,'TickLength',[0.02, 0.01])
% % %         hold on
% % %     end
% % % 
% % % end

%%
xx = linspace(min(data_opt.scan_range_rot*180/pi),max(data_opt.scan_range_rot*180/pi),101);
I_principal_list = zeros(3,3);
axis_lists = [-200 200; -200 200; -50 50;];
close all,clc
for j1 = [2 1 3]
    figure('Renderer', 'painters', 'Position', [10 10 300 250])
    yy = interp1(data_opt.scan_range_rot*180/pi,squeeze(data_opt.Fs_rot_1110(j1,j1,:))*1e30,xx,'cubic');
    plot(xx,yy,'color', 'm', 'linewidth',2)
    axis([-90 90 axis_lists(j1,:)])
    set(gca,'TickLength',[0.02, 0.01])
    set(gca,'XTick',linspace(-90,90,5))
    set(gca,'YTick',linspace(axis_lists(j1,1),axis_lists(j1,2),5))
    hold on

    % subplot(224)
    yy = interp1(data_opt.scan_range_rot*180/pi,squeeze(data_opt.Fs_rot_1111(j1,j1,:))*1e30,xx,'cubic');
    plot(xx,yy,'color', 'c', 'linewidth',2)
    set(gca,'XTickLabel',[]);
    set(gca,'YTickLabel',[]);
    set(gca,'XTick',[])
    set(gca,'YTick',[])

end

% % % %% SI: Diagonal components
% % % rgb = 'grb';
% % % axis_lists = [-200 200; -200 200; -50 50;];
% % % close all
% % % for j1 = [2 1 3]
% % % 
% % %     
% % %     figure('Renderer', 'painters', 'Position', [10 10 300 250])
% % %     for j2 = [2,1,3]
% % %         yy = interp1(data_opt.scan_range_rot*180/pi,squeeze(data_opt.Fs_rot_1110(j1,j2,:))*1e30,xx,'cubic');
% % %         plot(xx,yy,rgb(j2), 'linewidth',2)
% % %         axis([-90 90 axis_lists(j1,:)])
% % %         set(gca,'TickLength',[0.02, 0.01])
% % %         set(gca,'XTick',linspace(-90,90,5))
% % %         set(gca,'YTick',linspace(axis_lists(j1,1),axis_lists(j1,2),5))
% % %         hold on
% % % 
% % %     end
% % % end

%%
close all;
figure('Renderer', 'painters', 'Position', [10 10 600 800])
% c =  flip(crameri('hawaii',2),1); 
subplot(121)
 
y = [data_opt.Freqs_1110(2) data_opt.Freqs_1111(2)];
subplot(431), b = bar(1,y, 'FaceColor','flat', 'EdgeColor','none');
for k = 1:length(y)
    b(k).CData = c(k,:);
end
y0 = 90;
ylim([0,y0])
set(gca,'YTick',linspace(0,y0,3))
 title('SiO2 freq (kHz) 250 mW X')
set(gca,'TickLength',[0.02, 0.01])
    set(gca,'XTickLabel',[]);
    set(gca,'YTickLabel',[]);
    set(gca,'XTick',[])
    set(gca,'YTick',[])


y = [data_opt.Freqs_1110(1) data_opt.Freqs_1111(1)];
subplot(432),  b = bar(1,y, 'FaceColor','flat', 'EdgeColor','none');
for k = 1:length(y)
    b(k).CData = c(k,:);
end
 title('SiO2 freq (kHz) 250 mW Y')
y0 = 90;
ylim([0,y0])
set(gca,'YTick',linspace(0,y0,3))
set(gca,'TickLength',[0.02, 0.01])
    set(gca,'XTickLabel',[]);
    set(gca,'YTickLabel',[]);
    set(gca,'XTick',[])
    set(gca,'YTick',[])

 y = [data_opt.Freqs_1110(3) data_opt.Freqs_1111(3)];
subplot(433), b = bar(1,y, 'FaceColor','flat', 'EdgeColor','none');
for k = 1:length(y)
    b(k).CData = c(k,:);
end
y0 = 130;
ylim([0,y0])
set(gca,'YTick',linspace(0,y0,3))
set(gca,'TickLength',[0.02, 0.01])
 title('SiO2 freq (kHz) 250 mW Z')
    set(gca,'XTickLabel',[]);
    set(gca,'YTickLabel',[]);
    set(gca,'XTick',[])
    set(gca,'YTick',[])

y = [data_opt.Etas_1110(2) data_opt.Etas_1111(2)]*100;
subplot(434),  b = bar(1,y, 'FaceColor','flat', 'EdgeColor','none');
for k = 1:length(y)
    b(k).CData = c(k,:);
end
y0 = 90;
ylim([0,y0])
set(gca,'YTick',linspace(0,y0,3))
 title('etas 250 mW X')
set(gca,'TickLength',[0.02, 0.01])
    set(gca,'XTickLabel',[]);
    set(gca,'YTickLabel',[]);
    set(gca,'XTick',[])
    set(gca,'YTick',[])

y = [data_opt.Etas_1110(1) data_opt.Etas_1111(1)]*100;
subplot(435),  b = bar(1,y, 'FaceColor','flat', 'EdgeColor','none');
for k = 1:length(y)
    b(k).CData = c(k,:);
end
 title('etas Y')
 y0 = 90;
ylim([0,y0])
set(gca,'YTick',linspace(0,y0,3))
set(gca,'TickLength',[0.02, 0.01])
    set(gca,'XTickLabel',[]);
    set(gca,'YTickLabel',[]);
    set(gca,'XTick',[])
    set(gca,'YTick',[])


 y = [data_opt.Etas_1110(3) data_opt.Etas_1111(3)]*100;
subplot(436),  b = bar(1,y, 'FaceColor','flat', 'EdgeColor','none');
for k = 1:length(y)
    b(k).CData = c(k,:);
end
 title('etas Z')
 y0 = 100;
ylim([0,y0])
set(gca,'YTick',linspace(0,y0,3))
 set(gca,'TickLength',[0.02, 0.01])
    set(gca,'XTickLabel',[]);
    set(gca,'YTickLabel',[]);
    set(gca,'XTick',[])
    set(gca,'YTick',[])


y = [data_opt.Freqs_rot_1110(2) data_opt.Freqs_rot_1111(2)];
subplot(437),  b = bar(1,y, 'FaceColor','flat', 'EdgeColor','none');
for k = 1:length(y)
    b(k).CData = c(k,:);
end
y0 = 190;
ylim([0,y0])
set(gca,'YTick',linspace(0,y0,3))
 title('SiO2 freq (kHz) 250 mW X')
    set(gca,'XTickLabel',[]);
    set(gca,'YTickLabel',[]);
    set(gca,'XTick',[])
    set(gca,'YTick',[])

y = [data_opt.Freqs_rot_1110(1) data_opt.Freqs_rot_1111(1)];
set(gca,'TickLength',[0.02, 0.01])
subplot(438),  b = bar(1,y, 'FaceColor','flat', 'EdgeColor','none');
for k = 1:length(y)
    b(k).CData = c(k,:);
end
y0 = 180;
ylim([0,y0])
set(gca,'YTick',linspace(0,y0,3))
 title('SiO2 freq (kHz) 250 mW Y')
    set(gca,'XTickLabel',[]);
    set(gca,'YTickLabel',[]);
    set(gca,'XTick',[])
    set(gca,'YTick',[])

y = [data_opt.Freqs_rot_1110(3) data_opt.Freqs_rot_1111(3)];
subplot(439),  b = bar(1,y, 'FaceColor','flat', 'EdgeColor','none');
for k = 1:length(y)
    b(k).CData = c(k,:);
end
 title('SiO2 freq rot (kHz) 250 mW Z')
y0 = 80;
ylim([0,y0])
set(gca,'YTick',linspace(0,y0,3))
set(gca,'TickLength',[0.02, 0.01])
    set(gca,'XTickLabel',[]);
    set(gca,'YTickLabel',[]);
    set(gca,'XTick',[])
    set(gca,'YTick',[])


y = [data_opt.Etas_rot_1110(2) data_opt.Etas_rot_1111(2)]*100;
subplot(4,3,10),  b = bar(1,y, 'FaceColor','flat', 'EdgeColor','none');
for k = 1:length(y)
    b(k).CData = c(k,:);
end
 title('etas 250 mW X')
y0 = 60;
ylim([0,y0])
set(gca,'YTick',linspace(0,y0,3))
    set(gca,'XTickLabel',[]);
    set(gca,'YTickLabel',[]);
    set(gca,'XTick',[])
    set(gca,'YTick',[])


y = [data_opt.Etas_rot_1110(1) data_opt.Etas_rot_1111(1)]*100;
set(gca,'TickLength',[0.02, 0.01])
subplot(4,3,11),  b = bar(1,y, 'FaceColor','flat', 'EdgeColor','none');
for k = 1:length(y)
    b(k).CData = c(k,:);
end
 title('etas Y')
y0 = 60;
ylim([0,y0])
set(gca,'YTick',linspace(0,y0,3))
    set(gca,'XTickLabel',[]);
    set(gca,'YTickLabel',[]);
    set(gca,'XTick',[])
    set(gca,'YTick',[])
    

y = [data_opt.Etas_rot_1110(3) data_opt.Etas_rot_1111(3)]*100;
 set(gca,'TickLength',[0.02, 0.01])
subplot(4,3,12),  b = bar(1,y, 'FaceColor','flat', 'EdgeColor','none');
for k = 1:length(y)
    b(k).CData = c(k,:);
end
 title('etas Z')
y0 = 90;
ylim([0,y0])
set(gca,'YTick',linspace(0,y0,3))
set(gca,'TickLength',[0.02, 0.01])
    set(gca,'XTickLabel',[]);
    set(gca,'YTickLabel',[]);
    set(gca,'XTick',[])
    set(gca,'YTick',[])
