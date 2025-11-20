/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;

ALTER TABLE config_form_fields DISABLE TRIGGER gw_trg_config_control;

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source")
VALUES (3326, 'gw_fct_graphanalytics_arrangenetwork', 'utils', 'function', NULL, 'json', 'Function to arrenge the network in graphanalytics', 'role_basic', NULL, 'core')
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source")
VALUES (3328, 'gw_fct_graphanalytics_initnetwork', 'utils', 'function', 'json', 'json', 'Function to init the network in graphanalytics', 'role_basic', NULL, 'core')
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source")
VALUES (3330, 'gw_fct_graphanalytics_create_temptables', 'utils', 'function', 'json', 'json', 'Function to create temporal tables for graphanalytics', 'role_basic', NULL, 'core')
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source")
VALUES (3332, 'gw_fct_graphanalytics_delete_temptables', 'utils', 'function', 'json', 'json', 'Function to create temporal tables for graphanalytics', 'role_basic', NULL, 'core')
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source")
VALUES (3334, 'gw_fct_graphanalytics_settempgeom', 'utils', 'function', 'json', 'json', 'Function to update the geometry of the mapzones in the temp_minsector table for graphanalytics', 'role_basic', NULL, 'core')
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source")
VALUES (3336, 'gw_fct_graphanalytics_macrominsector', 'utils', 'function', 'json', 'json', 'Function to create macrominsectors', 'role_master', NULL, 'core')
ON CONFLICT (id) DO NOTHING;

-- update graphanalytic_minsector description to include explotation id description
UPDATE sys_function SET descript='Dynamic analisys to sectorize network using the flow traceability function and establish Minimum Sectors. 
Before start you need to configure:
- Field graph_delimiter on [cat_feature_node] table to establish which elements will be used to sectorize. 
- Enable status for minsector on utils_graphanalytics_status variable from [config_param_system] table.

In explotation id you can use ''-9'' to select all explotations, or a list of explotations separated by comma.'
WHERE id=2706;

INSERT INTO config_toolbox (id, alias, functionparams, inputparams, observ, active, device)
VALUES(3336, 'Macrominsector analysis', '{"featureType":[]}'::json, NULL, NULL, true, '{4}');

INSERT INTO sys_param_user VALUES ('utils_psector_strategy', 'config', 'Psector strategy', 'role_master', null, 'Value for psector_strategy', null, null, TRUE,
20, 'utils', FALSE, null, null, null, FALSE, 'text', 'check', TRUE, null, 'true', 'lyt_other', TRUE, null, null, null, null, 'core') ON CONFLICT (id) DO NOTHING;

--24/09/2024
INSERT INTO sys_function (id,function_name,project_type,function_type,input_params,return_type,descript,sys_role,"source")
VALUES (3338,'gw_fct_getgraphinundation','utils','function',NULL,'json','Retrieves GeoJSON data representing the inundation (flooding) graph for a specific area','role_edit','core');

--01/10/2024
INSERT INTO config_function (id, function_name, "style", layermanager, actions) VALUES(3336, 'gw_fct_getgraphinundation', '{
  "style": {
    "line": {
      "style": "unique",
      "values": {
        "width": 1.5,
        "color": [
          0,
          0,
          255
        ],
        "transparency": 0.7
      }
    }
  }
}'::json, NULL, NULL);

-- 09/10/2024
UPDATE sys_feature_class SET man_table  = 'element' WHERE id = 'ELEMENT';
UPDATE sys_feature_class SET man_table  = 'link' WHERE id = 'LINK';

ALTER TABLE sys_feature_class ALTER COLUMN man_table SET NOT NULL;

-- 18/10/2024
UPDATE config_form_fields SET widgetcontrols='{
  "reloadFields": [
    "fluid_type",
    "location_type",
    "category_type",
    "function_type",
    "featurecat_id"
  ]
}'::json WHERE formname='generic' AND formtype='form_featuretype_change' AND columnname='feature_type_new' AND tabname='tab_none';

-- 21/10/2024
UPDATE config_form_fields
  SET widgetcontrols='{"labelPosition": "top", "filterSign": ">="}'::json
  WHERE formtype='form_feature' AND columnname='date_event_from' AND tabname='tab_event';
UPDATE config_form_fields
  SET widgetcontrols='{"labelPosition": "top", "filterSign": "<="}'::json
  WHERE formtype='form_feature' AND columnname='date_event_to' AND tabname='tab_event';

--25/10/2024
INSERT INTO config_style (id,idval,is_templayer,active)
	VALUES (109,'GwSelectedPsector',true,true);

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source")
VALUES(3340, 'gw_fct_getpsectorfeatures', 'utils', 'function', 'json', 'json', 'Retrieves GeoJSON data with all the features from the selected psector ', 'role_edit', NULL, 'core');

INSERT INTO config_function (id,function_name,"style")
	VALUES (3340,'gw_fct_getpsectorfeatures','{
  "style": {
    "point": {
      "style": "qml",
      "id": "109"
    },
    "line": {
      "style": "qml",
      "id": "109"
    }
  }
}'::json);

INSERT INTO sys_style (layername, styleconfig_id, styletype, stylevalue, active) VALUES('line', 109, 'qml', '<!DOCTYPE qgis PUBLIC ''http://mrcc.com/qgis.dtd'' ''SYSTEM''>
<qgis styleCategories="Symbology" version="3.34.7-Prizren">
  <renderer-v2 attr="state" enableorderby="0" symbollevels="0" forceraster="0" referencescale="-1" type="categorizedSymbol">
    <categories>
      <category symbol="0" render="true" type="string" label="0" uuid="{29a5669a-e822-4c73-b36c-7525620f3c98}" value="0"/>
      <category symbol="1" render="true" type="string" label="1" uuid="{85682659-f88f-41b7-8234-84fc30c576b2}" value="1"/>
    </categories>
    <symbols>
      <symbol frame_rate="10" clip_to_extent="1" is_animated="0" alpha="1" force_rhr="0" type="line" name="0">
        <data_defined_properties>
          <Option type="Map">
            <Option type="QString" name="name" value=""/>
            <Option name="properties"/>
            <Option type="QString" name="type" value="collection"/>
          </Option>
        </data_defined_properties>
        <layer pass="0" id="{a391b56d-2384-467a-ade2-b0885f58876d}" locked="0" class="SimpleLine" enabled="1">
          <Option type="Map">
            <Option type="QString" name="align_dash_pattern" value="0"/>
            <Option type="QString" name="capstyle" value="square"/>
            <Option type="QString" name="customdash" value="5;2"/>
            <Option type="QString" name="customdash_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="customdash_unit" value="MM"/>
            <Option type="QString" name="dash_pattern_offset" value="0"/>
            <Option type="QString" name="dash_pattern_offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="dash_pattern_offset_unit" value="MM"/>
            <Option type="QString" name="draw_inside_polygon" value="0"/>
            <Option type="QString" name="joinstyle" value="bevel"/>
            <Option type="QString" name="line_color" value="219,30,42,255"/>
            <Option type="QString" name="line_style" value="solid"/>
            <Option type="QString" name="line_width" value="0.66"/>
            <Option type="QString" name="line_width_unit" value="MM"/>
            <Option type="QString" name="offset" value="0"/>
            <Option type="QString" name="offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="offset_unit" value="MM"/>
            <Option type="QString" name="ring_filter" value="0"/>
            <Option type="QString" name="trim_distance_end" value="0"/>
            <Option type="QString" name="trim_distance_end_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="trim_distance_end_unit" value="MM"/>
            <Option type="QString" name="trim_distance_start" value="0"/>
            <Option type="QString" name="trim_distance_start_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="trim_distance_start_unit" value="MM"/>
            <Option type="QString" name="tweak_dash_pattern_on_corners" value="0"/>
            <Option type="QString" name="use_custom_dash" value="0"/>
            <Option type="QString" name="width_map_unit_scale" value="3x:0,0,0,0,0,0"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol frame_rate="10" clip_to_extent="1" is_animated="0" alpha="1" force_rhr="0" type="line" name="1">
        <data_defined_properties>
          <Option type="Map">
            <Option type="QString" name="name" value=""/>
            <Option name="properties"/>
            <Option type="QString" name="type" value="collection"/>
          </Option>
        </data_defined_properties>
        <layer pass="0" id="{9d0ced51-3130-401a-a360-e50baff730f8}" locked="0" class="SimpleLine" enabled="1">
          <Option type="Map">
            <Option type="QString" name="align_dash_pattern" value="0"/>
            <Option type="QString" name="capstyle" value="square"/>
            <Option type="QString" name="customdash" value="5;2"/>
            <Option type="QString" name="customdash_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="customdash_unit" value="MM"/>
            <Option type="QString" name="dash_pattern_offset" value="0"/>
            <Option type="QString" name="dash_pattern_offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="dash_pattern_offset_unit" value="MM"/>
            <Option type="QString" name="draw_inside_polygon" value="0"/>
            <Option type="QString" name="joinstyle" value="bevel"/>
            <Option type="QString" name="line_color" value="84,176,74,255"/>
            <Option type="QString" name="line_style" value="solid"/>
            <Option type="QString" name="line_width" value="0.66"/>
            <Option type="QString" name="line_width_unit" value="MM"/>
            <Option type="QString" name="offset" value="0"/>
            <Option type="QString" name="offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="offset_unit" value="MM"/>
            <Option type="QString" name="ring_filter" value="0"/>
            <Option type="QString" name="trim_distance_end" value="0"/>
            <Option type="QString" name="trim_distance_end_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="trim_distance_end_unit" value="MM"/>
            <Option type="QString" name="trim_distance_start" value="0"/>
            <Option type="QString" name="trim_distance_start_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="trim_distance_start_unit" value="MM"/>
            <Option type="QString" name="tweak_dash_pattern_on_corners" value="0"/>
            <Option type="QString" name="use_custom_dash" value="0"/>
            <Option type="QString" name="width_map_unit_scale" value="3x:0,0,0,0,0,0"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </symbols>
    <source-symbol>
      <symbol frame_rate="10" clip_to_extent="1" is_animated="0" alpha="0.5" force_rhr="0" type="line" name="0">
        <data_defined_properties>
          <Option type="Map">
            <Option type="QString" name="name" value=""/>
            <Option name="properties"/>
            <Option type="QString" name="type" value="collection"/>
          </Option>
        </data_defined_properties>
        <layer pass="0" id="{a187d0f2-a38f-4516-bb7b-6db32e370dbf}" locked="0" class="SimpleLine" enabled="1">
          <Option type="Map">
            <Option type="QString" name="align_dash_pattern" value="0"/>
            <Option type="QString" name="capstyle" value="square"/>
            <Option type="QString" name="customdash" value="5;2"/>
            <Option type="QString" name="customdash_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="customdash_unit" value="MM"/>
            <Option type="QString" name="dash_pattern_offset" value="0"/>
            <Option type="QString" name="dash_pattern_offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="dash_pattern_offset_unit" value="MM"/>
            <Option type="QString" name="draw_inside_polygon" value="0"/>
            <Option type="QString" name="joinstyle" value="bevel"/>
            <Option type="QString" name="line_color" value="255,1,1,255"/>
            <Option type="QString" name="line_style" value="solid"/>
            <Option type="QString" name="line_width" value="2"/>
            <Option type="QString" name="line_width_unit" value="MM"/>
            <Option type="QString" name="offset" value="0"/>
            <Option type="QString" name="offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="offset_unit" value="MM"/>
            <Option type="QString" name="ring_filter" value="0"/>
            <Option type="QString" name="trim_distance_end" value="0"/>
            <Option type="QString" name="trim_distance_end_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="trim_distance_end_unit" value="MM"/>
            <Option type="QString" name="trim_distance_start" value="0"/>
            <Option type="QString" name="trim_distance_start_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="trim_distance_start_unit" value="MM"/>
            <Option type="QString" name="tweak_dash_pattern_on_corners" value="0"/>
            <Option type="QString" name="use_custom_dash" value="0"/>
            <Option type="QString" name="width_map_unit_scale" value="3x:0,0,0,0,0,0"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </source-symbol>
    <rotation/>
    <sizescale/>
  </renderer-v2>
  <selection mode="Default">
    <selectionColor invalid="1"/>
    <selectionSymbol>
      <symbol frame_rate="10" clip_to_extent="1" is_animated="0" alpha="1" force_rhr="0" type="line" name="">
        <data_defined_properties>
          <Option type="Map">
            <Option type="QString" name="name" value=""/>
            <Option name="properties"/>
            <Option type="QString" name="type" value="collection"/>
          </Option>
        </data_defined_properties>
        <layer pass="0" id="{b8e8cee6-e913-4fe1-ad85-fd1b7d97a05b}" locked="0" class="SimpleLine" enabled="1">
          <Option type="Map">
            <Option type="QString" name="align_dash_pattern" value="0"/>
            <Option type="QString" name="capstyle" value="square"/>
            <Option type="QString" name="customdash" value="5;2"/>
            <Option type="QString" name="customdash_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="customdash_unit" value="MM"/>
            <Option type="QString" name="dash_pattern_offset" value="0"/>
            <Option type="QString" name="dash_pattern_offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="dash_pattern_offset_unit" value="MM"/>
            <Option type="QString" name="draw_inside_polygon" value="0"/>
            <Option type="QString" name="joinstyle" value="bevel"/>
            <Option type="QString" name="line_color" value="35,35,35,255"/>
            <Option type="QString" name="line_style" value="solid"/>
            <Option type="QString" name="line_width" value="0.26"/>
            <Option type="QString" name="line_width_unit" value="MM"/>
            <Option type="QString" name="offset" value="0"/>
            <Option type="QString" name="offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="offset_unit" value="MM"/>
            <Option type="QString" name="ring_filter" value="0"/>
            <Option type="QString" name="trim_distance_end" value="0"/>
            <Option type="QString" name="trim_distance_end_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="trim_distance_end_unit" value="MM"/>
            <Option type="QString" name="trim_distance_start" value="0"/>
            <Option type="QString" name="trim_distance_start_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="trim_distance_start_unit" value="MM"/>
            <Option type="QString" name="tweak_dash_pattern_on_corners" value="0"/>
            <Option type="QString" name="use_custom_dash" value="0"/>
            <Option type="QString" name="width_map_unit_scale" value="3x:0,0,0,0,0,0"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </selectionSymbol>
  </selection>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerGeometryType>1</layerGeometryType>
</qgis>', true);

INSERT INTO sys_style (layername, styleconfig_id, styletype, stylevalue, active) VALUES('point', 109, 'qml', '<!DOCTYPE qgis PUBLIC ''http://mrcc.com/qgis.dtd'' ''SYSTEM''>
<qgis styleCategories="Symbology" version="3.34.7-Prizren">
  <renderer-v2 type="categorizedSymbol" symbollevels="0" attr="state" enableorderby="0" forceraster="0" referencescale="-1">
    <categories>
      <category type="string" uuid="{f8df73fa-3878-4caf-a44f-e30b3d14c36c}" label="0" symbol="0" value="0" render="true"/>
      <category type="string" uuid="{80f70d8a-963a-4de8-858a-7f0fb1934891}" label="1" symbol="1" value="1" render="true"/>
    </categories>
    <symbols>
      <symbol type="marker" frame_rate="10" alpha="1" clip_to_extent="1" is_animated="0" name="0" force_rhr="0">
        <data_defined_properties>
          <Option type="Map">
            <Option type="QString" value="" name="name"/>
            <Option name="properties"/>
            <Option type="QString" value="collection" name="type"/>
          </Option>
        </data_defined_properties>
        <layer class="SimpleMarker" enabled="1" pass="0" locked="0" id="{81483f17-9467-4a85-9ff7-f65635a16ac1}">
          <Option type="Map">
            <Option type="QString" value="0" name="angle"/>
            <Option type="QString" value="square" name="cap_style"/>
            <Option type="QString" value="219,30,42,255" name="color"/>
            <Option type="QString" value="1" name="horizontal_anchor_point"/>
            <Option type="QString" value="bevel" name="joinstyle"/>
            <Option type="QString" value="circle" name="name"/>
            <Option type="QString" value="0,0" name="offset"/>
            <Option type="QString" value="3x:0,0,0,0,0,0" name="offset_map_unit_scale"/>
            <Option type="QString" value="MM" name="offset_unit"/>
            <Option type="QString" value="35,35,35,255" name="outline_color"/>
            <Option type="QString" value="solid" name="outline_style"/>
            <Option type="QString" value="0" name="outline_width"/>
            <Option type="QString" value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale"/>
            <Option type="QString" value="MM" name="outline_width_unit"/>
            <Option type="QString" value="diameter" name="scale_method"/>
            <Option type="QString" value="2" name="size"/>
            <Option type="QString" value="3x:0,0,0,0,0,0" name="size_map_unit_scale"/>
            <Option type="QString" value="MM" name="size_unit"/>
            <Option type="QString" value="1" name="vertical_anchor_point"/>
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
      <symbol type="marker" frame_rate="10" alpha="1" clip_to_extent="1" is_animated="0" name="1" force_rhr="0">
        <data_defined_properties>
          <Option type="Map">
            <Option type="QString" value="" name="name"/>
            <Option name="properties"/>
            <Option type="QString" value="collection" name="type"/>
          </Option>
        </data_defined_properties>
        <layer class="SimpleMarker" enabled="1" pass="0" locked="0" id="{81483f17-9467-4a85-9ff7-f65635a16ac1}">
          <Option type="Map">
            <Option type="QString" value="0" name="angle"/>
            <Option type="QString" value="square" name="cap_style"/>
            <Option type="QString" value="84,176,74,255" name="color"/>
            <Option type="QString" value="1" name="horizontal_anchor_point"/>
            <Option type="QString" value="bevel" name="joinstyle"/>
            <Option type="QString" value="circle" name="name"/>
            <Option type="QString" value="0,0" name="offset"/>
            <Option type="QString" value="3x:0,0,0,0,0,0" name="offset_map_unit_scale"/>
            <Option type="QString" value="MM" name="offset_unit"/>
            <Option type="QString" value="35,35,35,255" name="outline_color"/>
            <Option type="QString" value="solid" name="outline_style"/>
            <Option type="QString" value="0" name="outline_width"/>
            <Option type="QString" value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale"/>
            <Option type="QString" value="MM" name="outline_width_unit"/>
            <Option type="QString" value="diameter" name="scale_method"/>
            <Option type="QString" value="2" name="size"/>
            <Option type="QString" value="3x:0,0,0,0,0,0" name="size_map_unit_scale"/>
            <Option type="QString" value="MM" name="size_unit"/>
            <Option type="QString" value="1" name="vertical_anchor_point"/>
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
    <source-symbol>
      <symbol type="marker" frame_rate="10" alpha="1" clip_to_extent="1" is_animated="0" name="0" force_rhr="0">
        <data_defined_properties>
          <Option type="Map">
            <Option type="QString" value="" name="name"/>
            <Option name="properties"/>
            <Option type="QString" value="collection" name="type"/>
          </Option>
        </data_defined_properties>
        <layer class="SimpleMarker" enabled="1" pass="0" locked="0" id="{81483f17-9467-4a85-9ff7-f65635a16ac1}">
          <Option type="Map">
            <Option type="QString" value="0" name="angle"/>
            <Option type="QString" value="square" name="cap_style"/>
            <Option type="QString" value="255,1,1,255" name="color"/>
            <Option type="QString" value="1" name="horizontal_anchor_point"/>
            <Option type="QString" value="bevel" name="joinstyle"/>
            <Option type="QString" value="circle" name="name"/>
            <Option type="QString" value="0,0" name="offset"/>
            <Option type="QString" value="3x:0,0,0,0,0,0" name="offset_map_unit_scale"/>
            <Option type="QString" value="MM" name="offset_unit"/>
            <Option type="QString" value="35,35,35,255" name="outline_color"/>
            <Option type="QString" value="solid" name="outline_style"/>
            <Option type="QString" value="0" name="outline_width"/>
            <Option type="QString" value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale"/>
            <Option type="QString" value="MM" name="outline_width_unit"/>
            <Option type="QString" value="diameter" name="scale_method"/>
            <Option type="QString" value="2" name="size"/>
            <Option type="QString" value="3x:0,0,0,0,0,0" name="size_map_unit_scale"/>
            <Option type="QString" value="MM" name="size_unit"/>
            <Option type="QString" value="1" name="vertical_anchor_point"/>
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
    </source-symbol>
    <rotation/>
    <sizescale/>
  </renderer-v2>
  <selection mode="Default">
    <selectionColor invalid="1"/>
    <selectionSymbol>
      <symbol type="marker" frame_rate="10" alpha="1" clip_to_extent="1" is_animated="0" name="" force_rhr="0">
        <data_defined_properties>
          <Option type="Map">
            <Option type="QString" value="" name="name"/>
            <Option name="properties"/>
            <Option type="QString" value="collection" name="type"/>
          </Option>
        </data_defined_properties>
        <layer class="SimpleMarker" enabled="1" pass="0" locked="0" id="{b137c48a-f52b-41be-b83b-5d204974aab6}">
          <Option type="Map">
            <Option type="QString" value="0" name="angle"/>
            <Option type="QString" value="square" name="cap_style"/>
            <Option type="QString" value="255,0,0,255" name="color"/>
            <Option type="QString" value="1" name="horizontal_anchor_point"/>
            <Option type="QString" value="bevel" name="joinstyle"/>
            <Option type="QString" value="circle" name="name"/>
            <Option type="QString" value="0,0" name="offset"/>
            <Option type="QString" value="3x:0,0,0,0,0,0" name="offset_map_unit_scale"/>
            <Option type="QString" value="MM" name="offset_unit"/>
            <Option type="QString" value="35,35,35,255" name="outline_color"/>
            <Option type="QString" value="solid" name="outline_style"/>
            <Option type="QString" value="0" name="outline_width"/>
            <Option type="QString" value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale"/>
            <Option type="QString" value="MM" name="outline_width_unit"/>
            <Option type="QString" value="diameter" name="scale_method"/>
            <Option type="QString" value="2" name="size"/>
            <Option type="QString" value="3x:0,0,0,0,0,0" name="size_map_unit_scale"/>
            <Option type="QString" value="MM" name="size_unit"/>
            <Option type="QString" value="1" name="vertical_anchor_point"/>
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
  <layerGeometryType>0</layerGeometryType>
</qgis>', true);

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source") VALUES(3342, 'gw_fct_set_current', 'utils', 'function', 'json', 'json', 'Sets the selected value as "current" for the user in config_param_user(value) and return the id and name to set it on label', 'role_basic', NULL, 'core');


-- 30/10/2024

DELETE FROM sys_foreignkey WHERE typevalue_table='inp_typevalue' AND typevalue_name='inp_value_param_energy' AND target_table='inp_pump' AND target_field='energyparam';
DELETE FROM sys_foreignkey WHERE typevalue_table='inp_typevalue' AND typevalue_name='inp_value_param_energy' AND target_table='inp_pump_additional' AND target_field='energyparam';
DELETE FROM sys_foreignkey WHERE typevalue_table='inp_typevalue' AND typevalue_name='inp_value_param_energy' AND target_table='inp_dscenario_pump_additional' AND target_field='energyparam';

DELETE FROM sys_foreignkey WHERE typevalue_table='inp_typevalue' AND typevalue_name='inp_value_pattern_type' AND target_table='inp_pattern' AND target_field='pattern_type';

DELETE FROM sys_foreignkey WHERE typevalue_table='inp_typevalue' AND typevalue_name='inp_value_status_valve' AND target_table='inp_valve' AND target_field='status';

DELETE FROM sys_foreignkey  WHERE typevalue_table='config_typevalue' AND typevalue_name='linkedaction_typevalue' AND target_table='config_form_fields' AND target_field='linkedaction';

ALTER TABLE inp_typevalue DISABLE TRIGGER gw_trg_typevalue_config_fk;
DELETE FROM inp_typevalue WHERE typevalue='inp_value_param_energy' AND id='EFFIC';
DELETE FROM inp_typevalue WHERE typevalue='inp_value_param_energy' AND id='PATTERN';
DELETE FROM inp_typevalue WHERE typevalue='inp_value_param_energy' AND id='PRICE';

DELETE FROM inp_typevalue WHERE typevalue='inp_value_pattern_type' AND id='VOLUME';
DELETE FROM inp_typevalue WHERE typevalue='inp_value_pattern_type' AND id='UNITARY';

DELETE FROM inp_typevalue WHERE typevalue='inp_value_status_valve' AND id='CLOSED';
DELETE FROM inp_typevalue WHERE typevalue='inp_value_status_valve' AND id='OPEN';
ALTER TABLE inp_typevalue ENABLE TRIGGER gw_trg_typevalue_config_fk;

ALTER TABLE config_typevalue DISABLE TRIGGER gw_trg_typevalue_config_fk;
DELETE FROM config_typevalue WHERE typevalue='linkedaction_typevalue' AND id='action_catalog';
DELETE FROM config_typevalue WHERE typevalue='linkedaction_typevalue' AND id='action_link';
DELETE FROM config_typevalue WHERE typevalue='linkedaction_typevalue' AND id='action_workcat';
ALTER TABLE config_typevalue ENABLE TRIGGER gw_trg_typevalue_config_fk;

DELETE FROM plan_typevalue WHERE typevalue = 'result_type';

INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, source, isaudit, fprocess_type, addparam)
VALUES (474, 'Get epa calibration file for pressures', 'ws', NULL, 'core', true, 'Function process', NULL) ON CONFLICT (fid) DO NOTHING;
INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, source, isaudit, fprocess_type, addparam)
VALUES (475, 'Get epa calibration file for volumes', 'ws', NULL, 'core', true, 'Function process', NULL) ON CONFLICT (fid) DO NOTHING;
INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, source, isaudit, fprocess_type, addparam)
VALUES (476, 'Get log for epa calibration volumes', 'ws', NULL, 'core', true, 'Function process', NULL) ON CONFLICT (fid) DO NOTHING;


