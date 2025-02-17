import abc
import datetime
import re
import types
from abc import ABC
from collections.abc import Mapping
from inspect import isfunction, isclass, getdoc, signature
import warnings
from pprint import pformat

import pandas as pd
import numpy as np
from tqdm.auto import tqdm

from ._type_converter import type2str, is_equal, txt_to_lines, is_nan
from .section_labels import *
from .section_lists import LINK_SECTIONS, NODE_SECTIONS
from .._io_helpers import CONFIG


_TYPES_NO_COPY = (type(None), int, float, str, datetime.date, datetime.time, datetime.timedelta)

# _DEFAULT_NOT_SPECIFIED = np.nan  # not used


class SwmmInputWarning(UserWarning): ...


def head_to_str(head):
    return f'\n\n{CONFIG.comment_prefix + CONFIG.section_separator}\n[{head}]\n'


########################################################################################################################
class CustomDict:
    """
    Custom implementation of dict.

    Used for SwmmInput, InpSectionABC (InpSection and InpSectionGeneric).

    Imitates :class:`collections.UserDict` (:term:`dict-like <mapping>`), but operations only effect ``self._data``.
    """

    def __init__(self, d=None, **kwargs):
        if d is None:
            self._data = kwargs
        else:
            if isinstance(d, dict):
                self._data = d
            else:
                self._data = dict(d)

    def __len__(self):
        return self._data.__len__()

    def __getitem__(self, key):
        return self._data.__getitem__(key)

    def __setitem__(self, key, item):
        self._data.__setitem__(key, item)

    def __delitem__(self, key):
        self._data.__delitem__(key)

    def __iter__(self):
        return self._data.__iter__()

    def __contains__(self, key):
        return self._data.__contains__(key)

    def __repr__(self):
        return pformat(self._data, indent=4, sort_dicts=False)
        # return self._data.__repr__()

    def __str__(self):
        return self._data.__str__()

    def get(self, key, default=None):
        """see :py:meth:`dict.get`"""
        if isinstance(key, list):
            return (self.get(k) for k in key)
        return self._data.get(key) if key in self else default

    def copy(self):
        """see :py:meth:`dict.copy`"""
        return type(self)({k: v if isinstance(v, _TYPES_NO_COPY) else v.copy() for k, v in self._data.items()})
        # return type(self)(self._data.copy())

    def values(self):
        """see :py:meth:`dict.values`"""
        return self._data.values()

    def keys(self):
        """see :py:meth:`dict.keys`"""
        return self._data.keys()

    def items(self):
        """see :py:meth:`dict.items`"""
        return self._data.items()

    def update(self, d=None, **kwargs):
        """see :py:meth:`dict.update`"""
        self._data.update(d, **kwargs)

    def pop(self, key):
        """see :py:meth:`dict.pop`"""
        return self._data.pop(key)

    def __bool__(self):
        return bool(self._data)

    # @property
    # def id(self):
    #     return id(self)


Mapping.register(CustomDict)


class InpSectionABC(ABC, CustomDict):
    """
    Abstract class for ``.inp``-file sections without objects.

    Abstract Class to define common functions

    Notes:
        Acts :term:`dict-like <mapping>`

    Attributes:
        _label (str): label of the section
    """
    _label = ''
    """str: label of the section"""

    @abc.abstractmethod
    def __init__(self, *args, **kwargs):
        CustomDict.__init__(self, *args, **kwargs)
        self._inp = None  # type: swmm_api.SwmmInput

    def set_parent_inp(self, inp):
        """
        Set inp-data object related to this section.

        Args:
            inp (swmm_api.SwmmInput): SWMM input-file data-object related to this section.
        """
        self._inp = inp

    def get_parent_inp(self):
        """
        Get inp-data object related to this section.

        Returns:
            swmm_api.SwmmInput: inp-data object related to this section.
        """
        return self._inp

    @classmethod
    @abc.abstractmethod
    def from_inp_lines(cls, lines, section_class=None):
        """
        Read ``.inp``-file lines and create a new section.

        Args:
            lines (str | list[list[str]]): Lines in the section of the ``.inp``-file

        Returns:
            InpSectionABC: New section.
        """
        ...

    @abc.abstractmethod
    def to_inp_lines(self, fast=False, sort_objects_alphabetical=False):
        """
        Convert the section to ``.inp``-file.lines.

        Args:
            fast (bool): speeding up conversion

                - :obj:`True`: If no special formation of the input file is needed.
                - :obj:`False`: Section is converted into a table to prettify string output (slower).

            sort_objects_alphabetical (bool): if objects in a section should be sorted alphabetical |
                default: use order of the read inp-file and append new objects

        Returns:
            str: Lines of the ``.inp``-file section.
        """
        ...

    def create_new_empty(self):
        """
        Create a new empty section of this kind of section.

        Returns:
            InpSectionABC: New empty section.
        """
        return type(self)()


