/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

UPDATE config_form_tableview
	SET objectname='ve_inp_controls'
	WHERE objectname='v_edit_inp_controls' AND columnname='sector_id';
UPDATE config_form_tableview
	SET objectname='ve_inp_controls'
	WHERE objectname='v_edit_inp_controls' AND columnname='active';
UPDATE config_form_tableview
	SET objectname='ve_inp_controls'
	WHERE objectname='v_edit_inp_controls' AND columnname='id';
UPDATE config_form_tableview
	SET objectname='ve_inp_controls'
	WHERE objectname='v_edit_inp_controls' AND columnname='text';

UPDATE config_form_tableview
	SET objectname='ve_inp_curve'
	WHERE objectname='v_edit_inp_curve' AND columnname='log';
UPDATE config_form_tableview
	SET objectname='ve_inp_curve'
	WHERE objectname='v_edit_inp_curve' AND columnname='id';
UPDATE config_form_tableview
	SET objectname='ve_inp_curve'
	WHERE objectname='v_edit_inp_curve' AND columnname='curve_type';
UPDATE config_form_tableview
	SET objectname='ve_inp_curve'
	WHERE objectname='v_edit_inp_curve' AND columnname='expl_id';
UPDATE config_form_tableview
	SET objectname='ve_inp_curve'
	WHERE objectname='v_edit_inp_curve' AND columnname='descript';
UPDATE config_form_tableview
	SET alias='active',columnname='active'
	WHERE objectname='ve_inp_curve' AND columnname='log';