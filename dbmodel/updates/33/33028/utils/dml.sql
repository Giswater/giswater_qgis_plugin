/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2020/02/12

UPDATE audit_cat_param_user SET isenabled=FALSE WHERE id='municipality_vdefault';
UPDATE audit_cat_param_user SET isenabled=FALSE WHERE id='sector_vdefault';
UPDATE audit_cat_param_user SET isenabled=FALSE WHERE id='exploitation_vdefault';
UPDATE audit_cat_param_user SET isenabled=FALSE WHERE id='dma_vdefault';



INSERT INTO sys_fprocess_cat(id, fprocess_name, context, project_type)
VALUES (112, 'Arc divide', 'edit', 'utils') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_fprocess_cat(id, fprocess_name, context, project_type)
VALUES (113, 'Node interpolate', 'edit', 'ud') ON CONFLICT (id) DO NOTHING;