########################################################################################################################
class InpSectionGeneric(InpSectionABC, ABC):
    """
    Abstract class for ``.inp``-file sections without objects.

    Notes:
        Acts :term:`dict-like <mapping>`

    Attributes:
        _label (str): label of the section
    """

    def __init__(self, *args, **kwargs):
        InpSectionABC.__init__(self, *args, **kwargs)

    def __setitem__(self, key, item):
        super().__setitem__(key, item)
        if isinstance(key, str) and ' ' not in key:
            super().__setattr__(key, item)

    def __delitem__(self, key):
        if hasattr(self, key):
            super().__delattr__(key)
        super().__delitem__(key)

    def to_inp_lines(self, fast=False, sort_objects_alphabetical=False):
        """
        Convert the section to ``.inp``-file.lines.

        Args:
            fast (bool): speeding up conversion

                - :obj:`True`: If no special formation of the input file is needed.
                - :obj:`False`: Section is converted into a table to prettify string output (slower).

            sort_objects_alphabetical (bool): if objects in a section should be sorted alphabetical |
                default: use order of the read inp-file and append new objects

        Returns:
            str: Lines of the ``.inp``-file section.
        """
        # size of the longest key (number of characters)
        if not self:
            return CONFIG.comment_empty_section
        max_len = len(max(self.keys(), key=len))
        return '\n'.join(f'{(key if isinstance(key, str) else " ".join(key)).ljust(max_len)}  {type2str(value)}' for key, value in self.items())


