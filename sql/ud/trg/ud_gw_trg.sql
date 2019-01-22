/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


DROP TRIGGER IF EXISTS gw_trg_edit_arc ON "SCHEMA_NAME".v_edit_arc;
CREATE TRIGGER gw_trg_edit_arc INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_arc
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_arc();

DROP TRIGGER IF EXISTS gw_trg_edit_connec ON "SCHEMA_NAME".v_edit_connec;
CREATE TRIGGER gw_trg_edit_connec INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_connec
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_connec();
 
DROP TRIGGER IF EXISTS gw_trg_edit_gully ON "SCHEMA_NAME".v_edit_gully;
CREATE TRIGGER gw_trg_edit_gully INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_gully
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_gully(gully);

DROP TRIGGER IF EXISTS gw_trg_edit_inp_arc_conduit ON "SCHEMA_NAME".v_edit_inp_conduit;
CREATE TRIGGER gw_trg_edit_inp_arc_conduit INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_inp_conduit
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_inp_arc('inp_conduit', 'CONDUIT');   

DROP TRIGGER IF EXISTS gw_trg_edit_inp_arc_pump ON "SCHEMA_NAME".v_edit_inp_pump;
CREATE TRIGGER gw_trg_edit_inp_arc_pump INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_inp_pump
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_inp_arc('inp_pump', 'PUMP');   

DROP TRIGGER IF EXISTS gw_trg_edit_inp_arc_orifice ON "SCHEMA_NAME".v_edit_inp_orifice;
CREATE TRIGGER gw_trg_edit_inp_arc_orifice INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_inp_orifice
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_inp_arc('inp_orifice', 'ORIFICE');   

DROP TRIGGER IF EXISTS gw_trg_edit_inp_arc_outlet ON "SCHEMA_NAME".v_edit_inp_outlet;
CREATE TRIGGER gw_trg_edit_inp_arc_outlet INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_inp_outlet
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_inp_arc('inp_outlet', 'OUTLET');   

DROP TRIGGER IF EXISTS gw_trg_edit_inp_arc_weir ON "SCHEMA_NAME".v_edit_inp_weir;
CREATE TRIGGER gw_trg_edit_inp_arc_weir INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_inp_weir
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_inp_arc('inp_weir', 'WEIR');   

DROP TRIGGER IF EXISTS gw_trg_edit_inp_arc_virtual ON "SCHEMA_NAME".v_edit_inp_virtual;
CREATE TRIGGER gw_trg_edit_inp_arc_virtual INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_inp_virtual
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_inp_arc('inp_virtual', 'VIRTUAL');   

DROP TRIGGER IF EXISTS gw_trg_edit_inp_node_junction ON "SCHEMA_NAME".v_edit_inp_junction;
CREATE TRIGGER gw_trg_edit_inp_node_junction INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_inp_junction 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_inp_node('inp_junction', 'JUNCTION');
 
DROP TRIGGER IF EXISTS gw_trg_edit_inp_node_divider ON "SCHEMA_NAME".v_edit_inp_divider;
CREATE TRIGGER gw_trg_edit_inp_node_divider INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_inp_divider
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_inp_node('inp_divider', 'DIVIDER');

DROP TRIGGER IF EXISTS gw_trg_edit_inp_node_outfall ON "SCHEMA_NAME".v_edit_inp_outfall;
CREATE TRIGGER gw_trg_edit_inp_node_outfall INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_inp_outfall
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_inp_node('inp_outfall', 'OUTFALL');

DROP TRIGGER IF EXISTS gw_trg_edit_inp_node_storage ON "SCHEMA_NAME".v_edit_inp_storage;
CREATE TRIGGER gw_trg_edit_inp_node_storage INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_inp_storage 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_inp_node('inp_storage', 'STORAGE');
  
DROP TRIGGER IF EXISTS gw_trg_edit_man_conduit ON "SCHEMA_NAME".v_edit_man_conduit;
CREATE TRIGGER gw_trg_edit_man_conduit INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_conduit 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_arc('man_conduit');     

