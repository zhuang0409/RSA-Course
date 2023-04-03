%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% RSA course
%% Tonghe Zhuang (tonghezhuang@gmail.com) 2023-01-10
% orginal codes from Lingnau A. 2019/09
% A1_matlab_cosmomvpa_solution.m: Getting familiar with CoSMoMVPA. 


%create two masked data sets ds_masked_odd and ds_masked_even that contain
%the mean across odd and even runs, separately for each
%of the six conditions

%to compute the mean, use the function cosmo_fx
%solution1
nCond = 6;
nRuns = 10;
targetVec=reshape(repmat(1:2,nCond,nRuns/2), nCond * nRuns, 1);
[targets targetVec]
targetsOdd =  find(targetVec==1);
targetsEven = find(targetVec==2);
ds_masked_odd  = cosmo_slice(ds_masked, targetsOdd);
ds_masked_even = cosmo_slice(ds_masked, targetsEven);

ds_masked_odd_mean =cosmo_fx(ds_masked_odd, @(x)mean(x,1), 'targets', 1);
ds_masked_even_mean=cosmo_fx(ds_masked_even, @(x)mean(x,1), 'targets', 1);

% solution 2
chunksVec=reshape(repmat(1:2,nCond,nRuns/2), nCond * nRuns, 1);
ds_masked = cosmo_fmri_dataset([pathToData, subjectID, '/', fName], ...
    'targets', targets,'chunks', chunksVec);

% ds_masked.sa.chunks=chunksVec;
 
ds_odd=cosmo_slice(ds_masked,ds_masked.sa.chunks==1);
ds_even=cosmo_slice(ds_masked,ds_masked.sa.chunks==2);

ds_odd_avg=cosmo_fx(ds_odd, @(x)mean(x,1), 'targets', 1);
ds_even_avg=cosmo_fx(ds_even, @(x)mean(x,1), 'targets', 1);

% solution 3
chunksVec=reshape(repmat(1:nRuns,nCond,1), nCond * nRuns, 1);
ds_masked = cosmo_fmri_dataset([pathToData, subjectID, '/', fName], ...
    'targets', targets,'chunks', chunksVec);

% ds_masked.sa.chunks=chunksVec;
odd_ind=find(mod(ds_masked.sa.chunks,2));
even_ind=find(1-mod(ds_masked.sa.chunks,2));

ds_odd_s3=cosmo_slice(ds_masked,odd_ind);
ds_even_s3=cosmo_slice(ds_masked,even_ind);

ds_odd_avg_s3=cosmo_fx(ds_odd_s3, @(x)mean(x,1), 'targets', 1);
ds_even_avg_s3=cosmo_fx(ds_even_s3, @(x)mean(x,1), 'targets', 1);

%(8) keep the same order
% e.g. the order should be [1 6 2 3 4 5]
% create a data for rdm, because I don't have data from meadows, if you
% have, please use the data from meadows directly. here is the examples
rand_ds=rand(1,15);
dsm=squareform(rand_ds);
imagesc(dsm);
reorder=[1 6 2 3 4 5];
new_dsm=dsm(reorder,reorder);
