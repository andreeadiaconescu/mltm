function details = MLTM_subject_details(id,options)

details = [];

details.dirSubject            = sprintf(str2num(id));
details.subjectdataroot       = fullfile(options.dataroot,details.dirSubject);
details.subjectresultsroot    = fullfile(options.resultroot, details.dirSubject);
details.behav.pathResults     = fullfile(details.subjectresultsroot, 'behav');
details.behav.invertSIBAKName = [details.dirSubject,options.model.perceptualModels];

% Create subjects results directory for current preprocessing strategy
[~,~] = mkdir(details.subjectresultsroot);
[~,~] = mkdir(details.behav.pathResults);

% File names
details.task.file     = fullfile(details.subjectdataroot,['out_', details.dirSubject , '.txt']);
end