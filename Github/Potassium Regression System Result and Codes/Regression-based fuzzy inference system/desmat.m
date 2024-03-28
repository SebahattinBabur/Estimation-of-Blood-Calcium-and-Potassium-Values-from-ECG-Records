function D = desmat(X,mtype)
%
% Design matrix for the regression matrix.
%
% D = desmat(X,mtype)
%
% INPUT:
%   X - regression matrix
%   mtype - model type
%
% OUTPUT:
%   D - design matrix

% 'T2RFIS: Type-2 Regression-based Fuzzy Inference System'
% Developed in MATLAB R2021b
% Author: Krzysztof Wiktorowicz
% E-mail: kwiktor@prz.edu.pl
% To be published: Wiktorowicz K., 'T2RFIS: Type-2 Regression-based 
% Fuzzy Inference System', 2022.

% slower
% mdl = fitlm(X,y,mtype,'intercept',false);
% D = mdl.Design;

% faster
D = x2fx(X,mtype); 
% without intercept (without first column)
D = D(:,2:end);
