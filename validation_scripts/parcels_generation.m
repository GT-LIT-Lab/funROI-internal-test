% This script generates parcels from a list of subjects using language and 
% events localizers, defined using either a single contrast or a conjunction
% of contrasts.

addpath('~/Documents/spm_ss')
addpath('~/Documents/spm12')

parcels_output_dir = fullfile(pwd, '..', 'data', 'spm_ss_results', 'parcels');
if ~exist(parcels_output_dir, 'dir')
    mkdir(parcels_output_dir);
end

events_spmfiles = dir(fullfile(pwd, '..', 'data', 'spm_first_level_results', ...
    '*_EventsOrig_instrsep_2runs', 'SPM.mat'));
events_spmfiles = strcat({events_spmfiles.folder}', filesep, ...
    {events_spmfiles.name}');
events_spmfiles = cellstr(events_spmfiles)';

lang_spmfiles = dir(fullfile(pwd, '..', 'data', 'spm_first_level_results', ...
    '*_SWNlocIPS168_3runs', 'SPM.mat'));
    lang_spmfiles = strcat({lang_spmfiles.folder}', filesep, ...
    {lang_spmfiles.name}');
lang_spmfiles = cellstr(lang_spmfiles)';

%% Language parcels generation: S-N
output_dir = fullfile(parcels_output_dir, 'Language_S-N');
ss=struct(...
    'swd',output_dir,...
    'files_spm',{lang_spmfiles},...                            
    'EffectOfInterest_contrasts',{{'S-N'}},...    
    'Localizer_contrasts',{{'S-N'}},...   
    'Localizer_thr_type', {{'none'}},...
    'Localizer_thr_p',[.001],... 
    'overlap_thr_vox',.10,...	  
    'type','GcSS',...        
    'smooth',6,... 
    'model',1,...
    'ExplicitMasking', [], ...
    'estimation','OLS',...
    'ask','none');
ss=spm_ss_design(ss);
ss=spm_ss_estimate(ss);

%% Events parcels generation: Sentence Sem-Perc
output_dir = fullfile(parcels_output_dir, 'Events_SentSem-Perc');
ss=struct(...
    'swd',output_dir,...
    'files_spm',{events_spmfiles},...                            
    'EffectOfInterest_contrasts',{{'Sem_sentminusPerc_sent'}},...    
    'Localizer_contrasts',{{'Sem_sentminusPerc_sent'}},...   
    'Localizer_thr_type', {{'none'}},...
    'Localizer_thr_p',[.05],... 
    'overlap_thr_vox',.10,...	  
    'type','GcSS',...        
    'smooth',6,... 
    'model',1,...
    'ExplicitMasking', [], ...
    'estimation','OLS',...
    'ask','none');
ss=spm_ss_design(ss);
ss=spm_ss_estimate(ss);

%% Events parcels generation: Photo Sem-Perc
output_dir = fullfile(parcels_output_dir, 'Events_PhotoSem-Perc');
ss=struct(...
    'swd',output_dir,...
    'files_spm',{events_spmfiles},...                            
    'EffectOfInterest_contrasts',{{'Sem_photominusPerc_photo'}},...    
    'Localizer_contrasts',{{'Sem_photominusPerc_photo'}},...   
    'Localizer_thr_type', {{'none'}},...
    'Localizer_thr_p',[.05],... 
    'overlap_thr_vox',.10,...	  
    'type','GcSS',...        
    'smooth',6,... 
    'model',1,...
    'ExplicitMasking', [], ...
    'estimation','OLS',...
    'ask','none');
ss=spm_ss_design(ss);
ss=spm_ss_estimate(ss);

%% Events parcels generation: Sentence/Photo Sem-Perc, conjunction using and
output_dir = fullfile(parcels_output_dir, 'Events_SentPhotoSem-Perc');
ss=struct(...
    'swd',output_dir,...
    'files_spm',{events_spmfiles},...                            
    'EffectOfInterest_contrasts',...
        {{'Sem_sentminusPerc_sent', 'Sem_photominusPerc_photo'}},...    
    'Localizer_contrasts',...
        {{'Sem_sentminusPerc_sent', 'Sem_photominusPerc_photo'}},...   
    'Localizer_thr_type', {{'none'}},...
    'Localizer_thr_p',[.05, .05],... 
    'Localizer_conjunction_type','and',...
    'overlap_thr_vox',.10,...	  
    'type','GcSS',...        
    'smooth',6,... 
    'model',1,...
    'ExplicitMasking', [], ...
    'estimation','OLS',...
    'ask','none');
ss=spm_ss_design(ss);
ss=spm_ss_estimate(ss);