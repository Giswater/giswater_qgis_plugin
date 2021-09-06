/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


CREATE OR REPLACE VIEW vi_gully2pjoint AS
SELECT link_id, feature_id, l.feature_type, exit_id, exit_type, l.expl_id, st_makeline(gully.the_geom, r.the_geom)
FROM selector_inp_result s, link l
JOIN gully ON feature_id = gully_id
JOIN rpt_inp_node r ON concat('VN',exit_id) = node_id
WHERE l.feature_type ='GULLY'
AND exit_type = 'VNODE'
AND r.result_id = s.result_id AND cur_user = current_user
UNION
SELECT link_id, feature_id, l.feature_type, exit_id, exit_type, l.expl_id, st_makeline(gully.the_geom, r.the_geom)
FROM selector_inp_result s, link l
JOIN gully ON feature_id = gully_id
JOIN rpt_inp_node r ON concat('VN',exit_id) = fusioned_node
WHERE l.feature_type ='GULLY'
AND exit_type = 'VNODE'
AND r.result_id = s.result_id AND cur_user = current_user;

 
CREATE OR REPLACE VIEW vu_connec AS 
 SELECT connec.connec_id,
    connec.code,
    connec.customer_code,
    connec.top_elev,
    connec.y1,
    connec.y2,
    connec.connecat_id,
    connec.connec_type,
    cat_feature.system_id AS sys_type,
    connec.private_connecat_id,
        CASE
            WHEN connec.matcat_id IS NULL THEN cat_connec.matcat_id
            ELSE connec.matcat_id
        END AS matcat_id,
    connec.expl_id,
    exploitation.macroexpl_id,
    connec.sector_id,
    sector.macrosector_id,
    connec.demand,
    connec.state,
    connec.state_type,
    CASE WHEN (y1+y2)/2 IS NOT NULL THEN ((y1+y2)/2)::numeric(12,3) ELSE connec_depth END as connec_depth,
    connec.connec_length,
    connec.arc_id,
    connec.annotation,
    connec.observ,
    connec.comment,
    connec.dma_id,
    dma.macrodma_id,
    connec.soilcat_id,
    connec.function_type,
    connec.category_type,
    connec.fluid_type,
    connec.location_type,
    connec.workcat_id,
    connec.workcat_id_end,
    connec.buildercat_id,
    connec.builtdate,
    connec.enddate,
    connec.ownercat_id,
    connec.muni_id,
    connec.postcode,
    connec.district_id,
    c.descript::character varying(100) AS streetname,
    connec.postnumber,
    connec.postcomplement,
    d.descript::character varying(100) AS streetname2,
    connec.postnumber2,
    connec.postcomplement2,
    connec.descript,
    cat_connec.svg,
    connec.rotation,
    concat(cat_feature.link_path, connec.link) AS link,
    connec.verified,
    connec.undelete,
    cat_connec.label,
    connec.label_x,
    connec.label_y,
    connec.label_rotation,
    connec.accessibility,
    connec.diagonal,
    connec.publish,
    connec.inventory,
    connec.uncertain,
    connec.num_value,
    connec.pjoint_id,
    connec.pjoint_type,
    date_trunc('second'::text, connec.tstamp) AS tstamp,
    connec.insert_user,
    date_trunc('second'::text, connec.lastupdate) AS lastupdate,
    connec.lastupdate_user,
    connec.the_geom,
    connec.workcat_id_plan,
    connec.asset_id
   FROM connec
     JOIN cat_connec ON connec.connecat_id::text = cat_connec.id::text
     LEFT JOIN ext_streetaxis ON connec.streetaxis_id::text = ext_streetaxis.id::text
     LEFT JOIN dma ON connec.dma_id = dma.dma_id
     LEFT JOIN exploitation ON connec.expl_id = exploitation.expl_id
     LEFT JOIN sector ON connec.sector_id = sector.sector_id
     LEFT JOIN cat_feature ON connec.connec_type::text = cat_feature.id::text
     LEFT JOIN v_ext_streetaxis c ON c.id::text = connec.streetaxis_id::text
     LEFT JOIN v_ext_streetaxis d ON d.id::text = connec.streetaxis2_id::text;


