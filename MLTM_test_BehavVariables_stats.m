function MLTM_test_BehavVariables_stats(options)

% MLTM_test_BehavVariables_stats        computes nANOVA for Behaviour
% Variables
%
% 
% Dependent Variables
% load data
[MAPs,~,~] = xlsread(options.groups,'data');

face_consideration     = MAPs(:,19);                % lowAQ, interaction

perf_acc               = MAPs(:,20);                % group
total_score            = MAPs(:,21);                % group

going_with_incongruent_gaze ...
                       = MAPs(:,22);                % high AQ, interaction

going_against_congruent_gaze ...
                       = MAPs(:,23);                % condition                
%% compute stats
% ~ ~ performance accuracy ~ ~ ~ ~
[BehavVariablesTable]  = MLTM_get_table(perf_acc,options);
[p, tbl, stats, terms] = anovan(...
    perf_acc, ...
    {BehavVariablesTable.condition, BehavVariablesTable.group}, ...
    'model','interaction', ...
    'varnames', {'condition', 'group'}, ...
    'display','off');

ANOVAAccuracy = tbl;  %InPaper

% ~ ~ total score ~ ~ ~ ~
[BehavVariablesTable]  = MLTM_get_table(total_score,options);
[p, tbl, stats, terms] = anovan(...
    total_score, ...
    {BehavVariablesTable.condition, BehavVariablesTable.group}, ...
    'model','interaction', ...
    'varnames', {'condition', 'group'}, ...
    'display','off');

ANOVATotalScore = tbl;  %InPaper

% ~ ~ consideration gaze ~ ~ ~ ~
[BehavVariablesTableGaze]  = MLTM_get_table(face_consideration,options);
[p, tbl, stats, terms] = anovan(...
    face_consideration, ...
    {BehavVariablesTableGaze.condition, BehavVariablesTableGaze.group}, ...
    'model','interaction', ...
    'varnames', {'condition', 'group'}, ...
    'display','off');

ANOVAConsideringGazeScore = tbl;  %InPaper

% ~ ~ with incongruent gaze ~ ~ ~ ~
[BehavVariablesTablewithIncongruentGaze]  = MLTM_get_table(going_with_incongruent_gaze,options);
[p, tbl, stats, terms] = anovan(...
    going_with_incongruent_gaze, ...
    {BehavVariablesTablewithIncongruentGaze.condition, BehavVariablesTablewithIncongruentGaze.group}, ...
    'model','interaction', ...
    'varnames', {'condition', 'group'}, ...
    'display','off');

ANOVAIncongruentGazeScore = tbl;  %InPaper

% ~ ~ against congruent gaze ~ ~ ~ ~
[BehavVariablesTable]  = MLTM_get_table(going_against_congruent_gaze,options);
[p, tbl, stats, terms] = anovan(...
    going_against_congruent_gaze, ...
    {BehavVariablesTable.condition, BehavVariablesTable.group}, ...
    'model','interaction', ...
    'varnames', {'condition', 'group'}, ...
    'display','off');

ANOVACongruentGazeScore = tbl;  %InPaper


%% make ANOVA tables
ANOVAAccuracyTbl = cell2table(ANOVAAccuracy(2:end,:),...
                        'VariableNames',{'Performance_Accuracy','SumSq1',...
                        'df','Singular1','MeanSq1','F1','PValue1'});
disp(ANOVAAccuracyTbl);

ANOVATotalScoreTbl = cell2table(ANOVATotalScore(2:end,:),...
                        'VariableNames',{'Total_Score','SumSq1',...
                        'df','Singular1','MeanSq1','F1','PValue1'});
disp(ANOVATotalScoreTbl);

ANOVAConsideringGazeTbl = cell2table(ANOVAConsideringGazeScore(2:end,:),...
                        'VariableNames',{'Considering_Gaze','SumSq1',...
                        'df','Singular1','MeanSq1','F1','PValue1'});
disp(ANOVAConsideringGazeTbl);

ANOVAIncongruentGazeTbl = cell2table(ANOVAIncongruentGazeScore(2:end,:),...
                        'VariableNames',{'With_Incongruent_Gaze','SumSq1',...
                        'df','Singular1','MeanSq1','F1','PValue1'});
