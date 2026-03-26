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

INSERT INTO config_function (id, function_name, "style", layermanager, actions) VALUES(3536, 'gw_fct_getmincutminsector', '{
  "style": {
    "Valves": {
      "style": "categorized",
      "field": "closed",
      "width": 2,
      "transparency": 0.5
    },
    "Arcs": {
      "style": "categorized",
      "field": "minsector_id",
      "width": 2,
      "transparency": 0.5
    },
    "Connecs": {
      "style": "categorized",
      "field": "minsector_id",
      "width": 2,
      "transparency": 0.5
    }
  }
}'::json, NULL, NULL);

-- 24/03/2026
UPDATE sys_function SET function_alias = 'MACROMAPZONES DYNAMIC SECTORITZATION' WHERE id = 3482;


INSERT INTO sys_table (id, descript, sys_role, "source")
VALUES('v_municipality', 'View of town cities and villages', 'role_edit', 'core');

INSERT INTO sys_table (id, descript, sys_role, "source")
VALUES('v_streetaxis', 'View of streetaxis', 'role_edit', 'core');

INSERT INTO sys_table (id, descript, sys_role, "source")
VALUES('v_address', 'View of entrance numbers', 'role_edit', 'core');

INSERT INTO sys_table (id, descript, sys_role, "source")
VALUES('v_plot', 'View of urban properties', 'role_edit', 'core');

INSERT INTO sys_table (id, descript, sys_role, "source")
VALUES('v_raster_dem', 'View to store raster DEM', 'role_edit', 'core');

INSERT INTO sys_table (id, descript, sys_role, "source")
VALUES('v_district', 'View of districts', 'role_edit', 'core');

INSERT INTO sys_table (id, descript, sys_role, "source")
VALUES('v_region', 'View of regions', 'role_edit', 'core');

INSERT INTO sys_table (id, descript, sys_role, "source")
VALUES('v_province', 'View of provinces', 'role_edit', 'core');

-- 26/03/2026
INSERT INTO inp_typevalue (typevalue, id, idval, descript, addparam) 
VALUES('inp_typevalue_dscenario', 'CALIBRATION', 'CALIBRATION', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
