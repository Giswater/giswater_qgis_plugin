/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2020/12/15
INSERT INTO sys_table VALUES ('v_plan_psector_gully', 'View to show gullys related to psectors. Useful to show gullys which will be obsolete in psectors', 'role_basic', 0, 'role_master', 2, 'Cannot view related gullys to psectors') ON CONFLICT (id) DO NOTHING;

-- 2020/12/16
UPDATE config_form_fields SET formname='inp_timeseries_value' WHERE formname='inp_timeseries';
UPDATE config_form_fields SET formname='inp_transects_value' WHERE formname='inp_transects';

UPDATE sys_table SET id='inp_timeseries_value' WHERE id='inp_timeseries';
UPDATE sys_table SET id='inp_timeseries' WHERE id='inp_timser_id';
UPDATE sys_table SET id='inp_transects_value' WHERE id='inp_transects';
UPDATE sys_table SET id='inp_transects' WHERE id='inp_transects_id';

UPDATE config_form_fields SET dv_querytext=replace(dv_querytext, 'inp_transects_id', 'inp_transects') WHERE dv_querytext LIKE '%inp_transects%';
UPDATE config_form_fields SET dv_querytext=replace(dv_querytext, 'inp_timser_id', 'inp_timeseries') WHERE dv_querytext LIKE '%inp_timser%';

ALTER TABLE sys_typevalue DISABLE TRIGGER gw_trg_typevalue_config_fk;
DELETE FROM sys_foreignkey WHERE target_table = 'inp_timser_id';
ALTER TABLE sys_typevalue ENABLE TRIGGER gw_trg_typevalue_config_fk;
