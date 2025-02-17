import warnings
import io
import numpy as np
import pandas as pd

from .._type_converter import get_gis_inp_decimals
from ..helpers import BaseSectionObject, InpSectionGeo
from ._identifiers import IDENTIFIERS
from ..section_labels import SUBCATCHMENTS, SUBAREAS, INFILTRATION, POLYGONS, LOADINGS, COVERAGES, GWF, GROUNDWATER
from ..._io_helpers import CONFIG


class SubCatchment(BaseSectionObject):
    """
    Basic subcatchment information.

    Section:
        [SUBCATCHMENTS]

    Purpose:
        Identifies each sub-catchment within the study area. Subcatchments are land area
        units which generate runoff from rainfall.

    Attributes:
        name (str): Name assigned to subcatchment.
        rain_gage (str): Name of rain gage in [``RAINGAGES``] section (:class:`~swmm_api.input_file.sections.RainGage`) assigned to subcatchment.
        outlet (str): Name of node or subcatchment that receives runoff from subcatchment.
        area (float): Area of subcatchment (acres or hectares).
        imperviousness (float): Percent imperviousness of subcatchment.
        width (float): Characteristic width of subcatchment (ft or meters).
        slope (float): Subcatchment slope (percent).
        curb_length (float): Total curb length (any length units). Use 0 if not applicable.
        snow_pack (str): Optional name of snow pack object (from [``SNOWPACKS``] section) that characterizes snow accumulation and melting over the subcatchment.
    """
    _identifier = IDENTIFIERS.name
    _section_label = SUBCATCHMENTS

    def __init__(self, name, rain_gage, outlet, area, imperviousness, width, slope, curb_length=0, snow_pack=np.nan):
        """
        Basic subcatchment information.

        Args:
            name (str): Name assigned to subcatchment.
            rain_gage (str): Name of rain gage in [``RAINGAGES``] section (:class:`~swmm_api.input_file.sections.RainGage`) assigned to subcatchment.
            outlet (str): Name of node or subcatchment that receives runoff from subcatchment.
            area (float): Area of subcatchment (acres or hectares).
            imperviousness (float): Percent imperviousness of subcatchment.
            width (float): Characteristic width of subcatchment (ft or meters).
            slope (float): Subcatchment slope (percent).
            curb_length (float): Total curb length (any length units). Use 0 if not applicable.
            snow_pack (str): Optional name of snow pack object (from [``SNOWPACKS``] section) that characterizes snow
                accumulation and melting over the subcatchment.
        """
        self.name = str(name)
        self.rain_gage = str(rain_gage)
        self.outlet = str(outlet)
        self.area = float(area)
        self.imperviousness = float(imperviousness)
        self.width = float(width)
        self.slope = float(slope)
        self.curb_length = float(curb_length)
        self.snow_pack = snow_pack


