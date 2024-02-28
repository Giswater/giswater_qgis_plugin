/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 9/2/2024;
ALTER TABLE inp_typevalue DISABLE TRIGGER gw_trg_typevalue_config_fk;
UPDATE inp_typevalue SET typevalue = '_inp_options_networkmode' WHERE typevalue = 'inp_options_networkmode' and id = '1';
UPDATE inp_typevalue SET idval = 'BASIC NETWORK' WHERE typevalue = 'inp_options_networkmode' and id = '2';
UPDATE inp_typevalue SET idval = 'NETWORK & CONNECS' WHERE typevalue = 'inp_options_networkmode' and id = '4';
ALTER TABLE inp_typevalue ENABLE TRIGGER gw_trg_typevalue_config_fk;

-- 24/2/2024;
DELETE FROM config_form_fields WHERE formname = 've_epa_virtualpump' and columnname = 'price_pattern';

-- 26/02/2024
UPDATE config_form_fields
	SET widgetcontrols='{"saveValue": false, "tableUpsert": "v_edit_inp_dscenario_virtualpump"}'::json, linkedobject='tbl_inp_dscenario_virtualpump', columnname='tbl_inp_virtualpump'
	WHERE formname='ve_epa_virtualpump' AND columnname='tbl_inp_pump';

-- 28/02/2024

DELETE FROM config_form_fields
	WHERE formname='inp_dscenario_connec' AND formtype='form_feature' AND columnname='pjoint_type' AND tabname='tab_none';
DELETE FROM config_form_fields
	WHERE formname='inp_dscenario_connec' AND formtype='form_feature' AND columnname='pjoint_id' AND tabname='tab_none';

UPDATE sys_table
	SET addparam='{"pkey": "dscenario_id, feature_id"}'::json
	WHERE id='inp_dscenario_demand';

UPDATE sys_table 
	SET criticity=NULL, context=NULL, orderby=NULL, alias=NULL 
	WHERE id='v_om_mincut';
UPDATE sys_table 
	SET criticity=2, context='{"level_1":"OM","level_2":"MINCUT"}', orderby=1, alias='Mincut init point', addparam='{"geom": "anl_the_geom"}'::json 
	WHERE id='v_om_mincut_initpoint';
-- Set style for v_om_mincut_initpoint
UPDATE sys_style SET idval = 'v_om_mincut_initpoint' WHERE idval = 'v_om_mincut';

UPDATE config_toolbox SET inputparams='[
{"widgetname":"exploitation", "label":"Exploitation id''s:","widgettype":"text","datatype":"json","layoutname":"grl_option_parameters","layoutorder":1, "placeholder":"1,2", "value":""}, 
{"widgetname":"usePsectors", "label":"Use masterplan psectors:","widgettype":"check","datatype":"boolean","layoutname":"grl_option_parameters","layoutorder":6, "value":"FALSE"}, 
{"widgetname":"updateFeature", "label":"Update feature attributes:","widgettype":"check","datatype":"boolean","layoutname":"grl_option_parameters","layoutorder":7, "value":"FALSE"}, 
{"widgetname":"updateMapZone", "label":"Update mapzone geometry method:","widgettype":"combo","datatype":"integer","layoutname":"grl_option_parameters","layoutorder":8,"comboIds":[0,1,2,3], "comboNames":["NONE", "CONCAVE POLYGON", "PIPE BUFFER", "PLOT & PIPE BUFFER"], "selectedId":"2"}, 
{"widgetname":"geomParamUpdate", "label":"Update parameter:","widgettype":"text","datatype":"float","layoutname":"grl_option_parameters","layoutorder":10, "isMandatory":false, "placeholder":"5-30", "value":""},
{"widgetname":"ignoreBrokenValves", "label":"Ignore Broken Valves:","widgettype":"check","datatype":"boolean","layoutname":"grl_option_parameters","layoutorder":11, "isMandatory":false, "placeholder":"", "value":""}
]'::json WHERE id=2706;
