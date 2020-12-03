/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2694

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_utils_import_ui_xml(text, boolean);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_import_ui_xml(p_formname text, p_parent boolean)
  RETURNS json AS
$BODY$

--select gw_fct_import_ui_xml('ve_node_x',TRUE);

-- fid:120

DECLARE

rec record;
rec_parent record;

v_widget_type text;
v_fields_array json[];
v_json_aux json;  
v_layout text;  
v_item_row integer;  
v_item_column integer;  
v_field_name text;   
v_label_name text;  
layout_xml xml;
v_parent_layer text;

BEGIN

	SET search_path=SCHEMA_NAME, public;

	--Loop in order to extract parts of xml related to layout_data_1,2,3
	FOR rec IN 1..3 LOOP
		EXECUTE 'select unnest(xpath(''//layout[@name="lyt_datadata_'||rec||'"]'', csv1::xml)) from temp_csv where fid = 120 AND cur_user=current_user
		AND source='''||p_formname||''';'
		INTO  layout_xml;
	
		--select into json the values of attributes related to widget and label location
		select array_agg(row_to_json(a)) from(
		select  unnest(xpath('//layout/@name', layout_xml))  as layout,
		unnest(xpath('..//item/@row', layout_xml)) as item_row,
		unnest(xpath('..//item/@column', layout_xml)) as item_column,
		unnest(xpath('..//item/widget/@class', layout_xml))  as widget_type,
		unnest(xpath('..//item/widget/@name', layout_xml))  as field_name,
		unnest(xpath('..//item/widget/property/string/text()', layout_xml))  as label_name)a
		INTO v_fields_array;
		
		IF v_fields_array IS NOT NULL THEN
		
			--select and save into variables values of attributes related to widget and label location
			FOREACH v_json_aux IN ARRAY v_fields_array LOOP
				SELECT quote_literal((v_json_aux)->>'layout')::TEXT INTO v_layout;
				SELECT ((v_json_aux)->>'item_row') INTO v_item_row;
				SELECT ((v_json_aux)->>'item_column') INTO v_item_column;
				SELECT quote_literal((v_json_aux)->>'widget_type')::TEXT INTO v_widget_type;
				SELECT quote_literal((v_json_aux)->>'field_name')::TEXT INTO v_field_name;
				SELECT quote_literal((v_json_aux)->>'label_name')::TEXT INTO v_label_name;
		
				--update config_form_fields with values from new ui
				IF p_parent IS TRUE THEN

					EXECUTE 'SELECT parent_layer  FROM cat_feature WHERE child_layer='''||p_formname||''';'
					INTO v_parent_layer;

					FOR rec_parent IN EXECUTE 'SELECT child_layer FROM SCHEMA_NAME.cat_feature WHERE parent_layer='''||v_parent_layer||''' ORDER BY id' LOOP

						EXECUTE 'UPDATE config_form_fields SET layoutname='||v_layout||', layoutorder='||v_item_row||', label='||v_label_name||'
						WHERE formname='''||rec_parent.child_layer||''' and columnname='||v_field_name||';';
					end loop;
				
				ELSE 	
					EXECUTE 'UPDATE config_form_fields SET layoutname='||v_layout||', layoutorder='||v_item_row||', label='||v_label_name||'
					WHERE formname='''||p_formname||''' and columnname='||v_field_name||';';
				END IF;
				-- widgettype='||v_widget_type||'

			END LOOP;
		END IF;
	END LOOP;

	return null;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
