/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;


-- parent
---------
DROP TRIGGER IF EXISTS gw_trg_edit_arc ON "SCHEMA_NAME".v_edit_arc;
CREATE TRIGGER gw_trg_edit_arc INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_arc
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_arc('parent');

DROP TRIGGER IF EXISTS gw_trg_edit_connec ON "SCHEMA_NAME".v_edit_connec;
CREATE TRIGGER gw_trg_edit_connec INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_connec
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_connec('parent');
 
DROP TRIGGER IF EXISTS gw_trg_edit_gully ON "SCHEMA_NAME".v_edit_gully;
CREATE TRIGGER gw_trg_edit_gully INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_gully
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_gully(gully,'parent');

DROP TRIGGER IF EXISTS gw_trg_edit_node ON "SCHEMA_NAME".v_edit_node;
CREATE TRIGGER gw_trg_edit_node INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_node
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_node('parent');  


-- child
--------
DROP TRIGGER IF EXISTS gw_trg_edit_man_storage_pol ON "SCHEMA_NAME".ve_pol_storage;
CREATE TRIGGER gw_trg_edit_man_storage_pol INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_pol_storage 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node_pol('man_storage_pol');

DROP TRIGGER IF EXISTS gw_trg_edit_man_netgully_pol ON "SCHEMA_NAME".ve_pol_netgully;
CREATE TRIGGER gw_trg_edit_man_netgully_pol INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_pol_netgully 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node_pol('man_netgully_pol');

DROP TRIGGER IF EXISTS gw_trg_edit_man_chamber_pol ON "SCHEMA_NAME".ve_pol_chamber;
CREATE TRIGGER gw_trg_edit_man_chamber_pol INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_pol_chamber 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node_pol('man_chamber_pol');

DROP TRIGGER IF EXISTS gw_trg_edit_man_wwtp_pol ON "SCHEMA_NAME".ve_pol_wwtp;
CREATE TRIGGER gw_trg_edit_man_wwtp_pol INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_pol_wwtp 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node_pol('man_wwtp_pol');

DROP TRIGGER IF EXISTS gw_trg_edit_man_conduit ON "SCHEMA_NAME".v_edit_man_conduit;
CREATE TRIGGER gw_trg_edit_man_conduit INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_conduit 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_arc('man_conduit');     

DROP TRIGGER IF EXISTS gw_trg_edit_man_siphon ON "SCHEMA_NAME".v_edit_man_siphon;
CREATE TRIGGER gw_trg_edit_man_siphon INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_siphon 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_arc('man_siphon');   

DROP TRIGGER IF EXISTS gw_trg_edit_man_waccel ON "SCHEMA_NAME".v_edit_man_waccel;
CREATE TRIGGER gw_trg_edit_man_waccel INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_waccel 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_arc('man_waccel'); 

DROP TRIGGER IF EXISTS gw_trg_edit_man_varc ON "SCHEMA_NAME".v_edit_man_varc;
CREATE TRIGGER gw_trg_edit_man_varc INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_varc 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_arc('man_varc'); 

DROP TRIGGER IF EXISTS gw_trg_edit_man_connec ON "SCHEMA_NAME".v_edit_man_connec;
CREATE TRIGGER gw_trg_edit_man_connec INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_connec
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_connec();
  
DROP TRIGGER IF EXISTS gw_trg_edit_man_gully ON "SCHEMA_NAME".v_edit_man_gully;
CREATE TRIGGER gw_trg_edit_man_gully INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_gully
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_gully(gully);

DROP TRIGGER IF EXISTS gw_trg_edit_man_gully_pol ON "SCHEMA_NAME".v_edit_man_gully_pol;
CREATE TRIGGER gw_trg_edit_man_gully_pol INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_gully_pol
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_gully_pol();

DROP TRIGGER IF EXISTS gw_trg_edit_man_chamber ON "SCHEMA_NAME".v_edit_man_chamber;
CREATE TRIGGER gw_trg_edit_man_chamber INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_chamber 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_node('man_chamber');     

DROP TRIGGER IF EXISTS gw_trg_edit_man_junction ON "SCHEMA_NAME".v_edit_man_junction;
CREATE TRIGGER gw_trg_edit_man_junction INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_junction 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_node('man_junction');

DROP TRIGGER IF EXISTS gw_trg_edit_man_manhole ON "SCHEMA_NAME".v_edit_man_manhole;
CREATE TRIGGER gw_trg_edit_man_manhole INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_manhole 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_node('man_manhole');

DROP TRIGGER IF EXISTS gw_trg_edit_man_netgully ON "SCHEMA_NAME".v_edit_man_netgully;
CREATE TRIGGER gw_trg_edit_man_netgully INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_netgully 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_node('man_netgully');  

