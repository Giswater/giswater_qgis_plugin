import numpy as np

from ._identifiers import IDENTIFIERS
from ..helpers import BaseSectionObject
from .._type_converter import to_bool, infer_type, convert_args
from ..section_labels import JUNCTIONS, OUTFALLS, STORAGE, DIVIDERS


class _Node(BaseSectionObject):
    _identifier = IDENTIFIERS.name

    def __init__(self, name, elevation):
        self.name = str(name)
        self.elevation = float(elevation)


class Junction(_Node):
    """
    Junction node information.

    Section:
        [JUNCTIONS]

    Purpose:
        Identifies each junction node of the drainage system.
        Junctions are points in space where channels and pipes connect together.
        For sewer systems they can be either connection fittings or manholes.

    Remarks:
        If :attr:`Junction.depth_max` is 0 then SWMM sets the maximum depth equal to the distance
        from the invert to the top of the highest connecting link.

        If the junction is part of a force main section of the system then set :attr:`Junction.depth_surcharge`
        to the maximum pressure that the system can sustain.

        Surface ponding can only occur when :attr:`Junction.area_ponded` is non-zero and the ``ALLOW_PONDING`` analysis option is turned on.

    Attributes:
        name (str): Name assigned to junction node.
        elevation (float): Elevation of junction invert (ft or m).
        depth_max (float): Depth from ground to invert elevation (ft or m) (default is 0).
        depth_init (float): Water depth at start of simulation (ft or m) (default is 0).
        depth_surcharge (float): Maximum additional pressure head above ground elevation that manhole junction
                            can sustain under surcharge conditions (ft or m) (default is 0).
        area_ponded (float): Area subjected to surface ponding once water depth exceeds :attr:`Junction.depth_max` + :attr:`Junction.depth_surcharge` (ft2 or m2) (default is 0).
    """
    _section_label = JUNCTIONS

    def __init__(self, name, elevation, depth_max=0, depth_init=0, depth_surcharge=0, area_ponded=0):
        """
        Junction node information.

        Args:
            name (str): Name assigned to junction node.
            elevation (float): Elevation of junction invert (ft or m).
            depth_max (float): Depth from ground to invert elevation (ft or m) (default is 0).
            depth_init (float): Water depth at start of simulation (ft or m) (default is 0).
            depth_surcharge (float): Maximum additional pressure head above ground elevation that manhole junction can sustain under surcharge conditions (ft or m) (default is 0).
            area_ponded (float): Area subjected to surface ponding once water depth exceeds :attr:`Junction.depth_max` + :attr:`Junction.depth_surcharge` (ft2 or m2) (default is 0).
        """
        _Node.__init__(self, name, elevation)
        self.depth_max = float(depth_max)
        self.depth_init = float(depth_init)
        self.depth_surcharge = float(depth_surcharge)
        self.area_ponded = float(area_ponded)


