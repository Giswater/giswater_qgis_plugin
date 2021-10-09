/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2021/10/09
DROP VIEW IF EXISTS v_edit_inp_lid_usage;

DROP VIEW IF EXISTS vi_gwf;
DROP VIEW IF EXISTS vi_loadings;
DROP VIEW IF EXISTS vi_subareas;
DROP VIEW IF EXISTS vi_subcatchments;
DROP VIEW IF EXISTS vi_subcatch2node;
DROP VIEW IF EXISTS vi_subcatchcentroid;
DROP VIEW IF EXISTS vi_coverages;
DROP VIEW IF EXISTS vi_groundwater;
DROP VIEW IF EXISTS vi_infiltration;
DROP VIEW IF EXISTS vi_lid_usage;


DROP VIEW IF EXISTS v_edit_inp_subcatchment;
CREATE OR REPLACE VIEW v_edit_inp_subcatchment AS 
 SELECT 
    inp_subcatchment.hydrology_id,
    inp_subcatchment.subc_id,
    inp_subcatchment.outlet_id,
    inp_subcatchment.rg_id,
    inp_subcatchment.area,
    inp_subcatchment.imperv,
    inp_subcatchment.width,
    inp_subcatchment.slope,
    inp_subcatchment.clength,
    inp_subcatchment.snow_id,
    inp_subcatchment.nimp,
    inp_subcatchment.nperv,
    inp_subcatchment.simp,
    inp_subcatchment.sperv,
    inp_subcatchment.zero,
    inp_subcatchment.routeto,
    inp_subcatchment.rted,
    inp_subcatchment.maxrate,
    inp_subcatchment.minrate,
    inp_subcatchment.decay,
    inp_subcatchment.drytime,
    inp_subcatchment.maxinfil,
    inp_subcatchment.suction,
    inp_subcatchment.conduct,
    inp_subcatchment.initdef,
    inp_subcatchment.curveno,
    inp_subcatchment.conduct_2,
    inp_subcatchment.drytime_2,
    inp_subcatchment.sector_id,
    inp_subcatchment.the_geom,
    inp_subcatchment.descript
   FROM selector_sector,
    inp_subcatchment,
    config_param_user
  WHERE inp_subcatchment.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text AND inp_subcatchment.hydrology_id = config_param_user.value::integer AND config_param_user.cur_user::text = "current_user"()::text AND config_param_user.parameter::text = 'inp_options_hydrology_scenario'::text;



CREATE OR REPLACE VIEW v_edit_inp_lid_usage AS 
SELECT 
l.hydrology_id, 
subc_id, 
lidco_id, 
"number", 
l.area, 
l.width, 
initsat, 
fromimp, 
toperv, 
rptfile, 
l.descript,
s.the_geom
FROM inp_lid_usage l
JOIN v_edit_inp_subcatchment s USING(subc_id)
WHERE s.hydrology_id=l.hydrology_id;


CREATE OR REPLACE VIEW v_edit_inp_dwf AS 
 SELECT
   i.dwfscenario_id,
    node_id,
    i.value,
    i.pat1,
    i.pat2,
    i.pat3,
    i.pat4
   FROM config_param_user c,
    inp_dwf i
     JOIN v_edit_inp_junction USING (node_id)
  WHERE c.cur_user::name = CURRENT_USER AND c.parameter::text = 'inp_options_dwfscenario'::text AND c.value::integer = i.dwfscenario_id;


CREATE OR REPLACE VIEW vi_gwf AS 
 SELECT inp_groundwater.subc_id,
    ('LATERAL'::text || ' '::text) || inp_groundwater.fl_eq_lat::text AS fl_eq_lat,
    ('DEEP'::text || ' '::text) || inp_groundwater.fl_eq_lat::text AS fl_eq_deep
   FROM v_edit_inp_subcatchment
     JOIN inp_groundwater ON inp_groundwater.subc_id::text = v_edit_inp_subcatchment.subc_id::text;


