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

overlap_estimator = OverlapEstimator()
overlap_estimator.run(
    froi1="../data/spm_first_level_results/Events.nii",
    froi2="../data/spm_first_level_results/Language.nii",
)
