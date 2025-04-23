/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 27/11/2024
DROP TRIGGER IF EXISTS gw_trg_edit_municipality ON v_ext_municipality;
CREATE TRIGGER gw_trg_edit_municipality INSTEAD OF INSERT OR DELETE OR UPDATE 
ON v_ext_municipality FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_municipality();