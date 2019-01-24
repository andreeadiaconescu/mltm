function c = tapas_hgf_ar1_reward_social_config
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Contains the configuration for the Hierarchical Gaussian Filter (HGF) for AR(1) processes
% for binary inputs in the absence of perceptual uncertainty.
%
% The HGF is the model introduced in 
%
% Mathys C, Daunizeau J, Friston, KJ, and Stephan KE. (2011). A Bayesian foundation
% for individual learning under uncertainty. Frontiers in Human Neuroscience, 5:39.
%
% The binary HGF model has since been augmented with a positive factor kappa1 which
% scales the second level with respect to the first, i.e., the relation between the
% first and second level is
%
% p(x1=1|x2) = s(kappa1*x2), where s(.) is the logistic sigmoid.
%
% By default, kappa1 is fixed to 1, leading (apart from the AR(1) process) to the
% model introduced in Mathys et al. (2011).
%
% This file refers to BINARY inputs (Eqs 1-3 in Mathys et al., (2011));
% for continuous inputs, refer to tapas_hgf_config.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% The HGF configuration consists of the priors of parameters and initial values. All priors are
% Gaussian in the space where the quantity they refer to is estimated. They are specified by their
% sufficient statistics: mean and variance (NOT standard deviation).
% 
% Quantities are estimated in their native space if they are unbounded (e.g., the omegas). They are
% estimated in log-space if they have a natural lower bound at zero (e.g., the sigmas).
% 
% The phis are estimated in 'logit space' because they are confined to the interval from 0 to 1.
% 'Logit-space' is a logistic sigmoid transformation of native space with a variable upper bound
% a>0:
% 
% tapas_logit(x) = ln(x/(a-x)); x = a/(1+exp(-tapas_logit(x)))
%
% Parameters can be fixed (i.e., set to a fixed value) by setting the variance of their prior to
% zero. Aside from being useful for model comparison, the need for this arises whenever the scale
% and origin at the j-th level are arbitrary. This is the case if the observation model does not
% contain the representations mu_j and sigma_j. A choice of scale and origin is then implied by
% fixing the initial value mu_j_0 of mu_j and either kappa_j-1 or omega_j-1.
%
% Fitted trajectories can be plotted by using the command
%
% >> tapas_hgf_binary_plotTraj(est)
% 
% where est is the stucture returned by tapas_fitModel. This structure contains the estimated
% perceptual parameters in est.p_prc and the estimated trajectories of the agent's
% representations (cf. Mathys et al., 2011). Their meanings are:
%              
%         est.p_prc.mu_0       row vector of initial values of mu (in ascending order of levels)
%         est.p_prc.sa_0       row vector of initial values of sigma (in ascending order of levels)
%         est.p_prc.phi        row vector of phis (representing reversion slope to attractor; in ascending order of levels)
%         est.p_prc.m        row vector of ms (representing attractors; in ascending order of levels)
%         est.p_prc.ka         row vector of kappas (in ascending order of levels)
%         est.p_prc.om         row vector of omegas (in ascending order of levels)
%
% Note that the first entry in all of the row vectors will be NaN because, at the first level,
% these parameters are either determined by the second level (mu_0 and sa_0) or undefined (rho,
% kappa, and omega).
%
%         est.traj.mu          mu (rows: trials, columns: levels)
%         est.traj.sa          sigma (rows: trials, columns: levels)
%         est.traj.muhat       prediction of mu (rows: trials, columns: levels)
%         est.traj.sahat       precisions of predictions (rows: trials, columns: levels)
%         est.traj.v           inferred variance of random walk (rows: trials, columns: levels)
%         est.traj.w           weighting factors (rows: trials, columns: levels)
%         est.traj.da          volatility prediction errors  (rows: trials, columns: levels)
%         est.traj.ud          updates with respect to prediction  (rows: trials, columns: levels)
%         est.traj.psi         precision weights on prediction errors  (rows: trials, columns: levels)
%         est.traj.epsi        precision-weighted prediction errors  (rows: trials, columns: levels)
%         est.traj.wt          full weights on prediction errors (at the first level,
%                                  this is the learning rate) (rows: trials, columns: levels)
%
% Note that in the absence of sensory uncertainty (which is the assumption here), the first
% column of mu, corresponding to the first level, will be equal to the inputs. Likewise, the
% first column of sa will be 0 always.
%
% Tips:
% - When analyzing a new dataset, take your inputs u and use
%
%   >> est = tapas_fitModel([], u, 'tapas_hgf_binary_config', 'tapas_bayes_optimal_binary_config');
%
%   to determine the Bayes optimal perceptual parameters (given your current priors as defined in
%   this file here, so choose them wide and loose to let the inputs influence the result). You can
%   then use the optimal parameters as your new prior means for the perceptual parameters.
%
% - If you get an error saying that the prior means are in a region where model assumptions are
%   violated, lower the prior means of the omegas, starting with the highest level and proceeding
%   downwards.
%
% - Alternatives are lowering the prior means of the kappas, if they are not fixed, or adjusting
%   the values of the kappas or omegas, if any of them are fixed.
%
% - If the log-model evidence cannot be calculated because the Hessian poses problems, look at
%   est.optim.H and fix the parameters that lead to NaNs.
%
% - Your guide to all these adjustments is the log-model evidence (LME). Whenever the LME increases
%   by at least 3 across datasets, the adjustment was a good idea and can be justified by just this:
%   the LME increased, so you had a better model.
%
% --------------------------------------------------------------------------------------------------
% Copyright (C) 2012-2017 Christoph Mathys, TNU, UZH & ETHZ
%
% This file is part of the HGF toolbox, which is released under the terms of the GNU General Public
% Licence (GPL), version 3. You can redistribute it and/or modify it under the terms of the GPL
% (either version 3 or, at your option, any later version). For further details, see the file
% COPYING or <http://www.gnu.org/licenses/>.


