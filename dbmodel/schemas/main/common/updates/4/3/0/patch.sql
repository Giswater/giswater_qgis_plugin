/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"plan_psector_x_connec", "column":"addparam", "dataType":"json", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"value_state", "column":"active", "dataType":"boolean", "isUtils":"False"}}$$);

INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname)
VALUES('help_domain', 'https://docs.giswater.org/', 'Base domain for documentation web.', 'Custom variable for documentation', NULL, NULL, false, NULL, 'utils', NULL, NULL, 'boolean', 'check', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
ON CONFLICT DO NOTHING;

UPDATE config_form_fields SET widgetfunction = replace(widgetfunction::text, 'v_edit_', 've_')::json WHERE widgetfunction::TEXT ILIKE '%v_edit_%';

UPDATE config_form_tableview SET visible=true WHERE objectname='plan_psector_x_arc' AND columnname='descript';
UPDATE config_form_tableview SET visible=true WHERE objectname='plan_psector_x_node' AND columnname='descript';

INSERT INTO config_form_tableview VALUES ('plan toolbar', 'utils', 'plan_psector_x_connec', 'id', 0, false, NULL, NULL, NULL);
INSERT INTO config_form_tableview VALUES ('plan toolbar', 'utils', 'plan_psector_x_connec', 'connec_id', 1, true, NULL, NULL, NULL);
INSERT INTO config_form_tableview VALUES ('plan toolbar', 'utils', 'plan_psector_x_connec', 'arc_id', 2, true, NULL, NULL, NULL);
INSERT INTO config_form_tableview VALUES ('plan toolbar', 'utils', 'plan_psector_x_connec', 'psector_id', 3, false, NULL, NULL, NULL);
INSERT INTO config_form_tableview VALUES ('plan toolbar', 'utils', 'plan_psector_x_connec', 'state', 4, true, NULL, NULL, NULL);
INSERT INTO config_form_tableview VALUES ('plan toolbar', 'utils', 'plan_psector_x_connec', 'doable', 5, true, NULL, NULL, NULL);
INSERT INTO config_form_tableview VALUES ('plan toolbar', 'utils', 'plan_psector_x_connec', 'descript', 6, true, NULL, NULL, NULL);
INSERT INTO config_form_tableview VALUES ('plan toolbar', 'utils', 'plan_psector_x_connec', '_link_geom_', 7, false, NULL, NULL, NULL);
INSERT INTO config_form_tableview VALUES ('plan toolbar', 'utils', 'plan_psector_x_connec', '_userdefined_geom_', 8, false, NULL, NULL, NULL);
INSERT INTO config_form_tableview VALUES ('plan toolbar', 'utils', 'plan_psector_x_connec', 'link_id', 9, true, NULL, NULL, NULL);
INSERT INTO config_form_tableview VALUES ('plan toolbar', 'utils', 'plan_psector_x_connec', 'insert_tstamp', 10, false, NULL, NULL, NULL);
INSERT INTO config_form_tableview VALUES ('plan toolbar', 'utils', 'plan_psector_x_connec', 'insert_user', 11, false, NULL, NULL, NULL);

UPDATE config_typevalue SET addparam='{"orderBy":999}' WHERE typevalue='sys_table_context' AND id='{"levels": ["HIDDEN"]}';

INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam)
VALUES('layout_name_typevalue', 'lyt_connect_link_4', 'lyt_connect_link_4', 'lytConnectLink4', '{"lytOrientation": "horizontal"}'::json);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('generic', 'link_to_connec', 'tab_none', 'arc_id', 'lyt_connect_link_4', 1, 'text', 'text', 'Connect to arc:', 'Arc Id', NULL, false, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 0);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('generic', 'link_to_connec', 'tab_none', 'btn_set_to_arc', 'lyt_connect_link_4', 2, NULL, 'button', NULL, 'Set to arc', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{
  "icon": "155"
}'::json, NULL, NULL, NULL, false, 0);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'link_to_connec', 'tab_none', 'btn_expr_arc', 'lyt_connect_link_4', 3, NULL, 'button', NULL, 'Select by Expression - Set closest point', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{
  "icon": "178"
}'::json, NULL, '{
  "functionName": "filter_expression_arc",
  "module": "connect_link_btn"
}'::json, NULL, false, 0);


INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source", function_alias)
VALUES(3512, 'gw_fct_plan_recover_archived', 'utils', 'function', 'json', 'json', NULL, 'role_plan', NULL, 'core', NULL);

