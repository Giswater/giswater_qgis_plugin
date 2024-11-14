from numpy import NaN

from ..section_labels import JUNCTIONS, CONDUITS, STORAGE, OUTFALLS, ORIFICES, DIVIDERS
from ..sections import Storage, Outfall, Orifice, Divider, Conduit


def junction_to_divider(inp, label, *args, **kwargs):
    """
    convert :class:`~swmm_api.input_file.inp_sections.node.Junction` to
    :class:`~swmm_api.input_file.inp_sections.node.Divider`

    and add it to the DIVIDERS section

    Args:
        inp (SwmmInput): inp-file data
        label (str): label of the junction
        *args: argument of the :class:`~swmm_api.input_file.inp_sections.node.Storage`-class
        **kwargs: keyword arguments of the :class:`~swmm_api.input_file.inp_sections.node.Divider`-class
    """
    j = inp[JUNCTIONS].pop(label)  # type: Junction
    if DIVIDERS not in inp:
        inp[DIVIDERS] = Divider.create_section()
    inp[DIVIDERS].add_obj(Divider(name=label, elevation=j.elevation, depth_max=j.depth_max,
                                  depth_init=j.depth_init, area_ponded=j.area_ponded, *args, **kwargs))


def junction_to_outfall(inp, label, *args, **kwargs):
    """
    convert :class:`~swmm_api.input_file.inp_sections.node.Junction` to
    :class:`~swmm_api.input_file.inp_sections.node.Outfall`

    and add it to the OUTFALLS section

    Args:
        inp (SwmmInput): inp-file data
        label (str): label of the junction
        *args: argument of the :class:`~swmm_api.input_file.inp_sections.node.Outfall`-class
        **kwargs: keyword arguments of the :class:`~swmm_api.input_file.inp_sections.node.Outfall`-class
    """
    j = inp[JUNCTIONS].pop(label)  # type: Junction
    if OUTFALLS not in inp:
        inp[OUTFALLS] = Outfall.create_section()
    inp[OUTFALLS].add_obj(Outfall(name=label, elevation=j.elevation, *args, **kwargs))


def junction_to_storage(inp, label, *args, **kwargs):
    """
    convert :class:`~swmm_api.input_file.inp_sections.node.Junction` to
    :class:`~swmm_api.input_file.inp_sections.node.Storage`

    and add it to the STORAGE section

    Args:
        inp (SwmmInput): inp-file data
        label (str): label of the junction
        *args: argument of the :class:`~swmm_api.input_file.inp_sections.node.Storage`-class
        **kwargs: keyword arguments of the :class:`~swmm_api.input_file.inp_sections.node.Storage`-class
    """
    j = inp[JUNCTIONS].pop(label)  # type: Junction
    if STORAGE not in inp:
        inp[STORAGE] = Storage.create_section()
    inp[STORAGE].add_obj(Storage(name=label, elevation=j.elevation, depth_max=j.depth_max,
                                 depth_init=j.depth_init, depth_surcharge=j.area_ponded, *args, **kwargs))


def storage_to_outfall(inp, label, *args, **kwargs):
    """
    convert :class:`~swmm_api.input_file.inp_sections.node.Storage` to
    :class:`~swmm_api.input_file.inp_sections.node.Outfall`

    and add it to the OUTFALLS section

    Args:
        inp (SwmmInput): inp-file data
        label (str): label of the storage node
        *args: argument of the :class:`~swmm_api.input_file.inp_sections.node.Outfall`-class
        **kwargs: keyword arguments of the :class:`~swmm_api.input_file.inp_sections.node.Outfall`-class
    """
    j = inp[STORAGE].pop(label)  # type: Storage
    if OUTFALLS not in inp:
        inp[OUTFALLS] = Outfall.create_section()
    inp[OUTFALLS].add_obj(Outfall(name=label, elevation=j.elevation, *args, **kwargs))


def conduit_to_orifice(inp, label, orientation, offset, discharge_coefficient, has_flap_gate=False, hours_to_open=0):
    """
    Convert conduit object to orifice object.

    convert :class:`~swmm_api.input_file.inp_sections.link.Conduit` to
    :class:`~swmm_api.input_file.inp_sections.link.Orifice`

    and add it to the ORIFICES section

    Args:
        inp (SwmmInput): inp-file data
        label (str): label of the conduit
        orientation (str): orientation of orifice: either SIDE or BOTTOM.
        offset (float): amount that a Side Orifice’s bottom or the position of a Bottom Orifice is offset above
            the invert of inlet node (ft or m, expressed as either a depth or as an elevation,
            depending on the LINK_OFFSETS option setting).
        discharge_coefficient (float): discharge coefficient (unitless).
        has_flap_gate (bool): YES if flap gate present to prevent reverse flow, NO if not (default is NO).
        hours_to_open (int): time in decimal hours to open a fully closed orifice (or close a fully open one).
                        Use 0 if the orifice can open/close instantaneously.
    """
    c = inp[CONDUITS].pop(label)  # type: Conduit
    if ORIFICES not in inp:
        inp[ORIFICES] = Orifice.create_section()
    inp[ORIFICES].add_obj(Orifice(name=label, from_node=c.from_node, to_node=c.to_node,
                                  orientation=orientation, offset=offset, discharge_coefficient=discharge_coefficient,
                                  has_flap_gate=has_flap_gate, hours_to_open=hours_to_open))


def orifice_to_conduit(inp, label, length, roughness, offset_upstream=0, offset_downstream=0, flow_initial=0, flow_max=NaN):
    """
    Convert orifice object to conduit object.

    convert :class:`~swmm_api.input_file.inp_sections.link.Conduit` to
    :class:`~swmm_api.input_file.inp_sections.link.Orifice`

    and add it to the ORIFICES section

    Args:
        inp (SwmmInput): inp-file data
        label (str): label of the conduit
        orientation (str): orientation of orifice: either SIDE or BOTTOM.
        offset (float): amount that a Side Orifice’s bottom or the position of a Bottom Orifice is offset above
            the invert of inlet node (ft or m, expressed as either a depth or as an elevation,
            depending on the LINK_OFFSETS option setting).
        discharge_coefficient (float): discharge coefficient (unitless).
        has_flap_gate (bool): YES if flap gate present to prevent reverse flow, NO if not (default is NO).
        hours_to_open (int): time in decimal hours to open a fully closed orifice (or close a fully open one).
                        Use 0 if the orifice can open/close instantaneously.
    """
    c = inp[ORIFICES].pop(label)  # type: Orifice
    if CONDUITS not in inp:
        inp[CONDUITS] = Orifice.create_section()
    inp[CONDUITS].add_obj(Conduit(name=label, from_node=c.from_node, to_node=c.to_node,
                                  length=length, roughness=roughness, offset_upstream=offset_upstream,
                                  offset_downstream=offset_downstream, flow_initial=flow_initial, flow_max=flow_max))
