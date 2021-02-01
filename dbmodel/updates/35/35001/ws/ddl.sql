/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- parent:
ALTER TABLE config_mincut_valve RENAME TO config_graf_valve;
ALTER TABLE config_mincut_checkvalve  RENAME TO config_graf_checkvalve;

-- 2021/01/21
DROP FUNCTION IF EXISTS gw_fct_mincut(character varying, character varying, integer, text);
DROP FUNCTION IF EXISTS gw_fct_mincut(character varying, character varying, integer, bigint, bigint);

-- 2021/01/23
UPDATE cat_feature_node SET graf_delimiter  ='CHECKVALVE' WHERE id = 'CHECK-VALVE';
