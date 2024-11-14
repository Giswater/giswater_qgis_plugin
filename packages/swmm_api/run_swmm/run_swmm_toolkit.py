__author__ = "Markus Pichler"
__credits__ = ["Markus Pichler"]
__maintainer__ = "Markus Pichler"
__email__ = "markus.pichler@tugraz.at"
__version__ = "0.1"
__license__ = "MIT"

from pathlib import Path

from ._run_helpers import get_report_errors, get_result_filenames, SWMMRunError, TemporaryWorkingDirectory


def swmm5_run_owa(fn_inp, fn_rpt=None, fn_out=None, working_dir=None):
    """
    Run a simulation with OWA-SWMM (swmm-toolkit package).

    Opens SWMM input file, reads in network data, runs, and closes

    Args:
        fn_inp (str | Path): pointer to name of input file (must exist)
        fn_rpt (str | Path): pointer to name of report file (to be created)
        fn_out (str | Path): pointer to name of binary output file (to be created)
        working_dir (str or pathlib.Path): directory where swmm should be executed. Important if relative paths are in the input file. Default is directory of input-file.
    """
    fn_rpt_default, fn_out_default = get_result_filenames(fn_inp)
    if fn_rpt is None:
        fn_rpt = fn_rpt_default
    if fn_out is None:
        fn_out = fn_out_default

    try:
        from swmm.toolkit import solver
    except ModuleNotFoundError as e:
        raise (e, SWMMRunError('to run SWMM with OWA-SWMM you have to install the swmm-toolkit package (pip install swmm-toolkit).'))

    try:
        if working_dir is None:
            working_dir = Path(fn_inp).resolve().parent

        with TemporaryWorkingDirectory(working_dir):
            solver.swmm_run(str(fn_inp), str(fn_rpt), str(fn_out))
        print('', end='\r')  # solver doesn't write a last new-line
    except Exception as e:
        raise SWMMRunError(f'{e.args[0]}\n{fn_inp}\n{get_report_errors(fn_rpt)}')


def get_swmm_version_owa():
    """
    Get the OWA-swmm version used for simulation with the API.

    Returns:
        str: swmm version
    """
    try:
        from swmm.toolkit import solver
    except ModuleNotFoundError as e:
        raise (e, SWMMRunError('to run SWMM with OWA-SWMM you have to install the swmm-toolkit package (pip install swmm-toolkit).'))

    return solver.swmm_version_info()
