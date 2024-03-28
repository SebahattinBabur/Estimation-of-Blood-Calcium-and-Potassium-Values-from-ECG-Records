%
% Multi-objective optimization for T2RFIS model.
% 
% This file saves the results for mpg_optim.

% 'T2RFIS: Type-2 Regression-based Fuzzy Inference System'
% Developed in MATLAB R2021b
% Author: Krzysztof Wiktorowicz
% E-mail: kwiktor@prz.edu.pl
% To be published: Wiktorowicz K., 'T2RFIS: Type-2 Regression-based 
% Fuzzy Inference System', 2022.

clear all

% load data and settings
mpg_init

% for reproducibility
rng default  

% number of variables
nvars = length([centers0(:)',widths0(:)',dists0(:)',1,1,1,1]);

% population size
PopSize = nvars;

% maximal number of iterations
MaxIter = 50;

% only for sizes
X0 = regmat2(xt,centers0,widths0,dists0,1,1);
D0 = desmat(X0,mtype);

% initial population matrix
M = [];
for i = 1:1
    M(i,1:nvars) = ...
        [centers0(:)',widths0(:)',dists0(:)',1,size(D0,2),1,1];
end

% objective function
fun = @(x)mpg_objfun(x,xt,yt,xv,yv,p,m,lambda,mtype,fstype);

% bounds
xmn = repmat(xmin',1,p)';
wmn = repmat(wmin',1,p)'; 
dmn = repmat(dmin',1,p)'; 

xmx = repmat(xmax',1,p)';
wmx = repmat(wmax',1,p)'; 
dmx = repmat(dmax',1,p)'; 

lb = [xmn(:)',wmn(:)',dmn(:)',1,1,.1,.1];
ub = [xmx(:)',wmx(:)',dmx(:)',20,size(D0,2),1.2,1.2];

% MGA options
options = optimoptions('gamultiobj','PlotFcn','gaplotpareto',...
    'InitialPopulationMatrix',M,'MaxGenerations',MaxIter,...
    'MaxStallGenerations',MaxIter,'PopulationSize',PopSize);

rm = [];
tt = [];

% 10 runs of the MGA algorithm
for k = 1:10,k
    tic
    [x{k},y{k},~,out] = ...
        gamultiobj(fun,nvars,[],[],[],[],lb,ub,options);
    rm(k) = min(y{k}(:,2))
    tt(k) = toc;
end

disp('==============')
mean(rm)
disp('==============')
mean(tt)

save mpg
