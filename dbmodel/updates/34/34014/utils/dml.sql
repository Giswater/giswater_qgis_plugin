/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 2020/06/15
ALTER SEQUENCE version_id_seq RENAME TO sys_version_id_seq;
UPDATE sys_table SET id = 'sys_version', sys_sequence = 'sys_version_id_seq' WHERE id = 'version';


-- 2020/06/02
UPDATE sys_table SET id='cat_feature_arc' WHERE id = 'arc_type';
UPDATE sys_table SET id='cat_feature_node' WHERE id = 'node_type';
UPDATE sys_table SET id='cat_feature_connec' WHERE id = 'connec_type';

UPDATE sys_table SET sys_sequence = 'om_mincut_seq' WHERE id  ='om_mincut';
UPDATE sys_table SET sys_sequence = null, sys_sequence_field =  null WHERE id  ='v_om_mincut';

UPDATE config_form_fields SET dv_querytext = replace (dv_querytext, ' arc_type', ' cat_feature_arc') WHERE dv_querytext like'% arc_type%';
UPDATE config_form_fields SET dv_querytext = replace (dv_querytext, ' node_type', ' cat_feature_node') WHERE dv_querytext like'% node_type%';
UPDATE config_form_fields SET dv_querytext = replace (dv_querytext, ' connec_type', ' cat_feature_connec') WHERE dv_querytext like'% connec_type%';
UPDATE config_form_fields SET dv_querytext = replace (dv_querytext, ' gully_type', ' cat_feature_gully') WHERE dv_querytext like'% gully_type%';

UPDATE sys_param_user SET dv_querytext = replace (dv_querytext, ' arc_type', ' cat_feature_arc') WHERE dv_querytext like'% arc_type%';
UPDATE sys_param_user SET dv_querytext = replace (dv_querytext, ' node_type', ' cat_feature_node') WHERE dv_querytext like'% node_type%';
UPDATE sys_param_user SET dv_querytext = replace (dv_querytext, ' connec_type', ' cat_feature_connec') WHERE dv_querytext like'% connec_type%';
UPDATE sys_param_user SET dv_querytext = replace (dv_querytext, ' gully_type', ' cat_feature_gully') WHERE dv_querytext like'% gully_type%';


INSERT INTO config_typevalue VALUES ('formtemplate_typevalue', 'dimensioning', 'dimensioning')
ON CONFLICT (typevalue, id) DO NOTHING;

UPDATE config_form_fields SET formname  ='v_edit_dimensions', formtype = 'form_feature' WHERE formname = 'dimensioning';

INSERT INTO config_info_layer VALUES ('v_edit_dimensions', false, null, true, null, 'dimensioning', 'Dimensions', 9)
ON CONFLICT (layer_id) DO NOTHING;

update config_form_fields a SET layoutorder = b.layoutorder, layoutname = b.layoutname 
FROM config_form_fields b WHERE a.formname='v_edit_dimensions' AND a.formtype = 'form_generic' AND a.columnname = b.columnname
AND b.formname = 'v_edit_dimensions' AND b.formtype = 'form_feature';

update config_form_fields set layoutname = 'lyt_symbology', layoutorder =  11 where formname = 'v_edit_dimensions' AND columnname = 'direction_arrow';
update config_form_fields set layoutname = 'lyt_symbology', layoutorder =  12 where formname = 'v_edit_dimensions' AND columnname = 'offset_label';
update config_form_fields set layoutname = 'lyt_symbology', layoutorder =  14 where formname = 'v_edit_dimensions' AND columnname = 'x_label';
update config_form_fields set layoutname = 'lyt_symbology', layoutorder =  15 where formname = 'v_edit_dimensions' AND columnname = 'y_label';
update config_form_fields set layoutname = 'lyt_symbology', layoutorder =  16 WHERE formname = 'v_edit_dimensions' AND columnname = 'rotation_label';

update config_form_fields set layoutname = 'lyt_other', layoutorder =  11 where formname = 'v_edit_dimensions' AND columnname = 'expl_id';
update config_form_fields set layoutname = 'lyt_other', layoutorder =  12 where formname = 'v_edit_dimensions' AND columnname = 'state';

DELETE FROM config_form_fields where formname = 'v_edit_dimensions'  and formtype  = 'form_feature';

update config_form_fields set formtype  = 'form_feature' WHERE formname = 'v_edit_dimensions';

INSERT INTO config_typevalue VALUES ('layout_name_typevalue', 'lyt_none', 'lyt_none')
ON CONFLICT (typevalue, id) DO NOTHING;

UPDATE config_typevalue SET id = 'lyt_measurements', idval = 'lyt_measurements' WHERE id  ='lyt_depth';

update config_form_fields set layoutname  = 'lyt_none' WHERE formname = 'v_edit_dimensions' and columnname IN ('id','expl_id');
update config_form_fields set layoutname  = 'lyt_other' WHERE formname = 'v_edit_dimensions' and columnname IN ('observ', 'expl_id', 'state');

update config_form_fields set layoutname  = 'lyt_measurements', layoutorder = 0 WHERE formname = 'v_edit_dimensions' and columnname = 'distance';

DELETE FROM config_typevalue WHERE typevalue = 'layout_name_typevalue' and id = 'lyt_distance';