INSERT INTO config_fprocess (fid, tablename, target, querytext, orderby, addparam, active) VALUES (474, 'vcp_pipes', '[PIPES]', NULL, 1, NULL, TRUE) ON CONFLICT (fid, tablename, target) DO NOTHING;
INSERT INTO config_fprocess (fid, tablename, target, querytext, orderby, addparam, active) VALUES (475, 'vcv_times', '[TIMES]', NULL, 1, NULL, TRUE) ON CONFLICT (fid, tablename, target) DO NOTHING;
INSERT INTO config_fprocess (fid, tablename, target, querytext, orderby, addparam, active) VALUES (475, 'vcv_dma', '[DMA]', NULL, 2, NULL, TRUE) ON CONFLICT (fid, tablename, target) DO NOTHING;
INSERT INTO config_fprocess (fid, tablename, target, querytext, orderby, addparam, active) VALUES (475, 'vcv_junction', '[JUNCTIONS]', NULL, 3, NULL, TRUE) ON CONFLICT (fid, tablename, target) DO NOTHING;
INSERT INTO config_fprocess (fid, tablename, target, querytext, orderby, addparam, active) VALUES (475, 'vcv_emitters', '[EMITTERS]', NULL, 4, NULL, TRUE) ON CONFLICT (fid, tablename, target) DO NOTHING;
INSERT INTO config_fprocess (fid, tablename, target, querytext, orderby, addparam, active) VALUES (475, 'vcv_demands', '[DEMANDS]', NULL, 5, NULL, TRUE) ON CONFLICT (fid, tablename, target) DO NOTHING;
INSERT INTO config_fprocess (fid, tablename, target, querytext, orderby, addparam, active) VALUES (475, 'vcv_patterns', '[PATTERNS]', NULL, 6, NULL, TRUE) ON CONFLICT (fid, tablename, target) DO NOTHING;
INSERT INTO config_fprocess (fid, tablename, target, querytext, orderby, addparam, active) VALUES (476, 'vcv_emitters_log', '[EMITTER]', NULL, 1, NULL, TRUE) ON CONFLICT (fid, tablename, target) DO NOTHING;
INSERT INTO config_fprocess (fid, tablename, target, querytext, orderby, addparam, active) VALUES (476, 'vcv_dma_log', '[DMA]', NULL, 2, NULL, TRUE) ON CONFLICT (fid, tablename, target) DO NOTHING;

INSERT INTO sys_table (id, descript, sys_role, criticity, context, orderby, alias, notify_action, isaudit, keepauditdays, "source", addparam) VALUES('vcv_times', 'View times for epatools', 'role_admin', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'core', NULL);
INSERT INTO sys_table (id, descript, sys_role, criticity, context, orderby, alias, notify_action, isaudit, keepauditdays, "source", addparam) VALUES('vcv_dma', 'View dma for epatools', 'role_admin', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'core', NULL);
INSERT INTO sys_table (id, descript, sys_role, criticity, context, orderby, alias, notify_action, isaudit, keepauditdays, "source", addparam) VALUES('vcv_emitters', 'View emitters for epatools', 'role_admin', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'core', NULL);

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source") VALUES(3344, 'gw_fct_getepacalfile', 'utils', 'function', 'json', 'json', 'Function to get calibration files from epatools', 'role_admin', NULL, 'core');


INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam) VALUES(532, 'Dynamic macrominsector analysis', 'utils', NULL, 'core', true, 'Function process', NULL);
-- 15/11/2024

UPDATE config_form_fields
	SET stylesheet='{"icon":"129"}'::json
	WHERE stylesheet->>'icon'='70';

UPDATE config_form_fields
	SET stylesheet='{"icon":"113"}'::json
	WHERE stylesheet->>'icon'='111b';

UPDATE config_form_fields
	SET stylesheet='{"icon":"143"}'::json
	WHERE stylesheet->>'icon'='131b';

UPDATE config_form_fields
	SET stylesheet='{"icon":"144"}'::json
	WHERE stylesheet->>'icon'='134b';

UPDATE config_form_fields
	SET stylesheet='{"icon":"147"}'::json
	WHERE stylesheet->>'icon'='170b';

UPDATE config_form_fields
	SET stylesheet='{"icon":"145"}'::json
	WHERE stylesheet->>'icon'='136b';

UPDATE config_form_fields
	SET stylesheet='{"icon":"114"}'::json
	WHERE stylesheet->>'icon'='112b';

UPDATE config_form_fields
	SET stylesheet='{"icon":"119"}'::json
	WHERE stylesheet->>'icon'='64';

UPDATE config_form_fields
	SET stylesheet='{"icon":"101"}'::json
	WHERE stylesheet->>'icon'='101';

UPDATE config_form_fields
	SET stylesheet='{"icon":"127"}'::json
	WHERE stylesheet->>'icon'='65';

UPDATE config_form_fields
	SET stylesheet='{"icon":"149"}'::json
	WHERE stylesheet->>'icon'='191';

UPDATE config_form_fields
	SET stylesheet='{"icon":"152"}'::json
	WHERE stylesheet->>'icon'='195';

-- 18/11/24
UPDATE config_form_fields SET widgettype='typeahead' WHERE formname='generic' AND formtype='form_featuretype_change' AND columnname='featurecat_id' AND tabname='tab_none';



INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, "source")
VALUES (3346, 'gw_trg_mantypevalue_fk', 'utils', 'trigger', NULL, NULL, 'Control foreign keys created in man_type_* tables', 'role_edit', 'core');

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, "source")
VALUES (3348, 'gw_fct_get_dialog', 'utils', 'function', 'json', 'json', 'Function to build dialogs for generic forms', 'role_basic', 'core');

UPDATE config_form_fields SET widgetfunction='{"functionName": "open_selected_path", "parameters":{"targetwidget":"tab_hydrometer_tbl_hydrometer", "columnfind": "hydrometer_link"}}'::json WHERE formname='connec' AND formtype='form_feature' AND columnname='btn_link' AND tabname='tab_hydrometer';
UPDATE config_form_fields SET widgetfunction='{"functionName": "open_selected_path", "parameters":{"targetwidget":"tab_hydrometer_tbl_hydrometer", "columnfind": "hydrometer_link"}}'::json WHERE formname='node' AND formtype='form_feature' AND columnname='btn_link' AND tabname='tab_hydrometer';

-- 20/11/24
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('arc', 'form_feature', 'tab_elements', 'btn_link', 'lyt_element_1', 12, NULL, 'button', NULL, 'Open link', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"70", "size":"24x24"}'::json, '{"saveValue":false, "filterSign":"="}'::json, '{"functionName": "open_selected_path", "parameters":{"targetwidget":"tab_elements_tbl_elements", "columnfind": "link"}}'::json, 'v_edit_arc', false, NULL) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('node', 'form_feature', 'tab_elements', 'btn_link', 'lyt_element_1', 12, NULL, 'button', NULL, 'Open link', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"70", "size":"24x24"}'::json, '{"saveValue":false, "filterSign":"="}'::json, '{"functionName": "open_selected_path", "parameters":{"targetwidget":"tab_elements_tbl_elements", "columnfind": "link"}}'::json, 'v_edit_node', false, NULL) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('connec', 'form_feature', 'tab_elements', 'btn_link', 'lyt_element_1', 12, NULL, 'button', NULL, 'Open link', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"70", "size":"24x24"}'::json, '{"saveValue":false, "filterSign":"="}'::json, '{"functionName": "open_selected_path", "parameters":{"targetwidget":"tab_elements_tbl_elements", "columnfind": "link"}}'::json, 'v_edit_connec', false, NULL) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, "source")
VALUES (3350, 'gw_fct_set_epa_selector', 'utils', 'function', 'json', 'json', 'Function to update tables with new selected values', 'role_basic', 'core');

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, "source")
VALUES (3352, 'gw_fct_get_epa_selector', 'utils', 'function', 'json', 'json', 'Function to get epa selector dialog with filled combos', 'role_basic', 'core');


INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_epa_select_1', 'lyt_epa_select_1', 'layoutEpaSelector1', '{"lytOrientation": "vertical"}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_epa_select_2', 'lyt_epa_select_2', 'layoutEpaSelector2', '{"lytOrientation": "vertical"}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_epa_select_3', 'lyt_epa_select_3', 'layoutEpaSelector3', '{"lytOrientation": "vertical"}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_result_1', 'lyt_result_1', 'layoutResult1', '{"lytOrientation": "vertical"}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_time_1', 'lyt_time_1', 'layoutTime1', '{"lytOrientation": "vertical"}'::json);

INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_result', 'tab_result', 'tabResult', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_time', 'tab_time', 'tabTime', '{
  "lytOrientation": "horizontal"
}'::json);

INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('widgettype_typevalue', 'tabwidget', 'tabwidget', 'tabwidget', NULL);

INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('formtype_typevalue', 'epa_selector', 'epa_selector', 'epaSelector', NULL);

INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('epa_selector', 'tab_result', 'Result', 'Result', 'role_basic', NULL, NULL, 0, '{5}');

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'epa_selector', 'tab_none', 'btn_cancel', 'lyt_buttons', 2, NULL, 'button', NULL, 'Cancel', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
"text": "Cancel"
}'::json, '{
  "functionName": "close_dlg",
  "module": "go2epa_selector_btn"
}'::json, NULL, false, 1);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'epa_selector', 'tab_none', 'btn_accept', 'lyt_buttons', 1, NULL, 'button', NULL, 'Accept', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "text": "Accept"
}'::json, '{
  "functionName": "accept",
  "module": "go2epa_selector_btn"
}'::json, NULL, false, 0);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'epa_selector', 'tab_none', 'spacer', 'lyt_buttons', 0, NULL, 'hspacer', NULL, NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);

INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('epa_selector_tab_result', '{"layouts":["lyt_result_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

-- 28/11/2024
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_epa_mngr_3', 'lyt_epa_mngr_3', 'layoutEpaManager3', '{"lytOrientation": "vertical"}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_epa_mngr_1', 'lyt_epa_mngr_1', 'layoutEpaManager1', '{
  "lytOrientation": "horizontal"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_epa_mngr_2', 'lyt_epa_mngr_2', 'layoutEpaManager2', '{
  "lytOrientation": "horizontal"
}'::json);

INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('formtype_typevalue', 'epa_manager', 'epa_manager', 'epaManager', NULL);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'epa_manager', 'tab_none', 'btn_close', 'lyt_buttons', 1, NULL, 'button', NULL, 'Close', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "text": "Close"
}'::json, '{"functionName": "closeDlg"}'::json, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'epa_manager', 'tab_none', 'txt_info', 'lyt_epa_mngr_1', 1, NULL, 'textarea', 'Info:', 'Table', NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'epa_manager', 'tab_none', 'table_view', 'lyt_epa_mngr_1', 0, NULL, 'tablewidget', '', 'Table', NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'epa_results', false, 0);

INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epamanager_form', 'utils', 'epa_results', 'addparam', NULL, false, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epamanager_form', 'utils', 'epa_results', 'export_options', NULL, false, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epamanager_form', 'utils', 'epa_results', 'id', 0, true, NULL, NULL, NULL, '{
  "accessorKey": "id",
  "header": "result_id",
  "filterVariant": "text",
  "enableSorting": true,
  "enableColumnOrdering": true,
  "enableColumnFilter": true,
  "enableClickToCopy": false
}'::json);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epamanager_form', 'utils', 'epa_results', 'inp_options', NULL, false, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epamanager_form', 'utils', 'epa_results', 'network_stats', NULL, false, NULL, NULL, NULL, NULL);

-- 03/12/2024
UPDATE config_form_fields
	SET widgetfunction='{"functionName": "btn_accept_featuretype_change", "module": "featuretype_change_btn", "parameters": {}}'::json
	WHERE formname='generic' AND formtype='form_featuretype_change' AND columnname='btn_accept' AND tabname='tab_none';
UPDATE config_form_fields
	SET widgetfunction='{"functionName": "btn_cancel_featuretype_change", "module": "featuretype_change_btn", "parameters": {}}'::json
	WHERE formname='generic' AND formtype='form_featuretype_change' AND columnname='btn_cancel' AND tabname='tab_none';
UPDATE config_form_fields
	SET widgetfunction='{"functionName": "btn_catalog_featuretype_change", "module": "featuretype_change_btn", "parameters": {}}'::json
	WHERE formname='generic' AND formtype='form_featuretype_change' AND columnname='btn_catalog' AND tabname='tab_none';
UPDATE config_form_fields
	SET widgetfunction='{"functionName": "cmb_new_featuretype_selection_changed", "module": "featuretype_change_btn", "parameters": {}}'::json
	WHERE formname='generic' AND formtype='form_featuretype_change' AND columnname='feature_type_new' AND tabname='tab_none';

INSERT INTO sys_param_user (id, formname, descript, sys_role, idval, "label", dv_querytext, dv_parent_id, isenabled, layoutorder, project_type, isparent, dv_querytext_filterc, feature_field_id, feature_dv_parent_value, isautoupdate, "datatype", widgettype, ismandatory, widgetcontrols, vdefault, layoutname, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, placeholder, "source") VALUES('epa_maxresults_peruser', 'hidden', 'Limit of maximum number of models for user', 'role_epa', NULL, NULL, NULL, NULL, NULL, NULL, 'utils', NULL, NULL, NULL, NULL, NULL, 'integer', 'text', true, NULL, '20', NULL, NULL, NULL, NULL, NULL, NULL, 'core');

--3/12/24
DELETE FROM sys_table where id = 'v_sector_node';

DELETE FROM config_toolbox WHERE id = 3204;
DELETE FROM sys_function WHERE id = 3204;
DELETE FROM sys_function WHERE id = 3238;
DELETE FROM sys_function WHERE id = 3190;


DELETE FROM sys_table WHERE id = 'node_border_sector';


-- 04/12/2024
INSERT INTO doc (id, "name", doc_type, "path", observ, "date", user_name, tstamp, the_geom)
SELECT id, "name", doc_type, "path", observ, "date", user_name, tstamp, the_geom FROM _doc;

-- 09/12(2024
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('v_edit_link', 'tab_none', NULL, NULL, 'role_basic', NULL, '[
  {
    "actionName": "actionEdit",
    "disabled": false
  }
]'::json, 0, '{4,5}');

DELETE FROM config_fprocess WHERE fid=239 AND tablename='vi_backdrop' AND target='[BACKDROP]';
DELETE FROM config_fprocess WHERE fid=141 AND tablename='vi_t_backdrop' AND target='[BACKDROP]';

-- 10/12/2024
INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, "source")
VALUES (3354, 'gw_fct_getlid', 'ud', 'function', 'json', 'json', 'Function to get lid dialog with filled combos', 'role_basic', 'core');

-- 11/12/24
INSERT INTO config_param_user ("parameter", value, cur_user) VALUES('edit_arc_automatic_link2netowrk', '{"active":"false", "buffer":"10"}', current_user)
ON CONFLICT ("parameter", cur_user) DO NOTHING;

UPDATE sys_message SET log_level=2 WHERE id=3268; --get closest address

-- 12/12/2024
INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, "source")
VALUES (3356, 'gw_trg_cat_material_fk', 'utils', 'trigger', NULL, NULL, 'Control foreign keys created in cat_material', 'role_edit', 'core');

DELETE FROM sys_table WHERE id='cat_mat_node';
DELETE FROM sys_table WHERE id='cat_mat_arc';
DELETE FROM sys_table WHERE id='cat_mat_element';

INSERT INTO sys_table (id, descript, sys_role, criticity, context, orderby, alias, notify_action, isaudit, keepauditdays, "source", addparam)
VALUES('cat_material', 'Catalog of materials.', 'role_edit', 2, '{"level_1":"INVENTORY","level_2":"CATALOGS"}', 7, 'Materials catalog', NULL, NULL, NULL, 'core', NULL);

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, "source")
VALUES (3358, 'gw_fct_admin_transfer_cat_material', 'utils', 'function', NULL, NULL, 'Function to transfer all values from old cat_mat_* tables to new one: cat_material', 'role_edit', 'core');


UPDATE config_form_fields SET dv_querytext='SELECT id, id AS idval FROM cat_material WHERE ''ARC'' = ANY(feature_type) AND id IS NOT NULL' WHERE formname='inp_cat_mat_roughness' AND formtype='form_feature' AND columnname='matcat_id' AND tabname='tab_none';
UPDATE config_form_fields SET dv_querytext='SELECT id, id AS idval FROM cat_material WHERE ''ARC'' = ANY(feature_type) AND id IS NOT NULL' WHERE formname='cat_mat_roughness' AND formtype='form_feature' AND columnname='matcat_id' AND tabname='tab_none';
UPDATE config_form_fields SET dv_querytext='SELECT id, id as idval FROM cat_material WHERE ''ARC'' = ANY(feature_type) AND id IS NOT NULL' WHERE formname='v_edit_review_arc' AND formtype='form_feature' AND columnname='matcat_id' AND tabname='tab_none';
UPDATE config_form_fields SET dv_querytext='SELECT id, id as idval FROM cat_material WHERE ''ARC'' = ANY(feature_type) AND id IS NOT NULL' WHERE formname='v_edit_review_audit_arc' AND formtype='form_feature' AND columnname='old_matcat_id' AND tabname='tab_none';
UPDATE config_form_fields SET dv_querytext='SELECT id, id as idval FROM cat_material WHERE ''ARC'' = ANY(feature_type) AND id IS NOT NULL' WHERE formname='v_edit_review_audit_arc' AND formtype='form_feature' AND columnname='new_matcat_id' AND tabname='tab_none';
UPDATE config_form_fields SET dv_querytext='SELECT id, descript AS idval FROM cat_material WHERE ''ARC'' = ANY(feature_type) AND id IS NOT NULL' WHERE formname='cat_connec' AND formtype='form_feature' AND columnname='matcat_id' AND tabname='tab_none';
UPDATE config_form_fields SET dv_querytext='SELECT id, descript AS idval FROM cat_material WHERE ''ARC'' = ANY(feature_type) AND id IS NOT NULL' WHERE formname='cat_arc' AND formtype='form_feature' AND columnname='matcat_id' AND tabname='tab_none';
UPDATE config_form_fields SET dv_querytext='SELECT id as id, id as idval FROM cat_material WHERE ''ARC'' = ANY(feature_type) AND active' WHERE formname='inp_dscenario_conduit' AND formtype='form_feature' AND columnname='matcat_id' AND tabname='tab_none';
UPDATE config_form_fields SET dv_querytext='SELECT id, id AS idval FROM cat_material WHERE ''ARC'' = ANY(feature_type) AND active' WHERE formname='v_edit_gully' AND formtype='form_feature' AND columnname='connec_matcat_id' AND tabname='tab_data';
UPDATE config_form_fields SET dv_querytext='SELECT id, id AS idval FROM cat_material WHERE ''ARC'' = ANY(feature_type) AND active' WHERE formname='ve_gully' AND formtype='form_feature' AND columnname='connec_matcat_id' AND tabname='tab_data';
UPDATE config_form_fields SET dv_querytext='SELECT id, id AS idval FROM cat_material WHERE ''ARC'' = ANY(feature_type) AND active' WHERE formname='ve_gully_gully' AND formtype='form_feature' AND columnname='connec_matcat_id' AND tabname='tab_data';
UPDATE config_form_fields SET dv_querytext='SELECT id, id AS idval FROM cat_material WHERE ''ARC'' = ANY(feature_type) AND active' WHERE formname='ve_gully_pgully' AND formtype='form_feature' AND columnname='connec_matcat_id' AND tabname='tab_data';
UPDATE config_form_fields SET dv_querytext='SELECT id, id AS idval FROM cat_material WHERE ''ARC'' = ANY(feature_type) AND active' WHERE formname='ve_gully_vgully' AND formtype='form_feature' AND columnname='connec_matcat_id' AND tabname='tab_data';
UPDATE config_form_fields SET dv_querytext='SELECT id as id, id as idval FROM cat_material WHERE ''ARC'' = ANY(feature_type) AND active' WHERE formname='v_edit_inp_dscenario_conduit' AND formtype='form_feature' AND columnname='matcat_id' AND tabname='tab_none';

UPDATE config_form_fields SET dv_querytext='SELECT id, id as idval FROM cat_material WHERE ''NODE'' = ANY(feature_type) AND id IS NOT NULL' WHERE formname='v_edit_review_node' AND formtype='form_feature' AND columnname='matcat_id' AND tabname='tab_none';
UPDATE config_form_fields SET dv_querytext='SELECT id, id as idval FROM cat_material WHERE ''NODE'' = ANY(feature_type) AND id IS NOT NULL' WHERE formname='v_edit_review_audit_node' AND formtype='form_feature' AND columnname='old_matcat_id' AND tabname='tab_none';
UPDATE config_form_fields SET dv_querytext='SELECT id, id as idval FROM cat_material WHERE ''NODE'' = ANY(feature_type) AND id IS NOT NULL' WHERE formname='v_edit_review_audit_node' AND formtype='form_feature' AND columnname='new_matcat_id' AND tabname='tab_none';
UPDATE config_form_fields SET dv_querytext='SELECT id, id as idval FROM cat_material WHERE ''NODE'' = ANY(feature_type) AND id IS NOT NULL' WHERE formname='v_edit_review_connec' AND formtype='form_feature' AND columnname='matcat_id' AND tabname='tab_none';
UPDATE config_form_fields SET dv_querytext='SELECT id, id as idval FROM cat_material WHERE ''NODE'' = ANY(feature_type) AND id IS NOT NULL' WHERE formname='v_edit_review_audit_connec' AND formtype='form_feature' AND columnname='old_matcat_id' AND tabname='tab_none';
UPDATE config_form_fields SET dv_querytext='SELECT id, id as idval FROM cat_material WHERE ''NODE'' = ANY(feature_type) AND id IS NOT NULL' WHERE formname='v_edit_review_audit_connec' AND formtype='form_feature' AND columnname='new_matcat_id' AND tabname='tab_none';
UPDATE config_form_fields SET dv_querytext='SELECT id, descript AS idval FROM cat_material WHERE ''NODE'' = ANY(feature_type) AND id IS NOT NULL' WHERE formname='cat_node' AND formtype='form_feature' AND columnname='matcat_id' AND tabname='tab_none';

UPDATE config_form_fields SET dv_querytext='SELECT id, descript AS idval FROM cat_material WHERE ''ELEMENT'' = ANY(feature_type) AND id IS NOT NULL' WHERE formname='cat_element' AND formtype='form_feature' AND columnname='matcat_id' AND tabname='tab_none';

UPDATE config_form_fields SET dv_querytext='SELECT id, id as idval FROM cat_material WHERE ''GULLY'' = ANY(feature_type) AND id IS NOT NULL' WHERE formname='v_edit_review_gully' AND formtype='form_feature' AND columnname='matcat_id' AND tabname='tab_none';
UPDATE config_form_fields SET dv_querytext='SELECT id, id as idval FROM cat_material WHERE ''GULLY'' = ANY(feature_type) AND id IS NOT NULL' WHERE formname='v_edit_review_audit_gully' AND formtype='form_feature' AND columnname='old_matcat_id' AND tabname='tab_none';
UPDATE config_form_fields SET dv_querytext='SELECT id, id as idval FROM cat_material WHERE ''GULLY'' = ANY(feature_type) AND id IS NOT NULL' WHERE formname='v_edit_review_audit_gully' AND formtype='form_feature' AND columnname='new_matcat_id' AND tabname='tab_none';
UPDATE config_form_fields SET dv_querytext='SELECT id, descript AS idval FROM cat_material WHERE ''GULLY'' = ANY(feature_type) AND id IS NOT NULL' WHERE formname='cat_grate' AND formtype='form_feature' AND columnname='matcat_id' AND tabname='tab_none';

UPDATE config_form_fields SET widgetcontrols = replace(widgetcontrols::TEXT, 'cat_mat_arc', 'cat_material')::json WHERE widgetcontrols::TEXT ILIKE '%cat_mat_arc%';
UPDATE config_form_fields SET widgetcontrols = replace(widgetcontrols::TEXT, 'cat_mat_node', 'cat_material')::json WHERE widgetcontrols::TEXT ILIKE '%cat_mat_node%';
UPDATE config_form_fields SET widgetcontrols = replace(widgetcontrols::TEXT, 'cat_mat_grate', 'cat_material')::json WHERE widgetcontrols::TEXT ILIKE '%cat_mat_grate%';
UPDATE config_form_fields SET widgetcontrols = replace(widgetcontrols::TEXT, 'cat_mat_gully', 'cat_material')::json WHERE widgetcontrols::TEXT ILIKE '%cat_mat_gully%';
UPDATE config_form_fields SET widgetcontrols = replace(widgetcontrols::TEXT, 'cat_mat_connec', 'cat_material')::json WHERE widgetcontrols::TEXT ILIKE '%cat_mat_connec%';
UPDATE config_form_fields SET widgetcontrols = replace(widgetcontrols::TEXT, 'cat_mat_element', 'cat_material')::json WHERE widgetcontrols::TEXT ILIKE '%cat_mat_element%';


INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source")
VALUES(3360, 'gw_fct_create_thyssen_subcatchments', 'ud', 'function', 'json', 'json', 'Calculate subcatchment parameters.', 'role_epa', NULL, 'core');

-- 18/12/2024
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_dscenario_mngr_2', 'lyt_dscenario_mngr_2', 'layoutDscenarioManager2', '{"lytOrientation": "vertical"}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_dscenario_mngr_3', 'lyt_dscenario_mngr_3', 'layoutDscenarioManager3', '{"lytOrientation": "vertical"}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_dscenario_mngr_1', 'lyt_dscenario_mngr_1', 'layoutDscenarioManager1', '{
  "lytOrientation": "horizontal"
}'::json);

INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('formtype_typevalue', 'dscenario_manager', 'dscenario_manager', 'dscenarioManager', NULL);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'dscenario_manager', 'tab_none', 'chk_show_inactive', 'lyt_dscenario_mngr_1', 0, 'boolean', 'check', 'Show inactive', 'Show inactive', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "functionName": "showInactive"
}'::json, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'dscenario_manager', 'tab_none', 'spacer_1', 'lyt_dscenario_mngr_1', 1, NULL, 'hspacer', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'dscenario_manager', 'tab_none', 'btn_close', 'lyt_buttons', 1, NULL, 'button', NULL, 'Close', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "text": "Close"
}'::json, '{"functionName": "close_dlg"}'::json, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'dscenario_manager', 'tab_none', 'table_view', 'lyt_dscenario_mngr_2', 0, NULL, 'tablewidget', '', 'Table', NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'dscenario_results', false, 0);

INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('dscenariomanager_form', 'utils', 'dscenario_results', 'active', 6, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('dscenariomanager_form', 'utils', 'dscenario_results', 'descript', 2, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('dscenariomanager_form', 'utils', 'dscenario_results', 'dscenario_type', 3, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('dscenariomanager_form', 'utils', 'dscenario_results', 'expl_id', 5, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('dscenariomanager_form', 'utils', 'dscenario_results', 'id', 0, true, NULL, NULL, NULL, '{
  "header": "dscenario_id",
  "accessorKey": "id"
}'::json);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('dscenariomanager_form', 'utils', 'dscenario_results', 'log', 7, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('dscenariomanager_form', 'utils', 'dscenario_results', 'name', 1, true, NULL, NULL, NULL, '{
  "accessorKey": "name",
  "header": "name",
  "filterVariant": "text",
  "enableSorting": true,
  "enableColumnOrdering": true,
  "enableColumnFilter": true,
  "enableClickToCopy": false
}'::json);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('dscenariomanager_form', 'utils', 'dscenario_results', 'parent_id', 4, true, NULL, NULL, NULL, NULL);

INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_dscenario_2', 'lyt_dscenario_2', 'layoutDscenario2', '{"lytOrientation": "vertical"}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_dscenario_3', 'lyt_dscenario_3', 'layoutDscenario3', '{"lytOrientation": "vertical"}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_dscenario_1', 'lyt_dscenario_1', 'layoutDscenario1', '{"lytOrientation": "vertical"}'::json);

INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('formtype_typevalue', 'dscenario', 'dscenario', 'dscenario', NULL);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'dscenario', 'tab_none', 'btn_close', 'lyt_buttons', 1, NULL, 'button', NULL, 'Close', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "text": "Close"
}'::json, '{
  "functionName": "close_dlg"
}'::json, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'dscenario', 'tab_none', 'spacer', 'lyt_buttons', 0, NULL, 'hspacer', NULL, NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 0);


--18/12/2024

ALTER TABLE IF EXISTS config_style ADD CONSTRAINT idval_chk UNIQUE (idval);

-- 20/12/2024
UPDATE sys_param_user SET id='plan_psector_current' WHERE id='plan_psector_vdefault';

-- 26/12/2024
INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source")
VALUES(3362, 'gw_fct_create_logtables', 'utils', 'function', 'json', 'json', 'Create temporal tables for check process.', 'role_basic', NULL, 'core');

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source")
VALUES(3364, 'gw_fct_setcheckdatabase', 'utils', 'function', 'json', 'json', 'Check database exceptions.', 'role_basic', NULL, 'core');

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source")
VALUES(3366, 'gw_fct_create_logreturn', 'utils', 'function', 'json', 'json', 'Create log return for check functions.', 'role_basic', NULL, 'core');

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source")
VALUES(3368, 'gw_fct_create_querytables', 'utils', 'function', 'json', 'json', 'Create temporal tables for check process.', 'role_basic', NULL, 'core');

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source")
VALUES(3370, 'gw_fct_create_return', 'utils', 'function', 'json', 'json', 'Create return for all fucntions.', 'role_basic', NULL, 'core');

DELETE FROM sys_param_user where id='utils_checkproject_database';
DELETE FROM sys_param_user where id='utils_checkproject_qgislayer';
DELETE FROM sys_param_user where id='qgis_form_initproject_hidden';

UPDATE config_param_system SET value = '
{"omCheck":true, "graphCheck":false, "epaCheck":false, "planCheck":false, "adminCheck":false, "verifiedExceptions":false}'
WHERE parameter = 'admin_checkproject';

UPDATE sys_function SET project_type = 'utils' WHERE id = 2430;

-- 16/01/2025
UPDATE config_form_fields
	SET stylesheet='{"icon":"173"}'::json
	WHERE formtype='form_feature' AND columnname='btn_link' AND tabname='tab_elements';

-- 21/01/2025
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam)
VALUES('layout_name_typevalue', 'lyt_workspace_mngr_3', 'lyt_workspace_mngr_3', 'layoutWorkspaceManager3', '{"lytOrientation": "vertical"}'::json);

INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam)
VALUES('layout_name_typevalue', 'lyt_workspace_mngr_1', 'lyt_workspace_mngr_1', 'layoutWorkspaceManager1', '{
"lytOrientation": "horizontal"
}'::json);

INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam)
VALUES('layout_name_typevalue', 'lyt_workspace_mngr_2', 'lyt_workspace_mngr_2', 'layoutWorkspaceManager2', '{
"lytOrientation": "horizontal"
}'::json);

INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam)
VALUES('formtype_typevalue', 'workspace_manager', 'workspace_manager', 'workspaceManager', NULL);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('generic', 'workspace_manager', 'tab_none', 'btn_close', 'lyt_buttons', 1, NULL, 'button', NULL, 'Close', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
"text": "Close"
}'::json, '{"functionName": "closeDlg"}'::json, NULL, false, 0);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('generic', 'workspace_manager', 'tab_none', 'txt_info', 'lyt_workspace_mngr_1', 1, NULL, 'textarea', 'Info:', 'Table', NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 0);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('generic', 'workspace_manager', 'tab_none', 'table_view', 'lyt_workspace_mngr_1', 0, NULL, 'tablewidget', '', 'Table', NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'workspace_results', false, 0);

INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('tbl_workspace_manager', 'SELECT id, "name", private::text, descript, config::text FROM v_ui_workspace', 5, 'tab', 'list', '{"orderBy":"1", "orderType": "ASC"}'::json, '{
"enableGlobalFilter": false,
"enableStickyHeader": true,
"positionToolbarAlertBanner": "bottom",
"enableGrouping": false,
"enablePinning": true,
"enableColumnOrdering": true,
"enableColumnFilterModes": true,
"enableFullScreenToggle": false,
"enablePagination": true,
"enableExporting": true,
"muiTablePaginationProps": {
"rowsPerPageOptions": [
5,
10,
15,
20,
50,
100
],
"showFirstButton": true,
"showLastButton": true
},
"enableRowSelection": true,
"multipleRowSelection": true,
"initialState": {
"showColumnFilters": false,
"pagination": {
"pageSize": 5,
"pageIndex": 0
},
"density": "compact",
"columnFilters": [
{
"id": "id",
"value": "",
"filterVariant": "text"
}
],
"sorting": [
{
"id": "id",
"desc": false
}
]
},
"modifyTopToolBar": true,
"renderTopToolbarCustomActions": [
{
"widgetfunction": {
"functionName": "setCurrent",
"params": {}
},
"color": "default",
"text": "Set Current",
"disableOnSelect": true,
"moreThanOneDisable": true
},
{
"widgetfunction": {
"functionName": "togglePrivacy",
"params": {}
},
"color": "default",
"text": "Toggle privacy",
"disableOnSelect": true,
"moreThanOneDisable": false
},
{
"widgetfunction": {
"functionName": "create",
"params": {}
},
"color": "success",
"text": "Create",
"disableOnSelect": false,
"moreThanOneDisable": false
},
{
"widgetfunction": {
"functionName": "edit",
"params": {}
},
"color": "info",
"text": "Edit",
"disableOnSelect": true,
"moreThanOneDisable": true
},
{
"widgetfunction": {
"functionName": "delete",
"params": {}
},
"color": "error",
"text": "Delete",
"disableOnSelect": true,
"moreThanOneDisable": false
}
],
"enableRowActions": false,
"renderRowActionMenuItems": [
{
"widgetfunction": {
"functionName": "open",
"params": {}
},
"icon": "OpenInBrowser",
"text": "Open"
}
]
}'::json);

INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('workspace_form', 'utils', 'tbl_workspace_manager', 'id', 0, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('workspace_form', 'utils', 'tbl_workspace_manager', 'name', 1, true, NULL, NULL, NULL, '{
"accessorKey": "name",
"header": "Name",
"filterVariant": "text",
"enableSorting": true,
"enableColumnOrdering": true,
"enableColumnFilter": true,
"enableClickToCopy": false
}'::json);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('workspace_form', 'utils', 'tbl_workspace_manager', 'private', 2, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('workspace_form', 'utils', 'tbl_workspace_manager', 'descript', 3, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('workspace_form', 'utils', 'tbl_workspace_manager', 'config', 4, false, NULL, NULL, NULL, NULL);

INSERT INTO config_typevalue (typevalue,id,idval,camelstyle,addparam)
VALUES ('layout_name_typevalue','lyt_workspace_open_1','lyt_workspace_open_1','layoutWorkspaceOpen1','{
"lytOrientation": "vertical"
}'::json);

INSERT INTO config_typevalue (typevalue,id,idval,camelstyle)
VALUES ('formtype_typevalue','workspace_open','workspace_open','workspaceOpen');

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'workspace_open', 'tab_none', 'name', 'lyt_workspace_open_1', 0, NULL, 'text', 'Workspace name: ', NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'workspace_open', 'tab_none', 'private', 'lyt_workspace_open_1', 2, NULL, 'check', 'Private Workspace:', NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 2);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'workspace_open', 'tab_none', 'descript', 'lyt_workspace_open_1', 1, NULL, 'textarea', 'Description: ', NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'workspace_open', 'tab_none', 'btn_accept', 'lyt_buttons', 0, NULL, 'button', '', NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
"text": "Save"
}'::json, '{
"functionName": "saveFeat"
}'::json, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'workspace_open', 'tab_none', 'btn_close', 'lyt_buttons', 1, NULL, 'button', '', NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
"text": "Close"
}'::json, '{
"functionName": "closeDlg"
}'::json, NULL, false, 0);

-- 23/01/2025
INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source") VALUES(3374, 'gw_fct_featurechanges', 'utils', 'function', 'json', 'json', 'Upsert assets in gis', 'role_basic', NULL, 'core');


UPDATE config_form_fields
	SET widgetcontrols='{"saveValue":false, "filterSign":"=", "onContextMenu":"Open element"}'::json
	WHERE formtype='form_feature' AND columnname='open_element' AND tabname='tab_elements';

UPDATE config_form_fields
	SET widgetcontrols='{"saveValue":false, "filterSign":"=", "onContextMenu":"Open link"}'::json
	WHERE formtype='form_feature' AND columnname='btn_link' AND tabname='tab_elements';

UPDATE config_form_fields
	SET widgetcontrols='{"saveValue":false, "filterSign":"=", "onContextMenu":"Delete element"}'::json
	WHERE formtype='form_feature' AND columnname='delete_element' AND tabname='tab_elements';

UPDATE config_form_fields
	SET widgetcontrols='{"onContextMenu":"Open gallery"}'::json
	WHERE formtype='form_feature' AND columnname='btn_open_gallery' AND tabname='tab_event';

UPDATE config_form_fields
	SET widgetcontrols='{"saveValue":false, "filterSign":"=", "onContextMenu":"Open visit event"}'::json
	WHERE formtype='form_feature' AND columnname='btn_open_visit_event' AND tabname='tab_event';

UPDATE config_form_fields
	SET widgetcontrols='{"saveValue":false, "filterSign":"=", "onContextMenu":"Open visit document"}'::json
	WHERE formtype='form_feature' AND columnname='btn_open_visit_doc' AND tabname='tab_event';

UPDATE config_form_fields
	SET widgetcontrols='{"saveValue":false, "filterSign":"=", "onContextMenu":"Delete document"}'::json
	WHERE formtype='form_feature' AND columnname='btn_doc_delete' AND tabname='tab_documents';

UPDATE config_form_fields
	SET widgetcontrols='{"saveValue":false, "filterSign":"=", "onContextMenu":"Open document"}'::json
	WHERE formtype='form_feature' AND columnname='open_doc' AND tabname='tab_documents';

UPDATE config_form_fields
	SET widgetcontrols='{"saveValue":false, "onContextMenu":"Edit dscenario"}'::json
	WHERE formtype='form_feature' AND tabname='tab_epa' AND columnname='edit_dscenario';

UPDATE config_form_fields
	SET widgetcontrols='{"saveValue":false, "onContextMenu":"Delete dscenario"}'::json
	WHERE formtype='form_feature' AND tabname='tab_epa' AND columnname='remove_from_dscenario';

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source") VALUES(3376, 'gw_fct_getwidgets_checkproject', 'utils', 'function', 'json', 'json', 'Set widgets to show in check project button according to user''s role.', 'role_basic', NULL, 'core');

-- 29/01/2025
UPDATE config_form_tabs SET device='{4,5}' WHERE formname='selector_basic' AND tabname='tab_sector';

INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('formtype_typevalue', 'check_project', 'check_project', 'checkProject', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_log', 'tab_log', 'tabLog', NULL);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'check_project', 'tab_log', 'txt_infolog', 'lyt_data_2', 0, NULL, 'textarea', NULL, NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'check_project', 'tab_data', 'om_check', 'lyt_data_1', 1, NULL, 'check', 'Check om data:', NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"minRole": "role_basic"}'::json, NULL, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'check_project', 'tab_data', 'epa_check', 'lyt_data_1', 2, NULL, 'check', 'Check EPA data:', NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"minRole": "role_epa"}'::json, NULL, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'check_project', 'tab_data', 'plan_check', 'lyt_data_1', 3, NULL, 'check', 'Check plan data:', NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"minRole": "role_plan"}'::json, NULL, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'check_project', 'tab_data', 'admin_check', 'lyt_data_1', 4, NULL, 'check', 'Check admin data:', NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"minRole": "role_admin"}'::json, NULL, NULL, false, 1);

UPDATE config_form_fields SET columnname='conneccat_id' WHERE formname='v_edit_link' AND formtype='form_feature' AND columnname='connecat_id' AND tabname='tab_none';