########################################################################################################################
class InpSection(InpSectionABC):
    """Class for ``.inp``-file sections with objects (i.e. nodes, links, subcatchments, raingages, ...)."""

    def __init__(self, section_object):
        """
        create an object for ``.inp``-file sections with objects (i.e. nodes, links, subcatchments, raingages, ...)

        Args:
            section_object (BaseSectionObject | similar): object class which is stored in this section.
                This information is used to set the index of the section and
                to decide if the section can be exported (converted to a string) as a table.
        """
        super().__init__()
        self._section_object = section_object

        from .section_types import SECTIONS_MULTI_TYPES
        self._possible_object_types = SECTIONS_MULTI_TYPES.get(section_object._section_label, (section_object,))

    # def __repr__(self):
    #     # return CustomDict.__repr__(self)
    #     return str(self)

    # def __str__(self):
    #     return f'[{self._section_object._section_label}] '  # + ' | '.join((str(s) for s in self.keys()))

    def __setitem__(self, key, value):
        if isinstance(self._identifier, str):
            if not isinstance(key, str):
                warnings.warn(f'Wrong key type (Unknown Behaviour)\n'
                              f'Needed: "{self._identifier}" as string\n'
                              f'Given: {key} of type {type(key)}', SwmmInputWarning)
        else:
            if len(self._identifier) != len(key):
                warnings.warn(f'Wrong number of keys (Unknown Behaviour)\n'
                              f'Needed keys: "{self._identifier}"\n'
                              f'Given keys: "{key}"', SwmmInputWarning)

        if not isinstance(value, self._possible_object_types):
            warnings.warn(f'Wrong section-object type (Unknown Behaviour)\n'
                          f'Needed type: "{self._section_object}"\n'
                          f'Given type: "{type(value)}"', SwmmInputWarning)

        super().__setitem__(key, value)

    @property
    def objects(self):
        """
        all swmm objects in this section

        Returns:
            dict[str, BaseSectionObject]: dictionary of objects with label as key and the object os value
        """
        return self._data

    @property
    def _identifier(self):
        """
        to set the index of the section (key to select an object an index for the dataframe export)

        Returns:
            str | tuple: key of the objects label (can be a single or multiple keys)
        """
        return self._section_object._identifier

    @property
    def _index_labels(self):
        if isinstance(self._identifier, tuple):
            return list(self._identifier)
        else:
            return self._identifier

    @property
    def _label(self):
        """
        get the label of the section

        Returns:
            str: label of the section
        """
        return self._section_object._section_label

    @property
    def _table_inp_export(self):
        # if the section can be exported (converted to a string) as a table.
        return self._section_object._table_inp_export

    def add_multiple(self, *items):
        """
        Add objects to section.

        Args:
            *items (BaseSectionObject): new objects
        """
        if (len(items) == 1) and isinstance(items[0], types.GeneratorType):
            items = items[0]
        for obj in items:
            try:
                self.add_obj(obj)
            except Exception as e:
                warnings.warn(f'error ({e}) when adding object ({obj}) to section "{self._label}"')

    def add_obj(self, obj):
        """
        Add object to section.

        Args:
            obj (BaseSectionObject): new object
        """
        self[obj.section_key] = obj

    def add_inp_lines(self, multi_line_args):
        """
        Creates and adds objects for each line.

        Args:
            multi_line_args (list[list[str]]): lines in the input file section
        """
        self.add_multiple(*self._section_object._convert_lines(multi_line_args))

    @classmethod
    def from_inp_lines(cls, lines, section_class):
        """
        Convert the lines of a section to this class and each line to an object.

        This function is used for the ``.inp``-file reading

        Args:
            lines (str | list[list[str]]): lines of a section in a ``.inp``-file
            section_class (BaseSectionObject): object class which is stored in this section.

        Returns:
            InpSection: section of the ``.inp``-file
        """
        return section_class.create_section(lines)

    def get_objects(self, sort_alphabetical=False):
        keys = self.keys()
        if sort_alphabetical:
            keys = sorted(keys, key=natural_keys)

        for k in keys:
            yield self[k]

    def to_inp_lines(self, fast=False, sort_objects_alphabetical=False):
        """
        Convert the section to a multi-line ``.inp``-file conform string.

        This function is used for the ``.inp``-file writing

        Args:
            fast (bool): speeding up conversion

                - :obj:`True`: if no special formation of the input file is needed
                - :obj:`False`: section is converted into a table to prettify string output (slower)

            sort_objects_alphabetical (bool): if objects in a section should be sorted alphabetical |
                default: use order of the read inp-file and append new objects

        Returns:
             str: lines of the ``.inp``-file section
        """
        if not self:  # if empty
            return CONFIG.comment_empty_section

        if fast or not self._table_inp_export:
            return '\n'.join(self.iter_inp_lines(sort_objects_alphabetical)) + '\n'
        else:
            if self._label == INFILTRATION:
                # mixed object class
                if not self:  # if empty
                    return CONFIG.comment_empty_section

                split = {}
                keys = self.keys()
                if sort_objects_alphabetical:
                    keys = sorted(keys, key=natural_keys)

                for k in keys:
                    o = self[k]
                    if type(o) not in split:
                        split[type(o)] = []
                    split[type(o)].append(o.to_dict_())

                # TODO
                #   detect multiple types
                #   set kind as last parameter for each object
                #   what to use - modified?
                # if len(split) > 1:
                #     ...
                # default_o = self.get_parent_inp()._converter[INFILTRATION]
                # self.get_parent_inp().set_default_infiltration_from_options()

                s = ''
                for v in split.values():
                    s += dataframe_to_inp_string(pd.DataFrame(v).set_index(self._index_labels)) + '\n\n'
                return s
            else:
                return dataframe_to_inp_string(self.get_dataframe(set_index=True,
                                                                  sort_objects_alphabetical=sort_objects_alphabetical))

    def iter_inp_lines(self, sort_objects_alphabetical=False):
        """
        Convert the section to a multi-line ``.inp``-file conform string.

        This function is used for the ``.inp``-file writing

        Args:
            sort_objects_alphabetical (bool): if objects in a section should be sorted alphabetical |
                default: use order of the read inp-file and append new objects

        Yields:
             str: lines of the ``.inp``-file section
        """
        if self:
            # only show write progress for big files
            n_objects = len(self.keys())
            values = self.get_objects(sort_objects_alphabetical)
            if n_objects > 50_000:
                _iterable = tqdm(values,
                                 desc=self._section_object.__name__,
                                 postfix='Write',
                                 total=n_objects)
            else:
                _iterable = values

            for o in _iterable:
                yield o.to_inp_line()
        else:  # if empty
            yield CONFIG.comment_empty_section

    @property
    def frame(self):
        """Convert section to a :class:`pandas.DataFrame`.

        This property is used for debugging purposes and data analysis of the input data of the swmm model.

        Returns:
            pandas.DataFrame: section as table
        """
        return self.get_dataframe(set_index=True, sort_objects_alphabetical=True)

    def get_dataframe(self, set_index=True, sort_objects_alphabetical=False):
        """Convert section to a :class:`pandas.DataFrame`.

        Args:
            set_index (bool): set object keys as index
            sort_objects_alphabetical (bool): if objects in a section should be sorted alphabetical |
                default: use order of the read inp-file and append new objects

        Returns:
            pandas.DataFrame: section as table
        """
        if not self:  # if empty
            return pd.DataFrame()
        df = pd.DataFrame([i.to_dict_() for i in self.get_objects(sort_objects_alphabetical)])
        if set_index:
            df = df.set_index(self._index_labels)
        return df

    def create_new_empty(self):
        """
        Create a new empty section of this kind of section.

        Returns:
            InpSection: new empty section
        """
        return type(self)(self._section_object)  # similar to `self._section_object.create_section()`

    def copy(self):
        """
        Get a copy of the section.

        Returns:
            InpSection: copy of the section
        """
        new = self.create_new_empty()
        # ΔTime: 18.678 s
        # new._data = deepcopy(self._data)
        # ΔTime: 2.943 s
        # new._data = {k: self[k].copy() for k in self}
        new.add_multiple(v.copy() for v in self.values())
        return new

    def filter_keys(self, keys, by=None):
        """
        Filter parts of the section with keys (identifier strings or attribute string).

        Args:
            keys (list | set): list of names to filter by (ether the identifier or the attribute of "by")
            by (str | list[str] | tuple[str]): attribute name of the section object to filter by

        Returns:
            tuple[BaseSectionObject] | list[BaseSectionObject]: filtered objects
        """

        # working with pandas makes it x10 faster
        if by is None:
            filtered_keys = set(self.keys()).intersection(set(keys))
        else:
            f = self.get_dataframe(set_index=False)
            if f.empty:
                return tuple()

            if isinstance(by, (list, set, tuple)):
                if (set(f.columns) & set(by)) != set(by):
                    raise SwmmInputWarning(f'{set(by) - set(f.columns)} not available. possible={f.columns.tolist()}')

                f_filtered = f[by].isin(keys).all(axis=1)
                # filtered_keys = (k for k in self if any(map(lambda b: self[k][b] in keys, by)))

            else:
                # filtered_keys = filter(lambda k: self[k][by] in keys, self)
                # filtered_keys = (k for k in self if self[k][by] in keys)
                f_filtered = f[by].isin(keys)

            filtered_keys = f[f_filtered].set_index(self._index_labels).index

        return (self[k] for k in filtered_keys)

    def slice_section(self, keys, by=None):
        """
        Filter parts of the section with keys (identifier strings or attribute string).

        Args:
            keys (list | set): list of names to filter by (ether the identifier or the attribute of "by")
            by (str | list[str] | tuple[str]): attribute name of the section object to filter by

        Returns:
            InpSection: new filtered section
        """
        new = self.create_new_empty()
        new.add_multiple(*self.filter_keys(keys, by=by))
        return new