class SubArea(BaseSectionObject):
    """
    Subcatchment impervious/pervious subarea data.

    Section:
        [SUBAREAS]

    Purpose:
        Supplies information about pervious and impervious areas for each subcatchment.
        Each subcatchment can consist of a pervious sub-area, an impervious sub-area with
        depression storage, and an impervious sub-area without depression storage.

    Attributes:
        subcatchment (str): Subcatchment name.
        n_imperv (float): Manning's n (coefficient) for overland flow over the impervious sub-area (in s*m^(-1/3)).
        n_perv (float): Manning's n (coefficient) for overland flow over the pervious sub-area (in s*m^(-1/3)).
        storage_imperv (float): depression storage for impervious sub-area (inches or mm).
        storage_perv (float): depression storage for pervious sub-area (inches or mm).
        pct_zero (float): percent of impervious area with no depression storage.
        route_to (str):

            - ``IMPERVIOUS`` if pervious area runoff runs onto impervious area,
            - ``PERVIOUS`` if impervious runoff runs onto pervious area,
            - ``OUTLET`` if both areas drain to the subcatchment's outlet (default = ``OUTLET``).

        pct_routed (float): percent of runoff routed from one type of area to another (default = 100).
    """
    _identifier = IDENTIFIERS.subcatchment
    _section_label = SUBAREAS

    class RoutToOption:
        __class__ = 'RoutTo Option'
        IMPERVIOUS = 'IMPERVIOUS'
        PERVIOUS = 'PERVIOUS'
        OUTLET = 'OUTLET'

    def __init__(self, subcatchment, n_imperv, n_perv, storage_imperv, storage_perv, pct_zero, route_to=RoutToOption.OUTLET,
                 pct_routed=100):
        """
        Subcatchment impervious/pervious subarea data.

        Args:
            subcatchment (str): Subcatchment name.
            n_imperv (float): Manning's n (coefficient) for overland flow over the impervious sub-area (in s*m^(-1/3)).
            n_perv (float): Manning's n (coefficient) for overland flow over the pervious sub-area (in s*m^(-1/3)).
            storage_imperv (float): depression storage for impervious sub-area (inches or mm).
            storage_perv (float): depression storage for pervious sub-area (inches or mm).
            pct_zero (float): percent of impervious area with no depression storage.
            route_to (str):

                - ``IMPERVIOUS`` if pervious area runoff runs onto impervious area,
                - ``PERVIOUS`` if impervious runoff runs onto pervious area,
                - ``OUTLET`` if both areas drain to the subcatchment's outlet (default = ``OUTLET``).

            pct_routed (float): percent of runoff routed from one type of area to another (default = 100).
        """
        self.subcatchment = str(subcatchment)
        self.n_imperv = float(n_imperv)
        self.n_perv = float(n_perv)
        self.storage_imperv = float(storage_imperv)
        self.storage_perv = float(storage_perv)
        self.pct_zero = float(pct_zero)
        self.route_to = str(route_to)
        self.pct_routed = float(pct_routed)


class Infiltration(BaseSectionObject):
    """
    Subcatchment infiltration parameters.

    ABSTRACT parent class. Use child classes!

    Section:
        [INFILTRATION]

    Purpose:
        Supplies infiltration parameters for each subcatchment.
        Rainfall lost to infiltration only occurs over the pervious sub-area of a subcatchment.

    Formats:
        ::

            Subcat MaxRate MinRate Decay DryTime MaxInf (Method)
            Subcat Psi Ksat IMD (Method)
            Subcat CurveNo Ksat DryTime (Method)

    Attributes:
        subcatchment (str): Subcatchment name.

    See Also:
        - :class:`InfiltrationHorton` : child class of this one.
        - :class:`InfiltrationGreenAmpt` : child class of this one.
        - :class:`InfiltrationCurveNumber` : child class of this one.
    """
    _identifier = IDENTIFIERS.subcatchment
    _section_label = INFILTRATION

    _table_inp_export = True  # due to possible mixed objects

    # jetbrains://clion/navigate/reference?project=Swmm5&path=src/infil.c : 133
    # infil_readParams

    class TYPES:
        HORTON = 'HORTON'
        MODIFIED_HORTON = 'MODIFIED_HORTON'
        GREEN_AMPT = 'GREEN_AMPT'
        MODIFIED_GREEN_AMPT = 'MODIFIED_GREEN_AMPT'
        CURVE_NUMBER = 'CURVE_NUMBER'

    _CONVERSION_DICT = {}

    def __init__(self, subcatchment):
        """
        Subcatchment infiltration parameters.

        Args:
            subcatchment (str): Subcatchment name.
        """
        self.subcatchment = str(subcatchment)

    @classmethod
    def from_inp_line(cls, subcatchment, *args, **kwargs):
        """
        Convert line in the ``.inp``-file to the respective Infiltration object.

        Args:
            subcatchment (str): Subcatchment name.
            *args (list[str]): arguments in the line
            **kwargs (dict): keyword arguments for the respective init-function of the object.

        Returns:
            BaseSectionObject: object of the ``.inp``-file section
        """
        sub_cls = cls

        # n_args = len(args) + len(kwargs.keys()) + 1
        # if n_args == 6:  # hortn
        #     sub_cls = InfiltrationHorton
        # elif n_args == 4:
        #     sub_cls = cls

        # _____________________________________
        sub_class_id = None
        if (CONFIG.swmm_version == '5.1.015') or CONFIG.swmm_version.startswith('5.2.'):
            # NEU in swmm 5.1.015
            last_arg = args[-1]
            if last_arg in Infiltration._CONVERSION_DICT:
                sub_class_id = last_arg
                sub_cls = Infiltration._CONVERSION_DICT[last_arg]
                # args = args[:-1]

        if sub_cls != InfiltrationHorton:
            args = args[:3]  # sometimes there is an additional 0 in the line, which is ignored by swmm and the EPA GUI.

        # _____________________________________
        o = sub_cls(subcatchment, *args, **kwargs)
        # _____________________________________
        if sub_class_id is not None:  # swmm version > 5.1.015
            o.kind = sub_class_id
        return o


