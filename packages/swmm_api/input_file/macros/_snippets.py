import numpy as np


def section_from_frame(df, section_class):
    """
    create a inp-file section from an pandas DataFrame

    will only work for specific sections ie. JUNCTIONS where every row is the same and no special __init__ is needed!

    Args:
        df (pandas.DataFrame): data
        section_class (BaseSectionObject):

    Returns:
        InpSection: converted section
    """
    # TODO: macro_snippets
    values = np.vstack((df.index.values, df.values.T)).T
    return section_class.create_section(values)
    # return cls.from_lines([line.split() for line in dataframe_to_inp_string(df).split('\n')], section_class)


def group_edit(inp):
    # ToDo
    # for objects of type (Subcatchments, Infiltration, Junctions, Storage Units, or Conduits)
    # with tag equal to
    # edit the property
    # by replacing it with
    pass


"""PCSWMM Simplify network tool 
Criteria

The criteria is a list of attributes and a given tolerance for each. Attribute criteria can be toggled on or off 
by checking the box next to the attribute. The attribute criteria are as follows:

    Cross-section shapes must match exactly
    Diameter values match within a specified percent tolerance
    Roughness values match within a specified percent tolerance
    Slope values match within a specified tolerance
    Transects must match exactly
    Shape curves must match exactly

Join preference

Select a preference for joining two conduits. The preference is used when two conduits are available for 
connecting on the upstream and downstream nodes. Choose the priority for the connection to be any one of the 
following:

    shorter conduit
    longer conduit
    closest slope
    upstream conduit
    downstream conduit
"""


# def dissolve_node(inp, node):
#     """
#     delete node and combine conduits
#
#     Args:
#         inp (InpData): inp data
#         node (str | Junction | Storage | Outfall): node to delete
#
#     Returns:
#         InpData: inp data
#     """
#     if isinstance(node, str):
#         node = find_node(inp, node)
#     # create new section with only
#     c1 = inp[sec.CONDUITS].slice_section([node.Name], 'to_node')
#     if c1:
#         c2 = inp[sec.CONDUITS].slice_section([node.Name], 'from_node')
#         inp = combine_conduits(inp, c1, c2)
#     else:
#         inp = delete_node(node.Name)
#     return inp
