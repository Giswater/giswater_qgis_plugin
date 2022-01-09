/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2021/12/22
CREATE OR REPLACE VIEW v_edit_sector AS 
 SELECT sector.sector_id,
    sector.name,
    sector.descript,
    sector.macrosector_id,
    sector.the_geom,
    sector.undelete,
    sector.active,
    sector.parent_id
   FROM selector_sector, sector
  WHERE sector.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text;


--2021/12/29
CREATE OR REPLACE VIEW v_edit_inp_curve AS 
 SELECT DISTINCT c.id,
    c.curve_type,
    c.descript,
    c.sector_id,
    c.log
   FROM selector_sector, inp_curve c
  WHERE c.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text OR c.sector_id IS NULL
  ORDER BY c.id;


CREATE OR REPLACE VIEW vi_options AS 
SELECT a.parameter,
a.value
   FROM ( SELECT a_1.idval AS parameter,
            b.value,
                CASE
                    WHEN a_1.layoutname ~~ '%general_1%'::text THEN '1'::text
                    WHEN a_1.layoutname ~~ '%hydraulics_1%'::text THEN '2'::text
                    WHEN a_1.layoutname ~~ '%hydraulics_2%'::text THEN '3'::text
                    WHEN a_1.layoutname ~~ '%date_1%'::text THEN '3'::text
                    WHEN a_1.layoutname ~~ '%date_2%'::text THEN '4'::text
                    WHEN a_1.layoutname ~~ '%general_2%'::text THEN '5'::text
                    ELSE NULL::text
                END AS layoutname,
            a_1.layoutorder
           FROM sys_param_user a_1
             JOIN config_param_user b ON a_1.id = b.parameter::text
          WHERE (a_1.layoutname = ANY (ARRAY['lyt_general_1'::text, 'lyt_general_2'::text, 'lyt_hydraulics_1'::text, 'lyt_hydraulics_2'::text, 'lyt_date_1'::text, 'lyt_date_2'::text])) AND b.cur_user::name = "current_user"() AND b.value IS NOT NULL AND a_1.idval IS NOT NULL
        UNION
         SELECT 'INFILTRATION'::text AS parameter,
            cat_hydrology.infiltration AS value,
            '1'::text AS text,
            2
           FROM config_param_user,
            cat_hydrology
          WHERE config_param_user.parameter::text = 'inp_options_hydrology_scenario'::text AND config_param_user.cur_user::text = "current_user"()::text) a
  ORDER BY a.layoutname, a.layoutorder;


--2022/01/05
 CREATE OR REPLACE VIEW v_edit_cat_dwf_dscenario AS
 SELECT DISTINCT ON (c.id)
 id,
 idval,
 startdate,
 enddate,
 observ,
 c.expl_id,
 c.active,
 log
 FROM cat_dwf_scenario c, selector_expl s
 WHERE (s.expl_id = c.expl_id AND cur_user = current_user)
 OR c.expl_id is null;


CREATE OR REPLACE VIEW v_edit_cat_hydrology AS
SELECT DISTINCT ON (hydrology_id)
hydrology_id,
name,
infiltration,
text,
c.expl_id,
c.active,
log
FROM cat_hydrology c, selector_expl s
WHERE (s.expl_id = c.expl_id AND cur_user = current_user)
OR c.expl_id is null;


DROP VIEW IF EXISTS v_edit_inp_weir;
CREATE OR REPLACE VIEW v_edit_inp_weir AS 
 SELECT v_arc.arc_id,
    v_arc.node_1,
    v_arc.node_2,
    v_arc.y1,
    v_arc.custom_y1,
    v_arc.elev1,
    v_arc.custom_elev1,
    v_arc.sys_elev1,
    v_arc.y2,
    v_arc.custom_y2,
    v_arc.elev2,
    v_arc.custom_elev2,
    v_arc.sys_elev2,
    v_arc.arccat_id,
    v_arc.gis_length,
    v_arc.sector_id,
    v_arc.macrosector_id,
    v_arc.state,
    v_arc.state_type,
    v_arc.annotation,
    v_arc.inverted_slope,
    v_arc.custom_length,
    v_arc.expl_id,
    inp_weir.weir_type,
    inp_weir.offsetval,
    inp_weir.cd,
    inp_weir.ec,
    inp_weir.cd2,
    inp_weir.flap,
    inp_weir.geom1,
    inp_weir.geom2,
    inp_weir.geom3,
    inp_weir.geom4,
    inp_weir.surcharge,
    v_arc.the_geom,
    road_width,  
    road_surf,
    coef_curve
   FROM selector_sector, v_arc
   JOIN inp_weir USING (arc_id)
   WHERE v_arc.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text;