CREATE OR REPLACE VIEW vu_gully AS 
 SELECT gully.gully_id,
    gully.code,
    gully.top_elev,
    gully.ymax,
    gully.sandbox,
    gully.matcat_id,
    gully.gully_type,
    cat_feature.system_id AS sys_type,
    gully.gratecat_id,
    cat_grate.matcat_id AS cat_grate_matcat,
    gully.units,
    gully.groove,
    gully.siphon,
    gully.connec_arccat_id,
    gully.connec_length,
    case when (top_elev-ymax+sandbox+ connec_y2)/2 IS NOT NULL then ((top_elev-ymax+sandbox+ connec_y2)/2)::numeric(12,3) ELSE connec_depth END as connec_depth,
    gully.arc_id,
    gully.expl_id,
    exploitation.macroexpl_id,
    gully.sector_id,
    sector.macrosector_id,
    gully.state,
    gully.state_type,
    gully.annotation,
    gully.observ,
    gully.comment,
    gully.dma_id,
    dma.macrodma_id,
    gully.soilcat_id,
    gully.function_type,
    gully.category_type,
    gully.fluid_type,
    gully.location_type,
    gully.workcat_id,
    gully.workcat_id_end,
    gully.buildercat_id,
    gully.builtdate,
    gully.enddate,
    gully.ownercat_id,
    gully.muni_id,
    gully.postcode,
    gully.district_id,
    c.descript::character varying(100) AS streetname,
    gully.postnumber,
    gully.postcomplement,
    d.descript::character varying(100) AS streetname2,
    gully.postnumber2,
    gully.postcomplement2,
    gully.descript,
    cat_grate.svg,
    gully.rotation,
    concat(cat_feature.link_path, gully.link) AS link,
    gully.verified,
    gully.undelete,
    cat_grate.label,
    gully.label_x,
    gully.label_y,
    gully.label_rotation,
    gully.publish,
    gully.inventory,
    gully.uncertain,
    gully.num_value,
    gully.pjoint_id,
    gully.pjoint_type,
    date_trunc('second'::text, gully.tstamp) AS tstamp,
    gully.insert_user,
    date_trunc('second'::text, gully.lastupdate) AS lastupdate,
    gully.lastupdate_user,
    gully.the_geom,
    gully.workcat_id_plan,
    gully.asset_id,
    CASE WHEN gully.connec_matcat_id is null then cc.matcat_id ELSE gully.connec_matcat_id END as connec_matcat_id,
    	gully.gratecat2_id,
	top_elev-ymax+sandbox AS connec_y1,
	gully.connec_y2	
   FROM gully
     LEFT JOIN cat_grate ON gully.gratecat_id::text = cat_grate.id::text
     LEFT JOIN ext_streetaxis ON gully.streetaxis_id::text = ext_streetaxis.id::text
     LEFT JOIN dma ON gully.dma_id = dma.dma_id
     LEFT JOIN sector ON gully.sector_id = sector.sector_id
     LEFT JOIN exploitation ON gully.expl_id = exploitation.expl_id
     LEFT JOIN cat_feature ON gully.gully_type::text = cat_feature.id::text
     LEFT JOIN v_ext_streetaxis c ON c.id::text = gully.streetaxis_id::text
     LEFT JOIN v_ext_streetaxis d ON d.id::text = gully.streetaxis2_id::text
     LEFT JOIN cat_connec cc ON cc.id = connec_arccat_id;

CREATE OR REPLACE VIEW v_gully AS 
SELECT * FROM vu_gully;

CREATE OR REPLACE VIEW v_edit_gully AS 
SELECT * FROM v_gully;

CREATE OR REPLACE VIEW ve_gully AS 
SELECT * FROM v_edit_gully;

SELECT gw_fct_admin_manage_child_views($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{"featureType":"GULLY"},
"data":{"filterFields":{}, "pageInfo":{}, "action":"MULTI-UPDATE", "newColumn":"connec_matcat_id" }}$$);