class Outfall(_Node):
    """
    Outfall node information.

    Section:
        [OUTFALLS]

    Purpose:
        Identifies each outfall node (i.e., final downstream boundary) of the drainage system and the corresponding
        water stage elevation. Only one link can be incident on an outfall node.

    Formats in .inp-file:
        ::

            Name Elev FREE               (Gated) (RouteTo)
            Name Elev NORMAL             (Gated) (RouteTo)
            Name Elev FIXED      Stage   (Gated) (RouteTo)
            Name Elev TIDAL      Tcurve  (Gated) (RouteTo)
            Name Elev TIMESERIES Tseries (Gated) (RouteTo)

    Attributes:
        name (str): name assigned to outfall node.
        elevation (float): invert elevation (ft or m).
        kind (str): one of ``FREE``, ``NORMAL``, ``FIXED``, ``TIDAL``, ``TIMESERIES`` (or use :attr:`Outfall.TYPES`)
        data (float | str): one of the following

            - Stage (float): elevation of fixed stage outfall (ft or m). (for ``FIXED``-Type)
            - Tcurve (str): name of curve in [``CURVES``] section (:class:`Curve`) containing tidal height (i.e., outfall stage) v. hour of day over a complete tidal cycle. (for ``TIDAL``-Type)
            - Tseries (str): name of time series in [``TIMESERIES``] section (:class:`Timeseries`) that describes how outfall stage varies with time. (for ``TIMESERIES``-Type)

        has_flap_gate (bool): ``YES`` (:obj:`True`) or ``NO`` (:obj:`False`) depending on whether a flap gate is present that prevents reverse flow. The default is ``NO``.
        route_to (str): name of a subcatchment that receives the outfall's discharge. The default is not to route the outfall’s discharge.
        
        TYPES: Enum-like for the attribute :attr:`Outfall.kind` with following members -> {``FREE`` | ``NORMAL`` | ``FIXED`` | ``TIDAL`` | ``TIMESERIES``}
    """
    _section_label = OUTFALLS

    class TYPES:
        FREE = 'FREE'
        NORMAL = 'NORMAL'
        FIXED = 'FIXED'
        TIDAL = 'TIDAL'
        TIMESERIES = 'TIMESERIES'

    def __init__(self, name, elevation, kind, *args, data=np.nan, has_flap_gate=False, route_to=np.nan): # Outfall node information.
        """
        Outfall node information.

        Args:
            name (str): name assigned to outfall node.
            elevation (float): invert elevation (ft or m).
            kind (str): one of ``FREE``, ``NORMAL``, ``FIXED``, ``TIDAL``, ``TIMESERIES`` (or use :attr:`Outfall.TYPES`)
            *args: -Arguments below- (for automatic input file reader.)
            data (float | str): one of the following

                - Stage (float): elevation of fixed stage outfall (ft or m). (for ``FIXED``-Type)
                - Tcurve (str): name of curve in [``CURVES``] section (:class:`Curve`) containing tidal height (i.e., outfall stage) v. hour of day over a complete tidal cycle. (for ``TIDAL``-Type)
                - Tseries (str): name of time series in [``TIMESERIES``] section (:class:`Timeseries`) that describes how outfall stage varies with time. (for ``TIMESERIES``-Type)

            has_flap_gate (bool): ``YES`` (:obj:`True`) or ``NO`` (:obj:`False`) depending on whether a flap gate is present that prevents reverse flow. The default is ``NO``.
            route_to (str): name of a subcatchment that receives the outfall's discharge. The default is not to route the outfall’s discharge.
        """
        _Node.__init__(self, name, elevation)
        self.kind = kind
        self.data = np.nan

        if args:
            if (kind in [Outfall.TYPES.FIXED, Outfall.TYPES.TIDAL, Outfall.TYPES.TIMESERIES]) or (len(args) == 3):
                self._data_init(*args)
            else:
                self._no_data_init(*args)
        else:
            self.data = data
            self.has_flap_gate = to_bool(has_flap_gate)
            self.route_to = route_to

    def _no_data_init(self, has_flap_gate=False, route_to=np.nan):
        """
        Init function if no keyword arguments were used and outfall has no data.

        Args:
            has_flap_gate (bool): ``YES`` (:obj:`True`) or ``NO`` (:obj:`False`) depending on whether a flap gate is present that prevents reverse flow. The default is ``NO``.
            route_to (str): name of a subcatchment that receives the outfall's discharge. The default is not to route the outfall’s discharge.
        """
        self.has_flap_gate = to_bool(has_flap_gate)
        self.route_to = route_to

    def _data_init(self, data=np.nan, has_flap_gate=False, route_to=np.nan):
        """
        Init function if no keyword arguments were used and outfall has data.

        Args:
            data (float | str): one of the following

                - Stage (float): elevation of fixed stage outfall (ft or m). (for ``FIXED``-Type)
                - Tcurve (str): name of curve in [``CURVES``] section (:class:`Curve`) containing tidal height (i.e., outfall stage) v. hour of day over a complete tidal cycle. (for ``TIDAL``-Type)
                - Tseries (str): name of time series in [``TIMESERIES``] section (:class:`Timeseries`) that describes how outfall stage varies with time. (for ``TIMESERIES``-Type)

            has_flap_gate (bool): ``YES`` (:obj:`True`) or ``NO`` (:obj:`False`) depending on whether a flap gate is present that prevents reverse flow. The default is ``NO``.
            route_to (str): name of a subcatchment that receives the outfall's discharge. The default is not to route the outfall’s discharge.
        """
        self.data = data
        self.has_flap_gate = to_bool(has_flap_gate)
        self.route_to = route_to

    @property
    def curve_name(self):
        """Name of the curve if outfall-kind is ``TIDAL``"""
        if self.kind == self.TYPES.TIDAL:
            return self.data


