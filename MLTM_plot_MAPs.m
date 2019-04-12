function MLTM_plot_MAPs(options)

% load data
[MAPs,~,txt] = xlsread(options.groups,'data');

% Independent Variables
group      = txt(2:end,3);
condition  = txt(2:end,2);

% Dependent Variables
[zeta]                 = MLTM_load_zeta(options);   % high AQ, interaction
[perceptualParameters] = MLTM_load_parameters(options);
% 
kappa_r                = perceptualParameters(:,1); % low AQ, interaction
face_consideration     = MAPs(:,18);                % low AQ, interaction

perf_acc               = MAPs(:,19).*10^2;          % main effect, group
total_score            = MAPs(:,20);                % main effect, group

go_with_gaze_incorrect_freq ...
                       = MAPs(:,21);                % main effect, group

go_against_gaze_correct_freq ...
                       = MAPs(:,22);                % main effect, condition
arbitration_stable_card ...
                       = MAPs(:,23);                % high AQ, interaction
arbitration_volatile_card ...
                       = MAPs(:,24);                % high AQ, interaction
pi2_card ...
                       = MAPs(:,29);
adviceTaking1 ...
                       = MAPs(:,34);
adviceTaking2 ...
                       = MAPs(:,35);
adviceTaken_VolatilityGazeHighAccuracy ...
                       = MAPs(:,36);                % main effect, condition
adviceTaken_VolatilityGazeLowAccuracy ...
                       = MAPs(:,37);                % main effect, group
                   
zeta1_newModel ...
                       = MAPs(:,38);
adviceTaken_Volatility...
                       = MAPs(:,39);               % main effect group
adviceTaken_Stability...
                       = MAPs(:,40);
adviceTaken_StableGazeCongruent...                 % main effect condition
                       = MAPs(:,41);
                   
adviceTaken_StableGazeIncongruent...               % main effect condition
                       = MAPs(:,42);
                   
curr_var               = kappa_r; 
currentMAP             = 'kappa_r';

curr_var               = pi2_card; 
currentMAP             = 'pi_2';

MLTM_violinplot(curr_var,condition,group,currentMAP);







