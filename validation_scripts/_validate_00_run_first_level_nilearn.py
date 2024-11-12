import os
import sys

package_path = "../../funROI"
sys.path.append(os.path.abspath(package_path))
import funROI

funROI.set_bids_data_folder("../data/bids")
funROI.set_bids_deriv_folder("../data/bids/derivatives/funROI")
funROI.set_bids_preprocessed_folder("../data/bids/derivatives/fmriprep")
funROI.set_analysis_output_folder("../data/funROI_output")

from funROI.first_level.nilearn import run_first_level

run_first_level(
    subjects=['199'],
    tasks=['langlocSN'],
    space='MNI152NLin6Asym',
    data_filter=[('res', '2')],
    other_contrasts=['S-N']
)