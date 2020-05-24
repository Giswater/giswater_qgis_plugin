/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


INSERT INTO config_typevalue_fk(typevalue_table, typevalue_name, target_table, target_field)
VALUES ('edit_typevalue','value_verified', 'gully', 'verified') ON CONFLICT (typevalue_table, typevalue_name, target_table, target_field) DO NOTHING;	

UPDATE sys_table SET id ='subcatchment' WHERE id ='inp_subcatchment';

UPDATE sys_table SET id ='v_edit_subcatchment' WHERE id ='v_edit_inp_subcatchment';

UPDATE sys_function SET function_name ='gw_trg_edit_inp_subcatchment' sys_sequence = 'inp_subcatchment_subc_id_seq' WHERE id ='gw_trg_edit_subcatchment';
