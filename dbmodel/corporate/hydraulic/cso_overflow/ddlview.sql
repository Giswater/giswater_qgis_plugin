/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = "SCHEMA_NAME", public;


DROP VIEW IF EXISTS v_cso_drainzone_rainfall_tstep;
CREATE OR REPLACE VIEW v_cso_drainzone_rainfall_tstep;
AS SELECT a.rowid,
    e.name AS macroexploitation,
    c.name AS exploitation,
    m.name AS municipality,
    a.drainzone_id,
    a.node_id AS outfall_id,
    a.rf_name AS rainfall,
    a.rf_tstep,
    round(a.rf_volume::numeric, 3) AS rf_intensity,
    round(a.vol_residual::numeric, 3) AS vol_dwf,
    round(a.vol_rainfall::numeric, 3) AS vol_rainfall,
    round(a.vol_total::numeric, 3) AS vol_total,
    round(a.vol_runoff::numeric, 3) AS vol_runoff,
    round(a.vol_infiltr::numeric, 3) AS vol_infiltr,
    round(a.vol_circ::numeric, 3) AS vol_circ,
    round(a.vol_circ_dep::numeric, 3) AS vol_circ_dep,
    round(a.vol_circ_red::numeric, 3) AS vol_circ_red,
    round(a.vol_non_leaked::numeric, 3) AS vol_non_leaked,
    round(a.vol_leaked::numeric, 3) AS vol_leaked,
    round(a.vol_wwtp::numeric, 3) AS vol_wwtp,
    round(a.vol_treated::numeric, 3) AS vol_treated
   FROM cso_out_vol a
     LEFT JOIN drainzone b USING (drainzone_id)
     LEFT JOIN exploitation c ON b.expl_id = c.expl_id
     LEFT JOIN macroexploitation e ON e.macroexpl_id = c.macroexpl_id
     LEFT JOIN node n USING (node_id)
     LEFT JOIN ext_municipality m ON n.muni_id = m.muni_id
  ORDER BY a.drainzone_id, a.rf_name, (a.rf_tstep::time without time zone);


DROP VIEW IF EXISTS v_cso_drainzone_rainfall;
CREATE OR REPLACE VIEW v_cso_drainzone_rainfall AS
SELECT 
    m.name AS macroexplotation,
    ex.name AS exploitation,
	e.name AS municipality,
	d.name AS drainzone,
	d.expl_id,
	d.drainzone_id,
	outfall_id,
    rainfall,
    sum(vol_dwf) AS vol_dwf,
    sum(vol_rainfall) AS vol_rainfall,
    sum(vol_total) AS vol_total,
    sum(vol_runoff) AS vol_runoff,
    sum(vol_infiltr) AS vol_infiltr,
    sum(vol_circ) AS vol_circ,
    sum(vol_circ_dep) AS vol_circ_dep,
    sum(vol_circ_red) AS vol_circ_red,
    sum(vol_non_leaked) AS vol_non_leaked,
    sum(vol_leaked) AS vol_leaked,
    sum(vol_wwtp) AS vol_wwtp,
    sum(vol_treated) AS vol_treated,
    (sum(vol_treated)/sum(vol_total))::NUMERIC(12,3) AS efficiency 
FROM v_cso_drainzone_rainfall_tstep dr
	 LEFT JOIN drainzone d ON d.drainzone_id = dr.drainzone_id
	 LEFT JOIN vu_node n ON n.node_id = dr.outfall_id
     LEFT JOIN exploitation ex ON ex.expl_id = d.expl_id
     LEFT JOIN macroexploitation m ON m.macroexpl_id = ex.macroexpl_id
     LEFT JOIN ext_municipality e ON n.muni_id = e.muni_id
     JOIN selector_expl se ON d.expl_id = se.expl_id
     WHERE cur_user = current_user
     GROUP BY m.name, ex.name, d.name, e.name, d.drainzone_id, outfall_id, rainfall 
     ORDER BY 1, 2, 4

     
DROP VIEW IF EXISTS v_cso_drainzone;
CREATE OR REPLACE VIEW v_cso_drainzone AS 
SELECT
	macroexplotation,
	exploitation,
	municipality,
	drainzone, 
	d.expl_id,
	d.drainzone_id,
	outfall_id,
    cso.thyssen_plv_area::numeric(12,3) AS total_area,
    cso.imperv_area::numeric(12,3) AS imperv_area,
    (cso.imperv_area/cso.thyssen_plv_area)::numeric(12,3) AS runoffc,
    CASE WHEN cc.calib_imperv_area IS NULL THEN cso.imperv_area::numeric(12,3) ELSE cc.calib_imperv_area::numeric(12,3) END AS calib_imperv_area,
    CASE WHEN cc.calib_imperv_area IS NOT NULL THEN (cc.calib_imperv_area/cso.thyssen_plv_area)::numeric(12,3) ELSE mean_coef_runoff::numeric(12,3) END AS calib_runoffc,
    (d.addparam->>'kmLength')::numeric(12,3) AS kmlength,
    sum(vol_dwf) AS vol_dwf,
    sum(vol_wwtp) AS vol_wwtp,
    ((sum(vol_leaked))/(10*24*3600))::numeric(12,3) AS q_leaked_p80,
    ((sum(vol_non_leaked))/(10*24*3600))::numeric(12,3) AS q_nonleaked_p80,
    cso.eq_inhab::integer AS eq_inhab,
    ((sum(vol_dwf)/sum(vol_runoff))*100)::numeric(12,3) AS dwf_p80_percent,
    avg(cov.efficiency)::numeric(12,3) AS efficiency,
    d.the_geom
   FROM v_cso_drainzone_rainfall cov 
   	 LEFT JOIN cso_calibration cc ON cc.drainzone_id = cov.drainzone_id
     LEFT JOIN cso_inp_system_subc cso ON cso.drainzone_id = cov.drainzone_id
     LEFT JOIN drainzone d ON d.drainzone_id =cov.drainzone_id 
     GROUP BY macroexplotation,	exploitation,	municipality,	drainzone, d.drainzone_id,cov.outfall_id, d.addparam->>'kmLength', cso.eq_inhab, d.the_geom, cso.thyssen_plv_area, cso.imperv_area, cso.mean_coef_runoff, cc.calib_imperv_area, cso.thyssen_plv_area
  ORDER BY 1,2,4;
 

