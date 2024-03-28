function Ax = gauss(x,c,w)
%
% Gaussian membership function.
%
% Ax = gauss(x,c,w)
%
% INPUT:
%   x - arguments
%   c - centers of membership functions
%   w - widths of membership functions
%
% OUTPUT:
%   Ax - membership values

% 'T2RFIS: Type-2 Regression-based Fuzzy Inference System'
% Developed in MATLAB R2021b
% Author: Krzysztof Wiktorowicz
% E-mail: kwiktor@prz.edu.pl
% To be published: Wiktorowicz K., 'T2RFIS: Type-2 Regression-based 
% Fuzzy Inference System', 2022.

x = x(:);

% number of data
n = length(x);

% number of fuzzy sets
p = length(c);

V = kron(c(:),ones(n,1));
S = kron(w(:),ones(n,1));
X = repmat(x,p,1);       

Ax = exp(-0.5*(((X-V)./S).^2));

Ax = reshape(Ax,n,p);
