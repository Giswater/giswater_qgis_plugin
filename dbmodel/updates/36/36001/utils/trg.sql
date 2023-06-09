/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

DROP TRIGGER gw_trg_link_data ON link;

CREATE TRIGGER gw_trg_link_data  AFTER INSERT OR UPDATE of the_geom ON link
FOR EACH ROW EXECUTE PROCEDURE gw_trg_link_data('link');

CREATE OR REPLACE VIEW v_ui_om_visit
AS SELECT om_visit.id,
    om_visit_cat.name AS visit_catalog,
    om_visit.ext_code,
    om_visit.startdate,
    om_visit.enddate,
    om_visit.user_name,
    om_visit.webclient_id,
    exploitation.name AS exploitation,
    om_visit.the_geom,
    om_visit.descript,
    om_visit.is_done,
    om_visit.visit_type
   FROM om_visit
     LEFT JOIN om_visit_cat ON om_visit.visitcat_id = om_visit_cat.id
     LEFT JOIN exploitation ON exploitation.expl_id = om_visit.expl_id;
     