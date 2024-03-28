clear all

% Data and settings.

% 'T2RFIS: Type-2 Regression-based Fuzzy Inference System'
% Developed in MATLAB R2021b
% Author: Krzysztof Wiktorowicz
% E-mail: kwiktor@prz.edu.pl
% To be published: Wiktorowicz K., 'T2RFIS: Type-2 Regression-based 
% Fuzzy Inference System', 2022.

% The data can be downloaded from:
% https://archive.ics.uci.edu/ml/datasets/auto+mpg
% Original data-set contains 398 rows, but the records 
% with missing values have been removed, so we have 
% 392 rows

%load mpg;
load('calcium.mat')
data = autompg;

% number of inputs
m = 10;

cvp = cvpartition(size(data, 1), 'Holdout', 0.30);

% input and output data
xd = data(:,2:m+1);
yd = data(:,1);

% traning data
xt = xd(cvp.training,:); 
yt = yd(cvp.training,:); 

% validation data
xv = xd(cvp.test,:); 
yv = yd(cvp.test,:);

% number of records
N = size(xd,1);


% data plot
xxt = find(cvp.training==1);
xxv = find(cvp.test==1);

figure(1)
set(gcf,'Position',[360 390 560 230])
clf
bar(xxt,yt,.5,'FaceColor',[0.8500,0.3250,0.0980])
hold on
bar(xxv,yv,.5,'FaceColor',[0,0.4470,0.7410])
hold off
grid
xlabel("index of the dataset")
ylabel("MPG")
legend({"Training data","Validation data"},'Location','NorthWest')

% number of fuzzy sets
p = 3;

% amount of regularization
lambda = 1e-3; 

% minimal and maximal values
xmin = min([xt;xv]);
xmax = max([xt;xv]);

% initial distribution of fuzzy sets
dx = (xmax-xmin)/(p-1);
centers0 = [];
for i = 1:m
    centers0 = [centers0,(xmin(i):dx(i):xmax(i))'];
end
widths0 = ones(1,p)'*(dx/(2*sqrt(-2*log(0.5))));
dists0 = zeros(p,m);

% bounds for widths
wmin = widths0(1,:)/5;
wmax = widths0(end,:)*2;

% bounds for distances
dmin = 0*ones(1,m);
dmax = .55*(wmax-wmin);

% type of regression function
mtype = 'interactions';

% type of feature selection method
fstype = 'ftest';