class InfiltrationHorton(Infiltration):
    """
    Subcatchment infiltration parameters for the (modified) Horton method.

    Section:
        [INFILTRATION]

    Purpose:
        Supplies infiltration parameters for each subcatchment.
        Rainfall lost to infiltration only occurs over the pervious sub-area of a subcatchment.

    Attributes:
        subcatchment (str): Subcatchment name.
        rate_max (float): Maximum infiltration rate on Horton curve (in/hr or mm/hr).
        rate_min (float): Minimum infiltration rate on Horton curve (in/hr or mm/hr).
        decay (float): Decay rate constant of Horton curve (1/hr).
        time_dry (float): Time it takes for fully saturated soil to dry (days).
        volume_max (float): Maximum infiltration volume possible (0 if not applicable) (in or mm).
        kind (str, Optional): Method to use -> ``HORTON`` or ``MODIFIED_HORTON`` (new in 5.1.015).

    See Also:
        - :class:`Infiltration`: Abstract parent class of this one.
        - :class:`InfiltrationGreenAmpt`: Child class of this one.
        - :class:`InfiltrationCurveNumber`: Child class of this one.
    """

    def __init__(self, subcatchment, rate_max, rate_min, decay, time_dry, volume_max, kind=None):
        """
        Subcatchment infiltration parameters for the (modified) Horton method.

        Args:
            subcatchment (str): Subcatchment name.
            rate_max (float): Maximum infiltration rate on Horton curve (in/hr or mm/hr).
            rate_min (float): Minimum infiltration rate on Horton curve (in/hr or mm/hr).
            decay (float): Decay rate constant of Horton curve (1/hr).
            time_dry (float): Time it takes for fully saturated soil to dry (days).
            volume_max (float): Maximum infiltration volume possible (0 if not applicable) (in or mm).
            kind (str, Optional): Method to use -> ``HORTON`` or ``MODIFIED_HORTON`` (new in 5.1.015).
        """
        Infiltration.__init__(self, subcatchment)
        self.rate_max = float(rate_max)
        self.rate_min = float(rate_min)
        self.decay = float(decay)
        self.time_dry = float(time_dry)
        self.volume_max = float(volume_max)
        self.kind = np.nan if kind is None else kind


class InfiltrationGreenAmpt(Infiltration):
    """
    Subcatchment infiltration parameters for the (modified) Green-Ampt method.
    
    Section:
        [INFILTRATION]

    Purpose:
        Supplies infiltration parameters for each subcatchment.
        Rainfall lost to infiltration only occurs over the pervious sub-area of a subcatchment.

    Attributes:
        subcatchment (str): Subcatchment name.
        suction_head (float): Soil suction head (inches or mm).
        hydraulic_conductivity (float): Soil saturated hydraulic conductivity (in/hr or mm/hr).
        moisture_deficit_init (float): Soil initial moisture deficit (porosity minus moisture content) (fraction).
        kind (str, Optional): Method to use -> ``GREEN_AMPT`` or ``MODIFIED_GREEN_AMPT`` (new in 5.1.015).

    See Also:
        - :class:`Infiltration`: Abstract parent class of this one.
        - :class:`InfiltrationHorton`: Child class of this one.
        - :class:`InfiltrationCurveNumber`: Child class of this one.
    """

    def __init__(self, subcatchment, suction_head, hydraulic_conductivity, moisture_deficit_init, kind=None):
        """
        Subcatchment infiltration parameters for the (modified) Green-Ampt method.
        
        Args:
            subcatchment (str): Subcatchment name.
            suction_head (float): Soil suction head (inches or mm). Average value of soil capillary suction along the wetting front (inches or mm).
            hydraulic_conductivity (float): Soil saturated hydraulic conductivity (in/hr or mm/hr).
            moisture_deficit_init (float): Soil initial moisture deficit (porosity minus moisture content) (fraction).
            kind (str, Optional): Method to use -> ``GREEN_AMPT`` or ``MODIFIED_GREEN_AMPT`` (new in 5.1.015).

        Initial Deficit:
            Fraction of soil volume that is initially dry (i.e., difference between soil porosity and initial moisture content).
            For a completely drained soil, it is the difference between the soil's porosity and its field capacity.
            Typical values for all of these parameters can be found in the Soil Characteristics Table in Section
            A.2.
        """
        Infiltration.__init__(self, subcatchment)
        self.suction_head = float(suction_head)
        self.hydraulic_conductivity = float(hydraulic_conductivity)
        self.moisture_deficit_init = float(moisture_deficit_init)
        self.kind = np.nan if kind is None else kind


