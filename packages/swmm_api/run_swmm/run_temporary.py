import shutil
import tempfile
from pathlib import Path

from .run_epaswmm import swmm5_run_epa
from .run import swmm5_run
from ._run_helpers import get_result_filenames
from ..output_file import SwmmOutput
from ..report_file import SwmmReport
from ..input_file import SEC
from ..input_file.macros import delete_sections
from ..input_file.section_lists import GEO_SECTIONS, GUI_SECTIONS


class SwmmResults:
    def __init__(self, inp, fn_inp):
        self.inp = inp
        self._rpt = None
        self._out = None

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


class swmm5_run_temporary:
    def __init__(self, inp, cleanup=True, run=swmm5_run, label='temp'):
        self.inp = inp
        self.cleanup = cleanup
        self.pth_temp = Path(tempfile.mkdtemp())

        self.fn_inp = self.pth_temp / f'{label}.inp'

        delete_sections(inp, GEO_SECTIONS + GUI_SECTIONS + [SEC.TAGS])

        inp.write_file(self.fn_inp, fast=True, encoding='utf-8')
        run(self.fn_inp)

    def __enter__(self):
        return SwmmResults(self.inp, self.fn_inp)

    def __exit__(self, exc_type, exc_val, exc_tb):
        if self.cleanup:
            shutil.rmtree(self.pth_temp)


def dummy_run(inp, skip_rpt=False, skip_out=False):
    pth_temp = Path(tempfile.mkdtemp())

    fn_inp_temp = pth_temp / 'temp.inp'

    delete_sections(inp, GEO_SECTIONS + GUI_SECTIONS + [SEC.TAGS])

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