DROP VIEW IF EXISTS v_edit_inp_orifice;
CREATE OR REPLACE VIEW v_edit_inp_orifice AS 
 SELECT v_arc.arc_id,
    v_arc.node_1,
    v_arc.node_2,
    v_arc.y1,
    v_arc.custom_y1,
    v_arc.elev1,
    v_arc.custom_elev1,
    v_arc.sys_elev1,
    v_arc.y2,
    v_arc.custom_y2,
    v_arc.elev2,
    v_arc.custom_elev2,
    v_arc.sys_elev2,
    v_arc.arccat_id,
    v_arc.gis_length,
    v_arc.sector_id,
    v_arc.macrosector_id,
    v_arc.state,
    v_arc.state_type,
    v_arc.annotation,
    v_arc.inverted_slope,
    v_arc.custom_length,
    v_arc.expl_id,
    inp_orifice.ori_type,
    inp_orifice.offsetval,
    inp_orifice.cd,
    inp_orifice.orate,
    inp_orifice.flap,
    inp_orifice.shape,
    inp_orifice.geom1,
    inp_orifice.geom2,
    inp_orifice.geom3,
    inp_orifice.geom4,
    v_arc.the_geom,
    close_time
   FROM selector_sector, v_arc
     JOIN inp_orifice USING (arc_id)
  WHERE v_arc.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW v_edit_inp_flwreg_orifice AS
SELECT
nodarc_id,
node_id,
order_id,
to_arc,
flwreg_length,
ori_type, 
offsetval, 
cd, 
orate,
flap, 
shape, 
geom1, 
geom2,
geom3, 
geom4, 
close_time,
ST_setsrid(ST_makeline(n.the_geom, ST_lineinterpolatepoint(a.the_geom, flwreg_length/st_length(a.the_geom))),SRID_VALUE)::geometry(LINESTRING,SRID_VALUE) as the_geom
FROM selector_sector s, inp_flwreg_orifice f
JOIN v_edit_node n USING (node_id)
LEFT JOIN arc a ON arc_id = to_arc
WHERE s.sector_id = n.sector_id AND cur_user = current_user;


CREATE OR REPLACE VIEW v_edit_inp_flwreg_outlet AS
SELECT
nodarc_id,
node_id,
order_id,
to_arc, 
flwreg_length,
outlet_type, 
offsetval, 
curve_id, 
cd1, 
cd2, 
flap,
ST_setsrid(ST_makeline(n.the_geom, ST_lineinterpolatepoint(a.the_geom, flwreg_length/st_length(a.the_geom))),SRID_VALUE)::geometry(LINESTRING,SRID_VALUE) as the_geom
FROM selector_sector s, inp_flwreg_outlet f
JOIN v_edit_node n USING (node_id)
LEFT JOIN arc a ON arc_id = to_arc
WHERE s.sector_id = n.sector_id AND cur_user = current_user;

CREATE OR REPLACE VIEW v_edit_inp_flwreg_weir AS
SELECT
nodarc_id,
node_id,
order_id,
to_arc,
flwreg_length,
weir_type,
offsetval,
cd,
ec,
cd2, 
flap, 
geom1, 
geom2,
geom3,
geom4,
surcharge,
road_width, 
road_surf,
coef_curve,
ST_setsrid(ST_makeline(n.the_geom, ST_lineinterpolatepoint(a.the_geom, flwreg_length/st_length(a.the_geom))),SRID_VALUE)::geometry(LINESTRING,SRID_VALUE) as the_geom
FROM selector_sector s, inp_flwreg_weir f
JOIN v_edit_node n USING (node_id)
LEFT JOIN arc a ON arc_id = to_arc
WHERE s.sector_id = n.sector_id AND cur_user = current_user;


CREATE OR REPLACE VIEW v_edit_inp_flwreg_pump AS
SELECT
nodarc_id,
node_id,
order_id,
to_arc,
flwreg_length,
curve_id,
status,
startup,
shutoff,
ST_setsrid(ST_makeline(n.the_geom, ST_lineinterpolatepoint(a.the_geom, flwreg_length/st_length(a.the_geom))),SRID_VALUE)::geometry(LINESTRING,SRID_VALUE) as the_geom
FROM selector_sector s, inp_flwreg_pump f
JOIN v_edit_node n USING (node_id)
LEFT JOIN arc a ON arc_id = to_arc
WHERE s.sector_id = n.sector_id AND cur_user = current_user;



