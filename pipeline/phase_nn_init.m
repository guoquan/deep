function run = phase_nn_init(phase_, model_, update_model_)
%PHASE_NN_INIT 
    function run_handle()
        layers = model_();
        % each direct node is a layer
        
        layer_names = fieldnames(layers);
        for layer_idx = 1:numel(layer_names)
            key = layer_names{layer_idx};
            layers.(key) = layers.(key).behave(layers.(key), key); % initiate layer
        end
        
        update_model_(layers);
    end
    run = @run_handle;
end
