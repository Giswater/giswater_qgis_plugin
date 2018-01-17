# -*- coding: utf-8 -*-
"""
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""

__author__ = 'Luigi Pirelli'
__date__ = 'January 2018'
__copyright__ = '(C) 2018, Luigi Pirelli'

# This will get replaced with a git SHA1 when you do a git archive

__revision__ = '$Format:%H$'

class Event(object):
    """Base class for composed events."""

    def __init__(self, controller):
        """constructor."""
        super(Event, self)-__init__()

        # save DB engine top allow queries
        _controller = controller

        _id = None
        _ext_code = None
        _position_id = None
        _position_value = None
        _parameter_id = None
        _value = None
        _value1 = None
        _value2 = None
        _geom1 = None
        _geom2 = None
        _geom3 = None
        _xcoord = None
        _ycoord = None
        _compass = None
        _tstamp = None
        _text = None
        _index_val = None
        _is_last = None

    def get(self, id):
        """retrieve a record with a specified primary key id."""
        pass

    def save(self):
        """Save current event in the DB as new record."""
        pass

    def update(self):
        """Dump current event state in db if record exist."""
        pass

    @property
    def id(self):
        return self._id
    @id.setter
    def id(self, v):
        self._id = v

    @property
    def ext_code(self):
        return self._ext_code
    @ext_code.setter
    def ext_code(self, v):
        self._ext_code = v

    @property
    def visit_id(self):
        return self._visit_id
    @visit_id.setter
    def visit_id(self, v):
        self._visit_id = v

    @property
    def position_id(self):
        return self._position_id
    @position_id.setter
    def position_id(self, v):
        self._position_id = v

    @property
    def position_value(self):
        return self._position_value
    @position_value.setter
    def position_value(self, v):
        self._position_value = v

    @property
    def parameter_id(self):
        return self._parameter_id
    @parameter_id.setter
    def parameter_id(self, v):
        self._parameter_id = v

    @property
    def value(self):
        return self._value
    @value.setter
    def value(self, v):
        self._value = v

    @property
    def value1(self):
        return self._value1
    @value1.setter
    def value1(self, v):
        self._value1 = v

    @property
    def value2(self):
        return self._value2
    @value2.setter
    def value2(self, v):
        self._value2 = v

    @property
    def geom1(self):
        return self._geom1
    @geom1.setter
    def geom1(self, v):
        self._geom1 = v

    @property
    def geom2(self):
        return self._geom2
    @geom2.setter
    def geom2(self, v):
        self._geom2 = v

    @property
    def geom3(self):
        return self._geom3
    @geom3.setter
    def geom3(self, v):
        self._geom3 = v

    @property
    def xcoord(self):
        return self._xcoord
    @xcoord.setter
    def xcoord(self, v):
        self._xcoord = v

    @property
    def ycoord(self):
        return self._ycoord
    @ycoord.setter
    def ycoord(self, v):
        self._ycoord = v

    @property
    def compass(self):
        return self._compass
    @compass.setter
    def compass(self, v):
        self._compass = v

    @property
    def tstamp(self):
        return self._tstamp
    @tstamp.setter
    def tstamp(self, v):
        self._tstamp = v

    @property
    def tstamp(self):
        return self._tstamp
    @tstamp.setter
    def tstamp(self, v):
        self._tstamp = v

    @property
    def text(self):
        return self._text
    @text.setter
    def text(self, v):
        self._text = v

    @property
    def index_val(self):
        return self._index_val
    @index_val.setter
    def index_val(self, v):
        self._index_val = v

    @property
    def is_last(self):
        return self._is_last
    @is_last.setter
    def is_last(self, v):
        self._is_last = v
