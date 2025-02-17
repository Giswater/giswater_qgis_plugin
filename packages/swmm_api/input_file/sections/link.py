import numpy as np

from ._identifiers import IDENTIFIERS
from ..helpers import BaseSectionObject
from .._type_converter import to_bool, infer_offset_elevation, convert_args, is_nan, is_not_set, get_default_if_not_set, \
    is_placeholder
from ..section_labels import CONDUITS, ORIFICES, OUTLETS, PUMPS, WEIRS


class _Link(BaseSectionObject):
    _identifier = IDENTIFIERS.name

    def __init__(self, name, from_node, to_node):
        self.name = str(name)
        self.from_node = str(from_node)
        self.to_node = str(to_node)


class Conduit(_Link):
    """
    Conduit link information.

    Section:
        [CONDUITS]

    Purpose:
        Identifies each conduit link of the drainage system. Conduits are pipes or channels that convey water
        from one node to another.

    Notes:
        These offsets are expressed as a relative distance above the node invert if the ``LINK_OFFSETS`` option
        is set to ``DEPTH`` (the default) or as an absolute elevation if it is set to ``ELEVATION``.

    Attributes:
        name (str): Name assigned to conduit link.
        from_node (str): Name of upstream node.
        to_node (str): Name of downstream node.
        length (float): Conduit length (ft or m).
        roughness (float): Value of n (i.e., roughness parameter) in Manning’s equation.
        offset_upstream (float): offset of upstream end of conduit invert above the invert elevation of its
                                 upstream node (ft or m).
        offset_downstream (float): Offset of downstream end of conduit invert above the invert elevation of its
                                   downstream node (ft or m).
        flow_initial (float): Flow in conduit at start of simulation (flow units) (default is 0).
        flow_max (float): Maximum flow allowed in the conduit (flow units) (default is no limit | 0 = no limit).
    """
    _section_label = CONDUITS

    def __init__(self, name, from_node, to_node, length, roughness, offset_upstream=0, offset_downstream=0,
                 flow_initial=0, flow_max=np.nan):
        """
        Conduit link information.

        Args:
            name (str): Name assigned to conduit link.
            from_node (str): Name of upstream node.
            to_node (str): Name of downstream node.
            length (float): Conduit length (ft or m).
            roughness (float): Value of n (i.e., roughness parameter) in Manning’s equation.
            offset_upstream (float): offset of upstream end of conduit invert above the invert elevation of its
                                     upstream node (ft or m).
            offset_downstream (float): Offset of downstream end of conduit invert above the invert elevation of its
                                       downstream node (ft or m).
            flow_initial (float): Flow in conduit at start of simulation (flow units) (default is 0).
            flow_max (float): Maximum flow allowed in the conduit (flow units) (default is no limit | 0 = no limit).
        """
        _Link.__init__(self, name, from_node, to_node)
        self.length = float(length)
        self.roughness = float(roughness)
        self.offset_upstream = infer_offset_elevation(offset_upstream)
        self.offset_downstream = infer_offset_elevation(offset_downstream)
        self.flow_initial = float(flow_initial)
        self.flow_max = float(flow_max)
        if self.flow_max == 0:
            self.flow_max = np.nan


