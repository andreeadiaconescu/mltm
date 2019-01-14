function display_substruct(ttests_sample)

% display_substruct displays second order parameters of structs

for f=fields(ttests_sample)'
    for g = fields(ttests_sample.(f{:}))'
        fprintf('\n=====\n\t%s.%s\n', f{:},g{:});
        ttests_sample.(f{:}).(g{:})
    end
end