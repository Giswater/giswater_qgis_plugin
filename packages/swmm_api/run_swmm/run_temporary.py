import shutil
import tempfile
from pathlib import Path

from .run_pyswmm import swmm5_run_progress
from .run_swmm_toolkit import swmm5_run_owa
from .run_epaswmm import swmm5_run_epa
from .run import swmm5_run
from ._run_helpers import get_result_filenames
from .._io_helpers import CONFIG
from ..input_file._type_converter import is_nan, is_placeholder, is_not_set
from ..input_file.sections import TimeseriesFile
from ..output_file import SwmmOutput
from ..report_file import SwmmReport, read_lid_report
from ..input_file import SEC, SwmmInput
from ..input_file.section_lists import GEO_SECTIONS, GUI_SECTIONS


class SwmmResults:
    def __init__(self, inp, fn_inp):
        self.inp = inp
        self._rpt = None
        self._out = None
        self._lid_rpts = None

        self._parent_path = fn_inp.parent
        self._fn_inp = fn_inp
        self._fn_rpt, self._fn_out = get_result_filenames(fn_inp)

    @property
    def rpt(self):
        if self._rpt is None:
            self._rpt = SwmmReport(self._fn_rpt)
        return self._rpt

    @property
    def out(self):
        if self._out is None:
            with SwmmOutput(self._fn_out) as out:
                out.to_numpy()
            self._out = out
        return self._out

    @property
    def lid_rpt_dict(self):
        """if LID report file exists, read file and save it in a dict with the key (SC label, LID label)"""
        if self._lid_rpts is None:
            self._lid_rpts = {}
            # get list of LID report files in inp data
            if SEC.LID_USAGE in self.inp:
                for lid_usage in self.inp.LID_USAGE.values():
                    if is_not_set(lid_usage.fn_lid_report):
                        continue  # no name defined -> no file will be written
                    pth = Path(lid_usage.fn_lid_report)

                    self._lid_rpts[(lid_usage.subcatchment, lid_usage.lid)] = read_lid_report(self._parent_path / pth)
        return self._lid_rpts


