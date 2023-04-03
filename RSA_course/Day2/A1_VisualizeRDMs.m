%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% VISUALIZE BEHAVIORAL AND NEURAL DSM %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%this is an adjusted version of the exercise 'run_rsa_visualize' from Nick
%Oosterhof
% angelika.lingnau@ur.de, 09/2019

pathToData = '/Users/zuzakabulska/Documents/CoSMoMVPA_datadb/tutorial_data/ak6/';
pathToModels = '/Users/zuzakabulska/Documents/CoSMoMVPA_datadb/tutorial_data/ak6/models/';
subjectID = 's01';

fName = [pathToData subjectID '/glm_T_stats_perrun.nii'];

targets=repmat(1:6,1,10)';

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

ev_dsm = pdist(ev_ds.samples, 'correlation');
vt_dsm = pdist(vt_ds.samples, 'correlation');

subplot(3,3,1);
imagesc(squareform(ev_dsm));
axis image
title('EV');

labels = {'monkey','lemur','mallard','warbler','ladybug','lunamoth'}';
set(gca, 'xtick', [1:1:6], 'xticklabels', labels);
set(gca, 'ytick', [1:1:6], 'yticklabels', labels);
set(gca, 'xticklabelrotation', 45);

subplot(3,3,2);
imagesc(squareform(vt_dsm));
axis image
title('VT');


set(gca, 'xtick', [1:1:6], 'xticklabels', labels);
set(gca, 'ytick', [1:1:6], 'yticklabels', labels);
set(gca, 'xticklabelrotation', 45);

modelName = [pathToModels 'behav_sim.mat'];
load(modelName); % loaded as 'behav'
behav_dsm=behav;

subplot(3,3,3);
imagesc(behav);
axis image
title('behav');

set(gca, 'xtick', [1:1:6], 'xticklabels', labels);
set(gca, 'ytick', [1:1:6], 'yticklabels', labels);
set(gca, 'xticklabelrotation', 45);


%% Add the dendrograms for EV, LV and behav in the middle row of the
% subplot figure (this requires matlab's stats toolbox)
if cosmo_check_external('@stats',false)
    % First, compute the linkage using Matlab's linkage for
    % 'ev_dsm', 'vt_dsm' and 'behav_dsm'. Assign the result
    % to 'ev_hclus', 'vt_hclus', and 'behav_hclus'

    ev_hclus = linkage(ev_dsm);
    vt_hclus = linkage(vt_dsm);
    behav_hclus = linkage(behav_dsm);

    subplot(3,3,4);
    dendrogram(ev_hclus,'labels',labels,'orientation','left');
    set(gca, 'xtick', []);

    subplot(3,3,5);
    dendrogram(vt_hclus,'labels',labels,'orientation','left');
    set(gca, 'xtick', []);

    subplot(3,3,6);
    dendrogram(behav_hclus,'labels',labels,'orientation','left');
    set(gca, 'xtick', []);

else
    fprintf('stats toolbox not present; cannot show dendrograms\n');
end

%% Show the MDS (multi-dimensional scaling) plots in the bottom row

% Show early visual cortex model similarity

% get two-dimensional projection of 'ev_dsm' dissimilarity using cmdscale;
% assign the result to a variable 'xy_ev'
subplot(3,3,7);
xy_ev = cmdscale(squareform(ev_dsm));
axis image;

% plot the labels using the xy_ev labels
text(xy_ev(:,1), xy_ev(:,2), labels);

% adjust range of x and y axes
mx = max(abs(xy_ev(:)));
xlim([-mx mx]);
ylim([-mx mx]);

% using cmdscale, store two-dimensional projection of 'vt_dsm' and
% 'behav_dsm' in 'xy_vt' and 'xy_behav'
subplot(3,3,8);
xy_vt = cmdscale(squareform(vt_dsm));
axis image;

text(xy_vt(:,1), xy_vt(:,2), labels);

mx = max(abs(xy_vt(:)));
xlim([-mx mx]);
ylim([-mx mx]);


subplot(3,3,9);
xy_behav = cmdscale(squareform(behav_dsm));
axis image;

text(xy_behav(:,1), xy_behav(:,2), labels);

mx = max(abs(xy_behav(:)));
xlim([-mx mx]);
ylim([-mx mx]);



