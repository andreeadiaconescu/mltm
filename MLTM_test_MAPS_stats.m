function MLTM_test_MAPS_stats(options)

% MLTM_test_MAPS_stats        computes all MAP stats
%
% 
% Dependent Variables
[zeta]                 = MLTM_load_zeta(options);
[perceptualParameters] = MLTM_load_parameters(options);
%% compute stats
% ~ ~ kappa card ~ ~ ~ ~
kappa_card = perceptualParameters(:,1);

[BehavTable1]     = MLTM_get_table(kappa_card,options);
[p, tbl, stats, terms] = anovan(...
    kappa_card, ...
    {BehavTable1.condition, BehavTable1.group}, ...
    'model','interaction', ...
    'varnames', {'condition', 'group'}, ...
    'display','off');

ANOVAKappa = tbl;  %InPaper

% ~ ~ zeta ~ ~ ~ ~
zeta_parameter = log(zeta(:,1));
[BehavTable2]     = MLTM_get_table(zeta_parameter,options);

[p,tbl,stats,terms] = anovan(...
    zeta_parameter,...
    {BehavTable2.condition,BehavTable2.group},...
    'model', 'interaction', ...
    'varnames', {'condition', 'group'}, ...
    'display','off');
ANOVAZeta = tbl;  %InPaper

%% make ANOVA tables
ANOVAKappaTbl = cell2table(ANOVAKappa(2:end,:),...
                        'VariableNames',{'Kappa_Card','SumSq1',...
                        'df','Singular1','MeanSq1','F1','PValue1'});
disp(ANOVAKappaTbl);

ANOVAZetaTbl = cell2table(ANOVAZeta(2:end,:),...
                     'VariableNames',{'Zeta','SumSq3',...
                     'df3','Singular3','MeanSq3','F3','PValue3'});
disp(ANOVAZetaTbl);

%% prepate data for ttests
sortbyCondition         = sortrows(BehavTable1,2);

sortbygroupHelpful      = sortrows(sortbyCondition([1:19],:),3);
ConditionHelpfulLow     = sortbygroupHelpful([11:19],1);
ConditionHelpfulHigh    = sortbygroupHelpful([1:10],1);

sortbygroupMisleading   = sortrows(sortbyCondition([20:end],:),3);
ConditionMisleadingLow  = sortbygroupMisleading([9:17],1);
ConditionMisleadingHigh = sortbygroupMisleading([1:8],1);


% ~ ~ kappa_r in Group 1 ~ ~ ~ ~
KappaLowHelpful     = ConditionHelpfulLow;
KappaLowMisleading  = ConditionMisleadingLow;

% ~ ~ kappa_r in Group 2 ~ ~ ~ ~
KappaHighHelpful    = ConditionHelpfulHigh;
KappaHighMisleading = ConditionMisleadingHigh;

sortbyCondition         = sortrows(BehavTable2,2);

sortbygroupHelpful      = sortrows(sortbyCondition([1:19],:),3);
ConditionHelpfulLow     = sortbygroupHelpful([11:19],1);
ConditionHelpfulHigh    = sortbygroupHelpful([1:10],1);

sortbygroupMisleading   = sortrows(sortbyCondition([20:end],:),3);
ConditionMisleadingLow  = sortbygroupMisleading([9:17],1);
ConditionMisleadingHigh = sortbygroupMisleading([1:8],1);


% ~ ~ zeta in Group 1 ~ ~ ~ ~
ZetaLowHelpful     = ConditionHelpfulLow;
ZetaLowMisleading  = ConditionMisleadingLow;

% ~ ~ zeta in Group 2 ~ ~ ~ ~
ZetaHighHelpful    = ConditionHelpfulHigh;
ZetaHighMisleading = ConditionMisleadingHigh;


%% compute post-hoc ttests reported in paper
% ~ ~ kappa_r ~ ~ ~ ~
[h,p,ci,MainResults.low.kappa_r]     = ...
    ttest2(cell2mat(table2cell(KappaLowHelpful)), cell2mat(table2cell(KappaLowMisleading)));
MainResults.low.kappa_r.p            = p;
MainResults.low.kappa_r.pBonf        = p*2;

[h,p,ci,MainResults.high.kappa_r]    = ...
    ttest2(cell2mat(table2cell(KappaHighHelpful)), cell2mat(table2cell(KappaHighMisleading)));
MainResults.high.kappa_r.p           = p;
MainResults.high.kappa_r.pBonf       = p*2;


% ~ ~ zeta ~ ~ ~ ~
[h,p,ci,MainResults.low.zeta]     = ...
    ttest2(cell2mat(table2cell(ZetaLowHelpful)), cell2mat(table2cell(ZetaLowMisleading)));
MainResults.low.zeta.p            = p;
MainResults.low.zeta.pBonf        = p*2;

[h,p,ci,MainResults.high.zeta]    = ...
    ttest2(cell2mat(table2cell(ZetaHighHelpful)), cell2mat(table2cell(ZetaHighMisleading)));
MainResults.high.zeta.p           = p;
MainResults.high.zeta.pBonf       = p*2;

display_substruct(MainResults);
end
