/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

DROP TRIGGER IF EXISTS gw_trg_edit_plan_psector_connec ON ve_plan_psector_x_connec;
DROP TRIGGER IF EXISTS gw_trg_edit_plan_psector_gully ON ve_plan_psector_x_gully;
DROP VIEW IF EXISTS ve_plan_psector_x_connec;
DROP VIEW IF EXISTS ve_plan_psector_x_gully;
DROP FUNCTION IF EXISTS gw_trg_edit_plan_psector_x_connect();
DELETE FROM sys_function WHERE id = 3174;
