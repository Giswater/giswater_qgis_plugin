# -*- coding: utf-8 -*-
"""This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""

__author__ = 'Daniel Marn'
__date__ = 'March 2025'
__copyright__ = '(C) 2025, Daniel Marn'

# This will get replaced with a git SHA1 when you do a git archive

__revision__ = '$Format:%H$'

from .models_manager import GwTable, GwGenericDescriptor


class GwOmVisitXLink(GwTable):
    """Class to serialize table 'om_visit_x_link'"""

    id = GwGenericDescriptor(-1)
    visit_id = GwGenericDescriptor(None)
    link_id = GwGenericDescriptor(None)
    is_last = GwGenericDescriptor(None)

    def __init__(self):

        GwTable.__init__(self, 'om_visit_x_link', 'id')

