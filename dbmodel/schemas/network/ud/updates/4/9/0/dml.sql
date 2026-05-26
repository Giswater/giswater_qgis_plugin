/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

UPDATE config_form_fields SET dv_querytext='SELECT function_type AS id, function_type AS idval FROM man_type_function WHERE active AND (featurecat_id IS NULL AND ''GULLY''=ANY(feature_type))' WHERE formname='ve_gully' AND formtype='form_feature' AND columnname='function_type' AND tabname='tab_data';
UPDATE config_form_fields SET dv_querytext='SELECT category_type AS id, category_type AS idval FROM man_type_category WHERE active AND (featurecat_id IS NULL AND ''GULLY''=ANY(feature_type))' WHERE formname='ve_gully' AND formtype='form_feature' AND columnname='category_type' AND tabname='tab_data';
UPDATE config_form_fields SET dv_querytext='SELECT location_type AS id, location_type AS idval FROM man_type_location WHERE active AND (featurecat_id IS NULL AND ''GULLY''=ANY(feature_type))' WHERE formname='ve_gully' AND formtype='form_feature' AND columnname='location_type' AND tabname='tab_data';

UPDATE config_form_fields SET dv_querytext='SELECT id, idval FROM om_typevalue WHERE typevalue = ''fluid_type''' WHERE formname='ve_element' AND formtype='form_feature' AND columnname='fluid_type' AND tabname='tab_data';
UPDATE config_form_fields SET dv_querytext='SELECT id, idval FROM om_typevalue WHERE typevalue = ''fluid_type''' WHERE formname='ve_arc' AND formtype='form_feature' AND columnname='fluid_type' AND tabname='tab_data';
UPDATE config_form_fields SET dv_querytext='SELECT id, idval FROM om_typevalue WHERE typevalue = ''fluid_type''' WHERE formname='ve_node' AND formtype='form_feature' AND columnname='fluid_type' AND tabname='tab_data';
UPDATE config_form_fields SET dv_querytext='SELECT id, idval FROM om_typevalue WHERE typevalue = ''fluid_type''' WHERE formname='ve_connec' AND formtype='form_feature' AND columnname='fluid_type' AND tabname='tab_data';
UPDATE config_form_fields SET dv_querytext='SELECT id, idval FROM om_typevalue WHERE typevalue = ''fluid_type''' WHERE formname='ve_gully' AND formtype='form_feature' AND columnname='fluid_type' AND tabname='tab_data';

DELETE FROM config_param_user WHERE "parameter"='edit_insert_show_elevation_from_dem' AND cur_user='postgres';

-- 09/04/2026
WITH connec_customer AS (
    SELECT rxc.hydrometer_id,
        MIN(c.customer_code) AS customer_code
    FROM rtc_hydrometer_x_connec rxc
    JOIN connec c ON c.connec_id = rxc.connec_id
    WHERE c.customer_code IS NOT NULL
    GROUP BY rxc.hydrometer_id
)
UPDATE ext_rtc_hydrometer h
SET customer_code = cc.customer_code
FROM connec_customer cc
WHERE h.hydrometer_id = cc.hydrometer_id;

DROP TABLE IF EXISTS rtc_hydrometer_x_connec;

INSERT INTO config_toolbox
(id, alias, functionparams, inputparams, observ, active, device)
VALUES(3248, 'Massive node interpolation', '{"featureType":[]}'::json,
'[
  {"label": "type:", "value": null, "tooltip": "Process name", "comboIds": ["MASSIVE", "INIT", "FLOWEXIT"], "datatype": "text", "comboNames": ["MASSIVE", "INIT", "FLOWEXIT"], "layoutname": "grl_option_parameters", "selectedId": null, "widgetname": "type", "widgettype": "combo", "layoutorder": 1},
  {"label": "Min Ymax (INIT/FLOWEXIT):", "value": null, "tooltip": "Choose minimum ymax value", "datatype": "text", "layoutname": "grl_option_parameters", "selectedId": null, "widgetname": "minYmax", "widgettype": "text", "layoutorder": 2},
  {"label": "Max Ymax (INIT/FLOWEXIT):", "value": null, "tooltip": "Choose maximum ynax value", "datatype": "text", "layoutname": "grl_option_parameters", "selectedId": null, "widgetname": "maxYmax", "widgettype": "text", "layoutorder": 3},
  {"label": "Min Slope (INIT/FLOWEXIT):", "value": null, "tooltip": "Choose minimum slope", "datatype": "text", "layoutname": "grl_option_parameters", "selectedId": null, "widgetname": "minSlope", "widgettype": "text", "layoutorder": 4},
  {"label": "Max Slope (INIT/FLOWEXIT):", "value": null, "tooltip": "Choose maximum slope", "datatype": "text", "layoutname": "grl_option_parameters", "selectedId": null, "widgetname": "maxSlope", "widgettype": "text", "layoutorder": 5},
  {"label": "node1 (FLOWEXIT):", "value": null, "tooltip": "Choose source node of your path", "datatype": "text", "layoutname": "grl_option_parameters", "selectedId": null, "widgetname": "node1", "widgettype": "text", "layoutorder": 6},
  {"label": "node2 (FLOWEXIT):", "value": null, "tooltip": "Choose target node of your path", "datatype": "text", "layoutname": "grl_option_parameters", "selectedId": null, "widgetname": "node2", "widgettype": "text", "layoutorder": 7},
  {"label": "Profile Mode (FLOWEXIT):", "value": null, "tooltip": "Profile mode", "comboIds": ["SMOOTH", "SHALLOW", "DEEP", "CENTERED"], "datatype": "text", "comboNames": ["SMOOTH", "SHALLOW", "DEEP", "CENTERED"], "layoutname": "grl_option_parameters", "selectedId": null, "widgetname": "profileMode", "widgettype": "combo", "layoutorder": 8},
  {"label": "Smooth Factor (SMOOTH):", "value": null, "tooltip": "Choose smoothAlpha", "datatype": "text", "layoutname": "grl_option_parameters", "selectedId": null, "widgetname": "smoothFactor", "widgettype": "text", "layoutorder": 9}
  ]'::json,