SELECT gw_fct_admin_manage_child_views($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{"featureType":"GULLY"},
"data":{"filterFields":{}, "pageInfo":{}, "action":"MULTI-UPDATE", "newColumn":"gratecat2_id" }}$$);

SELECT gw_fct_admin_manage_child_views($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{"featureType":"GULLY"},
"data":{"filterFields":{}, "pageInfo":{}, "action":"MULTI-UPDATE", "newColumn":"connec_y1" }}$$);

SELECT gw_fct_admin_manage_child_views($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{"featureType":"GULLY"},
"data":{"filterFields":{}, "pageInfo":{}, "action":"MULTI-UPDATE", "newColumn":"connec_y2" }}$$);



DROP VIEW IF EXISTS v_edit_inp_gully;
CREATE OR REPLACE VIEW v_edit_inp_gully as
SELECT 
gully_id, code, isepa, top_elev, ymax, sandbox, connec_matcat_id, gully_type, gratecat_id, units, groove, arc_id, s.sector_id, expl_id, state, state_type, the_geom, annotation, 
connec_length, connec_arccat_id, connec_y1, connec_y2, pjoint_id, pjoint_type,
custom_length, custom_n, efficiency, y0, ysur, q0, qmax, flap
FROM selector_sector s, v_edit_gully g
left JOIN inp_gully USING (gully_id)
WHERE g.sector_id  = s.sector_id AND cur_user = current_user;


CREATE OR REPLACE VIEW vi_gully AS 
SELECT 
gully_id,
xcoord,
ycoord,
(elev)::numeric(12,3) as elev,
(top_elev-elev)::numeric(12,3) as ymax,
y0,
ysur
FROM temp_gully;


CREATE OR REPLACE VIEW vi_grate AS 
SELECT
gully_id,
units,
grate_length*0.01 as length,
grate_width*0.01 as width,
total_area,
effective_area,
efficiency::numeric(12,3),
n_barr_l,
n_barr_w,
n_barr_diag,
a_param::numeric(12,5),
b_param::numeric(12,5),
groove
FROM temp_gully;


CREATE OR REPLACE VIEW vi_link AS 
SELECT
gully_id,
pjoint_id as outlet_id,
link_length as length,
n,
y1,
case when y2 is not null then y2::text else '*' end as y2,
q0,
qmax
FROM temp_gully;


CREATE OR REPLACE VIEW vi_lxsections AS 
SELECT
gully_id,
shape as shape,
geom1 as geom1,
geom2 as geom2,
geom3 as geom3,
geom4 as geom4
FROM temp_gully;


CREATE OR REPLACE VIEW vi_conduits AS 
 SELECT rpt_inp_arc.arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    rpt_inp_arc.length,
    rpt_inp_arc.n,
    rpt_inp_arc.elevmax1 AS z1,
    rpt_inp_arc.elevmax2 AS z2,
    rpt_inp_arc.q0::numeric(12,4) AS q0,
    rpt_inp_arc.qmax::numeric(12,4) AS qmax
   FROM selector_inp_result,
    rpt_inp_arc
     JOIN inp_conduit ON rpt_inp_arc.arc_id::text = inp_conduit.arc_id::text
  WHERE rpt_inp_arc.result_id::text = selector_inp_result.result_id::text AND selector_inp_result.cur_user = "current_user"()::text
  UNION
SELECT rpt_inp_arc.arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    rpt_inp_arc.length,
    rpt_inp_arc.n,
    rpt_inp_arc.elevmax1 AS z1,
    rpt_inp_arc.elevmax2 AS z2,
    rpt_inp_arc.q0::numeric(12,4) AS q0,
    rpt_inp_arc.qmax::numeric(12,4) AS qmax
   FROM selector_inp_result,
    rpt_inp_arc
     JOIN inp_conduit ON rpt_inp_arc.arcparent::text = inp_conduit.arc_id::text
  WHERE rpt_inp_arc.result_id::text = selector_inp_result.result_id::text AND selector_inp_result.cur_user = "current_user"()::text;



