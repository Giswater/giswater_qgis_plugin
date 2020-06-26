/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2020/06/26
CREATE OR REPLACE VIEW v_ui_om_visitman_x_gully AS 
SELECT DISTINCT ON (v_ui_om_visit_x_gully.visit_id) v_ui_om_visit_x_gully.visit_id,
    v_ui_om_visit_x_gully.ext_code,
    om_visit_cat.name AS visitcat_name,
    v_ui_om_visit_x_gully.gully_id,
    date_trunc('second'::text, v_ui_om_visit_x_gully.visit_start) AS visit_start,
    date_trunc('second'::text, v_ui_om_visit_x_gully.visit_end) AS visit_end,
    v_ui_om_visit_x_gully.user_name,
    v_ui_om_visit_x_gully.is_done,
    v_ui_om_visit_x_gully.feature_type,
    v_ui_om_visit_x_gully.form_type
    FROM v_ui_om_visit_x_gully
    LEFT JOIN om_visit_cat ON om_visit_cat.id = v_ui_om_visit_x_gully.visitcat_id;
	
	
DROP VIEW IF EXISTS v_edit_review_arc;
CREATE OR REPLACE VIEW v_edit_review_arc AS 
 SELECT review_arc.arc_id,
	arc.node_1,
    review_arc.y1,
	arc.node_2,
    review_arc.y2,
    review_arc.arc_type,
    review_arc.matcat_id,
    review_arc.arccat_id,
    review_arc.annotation,
    review_arc.observ,
    review_arc.expl_id,
    review_arc.the_geom,
    review_arc.field_checked,
    review_arc.is_validated
   FROM selector_expl,
    review_arc
	JOIN arc ON review_arc.arc_id::text = arc.arc_id::text
  WHERE selector_expl.cur_user = "current_user"()::text AND review_arc.expl_id = selector_expl.expl_id;

DROP TRIGGER IF EXISTS gw_trg_edit_review_arc ON v_edit_review_arc;
CREATE TRIGGER gw_trg_edit_review_arc
  INSTEAD OF INSERT OR UPDATE
  ON v_edit_review_arc
  FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_edit_review_arc();
