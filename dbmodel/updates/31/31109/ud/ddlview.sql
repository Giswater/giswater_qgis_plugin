/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;


--2019/02/13 
DROP VIEW IF EXISTS v_edit_inp_storage CASCADE;
CREATE VIEW v_edit_inp_storage AS
SELECT 
v_node.node_id, 
top_elev,
custom_top_elev,
ymax,
custom_ymax,
elev,
custom_elev,
sys_elev,
nodecat_id, 
v_node.sector_id, 
macrosector_id,"state", 
the_geom,
annotation,
inp_storage.storage_type, 
inp_storage.curve_id, 
inp_storage.a1, 
inp_storage.a2,
inp_storage.a0, 
inp_storage.fevap, 
inp_storage.sh, 
inp_storage.hc, 
inp_storage.imd, 
inp_storage.y0, 
inp_storage.ysur,
inp_storage.apond
FROM inp_selector_sector, v_node
	JOIN inp_storage ON (((v_node.node_id) = (inp_storage.node_id)))
	WHERE ((v_node.sector_id)=(inp_selector_sector.sector_id) AND inp_selector_sector.cur_user="current_user"());

	
--2019/02/12
CREATE OR REPLACE VIEW v_om_visit AS 
 SELECT distinct ON (visit_id) * FROM (SELECT om_visit.id AS visit_id,
    om_visit.ext_code AS code,
    om_visit.visitcat_id,
    om_visit_cat.name,
    om_visit.startdate AS visit_start,
    om_visit.enddate AS visit_end,
    om_visit.user_name,
    om_visit.is_done,
    om_visit_x_node.node_id AS feature_id,
    'NODE'::text as feature_type,
    om_visit.the_geom
   FROM selector_state,
    om_visit
     JOIN om_visit_x_node ON om_visit_x_node.visit_id = om_visit.id
     JOIN node ON node.node_id::text = om_visit_x_node.node_id::text
     JOIN om_visit_cat ON om_visit.visitcat_id = om_visit_cat.id
  WHERE selector_state.state_id = node.state AND selector_state.cur_user = "current_user"()::text
UNION
 SELECT om_visit.id AS visit_id,
    om_visit.ext_code AS code,
    om_visit.visitcat_id,
    om_visit_cat.name,
    om_visit.startdate AS visit_start,
    om_visit.enddate AS visit_end,
    om_visit.user_name,
    om_visit.is_done,
    om_visit_x_arc.arc_id AS feature_id,
    'ARC'::text as feature_type,
    om_visit.the_geom
   FROM selector_state,
    om_visit
     JOIN om_visit_x_arc ON om_visit_x_arc.visit_id = om_visit.id
     JOIN arc ON arc.arc_id::text = om_visit_x_arc.arc_id::text
     JOIN om_visit_cat ON om_visit.visitcat_id = om_visit_cat.id
  WHERE selector_state.state_id = arc.state AND selector_state.cur_user = "current_user"()::text
UNION
 SELECT om_visit.id AS visit_id,
    om_visit.ext_code AS code,
    om_visit.visitcat_id,
    om_visit_cat.name,
    om_visit.startdate AS visit_start,
    om_visit.enddate AS visit_end,
    om_visit.user_name,
    om_visit.is_done,
    om_visit_x_connec.connec_id AS feature_id,
    'CONNEC'::text as feature_type,
    om_visit.the_geom
   FROM selector_state,
    om_visit
     JOIN om_visit_x_connec ON om_visit_x_connec.visit_id = om_visit.id
     JOIN connec ON connec.connec_id::text = om_visit_x_connec.connec_id::text
     JOIN om_visit_cat ON om_visit.visitcat_id = om_visit_cat.id
  WHERE selector_state.state_id = connec.state AND selector_state.cur_user = "current_user"()::text
UNION
 SELECT om_visit.id AS visit_id,
    om_visit.ext_code AS code,
    om_visit.visitcat_id,
    om_visit_cat.name,
    om_visit.startdate AS visit_start,
    om_visit.enddate AS visit_end,
    om_visit.user_name,
    om_visit.is_done,
    om_visit_x_gully.gully_id AS feature_id,
    'GULLY'::text as feature_type,
    om_visit.the_geom
   FROM selector_state,
    om_visit
     JOIN om_visit_x_gully ON om_visit_x_gully.visit_id = om_visit.id
     JOIN gully ON gully.gully_id::text = om_visit_x_gully.gully_id::text
     JOIN om_visit_cat ON om_visit.visitcat_id = om_visit_cat.id
  WHERE selector_state.state_id = gully.state AND selector_state.cur_user = "current_user"()::text)a;


 