NULL, true, '{4}');


UPDATE sys_function SET sys_role = 'role_edit', function_alias = 'Massive node interpolation' ,
descript =
'PURPOSE
This function calculates node invert elevations using different strategies depending on the requested calculation type.

SUPPORTED TYPES
1) MASSIVE
Legacy mode. For each node with sys_elev IS NULL, the function tries to identify upstream and downstream reference nodes with known elevation and delegates interpolation to gw_fct_node_interpolate.

2) FLOWEXIT
Advanced profile solver mode. The function:
- computes the shortest path between node1 and node2,
- treats node1 and node2 as fixed anchor points,
- may stop earlier at an internal hard point, validates the calculation window,solves the profile globally using: minYmax,maxYmax,minSlope, maxSlope and assigns elevations according to profileMode.

3) INIT
Head node initialization mode. The function:
- finds arcs whose node_1 is a head node (degree = 1, only connected to that arc),
- requires node_2 to have a fixed elevation (sys_elev or custom_elev),
- computes a feasible elevation interval for node_1 using: minYmax, maxYmax, minSlope,  maxSlope,
- updates node_1 when the interval is feasible and writes detailed log messages when the interval is infeasible.

ELEVATION MODEL
- sys_elev is the authoritative known elevation.
- custom_elev is the calculated elevation written by this function.
- The function only writes custom_elev for nodes where sys_elev IS NULL.

PROFILE MODES
- DEEP: Selects the deepest feasible solution.
- SHALLOW: Selects the shallowest feasible solution.
- CENTERED: Selects the midpoint between the lower and upper feasible envelopes.
- SMOOTH: Starts from a centered feasible solution and applies internal smoothing. iterations while preserving feasibility and fixed anchors. SmoothFactor: Strength of each smoothing iteration. Lower values = rougher / more conservative.  Higher values = smoother / more aggressive.

BUSINESS RULES
- custom_elev is only written where sys_elev IS NULL.
- MASSIVE interpolates node by node using nearby known references.
- FLOWEXIT solves a constrained profile along shortest path(node1, node2).
- In FLOWEXIT, node1 and node2 are always fixed anchors.
- Internal hard points can also act as fixed anchors.
- Hard points are nodes with degree > 2, existing custom_elev, and at least one connected arc with slope.
- Hard points are not cleaned or recalculated.
- INIT only processes head arcs where node_1 has degree = 1. In INIT, node_2 must already have fixed elevation.
- FLOWEXIT and INIT must satisfy Ymax and slope constraints.
- Infeasible cases are logged in audit_check_data with detailed diagnostics.'
WHERE id  = 3248;


INSERT INTO sys_table (id, descript, sys_role, "source") VALUES('v_anl_node_massiveinterpolate', 'Massive interpolate for nodes', 'role_basic', 'core') ON CONFLICT DO NOTHING;
INSERT INTO sys_table (id, descript, sys_role, "source") VALUES('v_anl_arc_massiveinterpolate', 'Massive interpolate for arcs', 'role_basic', 'core') ON CONFLICT DO NOTHING;

-- 13/04/2026
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (4628, 'Number of nodes interpolated', null, 2, true, 'ud', 'core', 'UI') ON CONFLICT DO NOTHING;

-- 21/04/2026
DROP RULE IF EXISTS dwfzone_expl ON dwfzone;
INSERT INTO dwfzone (dwfzone_id, code, "name", dwfzone_type, expl_id, sector_id, muni_id, descript, link, graphconfig, stylesheet, lock_level, active, the_geom, created_at, created_by, updated_at, updated_by, drainzone_id, addparam) VALUES(-1, '-1', 'Conflict', NULL, '{0}', '{0}', '{0}', 'Dwfzone used on graphanalytics algorithm when two ore more zones has conflict in terms of some interconnection.', NULL, '{"use":[{"nodeParent":""}], "ignore":[], "forceClosed":[]}'::json, NULL, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL) ON CONFLICT (dwfzone_id) DO NOTHING;

-- 22/04/2026
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (4630, 'The node does not belong to the selected lot', 'Choose a node that belongs to the selected lot or change selected lot', 2, true, 'ud', 'core', 'UI') ON CONFLICT DO NOTHING;

-- 23/04/2026
INSERT INTO config_typevalue
(typevalue, id, idval, camelstyle, addparam)
VALUES('tabname_typevalue', 'tab_drainzone', 'tab_drainzone', 'tabRelations', NULL);
INSERT INTO config_typevalue
(typevalue, id, idval, camelstyle, addparam)
VALUES('tabname_typevalue', 'tab_dwfzone', 'tab_dwfzone', 'tabRelations', NULL);

INSERT INTO config_form_tabs
(formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device)
VALUES('form_mapzone', 'tab_drainzone', 'Drainzone', 'Drainzone', 'role_basic', NULL, NULL, 5, '{4}');
INSERT INTO config_form_tabs
(formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device)
VALUES('form_mapzone', 'tab_dwfzone', 'Dwfzone', 'Dwfzone', 'role_basic', NULL, NULL, 6, '{4}');

INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('mapzone_manager', 'form_mapzone', 'tab_none', 'tab_main', 'lyt_mapzone_mng_2', 1, NULL, 'tabwidget', NULL, NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "tabs": [
    "tab_macrosector",
	"tab_sector",
	"tab_drainzone",
	"tab_dwfzone",
	"tab_dma",
	"tab_macroomzone"
  ]
}'::json, NULL, NULL, false, 10);

