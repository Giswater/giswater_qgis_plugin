from warnings import warn
import os

from pandas import to_datetime

from swmm_api.input_file.macros import (find_node,
                                        find_link, calc_slope, conduit_iter_over_inp, combined_subcatchment_frame, )
from swmm_api.input_file.macros.convert_object import junction_to_storage, junction_to_outfall
from swmm_api.input_file.macros.reduce_unneeded import reduce_curves, reduce_raingages
from swmm_api.input_file.macros.edit import delete_node, combine_conduits
from swmm_api import read_inp_file, swmm5_run
from swmm_api.input_file.section_types import SECTION_TYPES
from swmm_api.input_file import SwmmInput, section_labels as sec
from swmm_api.input_file._type_converter import offset2delta
from swmm_api.output_file import parquet_helpers as parquet
from swmm_api.output_file.out import read_out_file


class InpMacros(SwmmInput):
    def __init__(self):
        SwmmInput.__init__(self, {})
        self.filename = None
        self.basename = None
        self.dirname = None
        self._out = None

    def set_name(self, name):
        self.filename = name
        self.basename = '.'.join(os.path.basename(name).split('.')[:-1])
        self.dirname = os.path.dirname(name)

    @property
    def report_filename(self):
        return os.path.join(self.dirname, self.basename + '.rpt')

    @property
    def out_filename(self):
        return os.path.join(self.dirname, self.basename + '.out')

    @property
    def parquet_filename(self):
        return os.path.join(self.dirname, self.basename + '.parquet')

    def __repr__(self):
        return str(self)

    def __str__(self):
        return self.to_string()

    def read_file(self, **kwargs):
        data = read_inp_file(self.filename, **kwargs)
        SwmmInput.__init__(self, data)

    @classmethod
    def from_file(cls, filename, **kwargs):
        inp = cls()
        inp.set_name(filename)
        inp.read_file(**kwargs)
        return inp

    def write(self, fast=True):
        self.write_file(self.filename, fast=fast)

    # @classmethod
    # def from_pickle(cls, fn):
    #     new = cls()
    #     pkl_file = open(fn, 'rb')
    #     new._data = pickle.load(pkl_file)
    #     pkl_file.close()
    #     return new
    #
    # def to_pickle(self, fn):
    #     output = open(fn, 'wb')
    #     pickle.dump(self._data, output)
    #     output.close()

    # ------------------------------------------------------------------------------------------------------------------
    def execute_swmm(self, rpt_dir=None, out_dir=None, init_print=False):
        swmm5_run(self.filename, rpt_dir=rpt_dir, out_dir=out_dir, init_print=init_print)

    def delete_report_file(self):
        os.remove(self.report_filename)

    def delete_inp_file(self):
        os.remove(self.filename)

    def run(self, rpt_dir=None, out_dir=None, init_print=False):
        self.execute_swmm(rpt_dir=rpt_dir, out_dir=out_dir, init_print=init_print)
        self.convert_out()

    def __getitem__(self, section):
        self.check_section(section)
        return SwmmInput.__getitem__(self, section)

    # ------------------------------------------------------------------------------------------------------------------
    @property
    def output_data(self):
        if self._out is None:
            self._out = read_out_file(self.out_filename)
        return self._out

    def get_out_frame(self):
        return self.output_data.to_frame()

    def convert_out(self):
        self.output_data.to_parquet()
        self.delete_out_file()

    def delete_out_file(self):
        # TODO check if file can be deleted
        self._out.close()
        try:
            os.remove(self.out_filename)
        except PermissionError as e:
            warn(str(e))

    def get_result_frame(self):
        if not os.path.isfile(self.parquet_filename):
            data = self.output_data.to_frame()
            self.convert_out()
            return data
        else:
            return parquet.read(self.parquet_filename)

    ####################################################################################################################
    def reset_section(self, section):
        if section in self:
            del self[section]
        self[section] = SECTION_TYPES[section]

    def check_section(self, section):
        if section not in self:
            self[section] = SECTION_TYPES[section]

    def set_start(self, start):
        if isinstance(start, str):
            start = to_datetime(start)
        self[sec.OPTIONS]['START_DATE'] = start.date()
        self[sec.OPTIONS]['START_TIME'] = start.time()

    def set_start_report(self, start):
        if isinstance(start, str):
            start = to_datetime(start)
        self[sec.OPTIONS]['REPORT_START_DATE'] = start.date()
        self[sec.OPTIONS]['REPORT_START_TIME'] = start.time()

    def set_end(self, end):
        if isinstance(end, str):
            end = to_datetime(end)
        self[sec.OPTIONS]['END_DATE'] = end.date()
        self[sec.OPTIONS]['END_TIME'] = end.time()

    def set_threads(self, num):
        self[sec.OPTIONS]['THREADS'] = num

    def ignore_rainfall(self, on=True):
        self[sec.OPTIONS]['IGNORE_RAINFALL'] = on

    def ignore_snowmelt(self, on=True):
        self[sec.OPTIONS]['IGNORE_SNOWMELT'] = on

    def ignore_groundwater(self, on=True):
        self[sec.OPTIONS]['IGNORE_GROUNDWATER'] = on

    def ignore_quality(self, on=True):
        self[sec.OPTIONS]['IGNORE_QUALITY'] = on

    def set_intervals(self, freq):
        new_step = offset2delta(freq)
        self[sec.OPTIONS]['REPORT_STEP'] = new_step
        self[sec.OPTIONS]['WET_STEP'] = new_step
        self[sec.OPTIONS]['DRY_STEP'] = new_step

    def activate_report(self, input=False, continuity=True, flowstats=True, controls=False):
        self[sec.REPORT]['INPUT'] = input
        self[sec.REPORT]['CONTINUITY'] = continuity
        self[sec.REPORT]['FLOWSTATS'] = flowstats
        self[sec.REPORT]['CONTROLS'] = controls

    def add_obj_to_report(self, obj_kind, new_obj):
        if isinstance(new_obj, str):
            new_obj = [new_obj]
        elif isinstance(new_obj, list):
            pass
        else:
            raise NotImplementedError(f'Type: {type(new_obj)} not implemented!')

        old_obj = self[sec.REPORT][obj_kind]
        if isinstance(old_obj, str):
            old_obj = [old_obj]
        elif isinstance(old_obj, (int, float)):
            old_obj = [str(old_obj)]
        elif isinstance(old_obj, list):
            pass
        elif old_obj is None:
            old_obj = []
        else:
            raise NotImplementedError(f'Type: {type(new_obj)} not implemented!')

        self[sec.REPORT][obj_kind] = old_obj + new_obj

    def add_nodes_to_report(self, new_nodes):
        self.add_obj_to_report('NODES', new_nodes)

    def add_links_to_report(self, new_links):
        self.add_obj_to_report('LINKS', new_links)

    # def add_timeseries_file(self, fn):
    #     if 'Files' not in self[sec.TIMESERIES]:
    #         self[sec.TIMESERIES]['Files'] = DataFrame(columns=['Type', 'Fname'])
    #
    #     self[sec.TIMESERIES]['Files'] = self[sec.TIMESERIES]['Files'].append(
    #         Series({'Fname': '"' + fn + '.dat"'}, name=path.basename(fn)))
    #     self[sec.TIMESERIES]['Files']['Type'] = 'FILE'

    def reduce_curves(self):
        reduce_curves(self)

    def reduce_raingages(self):
        reduce_raingages(self)

    def combined_subcatchment_infos(self):
        return combined_subcatchment_frame(self)

    def find_node(self, label):
        return find_node(self, label)

    def find_link(self, label):
        return find_link(self, label)

    def calc_slope(self, link_label):
        return calc_slope(self, link_label)

    def delete_node(self, node_label):
        delete_node(self, node_label)

    def combine_conduits(self, c1, c2):
        combine_conduits(self, c1, c2)

    def conduit_iter_over_inp(self, start, end=None):
        conduit_iter_over_inp(self, start, end=end)

    def junction_to_outfall(self, label, *args, **kwargs):
        junction_to_outfall(self, label, *args, **kwargs)

    def junction_to_storage(self, label, *args, **kwargs):
        junction_to_storage(self, label, *args, **kwargs)