class InpSectionGeo(InpSection):
    """Child class of :class:`~swmm_api.input_file.helpers.InpSection`. See parent class for all functions."""
    def __init__(self, section_object, crs="EPSG:32633"):
        """
        Create a section for ``.inp``-file with geo-objects (i.e. nodes, links, subcatchments, raingages, ...).

        Args:
            section_object (BaseSectionObject-like): object class which is stored in this section.
                This information is used to set the index of the section and
                to decide if the section can be exported (converted to a string) as a table.
            crs: Coordinate Reference System of the geometry objects.
                Can be anything accepted by :meth:`pyproj.CRS.from_user_input() <pyproj.crs.CRS.from_user_input>`,
                such as an authority string (eg “EPSG:32633”) or a WKT string.
        """
        InpSection.__init__(self, section_object)
        self._crs = crs

    def set_crs(self, crs):
        """
        Set the Coordinate Reference System (CRS) of a geo-section.

        Notes:
            The underlying geometries are not transformed to this CRS.

        Args:
            crs: Coordinate Reference System of the geometry objects.
                Can be anything accepted by :meth:`pyproj.CRS.from_user_input() <pyproj.crs.CRS.from_user_input>`,
                such as an authority string (eg “EPSG:32633”) or a WKT string.
        """
        self._crs = crs

    @property
    def geo_series(self):
        """
        Get a geopandas.GeoSeries representation for the geo-section.

        This function sets the object default crs.

        Returns:
            geopandas.GeoSeries: geo-series of the section-data
        """
        return self.get_geo_series(self._crs)

    def get_geo_series(self, crs):
        """
        Get a geopandas.GeoSeries representation for the geo-section using a custom crs.

        Args:
            crs: Coordinate Reference System of the geometry objects.
                Can be anything accepted by :meth:`pyproj.CRS.from_user_input() <pyproj.crs.CRS.from_user_input>`,
                such as an authority string (eg “EPSG:32633”) or a WKT string.

        Returns:
            geopandas.GeoSeries: geo-series of the section-data
        """
        from geopandas import GeoSeries
        return GeoSeries({label: item.geo for label, item in self.items()}, crs=crs, name='geometry')


