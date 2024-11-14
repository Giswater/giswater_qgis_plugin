__author__ = "Markus Pichler"
__credits__ = ["Markus Pichler"]
__maintainer__ = "Markus Pichler"
__email__ = "markus.pichler@tugraz.at"
__version__ = "0.1"
__license__ = "MIT"

from pathlib import Path

import pandas as pd
import numpy as np

"""
extension to pandas parquet reader and writer

because MultiIndex and integers are not supported as index/columns


index.freq & index/column name are not implemented by parquet
2019-01-12
"""


def _check_name(filename):
    """
    Check if name has a common parquet file-extension.

    Args:
        filename (str): old filename with or without extension

    Returns:
        str: new filename with extension
    """
    if isinstance(filename, Path):
        if not filename.suffix in ('.parq', '.parquet'):
            filename = filename.with_suffix('.parq')
    else:
        if not (filename.endswith('.parq') or filename.endswith('.parquet')):
            filename += '.parq'
    return filename


def _multiindex_to_index(multiindex, sep='/'):
    """

    Args:
        multiindex (pandas.MultiIndex): old index with multiple level

    Returns:
        pandas.Index: new index with one levels
    """
    if isinstance(multiindex, pd.MultiIndex):
        # compact_name = '/'.join(str(c) for c in multiindex.names)
        multiindex = [sep.join(str(c) for c in col).strip() for col in multiindex.values]
        # multiindex.name = compact_name
    return multiindex


def write(data, filename, compression='brotli', sep='/'):
    """
    Write data to parquet.

    Based on :meth:`pandas.DataFrame.to_parquet` to write the file.

    .. Important::
        To overcome the disability to write multi-indices in the parquet file, the multi-indices get converted as string
        and separated with the character defined by ``sep`` (default: ``'/'``)

    Args:
        data (pandas.DataFrame or pandas.Series):
        filename (str | Path): path to resulting file
        compression (str): Used compression. See :meth:`pandas.DataFrame.to_parquet`
        sep (str): Character used to separate multiindex labels in the parquet file. (default: ``'/'``)
    """
    filename = _check_name(filename)
    if isinstance(data, pd.Series):
        df = data.to_frame()
    else:
        df = data.copy()

    df.index = _multiindex_to_index(df.index, sep=sep)
    df.columns = _multiindex_to_index(df.columns, sep=sep)

    df.to_parquet(filename, compression=compression)


def _index_to_multiindex(index, sep='/'):
    """

    Args:
        index (pandas.Index): old index with one level

    Returns:
        pandas.MultiIndex: new index with multiple levels
    """
    if (index.dtype == 'object') and index.str.contains(sep).all():
        # old_name = index.name
        index = pd.MultiIndex.from_tuples([col.split(sep) for col in index])
        # if isinstance(old_name, str):
        #     new_names = old_name.split('/')
        #     index.names = new_names
    return index


def read(filename, sep='/'):
    """
    Read parquet file.

    Based on :func:`pandas.read_parquet` to write the file.

    .. Important::
        To overcome the disability to write multi-indices in the parquet file, the multi-indices get converted as string
        and separated with the character defined by ``sep`` (default: ``'/'``)

    Args:
        filename (str | Path): path to parquet file
        sep (str): Character used to separate multiindex labels in the parquet file. (default: ``'/'``)

    Returns:
        pandas.DataFrame: data
    """
    filename = _check_name(filename)
    df = pd.read_parquet(filename)
    df.columns = _index_to_multiindex(df.columns, sep=sep)
    df.index = _index_to_multiindex(df.index, sep=sep)
    return df
