/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

UPDATE sys_style SET stylevalue='<!DOCTYPE qgis PUBLIC ''http://mrcc.com/qgis.dtd'' ''SYSTEM''>
<qgis simplifyDrawingHints="1" symbologyReferenceScale="-1" maxScale="0" minScale="0" version="3.28.5-Firenze" simplifyLocal="1" hasScaleBasedVisibilityFlag="0" readOnly="0" simplifyAlgorithm="0" simplifyMaxScale="1" labelsEnabled="0" simplifyDrawingTol="1" styleCategories="AllStyleCategories">
 <flags>
  <Identifiable>1</Identifiable>
  <Removable>1</Removable>
  <Searchable>1</Searchable>
  <Private>0</Private>
 </flags>
 <temporal limitMode="0" accumulate="0" mode="0" durationField="" fixedDuration="0" startField="" startExpression="" endExpression="" durationUnit="min" enabled="0" endField="">
  <fixedRange>
   <start></start>
   <end></end>
  </fixedRange>
 </temporal>
 <elevation extrusionEnabled="0" binding="Centroid" respectLayerSymbol="1" zoffset="0" showMarkerSymbolInSurfacePlots="0" zscale="1" type="IndividualFeatures" extrusion="0" clamping="Terrain" symbology="Line">
  <data-defined-properties>
   <Option type="Map">
    <Option value="" type="QString" name="name"/>
    <Option name="properties"/>
    <Option value="collection" type="QString" name="type"/>
   </Option>
  </data-defined-properties>
  <profileLineSymbol>
   <symbol alpha="1" clip_to_extent="1" type="line" name="" force_rhr="0" frame_rate="10" is_animated="0">
    <data_defined_properties>
     <Option type="Map">
      <Option value="" type="QString" name="name"/>
      <Option name="properties"/>
      <Option value="collection" type="QString" name="type"/>
     </Option>
    </data_defined_properties>
    <layer enabled="1" pass="0" class="SimpleLine" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="align_dash_pattern"/>
      <Option value="square" type="QString" name="capstyle"/>
      <Option value="5;2" type="QString" name="customdash"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="customdash_map_unit_scale"/>
      <Option value="MM" type="QString" name="customdash_unit"/>
      <Option value="0" type="QString" name="dash_pattern_offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="dash_pattern_offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="dash_pattern_offset_unit"/>
      <Option value="0" type="QString" name="draw_inside_polygon"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="125,139,143,255" type="QString" name="line_color"/>
      <Option value="solid" type="QString" name="line_style"/>
      <Option value="0.6" type="QString" name="line_width"/>
      <Option value="MM" type="QString" name="line_width_unit"/>
      <Option value="0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="0" type="QString" name="ring_filter"/>
      <Option value="0" type="QString" name="trim_distance_end"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="trim_distance_end_map_unit_scale"/>
      <Option value="MM" type="QString" name="trim_distance_end_unit"/>
      <Option value="0" type="QString" name="trim_distance_start"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="trim_distance_start_map_unit_scale"/>
      <Option value="MM" type="QString" name="trim_distance_start_unit"/>
      <Option value="0" type="QString" name="tweak_dash_pattern_on_corners"/>
      <Option value="0" type="QString" name="use_custom_dash"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="width_map_unit_scale"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option name="properties"/>
       <Option value="collection" type="QString" name="type"/>
      </Option>
     </data_defined_properties>
    </layer>
   </symbol>
  </profileLineSymbol>
  <profileFillSymbol>
   <symbol alpha="1" clip_to_extent="1" type="fill" name="" force_rhr="0" frame_rate="10" is_animated="0">
    <data_defined_properties>
     <Option type="Map">
      <Option value="" type="QString" name="name"/>
      <Option name="properties"/>
      <Option value="collection" type="QString" name="type"/>
     </Option>
    </data_defined_properties>
    <layer enabled="1" pass="0" class="SimpleFill" locked="0">
     <Option type="Map">
      <Option value="3x:0,0,0,0,0,0" type="QString" name="border_width_map_unit_scale"/>
      <Option value="125,139,143,255" type="QString" name="color"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="0,0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="89,99,102,255" type="QString" name="outline_color"/>
      <Option value="solid" type="QString" name="outline_style"/>
      <Option value="0.2" type="QString" name="outline_width"/>
      <Option value="MM" type="QString" name="outline_width_unit"/>
      <Option value="solid" type="QString" name="style"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option name="properties"/>
       <Option value="collection" type="QString" name="type"/>
      </Option>
     </data_defined_properties>
    </layer>
   </symbol>
  </profileFillSymbol>
  <profileMarkerSymbol>
   <symbol alpha="1" clip_to_extent="1" type="marker" name="" force_rhr="0" frame_rate="10" is_animated="0">
    <data_defined_properties>
     <Option type="Map">
      <Option value="" type="QString" name="name"/>
      <Option name="properties"/>
      <Option value="collection" type="QString" name="type"/>
     </Option>
    </data_defined_properties>
    <layer enabled="1" pass="0" class="SimpleMarker" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="square" type="QString" name="cap_style"/>
      <Option value="125,139,143,255" type="QString" name="color"/>
      <Option value="1" type="QString" name="horizontal_anchor_point"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="diamond" type="QString" name="name"/>
      <Option value="0,0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="89,99,102,255" type="QString" name="outline_color"/>
      <Option value="solid" type="QString" name="outline_style"/>
      <Option value="0.2" type="QString" name="outline_width"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
      <Option value="MM" type="QString" name="outline_width_unit"/>
      <Option value="diameter" type="QString" name="scale_method"/>
      <Option value="3" type="QString" name="size"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="size_map_unit_scale"/>
      <Option value="MM" type="QString" name="size_unit"/>
      <Option value="1" type="QString" name="vertical_anchor_point"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option name="properties"/>
       <Option value="collection" type="QString" name="type"/>
      </Option>
     </data_defined_properties>
    </layer>
   </symbol>
  </profileMarkerSymbol>
 </elevation>
 <renderer-v2 referencescale="-1" symbollevels="0" type="RuleRenderer" enableorderby="0" forceraster="0">
  <rules key="{f409d5eb-3e1c-4ad5-a144-856e7968cdb5}">
   <rule key="{dff7f0b4-0963-45c8-b446-deb20b67eeda}" symbol="0" filter=" &quot;feature_type&quot;  = ''GULLY''"/>
  </rules>
  <symbols>
   <symbol alpha="1" clip_to_extent="1" type="line" name="0" force_rhr="0" frame_rate="10" is_animated="0">
    <data_defined_properties>
     <Option type="Map">
      <Option value="" type="QString" name="name"/>
      <Option name="properties"/>
      <Option value="collection" type="QString" name="type"/>
     </Option>
    </data_defined_properties>
    <layer enabled="1" pass="0" class="SimpleLine" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="align_dash_pattern"/>
      <Option value="square" type="QString" name="capstyle"/>
      <Option value="5;2" type="QString" name="customdash"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="customdash_map_unit_scale"/>
      <Option value="MM" type="QString" name="customdash_unit"/>
      <Option value="0" type="QString" name="dash_pattern_offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="dash_pattern_offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="dash_pattern_offset_unit"/>
      <Option value="0" type="QString" name="draw_inside_polygon"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="180,180,180,255" type="QString" name="line_color"/>
      <Option value="dash" type="QString" name="line_style"/>
      <Option value="0.26" type="QString" name="line_width"/>
      <Option value="MM" type="QString" name="line_width_unit"/>
      <Option value="0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="0" type="QString" name="ring_filter"/>
      <Option value="0" type="QString" name="trim_distance_end"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="trim_distance_end_map_unit_scale"/>
      <Option value="MM" type="QString" name="trim_distance_end_unit"/>
      <Option value="0" type="QString" name="trim_distance_start"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="trim_distance_start_map_unit_scale"/>
      <Option value="MM" type="QString" name="trim_distance_start_unit"/>
      <Option value="0" type="QString" name="tweak_dash_pattern_on_corners"/>
      <Option value="0" type="QString" name="use_custom_dash"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="width_map_unit_scale"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option name="properties"/>
       <Option value="collection" type="QString" name="type"/>
      </Option>
     </data_defined_properties>
    </layer>
    <layer enabled="1" pass="0" class="GeometryGenerator" locked="0">
     <Option type="Map">
      <Option value="Marker" type="QString" name="SymbolType"/>
      <Option value="end_point($geometry)" type="QString" name="geometryModifier"/>
      <Option value="MapUnit" type="QString" name="units"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option name="properties"/>
       <Option value="collection" type="QString" name="type"/>
      </Option>
     </data_defined_properties>
     <symbol alpha="1" clip_to_extent="1" type="marker" name="@0@1" force_rhr="0" frame_rate="10" is_animated="0">
      <data_defined_properties>
       <Option type="Map">
        <Option value="" type="QString" name="name"/>
        <Option name="properties"/>
        <Option value="collection" type="QString" name="type"/>
       </Option>
      </data_defined_properties>
      <layer enabled="1" pass="0" class="SimpleMarker" locked="0">
       <Option type="Map">
        <Option value="0" type="QString" name="angle"/>
        <Option value="square" type="QString" name="cap_style"/>
        <Option value="255,0,0,255" type="QString" name="color"/>
        <Option value="1" type="QString" name="horizontal_anchor_point"/>
        <Option value="bevel" type="QString" name="joinstyle"/>
        <Option value="cross2" type="QString" name="name"/>
        <Option value="0,0" type="QString" name="offset"/>
        <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
        <Option value="MM" type="QString" name="offset_unit"/>
        <Option value="180,180,180,255" type="QString" name="outline_color"/>
        <Option value="solid" type="QString" name="outline_style"/>
        <Option value="0" type="QString" name="outline_width"/>
        <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
        <Option value="MM" type="QString" name="outline_width_unit"/>
        <Option value="diameter" type="QString" name="scale_method"/>
        <Option value="1.8" type="QString" name="size"/>
        <Option value="3x:0,0,0,0,0,0" type="QString" name="size_map_unit_scale"/>
        <Option value="MM" type="QString" name="size_unit"/>
        <Option value="1" type="QString" name="vertical_anchor_point"/>
       </Option>
       <data_defined_properties>
        <Option type="Map">
         <Option value="" type="QString" name="name"/>
         <Option name="properties"/>
         <Option value="collection" type="QString" name="type"/>
        </Option>
       </data_defined_properties>
      </layer>
     </symbol>
    </layer>
   </symbol>
  </symbols>
 </renderer-v2>
 <customproperties>
  <Option type="Map">
   <Option value="0" type="QString" name="embeddedWidgets/count"/>
   <Option type="invalid" name="variableNames"/>
   <Option type="invalid" name="variableValues"/>
  </Option>
 </customproperties>
 <blendMode>0</blendMode>
 <featureBlendMode>0</featureBlendMode>
 <layerOpacity>1</layerOpacity>
 <SingleCategoryDiagramRenderer diagramType="Histogram" attributeLegend="1">
  <DiagramCategory spacingUnitScale="3x:0,0,0,0,0,0" diagramOrientation="Up" opacity="1" spacing="5" penColor="#000000" backgroundAlpha="255" rotationOffset="270" lineSizeScale="3x:0,0,0,0,0,0" minimumSize="0" penWidth="0" penAlpha="255" height="15" sizeScale="3x:0,0,0,0,0,0" labelPlacementMethod="XHeight" maxScaleDenominator="0" direction="0" lineSizeType="MM" spacingUnit="MM" barWidth="5" width="15" enabled="0" backgroundColor="#ffffff" minScaleDenominator="0" sizeType="MM" showAxis="1" scaleBasedVisibility="0" scaleDependency="Area">
   <fontProperties description="MS Shell Dlg 2,7.8,-1,5,50,0,0,0,0,0" style="" bold="0" underline="0" italic="0" strikethrough="0"/>
   <attribute field="" label="" colorOpacity="1" color="#000000"/>
   <axisSymbol>
    <symbol alpha="1" clip_to_extent="1" type="line" name="" force_rhr="0" frame_rate="10" is_animated="0">
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option name="properties"/>
       <Option value="collection" type="QString" name="type"/>
      </Option>
     </data_defined_properties>
     <layer enabled="1" pass="0" class="SimpleLine" locked="0">
      <Option type="Map">
       <Option value="0" type="QString" name="align_dash_pattern"/>
       <Option value="square" type="QString" name="capstyle"/>
       <Option value="5;2" type="QString" name="customdash"/>
       <Option value="3x:0,0,0,0,0,0" type="QString" name="customdash_map_unit_scale"/>
       <Option value="MM" type="QString" name="customdash_unit"/>
       <Option value="0" type="QString" name="dash_pattern_offset"/>
       <Option value="3x:0,0,0,0,0,0" type="QString" name="dash_pattern_offset_map_unit_scale"/>
       <Option value="MM" type="QString" name="dash_pattern_offset_unit"/>
       <Option value="0" type="QString" name="draw_inside_polygon"/>
       <Option value="bevel" type="QString" name="joinstyle"/>
       <Option value="35,35,35,255" type="QString" name="line_color"/>
       <Option value="solid" type="QString" name="line_style"/>
       <Option value="0.26" type="QString" name="line_width"/>
       <Option value="MM" type="QString" name="line_width_unit"/>
       <Option value="0" type="QString" name="offset"/>
       <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
       <Option value="MM" type="QString" name="offset_unit"/>
       <Option value="0" type="QString" name="ring_filter"/>
       <Option value="0" type="QString" name="trim_distance_end"/>
       <Option value="3x:0,0,0,0,0,0" type="QString" name="trim_distance_end_map_unit_scale"/>
       <Option value="MM" type="QString" name="trim_distance_end_unit"/>
       <Option value="0" type="QString" name="trim_distance_start"/>
       <Option value="3x:0,0,0,0,0,0" type="QString" name="trim_distance_start_map_unit_scale"/>
       <Option value="MM" type="QString" name="trim_distance_start_unit"/>
       <Option value="0" type="QString" name="tweak_dash_pattern_on_corners"/>
       <Option value="0" type="QString" name="use_custom_dash"/>
       <Option value="3x:0,0,0,0,0,0" type="QString" name="width_map_unit_scale"/>
      </Option>
      <data_defined_properties>
       <Option type="Map">
        <Option value="" type="QString" name="name"/>
        <Option name="properties"/>
        <Option value="collection" type="QString" name="type"/>
       </Option>
      </data_defined_properties>
     </layer>
    </symbol>
   </axisSymbol>
  </DiagramCategory>
 </SingleCategoryDiagramRenderer>
 <DiagramLayerSettings priority="0" showAll="1" linePlacementFlags="18" placement="2" dist="0" zIndex="0" obstacle="0">
  <properties>
   <Option type="Map">
    <Option value="" type="QString" name="name"/>
    <Option name="properties"/>
    <Option value="collection" type="QString" name="type"/>
   </Option>
  </properties>
 </DiagramLayerSettings>
 <geometryOptions removeDuplicateNodes="0" geometryPrecision="0">
  <activeChecks/>
  <checkConfiguration/>
 </geometryOptions>
 <legend type="default-vector" showLabelLegend="0"/>
 <referencedLayers/>
 <fieldConfiguration>
  <field configurationFlags="None" name="link_id">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" type="bool" name="IsMultiline"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field configurationFlags="None" name="feature_type">
   <editWidget type="ValueMap">
    <config>
     <Option type="Map">
      <Option type="Map" name="map">
       <Option value="ARC" type="QString" name="ARC"/>
       <Option value="CONNEC" type="QString" name="CONNEC"/>
       <Option value="ELEMENT" type="QString" name="ELEMENT"/>
       <Option value="GULLY" type="QString" name="GULLY"/>
       <Option value="LINK" type="QString" name="LINK"/>
       <Option value="NODE" type="QString" name="NODE"/>
      </Option>
     </Option>
    </config>
   </editWidget>
  </field>
  <field configurationFlags="None" name="feature_id">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" type="bool" name="IsMultiline"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field configurationFlags="None" name="exit_type">
   <editWidget type="ValueMap">
    <config>
     <Option type="Map">
      <Option type="Map" name="map">
       <Option value="ARC" type="QString" name="ARC"/>
       <Option value="CONNEC" type="QString" name="CONNEC"/>
       <Option value="GULLY" type="QString" name="GULLY"/>
       <Option value="NODE" type="QString" name="NODE"/>
      </Option>
     </Option>
    </config>
   </editWidget>
  </field>
  <field configurationFlags="None" name="exit_id">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" type="bool" name="IsMultiline"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field configurationFlags="None" name="state">
   <editWidget type="ValueMap">
    <config>
     <Option type="Map">
      <Option type="Map" name="map">
       <Option value="0" type="QString" name="OBSOLETE"/>
       <Option value="1" type="QString" name="OPERATIVE"/>
       <Option value="2" type="QString" name="PLANIFIED"/>
      </Option>
     </Option>
    </config>
   </editWidget>
  </field>
  <field configurationFlags="None" name="expl_id">
   <editWidget type="ValueRelation">
    <config>
     <Option type="Map">
      <Option value="False" type="QString" name="AllowNull"/>
      <Option value="" type="QString" name="FilterExpression"/>
      <Option value="expl_id" type="QString" name="Key"/>
      <Option value="v_edit_exploitation_79f9ccda_070f_4e89_b991_6f956aec4b36" type="QString" name="Layer"/>
      <Option value="name" type="QString" name="Value"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field configurationFlags="None" name="macroexpl_id">
   <editWidget type="Range">
    <config>
     <Option/>
    </config>
   </editWidget>
  </field>
  <field configurationFlags="None" name="sector_id">
   <editWidget type="ValueRelation">
    <config>
     <Option type="Map">
      <Option value="False" type="QString" name="AllowNull"/>
      <Option value="" type="QString" name="FilterExpression"/>
      <Option value="sector_id" type="QString" name="Key"/>
      <Option value="v_edit_sector_d4924986_50a2_4c42_bad8_bfff1644805d" type="QString" name="Layer"/>
      <Option value="name" type="QString" name="Value"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field configurationFlags="None" name="sector_type">
   <editWidget type="TextEdit">
    <config>
     <Option/>
    </config>
   </editWidget>
  </field>
  <field configurationFlags="None" name="macrosector_id">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" type="bool" name="IsMultiline"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field configurationFlags="None" name="muni_id">
   <editWidget type="Range">
    <config>
     <Option/>
    </config>
   </editWidget>
  </field>
  <field configurationFlags="None" name="drainzone_id">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" type="bool" name="IsMultiline"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field configurationFlags="None" name="drainzone_type">
   <editWidget type="TextEdit">
    <config>
     <Option/>
    </config>
   </editWidget>
  </field>
  <field configurationFlags="None" name="dma_id">
   <editWidget type="ValueMap">
    <config>
     <Option type="Map">
      <Option type="Map" name="map">
       <Option value="0" type="QString" name="Undefined"/>
       <Option value="1" type="QString" name="dma_01"/>
       <Option value="3" type="QString" name="dma_02"/>
      </Option>
     </Option>
    </config>
   </editWidget>
  </field>
  <field configurationFlags="None" name="macrodma_id">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" type="bool" name="IsMultiline"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field configurationFlags="None" name="exit_topelev">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" type="bool" name="IsMultiline"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field configurationFlags="None" name="exit_elev">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" type="bool" name="IsMultiline"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field configurationFlags="None" name="fluid_type">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" type="bool" name="IsMultiline"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field configurationFlags="None" name="gis_length">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" type="bool" name="IsMultiline"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field configurationFlags="None" name="sector_name">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" type="bool" name="IsMultiline"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field configurationFlags="None" name="dma_name">
   <editWidget type="TextEdit">
    <config>
     <Option/>
    </config>
   </editWidget>
  </field>
  <field configurationFlags="None" name="expl_id2">
   <editWidget type="Range">
    <config>
     <Option/>
    </config>
   </editWidget>
  </field>
  <field configurationFlags="None" name="epa_type">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" type="bool" name="IsMultiline"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field configurationFlags="None" name="is_operative">
   <editWidget type="CheckBox">
    <config>
     <Option type="Map">
      <Option value="true" type="QString" name="CheckedState"/>
      <Option value="false" type="QString" name="UncheckedState"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field configurationFlags="None" name="connecat_id">
   <editWidget type="ValueRelation">
    <config>
     <Option type="Map">
      <Option value="False" type="QString" name="AllowNull"/>
      <Option value="" type="QString" name="FilterExpression"/>
      <Option value="id" type="QString" name="Key"/>
      <Option value="cat_connec_c478157f_493b_462e_addb_2de2fbf4f4da" type="QString" name="Layer"/>
      <Option value="id" type="QString" name="Value"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field configurationFlags="None" name="workcat_id">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="False" type="QString" name="IsMultiline"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field configurationFlags="None" name="workcat_id_end">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="False" type="QString" name="IsMultiline"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field configurationFlags="None" name="builtdate">
   <editWidget type="DateTime">
    <config>
     <Option type="Map">
      <Option value="true" type="bool" name="allow_null"/>
      <Option value="true" type="bool" name="calendar_popup"/>
      <Option value="yyyy-MM-dd" type="QString" name="display_format"/>
      <Option value="yyyy-MM-dd" type="QString" name="field_format"/>
      <Option value="false" type="bool" name="field_iso_format"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field configurationFlags="None" name="enddate">
   <editWidget type="DateTime">
    <config>
     <Option type="Map">
      <Option value="true" type="bool" name="allow_null"/>
      <Option value="true" type="bool" name="calendar_popup"/>
      <Option value="yyyy-MM-dd" type="QString" name="display_format"/>
      <Option value="yyyy-MM-dd" type="QString" name="field_format"/>
      <Option value="false" type="bool" name="field_iso_format"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field configurationFlags="None" name="lastupdate">
   <editWidget type="DateTime">
    <config>
     <Option/>
    </config>
   </editWidget>
  </field>
  <field configurationFlags="None" name="lastupdate_user">
   <editWidget type="TextEdit">
    <config>
     <Option/>
    </config>
   </editWidget>
  </field>
  <field configurationFlags="None" name="uncertain">
   <editWidget type="CheckBox">
    <config>
     <Option type="Map">
      <Option value="true" type="QString" name="CheckedState"/>
      <Option value="false" type="QString" name="UncheckedState"/>
     </Option>
    </config>
   </editWidget>
  </field>
 </fieldConfiguration>
 <aliases>
  <alias field="link_id" name="link_id" index="0"/>
  <alias field="feature_type" name="feature_type" index="1"/>
  <alias field="feature_id" name="feature_id" index="2"/>
  <alias field="exit_type" name="exit_type" index="3"/>
  <alias field="exit_id" name="exit_id" index="4"/>
  <alias field="state" name="state" index="5"/>
  <alias field="expl_id" name="expl_id" index="6"/>
  <alias field="macroexpl_id" name="" index="7"/>
  <alias field="sector_id" name="sector_id" index="8"/>
  <alias field="sector_type" name="" index="9"/>
  <alias field="macrosector_id" name="macrosector_id" index="10"/>
  <alias field="muni_id" name="" index="11"/>
  <alias field="drainzone_id" name="drainzone_id" index="12"/>
  <alias field="drainzone_type" name="" index="13"/>
  <alias field="dma_id" name="dma_id" index="14"/>
  <alias field="macrodma_id" name="macrodma_id" index="15"/>
  <alias field="exit_topelev" name="exit_topelev" index="16"/>
  <alias field="exit_elev" name="exit_elev" index="17"/>
  <alias field="fluid_type" name="fluid_type" index="18"/>
  <alias field="gis_length" name="gis_length" index="19"/>
  <alias field="sector_name" name="sector_name" index="20"/>
  <alias field="dma_name" name="" index="21"/>
  <alias field="expl_id2" name="" index="22"/>
  <alias field="epa_type" name="epa_type" index="23"/>
  <alias field="is_operative" name="is_operative" index="24"/>
  <alias field="connecat_id" name="connecat_id" index="25"/>
  <alias field="workcat_id" name="workcat_id" index="26"/>
  <alias field="workcat_id_end" name="workcat_id_end" index="27"/>
  <alias field="builtdate" name="builtdate" index="28"/>
  <alias field="enddate" name="enddate" index="29"/>
  <alias field="lastupdate" name="" index="30"/>
  <alias field="lastupdate_user" name="" index="31"/>
  <alias field="uncertain" name="Uncertain" index="32"/>
 </aliases>
 <defaults>
  <default expression="" applyOnUpdate="0" field="link_id"/>
  <default expression="" applyOnUpdate="0" field="feature_type"/>
  <default expression="" applyOnUpdate="0" field="feature_id"/>
  <default expression="" applyOnUpdate="0" field="exit_type"/>
  <default expression="" applyOnUpdate="0" field="exit_id"/>
  <default expression="" applyOnUpdate="0" field="state"/>
  <default expression="" applyOnUpdate="0" field="expl_id"/>
  <default expression="" applyOnUpdate="0" field="macroexpl_id"/>
  <default expression="" applyOnUpdate="0" field="sector_id"/>
  <default expression="" applyOnUpdate="0" field="sector_type"/>
  <default expression="" applyOnUpdate="0" field="macrosector_id"/>
  <default expression="" applyOnUpdate="0" field="muni_id"/>
  <default expression="" applyOnUpdate="0" field="drainzone_id"/>
  <default expression="" applyOnUpdate="0" field="drainzone_type"/>
  <default expression="" applyOnUpdate="0" field="dma_id"/>
  <default expression="" applyOnUpdate="0" field="macrodma_id"/>
  <default expression="" applyOnUpdate="0" field="exit_topelev"/>
  <default expression="" applyOnUpdate="0" field="exit_elev"/>
  <default expression="" applyOnUpdate="0" field="fluid_type"/>
  <default expression="" applyOnUpdate="0" field="gis_length"/>
  <default expression="" applyOnUpdate="0" field="sector_name"/>
  <default expression="" applyOnUpdate="0" field="dma_name"/>
  <default expression="" applyOnUpdate="0" field="expl_id2"/>
  <default expression="" applyOnUpdate="0" field="epa_type"/>
  <default expression="" applyOnUpdate="0" field="is_operative"/>
  <default expression="" applyOnUpdate="0" field="connecat_id"/>
  <default expression="" applyOnUpdate="0" field="workcat_id"/>
  <default expression="" applyOnUpdate="0" field="workcat_id_end"/>
  <default expression="" applyOnUpdate="0" field="builtdate"/>
  <default expression="" applyOnUpdate="0" field="enddate"/>
  <default expression="" applyOnUpdate="0" field="lastupdate"/>
  <default expression="" applyOnUpdate="0" field="lastupdate_user"/>
  <default expression="" applyOnUpdate="0" field="uncertain"/>
 </defaults>
 <constraints>
  <constraint notnull_strength="2" field="link_id" constraints="3" exp_strength="0" unique_strength="1"/>
  <constraint notnull_strength="2" field="feature_type" constraints="1" exp_strength="0" unique_strength="0"/>
  <constraint notnull_strength="2" field="feature_id" constraints="1" exp_strength="0" unique_strength="0"/>
  <constraint notnull_strength="2" field="exit_type" constraints="1" exp_strength="0" unique_strength="0"/>
  <constraint notnull_strength="2" field="exit_id" constraints="1" exp_strength="0" unique_strength="0"/>
  <constraint notnull_strength="2" field="state" constraints="1" exp_strength="0" unique_strength="0"/>
  <constraint notnull_strength="2" field="expl_id" constraints="1" exp_strength="0" unique_strength="0"/>
  <constraint notnull_strength="0" field="macroexpl_id" constraints="0" exp_strength="0" unique_strength="0"/>
  <constraint notnull_strength="2" field="sector_id" constraints="1" exp_strength="0" unique_strength="0"/>
  <constraint notnull_strength="0" field="sector_type" constraints="0" exp_strength="0" unique_strength="0"/>
  <constraint notnull_strength="2" field="macrosector_id" constraints="1" exp_strength="0" unique_strength="0"/>
  <constraint notnull_strength="0" field="muni_id" constraints="0" exp_strength="0" unique_strength="0"/>
  <constraint notnull_strength="2" field="drainzone_id" constraints="1" exp_strength="0" unique_strength="0"/>
  <constraint notnull_strength="0" field="drainzone_type" constraints="0" exp_strength="0" unique_strength="0"/>
  <constraint notnull_strength="2" field="dma_id" constraints="1" exp_strength="0" unique_strength="0"/>
  <constraint notnull_strength="2" field="macrodma_id" constraints="1" exp_strength="0" unique_strength="0"/>
  <constraint notnull_strength="2" field="exit_topelev" constraints="1" exp_strength="0" unique_strength="0"/>
  <constraint notnull_strength="2" field="exit_elev" constraints="1" exp_strength="0" unique_strength="0"/>
  <constraint notnull_strength="2" field="fluid_type" constraints="1" exp_strength="0" unique_strength="0"/>
  <constraint notnull_strength="2" field="gis_length" constraints="1" exp_strength="0" unique_strength="0"/>
  <constraint notnull_strength="2" field="sector_name" constraints="1" exp_strength="0" unique_strength="0"/>
  <constraint notnull_strength="0" field="dma_name" constraints="0" exp_strength="0" unique_strength="0"/>
  <constraint notnull_strength="0" field="expl_id2" constraints="0" exp_strength="0" unique_strength="0"/>
  <constraint notnull_strength="2" field="epa_type" constraints="1" exp_strength="0" unique_strength="0"/>
  <constraint notnull_strength="2" field="is_operative" constraints="1" exp_strength="0" unique_strength="0"/>
  <constraint notnull_strength="2" field="connecat_id" constraints="1" exp_strength="0" unique_strength="0"/>
  <constraint notnull_strength="2" field="workcat_id" constraints="1" exp_strength="0" unique_strength="0"/>
  <constraint notnull_strength="2" field="workcat_id_end" constraints="1" exp_strength="0" unique_strength="0"/>
  <constraint notnull_strength="2" field="builtdate" constraints="1" exp_strength="0" unique_strength="0"/>
  <constraint notnull_strength="2" field="enddate" constraints="1" exp_strength="0" unique_strength="0"/>
  <constraint notnull_strength="0" field="lastupdate" constraints="0" exp_strength="0" unique_strength="0"/>
  <constraint notnull_strength="0" field="lastupdate_user" constraints="0" exp_strength="0" unique_strength="0"/>
  <constraint notnull_strength="2" field="uncertain" constraints="1" exp_strength="0" unique_strength="0"/>
 </constraints>
 <constraintExpressions>
  <constraint exp="" field="link_id" desc=""/>
  <constraint exp="" field="feature_type" desc=""/>
  <constraint exp="" field="feature_id" desc=""/>
  <constraint exp="" field="exit_type" desc=""/>
  <constraint exp="" field="exit_id" desc=""/>
  <constraint exp="" field="state" desc=""/>
  <constraint exp="" field="expl_id" desc=""/>
  <constraint exp="" field="macroexpl_id" desc=""/>
  <constraint exp="" field="sector_id" desc=""/>
  <constraint exp="" field="sector_type" desc=""/>
  <constraint exp="" field="macrosector_id" desc=""/>
  <constraint exp="" field="muni_id" desc=""/>
  <constraint exp="" field="drainzone_id" desc=""/>
  <constraint exp="" field="drainzone_type" desc=""/>
  <constraint exp="" field="dma_id" desc=""/>
  <constraint exp="" field="macrodma_id" desc=""/>
  <constraint exp="" field="exit_topelev" desc=""/>
  <constraint exp="" field="exit_elev" desc=""/>
  <constraint exp="" field="fluid_type" desc=""/>
  <constraint exp="" field="gis_length" desc=""/>
  <constraint exp="" field="sector_name" desc=""/>
  <constraint exp="" field="dma_name" desc=""/>
  <constraint exp="" field="expl_id2" desc=""/>
  <constraint exp="" field="epa_type" desc=""/>
  <constraint exp="" field="is_operative" desc=""/>
  <constraint exp="" field="connecat_id" desc=""/>
  <constraint exp="" field="workcat_id" desc=""/>
  <constraint exp="" field="workcat_id_end" desc=""/>
  <constraint exp="" field="builtdate" desc=""/>
  <constraint exp="" field="enddate" desc=""/>
  <constraint exp="" field="lastupdate" desc=""/>
  <constraint exp="" field="lastupdate_user" desc=""/>
  <constraint exp="" field="uncertain" desc=""/>
 </constraintExpressions>
 <expressionfields/>
 <attributeactions>
  <defaultAction value="{00000000-0000-0000-0000-000000000000}" key="Canvas"/>
 </attributeactions>
 <attributetableconfig sortExpression="" actionWidgetStyle="dropDown" sortOrder="0">
  <columns>
   <column type="field" name="link_id" width="-1" hidden="0"/>
   <column type="field" name="feature_type" width="-1" hidden="0"/>
   <column type="field" name="feature_id" width="-1" hidden="0"/>
   <column type="field" name="exit_type" width="-1" hidden="0"/>
   <column type="field" name="exit_id" width="-1" hidden="0"/>
   <column type="field" name="state" width="-1" hidden="0"/>
   <column type="field" name="expl_id" width="-1" hidden="0"/>
   <column type="field" name="macroexpl_id" width="-1" hidden="0"/>
   <column type="field" name="sector_id" width="-1" hidden="0"/>
   <column type="field" name="sector_type" width="-1" hidden="0"/>
   <column type="field" name="macrosector_id" width="-1" hidden="1"/>
   <column type="field" name="muni_id" width="-1" hidden="0"/>
   <column type="field" name="drainzone_id" width="-1" hidden="0"/>
   <column type="field" name="drainzone_type" width="-1" hidden="0"/>
   <column type="field" name="dma_id" width="-1" hidden="0"/>
   <column type="field" name="macrodma_id" width="-1" hidden="1"/>
   <column type="field" name="exit_topelev" width="-1" hidden="1"/>
   <column type="field" name="exit_elev" width="-1" hidden="1"/>
   <column type="field" name="fluid_type" width="-1" hidden="0"/>
   <column type="field" name="gis_length" width="-1" hidden="0"/>
   <column type="field" name="sector_name" width="-1" hidden="1"/>
   <column type="field" name="dma_name" width="-1" hidden="0"/>
   <column type="field" name="expl_id2" width="-1" hidden="0"/>
   <column type="field" name="epa_type" width="-1" hidden="0"/>
   <column type="field" name="is_operative" width="-1" hidden="0"/>
   <column type="field" name="connecat_id" width="-1" hidden="0"/>
   <column type="field" name="workcat_id" width="-1" hidden="0"/>
   <column type="field" name="workcat_id_end" width="-1" hidden="0"/>
   <column type="field" name="builtdate" width="-1" hidden="0"/>
   <column type="field" name="enddate" width="-1" hidden="0"/>
   <column type="field" name="lastupdate" width="-1" hidden="0"/>
   <column type="field" name="lastupdate_user" width="-1" hidden="0"/>
   <column type="field" name="uncertain" width="-1" hidden="1"/>
   <column type="actions" width="-1" hidden="1"/>
  </columns>
 </attributetableconfig>
 <conditionalstyles>
  <rowstyles/>
  <fieldstyles/>
 </conditionalstyles>
 <storedexpressions/>
 <editform tolerant="1">C:/Users/Usuario/Documents</editform>
 <editforminit/>
 <editforminitcodesource>0</editforminitcodesource>
 <editforminitfilepath>Program Files/QGIS 3.4</editforminitfilepath>
 <editforminitcode><![CDATA[# -*- coding: utf-8 -*-
"""
QGIS forms can have a Python function that is called when the form is
opened.

Use this function to add extra logic to your forms.

Enter the name of the function in the "Python Init function"
field.
An example follows:
"""
from PyQt4.QtGui import QWidget

def my_form_open(dialog, layer, feature):
  geom = feature.geometry()
  control = dialog.findChild(QWidget, "MyLineEdit")
]]></editforminitcode>
 <featformsuppress>0</featformsuppress>
 <editorlayout>generatedlayout</editorlayout>
 <editable>
  <field editable="1" name="builtdate"/>
  <field editable="0" name="connecat_id"/>
  <field editable="0" name="dma_id"/>
  <field editable="1" name="dma_name"/>
  <field editable="0" name="drainzone_id"/>
  <field editable="1" name="drainzone_type"/>
  <field editable="1" name="enddate"/>
  <field editable="0" name="epa_type"/>
  <field editable="0" name="exit_elev"/>
  <field editable="0" name="exit_id"/>
  <field editable="0" name="exit_topelev"/>
  <field editable="0" name="exit_type"/>
  <field editable="0" name="expl_id"/>
  <field editable="1" name="expl_id2"/>
  <field editable="0" name="feature_id"/>
  <field editable="0" name="feature_type"/>
  <field editable="0" name="fluid_type"/>
  <field editable="0" name="gis_length"/>
  <field editable="0" name="is_operative"/>
  <field editable="1" name="lastupdate"/>
  <field editable="1" name="lastupdate_user"/>
  <field editable="0" name="link_id"/>
  <field editable="0" name="macrodma_id"/>
  <field editable="1" name="macroexpl_id"/>
  <field editable="0" name="macrosector_id"/>
  <field editable="1" name="muni_id"/>
  <field editable="0" name="sector_id"/>
  <field editable="0" name="sector_name"/>
  <field editable="1" name="sector_type"/>
  <field editable="1" name="state"/>
  <field editable="1" name="uncertain"/>
  <field editable="1" name="workcat_id"/>
  <field editable="1" name="workcat_id_end"/>
 </editable>
 <labelOnTop>
  <field name="builtdate" labelOnTop="0"/>
  <field name="connecat_id" labelOnTop="0"/>
  <field name="dma_id" labelOnTop="0"/>
  <field name="dma_name" labelOnTop="0"/>
  <field name="drainzone_id" labelOnTop="0"/>
  <field name="drainzone_type" labelOnTop="0"/>
  <field name="enddate" labelOnTop="0"/>
  <field name="epa_type" labelOnTop="0"/>
  <field name="exit_elev" labelOnTop="0"/>
  <field name="exit_id" labelOnTop="0"/>
  <field name="exit_topelev" labelOnTop="0"/>
  <field name="exit_type" labelOnTop="0"/>
  <field name="expl_id" labelOnTop="0"/>
  <field name="expl_id2" labelOnTop="0"/>
  <field name="feature_id" labelOnTop="0"/>
  <field name="feature_type" labelOnTop="0"/>
  <field name="fluid_type" labelOnTop="0"/>
  <field name="gis_length" labelOnTop="0"/>
  <field name="is_operative" labelOnTop="0"/>
  <field name="lastupdate" labelOnTop="0"/>
  <field name="lastupdate_user" labelOnTop="0"/>
  <field name="link_id" labelOnTop="0"/>
  <field name="macrodma_id" labelOnTop="0"/>
  <field name="macroexpl_id" labelOnTop="0"/>
  <field name="macrosector_id" labelOnTop="0"/>
  <field name="muni_id" labelOnTop="0"/>
  <field name="sector_id" labelOnTop="0"/>
  <field name="sector_name" labelOnTop="0"/>
  <field name="sector_type" labelOnTop="0"/>
  <field name="state" labelOnTop="0"/>
  <field name="uncertain" labelOnTop="0"/>
  <field name="workcat_id" labelOnTop="0"/>
  <field name="workcat_id_end" labelOnTop="0"/>
 </labelOnTop>
 <reuseLastValue>
  <field reuseLastValue="0" name="builtdate"/>
  <field reuseLastValue="0" name="connecat_id"/>
  <field reuseLastValue="0" name="dma_id"/>
  <field reuseLastValue="0" name="dma_name"/>
  <field reuseLastValue="0" name="drainzone_id"/>
  <field reuseLastValue="0" name="drainzone_type"/>
  <field reuseLastValue="0" name="enddate"/>
  <field reuseLastValue="0" name="epa_type"/>
  <field reuseLastValue="0" name="exit_elev"/>
  <field reuseLastValue="0" name="exit_id"/>
  <field reuseLastValue="0" name="exit_topelev"/>
  <field reuseLastValue="0" name="exit_type"/>
  <field reuseLastValue="0" name="expl_id"/>
  <field reuseLastValue="0" name="expl_id2"/>
  <field reuseLastValue="0" name="feature_id"/>
  <field reuseLastValue="0" name="feature_type"/>
  <field reuseLastValue="0" name="fluid_type"/>
  <field reuseLastValue="0" name="gis_length"/>
  <field reuseLastValue="0" name="is_operative"/>
  <field reuseLastValue="0" name="lastupdate"/>
  <field reuseLastValue="0" name="lastupdate_user"/>
  <field reuseLastValue="0" name="link_id"/>
  <field reuseLastValue="0" name="macrodma_id"/>
  <field reuseLastValue="0" name="macroexpl_id"/>
  <field reuseLastValue="0" name="macrosector_id"/>
  <field reuseLastValue="0" name="muni_id"/>
  <field reuseLastValue="0" name="sector_id"/>
  <field reuseLastValue="0" name="sector_name"/>
  <field reuseLastValue="0" name="sector_type"/>
  <field reuseLastValue="0" name="state"/>
  <field reuseLastValue="0" name="uncertain"/>
  <field reuseLastValue="0" name="workcat_id"/>
  <field reuseLastValue="0" name="workcat_id_end"/>
 </reuseLastValue>
 <dataDefinedFieldProperties/>
 <widgets/>
 <previewExpression>"sector_name"</previewExpression>
 <mapTip></mapTip>
 <layerGeometryType>1</layerGeometryType>