class Orifice(_Link):
    """
    Orifice link information.

    Section:
        [ORIFICES]

    Purpose:
        Identifies each orifice link of the drainage system. An orifice link serves to limit the
        flow exiting a node and is often used to model flow diversions and storage node outlets.

    Notes:
        The geometry of an orifice’s opening must be described in the [``XSECTIONS``] section.
        The only allowable shapes are CIRCULAR and RECT_CLOSED (closed rectangular).

    Attributes:
        name (str): Name assigned to orifice link.
        from_node (str): Name of node on inlet end of orifice.
        to_node (str): Name of node on outlet end of orifice.
        orientation (str): Orientation of orifice: either ``SIDE`` or ``BOTTOM``.
        offset (float): Amount that a Side Orifice’s bottom or the position of a Bottom Orifice is offset above
                        the invert of inlet node (ft or m, expressed as either a depth or as an elevation,
                        depending on the LINK_OFFSETS option setting).
        discharge_coefficient (float): Discharge coefficient (unitless).
        has_flap_gate (bool): ``YES`` (:obj:`True`) if flap gate present to prevent reverse flow,
                              ``NO`` (:obj:`False`) if not (default is ``NO``).
        hours_to_open (int): Time in decimal hours to open a fully closed orifice (or close a fully open one).
                             Use 0 if the orifice can open/close instantaneously.

        ORIENTATION: Enum-like for the attribute :attr:`Orifice.orientation` with following members -> {``SIDE`` | ``BOTTOM``}
    """
    _section_label = ORIFICES

    class ORIENTATION:
        """Orientation of orifice."""
        SIDE = 'SIDE'
        BOTTOM = 'BOTTOM'

    def __init__(self, name, from_node, to_node, orientation, offset, discharge_coefficient, has_flap_gate=False,
                 hours_to_open=0):
        """
        Orifice link information.

        Args:
            name (str): Name assigned to orifice link.
            from_node (str): Name of node on inlet end of orifice.
            to_node (str): Name of node on outlet end of orifice.
            orientation (str): Orientation of orifice: either SIDE or BOTTOM.
            offset (float): Amount that a Side Orifice’s bottom or the position of a Bottom Orifice is offset above
                            the invert of inlet node (ft or m, expressed as either a depth or as an elevation,
                            depending on the LINK_OFFSETS option setting).
            discharge_coefficient (float): Discharge coefficient (unitless).
            has_flap_gate (bool): ``YES`` (:obj:`True`) if flap gate present to prevent reverse flow,
                                  ``NO`` (:obj:`False`) if not (default is ``NO``).
            hours_to_open (int): Time in decimal hours to open a fully closed orifice (or close a fully open one).
                                 Use 0 if the orifice can open/close instantaneously.
        """
        _Link.__init__(self, name, from_node, to_node)
        self.orientation = str(orientation)
        self.offset = infer_offset_elevation(offset)
        self.discharge_coefficient = float(discharge_coefficient)
        self.has_flap_gate = to_bool(has_flap_gate)
        self.hours_to_open = float(hours_to_open)


