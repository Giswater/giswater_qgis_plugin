/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 2021/04/15
UPDATE config_form_fields SET dv_querytext = NULL WHERE formname = 'new_dma';
UPDATE config_form_fields SET dv_querytext = 'SELECT macrodma_id as id, name as idval FROM macrodma WHERE macrodma_id IS NOT NULL',hidden = false
WHERE formname = 'new_dma' AND columnname = 'macrodma_id' ;
UPDATE config_form_fields SET dv_querytext = 'SELECT DISTINCT ''DMA'' as id, ''DMA'' as idval FROM exploitation WHERE expl_id IS NOT NULL' 
WHERE formname = 'new_dma' AND columnname = 'mapzoneType';
UPDATE config_form_fields SET dv_querytext = 'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id != 0 AND expl_id IS NOT NULL' 
WHERE formname = 'new_dma' AND columnname = 'expl_id';

-- 2021/04/18
UPDATE config_param_system set standardvalue = 
'{"status":false, "values":[
{"source":{"table":"ve_node_shutoff_valve", "column":"pression_exit"}, "target":{"table":"inp_valve", "column":"pressure"}}]}'
WHERE parameter = 'epa_automatic_man2inp_values';

UPDATE config_param_system set standardvalue = 'True' WHERE parameter = 'admin_raster_dem';

INSERT INTO config_form_fields(formname, formtype, columnname, layoutorder, datatype, widgettype, label, ismandatory, isparent, 
iseditable, isautoupdate, layoutname, hidden)
VALUES ('new_dma','form_catalog','dma_id',2, 'string', 'text', 'Dma id',false, false,true,false,'lyt_data_1',false); 

UPDATE config_form_fields SET layoutorder=3 WHERE formname='new_dma' AND columnname='name';
