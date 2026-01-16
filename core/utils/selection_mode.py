"""This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from enum import Enum


class GwSelectionMode(Enum):
    """Selection mode"""

    DEFAULT = 0
    EXPRESSION = 1
    PSECTOR = 2
    CAMPAIGN = 3
    EXPRESSION_CAMPAIGN = 4
    LOT = 5
    EXPRESSION_LOT = 6
    ELEMENT = 7
    FEATURE_END = 8
    VISIT = 9
    MINCUT_CONNEC = 10

