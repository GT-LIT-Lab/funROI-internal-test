% This script runs the spatial correlation on different contrasts on a set of 
% parcels. The following parcels are used:
%   Language parcels, Events parcels
% The following contrasts are used:
%   Sem_photo, Perc_photo, Sem_sent, Perc_sent, S, W, N

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

parcels_spcorr_output_dir = fullfile(pwd, '..', 'data', 'spm_ss_results', 'parcels_spcorr');
if ~exist(parcels_spcorr_output_dir, 'dir')
    mkdir(parcels_spcorr_output_dir);
end

for network = {'language', 'events'}
    parcels_file = get_parcels_file(network{1});
    for effect1_task = {'language', 'events'}
        for effect2_task = {'language', 'events'}
            if strcmp(effect1_task{1}, 'language')
                effect1_spmfiles = lang_spmfiles;
                effect1_contrasts = {'S', 'W', 'N'};
            else
                effect1_spmfiles = events_spmfiles;
                effect1_contrasts = {'Sem_photo', 'Perc_photo', 'Sem_sent', 'Perc_sent'};
            end
            if strcmp(effect2_task{1}, 'language')
                effect2_spmfiles = lang_spmfiles;
                effect2_contrasts = {'S', 'W', 'N'};
            else
                effect2_spmfiles = events_spmfiles;
                effect2_contrasts = {'Sem_photo', 'Perc_photo', 'Sem_sent', 'Perc_sent'};
            end
            for effect1_contrast = effect1_contrasts
                for effect2_contrast = effect2_contrasts
                    bcc=struct(...
                        'swd',fullfile(parcels_spcorr_output_dir, ...
                            ['spcorr_parcels_' network{1} '_' effect1_task{1} '2' effect2_task{1} '_' effect1_contrast{1} '2' effect2_contrast{1}]),...
                        'EffectOfInterest1_spm',{effect1_spmfiles},...  
                        'EffectOfInterest2_spm', {effect2_spmfiles},...
                        'EffectOfInterest1_contrasts',{effect1_contrast},...
                        'EffectOfInterest2_contrasts',{effect2_contrast},...                           
                        'ManualROIs', parcels_file,...
                        'overwrite', 1, ...
                        'model',1,...                                   
                        'ExplicitMasking', [], ...
                        'ask','none');   
                    bcc=spm_bcc_design(bcc);
                    bcc=spm_bcc_estimate(bcc);
                end
            end
        end
    end
end

function [parcels_file] = get_parcels_file(network)
    % Get the parcels file for the network
    if strcmp(network, 'language')
        parcels_file = fullfile(pwd, '..', 'data', 'spm_first_level_results', 'Language.nii');
    elseif strcmp(network, 'events')
        parcels_file = fullfile(pwd, '..', 'data', 'spm_first_level_results', 'Events.nii');
    end
end