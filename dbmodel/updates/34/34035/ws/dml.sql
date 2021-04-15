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