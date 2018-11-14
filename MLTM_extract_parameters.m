function MLTM_extract_parameters(options)

subjectsAll = options.subjects;
[models] = MLTM_extractLME(options,subjectsAll);

% Load Log Bayes Factors
nModels = size(models,2);
log_bfs_all=models-repmat(models(:,2),[1 (nModels)]);
logBFs     = log_bfs_all(:,1);

% Load decision to take advice
[advice_taking] = MLTM_load_advice(options);

% Load Zeta
[mltm_zeta] = MLTM_load_zeta(options);


% Load Parameters
[mltm_par] = MLTM_load_parameters(options);

design_matrix = [mltm_zeta mltm_par ones(size(mltm_par,1),1)];

%% Plot & Stats

% Plot 1
[R,P,RLO,RUP]   = corrcoef(advice_taking(:,1),logBFs);

disp(['Advice-Taking and Log Bayes Factors ' num2str(R(1,2))]);
disp(['Advice-Taking and Log Bayes Factors ' num2str(P(1,2))]);

s = MLTM_scatter(advice_taking(:,1),logBFs,100,'m');
title('Predicting Gaze Bias from LogBFs');
s.LineWidth = 0.6;
s.MarkerFaceColor = [0 0.5 0.5];

[B,BINT,R,RINT,stats] = regress(advice_taking(:,1),design_matrix);
disp(['GLM with taking advice as the dependent variable:'...
' the R-square statistic, the F statistic and p value  ' ...
num2str(stats(1:3))]);

%% Save as table
ofile=fullfile(options.resultroot,'MLTM_MAP_estimates_winning_model_nonModelVariables.xlsx');
xlswrite(ofile, [str2num(cell2mat(options.subjects')) design_matrix]);
end