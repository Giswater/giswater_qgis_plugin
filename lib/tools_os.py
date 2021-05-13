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
import urllib.parse as parse
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
        # Parse a URL into components
        url = parse.urlsplit(file_path)

        # Open selected document
        # Check if path is URL
        if url.scheme == "http" or url.scheme == "https":
            webbrowser.open(file_path)
        else:
            if not os.path.exists(file_path):
                message = "File not found"
                return False, message
            else:
                if sys.platform == "win32":
                    os.startfile(file_path)
                else:
                    opener = "open" if sys.platform == "darwin" else "xdg-open"
                    subprocess.call([opener, file_path])
        return True, None
    except Exception:
        return False, None



def get_relative_path(filepath, levels=1):

    common = filepath
    for i in range(levels + 1):
        common = os.path.dirname(common)

    return os.path.relpath(filepath, common)


def get_values_from_dictionary(dictionary):
    """ Return values from @dictionary """

    list_values = iter(dictionary.values())
    return list_values


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


def get_folder_size(folder):
    """ Get folder size """

    if not os.path.exists(folder):
        return 0

    size = 0
    for file in os.listdir(folder):
        filepath = os.path.join(folder, file)
        if os.path.isfile(filepath):
            size += os.path.getsize(filepath)

    return size

