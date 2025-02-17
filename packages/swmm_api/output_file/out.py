__author__ = "Markus Pichler"
__credits__ = ["Markus Pichler"]
__maintainer__ = "Markus Pichler"
__email__ = "markus.pichler@tugraz.at"
__version__ = "0.1"
__license__ = "MIT"

import datetime
import warnings
from itertools import product
from pathlib import Path

import numpy as np
import pandas as pd

from pandas._libs import OutOfBoundsDatetime

from .extract import SwmmOutExtract
from .definitions import OBJECTS, VARIABLES

from . import parquet_helpers as parquet
from .helpers import drop_useless_column_levels


class SwmmOutputWarning(UserWarning):
    pass


class SwmmOutput(SwmmOutExtract):
    """
    SWMM-output-file class.

    Attributes:
        filename (str): Path to the output-file (.out).
        index (pandas.DatetimeIndex): Index of the timeseries of the data.
        flow_unit (str): Flow unit. One of [``'CMS', 'LPS', 'MLD', 'CFS', 'GPM', 'MGD'``]
        labels (dict[str, list]): dictionary of the object labels as list (value) for each object type (keys are: ``'link'``, ``'node'``, ``'subcatchment'``)
        model_properties (dict[str, [dict[str, list]]]): property values for the subcatchments, nodes and links.
            The Properties for the objects are...

            - ``'subcatchment'``
                - [area]
            - ``'node'``
                - [type, invert, max. depth]
            - ``'link'``
                - type,
                - offsets
                    - ht. above start node invert (ft),
                    - ht. above end node invert (ft),
                - max. depth,
                - length

        pollutant_units (dict[str, str]): Units per pollutant.
        report_interval (datetime.timedelta): Intervall of the index.
        start_date (datetime.datetime): Start date of the data.
        swmm_version (str): SWMM Version
        variables (dict[str, list]): variables per object-type inclusive the pollutants.
        fp (file-like): Stream of the open file.
    """
    filename: str | Path

    def __init__(self, filename, skip_init=False, encoding=''):
        """
        Read a SWMM-output-file (___.out).

        Args:
            filename(str | Path): Path to the output-file (.out).
            encoding (str): Encoding of the text in the binary-file (None -> auto-detect encoding ... takes a few seconds | '' -> use default = 'utf-8')
        """
        SwmmOutExtract.__init__(self, filename, skip_init=skip_init, encoding=encoding)

        self._frame = None
        self._data = None

        if skip_init:
            return

        # the main datetime index for the results
        self.index = self._get_index()

    def __enter__(self):
        return self

    def _get_dtypes(self):
        """
        Get the dtypes of the data.

        Returns:
            str: numpy types
        """
        return 'f8' + ',f4' * self.number_columns

    @property
    def number_columns(self):
        """
        Get number of columns of the full results table.

        Returns:
            int: Number of columns of the full results table.
        """
        return sum(
            len(self.variables[kind]) * len(self.labels[kind])
            for kind in OBJECTS.LIST_
        )

    @property
    def _columns_raw(self):
        """
        get the column-names of the data

        Returns:
            list[list[str]]: multi-level column-names
        """
        columns = []
        for kind in OBJECTS.LIST_:
            columns += list(product([kind], self.labels[kind], self.variables[kind]))
        return columns

    def _get_index(self, start=None, end=None):
        if start is None:
            start = self.start_date

        # n_periods = number of time-steps (rows) to read (including start time-step (row))
        if end is None:
            n_periods = int(self.n_periods - (start - self.start_date) / self.report_interval)
        else:
            n_periods = int((end - start) / self.report_interval) + 1

        try:
            return pd.date_range(start, periods=n_periods, freq=self.report_interval)
        except OutOfBoundsDatetime:
            warnings.warn('Can not create a pandas.DatetimeIndex in given date-range. Default to pandas.Index.')
            return pd.Index([start + self.report_interval * i for i in range(n_periods)])

    def to_numpy(self, ignore_filesize=False, start=None, end=None):
        """
        Convert all data to a numpy-array.

        Args:
            ignore_filesize (bool): hide a warning when reading a huge output-file.
            start (datetime): start datetime for the period to read.
            end (datetime): end datetime for the period to read.

        Returns:
            numpy.ndarray: all data
        """
        if self._data is None:

            if not ignore_filesize and isinstance(self.filename, Path):
                stats_file = self.filename.lstat()
                filesize = stats_file.st_size  # in bytes
                filesize_gb = filesize*1e-9
                if filesize_gb > 6:
                    warnings.warn(f"You are attempting to read a large output file ({filesize_gb:0.3f} GB), "
                                  f"which could potentially lead to memory overflow. "
                                  f"If you are only interested in a specific portion of the file, "
                                  f"please utilize the .get_part() function with the slim=True parameter. "
                                  f"This way, only the necessary data is read from the file. "
                                  f"To disregard and suppress this message, use the ignore_filesize=True parameter.", SwmmOutputWarning)

            types = [('datetime', 'f8')] + [('/'.join(i), 'f4') for i in self._columns_raw]

            pos_start_output, n_periods = self._get_start_position_and_periods(start, end)

            self.fp.seek(pos_start_output, 0)

            if isinstance(self.filename, str) and (self.filename == '<stream>'):
                array = np.frombuffer(self.fp.read1(), dtype=np.dtype(types), count=n_periods)
            else:
                try:
                    array = np.fromfile(self.fp, dtype=np.dtype(types), count=n_periods)
                except:
                    array = np.frombuffer(self.fp.read1(), dtype=np.dtype(types), count=n_periods)

            if all([i is None for i in [start, end]]):
                # if file is incomplete n_periods can be different to inferred number of periods
                self.n_periods = int(array.size)
                self.index = self._get_index(start, end)

                # if the data is not sliced, save it as an attribute
                self._data = array

            return array

        # if the attribute self._data is already set
        if not all([i is None for i in [start, end]]):
            # slice data
            if start is None:
                i_start = None
            else:
                i_start = (self.index < start).sum()
            if end is None:
                i_end = None
            else:
                i_end = -(self.index > end).sum()
            return self._data[i_start:i_end]

        return self._data

    def to_frame(self, ignore_filesize=False):
        """
        Convert all the data to a pandas-DataFrame.

        .. Important::
            This function may take a long time if the out-file has with many objects (=columns).
            If you just want the data of a few columns use :meth:`SwmmOutput.get_part` instead.

        Args:
            ignore_filesize (bool): hide a warning when reading a huge output-file.

        Returns:
            pandas.DataFrame: data
        """
        if self._frame is None:
            self._frame = self._to_pandas(self.to_numpy(ignore_filesize=ignore_filesize))
            del self._frame['datetime']
        return self._frame

    def get_part(self, kind=None, label=None, variable=None, slim=False, show_progress=True, ignore_filesize=False, start=None, end=None):
        """
        Get specific columns of the data.

        .. Important::
            Set the parameter ``slim`` to ``True`` to speedup the code if you just want a few columns and
            there are a lot of objects (many columns) and just few time-steps (fewer rows) in the out-file.

        Args:
            kind (str | list | optional): [``'subcatchment'``, ``'node'`, ``'link'``, ``'system'``] (predefined in :obj:`swmm_api.output_file.definitions.OBJECTS`)
            label (str | list | optional): name of the objekts
            variable (str | list | optional): variable names (predefined in :obj:`swmm_api.output_file.definitions.VARIABLES`)

                * subcatchment:
                    - ``rainfall`` or :attr:`~swmm_api.output_file.definitions.SUBCATCHMENT_VARIABLES.RAINFALL`
                    - ``snow_depth`` or :attr:`~swmm_api.output_file.definitions.SUBCATCHMENT_VARIABLES.SNOW_DEPTH`
                    - ``evaporation`` or :attr:`~swmm_api.output_file.definitions.SUBCATCHMENT_VARIABLES.EVAPORATION`
                    - ``infiltration`` or :attr:`~swmm_api.output_file.definitions.SUBCATCHMENT_VARIABLES.INFILTRATION`
                    - ``runoff`` or :attr:`~swmm_api.output_file.definitions.SUBCATCHMENT_VARIABLES.RUNOFF`
                    - ``groundwater_outflow`` or :attr:`~swmm_api.output_file.definitions.SUBCATCHMENT_VARIABLES.GW_OUTFLOW`
                    - ``groundwater_elevation`` or :attr:`~swmm_api.output_file.definitions.SUBCATCHMENT_VARIABLES.GW_ELEVATION`
                    - ``soil_moisture`` or :attr:`~swmm_api.output_file.definitions.SUBCATCHMENT_VARIABLES.SOIL_MOISTURE`
                * node:
                    - ``depth`` or :attr:`~swmm_api.output_file.definitions.NODE_VARIABLES.DEPTH`
                    - ``head`` or :attr:`~swmm_api.output_file.definitions.NODE_VARIABLES.HEAD`
                    - ``volume`` or :attr:`~swmm_api.output_file.definitions.NODE_VARIABLES.VOLUME`
                    - ``lateral_inflow`` or :attr:`~swmm_api.output_file.definitions.NODE_VARIABLES.LATERAL_INFLOW`
                    - ``total_inflow`` or :attr:`~swmm_api.output_file.definitions.NODE_VARIABLES.TOTAL_INFLOW`
                    - ``flooding`` or :attr:`~swmm_api.output_file.definitions.NODE_VARIABLES.FLOODING`
                * link:
                    - ``flow`` or :attr:`~swmm_api.output_file.definitions.LINK_VARIABLES.FLOW`
                    - ``depth`` or :attr:`~swmm_api.output_file.definitions.LINK_VARIABLES.DEPTH`
                    - ``velocity`` or :attr:`~swmm_api.output_file.definitions.LINK_VARIABLES.VELOCITY`
                    - ``volume`` or :attr:`~swmm_api.output_file.definitions.LINK_VARIABLES.VOLUME`
                    - ``capacity`` or :attr:`~swmm_api.output_file.definitions.LINK_VARIABLES.CAPACITY`
                * system:
                    - ``air_temperature`` or :attr:`~swmm_api.output_file.definitions.SYSTEM_VARIABLES.AIR_TEMPERATURE`
                    - ``rainfall`` or :attr:`~swmm_api.output_file.definitions.SYSTEM_VARIABLES.RAINFALL`
                    - ``snow_depth`` or :attr:`~swmm_api.output_file.definitions.SYSTEM_VARIABLES.SNOW_DEPTH`
                    - ``infiltration`` or :attr:`~swmm_api.output_file.definitions.SYSTEM_VARIABLES.INFILTRATION`
                    - ``runoff`` or :attr:`~swmm_api.output_file.definitions.SYSTEM_VARIABLES.RUNOFF`
                    - ``dry_weather_inflow`` or :attr:`~swmm_api.output_file.definitions.SYSTEM_VARIABLES.DW_INFLOW`
                    - ``groundwater_inflow`` or :attr:`~swmm_api.output_file.definitions.SYSTEM_VARIABLES.GW_INFLOW`
                    - ``RDII_inflow`` or :attr:`~swmm_api.output_file.definitions.SYSTEM_VARIABLES.RDII_INFLOW`
                    - ``direct_inflow`` or :attr:`~swmm_api.output_file.definitions.SYSTEM_VARIABLES.DIRECT_INFLOW`
                    - ``lateral_inflow`` or :attr:`~swmm_api.output_file.definitions.SYSTEM_VARIABLES.LATERAL_INFLOW`
                    - ``flooding`` or :attr:`~swmm_api.output_file.definitions.SYSTEM_VARIABLES.FLOODING`
                    - ``outflow`` or :attr:`~swmm_api.output_file.definitions.SYSTEM_VARIABLES.OUTFLOW`
                    - ``volume`` or :attr:`~swmm_api.output_file.definitions.SYSTEM_VARIABLES.VOLUME`
                    - ``evaporation`` or :attr:`~swmm_api.output_file.definitions.SYSTEM_VARIABLES.EVAPORATION`
                    - ``PET`` or :attr:`~swmm_api.output_file.definitions.SYSTEM_VARIABLES.PET`

            slim (bool): set to ``True`` to speedup the code if there are a lot of objects and just few time-steps in the out-file.
            processes (int): number of parallel processes for the slim-reading.
            show_progress (bool): show a progress bar for the slim-reading.
            ignore_filesize (bool): hide a warning when reading a huge output-file.
            start (datetime): start datetime for the period to read.
            end (datetime): end datetime for the period to read.

        Returns:
            pandas.DataFrame | pandas.Series: Filtered data.
                (return Series if only one column is selected otherwise return a DataFrame)
        """
        columns = self._filter_part_columns(kind, label, variable)

        if slim:
            values = self._get_selective_results(columns, show_progress=show_progress, start=start, end=end)
        else:
            values = self.to_numpy(ignore_filesize=ignore_filesize, start=start, end=end)[list(map('/'.join, columns))]

        index = self._get_index(start, end)

        return self._to_pandas(values, index, drop_useless=True)

    def _filter_part_columns(self, kind=None, label=None, variable=None):
        """
        filter which columns should be extracted

        Args:
            kind (str | list): ["subcatchment", "node", "link", "system"]
            label (str | list): name of the objekts
            variable (str | list): variable names

        Returns:
            list: filtered list of tuple(kind, label, variable)
        """

        def _filter(i, possibilities, error_label):
            if i is None:
                return possibilities
            elif isinstance(i, str):
                if i in possibilities:
                    return [i]
                elif kind is None:
                    return []
                else:
                    warnings.warn(f'Did not found {error_label} "{i}" in output-file, return empty data. Possibilities: {possibilities}.', SwmmOutputWarning)
                    return []
            elif isinstance(i, list):
                # return [j for j in i if j in possibilities]
                l = []
                for j in i:
                    if j in possibilities:
                        l.append(j)
                    elif kind is None:
                        continue
                    else:
                        warnings.warn(f'Did not found {error_label} "{j}" in output-file, skipping request. Possibilities: {possibilities}', SwmmOutputWarning)
                return l

        columns = []
        for k in _filter(kind, OBJECTS.LIST_, 'object kind'):
            columns += list(product([k],
                                    _filter(label, self.labels[k], f'{k} label'),
                                    _filter(variable, self.variables[k], f'{k} variable')))
        return columns

    def _to_pandas(self, data, index: pd.DatetimeIndex = None, drop_useless=False):
        """
        Convert interim results to pandas DataFrame or Series.

        Args:
            data (dict, numpy.ndarray): timeseries data of swmm out file
            drop_useless (bool): if single column data should be returned as Series

        Returns:
            (pandas.DataFrame | pandas.Series): pandas Timerseries of data
        """
        if index is None:
            index = self.index

        if (isinstance(data, np.ndarray) and (data.size == 0)) or (isinstance(data, dict) and not bool(data)):  # successful for dict and np.array
            return pd.DataFrame()

        df = pd.DataFrame(data, index=index, dtype=float)

        # if isinstance(data, dict):  # slim=True
        #     df = pd.DataFrame.from_dict(data).set_index(index)
        #
        # else:  # slim=False - default - numpy.array
        #     data: np.ndarray
        #
        #     # if data.shape[0] != index.size:
        #     #     warnings.warn('index length does not match data length -> slice data')
        #     #     data = data[:index.size]
        #
        #     pd.DataFrame.from_dict(data).set_index(index)
        #
        #     df = pd.DataFrame(data, index=index, dtype=float)

        # -----------
        if df.columns.size == 1:
            return df.iloc[:, 0]
        # -----------
        # create multi-index-columns
        df.columns = pd.MultiIndex.from_tuples([col.split('/') for col in df.columns])

        if drop_useless:
            drop_useless_column_levels(df)

        return df

    def to_parquet(self):
        """
        Write the data in a parquet file.

        multi-column-names are separated by a slash ("/")

        Uses the function :func:`swmm_api.output_file.parquet.write`, which is based on :meth:`pandas.DataFrame.to_parquet` to write the file.

        Read parquet files with :func:`swmm_api.output_file.parquet.read` to get the original column-name-structure.
        """
        # flow_unit, model_properties, run_failed, swmm_version as .attr
        frame = self.to_frame()
        frame.attrs = {
            'flow_unit': self.flow_unit,
            'model_properties': self.model_properties,
            'run_failed': self.run_failed,
            'swmm_version': self.swmm_version,
        }
        parquet.write(frame, self.filename.with_suffix('.parquet'))

    def _iter_chunks(self, rows_at_a_time=1000, show_progress=True, kind=None, label=None, variable=None, slim=False, sep='/'):
        types = np.dtype([('datetime', 'f8')] + [(sep.join(i), 'f4') for i in self._columns_raw])
        self.fp.seek(self._pos_start_output, 0)

        columns = self._filter_part_columns(kind, label, variable)
        use_columns = ['datetime'] + [sep.join(c) for c in columns]

        # ---
        if show_progress:
            import tqdm.auto as tqdm
            iterator = tqdm.trange(0, self.n_periods, rows_at_a_time)
        else:
            iterator = range(0, self.n_periods, rows_at_a_time)

        # ---
        for i in iterator:
            # print(self.fp.tell())
            if slim:
                progress_desc = f'{repr(self)}.get_selective_results(n_cols={len(columns)})'

                label_list, offset_list = self._get_labels_and_offsets(columns)

                from ._basic_selective_results import _get_selective_results

                _pos_start_output = self._pos_start_output + i * self._bytes_per_period

                data = _get_selective_results(self.fp, label_list, offset_list, _pos_start_output,
                                              rows_at_a_time, self._bytes_per_period, progress_desc)

                df = pd.DataFrame(data)

                df.index = pd.date_range(self.start_date + i * self.report_interval, periods=rows_at_a_time, freq=self.report_interval)

            else:
                data = np.fromfile(self.fp, dtype=types, count=rows_at_a_time)[use_columns]

                df = pd.DataFrame(data)

                df.index = (pd.Timedelta(days=1) * df.pop('datetime') + self._base_date).dt.round('s')
            yield df

    def to_parquet_chunks(self, fn, rows_at_a_time=1000, show_progress=True, kind=None, label=None, variable=None, slim=False):
        import pyarrow as pa
        import pyarrow.parquet as pq

        parq_writer = None
        for df in self._iter_chunks(rows_at_a_time=rows_at_a_time,
                                    show_progress=show_progress,
                                    kind=kind, label=label, variable=variable,
                                    slim=slim):  # type: pandas.DataFrame
            table = pa.Table.from_pandas(df)

            # for the first chunk of records
            if parq_writer is None:
                # create a parquet write object giving it an output file
                parq_writer = pq.ParquetWriter(fn, table.schema, compression='brotli')
            parq_writer.write_table(table)

        # close the parquet writer
        if parq_writer:
            parq_writer.close()

    def to_parquet_chunks_fast(self, fn, rows_at_a_time=1000, show_progress=True, kind=None, label=None, variable=None, slim=False):
        import pyarrow as pa
        import pyarrow.parquet as pq

        # Use a ParquetWriter for faster writes
        parq_writer = None

        # Prepare the writer in a more efficient loop
        for df in self._iter_chunks(rows_at_a_time=rows_at_a_time,
                                    show_progress=show_progress,
                                    kind=kind, label=label, variable=variable,
                                    slim=slim):  # type: pandas.DataFrame

            # Convert the DataFrame to a PyArrow Table
            table = pa.Table.from_pandas(df, preserve_index=False)  # Avoid writing index for efficiency

            if parq_writer is None:
                # Initialize the ParquetWriter on the first chunk
                parq_writer = pq.ParquetWriter(fn, schema=table.schema, compression='zstd', use_dictionary=True)

            # Write the table to the file
            parq_writer.write_table(table)

        # Ensure the writer is properly closed
        if parq_writer:
            parq_writer.close()

    def to_hdf5_chunks_pandas(self, fn, rows_at_a_time=1000, show_progress=True, kind=None, label=None, variable=None, slim=False, sep='/', complib=None, complevel=None):
        # Iterate through DataFrame chunks
        for i, df in enumerate(self._iter_chunks(rows_at_a_time=rows_at_a_time,
                                                 show_progress=show_progress,
                                                 kind=kind, label=label, variable=variable,
                                                 slim=slim, sep=sep)):  # type: pandas.DataFrame
            df.columns = pd.MultiIndex.from_tuples([col.split(sep) for col in df.columns])
            for obj_kind in self.variables:
                for var_label in self.variables[obj_kind]:
                    # print(obj_kind, var_label)
                    df_sel = df[obj_kind].xs(var_label, level=1, axis=1).rename(columns=lambda s: s.replace('/', '_'))
                    # print(df_sel)
                    # break
                    mode = 'w' if i == 0 else 'a'  # Write mode for the first chunk, append mode otherwise
                    # Write chunk to HDF5 file
                    df_sel.to_hdf(fn, key=f'{obj_kind}/{var_label}', mode=mode, format='table', append=True, complib=complib, complevel=complevel)
            # if i == 3:
            #     break

    def to_hdf5_chunks(self, fn, rows_at_a_time=1000, show_progress=True, kind=None, label=None, variable=None, slim=False):
        import pandas as pd
        import h5py
        import numpy as np

        # Open HDF5 file in append mode
        with h5py.File(fn, 'a') as h5file:
            dataset_created = False  # Track if the dataset is already created

            for df in self._iter_chunks(rows_at_a_time=rows_at_a_time,
                                        show_progress=show_progress,
                                        kind=kind, label=label, variable=variable,
                                        slim=slim):  # type: pandas.DataFrame

                # Convert DataFrame to numpy array for HDF5 compatibility
                data = df.to_numpy()
                columns = df.columns.tolist()  # Column names
                num_rows, num_cols = data.shape

                if not dataset_created:
                    # Create dataset on first chunk
                    dataset = h5file.create_dataset(
                        'data',  # Dataset name
                        shape=(0, num_cols),  # Initial shape with zero rows
                        maxshape=(None, num_cols),  # Allow unlimited rows
                        dtype=data.dtype  # Use inferred data type
                    )

                    # Store column names as an attribute
                    h5file.attrs['columns'] = np.string_(columns)

                    dataset_created = True

                # Resize dataset to accommodate new data
                dataset.resize(dataset.shape[0] + num_rows, axis=0)

                # Append new data to dataset
                dataset[-num_rows:] = data

    # def to_netcdf(self, fn_nc):
    #     import xarray as xr
    #     df = self.to_frame()
    #     ds = df.to_xarray()
    #     ds.to_netcdf("example.nc")
    #
    #     reopened = xr.open_dataset('Example6-Final.nc')
    #
    #     print()
    #
    #     # ---------------------
    #     import netCDF4 as nc
    #     import numpy as np
    #
    #     netcdf_output = nc.Dataset(fn_nc, mode='w', format="NETCDF4")
    #
    #     # -----
    #     # Timestamps
    #     netcdf_output.createDimension(dimname='datetime', size=None)
    #     nc_time_variable = netcdf_output.createVariable(
    #         varname="datetime",
    #         datatype=datetime.datetime,
    #         dimensions=("datetime",),
    #     )
    #
    #     nc_time_variable[:] = self.index
    #
    #     nc_time_variable.units = "hours since 0001-01-01 00:00:00.0"
    #     nc_time_variable.calendar = "gregorian"
    #
    #     nc_time_variable[:] = cftime.date2num(
    #         [datetime.datetime.fromtimestamp(t) for t in swmm_output_timestamps],
    #         units=nc_time_variable.units,
    #         calendar=nc_time_variable.calendar
    #     )


read_out_file = SwmmOutput


def out2frame(filename):
    """
    Get the content of the SWMM Output file as a DataFrame

    Args:
        filename (str): filename of the output file

    Returns:
        pandas.DataFrame: Content of the SWMM Output file

    .. Important::
        Don't use this function if many object are in the out file, and you only need few of them.
        In this case use the method :meth:`SwmmOutput.get_part` instead.
    """
    out = SwmmOutput(filename)
    return out.to_frame()
