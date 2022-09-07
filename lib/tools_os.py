# -*- coding: utf-8 -*-
"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
import configparser
import os
import pathlib
import sys
import subprocess
import urllib.parse as parse
import webbrowser
import re
from chardet import detect

from qgis.PyQt.QtWidgets import QFileDialog

from . import tools_log


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
        # Open selected document
        # Check if path is URL
        url_regex = r"""(?i)\b((?:https?:(?:/{1,3}|[a-z0-9%])|[a-z0-9.\-]+[.](?:com|net|org|edu|gov|mil|aero|asia|biz|cat|coop|info|int|jobs|mobi|museum|name|post|pro|tel|travel|xxx|ac|ad|ae|af|ag|ai|al|am|an|ao|aq|ar|as|at|au|aw|ax|az|ba|bb|bd|be|bf|bg|bh|bi|bj|bm|bn|bo|br|bs|bt|bv|bw|by|bz|ca|cc|cd|cf|cg|ch|ci|ck|cl|cm|cn|co|cr|cs|cu|cv|cx|cy|cz|dd|de|dj|dk|dm|do|dz|ec|ee|eg|eh|er|es|et|eu|fi|fj|fk|fm|fo|fr|ga|gb|gd|ge|gf|gg|gh|gi|gl|gm|gn|gp|gq|gr|gs|gt|gu|gw|gy|hk|hm|hn|hr|ht|hu|id|ie|il|im|in|io|iq|ir|is|it|je|jm|jo|jp|ke|kg|kh|ki|km|kn|kp|kr|kw|ky|kz|la|lb|lc|li|lk|lr|ls|lt|lu|lv|ly|ma|mc|md|me|mg|mh|mk|ml|mm|mn|mo|mp|mq|mr|ms|mt|mu|mv|mw|mx|my|mz|na|nc|ne|nf|ng|ni|nl|no|np|nr|nu|nz|om|pa|pe|pf|pg|ph|pk|pl|pm|pn|pr|ps|pt|pw|py|qa|re|ro|rs|ru|rw|sa|sb|sc|sd|se|sg|sh|si|sj|Ja|sk|sl|sm|sn|so|sr|ss|st|su|sv|sx|sy|sz|tc|td|tf|tg|th|tj|tk|tl|tm|tn|to|tp|tr|tt|tv|tw|tz|ua|ug|uk|us|uy|uz|va|vc|ve|vg|vi|vn|vu|wf|ws|ye|yt|yu|za|zm|zw)/)(?:[^\s()<>{}\[\]]+|\([^\s()]*?\([^\s()]+\)[^\s()]*?\)|\([^\s]+?\))+(?:\([^\s()]*?\([^\s()]+\)[^\s()]*?\)|\([^\s]+?\)|[^\s`!()\[\]{};:'".,<>?«»“”‘’])|(?:(?<!@)[a-z0-9]+(?:[.\-][a-z0-9]+)*[.](?:com|net|org|edu|gov|mil|aero|asia|biz|cat|coop|info|int|jobs|mobi|museum|name|post|pro|tel|travel|xxx|ac|ad|ae|af|ag|ai|al|am|an|ao|aq|ar|as|at|au|aw|ax|az|ba|bb|bd|be|bf|bg|bh|bi|bj|bm|bn|bo|br|bs|bt|bv|bw|by|bz|ca|cc|cd|cf|cg|ch|ci|ck|cl|cm|cn|co|cr|cs|cu|cv|cx|cy|cz|dd|de|dj|dk|dm|do|dz|ec|ee|eg|eh|er|es|et|eu|fi|fj|fk|fm|fo|fr|ga|gb|gd|ge|gf|gg|gh|gi|gl|gm|gn|gp|gq|gr|gs|gt|gu|gw|gy|hk|hm|hn|hr|ht|hu|id|ie|il|im|in|io|iq|ir|is|it|je|jm|jo|jp|ke|kg|kh|ki|km|kn|kp|kr|kw|ky|kz|la|lb|lc|li|lk|lr|ls|lt|lu|lv|ly|ma|mc|md|me|mg|mh|mk|ml|mm|mn|mo|mp|mq|mr|ms|mt|mu|mv|mw|mx|my|mz|na|nc|ne|nf|ng|ni|nl|no|np|nr|nu|nz|om|pa|pe|pf|pg|ph|pk|pl|pm|pn|pr|ps|pt|pw|py|qa|re|ro|rs|ru|rw|sa|sb|sc|sd|se|sg|sh|si|sj|Ja|sk|sl|sm|sn|so|sr|ss|st|su|sv|sx|sy|sz|tc|td|tf|tg|th|tj|tk|tl|tm|tn|to|tp|tr|tt|tv|tw|tz|ua|ug|uk|us|uy|uz|va|vc|ve|vg|vi|vn|vu|wf|ws|ye|yt|yu|za|zm|zw)\b/?(?!@)))"""
        regex = re.compile(url_regex, re.IGNORECASE)
        if re.match(regex, file_path) is not None:
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


def get_encoding_type(file_path):
    with open(file_path, 'rb') as f:
        rawdata = f.read()
    return detect(rawdata)['encoding']


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


def get_number_of_files(folder):
    """ Get number of files of @folder and its subfolders """

    if not os.path.exists(folder):
        return 0

    file_count = sum(len(files) for _, _, files in os.walk(folder))
    return file_count


def ireplace(old, new, text):
    """ Replaces @old by @new in @text (case-insensitive) """

    return re.sub('(?i)'+re.escape(old), lambda m: new, text)


def manage_pg_service(section):

    service_file = os.environ.get('PGSERVICEFILE')
    if service_file is None:
        return None

    if not os.path.exists(service_file):
        tools_log.log_warning(f"File defined in environment variable 'PGSERVICEFILE' not found: {service_file}")
        return None

    config_parser = configparser.ConfigParser()
    credentials = {'host': None, 'port': None, 'dbname': None, 'user': None, 'password': None, 'sslmode': None}
    try:
        config_parser.read(service_file)
        if config_parser.has_section(section):
            params = config_parser.items(section)
            if not params:
                tools_log.log_warning(f"No parameters found in section {section}")
                return None
            else:
                for param in params:
                    credentials[param[0]] = param[1]
        else:
            tools_log.log_warning(f"Section '{section}' not found in the file {service_file}")
    except configparser.DuplicateSectionError as e:
        tools_log.log_warning(e)
    finally:
        return credentials

