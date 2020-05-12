/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

UPDATE audit_cat_param_user SET dv_querytext = 'SELECT id, idval FROM inp_typevalue WHERE typevalue=''inp_value_opti_hyd'''
WHERE id='inp_options_hydraulics';

ALTER TABLE inp_typevalue DISABLE TRIGGER gw_trg_typevalue_config_fk;
INSERT INTO inp_typevalue VALUES ('inp_value_opti_hyd', 'NONE', '') ON CONFLICT (typevalue, id) DO NOTHING;


UPDATE audit_cat_param_user SET vdefault = 2 WHERE id='inp_options_valve_mode';

UPDATE audit_cat_table SET isdeprecated=true WHERE id='inp_typevalue_source';

UPDATE audit_cat_table SET sys_role_id='role_edit' WHERE id='inp_inlet';
