# from: https://timcera.bitbucket.io/swmmtoolbox/docsrc/index.html
# https://bitbucket.org/timcera/swmmtoolbox/src/master/swmmtoolbox/swmmtoolbox.py
# copied to reduce dependencies
# ORIGINAL Author Tim Cera with BSD License
# Rewritten for custom use

# SWMM Version > 5.10.10
# Python Version >= 3.7

import copy

import datetime
from io import SEEK_END, SEEK_SET
from pathlib import Path

from warnings import warn

from .definitions import OBJECTS, VARIABLES
from .._io_helpers._read_bin import BinaryReader

VARIABLES_DICT = {
    OBJECTS.SUBCATCHMENT: VARIABLES.SUBCATCHMENT.LIST_,
    OBJECTS.NODE        : VARIABLES.NODE.LIST_,
    OBJECTS.LINK        : VARIABLES.LINK.LIST_,
    OBJECTS.POLLUTANT   : [],
    OBJECTS.SYSTEM      : VARIABLES.SYSTEM.LIST_,
}

_RECORDSIZE = 4
_FLOW_UNITS_METRIC = ['CMS', 'LPS', 'MLD']
_FLOW_UNITS_IMPERIAL = ['CFS', 'GPM', 'MGD']
_FLOW_UNITS = _FLOW_UNITS_IMPERIAL + _FLOW_UNITS_METRIC + [None]
_CONCENTRATION_UNITS = ['MG', 'UG', 'COUNTS']
_MAGIC_NUMBER = 516114522
_PROPERTY_LABELS = ['type', 'area', 'invert', 'max_depth', 'offset', 'length']
_NODES_TYPES = ['JUNCTION', 'OUTFALL', 'STORAGE', 'DIVIDER']
_LINK_TYPES = ['CONDUIT', 'PUMP', 'ORIFICE', 'WEIR', 'OUTLET']

_ERROR_MESSAGE_PREFIX = '*   '


class SwmmExtractValueError(Exception):
    def __init__(self, message):
        super().__init__(f'\n*\n{_ERROR_MESSAGE_PREFIX}{message}\n*\n')


class SwmmOutExtractWarning(UserWarning):
    pass


