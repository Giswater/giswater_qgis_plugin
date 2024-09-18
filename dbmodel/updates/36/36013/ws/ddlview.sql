/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 18/09/2024
CREATE OR REPLACE VIEW vu_connec AS 
 WITH streetaxis AS (
         SELECT v_ext_streetaxis.id,
            v_ext_streetaxis.descript
           FROM v_ext_streetaxis
        ), typevalue AS (
         SELECT edit_typevalue.typevalue,
            edit_typevalue.id,
            edit_typevalue.idval
           FROM edit_typevalue
          WHERE edit_typevalue.typevalue::text = ANY (ARRAY['sector_type'::character varying, 'presszone_type'::character varying, 'dma_type'::character varying, 'dqa_type'::character varying]::text[])
        )
 SELECT connec.connec_id,
    connec.code,
    connec.elevation,
    connec.depth,
    cat_connec.connectype_id AS connec_type,
    cat_feature.system_id AS sys_type,
    connec.connecat_id,
    cat_connec.matcat_id AS cat_matcat_id,
    cat_connec.pnom AS cat_pnom,
    cat_connec.dnom AS cat_dnom,
    cat_connec.dint AS cat_dint,
    connec.epa_type,
    connec.state,
    connec.state_type,
    connec.expl_id,
    exploitation.macroexpl_id,
    connec.sector_id,
    sector.name AS sector_name,
    sector.macrosector_id,
    et1.idval::character varying(16) AS sector_type,
    connec.presszone_id,
    presszone.name AS presszone_name,
    et2.idval::character varying(16) AS presszone_type,
    presszone.head AS presszone_head,
    connec.dma_id,
    dma.name AS dma_name,
    et3.idval::character varying(16) AS dma_type,
    dma.macrodma_id,
    connec.dqa_id,
    dqa.name AS dqa_name,
    et4.idval::character varying(16) AS dqa_type,
    dqa.macrodqa_id,
    connec.crmzone_id,
    crm_zone.name AS crmzone_name,
    connec.customer_code,
    connec.connec_length,
    connec.n_hydrometer,
    connec.arc_id,
    connec.annotation,
    connec.observ,
    connec.comment,
    connec.staticpressure,
    connec.soilcat_id,
    connec.function_type,
    connec.category_type,
    connec.fluid_type,
    connec.location_type,
    connec.workcat_id,
    connec.workcat_id_end,
    connec.workcat_id_plan,
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
    b.descript::character varying(100) AS streetname2,
    connec.postnumber2,
    connec.postcomplement2,
    mu.region_id,
    mu.province_id,
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
    connec.label_quadrant,
    connec.publish,
    connec.inventory,
    connec.num_value,
    connec.pjoint_id,
    connec.pjoint_type,
    connec.adate,
    connec.adescript,
    connec.accessibility,
    dma.stylesheet ->> 'featureColor'::text AS dma_style,
    presszone.stylesheet ->> 'featureColor'::text AS presszone_style,
    connec.asset_id,
    connec.om_state,
    connec.conserv_state,
    connec.priority,
    connec.valve_location,
    connec.valve_type,
    connec.shutoff_valve,
    connec.access_type,
    connec.placement_type,
    connec.expl_id2,
    vst.is_operative,
    connec.plot_code,
        CASE
            WHEN connec.brand_id IS NULL THEN cat_connec.brand_id
            ELSE connec.brand_id
        END AS brand_id,
        CASE
            WHEN connec.model_id IS NULL THEN cat_connec.model_id
            ELSE connec.model_id
        END AS model_id,
    connec.serial_number,
    connec.cat_valve,
    connec.minsector_id,
    connec.macrominsector_id,
    e.demand,
    e.press_max,
    e.press_min,
    e.press_avg,
    e.quality_max,
    e.quality_min,
    e.quality_avg,
    date_trunc('second'::text, connec.tstamp) AS tstamp,
    connec.insert_user,
    date_trunc('second'::text, connec.lastupdate) AS lastupdate,
    connec.lastupdate_user,
    connec.the_geom,
        CASE
            WHEN connec.sector_id > 0 AND vst.is_operative = true AND connec.epa_type = 'JUNCTION'::character varying(16)::text AND cpu.value = '4' THEN connec.epa_type::character varying
            ELSE NULL::character varying(16)
        END AS inp_type
   FROM (SELECT value FROM config_param_user WHERE parameter = 'inp_options_networkmode' and cur_user = current_user) cpu, connec
     JOIN cat_connec ON connec.connecat_id::text = cat_connec.id::text
     JOIN cat_feature ON cat_feature.id::text = cat_connec.connectype_id::text
     LEFT JOIN dma ON connec.dma_id = dma.dma_id
     LEFT JOIN sector ON connec.sector_id = sector.sector_id
     LEFT JOIN exploitation ON connec.expl_id = exploitation.expl_id
     LEFT JOIN dqa ON connec.dqa_id = dqa.dqa_id
     LEFT JOIN presszone ON presszone.presszone_id::text = connec.presszone_id::text
     LEFT JOIN crm_zone ON crm_zone.id::text = connec.crmzone_id::text
     LEFT JOIN streetaxis c ON c.id::text = connec.streetaxis_id::text
     LEFT JOIN streetaxis b ON b.id::text = connec.streetaxis2_id::text
     LEFT JOIN connec_add e ON e.connec_id::text = connec.connec_id::text
     LEFT JOIN value_state_type vst ON vst.id = connec.state_type
     LEFT JOIN ext_municipality mu ON connec.muni_id = mu.muni_id
     LEFT JOIN typevalue et1 ON et1.id::text = sector.sector_type::text AND et1.typevalue::text = 'sector_type'::text
     LEFT JOIN typevalue et2 ON et2.id::text = presszone.presszone_type AND et2.typevalue::text = 'presszone_type'::text
     LEFT JOIN typevalue et3 ON et3.id::text = dma.dma_type::text AND et3.typevalue::text = 'dma_type'::text
     LEFT JOIN typevalue et4 ON et4.id::text = dqa.dqa_type::text AND et4.typevalue::text = 'dqa_type'::text;


