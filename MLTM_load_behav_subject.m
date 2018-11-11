function MLTM_load_behav_subject(options)

subjAll = options.subjects;

for  i = 1:length(subjAll)
    sprintf('%s',subjAll{i})
    subjFileName = ['out_', subjAll{i}, '.txt'];
    subjLog = load(fullfile(options.dataroot,subjAll{i},subjFileName));
    responses = subjLog(:,9); % responses where the subject took the advice.
    %inputs
    blue_correct = subjLog(:,5);
    advice_correct = subjLog(:,6);
    blue_value=subjLog(:,3);
    green_value=subjLog(:,4);
    
    for k= 1:length(blue_correct)
        if blue_correct(k,:)== 1 && advice_correct(k,:)==1
            gaze(k,1)=1;
        elseif blue_correct(k,:)== 1 && advice_correct(k,:)==0
            gaze(k,1)=0;
        elseif blue_correct(k,:)== 0 && advice_correct(k,:)==1
            gaze(k,1)=0;
        elseif blue_correct(k,:)== 0 && advice_correct(k,:)==0
            gaze(k,1)=1;
        end
    end
    
    for k= 1:length(blue_correct)
        if gaze(k,:) == 1  % if gaze looks to blue card
            expr_gaze(k,:)=blue_value(k,:); % expected reward if follow gaze
            expr_nogaze(k,:)=green_value(k,:); % expected reward if not follow gaze
        elseif gaze(k,:) == 0 % if gaze looks to green card
            expr_gaze(k,:)=green_value(k,:);
            expr_nogaze(k,:)=blue_value(k,:);
        end
    end
    
    
    responses(responses==-1) = NaN;
    adviceTaken = sum((responses))./size(responses);
    behav_var = [];
    behav_var.adviceTaken = adviceTaken;
    save(fullfile(options.resultroot,[subjAll{i},'behaviour_variables.mat']), ' behav_var','-mat');
    
end