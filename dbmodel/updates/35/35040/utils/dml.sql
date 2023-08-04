/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME ,public;

UPDATE config_toolbox SET inputparams='[{"widgetname":"catFeature", "label":"Type:","widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layoutorder":1,
"comboIds":["ALL NODES", "ALL CONNECS", "HYDRANT", "JUNCTION", "METER", "PUMP", "TANK", "VALVE", "WJOIN"], 
"comboNames":["ALL NODES", "ALL CONNECS", "HYDRANT", "JUNCTION", "METER", "PUMP", "TANK", "VALVE", "WJOIN"]},
{"widgetname":"fieldToUpdate", "label":"Field to update:","widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layoutorder":2,
"comboIds":["postnumber", "postcomplement"], "comboNames":["POSTNUMBER", "POSTCOMPLEMENT"]},
{"widgetname":"searchBuffer", "label":"Search buffer (meters):","widgettype":"text","datatype":"float", "layoutname":"grl_option_parameters","layoutorder":3, "isMandatory":true, "value":"50"},
{"widgetname":"updateValues", "label":"Elements to update:","widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layoutorder":4,
"comboIds":["allValues", "nullStreet", "nullPostnumber", "nullPostcomplement"], "comboNames":["ALL ELEMENTS", "ELEMENTS WITH NULL STREETAXIS", "ELEMENTS WITH NULL POSTNUMBER", "ELEMENTS WITH NULL POSTCOMPLEMENT"]},
{"widgetname":"insersectPolygonLayer", "label":"Intersect with polygon layer:","widgettype":"combo","datatype":"text", "layoutname":"grl_option_parameters","layoutorder":5,
"comboIds":["NONE", "v_ext_plot"], "comboNames":["NONE", "PLOT"]}]'::json WHERE id=3198;


UPDATE sys_function SET descript='Function to capture automatically closest address from every node/connec.
- Type: choose if you want to update all node/connec or just a specific type of them.
- Field to update: possible fields to update are postnumber(integer) and postcomplement(text). The most usual is postnumber, but if address number is not numeric, then you will need to update postcomplement.
- Search buffer: maximum distance to look for an address from the point.
- Elements to update: if you dont''t want to update all elements, choose to only update the ones where streetaxis_id, postnumber or postcomplement is null.
- Insersect with polygon layer: If selected value is different from NONE, address and number will only be capturated for those elements which intersect with the configured polygonal layer.' WHERE id=3198;