CREATE OR REPLACE VIEW vi_xsections AS 
 SELECT rpt_inp_arc.arc_id,
    cat_arc_shape.epa AS shape,
    cat_arc.geom1::text AS other1,
    cat_arc.curve_id AS other2,
    0::text AS other3,
    0::text AS other4,
    rpt_inp_arc.barrels AS other5,
    NULL::text AS other6
   FROM selector_inp_result,
    rpt_inp_arc
     JOIN inp_conduit ON rpt_inp_arc.arc_id::text = inp_conduit.arc_id::text
     JOIN cat_arc ON rpt_inp_arc.arccat_id::text = cat_arc.id::text
     JOIN cat_arc_shape ON cat_arc_shape.id::text = cat_arc.shape::text
  WHERE cat_arc_shape.epa::text = 'CUSTOM'::text AND rpt_inp_arc.result_id::text = selector_inp_result.result_id::text AND selector_inp_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_arc.arc_id,
    cat_arc_shape.epa AS shape,
    cat_arc.geom1::text AS other1,
    cat_arc.geom2::text AS other2,
    cat_arc.geom3::text AS other3,
    cat_arc.geom4::text AS other4,
    rpt_inp_arc.barrels AS other5,
    inp_conduit.culvert::text AS other6
   FROM selector_inp_result,
    rpt_inp_arc
     JOIN inp_conduit ON rpt_inp_arc.arc_id::text = inp_conduit.arc_id::text
     JOIN cat_arc ON rpt_inp_arc.arccat_id::text = cat_arc.id::text
     JOIN cat_arc_shape ON cat_arc_shape.id::text = cat_arc.shape::text
  WHERE cat_arc_shape.epa::text <> 'CUSTOM'::text AND cat_arc_shape.epa::text <> 'IRREGULAR'::text AND rpt_inp_arc.result_id::text = selector_inp_result.result_id::text AND selector_inp_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_arc.arc_id,
    cat_arc_shape.epa AS shape,
    cat_arc.tsect_id AS other1,
    NULL::character varying AS other2,
    NULL::text AS other3,
    NULL::text AS other4,
    NULL::integer AS other5,
    NULL::text AS other6
   FROM selector_inp_result,
    rpt_inp_arc
     JOIN inp_conduit ON rpt_inp_arc.arc_id::text = inp_conduit.arc_id::text
     JOIN cat_arc ON rpt_inp_arc.arccat_id::text = cat_arc.id::text
     JOIN cat_arc_shape ON cat_arc_shape.id::text = cat_arc.shape::text
  WHERE cat_arc_shape.epa::text = 'IRREGULAR'::text AND rpt_inp_arc.result_id::text = selector_inp_result.result_id::text AND selector_inp_result.cur_user = "current_user"()::text
UNION
 SELECT inp_orifice.arc_id,
    inp_typevalue.idval AS shape,
    inp_orifice.geom1::text AS other1,
    inp_orifice.geom2::text AS other2,
    inp_orifice.geom3::text AS other3,
    inp_orifice.geom4::text AS other4,
    NULL::integer AS other5,
    NULL::text AS other6
   FROM selector_inp_result,
    rpt_inp_arc
     JOIN inp_orifice ON inp_orifice.arc_id::text = rpt_inp_arc.arc_id::text
     LEFT JOIN inp_typevalue ON inp_typevalue.id::text = inp_orifice.shape::text
  WHERE inp_typevalue.typevalue::text = 'inp_value_orifice'::text AND rpt_inp_arc.result_id::text = selector_inp_result.result_id::text AND selector_inp_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_arc.arc_id,
    inp_typevalue.idval AS shape,
    inp_flwreg_orifice.geom1::text AS other1,
    inp_flwreg_orifice.geom2::text AS other2,
    inp_flwreg_orifice.geom3::text AS other3,
    inp_flwreg_orifice.geom4::text AS other4,
    NULL::integer AS other5,
    NULL::text AS other6
   FROM selector_inp_result,
    rpt_inp_arc
     JOIN inp_flwreg_orifice ON rpt_inp_arc.flw_code::text = concat(inp_flwreg_orifice.node_id, '_', inp_flwreg_orifice.to_arc, '_ori_', inp_flwreg_orifice.flwreg_id)
     LEFT JOIN inp_typevalue ON inp_typevalue.id::text = inp_flwreg_orifice.shape::text
  WHERE inp_typevalue.typevalue::text = 'inp_value_orifice'::text AND rpt_inp_arc.result_id::text = selector_inp_result.result_id::text AND selector_inp_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_arc.arc_id,
    inp_typevalue.descript::character varying(30) AS shape,
    inp_weir.geom1::text AS other1,
    inp_weir.geom2::text AS other2,
    inp_weir.geom3::text AS other3,
    inp_weir.geom4::text AS other4,
    NULL::integer AS other5,
    NULL::text AS other6
   FROM selector_inp_result,
    rpt_inp_arc
     JOIN inp_weir ON inp_weir.arc_id::text = rpt_inp_arc.arc_id::text
     JOIN inp_typevalue ON inp_weir.weir_type::text = inp_typevalue.idval::text
  WHERE rpt_inp_arc.result_id::text = selector_inp_result.result_id::text AND selector_inp_result.cur_user = "current_user"()::text AND inp_typevalue.typevalue::text = 'inp_value_weirs'::text
