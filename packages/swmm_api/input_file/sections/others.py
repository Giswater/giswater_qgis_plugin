import datetime
import enum
import locale
import warnings
from typing import Literal

import numpy as np
import pandas as pd

from ._identifiers import IDENTIFIERS
from .._type_converter import infer_type, to_bool, str_to_datetime, datetime_to_str, type2str, convert_string, is_nan
from ..helpers import BaseSectionObject
from ..section_labels import *


class RainGage(BaseSectionObject):
    """
    Rain gage information.

    Section:
        [RAINGAGES]

    Purpose:
        Identifies each rain gage that provides rainfall data for the study area.

    Formats:
        ::

            Name Form Intvl SCF TIMESERIES Tseries
            Name Form Intvl SCF FILE       Fname   Sta Units

    Attributes:
        name (str): Name assigned to rain gage.
        form (str): Form of recorded rainfall, either ``INTENSITY``, ``VOLUME`` or ``CUMULATIVE`` (:attr:`RainGage.FORMATS`).
        interval (str | pd.Timedelta): time interval between gage readings in decimal hours or hours:minutes format (e.g., 0:15 for 15-minute readings).
        SCF (float): Snow catch deficiency correction factor (use 1.0 for no adjustment).
        source (str | Literal['TIMESERIES', 'FILE']): One of ``'TIMESERIES'`` ``'FILE'`` (:attr:`RainGage.SOURCES`).
        timeseries (str): Name of time series in [``TIMESERIES``] section (:class:`TimeSeries`) with rainfall data.
        filename (str): Name of external file with rainfall data. Rainfall files are discussed in Section 11.3 Rainfall Files.
        station (str): Name of recording station used in the rain file.
        units (str | Literal['MM', 'IN']): Rain depth units used in the rain file, either ``'IN'`` (inches) or ``'MM'`` (millimeters) (:attr:`RainGage.UNITS`).

        FORMATS: Enum-like for the attribute :attr:`RainGage.form` with following members -> {``INTENSITY`` | ``VOLUME`` | ``CUMULATIVE``}
        SOURCES: Enum-like for the attribute :attr:`RainGage.source` with following members -> {``TIMESERIES`` | ``FILE``}
        UNITS: Enum-like for the attribute :attr:`RainGage.units` with following members -> {``IN`` | ``MM``}
    """
    _identifier = IDENTIFIERS.name
    _section_label = RAINGAGES

    class FORMATS:
        INTENSITY = 'INTENSITY'
        VOLUME = 'VOLUME'
        CUMULATIVE = 'CUMULATIVE'

    class SOURCES:
        TIMESERIES = 'TIMESERIES'
        FILE = 'FILE'

    class UNITS:
        IN = 'IN'
        MM = 'MM'

    def __init__(self, name, form, interval, SCF, source: Literal['TIMESERIES', 'FILE'] or str, *args, timeseries=np.nan, filename=np.nan, station=np.nan, units: str or Literal['MM', 'IN'] = np.nan):
        """
        Rain gage information.

        Args:
            name (str): Name assigned to rain gage.
            form (str): Form of recorded rainfall, either ``INTENSITY``, ``VOLUME`` or ``CUMULATIVE`` (:attr:`RainGage.FORMATS`).
            interval (str or pd.Timedelta): time interval between gage readings in decimal hours or hours:minutes format (e.g., 0:15 for 15-minute readings).
            SCF (float): Snow catch deficiency correction factor (use 1.0 for no adjustment).
            source (str or Literal['TIMESERIES', 'FILE']): One of ``'TIMESERIES'`` ``'FILE'`` (:attr:`RainGage.SOURCES`).
            timeseries (str): Name of time series in [``TIMESERIES``] section (:class:`TimeSeries`) with rainfall data.
            filename (str): Name of external file with rainfall data. Rainfall files are discussed in Section 11.3 Rainfall Files.
            station (str): Name of recording station used in the rain file.
            units (str): Rain depth units used in the rain file, either ``'IN'`` (inches) or ``'MM'`` (millimeters) (:attr:`RainGage.UNITS`).
        """
        self.name = str(name)
        self.form = form
        self.interval = interval
        self.SCF = float(SCF)
        self.source = source

        self.timeseries = timeseries
        self.filename = filename
        self.station = station
        self.units = units

        if args:
            if source == RainGage.SOURCES.TIMESERIES:
                self.timeseries = args[0]
                if len(args) != 1:
                    pass

            elif source == RainGage.SOURCES.FILE:
                self.filename = convert_string(args[0])
                self.station = args[1]
                self.units = args[2]

            else:
                raise NotImplementedError(f'{source=} is not implemented in the RainGage object.')


class Symbol(BaseSectionObject):
    """
    X,Y coordinates for rain gages.

    Section:
        [SYMBOLS]

    Purpose:
        Assigns X,Y coordinates to rain gage symbols.


    Attributes:
        gage (str): name of gage.
        x (float): horizontal coordinate relative to origin in lower left of map.
        y (float): vertical coordinate relative to origin in lower left of map.
    """
    _identifier = IDENTIFIERS.gage
    _section_label = SYMBOLS

    def __init__(self, gage, x, y):
        """
        X,Y coordinates for rain gages.

        Args:
            gage (str): name of gage.
            x (float): horizontal coordinate relative to origin in lower left of map.
            y (float): vertical coordinate relative to origin in lower left of map.
        """
        self.gage = str(gage)
        self.x = float(x)
        self.y = float(y)


class Pattern(BaseSectionObject):
    """
    Periodic multipliers referenced in other sections.

    Section:
        [PATTERNS]

    Purpose:
        Specifies time pattern of dry weather flow or quality in the form of adjustment factors
        applied as multipliers to baseline values.


    Format:
        ::

            Name MONTHLY Factor1 Factor2 ... Factor12
            Name DAILY Factor1  Factor2  ...  Factor7
            Name HOURLY Factor1  Factor2  ...  Factor24
            Name WEEKEND Factor1  Factor2  ...  Factor24

    Remarks:
        The ``MONTHLY`` format is used to set monthly pattern factors for dry weather flow constituents.

        The ``DAILY`` format is used to set dry weather pattern factors for each day of the week, where Sunday is day 1.

        The ``HOURLY`` format is used to set dry weather factors for each hour of the day starting from midnight.
        If these factors are different for weekend days than for weekday days then the ``WEEKEND`` format can be used
        to specify hourly adjustment factors just for weekends.

        More than one line can be used to enter a pattern’s factors by repeating the pattern’s name
        (but not the pattern type) at the beginning of each additional line.

        The pattern factors are applied as multipliers to any baseline dry weather flows or quality
        concentrations supplied in the [``DWF``] (:class:`DryWeatherFlow`) section.

    Examples:
        ::

            ; Day of week adjustment factors
            D1 DAILY 0.5 1.0 1.0 1.0 1.0 1.0 0.5
            D2 DAILY 0.8 0.9 1.0 1.1 1.0 0.9 0.8

            ; Hourly adjustment factors
            H1 HOURLY 0.5 0.6 0.7 0.8 0.8 0.9
            H1        1.1 1.2 1.3 1.5 1.1 1.0
            H1        0.9 0.8 0.7 0.6 0.5 0.5
            H1        0.5 0.5 0.5 0.5 0.5 0.5


    Attributes:
        name (str): Name used to identify the pattern.
        cycle (str): One of ``MONTHLY``, ``DAILY``, ``HOURLY``, ``WEEKEND`` (:attr:`Pattern.CYCLES`.).
        factors (list): Multiplier values.

        CYCLES: Enum-like for the attribute :attr:`Pattern.cycle` with following members -> {``MONTHLY`` | ``DAILY`` | ``HOURLY`` | ``WEEKEND``}

    Usage:
        - :attr:`Inflow.pattern`
        - :attr:`DryWeatherFlow.pattern1`, ...
        - :class:`EvaporationSection` with the key `RECOVERY`
        - :attr:`Aquifer.pattern`
        - :class:`AdjustmentsSection` with the keys `N_PERV`, `DSTORE`, `INFIL`
    """
    _identifier = IDENTIFIERS.name
    _section_label = PATTERNS
    _table_inp_export = False

    class CYCLES:
        MONTHLY = 'MONTHLY'
        DAILY = 'DAILY'
        HOURLY = 'HOURLY'
        WEEKEND = 'WEEKEND'

    def __init__(self, name, cycle, *_factors, factors=None):
        """
        Periodic multipliers referenced in other sections.

        Args:
            name (str): Name used to identify the pattern.
            cycle (str): One of ``MONTHLY``, ``DAILY``, ``HOURLY``, ``WEEKEND`` (:attr:`Pattern.CYCLES`.).
            factors (list): Multiplier values.
            *_factors: for automatic inp file reading
        """
        self.name = str(name)
        self.cycle = cycle
        if factors is not None:
            self.factors = factors
        elif isinstance(_factors[0], (list, tuple)):
            self.factors = _factors[0]
        else:
            self.factors = list(float(f) for f in _factors)

    @classmethod
    def _convert_lines(cls, multi_line_args):
        args = []
        for line in multi_line_args:
            if line[1] in [cls.CYCLES.MONTHLY, cls.CYCLES.DAILY,
                           cls.CYCLES.HOURLY, cls.CYCLES.WEEKEND]:
                if args:
                    yield cls(*args)
                args = line
            else:
                args += line[1:]
        # last
        if args:
            yield cls(*args)

    def to_inp_line(self):
        if self.cycle in (self.CYCLES.MONTHLY, self.CYCLES.HOURLY, self.CYCLES.WEEKEND):
            s = ''
            import numpy as np

            l = len(self.cycle)
            first = True
            for a in np.array_split(self.factors, int(len(self.factors) / 6)):
                if first:
                    s += f'{self.name} {self.cycle} '
                    first = False
                else:
                    s += f'\n{self.name} {" ":<{l}} '
                s += ' '.join([type2str(i) for i in a])
            return s
        else:
            return super().to_inp_line()


class Pollutant(BaseSectionObject):
    """
    Pollutant information.

    Section:
        [POLLUTANTS]

    Purpose:
        Identifies the pollutants being analyzed.

    Remarks:
        ``FLOW`` is a reserved word and cannot be used to name a pollutant.

        If there is no co-pollutant but non-default values for :attr:`Pollutant.c_dwf` or :attr:`Pollutant.c_init`,
        then enter an asterisk (``*``) for the co-pollutant name (:attr:`Pollutant.co_pollutant`).

        When pollutant X has a co-pollutant Y, it means that fraction :attr:`Pollutant.co_fraction` of pollutant Y's runoff
        concentration is added to pollutant X's runoff concentration when wash off from a subcatchment is computed.

        The dry weather flow concentration can be overridden for any specific node of the conveyance
        system by editing the node's Inflows property.

    Attributes:
        name (str): name assigned to pollutant.
        unit (str): concentration units (:attr:`Pollutant.UNITS`)

                - ``MG/L`` for milligrams per liter
                - ``UG/L`` for micrograms per liter
                - ``#/L`` for direct count per liter

        c_rain (float): Concentration of pollutant in rainfall (concentration units).
        c_gw (float): Concentration of pollutant in groundwater (concentration units).
        c_rdii (float): Concentration of pollutant in inflow/infiltration (concentration units).
        decay (float): First-order decay coefficient (1/days).
        snow_only (bool): ``YES`` (:obj:`True`) if pollutant buildup occurs only when there is snow cover, ``NO`` (:obj:`False`) otherwise (default is ``NO``).
        co_pollutant (str): name of co-pollutant (default is no co-pollutant designated by a ``*``).
        co_fraction (float): fraction of co-pollutant concentration (default is 0).
        c_dwf (float): pollutant concentration in dry weather flow (default is 0).
        c_init (float): pollutant concentration throughout the conveyance system at the start of the simulation (default is 0).

        UNITS: Enum-like for the attribute :attr:`Pollutant.unit` with following members -> {``MG_PER_L`` | ``UG_PER_L`` | ``COUNT_PER_L``}
    """
    _identifier = IDENTIFIERS.name
    _section_label = POLLUTANTS

    class UNITS:
        MG_PER_L = 'MG/L'
        UG_PER_L = 'UG/L'
        COUNT_PER_L = '#/L'

    def __init__(self, name, unit, c_rain, c_gw, c_rdii, decay,
                 snow_only=False, co_pollutant='*', co_fraction=0, c_dwf=0, c_init=0):
        """
        Pollutant information.

        Args:
            name (str): Name assigned to pollutant.
            unit (str): Concentration units (:attr:`Pollutant.UNITS`).

                    - ``MG/L`` for milligrams per liter
                    - ``UG/L`` for micrograms per liter
                    - ``#/L`` for direct count per liter

            c_rain (float): Concentration of pollutant in rainfall (concentration units).
            c_gw (float): Concentration of pollutant in groundwater (concentration units).
            c_rdii (float): Concentration of pollutant in inflow/infiltration (concentration units).
            decay (float): First-order decay coefficient (1/days).
            snow_only (bool, Optional): ``YES`` (:obj:`True`) if pollutant buildup occurs only when there is snow cover, ``NO`` (:obj:`False`) otherwise (default is ``NO``).
            co_pollutant (str, Optional): name of co-pollutant (default is no co-pollutant designated by a ``*``).
            co_fraction (float, Optional): fraction of co-pollutant concentration (default is 0).
            c_dwf (float, Optional): pollutant concentration in dry weather flow (default is 0).
            c_init (float, Optional): pollutant concentration throughout the conveyance system at the start of the simulation (default is 0).
        """
        self.name = str(name)
        self.unit = str(unit)
        self.c_rain = float(c_rain)
        self.c_gw = float(c_gw)
        self.c_rdii = float(c_rdii)
        self.decay = float(decay)
        self.snow_only = to_bool(snow_only)
        self.co_pollutant = str(co_pollutant)
        self.co_fraction = float(co_fraction)
        self.c_dwf = float(c_dwf)
        self.c_init = float(c_init)