UPDATE sys_function SET id = 2430, project_type = 'utils' WHERE function_name = 'gw_fct_pg2epa_check_data';

-- 28/04/2026
INSERT INTO sys_feature_class (id, "type", epa_default, man_table) VALUES('NETSAMPLEPOINT', 'NODE', 'JUNCTION', 'man_netsamplepoint');

INSERT INTO sys_table (id, descript, sys_role, project_template, context, orderby, alias, notify_action, isaudit, keepauditdays, "source", addparam)
VALUES('man_netsamplepoint', 'Additional information for netsamplepoint management', 'role_edit', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'core', NULL) ON CONFLICT (id) DO NOTHING;

-- 28/04/2026
DO $$
DECLARE
	rec record;
	v_new_id integer;
	v_exit_id integer;
	v_conneccat_id varchar;
	v_connec_epa text;
	v_has_exit boolean;
	v_exit_is_arc boolean;
BEGIN
  IF (SELECT COUNT(*) FROM _samplepoint_) > 0 THEN
    RAISE NOTICE 'Samplepoints found, inserting new connecs...';
    INSERT INTO cat_feature (id, feature_class, feature_type, parent_layer, child_layer, active) VALUES ('SAMPLEPOINT', 'SAMPLEPOINT','CONNEC', 've_connec', 've_connec_samplepoint', true) ON CONFLICT (id) DO NOTHING;

    INSERT INTO cat_connec (id,connec_type,matcat_id,pnom,dnom,dint,active)
	  VALUES ('UPDATE_SAMPLEPOINT_490','SAMPLEPOINT','PVC','16','25',25.00000,true) ON CONFLICT (id) DO NOTHING;

    v_conneccat_id := 'UPDATE_SAMPLEPOINT_490';
    v_connec_epa := 'JUNCTION';

    FOR rec IN
      SELECT *
      FROM _samplepoint_ sp
      ORDER BY sp.sample_id
    LOOP
      v_new_id := NULL;
      v_exit_id := CASE WHEN rec.feature_id ~ '^[0-9]+$' THEN rec.feature_id::integer ELSE NULL END;

      INSERT INTO connec (
        code, top_elev, depth, conneccat_id, epa_type, state, state_type,
        expl_id, muni_id, sector_id, dma_id, presszone_id, district_id,
        streetaxis_id, postcode, postnumber, postcomplement,
        streetaxis2_id, postnumber2, postcomplement2,
        workcat_id, workcat_id_end, builtdate, enddate,
        verified, rotation, the_geom
      ) VALUES (
        rec.code, NULL, NULL, v_conneccat_id, v_connec_epa, rec.state, 2,
        rec.expl_id, rec.muni_id, COALESCE(rec.sector_id, 0), rec.dma_id, rec.presszone_id, rec.district_id,
        rec.streetaxis_id, rec.postcode, rec.postnumber, rec.postcomplement,
        rec.streetaxis2_id, rec.postnumber2, rec.postcomplement2,
        rec.workcat_id, rec.workcat_id_end, rec.builtdate, rec.enddate,
        rec.verified, rec.rotation, rec.the_geom
      )
      RETURNING connec_id INTO v_new_id;

      INSERT INTO man_samplepoint (connec_id, lab_code, place_name, cabinet)
      VALUES (v_new_id, rec.lab_code, rec.place_name, rec.cabinet);

      v_has_exit := v_exit_id IS NOT NULL AND (
        EXISTS (SELECT 1 FROM arc a WHERE a.arc_id = v_exit_id)
        OR EXISTS (SELECT 1 FROM node n WHERE n.node_id = v_exit_id)
        OR EXISTS (SELECT 1 FROM connec c WHERE c.connec_id = v_exit_id)
      );
      IF v_has_exit THEN
        v_exit_is_arc := EXISTS (SELECT 1 FROM arc a WHERE a.arc_id = v_exit_id);

        IF v_exit_is_arc IS FALSE THEN
          -- If exit_id refers to a node, find an arc that connects to this node
          SELECT arc_id INTO v_exit_id
          FROM arc
          WHERE node_1 = v_exit_id OR node_2 = v_exit_id
          LIMIT 1;

          v_exit_is_arc := v_exit_id IS NOT NULL;
        END IF;

        IF v_exit_is_arc THEN
          PERFORM gw_fct_setlinktonetwork(
            json_build_object(
              'client', json_build_object('device', 4, 'infoType', 1, 'lang', 'ES'),
              'feature', json_build_object('id', to_json(ARRAY[v_new_id::text])),
              'data', json_build_object(
                'feature_type', 'CONNEC',
                'forcedArcs', to_json(ARRAY[v_exit_id::text])
              )
            )
          );
        END IF;
      END IF;
    END LOOP;

  ELSE
    RAISE NOTICE 'No samplepoints found, skipping...';
  END IF;
END $$;

-- 08/05/2026
UPDATE config_param_system
SET value = jsonb_set(
    value::jsonb,
    '{sys_fct_tablename}',
    '"ve_gully"'
)
WHERE parameter = 'basic_search_v2_tab_network_gully';

