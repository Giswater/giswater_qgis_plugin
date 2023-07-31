/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME ,public;

UPDATE config_function set style = '{"style": {"polygon": {"style": "categorized","field": "minsector_id",  "transparency": 0.5}}}' WHERE id = 2706;