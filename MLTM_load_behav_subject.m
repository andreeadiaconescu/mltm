function MLTM_load_behav_subject(options)

subjAll = options.subjects;

for  i = 1:length(subjAll)
    sprintf('%s',subjAll{i})
    subjFileName = ['out_', subjAll{i}, '.txt'];
    subjLog = load(fullfile(options.dataroot,subjAll{i},subjFileName));
    
   
    %inputs
    blue_correct         = subjLog(:,5);
    green_correct        = ones(size(blue_correct))-blue_correct;
    advice_correct       = subjLog(:,6);
    advice_incorrect     = ones(size(advice_correct))- subjLog(:,6);
    blue_value           = subjLog(:,3);
    green_value          = subjLog(:,4);
    
    go_with_gaze         = subjLog(:,9); % responses where the subject took the advice.
    iInvalidTrial        = (go_with_gaze==-1);
    remove_ones_advice_correct  = (advice_correct(:,1)+ones(size(advice_correct)).*6)./6;
    remove_ones_y        = (go_with_gaze(:,1)+ones(size(go_with_gaze)).*5)./5;
    go_against_gaze      =  double(remove_ones_y == go_with_gaze+ones(size(go_with_gaze)));       % responses where the subject went against the advice.
    go_with_gaze_correct = double(go_with_gaze==advice_correct);
   
    
    for k= 1:length(blue_correct)
        if blue_correct(k,:)== 1 && advice_correct(k,:)==1
            gaze_congruency(k,1) = 1;
        elseif blue_correct(k,:)== 1 && advice_correct(k,:)==0
            gaze_congruency(k,1) = 0;
        elseif blue_correct(k,:)== 0 && advice_correct(k,:)==1
            gaze_congruency(k,1) = 0;
        elseif blue_correct(k,:)== 0 && advice_correct(k,:)==0
            gaze_congruency(k,1) = 1;
        end
    end
    
    gaze_incongruency = ones(size(gaze_congruency))-gaze_congruency;
    remove_zeros_congruency= (gaze_congruency(:,1)+ones(size(gaze_congruency)).*5)./6;
    remove_zeros_incongruency= (gaze_incongruency(:,1)+ones(size(gaze_incongruency)).*5)./6;
    
    go_with_gaze_incongruent    = double(go_with_gaze==remove_zeros_incongruency);
    go_against_gaze_congruent = double(go_against_gaze == remove_zeros_congruency);
    
    % Account for misses
    go_with_gaze(iInvalidTrial)    = NaN; % missed trials
    go_against_gaze(iInvalidTrial) = NaN;
    go_with_gaze_correct(iInvalidTrial) = NaN;
    go_with_gaze_incongruent(iInvalidTrial) = NaN;
    go_against_gaze_congruent(iInvalidTrial) = NaN;
    
    
    go_with_gaze_freq           = nansum((go_with_gaze))/size(go_with_gaze,1);
    go_against_gaze_freq        = nansum(go_against_gaze)/size(go_with_gaze,1);
    
    performance_accuracy        = nansum(go_with_gaze_correct)/size(go_with_gaze,1);
    totalScore                  = subjLog(size(go_with_gaze,1),end);
    go_with_gaze_incongruent_freq = nansum(go_with_gaze_incongruent)/size(go_with_gaze,1);
    go_against_gaze_congruent_freq = nansum(go_against_gaze_congruent)/size(go_with_gaze,1);
    
    
    StableCardTrials     = [ones(60,1); zeros(60,1)];
    VolatileCardTrials   = [zeros(60,1); ones(60,1)];
    
    % Responses for Phases
    takeAdviceStableCard     = nansum(go_with_gaze.*StableCardTrials)./sum(StableCardTrials);    
    takeAdviceVolatileCard   = nansum(go_with_gaze.*VolatileCardTrials)./sum(VolatileCardTrials);
    
    
    
 for k= 1:length(blue_correct)
        if gaze_congruency(k,:) == 1  % if gaze looks to blue card
            expr_gaze(k,:)=blue_value(k,:); % expected reward if follow gaze
            expr_nogaze(k,:)=green_value(k,:); % expected reward if not follow gaze
        elseif gaze_congruency(k,:) == 0 % if gaze looks to green card
            expr_gaze(k,:)=green_value(k,:);
            expr_nogaze(k,:)=blue_value(k,:);
        end
 end
    
    averageReward_when_follow_gaze    = mean(expr_gaze.*go_with_gaze);
    averageReward_when_Notfollow_gaze = mean(expr_nogaze.*go_against_gaze);
    
    behav_var = [];
    behav_var.performance_accuracy = performance_accuracy;
    behav_var.totalScore           = totalScore;
    behav_var.go_with_gaze_freq    = go_with_gaze_freq;
    behav_var.go_against_gaze_freq = go_against_gaze_freq;
    behav_var.go_with_gaze_incongruent_freq = go_with_gaze_incongruent_freq;
    behav_var.go_against_gaze_congruent_freq = go_against_gaze_congruent_freq;
    
    behav_var.averageReward_when_follow_gaze = averageReward_when_follow_gaze;
    behav_var.averageReward_when_Notfollow_gaze = averageReward_when_Notfollow_gaze;
    
    behav_var.takeAdviceStableCard = takeAdviceStableCard;
    behav_var.takeAdviceVolatileCard = takeAdviceVolatileCard;
    
    save(fullfile(options.resultroot,[subjAll{i},'behaviour_variables.mat']), 'behav_var','-mat');
    
end