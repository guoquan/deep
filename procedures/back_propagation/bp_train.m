function [ opt_param ] = bp_train( param, network, options )
%BP_TRAIN Summary of this function goes here
%   Detailed explanation goes here

logv('BP: Prepare BP training. ');

global env

options = fill_defaults(options);

env.bp_options = options;
env.iter = 0;
last_grad = 0;
opt_param = param;
activation = [];
while ~options.converge(env)
    logi(['BP: Iteration ' num2str(env.iter)]);
    
    cost = network.cost.behave.forward(opt_param, activation, options);
    logi(['BP: Cost = ' num2str(cost)]);
    
    grad = network.cost.behave.backward(cost, opt_param, sensitivity, activation, options);
    
    last_grad = options.momentum * last_grad + (1 - options.momentum) * grad;
    opt_param = opt_param - options.learning_rate * last_grad;
    
    env.iter = env.iter + 1;
end
end

function out_options = fill_defaults(in_options)
default.method = 'sgd';
default.learning_rate = 1;
default.momentum = 0.9;
default.converge = @(env)(env.iter > env.bp_options.max_iter);
default.max_iter = 100;

out_options = default;
f_list = fieldnames(in_options);
for i=1:length(f_list)
    f = f_list{i};
    out_options.(f) = in_options.(f);
end
end
