% Meltem Sevgi, MPI, Cologne.
% 2014
 
subjAll = {'1071' '1088' '2024' '2037' '2127' '2251' '2261' '2278' '2309',...
    '2337' '2346' '2372' '2419' '2465' '2478' '2504' '2879' '2899',...
'2946' '3049' '3077' '3123' '3139' '3145' '3146' '3168' '3234' '3301' '4564',...
 '4774' '4991' '5000' '5003' '5005' '5054' '5075'};
 
 logDir =['/data/lara/SB',num2str(subjAll),'/behav_data'];
    cd (logDir);
    mkdir HGF_analysis;
    fitDir = ['/data/lara/SB',num2str(subjAll),'/behav_data/HGF_analysis'];
    hgfscripts = '/data/lara/scripts/SocialBayes/HGF_implicit_advice_reward/Meltem_original';

% Loop for model estimation per subject.
for i = 1:length(subjAll)
    sprintf('%s',subjAll{i})
    subjFileName = ['out_', subjAll{i}, '.txt'];
    cd(logDir)
    subjLog = load(subjFileName);
    responses = subjLog(:,9); % responses where the subject took the advice.
    responses(responses==-1) = NaN;
    %adviceTaken(i,:) = sum(~isnan(responses));
    inputs = [subjLog(:,5) subjLog(:,6)];
    est_int = fitModel(responses, inputs);
    cd(fitDir)
    mkdir(fitDir, subjAll{i})
    cd(fullfile(fitDir, subjAll{i}))
    save  est_int est_int
    clear est_int
     
end




%% Meltem version 

% for i = 1:length(subjAll)
%     sprintf('%s',subjAll{i})
%     subjFileName = ['out_', subjAll{i}, '.txt'];
%     cd(logDir)
%     subjLog = load(subjFileName);
%     responses = subjLog(:,9); % responses where the subject took the advice.
%     responses(responses==-1) = NaN;
%     %adviceTaken(i,:) = sum(~isnan(responses));
%     inputs = [subjLog(:,5) subjLog(:,6)];
%     est = fitModel(responses, inputs);
%     cd(fitDir)
%     mkdir(fitDir, subjAll{i})
%     cd(fullfile(fitDir, subjAll{i}))
%     save  est est
%     clear est
%     
% end

% %Write estimated parameters into a .csv file
% cd(fitDir)
% fid = fopen('HGF_modelParameters.csv','w');
% fid = fopen('HGF_modelParametersReducedCard.csv','w');
% fid = fopen('HGF_modelParameters_FixedPercept_DecisionNoise.csv','w');
% fprintf(fid,'%s,','subjID');
% fprintf(fid,'%s,','kappaR');
% fprintf(fid,'%s,','omegaR');
% fprintf(fid,'%s,','thetaR');
% fprintf(fid,'%s,','kappaA');
% fprintf(fid,'%s,','omegaA');
% fprintf(fid,'%s,','thetaA');
% fprintf(fid,'%s,','zeta1');
% fprintf(fid,'%s\n','beta');
% 
% for i = 1:length(subjAll)
%     cd(fullfile(fitDir, subjAll{i}))
%     load est
%     load estReducedCard.mat
%     load estFixedPercept_DecisionNoise.mat
%     estTemp = est; % adapt this for the model name
%     
%     fprintf(fid,'%s,',subjAll{i});
%     fprintf(fid,'%1.4f,',estTemp.p_prc.ka_r);
%     fprintf(fid,'%1.4f,',estTemp.p_prc.om_r);
%     fprintf(fid,'%1.4f,',estTemp.p_prc.th_r);
%     fprintf(fid,'%1.4f,',estTemp.p_prc.ka_a);
%     fprintf(fid,'%1.4f,',estTemp.p_prc.om_a);
%     fprintf(fid,'%1.4f,',estTemp.p_prc.th_a);
%     fprintf(fid,'%1.4f,',estTemp.p_obs.ze1);
%     fprintf(fid,'%1.4f\n',estTemp.p_obs.beta);
%     
%     clear est estTemp
% end
% 
% % Write inital estimates into a .csv file.
% fid = fopen('HGF_modelParametersInitials.csv','w');
% fprintf(fid,'%s,','subjID');
% fprintf(fid,'%s,','lowStable');
% fprintf(fid,'%s,','sa2r_0');
% fprintf(fid,'%s,','mu3r_0');
% fprintf(fid,'%s,','sa3r_0');
% fprintf(fid,'%s,','mu2a_0');
% fprintf(fid,'%s,','sa2a_0');
% fprintf(fid,'%s,','mu3a_0');
% fprintf(fid,'%s\n','sa3a_0');
% 
% for i = 1:length(subjAll)
%     cd(fullfile(fitDir, subjAll{i}))
%     load est.mat
%     fprintf(fid,'%s,',subjAll{i});
%     fprintf(fid,'%1.4f,',est.p_prc.mu2r_0);
%     fprintf(fid,'%1.4f,',est.p_prc.sa2r_0);
%     fprintf(fid,'%1.4f,',est.p_prc.mu3r_0);
%     fprintf(fid,'%1.4f,',est.p_prc.sa3r_0);
%     fprintf(fid,'%1.4f,',est.p_prc.mu2a_0);
%     fprintf(fid,'%1.4f,',est.p_prc.sa2a_0);
%     fprintf(fid,'%1.4f,',est.p_prc.mu3a_0);
%     fprintf(fid,'%1.4f\n',est.p_prc.sa3a_0);
%     clear est
%     
% end
    
% Construct model evidence matrix LME_HGF for model comparison, 
% i.e LME_HGF is input for spm_BMS, and of size #subjects x #models.
% for i = 1:length(subjAll)
%     cd(fullfile(fitDir, subjAll{i}))
%     load estReducedCard.mat
%     load est.mat
%     load estFixedPercept_DecisionNoise.mat
%     LME_HGF(i,1) = est.F;
%     LME_HGF(i,2) = estReducedCard.F;
%     LME_HGF(i,3) = estFixedPercept_DecisionNoise.F;
%     clear est
%     clear estReducedCard
%     clear estFixedPercept_DecisionNoise
% end