% Config structure
c = struct;

% Model name
c.model = 'tapas_hgf_ar1_reward_social';

% Number of levels (minimum: 3)
c.n_levels = 3;

% Input intervals
% If input intervals are irregular, the last column of the input
% matrix u has to contain the interval between inputs k-1 and k
% in the k-th row, and this flag has to be set to true
c.irregular_intervals = false;

% Sufficient statistics of Gaussian parameter priors

% Initial mus and sigmas
% Format: row vectors of length n_levels
% For all but the first two levels, this is usually best
% kept fixed to 1 (determines origin on x_i-scale). The 
% first level is NaN because it is determined by the second,
% and the second implies neutrality between outcomes when it
% is centered at 0.
c.mu_0mu_r = [NaN, 0, 1];
c.mu_0sa_r = [NaN, 0, 0];
c.mu_0mu_a = [NaN, 0, 1];
c.mu_0sa_a = [NaN, 0, 0];

% mu03 sch�tzen:
% c.mu_0mu_r = [NaN, 0, 1];
% c.mu_0sa_r = [NaN, 1, 1]; %1
% c.mu_0mu_a = [NaN, 0, 1];
% c.mu_0sa_a = [NaN, 1, 1];

 c.logsa_0mu_r = [NaN, log(0.4), log(0.1)]; % TAKE THIS ! It was 4 before 
 c.logsa_0sa_r = [NaN,          1      1]; 
% 
 c.logsa_0mu_a = [NaN, log(0.4), log(0.1)]; %  
 c.logsa_0sa_a = [NaN,          1     1];

%Before

% c.logsa_0mu_r = [NaN, log(0.006), log(4)];
% c.logsa_0sa_r = [NaN,          1,      1];
% 
% c.logsa_0mu_a = [NaN, log(0.006), log(4)];
% c.logsa_0sa_a = [NaN,         1,     1];

% Phis
% Format: row vector of length n_levels.
% Undefined (therefore NaN) at the first level.
% Fix this to zero (-Inf in logit space) to set to zero.
c.logitphimu_r = [NaN, -Inf, tapas_logit(0.1,1)]; % phi 2 auf null is gaussian random walk auf level 2 im logit raum auf - unendlich 
c.logitphisa_r = [NaN,    0,                  2]; %0.5 oder 0.2 sigma prior auf 0.15

