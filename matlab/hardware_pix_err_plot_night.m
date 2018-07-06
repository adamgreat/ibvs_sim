clc
clear
close all

% ---------
% Plot Setup
% ---------
% Set Plot Width and FontSize
plot_width = 3.0;
aspect_ratio = 4/3; % 4:3 3:2
% Titel and Label Font size
font_size = 8.0;
% Legend font size
lfont_size = 8.0;
plot_height = plot_width * (1/aspect_ratio);
%

% Time when IBVS became active (retlative to when AUTO was engaged)
t0 = 29.0;

% Load mat files
data_outer = load('~/Desktop/rosbags/june_11/test1nightlandingibvs_data_outer.mat');
data_inner = load('~/Desktop/rosbags/june_11/test1nightlandingibvs_data_inner.mat');

% Trim off all of the data before and after IBVS mode was active
ar = data_outer.arr(:,32);
idx = find(ar);
first = idx(1);
last = idx(end);
data_outer = data_outer.arr(first:last,:);

ar = data_inner.arr(:,32);
idx = find(ar);
first = idx(1);
last = idx(end);
data_inner = data_inner.arr(first:last,:);

% Now we want to combine the two sets of data and split them where the
% switchover occurs

% get everything before switch to inner marker
idx = find(data_outer(:,33), 1);
idx = idx - 1;
data_outer = data_outer(1:idx,:);

% get everything after switch to inner marker
idx = find(data_inner(:,33), 1);
data_inner = data_inner(idx:end,:);

% combine them
data = [data_outer; data_inner];

% now get the data we care about
t = data(:,1);
t = t - t(1);
t = t + t0;

idx = find(data(:,33), 1);
t_switch = t(idx);
t_switch = [t_switch; t_switch];
line = [0; 300];

e1 = data(:,2);
e2 = data(:,3);
e3 = data(:,4);
e4 = data(:,5);

% figure(1), clf
figure('Units', 'inches', ...
       'Position', [0 0 plot_width plot_height], ...
       'PaperPositionMode', 'auto')
   
plot(t,e1, t,e2, t,e3, t,e4)
hold on
plot(t_switch, [-100, 1000], '--k')
% title('Marker Detection Rate vs Distance from Marker',...
%       'Interpreter', 'latex',...
%       'FontUnits', 'points',...
%       'FontSize', font_size,...
%       'FontName', 'Times')
  
xlabel('Time (s)',...
       'Interpreter', 'latex',...
       'FontUnits', 'points',...
       'FontSize', font_size,...
       'FontName', 'Times')
   
ylabel('$Error Length (pixels)$',...
       'Interpreter', 'latex',...
       'FontUnits', 'points',...
       'FontSize', font_size,...
       'FontName', 'Times')

% legend({'Outer', 'Inner'},...
%        'Interpreter', 'latex',...
%        'FontUnits', 'points',...
%        'FontSize', lfont_size,...
%        'FontName', 'Times',...
%        'Location', 'East',...
%        'Orientation', 'vertical',...
%        'Box', 'on')

axis([29, 50.7, 0, 230])
set(gca, ...
    'YTick', 0:50:200,...
    'XTick', 30:5:50)
grid on

%EXPORT FIGURE
% -Select the figure window you want to export
% -in command window:
%  print -depsc2 path2plotfile.eps
%