class InfiltrationCurveNumber(Infiltration):
    """
    Subcatchment infiltration parameters for the Curve-Number method.

    Section:
        [INFILTRATION]

    Purpose:
        Supplies infiltration parameters for each subcatchment.
        Rainfall lost to infiltration only occurs over the pervious sub-area of a subcatchment.

    Attributes:
        subcatchment (str): Subcatchment name.
        curve_no: SCS Curve Number.
        hydraulic_conductivity (float): Soil saturated hydraulic conductivity (in/hr or mm/hr)
            (This property has been deprecated and is no longer used.)
        time_dry (float): Time it takes for fully saturated soil to dry (days).
        kind (str, Optional): Method to use -> ``CURVE_NUMBER`` (new in 5.1.015).

    See Also:
        - :class:`Infiltration`: Abstract parent class of this one.
        - :class:`InfiltrationHorton`: Child class of this one.
        - :class:`InfiltrationGreenAmpt`: Child class of this one.
    """

    def __init__(self, subcatchment, curve_no, hydraulic_conductivity, time_dry, kind=None):
        """
        Subcatchment infiltration parameters for the Curve-Number method.

        Args:
            subcatchment (str): Subcatchment name.
            curve_no: SCS Curve Number.
            hydraulic_conductivity (float): Soil saturated hydraulic conductivity (in/hr or mm/hr)
                (This property has been deprecated and is no longer used.)
            time_dry (float): Time it takes for fully saturated soil to dry (days).
            kind (str, Optional): Method to use -> ``CURVE_NUMBER`` (new in 5.1.015).
        """
        Infiltration.__init__(self, subcatchment)
        self.curve_no = curve_no
        self.hydraulic_conductivity = float(hydraulic_conductivity)
        self.time_dry = float(time_dry)
        self.kind = np.nan if kind is None else Infiltration.TYPES.CURVE_NUMBER


Infiltration._CONVERSION_DICT = {
    Infiltration.TYPES.HORTON             : InfiltrationHorton,
    Infiltration.TYPES.MODIFIED_HORTON    : InfiltrationHorton,
    Infiltration.TYPES.GREEN_AMPT         : InfiltrationGreenAmpt,
    Infiltration.TYPES.MODIFIED_GREEN_AMPT: InfiltrationGreenAmpt,
    Infiltration.TYPES.CURVE_NUMBER       : InfiltrationCurveNumber
}


