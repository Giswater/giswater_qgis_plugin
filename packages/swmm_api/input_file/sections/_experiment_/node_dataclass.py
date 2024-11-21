# from abc import ABC
#
# from numpy import nan
# from attrs import define, field, converters
#
# from ._identifiers import IDENTIFIERS
# from ..helpers import BaseSectionObject
# from .._type_converter import to_bool, infer_type
# from ..section_labels import JUNCTIONS, OUTFALLS, STORAGE
#
# @define
# class _Node(BaseSectionObject, ABC):
#     _identifier = field(init=False, default=IDENTIFIERS.name)  # how to not include in anything?
#
#     name: str = field(converter=str)
#     elevation: float = field(converter=float)
#
#
# @define
# class Junction(_Node):
#     """
#     Junction node information.
#
#     Section:
#         [JUNCTIONS]
#
#     Purpose:
#         Identifies each junction node of the drainage system.
#         Junctions are points in space where channels and pipes connect together.
#         For sewer systems they can be either connection fittings or manholes.
#
#     Remarks:
#         If Ymax is 0 then SWMM sets the maximum depth equal to the distance
#         from the invert to the top of the highest connecting link.
#
#         If the junction is part of a force main section of the system then set Ysur
#         to the maximum pressure that the system can sustain.
#
#         Surface ponding can only occur when Apond is non-zero and the ALLOW_PONDING analysis option is turned on.
#
#     Attributes:
#         name (str): Name assigned to junction node.
#         elevation (float): Elevation of junction invert (ft or m).
#         depth_max (float): Depth from ground to invert elevation (ft or m) (default is 0).
#         depth_init (float): Water depth at start of simulation (ft or m) (default is 0).
#         depth_surcharge (float): Maximum additional head above ground elevation that manhole junction
#                             can sustain under surcharge conditions (ft or m) (default is 0).
#         area_ponded (float): Area subjected to surface ponding once water depth exceeds Ymax (ft2 or m2) (default is 0).
#     """
#     _section_label = field(init=False, default=JUNCTIONS)
#
#     depth_max: float = field(converter=float, default=0)
#     depth_init: float = field(converter=float, default=0)
#     depth_surcharge: float = field(converter=float, default=0)
#     area_ponded: float = field(converter=float, default=0)
#
#
# class Outfall(_Node):
#     """
#     Outfall node information.
#
#     Section:
#         [OUTFALLS]
#
#     Purpose:
#         Identifies each outfall node (i.e., final downstream boundary) of the drainage system and the corresponding
#         water stage elevation. Only one link can be incident on an outfall node.
#
#     Formats:
#         ::
#
#             Name Elev FREE               (Gated) (RouteTo)
#             Name Elev NORMAL             (Gated) (RouteTo)
#             Name Elev FIXED      Stage   (Gated) (RouteTo)
#             Name Elev TIDAL      Tcurve  (Gated) (RouteTo)
#             Name Elev TIMESERIES Tseries (Gated) (RouteTo)
#
#     Formats-PCSWMM:
#         ``Name  InvertElev  OutfallType  Stage/Table/TimeSeries  TideGate  RouteTo``
#
#     Format-SWMM-GUI:
#         ``Name  Elevation  Type  StageData  Gated  RouteTo``
#
#     Attributes:
#         name (str): name assigned to outfall node.
#         elevation (float): invert elevation (ft or m). ``Elev``
#         kind (str): one of ``FREE``, ``NORMAL``, ``FIXED``, ``TIDAL``, ``TIMESERIES``
#         data (float | str): one of the following
#
#             - Stage (float): elevation of fixed stage outfall (ft or m). for ``FIXED``-Type
#             - Tcurve (str): name of curve in [``CURVES``] section containing tidal height (i.e., outfall stage) v.
#             hour of day over a complete tidal cycle. for ``TIDAL``-Type
#             - Tseries (str): name of time series in [``TIMESERIES``] section that describes how outfall stage varies
#             with time.  for ``TIMESERIES``-Type
#         has_flap_gate (bool, Optional): ``YES`` (:obj:`True`) or ``NO`` (:obj:`False`) depending on whether a flap gate is present that prevents
#         reverse flow. The default is ``NO``. ``Gated``
#         route_to (str, Optional): name of a subcatchment that receives the outfall's discharge. The default is not to
#         route the outfall’s discharge.
#     """
#     _section_label = OUTFALLS
#
#     class TYPES:
#         FREE = 'FREE'
#         NORMAL = 'NORMAL'
#         FIXED = 'FIXED'
#         TIDAL = 'TIDAL'
#         TIMESERIES = 'TIMESERIES'
#
#     def __init__(self, name, elevation, kind, *args, data=nan, has_flap_gate=False, route_to=nan): # Outfall node information.
#         _Node.__init__(self, name, elevation)
#         self.kind = kind
#         self.data = nan
#
#         if args:
#             if kind in [Outfall.TYPES.FIXED,
#                         Outfall.TYPES.TIDAL,
#                         Outfall.TYPES.TIMESERIES]:
#                 self._data_init(*args)
#             elif len(args) == 3:
#                 self._data_init(*args)
#             else:
#                 self._no_data_init(*args)
#         else:
#             self.data = data
#             self.has_flap_gate = to_bool(has_flap_gate)
#             self.route_to = route_to
#
#     def _no_data_init(self, has_flap_gate=False, route_to=nan):
#         """
#         If no keyword arguments were used.
#
#         Args:
#             has_flap_gate (bool): YES or NO depending on whether a flap gate is present that prevents reverse flow. The
#             default is NO.
#             route_to (str): optional name of a subcatchment that receives the outfall's discharge.
#                            The default is not to route the outfall’s discharge.
#         """
#         self.has_flap_gate = to_bool(has_flap_gate)
#         self.route_to = route_to
#
#     def _data_init(self, data=nan, has_flap_gate=False, route_to=nan):
#         """
#         If no keyword arguments were used.
#
#         Args:
#             data (float | str): one of the following
#                 Stage (float): elevation of fixed stage outfall (ft or m).
#                 Tcurve (str): name of curve in [CURVES] section containing tidal height (i.e., outfall stage) v. hour of day over a complete tidal cycle.
#                 Tseries (str): name of time series in [TIMESERIES] section that describes how outfall stage varies with time.
#             has_flap_gate (bool): YES or NO depending on whether a flap gate is present that prevents reverse flow. The default is NO.
#             route_to (str): optional name of a subcatchment that receives the outfall's discharge. The default is not to route the outfall’s discharge.
#         """
#         self.data = data
#         self.has_flap_gate = to_bool(has_flap_gate)
#         self.route_to = route_to
#
#
# class Storage(_Node):
#     """
#     Storage node information.
#
#     Section:
#         [STORAGE]
#
#     Purpose:
#         Identifies each storage node of the drainage system.
#         Storage nodes can have any shape as specified by a surface area versus water depth relation.
#
#     Format:
#         ::
#
#             Name Elev Ymax Y0 TABULAR    Acurve   (Apond Fevap Psi Ksat IMD)
#             Name Elev Ymax Y0 FUNCTIONAL A1 A2 A0 (Apond Fevap Psi Ksat IMD)
#             Name Elev Ymax Y0 Shape      L  W  Z  (Ysur  Fevap Psi Ksat IMD)
#
#     Remarks:
#         A1, A2, and A0 are used in the following expression that relates surface area (ft2 or m2) to water depth
#         (ft or m) for a storage unit with ``FUNCTIONAL`` geometry:
#
#         Area = A0 + A1 * Depth ^ A2
#
#         For ``TABULAR`` geometry, the surface area curve will be extrapolated outwards to meet the unit's maximum depth
#         if need be.
#
#         The dimensions of storage units with other shapes are defined as follows:
#             - ``CYLINDRICAL``
#
#                 - L = major axis length
#                 - W = minor axis width
#                 - Z = not used
#
#             - ``CONICAL``
#
#                 - L = major axis length of base |
#                 - W = minor axis width of base |
#                 - Z = side slope (run/rise)
#
#             - ``PARABOLOID``
#
#                 - L = major axis length at full height |
#                 - W = minor axis width at full height |
#                 - Z = full height
#
#             - ``PYRAMIDAL``
#
#                 - L = base length |
#                 - W = base width |
#                 - Z = side slope (run/rise)
#
#         The parameters :attr:`suction_head`, :attr:`hydraulic_conductivity`, and :attr:`moisture_deficit_init`
#         need only be supplied if seepage loss through the soil at the bottom and
#         sloped sides of the storage unit should be considered.
#         They are the same Green-Ampt infiltration parameters described in the [``INFILTRATION``] section. (
#         :class:`InfiltrationGreenAmpt`)
#         If :attr:`hydraulic_conductivity` is zero then no seepage occurs while if :attr:`moisture_deficit_init`
#         is zero then seepage occurs at a constant rate equal to :attr:`hydraulic_conductivity`.
#         Otherwise seepage rate will vary with storage depth.
#
#     From C-Code:
#         ::
#
#             //  Format of input line is:
#             //     nodeID  elev  maxDepth  initDepth  FUNCTIONAL a1 a2 a0 surDepth fEvap (infil) //(5.1.013)
#             //     nodeID  elev  maxDepth  initDepth  TABULAR    curveID  surDepth fEvap (infil) //
#
#     Attributes:
#          name (str): Name assigned to storage node.
#          elevation (float): Node's invert elevation (ft or m).
#          depth_max (float): Maximum water depth possible (ft or m).
#          depth_init (float): Water depth at the start of the simulation (ft or m).
#          kind (str): One of :attr:`Storage.TYPES` (``TABULAR`` | ``FUNCTIONAL``), or One of :attr:`Storage.SHAPES`
#          data (str | list):
#
#             - :obj:`str`: name of curve in [``CURVES``] section with surface area (ft2 or m2) as a function of depth
#             (ft or m) for ``TABULAR`` geometry.
#             - :obj:`list`: ``FUNCTIONAL`` relation between surface area and depth with
#
#                 - A1 (:obj:`float`): coefficient
#                 - A2 (:obj:`float`): exponent
#                 - A0 (:obj:`float`): constant
#
#          depth_surcharge: maximum additional pressure head above full depth that a closed storage unit
#             can sustain under surcharge conditions (ft or m) (default is 0).
#          frac_evaporation (float): fraction of potential evaporation from the storage unit’s water surface realized
#             (default is 0).
#          suction_head (float): Soil suction head (inches or mm).
#          hydraulic_conductivity (float): Soil saturated hydraulic conductivity (in/hr or mm/hr).
#          moisture_deficit_init (float): Soil initial moisture deficit (porosity minus moisture content) (fraction).
#          TYPES: ``Storage.TYPES.TABULAR``, ``Storage.TYPES.FUNCTIONAL``
#     """
#     _section_label = STORAGE
#
#     class TYPES:
#         TABULAR = 'TABULAR'
#         FUNCTIONAL = 'FUNCTIONAL'
#
#     class SHAPES:
#         CYLINDRICAL = 'CYLINDRICAL'
#         CONICAL = 'CONICAL'
#         PARABOLOID = 'PARABOLOID'
#         PYRAMIDAL = 'PYRAMIDAL'
#
#         _possible = (CYLINDRICAL, CONICAL, PARABOLOID, PYRAMIDAL)
#
#     def __init__(self, name, elevation, depth_max, depth_init, kind, *args, data=None,
#                  depth_surcharge=0, frac_evaporation=0,
#                  suction_head=nan, hydraulic_conductivity=nan, moisture_deficit_init=nan):
#         """
#         Storage node information.
#
#         Args:
#              name (str): Name assigned to storage node.
#              elevation (float): Node's invert elevation (ft or m).
#              depth_max (float): Maximum water depth possible (ft or m).
#              depth_init (float): Water depth at the start of the simulation (ft or m).
#              kind (str): One of :attr:`Storage.TYPES` (``TABULAR`` | ``FUNCTIONAL``) or one of :attr:`Storage.SHAPES`
#              ( ``CYLINDRICAL`` | ``CONICAL`` | ``PARABOLOID`` | ``PYRAMIDAL``)
#              *args: -Arguments below- (for automatic input file reader.)
#              data (str | list):
#
#                 - :obj:`str`: name of curve in [``CURVES``] section with surface area (ft2 or m2) as a function of
#                 depth (ft or m) for ``TABULAR`` geometry.
#                 - :obj:`list`: ``FUNCTIONAL`` relation between surface area and depth with
#
#                     - A1 (:obj:`float`): coefficient
#                     - A2 (:obj:`float`): exponent
#                     - A0 (:obj:`float`): constant
#
#              depth_surcharge: maximum additional pressure head above full depth that a closed storage unit
#                 can sustain under surcharge conditions (ft or m) (default is 0).
#              frac_evaporation (float): fraction of potential evaporation from the storage unit’s water surface realized
#                 (default is 0).
#              suction_head (float): Soil suction head (inches or mm).
#              hydraulic_conductivity (float): Soil saturated hydraulic conductivity (in/hr or mm/hr).
#              moisture_deficit_init (float): Soil initial moisture deficit (porosity minus moisture content) (fraction).
#         """
#         _Node.__init__(self, name, elevation)
#         self.depth_max = float(depth_max)
#         self.depth_init = float(depth_init)
#         self.kind = kind
#
#         if args:
#             if kind == Storage.TYPES.TABULAR:
#                 self._tabular_init(*args)
#
#             elif kind == Storage.TYPES.FUNCTIONAL:
#                 self._functional_init(*args)
#
#             elif kind in Storage.SHAPES._possible:
#                 self._shape_init(*args)
#
#             else:
#                 raise NotImplementedError()
#         else:
#             self.data = data
#             self._optional_args(depth_surcharge, frac_evaporation,
#                                 suction_head, hydraulic_conductivity, moisture_deficit_init)
#
#     def _functional_init(self, coefficient, exponent, constant, *args, **kwargs):
#         """
#         Init for ``FUNCTIONAL`` relation between surface area and depth.
#
#         Area = constant + coefficient * Depth ^ exponent
#
#         Args:
#             coefficient (float): coefficient of FUNCTIONAL relation between surface area and depth.
#             exponent (float): exponent of FUNCTIONAL relation between surface area and depth.
#             constant (float): constant of FUNCTIONAL relation between surface area and depth.
#
#             depth_surcharge: maximum additional pressure head above full depth that a closed storage unit
#                 can sustain under surcharge conditions (ft or m) (default is 0).
#             frac_evaporation (float): fraction of potential evaporation from the storage unit’s water surface realized
#                 (default is 0).
#         """
#         self.data = [float(coefficient), float(exponent), float(constant)]
#         self._optional_args(*args, **kwargs)
#
#     def _tabular_init(self, curve_name, *args, **kwargs):
#         """
#         for storage type ``'TABULAR'``
#
#         Args:
#             curve_name (str): name of curve in [CURVES] section with surface area (ft2 or m2)
#                 as a function of depth (ft or m) for TABULAR geometry.
#             depth_surcharge: maximum additional pressure head above full depth that a closed storage unit
#                 can sustain under surcharge conditions (ft or m) (default is 0).
#             frac_evaporation (float): fraction of potential evaporation from the storage unit’s water surface realized
#                 (default is 0).
#         """
#         self.data = curve_name
#         self._optional_args(*args, **kwargs)
#
#     def _shape_init(self, L, W, Z, *args, **kwargs):
#         """
#         for storage type ``'FUNCTIONAL'``
#
#         Args:
#             L, W, Z: dimensions of the storage unit's shape (see table below).
#
#             depth_surcharge: maximum additional pressure head above full depth that a closed storage unit
#                 can sustain under surcharge conditions (ft or m) (default is 0).
#             frac_evaporation (float): fraction of potential evaporation from the storage unit’s water surface realized
#                 (default is 0).
#         """
#         self.data = infer_type([L, W, Z])
#         self._optional_args(*args, **kwargs)
#
#     def _optional_args(self, depth_surcharge=0, frac_evaporation=0, *exfiltration_args, **exfiltration_kwargs):
#         """
#         for the optional arguemts
#
#         Args:
#             depth_surcharge: maximum additional pressure head above full depth that a closed storage unit
#                 can sustain under surcharge conditions (ft or m) (default is 0).
#             frac_evaporation (float): fraction of potential evaporation from the storage unit’s water surface realized
#                 (default is 0).
#         """
#         self.depth_surcharge = float(depth_surcharge)
#         self.frac_evaporation = float(frac_evaporation)
#         self._exfiltration_args(*exfiltration_args, **exfiltration_kwargs)
#
#     def _exfiltration_args(self, suction_head=nan, hydraulic_conductivity=nan, moisture_deficit_init=nan):
#         """
#         Optional seepage parameters for soil surrounding the storage unit:
#
#         Args:
#             suction_head (float): Soil suction head (inches or mm).
#             hydraulic_conductivity (float): Soil saturated hydraulic conductivity (in/hr or mm/hr).
#             moisture_deficit_init (float): Soil initial moisture deficit (porosity minus moisture content) (fraction).
#         """
#         self.suction_head = float(suction_head)
#         self.hydraulic_conductivity = float(hydraulic_conductivity)
#         self.moisture_deficit_init = float(moisture_deficit_init)
#
#     @property
#     def curve_name(self):
#         if self.kind == Storage.TYPES.TABULAR:
#             return self.data