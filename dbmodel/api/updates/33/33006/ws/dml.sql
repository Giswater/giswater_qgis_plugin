/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--16/10/2019
UPDATE config_api_form_fields SET dv_querytext = 'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id != 0' 
WHERE column_id = 'expl_id' and formtype = 'feature';

UPDATE config_api_form_fields SET dv_querytext ='SELECT dma_id as id, name as idval FROM dma WHERE dma_id = 0 UNION SELECT dma_id as id, name as idval FROM dma WHERE dma_id IS NOT NULL' 
WHERE column_id = 'dma_id' and formtype = 'feature';

UPDATE config_api_form_fields SET dv_querytext ='SELECT dqa_id as id, name as idval FROM dqa WHERE dqa_id = 0 UNION SELECT dqa_id as id, name as idval FROM dqa WHERE dqa_id IS NOT NULL ' 
WHERE column_id = 'dqa_id' and formtype = 'feature';

UPDATE config_api_form_fields SET dv_querytext ='SELECT id, descript as idval FROM cat_presszone WHERE id = ''0'' UNION SELECT id, descript as idval FROM cat_presszone WHERE id IS NOT NULL ' 
WHERE column_id = 'presszonecat_id' and formtype = 'feature';

