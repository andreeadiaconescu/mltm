function MLTM_second_level(options)
%Performs all analysis steps for one subject of the MLTM study (up until
% first level modelbased statistics)
%   IN:     id          subject identifier string, e.g. '151'
%           options     as set by dmpad_set_analysis_options();

fprintf('\n===\n\t The following pipeline Steps were selected. Please double-check:\n\n');
Analysis_Strategy = options.secondlevel;
disp(Analysis_Strategy);
fprintf('\n\n===\n\n');
pause(2);

doModelComparison         = Analysis_Strategy(1);
doParameterExtraction     = Analysis_Strategy(2);


% Deletes previous preproc/stats files of analysis specified in options
if doModelComparison
    MLTM_model_selection(options);
end
if doParameterExtraction
   MLTM_extract_parameters(options);    
end

