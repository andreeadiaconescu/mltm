function [s] = MLTM_scatter2(X1, Y1, S1, C1)
%CREATEFIGURE(X1, Y1, S1, C1)
%  X1:  scatter x
%  Y1:  scatter y
%  S1:  scatter s
%  C1:  scatter c

%  Andreea Diaconescu


% Create figure
figure1 = figure;

% Create axes
axes1 = axes('Parent',figure1);
hold(axes1,'on');

% Create scatter
s = scatter(X1,Y1,S1,C1);

% Create xlabel
xlabel('AQ');

% Create ylabel
ylabel('total Score');

% Set the remaining axes properties
set(axes1,'FontName','Constantia','FontSize',20);
