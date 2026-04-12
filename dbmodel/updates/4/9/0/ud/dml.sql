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
  {"label": "type:", "value": null, "tooltip": "Process name", "comboIds": ["ALL", "FLOWEXIT"], "datatype": "text", "comboNames": ["ALL", "FLOWEXIT"], "layoutname": "grl_option_parameters", "selectedId": null, "widgetname": "type", "widgettype": "combo", "layoutorder": 1},
  {"label": "node1 (FLOWEXIT):", "value": null, "tooltip": "Choose source node of your path", "datatype": "text", "layoutname": "grl_option_parameters", "selectedId": null, "widgetname": "node1", "widgettype": "text", "layoutorder": 2}, 
  {"label": "node2 (FLOWEXIT):", "value": null, "tooltip": "Choose target node of your path", "datatype": "text", "layoutname": "grl_option_parameters", "selectedId": null, "widgetname": "node2", "widgettype": "text", "layoutorder": 3},
  {"label": "Min Ymax (FLOWEXIT):", "value": null, "tooltip": "Choose minimum ymax value", "datatype": "text", "layoutname": "grl_option_parameters", "selectedId": null, "widgetname": "minYmax", "widgettype": "text", "layoutorder": 4},
  {"label": "Max Ymax (FLOWEXIT):", "value": null, "tooltip": "Choose maximum ynax value", "datatype": "text", "layoutname": "grl_option_parameters", "selectedId": null, "widgetname": "maxYmax", "widgettype": "text", "layoutorder": 5},
  {"label": "Min Slope (FLOWEXIT):", "value": null, "tooltip": "Choose minimum slope", "datatype": "text", "layoutname": "grl_option_parameters", "selectedId": null, "widgetname": "minSlope", "widgettype": "text", "layoutorder": 6}, 
  {"label": "Max Slope (FLOWEXIT):", "value": null, "tooltip": "Choose maximum slope", "datatype": "text", "layoutname": "grl_option_parameters", "selectedId": null, "widgetname": "maxSlope", "widgettype": "text", "layoutorder": 7},
  {"label": "Profile Mode (FLOWEXIT):", "value": null, "tooltip": "Profile mode", "comboIds": ["SMOOTH", "SHALLOW", "DEEP", "CENTERED"], "datatype": "text", "comboNames": ["SMOOTH", "SHALLOW", "DEEP", "CENTERED"], "layoutname": "grl_option_parameters", "selectedId": null, "widgetname": "profileMode", "widgettype": "combo", "layoutorder": 8},
  {"label": "Smooth Factor (SMOOTH):", "value": null, "tooltip": "Choose smoothAlpha", "datatype": "text", "layoutname": "grl_option_parameters", "selectedId": null, "widgetname": "smoothFactor", "widgettype": "text", "layoutorder": 9},
  {"label": "Fix changes:", "value": null, "tooltip": "Fix changes (custom_elev will not be modify later for this tool)", "datatype": "boolean", "layoutname": "grl_option_parameters", "selectedId": null, "widgetname": "fixChanges", "widgettype": "check", "layoutorder": 10}
  ]'::json, 
NULL, true, '{4}');

update sys_function set sys_role = 'role_edit', function_alias = 'Massive node interpolation' ,
descript = 
'PURPOSE
This function calculates node invert elevations using different strategies
depending on the requested calculation type.
SUPPORTED TYPES
1) MASSIVE
Legacy mode. For each node with sys_elev IS NULL, the function tries to
identify upstream and downstream reference nodes with known system elevation
and delegates interpolation to gw_fct_node_interpolate.
2) FLOWEXIT
Advanced profile solver mode. The function:
- computes the shortest path between node1 and node2,
- truncates that corridor at the first downstream node with sys_elev,
- validates the calculation window,
- solves the profile globally using: minYmax, maxYmax, minSlope, maxSlope,
- and assigns elevations according to profileMode.
ELEVATION MODEL
- sys_elev is the authoritative known elevation.
- custom_elev is the calculated elevation written by this function.
- The function only writes custom_elev for nodes where sys_elev IS NULL.
ANCHORS
- The downstream outlet node is always fixed because it must have sys_elev.
- If node1 also has sys_elev, it is treated as an upstream fixed anchor.
- Fixed anchors are never modified.
PROFILE MODES
- DEEP: Selects the deepest feasible solution.
- SHALLOW: Selects the shallowest feasible solution.
- CENTERED: Selects the midpoint between the lower and upper feasible envelopes.
- SMOOTH: Starts from a centered feasible solution and applies internal smoothing iterations while preserving feasibility and fixed anchors.
BUSINESS RULES
- The function only writes custom_elev for nodes where sys_elev IS NULL.
- FLOWEXIT always works inside a controlled corridor: shortest path(node1, node2)
- The effective calculation window ends at the first downstream node in that corridor having sys_elev IS NOT NULL.
- All nodes inside the calculation window must have sys_top_elev. If only one node is missing it, the whole calculation is rejected.
- The resulting profile must satisfy: top_elev - maxYmax <= invert_elev <= top_elev - minYmax, minSlope <= slope <= maxSlope
- If no feasible profile exists, the function returns status = Rejected.'
where id  = 3248;


INSERT INTO sys_table (id, descript, sys_role, "source") VALUES('v_anl_node_massiveinterpolate', 'Massive interpolate for nodes', 'role_basic', 'core') ON CONFLICT DO NOTHING;
INSERT INTO sys_table (id, descript, sys_role, "source") VALUES('v_arc_node_massiveinterpolate', 'Massive interpolate for arcs', 'role_basic', 'core') ON CONFLICT DO NOTHING;