class Transect(BaseSectionObject):
    """
    Transect geometry for conduits with irregular cross-sections.

    Section:
        [TRANSECTS]

    Purpose:
        Describes the cross-section geometry of natural channels or conduits with irregular shapes
        following the HEC-2 data format.

    Formats:

        ::

            NC Nleft Nright Nchanl
            X1 Name Nsta Xleft Xright 0 0 0 Lfactor Wfactor Eoffset
            GR Elev Station ... Elev Station

    Remarks:
        Transect geometry is described as shown below, assuming that one is looking in a downstream direction:

        The first line in this section must always be a NC line. After that, the NC line is only needed when a
        transect has
        different Manning’s n values than the previous one.

        The Manning’s n values on the NC line will supersede any roughness value entered for the conduit which uses the
        irregular cross-section.

        There should be one X1 line for each transect.
        Any number of GR lines may follow, and each GR line can have any number of Elevation-Station data pairs.
        (In HEC-2 the GR line is limited to 5 stations.)

        The station that defines the left overbank boundary on the X1 line must correspond to one of the station entries
        on the GR lines that follow. The same holds true for the right overbank boundary. If there is no match,
        a warning
        will be issued and the program will assume that no overbank area exists.

        The meander modifier is applied to all conduits that use this particular transect for their cross section.
        It assumes that the length supplied for these conduits is that of the longer main channel.
        SWMM will use the shorter overbank length in its calculations while increasing the main channel roughness to
        account
        for its longer length.

    Attributes:
        name (str): name assigned to transect.
        station_elevations (list[list[float, float]]): of the tuple:

            Elev (float): elevation of the channel bottom at a cross-section station relative to some fixed reference (ft or m).
            Station (float): distance of a cross-section station from some fixed reference (ft or m).

        bank_station_left (float): station position which ends the left overbank portion of the channel (ft or m).
        bank_station_right (float): station position which begins the right overbank portion of the channel (ft or m).
        roughness_left (float): Manning’s n of right overbank portion of channel (use 0 if no change from previous NC line).
        roughness_right (float): Manning’s n of right overbank portion of channel (use 0 if no change from previous NC line.
        roughness_channel (float): Manning’s n of main channel portion of channel (use 0 if no change from previous NC line.
        modifier_stations (float): factor by which distances between stations should be multiplied to increase (or decrease) the width of the channel (enter 0 if not applicable). ``Wfactor``
        modifier_elevations (float): amount added (or subtracted) from the elevation of each station (ft or m).
        modifier_meander (float): meander modifier that represents the ratio of the length of a meandering main
            channel to the length of the overbank area that surrounds it (use 0 if not applicable).
    """
    _identifier = IDENTIFIERS.name
    _table_inp_export = False
    _section_label = TRANSECTS

    class KEYS:
        """KEYS: Enum-like for the attribute :attr:`Inflow.kind` with following members -> {``NC`` | ``X1`` | ``GR``}"""
        NC = 'NC'
        X1 = 'X1'
        GR = 'GR'

    def __init__(self, name, station_elevations=None, bank_station_left=0, bank_station_right=0,
                 roughness_left=0, roughness_right=0, roughness_channel=0,
                 modifier_stations=0, modifier_elevations=0, modifier_meander=0):
        """
        Transect geometry for conduits with irregular cross-sections.

        Args:
            name (str): name assigned to transect.
            station_elevations (list[list[float, float]]): of the tuple:

                Elev (float): elevation of the channel bottom at a cross-section station relative to some fixed reference (ft or m).
                Station (float): distance of a cross-section station from some fixed reference (ft or m).

            bank_station_left (float): station position which ends the left overbank portion of the channel (ft or m).
            bank_station_right (float): station position which begins the right overbank portion of the channel (ft or m).
            roughness_left (float): Manning’s n of right overbank portion of channel (use 0 if no change from previous NC line).
            roughness_right (float): Manning’s n of right overbank portion of channel (use 0 if no change from previous NC line.
            roughness_channel (float): Manning’s n of main channel portion of channel (use 0 if no change from previous NC line.
            modifier_stations (float): factor by which distances between stations should be multiplied to increase (or decrease) the width of the channel (enter 0 if not applicable). ``Wfactor``
            modifier_elevations (float): amount added (or subtracted) from the elevation of each station (ft or m).
            modifier_meander (float): meander modifier that represents the ratio of the length of a meandering main
                channel to the length of the overbank area that surrounds it (use 0 if not applicable).
        """
        self.name = str(name)

        self.roughness_left = None
        self.roughness_right = None
        self.roughness_channel = None
        self.set_roughness(roughness_left, roughness_right, roughness_channel)

        self.bank_station_left = None
        self.bank_station_right = None
        self.set_bank_stations(bank_station_left, bank_station_right)

        self.modifier_stations = None
        self.modifier_elevations = None
        self.modifier_meander = None
        self.set_modifiers(modifier_meander, modifier_stations, modifier_elevations)

        self.station_elevations = []

        if station_elevations is not None:
            for s in station_elevations:
                self.add_station_elevation(*s)

    def add_station_elevation(self, station, elevation):
        self.station_elevations.append([float(station), float(elevation)])

    def set_roughness(self, left=0., right=0., channel=0.):
        self.roughness_left = float(left)
        self.roughness_right = float(right)
        self.roughness_channel = float(channel)

    def set_bank_stations(self, left=0., right=0.):
        self.bank_station_left = float(left)
        self.bank_station_right = float(right)

    def set_modifiers(self, meander=0., stations=0., elevations=0.):
        self.modifier_stations = float(stations)
        self.modifier_elevations = float(elevations)
        self.modifier_meander = float(meander)

    def get_number_stations(self):
        """``Nsta`` number of stations across cross-section at which elevation data is supplied."""
        return len(self.station_elevations)

    @classmethod
    def _convert_lines(cls, multi_line_args):
        last_roughness = [0, 0, 0]
        last = None

        for line in multi_line_args:
            if line[0] == cls.KEYS.NC:
                last_roughness = line[1:]

            elif line[0] == cls.KEYS.X1:
                if last is not None:
                    yield last
                last = cls(name=line[1])
                last.set_bank_stations(*line[3:5])
                last.set_modifiers(*line[8:])
                last.set_roughness(*last_roughness)

            elif line[0] == cls.KEYS.GR:
                it = iter(line[1:])
                for station in it:
                    elevation = next(it)
                    last.add_station_elevation(station, elevation)

        if last is not None:
            yield last

    def to_inp_line(self, break_every=1):
        """
        Convert object to one line of the ``.inp``-file.

        Args:
            break_every: break every x-th GR station, default: after every station
        """
        s = (f'{self.KEYS.NC} {self.roughness_left} {self.roughness_right} {self.roughness_channel}\n'
             f'{self.KEYS.X1} {self.name} {self.get_number_stations()} {self.bank_station_left} '
             f'{self.bank_station_right} 0 0 0 {self.modifier_meander} {self.modifier_stations} '
             f'{self.modifier_elevations}\n')
        if break_every == 1:
            for x, y in self.station_elevations:
                s += f'{self.KEYS.GR} {x} {y}\n'
        else:
            s += self.KEYS.GR
            i = 0
            for x, y in self.station_elevations:
                s += f' {x} {y}'
                i += 1
                if i == break_every:
                    i = 0
                    s += '\n' + self.KEYS.GR

        if s.endswith(self.KEYS.GR):
            s = s[:-3]
        s += '\n'
        return s


