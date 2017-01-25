function [ pass ] = test_back_propagation( )
%TEST_BACK_PROPAGATION

global env

layer_in.behave = layer_input;
layer_in.input = 'data/mnist/sample';
layer_in.output = 'input';
layer_in.output_size = [16 16];

layer_label.behave = layer_input;
layer_label.input = 'data/mnist/label';
layer_label.output = 'input';
layer_label.output_size = 1;

layer_fc1.behave = layer_fc;
layer_fc1.input = layer_in;
layer_fc1.output = 'fc1';
layer_fc1.output_size = [4 4];

layer_sgm1.behave = layer_sigmoid;
layer_sgm1.input = layer_fc1;
layer_sgm1.output = 'sgm1';

layer_fc2.behave = layer_fc;
layer_fc2.input = layer_sgm1;
layer_fc2.output = 'fc2';
layer_fc2.output_size = [4 4];

layer_sm.behave = layer_softmax;
layer_sm.input = layer_fc2;
layer_sm.output = 'sgm1';
layer_sm.output_size = 10;

layer_cost.behave = layer_euclidean_dist;
layer_cost.input = [layer_sm layer_label];
layer_cost.output = 'cost';
layer_cost.output_size = 1;

network.layers = {
    layer_input
    layer_label
    layer_fc1
    layer_sgm1
    layer_fc2
    layer_sm
    };
network.cost = layer_cost;

env.verbose = 'INFO'; % Level of display [ ERROR, WARN, INFO, DEBUG, VERBOSE ]

%pipeline = setup_pipeline(network, []);
%pipeline.run();

opt_param = bp_train([], network, []);

pass = true;

end

