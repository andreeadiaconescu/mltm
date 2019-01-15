function MLTM_extract_parameters(options)

subjectsAll = options.subjects;

%% Load MAPs
% Load decision to take advice
[advice_taking] = MLTM_load_advice(options);

% Load Zeta
[mltm_zeta]     = MLTM_load_zeta(options);
zeta_matrix     = [mltm_zeta(:,1) ones(size(mltm_zeta,1),1)];

% Load Learning Parameters
[mltm_par]      = MLTM_load_parameters(options);
design_matrix   = [mltm_par mltm_zeta(:,1) mltm_zeta(:,2) ones(size(mltm_par,1),1)];

%% Testing Model Validity
[B,BINT,R,RINT,stats] = regress(advice_taking(:,1),design_matrix);
disp(['GLM with performance accuracy as the dependent variable:'...
' p value  ' ...
num2str(stats(3))]);

[B,BINT,R,RINT,stats] = regress(advice_taking(:,2),design_matrix);
disp(['GLM with total score as the dependent variable:'...
' p value  ' ...
num2str(stats(3))]);

[B,BINT,R,RINT,stats] = regress(advice_taking(:,5),design_matrix);
disp(['GLM with going with incongruent_gaze as the dependent variable:'...
' p value  ' ...
num2str(stats(3))]);

%% Figures
s = MLTM_scatter(design_matrix(:,2), advice_taking(:,1),100,'m');
title('Predicting Accuracy from Theta_r');
s.LineWidth = 0.6;
s.MarkerFaceColor = [0 0.5 0.5];

s = MLTM_scatter1(design_matrix(:,6), advice_taking(:,2),100,'r');
title('Predicting Total Score from Beta');
s.LineWidth = 0.6;
s.MarkerFaceColor = [0 0.5 0.5];

s = MLTM_scatter2(design_matrix(:,5), advice_taking(:,5),100,'c');
title('Predicting Going With Incongruent Gaze from Zeta');
s.LineWidth = 0.6;
s.MarkerFaceColor = [0 0.5 0.5];

%% Save as table
ofile=fullfile(options.resultroot,'MLTM_MAP_estimates_winning_model_nonModelVariables.xlsx');
xlswrite(ofile, [str2num(cell2mat(options.subjects')) [mltm_par mltm_zeta advice_taking(:,[1:5])]]);

columnNames = [{'subjectIds'}, options.model.hgfParam, options.model.respParam, ...
    {'performanceAccuracy','totalScore', ...
    'going_with_incongruent_gaze','going_against_congruent_gaze'}];
t = array2table([subjectsAll' num2cell([mltm_par mltm_zeta advice_taking(:,[1 2 5 6])])], ...
    'VariableNames', columnNames);
writetable(t, ofile);
end