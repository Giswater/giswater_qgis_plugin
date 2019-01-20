/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;

/* Instructions to fill this file for developers
- Use CREATE OR REPLACE
- DROP CASCADE IS FORBIDDEN
- Only use DROP when view:
	- is not customizable view (ie ve_node_* or ve_arc_*)
	- has not other views over
	- has not trigger
*/

DROP VIEW IF EXISTS v_edit_rtc_hydro_data_x_connec;
CREATE OR REPLACE VIEW v_edit_rtc_hydro_data_x_connec AS
SELECT
ext_rtc_hydrometer_x_data.id,
rtc_hydrometer_x_connec.connec_id,
ext_rtc_hydrometer_x_data.hydrometer_id,
ext_rtc_hydrometer.catalog_id,
ext_rtc_hydrometer_x_data.cat_period_id,
ext_cat_period.code as cat_period_code,
sum,
custom_sum
FROM ext_rtc_hydrometer_x_data
JOIN ext_rtc_hydrometer ON ext_rtc_hydrometer_x_data.hydrometer_id::int8=ext_rtc_hydrometer.id::int8
LEFT JOIN ext_cat_hydrometer ON ext_cat_hydrometer.id::int8 = ext_rtc_hydrometer.catalog_id::int8
JOIN rtc_hydrometer_x_connec ON rtc_hydrometer_x_connec.hydrometer_id::int8=ext_rtc_hydrometer_x_data.hydrometer_id::int8
JOIN ext_cat_period ON cat_period_id=ext_cat_period.id
ORDER BY 3, 5 DESC ;



CREATE OR REPLACE VIEW "v_plan_psector_x_arc" AS 
SELECT 
	row_number() OVER (ORDER BY v_plan_arc.arc_id) AS rid,
    plan_psector_x_arc.psector_id,
    plan_psector.psector_type,
    v_plan_arc.arc_id,
    v_plan_arc.arccat_id,
    v_plan_arc.cost_unit,
    v_plan_arc.cost::numeric(14,2) AS cost,
    v_plan_arc.length,
    v_plan_arc.budget,
    v_plan_arc.other_budget,
    v_plan_arc.total_budget,
    v_plan_arc.state,
     plan_psector.expl_id,
    plan_psector.atlas_id,
    v_plan_arc.the_geom
   FROM selector_psector, v_plan_arc
    JOIN plan_psector_x_arc ON plan_psector_x_arc.arc_id::text = v_plan_arc.arc_id::text
    JOIN plan_psector ON plan_psector.psector_id = plan_psector_x_arc.psector_id
    WHERE selector_psector.cur_user = "current_user"()::text AND selector_psector.psector_id = plan_psector_x_arc.psector_id 
	AND doable = true
	order by 2;
  
  
CREATE OR REPLACE VIEW "v_plan_psector_x_node" AS 
SELECT
row_number() OVER (ORDER BY v_plan_node.node_id) AS rid,
plan_psector_x_node.psector_id,
plan_psector.psector_type,
v_plan_node.node_id,
v_plan_node.nodecat_id,
v_plan_node.cost::numeric(12,2),
v_plan_node.measurement,
v_plan_node.budget as total_budget,
v_plan_node."state",
v_plan_node.expl_id,
plan_psector.atlas_id,
v_plan_node.the_geom
FROM selector_psector, v_plan_node
JOIN plan_psector_x_node ON plan_psector_x_node.node_id = v_plan_node.node_id
JOIN plan_psector ON plan_psector.psector_id = plan_psector_x_node.psector_id
WHERE selector_psector.cur_user="current_user"() AND selector_psector.psector_id=plan_psector_x_node.psector_id
	AND doable = true
order by 2;




CREATE OR REPLACE VIEW v_rtc_hydrometer_x_arc AS 
 SELECT rtc_hydrometer_x_connec.hydrometer_id,
    rtc_hydrometer_x_connec.connec_id,
    rpt_inp_arc.arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2
   FROM rtc_hydrometer_x_connec
     JOIN v_edit_connec ON v_edit_connec.connec_id::text = rtc_hydrometer_x_connec.connec_id::text
     JOIN rpt_inp_arc ON rpt_inp_arc.arc_id::text = v_edit_connec.arc_id::text;

	 

CREATE OR REPLACE VIEW v_rtc_hydrometer_x_node_period AS 
SELECT 
   a.hydrometer_id,
    a.node_1 AS node_id,
   a.arc_id,
   b.dma_id,
   b.period_id,
   b.lps_avg * 0.5::double precision AS lps_avg_real,
   c.effc::numeric(5,4)as losses,
    b.lps_avg * 0.5::double precision * c.effc::double precision AS lps_avg,
    c.minc AS cmin,
    b.lps_avg * 0.5::double precision * c.minc AS lps_min,
    c.maxc AS cmax,
    b.lps_avg * 0.5::double precision * c.maxc AS lps_max
   FROM v_rtc_hydrometer_x_arc a
     JOIN v_rtc_hydrometer_period b ON b.hydrometer_id = a.hydrometer_id
     JOIN ext_rtc_scada_dma_period c ON c.cat_period_id::text = b.period_id::text AND c.dma_id=b.dma_id::text
union
 SELECT 
   a.hydrometer_id,
    a.node_2 AS node_id,
   a.arc_id,
   b.dma_id,
   b.period_id,
   b.lps_avg * 0.5::double precision AS lps_avg_real,
   c.effc::numeric(5,4)as losses,
    b.lps_avg * 0.5::double precision * c.effc::double precision AS lps_avg,
    c.minc AS cmin,
    b.lps_avg * 0.5::double precision * c.minc AS lps_min,
    c.maxc AS cmax,
    b.lps_avg * 0.5::double precision * c.maxc AS lps_max
   FROM v_rtc_hydrometer_x_arc a
     JOIN v_rtc_hydrometer_period b ON b.hydrometer_id = a.hydrometer_id
     JOIN ext_rtc_scada_dma_period c ON c.cat_period_id::text = b.period_id::text AND c.dma_id=b.dma_id::text;


