%% RSA course
%% Tonghe Zhuang (tonghezhuang@gmail.com) 2023-01-10
% A1_RSA_searchlight_solution.m: Using a behavioural RSM
% The data used here is available from http://cosmomvpa.org/datadb.zip

%% Set data paths
ak6_study_path = '/Users/zhuang/Desktop/fMRI_methods/workshop_for_analysis/datadb/tutorial_data/ak6/';

% show readme information
readme_fn=fullfile(ak6_study_path,'README');
cosmo_type(readme_fn);

%% Load data
% This example uses the 'ak6' dataset
% In this example only one sample (response estimate) per condition (class)
% per feature (voxel) is used. Here this is done using t-stats from odd
% runs. One could also use output from a GLM based on an entire
% scanning session experiment.
%

% define data filenames & load data from even and odd runs

data_path=fullfile(ak6_study_path,'s01'); % data from subject s01
mask_fn=fullfile(data_path, 'brain_mask.nii'); % whole brain mask

data_fn=fullfile(data_path,'glm_T_stats_odd.nii');
ds=cosmo_fmri_dataset(data_fn,'mask',mask_fn,...
                            'targets',1:6,'chunks',1);
                        
%% Set animal species & class
ds.sa.labels={'monkey','lemur','mallard','warbler','ladybug','lunamoth'}';

%% Define feature neighorhoods
% For the searchlight, define neighborhood for each feature (voxel).
nvoxels_per_searchlight=100;

% The neighborhood defined here is used three times (one for each target
% similarity matrix), so it is not recomputed for every searchlight call.
fprintf('Defining neighborhood for each feature\n');
nbrhood=cosmo_spherical_neighborhood(ds,'count',nvoxels_per_searchlight);

% print neighborhood
fprintf('Searchlight neighborhood definition:\n');
cosmo_disp(nbrhood);

%% RSM searchlight
% load behavioural similarity matrix from disc
behav_model_fn=fullfile(ak6_study_path,'models','behav_sim.mat');% v1_model.mat
behav_model=importdata(behav_model_fn);

target_dsm=behav_model;

fprintf('Using the following target dsm\n');
disp(target_dsm);
imagesc(target_dsm)
set(gca,'XTick',1:nsamples,'XTickLabel',ds.sa.labels,...
        'YTick',1:nsamples,'YTickLabel',ds.sa.labels)
    
%% set measure
measure=@cosmo_target_dsm_corr_measure;
measure_args=struct();
measure_args.target_dsm=target_dsm;
% Enable centering the data
measure_args.center_data=true;


% run searchlight
ds_rsm_behav=cosmo_searchlight(ds,nbrhood,measure,measure_args);

% save results
output_fn=fullfile(ak6_study_path,'rsm_behav.nii');
cosmo_map2fmri(ds_rsm_behav,output_fn);
