function MLTM_extract_parameters(options)

subjectsAll = options.subjects;

%% Models and MAPs
[models] = MLTM_extractLME(options,subjectsAll);

% Load Log Bayes Factors
nModels     = size(models,2);
log_bfs_all = models-repmat(models(:,2),[1 (nModels)]);
logBFs      = log_bfs_all(:,1);

% Load decision to take advice
[advice_taking] = MLTM_load_advice(options);

% Load Zeta
[mltm_zeta]     = MLTM_load_zeta(options);

% Load Parameters
[mltm_par]      = MLTM_load_parameters(options);
design_matrix   = [mltm_par mltm_zeta(:,1) mltm_zeta(:,2) ones(size(mltm_par,1),1)];
zeta_matrix     = [mltm_zeta(:,1) ones(size(mltm_par,1),1)];
%% Figures
s     = MLTM_scatter(advice_taking(:,4),logBFs,100,'c');
[R,P] = corrcoef(advice_taking(:,4),logBFs);
disp(['Correlations: ' num2str(R(1,2))]);
disp(['P value  ' num2str(P(1,2))]);
title('Correlating Advice-taking (Helpful Advice) with LogBFs');
s.LineWidth = 0.6;
s.MarkerFaceColor = [0 0.5 0.5];
MLTM_plot_regression(advice_taking(:,4),logBFs);
%% Testing Model Validity
[B,BINT,R,RINT,stats] = regress(advice_taking(:,4),design_matrix);
disp(['GLM with taking advice as the dependent variable:'...
' p value  ' ...
num2str(stats(3))]);

%% Predictive Validity
[MAPs,~,~] = xlsread(options.questionnaires, 'subjects_scores');
EQ      = MAPs(:,2);
SQ      = MAPs(:,3); 
AQ      = MAPs(:,7); 

[B,BINT,R,RINT,stats] = regress(AQ,design_matrix);
disp(['GLM with AQ as the dependent variable:'...
' p value  ' ...
num2str(stats(3))]);

[B,BINT,R,RINT,stats] = regress(AQ,zeta_matrix);
disp(['Zeta with AQ as the dependent variable:'...
' p value  ' ...
num2str(stats(3))]);

[OlderFiles,~,~] = xlsread(options.questionnaires, 'AQ_Zeta_Score');
TotalScore = OlderFiles(:,4);

s = MLTM_scatter2(AQ,TotalScore,100,'m');
title('Predicting AQ from Total Score');
s.LineWidth = 0.6;
s.MarkerFaceColor = [0 0.5 0.5];

s = MLTM_scatter2(AQ,mltm_zeta(:,1),100,'c');
title('Predicting AQ from Zeta');
s.LineWidth = 0.6;
s.MarkerFaceColor = [0 0.5 0.5];

s = MLTM_scatter2(AQ,mltm_zeta(:,2),100,'g');
title('Predicting AQ from Beta');
s.LineWidth = 0.6;
s.MarkerFaceColor = [0 0.5 0.5];

%% Save as table
ofile=fullfile(options.resultroot,'MLTM_MAP_estimates_winning_model_nonModelVariables.xlsx');
xlswrite(ofile, [str2num(cell2mat(options.subjects')) [mltm_par mltm_zeta advice_taking(:,[1:5])]]);

columnNames = [{'subjectIds'}, options.model.hgfParam, options.model.respParam, ...
    {'adviceTaken','averageReward_when_follow_gaze', ...
    'averageReward_when_Notfollow_gaze','takeHelpful','againstIncorrect'}];
t = array2table([subjectsAll' num2cell([mltm_par mltm_zeta advice_taking(:,[1:5])])], ...
    'VariableNames', columnNames);
writetable(t, ofile);
end