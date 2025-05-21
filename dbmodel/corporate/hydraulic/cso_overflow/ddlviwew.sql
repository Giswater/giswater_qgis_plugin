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
 
  
CREATE OR REPLACE VIEW v_cso_drainzone
	AS select d.drainzone_id, cov.outfall_id, thyssen_plv_area ::numeric(12,3) as total_area, imperv_area::numeric(12,3), 
	mean_coef_runoff::numeric(12,3) as runoffc, demand::numeric(12,3), eq_inhab::integer ,
	(avg(efficiency))::numeric(12,3) as efficiency, the_geom
	from v_cso_drainzone_rainfall cov
	left join cso_inp_system_subc cso ON cso.drainzone_id::text = cov.drainzone_id
	LEFT JOIN drainzone d ON d.drainzone_id::text = cov.drainzone_id
	group by 1, 2, 3, 4, 5, 6, 7, 9
	order by 3


CREATE OR REPLACE VIEW v_cso_drainzone_rainfall_tstep
	AS SELECT cso_out_vol.rowid,
    cso_out_vol.drainzone_id,
    cso_out_vol.node_id as ouftall_id,
    cso_out_vol.rf_name as rainfall,
    cso_out_vol.rf_tstep,
    round(cso_out_vol.rf_volume, 3) AS rf_intensity,
    round(cso_out_vol.vol_residual, 3) AS vol_residual,
    round(cso_out_vol.vol_max_epi, 3) AS vol_max_epi,
    round(cso_out_vol.vol_res_epi, 3) AS vol_res_epi,
    round(cso_out_vol.vol_rainfall, 3) AS vol_rainfall,
    round(cso_out_vol.vol_total, 3) AS vol_total,
    round(cso_out_vol.vol_runoff, 3) AS vol_runoff,
    round(cso_out_vol.vol_infiltr, 3) AS vol_infiltr,
    round(cso_out_vol.vol_circ, 3) AS vol_circ,
    round(cso_out_vol.vol_circ_dep, 3) AS vol_circ_dep,
    round(cso_out_vol.vol_circ_red, 3) AS vol_circ_red,
    round(cso_out_vol.vol_non_leaked, 3) AS vol_non_leaked,
    round(cso_out_vol.vol_leaked, 3) AS vol_leaked,
    round(cso_out_vol.vol_wwtp, 3) AS vol_wwtp,
    round(cso_out_vol.vol_treated, 3) AS vol_treated,
    round(cso_out_vol.efficiency, 3) AS efficiency
	FROM cso_out_vol
	order by 2, 4, rf_tstep::time;
