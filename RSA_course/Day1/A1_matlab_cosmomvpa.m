%% RSA course
%% Tonghe Zhuang (tonghezhuang@gmail.com) 2023-01-10
% orginal codes from Lingnau A. 2019/09
% A1_matlab_cosmomvpa.m: Getting familiar with CoSMoMVPA. 
% code path: /Users/zhuang/Desktop/tonghe/Courses/RSA

%(1) Load dataset
pathToData = '/Users/zhuang/Desktop/fMRI_methods/workshop_for_analysis/datadb/tutorial_data/ak6/';
subjectID = 's01';
fName = 'glm_T_stats_perrun.nii';
fn='glm_T_stats_odd.nii';
ds = cosmo_fmri_dataset([pathToData, subjectID, '/', fName]);

% check the variables
ds
cosmo_disp(ds)

%(2) add targets information: 6 categories, 10 runs
targets=repmat(1:6,1,10)';
ds = cosmo_fmri_dataset([pathToData, subjectID, '/', fName], ...
    'targets', targets);
%dsexample=cosmo_fmri_dataset('/Users/zhuang/Desktop/fMRI_methods/workshop_for_analysis/data/ak6/s01/glm_T_stats_perrun.nii','targets',s);
%check ds
ds
cosmo_disp(ds)

%(3) Slice dataset
targetsToSelect = (1:1:6)';
ds_sliced_example = cosmo_slice(ds, targetsToSelect);

%check ds_sliced
ds_sliced_example
cosmo_disp(ds_sliced_example)

%(4) Show some slices
%show slices of first condition, first run
cosmo_plot_slices(cosmo_slice(ds, 1));

%your own code here:
%in six separate plots, show conditions 1:6 of the first run

%XXXXXX

%(5) Load a mask
maskName = 'ev_mask.nii';

ds_masked = cosmo_fmri_dataset([pathToData, subjectID, '/', fName], ...
    'mask', [pathToData, subjectID, '/', maskName],...
    'targets', targets);

%(6) Average across some dimension
%example: average across runs
%f_ds=cosmo_fx(ds, f, split_by, dim)
ds_mean=cosmo_fx(ds, @(x)mean(x,1), 'targets', 1);


%(7) your own code here:
%create two masked data sets ds_masked_odd and ds_masked_even that contain
%the mean across odd and even runs, separately for each
%of the six conditions

%to compute the mean, use the function cosmo_fx

%(8) plot dsm of your behavioral data (obtained from meadows)
load ([datapath,'xxx.mat']);
imagesc(squareform(dsm));
% your own code here:
% keep the order of behaviorial data with the same order of fmri data,
% which is monkey, lemur, mallard, warbler, ladybug, lunamoth.




