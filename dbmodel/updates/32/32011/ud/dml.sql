/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;


--03/04/2019
UPDATE audit_cat_param_user SET isenabled=true where id='visitclass_vdefault_gully';

INSERT INTO audit_cat_param_user VALUES ('visitclass_vdefault_gully', 'config', 'Default value of visit class for gully', 'role_om', NULL, NULL, 'Visit class of gully:', 'SELECT id, idval FROM om_visit_class WHERE feature_type=''GULLY'' AND  active IS TRUE AND sys_role_id IN (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, ''member''))', NULL, true, 2, 5, 'ud', false, NULL, NULL, NULL, false, 'integer', 'combo', false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false);
