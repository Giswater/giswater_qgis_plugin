/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 31/03/2026
DROP TRIGGER IF EXISTS gw_trg_edit_controls ON node;
DROP TRIGGER IF EXISTS gw_trg_edit_controls ON arc;
DROP TRIGGER IF EXISTS gw_trg_edit_controls ON connec;
DROP TRIGGER IF EXISTS gw_trg_edit_controls ON link;

CREATE TRIGGER gw_trg_edit_controls BEFORE DELETE OR UPDATE
ON node FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_controls('node_id');

CREATE TRIGGER gw_trg_edit_controls BEFORE DELETE OR UPDATE
ON arc FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_controls('arc_id');

CREATE TRIGGER gw_trg_edit_controls BEFORE DELETE OR UPDATE
ON connec FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_controls('connec_id');

CREATE TRIGGER gw_trg_edit_controls BEFORE DELETE OR UPDATE
ON link FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_controls('link_id');
