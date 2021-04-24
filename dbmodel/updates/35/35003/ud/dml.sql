/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2021/02/27
UPDATE sys_feature_epa_type SET active = true;
UPDATE sys_feature_epa_type SET active = false WHERE id IN ('DIVIDER');

UPDATE config_form_fields SET dv_querytext = 'SELECT id, id as idval FROM sys_feature_epa_type WHERE active 
AND feature_type = ''ARC'''  WHERE columnname = 'epa_type' AND formname like '%_arc%';
UPDATE config_form_fields SET dv_querytext = 'SELECT id, id as idval FROM sys_feature_epa_type WHERE active 
AND feature_type = ''NODE'''  WHERE columnname = 'epa_type' AND formname like '%_node%';

UPDATE cat_feature_node SET epa_default  ='UNDEFINED' WHERE epa_default  ='NOT DEFINED';
UPDATE cat_feature_arc SET epa_default  ='UNDEFINED' WHERE epa_default  ='NOT DEFINED';
UPDATE sys_feature_epa_type SET id  ='UNDEFINED' WHERE id  ='NOT DEFINED';
UPDATE arc SET epa_type ='UNDEFINED' WHERE epa_type  ='NOT DEFINED';
UPDATE node SET epa_type ='UNDEFINED' WHERE epa_type  ='NOT DEFINED';

--2021/04/07
DELETE FROM config_form_fields where formname='inp_flwreg_type';
DELETE FROM sys_table where id='inp_flwreg_type';

UPDATE config_form_tabs SET tabactions = '[{"actionName": "actionEdit", "disabled": false}, 
{"actionName": "actionZoom", "disabled": false}, 
{"actionName": "actionCentered", "disabled": false}, 
{"actionName": "actionZoomOut", "disabled": false}, 
{"actionName": "actionCatalog", "disabled": false}, 
{"actionName": "actionWorkcat", "disabled": false}, 
{"actionName": "actionCopyPaste", "disabled": false}, 
{"actionName": "actionLink", "disabled": false},
{"actionName":"actionGetArcId", "disabled":false},
{"actionName":"actionInterpolate", "disabled":false},
{"actionName": "actionHelp", "disabled": false}]'
WHERE formname ='v_edit_node';


UPDATE config_form_tabs SET tabactions = '[{"actionName":"actionEdit", "disabled":false},
{"actionName":"actionZoom", "disabled":false},
{"actionName":"actionCentered", "disabled":false},
{"actionName":"actionZoomOut", "disabled":false},
{"actionName":"actionCatalog", "disabled":false},
{"actionName":"actionWorkcat", "disabled":false},
{"actionName":"actionCopyPaste", "disabled":false},
{"actionName":"actionSection", "disabled":false},
{"actionName":"actionLink", "disabled":false},
{"actionName":"actionHelp", "disabled":false}]'
WHERE formname ='v_edit_arc';


UPDATE config_form_tabs SET tabactions = '[{"actionName":"actionEdit", "disabled":false},
{"actionName":"actionZoom", "disabled":false},
{"actionName":"actionCentered", "disabled":false},
{"actionName":"actionZoomOut", "disabled":false},
{"actionName":"actionCatalog", "disabled":false},
{"actionName":"actionWorkcat", "disabled":false},
{"actionName":"actionCopyPaste", "disabled":false},
{"actionName":"actionLink", "disabled":false},
{"actionName":"actionHelp", "disabled":false}, 
{"actionName":"actionGetArcId", "disabled":false}]'
WHERE formname ='v_edit_connec';


UPDATE config_form_tabs SET tabactions = '[{"actionName":"actionEdit", "disabled":true},
{"actionName":"actionZoom", "disabled":false},
{"actionName":"actionCentered", "disabled":false},
{"actionName":"actionZoomOut", "disabled":false},
{"actionName":"actionWorkcat", "disabled":false},
{"actionName":"actionCopyPaste", "disabled":false},
{"actionName":"actionLink", "disabled":false},
{"actionName":"actionHelp", "disabled":false}, 
{"actionName":"actionGetArcId", "disabled":false}]'
WHERE formname ='v_edit_gully';

-- 2021/04/24
DELETE FROM sys_table WHERE id = 'inp_controls_importinp';