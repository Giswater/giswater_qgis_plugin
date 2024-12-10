import abc
import struct
from io import SEEK_SET
from os import remove
from pathlib import Path

from ._encoding import get_default_encoding

_RECORDSIZE = 4


class BinaryReader(abc.ABC):
    """
    Parent class for reading the binary output- and hotstart-files (.out | .hst).

    Attributes:
        fp (file-like): Stream of the open file.
        filename (str): Path to the binary file.
    """

    def __init__(self, filename, encoding=''):
        """
        Read a binary file in SWMM. Used for output- and hotstart-files (.out | .hst).

        Args:
            filename (str | Path): Path to the binary file.
            encoding (str): Encoding of the text-file (None -> auto-detect encoding ... takes a few seconds | '' -> use default = 'utf-8')
        """
        self.fp = None
        if all([hasattr(filename, i) for i in ['tell', 'seek', 'read', 'close']]):
            self.fp = filename
            self.filename = '<stream>'
        else:
            self.fp = open(filename, "rb")
            self.filename = Path(filename)
        self.encoding = get_default_encoding(encoding)

    def __repr__(self):
        return f'{self.__class__.__name__}(file="{self.filename}")'

    def __enter__(self):
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        self.close()

    def close(self):
        """
        Close the .out-file.

        Close the binary file to prevent memory errors.
        """
        if self.fp is not None:
            self.fp.close()

    def delete(self):
        """
        Close and delete the .out-file.
        """
        self.close()
        remove(self.filename)

    def __del__(self):
        self.close()

    def _set_position(self, offset, whence=SEEK_SET):
        if self.fp.tell() != offset:
            self.fp.seek(offset, whence)

    def _next(self, n=1, dtype='i', flat=True):
        """
        read the next number or string in the binary .out-file

        Args:
            n (int): number of objects to read
            dtype (str): type of number to read ['i', 'f', 'd', 's', ...]
            flat (float): if just one object should be returned

        Returns:
            (int | float | str): read object
        """
        size = {'d': 2}.get(dtype, 1)
        if dtype == 's':
            s = self._next_base(f'{n}s', n)[0]
            return str(s, encoding=self.encoding, errors="replace")
        elif flat and (n == 1):
            return self._next_base(dtype, size * _RECORDSIZE)[0]
        else:
            return self._next_base(f'{n}{dtype}', n * size * _RECORDSIZE)

    def _next_base(self, fmt, size):
        """
        read from the binary .out-file

        Args:
            fmt (str): format of the read object(s)
            size (int): bytes to read

        Returns:
            (int | float | str): read object
        """
        return struct.unpack(fmt, self.fp.read(size))

    def _next_float(self):
        return self._next_base('f', _RECORDSIZE)[0]

    def _next_floats(self,  n):
        return self._next_base(f'{n}f', n * _RECORDSIZE)

    def _next_double(self):
        return self._next_base('d', _RECORDSIZE * 2)[0]

    def _next_doubles(self,  n):
        return self._next_base(f'{n}d', 2 * n * _RECORDSIZE)
