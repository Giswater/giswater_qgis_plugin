/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = "SCHEMA_NAME", public;



CREATE OR REPLACE VIEW v_cso_drainzone_rainfall
	AS SELECT drainzone_id ,cso_out_vol.node_id as outfall_id,
    cso_out_vol.rf_name as rainfall,
    (sum(vol_treated)/(sum(vol_treated) + sum(vol_leaked)))::numeric(12,3) as efficiency
	FROM cso_out_vol
	WHERE cso_out_vol.efficiency IS NOT NULL
	GROUP BY cso_out_vol.node_id, cso_out_vol.rf_name,drainzone_id 
	ORDER BY cso_out_vol.node_id, cso_out_vol.rf_name;
 
  
CREATE OR REPLACE VIEW v_cso_drainzone AS 
SELECT d.drainzone_id,
    cov.outfall_id,
    e.name AS muni_name,
    concat(m.macroexpl_id, ' - ', m.name, ' (', ex.expl_id, ' ', ex.name, ')') AS expl_name,
    cso.thyssen_plv_area::numeric(12,3) AS total_area,
    cso.imperv_area::numeric(12,3) AS imperv_area,
    cso.mean_coef_runoff::numeric(12,3) AS runoffc,
    cso.demand::numeric(12,3) AS demand,
    cso.eq_inhab::integer AS eq_inhab,
    avg(cov.efficiency)::numeric(12,3) AS efficiency,
    d.the_geom
   FROM ud.v_cso_drainzone_rainfall cov
     LEFT JOIN ud.cso_inp_system_subc cso ON cso.drainzone_id::text = cov.drainzone_id
     LEFT JOIN ud.drainzone d ON d.drainzone_id::text = cov.drainzone_id
     LEFT JOIN ud.vu_node n ON cov.outfall_id = n.node_id
     JOIN ud.macroexploitation m ON m.macroexpl_id = n.macroexpl_id
     JOIN ud.exploitation ex ON ex.expl_id = n.expl_id
	 JOIN ud.ext_municipality e ON n.muni_id = e.muni_id
	group by 1, 2, 3, 4, 5, 6, 7, 8, 9
	order by 3;


CREATE OR REPLACE VIEW v_cso_drainzone_rainfall_tstep
	AS SELECT cso_out_vol.rowid,
    cso_out_vol.drainzone_id,
    cso_out_vol.node_id as ouftall_id,
    cso_out_vol.rf_name as rainfall,
    cso_out_vol.rf_tstep,
    round(cso_out_vol.rf_volume::numeric, 3) AS rf_intensity,
    round(cso_out_vol.vol_residual::numeric, 3) AS vol_residual,
    round(cso_out_vol.vol_max_epi::numeric, 3) AS vol_max_epi,
    round(cso_out_vol.vol_res_epi::numeric, 3) AS vol_res_epi,
    round(cso_out_vol.vol_rainfall::numeric, 3) AS vol_rainfall,
    round(cso_out_vol.vol_total::numeric, 3) AS vol_total,
    round(cso_out_vol.vol_runoff::numeric, 3) AS vol_runoff,
    round(cso_out_vol.vol_infiltr::numeric, 3) AS vol_infiltr,
    round(cso_out_vol.vol_circ::numeric, 3) AS vol_circ,
    round(cso_out_vol.vol_circ_dep::numeric, 3) AS vol_circ_dep,
    round(cso_out_vol.vol_circ_red::numeric, 3) AS vol_circ_red,
    round(cso_out_vol.vol_non_leaked::numeric, 3) AS vol_non_leaked,
    round(cso_out_vol.vol_leaked::numeric, 3) AS vol_leaked,
    round(cso_out_vol.vol_wwtp::numeric, 3) AS vol_wwtp,
    round(cso_out_vol.vol_treated::numeric, 3) AS vol_treated,
    round(cso_out_vol.efficiency::numeric, 3) AS efficiency
	FROM ud.cso_out_vol
	order by 2, 4, rf_tstep::time;