DROP TRIGGER IF EXISTS gw_trg_edit_man_siphon ON "SCHEMA_NAME".v_edit_man_siphon;
CREATE TRIGGER gw_trg_edit_man_siphon INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_siphon 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_arc('man_siphon');   

DROP TRIGGER IF EXISTS gw_trg_edit_man_waccel ON "SCHEMA_NAME".v_edit_man_waccel;
CREATE TRIGGER gw_trg_edit_man_waccel INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_waccel 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_arc('man_waccel'); 

DROP TRIGGER IF EXISTS gw_trg_edit_man_varc ON "SCHEMA_NAME".v_edit_man_varc;
CREATE TRIGGER gw_trg_edit_man_varc INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_varc 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_arc('man_varc'); 

DROP TRIGGER IF EXISTS gw_trg_edit_man_connec ON "SCHEMA_NAME".v_edit_man_connec;
CREATE TRIGGER gw_trg_edit_man_connec INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_connec
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_connec();
  
DROP TRIGGER IF EXISTS gw_trg_edit_man_gully ON "SCHEMA_NAME".v_edit_man_gully;
CREATE TRIGGER gw_trg_edit_man_gully INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_gully
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_gully(gully);

DROP TRIGGER IF EXISTS gw_trg_edit_man_gully_pol ON "SCHEMA_NAME".v_edit_man_gully_pol;
CREATE TRIGGER gw_trg_edit_man_gully_pol INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_gully_pol
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_gully_pol();

DROP TRIGGER IF EXISTS gw_trg_edit_man_chamber ON "SCHEMA_NAME".v_edit_man_chamber;
CREATE TRIGGER gw_trg_edit_man_chamber INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_chamber 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_chamber');     

DROP TRIGGER IF EXISTS gw_trg_edit_man_junction ON "SCHEMA_NAME".v_edit_man_junction;
CREATE TRIGGER gw_trg_edit_man_junction INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_junction 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_junction');

DROP TRIGGER IF EXISTS gw_trg_edit_man_manhole ON "SCHEMA_NAME".v_edit_man_manhole;
CREATE TRIGGER gw_trg_edit_man_manhole INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_manhole 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_manhole');

DROP TRIGGER IF EXISTS gw_trg_edit_man_netgully ON "SCHEMA_NAME".v_edit_man_netgully;
CREATE TRIGGER gw_trg_edit_man_netgully INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_netgully 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_netgully');  

DROP TRIGGER IF EXISTS gw_trg_edit_man_netinit ON "SCHEMA_NAME".v_edit_man_netinit;
CREATE TRIGGER gw_trg_edit_man_netinit INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_netinit 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_netinit');  

DROP TRIGGER IF EXISTS gw_trg_edit_man_outfall ON "SCHEMA_NAME".v_edit_man_outfall;
CREATE TRIGGER gw_trg_edit_man_outfall INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_outfall 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_outfall');

DROP TRIGGER IF EXISTS gw_trg_edit_man_storage ON "SCHEMA_NAME".v_edit_man_storage;
CREATE TRIGGER gw_trg_edit_man_storage INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_storage 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_storage');

DROP TRIGGER IF EXISTS gw_trg_edit_man_valve ON "SCHEMA_NAME".v_edit_man_valve;
CREATE TRIGGER gw_trg_edit_man_valve INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_valve 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_valve');   

DROP TRIGGER IF EXISTS gw_trg_edit_man_wjump ON "SCHEMA_NAME".v_edit_man_wjump;
CREATE TRIGGER gw_trg_edit_man_wjump INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_wjump 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_wjump');   

DROP TRIGGER IF EXISTS gw_trg_edit_man_wwtp ON "SCHEMA_NAME".v_edit_man_wwtp;
CREATE TRIGGER gw_trg_edit_man_wwtp INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_wwtp 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_wwtp');
     
