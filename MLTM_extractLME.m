function [models] = MLTM_extractLME(options,subjAll)

% % pairs of perceptual and response model
iCombPercResp = zeros(2*4,2);
iCombPercResp(1:4,1)    = 1;
iCombPercResp(5:8,1)    = 2;
iCombPercResp(1:4,2)    = 1:4;
iCombPercResp(5:8,2)    = 1:4;

nModels = size(iCombPercResp,1);

models_mltm = cell(numel(subjAll), nModels);

for  iSubject = 1:length(subjAll)
    sprintf('%s',subjAll{iSubject})
    for iModel = 1:nModels
        tmp = load(fullfile(options.resultroot,[subjAll{iSubject},options.model.perceptualModels{iCombPercResp(iModel,1)}, ...
            options.model.responseModels{iCombPercResp(iModel,2)},'.mat']), 'est_int','-mat');
        models_mltm{iSubject,iModel} = tmp.est_int.F;
    end
end

models = cell2mat(models_mltm);

end