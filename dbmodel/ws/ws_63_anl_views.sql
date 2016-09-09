/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


-- ----------------------------
-- MINCUT
-- ----------------------------

DROP VIEW IF EXISTS SCHEMA_NAME.v_anl_mincut_connec;
CREATE OR REPLACE VIEW SCHEMA_NAME.v_anl_mincut_connec AS 
SELECT
connec_id,
v_edit_connec.the_geom
FROM SCHEMA_NAME.anl_mincut_arc
JOIN SCHEMA_NAME.v_edit_connec on v_edit_connec.arc_id=anl_mincut_arc.arc_id;


DROP VIEW IF EXISTS SCHEMA_NAME.v_anl_mincut_hydrometer;
CREATE OR REPLACE VIEW SCHEMA_NAME.v_anl_mincut_hydrometer AS 
SELECT
hydrometer_id,
v_edit_connec.connec_id,
code,
anl_mincut_arc.arc_id
FROM SCHEMA_NAME.anl_mincut_arc
JOIN SCHEMA_NAME.v_edit_connec on v_edit_connec.arc_id=anl_mincut_arc.arc_id
JOIN SCHEMA_NAME.rtc_hydrometer_x_connec on rtc_hydrometer_x_connec.connec_id=v_edit_connec.connec_id;