-- 2019/02/08
DROP VIEW IF EXISTS v_anl_flow_connec;
CREATE OR REPLACE VIEW v_anl_flow_connec AS 
 SELECT v_edit_connec.connec_id,
    anl_flow_arc.context,
    anl_flow_arc.expl_id,
    v_edit_connec.the_geom
   FROM anl_flow_arc
     JOIN v_edit_connec ON anl_flow_arc.arc_id::text = v_edit_connec.arc_id::text
     JOIN selector_expl ON anl_flow_arc.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text AND anl_flow_arc.cur_user::name = "current_user"();
	 
	 
DROP VIEW IF EXISTS v_anl_flow_hydrometer;
CREATE OR REPLACE VIEW v_anl_flow_hydrometer AS 
SELECT hydrometer_id AS id,
v_edit_connec.connec_id,
code,
context,
anl_flow_arc.expl_id,
anl_flow_arc.arc_id
FROM selector_expl, anl_flow_arc
	JOIN v_edit_connec on v_edit_connec.arc_id=anl_flow_arc.arc_id
	JOIN rtc_hydrometer_x_connec on rtc_hydrometer_x_connec.connec_id=v_edit_connec.connec_id
	WHERE anl_flow_arc.expl_id=selector_expl.expl_id
	AND selector_expl.cur_user="current_user"()
	AND anl_flow_arc.cur_user="current_user"();

 
-- 2019/03/04
DROP VIEW IF EXISTS v_ui_node_x_connection_upstream;
CREATE OR REPLACE VIEW v_ui_node_x_connection_upstream AS 
 SELECT row_number() OVER (ORDER BY v_edit_arc.node_2)+1000000 AS rid,
    v_edit_arc.node_2 AS node_id,
    v_edit_arc.arc_id AS feature_id,
    v_edit_arc.code AS feature_code,
    v_edit_arc.arc_type AS featurecat_id,
    v_edit_arc.arccat_id,
    v_edit_arc.y1 AS depth,
    st_length2d(v_edit_arc.the_geom)::numeric(12,2) AS length,
    node.node_id AS upstream_id,
    node.code AS upstream_code,
    node.node_type AS upstream_type,
    v_edit_arc.y2 AS upstream_depth,
	sys_type,
    st_x(st_lineinterpolatepoint(v_edit_arc.the_geom, 0.5::double precision)) AS x,
    st_y(st_lineinterpolatepoint(v_edit_arc.the_geom, 0.5::double precision)) AS y
   FROM v_edit_arc
     JOIN node ON v_edit_arc.node_1::text = node.node_id::text
     JOIN arc_type ON arc_type.id::text = v_edit_arc.arc_type::text
 UNION
   SELECT row_number() OVER (ORDER BY node.node_id)+2000000 AS rid,
    node.node_id,
    link.link_id::text AS feature_id,
    NULL::character varying AS feature_code,
    v_edit_connec.connec_type AS featurecat_id,
    v_edit_connec.connecat_id AS arccat_id,
    v_edit_connec.y2 AS depth,
    st_length2d(link.the_geom)::numeric(12,2) AS length,
    v_edit_connec.connec_id AS downstream_id,
    v_edit_connec.code AS downstream_code,
    v_edit_connec.connec_type AS downstream_type,
    v_edit_connec.y1 AS downstream_depth,
	sys_type,
    st_x(v_edit_connec.the_geom) AS x,
    st_y(v_edit_connec.the_geom) AS y
   FROM v_edit_connec
     JOIN link ON link.feature_id::text = v_edit_connec.connec_id::text AND link.feature_type::text = 'CONNEC'
     JOIN node ON link.exit_id::text = node.node_id::text AND link.exit_type::text = 'NODE'::text
     JOIN connec_type ON connec_type.id::text = v_edit_connec.connec_type::text
