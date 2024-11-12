# This script migrates the SPM first level analysis to a BIDS derivative folder
# using the funROI package.

import os
import sys
import glob

package_path = "../../funROI"
sys.path.append(os.path.abspath(package_path))
import funROI

funROI.set_bids_data_folder("../data/bids")
funROI.set_bids_deriv_folder("../data/bids/derivatives/funROI")
funROI.set_bids_preprocessed_folder("../data/bids/derivatives/fmriprep")

from funROI.first_level.spm import migrate_first_level_from_spm

spm_data_dir = "../data/spm_first_level_results"
for task, task_suffix in [
    ("SWNloc", "SWNlocIPS168_3runs"),
    ("EventsOrig", "EventsOrig_instrsep_2runs"),
]:
    spm_folders = glob.glob(os.path.join(spm_data_dir, f"*_{task_suffix}"))
    for spm_folder in spm_folders:
        subject_id = os.path.basename(spm_folder).split("_")[0]
        migrate_first_level_from_spm(spm_folder, subject_id, task)
