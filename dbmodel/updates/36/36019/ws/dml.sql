/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;


UPDATE config_form_fields SET iseditable = true where columnname ='to_arc';


update config_form_fields set hidden = false where columnname = 'macrodma_id' and formname in ('v_edit_dma');
update config_form_fields 
set hidden = false, columnname = 'macrodma', dv_querytext  = 'SELECT name as id, name as idval FROM macrodma WHERE macrodma_id IS NOT NULL', label= 'macrodma_id' 
where columnname = 'macrodma_id' and formname in ('v_ui_dma');

update config_form_fields set hidden = false where columnname = 'macrodqa_id' and formname in ('v_edit_dqa');
update config_form_fields 
set hidden = false, columnname = 'macrodqa', dv_querytext  = 'SELECT name as id, name as idval FROM macrodqa WHERE macrodqa_id IS NOT NULL', label= 'macrodqa_id' 
where columnname = 'macrodqa_id' and formname in ('v_ui_dqa');

update config_form_fields set hidden = false where columnname = 'macrosector_id' and formname in ('v_edit_sector');
update config_form_fields 
set hidden = false, columnname = 'macrosector', dv_querytext  = 'SELECT name as id, name as idval FROM macrosector WHERE macrosector_id IS NOT NULL', label= 'macrosector_id' 
where columnname = 'macrosector_id' and formname in ('v_ui_sector');

update config_toolbox set inputparams =
'[
{"widgetname":"exploitation", "label":"Exploitation:","widgettype":"combo","datatype":"text", "isMandatory":true, "tooltip":"Dscenario type", "dvQueryText":"WITH aux AS (SELECT ''-9'' as id, ''ALL'' as idval, 0 AS rowid UNION SELECT expl_id::text as id, name as idval, row_number() over()+1 AS  rowid FROM exploitation where expl_id>0) SELECT id, idval FROM aux ORDER BY rowid ASC", "layoutname":"grl_option_parameters","layoutorder":1, "value":""},
{"widgetname":"method", "label":"Method:","widgettype":"combo","datatype":"text","isMandatory":true,"tooltip":"Water balance method", "dvQueryText":"SELECT id, idval FROM om_typevalue WHERE typevalue = ''waterbalance_method''", "layoutname":"grl_option_parameters","layoutorder":2, "value":""},
{"widgetname":"period","label": "    [if PERIOD_ID] Period:","widgettype": "combo","datatype": "text","layoutname": "grl_option_parameters","layoutorder": 4,"dvQueryText":"SELECT id, code as idval FROM ext_cat_period ORDER BY id desc","selectedId": ""},
{"widgetname":"initDate", "label":"    [if DATE INTERVAL] Period (init date):","widgettype":"datetime","datatype":"text", "isMandatory":true, "tooltip":"Start date", "layoutname":"grl_option_parameters","layoutorder":5, "value":"1111-12-12"},
{"widgetname":"endDate", "label":"    [if DATE INTERVAL] Period (end date):","widgettype":"datetime","datatype":"text", "isMandatory":true, "tooltip":"End date", "layoutname":"grl_option_parameters","layoutorder":6, "value":"9999-12-12"},
{"widgetname":"executeGraphDma", "label":"Execute DMA:","widgettype":"check","datatype":"boolean","isMandatory":true,"tooltip":"Execute DMA","layoutname":"grl_option_parameters","layoutorder":7, "value":""}
]'
where id = 3142;

update om_typevalue set typevalue = 'waterbalance_method_' WHERE typevalue = 'waterbalance_method' and id = 'DCW';
