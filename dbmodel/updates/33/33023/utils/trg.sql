/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

DROP TRIGGER IF EXISTS gw_trg_cat_feature ON cat_feature;

CREATE TRIGGER gw_trg_cat_feature AFTER INSERT OR UPDATE OR DELETE
ON cat_feature
FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_cat_feature();