from .run_epaswmm import swmm5_run_epa
from .run_pyswmm import swmm5_run_progress
from .run_swmm_toolkit import swmm5_run_owa


def swmm5_run(fn_inp, fn_rpt=None, fn_out=None, progress_size=None, swmm_lib_path=None, working_dir=None):
    """
    Run a simulation with SWMM.

    The default working directory is the input-file directory.

    If ``progress_size`` is given -> using PySWMM, (see :func:`~swmm_api.run_swmm.run_pyswmm.swmm5_run_progress`)
    otherwise using swmm-toolkit of OWA. (see :func:`~swmm_api.run_swmm.run_swmm_toolkit.swmm5_run_owa`)
    If none of them are installed -> searching for epa-swmm path. (see :func:`~swmm_api.run_swmm.run_epaswmm.swmm5_run_epa`)

    Args:
        fn_inp (str or pathlib.Path): pointer to name of input file (must exist)
        fn_rpt (str or pathlib.Path): pointer to name of report file (to be created)
        fn_out (str or pathlib.Path): pointer to name of binary output file (to be created)
        progress_size (int):  Number of progress bar iterations. (this will only work using pyswmm)
        swmm_lib_path (str or pathlib.Path): custom path to the command line swmm executable. i.e. 'C:\\Program Files\\EPA SWMM 5.2.0 (64-bit)\\runswmm.exe'.
                UNIX users should place the path to the swmm executable in the system path and name the file 'swmm5'.
                Default: the api will search in the standard paths for the swmm exe.
                Be aware that the 'epaswmm5.exe' is the graphical user interface and will not work for this api.
        working_dir (str or pathlib.Path): directory where swmm should be executed. Important if relative paths are in the input file. Default is directory of input-file.
    """
    try:
        if progress_size:
            swmm5_run_progress(fn_inp, fn_rpt, fn_out, n_total=progress_size, swmm_lib_path=swmm_lib_path, working_dir=working_dir)
        else:
            swmm5_run_owa(fn_inp, fn_rpt, fn_out, working_dir=working_dir)
    except ImportError:  # pyswmm is not installed - try find SWMM
        swmm5_run_epa(fn_inp, fn_rpt, fn_out, swmm_path=swmm_lib_path, working_dir=working_dir)
