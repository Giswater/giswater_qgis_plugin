import os

from ..inp import SwmmInput


def split_inp_to_files(inp_fn, **kwargs):
    """
    spit an inp-file into the sections and write per section one file

    creates a subdirectory in the directory of the input file with the name of the input file (without ``.inp``)
    and creates for each section a ``.txt``-file

    Args:
        inp_fn (str): path to inp-file
        **kwargs: keyword arguments of the :func:`~swmm_api.input_file.inp_reader.read_inp_file`-function

    Keyword Args:
        custom_converter (dict): dictionary of {section: converter/section_type} Default: :const:`SECTION_TYPES`
    """
    parent = inp_fn.replace('.inp', '')
    os.mkdir(parent)
    inp = SwmmInput.read_file(inp_fn, **kwargs)
    for s in inp.keys():
        with open(os.path.join(parent, f'{s}.txt'), 'w') as f:
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
    for header_file in os.listdir(inp_fn):
        header = header_file.replace('.txt', '')
        with open(os.path.join(inp_fn, header_file), 'r') as f:
            inp[header] = f.read()
    return inp
