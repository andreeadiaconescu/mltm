function MLTM_model_selection(options)

subjAll = options.subjects;

[models] = MLTM_extractLME(options,subjAll);

save(fullfile(options.resultroot ,['models_results.mat']), ...
    'models', '-mat');

%% Model Selection
[~,model_posterior,xp,protected_xp,~]=spm_BMS(models);
H=model_posterior;
P = xp;
N=numel(H);
colorsProb=jet(numel(H));
colorsExceedance = bone(numel(P));
worst_model=find(model_posterior==min(model_posterior));
best_model= find(model_posterior==max(model_posterior)); 
% Plot results
figure;
nModels = size(models,2);
log_bfs_all=models-repmat(models(:,worst_model),[1 (nModels)]);
handleBar = bar(log_bfs_all(:,best_model));
set(handleBar, 'FaceColor', [0.3 0.3 0.3]);
line([0 length(subjAll)+1],[3 3], 'LineWidth',2,'LineStyle','-.','Color',[1 0 0]);
ylabel('Group Bayes factor');


% Plot results
figure;
for i=1:N
    h=bar(i,H(i));
    
    if i==1, hold on, end
    set(h,'FaceColor',colorsProb(i,:))
    
end
set(gca,'XTick',1:nModels)
set(gca,'XTickLabel',{'Both','Card'});
ylabel('p(r|y)');

figure;
for i=1:N
    
    j=bar(i,P(i));
    if i==1, hold on, end
    
    set(j,'FaceColor',colorsExceedance(i,:))
end
set(gca,'XTick',1:nModels)
set(gca,'XTickLabel',{'Both','Card'});
ylabel('Exceedance Probabilities');
disp(['Best model: ', num2str(find(model_posterior==max(model_posterior)))]);
end