CREATE OR REPLACE VIEW v_rpt_multi_arcflow_sum
AS SELECT rpt_inp_arc.id,
    rpt_inp_arc.arc_id,
    rpt_inp_arc.result_id,
    rpt_inp_arc.arc_type,
    rpt_inp_arc.arccat_id,
    rpt_inp_arc.sector_id,
    rpt_inp_arc.the_geom,
    rpt_arcflow_sum.arc_type AS swarc_type,
    max(rpt_arcflow_sum.max_flow) AS max_flow,
    max(rpt_arcflow_sum.time_days) AS time_days,
    max(rpt_arcflow_sum.time_hour) AS time_hour,
    max(rpt_arcflow_sum.max_veloc) AS max_veloc,
    max(COALESCE(rpt_arcflow_sum.mfull_flow, 0::numeric(12,4))) AS mfull_flow,
    max(COALESCE(rpt_arcflow_sum.mfull_depth, 0::numeric(12,4))) AS mfull_depth,
    max(rpt_arcflow_sum.max_shear) AS max_shear,
    max(rpt_arcflow_sum.max_hr) AS max_hr,
    max(rpt_arcflow_sum.max_slope) AS max_slope,
    max(rpt_arcflow_sum.day_max) AS day_max,
    max(rpt_arcflow_sum.time_max) AS time_max,
    max(rpt_arcflow_sum.min_shear) AS min_shear,
    max(rpt_arcflow_sum.day_min) AS day_min,
    max(rpt_arcflow_sum.time_min) AS swartime_minc_type
   FROM selector_rpt_main ,  rpt_inp_arc
     JOIN rpt_arcflow_sum ON rpt_arcflow_sum.arc_id::text = rpt_inp_arc.arc_id::text
  WHERE rpt_arcflow_sum.result_id::text = selector_rpt_main.result_id::text AND selector_rpt_main.cur_user = "current_user"()::text 
 AND rpt_inp_arc.result_id::text = selector_rpt_main.result_id::TEXT
 GROUP BY 1,2,3,4,5,6,7,8;

 
CREATE OR REPLACE VIEW v_rpt_multi_nodeflooding_sum
AS SELECT rpt_inp_node.id,
    rpt_nodeflooding_sum.node_id,
    selector_rpt_main.result_id,
    rpt_inp_node.node_type,
    rpt_inp_node.nodecat_id,
    max(rpt_nodeflooding_sum.hour_flood) AS hour_flood,
    max(rpt_nodeflooding_sum.max_rate) AS max_rate,
    max(rpt_nodeflooding_sum.time_days) AS time_days,
    max(rpt_nodeflooding_sum.time_hour) AS time_hour,
    max(rpt_nodeflooding_sum.tot_flood) AS tot_flood,
    max(rpt_nodeflooding_sum.max_ponded) AS max_ponded,
    rpt_inp_node.sector_id,
    rpt_inp_node.the_geom
   FROM selector_rpt_main,
    rpt_inp_node
     JOIN rpt_nodeflooding_sum ON rpt_nodeflooding_sum.node_id::text = rpt_inp_node.node_id::text
  WHERE rpt_nodeflooding_sum.result_id::text = selector_rpt_main.result_id::text AND selector_rpt_main.cur_user = "current_user"()::text AND rpt_inp_node.result_id::text = selector_rpt_main.result_id::TEXT
  GROUP BY 1,2,3,4,5,12,13;


CREATE OR REPLACE VIEW v_cso_weir
AS SELECT a.node_id,
    a.qmax,
    a.vmax,
    a.weight_factor,
    a.custom_qmax,
    a.custom_vmax,
    b.nodecat_id,
    b.the_geom,
    a.weir_type
   FROM cso_inp_weir a
     JOIN v_edit_node b USING (node_id);


CREATE OR REPLACE VIEW v_cso_weir
AS SELECT a.node_id,
    a.qmax,
    a.vmax,
    a.weight_factor,
    a.custom_qmax,
    a.custom_vmax,
    b.nodecat_id,
    b.the_geom,
    a.weir_type
   FROM cso_inp_weir a
     JOIN v_edit_node b USING (node_id);

     
CREATE OR REPLACE VIEW v_cso_wwtp
AS SELECT a.node_id,
    a.habitants,
    a.eq_habitants,
    a.qmed,
    a.qmax,
    a.qmin,
    a.unit_demand,
    b.nodecat_id,
    b.the_geom
   FROM cso_inp_wwtp a
     JOIN v_edit_node b USING (node_id);