def free_attributes(key):
    # TODO maybe later?!
    return key  # .lower()  # .replace('_', '') -> .casefold() betten than fold


########################################################################################################################
class BaseSectionObject(ABC):
    """
    base class for all section objects to unify operations

    sections objects only have __init__ with object parameters

    acts :term:`like a dict <mapping>` (getter and setter)"""
    _identifier = ''
    """str: attribute of an object which will be used as identifiers"""
    _table_inp_export = True
    """bool: if a section is writeable as table. Default ist True"""
    _section_class = InpSection
    """class: section class to identify functionality"""
    _section_label = ''
    """str: label of the section"""

    # @property
    # def section_label(self):
    #     return self._section_label

    __name__ = 'BaseSectionObject'

    @abc.abstractmethod
    def __init__(self, *args, **kwargs):
        pass

    def get(self, key):
        """
        Get an attribute value by the attribute name.

        Args:
            key (str): name of the attribute.

        Returns:
            any: the attribute value
        """
        if isinstance(key, (list, tuple, set)):
            return type(key)([self.get(k) for k in key])
        return self.__getattribute__(free_attributes(key))

    def set(self, key, value):
        """
        Set an attribute value.

        Args:
            key (str): name of the attribute.
            value (any): value for the attribute.
        """
        if not hasattr(self, key):
            raise SwmmInputWarning(f'{key} not a Object attribute | {self}')
        self.__setattr__(free_attributes(key), value)

    def __getitem__(self, key):
        return self.get(key)

    def __setitem__(self, key, item):
        self.set(key, item)

    def to_dict_(self):
        """
        get all object parameters as dictionary

        Returns:
            dict:
        """
        return vars(self)

    @property
    def attributes(self):
        """
        Get the attributes names for the object.

        Returns:
            tuple[str]: Attribute names for the object
        """
        return tuple(self.to_dict_().keys())

    @property
    def values(self):
        """
        Get the attributes values for the object.

        Returns:
            tuple[any]: Attribute values for the object
        """
        return tuple(self.to_dict_().values())

    @property
    def values_used(self):
        """
        Get only the used attributes values for the object.

        Values which aren't used are set as `:obj:numpy.nan`

        Returns:
            tuple[any]: Attribute values used for the object
        """
        return tuple(v for v in self.values if not is_nan(v))

    def __iter__(self):
        for k, v in self.to_dict_().items():
            yield k, v

    def __repr__(self):
        return str(self)

    def __str__(self):
        return self._to_debug_string()

    def __eq__(self, other):
        return isinstance(self, type(other)) and all([is_equal(self[k], other[k]) for k in self.attributes])

    def __hash__(self):
        return tuple([(k, v) for k, v in self]).__hash__()

    # @property
    # def id(self):
    #     return id(self)

    @property
    def section_key(self):  # get key of object for section
        return self.get(self._identifier)

    def _to_debug_string(self):
        """for debugging purposes

        string is almost equal to python syntax
        so you could copy it and past it into your code

        Returns:
            str: debug string of the object
        """
        return f'{self.__class__.__name__}({", ".join([f"{k}={repr(v)}" for k, v in self])})'

    @property
    def _short_debug_string(self):
        return f'{self.__class__.__name__}({self.section_key})'

    def to_inp_line(self):
        """
        Convert object to one line of the ``.inp``-file.

        for ``.inp``-file writing

        Returns:
            str: SWMM .inp file compatible string
        """
        return ' '.join([type2str(i) for i in self.values_used]).strip()

    @classmethod
    def from_inp_line(cls, *line_args):
        """
        Convert line in the ``.inp``-file to the object.

        Needed if multiple subclasses of an object are available (i.e. Infiltration).

        Args:
            *line_args (list[str]): arguments in the line

        Returns:
            BaseSectionObject: object of the ``.inp``-file section
        """
        try:
            return cls(*line_args)
        except (TypeError, ValueError) as e:
            raise TypeError(f'{e} | {cls.__name__}{line_args}\n\n__init__{signature(cls.__init__)}\n\n{getdoc(cls.__init__)}')

    def copy(self):
        """
        Copy object.

        Returns:
            BaseSectionObject or Child: copy of the object
        """
        # return type(self)(*self.values_used)
        try:
            return type(self)(**self.to_dict_())
        except TypeError as e:
            raise SwmmInputWarning(f'{e} | {self}')

    @classmethod
    def _prepare_convert_lines(cls, lines):
        # print(f'BYTES: {len(lines):>9_d}', )
        if isinstance(lines, str):
            if len(lines) > 10_000_000:
                n_lines = lines.strip().count('\n') + 1
                # to create a progressbar in the reading process
                # only needed with big (> 200 MB) files
                return tqdm(txt_to_lines(lines), desc=cls.__name__, total=n_lines, postfix='Read')
            else:
                return txt_to_lines(lines)
        elif isinstance(lines, pd.DataFrame):
            return lines.values
        else:
            return lines

    @classmethod
    def create_section(cls, lines=None):
        """
        Create a new section for the ``.inp``-file of this object and adds objects described in `lines`

        An empty section will be created when no lines are given.

        Args:
            lines (list[list] or str or optional): lines of values for multiple objects in this section

        Returns:
            InpSection: new section of this object type
        """
        sec = cls._section_class(cls)
        if lines is None:
            return sec

        lines_iter = cls._prepare_convert_lines(lines)
        sec.add_inp_lines(lines_iter)

        if isinstance(lines_iter, tqdm):
            lines_iter.close()

        return sec

    @classmethod
    def from_inp_lines(cls, lines):
        """
        Create a new section for the ``.inp``-file of this object and adds objects described in `lines`

        Args:
            lines (list[list] or str or optional): lines of values for multiple objects in this section

        Returns:
            InpSection: new section of this object type
        """
        return cls.create_section(lines)

    @classmethod
    def _convert_lines(cls, multi_line_args):
        """
        Convert the ``.inp``-file section.

        Creates and yields an object for each line.

        Args:
            multi_line_args (list[list[str]]): lines in the input file section

        Yields:
            BaseSectionObject: object of the ``.inp``-file section
        """
        # overwrite if each object has multiple lines
        for line_args in multi_line_args:
            yield cls.from_inp_line(*line_args)


