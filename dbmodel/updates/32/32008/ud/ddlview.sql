/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;

CREATE OR REPLACE VIEW v_ui_arc_x_relations AS 
SELECT row_number() OVER () + 1000000 AS rid,
    arc_id,
    v_edit_connec.connec_type AS featurecat_id,
    v_edit_connec.connecat_id AS catalog,
    v_edit_connec.connec_id AS feature_id,
    v_edit_connec.code AS feature_code,
    v_edit_connec.sys_type,
    state AS arc_state,
    v_edit_connec.state AS feature_state,
    st_x(v_edit_connec.the_geom) AS x,
    st_y(v_edit_connec.the_geom) AS y,
    featurecat_id AS proceed_from,
    feature_id AS proceed_from_id
   FROM v_edit_connec
  WHERE v_edit_connec.arc_id IS NOT NULL
UNION
 SELECT row_number() OVER () + 2000000 AS rid,
    v_edit_gully.arc_id,
    v_edit_gully.gully_type AS featurecat_id,
    v_edit_gully.gratecat_id AS catalog,
    v_edit_gully.gully_id AS feature_id,
    v_edit_gully.code AS feature_code,
    v_edit_gully.sys_type,
    v_edit_gully.state as arc_state,
    v_edit_gully.state AS feature_state,
    st_x(v_edit_gully.the_geom) AS x,
    st_y(v_edit_gully.the_geom) AS y,
    featurecat_id AS proceed_from,
    feature_id AS proceed_from_id
   FROM v_edit_gully
  WHERE v_edit_gully.arc_id IS NOT NULL;
