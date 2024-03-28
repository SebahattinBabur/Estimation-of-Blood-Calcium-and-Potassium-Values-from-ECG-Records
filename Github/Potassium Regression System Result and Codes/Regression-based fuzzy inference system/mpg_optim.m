%
% Selecting solution for multi-objective optimization 
% for the T2RFIS model.
% 
% This file opens the results generated in mpg_main.

% 'T2RFIS: Type-2 Regression-based Fuzzy Inference System'
% Developed in MATLAB R2021b
% Author: Krzysztof Wiktorowicz
% E-mail: kwiktor@prz.edu.pl
% To be published: Wiktorowicz K., 'T2RFIS: Type-2 Regression-based 
% Fuzzy Inference System', 2022.

clear all

warning off

load mpg

rmse = [];
xs = [];
ys = [];

for k = 1:10
    [~,ixs] = min(y{k}(:,2));
    rmse(k) = y{k}(ixs,2);
    xs{k} = x{k}(ixs,:);
    ys{k} = y{k}(ixs,:);
end

% find the model closest to the mean RMSE
[~,kx] = min(abs(rmse-mean(rmse)));

figure(2)
plot(y{kx}(:,1),y{kx}(:,2),'b*'),grid
xlabel('number of features' )
ylabel('RMSE')
title('Pareto front')
set(gcf,'Position',[360 390 560 230])

[~,sidx,centers,widths,dists,b,wl,wu] = ...
    mpg_objfun(xs{kx},xt,yt,xv,yv,p,m,lambda,mtype,fstype);

% model parameters
Xt = regmat2(xt,centers,widths,dists,wl,wu);
mdl = fitlm(Xt,yt,mtype,'intercept',false);
% number of all features
Nall = size(mdl.Coefficients(:,:),1)
[B,I] = sortrows([array2table(sidx'),mdl.Coefficients(sidx,:)]);
% features
B 
% coefficients of features
b(I)

% results for the selected model
ys{kx}

% plot results

% predictions for validation data
yhatv = evalt2rfis(xv,centers,widths,dists,wl,wu,b,mtype,sidx);

figure(3)
subplot(211)
hold on
bar(yv,'FaceColor',[0.8500,0.3250,0.0980])
bar(yhatv,'FaceColor',[0,0.4470,0.7410])
hold off
xlabel("index of the validation dataset")
ylabel("MPG")
legend({"Real MPG","Predicted MPG"},'Location','NorthWest')
subplot(212)
bar(yv-yhatv)
xlabel("index of the validation dataset")
ylabel("prediction error")
shg

% plot membership functions    
widthsl = widths;
widthsu = widthsl + dists;
xg = centers - 3*widthsl;

fis = sugfistype2;

for j = 1:m
    fis = addInput(fis,[xmin(j),xmax(j)],'Name',['x',num2str(j)]);

    for i = 1:p
        lg(i,j) = gauss(xg(i,j),centers(i,j),widthsu(i,j));
        fis = addMF(fis,['x',num2str(j)],'gaussmf', ...
            [widthsu(i,j),centers(i,j)],...
            'LowerLag',lg(i,j),'Name',['A',num2str(i)]);
    end
end

figure(4)
subplot(211)
plotmf(fis,'input',1),shg
grid
axis([xmin(1),xmax(1),0,1.2])
h = gca;
set(findall(h,'Type','Line'),'LineWidth',1.1);
set(h.XLabel,'String','$x^1$','Interpreter','Latex','FontSize',12)
title('Fuzzy sets for T2RFIS model','FontSize',10)
set(findall(gcf,'Type','Legend'),...
    'String',{'Upper MF' 'Lower MF'},...
    'Location','SouthEast')

subplot(212)
plotmf(fis,'input',2),shg
grid
axis([xmin(2),xmax(2),0,1.2])
h = gca;
set(findall(h,'Type','Line'),'LineWidth',1.1);
set(h.XLabel,'String','$x^2$','Interpreter','Latex','FontSize',12)
title('','FontSize',10)
set(findall(gcf,'Type','Legend'),...
    'String',{'Upper MF' 'Lower MF'},...
    'Location','SouthEast')

figure(5)
subplot(211)
plotmf(fis,'input',3),shg
grid
axis([xmin(3),xmax(3),0,1.2])
h = gca;
set(findall(h,'Type','Line'),'LineWidth',1.1);
set(h.XLabel,'String','$x^3$','Interpreter','Latex','FontSize',12)
title('Fuzzy sets for T2RFIS model','FontSize',10)
set(findall(gcf,'Type','Legend'),...
    'String',{'Upper MF' 'Lower MF'},...
    'Location','SouthEast')

subplot(212)
plotmf(fis,'input',4),shg
grid
axis([xmin(4),xmax(4),0,1.2])
h = gca;
set(findall(h,'Type','Line'),'LineWidth',1.1);
set(h.XLabel,'String','$x^4$','Interpreter','Latex','FontSize',12)
title('','FontSize',10)
set(findall(gcf,'Type','Legend'),...
    'String',{'Upper MF' 'Lower MF'},...
    'Location','SouthEast')

figure(6)
subplot(211)
plotmf(fis,'input',5),shg
grid
axis([xmin(5),xmax(5),0,1.2])
h = gca;
set(findall(h,'Type','Line'),'LineWidth',1.1);
set(h.XLabel,'String','$x^5$','Interpreter','Latex','FontSize',12)
title('Fuzzy sets for T2RFIS model','FontSize',10)
set(findall(gcf,'Type','Legend'),...
    'String',{'Upper MF' 'Lower MF'},...
    'Location','SouthEast')

subplot(212)
plotmf(fis,'input',6),shg
grid
axis([xmin(6),xmax(6),0,1.2])
h = gca;
set(findall(h,'Type','Line'),'LineWidth',1.1);
set(h.XLabel,'String','$x^6$','Interpreter','Latex','FontSize',12)
title('','FontSize',10)
set(findall(gcf,'Type','Legend'),...
    'String',{'Upper MF' 'Lower MF'},...
    'Location','SouthEast')