DROP TRIGGER IF EXISTS gw_trg_edit_man_netelement ON "SCHEMA_NAME".v_edit_man_netelement;
CREATE TRIGGER gw_trg_edit_man_netelement INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_netelement 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_netelement');   

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

DROP TRIGGER IF EXISTS gw_trg_edit_node ON "SCHEMA_NAME".v_edit_node;
CREATE TRIGGER gw_trg_edit_node INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_node
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_node();  

DROP TRIGGER IF EXISTS gw_trg_edit_raingage ON "SCHEMA_NAME".v_edit_raingage;
CREATE TRIGGER gw_trg_edit_raingage INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_raingage
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_raingage(raingage);

DROP TRIGGER IF EXISTS gw_trg_edit_review_arc ON "SCHEMA_NAME".v_edit_review_arc;
CREATE TRIGGER gw_trg_edit_review_arc INSTEAD OF INSERT OR UPDATE ON "SCHEMA_NAME".v_edit_review_arc 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_review_arc();

DROP TRIGGER IF EXISTS gw_trg_edit_review_connec ON "SCHEMA_NAME".v_edit_review_connec;
CREATE TRIGGER gw_trg_edit_review_connec INSTEAD OF INSERT OR UPDATE ON "SCHEMA_NAME".v_edit_review_connec 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_review_connec();

DROP TRIGGER IF EXISTS gw_trg_edit_review_gully ON "SCHEMA_NAME".v_edit_review_gully;
CREATE TRIGGER gw_trg_edit_review_gully INSTEAD OF INSERT OR UPDATE ON "SCHEMA_NAME".v_edit_review_gully 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_review_gully();

DROP TRIGGER IF EXISTS gw_trg_edit_review_node ON "SCHEMA_NAME".v_edit_review_node;
CREATE TRIGGER gw_trg_edit_review_node INSTEAD OF INSERT OR UPDATE ON "SCHEMA_NAME".v_edit_review_node 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_review_node();

DROP TRIGGER IF EXISTS gw_trg_edit_samplepoint ON "SCHEMA_NAME".v_edit_samplepoint;
CREATE TRIGGER gw_trg_edit_samplepoint INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_samplepoint 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_samplepoint('samplepoint');

DROP TRIGGER IF EXISTS gw_trg_edit_subcatchment ON "SCHEMA_NAME".v_edit_subcatchment;
CREATE TRIGGER gw_trg_edit_subcatchment INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_subcatchment
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_subcatchment(subcatchment);

DROP TRIGGER IF EXISTS gw_trg_flw_regulator ON "SCHEMA_NAME"."inp_flwreg_orifice";
CREATE TRIGGER gw_trg_flw_regulator BEFORE INSERT OR UPDATE ON "SCHEMA_NAME"."inp_flwreg_orifice" 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME"."gw_trg_flw_regulator"('orifice');

DROP TRIGGER IF EXISTS gw_trg_flw_regulator ON "SCHEMA_NAME"."inp_flwreg_outlet";
CREATE TRIGGER gw_trg_flw_regulator BEFORE INSERT OR UPDATE ON "SCHEMA_NAME"."inp_flwreg_outlet" 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME"."gw_trg_flw_regulator"('outlet');

DROP TRIGGER IF EXISTS gw_trg_flw_regulator ON "SCHEMA_NAME"."inp_flwreg_weir";
CREATE TRIGGER gw_trg_flw_regulator BEFORE INSERT OR UPDATE ON "SCHEMA_NAME"."inp_flwreg_weir" 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME"."gw_trg_flw_regulator"('weir');

DROP TRIGGER IF EXISTS gw_trg_flw_regulator ON "SCHEMA_NAME"."inp_flwreg_pump";
CREATE TRIGGER gw_trg_flw_regulator BEFORE INSERT OR UPDATE ON "SCHEMA_NAME"."inp_flwreg_pump" 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME"."gw_trg_flw_regulator"('pump');

