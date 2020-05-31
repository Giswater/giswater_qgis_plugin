/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 2020/05/31
UPDATE sys_param_user SET dv_querytext = 'SELECT presszone.presszone_id AS id, presszone.name AS idval FROM presszone WHERE presszone_id IS NOT NULL' 
WHERE id = 'presszone_vdefault';

 UPDATE config_form_fields SET  dv_querytext = 'SELECT presszone.presszone_id AS id, presszone.name AS idval FROM presszone WHERE presszone_id IS NOT NULL' 
 WHERE columnname = 'presszone_id';