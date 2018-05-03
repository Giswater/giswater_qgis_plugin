/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/



SET search_path = "SCHEMA_NAME", public, pg_catalog;


--FILL config_web_fields TABLE
------------------------------
INSERT INTO config_web_fields VALUES (81, 'F24', 'value', NULL, 'string', 12, NULL, '0.00', 'value', 'text', NULL, NULL, NULL, NULL, true, 4);
INSERT INTO config_web_fields VALUES (85, 'F24', 'value1', NULL, 'string', NULL, NULL, '0.00', 'value1', 'text', NULL, NULL, NULL, NULL, true, 5);
INSERT INTO config_web_fields VALUES (86, 'F24', 'value2', NULL, 'string', NULL, NULL, '0.00', 'value2', 'text', NULL, NULL, NULL, NULL, true, 6);
INSERT INTO config_web_fields VALUES (82, 'F24', 'geom1', NULL, 'string', NULL, NULL, '0.00', 'geom1', 'text', NULL, NULL, NULL, NULL, true, 7);
INSERT INTO config_web_fields VALUES (83, 'F24', 'geom2', NULL, 'string', NULL, NULL, '0.00', 'geom2', 'text', NULL, NULL, NULL, NULL, true, 8);
INSERT INTO config_web_fields VALUES (84, 'F24', 'geom3', NULL, 'string', NULL, NULL, '0.00', 'geom3', 'text', NULL, NULL, NULL, NULL, true, 9);
INSERT INTO config_web_fields VALUES (94, 'F22', 'parameter_id', NULL, 'string', 30, NULL, 'parameter', 'parameter_id', 'text', NULL, NULL, NULL, NULL, true, 1);
INSERT INTO config_web_fields VALUES (95, 'F23', 'parameter_id', NULL, 'string', NULL, NULL, 'parameter', 'parameter_id', 'text', NULL, NULL, NULL, NULL, true, 1);
INSERT INTO config_web_fields VALUES (90, 'F23', 'position_id', NULL, 'string', NULL, NULL, '', 'position_id', 'text', NULL, NULL, NULL, NULL, true, 2);
INSERT INTO config_web_fields VALUES (91, 'F23', 'position_value', NULL, 'string', NULL, NULL, '', 'position_value', 'text', NULL, NULL, NULL, NULL, true, 3);
INSERT INTO config_web_fields VALUES (92, 'F23', 'value', NULL, 'string', NULL, NULL, '0.00', 'value', 'text', NULL, NULL, NULL, NULL, true, 4);
INSERT INTO config_web_fields VALUES (93, 'F23', 'text', NULL, 'string', NULL, NULL, '', 'text', 'text', NULL, NULL, NULL, NULL, true, 5);
INSERT INTO config_web_fields VALUES (88, 'F22', 'value', NULL, 'string', NULL, NULL, '0.00', 'value', 'text', NULL, NULL, NULL, NULL, true, 2);
INSERT INTO config_web_fields VALUES (89, 'F22', 'text', NULL, 'string', NULL, NULL, '', 'text', 'text', NULL, NULL, NULL, NULL, true, 3);
INSERT INTO config_web_fields VALUES (78, 'F24', 'parameter_id', NULL, 'string', 30, NULL, 'parameter', 'parameter_id', 'text', NULL, NULL, NULL, NULL, true, 1);
INSERT INTO config_web_fields VALUES (79, 'F24', 'position_id', NULL, 'string', 30, NULL, '', 'position_id', 'text', NULL, NULL, NULL, NULL, true, 2);
INSERT INTO config_web_fields VALUES (80, 'F24', 'position_value', NULL, 'string', 12, NULL, '0.00', 'position_value', 'text', NULL, NULL, NULL, NULL, true, 3);

