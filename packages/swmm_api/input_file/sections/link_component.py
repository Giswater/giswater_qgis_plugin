from typing import NamedTuple

import numpy as np
from numpy import NaN, isnan
from pandas import DataFrame

from ._identifiers import IDENTIFIERS
from ..helpers import BaseSectionObject, InpSectionGeo
from .._type_converter import to_bool, get_gis_inp_decimals
from ..section_labels import XSECTIONS, LOSSES, VERTICES


class CrossSection(BaseSectionObject):
    """
    Conduit, orifice, and weir cross-section geometry.

    Section:
        [XSECTIONS]

    Purpose:
        Provides cross-section geometric data for conduit and regulator links of the drainage system.

    Formats:
        ::

            Link Shape      Geom1 Geom2                   Geom3 Geom4 (Barrels Culvert)
            Link CUSTOM     Geom1       Curve                         (Barrels)
            Link IRREGULAR                    Tsect
            Link STREET                            Street

    Remarks:
        The Culvert code number is used only for conduits that act as culverts
        and should be analyzed for inlet control conditions using the FHWA HDS-5 method.

        The ``CUSTOM`` shape is a closed conduit whose width versus height is described by a user-supplied Shape Curve.

        An ``IRREGULAR`` cross-section is used to model an open channel whose geometry is described by a Transect
        object.

        A ``STREET`` cross-section is used to model street conduits and inlet flow capture
        (see the [``INLETS``] and [``INLETS_USAGE``] sections).

        The Culvert code number is used only for closed conduits acting as culverts that should be
        analyzed for inlet control conditions using the FHWA HDS-5 methodology.

    Attributes:
        link (str): name of the conduit, orifice, or weir.
        shape (str): cross-section shape (see Tables D-1 below or 3-1 for available shapes).
        height (float): full height of the cross-section (ft or m).
        parameter_2-4: auxiliary parameters (width, side slopes, etc.) as listed in Table D-1.
        n_barrels (int): number of barrels (i.e., number of parallel pipes of equal size, slope, and roughness)
                       associated with a conduit (default is 1).
        culvert (int): code number from Table A.10 for the conduit’s inlet geometry if it is a culvert subject to
                       possible inlet flow control (leave blank otherwise).
        transect (str): name of an entry in the [``TRANSECTS``] section that describes the crosssection geometry of an
                     irregular channel.
        curve_name (str): name of a Shape Curve in the [``CURVES``] section that defines how width varies with depth.
    """
    _identifier = IDENTIFIERS.link
    _section_label = XSECTIONS

    class SHAPES:
        IRREGULAR = 'IRREGULAR'  # TransectCoordinates (Natural Channel)
        CUSTOM = 'CUSTOM'  # Full Height, ShapeCurveCoordinates
        STREET = 'STREET'

        CIRCULAR = 'CIRCULAR'  # Full Height = Diameter
        FORCE_MAIN = 'FORCE_MAIN'  # Full Height = Diameter, Roughness
        FILLED_CIRCULAR = 'FILLED_CIRCULAR'  # Full Height = Diameter, Filled Depth
        RECT_CLOSED = 'RECT_CLOSED'  # Rectangular: Full Height, Top Width
        RECT_OPEN = 'RECT_OPEN'  # Rectangular: Full Height, Top Width
        TRAPEZOIDAL = 'TRAPEZOIDAL'  # Full Height, Base Width, Side Slopes
        TRIANGULAR = 'TRIANGULAR'  # Full Height, Top Width
        HORIZ_ELLIPSE = 'HORIZ_ELLIPSE'  # Full Height, Max. Width
        VERT_ELLIPSE = 'VERT_ELLIPSE'  # Full Height, Max. Width
        ARCH = 'ARCH'  # Size Code or Full Height, Max. Width
        PARABOLIC = 'PARABOLIC'  # Full Height, Top Width
        POWER = 'POWER'  # Full Height, Top Width, Exponent
        RECT_TRIANGULAR = 'RECT_TRIANGULAR'  # Full Height, Top Width, Triangle Height
        RECT_ROUND = 'RECT_ROUND'  # Full Height, Top Width, Bottom Radius
        MODBASKETHANDLE = 'MODBASKETHANDLE'  # Full Height, Bottom Width, Top Radius
        EGG = 'EGG'  # Full Height
        HORSESHOE = 'HORSESHOE'  # Full Height Gothic Full Height
        GOTHIC = 'GOTHIC'  # Full Height
        CATENARY = 'CATENARY'  # Full Height
        SEMIELLIPTICAL = 'SEMIELLIPTICAL'  # Full Height
        BASKETHANDLE = 'BASKETHANDLE'  # Full Height
        SEMICIRCULAR = 'SEMICIRCULAR'  # Full Height

    def __init__(self, link, shape, height=0, parameter_2=0, parameter_3=0, parameter_4=0, n_barrels=1, culvert=NaN,
                 transect=None, curve_name=None, street=None):
        """
        Conduit, orifice, and weir cross-section geometry.

        Args:
            link (str): name of the conduit, orifice, or weir.
            shape (str): cross-section shape (see Tables D-1 below or 3-1 for available shapes).
            height (float): full height of the cross-section (ft or m).
            parameter_2-4: auxiliary parameters (width, side slopes, etc.) as listed in Table D-1.
            n_barrels (int): number of barrels (i.e., number of parallel pipes of equal size, slope, and roughness)
                           associated with a conduit (default is 1).
            culvert (int): code number from Table A.10 for the conduit’s inlet geometry if it is a culvert subject to
                           possible inlet flow control (leave blank otherwise).
            transect (str): name of an entry in the [``TRANSECTS``] section that describes the crosssection geometry of an
                         irregular channel.
            curve_name (str): name of a Shape Curve in the [``CURVES``] section that defines how width varies with depth.
        """
        # in SWMM C-code function "link_readXsectParams"
        self.link = str(link)
        self.shape = shape

        self.height = NaN
        self.transect = NaN
        self.street = NaN

        self.parameter_2 = NaN
        self.curve_name = NaN

        if shape == self.SHAPES.IRREGULAR:
            if transect is None:
                # read inp file
                transect = height
            self.transect = str(transect)  # name of TransectCoordinates
        elif shape == self.SHAPES.STREET:
            if street is None:
                # read inp file
                street = height
            self.street = str(street)  # name of Street section
        elif shape == self.SHAPES.CUSTOM:
            if curve_name is None:
                curve_name = parameter_2
            self.curve_name = str(curve_name)
            self.height = float(height)
        else:
            self.height = float(height)
            self.parameter_2 = float(parameter_2)

        self.parameter_3 = float(parameter_3)
        self.parameter_4 = float(parameter_4)
        self.n_barrels = int(n_barrels)
        # according to the c code 6 arguments are needed to not raise an error / nonsense, but you have to
        if n_barrels != 1 or not isinstance(n_barrels, str) and ~isnan(n_barrels):
            self.n_barrels = int(n_barrels)
        self.culvert = culvert

    @classmethod
    def custom(cls, link, height, curve):
        """
        ``CUSTOM`` shape is a closed conduit whose width versus height is described by a user-supplied Shape Curve.
        """
        return cls(link, CrossSection.SHAPES.CUSTOM, height=height, curve_name=curve)

    @classmethod
    def irregular(cls, link, transect):
        """
        ``IRREGULAR`` cross-section is used to model an open channel whose geometry is described by a Transect object.
        """
        return cls(link, CrossSection.SHAPES.IRREGULAR, transect=transect)

    @classmethod
    def create_street(cls, link, street):
        """
        ``IRREGULAR`` cross-section is used to model an open channel whose geometry is described by a Transect object.
        """
        return cls(link, CrossSection.SHAPES.STREET, street=street)


