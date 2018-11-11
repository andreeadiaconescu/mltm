function MLTM_plot_trajectories(options)

subjectsAll = options.subjects;
for  iSubject = 1:length(subjectsAll)
    sprintf('%s',subjectsAll{iSubject})
    tmp = load(fullfile(options.resultroot,[subjectsAll{iSubject},options.model.perceptualModels{1}, ...
        options.model.responseModels{1},'.mat']), 'est_int','-mat');
    hgf_plotTraj_reward_social(tmp.est_int);
    
end




end