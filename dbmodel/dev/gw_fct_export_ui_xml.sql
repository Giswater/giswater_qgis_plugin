
--select SCHEMA_NAME.gw_fct_create_ui_xml('ve_node_x');

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_create_ui_xml(p_tablename text)
  RETURNS json AS
$BODY$

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
	FOR rec IN (SELECT * FROM config_api_form_fields where formname=p_tablename order by layout_order) LOOP
		
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
			EXECUTE 'SELECT xmlelement(name item, xmlattributes( '||rec.layout_order||' as row,0 as column), 
			xmlelement(name widget, xmlattributes('''||v_widget_type||''' as class, '''||rec.column_id||''' as name ),
			xmlelement(name property,xmlattributes(''editable'' as name),xmlelement(name bool,''true'')),
			xmlelement(name property,xmlattributes('''||v_label_name||''' as name), 
			xmlelement(name string,'''||rec.label||'''))));'
			INTO v_sql;
		ELSE
			EXECUTE 'SELECT xmlelement(name item, xmlattributes( '||rec.layout_order||' as row,0 as column), 
			xmlelement(name widget, xmlattributes('''||v_widget_type||''' as class, '''||rec.column_id||''' as name ), 
			xmlelement(name property,xmlattributes('''||v_label_name||''' as name), 
			xmlelement(name string,'''||rec.label||'''))));'
			INTO v_sql;
		END IF;

--Append the element to the corresponding layout
		IF rec.layout_name= 'layout_data_1' THEN
			v_sql_layout_1=concat(v_sql_layout_1,' ',v_sql);

		ELSIF rec.layout_name= 'layout_data_2' THEN
			v_sql_layout_2=concat(v_sql_layout_2,' ',v_sql);

		ELSIF rec.layout_name= 'layout_data_3' THEN
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
			    <width>722</width>
			    <height>619</height>
			   </rect>
			  </property>
			  <property name="windowTitle">
			   <string>Dialog</string>
			  </property>
			  <layout class="QGridLayout" name="gridLayout_2">
			   <item row="1" column="1">
			    <widget class="QTabWidget" name="tab_main">
			     <property name="currentIndex">
			      <number>0</number>
			     </property>
			     <widget class="QWidget" name="tab">
			      <attribute name="title">
			       <string>Tab 1</string>
			      </attribute>
			      <layout class="QGridLayout" name="gridLayout_3">
			       <item row="0" column="0">
			        <widget class="QToolBox" name="toolBox">
			         <property name="currentIndex">
			          <number>0</number>
			         </property>
			         <widget class="QWidget" name="page_3">
			          <property name="geometry">
			           <rect>
			            <x>0</x>
			            <y>0</y>
			            <width>672</width>
			            <height>484</height>
			           </rect>
			          </property>
			          <attribute name="label">
			           <string>Page 1</string>
			          </attribute>
			          <layout class="QGridLayout" name="gridLayout_6">
			           <item row="0" column="0">
			            <layout class="QGridLayout" name="layout_data_1">';

	v_xml=concat(v_xml,v_sql_layout_1);

	v_xml=concat(v_xml, '
			</layout>
			</item>
           <item row="0" column="1">
            <layout class="QGridLayout" name="layout_data_2">');

	v_xml=concat(v_xml,v_sql_layout_2);


	v_xml=concat(v_xml, '
            </layout>
           </item>
          </layout>
         </widget>
         <widget class="QWidget" name="page_4">
          <property name="geometry">
           <rect>
            <x>0</x>
            <y>0</y>
            <width>672</width>
            <height>484</height>
           </rect>
          </property>
          <attribute name="label">
           <string>Page 2</string>
          </attribute>
          <layout class="QGridLayout" name="gridLayout_10">
           <item row="0" column="0">
            <layout class="QGridLayout" name="layout_data_3">');

	v_xml=concat(v_xml,v_sql_layout_3);

	v_xml=concat(v_xml, '
					</layout>
		           </item>
		          </layout>
		         </widget>
		        </widget>
		       </item>
		      </layout>
		     </widget>
		    </widget>
		   </item>
		  </layout>
		 </widget>
		 <resources/>
		 <connections/>
		</ui>');

	INSERT INTO temp_csv2pg(source, csv1, csv2pgcat_id) VALUES (p_tablename,v_xml,19);

return null;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

