function [varargout] = strfunc( func, str_in, varargin )
    cstr = cellstr(str_in);
    varargout = cell(1, nargout);
    [varargout{:}] = cellfun(func, cstr, varargin{:});
end
