/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2021/05/25
ALTER TABLE cat_feature_node ADD CONSTRAINT cat_feature_node_isextiupperintro_check CHECK (isexitupperintro = ANY (ARRAY[0,1,2,3]));


DROP TRIGGER IF EXISTS gw_trg_typevalue_fk ON man_addfields_value;

CREATE TRIGGER gw_trg_typevalue_fk  AFTER INSERT OR UPDATE ON man_addfields_value
FOR EACH ROW EXECUTE PROCEDURE gw_trg_typevalue_fk('man_addfields_value');
