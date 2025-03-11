/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--7/3/2024
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('edit_mapzones_set_lastupdate', 'false', 'If true, value of lastupdate is updated on node, arc, connec features and set to the date of executing the algorithm.', 'Set lastupdate on mapzone process', NULL, NULL, false, NULL, 'ws', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

--14/3/2024
update config_form_fields set hidden=true where columnname in ('geom3', 'geom4') and formname like '%orifice%';

--20/3/2024
UPDATE config_form_fields SET widgetcontrols = (replace(widgetcontrols::text,'"nullValue":false', '"nullValue":true'))::json 
where formname = 'cat_node' and columnname = 'node_type';
UPDATE config_form_fields SET widgetcontrols = (replace(widgetcontrols::text,'"nullValue":false', '"nullValue":true'))::json 
where formname = 'cat_arc' and columnname = 'arc_type';
UPDATE config_form_fields SET widgetcontrols = (replace(widgetcontrols::text,'"nullValue":false', '"nullValue":true'))::json 
where formname = 'cat_connec' and columnname = 'connec_type';
UPDATE config_form_fields SET widgetcontrols = (replace(widgetcontrols::text,'"nullValue":false', '"nullValue":true'))::json 
where formname = 'cat_grate' and columnname = 'gully_type';

UPDATE config_form_fields SET widgetcontrols = (replace(widgetcontrols::text,'"filterExpression": null', '"filterExpression":"active=true"'))::json 
where formname = 'cat_node' and columnname = 'node_type';
UPDATE config_form_fields SET widgetcontrols = (replace(widgetcontrols::text,'"filterExpression": null', '"filterExpression":"active=true"'))::json 
where formname = 'cat_arc' and columnname = 'arc_type';
UPDATE config_form_fields SET widgetcontrols = (replace(widgetcontrols::text,'"filterExpression": null', '"filterExpression":"active=true"'))::json 
where formname = 'cat_connec' and columnname = 'connec_type';
UPDATE config_form_fields SET widgetcontrols = (replace(widgetcontrols::text,'"filterExpression": null', '"filterExpression":"active=true"'))::json 
where formname = 'cat_grate' and columnname = 'gully_type';


UPDATE config_toolbox set inputparams = 
'[
{"widgetname":"idval", "label":"Name: (*)","widgettype":"linetext","datatype":"text", "isMandatory":true, "tooltip":"Name for dwf scenario (mandatory)", "placeholder":"", "layoutname":"grl_option_parameters","layoutorder":1, "value":""},
{"widgetname":"startdate", "label":"Startdate:","widgettype":"datetime","datatype":"date", "isMandatory":false, "tooltip":"Start date for dwf scenario", "placeholder":"", "layoutname":"grl_option_parameters","layoutorder":2, "value":""},
{"widgetname":"enddate", "label":"Enddate:","widgettype":"datetime","datatype":"date", "isMandatory":false, "tooltip":"End date", "placeholder":"End date for dwf scenario", "layoutname":"grl_option_parameters","layoutorder":3, "value":""},
{"widgetname":"observ", "label":"Observ:","widgettype":"linetext","datatype":"text", "isMandatory":false, "tooltip":"Observations of dwf scenario", "placeholder":"", "layoutname":"grl_option_parameters","layoutorder":4, "value":""},
{"widgetname":"expl", "label":"Exploitation:","widgettype":"combo","datatype":"text", "isMandatory":true, "tooltip":"dwf scenario type", "dvQueryText":"SELECT expl_id AS id, name as idval FROM v_edit_exploitation", "layoutname":"grl_option_parameters","layoutorder":5, "value":""},
{"widgetname":"active", "label":"Active:", "widgettype":"check", "datatype":"boolean", "tooltip":"If true, active" , "layoutname":"grl_option_parameters","layoutorder":6, "value":"true"}
]'
where id = 3292;