/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 3.1.112
INSERT INTO audit_cat_function VALUES (2682, 'gw_fct_api_getprint', 'utils', 'api function', NULL, NULL, NULL, 'Get print form', 'role_basic', false, false, NULL, false) 
ON CONFLICT (id) DO NOTHING;
INSERT INTO audit_cat_function VALUES (2684, 'gw_fct_api_setprint', 'utils', 'api function', NULL, NULL, NULL, 'Set print form', 'role_basic', false, false, NULL, false) 
ON CONFLICT (id) DO NOTHING;
INSERT INTO audit_cat_function VALUES (2686, 'gw_trg_doc', 'utils', 'function trigger', NULL, NULL, NULL, 'Automatic replace of path for docs', 'role_edit', false, false, NULL, false) 
ON CONFLICT (id) DO NOTHING;

SELECT setval('SCHEMA_NAME.config_param_system_id_seq', (SELECT max(id) FROM config_param_system), true);
INSERT INTO config_param_system (parameter, value, data_type, context, descript) 
VALUES ('edit_replace_doc_folderpath','[{"source":"c://dades/","target":"http:www.giswater.org"},{"source":"c://test/test/test","target":"http:www.bgeo.org"}]','json', 'edit', 'Variable to identify the text to replace and the text to be replaced on folder path. More than one must be possible. Managed on triggers of doc tables when insert new row')
ON CONFLICT (parameter) DO nothing;