disp(ANOVAIncongruentGazeTbl);

ANOVACongruentGazeTbl = cell2table(ANOVACongruentGazeScore(2:end,:),...
                        'VariableNames',{'Against_Congruent_Gaze','SumSq1',...
                        'df','Singular1','MeanSq1','F1','PValue1'});
disp(ANOVACongruentGazeTbl);
%% prepate data for ttests
sortbyCondition         = sortrows(BehavVariablesTableGaze,2);

sortbygroupHelpful      = sortrows(sortbyCondition([1:19],:),3);
ConditionHelpfulLow     = sortbygroupHelpful([11:19],1);
ConditionHelpfulHigh    = sortbygroupHelpful([1:10],1);

sortbygroupMisleading   = sortrows(sortbyCondition([20:end],:),3);
ConditionMisleadingLow  = sortbygroupMisleading([9:17],1);
ConditionMisleadingHigh = sortbygroupMisleading([1:8],1);


% ~ ~ consideringGaze in Group 1 ~ ~ ~ ~
consideringGazeLowHelpful     = ConditionHelpfulLow;
consideringGazeLowMisleading  = ConditionMisleadingLow;

% ~ ~ consideringGaze in Group 2 ~ ~ ~ ~
consideringGazeHighHelpful    = ConditionHelpfulHigh;
consideringGazeHighMisleading = ConditionMisleadingHigh;


%% compute post-hoc ttests reported in paper
% ~ ~ consideringGaze ~ ~ ~ ~
[h,p,ci,MainResults.low.consideringGaze]     = ...
    ttest2(cell2mat(table2cell(consideringGazeLowHelpful)), cell2mat(table2cell(consideringGazeLowMisleading)));
MainResults.low.consideringGaze.p            = p;
MainResults.low.consideringGaze.pBonf        = p*2;

[h,p,ci,MainResults.high.consideringGaze]    = ...
    ttest2(cell2mat(table2cell(consideringGazeHighHelpful)), cell2mat(table2cell(consideringGazeHighMisleading)));
MainResults.high.consideringGaze.p           = p;
MainResults.high.consideringGaze.pBonf       = p*2;

%% prepate data for ttests
sortbyCondition         = sortrows(BehavVariablesTablewithIncongruentGaze,2);

sortbygroupHelpful      = sortrows(sortbyCondition([1:19],:),3);
ConditionHelpfulLow     = sortbygroupHelpful([11:19],1);
ConditionHelpfulHigh    = sortbygroupHelpful([1:10],1);

sortbygroupMisleading   = sortrows(sortbyCondition([20:end],:),3);
ConditionMisleadingLow  = sortbygroupMisleading([9:17],1);
ConditionMisleadingHigh = sortbygroupMisleading([1:8],1);


% ~ ~ withIncongruentGaze in Group 1 ~ ~ ~ ~
withIncongruentGazeLowHelpful     = ConditionHelpfulLow;
withIncongruentGazeLowMisleading  = ConditionMisleadingLow;

% ~ ~ withIncongruentGaze in Group 2 ~ ~ ~ ~
withIncongruentGazeHighHelpful    = ConditionHelpfulHigh;
withIncongruentGazeHighMisleading = ConditionMisleadingHigh;


%% compute post-hoc ttests reported in paper
% ~ ~ withIncongruentGaze ~ ~ ~ ~
[h,p,ci,MainResults.low.withIncongruentGaze]     = ...
    ttest2(cell2mat(table2cell(withIncongruentGazeLowHelpful)), cell2mat(table2cell(withIncongruentGazeLowMisleading)));
MainResults.low.withIncongruentGaze.p            = p;
MainResults.low.withIncongruentGaze.pBonf        = p*2;

[h,p,ci,MainResults.high.withIncongruentGaze]    = ...
    ttest2(cell2mat(table2cell(withIncongruentGazeHighHelpful)), cell2mat(table2cell(withIncongruentGazeHighMisleading)));
MainResults.high.withIncongruentGaze.p           = p;
MainResults.high.withIncongruentGaze.pBonf       = p*2;


display_substruct(MainResults);
end
