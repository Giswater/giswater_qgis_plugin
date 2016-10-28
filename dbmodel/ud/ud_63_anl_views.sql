/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
SET search_path = "SCHEMA_NAME", public, pg_catalog;

-- ----------------------------
-- FLOWTRACE
-- ----------------------------


DROP VIEW IF EXISTS v_anl_flowtrace_connec;
CREATE OR REPLACE VIEW v_anl_flowtrace_connec AS 
SELECT
connec_id,
v_edit_connec.the_geom
FROM anl_flowtrace_arc
JOIN v_edit_connec on v_edit_connec.arc_id=anl_flowtrace_arc.arc_id;


DROP VIEW IF EXISTS v_anl_flowtrace_hydrometer;
CREATE OR REPLACE VIEW v_anl_flowtrace_hydrometer AS 
SELECT
hydrometer_id,
v_edit_connec.connec_id,
code,
anl_flowtrace_arc.arc_id
FROM anl_flowtrace_arc
JOIN v_edit_connec on v_edit_connec.arc_id=anl_flowtrace_arc.arc_id
JOIN rtc_hydrometer_x_connec on rtc_hydrometer_x_connec.connec_id=v_edit_connec.connec_id;



