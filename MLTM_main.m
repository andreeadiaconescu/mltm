function MLTM_main

options = MLTM_options();

fprintf('\n===\n\t Running the first level analysis:\n\n');
MLTM_first_level(options);

fprintf('\n===\n\t Running the group analyses:\n\n');
MLTM_second_level(options);

end
