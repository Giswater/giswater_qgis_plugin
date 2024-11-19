/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;

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

-- 08/10/2024
ALTER TABLE sys_foreignkey DROP CONSTRAINT sys_foreingkey_pkey;
ALTER TABLE sys_foreignkey DROP COLUMN id;
ALTER TABLE sys_foreignkey DROP CONSTRAINT sys_foreignkey_unique;
ALTER TABLE sys_foreignkey ADD CONSTRAINT sys_foreingkey_pkey PRIMARY KEY (typevalue_table, typevalue_name, target_table, target_field);

ALTER TABLE plan_psector ADD CONSTRAINT plan_psector_workcat_id_fkey FOREIGN KEY (workcat_id) REFERENCES cat_work(id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE plan_psector ADD CONSTRAINT plan_psector_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES plan_psector(psector_id) ON UPDATE CASCADE ON DELETE RESTRICT;
CREATE INDEX plan_psector_workcat_id_index ON plan_psector USING btree (workcat_id);
CREATE INDEX plan_psector_parent_id_index ON plan_psector USING btree (parent_id);

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

-- 19/11/24
ALTER TABLE rpt_cat_result ALTER COLUMN iscorporate SET NOT NULL;
ALTER TABLE rpt_cat_result ALTER COLUMN iscorporate SET DEFAULT false;

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, "source")
VALUES (3346, 'gw_trg_mantypevalue_fk', 'utils', 'trigger', NULL, NULL, 'Control foreign keys created in man_type_* tables', 'role_edit', 'core');

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, "source")
VALUES (3347, 'gw_fct_get_dialog', 'utils', 'function', 'json', 'json', 'Function to build dialogs for generic forms', 'role_basic', 'core');

