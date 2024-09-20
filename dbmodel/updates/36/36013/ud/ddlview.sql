/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 07/08/2024
CREATE OR REPLACE VIEW vu_gully AS 
 WITH streetaxis AS (
         SELECT v_ext_streetaxis.id,
            v_ext_streetaxis.descript
           FROM v_ext_streetaxis
        )
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
    cat_grate.width AS grate_width,
    cat_grate.length AS grate_length,
    gully.units,
    gully.groove,
    gully.groove_height,
    gully.groove_length,
    gully.siphon,
    gully.connec_arccat_id,
    gully.connec_length,
    gully.top_elev - gully.ymax + gully.sandbox AS connec_y1,
    gully.connec_y2,
        CASE
            WHEN ((gully.top_elev - gully.ymax + gully.sandbox + gully.connec_y2) / 2::numeric) IS NOT NULL THEN ((gully.top_elev - gully.ymax + gully.sandbox + gully.connec_y2) / 2::numeric)::numeric(12,3)
            ELSE gully.connec_depth
        END AS connec_depth,
    gully.arc_id,
    gully.epa_type,
    gully.expl_id,
    exploitation.macroexpl_id,
    gully.sector_id,
    sector.macrosector_id,
    sector.sector_type,
    gully.drainzone_id,
    drainzone.drainzone_type,
    gully.state,
    gully.state_type,
    gully.annotation,
    gully.observ,
    gully.comment,
    gully.dma_id,
    dma.macrodma_id,
    dma.dma_type,
    gully.soilcat_id,
    gully.function_type,
    gully.category_type,
    gully.fluid_type,
    gully.location_type,
    gully.workcat_id,
    gully.workcat_id_end,
    gully.workcat_id_plan,
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
    mu.region_id,
    mu.province_id,
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
    gully.label_quadrant,
    gully.publish,
    gully.inventory,
    gully.uncertain,
    gully.num_value,
    gully.pjoint_id,
    gully.pjoint_type,
    gully.asset_id,
        CASE
            WHEN gully.connec_matcat_id IS NULL THEN cc.matcat_id::text
            ELSE gully.connec_matcat_id
        END AS connec_matcat_id,
    gully.gratecat2_id,
    gully.units_placement,
    gully.expl_id2,
    vst.is_operative,
    gully.minsector_id,
    gully.macrominsector_id,
    gully.adate,
    gully.adescript,
    gully.siphon_type,
    gully.odorflap,
    gully.placement_type,
    gully.access_type,
    date_trunc('second'::text, gully.tstamp) AS tstamp,
    gully.insert_user,
    date_trunc('second'::text, gully.lastupdate) AS lastupdate,
    gully.lastupdate_user,
    gully.the_geom,
        CASE
            WHEN gully.sector_id > 0 AND vst.is_operative = true AND gully.epa_type::text = 'GULLY'::character varying(16)::text AND cpu.value = '2' THEN gully.epa_type
            ELSE NULL::character varying(16)
        END AS inp_type
   FROM (SELECT value FROM config_param_user WHERE parameter = 'inp_options_networkmode' and cur_user = current_user) cpu, gully
     LEFT JOIN cat_grate ON gully.gratecat_id::text = cat_grate.id::text
     LEFT JOIN dma ON gully.dma_id = dma.dma_id
     LEFT JOIN sector ON gully.sector_id = sector.sector_id
     LEFT JOIN exploitation ON gully.expl_id = exploitation.expl_id
     LEFT JOIN cat_feature ON gully.gully_type::text = cat_feature.id::text
     LEFT JOIN streetaxis c ON c.id::text = gully.streetaxis_id::text
     LEFT JOIN streetaxis d ON d.id::text = gully.streetaxis2_id::text
     LEFT JOIN cat_connec cc ON cc.id::text = gully.connec_arccat_id::text
     LEFT JOIN value_state_type vst ON vst.id = gully.state_type
     LEFT JOIN ext_municipality mu ON gully.muni_id = mu.muni_id
     LEFT JOIN drainzone USING (drainzone_id);


