/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 9/2/2024;
ALTER TABLE inp_typevalue DISABLE TRIGGER gw_trg_typevalue_config_fk;
UPDATE inp_typevalue SET typevalue = '_inp_options_networkmode' WHERE typevalue = 'inp_options_networkmode' and id = '1';
UPDATE inp_typevalue SET idval = 'BASIC NETWORK' WHERE typevalue = 'inp_options_networkmode' and id = '2';
UPDATE inp_typevalue SET idval = 'NETWORK & CONNECS' WHERE typevalue = 'inp_options_networkmode' and id = '4';
ALTER TABLE inp_typevalue ENABLE TRIGGER gw_trg_typevalue_config_fk;

-- 24/2/2024;
DELETE FROM config_form_fields WHERE formname = 've_epa_virtualpump' and columnname = 'price_pattern';

-- 26/02/2024
UPDATE config_form_fields
	SET widgetcontrols='{"saveValue": false, "tableUpsert": "v_edit_inp_dscenario_virtualpump"}'::json, linkedobject='tbl_inp_dscenario_virtualpump', columnname='tbl_inp_virtualpump'
	WHERE formname='ve_epa_virtualpump' AND columnname='tbl_inp_pump';

-- 28/02/2024

DELETE FROM config_form_fields
	WHERE formname='inp_dscenario_connec' AND formtype='form_feature' AND columnname='pjoint_type' AND tabname='tab_none';
DELETE FROM config_form_fields
	WHERE formname='inp_dscenario_connec' AND formtype='form_feature' AND columnname='pjoint_id' AND tabname='tab_none';

UPDATE sys_table
	SET addparam='{"pkey": "dscenario_id, feature_id"}'::json
	WHERE id='inp_dscenario_demand';

UPDATE sys_table 
	SET criticity=NULL, context=NULL, orderby=NULL, alias=NULL 
	WHERE id='v_om_mincut';
UPDATE sys_table 
	SET criticity=2, context='{"level_1":"OM","level_2":"MINCUT"}', orderby=1, alias='Mincut init point', addparam='{"geom": "anl_the_geom"}'::json 
	WHERE id='v_om_mincut_initpoint';
-- Set style for v_om_mincut_initpoint
INSERT INTO sys_style (id, idval,styletype,stylevalue,active)
	VALUES (170, 'v_om_mincut_initpoint','qml','<!DOCTYPE qgis PUBLIC ''http://mrcc.com/qgis.dtd'' ''SYSTEM''>
<qgis simplifyMaxScale="1" maxScale="0" simplifyDrawingHints="0" version="3.22.3-Białowieża" symbologyReferenceScale="-1" simplifyLocal="1" styleCategories="Symbology|Labeling|Rendering" minScale="100000000" labelsEnabled="0" simplifyAlgorithm="0" simplifyDrawingTol="1" hasScaleBasedVisibilityFlag="0">
  <renderer-v2 forceraster="0" symbollevels="0" referencescale="-1" enableorderby="0" type="singleSymbol">
    <symbols>
      <symbol alpha="1" clip_to_extent="1" name="0" force_rhr="0" type="marker">
        <data_defined_properties>
          <Option type="Map">
            <Option name="name" value="" type="QString"/>
            <Option name="properties"/>
            <Option name="type" value="collection" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer class="SimpleMarker" pass="0" enabled="1" locked="0">
          <Option type="Map">
            <Option name="angle" value="0" type="QString"/>
            <Option name="cap_style" value="square" type="QString"/>
            <Option name="color" value="45,84,255,255" type="QString"/>
            <Option name="horizontal_anchor_point" value="1" type="QString"/>
            <Option name="joinstyle" value="bevel" type="QString"/>
            <Option name="name" value="circle" type="QString"/>
            <Option name="offset" value="0,0" type="QString"/>
            <Option name="offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="offset_unit" value="MM" type="QString"/>
            <Option name="outline_color" value="0,24,124,255" type="QString"/>
            <Option name="outline_style" value="solid" type="QString"/>
            <Option name="outline_width" value="0" type="QString"/>
            <Option name="outline_width_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="outline_width_unit" value="MM" type="QString"/>
            <Option name="scale_method" value="diameter" type="QString"/>
            <Option name="size" value="2.4" type="QString"/>
            <Option name="size_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="size_unit" value="MM" type="QString"/>
            <Option name="vertical_anchor_point" value="1" type="QString"/>
          </Option>
          <prop k="angle" v="0"/>
          <prop k="cap_style" v="square"/>
          <prop k="color" v="45,84,255,255"/>
          <prop k="horizontal_anchor_point" v="1"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="name" v="circle"/>
          <prop k="offset" v="0,0"/>
          <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="offset_unit" v="MM"/>
          <prop k="outline_color" v="0,24,124,255"/>
          <prop k="outline_style" v="solid"/>
          <prop k="outline_width" v="0"/>
          <prop k="outline_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="outline_width_unit" v="MM"/>
          <prop k="scale_method" v="diameter"/>
          <prop k="size" v="2.4"/>
          <prop k="size_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="size_unit" v="MM"/>
          <prop k="vertical_anchor_point" v="1"/>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </symbols>
    <rotation/>
    <sizescale/>
  </renderer-v2>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerOpacity>1</layerOpacity>
  <layerGeometryType>0</layerGeometryType>
</qgis>',true);


UPDATE config_toolbox SET inputparams='[
{"widgetname":"exploitation", "label":"Exploitation id''s:","widgettype":"text","datatype":"json","layoutname":"grl_option_parameters","layoutorder":1, "placeholder":"1,2", "value":""}, 
{"widgetname":"usePsectors", "label":"Use masterplan psectors:","widgettype":"check","datatype":"boolean","layoutname":"grl_option_parameters","layoutorder":6, "value":"FALSE"}, 
{"widgetname":"updateFeature", "label":"Update feature attributes:","widgettype":"check","datatype":"boolean","layoutname":"grl_option_parameters","layoutorder":7, "value":"FALSE"}, 
{"widgetname":"updateMapZone", "label":"Update mapzone geometry method:","widgettype":"combo","datatype":"integer","layoutname":"grl_option_parameters","layoutorder":8,"comboIds":[0,1,2,3], "comboNames":["NONE", "CONCAVE POLYGON", "PIPE BUFFER", "PLOT & PIPE BUFFER"], "selectedId":"2"}, 
{"widgetname":"geomParamUpdate", "label":"Update parameter:","widgettype":"text","datatype":"float","layoutname":"grl_option_parameters","layoutorder":10, "isMandatory":false, "placeholder":"5-30", "value":""},
{"widgetname":"ignoreBrokenValves", "label":"Ignore Broken Valves:","widgettype":"check","datatype":"boolean","layoutname":"grl_option_parameters","layoutorder":11, "isMandatory":false, "placeholder":"", "value":""}
]'::json WHERE id=2706;