DROP VIEW IF EXISTS v_edit_inp_outlet;
CREATE OR REPLACE VIEW v_edit_inp_outlet AS 
 SELECT v_arc.arc_id,
    v_arc.node_1,
    v_arc.node_2,
    v_arc.y1,
    v_arc.custom_y1,
    v_arc.elev1,
    v_arc.custom_elev1,
    v_arc.sys_elev1,
    v_arc.y2,
    v_arc.custom_y2,
    v_arc.elev2,
    v_arc.custom_elev2,
    v_arc.sys_elev2,
    v_arc.arccat_id,
    v_arc.gis_length,
    v_arc.sector_id,
    v_arc.macrosector_id,
    v_arc.state,
    v_arc.state_type,
    v_arc.annotation,
    v_arc.inverted_slope,
    v_arc.custom_length,
    v_arc.expl_id,
    inp_outlet.outlet_type,
    inp_outlet.offsetval,
    inp_outlet.curve_id,
    inp_outlet.cd1,
    inp_outlet.cd2,
    inp_outlet.flap,
    v_arc.the_geom
   FROM selector_sector, v_arc
     JOIN inp_outlet USING (arc_id)
  WHERE v_arc.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW v_edit_inp_dscenario_outfall AS
SELECT
s.dscenario_id,
f.node_id, 
f.elev,
f.ymax,
f.outfall_type,
f.stage, 
f.curve_id,
f.timser_id, 
f.gate,
the_geom
FROM selector_inp_dscenario s, inp_dscenario_outfall f
JOIN v_edit_inp_outfall USING (node_id)
WHERE s.dscenario_id = f.dscenario_id AND cur_user = current_user;


CREATE OR REPLACE VIEW v_edit_inp_dscenario_storage AS
SELECT
s.dscenario_id,
f.node_id, 
f.elev,
f.ymax,
f.storage_type,
f.curve_id, 
f.a1, 
f.a2, 
f.a0, 
f.fevap, 
f.sh, 
f.hc, 
f.imd, 
f.y0,
f.ysur,
f.apond,
the_geom
FROM selector_inp_dscenario s, inp_dscenario_storage f
JOIN v_edit_inp_storage USING (node_id)
WHERE s.dscenario_id = f.dscenario_id AND cur_user = current_user;



CREATE OR REPLACE VIEW v_edit_inp_dscenario_flwreg_weir AS
SELECT
s.dscenario_id,
f.nodarc_id,
f.weir_type,
f.offsetval,
f.cd,
f.ec,
f.cd2, 
f.flap, 
f.geom1, 
f.geom2,
f.geom3,
f.geom4,
f.surcharge,
f.road_width, 
f.road_surf,
f.coef_curve,
the_geom
FROM selector_inp_dscenario s, inp_dscenario_flwreg_weir f
JOIN v_edit_inp_flwreg_weir n USING (nodarc_id)
WHERE s.dscenario_id = f.dscenario_id AND cur_user = current_user;


CREATE OR REPLACE VIEW v_edit_inp_dscenario_flwreg_pump AS
SELECT
s.dscenario_id,
f.nodarc_id,
f.curve_id,
f.status,
f.startup,
f.shutoff,
the_geom
FROM selector_inp_dscenario s, inp_dscenario_flwreg_pump f
JOIN v_edit_inp_flwreg_pump n USING (nodarc_id)
WHERE s.dscenario_id = f.dscenario_id AND cur_user = current_user;


CREATE OR REPLACE VIEW v_edit_inp_dscenario_flwreg_orifice AS
SELECT
s.dscenario_id,
f.nodarc_id,
f.ori_type,
f.offsetval,
f.cd,
f.orate,
f.flap,
f.shape, 
f.geom1, 
f.geom2,
f.geom3,
f.geom4, 
f.close_time,
the_geom
FROM selector_inp_dscenario s, inp_dscenario_flwreg_orifice f
JOIN v_edit_inp_flwreg_orifice n USING (nodarc_id)
WHERE s.dscenario_id = f.dscenario_id AND cur_user = current_user;


CREATE OR REPLACE VIEW v_edit_inp_dscenario_flwreg_outlet AS
SELECT
s.dscenario_id,
f.nodarc_id,
f.outlet_type,
f.offsetval,
f.curve_id,
f.cd1,
f.cd2,
f.flap,
the_geom
FROM selector_inp_dscenario s, inp_dscenario_flwreg_outlet f
JOIN v_edit_inp_flwreg_outlet n USING (nodarc_id)
WHERE s.dscenario_id = f.dscenario_id AND cur_user = current_user;