class Control(BaseSectionObject):
    """
    Rules that control pump and regulator operation.

    Section:
        [CONTROLS]

    Purpose:
        Determines how pumps and regulators will be adjusted
        based on simulation time or conditions at specific nodes and links.

    Formats:
        Each control rule is a series of statements of the form:
        ::

            RULE    ruleID
            IF      condition_1
            AND     condition_2
            OR      condition_3
            AND     condition_4
            Etc.
            THEN    action_1
            AND     action_2
            Etc.
            ELSE    action_3
            AND     action_4
            Etc.
            PRIORITY value

    Remarks:
        `RuleID`: an ID label assigned to the rule.
        `condition_n`: a condition clause.
        `action_n`: an action clause.
        `value`: a priority value (e.g., a number from 1 to 5).

        A **condition clause** of a Control Rule has the following format:
            `Object Name Attribute Relation Value`

        where:
            - `Object`: is a category of object,
            - `Name`: is the object’s assigned ID name,
            - `Attribute`: is the name of an attribute or property of the object,
            - `Relation`: is a relational operator (=, <>, <, <=, >, >=), and
            - `Value`: is an attribute value.

        for example:
        ::

            NODE N23 DEPTH > 10
            PUMP P45 STATUS = OFF
            SIMULATION TIME = 12:45:00
            NODE  N23  DEPTH  >  10
            NODE  N23  DEPTH  >  NODE 25 DEPTH
            PUMP  P45  STATUS =  OFF
            LINK  P45  TIMEOPEN >= 6:30
            SIMULATION CLOCKTIME = 22:45:00

        TIMEOPEN is the duration a link has been in an OPEN or ON state or have its
        SETTING be greater than zero; TIMECLOSED is the duration it has remained in a
        CLOSED or OFF state or have its SETTING be zero.

        +------------+------------+----------------------------------+
        | Object     | Attributes | Value                            |
        +============+============+==================================+
        | NODE       | DEPTH      | numerical value                  |
        +------------+------------+----------------------------------+
        |            | HEAD       | numerical value                  |
        +------------+------------+----------------------------------+
        |            | VOLUME     | numerical value                  |
        +------------+------------+----------------------------------+
        |            | INFLOW     | numerical value                  |
        +------------+------------+----------------------------------+
        | LINK       | FLOW       | numerical value                  |
        +------------+------------+----------------------------------+
        |            | DEPTH      | numerical value                  |
        +------------+------------+----------------------------------+
        |            | TIMEOPEN   | decimal hours or hr:min          |
        +------------+------------+----------------------------------+
        |            | TIMECLOSED | decimal hours or hr:min          |
        +------------+------------+----------------------------------+
        | CONDUIT    | STATUS     | OPEN or CLOSED                   |
        +------------+------------+----------------------------------+
        |            | TIMEOPEN   | decimal hours or hr:min          |
        +------------+------------+----------------------------------+
        |            | TIMECLOSED | decimal hours or hr:min          |
        +------------+------------+----------------------------------+
        | PUMP       | STATUS     | ON or OFF                        |
        +------------+------------+----------------------------------+
        |            | SETTING    | pump curve multiplier            |
        +------------+------------+----------------------------------+
        |            | FLOW       | numerical value                  |
        +------------+------------+----------------------------------+
        |            | TIMEOPEN   | decimal hours or hr:min          |
        +------------+------------+----------------------------------+
        |            | TIMECLOSED | decimal hours or hr:min          |
        +------------+------------+----------------------------------+
        | ORIFICE    | SETTING    | fraction open                    |
        +------------+------------+----------------------------------+
        |            | TIMEOPEN   | decimal hours or hr:min          |
        +------------+------------+----------------------------------+
        |            | TIMECLOSED | decimal hours or hr:min          |
        +------------+------------+----------------------------------+
        | WEIR       | SETTING    | fraction open                    |
        +------------+------------+----------------------------------+
        |            | TIMEOPEN   | decimal hours or hr:min          |
        +------------+------------+----------------------------------+
        |            | TIMECLOSED | decimal hours or hr:min          |
        +------------+------------+----------------------------------+
        | OUTLET     | SETTING    | rating curve multiplier          |
        +------------+------------+----------------------------------+
        |            | TIMEOPEN   | decimal hours or hr:min          |
        +------------+------------+----------------------------------+
        |            | TIMECLOSED | decimal hours or hr:min          |
        +------------+------------+----------------------------------+
        | SIMULATION | TIME       | elapsed time in decimal hours or |
        +------------+------------+----------------------------------+
        |            |            | hr:min:sec                       |
        +------------+------------+----------------------------------+
        | SIMULATION | DATE       | month/day/year                   |
        +------------+------------+----------------------------------+
        |            | MONTH      | month of year (January = 1)      |
        +------------+------------+----------------------------------+
        |            | DAY        | day of week (Sunday = 1)         |
        +------------+------------+----------------------------------+
        |            | CLOCKTIME  | time of day in hr:min:sec        |
        +------------+------------+----------------------------------+

        An **Action Clause** of a Control Rule has the following format:
            `Object Name Action = Value`
            `PUMP id STATUS = ON/OFF`
            `PUMP/ORIFICE/WEIR/OUTLET id SETTING = value`

        where:
            - `Object`: is a category of object,
            - `Name`: is the object’s assigned ID name,
            - `Action`: is the type of action
            - `Value`: is the action value/setting/status.

        where the meaning of SETTING depends on the object being controlled:
            - for Pumps it is a multiplier applied to the flow computed from the pump curve,
            - for Orifices it is the fractional amount that the orifice is fully open,
            - for Weirs it is the fractional amount of the original freeboard that exists (i.e., weir control is accomplished by moving the crest height up or down),
            - for Outlets it is a multiplier applied to the flow computed from the outlet's rating curve.

        Modulated controls are control rules that provide for a continuous degree of control
        applied to a pump or flow regulator as determined by the value of some controller
        variable, such as water depth at a node, or by time. The functional relation between
        the control setting and the controller variable is specified by using a control curve, a
        time series, or a PID controller. To model these types of controls, the value entry on
        the right-hand side of the action clause is replaced by the keyword CURVE,
        TIMESERIES, or PID and followed by the id name of the respective control curve or
        time series or by the gain, integral time (in minutes), and derivative time (in minutes)
        of a PID controller. For direct action control the gain is a positive number while for
        reverse action control it must be a negative number. By convention, the controller
        variable used in a control curve or PID control will always be the object and attribute
        named in the last condition clause of the rule. The value specified for this clause will
        be the setpoint used in a PID controller.


        for example:
        ::

            PUMP P67 STATUS = OFF
            ORIFICE O212 SETTING = 0.5
            WEIR W25 SETTING = CURVE C25
            ORIFICE ORI_23 SETTING = PID 0.1 0.1 0.0

        Only the RULE, IF and THEN portions of a rule are required; the other portions are optional.
        When mixing AND and OR clauses, the OR operator has higher precedence than AND, i.e., `IF A or B and C`
        is equivalent to `IF (A or B) and C.`
        If the interpretation was meant to be `IF A or (B and C)`
        then this can be expressed using two rules as in `IF A THEN ... IF B and C THEN ...`

        The PRIORITY value is used to determine which rule applies when two or more rules
        require that conflicting actions be taken on a link. A conflicting rule with a higher
        priority value has precedence over one with a lower value (e.g., PRIORITY 5
        outranks PRIORITY 1). A rule without a priority value always has a lower priority
        than one with a value. For two rules with the same priority value, the rule that
        appears first is given the higher priority.


    Examples:
        ::

            ; Simple time-based pump control
            RULE R1
            IF SIMULATION TIME > 8
            THEN PUMP 12 STATUS = ON
            ELSE PUMP 12 STATUS = OFF

            ; Multi-condition orifice gate control
            RULE R2A
            IF NODE 23 DEPTH > 12
            AND LINK 165 FLOW > 100
            THEN ORIFICE R55 SETTING = 0.5

            RULE R2B
            IF NODE 23 DEPTH > 12
            AND LINK 165 FLOW > 200
            THEN ORIFICE R55 SETTING = 1.0

            RULE R2C
            IF NODE 23 DEPTH <= 12
            OR LINK 165 FLOW <= 100
            THEN ORIFICE R55 SETTING = 0

            ; PID controller that attempts to keep Node 23’s depth at 12:
            RULE PID_1
            IF NODE 23 DEPTH <> 12
            THEN ORIFICE R55 SETTING = PID 0.5 0.1 0.0

            ; Pump station operation with a main (N1A) and lag (N1B) pump
            RULE R3A
            IF NODE N1 DEPTH > 5
            THEN PUMP N1A STATUS = ON

            RULE R3B
            IF PUMP N1A TIMEOPEN > 2:30
            THEN PUMP N1B STATUS = ON
            ELSE PUMP N1B STATUS = OFF

            RULE R3C
            IF NODE N1 DEPTH <= 0.5
            THEN PUMP N1A STATUS = OFF
            AND PUMP N1B STATUS = OFF

    """
    _identifier = IDENTIFIERS.name
    _table_inp_export = False
    _section_label = CONTROLS

    class OBJECTS:
        GAGE = 'GAGE'  # new in 5.2
        NODE = 'NODE'
        LINK = 'LINK'
        CONDUIT = 'CONDUIT'
        PUMP = 'PUMP'
        ORIFICE = 'ORIFICE'
        WEIR = 'WEIR'
        OUTLET = 'OUTLET'
        SIMULATION = 'SIMULATION'

    class ATTRIBUTES:
        DEPTH = 'DEPTH'
        HEAD = 'HEAD'
        VOLUME = 'VOLUME'
        INFLOW = 'INFLOW'
        FLOW = 'FLOW'
        TIMEOPEN = 'TIMEOPEN'
        TIMECLOSED = 'TIMECLOSED'
        STATUS = 'STATUS'
        SETTING = 'SETTING'
        TIME = 'TIME'
        DATE = 'DATE'
        MONTH = 'MONTH'
        DAY = 'DAY'
        CLOCKTIME = 'CLOCKTIME'
        INTENSITY = 'INTENSITY'  # new in 5.2
        n_HR_DEPTH = 'n-HR_DEPTH'  # new in 5.2

    class LOGIC:
        RULE = 'RULE'  # only to declare the first line of a rule
        IF = 'IF'  # only for conditions
        THEN = 'THEN'  # only for actions
        ELSE = 'ELSE'  # only for actions
        PRIORITY = 'PRIORITY'  # only to declare the last line of a rule with a priority
        AND = 'AND'  # for conditions and actions
        OR = 'OR'  # only for conditions

    LOGIC_TYPES = {i for i in LOGIC.__dict__ if not i.startswith('__')}
    OBJECT_TYPES = {i for i in OBJECTS.__dict__ if not i.startswith('__')}

    class _Condition(BaseSectionObject):
        """
        A **condition clause** of a Control Rule has the following format:
            `Object Name Attribute Relation Value`
            `SIMULATION Attribute Relation Value`

        where:
            - `Object`: is a category of object,
            - `Name`: is the object’s assigned ID name,
            - `Attribute`: is the name of an attribute or property of the object,
            - `Relation`: is a relational operator (=, <>, <, <=, >, >=), and
            - `Value`: is an attribute value.

        for example:
        ::

            NODE N23 DEPTH > 10
            PUMP P45 STATUS = OFF
            SIMULATION TIME = 12:45:00
            NODE  N23  DEPTH  >  10
            NODE  N23  DEPTH  >  NODE 25 DEPTH
            PUMP  P45  STATUS =  OFF
            LINK  P45  TIMEOPEN >= 6:30
            SIMULATION CLOCKTIME = 22:45:00
        """

        def __init__(self, logic: Literal['IF', 'OR', 'AND'], object_kind=np.nan, *args, label=np.nan, attribute=None, relation: Literal['=', '<>', '<', '<=', '>', '>='] = None, value=None):
            self.logic = logic.upper()  # if, and, or

            if isinstance(object_kind, str):
                self.object_kind = object_kind.upper()  # Control.OBJECTS
            else:
                self.object_kind = object_kind  # NaN for Variables

            line = list(args)
            if line and self.object_kind not in Control.OBJECT_TYPES:
                # Variable or Expression

                self.attribute = np.nan
                self.label = object_kind  # Name of the variable or expression
                self.object_kind = np.nan

                self.relation = line.pop(0)
                self.value = ' '.join([str(i) for i in line])

            elif line:
                self.label = np.nan  # only for kind==SIMULATION
                # 'SIMULATION' has/needs no label
                if self.object_kind != Control.OBJECTS.SIMULATION:
                    self.label = line.pop(0)

                self.attribute = line.pop(0).upper()
                self.relation = line.pop(0)
                self.value = ' '.join([str(i) for i in line])
            else:
                self.label = label
                self.attribute = attribute
                self.relation = relation
                self.value = value

        def involves_variable_or_expression(self):
            return is_nan(self.object_kind)

    class _Action(BaseSectionObject):
        """
        An **Action Clause** of a Control Rule has the following format:
            `Object Name Action = Value`
            `PUMP id STATUS = ON/OFF`
            `PUMP/ORIFICE/WEIR/OUTLET id SETTING = value`

        where:
            - `Object`: is a category of object,
            - `Name`: is the object’s assigned ID name,
            - `Action`: is the type of action
            - `Value`: is the action value/setting/status.

        for example:
        ::

            PUMP P67 STATUS = OFF
            ORIFICE O212 SETTING = 0.5
            WEIR W25 SETTING = CURVE C25
            ORIFICE ORI_23 SETTING = PID 0.1 0.1 0.0
        """

        def __init__(self, kind, label, action, relation='=', *values, value=None):
            self.kind = kind.upper()  # Control.OBJECTS
            self.label = label  # label of the object
            self.action = action.upper()  #
            self.relation = relation  # immer "="  # always equal
            if value is not None:
                self.value = value
            else:
                self.value = ' '.join(values)

        def to_inp_line(self):
            """
            Convert object to one line of the ``.inp``-file.

            for ``.inp``-file writing

            Returns:
                str: SWMM .inp file compatible string
            """
            return f'{self.kind} {self.label} {self.action} {self.relation} {self.value}'

    def __init__(self, name, conditions, actions_if, actions_else=None, priority=0):
        self.name = str(name)
        self.conditions = conditions  # type: list[Control._Condition]
        self.actions_if = actions_if  # type: list[Control._Action]
        self.actions_else = [] if actions_else is None else actions_else  # type: list[Control._Action]
        self.priority = int(priority)

    @classmethod
    def _convert_lines(cls, multi_line_args):
        kwargs = {}

        class SECTIONS(enum.Enum):
            CONDITIONS = 0
            ACTIONS_IF = 1
            ACTIONS_ELSE = 2

        last = None
        for logic, *line in multi_line_args:
            logic = logic.upper()
            if logic == ControlVariable.KEYWORD:
                yield ControlVariable.from_inp_line(*line)

            elif logic == ControlExpression.KEYWORD:
                yield ControlExpression.from_inp_line(*line)

            elif logic == cls.LOGIC.RULE:
                if kwargs:
                    yield cls(**kwargs)
                    kwargs = {}
                kwargs[IDENTIFIERS.name] = line[0]
                last = None

            elif logic == cls.LOGIC.IF:
                kwargs['conditions'] = [cls._Condition(logic, *line)]
                # is_condition = True
                last = SECTIONS.CONDITIONS

            elif logic == cls.LOGIC.THEN:
                kwargs['actions_if'] = [cls._Action(*line)]
                # args.append([cls._Action(logic, *line)])
                # is_condition = False
                # is_action = True
                last = SECTIONS.ACTIONS_IF

            elif logic == cls.LOGIC.ELSE:
                kwargs['actions_else'] = [cls._Action(*line)]
                # args.append([cls._Action(logic, *line)])
                # is_condition = False
                # is_action = True
                last = SECTIONS.ACTIONS_ELSE

            elif logic == cls.LOGIC.PRIORITY:
                kwargs['priority'] = line[0]
                # args.append(line[0])
                # is_action = False
                last = None

            elif last is SECTIONS.CONDITIONS:
                kwargs['conditions'].append(cls._Condition(logic, *line))

            elif last is SECTIONS.ACTIONS_IF:
                kwargs['actions_if'].append(cls._Action(*line))

            elif last is SECTIONS.ACTIONS_ELSE:
                kwargs['actions_else'].append(cls._Action(*line))

        # last
        if kwargs:  # if section was empty
            yield Control(**kwargs)

    def copy(self):
        return type(self)(self.name, self.conditions.copy(), self.actions_if.copy(), self.actions_else.copy(), self.priority)

    def to_inp_line(self):
        s = f'{self.LOGIC.RULE} {self.name}\n'
        s += '{}\n'.format('\n'.join([c.to_inp_line() for c in self.conditions]))
        s += 'THEN {}\n'.format('\nAND '.join([a.to_inp_line() for a in self.actions_if]))
        if self.actions_else:
            s += 'ELSE {}\n'.format('\nAND '.join([a.to_inp_line() for a in self.actions_else]))
        s += f'{self.LOGIC.PRIORITY} {self.priority}\n'
        return s


