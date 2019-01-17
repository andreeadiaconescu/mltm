
function MLTM_second_level(options)
%Performs all analysis steps at the group levle
%   IN:    
%           options     as set by MLTM_options();

fprintf('\n===\n\t The following pipeline Steps were selected. Please double-check:\n\n');
Analysis_Strategy = options.secondlevel;
disp(Analysis_Strategy);
fprintf('\n\n===\n\n');
pause(2);

doModelComparison              = Analysis_Strategy(1);
doCheckParameterCorrelations   = Analysis_Strategy(2);
doParameterExtraction          = Analysis_Strategy(3);
doComputeANOVA                 = Analysis_Strategy(4);


% Deletes previous preproc/stats files of analysis specified in options
if doModelComparison
    MLTM_model_selection(options);
end
if doParameterExtraction
   MLTM_extract_parameters(options);    
end
if doCheckParameterCorrelations
    MLTM_check_correlations(options);
end
if doComputeANOVA
    MLTM_plot_MAPs(options);
end
