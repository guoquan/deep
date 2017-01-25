function log_message( level, message )
%LOG_MESSAGE Show log message according to env setting
global env
if get_num_level(env.verbose) >= get_num_level(level)
    fprintf('%s (%s): %s\n', datestr(now, 'yyyy-mm-dd HH:MM:SS.FFF'), level, message);
end
end

function [ num_level ] = get_num_level( level )
switch level % ERROR, WARN, INFO, DEBUG, VERBOSE
    case 'ERROR'
        num_level = 1;
    case 'WARN'
        num_level = 2;
    case 'INFO'
        num_level = 3;
    case 'DEBUG'
        num_level = 4;
    case 'VERBOSE'
        num_level = 5;
    otherwise
        warning(['Unexpected log level ''' level '''. Use default (''INFO'').']);
        num_level = 3;
end
end