class swmm5_run_temporary:
    def __init__(self, inp: SwmmInput, cleanup=True, run=None, label='temp', set_saved_files_relative=False, base_path=None, **kwargs):
        """
        Run SWMM with an input file in a temporary directory.

        Examples:
            with swmm5_run_temporary(inp) as res:
                res  # type: swmm_api.run_summ.run_temporary.SwmmResults
                res.out  # type: SwmmOutput
                res.rpt  # type: SwmmReport
                res.inp  # type: SwmmInput
                res.lid_rpt  # type: dict[tuple(str, str), pandas.DataFrame]

        Args:
            inp (swmm_api.SwmmInput): SWMM input-file data.
            cleanup (bool): if temporary folder should be deleted after with-statement.
            run (function): function for running SWMM. The function should only have one positional argument: input_file_name. default from CONFIG.
            label (str): name for temporary files.
            set_saved_files_relative (bool): if all saved files should be set as relative path to be saved in the temporary folder.
            base_path (str or pathlib.Path): path where the files used (linked with relative paths) in the inp file are stored. default=current working directory.
        """
        self.inp = inp
        self.cleanup = cleanup
        self.pth_temp = Path(tempfile.mkdtemp())

        self.fn_inp = self.pth_temp / f'{label}.inp'

        inp.delete_sections(GEO_SECTIONS + GUI_SECTIONS + [SEC.TAGS])

        # ---
        # files used
        if base_path is None:
            pth_current = Path.cwd()
        else:
            pth_current = Path(base_path)

        # where to look:
        # when relative - look in current dir
        def _handle_files(fn):
            if Path(fn).is_file() and Path(fn).is_absolute():
                # print(Path(fn), 'is file')
                ...
            elif (pth_current / fn).is_file():
                # rename to pasted
                fn = str(pth_current / fn)
            else:
                # print('UNKONWN:', fn)
                ...
            # print(fn)
            return fn

        # RAINGAGES with file
        if SEC.RAINGAGES in self.inp:
            for rg in inp.RAINGAGES.values():
                if rg.source.upper() == 'FILE':
                    rg.filename = _handle_files(rg.filename)

        # TIMESERIES FILE
        if SEC.TIMESERIES in self.inp:
            for ts in inp.TIMESERIES.values():
                if isinstance(ts, TimeseriesFile):
                    # or isinstance(ts, TimeseriesFile)
                    ts.filename = _handle_files(ts.filename)

        # EVAPORATION
        if (SEC.EVAPORATION in self.inp) and 'FILE' in inp.EVAPORATION:
            inp.EVAPORATION['FILE'] = _handle_files(inp.EVAPORATION['FILE'])

        # TEMPERATURE
        if (SEC.TEMPERATURE in self.inp) and 'FILE' in inp.TEMPERATURE:
            inp.TEMPERATURE['FILE'] = _handle_files(inp.TEMPERATURE['FILE'])

        # BACKDROP
        if (SEC.BACKDROP in self.inp) and 'FILE' in inp.BACKDROP:
            inp.BACKDROP['FILE'] = _handle_files(inp.BACKDROP['FILE'])

        # FILES
        if (SEC.FILES in self.inp) and inp.FILES:
            for k, v in inp.FILES.items():
                inp.FILES[k] = _handle_files(v)

        # ---
        if set_saved_files_relative:
            # Remove write hotstart file when in relative path?
            # Maybe someone uses this file. Users have to check for their own.
            if SEC.FILES in inp:
                for key in inp.FILES:
                    if key.upper().startswith(inp.FILES.KEYS.SAVE):
                        # print('Are you using the saved file?')
                        pth = Path(inp.FILES[key])
                        # print(key, pth)
                        inp.FILES[key] = pth.name

            # Rename LID report to relative path.
            # Using a relative path will save the LID report into the temporary folder and will be deleted after the with-statement.
            # Using an absolute path will save the LID report into the given folder and will not be deleted.
            if SEC.LID_USAGE in inp:
                for lid_usage in inp.LID_USAGE.values():
                    if is_nan(lid_usage.fn_lid_report):
                        continue  # no name defined -> no file will be written
                    lid_usage.fn_lid_report = f'lid_rpt_{lid_usage.subcatchment}_{lid_usage.lid}.txt'

        inp.write_file(self.fn_inp, fast=True, encoding=CONFIG.encoding)

        if _ := 0:  # this code is not for running but to keep the imports, which are needed to enable the "eval" function below.
            swmm5_run_progress
            swmm5_run_owa
            swmm5_run

        if run is None:
            if isinstance(CONFIG.default_temp_run, str):
                run = eval(CONFIG.default_temp_run)
            else:
                run = CONFIG.default_temp_run  # type: function
        run(self.fn_inp, **kwargs)

    def __enter__(self):
        return SwmmResults(self.inp, self.fn_inp)

    def __exit__(self, exc_type, exc_val, exc_tb):
        if self.cleanup:
            shutil.rmtree(self.pth_temp)


def dummy_run(inp, skip_rpt=False, skip_out=False):
    pth_temp = Path(tempfile.mkdtemp())

    fn_inp_temp = pth_temp / 'temp.inp'

    inp.delete_sections(GEO_SECTIONS + GUI_SECTIONS + [SEC.TAGS])

    inp.write_file(fn_inp_temp, fast=True, encoding='utf-8')

    swmm5_run_epa(fn_inp_temp)

    fn_rpt, fn_out = get_result_filenames(fn_inp_temp)

    if skip_rpt:
        rpt = None
    else:
        rpt = SwmmReport(fn_rpt)

    if skip_out:
        out = None
    else:
        with SwmmOutput(fn_out) as out:
            out.to_numpy()

    shutil.rmtree(pth_temp)

    return rpt, out