class ControlVariable(Control):
    """
    Named Variables are aliases used to represent the triplet of
    <object type | object id | object attribute> (or a doublet for Simulation times)
    that appear in the condition clauses of control rules.

    Tested in GUI: object must exists, else error when running swmm -> no placeholders

    They allow condition clauses to be written as:

    - `variable relation value`
    - `variable relation variable`

    where `variable` is defined on a separate line before its first use in a rule using the format:
    `VARIABLE name = object id attribute`

    Here is an example of using this feature:
    ::

        VARIABLE N123_Depth = NODE N123 DEPTH
        VARIABLE N456_Depth = NODE N456 DEPTH
        VARIABLE P45 = PUMP 45 STATUS

        RULE 1
        IF N123_Depth > N456_Depth
        AND P45 = OFF
        THEN PUMP 45 STATUS = ON

        RULE 2
        IF N123_Depth < 1
        THEN PUMP 45 STATUS = OFF

    A variable is not allowed to have the same name as an object attribute.

    Aside from saving some typing, named variables are required when using arithmetic expressions
    in rule condition clauses.
    """
    KEYWORD = 'VARIABLE'

    def __init__(self, name, object_kind, label, attribute=np.nan):
        self.name = name
        self.object_kind = object_kind.upper()   # Control.OBJECTS
        self.label = label
        self.attribute = attribute

    def copy(self):
        return BaseSectionObject.copy(self)

    @classmethod
    def from_inp_line(cls, *line_args):
        return cls(*(l for l in line_args if l != '='))

    def to_inp_line(self):
        return f'{self.KEYWORD} {self.name} = {self.object_kind} {self.label} {self.attribute}\n'


class ControlExpression(Control):
    """
    In addition to a simple condition placed on a single variable, a control condition clause can also
    contain an arithmetic expression formed from several variables whose value is compared
    against. Thus the format of a condition clause can be extended as follows:

    - `expression relation value`
    - `expression relation variable`

    where `expression` is defined on a separate line before its first use in a rule using the format:
    `EXPRESSION name = f(variable1, variable2, ...)`

    Tested with GUI: expression as  a function of another expression is not possible (no chained dependencies)

    The function `f(...)` can be any well-formed mathematical expression containing one or more
    named variables as well as any of the following math functions (which are case insensitive) and
    operators:

    - abs(x) for absolute value of x
    - sgn(x) which is +1 for x >= 0 or -1 otherwise
    - step(x) which is 0 for x <= 0 and 1 otherwise
    - sqrt(x) for the square root of x
    - log(x) for logarithm base e of x
    - log10(x) for logarithm base 10 of x
    - exp(x) for e raised to the x power
    - the standard trig functions (sin, cos, tan, and cot)
    - the inverse trig functions (asin, acos, atan, and acot)
    - the hyperbolic trig functions (sinh, cosh, tanh, and coth)
    - the standard operators +, -, *, /, ^ (for exponentiation ) and any level of nested parentheses.

    Here is an example of using this feature:
    ::
        VARIABLE P1_flow = LINK 1 FLOW
        VARIABLE P2_flow = LINK 2 FLOW
        VARIABLE O3_flow = Link 3 FLOW

        EXPRESSION Net_Inflow = (P1_flow + P2_flow)/2 - O3_flow

        RULE 1
        IF Net_Inflow > 0.1
        THEN ORIFICE 3 SETTING = 1
        ELSE ORIFICE 3 SETTING = 0.5
    """
    KEYWORD = 'EXPRESSION'

    def __init__(self, name, expression, *_expressions):
        self.name = name
        self.expression = expression + ' '.join(_expressions)

    def copy(self):
        return BaseSectionObject.copy(self)

    @classmethod
    def from_inp_line(cls, *line_args):
        return cls(*(l for l in line_args if l != '='))

    def to_inp_line(self):
        return f'{self.KEYWORD} {self.name} = {self.expression}\n'

    def get_variables_involved(self) -> set:
        # variables can't be named only as number
        e = self.expression

        set_functions = {'abs', 'sgn', 'step', 'sqrt', 'log', 'log10', 'exp'}

        for func in ('sin', 'cos', 'tan', 'cot'):
            set_functions.add(func)
            set_functions.add(func+'h')
            set_functions.add('a'+func)

        # replace ()*/+-^ with space
        li_operators = '()*/+-^'
        for op in li_operators:
            e = e.replace(op, ' ')

        # split by space and make set
        # remove numbers and functions
        return {i for i in set(e.split(' ')) if not (i.replace('.', '').isnumeric() or (i.lower() in set_functions))}


class Curve(BaseSectionObject):
    """
    X-Y tabular data referenced in other sections.

    Section:
        [CURVES]

    Purpose:
        Describes a relationship between two variables in tabular format.

    Format:
        ::

            Name Type X-value Y-value ...

    Remarks:
        Multiple pairs of x-y values can appear on a line. If more than one line is needed,
        repeat the curve's name (but not the type) on subsequent lines. The x-values must
        be entered in increasing order.

        Choices for curve type have the following meanings (flows are expressed in the
        user’s choice of flow units set in the [``OPTIONS``] section (:class:`OptionSection`)):

            - ``STORAGE``: surface area in ft2 (m2) v. depth in ft (m) for a storage unit node
            - ``SHAPE``: width v. depth for a custom closed cross-section, both normalized with respect to full depth
            - ``DIVERSION``: diverted outflow v. total inflow for a flow divider node
            - ``TIDAL``: water surface elevation in ft (m) v. hour of the day for an outfall node
            - ``PUMP1``: pump outflow v. increment of inlet node volume in ft3 (m3)
            - ``PUMP2``: pump outflow v. increment of inlet node depth in ft (m)
            - ``PUMP3``: pump outflow v. head difference between outlet and inlet nodes in ft (m)
            - ``PUMP4``: pump outflow v. continuous depth in ft (m)
            - ``RATING``: outlet flow v. head in ft (m)
            - ``CONTROL``: control setting v. controller variable
            - ``WEIR``: weir coefficient v. head in ft|m

    Examples:
        ::

            ;Storage curve (x = depth, y = surface area)
            AC1 STORAGE 0 1000 2 2000 4 3500 6 4200 8 5000
            ;Type1 pump curve (x = inlet wet well volume, y = flow )
            PC1 PUMP1
            PC1 100 5 300 10 500 20

    Attributes:
        name (str): Name assigned to table.
        kind (str): One of ``STORAGE`` / ``SHAPE`` / ``DIVERSION`` / ``TIDAL`` / ``PUMP1`` / ``PUMP2`` / ``PUMP3`` / ``PUMP4`` / ``RATING`` / ``CONTROL`` / ``WEIR`` (:attr:`Curve.TYPES`).
        points (list[list[float, float]]): tuple of X-value (an independent variable) and the corresponding Y-value (a dependent variable)

        TYPES: Enum-like for the attribute :attr:`Inflow.kind` with following members -> {`STORAGE`` | ``SHAPE`` | ``DIVERSION`` | ``TIDAL`` | ``PUMP1`` | ``PUMP2`` | ``PUMP3`` | ``PUMP4`` | ``RATING`` | ``CONTROL`` | ``WEIR``}
    """
    _identifier = IDENTIFIERS.name
    _table_inp_export = False
    _section_label = CURVES

    class TYPES:
        CONTROL = 'CONTROL'
        DIVERSION = 'DIVERSION'
        PUMP1 = 'PUMP1'
        PUMP2 = 'PUMP2'
        PUMP3 = 'PUMP3'
        PUMP4 = 'PUMP4'
        RATING = 'RATING'
        STORAGE = 'STORAGE'
        SHAPE = 'SHAPE'
        TIDAL = 'TIDAL'
        WEIR = 'WEIR'

    @classmethod
    def _get_names(cls, Type):
        TYPES = cls.TYPES
        if Type == TYPES.STORAGE:
            return ['depth', 'area']
        elif Type == TYPES.SHAPE:
            return ['depth', 'width']
        elif Type == TYPES.DIVERSION:
            return ['inflow', 'outflow']
        elif Type == TYPES.TIDAL:
            return ['hour', 'elevation']
        elif Type == TYPES.PUMP1:
            return ['volume', 'outflow']
        elif Type == TYPES.PUMP2:
            return ['depth', 'outflow']
        elif Type == TYPES.PUMP3:
            return ['head diff', 'outflow']
        elif Type == TYPES.PUMP4:
            return ['depth', 'outflow']
        elif Type == TYPES.RATING:
            return ['head', 'flow']
        elif Type == TYPES.CONTROL:
            return ['variable', 'setting']
        elif Type == TYPES.WEIR:
            return ['head', 'coefficient']

    def __init__(self, name, kind, points):
        """
        X-Y tabular data referenced in other sections.

        Args:
            name (str): Name assigned to table.
            kind (str): One of ``STORAGE`` / ``SHAPE`` / ``DIVERSION`` / ``TIDAL`` / ``PUMP1`` / ``PUMP2`` / ``PUMP3`` / `PUMP4`` / ``RATING`` / ``CONTROL`` (:attr:`Curve.TYPES`).
            points (list[list[float | int]]): tuple of X-value (an independent variable) and the corresponding Y-value (a dependent variable)
        """
        self.name = str(name)
        self.kind = kind.upper()
        self.points = points

    @classmethod
    def _convert_lines(cls, multi_line_args):
        last = None
        kind = None
        points = []
        for name, *line in multi_line_args:
            remains = iter(line)

            if name != last:
                # new curve line
                if last is not None:
                    # first return previous curve
                    yield cls(last, kind, points)
                # reset variables
                points = []
                last = name
                kind = next(remains)

            # points in current line
            for a in remains:
                b = next(remains)
                points.append(infer_type([a, b]))

        # last
        if last is not None:
            yield cls(last, kind, points)

    @property
    def frame(self):
        return pd.DataFrame.from_records(self.points, columns=self._get_names(self.kind))

    def to_inp_line(self):
        points = iter(self.points)
        x, y = next(points)
        f = f'{self.name}  {self.kind} {x:7.4f} {y:7.4f}\n'
        empty_space = ' ' * len(self.kind)
        for x, y in points:  # [(x,y), (x,y), ...]
            f += f'{self.name}  {empty_space} {x:7.4f} {y:7.4f}\n'
        return f


