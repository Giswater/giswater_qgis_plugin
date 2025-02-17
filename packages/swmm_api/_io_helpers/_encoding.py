import subprocess
import sys
import warnings
from pathlib import Path

from ._config import CONFIG


def get_default_encoding(encoding='', filename=None):
    """

    Args:
        encoding (str): Encoding of the text-file (None -> auto-detect encoding ... takes a few seconds | '' -> use default = 'utf-8')
        filename (str | pathlib.Path): path to file, for which the encoding should be detected.

    Returns:
        str: final encoding
    """
    if encoding is None:
        if filename is None:
            warnings.warn(f'Could not find correct encoding. Please set encoding manually.')
            return CONFIG.encoding
        return detect_encoding(filename)
    elif isinstance(encoding, str):
        if encoding == '':
            return CONFIG.encoding
        else:
            return encoding


def detect_encoding(filename):
    """
    Detect encoding of text-file.

    Args:
        filename (str | pathlib.Path): path to file, for which the encoding should be detected.

    Returns:

    """
    if "linux" in sys.platform:
        shell_output = subprocess.check_output(['file', '-i', str(filename)]).decode().strip()
    else:
        try:
            filename = Path(filename)
            cwd = filename.parent
            if not cwd:
                cwd = None
            shell_output = subprocess.check_output(f'bash -ic "file -i {filename.name}"',
                                                   cwd=cwd
                                                   ).decode().strip()
        except:
            try:
                import cchardet as chardet
                with open(filename, "rb") as f:
                    binary_txt = f.read()
                    detection = chardet.detect(binary_txt)
                    return detection["encoding"]
                    # confidence = detection["confidence"]
                    # txt1 = binary_txt.decode(encoding1)
            except:
                return 'utf-8'

    return shell_output.split('charset=')[-1]
