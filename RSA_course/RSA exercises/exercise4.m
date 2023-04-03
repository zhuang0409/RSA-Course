%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% EXERCISE 4: COMPARE NEURAL DSMs ACROSS ROIs %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% angelika.lingnau@ur.de, 09/2019

pathToData = '/Users/alingnau/CoSMoMVPA-master/data/HLR/';
pathToModels = '/Users/alingnau/CoSMoMVPA-master/data/HLR/models/';
subjectID = 's01';

masks = {'LO1.nii.gz', 'LO2.nii.gz', 'LO3.nii.gz', ...
    'V4t.nii.gz', 'MT.nii.gz', 'MST.nii.gz', 'FST.nii.gz', ...
    'PH.nii.gz', 'PHT.nii.gz', 'TE1p.nii.gz', 'STSvp.nii.gz'};
nMasks = length(masks);
targets = 1:1:4'; 
targetNames = {'upperLeft', 'upperRight', 'lowerLeft', 'lowerRight'};
fName = [pathToData subjectID '/t_HLR.nii.gz'];

%load models
models = {'leftRight.mat', 'upperLower.mat'};
nModels = length(models);
for i = 1 : nModels
    load([pathToModels models{i}]);
end

leftRight_model_sf=cosmo_squareform(leftRight);
upperLower_model_sf=cosmo_squareform(upperLower);

leftRight_model_dsm=squareform(leftRight);
upperLower_model_dsm=squareform(upperLower);


counter=0;

for i = 1:nMasks
    
    % load dataset
    maskName=[pathToData subjectID '/' masks{i}];
    ds = cosmo_fmri_dataset(fName,...
        'mask',maskName,...
        'targets', targets);
    
    % remove constant features
    ds=cosmo_remove_useless_data(ds);
    
    %compute correlations between behavioral models and neural dsm
    r_model1=cosmo_target_dsm_corr_measure(ds,'target_dsm', leftRight_model_dsm);
    r_model2=cosmo_target_dsm_corr_measure(ds,'target_dsm', upperLower_model_dsm);

    
    % compute the one-minus-correlation value for each pair of
    dsm=cosmo_pdist(ds.samples, 'correlation');
    
    if counter==0
        % first dsm, allocate space
        nPairs=numel(dsm);
        neural_dsms=zeros(nMasks,nPairs);
        r1 = zeros(nMasks,1);
        r2 = zeros(nMasks,1);
    end
    
    % increase counter and store the dsm as the counter-th row in
    % 'neural_dsms'
    counter=counter+1;
    neural_dsms(counter,:)=dsm;
    r1(counter)=r_model1.samples;
    r2(counter)=r_model2.samples;
end



figure
for i = 1: nMasks
    subplot(3,4,i)
    imagesc(squareform(neural_dsms(i,:)));
    %title(masks{i}), 'interpreter','latex');
    title(masks{i});
    axis image
end

figure
subplot(1,2,1)
imagesc(leftRight);
axis image
set(gca, 'xtick', [1:1:4], 'ytick', [1:1:4]);
set(gca, 'xticklabel', targetNames);
set(gca, 'yticklabel', targetNames);
set(gca, 'xticklabelrotation', 45);
title('model leftRight');

subplot(1,2,2)
imagesc(upperLower);
axis image
set(gca, 'xtick', [1:1:4], 'ytick', [1:1:4]);
set(gca, 'xticklabel', targetNames);
set(gca, 'yticklabel', targetNames);
set(gca, 'xticklabelrotation', 45);
title('model upperLower');

figure
mat = [r1 r2];
hBar = bar(mat);
set(gca, 'xtick', 1:1:nMasks);
%set(gca, 'TickLabelInterpreter', 'latex');
set(gca, 'xticklabel', masks);
set(gca, 'xticklabelrotation', 45);

%%%
set(gca, 'fontsize', 14);
hleg = legend([hBar(1), hBar(2)],'leftRight', 'upperLower', 'location', 'SouthWest');
set(hleg, 'box', 'off', 'fontsize', 14);
hxlab = xlabel('ROI');
hylab = ylabel('Correlation');
%axis([0.5 2.5 0 1]);
title('Correlation between neural and model DSMs');


t = 1;