class Street(BaseSectionObject):
    """
    Cross-section geometry for street conduits.

    Section:
        [STREETS]

    Purpose:
        Describes the cross-section geometry of conduits that represent streets.

    Attributes:
        name(str): Name assigned to the street cross-section.
        width_crown (float): Distance from street’s curb to its crown (ft or m).
        height_curb (float): Curb height (ft or m).
        slope (float): Street cross slope (%).
        n_road (float): Manning’s roughness coefficient (n) of the road surface.
        depth_gutter (float | optional): Gutter depression height (in or mm) (default = 0).
        width_gutter (float | optional): Depressed gutter width (ft or m) (default = 0).
        sides (int | optional): 1 for single sided street or 2 for two-sided street (default = 2).
        width_backing (float | optional): Street backing width (ft or m) (default = 0).
        slope_backing (float | optional): Street backing slope (%) (default = 0).
        n_backing (float | optional): Street backing Manning’s roughness coefficient (n) (default = 0).

    Remarks:
        If the street has no depressed gutter (a = 0) then the gutter width entry is ignored. If the
        street has no backing then the three backing parameters can be omitted.
    """
    _identifier = IDENTIFIERS.name
    _table_inp_export = True
    _section_label = STREETS

    def __init__(self, name, width_crown, height_curb, slope, n_road, depth_gutter=0, width_gutter=0, sides=2,
                 width_backing=0, slope_backing=0, n_backing=0):
        """
        Cross-section geometry for street conduits.

        Args:
            name(str): Name assigned to the street cross-section.
            width_crown (float): Distance from street’s curb to its crown (ft or m).
            height_curb (float): Curb height (ft or m).
            slope (float): Street cross slope (%).
            n_road (float): Manning’s roughness coefficient (n) of the road surface.
            depth_gutter (float | optional): Gutter depression height (in or mm) (default = 0).
            width_gutter (float | optional): Depressed gutter width (ft or m) (default = 0).
            sides (int | optional): 1 for single sided street or 2 for two-sided street (default = 2).
            width_backing (float | optional): Street backing width (ft or m) (default = 0).
            slope_backing (float | optional): Street backing slope (%) (default = 0).
            n_backing (float | optional): Street backing Manning’s roughness coefficient (n) (default = 0).
        """
        self.name = str(name)
        self.width_crown = float(width_crown)
        self.height_curb = float(height_curb)
        self.slope = float(slope)
        self.n_road = float(n_road)
        self.depth_gutter = float(depth_gutter)
        self.width_gutter = float(width_gutter)
        self.sides = int(sides)
        self.width_backing = float(width_backing)
        self.slope_backing = float(slope_backing)
        self.n_backing = float(n_backing)


class Inlet(BaseSectionObject):
    """
    Design data for storm drain inlets.

    Section:
        [INLETS]

    Purpose:
        Defines inlet structure designs used to capture street and channel flow that are sent to below
        ground sewers.

    Format:
        ::

            Name GRATE/DROP_GRATE Length Width Type (Aopen Vsplash)
            Name CURB/DROP_CURB Length Height (Throat)
            Name SLOTTED Length Width
            Name CUSTOM Dcurve/Rcurve

    Parameters:
        name (str): name assigned to the inlet structure.
        length (float): length of the inlet parallel to the street curb (ft or m).
        width (float): width of a GRATE or SLOTTED inlet (ft or m).
        height (float): height of a CURB opening inlet (ft or m).
        grate_type (str): type of GRATE used (see below).
        area_open (float): fraction of a GENERIC grate’s area that is open.
        velocity_splash (float): splash over velocity for a GENERIC grate (ft/s or m/s).
        throat_angle (str): the throat angle of a CURB opening inlet (HORIZONTAL, INCLINED or VERTICAL).
        curve (str): one of:
            - name of a Diversion-type curve (captured flow v. approach flow) for a CUSTOM inlet.
            - name of a Rating-type curve (captured flow v. water depth) for a CUSTOM inlet.

    Remarks:
        See Section 3.3.7 for a description of the different types of inlets that SWMM can model.

        Use one line for each inlet design except for a combination inlet where one GRATE line
        describes its grated inlet and a second CURB line (with the same inlet name) describes its curb
        opening inlet.

        GRATE, CURB, and SLOTTED inlets are used with STREET conduits, DROP_GRATE and
        DROP_CURB inlets with open channels, and a CUSTOM inlet with any conduit.

        GRATE and DROP_GRATE types can be any of the following:

            - ``P_BAR``-50: Parallel bar grate with bar spacing 17⁄8” on center
            - ``P_BAR``-50X100: Parallel bar grate with bar spacing 17⁄8” on center and 3⁄8” diameter lateral rods spaced at 4” on center
            - ``P_BAR``-30: Parallel bar grate with 11⁄8” on center bar spacing
            - ``CURVED_VANE``: Curved vane grate with 31⁄4” longitudinal bar and 41⁄4” transverse bar spacing on center
            - ``TILT_BAR``-45: 45 degree tilt bar grate with 21⁄4” longitudinal bar and 4” transverse bar spacing on center
            - ``TILT_BAR``-30: 30 degree tilt bar grate with 31⁄4” and 4” on center longitudinal and lateral bar spacing respectively
            - ``RETICULINE``: "Honeycomb" pattern of lateral bars and longitudinal bearing bars
            - ``GENERIC``: A generic grate design.

        Only a GENERIC type grate requires that Aopen and Vsplash values be provided.
        The other standard grate types have predetermined values of these parameters.
        (Splash over velocity is the minimum velocity that will cause some water to shoot over the inlet thus
        reducing its capture efficiency).

        A CUSTOM inlet takes the name of either a Diversion curve or a Rating curve as its only
        parameter (see the [CURVES] section). Diversion curves are best suited for on-grade
        inlets and Rating curves for on-sag inlets.

    Examples:
        ::

            ; A 2-ft x 2-ft parallel bar grate
            InletType1 GRATE 2 2 P-BAR-30

            ; A combination inlet
            InletType2 GRATE 2 2   CURVED_VANE
            InletType2 CURB  4 0.5 HORIZONTAL

            ; A custom inlet using Curve1 as its capture curve
            InletType3 CUSTOM Curve1
    """
    _identifier = (IDENTIFIERS.name, 'kind')
    _section_label = INLETS

    _table_inp_export = False  # due to possible mixed objects

    class TYPES:
        GRATE = 'GRATE'
        CURB = 'CURB'
        DROP_GRATE = 'DROP_GRATE'
        DROP_CURB = 'DROP_CURB'
        SLOTTED = 'SLOTTED'
        CUSTOM = 'CUSTOM'

    class THROAT:
        HORIZONTAL = 'HORIZONTAL'
        INCLINED = 'INCLINED'
        VERTICAL = 'VERTICAL'

    def __init__(self, name, kind,
                 # length, width, height, grate_type, area_open, velocity_splash, throat_angle
                 ):
        """Design data for storm drain inlets."""
        self.name = name
        self.kind = kind

    @classmethod
    def from_inp_line(cls, name, kind, *line_args):
        return _INLET_DICT[kind](name, kind, *line_args)


class InletGrate(Inlet):
    def __init__(self, name, kind=Inlet.TYPES.GRATE, length=None, width=None, grate_type=None, area_open=np.nan,
                 velocity_splash=np.nan):
        super().__init__(name, kind)
        self.length = float(length)
        self.width = float(width)
        self.grate_type = str(grate_type)
        self.area_open = area_open
        self.velocity_splash = velocity_splash


class InletCurb(Inlet):
    def __init__(self, name, kind=Inlet.TYPES.CURB, length=None, height=None, throat_angle=np.nan):
        super().__init__(name, kind)
        self.length = float(length)
        self.height = float(height)
        self.throat_angle = throat_angle


class InletSlotted(Inlet):
    def __init__(self, name, kind=Inlet.TYPES.SLOTTED, length=None, width=None):
        super().__init__(name, kind)
        self.length = float(length)
        self.width = float(width)


class InletCustom(Inlet):
    def __init__(self, name, kind=Inlet.TYPES.CUSTOM, curve=None):
        super().__init__(name, kind)
        self.curve = curve


_INLET_DICT = {
    Inlet.TYPES.GRATE  : InletGrate,
    Inlet.TYPES.CURB   : InletCurb,
    Inlet.TYPES.SLOTTED: InletSlotted,
    Inlet.TYPES.CUSTOM : InletCustom,
}


class InletUsage(BaseSectionObject):
    """
    Assignment of inlets to street and channel conduits.

    Section:
        [INLET_USAGE]

    Purpose:
        Assigns inlet structures to specific street and open channel conduits.

    Attributes:
        conduit (str): name of a street or open channel conduit containing the inlet.
        inlet (str): name of an inlet structure (from the [``INLETS``] section (:class:`Inlet`)) to use.
        node (str): name of the sewer node receiving flow captured by the inlet.
        num (int | optional): number of replicate inlets placed on each side of the street.
        clogged_pct (float | optional): degree to which inlet capacity is reduced due to clogging (%).
        flow_max (float | optional): maximum flow that the inlet can capture (flow units).
        height_gutter (float | optional): height of local gutter depression (in or mm).
        width_gutter (float | optional): width of local gutter depression (ft or m).
        placement (str | optional): One of ``AUTOMATIC``, ``ON_GRADE``, or ``ON_SAG`` (:attr:`InletUsage.PLACEMENTS`).

        PLACEMENTS: Enum-like for the attribute :attr:`InletUsage.placement` with following members -> {``AUTOMATIC`` | ``ON_GRADE`` | ``ON_SAG``}

    Remarks:
        Only conduits with a ``STREET`` cross section can be assigned a curb and gutter inlet while
        drop inlets can only be assigned to conduits with a ``RECT_OPEN`` or ``TRAPEZOIDAL`` cross
        section.

        Only the first three parameters are required. The default number of inlets is 1 (for each side
        of a two-sided street) while the remaining parameters have default values of 0.

        A :attr:`InletUsage.flow_max` value of 0 indicates that the inlet has no flow restriction.

        The local gutter depression applies only over the length of the inlet unlike the continuous
        depression for a ``STREET`` cross section which exists over the full curb length.

        The default inlet placement is AUTOMATIC, meaning that the program uses the network
        topography to determine whether an inlet operates on-grade or on-sag. On-grade means the
        inlet is located on a continuous grade. On-sag means the inlet is located at a sag or sump point
        where all adjacent conduits slope towards the inlet leaving no place for water to flow except
        into the inlet.
    """
    _identifier = 'conduit'  # inlet
    _table_inp_export = True
    _section_label = INLET_USAGE

    class PLACEMENTS:
        AUTOMATIC = 'AUTOMATIC'
        ON_GRADE = 'ON_GRADE'
        ON_SAG = 'ON_SAG'

    def __init__(self, conduit, inlet, node, num=np.nan, clogged_pct=np.nan, flow_max=np.nan, height_gutter=np.nan,
                 width_gutter=np.nan, placement=np.nan):
        """
        Assignment of inlets to street and channel conduits.

        Args:
            conduit (str): name of a street or open channel conduit containing the inlet.
            inlet (str): name of an inlet structure (from the [INLETS] section (:class:`Inlet`)) to use.
            node (str): name of the sewer node receiving flow captured by the inlet.
            num (int | optional): number of replicate inlets placed on each side of the street.
            clogged_pct (float | optional): degree to which inlet capacity is reduced due to clogging (%).
            flow_max (float | optional): maximum flow that the inlet can capture (flow units).
            height_gutter (float | optional): height of local gutter depression (in or mm).
            width_gutter (float | optional): width of local gutter depression (ft or m).
            placement (str | optional):  One of ``AUTOMATIC``, ``ON_GRADE``, or ``ON_SAG`` (:attr:`InletUsage.PLACEMENTS`).
        """
        self.conduit = str(conduit)
        self.inlet = str(inlet)
        self.node = str(node)
        self.num = int(num)
        self.clogged_pct = float(clogged_pct)
        self.flow_max = float(flow_max)
        self.height_gutter = float(height_gutter)
        self.width_gutter = float(width_gutter)
        self.placement = placement


