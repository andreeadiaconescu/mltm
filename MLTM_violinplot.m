function MLTM_violinplot(current_var,condition,group,currentMAP)
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
y = cell2mat(table2cell(ConditionMisleadingLow));
z = cell2mat(table2cell(ConditionHelpfulHigh));
t = cell2mat(table2cell(ConditionMisleadingHigh));

p = anovan(current_var,{IA_variable.group IA_variable.condition},...
    'model','interaction','varnames',{'Group','Frame'});

VariablestoPlot = {x y z t};
GroupstoPlot    = {ones(length(x), 1), 2*ones(length(y), 1), 3*ones(length(z), 1),4*ones(length(t), 1)};

GroupingVariables = {'Congruent Low AQ','Incongruent Low AQ',...
    'Congruent High AQ','Incongruent High AQ'};

figure;

H   = VariablestoPlot;
N=numel(VariablestoPlot);

switch currentMAP
    case 'kappa_r'
        colors=winter(numel(H));
        label = '\kappa_r';
    case 'zeta'
        colors=cool(numel(H));
        label = '\zeta';
    case 'pi_2'
        colors=copper(numel(H));
        label = '\pi_2';
end
for i=1:N
    e = notBoxPlot(cell2mat(H(i)),cell2mat(GroupstoPlot(i)),'markMedian',true);
    set(e.data,'MarkerSize', 10);
    if i == 2 || i == 4
        set(e.data,'Marker','o');
        set(e.data,'Marker','o');
    end
    if i==1, hold on, end
    set(e.data,'Color',colors(i,:))
    set(e.sdPtch,'FaceColor',colors(i,:));
    set(e.semPtch,'FaceColor',[0.9 0.9 0.9]);
end
set(gca,'XTick',1:N)
% set(gca,'XTickLabel',GroupingVariables);
set(gca,'FontName','Times New Roman','FontSize',40);
ylabel(label);
end

