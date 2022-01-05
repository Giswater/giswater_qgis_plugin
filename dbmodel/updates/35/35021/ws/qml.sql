/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2022/01/05

INSERT INTO sys_style VALUES('10','v_edit_inp_junction','qml',
'<!DOCTYPE qgis PUBLIC ''http://mrcc.com/qgis.dtd'' ''SYSTEM''>
<qgis simplifyDrawingHints="1" simplifyLocal="1" simplifyMaxScale="1" version="3.16.5-Hannover" minScale="100000000" hasScaleBasedVisibilityFlag="0" simplifyDrawingTol="1" readOnly="0" labelsEnabled="0" maxScale="0" simplifyAlgorithm="0" styleCategories="AllStyleCategories">
  <flags>
    <Identifiable>1</Identifiable>
    <Removable>1</Removable>
    <Searchable>1</Searchable>
  </flags>
  <temporal endExpression="" fixedDuration="0" enabled="0" startExpression="" durationUnit="min" endField="" mode="0" durationField="" startField="" accumulate="0">
    <fixedRange>
      <start></start>
      <end></end>
    </fixedRange>
  </temporal>
  <renderer-v2 type="singleSymbol" symbollevels="0" enableorderby="0" forceraster="0">
    <symbols>
      <symbol type="marker" clip_to_extent="1" alpha="1" force_rhr="0" name="0">
        <layer enabled="1" class="SimpleMarker" pass="0" locked="0">
          <prop v="0" k="angle"/>
          <prop v="0,242,255,255" k="color"/>
          <prop v="1" k="horizontal_anchor_point"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="circle" k="name"/>
          <prop v="0,0" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="0,0,0,255" k="outline_color"/>
          <prop v="solid" k="outline_style"/>
          <prop v="0" k="outline_width"/>
          <prop v="3x:0,0,0,0,0,0" k="outline_width_map_unit_scale"/>
          <prop v="MM" k="outline_width_unit"/>
          <prop v="diameter" k="scale_method"/>
          <prop v="2" k="size"/>
          <prop v="3x:0,0,0,0,0,0" k="size_map_unit_scale"/>
          <prop v="MM" k="size_unit"/>
          <prop v="1" k="vertical_anchor_point"/>
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
    <rotation/>
    <sizescale/>
  </renderer-v2>
  <customproperties/>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerOpacity>1</layerOpacity>
  <geometryOptions geometryPrecision="0" removeDuplicateNodes="0">
    <activeChecks type="StringList">
      <Option type="QString" value=""/>
    </activeChecks>
    <checkConfiguration/>
  </geometryOptions>
  <legend type="default-vector"/>
  <referencedLayers/>
  <fieldConfiguration>
    <field configurationFlags="None" name="node_id">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="elevation">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="depth">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="nodecat_id">
      <editWidget type="ValueRelation">
        <config>
          <Option type="Map">
            <Option type="QString" value="False" name="AllowNull"/>
            <Option type="QString" value="" name="FilterExpression"/>
            <Option type="QString" value="id" name="Key"/>
            <Option type="QString" value="cat_node20151105202206790" name="Layer"/>
            <Option type="QString" value="id" name="Value"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="sector_id">
      <editWidget type="ValueRelation">
        <config>
          <Option type="Map">
            <Option type="QString" value="False" name="AllowNull"/>
            <Option type="QString" value="" name="FilterExpression"/>
            <Option type="QString" value="sector_id" name="Key"/>
            <Option type="QString" value="v_edit_sector20171204170540567" name="Layer"/>
            <Option type="QString" value="name" name="Value"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="macrosector_id">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option type="Map" name="map">
              <Option type="QString" value="0" name="Undefined"/>
              <Option type="QString" value="1" name="macrosector_01"/>
              <Option type="QString" value="2" name="macrosector_02"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="dma_id">
      <editWidget type="ValueRelation">
        <config>
          <Option type="Map">
            <Option type="QString" value="False" name="AllowNull"/>
            <Option type="QString" value="" name="FilterExpression"/>
            <Option type="QString" value="dma_id" name="Key"/>
            <Option type="QString" value="v_edit_dma20190515092620863" name="Layer"/>
            <Option type="QString" value="name" name="Value"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="state">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option type="Map" name="map">
              <Option type="QString" value="0" name="OBSOLETE"/>
              <Option type="QString" value="1" name="OPERATIVE"/>
              <Option type="QString" value="2" name="PLANIFIED"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="state_type">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option type="Map" name="map">
              <Option type="QString" value="95" name="CANCELED FICTICIOUS"/>
              <Option type="QString" value="96" name="CANCELED PLANIFIED"/>
              <Option type="QString" value="97" name="DONE FICTICIOUS"/>
              <Option type="QString" value="98" name="DONE PLANIFIED"/>
              <Option type="QString" value="99" name="FICTICIUS"/>
              <Option type="QString" value="1" name="OBSOLETE"/>
              <Option type="QString" value="2" name="OPERATIVE"/>
              <Option type="QString" value="3" name="PLANIFIED"/>
              <Option type="QString" value="5" name="PROVISIONAL"/>
              <Option type="QString" value="4" name="RECONSTRUCT"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="annotation">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="demand">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="pattern_id">
      <editWidget type="ValueRelation">
        <config>
          <Option type="Map">
            <Option type="QString" value="True" name="AllowNull"/>
            <Option type="QString" value="" name="FilterExpression"/>
            <Option type="QString" value="pattern_id" name="Key"/>
            <Option type="QString" value="v_edit_inp_pattern_aa06a7c7_458c_4809_a192_2495d2bf77fd" name="Layer"/>
            <Option type="QString" value="pattern_id" name="Value"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="peak_factor">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
          </Option>
        </config>
      </editWidget>
    </field>
  </fieldConfiguration>
  <aliases>
    <alias name="node_id" index="0" field="node_id"/>
    <alias name="elevation" index="1" field="elevation"/>
    <alias name="depth" index="2" field="depth"/>
    <alias name="nodecat_id" index="3" field="nodecat_id"/>
    <alias name="sector_id" index="4" field="sector_id"/>
    <alias name="macrosector_id" index="5" field="macrosector_id"/>
    <alias name="Dma" index="6" field="dma_id"/>
    <alias name="state" index="7" field="state"/>
    <alias name="State type" index="8" field="state_type"/>
    <alias name="annotation" index="9" field="annotation"/>
    <alias name="demand" index="10" field="demand"/>
    <alias name="pattern_id" index="11" field="pattern_id"/>
    <alias name="peak_factor" index="12" field="peak_factor"/>
  </aliases>
  <defaults>
    <default expression="" field="node_id" applyOnUpdate="0"/>
    <default expression="" field="elevation" applyOnUpdate="0"/>
    <default expression="" field="depth" applyOnUpdate="0"/>
    <default expression="" field="nodecat_id" applyOnUpdate="0"/>
    <default expression="" field="sector_id" applyOnUpdate="0"/>
    <default expression="" field="macrosector_id" applyOnUpdate="0"/>
    <default expression="" field="dma_id" applyOnUpdate="0"/>
    <default expression="" field="state" applyOnUpdate="0"/>
    <default expression="" field="state_type" applyOnUpdate="0"/>
    <default expression="" field="annotation" applyOnUpdate="0"/>
    <default expression="" field="demand" applyOnUpdate="0"/>
    <default expression="" field="pattern_id" applyOnUpdate="0"/>
    <default expression="" field="peak_factor" applyOnUpdate="0"/>
  </defaults>
  <constraints>
    <constraint exp_strength="0" notnull_strength="2" constraints="3" unique_strength="1" field="node_id"/>
    <constraint exp_strength="0" notnull_strength="2" constraints="1" unique_strength="0" field="elevation"/>
    <constraint exp_strength="0" notnull_strength="2" constraints="1" unique_strength="0" field="depth"/>
    <constraint exp_strength="0" notnull_strength="2" constraints="1" unique_strength="0" field="nodecat_id"/>
    <constraint exp_strength="0" notnull_strength="2" constraints="1" unique_strength="0" field="sector_id"/>
    <constraint exp_strength="0" notnull_strength="2" constraints="1" unique_strength="0" field="macrosector_id"/>
    <constraint exp_strength="0" notnull_strength="2" constraints="1" unique_strength="0" field="dma_id"/>
    <constraint exp_strength="0" notnull_strength="2" constraints="1" unique_strength="0" field="state"/>
    <constraint exp_strength="0" notnull_strength="2" constraints="1" unique_strength="0" field="state_type"/>
    <constraint exp_strength="0" notnull_strength="2" constraints="1" unique_strength="0" field="annotation"/>
    <constraint exp_strength="0" notnull_strength="2" constraints="1" unique_strength="0" field="demand"/>
    <constraint exp_strength="0" notnull_strength="2" constraints="1" unique_strength="0" field="pattern_id"/>
    <constraint exp_strength="0" notnull_strength="2" constraints="1" unique_strength="0" field="peak_factor"/>
  </constraints>
  <constraintExpressions>
    <constraint exp="" desc="" field="node_id"/>
    <constraint exp="" desc="" field="elevation"/>
    <constraint exp="" desc="" field="depth"/>
    <constraint exp="" desc="" field="nodecat_id"/>
    <constraint exp="" desc="" field="sector_id"/>
    <constraint exp="" desc="" field="macrosector_id"/>
    <constraint exp="" desc="" field="dma_id"/>
    <constraint exp="" desc="" field="state"/>
    <constraint exp="" desc="" field="state_type"/>
    <constraint exp="" desc="" field="annotation"/>
    <constraint exp="" desc="" field="demand"/>
    <constraint exp="" desc="" field="pattern_id"/>
    <constraint exp="" desc="" field="peak_factor"/>
  </constraintExpressions>
  <expressionfields/>
  <attributeactions>
    <defaultAction value="{00000000-0000-0000-0000-000000000000}" key="Canvas"/>
  </attributeactions>
  <attributetableconfig actionWidgetStyle="dropDown" sortExpression="" sortOrder="0">
    <columns>
      <column type="field" name="node_id" width="-1" hidden="0"/>
      <column type="field" name="elevation" width="-1" hidden="0"/>
      <column type="field" name="depth" width="-1" hidden="0"/>
      <column type="field" name="nodecat_id" width="-1" hidden="0"/>
      <column type="field" name="sector_id" width="-1" hidden="0"/>
      <column type="field" name="macrosector_id" width="-1" hidden="1"/>
      <column type="field" name="dma_id" width="-1" hidden="0"/>
      <column type="field" name="state" width="-1" hidden="0"/>
      <column type="field" name="state_type" width="-1" hidden="0"/>
      <column type="field" name="annotation" width="-1" hidden="0"/>
      <column type="field" name="demand" width="-1" hidden="0"/>
      <column type="field" name="pattern_id" width="-1" hidden="0"/>
      <column type="field" name="peak_factor" width="-1" hidden="0"/>
      <column type="actions" width="-1" hidden="1"/>
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
  <editforminitcode><![CDATA[]]></editforminitcode>
  <featformsuppress>2</featformsuppress>
  <editorlayout>generatedlayout</editorlayout>
  <editable>
    <field name="annotation" editable="1"/>
    <field name="demand" editable="1"/>
    <field name="depth" editable="1"/>
    <field name="dma_id" editable="1"/>
    <field name="elevation" editable="1"/>
    <field name="macrosector_id" editable="0"/>
    <field name="node_id" editable="0"/>
    <field name="nodecat_id" editable="1"/>
    <field name="pattern_id" editable="1"/>
    <field name="peak_factor" editable="1"/>
    <field name="sector_id" editable="1"/>
    <field name="state" editable="1"/>
    <field name="state_type" editable="1"/>
  </editable>
  <labelOnTop/>
  <dataDefinedFieldProperties/>
  <widgets/>
  <previewExpression></previewExpression>
  <mapTip></mapTip>
  <layerGeometryType>0</layerGeometryType>
</qgis>', true);