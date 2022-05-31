/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2022/05/23
UPDATE config_param_system set layoutorder = layoutorder + 10 WHERE parameter in ('om_profile_guitarlegend','om_profile_guitartext','om_profile_vdefault');

UPDATE sys_table set alias = 'Pattern values' WHERE id = 'v_edit_inp_pattern_value';
UPDATE sys_table set alias = 'Curve values' WHERE id = 'v_edit_inp_curve_value';

--2022/05/31
UPDATE inp_typevalue
	SET addparam='{"header": ["Flow", "Efficiency"]}'::json
	WHERE typevalue='inp_value_curve' AND id='EFFICIENCY';
UPDATE inp_typevalue
	SET addparam='{"header": ["Flow", "Headloss"]}'::json
	WHERE typevalue='inp_value_curve' AND id='HEADLOSS';
UPDATE inp_typevalue
	SET addparam='{"header": ["Flow", "Head"]}'::json
	WHERE typevalue='inp_value_curve' AND id='PUMP';
UPDATE inp_typevalue
	SET addparam='{"header": ["Height", "Volume"]}'::json
	WHERE typevalue='inp_value_curve' AND id='VOLUME';

INSERT INTO config_form_tableview (location_type,project_type,tablename,columnname,columnindex,visible)
	VALUES ('nonvisual manager','ws','v_edit_inp_pattern','pattern_id',0,true);
INSERT INTO config_form_tableview (location_type,project_type,tablename,columnname,columnindex,visible,style)
	VALUES ('nonvisual manager','ws','v_edit_inp_pattern','observ',1,true,'{"stretch": true}'::json);
INSERT INTO config_form_tableview (location_type,project_type,tablename,columnname,columnindex,visible)
	VALUES ('nonvisual manager','ws','v_edit_inp_pattern','tscode',2,false);
INSERT INTO config_form_tableview (location_type,project_type,tablename,columnname,columnindex,visible)
	VALUES ('nonvisual manager','ws','v_edit_inp_pattern','tsparameters',3,false);
INSERT INTO config_form_tableview (location_type,project_type,tablename,columnname,columnindex,visible)
	VALUES ('nonvisual manager','ws','v_edit_inp_pattern','expl_id',4,true);
INSERT INTO config_form_tableview (location_type,project_type,tablename,columnname,columnindex,visible)
	VALUES ('nonvisual manager','ws','v_edit_inp_pattern','log',5,false);

INSERT INTO config_form_tableview (location_type,project_type,tablename,columnname,columnindex,visible)
	VALUES ('nonvisual manager','ws','v_edit_inp_rules','id',0,true);
INSERT INTO config_form_tableview (location_type,project_type,tablename,columnname,columnindex,visible)
	VALUES ('nonvisual manager','ws','v_edit_inp_rules','sector_id',1,true);
INSERT INTO config_form_tableview (location_type,project_type,tablename,columnname,columnindex,visible,style)
	VALUES ('nonvisual manager','ws','v_edit_inp_rules','text',2,true,'{"stretch": true}'::json);
INSERT INTO config_form_tableview (location_type,project_type,tablename,columnname,columnindex,visible)
	VALUES ('nonvisual manager','ws','v_edit_inp_rules','active',3,true);
