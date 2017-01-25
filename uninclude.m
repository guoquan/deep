%uninclude remove the project path (after using) to avoid any side-effect.

% get DEEP root identified by include script
[deep_root, ~, ~] = fileparts(mfilename('fullpath'));

% remove from path
all_paths = genpath(deep_root);
rmpath(all_paths);

clearvars -global env
