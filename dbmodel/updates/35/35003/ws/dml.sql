/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2021/02/27
UPDATE sys_feature_epa_type SET active = true;
UPDATE sys_feature_epa_type SET active = false WHERE id IN('PUMP-IMPORTINP','VALVE-IMPORTINP', 'INLET');

UPDATE config_form_fields SET dv_querytext = 'SELECT id, id as idval FROM sys_feature_epa_type WHERE active AND feature_type = ''ARC'''  WHERE columnname = 'epa_type' AND formname like '%_arc%';
UPDATE config_form_fields SET dv_querytext = 'SELECT id, id as idval FROM sys_feature_epa_type WHERE active AND feature_type = ''NODE'''  WHERE columnname = 'epa_type' AND formname like '%_node%';

DELETE FROM sys_table WHERE id = 'inp_rules_controls_importinp';