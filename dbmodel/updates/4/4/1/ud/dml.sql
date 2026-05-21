/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


UPDATE config_form_tableview
	SET objectname='ve_inp_pattern'
	WHERE objectname='v_edit_inp_pattern' AND columnname='pattern_id';
UPDATE config_form_tableview
	SET objectname='ve_inp_pattern'
	WHERE objectname='v_edit_inp_pattern' AND columnname='pattern_type';
UPDATE config_form_tableview
	SET objectname='ve_inp_pattern'
	WHERE objectname='v_edit_inp_pattern' AND columnname='observ';
UPDATE config_form_tableview
	SET objectname='ve_inp_pattern'
	WHERE objectname='v_edit_inp_pattern' AND columnname='tsparameters';
UPDATE config_form_tableview
	SET objectname='ve_inp_pattern'
	WHERE objectname='v_edit_inp_pattern' AND columnname='expl_id';
UPDATE config_form_tableview
	SET objectname='ve_inp_pattern'
	WHERE objectname='v_edit_inp_pattern' AND columnname='log';


UPDATE config_form_tableview
	SET objectname='ve_inp_timeseries'
	WHERE objectname='v_edit_inp_timeseries' AND columnname='log';
UPDATE config_form_tableview
	SET objectname='ve_inp_timeseries'
	WHERE objectname='v_edit_inp_timeseries' AND columnname='timeser_type';
UPDATE config_form_tableview
	SET objectname='ve_inp_timeseries'
	WHERE objectname='v_edit_inp_timeseries' AND columnname='id';
UPDATE config_form_tableview
	SET objectname='ve_inp_timeseries'
	WHERE objectname='v_edit_inp_timeseries' AND columnname='times_type';
UPDATE config_form_tableview
	SET objectname='ve_inp_timeseries'
	WHERE objectname='v_edit_inp_timeseries' AND columnname='idval';
UPDATE config_form_tableview
	SET objectname='ve_inp_timeseries'
	WHERE objectname='v_edit_inp_timeseries' AND columnname='fname';
UPDATE config_form_tableview
	SET objectname='ve_inp_timeseries'
	WHERE objectname='v_edit_inp_timeseries' AND columnname='expl_id';
UPDATE config_form_tableview
	SET objectname='ve_inp_timeseries'
	WHERE objectname='v_edit_inp_timeseries' AND columnname='descript';

DELETE FROM config_form_tableview
	WHERE objectname='ve_inp_timeseries' AND columnname='idval';
DELETE FROM config_form_tableview
	WHERE objectname='ve_inp_timeseries' AND columnname='log';
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible,alias)
	VALUES ('nonvisual manager','ud','ve_inp_timeseries','active',6,true,'active') ON CONFLICT DO NOTHING;
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible,alias)
	VALUES ('nonvisual manager','ud','ve_inp_timeseries','addparam',7,true,'addparam') ON CONFLICT DO NOTHING;
UPDATE config_form_tableview
	SET columnindex=3
	WHERE objectname='ve_inp_timeseries' AND columnname='descript';
UPDATE config_form_tableview
	SET columnindex=4
	WHERE objectname='ve_inp_timeseries' AND columnname='fname';
UPDATE config_form_tableview
	SET columnindex=5
	WHERE objectname='ve_inp_timeseries' AND columnname='expl_id';

INSERT INTO sys_message (id,error_message,hint_message,log_level,show_user,project_type,"source",message_type)
VALUES (4362,'Fusion is not allowed due to inconsistent or opposite arc directions','Please review your arcs and ensure their directions are continuous and logical',2,true,'ud','core','UI');
