from pathlib import Path

from ..inp import SwmmInput


def split_inp_to_files(inp_fn, **kwargs):
    """
    spit an inp-file into the sections and write per section one file

    creates a subdirectory in the directory of the input file with the name of the input file (without ``.inp``)
    and creates for each section a ``.txt``-file

    Args:
        inp_fn (str): path to inp-file
        **kwargs: keyword arguments of the :func:`~swmm_api.input_file.inp.read_inp_file`-function

    Keyword Args:
        custom_converter (dict): dictionary of {section: converter/section_type} Default: :const:`SECTION_TYPES`
    """
    inp_fn = Path(inp_fn)
    parent = inp_fn.parent / inp_fn.stem
    parent.mkdir(exist_ok=True)
    inp = SwmmInput(inp_fn, **kwargs)
    for s in inp.keys():
        with open(parent / f'{s}.txt', 'w') as f:
            f.write(inp._data[s])


def read_split_inp_file(inp_fn):
    """
    use this function to read an split inp-file after splitting the file with the :func:`~split_inp_to_files`-function

    Args:
        inp_fn (str): path of the directory of the split inp-file

    Returns:
        SwmmInput: inp-file data
    """
    inp = SwmmInput()
    for header_file in Path(inp_fn).iterdir():
        with open(header_file, 'r') as f:
            inp[header_file.stem] = f.read()
    return inp
