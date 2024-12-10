from numpy import nan, isnan

from ._identifiers import IDENTIFIERS
from .._type_converter import convert_string, get_gis_inp_decimals
from ..helpers import BaseSectionObject, InpSectionGeo
from ..section_labels import DWF, INFLOWS, COORDINATES, RDII, TREATMENT


class DryWeatherFlow(BaseSectionObject):
    """
    Baseline dry weather sanitary inflow at nodes.

    Section:
        [DWF]

    Purpose:
        Specifies dry weather flow and its quality entering the drainage system at specific nodes.

    Remarks:
        Names of up to four time patterns appearing in the [``PATTERNS``] section (:class:`Pattern`).

        The actual dry weather input will equal the product of the baseline value and any adjustment factors
        supplied by the specified patterns. (If not supplied, an adjustment factor defaults to 1.0.)
        The patterns can be any combination of monthly, daily, hourly and weekend hourly
        patterns, listed in any order. See the [PATTERNS] section for more details.

    Attributes:
        node (str): name of node where dry weather flow enters.
        constituent (str): keyword ``FLOW`` for flow or pollutant name for quality constituent. ``Type``
        base_value (float): average baseline value for corresponding constituent (flow or concentration units).
        pattern1 (str, Optional): Names of a time pattern in the [``PATTERNS``] section (:class:`Pattern`).
        pattern2 (str, Optional): Names of a time pattern in the [``PATTERNS``] section (:class:`Pattern`).
        pattern3 (str, Optional): Names of a time pattern in the [``PATTERNS``] section (:class:`Pattern`).
        pattern4 (str, Optional): Names of a time pattern in the [``PATTERNS``] section (:class:`Pattern`).
    """
    _identifier = (IDENTIFIERS.node, IDENTIFIERS.constituent)
    _section_label = DWF

    class TYPES:
        FLOW = 'FLOW'

    def __init__(self, node, constituent, base_value, pattern1=nan, pattern2=nan, pattern3=nan, pattern4=nan, *_patterns):
        """
        Baseline dry weather sanitary inflow at nodes.

        Args:
            node (str): name of node where dry weather flow enters.
            constituent (str): keyword ``FLOW`` for flow or pollutant name for quality constituent. ``Type``
            base_value (float): average baseline value for corresponding constituent (flow or concentration units).
            pattern1 (str, Optional): Names of a time pattern in the [``PATTERNS``] section (:class:`Pattern`).
            pattern2 (str, Optional): Names of a time pattern in the [``PATTERNS``] section (:class:`Pattern`).
            pattern3 (str, Optional): Names of a time pattern in the [``PATTERNS``] section (:class:`Pattern`).
            pattern4 (str, Optional): Names of a time pattern in the [``PATTERNS``] section (:class:`Pattern`).
            *_patterns: if more than 4 patterns are defined, swmm will not run to an error, but will ignore these patterns.
        """
        self.node = str(node)
        self.constituent = str(constituent)
        self.base_value = float(base_value)
        self.pattern1 = convert_string(pattern1)
        self.pattern2 = convert_string(pattern2)
        self.pattern3 = convert_string(pattern3)
        self.pattern4 = convert_string(pattern4)

    def get_pattern_list(self):
        return [self[p] for p in ['pattern1', 'pattern2', 'pattern3', 'pattern4'] if isinstance(self[p], str)]


