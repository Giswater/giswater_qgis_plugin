# -*- coding: utf-8 -*-
"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
import os
import pathlib
import sys
import subprocess
import time
import webbrowser

from qgis.PyQt.QtWidgets import QFileDialog


def get_datadir() -> pathlib.Path:

    """
    Returns a parent directory path
    where persistent application data can be stored.

    # linux: ~/.local/share
    # macOS: ~/Library/Application Support
    # windows: C:/Users/<USER>/AppData/Roaming
    """

    home = pathlib.Path.home()

    if sys.platform == "win32":
        return home / "AppData/Roaming"
    elif sys.platform == "linux":
        return home / ".local/share"
    elif sys.platform == "darwin":
        return home / "Library/Application Support"


def open_file(file_path):
    """
    Opens a file (as if you double-click it)
        :param file_path: Path of the file
    """

    try:
        # Check if file exist
        if os.path.exists(file_path):
            # Open file
            if sys.platform == "win32":
                os.startfile(file_path)
            else:
                opener = "open" if sys.platform == "darwin" else "xdg-open"
                subprocess.call([opener, file_path])
        else:
            webbrowser.open(file_path)
    except Exception:
        return False
    finally:
        return True


def set_filename(prefix_name='log', tstamp_format='%Y%m%d'):
    """ Set a file name format like 'prefix_timestamp.log' """

    tstamp = str(time.strftime(tstamp_format))
    name = prefix_name + "_" + tstamp + ".log"
    return name


def get_relative_path(filepath, levels=1):

    common = filepath
    for i in range(levels + 1):
        common = os.path.dirname(common)

    return os.path.relpath(filepath, common)


def get_values_from_dictionary(dictionary):
    """ Return values from @dictionary """

    list_values = iter(dictionary.values())
    return list_values


def open_url(widget):
    """ Opens a url with the default browser """

    path = widget.text()
    # Check if file exist
    if os.path.exists(path):
        # Open the document
        if sys.platform == "win32":
            os.startfile(path)
        else:
            opener = "open" if sys.platform == "darwin" else "xdg-open"
            subprocess.call([opener, path])
    else:
        webbrowser.open(path)


def set_boolean(param, default=True):
    """
    Receives a string and returns a bool
        :param param: String to cast (String)
        :param default: Value to return if the parameter is not one of the keys of the dictionary of values (Boolean)
        :return: default if param not in bool_dict (bool)
    """

    bool_dict = {True: True, "TRUE": True, "True": True, "true": True,
                 False: False, "FALSE": False, "False": False, "false": False}

    return bool_dict.get(param, default)


def open_file_path(msg="Select file", filter_="All (*.*)"):
    """ Open QFileDialog """

    path, filter_ = QFileDialog.getOpenFileName(None, msg, "", filter_)
    return path, filter_


def check_python_function(module, function_name):
    """ Check if function exist in @module """
    object_functions = [method_name for method_name in dir(module) if callable(getattr(module, method_name))]
    return function_name in object_functions
