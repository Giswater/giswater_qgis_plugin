/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

CREATE TRIGGER gw_trg_v_edit_sector INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_sector 
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_sector('EDIT');

CREATE TRIGGER gw_trg_v_edit_omzone INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_omzone 
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_omzone('EDIT');

CREATE TRIGGER gw_trg_v_edit_dma INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_dma 
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_dma('EDIT');

CREATE TRIGGER gw_trg_v_edit_dwfzone INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_dwfzone 
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_dwfzone('EDIT');

CREATE TRIGGER gw_trg_v_edit_drainzone INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_drainzone 
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_drainzone('EDIT');

-- 02/12/2025
DROP TRIGGER IF EXISTS gw_trg_fk_array_id_table_update ON arc;
CREATE TRIGGER gw_trg_fk_array_id_table_update AFTER
UPDATE OF arc_id ON arc FOR EACH ROW WHEN (OLD.arc_id IS DISTINCT FROM NEW.arc_id) EXECUTE FUNCTION gw_trg_array_fk_id_table('arc_id',
'{"man_frelem":"to_arc"}');

CREATE TRIGGER gw_trg_topocontrol_node AFTER INSERT OR UPDATE OF the_geom, state, top_elev, ymax, elev, custom_top_elev, custom_elev ON
node FOR EACH ROW EXECUTE FUNCTION gw_trg_topocontrol_node();

CREATE TRIGGER gw_trg_edit_arc INSTEAD OF INSERT OR DELETE OR UPDATE ON
ve_arc FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_arc('parent');

CREATE TRIGGER gw_trg_edit_node INSTEAD OF INSERT OR DELETE OR UPDATE ON
ve_node FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_node('parent');

CREATE TRIGGER gw_trg_edit_inp_node_junction INSTEAD OF INSERT OR DELETE OR UPDATE ON
ve_inp_outfall FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_node('inp_outfall');

CREATE TRIGGER gw_trg_edit_inp_arc_conduit INSTEAD OF INSERT OR DELETE OR UPDATE ON
ve_inp_conduit FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_arc('inp_conduit');

CREATE TRIGGER gw_trg_edit_inp_dscenario INSTEAD OF INSERT OR DELETE OR UPDATE ON
ve_inp_dscenario_conduit FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('CONDUIT');

CREATE TRIGGER gw_trg_edit_inp_dscenario INSTEAD OF INSERT OR DELETE OR UPDATE ON
ve_inp_dscenario_inflows FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('INFLOWS');

CREATE TRIGGER gw_trg_edit_inp_dscenario INSTEAD OF INSERT OR DELETE OR UPDATE ON
ve_inp_dscenario_inflows_poll FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('INFLOWS-POLL');

CREATE TRIGGER gw_trg_edit_inp_dscenario INSTEAD OF INSERT OR DELETE OR UPDATE ON
ve_inp_dscenario_inlet FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('INLET');

CREATE TRIGGER gw_trg_edit_inp_dscenario INSTEAD OF INSERT OR DELETE OR UPDATE ON
ve_inp_dscenario_junction FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('JUNCTION');

CREATE TRIGGER gw_trg_edit_inp_dscenario INSTEAD OF INSERT OR DELETE OR UPDATE ON
ve_inp_dscenario_outfall FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('OUTFALL');

CREATE TRIGGER gw_trg_edit_inp_dscenario INSTEAD OF INSERT OR DELETE OR UPDATE ON
ve_inp_dscenario_storage FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('STORAGE');

CREATE TRIGGER gw_trg_edit_inp_dscenario INSTEAD OF INSERT OR DELETE OR UPDATE ON
ve_inp_dscenario_treatment FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('TREATMENT');

CREATE TRIGGER gw_trg_edit_inp_dwf INSTEAD OF INSERT OR DELETE OR UPDATE ON
ve_inp_dwf FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dwf();

CREATE TRIGGER gw_trg_edit_inp_inflows INSTEAD OF INSERT OR DELETE OR UPDATE ON
ve_inp_inflows FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_inflows('INFLOWS');

CREATE TRIGGER gw_trg_edit_inp_inflows INSTEAD OF INSERT OR DELETE OR UPDATE ON
ve_inp_inflows_poll FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_inflows('INFLOWS-POLL');

CREATE TRIGGER gw_trg_edit_inp_node_inlet INSTEAD OF INSERT OR DELETE OR UPDATE ON
ve_inp_inlet FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_node('inp_inlet');

CREATE TRIGGER gw_trg_edit_inp_node_junction INSTEAD OF INSERT OR DELETE OR UPDATE ON
ve_inp_junction FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_node('inp_junction');

CREATE TRIGGER gw_trg_edit_inp_arc_orifice INSTEAD OF INSERT OR DELETE OR UPDATE ON
ve_inp_orifice FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_arc('inp_orifice');

CREATE TRIGGER gw_trg_edit_inp_arc_outlet INSTEAD OF INSERT OR DELETE OR UPDATE ON
ve_inp_outlet FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_arc('inp_outlet');

CREATE TRIGGER gw_trg_edit_inp_arc_pump INSTEAD OF INSERT OR DELETE OR UPDATE     ON
ve_inp_pump FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_arc('inp_pump');

CREATE TRIGGER gw_trg_edit_inp_node_storage INSTEAD OF INSERT OR DELETE OR UPDATE ON
ve_inp_storage FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_node('inp_storage');

CREATE TRIGGER gw_trg_edit_inp_treatment INSTEAD OF INSERT OR DELETE OR UPDATE ON
ve_inp_treatment FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_treatment();

CREATE TRIGGER gw_trg_edit_inp_arc_virtual INSTEAD OF INSERT OR DELETE OR UPDATE ON
ve_inp_virtual FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_arc('inp_virtual');

CREATE TRIGGER gw_trg_edit_inp_arc_weir INSTEAD OF INSERT OR DELETE OR UPDATE ON
ve_inp_weir FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_arc('inp_weir');