class Outlet(_Link):
    """
    Outlet link information.

    Section:
        [OUTLETS]

    Purpose:
        Identifies each outlet flow control device of the drainage system.
        These devices are used to model outflows from storage units or flow diversions
        that have a user-defined relation between flow rate and water depth.

    Attributes:
        name (str): Name assigned to outlet link.
        from_node (str): Name of node on inlet end of link.
        to_node (str): Name of node on outflow end of link.
        offset (float): Amount that the outlet is offset above the invert of inlet node.
            (ft or m, expressed as either a depth or as an elevation, depending on the ``LINK_OFFSETS`` option setting).
        curve_type (str): One of :attr:`Outlet.TYPES`.
        curve_description (str | tuple[float, float]):

            - :obj:`str`: ``name_curve`` Name of the rating curve listed in the [``CURVES``] section that
                          describes outflow rate (flow units) as a function of:

                - water depth above the offset elevation at the inlet node (ft or m) for a TABULAR/DEPTH outlet.
                - head difference (ft or m) between the inlet and outflow nodes for a TABULAR/HEAD outlet.
            - :obj:`tuple[float, float]`: Coefficient and exponent, respectively, of a power
                                          function that relates outflow (Q) to:

                - water depth (ft or m) above the offset elevation at the inlet node for a FUNCTIONAL/DEPTH outlet.
                - head difference (ft or m) between the inlet and outflow nodes for a FUNCTIONAL/HEAD outlet.
                  (i.e., :math:`Q = C1*H^{C2}` where H is either depth or head).

        has_flap_gate (bool): ``YES`` (:obj:`True`) if flap gate present to prevent reverse flow,
                              ``NO`` (:obj:`False`) if not (default is ``NO``).

        TYPES: Enum-like for the attribute :attr:`Outlet.curve_type` with following members -> {``TABULAR_DEPTH`` | ``TABULAR_HEAD`` | ``FUNCTIONAL_DEPTH`` | ``FUNCTIONAL_HEAD``}
    """
    _section_label = OUTLETS

    class TYPES:
        """How the outlet flow rate is calculated."""
        TABULAR_DEPTH = 'TABULAR/DEPTH'
        TABULAR_HEAD = 'TABULAR/HEAD'
        FUNCTIONAL_DEPTH = 'FUNCTIONAL/DEPTH'
        FUNCTIONAL_HEAD = 'FUNCTIONAL/HEAD'

    def __init__(self, name, from_node, to_node, offset, curve_type, *args, curve_description=None, has_flap_gate=False):
        """
        Outlet link information.

        Args:
            name (str): Name assigned to outlet link.
            from_node (str): Name of node on inlet end of link.
            to_node (str): Name of node on outflow end of link.
            offset (float): Amount that the outlet is offset above the invert of inlet node
                (ft or m, expressed as either a depth or as an elevation, depending on the LINK_OFFSETS option setting).
            curve_type (str): One of :attr:`Outlet.TYPES`
            *args: -Arguments below- (for automatic input file reader.)
            curve_description (str | tuple[float, float]):

                - :obj:`str`: ``name_curve`` Name of the rating curve listed in the [``CURVES``] section that
                              describes outflow rate (flow units) as a function of:

                    - water depth above the offset elevation at the inlet node (ft or m) for a TABULAR/DEPTH outlet.
                    - head difference (ft or m) between the inlet and outflow nodes for a TABULAR/HEAD outlet.
                - :obj:`tuple[float, float]`: Coefficient and exponent, respectively, of a power
                                              function that relates outflow (Q) to:

                    - water depth (ft or m) above the offset elevation at the inlet node for a FUNCTIONAL/DEPTH outlet.
                    - head difference (ft or m) between the inlet and outflow nodes for a FUNCTIONAL/HEAD outlet.
                      (i.e., Q = C1H^C2 where H is either depth or head).

            has_flap_gate (bool): ``YES`` (:obj:`True`) if flap gate present to prevent reverse flow,
                                  ``NO`` (:obj:`False`) if not (default is ``NO``).
        """
        _Link.__init__(self, name, from_node, to_node)
        self.offset = infer_offset_elevation(offset)
        self.curve_type = str(curve_type).upper()

        if args:
            if self.curve_type.startswith('TABULAR'):
                self._tabular_init(*args)
            elif self.curve_type.startswith('FUNCTIONAL'):
                args = convert_args(args)
                self._functional_init(*args)
            else:
                raise NotImplementedError(f'Type: "{self.curve_type}" is not implemented')

        else:
            self.curve_description = curve_description
            self.has_flap_gate = to_bool(has_flap_gate)

    def _tabular_init(self, curve_name, has_flap_gate=False):
        """
        Init for object which describes the outflow rate (flow units) as a rating curve.

        Args:
            curve_name (str): Name of the rating curve listed in the [``CURVES``] section that describes
                              outflow rate (flow units) as a function of:

                - water depth above the offset elevation at the inlet node (ft or m) for a TABULAR/DEPTH outlet.
                - head difference (ft or m) between the inlet and outflow nodes for a TABULAR/HEAD outlet.
            has_flap_gate (bool): ``YES`` (:obj:`True`) if flap gate present to prevent reverse flow,
                                  ``NO`` (:obj:`False`) if not (default is ``NO``).
        """
        self.curve_description = str(curve_name)
        self.has_flap_gate = to_bool(has_flap_gate)

    @property
    def curve_name(self):
        if isinstance(self.curve_description, str):
            return self.curve_description

    def _functional_init(self, coefficient, exponent, has_flap_gate=False):
        """
        Init for object which describes the outflow rate (flow units) as a function.

        Q = coefficient * H^exponent

        where H is either:

            - water depth (ft or m) above the offset elevation at the inlet node for a FUNCTIONAL/DEPTH outlet.
            - head difference (ft or m) between the inlet and outflow nodes for a FUNCTIONAL/HEAD outlet.

        Args:
            coefficient (float): Coefficient of a power function.
            exponent (float): Exponent of a power function.
            has_flap_gate (bool): ``YES`` (:obj:`True`) if flap gate present to prevent reverse flow,
                                  ``NO`` (:obj:`False`) if not (default is ``NO``).
        """
        self.curve_description = [float(coefficient), float(exponent)]
        self.has_flap_gate = to_bool(has_flap_gate)


