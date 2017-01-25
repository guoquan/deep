function [ f ] = layer_input(layer)

    function setup(options)
        if ischar(layer.input) % data from a file
            s = load(layer.input);
            layer.data = s.data;
        elseif ismatrix(layer.input) % in-memory data
            layer.data = layer.input;
        elseif isstruct(layer.input) % from another layer?
            % pass
        else % what else?
            % pass
        end
        layer.offset = 0;
    end

    function output = forward(opt_param, activation, options)
        s_start = layer.offset + 1;
        s_end = min(size(layer.data, 2), layer.offset + layer.minibatch);
        output = double(reshape( ...
            layer.data(:, s_start:s_end), ...
            [layer.output_size(:)' layer.minibatch]));
        layer.offset = layer.offset + layer.minibatch;
        if layer.offset > size(layer.data, 2)
            layer.offset = 0;
        end
    end

    f.setup = @setup;
    f.forward = @forward;
    %f.backward = []; % no backward
    f.layer = @()(layer);
end
