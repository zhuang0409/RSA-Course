%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% COMPARE NEURAL DSMs with several BEHAVIORAL models within ROIs %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% zuzanna.kabulska@ur.de,01/2023 
% based on angelika.lingnau@ur.de, 09/2019

%% Set data paths
pathToData = '/Users/zuzakabulska/Documents/CoSMoMVPA_datadb/tutorial_data/ak6/';
pathToModels = '/Users/zuzakabulska/Documents/CoSMoMVPA_datadb/tutorial_data/ak6/models/';
subjectID = 's01';

%% Load data

%  behavioral models
modelName1 = [pathToModels 'behav_sim.mat'];
load(modelName1);
behav_dsm=behav;

modelName2 = [pathToModels 'v1_model.mat'];
load(modelName2);
v1_model_dsm=v1_model;

% neural models
data_fn = [pathToData subjectID '/glm_T_stats_perrun.nii'];
targets=repmat(1:6,1,10)'; % 6 animals, 10 runs per session

% load data from early visual cortex ROI
ev_ds = cosmo_fmri_dataset(data_fn, ...
    'mask',[pathToData subjectID '/ev_mask.nii'],...
    'targets',targets);

% load data from ventral temporal ROI
vt_ds = cosmo_fmri_dataset(data_fn, ...
    'mask',[pathToData subjectID '/vt_mask.nii'],...
    'targets',targets);

% compute average for each unique target, so that the datasets have 6
% samples each - one for each target
vt_ds=cosmo_fx(vt_ds, @(x)mean(x,1), 'targets', 1);
ev_ds=cosmo_fx(ev_ds, @(x)mean(x,1), 'targets', 1);

% remove constant features
vt_ds=cosmo_remove_useless_data(vt_ds);
ev_ds=cosmo_remove_useless_data(ev_ds);

%% Run RSA
% prepare CoSMo structure
varargin=struct();
% varargin.target_dsm = behav_dsm;
% varargin.regress_dsm = v1_model_dsm; % partial correlation, corr. as output
modelsToDSM = {behav_dsm, v1_model_dsm}; % for .glm_dsm
varargin.glm_dsm = modelsToDSM; % multiple regression, betas as output
varargin.metric = 'squaredeuclidean';
varargin.type = 'Pearson';
varargin.center_data = true;

% run RSA
r_ev_reg=cosmo_target_dsm_corr_measure(ev_ds,varargin);
r_vt_reg=cosmo_target_dsm_corr_measure(vt_ds,varargin);

% plot the results
%rMat = [r_ev_reg.samples(1,1), r_vt_reg.samples(1,1)];
rMat = [r_ev_reg.samples(1,1), r_ev_reg.samples(2,1);...
    r_vt_reg.samples(1,1),r_vt_reg.samples(2,1)];

hbar = bar(rMat);
set(gca, 'xticklabel', {'early visual', 'ventro-temporal'});
hleg = legend([hbar(1), hbar(2)], 'behav model', 'v1 model','location', 'NorthWest');

set(gca, 'fontsize', 14);
%hylab = ylabel('Partial correlation');
hylab = ylabel('Regression coefficients');
title('Correlation with beh. model after regressing out V1 info');

%% Exercises for you:
% (1) run the same analysis again, with your own behavioral data 