DROP VIEW IF EXISTS v_edit_inp_dscenario_conduit;
CREATE OR REPLACE VIEW v_edit_inp_dscenario_conduit AS
SELECT
f.dscenario_id,
arc_id,
f.arccat_id,
f.matcat_id,
f.elev1,
f.elev2,
f.custom_n,
f.barrels,
f.culvert,
f.kentry,
f.kexit,
f.kavg,
f.flap,
f.q0,
f.qmax,
f.seepage,
the_geom
FROM selector_inp_dscenario s, inp_dscenario_conduit f
JOIN v_edit_inp_conduit USING (arc_id)
WHERE s.dscenario_id = f.dscenario_id AND cur_user = current_user;


DROP VIEW IF EXISTS v_edit_inp_dscenario_junction;
CREATE OR REPLACE VIEW v_edit_inp_dscenario_junction AS
SELECT
f.dscenario_id,
node_id,
f.elev,
f.ymax,
f.y0,
f.ysur,
f.apond,
f.outfallparam,
the_geom
FROM selector_inp_dscenario s, inp_dscenario_junction f
JOIN v_edit_inp_junction USING (node_id)
WHERE s.dscenario_id = f.dscenario_id AND cur_user = current_user;


CREATE OR REPLACE VIEW v_edit_inp_inflows AS
SELECT
node_id,
order_id,
timser_id,
sfactor,
base,
pattern_id
FROM inp_inflows
JOIN v_edit_inp_junction USING (node_id);


CREATE OR REPLACE VIEW v_edit_inp_dscenario_inflows AS
SELECT
s.dscenario_id,
node_id,
order_id,
timser_id,
sfactor,
base,
pattern_id
FROM selector_inp_dscenario s, inp_dscenario_inflows f
JOIN v_edit_inp_junction USING (node_id)
WHERE s.dscenario_id = f.dscenario_id AND cur_user = current_user;


CREATE OR REPLACE VIEW v_edit_inp_inflows_poll AS
SELECT
node_id,
poll_id,
timser_id,
form_type,
mfactor,
sfactor,
base,
pattern_id
FROM inp_inflows_poll
JOIN v_edit_inp_junction USING (node_id);


CREATE OR REPLACE VIEW v_edit_inp_dscenario_inflows_poll AS
SELECT
s.dscenario_id,
node_id,
poll_id,
timser_id,
form_type,
mfactor,
sfactor,
base,
pattern_id
FROM selector_inp_dscenario s, inp_dscenario_inflows_poll f
JOIN v_edit_inp_junction USING (node_id)
WHERE s.dscenario_id = f.dscenario_id AND cur_user = current_user;


CREATE OR REPLACE VIEW v_edit_inp_treatment AS
SELECT
node_id,
poll_id,
function
FROM inp_treatment
JOIN v_edit_inp_junction USING (node_id);


CREATE OR REPLACE VIEW v_edit_inp_dscenario_treatment AS
SELECT
s.dscenario_id,
node_id, 
poll_id, 
function
FROM selector_inp_dscenario s, inp_dscenario_treatment f
JOIN v_edit_inp_junction USING (node_id)
WHERE s.dscenario_id = f.dscenario_id AND cur_user = current_user;


