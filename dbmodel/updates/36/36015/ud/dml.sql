/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

DELETE FROM sys_table WHERE id='archived_rpt_inp_pattern_value';

UPDATE sys_table SET context='{"level_1":"EPA","level_2":"HYDROLOGY"}', alias='Dry Weather Flows (DWF)', orderby=5 WHERE id  = 'v_edit_inp_dwf';

UPDATE config_toolbox SET inputparams = '
[
{"widgetname":"copyFrom", "label":"Copy from:", "widgettype":"combo", "datatype":"text", "dvQueryText":"SELECT hydrology_id as id, name as idval FROM cat_hydrology WHERE active IS TRUE", "layoutname":"grl_option_parameters","layoutorder":1, "selectedId":"$userDscenario"},
{"widgetname":"name", "label":"Name: (*)","widgettype":"linetext","datatype":"text", "isMandatory":true, "tooltip":"Name for hydrology scenario (mandatory)", "placeholder":"", "layoutname":"grl_option_parameters","layoutorder":2, "value":""},
{"widgetname":"text", "label":"Text:","widgettype":"linetext","datatype":"text", "isMandatory":false, "tooltip":"Text of hydrology scenario", "placeholder":"", "layoutname":"grl_option_parameters","layoutorder":4, "value":""},
{"widgetname":"expl", "label":"Exploitation:","widgettype":"combo","datatype":"text", "isMandatory":true, "tooltip":"hydrology scenario type", "dvQueryText":"SELECT expl_id AS id, name as idval FROM v_edit_exploitation", "layoutname":"grl_option_parameters","layoutorder":5, "value":""},
{"widgetname":"active", "label":"Active:", "widgettype":"check", "datatype":"boolean", "tooltip":"If true, active" , "layoutname":"grl_option_parameters","layoutorder":6, "value":"true"}
]'
WHERE id = 3294;

UPDATE config_form_fields SET iseditable = true where columnname = 'to_arc';

UPDATE config_form_fields SET iseditable = true where columnname like '%road%';

UPDATE config_form_fields SET iseditable = true where columnname like 'coef_curve';

UPDATE config_form_fields SET hidden = true where columnname in ('geom3', 'geom4') and formname like '%orifice%';

UPDATE sys_param_user SET dv_isnullvalue = true where id = 'inp_options_hydrology_scenario';

INSERT INTO inp_typevalue VALUES ('inp_typevalue_dscenario', 'LIDS', 'LIDS');

UPDATE config_form_fields SET linkedobject='tbl_event_x_gully' WHERE formname='gully' AND formtype='form_feature' AND tabname='tab_event' AND linkedobject = 'tbl_visit_x_gully';

