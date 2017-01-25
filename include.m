%include include all sub folders in the project

% get DEEP root identified by include script
[deep_root, ~, ~] = fileparts(mfilename('fullpath'));

% add to path
all_paths = genpath(deep_root);
addpath(all_paths);

global env
env.verbose = 'INFO'; % ERROR, WARN, INFO, DEBUG, VERBOSE
env.deep.version = '0.0.0.1';
env.deep_root = deep_root;