class Storage(_Node):
    """
    Storage node information.

    Section:
        [STORAGE]

    Purpose:
        Identifies each storage node of the drainage system.
        Storage nodes can have any shape as specified by a surface area versus water depth relation.

    Format in .inp-file:
        ::

            Name Elev Ymax Y0 TABULAR    Acurve   (Apond Fevap Psi Ksat IMD)
            Name Elev Ymax Y0 FUNCTIONAL A1 A2 A0 (Apond Fevap Psi Ksat IMD)
            Name Elev Ymax Y0 Shape      L  W  Z  (Ysur  Fevap Psi Ksat IMD)

    Remarks:
        A1, A2, and A0 are used in the following expression that relates surface area (ft2 or m2) to water depth
        (ft or m) for a storage unit with ``FUNCTIONAL`` geometry:

        :math:`Area = A0 + A1 * Depth ^ {A2}`

        For ``TABULAR`` geometry, the surface area curve will be extrapolated outwards to meet the unit's maximum depth
        if need be.

        The dimensions of storage units with other shapes are defined as follows:
            - ``CYLINDRICAL``

                - L = major axis length
                - W = minor axis width
                - Z = not used

            - ``CONICAL``

                - L = major axis length of base
                - W = minor axis width of base
                - Z = side slope (run/rise)

            - ``PARABOLOID``

                - L = major axis length at full height
                - W = minor axis width at full height
                - Z = full height

            - ``PYRAMIDAL``

                - L = base length
                - W = base width
                - Z = side slope (run/rise)

        The parameters :attr:`suction_head`, :attr:`hydraulic_conductivity`, and :attr:`moisture_deficit_init`
        need only be supplied if seepage loss through the soil at the bottom and
        sloped sides of the storage unit should be considered.
        They are the same Green-Ampt infiltration parameters described in the [``INFILTRATION``] section. (
        :class:`InfiltrationGreenAmpt`)
        If :attr:`hydraulic_conductivity` is zero then no seepage occurs while if :attr:`moisture_deficit_init`
        is zero then seepage occurs at a constant rate equal to :attr:`hydraulic_conductivity`.
        Otherwise seepage rate will vary with storage depth.

    Attributes:
         name (str): Name assigned to storage node.
         elevation (float): Node's invert elevation (ft or m).
         depth_max (float): Maximum water depth possible (ft or m).
         depth_init (float): Water depth at the start of the simulation (ft or m).
         kind (str): One of :attr:`Storage.TYPES` (``TABULAR`` | ``FUNCTIONAL``), or :attr:`Storage.SHAPES`
         data (str | list):

            - :obj:`str`: name of curve in [``CURVES``] section with surface area (ft2 or m2) as a function of depth (ft or m) for ``TABULAR`` geometry.
            - :obj:`list`: ``FUNCTIONAL`` relation between surface area and depth with

                - A1 (:obj:`float`): coefficient
                - A2 (:obj:`float`): exponent
                - A0 (:obj:`float`): constant

         depth_surcharge (float): maximum additional pressure head above full depth that a closed storage unit can sustain under surcharge conditions (ft or m) (default is 0).
         frac_evaporation (float): fraction of potential evaporation from the storage unit’s water surface realized (default is 0).
         suction_head (float): Soil suction head (inches or mm).
         hydraulic_conductivity (float): Soil saturated hydraulic conductivity (in/hr or mm/hr).
         moisture_deficit_init (float): Soil initial moisture deficit (porosity minus moisture content) (fraction).

         TYPES: Enum-like for the attribute :attr:`Storage.kind` with following members -> {``TABULAR`` | ``FUNCTIONAL``}
         SHAPES: Enum-like for the attribute :attr:`Storage.kind` with following members -> {``CYLINDRICAL`` | ``CONICAL`` | ``PARABOLOID`` | ``PYRAMIDAL``}
    """
    _section_label = STORAGE

    class TYPES:
        TABULAR = 'TABULAR'
        FUNCTIONAL = 'FUNCTIONAL'

    class SHAPES:
        CYLINDRICAL = 'CYLINDRICAL'
        CONICAL = 'CONICAL'
        PARABOLOID = 'PARABOLOID'
        PYRAMIDAL = 'PYRAMIDAL'

        _possible = (CYLINDRICAL, CONICAL, PARABOLOID, PYRAMIDAL)

    def __init__(self, name, elevation, depth_max, depth_init, kind, *args, data=None,
                 depth_surcharge=0., frac_evaporation=0.,
                 suction_head=np.nan, hydraulic_conductivity=np.nan, moisture_deficit_init=np.nan):
        """
        Storage node information.

        Args:
             name (str): Name assigned to storage node.
             elevation (float): Node's invert elevation (ft or m).
             depth_max (float): Maximum water depth possible (ft or m).
             depth_init (float): Water depth at the start of the simulation (ft or m).
             kind (str): One of :attr:`Storage.TYPES` (``TABULAR`` | ``FUNCTIONAL``) or :attr:`Storage.SHAPES` ( ``CYLINDRICAL`` | ``CONICAL`` | ``PARABOLOID`` | ``PYRAMIDAL``)
             *args: -Arguments below- (for automatic input file reader.)
             data (str | list):

                - :obj:`str`: name of curve in [``CURVES``] section with surface area (ft2 or m2) as a function of depth (ft or m) for ``TABULAR`` geometry.
                - :obj:`list`: ``FUNCTIONAL`` relation between surface area and depth with

                    - A1 (:obj:`float`): coefficient
                    - A2 (:obj:`float`): exponent
                    - A0 (:obj:`float`): constant

             depth_surcharge (float): maximum additional pressure head above full depth that a closed storage unit can sustain under surcharge conditions (ft or m) (default is 0).
             frac_evaporation (float): fraction of potential evaporation from the storage unit’s water surface realized (default is 0).
             suction_head (float): Soil suction head (inches or mm).
             hydraulic_conductivity (float): Soil saturated hydraulic conductivity (in/hr or mm/hr).
             moisture_deficit_init (float): Soil initial moisture deficit (porosity minus moisture content) (fraction).
        """
        _Node.__init__(self, name, elevation)
        self.depth_max = float(depth_max)
        self.depth_init = float(depth_init)
        self.kind = kind

        if args:
            args = convert_args(args)

            if kind == Storage.TYPES.TABULAR:
                self._tabular_init(*args)

            elif kind == Storage.TYPES.FUNCTIONAL:
                self._functional_init(*args)

            elif kind in Storage.SHAPES._possible:
                self._shape_init(*args)

            else:
                raise NotImplementedError()
        else:
            self.data = data
            self._optional_args(depth_surcharge, frac_evaporation,
                                suction_head, hydraulic_conductivity, moisture_deficit_init)

    def _functional_init(self, coefficient, exponent, constant, *args, **kwargs):
        """
        Init for ``FUNCTIONAL`` relation between surface area and depth.

        Area = constant + coefficient * Depth ^ exponent

        Args:
            coefficient (float): coefficient of FUNCTIONAL relation between surface area and depth.
            exponent (float): exponent of FUNCTIONAL relation between surface area and depth.
            constant (float): constant of FUNCTIONAL relation between surface area and depth.

            depth_surcharge: maximum additional pressure head above full depth that a closed storage unit
                can sustain under surcharge conditions (ft or m) (default is 0).
            frac_evaporation (float): fraction of potential evaporation from the storage unit’s water surface realized
                (default is 0).
        """
        self.data = [float(coefficient), float(exponent), float(constant)]
        self._optional_args(*args, **kwargs)

    def _tabular_init(self, curve_name, *args, **kwargs):
        """
        for storage type ``'TABULAR'``

        Args:
            curve_name (str): name of curve in [CURVES] section with surface area (ft2 or m2)
                as a function of depth (ft or m) for TABULAR geometry.
            depth_surcharge: maximum additional pressure head above full depth that a closed storage unit
                can sustain under surcharge conditions (ft or m) (default is 0).
            frac_evaporation (float): fraction of potential evaporation from the storage unit’s water surface realized
                (default is 0).
        """
        self.data = curve_name
        args = convert_args(args)
        self._optional_args(*args, **kwargs)

    def _shape_init(self, L, W, Z, *args, **kwargs):
        """
        for storage type ``'FUNCTIONAL'``

        Args:
            L, W, Z: dimensions of the storage unit's shape (see table below).

            depth_surcharge: maximum additional pressure head above full depth that a closed storage unit
                can sustain under surcharge conditions (ft or m) (default is 0).
            frac_evaporation (float): fraction of potential evaporation from the storage unit’s water surface realized
                (default is 0).
        """
        self.data = infer_type([L, W, Z])
        self._optional_args(*args, **kwargs)

    def _optional_args(self, depth_surcharge=0., frac_evaporation=0., *exfiltration_args, **exfiltration_kwargs):
        """
        for the optional arguemts

        Args:
            depth_surcharge: maximum additional pressure head above full depth that a closed storage unit
                can sustain under surcharge conditions (ft or m) (default is 0).
            frac_evaporation (float): fraction of potential evaporation from the storage unit’s water surface realized
                (default is 0).
        """
        self.depth_surcharge = float(depth_surcharge)
        self.frac_evaporation = float(frac_evaporation)
        self._exfiltration_args(*exfiltration_args, **exfiltration_kwargs)

    def _exfiltration_args(self, suction_head=np.nan, hydraulic_conductivity=np.nan, moisture_deficit_init=np.nan):
        """
        Optional seepage parameters for soil surrounding the storage unit:

        Args:
            suction_head (float): Soil suction head (inches or mm).
            hydraulic_conductivity (float): Soil saturated hydraulic conductivity (in/hr or mm/hr).
            moisture_deficit_init (float): Soil initial moisture deficit (porosity minus moisture content) (fraction).
        """
        self.suction_head = float(suction_head)
        self.hydraulic_conductivity = float(hydraulic_conductivity)
        self.moisture_deficit_init = float(moisture_deficit_init)

    @property
    def curve_name(self):
        """Name of the curve if storage-kind is ``TABULAR``"""
        if self.kind == self.TYPES.TABULAR:
            return self.data


