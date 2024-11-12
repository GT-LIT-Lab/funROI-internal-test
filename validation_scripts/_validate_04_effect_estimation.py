# This script estimates the following effects:
#   S, W, N, Sem_photo, Perc_photo, Sem_sent, Perc_sent
# using the following localizers:
#   language localizer S-N
#   events localizer Sem_sentminusPerc_sent
#   events localizer Sem_photominusPerc_photo
#   events localizer Sem_sentminusPerc_sent + Sem_photominusPerc_photo (and)

import os
import sys

package_path = "../../funROI"
sys.path.append(os.path.abspath(package_path))
import funROI

funROI.set_bids_data_folder("../data/bids")
funROI.set_bids_deriv_folder("../data/bids/derivatives/funROI")
funROI.set_bids_preprocessed_folder("../data/bids/derivatives/fmriprep")
funROI.set_analysis_output_folder("../data/funROI_output")

from funROI.analysis import EffectEstimator


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


for localizer in ["language", "events_sent", "events_photo", "events_both"]:
    froi = get_froi_config(localizer)
    effect_estimator = EffectEstimator(subjects=subjects, froi=froi)
    effect_estimator.run(task="SWNloc", effects=["S", "W", "N"])
    effect_estimator.run(
        task="EventsOrig",
        effects=["Sem_photo", "Perc_photo", "Sem_sent", "Perc_sent"],
    )
