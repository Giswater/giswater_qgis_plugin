/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- v_plan_netscenario views

CREATE OR REPLACE VIEW v_plan_netscenario_node AS
WITH plan_netscenario_current AS (
  SELECT value::integer AS netscenario_id
  FROM config_param_user
  WHERE cur_user = CURRENT_USER
    AND parameter = 'plan_netscenario_current'
  LIMIT 1
), sel_expl AS (
    SELECT selector_expl.expl_id
    FROM selector_expl
    WHERE selector_expl.cur_user = CURRENT_USER
)
SELECT
    n.netscenario_id,
    n.node_id,
    n.presszone_id,
    n.staticpressure,
    n.dma_id,
    n.pattern_id,
    n.the_geom,
    nd.nodecat_id,
    cn.node_type,
    nd.epa_type,
    nd.state,
    nd.state_type
FROM plan_netscenario_node n
JOIN plan_netscenario p ON n.netscenario_id = p.netscenario_id
LEFT JOIN node nd USING (node_id)
LEFT JOIN cat_node cn ON nd.nodecat_id::text = cn.id::text
JOIN plan_netscenario_current pnc ON n.netscenario_id = pnc.netscenario_id
WHERE EXISTS (SELECT 1 FROM sel_expl WHERE sel_expl.expl_id = p.expl_id);

CREATE OR REPLACE VIEW v_plan_netscenario_connec
AS WITH plan_netscenario_current AS (
  SELECT value::integer AS netscenario_id
  FROM config_param_user
  WHERE cur_user = CURRENT_USER
    AND parameter = 'plan_netscenario_current'
  LIMIT 1
), sel_expl AS (
    SELECT selector_expl.expl_id
    FROM selector_expl
    WHERE selector_expl.cur_user = CURRENT_USER
)
SELECT n.netscenario_id,
    n.connec_id,
    n.presszone_id,
    n.staticpressure,
    n.dma_id,
    n.pattern_id,
    n.the_geom,
    c.conneccat_id,
    cc.connec_type,
    c.epa_type,
    c.state,
    c.state_type
FROM plan_netscenario_connec n
JOIN plan_netscenario p ON n.netscenario_id = p.netscenario_id
LEFT JOIN connec c USING (connec_id)
LEFT JOIN cat_connec cc ON cc.id::text = c.conneccat_id::text
JOIN plan_netscenario_current pnc ON n.netscenario_id = pnc.netscenario_id
WHERE EXISTS (SELECT 1 FROM sel_expl WHERE sel_expl.expl_id = p.expl_id);

CREATE OR REPLACE VIEW v_plan_netscenario_arc
AS WITH plan_netscenario_current AS (
  SELECT value::integer AS netscenario_id
  FROM config_param_user
  WHERE cur_user = CURRENT_USER
    AND parameter = 'plan_netscenario_current'
  LIMIT 1
), sel_expl AS (
    SELECT selector_expl.expl_id
    FROM selector_expl
    WHERE selector_expl.cur_user = CURRENT_USER
)
SELECT n.netscenario_id,
    n.arc_id,
    n.presszone_id,
    n.dma_id,
    n.the_geom,
    a.arccat_id,
    a.epa_type,
    a.state,
    a.state_type
FROM plan_netscenario_arc n
JOIN plan_netscenario p ON n.netscenario_id = p.netscenario_id
LEFT JOIN arc a USING (arc_id)
JOIN plan_netscenario_current pnc ON n.netscenario_id = pnc.netscenario_id
WHERE EXISTS (SELECT 1 FROM sel_expl WHERE sel_expl.expl_id = p.expl_id);

CREATE OR REPLACE VIEW ve_plan_netscenario_valve
AS WITH plan_netscenario_current AS (
  SELECT value::integer AS netscenario_id
  FROM config_param_user
  WHERE cur_user = CURRENT_USER
    AND parameter = 'plan_netscenario_current'
  LIMIT 1
), sel_expl AS (
    SELECT selector_expl.expl_id
    FROM selector_expl
    WHERE selector_expl.cur_user = CURRENT_USER
)
SELECT v.netscenario_id,
    v.node_id,
    v.closed,
    n.the_geom
