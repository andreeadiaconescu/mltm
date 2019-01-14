function logp = softmax_reward_social(r, infStates, ptrans)
% Calculates the log-probability of response y=1 under the IOIO response model with constant
% weight zeta_1
%
% --------------------------------------------------------------------------------------------------
% Copyright (C) 2012 Christoph Mathys, TNU, UZH & ETHZ
%
% This file is part of the HGF toolbox, which is released under the terms of the GNU General Public
% Licence (GPL), version 3. You can redistribute it and/or modify it under the terms of the GPL
% (either version 3 or, at your option, any later version). For further details, see the file
% COPYING or <http://www.gnu.org/licenses/>.

% Transform zetas to their native space
ze1 = exp(ptrans(1));
beta = exp(ptrans(2));

% Initialize returned log-probabilities, predictions,
% and residuals as NaNs so that NaN is returned for all
% irregualar trials
n = size(infStates,1);

% lara change
% blue_correct = r.u(:,1);
% advice_correct = r.u(:,2);

blue_correct = r.u(:,1);
advice_correct = r.u(:,2);
blue_value=r.u(:,3);
green_value=r.u(:,4);


for k= 1:length(blue_correct);
if blue_correct(k,:)== 1 && advice_correct(k,:)==1
    gaze(k,1)=1; 
elseif blue_correct(k,:)== 1 && advice_correct(k,:)==0
     gaze(k,1)=0;
elseif blue_correct(k,:)== 0 && advice_correct(k,:)==1
     gaze(k,1)=0;
elseif blue_correct(k,:)== 0 && advice_correct(k,:)==0
     gaze(k,1)=1;
         end
end

% now that we know where gaze looked at, we can extract expected reward values when follow gaze
% vs expected reward when not follow gaze


for k= 1:length(blue_correct);
if gaze(k,:) == 1 ; % if gaze looks to blue card
    expr_gaze(k,:)=blue_value(k,:); % expected reward if follow gaze
    expr_nogaze(k,:)=green_value(k,:); % expected reward if not follow gaze
elseif gaze(k,:) == 0; % if gaze looks to green card
       expr_gaze(k,:)=green_value(k,:);
       expr_nogaze(k,:)=blue_value(k,:);
end
end

expr_gaze(r.irr) = []; % remove irr. trials
expr_nogaze(r.irr) = [];
gaze(r.irr) = [];



gaze(r.irr) = [];


% lara change stop

% Initialize returned log-probabilities as NaNs so that NaN is
% returned for all irregualar trials
logp = NaN(length(infStates),1);

% Weed irregular trials out from inferred states, cue inputs, and responses
x_r = infStates(:,1,1);
x_r(r.irr) = [];

x_a = infStates(:,1,3);
x_a(r.irr) = [];

mu3_hat_r = infStates(:,3,1);
mu3_hat_r(r.irr) = [];

mu3_hat_a = infStates(:,3,3);
mu3_hat_a(r.irr) = [];

sa2hat_r = infStates(:,2,2);
sa2hat_r(r.irr) = [];

sa2hat_a = infStates(:,2,4);
sa2hat_a(r.irr) = [];

y = r.y(:,1);
y(r.irr) = [];

% Precision (i.e., Fisher information) vectors
px = 1./(x_a.*(1-x_a));
pc = 1./(x_r.*(1-x_r));

% Weight vectors
%% Version 1
wx = ze1.*px./(ze1.*px + pc); % precision first level
wc = pc./(ze1.*px + pc);
%% Version 2
% wx = ze1.*1./sa2hat_a.*px./(ze1.*px.*1./sa2hat_a + pc.*1./sa2hat_r);
% wc = pc.*1./sa2hat_r./(ze1.*px.*1./sa2hat_a + pc.*1./sa2hat_r);

%% Version 3
% beta=exp(-mu3_hat_r)+exp(-mu3_hat_a);
% beta=exp((-mu3_hat_r)+exp(-mu3_hat_a)+(log(beta)));
beta=exp((log(beta)));
%%


% lara change again
% as a next step, x_r (muhat1card) needs to be translated into gaze space.
% if gaze looks to green card we must replace x_r with 1-x_r
% if gaze looks to blue card x_r remains as it is

for k= 1:length(gaze);
if gaze(k,:)==0;
    x_r(k,:)=1-x_r(k,:);
elseif gaze(k,:)==1;
    x_r(k,:)=x_r(k,:);
end
end
%lara change stop

% Belief vector
b = wx.*x_a + wc.*x_r;

% OLD VERSION - NO CARD VALUES
% Calculate log-probabilities for non-irregular trials
% logp(not(ismember(1:length(logp),r.irr))) = y.*beta.*log(b./(1-b)) +log((1-b).^beta ./((1-b).^beta +b.^beta));
% prob = b.^(beta)./(b.^(beta)+(1-b).^(beta));

% prob = 1./(1+exp(-beta.*(expr_gaze.*b-expr_nogaze.*(1-b)).*(2.*y-1)));
% reg = ~ismember(1:n,r.irr);
% logp(reg) = log(prob);

x    = b;
logx = log(x);
log1pxm1 = log1p(x-1);
logx(1-x<1e-4) = log1pxm1(1-x<1e-4);
log1mx = log(1-x);
log1pmx = log1p(-x);
log1mx(x<1e-4) = log1pmx(x<1e-4);

% Calculate log-probabilities for non-irregular trials
reg = ~ismember(1:n,r.irr);
logp(reg) = y.*beta.*(logx -log1mx) +beta.*log1mx -log((1-x).^beta +x.^beta);
return;
