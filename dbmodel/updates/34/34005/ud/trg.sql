/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2020/03/18

CREATE TRIGGER gw_trg_edit_arc INSTEAD OF INSERT OR UPDATE OR DELETE ON v_edit_arc
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_arc('parent');

CREATE TRIGGER gw_trg_edit_node INSTEAD OF INSERT OR UPDATE OR DELETE  ON v_edit_node
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_node('parent');

CREATE TRIGGER gw_trg_edit_connec INSTEAD OF INSERT OR UPDATE OR DELETE ON v_edit_connec
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_connec('parent');

CREATE TRIGGER gw_trg_edit_gully INSTEAD OF INSERT OR UPDATE OR DELETE ON v_edit_gully
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_gully('parent');

CREATE TRIGGER gw_trg_edit_man_chamber INSTEAD OF INSERT OR UPDATE OR DELETE
ON v_edit_man_chamber FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_node('man_chamber');

CREATE TRIGGER gw_trg_edit_man_chamber_pol INSTEAD OF INSERT OR UPDATE OR DELETE
ON v_edit_man_chamber_pol FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_man_node_pol('man_chamber_pol');

CREATE TRIGGER gw_trg_edit_man_conduit INSTEAD OF INSERT OR UPDATE OR DELETE
ON v_edit_man_conduit FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_arc('man_conduit');

CREATE TRIGGER gw_trg_edit_man_connec INSTEAD OF INSERT OR UPDATE OR DELETE
ON v_edit_man_connec FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_connec();

CREATE TRIGGER gw_trg_edit_man_gully INSTEAD OF INSERT OR UPDATE OR DELETE
ON v_edit_man_gully FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_gully();
  
CREATE TRIGGER gw_trg_edit_man_gully_pol INSTEAD OF INSERT OR UPDATE OR DELETE
ON v_edit_man_gully_pol FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_man_gully_pol();

CREATE TRIGGER gw_trg_edit_man_junction INSTEAD OF INSERT OR UPDATE OR DELETE
ON v_edit_man_junction FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_node('man_junction');

CREATE TRIGGER gw_trg_edit_man_manhole INSTEAD OF INSERT OR UPDATE OR DELETE
ON v_edit_man_manhole FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_node('man_manhole');

CREATE TRIGGER gw_trg_edit_man_netgully INSTEAD OF INSERT OR UPDATE OR DELETE
ON v_edit_man_netgully FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_node('man_netgully');

CREATE TRIGGER gw_trg_edit_man_netgully_pol INSTEAD OF INSERT OR UPDATE OR DELETE
ON v_edit_man_netgully_pol FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_man_node_pol('man_netgully_pol');

CREATE TRIGGER gw_trg_edit_man_netinit INSTEAD OF INSERT OR UPDATE OR DELETE
ON v_edit_man_netinit FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_node('man_netinit');
  
CREATE TRIGGER gw_trg_edit_man_netelement INSTEAD OF INSERT OR UPDATE OR DELETE
ON v_edit_man_netelement FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_node('man_netelement');

CREATE TRIGGER gw_trg_edit_man_outfall INSTEAD OF INSERT OR UPDATE OR DELETE
ON v_edit_man_outfall FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_node('man_outfall');

CREATE TRIGGER gw_trg_edit_man_siphon INSTEAD OF INSERT OR UPDATE OR DELETE
ON v_edit_man_siphon FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_arc('man_siphon');

CREATE TRIGGER gw_trg_edit_man_storage INSTEAD OF INSERT OR UPDATE OR DELETE 
ON v_edit_man_storage FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_node('man_storage');

CREATE TRIGGER gw_trg_edit_man_storage_pol INSTEAD OF INSERT OR UPDATE OR DELETE 
ON v_edit_man_storage_pol FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_man_node_pol('man_storage_pol');

CREATE TRIGGER gw_trg_edit_man_valve INSTEAD OF INSERT OR UPDATE OR DELETE
ON v_edit_man_valve FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_node('man_valve');

CREATE TRIGGER gw_trg_edit_man_varc INSTEAD OF INSERT OR UPDATE OR DELETE
ON v_edit_man_varc FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_arc('man_varc');
  
CREATE TRIGGER gw_trg_edit_man_waccel INSTEAD OF INSERT OR UPDATE OR DELETE
ON v_edit_man_waccel FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_arc('man_waccel');