class Loss(BaseSectionObject):
    """
    Conduit entrance/exit losses and flap valves.
    
    Section:
        [LOSSES]

    Purpose:
        Specifies minor head loss coefficients, flap gates, and seepage rates for conduits.

    Remarks:
        Minor losses are only computed for the Dynamic Wave flow routing option (see
        [OPTIONS] section). They are computed as Kv 2 /2g where K = minor loss coefficient, v
        = velocity, and g = acceleration of gravity. Entrance losses are based on the velocity
        at the entrance of the conduit, exit losses on the exit velocity, and average losses on
        the average velocity.

        Only enter data for conduits that actually have minor losses, flap valves, or seepage
        losses.

    Attributes:
        link (str): Name of conduit.
        entrance (float): Entrance (inlet) minor head loss coefficient.
        exit (float): Exit (outlet) minor head loss coefficient.
        average (float): Average minor head loss coefficient across length of conduit.
        has_flap_gate (bool): ``YES`` (:obj:`True`) if flap gate present to prevent reverse flow,
                              ``NO`` (:obj:`False`) if not (default is ``NO``).
        seepage_rate (float): Rate of seepage loss into surrounding soil (in/hr or mm/hr). (Default is 0.)
    """
    _identifier = IDENTIFIERS.link
    _section_label = LOSSES

    class TYPES:
        ENTRANCE = 'entrance'
        EXIT = 'exit'
        AVERAGE = 'average'

    def __init__(self, link, entrance=0, exit=0, average=0, has_flap_gate=False, seepage_rate=0):
        """
        Conduit entrance/exit losses and flap valves.

        Args:
            link (str): Name of conduit.
            entrance (float): Entrance minor head loss coefficient.
            exit (float): Exit minor head loss coefficient.
            average (float): Average minor head loss coefficient across length of conduit.
            has_flap_gate (bool): ``YES`` (:obj:`True`) if flap gate present to prevent reverse flow,
                                  ``NO`` (:obj:`False`) if not (default is ``NO``).
            seepage_rate (float): Rate of seepage loss into surrounding soil (in/hr or mm/hr). (Default is 0.)
        """
        self.link = str(link)
        self.entrance = float(entrance)
        self.exit = float(exit)
        self.average = float(average)
        self.has_flap_gate = to_bool(has_flap_gate)
        self.seepage_rate = float(seepage_rate)


