function [IA_variable]     = MLTM_get_table(current_var,options)

% load data
[~,~,txt] = xlsread(options.groups,'data');

% Independent Variables
group      = txt(2:end,3);
condition  = txt(2:end,2);


IA_variable = table(current_var,condition,group);
IA_variable.group = nominal(IA_variable.group);
IA_variable.condition = nominal(IA_variable.condition);

end