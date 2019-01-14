function MLTM_load_behav_subject(options)

subjAll = options.subjects;

for  i = 1:length(subjAll)
    sprintf('%s',subjAll{i})
    subjFileName = ['out_', subjAll{i}, '.txt'];
    subjLog = load(fullfile(options.dataroot,subjAll{i},subjFileName));
    
   
    %inputs
    blue_correct         = subjLog(:,5);
    StableCardTrials     = [ones(60,1); zeros(60,1)];
    VolatileCardTrials   = [zeros(60,1); ones(60,1)];
    advice_correct       = subjLog(:,6);
    StableAdviceTrials   = [ones(30,1); zeros(40,1);ones(50,1)];
    VolatileAdviceTrials = [zeros(30,1); ones(40,1);zeros(50,1)];
    blue_value           = subjLog(:,3);
    green_value          = subjLog(:,4);
    
    % phases (based on inputs)
    card_stable    = sum(blue_correct.*StableCardTrials);
    card_volatile  = sum(blue_correct.*VolatileCardTrials);
    advice_stable  = sum(advice_correct.*StableAdviceTrials);
    advice_volatile= sum(advice_correct.*VolatileAdviceTrials);
    
    % Responses
    responses        = subjLog(:,9); % responses where the subject took the advice.
    remove_zeros_advice_correct = (advice_correct(:,1)+ones(size(responses)).*5)./6;
    take_Helpful     = (responses==remove_zeros_advice_correct); % responses where the subject took the advice.
    remove_ones_advice_correct  = (advice_correct(:,1)+ones(size(advice_correct)).*6)./6;
    remove_ones_y    = (responses(:,1)+ones(size(responses)).*5)./5;
    invert_responses =  remove_ones_y == responses+ones(size(responses));       % responses where the subject went against the advice.
    
    % Responses for Phases
    takeAdviceStableCard     = sum(responses.*StableCardTrials)./sum(StableCardTrials);    
    takeAdviceVolatileCard   = sum(responses.*VolatileCardTrials)./sum(VolatileCardTrials);
    takeAdviceStableAdvice   = sum(responses.*StableAdviceTrials)./sum(StableAdviceTrials);
    takeAdviceVolatileAdvice = sum(responses.*VolatileAdviceTrials)./sum(VolatileAdviceTrials);
    
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
    
 for k= 1:length(blue_correct)
        if gaze_congruency(k,:) == 1  % if gaze looks to blue card
            expr_gaze(k,:)=blue_value(k,:); % expected reward if follow gaze
            expr_nogaze(k,:)=green_value(k,:); % expected reward if not follow gaze
        elseif gaze_congruency(k,:) == 0 % if gaze looks to green card
            expr_gaze(k,:)=green_value(k,:);
            expr_nogaze(k,:)=blue_value(k,:);
        end
 end
    
    averageReward_when_follow_gaze = mean(expr_gaze.*responses);
    averageReward_when_Notfollow_gaze = mean(expr_nogaze.*invert_responses);
    
    responses(responses==-1) = NaN;
    adviceTaken = nansum((responses))./size(responses,1);
    behav_var = [];
    behav_var.adviceTaken = adviceTaken;
    behav_var.takeHelpful = sum(take_Helpful)./sum(advice_correct);
    behav_var.againstIncorrect = sum((remove_ones_y==remove_ones_advice_correct))./(size(responses,1)-sum(advice_correct(:,1)));
    behav_var.averageReward_when_follow_gaze = averageReward_when_follow_gaze;
    behav_var.averageReward_when_Notfollow_gaze = averageReward_when_Notfollow_gaze;
    behav_var.card_stable = card_stable;
    behav_var.card_volatile = card_volatile;
    behav_var.advice_stable = advice_stable;
    behav_var.advice_volatile = advice_volatile;
    behav_var.takeAdviceStableCard = takeAdviceStableCard;
    behav_var.takeAdviceVolatileCard = takeAdviceVolatileCard;
    behav_var.takeAdviceStableAdvice = takeAdviceStableAdvice;
    behav_var.takeAdviceVolatileAdvice = takeAdviceVolatileAdvice;
    
    save(fullfile(options.resultroot,[subjAll{i},'behaviour_variables.mat']), 'behav_var','-mat');
    
end