class Inflow(BaseSectionObject):
    """
    External hydrograph/pollutograph inflow at nodes.

    Section:
        [INFLOWS]

    Purpose:
        Specifies external hydrographs and pollutographs that enter the drainage system at specific nodes.

    Remarks:
        External inflows are represented by both a constant and time varying component as follows:

            Inflow = (Baseline value)*(Pattern factor) + (Scaling factor)*(Time series value)

        If an external inflow of a pollutant concentration is specified for a node,
        then there must also be an external inflow of ``FLOW`` provided for the same node, unless the node is an Outfall.
        In that case a pollutant can enter the system during periods
        when the outfall is submerged and reverse flow occurs.
        External pollutant mass inflows do not require a ``FLOW`` inflow.

    Examples in the .inp-file:
        ::

            NODE2  FLOW N2FLOW
            NODE33 TSS  N33TSS CONCEN

            ;Mass inflow of BOD in time series N65BOD given in lbs/hr ;(126 converts lbs/hr to mg/sec)
            NODE65 BOD N65BOD MASS 126
            ;Flow inflow with baseline and scaling factor
            N176 FLOW FLOW_176 FLOW 1.0 0.5 12.7 FlowPat


    Attributes:
        node (str): name of node where external inflow enters.
        constituent (str): ``FLOW`` or name of pollutant (:attr:`Pollutant.name`).
        time_series (str): name of time series in [``TIMESERIES``] section (:class:`Timeseries`) describing how external flow or pollutant loading varies with time.
        kind (str): ``FLOW`` or ``CONCEN`` if pollutant inflow is described as a concentration, ``MASS`` if it is described as a mass flow rate (default is ``CONCEN``). (see :attr:`Inflow.TYPES`)
        mass_unit_factor (float): the factor that converts the inflow’s mass flow rate units into the project’s mass units per second, where the project’s mass units are those specified for the pollutant in the [``POLLUTANTS``] section (:class:`Pollutant`) (default is 1.0).
        scale_factor (float): scaling factor that multiplies the recorded time series values (default is 1.0).
        base_value (float): constant baseline value added to the time series value (default is 0.0).
        pattern (str): name of optional time pattern in [``PATTERNS``] section (:class:`Pattern`) used to adjust the baseline value on a periodic basis.

        TYPES: Enum-like for the attribute :attr:`Inflow.kind` with following members -> {``FLOW`` | ``CONCEN`` | ``MASS``}
    """
    _identifier = (IDENTIFIERS.node, IDENTIFIERS.constituent)
    _section_label = INFLOWS

    class TYPES:
        FLOW = 'FLOW'
        CONCEN = 'CONCEN'
        MASS = 'MASS'

    def __init__(self, node, constituent=TYPES.FLOW, time_series=None, kind=TYPES.FLOW, mass_unit_factor=1.0,
                 scale_factor=1.0, base_value=0., pattern=nan):
        """
        External hydrograph/pollutograph inflow at nodes.

        Args:
            node (str): name of node where external inflow enters.
            constituent (str): ``'FLOW'`` or name of pollutant (:attr:`Pollutant.name`).
            time_series (str): name of time series in [``TIMESERIES``] section (:class:`Timeseries`) describing how external flow or pollutant loading varies with time.
            kind (str): ``FLOW`` or ``CONCEN`` if pollutant inflow is described as a concentration, ``MASS`` if it is described as a mass flow rate (default is ``CONCEN``). (see :attr:`Inflow.TYPES`)
            mass_unit_factor (float): the factor that converts the inflow’s mass flow rate units into the project’s mass units persecond, where the project’s mass units are those specified for the pollutant in the [``POLLUTANTS``] section (:class:`Pollutant`) (default is 1.0).
            scale_factor (float): scaling factor that multiplies the recorded time series values (default is 1.0).
            base_value (float): constant baseline value added to the time series value (default is 0.0).
            pattern (str): name of optional time pattern in [``PATTERNS``] section (:class:`Pattern`) used to adjust the baseline value on a periodic basis.
        """
        self.node = str(node)
        self.constituent = str(constituent)
        if self.constituent.upper() == self.TYPES.FLOW:
            self.constituent = self.constituent.upper()
        self.time_series = time_series
        self.kind = str(kind)
        self.mass_unit_factor = float(mass_unit_factor)
        self.scale_factor = float(scale_factor)
        self.base_value = float(base_value)
        self.pattern = convert_string(pattern)

        if (time_series is None) or (time_series == ''):
            self.time_series = '""'


class Coordinate(BaseSectionObject):
    """
    X,Y coordinates for nodes.

    Section:
        [COORDINATES]

    Purpose:
        Assigns X,Y coordinates to drainage system nodes.

    Attributes:
        node (str): name of node.
        x (float): horizontal coordinate relative to origin in lower left of map.
        y (float): vertical coordinate relative to origin in lower left of map.
    """
    _identifier = IDENTIFIERS.node
    _section_label = COORDINATES
    _section_class = InpSectionGeo

    def __init__(self, node, x, y):
        """
        X,Y coordinates for nodes.

        Args:
            node (str): name of node.
            x (float): horizontal coordinate relative to origin in lower left of map.
            y (float): vertical coordinate relative to origin in lower left of map.
        """
        self.node = str(node)
        self.x = float(x)
        self.y = float(y)

    @property
    def point(self):
        return self.x, self.y

    def to_inp_line(self):
        # separate function to keep accuracy
        return f'{self.node} {self.x:0.{get_gis_inp_decimals()}f} {self.y:0.{get_gis_inp_decimals()}f}'

    @property
    def geo(self):
        """
        get the shapely representation for the object (Point).

        Returns:
            shapely.geometry.Point: point object for the coordinates.
        """
        import shapely.geometry as shp
        return shp.Point(self.point)

    @classmethod
    def create_section_from_geoseries(cls, data):
        """
        create a COORDINATES inp-file section for a geopandas.GeoSeries

        Args:
            data (geopandas.GeoSeries): geopandas.GeoSeries of coordinates

        Returns:
            InpSectionGeo: COORDINATES inp-file section
        """
        return cls.create_section(zip(data.index, data.x, data.y))

    @classmethod
    def from_shapely(cls, node, point):
        """
        Create a Coordinate object with a shapely Point

        Args:
            node (str): label of the node
            point (shapely.geometry.Point):

        Returns:
            Coordinate: Coordinate object
        """
        return cls(node, point.x, point.y)


