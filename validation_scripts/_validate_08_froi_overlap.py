import os
import sys

package_path = "../../funROI"
sys.path.append(os.path.abspath(package_path))
import funROI

funROI.set_bids_data_folder("../data/bids")
funROI.set_bids_deriv_folder("../data/bids/derivatives/funROI")
funROI.set_bids_preprocessed_folder("../data/bids/derivatives/fmriprep")
funROI.set_analysis_output_folder("../data/funROI_output")

from funROI.analysis import OverlapEstimator

def get_froi_config(localizer):
    if localizer == "language":
        froi = funROI.FROIConfig(
            task="SWNloc",
            contrasts=["S-N"],
            threshold_type="percent",
            threshold_value=0.1,
            parcels="../data/spm_first_level_results/Language.nii",
        )
    elif localizer == "events_sent":
        froi = funROI.FROIConfig(
            task="EventsOrig",
            contrasts=["Sem_sentminusPerc_sent"],
            threshold_type="percent",
            threshold_value=0.1,
            parcels="../data/spm_first_level_results/Events.nii",
        )
    elif localizer == "events_photo":
        froi = funROI.FROIConfig(
            task="EventsOrig",
            contrasts=["Sem_photominusPerc_photo"],
            threshold_type="percent",
            threshold_value=0.1,
            parcels="../data/spm_first_level_results/Events.nii",
        )
    elif localizer == "events_both":
        froi = funROI.FROIConfig(
            task="EventsOrig",
            contrasts=["Sem_sentminusPerc_sent", "Sem_photominusPerc_photo"],
            threshold_type="percent",
            threshold_value=0.1,
            parcels="../data/spm_first_level_results/Events.nii",
            conjunction_type="max",
        )
    return froi

subjects = [
    "040",
    "057",
    "059",
    "056",
    "067",
    "068",
    "019",
    "070",
    "087",
    "078",
    "089",
    "076",
]

overlap_estimator = OverlapEstimator(subjects=subjects)
for froi1 in ["language", "events_sent", "events_photo", "events_both"]:
    for froi2 in ["language", "events_sent", "events_photo", "events_both"]:
        froi1_config = get_froi_config(froi1)
        froi2_config = get_froi_config(froi2)
        overlap_estimator.run(froi1_config, froi2_config)
