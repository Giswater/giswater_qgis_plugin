/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;


INSERT INTO config_api_form_fields VALUES (nextval('SCHEMA_NAME.config_api_form_fields_id_seq'::regclass), 'printGeneric', 'utils', 'composer', 1, 1, true, NULL, 'combo', 'Composer:', NULL, NULL, NULL, NULL, NULL, false, NULL, true, NULL, 'SELECT 1 as id, ''1'' as idval FROM arc WHERE arc_id=''''', NULL, NULL, NULL, NULL, 'gw_api_setprint', NULL, NULL, NULL, NULL, NULL, NULL) ON CONFLICT ON CONSTRAINT config_api_form_fields_pkey2 DO NOTHING;
INSERT INTO config_api_form_fields VALUES (nextval('SCHEMA_NAME.config_api_form_fields_id_seq'::regclass),'printGeneric', 'utils', 'title', 2, 1, true, 'string', 'text', 'Title:', NULL, NULL, NULL, NULL, NULL, false, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, 'gw_api_setprint', NULL, NULL, NULL, NULL, NULL, NULL) ON CONFLICT ON CONSTRAINT config_api_form_fields_pkey2 DO NOTHING;
INSERT INTO config_api_form_fields VALUES (nextval('SCHEMA_NAME.config_api_form_fields_id_seq'::regclass),'printGeneric', 'utils', 'scale', 1, 2, true, 'double', 'text', 'Escale:', NULL, NULL, NULL, NULL, NULL, false, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, 'gw_api_setprint', NULL, NULL, NULL, NULL, NULL, NULL) ON CONFLICT ON CONSTRAINT config_api_form_fields_pkey2 DO NOTHING;
INSERT INTO config_api_form_fields VALUES (nextval('SCHEMA_NAME.config_api_form_fields_id_seq'::regclass),'printGeneric', 'utils', 'rotation', 1, 3, true, 'double', 'text', 'Rotation:', NULL, NULL, NULL, NULL, NULL, false, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, 'gw_api_setprint', NULL, NULL, NULL, NULL, NULL, NULL) ON CONFLICT ON CONSTRAINT config_api_form_fields_pkey2 DO NOTHING;
