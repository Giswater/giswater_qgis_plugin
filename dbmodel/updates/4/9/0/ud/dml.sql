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

INSERT INTO sys_table (id,descript,sys_role,"source")
VALUES ('dwfzone_graph','Table to manage graph for dwfzone','role_edit','core');

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