CREATE OR REPLACE VIEW vu_arc AS 
 WITH vu_node AS (
         SELECT node.node_id,
            node.top_elev,
            node.custom_top_elev,
                CASE
                    WHEN node.custom_top_elev IS NOT NULL THEN node.custom_top_elev
                    ELSE node.top_elev
                END AS sys_top_elev,
            node.ymax,
            node.custom_ymax,
                CASE
                    WHEN node.custom_ymax IS NOT NULL THEN node.custom_ymax
                    ELSE node.ymax
                END AS sys_ymax,
            node.elev,
            node.custom_elev,
                CASE
                    WHEN node.custom_elev IS NOT NULL THEN node.custom_elev
                    WHEN node.elev IS NOT NULL AND node.custom_elev IS NULL THEN node.elev
                    WHEN node.custom_ymax IS NOT NULL THEN
                    CASE
                        WHEN node.custom_top_elev IS NOT NULL THEN node.custom_top_elev - node.custom_ymax
                        ELSE node.top_elev - node.custom_ymax
                    END
                    WHEN node.ymax IS NOT NULL THEN
                    CASE
                        WHEN node.custom_top_elev IS NOT NULL THEN node.custom_top_elev - node.ymax
                        ELSE node.top_elev - node.ymax
                    END
                    ELSE NULL::numeric(12,3)
                END AS sys_elev,
                CASE
                    WHEN node.matcat_id IS NULL THEN cat_node.matcat_id
                    ELSE node.matcat_id
                END AS matcat_id,
            node.node_type,
            exploitation.macroexpl_id
           FROM node
             LEFT JOIN cat_node ON node.nodecat_id::text = cat_node.id::text
             LEFT JOIN exploitation ON node.expl_id = exploitation.expl_id
        )
 SELECT arc.arc_id,
    arc.code,
    arc.node_1,
    a.node_type AS nodetype_1,
    arc.y1,
    arc.custom_y1,
    arc.elev1,
    arc.custom_elev1,
        CASE
            WHEN arc.sys_elev1 IS NULL THEN a.sys_elev::numeric(12,3)
            ELSE arc.sys_elev1
        END AS sys_elev1,
    a.sys_top_elev - arc.sys_elev1 AS sys_y1,
    a.sys_top_elev - arc.sys_elev1 - cat_arc.geom1 AS r1,
        CASE
            WHEN a.sys_elev IS NOT NULL THEN arc.sys_elev1 - a.sys_elev
            ELSE (arc.sys_elev1 - (a.sys_top_elev - a.sys_ymax))::numeric(12,3)
        END AS z1,
    arc.node_2,
    a.node_type AS nodetype_2,
    arc.y2,
    arc.custom_y2,
    arc.elev2,
    arc.custom_elev2,
        CASE
            WHEN arc.sys_elev2 IS NULL THEN b.sys_elev::numeric(12,3)
            ELSE arc.sys_elev2
        END AS sys_elev2,
    b.sys_top_elev - arc.sys_elev2 AS sys_y2,
    b.sys_top_elev - arc.sys_elev2 - cat_arc.geom1 AS r2,
        CASE
            WHEN b.sys_elev IS NOT NULL THEN arc.sys_elev2 - b.sys_elev
            ELSE (arc.sys_elev2 - (b.sys_top_elev - b.sys_ymax))::numeric(12,3)
        END AS z2,
        CASE
            WHEN arc.sys_slope IS NULL AND st_length(arc.the_geom) > 1::double precision THEN ((a.sys_elev - b.sys_elev)::double precision / st_length(arc.the_geom))::numeric(12,4)
            ELSE arc.sys_slope
        END AS slope,
    arc.arc_type,
    cat_feature.system_id AS sys_type,
    arc.arccat_id,
        CASE
            WHEN arc.matcat_id IS NULL THEN cat_arc.matcat_id
            ELSE arc.matcat_id
        END AS matcat_id,
    cat_arc.shape AS cat_shape,
    cat_arc.geom1 AS cat_geom1,
    cat_arc.geom2 AS cat_geom2,
    cat_arc.width,
    arc.epa_type,
    arc.expl_id,
    a.macroexpl_id,
    arc.sector_id,
    sector.macrosector_id,
    arc.state,
    arc.state_type,
    arc.annotation,
    st_length(arc.the_geom)::numeric(12,2) AS gis_length,
    arc.custom_length,
    arc.inverted_slope,
    arc.observ,
    arc.comment,
    arc.dma_id,
    dma.macrodma_id,
    arc.soilcat_id,
    arc.function_type,
    arc.category_type,
    arc.fluid_type,
    arc.location_type,
    arc.workcat_id,
    arc.workcat_id_end,
    arc.builtdate,
    arc.enddate,
    arc.buildercat_id,
    arc.ownercat_id,
    arc.muni_id,
    arc.postcode,
    arc.district_id,
    c.descript::character varying(100) AS streetname,
    arc.postnumber,
    arc.postcomplement,
    d.descript::character varying(100) AS streetname2,
    arc.postnumber2,
    arc.postcomplement2,
    arc.descript,
    concat(cat_feature.link_path, arc.link) AS link,
    arc.verified,
    arc.undelete,
    cat_arc.label,
    arc.label_x,
    arc.label_y,
    arc.label_rotation,
    arc.publish,
    arc.inventory,
    arc.uncertain,
    arc.num_value,
    date_trunc('second'::text, arc.tstamp) AS tstamp,
    arc.insert_user,
    date_trunc('second'::text, arc.lastupdate) AS lastupdate,
    arc.lastupdate_user,
    arc.the_geom,
    arc.workcat_id_plan,
    arc.asset_id,
    arc.pavcat_id
   FROM arc
     JOIN cat_arc ON arc.arccat_id::text = cat_arc.id::text
     LEFT JOIN vu_node a ON a.node_id::text = arc.node_1::text
     LEFT JOIN vu_node b ON b.node_id::text = arc.node_2::text
     JOIN sector ON sector.sector_id = arc.sector_id
     JOIN cat_feature ON arc.arc_type::text = cat_feature.id::text
     JOIN dma ON arc.dma_id = dma.dma_id
     LEFT JOIN v_ext_streetaxis c ON c.id::text = arc.streetaxis_id::text
     LEFT JOIN v_ext_streetaxis d ON d.id::text = arc.streetaxis2_id::text;


