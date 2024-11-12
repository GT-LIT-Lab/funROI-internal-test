# This script generates parcels from a list of subjects using language and
# events localizers,  defined using either a single contrast or a conjunction
# of contrasts.

import os
import sys

package_path = "../../funROI"
sys.path.append(os.path.abspath(package_path))
import funROI
from funROI.analysis import ParcelsGenerator

funROI.set_bids_data_folder("../data/bids")
funROI.set_bids_deriv_folder("../data/bids/derivatives/funROI")
funROI.set_bids_preprocessed_folder("../data/bids/derivatives/fmriprep")
funROI.set_analysis_output_folder("../data/funROI_output")

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

# S-N contrast
parcels_generator = ParcelsGenerator(
    parcels_name="Language_S-N",
    smoothing_kernel_size=6,
    overlap_thr_vox=0.1,
    use_spm_smooth=True,
)
parcels_generator.add_subjects(
    subjects=subjects,
    task="SWNloc",
    contrasts=["S-N"],
    p_threshold_type="none",
    p_threshold_value=0.001,
)
parcels = parcels_generator.run()


# Sem_sentminusPerc_sent contrast
parcels_generator = ParcelsGenerator(
    parcels_name="Events_SentSem-Perc",
    smoothing_kernel_size=6,
    overlap_thr_vox=0.1,
    use_spm_smooth=True,
)
parcels_generator.add_subjects(
    subjects=subjects,
    task="EventsOrig",
    contrasts=["Sem_sentminusPerc_sent"],
    p_threshold_type="none",
    p_threshold_value=0.05,
)
parcels = parcels_generator.run()


# Sem_photominusPerc_photo contrast
parcels_generator = ParcelsGenerator(
    parcels_name="Events_PhotoSem-Perc",
    smoothing_kernel_size=6,
    overlap_thr_vox=0.1,
    use_spm_smooth=True,
)
parcels_generator.add_subjects(
    subjects=subjects,
    task="EventsOrig",
    contrasts=["Sem_photominusPerc_photo"],
    p_threshold_type="none",
    p_threshold_value=0.05,
)
parcels = parcels_generator.run()


# Conjunction of Sem_photominusPerc_photo and Sem_sentminusPerc_sent contrasts
parcels_generator = ParcelsGenerator(
    parcels_name="Events_SentPhotoSem-Perc",
    smoothing_kernel_size=6,
    overlap_thr_vox=0.1,
    use_spm_smooth=True,
)
parcels_generator.add_subjects(
    subjects=subjects,
    task="EventsOrig",
    contrasts=["Sem_photominusPerc_photo", "Sem_sentminusPerc_sent"],
    p_threshold_type="none",
    p_threshold_value=0.05,
    conjunction_type="and",
)
parcels = parcels_generator.run()
