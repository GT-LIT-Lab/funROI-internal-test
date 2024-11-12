# This script runs the spatial correlation on different contrasts on a set of
# parcels. The following parcels are used:
#   Language parcels, Events parcels
# The following contrasts are used:
#   Sem_photo, Perc_photo, Sem_sent, Perc_sent, S, W, N

import os
import sys

package_path = "../../funROI"
sys.path.append(os.path.abspath(package_path))
import funROI

funROI.set_bids_data_folder("../data/bids")
funROI.set_bids_deriv_folder("../data/bids/derivatives/funROI")
funROI.set_bids_preprocessed_folder("../data/bids/derivatives/fmriprep")
funROI.set_analysis_output_folder("../data/funROI_output")

from funROI.analysis import SpatialCorrelationEstimator

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


for networks in ["Language", "Events"]:
    spcorr_estimator = SpatialCorrelationEstimator(
        subjects=subjects,
        froi=f"../data/spm_first_level_results/{networks}.nii",
    )
    contrasts = [
        ("SWNloc", "S"),
        ("SWNloc", "W"),
        ("SWNloc", "N"),
        ("EventsOrig", "Sem_photo"),
        ("EventsOrig", "Perc_photo"),
        ("EventsOrig", "Sem_sent"),
        ("EventsOrig", "Perc_sent"),
    ]
    for task1, effect1 in contrasts:
        for task2, effect2 in contrasts:
            spcorr_estimator.run(task1, effect1, task2, effect2)
