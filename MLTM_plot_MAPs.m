function MLTM_plot_MAPs(options)

% load data
[MAPs,~,txt] = xlsread(options.groups,'data');

% Independent Variables
group      = txt(2:end,3);
condition  = txt(2:end,2);

% Dependent Variables
[zeta]                 = MLTM_load_zeta(options);
[perceptualParameters] = MLTM_load_parameters(options);
with_advice            = MAPs(:,6);

kappa_r                = perceptualParameters(:,1);
against_incorrect      = MAPs(:,16);

curr_var               = log(zeta(:,1));

[vs] = MLTM_violinplot(curr_var,condition,group);







