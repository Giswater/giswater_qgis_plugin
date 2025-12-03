/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = "SCHEMA_NAME", public;


CREATE OR REPLACE VIEW v_cso_drainzone_rainfall_tstep
AS SELECT rowid,
    drainzone_id,
    node_id AS ouftall_id,
    rf_name AS rainfall,
    rf_tstep,
    round(rf_volume::numeric, 3) AS rf_intensity,
    round(vol_residual::numeric, 3) AS vol_residual,
    round(vol_max_epi::numeric, 3) AS vol_max_epi,
    round(vol_res_epi::numeric, 3) AS vol_res_epi,
    round(vol_rainfall::numeric, 3) AS vol_rainfall,
    round(vol_total::numeric, 3) AS vol_total,
    round(vol_runoff::numeric, 3) AS vol_runoff,
    round(vol_infiltr::numeric, 3) AS vol_infiltr,
    round(vol_circ::numeric, 3) AS vol_circ,
    round(vol_circ_dep::numeric, 3) AS vol_circ_dep,
    round(vol_circ_red::numeric, 3) AS vol_circ_red,
    round(vol_non_leaked::numeric, 3) AS vol_non_leaked,
    round(vol_leaked::numeric, 3) AS vol_leaked,
    round(vol_wwtp::numeric, 3) AS vol_wwtp,
    round(vol_treated::numeric, 3) AS vol_treated,
    round(efficiency::numeric, 3) AS efficiency
   FROM cso_out_vol
  ORDER BY drainzone_id, rf_name, (rf_tstep::time without time zone);

CREATE OR REPLACE VIEW v_cso_drainzone_rainfall
AS SELECT cso_out_vol.drainzone_id,
    cso_out_vol.node_id AS outfall_id,
    cso_out_vol.rf_name AS rainfall,
        CASE
            WHEN (sum(cso_out_vol.vol_treated) + sum(cso_out_vol.vol_leaked)) = 0::double precision THEN 0::numeric
            ELSE (sum(cso_out_vol.vol_treated) / (sum(cso_out_vol.vol_treated) + sum(cso_out_vol.vol_leaked)))::numeric(12,3)
        END AS efficiency,
    drainzone.expl_id
   FROM cso_out_vol
     JOIN drainzone USING (drainzone_id)
  GROUP BY cso_out_vol.node_id, cso_out_vol.rf_name, cso_out_vol.drainzone_id, drainzone.expl_id
  ORDER BY cso_out_vol.node_id, cso_out_vol.rf_name;

CREATE OR REPLACE VIEW v_cso_drainzone
AS SELECT d.drainzone_id,
    cov.outfall_id,
    d.name AS drainzone_name,
    e.name AS muni_name,
    m.macroexpl_id,
    m.name AS macro_name,
    n.expl_id,
    ex.name AS expl_name,
    cso.thyssen_plv_area::numeric(12,3) AS total_area,
    cso.imperv_area::numeric(12,3) AS imperv_area,
    cso.mean_coef_runoff::numeric(12,3) AS runoffc,
    cso.demand::numeric(12,3) AS demand,
    cso.eq_inhab::integer AS eq_inhab,
    avg(cov.efficiency)::numeric(12,3) AS efficiency,
    d.the_geom
   FROM v_cso_drainzone_rainfall cov
     LEFT JOIN cso_inp_system_subc cso ON cso.drainzone_id = cov.drainzone_id
     LEFT JOIN drainzone d ON d.drainzone_id = cov.drainzone_id
     LEFT JOIN vu_node n ON cov.outfall_id = n.node_id::text
     LEFT JOIN macroexploitation m ON m.macroexpl_id = n.macroexpl_id
     LEFT JOIN exploitation ex ON ex.expl_id = n.expl_id
     LEFT JOIN ext_municipality e ON n.muni_id = e.muni_id
  GROUP BY d.drainzone_id, cov.outfall_id, e.name, m.macroexpl_id, m.name, n.expl_id, ex.name, (cso.thyssen_plv_area::numeric(12,3)), (cso.imperv_area::numeric(12,3)), (cso.mean_coef_runoff::numeric(12,3)), (cso.demand::numeric(12,3)), (cso.eq_inhab::integer)
  ORDER BY e.name;
