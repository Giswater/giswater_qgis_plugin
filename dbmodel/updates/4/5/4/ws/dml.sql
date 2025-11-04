/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

UPDATE config_form_fields
SET dv_querytext='SELECT fluid_type as id, fluid_type as idval FROM man_type_fluid WHERE ((featurecat_id is null AND ''LINK''=ANY(feature_type)) ) AND active IS TRUE'
WHERE formname='ve_link' AND formtype='form_feature' AND columnname='fluid_type' AND tabname='tab_data';

DROP TRIGGER IF EXISTS gw_trg_edit_plan_psector_connec ON ve_plan_psector_x_connec;
DROP VIEW IF EXISTS ve_plan_psector_x_connec;
DROP FUNCTION IF EXISTS gw_trg_edit_plan_psector_x_connect();
DELETE FROM sys_function WHERE id = 3174;
