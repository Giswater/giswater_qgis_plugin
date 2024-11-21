import struct
from io import SEEK_SET, BytesIO
from tqdm.auto import tqdm

_RECORDSIZE = 4


def _get_selective_results(fp: BytesIO, label_list: list[str], offset_list: list[int], pos_start_output: int,
                           n_periods: int, bytes_per_period: int, progress_desc: str, show_progress: bool):
    iter_label_offset = list(zip(label_list, offset_list))

    variable = range(pos_start_output,  # start
                     pos_start_output + n_periods * bytes_per_period,  # stop
                     bytes_per_period)  # step

    values = {col: [] for col in label_list}

    if show_progress:
        iterator = tqdm(variable, desc=progress_desc)
    else:
        iterator = variable

    # Wrap the loop with tqdm to show progress
    for period_offset in iterator:
        for label, offset in iter_label_offset:
            fp.seek(offset + period_offset, SEEK_SET)
            values[label].append(struct.unpack('f', fp.read(_RECORDSIZE))[0])

    return values
