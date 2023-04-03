% exercise 
%% tonghezhuang@gmail.com
% (1) run the ROI-based RSA analysis
% (2) run the searchlight RSA analysis

%% data description
% fmri study (Event-related design)
% 72 images of actions, e.g., to eat an apple. 

%% (1) run the ROI-based RSA analysis (RSA standard)
% 1. load data and masks (V1 and LOTC)
% 2. average data across runs
% 3. create the behavioral models-72 * 72 (with 3 clusters; 12 clusters)
% 4. run RSA
% 5. plot
% 6. statistics

%% (2) run the searchlight RSA analysis (GLM-based)
% 1. load data and mask (standard brain template)
% 2. average data across runs
% 3. create the behavioral models (3*3; 12*12)
% 4. run RSA 
% 5. separate output maps
% 6. statistics
% 7. plot