########################################################################################################################
def dataframe_to_inp_string(df, index=True):
    """
    Convert a data-frame into a multi-line tabular string for inp-file creation.

    Used to make a better readable .inp file and for debugging.

    Args:
        df (pandas.DataFrame): section table
        index (bool): add index to string

    Returns:
        str: .inp file conform string for one section
    """
    if df.empty:
        return CONFIG.comment_empty_section

    if isinstance(df, pd.Series):
        return df.apply(type2str).to_string()

    c = df.copy()
    if c.columns.name is None:
        c.columns.name = CONFIG.comment_prefix
    else:
        if not c.columns.name.startswith(CONFIG.comment_prefix):
            c.columns.name = CONFIG.comment_prefix + c.columns.name

    if c.index.name is not None:
        if not c.index.name.startswith(CONFIG.comment_prefix):
            c.index.name = CONFIG.comment_prefix + c.index.name

    if isinstance(c.index, pd.MultiIndex):
        if c.index.names is not None:
            if not c.index.levels[0].name.startswith(CONFIG.comment_prefix):
                c.index.set_names(f';{c.index.names[0]}', level=0, inplace=True)
                # because pandas 1.0
                # c.index.levels[0].name = f';{c.index.names[0].name}'

    if not index:
        c.columns = [CONFIG.comment_prefix + c.columns[0]] + list(c.columns)[1:]

    from packaging import version
    if version.parse(pd.__version__) >= version.parse('2.1'):
        return c.map(type2str).to_string(sparsify=False,
                                         line_width=999999,
                                         max_rows=999999,
                                         max_cols=999999,
                                         max_colwidth=999999,
                                         index=index)
    else:
        return c.applymap(type2str).to_string(sparsify=False,
                                              line_width=999999,
                                              max_rows=999999,
                                              max_cols=999999,
                                              max_colwidth=999999,
                                              index=index)


