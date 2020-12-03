/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/



SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2019/03/19

-- trigger deleted on 3.4.010
--DROP TRIGGER IF EXISTS gw_trg_edit_subcatchment ON SCHEMA_NAME.v_edit_subcatchment;
--CREATE TRIGGER gw_trg_edit_subcatchment INSTEAD OF INSERT OR UPDATE OR DELETE  ON SCHEMA_NAME.v_edit_subcatchment  
--FOR EACH ROW  EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_edit_subcatchment('subcatchment');