DROP TRIGGER IF EXISTS gw_trg_gully_update ON "SCHEMA_NAME"."gully";
CREATE TRIGGER gw_trg_gully_update AFTER UPDATE OF the_geom ON "SCHEMA_NAME"."gully" 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME"."gw_trg_gully_update"();

DROP TRIGGER IF EXISTS gw_trg_node_update ON "SCHEMA_NAME"."node";
CREATE TRIGGER gw_trg_node_update AFTER INSERT OR UPDATE OF the_geom, top_elev, custom_top_elev, "state" ON "SCHEMA_NAME"."node" 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME"."gw_trg_node_update"();

DROP TRIGGER IF EXISTS gw_trg_edit_review_audit_arc ON "SCHEMA_NAME".v_edit_review_audit_arc;
CREATE TRIGGER gw_trg_edit_review_audit_arc INSTEAD OF UPDATE ON "SCHEMA_NAME".v_edit_review_audit_arc 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_review_audit_arc();

DROP TRIGGER IF EXISTS gw_trg_edit_review_audit_connec ON "SCHEMA_NAME".v_edit_review_audit_connec;
CREATE TRIGGER gw_trg_edit_review_audit_connec INSTEAD OF UPDATE ON "SCHEMA_NAME".v_edit_review_audit_connec 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_review_audit_connec();

DROP TRIGGER IF EXISTS gw_trg_edit_review_audit_gully ON "SCHEMA_NAME".v_edit_review_audit_gully;
CREATE TRIGGER gw_trg_edit_review_audit_gully INSTEAD OF UPDATE ON "SCHEMA_NAME".v_edit_review_audit_gully 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_review_audit_gully();

DROP TRIGGER IF EXISTS gw_trg_edit_review_audit_node ON "SCHEMA_NAME".v_edit_review_audit_node;
CREATE TRIGGER gw_trg_edit_review_audit_node INSTEAD OF UPDATE ON "SCHEMA_NAME".v_edit_review_audit_node 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_review_audit_node();

DROP TRIGGER IF EXISTS gw_trg_topocontrol_arc ON "SCHEMA_NAME"."arc";
CREATE TRIGGER gw_trg_topocontrol_arc BEFORE INSERT OR UPDATE OF 
the_geom, state, inverted_slope, y1, y2, elev1, elev2, custom_y1, custom_y2, custom_elev1, custom_elev2 
ON SCHEMA_NAME.arc FOR EACH ROW  EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_topocontrol_arc();

DROP TRIGGER IF EXISTS gw_trg_ui_doc_x_gully ON "SCHEMA_NAME".v_ui_doc_x_gully;
CREATE TRIGGER gw_trg_ui_doc_x_gully INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_ui_doc_x_gully
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_ui_doc(doc_x_gully);

DROP TRIGGER IF EXISTS gw_trg_ui_elememt_x_gully ON "SCHEMA_NAME".v_ui_element_x_gully;
CREATE TRIGGER gw_trg_ui_elememt_x_gully INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_ui_element_x_gully
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_ui_element(element_x_gully);

DROP TRIGGER IF EXISTS gw_trg_edit_visitman_x_gully ON "SCHEMA_NAME".v_ui_om_visitman_x_gully;
CREATE TRIGGER gw_trg_edit_visitman_x_gully INSTEAD OF DELETE ON "SCHEMA_NAME".v_ui_om_visitman_x_gully FOR EACH ROW EXECUTE PROCEDURE 
"SCHEMA_NAME".gw_trg_ui_visitman();

DROP TRIGGER IF EXISTS gw_trg_update_link_arc_id ON "SCHEMA_NAME".gully;
CREATE TRIGGER gw_trg_update_link_arc_id AFTER UPDATE OF arc_id ON "SCHEMA_NAME".gully
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_update_link_arc_id(gully);

DROP TRIGGER IF EXISTS gw_trg_man_addfields_value_gully_control ON gully;
CREATE TRIGGER gw_trg_man_addfields_value_gully_control AFTER UPDATE OF gully_id OR DELETE ON SCHEMA_NAME.gully
FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_man_addfields_value_control('GULLY');