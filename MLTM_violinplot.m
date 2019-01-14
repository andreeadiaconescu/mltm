function [vs] = MLTM_violinplot(current_var,condition,group)
IA_variable = table(current_var,condition,group);
IA_variable.group = nominal(IA_variable.group);
IA_variable.condition = nominal(IA_variable.condition);

sortbyframe           = sortrows(IA_variable,2);
sortbygroupFrameA     = sortrows(sortbyframe([1:19],:),3);
ConditionHelpfulLow   = sortbygroupFrameA([11:19],1);
ConditionHelpfulHigh  = sortbygroupFrameA([1:10],1);

sortbygroupFrameB        = sortrows(sortbyframe([20:end],:),3);
ConditionMisleadingLow   = sortbygroupFrameB([9:17],1);
ConditionMisleadingHigh  = sortbygroupFrameB([1:8],1);

figure; 
subplot(2,2,1); violinplot(ConditionHelpfulLow);
subplot(2,2,2); violinplot(ConditionHelpfulHigh);
subplot(2,2,3); violinplot(ConditionMisleadingLow);
subplot(2,2,4); violinplot(ConditionMisleadingHigh);

x = cell2mat(table2cell(ConditionHelpfulLow));
y = cell2mat(table2cell(ConditionHelpfulHigh));
z = cell2mat(table2cell(ConditionMisleadingLow));
t = cell2mat(table2cell(ConditionMisleadingHigh));

Variables = [x; y; z; t];
Groups    = [ones(length(x), 1); 2*ones(length(y), 1); 3*ones(length(z), 1);4*ones(length(t), 1)];
p = anovan(current_var,{IA_variable.group IA_variable.condition},...
    'model','interaction','varnames',{'Group','Frame'});
figure; vs = violinplot(Variables, Groups);

end