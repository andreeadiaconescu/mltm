function options = MLTM_options()

%% User folders-----------------------------------------------------------%
[~, uid] = unix('whoami');
switch uid(1: end-1)
    case 'drea'
        dataroot    = '/Users/drea/Documents/Collaborations/LeoSchilbach_ImplicitAdvice/Data';
        resultroot  = '/Users/drea/Documents/Collaborations/LeoSchilbach_ImplicitAdvice/Inverted';
        configroot  = fullfile(fileparts(mfilename('fullpath')), '/configs');
end


options.root                 = dataroot;
options.dataroot             = dataroot;
options.resultroot           = resultroot;
options.configroot           = configroot;
options.code                 = fullfile(fileparts(mfilename('fullpath')));
options.model.pathPerceptual = fullfile([options.code,'/Perceptual_Model']);
options.model.pathResponse   = fullfile([options.code,'/Response_Model']);

% Add paths: HGF, VBA
addpath(genpath(options.model.pathPerceptual));
addpath(genpath(options.model.pathResponse));
addpath(genpath('/Users/drea/Documents/MATLAB/VBA_toolbox/VBA-toolbox'));


options.family.template             = fullfile(options.configroot,'family_allmodels.mat');
options.questionnaires              = fullfile([options.dataroot,'/Questionnaire_Data/Meltem_DataQuestionnaires.xlsx']);

options.model.perceptualModels   = {'hgf_binary3l_reward_social_config'};
options.model.responseModels     =  {'softmax_reward_social_config','softmax_reward_config'};
options.model.labels = ...
    {'Both', 'Reward','Social'};

options.family.responsemodels1.labels = {'Both','Reward','Advice'};
options.family.responsemodels1.partition = [1 2 3 1 2 3 1 2 3 1 2 3];



% Parameters
options.model.hgfPrior   = {'sa2r_0','mu2r_0','sa3r_0','mu3r_0',...
                            'sa2a_0','mu2a_0','sa3a_0','mu3a_0'};
                        
options.model.hgfParam   = {'kappaR','omegaR','thetaR',...
                            'kappaA','omegaA','thetaA','zeta1','beta'};

%% Subject IDs ------------------------------------------------------------%
% Local function for drug group specific settings
options = subject_task_details(options);
%% Subjects with specific name rules
    function detailsOut = subject_task_details(detailsIn)
        
        detailsOut = detailsIn;
        detailsOut.subjects=...
            {'1071' '1088' '2024' '2037' '2127' '2251' '2261' '2278' '2309',...
            '2337' '2346' '2372' '2419' '2465' '2478' '2504' '2879' '2899',...
            '2946' '3049' '3077' '3123' '3139' '3145' '3146' '3168' '3234',...
            '3301' '4564' '4774' '4991' '5000' '5003' '5005' '5054' '5075'};
        
    end
end

