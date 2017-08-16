/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
SET search_path = "SCHEMA_NAME", public, pg_catalog;

-- ----------------------------
-- FLOWTRACE
-- ----------------------------

DROP VIEW IF EXISTS v_anl_flowtrace_arc;
CREATE OR REPLACE VIEW v_anl_flowtrace_arc AS 
SELECT
arc_id,
the_geom
FROM anl_flow_trace_arc

;

DROP VIEW IF EXISTS v_anl_flowtrace_node;
CREATE OR REPLACE VIEW v_anl_flowtrace_node AS 
SELECT
node_id,
the_geom
FROM anl_flow_trace_node

;

DROP VIEW IF EXISTS v_anl_flowexit_arc;
CREATE OR REPLACE VIEW v_anl_flowexit_arc AS 
SELECT
arc_id,
the_geom
FROM anl_flow_trace_arc

;

DROP VIEW IF EXISTS v_anl_flowtrace_node;
CREATE OR REPLACE VIEW v_anl_flowtrace_node AS 
SELECT
node_id,
the_geom
FROM anl_flow_trace_node

;



DROP VIEW IF EXISTS v_anl_flowtrace_connec;
CREATE OR REPLACE VIEW v_anl_flowtrace_connec AS 
SELECT
connec_id,
v_edit_connec.the_geom
FROM anl_flow_trace_arc
JOIN v_edit_connec on v_edit_connec.arc_id=anl_flow_trace_arc.arc_id;


DROP VIEW IF EXISTS v_anl_flowtrace_hydrometer;
CREATE OR REPLACE VIEW v_anl_flowtrace_hydrometer AS 
SELECT
hydrometer_id,
v_edit_connec.connec_id,
code,
anl_flow_trace_arc.arc_id
FROM anl_flow_trace_arc
JOIN v_edit_connec on v_edit_connec.arc_id=anl_flow_trace_arc.arc_id
JOIN rtc_hydrometer_x_connec on rtc_hydrometer_x_connec.connec_id=v_edit_connec.connec_id;

/*
DROP VIEW IF EXISTS v_anl_dwf_connec;
CREATE OR REPLACE VIEW v_anl_dwf_connec AS 
 SELECT connec.connec_id,
    anl_dwf_selector_scenario.scenario_id,
    connec.code,
    anl_dwf_connec_x_uses_value.m3dia,
    connec.the_geom
   FROM connec
     JOIN anl_dwf_connec_x_uses_value ON anl_dwf_connec_x_uses_value.connec_id = connec.connec_id
     JOIN anl_dwf_selector_scenario ON anl_dwf_selector_scenario.scenario_id = anl_dwf_connec_x_uses_value.scenario_id;
 */
	 
DROP VIEW IF EXISTS v_anl_node_sink CASCADE;
CREATE OR REPLACE VIEW v_anl_node_sink AS
SELECT
anl_node_sink.node_id,
anl_node_sink.num_arcs,
anl_node_sink.the_geom,
node.expl_id
FROM selector_expl, anl_node_sink
JOIN node ON node.node_id=anl_node_sink.node_id
WHERE ((node.expl_id)=(selector_expl.expl_id)
AND selector_expl.cur_user="current_user"());


DROP VIEW IF EXISTS v_anl_flow_exit_node CASCADE;
CREATE OR REPLACE VIEW v_anl_flow_exit_node AS
SELECT
anl_flow_exit_node.node_id,
anl_flow_exit_node.the_geom,
node.expl_id
FROM selector_expl, anl_flow_exit_node
JOIN node ON node.node_id=anl_flow_exit_node.node_id
WHERE ((node.expl_id)=(selector_expl.expl_id)
AND selector_expl.cur_user="current_user"());


DROP VIEW IF EXISTS v_anl_flow_exit_arc CASCADE;
CREATE OR REPLACE VIEW v_anl_flow_exit_arc AS
SELECT
anl_flow_exit_arc.arc_id,
anl_flow_exit_arc.the_geom,
arc.expl_id
FROM selector_expl, anl_flow_exit_arc
JOIN arc ON arc.arc_id=anl_flow_exit_arc.arc_id
WHERE ((arc.expl_id)=(selector_expl.expl_id)
AND selector_expl.cur_user="current_user"());


DROP VIEW IF EXISTS v_anl_flow_trace_node CASCADE;
CREATE OR REPLACE VIEW v_anl_flow_trace_node AS
SELECT
anl_flow_trace_node.node_id,
anl_flow_trace_node.the_geom,
node.expl_id
FROM selector_expl, anl_flow_trace_node
JOIN node ON node.node_id=anl_flow_trace_node.node_id
WHERE ((node.expl_id)=(selector_expl.expl_id)
AND selector_expl.cur_user="current_user"());


DROP VIEW IF EXISTS v_anl_flow_trace_arc CASCADE;
CREATE OR REPLACE VIEW v_anl_flow_trace_arc AS
SELECT
anl_flow_trace_arc.arc_id,
anl_flow_trace_arc.the_geom,
arc.expl_id
FROM selector_expl, anl_flow_trace_arc
JOIN arc ON arc.arc_id=anl_flow_trace_arc.arc_id
WHERE ((arc.expl_id)=(selector_expl.expl_id)
AND selector_expl.cur_user="current_user"());
