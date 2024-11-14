from itertools import product

import pandas as pd

from ..inp import SwmmInput
from ..section_labels import TAGS, SUBCATCHMENTS
from .collection import nodes_dict, links_dict
from ..sections import Tag

TAG_COL_NAME = 'tag'


def _get_tags_frame(inp, part=None):
    if TAGS in inp and inp[TAGS]:
        df_tags = inp[TAGS].frame
        if part in df_tags.index.levels[0]:
            return inp[TAGS].frame.xs(part, axis=0, level=0)
    return pd.Series(name=TAG_COL_NAME, dtype=str)


def get_node_tags(inp):
    """
    get node tags as pandas.Series

    Args:
        inp (SwmmInput): inp data

    Returns:
        pandas.Series: node tags
    """
    return _get_tags_frame(inp, Tag.TYPES.Node)


def get_link_tags(inp):
    """
    get node link as pandas.Series

    Args:
        inp (SwmmInput): inp data

    Returns:
        pandas.Series: link tags
    """
    return _get_tags_frame(inp, Tag.TYPES.Link)


def get_subcatchment_tags(inp):
    """
    get subcatchment tags as pandas.Series

    Args:
        inp (SwmmInput): inp data

    Returns:
        pandas.Series: subcatchment tags
    """
    return _get_tags_frame(inp, Tag.TYPES.Subcatch)


def filter_tags(inp_tags: SwmmInput, inp_objects: SwmmInput = None):
    """
    get tags of one inp data for objects of another inp data and create new section

    Args:
        inp_tags (SwmmInput): inp data where all tags are
        inp_objects (SwmmInput): inp data of the needed objects

    Returns:
        InpSection[str, Tag] | dict[str, Tag]:
    """
    if inp_objects is None:
        inp_objects = inp_tags

    nodes = nodes_dict(inp_objects)
    keys = list(product([Tag.TYPES.Node], list(nodes.keys())))

    links = links_dict(inp_objects)
    keys += list(product([Tag.TYPES.Link], list(links.keys())))

    if SUBCATCHMENTS in inp_objects:
        keys += list(product([Tag.TYPES.Subcatch], list(inp_objects.SUBCATCHMENTS.keys())))

    return inp_tags.TAGS.slice_section(keys)


def delete_tag_group(inp, part):
    """
    delete all tags of one group

    Args:
        inp (SwmmInput):
        part (str): label of the group i.e.: :attr:`Tag.TYPE.Node` (or the strings: 'Node', 'Subcatch', 'Link')
    """
    if TAGS in inp:
        for key in list(inp[TAGS].keys()):
            if inp[TAGS][key].kind == part:
                del inp[TAGS][key]


def _(inp, df):
    inp[TAGS] = Tag.from_inp_lines(df.assign(kind=Tag.TYPES.Subcatch).reindex(drop=None)[['kind', 'name', 'tag']].values)
