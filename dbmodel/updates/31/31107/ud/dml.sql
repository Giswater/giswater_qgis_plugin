/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2019/02/05

INSERT INTO audit_cat_param_user VALUES ('dim_tooltip', NULL, 'If true, tooltip appears when you''re selecting depth from another node with dimensioning tool', 'role_edit', NULL, NULL, NULL, NULL, 'boolean');
INSERT INTO audit_cat_param_user VALUES ('cad_tools_base_layer_vdefault', NULL, 'Selected layer will be the only one which allow snapping with CAD tools', 'role_edit', NULL, NULL, NULL, NULL, 'text');
