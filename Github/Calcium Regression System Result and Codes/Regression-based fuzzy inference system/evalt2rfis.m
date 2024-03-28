function yhat = evalt2rfis(x,centers,widths,dists,wl,wu,b,mtype,sidx)
%
% Evaluate the output of RFIS.
%
% yhat = evalt2rfis(x,centers,widths,dists,wl,wu,b,mtype)
% yhat = evalt2rfis(x,centers,widths,dists,wl,wu,b,mtype,sidx)
%
% INPUT:
%   x - input data
%   centers - centers of membership functions
%   widths - widths of membership functions
%   dists - distances of membership functions
%   wl, wu - weights for regression matrices
%   b - system function coefficients
%   mtype - type of regression model
%   sidx - indices of selected features
%
% OUTPUT:
%   yhat - predicted output

% 'T2RFIS: Type-2 Regression-based Fuzzy Inference System'
% Developed in MATLAB R2021b
% Author: Krzysztof Wiktorowicz
% E-mail: kwiktor@prz.edu.pl
% To be published: Wiktorowicz K., 'T2RFIS: Type-2 Regression-based 
% Fuzzy Inference System', 2022.

% regression matrix
X = regmat2(x,centers,widths,dists,wl,wu);

% design matrix
D = desmat(X,mtype);

% predict the output
if nargin == 8
    sidx = 1:size(D,2);
end
Dtmp = D(:,sidx);
yhat = Dtmp*b;
