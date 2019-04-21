/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

CREATE TRIGGER gw_trg_vi_curves  INSTEAD OF INSERT OR UPDATE OR DELETE
ON SCHEMA_NAME.vi_curves  FOR EACH ROW  EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_curves');