-- 31/01/2025
INSERT INTO sys_function
(id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source")
VALUES(3380, 'gw_fct_getlayerstofilter', 'utils', 'function', 'json', 'json', 'Function to filter WMS layers with imported columns', 'role_basic', NULL, 'core');

-- 05/02/2025
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('formtype_typevalue', 'psector_manager', 'psector_manager', 'psectorManager', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_psector_mngr_1', 'lyt_psector_mngr_1', 'layoutPsectorManager1', '{
  "lytOrientation": "horizontal"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_psector_mngr_2', 'lyt_psector_mngr_2', 'layoutPsectorManager2', '{
  "lytOrientation": "horizontal"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_psector_mngr_3', 'lyt_psector_mngr_3', 'layoutPsectorManager3', '{
  "lytOrientation": "horizontal"
}'::json);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector_manager', 'tab_none', 'btn_close', 'lyt_buttons', 1, NULL, 'button', NULL, 'Close', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "text": "Close"
}'::json, '{"functionName": "closeDlg"}'::json, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector_manager', 'tab_none', 'chk_show_inactive', 'lyt_psector_mngr_1', 0, 'boolean', 'check', 'Show inactive', 'Show inactive', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "functionName": "showInactive"
}'::json, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector_manager', 'tab_none', 'spacer_1', 'lyt_psector_mngr_1', 1, NULL, 'hspacer', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector_manager', 'tab_none', 'table_view', 'lyt_psector_mngr_2', 0, NULL, 'tablewidget', '', 'Table', NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'psector_results', false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector_manager', 'tab_none', 'txt_info', 'lyt_psector_mngr_2', 1, NULL, 'textarea', 'Info:', 'Table', NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 0);

INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('psector_results', 'SELECT psector_id AS id, ext_code, name, descript, priority, status, text1, text2, observ, vat, other, expl_id, psector_type, active::text, workcat_id, parent_id FROM plan_psector WHERE psector_id IS NOT NULL', 5, 'tab', 'list', '{"orderBy":"1", "orderType": "ASC"}'::json, '{
  "enableGlobalFilter": false,
  "enableStickyHeader": true,
  "positionToolbarAlertBanner": "bottom",
  "enableGrouping": false,
  "enablePinning": true,
  "enableColumnOrdering": true,
  "enableColumnFilterModes": true,
  "enableFullScreenToggle": false,
  "enablePagination": true,
  "enableExporting": true,
  "muiTablePaginationProps": {
    "rowsPerPageOptions": [
      5,
      10,
      15,
      20,
      50,
      100
    ],
    "showFirstButton": true,
    "showLastButton": true
  },
  "enableRowSelection": true,
  "multipleRowSelection": true,
  "initialState": {
    "showColumnFilters": false,
    "pagination": {
      "pageSize": 5,
      "pageIndex": 0
    },
    "density": "compact",
    "columnFilters": [
      {
        "id": "id",
        "value": "",
        "filterVariant": "text"
      }
    ],
    "sorting": [
      {
        "id": "name",
        "desc": false
      }
    ]
  },
  "modifyTopToolBar": true,
  "renderTopToolbarCustomActions": [
    {
      "name": "btn_show_psector",
      "widgetfunction": {
        "functionName": "showPsector",
        "params": {}
      },
      "color": "default",
      "text": "Show psector",
      "disableOnSelect": true,
      "moreThanOneDisable": false
    }
  ],
  "enableRowActions": false,
  "renderRowActionMenuItems": [
    {
      "widgetfunction": {
        "functionName": "open",
        "params": {}
      },
      "icon": "OpenInBrowser",
      "text": "Open"
    }
  ]
}'::json);


-- 06/02/2025
UPDATE config_form_fields
	SET widgetcontrols='{"saveValue":false, "filterSign":"=", "onContextMenu":"Open link"}'::json
	WHERE formname='connec' AND formtype='form_feature' AND columnname='btn_link' AND tabname='tab_hydrometer';

-- edit_typevalue
INSERT INTO edit_typevalue (typevalue, id, idval, descript, addparam) VALUES('value_datasource', '0', 'UNKNOWN', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO edit_typevalue (typevalue, id, idval, descript, addparam) VALUES('value_datasource', '1', 'GMAO', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO edit_typevalue (typevalue, id, idval, descript, addparam) VALUES('value_datasource', '2', 'CRM', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO edit_typevalue (typevalue, id, idval, descript, addparam) VALUES('value_datasource', '3', 'DEM', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO edit_typevalue (typevalue, id, idval, descript, addparam) VALUES('value_datasource', '4', 'TOPO', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;

-- 07/02/2025
INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source")
VALUES (3382, 'gw_fct_import_epanet_nodarcs', 'ws', 'function', 'json', 'json', 'Function to manage nodarcs after importing INP file', 'role_epa', NULL, 'core');

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source")
VALUES (3384, 'gw_fct_import_swmm_flwreg', 'ud', 'function', 'json', 'json', 'Function to manage nodarcs after importing INP file', 'role_epa', NULL, 'core');

-- 10/02/2025
UPDATE config_form_list SET listname='v_ui_hydrometer' WHERE listname='tbl_hydrometer';

UPDATE config_form_fields SET dv_querytext='SELECT id, id AS idval FROM inp_curve WHERE id IS NOT NULL AND curve_type = ''STORAGE'''
WHERE formname='ve_epa_storage' AND formtype='form_feature' AND columnname='curve_id' AND tabname='tab_epa';

UPDATE config_form_fields SET dv_querytext='SELECT id, id AS idval FROM inp_curve WHERE id IS NOT NULL AND curve_type IN (''PUMP'', ''PUMP1'', ''PUMP2'', ''PUMP3'', ''PUMP4'')'
WHERE formname='ve_epa_pump' AND formtype='form_feature' AND columnname='curve_id' AND tabname='tab_epa';

UPDATE config_form_list SET query_text='SELECT * FROM v_ui_doc_x_node WHERE node_id IS NOT NULL', vdefault=NULL WHERE listname='tbl_doc_x_node' AND device=4;
UPDATE config_form_list SET query_text='SELECT * FROM v_ui_doc_x_arc WHERE arc_id IS NOT NULL', vdefault=NULL WHERE listname='tbl_doc_x_arc' AND device=4;
UPDATE config_form_list SET query_text='SELECT * FROM v_ui_doc_x_connec WHERE connec_id IS NOT NULL', vdefault=NULL WHERE listname='tbl_doc_x_connec' AND device=4;
UPDATE config_form_list SET query_text='SELECT * FROM v_ui_doc_x_gully WHERE gully_id IS NOT NULL', vdefault=NULL WHERE listname='tbl_doc_x_gully' AND device=4;

UPDATE config_form_list SET query_text='SELECT * FROM v_ui_element_x_arc WHERE arc_id IS NOT NULL', vdefault=NULL WHERE listname='tbl_element_x_arc' AND device=4;
UPDATE config_form_list SET query_text='SELECT * FROM v_ui_element_x_node WHERE node_id IS NOT NULL', vdefault=NULL WHERE listname='tbl_element_x_node' AND device=4;
UPDATE config_form_list SET query_text='SELECT * FROM v_ui_element_x_connec WHERE connec_id IS NOT NULL', vdefault=NULL WHERE listname='tbl_element_x_connec' AND device=4;
UPDATE config_form_list SET query_text='SELECT * FROM v_ui_element_x_gully WHERE gully_id IS NOT NULL', vdefault=NULL WHERE listname='tbl_element_x_gully' AND device=4;

UPDATE config_form_list SET query_text='SELECT * FROM v_ui_element_x_arc WHERE arc_id IS NOT NULL', vdefault=NULL WHERE listname='v_ui_element_x_arc' AND device=3;

-- 11/02/2025
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_log_1', 'lyt_log_1', 'lytLog1', NULL) ON CONFLICT DO NOTHING;
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_data_4', 'lyt_data_4', 'layoutData4', '{"createAddfield":"TRUE"}'::json);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'check_project', 'tab_data', 'versions_check', 'lyt_data_1', 1, NULL, 'check', 'Versions', NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'check_project', 'tab_data', 'graph_check', 'lyt_data_3', 2, NULL, 'check', 'Check graph data:', NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"minRole": "role_basic"}'::json, NULL, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'check_project', 'tab_data', 'qgisproj_check', 'lyt_data_1', 2, NULL, 'check', 'Qgis Project', NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'check_project', 'tab_data', 'Info:', 'lyt_data_4', 0, NULL, 'textarea', NULL, NULL, NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "vdefault_value": "This function verifies both the project and the database. For the database verification, all objects selected by the user through their sector and exploitation selector are checked."
}'::json, NULL, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'check_project', 'tab_data', 'verified_exceptions', 'lyt_data_2', 0, NULL, 'check', 'Ignore verified exception:', NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"minRole": "role_basic"}'::json, NULL, NULL, false, 1);
UPDATE config_form_fields SET layoutname='lyt_data_3', layoutorder=1, "datatype"=NULL, widgettype='check', "label"='Check om data:', tooltip=NULL, placeholder=NULL, ismandatory=false, isparent=false, iseditable=true, isautoupdate=false, isfilter=NULL, dv_querytext=NULL, dv_orderby_id=NULL, dv_isnullvalue=NULL, dv_parent_id=NULL, dv_querytext_filterc=NULL, stylesheet=NULL, widgetcontrols='{"minRole": "role_basic"}'::json, widgetfunction=NULL, linkedobject=NULL, hidden=false, web_layoutorder=1 WHERE formname='generic' AND formtype='check_project' AND columnname='om_check' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_3', layoutorder=2, "datatype"=NULL, widgettype='check', "label"='Check graph data:', tooltip=NULL, placeholder=NULL, ismandatory=false, isparent=false, iseditable=true, isautoupdate=false, isfilter=NULL, dv_querytext=NULL, dv_orderby_id=NULL, dv_isnullvalue=NULL, dv_parent_id=NULL, dv_querytext_filterc=NULL, stylesheet=NULL, widgetcontrols='{"minRole": "role_basic"}'::json, widgetfunction=NULL, linkedobject=NULL, hidden=false, web_layoutorder=1 WHERE formname='generic' AND formtype='check_project' AND columnname='graph_check' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_3', layoutorder=3, "datatype"=NULL, widgettype='check', "label"='Check EPA data:', tooltip=NULL, placeholder=NULL, ismandatory=false, isparent=false, iseditable=true, isautoupdate=false, isfilter=NULL, dv_querytext=NULL, dv_orderby_id=NULL, dv_isnullvalue=NULL, dv_parent_id=NULL, dv_querytext_filterc=NULL, stylesheet=NULL, widgetcontrols='{"minRole": "role_epa"}'::json, widgetfunction=NULL, linkedobject=NULL, hidden=false, web_layoutorder=1 WHERE formname='generic' AND formtype='check_project' AND columnname='epa_check' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_3', layoutorder=4, "datatype"=NULL, widgettype='check', "label"='Check plan data:', tooltip=NULL, placeholder=NULL, ismandatory=false, isparent=false, iseditable=true, isautoupdate=false, isfilter=NULL, dv_querytext=NULL, dv_orderby_id=NULL, dv_isnullvalue=NULL, dv_parent_id=NULL, dv_querytext_filterc=NULL, stylesheet=NULL, widgetcontrols='{
  "minRole": "role_master"
}'::json, widgetfunction=NULL, linkedobject=NULL, hidden=false, web_layoutorder=1 WHERE formname='generic' AND formtype='check_project' AND columnname='plan_check' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_3', layoutorder=5, "datatype"=NULL, widgettype='check', "label"='Check admin data:', tooltip=NULL, placeholder=NULL, ismandatory=false, isparent=false, iseditable=true, isautoupdate=false, isfilter=NULL, dv_querytext=NULL, dv_orderby_id=NULL, dv_isnullvalue=NULL, dv_parent_id=NULL, dv_querytext_filterc=NULL, stylesheet=NULL, widgetcontrols='{"minRole": "role_admin"}'::json, widgetfunction=NULL, linkedobject=NULL, hidden=false, web_layoutorder=1 WHERE formname='generic' AND formtype='check_project' AND columnname='admin_check' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_log_1', layoutorder=0, "datatype"=NULL, widgettype='textarea', "label"=NULL, tooltip=NULL, placeholder=NULL, ismandatory=false, isparent=false, iseditable=true, isautoupdate=false, isfilter=NULL, dv_querytext=NULL, dv_orderby_id=NULL, dv_isnullvalue=NULL, dv_parent_id=NULL, dv_querytext_filterc=NULL, stylesheet=NULL, widgetcontrols=NULL, widgetfunction=NULL, linkedobject=NULL, hidden=false, web_layoutorder=1 WHERE formname='generic' AND formtype='check_project' AND columnname='txt_infolog' AND tabname='tab_log';

-- 12/02/2025
INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source")
VALUES (3386, 'gw_fct_manage_relations', 'utils', 'function', 'json', 'json', 'Function to manage relations between elements and documents', 'role_edit', NULL, 'core');

UPDATE sys_message
SET error_message = 'The inserted catalog value does not exist --> %catalog_value%'
WHERE id = 3282;

UPDATE sys_fprocess SET fprocess_name='EPA connec over EPA node (goe2pa)', project_type='ws', parameters=NULL, "source"='core', isaudit=true, fprocess_type='Check epa-result', addparam=NULL, except_level=3, except_msg='EPA connecs over EPA nodes', except_table='anl_connec', except_table_msg=NULL, query_text='	SELECT connec_id, conneccat_id, expl_id, the_geom FROM (
	SELECT DISTINCT t2.connec_id, t2.conneccat_id , t2.expl_id, t1.the_geom, st_distance(t1.the_geom, t2.the_geom) as dist, t1.state as state1, t2.state as state2 
	FROM v_edit_node AS t1 JOIN v_edit_connec AS t2 ON ST_Dwithin(t1.the_geom, t2.the_geom, 0.1) 
	WHERE t1.epa_type != ''UNDEFINED''
	AND t2.epa_type = ''JUNCTION'') a 
    WHERE a.state1 > 0 AND a.state2 > 0 ', info_msg='No EPA connecs over EPA node have been detected.', function_name='[gw_fct_pg2epa_check_networkmode_connec]', active=false WHERE fid=413;

-- 17/02/2025
UPDATE sys_message
SET error_message = 'Cannot do this operation because the lock level is set to %lock_level%',
    hint_message = 'Please review the lock level'
WHERE id = 3284;

-- edit_typevalue
INSERT INTO edit_typevalue (typevalue, id, idval, descript, addparam) VALUES('value_lock_level', '0', 'ALLOW EVERYTHING', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO edit_typevalue (typevalue, id, idval, descript, addparam) VALUES('value_lock_level', '1', 'BLOCK UPDATE', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO edit_typevalue (typevalue, id, idval, descript, addparam) VALUES('value_lock_level', '2', 'BLOCK DELETE', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO edit_typevalue (typevalue, id, idval, descript, addparam) VALUES('value_lock_level', '3', 'BLOCK UPDATE AND DELETE', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;

-- 19/02/2025
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_add_info_1', 'lyt_add_info_1', 'layoutAddInfo1', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_budget_1', 'lyt_budget_1', 'layoutBudget1', '{
  "lytOrientation": "horizontal"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_budget_10', 'lyt_budget_10', 'layoutBudget10', '{
  "lytOrientation": "horizontal"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_budget_11', 'lyt_budget_11', 'layoutBudget11', '{
  "lytOrientation": "horizontal"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_budget_12', 'lyt_budget_12', 'layoutBudget12', '{
  "lytOrientation": "horizontal"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_budget_13', 'lyt_budget_13', 'layoutBudget13', '{
  "lytOrientation": "horizontal"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_budget_2', 'lyt_budget_2', 'layoutBudget2', '{
  "lytOrientation": "horizontal"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_budget_3', 'lyt_budget_3', 'layoutBudget3', '{
  "lytOrientation": "horizontal"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_budget_4', 'lyt_budget_4', 'layoutBudget4', '{
  "lytOrientation": "vertical"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_budget_5', 'lyt_budget_5', 'layoutBudget5', '{
  "lytOrientation": "horizontal"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_budget_6', 'lyt_budget_6', 'layoutBudget6', '{
  "lytOrientation": "horizontal"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_budget_7', 'lyt_budget_7', 'layoutBudget7', '{
  "lytOrientation": "horizontal"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_budget_8', 'lyt_budget_8', 'layoutBudget8', '{
  "lytOrientation": "vertical"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_budget_9', 'lyt_budget_9', 'layoutBudge9', '{
  "lytOrientation": "horizontal"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_general_1', 'lyt_general_1', 'layoutGeneral1', '{
  "lytOrientation": "horizontal"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_general_2', 'lyt_general_2', 'layoutGeneral2', '{
  "lytOrientation": "horizontal"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_general_3', 'lyt_general_3', 'layoutGeneral3', '{
  "lytOrientation": "horizontal"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_general_4', 'lyt_general_4', 'layoutGeneral4', '{
  "lytOrientation": "horizontal"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_general_5', 'lyt_general_5', 'layoutGeneral5', '{
  "lytOrientation": "horizontal"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_general_6', 'lyt_general_6', 'layoutGeneral6', '{
  "lytOrientation": "vertical"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_general_7', 'lyt_general_7', 'layoutGeneral7', '{
  "lytOrientation": "horizontal"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_general_8', 'lyt_general_8', 'layoutGeneral8', '{
  "lytOrientation": "horizontal"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_other_prices_1', 'lyt_other_prices_1', 'layoutOtherPrices1', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_psector_1', 'lyt_psector_1', 'layoutPsector1', '{
  "lytOrientation": "horizontal"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_psector_2', 'lyt_psector_2', 'layoutPsector2', '{
  "lytOrientation": "vertical"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_psector_3', 'lyt_psector_3', 'layoutPsector3', '{
  "lytOrientation": "vertical"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_relations_1', 'lyt_relations_1', 'layoutRelations1', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_relations_arc_1', 'lyt_relations_arc_1', 'layoutRelationsArc1', '{
  "lytOrientation": "horizontal"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_relations_connec_1', 'lyt_relations_connec_1', 'layoutRelationsConnec1', '{
  "lytOrientation": "horizontal"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_relations_node_1', 'lyt_relations_node_1', 'layoutRelationsNode1', '{
  "lytOrientation": "horizontal"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('formtype_typevalue', 'psector', 'psector', 'psector', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_add_info', 'tab_add_info', 'tabAddInfo', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_budget', 'tab_budget', 'tabBudget', '{
  "lytOrientation": "vertical"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_document', 'tab_document', 'tabDocument', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_general', 'tab_general', 'tabGeneral', '{
  "lytOrientation": "vertical"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_other_prices', 'tab_other_prices', 'tabOtherPrices', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_relations_arc', 'tab_relations_arc', 'tabRelationsArc', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_relations_connec', 'tab_relations_connec', 'tabRelationsConnec', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_relations_node', 'tab_relations_node', 'tabRelationsNode', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_other_prices_all', 'tab_other_prices_all', 'tabOtherPricesAll', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_other_prices_mine', 'tab_other_prices_mine', 'tabOtherPricesMine', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_other_prices_all_1', 'lyt_other_prices_all_1', 'layoutOtherPricesAll1', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_other_prices_mine_1', 'lyt_other_prices_mine_1', 'layoutOtherPricesMine1', NULL);

INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('psector', 'tab_relations_node', 'Node', 'Node', 'role_basic', NULL, NULL, 0, '{5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('psector', 'tab_relations_connec', 'Connec', 'Connec', 'role_basic', NULL, NULL, 0, '{5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('psector', 'tab_add_info', 'Additional info', 'Additional info', 'role_basic', NULL, NULL, 0, '{5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('psector', 'tab_budget', 'Budget', 'Budget', 'role_basic', NULL, NULL, 0, '{5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('psector', 'tab_document', 'Document', 'Document', 'role_basic', NULL, NULL, 0, '{5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('psector', 'tab_general', 'General', 'General', 'role_basic', NULL, NULL, 0, '{5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('psector', 'tab_other_prices', 'Other prices', 'Other prices', 'role_basic', NULL, NULL, 0, '{5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('psector', 'tab_relations', 'Relations', 'Relations', 'role_basic', NULL, NULL, 0, '{5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('psector', 'tab_relations_arc', 'Arc', 'Arc', 'role_basic', NULL, NULL, 0, '{5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('psector', 'tab_other_prices_mine', 'My prices', 'My prices', 'role_basic', NULL, NULL, 0, '{5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('psector', 'tab_other_prices_all', 'All prices', 'All prices', 'role_basic', NULL, NULL, 0, '{5}');

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_general', 'atlas_id', 'lyt_general_8', 4, 'text', 'text', 'Atlas id:', 'Atlas id', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, '{
  "functionName": "enable"
}'::json, NULL, false, 2);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_general', 'chk_enable_all', 'lyt_general_7', 0, 'boolean', 'check', 'Enable all (visualize obsolete state on features related to psector)', 'Enable all (visualize obsolete state on features related to psector)', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "setMultiline": true
}'::json, '{
  "functionName": "enable",
  "module": "psector"
}'::json, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_general', 'descript', 'lyt_general_6', 0, 'text', 'textarea', 'Descript:', 'Descript', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "setMultiline": false
}'::json, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_general', 'expl_id', 'lyt_general_4', 1, 'string', 'combo', 'Exploitation:', 'Exploitation', NULL, false, false, false, false, false, 'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id != 0', NULL, NULL, NULL, NULL, '{"label":"color:red; font-weight:bold"}'::json, '{"setMultiline":false}'::json, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_general', 'ext_code', 'lyt_general_2', 0, 'text', 'text', 'Ext code:  ', 'Ext code', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_general', 'name', 'lyt_general_1', 0, 'text', 'text', 'Name:      ', 'Name', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_general', 'observ', 'lyt_general_6', 3, 'text', 'textarea', 'Observation:', 'Observation', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 3);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_general', 'parent_id', 'lyt_general_2', 1, 'text', 'text', 'Parent id: ', 'Parent id', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_general', 'priority', 'lyt_general_3', 1, 'string', 'combo', 'Priority:', 'Priority', NULL, false, false, false, false, false, 'SELECT id, idval FROM plan_typevalue WHERE typevalue = ''value_priority''', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_general', 'psector_id', 'lyt_general_1', 1, 'text', 'text', 'Psector id:', 'Psector id', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_general', 'psector_type', 'lyt_general_4', 3, 'string', 'combo', 'Psector type:', 'Psector type:', NULL, false, false, false, false, false, 'SELECT id, idval FROM plan_typevalue WHERE typevalue = ''psector_type''', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_general', 'rotation', 'lyt_general_8', 2, 'text', 'text', 'Rotation:', 'Rotation', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_general', 'scale', 'lyt_general_8', 0, 'text', 'text', 'Scale:', 'Scale', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_general', 'spacer_1', 'lyt_general_4', 2, 'string', 'hspacer', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_general', 'status', 'lyt_general_3', 0, 'string', 'combo', 'Status:     ', 'Status', NULL, false, false, false, false, false, 'SELECT id, idval FROM plan_typevalue WHERE typevalue = ''psector_status''', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_general', 'text1', 'lyt_general_6', 1, 'text', 'textarea', 'Text 1:', 'Text 1:', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_general', 'text2', 'lyt_general_6', 2, 'text', 'textarea', 'Text 2:', 'Text 2:', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 2);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_general', 'workcat_id', 'lyt_general_4', 0, 'string', 'combo', 'Worcat id:', 'Worcat id', NULL, false, false, false, false, false, 'SELECT id, id as idval  FROM cat_work', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 0);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_budget', 'total_other', 'lyt_budget_3', 2, 'text', 'text', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 2);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_budget', 'vat_total', 'lyt_budget_8', 1, 'text', 'text', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_relations_arc', 'table_view_arc', 'lyt_relations_arc_1', 0, NULL, 'tablewidget', '', 'Table', NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "setMultiline": false,
  "filter": false
}'::json, NULL, 'relations_arc_results', false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_budget', 'spacer_1', 'lyt_budget_1', 1, NULL, 'hspacer', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_budget', 'lbl_total_node', 'lyt_budget_2', 0, 'text', 'label', 'Total nodes:', 'Total nodes', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_budget', 'spacer_2', 'lyt_budget_2', 1, NULL, 'hspacer', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_budget', 'spacer_3', 'lyt_budget_3', 1, NULL, 'hspacer', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_budget', 'lbl_total_arc', 'lyt_budget_1', 0, 'text', 'label', 'Total arcs:', 'Total arcs', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_budget', 'lbl_total_other', 'lyt_budget_3', 0, 'text', 'label', 'Total other prices:', 'Total other prices:', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_budget', 'spacer_4', 'lyt_budget_5', 0, NULL, 'hspacer', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_budget', 'spacer_5', 'lyt_budget_7', 0, NULL, 'hspacer', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_budget', 'spacer_6', 'lyt_budget_10', 0, NULL, 'hspacer', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_budget', 'divider3', 'lyt_budget_12', 0, NULL, 'divider', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_budget', 'spacer_7', 'lyt_budget_13', 0, NULL, 'hspacer', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_relations_connec', 'table_view_connec', 'lyt_relations_connec_1', 0, NULL, 'tablewidget', '', 'Table', NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "setMultiline": false,
  "filter": false
}'::json, NULL, 'relations_connec_results', false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_relations_node', 'table_view_node', 'lyt_relations_node_1', 0, NULL, 'tablewidget', '', 'Table', NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "setMultiline": false,
  "filter": false
}'::json, NULL, 'relations_node_results', false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_none', 'spacer_1', 'lyt_buttons', 0, NULL, 'hspacer', NULL, NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_none', 'btn_close', 'lyt_buttons', 2, NULL, 'button', NULL, 'Cancel', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "text": "Cancel"
}'::json, '{
  "functionName": "close_dlg",
  "module": "psector"
}'::json, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_none', 'btn_accept', 'lyt_buttons', 1, NULL, 'button', NULL, 'Accept', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "text": "Accept"
}'::json, '{
  "functionName": "accept",
  "module": "psector"
}'::json, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_add_info', 'num_value', 'lyt_add_info_1', 0, 'text', 'text', 'Num value:', 'Num value', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_document', 'table_view_docs', 'lyt_document_1', 0, NULL, 'tablewidget', '', 'Table', NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "setMultiline": false,
  "filter": false
}'::json, NULL, 'doc_results', false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_none', 'tab_main', 'lyt_psector_1', 0, NULL, 'tabwidget', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "tabs": [
    "tab_general",
    "tab_add_info",
    "tab_relations",
    "tab_other_prices",
    "tab_budget",
    "tab_document"
  ]
}'::json, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_add_info', 'text3', 'lyt_add_info_1', 1, 'string', 'textarea', 'Text 3:', 'Text 3:', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_add_info', 'text4', 'lyt_add_info_1', 2, 'string', 'textarea', 'Text 4:', 'Text 4:', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 2);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_add_info', 'text5', 'lyt_add_info_1', 3, 'string', 'textarea', 'Text 5:', 'Text 5:', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 3);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_add_info', 'text6', 'lyt_add_info_1', 4, 'string', 'textarea', 'Text 6:', 'Text 6:', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 4);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_budget', 'gexpenses', 'lyt_budget_6', 0, 'text', 'text', 'General expenses %', 'General expenses %', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_budget', 'total_arc', 'lyt_budget_1', 2, 'text', 'text', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 2);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_budget', 'pec_vat', 'lyt_budget_10', 1, 'text', 'text', 'Total:', 'Total:', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_budget', 'gexpenses_total', 'lyt_budget_6', 1, 'text', 'text', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_budget', 'pec', 'lyt_budget_7', 1, 'text', 'text', 'Total:', 'Total:', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_budget', 'other_total', 'lyt_budget_11', 1, 'text', 'text', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_budget', 'pca', 'lyt_budget_13', 1, 'text', 'text', 'Total:', 'Total:', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_budget', 'vat', 'lyt_budget_8', 0, 'text', 'text', 'VAT: %', 'VAT: %', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_budget', 'other', 'lyt_budget_11', 0, 'text', 'text', 'Other expenses %', 'Other expenses %', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_budget', 'pem', 'lyt_budget_5', 1, 'text', 'text', 'Total:', 'Total:', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_budget', 'divider1', 'lyt_budget_4', 0, NULL, 'divider', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 0);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_budget', 'divider2', 'lyt_budget_9', 0, NULL, 'divider', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_budget', 'total_node', 'lyt_budget_2', 2, 'text', 'text', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 2);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_other_prices', 'tab_other_prices', 'lyt_other_prices_1', 0, NULL, 'tabwidget', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "tabs": [
    "tab_other_prices_mine",
    "tab_other_prices_all"
  ]
}'::json, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_other_prices_all', 'tbl_prices', 'lyt_other_prices_all_1', 0, NULL, 'tablewidget', '', 'Table', NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "setMultiline": false,
  "filter": false
}'::json, NULL, 'prices_results', false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_other_prices_mine', 'tbl_prices_plan', 'lyt_other_prices_mine_1', 0, NULL, 'tablewidget', '', 'Table', NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "setMultiline": false,
  "filter": false
}'::json, NULL, 'prices_psector_results', false, 0);

INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('psector_tab_relations_node', '{"layouts":["lyt_relations_node_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('psector_tab_relations_connec', '{"layouts":["lyt_relations_connec_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('psector_tab_add_info', '{"layouts":["lyt_add_info_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('psector_tab_document', '{"layouts":["lyt_document_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('psector_tab_relations', '{"layouts":["lyt_relations_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('psector_tab_relations_arc', '{"layouts":["lyt_relations_arc_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('psector_tab_other_prices', '{"layouts":["lyt_other_prices_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('psector_tab_general', '{"layouts":["lyt_general_1","lyt_general_2","lyt_general_3","lyt_general_4","lyt_general_5","lyt_general_6","lyt_general_7","lyt_general_8"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('psector_tab_budget', '{"layouts":["lyt_budget_1","lyt_budget_2","lyt_budget_3","lyt_budget_4","lyt_budget_5","lyt_budget_6","lyt_budget_7","lyt_budget_8","lyt_budget_9","lyt_budget_10","lyt_budget_11","lyt_budget_12","lyt_budget_13","lyt_budget_14"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('psector_tab_other_prices_all', '{"layouts":["lyt_other_prices_all_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('psector_tab_other_prices_mine', '{"layouts":["lyt_other_prices_mine_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('prices_results', 'SELECT id, unit, descript, price FROM v_price_compost WHERE id IS NOT NULL', 5, 'tab', 'list', '{"orderBy":"1", "orderType": "ASC"}'::json, '{
  "enableGlobalFilter": false,
  "enableStickyHeader": true,
  "positionToolbarAlertBanner": "bottom",
  "enableGrouping": false,
  "enablePinning": true,
  "enableColumnOrdering": true,
  "enableColumnFilterModes": true,
  "enableFullScreenToggle": false,
  "enablePagination": true,
  "enableExporting": true,
  "muiTablePaginationProps": {
    "rowsPerPageOptions": [
      5,
      10,
      15,
      20,
      50,
      100
    ],
    "showFirstButton": true,
    "showLastButton": true
  },
  "enableRowSelection": true,
  "multipleRowSelection": true,
  "initialState": {
    "showColumnFilters": false,
    "pagination": {
      "pageSize": 5,
      "pageIndex": 0
    },
    "density": "compact",
    "columnFilters": [
      {
        "id": "id",
        "value": "",
        "filterVariant": "text"
      }
    ],
    "sorting": [
      {
        "id": "id",
        "desc": false
      }
    ]
  },
  "modifyTopToolBar": true,
  "renderTopToolbarCustomActions": [
  ],
  "enableRowActions": false,
  "renderRowActionMenuItems": [
    {
      "widgetfunction": {
        "functionName": "open",
        "params": {}
      },
      "icon": "OpenInBrowser",
      "text": "Open"
    }
  ]
}'::json);
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('doc_results', 'SELECT psector_name, doc_name, doc_type, "path", observ, "date", user_name FROM v_ui_doc_x_psector WHERE psector_name IS NOT NULL', 5, 'tab', 'list', '{"orderBy":"1", "orderType": "ASC"}'::json, '{
  "enableGlobalFilter": false,
  "enableStickyHeader": true,
  "positionToolbarAlertBanner": "bottom",
  "enableGrouping": false,
  "enablePinning": true,
  "enableColumnOrdering": true,
  "enableColumnFilterModes": true,
  "enableFullScreenToggle": false,
  "enablePagination": true,
  "enableExporting": true,
  "muiTablePaginationProps": {
    "rowsPerPageOptions": [
      5,
      10,
      15,
      20,
      50,
      100
    ],
    "showFirstButton": true,
    "showLastButton": true
  },
  "enableRowSelection": true,
  "multipleRowSelection": true,
  "initialState": {
    "showColumnFilters": false,
    "pagination": {
      "pageSize": 5,
      "pageIndex": 0
    },
    "density": "compact",
    "columnFilters": [
      {
        "id": "id",
        "value": "",
        "filterVariant": "text"
      }
    ],
    "sorting": [
      {
        "id": "id",
        "desc": false
      }
    ]
  },
  "modifyTopToolBar": true,
  "renderTopToolbarCustomActions": [
  ],
  "enableRowActions": false,
  "renderRowActionMenuItems": [
    {
      "widgetfunction": {
        "functionName": "open",
        "params": {}
      },
      "icon": "OpenInBrowser",
      "text": "Open"
    }
  ]
}'::json);
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('prices_psector_results', 'SELECT id, price_id, unit, price_descript, price, measurement, observ, total_budget FROM v_edit_plan_psector_x_other WHERE id IS NOT NULL', 5, 'tab', 'list', '{"orderBy":"1", "orderType": "ASC"}'::json, '{
  "enableGlobalFilter": false,
  "enableStickyHeader": true,
  "positionToolbarAlertBanner": "bottom",
  "enableGrouping": false,
  "enablePinning": true,
  "enableColumnOrdering": true,
  "enableColumnFilterModes": true,
  "enableFullScreenToggle": false,
  "enablePagination": true,
  "enableExporting": true,
  "muiTablePaginationProps": {
    "rowsPerPageOptions": [
      5,
      10,
      15,
      20,
      50,
      100
    ],
    "showFirstButton": true,
    "showLastButton": true
  },
  "enableRowSelection": true,
  "multipleRowSelection": true,
  "initialState": {
    "showColumnFilters": false,
    "pagination": {
      "pageSize": 5,
      "pageIndex": 0
    },
    "density": "compact",
    "columnFilters": [
      {
        "id": "id",
        "value": "",
        "filterVariant": "text"
      }
    ],
    "sorting": [
      {
        "id": "id",
        "desc": false
      }
    ]
  },
  "modifyTopToolBar": true,
  "renderTopToolbarCustomActions": [
  ],
  "enableRowActions": false,
  "renderRowActionMenuItems": [
    {
      "widgetfunction": {
        "functionName": "open",
        "params": {}
      },
      "icon": "OpenInBrowser",
      "text": "Open"
    }
  ]
}'::json);
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('relations_arc_results', 'SELECT id, arc_id, state, doable::text, addparam::text FROM plan_psector_x_arc WHERE id IS NOT NULL', 5, 'tab', 'list', '{"orderBy":"1", "orderType": "ASC"}'::json, '{
  "enableGlobalFilter": false,
  "enableStickyHeader": true,
  "positionToolbarAlertBanner": "bottom",
  "enableGrouping": false,
  "enablePinning": true,
  "enableColumnOrdering": true,
  "enableColumnFilterModes": true,
  "enableFullScreenToggle": false,
  "enablePagination": true,
  "enableExporting": true,
  "muiTablePaginationProps": {
    "rowsPerPageOptions": [
      5,
      10,
      15,
      20,
      50,
      100
    ],
    "showFirstButton": true,
    "showLastButton": true
  },
  "enableRowSelection": false,
  "multipleRowSelection": true,
  "initialState": {
    "showColumnFilters": false,
    "pagination": {
      "pageSize": 5,
      "pageIndex": 0
    },
    "density": "compact",
    "columnFilters": [
      {
        "id": "id",
        "value": "",
        "filterVariant": "text"
      }
    ],
    "sorting": [
      {
        "id": "id",
        "desc": false
      }
    ]
  },
  "modifyTopToolBar": true,
  "renderTopToolbarCustomActions": [],
  "enableRowActions": false,
  "renderRowActionMenuItems": [
    {
      "widgetfunction": {
        "functionName": "open",
        "params": {}
      },
      "icon": "OpenInBrowser",
      "text": "Open"
    }
  ]
}'::json);
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('relations_connec_results', 'SELECT id, connec_id, arc_id, state, doable::text FROM plan_psector_x_connec WHERE id IS NOT NULL', 5, 'tab', 'list', '{"orderBy":"1", "orderType": "ASC"}'::json, '{
  "enableGlobalFilter": false,
  "enableStickyHeader": true,
  "positionToolbarAlertBanner": "bottom",
  "enableGrouping": false,
  "enablePinning": true,
  "enableColumnOrdering": true,
  "enableColumnFilterModes": true,
  "enableFullScreenToggle": false,
  "enablePagination": true,
  "enableExporting": true,
  "muiTablePaginationProps": {
    "rowsPerPageOptions": [
      5,
      10,
      15,
      20,
      50,
      100
    ],
    "showFirstButton": true,
    "showLastButton": true
  },
  "enableRowSelection": false,
  "multipleRowSelection": true,
  "initialState": {
    "showColumnFilters": false,
    "pagination": {
      "pageSize": 5,
      "pageIndex": 0
    },
    "density": "compact",
    "columnFilters": [
      {
        "id": "id",
        "value": "",
        "filterVariant": "text"
      }
    ],
    "sorting": [
      {
        "id": "id",
        "desc": false
      }
    ]
  },
  "modifyTopToolBar": true,
  "renderTopToolbarCustomActions": [],
  "enableRowActions": false,
  "renderRowActionMenuItems": [
    {
      "widgetfunction": {
        "functionName": "open",
        "params": {}
      },
      "icon": "OpenInBrowser",
      "text": "Open"
    }
  ]
}'::json);
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('relations_node_results', 'SELECT id, node_id, state, doable::text, addparam::text FROM plan_psector_x_node WHERE id IS NOT NULL', 5, 'tab', 'list', '{"orderBy":"1", "orderType": "ASC"}'::json, '{
  "enableGlobalFilter": false,
  "enableStickyHeader": true,
  "positionToolbarAlertBanner": "bottom",
  "enableGrouping": false,
  "enablePinning": true,
  "enableColumnOrdering": true,
  "enableColumnFilterModes": true,
  "enableFullScreenToggle": false,
  "enablePagination": true,
  "enableExporting": true,
  "muiTablePaginationProps": {
    "rowsPerPageOptions": [
      5,
      10,
      15,
      20,
      50,
      100
    ],
    "showFirstButton": true,
    "showLastButton": true
  },
  "enableRowSelection": false,
  "multipleRowSelection": true,
  "initialState": {
    "showColumnFilters": false,
    "pagination": {
      "pageSize": 5,
      "pageIndex": 0
    },
    "density": "compact",
    "columnFilters": [
      {
        "id": "id",
        "value": "",
        "filterVariant": "text"
      }
    ],
    "sorting": [
      {
        "id": "id",
        "desc": false
      }
    ]
  },
  "modifyTopToolBar": true,
  "renderTopToolbarCustomActions": [],
  "enableRowActions": false,
  "renderRowActionMenuItems": [
    {
      "widgetfunction": {
        "functionName": "open",
        "params": {}
      },
      "icon": "OpenInBrowser",
      "text": "Open"
    }
  ]
}'::json);


-- 19/02/2025
UPDATE config_typevalue SET idval='lyt_bot_1', camelstyle='layoutBottom1', addparam='{"createAddfield":"TRUE","lytOrientation":"horizontal"}'::json WHERE typevalue='layout_name_typevalue' AND id='lyt_bot_1';
UPDATE config_typevalue SET idval='lyt_top_1', camelstyle='layoutTop1', addparam='{"createAddfield":"TRUE","lytOrientation":"horizontal"}'::json WHERE typevalue='layout_name_typevalue' AND id='lyt_top_1';
UPDATE config_typevalue SET idval='lyt_element_1', camelstyle='lytElements1', addparam='{"createAddfield":"TRUE","lytOrientation":"horizontal"}'::json WHERE typevalue='layout_name_typevalue' AND id='lyt_element_1';
UPDATE config_typevalue SET idval='lyt_event_1', camelstyle='lytEvents1', addparam='{"createAddfield":"TRUE","lytOrientation":"horizontal"}'::json WHERE typevalue='layout_name_typevalue' AND id='lyt_event_1';
UPDATE config_typevalue SET idval='lyt_epa_dsc_1', camelstyle='lytEpaDsc1', addparam='{"lytOrientation": "horizontal"}'::json WHERE typevalue='layout_name_typevalue' AND id='lyt_epa_dsc_1';
UPDATE config_typevalue SET idval='lyt_event_2', camelstyle='lytEvents2', addparam='{"lytOrientation":"horizontal"}'::json WHERE typevalue='layout_name_typevalue' AND id='lyt_event_2';
UPDATE config_typevalue SET idval='lyt_document_1', camelstyle='lytDocuments1', addparam='{"lytOrientation":"horizontal"}'::json WHERE typevalue='layout_name_typevalue' AND id='lyt_document_1';
UPDATE config_typevalue SET idval='lyt_document_2', camelstyle='lytDocuments2', addparam='{"lytOrientation":"horizontal"}'::json WHERE typevalue='layout_name_typevalue' AND id='lyt_document_2';
UPDATE config_typevalue SET idval='lyt_hydro_val_1', camelstyle='lytHydroVal1', addparam='{"lytOrientation":"horizontal"}'::json WHERE typevalue='layout_name_typevalue' AND id='lyt_hydro_val_1';
UPDATE config_typevalue SET idval='lyt_hydrometer_1', camelstyle='lytHydrometer1', addparam='{"lytOrientation":"horizontal"}'::json WHERE typevalue='layout_name_typevalue' AND id='lyt_hydrometer_1';


UPDATE config_form_fields	SET widgetcontrols='{"setMultiline": false, "valueRelation": {"layer": "v_edit_presszone", "activated": true, "keyColumn": "presszone_id", "nullValue": false, "valueColumn": "name", "filterExpression": null}}'::json, layoutname='lyt_data_2' WHERE columnname ='presszone_id' AND formtype='form_feature' AND tabname='tab_data' AND (formname LIKE '%_connec_%' OR formname LIKE '%_node_%' OR formname LIKE '%_arc_%');
UPDATE config_form_fields	SET widgetcontrols='{"setMultiline": false, "valueRelation": {"layer": "v_edit_dqa", "activated": true, "keyColumn": "dqa_id", "nullValue": false, "valueColumn": "name", "filterExpression": null}}'::json, layoutname='lyt_data_2' WHERE columnname ='dqa_id' AND formtype='form_feature' AND tabname='tab_data' AND (formname LIKE '%_connec_%' OR formname LIKE '%_node_%' OR formname LIKE '%_arc_%');
UPDATE config_form_fields	SET widgetcontrols='{"setMultiline": false}'::json, layoutname='lyt_data_2'	WHERE columnname ='verified' AND formtype='form_feature' AND tabname='tab_data' AND (formname LIKE '%_connec_%' OR formname LIKE '%_node_%' OR formname LIKE '%_arc_%');
UPDATE config_form_fields	SET widgetcontrols='{"setMultiline": false, "valueRelation": {"layer": "v_edit_exploitation", "activated": true, "keyColumn": "expl_id", "nullValue": false, "valueColumn": "name", "filterExpression": null}}'::json, layoutname='lyt_data_2' WHERE columnname ='expl_id' AND formtype='form_feature' AND tabname='tab_data' AND (formname LIKE '%_connec_%' OR formname LIKE '%_node_%' OR formname LIKE '%_arc_%');

UPDATE config_form_fields SET "label"='Customer code:', tooltip='Customer code' WHERE formname='connec' AND formtype='form_feature' AND columnname='hydrometer_id' AND tabname='tab_hydrometer';

-- 27/02/2025
UPDATE config_form_fields SET layoutorder=2, web_layoutorder=2 WHERE formname='generic' AND formtype='epa_selector' AND columnname='btn_accept' AND tabname='tab_none';
UPDATE config_form_fields SET layoutorder=3, web_layoutorder=3 WHERE formname='generic' AND formtype='epa_selector' AND columnname='btn_cancel' AND tabname='tab_none';
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'epa_selector', 'tab_none', 'hspacer_epa_selector', 'lyt_buttons', 1, NULL, 'hspacer', NULL, NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 1);

-- 03/03/2025
UPDATE config_form_tabs SET "label"='Data', tooltip='Data', sys_role='role_basic', tabfunction=NULL, tabactions='[
  {
    "actionName": "actionEdit",
    "disabled": false
  },
  {
    "actionName": "actionAudit",
    "disabled": false
  },
  {
    "actionName": "actionZoom",
    "disabled": false
  },
  {
    "actionName": "actionCentered",
    "disabled": false
  },
  {
    "actionName": "actionZoomOut",
    "disabled": false
  },
  {
    "actionName": "actionCatalog",
    "disabled": false
  },
  {
    "actionName": "actionWorkcat",
    "disabled": false
  },
  {
    "actionName": "actionCopyPaste",
    "disabled": false
  },
  {
    "actionName": "actionLink",
    "disabled": false
  },
  {
    "actionName": "actionMapZone",
    "disabled": false
  },
  {
    "actionName": "actionSetToArc",
    "disabled": false
  },
  {
    "actionName": "actionGetParentId",
    "disabled": false
  },
  {
    "actionName": "actionGetArcId",
    "disabled": false
  },
  {
    "actionName": "actionRotation",
    "disabled": false
  },
  {
    "actionName": "actionInterpolate",
    "disabled": false
  }
]'::json, orderby=0, device='{4,5}' WHERE formname='v_edit_node' AND tabname='tab_data';

INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('linkedaction_typevalue', 'action_audit', 'action_audit', 'actionAudit', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('formtype_typevalue', 'audit_manager', 'audit_manager', 'auditManager', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_audit_manager_1', 'lyt_audit_manager_1', 'layoutAuditManager1', '{
  "lytOrientation": "horizontal"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_audit_manager_2', 'lyt_audit_manager_2', 'layoutAuditManager2', '{
  "lytOrientation": "horizontal"
}'::json);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'audit_manager', 'tab_none', 'spacer_2', 'lyt_buttons', 0, NULL, 'hspacer', NULL, NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'audit_manager', 'tab_none', 'spacer_1', 'lyt_audit_manager_1', 0, NULL, 'hspacer', NULL, NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'audit_manager', 'tab_none', 'spacer_3', 'lyt_audit_manager_2', 2, NULL, 'hspacer', NULL, NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'audit_manager', 'tab_none', 'date_to', 'lyt_audit_manager_2', 0, 'date', 'datetime', 'Select date:', 'Select date', NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'audit_manager', 'tab_none', 'btn_open', 'lyt_audit_manager_1', 1, NULL, 'button', NULL, 'Open', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"text": "Open"}'::json, '{
  "functionName": "open",
  "module": "audit"
}'::json, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'audit_manager', 'tab_none', 'btn_open_date', 'lyt_audit_manager_2', 1, NULL, 'button', NULL, 'Open', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"text": "Open date"}'::json, '{
  "functionName": "open_date",
  "module": "audit"
}'::json, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'audit_manager', 'tab_none', 'btn_close', 'lyt_buttons', 1, NULL, 'button', NULL, 'Close', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"text": "Close"}'::json, '{
  "functionName": "close_dlg",
  "module": "audit"
}'::json, NULL, false, 0);

INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('audit_results', 'SELECT id, tstamp, "action", query, user_name FROM audit.log WHERE id IS NOT NULL', 4, 'tab', 'list', '{"orderBy":"1", "orderType": "ASC"}'::json, '{
  "enableGlobalFilter": false,
  "enableStickyHeader": true,
  "positionToolbarAlertBanner": "bottom",
  "enableGrouping": false,
  "enablePinning": true,
  "enableColumnOrdering": true,
  "enableColumnFilterModes": true,
  "enableFullScreenToggle": false,
  "enablePagination": true,
  "enableExporting": true,
  "muiTablePaginationProps": {
    "rowsPerPageOptions": [
      5,
      10,
      15,
      20,
      50,
      100
    ],
    "showFirstButton": true,
    "showLastButton": true
  },
  "enableRowSelection": true,
  "multipleRowSelection": true,
  "initialState": {
    "showColumnFilters": false,
    "pagination": {
      "pageSize": 5,
      "pageIndex": 0
    },
    "density": "compact",
    "columnFilters": [
      {
        "id": "id",
        "value": "",
        "filterVariant": "text"
      }
    ],
    "sorting": [
      {
        "id": "name",
        "desc": false
      }
    ]
  },
  "modifyTopToolBar": true,
  "renderTopToolbarCustomActions": [
    {
      "name": "btn_show_psector",
      "widgetfunction": {
        "functionName": "showPsector",
        "params": {}
      },
      "color": "default",
      "text": "Show psector",
      "disableOnSelect": true,
      "moreThanOneDisable": false
    }
  ],
  "enableRowActions": false,
  "renderRowActionMenuItems": [
    {
      "widgetfunction": {
        "functionName": "open",
        "params": {}
      },
      "icon": "OpenInBrowser",
      "text": "Open"
    }
  ]
}'::json);

DELETE FROM config_form_fields WHERE formname='v_edit_dimensions' AND formtype='form_feature' AND columnname='id' AND tabname='tab_none';


-- 05/03/2025
UPDATE sys_param_user
	SET layoutorder=24
	WHERE id='utils_psector_strategy';

-- 06/03/2025
DELETE FROM sys_function WHERE id = 3240;

INSERT INTO inp_typevalue (typevalue, id, idval, descript, addparam) VALUES('inp_typevalue_pattern', 'MONTHLY', 'MONTHLY', NULL, NULL) ON CONFLICT DO NOTHING;
INSERT INTO inp_typevalue (typevalue, id, idval, descript, addparam) VALUES('inp_typevalue_pattern', 'DAILY', 'DAILY', NULL, NULL) ON CONFLICT DO NOTHING;
INSERT INTO inp_typevalue (typevalue, id, idval, descript, addparam) VALUES('inp_typevalue_pattern', 'HOURLY', 'HOURLY', NULL, NULL) ON CONFLICT DO NOTHING;
INSERT INTO inp_typevalue (typevalue, id, idval, descript, addparam) VALUES('inp_typevalue_pattern', 'WEEKEND', 'WEEKEND', NULL, NULL) ON CONFLICT DO NOTHING;

UPDATE config_form_fields SET dv_querytext='SELECT  id, idval FROM inp_typevalue WHERE id IS NOT NULL AND typevalue=''inp_typevalue_pattern''' WHERE formname='inp_pattern' AND formtype='form_feature' AND columnname='pattern_type' AND tabname='tab_none';

-- 07/03/2025
DELETE FROM sys_table WHERE id='config_file';
UPDATE config_form_fields SET dv_querytext='SELECT DISTINCT idval AS id, idval FROM config_typevalue WHERE typevalue = ''filetype_typevalue''' WHERE formname='om_visit_event_photo' AND formtype='form_list_header' AND columnname='filetype' AND tabname='tab_none';

-- 10/03/2025
DELETE FROM sys_table WHERE id='cat_builder';
UPDATE sys_table SET context = '{"level_1":"INVENTORY","level_2":"CATALOGS"}', alias = 'Brand model catalog', orderby=15 WHERE id ='cat_brand_model';
UPDATE sys_table SET context = '{"level_1":"INVENTORY","level_2":"CATALOGS"}', alias = 'Brand catalog', orderby=16 WHERE id ='cat_brand';
UPDATE sys_table SET context = '{"level_1":"INVENTORY","level_2":"CATALOGS"}', alias = 'Users catalog', orderby=17 WHERE id ='cat_users';
UPDATE sys_table SET context = '{"level_1":"INVENTORY","level_2":"CATALOGS"}', alias = 'Period catalog', orderby=18 WHERE id ='ext_cat_period';
UPDATE sys_table SET context = '{"level_1":"INVENTORY","level_2":"CATALOGS"}', alias = 'Hydrometer catalog', orderby=19 WHERE id ='ext_cat_hydrometer';

DELETE FROM config_form_fields WHERE formname='cat_builder';

-- 11/03/2025
DELETE FROM sys_table WHERE id='config_user_x_sector';
DELETE FROM sys_function WHERE function_name='gw_trg_cat_manager';

--13/03/2025
ALTER TABLE sys_role DROP CONSTRAINT sys_role_check;
UPDATE sys_role SET id='role_plan', context='plan', descript=NULL WHERE id='role_master';
ALTER TABLE sys_role ADD CONSTRAINT sys_role_check
CHECK (((id)::text = ANY (ARRAY[('role_admin'::character varying)::text, ('role_basic'::character varying)::text, ('role_edit'::character varying)::text, ('role_epa'::character varying)::text, ('role_plan'::character varying)::text, ('role_om'::character varying)::text, ('role_crm'::character varying)::text, ('role_system'::character varying)::text])));

-- 14/03/2025
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('formtype_typevalue', 'snapshot_view', 'snapshot_view', 'snapshotView', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_snapshot_view_1', 'lyt_snapshot_view_1', 'layoutSnapshotView1', '{
  "lytOrientation": "vertical"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_snapshot_view_2', 'lyt_snapshot_view_2', 'layoutSnapshotView2', '{
  "lytOrientation": "horizontal"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_snapshot_view_3', 'lyt_snapshot_view_3', 'layoutSnapshotView3', '{
  "lytOrientation": "vertical"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_snapshot_view_4', 'lyt_snapshot_view_4', 'layoutSnapshotView4', '{
  "lytOrientation": "vertical"
}'::json);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'snapshot_view', 'tab_none', 'spacer1', 'lyt_buttons', 0, NULL, 'hspacer', NULL, NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'snapshot_view', 'tab_none', 'chk_connec', 'lyt_snapshot_view_3', 3, 'boolean', 'check', 'Connecs', 'Connecs', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'snapshot_view', 'tab_none', 'chk_gully', 'lyt_snapshot_view_3', 4, 'boolean', 'check', 'Gullies', 'Gullies', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'snapshot_view', 'tab_none', 'chk_node', 'lyt_snapshot_view_3', 2, 'boolean', 'check', 'Nodes', 'Nodes', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'snapshot_view', 'tab_none', 'chk_arc', 'lyt_snapshot_view_3', 1, 'boolean', 'check', 'Arcs', 'Arcs', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'snapshot_view', 'tab_none', 'chk_link', 'lyt_snapshot_view_4', 0, 'boolean', 'check', 'Links', 'Links', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'snapshot_view', 'tab_none', 'chk_element', 'lyt_snapshot_view_4', 1, 'boolean', 'check', 'Elements', 'Elements', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'snapshot_view', 'tab_none', 'chk_doc', 'lyt_snapshot_view_4', 2, 'boolean', 'check', 'Documents', 'Documents', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'snapshot_view', 'tab_none', 'date', 'lyt_snapshot_view_1', 1, 'date', 'datetime', 'Select date', 'Select date', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'snapshot_view', 'tab_none', 'extension', 'lyt_snapshot_view_2', 0, 'string', 'text', 'Grid Extension', 'Grid Extension', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'snapshot_view', 'tab_none', 'btn_close', 'lyt_buttons', 2, NULL, 'button', NULL, 'Close', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "text": "Close"
}'::json, '{
  "functionName": "close_dlg",
  "module": "snapshot_view"
}'::json, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'snapshot_view', 'tab_none', 'btn_grid', 'lyt_snapshot_view_2', 1, NULL, 'button', NULL, ' ', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{
  "icon": "999"
}'::json, NULL, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'snapshot_view', 'tab_none', 'btn_run', 'lyt_buttons', 1, NULL, 'button', NULL, 'Run', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "text": "Run"
}'::json, '{
  "functionName": "run",
  "module": "snapshot_view"
}'::json, NULL, false, 0);



-- 19/03/2025


INSERT INTO config_typevalue(typevalue, id, idval, camelstyle, addparam) VALUES ('layout_name_typevalue', 'lyt_element_mng_1', 'lyt_element_mng_1', 'layoutElementManager1', '{"lytOrientation":"horizontal"}'::json);
INSERT INTO config_typevalue(typevalue, id, idval, camelstyle, addparam) VALUES ('layout_name_typevalue', 'lyt_element_mng_2', 'lyt_element_mng_2', 'layoutElementManager2', '{"lytOrientation":"horizontal"}'::json);
INSERT INTO config_typevalue(typevalue, id, idval, camelstyle, addparam) VALUES ('formtype_typevalue', 'form_element', 'form_element', 'formElement', null);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('element_manager', 'form_element', 'tab_none', 'hspacer_lyt_bot_3', 'lyt_buttons', 1, NULL, 'hspacer', NULL, NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('element_manager', 'form_element', 'tab_none', 'tbl_element', 'lyt_element_mng_2', 1, NULL, 'tablewidget', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"saveValue": false}'::json, '{"functionName":"open_selected_manager_item", "parameters":{"columnfind":"id"}}'::json, 'v_ui_element', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('element_manager', 'form_element', 'tab_none', 'create', 'lyt_element_mng_1', 3, NULL, 'button', NULL, 'Create', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"saveValue":false, "text":"Create"}'::json, '{"functionName": "manage_element","parameters": {}}'::json, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('element_manager', 'form_element', 'tab_none', 'element_id', 'lyt_element_mng_1', 1, 'string', 'typeahead', 'Filter by: Element id', NULL, NULL, false, false, true, false, true, 'SELECT id, id as idval FROM v_ui_element WHERE id IS NOT NULL', NULL, NULL, NULL, NULL, NULL, '{"saveValue": false, "filterSign":"ILIKE"}'::json, '{"functionName": "filter_table", "parameters":{"columnfind":"id"}}'::json, 'v_ui_element', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('element_manager', 'form_element', 'tab_none', 'cancel', 'lyt_buttons', 2, NULL, 'button', NULL, 'Close', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"saveValue":false, "text":"Close"}'::json, '{"functionName": "close_manager",  "parameters":{}}'::json, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('element_manager', 'form_element', 'tab_none', 'hspacer_lyt_element_mng_1', 'lyt_element_mng_1', 2, NULL, 'hspacer', NULL, NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('element_manager', 'form_element', 'tab_none', 'delete', 'lyt_element_mng_1', 4, NULL, 'button', NULL, 'Delete', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"saveValue":false, "text":"Delete", "onContextMenu":"Delete"}'::json, '{"functionName": "delete_manager_item","parameters": {"sourcetable": "v_edit_element", "targetwidget":"tab_none_tbl_element"}}'::json, NULL, false, NULL);


--25/03/2025

-- link related
DELETE FROM config_form_tabs WHERE formname = 'v_edit_link' AND tabname = 'tab_none';

INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('v_edit_link', 'tab_documents', 'Documents', 'List of documents', 'role_basic', NULL, '[{"actionName":"actionEdit", "disabled":false},
{"actionName":"actionZoom", "disabled":false},
{"actionName":"actionCentered", "disabled":false},
{"actionName":"actionZoomOut", "disabled":false},
{"actionName":"actionCatalog", "disabled":false},
{"actionName":"actionWorkcat", "disabled":false},
{"actionName":"actionCopyPaste","disabled":false},
{"actionName":"actionSection", "disabled":false},
{"actionName":"actionGetParentId", "disabled":false},
{"actionName":"actionLink",  "disabled":false}]'::json, 5, '{4,5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('v_edit_link', 'tab_data', 'Data', 'Data', 'role_basic', NULL, '[{"actionName":"actionEdit", "disabled":false},
{"actionName":"actionZoom", "disabled":false},
{"actionName":"actionCentered", "disabled":false},
{"actionName":"actionZoomOut", "disabled":false},
{"actionName":"actionCatalog", "disabled":false},
{"actionName":"actionWorkcat", "disabled":false},
{"actionName":"actionCopyPaste","disabled":false},
{"actionName":"actionSection", "disabled":false},
{"actionName":"actionGetParentId", "disabled":false},
{"actionName":"actionLink",  "disabled":false},
{"actionName": "actionHelp", "disabled": false}]'::json, 0, '{4,5}');

UPDATE config_info_layer SET is_parent=false, tableparent_id=NULL, is_editable=true, formtemplate='info_feature', headertext='Link', orderby=7, tableparentepa_id=NULL, addparam=NULL WHERE layer_id='v_edit_link';

UPDATE config_param_system SET value='{"node":"node_id", "arc":"arc_id", "connec":"connec_id", "link":"link_id",  "gully":"gully_id", "element":{"childType":"ELEMENT", "column":"element_id"},
 "hydrometer":{"childType":"HYDROMETER", "column":"hydrometer_id"},  "newText":"NEW"}' WHERE "parameter"='admin_formheader_field';

INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('tbl_doc_x_link', 'SELECT * FROM v_ui_doc_x_link WHERE link_id IS NOT NULL', 4, 'tab', 'list', NULL, NULL);

INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('link form', 'utils', 'tbl_doc_x_link', 'sys_id', 0, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('link form', 'utils', 'tbl_doc_x_link', 'id', 1, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('link form', 'utils', 'tbl_doc_x_link', 'link_id', 2, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('link form', 'utils', 'tbl_doc_x_link', 'doc_id', 3, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('link form', 'utils', 'tbl_doc_x_link', 'doc_type', 4, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('link form', 'utils', 'tbl_doc_x_link', 'path', 5, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('link form', 'utils', 'tbl_doc_x_link', 'observ', 6, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('link form', 'utils', 'tbl_doc_x_link', 'date', 7, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('link form', 'utils', 'tbl_doc_x_link', 'user_name', 8, true, NULL, NULL, NULL, NULL);

-- 02/04/2025
UPDATE config_form_fields SET dv_querytext = REPLACE(dv_querytext, 'sys_feature_cat', ' sys_feature_class') WHERE dv_querytext ILIKE '%sys_feature_cat%';

-- 03/04/2025
INSERT INTO value_state_type (id, state, "name", is_operative, is_doable) VALUES  (100, 2, 'OBSOLETE-FICTICIUS', true, false) ON CONFLICT DO NOTHING;

UPDATE config_form_fields SET dv_querytext='WITH check_value AS (
  SELECT value::integer AS psector_value 
  FROM config_param_user 
  WHERE parameter = ''plan_psector_current''
  AND cur_user = ''||CURRENT_USER||''
)
SELECT id, name as idval 
FROM value_state 
WHERE id IS NOT NULL 
AND CASE 
  WHEN (SELECT psector_value FROM check_value) IS NULL THEN id != 2 
  ELSE true 
END', dv_querytext_filterc = NULL WHERE formname ILIKE 've_%' AND formtype='form_feature' AND columnname='state' AND tabname='tab_data';

INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('tbl_element_x_link', 'SELECT * FROM v_ui_element_x_link WHERE link_id IS NOT NULL', 4, 'tab', 'list', NULL, NULL);

ALTER TABLE config_form_fields ENABLE TRIGGER gw_trg_config_control;

DELETE FROM config_form_fields WHERE formname IN ('v_edit_arc', 'v_edit_connec', 'v_edit_gully', 'v_edit_node', 'v_edit_element') AND columnname='undelete';

-- 25/04/2025
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_connect_link_3', 'lyt_connect_link_3', 'lytConnectLink3', '{
  "lytOrientation": "horizontal"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_connect_link_2', 'lyt_connect_link_2', 'lytConnectLink2', '{
  "lytOrientation": "horizontal"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_connect_link_1', 'lyt_connect_link_1', 'lytConnectLink1', '{"lytOrientation": "vertical"}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('formtype_typevalue', 'link_to_connec', 'link_to_connec', 'linkToConnec', NULL);

ALTER TABLE config_form_fields DISABLE TRIGGER gw_trg_config_control;
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'link_to_connec', 'tab_none', 'linkcat', 'lyt_connect_link_1', 2, 'text', 'combo', 'Link catalog:', 'Link catalog', NULL, true, NULL, true, NULL, NULL, 'SELECT id, id AS idval FROM cat_link WHERE id IS NOT NULL', NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'link_to_connec', 'tab_none', 'pipe_diameter', 'lyt_connect_link_1', 0, 'text', 'text', 'Max. Pipe diameter:', 'Max. Pipe diameter:', '150', true, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'link_to_connec', 'tab_none', 'max_distance', 'lyt_connect_link_1', 1, 'text', 'text', 'Max. distance:', 'Max. distance', '100', true, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'link_to_connec', 'tab_none', 'tbl_ids', 'lyt_connect_link_3', 0, NULL, 'tableview', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'link_to_connec', 'tab_none', 'btn_snapping', 'lyt_connect_link_2', 3, NULL, 'button', NULL, 'Select on canvas', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{
  "icon": "137"
}'::json, NULL, '{
  "functionName": "snapping",
  "module": "connect_link_btn"
}'::json, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'link_to_connec', 'tab_none', 'btn_add', 'lyt_connect_link_2', 1, NULL, 'button', NULL, 'Add', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{
  "icon": "111"
}'::json, NULL, '{
  "functionName": "add",
  "module": "connect_link_btn"
}'::json, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'link_to_connec', 'tab_none', 'btn_remove', 'lyt_connect_link_2', 2, NULL, 'button', NULL, 'Remove', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{
  "icon": "112"
}'::json, NULL, '{
  "functionName": "remove",
  "module": "connect_link_btn"
}'::json, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'link_to_connec', 'tab_none', 'id', 'lyt_connect_link_2', 0, 'text', 'combo', 'Connec Id:', 'Connec Id', NULL, NULL, NULL, true, NULL, NULL, 'SELECT connec_id AS id, connec_id AS idval FROM connec WHERE connec_id IS NOT NULL', NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'link_to_connec', 'tab_none', 'spacer_1', 'lyt_buttons', 0, NULL, 'hspacer', NULL, NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'link_to_connec', 'tab_none', 'btn_accept', 'lyt_buttons', 1, NULL, 'button', '', 'Accept', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"text":"Accept"}'::json, '{
  "functionName": "accept",
  "module": "connect_link_btn"
}'::json, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'link_to_connec', 'tab_none', 'btn_close', 'lyt_buttons', 2, NULL, 'button', '', 'Close', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "text": "Close"
}'::json, '{
  "functionName": "close",
  "module": "connect_link_btn"
}'::json, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'link_to_connec', 'tab_none', 'btn_filter_expression', 'lyt_connect_link_2', 4, NULL, 'button', NULL, 'Filter by expression', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{
  "icon": "178"
}'::json, NULL, '{
  "functionName": "filter_expression",
  "module": "connect_link_btn"
}'::json, NULL, false, 0);
ALTER TABLE config_form_fields ENABLE TRIGGER gw_trg_config_control;


-- messages:
UPDATE sys_message SET message_type = 'UI';


-- revisar donde se hacen los inserts para cm
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('formtype_typevalue', 'create_organization', 'create_organization', NULL, NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_create_org_1', 'lyt_create_org_1', NULL, '{"lytOrientation": "vertical"}'::json);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'create_organization', 'tab_none', 'active', 'lyt_create_org_1', 2, 'text', 'check', 'Active:', 'Active', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'create_organization', 'tab_none', 'btn_accept', 'lyt_buttons', 1, NULL, 'button', '', 'Accept', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "text": "Accept"
}'::json, '{
  "functionName": "upsert_organization",
  "module": "lot"
}'::json, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'create_organization', 'tab_none', 'btn_close', 'lyt_buttons', 2, NULL, 'button', '', 'Close', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "text": "Close"
}'::json, '{
  "functionName": "close",
  "module": "lot"
}'::json, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'create_organization', 'tab_none', 'descript', 'lyt_create_org_1', 1, 'text', 'textarea', 'Description:', 'Description', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'create_organization', 'tab_none', 'name', 'lyt_create_org_1', 0, 'text', 'text', 'Name:', 'Name', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'create_organization', 'tab_none', 'spacer_1', 'lyt_buttons', 0, NULL, 'hspacer', '', NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 0);

-- 12/05/2025
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('formtype_typevalue', 'audit', 'audit', 'audit', NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'audit', 'tab_none', 'btn_close', 'lyt_buttons', 1, NULL, 'button', NULL, 'Close', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"text": "Close"}'::json, '{
  "functionName": "close_dlg",
  "module": "audit"
}'::json, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'audit', 'tab_none', 'spacer_1', 'lyt_buttons', 0, NULL, 'hspacer', NULL, NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 0);

-- 20/05/2025
DELETE FROM config_form_fields
WHERE formname='generic' AND formtype='form_featuretype_change' AND columnname='fluid_type' AND tabname='tab_none';

UPDATE config_form_fields SET iseditable = FALSE WHERE columnname = 'fluid_type';

-- 10/06/2025
-- remove fluid_type from element forms
DELETE FROM config_form_fields WHERE formname ILIKE '%elem%' AND formtype = 'form_feature' AND columnname = 'fluid_type';
