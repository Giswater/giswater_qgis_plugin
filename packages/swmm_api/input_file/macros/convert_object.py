import inspect

import numpy as np

from ..helpers import BaseSectionObject
from ..section_labels import JUNCTIONS, CONDUITS, STORAGE, OUTFALLS, ORIFICES, DIVIDERS
from ..sections import Storage, Outfall, Orifice, Divider, Conduit, Junction


def convert_base_obj(inp, section_label: str, object_label: str, new_type: type, **kwargs):
    """
    Convert an object of a given section to a new object of "new_type".

    Works inplace.

    Args:
        inp (swmm_api.SwmmInput): SWMM input-file data.
        section_label (str):
        object_label (str):
        new_type (type):
        *args:
        **kwargs:
    """

    if object_label in inp[new_type._section_label]:
        # already thi object type - nothing to do
        return

    i = inp[section_label].pop(object_label)  # type: BaseSectionObject

    # attributes from old object that can be reused.
    parameters_old = i.to_dict_()
    parameters_new = inspect.getfullargspec(new_type.__init__).args
    parameters_reuse = {k: v for k, v in parameters_old.items() if k in parameters_new}

    inp.add_obj(new_type(**{**parameters_reuse, **kwargs}))


def junction_to_divider(inp, label, *args, **kwargs):
    """
    convert :class:`~swmm_api.input_file.sections.node.Junction` to
    :class:`~swmm_api.input_file.sections.node.Divider`

    and add it to the DIVIDERS section

    Args:
        inp (swmm_api.SwmmInput): SWMM input-file data.
        label (str): label of the junction
        *args: argument of the :class:`~swmm_api.input_file.sections.node.Storage`-class
        **kwargs: keyword arguments of the :class:`~swmm_api.input_file.sections.node.Divider`-class
    """
    convert_base_obj(inp, JUNCTIONS, label, Divider, **kwargs)

    # j = inp[JUNCTIONS].pop(label)  # type: Junction
    # inp.add_obj(Divider(name=label, elevation=j.elevation, depth_max=j.depth_max,
    #                     depth_init=j.depth_init, area_ponded=j.area_ponded, *args, **kwargs))


def junction_to_outfall(inp, label, *args, **kwargs):
    """
    convert :class:`~swmm_api.input_file.sections.node.Junction` to
    :class:`~swmm_api.input_file.sections.node.Outfall`

    and add it to the OUTFALLS section

    Args:
        inp (swmm_api.SwmmInput): SWMM input-file data.
        label (str): label of the junction
        *args: argument of the :class:`~swmm_api.input_file.sections.node.Outfall`-class
        **kwargs: keyword arguments of the :class:`~swmm_api.input_file.sections.node.Outfall`-class
    """
    convert_base_obj(inp, JUNCTIONS, label, Outfall, **kwargs)

    # j = inp[JUNCTIONS].pop(label)  # type: Junction
    # inp.add_obj(Outfall(name=label, elevation=j.elevation, *args, **kwargs))


def junction_to_storage(inp, label, *args, **kwargs):
    """
    convert :class:`~swmm_api.input_file.sections.node.Junction` to
    :class:`~swmm_api.input_file.sections.node.Storage`

    and add it to the STORAGE section

    Args:
        inp (swmm_api.SwmmInput): SWMM input-file data.
        label (str): label of the junction
        *args: argument of the :class:`~swmm_api.input_file.sections.node.Storage`-class
        **kwargs: keyword arguments of the :class:`~swmm_api.input_file.sections.node.Storage`-class
    """
    convert_base_obj(inp, JUNCTIONS, label, Storage, **kwargs)

    # j = inp[JUNCTIONS].pop(label)  # type: Junction
    # inp.add_obj(Storage(name=label, elevation=j.elevation, depth_max=j.depth_max,
    #                     depth_init=j.depth_init, depth_surcharge=j.depth_surcharge, *args, **kwargs))