########################################################################################################################
def convert_section(head, lines, converter):
    """
    Convert section string to a section object.

    Args:
        head (str): header of the section
        lines (str): lines in the section
        converter (dict): dict of converters assigned to header {header: converter]

    Returns:
        str | InpSection | InpSectionGeneric: converted section
    """
    if head in converter:
        section_ = converter[head]

        if isfunction(section_):  # section_ ... converter function
            return section_(lines)

        elif isclass(section_):  # section_ ... type/class
            try:
                return section_.from_inp_lines(lines)
            except ValueError as e:
                raise SwmmInputWarning(str(e) + f'\nClass ({section_}) for Section "{head}" has wrong implementation of the function "from_inp_lines". Section will not be converted.')

        else:
            # warnings.warn(f'Type of converter ({type(section_)}) for Section "{head}" not implemented. Section will not be converted.', SwmmInputWarning)
            warnings.warn(f'Type of converter ({type(section_)}) for Section "{head}" not implemented. Section will be converted using the DummySectionObject.', SwmmInputWarning)
            from .helpers_dummy import DummySectionObject
            return DummySectionObject.from_inp_lines(lines)
    else:
        # warnings.warn(f'Section "{head}" not implemented. Section will not be converted.', SwmmInputWarning)
        warnings.warn(f'Section "{head}" not implemented. Section will be converted using the DummySectionObject.', SwmmInputWarning)
        from .helpers_dummy import DummySectionObject
        return DummySectionObject.from_inp_lines(lines)

    return lines.replace(CONFIG.comment_prefix + CONFIG.section_separator, '').strip()


########################################################################################################################
SECTIONS_ORDER_MP = ([
                         TITLE,
                         OPTIONS,
                         REPORT,
                         EVAPORATION,
                         TEMPERATURE

                     ] + NODE_SECTIONS +
                     [
                         DWF,
                         INFLOWS

                     ] + LINK_SECTIONS +
                     [

                         LOSSES,
                         XSECTIONS,
                         STREETS,
                         INLETS,
                         INLET_USAGE,
                         TRANSECTS,

                         CURVES,
                         TIMESERIES,
                         RAINGAGES,
                         PATTERNS,

                         SUBCATCHMENTS,
                         SUBAREAS,
                         INFILTRATION,

                         POLLUTANTS,
                         LOADINGS,
                     ])

