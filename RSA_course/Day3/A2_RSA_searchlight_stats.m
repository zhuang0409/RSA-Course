%% Statistics RSA
%% codes from Tonghe Zhuang (tonghezhuang@gmail.com) 2023-01-10

%% create Statistical Map
data_path = '/Users/zuzakabulska/Documents/PhD_courses/WS22:23/RSAcourse/Day3_15.01.2023/data_for_stats-20230114T144825Z-001/data_for_stats/';
%subjects
subjectIDs = {'s01','s02','s03'};
nSubs = length(subjectIDs);
mask_fn=fullfile(data_path, 'MNI152_T1_2mm_brain_mask.nii.gz'); 
alignedGroupMap = cell(length(subjectIDs),1);
% merge individual maps into statistical map
for iSub = 1:nSubs
    individualMap = sprintf('%s.nii.gz',subjectIDs{iSub});
    alignedGroupMap{iSub} = cosmo_fmri_dataset(fullfile(data_path, individualMap), 'mask', mask_fn);
    alignedGroupMap{iSub}.sa.targets = 1;
    alignedGroupMap{iSub}.sa.chunks = zeros(1,1)+iSub;    
end

dsGroup = cosmo_stack(alignedGroupMap);
dsGroup = cosmo_remove_useless_data(dsGroup);
% save data
cosmo_map2fmri(dsGroup, fullfile(data_path, 'GROUP.nii.gz'));

%% Statistics
% load data
ds = cosmo_fmri_dataset(fullfile(data_path, 'GROUP.nii.gz'));
nSub=3;

% statistical method
opt = struct();
%opt.cluster_stat = 'tfce';
opt.cluster_stat = 'maxsum';%maxsum
opt.niter = 100;         % usually should be > 1000
opt.h0_mean = 0;
opt.p_uncorrected=0.001;%maxsum
%opt.dh = 0.1;
opt.nproc = 4;

ds.sa.targets = ones(nSub,1);
ds.sa.chunks = (1:nSub)';
ds = cosmo_remove_useless_data(ds);
nbrhood = cosmo_cluster_neighborhood(ds);
ds_z = cosmo_montecarlo_cluster_stat(ds, nbrhood, opt);
% save data
cosmo_map2fmri(ds_z, fullfile(data_path,'GROUP_Stats.nii.gz'));%'GROUP_Stats_tfce.nii.gz'

% %% statistical map
% dstarget = ds_z;
% dstarget.samples(ds_z.samples<1.649)=0;% p=0.05
% % save data
% cosmo_map2fmri(dstarget,fullfile(data_path,'Group_statmap.nii.gz'));

%% execrise for you
% run statistics with TFCE