</qgis>
' WHERE styleconfig_id=102 and layername='v_edit_link';



INSERT INTO sys_style (layername, styleconfig_id, styletype, active, stylevalue) VALUES
('v_edit_gully', 102, 'qml', true,
'<!DOCTYPE qgis PUBLIC ''http://mrcc.com/qgis.dtd'' ''SYSTEM''>
<qgis simplifyMaxScale="1" hasScaleBasedVisibilityFlag="1" readOnly="0" maxScale="0" simplifyDrawingTol="1" simplifyAlgorithm="0" symbologyReferenceScale="-1" version="3.28.5-Firenze" styleCategories="AllStyleCategories" minScale="2500" labelsEnabled="0" simplifyLocal="1" simplifyDrawingHints="0">
 <flags>
  <Identifiable>1</Identifiable>
  <Removable>1</Removable>
  <Searchable>1</Searchable>
  <Private>0</Private>
 </flags>
 <temporal limitMode="0" endField="" fixedDuration="0" mode="0" startExpression="" enabled="0" endExpression="" durationField="" accumulate="0" durationUnit="min" startField="">
  <fixedRange>
   <start></start>
   <end></end>
  </fixedRange>
 </temporal>
 <elevation binding="Centroid" showMarkerSymbolInSurfacePlots="0" zoffset="0" symbology="Line" extrusionEnabled="0" respectLayerSymbol="1" zscale="1" extrusion="0" clamping="Terrain" type="IndividualFeatures">
  <data-defined-properties>
   <Option type="Map">
    <Option value="" name="name" type="QString"/>
    <Option name="properties"/>
    <Option value="collection" name="type" type="QString"/>
   </Option>
  </data-defined-properties>
  <profileLineSymbol>
   <symbol clip_to_extent="1" is_animated="0" frame_rate="10" name="" type="line" force_rhr="0" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option value="" name="name" type="QString"/>
      <Option name="properties"/>
      <Option value="collection" name="type" type="QString"/>
     </Option>
    </data_defined_properties>
    <layer pass="0" locked="0" enabled="1" class="SimpleLine">
     <Option type="Map">
      <Option value="0" name="align_dash_pattern" type="QString"/>
      <Option value="square" name="capstyle" type="QString"/>
      <Option value="5;2" name="customdash" type="QString"/>
      <Option value="3x:0,0,0,0,0,0" name="customdash_map_unit_scale" type="QString"/>
      <Option value="MM" name="customdash_unit" type="QString"/>
      <Option value="0" name="dash_pattern_offset" type="QString"/>
      <Option value="3x:0,0,0,0,0,0" name="dash_pattern_offset_map_unit_scale" type="QString"/>
      <Option value="MM" name="dash_pattern_offset_unit" type="QString"/>
      <Option value="0" name="draw_inside_polygon" type="QString"/>
      <Option value="bevel" name="joinstyle" type="QString"/>
      <Option value="190,207,80,255" name="line_color" type="QString"/>
      <Option value="solid" name="line_style" type="QString"/>
      <Option value="0.6" name="line_width" type="QString"/>
      <Option value="MM" name="line_width_unit" type="QString"/>
      <Option value="0" name="offset" type="QString"/>
      <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
      <Option value="MM" name="offset_unit" type="QString"/>
      <Option value="0" name="ring_filter" type="QString"/>
      <Option value="0" name="trim_distance_end" type="QString"/>
      <Option value="3x:0,0,0,0,0,0" name="trim_distance_end_map_unit_scale" type="QString"/>
      <Option value="MM" name="trim_distance_end_unit" type="QString"/>
      <Option value="0" name="trim_distance_start" type="QString"/>
      <Option value="3x:0,0,0,0,0,0" name="trim_distance_start_map_unit_scale" type="QString"/>
      <Option value="MM" name="trim_distance_start_unit" type="QString"/>
      <Option value="0" name="tweak_dash_pattern_on_corners" type="QString"/>
      <Option value="0" name="use_custom_dash" type="QString"/>
      <Option value="3x:0,0,0,0,0,0" name="width_map_unit_scale" type="QString"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" name="name" type="QString"/>
       <Option name="properties"/>
       <Option value="collection" name="type" type="QString"/>
      </Option>
     </data_defined_properties>
    </layer>
   </symbol>
  </profileLineSymbol>
  <profileFillSymbol>
   <symbol clip_to_extent="1" is_animated="0" frame_rate="10" name="" type="fill" force_rhr="0" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option value="" name="name" type="QString"/>
      <Option name="properties"/>
      <Option value="collection" name="type" type="QString"/>
     </Option>
    </data_defined_properties>
    <layer pass="0" locked="0" enabled="1" class="SimpleFill">
     <Option type="Map">
      <Option value="3x:0,0,0,0,0,0" name="border_width_map_unit_scale" type="QString"/>
      <Option value="190,207,80,255" name="color" type="QString"/>
      <Option value="bevel" name="joinstyle" type="QString"/>
      <Option value="0,0" name="offset" type="QString"/>
      <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
      <Option value="MM" name="offset_unit" type="QString"/>
      <Option value="136,148,57,255" name="outline_color" type="QString"/>
      <Option value="solid" name="outline_style" type="QString"/>
      <Option value="0.2" name="outline_width" type="QString"/>
      <Option value="MM" name="outline_width_unit" type="QString"/>
      <Option value="solid" name="style" type="QString"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" name="name" type="QString"/>
       <Option name="properties"/>
       <Option value="collection" name="type" type="QString"/>
      </Option>
     </data_defined_properties>
    </layer>
   </symbol>
  </profileFillSymbol>
  <profileMarkerSymbol>
   <symbol clip_to_extent="1" is_animated="0" frame_rate="10" name="" type="marker" force_rhr="0" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option value="" name="name" type="QString"/>
      <Option name="properties"/>
      <Option value="collection" name="type" type="QString"/>
     </Option>
    </data_defined_properties>
    <layer pass="0" locked="0" enabled="1" class="SimpleMarker">
     <Option type="Map">
      <Option value="0" name="angle" type="QString"/>
      <Option value="square" name="cap_style" type="QString"/>
      <Option value="190,207,80,255" name="color" type="QString"/>
      <Option value="1" name="horizontal_anchor_point" type="QString"/>
      <Option value="bevel" name="joinstyle" type="QString"/>
      <Option value="diamond" name="name" type="QString"/>
      <Option value="0,0" name="offset" type="QString"/>
      <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
      <Option value="MM" name="offset_unit" type="QString"/>
      <Option value="136,148,57,255" name="outline_color" type="QString"/>
      <Option value="solid" name="outline_style" type="QString"/>
      <Option value="0.2" name="outline_width" type="QString"/>
      <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
      <Option value="MM" name="outline_width_unit" type="QString"/>
      <Option value="diameter" name="scale_method" type="QString"/>
      <Option value="3" name="size" type="QString"/>
      <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
      <Option value="MM" name="size_unit" type="QString"/>
      <Option value="1" name="vertical_anchor_point" type="QString"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" name="name" type="QString"/>
       <Option name="properties"/>
       <Option value="collection" name="type" type="QString"/>
      </Option>
     </data_defined_properties>
    </layer>
   </symbol>
  </profileMarkerSymbol>
 </elevation>
 <renderer-v2 attr="inp_type" forceraster="0" type="categorizedSymbol" enableorderby="0" symbollevels="0" referencescale="-1">
  <categories>
   <category symbol="0" render="true" value="GULLY" label="GULLY" type="string"/>
   <category symbol="1" render="true" value="" label="NOT USED" type="string"/>
  </categories>
  <symbols>
   <symbol clip_to_extent="1" is_animated="0" frame_rate="10" name="0" type="marker" force_rhr="0" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option value="" name="name" type="QString"/>
      <Option name="properties"/>
      <Option value="collection" name="type" type="QString"/>
     </Option>
    </data_defined_properties>
    <layer pass="0" locked="0" enabled="1" class="SimpleMarker">
     <Option type="Map">
      <Option value="0" name="angle" type="QString"/>
      <Option value="square" name="cap_style" type="QString"/>
      <Option value="255,255,255,0" name="color" type="QString"/>
      <Option value="1" name="horizontal_anchor_point" type="QString"/>
      <Option value="bevel" name="joinstyle" type="QString"/>
      <Option value="circle" name="name" type="QString"/>
      <Option value="0,0" name="offset" type="QString"/>
      <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
      <Option value="MM" name="offset_unit" type="QString"/>
      <Option value="65,62,62,255" name="outline_color" type="QString"/>
      <Option value="solid" name="outline_style" type="QString"/>
      <Option value="0" name="outline_width" type="QString"/>
      <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
      <Option value="MM" name="outline_width_unit" type="QString"/>
      <Option value="diameter" name="scale_method" type="QString"/>
      <Option value="1.6" name="size" type="QString"/>
      <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
      <Option value="MM" name="size_unit" type="QString"/>
      <Option value="1" name="vertical_anchor_point" type="QString"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" name="name" type="QString"/>
       <Option name="properties"/>
       <Option value="collection" name="type" type="QString"/>
      </Option>
     </data_defined_properties>
    </layer>
   </symbol>
   <symbol clip_to_extent="1" is_animated="0" frame_rate="10" name="1" type="marker" force_rhr="0" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option value="" name="name" type="QString"/>
      <Option name="properties"/>
      <Option value="collection" name="type" type="QString"/>
     </Option>
    </data_defined_properties>
    <layer pass="0" locked="0" enabled="1" class="SimpleMarker">
     <Option type="Map">
      <Option value="0" name="angle" type="QString"/>
      <Option value="square" name="cap_style" type="QString"/>
      <Option value="215,215,215,255" name="color" type="QString"/>
      <Option value="1" name="horizontal_anchor_point" type="QString"/>
      <Option value="bevel" name="joinstyle" type="QString"/>
      <Option value="circle" name="name" type="QString"/>
      <Option value="0,0" name="offset" type="QString"/>
      <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
      <Option value="MM" name="offset_unit" type="QString"/>
      <Option value="215,215,215,255" name="outline_color" type="QString"/>
      <Option value="solid" name="outline_style" type="QString"/>
      <Option value="0.4" name="outline_width" type="QString"/>
      <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
      <Option value="MM" name="outline_width_unit" type="QString"/>
      <Option value="diameter" name="scale_method" type="QString"/>
      <Option value="1.6" name="size" type="QString"/>
      <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
      <Option value="MM" name="size_unit" type="QString"/>
      <Option value="1" name="vertical_anchor_point" type="QString"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" name="name" type="QString"/>
       <Option name="properties"/>
       <Option value="collection" name="type" type="QString"/>
      </Option>
     </data_defined_properties>
    </layer>
   </symbol>
  </symbols>
  <source-symbol>
   <symbol clip_to_extent="1" is_animated="0" frame_rate="10" name="0" type="marker" force_rhr="0" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option value="" name="name" type="QString"/>
      <Option name="properties"/>
      <Option value="collection" name="type" type="QString"/>
     </Option>
    </data_defined_properties>
    <layer pass="0" locked="0" enabled="1" class="SimpleMarker">
     <Option type="Map">
      <Option value="0" name="angle" type="QString"/>
      <Option value="square" name="cap_style" type="QString"/>
      <Option value="255,255,255,0" name="color" type="QString"/>
      <Option value="1" name="horizontal_anchor_point" type="QString"/>
      <Option value="bevel" name="joinstyle" type="QString"/>
      <Option value="circle" name="name" type="QString"/>
      <Option value="0,0" name="offset" type="QString"/>
      <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
      <Option value="MM" name="offset_unit" type="QString"/>
      <Option value="65,62,62,255" name="outline_color" type="QString"/>
      <Option value="solid" name="outline_style" type="QString"/>
      <Option value="0" name="outline_width" type="QString"/>
      <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
      <Option value="MM" name="outline_width_unit" type="QString"/>
      <Option value="diameter" name="scale_method" type="QString"/>
      <Option value="1.6" name="size" type="QString"/>
      <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
      <Option value="MM" name="size_unit" type="QString"/>
      <Option value="1" name="vertical_anchor_point" type="QString"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" name="name" type="QString"/>
       <Option name="properties"/>
       <Option value="collection" name="type" type="QString"/>
      </Option>
     </data_defined_properties>
    </layer>
   </symbol>
  </source-symbol>
  <colorramp name="[source]" type="randomcolors">
   <Option/>
  </colorramp>
  <rotation/>
  <sizescale/>
 </renderer-v2>
 <customproperties>
  <Option type="Map">
   <Option name="dualview/previewExpressions" type="List">
    <Option value="&quot;gully_id&quot;" type="QString"/>
   </Option>
   <Option value="0" name="embeddedWidgets/count" type="QString"/>
   <Option name="variableNames"/>
   <Option name="variableValues"/>
  </Option>
 </customproperties>
 <blendMode>0</blendMode>
 <featureBlendMode>0</featureBlendMode>
 <layerOpacity>1</layerOpacity>
 <SingleCategoryDiagramRenderer diagramType="Histogram" attributeLegend="1">
  <DiagramCategory barWidth="5" showAxis="0" sizeType="MM" lineSizeType="MM" lineSizeScale="3x:0,0,0,0,0,0" scaleDependency="Area" width="15" backgroundAlpha="255" penColor="#000000" height="15" diagramOrientation="Up" penWidth="0" labelPlacementMethod="XHeight" scaleBasedVisibility="0" spacingUnit="MM" spacingUnitScale="3x:0,0,0,0,0,0" minimumSize="0" rotationOffset="270" penAlpha="255" minScaleDenominator="0" spacing="0" backgroundColor="#ffffff" opacity="1" sizeScale="3x:0,0,0,0,0,0" maxScaleDenominator="1e+08" enabled="0" direction="1">
   <fontProperties strikethrough="0" italic="0" underline="0" bold="0" description="MS Shell Dlg 2,8.25,-1,5,50,0,0,0,0,0" style=""/>
   <attribute field="" label="" colorOpacity="1" color="#000000"/>
   <axisSymbol>
    <symbol clip_to_extent="1" is_animated="0" frame_rate="10" name="" type="line" force_rhr="0" alpha="1">
     <data_defined_properties>
      <Option type="Map">
       <Option value="" name="name" type="QString"/>
       <Option name="properties"/>
       <Option value="collection" name="type" type="QString"/>
      </Option>
     </data_defined_properties>
     <layer pass="0" locked="0" enabled="1" class="SimpleLine">
      <Option type="Map">
       <Option value="0" name="align_dash_pattern" type="QString"/>
       <Option value="square" name="capstyle" type="QString"/>
       <Option value="5;2" name="customdash" type="QString"/>
       <Option value="3x:0,0,0,0,0,0" name="customdash_map_unit_scale" type="QString"/>
       <Option value="MM" name="customdash_unit" type="QString"/>
       <Option value="0" name="dash_pattern_offset" type="QString"/>
       <Option value="3x:0,0,0,0,0,0" name="dash_pattern_offset_map_unit_scale" type="QString"/>
       <Option value="MM" name="dash_pattern_offset_unit" type="QString"/>
       <Option value="0" name="draw_inside_polygon" type="QString"/>
       <Option value="bevel" name="joinstyle" type="QString"/>
       <Option value="35,35,35,255" name="line_color" type="QString"/>
       <Option value="solid" name="line_style" type="QString"/>
       <Option value="0.26" name="line_width" type="QString"/>
       <Option value="MM" name="line_width_unit" type="QString"/>
       <Option value="0" name="offset" type="QString"/>
       <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
       <Option value="MM" name="offset_unit" type="QString"/>
       <Option value="0" name="ring_filter" type="QString"/>
       <Option value="0" name="trim_distance_end" type="QString"/>
       <Option value="3x:0,0,0,0,0,0" name="trim_distance_end_map_unit_scale" type="QString"/>
       <Option value="MM" name="trim_distance_end_unit" type="QString"/>
       <Option value="0" name="trim_distance_start" type="QString"/>
       <Option value="3x:0,0,0,0,0,0" name="trim_distance_start_map_unit_scale" type="QString"/>
       <Option value="MM" name="trim_distance_start_unit" type="QString"/>
       <Option value="0" name="tweak_dash_pattern_on_corners" type="QString"/>
       <Option value="0" name="use_custom_dash" type="QString"/>
       <Option value="3x:0,0,0,0,0,0" name="width_map_unit_scale" type="QString"/>
      </Option>
      <data_defined_properties>
       <Option type="Map">
        <Option value="" name="name" type="QString"/>
        <Option name="properties"/>
        <Option value="collection" name="type" type="QString"/>
       </Option>
      </data_defined_properties>
     </layer>
    </symbol>
   </axisSymbol>
  </DiagramCategory>
 </SingleCategoryDiagramRenderer>
 <DiagramLayerSettings linePlacementFlags="18" obstacle="0" placement="0" dist="0" priority="0" showAll="1" zIndex="0">
  <properties>
   <Option type="Map">
    <Option value="" name="name" type="QString"/>
    <Option name="properties"/>
    <Option value="collection" name="type" type="QString"/>
   </Option>
  </properties>
 </DiagramLayerSettings>
 <geometryOptions removeDuplicateNodes="0" geometryPrecision="0">
  <activeChecks/>
  <checkConfiguration/>
 </geometryOptions>
 <legend type="default-vector" showLabelLegend="0"/>
 <referencedLayers/>
 <fieldConfiguration>
  <field name="gully_id" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="code" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="top_elev" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="ymax" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="sandbox" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="matcat_id" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="gully_type" configurationFlags="None">
   <editWidget type="ValueRelation">
    <config>
     <Option type="Map">
      <Option value="False" name="AllowNull" type="QString"/>
      <Option value="" name="FilterExpression" type="QString"/>
      <Option value="id" name="Key" type="QString"/>
      <Option value="v_edit_cat_feature_gully_8979adc2_9078_461e_a337_347fb0723b32" name="Layer" type="QString"/>
      <Option value="id" name="Value" type="QString"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="sys_type" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option/>
    </config>
   </editWidget>
  </field>
  <field name="gratecat_id" configurationFlags="None">
   <editWidget type="ValueRelation">
    <config>
     <Option type="Map">
      <Option value="False" name="AllowNull" type="QString"/>
      <Option value="" name="FilterExpression" type="QString"/>
      <Option value="id" name="Key" type="QString"/>
      <Option value="cat_grate_c32f087c_3368_4aa6_966e_1ff0e19c5894" name="Layer" type="QString"/>
      <Option value="id" name="Value" type="QString"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="cat_grate_matcat" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="units" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="groove" configurationFlags="None">
   <editWidget type="CheckBox">
    <config>
     <Option type="Map">
      <Option value="true" name="CheckedState" type="QString"/>
      <Option value="false" name="UncheckedState" type="QString"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="groove_height" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="groove_length" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="siphon" configurationFlags="None">
   <editWidget type="CheckBox">
    <config>
     <Option type="Map">
      <Option value="true" name="CheckedState" type="QString"/>
      <Option value="false" name="UncheckedState" type="QString"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="connec_arccat_id" configurationFlags="None">
   <editWidget type="ValueRelation">
    <config>
     <Option type="Map">
      <Option value="False" name="AllowNull" type="QString"/>
      <Option value="" name="FilterExpression" type="QString"/>
      <Option value="id" name="Key" type="QString"/>
      <Option value="cat_connec_c478157f_493b_462e_addb_2de2fbf4f4da" name="Layer" type="QString"/>
      <Option value="id" name="Value" type="QString"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="connec_length" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="connec_depth" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="connec_matcat_id" configurationFlags="None">
   <editWidget type="ValueMap">
    <config>
     <Option type="Map">
      <Option name="map" type="Map">
       <Option value="" name="" type="QString"/>
       <Option value="Brick" name="Brick" type="QString"/>
       <Option value="Concret" name="Concret" type="QString"/>
       <Option value="PEAD" name="PEAD" type="QString"/>
       <Option value="PEC" name="PEC" type="QString"/>
       <Option value="PVC" name="PVC" type="QString"/>
       <Option value="Unknown" name="Unknown" type="QString"/>
       <Option value="Virtual" name="Virtual" type="QString"/>
      </Option>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="connec_y1" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="connec_y2" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="grate_width" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option/>
    </config>
   </editWidget>
  </field>
  <field name="grate_length" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option/>
    </config>
   </editWidget>
  </field>
  <field name="arc_id" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="False" name="IsMultiline" type="QString"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="epa_type" configurationFlags="None">
   <editWidget type="ValueMap">
    <config>
     <Option type="Map">
      <Option name="map" type="Map">
       <Option value="GULLY" name="GULLY" type="QString"/>
       <Option value="UNDEFINED" name="UNDEFINED" type="QString"/>
      </Option>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="inp_type" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option/>
    </config>
   </editWidget>
  </field>
  <field name="state" configurationFlags="None">
   <editWidget type="ValueMap">
    <config>
     <Option type="Map">
      <Option name="map" type="Map">
       <Option value="0" name="OBSOLETE" type="QString"/>
       <Option value="1" name="OPERATIVE" type="QString"/>
       <Option value="2" name="PLANIFIED" type="QString"/>
      </Option>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="state_type" configurationFlags="None">
   <editWidget type="ValueMap">
    <config>
     <Option type="Map">
      <Option name="map" type="Map">
       <Option value="99" name="FICTICIUS" type="QString"/>
       <Option value="1" name="OBSOLETE" type="QString"/>
       <Option value="2" name="OPERATIVE" type="QString"/>
       <Option value="3" name="PLANIFIED" type="QString"/>
       <Option value="5" name="PROVISIONAL" type="QString"/>
       <Option value="4" name="RECONSTRUCT" type="QString"/>
      </Option>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="expl_id" configurationFlags="None">
   <editWidget type="ValueRelation">
    <config>
     <Option type="Map">
      <Option value="False" name="AllowNull" type="QString"/>
      <Option value="" name="FilterExpression" type="QString"/>
      <Option value="expl_id" name="Key" type="QString"/>
      <Option value="v_edit_exploitation_79f9ccda_070f_4e89_b991_6f956aec4b36" name="Layer" type="QString"/>
      <Option value="name" name="Value" type="QString"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="macroexpl_id" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="sector_id" configurationFlags="None">
   <editWidget type="ValueRelation">
    <config>
     <Option type="Map">
      <Option value="False" name="AllowNull" type="QString"/>
      <Option value="" name="FilterExpression" type="QString"/>
      <Option value="sector_id" name="Key" type="QString"/>
      <Option value="v_edit_sector_d4924986_50a2_4c42_bad8_bfff1644805d" name="Layer" type="QString"/>
      <Option value="name" name="Value" type="QString"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="sector_type" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option/>
    </config>
   </editWidget>
  </field>
  <field name="macrosector_id" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="drainzone_id" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="drainzone_type" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option/>
    </config>
   </editWidget>
  </field>
  <field name="dma_id" configurationFlags="None">
   <editWidget type="ValueMap">
    <config>
     <Option type="Map">
      <Option name="map" type="Map">
       <Option value="0" name="Undefined" type="QString"/>
       <Option value="1" name="dma_01" type="QString"/>
       <Option value="3" name="dma_02" type="QString"/>
      </Option>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="macrodma_id" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="annotation" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="observ" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="comment" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="soilcat_id" configurationFlags="None">
   <editWidget type="ValueMap">
    <config>
     <Option type="Map">
      <Option name="map" type="Map">
       <Option value="" name="" type="QString"/>
       <Option value="soil1" name="soil1" type="QString"/>
       <Option value="soil2" name="soil2" type="QString"/>
       <Option value="soil3" name="soil3" type="QString"/>
      </Option>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="function_type" configurationFlags="None">
   <editWidget type="ValueMap">
    <config>
     <Option type="Map">
      <Option name="map" type="Map">
       <Option value="" name="" type="QString"/>
       <Option value="St. Function" name="St. Function" type="QString"/>
      </Option>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="category_type" configurationFlags="None">
   <editWidget type="ValueMap">
    <config>
     <Option type="Map">
      <Option name="map" type="Map">
       <Option value="" name="" type="QString"/>
       <Option value="St. Category" name="St. Category" type="QString"/>
      </Option>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="fluid_type" configurationFlags="None">
   <editWidget type="ValueMap">
    <config>
     <Option type="Map">
      <Option name="map" type="Map">
       <Option value="" name="" type="QString"/>
       <Option value="St. Fluid" name="St. Fluid" type="QString"/>
      </Option>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="location_type" configurationFlags="None">
   <editWidget type="ValueMap">
    <config>
     <Option type="Map">
      <Option name="map" type="Map">
       <Option value="" name="" type="QString"/>
       <Option value="St. Location" name="St. Location" type="QString"/>
      </Option>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="workcat_id" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="False" name="IsMultiline" type="QString"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="workcat_id_end" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="False" name="IsMultiline" type="QString"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="workcat_id_plan" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="False" name="IsMultiline" type="QString"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="buildercat_id" configurationFlags="None">
   <editWidget type="ValueMap">
    <config>
     <Option type="Map">
      <Option name="map" type="Map">
       <Option value="" name="" type="QString"/>
       <Option value="builder1" name="builder1" type="QString"/>
       <Option value="builder2" name="builder2" type="QString"/>
       <Option value="builder3" name="builder3" type="QString"/>
      </Option>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="builtdate" configurationFlags="None">
   <editWidget type="DateTime">
    <config>
     <Option type="Map">
      <Option value="true" name="allow_null" type="bool"/>
      <Option value="true" name="calendar_popup" type="bool"/>
      <Option value="yyyy-MM-dd" name="display_format" type="QString"/>
      <Option value="yyyy-MM-dd" name="field_format" type="QString"/>
      <Option value="false" name="field_iso_format" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="enddate" configurationFlags="None">
   <editWidget type="DateTime">
    <config>
     <Option type="Map">
      <Option value="true" name="allow_null" type="bool"/>
      <Option value="true" name="calendar_popup" type="bool"/>
      <Option value="yyyy-MM-dd" name="display_format" type="QString"/>
      <Option value="yyyy-MM-dd" name="field_format" type="QString"/>
      <Option value="false" name="field_iso_format" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="ownercat_id" configurationFlags="None">
   <editWidget type="ValueMap">
    <config>
     <Option type="Map">
      <Option name="map" type="Map">
       <Option value="" name="" type="QString"/>
       <Option value="owner1" name="owner1" type="QString"/>
       <Option value="owner2" name="owner2" type="QString"/>
       <Option value="owner3" name="owner3" type="QString"/>
      </Option>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="muni_id" configurationFlags="None">
   <editWidget type="ValueMap">
    <config>
     <Option type="Map">
      <Option name="map" type="Map">
       <Option value="1" name="Sant Boi del Llobregat" type="QString"/>
       <Option value="2" name="Sant Esteve de les Roures" type="QString"/>
       <Option value="0" name="Undefined" type="QString"/>
      </Option>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="postcode" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="district_id" configurationFlags="None">
   <editWidget type="ValueMap">
    <config>
     <Option type="Map">
      <Option name="map" type="Map">
       <Option value="1" name="Camps Blancs" type="QString"/>
       <Option value="2" name="Marianao" type="QString"/>
      </Option>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="streetname" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="False" name="IsMultiline" type="QString"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="postnumber" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="False" name="IsMultiline" type="QString"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="postcomplement" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="streetname2" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="False" name="IsMultiline" type="QString"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="postnumber2" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="False" name="IsMultiline" type="QString"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="postcomplement2" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="region_id" configurationFlags="None">
   <editWidget type="ValueMap">
    <config>
     <Option type="Map">
      <Option name="map" type="Map">
       <Option value="" name="" type="QString"/>
       <Option value="1" name="Baix Llobregat" type="QString"/>
      </Option>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="province_id" configurationFlags="None">
   <editWidget type="ValueMap">
    <config>
     <Option type="Map">
      <Option name="map" type="Map">
       <Option value="" name="" type="QString"/>
       <Option value="1" name="Barcelona" type="QString"/>
      </Option>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="descript" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="svg" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="rotation" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="link" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="False" name="IsMultiline" type="QString"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="verified" configurationFlags="None">
   <editWidget type="ValueMap">
    <config>
     <Option type="Map">
      <Option name="map" type="Map">
       <Option value="" name="" type="QString"/>
       <Option value="2" name="IGNORE CHECK" type="QString"/>
       <Option value="0" name="TO REVIEW" type="QString"/>
       <Option value="1" name="VERIFIED" type="QString"/>
      </Option>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="undelete" configurationFlags="None">
   <editWidget type="CheckBox">
    <config>
     <Option type="Map">
      <Option value="true" name="CheckedState" type="QString"/>
      <Option value="false" name="UncheckedState" type="QString"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="label" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="label_x" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="label_y" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="label_rotation" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="label_quadrant" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="publish" configurationFlags="None">
   <editWidget type="CheckBox">
    <config>
     <Option type="Map">
      <Option value="true" name="CheckedState" type="QString"/>
      <Option value="false" name="UncheckedState" type="QString"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="inventory" configurationFlags="None">
   <editWidget type="CheckBox">
    <config>
     <Option type="Map">
      <Option value="true" name="CheckedState" type="QString"/>
      <Option value="false" name="UncheckedState" type="QString"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="uncertain" configurationFlags="None">
   <editWidget type="CheckBox">
    <config>
     <Option type="Map">
      <Option value="true" name="CheckedState" type="QString"/>
      <Option value="false" name="UncheckedState" type="QString"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="num_value" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="pjoint_id" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="pjoint_type" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="asset_id" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="gratecat2_id" configurationFlags="None">
   <editWidget type="ValueRelation">
    <config>
     <Option type="Map">
      <Option value="False" name="AllowNull" type="QString"/>
      <Option value="" name="FilterExpression" type="QString"/>
      <Option value="id" name="Key" type="QString"/>
      <Option value="cat_grate_c32f087c_3368_4aa6_966e_1ff0e19c5894" name="Layer" type="QString"/>
      <Option value="id" name="Value" type="QString"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="units_placement" configurationFlags="None">
   <editWidget type="ValueMap">
    <config>
     <Option type="Map">
      <Option name="map" type="Map">
       <Option value="" name="" type="QString"/>
       <Option value="LENGTH-SIDE" name="LENGTH-SIDE" type="QString"/>
       <Option value="WIDTH-SIDE" name="WIDTH-SIDE" type="QString"/>
      </Option>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="expl_id2" configurationFlags="None">
   <editWidget type="ValueMap">
    <config>
     <Option type="Map">
      <Option name="map" type="Map">
       <Option value="" name="" type="QString"/>
       <Option value="1" name="expl_01" type="QString"/>
       <Option value="2" name="expl_02" type="QString"/>
      </Option>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="is_operative" configurationFlags="None">
   <editWidget type="CheckBox">
    <config>
     <Option/>
    </config>
   </editWidget>
  </field>
  <field name="minsector_id" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="macrominsector_id" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="adate" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="adescript" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="siphon_type" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="odorflap" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="placement_type" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="access_type" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="tstamp" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="insert_user" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option/>
    </config>
   </editWidget>
  </field>
  <field name="lastupdate" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="lastupdate_user" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
 </fieldConfiguration>
 <aliases>
  <alias field="gully_id" index="0" name="gully_id"/>
  <alias field="code" index="1" name="code"/>
  <alias field="top_elev" index="2" name="top_elev"/>
  <alias field="ymax" index="3" name="ymax"/>
  <alias field="sandbox" index="4" name="sandbox"/>
  <alias field="matcat_id" index="5" name="matcat_id"/>
  <alias field="gully_type" index="6" name="gully_type"/>
  <alias field="sys_type" index="7" name=""/>
  <alias field="gratecat_id" index="8" name="gratecat_id"/>
  <alias field="cat_grate_matcat" index="9" name="cat_grate_matcat"/>
  <alias field="units" index="10" name="units"/>
  <alias field="groove" index="11" name="groove"/>
  <alias field="groove_height" index="12" name="groove height"/>
  <alias field="groove_length" index="13" name="groove length"/>
  <alias field="siphon" index="14" name="siphon"/>
  <alias field="connec_arccat_id" index="15" name="connec_arccat_id"/>
  <alias field="connec_length" index="16" name="connec_length"/>
  <alias field="connec_depth" index="17" name="connec_depth"/>
  <alias field="connec_matcat_id" index="18" name="connec_matcat_id"/>
  <alias field="connec_y1" index="19" name="connec_y1"/>
  <alias field="connec_y2" index="20" name="connec_y2"/>
  <alias field="grate_width" index="21" name=""/>
  <alias field="grate_length" index="22" name=""/>
  <alias field="arc_id" index="23" name="arc_id"/>
  <alias field="epa_type" index="24" name="epa_type"/>
  <alias field="inp_type" index="25" name=""/>
  <alias field="state" index="26" name="state"/>
  <alias field="state_type" index="27" name="state_type"/>
  <alias field="expl_id" index="28" name="expl_id"/>
  <alias field="macroexpl_id" index="29" name="Macroexploitation"/>
  <alias field="sector_id" index="30" name="sector_id"/>
  <alias field="sector_type" index="31" name=""/>
  <alias field="macrosector_id" index="32" name="macrosector_id"/>
  <alias field="drainzone_id" index="33" name="drainzone_id"/>
  <alias field="drainzone_type" index="34" name=""/>
  <alias field="dma_id" index="35" name="dma_id"/>
  <alias field="macrodma_id" index="36" name="macrodma_id"/>
  <alias field="annotation" index="37" name="annotation"/>
  <alias field="observ" index="38" name="observ"/>
  <alias field="comment" index="39" name="comment"/>
  <alias field="soilcat_id" index="40" name="soilcat_id"/>
  <alias field="function_type" index="41" name="function_type"/>
  <alias field="category_type" index="42" name="category_type"/>
  <alias field="fluid_type" index="43" name="fluid_type"/>
  <alias field="location_type" index="44" name="location_type"/>
  <alias field="workcat_id" index="45" name="workcat_id"/>
  <alias field="workcat_id_end" index="46" name="workcat_id_end"/>
  <alias field="workcat_id_plan" index="47" name="workcat_id_plan"/>
  <alias field="buildercat_id" index="48" name="buildercat_id"/>
  <alias field="builtdate" index="49" name="builtdate"/>
  <alias field="enddate" index="50" name="enddate"/>
  <alias field="ownercat_id" index="51" name="ownercat_id"/>
  <alias field="muni_id" index="52" name="muni_id"/>
  <alias field="postcode" index="53" name="postcode"/>
  <alias field="district_id" index="54" name="district"/>
  <alias field="streetname" index="55" name="streetname"/>
  <alias field="postnumber" index="56" name="postnumber"/>
  <alias field="postcomplement" index="57" name="postcomplement"/>
  <alias field="streetname2" index="58" name="streetname2"/>
  <alias field="postnumber2" index="59" name="postnumber2"/>
  <alias field="postcomplement2" index="60" name="postcomplement2"/>
  <alias field="region_id" index="61" name="Region"/>
  <alias field="province_id" index="62" name="Province"/>
  <alias field="descript" index="63" name="descript"/>
  <alias field="svg" index="64" name="svg"/>
  <alias field="rotation" index="65" name="rotation"/>
  <alias field="link" index="66" name="link"/>
  <alias field="verified" index="67" name="verified"/>
  <alias field="undelete" index="68" name="undelete"/>
  <alias field="label" index="69" name="Catalog label"/>
  <alias field="label_x" index="70" name="label_x"/>
  <alias field="label_y" index="71" name="label_y"/>
  <alias field="label_rotation" index="72" name="label_rotation"/>
  <alias field="label_quadrant" index="73" name="label_quadrant"/>
  <alias field="publish" index="74" name="publish"/>
  <alias field="inventory" index="75" name="inventory"/>
  <alias field="uncertain" index="76" name="uncertain"/>
  <alias field="num_value" index="77" name="num_value"/>
  <alias field="pjoint_id" index="78" name="pjoint_id"/>
  <alias field="pjoint_type" index="79" name="pjoint_type"/>
  <alias field="asset_id" index="80" name="asset_id"/>
  <alias field="gratecat2_id" index="81" name="gratecat2_id"/>
  <alias field="units_placement" index="82" name="units placement"/>
  <alias field="expl_id2" index="83" name="Exploitation 2"/>
  <alias field="is_operative" index="84" name=""/>
  <alias field="minsector_id" index="85" name="minsector_id"/>
  <alias field="macrominsector_id" index="86" name="macrominsector_id"/>
  <alias field="adate" index="87" name="adate"/>
  <alias field="adescript" index="88" name="adescript"/>
  <alias field="siphon_type" index="89" name="siphon_type"/>
  <alias field="odorflap" index="90" name="odorflap"/>
  <alias field="placement_type" index="91" name="placement_type"/>
  <alias field="access_type" index="92" name="access_type"/>
  <alias field="tstamp" index="93" name="Insert tstamp"/>
  <alias field="insert_user" index="94" name=""/>
  <alias field="lastupdate" index="95" name="Last update"/>
  <alias field="lastupdate_user" index="96" name="Last update user"/>
 </aliases>
 <defaults>
  <default field="gully_id" expression="" applyOnUpdate="0"/>
  <default field="code" expression="" applyOnUpdate="0"/>
  <default field="top_elev" expression="" applyOnUpdate="0"/>
  <default field="ymax" expression="" applyOnUpdate="0"/>
  <default field="sandbox" expression="" applyOnUpdate="0"/>
  <default field="matcat_id" expression="" applyOnUpdate="0"/>
  <default field="gully_type" expression="" applyOnUpdate="0"/>
  <default field="sys_type" expression="" applyOnUpdate="0"/>
  <default field="gratecat_id" expression="" applyOnUpdate="0"/>
  <default field="cat_grate_matcat" expression="" applyOnUpdate="0"/>
  <default field="units" expression="" applyOnUpdate="0"/>
  <default field="groove" expression="" applyOnUpdate="0"/>
  <default field="groove_height" expression="" applyOnUpdate="0"/>
  <default field="groove_length" expression="" applyOnUpdate="0"/>
  <default field="siphon" expression="" applyOnUpdate="0"/>
  <default field="connec_arccat_id" expression="" applyOnUpdate="0"/>
  <default field="connec_length" expression="" applyOnUpdate="0"/>
  <default field="connec_depth" expression="" applyOnUpdate="0"/>
  <default field="connec_matcat_id" expression="" applyOnUpdate="0"/>
  <default field="connec_y1" expression="" applyOnUpdate="0"/>
  <default field="connec_y2" expression="" applyOnUpdate="0"/>
  <default field="grate_width" expression="" applyOnUpdate="0"/>
  <default field="grate_length" expression="" applyOnUpdate="0"/>
  <default field="arc_id" expression="" applyOnUpdate="0"/>
  <default field="epa_type" expression="" applyOnUpdate="0"/>
  <default field="inp_type" expression="" applyOnUpdate="0"/>
  <default field="state" expression="" applyOnUpdate="0"/>
  <default field="state_type" expression="" applyOnUpdate="0"/>
  <default field="expl_id" expression="" applyOnUpdate="0"/>
  <default field="macroexpl_id" expression="" applyOnUpdate="0"/>
  <default field="sector_id" expression="" applyOnUpdate="0"/>
  <default field="sector_type" expression="" applyOnUpdate="0"/>
  <default field="macrosector_id" expression="" applyOnUpdate="0"/>
  <default field="drainzone_id" expression="" applyOnUpdate="0"/>
  <default field="drainzone_type" expression="" applyOnUpdate="0"/>
  <default field="dma_id" expression="" applyOnUpdate="0"/>
  <default field="macrodma_id" expression="" applyOnUpdate="0"/>
  <default field="annotation" expression="" applyOnUpdate="0"/>
  <default field="observ" expression="" applyOnUpdate="0"/>
  <default field="comment" expression="" applyOnUpdate="0"/>
  <default field="soilcat_id" expression="" applyOnUpdate="0"/>
  <default field="function_type" expression="" applyOnUpdate="0"/>
  <default field="category_type" expression="" applyOnUpdate="0"/>
  <default field="fluid_type" expression="" applyOnUpdate="0"/>
  <default field="location_type" expression="" applyOnUpdate="0"/>
  <default field="workcat_id" expression="" applyOnUpdate="0"/>
  <default field="workcat_id_end" expression="" applyOnUpdate="0"/>
  <default field="workcat_id_plan" expression="" applyOnUpdate="0"/>
  <default field="buildercat_id" expression="" applyOnUpdate="0"/>
  <default field="builtdate" expression="" applyOnUpdate="0"/>
  <default field="enddate" expression="" applyOnUpdate="0"/>
  <default field="ownercat_id" expression="" applyOnUpdate="0"/>
  <default field="muni_id" expression="" applyOnUpdate="0"/>
  <default field="postcode" expression="" applyOnUpdate="0"/>
  <default field="district_id" expression="" applyOnUpdate="0"/>
  <default field="streetname" expression="" applyOnUpdate="0"/>
  <default field="postnumber" expression="" applyOnUpdate="0"/>
  <default field="postcomplement" expression="" applyOnUpdate="0"/>
  <default field="streetname2" expression="" applyOnUpdate="0"/>
  <default field="postnumber2" expression="" applyOnUpdate="0"/>
  <default field="postcomplement2" expression="" applyOnUpdate="0"/>
  <default field="region_id" expression="" applyOnUpdate="0"/>
  <default field="province_id" expression="" applyOnUpdate="0"/>
  <default field="descript" expression="" applyOnUpdate="0"/>
  <default field="svg" expression="" applyOnUpdate="0"/>
  <default field="rotation" expression="" applyOnUpdate="0"/>
  <default field="link" expression="" applyOnUpdate="0"/>
  <default field="verified" expression="" applyOnUpdate="0"/>
  <default field="undelete" expression="" applyOnUpdate="0"/>
  <default field="label" expression="" applyOnUpdate="0"/>
  <default field="label_x" expression="" applyOnUpdate="0"/>
  <default field="label_y" expression="" applyOnUpdate="0"/>
  <default field="label_rotation" expression="" applyOnUpdate="0"/>
  <default field="label_quadrant" expression="" applyOnUpdate="0"/>
  <default field="publish" expression="" applyOnUpdate="0"/>
  <default field="inventory" expression="" applyOnUpdate="0"/>
  <default field="uncertain" expression="" applyOnUpdate="0"/>
  <default field="num_value" expression="" applyOnUpdate="0"/>
  <default field="pjoint_id" expression="" applyOnUpdate="0"/>
  <default field="pjoint_type" expression="" applyOnUpdate="0"/>
  <default field="asset_id" expression="" applyOnUpdate="0"/>
  <default field="gratecat2_id" expression="" applyOnUpdate="0"/>
  <default field="units_placement" expression="" applyOnUpdate="0"/>
  <default field="expl_id2" expression="" applyOnUpdate="0"/>
  <default field="is_operative" expression="" applyOnUpdate="0"/>
  <default field="minsector_id" expression="" applyOnUpdate="0"/>
  <default field="macrominsector_id" expression="" applyOnUpdate="0"/>
  <default field="adate" expression="" applyOnUpdate="0"/>
  <default field="adescript" expression="" applyOnUpdate="0"/>
  <default field="siphon_type" expression="" applyOnUpdate="0"/>
  <default field="odorflap" expression="" applyOnUpdate="0"/>
  <default field="placement_type" expression="" applyOnUpdate="0"/>
  <default field="access_type" expression="" applyOnUpdate="0"/>
  <default field="tstamp" expression="" applyOnUpdate="0"/>
  <default field="insert_user" expression="" applyOnUpdate="0"/>
  <default field="lastupdate" expression="" applyOnUpdate="0"/>
  <default field="lastupdate_user" expression="" applyOnUpdate="0"/>
 </defaults>
 <constraints>
  <constraint field="gully_id" unique_strength="1" notnull_strength="2" exp_strength="0" constraints="3"/>
  <constraint field="code" unique_strength="0" notnull_strength="2" exp_strength="0" constraints="1"/>
  <constraint field="top_elev" unique_strength="0" notnull_strength="2" exp_strength="0" constraints="1"/>
  <constraint field="ymax" unique_strength="0" notnull_strength="2" exp_strength="0" constraints="1"/>
  <constraint field="sandbox" unique_strength="0" notnull_strength="2" exp_strength="0" constraints="1"/>
  <constraint field="matcat_id" unique_strength="0" notnull_strength="2" exp_strength="0" constraints="1"/>
  <constraint field="gully_type" unique_strength="0" notnull_strength="1" exp_strength="0" constraints="1"/>
  <constraint field="sys_type" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="gratecat_id" unique_strength="0" notnull_strength="1" exp_strength="0" constraints="1"/>
  <constraint field="cat_grate_matcat" unique_strength="0" notnull_strength="2" exp_strength="0" constraints="1"/>
  <constraint field="units" unique_strength="0" notnull_strength="2" exp_strength="0" constraints="1"/>
  <constraint field="groove" unique_strength="0" notnull_strength="2" exp_strength="0" constraints="1"/>
  <constraint field="groove_height" unique_strength="0" notnull_strength="2" exp_strength="0" constraints="1"/>
  <constraint field="groove_length" unique_strength="0" notnull_strength="2" exp_strength="0" constraints="1"/>
  <constraint field="siphon" unique_strength="0" notnull_strength="2" exp_strength="0" constraints="1"/>
  <constraint field="connec_arccat_id" unique_strength="0" notnull_strength="2" exp_strength="0" constraints="1"/>
  <constraint field="connec_length" unique_strength="0" notnull_strength="2" exp_strength="0" constraints="1"/>
  <constraint field="connec_depth" unique_strength="0" notnull_strength="2" exp_strength="0" constraints="1"/>
  <constraint field="connec_matcat_id" unique_strength="0" notnull_strength="2" exp_strength="0" constraints="1"/>
  <constraint field="connec_y1" unique_strength="0" notnull_strength="2" exp_strength="0" constraints="1"/>
  <constraint field="connec_y2" unique_strength="0" notnull_strength="2" exp_strength="0" constraints="1"/>
  <constraint field="grate_width" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="grate_length" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="arc_id" unique_strength="0" notnull_strength="2" exp_strength="0" constraints="1"/>
  <constraint field="epa_type" unique_strength="0" notnull_strength="2" exp_strength="0" constraints="1"/>
  <constraint field="inp_type" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="state" unique_strength="0" notnull_strength="2" exp_strength="0" constraints="1"/>
  <constraint field="state_type" unique_strength="0" notnull_strength="2" exp_strength="0" constraints="1"/>
  <constraint field="expl_id" unique_strength="0" notnull_strength="2" exp_strength="0" constraints="1"/>
  <constraint field="macroexpl_id" unique_strength="0" notnull_strength="1" exp_strength="0" constraints="1"/>
  <constraint field="sector_id" unique_strength="0" notnull_strength="2" exp_strength="0" constraints="1"/>
  <constraint field="sector_type" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="macrosector_id" unique_strength="0" notnull_strength="2" exp_strength="0" constraints="1"/>
  <constraint field="drainzone_id" unique_strength="0" notnull_strength="2" exp_strength="0" constraints="1"/>
  <constraint field="drainzone_type" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="dma_id" unique_strength="0" notnull_strength="2" exp_strength="0" constraints="1"/>
  <constraint field="macrodma_id" unique_strength="0" notnull_strength="2" exp_strength="0" constraints="1"/>
  <constraint field="annotation" unique_strength="0" notnull_strength="2" exp_strength="0" constraints="1"/>
  <constraint field="observ" unique_strength="0" notnull_strength="2" exp_strength="0" constraints="1"/>
  <constraint field="comment" unique_strength="0" notnull_strength="2" exp_strength="0" constraints="1"/>
  <constraint field="soilcat_id" unique_strength="0" notnull_strength="2" exp_strength="0" constraints="1"/>
  <constraint field="function_type" unique_strength="0" notnull_strength="2" exp_strength="0" constraints="1"/>
  <constraint field="category_type" unique_strength="0" notnull_strength="2" exp_strength="0" constraints="1"/>
  <constraint field="fluid_type" unique_strength="0" notnull_strength="2" exp_strength="0" constraints="1"/>
  <constraint field="location_type" unique_strength="0" notnull_strength="2" exp_strength="0" constraints="1"/>
  <constraint field="workcat_id" unique_strength="0" notnull_strength="2" exp_strength="0" constraints="1"/>
  <constraint field="workcat_id_end" unique_strength="0" notnull_strength="2" exp_strength="0" constraints="1"/>
  <constraint field="workcat_id_plan" unique_strength="0" notnull_strength="2" exp_strength="0" constraints="1"/>
  <constraint field="buildercat_id" unique_strength="0" notnull_strength="2" exp_strength="0" constraints="1"/>
  <constraint field="builtdate" unique_strength="0" notnull_strength="2" exp_strength="0" constraints="1"/>
  <constraint field="enddate" unique_strength="0" notnull_strength="2" exp_strength="0" constraints="1"/>
  <constraint field="ownercat_id" unique_strength="0" notnull_strength="2" exp_strength="0" constraints="1"/>
  <constraint field="muni_id" unique_strength="0" notnull_strength="2" exp_strength="0" constraints="1"/>
  <constraint field="postcode" unique_strength="0" notnull_strength="2" exp_strength="0" constraints="1"/>
  <constraint field="district_id" unique_strength="0" notnull_strength="2" exp_strength="0" constraints="1"/>
  <constraint field="streetname" unique_strength="0" notnull_strength="2" exp_strength="0" constraints="1"/>
  <constraint field="postnumber" unique_strength="0" notnull_strength="2" exp_strength="0" constraints="1"/>
  <constraint field="postcomplement" unique_strength="0" notnull_strength="2" exp_strength="0" constraints="1"/>
  <constraint field="streetname2" unique_strength="0" notnull_strength="2" exp_strength="0" constraints="1"/>
  <constraint field="postnumber2" unique_strength="0" notnull_strength="2" exp_strength="0" constraints="1"/>
  <constraint field="postcomplement2" unique_strength="0" notnull_strength="2" exp_strength="0" constraints="1"/>
  <constraint field="region_id" unique_strength="0" notnull_strength="2" exp_strength="0" constraints="1"/>
  <constraint field="province_id" unique_strength="0" notnull_strength="2" exp_strength="0" constraints="1"/>
  <constraint field="descript" unique_strength="0" notnull_strength="2" exp_strength="0" constraints="1"/>
  <constraint field="svg" unique_strength="0" notnull_strength="2" exp_strength="0" constraints="1"/>
  <constraint field="rotation" unique_strength="0" notnull_strength="2" exp_strength="0" constraints="1"/>
  <constraint field="link" unique_strength="0" notnull_strength="2" exp_strength="0" constraints="1"/>
  <constraint field="verified" unique_strength="0" notnull_strength="2" exp_strength="0" constraints="1"/>
  <constraint field="undelete" unique_strength="0" notnull_strength="2" exp_strength="0" constraints="1"/>
  <constraint field="label" unique_strength="0" notnull_strength="2" exp_strength="0" constraints="1"/>
  <constraint field="label_x" unique_strength="0" notnull_strength="2" exp_strength="0" constraints="1"/>
  <constraint field="label_y" unique_strength="0" notnull_strength="2" exp_strength="0" constraints="1"/>
  <constraint field="label_rotation" unique_strength="0" notnull_strength="2" exp_strength="0" constraints="1"/>
  <constraint field="label_quadrant" unique_strength="0" notnull_strength="2" exp_strength="0" constraints="1"/>
  <constraint field="publish" unique_strength="0" notnull_strength="2" exp_strength="0" constraints="1"/>
  <constraint field="inventory" unique_strength="0" notnull_strength="2" exp_strength="0" constraints="1"/>
  <constraint field="uncertain" unique_strength="0" notnull_strength="2" exp_strength="0" constraints="1"/>
  <constraint field="num_value" unique_strength="0" notnull_strength="2" exp_strength="0" constraints="1"/>
  <constraint field="pjoint_id" unique_strength="0" notnull_strength="2" exp_strength="0" constraints="1"/>
  <constraint field="pjoint_type" unique_strength="0" notnull_strength="2" exp_strength="0" constraints="1"/>
  <constraint field="asset_id" unique_strength="0" notnull_strength="2" exp_strength="0" constraints="1"/>
  <constraint field="gratecat2_id" unique_strength="0" notnull_strength="2" exp_strength="0" constraints="1"/>
  <constraint field="units_placement" unique_strength="0" notnull_strength="2" exp_strength="0" constraints="1"/>
  <constraint field="expl_id2" unique_strength="0" notnull_strength="2" exp_strength="0" constraints="1"/>
  <constraint field="is_operative" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="minsector_id" unique_strength="0" notnull_strength="2" exp_strength="0" constraints="1"/>
  <constraint field="macrominsector_id" unique_strength="0" notnull_strength="2" exp_strength="0" constraints="1"/>
  <constraint field="adate" unique_strength="0" notnull_strength="2" exp_strength="0" constraints="1"/>
  <constraint field="adescript" unique_strength="0" notnull_strength="2" exp_strength="0" constraints="1"/>
  <constraint field="siphon_type" unique_strength="0" notnull_strength="2" exp_strength="0" constraints="1"/>
  <constraint field="odorflap" unique_strength="0" notnull_strength="2" exp_strength="0" constraints="1"/>
  <constraint field="placement_type" unique_strength="0" notnull_strength="2" exp_strength="0" constraints="1"/>
  <constraint field="access_type" unique_strength="0" notnull_strength="2" exp_strength="0" constraints="1"/>
  <constraint field="tstamp" unique_strength="0" notnull_strength="1" exp_strength="0" constraints="1"/>
  <constraint field="insert_user" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="lastupdate" unique_strength="0" notnull_strength="2" exp_strength="0" constraints="1"/>
  <constraint field="lastupdate_user" unique_strength="0" notnull_strength="2" exp_strength="0" constraints="1"/>
 </constraints>
 <constraintExpressions>
  <constraint field="gully_id" desc="" exp=""/>
  <constraint field="code" desc="" exp=""/>
  <constraint field="top_elev" desc="" exp=""/>
  <constraint field="ymax" desc="" exp=""/>
  <constraint field="sandbox" desc="" exp=""/>
  <constraint field="matcat_id" desc="" exp=""/>
  <constraint field="gully_type" desc="" exp=""/>
  <constraint field="sys_type" desc="" exp=""/>
  <constraint field="gratecat_id" desc="" exp=""/>
  <constraint field="cat_grate_matcat" desc="" exp=""/>
  <constraint field="units" desc="" exp=""/>
  <constraint field="groove" desc="" exp=""/>
  <constraint field="groove_height" desc="" exp=""/>
  <constraint field="groove_length" desc="" exp=""/>
  <constraint field="siphon" desc="" exp=""/>
  <constraint field="connec_arccat_id" desc="" exp=""/>
  <constraint field="connec_length" desc="" exp=""/>
  <constraint field="connec_depth" desc="" exp=""/>
  <constraint field="connec_matcat_id" desc="" exp=""/>
  <constraint field="connec_y1" desc="" exp=""/>
  <constraint field="connec_y2" desc="" exp=""/>
  <constraint field="grate_width" desc="" exp=""/>
  <constraint field="grate_length" desc="" exp=""/>
  <constraint field="arc_id" desc="" exp=""/>
  <constraint field="epa_type" desc="" exp=""/>
  <constraint field="inp_type" desc="" exp=""/>
  <constraint field="state" desc="" exp=""/>
  <constraint field="state_type" desc="" exp=""/>
  <constraint field="expl_id" desc="" exp=""/>
  <constraint field="macroexpl_id" desc="" exp=""/>
  <constraint field="sector_id" desc="" exp=""/>
  <constraint field="sector_type" desc="" exp=""/>
  <constraint field="macrosector_id" desc="" exp=""/>
  <constraint field="drainzone_id" desc="" exp=""/>
  <constraint field="drainzone_type" desc="" exp=""/>
  <constraint field="dma_id" desc="" exp=""/>
  <constraint field="macrodma_id" desc="" exp=""/>
  <constraint field="annotation" desc="" exp=""/>
  <constraint field="observ" desc="" exp=""/>
  <constraint field="comment" desc="" exp=""/>
  <constraint field="soilcat_id" desc="" exp=""/>
  <constraint field="function_type" desc="" exp=""/>
  <constraint field="category_type" desc="" exp=""/>
  <constraint field="fluid_type" desc="" exp=""/>
  <constraint field="location_type" desc="" exp=""/>
  <constraint field="workcat_id" desc="" exp=""/>
  <constraint field="workcat_id_end" desc="" exp=""/>
  <constraint field="workcat_id_plan" desc="" exp=""/>
  <constraint field="buildercat_id" desc="" exp=""/>
  <constraint field="builtdate" desc="" exp=""/>
  <constraint field="enddate" desc="" exp=""/>
  <constraint field="ownercat_id" desc="" exp=""/>
  <constraint field="muni_id" desc="" exp=""/>
  <constraint field="postcode" desc="" exp=""/>
  <constraint field="district_id" desc="" exp=""/>
  <constraint field="streetname" desc="" exp=""/>
  <constraint field="postnumber" desc="" exp=""/>
  <constraint field="postcomplement" desc="" exp=""/>
  <constraint field="streetname2" desc="" exp=""/>
  <constraint field="postnumber2" desc="" exp=""/>
  <constraint field="postcomplement2" desc="" exp=""/>
  <constraint field="region_id" desc="" exp=""/>
  <constraint field="province_id" desc="" exp=""/>
  <constraint field="descript" desc="" exp=""/>
  <constraint field="svg" desc="" exp=""/>
  <constraint field="rotation" desc="" exp=""/>
  <constraint field="link" desc="" exp=""/>
  <constraint field="verified" desc="" exp=""/>
  <constraint field="undelete" desc="" exp=""/>
  <constraint field="label" desc="" exp=""/>
  <constraint field="label_x" desc="" exp=""/>
  <constraint field="label_y" desc="" exp=""/>
  <constraint field="label_rotation" desc="" exp=""/>
  <constraint field="label_quadrant" desc="" exp=""/>
  <constraint field="publish" desc="" exp=""/>
  <constraint field="inventory" desc="" exp=""/>
  <constraint field="uncertain" desc="" exp=""/>
  <constraint field="num_value" desc="" exp=""/>
  <constraint field="pjoint_id" desc="" exp=""/>
  <constraint field="pjoint_type" desc="" exp=""/>
  <constraint field="asset_id" desc="" exp=""/>
  <constraint field="gratecat2_id" desc="" exp=""/>
  <constraint field="units_placement" desc="" exp=""/>
  <constraint field="expl_id2" desc="" exp=""/>
  <constraint field="is_operative" desc="" exp=""/>
  <constraint field="minsector_id" desc="" exp=""/>
  <constraint field="macrominsector_id" desc="" exp=""/>
  <constraint field="adate" desc="" exp=""/>
  <constraint field="adescript" desc="" exp=""/>
  <constraint field="siphon_type" desc="" exp=""/>
  <constraint field="odorflap" desc="" exp=""/>
  <constraint field="placement_type" desc="" exp=""/>
  <constraint field="access_type" desc="" exp=""/>
  <constraint field="tstamp" desc="" exp=""/>
  <constraint field="insert_user" desc="" exp=""/>
  <constraint field="lastupdate" desc="" exp=""/>
  <constraint field="lastupdate_user" desc="" exp=""/>
 </constraintExpressions>
 <expressionfields/>
 <attributeactions>
  <defaultAction value="{00000000-0000-0000-0000-000000000000}" key="Canvas"/>
 </attributeactions>
 <attributetableconfig sortOrder="0" actionWidgetStyle="dropDown" sortExpression="">
  <columns>
   <column hidden="0" width="-1" name="gully_id" type="field"/>
   <column hidden="0" width="-1" name="code" type="field"/>
   <column hidden="0" width="-1" name="top_elev" type="field"/>
   <column hidden="0" width="-1" name="ymax" type="field"/>
   <column hidden="0" width="-1" name="sandbox" type="field"/>
   <column hidden="0" width="-1" name="matcat_id" type="field"/>
   <column hidden="0" width="-1" name="gully_type" type="field"/>
   <column hidden="0" width="-1" name="sys_type" type="field"/>
   <column hidden="0" width="-1" name="gratecat_id" type="field"/>
   <column hidden="0" width="-1" name="cat_grate_matcat" type="field"/>
   <column hidden="0" width="-1" name="units" type="field"/>
   <column hidden="0" width="-1" name="groove" type="field"/>
   <column hidden="0" width="-1" name="siphon" type="field"/>
   <column hidden="0" width="-1" name="connec_arccat_id" type="field"/>
   <column hidden="1" width="-1" name="connec_length" type="field"/>
   <column hidden="0" width="-1" name="connec_depth" type="field"/>
   <column hidden="0" width="-1" name="arc_id" type="field"/>
   <column hidden="0" width="-1" name="expl_id" type="field"/>
   <column hidden="1" width="-1" name="macroexpl_id" type="field"/>
   <column hidden="0" width="-1" name="sector_id" type="field"/>
   <column hidden="1" width="-1" name="macrosector_id" type="field"/>
   <column hidden="0" width="-1" name="state" type="field"/>
   <column hidden="0" width="-1" name="state_type" type="field"/>
   <column hidden="0" width="-1" name="annotation" type="field"/>
   <column hidden="0" width="-1" name="observ" type="field"/>
   <column hidden="1" width="-1" name="comment" type="field"/>
   <column hidden="0" width="-1" name="dma_id" type="field"/>
   <column hidden="1" width="-1" name="macrodma_id" type="field"/>
   <column hidden="0" width="-1" name="soilcat_id" type="field"/>
   <column hidden="0" width="-1" name="function_type" type="field"/>
   <column hidden="0" width="-1" name="category_type" type="field"/>
   <column hidden="0" width="-1" name="fluid_type" type="field"/>
   <column hidden="0" width="-1" name="location_type" type="field"/>
   <column hidden="0" width="-1" name="workcat_id" type="field"/>
   <column hidden="0" width="-1" name="workcat_id_end" type="field"/>
   <column hidden="1" width="-1" name="buildercat_id" type="field"/>
   <column hidden="0" width="-1" name="builtdate" type="field"/>
   <column hidden="0" width="-1" name="enddate" type="field"/>
   <column hidden="0" width="-1" name="ownercat_id" type="field"/>
   <column hidden="0" width="-1" name="muni_id" type="field"/>
   <column hidden="0" width="-1" name="postcode" type="field"/>
   <column hidden="1" width="-1" name="district_id" type="field"/>
   <column hidden="0" width="-1" name="streetname" type="field"/>
   <column hidden="0" width="-1" name="postnumber" type="field"/>
   <column hidden="0" width="-1" name="postcomplement" type="field"/>
   <column hidden="0" width="-1" name="streetname2" type="field"/>
   <column hidden="0" width="-1" name="postnumber2" type="field"/>
   <column hidden="0" width="-1" name="postcomplement2" type="field"/>
   <column hidden="0" width="-1" name="descript" type="field"/>
   <column hidden="1" width="-1" name="svg" type="field"/>
   <column hidden="0" width="-1" name="rotation" type="field"/>
   <column hidden="0" width="-1" name="link" type="field"/>
   <column hidden="1" width="-1" name="verified" type="field"/>
   <column hidden="1" width="-1" name="undelete" type="field"/>
   <column hidden="0" width="-1" name="label" type="field"/>
   <column hidden="0" width="-1" name="label_x" type="field"/>
   <column hidden="0" width="-1" name="label_y" type="field"/>
   <column hidden="0" width="-1" name="label_rotation" type="field"/>
   <column hidden="1" width="-1" name="publish" type="field"/>
   <column hidden="1" width="-1" name="inventory" type="field"/>
   <column hidden="1" width="-1" name="uncertain" type="field"/>
   <column hidden="1" width="-1" name="num_value" type="field"/>
   <column hidden="0" width="-1" name="pjoint_id" type="field"/>
   <column hidden="0" width="-1" name="pjoint_type" type="field"/>
   <column hidden="1" width="-1" name="tstamp" type="field"/>
   <column hidden="0" width="-1" name="insert_user" type="field"/>
   <column hidden="1" width="-1" name="lastupdate" type="field"/>
   <column hidden="1" width="-1" name="lastupdate_user" type="field"/>
   <column hidden="1" width="-1" type="actions"/>
   <column hidden="0" width="-1" name="asset_id" type="field"/>
   <column hidden="0" width="-1" name="connec_matcat_id" type="field"/>
   <column hidden="0" width="-1" name="gratecat2_id" type="field"/>
   <column hidden="0" width="-1" name="connec_y1" type="field"/>
   <column hidden="0" width="-1" name="connec_y2" type="field"/>
   <column hidden="0" width="-1" name="epa_type" type="field"/>
   <column hidden="0" width="-1" name="groove_height" type="field"/>
   <column hidden="0" width="-1" name="groove_length" type="field"/>
   <column hidden="0" width="-1" name="grate_width" type="field"/>
   <column hidden="0" width="-1" name="grate_length" type="field"/>
   <column hidden="0" width="-1" name="units_placement" type="field"/>
   <column hidden="0" width="-1" name="drainzone_id" type="field"/>
   <column hidden="1" width="-1" name="expl_id2" type="field"/>
   <column hidden="0" width="-1" name="is_operative" type="field"/>
   <column hidden="1" width="-1" name="region_id" type="field"/>
   <column hidden="1" width="-1" name="province_id" type="field"/>
   <column hidden="0" width="-1" name="adate" type="field"/>
   <column hidden="0" width="-1" name="adescript" type="field"/>
   <column hidden="0" width="-1" name="siphon_type" type="field"/>
   <column hidden="0" width="-1" name="odorflap" type="field"/>
   <column hidden="0" width="-1" name="inp_type" type="field"/>
   <column hidden="0" width="-1" name="sector_type" type="field"/>
   <column hidden="0" width="-1" name="drainzone_type" type="field"/>
   <column hidden="0" width="-1" name="label_quadrant" type="field"/>
   <column hidden="0" width="-1" name="minsector_id" type="field"/>
   <column hidden="0" width="-1" name="macrominsector_id" type="field"/>
   <column hidden="0" width="-1" name="placement_type" type="field"/>
   <column hidden="0" width="-1" name="access_type" type="field"/>
   <column hidden="0" width="-1" name="workcat_id_plan" type="field"/>
  </columns>
 </attributetableconfig>
 <conditionalstyles>
  <rowstyles/>
  <fieldstyles/>
 </conditionalstyles>
 <storedexpressions/>
 <editform tolerant="1"></editform>
 <editforminit/>
 <editforminitcodesource>0</editforminitcodesource>
 <editforminitfilepath></editforminitfilepath>
 <editforminitcode><![CDATA[# -*- codificación: utf-8 -*-
"""
Los formularios de QGIS pueden tener una función de Python que
es llamada cuando se abre el formulario.

Use esta función para añadir lógica extra a sus formularios.

Introduzca el nombre de la función en el campo
"Python Init function".
Sigue un ejemplo:
"""
from qgis.PyQt.QtWidgets import QWidget

def my_form_open(dialog, layer, feature):
	geom = feature.geometry()
	control = dialog.findChild(QWidget, "MyLineEdit")
]]></editforminitcode>
 <featformsuppress>0</featformsuppress>
 <editorlayout>generatedlayout</editorlayout>
 <editable>
  <field name="access_type" editable="1"/>
  <field name="adate" editable="1"/>
  <field name="adescript" editable="1"/>
  <field name="annotation" editable="1"/>
  <field name="arc_id" editable="1"/>
  <field name="asset_id" editable="1"/>
  <field name="buildercat_id" editable="1"/>
  <field name="builtdate" editable="1"/>
  <field name="cat_grate_matcat" editable="0"/>
  <field name="category_type" editable="1"/>
  <field name="code" editable="1"/>
  <field name="comment" editable="1"/>
  <field name="connec_arccat_id" editable="1"/>
  <field name="connec_depth" editable="1"/>
  <field name="connec_length" editable="1"/>
  <field name="connec_matcat_id" editable="1"/>
  <field name="connec_y1" editable="0"/>
  <field name="connec_y2" editable="0"/>
  <field name="descript" editable="1"/>
  <field name="district_id" editable="1"/>
  <field name="dma_id" editable="1"/>
  <field name="drainzone_id" editable="0"/>
  <field name="drainzone_type" editable="1"/>
  <field name="enddate" editable="1"/>
  <field name="epa_type" editable="1"/>
  <field name="expl_id" editable="1"/>
  <field name="expl_id2" editable="1"/>
  <field name="feature_id" editable="1"/>
  <field name="featurecat_id" editable="1"/>
  <field name="fluid_type" editable="1"/>
  <field name="function_type" editable="1"/>
  <field name="grate_length" editable="1"/>
  <field name="grate_width" editable="1"/>
  <field name="gratecat2_id" editable="1"/>
  <field name="gratecat_id" editable="1"/>
  <field name="groove" editable="1"/>
  <field name="groove_height" editable="1"/>
  <field name="groove_length" editable="1"/>
  <field name="gully_id" editable="1"/>
  <field name="gully_type" editable="0"/>
  <field name="inp_type" editable="1"/>
  <field name="insert_user" editable="1"/>
  <field name="inventory" editable="1"/>
  <field name="is_operative" editable="1"/>
  <field name="label" editable="0"/>
  <field name="label_quadrant" editable="1"/>
  <field name="label_rotation" editable="1"/>
  <field name="label_x" editable="1"/>
  <field name="label_y" editable="1"/>
  <field name="lastupdate" editable="0"/>
  <field name="lastupdate_user" editable="0"/>
  <field name="link" editable="0"/>
  <field name="location_type" editable="1"/>
  <field name="macrodma_id" editable="1"/>
  <field name="macroexpl_id" editable="1"/>
  <field name="macrominsector_id" editable="1"/>
  <field name="macrosector_id" editable="0"/>
  <field name="matcat_id" editable="0"/>
  <field name="minsector_id" editable="1"/>
  <field name="muni_id" editable="1"/>
  <field name="num_value" editable="1"/>
  <field name="observ" editable="1"/>
  <field name="odorflap" editable="1"/>
  <field name="ownercat_id" editable="1"/>
  <field name="pjoint_id" editable="0"/>
  <field name="pjoint_type" editable="0"/>
  <field name="placement_type" editable="1"/>
  <field name="postcode" editable="1"/>
  <field name="postcomplement" editable="1"/>
  <field name="postcomplement2" editable="1"/>
  <field name="postnumber" editable="1"/>
  <field name="postnumber2" editable="1"/>
  <field name="province_id" editable="0"/>
  <field name="publish" editable="1"/>
  <field name="region_id" editable="0"/>
  <field name="rotation" editable="1"/>
  <field name="sandbox" editable="1"/>
  <field name="sector_id" editable="1"/>
  <field name="sector_type" editable="1"/>
  <field name="siphon" editable="1"/>
  <field name="siphon_type" editable="1"/>
  <field name="soilcat_id" editable="1"/>
  <field name="state" editable="1"/>
  <field name="state_type" editable="1"/>
  <field name="streetname" editable="1"/>
  <field name="streetname2" editable="1"/>
  <field name="svg" editable="1"/>
  <field name="sys_type" editable="1"/>
  <field name="top_elev" editable="1"/>
  <field name="tstamp" editable="1"/>
  <field name="uncertain" editable="1"/>
  <field name="undelete" editable="1"/>
  <field name="units" editable="1"/>
  <field name="units_placement" editable="1"/>
  <field name="verified" editable="1"/>
  <field name="workcat_id" editable="1"/>
  <field name="workcat_id_end" editable="1"/>
  <field name="workcat_id_plan" editable="1"/>
  <field name="ymax" editable="1"/>
 </editable>
 <labelOnTop>
  <field labelOnTop="0" name="access_type"/>
  <field labelOnTop="0" name="adate"/>
  <field labelOnTop="0" name="adescript"/>
  <field labelOnTop="0" name="annotation"/>
  <field labelOnTop="0" name="arc_id"/>
  <field labelOnTop="0" name="asset_id"/>
  <field labelOnTop="0" name="buildercat_id"/>
  <field labelOnTop="0" name="builtdate"/>
  <field labelOnTop="0" name="cat_grate_matcat"/>
  <field labelOnTop="0" name="category_type"/>
  <field labelOnTop="0" name="code"/>
  <field labelOnTop="0" name="comment"/>
  <field labelOnTop="0" name="connec_arccat_id"/>
  <field labelOnTop="0" name="connec_depth"/>
  <field labelOnTop="0" name="connec_length"/>
  <field labelOnTop="0" name="connec_matcat_id"/>
  <field labelOnTop="0" name="connec_y1"/>
  <field labelOnTop="0" name="connec_y2"/>
  <field labelOnTop="0" name="descript"/>
  <field labelOnTop="0" name="district_id"/>
  <field labelOnTop="0" name="dma_id"/>
  <field labelOnTop="0" name="drainzone_id"/>
  <field labelOnTop="0" name="drainzone_type"/>
  <field labelOnTop="0" name="enddate"/>
  <field labelOnTop="0" name="epa_type"/>
  <field labelOnTop="0" name="expl_id"/>
  <field labelOnTop="0" name="expl_id2"/>
  <field labelOnTop="0" name="feature_id"/>
  <field labelOnTop="0" name="featurecat_id"/>
  <field labelOnTop="0" name="fluid_type"/>
  <field labelOnTop="0" name="function_type"/>
  <field labelOnTop="0" name="grate_length"/>
  <field labelOnTop="0" name="grate_width"/>
  <field labelOnTop="0" name="gratecat2_id"/>
  <field labelOnTop="0" name="gratecat_id"/>
  <field labelOnTop="0" name="groove"/>
  <field labelOnTop="0" name="groove_height"/>
  <field labelOnTop="0" name="groove_length"/>
  <field labelOnTop="0" name="gully_id"/>
  <field labelOnTop="0" name="gully_type"/>
  <field labelOnTop="0" name="inp_type"/>
  <field labelOnTop="0" name="insert_user"/>
  <field labelOnTop="0" name="inventory"/>
  <field labelOnTop="0" name="is_operative"/>
  <field labelOnTop="0" name="label"/>
  <field labelOnTop="0" name="label_quadrant"/>
  <field labelOnTop="0" name="label_rotation"/>
  <field labelOnTop="0" name="label_x"/>
  <field labelOnTop="0" name="label_y"/>
  <field labelOnTop="0" name="lastupdate"/>
  <field labelOnTop="0" name="lastupdate_user"/>
  <field labelOnTop="0" name="link"/>
  <field labelOnTop="0" name="location_type"/>
  <field labelOnTop="0" name="macrodma_id"/>
  <field labelOnTop="0" name="macroexpl_id"/>
  <field labelOnTop="0" name="macrominsector_id"/>
  <field labelOnTop="0" name="macrosector_id"/>
  <field labelOnTop="0" name="matcat_id"/>
  <field labelOnTop="0" name="minsector_id"/>
  <field labelOnTop="0" name="muni_id"/>
  <field labelOnTop="0" name="num_value"/>
  <field labelOnTop="0" name="observ"/>
  <field labelOnTop="0" name="odorflap"/>
  <field labelOnTop="0" name="ownercat_id"/>
  <field labelOnTop="0" name="pjoint_id"/>
  <field labelOnTop="0" name="pjoint_type"/>
  <field labelOnTop="0" name="placement_type"/>
  <field labelOnTop="0" name="postcode"/>
  <field labelOnTop="0" name="postcomplement"/>
  <field labelOnTop="0" name="postcomplement2"/>
  <field labelOnTop="0" name="postnumber"/>
  <field labelOnTop="0" name="postnumber2"/>
  <field labelOnTop="0" name="province_id"/>
  <field labelOnTop="0" name="publish"/>
  <field labelOnTop="0" name="region_id"/>
  <field labelOnTop="0" name="rotation"/>
  <field labelOnTop="0" name="sandbox"/>
  <field labelOnTop="0" name="sector_id"/>
  <field labelOnTop="0" name="sector_type"/>
  <field labelOnTop="0" name="siphon"/>
  <field labelOnTop="0" name="siphon_type"/>
  <field labelOnTop="0" name="soilcat_id"/>
  <field labelOnTop="0" name="state"/>
  <field labelOnTop="0" name="state_type"/>
  <field labelOnTop="0" name="streetname"/>
  <field labelOnTop="0" name="streetname2"/>
  <field labelOnTop="0" name="svg"/>
  <field labelOnTop="0" name="sys_type"/>
  <field labelOnTop="0" name="top_elev"/>
  <field labelOnTop="0" name="tstamp"/>
  <field labelOnTop="0" name="uncertain"/>
  <field labelOnTop="0" name="undelete"/>
  <field labelOnTop="0" name="units"/>
  <field labelOnTop="0" name="units_placement"/>
  <field labelOnTop="0" name="verified"/>
  <field labelOnTop="0" name="workcat_id"/>
  <field labelOnTop="0" name="workcat_id_end"/>
  <field labelOnTop="0" name="workcat_id_plan"/>
  <field labelOnTop="0" name="ymax"/>
 </labelOnTop>
 <reuseLastValue>
  <field name="access_type" reuseLastValue="0"/>
  <field name="adate" reuseLastValue="0"/>
  <field name="adescript" reuseLastValue="0"/>
  <field name="annotation" reuseLastValue="0"/>
  <field name="arc_id" reuseLastValue="0"/>
  <field name="asset_id" reuseLastValue="0"/>
  <field name="buildercat_id" reuseLastValue="0"/>
  <field name="builtdate" reuseLastValue="0"/>
  <field name="cat_grate_matcat" reuseLastValue="0"/>
  <field name="category_type" reuseLastValue="0"/>
  <field name="code" reuseLastValue="0"/>
  <field name="comment" reuseLastValue="0"/>
  <field name="connec_arccat_id" reuseLastValue="0"/>
  <field name="connec_depth" reuseLastValue="0"/>
  <field name="connec_length" reuseLastValue="0"/>
  <field name="connec_matcat_id" reuseLastValue="0"/>
  <field name="connec_y1" reuseLastValue="0"/>
  <field name="connec_y2" reuseLastValue="0"/>
  <field name="descript" reuseLastValue="0"/>
  <field name="district_id" reuseLastValue="0"/>
  <field name="dma_id" reuseLastValue="0"/>
  <field name="drainzone_id" reuseLastValue="0"/>
  <field name="drainzone_type" reuseLastValue="0"/>
  <field name="enddate" reuseLastValue="0"/>
  <field name="epa_type" reuseLastValue="0"/>
  <field name="expl_id" reuseLastValue="0"/>
  <field name="expl_id2" reuseLastValue="0"/>
  <field name="fluid_type" reuseLastValue="0"/>
  <field name="function_type" reuseLastValue="0"/>
  <field name="grate_length" reuseLastValue="0"/>
  <field name="grate_width" reuseLastValue="0"/>
  <field name="gratecat2_id" reuseLastValue="0"/>
  <field name="gratecat_id" reuseLastValue="0"/>
  <field name="groove" reuseLastValue="0"/>
  <field name="groove_height" reuseLastValue="0"/>
  <field name="groove_length" reuseLastValue="0"/>
  <field name="gully_id" reuseLastValue="0"/>
  <field name="gully_type" reuseLastValue="0"/>
  <field name="inp_type" reuseLastValue="0"/>
  <field name="insert_user" reuseLastValue="0"/>
  <field name="inventory" reuseLastValue="0"/>
  <field name="is_operative" reuseLastValue="0"/>
  <field name="label" reuseLastValue="0"/>
  <field name="label_quadrant" reuseLastValue="0"/>
  <field name="label_rotation" reuseLastValue="0"/>
  <field name="label_x" reuseLastValue="0"/>
  <field name="label_y" reuseLastValue="0"/>
  <field name="lastupdate" reuseLastValue="0"/>
  <field name="lastupdate_user" reuseLastValue="0"/>
  <field name="link" reuseLastValue="0"/>
  <field name="location_type" reuseLastValue="0"/>
  <field name="macrodma_id" reuseLastValue="0"/>
  <field name="macroexpl_id" reuseLastValue="0"/>
  <field name="macrominsector_id" reuseLastValue="0"/>
  <field name="macrosector_id" reuseLastValue="0"/>
  <field name="matcat_id" reuseLastValue="0"/>
  <field name="minsector_id" reuseLastValue="0"/>
  <field name="muni_id" reuseLastValue="0"/>
  <field name="num_value" reuseLastValue="0"/>
  <field name="observ" reuseLastValue="0"/>
  <field name="odorflap" reuseLastValue="0"/>
  <field name="ownercat_id" reuseLastValue="0"/>
  <field name="pjoint_id" reuseLastValue="0"/>
  <field name="pjoint_type" reuseLastValue="0"/>
  <field name="placement_type" reuseLastValue="0"/>
  <field name="postcode" reuseLastValue="0"/>
  <field name="postcomplement" reuseLastValue="0"/>
  <field name="postcomplement2" reuseLastValue="0"/>
  <field name="postnumber" reuseLastValue="0"/>
  <field name="postnumber2" reuseLastValue="0"/>
  <field name="province_id" reuseLastValue="0"/>
  <field name="publish" reuseLastValue="0"/>
  <field name="region_id" reuseLastValue="0"/>
  <field name="rotation" reuseLastValue="0"/>
  <field name="sandbox" reuseLastValue="0"/>
  <field name="sector_id" reuseLastValue="0"/>
  <field name="sector_type" reuseLastValue="0"/>
  <field name="siphon" reuseLastValue="0"/>
  <field name="siphon_type" reuseLastValue="0"/>
  <field name="soilcat_id" reuseLastValue="0"/>
  <field name="state" reuseLastValue="0"/>
  <field name="state_type" reuseLastValue="0"/>
  <field name="streetname" reuseLastValue="0"/>
  <field name="streetname2" reuseLastValue="0"/>
  <field name="svg" reuseLastValue="0"/>
  <field name="sys_type" reuseLastValue="0"/>
  <field name="top_elev" reuseLastValue="0"/>
  <field name="tstamp" reuseLastValue="0"/>
  <field name="uncertain" reuseLastValue="0"/>
  <field name="undelete" reuseLastValue="0"/>
  <field name="units" reuseLastValue="0"/>
  <field name="units_placement" reuseLastValue="0"/>
  <field name="verified" reuseLastValue="0"/>
  <field name="workcat_id" reuseLastValue="0"/>
  <field name="workcat_id_end" reuseLastValue="0"/>
  <field name="workcat_id_plan" reuseLastValue="0"/>
  <field name="ymax" reuseLastValue="0"/>
 </reuseLastValue>
 <dataDefinedFieldProperties/>
 <widgets/>
 <previewExpression>"gully_id"</previewExpression>
 <mapTip></mapTip>
 <layerGeometryType>0</layerGeometryType>
</qgis>');


UPDATE sys_style set stylevalue = 
'<!DOCTYPE qgis PUBLIC ''http://mrcc.com/qgis.dtd'' ''SYSTEM''>
<qgis simplifyMaxScale="1" hasScaleBasedVisibilityFlag="0" readOnly="0" maxScale="0" simplifyDrawingTol="1" simplifyAlgorithm="0" symbologyReferenceScale="-1" version="3.28.5-Firenze" styleCategories="AllStyleCategories" minScale="0" labelsEnabled="1" simplifyLocal="1" simplifyDrawingHints="1">
 <flags>
  <Identifiable>1</Identifiable>
  <Removable>1</Removable>
  <Searchable>1</Searchable>
  <Private>0</Private>
 </flags>
 <temporal limitMode="0" endField="" fixedDuration="0" mode="0" startExpression="" enabled="0" endExpression="" durationField="" accumulate="0" durationUnit="min" startField="">
  <fixedRange>
   <start></start>
   <end></end>
  </fixedRange>
 </temporal>
 <elevation binding="Centroid" showMarkerSymbolInSurfacePlots="0" zoffset="0" symbology="Line" extrusionEnabled="0" respectLayerSymbol="1" zscale="1" extrusion="0" clamping="Terrain" type="IndividualFeatures">
  <data-defined-properties>
   <Option type="Map">
    <Option value="" name="name" type="QString"/>
    <Option name="properties"/>
    <Option value="collection" name="type" type="QString"/>
   </Option>
  </data-defined-properties>
  <profileLineSymbol>
   <symbol clip_to_extent="1" is_animated="0" frame_rate="10" name="" type="line" force_rhr="0" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option value="" name="name" type="QString"/>
      <Option name="properties"/>
      <Option value="collection" name="type" type="QString"/>
     </Option>
    </data_defined_properties>
    <layer pass="0" locked="0" enabled="1" class="SimpleLine">
     <Option type="Map">
      <Option value="0" name="align_dash_pattern" type="QString"/>
      <Option value="square" name="capstyle" type="QString"/>
      <Option value="5;2" name="customdash" type="QString"/>
      <Option value="3x:0,0,0,0,0,0" name="customdash_map_unit_scale" type="QString"/>
      <Option value="MM" name="customdash_unit" type="QString"/>
      <Option value="0" name="dash_pattern_offset" type="QString"/>
      <Option value="3x:0,0,0,0,0,0" name="dash_pattern_offset_map_unit_scale" type="QString"/>
      <Option value="MM" name="dash_pattern_offset_unit" type="QString"/>
      <Option value="0" name="draw_inside_polygon" type="QString"/>
      <Option value="bevel" name="joinstyle" type="QString"/>
      <Option value="145,82,45,255" name="line_color" type="QString"/>
      <Option value="solid" name="line_style" type="QString"/>
      <Option value="0.6" name="line_width" type="QString"/>
      <Option value="MM" name="line_width_unit" type="QString"/>
      <Option value="0" name="offset" type="QString"/>
      <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
      <Option value="MM" name="offset_unit" type="QString"/>
      <Option value="0" name="ring_filter" type="QString"/>
      <Option value="0" name="trim_distance_end" type="QString"/>
      <Option value="3x:0,0,0,0,0,0" name="trim_distance_end_map_unit_scale" type="QString"/>
      <Option value="MM" name="trim_distance_end_unit" type="QString"/>
      <Option value="0" name="trim_distance_start" type="QString"/>
      <Option value="3x:0,0,0,0,0,0" name="trim_distance_start_map_unit_scale" type="QString"/>
      <Option value="MM" name="trim_distance_start_unit" type="QString"/>
      <Option value="0" name="tweak_dash_pattern_on_corners" type="QString"/>
      <Option value="0" name="use_custom_dash" type="QString"/>
      <Option value="3x:0,0,0,0,0,0" name="width_map_unit_scale" type="QString"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" name="name" type="QString"/>
       <Option name="properties"/>
       <Option value="collection" name="type" type="QString"/>
      </Option>
     </data_defined_properties>
    </layer>
   </symbol>
  </profileLineSymbol>
  <profileFillSymbol>
   <symbol clip_to_extent="1" is_animated="0" frame_rate="10" name="" type="fill" force_rhr="0" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option value="" name="name" type="QString"/>
      <Option name="properties"/>
      <Option value="collection" name="type" type="QString"/>
     </Option>
    </data_defined_properties>
    <layer pass="0" locked="0" enabled="1" class="SimpleFill">
     <Option type="Map">
      <Option value="3x:0,0,0,0,0,0" name="border_width_map_unit_scale" type="QString"/>
      <Option value="145,82,45,255" name="color" type="QString"/>
      <Option value="bevel" name="joinstyle" type="QString"/>
      <Option value="0,0" name="offset" type="QString"/>
      <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
      <Option value="MM" name="offset_unit" type="QString"/>
      <Option value="104,59,32,255" name="outline_color" type="QString"/>
      <Option value="solid" name="outline_style" type="QString"/>
      <Option value="0.2" name="outline_width" type="QString"/>
      <Option value="MM" name="outline_width_unit" type="QString"/>
      <Option value="solid" name="style" type="QString"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" name="name" type="QString"/>
       <Option name="properties"/>
       <Option value="collection" name="type" type="QString"/>
      </Option>
     </data_defined_properties>
    </layer>
   </symbol>
  </profileFillSymbol>
  <profileMarkerSymbol>
   <symbol clip_to_extent="1" is_animated="0" frame_rate="10" name="" type="marker" force_rhr="0" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option value="" name="name" type="QString"/>
      <Option name="properties"/>
      <Option value="collection" name="type" type="QString"/>
     </Option>
    </data_defined_properties>
    <layer pass="0" locked="0" enabled="1" class="SimpleMarker">
     <Option type="Map">
      <Option value="0" name="angle" type="QString"/>
      <Option value="square" name="cap_style" type="QString"/>
      <Option value="145,82,45,255" name="color" type="QString"/>
      <Option value="1" name="horizontal_anchor_point" type="QString"/>
      <Option value="bevel" name="joinstyle" type="QString"/>
      <Option value="diamond" name="name" type="QString"/>
      <Option value="0,0" name="offset" type="QString"/>
      <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
      <Option value="MM" name="offset_unit" type="QString"/>
      <Option value="104,59,32,255" name="outline_color" type="QString"/>
      <Option value="solid" name="outline_style" type="QString"/>
      <Option value="0.2" name="outline_width" type="QString"/>
      <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
      <Option value="MM" name="outline_width_unit" type="QString"/>
      <Option value="diameter" name="scale_method" type="QString"/>
      <Option value="3" name="size" type="QString"/>
      <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
      <Option value="MM" name="size_unit" type="QString"/>
      <Option value="1" name="vertical_anchor_point" type="QString"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" name="name" type="QString"/>
       <Option name="properties"/>
       <Option value="collection" name="type" type="QString"/>
      </Option>
     </data_defined_properties>
    </layer>
   </symbol>
  </profileMarkerSymbol>
 </elevation>
 <renderer-v2 forceraster="0" type="RuleRenderer" enableorderby="0" symbollevels="0" referencescale="-1">
  <rules key="{4cb3e952-bd79-40ee-9f19-dc8fa18f2452}">
   <rule symbol="0" label="CONDUIT" key="{294ddb79-aff2-4244-a83c-29b1c7e34366}" filter="&quot;inp_type&quot; = ''CONDUIT''"/>
   <rule symbol="1" label="VIRTUAL" key="{bd4ace4b-318d-428c-a3c1-0ce17445beda}" filter="&quot;inp_type&quot; = ''VIRTUAL''"/>
   <rule symbol="2" label="PUMP" key="{2f673a7d-f319-42d8-a666-36380c3a0818}" filter="&quot;inp_type&quot; = ''PUMP''"/>
   <rule symbol="3" label="WEIR" key="{dde3a32f-0f78-4ca9-b6c5-6ca0f43a7cec}" filter="&quot;inp_type&quot; = ''WEIR''"/>
   <rule symbol="4" label="ORIFICE" key="{3ca1f4ff-af9b-4c83-beb6-5e924bcac7ec}" filter="&quot;inp_type&quot; = ''ORIFICE''"/>
   <rule symbol="5" label="OUTLET" key="{4007a203-30ed-448e-8322-65999b1f7a07}" filter="&quot;inp_type&quot; = ''OUTLET''"/>
   <rule symbol="6" label="NOT USED" key="{9c3b163a-25f9-44cc-a324-c05147612097}" filter="&quot;inp_type&quot; IS NULL"/>
  </rules>
  <symbols>
   <symbol clip_to_extent="1" is_animated="0" frame_rate="10" name="0" type="line" force_rhr="0" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option value="" name="name" type="QString"/>
      <Option name="properties"/>
      <Option value="collection" name="type" type="QString"/>
     </Option>
    </data_defined_properties>
    <layer pass="0" locked="0" enabled="1" class="SimpleLine">
     <Option type="Map">
      <Option value="0" name="align_dash_pattern" type="QString"/>
      <Option value="square" name="capstyle" type="QString"/>
      <Option value="5;2" name="customdash" type="QString"/>
      <Option value="3x:0,0,0,0,0,0" name="customdash_map_unit_scale" type="QString"/>
      <Option value="MM" name="customdash_unit" type="QString"/>
      <Option value="0" name="dash_pattern_offset" type="QString"/>
      <Option value="3x:0,0,0,0,0,0" name="dash_pattern_offset_map_unit_scale" type="QString"/>
      <Option value="MM" name="dash_pattern_offset_unit" type="QString"/>
      <Option value="0" name="draw_inside_polygon" type="QString"/>
      <Option value="bevel" name="joinstyle" type="QString"/>
      <Option value="31,120,180,255" name="line_color" type="QString"/>
      <Option value="solid" name="line_style" type="QString"/>
      <Option value="0.56" name="line_width" type="QString"/>
      <Option value="MM" name="line_width_unit" type="QString"/>
      <Option value="0" name="offset" type="QString"/>
      <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
      <Option value="MM" name="offset_unit" type="QString"/>
      <Option value="0" name="ring_filter" type="QString"/>
      <Option value="0" name="trim_distance_end" type="QString"/>
      <Option value="3x:0,0,0,0,0,0" name="trim_distance_end_map_unit_scale" type="QString"/>
      <Option value="MM" name="trim_distance_end_unit" type="QString"/>
      <Option value="0" name="trim_distance_start" type="QString"/>
      <Option value="3x:0,0,0,0,0,0" name="trim_distance_start_map_unit_scale" type="QString"/>
      <Option value="MM" name="trim_distance_start_unit" type="QString"/>
      <Option value="0" name="tweak_dash_pattern_on_corners" type="QString"/>
      <Option value="0" name="use_custom_dash" type="QString"/>
      <Option value="3x:0,0,0,0,0,0" name="width_map_unit_scale" type="QString"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" name="name" type="QString"/>
       <Option name="properties" type="Map">
        <Option name="outlineWidth" type="Map">
         <Option value="true" name="active" type="bool"/>
         <Option value="CASE &#xd;&#xa;WHEN  @map_scale  &lt;= 5000 THEN 0.55&#xd;&#xa;WHEN @map_scale  > 5000 THEN  &quot;conduit_cat_geom1&quot; * 0.4&#xd;&#xa;END" name="expression" type="QString"/>
         <Option value="3" name="type" type="int"/>
        </Option>
       </Option>
       <Option value="collection" name="type" type="QString"/>
      </Option>
     </data_defined_properties>
    </layer>
    <layer pass="0" locked="0" enabled="1" class="MarkerLine">
     <Option type="Map">
      <Option value="4" name="average_angle_length" type="QString"/>
      <Option value="3x:0,0,0,0,0,0" name="average_angle_map_unit_scale" type="QString"/>
      <Option value="MM" name="average_angle_unit" type="QString"/>
      <Option value="3" name="interval" type="QString"/>
      <Option value="3x:0,0,0,0,0,0" name="interval_map_unit_scale" type="QString"/>
      <Option value="MM" name="interval_unit" type="QString"/>
      <Option value="0" name="offset" type="QString"/>
      <Option value="0" name="offset_along_line" type="QString"/>
      <Option value="3x:0,0,0,0,0,0" name="offset_along_line_map_unit_scale" type="QString"/>
      <Option value="MM" name="offset_along_line_unit" type="QString"/>
      <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
      <Option value="MM" name="offset_unit" type="QString"/>
      <Option value="true" name="place_on_every_part" type="bool"/>
      <Option value="CentralPoint" name="placements" type="QString"/>
      <Option value="0" name="ring_filter" type="QString"/>
      <Option value="1" name="rotate" type="QString"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" name="name" type="QString"/>
       <Option name="properties" type="Map">
        <Option name="outlineWidth" type="Map">
         <Option value="true" name="active" type="bool"/>
         <Option value="CASE &#xd;&#xa;WHEN  @map_scale  &lt;= 5000 THEN 2.0 &#xd;&#xa;WHEN @map_scale  > 5000 THEN 0&#xd;&#xa;END" name="expression" type="QString"/>
         <Option value="3" name="type" type="int"/>
        </Option>
       </Option>
       <Option value="collection" name="type" type="QString"/>
      </Option>
     </data_defined_properties>
     <symbol clip_to_extent="1" is_animated="0" frame_rate="10" name="@0@1" type="marker" force_rhr="0" alpha="1">
      <data_defined_properties>
       <Option type="Map">
        <Option value="" name="name" type="QString"/>
        <Option name="properties"/>
        <Option value="collection" name="type" type="QString"/>
       </Option>
      </data_defined_properties>
      <layer pass="0" locked="0" enabled="1" class="SimpleMarker">
       <Option type="Map">
        <Option value="0" name="angle" type="QString"/>
        <Option value="square" name="cap_style" type="QString"/>
        <Option value="31,120,180,255" name="color" type="QString"/>
        <Option value="1" name="horizontal_anchor_point" type="QString"/>
        <Option value="bevel" name="joinstyle" type="QString"/>
        <Option value="filled_arrowhead" name="name" type="QString"/>
        <Option value="0,0" name="offset" type="QString"/>
        <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
        <Option value="MM" name="offset_unit" type="QString"/>
        <Option value="0,0,0,255" name="outline_color" type="QString"/>
        <Option value="solid" name="outline_style" type="QString"/>
        <Option value="0" name="outline_width" type="QString"/>
        <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
        <Option value="MM" name="outline_width_unit" type="QString"/>
        <Option value="diameter" name="scale_method" type="QString"/>
        <Option value="1.56" name="size" type="QString"/>
        <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
        <Option value="MM" name="size_unit" type="QString"/>
        <Option value="1" name="vertical_anchor_point" type="QString"/>
       </Option>
       <data_defined_properties>
        <Option type="Map">
         <Option value="" name="name" type="QString"/>
         <Option name="properties" type="Map">
          <Option name="size" type="Map">
           <Option value="true" name="active" type="bool"/>
           <Option value="CASE &#xd;&#xa;WHEN  @map_scale  &lt;= 1000 THEN 2.0 &#xd;&#xa;WHEN @map_scale  > 1000 THEN 0&#xd;&#xa;END" name="expression" type="QString"/>
           <Option value="3" name="type" type="int"/>
          </Option>
         </Option>
         <Option value="collection" name="type" type="QString"/>
        </Option>
       </data_defined_properties>
      </layer>
     </symbol>
    </layer>
   </symbol>
   <symbol clip_to_extent="1" is_animated="0" frame_rate="10" name="1" type="line" force_rhr="0" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option value="" name="name" type="QString"/>
      <Option name="properties"/>
      <Option value="collection" name="type" type="QString"/>
     </Option>
    </data_defined_properties>
    <layer pass="0" locked="0" enabled="1" class="SimpleLine">
     <Option type="Map">
      <Option value="0" name="align_dash_pattern" type="QString"/>
      <Option value="square" name="capstyle" type="QString"/>
      <Option value="5;2" name="customdash" type="QString"/>
      <Option value="3x:0,0,0,0,0,0" name="customdash_map_unit_scale" type="QString"/>
      <Option value="MM" name="customdash_unit" type="QString"/>
      <Option value="0" name="dash_pattern_offset" type="QString"/>
      <Option value="3x:0,0,0,0,0,0" name="dash_pattern_offset_map_unit_scale" type="QString"/>
      <Option value="MM" name="dash_pattern_offset_unit" type="QString"/>
      <Option value="0" name="draw_inside_polygon" type="QString"/>
      <Option value="bevel" name="joinstyle" type="QString"/>
      <Option value="31,120,180,255" name="line_color" type="QString"/>
      <Option value="dot" name="line_style" type="QString"/>
      <Option value="0.56" name="line_width" type="QString"/>
      <Option value="MM" name="line_width_unit" type="QString"/>
      <Option value="0" name="offset" type="QString"/>
      <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
      <Option value="MM" name="offset_unit" type="QString"/>
      <Option value="0" name="ring_filter" type="QString"/>
      <Option value="0" name="trim_distance_end" type="QString"/>
      <Option value="3x:0,0,0,0,0,0" name="trim_distance_end_map_unit_scale" type="QString"/>
      <Option value="MM" name="trim_distance_end_unit" type="QString"/>
      <Option value="0" name="trim_distance_start" type="QString"/>
      <Option value="3x:0,0,0,0,0,0" name="trim_distance_start_map_unit_scale" type="QString"/>
      <Option value="MM" name="trim_distance_start_unit" type="QString"/>
      <Option value="0" name="tweak_dash_pattern_on_corners" type="QString"/>
      <Option value="0" name="use_custom_dash" type="QString"/>
      <Option value="3x:0,0,0,0,0,0" name="width_map_unit_scale" type="QString"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" name="name" type="QString"/>
       <Option name="properties" type="Map">
        <Option name="outlineWidth" type="Map">
         <Option value="true" name="active" type="bool"/>
         <Option value="CASE &#xd;&#xa;WHEN  @map_scale  &lt;= 5000 THEN 0.55&#xd;&#xa;WHEN @map_scale  > 5000 THEN  &quot;conduit_cat_geom1&quot; * 0.4&#xd;&#xa;END" name="expression" type="QString"/>
         <Option value="3" name="type" type="int"/>
        </Option>
       </Option>
       <Option value="collection" name="type" type="QString"/>
      </Option>
     </data_defined_properties>
    </layer>
    <layer pass="0" locked="0" enabled="1" class="MarkerLine">
     <Option type="Map">
      <Option value="4" name="average_angle_length" type="QString"/>
      <Option value="3x:0,0,0,0,0,0" name="average_angle_map_unit_scale" type="QString"/>
      <Option value="MM" name="average_angle_unit" type="QString"/>
      <Option value="3" name="interval" type="QString"/>
      <Option value="3x:0,0,0,0,0,0" name="interval_map_unit_scale" type="QString"/>
      <Option value="MM" name="interval_unit" type="QString"/>
      <Option value="0" name="offset" type="QString"/>
      <Option value="0" name="offset_along_line" type="QString"/>
      <Option value="3x:0,0,0,0,0,0" name="offset_along_line_map_unit_scale" type="QString"/>
      <Option value="MM" name="offset_along_line_unit" type="QString"/>
      <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
      <Option value="MM" name="offset_unit" type="QString"/>
      <Option value="true" name="place_on_every_part" type="bool"/>
      <Option value="CentralPoint" name="placements" type="QString"/>
      <Option value="0" name="ring_filter" type="QString"/>
      <Option value="1" name="rotate" type="QString"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" name="name" type="QString"/>
       <Option name="properties" type="Map">
        <Option name="outlineWidth" type="Map">
         <Option value="true" name="active" type="bool"/>
         <Option value="CASE &#xd;&#xa;WHEN  @map_scale  &lt;= 5000 THEN 2.0 &#xd;&#xa;WHEN @map_scale  > 5000 THEN 0&#xd;&#xa;END" name="expression" type="QString"/>
         <Option value="3" name="type" type="int"/>
        </Option>
       </Option>
       <Option value="collection" name="type" type="QString"/>
      </Option>
     </data_defined_properties>
     <symbol clip_to_extent="1" is_animated="0" frame_rate="10" name="@1@1" type="marker" force_rhr="0" alpha="1">
      <data_defined_properties>
       <Option type="Map">
        <Option value="" name="name" type="QString"/>
        <Option name="properties"/>
        <Option value="collection" name="type" type="QString"/>
       </Option>
      </data_defined_properties>
      <layer pass="0" locked="0" enabled="1" class="SimpleMarker">
       <Option type="Map">
        <Option value="0" name="angle" type="QString"/>
        <Option value="square" name="cap_style" type="QString"/>
        <Option value="31,120,180,255" name="color" type="QString"/>
        <Option value="1" name="horizontal_anchor_point" type="QString"/>
        <Option value="bevel" name="joinstyle" type="QString"/>
        <Option value="filled_arrowhead" name="name" type="QString"/>
        <Option value="0,0" name="offset" type="QString"/>
        <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
        <Option value="MM" name="offset_unit" type="QString"/>
        <Option value="0,0,0,255" name="outline_color" type="QString"/>
        <Option value="solid" name="outline_style" type="QString"/>
        <Option value="0" name="outline_width" type="QString"/>
        <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
        <Option value="MM" name="outline_width_unit" type="QString"/>
        <Option value="diameter" name="scale_method" type="QString"/>
        <Option value="1.56" name="size" type="QString"/>
        <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
        <Option value="MM" name="size_unit" type="QString"/>
        <Option value="1" name="vertical_anchor_point" type="QString"/>
       </Option>
       <data_defined_properties>
        <Option type="Map">
         <Option value="" name="name" type="QString"/>
         <Option name="properties" type="Map">
          <Option name="size" type="Map">
           <Option value="true" name="active" type="bool"/>
           <Option value="CASE &#xd;&#xa;WHEN  @map_scale  &lt;= 1000 THEN 2.0 &#xd;&#xa;WHEN @map_scale  > 1000 THEN 0&#xd;&#xa;END" name="expression" type="QString"/>
           <Option value="3" name="type" type="int"/>
          </Option>
         </Option>
         <Option value="collection" name="type" type="QString"/>
        </Option>
       </data_defined_properties>
      </layer>
     </symbol>
    </layer>
   </symbol>
   <symbol clip_to_extent="1" is_animated="0" frame_rate="10" name="2" type="line" force_rhr="0" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option value="" name="name" type="QString"/>
      <Option name="properties"/>
      <Option value="collection" name="type" type="QString"/>
     </Option>
    </data_defined_properties>
    <layer pass="0" locked="0" enabled="1" class="SimpleLine">
     <Option type="Map">
      <Option value="0" name="align_dash_pattern" type="QString"/>
      <Option value="square" name="capstyle" type="QString"/>
      <Option value="5;2" name="customdash" type="QString"/>
      <Option value="3x:0,0,0,0,0,0" name="customdash_map_unit_scale" type="QString"/>
      <Option value="MM" name="customdash_unit" type="QString"/>
      <Option value="0" name="dash_pattern_offset" type="QString"/>
      <Option value="3x:0,0,0,0,0,0" name="dash_pattern_offset_map_unit_scale" type="QString"/>
      <Option value="MM" name="dash_pattern_offset_unit" type="QString"/>
      <Option value="0" name="draw_inside_polygon" type="QString"/>
      <Option value="bevel" name="joinstyle" type="QString"/>
      <Option value="31,120,180,255" name="line_color" type="QString"/>
      <Option value="solid" name="line_style" type="QString"/>
      <Option value="0.483636" name="line_width" type="QString"/>
      <Option value="MM" name="line_width_unit" type="QString"/>
      <Option value="0" name="offset" type="QString"/>
      <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
      <Option value="MM" name="offset_unit" type="QString"/>
      <Option value="0" name="ring_filter" type="QString"/>
      <Option value="0" name="trim_distance_end" type="QString"/>
      <Option value="3x:0,0,0,0,0,0" name="trim_distance_end_map_unit_scale" type="QString"/>
      <Option value="MM" name="trim_distance_end_unit" type="QString"/>
      <Option value="0" name="trim_distance_start" type="QString"/>
      <Option value="3x:0,0,0,0,0,0" name="trim_distance_start_map_unit_scale" type="QString"/>
      <Option value="MM" name="trim_distance_start_unit" type="QString"/>
      <Option value="0" name="tweak_dash_pattern_on_corners" type="QString"/>
      <Option value="0" name="use_custom_dash" type="QString"/>
      <Option value="3x:0,0,0,0,0,0" name="width_map_unit_scale" type="QString"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" name="name" type="QString"/>
       <Option name="properties" type="Map">
        <Option name="outlineWidth" type="Map">
         <Option value="true" name="active" type="bool"/>
         <Option value="CASE &#xd;&#xa;WHEN  @map_scale  &lt;= 5000 THEN 0.55&#xd;&#xa;WHEN @map_scale  > 5000 THEN  &quot;conduit_cat_geom1&quot; * 0.4&#xd;&#xa;END" name="expression" type="QString"/>
         <Option value="3" name="type" type="int"/>
        </Option>
       </Option>
       <Option value="collection" name="type" type="QString"/>
      </Option>
     </data_defined_properties>
    </layer>
    <layer pass="0" locked="0" enabled="1" class="MarkerLine">
     <Option type="Map">
      <Option value="4" name="average_angle_length" type="QString"/>
      <Option value="3x:0,0,0,0,0,0" name="average_angle_map_unit_scale" type="QString"/>
      <Option value="MM" name="average_angle_unit" type="QString"/>
      <Option value="3" name="interval" type="QString"/>
      <Option value="3x:0,0,0,0,0,0" name="interval_map_unit_scale" type="QString"/>
      <Option value="MM" name="interval_unit" type="QString"/>
      <Option value="0" name="offset" type="QString"/>
      <Option value="0" name="offset_along_line" type="QString"/>
      <Option value="3x:0,0,0,0,0,0" name="offset_along_line_map_unit_scale" type="QString"/>
      <Option value="MM" name="offset_along_line_unit" type="QString"/>
      <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
      <Option value="MM" name="offset_unit" type="QString"/>
      <Option value="true" name="place_on_every_part" type="bool"/>
      <Option value="CentralPoint" name="placements" type="QString"/>
      <Option value="0" name="ring_filter" type="QString"/>
      <Option value="1" name="rotate" type="QString"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" name="name" type="QString"/>
       <Option name="properties" type="Map">
        <Option name="outlineWidth" type="Map">
         <Option value="true" name="active" type="bool"/>
         <Option value="CASE &#xd;&#xa;WHEN  @map_scale  &lt;= 5000 THEN 2.0 &#xd;&#xa;WHEN @map_scale  > 5000 THEN 0&#xd;&#xa;END" name="expression" type="QString"/>
         <Option value="3" name="type" type="int"/>
        </Option>
       </Option>
       <Option value="collection" name="type" type="QString"/>
      </Option>
     </data_defined_properties>
     <symbol clip_to_extent="1" is_animated="0" frame_rate="10" name="@2@1" type="marker" force_rhr="0" alpha="1">
      <data_defined_properties>
       <Option type="Map">
        <Option value="" name="name" type="QString"/>
        <Option name="properties"/>
        <Option value="collection" name="type" type="QString"/>
       </Option>
      </data_defined_properties>
      <layer pass="0" locked="0" enabled="1" class="SimpleMarker">
       <Option type="Map">
        <Option value="0" name="angle" type="QString"/>
        <Option value="square" name="cap_style" type="QString"/>
        <Option value="237,124,89,255" name="color" type="QString"/>
        <Option value="1" name="horizontal_anchor_point" type="QString"/>
        <Option value="bevel" name="joinstyle" type="QString"/>
        <Option value="circle" name="name" type="QString"/>
        <Option value="0,0" name="offset" type="QString"/>
        <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
        <Option value="MM" name="offset_unit" type="QString"/>
        <Option value="50,87,128,255" name="outline_color" type="QString"/>
        <Option value="solid" name="outline_style" type="QString"/>
        <Option value="0.4" name="outline_width" type="QString"/>
        <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
        <Option value="MM" name="outline_width_unit" type="QString"/>
        <Option value="diameter" name="scale_method" type="QString"/>
        <Option value="3.8" name="size" type="QString"/>
        <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
        <Option value="MM" name="size_unit" type="QString"/>
        <Option value="1" name="vertical_anchor_point" type="QString"/>
       </Option>
       <data_defined_properties>
        <Option type="Map">
         <Option value="" name="name" type="QString"/>
         <Option name="properties"/>
         <Option value="collection" name="type" type="QString"/>
        </Option>
       </data_defined_properties>
      </layer>
      <layer pass="0" locked="0" enabled="1" class="FontMarker">
       <Option type="Map">
        <Option value="0" name="angle" type="QString"/>
        <Option value="P" name="chr" type="QString"/>
        <Option value="0,0,0,255" name="color" type="QString"/>
        <Option value="MS Shell Dlg 2" name="font" type="QString"/>
        <Option value="" name="font_style" type="QString"/>
        <Option value="1" name="horizontal_anchor_point" type="QString"/>
        <Option value="bevel" name="joinstyle" type="QString"/>
        <Option value="0,0" name="offset" type="QString"/>
        <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
        <Option value="MM" name="offset_unit" type="QString"/>
        <Option value="35,35,35,255" name="outline_color" type="QString"/>
        <Option value="0" name="outline_width" type="QString"/>
        <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
        <Option value="MM" name="outline_width_unit" type="QString"/>
        <Option value="1.9" name="size" type="QString"/>
        <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
        <Option value="MM" name="size_unit" type="QString"/>
        <Option value="1" name="vertical_anchor_point" type="QString"/>
       </Option>
       <data_defined_properties>
        <Option type="Map">
         <Option value="" name="name" type="QString"/>
         <Option name="properties"/>
         <Option value="collection" name="type" type="QString"/>
        </Option>
       </data_defined_properties>
      </layer>
     </symbol>
    </layer>
   </symbol>
   <symbol clip_to_extent="1" is_animated="0" frame_rate="10" name="3" type="line" force_rhr="0" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option value="" name="name" type="QString"/>
      <Option name="properties"/>
      <Option value="collection" name="type" type="QString"/>
     </Option>
    </data_defined_properties>
    <layer pass="0" locked="0" enabled="1" class="SimpleLine">
     <Option type="Map">
      <Option value="0" name="align_dash_pattern" type="QString"/>
      <Option value="square" name="capstyle" type="QString"/>
      <Option value="5;2" name="customdash" type="QString"/>
      <Option value="3x:0,0,0,0,0,0" name="customdash_map_unit_scale" type="QString"/>
      <Option value="MM" name="customdash_unit" type="QString"/>
      <Option value="0" name="dash_pattern_offset" type="QString"/>
      <Option value="3x:0,0,0,0,0,0" name="dash_pattern_offset_map_unit_scale" type="QString"/>
      <Option value="MM" name="dash_pattern_offset_unit" type="QString"/>
      <Option value="0" name="draw_inside_polygon" type="QString"/>
      <Option value="bevel" name="joinstyle" type="QString"/>
      <Option value="31,120,180,255" name="line_color" type="QString"/>
      <Option value="solid" name="line_style" type="QString"/>
      <Option value="0.483636" name="line_width" type="QString"/>
      <Option value="MM" name="line_width_unit" type="QString"/>
      <Option value="0" name="offset" type="QString"/>
      <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
      <Option value="MM" name="offset_unit" type="QString"/>
      <Option value="0" name="ring_filter" type="QString"/>
      <Option value="0" name="trim_distance_end" type="QString"/>
      <Option value="3x:0,0,0,0,0,0" name="trim_distance_end_map_unit_scale" type="QString"/>
      <Option value="MM" name="trim_distance_end_unit" type="QString"/>
      <Option value="0" name="trim_distance_start" type="QString"/>
      <Option value="3x:0,0,0,0,0,0" name="trim_distance_start_map_unit_scale" type="QString"/>
      <Option value="MM" name="trim_distance_start_unit" type="QString"/>
      <Option value="0" name="tweak_dash_pattern_on_corners" type="QString"/>
      <Option value="0" name="use_custom_dash" type="QString"/>
      <Option value="3x:0,0,0,0,0,0" name="width_map_unit_scale" type="QString"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" name="name" type="QString"/>
       <Option name="properties" type="Map">
        <Option name="outlineWidth" type="Map">
         <Option value="true" name="active" type="bool"/>
         <Option value="CASE &#xd;&#xa;WHEN  @map_scale  &lt;= 5000 THEN 0.55&#xd;&#xa;WHEN @map_scale  > 5000 THEN  &quot;conduit_cat_geom1&quot; * 0.4&#xd;&#xa;END" name="expression" type="QString"/>
         <Option value="3" name="type" type="int"/>
        </Option>
       </Option>
       <Option value="collection" name="type" type="QString"/>
      </Option>
     </data_defined_properties>
    </layer>
    <layer pass="0" locked="0" enabled="1" class="MarkerLine">
     <Option type="Map">
      <Option value="4" name="average_angle_length" type="QString"/>
      <Option value="3x:0,0,0,0,0,0" name="average_angle_map_unit_scale" type="QString"/>
      <Option value="MM" name="average_angle_unit" type="QString"/>
      <Option value="3" name="interval" type="QString"/>
      <Option value="3x:0,0,0,0,0,0" name="interval_map_unit_scale" type="QString"/>
      <Option value="MM" name="interval_unit" type="QString"/>
      <Option value="0" name="offset" type="QString"/>
      <Option value="0" name="offset_along_line" type="QString"/>
      <Option value="3x:0,0,0,0,0,0" name="offset_along_line_map_unit_scale" type="QString"/>
      <Option value="MM" name="offset_along_line_unit" type="QString"/>
      <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
      <Option value="MM" name="offset_unit" type="QString"/>
      <Option value="true" name="place_on_every_part" type="bool"/>
      <Option value="CentralPoint" name="placements" type="QString"/>
      <Option value="0" name="ring_filter" type="QString"/>
      <Option value="1" name="rotate" type="QString"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" name="name" type="QString"/>
       <Option name="properties" type="Map">
        <Option name="outlineWidth" type="Map">
         <Option value="true" name="active" type="bool"/>
         <Option value="CASE &#xd;&#xa;WHEN  @map_scale  &lt;= 5000 THEN 2.0 &#xd;&#xa;WHEN @map_scale  > 5000 THEN 0&#xd;&#xa;END" name="expression" type="QString"/>
         <Option value="3" name="type" type="int"/>
        </Option>
       </Option>
       <Option value="collection" name="type" type="QString"/>
      </Option>
     </data_defined_properties>
     <symbol clip_to_extent="1" is_animated="0" frame_rate="10" name="@3@1" type="marker" force_rhr="0" alpha="1">
      <data_defined_properties>
       <Option type="Map">
        <Option value="" name="name" type="QString"/>
        <Option name="properties"/>
        <Option value="collection" name="type" type="QString"/>
       </Option>
      </data_defined_properties>
      <layer pass="0" locked="0" enabled="1" class="SimpleMarker">
       <Option type="Map">
        <Option value="0" name="angle" type="QString"/>
        <Option value="square" name="cap_style" type="QString"/>
        <Option value="234,237,205,255" name="color" type="QString"/>
        <Option value="1" name="horizontal_anchor_point" type="QString"/>
        <Option value="bevel" name="joinstyle" type="QString"/>
        <Option value="circle" name="name" type="QString"/>
        <Option value="0,0" name="offset" type="QString"/>
        <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
        <Option value="MM" name="offset_unit" type="QString"/>
        <Option value="50,87,128,255" name="outline_color" type="QString"/>
        <Option value="solid" name="outline_style" type="QString"/>
        <Option value="0.4" name="outline_width" type="QString"/>
        <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
        <Option value="MM" name="outline_width_unit" type="QString"/>
        <Option value="diameter" name="scale_method" type="QString"/>
        <Option value="3.8" name="size" type="QString"/>
        <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
        <Option value="MM" name="size_unit" type="QString"/>
        <Option value="1" name="vertical_anchor_point" type="QString"/>
       </Option>
       <data_defined_properties>
        <Option type="Map">
         <Option value="" name="name" type="QString"/>
         <Option name="properties"/>
         <Option value="collection" name="type" type="QString"/>
        </Option>
       </data_defined_properties>
      </layer>
      <layer pass="0" locked="0" enabled="1" class="FontMarker">
       <Option type="Map">
        <Option value="0" name="angle" type="QString"/>
        <Option value="W" name="chr" type="QString"/>
        <Option value="0,0,0,255" name="color" type="QString"/>
        <Option value="MS Shell Dlg 2" name="font" type="QString"/>
        <Option value="" name="font_style" type="QString"/>
        <Option value="1" name="horizontal_anchor_point" type="QString"/>
        <Option value="bevel" name="joinstyle" type="QString"/>
        <Option value="0,0" name="offset" type="QString"/>
        <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
        <Option value="MM" name="offset_unit" type="QString"/>
        <Option value="35,35,35,255" name="outline_color" type="QString"/>
        <Option value="0" name="outline_width" type="QString"/>
        <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
        <Option value="MM" name="outline_width_unit" type="QString"/>
        <Option value="1.9" name="size" type="QString"/>
        <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
        <Option value="MM" name="size_unit" type="QString"/>
        <Option value="1" name="vertical_anchor_point" type="QString"/>
       </Option>
       <data_defined_properties>
        <Option type="Map">
         <Option value="" name="name" type="QString"/>
         <Option name="properties"/>
         <Option value="collection" name="type" type="QString"/>
        </Option>
       </data_defined_properties>
      </layer>
     </symbol>
    </layer>
   </symbol>
   <symbol clip_to_extent="1" is_animated="0" frame_rate="10" name="4" type="line" force_rhr="0" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option value="" name="name" type="QString"/>
      <Option name="properties"/>
      <Option value="collection" name="type" type="QString"/>
     </Option>
    </data_defined_properties>
    <layer pass="0" locked="0" enabled="1" class="SimpleLine">
     <Option type="Map">
      <Option value="0" name="align_dash_pattern" type="QString"/>
      <Option value="square" name="capstyle" type="QString"/>
      <Option value="5;2" name="customdash" type="QString"/>
      <Option value="3x:0,0,0,0,0,0" name="customdash_map_unit_scale" type="QString"/>
      <Option value="MM" name="customdash_unit" type="QString"/>
      <Option value="0" name="dash_pattern_offset" type="QString"/>
      <Option value="3x:0,0,0,0,0,0" name="dash_pattern_offset_map_unit_scale" type="QString"/>
      <Option value="MM" name="dash_pattern_offset_unit" type="QString"/>
      <Option value="0" name="draw_inside_polygon" type="QString"/>
      <Option value="bevel" name="joinstyle" type="QString"/>
      <Option value="31,120,180,255" name="line_color" type="QString"/>
      <Option value="solid" name="line_style" type="QString"/>
      <Option value="0.483636" name="line_width" type="QString"/>
      <Option value="MM" name="line_width_unit" type="QString"/>
      <Option value="0" name="offset" type="QString"/>
      <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
      <Option value="MM" name="offset_unit" type="QString"/>
      <Option value="0" name="ring_filter" type="QString"/>
      <Option value="0" name="trim_distance_end" type="QString"/>
      <Option value="3x:0,0,0,0,0,0" name="trim_distance_end_map_unit_scale" type="QString"/>
      <Option value="MM" name="trim_distance_end_unit" type="QString"/>
      <Option value="0" name="trim_distance_start" type="QString"/>
      <Option value="3x:0,0,0,0,0,0" name="trim_distance_start_map_unit_scale" type="QString"/>
      <Option value="MM" name="trim_distance_start_unit" type="QString"/>
      <Option value="0" name="tweak_dash_pattern_on_corners" type="QString"/>
      <Option value="0" name="use_custom_dash" type="QString"/>
      <Option value="3x:0,0,0,0,0,0" name="width_map_unit_scale" type="QString"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" name="name" type="QString"/>
       <Option name="properties" type="Map">
        <Option name="outlineWidth" type="Map">
         <Option value="true" name="active" type="bool"/>
         <Option value="CASE &#xd;&#xa;WHEN  @map_scale  &lt;= 5000 THEN 0.55&#xd;&#xa;WHEN @map_scale  > 5000 THEN  &quot;conduit_cat_geom1&quot; * 0.4&#xd;&#xa;END" name="expression" type="QString"/>
         <Option value="3" name="type" type="int"/>
        </Option>
       </Option>
       <Option value="collection" name="type" type="QString"/>
      </Option>
     </data_defined_properties>
    </layer>
    <layer pass="0" locked="0" enabled="1" class="MarkerLine">
     <Option type="Map">
      <Option value="4" name="average_angle_length" type="QString"/>
      <Option value="3x:0,0,0,0,0,0" name="average_angle_map_unit_scale" type="QString"/>
      <Option value="MM" name="average_angle_unit" type="QString"/>
      <Option value="3" name="interval" type="QString"/>
      <Option value="3x:0,0,0,0,0,0" name="interval_map_unit_scale" type="QString"/>
      <Option value="MM" name="interval_unit" type="QString"/>
      <Option value="0" name="offset" type="QString"/>
      <Option value="0" name="offset_along_line" type="QString"/>
      <Option value="3x:0,0,0,0,0,0" name="offset_along_line_map_unit_scale" type="QString"/>
      <Option value="MM" name="offset_along_line_unit" type="QString"/>
      <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
      <Option value="MM" name="offset_unit" type="QString"/>
      <Option value="true" name="place_on_every_part" type="bool"/>
      <Option value="CentralPoint" name="placements" type="QString"/>
      <Option value="0" name="ring_filter" type="QString"/>
      <Option value="1" name="rotate" type="QString"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" name="name" type="QString"/>
       <Option name="properties" type="Map">
        <Option name="outlineWidth" type="Map">
         <Option value="true" name="active" type="bool"/>
         <Option value="CASE &#xd;&#xa;WHEN  @map_scale  &lt;= 5000 THEN 2.0 &#xd;&#xa;WHEN @map_scale  > 5000 THEN 0&#xd;&#xa;END" name="expression" type="QString"/>
         <Option value="3" name="type" type="int"/>
        </Option>
       </Option>
       <Option value="collection" name="type" type="QString"/>
      </Option>
     </data_defined_properties>
     <symbol clip_to_extent="1" is_animated="0" frame_rate="10" name="@4@1" type="marker" force_rhr="0" alpha="1">
      <data_defined_properties>
       <Option type="Map">
        <Option value="" name="name" type="QString"/>
        <Option name="properties"/>
        <Option value="collection" name="type" type="QString"/>
       </Option>
      </data_defined_properties>
      <layer pass="0" locked="0" enabled="1" class="SimpleMarker">
       <Option type="Map">
        <Option value="0" name="angle" type="QString"/>
        <Option value="square" name="cap_style" type="QString"/>
        <Option value="197,203,117,255" name="color" type="QString"/>
        <Option value="1" name="horizontal_anchor_point" type="QString"/>
        <Option value="bevel" name="joinstyle" type="QString"/>
        <Option value="circle" name="name" type="QString"/>
        <Option value="0,0" name="offset" type="QString"/>
        <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
        <Option value="MM" name="offset_unit" type="QString"/>
        <Option value="50,87,128,255" name="outline_color" type="QString"/>
        <Option value="solid" name="outline_style" type="QString"/>
        <Option value="0.4" name="outline_width" type="QString"/>
        <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
        <Option value="MM" name="outline_width_unit" type="QString"/>
        <Option value="diameter" name="scale_method" type="QString"/>
        <Option value="3.8" name="size" type="QString"/>
        <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
        <Option value="MM" name="size_unit" type="QString"/>
        <Option value="1" name="vertical_anchor_point" type="QString"/>
       </Option>
       <data_defined_properties>
        <Option type="Map">
         <Option value="" name="name" type="QString"/>
         <Option name="properties"/>
         <Option value="collection" name="type" type="QString"/>
        </Option>
       </data_defined_properties>
      </layer>
      <layer pass="0" locked="0" enabled="1" class="FontMarker">
       <Option type="Map">
        <Option value="0" name="angle" type="QString"/>
        <Option value="O" name="chr" type="QString"/>
        <Option value="0,0,0,255" name="color" type="QString"/>
        <Option value="MS Shell Dlg 2" name="font" type="QString"/>
        <Option value="" name="font_style" type="QString"/>
        <Option value="1" name="horizontal_anchor_point" type="QString"/>
        <Option value="bevel" name="joinstyle" type="QString"/>
        <Option value="0,0" name="offset" type="QString"/>
        <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
        <Option value="MM" name="offset_unit" type="QString"/>
        <Option value="35,35,35,255" name="outline_color" type="QString"/>
        <Option value="0" name="outline_width" type="QString"/>
        <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
        <Option value="MM" name="outline_width_unit" type="QString"/>
        <Option value="1.9" name="size" type="QString"/>
        <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
        <Option value="MM" name="size_unit" type="QString"/>
        <Option value="1" name="vertical_anchor_point" type="QString"/>
       </Option>
       <data_defined_properties>
        <Option type="Map">
         <Option value="" name="name" type="QString"/>
         <Option name="properties"/>
         <Option value="collection" name="type" type="QString"/>
        </Option>
       </data_defined_properties>
      </layer>
     </symbol>
    </layer>
   </symbol>
   <symbol clip_to_extent="1" is_animated="0" frame_rate="10" name="5" type="line" force_rhr="0" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option value="" name="name" type="QString"/>
      <Option name="properties"/>
      <Option value="collection" name="type" type="QString"/>
     </Option>
    </data_defined_properties>
    <layer pass="0" locked="0" enabled="1" class="SimpleLine">
     <Option type="Map">
      <Option value="0" name="align_dash_pattern" type="QString"/>
      <Option value="square" name="capstyle" type="QString"/>
      <Option value="5;2" name="customdash" type="QString"/>
      <Option value="3x:0,0,0,0,0,0" name="customdash_map_unit_scale" type="QString"/>
      <Option value="MM" name="customdash_unit" type="QString"/>
      <Option value="0" name="dash_pattern_offset" type="QString"/>
      <Option value="3x:0,0,0,0,0,0" name="dash_pattern_offset_map_unit_scale" type="QString"/>
      <Option value="MM" name="dash_pattern_offset_unit" type="QString"/>
      <Option value="0" name="draw_inside_polygon" type="QString"/>
      <Option value="bevel" name="joinstyle" type="QString"/>
      <Option value="31,120,180,255" name="line_color" type="QString"/>
      <Option value="solid" name="line_style" type="QString"/>
      <Option value="0.483636" name="line_width" type="QString"/>
      <Option value="MM" name="line_width_unit" type="QString"/>
      <Option value="0" name="offset" type="QString"/>
      <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
      <Option value="MM" name="offset_unit" type="QString"/>
      <Option value="0" name="ring_filter" type="QString"/>
      <Option value="0" name="trim_distance_end" type="QString"/>
      <Option value="3x:0,0,0,0,0,0" name="trim_distance_end_map_unit_scale" type="QString"/>
      <Option value="MM" name="trim_distance_end_unit" type="QString"/>
      <Option value="0" name="trim_distance_start" type="QString"/>
      <Option value="3x:0,0,0,0,0,0" name="trim_distance_start_map_unit_scale" type="QString"/>
      <Option value="MM" name="trim_distance_start_unit" type="QString"/>
      <Option value="0" name="tweak_dash_pattern_on_corners" type="QString"/>
      <Option value="0" name="use_custom_dash" type="QString"/>
      <Option value="3x:0,0,0,0,0,0" name="width_map_unit_scale" type="QString"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" name="name" type="QString"/>
       <Option name="properties" type="Map">
        <Option name="outlineWidth" type="Map">
         <Option value="true" name="active" type="bool"/>
         <Option value="CASE &#xd;&#xa;WHEN  @map_scale  &lt;= 5000 THEN 0.55&#xd;&#xa;WHEN @map_scale  > 5000 THEN  &quot;conduit_cat_geom1&quot; * 0.4&#xd;&#xa;END" name="expression" type="QString"/>
         <Option value="3" name="type" type="int"/>
        </Option>
       </Option>
       <Option value="collection" name="type" type="QString"/>
      </Option>
     </data_defined_properties>
    </layer>
    <layer pass="0" locked="0" enabled="1" class="MarkerLine">
     <Option type="Map">
      <Option value="4" name="average_angle_length" type="QString"/>
      <Option value="3x:0,0,0,0,0,0" name="average_angle_map_unit_scale" type="QString"/>
      <Option value="MM" name="average_angle_unit" type="QString"/>
      <Option value="3" name="interval" type="QString"/>
      <Option value="3x:0,0,0,0,0,0" name="interval_map_unit_scale" type="QString"/>
      <Option value="MM" name="interval_unit" type="QString"/>
      <Option value="0" name="offset" type="QString"/>
      <Option value="0" name="offset_along_line" type="QString"/>
      <Option value="3x:0,0,0,0,0,0" name="offset_along_line_map_unit_scale" type="QString"/>
      <Option value="MM" name="offset_along_line_unit" type="QString"/>
      <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
      <Option value="MM" name="offset_unit" type="QString"/>
      <Option value="true" name="place_on_every_part" type="bool"/>
      <Option value="CentralPoint" name="placements" type="QString"/>
      <Option value="0" name="ring_filter" type="QString"/>
      <Option value="1" name="rotate" type="QString"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" name="name" type="QString"/>
       <Option name="properties" type="Map">
        <Option name="outlineWidth" type="Map">
         <Option value="true" name="active" type="bool"/>
         <Option value="CASE &#xd;&#xa;WHEN  @map_scale  &lt;= 5000 THEN 2.0 &#xd;&#xa;WHEN @map_scale  > 5000 THEN 0&#xd;&#xa;END" name="expression" type="QString"/>
         <Option value="3" name="type" type="int"/>
        </Option>
       </Option>
       <Option value="collection" name="type" type="QString"/>
      </Option>
     </data_defined_properties>
     <symbol clip_to_extent="1" is_animated="0" frame_rate="10" name="@5@1" type="marker" force_rhr="0" alpha="1">
      <data_defined_properties>
       <Option type="Map">
        <Option value="" name="name" type="QString"/>
        <Option name="properties"/>
        <Option value="collection" name="type" type="QString"/>
       </Option>
      </data_defined_properties>
      <layer pass="0" locked="0" enabled="1" class="SimpleMarker">
       <Option type="Map">
        <Option value="0" name="angle" type="QString"/>
        <Option value="square" name="cap_style" type="QString"/>
        <Option value="175,186,23,255" name="color" type="QString"/>
        <Option value="1" name="horizontal_anchor_point" type="QString"/>
        <Option value="bevel" name="joinstyle" type="QString"/>
        <Option value="circle" name="name" type="QString"/>
        <Option value="0,0" name="offset" type="QString"/>
        <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
        <Option value="MM" name="offset_unit" type="QString"/>
        <Option value="50,87,128,255" name="outline_color" type="QString"/>
        <Option value="solid" name="outline_style" type="QString"/>
        <Option value="0.4" name="outline_width" type="QString"/>
        <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
        <Option value="MM" name="outline_width_unit" type="QString"/>
        <Option value="diameter" name="scale_method" type="QString"/>
        <Option value="3.8" name="size" type="QString"/>
        <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
        <Option value="MM" name="size_unit" type="QString"/>
        <Option value="1" name="vertical_anchor_point" type="QString"/>
       </Option>
       <data_defined_properties>
        <Option type="Map">
         <Option value="" name="name" type="QString"/>
         <Option name="properties"/>
         <Option value="collection" name="type" type="QString"/>
        </Option>
       </data_defined_properties>
      </layer>
      <layer pass="0" locked="0" enabled="1" class="FontMarker">
       <Option type="Map">
        <Option value="0" name="angle" type="QString"/>
        <Option value="L" name="chr" type="QString"/>
        <Option value="0,0,0,255" name="color" type="QString"/>
        <Option value="MS Shell Dlg 2" name="font" type="QString"/>
        <Option value="" name="font_style" type="QString"/>
        <Option value="1" name="horizontal_anchor_point" type="QString"/>
        <Option value="bevel" name="joinstyle" type="QString"/>
        <Option value="0,0" name="offset" type="QString"/>
        <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
        <Option value="MM" name="offset_unit" type="QString"/>
        <Option value="35,35,35,255" name="outline_color" type="QString"/>
        <Option value="0" name="outline_width" type="QString"/>
        <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
        <Option value="MM" name="outline_width_unit" type="QString"/>
        <Option value="1.9" name="size" type="QString"/>
        <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
        <Option value="MM" name="size_unit" type="QString"/>
        <Option value="1" name="vertical_anchor_point" type="QString"/>
       </Option>
       <data_defined_properties>
        <Option type="Map">
         <Option value="" name="name" type="QString"/>
         <Option name="properties"/>
         <Option value="collection" name="type" type="QString"/>
        </Option>
       </data_defined_properties>
      </layer>
     </symbol>
    </layer>
   </symbol>
   <symbol clip_to_extent="1" is_animated="0" frame_rate="10" name="6" type="line" force_rhr="0" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option value="" name="name" type="QString"/>
      <Option name="properties"/>
      <Option value="collection" name="type" type="QString"/>
     </Option>
    </data_defined_properties>
    <layer pass="0" locked="0" enabled="1" class="SimpleLine">
     <Option type="Map">
      <Option value="0" name="align_dash_pattern" type="QString"/>
      <Option value="square" name="capstyle" type="QString"/>
      <Option value="5;2" name="customdash" type="QString"/>
      <Option value="3x:0,0,0,0,0,0" name="customdash_map_unit_scale" type="QString"/>
      <Option value="MM" name="customdash_unit" type="QString"/>
      <Option value="0" name="dash_pattern_offset" type="QString"/>
      <Option value="3x:0,0,0,0,0,0" name="dash_pattern_offset_map_unit_scale" type="QString"/>
      <Option value="MM" name="dash_pattern_offset_unit" type="QString"/>
      <Option value="0" name="draw_inside_polygon" type="QString"/>
      <Option value="bevel" name="joinstyle" type="QString"/>
      <Option value="206,206,206,255" name="line_color" type="QString"/>
      <Option value="solid" name="line_style" type="QString"/>
      <Option value="0.5" name="line_width" type="QString"/>
      <Option value="MM" name="line_width_unit" type="QString"/>
      <Option value="0" name="offset" type="QString"/>
      <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
      <Option value="MM" name="offset_unit" type="QString"/>
      <Option value="0" name="ring_filter" type="QString"/>
      <Option value="0" name="trim_distance_end" type="QString"/>
      <Option value="3x:0,0,0,0,0,0" name="trim_distance_end_map_unit_scale" type="QString"/>
      <Option value="MM" name="trim_distance_end_unit" type="QString"/>
      <Option value="0" name="trim_distance_start" type="QString"/>
      <Option value="3x:0,0,0,0,0,0" name="trim_distance_start_map_unit_scale" type="QString"/>
      <Option value="MM" name="trim_distance_start_unit" type="QString"/>
      <Option value="0" name="tweak_dash_pattern_on_corners" type="QString"/>
      <Option value="0" name="use_custom_dash" type="QString"/>
      <Option value="3x:0,0,0,0,0,0" name="width_map_unit_scale" type="QString"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" name="name" type="QString"/>
       <Option name="properties"/>
       <Option value="collection" name="type" type="QString"/>
      </Option>
     </data_defined_properties>
    </layer>
   </symbol>
  </symbols>
 </renderer-v2>
 <labeling type="rule-based">
  <rules key="{ee32b893-e549-45d7-a2ed-119687342afc}">
   <rule key="{e902c555-dc3c-47d4-a5a3-e137b1239972}" filter="&quot;inp_type&quot; IS NOT NULL">
    <settings calloutType="simple">
     <text-style textColor="0,0,0,255" fontLetterSpacing="0" fieldName="arccat_id" textOrientation="horizontal" allowHtml="0" fontFamily="MS Shell Dlg 2" blendMode="0" fontSizeMapUnitScale="3x:0,0,0,0,0,0" legendString="Aa" fontWeight="50" namedStyle="Normal" fontStrikeout="0" textOpacity="1" fontUnderline="0" fontSizeUnit="Point" useSubstitutions="0" fontKerning="1" forcedBold="0" forcedItalic="0" fontSize="8.25" fontItalic="0" fontWordSpacing="0" multilineHeight="1" capitalization="0" multilineHeightUnit="Percentage" previewBkgrdColor="255,255,255,255" isExpression="0">
      <families/>
      <text-buffer bufferSizeUnits="MM" bufferJoinStyle="128" bufferBlendMode="0" bufferNoFill="0" bufferColor="255,255,255,255" bufferSizeMapUnitScale="3x:0,0,0,0,0,0" bufferSize="1" bufferDraw="0" bufferOpacity="1"/>
      <text-mask maskedSymbolLayers="" maskSizeMapUnitScale="3x:0,0,0,0,0,0" maskOpacity="1" maskJoinStyle="128" maskEnabled="0" maskSizeUnits="MM" maskType="0" maskSize="0"/>
      <background shapeRotationType="0" shapeFillColor="255,255,255,255" shapeBorderWidthUnit="MM" shapeSizeX="0" shapeSizeUnit="MM" shapeBorderColor="128,128,128,255" shapeOpacity="1" shapeBorderWidthMapUnitScale="3x:0,0,0,0,0,0" shapeSizeY="0" shapeBorderWidth="0" shapeRadiiMapUnitScale="3x:0,0,0,0,0,0" shapeSVGFile="" shapeDraw="0" shapeRadiiX="0" shapeSizeType="0" shapeOffsetX="0" shapeJoinStyle="64" shapeOffsetUnit="MM" shapeType="0" shapeRadiiY="0" shapeRotation="0" shapeOffsetY="0" shapeOffsetMapUnitScale="3x:0,0,0,0,0,0" shapeRadiiUnit="MM" shapeBlendMode="0" shapeSizeMapUnitScale="3x:0,0,0,0,0,0">
       <symbol clip_to_extent="1" is_animated="0" frame_rate="10" name="markerSymbol" type="marker" force_rhr="0" alpha="1">
        <data_defined_properties>
         <Option type="Map">
          <Option value="" name="name" type="QString"/>
          <Option name="properties"/>
          <Option value="collection" name="type" type="QString"/>
         </Option>
        </data_defined_properties>
        <layer pass="0" locked="0" enabled="1" class="SimpleMarker">
         <Option type="Map">
          <Option value="0" name="angle" type="QString"/>
          <Option value="square" name="cap_style" type="QString"/>
          <Option value="231,113,72,255" name="color" type="QString"/>
          <Option value="1" name="horizontal_anchor_point" type="QString"/>
          <Option value="bevel" name="joinstyle" type="QString"/>
          <Option value="circle" name="name" type="QString"/>
          <Option value="0,0" name="offset" type="QString"/>
          <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
          <Option value="MM" name="offset_unit" type="QString"/>
          <Option value="35,35,35,255" name="outline_color" type="QString"/>
          <Option value="solid" name="outline_style" type="QString"/>
          <Option value="0" name="outline_width" type="QString"/>
          <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
          <Option value="MM" name="outline_width_unit" type="QString"/>
          <Option value="diameter" name="scale_method" type="QString"/>
          <Option value="2" name="size" type="QString"/>
          <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
          <Option value="MM" name="size_unit" type="QString"/>
          <Option value="1" name="vertical_anchor_point" type="QString"/>
         </Option>
         <data_defined_properties>
          <Option type="Map">
           <Option value="" name="name" type="QString"/>
           <Option name="properties"/>
           <Option value="collection" name="type" type="QString"/>
          </Option>
         </data_defined_properties>
        </layer>
       </symbol>
       <symbol clip_to_extent="1" is_animated="0" frame_rate="10" name="fillSymbol" type="fill" force_rhr="0" alpha="1">
        <data_defined_properties>
         <Option type="Map">
          <Option value="" name="name" type="QString"/>
          <Option name="properties"/>
          <Option value="collection" name="type" type="QString"/>
         </Option>
        </data_defined_properties>
        <layer pass="0" locked="0" enabled="1" class="SimpleFill">
         <Option type="Map">
          <Option value="3x:0,0,0,0,0,0" name="border_width_map_unit_scale" type="QString"/>
          <Option value="255,255,255,255" name="color" type="QString"/>
          <Option value="bevel" name="joinstyle" type="QString"/>
          <Option value="0,0" name="offset" type="QString"/>
          <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
          <Option value="MM" name="offset_unit" type="QString"/>
          <Option value="128,128,128,255" name="outline_color" type="QString"/>
          <Option value="no" name="outline_style" type="QString"/>
          <Option value="0" name="outline_width" type="QString"/>
          <Option value="MM" name="outline_width_unit" type="QString"/>
          <Option value="solid" name="style" type="QString"/>
         </Option>
         <data_defined_properties>
          <Option type="Map">
           <Option value="" name="name" type="QString"/>
           <Option name="properties"/>
           <Option value="collection" name="type" type="QString"/>
          </Option>
         </data_defined_properties>
        </layer>
       </symbol>
      </background>
      <shadow shadowRadiusAlphaOnly="0" shadowColor="0,0,0,255" shadowBlendMode="6" shadowOffsetAngle="135" shadowOffsetUnit="MM" shadowDraw="0" shadowOffsetMapUnitScale="3x:0,0,0,0,0,0" shadowScale="100" shadowRadiusUnit="MM" shadowOffsetGlobal="1" shadowOpacity="0.69999999999999996" shadowRadiusMapUnitScale="3x:0,0,0,0,0,0" shadowUnder="0" shadowRadius="1.5" shadowOffsetDist="1"/>
      <dd_properties>
       <Option type="Map">
        <Option value="" name="name" type="QString"/>
        <Option name="properties"/>
        <Option value="collection" name="type" type="QString"/>
       </Option>
      </dd_properties>
      <substitutions/>
     </text-style>
     <text-format addDirectionSymbol="0" useMaxLineLengthForAutoWrap="1" placeDirectionSymbol="0" rightDirectionSymbol=">" wrapChar="" decimals="3" formatNumbers="0" plussign="0" leftDirectionSymbol="&lt;" autoWrapLength="0" multilineAlign="0" reverseDirectionSymbol="0"/>
     <placement overrunDistanceMapUnitScale="3x:0,0,0,0,0,0" centroidInside="0" lineAnchorPercent="0.5" fitInPolygonOnly="0" xOffset="0" maxCurvedCharAngleIn="25" placement="2" priority="5" maxCurvedCharAngleOut="-25" dist="0" lineAnchorTextPoint="CenterOfText" allowDegraded="0" layerType="LineGeometry" geometryGenerator="" distUnits="MM" distMapUnitScale="3x:0,0,0,0,0,0" overrunDistance="0" yOffset="0" rotationAngle="0" repeatDistance="0" repeatDistanceUnits="MM" rotationUnit="AngleDegrees" lineAnchorType="0" lineAnchorClipping="0" offsetType="0" centroidWhole="0" quadOffset="4" repeatDistanceMapUnitScale="3x:0,0,0,0,0,0" preserveRotation="1" geometryGeneratorType="PointGeometry" polygonPlacementFlags="2" placementFlags="10" labelOffsetMapUnitScale="3x:0,0,0,0,0,0" geometryGeneratorEnabled="0" offsetUnits="MapUnit" predefinedPositionOrder="TR,TL,BR,BL,R,L,TSR,BSR" overlapHandling="PreventOverlap" overrunDistanceUnit="MM"/>
     <rendering minFeatureSize="0" scaleMax="1000" fontMaxPixelSize="10000" labelPerPart="0" scaleVisibility="1" drawLabels="1" upsidedownLabels="0" unplacedVisibility="0" obstacleFactor="1" mergeLines="0" limitNumLabels="0" scaleMin="1" maxNumLabels="2000" obstacle="1" obstacleType="0" fontLimitPixelSize="0" fontMinPixelSize="3" zIndex="0"/>
     <dd_properties>
      <Option type="Map">
       <Option value="" name="name" type="QString"/>
       <Option name="properties"/>
       <Option value="collection" name="type" type="QString"/>
      </Option>
     </dd_properties>
     <callout type="simple">
      <Option type="Map">
       <Option value="pole_of_inaccessibility" name="anchorPoint" type="QString"/>
       <Option value="0" name="blendMode" type="int"/>
       <Option name="ddProperties" type="Map">
        <Option value="" name="name" type="QString"/>
        <Option name="properties"/>
        <Option value="collection" name="type" type="QString"/>
       </Option>
       <Option value="false" name="drawToAllParts" type="bool"/>
       <Option value="0" name="enabled" type="QString"/>
       <Option value="point_on_exterior" name="labelAnchorPoint" type="QString"/>
       <Option value="&lt;symbol clip_to_extent=&quot;1&quot; is_animated=&quot;0&quot; frame_rate=&quot;10&quot; name=&quot;symbol&quot; type=&quot;line&quot; force_rhr=&quot;0&quot; alpha=&quot;1&quot;>&lt;data_defined_properties>&lt;Option type=&quot;Map&quot;>&lt;Option value=&quot;&quot; name=&quot;name&quot; type=&quot;QString&quot;/>&lt;Option name=&quot;properties&quot;/>&lt;Option value=&quot;collection&quot; name=&quot;type&quot; type=&quot;QString&quot;/>&lt;/Option>&lt;/data_defined_properties>&lt;layer pass=&quot;0&quot; locked=&quot;0&quot; enabled=&quot;1&quot; class=&quot;SimpleLine&quot;>&lt;Option type=&quot;Map&quot;>&lt;Option value=&quot;0&quot; name=&quot;align_dash_pattern&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;square&quot; name=&quot;capstyle&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;5;2&quot; name=&quot;customdash&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;3x:0,0,0,0,0,0&quot; name=&quot;customdash_map_unit_scale&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;MM&quot; name=&quot;customdash_unit&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;0&quot; name=&quot;dash_pattern_offset&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;3x:0,0,0,0,0,0&quot; name=&quot;dash_pattern_offset_map_unit_scale&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;MM&quot; name=&quot;dash_pattern_offset_unit&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;0&quot; name=&quot;draw_inside_polygon&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;bevel&quot; name=&quot;joinstyle&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;60,60,60,255&quot; name=&quot;line_color&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;solid&quot; name=&quot;line_style&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;0.3&quot; name=&quot;line_width&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;MM&quot; name=&quot;line_width_unit&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;0&quot; name=&quot;offset&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;3x:0,0,0,0,0,0&quot; name=&quot;offset_map_unit_scale&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;MM&quot; name=&quot;offset_unit&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;0&quot; name=&quot;ring_filter&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;0&quot; name=&quot;trim_distance_end&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;3x:0,0,0,0,0,0&quot; name=&quot;trim_distance_end_map_unit_scale&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;MM&quot; name=&quot;trim_distance_end_unit&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;0&quot; name=&quot;trim_distance_start&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;3x:0,0,0,0,0,0&quot; name=&quot;trim_distance_start_map_unit_scale&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;MM&quot; name=&quot;trim_distance_start_unit&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;0&quot; name=&quot;tweak_dash_pattern_on_corners&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;0&quot; name=&quot;use_custom_dash&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;3x:0,0,0,0,0,0&quot; name=&quot;width_map_unit_scale&quot; type=&quot;QString&quot;/>&lt;/Option>&lt;data_defined_properties>&lt;Option type=&quot;Map&quot;>&lt;Option value=&quot;&quot; name=&quot;name&quot; type=&quot;QString&quot;/>&lt;Option name=&quot;properties&quot;/>&lt;Option value=&quot;collection&quot; name=&quot;type&quot; type=&quot;QString&quot;/>&lt;/Option>&lt;/data_defined_properties>&lt;/layer>&lt;/symbol>" name="lineSymbol" type="QString"/>
       <Option value="0" name="minLength" type="double"/>
       <Option value="3x:0,0,0,0,0,0" name="minLengthMapUnitScale" type="QString"/>
       <Option value="MM" name="minLengthUnit" type="QString"/>
       <Option value="0" name="offsetFromAnchor" type="double"/>
       <Option value="3x:0,0,0,0,0,0" name="offsetFromAnchorMapUnitScale" type="QString"/>
       <Option value="MM" name="offsetFromAnchorUnit" type="QString"/>
       <Option value="0" name="offsetFromLabel" type="double"/>
       <Option value="3x:0,0,0,0,0,0" name="offsetFromLabelMapUnitScale" type="QString"/>
       <Option value="MM" name="offsetFromLabelUnit" type="QString"/>
      </Option>
     </callout>
    </settings>
   </rule>
  </rules>
 </labeling>
 <customproperties>
  <Option type="Map">
   <Option value="0" name="embeddedWidgets/count" type="QString"/>
   <Option name="variableNames" type="invalid"/>
   <Option name="variableValues" type="invalid"/>
  </Option>
 </customproperties>
 <blendMode>0</blendMode>
 <featureBlendMode>0</featureBlendMode>
 <layerOpacity>1</layerOpacity>
 <SingleCategoryDiagramRenderer diagramType="Histogram" attributeLegend="1">
  <DiagramCategory barWidth="5" showAxis="1" sizeType="MM" lineSizeType="MM" lineSizeScale="3x:0,0,0,0,0,0" scaleDependency="Area" width="15" backgroundAlpha="255" penColor="#000000" height="15" diagramOrientation="Up" penWidth="0" labelPlacementMethod="XHeight" scaleBasedVisibility="0" spacingUnit="MM" spacingUnitScale="3x:0,0,0,0,0,0" minimumSize="0" rotationOffset="270" penAlpha="255" minScaleDenominator="0" spacing="5" backgroundColor="#ffffff" opacity="1" sizeScale="3x:0,0,0,0,0,0" maxScaleDenominator="0" enabled="0" direction="0">
   <fontProperties strikethrough="0" italic="0" underline="0" bold="0" description="MS Shell Dlg 2,7.8,-1,5,50,0,0,0,0,0" style=""/>
   <attribute field="" label="" colorOpacity="1" color="#000000"/>
   <axisSymbol>
    <symbol clip_to_extent="1" is_animated="0" frame_rate="10" name="" type="line" force_rhr="0" alpha="1">
     <data_defined_properties>
      <Option type="Map">
       <Option value="" name="name" type="QString"/>
       <Option name="properties"/>
       <Option value="collection" name="type" type="QString"/>
      </Option>
     </data_defined_properties>
     <layer pass="0" locked="0" enabled="1" class="SimpleLine">
      <Option type="Map">
       <Option value="0" name="align_dash_pattern" type="QString"/>
       <Option value="square" name="capstyle" type="QString"/>
       <Option value="5;2" name="customdash" type="QString"/>
       <Option value="3x:0,0,0,0,0,0" name="customdash_map_unit_scale" type="QString"/>
       <Option value="MM" name="customdash_unit" type="QString"/>
       <Option value="0" name="dash_pattern_offset" type="QString"/>
       <Option value="3x:0,0,0,0,0,0" name="dash_pattern_offset_map_unit_scale" type="QString"/>
       <Option value="MM" name="dash_pattern_offset_unit" type="QString"/>
       <Option value="0" name="draw_inside_polygon" type="QString"/>
       <Option value="bevel" name="joinstyle" type="QString"/>
       <Option value="35,35,35,255" name="line_color" type="QString"/>
       <Option value="solid" name="line_style" type="QString"/>
       <Option value="0.26" name="line_width" type="QString"/>
       <Option value="MM" name="line_width_unit" type="QString"/>
       <Option value="0" name="offset" type="QString"/>
       <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
       <Option value="MM" name="offset_unit" type="QString"/>
       <Option value="0" name="ring_filter" type="QString"/>
       <Option value="0" name="trim_distance_end" type="QString"/>
       <Option value="3x:0,0,0,0,0,0" name="trim_distance_end_map_unit_scale" type="QString"/>
       <Option value="MM" name="trim_distance_end_unit" type="QString"/>
       <Option value="0" name="trim_distance_start" type="QString"/>
       <Option value="3x:0,0,0,0,0,0" name="trim_distance_start_map_unit_scale" type="QString"/>
       <Option value="MM" name="trim_distance_start_unit" type="QString"/>
       <Option value="0" name="tweak_dash_pattern_on_corners" type="QString"/>
       <Option value="0" name="use_custom_dash" type="QString"/>
       <Option value="3x:0,0,0,0,0,0" name="width_map_unit_scale" type="QString"/>
      </Option>
      <data_defined_properties>
       <Option type="Map">
        <Option value="" name="name" type="QString"/>
        <Option name="properties"/>
        <Option value="collection" name="type" type="QString"/>
       </Option>
      </data_defined_properties>
     </layer>
    </symbol>
   </axisSymbol>
  </DiagramCategory>
 </SingleCategoryDiagramRenderer>
 <DiagramLayerSettings linePlacementFlags="18" obstacle="0" placement="2" dist="0" priority="0" showAll="1" zIndex="0">
  <properties>
   <Option type="Map">
    <Option value="" name="name" type="QString"/>
    <Option name="properties"/>
    <Option value="collection" name="type" type="QString"/>
   </Option>
  </properties>
 </DiagramLayerSettings>
 <geometryOptions removeDuplicateNodes="0" geometryPrecision="0">
  <activeChecks/>
  <checkConfiguration/>
 </geometryOptions>
 <legend type="default-vector" showLabelLegend="0"/>
 <referencedLayers/>
 <fieldConfiguration>
  <field name="arc_id" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="code" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="node_1" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="False" name="IsMultiline" type="QString"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="nodetype_1" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option/>
    </config>
   </editWidget>
  </field>
  <field name="y1" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="custom_y1" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="elev1" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="custom_elev1" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="sys_elev1" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="sys_y1" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="r1" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="z1" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="node_2" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="False" name="IsMultiline" type="QString"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="nodetype_2" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option/>
    </config>
   </editWidget>
  </field>
  <field name="y2" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="custom_y2" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="elev2" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="custom_elev2" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="sys_elev2" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="sys_y2" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="r2" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="z2" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="slope" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="arc_type" configurationFlags="None">
   <editWidget type="ValueRelation">
    <config>
     <Option type="Map">
      <Option value="False" name="AllowNull" type="QString"/>
      <Option value="" name="FilterExpression" type="QString"/>
      <Option value="id" name="Key" type="QString"/>
      <Option value="v_edit_cat_feature_arc_4cd4d71c_df9e_44bf_8911_d4932f930ad2" name="Layer" type="QString"/>
      <Option value="id" name="Value" type="QString"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="sys_type" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option/>
    </config>
   </editWidget>
  </field>
  <field name="arccat_id" configurationFlags="None">
   <editWidget type="ValueRelation">
    <config>
     <Option type="Map">
      <Option value="False" name="AllowNull" type="QString"/>
      <Option value="" name="FilterExpression" type="QString"/>
      <Option value="id" name="Key" type="QString"/>
      <Option value="cat_arc_52f24e12_c228_47c2_b347_69b187f2d984" name="Layer" type="QString"/>
      <Option value="id" name="Value" type="QString"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="matcat_id" configurationFlags="None">
   <editWidget type="ValueRelation">
    <config>
     <Option type="Map">
      <Option value="False" name="AllowNull" type="QString"/>
      <Option value="" name="FilterExpression" type="QString"/>
      <Option value="id" name="Key" type="QString"/>
      <Option value="cat_mat_arc_bba8ab41_f652_4864_95d3_45c7e39b5175" name="Layer" type="QString"/>
      <Option value="descript" name="Value" type="QString"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="cat_shape" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="cat_geom1" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="cat_geom2" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="cat_width" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option/>
    </config>
   </editWidget>
  </field>
  <field name="cat_area" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option/>
    </config>
   </editWidget>
  </field>
  <field name="epa_type" configurationFlags="None">
   <editWidget type="ValueMap">
    <config>
     <Option type="Map">
      <Option name="map" type="Map">
       <Option value="CONDUIT" name="CONDUIT" type="QString"/>
       <Option value="ORIFICE" name="ORIFICE" type="QString"/>
       <Option value="OUTLET" name="OUTLET" type="QString"/>
       <Option value="PUMP" name="PUMP" type="QString"/>
       <Option value="UNDEFINED" name="UNDEFINED" type="QString"/>
       <Option value="VIRTUAL" name="VIRTUAL" type="QString"/>
       <Option value="WEIR" name="WEIR" type="QString"/>
      </Option>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="state" configurationFlags="None">
   <editWidget type="ValueMap">
    <config>
     <Option type="Map">
      <Option name="map" type="Map">
       <Option value="0" name="OBSOLETE" type="QString"/>
       <Option value="1" name="OPERATIVE" type="QString"/>
       <Option value="2" name="PLANIFIED" type="QString"/>
      </Option>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="state_type" configurationFlags="None">
   <editWidget type="ValueMap">
    <config>
     <Option type="Map">
      <Option name="map" type="Map">
       <Option value="99" name="FICTICIUS" type="QString"/>
       <Option value="1" name="OBSOLETE" type="QString"/>
       <Option value="2" name="OPERATIVE" type="QString"/>
       <Option value="3" name="PLANIFIED" type="QString"/>
       <Option value="5" name="PROVISIONAL" type="QString"/>
       <Option value="4" name="RECONSTRUCT" type="QString"/>
      </Option>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="expl_id" configurationFlags="None">
   <editWidget type="ValueRelation">
    <config>
     <Option type="Map">
      <Option value="False" name="AllowNull" type="QString"/>
      <Option value="" name="FilterExpression" type="QString"/>
      <Option value="expl_id" name="Key" type="QString"/>
      <Option value="v_edit_exploitation_79f9ccda_070f_4e89_b991_6f956aec4b36" name="Layer" type="QString"/>
      <Option value="name" name="Value" type="QString"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="macroexpl_id" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="sector_id" configurationFlags="None">
   <editWidget type="ValueRelation">
    <config>
     <Option type="Map">
      <Option value="False" name="AllowNull" type="QString"/>
      <Option value="" name="FilterExpression" type="QString"/>
      <Option value="sector_id" name="Key" type="QString"/>
      <Option value="v_edit_sector_d4924986_50a2_4c42_bad8_bfff1644805d" name="Layer" type="QString"/>
      <Option value="name" name="Value" type="QString"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="sector_type" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option/>
    </config>
   </editWidget>
  </field>
  <field name="macrosector_id" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="drainzone_id" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="drainzone_type" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option/>
    </config>
   </editWidget>
  </field>
  <field name="annotation" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="gis_length" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="custom_length" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="inverted_slope" configurationFlags="None">
   <editWidget type="CheckBox">
    <config>
     <Option type="Map">
      <Option value="true" name="CheckedState" type="QString"/>
      <Option value="false" name="UncheckedState" type="QString"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="observ" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="comment" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="dma_id" configurationFlags="None">
   <editWidget type="ValueMap">
    <config>
     <Option type="Map">
      <Option name="map" type="Map">
       <Option value="0" name="Undefined" type="QString"/>
       <Option value="1" name="dma_01" type="QString"/>
       <Option value="3" name="dma_02" type="QString"/>
      </Option>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="macrodma_id" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="dma_type" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option/>
    </config>
   </editWidget>
  </field>
  <field name="soilcat_id" configurationFlags="None">
   <editWidget type="ValueMap">
    <config>
     <Option type="Map">
      <Option name="map" type="Map">
       <Option value="" name="" type="QString"/>
       <Option value="soil1" name="soil1" type="QString"/>
       <Option value="soil2" name="soil2" type="QString"/>
       <Option value="soil3" name="soil3" type="QString"/>
      </Option>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="function_type" configurationFlags="None">
   <editWidget type="ValueMap">
    <config>
     <Option type="Map">
      <Option name="map" type="Map">
       <Option value="" name="" type="QString"/>
       <Option value="St. Function" name="St. Function" type="QString"/>
      </Option>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="category_type" configurationFlags="None">
   <editWidget type="ValueMap">
    <config>
     <Option type="Map">
      <Option name="map" type="Map">
       <Option value="" name="" type="QString"/>
       <Option value="St. Category" name="St. Category" type="QString"/>
      </Option>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="fluid_type" configurationFlags="None">
   <editWidget type="ValueMap">
    <config>
     <Option type="Map">
      <Option name="map" type="Map">
       <Option value="" name="" type="QString"/>
       <Option value="St. Fluid" name="St. Fluid" type="QString"/>
      </Option>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="location_type" configurationFlags="None">
   <editWidget type="ValueMap">
    <config>
     <Option type="Map">
      <Option name="map" type="Map">
       <Option value="" name="" type="QString"/>
       <Option value="St. Location" name="St. Location" type="QString"/>
      </Option>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="workcat_id" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="False" name="IsMultiline" type="QString"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="workcat_id_end" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="False" name="IsMultiline" type="QString"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="workcat_id_plan" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="False" name="IsMultiline" type="QString"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="builtdate" configurationFlags="None">
   <editWidget type="DateTime">
    <config>
     <Option type="Map">
      <Option value="true" name="allow_null" type="bool"/>
      <Option value="true" name="calendar_popup" type="bool"/>
      <Option value="yyyy-MM-dd" name="display_format" type="QString"/>
      <Option value="yyyy-MM-dd" name="field_format" type="QString"/>
      <Option value="false" name="field_iso_format" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="enddate" configurationFlags="None">
   <editWidget type="DateTime">
    <config>
     <Option type="Map">
      <Option value="true" name="allow_null" type="bool"/>
      <Option value="true" name="calendar_popup" type="bool"/>
      <Option value="yyyy-MM-dd" name="display_format" type="QString"/>
      <Option value="yyyy-MM-dd" name="field_format" type="QString"/>
      <Option value="false" name="field_iso_format" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="buildercat_id" configurationFlags="None">
   <editWidget type="ValueMap">
    <config>
     <Option type="Map">
      <Option name="map" type="Map">
       <Option value="" name="" type="QString"/>
       <Option value="builder1" name="builder1" type="QString"/>
       <Option value="builder2" name="builder2" type="QString"/>
       <Option value="builder3" name="builder3" type="QString"/>
      </Option>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="ownercat_id" configurationFlags="None">
   <editWidget type="ValueMap">
    <config>
     <Option type="Map">
      <Option name="map" type="Map">
       <Option value="" name="" type="QString"/>
       <Option value="owner1" name="owner1" type="QString"/>
       <Option value="owner2" name="owner2" type="QString"/>
       <Option value="owner3" name="owner3" type="QString"/>
      </Option>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="muni_id" configurationFlags="None">
   <editWidget type="ValueMap">
    <config>
     <Option type="Map">
      <Option name="map" type="Map">
       <Option value="1" name="Sant Boi del Llobregat" type="QString"/>
       <Option value="2" name="Sant Esteve de les Roures" type="QString"/>
       <Option value="0" name="Undefined" type="QString"/>
      </Option>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="postcode" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="district_id" configurationFlags="None">
   <editWidget type="ValueMap">
    <config>
     <Option type="Map">
      <Option name="map" type="Map">
       <Option value="1" name="Camps Blancs" type="QString"/>
       <Option value="2" name="Marianao" type="QString"/>
      </Option>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="streetname" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="False" name="IsMultiline" type="QString"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="postnumber" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="False" name="IsMultiline" type="QString"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="postcomplement" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="streetname2" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="False" name="IsMultiline" type="QString"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="postnumber2" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="False" name="IsMultiline" type="QString"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="postcomplement2" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="region_id" configurationFlags="None">
   <editWidget type="ValueMap">
    <config>
     <Option type="Map">
      <Option name="map" type="Map">
       <Option value="" name="" type="QString"/>
       <Option value="1" name="Baix Llobregat" type="QString"/>
      </Option>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="province_id" configurationFlags="None">
   <editWidget type="ValueMap">
    <config>
     <Option type="Map">
      <Option name="map" type="Map">
       <Option value="" name="" type="QString"/>
       <Option value="1" name="Barcelona" type="QString"/>
      </Option>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="descript" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="link" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="False" name="IsMultiline" type="QString"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="verified" configurationFlags="None">
   <editWidget type="ValueMap">
    <config>
     <Option type="Map">
      <Option name="map" type="Map">
       <Option value="" name="" type="QString"/>
       <Option value="2" name="IGNORE CHECK" type="QString"/>
       <Option value="0" name="TO REVIEW" type="QString"/>
       <Option value="1" name="VERIFIED" type="QString"/>
      </Option>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="undelete" configurationFlags="None">
   <editWidget type="CheckBox">
    <config>
     <Option type="Map">
      <Option value="true" name="CheckedState" type="QString"/>
      <Option value="false" name="UncheckedState" type="QString"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="label" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="label_x" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="label_y" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="label_rotation" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="label_quadrant" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="publish" configurationFlags="None">
   <editWidget type="CheckBox">
    <config>
     <Option type="Map">
      <Option value="true" name="CheckedState" type="QString"/>
      <Option value="false" name="UncheckedState" type="QString"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="inventory" configurationFlags="None">
   <editWidget type="CheckBox">
    <config>
     <Option type="Map">
      <Option value="true" name="CheckedState" type="QString"/>
      <Option value="false" name="UncheckedState" type="QString"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="uncertain" configurationFlags="None">
   <editWidget type="CheckBox">
    <config>
     <Option type="Map">
      <Option value="true" name="CheckedState" type="QString"/>
      <Option value="false" name="UncheckedState" type="QString"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="num_value" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="asset_id" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="pavcat_id" configurationFlags="None">
   <editWidget type="ValueMap">
    <config>
     <Option type="Map">
      <Option name="map" type="Map">
       <Option value="" name="" type="QString"/>
       <Option value="Asphalt" name="Asphalt" type="QString"/>
       <Option value="pavement1" name="pavement1" type="QString"/>
       <Option value="pavement2" name="pavement2" type="QString"/>
      </Option>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="parent_id" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="False" name="IsMultiline" type="QString"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="expl_id2" configurationFlags="None">
   <editWidget type="ValueMap">
    <config>
     <Option type="Map">
      <Option name="map" type="Map">
       <Option value="" name="" type="QString"/>
       <Option value="1" name="expl_01" type="QString"/>
       <Option value="2" name="expl_02" type="QString"/>
      </Option>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="is_operative" configurationFlags="None">
   <editWidget type="CheckBox">
    <config>
     <Option/>
    </config>
   </editWidget>
  </field>
  <field name="minsector_id" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="macrominsector_id" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="adate" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="adescript" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="visitability" configurationFlags="None">
   <editWidget type="ValueMap">
    <config>
     <Option type="Map">
      <Option name="map" type="Map">
       <Option value="1" name="NO VISITABLE" type="QString"/>
       <Option value="2" name="SEMI VISITABLE" type="QString"/>
       <Option value="3" name="VISITABLE" type="QString"/>
      </Option>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="tstamp" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="insert_user" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option/>
    </config>
   </editWidget>
  </field>
  <field name="lastupdate" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="lastupdate_user" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="inp_type" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option/>
    </config>
   </editWidget>
  </field>
 </fieldConfiguration>
 <aliases>
  <alias field="arc_id" index="0" name="arc_id"/>
  <alias field="code" index="1" name="code"/>
  <alias field="node_1" index="2" name="node_1"/>
  <alias field="nodetype_1" index="3" name=""/>
  <alias field="y1" index="4" name="y1"/>
  <alias field="custom_y1" index="5" name="custom_y1"/>
  <alias field="elev1" index="6" name="elev1"/>
  <alias field="custom_elev1" index="7" name="custom_elev1"/>
  <alias field="sys_elev1" index="8" name="sys_elev1"/>
  <alias field="sys_y1" index="9" name="sys_y1"/>
  <alias field="r1" index="10" name="r1"/>
  <alias field="z1" index="11" name="z1"/>
  <alias field="node_2" index="12" name="node_2"/>
  <alias field="nodetype_2" index="13" name=""/>
  <alias field="y2" index="14" name="y2"/>
  <alias field="custom_y2" index="15" name="custom_y2"/>
  <alias field="elev2" index="16" name="elev2"/>
  <alias field="custom_elev2" index="17" name="custom_elev2"/>
  <alias field="sys_elev2" index="18" name="sys_elev2"/>
  <alias field="sys_y2" index="19" name="sys_y2"/>
  <alias field="r2" index="20" name="r2"/>
  <alias field="z2" index="21" name="z2"/>
  <alias field="slope" index="22" name="slope"/>
  <alias field="arc_type" index="23" name="arc_type"/>
  <alias field="sys_type" index="24" name=""/>
  <alias field="arccat_id" index="25" name="arccat_id"/>
  <alias field="matcat_id" index="26" name="matcat_id"/>
  <alias field="cat_shape" index="27" name="cat_shape"/>
  <alias field="cat_geom1" index="28" name="cat_geom1"/>
  <alias field="cat_geom2" index="29" name="cat_geom2"/>
  <alias field="cat_width" index="30" name=""/>
  <alias field="cat_area" index="31" name=""/>
  <alias field="epa_type" index="32" name="epa_type"/>
  <alias field="state" index="33" name="state"/>
  <alias field="state_type" index="34" name="state_type"/>
  <alias field="expl_id" index="35" name="expl_id"/>
  <alias field="macroexpl_id" index="36" name="Macroexploitation"/>
  <alias field="sector_id" index="37" name="sector_id"/>
  <alias field="sector_type" index="38" name=""/>
  <alias field="macrosector_id" index="39" name="macrosector_id"/>
  <alias field="drainzone_id" index="40" name="drainzone_id"/>
  <alias field="drainzone_type" index="41" name=""/>
  <alias field="annotation" index="42" name="annotation"/>
  <alias field="gis_length" index="43" name="gis_length"/>
  <alias field="custom_length" index="44" name="custom_length"/>
  <alias field="inverted_slope" index="45" name="inverted_slope"/>
  <alias field="observ" index="46" name="observ"/>
  <alias field="comment" index="47" name="comment"/>
  <alias field="dma_id" index="48" name="dma_id"/>
  <alias field="macrodma_id" index="49" name="macrodma_id"/>
  <alias field="dma_type" index="50" name=""/>
  <alias field="soilcat_id" index="51" name="soilcat_id"/>
  <alias field="function_type" index="52" name="function_type"/>
  <alias field="category_type" index="53" name="category_type"/>
  <alias field="fluid_type" index="54" name="fluid_type"/>
  <alias field="location_type" index="55" name="location_type"/>
  <alias field="workcat_id" index="56" name="workcat_id"/>
  <alias field="workcat_id_end" index="57" name="workcat_id_end"/>
  <alias field="workcat_id_plan" index="58" name="workcat_id_plan"/>
  <alias field="builtdate" index="59" name="builtdate"/>
  <alias field="enddate" index="60" name="enddate"/>
  <alias field="buildercat_id" index="61" name="buildercat_id"/>
  <alias field="ownercat_id" index="62" name="ownercat_id"/>
  <alias field="muni_id" index="63" name="muni_id"/>
  <alias field="postcode" index="64" name="postcode"/>
  <alias field="district_id" index="65" name="district"/>
  <alias field="streetname" index="66" name="streetname"/>
  <alias field="postnumber" index="67" name="postnumber"/>
  <alias field="postcomplement" index="68" name="postcomplement"/>
  <alias field="streetname2" index="69" name="streetname2"/>
  <alias field="postnumber2" index="70" name="postnumber2"/>
  <alias field="postcomplement2" index="71" name="postcomplement2"/>
  <alias field="region_id" index="72" name="Region"/>
  <alias field="province_id" index="73" name="Province"/>
  <alias field="descript" index="74" name="descript"/>
  <alias field="link" index="75" name="link"/>
  <alias field="verified" index="76" name="verified"/>
  <alias field="undelete" index="77" name="undelete"/>
  <alias field="label" index="78" name="Catalog label"/>
  <alias field="label_x" index="79" name="label_x"/>
  <alias field="label_y" index="80" name="label_y"/>
  <alias field="label_rotation" index="81" name="label_rotation"/>
  <alias field="label_quadrant" index="82" name="label_quadrant"/>
  <alias field="publish" index="83" name="publish"/>
  <alias field="inventory" index="84" name="inventory"/>
  <alias field="uncertain" index="85" name="uncertain"/>
  <alias field="num_value" index="86" name="num_value"/>
  <alias field="asset_id" index="87" name="asset_id"/>
  <alias field="pavcat_id" index="88" name="pavcat_id"/>
  <alias field="parent_id" index="89" name="parent_id"/>
  <alias field="expl_id2" index="90" name="Exploitation 2"/>
  <alias field="is_operative" index="91" name=""/>
  <alias field="minsector_id" index="92" name="minsector_id"/>
  <alias field="macrominsector_id" index="93" name="macrominsector_id"/>
  <alias field="adate" index="94" name="adate"/>
  <alias field="adescript" index="95" name="adescript"/>
  <alias field="visitability" index="96" name="Visitability"/>
  <alias field="tstamp" index="97" name="Insert tstamp"/>
  <alias field="insert_user" index="98" name=""/>
  <alias field="lastupdate" index="99" name="Last update"/>
  <alias field="lastupdate_user" index="100" name="Last update user"/>
  <alias field="inp_type" index="101" name=""/>
 </aliases>
 <defaults>
  <default field="arc_id" expression="" applyOnUpdate="0"/>
  <default field="code" expression="" applyOnUpdate="0"/>
  <default field="node_1" expression="" applyOnUpdate="0"/>
  <default field="nodetype_1" expression="" applyOnUpdate="0"/>
  <default field="y1" expression="" applyOnUpdate="0"/>
  <default field="custom_y1" expression="" applyOnUpdate="0"/>
  <default field="elev1" expression="" applyOnUpdate="0"/>
  <default field="custom_elev1" expression="" applyOnUpdate="0"/>
  <default field="sys_elev1" expression="" applyOnUpdate="0"/>
  <default field="sys_y1" expression="" applyOnUpdate="0"/>
  <default field="r1" expression="" applyOnUpdate="0"/>
  <default field="z1" expression="" applyOnUpdate="0"/>
  <default field="node_2" expression="" applyOnUpdate="0"/>
  <default field="nodetype_2" expression="" applyOnUpdate="0"/>
  <default field="y2" expression="" applyOnUpdate="0"/>
  <default field="custom_y2" expression="" applyOnUpdate="0"/>
  <default field="elev2" expression="" applyOnUpdate="0"/>
  <default field="custom_elev2" expression="" applyOnUpdate="0"/>
  <default field="sys_elev2" expression="" applyOnUpdate="0"/>
  <default field="sys_y2" expression="" applyOnUpdate="0"/>
  <default field="r2" expression="" applyOnUpdate="0"/>
  <default field="z2" expression="" applyOnUpdate="0"/>
  <default field="slope" expression="" applyOnUpdate="0"/>
  <default field="arc_type" expression="" applyOnUpdate="0"/>
  <default field="sys_type" expression="" applyOnUpdate="0"/>
  <default field="arccat_id" expression="" applyOnUpdate="0"/>
  <default field="matcat_id" expression="" applyOnUpdate="0"/>
  <default field="cat_shape" expression="" applyOnUpdate="0"/>
  <default field="cat_geom1" expression="" applyOnUpdate="0"/>
  <default field="cat_geom2" expression="" applyOnUpdate="0"/>
  <default field="cat_width" expression="" applyOnUpdate="0"/>
  <default field="cat_area" expression="" applyOnUpdate="0"/>
  <default field="epa_type" expression="" applyOnUpdate="0"/>
  <default field="state" expression="" applyOnUpdate="0"/>
  <default field="state_type" expression="" applyOnUpdate="0"/>
  <default field="expl_id" expression="" applyOnUpdate="0"/>
  <default field="macroexpl_id" expression="" applyOnUpdate="0"/>
  <default field="sector_id" expression="" applyOnUpdate="0"/>
  <default field="sector_type" expression="" applyOnUpdate="0"/>
  <default field="macrosector_id" expression="" applyOnUpdate="0"/>
  <default field="drainzone_id" expression="" applyOnUpdate="0"/>
  <default field="drainzone_type" expression="" applyOnUpdate="0"/>
  <default field="annotation" expression="" applyOnUpdate="0"/>
  <default field="gis_length" expression="" applyOnUpdate="0"/>
  <default field="custom_length" expression="" applyOnUpdate="0"/>
  <default field="inverted_slope" expression="" applyOnUpdate="0"/>
  <default field="observ" expression="" applyOnUpdate="0"/>
  <default field="comment" expression="" applyOnUpdate="0"/>
  <default field="dma_id" expression="" applyOnUpdate="0"/>
  <default field="macrodma_id" expression="" applyOnUpdate="0"/>
  <default field="dma_type" expression="" applyOnUpdate="0"/>
  <default field="soilcat_id" expression="" applyOnUpdate="0"/>
  <default field="function_type" expression="" applyOnUpdate="0"/>
  <default field="category_type" expression="" applyOnUpdate="0"/>
  <default field="fluid_type" expression="" applyOnUpdate="0"/>
  <default field="location_type" expression="" applyOnUpdate="0"/>
  <default field="workcat_id" expression="" applyOnUpdate="0"/>
  <default field="workcat_id_end" expression="" applyOnUpdate="0"/>
  <default field="workcat_id_plan" expression="" applyOnUpdate="0"/>
  <default field="builtdate" expression="" applyOnUpdate="0"/>
  <default field="enddate" expression="" applyOnUpdate="0"/>
  <default field="buildercat_id" expression="" applyOnUpdate="0"/>
  <default field="ownercat_id" expression="" applyOnUpdate="0"/>
  <default field="muni_id" expression="" applyOnUpdate="0"/>
  <default field="postcode" expression="" applyOnUpdate="0"/>
  <default field="district_id" expression="" applyOnUpdate="0"/>
  <default field="streetname" expression="" applyOnUpdate="0"/>
  <default field="postnumber" expression="" applyOnUpdate="0"/>
  <default field="postcomplement" expression="" applyOnUpdate="0"/>
  <default field="streetname2" expression="" applyOnUpdate="0"/>
  <default field="postnumber2" expression="" applyOnUpdate="0"/>
  <default field="postcomplement2" expression="" applyOnUpdate="0"/>
  <default field="region_id" expression="" applyOnUpdate="0"/>
  <default field="province_id" expression="" applyOnUpdate="0"/>
  <default field="descript" expression="" applyOnUpdate="0"/>
  <default field="link" expression="" applyOnUpdate="0"/>
  <default field="verified" expression="" applyOnUpdate="0"/>
  <default field="undelete" expression="" applyOnUpdate="0"/>
  <default field="label" expression="" applyOnUpdate="0"/>
  <default field="label_x" expression="" applyOnUpdate="0"/>
  <default field="label_y" expression="" applyOnUpdate="0"/>
  <default field="label_rotation" expression="" applyOnUpdate="0"/>
  <default field="label_quadrant" expression="" applyOnUpdate="0"/>
  <default field="publish" expression="" applyOnUpdate="0"/>
  <default field="inventory" expression="" applyOnUpdate="0"/>
  <default field="uncertain" expression="" applyOnUpdate="0"/>
  <default field="num_value" expression="" applyOnUpdate="0"/>
  <default field="asset_id" expression="" applyOnUpdate="0"/>
  <default field="pavcat_id" expression="" applyOnUpdate="0"/>
  <default field="parent_id" expression="" applyOnUpdate="0"/>
  <default field="expl_id2" expression="" applyOnUpdate="0"/>
  <default field="is_operative" expression="" applyOnUpdate="0"/>
  <default field="minsector_id" expression="" applyOnUpdate="0"/>
  <default field="macrominsector_id" expression="" applyOnUpdate="0"/>
  <default field="adate" expression="" applyOnUpdate="0"/>
  <default field="adescript" expression="" applyOnUpdate="0"/>
  <default field="visitability" expression="" applyOnUpdate="0"/>
  <default field="tstamp" expression="" applyOnUpdate="0"/>
  <default field="insert_user" expression="" applyOnUpdate="0"/>
  <default field="lastupdate" expression="" applyOnUpdate="0"/>
  <default field="lastupdate_user" expression="" applyOnUpdate="0"/>
  <default field="inp_type" expression="" applyOnUpdate="0"/>
 </defaults>
 <constraints>
  <constraint field="arc_id" unique_strength="1" notnull_strength="1" exp_strength="0" constraints="3"/>
  <constraint field="code" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="node_1" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="nodetype_1" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="y1" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="custom_y1" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="elev1" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="custom_elev1" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="sys_elev1" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="sys_y1" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="r1" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="z1" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="node_2" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="nodetype_2" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="y2" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="custom_y2" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="elev2" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="custom_elev2" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="sys_elev2" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="sys_y2" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="r2" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="z2" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="slope" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="arc_type" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="sys_type" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="arccat_id" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="matcat_id" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="cat_shape" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="cat_geom1" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="cat_geom2" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="cat_width" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="cat_area" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="epa_type" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="state" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="state_type" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="expl_id" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="macroexpl_id" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="sector_id" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="sector_type" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="macrosector_id" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="drainzone_id" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="drainzone_type" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="annotation" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="gis_length" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="custom_length" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="inverted_slope" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="observ" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="comment" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="dma_id" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="macrodma_id" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="dma_type" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="soilcat_id" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="function_type" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="category_type" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="fluid_type" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="location_type" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="workcat_id" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="workcat_id_end" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="workcat_id_plan" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="builtdate" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="enddate" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="buildercat_id" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="ownercat_id" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="muni_id" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="postcode" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="district_id" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="streetname" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="postnumber" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="postcomplement" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="streetname2" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="postnumber2" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="postcomplement2" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="region_id" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="province_id" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="descript" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="link" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="verified" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="undelete" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="label" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="label_x" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="label_y" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="label_rotation" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="label_quadrant" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="publish" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="inventory" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="uncertain" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="num_value" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="asset_id" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="pavcat_id" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="parent_id" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="expl_id2" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="is_operative" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="minsector_id" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="macrominsector_id" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="adate" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="adescript" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="visitability" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="tstamp" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="insert_user" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="lastupdate" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="lastupdate_user" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="inp_type" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
 </constraints>
 <constraintExpressions>
  <constraint field="arc_id" desc="" exp=""/>
  <constraint field="code" desc="" exp=""/>
  <constraint field="node_1" desc="" exp=""/>
  <constraint field="nodetype_1" desc="" exp=""/>
  <constraint field="y1" desc="" exp=""/>
  <constraint field="custom_y1" desc="" exp=""/>
  <constraint field="elev1" desc="" exp=""/>
  <constraint field="custom_elev1" desc="" exp=""/>
  <constraint field="sys_elev1" desc="" exp=""/>
  <constraint field="sys_y1" desc="" exp=""/>
  <constraint field="r1" desc="" exp=""/>
  <constraint field="z1" desc="" exp=""/>
  <constraint field="node_2" desc="" exp=""/>
  <constraint field="nodetype_2" desc="" exp=""/>
  <constraint field="y2" desc="" exp=""/>
  <constraint field="custom_y2" desc="" exp=""/>
  <constraint field="elev2" desc="" exp=""/>
  <constraint field="custom_elev2" desc="" exp=""/>
  <constraint field="sys_elev2" desc="" exp=""/>
  <constraint field="sys_y2" desc="" exp=""/>
  <constraint field="r2" desc="" exp=""/>
  <constraint field="z2" desc="" exp=""/>
  <constraint field="slope" desc="" exp=""/>
  <constraint field="arc_type" desc="" exp=""/>
  <constraint field="sys_type" desc="" exp=""/>
  <constraint field="arccat_id" desc="" exp=""/>
  <constraint field="matcat_id" desc="" exp=""/>
  <constraint field="cat_shape" desc="" exp=""/>
  <constraint field="cat_geom1" desc="" exp=""/>
  <constraint field="cat_geom2" desc="" exp=""/>
  <constraint field="cat_width" desc="" exp=""/>
  <constraint field="cat_area" desc="" exp=""/>
  <constraint field="epa_type" desc="" exp=""/>
  <constraint field="state" desc="" exp=""/>
  <constraint field="state_type" desc="" exp=""/>
  <constraint field="expl_id" desc="" exp=""/>
  <constraint field="macroexpl_id" desc="" exp=""/>
  <constraint field="sector_id" desc="" exp=""/>
  <constraint field="sector_type" desc="" exp=""/>
  <constraint field="macrosector_id" desc="" exp=""/>
  <constraint field="drainzone_id" desc="" exp=""/>
  <constraint field="drainzone_type" desc="" exp=""/>
  <constraint field="annotation" desc="" exp=""/>
  <constraint field="gis_length" desc="" exp=""/>
  <constraint field="custom_length" desc="" exp=""/>
  <constraint field="inverted_slope" desc="" exp=""/>
  <constraint field="observ" desc="" exp=""/>
  <constraint field="comment" desc="" exp=""/>
  <constraint field="dma_id" desc="" exp=""/>
  <constraint field="macrodma_id" desc="" exp=""/>
  <constraint field="dma_type" desc="" exp=""/>
  <constraint field="soilcat_id" desc="" exp=""/>
  <constraint field="function_type" desc="" exp=""/>
  <constraint field="category_type" desc="" exp=""/>
  <constraint field="fluid_type" desc="" exp=""/>
  <constraint field="location_type" desc="" exp=""/>
  <constraint field="workcat_id" desc="" exp=""/>
  <constraint field="workcat_id_end" desc="" exp=""/>
  <constraint field="workcat_id_plan" desc="" exp=""/>
  <constraint field="builtdate" desc="" exp=""/>
  <constraint field="enddate" desc="" exp=""/>
  <constraint field="buildercat_id" desc="" exp=""/>
  <constraint field="ownercat_id" desc="" exp=""/>
  <constraint field="muni_id" desc="" exp=""/>
  <constraint field="postcode" desc="" exp=""/>
  <constraint field="district_id" desc="" exp=""/>
  <constraint field="streetname" desc="" exp=""/>
  <constraint field="postnumber" desc="" exp=""/>
  <constraint field="postcomplement" desc="" exp=""/>
  <constraint field="streetname2" desc="" exp=""/>
  <constraint field="postnumber2" desc="" exp=""/>
  <constraint field="postcomplement2" desc="" exp=""/>
  <constraint field="region_id" desc="" exp=""/>
  <constraint field="province_id" desc="" exp=""/>
  <constraint field="descript" desc="" exp=""/>
  <constraint field="link" desc="" exp=""/>
  <constraint field="verified" desc="" exp=""/>
  <constraint field="undelete" desc="" exp=""/>
  <constraint field="label" desc="" exp=""/>
  <constraint field="label_x" desc="" exp=""/>
  <constraint field="label_y" desc="" exp=""/>
  <constraint field="label_rotation" desc="" exp=""/>
  <constraint field="label_quadrant" desc="" exp=""/>
  <constraint field="publish" desc="" exp=""/>
  <constraint field="inventory" desc="" exp=""/>
  <constraint field="uncertain" desc="" exp=""/>
  <constraint field="num_value" desc="" exp=""/>
  <constraint field="asset_id" desc="" exp=""/>
  <constraint field="pavcat_id" desc="" exp=""/>
  <constraint field="parent_id" desc="" exp=""/>
  <constraint field="expl_id2" desc="" exp=""/>
  <constraint field="is_operative" desc="" exp=""/>
  <constraint field="minsector_id" desc="" exp=""/>
  <constraint field="macrominsector_id" desc="" exp=""/>
  <constraint field="adate" desc="" exp=""/>
  <constraint field="adescript" desc="" exp=""/>
  <constraint field="visitability" desc="" exp=""/>
  <constraint field="tstamp" desc="" exp=""/>
  <constraint field="insert_user" desc="" exp=""/>
  <constraint field="lastupdate" desc="" exp=""/>
  <constraint field="lastupdate_user" desc="" exp=""/>
  <constraint field="inp_type" desc="" exp=""/>
 </constraintExpressions>
 <expressionfields/>
 <attributeactions>
  <defaultAction value="{00000000-0000-0000-0000-000000000000}" key="Canvas"/>
 </attributeactions>
 <attributetableconfig sortOrder="0" actionWidgetStyle="dropDown" sortExpression="">
  <columns>
   <column hidden="0" width="-1" name="arc_id" type="field"/>
   <column hidden="0" width="-1" name="code" type="field"/>
   <column hidden="0" width="-1" name="node_1" type="field"/>
   <column hidden="0" width="-1" name="nodetype_1" type="field"/>
   <column hidden="0" width="-1" name="y1" type="field"/>
   <column hidden="0" width="-1" name="custom_y1" type="field"/>
   <column hidden="0" width="-1" name="elev1" type="field"/>
   <column hidden="0" width="-1" name="custom_elev1" type="field"/>
   <column hidden="0" width="-1" name="sys_elev1" type="field"/>
   <column hidden="0" width="-1" name="sys_y1" type="field"/>
   <column hidden="0" width="-1" name="r1" type="field"/>
   <column hidden="0" width="-1" name="z1" type="field"/>
   <column hidden="0" width="-1" name="node_2" type="field"/>
   <column hidden="0" width="-1" name="nodetype_2" type="field"/>
   <column hidden="0" width="-1" name="y2" type="field"/>
   <column hidden="0" width="-1" name="custom_y2" type="field"/>
   <column hidden="0" width="-1" name="elev2" type="field"/>
   <column hidden="0" width="-1" name="custom_elev2" type="field"/>
   <column hidden="0" width="-1" name="sys_elev2" type="field"/>
   <column hidden="0" width="-1" name="sys_y2" type="field"/>
   <column hidden="0" width="-1" name="r2" type="field"/>
   <column hidden="0" width="-1" name="z2" type="field"/>
   <column hidden="0" width="-1" name="slope" type="field"/>
   <column hidden="0" width="-1" name="arc_type" type="field"/>
   <column hidden="0" width="-1" name="sys_type" type="field"/>
   <column hidden="0" width="-1" name="arccat_id" type="field"/>
   <column hidden="0" width="-1" name="matcat_id" type="field"/>
   <column hidden="0" width="-1" name="cat_shape" type="field"/>
   <column hidden="0" width="-1" name="cat_geom1" type="field"/>
   <column hidden="0" width="-1" name="cat_geom2" type="field"/>
   <column hidden="0" width="-1" name="cat_width" type="field"/>
   <column hidden="0" width="-1" name="cat_area" type="field"/>
   <column hidden="0" width="-1" name="epa_type" type="field"/>
   <column hidden="0" width="-1" name="state" type="field"/>
   <column hidden="0" width="-1" name="state_type" type="field"/>
   <column hidden="0" width="-1" name="expl_id" type="field"/>
   <column hidden="0" width="-1" name="macroexpl_id" type="field"/>
   <column hidden="0" width="-1" name="sector_id" type="field"/>
   <column hidden="0" width="-1" name="sector_type" type="field"/>
   <column hidden="0" width="-1" name="macrosector_id" type="field"/>
   <column hidden="0" width="-1" name="drainzone_id" type="field"/>
   <column hidden="0" width="-1" name="drainzone_type" type="field"/>
   <column hidden="0" width="-1" name="annotation" type="field"/>
   <column hidden="0" width="-1" name="gis_length" type="field"/>
   <column hidden="0" width="-1" name="custom_length" type="field"/>
   <column hidden="0" width="-1" name="inverted_slope" type="field"/>
   <column hidden="0" width="-1" name="observ" type="field"/>
   <column hidden="0" width="-1" name="comment" type="field"/>
   <column hidden="0" width="-1" name="dma_id" type="field"/>
   <column hidden="0" width="-1" name="macrodma_id" type="field"/>
   <column hidden="0" width="-1" name="dma_type" type="field"/>
   <column hidden="0" width="-1" name="soilcat_id" type="field"/>
   <column hidden="0" width="-1" name="function_type" type="field"/>
   <column hidden="0" width="-1" name="category_type" type="field"/>
   <column hidden="0" width="-1" name="fluid_type" type="field"/>
   <column hidden="0" width="-1" name="location_type" type="field"/>
   <column hidden="0" width="-1" name="workcat_id" type="field"/>
   <column hidden="0" width="-1" name="workcat_id_end" type="field"/>
   <column hidden="0" width="-1" name="workcat_id_plan" type="field"/>
   <column hidden="0" width="-1" name="builtdate" type="field"/>
   <column hidden="0" width="-1" name="enddate" type="field"/>
   <column hidden="0" width="-1" name="buildercat_id" type="field"/>
   <column hidden="0" width="-1" name="ownercat_id" type="field"/>
   <column hidden="0" width="-1" name="muni_id" type="field"/>
   <column hidden="0" width="-1" name="postcode" type="field"/>
   <column hidden="0" width="-1" name="district_id" type="field"/>
   <column hidden="0" width="-1" name="streetname" type="field"/>
   <column hidden="0" width="-1" name="postnumber" type="field"/>
   <column hidden="0" width="-1" name="postcomplement" type="field"/>
   <column hidden="0" width="-1" name="streetname2" type="field"/>
   <column hidden="0" width="-1" name="postnumber2" type="field"/>
   <column hidden="0" width="-1" name="postcomplement2" type="field"/>
   <column hidden="0" width="-1" name="region_id" type="field"/>
   <column hidden="0" width="-1" name="province_id" type="field"/>
   <column hidden="0" width="-1" name="descript" type="field"/>
   <column hidden="0" width="-1" name="link" type="field"/>
   <column hidden="0" width="-1" name="verified" type="field"/>
   <column hidden="0" width="-1" name="undelete" type="field"/>
   <column hidden="0" width="-1" name="label" type="field"/>
   <column hidden="0" width="-1" name="label_x" type="field"/>
   <column hidden="0" width="-1" name="label_y" type="field"/>
   <column hidden="0" width="-1" name="label_rotation" type="field"/>
   <column hidden="0" width="-1" name="label_quadrant" type="field"/>
   <column hidden="0" width="-1" name="publish" type="field"/>
   <column hidden="0" width="-1" name="inventory" type="field"/>
   <column hidden="0" width="-1" name="uncertain" type="field"/>
   <column hidden="0" width="-1" name="num_value" type="field"/>
   <column hidden="0" width="-1" name="asset_id" type="field"/>
   <column hidden="0" width="-1" name="pavcat_id" type="field"/>
   <column hidden="0" width="-1" name="parent_id" type="field"/>
   <column hidden="0" width="-1" name="expl_id2" type="field"/>
   <column hidden="0" width="-1" name="is_operative" type="field"/>
   <column hidden="0" width="-1" name="minsector_id" type="field"/>
   <column hidden="0" width="-1" name="macrominsector_id" type="field"/>
   <column hidden="0" width="-1" name="adate" type="field"/>
   <column hidden="0" width="-1" name="adescript" type="field"/>
   <column hidden="0" width="-1" name="visitability" type="field"/>
   <column hidden="0" width="-1" name="tstamp" type="field"/>
   <column hidden="0" width="-1" name="insert_user" type="field"/>
   <column hidden="0" width="-1" name="lastupdate" type="field"/>
   <column hidden="0" width="-1" name="lastupdate_user" type="field"/>
   <column hidden="0" width="-1" name="inp_type" type="field"/>
   <column hidden="1" width="-1" type="actions"/>
  </columns>
 </attributetableconfig>
 <conditionalstyles>
  <rowstyles/>
  <fieldstyles/>
 </conditionalstyles>
 <storedexpressions/>
 <editform tolerant="1"></editform>
 <editforminit/>
 <editforminitcodesource>0</editforminitcodesource>
 <editforminitfilepath></editforminitfilepath>
 <editforminitcode><![CDATA[# -*- codificación: utf-8 -*-
"""
Los formularios de QGIS pueden tener una función de Python que
es llamada cuando se abre el formulario.

Use esta función para añadir lógica extra a sus formularios.

Introduzca el nombre de la función en el campo
"Python Init function".
Sigue un ejemplo:
"""
from qgis.PyQt.QtWidgets import QWidget

def my_form_open(dialog, layer, feature):
	geom = feature.geometry()
	control = dialog.findChild(QWidget, "MyLineEdit")
]]></editforminitcode>
 <featformsuppress>0</featformsuppress>
 <editorlayout>generatedlayout</editorlayout>
 <editable>
  <field name="adate" editable="1"/>
  <field name="adescript" editable="1"/>
  <field name="annotation" editable="1"/>
  <field name="arc_id" editable="1"/>
  <field name="arc_type" editable="1"/>
  <field name="arccat_id" editable="1"/>
  <field name="asset_id" editable="1"/>
  <field name="buildercat_id" editable="1"/>
  <field name="builtdate" editable="1"/>
  <field name="cat_area" editable="1"/>
  <field name="cat_geom1" editable="1"/>
  <field name="cat_geom2" editable="1"/>
  <field name="cat_shape" editable="1"/>
  <field name="cat_width" editable="1"/>
  <field name="category_type" editable="1"/>
  <field name="code" editable="1"/>
  <field name="comment" editable="1"/>
  <field name="custom_elev1" editable="1"/>
  <field name="custom_elev2" editable="1"/>
  <field name="custom_length" editable="1"/>
  <field name="custom_y1" editable="1"/>
  <field name="custom_y2" editable="1"/>
  <field name="descript" editable="1"/>
  <field name="district_id" editable="1"/>
  <field name="dma_id" editable="1"/>
  <field name="dma_type" editable="1"/>
  <field name="drainzone_id" editable="1"/>
  <field name="drainzone_type" editable="1"/>
  <field name="elev1" editable="1"/>
  <field name="elev2" editable="1"/>
  <field name="enddate" editable="1"/>
  <field name="epa_type" editable="1"/>
  <field name="expl_id" editable="1"/>
  <field name="expl_id2" editable="1"/>
  <field name="fluid_type" editable="1"/>
  <field name="function_type" editable="1"/>
  <field name="gis_length" editable="1"/>
  <field name="inp_type" editable="1"/>
  <field name="insert_user" editable="1"/>
  <field name="inventory" editable="1"/>
  <field name="inverted_slope" editable="1"/>
  <field name="is_operative" editable="1"/>
  <field name="label" editable="1"/>
  <field name="label_quadrant" editable="1"/>
  <field name="label_rotation" editable="1"/>
  <field name="label_x" editable="1"/>
  <field name="label_y" editable="1"/>
  <field name="lastupdate" editable="1"/>
  <field name="lastupdate_user" editable="1"/>
  <field name="link" editable="1"/>
  <field name="location_type" editable="1"/>
  <field name="macrodma_id" editable="1"/>
  <field name="macroexpl_id" editable="1"/>
  <field name="macrominsector_id" editable="1"/>
  <field name="macrosector_id" editable="1"/>
  <field name="matcat_id" editable="1"/>
  <field name="minsector_id" editable="1"/>
  <field name="muni_id" editable="1"/>
  <field name="node_1" editable="1"/>
  <field name="node_2" editable="1"/>
  <field name="nodetype_1" editable="1"/>
  <field name="nodetype_2" editable="1"/>
  <field name="num_value" editable="1"/>
  <field name="observ" editable="1"/>
  <field name="ownercat_id" editable="1"/>
  <field name="parent_id" editable="1"/>
  <field name="pavcat_id" editable="1"/>
  <field name="postcode" editable="1"/>
  <field name="postcomplement" editable="1"/>
  <field name="postcomplement2" editable="1"/>
  <field name="postnumber" editable="1"/>
  <field name="postnumber2" editable="1"/>
  <field name="province_id" editable="1"/>
  <field name="publish" editable="1"/>
  <field name="r1" editable="1"/>
  <field name="r2" editable="1"/>
  <field name="region_id" editable="1"/>
  <field name="sector_id" editable="1"/>
  <field name="sector_type" editable="1"/>
  <field name="slope" editable="1"/>
  <field name="soilcat_id" editable="1"/>
  <field name="state" editable="1"/>
  <field name="state_type" editable="1"/>
  <field name="streetname" editable="1"/>
  <field name="streetname2" editable="1"/>
  <field name="sys_elev1" editable="1"/>
  <field name="sys_elev2" editable="1"/>
  <field name="sys_type" editable="1"/>
  <field name="sys_y1" editable="1"/>
  <field name="sys_y2" editable="1"/>
  <field name="tstamp" editable="1"/>
  <field name="uncertain" editable="1"/>
  <field name="undelete" editable="1"/>
  <field name="verified" editable="1"/>
  <field name="visitability" editable="1"/>
  <field name="workcat_id" editable="1"/>
  <field name="workcat_id_end" editable="1"/>
  <field name="workcat_id_plan" editable="1"/>
  <field name="y1" editable="1"/>
  <field name="y2" editable="1"/>
  <field name="z1" editable="1"/>
  <field name="z2" editable="1"/>
 </editable>
 <labelOnTop>
  <field labelOnTop="0" name="adate"/>
  <field labelOnTop="0" name="adescript"/>
  <field labelOnTop="0" name="annotation"/>
  <field labelOnTop="0" name="arc_id"/>
  <field labelOnTop="0" name="arc_type"/>
  <field labelOnTop="0" name="arccat_id"/>
  <field labelOnTop="0" name="asset_id"/>
  <field labelOnTop="0" name="buildercat_id"/>
  <field labelOnTop="0" name="builtdate"/>
  <field labelOnTop="0" name="cat_area"/>
  <field labelOnTop="0" name="cat_geom1"/>
  <field labelOnTop="0" name="cat_geom2"/>
  <field labelOnTop="0" name="cat_shape"/>
  <field labelOnTop="0" name="cat_width"/>
  <field labelOnTop="0" name="category_type"/>
  <field labelOnTop="0" name="code"/>
  <field labelOnTop="0" name="comment"/>
  <field labelOnTop="0" name="custom_elev1"/>
  <field labelOnTop="0" name="custom_elev2"/>
  <field labelOnTop="0" name="custom_length"/>
  <field labelOnTop="0" name="custom_y1"/>
  <field labelOnTop="0" name="custom_y2"/>
  <field labelOnTop="0" name="descript"/>
  <field labelOnTop="0" name="district_id"/>
  <field labelOnTop="0" name="dma_id"/>
  <field labelOnTop="0" name="dma_type"/>
  <field labelOnTop="0" name="drainzone_id"/>
  <field labelOnTop="0" name="drainzone_type"/>
  <field labelOnTop="0" name="elev1"/>
  <field labelOnTop="0" name="elev2"/>
  <field labelOnTop="0" name="enddate"/>
  <field labelOnTop="0" name="epa_type"/>
  <field labelOnTop="0" name="expl_id"/>
  <field labelOnTop="0" name="expl_id2"/>
  <field labelOnTop="0" name="fluid_type"/>
  <field labelOnTop="0" name="function_type"/>
  <field labelOnTop="0" name="gis_length"/>
  <field labelOnTop="0" name="inp_type"/>
  <field labelOnTop="0" name="insert_user"/>
  <field labelOnTop="0" name="inventory"/>
  <field labelOnTop="0" name="inverted_slope"/>
  <field labelOnTop="0" name="is_operative"/>
  <field labelOnTop="0" name="label"/>
  <field labelOnTop="0" name="label_quadrant"/>
  <field labelOnTop="0" name="label_rotation"/>
  <field labelOnTop="0" name="label_x"/>
  <field labelOnTop="0" name="label_y"/>
  <field labelOnTop="0" name="lastupdate"/>
  <field labelOnTop="0" name="lastupdate_user"/>
  <field labelOnTop="0" name="link"/>
  <field labelOnTop="0" name="location_type"/>
  <field labelOnTop="0" name="macrodma_id"/>
  <field labelOnTop="0" name="macroexpl_id"/>
  <field labelOnTop="0" name="macrominsector_id"/>
  <field labelOnTop="0" name="macrosector_id"/>
  <field labelOnTop="0" name="matcat_id"/>
  <field labelOnTop="0" name="minsector_id"/>
  <field labelOnTop="0" name="muni_id"/>
  <field labelOnTop="0" name="node_1"/>
  <field labelOnTop="0" name="node_2"/>
  <field labelOnTop="0" name="nodetype_1"/>
  <field labelOnTop="0" name="nodetype_2"/>
  <field labelOnTop="0" name="num_value"/>
  <field labelOnTop="0" name="observ"/>
  <field labelOnTop="0" name="ownercat_id"/>
  <field labelOnTop="0" name="parent_id"/>
  <field labelOnTop="0" name="pavcat_id"/>
  <field labelOnTop="0" name="postcode"/>
  <field labelOnTop="0" name="postcomplement"/>
  <field labelOnTop="0" name="postcomplement2"/>
  <field labelOnTop="0" name="postnumber"/>
  <field labelOnTop="0" name="postnumber2"/>
  <field labelOnTop="0" name="province_id"/>
  <field labelOnTop="0" name="publish"/>
  <field labelOnTop="0" name="r1"/>
  <field labelOnTop="0" name="r2"/>
  <field labelOnTop="0" name="region_id"/>
  <field labelOnTop="0" name="sector_id"/>
  <field labelOnTop="0" name="sector_type"/>
  <field labelOnTop="0" name="slope"/>
  <field labelOnTop="0" name="soilcat_id"/>
  <field labelOnTop="0" name="state"/>
  <field labelOnTop="0" name="state_type"/>
  <field labelOnTop="0" name="streetname"/>
  <field labelOnTop="0" name="streetname2"/>
  <field labelOnTop="0" name="sys_elev1"/>
  <field labelOnTop="0" name="sys_elev2"/>
  <field labelOnTop="0" name="sys_type"/>
  <field labelOnTop="0" name="sys_y1"/>
  <field labelOnTop="0" name="sys_y2"/>
  <field labelOnTop="0" name="tstamp"/>
  <field labelOnTop="0" name="uncertain"/>
  <field labelOnTop="0" name="undelete"/>
  <field labelOnTop="0" name="verified"/>
  <field labelOnTop="0" name="visitability"/>
  <field labelOnTop="0" name="workcat_id"/>
  <field labelOnTop="0" name="workcat_id_end"/>
  <field labelOnTop="0" name="workcat_id_plan"/>
  <field labelOnTop="0" name="y1"/>
  <field labelOnTop="0" name="y2"/>
  <field labelOnTop="0" name="z1"/>
  <field labelOnTop="0" name="z2"/>
 </labelOnTop>
 <reuseLastValue>
  <field name="adate" reuseLastValue="0"/>
  <field name="adescript" reuseLastValue="0"/>
  <field name="annotation" reuseLastValue="0"/>
  <field name="arc_id" reuseLastValue="0"/>
  <field name="arc_type" reuseLastValue="0"/>
  <field name="arccat_id" reuseLastValue="0"/>
  <field name="asset_id" reuseLastValue="0"/>
  <field name="buildercat_id" reuseLastValue="0"/>
  <field name="builtdate" reuseLastValue="0"/>
  <field name="cat_area" reuseLastValue="0"/>
  <field name="cat_geom1" reuseLastValue="0"/>
  <field name="cat_geom2" reuseLastValue="0"/>
  <field name="cat_shape" reuseLastValue="0"/>
  <field name="cat_width" reuseLastValue="0"/>
  <field name="category_type" reuseLastValue="0"/>
  <field name="code" reuseLastValue="0"/>
  <field name="comment" reuseLastValue="0"/>
  <field name="custom_elev1" reuseLastValue="0"/>
  <field name="custom_elev2" reuseLastValue="0"/>
  <field name="custom_length" reuseLastValue="0"/>
  <field name="custom_y1" reuseLastValue="0"/>
  <field name="custom_y2" reuseLastValue="0"/>
  <field name="descript" reuseLastValue="0"/>
  <field name="district_id" reuseLastValue="0"/>
  <field name="dma_id" reuseLastValue="0"/>
  <field name="dma_type" reuseLastValue="0"/>
  <field name="drainzone_id" reuseLastValue="0"/>
  <field name="drainzone_type" reuseLastValue="0"/>
  <field name="elev1" reuseLastValue="0"/>
  <field name="elev2" reuseLastValue="0"/>
  <field name="enddate" reuseLastValue="0"/>
  <field name="epa_type" reuseLastValue="0"/>
  <field name="expl_id" reuseLastValue="0"/>
  <field name="expl_id2" reuseLastValue="0"/>
  <field name="fluid_type" reuseLastValue="0"/>
  <field name="function_type" reuseLastValue="0"/>
  <field name="gis_length" reuseLastValue="0"/>
  <field name="inp_type" reuseLastValue="0"/>
  <field name="insert_user" reuseLastValue="0"/>
  <field name="inventory" reuseLastValue="0"/>
  <field name="inverted_slope" reuseLastValue="0"/>
  <field name="is_operative" reuseLastValue="0"/>
  <field name="label" reuseLastValue="0"/>
  <field name="label_quadrant" reuseLastValue="0"/>
  <field name="label_rotation" reuseLastValue="0"/>
  <field name="label_x" reuseLastValue="0"/>
  <field name="label_y" reuseLastValue="0"/>
  <field name="lastupdate" reuseLastValue="0"/>
  <field name="lastupdate_user" reuseLastValue="0"/>
  <field name="link" reuseLastValue="0"/>
  <field name="location_type" reuseLastValue="0"/>
  <field name="macrodma_id" reuseLastValue="0"/>
  <field name="macroexpl_id" reuseLastValue="0"/>
  <field name="macrominsector_id" reuseLastValue="0"/>
  <field name="macrosector_id" reuseLastValue="0"/>
  <field name="matcat_id" reuseLastValue="0"/>
  <field name="minsector_id" reuseLastValue="0"/>
  <field name="muni_id" reuseLastValue="0"/>
  <field name="node_1" reuseLastValue="0"/>
  <field name="node_2" reuseLastValue="0"/>
  <field name="nodetype_1" reuseLastValue="0"/>
  <field name="nodetype_2" reuseLastValue="0"/>
  <field name="num_value" reuseLastValue="0"/>
  <field name="observ" reuseLastValue="0"/>
  <field name="ownercat_id" reuseLastValue="0"/>
  <field name="parent_id" reuseLastValue="0"/>
  <field name="pavcat_id" reuseLastValue="0"/>
  <field name="postcode" reuseLastValue="0"/>
  <field name="postcomplement" reuseLastValue="0"/>
  <field name="postcomplement2" reuseLastValue="0"/>
  <field name="postnumber" reuseLastValue="0"/>
  <field name="postnumber2" reuseLastValue="0"/>
  <field name="province_id" reuseLastValue="0"/>
  <field name="publish" reuseLastValue="0"/>
  <field name="r1" reuseLastValue="0"/>
  <field name="r2" reuseLastValue="0"/>
  <field name="region_id" reuseLastValue="0"/>
  <field name="sector_id" reuseLastValue="0"/>
  <field name="sector_type" reuseLastValue="0"/>
  <field name="slope" reuseLastValue="0"/>
  <field name="soilcat_id" reuseLastValue="0"/>
  <field name="state" reuseLastValue="0"/>
  <field name="state_type" reuseLastValue="0"/>
  <field name="streetname" reuseLastValue="0"/>
  <field name="streetname2" reuseLastValue="0"/>
  <field name="sys_elev1" reuseLastValue="0"/>
  <field name="sys_elev2" reuseLastValue="0"/>
  <field name="sys_type" reuseLastValue="0"/>
  <field name="sys_y1" reuseLastValue="0"/>
  <field name="sys_y2" reuseLastValue="0"/>
  <field name="tstamp" reuseLastValue="0"/>
  <field name="uncertain" reuseLastValue="0"/>
  <field name="undelete" reuseLastValue="0"/>
  <field name="verified" reuseLastValue="0"/>
  <field name="visitability" reuseLastValue="0"/>
  <field name="workcat_id" reuseLastValue="0"/>
  <field name="workcat_id_end" reuseLastValue="0"/>
  <field name="workcat_id_plan" reuseLastValue="0"/>
  <field name="y1" reuseLastValue="0"/>
  <field name="y2" reuseLastValue="0"/>
  <field name="z1" reuseLastValue="0"/>
  <field name="z2" reuseLastValue="0"/>
 </reuseLastValue>
 <dataDefinedFieldProperties/>
 <widgets/>
 <previewExpression>"streetname"</previewExpression>
 <mapTip></mapTip>
 <layerGeometryType>1</layerGeometryType>
</qgis>
' where layername = 'v_edit_arc' and styleconfig_id = 102;






