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

% Design
options.task.stable_card                = [ones(20,1); ones(20,1).*NaN; ones(20,1);ones(60,1).*NaN];
options.task.volatile_card              = [ones(60,1).*NaN; ones(60,1)];
options.task.chance_card                = [ones(20,1).*NaN; ones(20,1); ones(20,1).*NaN;ones(60,1).*NaN];
options.task.congruent.first            = [ones(20,1); ones(100,1).*NaN];
options.task.congruent.second           = [ones(80,1).*NaN; ones(40,1)];
options.task.congruent_volatility       = [ones(30,1).*NaN; ones(10,1); ones(10,1).*NaN; ones(10,1); ones(10,1).*NaN; ones(10,1);...
                                           ones(40,1).*NaN];
options.task.incongruent_volatility     = [ones(40,1).*NaN; ones(10,1); ones(10,1).*NaN; ones(20,1);ones(40,1).*NaN];

% Analysis setting
options.firstlevel  = [1 0];
options.secondlevel = [1 1 1 1];

% Add paths: HGF, VBA
addpath(genpath(options.model.pathPerceptual));
addpath(genpath(options.model.pathResponse));
addpath(genpath('/Users/drea/Documents/Social_Learning_Behaviour/Toolboxes/SPM12_r7219'));


options.family.template             = fullfile(options.configroot,'family_allmodels.mat');
options.questionnaires              = fullfile([options.dataroot,'/Questionnaire_Data/AQ_Zeta_Score_complete.xlsx']);
options.groups                      = fullfile([options.dataroot,'/Questionnaire_Data/MLTM_Groups_Conditions.xlsx']);

options.model.perceptualModels   = {'hgf_binary3l_normative_config','hgf_binary3l_reward_social_fixOmega_config'};
options.model.responseModels     = {'softmax_reward_social_fix_config','softmax_reward_fix_config',...
                                    'softmax_reward_social_fix_no_reward_config','softmax_reward_fix_no_reward_config'};
                                
options.model.winningPerceptual  = 'hgf_binary3l_reward_social_fixOmega_config';
options.model.winningResponse    = 'softmax_reward_social_fix_config';

options.model.labels = ...
    {'M1','M2',...
    'M3','M4'...
    'M5','M6',...
    'M7','M8'};

options.family.responsemodels1.labels    = {'Both','Card'};
options.family.responsemodels1.partition = [1 1 2 2 1 1 2 2];
options.family.responsemodels2.labels    = {'Reward','NoReward'};
options.family.responsemodels2.partition = [1 2 1 2 1 2 1 2];
options.family.responsemodels3.labels    = {'Normative','HGF'};
options.family.responsemodels3.partition = [1 1 1 1 2 2 2 2];

% Parameters
options.model.hgfPrior   = {'sa2r_0','mu2r_0','sa3r_0','mu3r_0',...
                            'sa2a_0','mu2a_0','sa3a_0','mu3a_0'};
options.model.hgfParam   = {'kappaR','thetaR','kappaA','thetaA'};
options.model.respParam  = {'zeta1','beta'};

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
options = subject_by_gaze_schedule_details(options);
    function detailsOut = subject_by_gaze_schedule_details(detailsIn)
        
        detailsOut = detailsIn;
        detailsOut.subjects_by_gaze.congruent=...
            {'3139' '1071' '5054' '2899' '3145' '2337' '2261' '2024',...
             '3168' '5075' '2346' '2251' '2309' '4991' '3146' '4774',...
             '3234' '2465' '2127'};              
    end
end

