/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 29/10/2025
DROP TRIGGER IF EXISTS gw_trg_fk_array_array_table ON man_frelem;
CREATE TRIGGER gw_trg_fk_array_array_table AFTER INSERT OR UPDATE ON man_frelem
FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('to_arc', 'arc', 'arc_id');
