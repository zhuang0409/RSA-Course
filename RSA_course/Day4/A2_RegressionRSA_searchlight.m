%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% GLM-based RSA with several BEHAVIORAL models within the whole brain %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% zuzanna.kabulska@ur.de,01/2023 
% based on tonghezhuang@gmail.com, 01/2023
% The data used here is available from http://cosmomvpa.org/datadb.zip

%% Set data paths
pathToData = '/Users/zuzakabulska/Documents/CoSMoMVPA_datadb/tutorial_data/ak6/';
pathToModels = '/Users/zuzakabulska/Documents/CoSMoMVPA_datadb/tutorial_data/ak6/models/';
subjectID = 's01';

%% Load data

%  behavioral models
modelName1 = [pathToModels 'behav_sim.mat'];
load(modelName1);
behav_dsm = behav;

modelName2 = [pathToModels 'v1_model.mat'];
load(modelName2);
v1_model_dsm = v1_model;

% neural models
% define data filenames & load data
data_path = fullfile(pathToData,'s01'); % path to subject s01
mask_fn = fullfile(data_path, 'brain_mask.nii'); % whole brain mask
data_fn = fullfile(data_path,'glm_T_stats_perrun.nii'); % subject data
ds = cosmo_fmri_dataset(data_fn,'mask',mask_fn);
ds.sa.targets = repmat(1:6,1,10)'; % 6 animals, 10 runs per session
ds.sa.chunks = ones(length(ds.sa.targets),1);

% compute average for each unique target, so that the datasets have 6
% samples each - one for each target
ds=cosmo_fx(ds, @(x)mean(x,1), 'targets', 1);

% remove constant features
ds=cosmo_remove_useless_data(ds);

% simple sanity check to ensure all attributes are set properly
cosmo_check_dataset(ds);

%% Run RSA searchlight
% For the searchlight, define neighborhood for each feature (voxel).
nvoxels_per_searchlight=100;
fprintf('Defining neighborhood for each feature\n');
nbrhood=cosmo_spherical_neighborhood(ds,'count',nvoxels_per_searchlight);

% set measure
measure=@cosmo_target_dsm_corr_measure;
varargin=struct();
% varargin.target_dsm = behav_dsm;
% varargin.regress_dsm = v1_model_dsm; % partial correlation, corr. as output
modelsToDSM = {behav_dsm, v1_model_dsm}; % for .glm_dsm
varargin.glm_dsm = modelsToDSM; % multiple regression, betas as output
varargin.metric = 'squaredeuclidean';
varargin.type = 'Pearson'; 
varargin.center_data='true';

% run RSA searchlight
ds_rsm=cosmo_searchlight(ds,nbrhood,measure,varargin);

% save results
cosmo_map2fmri(ds_rsm,'rsa_partialCorr_wholeBrain.nii');

%% Exercises for you:
% (1) run the script using your own behavioral model as .target_dsm
% (2) run the script regressing out two additional models (e.g. V1 and
% behav_dsm)
