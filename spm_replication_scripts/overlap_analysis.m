 %% Parcels overlap
calculate_parcel_overlap('../data/spm_first_level_results/Events.nii', ...
    '../data/spm_first_level_results/Language.nii', ...
    '../data/spm_ss_results/overlap_parcels.csv')



%% fROI overlap
% diff task
rois = {
    'Sem-Perc_Both', 'EventsOrig_instrsep_2runs', 'locT_conjunction_0009_percene2fbeb545e8538fc631a5b658897462d_d51fd8e6a075650259d79e425ef95cc5.ROIs.nii', 'locT_conjunction_0096_percen5a6ad3e5da98f3d30e0d51a3fc4a2c63_d51fd8e6a075650259d79e425ef95cc5.ROIs.nii', 'locT_conjunction_0094_percena6a65b90da71791a6a7b6eca4f6fd7a1_d51fd8e6a075650259d79e425ef95cc5.ROIs.nii';
    'Sem-Perc_Sent', 'EventsOrig_instrsep_2runs', 'locT_0009_percentile-ROI-leva24e3979931e708a651794ceb617213f_d51fd8e6a075650259d79e425ef95cc5.ROIs.nii', 'locT_0096_percentile-ROI-leva56632ce682fed906375eecc49c63865_d51fd8e6a075650259d79e425ef95cc5.ROIs.nii', 'locT_0094_percentile-ROI-levb60bc7addc9591400238245ce62dd472_d51fd8e6a075650259d79e425ef95cc5.ROIs.nii';
    'Sem-Perc_Photo', 'EventsOrig_instrsep_2runs', 'locT_0011_percentile-ROI-levb81abf9a5eb2f9763055c84b4ce0fa50_d51fd8e6a075650259d79e425ef95cc5.ROIs.nii', 'locT_0104_percentile-ROI-levafa097a41ca981790f7db929876eeb9a_d51fd8e6a075650259d79e425ef95cc5.ROIs.nii', 'locT_0102_percentile-ROI-levdbb70a9a71d46cb05992126c11497cef_d51fd8e6a075650259d79e425ef95cc5.ROIs.nii';
    'S-N', 'SWNlocIPS168_3runs', 'locT_0004_percentile-ROI-lev108e4c18d6ea2abe6e93878e9ec37706_0ec4c2aea138a29651934fa82423479c.ROIs.nii', '', '';
}; 
subjects = {'040', '057', '059', '056', '067', '068', '019', '070', '087', '078', '089', '076'};


curr_path = pwd;  % or specify the current path directly

% Loop through each subject and each ROI
for s = 1:length(subjects)
    subject_id = subjects{s};  % Get the current subject

    for r = 1:size(rois, 1)
        roi_name = rois{r, 1};
        task = rois{r, 2};
        locTsuffix = rois{r, 3};
        ses1locTsuffix = rois{r, 4};
        ses2locTsuffix = rois{r, 5};
        

        full_file_path = fullfile(curr_path, '..', 'data', 'spm_first_level_results', ...
            [subject_id '_' task], locTsuffix);

        for r2 = 1:size(rois, 1)
            if r2 < r
                continue
            end
            roi_name2 = rois{r2, 1};
            task2 = rois{r2, 2};
            locTsuffix2 = rois{r2, 3};
            ses1locTsuffix2 = rois{r2, 4};
            ses2locTsuffix2 = rois{r2, 5};

            if r ~= 4 && r2 ~= 4
                full_file_path_sp = fullfile(curr_path, '..', 'data', 'spm_first_level_results', ...
                [subject_id '_' task], ses1locTsuffix);
                full_file_path2_sp = fullfile(curr_path, '..', 'data', 'spm_first_level_results', ...
                [subject_id '_' task2], ses2locTsuffix2);
                output_path = fullfile(curr_path, '..', 'data', 'spm_ss_results', 'overlap_frois', ...
                [subject_id '_' roi_name '_' roi_name2 '_1.csv']);
                calculate_parcel_overlap(full_file_path_sp, full_file_path2_sp, output_path);

                full_file_path_sp = fullfile(curr_path, '..', 'data', 'spm_first_level_results', ...
                [subject_id '_' task], ses2locTsuffix);
                full_file_path2_sp = fullfile(curr_path, '..', 'data', 'spm_first_level_results', ...
                [subject_id '_' task2], ses1locTsuffix2);
                output_path = fullfile(curr_path, '..', 'data', 'spm_ss_results', 'overlap_frois', ...
                [subject_id '_' roi_name '_' roi_name2 '_2.csv']);
                calculate_parcel_overlap(full_file_path_sp, full_file_path2_sp, output_path);
            elseif r == 4 && r2 == 4
                    continue
            else
    
                full_file_path2 = fullfile(curr_path, '..', 'data', 'spm_first_level_results', ...
                    [subject_id '_' task2], locTsuffix2);
    
                output_path = fullfile(curr_path, '..', 'data', 'spm_ss_results', 'overlap_frois', ...
                    [subject_id '_' roi_name '_' roi_name2 '.csv']);
    
                calculate_parcel_overlap(full_file_path, full_file_path2, output_path);
            end
        end
    end
end

