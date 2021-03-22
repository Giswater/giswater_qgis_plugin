/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2021/03/22
DROP VIEW IF EXISTS v_edit_review_audit_gully;
CREATE OR REPLACE VIEW v_edit_review_audit_gully AS 
 SELECT review_audit_gully.id,
    review_audit_gully.gully_id,
    review_audit_gully.old_top_elev,
    review_audit_gully.new_top_elev,
    review_audit_gully.old_ymax,
    review_audit_gully.new_ymax,
    review_audit_gully.old_sandbox,
    review_audit_gully.new_sandbox,
    review_audit_gully.old_matcat_id,
    review_audit_gully.new_matcat_id,
    review_audit_gully.old_gully_type,
    review_audit_gully.new_gully_type,
    review_audit_gully.old_gratecat_id,
    review_audit_gully.new_gratecat_id,
    review_audit_gully.old_units,
    review_audit_gully.new_units,
    review_audit_gully.old_groove,
    review_audit_gully.new_groove,
    review_audit_gully.old_siphon,
    review_audit_gully.new_siphon,
    review_audit_gully.old_connec_arccat_id,
    review_audit_gully.new_connec_arccat_id,
    review_audit_gully.old_featurecat_id,
    review_audit_gully.new_featurecat_id,
    review_audit_gully.old_feature_id,
    review_audit_gully.new_feature_id,
    review_audit_gully.old_annotation,
    review_audit_gully.new_annotation,
    review_audit_gully.old_observ,
    review_audit_gully.new_observ,
    review_audit_gully.expl_id,
    review_audit_gully.the_geom,
    review_audit_gully.review_status_id,
    review_audit_gully.field_date,
    review_audit_gully.field_user,
    review_audit_gully.is_validated
   FROM review_audit_gully,
    selector_expl
  WHERE selector_expl.cur_user = "current_user"()::text AND review_audit_gully.expl_id = selector_expl.expl_id AND review_audit_gully.review_status_id <> 0;
  
  
  
DROP VIEW IF EXISTS v_edit_review_gully;
CREATE OR REPLACE VIEW v_edit_review_gully AS 
 SELECT review_gully.gully_id,
    review_gully.top_elev,
    review_gully.ymax,
    review_gully.sandbox,
    review_gully.matcat_id,
    review_gully.gully_type,
    review_gully.gratecat_id,
    review_gully.units,
    review_gully.groove,
    review_gully.siphon,
    review_gully.connec_arccat_id,
    review_gully.featurecat_id,
    review_gully.feature_id,
    review_gully.annotation,
    review_gully.observ,
    review_gully.expl_id,
    review_gully.the_geom,
    review_gully.field_checked,
    review_gully.is_validated
   FROM review_gully,
    selector_expl
  WHERE selector_expl.cur_user = "current_user"()::text AND review_gully.expl_id = selector_expl.expl_id;


SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"review_audit_gully", "column":"old_connec_matcat_id"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"review_audit_gully", "column":"new_connec_matcat_id"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"review_gully", "column":"connec_matcat_id"}}$$);

