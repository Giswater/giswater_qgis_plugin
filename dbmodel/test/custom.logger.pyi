"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
import logging

class CustomLogger(logging.Logger):
    def success(self, message: str, *args, **kwargs) -> None: ...

logger: CustomLogger
