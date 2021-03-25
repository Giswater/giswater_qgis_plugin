/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2020/09/30
UPDATE sys_table SET sys_sequence = 'cat_mat_roughness_id_seq' where id = 'cat_mat_roughness';

--2020/12/14
UPDATE cat_mat_roughness SET active = TRUE WHERE active IS NULL;

--2020/12/15
UPDATE dqa SET active = TRUE WHERE active IS NULL;
UPDATE macrodqa SET active = TRUE WHERE active IS NULL;
UPDATE presszone SET active = TRUE WHERE active IS NULL;


UPDATE config_form_fields SET dv_querytext = concat(dv_querytext, ' AND active IS TRUE ')
WHERE columnname IN ('dqa_id', 'presszone_id','macrodqa_id') AND
(formname ilike 've_arc%' OR formname ilike 've_node%' OR formname ilike 've_connec%' OR formname ilike 've_gully%' 
OR formname in ('v_edit_element','v_edit_node','v_edit_arc','v_edit_connec','v_edit_gully')) and dv_querytext is not null;

UPDATE cat_feature_node SET epa_table = 'inp_reservoir' WHERE epa_default  ='RESERVOIR';
UPDATE cat_feature_node SET epa_table = 'inp_tank' WHERE epa_default  ='TANK';
UPDATE cat_feature_node SET epa_table = 'inp_inlet' WHERE epa_default  ='INLET';
UPDATE cat_feature_node SET epa_table = 'inp_valve' WHERE epa_default  ='VALVE';
UPDATE cat_feature_node SET epa_table = 'inp_junction' WHERE epa_default  ='JUNCTION';
UPDATE cat_feature_node SET epa_table = 'inp_pump' WHERE epa_default  ='PUMP';
UPDATE cat_feature_node SET epa_table = 'inp_shortpipe' WHERE epa_default  ='SHORTPIPE';

UPDATE cat_feature_arc SET epa_table = 'inp_pipe' WHERE epa_default  ='PIPE';
UPDATE cat_feature_arc SET epa_table = 'inp_virtualvalve' WHERE epa_default  ='VIRTUALVALVE';
UPDATE cat_feature_arc SET epa_table = 'inp_pump_importinp' WHERE epa_default  ='PUMP-IMPORTINP';
UPDATE cat_feature_arc SET epa_table = 'inp_valve_importinp' WHERE epa_default  ='VALVE-IMPORTINP';

UPDATE inp_arc_type SET epa_table = f.epa_table FROM cat_feature_arc f WHERE inp_arc_type.id=f.epa_default;
UPDATE inp_arc_type SET epa_table = 'inp_pump_importinp' where id = 'PUMP-IMPORTINP';
UPDATE inp_arc_type SET epa_table = 'inp_valve_importinp' where id = 'VALVE-IMPORTINP';
UPDATE inp_arc_type SET epa_table = 'inp_virtualvalve' where id = 'VIRTUALVALVE';

UPDATE inp_node_type SET epa_table = f.epa_table FROM cat_feature_node f WHERE inp_node_type.id=f.epa_default;
UPDATE inp_node_type SET epa_table = 'inp_inlet' where id = 'INLET';

INSERT INTO sys_feature_epa_type SELECT id, 'NODE', epa_table FROM inp_node_type;
INSERT INTO sys_feature_epa_type SELECT id, 'ARC', epa_table FROM inp_arc_type;