c.logitphimu_a = [NaN, -Inf, tapas_logit(0.1,1)]; % phi 2 auf null is gaussian random walk auf level 2 im logit raum auf - unendlich 
c.logitphisa_a = [NaN,    0,                  2];


% ms
% Format: row vector of length n_levels.
% This should be fixed for all levels where the omega of
% the next lowest level is not fixed because that offers
% an alternative parametrization of the same model.
c.mmu_r = [NaN, c.mu_0mu_r(2), c.mu_0mu_r(3)];
c.msa_r = [NaN,           0,           0]; % on 3rd level 1 bevore 
c.mmu_a = [NaN, c.mu_0mu_a(2), c.mu_0mu_a(3)];
c.msa_a = [NaN,           0,           0];

% % ms
% % Format: row vector of length n_levels.
% % This should be fixed for all levels where the omega of
% % the next lowest level is not fixed because that offers
% % an alternative parametrization of the same model.
% c.mmu_r = [NaN, c.mu_0mu_r(2), c.mu_0mu_r(3)];
% c.msa_r = [NaN,           0,           1];
% c.mmu_a = [NaN, c.mu_0mu_a(2), c.mu_0mu_a(3)];
% c.msa_a = [NaN,           0,           1];

% Kappas
% Format: row vector of length n_levels-1.
% Fixing log(kappa1) to log(1) leads to the original HGF model.
% Higher log(kappas) should be fixed (preferably to log(1)) if the
% observation model does not use mu_i+1 (kappa then determines the
% % scaling of x_i+1).
c.logkamu_r = [log(1), log(1)]; % Kappa 2 auf -Inf und dann 0; alles auf 3. Level auf Null
c.logkasa_r = [     0,      0]; % set sa = 1 if kappa should be free
c.logkamu_a = [log(1), log(1)];
c.logkasa_a = [     0,      0];

% % F�r no Vol Models
% c.logkamu_r = [log(1), -Inf]; 
% c.logkasa_r = [     0,      0];
% c.logkamu_a = [log(1), -Inf];
% c.logkasa_a = [     0,      0];

% Omegas
%Format: row vector of length n_levels.
%Undefined (therefore NaN) at the first level.
c.ommu_r = [NaN,  -4,  -6]; 
c.omsa_r = [NaN, 4, 4];

c.ommu_a = [NaN,  -4,  -6];  
c.omsa_a = [NaN, 4, 4];  

% Gather prior settings in vectors

c.priormus = [
    c.mu_0mu_r,...
    c.logsa_0mu_r,...
    c.logitphimu_r,...
    c.mmu_r,...
    c.logkamu_r,...
    c.ommu_r,...
     c.mu_0mu_a,...
    c.logsa_0mu_a,...
    c.logitphimu_a,...
    c.mmu_a,...
    c.logkamu_a,...
    c.ommu_a,...
         ];

c.priorsas = [
    c.mu_0sa_r,...
    c.logsa_0sa_r,...
    c.logitphisa_r,...
    c.msa_r,...
    c.logkasa_r,...
    c.omsa_r,...
       c.mu_0sa_a,...
    c.logsa_0sa_a,...
    c.logitphisa_a,...
    c.msa_a,...
    c.logkasa_a,...
    c.omsa_a,...
         ];

%Check whether we have the right number of priors
expectedLength = 5*c.n_levels+(c.n_levels-1);
if length([c.priormus, c.priorsas]) ~= 4*expectedLength;
    error('tapas:hgf:PriorDefNotMatchingLevels', 'Prior definition does not match number of levels.')
end

% Model function handle
c.prc_fun = @tapas_hgf_ar1_reward_social;

% Handle to function that transforms perceptual parameters to their native space
% from the space they are estimated in
c.transp_prc_fun = @tapas_hgf_ar1_reward_social_transp;

return;
