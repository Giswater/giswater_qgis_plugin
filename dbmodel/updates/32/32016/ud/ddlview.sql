/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;

DROP VIEW IF EXISTS ve_lot_x_gully;
CREATE OR REPLACE VIEW ve_lot_x_gully AS 
 SELECT row_number() OVER (ORDER BY om_visit_lot_x_gully.lot_id, gully.gully_id) AS rid,
    gully.gully_id,
    lower(gully.feature_type::text) AS feature_type,
    gully.code,
    om_visit_lot.visitclass_id,
    om_visit_lot_x_gully.lot_id,
    om_visit_lot_x_gully.status,
    om_typevalue.idval AS status_name,
    om_visit_lot_x_gully.observ,
    gully.the_geom
   FROM selector_lot,
    om_visit_lot
     JOIN om_visit_lot_x_gully ON om_visit_lot_x_gully.lot_id = om_visit_lot.id
     JOIN gully ON gully.gully_id::text = om_visit_lot_x_gully.gully_id::text
     LEFT JOIN om_typevalue ON om_typevalue.id = om_visit_lot_x_gully.status AND om_typevalue.typevalue = 'lot_x_feature_status'::text
  WHERE om_visit_lot.id = selector_lot.lot_id AND selector_lot.cur_user = "current_user"()::text;


  
CREATE OR REPLACE VIEW v_edit_inp_junction AS
SELECT DISTINCT ON (node_id) 
v_node.node_id, 
top_elev,
custom_top_elev,
ymax,
custom_ymax,
elev,
custom_elev,
elev AS sys_elev,
nodecat_id, 
v_node.sector_id, 
v_node.macrosector_id,
v_node.state, 
v_node.the_geom,
v_node.annotation, 
inp_junction.y0, 
inp_junction.ysur,
inp_junction.apond,
inp_junction.outfallparam::text
FROM inp_selector_sector, v_node
     JOIN inp_junction ON inp_junction.node_id = v_node.node_id
     JOIN vi_parent_arc a ON (a.node_1=v_node.node_id OR a.node_2=v_node.node_id)
     WHERE a.sector_id = inp_selector_sector.sector_id AND inp_selector_sector.cur_user = "current_user"()::text;

	 
DROP VIEW vi_outfalls;
CREATE OR REPLACE VIEW vi_outfalls AS 
 SELECT rpt_inp_node.node_id,
    rpt_inp_node.elev,
    inp_outfall.outfall_type,
    inp_outfall.stage::text as other1, 
    inp_outfall.gate::text as other2
   FROM inp_selector_result, rpt_inp_node
     JOIN inp_outfall ON inp_outfall.node_id::text = rpt_inp_node.node_id::text
  WHERE inp_outfall.outfall_type::text = 'FIXED'::text AND rpt_inp_node.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_node.node_id,
    rpt_inp_node.elev,
    inp_outfall.outfall_type,
    inp_outfall.gate,
    null as other2
   FROM inp_selector_result, rpt_inp_node
     JOIN inp_outfall ON rpt_inp_node.node_id::text = inp_outfall.node_id::text
  WHERE inp_outfall.outfall_type::text = 'FREE'::text AND rpt_inp_node.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_node.node_id,
    rpt_inp_node.elev,
    inp_outfall.outfall_type,
    inp_outfall.gate,
    null as other2
   FROM inp_selector_result, rpt_inp_node
     JOIN inp_outfall ON rpt_inp_node.node_id::text = inp_outfall.node_id::text
  WHERE inp_outfall.outfall_type::text = 'NORMAL'::text AND rpt_inp_node.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_node.node_id,
    rpt_inp_node.elev,
    inp_typevalue.idval AS outfall_type,
    inp_outfall.curve_id,
    inp_outfall.gate
     FROM inp_selector_result, rpt_inp_node
     JOIN inp_outfall ON rpt_inp_node.node_id::text = inp_outfall.node_id::text
     LEFT JOIN inp_typevalue ON inp_typevalue.id::text = inp_outfall.outfall_type::text
  WHERE inp_typevalue.typevalue::text = 'inp_typevalue_outfall'::text AND inp_outfall.outfall_type::text = 'TIDAL'::text 
  AND rpt_inp_node.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_node.node_id,
    rpt_inp_node.elev,
    inp_typevalue.idval AS outfall_type,
    inp_outfall.timser_id,
    inp_outfall.gate
   FROM inp_selector_result, rpt_inp_node
     JOIN inp_outfall ON rpt_inp_node.node_id::text = inp_outfall.node_id::text
     LEFT JOIN inp_typevalue ON inp_typevalue.id::text = inp_outfall.outfall_type::text
  WHERE inp_typevalue.typevalue::text = 'inp_typevalue_outfall'::text AND inp_outfall.outfall_type::text = 'TIMESERIES'::text 
  AND rpt_inp_node.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_node.node_id,
    rpt_inp_node.elev,
    outfallparam->>'outfall_type',
    case when outfallparam->>'stage' is not null then outfallparam->>'stage'
	 when outfallparam->>'curve_id' is not null then outfallparam->>'curve_id'
	 when outfallparam->>'timser_id' is not null then outfallparam->>'timser_id'
    END as other1,
    outfallparam->>'gate' as other2
   FROM inp_selector_result, rpt_inp_node JOIN inp_junction USING (node_id) 
  WHERE rpt_inp_node.epa_type='OUTFALL' AND rpt_inp_node.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text;
   
  

