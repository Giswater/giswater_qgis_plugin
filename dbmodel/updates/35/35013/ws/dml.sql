/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


UPDATE sys_table SET
notify_action = '[{"channel":"desktop","name":"refresh_attribute_table", "enabled":"true", 
"trg_fields":"dscenario_id","featureType":["v_edit_inp_dscenario_demand","v_edit_inp_dscenario_pipe","v_edit_inp_dscenario_pump","v_edit_inp_dscenario_reservoir","v_edit_inp_dscenario_shortpipe",
"v_edit_inp_dscenario_tank", "v_edit_inp_dscenario_valve"]}]' 
WHERE id = 'cat_dscenario';

UPDATE config_form_fields SET widgettype ='text' WHERE formname = 'v_edit_inp_dscenario_demand' AND columnname = 'demand_type'