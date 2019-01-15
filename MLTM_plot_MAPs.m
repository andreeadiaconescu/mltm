function MLTM_plot_MAPs(options)

% load data
[MAPs,~,txt] = xlsread(options.groups,'data');

% Independent Variables
group      = txt(2:end,3);
condition  = txt(2:end,2);

% Dependent Variables
[zeta]                 = MLTM_load_zeta(options);   % high AQ, interaction
[perceptualParameters] = MLTM_load_parameters(options);

kappa_r                = perceptualParameters(:,1); % lowAQ, interaction
face_consideration     = MAPs(:,17);                % lowAQ, interaction

perf_acc               = MAPs(:,20);                % group
total_score            = MAPs(:,21);                % group

going_with_incongruent_gaze ...
                       = MAPs(:,22);                % high AQ, interaction

going_against_congruent_gaze ...
                       = MAPs(:,23);                % condition
                   
curr_var               = kappa_r;

[vs] = MLTM_violinplot(curr_var,condition,group);







