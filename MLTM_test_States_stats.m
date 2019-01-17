function MLTM_test_States_stats(options)

% MLTM_test_States_stats        computes nANOVA for the Precision2
%
% 
% Dependent Variables
% load data
[MAPs,~,~] = xlsread(options.groups,'data');

pi2hat_card ...
                       = MAPs(:,30);                
%% compute stats
% ~ ~ belief precision card ~ ~ ~ ~

[BehavTable3]     = MLTM_get_table(pi2hat_card,options);
[p, tbl, stats, terms] = anovan(...
    pi2hat_card, ...
    {BehavTable3.condition, BehavTable3.group}, ...
    'model','interaction', ...
    'varnames', {'condition', 'group'}, ...
    'display','off');

ANOVAPi = tbl;  %InPaper


%% make ANOVA tables
ANOVAPiTbl = cell2table(ANOVAPi(2:end,:),...
                        'VariableNames',{'pi2hat_Card','SumSq1',...
                        'df','Singular1','MeanSq1','F1','PValue1'});
disp(ANOVAPiTbl);

%% prepate data for ttests
sortbyCondition         = sortrows(BehavTable3,2);

sortbygroupHelpful      = sortrows(sortbyCondition([1:19],:),3);
ConditionHelpfulLow     = sortbygroupHelpful([11:19],1);
ConditionHelpfulHigh    = sortbygroupHelpful([1:10],1);

sortbygroupMisleading   = sortrows(sortbyCondition([20:end],:),3);
ConditionMisleadingLow  = sortbygroupMisleading([9:17],1);
ConditionMisleadingHigh = sortbygroupMisleading([1:8],1);


% ~ ~ pi2hat_r in Group 1 ~ ~ ~ ~
pi2hatLowHelpful     = ConditionHelpfulLow;
pi2hatLowMisleading  = ConditionMisleadingLow;

% ~ ~ pi2hat_r in Group 2 ~ ~ ~ ~
pi2hatHighHelpful    = ConditionHelpfulHigh;
pi2hatHighMisleading = ConditionMisleadingHigh;


%% compute post-hoc ttests reported in paper
% ~ ~ pi2hat_r ~ ~ ~ ~
[h,p,ci,MainResults.low.pi2hat_r]     = ...
    ttest2(cell2mat(table2cell(pi2hatLowHelpful)), cell2mat(table2cell(pi2hatLowMisleading)));
MainResults.low.pi2hat_r.p            = p;
MainResults.low.pi2hat_r.pBonf        = p*2;

[h,p,ci,MainResults.high.pi2hat_r]    = ...
    ttest2(cell2mat(table2cell(pi2hatHighHelpful)), cell2mat(table2cell(pi2hatHighMisleading)));
MainResults.high.pi2hat_r.p           = p;
MainResults.high.pi2hat_r.pBonf       = p*2;

display_substruct(MainResults);
end
