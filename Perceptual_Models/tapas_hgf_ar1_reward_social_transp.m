function [pvec, pstruct] = tapas_hgf_ar1_reward_social_transp(r, ptrans)
% --------------------------------------------------------------------------------------------------
% Copyright (C) 2012-2013 Christoph Mathys, TNU, UZH & ETHZ
%
% This file is part of the HGF toolbox, which is released under the terms of the GNU General Public
% Licence (GPL), version 3. You can redistribute it and/or modify it under the terms of the GPL
% (either version 3 or, at your option, any later version). For further details, see the file
% COPYING or <http://www.gnu.org/licenses/>.

pvec    = NaN(1,length(ptrans));
pstruct = struct;

l = r.c_prc.n_levels;

pvec(1:l)           = ptrans(1:l);                       % mu_0_r
pstruct.mu_0_r      = pvec(1:l);
pvec(l+1:2*l)       = exp(ptrans(l+1:2*l));              % sa_0_r
pstruct.sa_0_r      = pvec(l+1:2*l);
pvec(2*l+1:3*l)     = tapas_sgm(ptrans(2*l+1:3*l),1);    % phi_r
pstruct.phi_r       = pvec(2*l+1:3*l);
pvec(3*l+1:4*l)     = ptrans(3*l+1:4*l);                 % m_r
pstruct.m_r         = pvec(3*l+1:4*l);
pvec(4*l+1:5*l-1)   = exp(ptrans(4*l+1:5*l-1));          % ka_r
pstruct.ka_r        = pvec(4*l+1:5*l-1);
pvec(5*l:6*l-1)     = ptrans(5*l:6*l-1);                 % om_r
pstruct.om_r        = pvec(5*l:6*l-1);

pvec(6*l:7*l-1)     = ptrans(6*l:7*l-1);                 % mu_0_a
pstruct.mu_0_a      = pvec(6*l:7*l-1);
pvec((7*l:8*l-1))   = exp(ptrans(7*l:8*l-1));           % sa_0_a
pstruct.sa_0_a      = pvec(7*l:8*l-1);
pvec(8*l:9*l-1)     = tapas_sgm(ptrans(8*l:9*l-1),1);   % phi_a
pstruct.phi_a       = pvec(8*l:9*l-1);
pvec(9*l:10*l-1)    = ptrans(9*l:10*l-1);                % m_a
pstruct.m_a         = pvec(9*l:10*l-1);
pvec(10*l:10*l+1)   = exp(ptrans(10*l:10*l+1));          % ka_a
pstruct.ka_a        = pvec(10*l:10*l+1);
pvec(11*l-1:11*l+1)   = ptrans(11*l-1:11*l+1);                % om_a
pstruct.om_a        = pvec(11*l-1:11*l+1);


% pvec(1:l)         = ptrans(1:l);                           % mu_0_a
% pstruct.mu_0_a      = pvec(1:l);
% pvec(l+1:2*l)     = exp(ptrans(l+1:2*l));                  % sa_0_a
% pstruct.sa_0_a      = pvec(l+1:2*l);
% pvec(2*l+1:3*l)   = tapas_sgm(ptrans(2*l+1:3*l),1);        % phi_a
% pstruct.phi_a       = pvec(2*l+1:3*l);
% pvec(3*l+1:4*l)   = ptrans(3*l+1:4*l);                     % m_a
% pstruct.m_a         = pvec(3*l+1:4*l);
% pvec(4*l+1:5*l-1) = exp(ptrans(4*l+1:5*l-1));              % ka_a
% pstruct.ka_a        = pvec(4*l+1:5*l-1);
% pvec(5*l:6*l-1)   = ptrans(5*l:6*l-1);                     % om_a
% pstruct.om_a        = pvec(5*l:6*l-1);

return;