CREATE OR REPLACE VIEW v_arc AS 
SELECT * FROM vu_arc
JOIN v_state_arc USING (arc_id);

CREATE OR REPLACE VIEW v_edit_arc AS 
SELECT * FROM v_arc;

CREATE OR REPLACE VIEW ve_arc AS 
SELECT * FROM v_arc;

SELECT gw_fct_admin_manage_child_views($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{"featureType":"ARC"},
 "data":{"filterFields":{}, "pageInfo":{}, "action":"MULTI-UPDATE", "newColumn":"pavcat_id" }}$$);
 
SELECT gw_fct_admin_manage_child_views($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{"systemId":"CONDUIT"},
 "data":{"filterFields":{}, "pageInfo":{}, "action":"MULTI-UPDATE", "newColumn":"inlet_offset" }}$$);

CREATE OR REPLACE VIEW v_plan_aux_arc_pavement AS 
 SELECT a.arc_id,
        CASE 
            WHEN v_price_x_catpavement.thickness IS NULL THEN 0::numeric(12,2)
            ELSE v_price_x_catpavement.thickness::numeric(12,2)
        END AS thickness,
        CASE
            WHEN v_price_x_catpavement.m2pav_cost IS NULL THEN 0::numeric
            ELSE v_price_x_catpavement.m2pav_cost::numeric
        END AS m2pav_cost
   FROM v_edit_arc a
     LEFT JOIN v_price_x_catpavement ON v_price_x_catpavement.pavcat_id::text = a.pavcat_id::text;


DROP VIEW IF EXISTS vi_inflows;
CREATE OR REPLACE VIEW vi_inflows AS
SELECT
node_id,
type,
timser_id,
'FLOW'::text as format,
1::numeric(12,4) as mfactor,
sfactor,
base,
pattern_id
FROM temp_node_other
WHERE type = 'FLOW'
UNION
SELECT
node_id,
poll_id,
timser_id,
other as format,
mfactor,
sfactor,
base,
pattern_id
FROM temp_node_other
WHERE type ='POLLUTANT';


DROP VIEW IF EXISTS vi_treatment;
CREATE OR REPLACE VIEW vi_treatment AS 
 SELECT 
node_id,
poll_id,
other as function
FROM temp_node_other
WHERE type = 'TREATMENT';


DROP VIEW IF EXISTS vi_outlets;
CREATE OR REPLACE VIEW vi_outlets AS 
SELECT arc_id,
node_1,
node_2,
offsetval as "Offset",
outlet_type,
case when curve_id is null then cd1::text else curve_id end as other1,
cd2::text AS other2,
f.flap::varchar AS other3
FROM temp_arc_flowregulator f
JOIN temp_arc USING (arc_id)
WHERE type='OUTLET';


DROP VIEW IF EXISTS vi_orifices;
CREATE OR REPLACE VIEW vi_orifices AS 
SELECT arc_id,
node_1,
node_2,
ori_type,
offsetval as "Offset",
cd,
f.flap,
orate,
close_time
FROM temp_arc_flowregulator f
JOIN temp_arc USING (arc_id)
WHERE type='ORIFICE';


DROP VIEW IF EXISTS vi_weirs;
CREATE OR REPLACE VIEW vi_weirs AS 
SELECT arc_id,
node_1,
node_2,
weir_type,
offsetval as "Offset",
cd,
f.flap,
ec,
cd2,
surcharge,
road_width,
road_surf,
coef_curve
FROM temp_arc_flowregulator f
JOIN temp_arc USING (arc_id)
WHERE type='WEIR';


DROP VIEW IF EXISTS vi_pumps;
CREATE OR REPLACE VIEW vi_pumps AS 
SELECT arc_id,
node_1,
node_2,
curve_id,
status,
startup,
shutoff
FROM temp_arc_flowregulator
JOIN temp_arc USING (arc_id)
WHERE type='PUMP';
  