CREATE OR REPLACE VIEW vi_subareas AS 
 SELECT v_edit_inp_subcatchment.subc_id,
    v_edit_inp_subcatchment.nimp,
    v_edit_inp_subcatchment.nperv,
    v_edit_inp_subcatchment.simp,
    v_edit_inp_subcatchment.sperv,
    v_edit_inp_subcatchment.zero,
    v_edit_inp_subcatchment.routeto,
    v_edit_inp_subcatchment.rted
   FROM v_edit_inp_subcatchment;
   
CREATE OR REPLACE VIEW vi_subcatch2node AS 
 SELECT s1.subc_id,
        CASE
            WHEN s2.the_geom IS NOT NULL THEN st_makeline(st_centroid(s1.the_geom), st_centroid(s2.the_geom))
            ELSE st_makeline(st_centroid(s1.the_geom), v_node.the_geom)
        END AS the_geom
   FROM v_edit_inp_subcatchment s1
     LEFT JOIN v_edit_inp_subcatchment s2 ON s2.subc_id::text = s1.outlet_id::text
     LEFT JOIN v_node ON v_node.node_id::text = s1.outlet_id::text;

   
CREATE OR REPLACE VIEW vi_subcatchments AS 
 SELECT v_edit_inp_subcatchment.subc_id,
    v_edit_inp_subcatchment.rg_id,
        CASE
            WHEN b.outlet_id IS NOT NULL THEN b.outlet_id::character varying(16)
            WHEN c.outlet_id IS NOT NULL THEN c.outlet_id::character varying(16)
            ELSE v_edit_inp_subcatchment.outlet_id
        END AS outlet_id,
    v_edit_inp_subcatchment.area,
    v_edit_inp_subcatchment.imperv,
    v_edit_inp_subcatchment.width,
    v_edit_inp_subcatchment.slope,
    v_edit_inp_subcatchment.clength,
    v_edit_inp_subcatchment.snow_id
   FROM v_edit_inp_subcatchment
     LEFT JOIN ( SELECT DISTINCT ON (a.subc_id) a.subc_id,
            a.node_array AS outlet_id
           FROM ( SELECT unnest(inp_subcatchment.outlet_id::text[]) AS node_array,
                    inp_subcatchment.subc_id
                   FROM inp_subcatchment
                  WHERE "left"(inp_subcatchment.outlet_id::text, 1) = '{'::text) a
             JOIN rpt_inp_node b_1 ON b_1.node_id::text = a.node_array
          WHERE b_1.result_id::text = ((( SELECT selector_inp_result.result_id
                   FROM selector_inp_result
                  WHERE selector_inp_result.cur_user = CURRENT_USER::text))::text)) b ON v_edit_inp_subcatchment.subc_id::text = b.subc_id::text
     LEFT JOIN ( SELECT DISTINCT ON (e.subc_id) e.subc_id,
            e.parent_array AS outlet_id
           FROM ( SELECT unnest(inp_subcatchment.outlet_id::text[]) AS parent_array,
                    inp_subcatchment.subc_id
                   FROM inp_subcatchment
                  WHERE "left"(inp_subcatchment.outlet_id::text, 1) = '{'::text) e) c ON v_edit_inp_subcatchment.subc_id::text = c.subc_id::text;