class Timeseries(BaseSectionObject):
    """
    Time series data referenced in other sections.

    Section:
        [TIMESERIES]

    Purpose:
        Describes how a quantity varies over time.

    Formats:
        ::

            Name ( Date ) Hour Value ...
            Name Time Value ...
            Name FILE Fname

    Remarks:
        There are two options for supplying the data for a time series:
            i.: directly within this input file section as described by the first two formats
            ii.: through an external data file named with the third format.

        When direct data entry is used, multiple date-time-value or time-value entries can
        appear on a line. If more than one line is needed, the table's name must be repeated
        as the first entry on subsequent lines.

        When an external file is used, each line in the file must use the same formats listed
        above, except that only one date-time-value (or time-value) entry is allowed per line.
        Any line that begins with a semicolon is considered a comment line and is ignored.
        Blank lines are not allowed.

        Note that there are two methods for describing the occurrence time of time series data:

        - as calendar date/time of day (which requires that at least one date, at the start of the series, be entered)
        - as elapsed hours since the start of the simulation.

        For the first method, dates need only be entered at points in time when a new day occurs.

    Examples:
        ::

            ;Rainfall time series with dates specified
            TS1 6-15-2001 7:00 0.1 8:00 0.2 9:00 0.05 10:00 0
            TS1 6-21-2001 4:00 0.2 5:00 0 14:00 0.1 15:00 0

            ;Inflow hydrograph - time relative to start of simulation
            HY1 0 0 1.25 100 2:30 150 3.0 120 4.5 0
            HY1 32:10 0 34.0 57 35.33 85 48.67 24 50 0

    Attributes:
        name (str): name assigned to time series.

        TYPES: Enum-like for the attribute :attr:`TimeseriesFile.kind` with following members -> {``FILE``}
    """
    _identifier = IDENTIFIERS.name
    _section_label = TIMESERIES
    _table_inp_export = False  # due to possible mixed objects

    class TYPES:
        FILE = 'FILE'

    def __init__(self, name):
        self.name = str(name)

    @classmethod
    def _convert_lines(cls, multi_line_args):
        last = None
        data = []
        last_date = None

        for name, *line in multi_line_args:
            # ---------------------------------
            # yield last time-series
            # was the last line a TimeseriesData and is in this line a new name
            if last is not None and (name != last):  # new series
                yield TimeseriesData(last, data)
                data = []
                last_date = None

            # ---------------------------------
            # yield file time-series
            if line[0].upper() == cls.TYPES.FILE:
                yield TimeseriesFile(name, ' '.join(line[1:]))
                last = None
                continue

            # ---------------------------------
            # inline time-series
            last = name
            parts_in_line = iter(line)
            for part in parts_in_line:
                if ('/' in part) or (('-' in part) and not part.startswith('-')):
                    # MM-DD-YYYY or MM/DD/YYYY or MMM-DD-YYYY MMM/DD/YYYY
                    last_date = part

                    # HH:MM or HH:MM:SS or H (as float)
                    time = next(parts_in_line)
                else:
                    # HH:MM or HH:MM:SS or H (as float)
                    time = part

                data.append((
                    time if last_date is None else ' '.join([last_date, time]),
                    float(next(parts_in_line))
                ))

        # add last inline time-series if present
        if data:
            yield TimeseriesData(last, data)


class TimeseriesFile(Timeseries):
    """
    Time series data referenced in other sections.

    Section:
        [TIMESERIES]

    Purpose:
        Describes how a quantity varies over time.

    Formats:
        ::

            Name FILE Fname

    Attributes:
        name (str): name assigned to time series.
        filename (str): name of a file in which the time series data are stored.
    """

    def __init__(self, name, filename, kind=Timeseries.TYPES.FILE):
        """
        Time series data referenced in other sections.

        Args:
            name (str): Name assigned to time series.
            filename (str): Name of a file in which the time series data are stored.
            kind: always ``FILE`` (:attr:`Timeseries.TYPES`.FILE)
        """
        Timeseries.__init__(self, name)
        self.kind = self.TYPES.FILE
        self.filename = convert_string(filename)


class TimeseriesData(Timeseries):
    """
    Time series data referenced in other sections.

    Section:
        [TIMESERIES]

    Purpose:
        Describes how a quantity varies over time.

    Formats:
        ::

            Name ( Date ) Hour Value ...
            Name Time Value ...

    Attributes:
        name (str): name assigned to time series.
        data (list[tuple]): list of index/value tuple with:

            - Date: date in Month/Day/Year format (e.g., June 15, 2001 would be 6/15/2001).
            - Hour: 24-hour military time (e.g., 8:40 pm would be 20:40) relative to the last date specified
                   (or to midnight of the starting date of the simulation if no previous date was specified).
            - Time: hours since the start of the simulation, expressed as a decimal number or as hours:minutes.
            - Value: value corresponding to given date and time.
    """

    def __init__(self, name, data):
        """
        Time series data referenced in other sections.

        Args:
            name (str): Name assigned to time series.
            data (list[tuple]): List of index/value tuple with:

                - Date: date in Month/Day/Year format (e.g., June 15, 2001 would be 6/15/2001).
                - Hour: 24-hour military time (e.g., 8:40 pm would be 20:40) relative to the last date specified
                       (or to midnight of the starting date of the simulation if no previous date was specified).
                - Time: hours since the start of the simulation, expressed as a decimal number or as hours:minutes.
                - Value: value corresponding to given date and time.
        """
        Timeseries.__init__(self, name)
        self.data = data
        self._fix_index()

    def _fix_index(self):
        """
        convert string index to pandas.Timestamp (datetime like) or float

        index format supported by SWMM:
        - '%m/%d/%Y %H:%M'
        - '%b/%d/%Y %H:%M'
        - '%m-%d-%Y %H:%M'
        - '%b-%d-%Y %H:%M'
        - '%m/%d/%Y %H:%M:%S'
        - '%b/%d/%Y %H:%M:%S'
        - '%m-%d-%Y %H:%M:%S'
        - '%b-%d-%Y %H:%M:%S'
        - Hours as float relative to simulation start time
        """
        date_time, values = zip(*self.data)
        date_time_new = []
        last_date = None

        # str_only: only for very long timeseries in the .inp-file.
        # The datetime will be converted with pandas for performance boost.
        if len(date_time) > 10000 * 2:  # 10000 it/s
            str_only = True
        else:
            str_only = False
        try:
            loc = locale.getlocale(locale.LC_TIME)

            # use default locale for SWMM dates
            try:
                locale.setlocale(locale.LC_TIME, 'en_US.utf8')  # works for windows and linux
            except locale.Error:
                locale.setlocale(locale.LC_TIME, 'en_US.UTF-8')  # works for mac

            for dt in date_time:
                if isinstance(dt, (pd.Timestamp, datetime.datetime)):
                    date_time_new.append(dt)
                elif isinstance(dt, (float, int)):
                    date_time_new.append(dt)
                else:
                    parts = dt.split()
                    if len(parts) == 1:
                        time = parts[0]
                    else:
                        last_date, time = parts

                    date_time_new.append(str_to_datetime(last_date, time, str_only=str_only))
            if str_only:
                date_time_new = pd.to_datetime(date_time_new, format='%m/%d/%Y %H:%M:%S')

            try:
                locale.setlocale(locale.LC_TIME, loc)  # restore saved locale
            except locale.Error:
                locale.setlocale(locale.LC_TIME, '')
            self.data = list(zip(date_time_new, values))
        except Exception as e:
            # if the conversion doesn't work - skip it
            # maybe the locale is not available
            warnings.warn(f'Could not convert Data for Timeseries(Name={self.name}). First datetime = "{date_time[0]}"')

    @property
    def frame(self):
        """
        convert object to pandas Series

        Returns:
            pandas.Series: Timeseries
        """
        warnings.warn('Using "TimeseriesData.frame" is deprecated, use "TimeseriesData.pandas" instead.', DeprecationWarning)
        return self.pandas

    @property
    def pandas(self):
        """
        convert object to pandas Series

        Returns:
            pandas.Series: Timeseries
        """
        date_time, values = zip(*self.data)
        return pd.Series(index=date_time, data=values, name=self.name)

    def to_inp_line(self):
        return '\n'.join(
            f'{self.name} {datetime_to_str(date_time)} {value}'
            for date_time, value in self.data
        ) + '\n'

    @classmethod
    def from_pandas(cls, series, label=None):
        """
        convert pandas Series to TimeseriesData object

        Args:
            series (pandas.Series): timeseries with DateTimeIndex
                or index with correct formatted for SWMM:
                - '%m/%d/%Y %H:%M'
                - '%b/%d/%Y %H:%M'
                - '%m-%d-%Y %H:%M'
                - '%b-%d-%Y %H:%M'
                - '%m/%d/%Y %H:%M:%S'
                - '%b/%d/%Y %H:%M:%S'
                - '%m-%d-%Y %H:%M:%S'
                - '%b-%d-%Y %H:%M:%S'
                - Hours as float relative to simulation start time
            label (str): optional: label of the series. default: take series.name

        Returns:
            TimeseriesData: object for inp file
        """
        return cls(series.name if label is None else label, list(zip(series.index, series.values)))


class Tag(BaseSectionObject):
    """
    Tags for node, link and subcatchment objects.

    Section:
        [TAGS]

    Purpose:
        Not for computation. Only for labeling or selection of objects.

    Attributes:
        kind (str): Type of object. One of :attr:`Tag.TYPES`.
        name (str): label of the object.
        tag (str): tag.

        TYPES: Enum-like for the attribute :attr:`Tag.kind` with following members -> {``Node`` | ``Subcatch`` | ``Link``}
    """
    _identifier = ('kind', IDENTIFIERS.name)
    _section_label = TAGS

    class TYPES:
        Node = 'Node'
        Subcatch = 'Subcatch'
        Link = 'Link'

    def __init__(self, kind, name, tag, *tags):
        """
        Tags for node, link and subcatchment objects.

        Args:
            kind (str): Type of object. One of :attr:`Tag.TYPES`.
            name (str): label of the object.
            tag (str): tag.
            *tags (str): Only for .inp-file reading, if whitespaces are in the tag.
        """
        self.kind = kind.lower().capitalize()
        self.name = name
        self.tag = tag
        if tags:
            self.tag += '_' + '_'.join(tags)


class Label(BaseSectionObject):
    """
    X,Y coordinates and text of labels.

    Section:
        [LABELS]

    Purpose:
        Assigns X,Y coordinates to user-defined map labels.

    Args:
        x (float): Horizontal coordinate relative to origin in lower left of map.
        y (float): Vertical coordinate relative to origin in lower left of map.
        label (str): Text of label surrounded by double quotes.
        anchor (str): Name of node or subcatchment that anchors the label on zoom-ins (use an empty pair of double quotes if there is no anchor).
        font (str): Name of label’s font (surround by double quotes if the font name includes spaces).
        size (float): Font size in points.
        bold (bool): ``YES`` (:obj:`True`) for bold font, `NO`` (:obj:`False`)  otherwise.
        italic (bool): ``YES`` (:obj:`True`) for italic font, `NO`` (:obj:`False`)  otherwise.
    """
    _identifier = ('x', 'y', 'label')
    _section_label = LABELS

    def __init__(self, x, y, label, anchor=np.nan, font=np.nan, size=np.nan, bold=np.nan, italic=np.nan):
        """
        X,Y coordinates and text of labels.

        Args:
            x (float): Horizontal coordinate relative to origin in lower left of map.
            y (float): Vertical coordinate relative to origin in lower left of map.
            label (str): Text of label surrounded by double quotes.
            anchor (str): Name of node or subcatchment that anchors the label on zoom-ins (use an empty pair of double quotes if there is no anchor).
            font (str): Name of label’s font (surround by double quotes if the font name includes spaces).
            size (float): Font size in points.
            bold (bool): ``YES`` (:obj:`True`) for bold font, `NO`` (:obj:`False`)  otherwise.
            italic (bool): ``YES`` (:obj:`True`) for italic font, `NO`` (:obj:`False`)  otherwise.
        """
        self.x = float(x)
        self.y = float(y)
        self.label = label
        self.anchor = anchor
        self.font = font
        self.size = size
        self.bold = bold
        self.italic = italic


