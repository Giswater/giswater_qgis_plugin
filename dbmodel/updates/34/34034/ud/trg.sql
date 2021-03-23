/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2021/03/22
DROP TRIGGER IF EXISTS gw_trg_edit_review_gully ON v_edit_review_gully;
CREATE TRIGGER gw_trg_edit_review_gully INSTEAD OF INSERT OR UPDATE ON v_edit_review_gully
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_review_gully();


DROP TRIGGER IF EXISTS gw_trg_edit_review_audit_gully ON v_edit_review_audit_gully;
CREATE TRIGGER gw_trg_edit_review_audit_gully INSTEAD OF UPDATE ON v_edit_review_audit_gully
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_review_audit_gully();