CREATE OR REPLACE VIEW vi_coverages AS 
 SELECT v_edit_inp_subcatchment.subc_id,
    inp_coverage_land_x_subc.landus_id,
    inp_coverage_land_x_subc.percent
   FROM inp_coverage_land_x_subc
     JOIN v_edit_inp_subcatchment ON inp_coverage_land_x_subc.subc_id::text = v_edit_inp_subcatchment.subc_id::text
     LEFT JOIN ( SELECT DISTINCT ON (a.subc_id) a.subc_id,
            v_node.node_id
           FROM ( SELECT unnest(inp_subcatchment.outlet_id::text[]) AS node_array,
                    inp_subcatchment.subc_id,
                    inp_subcatchment.outlet_id,
                    inp_subcatchment.rg_id,
                    inp_subcatchment.area,
                    inp_subcatchment.imperv,
                    inp_subcatchment.width,
                    inp_subcatchment.slope,
                    inp_subcatchment.clength,
                    inp_subcatchment.snow_id,
                    inp_subcatchment.nimp,
                    inp_subcatchment.nperv,
                    inp_subcatchment.simp,
                    inp_subcatchment.sperv,
                    inp_subcatchment.zero,
                    inp_subcatchment.routeto,
                    inp_subcatchment.rted,
                    inp_subcatchment.maxrate,
                    inp_subcatchment.minrate,
                    inp_subcatchment.decay,
                    inp_subcatchment.drytime,
                    inp_subcatchment.maxinfil,
                    inp_subcatchment.suction,
                    inp_subcatchment.conduct,
                    inp_subcatchment.initdef,
                    inp_subcatchment.curveno,
                    inp_subcatchment.conduct_2,
                    inp_subcatchment.drytime_2,
                    inp_subcatchment.sector_id,
                    inp_subcatchment.hydrology_id,
                    inp_subcatchment.the_geom,
                    inp_subcatchment.descript
                   FROM inp_subcatchment
                  WHERE "left"(inp_subcatchment.outlet_id::text, 1) = '{'::text) a
             JOIN v_node ON v_node.node_id::text = a.node_array) b ON v_edit_inp_subcatchment.subc_id::text = b.subc_id::text;



CREATE OR REPLACE VIEW vi_groundwater AS 
 SELECT inp_groundwater.subc_id,
    inp_groundwater.aquif_id,
    inp_groundwater.node_id,
    inp_groundwater.surfel,
    inp_groundwater.a1,
    inp_groundwater.b1,
    inp_groundwater.a2,
    inp_groundwater.b2,
    inp_groundwater.a3,
    inp_groundwater.tw,
    inp_groundwater.h
   FROM v_edit_inp_subcatchment
     JOIN inp_groundwater ON inp_groundwater.subc_id::text = v_edit_inp_subcatchment.subc_id::text
     LEFT JOIN ( SELECT DISTINCT ON (a.subc_id) a.subc_id,
            v_node.node_id
           FROM ( SELECT unnest(inp_subcatchment.outlet_id::text[]) AS node_array,
                    inp_subcatchment.subc_id,
                    inp_subcatchment.outlet_id,
                    inp_subcatchment.rg_id,
                    inp_subcatchment.area,
                    inp_subcatchment.imperv,
                    inp_subcatchment.width,
                    inp_subcatchment.slope,
                    inp_subcatchment.clength,
                    inp_subcatchment.snow_id,
                    inp_subcatchment.nimp,
                    inp_subcatchment.nperv,
                    inp_subcatchment.simp,
                    inp_subcatchment.sperv,
                    inp_subcatchment.zero,
                    inp_subcatchment.routeto,
                    inp_subcatchment.rted,
                    inp_subcatchment.maxrate,
                    inp_subcatchment.minrate,
                    inp_subcatchment.decay,
                    inp_subcatchment.drytime,
                    inp_subcatchment.maxinfil,
                    inp_subcatchment.suction,
                    inp_subcatchment.conduct,
                    inp_subcatchment.initdef,
                    inp_subcatchment.curveno,
                    inp_subcatchment.conduct_2,
                    inp_subcatchment.drytime_2,
                    inp_subcatchment.sector_id,
                    inp_subcatchment.hydrology_id,
                    inp_subcatchment.the_geom,
                    inp_subcatchment.descript
                   FROM inp_subcatchment
                  WHERE "left"(inp_subcatchment.outlet_id::text, 1) = '{'::text) a
             JOIN v_node ON v_node.node_id::text = a.node_array) b ON v_edit_inp_subcatchment.subc_id::text = b.subc_id::text;


