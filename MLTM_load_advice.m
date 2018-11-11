function [advice_taking] = MLTM_load_advice(options)

subjectsAll = options.subjects;
advice      = cell(numel(subjectsAll), 5);
for  iSubject = 1:length(subjectsAll)
    sprintf('%s',subjectsAll{iSubject})
    tmp = load(fullfile(options.resultroot,[subjectsAll{iSubject},...
        'behaviour_variables.mat']), 'behav_var','-mat');
    
    advice{iSubject,1} = tmp.behav_var.adviceTaken;
    advice{iSubject,2} = tmp.behav_var.averageReward_when_follow_gaze;
    advice{iSubject,3} = tmp.behav_var.averageReward_when_Notfollow_gaze;
    advice{iSubject,4} = tmp.behav_var.takeHelpful;
    advice{iSubject,5} = tmp.behav_var.againstIncorrect;
end
advice_taking = cell2mat(advice);

end