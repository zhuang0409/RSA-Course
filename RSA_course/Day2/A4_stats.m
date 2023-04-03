%% statistics for ROI-based RSA analysis
load('my_rMat.mat');%my=load('my_rMat.mat');
load('rMat.mat');

Mat = [mean(rMat); mean(my_rMat)];
hbar = bar(Mat);

%% visualization
set(gca, 'xticklabel', {'early visual', 'ventro-temporal'});
set(gca, 'fontsize', 14);
hleg = legend([hbar(1), hbar(2)],'behav model', 'my behav model', 'location', 'NorthWest');
set(hleg, 'box', 'off', 'fontsize', 14);
%hxlab = xlabel('');
hylab = ylabel('Correlation');
axis([0.5 2.5 0 1]);

title('Correlation between neural and model DSM');

%% stats
% t-test
% whether it is significant different against zero
[H,P,CI,STATS]=ttest(rMat(:,1));
% compare the models within a ROI (early visual cortex)
[H1,P1,CI1,STATS1]=ttest(rMat(:,1),my_rMat(:,1));

% your task:
% (1) whether it is significant different against zeros for VT ROIs
% (2) compare the models within a ROI (VT)

% anova
data_all=[rMat my_rMat];
Subjs=[1:1:8]';
F1=[1 1 2 2];
F2=[1 2 1 2];
results_stats=rm_anova2(data_all,Subjs,F1,F2,{'rois', 'models'});
