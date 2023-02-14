/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

INSERT INTO config_toolbox (id, alias, functionparams, inputparams, observ, active) VALUES(3198, 'Get address values from closest street number', '{"featureType":["node","connec","gully"]}'::json, 
'[{"widgetname":"catFeature", "label":"Type:","widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layoutorder":1,
"comboIds":["ALL NODES", "ALL CONNECS", "ALL GULLYS", "CHAMBER", "JUNCTION", "MANHOLE", "NETINIT", "OUTFALL", "STORAGE", "VALVE"], 
"comboNames":["ALL NODES", "ALL CONNECS", "ALL GULLYS", "CHAMBER", "JUNCTION", "MANHOLE", "NETINIT", "OUTFALL", "STORAGE", "VALVE"], "selectedId":"ALL NODES"},
{"widgetname":"fieldToUpdate", "label":"Field to update:","widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layoutorder":2,
"comboIds":["postnumber", "postcomplement"], "comboNames":["POSTNUMBER", "POSTCOMPLEMENT"], "selectedId":"postnumber"},
{"widgetname":"searchBuffer", "label":"Search buffer (meters):","widgettype":"text","datatype":"float", "layoutname":"grl_option_parameters","layoutorder":3, "isMandatory":true, "value":"50"},
{"widgetname":"updateValues", "label":"Elements to update:","widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layoutorder":4,
"comboIds":["allValues", "nullStreet", "nullPostnumber", "nullPostcomplement"], "comboNames":["ALL ELEMENTS", "ELEMENTS WITH NULL STREETAXIS", "ELEMENTS WITH NULL POSTNUMBER", "ELEMENTS WITH NULL POSTCOMPLEMENT"], "selectedId":"nullStreet"}]'::json, NULL, true);

INSERT INTO inp_gully SELECT gully_id FROM gully ON CONFLICT DO NOTHING;
INSERT INTO inp_netgully SELECT node_id FROM man_netgully ON CONFLICT DO NOTHING;

UPDATE gully SET epa_type='GULLY' WHERE epa_type IS NULL;
UPDATE node SET epa_type='NETGULLY' WHERE node_id in (SELECT node_id FROM node JOIN cat_feature ON node_type=id AND system_id='NETGULLY');
