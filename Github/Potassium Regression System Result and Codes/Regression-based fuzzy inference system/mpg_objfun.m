function [y,sidx,centers,widths,dists,b,wl,wu] = ...
    mpg_objfun(x,xt,yt,xv,yv,p,m,lambda,mtype,fstype)

% Objective function for T2RFIS model.
%
% INPUT:
%   x - an individual
%   xt, yt - training data
%   xv, yv - validation data
%   p - number of fuzzy sets
%   m - number of inputs
%   lambda - amount of regularization
%   mtype - model type
%   fstype - feature selection method
%
% OUTPUT:
%   y - objective function values
%   sidx - indices of features
%   centers - centers of membership functions
%   widths - widths of membership functions
%   dists - distances of membership functions
%   b - system function parameters
%   wl, wu - weights for regression matrices

% 'T2RFIS: Type-2 Regression-based Fuzzy Inference System'
% Developed in MATLAB R2021b
% Author: Krzysztof Wiktorowicz
% E-mail: kwiktor@prz.edu.pl
% To be published: Wiktorowicz K., 'T2RFIS: Type-2 Regression-based 
% Fuzzy Inference System', 2022.

% decode an individual
centers = x(1:p*m);
widths = x(p*m+1:2*p*m);
dists = x(2*p*m+1:end-4);
q1 = round(x(end-3));
q2 = round(x(end-2));
wl = x(end-1);
wu = x(end);

% parameters of membership functions
centers = reshape(centers,p,m);
widths = reshape(widths,p,m);
dists = reshape(dists,p,m);

% regression matrix for training data
Xt = regmat2(xt,centers,widths,dists,wl,wu);

% design matrix for training data
Dt = desmat(Xt,mtype);

% feature selection
if fstype == 'ftest'
    idx = fsrftest(Dt,yt,'NumBins',q1);
elseif fstype == 'rtree'
    tree = fitrtree(Dt,yt,'MinLeafSize',q1);
    imp = predictorImportance(tree);
    [~,idx] = sort(imp,'descend');
end

% select feature indices
sidx = idx(1:q2);

% ridge regression
Dtf = Dt(:,sidx);
b = myridge(Dtf,yt,lambda);

% predict the output
yhat = evalt2rfis(xv,centers,widths,dists,wl,wu,b,mtype,sidx);

% objective functions
y(1) = length(sidx);
y(2) = sqrt(mean((yhat-yv).^2));