class Polygon(BaseSectionObject):
    """
    X,Y coordinates for each vertex of subcatchment polygons.

    Section:
        [POLYGONS]

    Purpose:
        Assigns X,Y coordinates to vertex points of polygons that define a subcatchment boundary.

    Remarks:
        Include a separate line for each vertex of the subcatchment polygon, ordered in a
        consistent clockwise or counter-clockwise sequence.

    Attributes:
        subcatchment (str): Name of subcatchment.
        polygon (list[list[float,float]]): List of the polygon points as coordinate tuple (x, y) relative to origin in lower left of map.
    """
    _identifier = IDENTIFIERS.subcatchment
    _table_inp_export = False
    _section_label = POLYGONS
    _section_class = InpSectionGeo

    def __init__(self, subcatchment, polygon):
        """
        X,Y coordinates for each vertex of subcatchment polygons.

        Args:
            subcatchment (str): Name of subcatchment.
            polygon (list[list[float,float]]): List of the polygon points as coordinate tuple (x, y) relative to origin in lower left of map.

        Notes:
            If a polygon has more than 1000 points,  it is cropped in the EPA user interface.
        """
        self.subcatchment = str(subcatchment)
        self.polygon = polygon

    @classmethod
    def _prepare_convert_lines(cls, lines):
        return lines

    @classmethod
    def _convert_lines(cls, multi_line_args):
        if isinstance(multi_line_args, str) and multi_line_args == '':
            return ()

        with warnings.catch_warnings():
            warnings.filterwarnings(
                action='ignore',
                message='.*loadtxt: input contained no data*', category=UserWarning)
            a = np.loadtxt(io.StringIO(multi_line_args), comments=';',
                           dtype={'names': ('polygon', 'x', 'y'),
                                  'formats': ('O', 'f4', 'f4')})

        if a.size == 0:
            return ()

        _, unique_index = np.unique(a['polygon'], return_index=True)
        unique_index_sorted = unique_index[unique_index.argsort()]

        for sc in np.split(a, unique_index_sorted[1:]):
            yield cls(sc['polygon'][0], sc[['x', 'y']].tolist())

        # polygon = []
        # last = None
        #
        # for line in multi_line_args:
        #     Subcatch, x, y = line
        #     x = float(x)
        #     y = float(y)
        #     if Subcatch == last:
        #         polygon.append([x, y])
        #     else:
        #         if last is not None:
        #             yield cls(last, polygon)
        #         last = Subcatch
        #         polygon = [[x, y]]
        # # last
        # if last is not None:
        #     yield cls(last, polygon)

    @property
    def frame(self):
        return pd.DataFrame.from_records(self.polygon, columns=['x', 'y'])

    def to_inp_line(self):
        return '\n'.join([f'{self.subcatchment}  {x:0.{get_gis_inp_decimals()}f} {y:0.{get_gis_inp_decimals()}f}' for x, y in self.polygon])

    @property
    def geo(self):
        """
        get the shapely representation for the object (Polygon).

        Returns:
            shapely.geometry.Polygon: LineString object for the polygon.
        """
        import shapely.geometry as shp
        return shp.Polygon(self.polygon)

    @classmethod
    def create_section_from_geoseries(cls, data):
        """
        create a POLYGONS inp-file section for a geopandas.GeoSeries

        Warnings:
            Only uses the exterior coordinates and ignoring all interiors.

        Args:
            data (geopandas.GeoSeries): geopandas.GeoSeries of polygons

        Returns:
            InpSectionGeo: POLYGONS inp-file section
        """
        s = cls.create_section()
        has_interiors = data.interiors.apply(len) > 0
        if has_interiors.any():
            warnings.warn('Converting GeoSeries with Interiors(Holes) to POLYGON inp-section will ignore this interiors!')
        # s.add_multiple(cls(i, [xy[0:2] for xy in list(p.coords)]) for i, p in data.exterior.items())
        s.add_multiple(cls.from_shapely(i, p) for i, p in data.items())
        return s

    @classmethod
    def from_shapely(cls, subcatchment, polygon):
        """
        Create a Polygon object with a shapely Polygon.

        Args:
            subcatchment (str): Name of the subcatchment
            polygon (shapely.geometry.Polygon):

        Returns:
            Polygon: Polygon object
        """
        return cls(subcatchment, cls.convert_shapely(polygon))

    @staticmethod
    def convert_shapely(polygon):
        """
        Convert a shapely polygon to a coordinate-pair-list.

        Args:
            polygon (shapely.geometry.Polygon):

        Returns:
            list[list[float,float]]: list of coordinate pairs of the polygon.
        """
        return [xy[0:2] for xy in list(polygon.exterior.coords)]