UPDATE config_form_fields SET iseditable = false where formname ilike 've_node_%' and columnname = 'state';
UPDATE config_form_fields SET iseditable = false where formname ilike 've_arc_%' and columnname = 'state';
UPDATE config_form_fields SET iseditable = false where formname ilike 've_connec_%' and columnname = 'state';
UPDATE config_form_fields SET iseditable = false where formname ilike 've_link_%' and columnname = 'state';
UPDATE config_form_fields SET iseditable = false where formname ilike 've_gully_%' and columnname = 'state';

INSERT INTO config_style (id, idval, descript, sys_role, addparam, is_templayer, active) VALUES(110, 'GwPlan', NULL, NULL, NULL, false, true);

UPDATE config_form_fields
	SET iseditable=false
	WHERE formname='generic' AND formtype='check_project' AND columnname='txt_infolog' AND tabname='tab_log';

UPDATE value_state SET active = true;

UPDATE config_form_fields SET widgettype='typeahead' WHERE formname='generic' AND formtype='link_to_connec' AND columnname='id' AND tabname='tab_none';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (4350, 'Planified arcs belong to a different psector than the current one', 'One or more planned arcs are associated with a different psector', 2, true, 'utils', 'core', 'UI'),
(4352, 'Fusion is not allowed in operative mode when there are planned arcs', 'To continue, switch to plan mode or remove the planned arcs from the psector', 2, true, 'utils', 'core', 'UI');

UPDATE sys_table SET context=NULL WHERE id='v_plan_current_psector';
UPDATE sys_table SET context=NULL WHERE id='v_plan_psector_arc';
UPDATE sys_table SET context=NULL WHERE id='v_plan_psector_connec';
UPDATE sys_table SET context=NULL WHERE id='v_plan_psector_link';
UPDATE sys_table SET context=NULL WHERE id='v_plan_psector_node';


