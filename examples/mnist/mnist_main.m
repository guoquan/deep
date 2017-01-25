% clean start
close all
clearvars all
clc

include % make sure every one on board

%global env

% define layers
layers.input.behave = @layer_input; 
layers.input.source.train = 'data/mnist/train-images-idx3-ubyte.mat';
layers.input.source.test = 'data/mnist/t10k-images-idx3-ubyte.mat';
layers.input.output.minibatch.train = 1000;
layers.input.output.minibatch.test = 10000;
layers.input.output.size = [28 28];

layers.label_in.behave = @layer_input;
layers.label_in.source.train = 'train-labels-idx1-ubyte';
layers.label_in.source.test = 'data/mnist/t10k-labels-idx1-ubyte.mat';
layers.label_in.output.minibatch.train = 1000;
layers.label_in.output.minibatch.test = 10000;
layers.label_in.output.size = 1;

layers.label.behave = @layer_expand;
layers.label.input = 'label_in';
layers.label.output_size = 10;

layers.fc1.behave = @layer_fc;
layers.fc1.input = 'label';
layers.fc1.output.size = 200;

layers.sgm1.behave = @layer_sigmoid;
layers.sgm1.input = 'fc1';

layers.fc2.behave = @layer_fc;
layers.fc2.input = 'sgm1';
layers.fc2.output.size = 10;

layers.pred.behave = @layer_softmax;
layers.pred.input = 'fc2';

layers.cost.behave = @layer_euclidean_dist;
layers.cost.input = {'pred' 'label'};

% define phases
phases.init.behave = @phase_init;

phases.train.behave = @phase_train;
phases.train.prec = 'init';
phases.train.cost = layer_cost;

phases.test.behave = @phase_test;
phases.test.prec = 'train';

% scaffold the pipeline
pipeline = setup_pipeline(phases, layers);

% run
pipeline.run(); % or pipeline.init.run(); pipeline.train.run(); pipeline.test.run()