class Loading(BaseSectionObject):
    """
    Initial pollutant loads on subcatchments.

    Section:
        [LOADINGS]

    Purpose:
        Specifies the pollutant buildup that exists on each subcatchment at the start of a simulation.

    Format:
        ::

            Subcat Pollut InitBuildup Pollut InitBuildup ...

    Remarks:
        More than one pair of pollutant - buildup values can be entered per line. If more than
        one line is needed, then the subcatchment name must still be entered first on the
        succeeding lines.

        If an initial buildup is not specified for a pollutant, then its initial buildup is computed
        by applying the DRY_DAYS option (specified in the [OPTIONS] section) to the
        pollutant’s buildup function for each land use in the subcatchment.


    Attributes:
        subcatchment (str): name of a subcatchment.
        pollutant_buildup_dict (dict[str, float]): dict where name of a pollutant (str) is the key and the initial buildup of pollutant (float) (lbs/acre or kg/hectare) is the value.

    """
    _identifier = IDENTIFIERS.subcatchment
    _table_inp_export = False
    _section_label = LOADINGS

    def __init__(self, subcatchment, pollutant_buildup_dict=None):
        """
        Initial pollutant loads on subcatchments.

        Args:
            subcatchment (str): name of a subcatchment.
            pollutant_buildup_dict (dict[str, float]): dict where name of a pollutant (str) is the key and the initial buildup of pollutant (float) (lbs/acre or kg/hectare) is the value.
        """
        self.subcatchment = str(subcatchment)
        self.pollutant_buildup_dict = {}
        if pollutant_buildup_dict:
            self.pollutant_buildup_dict = pollutant_buildup_dict

    def _add_buildup(self, pollutant, buildup):
        self.pollutant_buildup_dict[pollutant] = float(buildup)

    @classmethod
    def _convert_lines(cls, multi_line_args):
        last = None
        for Subcatch, *line in multi_line_args:

            if last is None:
                # first line of section
                last = cls(Subcatch)

            elif last.subcatchment != Subcatch:
                # new Coverage
                yield last
                last = cls(Subcatch)

            # Coverage definitions
            remains = iter(line)
            for pollutant in remains:
                buildup = next(remains)
                last._add_buildup(pollutant, buildup)

        # last
        if last is not None:
            yield last

    @property
    def frame(self):
        return pd.DataFrame.from_dict(self.pollutant_buildup_dict, columns=['pollutant', 'initial buildup'])

    def to_inp_line(self):
        return '\n'.join([f'{self.subcatchment}  {p} {b}' for p, b in self.pollutant_buildup_dict.items()])


class Coverage(BaseSectionObject):
    """
    Assignment of land uses to subcatchments.

    Section:
        [COVERAGES]

    Purpose:
        Specifies the percentage of a subcatchment’s area that is covered by each category of land use.

    Format:
        ::

            Subcat Landuse Percent Landuse Percent . . .

    Remarks:
        More than one pair of land use - percentage values can be entered per line. If more
        than one line is needed, then the subcatchment name must still be entered first on
        the succeeding lines.

        If a land use does not pertain to a subcatchment, then it does not have to be entered.

        If no land uses are associated with a subcatchment then no contaminants will appear
        in the runoff from the subcatchment.

    Attributes:
        subcatchment (str): Subcatchment name.
        land_use_dict (dict): dict where land use name (str) is the key and the percent of subcatchment area (float) is the value.
    """
    _identifier = IDENTIFIERS.subcatchment
    _section_label = COVERAGES
    _table_inp_export = False

    def __init__(self, subcatchment, land_use_dict=None):
        """
        Assignment of land uses to subcatchments.

        Args:
            subcatchment (str): Subcatchment name.
            land_use_dict (dict): dict where land use name (str) is the key and the percent of subcatchment area (float) is the value.
        """
        self.subcatchment = str(subcatchment)
        self.land_use_dict = {}
        if land_use_dict:
            self.land_use_dict = land_use_dict

    def _add_land_use(self, land_use, percent):
        self.land_use_dict[land_use] = float(percent)

    @classmethod
    def _convert_lines(cls, multi_line_args):
        last = None
        for subcatchment, *line in multi_line_args:

            if last is None:
                # first line of section
                last = cls(subcatchment)

            elif last.subcatchment != subcatchment:
                # new Coverage
                yield last
                last = cls(subcatchment)

            # Coverage definitions
            remains = iter(line)
            for land_use in remains:
                percent = next(remains)
                last._add_land_use(land_use, percent)

        # last
        if last is not None:
            yield last

    @property
    def frame(self):
        return pd.DataFrame.from_dict(self.land_use_dict, columns=['land_use', 'percent'])

    def to_inp_line(self):
        return '\n'.join([f'{self.subcatchment}  {lu} {pct}' for lu, pct in self.land_use_dict.items()])


