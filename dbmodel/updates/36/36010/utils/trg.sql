/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

DROP TRIGGER IF EXISTS gw_trg_edit_cad_aux ON v_edit_cad_auxcircle;
CREATE TRIGGER gw_trg_edit_cad_aux INSTEAD OF
INSERT OR DELETE OR UPDATE
ON v_edit_cad_auxcircle FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_cad_aux('circle');
