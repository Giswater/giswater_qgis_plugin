/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

UPDATE config_toolbox SET
alias = 'Arcs shorter/bigger than specific length',
inputparams = '[{"label": "Arc length shorter than:", "datatype": "string", "layoutname": "grl_option_parameters", "widgetname": "shorterThan", "widgettype": "text", "layoutorder": 1}, 
{"label": "Arc length bigger than:", "datatype": "string", "layoutname": "grl_option_parameters", "widgetname": "biggerThan", "widgettype": "text", "layoutorder": 2}]'
WHERE id = 3052;

