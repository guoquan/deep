function [ x,cost,exitflag,output ] = minGd( func, x0, option )
%MINGD Summary of this function goes here
%   Detailed explanation goes here

eta = getOpt(option,'eta',1);
maxIter = getOpt(option,'maxIter',500);
tolGrad = getOpt(option,'tolGrad',1e-5);
tolCost = getOpt(option,'tolCost',1e-9);
minCost = getOpt(option,'minCost',1e-9);
display = getOpt(option,'display','on');
fig = getOpt(option,'fig',[]);
fig_intvl = getOpt(option,'fig_intvl',100);
model = getOpt(option,'model',[]);

if strcmp('on',display)
    fprintf('%10s %15s %15s\n','Iteration','Cost','Cost Chagne');
end
    
x = x0;
cost_old = 0;
exitflag = 0;
i_ep = 1;
while i_ep <= maxIter
    [cost, grad] = func(x);
    x = x - eta * grad;
    
    if strcmp('on',display)
        fprintf('%10d %15.5e %15.5e\n',i_ep, cost, cost-cost_old);
        if ~isempty(fig) && ~mod(i_ep,fig_intvl)
            W1 = reshape(x(1:model.hiddenSize*model.visibleSize), model.hiddenSize, model.visibleSize);
            figure(fig);
            display_network(W1', 12);
            print('-djpeg', ['features/feature.' num2str(i_ep, '%08d') '.jpg']);
        end
    end
    
    if sum(abs(grad)) <= tolGrad
        exitflag=1;
        msg = ['Gradiant norm below tolGrad(' num2str(tolGrad) ')'];
        break;
    end
    
    if abs(cost-cost_old) <= tolCost
        exitflag=2;
        msg = ['Cost change below tolCost(' num2str(tolCost) ')'];
        break;
    end
    
    if cost <= minCost
        exitflag=3;
        msg = ['Cost below minCost(' num2str(tolCost) ')'];
        break;
    end
    
    cost_old = cost;
    i_ep = i_ep + 1;
end

if ~exitflag
    msg='Exceeded Maximum Number of Iterations';
end

if strcmp('on',display)
    disp(msg);
end
output.msg = msg;
end

function [v] = getOpt(options,opt,default)
if isfield(options,opt) && ~isempty(options.(opt))
    v = options.(opt);
else
    v = default;
end
end