DROP VIEW IF EXISTS vi_xsections;
CREATE OR REPLACE VIEW vi_xsections AS 
 SELECT arc_id,
    cat_arc_shape.epa AS shape,
    cat_arc.geom1::text AS other1,
    cat_arc.curve_id AS other2,
    0::text AS other3,
    0::text AS other4,
    barrels AS other5,
    NULL::text AS other6
   FROM temp_arc
   JOIN cat_arc ON temp_arc.arccat_id::text = cat_arc.id::text
   JOIN cat_arc_shape ON cat_arc_shape.id::text = cat_arc.shape::text
   WHERE cat_arc_shape.epa::text = 'CUSTOM'::text
UNION
 SELECT arc_id,
    cat_arc_shape.epa AS shape,
    cat_arc.geom1::text AS other1,
    cat_arc.geom2::text AS other2,
    cat_arc.geom3::text AS other3,
    cat_arc.geom4::text AS other4,
    barrels AS other5,
    culvert::text AS other6
    FROM temp_arc
    JOIN cat_arc ON temp_arc.arccat_id::text = cat_arc.id::text
    JOIN cat_arc_shape ON cat_arc_shape.id::text = cat_arc.shape::text
    WHERE cat_arc_shape.epa::text NOT IN ('CUSTOM','IRREGULAR')
UNION
 SELECT arc_id,
    cat_arc_shape.epa AS shape,
    cat_arc.tsect_id AS other1,
    0::character varying AS other2,
    0::text AS other3,
    0::text AS other4,
    barrels AS other5,
    NULL::text AS other6
    FROM temp_arc
    JOIN cat_arc ON temp_arc.arccat_id::text = cat_arc.id::text
    JOIN cat_arc_shape ON cat_arc_shape.id::text = cat_arc.shape::text
    WHERE cat_arc_shape.epa::text = 'IRREGULAR'
UNION
 SELECT arc_id,
    shape,
    geom1::text AS other1,
    geom2::text AS other2,
    geom3::text AS other3,
    geom4::text AS other4,
    NULL::integer AS other5,
    NULL::text AS other6
    FROM temp_arc_flowregulator
    WHERE type IN ('ORIFICE', 'WEIR');

DROP VIEW vi_outfalls;
CREATE OR REPLACE VIEW vi_outfalls AS 
SELECT 
node_id,
elev,
addparam::json->>'outfall_type' as "Outfall type",
addparam::json->>'gate' as "Other 1",
null::text as "Other 2"
FROM temp_node WHERE epa_type  ='OUTFALL' 
AND addparam::json->>'outfall_type' IN ('FREE','NORMAL')
UNION
SELECT 
node_id,
elev,
addparam::json->>'outfall_type' as "outfall_type",
addparam::json->>'state' as "other1",
addparam::json->>'gate' as "other2"
FROM temp_node WHERE epa_type  ='OUTFALL' 
AND addparam::json->>'outfall_type' = 'FIXED'
UNION
SELECT 
node_id,
elev,
addparam::json->>'outfall_type' as "Outfall type",
addparam::json->>'curve_id' as "Other 1",
addparam::json->>'gate' as "Other 2"
FROM temp_node WHERE epa_type  ='OUTFALL' 
AND addparam::json->>'outfall_type' = 'TIDAL'
UNION
SELECT 
node_id,
elev,
addparam::json->>'outfall_type' as "Outfall type",
addparam::json->>'timser_id' as "Other 1",
addparam::json->>'gate' as "Other 2"
FROM temp_node WHERE epa_type  ='OUTFALL' 
AND addparam::json->>'outfall_type' = 'TIMESERIES';


DROP VIEW vi_storage;
CREATE OR REPLACE VIEW vi_storage AS
SELECT
node_id,
elev,
ymax,
y0,
addparam::json->>'storage_type' as "storage_type",
addparam::json->>'a1' AS "other1",
addparam::json->>'a2' AS "other2",
addparam::json->>'a0' AS "other3",
apond::text AS "other4",
addparam::json->>'fevap' AS "other5",
addparam::json->>'sh' AS "other6",
addparam::json->>'hc' AS "other7",
addparam::json->>'imd' AS "other8"
FROM temp_node WHERE epa_type  ='STORAGE' 
AND addparam::json->>'storage_type' = 'FUNCTIONAL'
UNION
SELECT
node_id,
elev,
ymax,
y0,
addparam::json->>'storage_type' as "Storage type",
addparam::json->>'curve_id' AS other1,
apond::text AS other2,
addparam::json->>'fevap' AS other3,
addparam::json->>'sh' AS other4,
addparam::json->>'hc' AS other5,
addparam::json->>'imd' AS other6,
NULL AS other7,
NULL AS other8
FROM temp_node WHERE epa_type  ='STORAGE' 
AND addparam::json->>'storage_type' = 'TABULAR';