CREATE OR REPLACE VIEW vi_infiltration AS 
 SELECT v_edit_inp_subcatchment.subc_id,
    v_edit_inp_subcatchment.curveno AS other1,
    v_edit_inp_subcatchment.conduct_2 AS other2,
    v_edit_inp_subcatchment.drytime_2 AS other3,
    NULL::integer AS other4,
    NULL::double precision AS other5
   FROM v_edit_inp_subcatchment
     JOIN cat_hydrology ON cat_hydrology.hydrology_id = v_edit_inp_subcatchment.hydrology_id
     LEFT JOIN ( SELECT DISTINCT ON (a.subc_id) a.subc_id,
            v_node.node_id
           FROM ( SELECT unnest(inp_subcatchment.outlet_id::text[]) AS node_array,
                    inp_subcatchment.subc_id,
                    inp_subcatchment.outlet_id,
                    inp_subcatchment.rg_id,
                    inp_subcatchment.area,
                    inp_subcatchment.imperv,
                    inp_subcatchment.width,
                    inp_subcatchment.slope,
                    inp_subcatchment.clength,
                    inp_subcatchment.snow_id,
                    inp_subcatchment.nimp,
                    inp_subcatchment.nperv,
                    inp_subcatchment.simp,
                    inp_subcatchment.sperv,
                    inp_subcatchment.zero,
                    inp_subcatchment.routeto,
                    inp_subcatchment.rted,
                    inp_subcatchment.maxrate,
                    inp_subcatchment.minrate,
                    inp_subcatchment.decay,
                    inp_subcatchment.drytime,
                    inp_subcatchment.maxinfil,
                    inp_subcatchment.suction,
                    inp_subcatchment.conduct,
                    inp_subcatchment.initdef,
                    inp_subcatchment.curveno,
                    inp_subcatchment.conduct_2,
                    inp_subcatchment.drytime_2,
                    inp_subcatchment.sector_id,
                    inp_subcatchment.hydrology_id,
                    inp_subcatchment.the_geom,
                    inp_subcatchment.descript
                   FROM inp_subcatchment
                  WHERE "left"(inp_subcatchment.outlet_id::text, 1) = '{'::text) a
             JOIN v_node ON v_node.node_id::text = a.node_array) b ON v_edit_inp_subcatchment.subc_id::text = b.subc_id::text
  WHERE cat_hydrology.infiltration::text = 'CURVE_NUMBER'::text
UNION
 SELECT v_edit_inp_subcatchment.subc_id,
    v_edit_inp_subcatchment.suction AS other1,
    v_edit_inp_subcatchment.conduct AS other2,
    v_edit_inp_subcatchment.initdef AS other3,
    NULL::integer AS other4,
    NULL::double precision AS other5
   FROM v_edit_inp_subcatchment
     JOIN cat_hydrology ON cat_hydrology.hydrology_id = v_edit_inp_subcatchment.hydrology_id
     LEFT JOIN ( SELECT DISTINCT ON (a.subc_id) a.subc_id,
            v_node.node_id
           FROM ( SELECT unnest(inp_subcatchment.outlet_id::text[]) AS node_array,
                    inp_subcatchment.subc_id,
                    inp_subcatchment.outlet_id,
                    inp_subcatchment.rg_id,
                    inp_subcatchment.area,
                    inp_subcatchment.imperv,
                    inp_subcatchment.width,
                    inp_subcatchment.slope,
                    inp_subcatchment.clength,
                    inp_subcatchment.snow_id,
                    inp_subcatchment.nimp,
                    inp_subcatchment.nperv,
                    inp_subcatchment.simp,
                    inp_subcatchment.sperv,
                    inp_subcatchment.zero,
                    inp_subcatchment.routeto,
                    inp_subcatchment.rted,
                    inp_subcatchment.maxrate,
                    inp_subcatchment.minrate,
                    inp_subcatchment.decay,
                    inp_subcatchment.drytime,
                    inp_subcatchment.maxinfil,
                    inp_subcatchment.suction,
                    inp_subcatchment.conduct,
                    inp_subcatchment.initdef,
                    inp_subcatchment.curveno,
                    inp_subcatchment.conduct_2,
                    inp_subcatchment.drytime_2,
                    inp_subcatchment.sector_id,
                    inp_subcatchment.hydrology_id,
                    inp_subcatchment.the_geom,
                    inp_subcatchment.descript
                   FROM inp_subcatchment
                  WHERE "left"(inp_subcatchment.outlet_id::text, 1) = '{'::text) a
             JOIN v_node ON v_node.node_id::text = a.node_array) b ON v_edit_inp_subcatchment.subc_id::text = b.subc_id::text
  WHERE cat_hydrology.infiltration::text = 'GREEN_AMPT'::text
