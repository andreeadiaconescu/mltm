function MLTM_extract_parameters(options)

subjectsAll = options.subjects;
[models] = MLTM_extractLME(options,subjectsAll);

% Load Log Bayes Factors
nModels = size(models,2);
log_bfs_all=models-repmat(models(:,2),[1 (nModels)]);
logBFs     = log_bfs_all(:,1);

% Load decision to take advice

[advice_taking] = MLTM_load_advice(options,subjectsAll);

% Load Zeta

[mltm_zeta] = MLTM_load_zeta(options,subjectsAll);

% Load Parameters
[mltm_par] = MLTM_load_parameters(options,subjectsAll);

% Plot
figure;
s = MLTM_scatter(advice_taking,logBFs,100,'m');
title('Predicting Gaze Bias from LogBFs');
s.LineWidth = 0.6;
s.MarkerFaceColor = [0 0.5 0.5];

end