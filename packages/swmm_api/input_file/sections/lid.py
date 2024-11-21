from numpy import nan

from ._identifiers import IDENTIFIERS
from .._type_converter import to_bool, convert_string
from ..helpers import BaseSectionObject
from ..section_labels import LID_USAGE, LID_CONTROLS


class LIDControl(BaseSectionObject):
    """
    Low impact development control information.

    Section:
        [LID_CONTROLS]

    Purpose:
        Defines scale-independent LID controls that can be deployed within subcatchments.

    Formats:
        ::

            Name SURFACE StorHt VegFrac Rough Slope Xslope
            Name SOIL Thick Por FC WP Ksat Kcoeff Suct
            Name PAVEMENT Thick Vratio FracImp Perm Vclog
            Name STORAGE Height Vratio Seepage Vclog
            Name DRAIN Coeff Expon Offset Delay
            Name DRAINMAT Thick Vratio Rough
            Name REMOVALS Pollut PctRemove ...

    Examples:
        ::

            ;A street planter with no drain
            Planter BC
            Planter SURFACE 6 0.3 0 0 0
            Planter SOIL 24 0.5 0.1 0.05 1.2 2.4
            Planter STORAGE 12 0.5 0.5 0

            ;A green roof with impermeable bottom
            GR1 BC
            GR1 SURFACE 3 0 0 0 0
            GR1 SOIL 3 0.5 0.1 0.05 1.2 2.4
            GR1 STORAGE 3 0.5 0 0
            GR1 DRAIN 5 0.5 0 0

            ;A rain barrel that drains 6 hours after rainfall ends
            RB12 RB
            RB12 STORAGE 36 0 0 0
            RB12 DRAIN 10 0.5 0 6

            ;A grass swale 24 in. high with 5:1 side slope
            Swale VS
            Swale SURFACE 24 0 0.2 3 5

    Remarks:
        The following table shows which layers are required (x) or are optional (o) for each type of LID process:

        +-----------------------+---------+----------+------+---------+-------+-----------+--------------------+
        | LID Type              | Surface | Pavement | Soil | Storage | Drain | Drain Mat | Pollutant Removals |
        +-----------------------+---------+----------+------+---------+-------+-----------+--------------------+
        | Bio-Retention Cell    | x       |          | x    | x       | o     |           | o                  |
        +-----------------------+---------+----------+------+---------+-------+-----------+--------------------+
        | Rain Garden           | x       |          | x    |         |       |           |                    |
        +-----------------------+---------+----------+------+---------+-------+-----------+--------------------+
        | Green Roof            | x       |          | x    |         |       | x         |                    |
        +-----------------------+---------+----------+------+---------+-------+-----------+--------------------+
        | Infiltration Trench   | x       |          |      | x       | o     |           | o                  |
        +-----------------------+---------+----------+------+---------+-------+-----------+--------------------+
        | Permeable Pavement    | x       | x        | o    | x       | o     |           | o                  |
        +-----------------------+---------+----------+------+---------+-------+-----------+--------------------+
        | Rain Barrel           |         |          |      | x       | x     |           | o                  |
        +-----------------------+---------+----------+------+---------+-------+-----------+--------------------+
        | Rooftop Disconnection | x       |          |      |         | x     |           |                    |
        +-----------------------+---------+----------+------+---------+-------+-----------+--------------------+
        | Vegetative Swale      | x       |          |      |         |       |           |                    |
        +-----------------------+---------+----------+------+---------+-------+-----------+--------------------+


        The equation used to compute flow rate out of the underdrain per unit area of the LID (in in/hr or
        mm/hr) is q = C * (h - H_d) ^ n where q is outflow, h is height of stored water (inches or mm) and H d
        is the drain offset height. Note that the units of C depend on the unit system being used as well
        as the value assigned to n.

        The actual dimensions of an LID control are provided in the [LID_USAGE] section when it is
        placed in a particular subcatchment.

    Attributes:
        name (str): name assigned to LID process.
        lid_kind (str): One of :attr:`LIDControl.LID_TYPES`.

            - ``BC`` bio-retention cell
            - ``RG`` rain garden
            - ``GR`` green roof
            - ``IT`` infiltration trench
            - ``PP`` permeable pavement
            - ``RB`` rain barrel
            - ``RD`` rooftop disconnection
            - ``VS`` vegetative swale

        layer_dict (MutableMapping[str, LIDControl.LAYER_TYPES.Surface | LIDControl.LAYER_TYPES.Soil]): Sict of used layers in control.

        LID_TYPES: Enum-like for the attribute :attr:`LIDControl.lid_kind` with following members -> {``BC`` | ``RG`` | ``IT`` | ``PP`` | ``RB`` | ``RD`` | ``VS``}

        LAYER_TYPES: Sub-classes for the attribute :attr:`LIDControl.layer_dict` with following members -> {Surface, Soil, Pavement, Storage, Drain, Drainmat, Removals}
    """
    _identifier = IDENTIFIERS.name
    _section_label = LID_CONTROLS
    _table_inp_export = False

    class LID_TYPES:
        BC = 'BC'  # bio-retention cell
        RG = 'RG'  # rain garden
        GR = 'GR'  # green roof
        IT = 'IT'  # infiltration trench
        PP = 'PP'  # permeable pavement
        RB = 'RB'  # rain barrel
        RD = 'RD'  # rooftop disconnection
        VS = 'VS'  # vegetative swale

        # Aliases
        BIO_RETENTION_CELL = BC
        RAIN_GARDEN = RG
        GREEN_ROOF = GR
        INFILTRATION_TRENCH = IT
        PERMEABLE_PAVEMENT = PP
        RAIN_BARREL = RB
        ROOFTOP_DISCONNECTION = RD
        VEGETATIVE_SWALE = VS

        _possible = {BC, RG, GR, IT, PP, RB, RD, VS}

    def __init__(self, name, lid_kind, layer_dict=None):
        """
        Low impact development control information.

        Args:
            name (str): Name assigned to LID process.
            lid_kind (str): One of :attr:`LIDControl.LID_TYPES`.

                - ``BC`` for bio-retention cell
                - ``RG`` for rain garden; GR for green roof
                - ``IT`` for infiltration trench
                - ``PP`` for permeable pavement
                - ``RB`` for rain barrel
                - ``RD`` for rooftop disconnection
                - ``VS`` for vegetative swale.

            layer_dict (dict[str, LIDControl.LAYER_TYPES.Surface]): dict of used layers in control.
        """
        self.name = str(name)
        self.lid_kind = lid_kind.upper()  # one of LID_TYPES
        self.layer_dict = {} if layer_dict is None else layer_dict
        # Using dict instead of list to simplify editing single layer after creation.

    @classmethod
    def _convert_lines(cls, multi_line_args):
        last = None

        for name, *line in multi_line_args:
            # ---------------------------------
            if line[0].upper() in cls.LID_TYPES._possible:
                if last is not None:
                    yield last
                last = cls(name, lid_kind=line[0].upper())
            elif name == last.name:
                layer_type = line.pop(0).upper()  # one of LAYER_TYPES
                layer = cls.LAYER_TYPES._dict[layer_type](*line)
                last.add_layer(layer)
                # last.layer_dict[layer_type] = layer
        if last is not None:
            yield last

    class LAYER_TYPES:
        """Layer types to add to LID controls."""
        class Surface(BaseSectionObject):
            _LABEL = 'SURFACE'

            def __init__(self, StorHt, VegFrac=0, Rough=0, Slope=0, Xslope=0):
                """

                Used:
                    bio-retention cell
                    rain garden
                    green roof
                    infiltration trench
                    permeable pavement
                    rooftop disconnection
                    vegetative swale

                Args:
                    StorHt (float): when confining walls or berms are present this is the maximum depth to which water can
                        pond above the surface of the unit before overflow occurs (in inches or mm). For LIDs that
                        experience overland flow it is the height of any surface depression storage.
                        For swales, it is the height of its trapezoidal cross section.
                    VegFrac (float): fraction of the surface storage volume that is filled with vegetation.
                    Rough (float): Manning's n for overland flow over surface soil cover, pavement, roof surface or a
                        vegetative swale. Use 0 for other types of LIDs.
                    Slope (float): slope of a roof surface, pavement surface or vegetative swale (percent).
                        Use 0 for other types of LIDs.
                    Xslope (float): slope (run over rise) of the side walls of a vegetative swale's cross section.
                        Use 0 for other types of LIDs.

                Remarks:
                    If either Rough or Slope values are 0 then any ponded water that exceeds the
                    surface storage depth is assumed to completely overflow the LID control within a
                    single time step.
                """
                self.StorHt = float(StorHt)
                self.VegFrac = float(VegFrac)
                self.Rough = float(Rough)
                self.Slope = float(Slope)
                self.Xslope = float(Xslope)

        class Soil(BaseSectionObject):
            _LABEL = 'SOIL'

            def __init__(self, Thick, Por, FC, WP, Ksat, Kcoeff, Suct):
                """
                The Soil Layer of the LID Control describes the properties of the engineered soil
                mixture used in bio-retention types of LIDs and the optional sand layer beneath permeable
                pavement.

                Used:
                    bio-retention cell
                    rain garden
                    green roof
                    permeable pavement (only optional)

                Args:
                    Thick (float): thickness of the soil layer (inches or mm). Typical values range from 18 to 36 inches (450 to 900 mm) for rain gardens, street planters and other types of land-based bio-retention units, but only 3 to 6 inches (75 to 150 mm) for green roofs.
                    Por (float): soil porosity (The volume of pore space relative to total volume as a fraction).
                    FC (float): soil field capacity (volume of pore water relative to total volume after the
                        soil has been allowed to drain fully). Below this level, vertical drainage of water through the soil layer does not occur.
                    WP (float): soil wilting point (volume of pore water relative to total volume for a well
                        dried soil where only bound water remains). The moisture content of the soil cannot fall below this limit.
                    Ksat (float): soil’s saturated hydraulic conductivity (in/hr or mm/hr).
                    Kcoeff (float): slope of the curve of log(conductivity) versus soil moisture content (dimensionless).
                        Conductivity Slope - Average slope of the curve of log(conductivity) versus soil moisture deficit (porosity minus moisture content) (unitless).
                        Typical values range from 30 to 60. It can be estimated from a standard soil grain size analysis as 0.48(%Sand) + 0.85(%Clay).
                    Suct (float): soil capillary suction (in or mm) or Suction Head.
                        The average value of soil capillary suction along the wetting front (inches or mm).
                        This is the same parameter as used in the Green-Ampt infiltration model.
                """
                self.Thick = float(Thick)
                self.Por = float(Por)
                self.FC = float(FC)
                self.WP = float(WP)
                self.Ksat = float(Ksat)
                self.Kcoeff = float(Kcoeff)
                self.Suct = float(Suct)

        class Pavement(BaseSectionObject):
            _LABEL = 'PAVEMENT'

            def __init__(self, Thick, Vratio, FracImp, Perm, Vclog, regeneration_interval=nan, regeneration_fraction=nan):
                """
                Used:
                    permeable pavement

                Args:
                    Thick (float): thickness of the pavement layer (inches or mm).
                    Vratio (float): void ratio (volume of void space relative to the volume of solids in the
                        pavement for continuous systems or for the fill material used in modular
                        systems). Note that porosity = void ratio / (1 + void ratio).

                    FracImp (float): ratio of impervious paver material to total area for modular systems; 0 for
                        continuous porous pavement systems.
                    Perm (float): permeability of the concrete or asphalt used in continuous systems or
                        hydraulic conductivity of the fill material (gravel or sand) used in modular
                        systems (in/hr or mm/hr).
                    Vclog (float): number of pavement layer void volumes of runoff treated it takes to completely clog the pavement. Use a value of 0 to ignore clogging.
                """
                self.Thick = float(Thick)
                self.Vratio = float(Vratio)
                self.FracImp = float(FracImp)
                self.Perm = float(Perm)
                self.Vclog = Vclog  # acc. to documentation
                # self.clogging_factor = float(clogging_factor)
                self.regeneration_interval = float(regeneration_interval)
                self.regeneration_fraction = float(regeneration_fraction)

        class Storage(BaseSectionObject):
            _LABEL = 'STORAGE'

            def __init__(self, Height, Vratio, Seepage, Vclog, Covrd=True):
                """
                Used:
                    bio-retention cell
                    infiltration trench
                    permeable pavement
                    rain barrel

                Args:
                    Height (float): thickness of the storage layer or height of a rain barrel (inches or mm).
                    Vratio (float): void ratio (volume of void space relative to the volume of solids in the
                        layer). Note that porosity = void ratio / (1 + void ratio).
                    Seepage (float): the rate at which water seeps from the layer into the underlying native
                        soil when first constructed (in/hr or mm/hr). If there is an impermeable
                        floor or liner below the layer then use a value of 0.
                    Vclog (int): number of storage layer void volumes of runoff treated it takes to
                        completely clog the layer. Use a value of 0 to ignore clogging.
                    Covrd (bool): YES (the default) if a rain barrel is covered, NO if it is not.

                Remarks:
                    Values for Vratio, Seepage, and Vclog are ignored for rain barrels.
                """
                self.Height = float(Height)
                self.Vratio = float(Vratio)
                self.Seepage = float(Seepage)
                self.Vclog = int(Vclog)
                self.Covrd = to_bool(Covrd)

        class Drain(BaseSectionObject):
            _LABEL = 'DRAIN'

            def __init__(self, Coeff, Expon, Offset, Delay, open_level=nan, close_level=nan, Qcurve=nan):
                """

                Used:
                    bio-retention cell (only optional)
                    infiltration trench (only optional)
                    permeable pavement (only optional)
                    rain barrel
                    rooftop disconnection

                Args:
                    Coeff (float): coefficient C that determines the rate of flow through the drain as a
                        function of height of stored water above the drain bottom. For Rooftop
                        Disconnection it is the maximum flow rate (in inches/hour or mm/hour)
                        that the roof’s gutters and downspouts can handle before overflowing.
                    Expon (float): exponent n that determines the rate of flow through the drain as a
                        function of height of stored water above the drain outlet.
                    Offset (float): height of the drain line above the bottom of the storage layer or rain
                        barrel (inches or mm).
                    Delay: number of dry weather hours that must elapse before the drain line in a
                        rain barrel is opened (the line is assumed to be closed once rainfall
                        begins). A value of 0 signifies that the barrel's drain line is always open
                        and drains continuously. This parameter is ignored for other types of
                        LIDs.
                    Hopen (): The height of water (in inches or mm) in the drain's Storage Layer that causes
                        the drain to automatically open. Use 0 to disable this feature.
                    Hclose (): The height of water (in inches or mm) in the drain's Storage Layer that causes
                        the drain to automatically close. Use 0 to disable this feature.
                    Qcurve (): The name of an optional Control Curve that adjusts the computed drain flow as
                        a function of the head of water above the drain. Leave blank if not applicable.
                """
                self.Coeff = float(Coeff)
                self.Expon = float(Expon)
                self.Offset = float(Offset)
                self.Delay = Delay  # acc. to documentation  / for Rain Barrels only
                self.open_level = open_level  # not in documentation of 5.1 but in 5.2
                self.close_level = close_level  # not in documentation of 5.1 but in 5.2
                self.Qcurve = Qcurve

        class Drainmat(BaseSectionObject):
            _LABEL = 'DRAINMAT'

            def __init__(self, Thick, Vratio, Rough):
                """
                Used:
                    GreenRoofs

                Args:
                    Thick (float): thickness of the drainage mat (inches or mm).
                    Vratio (float): ratio of void volume to total volume in the mat.
                    Rough (float): Manning's n constant used to compute the horizontal flow rate of drained water through the mat.
                """
                self.Thick = float(Thick)
                self.Vratio = float(Vratio)
                self.Rough = float(Rough)

        class Removals(BaseSectionObject):
            _LABEL = 'REMOVALS'

            def __init__(self, *pollutant_removal_rate):
                """
                Pollutant removals.

                Only when pollutants are defined.

                Used:
                    bio-retention cell
                    infiltration trench
                    permeable pavement
                    rain barrel

                Args:
                    Pollut (str): name of a pollutant
                    Rmvl (flaat): the percent removal the LID achieves for the pollutant (several pollutant
                        removals can be placed on the same line or specified in separate REMOVALS
                        lines).
                """
                self.pollutant_removal_rate = list(pollutant_removal_rate)

        SURFACE = Surface._LABEL
        SOIL = Soil._LABEL
        PAVEMENT = Pavement._LABEL
        STORAGE = Storage._LABEL
        DRAIN = Drain._LABEL
        DRAINMAT = Drainmat._LABEL
        REMOVALS = Removals._LABEL

        _dict = {x._LABEL: x for x in (Surface, Soil, Pavement, Storage, Drain, Drainmat, Removals)}
        _possible = set(_dict.keys())

    def add_layer(self, layer):
        """
        Add a new layer to the LID control. Or overwrite the existing one.

        Args:
            layer (LIDControl.LAYER_TYPES.Surface | LIDControl.LAYER_TYPES.Soil | LIDControl.LAYER_TYPES.Pavement | LIDControl.LAYER_TYPES.Storage | LIDControl.LAYER_TYPES.Drain | LIDControl.LAYER_TYPES.Drainmat | LIDControl.LAYER_TYPES.Removals): layer object.
        """
        self.layer_dict[layer._LABEL] = layer

    def add_layer_as_dict(self, layer_type, kwargs):
        """
        Add a new layer to the LID control. Or overwrite the existing one.

        Args:
            layer_type (str): label of the layer. One of :attr:`LIDControl.LAYER_TYPES._possible` -> {``SURFACE``| ``SOIL``| ``PAVEMENT``| ``STORAGE``| ``DRAIN``| ``DRAINMAT``| ``REMOVALS``}
            kwargs (dict): keyword arguments of the new layer.
        """
        self.add_layer(self.LAYER_TYPES._dict[layer_type](**kwargs))

    def to_inp_line(self):
        s = f'{self.name} {self.lid_kind}\n'
        for layer, l in self.layer_dict.items():
            s += f'{self.name} {layer:<8} {l.to_inp_line()}\n'
        return s


