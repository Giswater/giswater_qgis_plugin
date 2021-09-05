/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


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
    gully.connec_depth,
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
    CASE WHEN gully.connec_matcat_id is null then ca.matcat_id END as connec_matcat_id,
	gully.gratecat2_id
   FROM gully
     LEFT JOIN cat_grate ON gully.gratecat_id::text = cat_grate.id::text
     LEFT JOIN ext_streetaxis ON gully.streetaxis_id::text = ext_streetaxis.id::text
     LEFT JOIN dma ON gully.dma_id = dma.dma_id
     LEFT JOIN sector ON gully.sector_id = sector.sector_id
     LEFT JOIN exploitation ON gully.expl_id = exploitation.expl_id
     LEFT JOIN cat_feature ON gully.gully_type::text = cat_feature.id::text
     LEFT JOIN v_ext_streetaxis c ON c.id::text = gully.streetaxis_id::text
     LEFT JOIN v_ext_streetaxis d ON d.id::text = gully.streetaxis2_id::text
     LEFT JOIN cat_arc ca ON ca.id = connec_arccat_id;

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


DROP VIEW IF EXISTS v_edit_inp_gully;
CREATE OR REPLACE VIEW v_edit_inp_gully as
SELECT 
gully_id, code, isepa, top_elev, ymax, sandbox, connec_matcat_id, gully_type, gratecat_id, units, groove, arc_id, s.sector_id, expl_id, state, state_type, the_geom, annotation, 
connec_length, connec_arccat_id, pjoint_id,
custom_length, custom_n, efficiency, outlet_depth, y0, ysur, q0, qmax, flap
FROM selector_sector s, v_edit_gully g
left JOIN inp_gully USING (gully_id)
WHERE g.sector_id  = s.sector_id AND cur_user = current_user;

CREATE OR REPLACE VIEW vi_gully AS 
SELECT 
gully_id,
xcoord,
ycoord,
units,
groove,
elev as bottom,
elev-sandbox as elev,
top_elev-elev as ymax,
y0,
ysur
FROM temp_gully;

CREATE OR REPLACE VIEW vi_grate AS 
SELECT
gully_id,
grate_length as length,
grate_width as width,
total_area,
effective_area,
efficiency,
n_barr_l,
n_barr_w,
n_barr_diag,
a_param,
b_param
FROM temp_gully;

CREATE OR REPLACE VIEW vi_link AS 
SELECT
gully_id,
pjoint_id as outlet_id,
link_length as length,
n,
z1,
z2,
q0,
qmax,
shape
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