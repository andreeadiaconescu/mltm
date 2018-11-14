function MLTM_check_correlations(options)

subjectsAll = options.subjects;
for  iSubject = 1:length(subjectsAll)
    sprintf('%s',subjectsAll{iSubject})
    tmp = load(fullfile(options.resultroot,[subjectsAll{iSubject},options.model.perceptualModels{1}, ...
        options.model.responseModels{1},'.mat']), 'est_int','-mat');
    corrMatrix    = tmp.est_int.optim.Corr;
    z_transformed = real(compi_fisherz(reshape(corrMatrix,size(corrMatrix,1)^2,1)));
    averageCorr{iSubject,1}=reshape(z_transformed,size(corrMatrix,1),...
        size(corrMatrix,2));
    
end

averageZCorr = mean(cell2mat(permute(averageCorr,[2 3 1])),3);
averageGroupCorr = compi_ifisherz(reshape(averageZCorr,size(corrMatrix,1)^2,1));
finalCorr = reshape(averageGroupCorr,size(corrMatrix,1),...
        size(corrMatrix,2));
figure;imagesc(finalCorr);
caxis([-1 1]);
title('Correlation Matrix, averaged over subjects');
maximumCorr = max(max(finalCorr(~isinf(finalCorr))));
fprintf('\n\n----- Maximum correlation is %s -----\n\n', ...
    num2str(maximumCorr));
minimumCorr = min(min(finalCorr(~isinf(finalCorr))));
fprintf('\n\n----- Minimum correlation is %s -----\n\n', ...
    num2str(minimumCorr));


end