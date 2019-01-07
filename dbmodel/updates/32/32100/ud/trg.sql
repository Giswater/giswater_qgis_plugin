
DROP TRIGGER IF EXISTS gw_trg_edit_inp_node_junction ON "SCHEMA_NAME".ve_inp_junction;
CREATE TRIGGER gw_trg_edit_inp_node_junction INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_inp_junction 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_inp_node('inp_junction', 'JUNCTION');
 
DROP TRIGGER IF EXISTS gw_trg_edit_inp_node_divider ON "SCHEMA_NAME".ve_inp_divider;
CREATE TRIGGER gw_trg_edit_inp_node_divider INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_inp_divider
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_inp_node('inp_divider', 'DIVIDER');

DROP TRIGGER IF EXISTS gw_trg_edit_inp_node_outfall ON "SCHEMA_NAME".ve_inp_outfall;
CREATE TRIGGER gw_trg_edit_inp_node_outfall INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_inp_outfall
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_inp_node('inp_outfall', 'OUTFALL');

DROP TRIGGER IF EXISTS gw_trg_edit_inp_node_storage ON "SCHEMA_NAME".ve_inp_storage;
CREATE TRIGGER gw_trg_edit_inp_node_storage INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_inp_storage 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_inp_node('inp_storage', 'STORAGE');

DROP TRIGGER IF EXISTS gw_trg_edit_arc ON "SCHEMA_NAME".ve_arc;
CREATE TRIGGER gw_trg_edit_arc INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_arc
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_arc();

/*
DROP TRIGGER IF EXISTS gw_trg_edit_plan_arc ON "SCHEMA_NAME".v_edit_plan_arc;
CREATE TRIGGER gw_trg_edit_plan_arc INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_plan_arc
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_arc();
*/

DROP TRIGGER IF EXISTS gw_trg_edit_connec ON "SCHEMA_NAME".ve_connec;
CREATE TRIGGER gw_trg_edit_connec INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_connec
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_connec();

DROP TRIGGER IF EXISTS gw_trg_edit_gully ON "SCHEMA_NAME".ve_gully;
CREATE TRIGGER gw_trg_edit_gully INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_gully
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_gully(gully);

DROP TRIGGER IF EXISTS gw_trg_edit_inp_arc_conduit ON "SCHEMA_NAME".ve_inp_conduit;
CREATE TRIGGER gw_trg_edit_inp_arc_conduit INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_inp_conduit
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_inp_arc('inp_conduit', 'CONDUIT');   

DROP TRIGGER IF EXISTS gw_trg_edit_inp_arc_pump ON "SCHEMA_NAME".ve_inp_pump;
CREATE TRIGGER gw_trg_edit_inp_arc_pump INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_inp_pump
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_inp_arc('inp_pump', 'PUMP');   

DROP TRIGGER IF EXISTS gw_trg_edit_inp_arc_orifice ON "SCHEMA_NAME".ve_inp_orifice;
CREATE TRIGGER gw_trg_edit_inp_arc_orifice INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_inp_orifice
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_inp_arc('inp_orifice', 'ORIFICE');   

DROP TRIGGER IF EXISTS gw_trg_edit_inp_arc_outlet ON "SCHEMA_NAME".ve_inp_outlet;
CREATE TRIGGER gw_trg_edit_inp_arc_outlet INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_inp_outlet
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_inp_arc('inp_outlet', 'OUTLET');   

DROP TRIGGER IF EXISTS gw_trg_edit_inp_arc_weir ON "SCHEMA_NAME".ve_inp_weir;
CREATE TRIGGER gw_trg_edit_inp_arc_weir INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_inp_weir
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_inp_arc('inp_weir', 'WEIR');   

DROP TRIGGER IF EXISTS gw_trg_edit_inp_arc_virtual ON "SCHEMA_NAME".ve_inp_virtual;
CREATE TRIGGER gw_trg_edit_inp_arc_virtual INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_inp_virtual
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_inp_arc('inp_virtual', 'VIRTUAL');   

DROP TRIGGER IF EXISTS gw_trg_edit_arc_pumppipe ON "SCHEMA_NAME".ve_arc_pumppipe;
CREATE TRIGGER gw_trg_edit_arc_pumppipe INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_arc_pumppipe FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_arc('PUMP-PIPE');     