-- 12/05/2026
UPDATE config_toolbox
	SET inputparams='[
  {
    "widgetname": "graphClass",
    "label": "Graph class:",
    "widgettype": "combo",
    "datatype": "text",
    "tooltip": "Graphanalytics method used",
    "layoutname": "grl_option_parameters",
    "layoutorder": 1,
    "comboIds": [
      "MACROSECTOR",
      "MACROOMZONE"
    ],
    "comboNames": [
      "MACROSECTOR",
      "MACROOMZONE"
    ],
    "selectedId": null
  },
  {
    "widgetname": "exploitation",
    "label": "Exploitation:",
    "widgettype": "combo",
    "datatype": "text",
    "tooltip": "Choose exploitation to work with",
    "layoutname": "grl_option_parameters",
    "layoutorder": 2,
    "dvQueryText": "SELECT id, idval FROM ( SELECT -901 AS id, ''User selected expl'' AS idval, ''a'' AS sort_order UNION SELECT -902 AS id, ''All exploitations'' AS idval, ''b'' AS sort_order UNION SELECT expl_id AS id, name AS idval, ''c'' AS sort_order FROM exploitation WHERE active IS NOT FALSE ) a ORDER BY sort_order ASC, idval ASC",
    "selectedId": null
  },
  {
    "widgetname": "commitChanges",
    "label": "Commit changes:",
    "widgettype": "check",
    "datatype": "boolean",
    "tooltip": "If True, changes will be applied to DB. If False, algorithm results will be saved in a temporal layer",
    "layoutname": "grl_option_parameters",
    "layoutorder": 8,
    "value": null
  },
  {
    "label": "Mapzone constructor method:",
    "comboIds": [
      0,
      1,
      2,
      3,
      4
    ],
    "datatype": "integer",
    "comboNames": [
      "NONE",
      "CONCAVE POLYGON",
      "PIPE BUFFER",
      "PLOT & PIPE BUFFER",
      "LINK & PIPE BUFFER"
    ],
    "layoutname": "grl_option_parameters",
    "selectedId": null,
    "widgetname": "updateMapZone",
    "widgettype": "combo",
    "layoutorder": 9
  },
  {
    "label": "Pipe buffer",
    "value": null,
    "tooltip": "Buffer from arcs to create mapzone geometry using [PIPE BUFFER] options. Normal values maybe between 3-20 mts.",
    "datatype": "float",
    "layoutname": "grl_option_parameters",
    "widgetname": "geomParamUpdate",
    "widgettype": "text",
    "isMandatory": false,
    "layoutorder": 10,
    "placeholder": "5-30"
  }
]'::json
	WHERE id=3482;

UPDATE config_toolbox
SET "inputparams"='[{"label": "Graph class:", "tooltip": "Graphanalytics method used", "comboIds": ["DWFZONE", "SECTOR", "DMA"], "datatype": "text", "comboNames": ["Drainage area (DRAINZONE + DWFZONE)", "SECTOR", "DMA"], "layoutname": "grl_option_parameters", "selectedId": null, "widgetname": "graphClass", "widgettype": "combo", "layoutorder": 1}, {"label": "Exploitation:", "tooltip": "Choose exploitation to work with", "datatype": "text", "layoutname": "grl_option_parameters", "selectedId": null, "widgetname": "exploitation", "widgettype": "combo", "dvQueryText": "SELECT id, idval FROM ( SELECT -901 AS id, ''User selected expl'' AS idval, ''a'' AS sort_order UNION SELECT -902 AS id, ''All exploitations'' AS idval, ''b'' AS sort_order UNION SELECT expl_id AS id, name AS idval, ''c'' AS sort_order FROM exploitation WHERE active IS NOT FALSE AND expl_id > 0 ) a ORDER BY sort_order ASC, idval ASC", "layoutorder": 2}, {"label": "Force open arcs: (*)", "value": null, "tooltip": "Optative arc id(s) to temporary open closed arc(s) in order to force algorithm to continue there", "datatype": "text", "layoutname": "grl_option_parameters", "widgetname": "forceOpen", "widgettype": "linetext", "isMandatory": false, "layoutorder": 5, "placeholder": "1015,2231,3123"}, {"label": "Force closed arcs: (*)", "value": null, "tooltip": "Optative arc id(s) to temporary close open arc(s) to force algorithm to stop there", "datatype": "text", "layoutname": "grl_option_parameters", "widgetname": "forceClosed", "widgettype": "text", "isMandatory": false, "layoutorder": 6, "placeholder": "1015,2231,3123"}, {"label": "Use selected psectors:", "value": null, "tooltip": "If true, use selected psectors. If false ignore selected psectors and only works with on-service network", "datatype": "boolean", "layoutname": "grl_option_parameters", "widgetname": "usePlanPsector", "widgettype": "check", "layoutorder": 7}, {"label": "Commit changes:", "value": null, "tooltip": "If true, changes will be applied to DB. If false, algorithm results will be saved in anl tables", "datatype": "boolean", "layoutname": "grl_option_parameters", "widgetname": "commitChanges", "widgettype": "check", "layoutorder": 8}, {"label": "Mapzone constructor method:", "comboIds": [0, 1, 2, 6], "datatype": "integer", "comboNames": ["NONE", "CONCAVE POLYGON", "PIPE BUFFER", "EPA SUBCATCH"], "layoutname": "grl_option_parameters", "selectedId": null, "widgetname": "updateMapZone", "widgettype": "combo", "layoutorder": 10}, {"label": "Pipe buffer", "value": null, "tooltip": "Buffer from arcs to create mapzone geometry using [PIPE BUFFER] options. Normal values maybe between 3-20 mts.", "datatype": "float", "layoutname": "grl_option_parameters", "widgetname": "geomParamUpdate", "widgettype": "text", "isMandatory": false, "layoutorder": 11, "placeholder": "5-30"}, {"label": "Mapzones from zero:", "value": null, "tooltip": "If true, mapzones are calculated automatically from zero", "datatype": "boolean", "layoutname": "grl_option_parameters", "widgetname": "fromZero", "widgettype": "check", "layoutorder": 12}]'::json
WHERE id = 2768;


-- 13/05/2026
UPDATE sys_style
	SET stylevalue='<!DOCTYPE qgis PUBLIC ''http://mrcc.com/qgis.dtd'' ''SYSTEM''>
