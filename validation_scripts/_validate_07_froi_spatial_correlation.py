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

# Can use fROIs instead of parcels
froi = funROI.FROIConfig(
    task="EventsOrig",
    contrasts=["Sem_sentminusPerc_sent"],
    threshold_type="percent",
    threshold_value=0.1,
    parcels="../data/spm_first_level_results/Events.nii",
)
spcorr_estimator = SpatialCorrelationEstimator(
    subjects=subjects,
    froi=froi,
)

contrasts1 = [
    ("SWNloc", "S"),
    ("SWNloc", "W"),
    ("SWNloc", "N")
]
contrasts2 = [
    ("EventsOrig", "Sem_photo"),
    ("EventsOrig", "Perc_photo"),
    ("EventsOrig", "Sem_sent"),
    ("EventsOrig", "Perc_sent"),
]
for task1, effect1 in contrasts1:
    for task2, effect2 in contrasts2:
        spcorr_estimator.run(task1, effect1, task2, effect2)
