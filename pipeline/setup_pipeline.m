function [ pipeline ] = setup_pipeline(phases, model)
%SETUP_PIPELINE Scaffold the pipeline and initial the run() callbacks.
    
    % pipeline summary
    % run:              @setup_pipeline/run
    % graph:            @setup_pipeline/get_graph
    % heads:            @setup_pipeline/heads
    % <phase_names>*:   phase_handle = setup_phase(...)
    
    % en-closure variables
    % phase_names_:
    % graph_:
    % order_:
    % phase_handles_:
    % head_in_:
    % head_out_:
    
    phase_names_ = fieldnames(phases);
    logd(['Total number of phases: ' num2str(numel(phase_names_))]);
    logv('Phases: ');
    for phase_idx = 1:numel(phase_names_)
        logv([num2str(phase_idx) ' -> ' phase_names_{phase_idx}]);
    end
    
    % construct a graph to determine dependency (also check for acyclic)
    logi('Construct phases graph.');
    graph_ = logical(sparse(numel(phase_names_), numel(phase_names_)));
    function find_depend(phase_idx, prec_name)
        % add a edge from preceding phase to current
        graph_(strcmp(prec_name, phase_names_), phase_idx) = 1;
    end
    for phase_idx = 1:numel(phase_names_)
        phase = phases.(phase_names_{phase_idx});
        if isfield(phase, 'prec');
            strfunc(@(prec_name)(find_depend(phase_idx, prec_name)), phase.prec);
        end
    end
    logd(['Phase Graph: ' mat2str(graph_)]);
    logv(['Graph: ' num2str(1:numel(phase_names_))]);
    for phase_idx = 1:numel(phase_names_)
        logv([phase_names_{phase_idx} '(' num2str(phase_idx) ') - ' num2str(graph_(:, phase_idx)')]);
    end
    
    % do a topological sort to get a processing order
    logi('Topological sort the phases graph.');
    try
        % this function is from The MathWorks, Inc. MATLAB Bioinformatics Toolbox
        order_ = graphtopoorder(graph_);
    catch err
        loge([err.message '\n' ...
            'Phases dependency cannot be validated to be a DAG (directed acyclic graph).']);
    end
    logd(['Phase order: ' num2str(order_)]);
    logv(['Order: ' num2str(order_)]);
    for ord_idx = 1:numel(order_)
        logv([phase_names_{order_(ord_idx)} '(' num2str(order_(ord_idx)) ') - ' num2str(graph_(:, order_(ord_idx))')]);
    end
    
    % setup each phase
    phase_handles_ = struct();
    for order_idx = 1:numel(order_)
        phase_idx = order_(order_idx);
        name = phase_names_{phase_idx};
        phase = phases.(name);
        
        % prepare precedings
        precedings = struct();
        prec_idxs = find(graph_(:, phase_idx));
        for prec_idx = 1:numel(prec_idxs)
            prec_name = phase_names_{prec_idxs(prec_idx)};
            precedings.(prec_name) = phase_handles_.(prec_name);
        end
        
        % setup hooks
        phase_handles_.(name) = setup_phase(phase, precedings, model, name);
        pipeline.(name) = phase_handles_.(name);
    end
    
    % setup the run callback
    function run()
        for idx = 1:numel(order_)
            phase_handle = phase_handles_.(phase_names_{order_(idx)});
            if ~phase_handle.done()
            	phase_handle.run();
            end
        end
    end
    pipeline.run = @run;
    
    % graph callback
    function graph = get_graph()
        graph = graph_;
    end
    pipeline.graph = @get_graph;
    
    head_in_ = find(~any(graph_, 1));
    head_out_ = find(~any(graph_, 2));
    function [head_in, head_out] = heads()
        head_in = head_in_;
        head_out = head_out_;
    end
    pipeline.heads = @heads;
    
    function status = get_status()
        status = false(1, numel(phase_names_));
        for idx = 1:numel(order_)
            phase_handle = phase_handles_.(phase_names_{order_(idx)});
            status(order_(idx)) = phase_handle.done();
        end
        
        logd(['Phase status: ' num2str(status)]);
        logv([' Phase: ' num2str(order_)]);
        logv(['Status: ' num2str(status)]);
        for idx = 1:numel(order_)
            logv([phase_names_{order_(idx)} '(' num2str(order_(idx)) ') - ' num2str(graph_(:, order_(idx))')]);
        end
    end
    pipeline.status = @get_status;
end