UNION
 SELECT row_number() OVER (ORDER BY node.node_id)+3000000 AS rid,
    node.node_id,
    link.link_id::text AS feature_id,
    NULL::character varying AS feature_code,
    v_edit_gully.gully_type AS featurecat_id,
    v_edit_gully.connec_arccat_id AS arccat_id,
    v_edit_gully.connec_depth AS depth,
    v_edit_gully.connec_length AS length,
    v_edit_gully.gully_id AS downstream_id,
    v_edit_gully.code AS downstream_code,
    v_edit_gully.gully_type AS downstream_type,
    v_edit_gully.ymax - v_edit_gully.sandbox AS downstream_depth,
    gully_type.man_table AS feature_table,
    st_x(v_edit_gully.the_geom) AS x,
    st_y(v_edit_gully.the_geom) AS y
   FROM v_edit_gully
     JOIN link ON link.feature_id::text = v_edit_gully.gully_id::text AND link.feature_type::text = 'GULLY'
     JOIN node ON link.exit_id::text = node.node_id::text AND link.exit_type::text = 'NODE'::text
     JOIN gully_type ON gully_type.id::text = v_edit_gully.gully_type::text;


DROP VIEW IF EXISTS v_ui_node_x_connection_downstream;
CREATE OR REPLACE VIEW v_ui_node_x_connection_downstream AS 
 SELECT row_number() OVER (ORDER BY v_edit_arc.node_1)+1000000 AS rid,
    v_edit_arc.node_1 AS node_id,
    v_edit_arc.arc_id AS feature_id,
    v_edit_arc.code AS feature_code,
    v_edit_arc.arc_type AS featurecat_id,
    v_edit_arc.arccat_id,
    v_edit_arc.y2 AS depth,
    st_length2d(v_edit_arc.the_geom)::numeric(12,2) AS length,
    node.node_id AS downstream_id,
    node.code AS downstream_code,
    node.node_type AS downstream_type,
    v_edit_arc.y1 AS downstream_depth,
    sys_type,
    st_x(st_lineinterpolatepoint(v_edit_arc.the_geom, 0.5::double precision)) AS x,
    st_y(st_lineinterpolatepoint(v_edit_arc.the_geom, 0.5::double precision)) AS y
   FROM v_edit_arc
     JOIN node ON v_edit_arc.node_2::text = node.node_id::text
     JOIN arc_type ON arc_type.id::text = v_edit_arc.arc_type::text;


--2019/03/06

CREATE OR REPLACE VIEW v_node AS
SELECT node.node_id,
   node.code,
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
           WHEN node.elev IS NOT NULL AND node.custom_elev IS NULL THEN node.elev
           WHEN node.custom_elev IS NOT NULL THEN node.custom_elev
           ELSE null::numeric(12,3)
       END AS sys_elev,
   node.node_type,
   node_type.type AS sys_type,
   node.nodecat_id,
   cat_node.matcat_id AS cat_matcat_id,
   node.epa_type,
   node.sector_id,
   sector.macrosector_id,
   node.state,
   node.state_type,
   node.annotation,
   node.observ,
   node.comment,
   node.dma_id,
   node.soilcat_id,
   node.function_type,
   node.category_type,
   node.fluid_type,
   node.location_type,
   node.workcat_id,
   node.workcat_id_end,
   node.buildercat_id,
   node.builtdate,
   node.enddate,
   node.ownercat_id,
   node.muni_id,
   node.postcode,
   node.streetaxis_id,
   node.postnumber,
   node.postcomplement,
   node.postcomplement2,
   node.streetaxis2_id,
   node.postnumber2,
   node.descript,
   cat_node.svg,
   node.rotation,
   concat(node_type.link_path, node.link) AS link,
   node.verified,
   node.the_geom,
   node.undelete,
   node.label_x,
   node.label_y,
   node.label_rotation,
   node.publish,
   node.inventory,
   node.uncertain,
   node.xyz_date,
   node.unconnected,
   dma.macrodma_id,
   node.expl_id,
   node.num_value
  FROM node
    JOIN v_state_node ON node.node_id::text = v_state_node.node_id::text
    LEFT JOIN cat_node ON node.nodecat_id::text = cat_node.id::text
    LEFT JOIN node_type ON node_type.id::text = node.node_type::text
    LEFT JOIN dma ON node.dma_id = dma.dma_id
    LEFT JOIN sector ON node.sector_id = sector.sector_id;