CREATE OR REPLACE VIEW vu_link AS 
 WITH typevalue AS (
         SELECT edit_typevalue.typevalue,
            edit_typevalue.id,
            edit_typevalue.idval
           FROM edit_typevalue
          WHERE edit_typevalue.typevalue::text = ANY (ARRAY['sector_type'::character varying, 'presszone_type'::character varying, 'dma_type'::character varying, 'dqa_type'::character varying]::text[])
        )
 SELECT l.link_id,
    l.feature_type,
    l.feature_id,
    l.exit_type,
    l.exit_id,
    l.state,
    l.expl_id,
    l.sector_id,
    s.name AS sector_name,
    et1.idval::character varying(16) AS sector_type,
    s.macrosector_id,
    presszone_id::character varying(16) AS presszone_id,
    p.name AS presszone_name,
    et2.idval::character varying(16) AS presszone_type,
    p.head AS presszone_head,
    l.dma_id,
    d.name AS dma_name,
    et3.idval::character varying(16) AS dma_type,
    d.macrodma_id,
    l.dqa_id,
    q.name AS dqa_name,
    et4.idval::character varying(16) AS dqa_type,
    q.macrodqa_id,
    l.exit_topelev,
    l.exit_elev,
    l.fluid_type,
    st_length2d(l.the_geom)::numeric(12,3) AS gis_length,
    l.the_geom,
    l.muni_id,
    l.expl_id2,
    l.epa_type,
    l.is_operative,
    l.staticpressure,
    l.connecat_id,
    l.workcat_id,
    l.workcat_id_end,
    l.builtdate,
    l.enddate,
    date_trunc('second'::text, l.lastupdate) AS lastupdate,
    l.lastupdate_user,
    l.uncertain,
    l.minsector_id,
    l.macrominsector_id,
    CASE
            WHEN sector_id > 0 AND is_operative = true AND epa_type = 'JUNCTION'::character varying(16)::text AND cpu.value = '4' THEN epa_type::character varying
            ELSE NULL::character varying(16)
        END AS inp_type
     FROM (SELECT value FROM config_param_user WHERE parameter = 'inp_options_networkmode' and cur_user = current_user) cpu, link l
     LEFT JOIN sector s USING (sector_id)
     LEFT JOIN presszone p USING (presszone_id)
     LEFT JOIN dma d USING (dma_id)
     LEFT JOIN dqa q USING (dqa_id)
     LEFT JOIN typevalue et1 ON et1.id::text = s.sector_type::text AND et1.typevalue::text = 'sector_type'::text
     LEFT JOIN typevalue et2 ON et2.id::text = p.presszone_type AND et2.typevalue::text = 'presszone_type'::text
     LEFT JOIN typevalue et3 ON et3.id::text = d.dma_type::text AND et3.typevalue::text = 'dma_type'::text
     LEFT JOIN typevalue et4 ON et4.id::text = q.dqa_type::text AND et4.typevalue::text = 'dqa_type'::text;



CREATE OR REPLACE VIEW v_edit_link AS 
	SELECT l.* FROM (
	SELECT *
	FROM vu_link
	JOIN v_state_link USING (link_id)) l
	join selector_sector s using (sector_id)
	LEFT JOIN selector_municipality m using (muni_id)
	where s.cur_user = current_user and (m.cur_user = current_user or l.muni_id is null);
	
	
DROP view v_edit_inp_pipe ;
CREATE OR REPLACE VIEW v_edit_inp_pipe AS 
 SELECT a.arc_id,
    a.node_1,
    a.node_2,
    a.arccat_id,
    a.expl_id,
    a.sector_id,
    a.dma_id,
    a.state,
    a.state_type,
    a.custom_length,
    a.annotation,
    inp_pipe.minorloss,
    inp_pipe.status,
    a.cat_matcat_id,
    inp_pipe.custom_roughness,
    a.cat_dint,
    inp_pipe.custom_dint,
    inp_pipe.bulk_coeff,
    inp_pipe.wall_coeff,
    a.the_geom
   FROM v_edit_arc a
     JOIN inp_pipe USING (arc_id)
  WHERE a.is_operative IS TRUE;


CREATE OR REPLACE VIEW v_edit_minsector AS 
 SELECT m.minsector_id,
    m.code,
    m.dma_id,
    m.dqa_id,
    m.presszone_id,
    m.expl_id,
    m.num_border,
    m.num_connec,
    m.num_hydro,
    m.length,
    m.descript,
    m.addparam::text AS addparam,
    m.the_geom
   FROM selector_expl, minsector m
  WHERE (m.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text);
  