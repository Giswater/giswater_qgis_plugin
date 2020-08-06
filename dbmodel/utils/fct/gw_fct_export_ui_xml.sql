/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2692

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_utils_export_ui_xml(text, boolean);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_export_ui_xml(p_formname text, p_parent boolean)
RETURNS json AS
$BODY$

--select SCHEMA_NAME.gw_fct_export_ui_xml('ve_node_x',false);

--fid:246

DECLARE

rec record;

v_sql TEXT;
v_widget_type text;
v_xml text;
v_label_name text;
v_sql_layout_1 text;
v_sql_layout_2 text;
v_sql_layout_3 text;

BEGIN

	SET search_path=SCHEMA_NAME;

	--iterate over fields defined for the selected form
	FOR rec IN (SELECT * FROM config_form_fields where formname=p_formname AND formtype='form_feature' AND layoutorder IS NOT NULL order by layoutorder) LOOP

	IF p_parent IS TRUE THEN
		IF (SELECT param_name FROM sys_addfields
			JOIN cat_feature ON cat_feature.id=sys_addfields.cat_feature_id
			WHERE child_layer=p_formname AND sys_addfields.param_name=rec.columnname) IS NOT NULL THEN

			CONTINUE;
						
		END IF;
	END IF;


	--changing defined widget types into Qt widgets types, set the label_name location for xml
	IF rec.widgettype='combo' THEN
		v_widget_type='QComboBox';
		v_label_name='currentText';
	ELSIF rec.widgettype='check' THEN
		v_widget_type='QCheckBox';
		v_label_name='text';
	ELSIF rec.widgettype='datepickertime' THEN
		v_widget_type='QDateTimeEdit';		
	ELSIF rec.widgettype='doubleSpinbox' THEN
		v_widget_type='QDoubleSpinBox';
		v_label_name='specialValueText';
	ELSIF rec.widgettype='textarea' THEN
		v_widget_type='QTextEdit';
		v_label_name='placeholderText';
	ELSE 
		v_widget_type='QLineEdit';
		v_label_name='text';
	END IF;

	--create xml elements for each field in the form
	IF rec.widgettype='combo' THEN
		EXECUTE 'SELECT xmlelement(name item, xmlattributes( '||rec.layoutorder||' as row,0 as column),
		xmlelement(name widget, xmlattributes('''||v_widget_type||''' as class, '''||rec.columnname||''' as name ),
		xmlelement(name property,xmlattributes(''editable'' as name),xmlelement(name bool,''true'')),
		xmlelement(name property,xmlattributes('''||v_label_name||''' as name), 
		xmlelement(name string,'''||rec.label||'''))));'
		INTO v_sql;
	ELSE
		EXECUTE 'SELECT xmlelement(name item, xmlattributes( '||rec.layoutorder||' as row,0 as column),
		xmlelement(name widget, xmlattributes('''||v_widget_type||''' as class, '''||rec.columnname||''' as name ),
		xmlelement(name property,xmlattributes('''||v_label_name||''' as name), 
		xmlelement(name string,'''||rec.label||'''))));'
		INTO v_sql;
	END IF;

	--Append the element to the corresponding layout
	IF rec.layoutname= 'lyt_data_1' THEN
		v_sql_layout_1=concat(v_sql_layout_1,' ',v_sql);

	ELSIF rec.layoutname= 'lyt_data_2' THEN
		v_sql_layout_2=concat(v_sql_layout_2,' ',v_sql);

	ELSIF rec.layoutname= 'lyt_data_3' THEN
		v_sql_layout_3=concat(v_sql_layout_3,' ',v_sql);
	END IF;

	END LOOP;

	--Concatenate the base of ui xml with the layout elements
	v_xml='<?xml version="1.0" encoding="UTF-8"?>
	<ui version="4.0">
	 <class>Dialog</class>
	 <widget class="QDialog" name="Dialog">
	  <property name="geometry">
	   <rect>
		<x>0</x>
		<y>0</y>
		<width>646</width>
		<height>538</height>
	   </rect>
	  </property>
	  <property name="windowTitle">
	   <string>Dialog</string>
	  </property>
	  <layout class="QGridLayout" name="gridLayout_1">
		 <item row="0" column="0">
		<layout class="QGridLayout" name="lyt_data_1">';

	v_xml=concat(v_xml,v_sql_layout_1);

	v_xml=concat(v_xml, '
		</layout>
		</item>
	<item row="0" column="1">
	<layout class="QGridLayout" name="lyt_data_2">');

	v_xml=concat(v_xml,v_sql_layout_2);


	v_xml=concat(v_xml, '
	</layout>
	</item>
	<item row="1" column="0" colspan="2">
	<layout class="QGridLayout" name="lyt_data_3">');

	v_xml=concat(v_xml,v_sql_layout_3);

	v_xml=concat(v_xml, '
				</layout>
		   </item>
		  </layout>
		 </widget>
		 <resources/>
		 <connections/>
		</ui>
		');

	INSERT INTO temp_csv(source, csv1, fid) VALUES (p_formname,v_xml,246);

	return null;
END;
$BODY$
LANGUAGE plpgsql VOLATILE
COST 100;

