/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2022/03/02

CREATE TRIGGER gw_trg_edit_ve_epa_junction INSTEAD OF INSERT OR UPDATE OR DELETE ON ve_epa_junction
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_ve_epa('junction');

CREATE TRIGGER gw_trg_edit_ve_epa_conduit INSTEAD OF INSERT OR UPDATE OR DELETE ON ve_epa_conduit
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_ve_epa('conduit');

CREATE TRIGGER gw_trg_edit_ve_epa_outfall INSTEAD OF INSERT OR UPDATE OR DELETE ON ve_epa_outfall
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_ve_epa('outfall');

CREATE TRIGGER gw_trg_edit_ve_epa_storage INSTEAD OF INSERT OR UPDATE OR DELETE ON ve_epa_storage
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_ve_epa('storage');