INSERT INTO sys_style (layername, styleconfig_id, styletype, stylevalue, active) VALUES('ve_plan_psector', 110, 'qml', '<!DOCTYPE qgis PUBLIC ''http://mrcc.com/qgis.dtd'' ''SYSTEM''>
<qgis version="3.40.7-Bratislava" styleCategories="Symbology">
 <renderer-v2 forceraster="0" type="RuleRenderer" symbollevels="0" referencescale="-1" enableorderby="0">
  <rules key="{27c5bcf5-31ab-4680-a34f-7d1469258a0b}">
   <rule key="{acd8b33b-d1cb-4560-9912-677a5b67bb73}" symbol="1" label="Active" filter="active is true"/>
   <rule key="{1a5745ef-3db0-447b-916c-16f80c5fad2f}" symbol="2" label="Inactive" filter="active is not true"/>
   <rule key="{d7963222-1f79-4e3c-81c2-99095fc5484b}" symbol="0" label="Archived" filter="status in (5,6,7)"/>
  </rules>
  <symbols>
   <symbol frame_rate="10" type="fill" clip_to_extent="1" is_animated="0" force_rhr="0" name="0" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option type="QString" value="" name="name"/>
      <Option name="properties"/>
      <Option type="QString" value="collection" name="type"/>
     </Option>
    </data_defined_properties>
    <layer class="SimpleFill" id="{da502e84-2255-4840-b89b-b703671034aa}" locked="0" pass="0" enabled="1">
     <Option type="Map">
      <Option type="QString" value="3x:0,0,0,0,0,0" name="border_width_map_unit_scale"/>
      <Option type="QString" value="203,203,203,255,rgb:0.79607843137254897,0.79607843137254897,0.79607843137254897,1" name="color"/>
      <Option type="QString" value="bevel" name="joinstyle"/>
      <Option type="QString" value="0,0" name="offset"/>
      <Option type="QString" value="3x:0,0,0,0,0,0" name="offset_map_unit_scale"/>
      <Option type="QString" value="MM" name="offset_unit"/>
      <Option type="QString" value="203,203,203,255,hsv:0.82013888888888886,0,0.79452201113908594,1" name="outline_color"/>
      <Option type="QString" value="solid" name="outline_style"/>
      <Option type="QString" value="0.75" name="outline_width"/>
      <Option type="QString" value="MM" name="outline_width_unit"/>
      <Option type="QString" value="b_diagonal" name="style"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option type="QString" value="" name="name"/>
       <Option name="properties"/>
       <Option type="QString" value="collection" name="type"/>
      </Option>
     </data_defined_properties>
    </layer>
   </symbol>
   <symbol frame_rate="10" type="fill" clip_to_extent="1" is_animated="0" force_rhr="0" name="1" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option type="QString" value="" name="name"/>
      <Option name="properties"/>
      <Option type="QString" value="collection" name="type"/>
     </Option>
    </data_defined_properties>
    <layer class="SimpleFill" id="{da502e84-2255-4840-b89b-b703671034aa}" locked="0" pass="0" enabled="1">
     <Option type="Map">
      <Option type="QString" value="3x:0,0,0,0,0,0" name="border_width_map_unit_scale"/>
      <Option type="QString" value="227,92,92,63,rgb:0.8901960784313725,0.36078431372549019,0.36078431372549019,0.24705882352941178" name="color"/>
      <Option type="QString" value="bevel" name="joinstyle"/>
      <Option type="QString" value="0,0" name="offset"/>
      <Option type="QString" value="3x:0,0,0,0,0,0" name="offset_map_unit_scale"/>
      <Option type="QString" value="MM" name="offset_unit"/>
      <Option type="QString" value="0,202,0,255,hsv:0.33333333333333331,1,0.792156862745098,1" name="outline_color"/>
      <Option type="QString" value="solid" name="outline_style"/>
      <Option type="QString" value="0.75" name="outline_width"/>
      <Option type="QString" value="MM" name="outline_width_unit"/>
      <Option type="QString" value="no" name="style"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option type="QString" value="" name="name"/>
       <Option name="properties"/>
       <Option type="QString" value="collection" name="type"/>
      </Option>
     </data_defined_properties>
    </layer>
   </symbol>
   <symbol frame_rate="10" type="fill" clip_to_extent="1" is_animated="0" force_rhr="0" name="2" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option type="QString" value="" name="name"/>
      <Option name="properties"/>
      <Option type="QString" value="collection" name="type"/>
     </Option>
    </data_defined_properties>
    <layer class="SimpleFill" id="{da502e84-2255-4840-b89b-b703671034aa}" locked="0" pass="0" enabled="1">
     <Option type="Map">
      <Option type="QString" value="3x:0,0,0,0,0,0" name="border_width_map_unit_scale"/>
      <Option type="QString" value="227,92,92,63,rgb:0.8901960784313725,0.36078431372549019,0.36078431372549019,0.24705882352941178" name="color"/>
      <Option type="QString" value="bevel" name="joinstyle"/>
      <Option type="QString" value="0,0" name="offset"/>
      <Option type="QString" value="3x:0,0,0,0,0,0" name="offset_map_unit_scale"/>
      <Option type="QString" value="MM" name="offset_unit"/>
      <Option type="QString" value="255,149,0,255,rgb:1,0.58431372549019611,0,1" name="outline_color"/>
      <Option type="QString" value="solid" name="outline_style"/>
      <Option type="QString" value="0.75" name="outline_width"/>
      <Option type="QString" value="MM" name="outline_width_unit"/>
      <Option type="QString" value="no" name="style"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option type="QString" value="" name="name"/>
       <Option name="properties"/>
       <Option type="QString" value="collection" name="type"/>
      </Option>
     </data_defined_properties>
    </layer>
   </symbol>
  </symbols>
  <data-defined-properties>
   <Option type="Map">
    <Option type="QString" value="" name="name"/>
    <Option name="properties"/>
    <Option type="QString" value="collection" name="type"/>
   </Option>
  </data-defined-properties>
 </renderer-v2>
 <selection mode="Default">
  <selectionColor invalid="1"/>
  <selectionSymbol>
   <symbol frame_rate="10" type="fill" clip_to_extent="1" is_animated="0" force_rhr="0" name="" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option type="QString" value="" name="name"/>
      <Option name="properties"/>
      <Option type="QString" value="collection" name="type"/>
     </Option>
    </data_defined_properties>
    <layer class="SimpleFill" id="{323b1679-e9a1-4444-89e5-7be9913c57d8}" locked="0" pass="0" enabled="1">
     <Option type="Map">
      <Option type="QString" value="3x:0,0,0,0,0,0" name="border_width_map_unit_scale"/>
      <Option type="QString" value="0,0,255,255,rgb:0,0,1,1" name="color"/>
      <Option type="QString" value="bevel" name="joinstyle"/>
      <Option type="QString" value="0,0" name="offset"/>
      <Option type="QString" value="3x:0,0,0,0,0,0" name="offset_map_unit_scale"/>
      <Option type="QString" value="MM" name="offset_unit"/>
      <Option type="QString" value="35,35,35,255,rgb:0.13725490196078433,0.13725490196078433,0.13725490196078433,1" name="outline_color"/>
      <Option type="QString" value="solid" name="outline_style"/>
      <Option type="QString" value="0.26" name="outline_width"/>
      <Option type="QString" value="MM" name="outline_width_unit"/>
      <Option type="QString" value="solid" name="style"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option type="QString" value="" name="name"/>
       <Option name="properties"/>
       <Option type="QString" value="collection" name="type"/>
      </Option>
     </data_defined_properties>
    </layer>
   </symbol>
  </selectionSymbol>
 </selection>
 <blendMode>0</blendMode>
 <featureBlendMode>0</featureBlendMode>
 <layerGeometryType>2</layerGeometryType>
</qgis>
', true);


UPDATE sys_style SET stylevalue='<!DOCTYPE qgis PUBLIC ''http://mrcc.com/qgis.dtd'' ''SYSTEM''>
<qgis version="3.40.7-Bratislava" styleCategories="Symbology">
 <renderer-v2 forceraster="0" type="RuleRenderer" symbollevels="0" referencescale="-1" enableorderby="0">
  <rules key="{27c5bcf5-31ab-4680-a34f-7d1469258a0b}">
   <rule key="{acd8b33b-d1cb-4560-9912-677a5b67bb73}" symbol="1" label="Active" filter="active is true"/>
   <rule key="{1a5745ef-3db0-447b-916c-16f80c5fad2f}" symbol="2" label="Inactive" filter="active is not true"/>
   <rule key="{d7963222-1f79-4e3c-81c2-99095fc5484b}" symbol="0" label="Archived" filter="status in (5,6,7)"/>
  </rules>
  <symbols>
   <symbol frame_rate="10" type="fill" clip_to_extent="1" is_animated="0" force_rhr="0" name="0" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option type="QString" value="" name="name"/>
      <Option name="properties"/>
      <Option type="QString" value="collection" name="type"/>
     </Option>
    </data_defined_properties>
    <layer class="SimpleFill" id="{da502e84-2255-4840-b89b-b703671034aa}" locked="0" pass="0" enabled="1">
     <Option type="Map">
      <Option type="QString" value="3x:0,0,0,0,0,0" name="border_width_map_unit_scale"/>
      <Option type="QString" value="203,203,203,255,rgb:0.79607843137254897,0.79607843137254897,0.79607843137254897,1" name="color"/>
      <Option type="QString" value="bevel" name="joinstyle"/>
      <Option type="QString" value="0,0" name="offset"/>
      <Option type="QString" value="3x:0,0,0,0,0,0" name="offset_map_unit_scale"/>
      <Option type="QString" value="MM" name="offset_unit"/>
      <Option type="QString" value="203,203,203,255,hsv:0.82013888888888886,0,0.79452201113908594,1" name="outline_color"/>
      <Option type="QString" value="solid" name="outline_style"/>
      <Option type="QString" value="0.75" name="outline_width"/>
      <Option type="QString" value="MM" name="outline_width_unit"/>
      <Option type="QString" value="b_diagonal" name="style"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option type="QString" value="" name="name"/>
       <Option name="properties"/>
       <Option type="QString" value="collection" name="type"/>
      </Option>
     </data_defined_properties>
    </layer>
   </symbol>
   <symbol frame_rate="10" type="fill" clip_to_extent="1" is_animated="0" force_rhr="0" name="1" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option type="QString" value="" name="name"/>
      <Option name="properties"/>
      <Option type="QString" value="collection" name="type"/>
     </Option>
    </data_defined_properties>
    <layer class="SimpleFill" id="{da502e84-2255-4840-b89b-b703671034aa}" locked="0" pass="0" enabled="1">
     <Option type="Map">
      <Option type="QString" value="3x:0,0,0,0,0,0" name="border_width_map_unit_scale"/>
      <Option type="QString" value="227,92,92,63,rgb:0.8901960784313725,0.36078431372549019,0.36078431372549019,0.24705882352941178" name="color"/>
      <Option type="QString" value="bevel" name="joinstyle"/>
      <Option type="QString" value="0,0" name="offset"/>
      <Option type="QString" value="3x:0,0,0,0,0,0" name="offset_map_unit_scale"/>
      <Option type="QString" value="MM" name="offset_unit"/>
      <Option type="QString" value="0,202,0,255,hsv:0.33333333333333331,1,0.792156862745098,1" name="outline_color"/>
      <Option type="QString" value="solid" name="outline_style"/>
      <Option type="QString" value="0.75" name="outline_width"/>
      <Option type="QString" value="MM" name="outline_width_unit"/>
      <Option type="QString" value="no" name="style"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option type="QString" value="" name="name"/>
       <Option name="properties"/>
       <Option type="QString" value="collection" name="type"/>
      </Option>
     </data_defined_properties>
    </layer>
   </symbol>
   <symbol frame_rate="10" type="fill" clip_to_extent="1" is_animated="0" force_rhr="0" name="2" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option type="QString" value="" name="name"/>
      <Option name="properties"/>
      <Option type="QString" value="collection" name="type"/>
     </Option>
    </data_defined_properties>
    <layer class="SimpleFill" id="{da502e84-2255-4840-b89b-b703671034aa}" locked="0" pass="0" enabled="1">
     <Option type="Map">
      <Option type="QString" value="3x:0,0,0,0,0,0" name="border_width_map_unit_scale"/>
      <Option type="QString" value="227,92,92,63,rgb:0.8901960784313725,0.36078431372549019,0.36078431372549019,0.24705882352941178" name="color"/>
      <Option type="QString" value="bevel" name="joinstyle"/>
      <Option type="QString" value="0,0" name="offset"/>
      <Option type="QString" value="3x:0,0,0,0,0,0" name="offset_map_unit_scale"/>
      <Option type="QString" value="MM" name="offset_unit"/>
      <Option type="QString" value="255,149,0,255,rgb:1,0.58431372549019611,0,1" name="outline_color"/>
      <Option type="QString" value="solid" name="outline_style"/>
      <Option type="QString" value="0.75" name="outline_width"/>
      <Option type="QString" value="MM" name="outline_width_unit"/>
      <Option type="QString" value="no" name="style"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option type="QString" value="" name="name"/>
       <Option name="properties"/>
       <Option type="QString" value="collection" name="type"/>
      </Option>
     </data_defined_properties>
    </layer>
   </symbol>
  </symbols>
  <data-defined-properties>
   <Option type="Map">
    <Option type="QString" value="" name="name"/>
    <Option name="properties"/>
    <Option type="QString" value="collection" name="type"/>
   </Option>
  </data-defined-properties>
 </renderer-v2>
 <selection mode="Default">
  <selectionColor invalid="1"/>
  <selectionSymbol>
   <symbol frame_rate="10" type="fill" clip_to_extent="1" is_animated="0" force_rhr="0" name="" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option type="QString" value="" name="name"/>
      <Option name="properties"/>
      <Option type="QString" value="collection" name="type"/>
     </Option>
    </data_defined_properties>
    <layer class="SimpleFill" id="{323b1679-e9a1-4444-89e5-7be9913c57d8}" locked="0" pass="0" enabled="1">
     <Option type="Map">
      <Option type="QString" value="3x:0,0,0,0,0,0" name="border_width_map_unit_scale"/>
      <Option type="QString" value="0,0,255,255,rgb:0,0,1,1" name="color"/>
      <Option type="QString" value="bevel" name="joinstyle"/>
      <Option type="QString" value="0,0" name="offset"/>
      <Option type="QString" value="3x:0,0,0,0,0,0" name="offset_map_unit_scale"/>
      <Option type="QString" value="MM" name="offset_unit"/>
      <Option type="QString" value="35,35,35,255,rgb:0.13725490196078433,0.13725490196078433,0.13725490196078433,1" name="outline_color"/>
      <Option type="QString" value="solid" name="outline_style"/>
      <Option type="QString" value="0.26" name="outline_width"/>
      <Option type="QString" value="MM" name="outline_width_unit"/>
      <Option type="QString" value="solid" name="style"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option type="QString" value="" name="name"/>
       <Option name="properties"/>
       <Option type="QString" value="collection" name="type"/>
      </Option>
     </data_defined_properties>
    </layer>
   </symbol>
  </selectionSymbol>
 </selection>
 <blendMode>0</blendMode>
 <featureBlendMode>0</featureBlendMode>
 <layerGeometryType>2</layerGeometryType>
</qgis>
' WHERE styleconfig_id=110;

CREATE TRIGGER gw_trg_edit_frelem_x_node_delete AFTER DELETE ON
element_x_node FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_frelem_x_node();