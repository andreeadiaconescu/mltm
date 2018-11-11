function r = fitModel(responses, inputs, varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This is the main function for fitting the parameters of a combination of perceptual and
% observation models, given inputs and responses.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% USAGE:
%     est = fitModel(responses, inputs)
% 
% INPUT ARGUMENTS:
%     responses          Array of binary responses (column vector)
%     inputs             Array of inputs (column vector)
%
%                        Code irregular (missed, etc.) responses as NaN. Such responses will be
%                        ignored. However, the trial as such will not be ignored and filtering will
%                        take place based on the input.
%
%                        To ignore a trial, code the input as NaN. In this case, filtering is
%                        suspended for this trial and all representations (i.e., inferences on
%                        hidden states) will remain constant.
%
%                        Note that an input is often a composite event, for example a cue-stimulus
%                        contingency. If the agent you are modeling is lerning such contingencies,
%                        inputs have to be coded in contingency space (e.g., blue cue -> reward as
%                        well as green cue -> no reward is coded as 1 while blue cue -> no reward as
%                        well as green cue -> reward is coded as 0). The same applies to responses.
%
%                        If needed for a specific application, responses and inputs can be
%                        matrices with further columns. The coding of irregular and ignored
%                        trials described above then applies to their first column.
%
% OUTPUT:
%     est.u              Input to agent (i.e., the inputs array from the arguments)
%     est.y              Observed responses (i.e., the responses array from the arguments)
%     est.irr            Index numbers of irregular trials
%     est.ign            Index numbers of ignored trials
%     est.c_prc          Configuration settings for your chosen perceptual model
%                        (see the configuration file of that model for details)
%     est.c_obs          Configuration settings for your chosen observation model
%                        (see the configuration file of that model for details)
%     est.c_opt          Configuration settings for your chosen optimization algorithm
%                        (see the configuration file of that algorithm for details)
%     est.optim          A place for the optimization algorithm to dump infos of interest to it
%     est.p_prc          Maximum-a-posteriori estimates of perceptual parameters
%                        (see the configuration file of your chosen perceptual model for details)
%     est.p_obs          Maximum-a-posteriori estimates of observation parameters
%                        (see the configuration file of your chosen observation model for details)
%     est.traj:          Trajectories of the environmental states tracked by the perceptual model
%                        (see the configuration file of that model for details)
%     est.F              The negative free energy. This is a lower bound on the log-model evidence.
%
% CONFIGURATION:
%     In order to fit a model in this framework, you have to make three choices:
%
%     (1) a perceptual model,
%     (2) an observation model, and
%     (3) an optimization algorithm.
%
%     The perceptual model can for example be a Bayesian generative model of the states of an
%     agent's environment (like the Hierarchical Gaussian Filter (HGF)) or a reinforcement learning
%     algorithm (like Rescorla-Wagner (RW)). It describes the states or values that
%     probabilistically determine observed responses.
%
%     The observation model describes how the states or values of the perceptual model map onto
%     responses. Examples are the softmax decision rule or the closely related unit-square sigmoid
%     decision model.
%
%     The optimization algorithm is used to determine the maximum-a-posteriori (MAP) estimates of
%     the parameters of both the perceptual and decision models. Its objective function is the
%     unnormalized log-posterior of all perceptual and observation parameters, given the data and
%     the perceptual and observation models. This corresponds to the log-joint of data and
%     parameters, given the models.
%
%     Perceptual and observation models have to be chosen so that they are compatible, while the
%     choice of optimization algorithm is independent. To choose a particular combination, make
%     your changes to the configuration section of this file below. Compatibility information can
%     be found there.
%
%     Once you have made your choice, go to the relevant configuration files (e.g.,
%     hgf_binary_config.m for a choice of r.c_prc = hgf_binary_config), read the model- and
%     algorithm-specific information there, and configure accordingly.
%
%     The choices configured below can be overriden on the command line. Usage then is:
%
%     est = fitModel(responses, inputs, prc_model, obs_model, opt_algo)
%
%     where the last three arguments are strings containing the names of the corresponding
%     configuration files (without the extension .m).
%
% NEW DATASETS:
%     When analyzing a new dataset, take your inputs and use 'bayes_optimal_config' (or
%     'bayes_optimal_binary_config' for binary inputs) as your observation model. This determines
%     the Bayes optimal perceptual parameters (given your current priors, so choose them wide and
%     loose to let the inputs influence the result). You can then use the optimal parameters as your
%     new prior means for the perceptual parameters.
%
% PLOTTING OF RESULTS:
%     To plot the trajectories of the inferred perceptual states (as implied by the estimated
%     parameters), there is a function <modelname>_plotTraj(...) for each perceptual model. This
%     takes the structure returned by fitModel(...) as its only argument.
%
%     Additionally, the function fit_plotCorr(...) plots the posterior correlation of the
%     estimated parameters. It takes the structure returned by fitModel(...) as its only
%     argument. Note that this function only works if the optimization algorithm makes the
%     posterior correlation available in est.optim.Corr.
%
% EXAMPLE:
%     est = fitModel(responses, inputs)
%     hgf_plotTraj_reward_social(est)
%     fit_plotCorr(est)
%
% --------------------------------------------------------------------------------------------------
% Copyright (C) 2012-2013 Christoph Mathys, TNU, UZH & ETHZ
%
% This file is part of the HGF toolbox, which is released under the terms of the GNU General Public
% Licence (GPL), version 3. You can redistribute it and/or modify it under the terms of the GPL
% (either version 3 or, at your option, any later version). For further details, see the file
% COPYING or <http://www.gnu.org/licenses/>.

% Store responses, inputs, and information about irregular trials in newly
% initialized structure r
r = dataPrep(responses, inputs);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% CONFIGURE THESE AS DESCRIBED ABOVE:
%
% Perceptual model
% ~~~~~~~~~~~~~~~~
% Choices are: 
% - hgf_binary3l_reward_social_config
% - hgf_binary_config
% - hgf_binary3l_config
% - rw_binary_config
% - hgf_config
% - hgf_ar1_config
r.c_prc = hgf_binary3l_reward_social_config;

% Observation model
% ~~~~~~~~~~~~~~~~~
% Choices are:
% - unitsq_sgm_config                 (compatible with *_binary_config)
% - softmax_binary_config             (compatible with *_binary_config)
% - bayes_optimal_binary_config       (compatible with *_binary_config)
% - gaussian_obs_config               (compatible with hgf_config)
% - bayes_optimal_config              (compatible with hgf_config)
% - squared_pe_config                 (compatible with hgf_config)
% - softmax_reward_social             (compatible with
%                                      hgf_binary3l_reward_social_config)
r.c_obs = softmax_reward_social_config;      

% Optimization algorithm
% ~~~~~~~~~~~~~~~~~~~~~~
% Choices are:
% - quasinewton_optim_config
r.c_opt = quasinewton_optim_config;

% END OF CONFIGURATION
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Overridden settings from the command line
if nargin > 2 && ~isempty(varargin{1})
    r.c_prc = eval(varargin{1});
end

if nargin > 3 && ~isempty(varargin{2})
    r.c_obs = eval(varargin{2});
end

if nargin > 4 && ~isempty(varargin{3})
    r.c_opt = eval(varargin{3});
end

% Replace placeholders in parameter vectors with their calculated values
r.c_prc.priormus(r.c_prc.priormus==99991) = r.plh.p99991;
r.c_prc.priorsas(r.c_prc.priorsas==99991) = r.plh.p99991;

r.c_prc.priormus(r.c_prc.priormus==99992) = r.plh.p99992;
r.c_prc.priorsas(r.c_prc.priorsas==99992) = r.plh.p99992;

r.c_prc.priormus(r.c_prc.priormus==99993) = r.plh.p99993;
r.c_prc.priorsas(r.c_prc.priorsas==99993) = r.plh.p99993;

r.c_prc.priormus(r.c_prc.priormus==99994) = r.plh.p99994;
r.c_prc.priorsas(r.c_prc.priorsas==99994) = r.plh.p99994;

r = rmfield(r, 'plh');

% Estimate mode of posterior parameter distribution (MAP estimate)
r = optim(r, r.c_prc.prc_fun, r.c_obs.obs_fun, r.c_opt.opt_algo);

% Store maximum of the log-joint
r.maxLogJoint = -r.optim.valMin;

% Separate perceptual and observation parameters
n_prcpars = length(r.c_prc.priormus);
ptrans_prc = r.optim.final(1:n_prcpars);
ptrans_obs = r.optim.final(n_prcpars+1:end);

% Transform MAP parameters back to their native space
[dummy, r.p_prc]   = r.c_prc.transp_prc_fun(r, ptrans_prc);
[dummy, r.p_obs]   = r.c_obs.transp_obs_fun(r, ptrans_obs);
r.p_prc.p      = r.c_prc.transp_prc_fun(r, ptrans_prc);
r.p_obs.p      = r.c_obs.transp_obs_fun(r, ptrans_obs);

% Store transformed MAP parameters
r.p_prc.ptrans = ptrans_prc;
r.p_obs.ptrans = ptrans_obs;

% Store representations at MAP estimate
r.traj = r.c_prc.prc_fun(r, r.p_prc.p);

% Print results
disp(' ')
disp('Results:');
disp(r.p_prc)
disp(r.p_obs)
disp(['Negative free energy F: ' num2str(r.F)])

return;

% --------------------------------------------------------------------------------------------------
function r = dataPrep(responses, inputs)

% Initialize data structure to be returned
r = struct;

% Check if inputs look like column vectors
if size(inputs,1) <= size(inputs,2)
    disp(' ')
    disp('Warning: ensure that input sequences are COLUMN vectors.')
end

% Store responses and inputs
r.y  = responses;
r.u  = inputs;

% Determine ignored trials
ign = [];
for k = 1:size(r.u,1)
    if isnan(r.u(k,1))
        ign = [ign, k];
    end
end

r.ign = ign;

if isempty(ign)
    ignout = 'none';
else
    ignout = ign;
end
disp(['Ignored trials: ', num2str(ignout)])
    
% Determine irregular trials
irr = [];
for k = 1:size(r.y,1)
    if isnan(r.y(k,1))
        irr = [irr, k];
    end
end

% Make sure every ignored trial is also irregular
irr = unique([ign, irr]);

r.irr = irr;

if isempty(irr)
    irrout = 'none';
else
    irrout = irr;
end
disp(['Irregular trials: ', num2str(irrout)])
    
% Calculate placeholder values for configuration files

% First input
% Usually a good choice for the prior mean of mu_1
r.plh.p99991 = r.u(1,1);

% Variance of first 20 inputs
% Usually a good choice for the prior variance of mu_1
if length(r.u(:,1)) > 20
    r.plh.p99992 = var(r.u(1:20,1),1);
else
    r.plh.p99992 = var(r.u(:,1),1);
end

% Log-variance of first 20 inputs
% Usually a good choice for the prior means of log(sa_1) and alpha
if length(r.u(:,1)) > 20
    r.plh.p99993 = log(var(r.u(1:20,1),1));
else
    r.plh.p99993 = log(var(r.u(:,1),1));
end

% Log-variance of first 20 inputs minus two
% Usually a good choice for the prior mean of omega_1
if length(r.u(:,1)) > 20
    r.plh.p99994 = log(var(r.u(1:20,1),1))-2;
else
    r.plh.p99994 = log(var(r.u(:,1),1))-2;
end

return;

% --------------------------------------------------------------------------------------------------
function r = optim(r, prc_fun, obs_fun, opt_algo)

% Use means of priors as starting values for optimization for optimized parameters (and as values
% for fixed parameters)
init = [r.c_prc.priormus, r.c_obs.priormus];

% Determine indices of parameters to optimize (i.e., those that are not fixed or NaN)
opt_idx = [r.c_prc.priorsas, r.c_obs.priorsas];
opt_idx(isnan(opt_idx)) = 0;
opt_idx = find(opt_idx);

% Number of perceptual and observation parameters
n_prcpars = length(r.c_prc.priormus);
n_obspars = length(r.c_obs.priormus);

% Construct the objective function to be MINIMIZED:
% The negative log-joint as a function of a single parameter vector
nlj = @(p) [negLogJoint(r, prc_fun, obs_fun, p(1:n_prcpars), p(n_prcpars+1:n_prcpars+n_obspars))];

% Automatically find a sensible upper bound on theta if desired (and if theta exists)
if isfield(r.c_prc, 'thub') && r.c_prc.thub == 0
    disp(' ')
    disp('Determining the upper bound on theta...')

    maxub = 2;
    ul = maxub;
    ll = 0;
    while (ul-ll)/ul > 1e-2
        testval = ll+(ul-ll)/2;
        r.c_prc.thub = testval;
        nlj = @(p) [negLogJoint(r, prc_fun, obs_fun, p(1:n_prcpars), p(n_prcpars+1:n_prcpars+n_obspars))];
        [dummy, rval] = nlj(init);
        if rval ~= 0
            ul = testval;
        else
            ll = testval;
        end

        if ul == maxub
            ll = maxub;
            break;
        end
    end

    if ll ~= 0
        r.c_prc.thub = ll;
        nlj = @(p) [negLogJoint(r, prc_fun, obs_fun, p(1:n_prcpars), p(n_prcpars+1:n_prcpars+n_obspars))];
        disp(' ')
        disp(['Set the upper bound on theta to ', num2str(r.c_prc.thub), '.'])
    else
        error('Prior means are in a region where the log-joint cannot be evaluated. Please adjust.');
    end
else
    % Check whether priors are in a region where the objective function can be evaluated
    [dummy, rval] = nlj(init);
    if rval ~= 0
        error('Prior means are in a region where the log-joint cannot be evaluated. Please adjust.');
    end
end

% The objective function is now the negative log joint restricted
% with respect to the parameters that are not optimized
obj_fun = @(p_opt) restrictfun(nlj, init, opt_idx, p_opt);

% Optimize
disp(' ')
disp('Optimizing...')
r.optim = opt_algo(obj_fun, init(opt_idx)', r.c_opt);

% Replace optimized values in init with arg min values
final = init;
final(opt_idx) = r.optim.argMin';
r.optim.final = final;

% Calculate the covariance matrix Sigma and the negative free energy F.
disp(' ')
disp('Calculating the negative free energy...')
d     = length(opt_idx);
Sigma = NaN(d);
Corr  = NaN(d);
F     = NaN;

options.init_h    = 1;
options.min_steps = 10;

% Numerical computation of the Hessian of the negative log-joint at the MAP estimate
H = riddershessian(obj_fun, r.optim.argMin, options);

% Use the Hessian from the optimization, if available,
% if the numerical Hessian is not positive definite
if any(isinf(H(:))) || any(isnan(H(:))) || any(eig(H)<=0)
    if isfield(r.optim, 'T')
        % Hessian of the negative log-joint at the MAP estimate
        H     = inv(r.optim.T);
        % Parameter covariance 
        Sigma = r.optim.T;
        % Parameter correlation
        Corr = Cov2Corr(Sigma);
        % Negative free energy
        F     = -r.optim.valMin + 1/2*log(1/det(H)) + d/2*log(2*pi);
    else
        disp('Warning: Cannot calculate Sigma and F because the Hessian is not positive definite.')    
    end
else
    % Parameter covariance
    Sigma = inv(H);
    % Parameter correlation
    Corr = Cov2Corr(Sigma);
    % Negative free energy
    F = -r.optim.valMin + 1/2*log(1/det(H)) + d/2*log(2*pi);    
end

[negLogJoint, rval,logLl,logPrcPrior,logObsPrior] = obj_fun(r.optim.argMin');

r.optim.H     = H;
r.optim.Sigma = Sigma;
r.optim.Corr  = Corr;
r.F = F; 
r.logLl = logLl;
r.logPrcPrior=logPrcPrior;
r.logObsPrior=logObsPrior;
return;

% --------------------------------------------------------------------------------------------------
function [negLogJoint, rval,logLl,logPrcPrior,logObsPrior] = negLogJoint(r, prc_fun, obs_fun, ptrans_prc, ptrans_obs)
% Returns the the negative log-joint density for perceptual and observation parameters

% Calculate perceptual trajectories. The columns of the matrix infStates contain the trajectories of
% the inferred states (according to the perceptual model) that the observation model bases its
% predictions on.
try
    [dummy, infStates] = prc_fun(r, ptrans_prc, 'trans');
catch
    negLogJoint = realmax;
    % Signal that something has gone wrong
    rval = -1;
    return;
end

% Calculate the log-likelihood of observed responses given the perceptual trajectories,
% under the observation model
trialLogLls = obs_fun(r, infStates, ptrans_obs);
logLl = nansum(trialLogLls);

% Calculate the log-prior of the perceptual parameters.
% Only parameters that are neither NaN nor fixed (non-zero prior variance) are relevant.
prc_idx = r.c_prc.priorsas;
prc_idx(isnan(prc_idx)) = 0;
prc_idx = find(prc_idx);

% Note: 8*atan(1) == 2*pi (this is used to guard against
% errors resulting from having used pi as a variable).
logPrcPriors = -1/2.*log(8*atan(1).*r.c_prc.priorsas(prc_idx)) - 1/2.*(ptrans_prc(prc_idx) - r.c_prc.priormus(prc_idx)).^2./r.c_prc.priorsas(prc_idx);
logPrcPrior  = sum(logPrcPriors);

% Calculate the log-prior of the observation parameters.
% Only parameters that are neither NaN nor fixed (non-zero prior variance) are relevant.
obs_idx = r.c_obs.priorsas;
obs_idx(isnan(obs_idx)) = 0;
obs_idx = find(obs_idx);


p_obs = r.c_obs.transp_obs_fun(r, ptrans_obs); % transform obs params back to their native param space ADLK
logObsPriors = -1/2.*log(8*atan(1).*r.c_obs.priorsas(obs_idx)) - 1/2.*(ptrans_obs(obs_idx) - r.c_obs.priormus(obs_idx)).^2./r.c_obs.priorsas(obs_idx);%  ...
               % -log(abs(p_obs(obs_idx).*(1-p_obs(obs_idx)))); %% function of random variable determinant ADLK
logObsPrior  = sum(logObsPriors);

negLogJoint = -(logLl + logPrcPrior + logObsPrior);


% Signal that all has gone right
rval = 0;

return;

% --------------------------------------------------------------------------------------------------
function [val, varargout] = restrictfun(f, arg, free_idx, free_arg)
% This is a helper function for the construction of file handles to
% restricted functions.
%
% It returns the value of a function restricted to subset of the
% arguments of the input function handle. The input handle takes
% *one* vector as its argument.
% 
% INPUT:
%   f            The input function handle
%   arg          The argument vector for the input function containing the
%                fixed values of the restricted arguments (plus dummy values
%                for the free arguments)
%   free_idx     The index numbers of the arguments that are not restricted
%   free_arg     The values of the free arguments

% Replace the dummy arguments in arg
arg(free_idx) = free_arg;

% Evaluate

if nargout > 1
    varargout = cell(1,nargout-1);
    [val, varargout{1,:}] = f(arg);
else
    val = f(arg);
end
return;
