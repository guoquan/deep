function f_out = hook_before(f, hook)
%hook_before Add a hook function before.
% No parameter support. Consider to use closure to avoid any parameter.
    function hooked()
        hook();
        f();
    end
    f_out = @hooked;
end
