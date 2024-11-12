% This script estimates the following effects:
%   S, W, N, Sem_photo, Perc_photo, Sem_sent, Perc_sent
% using the following localizers:
%   language localizer S-N
%   events localizer Sem_sentminusPerc_sent
%   events localizer Sem_photominusPerc_photo
%   events localizer Sem_sentminusPerc_sent + Sem_photominusPerc_photo (and)

addpath('~/Documents/spm_ss')
addpath('~/Documents/spm12')

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

effect_output_dir = fullfile(pwd, '..', 'data', 'spm_ss_results', 'effects');
if ~exist(effect_output_dir, 'dir')
    mkdir(effect_output_dir);
end

for localizer_type = {'language', 'events_sent', 'events_photo', 'events_both'}
    [spm_files, parcel_file, contrasts] = get_loc_config(...
        localizer_type{1}, events_spmfiles, lang_spmfiles);
    output_pth = fullfile(effect_output_dir, ...
        [localizer_type{1} '_lang']);
    effect_contrast = {'S', 'W', 'N'};
    effect_spm_files = lang_spmfiles;
    estimate_effect(output_pth, effect_spm_files, ...
        spm_files, parcel_file, effect_contrast, contrasts);

    output_pth = fullfile(effect_output_dir, ...
        [localizer_type{1} '_events']);
    effect_contrast = {'Sem_photo', 'Perc_photo', 'Sem_sent', 'Perc_sent'};
    effect_spm_files = events_spmfiles;
    estimate_effect(output_pth, effect_spm_files, ...
        spm_files, parcel_file, effect_contrast, contrasts);
end


function [spm_files, parcel_file, contrasts] = get_loc_config(...
    localizer_type, events_spmfiles, lang_spmfiles)
    % Get the localizer configuration
    if strcmp(localizer_type, 'language')
        spm_files = lang_spmfiles;
        parcel_file = fullfile(pwd, '..', 'data', 'spm_first_level_results', 'Language.nii');
        contrasts = {'S-N'};
    elseif strcmp(localizer_type, 'events_sent')
        spm_files = events_spmfiles;
        parcel_file = fullfile(pwd, '..', 'data', 'spm_first_level_results', 'Events.nii');
        contrasts = {'Sem_sentminusPerc_sent'};
    elseif strcmp(localizer_type, 'events_photo')
        spm_files = events_spmfiles;
        parcel_file = fullfile(pwd, '..', 'data', 'spm_first_level_results', 'Events.nii');
        contrasts = {'Sem_photominusPerc_photo'};
    elseif strcmp(localizer_type, 'events_both')
        spm_files = events_spmfiles;
        parcel_file = fullfile(pwd, '..', 'data', 'spm_first_level_results', 'Events.nii');
        contrasts = {'Sem_sentminusPerc_sent', 'Sem_photominusPerc_photo'};
    else
        error('Invalid localizer type');
    end
end

function [] = estimate_effect(output_pth, effect_spm_files, ...
    localizer_spm_files, parcel_file, effect_contrast, localizer_contrasts)
    % Run the effect estimation
    ss=struct(...
        'swd',output_pth,...
        'EffectOfInterest_spm',{effect_spm_files},...  
        'Localizer_spm', {localizer_spm_files},...
        'EffectOfInterest_contrasts',{effect_contrast},...
        'Localizer_contrasts',{localizer_contrasts},...    
        'Localizer_thr_type',{{'percentile-ROI-level'}},...
        'Localizer_thr_p',[.1],... 
        'Localizer_conjunction_type', 'max',...
        'type','mROI',...
        'ManualROIs', parcel_file,...
        'overwrite', 1, ...
        'model',1,...                                   
        'ExplicitMasking', '', ...
        'estimation','OLS',...
        'ask','none');   
    ss=spm_ss_design(ss);
    ss=spm_ss_estimate(ss);
end