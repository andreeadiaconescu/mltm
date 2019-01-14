function MLTM_invert_subject(options)

subjAll = options.subjects;

% pairs of perceptual and response model
iCombPercResp = zeros(2*4,2);
iCombPercResp(1:2,1)    = 1:2;
iCombPercResp(3:4,1)    = 1:2;
iCombPercResp(5:6,1)    = 1:2;
iCombPercResp(7:8,1)    = 1:2;
iCombPercResp(1:2,2)    = 1;
iCombPercResp(3:4,2)    = 2;
iCombPercResp(5:6,2)    = 3;
iCombPercResp(7:8,2)    = 4;

nModels = size(iCombPercResp,1);

for  i = 1:length(subjAll)
    for iModel = 1:nModels
        sprintf('%s',subjAll{i})
        subjFileName = ['out_', subjAll{i}, '.txt'];
        subjLog = load(fullfile(options.dataroot,subjAll{i},subjFileName));
        responses  = subjLog(:,9); % responses where the subject took the advice.
        blue_value = subjLog(:,3);
        green_value= subjLog(:,4);
        responses(responses==-1) = NaN;
        inputs = [subjLog(:,5) subjLog(:,6) blue_value green_value];
        est_int = fitModel(responses, inputs, options.model.perceptualModels{iCombPercResp(iModel,1)},...
            options.model.responseModels{iCombPercResp(iModel,2)});
        save(fullfile(options.resultroot,[subjAll{i},options.model.perceptualModels{iCombPercResp(iModel,1)},...
            options.model.responseModels{iCombPercResp(iModel,2)},'.mat']), 'est_int','-mat');
    end
end