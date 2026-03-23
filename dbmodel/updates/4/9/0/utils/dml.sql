/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 19/03/2026
INSERT INTO inp_typevalue (typevalue, id, idval, descript, addparam) 
VALUES('inp_typevalue_dscenario', 'PATTERN', 'PATTERN', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;

INSERT INTO config_function (id, function_name, "style", layermanager, actions) 
VALUES(3536, 'gw_fct_getmincutminsector', '{
  "style": {
    "Valves": {
      "style": "categorized",
      "field": "closed"
    },
    "Arcs": {
      "style": "categorized",
      "field": "minsector_id"
    },
    "Connecs": {
      "style": "categorized",
      "field": "minsector_id"
    }
  }
}'::json, NULL, NULL)
ON CONFLICT DO NOTHING;