class SwmmOutExtract(BinaryReader):
    """
    The class that handles all extraction of data from the out file.

    Attributes:
        flow_unit (str): Flow unit. One of [``'CMS', 'LPS', 'MLD', 'CFS', 'GPM', 'MGD'``]
        labels (dict[str, list]): dictionary of the object labels as list (value) for each object type
            (keys are: ``'link'``, ``'node'``, ``'subcatchment'``)
        model_properties (dict[str, [dict[str, list]]]): property values for the subcatchments, nodes and links. 
            The Properties for the objects are.
        
                    - ``subcatchment``
                      - [area]
                    - ``node``
                      - [type, invert, max. depth]
                    - ``link``
                      - type, 
                      - offsets
                        - ht. above start node invert (ft), 
                        - ht. above end node invert (ft), 
                      - max. depth,
                      - length
        
        n_periods (int): number of periods (=index-values)
        pollutant_units (dict[str, str]): Units per pollutant.
        _pos_start_output (int): Start position of the data.
        report_interval (datetime.timedelta): Intervall of the index.
        start_date (datetime.datetime): Start date of the data.
        swmm_version (str): SWMM Version
        variables (dict[str, list]): variables per object-type inclusive the pollutants.
        fp (file-like): Stream of the open file.
        filename (str): Path to the .out-file.

    Args:
        filename (str): Path to the .out-file.
        encoding (str): Encoding of the text in the binary-file (None -> auto-detect encoding ... takes a few seconds | '' -> use default = 'utf-8')
    """
    filename: str or Path

    def __init__(self, filename, skip_init=False, encoding=''):
        super().__init__(filename, encoding)

        if skip_init:
            return
        # ____
        self.fp.seek(-6 * _RECORDSIZE, SEEK_END)
        (
            _pos_start_labels,  # starting file position of ID names
            _pos_start_input,  # starting file position of input data
            _pos_start_output,  # starting file position of output data
            self.n_periods,  # Number of reporting periods
            error_code,
            magic_num_end,
        ) = self._next(6)

        # ____
        self.fp.seek(0, SEEK_SET)
        magic_num_start = self._next()

        self.run_failed = False
        # ____
        # check errors
        if magic_num_start != _MAGIC_NUMBER:
            raise SwmmExtractValueError(f'Beginning magic number incorrect.\n'
                                        f'{_ERROR_MESSAGE_PREFIX}Potential causes for this issue include either the file ({self.filename}) not being a binary SWMM output file\n'
                                        f'{_ERROR_MESSAGE_PREFIX}or the output file being corrupted.')

        if magic_num_end != _MAGIC_NUMBER:
            warn('Ending magic number incorrect.', SwmmOutExtractWarning)
            # raise SwmmExtractValueError('Ending magic number incorrect.')
            self.run_failed = True
        elif error_code != 0:
            warn(f'Error code "{error_code}" in output file indicates a problem with the run.', SwmmOutExtractWarning)
            # raise SwmmExtractValueError(f'Error code "{error_code}" in output file indicates a problem with the run.')
            self.run_failed = True

        # ---
        # read additional parameters from start of file
        # Version number i.e. "51015"
        self.swmm_version, self.flow_unit, n_subcatch, n_nodes, n_links, n_pollutants = self._next(6)
        self.flow_unit = _FLOW_UNITS[self.flow_unit]

        # ____
        # self.fp.seek(_pos_start_labels, SEEK_SET)  # not needed!
        # print(self.fp.tell(), _pos_start_labels)
        # assert _pos_start_labels == self.fp.tell()
        # ____
        # Read in the names
        # get the dictionary of the object labels for each object type (link, node, subcatchment)
        self.labels = {}
        for kind, n in zip(OBJECTS.LIST_, [n_subcatch, n_nodes, n_links, n_pollutants, 0]):
            self.labels[kind] = [self._next(n=self._next(), dtype='s') for _ in range(n)]

        # ____
        # print(self.fp.tell(), _pos_start_input)
        # assert _pos_start_input == self.fp.tell()
        # ____
        # Update variables to add pollutant names to subcatchment, nodes, and links.
        # get the dictionary of the object variables for each object type (link, node, subcatchment)
        self.variables = copy.deepcopy(VARIABLES_DICT)
        for kind in [OBJECTS.SUBCATCHMENT, OBJECTS.NODE, OBJECTS.LINK]:
            self.variables[kind] += self.labels[OBJECTS.POLLUTANT]

        # ____
        # System vars do not have names per se, but made names = number labels
        self.labels[OBJECTS.SYSTEM] = ['']  # self.variables[OBJECTS.SYSTEM]

        # ____
        # Read codes of pollutant concentration UNITS = Number of pollutants * 4 byte integers
        _pollutant_unit_labels = [_CONCENTRATION_UNITS[p] if p < len(_CONCENTRATION_UNITS) else 'nan'
                                  for p in self._next(n_pollutants, flat=False)]
        self.pollutant_units = dict(zip(self.labels[OBJECTS.POLLUTANT], _pollutant_unit_labels))

        # ____
        # property values for subcatchments, nodes and links
        #   subcatchment
        #     area
        #   node
        #     type, invert, & max. depth
        #   link
        #     type, offsets [ht. above start node invert (ft), ht. above end node invert (ft)], max. depth, & length
        self.model_properties = {}
        for kind in [OBJECTS.SUBCATCHMENT, OBJECTS.NODE, OBJECTS.LINK]:
            self.model_properties[kind] = {}
            # ------
            # read the property labels per object type
            property_labels = []
            for i in list(self._next(self._next(), flat=False)):
                property_label = _PROPERTY_LABELS[i]
                if property_label in property_labels:
                    property_label += '_2'
                property_labels.append(property_label)
            # ------
            # read the values per object and per property
            for label in self.labels[kind]:
                self.model_properties[kind][label] = {}
                for property_label in property_labels:
                    value = self._next(dtype={'type': 'i'}.get(property_label, 'f'))
                    if property_label == 'type':
                        value = {OBJECTS.NODE: _NODES_TYPES, OBJECTS.LINK: _LINK_TYPES}[kind][value]
                    self.model_properties[kind][label][property_label] = value

        # ____
        # double check variables
        for kind in [OBJECTS.SUBCATCHMENT, OBJECTS.NODE, OBJECTS.LINK, OBJECTS.SYSTEM]:
            n_vars = self._next()
            n_vars_labels = len(self.variables[kind])
            if n_vars != n_vars_labels:
                raise SwmmExtractValueError(f'Number of variables in out-file (={n_vars}) different to standard out-file (={n_vars_labels}) for object type "{kind}". Please add the variable names to swmm_api.output_file.definitions.{kind.upper()}_VARIABLES.LIST_ object before reading custom out-file.')
            self._next(n_vars)

        # ____

        """
        // --- save starting report date & report step
        //     (if reporting start date > simulation start date then
        //      make saved starting report date one reporting period
        //      prior to the date of the first reported result)
        z = (double)ReportStep/86400.0;
        if ( StartDateTime + z > ReportStart ) z = StartDateTime;
        else
        {
            z = floor((ReportStart - StartDateTime)/z) - 1.0;
            z = StartDateTime + z*(double)ReportStep/86400.0;
        }
        fwrite(&z, sizeof(REAL8), 1, Fout.file);
        k = ReportStep;
        if ( fwrite(&k, sizeof(INT4), 1, Fout.file) < 1)
        {
            report_writeErrorMsg(ERR_OUT_WRITE, "");
            return ErrorCode;
        }
        """
        self._base_date = datetime.datetime(1899, 12, 30)
        _offset_start_td = datetime.timedelta(days=self._next(dtype='d'))
        # self.start_date_ = _base_date + _offset_start_td
        self.report_interval = datetime.timedelta(seconds=self._next())

        # ____
        self._bytes_per_period = self._infer_bytes_per_period()

        # ____
        # print(self.fp.tell(), _pos_start_output)
        # assert _pos_start_output == self.fp.tell()
        # if _pos_start_output == 0:
        # Out File not complete!
        self._pos_start_output = self.fp.tell()

        # ____
        # date-offset of the first index in the timeseries
        _offset_first_index_td = datetime.timedelta(days=self._next(dtype='d'))

        # rounding error in first offset (can only be an integer multiple of report_interval)
        _factor = (_offset_first_index_td - _offset_start_td) / self.report_interval

        # get real start date of the timeseries
        self.start_date = self._base_date + _offset_start_td + self.report_interval * int(_factor)

        # ____
        if magic_num_end != _MAGIC_NUMBER:
            self._infer_n_periods()
            warn('Infer time periods of the output file due to a corrupt SWMM .out-file.', SwmmOutExtractWarning)

        if self.n_periods == 0:
            warn('There are zero time periods in the output file.', SwmmOutExtractWarning)
            # raise SwmmExtractValueError('There are zero time periods in the output file.')

    def _infer_bytes_per_period(self):
        """
        Calculate the bytes for each time period when reading the computed results

        Returns:
            int: bytes per period
        """
        _bytes_per_period = 2  # for the datetime
        for obj in [OBJECTS.SUBCATCHMENT, OBJECTS.NODE, OBJECTS.LINK]:
            _bytes_per_period += len(self.variables[obj]) * len(self.labels[obj])
        _bytes_per_period += len(self.variables[OBJECTS.SYSTEM])
        _bytes_per_period *= _RECORDSIZE
        return _bytes_per_period

    def _get_labels_and_offsets(self, columns):
        n_vars_subcatch = len(self.variables[OBJECTS.SUBCATCHMENT])
        n_vars_node = len(self.variables[OBJECTS.NODE])
        n_vars_link = len(self.variables[OBJECTS.LINK])

        n_subcatch = len(self.labels[OBJECTS.SUBCATCHMENT])
        n_nodes = len(self.labels[OBJECTS.NODE])
        n_links = len(self.labels[OBJECTS.LINK])

        offset_list = []
        label_list = []

        for kind, label, variable in columns:
            label_list.append('/'.join([kind, label, variable]))

            index_kind = OBJECTS.LIST_.index(kind)
            index_variable = self.variables[kind].index(variable)
            item_index = self.labels[kind].index(str(label))
            offset_list.append((2 + index_variable + {
                0: (item_index * n_vars_subcatch),
                1: (n_subcatch * n_vars_subcatch +
                    item_index * n_vars_node),
                2: (n_subcatch * n_vars_subcatch +
                    n_nodes * n_vars_node +
                    item_index * n_vars_link),
                4: (n_subcatch * n_vars_subcatch +
                    n_nodes * n_vars_node +
                    n_links * n_vars_link)
            }[index_kind]) * _RECORDSIZE)

        return label_list, offset_list

    def _get_start_position_and_periods(self, start=None, end=None):
        if all([i is None for i in [start, end]]):
            return self._pos_start_output, self.n_periods

        if start is None:
            i_period_start = 0
        else:
            i_period_start = (start - self.start_date) / self.report_interval

        if end is None:
            i_period_end = self.n_periods  # - i_period_start
        else:
            i_period_end = (end - self.start_date) / self.report_interval + 1

        n_periods = i_period_end - i_period_start
        pos_start_output = self._pos_start_output + i_period_start * self._bytes_per_period
        return int(pos_start_output), int(n_periods)

    def _get_selective_results(self, columns, show_progress=True, start=None, end=None):
        """
        Get results of selective columns in .out-file.

        This function is due to its iterative reading slow,
        but has its advantages with out-files with many columns (>1000) and fewer time-steps

        Args:
            columns (list[tuple]): list of column identifier tuple with [(kind, label, variable), ...]
            show_progress (bool): show a progress bar.
            start (datetime): start datetime for the period to read.
            end (datetime): end datetime for the period to read.

        Returns:
            dict[str, list]: dictionary where keys are the column names ('/' as separator) and values are the list of result values
        """
        progress_desc = f'{repr(self)}.get_selective_results(n_cols={len(columns)})'

        label_list, offset_list = self._get_labels_and_offsets(columns)
        pos_start_output, n_periods = self._get_start_position_and_periods(start, end)

        # ---
        # from ._basic_selective_results import _get_selective_results  # cpython
        from ._basic_selective_results_python import _get_selective_results
        v = _get_selective_results(self.fp, label_list, offset_list, pos_start_output,
                                   n_periods, self._bytes_per_period, progress_desc, show_progress)
        return v

    def _infer_n_periods(self):
        """
        Internal function to infer the number of periods written in the out-file.

        This is needed when the outfile was not generated properly.

        Sets the attribute n_periods.
        """
        # print('start _infer_n_periods')
        not_done = True
        # print(f'{self.filename.stat().st_size:_d}')
        # 192_159_825_920 filesize
        # 179_517_985_920
        #       2_409_120 approx. index size
        #          18_627 column size
        #          91_772 already read bytes
        #          74_516 bytes per period
        # print(self.number_columns)
        # print(self._bytes_per_period)

        last_offset = self.fp.seek(-6*_RECORDSIZE, SEEK_END)
        est_n_periods = int((last_offset - self._pos_start_output) / self._bytes_per_period)-1
        # self.n_periods

        step = int(est_n_periods / 4)
        period = 0

        # 1289386
        # 2311667
        # print(f'{est_n_periods=} | {step=}')

        # self.start_date

        # start_date = self._base_date + _offset_start_td + self.report_interval * int(_factor)

        # self.start_date + est_n_periods * self.report_interval

        # self.fp.tell()
        import math

        # period = est_n_periods-1

        first_failed = False
        i = 1
        while not_done:
            dt_theory = self.start_date + period * self.report_interval
            # print(f'___\n{i}: {period=}/{est_n_periods} | {str(dt_theory)=} | {step=}')
            # print(f'pos={self._pos_start_output + period * self._bytes_per_period}')
            self.fp.seek(self._pos_start_output + period * self._bytes_per_period, SEEK_SET)
            try:
                dt = self._next(dtype='d')  # unpack requires a buffer of 8 bytes

                # print(f'{dt=}')
                # if dt is very large, python will raise an error
                # dt can also be near zero, what is also an error, but will not raise

                # print(self._base_date + datetime.timedelta(days=dt))
                # print(f'tell={self.fp.tell()}')
                if dt < 0.00000001:
                    raise EOFError('dt < 0.00000001')

                if first_failed:
                    step = math.ceil(step/2)
                period += step

            except Exception as e:
                if not first_failed:
                    first_failed = True

                # print('###', e, f'tell={self.fp.tell()}')

                if step <= 1:
                    break

                step = math.ceil(step/2)
                period -= step
            i += 1

        self.n_periods = period

    def copy(self):
        new = type(self)(self.filename, skip_init=True)
        new.__dict__ = vars(self)
        return new