SECTION_ORDER_DEFAULT = [TITLE,
                         OPTIONS,
                         FILES,
                         EVAPORATION,
                         TEMPERATURE,
                         RAINGAGES,
                         SUBCATCHMENTS,
                         SUBAREAS,
                         INFILTRATION,
                         LID_CONTROLS,
                         LID_USAGE,
                         AQUIFERS,
                         GROUNDWATER,
                         GWF,
                         SNOWPACKS,
                         JUNCTIONS,
                         OUTFALLS,
                         DIVIDERS,
                         STORAGE,
                         CONDUITS,
                         PUMPS,
                         ORIFICES,
                         WEIRS,
                         OUTLETS,
                         XSECTIONS,
                         STREETS,
                         INLETS,
                         INLET_USAGE,
                         TRANSECTS,
                         LOSSES,
                         CONTROLS,
                         POLLUTANTS,
                         LANDUSES,
                         COVERAGES,
                         LOADINGS,
                         BUILDUP,
                         WASHOFF,
                         TREATMENT,
                         INFLOWS,
                         DWF,
                         HYDROGRAPHS,
                         RDII,
                         CURVES,
                         TIMESERIES,
                         PATTERNS,
                         REPORT,
                         ADJUSTMENTS,
                         TAGS,
                         MAP,
                         COORDINATES,
                         VERTICES,
                         POLYGONS,
                         SYMBOLS,
                         LABELS,
                         BACKDROP,
                         PROFILES]


def check_order(inp, order_list=None):
    if order_list is None:
        order_list = SECTION_ORDER_DEFAULT
    order = [order_list.index(o) if o in order_list else len(order_list) for o in inp]
    return all((order[i + 1] - order[i]) > 0 for i in range(len(order) - 1))


def _sort_by(key, sections_order):
    if key in sections_order:
        return sections_order.index(key)
    else:
        return len(sections_order)


re_int = re.compile(r'(\d+)')


def natural_keys(text):
    if isinstance(text, str):
        return [int(text) if text.isdigit() else text for text in re_int.split(text)]
    else:
        return [*(natural_keys(t) for t in text)]


def section_to_string(section, fast=True, sort_objects_alphabetical=False):
    """
    Create a string of a section in an ``.inp``-file.

    Args:
        section (InpSection | InpSectionGeneric):
            section of an ``.inp``-file
        fast (bool): don't use any formatting else format as table
        sort_objects_alphabetical (bool): if objects in a section should be sorted alphabetical |
            default: use order of the read inp-file and append new objects

    Returns:
        str: string of the ``.inp``-file section
    """
    if isinstance(section, str):  # Title
        return section.replace(CONFIG.comment_prefix + CONFIG.section_separator, '').strip()

    # ----------------------
    elif isinstance(section, list):  # V1
        return '\n'.join([type2str(line) for line in section])

    # ----------------------
    elif isinstance(section, dict):  # V2
        max_len = len(max(section.keys(), key=len)) + 2
        f = ''
        for sub in section:
            f += f'{sub:<{max_len}}{type2str(section[sub])}\n'  # format(key=sub.ljust(max_len), value=type2str(section[sub]) + '\n')
        return f

    # ----------------------
    elif isinstance(section, (pd.DataFrame, pd.Series)):  # V3
        return dataframe_to_inp_string(section)

    # ----------------------
    elif isinstance(section, InpSectionGeneric):  # V4
        if not section:
            return CONFIG.comment_empty_section
        return section.to_inp_lines(fast=fast)

    elif isinstance(section, InpSection):  # V4
        return section.to_inp_lines(fast=fast, sort_objects_alphabetical=sort_objects_alphabetical)

    elif section is None:
        return ''

    else:
        print(section, '?' * 10)


def iter_section_lines(section, sort_objects_alphabetical=False):
    if isinstance(section, str):  # Title
        yield section.replace(CONFIG.comment_prefix + CONFIG.section_separator, '').strip()

    # ----------------------
    elif isinstance(section, list):  # V1
        for line in section:
            yield type2str(line)

    # ----------------------
    elif isinstance(section, dict):  # V2
        max_len = len(max(section.keys(), key=len)) + 2
        for sub in section:
            yield f'{sub:<{max_len}}{type2str(section[sub])}\n'

    # ----------------------
    elif isinstance(section, (pd.DataFrame, pd.Series)):  # V3
        yield dataframe_to_inp_string(section)

    # ----------------------
    elif isinstance(section, InpSectionGeneric):
        yield section.to_inp_lines(fast=True)

    elif isinstance(section, InpSection):  # V4
        for line in section.iter_inp_lines(sort_objects_alphabetical=sort_objects_alphabetical):
            yield line
