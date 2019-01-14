function [zeta] = MLTM_load_zeta(options)

subjectsAll = options.subjects;
mltm_zeta      = cell(numel(subjectsAll), 1);
for  iSubject = 1:length(subjectsAll)
    sprintf('%s',subjectsAll{iSubject})
    tmp = load(fullfile(options.resultroot,[subjectsAll{iSubject},options.model.winningPerceptual, ...
                options.model.winningResponse,'.mat']), 'est_int','-mat');
    
    mltm_zeta{iSubject,1} = tmp.est_int.p_obs.ze1;
    mltm_zeta{iSubject,2} = tmp.est_int.p_obs.beta;
end
zeta = cell2mat(mltm_zeta);

end