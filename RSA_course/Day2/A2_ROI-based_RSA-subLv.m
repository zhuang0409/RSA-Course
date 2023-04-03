%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% COMPARE BEHAVIORAL AND NEURAL DSMs within ROIs %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% zuzanna.kabulska@ur.de,01/2023 
% based on angelika.lingnau@ur.de, 09/2019

pathToData = '/Users/zuzakabulska/Documents/CoSMoMVPA_datadb/tutorial_data/ak6/';
pathToModels = '/Users/zuzakabulska/Documents/CoSMoMVPA_datadb/tutorial_data/ak6/models/';
subjectID = 's01';

fName = [pathToData subjectID '/glm_T_stats_perrun.nii'];

modelName1 = [pathToModels 'behav_sim.mat'];
load(modelName1);

behav_dsm=squareform(behav);

targets=repmat(1:6,1,10)'; % 6 animals, 10 runs per session

%load data from early visual cortex ROI
ev_ds = cosmo_fmri_dataset(fName, ...
    'mask',[pathToData subjectID '/ev_mask.nii'],...
    'targets',targets);

%load data from ventral temporal ROI
vt_ds = cosmo_fmri_dataset(fName, ...
    'mask',[pathToData subjectID '/vt_mask.nii'],...
    'targets',targets);

% compute average for each unique target, so that the datasets have 6
% samples each - one for each target
vt_ds=cosmo_fx(vt_ds, @(x)mean(x,1), 'targets', 1);
ev_ds=cosmo_fx(ev_ds, @(x)mean(x,1), 'targets', 1);

% remove constant features
vt_ds=cosmo_remove_useless_data(vt_ds);
ev_ds=cosmo_remove_useless_data(ev_ds);

% Use pdist (or cosmo_pdist) with 'correlation' distance to get DSMs
% in vector form. Assign the result to 'ev_dsm' and 'vt_dsm'

%ev_dsm = pdist(ev_ds.samples, 'correlation');
%vt_dsm = pdist(vt_ds.samples, 'correlation');

%compute correlations between behavioral model and neural model
varargin.metric = 'squaredeuclidean';
varargin.type = 'Pearson'; % 'Pearson' is default
varargin.center_data = 'true';
varargin.target_dsm = behav_dsm;
r_ev_behav=cosmo_target_dsm_corr_measure(ev_ds,varargin);
%r_ev_behav=cosmo_target_dsm_corr_measure(ev_ds,'target_dsm',behav_dsm,varargin);
r_vt_behav=cosmo_target_dsm_corr_measure(vt_ds,varargin);

rMat = [r_ev_behav.samples; r_vt_behav.samples];
hbar = bar(rMat);

set(gca, 'xticklabel', {'early visual', 'ventro-temporal'});
set(gca, 'fontsize', 14);
%hleg = legend([hbar(1), hbar(2)],'v1 model', 'behav model', 'location', 'NorthWest');
%hxlab = xlabel('');
hylab = ylabel('Correlation');
axis([0.5 2.5 0 1]);

title('Correlation between neural and model DSM');

%% Exercises for you:
% (1) run the same analysis again, with your own behavioral data 
% (2) run the same analysis again, with the varargin argument 'center_data' set to 'true'