class Divider(_Node):
    r"""
    Flow divider node information.

    Section:
        [DIVIDERS]

    Purpose:
        Identifies each flow divider node of the drainage system. Flow dividers are junctions with
        exactly two outflow conduits where the total outflow is divided between the two in a prescribed manner.

    Formats in .inp-file:
        ::

            Name Elev DivLink OVERFLOW            (Ymax Y0 Ysur Apond)
            Name Elev DivLink CUTOFF   Qmin       (Ymax Y0 Ysur Apond)
            Name Elev DivLink TABULAR  Dcurve     (Ymax Y0 Ysur Apond)
            Name Elev DivLink WEIR     Qmin Ht Cd (Ymax Y0 Ysur Apond)

    Attributes:
        name (str): Name assigned to divider node.
        elevation (float): Node’s invert elevation (ft or m).
        link (str): name of the link to which flow is diverted.
        kind (str): one of ``OVERFLOW``, ``CUTOFF``, ``TABULAR``, ``WEIR`` (or use :attr:`Divider.TYPES`).
        data (float | str | list): one of ...

            - flow_begin (float): flow at which diversion begins for either a CUTOFF or WEIR divider (flow units).
            - curve (str): name of a curve for a TABULAR divider that relates diverted flow to total flow.
            - height (float): height of a WEIR divider (ft or m).
            - discharge_coefficient (float): discharge coefficient for a WEIR divider.

        depth_max (float): Depth from ground to invert elevation (ft or m) (default is 0).
        depth_init (float): Water depth at start of simulation (ft or m) (default is 0).
        depth_surcharge (float): Maximum additional head above ground elevation that manhole junction
                            can sustain under surcharge conditions (ft or m) (default is 0).
        area_ponded (float): Area subjected to surface ponding once water depth exceeds :attr:`Divider.depth_max` (ft2 or m2) (default is 0).

        TYPES: Enum-like for the attribute :attr:`Divider.kind` with following members -> {``OVERFLOW`` | ``CUTOFF`` | ``TABULAR`` | ``WEIR``}

    Remarks:
        If :attr:`Divider.depth_max` is 0 then SWMM sets the node’s maximum depth equal to the distance from its invert to the top of the highest connecting link.

        Surface ponding can only occur when :attr:`Divider.area_ponded` is non-zero and the ALLOW_PONDING analysis option is turned on.

        Divider nodes are only active under the Steady Flow or Kinematic Wave analysis options.
        For Dynamic Wave flow routing they behave the same as Junction nodes.

        .. math::

            discharge\_coefficient * weir\_height ^ {3/2} > flow\_begin

        The value of the discharge coefficient times the weir height raised to the 3/2 power must be greater than the minimum flow parameter
    """
    _section_label = DIVIDERS

    class TYPES:
        OVERFLOW = 'OVERFLOW'
        CUTOFF = 'CUTOFF'
        TABULAR = 'TABULAR'
        WEIR = 'WEIR'

    def __init__(self, name, elevation, link, kind, *args, data=None, depth_max=0, depth_init=0, depth_surcharge=0, area_ponded=0):
        """
        Flow divider node information.

        Args:
            name (str): Name assigned to divider node.
            elevation (float): Node’s invert elevation (ft or m).
            link (str): name of the link to which flow is diverted.
            kind (str): one of ``OVERFLOW``, ``CUTOFF``, ``TABULAR``, ``WEIR`` (or use :attr:`Divider.TYPES`).
            data (float | str | list): one of ...

                - flow_begin (float): flow at which diversion begins for either a CUTOFF or WEIR divider (flow units).
                - curve (str): name of a curve for a TABULAR divider that relates diverted flow to total flow.
                - height (float): height of a WEIR divider (ft or m).
                - discharge_coefficient (float): discharge coefficient for a WEIR divider.

            depth_max (float): Depth from ground to invert elevation (ft or m) (default is 0).
            depth_init (float): Water depth at start of simulation (ft or m) (default is 0).
            depth_surcharge (float): Maximum additional head above ground elevation that manhole junction
                                can sustain under surcharge conditions (ft or m) (default is 0).
            area_ponded (float): Area subjected to surface ponding once water depth exceeds :attr:`Junction.depth_max` (ft2 or m2) (default is 0).
        """
        _Node.__init__(self, name, elevation)
        self.link = str(link)
        self.kind = kind

        if args:
            if kind == self.TYPES.OVERFLOW:
                self._optional_args(*args)
            elif kind == self.TYPES.CUTOFF:
                self._init_cutoff(*args)
            elif kind == self.TYPES.TABULAR:
                self._init_tabular(*args)
            elif kind == self.TYPES.WEIR:
                self._init_weir(*args)

            else:
                raise NotImplementedError()
        else:
            self.data = data
            self._optional_args(depth_max, depth_init, depth_surcharge, area_ponded)

    def _init_cutoff(self, flow_begin, *args, **kwargs):
        """
        Init for ``CUTOFF``.

        Args:
            flow_begin (float): flow at which diversion begins for either a CUTOFF or WEIR divider (flow units).
        """
        self.data = float(flow_begin)
        self._optional_args(*args, **kwargs)

    def _init_tabular(self, curve, *args, **kwargs):
        """
        Init for ``CUTOFF``.

        Args:
            curve (str): name of a curve for a TABULAR divider that relates diverted flow to total flow.
        """
        self.data = str(curve)
        self._optional_args(*args, **kwargs)

    def _init_weir(self, flow_begin, height, discharge_coefficient, *args, **kwargs):
        """
        Init for ``CUTOFF``.

        Args:
            flow_begin (float): flow at which diversion begins for either a CUTOFF or WEIR divider (flow units).
            height (float): height of a WEIR divider (ft or m).
            discharge_coefficient (float): discharge coefficient for a WEIR divider.
        """
        self.data = [float(flow_begin), float(height), float(discharge_coefficient)]
        self._optional_args(*args, **kwargs)

    def _optional_args(self, depth_max=0, depth_init=0, depth_surcharge=0, area_ponded=0):
        """
        Optional node parameters.

        Args:
            depth_max (float): Depth from ground to invert elevation (ft or m) (default is 0).
            depth_init (float): Water depth at start of simulation (ft or m) (default is 0).
            depth_surcharge (float): Maximum additional pressure head above ground elevation that the node can sustain under surcharge conditions (ft or m) (default is 0).
            area_ponded (float): Area subjected to surface ponding once water depth exceeds :attr:`Divider.depth_max` + :attr:`Divider.depth_surcharge` (ft2 or m2) (default is 0).
        """
        self.depth_max = float(depth_max)
        self.depth_init = float(depth_init)
        self.depth_surcharge = float(depth_surcharge)
        self.area_ponded = float(area_ponded)

    @property
    def curve_name(self):
        """Name of the curve if Divider-kind is ``TABULAR``"""
        if self.kind == self.TYPES.TABULAR:
            return self.data