CREATE OR REPLACE VIEW v_edit_node AS
SELECT v_node.node_id,
   v_node.code,
   v_node.top_elev,
   v_node.custom_top_elev,
   v_node.sys_top_elev,
   v_node.ymax,
   v_node.custom_ymax,
   v_node.sys_ymax,
   v_node.elev,
   v_node.custom_elev,
   CASE WHEN sys_elev is not null then sys_elev
   ELSE (sys_top_elev-sys_ymax)::numeric(12,3) END
   as sys_elev,
   v_node.node_type,
   v_node.sys_type,
   v_node.nodecat_id,
   v_node.cat_matcat_id,
   v_node.epa_type,
   v_node.sector_id,
   v_node.macrosector_id,
   v_node.state,
   v_node.state_type,
   v_node.annotation,
   v_node.observ,
   v_node.comment,
   v_node.dma_id,
   v_node.soilcat_id,
   v_node.function_type,
   v_node.category_type,
   v_node.fluid_type,
   v_node.location_type,
   v_node.workcat_id,
   v_node.workcat_id_end,
   v_node.buildercat_id,
   v_node.builtdate,
   v_node.enddate,
   v_node.ownercat_id,
   v_node.muni_id,
   v_node.postcode,
   v_node.streetaxis_id,
   v_node.postnumber,
   v_node.postcomplement,
   v_node.postcomplement2,
   v_node.streetaxis2_id,
   v_node.postnumber2,
   v_node.descript,
   v_node.svg,
   v_node.rotation,
   v_node.link,
   v_node.verified,
   v_node.the_geom,
   v_node.undelete,
   v_node.label_x,
   v_node.label_y,
   v_node.label_rotation,
   v_node.publish,
   v_node.inventory,
   v_node.uncertain,
   v_node.xyz_date,
   v_node.unconnected,
   v_node.macrodma_id,
   v_node.expl_id,
   v_node.num_value
  FROM v_node
    JOIN cat_node ON v_node.nodecat_id::text = cat_node.id::text;



CREATE OR REPLACE VIEW v_edit_man_junction AS 
SELECT 
v_node.node_id,
code,
top_elev,
custom_top_elev,
ymax,
custom_ymax,
elev,
custom_elev,
CASE WHEN sys_elev is not null then sys_elev
ELSE (sys_top_elev-sys_ymax)::numeric(12,3) END
as sys_elev,
node_type,
nodecat_id,
epa_type,
sector_id,
macrosector_id,
state,
state_type,
annotation,
observ,
comment,
dma_id,
soilcat_id,
function_type,
category_type,
fluid_type,
location_type,
workcat_id,
workcat_id_end,
buildercat_id,
builtdate,
enddate,
ownercat_id,
muni_id,
postcode,
streetaxis_id,
postnumber,
postcomplement,
streetaxis2_id,
postnumber2,
postcomplement2,
descript,
rotation,
svg,
link,
verified,
the_geom,
undelete,
label_x,
label_y,
label_rotation,
publish,
inventory,
uncertain,
xyz_date,
unconnected,
macrodma_id,
expl_id,
num_value
FROM v_node
  JOIN man_junction ON man_junction.node_id = v_node.node_id;
  
   
CREATE OR REPLACE VIEW v_edit_man_outfall AS 
SELECT 
v_node.node_id,
code,
top_elev,
custom_top_elev,
ymax,
custom_ymax,
elev,
custom_elev,
CASE WHEN sys_elev is not null then sys_elev
ELSE (sys_top_elev-sys_ymax)::numeric(12,3) END
as sys_elev,
node_type,
nodecat_id,
epa_type,
sector_id,
macrosector_id,
state,
state_type,
annotation,
observ,
comment,
dma_id,
soilcat_id,
function_type,
category_type,
fluid_type,
location_type,
workcat_id,
workcat_id_end,
buildercat_id,
builtdate,
enddate,
ownercat_id,
muni_id,
postcode,
streetaxis_id,
postnumber,
postcomplement,
streetaxis2_id,
postnumber2,
postcomplement2,
descript,
rotation,
svg,
link,
verified,
the_geom,
undelete,
label_x,
label_y,
label_rotation,
publish,
inventory,
uncertain,
xyz_date,
unconnected,
macrodma_id,
expl_id,
num_value,
man_outfall.name
FROM v_node
  JOIN man_outfall ON man_outfall.node_id = v_node.node_id;
  
  