UNION
 SELECT v_edit_inp_subcatchment.subc_id,
    v_edit_inp_subcatchment.maxrate AS other1,
    v_edit_inp_subcatchment.minrate AS other2,
    v_edit_inp_subcatchment.decay AS other3,
    v_edit_inp_subcatchment.drytime AS other4,
    v_edit_inp_subcatchment.maxinfil AS other5
   FROM v_edit_inp_subcatchment
     JOIN cat_hydrology ON cat_hydrology.hydrology_id = v_edit_inp_subcatchment.hydrology_id
     LEFT JOIN ( SELECT DISTINCT ON (a.subc_id) a.subc_id,
            v_node.node_id
           FROM ( SELECT unnest(inp_subcatchment.outlet_id::text[]) AS node_array,
                    inp_subcatchment.subc_id,
                    inp_subcatchment.outlet_id,
                    inp_subcatchment.rg_id,
                    inp_subcatchment.area,
                    inp_subcatchment.imperv,
                    inp_subcatchment.width,
                    inp_subcatchment.slope,
                    inp_subcatchment.clength,
                    inp_subcatchment.snow_id,
                    inp_subcatchment.nimp,
                    inp_subcatchment.nperv,
                    inp_subcatchment.simp,
                    inp_subcatchment.sperv,
                    inp_subcatchment.zero,
                    inp_subcatchment.routeto,
                    inp_subcatchment.rted,
                    inp_subcatchment.maxrate,
                    inp_subcatchment.minrate,
                    inp_subcatchment.decay,
                    inp_subcatchment.drytime,
                    inp_subcatchment.maxinfil,
                    inp_subcatchment.suction,
                    inp_subcatchment.conduct,
                    inp_subcatchment.initdef,
                    inp_subcatchment.curveno,
                    inp_subcatchment.conduct_2,
                    inp_subcatchment.drytime_2,
                    inp_subcatchment.sector_id,
                    inp_subcatchment.hydrology_id,
                    inp_subcatchment.the_geom,
                    inp_subcatchment.descript
                   FROM inp_subcatchment
                  WHERE "left"(inp_subcatchment.outlet_id::text, 1) = '{'::text) a
             JOIN v_node ON v_node.node_id::text = a.node_array) b ON v_edit_inp_subcatchment.subc_id::text = b.subc_id::text
  WHERE cat_hydrology.infiltration::text = ANY (ARRAY['MODIFIED_HORTON'::text, 'HORTON'::text]);

CREATE OR REPLACE VIEW vi_subcatchcentroid AS 
 SELECT v_edit_inp_subcatchment.subc_id,
    st_centroid(v_edit_inp_subcatchment.the_geom) AS the_geom
   FROM v_edit_inp_subcatchment;


CREATE OR REPLACE VIEW vi_lid_usage AS 
 SELECT inp_lid_usage.subc_id,
    inp_lid_usage.lidco_id,
    inp_lid_usage.number::integer AS number,
    inp_lid_usage.area,
    inp_lid_usage.width,
    inp_lid_usage.initsat,
    inp_lid_usage.fromimp,
    inp_lid_usage.toperv::integer AS toperv,
    inp_lid_usage.rptfile
   FROM v_edit_inp_subcatchment
     JOIN inp_lid_usage ON inp_lid_usage.subc_id::text = v_edit_inp_subcatchment.subc_id::text;