class GroundwaterFlow(BaseSectionObject):
    """
    Groundwater flow expressions.

    Section:
        [GWF]

    Purpose:
        Defines custom groundwater flow equations for specific subcatchments.

    Format:
        ::

            Subcat LATERAL/DEEP Expr

    Attributes:
        subcatchment (str): Subcatchment name.
        kind (str): ``GroundwaterFlow.TYPES`` (``LATERAL`` or ``DEEP``)
        expression (str): Math formula expressing the rate of groundwater flow
                          (in cfs per acre or cms per hectare for lateral flow or in/hr or mm/hr for deep flow)
                          as a function of the following variables

            - ``Hgw`` (for height of the groundwater table)
            - ``Hsw`` (for height of the surface water)
            - ``Hcb`` (for height of the channel bottom)
            - ``Hgs`` (for height of ground surface) where all heights are relative to the aquifer bottom and have units of either feet or meters;
            - ``Ks`` (for saturated hydraulic conductivity in in/hr or mm/hr)
            - ``K`` (for unsaturated hydraulic conductivity in in/hr or mm/hr)
            - ``Theta`` (for moisture content of unsaturated zone)
            - ``Phi`` (for aquifer soil porosity)
            - ``Fi`` (for infiltration rate from the ground surface in in/hr or mm/hr)
            - ``Fu`` (for percolation rate from the upper unsaturated zone in in/hr or mm/hr)
            - ``A`` (for subcatchment area in acres or hectares)

    Remarks:
        Use ``LATERAL`` to designate an expression for lateral groundwater flow
        (to a node of the conveyance network) and ``DEEP`` for vertical loss to deep groundwater.

        A subcatchment can have a lateral **and** a deep groundwater-flow.

        See the [``TREATMENT``] section for a list of built-in math functions that can be used in
        ``Expr``. In particular, the ``STEP(x)`` function is 1 when ``x > 0`` and is 0 otherwise.

    Examples:
        ::

            ;Two-stage linear reservoir for lateral flow
            Subcatch1 LATERAL 0.001*Hgw + 0.05*(Hgw–5)*STEP(Hgw–5)

            ;Constant seepage rate to deep aquifer
            Subactch1 DEEP 0.002
    """
    _identifier = (IDENTIFIERS.subcatchment, 'kind')
    _section_label = GWF

    class TYPES:
        LATERAL = 'LATERAL'
        DEEP = 'DEEP'

    def __init__(self, subcatchment, kind, expression, *expression_):
        """
        Groundwater flow expressions.

        Args:
            subcatchment (str): Subcatchment name.
            kind (str): ``GroundwaterFlow.TYPES`` (``LATERAL`` or ``DEEP``)
            expression (str): Math formula expressing the rate of groundwater flow
                              (in cfs per acre or cms per hectare for lateral flow or in/hr or mm/hr for deep flow)
                              as a function of the following variables

                - ``Hgw`` (for height of the groundwater table)
                - ``Hsw`` (for height of the surface water)
                - ``Hcb`` (for height of the channel bottom)
                - ``Hgs`` (for height of ground surface) where all heights are relative to the aquifer bottom and have units of either feet or meters;
                - ``Ks`` (for saturated hydraulic conductivity in in/hr or mm/hr)
                - ``K`` (for unsaturated hydraulic conductivity in in/hr or mm/hr)
                - ``Theta`` (for moisture content of unsaturated zone)
                - ``Phi`` (for aquifer soil porosity)
                - ``Fi`` (for infiltration rate from the ground surface in in/hr or mm/hr)
                - ``Fu`` (for percolation rate from the upper unsaturated zone in in/hr or mm/hr)
                - ``A`` (for subcatchment area in acres or hectares)
            *expression_:
        """
        self.subcatchment = str(subcatchment)
        self.kind = kind
        self.expression = expression + ' '.join(expression_)


