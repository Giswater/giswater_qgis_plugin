/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 2020/05/09
UPDATE sys_table SET sys_sequence = null, sys_sequence_field = null WHERE id LIKE '%selector%';

INSERT INTO om_typevalue SELECT 'mincut_cause', row_number() over (order by id), descript FROM _anl_mincut_cat_cause_;
INSERT INTO om_typevalue SELECT 'mincut_class', id, name FROM _anl_mincut_cat_class_;
INSERT INTO om_typevalue SELECT 'mincut_state', id, name FROM _anl_mincut_cat_state_;

SELECT setval('sys_foreingkey_id_seq', (SELECT max(id) FROM sys_foreignkey));

INSERT INTO sys_foreignkey (typevalue_table, typevalue_name, target_table, target_field) VALUES ('om_typevalue','mincut_cause','om_mincut','anl_cause');
INSERT INTO sys_foreignkey (typevalue_table, typevalue_name, target_table, target_field) VALUES ('om_typevalue','mincut_class','om_mincut','mincut_class');
INSERT INTO sys_foreignkey (typevalue_table, typevalue_name, target_table, target_field) VALUES ('om_typevalue','mincut_state','om_mincut','mincut_state');


ALTER TABLE om_mincut DROP CONSTRAINT anl_mincut_result_cat_mincut_state_fkey;
ALTER TABLE om_mincut DROP CONSTRAINT anl_mincut_result_cat_mincut_class_fkey;
ALTER TABLE om_mincut DROP CONSTRAINT anl_mincut_result_cat_cause_anl_cause_fkey;
