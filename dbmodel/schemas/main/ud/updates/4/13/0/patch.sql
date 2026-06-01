/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


DROP TRIGGER IF EXISTS gw_trg_edit_pol_element on ve_pol_element;

CREATE TRIGGER gw_trg_edit_pol_chamber INSTEAD OF INSERT OR UPDATE OR DELETE ON ve_pol_chamber
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_man_node_pol();

CREATE TRIGGER gw_trg_edit_pol_connec INSTEAD OF INSERT OR UPDATE OR DELETE ON ve_pol_connec
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_man_connec_pol();

CREATE TRIGGER gw_trg_edit_pol_element INSTEAD OF INSERT OR UPDATE OR DELETE ON ve_pol_element
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_element_pol();

CREATE TRIGGER gw_trg_edit_pol_netgully INSTEAD OF INSERT OR UPDATE OR DELETE ON ve_pol_netgully
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_man_node_pol();

CREATE TRIGGER gw_trg_edit_pol_node INSTEAD OF INSERT OR UPDATE OR DELETE ON ve_pol_node
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_man_node_pol();

CREATE TRIGGER gw_trg_edit_pol_storage INSTEAD OF INSERT OR UPDATE OR DELETE ON ve_pol_storage
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_man_node_pol();

CREATE TRIGGER gw_trg_edit_pol_wwtp INSTEAD OF INSERT OR UPDATE OR DELETE ON ve_pol_wwtp
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_man_node_pol();