class Groundwater(BaseSectionObject):
    """
    Subcatchment groundwater parameters.

    Section:
        [GROUNDWATER]

    Purpose:
        Supplies parameters that determine the rate of groundwater flow between the aquifer
        underneath a subcatchment and a node of the conveyance system.

    Attributes:
        subcatchment (float): Subcatchment name.
        aquifer (float): Name of groundwater aquifer underneath the subcatchment.
        node (float): Name of node in conveyance system exchanging groundwater with aquifer.
        Esurf (float): Surface elevation of subcatchment (ft or m).
        A1 (float): Groundwater flow coefficient (see below).
        B1 (float): Groundwater flow exponent (see below).
        A2 (float): Surface water flow coefficient (see below).
        B2 (float): Surface water flow exponent (see below).
        A3 (float): Surface water – groundwater interaction coefficient (see below).
        Dsw (float): Fixed depth of surface water at receiving node (ft or m)
                    (set to zero if surface water depth will vary as computed by flow routing).
        Egwt (float): Threshold groundwater table elevation which must be reached before any flow occurs (ft or m).
                    Leave blank (or enter \\*) to use the elevation of the receiving node's invert.
        Ebot (float): Elevation of the bottom of the aquifer (ft or m).
        Egw (float): Groundwater table elevation at the start of the simulation (ft or m).
        Umc (float): Unsaturated zone moisture content at start of simulation (volumetric fraction).


    Remarks:
        The optional parameters (Ebot, Egw, Umc) can be used to override the values supplied for the subcatchment’s
        aquifer.

        The flow coefficients are used in the following equation that determines the lateral groundwater
        flow rate based on groundwater and surface water elevations:

        .. math::

            Q_L = A1 * (H_{gw} – H_{cb} ) ^ {B1} – A2 * (H_{sw} – H_{cb} ) ^ {B2} + A3 * H_{gw} * H_{sw}

        where:
            - Q_L = lateral groundwater flow (cfs per acre or cms per hectare),
            - H_gw = height of saturated zone above bottom of aquifer (ft or m),
            - H_sw = height of surface water at receiving node above aquifer bottom (ft or m),
            - H_cb = height of channel bottom above aquifer bottom (ft or m).
    """
    _identifier = (IDENTIFIERS.subcatchment, 'aquifer', IDENTIFIERS.node)
    _section_label = GROUNDWATER

    def __init__(self, subcatchment, aquifer, node, Esurf, A1, B1, A2, B2, A3, Dsw, Egwt=np.nan, Ebot=np.nan, Egw=np.nan, Umc=np.nan):
        """
        Subcatchment groundwater parameters.

        Args:
            subcatchment (float): Subcatchment name.
            aquifer (float): Name of groundwater aquifer underneath the subcatchment.
            node (float): Name of node in conveyance system exchanging groundwater with aquifer.
            Esurf (float): Surface elevation of subcatchment (ft or m).
            A1 (float): Groundwater flow coefficient (see below).
            B1 (float): Groundwater flow exponent (see below).
            A2 (float): Surface water flow coefficient (see below).
            B2 (float): Surface water flow exponent (see below).
            A3 (float): Surface water – groundwater interaction coefficient (see below).
            Dsw (float): Fixed depth of surface water at receiving node (ft or m)
                        (set to zero if surface water depth will vary as computed by flow routing).
            Egwt (float or str): Threshold groundwater table elevation which must be reached before any flow occurs (ft or m).
                        Leave blank (or enter `*`) to use the elevation of the receiving node's invert.
            Ebot (float): Elevation of the bottom of the aquifer (ft or m).
            Egw (float): Groundwater table elevation at the start of the simulation (ft or m).
            Umc (float): Unsaturated zone moisture content at start of simulation (volumetric fraction).
        """
        self.subcatchment = str(subcatchment)
        self.aquifer = str(aquifer)
        self.node = str(node)
        self.Esurf = float(Esurf)
        self.A1 = float(A1)
        self.B1 = float(B1)
        self.A2 = float(A2)
        self.B2 = float(B2)
        self.A3 = float(A3)
        self.Dsw = float(Dsw)
        self.Egwt = Egwt
        self.Ebot = float(Ebot)
        self.Egw = float(Egw)
        self.Umc = float(Umc)