DROP TRIGGER IF EXISTS gw_trg_edit_man_netinit ON "SCHEMA_NAME".v_edit_man_netinit;
CREATE TRIGGER gw_trg_edit_man_netinit INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_netinit 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_node('man_netinit');  

DROP TRIGGER IF EXISTS gw_trg_edit_man_outfall ON "SCHEMA_NAME".v_edit_man_outfall;
CREATE TRIGGER gw_trg_edit_man_outfall INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_outfall 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_node('man_outfall');

DROP TRIGGER IF EXISTS gw_trg_edit_man_storage ON "SCHEMA_NAME".v_edit_man_storage;
CREATE TRIGGER gw_trg_edit_man_storage INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_storage 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_node('man_storage');

DROP TRIGGER IF EXISTS gw_trg_edit_man_valve ON "SCHEMA_NAME".v_edit_man_valve;
CREATE TRIGGER gw_trg_edit_man_valve INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_valve 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_node('man_valve');   

DROP TRIGGER IF EXISTS gw_trg_edit_man_wjump ON "SCHEMA_NAME".v_edit_man_wjump;
CREATE TRIGGER gw_trg_edit_man_wjump INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_wjump 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_node('man_wjump');   

DROP TRIGGER IF EXISTS gw_trg_edit_man_wwtp ON "SCHEMA_NAME".v_edit_man_wwtp;
CREATE TRIGGER gw_trg_edit_man_wwtp INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_wwtp 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_node('man_wwtp');
     
DROP TRIGGER IF EXISTS gw_trg_edit_man_netelement ON "SCHEMA_NAME".v_edit_man_netelement;
CREATE TRIGGER gw_trg_edit_man_netelement INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_netelement 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_node('man_netelement');   

DROP TRIGGER IF EXISTS gw_trg_edit_man_storage_pol ON "SCHEMA_NAME".v_edit_man_storage_pol;
CREATE TRIGGER gw_trg_edit_man_storage_pol INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_storage_pol 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node_pol('man_storage_pol');

DROP TRIGGER IF EXISTS gw_trg_edit_man_netgully_pol ON "SCHEMA_NAME".v_edit_man_netgully_pol;
CREATE TRIGGER gw_trg_edit_man_netgully_pol INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_netgully_pol 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node_pol('man_netgully_pol');

DROP TRIGGER IF EXISTS gw_trg_edit_man_chamber_pol ON "SCHEMA_NAME".v_edit_man_chamber_pol;
CREATE TRIGGER gw_trg_edit_man_chamber_pol INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_chamber_pol 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node_pol('man_chamber_pol');

DROP TRIGGER IF EXISTS gw_trg_edit_man_wwtp_pol ON "SCHEMA_NAME".v_edit_man_wwtp_pol;
CREATE TRIGGER gw_trg_edit_man_wwtp_pol INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_wwtp_pol 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node_pol('man_wwtp_pol');

--custom
--------
DROP TRIGGER IF EXISTS gw_trg_edit_arc_pumppipe ON "SCHEMA_NAME".ve_arc_pumppipe;
CREATE TRIGGER gw_trg_edit_arc_pumppipe INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_arc_pumppipe FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_arc('PUMP-PIPE');     

DROP TRIGGER IF EXISTS gw_trg_edit_arc_conduit ON "SCHEMA_NAME".ve_arc_conduit;
CREATE TRIGGER gw_trg_edit_arc_conduit INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_arc_conduit FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_arc('CONDUIT');   

DROP TRIGGER IF EXISTS gw_trg_edit_arc_siphon ON "SCHEMA_NAME".ve_arc_siphon;
CREATE TRIGGER gw_trg_edit_arc_siphon INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_arc_siphon FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_arc('SIPHON'); 

DROP TRIGGER IF EXISTS gw_trg_edit_arc_varc ON "SCHEMA_NAME".ve_arc_varc;
CREATE TRIGGER gw_trg_edit_arc_varc INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_arc_varc FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_arc('VARC'); 

DROP TRIGGER IF EXISTS gw_trg_edit_arc_waccel ON "SCHEMA_NAME".ve_arc_waccel;
CREATE TRIGGER gw_trg_edit_arc_waccel INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_arc_waccel FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_arc('WACCEL'); 

DROP TRIGGER IF EXISTS gw_trg_edit_connec ON "SCHEMA_NAME".ve_connec;
CREATE TRIGGER gw_trg_edit_connec INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_connec FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_connec('CONNEC');

DROP TRIGGER IF EXISTS gw_trg_edit_gully ON "SCHEMA_NAME".ve_gully;
CREATE TRIGGER gw_trg_edit_gully INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_gully FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_gully(gully,'GULLY');

DROP TRIGGER IF EXISTS gw_trg_edit_man_gully_pol ON "SCHEMA_NAME".ve_pol_gully;
CREATE TRIGGER gw_trg_edit_man_gully_pol INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_pol_gully FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_gully_pol();

