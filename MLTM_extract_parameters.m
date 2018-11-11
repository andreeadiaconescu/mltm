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

%% Plot & Stats

% Plot 1
[R,P,RLO,RUP]   = corrcoef(advice_taking(:,1),logBFs);

disp(['Advice-Taking and Log Bayes Factors ' num2str(R(1,2))]);
disp(['Advice-Taking and Log Bayes Factors ' num2str(P(1,2))]);

s = MLTM_scatter(advice_taking(:,1),logBFs,100,'m');
title('Predicting Gaze Bias from LogBFs');
s.LineWidth = 0.6;
s.MarkerFaceColor = [0 0.5 0.5];

[R,P,RLO,RUP]   = corrcoef(advice_taking(:,4),log(mltm_zeta));

disp(['Advice-Taking and Zeta ' num2str(R(1,2))]);
disp(['Advice-Taking and Zeta ' num2str(P(1,2))]);

% Plot 2
s = MLTM_scatter(advice_taking(:,4),log(mltm_zeta),100,'r');
title('Relating Zeta to Advice-Taking (Helpful)');
s.LineWidth = 0.6;
s.MarkerFaceColor = [0 0.5 0.5];

% Plot 3
[R,P,RLO,RUP]   = corrcoef(advice_taking(:,1),mltm_par(:,1));

disp(['Advice-Taking and Omega_Card ' num2str(R(1,2))]);
disp(['Advice-Taking and Omega_Card ' num2str(P(1,2))]);

s = MLTM_scatter(advice_taking(:,1),mltm_par(:,1),100,'m');
title('Predicting Gaze Bias from Omega_Card');
s.LineWidth = 0.6;
s.MarkerFaceColor = [0 0.5 0.5];

[R,P,RLO,RUP]   = corrcoef(advice_taking(:,1),log(mltm_zeta));

disp(['Advice-Taking and Zeta ' num2str(R(1,2))]);
disp(['Advice-Taking and Zeta ' num2str(P(1,2))]);

% Plot 2
s = MLTM_scatter(advice_taking(:,1),log(mltm_zeta),100,'r');
title('Relating Zeta to Advice-Taking (Misleading)');
s.LineWidth = 0.6;
s.MarkerFaceColor = [0 0.5 0.5];



end