class Pump(_Link):
    """
    Pump link information.
    
    Section:
        [PUMPS]

    Purpose:
        Identifies each pump link of the drainage system.

    Attributes:
        name (str): Name assigned to pump link.
        from_node (str): Name of node on inlet side of pump.
        to_node (str): Name of node on outlet side of pump.
        curve_name (str): Name of pump curve listed in the [``CURVES``] section of the input.
        status (str): Status at start of simulation (either ``ON`` or ``OFF``; default is ``ON``).
        depth_on (float): Depth at inlet node when pump turns on (ft or m) (default is 0).
        depth_off (float): Depth at inlet node when pump shuts off (ft or m) (default is 0).

        STATES: Enum-like for the attribute :attr:`Pump.status` with following members -> {``ON`` | ``OFF``}

    See Section 3.2 for a description of the different types of pumps available.
    """
    _section_label = PUMPS

    class STATES:
        """Status at start of simulation (either ``ON`` or ``OFF``; default is ``ON``)."""
        ON = 'ON'
        OFF = 'OFF'

    def __init__(self, name, from_node, to_node, curve_name, status='ON', depth_on=0, depth_off=0):
        """
        Pump link information.

        Args:
            name (str): Name assigned to pump link.
            from_node (str): Name of node on inlet side of pump.
            to_node (str): Name of node on outlet side of pump.
            curve_name (str): Name of pump curve listed in the [``CURVES``] section of the input. (or * for an Ideal pump)
            status (str): Status at start of simulation (either ``ON`` or ``OFF``; default is ``ON``).
            depth_on (float): Depth at inlet node when pump turns on (ft or m) (default is 0).
            depth_off (float): Depth at inlet node when pump shuts off (ft or m) (default is 0).
        """
        _Link.__init__(self, name, from_node, to_node)
        self.curve_name = str(curve_name)
        self.status = str(status)
        self.depth_on = float(depth_on)
        self.depth_off = float(depth_off)


