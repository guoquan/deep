function phase_handle = setup_phase(phase_, precedings_, raw_model_, name_)
    % use closure to maintain phase config and its model
    
    % short summary of phase_handle
    % model:        @setup_phase/get_model
    % update_model: @setup_phase/update_model (! deprecated)
    % done:         @setup_phase/get_status
    % run:          phase.behave(...) (+ pre hook) (+ post hook)
    % reset:        @setup_phase/reset
    % reg_reset:    @setup_phase/reg_reset
    
    % summary of en-closure variables
    % en-closure variables always end with '_'
    % phase_:
    % precedings_:
    % model_:
    % name_:
    % done_:
    % reset_list_:
    
    logi(['Setup phase ' name_ '.']);
    
    % status of the phase
    done_ = false;
    function done = get_status()
        done = done_;
    end
    phase_handle.done = @get_status;
    
    model_ = extract_phase(raw_model_, name_);
    % model is the only DYNAMIC property of phase.
    % modification(s) to other properties outside the closure will not be
    % update back to the en-closure memory
    function model = get_model()
        checke(done_, ['Error try to get ' name_ '.model() before ' name_ '.run()!']);
        model = model_;
    end
    phase_handle.model = @get_model;    
    function update_model(model)
        model_ = model;
    end
    phase_handle.update_model = @update_model;
    
    % add run() callback
    function model = get_model_now()
        model = model_;
    end
    phase_handle.run = phase_.behave(phase_, @get_model_now, @update_model);
    
    function migrate(prec_name)
        logi(['Migrate model from ' prec_name ' to '  name_ '.']);
        checke(isfield(precedings_, prec_name), ...
            ['Can''t find preceding phase ' prec_name ' for ' name_ '!']);
        prec_model = precedings_.(prec_name).model();
        model_ = migrate_phase(model_, prec_model);
    end
    function pre_run_hook()
        logi(['Prepare phase ' name_ '.']);
        % fill precedent phase results
        if isfield(phase_, 'prec')
            strfunc(@migrate, phase_.prec);
        end
        % prepare done, go ahead
        logi(['Invoke phase ' name_ '.']);
    end
    function post_run_hook()
        done_ = true;
    end
    phase_handle.run = hook_before(phase_handle.run, @pre_run_hook);
    phase_handle.run = hook_after(phase_handle.run, @post_run_hook);
    
    reset_list_ = {};
    function reset()
        if done_
            logv(['Reset dependents of ' name_ '.']);
            % reset dependents
            for reset_idx = 1:numel(reset_list_)
                reset_list_{reset_idx}();
            end

            logi(['Reset phase ' name_ '.']);
            % extract setting for this phase
            model_ = extract_phase(raw_model_, name_);
            done_ = false;
        else
            logw(['Reset ' name_ ' before run().']);
        end
    end
    phase_handle.reset = @reset;
    function reg_reset(reset)
        reset_list_{numel(reset_list_) + 1} = reset;
    end
    phase_handle.reg_reset = @reg_reset;
    
    function add_to_prec(prec_name)
        logi(['Regist reset callback for ' name_  ' to ' prec_name '.']);
        checke(isfield(precedings_, prec_name), ...
            ['Can''t find preceding phase ' prec_name ' for ' name_ '!']);
        precedings_.(prec_name).reg_reset(@reset);
    end
    if isfield(phase_, 'prec')
        strfunc(@add_to_prec, phase_.prec);
    end
end

function obj = extract_phase(obj, phase_name)
    % replace node with phase specified config
    if isfield(obj, phase_name)
        obj = obj.(phase_name);
    end
    
    if iscell(obj) % process cell arrays
        for idx = 1:numel(obj)
            obj{idx} = extract_phase(obj{idx}, phase_name);
        end
    elseif size(obj, 1) * size(obj, 2) > 1 && ~ischar(obj) % process numerical and struct arrays
        for idx = 1:numel(obj)
            obj(idx) = extract_phase(obj(idx), phase_name);
        end
    elseif isstruct(obj) % process single node
        fs = fieldnames(obj);
        for f_idx = 1:numel(fs)
            f = fs{f_idx};
            obj.(f) = extract_phase(obj.(f), phase_name);
        end
    end % pass everything else
end

function obj = migrate_phase(obj, pre_obj)
    if isstruct(pre_obj)
        fs = fieldnames(pre_obj);
        for f_idx = 1:numel(fs)
            f = fs{f_idx};
            if ~isfield(obj, f)
                obj.(f) = pre_obj.(f);
            else
                obj.(f) = migrate_phase(obj.(f), pre_obj.(f));
            end
        end
    end
end