/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

INSERT INTO config_toolbox (id, alias, functionparams, inputparams, observ, active) VALUES(3198, 'Get address values from closest street number', '{"featureType":["node","connec","gully"]}'::json, 
'[{"widgetname":"catFeature", "label":"Type:","widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layoutorder":1,
"comboIds":["ALL NODES", "ALL CONNECS", "ALL GULLYS", "CHAMBER", "JUNCTION", "MANHOLE", "NETINIT", "OUTFALL", "STORAGE", "VALVE"], 
"comboNames":["ALL NODES", "ALL CONNECS", "ALL GULLYS", "CHAMBER", "JUNCTION", "MANHOLE", "NETINIT", "OUTFALL", "STORAGE", "VALVE"]},
{"widgetname":"fieldToUpdate", "label":"Field to update:","widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layoutorder":2,
"comboIds":["postnumber", "postcomplement"], "comboNames":["POSTNUMBER", "POSTCOMPLEMENT"]},
{"widgetname":"searchBuffer", "label":"Search buffer (meters):","widgettype":"text","datatype":"float", "layoutname":"grl_option_parameters","layoutorder":3, "isMandatory":true, "value":"50"},
{"widgetname":"updateValues", "label":"Elements to update:","widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layoutorder":4,
"comboIds":["allValues", "nullStreet", "nullPostnumber", "nullPostcomplement"], "comboNames":["ALL ELEMENTS", "ELEMENTS WITH NULL STREETAXIS", "ELEMENTS WITH NULL POSTNUMBER", "ELEMENTS WITH NULL POSTCOMPLEMENT"]}]'::json, NULL, true);

INSERT INTO inp_gully SELECT gully_id FROM gully ON CONFLICT DO NOTHING;
INSERT INTO inp_netgully SELECT node_id FROM man_netgully ON CONFLICT DO NOTHING;

UPDATE gully SET epa_type='GULLY' WHERE epa_type IS NULL;
UPDATE node SET epa_type='NETGULLY' WHERE node_id in (SELECT node_id FROM node JOIN cat_feature ON node_type=id AND system_id='NETGULLY');

INSERT INTO config_param_system(
parameter, value, descript, label, dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, datatype, widgettype, ismandatory, iseditable)
VALUES ('edit_node_automatic_sander', FALSE, 'Calculate sander depth of manhole, chamber and wjump depending on node sys_ymax and arc sys_y1' , 'Automatic sander depth:', null, null, false, null, 'ud',
 false, false, 'boolean', 'check', false, true) ON CONFLICT (parameter) DO NOTHING;

INSERT INTO sys_function(
id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, source)
VALUES (3204, 'gw_fct_calculate_sander', 'ud', 'function', 'json', 'json', 'Function that calculates the depth of sander depending on node sys_ymax and arc sys_y1' , 'role_edit', null, 'core') ON CONFLICT (id) DO NOTHING;