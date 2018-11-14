function [perceptualParameters] = MLTM_load_parameters(options)

subjectsAll = options.subjects;
mltm_par      = cell(numel(subjectsAll), 4);
for  iSubject = 1:length(subjectsAll)
    sprintf('%s',subjectsAll{iSubject})
    tmp = load(fullfile(options.resultroot,[subjectsAll{iSubject},options.model.perceptualModels{1}, ...
                options.model.responseModels{1},'.mat']), 'est_int','-mat');
    
    mltm_par{iSubject,1} = tmp.est_int.p_prc.ka_r;
    mltm_par{iSubject,2} = tmp.est_int.p_prc.th_r;
    mltm_par{iSubject,3} = tmp.est_int.p_prc.ka_a;
    mltm_par{iSubject,4} = tmp.est_int.p_prc.th_a;
end
perceptualParameters = cell2mat(mltm_par);



end