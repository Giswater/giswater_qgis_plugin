import os
import warnings


def read_txt_file(filename, encoding):
    """
    Read text file. I.e. SWMM inp and rpt file.

    Args:
        filename (str or pathlib.Path): Path/filename to text-file.
        encoding (str): Encoding of the text-file (None -> auto-detect encoding ... takes a few seconds | '' -> use default = 'utf-8')

    Returns:
        str: Content of the text-file.
    """
    # import cchardet as chardet
    # with open(filename, "rb") as f:
    #     binary_txt = f.read()
    #     detection = chardet.detect(binary_txt)
    #     encoding1 = detection["encoding"]
    #     confidence1 = detection["confidence"]
    #     txt1 = binary_txt.decode(encoding1)
    if isinstance(filename, (str, bytes, os.PathLike)):
        with open(filename, 'rb') as file:
            binary = file.read()
    else:
        try:
            binary = filename.read()
        except AttributeError:
            raise IOError('Provided file can\'t be read')

    for e in (encoding, 'utf8', 'iso-8859-1', 'windows-1252'):
        try:
            return binary.decode(encoding=e).replace('\r', '')
        except UnicodeDecodeError:
            continue
    warnings.warn(f'Could not find correct encoding (found "{encoding}", but is wrong) for file ("{filename}"). Please set encoding manually.')
    return binary.decode().replace('\r', '')
