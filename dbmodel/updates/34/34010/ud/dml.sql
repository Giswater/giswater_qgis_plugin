/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


INSERT INTO sys_foreignkey(typevalue_table, typevalue_name, target_table, target_field)
VALUES ('edit_typevalue','value_verified', 'gully', 'verified') ON CONFLICT (typevalue_table, typevalue_name, target_table, target_field, parameter_id) DO NOTHING;	

UPDATE sys_table SET id ='subcatchment' WHERE id ='inp_subcatchment';

UPDATE sys_table SET id ='v_edit_subcatchment',sys_sequence = 'inp_subcatchment_subc_id_seq' WHERE id ='v_edit_inp_subcatchment';

UPDATE sys_function SET function_name ='gw_trg_edit_inp_subcatchment' WHERE function_name ='gw_trg_edit_subcatchment';

UPDATE config_form_fields SET formname = 'v_edit_inp_subcatchment' WHERE formname = 'v_edit_subcatchment';
UPDATE sys_table SET notify_action = (replace(notify_action::text, 'v_edit_subcatchment', 'v_edit_inp_subcatchment'))::json;
