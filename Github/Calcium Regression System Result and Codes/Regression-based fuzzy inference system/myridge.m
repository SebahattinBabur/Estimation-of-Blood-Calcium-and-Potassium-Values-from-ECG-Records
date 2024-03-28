function b = myridge(X,y,lambda)    
% 
% Ridge regression.
%
% b = myridge(X,y,lambda)
%
% INPUT:
%   X,y - data
%   lambda - amount of regularization
%
% OUTPUT:
%   b - coefficients

% 'T2RFIS: Type-2 Regression-based Fuzzy Inference System'
% Developed in MATLAB R2021b
% Author: Krzysztof Wiktorowicz
% E-mail: kwiktor@prz.edu.pl
% To be published: Wiktorowicz K., 'T2RFIS: Type-2 Regression-based 
% Fuzzy Inference System', 2022.

XtX = X'*X;
X1 = XtX + lambda*eye(size(XtX));
b = X1\X'*y;