CREATE OR REPLACE VIEW v_edit_inp_divider AS
SELECT DISTINCT ON (node_id) 
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
v_node.macrosector_id,
v_node.state, 
v_node.annotation, 
v_node.the_geom,
inp_divider.divider_type, 
inp_divider.arc_id, 
inp_divider.curve_id, 
inp_divider.qmin, 
inp_divider.ht, 
inp_divider.cd, 
inp_divider.y0, 
inp_divider.ysur, 
inp_divider.apond
FROM inp_selector_sector, v_node
     JOIN inp_divider ON (((v_node.node_id) = (inp_divider.node_id)))
     JOIN vi_parent_arc a ON (a.node_1=v_node.node_id OR a.node_2=v_node.node_id)
     WHERE a.sector_id = inp_selector_sector.sector_id AND inp_selector_sector.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW v_edit_inp_outfall AS
SELECT DISTINCT ON (node_id)
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
v_node.macrosector_id,
v_node."state", 
v_node.the_geom,
v_node.annotation, 
inp_outfall.outfall_type, 
inp_outfall.stage, 
inp_outfall.curve_id, 
inp_outfall.timser_id,
inp_outfall.gate
FROM inp_selector_sector, v_node
     JOIN inp_outfall ON (((v_node.node_id) = (inp_outfall.node_id)))
     JOIN vi_parent_arc a ON (a.node_1=v_node.node_id OR a.node_2=v_node.node_id)
     WHERE a.sector_id = inp_selector_sector.sector_id AND inp_selector_sector.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW v_edit_inp_storage AS
SELECT DISTINCT ON (node_id) 
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
v_node.macrosector_id,
v_node."state", 
v_node.the_geom,
v_node.annotation,
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
     JOIN vi_parent_arc a ON (a.node_1=v_node.node_id OR a.node_2=v_node.node_id)
     WHERE a.sector_id = inp_selector_sector.sector_id AND inp_selector_sector.cur_user = "current_user"()::text;
	 
	 

CREATE OR REPLACE VIEW v_ui_plan_arc_cost AS 
 SELECT arc.arc_id,
    1 AS orderby,
    'element'::text AS identif,
    cat_arc.id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    1 AS measurement,
    1::numeric * v_price_compost.price AS total_cost
   FROM arc
     JOIN cat_arc ON cat_arc.id::text = arc.arccat_id::text
     JOIN v_price_compost ON cat_arc.cost::text = v_price_compost.id::text
     JOIN v_plan_arc ON arc.arc_id::text = v_plan_arc.arc_id::text
UNION
 SELECT arc.arc_id,
    2 AS orderby,
    'm2bottom'::text AS identif,
    cat_arc.id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    v_plan_arc.m2mlbottom AS measurement,
    v_plan_arc.m2mlbottom * v_price_compost.price AS total_cost
   FROM arc
     JOIN cat_arc ON cat_arc.id::text = arc.arccat_id::text
     JOIN v_price_compost ON cat_arc.m2bottom_cost::text = v_price_compost.id::text
     JOIN v_plan_arc ON arc.arc_id::text = v_plan_arc.arc_id::text
UNION
 SELECT arc.arc_id,
    3 AS orderby,
    'm3protec'::text AS identif,
    cat_arc.id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    v_plan_arc.m3mlprotec AS measurement,
    v_plan_arc.m3mlprotec * v_price_compost.price AS total_cost
   FROM arc
     JOIN cat_arc ON cat_arc.id::text = arc.arccat_id::text
     JOIN v_price_compost ON cat_arc.m3protec_cost::text = v_price_compost.id::text
     JOIN v_plan_arc ON arc.arc_id::text = v_plan_arc.arc_id::text
UNION
 SELECT arc.arc_id,
    4 AS orderby,
    'm3exc'::text AS identif,
    cat_soil.id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    v_plan_arc.m3mlexc AS measurement,
    v_plan_arc.m3mlexc * v_price_compost.price AS total_cost
   FROM arc
     JOIN cat_soil ON cat_soil.id::text = arc.soilcat_id::text
     JOIN v_price_compost ON cat_soil.m3exc_cost::text = v_price_compost.id::text
     JOIN v_plan_arc ON arc.arc_id::text = v_plan_arc.arc_id::text