class Hydrograph(BaseSectionObject):
    """
    Unit hydrograph data used to construct RDII inflows.

    Section:
        [HYDROGRAPHS]

    Purpose:
        Specifies the shapes of the triangular unit hydrographs that determine the amount of
        rainfall-dependent infiltration/inflow (RDII) entering the drainage system.

    Formats:
        ::

            Name Raingage
            Name Month SHORT/MEDIUM/LONG R T K (Dmax Drec D0)

    Remarks:
        For each group of unit hydrographs, use one line to specify its rain gage followed by
        as many lines as are needed to define each unit hydrograph used by the group
        throughout the year. Three separate unit hydrographs, that represent the short-term,
        medium-term, and long-term RDII responses, can be defined for each month (or all
        months taken together). Months not listed are assumed to have no RDII.

        The response ratio (:attr:`Hydrograph.Parameters.response_ratio`, R) is the fraction of a unit of rainfall depth that becomes RDII.
        The sum of the ratios for a set of three hydrographs does not have to equal 1.0.

        The recession limb ratio (:attr:`Hydrograph.Parameters.recession_limb_ratio`,K) is the ratio of the duration of the hydrograph’s recession
        limb to the time to peak (:attr:`Hydrograph.Parameters.time_to_peak`,T) making the hydrograph time base equal to T*(1+K) hours.
        The area under each unit hydrograph is 1 inch (or mm).

        The optional initial abstraction parameters determine how much rainfall is lost at the
        start of a storm to interception and depression storage. If not supplied then the
        default is no initial abstraction.

    Examples:
        ::

            ; All three unit hydrographs in this group have the same shapes except those in July,
            ; which have only a short- and medium-term response and a different shape.
            UH101 RG1
            UH101 ALL SHORT 0.033 1.0 2.0
            UH101 ALL MEDIUM 0.300 3.0 2.0
            UH101 ALL LONG 0.033 10.0 2.0
            UH101 JUL SHORT 0.033 0.5 2.0
            UH101 JUL MEDIUM 0.011 2.0 2.0

    Attributes:
        name (str): Name assigned to a unit hydrograph group.
        rain_gage (str): Name of the rain gage used by the unit hydrograph group.
        monthly_parameters (list[Hydrograph.Parameters]): List of response types per month.

        RESPONSE: Enum-like for the attribute :attr:`Hydrograph.Parameters.response` with following members -> {``SHORT`` | ``MEDIUM`` | ``LONG``}
        MONTHS: Enum-like for the attribute :attr:`Hydrograph.Parameters.month` with following members -> {JAN, FEB, MAR, APR, MAI, JUN, JUL, AUG, SEP, OCT, NOV, DEC, ALL}
    """
    _identifier = IDENTIFIERS.name
    _table_inp_export = False
    _section_label = HYDROGRAPHS

    class RESPONSE:
        SHORT = 'SHORT'
        MEDIUM = 'MEDIUM'
        LONG = 'LONG'

    def __init__(self, name, rain_gage, monthly_parameters=None):
        """
        Unit hydrograph data used to construct RDII inflows.

        Args:
            name (str): Name assigned to a unit hydrograph group.
            rain_gage (str): Name of the rain gage used by the unit hydrograph group.
            monthly_parameters (list[Hydrograph.Parameters]): List of response types per month.
        """
        self.name = str(name)
        self.rain_gage = str(rain_gage)

        if monthly_parameters is None:
            self.monthly_parameters = []
        else:
            self.monthly_parameters = monthly_parameters

    @classmethod
    def _convert_lines(cls, multi_line_args):
        last = None

        for name, *line in multi_line_args:
            # ---------------------------------
            if line[0].upper() not in cls.MONTHS._possible:
                if last is not None:
                    yield last
                last = cls(name, rain_gage=line[0])
            elif name == last.name:
                last.monthly_parameters.append(cls.MONTHS.Parameters(name, *line))
        if last is not None:
            yield last

    class MONTHS:
        JAN = 'JAN'
        FEB = 'FEB'
        MAR = 'MAR'
        APR = 'APR'
        MAY = 'MAY'
        JUN = 'JUN'
        JUL = 'JUL'
        AUG = 'AUG'
        SEP = 'SEP'
        OCT = 'OCT'
        NOV = 'NOV'
        DEC = 'DEC'

        ALL = 'ALL'

        _possible = [JAN, FEB, MAR, APR, MAY, JUN, JUL, AUG, SEP, OCT, NOV, DEC, ALL]

        class Parameters(BaseSectionObject):
            _identifier = (IDENTIFIERS.name, 'month', 'response')

            def __init__(self, name, month, response, response_ratio, time_to_peak, recession_limb_ratio,
                         depth_max=np.nan, depth_recovery=np.nan, depth_init=np.nan):
                """
                Unit hydrograph parameters.

                Args:
                    name (str): name assigned to a unit hydrograph group.
                    month (str): month of the year (e.g., JAN, FEB, etc. or ALL for all months) (One of :attr:`Hydrograph.MONTHS`).
                    response (str): One of :attr:`Hydrograph.RESPONSE`.
                    response_ratio (float): response ratio for the unit hydrograph.
                    time_to_peak (float):  time to peak (hours) for the unit hydrograph.
                    recession_limb_ratio (float):  recession limb ratio for the unit hydrograph.
                    depth_max (str): maximum initial abstraction depth available (in rain depth units).
                    depth_recovery (str): initial abstraction recovery rate (in rain depth units per day)
                    depth_init (str): initial abstraction depth already filled at the start of the simulation (in rain depth units).
                """
                self.name = str(name)
                self.month = str(month)
                self.response = str(response)
                self.response_ratio = float(response_ratio)
                self.time_to_peak = float(time_to_peak)
                self.recession_limb_ratio = float(recession_limb_ratio)
                self.depth_max = depth_max
                self.depth_recovery = depth_recovery
                self.depth_init = depth_init

    def to_inp_line(self):
        s = f'{self.name} {self.rain_gage}\n'
        for hyd in self.monthly_parameters:
            s += hyd.to_inp_line() + '\n'
        return s


class LandUse(BaseSectionObject):
    """
    Land use categories.

    Section:
        [LANDUSES]

    Purpose:
        Identifies the various categories of land uses within the drainage area. Each
        subcatchment area can be assigned a different mix of land uses. Each land use can
        be subjected to a different street sweeping schedule.

    Attributes:
        name (str): Land use name.
        sweep_interval (float): Days between street sweeping.
        availability (float): Fraction of pollutant buildup available for removal by street sweeping.
        last_sweep (float): Days since last sweeping at start of the simulation.
    """
    _identifier = IDENTIFIERS.name
    _section_label = LANDUSES

    def __init__(self, name, sweep_interval=np.nan, availability=np.nan, last_sweep=np.nan):
        """
        Land use categories.

        Args:
            name (str): Land use name.
            sweep_interval (float): Days between street sweeping.
            availability (float): Fraction of pollutant buildup available for removal by street sweeping.
            last_sweep (float): Days since last sweeping at start of the simulation.
        """
        self.name = str(name)
        self.sweep_interval = float(sweep_interval)
        self.availability = float(availability)
        self.last_sweep = float(last_sweep)


class WashOff(BaseSectionObject):
    """
    Washoff functions for pollutants and land uses.

    Section:
        [WASHOFF]

    Purpose:
        Specifies the rate at which pollutants are washed off from different land uses during rain events.

    Remarks:
        Table: Pollutant wash off functions

        +------+--------------------------+--------------------------------------+------------+
        | Name | Function                 | Equation                             | Units      |
        +------+--------------------------+--------------------------------------+------------+
        | EXP  | Exponential              | :math:`C1 * (runoff)^{C2}*(buildup)` | Mass/hour  |
        +------+--------------------------+--------------------------------------+------------+
        | RC   | Rating Curve             | :math:`C1 * (runoff)^{C2}`           | Mass/sec   |
        +------+--------------------------+--------------------------------------+------------+
        | EMC  | Event Mean Concentration | :math:`C1`                           | Mass/Liter |
        +------+--------------------------+--------------------------------------+------------+

        Each washoff function expresses its results in different units.

        For the Exponential function the runoff variable is expressed in catchment depth
        per unit of time (inches per hour or millimeters per hour), while for the Rating Curve
        function it is in whatever flow units were specified in the [``OPTIONS``] section (:class:`OptionSection`) of the
        input file (e.g., ``CFS``, ``CMS``, etc.).

        The buildup parameter in the Exponential function is the current total buildup over
        the subcatchment’s land use area in mass units. The units of C1 in the Exponential
        function are (in/hr)
        -C2 per hour (or (mm/hr) -C2 per hour). For the Rating Curve
        function, the units of ``C1`` depend on the flow units employed. For the EMC (event
        mean concentration) function, ``C1`` is always in concentration units.

    Attributes:
        land_use (str): Land use name.
        pollutant (str): Pollutant name.
        func_type: One of  ``EXP`` / ``RC`` / ``EMC`` (:attr:`WashOff.FUNCTIONS`).
        C1 (float): Washoff function coefficients (see Table).
        C2 (float): Washoff function coefficients (see Table).
        sweeping_removal (float): Street sweeping removal efficiency (percent) .
        BMP_removal (float): BMP removal efficiency (percent).

        FUNCTIONS: Enum-like for the attribute :attr:`WashOff.func_type` with following members -> {``EXP`` | ``RC`` | ``EMC``}

    See Also:
        :class:`~swmm_api.input_file.helpers.BaseSectionObject` : Abstract parent class of this one.
    """
    _identifier = (IDENTIFIERS.land_use, IDENTIFIERS.pollutant)
    _section_label = WASHOFF

    class FUNCTIONS:
        EXP = 'EXP'
        RC = 'RC'
        EMC = 'EMC'

    def __init__(self, land_use, pollutant, func_type, C1, C2, sweeping_removal, BMP_removal):
        """
        Washoff functions for pollutants and land uses.

        Args:
            land_use (str): Land use name.
            pollutant (str): Pollutant name.
            func_type: One of  ``EXP`` / ``RC`` / ``EMC`` (:attr:`WashOff.FUNCTIONS`).
            C1 (float): Washoff function coefficients (see Table D-3).
            C2 (float): Washoff function coefficients (see Table D-3).
            sweeping_removal (float): Street sweeping removal efficiency (percent) .
            BMP_removal (float): BMP removal efficiency (percent).
        """
        self.land_use = str(land_use)
        self.pollutant = str(pollutant)
        self.func_type = str(func_type)
        self.C1 = float(C1)
        self.C2 = float(C2)
        self.sweeping_removal = float(sweeping_removal)
        self.BMP_removal = float(BMP_removal)


class BuildUp(BaseSectionObject):
    r"""
    Buildup functions for pollutants and land uses.

    Section:
        [BUILDUP]

    Purpose:
        Specifies the rate at which pollutants build up over different land uses between rain events.

    Remarks:
        Buildup is measured in pounds (kilograms) per unit of area (or curb length) for
        pollutants whose concentration units are either mg/L or ug/L. If the concentration
        units are counts/L, then the buildup is expressed as counts per unit of area (or curb
        length).

        Table: Pollutant buildup functions (t is antecedent dry days)

        +---------+-------------+------------------------------+
        | Name    | Function    | Equation                     |
        +---------+-------------+------------------------------+
        | ``POW`` | Power       | :math:`Min (C1, C2*t^{C3} )` |
        +---------+-------------+------------------------------+
        | ``EXP`` | Exponential | :math:`C1*(1 – e^{-C2*t})`   |
        +---------+-------------+------------------------------+
        | ``SAT`` | Saturation  | :math:`\frac{C1*t}{C3 + t}`  |
        +---------+-------------+------------------------------+
        | ``EXT`` | External    | See below                    |
        +---------+-------------+------------------------------+

        For the ``EXT`` buildup function, ``C1`` is the maximum possible buildup (mass per area or
        curb length), ``C2`` is a scaling factor, and ``C3`` is the name of a Time Series that
        contains buildup rates (as mass per area or curb length per day) as a function of
        time.

    Attributes:
        land_use (str): Land use name.
        pollutant (str): Pollutant name.
        func_type: One of ``POW`` / ``EXP`` / ``SAT`` / ``EXT`` (:attr:`BuildUp.FUNCTIONS`).
        C1 (float): buildup function parameters (see Table).
        C2 (float): buildup function parameters (see Table).
        C3 (float): buildup function parameters (see Table).
        per_unit (str): ``AREA`` if buildup is per unit area, ``CURBLENGTH`` if per length of curb  (:attr:`BuildUp.UNIT`).

        FUNCTIONS: Enum-like for the attribute :attr:`BuildUp.func_type` with following members -> {``POW`` | ``EXP`` | ``SAT`` | ``EXT``}
        UNIT: Enum-like for the attribute :attr:`BuildUp.per_unit` with following members -> {``AREA`` | ``CURBLENGTH``}
    """
    _identifier = (IDENTIFIERS.land_use, IDENTIFIERS.pollutant)
    _section_label = BUILDUP

    class FUNCTIONS:
        POW = 'POW'
        EXP = 'EXP'
        SAT = 'SAT'
        EXT = 'EXT'

    class UNIT:
        AREA = 'AREA'
        CURBLENGTH = 'CURBLENGTH'
        # CURB = 'CURB'

    def __init__(self, land_use, pollutant, func_type, C1, C2, C3, per_unit):
        """
        Buildup functions for pollutants and land uses.

        Args:
            land_use (str): Land use name.
            pollutant (str): Pollutant name.
            func_type: One of ``POW`` / ``EXP`` / ``SAT`` / ``EXT`` (:attr:`BuildUp.FUNCTIONS`).
            C1 (float): buildup function parameters (see Table).
            C2 (float): buildup function parameters (see Table).
            C3 (float): buildup function parameters (see Table).
            per_unit (str): ``AREA`` if buildup is per unit area, ``CURBLENGTH`` if per length of curb  (:attr:`BuildUp.UNIT`).
        """
        self.land_use = str(land_use)
        self.pollutant = str(pollutant)
        self.func_type = str(func_type)
        self.C1 = float(C1)
        self.C2 = float(C2)
        self.C3 = float(C3)
        self.per_unit = per_unit


