/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

update connec set pjoint_id = exit_id, pjoint_type='VNODE' FROM link WHERE link.feature_id=connec_id;


ALTER TABLE inp_typevalue DISABLE TRIGGER gw_trg_typevalue_config_fk;

UPDATE inp_typevalue SET idval='DMAPERIOD>NODE' WHERE typevalue='inp_value_patternmethod' AND id='23';
UPDATE inp_typevalue SET idval='HYDROPERIOD>NODE' WHERE typevalue='inp_value_patternmethod' AND id='24';
UPDATE inp_typevalue SET idval='DMAINTERVAL>NODE' WHERE typevalue='inp_value_patternmethod' AND id='25';
UPDATE inp_typevalue SET idval='HYDROPERIOD>NODE::DMAINTERVAL' WHERE typevalue='inp_value_patternmethod' AND id='26';
UPDATE inp_typevalue SET idval='HYDROPERIOD>PJOINT' WHERE typevalue='inp_value_patternmethod' AND id='27';

ALTER TABLE inp_typevalue ENABLE TRIGGER gw_trg_typevalue_config_fk;


INSERT INTO inp_typevalue VALUES ('inp_value_patternmethod', '27', 'DMAPERIOD>PJOINT')
ON CONFLICT (typevalue, id) DO NOTHING;

UPDATE audit_cat_param_user SET dv_isnullvalue=FALSE WHERE id='inp_options_patternmethod';

UPDATE audit_cat_function SET project_type='ud' WHERE id=2772;


UPDATE audit_cat_function SET istoolbox=false, isparametric=false, alias=null WHERE id=2774;


UPDATE audit_cat_function SET
return_type = '[{"widgetname":"grafClass", "label":"Graf class:", "widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layout_order":1,"comboIds":["PRESSZONE","DQA","DMA","SECTOR"],
"comboNames":["Pressure Zonification (PRESSZONE)", "District Quality Areas (DQA) ", "District Metering Areas (DMA)", "Inlet Sectorization (SECTOR-HIGH / SECTOR-LOW)"], "selectedId":"DMA"}, 
{"widgetname":"exploitation", "label":"Exploitation id''s:","widgettype":"text","datatype":"json","layoutname":"grl_option_parameters","layout_order":2, "placeholder":"[1,2]", "value":""},
{"widgetname":"updateFeature", "label":"Update feature attributes:","widgettype":"check","datatype":"boolean","layoutname":"grl_option_parameters","layout_order":7, "value":"FALSE"},
{"widgetname":"updateMapZone", "label":"Update geometry (if true choose only one parameter belove)","widgettype":"check","datatype":"boolean","layoutname":"grl_option_parameters","layout_order":8, "value":"FALSE"},
{"widgetname":"buffer", "label":"1: Buffer for arc disolve approach:","widgettype":"text","datatype":"float","layoutname":"grl_option_parameters","layout_order":9, "ismandatory":false, "placeholder":"10", "value":""}
{"widgetname":"concaveHullParam", "label":"2: Hull parameter for concave polygon approach:","widgettype":"text","datatype":"float","layoutname":"grl_option_parameters","layout_order":9, "ismandatory":false, "placeholder":"0.9", "value":""}]'
 WHERE id=2768;
 
 
 --2019/12/11
 UPDATE audit_cat_table SET context='Editable view', description='View to edit status of valves on field', sys_role_id='role_om', sys_criticity=0, sys_sequence=null, sys_sequence_field=null WHERE id='v_edit_field_valve'

 --2019/12/13
UPDATE audit_cat_function SET input_params='{"featureType":["node","connec"]}' WHERE function_name = 'gw_fct_update_elevation_from_dem';