%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% EXERCISE 5: RSA SEARCHLIGHT %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% run cross-validation with nearest neighbor classifier
% angelika.lingnau@ur.de, 09/2019%

pathToData = '/Users/alingnau/CoSMoMVPA-master/data/HLR/';
pathToModels = '/Users/alingnau/CoSMoMVPA-master/data/HLR/models';
pathToResults = '/Users/alingnau/CoSMoMVPA-master/handsOnCoimbra/results/'

subjectID = 's01';

fName=[pathToData subjectID '/t_HLR.nii.gz'];
outputName = [pathToResults sprintf('%s_HLR_searchlight_modelUpperLower.nii.gz', subjectID)];
maskName=[pathToData subjectID '/brain_mask.nii.gz'];
targets=1:1:4';
ds = cosmo_fmri_dataset(data_fn, ...
                        'mask',mask_fn,...
                        'targets',targets);

modelName = [pathToModels '/upperLower.mat'];               
load(modelName);

%% Set measure
% Set the 'measure' and 'measure_args' to use the
% @cosmo_target_dsm_corr_measure measure and set its parameters
% to so that the target_dsm is based on upperLower.mat

measure = @cosmo_target_dsm_corr_measure;
measure_args = struct();
measure_args.target_dsm = upperLower;

% Enable centering the data
measure_args.center_data=true;

% Run searchlight
% use spherical neighborhood of 100 voxels
voxel_count=100;

% define a neighborhood using cosmo_spherical_neighborhood
nbrhood=cosmo_spherical_neighborhood(ds,'count',voxel_count);

% Run the searchlight
results = cosmo_searchlight(ds,nbrhood,measure,measure_args);

% Save results
cosmo_map2fmri(results, outputName);

% Show some slices
figure;
cosmo_plot_slices(results, 3, -20);


