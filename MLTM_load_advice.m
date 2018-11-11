function [advice_taking] = MLTM_load_advice(options,subjectsAll)

for  iSubject = length(subjectsAll)
    sprintf('%s',subjectsAll{iSubject})
    tmp = load(fullfile(options.resultroot,[subjectsAll{iSubject},options.model.perceptualModels{1}, ...
        options.model.responseModels{1},'.mat']), 'est_int','-mat');
    advice{iSubject,1} = tmp.est_int.adviceTaken;
end

advice_taking = cell2mat(advice);

end