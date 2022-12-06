/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2022/09/29
DROP TRIGGER IF EXISTS gw_trg_edit_setarcdata ON arc;
CREATE TRIGGER gw_trg_edit_setarcdata
  AFTER INSERT OR UPDATE OF node_1, node_2
  ON arc
  FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_edit_setarcdata('arc');


DROP TRIGGER IF EXISTS gw_trg_edit_setarcdata ON node;
CREATE TRIGGER gw_trg_edit_setarcdata
  AFTER INSERT OR UPDATE OF nodecat_id, elevation, depth, staticpressure
  ON node
  FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_edit_setarcdata('node');


CREATE TRIGGER gw_trg_edit_review_node
  INSTEAD OF INSERT OR UPDATE
  ON v_edit_review_node
  FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_edit_review_node();
  
CREATE TRIGGER gw_trg_edit_review_connec
  INSTEAD OF INSERT OR UPDATE
  ON v_edit_review_connec
  FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_edit_review_connec();

CREATE TRIGGER gw_trg_edit_review_arc
  INSTEAD OF INSERT OR UPDATE
  ON v_edit_review_arc
  FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_edit_review_arc();

DROP TRIGGER IF EXISTS gw_trg_edit_inp_arc_virtualvalve ON v_edit_inp_virtualvalve;
CREATE TRIGGER gw_trg_edit_inp_arc_virtualvalve
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON v_edit_inp_virtualvalve
  FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_edit_inp_arc('inp_virtualvalve');


CREATE TRIGGER gw_trg_edit_inp_dscenario
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON v_edit_inp_dscenario_virtualvalve
  FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_edit_inp_dscenario('VIRTUALVALVE');


CREATE TRIGGER gw_trg_edit_link
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON v_edit_link
  FOR EACH ROW 
  EXECUTE PROCEDURE gw_trg_edit_link();