class Weir(_Link):
    """
    Weir link information.

    Section:
        [WEIRS]

    Purpose:
        Identifies each weir link of the drainage system. Weirs are used to model flow
        diversions and storage node outlets.

    Remarks:
        The geometry of a weir’s opening is described in the [``XSECTIONS``] section (:class:`CrossSection`).
        The following shapes must be used with each type of weir:

        ===============  ===================
        Weir Form        Cross-Section Shape
        ===============  ===================
        ``TRANSVERSE``   ``RECT_OPEN``
        ``SIDEFLOW``     ``RECT_OPEN``
        ``V-NOTCH``      ``TRIANGULAR``
        ``TRAPEZOIDAL``  ``TRAPEZOIDAL``
        ``ROADWAY``      ``RECT_OPEN``
        ===============  ===================

        The ``ROADWAY`` weir is a broad crested rectangular weir used model roadway crossings usually in conjunction with culvert-type conduits.
        It uses the FHWA HDS-5 method to determine a discharge coefficient as a function of flow depth and roadway width and surface.
        If no roadway data are provided then the weir behaves as a ``TRANSVERSE`` weir with :attr:`discharge_coefficient` as its discharge coefficient.
        Note that if roadway data are provided, then values for the other optional weir parameters
        (``NO`` for :attr:`has_flap_gate`, 0 for :attr:`n_end_contractions`, 0 for :attr:`discharge_coefficient_end`, and ``NO`` for :attr:`can_surcharge`)
        must be entered even though they do not apply to ``ROADWAY`` weirs.

    Attributes:
        name (str): Name assigned to weir link
        from_node (str): Name of node on inlet side of weir.
        to_node (str): Name of node on outlet side of weir.
        form (str): One of :attr:`Weir.FORMS` (``TRANSVERSE``, ``SIDEFLOW``, ``V-NOTCH``, ``TRAPEZOIDAL`` or ``ROADWAY``).
        height_crest (float): Amount that the weir’s crest is offset above the invert of inlet node (ft or m, expressed as either a depth or as an elevation, depending on the LINK_OFFSETS option setting).
        discharge_coefficient (float): Weir discharge coefficient (for CFS if using US flow units or CMS if using metric flow units).
        has_flap_gate (bool): ``YES`` (:obj:`True`) if flap gate present to prevent reverse flow, ``NO`` (:obj:`False`) if not (default is ``NO``).
        n_end_contractions (float): Number of end contractions for ``TRANSVERSE`` or ``TRAPEZOIDAL`` weir (default is 0).
        discharge_coefficient_end (float): Discharge coefficient for triangular ends of a ``TRAPEZOIDAL`` weir (for ``CFS`` if using US flow units or ``CMS`` if using metric flow units) (default is value of ``discharge_coefficient``).
        can_surcharge (bool): ``YES`` (:obj:`True`) if the weir can surcharge (have an upstream water level higher than the height of the opening); ``NO`` (:obj:`False`) if it cannot (default is ``YES``).
        road_width (float): Width of road lanes and shoulders for ``ROADWAY`` weir (ft or m).
        road_surface (str): Type of road surface for ``ROADWAY`` weir: ``PAVED`` or ``GRAVEL``.
        coefficient_curve (str): Name of an optional Weir Curve that allows the central Discharge Coeff. to vary with head (ft or m) across the weir. Does not apply to Roadway weirs. Available curves are listed in the [``CURVES``] section (:class:`Curve`) of the input.

        FORMS: Enum-like for the attribute :attr:`Weir.form` with following members -> {``TRANSVERSE`` | ``SIDEFLOW`` | ``V_NOTCH`` | ``TRAPEZOIDAL`` | ``ROADWAY``}
        ROAD_SURFACES: Enum-like for the attribute :attr:`Weir.road_surface` with following members -> {``ROADWAY`` | ``PAVED`` | ``GRAVEL``}
    """
    _section_label = WEIRS

    class FORMS:
        """Form of the weir crest, one of {``TRANSVERSE``, ``SIDEFLOW``, ``V-NOTCH``, ``TRAPEZOIDAL`` or ``ROADWAY``}."""
        TRANSVERSE = 'TRANSVERSE'
        SIDEFLOW = 'SIDEFLOW'
        V_NOTCH = 'V-NOTCH'
        TRAPEZOIDAL = 'TRAPEZOIDAL'
        ROADWAY = 'ROADWAY'

    class ROAD_SURFACES:
        """Type of road surface for ``ROADWAY`` weir: ``PAVED`` or ``GRAVEL``."""
        PAVED = 'PAVED'
        GRAVEL = 'GRAVEL'

    def __init__(self, name, from_node, to_node, form, height_crest, discharge_coefficient, has_flap_gate=False,
                 n_end_contractions=0, discharge_coefficient_end=0, can_surcharge=True,
                 road_width=np.nan, road_surface=np.nan, coefficient_curve=np.nan):
        """
        Weir link information.

        Args:
            name (str): Name assigned to weir link
            from_node (str): Name of node on inlet side of weir.
            to_node (str): Name of node on outlet side of weir.
            form (str): One if :attr:`Weir.FORMS` (``TRANSVERSE``, ``SIDEFLOW``, ``V-NOTCH``, ``TRAPEZOIDAL`` or ``ROADWAY``).
            height_crest (float): Amount that the weir’s crest is offset above the invert of inlet node (ft or m, expressed as either a depth or as an elevation, depending on the LINK_OFFSETS option setting).
            discharge_coefficient (float): Weir discharge coefficient (for CFS if using US flow units or CMS if using metric flow units).
            has_flap_gate (bool): ``YES`` (:obj:`True`) if flap gate present to prevent reverse flow, ``NO`` (:obj:`False`) if not (default is ``NO``).
            n_end_contractions (float): Number of end contractions for ``TRANSVERSE`` or ``TRAPEZOIDAL`` weir (default is 0).
            discharge_coefficient_end (float): Discharge coefficient for triangular ends of a ``TRAPEZOIDAL`` weir (for ``CFS`` if using US flow units or ``CMS`` if using metric flow units) (default is value of ``discharge_coefficient``).
            can_surcharge (bool): ``YES`` (:obj:`True`) if the weir can surcharge (have an upstream water level higher than the height of the opening); ``NO`` (:obj:`False`) if it cannot (default is ``YES``).
            road_width (float): Width of road lanes and shoulders for ``ROADWAY`` weir (ft or m).
            road_surface (str): Type of road surface for ``ROADWAY`` weir: ``PAVED`` or ``GRAVEL``.
            coefficient_curve (str): Name of an optional Weir Curve that allows the central Discharge Coeff. to vary with head (ft or m) across the weir. Does not apply to Roadway weirs. Available curves are listed in the [``CURVES``] section (:class:`Curve`) of the input.
        """
        _Link.__init__(self, name, from_node, to_node)
        self.form = str(form).upper()
        self.height_crest = infer_offset_elevation(height_crest)
        self.discharge_coefficient = float(discharge_coefficient)

        # optional parameters (due to defaults)
        # set * if one of the following parameters is used
        # set default if one exists
        # set nan if none of the following parameters is used

        # ---
        self.has_flap_gate = to_bool(get_default_if_not_set(has_flap_gate, False))  # YES | NO | np.nan | *

        # ---
        self.n_end_contractions = int(get_default_if_not_set(n_end_contractions, 0))

        # ---
        self.discharge_coefficient_end = float(get_default_if_not_set(discharge_coefficient_end, self.discharge_coefficient if self.form == self.FORMS.TRAPEZOIDAL else 0))

        # ---
        self.can_surcharge = to_bool(get_default_if_not_set(can_surcharge, True))  # YES | NO | np.nan | *

        # road_width and road_surface will be marked as '*' in epa-swmm GUI
        # value will be ignored

        # ---
        # either: '*', np.nan or a float
        # change '*' to np.nan - convert everything else to float
        self.road_width = np.nan if is_placeholder(road_width) else float(road_width)

        # ---
        # either '*', np.nan or a string
        if isinstance(road_surface, str):
            if road_surface.lower() in {'*', 'nan'}:
                self.road_surface = np.nan
            elif road_surface.upper() in (self.ROAD_SURFACES.PAVED, self.ROAD_SURFACES.GRAVEL):
                self.road_surface = road_surface.upper()
            else:
                raise NotImplementedError(f'The parameter road_surface takes either "*", np.nan, "{self.ROAD_SURFACES.PAVED}" or "{self.ROAD_SURFACES.GRAVEL}" but "{road_surface}" is given.')
        elif is_nan(road_surface):
            self.road_surface = road_surface  # = nan
        else:
            raise NotImplementedError(f'The parameter road_surface takes either "*", np.nan, "{self.ROAD_SURFACES.PAVED}" or "{self.ROAD_SURFACES.GRAVEL}" but "{road_surface}" with type {type(road_surface)} is given.')

        # ---
        # either np.nan or a string or '*'
        self.coefficient_curve = get_default_if_not_set(coefficient_curve, np.nan)

        self._set_unused_parameters_stars()

    def _set_unused_parameters_stars(self):
        """
        Set "*" for the parameters ``road_width`` and ``road_surface``

        when both are unused and ``coefficient_curve`` is set.
        """
        if isinstance(self.coefficient_curve, str):
            if is_nan(self.road_width):
                self.road_width = '*'
            if is_nan(self.road_surface):
                self.road_surface = '*'

    @property
    def curve_name(self):
        if isinstance(self.coefficient_curve, str):
            return self.coefficient_curve

    def to_dict_(self):
        self._set_unused_parameters_stars()
        return super().to_dict_()

    def to_inp_line(self):
        self._set_unused_parameters_stars()
        return super().to_inp_line()
