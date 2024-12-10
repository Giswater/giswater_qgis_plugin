__author__ = "Markus Pichler"
__credits__ = ["Markus Pichler"]
__maintainer__ = "Markus Pichler"
__email__ = "markus.pichler@tugraz.at"
__version__ = "0.1"
__license__ = "MIT"


import os
import re
import shutil
import subprocess
import warnings
from pathlib import Path
from sys import platform as _platform

from ._run_helpers import SWMMRunError, get_report_errors
from .._io_helpers import CONFIG


def get_swmm_command_line(swmm_path, inp, rpt, out):
    cmd = (str(swmm_path), str(inp), str(rpt), str(out))
    return cmd


def infer_swmm_path():
    # if an exe/bin is already configured, use it
    if CONFIG['exe_path'] is not None:
        return CONFIG['exe_path']

    # UNIX
    fn_base = ('runswmm', 'swmm5')
    suffix = ''

    # WINDOWS
    if _platform.startswith("win"):
        suffix = '.exe'

    # search in path
    sys_path = [Path(p) for p in os.environ['PATH'].split(';')]
    possible_exe = [fn
                    for pth in sys_path if pth.is_dir()
                    for fn in pth.iterdir() if ((fn.stem in fn_base) and (fn.suffix == suffix))]


    # if found set it as default and return it
    if possible_exe:
        CONFIG['exe_path'] = str(possible_exe[0])
        return CONFIG['exe_path']

    # look for swmm in default installation path
    if _platform.startswith("win"):
        swmm_paths = {}
        # script_path = '???/swmm5.exe'
        for program_files in ('PROGRAMFILES', 'PROGRAMFILES(X86)'):
            parent = Path(os.environ[program_files])
            for pth in parent.iterdir():
                if 'EPA SWMM' in pth.name:
                    version_number = re.search( r"\d+(\.\d+)*", pth.name).group()
                    for base in fn_base:
                        exe_pth = pth / f'{base}{suffix}'
                        if (version_number not in swmm_paths) and exe_pth.is_file():
                            # extract version number from string using regex
                            swmm_paths[version_number] = exe_pth

        biggest_version = sorted(swmm_paths, reverse=True)[0]

        CONFIG['exe_path'] = swmm_paths[biggest_version]
        return CONFIG['exe_path']


def text_swmm_path(swmm_path):
    try:
        get_swmm_version_base(swmm_path)
    except FileNotFoundError:
        raise SWMMRunError('Path to SWMM command line executable not found. Please pass a custom path to the swmm5.exe using the "swmm_path" argument.')


def _to_path(pth, default):
    if pth is None:
        pth = default
    elif isinstance(pth, str):
        pth = Path(pth)

    if not pth.is_absolute():
        pth = pth.resolve()
    return pth


def resolve_paths(fn_inp, pth_rpt_dir=None, pth_out_dir=None, pth_working_dir=None):
    """
    Check all paths.

    Make string to pathlib.Path and resolve relative paths.
    Set input dir as default working dir.

    Args:
        fn_inp (str or Path): path to input file
        pth_rpt_dir (str or Path): directory in which the report-file is written.
        pth_out_dir (str or Path): directory in which the output-file is written.
        pth_working_dir (str | Path): directory where swmm should be executed. Important if relative paths are in the input file. Default is directory of input-file.

    Returns:
        tuple[Path, Path, Path, Path]: fn_inp, pth_rpt_dir, pth_out_dir, pth_working_dir
    """
    fn_inp = _to_path(fn_inp, ...)

    # ---
    pth_rpt_dir = _to_path(pth_rpt_dir, fn_inp.parent)
    fn_rpt = pth_rpt_dir / (fn_inp.stem + '.rpt')

    # ---
    pth_out_dir = _to_path(pth_out_dir, fn_inp.parent)
    fn_out = pth_out_dir / (fn_inp.stem + '.out')

    # ---
    pth_working_dir = _to_path(pth_working_dir, fn_inp.parent)

    # ---
    if not fn_inp.is_file():
        raise FileNotFoundError(f'inputfile {fn_inp} not found.')

    if not pth_working_dir.is_dir():
        raise NotADirectoryError(f'Working dir {pth_working_dir} not found.')

    # ---
    return fn_inp, fn_rpt, fn_out, pth_working_dir


def is_executable_available(exec_name):
    # Check if the executable is in the system path
    if shutil.which(exec_name):
        return True

    # Check if it's an absolute path and the file exists and is executable
    if os.path.isabs(exec_name) and os.path.isfile(exec_name) and os.access(exec_name, os.X_OK):
        return True

    # Check if it's a relative path, and the file exists and is executable
    if os.path.isfile(exec_name) and os.access(exec_name, os.X_OK):
        return True

    return False


