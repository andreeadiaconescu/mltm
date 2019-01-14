function [advice_taking] = MLTM_load_advice(options)

subjectsAll = options.subjects;
advice      = cell(numel(subjectsAll), 13);
for  iSubject = 1:length(subjectsAll)
    sprintf('%s',subjectsAll{iSubject})
    tmp = load(fullfile(options.resultroot,[subjectsAll{iSubject},...
        'behaviour_variables.mat']), 'behav_var','-mat');
    
    advice{iSubject,1} = tmp.behav_var.adviceTaken;
    advice{iSubject,2} = tmp.behav_var.averageReward_when_follow_gaze;
    advice{iSubject,3} = tmp.behav_var.averageReward_when_Notfollow_gaze;
    advice{iSubject,4} = tmp.behav_var.takeHelpful;
    advice{iSubject,5} = tmp.behav_var.againstIncorrect;
    advice{iSubject,6} = tmp.behav_var.card_stable;
    advice{iSubject,7} = tmp.behav_var.card_volatile;
    advice{iSubject,8} = tmp.behav_var.advice_stable;
    advice{iSubject,9} = tmp.behav_var.advice_volatile;
    advice{iSubject,10} = tmp.behav_var.takeAdviceStableCard;
    advice{iSubject,11} = tmp.behav_var.takeAdviceVolatileCard;
    advice{iSubject,12} = tmp.behav_var.takeAdviceStableAdvice;
    advice{iSubject,13} = tmp.behav_var.takeAdviceVolatileAdvice;
    
end
advice_taking = cell2mat(advice);

%% Save as table
ofile=fullfile(options.resultroot,'MLTM_winning_model_nonModelVariables.xlsx');
xlswrite(ofile, [str2num(cell2mat(options.subjects')) [advice_taking]]);

columnNames = [{'subjectIds'}, ...
    {'adviceTaken','averageReward_when_follow_gaze', ...
    'averageReward_when_Notfollow_gaze','takeHelpful','againstIncorrect',...
    'card_stable','card_volatile','advice_stable','advice_volatile',...
    'takeAdviceStableCard','takeAdviceVolatileCard','takeAdviceStableAdvice','takeAdviceVolatileAdvice'}];
t = array2table([subjectsAll' num2cell([advice_taking])], ...
    'VariableNames', columnNames);
writetable(t, ofile);

end