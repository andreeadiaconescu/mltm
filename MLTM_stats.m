function MLTM_stats(options)
%Performs all statistical analyses and prints tables for the pape
%   IN:   
%           options     as set by MLTM_options();

fprintf('\n===\n\t Running group-level stats and printing tables for Parameters:\n\n');
MLTM_test_MAPS_stats(options);

fprintf('\n===\n\t Running group-level stats and printing tables for Belief Precision of Card Probabilities:\n\n');
MLTM_test_States_stats(options);

fprintf('\n===\n\t Running group-level stats and printing tables for Behavioural Variables:\n\n');
MLTM_test_BehavVariables_stats(options);

end