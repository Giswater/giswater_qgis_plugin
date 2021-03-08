/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2021/03/04

INSERT INTO config_param_system (parameter, value,  project_type, datatype,isenabled, descript)
VALUES ('admin_addmapzone', '{"dma":{"idXExpl": "false", "setUpdate":null}, "presszone":{"idXExpl": "false", "setUpdate":null}}', 'ws', 'json', false, 
'Defines if mapzone id depends on expl and if it updates any more inventory fields')
ON CONFLICT (parameter) DO NOTHING;

UPDATE inp_typevalue SET idval = 'PRESSPUMP', id = 'PRESSPUMP' WHERE id = '1' AND typevalue = 'inp_typevalue_pumptype';
UPDATE inp_typevalue SET idval = 'FLOWPUMP', id = 'FLOWPUMP' WHERE id = '2' AND typevalue = 'inp_typevalue_pumptype';

UPDATE inp_pump SET pump_type  ='FLOWPUMP';

INSERT INTO config_form_fields
SELECT formname, formtype, 'pump_type', 20, datatype, widgettype, 'Pump type', null, null, 'By using Pressure pump (PRESSPUMP) double nodarc (PBV + PUMP) will be exported to EPANET. In combination with with pressure constant curve (GP) it is possible to modelate network pressure groups', ismandatory, isparent, iseditable, isautoupdate, 'SELECT id, idval FROM inp_typevalue WHERE typevalue = ''inp_typevalue_pumptype''', true, false, null, null, null, null, null, null, layoutname, null, false
FROM config_form_fields WHERE formname  ='v_edit_inp_pump' and columnname  ='status';