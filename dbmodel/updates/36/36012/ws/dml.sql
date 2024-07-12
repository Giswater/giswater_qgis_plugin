/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

INSERT INTO sys_function VALUES (3310, 'gw_fct_setpsectorcostremovedpipes', 'ws', 'function', 'json', 'json',
'Function to set cost for removed material on specific psectors', 'role_master', null, 'core')
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_fprocess VALUES (523, 'fprocess to set cost for removed material on psectors','ws',null,'core',FALSE, 'Function process')
ON CONFLICT (fid) DO NOTHING;

DELETE from sys_fprocess WHERE fid = 522;

INSERT INTO config_toolbox VALUES (3310, 'Set cost for removed material on psectors', '{"featureType":[]}',
'[
{"widgetname":"expl", "label":"Exploitation:", "widgettype":"combo", "datatype":"text", "dvQueryText":"SELECT expl_id as id, name as idval FROM v_edit_exploitation", "layoutname":"grl_option_parameters","layoutorder":1, "selectedId":""},
{"widgetname":"material", "label":"Material:", "widgettype":"combo", "datatype":"text", "dvQueryText":"SELECT id, descript as idval FROM cat_mat_node", "layoutname":"grl_option_parameters","layoutorder":2, "selectedId":""},
{"widgetname":"price", "label":"Price:","widgettype":"linetext","datatype":"text", "isMandatory":true, "tooltip":"Code of removal material price", "placeholder":"", "layoutname":"grl_option_parameters","layoutorder":3, "value":""},
{"widgetname":"observ", "label":"Observ:","widgettype":"linetext","datatype":"text", "isMandatory":true, "tooltip":"Descriptive text for removal (it apears on psector_x_other observ)", "placeholder":"", "layoutname":"grl_option_parameters","layoutorder":4, "value":""}
]',
null, TRUE, '{4}');


UPDATE config_form_tabs
	SET orderby=2
	WHERE formname='v_edit_arc' AND tabname='tab_elements';
UPDATE config_form_tabs
	SET orderby=3
	WHERE formname='v_edit_arc' AND tabname='tab_relations';
UPDATE config_form_tabs
	SET orderby=4
	WHERE formname='v_edit_arc' AND tabname='tab_event';
UPDATE config_form_tabs
	SET orderby=5
	WHERE formname='v_edit_arc' AND tabname='tab_documents';
UPDATE config_form_tabs
	SET orderby=6
	WHERE formname='v_edit_arc' AND tabname='tab_plan';

UPDATE config_form_tabs
	SET orderby=3
	WHERE formname='v_edit_connec' AND tabname='tab_hydrometer';
UPDATE config_form_tabs
	SET orderby=4
	WHERE formname='v_edit_connec' AND tabname='tab_hydrometer_val';

UPDATE config_form_tabs
	SET orderby=3
	WHERE formname='v_edit_node' AND tabname='tab_event';
UPDATE config_form_tabs
	SET orderby=4
	WHERE formname='v_edit_node' AND tabname='tab_documents';
UPDATE config_form_tabs
	SET orderby=5
	WHERE formname='v_edit_node' AND tabname='tab_plan';

UPDATE config_form_tabs
	SET orderby=6
	WHERE formname='ve_node_water_connection' AND tabname='tab_hydrometer';
UPDATE config_form_tabs
	SET orderby=7
	WHERE formname='ve_node_water_connection' AND tabname='tab_hydrometer_val';