CREATE OR REPLACE VIEW v_edit_man_storage AS 
SELECT 
v_node.node_id,
code,
top_elev,
custom_top_elev,
ymax,
custom_ymax,
elev,
custom_elev,
CASE WHEN sys_elev is not null then sys_elev
ELSE (sys_top_elev-sys_ymax)::numeric(12,3) END
as sys_elev,
node_type,
nodecat_id,
epa_type,
sector_id,
macrosector_id,
state,
state_type,
annotation,
observ,
comment,
dma_id,
soilcat_id,
function_type,
category_type,
fluid_type,
location_type,
workcat_id,
workcat_id_end,
buildercat_id,
builtdate,
enddate,
ownercat_id,
muni_id,
postcode,
streetaxis_id,
postnumber,
postcomplement,
streetaxis2_id,
postnumber2,
postcomplement2,
descript,
rotation,
svg,
link,
verified,
the_geom,
undelete,
label_x,
label_y,
label_rotation,
publish,
inventory,
uncertain,
xyz_date,
unconnected,
macrodma_id,
expl_id,
num_value,
man_storage.pol_id,
man_storage.length,
man_storage.width,
man_storage.custom_area,
man_storage.max_volume,
man_storage.util_volume,
man_storage.min_height,
man_storage.accessibility,
man_storage.name
FROM v_node
  JOIN man_storage ON man_storage.node_id = v_node.node_id;
  
   
   
CREATE OR REPLACE VIEW v_edit_man_valve AS 
SELECT 
v_node.node_id,
code,
top_elev,
custom_top_elev,
ymax,
custom_ymax,
elev,
custom_elev,
CASE WHEN sys_elev is not null then sys_elev
ELSE (sys_top_elev-sys_ymax)::numeric(12,3) END
as sys_elev,
node_type,
nodecat_id,
epa_type,
sector_id,
macrosector_id,
state,
state_type,
annotation,
observ,
comment,
dma_id,
soilcat_id,
function_type,
category_type,
fluid_type,
location_type,
workcat_id,
workcat_id_end,
buildercat_id,
builtdate,
enddate,
ownercat_id,
muni_id,
postcode,
streetaxis_id,
postnumber,
postcomplement,
streetaxis2_id,
postnumber2,
postcomplement2,
descript,
rotation,
svg,
link,
verified,
the_geom,
v_node.undelete,
label_x,
label_y,
label_rotation,
publish,
inventory,
uncertain,
xyz_date,
unconnected,
macrodma_id,
expl_id,
num_value,
man_valve.name
FROM v_node
  JOIN man_valve ON man_valve.node_id = v_node.node_id;
  
   
   
CREATE OR REPLACE VIEW v_edit_man_netinit AS 
SELECT 
v_node.node_id,
code,
top_elev,
custom_top_elev,
ymax,
custom_ymax,
elev,
custom_elev,
CASE WHEN sys_elev is not null then sys_elev
ELSE (sys_top_elev-sys_ymax)::numeric(12,3) END
as sys_elev,
node_type,
nodecat_id,
epa_type,
sector_id,
macrosector_id,
state,
state_type,
annotation,
observ,
comment,
dma_id,
soilcat_id,
function_type,
category_type,
fluid_type,
location_type,
workcat_id,
workcat_id_end,
buildercat_id,
builtdate,
enddate,
ownercat_id,
muni_id,
postcode,
streetaxis_id,
postnumber,
postcomplement,
streetaxis2_id,
postnumber2,
postcomplement2,
descript,
rotation,
svg,
link,
verified,
the_geom,
v_node.undelete,
label_x,
label_y,
label_rotation,
publish,
inventory,
uncertain,
xyz_date,
unconnected,
macrodma_id,
expl_id,
num_value,
man_netinit.length,
man_netinit.width,
man_netinit.inlet,
man_netinit.bottom_channel,
man_netinit.accessibility,
man_netinit.name,
man_netinit.sander_depth
FROM v_node
  JOIN man_netinit ON man_netinit.node_id = v_node.node_id;


   