class RainfallDependentInfiltrationInflow(BaseSectionObject):
    """
    Rainfall-dependent I/I information at nodes.

    Section:
        [RDII]

    Purpose:
        Specifies the parameters that describe rainfall-dependent infiltration/inflow (RDII)
        entering the drainage system at specific nodes.

    Attributes:
        node (str): name of node.
        hydrograph (str): name of an RDII unit hydrograph group specified in the [``HYDROGRAPHS``] section.
        sewer_area (float): area of the sewershed which contributes RDII to the node (acres or hectares).
    """
    _identifier = IDENTIFIERS.node
    _section_label = RDII

    def __init__(self, node, hydrograph, sewer_area):
        """
        Rainfall-dependent I/I information at nodes.

        Args:
            node (str): name of node.
            hydrograph (str): name of an RDII unit hydrograph group specified in the [``HYDROGRAPHS``] section.
            sewer_area (float): area of the sewershed which contributes RDII to the node (acres or hectares).
        """
        self.node = str(node)
        self.hydrograph = str(hydrograph)
        self.sewer_area = float(sewer_area)


class Treatment(BaseSectionObject):
    r"""
    Pollutant removal functions at conveyance system nodes.

    Section:
        [TREATMENT]

    Purpose:
        Specifies the degree of treatment received by pollutants at specific nodes of the drainage system.

    Format:
        ::

            Node Pollut Result = Func


    Attributes:
        node (str): Name of node where treatment occurs.
        pollutant (str): Name of pollutant receiving treatment.
        result (str): Result computed by treatment function. Choices are C (function computes effluent concentration)
            R (function computes fractional removal).
        function (str): mathematical function expressing treatment result in terms of pollutant concentrations,
            pollutant removals, and other standard variables (see below).

    Remarks:
        Treatment functions can be any well-formed mathematical expression involving:
            - inlet pollutant concentrations (use the pollutant name to represent a concentration)
            - removal of other pollutants (use R\_ pre-pended to the pollutant name to represent removal)
            - process variables which include:
                - FLOW for flow rate into node (user’s flow units)
                - DEPTH for water depth above node invert (ft or m)
                - AREA for node surface area (ft2 or m2)
                - DT for routing time step (seconds)
                - HRT for hydraulic residence time (hours)

        Any of the following math functions can be used in a treatment function:
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

        along with the standard operators +, -, \*, /, ^ (for exponentiation ) and any level of nested parentheses.

    Examples:
        ::

            ; 1-st order decay of BOD
            Node23 BOD C = BOD * exp(-0.05*HRT)
            ; lead removal is 20% of TSS removal
            Node23 Lead R = 0.2 * R_TSS
    """
    _identifier = (IDENTIFIERS.node, IDENTIFIERS.pollutant)
    _section_label = TREATMENT
    _table_inp_export = False

    def __init__(self, node, pollutant, result, function):
        """
        Pollutant removal functions at conveyance system nodes.

        Args:
            node (str): Name of node where treatment occurs.
            pollutant (str): Name of pollutant receiving treatment.
            result (str): Result computed by treatment function. Choices are C (function computes effluent concentration)
                R (function computes fractional removal).
            function (str): mathematical function expressing treatment result in terms of pollutant concentrations,
                pollutant removals, and other standard variables (see below).
        """
        self.node = str(node)
        self.pollutant = str(pollutant)
        self.result = str(result)
        self.function = str(function)

    @classmethod
    def _convert_lines(cls, multi_line_args):
        for name, pollutant, *line in multi_line_args:
            result, function = ' '.join(line).split('=')
            yield cls(name, pollutant, result, function)

    def to_inp_line(self):
        """
        convert object to one line of the ``.inp``-file

        for ``.inp``-file writing

        Returns:
            str: SWMM .inp file compatible string
        """
        return f'{self.node} {self.pollutant} {self.result} = {self.function}'