UNION
 SELECT rpt_inp_arc.arc_id,
    inp_typevalue.descript::character varying(30) AS shape,
    inp_flwreg_weir.geom1::text AS other1,
    inp_flwreg_weir.geom2::text AS other2,
    inp_flwreg_weir.geom3::text AS other3,
    inp_flwreg_weir.geom4::text AS other4,
    NULL::integer AS other5,
    NULL::text AS other6
   FROM selector_inp_result,
    rpt_inp_arc
     JOIN inp_flwreg_weir ON rpt_inp_arc.flw_code::text = concat(inp_flwreg_weir.node_id, '_', inp_flwreg_weir.to_arc, '_weir_', inp_flwreg_weir.flwreg_id)
     JOIN inp_typevalue ON inp_flwreg_weir.weir_type::text = inp_typevalue.idval::text
  WHERE rpt_inp_arc.result_id::text = selector_inp_result.result_id::text AND selector_inp_result.cur_user = "current_user"()::text AND inp_typevalue.typevalue::text = 'inp_value_weirs'::text
UNION

SELECT rpt_inp_arc.arc_id,
    cat_arc_shape.epa AS shape,
    cat_arc.geom1::text AS other1,
    cat_arc.curve_id AS other2,
    0::text AS other3,
    0::text AS other4,
    rpt_inp_arc.barrels AS other5,
    NULL::text AS other6
   FROM selector_inp_result,
    rpt_inp_arc
     JOIN inp_conduit ON rpt_inp_arc.arcparent::text = inp_conduit.arc_id::text
     JOIN cat_arc ON rpt_inp_arc.arccat_id::text = cat_arc.id::text
     JOIN cat_arc_shape ON cat_arc_shape.id::text = cat_arc.shape::text
  WHERE cat_arc_shape.epa::text = 'CUSTOM'::text AND rpt_inp_arc.result_id::text = selector_inp_result.result_id::text AND selector_inp_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_arc.arc_id,
    cat_arc_shape.epa AS shape,
    cat_arc.geom1::text AS other1,
    cat_arc.geom2::text AS other2,
    cat_arc.geom3::text AS other3,
    cat_arc.geom4::text AS other4,
    rpt_inp_arc.barrels AS other5,
    inp_conduit.culvert::text AS other6
   FROM selector_inp_result,
    rpt_inp_arc
     JOIN inp_conduit ON rpt_inp_arc.arcparent::text = inp_conduit.arc_id::text
     JOIN cat_arc ON rpt_inp_arc.arccat_id::text = cat_arc.id::text
     JOIN cat_arc_shape ON cat_arc_shape.id::text = cat_arc.shape::text
  WHERE cat_arc_shape.epa::text <> 'CUSTOM'::text AND cat_arc_shape.epa::text <> 'IRREGULAR'::text AND rpt_inp_arc.result_id::text = selector_inp_result.result_id::text AND selector_inp_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_arc.arc_id,
    cat_arc_shape.epa AS shape,
    cat_arc.tsect_id AS other1,
    NULL::character varying AS other2,
    NULL::text AS other3,
    NULL::text AS other4,
    NULL::integer AS other5,
    NULL::text AS other6
   FROM selector_inp_result,
    rpt_inp_arc
     JOIN inp_conduit ON rpt_inp_arc.arcparent::text = inp_conduit.arc_id::text
     JOIN cat_arc ON rpt_inp_arc.arccat_id::text = cat_arc.id::text
     JOIN cat_arc_shape ON cat_arc_shape.id::text = cat_arc.shape::text
  WHERE cat_arc_shape.epa::text = 'IRREGULAR'::text AND rpt_inp_arc.result_id::text = selector_inp_result.result_id::text AND selector_inp_result.cur_user = "current_user"()::text