class SnowPack(BaseSectionObject):
    """
    Subcatchment snow pack parameters.

    Section:
        [SNOWPACKS]

    Purpose:
        Specifies parameters that govern how snowfall accumulates and melts on the
        plowable, impervious and pervious surfaces of subcatchments.

    Formats:
        ::

            Name PLOWABLE Cmin Cmax Tbase FWF SD0 FW0 SNN0
            Name IMPERVIOUS Cmin Cmax Tbase FWF SD0 FW0 SD100
            Name PERVIOUS Cmin Cmax Tbase FWF SD0 FW0 SD100
            Name REMOVAL Dplow Fout Fimp Fperv Fimelt (Fsub Scatch)

    Remarks:
        Use one set of ``PLOWABLE``, ``IMPERVIOUS``, and ``PERVIOUS`` lines for each snow pack
        parameter set created. Snow pack parameter sets are associated with specific
        subcatchments in the [``SUBCATCHMENTS``] section (:class:`SubCatchment`). Multiple subcatchments can share
        the same set of snow pack parameters.

        The ``PLOWABLE`` line contains parameters for the impervious area of a subcatchment
        that is subject to snow removal by plowing but not to areal depletion. This area is the
        fraction SNN0 of the total impervious area. The ``IMPERVIOUS`` line contains parameter
        values for the remaining impervious area and the ``PERVIOUS`` line does the same for
        the entire pervious area. Both of the latter two areas are subject to areal depletion.

        The ``REMOVAL`` line describes how snow removed from the plowable area is
        transferred onto other areas. The various transfer fractions should sum to no more
        than 1.0. If the line is omitted then no snow removal takes place.

    Attributes:
        name (str): Name assigned to snowpack parameter set.
        parts (dict): key = one of [``PLOWABLE``, ``IMPERVIOUS``, ``PERVIOUS``, ``REMOVAL``] and value = corresponding [``SnowPack.PARTS.Plowable``, ``SnowPack.PARTS.Pervious``, ``SnowPack.PARTS.Impervious``, ``SnowPack.PARTS.Removal``]
    """
    _identifier = IDENTIFIERS.name
    _section_label = SNOWPACKS
    _table_inp_export = False

    def __init__(self, name, parts=None):
        self.name = str(name)
        self.parts = {}

        if isinstance(parts, dict):
            self.parts = parts
        elif isinstance(parts, list):
            for p in parts:
                self.add_pack(p)
        elif parts is None:
            pass
        else:
            raise NotImplementedError(f'SnowPack packs type "{type(parts)}" not implemented!')

    def add_pack(self, p):
        if isinstance(p, self.PARTS._possible_types):
            self.parts[p._LABEL] = p

    @classmethod
    def _convert_lines(cls, multi_line_args):
        last = None

        for name, kind, *line in multi_line_args:
            # ---------------------------------
            if last is None:
                last = cls(name)

            elif name != last.name:
                yield last
                last = cls(name)

            kind = kind.upper()
            last.parts[kind] = cls.PARTS._dict[kind](*line)
        if last is not None:
            yield last

    class PARTS:
        class _Base(BaseSectionObject):
            _table_inp_export = False
            _identifier = IDENTIFIERS.name
            _section_label = SNOWPACKS

            def __init__(self, Cmin, Cmax, Tbase, FWF, SD0, FW0):
                """

                Args:
                    Cmin (float): Minimum melt coefficient (in/hr-deg F or mm/hr-deg C).
                    Cmax (float): Maximum melt coefficient (in/hr-deg F or mm/hr-deg C).
                    Tbase (float): Snow melt base temperature (deg F or deg C).
                    FWF (float): Ratio of free water holding capacity to snow depth (fraction).
                    SD0 (float): Initial snow depth (in or mm water equivalent).
                    FW0 (float): Initial free water in pack (in or mm).
                """
                self.Cmin = float(Cmin)
                self.Cmax = float(Cmax)
                self.Tbase = float(Tbase)
                self.FWF = float(FWF)
                self.SD0 = float(SD0)
                self.FW0 = float(FW0)

        class Plowable(_Base):
            _LABEL = 'PLOWABLE'

            def __init__(self, Cmin, Cmax, Tbase, FWF, SD0, FW0, SNN0):
                SnowPack.PARTS._Base.__init__(self, Cmin, Cmax, Tbase, FWF, SD0, FW0)
                self.SNN0 = float(SNN0)

        class Pervious(_Base):
            _LABEL = 'PERVIOUS'

            def __init__(self, Cmin, Cmax, Tbase, FWF, SD0, FW0, SD100):
                """
                ``PERVIOUS`` line.

                Args:
                    Cmin (float): Minimum melt coefficient (in/hr-deg F or mm/hr-deg C).
                    Cmax (float): Maximum melt coefficient (in/hr-deg F or mm/hr-deg C).
                    Tbase (float): Snow melt base temperature (deg F or deg C).
                    FWF (float): Ratio of free water holding capacity to snow depth (fraction).
                    SD0 (float): Initial snow depth (in or mm water equivalent).
                    FW0 (float): Initial free water in pack (in or mm).
                    SD100 (float): Snow depth above which there is 100% cover (in or mm water equivalent).
                """
                SnowPack.PARTS._Base.__init__(self, Cmin, Cmax, Tbase, FWF, SD0, FW0)
                self.SD100 = float(SD100)

        class Impervious(Pervious):
            _LABEL = 'IMPERVIOUS'

        class Removal(BaseSectionObject):
            _LABEL = 'REMOVAL'

            def __init__(self, Dplow, Fout, Fimp, Fperv, Fimelt, Fsub=np.nan, Scatch=np.nan):
                """
                The ``REMOVAL`` line describes how snow removed from the plowable area is
                transferred onto other areas. The various transfer fractions should sum to no more
                than 1.0. If the line is omitted then no snow removal takes place.

                Args:
                    Dplow (float): Depth of snow on plowable areas at which snow removal begins (in or mm).
                    Fout (float): Fraction of snow on plowable area transferred out of watershed.
                    Fimp (float): Fraction of snow on plowable area transferred to impervious area by plowing.
                    Fperv (float): Fraction of snow on plowable area transferred to pervious area by plowing.
                    Fimelt (float): Fraction of snow on plowable area converted into immediate melt.
                    Fsub (float): Fraction of snow on plowable area transferred to pervious area in another subcatchment.
                    Scatch (str): Name of subcatchment receiving the Fsub fraction of transferred snow.
                """
                self.Dplow = float(Dplow)
                self.Fout = float(Fout)
                self.Fimp = float(Fimp)
                self.Fperv = float(Fperv)
                self.Fimelt = float(Fimelt)
                self.Fsub = float(Fsub)
                self.Scatch = Scatch

        PLOWABLE = Plowable._LABEL
        IMPERVIOUS = Pervious._LABEL
        PERVIOUS = Impervious._LABEL
        REMOVAL = Removal._LABEL

        _possible_types = (Plowable, Pervious, Impervious, Removal)
        _possible = (PLOWABLE, PERVIOUS, IMPERVIOUS, REMOVAL)

        _dict = {x._LABEL: x for x in _possible_types}

    @property
    def plowable(self):
        return self.parts[self.PARTS.PLOWABLE]

    @property
    def impervious(self):
        return self.parts[self.PARTS.IMPERVIOUS]

    @property
    def pervious(self):
        return self.parts[self.PARTS.PERVIOUS]

    @property
    def removal(self):
        return self.parts[self.PARTS.REMOVAL]

    def to_inp_line(self):
        s = ''
        for pack in self.PARTS._possible:
            if self.parts[pack] is not None:
                s += f'{self.name} {pack:<8} {self.parts[pack].to_inp_line()}\n'
        return s


class Aquifer(BaseSectionObject):
    """
    Groundwater aquifer parameters.

    Section:
        [AQUIFERS]

    Purpose:
        Supplies parameters for each unconfined groundwater aquifer in the study area.
        Aquifers consist of two zones – a lower saturated zone and an upper unsaturated
        zone with a moving boundary between the two.

    Remarks:
        Local values for :attr:`Aquifer.Ebot`, :attr:`Aquifer.Egw`, and :attr:`Aquifer.Umc` can be assigned to specific subcatchments in
        the [``GROUNDWATER``] section (:class:`Groundwater`) described below.

    Attributes:
        name (str): name assigned to aquifer.
        Por (float): soil porosity (volumetric fraction).
        WP (float): soil wilting point (volumetric fraction).
        FC (float): soil field capacity (volumetric fraction).
        Ks (float): saturated hydraulic conductivity (in/hr or mm/hr).
        Kslp (float): slope of the logarithm of hydraulic conductivity versus moisture deficit (i.e., porosity minus
            moisture content) curve (in/hr or mm/hr).
        Tslp (float): slope of soil tension versus moisture content curve (inches or mm).
        ETu (float): fraction of total evaporation available for evapotranspiration in the upper unsaturated zone.
        ETs (float): maximum depth into the lower saturated zone over which evapotranspiration can occur (ft or m).
        Seep (float): seepage rate from saturated zone to deep groundwater when water table is at ground surface (
            in/hr or mm/hr).
        Ebot (float): elevation of the bottom of the aquifer (ft or m).
        Egw (float): groundwater table elevation at start of simulation (ft or m).
        Umc (float): unsaturated zone moisture content at start of simulation (volumetric fraction).
        pattern (float): name of optional monthly time pattern used to adjust the upper zone evaporation
            fraction for different months of the year.
    """
    _identifier = IDENTIFIERS.name
    _section_label = AQUIFERS

    def __init__(self, name, Por, WP, FC, Ks, Kslp, Tslp, ETu, ETs, Seep, Ebot, Egw, Umc, pattern=np.nan):
        """
        Groundwater aquifer parameters.

        Args:
            name (str): name assigned to aquifer.
            Por (float): soil porosity (volumetric fraction).
            WP (float): soil wilting point (volumetric fraction).
            FC (float): soil field capacity (volumetric fraction).
            Ks (float): saturated hydraulic conductivity (in/hr or mm/hr).
            Kslp (float): slope of the logarithm of hydraulic conductivity versus moisture deficit (i.e.,
                porosity minus moisture content) curve (in/hr or mm/hr).
            Tslp (float): slope of soil tension versus moisture content curve (inches or mm).
            ETu (float): fraction of total evaporation available for evapotranspiration in the upper unsaturated zone.
            ETs (float): maximum depth into the lower saturated zone over which evapotranspiration can occur (ft or m).
            Seep (float): seepage rate from saturated zone to deep groundwater when water table is at ground surface
                (in/hr or mm/hr).
            Ebot (float): elevation of the bottom of the aquifer (ft or m).
            Egw (float): groundwater table elevation at start of simulation (ft or m).
            Umc (float): unsaturated zone moisture content at start of simulation (volumetric fraction).
            pattern (str, Optional): name of optional monthly time pattern used to adjust the upper zone
                evaporation fraction for different months of the year.
        """
        self.name = str(name)
        self.Por = float(Por)
        self.WP = float(WP)
        self.FC = float(FC)
        self.Ks = float(Ks)
        self.Kslp = float(Kslp)
        self.Tslp = float(Tslp)
        self.ETu = float(ETu)
        self.ETs = float(ETs)
        self.Seep = float(Seep)
        self.Ebot = float(Ebot)
        self.Egw = float(Egw)
        self.Umc = float(Umc)
        self.pattern = convert_string(pattern)