<qgis styleCategories="Symbology" version="3.40.9-Bratislava">
  <renderer-v2 symbollevels="0" enableorderby="0" type="RuleRenderer" referencescale="-1" forceraster="0">
    <rules key="{0636f35c-7cdb-4ac1-935d-1cf79c89bfa5}">
      <rule symbol="0" label="FLUID TYPE" key="{ecd5686e-b0b0-4a8a-867a-3e881ff055ed}">
        <rule filter="&quot;fluid_type&quot; = ''0''" symbol="1" label="NOT INFORMED" key="{40e8c9c5-e496-4f35-8c10-e31f6d62aba8}"/>
        <rule filter="&quot;fluid_type&quot; = ''1''" symbol="2" label="STORMWATER" key="{4a15a529-2726-4994-8c68-89318c76da72}"/>
        <rule filter="&quot;fluid_type&quot; = ''2''" symbol="3" label="COMBINED DILUTED" key="{35abe4e2-8068-4788-88ad-ad882466bca2}"/>
        <rule filter="&quot;fluid_type&quot; = ''3''" symbol="4" label="SEWAGE" key="{a9358e41-776d-4a35-a01f-d1239b85409f}"/>
        <rule filter="&quot;fluid_type&quot; = ''4''" symbol="5" label="COMBINED" key="{6932aaa4-244a-48eb-89c8-0eb1ff750952}"/>
      </rule>
      <rule filter="initoverflowpath IS FALSE" symbol="6" label="Initoverflowpath FALSE" key="{997a52d5-68d3-4988-8274-c9a9ad97ae73}"/>
      <rule filter="initoverflowpath IS TRUE" symbol="7" label="Initoverflowpath TRUE" key="{53702b46-77ae-48dc-87cb-adc8d9b4d459}"/>
    </rules>
    <symbols>
      <symbol force_rhr="0" frame_rate="10" name="0" alpha="1" is_animated="0" type="line" clip_to_extent="1">
        <data_defined_properties>
          <Option type="Map">
            <Option name="name" value="" type="QString"/>
            <Option name="properties"/>
            <Option name="type" value="collection" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer pass="0" id="{82d77555-fd1a-4c4b-9dfb-6cf4f89043ea}" locked="0" enabled="1" class="SimpleLine">
          <Option type="Map">
            <Option name="align_dash_pattern" value="0" type="QString"/>
            <Option name="capstyle" value="square" type="QString"/>
            <Option name="customdash" value="5;2" type="QString"/>
            <Option name="customdash_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="customdash_unit" value="MM" type="QString"/>
            <Option name="dash_pattern_offset" value="0" type="QString"/>
            <Option name="dash_pattern_offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="dash_pattern_offset_unit" value="MM" type="QString"/>
            <Option name="draw_inside_polygon" value="0" type="QString"/>
            <Option name="joinstyle" value="bevel" type="QString"/>
            <Option name="line_color" value="223,0,255,0,hsv:0.8125,1,1,0" type="QString"/>
            <Option name="line_style" value="solid" type="QString"/>
            <Option name="line_width" value="1" type="QString"/>
            <Option name="line_width_unit" value="MM" type="QString"/>
            <Option name="offset" value="0" type="QString"/>
            <Option name="offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="offset_unit" value="MM" type="QString"/>
            <Option name="ring_filter" value="0" type="QString"/>
            <Option name="trim_distance_end" value="0" type="QString"/>
            <Option name="trim_distance_end_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="trim_distance_end_unit" value="MM" type="QString"/>
            <Option name="trim_distance_start" value="0" type="QString"/>
            <Option name="trim_distance_start_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="trim_distance_start_unit" value="MM" type="QString"/>
            <Option name="tweak_dash_pattern_on_corners" value="0" type="QString"/>
            <Option name="use_custom_dash" value="0" type="QString"/>
            <Option name="width_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" frame_rate="10" name="1" alpha="1" is_animated="0" type="line" clip_to_extent="1">
        <data_defined_properties>
          <Option type="Map">
            <Option name="name" value="" type="QString"/>
            <Option name="properties"/>
            <Option name="type" value="collection" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer pass="0" id="{e27969d7-935c-44dd-b635-1762befd319c}" locked="0" enabled="1" class="SimpleLine">
          <Option type="Map">
            <Option name="align_dash_pattern" value="0" type="QString"/>
            <Option name="capstyle" value="square" type="QString"/>
            <Option name="customdash" value="5;2" type="QString"/>
            <Option name="customdash_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="customdash_unit" value="MM" type="QString"/>
            <Option name="dash_pattern_offset" value="0" type="QString"/>
            <Option name="dash_pattern_offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="dash_pattern_offset_unit" value="MM" type="QString"/>
            <Option name="draw_inside_polygon" value="0" type="QString"/>
            <Option name="joinstyle" value="bevel" type="QString"/>
            <Option name="line_color" value="0,236,255,255,rgb:0,0.92549019607843142,1,1" type="QString"/>
            <Option name="line_style" value="solid" type="QString"/>
            <Option name="line_width" value="1.66" type="QString"/>
            <Option name="line_width_unit" value="MM" type="QString"/>
            <Option name="offset" value="0" type="QString"/>
            <Option name="offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="offset_unit" value="MM" type="QString"/>
            <Option name="ring_filter" value="0" type="QString"/>
            <Option name="trim_distance_end" value="0" type="QString"/>
            <Option name="trim_distance_end_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="trim_distance_end_unit" value="MM" type="QString"/>
            <Option name="trim_distance_start" value="0" type="QString"/>
            <Option name="trim_distance_start_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="trim_distance_start_unit" value="MM" type="QString"/>
            <Option name="tweak_dash_pattern_on_corners" value="0" type="QString"/>
            <Option name="use_custom_dash" value="0" type="QString"/>
            <Option name="width_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" frame_rate="10" name="2" alpha="1" is_animated="0" type="line" clip_to_extent="1">
        <data_defined_properties>
          <Option type="Map">
            <Option name="name" value="" type="QString"/>
            <Option name="properties"/>
            <Option name="type" value="collection" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer pass="0" id="{f5733214-6984-4124-9c69-b801dad5db3d}" locked="0" enabled="1" class="SimpleLine">
          <Option type="Map">
            <Option name="align_dash_pattern" value="0" type="QString"/>
            <Option name="capstyle" value="square" type="QString"/>
            <Option name="customdash" value="5;2" type="QString"/>
            <Option name="customdash_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="customdash_unit" value="MM" type="QString"/>
            <Option name="dash_pattern_offset" value="0" type="QString"/>
            <Option name="dash_pattern_offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="dash_pattern_offset_unit" value="MM" type="QString"/>
            <Option name="draw_inside_polygon" value="0" type="QString"/>
            <Option name="joinstyle" value="bevel" type="QString"/>
            <Option name="line_color" value="204,163,0,255,rgb:0.80000000000000004,0.63921568627450975,0,1" type="QString"/>
            <Option name="line_style" value="solid" type="QString"/>
            <Option name="line_width" value="1.66" type="QString"/>
            <Option name="line_width_unit" value="MM" type="QString"/>
            <Option name="offset" value="0" type="QString"/>
            <Option name="offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="offset_unit" value="MM" type="QString"/>
            <Option name="ring_filter" value="0" type="QString"/>
            <Option name="trim_distance_end" value="0" type="QString"/>
            <Option name="trim_distance_end_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="trim_distance_end_unit" value="MM" type="QString"/>
            <Option name="trim_distance_start" value="0" type="QString"/>
            <Option name="trim_distance_start_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="trim_distance_start_unit" value="MM" type="QString"/>
            <Option name="tweak_dash_pattern_on_corners" value="0" type="QString"/>
            <Option name="use_custom_dash" value="0" type="QString"/>
            <Option name="width_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" frame_rate="10" name="3" alpha="1" is_animated="0" type="line" clip_to_extent="1">
        <data_defined_properties>
          <Option type="Map">
            <Option name="name" value="" type="QString"/>
            <Option name="properties"/>
            <Option name="type" value="collection" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer pass="0" id="{c48c11c7-7bb9-4b99-8b87-f1ba495dbaca}" locked="0" enabled="1" class="SimpleLine">
          <Option type="Map">
            <Option name="align_dash_pattern" value="0" type="QString"/>
            <Option name="capstyle" value="square" type="QString"/>
            <Option name="customdash" value="5;2" type="QString"/>
            <Option name="customdash_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="customdash_unit" value="MM" type="QString"/>
            <Option name="dash_pattern_offset" value="0" type="QString"/>
            <Option name="dash_pattern_offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="dash_pattern_offset_unit" value="MM" type="QString"/>
            <Option name="draw_inside_polygon" value="0" type="QString"/>
            <Option name="joinstyle" value="bevel" type="QString"/>
            <Option name="line_color" value="255,0,0,255,rgb:1,0,0,1" type="QString"/>
            <Option name="line_style" value="solid" type="QString"/>
            <Option name="line_width" value="1.66" type="QString"/>
            <Option name="line_width_unit" value="MM" type="QString"/>
            <Option name="offset" value="0" type="QString"/>
            <Option name="offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="offset_unit" value="MM" type="QString"/>
            <Option name="ring_filter" value="0" type="QString"/>
            <Option name="trim_distance_end" value="0" type="QString"/>
            <Option name="trim_distance_end_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="trim_distance_end_unit" value="MM" type="QString"/>
            <Option name="trim_distance_start" value="0" type="QString"/>
            <Option name="trim_distance_start_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="trim_distance_start_unit" value="MM" type="QString"/>
            <Option name="tweak_dash_pattern_on_corners" value="0" type="QString"/>
            <Option name="use_custom_dash" value="0" type="QString"/>
            <Option name="width_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" frame_rate="10" name="4" alpha="1" is_animated="0" type="line" clip_to_extent="1">
        <data_defined_properties>
          <Option type="Map">
            <Option name="name" value="" type="QString"/>
            <Option name="properties"/>
            <Option name="type" value="collection" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer pass="0" id="{1faa0c62-4b21-408e-8118-b4d46d1e1f83}" locked="0" enabled="1" class="SimpleLine">
          <Option type="Map">
            <Option name="align_dash_pattern" value="0" type="QString"/>
            <Option name="capstyle" value="square" type="QString"/>
            <Option name="customdash" value="5;2" type="QString"/>
            <Option name="customdash_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="customdash_unit" value="MM" type="QString"/>
            <Option name="dash_pattern_offset" value="0" type="QString"/>
            <Option name="dash_pattern_offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="dash_pattern_offset_unit" value="MM" type="QString"/>
            <Option name="draw_inside_polygon" value="0" type="QString"/>
            <Option name="joinstyle" value="bevel" type="QString"/>
            <Option name="line_color" value="255,0,242,255,rgb:1,0,0.94901960784313721,1" type="QString"/>
            <Option name="line_style" value="solid" type="QString"/>
            <Option name="line_width" value="1.66" type="QString"/>
            <Option name="line_width_unit" value="MM" type="QString"/>
            <Option name="offset" value="0" type="QString"/>
            <Option name="offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="offset_unit" value="MM" type="QString"/>
            <Option name="ring_filter" value="0" type="QString"/>
            <Option name="trim_distance_end" value="0" type="QString"/>
            <Option name="trim_distance_end_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="trim_distance_end_unit" value="MM" type="QString"/>
            <Option name="trim_distance_start" value="0" type="QString"/>
            <Option name="trim_distance_start_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="trim_distance_start_unit" value="MM" type="QString"/>
            <Option name="tweak_dash_pattern_on_corners" value="0" type="QString"/>
            <Option name="use_custom_dash" value="0" type="QString"/>
            <Option name="width_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" frame_rate="10" name="5" alpha="1" is_animated="0" type="line" clip_to_extent="1">
        <data_defined_properties>
          <Option type="Map">
            <Option name="name" value="" type="QString"/>
            <Option name="properties"/>
            <Option name="type" value="collection" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer pass="0" id="{dcfa2132-2ed5-4aef-8162-caa7823b95bd}" locked="0" enabled="1" class="SimpleLine">
          <Option type="Map">
            <Option name="align_dash_pattern" value="0" type="QString"/>
            <Option name="capstyle" value="square" type="QString"/>
            <Option name="customdash" value="5;2" type="QString"/>
            <Option name="customdash_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="customdash_unit" value="MM" type="QString"/>
            <Option name="dash_pattern_offset" value="0" type="QString"/>
            <Option name="dash_pattern_offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="dash_pattern_offset_unit" value="MM" type="QString"/>
            <Option name="draw_inside_polygon" value="0" type="QString"/>
            <Option name="joinstyle" value="bevel" type="QString"/>
            <Option name="line_color" value="0,255,76,255,rgb:0,1,0.29803921568627451,1" type="QString"/>
            <Option name="line_style" value="solid" type="QString"/>
            <Option name="line_width" value="1.66" type="QString"/>
            <Option name="line_width_unit" value="MM" type="QString"/>
            <Option name="offset" value="0" type="QString"/>
            <Option name="offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="offset_unit" value="MM" type="QString"/>
            <Option name="ring_filter" value="0" type="QString"/>
            <Option name="trim_distance_end" value="0" type="QString"/>
            <Option name="trim_distance_end_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="trim_distance_end_unit" value="MM" type="QString"/>
            <Option name="trim_distance_start" value="0" type="QString"/>
            <Option name="trim_distance_start_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="trim_distance_start_unit" value="MM" type="QString"/>
            <Option name="tweak_dash_pattern_on_corners" value="0" type="QString"/>
            <Option name="use_custom_dash" value="0" type="QString"/>
            <Option name="width_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" frame_rate="10" name="6" alpha="1" is_animated="0" type="line" clip_to_extent="1">
        <data_defined_properties>
          <Option type="Map">
            <Option name="name" value="" type="QString"/>
            <Option name="properties"/>
            <Option name="type" value="collection" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer pass="0" id="{22a8834d-18a7-497b-92ee-d4d461063da0}" locked="0" enabled="1" class="MarkerLine">
          <Option type="Map">
            <Option name="average_angle_length" value="4" type="QString"/>
            <Option name="average_angle_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="average_angle_unit" value="MM" type="QString"/>
            <Option name="interval" value="3" type="QString"/>
            <Option name="interval_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="interval_unit" value="MM" type="QString"/>
            <Option name="offset" value="0" type="QString"/>
            <Option name="offset_along_line" value="0" type="QString"/>
            <Option name="offset_along_line_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="offset_along_line_unit" value="MM" type="QString"/>
            <Option name="offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="offset_unit" value="MM" type="QString"/>
            <Option name="place_on_every_part" value="true" type="bool"/>
            <Option name="placements" value="Interval" type="QString"/>
            <Option name="ring_filter" value="0" type="QString"/>
            <Option name="rotate" value="1" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
          <symbol force_rhr="0" frame_rate="10" name="@6@0" alpha="1" is_animated="0" type="marker" clip_to_extent="1">
            <data_defined_properties>
              <Option type="Map">
                <Option name="name" value="" type="QString"/>
                <Option name="properties"/>
                <Option name="type" value="collection" type="QString"/>
              </Option>
            </data_defined_properties>
            <layer pass="0" id="{6d54d628-e447-4f9b-aa18-854b2fc7a132}" locked="0" enabled="1" class="SimpleMarker">
              <Option type="Map">
                <Option name="angle" value="0" type="QString"/>
                <Option name="cap_style" value="square" type="QString"/>
                <Option name="color" value="0,0,0,255,hsv:0.63749999999999996,0.5077744716563668,0,1" type="QString"/>
                <Option name="horizontal_anchor_point" value="1" type="QString"/>
                <Option name="joinstyle" value="bevel" type="QString"/>
                <Option name="name" value="circle" type="QString"/>
                <Option name="offset" value="0,0" type="QString"/>
                <Option name="offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
                <Option name="offset_unit" value="MM" type="QString"/>
                <Option name="outline_color" value="35,35,35,255,rgb:0.13725490196078433,0.13725490196078433,0.13725490196078433,1" type="QString"/>
                <Option name="outline_style" value="solid" type="QString"/>
                <Option name="outline_width" value="0" type="QString"/>
                <Option name="outline_width_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
                <Option name="outline_width_unit" value="MM" type="QString"/>
                <Option name="scale_method" value="diameter" type="QString"/>
                <Option name="size" value="1.5" type="QString"/>
                <Option name="size_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
                <Option name="size_unit" value="MM" type="QString"/>
                <Option name="vertical_anchor_point" value="1" type="QString"/>
              </Option>
              <data_defined_properties>
                <Option type="Map">
                  <Option name="name" value="" type="QString"/>
                  <Option name="properties"/>
                  <Option name="type" value="collection" type="QString"/>
                </Option>
              </data_defined_properties>
            </layer>
          </symbol>
        </layer>
      </symbol>
      <symbol force_rhr="0" frame_rate="10" name="7" alpha="1" is_animated="0" type="line" clip_to_extent="1">
        <data_defined_properties>
          <Option type="Map">
            <Option name="name" value="" type="QString"/>
            <Option name="properties"/>
            <Option name="type" value="collection" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer pass="0" id="{3d948eb9-9960-4238-9138-1757f13eaeee}" locked="0" enabled="1" class="MarkerLine">
          <Option type="Map">
            <Option name="average_angle_length" value="4" type="QString"/>
            <Option name="average_angle_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="average_angle_unit" value="MM" type="QString"/>
            <Option name="interval" value="3" type="QString"/>
            <Option name="interval_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="interval_unit" value="MM" type="QString"/>
            <Option name="offset" value="0" type="QString"/>
            <Option name="offset_along_line" value="0" type="QString"/>
            <Option name="offset_along_line_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="offset_along_line_unit" value="MM" type="QString"/>
            <Option name="offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="offset_unit" value="MM" type="QString"/>
            <Option name="place_on_every_part" value="true" type="bool"/>
            <Option name="placements" value="Interval" type="QString"/>
            <Option name="ring_filter" value="0" type="QString"/>
            <Option name="rotate" value="1" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
          <symbol force_rhr="0" frame_rate="10" name="@7@0" alpha="1" is_animated="0" type="marker" clip_to_extent="1">
            <data_defined_properties>
              <Option type="Map">
                <Option name="name" value="" type="QString"/>
                <Option name="properties"/>
                <Option name="type" value="collection" type="QString"/>
              </Option>
            </data_defined_properties>
            <layer pass="0" id="{2675b728-5ff3-49a7-9855-100d997df1fc}" locked="0" enabled="1" class="SimpleMarker">
              <Option type="Map">
                <Option name="angle" value="0" type="QString"/>
                <Option name="cap_style" value="square" type="QString"/>
                <Option name="color" value="255,255,255,255,hsv:0,0,1,1" type="QString"/>
                <Option name="horizontal_anchor_point" value="1" type="QString"/>
                <Option name="joinstyle" value="bevel" type="QString"/>
                <Option name="name" value="circle" type="QString"/>
                <Option name="offset" value="0,0" type="QString"/>
                <Option name="offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
                <Option name="offset_unit" value="MM" type="QString"/>
                <Option name="outline_color" value="35,35,35,255,rgb:0.13725490196078433,0.13725490196078433,0.13725490196078433,1" type="QString"/>
                <Option name="outline_style" value="solid" type="QString"/>
                <Option name="outline_width" value="0" type="QString"/>
                <Option name="outline_width_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
                <Option name="outline_width_unit" value="MM" type="QString"/>
                <Option name="scale_method" value="diameter" type="QString"/>
                <Option name="size" value="1.5" type="QString"/>
                <Option name="size_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
                <Option name="size_unit" value="MM" type="QString"/>
                <Option name="vertical_anchor_point" value="1" type="QString"/>
              </Option>
              <data_defined_properties>
                <Option type="Map">
                  <Option name="name" value="" type="QString"/>
                  <Option name="properties"/>
                  <Option name="type" value="collection" type="QString"/>
                </Option>
              </data_defined_properties>
            </layer>
          </symbol>
        </layer>
      </symbol>
    </symbols>
    <data-defined-properties>
      <Option type="Map">
        <Option name="name" value="" type="QString"/>
        <Option name="properties"/>
        <Option name="type" value="collection" type="QString"/>
      </Option>
    </data-defined-properties>
  </renderer-v2>
  <selection mode="Default">
    <selectionColor invalid="1"/>
    <selectionSymbol>
      <symbol force_rhr="0" frame_rate="10" name="" alpha="1" is_animated="0" type="line" clip_to_extent="1">
        <data_defined_properties>
          <Option type="Map">
            <Option name="name" value="" type="QString"/>
            <Option name="properties"/>
            <Option name="type" value="collection" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer pass="0" id="{e56f016d-a2d7-4934-8012-09784c514d01}" locked="0" enabled="1" class="SimpleLine">
          <Option type="Map">
            <Option name="align_dash_pattern" value="0" type="QString"/>
            <Option name="capstyle" value="square" type="QString"/>
            <Option name="customdash" value="5;2" type="QString"/>
            <Option name="customdash_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="customdash_unit" value="MM" type="QString"/>
            <Option name="dash_pattern_offset" value="0" type="QString"/>
            <Option name="dash_pattern_offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="dash_pattern_offset_unit" value="MM" type="QString"/>
            <Option name="draw_inside_polygon" value="0" type="QString"/>
            <Option name="joinstyle" value="bevel" type="QString"/>
            <Option name="line_color" value="35,35,35,255,rgb:0.13725490196078433,0.13725490196078433,0.13725490196078433,1" type="QString"/>
            <Option name="line_style" value="solid" type="QString"/>
            <Option name="line_width" value="0.26" type="QString"/>
            <Option name="line_width_unit" value="MM" type="QString"/>
            <Option name="offset" value="0" type="QString"/>
            <Option name="offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="offset_unit" value="MM" type="QString"/>
            <Option name="ring_filter" value="0" type="QString"/>
            <Option name="trim_distance_end" value="0" type="QString"/>
            <Option name="trim_distance_end_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="trim_distance_end_unit" value="MM" type="QString"/>
            <Option name="trim_distance_start" value="0" type="QString"/>
            <Option name="trim_distance_start_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="trim_distance_start_unit" value="MM" type="QString"/>
            <Option name="tweak_dash_pattern_on_corners" value="0" type="QString"/>
            <Option name="use_custom_dash" value="0" type="QString"/>
            <Option name="width_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </selectionSymbol>
  </selection>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerGeometryType>1</layerGeometryType>
</qgis>
'
	WHERE layername='Fluid Type Lines' AND styleconfig_id=101;