CREATE OR REPLACE VIEW v_edit_man_manhole AS 
SELECT 
v_node.node_id,
code,
top_elev,
custom_top_elev,
ymax,
custom_ymax,
elev,
custom_elev,
CASE WHEN sys_elev is not null then sys_elev
ELSE (sys_top_elev-sys_ymax)::numeric(12,3) END
as sys_elev,
node_type,
nodecat_id,
epa_type,
sector_id,
macrosector_id,
state,
state_type,
annotation,
observ,
comment,
dma_id,
soilcat_id,
function_type,
category_type,
fluid_type,
location_type,
workcat_id,
workcat_id_end,
buildercat_id,
builtdate,
enddate,
ownercat_id,
muni_id,
postcode,
streetaxis_id,
postnumber,
postcomplement,
streetaxis2_id,
postnumber2,
postcomplement2,
descript,
rotation,
svg,
link,
verified,
the_geom,
v_node.undelete,
label_x,
label_y,
label_rotation,
publish,
inventory,
uncertain,
xyz_date,
unconnected,
macrodma_id,
expl_id,
num_value,
man_manhole.length,
man_manhole.width,
man_manhole.sander_depth,
man_manhole.prot_surface,
man_manhole.inlet,
man_manhole.bottom_channel,
man_manhole.accessibility
FROM v_node
  JOIN man_manhole ON man_manhole.node_id = v_node.node_id;
  

CREATE OR REPLACE VIEW v_edit_man_wjump AS 
SELECT 
v_node.node_id,
code,
top_elev,
custom_top_elev,
ymax,
custom_ymax,
elev,
custom_elev,
CASE WHEN sys_elev is not null then sys_elev
ELSE (sys_top_elev-sys_ymax)::numeric(12,3) END
as sys_elev,
node_type,
nodecat_id,
epa_type,
sector_id,
macrosector_id,
state,
state_type,
annotation,
observ,
comment,
dma_id,
soilcat_id,
function_type,
category_type,
fluid_type,
location_type,
workcat_id,
workcat_id_end,
buildercat_id,
builtdate,
enddate,
ownercat_id,
muni_id,
postcode,
streetaxis_id,
postnumber,
postcomplement,
streetaxis2_id,
postnumber2,
postcomplement2,
descript,
rotation,
svg,
link,
verified,
the_geom,
v_node.undelete,
label_x,
label_y,
label_rotation,
publish,
inventory,
uncertain,
xyz_date,
unconnected,
macrodma_id,
expl_id,
num_value,
man_wjump.length,
man_wjump.width,
man_wjump.sander_depth,
man_wjump.prot_surface,
man_wjump.accessibility,
man_wjump.name
FROM v_node
  JOIN man_wjump ON man_wjump.node_id = v_node.node_id;


CREATE OR REPLACE VIEW v_edit_man_netgully AS 
SELECT 
v_node.node_id,
code,
top_elev,
custom_top_elev,
ymax,
custom_ymax,
elev,
custom_elev,
CASE WHEN sys_elev is not null then sys_elev
ELSE (sys_top_elev-sys_ymax)::numeric(12,3) END
as sys_elev,
node_type,
nodecat_id,
epa_type,
sector_id,
macrosector_id,
state,
state_type,
annotation,
observ,
comment,
dma_id,
soilcat_id,
function_type,
category_type,
fluid_type,
location_type,
workcat_id,
workcat_id_end,
buildercat_id,
builtdate,
enddate,
ownercat_id,
muni_id,
postcode,
streetaxis_id,
postnumber,
postcomplement,
streetaxis2_id,
postnumber2,
postcomplement2,
descript,
rotation,
svg,
link,
verified,
the_geom,
v_node.undelete,
label_x,
label_y,
label_rotation,
publish,
inventory,
uncertain,
xyz_date,
unconnected,
macrodma_id,
expl_id,
num_value,
man_netgully.pol_id,
man_netgully.sander_depth,
man_netgully.gratecat_id,
man_netgully.units,
man_netgully.groove,
man_netgully.siphon
FROM v_node
  JOIN man_netgully ON man_netgully.node_id = v_node.node_id;


