/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2020/06/11
UPDATE config_api_form_fields SET formname  ='v_edit_dimensions' formtype = 'form_feature' WHERE formname = 'dimensioning';

INSERT INTO config_api_typevalue VALUES ('formtemplate_typevalue', 'dimensioning', 'dimensioning')
ON CONFLICT (typevalue, id) DO NOTHING;

INSERT INTO config_api_layer VALUES ('v_edit_dimensions', false, null, true, null, 'dimensioning', 'Dimensions', 5)
ON CONFLICT (layer_id) DO NOTHING;


update config_api_form_fields set formtype  = 'feature' where formname = 'v_edit_dimensions' AND formtype= 'form';

update config_api_form_fields a SET layout_id = b.layout_id, layout_order = b.layout_order, layout_name = b.layout_name 
FROM config_api_form_fields b WHERE b.formname='v_edit_dimensions' AND b.formtype = 'catalog' AND a.column_id = b.column_id
AND a.formname = 'v_edit_dimensions' AND a.formtype = 'feature';

DELETE FROM config_api_form_fields where formname = 'v_edit_dimensions'  and formtype  = 'catalog';

update config_api_form_fields set layout_id = 1 where formname = 'v_edit_dimensions' AND layout_id is null;
update config_api_form_fields set layout_name = 'symbology_layout', layout_order =  11 where formname = 'v_edit_dimensions' AND column_id = 'direction_arrow';
update config_api_form_fields set layout_name = 'symbology_layout', layout_order =  12 where formname = 'v_edit_dimensions' AND column_id = 'offset_label';
update config_api_form_fields set layout_name = 'symbology_layout', layout_order =  14 where formname = 'v_edit_dimensions' AND column_id = 'x_label';
update config_api_form_fields set layout_name = 'symbology_layout', layout_order =  15 where formname = 'v_edit_dimensions' AND column_id = 'y_label';
update config_api_form_fields set layout_name = 'symbology_layout', WHERE formname = 'v_edit_dimensions' AND column_id = 'rotation_label';


update config_api_form_fields set layout_name = 'other_layout', layout_order =  11 where formname = 'v_edit_dimensions' AND column_id = 'expl_id';
update config_api_form_fields set layout_name = 'other_layout', layout_order =  12 where formname = 'v_edit_dimensions' AND column_id = 'state';