DROP TRIGGER IF EXISTS gw_trg_edit_node_chamber ON "SCHEMA_NAME".ve_node_chamber;
CREATE TRIGGER gw_trg_edit_node_chamber INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_chamber FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_node('CHAMBER');     

DROP TRIGGER IF EXISTS gw_trg_edit_node_weir ON "SCHEMA_NAME".ve_node_weir;
CREATE TRIGGER gw_trg_edit_node_weir INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_weir FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_node('WEIR');

DROP TRIGGER IF EXISTS gw_trg_edit_node_pumpstation ON "SCHEMA_NAME".ve_node_pumpstation;
CREATE TRIGGER gw_trg_edit_node_pumpstation INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_pumpstation FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_node('PUMP-STATION');

DROP TRIGGER IF EXISTS gw_trg_edit_node_register ON "SCHEMA_NAME".ve_node_register;
CREATE TRIGGER gw_trg_edit_node_register INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_register FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_node('REGISTER');  

DROP TRIGGER IF EXISTS gw_trg_edit_node_change ON "SCHEMA_NAME".ve_node_change;
CREATE TRIGGER gw_trg_edit_node_change INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_change FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_node('CHANGE');  

DROP TRIGGER IF EXISTS gw_trg_edit_node_vnode ON "SCHEMA_NAME".ve_node_vnode;
CREATE TRIGGER gw_trg_edit_node_vnode INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_vnode FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_node('VNODE');

DROP TRIGGER IF EXISTS gw_trg_edit_node_junction ON "SCHEMA_NAME".ve_node_junction;
CREATE TRIGGER gw_trg_edit_node_junction INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_junction FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_node('JUNCTION');

DROP TRIGGER IF EXISTS gw_trg_edit_node_highpoint ON "SCHEMA_NAME".ve_node_highpoint;
CREATE TRIGGER gw_trg_edit_node_highpoint INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_highpoint FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_node('HIGHPOINT');   

DROP TRIGGER IF EXISTS gw_trg_edit_node_circmanhole ON "SCHEMA_NAME".ve_node_circmanhole;
CREATE TRIGGER gw_trg_edit_node_circmanhole INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_circmanhole FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_node('CIRC-MANHOLE');   

DROP TRIGGER IF EXISTS gw_trg_edit_node_rectmanhole ON "SCHEMA_NAME".ve_node_rectmanhole;
CREATE TRIGGER gw_trg_edit_node_rectmanhole INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_rectmanhole FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_node('RECT-MANHOLE');
     
DROP TRIGGER IF EXISTS gw_trg_edit_node_netelement ON "SCHEMA_NAME".ve_node_netelement;
CREATE TRIGGER gw_trg_edit_node_netelement INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_netelement FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_node('NETELEMENT');

DROP TRIGGER IF EXISTS gw_trg_edit_node_netgully ON "SCHEMA_NAME".ve_node_netgully;
CREATE TRIGGER gw_trg_edit_node_netgully INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_netgully FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_node('NETGULLY'); 

DROP TRIGGER IF EXISTS gw_trg_edit_node_sandbox ON "SCHEMA_NAME".ve_node_sandbox;
CREATE TRIGGER gw_trg_edit_node_sandbox INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_sandbox FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_node('SANDBOX'); 

DROP TRIGGER IF EXISTS gw_trg_edit_node_outfall ON "SCHEMA_NAME".ve_node_outfall;
CREATE TRIGGER gw_trg_edit_node_outfall INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_outfall FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_node('OUTFALL'); 

DROP TRIGGER IF EXISTS gw_trg_edit_node_overflowstorage ON "SCHEMA_NAME".ve_node_overflowstorage;
CREATE TRIGGER gw_trg_edit_node_overflowstorage INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_overflowstorage FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_node('OWERFLOW-STORAGE'); 

DROP TRIGGER IF EXISTS gw_trg_edit_node_sewerstorage ON "SCHEMA_NAME".ve_node_sewerstorage;
CREATE TRIGGER gw_trg_edit_node_sewerstorage INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_sewerstorage FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_node('SEWER-STORAGE');

DROP TRIGGER IF EXISTS gw_trg_edit_node_valve ON "SCHEMA_NAME".ve_node_valve;
CREATE TRIGGER gw_trg_edit_node_valve INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_valve FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_node('VALVE');

DROP TRIGGER IF EXISTS gw_trg_edit_node_jump ON "SCHEMA_NAME".ve_node_jump;
CREATE TRIGGER gw_trg_edit_node_jump INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_jump FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_node('JUMP');

DROP TRIGGER IF EXISTS gw_trg_edit_node_wwtp ON "SCHEMA_NAME".ve_node_wwtp;
CREATE TRIGGER gw_trg_edit_node_wwtp INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_wwtp FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_node('WWTP');
