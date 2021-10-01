"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from qgis.PyQt.QtCore import QObject, pyqtSignal


class GwSignalManager(QObject):
    show_message = pyqtSignal(str, int, int)
    refresh_selectors = pyqtSignal(str)

    def __init__(self):
        """
        This class has signals that are needed to bypass the limitation of threads working with Qt objects.
        Mainly used in tools_backend_calls.py as the notify from PostgreSQL is in a thread.
        An instance of this class always exists in global_vars
                                (signal_manager, created in main.py -> global_vars.signal_manager = GwSignalManager())

        To create a new signal you need to:
                1- Create the variable above like: signal_name = pyqtSignal(arg1_type, ...)
                2- Connect the signal in main.py -> def _create_signal_manager(self)
                Note: the arguments are passed to the connected function automatically,
                      you assign the arguments when you emit the signal
                3- Emit the signal when you want to execute the connected function like: signal_name.emit(arg1, ...)
        """

        QObject.__init__(self)
