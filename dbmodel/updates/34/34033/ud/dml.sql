/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2021/02/27
UPDATE config_form_tableview SET status = TRUE WHERE tablename  ='v_ui_rpt_cat_result' AND columnname = 'id';

UPDATE sys_table SET notify_action = '[{"channel":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"id","featureType":["inp_flwreg_pump", "v_edit_inp_pump", "inp_flwreg_outlet", "v_edit_inp_outlet", "inp_curve","inp_curve_value", "v_edit_inp_divider","v_edit_inp_storage"]}]' WHERE id = 'inp_curve';

-- 2021/03/04
CREATE INDEX plan_psector_x_gully_arc_id ON plan_psector_x_connec USING btree (arc_id);
CREATE INDEX plan_psector_x_gully_gully_id ON plan_psector_x_gully USING btree (gully_id);

UPDATE sys_table set sys_sequence='plan_psector_x_gully_id_seq', sys_sequence_field='id' WHERE id='plan_psector_x_gully';