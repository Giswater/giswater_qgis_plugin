/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 2020/05/09
SELECT gw_fct_admin_schema_manage_triggers('notify',null);

UPDATE sys_table SET sys_sequence = null, sys_sequence_field = null WHERE id LIKE '%selector%';

INSERT INTO om_typevalue SELECT 'mincut_cause', row_number() over (order by id), descript FROM ws8.anl_mincut_cat_cause;
INSERT INTO om_typevalue SELECT 'mincut_class', id, name FROM ws8.anl_mincut_cat_class;
INSERT INTO om_typevalue SELECT 'mincut_state', id, name FROM ws8.anl_mincut_cat_state;

SELECT setval('ws8.typevalue_fk_id_seq', max(id), true) FROM ws8.config_typevalue_fk;

INSERT INTO config_typevalue_fk (typevalue_table, typevalue_name, target_table, target_field) VALUES ('om_typevalue','mincut_cause','om_mincut','anl_cause');
INSERT INTO config_typevalue_fk (typevalue_table, typevalue_name, target_table, target_field) VALUES ('om_typevalue','mincut_class','om_mincut','mincut_class');
INSERT INTO config_typevalue_fk (typevalue_table, typevalue_name, target_table, target_field) VALUES ('om_typevalue','mincut_state','om_mincut','mincut_state');