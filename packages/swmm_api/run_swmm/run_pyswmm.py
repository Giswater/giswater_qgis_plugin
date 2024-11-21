from datetime import timedelta
from math import floor
from pathlib import Path

from tqdm.auto import tqdm

from ._run_helpers import TemporaryWorkingDirectory


def swmm5_run_progress(fn_inp, fn_rpt=None, fn_out=None, n_total=100, swmm_lib_path=None, working_dir=None):
    """
    Run a simulation with OWA-SWMM (PySWMM package) and adding a progress bar.

    Args:
        fn_inp (str or pathlib.Path): pointer to name of input file (must exist)
        fn_rpt (str): pointer to name of report file (to be created)
        fn_out (str): pointer to name of binary output file (to be created)
        n_total (int): Number of progress bar iterations.
        swmm_lib_path: User-specified SWMM library path (default None).
        working_dir (str or pathlib.Path): directory where swmm should be executed. Important if relative paths are in the input file. Default is directory of input-file.
    """
    from pyswmm import Simulation

    if working_dir is None:
        working_dir = Path(fn_inp).resolve().parent

    with TemporaryWorkingDirectory(working_dir):
        with Simulation(inputfile=str(fn_inp), reportfile=fn_rpt, outputfile=fn_out) as sim:  # , swmm_lib_path=swmm_lib_path
            total_time_seconds = (sim.end_time - sim.start_time) / timedelta(seconds=1)
            sim.step_advance(floor(total_time_seconds / n_total))

            with tqdm(total=n_total, desc=f'swmm5 {fn_inp}') as progress:
                for _ in sim:
                    progress.update(1)
                    progress.postfix = f'{sim.current_time}'
                progress.update(progress.total - progress.n)
                progress.postfix = f'{sim.current_time}'
