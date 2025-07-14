/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


CREATE TRIGGER gw_trg_edit_gully INSTEAD OF INSERT OR DELETE OR UPDATE ON 
v_edit_gully FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_gully('parent');

CREATE TRIGGER gw_trg_edit_connec INSTEAD OF INSERT OR DELETE OR UPDATE ON 
v_edit_connec FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_connec('parent');

CREATE TRIGGER gw_trg_edit_node INSTEAD OF INSERT OR DELETE OR UPDATE ON 
v_edit_node FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_node('parent');

CREATE TRIGGER gw_trg_edit_inp_node_junction INSTEAD OF INSERT OR DELETE OR UPDATE ON 
v_edit_inp_junction FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_node('inp_junction');

CREATE TRIGGER gw_trg_edit_inp_treatment INSTEAD OF INSERT OR DELETE OR UPDATE ON
v_edit_inp_treatment FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_treatment();

CREATE TRIGGER gw_trg_edit_inp_inflows INSTEAD OF INSERT OR DELETE OR UPDATE ON 
v_edit_inp_inflows_poll FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_inflows('INFLOWS-POLL');

CREATE TRIGGER gw_trg_edit_inp_inflows INSTEAD OF INSERT OR DELETE OR UPDATE ON
v_edit_inp_inflows FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_inflows('INFLOWS');

CREATE TRIGGER gw_trg_edit_inp_dwf INSTEAD OF INSERT OR DELETE OR UPDATE ON
v_edit_inp_dwf FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dwf();

CREATE TRIGGER gw_trg_edit_inp_dscenario INSTEAD OF INSERT OR DELETE OR UPDATE ON
v_edit_inp_dscenario_treatment FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('TREATMENT');

CREATE TRIGGER gw_trg_edit_inp_dscenario INSTEAD OF INSERT OR DELETE OR UPDATE ON
v_edit_inp_dscenario_junction FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('JUNCTION');

CREATE TRIGGER gw_trg_edit_inp_dscenario INSTEAD OF INSERT OR DELETE OR UPDATE ON
v_edit_inp_dscenario_inflows_poll FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('INFLOWS-POLL');

CREATE TRIGGER gw_trg_edit_inp_dscenario INSTEAD OF INSERT OR DELETE OR UPDATE ON
v_edit_inp_dscenario_inflows FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('INFLOWS');

CREATE TRIGGER gw_trg_edit_inp_node_storage INSTEAD OF INSERT OR DELETE OR UPDATE ON
v_edit_inp_storage FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_node('inp_storage');

CREATE TRIGGER gw_trg_edit_inp_dscenario INSTEAD OF INSERT OR DELETE OR UPDATE ON
v_edit_inp_dscenario_storage FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('STORAGE');

CREATE TRIGGER gw_trg_edit_inp_node_junction INSTEAD OF INSERT OR DELETE OR UPDATE ON
v_edit_inp_outfall FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_node('inp_outfall');

CREATE TRIGGER gw_trg_edit_inp_dscenario INSTEAD OF INSERT OR DELETE OR UPDATE ON
v_edit_inp_dscenario_outfall FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('OUTFALL');

CREATE TRIGGER gw_trg_edit_arc INSTEAD OF INSERT OR DELETE OR UPDATE ON
v_edit_arc FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_arc('parent');

CREATE TRIGGER gw_trg_edit_inp_arc_weir INSTEAD OF INSERT OR DELETE OR UPDATE ON
v_edit_inp_weir FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_arc('inp_weir');

CREATE TRIGGER gw_trg_edit_inp_arc_virtual INSTEAD OF INSERT OR DELETE OR UPDATE ON
v_edit_inp_virtual FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_arc('inp_virtual');

CREATE TRIGGER gw_trg_edit_inp_arc_pump INSTEAD OF INSERT OR DELETE OR UPDATE ON
v_edit_inp_pump FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_arc('inp_pump');

CREATE TRIGGER gw_trg_edit_inp_arc_outlet INSTEAD OF INSERT OR DELETE OR UPDATE ON
v_edit_inp_outlet FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_arc('inp_outlet');

CREATE TRIGGER gw_trg_edit_inp_arc_orifice INSTEAD OF INSERT OR DELETE OR UPDATE ON
v_edit_inp_orifice FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_arc('inp_orifice');

CREATE TRIGGER gw_trg_edit_inp_arc_conduit INSTEAD OF INSERT OR DELETE OR UPDATE ON
v_edit_inp_conduit FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_arc('inp_conduit');

CREATE TRIGGER gw_trg_edit_inp_dscenario INSTEAD OF INSERT OR DELETE OR UPDATE ON
v_edit_inp_dscenario_conduit FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('CONDUIT');

CREATE TRIGGER gw_trg_v_edit_dwfzone INSTEAD OF INSERT OR DELETE OR UPDATE ON
v_edit_dwfzone FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_dwfzone('EDIT');

CREATE TRIGGER gw_trg_v_ui_dwfzone INSTEAD OF INSERT OR DELETE OR UPDATE ON
v_ui_dwfzone FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_dwfzone('UI');

CREATE TRIGGER gw_trg_edit_link_link INSTEAD OF INSERT OR DELETE OR UPDATE ON
ve_link_link FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_link('LINK');

-- 14/07/2025
-- Municipality
CREATE TRIGGER gw_trg_fk_array_id_table BEFORE DELETE ON ext_municipality
FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_id_table('muni_id', '{"dma":"muni_id"}');

CREATE TRIGGER gw_trg_fk_array_id_table_update AFTER UPDATE ON ext_municipality
FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_id_table('muni_id', '{"dma":"muni_id"}');

CREATE TRIGGER gw_trg_fk_array_array_table AFTER INSERT OR UPDATE ON dma
FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('muni_id', 'ext_municipality', 'muni_id');

-- Exploitation
CREATE TRIGGER gw_trg_fk_array_id_table BEFORE DELETE ON exploitation
FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_id_table('expl_id', '{"dma":"expl_id"}');

CREATE TRIGGER gw_trg_fk_array_id_table_update AFTER UPDATE ON exploitation
FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_id_table('expl_id', '{"dma":"expl_id"}');

CREATE TRIGGER gw_trg_fk_array_array_table AFTER INSERT OR UPDATE ON dma
FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('expl_id', 'exploitation', 'expl_id');

-- Sector
CREATE TRIGGER gw_trg_fk_array_id_table BEFORE DELETE ON sector
FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_id_table('sector_id', '{"dma":"sector_id"}');

CREATE TRIGGER gw_trg_fk_array_id_table_update AFTER UPDATE ON sector
FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_id_table('sector_id', '{"dma":"sector_id"}');

CREATE TRIGGER gw_trg_fk_array_array_table AFTER INSERT OR UPDATE ON dma
FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('sector_id', 'sector', 'sector_id');
