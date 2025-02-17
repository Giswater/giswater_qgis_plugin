__author__ = "Markus Pichler"
__credits__ = ["Markus Pichler"]
__maintainer__ = "Markus Pichler"
__email__ = "markus.pichler@tugraz.at"
__version__ = "0.1"
__license__ = "MIT"

import datetime
from pathlib import Path
import warnings

import pandas as pd

from .helpers import (_get_title_of_part, _remove_lines, _part_to_frame,
                      _continuity_part_to_dict, ReportUnitConversion,
                      _routing_part_to_dict, _quality_continuity_part_to_dict,
                      _transect_street_shape_converter, _options_part_to_dict, )
from .._io_helpers._encoding import get_default_encoding
from .._io_helpers._read_txt import read_txt_file
from ..input_file.helpers import natural_keys


class SwmmReport:
    """
    SWMM-report-file class.
    """

    def __init__(self, filename, encoding=''):
        """
        Read a SWMM-report-file (___.rpt).

        Args:
            filename (str or pathlib.Path): Path to  the rpt file.
            encoding (str): Encoding of the text-file (``None`` -> auto-detect encoding ... takes a few seconds | ``''`` -> use default = ``'utf-8'``).

        Notes:
            For more information see SWMM 5.1 User Manual | 9.1 Viewing a Status Report | S. 136
            Landuse Labels are not allowed to be longer than 13 characters!

        .. Important::
            The summary results displayed in these tables are based on results found at every
            computational time step and not just on the results from each reporting time step.
        """
        self._filename = Path(filename)
        # ________________
        self._raw_parts = {}
        self._converted_parts = {}
        # ________________
        # split report file to a dict
        self._report_to_dict(encoding=encoding)

        # ________________
        self._version_title = None
        self._note = None

        self._routing_time_step_summary = None

        # input summaries
        self._element_count = None
        self._rainfall_file_summary = None

        # ________________
        self._raingage_summary = None
        self._subcatchment_summary = None
        self._node_summary = None
        self._link_summary = None
        self._cross_section_summary = None
        self._transect_summary = None
        self._street_summary = None
        self._shape_summary = None

        self._runoff_quantity_continuity = None
        self._flow_routing_continuity = None
        self._groundwater_continuity = None
        self._quality_routing_continuity = None
        self._runoff_quality_continuity = None
        self._rainfall_dependent_ii = None

        self._highest_continuity_errors = None
        self._time_step_critical_elements = None
        self._highest_flow_instability_indexes = None

        self._analysis_options = None

        self._node_depth_summary = None
        self._node_inflow_summary = None
        self._node_surcharge_summary = None
        self._node_flooding_summary = None
        self._storage_volume_summary = None
        self._outfall_loading_summary = None

        self._link_flow_summary = None
        self._flow_classification_summary = None
        self._conduit_surcharge_summary = None

        self._subcatchment_runoff_summary = None

        self._groundwater_summary = None

        self._pollutant_summary = None
        self._landuse_summary = None
        self._link_pollutant_load_summary = None
        self._subcatchment_washoff_summary = None

        self._pumping_summary = None

        self._street_flow_summary = None

        self._lid_control_summary = None
        self._lid_performance_summary = None

        self._control_actions_taken = None

    def __repr__(self):
        return f'SwmmReport(file="{self._filename}")'

    def summary(self):
        """Prints overview of the content in the rpt-file."""
        print(repr(self), 'Headers:', *list(self._raw_parts.keys()), sep='\n  - ')
        # self._pprint({
        #
        # })

    def print_raw_part(self, part):
        print(self._raw_parts[part])

    def is_empty(self) -> bool:
        """Bool if file is empty."""
        return not bool(self._raw_parts)

    def is_file(self) -> bool:
        """Bool if file exists."""
        return self._filename.is_file()

    def _report_to_dict(self, encoding=''):
        """
        Convert the report file into a dictionary depending on the different parts.

        Args:
            encoding (str): Encoding of the text-file (None -> auto-detect encoding ... takes a few seconds | '' -> use default = 'utf-8')

        Returns:
            dict[str, str]: dictionary of parts of the report file
        """
        self._encoding = get_default_encoding(encoding, self._filename)

        txt = read_txt_file(self._filename, encoding=self._encoding)
        lines = txt.split('\n')

        if not txt:
            warnings.warn(f'SWMM-report-file ({self._filename}) is empty.')
            return

        self._raw_parts['Simulation Infos'] = '\n'.join(lines[-3:])
        lines = lines[:-3]
        parts0 = '\n'.join(lines).replace('\n\n  ****', '\n  \n  ****').split('\n  \n  ****')

        def _concat_lines(a, b):
            index_continuity = 28
            if a[:index_continuity] == b[:index_continuity]:
                return a + b[index_continuity:]
            else:
                return a + b

        for i, part in enumerate(parts0):
            if part.startswith('*'):
                part = '  ****' + part

            key = _get_title_of_part(part, i)
            new_lines = _remove_lines(part, title=False, empty=True, sep=False)
            if key in self._raw_parts:
                if new_lines.count('\n') == self._raw_parts[key].count('\n'):
                    self._raw_parts[key] = '\n'.join([_concat_lines(a, b) for a, b in zip(self._raw_parts[key].split('\n'), new_lines.split('\n'))])
            else:
                self._raw_parts[key] = new_lines

    def _get_converted_part(self, key):
        if key not in self._converted_parts:
            if key not in self._raw_parts:
                return
            self._converted_parts[key] = _remove_lines(self._raw_parts[key], title=True, empty=False)

        return self._converted_parts[key]

    @property
    def available_parts(self):
        """
        Available parts in the report file.

        Returns:
            list[str]: list of parts
        """
        return list(self._raw_parts.keys())

    @property
    def analysis_options(self):
        """
        Analysis Options

        Returns:
            dict[str, str | dict[str, str]]: Analysis Options
        """
        if self._analysis_options is None:
            p = self._get_converted_part('Analysis Options')
            self._analysis_options = _options_part_to_dict(p)
        return self._analysis_options

    @property
    def flow_unit(self):
        """
        Flow unit of the simulation.

        Returns:
            str: flow unit
        """
        if self.analysis_options is None:
            return
        if 'Flow Units' in self.analysis_options:
            return self.analysis_options['Flow Units']

    @property
    def unit(self):
        """
        Unit label for some part of the report file.

        Some columns or keys in the report use units. To write general functions for all units use this helper.

        Returns:
            swmm_api.report_file.helpers.ReportUnitConversion: helper for unit labels
        """
        if self.flow_unit:
            return ReportUnitConversion(self.flow_unit)

    @property
    def element_count(self):
        """
        Element Count

        Returns:
            dict[str, str]: element count
        """
        if self._element_count is None:
            p = self._get_converted_part('Element Count')
            self._element_count = _options_part_to_dict(p)
        return self._element_count

    @property
    def flow_routing_continuity(self):
        """
        Flow Routing Continuity

        Returns:
            dict[str, dict[str, float]]: Flow Routing Continuity
        """
        if self._flow_routing_continuity is None:
            raw = self._raw_parts.get('Flow Routing Continuity', None)
            self._flow_routing_continuity = _continuity_part_to_dict(raw)
        return self._flow_routing_continuity

    @property
    def runoff_quantity_continuity(self):
        """
        Runoff Quantity Continuity

        Returns:
            dict[str, dict[str, float]]: Runoff Quantity Continuity
        """
        if self._runoff_quantity_continuity is None:
            raw = self._raw_parts.get('Runoff Quantity Continuity', None)
            self._runoff_quantity_continuity = _continuity_part_to_dict(raw)
        return self._runoff_quantity_continuity

    @property
    def groundwater_continuity(self):
        """
        Groundwater Continuity

        Returns:
            dict[str, dict[str, float]]: Groundwater Continuity
        """
        if self._groundwater_continuity is None:
            p = self._raw_parts.get('Groundwater Continuity', None)
            self._groundwater_continuity = _continuity_part_to_dict(p)
        return self._groundwater_continuity

    @property
    def rainfall_dependent_ii(self):
        """
        Rainfall Dependent I/I

        Returns:
            dict[str, dict[str, float]]: Rainfall Dependent I/I
        """
        if self._rainfall_dependent_ii is None:
            p = self._raw_parts.get('Rainfall Dependent I/I', None)
            self._rainfall_dependent_ii = _continuity_part_to_dict(p)
        return self._rainfall_dependent_ii

    @property
    def quality_routing_continuity(self):
        """
        Quality Routing Continuity

        Returns:
            dict[str, dict[str, float]]: Quality Routing Continuity
        """
        if self._quality_routing_continuity is None:
            p = self._raw_parts.get('Quality Routing Continuity', None)
            self._quality_routing_continuity = _quality_continuity_part_to_dict(p)
        return self._quality_routing_continuity

    @property
    def runoff_quality_continuity(self):
        """
        Runoff Quality Continuity

        Returns:
            dict[str, dict[str, float]]: Runoff Quality Continuity
        """
        if self._runoff_quality_continuity is None:
            p = self._raw_parts.get('Runoff Quality Continuity', None)
            self._runoff_quality_continuity = _quality_continuity_part_to_dict(p)
        return self._runoff_quality_continuity

    @property
    def highest_continuity_errors(self):
        """
        Highest Continuity Errors

        Returns:
            dict[str, str]: Highest Continuity Errors
        """
        if self._highest_continuity_errors is None:
            p = self._get_converted_part('Highest Continuity Errors')
            self._highest_continuity_errors = _routing_part_to_dict(p)
        return self._highest_continuity_errors

    @property
    def time_step_critical_elements(self):
        """
        Time-Step Critical Elements

        Returns:
            dict: Time-Step Critical Elements
        """
        if self._time_step_critical_elements is None:
            p = self._get_converted_part('Time-Step Critical Elements')
            self._time_step_critical_elements = _routing_part_to_dict(p)
        return self._time_step_critical_elements

    @property
    def highest_flow_instability_indexes(self):
        """
        Highest Flow Instability Indexes

        Returns:
            dict: Highest Flow Instability Indexes
        """
        if self._highest_flow_instability_indexes is None:
            p = self._get_converted_part('Highest Flow Instability Indexes')
            self._highest_flow_instability_indexes = _routing_part_to_dict(p)
        return self._highest_flow_instability_indexes

    @property
    def node_summary(self):
        """
        Node Depth Summary

        Returns:
            pandas.DataFrame: Node Depth Summary
        """
        if self._node_summary is None:
            p = self._get_converted_part('Node Summary')
            self._node_summary = _part_to_frame(p)
        return self._node_summary

    @property
    def link_summary(self):
        """
        Node Depth Summary

        Returns:
            pandas.DataFrame: Node Depth Summary
        """
        if self._link_summary is None:
            p = self._get_converted_part('Link Summary')
            if p is None:
                return
            self._link_summary = _part_to_frame(p, replace_parts=(('From Node', 'FromNode'), ('To Node', 'ToNode')))
        return self._link_summary

    @property
    def rainfall_file_summary(self):
        """
        Node Depth Summary

        Returns:
            pandas.DataFrame: Node Depth Summary
        """
        if self._rainfall_file_summary is None:
            p = self._get_converted_part('Rainfall File Summary')
            # p = p.replace('Data Source', 'DataSource')
            self._rainfall_file_summary = _part_to_frame(p)
        return self._rainfall_file_summary

    @property
    def raingage_summary(self):
        """
        Node Depth Summary

        Returns:
            pandas.DataFrame: Node Depth Summary
        """
        if self._raingage_summary is None:
            p = self._get_converted_part('Raingage Summary')
            if p is None:
                return
            self._raingage_summary = _part_to_frame(p, replace_parts=('Data Source', 'DataSource'))
        return self._raingage_summary

    @property
    def subcatchment_summary(self):
        """
        Node Depth Summary

        Returns:
            pandas.DataFrame: Node Depth Summary
        """
        if self._subcatchment_summary is None:
            p = self._get_converted_part('Subcatchment Summary')
            if p is None:
                return
            self._subcatchment_summary = _part_to_frame(p, replace_parts=('Rain Gage', 'RainGage'))
        return self._subcatchment_summary

    @property
    def cross_section_summary(self):
        """
        Node Depth Summary

        Returns:
            pandas.DataFrame: Node Depth Summary
        """
        if self._cross_section_summary is None:
            p = self._get_converted_part('Cross Section Summary')
            self._cross_section_summary = _part_to_frame(p)
        return self._cross_section_summary

    @property
    def subcatchment_runoff_summary(self):
        """
        Subcatchment Runoff Summary

        Returns:
            pandas.DataFrame: Subcatchment Runoff Summary
        """
        if self._subcatchment_runoff_summary is None:
            p = self._get_converted_part('Subcatchment Runoff Summary')
            self._subcatchment_runoff_summary = _part_to_frame(p)
        return self._subcatchment_runoff_summary

    @property
    def node_depth_summary(self):
        """
        Node Depth Summary

        Returns:
            pandas.DataFrame: Node Depth Summary
        """
        if self._node_depth_summary is None:
            p = self._get_converted_part('Node Depth Summary')
            self._node_depth_summary = _part_to_frame(p)
        return self._node_depth_summary

    @property
    def node_inflow_summary(self):
        """
        Node Inflow Summary

        Example:
            ::

              -------------------------------------------------------------------------------------------------
                                              Maximum  Maximum                  Lateral       Total        Flow
                                              Lateral    Total  Time of Max      Inflow      Inflow     Balance
                                               Inflow   Inflow   Occurrence      Volume      Volume       Error
              Node                 Type           LPS      LPS  days hr:min    10^6 ltr    10^6 ltr     Percent
              -------------------------------------------------------------------------------------------------

        Columns:
            ['Type', 'Maximum_Lateral_Inflow_LPS', 'Maximum_Total_Inflow_LPS',
            'Time of Max_Occurrence_days hr:min', 'Lateral_Inflow_Volume_10^6 ltr',
            'Total_Inflow_Volume_10^6 ltr', 'Flow_Balance_Error_Percent']

        Returns:
            pandas.DataFrame: Node Inflow Summary
        """
        if self._node_inflow_summary is None:
            p = self._get_converted_part('Node Inflow Summary')
            self._node_inflow_summary = _part_to_frame(p)
        return self._node_inflow_summary

    @property
    def node_surcharge_summary(self):
        """
        Node Surcharge Summary

        Returns:
            pandas.DataFrame: Node Surcharge Summary
        """
        if self._node_surcharge_summary is None:
            p = self._get_converted_part('Node Surcharge Summary')
            self._node_surcharge_summary = _part_to_frame(p)
        return self._node_surcharge_summary

    @property
    def node_flooding_summary(self):
        """
        Node Flooding Summary

        Returns:
            pandas.DataFrame: Node Flooding Summary
        """
        if self._node_flooding_summary is None:
            p = self._get_converted_part('Node Flooding Summary')
            self._node_flooding_summary = _part_to_frame(p)
        return self._node_flooding_summary

    @property
    def storage_volume_summary(self):
        """
        Storage Volume Summary

        Returns:
            pandas.DataFrame: Storage Volume Summary
        """
        if self._storage_volume_summary is None:
            p = self._get_converted_part('Storage Volume Summary')
            self._storage_volume_summary = _part_to_frame(p, replace_parts=('Storage Unit', 'Storage_Unit'))
        return self._storage_volume_summary

    @property
    def outfall_loading_summary(self):
        """
        Outfall Loading Summary

        Examples:
            ::

              -----------------------------------------------------------
                                     Flow       Avg       Max       Total
                                     Freq      Flow      Flow      Volume
              Outfall Node           Pcnt       LPS       LPS    10^6 ltr
              -----------------------------------------------------------

        columns = [Flow_Frag_Pct, Avg_Flow_LPS, Max_Flow_LPS, Total_Volume_10^6 ltr]

        Returns:
            pandas.DataFrame: Outfall Loading Summary
        """
        if self._outfall_loading_summary is None:
            p = self._get_converted_part('Outfall Loading Summary')
            self._outfall_loading_summary = _part_to_frame(p, replace_parts=('Outfall Node', 'Outfall_Node'))
        return self._outfall_loading_summary

    @property
    def link_flow_summary(self):
        """
        Link Flow Summary

        Returns:
            pandas.DataFrame: Link Flow Summary
        """
        if self._link_flow_summary is None:
            p = self._get_converted_part('Link Flow Summary')
            self._link_flow_summary = _part_to_frame(p)
        return self._link_flow_summary

    @property
    def flow_classification_summary(self):
        """
        Flow Classification Summary (Dynamic Wave Routing Only)

        Ratio of adjusted conduit length to actual length
        Fraction of all time steps spent in the following flow categories:
          - dry on both ends
          - dry on the upstream end
          - dry on the downstream end
          - subcritical flow
          - supercritical flow
          - critical flow at the upstream end
          - critical flow at the downstream end
        Fraction of all time steps flow is limited to normal flow
        Fraction of all time steps flow is inlet controlled (for culverts only)

        Returns:
            pandas.DataFrame: Flow Classification Summary
        """
        if self._flow_classification_summary is None:
            p = self._get_converted_part('Flow Classification Summary')
            t = '---------- Fraction of Time in Flow Class ----------'
            self._flow_classification_summary = _part_to_frame(p, replace_parts=(t, ' ' * len(t)))
        return self._flow_classification_summary

    @property
    def conduit_surcharge_summary(self):
        """
        Conduit Surcharge Summary

        Hours that conduit is full at:

          - both ends*
          - upstream end
          - downstream end

        Hours that conduit flows above full normal flow
        Hours that conduit is capacity limited*

        Note: only conduits with one or more non-zero entries are listed and
        a conduit is considered capacity limited if its upstream end is full and
        the HGL slope is greater than the conduit slope.

        Returns:
            pandas.DataFrame: Conduit Surcharge Summary
        """
        if self._conduit_surcharge_summary is None:
            p = self._get_converted_part('Conduit Surcharge Summary')
            self._conduit_surcharge_summary = _part_to_frame(p, replace_parts=(('--------- Hours Full -------- ', 'HoursFull Hours Full HoursFull'),
                                                                               ('Both Ends', 'Both_Ends')))
        return self._conduit_surcharge_summary

    @property
    def control_actions_taken(self):
        """
        Control Actions Taken

        Returns:
            list[str]: Control Actions Taken
        """
        if self._control_actions_taken is None:
            p = self._get_converted_part('Control Actions Taken')
            if p:
                self._control_actions_taken = p.split('\n')
        return self._control_actions_taken

    @property
    def groundwater_summary(self):
        """
        Groundwater Summary

        Returns:
            pandas.DataFrame: Groundwater Summary
        """
        if self._groundwater_summary is None:
            p = self._get_converted_part('Groundwater Summary')
            self._groundwater_summary = _part_to_frame(p)
        return self._groundwater_summary

    @property
    def landuse_summary(self):
        """
        Landuse Summary

        Returns:
            pandas.DataFrame: Landuse Summary
        """
        if self._landuse_summary is None:
            p = self._get_converted_part('Landuse Summary')
            self._landuse_summary = _part_to_frame(p)
        return self._landuse_summary

    @property
    def lid_control_summary(self):
        """
        LID Control Summary

        Returns:
            pandas.DataFrame: LID Control Summary
        """
        if self._lid_control_summary is None:
            p = self._get_converted_part('LID Control Summary')
            self._lid_control_summary = _part_to_frame(p)
        return self._lid_control_summary

    @property
    def lid_performance_summary(self):
        """
        LID Performance Summary

        Returns:
            pandas.DataFrame: LID Performance Summary
        """
        if self._lid_performance_summary is None:
            p = self._get_converted_part('LID Performance Summary')
            self._lid_performance_summary = _part_to_frame(p, replace_parts=('LID Control', 'LID_Control'))
        return self._lid_performance_summary

    @property
    def link_pollutant_load_summary(self):
        """
        Link Pollutant Load Summary

        Returns:
            pandas.DataFrame: Link Pollutant Load Summary
        """
        if self._link_pollutant_load_summary is None:
            p = self._get_converted_part('Link Pollutant Load Summary')
            self._link_pollutant_load_summary = _part_to_frame(p)
        return self._link_pollutant_load_summary

    @property
    def note(self):
        """
        Note

        Returns:
            str: Node
        """
        if self._note is None:
            p = self._get_converted_part('Note')
            if p:
                self._note = ' '.join(p.strip(' *').split())
        return self._note

    @property
    def pollutant_summary(self):
        """
        Pollutant Summary

        Returns:
            pandas.DataFrame: Pollutant Summary
        """
        if self._pollutant_summary is None:
            p = self._get_converted_part('Pollutant Summary')
            self._pollutant_summary = _part_to_frame(p)
        return self._pollutant_summary

    @property
    def pumping_summary(self):
        """
        Pumping Summary

        Returns:
            pandas.DataFrame: Pumping Summary
        """
        if self._pumping_summary is None:
            p = self._get_converted_part('Pumping Summary')
            self._pumping_summary = _part_to_frame(p)
        return self._pumping_summary

    @property
    def street_flow_summary(self):
        """
        Street Flow Summary

        Returns:
            pandas.DataFrame: Street Flow Summary
        """
        if self._street_flow_summary is None:
            p = self._get_converted_part('Street Flow Summary')
            self._street_flow_summary = _part_to_frame(p, replace_parts=('Street Conduit', 'StreetConduit'))
        return self._street_flow_summary

    @property
    def routing_time_step_summary(self):
        """
        Routing Time Step Summary

        Returns:
            dict[str, float]: Routing Time Step Summary
        """
        if self._routing_time_step_summary is None:
            p = self._get_converted_part('Routing Time Step Summary')
            if p:
                self._routing_time_step_summary = {}
                for line in self._get_converted_part('Routing Time Step Summary').split('\n'):
                    if 'Time Step Frequencies' in line:
                        continue
                    key, value = ' '.join(line.split()).split(' : ')
                    if 'sec' in value:
                        value = pd.Timedelta(value)
                    elif '%' in value:
                        value = value
                    else:
                        value = float(value)
                    self._routing_time_step_summary[key] = value

        return self._routing_time_step_summary

    @property
    def subcatchment_washoff_summary(self):
        """
        Subcatchment Washoff Summary

        Returns:
            pandas.DataFrame: Subcatchment Washoff Summary
        """
        if self._subcatchment_washoff_summary is None:
            p = self._get_converted_part('Subcatchment Washoff Summary')
            self._subcatchment_washoff_summary = _part_to_frame(p)
        return self._subcatchment_washoff_summary

    @property
    def transect_summary(self):
        """
        Transect Summary

        Returns:
            dict[pandas.DataFrame]: Transect Summary
        """
        if self._transect_summary is None:
            p = self._get_converted_part('Transect Summary')
            self._transect_summary = _transect_street_shape_converter(p, key='Transect')
        return self._transect_summary

    @property
    def shape_summary(self):
        """
        Shape Summary

        Returns:
            dict[pandas.DataFrame]: Shape Summary
        """
        if self._shape_summary is None:
            p = self._get_converted_part('Shape Summary')
            self._shape_summary = _transect_street_shape_converter(p, key='Shape')
        return self._shape_summary

    @property
    def street_summary(self):
        """
        Street Summary

        Returns:
            dict[pandas.DataFrame]: Street Summary
        """
        if self._street_summary is None:
            p = self._get_converted_part('Street Summary')
            self._street_summary = _transect_street_shape_converter(p, key='Street')
        return self._street_summary
        pass

    # @property
    # def most_frequent_nonconverging_nodes(self):
    #     'Most Frequent Nonconverging Nodes'
    #     return

    def get_simulation_info(self):
        """
        Simulation Infos

        Returns:
            dict[str, str]: Simulation Infos
        """
        t = self._raw_parts.get('Simulation Infos', None)
        if t:
            return dict(line.strip().split(':', 1) for line in t.split('\n'))

    def _convert_str_time(self, s):
        import locale
        orig_locale = locale.getlocale(locale.LC_TIME)
        try:
            locale.setlocale(locale.LC_TIME, 'C')
            date_time = datetime.datetime.strptime(s.strip(), '%a %b %d %H:%M:%S %Y')
        except locale.Error:
            date_time = s
        locale.setlocale(locale.LC_TIME, orig_locale)
        return date_time

    @property
    def analyse_start(self):
        """
        Timestamp of the start of the simulation

        Returns:
            pd.Timestamp: Timestamp of the start of the simulation
        """
        info = self.get_simulation_info()
        if info:
            return self._convert_str_time(info['Analysis begun on'])

    @property
    def analyse_end(self):
        """
        Timestamp of the end of the simulation

        Returns:
            pd.Timestamp: Timestamp of the end of the simulation
        """
        info = self.get_simulation_info()
        if info:
            return self._convert_str_time(info['Analysis ended on'])

    @property
    def analyse_duration(self):
        """
        Total elapsed simulation duration.

        Returns:
            pandas.Timedelta: simulation duration
        """
        info = self.get_simulation_info()
        if info:
            v = info['Total elapsed time']
            if '< 1 sec' in v:
                return datetime.timedelta(seconds=1)
            di_td = {}
            if '.' in v:
                days, v = v.split('.')
                di_td['days'] = int(days)

            if v.count(':') == 2:
                di_td.update(dict(zip(('hours', 'minutes', 'seconds'), (int(i) for i in v.strip().split(':')))))

            return datetime.timedelta(**di_td)

    @staticmethod
    def _pretty_dict(di, chunk_size=20):
        if not di:
            return '{}'
        f = ''
        max_len = len(max(di.keys(), key=len)) + 7
        for key in sorted(di.keys()):
            value = di[key]
            if isinstance(value, (list, tuple, set)):
                key += f' ({len(value)})'
                value = sorted(value, key=natural_keys)
            key += ':'
            if isinstance(value, list) and len(value) > chunk_size:
                n = len(value)
                for i in range(0, n, chunk_size):
                    sub_value = str(value[i:i + chunk_size])
                    if i == 0:
                        sub_value = sub_value.replace(']', ',')
                    elif i + chunk_size >= n:
                        sub_value = sub_value.replace('[', ' ')

                    if i != 0:
                        key = ''

                    f += f'{key:<{max_len}}{sub_value}\n'
            else:
                f += f'{key:<{max_len}}{value}\n'
        return f

    def get_errors(self):
        """
        Malicious objects per error.

        Returns:
            dict[str, (str | bool | list[str])]: key is the error and value is a object label, a list of object-label or a bool
        """
        di = {}
        for part in ('Version+Title', 'Analysis Options'):
            t = self._raw_parts.get(part, None)
            if t:
                for line in t.split('\n'):
                    line = line.strip()
                    if line.startswith('ERROR'):
                        label, txt = line.split(':', 1)
                        if label in di:
                            di[label].append(txt)
                        else:
                            di[label] = [txt]
        return di

    def print_errors(self):
        """Print the errors in the report file in a pretty way."""
        print(self._pretty_dict(self.get_errors()))

    def get_version_title(self):
        """
        Get the version of SWMM used and title of the model.

        Returns:
            str: version and title
        """
        if self._version_title is None:
            t = self._raw_parts.get('Version+Title', None)
            self._version_title = t.split('\n')[0].strip()
        return self._version_title

    def get_warnings(self):
        """
        Get the malicious objects per warning.

        Returns:
            dict[str, (str | bool | list[str])]: key is the warning and value is a object label, a list of object-label or a bool

        Notes:
            WARNING 01: wet weather time step reduced to recording interval for Rain Gage xxx.
                The wet weather time step was automatically reduced so that no period with rainfall would be skipped
                during a simulation.
            WARNING 02: maximum depth increased for Node xxx.
                The maximum depth for the node was automatically increased to match the top of the highest connecting
                conduit.
            WARNING 03: negative offset ignored for Link xxx.
                The link’s stipulated offset was below the connecting node's invert so its actual offset was set to 0.
            WARNING 04: minimum elevation drop used for Conduit xxx.
                The elevation drop between the end nodes of the conduit was below 0.001 ft (0.00035 m) so the latter
                value was used instead to calculate its slope.
            WARNING 05: minimum slope used for Conduit xxx.
                The conduit's computed slope was below the user-specified Minimum Conduit Slope so the latter value was
                used instead.
            WARNING 06: dry weather time step increased to wet weather time step.
                The user-specified time step for computing runoff during dry weather periods was lower than that set for
                wet weather periods and was automatically increased to the wet weather value.
            WARNING 07: routing time step reduced to wet weather time step.
                The user-specified time step for flow routing was larger than the wet weather runoff time step and was
                automatically reduced to the runoff time step to prevent loss of accuracy.
            WARNING 08: elevation drop exceeds length for Conduit xxx.
                The elevation drop across the ends of a conduit exceeds its length. The program computes the conduit's
                slope as the elevation drop divided by the length instead of using the more accurate right triangle
                method. The user should check for errors in the length and in both the invert elevations and offsets at
                the conduit's upstream and downstream nodes.
            WARNING 09: time series interval greater than recording interval for Rain Gage xxx.
                The smallest time interval between entries in the precipitation time series used by the rain gage is
                greater than the recording time interval specified for the gage. If this was not actually intended then
                what appear to be continuous periods of rainfall in the time series will instead be read with time gaps
                in between them.
            WARNING 10: crest elevation is below downstream invert for regulator Link xxx.
                The height of the opening on an orifice, weir, or outlet is below the invert elevation of its downstream
                node. Users should check to see if the regulator's offset height or the downstream node's invert
                elevation is in error.
            WARNING 11: non-matching attributes in Control Rule xxx.
                The premise of a control is comparing two different types of attributes to one another (for example,
                conduit flow and junction water depth).
        """
        t = self._raw_parts.get('Version+Title', None)
        di = {}
        if t:
            for line in t.split('\n'):
                line = line.strip()
                if line.startswith('WARNING'):

                    if ('WARNING 06' in line) or ('WARNING 07' in line):
                        di[line] = True
                    else:
                        *message, object_label = line.split()
                        message = ' '.join(message)
                        if message in di:
                            di[message].append(object_label)
                        else:
                            di[message] = [object_label]
        return di

    def print_warnings(self):
        """Print the warnings in the report file in a pretty way."""
        print(self._pretty_dict(self.get_warnings()))


read_rpt_file = SwmmReport
