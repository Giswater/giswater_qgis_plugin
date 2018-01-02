"""
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
"""

# -*- coding: utf-8 -*-
import os

from keyczar import keyczar
from keyczar import keyczart
from keyczar.errors import KeyczarError

# Note that the names used in these format strings
# should be used in your code
FMT_CREATE = 'create --location=%(loc)s --purpose=crypt'
FMT_ADDKEY = 'addkey --location=%(loc)s --status=primary'


def _require_dir(loc):
    """ Make sure that loc is a directory. If it does not exist, create it """
    if os.path.exists(loc):
        if not os.path.isdir(loc):
            raise ValueError( '%s must be a directory' % loc)
    else:
        # should we verify that containing dir is 0700?
        os.makedirs(loc, 0755)

def _tool(fmt, **kwds):
    """ Package the call to keyczart.main
        which is awkwardly setup for command-line use without
        organizing the underlying logic for direct function calls.
    """
    return keyczart.main((fmt % kwds).split())
    
def _initialize(loc, **kwds):
    """Initialize a location. Create it. Add a primary key """
    _require_dir(loc)
    steps = [FMT_CREATE, FMT_ADDKEY]
    for step in steps:
        _tool(step, loc=loc, **kwds)


class Crypter(object):
    """ Simplify use of keyczar.Crypter class """
    
    location = 'stdkeyset'

    @staticmethod
    def _read(loc):
        return keyczar.Crypter.Read(loc)

    def __init__(self, loc=None):
        if loc is None:
            loc = self.location
        try:
            self.crypt = self._read(loc)
        except KeyczarError:
            _initialize(loc)
            self.crypt = self._read(loc)

    def encrypt(self, s):
        return self.crypt.Encrypt(s)

    def decrypt(self, s):
        return self.crypt.Decrypt(s)
    
    