import sys
from pathlib import Path

swmm_path_linux = None

if sys.platform == 'linux':
    swmm_path_linux = Path(__file__).parent / 'swmm51015'
elif sys.platform.startswith('win'):
    pass
else:
    pass

from ._run_helpers import SWMMRunError, get_result_filenames, delete_swmm_files
from .run_epaswmm import swmm5_run_epa
from .run_swmm_toolkit import swmm5_run_owa
from .run_pyswmm import swmm5_run_progress
from .run import swmm5_run
from .run_temporary import swmm5_run_temporary, dummy_run