def storage_to_outfall(inp, label, *args, **kwargs):
    """
    convert :class:`~swmm_api.input_file.sections.node.Storage` to
    :class:`~swmm_api.input_file.sections.node.Outfall`

    and add it to the OUTFALLS section

    Args:
        inp (swmm_api.SwmmInput): SWMM input-file data.
        label (str): label of the storage node
        *args: argument of the :class:`~swmm_api.input_file.sections.node.Outfall`-class
        **kwargs: keyword arguments of the :class:`~swmm_api.input_file.sections.node.Outfall`-class
    """
    convert_base_obj(inp, STORAGE, label, Outfall, **kwargs)

    # s = inp[STORAGE].pop(label)  # type: Storage
    # inp.add_obj(Outfall(name=label, elevation=s.elevation, *args, **kwargs))


def storage_to_junction(inp, label, *args, **kwargs):
    """
    convert :class:`~swmm_api.input_file.sections.node.Storage` to
    :class:`~swmm_api.input_file.sections.node.Junction`

    and add it to the JUNCTIONS section

    Args:
        inp (swmm_api.SwmmInput): SWMM input-file data.
        label (str): label of the storage node
        *args: argument of the :class:`~swmm_api.input_file.sections.node.Junction`-class
        **kwargs: keyword arguments of the :class:`~swmm_api.input_file.sections.node.Junction`-class
    """
    convert_base_obj(inp, STORAGE, label, Junction, **kwargs)

    # s = inp[STORAGE].pop(label)  # type: Storage
    # inp.add_obj(Junction(name=label, elevation=s.elevation,
    #                      depth_max=s.depth_max, depth_init=s.depth_init,
    #                      depth_surcharge=s.depth_surcharge, *args, **kwargs))


def conduit_to_orifice(inp, label, orientation, offset, discharge_coefficient, has_flap_gate=False, hours_to_open=0):
    """
    Convert conduit object to orifice object.

    convert :class:`~swmm_api.input_file.sections.link.Conduit` to
    :class:`~swmm_api.input_file.sections.link.Orifice`

    and add it to the ORIFICES section

    Args:
        inp (swmm_api.SwmmInput): SWMM input-file data.
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

    # _convert_obj(inp, CONDUITS, label, Orifice, **kwargs)
    convert_base_obj(inp, CONDUITS, label, Orifice,
                     orientation=orientation, offset=offset, discharge_coefficient=discharge_coefficient,
                     has_flap_gate=has_flap_gate, hours_to_open=hours_to_open)

    # c = inp[CONDUITS].pop(label)  # type: Conduit
    # inp.add_obj(Orifice(name=label, from_node=c.from_node, to_node=c.to_node,
    #                     orientation=orientation, offset=offset, discharge_coefficient=discharge_coefficient,
    #                     has_flap_gate=has_flap_gate, hours_to_open=hours_to_open))


def orifice_to_conduit(inp, label, length, roughness, offset_upstream=0, offset_downstream=0, flow_initial=0, flow_max=np.nan):
    """
    Convert orifice object to conduit object.

    convert :class:`~swmm_api.input_file.sections.link.Conduit` to
    :class:`~swmm_api.input_file.sections.link.Orifice`

    and add it to the ORIFICES section

    Args:
        inp (swmm_api.SwmmInput): SWMM input-file data.
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

    # _convert_obj(inp, ORIFICES, label, Conduit, **kwargs)
    convert_base_obj(inp, ORIFICES, label, Conduit,
                     length=length, roughness=roughness, offset_upstream=offset_upstream,
                     offset_downstream=offset_downstream, flow_initial=flow_initial, flow_max=flow_max)

    # c = inp[ORIFICES].pop(label)  # type: Orifice
    # inp.add_obj(Conduit(name=label, from_node=c.from_node, to_node=c.to_node,
    #                     length=length, roughness=roughness, offset_upstream=offset_upstream,
    #                     offset_downstream=offset_downstream, flow_initial=flow_initial, flow_max=flow_max))