DROP VIEW vi_dividers;
CREATE VIEW vi_dividers AS 
SELECT
node_id,
elev,
addparam::json->>'arc_id' as "arc_id",
addparam::json->>'divider_type' AS divider_type,
addparam::json->>'qmin' AS other1,
y0 AS other2,
ysur AS other3,
apond AS other4,
NULL::double precision AS other5,
NULL::double precision AS other6
FROM temp_node WHERE epa_type  ='DIVIDER' 
AND addparam::json->>'divider_type' = 'CUTOFF'
UNION
SELECT
node_id,
elev,
addparam::json->>'arc_id' as "arc_id",
addparam::json->>'divider_type' AS divider_type,
y0::text AS other1,
ysur AS other2,
apond AS other3,
NULL::numeric AS other4,
NULL::double precision AS other5,
NULL::double precision AS other6
FROM temp_node WHERE epa_type  ='DIVIDER' 
AND addparam::json->>'divider_type' = 'OVERFLOW'
UNION
SELECT
node_id,
elev,
addparam::json->>'arc_id' as "arc_id",
addparam::json->>'divider_type' AS divider_type,
addparam::json->>'curve_id' AS other1,
y0 AS other2,
ysur AS other3,
apond AS other4,
NULL::double precision AS other5,
NULL::double precision AS other6
FROM temp_node WHERE epa_type  ='DIVIDER' 
AND addparam::json->>'divider_type' = 'TABULAR'
UNION
SELECT
node_id,
elev,
addparam::json->>'arc_id' as "arc_id",
addparam::json->>'divider_type' AS divider_type,
addparam::json->>'qmin' AS other1,
(addparam::json->>'ht')::numeric AS other2,
(addparam::json->>'cd')::numeric AS other3,
y0 AS other4,
ysur AS other5,
apond AS other6
FROM temp_node WHERE epa_type  ='DIVIDER' 
AND addparam::json->>'divider_type' = 'WEIR';

DROP VIEW IF EXISTS vi_junction;
CREATE OR REPLACE VIEW vi_junctions AS
SELECT 
node_id,
elev,
ymax,
y0,
ysur,
apond,
concat(';',sector_id,' ',node_type)::text as other
FROM temp_node WHERE epa_type  ='JUNCTION'; 


DROP VIEW vi_adjustments;
CREATE OR REPLACE VIEW vi_adjustments AS 
SELECT adj_type as parameter, subc_id, monthly_adj FROM (
SELECT 1 as order, inp_adjustments.adj_type, null as subc_id,
concat(inp_adjustments.value_1, ' ', inp_adjustments.value_2, ' ', inp_adjustments.value_3, ' ', inp_adjustments.value_4, ' ', 
inp_adjustments.value_5, ' ', inp_adjustments.value_6, ' ', inp_adjustments.value_7, ' ', inp_adjustments.value_8, ' ', 
inp_adjustments.value_9, ' ', inp_adjustments.value_10, ' ', inp_adjustments.value_11, ' ', inp_adjustments.value_12) AS monthly_adj
FROM inp_adjustments
UNION
SELECT 2, 'N-PERV' as parameter, subc_id, nperv_pattern_id as montly_adjunstment FROM inp_subcatchment WHERE nperv_pattern_id IS NOT NULL
UNION
SELECT 2, 'DSTORE' , subc_id, dstore_pattern_id as montly_adjunstment FROM inp_subcatchment WHERE dstore_pattern_id IS NOT NULL
UNION
SELECT 2, 'INFIL', subc_id, infil_pattern_id as montly_adjunstment FROM inp_subcatchment WHERE infil_pattern_id IS NOT NULL
)a;


DROP VIEW vi_conduits;
CREATE OR REPLACE VIEW vi_conduits AS 
 SELECT arc_id,
    node_1,
    node_2,
    length,
    n,
    elevmax1 AS z1,
    elevmax2 AS z2,
    t.q0::numeric(12,4) AS q0,
    t.qmax::numeric(12,4) AS qmax,
    concat(';',sector_id,' ',arccat_id,' ',age)::text as other
   FROM temp_arc t
     JOIN inp_conduit USING (arc_id)
UNION
 SELECT t.arc_id,
    node_1,
    node_2,
    length,
    n,
    elevmax1 AS z1,
    elevmax2 AS z2,
    t.q0::numeric(12,4) AS q0,
    t.qmax::numeric(12,4) AS qmax,
    concat(';',sector_id,' ',arccat_id)::text as other
   FROM temp_arc t
     JOIN inp_conduit ON arcparent::text = inp_conduit.arc_id::text;
  