DROP TRIGGER IF EXISTS gw_trg_edit_arc_conduit ON "SCHEMA_NAME".ve_arc_conduit;
CREATE TRIGGER gw_trg_edit_arc_conduit INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_arc_conduit FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_arc('CONDUIT');   

DROP TRIGGER IF EXISTS gw_trg_edit_arc_siphon ON "SCHEMA_NAME".ve_arc_siphon;
CREATE TRIGGER gw_trg_edit_arc_siphon INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_arc_siphon FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_arc('SIPHON'); 

DROP TRIGGER IF EXISTS gw_trg_edit_arc_varc ON "SCHEMA_NAME".ve_arc_varc;
CREATE TRIGGER gw_trg_edit_arc_varc INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_arc_varc FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_arc('VARC'); 

DROP TRIGGER IF EXISTS gw_trg_edit_arc_waccel ON "SCHEMA_NAME".ve_arc_waccel;
CREATE TRIGGER gw_trg_edit_arc_waccel INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_arc_waccel FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_arc('WACCEL'); 

DROP TRIGGER IF EXISTS gw_trg_edit_connec ON "SCHEMA_NAME".ve_connec;
CREATE TRIGGER gw_trg_edit_connec INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_connec FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_connec();

DROP TRIGGER IF EXISTS gw_trg_edit_gully ON "SCHEMA_NAME".ve_gully;
CREATE TRIGGER gw_trg_edit_gully INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_gully FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_gully(gully);

DROP TRIGGER IF EXISTS gw_trg_edit_man_gully_pol ON "SCHEMA_NAME".ve_pol_gully;
CREATE TRIGGER gw_trg_edit_man_gully_pol INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_pol_gully FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_gully_pol();


DROP TRIGGER IF EXISTS gw_trg_edit_node_chamber ON "SCHEMA_NAME".ve_node_chamber;
CREATE TRIGGER gw_trg_edit_node_chamber INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_chamber FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('CHAMBER');     

DROP TRIGGER IF EXISTS gw_trg_edit_node_weir ON "SCHEMA_NAME".ve_node_weir;
CREATE TRIGGER gw_trg_edit_node_weir INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_weir FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('WEIR');

DROP TRIGGER IF EXISTS gw_trg_edit_node_pumpstation ON "SCHEMA_NAME".ve_node_pumpstation;
CREATE TRIGGER gw_trg_edit_node_pumpstation INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_pumpstation FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('PUMP-STATION');

DROP TRIGGER IF EXISTS gw_trg_edit_node_register ON "SCHEMA_NAME".ve_node_register;
CREATE TRIGGER gw_trg_edit_node_register INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_register FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('REGISTER');  

DROP TRIGGER IF EXISTS gw_trg_edit_node_change ON "SCHEMA_NAME".ve_node_change;
CREATE TRIGGER gw_trg_edit_node_change INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_change FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('CHANGE');  

DROP TRIGGER IF EXISTS gw_trg_edit_node_vnode ON "SCHEMA_NAME".ve_node_vnode;
CREATE TRIGGER gw_trg_edit_node_vnode INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_vnode FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('VNODE');

DROP TRIGGER IF EXISTS gw_trg_edit_node_junction ON "SCHEMA_NAME".ve_node_junction;
CREATE TRIGGER gw_trg_edit_node_junction INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_junction FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('JUNCTION');

DROP TRIGGER IF EXISTS gw_trg_edit_node_highpoint ON "SCHEMA_NAME".ve_node_highpoint;
CREATE TRIGGER gw_trg_edit_node_highpoint INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_highpoint FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('HIGHPOINT');   

DROP TRIGGER IF EXISTS gw_trg_edit_node_circmanhole ON "SCHEMA_NAME".ve_node_circmanhole;
CREATE TRIGGER gw_trg_edit_node_circmanhole INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_circmanhole FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('CIRC-MANHOLE');   

DROP TRIGGER IF EXISTS gw_trg_edit_node_rectmanhole ON "SCHEMA_NAME".ve_node_rectmanhole;
CREATE TRIGGER gw_trg_edit_node_rectmanhole INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_rectmanhole FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('RECT-MANHOLE');
     
