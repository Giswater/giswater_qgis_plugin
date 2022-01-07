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



CREATE OR REPLACE VIEW v_edit_inp_flwreg_weir AS
SELECT
node_id,
order_id,
concat(node_id,'_wei_',order_id) as nodarc_id,
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
the_geom
FROM inp_flwreg_weir f
JOIN v_edit_node USING (node_id);


CREATE OR REPLACE VIEW v_edit_inp_flwreg_pump AS
SELECT
node_id,
order_id,
concat(node_id,'_pum_',order_id) as nodarc_id,
to_arc,
flwreg_length,
curve_id,
status,
startup,
shutoff,
the_geom
FROM inp_flwreg_pump f
JOIN v_edit_node USING (node_id);

  

CREATE OR REPLACE VIEW v_edit_inp_flwreg_orifice AS
SELECT
node_id,
order_id,
concat(node_id,'_ori_',order_id) as nodarc_id,
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
the_geom
FROM inp_flwreg_orifice f
JOIN v_edit_node USING (node_id);


CREATE OR REPLACE VIEW v_edit_inp_flwreg_outlet AS
SELECT
node_id,
order_id,
concat(node_id,'_out_',order_id) as nodarc_id,
to_arc, 
flwreg_length,
outlet_type, 
offsetval, 
curve_id, 
cd1, 
cd2, 
flap,
the_geom
FROM inp_flwreg_outlet f
JOIN v_edit_node USING (node_id);


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
node_id, 
outfall_type,
stage, 
curve_id,
timser_id, 
gate, 
the_geom
FROM selector_inp_dscenario s, inp_dscenario_outfall f
JOIN node USING (node_id)
WHERE s.dscenario_id = f.dscenario_id AND cur_user = current_user;


CREATE OR REPLACE VIEW v_edit_inp_dscenario_storage AS
SELECT
s.dscenario_id,
node_id, 
storage_type,
curve_id, 
a1, 
a2, 
a0, 
fevap, 
sh, 
hc, 
imd, 
y0,
ysur,
apond,
the_geom
FROM selector_inp_dscenario s, inp_dscenario_storage f
JOIN node USING (node_id)
WHERE s.dscenario_id = f.dscenario_id AND cur_user = current_user;


CREATE OR REPLACE VIEW v_edit_inp_dscenario_divider AS
SELECT
s.dscenario_id,
node_id, 
f.elev,
f.ymax,
divider_type,
f.arc_id, 
curve_id,
qmin, 
ht, 
cd, 
y0, 
ysur,
apond 
FROM selector_inp_dscenario s, inp_dscenario_divider f
JOIN node USING (node_id)
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
f.coef_curve
FROM selector_inp_dscenario s, inp_dscenario_flwreg_weir f
WHERE s.dscenario_id = f.dscenario_id AND cur_user = current_user;


CREATE OR REPLACE VIEW v_edit_inp_dscenario_flwreg_pump AS
SELECT
s.dscenario_id,
f.nodarc_id,
f.curve_id,
f.status,
f.startup,
f.shutoff
FROM selector_inp_dscenario s, inp_dscenario_flwreg_pump f
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
f.close_time
FROM selector_inp_dscenario s, inp_dscenario_flwreg_orifice f
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
f.flap
FROM selector_inp_dscenario s, inp_dscenario_flwreg_outlet f
WHERE s.dscenario_id = f.dscenario_id AND cur_user = current_user;


DROP VIEW IF EXISTS v_edit_inp_dscenario_conduit;
CREATE OR REPLACE VIEW v_edit_inp_dscenario_conduit AS
SELECT
f.dscenario_id,
arc_id,
f.arccat_id,
f.matcat_id,
f.y1,
f.y2,
custom_n,
barrels,
culvert,
kentry,
kexit,
kavg,
flap,
q0,
qmax,
seepage
FROM selector_inp_dscenario s, inp_dscenario_conduit f
JOIN arc USING (arc_id)
WHERE s.dscenario_id = f.dscenario_id AND cur_user = current_user;


DROP VIEW IF EXISTS v_edit_inp_dscenario_junction;
CREATE OR REPLACE VIEW v_edit_inp_dscenario_junction AS
SELECT
f.dscenario_id,
node_id,
f.elev,
f.ymax,
y0,
ysur,
apond,
outfallparam
FROM selector_inp_dscenario s, inp_dscenario_junction f
JOIN node USING (node_id)
WHERE s.dscenario_id = f.dscenario_id AND cur_user = current_user;


CREATE OR REPLACE VIEW v_edit_inp_inflows AS
SELECT
node_id,
order_id,
timser_id,
sfactor,
base,
pattern_id,
the_geom
FROM inp_inflows
JOIN node USING (node_id);


CREATE OR REPLACE VIEW v_edit_inp_dscenario_inflows AS
SELECT
s.dscenario_id,
node_id,
order_id,
timser_id,
sfactor,
base,
pattern_id,
the_geom
FROM selector_inp_dscenario s, inp_dscenario_inflows f
JOIN node USING (node_id)
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
pattern_id,
the_geom
FROM inp_inflows_poll
JOIN node USING (node_id);


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
pattern_id,
the_geom
FROM selector_inp_dscenario s, inp_dscenario_inflows_poll f
JOIN node USING (node_id)
WHERE s.dscenario_id = f.dscenario_id AND cur_user = current_user;


CREATE OR REPLACE VIEW v_edit_inp_treatment AS
SELECT
node_id,
poll_id,
function,
the_geom
FROM inp_treatment
JOIN node USING (node_id);


CREATE OR REPLACE VIEW v_edit_inp_dscenario_treatment AS
SELECT
s.dscenario_id,
node_id, 
poll_id, 
function,
the_geom
FROM selector_inp_dscenario s, inp_dscenario_treatment f
JOIN node USING (node_id)
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