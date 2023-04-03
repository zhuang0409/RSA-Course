%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% COMPARE BEHAVIORAL AND NEURAL DSMs within ROIs => all subjects %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% zuzanna.kabulska@ur.de,01/2023 

pathToData = '/Users/zuzakabulska/Documents/CoSMoMVPA_datadb/tutorial_data/ak6/';
pathToModels = '/Users/zuzakabulska/Documents/CoSMoMVPA_datadb/tutorial_data/ak6/models/';

nSub = 8;

modelName1 = [pathToModels 'behav_sim.mat'];
varargin.metric = 'squaredeuclidean';
varargin.type = 'Pearson'; % 'Pearson' is default

for iSub = 1:nSub
    subjectID = sprintf('s%02d',iSub);

    % Loading behavioral data
    load(modelName1);
    behav_dsm=squareform(behav);
    
    fName = [pathToData subjectID '/glm_T_stats_perrun.nii'];
    
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

    %compute correlations between behavioral model and neural model
    r_ev_behav=cosmo_target_dsm_corr_measure(ev_ds,'target_dsm',behav_dsm,varargin);
    r_vt_behav=cosmo_target_dsm_corr_measure(vt_ds,'target_dsm',behav_dsm,varargin);
    
    rMat(iSub,:) = [r_ev_behav.samples, r_vt_behav.samples];

end

save('rMat','rMat')
