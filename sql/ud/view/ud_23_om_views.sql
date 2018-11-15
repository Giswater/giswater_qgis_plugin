/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;




DROP VIEW IF EXISTS v_ui_om_visit_x_gully CASCADE;
CREATE OR REPLACE VIEW v_ui_om_visit_x_gully AS 
SELECT om_visit_event.id AS event_id,
    om_visit.id AS visit_id,
    om_visit.ext_code,
    om_visit.visitcat_id,
    om_visit.startdate AS visit_start,
    om_visit.enddate AS visit_end,
    om_visit.user_name,
    om_visit.is_done,
    date_trunc('second', om_visit_event.tstamp) AS tstamp,
    om_visit_x_gully.gully_id,
    om_visit_event.parameter_id,
    om_visit_parameter.parameter_type,
    om_visit_parameter.feature_type,
    om_visit_parameter.form_type,
    om_visit_parameter.descript,
    om_visit_event.value,
    om_visit_event.xcoord,
    om_visit_event.ycoord,
    om_visit_event.compass,
    om_visit_event.event_code,
        CASE
            WHEN a.event_id IS NULL THEN false
            ELSE true
        END AS gallery,
        CASE
            WHEN b.visit_id IS NULL THEN false
            ELSE true
        END AS document
    FROM om_visit
    JOIN om_visit_event ON om_visit.id = om_visit_event.visit_id
    JOIN om_visit_x_gully ON om_visit_x_gully.visit_id = om_visit.id
    LEFT JOIN om_visit_parameter ON om_visit_parameter.id::text = om_visit_event.parameter_id::text
    LEFT JOIN ( SELECT DISTINCT om_visit_event_photo.event_id
           FROM om_visit_event_photo) a ON a.event_id = om_visit_event.id
    LEFT JOIN ( SELECT DISTINCT doc_x_visit.visit_id
           FROM doc_x_visit) b ON b.visit_id = om_visit.id
    ORDER BY om_visit_x_gully.gully_id;

	

	
	

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
    JOIN om_visit_cat ON om_visit_cat.id = v_ui_om_visit_x_gully.visitcat_id;
	
	
	

