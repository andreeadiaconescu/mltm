function c = softmax_reward_config
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Contains the configuration for the Softmax reward and social learning observation model
%
% --------------------------------------------------------------------------------------------------
% Copyright (C) 2012 Christoph Mathys, Andreea Diaconescu TNU, UZH & ETHZ

% Zeta is in logit space, while Beta is in log space.
%
% This file is part of the HGF toolbox, which is released under the terms of the GNU General Public
% Licence (GPL), version 3. You can redistribute it and/or modify it under the terms of the GPL
% (either version 3 or, at your option, any later version). For further details, see the file
% COPYING or <http://www.gnu.org/licenses/>.

% Config structure
c = struct;

% Model name
c.model = 'softmax_reward_no_reward';

% Sufficient statistics of Gaussian parameter priors


% Zeta is in log-space
c.logze1mu = -Inf;
c.logze1sa = 0;

% Beta in log-space
c.logbetamu = log(48);
c.logbetasa = 5^2;

% Gather prior settings in vectors
c.priormus = [
    c.logze1mu,...
    c.logbetamu,...
    ];

c.priorsas = [
    c.logze1sa,...
    c.logbetasa,...
    ];


% Model filehandle
c.obs_fun = @softmax_reward_social_no_reward;

% Handle to function that transforms observation parameters to their native space
% from the space they are estimated in
c.transp_obs_fun = @softmax_reward_social_transp;

return;