class Vertices(BaseSectionObject):
    """
    X,Y coordinates for each interior vertex of polyline links.

    Section:
        [VERTICES]

    Purpose:
        Assigns X,Y coordinates to interior vertex points of curved drainage system links.

    Remarks:
        Straight-line links have no interior vertices and therefore are not listed in this section.

        Include a separate line for each interior vertex of the link, ordered from the inlet node to the outlet
        node.

    Attributes:
        link (str): Name of link.
        vertices (list[list[float, float]]): Vertices relative to origin in lower left of map.

            - x_coord: horizontal (x-)coordinate
            - y_coord: vertical (y-)coordinate
    """
    _identifier = IDENTIFIERS.link
    _table_inp_export = False
    _section_label = VERTICES
    _section_class = InpSectionGeo

    def __init__(self, link, vertices):
        """
        X,Y coordinates for each interior vertex of polyline links.

        Args:
            link (str): Name of link.
            vertices (list[list[float, float]]): Vertices relative to origin in lower left of map.

                - x_coord: horizontal (x-)coordinate
                - y_coord: vertical (y-)coordinate
        """
        self.link = str(link)
        self.vertices = vertices

    @classmethod
    def _convert_lines(cls, multi_line_args):
        vertices = []
        last = None

        for line in multi_line_args:
            link, x, y = line
            x = float(x)
            y = float(y)
            if link == last:
                vertices.append((x, y))
            else:
                if last is not None:
                    yield cls(last, vertices)
                last = link
                vertices = [(x, y)]
        # last
        if last is not None:
            yield cls(last, vertices)

    def to_inp_line(self):
        return '\n'.join([f'{self.link} {x:0.{get_gis_inp_decimals()}f} {y:0.{get_gis_inp_decimals()}f}' for x, y in self.vertices])

    @property
    def frame(self):
        """convert Vertices object to a data-frame

        for debugging purposes

        Returns:
            pandas.DataFrame: section as table
        """
        return DataFrame.from_records(self.vertices, columns=['x', 'y'])

    @property
    def geo(self):
        """
        get the shapely representation for the object (LineString).

        Returns:
            shapely.geometry.LineString: LineString object for the vertices.
        """
        import shapely.geometry as sh
        return sh.LineString(self.vertices)

    @classmethod
    def create_section_from_geoseries(cls, data) :
        """
        create a VERTICES inp-file section for a geopandas.GeoSeries

        Args:
            data (geopandas.GeoSeries): geopandas.GeoSeries of coordinates

        Returns:
            InpSectionGeo: VERTICES inp-file section
        """
        # geometry mit MultiLineString deswegen v[0] mit ersten und einzigen linestring zu verwenden
        s = cls.create_section()
        # s.update({i: Vertices(i, v) for i, v in zip(data.index, map(lambda i: list(i.coords), data.values))})
        # s.add_multiple(cls(i, list(v.coords)) for i, v in data.to_dict().items())
        s.add_multiple(cls.from_shapely(i, v) for i, v in data.items())
        return s

    @classmethod
    def from_shapely(cls, link, line):
        """
        Create a Vertices object with a shapely LineString

        Args:
            link (str): label of the link
            line (shapely.geometry.LineString):

        Returns:
            Vertices: Vertices object
        """
        return cls(link, list(line.coords))

    def get_geo_length(self):
        return np.sum(np.sqrt(np.sum(np.square(np.diff(np.array(self.vertices), axis=0)), axis=1)))
