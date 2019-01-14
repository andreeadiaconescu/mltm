function MLTM_plot_MAPs(options)

% load data
[MAPs,~,txt] = xlsread(options.groups,'data');

% Independent Variables
group      = txt(2:end,3);
condition  = txt(2:end,2);

% Dependent Variables
[zeta]           = MLTM_load_zeta(options);
advice           = MAPs(:,6);

[vs] = MLTM_violinplot(log(zeta(:,1)),condition,group);







