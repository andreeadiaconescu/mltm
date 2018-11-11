function MLTM_invert_subject(options)

responseModels   = options.model.responseModels;
perceptualModels = options.model.perceptualModels;

subjAll = options.subjects;

for  i = 1:length(subjAll)
    for iRsp=1:numel(responseModels)
        for iPrp=1:numel(perceptualModels)
            sprintf('%s',subjAll{i})
            subjFileName = ['out_', subjAll{i}, '.txt'];
            subjLog = load(fullfile(options.dataroot,subjAll{i},subjFileName));
            responses = subjLog(:,9); % responses where the subject took the advice.
            blue_value=subjLog(:,3);
            green_value=subjLog(:,4);
            responses(responses==-1) = NaN;
            inputs = [subjLog(:,5) subjLog(:,6) blue_value green_value];
            est_int = fitModel(responses, inputs,options.model.perceptualModels{iPrp},options.model.responseModels{iRsp});
            est_int.adviceTaken = adviceTaken;
            hgf_plotTraj_reward_social(est_int);
            cd(options.resultroot)
            mkdir(options.resultroot, subjAll{i});
            save(fullfile(options.resultroot,[subjAll{i},options.model.perceptualModels{iPrp}, ...
                options.model.responseModels{iRsp},'.mat']), 'est_int','-mat');
        end
    end
end