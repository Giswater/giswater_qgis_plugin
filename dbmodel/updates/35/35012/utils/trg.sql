/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2021/08/24
DROP TRIGGER IF EXISTS gw_trg_edit_pol_node ON ve_pol_node;

CREATE TRIGGER gw_trg_edit_pol_node
INSTEAD OF INSERT OR UPDATE OR DELETE ON ve_pol_node
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_man_node_pol();


DROP TRIGGER IF EXISTS gw_trg_edit_pol_connec ON ve_pol_connec;

CREATE TRIGGER gw_trg_edit_pol_connec
INSTEAD OF INSERT OR UPDATE OR DELETE ON ve_pol_connec
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_man_connec_pol();