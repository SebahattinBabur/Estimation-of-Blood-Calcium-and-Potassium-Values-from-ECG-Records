function [X,Xl,Xu] = regmat2(x,centers,widths,dists,wl,wu)
%
% Regression matrix for observation data.
%
% INPUT:
%   x - input data
%   centers - centers of membership functions
%   widths - widths of membership functions
%   dists - distances of membership functions
%   wl, wu - weights for regression matrices
%
% OUTPUT:
%   X - regression matrix
%   Xl - lower regression matrix
%   Xu - upper regression matrix

% 'T2RFIS: Type-2 Regression-based Fuzzy Inference System'
% Developed in MATLAB R2021b
% Author: Krzysztof Wiktorowicz
% E-mail: kwiktor@prz.edu.pl
% To be published: Wiktorowicz K., 'T2RFIS: Type-2 Regression-based 
% Fuzzy Inference System', 2022.

% number of inputs
m = size(x,2);

% number of fuzzy sets
p = size(centers,1);

Xl = [];
Xu = [];

for j = 1:m
    % lower and upper widths
    widthsl = widths;
    widthsu = widthsl + dists;
           
    % membership grades
    Axl = gauss(x(:,j),centers(:,j),widthsl(:,j));
    Axu = gauss(x(:,j),centers(:,j),widthsu(:,j));
            
    % fuzzy basis functions
    xil = Axl./sum(Axl,2);
    xiu = Axu./sum(Axu,2);
    
    % lower and upper regression matrices
    Xl = [Xl,xil];
    Xu = [Xu,xiu];
end

% regression matrix
X = (wl*Xl + wu*Xu)/(wl + wu);
