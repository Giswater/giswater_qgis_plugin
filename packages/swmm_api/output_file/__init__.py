from .out import read_out_file, SwmmOutput, out2frame
from .definitions import VARIABLES, OBJECTS
from .analysis import agg_events, get_event_table
from . import definitions as OUT
from . import parquet_helpers
parq = parquet_helpers