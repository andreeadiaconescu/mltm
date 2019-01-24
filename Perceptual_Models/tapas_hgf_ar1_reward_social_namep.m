function pstruct = tapas_hgf_ar1_reward_social_namep(pvec)
% --------------------------------------------------------------------------------------------------
% Copyright (C) 2012-2013 Christoph Mathys, TNU, UZH & ETHZ
%
% This file is part of the HGF toolbox, which is released under the terms of the GNU General Public
% Licence (GPL), version 3. You can redistribute it and/or modify it under the terms of the GPL
% (either version 3 or, at your option, any later version). For further details, see the file
% COPYING or <http://www.gnu.org/licenses/>.
%pvec=pvec
%hallo

pstruct = struct;
l=3
% l = (length(pvec)+1)/12
%     
% if l ~= floor(l)
%     error('tapas:hgf:UndetNumLevels', 'Cannot determine number of levels');
% end

pstruct.mu_0_r      = pvec(1:l);
pstruct.sa_0_r      = pvec(l+1:2*l);
pstruct.phi_r       = pvec(2*l+1:3*l);
pstruct.m_r         = pvec(3*l+1:4*l);
pstruct.ka_r        = pvec(4*l+1:5*l-1);
pstruct.om_r        = pvec(5*l:6*l-1);

pstruct.mu_0_a      = pvec(6*l:7*l-1);
pstruct.sa_0_a      = pvec(7*l:8*l-1);
pstruct.phi_a       = pvec(8*l:9*l-1);
pstruct.m_a         = pvec(9*l:10*l-1);
pstruct.ka_a        = pvec(10*l:10*l+1);
pstruct.om_a        = pvec(11*l-1:11*l+1);

return;