DROP TRIGGER IF EXISTS gw_trg_edit_node_netelement ON "SCHEMA_NAME".ve_node_netelement;
CREATE TRIGGER gw_trg_edit_node_netelement INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_netelement FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('NETELEMENT');

DROP TRIGGER IF EXISTS gw_trg_edit_node_netgully ON "SCHEMA_NAME".ve_node_netgully;
CREATE TRIGGER gw_trg_edit_node_netgully INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_netgully FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('NETGULLY'); 

DROP TRIGGER IF EXISTS gw_trg_edit_node_sandbox ON "SCHEMA_NAME".ve_node_sandbox;
CREATE TRIGGER gw_trg_edit_node_sandbox INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_sandbox FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('SANDBOX'); 

DROP TRIGGER IF EXISTS gw_trg_edit_node_outfall ON "SCHEMA_NAME".ve_node_outfall;
CREATE TRIGGER gw_trg_edit_node_outfall INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_outfall FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('OUTFALL'); 

DROP TRIGGER IF EXISTS gw_trg_edit_node_overflowstorage ON "SCHEMA_NAME".ve_node_overflowstorage;
CREATE TRIGGER gw_trg_edit_node_overflowstorage INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_overflowstorage FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('OWERFLOW-STORAGE'); 


DROP TRIGGER IF EXISTS gw_trg_edit_node_sewerstorage ON "SCHEMA_NAME".ve_node_sewerstorage;
CREATE TRIGGER gw_trg_edit_node_sewerstorage INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_sewerstorage FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('SEWER-STORAGE');

DROP TRIGGER IF EXISTS gw_trg_edit_node_valve ON "SCHEMA_NAME".ve_node_valve;
CREATE TRIGGER gw_trg_edit_node_valve INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_valve FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('VALVE');

DROP TRIGGER IF EXISTS gw_trg_edit_node_jump ON "SCHEMA_NAME".ve_node_jump;
CREATE TRIGGER gw_trg_edit_node_jump INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_jump FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('JUMP');

DROP TRIGGER IF EXISTS gw_trg_edit_node_wwtp ON "SCHEMA_NAME".ve_node_wwtp;
CREATE TRIGGER gw_trg_edit_node_wwtp INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_wwtp FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('WWTP');

DROP TRIGGER IF EXISTS gw_trg_edit_man_storage_pol ON "SCHEMA_NAME".ve_pol_storage;
CREATE TRIGGER gw_trg_edit_man_storage_pol INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_pol_storage FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node_pol('man_storage_pol');

DROP TRIGGER IF EXISTS gw_trg_edit_man_netgully_pol ON "SCHEMA_NAME".ve_pol_netgully;
CREATE TRIGGER gw_trg_edit_man_netgully_pol INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_pol_netgully FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node_pol('man_netgully_pol');

DROP TRIGGER IF EXISTS gw_trg_edit_man_chamber_pol ON "SCHEMA_NAME".ve_pol_chamber;
CREATE TRIGGER gw_trg_edit_man_chamber_pol INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_pol_chamber FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node_pol('man_chamber_pol');

DROP TRIGGER IF EXISTS gw_trg_edit_man_wwtp_pol ON "SCHEMA_NAME".ve_pol_wwtp;
CREATE TRIGGER gw_trg_edit_man_wwtp_pol INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_pol_wwtp FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node_pol('man_wwtp_pol');

DROP TRIGGER IF EXISTS gw_trg_edit_node ON "SCHEMA_NAME".ve_node;
CREATE TRIGGER gw_trg_edit_node INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_node();

/*
DROP TRIGGER IF EXISTS gw_trg_edit_plan_node ON "SCHEMA_NAME".v_edit_plan_node;
CREATE TRIGGER gw_trg_edit_plan_node INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_plan_node
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_node();
*/

DROP TRIGGER IF EXISTS gw_trg_edit_raingage ON "SCHEMA_NAME".ve_raingage;
CREATE TRIGGER gw_trg_edit_raingage INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_raingage
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_raingage(raingage);

DROP TRIGGER IF EXISTS gw_trg_edit_subcatchment ON "SCHEMA_NAME".ve_subcatchment;
CREATE TRIGGER gw_trg_edit_subcatchment INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_subcatchment
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_subcatchment(subcatchment);