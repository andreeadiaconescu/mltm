function [zeta] = MLTM_load_zeta(options)

subjectsAll = options.subjects;
mltm_zeta      = cell(numel(subjectsAll), 1);
for  iSubject = 1:length(subjectsAll)
    sprintf('%s',subjectsAll{iSubject})
    tmp = load(fullfile(options.resultroot,[subjectsAll{iSubject},options.model.perceptualModels{1}, ...
                options.model.responseModels{1},'.mat']), 'est_int','-mat');
    
    mltm_zeta{iSubject,1} = tmp.est_int.p_obs.ze1;
    
end
zeta = cell2mat(mltm_zeta);

end