CREATE TRIGGER gw_trg_edit_man_wjump INSTEAD OF INSERT OR UPDATE OR DELETE
ON v_edit_man_wjump FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_node('man_wjump');

CREATE TRIGGER gw_trg_edit_man_wwtp INSTEAD OF INSERT OR UPDATE OR DELETE
ON v_edit_man_wwtp FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_node('man_wwtp');

CREATE TRIGGER gw_trg_edit_man_wwtp_pol INSTEAD OF INSERT OR UPDATE OR DELETE
ON v_edit_man_wwtp_pol FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_man_node_pol('man_wwtp_pol');

CREATE TRIGGER gw_trg_edit_inp_arc_conduit INSTEAD OF INSERT OR UPDATE OR DELETE
ON v_edit_inp_conduit FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_inp_arc('inp_conduit');

CREATE TRIGGER gw_trg_edit_inp_node_divider INSTEAD OF INSERT OR UPDATE OR DELETE
ON v_edit_inp_divider FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_inp_node('inp_divider');
  
CREATE TRIGGER gw_trg_edit_inp_node_junction INSTEAD OF INSERT OR UPDATE OR DELETE
ON v_edit_inp_junction FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_inp_node('inp_junction');

CREATE TRIGGER gw_trg_edit_inp_arc_orifice INSTEAD OF INSERT OR UPDATE OR DELETE
ON v_edit_inp_orifice FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_inp_arc('inp_orifice');

CREATE TRIGGER gw_trg_edit_inp_node_outfall INSTEAD OF INSERT OR UPDATE OR DELETE
ON v_edit_inp_outfall FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_inp_node('inp_outfall');

CREATE TRIGGER gw_trg_edit_inp_arc_outlet INSTEAD OF INSERT OR UPDATE OR DELETE
ON v_edit_inp_outlet FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_inp_arc('inp_outlet');

CREATE TRIGGER gw_trg_edit_inp_arc_pump INSTEAD OF INSERT OR UPDATE OR DELETE 
ON v_edit_inp_pump FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_inp_arc('inp_pump');
 
CREATE TRIGGER gw_trg_edit_inp_node_storage INSTEAD OF INSERT OR UPDATE OR DELETE
ON v_edit_inp_storage FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_inp_node('inp_storage');

CREATE TRIGGER gw_trg_edit_inp_arc_virtual INSTEAD OF INSERT OR UPDATE OR DELETE
ON v_edit_inp_virtual FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_inp_arc('inp_virtual');
  
CREATE TRIGGER gw_trg_edit_inp_arc_weir INSTEAD OF INSERT OR UPDATE OR DELETE
ON v_edit_inp_weir FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_inp_arc('inp_weir');

CREATE TRIGGER gw_trg_edit_man_netgully_pol INSTEAD OF INSERT OR UPDATE OR DELETE
ON ve_pol_netgully FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_man_node_pol('man_netgully_pol');
  
CREATE TRIGGER gw_trg_edit_man_storage_pol INSTEAD OF INSERT OR UPDATE OR DELETE
ON ve_pol_storage FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_man_node_pol('man_storage_pol');
  
CREATE TRIGGER gw_trg_edit_man_wwtp_pol INSTEAD OF INSERT OR UPDATE OR DELETE
ON ve_pol_wwtp FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_man_node_pol('man_wwtp_pol');
  
CREATE TRIGGER gw_trg_edit_man_chamber_pol INSTEAD OF INSERT OR UPDATE OR DELETE 
ON ve_pol_chamber FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_man_node_pol('man_chamber_pol');

CREATE TRIGGER gw_trg_vi_groundwater INSTEAD OF INSERT OR UPDATE OR DELETE
ON vi_groundwater FOR EACH ROW EXECUTE PROCEDURE gw_trg_vi('vi_groundwater');
  
CREATE TRIGGER gw_trg_vi_infiltration INSTEAD OF INSERT OR UPDATE OR DELETE
ON vi_infiltration FOR EACH ROW EXECUTE PROCEDURE gw_trg_vi('vi_infiltration');
  
CREATE TRIGGER gw_trg_vi_coverages INSTEAD OF INSERT OR UPDATE OR DELETE
ON vi_coverages FOR EACH ROW EXECUTE PROCEDURE gw_trg_vi('vi_coverages');




