/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

DROP TRIGGER IF EXISTS gw_trg_edit_arc ON ve_arc;
CREATE TRIGGER gw_trg_edit_arc INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_arc
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_arc('parent');

DROP TRIGGER IF EXISTS gw_trg_edit_node ON ve_node;
CREATE TRIGGER gw_trg_edit_node INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_node 
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_node('parent');

DROP TRIGGER IF EXISTS gw_trg_edit_connec ON ve_connec;
CREATE TRIGGER gw_trg_edit_connec INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_connec 
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_connec('parent');

DROP TRIGGER IF EXISTS gw_trg_edit_link ON ve_link;
CREATE TRIGGER gw_trg_edit_link INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_link 
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_link('LINK');

CREATE TRIGGER gw_trg_edit_ve_epa_valve INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_epa_valve
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_ve_epa('valve');
