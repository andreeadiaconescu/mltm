function MLTM_load_behav_subject(options)

subjAll = options.subjects;

for  i = 1:length(subjAll)
    sprintf('%s',subjAll{i})
    subjFileName = ['out_', subjAll{i}, '.txt'];
    subjLog = load(fullfile(options.dataroot,subjAll{i},subjFileName));
    
    
    % Gather inputs
    blue_correct         = subjLog(:,5);
    green_correct        = ones(size(blue_correct))-blue_correct;
    advice_correct       = subjLog(:,6);
    advice_incorrect     = ones(size(advice_correct))- subjLog(:,6);
    blue_value           = subjLog(:,3);
    green_value          = subjLog(:,4);
    
    go_with_gaze         = subjLog(:,9); % responses where the subject took the advice.
    iInvalidTrial        = (go_with_gaze==-1);
    remove_ones_advice_correct ...
        = (advice_correct(:,1)+ones(size(advice_correct)).*6)./6;
    remove_zeros_advice_correct...
        = (advice_correct(:,1)+ones(size(advice_correct)).*5)./6;
    remove_zeros_advice_incorrect...
        = (advice_incorrect(:,1)+ones(size(advice_incorrect)).*5)./6;
    remove_ones_y        = (go_with_gaze(:,1)+ones(size(go_with_gaze)).*5)./5;
    go_against_gaze      = ones(size(go_with_gaze))- go_with_gaze;       % responses where the subject went against the advice.
    
    % Transform inputs
    responses            = go_with_gaze;
    input                = advice_correct;
    
    totalResponses       = sum(isfinite(responses)); % total number of valid responses
    followResponses      = nansum(responses); % total number of responses where gaze followed
    
    followvol            = nansum(responses(31:70,:)); % gaze followed in volatile phase
    totalvol             = sum(isfinite(responses(31:70,:))); % total number of responses in volatile phase
    followstable         = nansum(responses([1:30 71:120]));
    totalstable          = sum(isfinite(responses([1:30 71:120])));
    
    
    advice_taken_all     = followResponses * 100 / totalResponses;
    advice_taken_vol     = followvol * 100 / totalvol;
    advice_taken_stable  = followstable * 100 / totalstable;
    
    if input(1,1) == 1 % subject received helpfulfirst-schedule
        followstablehelpful  = nansum(responses(1:30,:));
        totalstablehelpful   = sum(isfinite(responses(1:30,:)));
        advice_taken_stablehelpful...
            = followstablehelpful * 100 /  totalstablehelpful;
        
        followstablemislead  = nansum(responses(71:120,:));
        totalstablemislead   = sum(isfinite(responses(71:120,:)));
        advice_taken_stablemisleading...
            = followstablemislead * 100 / totalstablemislead;
        
        follow_vol_highacc   = nansum(responses([41:50 61:70]));
        total_volhighacc     = sum(isfinite(responses([41:50 61:70])));
        advice_taken_volhighacc...
            = follow_vol_highacc * 100 /  total_volhighacc;
        
        follow_vol_lowacc    = nansum(responses([31:40 51:60]));
        total_vollowacc      = sum(isfinite(responses([31:40 51:60])));
        advice_taken_vol_lowacc...
            = follow_vol_lowacc * 100 /  total_vollowacc;
        
    elseif input(1,1) == 0 % subject received misleadingfirst-schedule
        followstablehelpful  = nansum(responses(71:120,:));
        totalstablehelpful   = sum(isfinite(responses(71:120,:)));
        advice_taken_stablehelpful...
            = followstablehelpful * 100 /  totalstablehelpful;
        followstablemislead  = nansum(responses(1:30,:));
        totalstablemislead   = sum(isfinite(responses(1:30,:)));
        advice_taken_stablemisleading...
            = followstablemislead * 100 / totalstablemislead;
        
        follow_vol_highacc   = nansum(responses([31:40 51:60]));
        total_volhighacc     = sum(isfinite(responses([31:40 51:60])));
        advice_taken_volhighacc...
            = follow_vol_highacc * 100 /  total_volhighacc;
        follow_vol_lowacc    = nansum(responses([41:50 61:70]));
        total_vollowacc      = sum(isfinite(responses([41:50 61:70])));
        advice_taken_vol_lowacc...
            = follow_vol_lowacc * 100 /  total_vollowacc;
    end
    
    
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
    
    go_with_gaze_correctly = double(go_with_gaze==advice_correct);
    
    go_with_gaze_incorrect = double(go_with_gaze==remove_zeros_advice_incorrect);
                       
    go_with_gaze_incorrect_freq...
                           = nansum((go_with_gaze_incorrect))/nansum(go_with_gaze);
                         
    go_against_gaze_correct   = double(go_against_gaze==remove_zeros_advice_correct);
    go_against_gaze_correct_freq...
                             = nansum((go_against_gaze_correct))/nansum(go_against_gaze);
    
    % Account for misses
    go_with_gaze(iInvalidTrial)    = NaN; % missed trials
    go_against_gaze(iInvalidTrial) = NaN;
    go_with_gaze_correctly(iInvalidTrial) ...
                                   = NaN;
    
    performance_accuracy           = nansum(go_with_gaze_correctly)/size(go_with_gaze,1);
    totalScore                     = subjLog(size(go_with_gaze,1),end);
    
    
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
    
    averageReward_when_follow_gaze    = nanmean(expr_gaze.*go_with_gaze);
    averageReward_when_Notfollow_gaze = nanmean(expr_nogaze.*go_against_gaze);
    
    behav_var = [];
    behav_var.performance_accuracy = performance_accuracy;
    behav_var.totalScore           = totalScore;
    behav_var.go_with_gaze_incorrect_freq...
                                   = go_with_gaze_incorrect_freq;
    behav_var.go_against_gaze_correct_freq...
                                   = go_against_gaze_correct_freq;
    
    behav_var.averageReward_when_follow_gaze ...
                                   = averageReward_when_follow_gaze;
    behav_var.averageReward_when_Notfollow_gaze ...
                                   = averageReward_when_Notfollow_gaze;
    
    behav_var.takeAdviceStableCard = takeAdviceStableCard;
    behav_var.takeAdviceVolatileCard...
                                   = takeAdviceVolatileCard;
    behav_var.advice_taken_all     = advice_taken_all;
    behav_var.advice_taken_vol     = advice_taken_vol;
    behav_var.advice_taken_stable  = advice_taken_stable;
    behav_var.advice_taken_stablehelpful...
                                   = advice_taken_stablehelpful;
    behav_var.advice_taken_stablemisleading...
                                   = advice_taken_stablemisleading;
    behav_var.advice_taken_volhighacc...
                                   = advice_taken_volhighacc;
    behav_var.advice_taken_vol_lowacc...
                                   = advice_taken_vol_lowacc;
    
    save(fullfile(options.resultroot,[subjAll{i},'behaviour_variables.mat']), 'behav_var','-mat');
    
end