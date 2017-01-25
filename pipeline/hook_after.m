function f_out = hook_after(f, hook)
%hook_after Add a hook function after.
% No parameter support. Consider to use closure to avoid any parameter.
    function hooked()
        f();
        hook();
    end
    f_out = @hooked;
end