CREATE OR REPLACE VIEW v_edit_man_chamber AS 
SELECT 
v_node.node_id,
code ,
top_elev,
custom_top_elev,
ymax,
custom_ymax,
elev,
custom_elev,
CASE WHEN sys_elev is not null then sys_elev
ELSE (sys_top_elev-sys_ymax)::numeric(12,3) END
as sys_elev,
node_type,
nodecat_id,
epa_type,
sector_id,
macrosector_id,
state,
state_type,
annotation,
observ,
comment,
dma_id,
soilcat_id,
function_type,
category_type,
fluid_type,
location_type,
workcat_id,
workcat_id_end,
buildercat_id,
builtdate,
enddate,
ownercat_id,
muni_id,
postcode,
streetaxis_id,
postnumber,
postcomplement,
streetaxis2_id,
postnumber2,
postcomplement2,
descript,
rotation,
svg,
link,
verified,
the_geom,
undelete,
label_x,
label_y,
label_rotation,
publish,
inventory,
uncertain,
xyz_date,
unconnected,
macrodma_id,
expl_id,
num_value,
man_chamber.pol_id,
man_chamber.length,
man_chamber.width,
man_chamber.sander_depth,
man_chamber.max_volume,
man_chamber.util_volume,
man_chamber.inlet,
man_chamber.bottom_channel,
man_chamber.accessibility,
man_chamber.name
FROM v_node
    JOIN man_chamber ON man_chamber.node_id = v_node.node_id;
   
   
CREATE OR REPLACE VIEW v_edit_man_wwtp AS 
SELECT 
v_node.node_id,
code,
top_elev,
custom_top_elev,
ymax,
custom_ymax,
elev,
custom_elev,
CASE WHEN sys_elev is not null then sys_elev
ELSE (sys_top_elev-sys_ymax)::numeric(12,3) END
as sys_elev,
node_type,
nodecat_id,
epa_type,
sector_id,
macrosector_id,
state,
state_type,
annotation,
observ,
comment,
dma_id,
soilcat_id,
function_type,
category_type,
fluid_type,
location_type,
workcat_id,
workcat_id_end,
buildercat_id,
builtdate,
enddate,
ownercat_id,
muni_id,
postcode,
streetaxis_id,
postnumber,
postcomplement,
streetaxis2_id,
postnumber2,
postcomplement2,
descript,
rotation,
svg,
link,
verified,
the_geom,
undelete,
label_x,
label_y,
label_rotation,
publish,
inventory,
uncertain,
xyz_date,
unconnected,
macrodma_id,
expl_id,
num_value,
man_wwtp.pol_id,
man_wwtp.name
FROM v_node
  JOIN man_wwtp ON man_wwtp.node_id = v_node.node_id;
  

CREATE OR REPLACE VIEW v_edit_man_netelement AS 
SELECT 
v_node.node_id,
code,
top_elev,
custom_top_elev,
ymax,
custom_ymax,
elev,
custom_elev,
CASE WHEN sys_elev is not null then sys_elev
ELSE (sys_top_elev-sys_ymax)::numeric(12,3) END
as sys_elev,
node_type,
nodecat_id,
epa_type,
sector_id,
macrosector_id,
state,
state_type,
annotation,
observ,
comment,
dma_id,
soilcat_id,
function_type,
category_type,
fluid_type,
location_type,
workcat_id,
workcat_id_end,
buildercat_id,
builtdate,
enddate,
ownercat_id,
muni_id,
postcode,
streetaxis_id,
postnumber,
postcomplement,
streetaxis2_id,
postnumber2,
postcomplement2,
descript,
rotation,
svg,
link,
verified,
the_geom,
undelete,
label_x,
label_y,
label_rotation,
publish,
inventory,
uncertain,
xyz_date,
unconnected,
macrodma_id,
expl_id,
num_value,
man_netelement.serial_number
FROM v_node
  JOIN man_netelement ON man_netelement.node_id = v_node.node_id;


CREATE OR REPLACE VIEW vu_node AS 
 SELECT node.node_id,
    node.code,
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
            WHEN node.elev IS NOT NULL AND node.custom_elev IS NULL THEN node.elev
            WHEN node.custom_elev IS NOT NULL THEN node.custom_elev
            ELSE NULL::numeric(12,3)
        END AS sys_elev,
    node.node_type,
    node_type.type AS sys_type,
    node.nodecat_id,
    cat_node.matcat_id AS cat_matcat_id,
    node.epa_type,
    node.sector_id,
    sector.macrosector_id,
    node.state,
    node.state_type,
    node.annotation,
    node.observ,
    node.comment,
    node.dma_id,
    node.soilcat_id,
    node.function_type,
    node.category_type,
    node.fluid_type,
    node.location_type,
    node.workcat_id,
    node.workcat_id_end,
    node.buildercat_id,
    node.builtdate,
    node.enddate,
    node.ownercat_id,
    node.muni_id,
    node.postcode,
    node.streetaxis_id,
    node.postnumber,
    node.postcomplement,
    node.postcomplement2,
    node.streetaxis2_id,
    node.postnumber2,
    node.descript,
    cat_node.svg,
    node.rotation,
    concat(node_type.link_path, node.link) AS link,
    node.verified,
    node.the_geom,
    node.undelete,
    node.label_x,
    node.label_y,
    node.label_rotation,
    node.publish,
    node.inventory,
    node.uncertain,
    node.xyz_date,
    node.unconnected,
    dma.macrodma_id,
    node.expl_id,
    node.num_value
   FROM node
     LEFT JOIN cat_node ON node.nodecat_id::text = cat_node.id::text
     LEFT JOIN node_type ON node_type.id::text = node.node_type::text
     LEFT JOIN dma ON node.dma_id = dma.dma_id
     LEFT JOIN sector ON node.sector_id = sector.sector_id;



