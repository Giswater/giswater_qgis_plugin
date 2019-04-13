/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 3.1.112
INSERT INTO audit_cat_function VALUES (2619, 'gw_fct_api_getprint', 'utils', 'api function', NULL, NULL, NULL, 'Get print form', 'role_basic', false, false, NULL, false) ON CONFLICT (id) DO NOTHING;
INSERT INTO audit_cat_function VALUES (2621, 'gw_fct_api_setprint', 'utils', 'api function', NULL, NULL, NULL, 'Set print form', 'role_basic', false, false, NULL, false) ON CONFLICT (id) DO NOTHING;