class LIDUsage(BaseSectionObject):
    """
    Assignment of LID controls to subcatchments.

    Section:
        [LID_USAGE]

    Purpose:
        Deploys LID controls within specific subcatchment areas.

    Remarks:
        If :attr:`LIDUsage.route_to_pervious` is set to 1 and :attr:`LIDUsage.drain_to` set to some other outlet,
        then only the excess surface flow from the LID unit will be routed back to the subcatchment’s pervious
        area while the underdrain flow will be sent to :attr:`LIDUsage.drain_to`.

        More than one type of LID process can be deployed within a subcatchment as long
        as their total area does not exceed that of the subcatchment and the total percent
        impervious area treated does not exceed 100.

    Attributes:
        subcatchment (str): Name of the subcatchment using the LID process.
        lid (str): Name of an LID process defined in the [LID_CONTROLS] section.
        n_replicate (int): Number of replicate LID units deployed.
        area (float): Area of each replicate unit (ft^2 or m^2 ).
        width (float): Width of the outflow face of each identical LID unit (in ft or m). This
            parameter applies to roofs, pavement, trenches, and swales that use
            overland flow to convey surface runoff off of the unit. It can be set to 0 for
            other LID processes, such as bio-retention cells, rain gardens, and rain
            barrels that simply spill any excess captured runoff over their berms.
        saturation_init (float): For bio-retention cells, rain gardens, and green roofs this is the degree to
            which the unit's soil is initially filled with water (0 % saturation
            corresponds to the wilting point moisture content, 100 % saturation has
            the moisture content equal to the porosity). The storage zone beneath
            the soil zone of the cell is assumed to be completely dry. For other types
            of LIDs it corresponds to the degree to which their storage zone is
            initially filled with water
        impervious_portion (float): Percent of the impervious portion of the subcatchment’s non-LID area
            whose runoff is treated by the LID practice. (E.g., if rain barrels are used
            to capture roof runoff and roofs represent 60% of the impervious area,
            then the impervious area treated is 60%). If the LID unit treats only direct
            rainfall, such as with a green roof, then this value should be 0. If the LID
            takes up the entire subcatchment then this field is ignored.
        route_to_pervious (int): A value of 1 indicates that the surface and drain flow from the LID unit
            should be routed back onto the pervious area of the subcatchment that
            contains it. This would be a common choice to make for rain barrels,
            rooftop disconnection, and possibly green roofs. The default value is 0.
        fn_lid_report (str): Optional name of a file to which detailed time series results for the LID
            will be written. Enclose the name in double quotes if it contains spaces
            and include the full path if it is different than the SWMM input file path.
            Use ‘*’ if not applicable and an entry for DrainTo follows
        drain_to (str): Optional name of subcatchment or node that receives flow from the unit’s
            drain line, if different from the outlet of the subcatchment that the LID is
            placed in.
        from_pervious (float): optional percent of the pervious portion of the subcatchment’s non-LID area
            whose runoff is treated by the LID practice. The default value is 0.

    Examples:
        ::

            ;34 rain barrels of 12 sq ft each are placed in
            ;subcatchment S1. They are initially empty and treat 17%
            ;of the runoff from the subcatchment’s impervious area.
            ;The outflow from the barrels is returned to the
            ;subcatchment’s pervious area.
            S1 RB14 34 12 0 0 17 1

            ;Subcatchment S2 consists entirely of a single vegetative
            ;swale 200 ft long by 50 ft wide.
            S2 Swale 1 10000 50 0 0 0 “swale.rpt”
    """
    _identifier = (IDENTIFIERS.subcatchment, 'lid')
    _section_label = LID_USAGE

    def __init__(self, subcatchment, lid, n_replicate, area, width, saturation_init, impervious_portion, route_to_pervious=0, fn_lid_report=nan, drain_to=nan, from_pervious=nan):
        """
        Assignment of LID controls to subcatchments.

        Args:
            subcatchment (str): Name of the subcatchment using the LID process.
            lid (str): Name of an LID process defined in the [LID_CONTROLS] section.
            n_replicate (int): Number of replicate LID units deployed.
            area (float): Area of each replicate unit (ft^2 or m^2 ).
            width (float): Width of the outflow face of each identical LID unit (in ft or m). This
                parameter applies to roofs, pavement, trenches, and swales that use
                overland flow to convey surface runoff off of the unit. It can be set to 0 for
                other LID processes, such as bio-retention cells, rain gardens, and rain
                barrels that simply spill any excess captured runoff over their berms.
            saturation_init (float): For bio-retention cells, rain gardens, and green roofs this is the degree to
                which the unit's soil is initially filled with water (0 % saturation
                corresponds to the wilting point moisture content, 100 % saturation has
                the moisture content equal to the porosity). The storage zone beneath
                the soil zone of the cell is assumed to be completely dry. For other types
                of LIDs it corresponds to the degree to which their storage zone is
                initially filled with water
            impervious_portion (float): Percent of the impervious portion of the subcatchment’s non-LID area
                whose runoff is treated by the LID practice. (E.g., if rain barrels are used
                to capture roof runoff and roofs represent 60% of the impervious area,
                then the impervious area treated is 60%). If the LID unit treats only direct
                rainfall, such as with a green roof, then this value should be 0. If the LID
                takes up the entire subcatchment then this field is ignored.
            route_to_pervious (int): A value of 1 indicates that the surface and drain flow from the LID unit
                should be routed back onto the pervious area of the subcatchment that
                contains it. This would be a common choice to make for rain barrels,
                rooftop disconnection, and possibly green roofs. The default value is 0.
            fn_lid_report (str): Optional name of a file to which detailed time series results for the LID
                will be written. Enclose the name in double quotes if it contains spaces
                and include the full path if it is different than the SWMM input file path.
                Use ‘*’ if not applicable and an entry for DrainTo follows
            drain_to (str): Optional name of subcatchment or node that receives flow from the unit’s
                drain line, if different from the outlet of the subcatchment that the LID is
                placed in.
            from_pervious (float): optional percent of the pervious portion of the subcatchment’s non-LID area
                whose runoff is treated by the LID practice. The default value is 0.
        """
        self.subcatchment = str(subcatchment)
        self.lid = str(lid)
        self.n_replicate = n_replicate
        self.area = float(area)
        self.width = float(width)
        self.saturation_init = float(saturation_init)
        self.impervious_portion = float(impervious_portion)
        self.route_to_pervious = int(route_to_pervious)
        self.fn_lid_report = convert_string(fn_lid_report)
        self.drain_to = drain_to
        self.from_pervious = from_pervious