CREATE OR REPLACE VIEW v_arc_x_node AS 
 SELECT v_arc.arc_id,
    v_arc.code,
    v_arc.node_1,
    v_arc.y1,
    v_arc.custom_y1,
    v_arc.elev1,
    v_arc.custom_elev1,
    v_arc.sys_elev1,
    a.sys_top_elev - v_arc.sys_elev1 AS sys_y1,
    a.sys_top_elev - v_arc.sys_elev1 - v_arc.geom1 AS r1,
       CASE
            WHEN a.sys_elev IS NOT NULL THEN (v_arc.sys_elev1 - a.sys_elev)
            ELSE  (v_arc.sys_elev1 -(a.sys_top_elev - a.sys_ymax))::numeric(12,3)
        END AS z1,
    v_arc.node_2,
    v_arc.y2,
    v_arc.custom_y2,
    v_arc.elev2,
    v_arc.custom_elev2,
    v_arc.sys_elev2,
    b.sys_top_elev - v_arc.sys_elev2 AS sys_y2,
    b.sys_top_elev - v_arc.sys_elev2 - v_arc.geom1 AS r2,
        CASE
            WHEN b.sys_elev IS NOT NULL THEN (v_arc.sys_elev2 - b.sys_elev)
            ELSE  (v_arc.sys_elev2 -(b.sys_top_elev - b.sys_ymax))::numeric(12,3)
        END AS z2,
    v_arc.sys_slope AS slope,
    v_arc.arc_type,
    arc_type.type AS sys_type,
    v_arc.arccat_id,
    v_arc.matcat_id,
    v_arc.shape,
    v_arc.geom1,
    v_arc.geom2,
    v_arc.width,
    v_arc.epa_type,
    v_arc.sector_id,
    sector.macrosector_id,
    v_arc.state,
    v_arc.state_type,
    v_arc.annotation,
    v_arc.custom_length,
    v_arc.gis_length,
    v_arc.observ,
    v_arc.comment,
    v_arc.inverted_slope,
    v_arc.dma_id,
    dma.macrodma_id,
    v_arc.soilcat_id,
    v_arc.function_type,
    v_arc.category_type,
    v_arc.fluid_type,
    v_arc.location_type,
    v_arc.workcat_id,
    v_arc.workcat_id_end,
    v_arc.buildercat_id,
    v_arc.builtdate,
    v_arc.enddate,
    v_arc.ownercat_id,
    v_arc.muni_id,
    v_arc.postcode,
    v_arc.streetaxis_id,
    v_arc.postnumber,
    v_arc.postcomplement,
    v_arc.postcomplement2,
    v_arc.streetaxis2_id,
    v_arc.postnumber2,
    v_arc.descript,
    concat(arc_type.link_path, v_arc.link) AS link,
    v_arc.verified,
    v_arc.the_geom,
    v_arc.undelete,
    v_arc.label_x,
    v_arc.label_y,
    v_arc.label_rotation,
    v_arc.publish,
    v_arc.inventory,
    v_arc.uncertain,
    v_arc.expl_id,
    v_arc.num_value
   FROM v_arc
     JOIN sector ON sector.sector_id = v_arc.sector_id
     JOIN arc_type ON v_arc.arc_type::text = arc_type.id::text
     JOIN dma ON v_arc.dma_id = dma.dma_id
     LEFT JOIN vu_node a ON a.node_id::text = v_arc.node_1::text
     LEFT JOIN vu_node b ON b.node_id::text = v_arc.node_2::text;