FROM plan_netscenario_valve v
JOIN node n USING (node_id)
JOIN plan_netscenario_current pnc ON v.netscenario_id = pnc.netscenario_id
WHERE EXISTS (SELECT 1 FROM sel_expl WHERE sel_expl.expl_id = n.expl_id);

CREATE OR REPLACE VIEW ve_plan_netscenario_presszone
AS WITH plan_netscenario_current AS (
  SELECT value::integer AS netscenario_id
  FROM config_param_user
  WHERE cur_user = CURRENT_USER
    AND parameter = 'plan_netscenario_current'
  LIMIT 1
), sel_expl AS (
    SELECT selector_expl.expl_id
    FROM selector_expl
    WHERE selector_expl.cur_user = CURRENT_USER
)
SELECT n.netscenario_id,
    p.name AS netscenario_name,
    n.presszone_id,
    n.presszone_name AS name,
    n.head,
    n.graphconfig,
    n.the_geom,
    n.active,
    n.presszone_type,
    n.stylesheet::text AS stylesheet,
    n.expl_id2
FROM plan_netscenario_presszone n
JOIN plan_netscenario p USING (netscenario_id)
JOIN plan_netscenario_current pnc ON n.netscenario_id = pnc.netscenario_id
WHERE EXISTS (SELECT 1 FROM sel_expl WHERE sel_expl.expl_id = p.expl_id);

CREATE OR REPLACE VIEW ve_plan_netscenario_dma
AS WITH plan_netscenario_current AS (
  SELECT value::integer AS netscenario_id
  FROM config_param_user
  WHERE cur_user = CURRENT_USER
    AND parameter = 'plan_netscenario_current'
  LIMIT 1
), sel_expl AS (
    SELECT selector_expl.expl_id
    FROM selector_expl
    WHERE selector_expl.cur_user = CURRENT_USER
)
SELECT n.netscenario_id,
    p.name AS netscenario_name,
    n.dma_id,
    n.dma_name AS name,
    n.pattern_id,
    n.graphconfig,
    n.the_geom,
    n.active,
    n.stylesheet::text AS stylesheet,
    n.expl_id2
FROM plan_netscenario_dma n
JOIN plan_netscenario p USING (netscenario_id)
JOIN plan_netscenario_current pnc ON n.netscenario_id = pnc.netscenario_id
WHERE EXISTS (SELECT 1 FROM sel_expl WHERE sel_expl.expl_id = p.expl_id);

CREATE OR REPLACE VIEW v_ui_plan_netscenario
AS WITH sel_expl AS (
    SELECT selector_expl.expl_id
    FROM selector_expl
    WHERE selector_expl.cur_user = CURRENT_USER
)
SELECT DISTINCT ON (netscenario_id) netscenario_id,
    name,
    descript,
    netscenario_type,
    parent_id,
    expl_id,
    active,
    log
FROM plan_netscenario
WHERE EXISTS (SELECT 1 FROM sel_expl WHERE sel_expl.expl_id = expl_id);

DROP VIEW IF EXISTS v_om_mincut_arc;
DROP VIEW IF EXISTS v_om_mincut_connec;
CREATE OR REPLACE VIEW v_om_mincut_arc AS
WITH sel_mincut AS (
	SELECT result_id, result_type
	FROM selector_mincut_result
	WHERE cur_user = CURRENT_USER
)
SELECT oma.id,
    oma.result_id,
    om.mincut_class,
    om.work_order,
    oma.arc_id,
    sm.result_type,
    oma.the_geom
FROM om_mincut_arc oma
JOIN om_mincut om ON oma.result_id = om.id
JOIN sel_mincut sm ON sm.result_id = oma.result_id
ORDER BY oma.arc_id;

CREATE OR REPLACE VIEW v_om_mincut_connec
AS WITH sel_mincut AS (
	SELECT result_id, result_type
	FROM selector_mincut_result
	WHERE cur_user = CURRENT_USER
)
SELECT omc.id,
    omc.result_id,
    om.work_order,
    omc.connec_id,
    omc.customer_code,
    sm.result_type,
    omc.the_geom
FROM om_mincut_connec omc
JOIN om_mincut om ON omc.result_id = om.id
JOIN sel_mincut sm ON sm.result_id = omc.result_id
ORDER BY omc.connec_id;
