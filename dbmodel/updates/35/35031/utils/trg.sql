/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


DROP TRIGGER IF EXISTS gw_trg_plan_psector ON plan_psector;
CREATE TRIGGER gw_trg_plan_psector
AFTER INSERT OR UPDATE OF active 
ON plan_psector 
FOR EACH ROW 
EXECUTE PROCEDURE gw_trg_plan_psector();

DROP TRIGGER IF EXISTS gw_trg_arc_vnodelink_update ON arc;
CREATE TRIGGER gw_trg_arc_link_update
  AFTER UPDATE OF the_geom
  ON arc
  FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_arc_link_update();

DROP TRIGGER IF EXISTS gw_trg_cat_feature ON cat_feature;

CREATE TRIGGER gw_trg_cat_feature_after
    AFTER INSERT OR DELETE OR UPDATE 
    ON cat_feature
    FOR EACH ROW
    EXECUTE PROCEDURE gw_trg_cat_feature();
    
    CREATE TRIGGER gw_trg_cat_feature_delete
    BEFORE DELETE
    ON cat_feature
    FOR EACH ROW
    EXECUTE PROCEDURE gw_trg_cat_feature('DELETE');