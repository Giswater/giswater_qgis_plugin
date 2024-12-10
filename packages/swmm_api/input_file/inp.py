from collections.abc import Mapping
from pathlib import Path

import os
import re
import warnings

from .helpers import (section_to_string, CustomDict, convert_section, InpSection, InpSectionGeo,
                      InpSectionGeneric, SECTION_ORDER_DEFAULT, check_order, SECTIONS_ORDER_MP, head_to_str,
                      iter_section_lines, SwmmInputWarning, BaseSectionObject, )
from .._io_helpers import get_default_encoding, read_txt_file
from .section_types import SECTION_TYPES
from .section_labels import *
from .sections import *


class SwmmInput(CustomDict):
    """
    SWMM-input-file class.

    Child class of dict.
    Basically a dict where the section labels of the input file are the keys
    and the values are the data in these sections.

    You can create a new empty input file, read existing ones and modify that data.
    """

    def __init__(self, *args, custom_section_handler=None, encoding='', force_ignore_case=False, **kwargs):
        """
        Read or create a SWMM-input-file (___.inp).

        Args:
            *args: only for creating the inp-object as a dict.
            custom_section_handler:
            encoding (str): Encoding of the text-file (None -> auto-detect encoding ... takes a few seconds | '' -> use default = 'utf-8')
            **kwargs: only for creating the inp-object as a dict.
        """
        filename = None
        if (len(args) == 1) and isinstance(args[0], (str, Path)):
            if not os.path.isfile(args[0]):
                raise FileNotFoundError(args[0])
            # argument is an inp-file.
            super().__init__()
            filename = args[0]
        else:
            super().__init__(*args, **kwargs)
        self._converter = SECTION_TYPES.copy()

        self._default_encoding = encoding  # ''->default | None->autodetect | str->custom

        if custom_section_handler is not None:
            self._converter.update(custom_section_handler)

        # only when reading a new file
        self._original_section_order = SECTIONS_ORDER_MP

        if filename is not None:
            self._init_from_file(filename, force_ignore_case=force_ignore_case)

    def copy(self):
        """Copy inp-data."""
        new = type(self)()  # type: SwmmInput
        new._converter = self._converter
        new._default_encoding = self._default_encoding
        new._original_section_order = self._original_section_order
        for key in self:
            if hasattr(self._data[key], 'copy'):
                new._data[key] = self._data[key].copy()
            else:
                new._data[key] = self._data[key]
        return new

    def update(self, d=None, convert_inp_data=True, **kwargs):
        """Update inp-data with another inp-data-object."""
        if convert_inp_data:
            self.force_convert_all()
            d.force_convert_all()
        for sec in d:
            if sec not in self:
                self._data[sec] = d._data[sec]
            else:
                if isinstance(self._data[sec], str):
                    if isinstance(d._data[sec], str):
                        self._data[sec] += f'\n{d._data[sec]}'
                    else:
                        self[sec].update(d[sec])
                        # warnings.warn(f'Updating of string section in INP-file not implemented! Skip Section {sec}')
                else:
                    self[sec].update(d[sec])

    def _init_from_str(self, txt, force_ignore_case=False):
        # __________________________________
        if force_ignore_case:
            txt = txt.upper()

        # __________________________________
        self._original_section_order = []
        for head, lines in zip(re.findall(r'\[(\w+)\]', txt),
                               re.split(r'\[\w+\]', txt)[1:]):
            head = head.upper()
            if head in self._data:
                self._data[head] += f'\n{lines.strip()}'
            else:
                self._data[head] = lines.strip()
                self._original_section_order.append(head)

        # ----------------
        # if order in inp follows default SWMM GUI order
        #   set full/complete order list of SWMM GUI
        #   to use the right order for additional created sections
        if check_order(self, SECTION_ORDER_DEFAULT):
            self._original_section_order = SECTION_ORDER_DEFAULT

        self.set_default_infiltration_from_options()

    def _init_from_file(self, filename, force_ignore_case=False):
        """
        Read ``.inp``-file and convert the sections in pythonic objects.

        The sections will be converted when used.

        Args:
            filename (str): path/filename to .inp file
            force_ignore_case (bool): SWMM is case-insensitive but python is case-sensitive -> set True to ignore case
                                        all text/labels will be set to uppercase
        """
        self._default_encoding = get_default_encoding(self._default_encoding, filename)

        if os.path.isfile(filename) or filename.endswith('.inp'):
            txt = read_txt_file(filename, encoding=self._default_encoding)

        else:
            warnings.warn('Reading a string with SwmmInput.read_file is deprecated. Use SwmmInput.read_text instead.', DeprecationWarning)
            txt = filename

        self._init_from_str(txt, force_ignore_case=force_ignore_case)

    @classmethod
    def read_file(cls, filename, custom_converter=None, force_ignore_case=False, encoding=''):
        """
        Read ``.inp``-file and convert the sections in pythonic objects.

        The sections will be converted when used.

        Args:
            filename (str | Path): path/filename to .inp file
            custom_converter (dict): dictionary of {section: converter/section_type} Default: :py:const:`SECTION_TYPES`
            force_ignore_case (bool): SWMM is case-insensitive but python is case-sensitive -> set True to ignore case
                                        all text/labels will be set to uppercase
            encoding (str): Encoding of the text-file (None -> auto-detect encoding ... takes a few seconds | '' -> use default = 'utf-8')

        Returns:
            SwmmInput: dict-like data of the sections in the ``.inp``-file
        """
        inp = cls(custom_section_handler=custom_converter, encoding=encoding)
        inp._init_from_file(filename, force_ignore_case)
        return inp

    @classmethod
    def read_text(cls, txt, custom_converter=None, force_ignore_case=False):
        """
        Read the text of an ``.inp``-file and convert the sections in pythonic objects.

        The sections will be converted when used.

        Args:
            txt (str): text of the .inp file
            custom_converter (dict): dictionary of {section: converter/section_type} Default: :py:const:`SECTION_TYPES`
            force_ignore_case (bool): SWMM is case-insensitive but python is case-sensitive -> set True to ignore case
                                        all text/labels will be set to uppercase

        Returns:
            SwmmInput: dict-like data of the sections in the ``.inp``-file
        """
        inp = cls(custom_section_handler=custom_converter)
        inp._init_from_str(txt, force_ignore_case=force_ignore_case)
        return inp

    def force_convert_all(self):
        """
        Convert all sections to pythonic objects.

        By default, unused sections will be stored as string.

        Necessary to reduce final file-size with keyword (fast=True).
        """
        for key in self:
            self._convert_section(key)

    def __getitem__(self, key):
        # if section not in inp-data, create an empty section
        if key not in self:
            self._data[key] = self._converter[key].create_section()
        else:
            # if section is a string (raw string from the .inp-file) convert section first
            self._convert_section(key)

        return self._data.__getitem__(key)

    def __setitem__(self, key, item):
        super().__setitem__(key, item)
        # if a new section is added, make the section aware in which inp file it is.
        if hasattr(self._data[key], 'set_parent_inp'):
            self._data[key].set_parent_inp(self)

    def __delattr__(self, attribute_name):
        """delete section"""
        # if the attribute_name is a known section-key then only delete the data (not the attribute)
        if attribute_name in self._data.keys():
            del self._data[attribute_name]
        else:  # else delete the attribute
            super().__delattr__(attribute_name)

    def _convert_section(self, key):
        # if section is a string (raw string from the .inp-file) convert section first
        if isinstance(self._data[key], str):
            self._data[key] = convert_section(key, self._data[key], self._converter)

            if hasattr(self._data[key], 'set_parent_inp'):
                self._data[key].set_parent_inp(self)

    def set_default_infiltration_from_options(self):
        """Set the default infiltration class based on the OPTIONS section."""
        if OPTIONS in self \
                and 'INFILTRATION' in self[OPTIONS] \
                and isinstance(self[OPTIONS], (dict, OptionSection, InpSectionGeneric)):
            self.set_infiltration_method(Infiltration._CONVERSION_DICT.get(self[OPTIONS]['INFILTRATION']))

    def set_infiltration_method(self, infiltration_class):
        """
        Set the default infiltration class.

        Args:
            infiltration_class: One of
                :class:`~swmm_api.input_file.sections.InfiltrationCurveNumber`,
                :class:`~swmm_api.input_file.sections.InfiltrationGreenAmpt`,
                :class:`~swmm_api.input_file.sections.InfiltrationHorton`
        """
        # self[OPTIONS]['INFILTRATION'] = INFILTRATION_DICT_r[infiltration_class]
        self._converter[INFILTRATION] = infiltration_class

    def _get_section_headers(self, custom_sections_order=None):
        """
        Get list of section keys/headers/labels.

        Args:
            custom_sections_order (list): Custom list for section sorting. (optional)

        Returns:
            list: sorted section-headers based on given order
        """
        if custom_sections_order is None:
            custom_sections_order = self._original_section_order

        def _sort_by(key):
            if key in custom_sections_order:
                return custom_sections_order.index(key)
            else:
                return len(custom_sections_order)

        return sorted(self.keys(), key=_sort_by)

    def to_string(self, fast=True, custom_sections_order=None, sort_objects_alphabetical=False):
        """
        Convert the inp-data to a ``.inp``-file-string.

        Args:
            fast (bool): don't use any formatting else format as table
            custom_sections_order (list[str]): list of section names to preset the order of the section in the
                created inp-file | default: order of the read inp-file + default order of the SWMM GUI
            sort_objects_alphabetical (bool): if objects in a section should be sorted alphabetical |
                default: use order of the read inp-file and append new objects

        Returns:
            str: string of input file text
        """
        f = ''
        for head in self._get_section_headers(custom_sections_order):
            f += head_to_str(head)
            f += section_to_string(self._data[head], fast=fast, sort_objects_alphabetical=sort_objects_alphabetical)
        return f

    def write_file(self, filename, fast=True, encoding=None, custom_sections_order=None,
                   sort_objects_alphabetical=False, per_line=False):
        """
        Write a new ``.inp``-file.

        Args:
            filename (str | Path): path/filename of created ``.inp``-file
            fast (bool): don't use any formatting else format as table
            encoding (str): define encoding for resulting inp-file. Default is same as read inp file or package default ('utf-8')
            custom_sections_order (list[str]): list of section names to preset the order of the section in the created
                inp-file | default: order of the read inp-file + default order of the SWMM GUI
            sort_objects_alphabetical (bool): if objects in a section should be sorted alphabetical |
                default: use order of the read inp-file and append new objects
            per_line (bool): weather to write the data line per line (=True) or section per section (=False) into the
                file. line per line has an advantage for big files (> 1 GB) and uses less memory (RAM).
        """

        if encoding is None:
            encoding = self._default_encoding   # None->autodetect | str->custom
            if encoding == '':
                encoding = get_default_encoding(encoding)

        with open(filename, 'w', encoding=encoding) as f:
            for head in self._get_section_headers(custom_sections_order):
                if not self._data[head]:  # if section is empty
                    continue
                f.write(head_to_str(head))
                if per_line:
                    for line in iter_section_lines(self._data[head],
                                                   sort_objects_alphabetical=sort_objects_alphabetical):
                        f.write(line + '\n')
                else:
                    f.write(section_to_string(self._data[head], fast=fast,
                                              sort_objects_alphabetical=sort_objects_alphabetical))
        return filename

    to_file = write_file  # alias

    def print_string(self, custom_sections_order=None):
        """
        Print the string of the inp-data (to the stdout).

        Args:
            custom_sections_order (list[str]): list of section names to preset the order of the section in the created
                inp-file | default: order of the read inp-file + default order of the SWMM GUI
        """
        for head in self._get_section_headers(custom_sections_order):
            print(head_to_str(head))
            for line in iter_section_lines(self._data[head], sort_objects_alphabetical=False):
                print(line)

    def check_for_section(self, section_class):
        """
        Check if a section is in the inp-data, and create it if not present.

        Args:
            section_class(type[BaseSectionObject] or type[InpSectionGeneric]): section object class.

        Returns:
            swmm_api.input_file.helpers.InpSection | swmm_api.input_file.helpers.InpSectionGeneric: section of inp
        """
        if hasattr(section_class, '_section_label'):  # BaseSectionObject
            section_label = section_class._section_label
            new_empty_section = section_class.create_section()
        elif hasattr(section_class, '_label'):  # InpSectionGeneric
            section_label = section_class._label
            new_empty_section = section_class()
        else:
            warnings.warn(f'Unknown Section Object type "{type(section_class)}" for function "check_for_section". -> Ignore', SwmmInputWarning)
            return

        if section_label not in self:
            self[section_label] = new_empty_section
        return self[section_label]

    def iter_avail_section_labels(self, section_list):
        """
        Iterate over sections labels given if they exist in the inp data.

        Args:
            section_list (list[str] | tuple[str] | set[str]): list of section labels.

        Yields:
            str: section label
        """
        for s in section_list:
            if s in self:
                yield s

    def iter_avail_sections(self, section_list):
        """
        Iterate over sections given if they exist in the inp data.

        Args:
            section_list (list[str] | tuple[str] | set[str]): list of section labels.

        Yields:
            (str, InpSection): section label and section-object
        """
        for s in self.iter_avail_section_labels(section_list):
            yield s, self[s]

    def add_new_section(self, section):
        """
        Add new section to the inp-data.

        Args:
            section (InpSectionABC or InpSection or InpSectionGeneric):

        .. Important::
            works inplace
        """
        if section._label not in self:
            self[section._label] = section
        else:
            warnings.warn(f'Section [{section._label}] not empty!', SwmmInputWarning)

    def delete_section(self, section_label: (str or list[str] or tuple[str] or set[str])):
        """
        Delete a section from the inp-data.

        Args:
            section_label (str | list[str] | tuple[str] | set[str]): label of the section or list of sections to be deleted.
        """
        if isinstance(section_label, str):
            if section_label in self:
                del self[section_label]
        elif isinstance(section_list := section_label, (list, tuple, set)):
            for s in section_list:
                self.delete_section(s)

    delete_sections = delete_section  # alias

    def add_obj(self, obj):
        """
        Add object to respective section.

        Args:
            obj (BaseSectionObject):new object
        """
        self.check_for_section(obj)
        self[obj._section_label].add_obj(obj)

    def add_multiple(self, *items):
        """
        Add multiple objects to respective sections.

        Args:
            *items (BaseSectionObject): new objects
        """
        for obj in items:
            self.add_obj(obj)

    @property
    def TITLE(self):
        """
        TITLE Section

        Returns:
            TitleSection: TITLE Section
        """
        if TITLE in self:
            return self[TITLE]

    @property
    def OPTIONS(self):
        """
        OPTIONS Section

        Returns:
            OptionSection: OPTIONS Section
        """
        if OPTIONS in self:
            return self[OPTIONS]

    @property
    def REPORT(self):
        """
        REPORT Section

        Returns:
            ReportSection: REPORT Section
        """
        if REPORT not in self:
            self[REPORT] = ReportSection()
        return self[REPORT]

    @property
    def EVAPORATION(self):
        """
        EVAPORATION Section

        Returns:
            EvaporationSection: EVAPORATION Section
        """
        if EVAPORATION in self:
            return self[EVAPORATION]

    @property
    def TEMPERATURE(self):
        """
        TEMPERATURE Section

        Returns:
            TemperatureSection: TEMPERATURE Section
        """
        if TEMPERATURE in self:
            return self[TEMPERATURE]

    @property
    def FILES(self):
        """
        FILES Section

        Returns:
            FilesSection: FILES Section
        """
        if FILES in self:
            return self[FILES]

    @property
    def BACKDROP(self):
        """
        BACKDROP Section

        Returns:
            BackdropSection: BACKDROP Section
        """
        if BACKDROP in self:
            return self[BACKDROP]

    @property
    def ADJUSTMENTS(self):
        """
        ADJUSTMENTS Section

        Returns:
            AdjustmentsSection: ADJUSTMENTS Section
        """
        if ADJUSTMENTS in self:
            return self[ADJUSTMENTS]

    # -----
    @property
    def COORDINATES(self):
        """
        COORDINATES section

        Returns:
            Mapping[str, Coordinate] | InpSectionGeo: Coordinates in INP
        """
        if COORDINATES in self:
            return self[COORDINATES]

    @property
    def VERTICES(self):
        """
        VERTICES section

        Returns:
            Mapping[str, Vertices] | InpSectionGeo: Vertices section
        """
        if VERTICES in self:
            return self[VERTICES]

    @property
    def POLYGONS(self):
        """
        POLYGONS section

        Returns:
            Mapping[str, Polygon] or InpSectionGeo: Polygon section
        """
        if POLYGONS in self:
            return self[POLYGONS]

    @property
    def SYMBOLS(self):
        """
        SYMBOLS section

        Returns:
            Mapping[str, Symbol] | InpSection: Symbol section
        """
        if SYMBOLS in self:
            return self[SYMBOLS]

    @property
    def MAP(self):
        """
        MAP section

        Returns:
            MapSection: MapSection section
        """
        if MAP in self:
            return self[MAP]

    @property
    def LABELS(self):
        """
        LABELS section

        Returns:
            Mapping[str, Label] | InpSection: Label section
        """
        if LABELS in self:
            return self[LABELS]

    @property
    def CONDUITS(self):
        """
        CONDUITS section

        Returns:
            Mapping[str, Conduit] | InpSection: Conduit section
        """
        if CONDUITS in self:
            return self[CONDUITS]

    @property
    def ORIFICES(self):
        """
        ORIFICES section

        Returns:
            Mapping[str, Orifice] | InpSection: Orifice section
        """
        if ORIFICES in self:
            return self[ORIFICES]

    @property
    def WEIRS(self):
        """
        WEIRS section

        Returns:
            Mapping[str, Weir] | InpSection: Weir section
        """
        if WEIRS in self:
            return self[WEIRS]

    @property
    def PUMPS(self):
        """
        PUMPS section

        Returns:
            Mapping[str, Pump] | InpSection: Pump section
        """
        if PUMPS in self:
            return self[PUMPS]

    @property
    def OUTLETS(self):
        """
        OUTLETS section

        Returns:
            Mapping[str, Outlet] | InpSection: Outlet section
        """
        if OUTLETS in self:
            return self[OUTLETS]

    @property
    def TRANSECTS(self):
        """
        TRANSECTS section

        Returns:
            Mapping[str, Transect] | InpSection: Transect section
        """
        if TRANSECTS in self:
            return self[TRANSECTS]

    @property
    def XSECTIONS(self):
        """
        XSECTIONS section

        Returns:
            Mapping[str, CrossSection] | InpSection: CrossSection section
        """
        if XSECTIONS in self:
            return self[XSECTIONS]

    @property
    def LOSSES(self):
        """
        LOSSES section

        Returns:
            Mapping[str, Loss] | InpSection: Loss section
        """
        if LOSSES in self:
            return self[LOSSES]

    @property
    def JUNCTIONS(self):
        """
        JUNCTIONS section

        Returns:
            Mapping[str, Junction] | InpSection: Junction section
        """
        if JUNCTIONS in self:
            return self[JUNCTIONS]

    @property
    def OUTFALLS(self):
        """
        OUTFALLS section

        Returns:
            Mapping[str, Outfall] | InpSection: Outfall section
        """
        if OUTFALLS in self:
            return self[OUTFALLS]

    @property
    def STORAGE(self):
        """
        STORAGE section

        Returns:
            Mapping[str, swmm_api.input_file.sections.node.Storage] | InpSection: Storage section
        """
        if STORAGE in self:
            return self[STORAGE]

    @property
    def DWF(self):
        """
        DWF section

        Returns:
            Mapping[tuple[str, str], DryWeatherFlow] | InpSection: DryWeatherFlow section
        """
        if DWF in self:
            return self[DWF]

    @property
    def INFLOWS(self):
        """
        INFLOWS section

        Returns:
            Mapping[tuple[str, str], Inflow] | InpSection: Inflow section
        """
        if INFLOWS in self:
            return self[INFLOWS]

    @property
    def RDII(self):
        """
        RDII section

        Returns:
            Mapping[str, RainfallDependentInfiltrationInflow] | InpSection: RainfallDependentInfiltrationInflow section
        """
        if RDII in self:
            return self[RDII]

    @property
    def TREATMENT(self):
        """
        TREATMENT section

        Returns:
            Mapping[tuple[str, str], Treatment] | InpSection: Treatment section
        """
        if TREATMENT in self:
            return self[TREATMENT]

    @property
    def SUBCATCHMENTS(self):
        """
        SUBCATCHMENTS section

        Returns:
            Mapping[str, SubCatchment] | InpSection: SubCatchment section
        """
        if SUBCATCHMENTS in self:
            return self[SUBCATCHMENTS]

    @property
    def SUBAREAS(self):
        """
        SUBAREAS section

        Returns:
            Mapping[str, SubArea] | InpSection: SubArea section
        """
        if SUBAREAS in self:
            return self[SUBAREAS]

    @property
    def INFILTRATION(self):
        """
        INFILTRATION section

        Returns:
            Mapping[str, (Infiltration | InfiltrationGreenAmpt | InfiltrationHorton | InfiltrationCurveNumber)] | InpSection: Infiltration section
        """
        if INFILTRATION in self:
            return self[INFILTRATION]

    @property
    def LOADINGS(self):
        """
        LOADINGS section

        Returns:
            Mapping[str, Loading] | InpSection: Loading section
        """
        if LOADINGS in self:
            return self[LOADINGS]

    @property
    def WASHOFF(self):
        """
        WASHOFF section

        Returns:
            Mapping[tuple[str, str], WashOff] | InpSection: WashOff section
        """
        if WASHOFF in self:
            return self[WASHOFF]

    @property
    def BUILDUP(self):
        """
        BUILDUP section

        Returns:
            Mapping[tuple[str, str], BuildUp] | InpSection: BuildUp section
        """
        if BUILDUP in self:
            return self[BUILDUP]

    @property
    def COVERAGES(self):
        """
        COVERAGES section

        Returns:
            Mapping[str, Coverage] | InpSection: Coverage section
        """
        if COVERAGES in self:
            return self[COVERAGES]

    @property
    def GWF(self):
        """
        GWF section

        Returns:
            Mapping[tuple[str, str], GroundwaterFlow] | InpSection: GroundwaterFlow section
        """
        if GWF in self:
            return self[GWF]

    @property
    def GROUNDWATER(self):
        """
        GROUNDWATER section

        Returns:
            Mapping[tuple[str, str, str], Groundwater] | InpSection: Groundwater section
        """
        if GROUNDWATER in self:
            return self[GROUNDWATER]

    @property
    def RAINGAGES(self):
        """
        RAINGAGES section

        Returns:
            Mapping[str, RainGage] | InpSection: RainGage section
        """
        if RAINGAGES in self:
            return self[RAINGAGES]

    @property
    def PATTERNS(self):
        """
        PATTERNS section

        Returns:
            Mapping[str, Pattern] | InpSection: Pattern section
        """
        if PATTERNS in self:
            return self[PATTERNS]

    @property
    def POLLUTANTS(self):
        """
        POLLUTANTS section

        Returns:
            Mapping[str, Pollutant] | InpSection: Pollutant section
        """
        if POLLUTANTS in self:
            return self[POLLUTANTS]

    @property
    def CONTROLS(self):
        """
        CONTROLS section

        Returns:
            Mapping[str, Control] | InpSection: Control section
        """
        if CONTROLS in self:
            return self[CONTROLS]

    @property
    def CURVES(self):
        """
        CURVES section

        Returns:
            Mapping[str, Curve] | InpSection: Curve section
        """
        if CURVES in self:
            return self[CURVES]

    @property
    def TIMESERIES(self):
        """
        TIMESERIES section

        Returns:
            Mapping[str, Timeseries | TimeseriesData | TimeseriesFile] | InpSection: Timeseries section
        """
        if TIMESERIES in self:
            return self[TIMESERIES]

    @property
    def TAGS(self):
        """
        TAGS section

        Returns:
            Mapping[tuple[str, str], Tag] | InpSection: Tag section
        """
        if TAGS in self:
            return self[TAGS]

    @property
    def HYDROGRAPHS(self):
        """
        HYDROGRAPHS section

        Returns:
            Mapping[str, Hydrograph] | InpSection: Hydrograph section
        """
        if HYDROGRAPHS in self:
            return self[HYDROGRAPHS]

    @property
    def LANDUSES(self):
        """
        LANDUSES section

        Returns:
            Mapping[str, LandUse] | InpSection: LandUse section
        """
        if LANDUSES in self:
            return self[LANDUSES]

    @property
    def AQUIFERS(self):
        """
        AQUIFERS section

        Returns:
            Mapping[str, Aquifer] | InpSection: Aquifer section
        """
        if AQUIFERS in self:
            return self[AQUIFERS]

    @property
    def SNOWPACKS(self):
        """
        SNOWPACKS section

        Returns:
            Mapping[str, SnowPack] | InpSection: SnowPack section
        """
        if SNOWPACKS in self:
            return self[SNOWPACKS]

    @property
    def LID_CONTROLS(self):
        """
        LID_CONTROLS section

        Returns:
            Mapping[str, LIDControl] | InpSection: LIDControl section
        """
        if LID_CONTROLS in self:
            return self[LID_CONTROLS]

    @property
    def LID_USAGE(self):
        """
        LID_USAGE section

        Returns:
            Mapping[tuple[str, str], LIDUsage] | InpSection: LIDUsage section
        """
        if LID_USAGE in self:
            return self[LID_USAGE]

    @property
    def STREETS(self):
        """
        STREETS section

        Returns:
            Mapping[str, Street] | InpSection: Street section
        """
        if STREETS in self:
            return self[STREETS]

    @property
    def INLETS(self):
        """
        INLETS section

        Returns:
            Mapping[tuple[str, str], Inlet] | InpSection: Inlet section
        """
        if INLETS in self:
            return self[INLETS]

    @property
    def INLET_USAGE(self):
        """
        INLET_USAGE section

        Returns:
            Mapping[str, InletUsage] | InpSection: InletUsage section
        """
        if INLET_USAGE in self:
            return self[INLET_USAGE]


read_inp_file = SwmmInput.read_file

Mapping.register(SwmmInput)
