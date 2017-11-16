
/*This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;



-- ----------------------------
-- MINCUT PRE-PROCESS
-- ----------------------------


CREATE OR REPLACE VIEW v_anl_mincut_selected_valve AS 
 SELECT 
 v_edit_man_valve.node_id,
 v_edit_man_valve.nodetype_id,
 closed,
 broken,
 the_geom
 FROM v_edit_man_valve
     JOIN man_valve ON v_edit_man_valve.node_id::text = man_valve.node_id::text
     JOIN anl_mincut_selector_valve ON nodetype_id::text = anl_mincut_selector_valve.id::text;





-- ----------------------------
-- MINCUT CATALOG
-- ----------------------------



DROP VIEW IF EXISTS "v_anl_mincut_result_arc" CASCADE; 
CREATE VIEW "v_anl_mincut_result_arc" AS 
SELECT 
anl_mincut_result_arc.id,
anl_mincut_result_arc.result_id,
anl_mincut_result_arc.arc_id,
arc.the_geom
FROM anl_mincut_result_selector, arc 
JOIN anl_mincut_result_arc ON anl_mincut_result_arc.arc_id::text = arc.arc_id::text
	WHERE anl_mincut_result_selector.result_id::text = anl_mincut_result_arc.result_id::text AND anl_mincut_result_selector.cur_user = "current_user"()::text
	ORDER BY anl_mincut_result_arc.arc_id;




DROP VIEW IF EXISTS "v_anl_mincut_result_node" CASCADE; 
CREATE VIEW "v_anl_mincut_result_node" AS
SELECT 
anl_mincut_result_node.id,
anl_mincut_result_node.result_id,
anl_mincut_result_node.node_id,  
node.the_geom 
FROM anl_mincut_result_selector, node
JOIN anl_mincut_result_node ON ((anl_mincut_result_node.node_id) = (node.node_id))
WHERE ((anl_mincut_result_selector.result_id::text) = (anl_mincut_result_node.result_id::text)) 
AND anl_mincut_result_selector.cur_user="current_user"()
GROUP BY anl_mincut_result_node.id, anl_mincut_result_selector.result_id, node.the_geom
ORDER BY anl_mincut_result_node.node_id;


DROP VIEW IF EXISTS "v_anl_mincut_result_valve" CASCADE;
CREATE VIEW "v_anl_mincut_result_valve" AS
SELECT 
anl_mincut_result_valve.id,
anl_mincut_result_valve.result_id,
node_id,
closed,
broken,
unaccess,
proposed,
the_geom
FROM anl_mincut_result_selector, anl_mincut_result_valve 
WHERE anl_mincut_result_selector.result_id::text = anl_mincut_result_valve.result_id::text
AND anl_mincut_result_selector.cur_user="current_user"();



DROP VIEW IF EXISTS "v_anl_mincut_result_connec";
CREATE OR REPLACE VIEW "v_anl_mincut_result_connec" AS 
SELECT
anl_mincut_result_connec.id,
anl_mincut_result_connec.result_id,
anl_mincut_result_connec.connec_id,  
connec.the_geom 
FROM anl_mincut_result_selector, connec
JOIN anl_mincut_result_connec ON (((anl_mincut_result_connec.connec_id) = (connec.connec_id)))
WHERE ((anl_mincut_result_selector.result_id::text) = (anl_mincut_result_connec.result_id::text))
AND anl_mincut_result_selector.cur_user="current_user"()
GROUP BY anl_mincut_result_connec.id, anl_mincut_result_selector.result_id, connec.the_geom
ORDER BY anl_mincut_result_connec.connec_id;




DROP VIEW IF EXISTS "v_anl_mincut_result_polygon";
CREATE OR REPLACE VIEW "v_anl_mincut_result_polygon" AS 
SELECT
anl_mincut_result_polygon.id,
anl_mincut_result_polygon.result_id,
anl_mincut_result_polygon.polygon_id,  
anl_mincut_result_polygon.the_geom 
FROM anl_mincut_result_polygon,anl_mincut_result_selector
WHERE ((anl_mincut_result_selector.result_id::text) = (anl_mincut_result_polygon.result_id::text))
AND anl_mincut_result_selector.cur_user="current_user"()
GROUP BY anl_mincut_result_polygon.id, anl_mincut_result_selector.result_id, anl_mincut_result_polygon.the_geom
ORDER BY anl_mincut_result_polygon.polygon_id;




DROP VIEW IF EXISTS "v_anl_mincut_result_hydrometer";
CREATE OR REPLACE VIEW "v_anl_mincut_result_hydrometer" AS 
SELECT
anl_mincut_result_hydrometer.id,
anl_mincut_result_hydrometer.result_id,
anl_mincut_result_hydrometer.hydrometer_id
FROM anl_mincut_result_hydrometer,anl_mincut_result_selector
WHERE ((anl_mincut_result_selector.result_id::text) = (anl_mincut_result_hydrometer.result_id::text))
AND anl_mincut_result_selector.cur_user="current_user"() 
GROUP BY anl_mincut_result_hydrometer.id, anl_mincut_result_selector.result_id
ORDER BY anl_mincut_result_hydrometer.hydrometer_id;




DROP VIEW IF EXISTS "v_ui_mincut_hydrometer";
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
JOIN rtc_hydrometer_x_connec ON rtc_hydrometer_x_connec.hydrometer_id=anl_mincut_result_hydrometer.hydrometer_id;



DROP VIEW IF EXISTS "v_ui_mincut_connec";
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


