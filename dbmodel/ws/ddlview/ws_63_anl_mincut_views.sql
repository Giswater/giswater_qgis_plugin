/*This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;



-- ----------------------------
-- MINCUT CATALOG
-- ----------------------------

-- graf auxiliar view
DROP VIEW IF EXISTS "v_anl_mincut_flowtrace" CASCADE; 
CREATE OR REPLACE VIEW v_anl_mincut_flowtrace AS 
WITH nodes_a AS (
    SELECT node_id_a
    FROM anl_mincut_arc_x_node
    WHERE water = 1)
SELECT anl_mincut_arc_x_node.node_id,
	anl_mincut_arc_x_node.arc_id
	FROM anl_mincut_arc_x_node
	LEFT JOIN nodes_a ON anl_mincut_arc_x_node.node_id = nodes_a.node_id_a
	WHERE anl_mincut_arc_x_node.flag1 = 0 AND nodes_a.node_id_a IS NOT NULL OR anl_mincut_arc_x_node.flag1 = 1 AND user_name=current_user;


DROP VIEW IF EXISTS "v_anl_mincut_result_cat" CASCADE; 
CREATE OR REPLACE VIEW v_anl_mincut_result_cat AS
SELECT 
anl_mincut_result_cat.id,
work_order,
anl_mincut_cat_state.name as state,
anl_mincut_cat_class.name as class,
mincut_type,
received_date,
anl_mincut_result_cat.expl_id,
exploitation.name AS expl_name,
macroexploitation.name AS macroexpl_name,
anl_mincut_result_cat.macroexpl_id,
anl_mincut_result_cat.muni_id,
ext_municipality.name AS muni_name,
postcode,
streetaxis_id,
ext_streetaxis.name AS street_name,
postnumber,
anl_cause,
anl_tstamp ,
anl_user,
anl_descript,
anl_feature_id,
anl_feature_type,
anl_the_geom,
forecast_start,
forecast_end,
assigned_to,
exec_start,
exec_end,
exec_user,
exec_descript,
exec_the_geom,
exec_from_plot,
exec_depth,
exec_appropiate
FROM anl_mincut_result_selector, anl_mincut_result_cat
LEFT JOIN anl_mincut_cat_class ON anl_mincut_cat_class.id = mincut_class
LEFT JOIN anl_mincut_cat_state ON anl_mincut_cat_state.id = mincut_state
LEFT JOIN exploitation ON anl_mincut_result_cat.expl_id = exploitation.expl_id
LEFT JOIN ext_streetaxis ON anl_mincut_result_cat.streetaxis_id::text = ext_streetaxis.id::text
LEFT JOIN macroexploitation ON anl_mincut_result_cat.macroexpl_id = macroexploitation.macroexpl_id
LEFT JOIN ext_municipality ON anl_mincut_result_cat.muni_id = ext_streetaxis.muni_id
	WHERE anl_mincut_result_selector.result_id = anl_mincut_result_cat.id AND anl_mincut_result_selector.cur_user = "current_user"()::text;


DROP VIEW IF EXISTS "v_anl_mincut_selected_valve" CASCADE; 
CREATE OR REPLACE VIEW v_anl_mincut_selected_valve AS 
 SELECT 
 v_edit_man_valve.node_id,
 v_edit_man_valve.nodetype_id,
 man_valve.closed,
 man_valve.broken,
 the_geom
 FROM v_edit_man_valve
     JOIN man_valve ON v_edit_man_valve.node_id::text = man_valve.node_id::text
     JOIN anl_mincut_selector_valve ON nodetype_id::text = anl_mincut_selector_valve.id::text;


DROP VIEW IF EXISTS "v_anl_mincut_result_arc" CASCADE; 
CREATE VIEW "v_anl_mincut_result_arc" AS 
SELECT 
anl_mincut_result_arc.id,
anl_mincut_result_arc.result_id,
anl_mincut_result_cat.work_order,
anl_mincut_result_arc.arc_id,
arc.the_geom
FROM anl_mincut_result_selector, arc 
JOIN anl_mincut_result_arc ON anl_mincut_result_arc.arc_id::text = arc.arc_id::text
JOIN anl_mincut_result_cat ON anl_mincut_result_arc.result_id=anl_mincut_result_cat.id
	WHERE anl_mincut_result_selector.result_id::text = anl_mincut_result_arc.result_id::text AND anl_mincut_result_selector.cur_user = "current_user"()::text
	ORDER BY anl_mincut_result_arc.arc_id;


DROP VIEW IF EXISTS "v_anl_mincut_result_node" CASCADE; 
CREATE VIEW "v_anl_mincut_result_node" AS
SELECT 
anl_mincut_result_node.id,
anl_mincut_result_node.result_id,
anl_mincut_result_cat.work_order,
anl_mincut_result_node.node_id,  
node.the_geom 
FROM anl_mincut_result_selector, node
JOIN anl_mincut_result_node ON ((anl_mincut_result_node.node_id) = (node.node_id))
JOIN anl_mincut_result_cat ON anl_mincut_result_node.result_id=anl_mincut_result_cat.id
WHERE ((anl_mincut_result_selector.result_id::text) = (anl_mincut_result_node.result_id::text)) 
AND anl_mincut_result_selector.cur_user="current_user"();


DROP VIEW IF EXISTS "v_anl_mincut_result_valve" CASCADE;
CREATE VIEW "v_anl_mincut_result_valve" AS
SELECT 
anl_mincut_result_valve.id,
anl_mincut_result_valve.result_id,
anl_mincut_result_cat.work_order,
node_id,
closed,
broken,
unaccess,
proposed,
the_geom
FROM anl_mincut_result_selector, anl_mincut_result_valve
JOIN anl_mincut_result_cat ON anl_mincut_result_valve.result_id=anl_mincut_result_cat.id
WHERE anl_mincut_result_selector.result_id::text = anl_mincut_result_valve.result_id::text
AND anl_mincut_result_selector.cur_user="current_user"();


DROP VIEW IF EXISTS "v_anl_mincut_result_connec" CASCADE;
CREATE OR REPLACE VIEW "v_anl_mincut_result_connec" AS 
SELECT
anl_mincut_result_connec.id,
anl_mincut_result_connec.result_id,
anl_mincut_result_cat.work_order,
anl_mincut_result_connec.connec_id,
connec.customer_code,  
connec.the_geom 
FROM anl_mincut_result_selector, connec
JOIN anl_mincut_result_connec ON (((anl_mincut_result_connec.connec_id) = (connec.connec_id)))
JOIN anl_mincut_result_cat ON anl_mincut_result_connec.result_id=anl_mincut_result_cat.id
WHERE ((anl_mincut_result_selector.result_id::text) = (anl_mincut_result_connec.result_id::text))
AND anl_mincut_result_selector.cur_user="current_user"();


DROP VIEW IF EXISTS "v_anl_mincut_result_polygon" CASCADE;
CREATE OR REPLACE VIEW "v_anl_mincut_result_polygon" AS 
SELECT
anl_mincut_result_polygon.id,
anl_mincut_result_polygon.result_id,
anl_mincut_result_cat.work_order,
anl_mincut_result_polygon.polygon_id,  
anl_mincut_result_polygon.the_geom 
FROM anl_mincut_result_selector, anl_mincut_result_polygon
JOIN anl_mincut_result_cat ON anl_mincut_result_polygon.result_id=anl_mincut_result_cat.id
WHERE ((anl_mincut_result_selector.result_id::text) = (anl_mincut_result_polygon.result_id::text))
AND anl_mincut_result_selector.cur_user="current_user"();



DROP VIEW IF EXISTS "v_anl_mincut_result_hydrometer" CASCADE;
CREATE OR REPLACE VIEW "v_anl_mincut_result_hydrometer" AS 
SELECT
anl_mincut_result_hydrometer.id,
anl_mincut_result_hydrometer.result_id,
anl_mincut_result_cat.work_order,
anl_mincut_result_hydrometer.hydrometer_id,
ext_rtc_hydrometer.code AS hydrometer_customer_code,
rtc_hydrometer_x_connec.connec_id
FROM anl_mincut_result_selector, anl_mincut_result_hydrometer
JOIN ext_rtc_hydrometer ON anl_mincut_result_hydrometer.hydrometer_id::int8 = ext_rtc_hydrometer.id::int8
JOIN rtc_hydrometer_x_connec ON anl_mincut_result_hydrometer.hydrometer_id::text = rtc_hydrometer_x_connec.hydrometer_id::text
JOIN anl_mincut_result_cat ON anl_mincut_result_hydrometer.result_id=anl_mincut_result_cat.id
WHERE ((anl_mincut_result_selector.result_id::text) = (anl_mincut_result_hydrometer.result_id::text))
AND anl_mincut_result_selector.cur_user="current_user"() ;


DROP VIEW IF EXISTS "v_ui_mincut_hydrometer" CASCADE;
CREATE OR REPLACE VIEW "v_ui_mincut_hydrometer" AS 
SELECT
anl_mincut_result_hydrometer.id,
anl_mincut_result_hydrometer.hydrometer_id,
connec_id,
anl_mincut_result_hydrometer.result_id,
work_order,
mincut_state,
mincut_class,
mincut_type,
received_date,
anl_cause,
anl_tstamp,
anl_user,
anl_descript,
forecast_start,
forecast_end,
exec_start,
exec_end,
exec_user,
exec_descript,
exec_appropiate,
        CASE
            WHEN anl_mincut_result_cat.mincut_state = 0 THEN anl_mincut_result_cat.forecast_start::timestamp with time zone
            WHEN anl_mincut_result_cat.mincut_state = 1 THEN now()
            WHEN anl_mincut_result_cat.mincut_state = 2 THEN anl_mincut_result_cat.exec_start::timestamp with time zone
            ELSE NULL::timestamp with time zone
        END AS start_date,
        CASE
            WHEN anl_mincut_result_cat.mincut_state = 0 THEN anl_mincut_result_cat.forecast_end::timestamp with time zone
            WHEN anl_mincut_result_cat.mincut_state = 1 THEN now()
            WHEN anl_mincut_result_cat.mincut_state = 2 THEN anl_mincut_result_cat.exec_end::timestamp with time zone
            ELSE NULL::timestamp with time zone
        END AS end_date
FROM anl_mincut_result_hydrometer
JOIN anl_mincut_result_cat ON anl_mincut_result_hydrometer.result_id = anl_mincut_result_cat.id
JOIN rtc_hydrometer_x_connec ON rtc_hydrometer_x_connec.hydrometer_id::int8=anl_mincut_result_hydrometer.hydrometer_id::int8;



DROP VIEW IF EXISTS "v_ui_mincut_connec" CASCADE;
CREATE OR REPLACE VIEW "v_ui_mincut_connec" AS 
SELECT
anl_mincut_result_connec.id,
anl_mincut_result_connec.connec_id,
anl_mincut_result_connec.result_id,
work_order,
mincut_state,
mincut_class,
mincut_type,
virtual,
received_date,
anl_cause,
anl_tstamp,
anl_user,
anl_descript,
forecast_start,
forecast_end,
exec_start,
exec_end,
exec_user,
exec_descript,
exec_appropiate,
        CASE
            WHEN anl_mincut_result_cat.mincut_state = 0 THEN anl_mincut_result_cat.forecast_start::timestamp with time zone
            WHEN anl_mincut_result_cat.mincut_state = 1 THEN now()
            WHEN anl_mincut_result_cat.mincut_state = 2 THEN anl_mincut_result_cat.exec_start::timestamp with time zone
            ELSE NULL::timestamp with time zone
        END AS start_date,
        CASE
            WHEN anl_mincut_result_cat.mincut_state = 0 THEN anl_mincut_result_cat.forecast_end::timestamp with time zone
            WHEN anl_mincut_result_cat.mincut_state = 1 THEN now()
            WHEN anl_mincut_result_cat.mincut_state = 2 THEN anl_mincut_result_cat.exec_end::timestamp with time zone
            ELSE NULL::timestamp with time zone
        END AS end_date
FROM anl_mincut_result_connec
JOIN anl_mincut_result_cat ON anl_mincut_result_connec.result_id = anl_mincut_result_cat.id
JOIN anl_mincut_cat_type ON mincut_type=anl_mincut_cat_type.id;

-- ----------------------------
-- MINCUT MANAGER VIEW
-- ----------------------------

DROP VIEW IF EXISTS "v_ui_anl_mincut_result_cat" CASCADE;
CREATE OR REPLACE VIEW "v_ui_anl_mincut_result_cat" AS
SELECT
anl_mincut_result_cat.id,
anl_mincut_result_cat.id as name,
work_order,
anl_mincut_cat_state.name as state,
anl_mincut_cat_class.name as class,
mincut_type,
received_date,
expl_id,
macroexpl_id,
muni_id,
postcode,
streetaxis_id,
postnumber,
anl_cause,
anl_tstamp ,
anl_user,
anl_descript,
anl_feature_id,
anl_feature_type,
anl_the_geom,
forecast_start,
forecast_end,
assigned_to,
exec_start,
exec_end,
exec_user,
exec_descript,
exec_the_geom,
exec_from_plot,
exec_depth,
exec_appropiate
FROM anl_mincut_result_cat
LEFT JOIN anl_mincut_cat_class ON anl_mincut_cat_class.id = mincut_class
LEFT JOIN anl_mincut_cat_state ON anl_mincut_cat_state.id = mincut_state;

-- ----------------------------
-- MINCUT RESULT AUDIT VIEW
-- ----------------------------

DROP VIEW IF EXISTS "v_anl_mincut_result_audit" CASCADE;
CREATE OR REPLACE VIEW "v_anl_mincut_result_audit" AS 
 SELECT audit_log_data.id,
    audit_log_data.feature_id,
    audit_log_data.log_message,
    arc.the_geom
   FROM audit_log_data
     JOIN arc ON arc.arc_id::text = audit_log_data.feature_id::text
  WHERE audit_log_data.fprocesscat_id = 29 AND audit_log_data.user_name = "current_user"()::text
  ORDER BY audit_log_data.log_message;
    
-- ----------------------------
-- MINCUT CONFLICT
-- ----------------------------

DROP VIEW IF EXISTS "v_anl_mincut_result_conflict_arc" CASCADE;    
CREATE VIEW v_anl_mincut_result_conflict_arc AS
SELECT * FROM anl_arc WHERE fprocesscat_id=31 AND cur_user=current_user;

DROP VIEW IF EXISTS "v_anl_mincut_result_conflict_valve" CASCADE; 
CREATE VIEW v_anl_mincut_result_conflict_valve AS
SELECT * FROM anl_node WHERE fprocesscat_id=31 AND cur_user=current_user;

-- ----------------------------
-- MINCUT FORECAST
-- ----------------------------

DROP VIEW IF EXISTS "v_anl_mincut_planified_arc" CASCADE; 
CREATE VIEW v_anl_mincut_planified_arc AS
SELECT anl_mincut_result_arc.id, result_id, arc_id, forecast_start, forecast_end, the_geom FROM anl_mincut_result_arc
JOIN anl_mincut_result_cat ON anl_mincut_result_cat.id=result_id WHERE mincut_state<2;

DROP VIEW IF EXISTS "v_anl_mincut_planified_valve" CASCADE; 
CREATE VIEW v_anl_mincut_planified_valve AS
SELECT anl_mincut_result_valve.id, result_id, node_id, closed, unaccess, proposed, forecast_start, forecast_end, the_geom FROM anl_mincut_result_valve
JOIN anl_mincut_result_cat ON anl_mincut_result_cat.id=result_id WHERE mincut_state<2 and proposed=true;