UNION
 SELECT arc.arc_id,
    5 AS orderby,
    'm3fill'::text AS identif,
    cat_soil.id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    v_plan_arc.m3mlfill AS measurement,
    v_plan_arc.m3mlfill * v_price_compost.price AS total_cost
   FROM arc
     JOIN cat_soil ON cat_soil.id::text = arc.soilcat_id::text
     JOIN v_price_compost ON cat_soil.m3fill_cost::text = v_price_compost.id::text
     JOIN v_plan_arc ON arc.arc_id::text = v_plan_arc.arc_id::text
UNION
 SELECT arc.arc_id,
    6 AS orderby,
    'm3excess'::text AS identif,
    cat_soil.id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    v_plan_arc.m3mlexcess AS measurement,
    v_plan_arc.m3mlexcess * v_price_compost.price AS total_cost
   FROM arc
     JOIN cat_soil ON cat_soil.id::text = arc.soilcat_id::text
     JOIN v_price_compost ON cat_soil.m3excess_cost::text = v_price_compost.id::text
     JOIN v_plan_arc ON arc.arc_id::text = v_plan_arc.arc_id::text
UNION
 SELECT arc.arc_id,
    7 AS orderby,
    'm2trenchl'::text AS identif,
    cat_soil.id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    v_plan_arc.m2mltrenchl AS measurement,
    v_plan_arc.m2mltrenchl * v_price_compost.price AS total_cost
   FROM arc
     JOIN cat_soil ON cat_soil.id::text = arc.soilcat_id::text
     JOIN v_price_compost ON cat_soil.m2trenchl_cost::text = v_price_compost.id::text
     JOIN v_plan_arc ON arc.arc_id::text = v_plan_arc.arc_id::text
UNION
 SELECT arc.arc_id,
    8 AS orderby,
    'pavement'::text AS identif,
    cat_pavement.id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    v_plan_arc.m2mlpav * plan_arc_x_pavement.percent AS measurement,
    v_plan_arc.m2mlpav * plan_arc_x_pavement.percent * v_price_compost.price AS total_cost
   FROM arc
     JOIN plan_arc_x_pavement ON plan_arc_x_pavement.arc_id::text = arc.arc_id::text
     JOIN cat_pavement ON cat_pavement.id::text = plan_arc_x_pavement.pavcat_id::text
     JOIN v_price_compost ON cat_pavement.m2_cost::text = v_price_compost.id::text
     JOIN v_plan_arc ON arc.arc_id::text = v_plan_arc.arc_id::text
UNION
 SELECT connec.arc_id,
    9 AS orderby,
    'connec'::text AS identif,
    'Various catalog'::character varying AS catalog_id,
    'Various prices'::character varying AS price_id,
    'ut'::character varying AS unit,
    'Sumatory of connecs cost related to arc. The cost is calculated in combination of parameters depth/length from connec table and catalog price from cat_connec table'::character varying AS descript,
    NULL::numeric AS cost,
    count(connec.connec_id) AS measurement,
    sum(connec.connec_length * (v_price_x_catconnec.cost_mlconnec + v_price_x_catconnec.cost_m3trench * (connec.y1+connec.y2) * 0.333/2) + v_price_x_catconnec.cost_ut)::numeric(12,2) AS total_cost
   FROM connec
     JOIN v_price_x_catconnec ON v_price_x_catconnec.id::text = connec.connecat_id::text
     GROUP BY connec.arc_id
UNION
 SELECT gully.arc_id,
    10 AS orderby,
    'gully'::text AS identif,
    'Various catalog'::character varying AS catalog_id,
    'Various prices'::character varying AS price_id,
    'ut'::character varying AS unit,
    'Sumatory of gully cost related to arc. The cost is calculated in combination of parameters depth/length from gully table and catalog price from cat_grate table'::character varying AS descript,
    NULL::numeric AS cost,
    count(gully.gully_id) AS measurement,
   (sum(v_price_x_catgrate.price) + sum(gully.connec_length * (v_price_x_catconnec.cost_mlconnec + v_price_x_catconnec.cost_m3trench * gully.connec_depth * 0.5)))::numeric(12,2) AS total_cost
   FROM gully
     LEFT JOIN v_price_x_catconnec ON v_price_x_catconnec.id::text = gully.connec_arccat_id::text
     JOIN v_price_x_catgrate ON v_price_x_catgrate.id::text = gully.gratecat_id::text
  GROUP BY gully.arc_id
  ORDER BY 1, 2;