CREATE OR REPLACE VIEW v_state_connec AS 
WITH 
p AS (SELECT connec_id, psector_id, state, arc_id FROM plan_psector_x_connec WHERE active), 
s AS (SELECT * FROM selector_psector WHERE cur_user = current_user), 
c as (SELECT connec_id, state, arc_id FROM connec)
SELECT c.connec_id::varchar(30), c.arc_id FROM selector_state,c WHERE c.state = selector_state.state_id AND selector_state.cur_user = "current_user"()::text
	EXCEPT
SELECT p.connec_id::varchar(30), p.arc_id FROM selector_psector, p WHERE p.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text AND p.state = 0
	UNION
SELECT p.connec_id::varchar(30), p.arc_id FROM selector_psector, p WHERE p.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text AND p.state = 1;



CREATE OR REPLACE VIEW v_state_gully AS 
WITH 
p AS (SELECT gully_id, psector_id, state, arc_id FROM plan_psector_x_gully WHERE active), 
s AS (SELECT * FROM selector_psector WHERE cur_user = current_user), 
c as (SELECT gully_id, state, arc_id FROM gully)
SELECT c.gully_id, c.arc_id FROM selector_state,c WHERE c.state = selector_state.state_id AND selector_state.cur_user = "current_user"()::text
	EXCEPT
SELECT p.gully_id, p.arc_id FROM selector_psector, p WHERE p.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text AND p.state = 0
	UNION
SELECT p.gully_id, p.arc_id FROM selector_psector, p WHERE p.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text AND p.state = 1;



CREATE OR REPLACE VIEW v_state_link_connec AS 
WITH 
p AS (SELECT connec_id, psector_id, state, link_id FROM plan_psector_x_connec WHERE active), 
sp AS (SELECT * FROM selector_psector WHERE cur_user = current_user), 
se AS (SELECT * FROM selector_expl WHERE cur_user = current_user), 
l AS (SELECT link_id, state, expl_id, expl_id2 FROM link)
SELECT l.link_id  FROM selector_state, se, l WHERE l.state = selector_state.state_id AND (l.expl_id = se.expl_id OR l.expl_id2 = se.expl_id) AND selector_state.cur_user = "current_user"()::text AND se.cur_user = "current_user"()::text
	EXCEPT
SELECT p.link_id FROM sp, se, p JOIN l USING (link_id) WHERE p.psector_id = sp.psector_id AND sp.cur_user = "current_user"()::text AND p.state = 0 AND l.expl_id = se.expl_id AND se.cur_user = CURRENT_USER::text
	UNION
SELECT p.link_id FROM sp, se, p JOIN l USING (link_id) WHERE p.psector_id = sp.psector_id AND sp.cur_user = "current_user"()::text AND p.state = 1 AND l.expl_id = se.expl_id AND se.cur_user = CURRENT_USER::text;


CREATE OR REPLACE VIEW v_state_link_gully AS 
WITH 
p AS (SELECT gully_id, psector_id, state, link_id FROM plan_psector_x_gully WHERE active), 
sp AS (SELECT * FROM selector_psector WHERE cur_user = current_user), 
se AS (SELECT * FROM selector_expl WHERE cur_user = current_user), 
l AS (SELECT link_id, state, expl_id, expl_id2 FROM link)
SELECT l.link_id  FROM selector_state, se, l WHERE l.state = selector_state.state_id AND (l.expl_id = se.expl_id OR l.expl_id2 = se.expl_id) AND selector_state.cur_user = "current_user"()::text AND se.cur_user = "current_user"()::text
	EXCEPT
SELECT p.link_id FROM sp, se, p JOIN l USING (link_id) WHERE p.psector_id = sp.psector_id AND sp.cur_user = "current_user"()::text AND p.state = 0 AND l.expl_id = se.expl_id AND se.cur_user = CURRENT_USER::text
	UNION
SELECT p.link_id FROM sp, se, p JOIN l USING (link_id) WHERE p.psector_id = sp.psector_id AND sp.cur_user = "current_user"()::text AND p.state = 1 AND l.expl_id = se.expl_id AND se.cur_user = CURRENT_USER::text;


CREATE OR REPLACE VIEW v_state_link AS
SELECT * FROM v_state_link_connec
UNION
SELECT * FROM v_state_link_gully;



