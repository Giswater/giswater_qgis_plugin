/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2022/01/03


-- JUNCTION REFACTOR
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_junction", "column":"emitter_coef", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_junction", "column":"initial_quality", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_junction", "column":"source_type", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_junction", "column":"source_quality", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_junction", "column":"source_pattern", "dataType":"float", "isUtils":"False"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_junction", "column":"emitter_coef", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_junction", "column":"initial_quality", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_junction", "column":"source_type", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_junction", "column":"source_quality", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_junction", "column":"source_pattern", "dataType":"float", "isUtils":"False"}}$$);

UPDATE inp_junction j SET emitter_coef = coef FROM inp_emitter s WHERE s.node_id = j.node_id;
UPDATE inp_junction j SET initial_quality = initqual FROM inp_quality s WHERE s.node_id = j.node_id;
UPDATE inp_junction j SET source_type = sourc_type FROM inp_source s WHERE s.node_id = j.node_id;
UPDATE inp_junction j SET source_quality = quality FROM inp_source s WHERE s.node_id = j.node_id;
UPDATE inp_junction j SET source_pattern = pattern_id FROM inp_source s WHERE s.node_id = j.node_id;

ALTER TABLE inp_emitter RENAME TO _inp_emitter_;
ALTER TABLE inp_quality RENAME TO _inp_emitter_;
ALTER TABLE inp_source RENAME TO _inp_emitter_;

DELETE FROM sys_table WHERE id  IN ('inp_quality', 'inp_source','inp_emitter');

UPDATE config_form_fields SET formname = 'v_edit_inp_junction' WHERE formname IN ('inp_quality','inp_source','inp_emitter');
UPDATE config_form_fields SET formname = 've_inp_junction' WHERE formname = 've_inp_junction';

