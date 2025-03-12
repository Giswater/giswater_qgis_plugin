/*
Copyright © 2023 by BGEO. All rights reserved.
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;

DROP TRIGGER IF EXISTS gw_trg_edit_team_x_user ON v_om_team_x_user;
CREATE TRIGGER gw_trg_edit_team_x_user INSTEAD OF INSERT OR UPDATE OR DELETE ON v_om_team_x_user
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_team_x_user();

DROP TRIGGER IF EXISTS gw_trg_edit_team_x_visitclass ON v_om_team_x_visitclass;
CREATE TRIGGER gw_trg_edit_team_x_visitclass INSTEAD OF INSERT OR UPDATE OR DELETE ON v_om_team_x_visitclass 
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_team_x_visitclass();

DROP TRIGGER IF EXISTS gw_trg_edit_cat_team ON v_edit_cat_team;
CREATE TRIGGER gw_trg_edit_cat_team INSTEAD OF INSERT OR UPDATE OR DELETE ON v_edit_cat_team
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_cat_team();

DROP TRIGGER IF EXISTS gw_trg_edit_cat_vehicle ON v_ext_cat_vehicle;
CREATE TRIGGER gw_trg_edit_cat_vehicle INSTEAD OF INSERT OR UPDATE OR DELETE ON v_ext_cat_vehicle
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_cat_vehicle();

DROP TRIGGER IF EXISTS gw_trg_edit_lot_x_user ON v_om_lot_x_user;
CREATE TRIGGER gw_trg_edit_lot_x_user INSTEAD OF INSERT OR UPDATE OR DELETE ON v_om_lot_x_user
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_lot_x_user();

DROP TRIGGER IF EXISTS gw_trg_om_visit_lotmanage ON om_visit;
CREATE TRIGGER gw_trg_om_visit_lotmanage AFTER INSERT OR UPDATE OF class_id, status ON om_visit
FOR EACH ROW EXECUTE PROCEDURE gw_trg_om_visit_lotmanage();

DROP TRIGGER IF EXISTS gw_trg_om_visit_lotmanage ON om_visit_x_arc;
CREATE TRIGGER gw_trg_om_visit_lotmanage AFTER INSERT ON om_visit_x_arc
FOR EACH ROW EXECUTE PROCEDURE gw_trg_om_visit_lotmanage('arc');

DROP TRIGGER IF EXISTS gw_trg_om_visit_lotmanage ON om_visit_x_node;
CREATE TRIGGER gw_trg_om_visit_lotmanage AFTER INSERT ON om_visit_x_node
FOR EACH ROW EXECUTE PROCEDURE gw_trg_om_visit_lotmanage('node');

DROP TRIGGER IF EXISTS gw_trg_om_visit_lotmanage ON om_visit_x_connec;
CREATE TRIGGER gw_trg_om_visit_lotmanage AFTER INSERT ON om_visit_x_connec
FOR EACH ROW EXECUTE PROCEDURE gw_trg_om_visit_lotmanage('connec');

DROP TRIGGER IF EXISTS gw_trg_edit_team_x_vehicle ON v_om_team_x_vehicle;
CREATE TRIGGER gw_trg_edit_team_x_vehicle INSTEAD OF INSERT OR UPDATE OR DELETE ON v_om_team_x_vehicle
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_team_x_vehicle();

DROP TRIGGER IF EXISTS gw_trg_lot_x_unit ON v_edit_om_visit_lot_x_unit;
CREATE TRIGGER gw_trg_lot_x_unit INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_om_visit_lot_x_unit 
FOR EACH ROW EXECUTE FUNCTION gw_trg_lot_x_unit();

DROP TRIGGER IF EXISTS gw_trg_lot_x_macrounit ON v_edit_om_visit_lot_x_macrounit;
CREATE TRIGGER gw_trg_lot_x_macrounit INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_om_visit_lot_x_macrounit 
FOR EACH ROW EXECUTE FUNCTION gw_trg_lot_x_macrounit();

--dma2category
drop trigger if exists gw_trg_dma2category_arc on arc;
CREATE TRIGGER gw_trg_dma2category_arc AFTER INSERT OR DELETE OR UPDATE OF dma_id ON arc 
FOR EACH ROW EXECUTE FUNCTION gw_trg_dma2category('arc', 'parent_table');
   
drop trigger if exists gw_trg_dma2category_node on node;
CREATE TRIGGER gw_trg_dma2category_node AFTER INSERT OR DELETE OR UPDATE OF dma_id ON node 
FOR EACH ROW EXECUTE FUNCTION gw_trg_dma2category('node', 'parent_table');
    
drop trigger if exists gw_trg_dma2category_connec on connec;
CREATE TRIGGER gw_trg_dma2category_connec AFTER INSERT OR DELETE OR UPDATE OF dma_id ON connec 
FOR EACH ROW EXECUTE FUNCTION gw_trg_dma2category('connec', 'parent_table');
    
drop trigger if exists gw_trg_dma2category_gully on gully;
CREATE TRIGGER gw_trg_dma2category_gully AFTER INSERT OR DELETE OR UPDATE OF dma_id ON gully 
FOR EACH ROW EXECUTE FUNCTION gw_trg_dma2category('gully', 'parent_table');


drop trigger if exists gw_trg_dma2category_arc on om_category_x_arc;
CREATE TRIGGER gw_trg_dma2category_arc AFTER INSERT OR DELETE OR UPDATE OF category_id ON om_category_x_arc
FOR EACH ROW EXECUTE FUNCTION gw_trg_dma2category('arc', 'om_category');
   
drop trigger if exists gw_trg_dma2category_node on om_category_x_node;
CREATE TRIGGER gw_trg_dma2category_node AFTER INSERT OR DELETE OR UPDATE OF category_id ON om_category_x_node
FOR EACH ROW EXECUTE FUNCTION gw_trg_dma2category('node', 'om_category');
    
drop trigger if exists gw_trg_dma2category_connec on om_category_x_connec;
CREATE TRIGGER gw_trg_dma2category_connec AFTER INSERT OR DELETE OR UPDATE OF category_id ON om_category_x_connec
FOR EACH ROW EXECUTE FUNCTION gw_trg_dma2category('connec', 'om_category');
    
drop trigger if exists gw_trg_dma2category_gully on om_category_x_gully;
CREATE TRIGGER gw_trg_dma2category_gully AFTER INSERT OR DELETE OR UPDATE OF category_id ON om_category_x_gully 
FOR EACH ROW EXECUTE FUNCTION gw_trg_dma2category('gully', 'om_category');

DROP TRIGGER IF EXISTS gw_trg_om_visit_lot ON om_visit_lot;
CREATE TRIGGER gw_trg_om_visit_lot AFTER UPDATE OF status ON om_visit_lot 
FOR EACH ROW EXECUTE FUNCTION gw_trg_om_visit_lot();


