# -*- coding: utf-8 -*-
"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""

__author__ = 'Luigi Pirelli'
__date__ = 'January 2018'
__copyright__ = '(C) 2018, Luigi Pirelli'

# This will get replaced with a git SHA1 when you do a git archive

__revision__ = '$Format:%H$'

from .table import GwTable, GwGenericDescriptor


class GwVisitXConnec(GwTable):
    """ Class to serialize table 'om_visit_x_connec' """

    id = GwGenericDescriptor(-1)
    visit_id = GwGenericDescriptor(None)
    connec_id = GwGenericDescriptor(None)
    is_last = GwGenericDescriptor(None)

    def __init__(self):
        """ Class constructor """
        GwTable.__init__(self, 'om_visit_x_connec', 'id')