def get_swmm_command_line_auto(fn_inp, fn_rpt, fn_out, create_out=True, swmm_path=None):
    # -----------------------
    if swmm_path is None:
        swmm_path = infer_swmm_path()
    else:
        ...  # TODO check if in system path or valide file name
        # if executed -> raises a file not found error

    if not is_executable_available(swmm_path):
        warnings.warn(f'Executable of SWMM not found ({swmm_path}).')

    return get_swmm_command_line(swmm_path, fn_inp, fn_rpt, fn_out if create_out else '')


def run_swmm_stdout(command_line, sep='_' * 100, working_dir=None):
    print(sep)
    print(*command_line, sep=' | ')
    subprocess.run(command_line, cwd=working_dir)
    print(sep)


def run_swmm_custom(command_line, working_dir=None):
    # shell_output = subprocess.run(command_line, shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    shell_output = subprocess.run(command_line, capture_output=True, cwd=working_dir)
    return shell_output


def swmm5_run_epa(inp, rpt_dir=None, out_dir=None, init_print=False, create_out=True, swmm_path=None, working_dir=None):
    r"""
    Run a simulation with EPA-SWMM.

    EPA-SWMM must be installed in the default folder.
    In linux and mac (\*nix) swmm must be executeable with the `swmm5` command.

    The default working directory is the input-file directory.

    Args:
        inp (str or Path): path to input file
        rpt_dir (str or Path): directory in which the report-file is written.
        out_dir (str or Path): directory in which the output-file is written.
        init_print (bool): if the default commandline output should be printed
        create_out (bool): if the out-file should be created
        swmm_path (str): custom path to the command line swmm executable. i.e. ``C:\\Program Files\\EPA SWMM 5.2.0 (64-bit)\\runswmm.exe``.
                UNIX users should place the path to the swmm executable in the system path and name the file ``swmm5``.
                Default: the api will search in the standard paths for the swmm exe.
                Be aware that the ``epaswmm5.exe`` is the graphical user interface and will not work for this api.
        working_dir (str or Path): directory where swmm should be executed. Important if relative paths are in the input file. Default is directory of input-file.

    Returns:
        tuple[str | Path, str | Path]: INP-, RPT- and OUT-filename
    """
    fn_inp, fn_rpt, fn_out, working_dir = resolve_paths(inp, rpt_dir, out_dir, working_dir)

    command_line = get_swmm_command_line_auto(fn_inp, fn_rpt, fn_out, create_out=create_out, swmm_path=swmm_path)

    if init_print:
        run_swmm_stdout(command_line, working_dir=working_dir)
        stdout = ' '.join(command_line)
    else:
        stdout = run_swmm_custom(command_line, working_dir=working_dir)

    check_swmm_errors(fn_rpt, stdout)

    return fn_rpt, fn_out


def swmm5_run_parallel(inp_fns, processes=4):
    """
    run multiple swmm models in parallel

    Args:
        inp_fns (list): list of SWMM modell filenames (.inp-files)
        processes (int): number of parallel processes
    """
    _run_parallel(inp_fns, swmm5_run_epa, processes=processes)


def _run_parallel(variable, func=swmm5_run_epa, processes=4):
    from tqdm.auto import tqdm
    from functools import partial

    if processes == 1:
        for fn_inp in tqdm(variable):
            func(fn_inp)

    else:
        from multiprocessing.dummy import Pool

        pool = Pool(processes)
        for _ in tqdm(pool.imap(partial(func), variable), total=len(variable)):
            pass


def get_swmm_version_base(swmm_path):
    """
    Get the swmm version.

    Args:
        swmm_path (str): Path to swmm CLI exe.

    Returns:
        str: swmm version
    """
    shell_output = subprocess.check_output([swmm_path, '--version'])
    return shell_output.decode().strip()


def get_swmm_version_epa():
    """
    Get the EPA-swmm version used for simulation with the API.

    Returns:
        str: swmm version
    """
    swmm_path = infer_swmm_path()
    return get_swmm_version_base(swmm_path)


def check_swmm_errors(fn_rpt, shell_output):
    msgs = {}

    if isinstance(shell_output, str):  # init_print=True
        msgs['CALL'] = shell_output

    else:
        stdout = shell_output.stdout.decode()
        # if 'error' in stdout:
        msgs.update({
            'CALL'  : shell_output.args,
            'RETURN': shell_output.returncode,
            'ERROR' : shell_output.stderr.decode(),
            'OUT'   : stdout,
        })

    if isinstance(shell_output, str) or ('OUT' in msgs and 'error' in msgs['OUT']):
        msgs['REPORT'] = get_report_errors(fn_rpt)

    if ('REPORT' in msgs) and ((msgs['REPORT'] != 'No Errors.') or (msgs['REPORT'] == 'NO Report file created!!!')):
        sep = '\n' + '_' * 100 + '\n'
        error_msg = sep + sep.join(f'{k}:\n  {v}' for k, v in msgs.items())
        raise SWMMRunError(error_msg)