UNION
 SELECT inp_orifice.arc_id,
    inp_typevalue.idval AS shape,
    inp_orifice.geom1::text AS other1,
    inp_orifice.geom2::text AS other2,
    inp_orifice.geom3::text AS other3,
    inp_orifice.geom4::text AS other4,
    NULL::integer AS other5,
    NULL::text AS other6
   FROM selector_inp_result,
    rpt_inp_arc
     JOIN inp_orifice ON inp_orifice.arc_id::text = rpt_inp_arc.arcparent::text
     LEFT JOIN inp_typevalue ON inp_typevalue.id::text = inp_orifice.shape::text
  WHERE inp_typevalue.typevalue::text = 'inp_value_orifice'::text AND rpt_inp_arc.result_id::text = selector_inp_result.result_id::text AND selector_inp_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_arc.arc_id,
    inp_typevalue.idval AS shape,
    inp_flwreg_orifice.geom1::text AS other1,
    inp_flwreg_orifice.geom2::text AS other2,
    inp_flwreg_orifice.geom3::text AS other3,
    inp_flwreg_orifice.geom4::text AS other4,
    NULL::integer AS other5,
    NULL::text AS other6
   FROM selector_inp_result,
    rpt_inp_arc
     JOIN inp_flwreg_orifice ON rpt_inp_arc.flw_code::text = concat(inp_flwreg_orifice.node_id, '_', inp_flwreg_orifice.to_arc, '_ori_', inp_flwreg_orifice.flwreg_id)
     LEFT JOIN inp_typevalue ON inp_typevalue.id::text = inp_flwreg_orifice.shape::text
  WHERE inp_typevalue.typevalue::text = 'inp_value_orifice'::text AND rpt_inp_arc.result_id::text = selector_inp_result.result_id::text AND selector_inp_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_arc.arc_id,
    inp_typevalue.descript::character varying(30) AS shape,
    inp_weir.geom1::text AS other1,
    inp_weir.geom2::text AS other2,
    inp_weir.geom3::text AS other3,
    inp_weir.geom4::text AS other4,
    NULL::integer AS other5,
    NULL::text AS other6
   FROM selector_inp_result,
    rpt_inp_arc
     JOIN inp_weir ON inp_weir.arc_id::text = rpt_inp_arc.arcparent::text
     JOIN inp_typevalue ON inp_weir.weir_type::text = inp_typevalue.idval::text
  WHERE rpt_inp_arc.result_id::text = selector_inp_result.result_id::text AND selector_inp_result.cur_user = "current_user"()::text AND inp_typevalue.typevalue::text = 'inp_value_weirs'::text
UNION
 SELECT rpt_inp_arc.arc_id,
    inp_typevalue.descript::character varying(30) AS shape,
    inp_flwreg_weir.geom1::text AS other1,
    inp_flwreg_weir.geom2::text AS other2,
    inp_flwreg_weir.geom3::text AS other3,
    inp_flwreg_weir.geom4::text AS other4,
    NULL::integer AS other5,
    NULL::text AS other6
   FROM selector_inp_result,
    rpt_inp_arc
     JOIN inp_flwreg_weir ON rpt_inp_arc.flw_code::text = concat(inp_flwreg_weir.node_id, '_', inp_flwreg_weir.to_arc, '_weir_', inp_flwreg_weir.flwreg_id)
     JOIN inp_typevalue ON inp_flwreg_weir.weir_type::text = inp_typevalue.idval::text