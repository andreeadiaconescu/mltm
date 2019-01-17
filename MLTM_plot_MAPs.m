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
face_consideration     = MAPs(:,19);                % lowAQ, interaction

perf_acc               = MAPs(:,20);                % group
total_score            = MAPs(:,21);                % group

going_with_incongruent_gaze ...
                       = MAPs(:,22);                % high AQ, interaction

going_against_congruent_gaze ...
                       = MAPs(:,23);                % condition
arbitration_stable_card ...
                       = MAPs(:,24);                % high AQ, interaction
arbitration_volatile_card ...
                       = MAPs(:,25);                % high AQ, interaction
pi2_card ...
                       = MAPs(:,30);                
                   
curr_var               = face_consideration;                  % lowAQ, interaction

[vs] = MLTM_violinplot(curr_var,condition,group);







