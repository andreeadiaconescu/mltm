function MLTM_phases_per_condition(options)

subjectsAll       = options.subjects;
subjectsCong      = sort(options.subjects_by_gaze.congruent);
subjectsIncong    = setdiff(subjectsAll,subjectsCong);

mltm_states_congruent      = cell(numel(subjectsCong), 5);
for  iSubject = 1:length(subjectsCong)
    sprintf('%s',subjectsCong{iSubject})
    tmp = load(fullfile(options.resultroot,[subjectsCong{iSubject},options.model.winningPerceptual, ...
        options.model.winningResponse,'.mat']), 'est_int','-mat');
    
    x_r = tmp.est_int.traj.muhat_r(:,1);  
    x_a = tmp.est_int.traj.muhat_a(:,1);
    ze1 = tmp.est_int.p_obs.ze1;
    
    advice = tmp.est_int.y;
    
    % Precision (i.e., Fisher information) vectors
    px = 1./(x_a.*(1-x_a));
    pc = 1./(x_r.*(1-x_r));
    
    % Weight vectors
    wx = ze1.*px./(ze1.*px + pc); % precision first level
    wc = pc./(ze1.*px + pc);
    
    mltm_states_congruent{iSubject,1} = nanmean(wx.*options.task.congruent.first); % first trials arbitration
    mltm_states_congruent{iSubject,2} = nanmean(wx.*options.task.congruent.second); % last trials arbitration
    mltm_states_congruent{iSubject,3} = nanmean(wx.*options.task.congruent_volatility); 
    mltm_states_congruent{iSubject,4} = nanmean(wx.*options.task.incongruent_volatility); 
    mltm_states_congruent{iSubject,5} = tmp.est_int.p_obs.ze1; 
    mltm_states_congruent{iSubject,6} = nansum(advice.*options.task.congruent.first)./nansum(options.task.congruent.first); % first trials arbitration
    mltm_states_congruent{iSubject,7} = nansum(advice.*options.task.congruent.second)./nansum(options.task.congruent.second);
    mltm_states_congruent{iSubject,8} = nansum(advice.*options.task.congruent_volatility)./nansum(options.task.congruent_volatility); % first trials arbitration
    mltm_states_congruent{iSubject,9} = nansum(advice.*options.task.incongruent_volatility)./nansum(options.task.incongruent_volatility);
end

states_congruent = [cell2mat(mltm_states_congruent(:,[1:4 6 7])) ones(size(mltm_states_congruent,1),1)];
zetaCongr        = log(cell2mat(mltm_states_congruent(:,5)));

[B,BINT,R,RINT,stats] = regress(zetaCongr,states_congruent);
disp(['GLM with performance accuracy as the dependent variable:'...
' p value  ' ...
num2str(stats(3))]);

s = MLTM_scatter1(zetaCongr,states_congruent(:,1), 100,'c');
title('Predicting Arbitration from Zeta');
s.LineWidth = 0.6;
s.MarkerFaceColor = [0 0.5 0.5];
hold on; scatter(zetaCongr,states_congruent(:,2), 100,'m');
scatter(zetaCongr,states_congruent(:,3), 100,'g');
scatter(zetaCongr,states_congruent(:,4), 100,'k');

% 
groupCongr = {'Low' 'High' 'Low' 'High' 'Low' 'High' 'Low',...
              'Low' 'High' 'Low' 'Low' 'Low' 'High' 'High',...
              'High' 'High' 'High' 'High' 'Low'};
figure; gscatter(zetaCongr,states_congruent(:,1),groupCongr');
hold on; gscatter(zetaCongr,states_congruent(:,2),groupCongr');
gscatter(zetaCongr,states_congruent(:,3), groupCongr');
gscatter(zetaCongr,states_congruent(:,4), groupCongr');


mltm_states_incongruent      = cell(numel(subjectsIncong), 7);
for  iSubject = 1:length(subjectsIncong)
    sprintf('%s',subjectsIncong{iSubject})
    tmp = load(fullfile(options.resultroot,[subjectsIncong{iSubject},options.model.winningPerceptual, ...
        options.model.winningResponse,'.mat']), 'est_int','-mat');
    
    x_r = tmp.est_int.traj.muhat_r(:,1);  
    x_a = tmp.est_int.traj.muhat_a(:,1);
    ze1 = tmp.est_int.p_obs.ze1;
    
    % Precision (i.e., Fisher information) vectors
    px = 1./(x_a.*(1-x_a));
    pc = 1./(x_r.*(1-x_r));
    
    % Weight vectors
    wx = ze1.*px./(ze1.*px + pc); % precision first level
    wc = pc./(ze1.*px + pc);
    
    advice = tmp.est_int.y;
    
    mltm_states_incongruent{iSubject,1} = nanmean(wx.*options.task.congruent.first); % first trials arbitration
    mltm_states_incongruent{iSubject,2} = nanmean(wx.*options.task.congruent.second); % last trials arbitration
    mltm_states_incongruent{iSubject,3} = nanmean(wx.*options.task.congruent_volatility); 
    mltm_states_incongruent{iSubject,4} = nanmean(wx.*options.task.incongruent_volatility); 
    mltm_states_incongruent{iSubject,5} = tmp.est_int.p_obs.ze1; 
    mltm_states_incongruent{iSubject,6} = nansum(advice.*options.task.congruent.first)./nansum(options.task.congruent.first); % first trials arbitration
    mltm_states_incongruent{iSubject,7} = nansum(advice.*options.task.congruent.second)./nansum(options.task.congruent.second); % last trials arbitration
    mltm_states_incongruent{iSubject,8} = nansum(advice.*options.task.congruent_volatility)./nansum(options.task.congruent_volatility); % first trials arbitration
    mltm_states_incongruent{iSubject,9} = nansum(advice.*options.task.incongruent_volatility)./nansum(options.task.incongruent_volatility);
end


states_incongruent = [cell2mat(mltm_states_incongruent(:,[1:4 6 7])) ones(size(mltm_states_incongruent,1),1)];
zetaIncongr        = log(cell2mat(mltm_states_incongruent(:,5)));

[B,BINT,R,RINT,stats] = regress(zetaIncongr,states_incongruent);
disp(['GLM with performance accuracy as the dependent variable:'...
' p value  ' ...
num2str(stats(3))]);

s = MLTM_scatter1(zetaIncongr,states_incongruent(:,1), 100,'b');
title('Predicting Arbitration from Zeta');
s.LineWidth = 0.6;
s.MarkerFaceColor = [0 0.5 0.5];
hold on; scatter(zetaIncongr,states_incongruent(:,2), 100,'r');
scatter(zetaIncongr,states_incongruent(:,3), 100,'g');
scatter(zetaIncongr,states_incongruent(:,4), 100,'k');

subjectsIncong;

groupIncong = {'High' 'High' 'High' 'Low' 'Low' 'Low' 'High' 'Low',...
               'Low' 'Low' 'Low' 'High' 'High' 'Low' 'High' 'Low',...
               'High'};
figure; gscatter(zetaIncongr,states_incongruent(:,1),groupIncong');
hold on; gscatter(zetaIncongr,states_incongruent(:,2),groupIncong');
gscatter(zetaIncongr,states_incongruent(:,3), groupIncong');
gscatter(zetaIncongr,states_incongruent(:,4), groupIncong');

end