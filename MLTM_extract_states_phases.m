function MLTM_extract_states_phases(options)

subjectsAll = options.subjects;

mltm_states      = cell(numel(subjectsAll), 4);
for  iSubject = 1:length(subjectsAll)
    sprintf('%s',subjectsAll{iSubject})
    tmp = load(fullfile(options.resultroot,[subjectsAll{iSubject},options.model.winningPerceptual, ...
        options.model.winningResponse,'.mat']), 'est_int','-mat');
    
    x_r = tmp.est_int.traj.muhat_r(:,1);  
    x_a = tmp.est_int.traj.muhat_a(:,1);
    ze1 = tmp.est_int.p_obs.ze1;
    
    sa2hat_r = tmp.est_int.traj.sahat_r(:,2);
    sa2hat_a = tmp.est_int.traj.sahat_a(:,2);
    
    pi2hat_r = 1./sa2hat_r;
    pi2hat_a = 1./sa2hat_a;
    
    % Precision (i.e., Fisher information) vectors
    px = 1./(x_a.*(1-x_a));
    pc = 1./(x_r.*(1-x_r));
    
    % Weight vectors
    wx = ze1.*px./(ze1.*px + pc); % precision first level
    wc = pc./(ze1.*px + pc);
    
    mltm_states{iSubject,1} = nanmean(wx.*options.task.stable_card); % stable arbitration
    mltm_states{iSubject,2} = nanmean(wx.*options.task.volatile_card); % volatile arbitration
    mltm_states{iSubject,3} = nanmean(wx.*options.task.chance_card); % stable arbitration
    
    mltm_states{iSubject,4} = nanmean(sa2hat_r.*options.task.stable_card); 
    mltm_states{iSubject,5} = nanmean(sa2hat_r.*options.task.volatile_card);
    mltm_states{iSubject,6} = nanmean(sa2hat_r.*options.task.chance_card);
    
    mltm_states{iSubject,7} = nanmean(sa2hat_a.*options.task.stable_card); 
    mltm_states{iSubject,8} = nanmean(sa2hat_a.*options.task.volatile_card);
    mltm_states{iSubject,9} = nanmean(sa2hat_a.*options.task.chance_card);
    
    mltm_states{iSubject,10} = nanmean(pi2hat_r.*options.task.stable_card); 
    mltm_states{iSubject,11} = nanmean(pi2hat_r.*options.task.volatile_card);
    mltm_states{iSubject,12} = nanmean(pi2hat_r.*options.task.chance_card);
    
    mltm_states{iSubject,13} = nanmean(pi2hat_a.*options.task.stable_card); 
    mltm_states{iSubject,14} = nanmean(pi2hat_a.*options.task.volatile_card);
    mltm_states{iSubject,15} = nanmean(pi2hat_a.*options.task.chance_card);
end
arbitration = [cell2mat(mltm_states(:,[1:3])) ones(size(mltm_states,1),1)];
uncertainty = [cell2mat(mltm_states(:,[4:9])) ones(size(mltm_states,1),1)];
precision   = [cell2mat(mltm_states(:,[10:15])) ones(size(mltm_states,1),1)];

%% Load MAPs
% Load decision to take advice
[advice_taking] = MLTM_load_advice(options);

%% Testing Model Validity
[B,BINT,R,RINT,stats] = regress(advice_taking(:,1),precision);
disp(['GLM with performance accuracy as the dependent variable:'...
' p value  ' ...
num2str(stats(3))]);

[B,BINT,R,RINT,stats] = regress(advice_taking(:,5),arbitration);
disp(['GLM with going with gaze incongruent with card as the dependent variable:'...
' p value  ' ...
num2str(stats(3))]);

[B,BINT,R,RINT,stats] = regress(advice_taking(:,6),arbitration);
disp(['GLM with going against gaze congruent with card as the dependent variable:'...
' p value  ' ...
num2str(stats(3))]);
%% Save as table
ofile=fullfile(options.resultroot,'MLTM_states.xlsx');
xlswrite(ofile, [str2num(cell2mat(options.subjects')) [cell2mat(mltm_states)]]);

columnNames = [{'subjectIds','arbitration_stable','arbitration_volatile', 'arbitration_chance',...
                'sa2hat_r_stable','sa2hat_r_volatile','sa2hat_r_chance',...
                'sa2hat_a_stable','sa2hat_a_volatile','sa2hat_a_chance',...
                'pi2hat_r_stable','pi2hat_r_volatile','pi2hat_r_chance',...
                'pi2hat_a_stable','pi2hat_a_volatile','pi2hat_a_chance'}];
t = array2table([subjectsAll' num2cell([cell2mat(mltm_states)])], ...
    'VariableNames', columnNames);
writetable(t, ofile);
end