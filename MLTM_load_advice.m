function [advice_taking] = MLTM_load_advice(options)

subjectsAll = options.subjects;
advice      = cell(numel(subjectsAll), 13);
for  iSubject = 1:length(subjectsAll)
    sprintf('%s',subjectsAll{iSubject})
    tmp = load(fullfile(options.resultroot,[subjectsAll{iSubject},...
        'behaviour_variables.mat']), 'behav_var','-mat');
    
    advice{iSubject,1}  = tmp.behav_var.performance_accuracy;
    advice{iSubject,2}  = tmp.behav_var.totalScore;
    advice{iSubject,3}  = tmp.behav_var.go_with_gaze_incorrect_freq;
    advice{iSubject,4}  = tmp.behav_var.go_against_gaze_correct_freq;
    
    advice{iSubject,5}  = tmp.behav_var.averageReward_when_follow_gaze;
    advice{iSubject,6}  = tmp.behav_var.averageReward_when_Notfollow_gaze;
    
    advice{iSubject,7}  = tmp.behav_var.takeAdviceStableCard;
    advice{iSubject,8} = tmp.behav_var.takeAdviceVolatileCard;
    
    advice{iSubject,9} = tmp.behav_var.advice_taken_all;
    advice{iSubject,10} = tmp.behav_var.advice_taken_vol;
    advice{iSubject,11} = tmp.behav_var.advice_taken_stable;
    
    advice{iSubject,12} = tmp.behav_var.advice_taken_stablehelpful;
    advice{iSubject,13} = tmp.behav_var.advice_taken_stablemisleading;
    advice{iSubject,14} = tmp.behav_var.advice_taken_volhighacc;   
    advice{iSubject,15} = tmp.behav_var.advice_taken_vol_lowacc;
                               
end
advice_taking = cell2mat(advice);

%% Save as table
ofile=fullfile(options.resultroot,'MLTM_winning_model_nonModelVariables.xlsx');
xlswrite(ofile, [str2num(cell2mat(options.subjects')) [advice_taking]]);

columnNames = [{'subjectIds'}, ...
    {'performance_accuracy','totalScore', ...
    'go_with_gaze_incorrect_freq','go_against_gaze_correct_freq',...
    'averageReward_when_follow_gaze','averageReward_when_Notfollow_gaze',...
    'takeAdviceStableCard','takeAdviceVolatileAdvice',...
    'adviceTaken','adviceTaken_Volatility','adviceTaken_Stability',...
    'adviceTaken_StableGazeCongruent','adviceTaken_StableGazeIncongruent',...
    'adviceTaken_VolatilityGazeHighAccuracy','adviceTaken_VolatilityGazeLowAccuracy'}];
t = array2table([subjectsAll' num2cell([advice_taking])], ...
    'VariableNames', columnNames);
writetable(t, ofile);

end