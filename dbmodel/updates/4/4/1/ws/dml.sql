/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

UPDATE config_form_tableview
	SET objectname='ve_inp_pattern'
	WHERE objectname='v_edit_inp_pattern' AND columnname='observ';
UPDATE config_form_tableview
	SET objectname='ve_inp_pattern'
	WHERE objectname='v_edit_inp_pattern' AND columnname='expl_id';
UPDATE config_form_tableview
	SET objectname='ve_inp_pattern'
	WHERE objectname='v_edit_inp_pattern' AND columnname='tsparameters';
UPDATE config_form_tableview
	SET objectname='ve_inp_pattern'
	WHERE objectname='v_edit_inp_pattern' AND columnname='log';
UPDATE config_form_tableview
	SET objectname='ve_inp_pattern'
	WHERE objectname='v_edit_inp_pattern' AND columnname='tscode';
UPDATE config_form_tableview
	SET objectname='ve_inp_pattern'
	WHERE objectname='v_edit_inp_pattern' AND columnname='pattern_id';

DELETE FROM config_form_tableview
	WHERE objectname='ve_inp_pattern' AND columnname='tscode';
DELETE FROM config_form_tableview
	WHERE objectname='ve_inp_pattern' AND columnname='tsparameters';

INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible,alias)
	VALUES ('nonvisual manager','ws','ve_inp_pattern','pattern_type',3,true,'pattern_type');
UPDATE config_form_tableview
	SET columnindex=2
	WHERE objectname='ve_inp_pattern' AND columnname='expl_id';
UPDATE config_form_tableview
	SET columnindex=4,alias='active',columnname='active'
	WHERE objectname='ve_inp_pattern' AND columnname='log';



INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible,alias)
	VALUES ('nonvisual manager','ws','cat_mat_roughness','id',0,true,'id');
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible,alias)
	VALUES ('nonvisual manager','ws','cat_mat_roughness','matcat_id',1,true,'matcat_id');
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible,alias)
	VALUES ('nonvisual manager','ws','cat_mat_roughness','period_id',2,true,'period_id');
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible,alias)
	VALUES ('nonvisual manager','ws','cat_mat_roughness','init_age',3,true,'init_age');
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible,alias)
	VALUES ('nonvisual manager','ws','cat_mat_roughness','end_age',4,true,'end_age');
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible,alias)
	VALUES ('nonvisual manager','ws','cat_mat_roughness','roughness',5,true,'rougness');
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible,alias)
	VALUES ('nonvisual manager','ws','cat_mat_roughness','descript',6,true,'descript');
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible,alias)
	VALUES ('nonvisual manager','ws','cat_mat_roughness','active',7,true,'active');

UPDATE config_form_tableview
	SET objectname='ve_inp_rules'
	WHERE objectname='v_edit_inp_rules' AND columnname='id';
UPDATE config_form_tableview
	SET objectname='ve_inp_rules'
	WHERE objectname='v_edit_inp_rules' AND columnname='sector_id';
UPDATE config_form_tableview
	SET objectname='ve_inp_rules'
	WHERE objectname='v_edit_inp_rules' AND columnname='text';
UPDATE config_form_tableview
	SET objectname='ve_inp_rules'
	WHERE objectname='v_edit_inp_rules' AND columnname='active';

