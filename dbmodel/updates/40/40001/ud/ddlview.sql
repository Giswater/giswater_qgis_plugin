/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;

DROP VIEW IF EXISTS v_edit_cat_feature_flwreg;

DROP VIEW IF EXISTS v_edit_inp_dscenario_frorifice;
DROP VIEW IF EXISTS v_edit_inp_dscenario_froutlet;
DROP VIEW IF EXISTS v_edit_inp_dscenario_frweir;

DROP VIEW IF EXISTS v_edit_inp_frorifice;
DROP VIEW IF EXISTS v_edit_inp_froutlet;
DROP VIEW IF EXISTS v_edit_inp_frweir;


DROP VIEW IF EXISTS v_edit_drainzone;
DROP VIEW IF EXISTS v_rpt_comp_nodedepth_sum;
DROP VIEW IF EXISTS v_rpt_comp_nodeinflow_sum;
DROP VIEW IF EXISTS v_rpt_comp_nodeflooding_sum;

DROP VIEW IF EXISTS v_rpt_comp_nodesurcharge_sum;
DROP VIEW IF EXISTS v_rpt_comp_arcflow_sum;
DROP VIEW IF EXISTS v_rpt_comp_condsurcharge_sum;

DROP VIEW IF EXISTS v_rpt_comp_pumping_sum;
DROP VIEW IF EXISTS v_rpt_comp_flowclass_sum;
DROP VIEW IF EXISTS v_edit_macrosector;

DROP VIEW IF EXISTS v_edit_review_node;
DROP VIEW IF EXISTS v_expl_connec;
DROP VIEW IF EXISTS v_rtc_hydrometer;

DROP VIEW IF EXISTS v_ui_hydroval;
DROP VIEW IF EXISTS v_ui_hydrometer;
DROP VIEW IF EXISTS v_ui_hydroval_x_connec;

DROP VIEW IF EXISTS v_ui_om_visitman_x_connec;
DROP VIEW IF EXISTS v_ui_om_visit_x_connec;

DROP VIEW IF EXISTS v_ui_event_x_connec;

DROP VIEW IF EXISTS ve_elem_cover;
DROP VIEW IF EXISTS ve_elem_frpump;
DROP VIEW IF EXISTS ve_elem_gate;
DROP VIEW IF EXISTS ve_elem_iot_sensor;
DROP VIEW IF EXISTS ve_elem_protector;
DROP VIEW IF EXISTS ve_elem_pump;
DROP VIEW IF EXISTS ve_elem_step;
DROP VIEW IF EXISTS v_edit_element;

-- ====

CREATE OR REPLACE VIEW v_edit_exploitation
AS SELECT exploitation.expl_id,
    exploitation.code,
    exploitation.name,
    exploitation.macroexpl_id,
    exploitation.owner_vdefault,
    exploitation.descript,
    exploitation.lock_level,
    exploitation.active,
    exploitation.the_geom,
    exploitation.created_at,
    exploitation.created_by,
    exploitation.updated_at,
    exploitation.updated_by
   FROM selector_expl,
    exploitation
  WHERE exploitation.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text;

CREATE OR REPLACE VIEW v_edit_macroomzone AS
 SELECT macroomzone.macroomzone_id,
    macroomzone.code,
    macroomzone.name,
    macroomzone.descript,
    macroomzone.the_geom,
    macroomzone.expl_id,
    macroomzone.lock_level,
    macroomzone.created_at,
    macroomzone.created_by,
    macroomzone.updated_at,
    macroomzone.updated_by
   FROM selector_expl, macroomzone
  WHERE macroomzone.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW v_edit_omzone
AS SELECT o.omzone_id,
    o.code,
    o.name,
    o.macroomzone_id,
    o.omzone_type,
    o.expl_id,
    e.name as expl_name,
    o.descript,
    o.link,
    o.graphconfig,
    o.stylesheet,
    o.the_geom,
    o.lock_level
FROM omzone o, selector_expl
LEFT JOIN exploitation e USING (expl_id)
WHERE ((o.expl_id = selector_expl.expl_id) AND selector_expl.cur_user = "current_user"()::text) OR o.expl_id is null
order by 1 asc;

CREATE OR REPLACE VIEW v_edit_sector
AS SELECT s.sector_id,
    s.code,
    s.name,
    s.sector_type,
    s.macrosector_id,
    s.descript,
    s.graphconfig::text,
    s.stylesheet,
    s.parent_id,
    s.link,
    s.lock_level,
    s.the_geom,
    s.created_at,
    s.created_by,
    s.updated_at,
    s.updated_by
   FROM selector_sector,
    sector s
  WHERE s.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text;

CREATE OR REPLACE VIEW v_ui_sector
AS SELECT s.sector_id,
    s.code,
    s.name,
    s.sector_type,
    ms.name AS macrosector,
    s.descript,
    s.lock_level,
    s.graphconfig,
    s.stylesheet,
    s.link,
    s.active,
    s.parent_id,
    s.created_at,
    s.created_by,
    s.updated_at,
    s.updated_by
    FROM selector_sector ss,
    sector s
     LEFT JOIN macrosector ms ON ms.macrosector_id = s.macrosector_id
  WHERE s.sector_id > 0 AND ss.sector_id = s.sector_id AND ss.cur_user = CURRENT_USER
  ORDER BY s.sector_id;



-- recreate v_edit_samplepoint, v_ext_streetaxis, v_ext_municipality views
-----------------------------------

CREATE OR REPLACE VIEW v_edit_samplepoint AS
SELECT sm.* FROM (
SELECT
    samplepoint.sample_id,
    samplepoint.code,
    samplepoint.lab_code,
    samplepoint.feature_id,
    samplepoint.featurecat_id,
    samplepoint.expl_id,
    samplepoint.muni_id,
    samplepoint.sector_id,
    samplepoint.omzone_id,
    omzone.macroomzone_id,
    samplepoint.state,
    samplepoint.builtdate,
    samplepoint.enddate,
    samplepoint.workcat_id,
    samplepoint.workcat_id_end,
    samplepoint.rotation,
    samplepoint.postcode,
    samplepoint.district_id,
    samplepoint.streetaxis_id,
    samplepoint.postnumber,
    samplepoint.postcomplement,
    samplepoint.streetaxis2_id,
    samplepoint.postnumber2,
    samplepoint.postcomplement2,
    samplepoint.place_name,
    samplepoint.cabinet,
    samplepoint.observations,
    samplepoint.verified,
    samplepoint.link,
    samplepoint.the_geom
    FROM selector_expl, samplepoint
    --JOIN v_state_samplepoint ON samplepoint.sample_id::text = v_state_samplepoint.sample_id::text
    LEFT JOIN omzone ON omzone.omzone_id = samplepoint.omzone_id
	WHERE samplepoint.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text) sm
	join selector_sector s using (sector_id)
    LEFT JOIN selector_municipality m using (muni_id)
    where s.cur_user = current_user
    and (m.cur_user = current_user or sm.muni_id is null);


CREATE OR REPLACE VIEW v_ext_streetaxis
AS SELECT ext_streetaxis.id,
    ext_streetaxis.code,
    ext_streetaxis.type,
    ext_streetaxis.name,
    ext_streetaxis.text,
    ext_streetaxis.the_geom,
    ext_streetaxis.expl_id,
    ext_streetaxis.muni_id,
        CASE
            WHEN ext_streetaxis.type IS NULL THEN ext_streetaxis.name::text
            WHEN ext_streetaxis.text IS NULL THEN ((ext_streetaxis.name::text || ', '::text) || ext_streetaxis.type::text) || '.'::text
            WHEN ext_streetaxis.type IS NULL AND ext_streetaxis.text IS NULL THEN ext_streetaxis.name::text
            ELSE (((ext_streetaxis.name::text || ', '::text) || ext_streetaxis.type::text) || '. '::text) || ext_streetaxis.text
        END AS descript,
    ext_streetaxis.source
   FROM selector_municipality s, ext_streetaxis
   WHERE ext_streetaxis.muni_id = s.muni_id AND s.cur_user = "current_user"()::text;

CREATE OR REPLACE VIEW v_ext_municipality
AS SELECT DISTINCT s.muni_id,
    m.name,
    m.active,
    m.the_geom
    FROM ext_municipality m, selector_municipality s
	WHERE m.muni_id = s.muni_id AND s.cur_user = "current_user"()::text;

CREATE OR REPLACE VIEW v_edit_link
AS WITH
	typevalue AS
       (
			SELECT edit_typevalue.typevalue, edit_typevalue.id, edit_typevalue.idval
			FROM edit_typevalue
			WHERE edit_typevalue.typevalue::text = ANY (ARRAY['sector_type'::character varying::text, 'drainzone_type'::character varying::text, 'omzone_type'::character varying::text, 'dwfzone_type'::character varying::text])
        ),
    sector_table AS
		(
			SELECT sector_id, macrosector_id, stylesheet, id::varchar(16) AS sector_type
			FROM sector
			LEFT JOIN typevalue t ON t.id::text = sector.sector_type AND t.typevalue::text = 'sector_type'::text
		),
	omzone_table AS
		(
			SELECT omzone_id, macroomzone_id, stylesheet, id::varchar(16) AS omzone_type
			FROM omzone
			LEFT JOIN typevalue t ON t.id::text = omzone.omzone_type AND t.typevalue::text = 'omzone_type'::text
		),
	drainzone_table AS
		(
			SELECT drainzone_id, stylesheet, id::varchar(16) AS drainzone_type
			FROM drainzone
			LEFT JOIN typevalue t ON t.id::text = drainzone.drainzone_type AND t.typevalue::text = 'drainzone_type'::text
		),
	dwfzone_table AS
		(
			SELECT dwfzone_id, stylesheet, id::varchar(16) AS dwfzone_type
			FROM dwfzone
			LEFT JOIN typevalue t ON t.id::text = dwfzone.dwfzone_type AND t.typevalue::text = 'dwfzone_type'::text
		),
	inp_network_mode AS
    	(
			SELECT value FROM config_param_user WHERE parameter::text = 'inp_options_networkmode'::text AND config_param_user.cur_user::text = CURRENT_USER
        ),
	link_psector AS
        (
			(
				SELECT DISTINCT ON (pp.connec_id, pp.state) 'CONNEC' AS feature_type, pp.connec_id AS feature_id, pp.state AS p_state, pp.psector_id, pp.link_id
				FROM plan_psector_x_connec pp
				JOIN selector_psector sp ON sp.cur_user = current_user AND sp.psector_id = pp.psector_id
				ORDER BY pp.connec_id, pp.state, pp.link_id DESC NULLS LAST
			)
			UNION ALL
			(
				SELECT DISTINCT ON (pp.gully_id, pp.state) 'GULLY' AS feature_type, pp.gully_id AS feature_id, pp.state AS p_state, pp.psector_id, pp.link_id
				FROM plan_psector_x_gully pp
				JOIN selector_psector sp ON sp.cur_user = current_user AND sp.psector_id = pp.psector_id
				ORDER BY pp.gully_id, pp.state, pp.link_id DESC NULLS LAST
			)
        ),
    link_selector AS
        (
            SELECT l.link_id
            FROM link l
            JOIN selector_state s ON s.cur_user = CURRENT_USER AND l.state = s.state_id
            LEFT JOIN (
            SELECT link_id FROM link_psector WHERE p_state = 0
            ) a ON a.link_id = l.link_id
            WHERE a.link_id IS NULL
            AND EXISTS (
                SELECT 1 FROM selector_expl se
                WHERE s.cur_user = current_user
                AND se.expl_id = ANY (array_append(l.expl_visibility, l.expl_id))
            )
            AND EXISTS (
                SELECT 1 FROM selector_sector sc
                WHERE sc.cur_user = current_user
                AND sc.sector_id = l.sector_id
            )
            AND EXISTS (
                SELECT 1 FROM selector_municipality sm
                WHERE sm.cur_user = current_user
                AND sm.muni_id = l.muni_id
            )
            UNION ALL
            SELECT link_id FROM link_psector
            WHERE p_state = 1
        ),
    link_selected as
    	(
			SELECT DISTINCT ON (l.link_id) l.link_id,
            l.code,
            l.sys_code,
            l.top_elev1,
            l.y1,
            CASE
                WHEN l.top_elev1 IS NULL OR l.y1 IS NULL THEN NULL
                ELSE (l.top_elev1 - l.y1)
            END AS elevation1,
			l.exit_id,
			l.exit_type,
            l.top_elev2,
            l.y2,
            CASE
                WHEN l.top_elev2 IS NULL OR l.y2 IS NULL THEN NULL
                ELSE (l.top_elev2 - l.y2)
            END AS elevation2,
			l.feature_type,
			l.feature_id,
            l.link_type,
            cat_feature.feature_class AS sys_type,
			l.linkcat_id,
			l.epa_type,
			l.state,
			l.expl_id,
			macroexpl_id,
			l.sector_id,
			macrosector_id,
			sector_table.sector_type,
			l.muni_id,
			l.drainzone_id,
			drainzone_table.drainzone_type,
			l.dwfzone_id,
			dwfzone_table.dwfzone_type,
			l.omzone_id,
			omzone_table.macroomzone_id,
			l.fluid_type,
			l.workcat_id,
			l.workcat_id_end,
			l.builtdate,
			l.enddate,
            l.verified,
			l.uncertain,
            l.datasource,
			l.is_operative,
			sector_table.stylesheet ->> 'featureColor'::text AS sector_style,
			omzone_table.stylesheet ->> 'featureColor'::text AS omzone_style,
			drainzone_table.stylesheet ->> 'featureColor'::text AS drainzone_style,
			dwfzone_table.stylesheet ->> 'featureColor'::text AS dwfzone_style,
            l.lock_level,
			l.expl_visibility,
            l.created_at,
            l.created_by,
            date_trunc('second'::text, l.updated_at) AS updated_at,
            l.updated_by,
			l.the_geom,
			st_length2d(l.the_geom)::numeric(12,3) AS gis_length,
            l.custom_length
			FROM inp_network_mode, link_selector
			JOIN link l using (link_id)
			JOIN exploitation ON l.expl_id = exploitation.expl_id
			JOIN ext_municipality mu ON l.muni_id = mu.muni_id
			JOIN sector_table ON l.sector_id = sector_table.sector_id
            JOIN cat_link ON cat_link.id::text = l.linkcat_id::text
            JOIN cat_feature ON cat_feature.id::text = l.link_type::text
			LEFT JOIN omzone_table ON l.omzone_id = omzone_table.omzone_id
			LEFT join drainzone_table ON l.omzone_id = drainzone_table.drainzone_id
			LEFT JOIN dwfzone_table ON l.dwfzone_id = dwfzone_table.dwfzone_id
		)
     SELECT link_selected.*
	 FROM link_selected;



CREATE OR REPLACE VIEW v_edit_link_connec
as select * from v_edit_link where feature_type = 'CONNEC';

CREATE OR REPLACE VIEW v_edit_link_gully
as select * from v_edit_link where feature_type = 'GULLY';


CREATE OR REPLACE VIEW v_edit_drainzone
AS SELECT d.drainzone_id,
    d.code,
    d.name,
    et.idval as drainzone_type,
    d.descript,
    d.graphconfig::text AS graphconfig,
    d.stylesheet::text AS stylesheet,
    d.link,
    d.expl_id,
    d.lock_level,
    d.the_geom,
    d.created_at,
    d.created_by,
    d.updated_at,
    d.updated_by
   FROM selector_expl,
    drainzone d
    LEFT JOIN edit_typevalue et ON et.id::text = d.drainzone_type::text AND et.typevalue::text = 'drainzone_type'::text
  WHERE d.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text;

CREATE OR REPLACE VIEW v_edit_dwfzone
AS SELECT d.dwfzone_id,
    d.code,
    d.name,
    et.idval as dwfzone_type,
    d.descript,
    d.graphconfig::text AS graphconfig,
    d.stylesheet::text AS stylesheet,
    d.link,
    d.expl_id,
    d.lock_level,
    d.the_geom,
    d.created_at,
    d.created_by,
    d.updated_at,
    d.updated_by
   FROM selector_expl e,
    dwfzone d
    LEFT JOIN edit_typevalue et ON et.id::text = d.dwfzone_type::text AND et.typevalue::text = 'dwfzone_type'::text
  WHERE d.expl_id = e.expl_id AND e.cur_user = "current_user"()::text;


-- recreate all deleted views: arc, node, connec, gully and dependencies
-----------------------------------



CREATE OR REPLACE VIEW v_edit_arc
AS WITH
	typevalue AS
       (
			SELECT edit_typevalue.typevalue, edit_typevalue.id, edit_typevalue.idval
			FROM edit_typevalue
			WHERE edit_typevalue.typevalue::text = ANY (ARRAY['sector_type'::character varying::text, 'drainzone_type'::character varying::text, 'omzone_type'::character varying::text, 'dwfzone_type'::character varying::text])
        ),
    sector_table AS
		(
			SELECT sector_id, macrosector_id, stylesheet, id::varchar(16) AS sector_type
			FROM sector
			LEFT JOIN typevalue t ON t.id::text = sector.sector_type AND t.typevalue::text = 'sector_type'::text
		),
	omzone_table AS
		(
			SELECT omzone_id, macroomzone_id, stylesheet, id::varchar(16) AS omzone_type
			FROM omzone
			LEFT JOIN typevalue t ON t.id::text = omzone.omzone_type AND t.typevalue::text = 'omzone_type'::text
		),
	drainzone_table AS
		(
			SELECT drainzone_id, stylesheet, id::varchar(16) AS drainzone_type
			FROM drainzone
			LEFT JOIN typevalue t ON t.id::text = drainzone.drainzone_type AND t.typevalue::text = 'drainzone_type'::text
		),
	dwfzone_table AS
		(
			SELECT dwfzone_id, stylesheet, id::varchar(16) AS dwfzone_type
			FROM dwfzone
			LEFT JOIN typevalue t ON t.id::text = dwfzone.dwfzone_type AND t.typevalue::text = 'dwfzone_type'::text
		),
	arc_psector AS
		(
			SELECT pp.arc_id,  pp.state AS p_state
			FROM plan_psector_x_arc pp
			JOIN selector_psector sp ON sp.cur_user = CURRENT_USER AND sp.psector_id = pp.psector_id
        ),
  arc_selector AS
		(
	        SELECT arc.arc_id
            FROM arc
            JOIN selector_state s ON s.cur_user = CURRENT_USER AND arc.state = s.state_id
            LEFT JOIN (
                SELECT arc_id FROM arc_psector WHERE p_state = 0
            ) a USING (arc_id)
            WHERE a.arc_id IS NULL
            AND EXISTS (
                SELECT 1 FROM selector_expl se
                WHERE s.cur_user = current_user
                AND se.expl_id = ANY (array_append(arc.expl_visibility, arc.expl_id))
            )
            AND EXISTS (
                SELECT 1 FROM selector_sector sc
                WHERE sc.cur_user = current_user
                AND sc.sector_id = arc.sector_id
            )
            AND EXISTS (
                SELECT 1 FROM selector_municipality sm
                WHERE sm.cur_user = current_user
                AND sm.muni_id = arc.muni_id
            )
            UNION ALL
            SELECT arc_id FROM arc_psector
            WHERE p_state = 1
        ),
    arc_selected AS
		(
		    SELECT arc.arc_id,
			arc.code,
            arc.sys_code,
			arc.node_1,
			arc.nodetype_1,
			arc.elev1,
			arc.custom_elev1,
	        CASE
	            WHEN arc.sys_elev1 IS NULL THEN arc.node_sys_elev_1
	            ELSE arc.sys_elev1
	        END AS sys_elev1,
			arc.y1,
			arc.custom_y1,
	        CASE
	            WHEN
	            CASE
	                WHEN arc.custom_y1 IS NULL THEN arc.y1
	                ELSE arc.custom_y1
	            END IS NULL THEN arc.node_sys_top_elev_1 - arc.sys_elev1
	            ELSE
	            CASE
	                WHEN arc.custom_y1 IS NULL THEN arc.y1
	                ELSE arc.custom_y1
	            END
	        END AS sys_y1,
			arc.node_sys_top_elev_1 -
	        CASE
	            WHEN arc.sys_elev1 IS NULL THEN arc.node_sys_elev_1
	            ELSE arc.sys_elev1
	        END - cat_arc.geom1 AS r1,
	        CASE
	            WHEN arc.sys_elev1 IS NULL THEN arc.node_sys_elev_1
	            ELSE arc.sys_elev1
	        END - arc.node_sys_elev_1 AS z1,
			arc.node_2,
			arc.nodetype_2,
			arc.elev2,
			arc.custom_elev2,
	        CASE
	            WHEN arc.sys_elev2 IS NULL THEN arc.node_sys_elev_2
	            ELSE arc.sys_elev2
	        END AS sys_elev2,
			arc.y2,
			arc.custom_y2,
	        CASE
	            WHEN
	            CASE
	                WHEN arc.custom_y2 IS NULL THEN arc.y2
	                ELSE arc.custom_y2
	            END IS NULL THEN arc.node_sys_top_elev_2 - arc.sys_elev2
	            ELSE
	            CASE
	                WHEN arc.custom_y2 IS NULL THEN arc.y2
	                ELSE arc.custom_y2
	            END
	        END AS sys_y2,
			arc.node_sys_top_elev_2 -
			CASE
				WHEN arc.sys_elev2 IS NULL THEN arc.node_sys_elev_2
				ELSE arc.sys_elev2
			END - cat_arc.geom1 AS r2,
			CASE
				WHEN arc.sys_elev2 IS NULL THEN arc.node_sys_elev_2
				ELSE arc.sys_elev2
			END - arc.node_sys_elev_2 AS z2,
			cat_feature.feature_class AS sys_type,
			arc.arc_type::text,
			arc.arccat_id,
	        CASE
	            WHEN arc.matcat_id IS NULL THEN cat_arc.matcat_id
	            ELSE arc.matcat_id
	        END AS matcat_id,
			cat_arc.shape AS cat_shape,
			cat_arc.geom1 AS cat_geom1,
			cat_arc.geom2 AS cat_geom2,
			cat_arc.width AS cat_width,
			cat_arc.area AS cat_area,
			arc.custom_length,
			arc.epa_type,
			arc.state,
			arc.state_type,
			arc.parent_id,
			arc.expl_id,
			e.macroexpl_id,
			arc.sector_id,
			sector_table.macrosector_id,
			sector_table.sector_type,
			arc.muni_id,
			arc.drainzone_id,
			drainzone_table.drainzone_type,
			arc.dwfzone_id,
			dwfzone_table.dwfzone_type,
			arc.omzone_id,
			omzone_table.macroomzone_id,
			omzone_table.omzone_type,
			arc.minsector_id,
			arc.macrominsector_id,
			arc.pavcat_id,
			arc.soilcat_id,
			arc.function_type,
			arc.category_type,
			arc.location_type,
			arc.fluid_type,
			arc.annotation,
			arc.observ,
			arc.comment,
			arc.descript,
			concat(cat_feature.link_path, arc.link) AS link,
			arc.num_value,
			arc.district_id,
			arc.postcode,
			streetname_id,
			arc.postnumber,
			arc.postcomplement,
			streetname2_id,
			arc.postnumber2,
			arc.postcomplement2,
			mu.region_id,
			mu.province_id,
			arc.workcat_id,
			arc.workcat_id_end,
			arc.workcat_id_plan,
			arc.builtdate,
            arc.registration_date,
			arc.enddate,
			arc.ownercat_id,
            arc.last_visitdate,
			arc.visitability,
            arc.om_state,
            arc.conserv_state,
			arc.brand_id,
			arc.model_id,
			arc.serial_number,
			arc.asset_id,
			arc.adate,
			arc.adescript,
			arc.verified,
			arc.uncertain,
			cat_arc.label,
			arc.label_x,
			arc.label_y,
			arc.label_rotation,
			arc.label_quadrant,
			arc.inventory,
			arc.publish,
			vst.is_operative,
            arc.is_scadamap,
	        CASE
	            WHEN arc.sector_id > 0 AND vst.is_operative = true AND arc.epa_type::text <> 'UNDEFINED'::character varying(16)::text THEN arc.epa_type
	            ELSE NULL::character varying(16)
	        END AS inp_type,
			sector_table.stylesheet ->> 'featureColor'::text AS sector_style,
			drainzone_table.stylesheet ->> 'featureColor'::text AS drainzone_style,
			dwfzone_table.stylesheet ->> 'featureColor'::text AS dwfzone_style,
			omzone_table.stylesheet ->> 'featureColor'::text AS omzone_style,
            arc.lock_level,
            arc.initoverflowpath,
			arc.expl_visibility,
            date_trunc('second'::text, arc.created_at) AS created_at,
			arc.created_by,
			date_trunc('second'::text, arc.updated_at) AS updated_at,
			arc.updated_by,
			arc.the_geom,
            -- extra we don't know the order
			st_length(arc.the_geom)::numeric(12,2) AS gis_length,
			arc.inverted_slope,
            arc.hydraulic_capacity,
            arc.meandering,
            arc.negativeoffset,
			arc.sys_slope AS slope
			FROM arc_selector
			JOIN arc using (arc_id)
			JOIN cat_arc ON arc.arccat_id::text = cat_arc.id::text
			JOIN cat_feature ON arc.arc_type::text = cat_feature.id::text
			JOIN exploitation e on e.expl_id = arc.expl_id
			JOIN ext_municipality mu ON arc.muni_id = mu.muni_id
			JOIN value_state_type vst ON vst.id = arc.state_type
			JOIN sector_table on sector_table.sector_id = arc.sector_id
			LEFT JOIN omzone_table on omzone_table.omzone_id = arc.omzone_id
			LEFT JOIN drainzone_table ON arc.omzone_id = drainzone_table.drainzone_id
			LEFT JOIN dwfzone_table ON arc.dwfzone_id = dwfzone_table.dwfzone_id
            LEFT JOIN arc_add a ON a.arc_id::text = arc.arc_id::text
		)
	SELECT arc_selected.*
	FROM arc_selected;


CREATE OR REPLACE VIEW v_edit_node
AS WITH
	typevalue AS
       (
			SELECT edit_typevalue.typevalue, edit_typevalue.id, edit_typevalue.idval
			FROM edit_typevalue
			WHERE edit_typevalue.typevalue::text = ANY (ARRAY['sector_type'::character varying::text, 'drainzone_type'::character varying::text, 'omzone_type'::character varying::text, 'dwfzone_type'::character varying::text])
        ),
    sector_table AS
		(
			SELECT sector_id, macrosector_id, stylesheet, id::varchar(16) AS sector_type
			FROM sector
			LEFT JOIN typevalue t ON t.id::text = sector.sector_type AND t.typevalue::text = 'sector_type'::text
		),
	omzone_table AS
		(
			SELECT omzone_id, macroomzone_id, stylesheet, id::varchar(16) AS omzone_type
			FROM omzone
			LEFT JOIN typevalue t ON t.id::text = omzone.omzone_type AND t.typevalue::text = 'omzone_type'::text
		),
	drainzone_table AS
		(
			SELECT drainzone_id, stylesheet, id::varchar(16) AS drainzone_type
			FROM drainzone
			LEFT JOIN typevalue t ON t.id::text = drainzone.drainzone_type AND t.typevalue::text = 'drainzone_type'::text
		),
	dwfzone_table AS
		(
			SELECT dwfzone_id, stylesheet, id::varchar(16) AS dwfzone_type
			FROM dwfzone
			LEFT JOIN typevalue t ON t.id::text = dwfzone.dwfzone_type AND t.typevalue::text = 'dwfzone_type'::text
		),
	node_psector AS
        (
			SELECT pp.node_id, pp.state AS p_state
			FROM plan_psector_x_node pp
			JOIN selector_psector sp ON sp.cur_user = current_user AND sp.psector_id = pp.psector_id
        ),
    node_selector AS
        (
            SELECT node.node_id
            FROM node
            JOIN selector_state s ON s.cur_user = CURRENT_USER AND node.state = s.state_id
            LEFT JOIN (
            SELECT node_id FROM node_psector WHERE p_state = 0
            ) a USING (node_id)
            WHERE a.node_id IS NULL
            AND EXISTS (
                SELECT 1 FROM selector_expl se
                WHERE s.cur_user = current_user
                AND se.expl_id = ANY (array_append(node.expl_visibility, node.expl_id))
            )
            AND EXISTS (
                SELECT 1 FROM selector_sector sc
                WHERE sc.cur_user = current_user
                AND sc.sector_id = node.sector_id
            )
            AND EXISTS (
                SELECT 1 FROM selector_municipality sm
                WHERE sm.cur_user = current_user
                AND sm.muni_id = node.muni_id
            )
            UNION ALL
            SELECT node_id FROM node_psector
            WHERE p_state = 1
        ),
    node_selected AS
    	(
    		SELECT node.node_id,
			node.code,
            node.sys_code,
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
			cat_feature.feature_class AS sys_type,
			node.node_type::text,
			CASE
				WHEN node.matcat_id IS NULL THEN cat_node.matcat_id
				ELSE node.matcat_id
			END AS matcat_id,
			node.nodecat_id,
			node.epa_type,
			node.state,
			node.state_type,
			node.arc_id,
			node.parent_id,
			node.expl_id,
			exploitation.macroexpl_id,
			node.sector_id,
			sector_table.macrosector_id,
			sector_table.sector_type,
			node.muni_id,
			node.drainzone_id,
			drainzone_table.drainzone_type,
			node.dwfzone_id,
			dwfzone_table.dwfzone_type,
			node.omzone_id,
			omzone_table.macroomzone_id,
			node.minsector_id,
			node.macrominsector_id,
            node.pavcat_id,
			node.soilcat_id,
			node.function_type,
			node.category_type,
			node.location_type,
			node.fluid_type,
			node.annotation,
			node.observ,
			node.comment,
			node.descript,
			concat(cat_feature.link_path, node.link) AS link,
			node.num_value,
			node.district_id,
			node.postcode,
			streetname_id,
			node.postnumber,
			node.postcomplement,
			streetname2_id,
			node.postnumber2,
			node.postcomplement2,
			mu.region_id,
			mu.province_id,
			node.workcat_id,
			node.workcat_id_end,
			node.workcat_id_plan,
			node.builtdate,
			node.enddate,
			node.ownercat_id,
			node.access_type,
			node.placement_type,
			node.brand_id,
			node.model_id,
			node.serial_number,
			node.asset_id,
			node.adate,
			node.adescript,
			node.verified,
			node.xyz_date,
			node.uncertain,
			node.unconnected,
			cat_node.label,
			node.label_x,
			node.label_y,
			node.label_rotation,
			node.rotation,
			node.label_quadrant,
			cat_node.svg,
			node.inventory,
			node.publish,
			vst.is_operative,
            node.is_scadamap,
			CASE
			  WHEN node.sector_id > 0 AND vst.is_operative = true AND node.epa_type::text <> 'UNDEFINED'::character varying(16)::text THEN node.epa_type
			  ELSE NULL::character varying(16)
			END AS inp_type,
			sector_table.stylesheet ->> 'featureColor'::text AS sector_style,
			omzone_table.stylesheet ->> 'featureColor'::text AS omzone_style,
			drainzone_table.stylesheet ->> 'featureColor'::text AS drainzone_style,
			dwfzone_table.stylesheet ->> 'featureColor'::text AS dwfzone_style,
            node.lock_level,
			node.expl_visibility,
            (SELECT ST_X(node.the_geom)) AS xcoord,
            (SELECT ST_Y(node.the_geom)) AS ycoord,
            (SELECT ST_Y(ST_Transform(node.the_geom, 4326))) AS lat,
            (SELECT ST_X(ST_Transform(node.the_geom, 4326))) AS long,
            date_trunc('second'::text, node.created_at) AS created_at,
			node.created_by,
			date_trunc('second'::text, node.updated_at) AS updated_at,
			node.updated_by,
			node.the_geom,
            -- extra we don't know the order
            node.hemisphere
			FROM node_selector
			JOIN node USING (node_id)
			JOIN cat_node ON node.nodecat_id::text = cat_node.id::text
			JOIN cat_feature ON cat_feature.id::text = node.node_type::text
			JOIN exploitation ON node.expl_id = exploitation.expl_id
			JOIN ext_municipality mu ON node.muni_id = mu.muni_id
			JOIN value_state_type vst ON vst.id = node.state_type
			JOIN sector_table ON sector_table.sector_id = node.sector_id
			LEFT JOIN omzone_table ON omzone_table.omzone_id = node.omzone_id
			LEFT JOIN drainzone_table ON node.omzone_id = drainzone_table.drainzone_id
			LEFT JOIN dwfzone_table ON node.dwfzone_id = dwfzone_table.dwfzone_id
            LEFT JOIN node_add e ON e.node_id::text = node.node_id::text
    	),
    node_base AS
        (
			SELECT
			node_id,
			code,
            sys_code,
			top_elev,
			custom_top_elev,
			sys_top_elev,
			ymax,
			custom_ymax,
			CASE
				WHEN sys_ymax IS NOT NULL THEN sys_ymax
				ELSE (sys_top_elev - sys_elev)::numeric(12,3)
			END AS sys_ymax,
			elev,
			custom_elev,
			CASE
				WHEN elev IS NOT NULL AND custom_elev IS NULL THEN elev
				WHEN custom_elev IS NOT NULL THEN custom_elev
				ELSE (sys_top_elev - sys_ymax)::numeric(12,3)
			END AS sys_elev,
			node_type::text,
			sys_type,
			nodecat_id,
			matcat_id,
			epa_type,
			state,
			state_type,
			expl_id,
			macroexpl_id,
			sector_id,
			sector_type,
			macrosector_id,
			drainzone_id,
			drainzone_type,
			annotation,
			observ,
			comment,
			omzone_id,
			macroomzone_id,
			dwfzone_id,
			dwfzone_type,
			soilcat_id,
			function_type,
			category_type,
			fluid_type,
			location_type,
			sector_style,
			omzone_style,
			drainzone_style,
			dwfzone_style,
			workcat_id,
			workcat_id_end,
			builtdate,
			enddate,
			ownercat_id,
			muni_id,
			postcode,
			district_id,
			streetname_id,
			postnumber,
			postcomplement,
			streetname2_id,
			postnumber2,
			postcomplement2,
			region_id,
			province_id,
			descript,
			svg,
			rotation,
			link,
			verified,
			label,
			label_x,
			label_y,
			label_rotation,
			label_quadrant,
			publish,
			inventory,
			uncertain,
			xyz_date,
			unconnected,
			num_value,
			workcat_id_plan,
			asset_id,
			parent_id,
			arc_id,
			expl_visibility,
			is_operative,
			minsector_id,
			macrominsector_id,
			adate,
			adescript,
			placement_type,
			access_type,
			inp_type,
			brand_id,
			model_id,
			serial_number,
            pavcat_id,
            lock_level,
            is_scadamap,
            xcoord,
            ycoord,
            lat,
            long,
            hemisphere,
            created_at,
			created_by,
			updated_at,
			updated_by,
			the_geom
			FROM node_selected
		)
	SELECT node_base.*
	FROM node_base;


CREATE OR REPLACE VIEW v_edit_connec
AS WITH
	typevalue AS
       (
			SELECT edit_typevalue.typevalue, edit_typevalue.id, edit_typevalue.idval
			FROM edit_typevalue
			WHERE edit_typevalue.typevalue::text = ANY (ARRAY['sector_type'::character varying::text, 'drainzone_type'::character varying::text, 'omzone_type'::character varying::text, 'dwfzone_type'::character varying::text])
        ),
    sector_table AS
		(
			SELECT sector_id, macrosector_id, stylesheet, id::varchar(16) AS sector_type
			FROM sector
			LEFT JOIN typevalue t ON t.id::text = sector.sector_type AND t.typevalue::text = 'sector_type'::text
		),
	omzone_table AS
		(
			SELECT omzone_id, macroomzone_id, stylesheet, id::varchar(16) AS omzone_type
			FROM omzone
			LEFT JOIN typevalue t ON t.id::text = omzone.omzone_type AND t.typevalue::text = 'omzone_type'::text
		),
	drainzone_table AS
		(
			SELECT drainzone_id, stylesheet, id::varchar(16) AS drainzone_type
			FROM drainzone
			LEFT JOIN typevalue t ON t.id::text = drainzone.drainzone_type AND t.typevalue::text = 'drainzone_type'::text
		),
	dwfzone_table AS
		(
			SELECT dwfzone_id, stylesheet, id::varchar(16) AS dwfzone_type
			FROM dwfzone
			LEFT JOIN typevalue t ON t.id::text = dwfzone.dwfzone_type AND t.typevalue::text = 'dwfzone_type'::text
		),
	link_planned AS
    	(
			SELECT link_id, feature_id, feature_type, exit_id, exit_type, l.expl_id, macroexpl_id, l.sector_id, sector_type, macrosector_id, l.omzone_id, macroomzone_id, omzone_type,
			l.drainzone_id, drainzone_type, l.dwfzone_id, dwfzone_type,
		    fluid_type
			FROM link l
			JOIN exploitation USING (expl_id)
			JOIN sector_table ON l.sector_id = sector_table.sector_id
			LEFT JOIN omzone_table ON l.omzone_id = omzone_table.omzone_id
			LEFT JOIN drainzone_table ON l.omzone_id = drainzone_table.drainzone_id
			LEFT JOIN dwfzone_table ON l.dwfzone_id = dwfzone_table.dwfzone_id
			WHERE l.state = 2
    	),
    connec_psector AS
        (
			SELECT DISTINCT ON (pp.connec_id, pp.state) pp.connec_id, pp.state AS p_state, pp.psector_id, pp.arc_id, pp.link_id
			FROM plan_psector_x_connec pp
			JOIN selector_psector sp ON sp.cur_user = current_user AND sp.psector_id = pp.psector_id
			ORDER BY pp.connec_id, pp.state, pp.link_id DESC NULLS LAST
        ),
    connec_selector AS
        (
            SELECT connec.connec_id, arc_id::varchar(16), null::integer as link_id
            FROM connec
            JOIN selector_state s ON s.cur_user = CURRENT_USER AND connec.state = s.state_id
            LEFT JOIN (
            SELECT connec_id FROM connec_psector WHERE p_state = 0
            ) a USING (connec_id)
            WHERE a.connec_id IS NULL
            AND EXISTS (
                SELECT 1 FROM selector_expl se
                WHERE s.cur_user = current_user
                AND se.expl_id = ANY (array_append(connec.expl_visibility, connec.expl_id))
            )
            AND EXISTS (
                SELECT 1 FROM selector_sector sc
                WHERE sc.cur_user = current_user
                AND sc.sector_id = connec.sector_id
            )
            AND EXISTS (
                SELECT 1 FROM selector_municipality sm
                WHERE sm.cur_user = current_user
                AND sm.muni_id = connec.muni_id
            )
            UNION ALL
            SELECT connec_id, connec_psector.arc_id::varchar(16), link_id FROM connec_psector
            WHERE p_state = 1
        ),
    connec_selected AS
    	(
			SELECT connec.connec_id,
			connec.code,
            connec.sys_code,
			connec.top_elev,
			connec.y1,
			connec.y2,
			cat_feature.feature_class as sys_type,
			connec.connec_type::text,
			connec.matcat_id,
			connec.conneccat_id,
			connec.customer_code,
			connec.connec_depth,
			connec.connec_length,
			connec.state,
			connec.state_type,
			connec_selector.arc_id,
			connec.expl_id,
			exploitation.macroexpl_id,
			CASE
				WHEN link_planned.sector_id IS NULL THEN connec.sector_id
				ELSE link_planned.sector_id
			END AS sector_id,
			CASE
				WHEN link_planned.macrosector_id IS NULL THEN sector_table.macrosector_id
				ELSE link_planned.macrosector_id
			END AS macrosector_id,
			sector_table.sector_type,
			connec.muni_id,
			CASE
				WHEN link_planned.drainzone_id IS NULL THEN connec.drainzone_id
				ELSE link_planned.drainzone_id
			END AS drainzone_id,
			CASE
				WHEN link_planned.drainzone_type IS NULL THEN drainzone_table.drainzone_type
				ELSE link_planned.drainzone_type
			END AS drainzone_type,
            CASE
				WHEN link_planned.dwfzone_id IS NULL THEN connec.dwfzone_id
				ELSE link_planned.dwfzone_id
			END AS dwfzone_id,
			CASE
				WHEN link_planned.dwfzone_type IS NULL THEN dwfzone_table.dwfzone_type
				ELSE link_planned.dwfzone_type
			END AS dwfzone_type,
			CASE
				WHEN link_planned.omzone_id IS NULL THEN connec.omzone_id
				ELSE link_planned.omzone_id
			END AS omzone_id,
			CASE
				WHEN link_planned.macroomzone_id IS NULL THEN omzone_table.macroomzone_id
				ELSE link_planned.macroomzone_id
			END AS macroomzone_id,
			CASE
				WHEN link_planned.omzone_type IS NULL THEN omzone_table.omzone_type
				ELSE link_planned.omzone_type
			END AS omzone_type,
			connec.minsector_id,
			connec.macrominsector_id,
			connec.soilcat_id,
			connec.function_type,
			connec.category_type,
			connec.location_type,
			connec.fluid_type,
			connec.annotation,
			connec.observ,
			connec.comment,
			connec.descript,
			connec.link::text,
			connec.num_value,
			connec.district_id,
			connec.postcode,
			connec.streetname_id,
			connec.postnumber,
			connec.postcomplement,
			connec.streetname2_id,
			connec.postnumber2,
			connec.postcomplement2,
			mu.region_id,
			mu.province_id,
			connec.workcat_id,
			connec.workcat_id_end,
			connec.workcat_id_plan,
			connec.builtdate,
			connec.enddate,
			connec.ownercat_id,
			connec.access_type,
			connec.placement_type,
			connec.asset_id,
			connec.adate,
			connec.adescript,
			connec.verified,
			connec.uncertain,
			cat_connec.label,
			connec.label_x,
			connec.label_y,
			connec.label_rotation,
			connec.rotation,
			connec.label_quadrant,
			cat_connec.svg,
			connec.inventory,
			connec.publish,
			vst.is_operative,
			sector_table.stylesheet ->> 'featureColor'::text AS sector_style,
			drainzone_table.stylesheet ->> 'featureColor'::text AS drainzone_style,
			dwfzone_table.stylesheet ->> 'featureColor'::text AS dwfzone_style,
			omzone_table.stylesheet ->> 'featureColor'::text AS omzone_style,
			connec.lock_level,
			connec.expl_visibility,
            (SELECT ST_X(connec.the_geom)) AS xcoord,
            (SELECT ST_Y(connec.the_geom)) AS ycoord,
            (SELECT ST_Y(ST_Transform(connec.the_geom, 4326))) AS lat,
            (SELECT ST_X(ST_Transform(connec.the_geom, 4326))) AS long,
            date_trunc('second'::text, connec.created_at) AS created_at,
			connec.created_by,
			date_trunc('second'::text, connec.updated_at) AS updated_at,
			connec.updated_by,
			connec.the_geom,
            -- extra we don't know the order
			connec.demand,
			connec.accessibility,
			connec.diagonal,
			CASE
				WHEN link_planned.exit_id IS NULL THEN connec.pjoint_id
				ELSE link_planned.exit_id
			END AS pjoint_id,
			CASE
				WHEN link_planned.exit_type IS NULL THEN connec.pjoint_type
				ELSE link_planned.exit_type
			END AS pjoint_type,
			connec.plot_code
			FROM connec_selector
			JOIN connec USING (connec_id)
			JOIN cat_connec ON cat_connec.id::text = connec.conneccat_id::text
			JOIN cat_feature ON cat_feature.id::text = connec.connec_type::text::text
			JOIN exploitation ON connec.expl_id = exploitation.expl_id
			JOIN ext_municipality mu ON connec.muni_id = mu.muni_id
			JOIN value_state_type vst ON vst.id = connec.state_type
			JOIN sector_table ON sector_table.sector_id = connec.sector_id
			LEFT JOIN omzone_table ON omzone_table.omzone_id = connec.omzone_id
			LEFT JOIN drainzone_table ON connec.omzone_id = drainzone_table.drainzone_id
			LEFT JOIN dwfzone_table ON connec.dwfzone_id = dwfzone_table.dwfzone_id
			LEFT JOIN link_planned USING (link_id)
	   )
	SELECT connec_selected.*
	FROM connec_selected;



CREATE OR REPLACE VIEW v_edit_gully
AS WITH
	typevalue AS
       (
			SELECT edit_typevalue.typevalue, edit_typevalue.id, edit_typevalue.idval
			FROM edit_typevalue
			WHERE edit_typevalue.typevalue::text = ANY (ARRAY['sector_type'::character varying::text, 'drainzone_type'::character varying::text, 'omzone_type'::character varying::text, 'dwfzone_type'::character varying::text])
        ),
    sector_table AS
		(
			SELECT sector_id, macrosector_id, stylesheet, id::varchar(16) AS sector_type
			FROM sector
			LEFT JOIN typevalue t ON t.id::text = sector.sector_type AND t.typevalue::text = 'sector_type'::text
		),
	omzone_table AS
		(
			SELECT omzone_id, macroomzone_id, stylesheet, id::varchar(16) AS omzone_type
			FROM omzone
			LEFT JOIN typevalue t ON t.id::text = omzone.omzone_type AND t.typevalue::text = 'omzone_type'::text
		),
	drainzone_table AS
		(
			SELECT drainzone_id, stylesheet, id::varchar(16) AS drainzone_type
			FROM drainzone
			LEFT JOIN typevalue t ON t.id::text = drainzone.drainzone_type AND t.typevalue::text = 'drainzone_type'::text
		),
	dwfzone_table AS
		(
			SELECT dwfzone_id, stylesheet, id::varchar(16) AS dwfzone_type
			FROM dwfzone
			LEFT JOIN typevalue t ON t.id::text = dwfzone.dwfzone_type AND t.typevalue::text = 'dwfzone_type'::text
		),
	inp_network_mode AS
    	(
			SELECT value FROM config_param_user WHERE parameter::text = 'inp_options_networkmode'::text AND config_param_user.cur_user::text = CURRENT_USER
        ),
    link_planned AS
    	(
			SELECT link_id, feature_id, feature_type, exit_id, exit_type, l.expl_id, macroexpl_id, l.sector_id, sector_type, macrosector_id, l.omzone_id, omzone_type, macroomzone_id,
			l.drainzone_id, drainzone_type, l.dwfzone_id, dwfzone_type,
			fluid_type
			FROM link l
			JOIN exploitation USING (expl_id)
			JOIN sector_table ON l.sector_id = sector_table.sector_id
			LEFT JOIN omzone_table ON l.omzone_id = omzone_table.omzone_id
			LEFT JOIN drainzone_table ON l.omzone_id = drainzone_table.drainzone_id
			LEFT JOIN dwfzone_table ON l.dwfzone_id = dwfzone_table.dwfzone_id
			WHERE l.state = 2
    	),
    gully_psector AS
        (
			SELECT DISTINCT ON (pp.gully_id, pp.state) pp.gully_id, pp.state AS p_state, pp.psector_id, pp.arc_id, pp.link_id
			FROM plan_psector_x_gully pp
			JOIN selector_psector sp ON sp.cur_user = current_user AND sp.psector_id = pp.psector_id
			ORDER BY pp.gully_id, pp.state, pp.link_id DESC NULLS LAST
        ),
    gully_selector AS
        (
            SELECT gully.gully_id, arc_id::varchar(16), null::integer as link_id
            FROM gully
            JOIN selector_state s ON s.cur_user = CURRENT_USER AND gully.state = s.state_id
            LEFT JOIN (
            SELECT gully_id FROM gully_psector WHERE p_state = 0
            ) a USING (gully_id)
            WHERE a.gully_id IS NULL
            AND EXISTS (
                SELECT 1 FROM selector_expl se
                WHERE s.cur_user = current_user
                AND se.expl_id = ANY (array_append(gully.expl_visibility, gully.expl_id))
            )
            AND EXISTS (
                SELECT 1 FROM selector_sector sc
                WHERE sc.cur_user = current_user
                AND sc.sector_id = gully.sector_id
            )
            AND EXISTS (
                SELECT 1 FROM selector_municipality sm
                WHERE sm.cur_user = current_user
                AND sm.muni_id = gully.muni_id
            )
            UNION ALL
            SELECT gully_id, gully_psector.arc_id::varchar(16), link_id FROM gully_psector
            WHERE p_state = 1
        ),
    gully_selected AS
    	(
			SELECT gully.gully_id,
			gully.code,
            gully.sys_code,
			gully.top_elev,
			gully.ymax,
			gully.sandbox,
			gully.matcat_id,
			gully.gully_type,
			cat_feature.feature_class AS sys_type,
			gully.gullycat_id,
			cat_gully.matcat_id AS cat_gully_matcat,
			gully.units,
			gully.groove,
			gully.groove_height,
			gully.groove_length,
			gully.siphon,
			gully._connec_arccat_id as connec_arccat_id, -- todo: remove this
			gully.connec_length,
			CASE
			   WHEN ((gully.top_elev - gully.ymax + gully.sandbox + gully.connec_y2) / 2::numeric) IS NOT NULL THEN ((gully.top_elev - gully.ymax + gully.sandbox + gully.connec_y2) / 2::numeric)::numeric(12,3)
			   ELSE gully.connec_depth
			END AS connec_depth,
			CASE
				WHEN gully._connec_matcat_id IS NULL THEN cc.matcat_id::text
				ELSE gully._connec_matcat_id
			END AS connec_matcat_id,
			gully.top_elev - gully.ymax + gully.sandbox AS connec_y1,
			gully.connec_y2,
			cat_gully.width AS grate_width,
			cat_gully.length AS grate_length,
			gully.arc_id,
            gully.omunit_id,
			gully.epa_type,
			gully.state,
			gully.state_type,
			gully.expl_id,
			exploitation.macroexpl_id,
			CASE
				WHEN link_planned.sector_id IS NULL THEN sector_table.sector_id
				ELSE link_planned.sector_id
			END AS sector_id,
			CASE
				WHEN link_planned.sector_id IS NULL THEN sector_table.sector_type
				ELSE link_planned.sector_type
			END AS sector_type,
			CASE
				WHEN link_planned.macrosector_id IS NULL THEN sector_table.macrosector_id
				ELSE link_planned.macrosector_id
			END AS macrosector_id,
			gully.muni_id,
			CASE
				WHEN link_planned.drainzone_id IS NULL THEN drainzone_table.drainzone_id
				ELSE link_planned.drainzone_id
			END AS drainzone_id,
			CASE
				WHEN link_planned.drainzone_type IS NULL THEN drainzone_table.drainzone_type
				ELSE link_planned.drainzone_type
			END AS drainzone_type,
			CASE
				WHEN link_planned.omzone_id IS NULL THEN omzone_table.omzone_id
				ELSE link_planned.omzone_id
			END AS omzone_id,
			CASE
				WHEN link_planned.omzone_type IS NULL THEN omzone_table.omzone_type
				ELSE link_planned.omzone_type
			END AS omzone_type,
			CASE
				WHEN link_planned.macroomzone_id IS NULL THEN omzone_table.macroomzone_id
				ELSE link_planned.macroomzone_id
			END AS macroomzone_id,
			CASE
				WHEN link_planned.dwfzone_id IS NULL THEN dwfzone_table.dwfzone_id
				ELSE link_planned.dwfzone_id
			END AS dwfzone_id,
			CASE
				WHEN link_planned.dwfzone_type IS NULL THEN dwfzone_table.dwfzone_type
				ELSE link_planned.dwfzone_type
			END AS dwfzone_type,
			gully.minsector_id,
			gully.macrominsector_id,
			gully.soilcat_id,
			gully.function_type,
			gully.category_type,
			gully.location_type,
			gully.fluid_type,
			gully.descript,
			gully.annotation,
			gully.observ,
			gully.comment,
			concat(cat_feature.link_path, gully.link) AS link,
			gully.num_value,
			gully.district_id,
			gully.postcode,
			streetname_id,
			gully.postnumber,
			gully.postcomplement,
			streetname2_id,
			gully.postnumber2,
			gully.postcomplement2,
			mu.region_id,
			mu.province_id,
			gully.workcat_id,
			gully.workcat_id_end,
			gully.workcat_id_plan,
			gully.builtdate,
			gully.enddate,
			gully.ownercat_id,
			gully.placement_type,
			gully.access_type,
			gully.asset_id,
			gully.adate,
			gully.adescript,
			gully.verified,
			gully.uncertain,
			cat_gully.label,
			gully.label_x,
			gully.label_y,
			gully.label_rotation,
			gully.rotation,
			gully.label_quadrant,
			cat_gully.svg,
			gully.inventory,
			gully.publish,
			vst.is_operative,
            CASE
			   WHEN gully.sector_id > 0 AND vst.is_operative = true AND gully.epa_type::text = 'GULLY'::character varying(16)::text AND inp_network_mode.value = '2'::text THEN gully.epa_type
			   ELSE NULL::character varying(16)
			END AS inp_type,
			sector_table.stylesheet ->> 'featureColor'::text AS sector_style,
			omzone_table.stylesheet ->> 'featureColor'::text AS omzone_style,
			drainzone_table.stylesheet ->> 'featureColor'::text AS drainzone_style,
			dwfzone_table.stylesheet ->> 'featureColor'::text AS dwfzone_style,
			gully.lock_level,
			gully.expl_visibility,
            date_trunc('second'::text, gully.created_at) AS created_at,
			gully.created_by,
			date_trunc('second'::text, gully.updated_at) AS updated_at,
			gully.updated_by,
			gully.the_geom,
            CASE
				WHEN link_planned.exit_id IS NULL THEN gully.pjoint_id
				ELSE link_planned.exit_id
			END AS pjoint_id,
			CASE
				WHEN link_planned.exit_type IS NULL THEN gully.pjoint_type
				ELSE link_planned.exit_type
			END AS pjoint_type,
			gully.gullycat2_id,
			gully.units_placement,
			gully.siphon_type,
			gully.odorflap,
			gully.length,
			gully.width
			FROM inp_network_mode, gully_selector
			JOIN gully using (gully_id)
			JOIN cat_gully ON gully.gullycat_id::text = cat_gully.id::text
			JOIN exploitation ON gully.expl_id = exploitation.expl_id
			JOIN cat_feature ON gully.gully_type::text = cat_feature.id::text
			LEFT JOIN cat_connec cc ON cc.id::text = gully._connec_arccat_id::text
			JOIN value_state_type vst ON vst.id = gully.state_type
			JOIN ext_municipality mu ON gully.muni_id = mu.muni_id
			JOIN sector_table ON gully.sector_id = sector_table.sector_id
			LEFT JOIN omzone_table ON gully.omzone_id = omzone_table.omzone_id
			LEFT JOIN drainzone_table ON gully.omzone_id = drainzone_table.drainzone_id
			LEFT JOIN dwfzone_table ON gully.dwfzone_id = dwfzone_table.dwfzone_id
			LEFT JOIN link_planned ON gully.gully_id = feature_id
		)
	SELECT gully_selected.*
	FROM gully_selected;


-- dependent views
CREATE OR REPLACE VIEW v_plan_aux_arc_pavement
AS SELECT plan_arc_x_pavement.arc_id,
    sum(v_price_x_catpavement.thickness * plan_arc_x_pavement.percent)::numeric(12,2) AS thickness,
    sum(v_price_x_catpavement.m2pav_cost * plan_arc_x_pavement.percent)::numeric(12,2) AS m2pav_cost,
    'Various pavements'::character varying AS pavcat_id,
    1 AS percent,
    'VARIOUS'::character varying AS price_id
   FROM plan_arc_x_pavement
     JOIN v_price_x_catpavement USING (pavcat_id)
  GROUP BY plan_arc_x_pavement.arc_id
UNION
 SELECT v_edit_arc.arc_id,
    c.thickness,
    v_price_x_catpavement.m2pav_cost,
    v_edit_arc.pavcat_id,
    1 AS percent,
    p.id AS price_id
   FROM v_edit_arc
     JOIN cat_pavement c ON c.id::text = v_edit_arc.pavcat_id::text
     JOIN v_price_x_catpavement USING (pavcat_id)
     LEFT JOIN v_price_compost p ON c.m2_cost::text = p.id::text
     LEFT JOIN ( SELECT plan_arc_x_pavement.arc_id
           FROM plan_arc_x_pavement) a USING (arc_id)
  WHERE a.arc_id IS NULL;

CREATE OR REPLACE VIEW v_price_x_catarc
AS SELECT cat_arc.id,
    cat_arc.geom1,
    cat_arc.z1,
    cat_arc.z2,
    cat_arc.width,
    cat_arc.area,
    cat_arc.thickness,
    cat_arc.estimated_depth,
    cat_arc.cost_unit,
    price_cost.price AS cost,
    price_m2bottom.price AS m2bottom_cost,
    price_m3protec.price AS m3protec_cost
   FROM cat_arc
     JOIN v_price_compost price_cost ON cat_arc.cost::text = price_cost.id::text
     JOIN v_price_compost price_m2bottom ON cat_arc.m2bottom_cost::text = price_m2bottom.id::text
     JOIN v_price_compost price_m3protec ON cat_arc.m3protec_cost::text = price_m3protec.id::text;

CREATE OR REPLACE VIEW v_plan_arc
AS SELECT d.arc_id,
    d.node_1,
    d.node_2,
    d.arc_type::text,
    d.arccat_id,
    d.epa_type,
    d.state,
    d.expl_id,
    d.sector_id,
    d.annotation,
    d.soilcat_id,
    d.y1,
    d.y2,
    d.mean_y,
    d.z1,
    d.z2,
    d.thickness,
    d.width,
    d.b,
    d.bulk,
    d.geom1,
    d.area,
    d.y_param,
    d.total_y,
    d.rec_y,
    d.geom1_ext,
    d.calculed_y,
    d.m3mlexc,
    d.m2mltrenchl,
    d.m2mlbottom,
    d.m2mlpav,
    d.m3mlprotec,
    d.m3mlfill,
    d.m3mlexcess,
    d.m3exc_cost,
    d.m2trenchl_cost,
    d.m2bottom_cost,
    d.m2pav_cost,
    d.m3protec_cost,
    d.m3fill_cost,
    d.m3excess_cost,
    d.cost_unit,
    d.pav_cost,
    d.exc_cost,
    d.trenchl_cost,
    d.base_cost,
    d.protec_cost,
    d.fill_cost,
    d.excess_cost,
    d.arc_cost,
    d.cost,
    d.length,
    d.budget,
    d.other_budget,
        CASE
            WHEN d.other_budget IS NOT NULL THEN (d.budget + d.other_budget)::numeric(14,2)
            ELSE d.budget
        END AS total_budget,
    d.the_geom
   FROM ( WITH v_plan_aux_arc_cost AS (
                 WITH v_plan_aux_arc_ml AS (
                         SELECT v_edit_arc.arc_id,
                            v_edit_arc.y1,
                            v_edit_arc.y2,
                                CASE
                                    WHEN (v_edit_arc.y1 * v_edit_arc.y2) = 0::numeric OR (v_edit_arc.y1 * v_edit_arc.y2) IS NULL THEN v_price_x_catarc.estimated_depth
                                    ELSE ((v_edit_arc.y1 + v_edit_arc.y2) / 2::numeric)::numeric(12,2)
                                END AS mean_y,
                            v_edit_arc.arccat_id,
                            COALESCE(v_price_x_catarc.geom1, 0::numeric)::numeric(12,4) AS geom1,
                            COALESCE(v_price_x_catarc.z1, 0::numeric)::numeric(12,2) AS z1,
                            COALESCE(v_price_x_catarc.z2, 0::numeric)::numeric(12,2) AS z2,
                            COALESCE(v_price_x_catarc.area, 0::numeric)::numeric(12,4) AS area,
                            COALESCE(v_price_x_catarc.width, 0::numeric)::numeric(12,2) AS width,
                            COALESCE(v_price_x_catarc.thickness / 1000::numeric, 0::numeric)::numeric(12,2) AS bulk,
                            v_price_x_catarc.cost_unit,
                            COALESCE(v_price_x_catarc.cost, 0::numeric)::numeric(12,2) AS arc_cost,
                            COALESCE(v_price_x_catarc.m2bottom_cost, 0::numeric)::numeric(12,2) AS m2bottom_cost,
                            COALESCE(v_price_x_catarc.m3protec_cost, 0::numeric)::numeric(12,2) AS m3protec_cost,
                            v_price_x_catsoil.id AS soilcat_id,
                            COALESCE(v_price_x_catsoil.y_param, 10::numeric)::numeric(5,2) AS y_param,
                            COALESCE(v_price_x_catsoil.b, 0::numeric)::numeric(5,2) AS b,
                            COALESCE(v_price_x_catsoil.trenchlining, 0::numeric) AS trenchlining,
                            COALESCE(v_price_x_catsoil.m3exc_cost, 0::numeric)::numeric(12,2) AS m3exc_cost,
                            COALESCE(v_price_x_catsoil.m3fill_cost, 0::numeric)::numeric(12,2) AS m3fill_cost,
                            COALESCE(v_price_x_catsoil.m3excess_cost, 0::numeric)::numeric(12,2) AS m3excess_cost,
                            COALESCE(v_price_x_catsoil.m2trenchl_cost, 0::numeric)::numeric(12,2) AS m2trenchl_cost,
                            COALESCE(v_plan_aux_arc_pavement.thickness, 0::numeric)::numeric(12,2) AS thickness,
                            COALESCE(v_plan_aux_arc_pavement.m2pav_cost, 0::numeric) AS m2pav_cost,
                            v_edit_arc.state,
                            v_edit_arc.expl_id,
                            v_edit_arc.the_geom
                           FROM v_edit_arc
                             LEFT JOIN v_price_x_catarc ON v_edit_arc.arccat_id::text = v_price_x_catarc.id::text
                             LEFT JOIN v_price_x_catsoil ON v_edit_arc.soilcat_id::text = v_price_x_catsoil.id::text
                             LEFT JOIN v_plan_aux_arc_pavement ON v_plan_aux_arc_pavement.arc_id::text = v_edit_arc.arc_id::text
                          WHERE v_plan_aux_arc_pavement.arc_id IS NOT NULL
                        )
                 SELECT v_plan_aux_arc_ml.arc_id,
                    v_plan_aux_arc_ml.y1,
                    v_plan_aux_arc_ml.y2,
                    v_plan_aux_arc_ml.mean_y,
                    v_plan_aux_arc_ml.arccat_id,
                    v_plan_aux_arc_ml.geom1,
                    v_plan_aux_arc_ml.z1,
                    v_plan_aux_arc_ml.z2,
                    v_plan_aux_arc_ml.area,
                    v_plan_aux_arc_ml.width,
                    v_plan_aux_arc_ml.bulk,
                    v_plan_aux_arc_ml.cost_unit,
                    v_plan_aux_arc_ml.arc_cost,
                    v_plan_aux_arc_ml.m2bottom_cost,
                    v_plan_aux_arc_ml.m3protec_cost,
                    v_plan_aux_arc_ml.soilcat_id,
                    v_plan_aux_arc_ml.y_param,
                    v_plan_aux_arc_ml.b,
                    v_plan_aux_arc_ml.trenchlining,
                    v_plan_aux_arc_ml.m3exc_cost,
                    v_plan_aux_arc_ml.m3fill_cost,
                    v_plan_aux_arc_ml.m3excess_cost,
                    v_plan_aux_arc_ml.m2trenchl_cost,
                    v_plan_aux_arc_ml.thickness,
                    v_plan_aux_arc_ml.m2pav_cost,
                    v_plan_aux_arc_ml.state,
                    v_plan_aux_arc_ml.expl_id,
                    (2::numeric * ((v_plan_aux_arc_ml.mean_y + v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.bulk) / v_plan_aux_arc_ml.y_param) + v_plan_aux_arc_ml.width + v_plan_aux_arc_ml.b * 2::numeric)::numeric(12,3) AS m2mlpavement,
                    (2::numeric * v_plan_aux_arc_ml.b + v_plan_aux_arc_ml.width)::numeric(12,3) AS m2mlbase,
                    (v_plan_aux_arc_ml.mean_y + v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.bulk - v_plan_aux_arc_ml.thickness)::numeric(12,3) AS calculed_y,
                    (v_plan_aux_arc_ml.trenchlining * 2::numeric * (v_plan_aux_arc_ml.mean_y + v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.bulk - v_plan_aux_arc_ml.thickness))::numeric(12,3) AS m2mltrenchl,
                    ((v_plan_aux_arc_ml.mean_y + v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.bulk - v_plan_aux_arc_ml.thickness) * (2::numeric * ((v_plan_aux_arc_ml.mean_y + v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.bulk - v_plan_aux_arc_ml.thickness) / v_plan_aux_arc_ml.y_param) + v_plan_aux_arc_ml.width + v_plan_aux_arc_ml.b * 2::numeric + v_plan_aux_arc_ml.b * 2::numeric + v_plan_aux_arc_ml.width) / 2::numeric)::numeric(12,3) AS m3mlexc,
                    ((v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.geom1 + v_plan_aux_arc_ml.bulk * 2::numeric + v_plan_aux_arc_ml.z2) * ((2::numeric * ((v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.geom1 + v_plan_aux_arc_ml.bulk * 2::numeric + v_plan_aux_arc_ml.z2) / v_plan_aux_arc_ml.y_param) + v_plan_aux_arc_ml.width + v_plan_aux_arc_ml.b * 2::numeric + (v_plan_aux_arc_ml.b * 2::numeric + v_plan_aux_arc_ml.width)) / 2::numeric) - v_plan_aux_arc_ml.area)::numeric(12,3) AS m3mlprotec,
                    ((v_plan_aux_arc_ml.mean_y + v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.bulk - v_plan_aux_arc_ml.thickness) * (2::numeric * ((v_plan_aux_arc_ml.mean_y + v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.bulk - v_plan_aux_arc_ml.thickness) / v_plan_aux_arc_ml.y_param) + v_plan_aux_arc_ml.width + v_plan_aux_arc_ml.b * 2::numeric + v_plan_aux_arc_ml.b * 2::numeric + v_plan_aux_arc_ml.width) / 2::numeric - (v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.geom1 + v_plan_aux_arc_ml.bulk * 2::numeric + v_plan_aux_arc_ml.z2) * ((2::numeric * ((v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.geom1 + v_plan_aux_arc_ml.bulk * 2::numeric + v_plan_aux_arc_ml.z2) / v_plan_aux_arc_ml.y_param) + v_plan_aux_arc_ml.width + v_plan_aux_arc_ml.b * 2::numeric + (v_plan_aux_arc_ml.b * 2::numeric + v_plan_aux_arc_ml.width)) / 2::numeric))::numeric(12,3) AS m3mlfill,
                    ((v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.geom1 + v_plan_aux_arc_ml.bulk * 2::numeric + v_plan_aux_arc_ml.z2) * ((2::numeric * ((v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.geom1 + v_plan_aux_arc_ml.bulk * 2::numeric + v_plan_aux_arc_ml.z2) / v_plan_aux_arc_ml.y_param) + v_plan_aux_arc_ml.width + v_plan_aux_arc_ml.b * 2::numeric + (v_plan_aux_arc_ml.b * 2::numeric + v_plan_aux_arc_ml.width)) / 2::numeric))::numeric(12,3) AS m3mlexcess,
                    v_plan_aux_arc_ml.the_geom
                   FROM v_plan_aux_arc_ml
                  WHERE v_plan_aux_arc_ml.arc_id IS NOT NULL
                )
         SELECT v_plan_aux_arc_cost.arc_id,
            arc.node_1,
            arc.node_2,
            arc.arc_type::text,
            v_plan_aux_arc_cost.arccat_id,
            arc.epa_type,
            v_plan_aux_arc_cost.state,
            v_plan_aux_arc_cost.expl_id,
            arc.sector_id,
            arc.annotation,
            v_plan_aux_arc_cost.soilcat_id,
            v_plan_aux_arc_cost.y1,
            v_plan_aux_arc_cost.y2,
            v_plan_aux_arc_cost.mean_y,
            v_plan_aux_arc_cost.z1,
            v_plan_aux_arc_cost.z2,
            v_plan_aux_arc_cost.thickness,
            v_plan_aux_arc_cost.width,
            v_plan_aux_arc_cost.b,
            v_plan_aux_arc_cost.bulk,
            v_plan_aux_arc_cost.geom1,
            v_plan_aux_arc_cost.area,
            v_plan_aux_arc_cost.y_param,
            (v_plan_aux_arc_cost.calculed_y + v_plan_aux_arc_cost.thickness)::numeric(12,2) AS total_y,
            (v_plan_aux_arc_cost.calculed_y - 2::numeric * v_plan_aux_arc_cost.bulk - v_plan_aux_arc_cost.z1 - v_plan_aux_arc_cost.z2 - v_plan_aux_arc_cost.geom1)::numeric(12,2) AS rec_y,
            (v_plan_aux_arc_cost.geom1 + 2::numeric * v_plan_aux_arc_cost.bulk)::numeric(12,2) AS geom1_ext,
            v_plan_aux_arc_cost.calculed_y,
            v_plan_aux_arc_cost.m3mlexc,
            v_plan_aux_arc_cost.m2mltrenchl,
            v_plan_aux_arc_cost.m2mlbase AS m2mlbottom,
            v_plan_aux_arc_cost.m2mlpavement AS m2mlpav,
            v_plan_aux_arc_cost.m3mlprotec,
            v_plan_aux_arc_cost.m3mlfill,
            v_plan_aux_arc_cost.m3mlexcess,
            v_plan_aux_arc_cost.m3exc_cost,
            v_plan_aux_arc_cost.m2trenchl_cost,
            v_plan_aux_arc_cost.m2bottom_cost,
            v_plan_aux_arc_cost.m2pav_cost::numeric(12,2) AS m2pav_cost,
            v_plan_aux_arc_cost.m3protec_cost,
            v_plan_aux_arc_cost.m3fill_cost,
            v_plan_aux_arc_cost.m3excess_cost,
            v_plan_aux_arc_cost.cost_unit,
                CASE
                    WHEN v_plan_aux_arc_cost.cost_unit::text = 'u'::text THEN NULL::numeric
                    ELSE v_plan_aux_arc_cost.m2mlpavement * v_plan_aux_arc_cost.m2pav_cost
                END::numeric(12,3) AS pav_cost,
                CASE
                    WHEN v_plan_aux_arc_cost.cost_unit::text = 'u'::text THEN NULL::numeric
                    ELSE v_plan_aux_arc_cost.m3mlexc * v_plan_aux_arc_cost.m3exc_cost
                END::numeric(12,3) AS exc_cost,
                CASE
                    WHEN v_plan_aux_arc_cost.cost_unit::text = 'u'::text THEN NULL::numeric
                    ELSE v_plan_aux_arc_cost.m2mltrenchl * v_plan_aux_arc_cost.m2trenchl_cost
                END::numeric(12,3) AS trenchl_cost,
                CASE
                    WHEN v_plan_aux_arc_cost.cost_unit::text = 'u'::text THEN NULL::numeric
                    ELSE v_plan_aux_arc_cost.m2mlbase * v_plan_aux_arc_cost.m2bottom_cost
                END::numeric(12,3) AS base_cost,
                CASE
                    WHEN v_plan_aux_arc_cost.cost_unit::text = 'u'::text THEN NULL::numeric
                    ELSE v_plan_aux_arc_cost.m3mlprotec * v_plan_aux_arc_cost.m3protec_cost
                END::numeric(12,3) AS protec_cost,
                CASE
                    WHEN v_plan_aux_arc_cost.cost_unit::text = 'u'::text THEN NULL::numeric
                    ELSE v_plan_aux_arc_cost.m3mlfill * v_plan_aux_arc_cost.m3fill_cost
                END::numeric(12,3) AS fill_cost,
                CASE
                    WHEN v_plan_aux_arc_cost.cost_unit::text = 'u'::text THEN NULL::numeric
                    ELSE v_plan_aux_arc_cost.m3mlexcess * v_plan_aux_arc_cost.m3excess_cost
                END::numeric(12,3) AS excess_cost,
            v_plan_aux_arc_cost.arc_cost::numeric(12,3) AS arc_cost,
                CASE
                    WHEN v_plan_aux_arc_cost.cost_unit::text = 'u'::text THEN v_plan_aux_arc_cost.arc_cost
                    ELSE v_plan_aux_arc_cost.m3mlexc * v_plan_aux_arc_cost.m3exc_cost + v_plan_aux_arc_cost.m2mlbase * v_plan_aux_arc_cost.m2bottom_cost + v_plan_aux_arc_cost.m2mltrenchl * v_plan_aux_arc_cost.m2trenchl_cost + v_plan_aux_arc_cost.m3mlprotec * v_plan_aux_arc_cost.m3protec_cost + v_plan_aux_arc_cost.m3mlfill * v_plan_aux_arc_cost.m3fill_cost + v_plan_aux_arc_cost.m3mlexcess * v_plan_aux_arc_cost.m3excess_cost + v_plan_aux_arc_cost.m2mlpavement * v_plan_aux_arc_cost.m2pav_cost + v_plan_aux_arc_cost.arc_cost
                END::numeric(12,2) AS cost,
                CASE
                    WHEN v_plan_aux_arc_cost.cost_unit::text = 'u'::text THEN NULL::double precision
                    ELSE st_length2d(v_plan_aux_arc_cost.the_geom)
                END::numeric(12,2) AS length,
                CASE
                    WHEN v_plan_aux_arc_cost.cost_unit::text = 'u'::text THEN v_plan_aux_arc_cost.arc_cost
                    ELSE st_length2d(v_plan_aux_arc_cost.the_geom)::numeric(12,2) * (v_plan_aux_arc_cost.m3mlexc * v_plan_aux_arc_cost.m3exc_cost + v_plan_aux_arc_cost.m2mlbase * v_plan_aux_arc_cost.m2bottom_cost + v_plan_aux_arc_cost.m2mltrenchl * v_plan_aux_arc_cost.m2trenchl_cost + v_plan_aux_arc_cost.m3mlprotec * v_plan_aux_arc_cost.m3protec_cost + v_plan_aux_arc_cost.m3mlfill * v_plan_aux_arc_cost.m3fill_cost + v_plan_aux_arc_cost.m3mlexcess * v_plan_aux_arc_cost.m3excess_cost + v_plan_aux_arc_cost.m2mlpavement * v_plan_aux_arc_cost.m2pav_cost + v_plan_aux_arc_cost.arc_cost)::numeric(14,2)
                END::numeric(14,2) AS budget,
            COALESCE(v_plan_aux_arc_connec.connec_total_cost, 0::numeric) + COALESCE(v_plan_aux_arc_gully.gully_total_cost, 0::numeric) AS other_budget,
            v_plan_aux_arc_cost.the_geom
           FROM v_plan_aux_arc_cost
             JOIN arc ON v_plan_aux_arc_cost.arc_id::text = arc.arc_id::text
             LEFT JOIN ( SELECT DISTINCT ON (c.arc_id) c.arc_id,
                    (min(p.price) * count(*)::numeric)::numeric(12,2) AS connec_total_cost
                   FROM v_edit_connec c
                     JOIN arc arc_1 USING (arc_id)
                     JOIN cat_arc ON cat_arc.id::text = arc_1.arccat_id::text
                     LEFT JOIN v_price_compost p ON cat_arc.connect_cost = p.id::text
                  WHERE c.arc_id IS NOT NULL
                  GROUP BY c.arc_id) v_plan_aux_arc_connec ON v_plan_aux_arc_connec.arc_id::text = v_plan_aux_arc_cost.arc_id::text
             LEFT JOIN ( SELECT DISTINCT ON (c.arc_id) c.arc_id,
                    (min(p.price) * count(*)::numeric)::numeric(12,2) AS gully_total_cost
                   FROM v_edit_gully c
                     JOIN arc arc_1 USING (arc_id)
                     JOIN cat_arc ON cat_arc.id::text = arc_1.arccat_id::text
                     LEFT JOIN v_price_compost p ON cat_arc.connect_cost = p.id::text
                  WHERE c.arc_id IS NOT NULL
                  GROUP BY c.arc_id) v_plan_aux_arc_gully ON v_plan_aux_arc_gully.arc_id::text = v_plan_aux_arc_cost.arc_id::text) d;


CREATE OR REPLACE VIEW v_ext_raster_dem
AS SELECT DISTINCT ON (r.id) r.id,
    c.code,
    c.alias,
    c.raster_type,
    c.descript,
    c.source,
    c.provider,
    c.year,
    r.rast,
    r.rastercat_id,
    r.envelope
    FROM v_ext_municipality a, ext_raster_dem r
    JOIN ext_cat_raster c ON c.id = r.rastercat_id
    WHERE st_dwithin(r.envelope, a.the_geom, 0::double precision);


CREATE OR REPLACE VIEW v_ui_element_x_gully
AS SELECT
    element_x_gully.gully_id,
    element_x_gully.element_id,
    cat_feature.feature_class,
    cat_element.element_type,
    element.elementcat_id,
    cat_element.descript,
    element.num_elements,
    value_state.name AS state,
    value_state_type.name AS state_type,
    element.observ,
    element.comment,
    element.location_type,
    element.builtdate,
    element.enddate
   FROM element_x_gully
     JOIN element ON element.element_id::text = element_x_gully.element_id::text
     JOIN value_state ON element.state = value_state.id
     LEFT JOIN value_state_type ON element.state_type = value_state_type.id
     LEFT JOIN man_type_location ON man_type_location.location_type::text = element.location_type::text AND man_type_location.feature_type::text = 'ELEMENT'::text
     LEFT JOIN cat_element ON cat_element.id::text = element.elementcat_id::text
     JOIN cat_feature_element cfe ON cfe.id::text = cat_element.element_type::text
     JOIN cat_feature ON cat_feature.id::text = cfe.id::text;


CREATE OR REPLACE VIEW v_ui_arc_x_relations
AS WITH links_node AS (
         SELECT n.node_id,
            l.feature_id,
            l.exit_type AS proceed_from,
            l.exit_id AS proceed_from_id,
            l.state AS l_state,
            n.state AS n_state
           FROM node n
             JOIN link l ON n.node_id::text = l.exit_id::text
          WHERE l.state = 1
        )
 SELECT row_number() OVER () + 1000000 AS rid,
    v_edit_connec.arc_id,
    v_edit_connec.connec_type::text AS featurecat_id,
    v_edit_connec.conneccat_id AS catalog,
    v_edit_connec.connec_id AS feature_id,
    v_edit_connec.code AS feature_code,
    v_edit_connec.sys_type,
    a.state AS arc_state,
    v_edit_connec.state AS feature_state,
    st_x(v_edit_connec.the_geom) AS x,
    st_y(v_edit_connec.the_geom) AS y,
    l.exit_type AS proceed_from,
    l.exit_id AS proceed_from_id,
    'v_edit_connec'::text AS sys_table_id
   FROM v_edit_connec
     JOIN link l ON v_edit_connec.connec_id::text = l.feature_id::text
     JOIN arc a ON a.arc_id::text = v_edit_connec.arc_id::text
  WHERE v_edit_connec.arc_id IS NOT NULL AND l.exit_type::text <> 'NODE'::text AND l.state = 1 AND l.state = 1 AND a.state = 1
UNION
 SELECT DISTINCT ON (c.connec_id) row_number() OVER () + 2000000 AS rid,
    a.arc_id,
    c.connec_type::text AS featurecat_id,
    c.conneccat_id AS catalog,
    c.connec_id AS feature_id,
    c.code AS feature_code,
    c.sys_type,
    a.state AS arc_state,
    c.state AS feature_state,
    st_x(c.the_geom) AS x,
    st_y(c.the_geom) AS y,
    n.proceed_from,
    n.proceed_from_id,
    'v_edit_connec'::text AS sys_table_id
   FROM arc a
     JOIN links_node n ON a.node_1::text = n.node_id::text
     JOIN v_edit_connec c ON c.connec_id::text = n.feature_id::text
UNION
 SELECT row_number() OVER () + 3000000 AS rid,
    v_edit_gully.arc_id,
    v_edit_gully.gully_type AS featurecat_id,
    v_edit_gully.gullycat_id AS catalog,
    v_edit_gully.gully_id AS feature_id,
    v_edit_gully.code AS feature_code,
    v_edit_gully.sys_type,
    a.state AS arc_state,
    v_edit_gully.state AS feature_state,
    st_x(v_edit_gully.the_geom) AS x,
    st_y(v_edit_gully.the_geom) AS y,
    l.exit_type AS proceed_from,
    l.exit_id AS proceed_from_id,
    'v_edit_gully'::text AS sys_table_id
   FROM v_edit_gully
     JOIN link l ON v_edit_gully.gully_id::text = l.feature_id::text
     JOIN arc a ON a.arc_id::text = v_edit_gully.arc_id::text
  WHERE v_edit_gully.arc_id IS NOT NULL AND l.exit_type::text <> 'NODE'::text AND l.state = 1 AND a.state = 1
UNION
 SELECT DISTINCT ON (g.gully_id) row_number() OVER () + 4000000 AS rid,
    a.arc_id,
    g.gully_type AS featurecat_id,
    g.gullycat_id AS catalog,
    g.gully_id AS feature_id,
    g.code AS feature_code,
    g.sys_type,
    a.state AS arc_state,
    g.state AS feature_state,
    st_x(g.the_geom) AS x,
    st_y(g.the_geom) AS y,
    n.proceed_from,
    n.proceed_from_id,
    'v_edit_gully'::text AS sys_table_id
   FROM arc a
     JOIN links_node n ON a.node_1::text = n.node_id::text
     JOIN v_edit_gully g ON g.gully_id::text = n.feature_id::text;



CREATE OR REPLACE VIEW v_edit_inp_conduit
AS SELECT v_edit_arc.arc_id,
    v_edit_arc.node_1,
    v_edit_arc.node_2,
    v_edit_arc.y1,
    v_edit_arc.custom_y1,
    v_edit_arc.elev1,
    v_edit_arc.custom_elev1,
    v_edit_arc.sys_elev1,
    v_edit_arc.y2,
    v_edit_arc.custom_y2,
    v_edit_arc.elev2,
    v_edit_arc.custom_elev2,
    v_edit_arc.sys_elev2,
    v_edit_arc.arccat_id,
    v_edit_arc.matcat_id,
    v_edit_arc.cat_shape,
    v_edit_arc.cat_geom1,
    v_edit_arc.gis_length,
    v_edit_arc.sector_id,
    v_edit_arc.macrosector_id,
    v_edit_arc.state,
    v_edit_arc.state_type,
    v_edit_arc.annotation,
    v_edit_arc.inverted_slope,
    v_edit_arc.custom_length,
    v_edit_arc.expl_id,
    inp_conduit.barrels,
    inp_conduit.culvert,
    inp_conduit.kentry,
    inp_conduit.kexit,
    inp_conduit.kavg,
    inp_conduit.flap,
    inp_conduit.q0,
    inp_conduit.qmax,
    inp_conduit.seepage,
    inp_conduit.custom_n,
    v_edit_arc.the_geom
    FROM v_edit_arc
    JOIN inp_conduit USING (arc_id)
	WHERE v_edit_arc.is_operative IS TRUE;

CREATE OR REPLACE VIEW v_edit_inp_dscenario_conduit
AS SELECT f.dscenario_id,
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
    v_edit_inp_conduit.the_geom
    FROM selector_inp_dscenario s, inp_dscenario_conduit f
    JOIN v_edit_inp_conduit USING (arc_id)
	WHERE s.dscenario_id = f.dscenario_id AND s.cur_user = CURRENT_USER;

CREATE OR REPLACE VIEW ve_pol_storage
AS SELECT polygon.pol_id,
    polygon.feature_id AS node_id,
    polygon.the_geom
    FROM polygon
    JOIN v_edit_node ON polygon.feature_id::text = v_edit_node.node_id::text
	WHERE polygon.sys_type::text = 'STORAGE'::text;

CREATE OR REPLACE VIEW ve_pol_wwtp
AS SELECT polygon.pol_id,
    polygon.feature_id AS node_id,
    polygon.the_geom
    FROM polygon
    JOIN v_edit_node ON polygon.feature_id::text = v_edit_node.node_id::text
   WHERE polygon.sys_type::text = 'WWTP'::text;


CREATE OR REPLACE VIEW v_edit_inp_subcatchment
AS SELECT inp_subcatchment.hydrology_id,
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
    inp_subcatchment.descript,
    inp_subcatchment.minelev,
    inp_subcatchment.muni_id
   FROM inp_subcatchment,
    config_param_user,
    selector_sector,
    selector_municipality
  WHERE inp_subcatchment.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text AND inp_subcatchment.muni_id = selector_municipality.muni_id AND selector_municipality.cur_user = "current_user"()::text AND inp_subcatchment.hydrology_id = config_param_user.value::integer AND config_param_user.cur_user::text = "current_user"()::text AND config_param_user.parameter::text = 'inp_options_hydrology_scenario'::text;


CREATE OR REPLACE VIEW ve_pol_chamber
AS SELECT polygon.pol_id,
    polygon.feature_id AS node_id,
    polygon.the_geom
    FROM polygon
	JOIN v_edit_node ON polygon.feature_id::text = v_edit_node.node_id::text
    WHERE polygon.sys_type::text = 'CHAMBER'::text;

CREATE OR REPLACE VIEW ve_pol_netgully
AS SELECT polygon.pol_id,
    polygon.feature_id AS node_id,
    polygon.the_geom
    FROM polygon
	JOIN v_edit_node ON polygon.feature_id::text = v_edit_node.node_id::text
    WHERE polygon.sys_type::text = 'NETGULLY'::text;

CREATE OR REPLACE VIEW v_price_x_catnode
AS SELECT cat_node.id,
    cat_node.estimated_y,
    cat_node.cost_unit,
    v_price_compost.price AS cost
   FROM cat_node
     JOIN v_price_compost ON cat_node.cost::text = v_price_compost.id::text;

CREATE OR REPLACE VIEW v_plan_node
AS SELECT a.node_id,
    a.nodecat_id,
    a.node_type::text,
    a.top_elev,
    a.elev,
    a.epa_type,
    a.state,
    a.sector_id,
    a.expl_id,
    a.annotation,
    a.cost_unit,
    a.descript,
    a.cost,
    a.measurement,
    a.budget,
    a.the_geom
   FROM ( SELECT v_edit_node.node_id,
            v_edit_node.nodecat_id,
            v_edit_node.sys_type AS node_type,
            v_edit_node.top_elev,
            v_edit_node.elev,
            v_edit_node.epa_type,
            v_edit_node.state,
            v_edit_node.sector_id,
            v_edit_node.expl_id,
            v_edit_node.annotation,
            v_price_x_catnode.cost_unit,
            v_price_compost.descript,
            v_price_compost.price AS cost,
                CASE
                    WHEN v_price_x_catnode.cost_unit::text = 'u'::text THEN 1::numeric
                    WHEN v_price_x_catnode.cost_unit::text = 'm3'::text THEN
                    CASE
                        WHEN v_edit_node.sys_type::text = 'STORAGE'::text THEN man_storage.max_volume
                        WHEN v_edit_node.sys_type::text = 'CHAMBER'::text THEN man_chamber.max_volume
                        ELSE NULL::numeric
                    END
                    WHEN v_price_x_catnode.cost_unit::text = 'm'::text THEN
                    CASE
                        WHEN v_edit_node.ymax = 0::numeric THEN v_price_x_catnode.estimated_y
                        WHEN v_edit_node.ymax IS NULL THEN v_price_x_catnode.estimated_y
                        ELSE v_edit_node.ymax
                    END
                    ELSE NULL::numeric
                END::numeric(12,2) AS measurement,
                CASE
                    WHEN v_price_x_catnode.cost_unit::text = 'u'::text THEN v_price_x_catnode.cost
                    WHEN v_price_x_catnode.cost_unit::text = 'm3'::text THEN
                    CASE
                        WHEN v_edit_node.sys_type::text = 'STORAGE'::text THEN man_storage.max_volume * v_price_x_catnode.cost
                        WHEN v_edit_node.sys_type::text = 'CHAMBER'::text THEN man_chamber.max_volume * v_price_x_catnode.cost
                        ELSE NULL::numeric
                    END
                    WHEN v_price_x_catnode.cost_unit::text = 'm'::text THEN
                    CASE
                        WHEN v_edit_node.ymax = 0::numeric THEN v_price_x_catnode.estimated_y * v_price_x_catnode.cost
                        WHEN v_edit_node.ymax IS NULL THEN v_price_x_catnode.estimated_y * v_price_x_catnode.cost
                        ELSE v_edit_node.ymax * v_price_x_catnode.cost
                    END
                    ELSE NULL::numeric
                END::numeric(12,2) AS budget,
            v_edit_node.the_geom
           FROM v_edit_node
             LEFT JOIN v_price_x_catnode ON v_edit_node.nodecat_id::text = v_price_x_catnode.id::text
             LEFT JOIN man_chamber ON man_chamber.node_id::text = v_edit_node.node_id::text
             LEFT JOIN man_storage ON man_storage.node_id::text = v_edit_node.node_id::text
             LEFT JOIN cat_node ON cat_node.id::text = v_edit_node.nodecat_id::text
             LEFT JOIN v_price_compost ON v_price_compost.id::text = cat_node.cost::text) a;

CREATE OR REPLACE VIEW v_ui_plan_node_cost
AS SELECT node.node_id,
    1 AS orderby,
    'element'::text AS identif,
    cat_node.id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    1 AS measurement,
    1::numeric * v_price_compost.price AS total_cost,
    NULL::double precision AS length
   FROM node
     JOIN cat_node ON cat_node.id::text = node.nodecat_id::text
     JOIN v_price_compost ON cat_node.cost::text = v_price_compost.id::text
     JOIN v_plan_node ON node.node_id::text = v_plan_node.node_id::text;

CREATE OR REPLACE VIEW v_plan_result_node
AS SELECT plan_rec_result_node.node_id,
    plan_rec_result_node.nodecat_id,
    plan_rec_result_node.node_type::text,
    plan_rec_result_node.top_elev,
    plan_rec_result_node.elev,
    plan_rec_result_node.epa_type,
    plan_rec_result_node.state,
    plan_rec_result_node.sector_id,
    plan_rec_result_node.expl_id,
    plan_rec_result_node.cost_unit,
    plan_rec_result_node.descript,
    plan_rec_result_node.measurement,
    plan_rec_result_node.cost,
    plan_rec_result_node.budget,
    plan_rec_result_node.the_geom,
    plan_rec_result_node.builtcost,
    plan_rec_result_node.builtdate,
    plan_rec_result_node.age,
    plan_rec_result_node.acoeff,
    plan_rec_result_node.aperiod,
    plan_rec_result_node.arate,
    plan_rec_result_node.amortized,
    plan_rec_result_node.pending
   FROM selector_expl,
    selector_plan_result,
    plan_rec_result_node
  WHERE plan_rec_result_node.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text AND plan_rec_result_node.result_id::text = selector_plan_result.result_id::text AND selector_plan_result.cur_user = "current_user"()::text AND plan_rec_result_node.state = 1
UNION
 SELECT v_plan_node.node_id,
    v_plan_node.nodecat_id,
    v_plan_node.node_type::text,
    v_plan_node.top_elev,
    v_plan_node.elev,
    v_plan_node.epa_type,
    v_plan_node.state,
    v_plan_node.sector_id,
    v_plan_node.expl_id,
    v_plan_node.cost_unit,
    v_plan_node.descript,
    v_plan_node.measurement,
    v_plan_node.cost,
    v_plan_node.budget,
    v_plan_node.the_geom,
    NULL::double precision AS builtcost,
    NULL::timestamp without time zone AS builtdate,
    NULL::double precision AS age,
    NULL::double precision AS acoeff,
    NULL::text AS aperiod,
    NULL::double precision AS arate,
    NULL::double precision AS amortized,
    NULL::double precision AS pending
   FROM v_plan_node
  WHERE v_plan_node.state = 2;

CREATE OR REPLACE VIEW v_plan_psector_budget_node
AS SELECT row_number() OVER (ORDER BY v_plan_node.node_id) AS rid,
    plan_psector_x_node.psector_id,
    plan_psector.psector_type,
    v_plan_node.node_id,
    v_plan_node.nodecat_id,
    v_plan_node.cost::numeric(12,2) AS cost,
    v_plan_node.measurement,
    v_plan_node.budget AS total_budget,
    v_plan_node.state,
    v_plan_node.expl_id,
    plan_psector.atlas_id,
    plan_psector_x_node.doable,
    plan_psector.priority,
    v_plan_node.the_geom
   FROM v_plan_node
     JOIN plan_psector_x_node ON plan_psector_x_node.node_id::text = v_plan_node.node_id::text
     JOIN plan_psector ON plan_psector.psector_id = plan_psector_x_node.psector_id
  WHERE plan_psector_x_node.doable = true
  ORDER BY plan_psector_x_node.psector_id;

CREATE OR REPLACE VIEW v_edit_inp_outfall
AS SELECT v_edit_node.node_id,
    v_edit_node.top_elev,
    v_edit_node.custom_top_elev,
    v_edit_node.ymax,
    v_edit_node.custom_ymax,
    v_edit_node.elev,
    v_edit_node.custom_elev,
    v_edit_node.sys_elev,
    v_edit_node.nodecat_id,
    v_edit_node.sector_id,
    v_edit_node.macrosector_id,
    v_edit_node.state,
    v_edit_node.state_type,
    v_edit_node.annotation,
    v_edit_node.expl_id,
    inp_outfall.outfall_type,
    inp_outfall.stage,
    inp_outfall.curve_id,
    inp_outfall.timser_id,
    inp_outfall.gate,
    inp_outfall.route_to,
    v_edit_node.the_geom
    FROM v_edit_node
    JOIN inp_outfall USING (node_id)
	WHERE v_edit_node.is_operative IS TRUE;

CREATE OR REPLACE VIEW v_edit_inp_storage
AS SELECT v_edit_node.node_id,
    v_edit_node.top_elev,
    v_edit_node.custom_top_elev,
    v_edit_node.ymax,
    v_edit_node.custom_ymax,
    v_edit_node.elev,
    v_edit_node.custom_elev,
    v_edit_node.sys_elev,
    v_edit_node.nodecat_id,
    v_edit_node.sector_id,
    v_edit_node.macrosector_id,
    v_edit_node.state,
    v_edit_node.state_type,
    v_edit_node.annotation,
    v_edit_node.expl_id,
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
    v_edit_node.the_geom
    FROM v_edit_node
    JOIN inp_storage USING (node_id)
    WHERE v_edit_node.is_operative IS TRUE;

CREATE OR REPLACE VIEW v_edit_inp_netgully
AS SELECT n.node_id,
    n.code,
    n.top_elev,
    n.custom_top_elev,
    n.ymax,
    n.custom_ymax,
    n.elev,
    n.custom_elev,
    n.sys_elev,
    n.node_type::text,
    n.nodecat_id,
    man_netgully.gullycat_id,
    (cat_gully.width / 100::numeric)::numeric(12,3) AS grate_width,
    (cat_gully.length / 100::numeric)::numeric(12,3) AS grate_length,
    n.sector_id,
    n.macrosector_id,
    n.expl_id,
    n.state,
    n.state_type,
    n.the_geom,
    man_netgully.units,
    man_netgully.units_placement,
    man_netgully.groove,
    man_netgully.groove_height,
    man_netgully.groove_length,
    cat_gully.a_param,
    cat_gully.b_param,
        CASE
            WHEN man_netgully.units_placement::text = 'LENGTH-SIDE'::text THEN (COALESCE(man_netgully.units::integer, 1)::numeric * cat_gully.width / 100::numeric)::numeric(12,3)
            WHEN man_netgully.units_placement::text = 'WIDTH-SIDE'::text THEN (COALESCE(man_netgully.units::integer, 1)::numeric * cat_gully.length / 100::numeric)::numeric(12,3)
            ELSE (cat_gully.width / 100::numeric)::numeric(12,3)
        END AS total_width,
        CASE
            WHEN man_netgully.units_placement::text = 'LENGTH-SIDE'::text THEN (COALESCE(man_netgully.units::integer, 1)::numeric * cat_gully.width / 100::numeric)::numeric(12,3)
            WHEN man_netgully.units_placement::text = 'WIDTH-SIDE'::text THEN (COALESCE(man_netgully.units::integer, 1)::numeric * cat_gully.length / 100::numeric)::numeric(12,3)
            ELSE (cat_gully.length / 100::numeric)::numeric(12,3)
        END AS total_length,
    n.ymax - COALESCE(man_netgully.sander_depth, 0::numeric) AS depth,
    n.annotation,
    i.y0,
    i.ysur,
    i.apond,
    i.outlet_type,
    i.custom_width,
    i.custom_length,
    i.custom_depth,
    i.method,
    i.weir_cd,
    i.orifice_cd,
    i.custom_a_param,
    i.custom_b_param,
    i.efficiency
    FROM v_edit_node n
    JOIN inp_netgully i USING (node_id)
    LEFT JOIN man_netgully USING (node_id)
    LEFT JOIN cat_gully ON man_netgully.gullycat_id::text = cat_gully.id::text
    WHERE n.is_operative IS TRUE;


CREATE OR REPLACE VIEW v_edit_inp_divider
AS SELECT v_edit_node.node_id,
    v_edit_node.top_elev,
    v_edit_node.custom_top_elev,
    v_edit_node.ymax,
    v_edit_node.custom_ymax,
    v_edit_node.elev,
    v_edit_node.custom_elev,
    v_edit_node.sys_elev,
    v_edit_node.nodecat_id,
    v_edit_node.sector_id,
    v_edit_node.macrosector_id,
    v_edit_node.state,
    v_edit_node.state_type,
    v_edit_node.annotation,
    v_edit_node.expl_id,
    inp_divider.divider_type,
    inp_divider.arc_id,
    inp_divider.curve_id,
    inp_divider.qmin,
    inp_divider.ht,
    inp_divider.cd,
    inp_divider.y0,
    inp_divider.ysur,
    inp_divider.apond,
    v_edit_node.the_geom
    FROM v_edit_node
    JOIN inp_divider ON v_edit_node.node_id::text = inp_divider.node_id::text
	WHERE is_operative = TRUE;

CREATE OR REPLACE VIEW v_edit_inp_dscenario_storage
AS SELECT s.dscenario_id,
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
    v_edit_inp_storage.the_geom
    FROM selector_inp_dscenario s, inp_dscenario_storage f
    JOIN v_edit_inp_storage USING (node_id)
	WHERE s.dscenario_id = f.dscenario_id AND s.cur_user = CURRENT_USER;

CREATE OR REPLACE VIEW v_edit_inp_dscenario_outfall
AS SELECT s.dscenario_id,
    f.node_id,
    f.elev,
    f.ymax,
    f.outfall_type,
    f.stage,
    f.curve_id,
    f.timser_id,
    f.gate,
    f.route_to,
    v_edit_inp_outfall.the_geom
    FROM selector_inp_dscenario s,
    inp_dscenario_outfall f
    JOIN v_edit_inp_outfall USING (node_id)
    WHERE s.dscenario_id = f.dscenario_id AND s.cur_user = CURRENT_USER;


CREATE OR REPLACE VIEW v_edit_inp_junction
AS SELECT n.node_id,
    n.top_elev,
    n.custom_top_elev,
    n.ymax,
    n.custom_ymax,
    n.elev,
    n.custom_elev,
    n.sys_elev,
    n.nodecat_id,
    n.sector_id,
    n.macrosector_id,
    n.state,
    n.state_type,
    n.annotation,
    n.expl_id,
    inp_junction.y0,
    inp_junction.ysur,
    inp_junction.apond,
    inp_junction.outfallparam::text AS outfallparam,
    n.the_geom
    FROM v_edit_node n
    JOIN inp_junction USING (node_id)
	WHERE n.is_operative IS TRUE;

CREATE OR REPLACE VIEW v_edit_inp_treatment
AS SELECT node_id,
    inp_treatment.poll_id,
    inp_treatment.function
   FROM inp_treatment
     JOIN v_edit_inp_junction USING (node_id);

CREATE OR REPLACE VIEW v_edit_inp_inflows_poll
AS SELECT node_id,
    inp_inflows_poll.poll_id,
    inp_inflows_poll.timser_id,
    inp_inflows_poll.form_type,
    inp_inflows_poll.mfactor,
    inp_inflows_poll.sfactor,
    inp_inflows_poll.base,
    inp_inflows_poll.pattern_id
   FROM inp_inflows_poll
     JOIN v_edit_inp_junction USING (node_id);

CREATE OR REPLACE VIEW v_edit_inp_inflows
AS SELECT node_id,
    inp_inflows.order_id,
    inp_inflows.timser_id,
    inp_inflows.sfactor,
    inp_inflows.base,
    inp_inflows.pattern_id
    FROM inp_inflows
    JOIN v_edit_inp_junction USING (node_id);

CREATE OR REPLACE VIEW v_edit_inp_dwf
AS SELECT i.dwfscenario_id,
    node_id,
    i.value,
    i.pat1,
    i.pat2,
    i.pat3,
    i.pat4
    FROM config_param_user c,  inp_dwf i
    JOIN v_edit_inp_junction USING (node_id)
    WHERE c.cur_user::name = CURRENT_USER AND c.parameter::text = 'inp_options_dwfscenario'::text
    AND c.value::integer = i.dwfscenario_id;

CREATE OR REPLACE VIEW v_edit_inp_dscenario_treatment
AS SELECT s.dscenario_id,
    node_id,
    f.poll_id,
    f.function
    FROM selector_inp_dscenario s,  inp_dscenario_treatment f
    JOIN v_edit_inp_junction USING (node_id)
    WHERE s.dscenario_id = f.dscenario_id AND s.cur_user = CURRENT_USER;

CREATE OR REPLACE VIEW v_edit_inp_dscenario_junction
AS SELECT f.dscenario_id,
    node_id,
    f.elev,
    f.ymax,
    f.y0,
    f.ysur,
    f.apond,
    f.outfallparam,
    v_edit_inp_junction.the_geom
    FROM selector_inp_dscenario s, inp_dscenario_junction f
    JOIN v_edit_inp_junction USING (node_id)
    WHERE s.dscenario_id = f.dscenario_id AND s.cur_user = CURRENT_USER;


CREATE OR REPLACE VIEW v_edit_inp_dscenario_inflows_poll
AS SELECT s.dscenario_id,
    node_id,
    f.poll_id,
    f.timser_id,
    f.form_type,
    f.mfactor,
    f.sfactor,
    f.base,
    f.pattern_id
    FROM selector_inp_dscenario s, inp_dscenario_inflows_poll f
    JOIN v_edit_inp_junction USING (node_id)
    WHERE s.dscenario_id = f.dscenario_id AND s.cur_user = CURRENT_USER;

CREATE OR REPLACE VIEW v_edit_inp_dscenario_inflows
AS SELECT s.dscenario_id,
    node_id,
    f.order_id,
    f.timser_id,
    f.sfactor,
    f.base,
    f.pattern_id
    FROM selector_inp_dscenario s,
    inp_dscenario_inflows f
    JOIN v_edit_inp_junction USING (node_id)
    WHERE s.dscenario_id = f.dscenario_id AND s.cur_user = CURRENT_USER;


CREATE OR REPLACE VIEW v_edit_inp_froutlet
AS SELECT
    f.element_id,
    f.node_id,
    f.order_id,
	f.nodarc_id,
    f.to_arc,
    f.flwreg_length,
    ou.outlet_type,
    ou.offsetval,
    ou.curve_id,
    ou.cd1,
    ou.cd2,
    ou.flap,
    f.the_geom
    FROM ve_frelem f
    JOIN inp_froutlet ou USING (element_id);

CREATE OR REPLACE VIEW v_edit_inp_frweir
AS SELECT
    f.element_id,
    f.node_id,
    f.order_id,
	f.nodarc_id,
    f.to_arc,
    f.flwreg_length,
    w.weir_type,
    w.offsetval,
    w.cd,
    w.ec,
    w.cd2,
    w.flap,
    w.geom1,
    w.geom2,
    w.geom3,
    w.geom4,
    w.surcharge,
    w.road_width,
    w.road_surf,
    w.coef_curve,
    f.the_geom
    FROM ve_frelem f
    JOIN inp_frweir w USING (element_id);


CREATE OR REPLACE VIEW v_edit_inp_frpump
AS SELECT
    f.element_id,
    f.node_id,
    f.order_id,
	f.nodarc_id,
    f.to_arc,
    f.flwreg_length,
    p.curve_id,
    p.status,
    p.startup,
    p.shutoff,
    f.the_geom
    FROM ve_frelem f
    JOIN inp_frpump p USING (element_id);

CREATE OR REPLACE VIEW v_edit_inp_frorifice
AS SELECT
    f.element_id,
    f.node_id,
    f.order_id,
	f.nodarc_id,
    f.to_arc,
    f.flwreg_length,
    ori.orifice_type,
    ori.offsetval,
    ori.cd,
    ori.orate,
    ori.flap,
    ori.shape,
    ori.geom1,
    ori.geom2,
    ori.geom3,
    ori.geom4,
    f.the_geom
    FROM ve_frelem f
    JOIN inp_frorifice ori USING (element_id);

CREATE OR REPLACE VIEW v_edit_inp_frpump
AS SELECT
    f.element_id,
    f.node_id,
    f.order_id,
	f.nodarc_id,
    f.to_arc,
    f.flwreg_length,
    p.curve_id,
    p.status,
    p.startup,
    p.shutoff,
    f.the_geom
    FROM ve_frelem f
    JOIN inp_frpump p ON f.element_id::text = p.element_id::text;


CREATE OR REPLACE VIEW v_edit_inp_dscenario_frpump
AS SELECT s.dscenario_id,
    f.element_id,
    f.curve_id,
    f.status,
    f.startup,
    f.shutoff,
    n.the_geom
    FROM selector_inp_dscenario s, inp_dscenario_frpump f
    JOIN v_edit_inp_frpump n USING (element_id)
    WHERE s.dscenario_id = f.dscenario_id AND s.cur_user = CURRENT_USER::text;


CREATE OR REPLACE VIEW v_edit_inp_dscenario_froutlet
AS SELECT
    s.dscenario_id,
    f.element_id,
    n.node_id,
    f.outlet_type,
    f.offsetval,
    f.curve_id,
    f.cd1,
    f.cd2,
    f.flap,
    n.the_geom
    FROM selector_inp_dscenario s, inp_dscenario_froutlet f
    JOIN v_edit_inp_froutlet n USING (element_id)
	WHERE s.dscenario_id = f.dscenario_id AND s.cur_user = CURRENT_USER::text;

CREATE OR REPLACE VIEW v_edit_inp_dscenario_frweir
AS SELECT
    s.dscenario_id,
    f.element_id,
    n.node_id,
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
    n.the_geom
    FROM selector_inp_dscenario s, inp_dscenario_frweir f
    JOIN v_edit_inp_frweir n USING (element_id)
	WHERE s.dscenario_id = f.dscenario_id AND s.cur_user = CURRENT_USER::text;

CREATE OR REPLACE VIEW v_edit_inp_dscenario_frpump
AS SELECT
    s.dscenario_id,
    f.element_id,
    f.curve_id,
    -- n.node_id,
    f.status,
    f.startup,
    f.shutoff,
    n.the_geom
    FROM selector_inp_dscenario s, inp_dscenario_frpump f
    JOIN v_edit_inp_frpump n USING (element_id)
    WHERE s.dscenario_id = f.dscenario_id AND s.cur_user = CURRENT_USER::text;

CREATE OR REPLACE VIEW v_edit_inp_dscenario_frorifice
AS SELECT
    s.dscenario_id,
    f.element_id,
    n.node_id,
    f.orifice_type,
    f.offsetval,
    f.cd,
    f.orate,
    f.flap,
    f.shape,
    f.geom1,
    f.geom2,
    f.geom3,
    f.geom4,
    n.the_geom
    FROM selector_inp_dscenario s, inp_dscenario_frorifice f
    JOIN v_edit_inp_frorifice n USING (element_id)
    WHERE s.dscenario_id = f.dscenario_id AND s.cur_user = CURRENT_USER::text;


CREATE OR REPLACE VIEW v_edit_inp_orifice
AS SELECT v_edit_arc.arc_id,
    v_edit_arc.node_1,
    v_edit_arc.node_2,
    v_edit_arc.y1,
    v_edit_arc.custom_y1,
    v_edit_arc.elev1,
    v_edit_arc.custom_elev1,
    v_edit_arc.sys_elev1,
    v_edit_arc.y2,
    v_edit_arc.custom_y2,
    v_edit_arc.elev2,
    v_edit_arc.custom_elev2,
    v_edit_arc.sys_elev2,
    v_edit_arc.arccat_id,
    v_edit_arc.gis_length,
    v_edit_arc.sector_id,
    v_edit_arc.macrosector_id,
    v_edit_arc.state,
    v_edit_arc.state_type,
    v_edit_arc.annotation,
    v_edit_arc.inverted_slope,
    v_edit_arc.custom_length,
    v_edit_arc.expl_id,
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
    v_edit_arc.the_geom
    FROM v_edit_arc
    JOIN inp_orifice USING (arc_id)
    WHERE is_operative IS TRUE;

CREATE OR REPLACE VIEW v_edit_inp_outlet
AS SELECT v_edit_arc.arc_id,
    v_edit_arc.node_1,
    v_edit_arc.node_2,
    v_edit_arc.y1,
    v_edit_arc.custom_y1,
    v_edit_arc.elev1,
    v_edit_arc.custom_elev1,
    v_edit_arc.sys_elev1,
    v_edit_arc.y2,
    v_edit_arc.custom_y2,
    v_edit_arc.elev2,
    v_edit_arc.custom_elev2,
    v_edit_arc.sys_elev2,
    v_edit_arc.arccat_id,
    v_edit_arc.gis_length,
    v_edit_arc.sector_id,
    v_edit_arc.macrosector_id,
    v_edit_arc.state,
    v_edit_arc.state_type,
    v_edit_arc.annotation,
    v_edit_arc.inverted_slope,
    v_edit_arc.custom_length,
    v_edit_arc.expl_id,
    inp_outlet.outlet_type,
    inp_outlet.offsetval,
    inp_outlet.curve_id,
    inp_outlet.cd1,
    inp_outlet.cd2,
    inp_outlet.flap,
    v_edit_arc.the_geom
    FROM v_edit_arc
    JOIN inp_outlet USING (arc_id)
	WHERE is_operative IS TRUE;

CREATE OR REPLACE VIEW v_edit_inp_pump
AS SELECT v_edit_arc.arc_id,
    v_edit_arc.node_1,
    v_edit_arc.node_2,
    v_edit_arc.y1,
    v_edit_arc.custom_y1,
    v_edit_arc.elev1,
    v_edit_arc.custom_elev1,
    v_edit_arc.sys_elev1,
    v_edit_arc.y2,
    v_edit_arc.custom_y2,
    v_edit_arc.elev2,
    v_edit_arc.custom_elev2,
    v_edit_arc.sys_elev2,
    v_edit_arc.arccat_id,
    v_edit_arc.gis_length,
    v_edit_arc.sector_id,
    v_edit_arc.macrosector_id,
    v_edit_arc.state,
    v_edit_arc.state_type,
    v_edit_arc.annotation,
    v_edit_arc.inverted_slope,
    v_edit_arc.custom_length,
    v_edit_arc.expl_id,
    inp_pump.curve_id,
    inp_pump.status,
    inp_pump.startup,
    inp_pump.shutoff,
    v_edit_arc.the_geom
    FROM v_edit_arc
    JOIN inp_pump USING (arc_id)
    WHERE is_operative IS TRUE;

CREATE OR REPLACE VIEW v_edit_inp_virtual
AS SELECT v_edit_arc.arc_id,
    v_edit_arc.node_1,
    v_edit_arc.node_2,
    v_edit_arc.arccat_id,
    v_edit_arc.gis_length,
    v_edit_arc.sector_id,
    v_edit_arc.macrosector_id,
    v_edit_arc.state,
    v_edit_arc.state_type,
    v_edit_arc.expl_id,
    inp_virtual.fusion_node,
    inp_virtual.add_length,
    v_edit_arc.the_geom
    FROM v_edit_arc
    JOIN inp_virtual USING (arc_id)
    WHERE is_operative IS TRUE;

CREATE OR REPLACE VIEW v_edit_inp_weir
AS SELECT v_edit_arc.arc_id,
    v_edit_arc.node_1,
    v_edit_arc.node_2,
    v_edit_arc.y1,
    v_edit_arc.custom_y1,
    v_edit_arc.elev1,
    v_edit_arc.custom_elev1,
    v_edit_arc.sys_elev1,
    v_edit_arc.y2,
    v_edit_arc.custom_y2,
    v_edit_arc.elev2,
    v_edit_arc.custom_elev2,
    v_edit_arc.sys_elev2,
    v_edit_arc.arccat_id,
    v_edit_arc.gis_length,
    v_edit_arc.sector_id,
    v_edit_arc.macrosector_id,
    v_edit_arc.state,
    v_edit_arc.state_type,
    v_edit_arc.annotation,
    v_edit_arc.inverted_slope,
    v_edit_arc.custom_length,
    v_edit_arc.expl_id,
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
    v_edit_arc.the_geom,
    inp_weir.road_width,
    inp_weir.road_surf,
    inp_weir.coef_curve
    FROM v_edit_arc
    JOIN inp_weir USING (arc_id)
	WHERE is_operative IS TRUE;


CREATE OR REPLACE VIEW v_ui_workcat_x_feature
AS SELECT row_number() OVER (ORDER BY arc.arc_id) + 1000000 AS rid,
    arc.feature_type,
    arc.arccat_id AS featurecat_id,
    arc.arc_id AS feature_id,
    arc.code,
    exploitation.name AS expl_name,
    arc.workcat_id,
    exploitation.expl_id
   FROM arc
     JOIN exploitation ON exploitation.expl_id = arc.expl_id
  WHERE arc.state = 1
UNION
 SELECT row_number() OVER (ORDER BY node.node_id) + 2000000 AS rid,
    node.feature_type,
    node.nodecat_id AS featurecat_id,
    node.node_id AS feature_id,
    node.code,
    exploitation.name AS expl_name,
    node.workcat_id,
    exploitation.expl_id
   FROM node
     JOIN exploitation ON exploitation.expl_id = node.expl_id
  WHERE node.state = 1
UNION
 SELECT row_number() OVER (ORDER BY connec.connec_id) + 3000000 AS rid,
    connec.feature_type,
    connec.conneccat_id AS featurecat_id,
    connec.connec_id AS feature_id,
    connec.code,
    exploitation.name AS expl_name,
    connec.workcat_id,
    exploitation.expl_id
   FROM connec
     JOIN exploitation ON exploitation.expl_id = connec.expl_id
  WHERE connec.state = 1
UNION
 SELECT row_number() OVER (ORDER BY gully.gully_id) + 4000000 AS rid,
    gully.feature_type,
    gully.gullycat_id AS featurecat_id,
    gully.gully_id AS feature_id,
    gully.code,
    exploitation.name AS expl_name,
    gully.workcat_id,
    exploitation.expl_id
   FROM gully
     JOIN exploitation ON exploitation.expl_id = gully.expl_id
  WHERE gully.state = 1
UNION
 SELECT row_number() OVER (ORDER BY element.element_id) + 5000000 AS rid,
    element.feature_type,
    element.elementcat_id AS featurecat_id,
    element.element_id AS feature_id,
    element.code,
    exploitation.name AS expl_name,
    element.workcat_id,
    exploitation.expl_id
   FROM element
     JOIN exploitation ON exploitation.expl_id = element.expl_id
  WHERE element.state = 1;

CREATE OR REPLACE VIEW v_ui_workcat_x_feature_end
AS SELECT row_number() OVER (ORDER BY v_edit_arc.arc_id) + 1000000 AS rid,
    'ARC'::character varying AS feature_type,
    v_edit_arc.arccat_id AS featurecat_id,
    v_edit_arc.arc_id AS feature_id,
    v_edit_arc.code,
    exploitation.name AS expl_name,
    v_edit_arc.workcat_id_end AS workcat_id,
    exploitation.expl_id
   FROM v_edit_arc
     JOIN exploitation ON exploitation.expl_id = v_edit_arc.expl_id
  WHERE v_edit_arc.state = 0
UNION
 SELECT row_number() OVER (ORDER BY v_edit_node.node_id) + 2000000 AS rid,
    'NODE'::character varying AS feature_type,
    v_edit_node.nodecat_id AS featurecat_id,
    v_edit_node.node_id AS feature_id,
    v_edit_node.code,
    exploitation.name AS expl_name,
    v_edit_node.workcat_id_end AS workcat_id,
    exploitation.expl_id
   FROM v_edit_node
     JOIN exploitation ON exploitation.expl_id = v_edit_node.expl_id
  WHERE v_edit_node.state = 0
UNION
 SELECT row_number() OVER (ORDER BY v_edit_connec.connec_id) + 3000000 AS rid,
    'CONNEC'::character varying AS feature_type,
    v_edit_connec.conneccat_id AS featurecat_id,
    v_edit_connec.connec_id AS feature_id,
    v_edit_connec.code,
    exploitation.name AS expl_name,
    v_edit_connec.workcat_id_end AS workcat_id,
    exploitation.expl_id
   FROM v_edit_connec
     JOIN exploitation ON exploitation.expl_id = v_edit_connec.expl_id
  WHERE v_edit_connec.state = 0
UNION
 SELECT row_number() OVER (ORDER BY element.element_id) + 4000000 AS rid,
    'ELEMENT'::character varying AS feature_type,
    element.elementcat_id AS featurecat_id,
    element.element_id AS feature_id,
    element.code,
    exploitation.name AS expl_name,
    element.workcat_id_end AS workcat_id,
    exploitation.expl_id
   FROM element
     JOIN exploitation ON exploitation.expl_id = element.expl_id
  WHERE element.state = 0
UNION
 SELECT row_number() OVER (ORDER BY v_edit_gully.gully_id) + 4000000 AS rid,
    'GULLY'::character varying AS feature_type,
    v_edit_gully.gullycat_id AS featurecat_id,
    v_edit_gully.gully_id AS feature_id,
    v_edit_gully.code,
    exploitation.name AS expl_name,
    v_edit_gully.workcat_id_end AS workcat_id,
    exploitation.expl_id
   FROM v_edit_gully
     JOIN exploitation ON exploitation.expl_id = v_edit_gully.expl_id
  WHERE v_edit_gully.state = 0;

CREATE OR REPLACE VIEW v_ui_node_x_connection_downstream
AS SELECT row_number() OVER (ORDER BY v_edit_arc.node_1) + 1000000 AS rid,
    v_edit_arc.node_1 AS node_id,
    v_edit_arc.arc_id AS feature_id,
    v_edit_arc.code AS feature_code,
    v_edit_arc.arc_type::text AS featurecat_id,
    v_edit_arc.arccat_id,
    v_edit_arc.y2 AS depth,
    st_length2d(v_edit_arc.the_geom)::numeric(12,2) AS length,
    node.node_id AS downstream_id,
    node.code AS downstream_code,
    node.node_type::text AS downstream_type,
    v_edit_arc.y1 AS downstream_depth,
    v_edit_arc.sys_type,
    st_x(st_lineinterpolatepoint(v_edit_arc.the_geom, 0.5::double precision)) AS x,
    st_y(st_lineinterpolatepoint(v_edit_arc.the_geom, 0.5::double precision)) AS y,
    cat_arc.descript,
    value_state.name AS state,
    'v_edit_arc'::text AS sys_table_id
   FROM v_edit_arc
     JOIN node ON v_edit_arc.node_2::text = node.node_id::text
     LEFT JOIN cat_arc ON v_edit_arc.arccat_id::text = cat_arc.id::text
     JOIN value_state ON v_edit_arc.state = value_state.id;

CREATE OR REPLACE VIEW v_ui_node_x_connection_upstream
AS SELECT row_number() OVER (ORDER BY v_edit_arc.node_2) + 1000000 AS rid,
    v_edit_arc.node_2 AS node_id,
    v_edit_arc.arc_id AS feature_id,
    v_edit_arc.code AS feature_code,
    v_edit_arc.arc_type::text AS featurecat_id,
    v_edit_arc.arccat_id,
    v_edit_arc.y1 AS depth,
    st_length2d(v_edit_arc.the_geom)::numeric(12,2) AS length,
    node.node_id AS upstream_id,
    node.code AS upstream_code,
    node.node_type AS upstream_type,
    v_edit_arc.y2 AS upstream_depth,
    v_edit_arc.sys_type,
    st_x(st_lineinterpolatepoint(v_edit_arc.the_geom, 0.5::double precision)) AS x,
    st_y(st_lineinterpolatepoint(v_edit_arc.the_geom, 0.5::double precision)) AS y,
    cat_arc.descript,
    value_state.name AS state,
    'v_edit_arc'::text AS sys_table_id
   FROM v_edit_arc
     JOIN node ON v_edit_arc.node_1::text = node.node_id::text
     LEFT JOIN cat_arc ON v_edit_arc.arccat_id::text = cat_arc.id::text
     JOIN value_state ON v_edit_arc.state = value_state.id
UNION
 SELECT DISTINCT ON (v_edit_connec.connec_id) row_number() OVER (ORDER BY node.node_id) + 2000000 AS rid,
    node.node_id,
    v_edit_connec.connec_id AS feature_id,
    v_edit_connec.code::text AS feature_code,
    v_edit_connec.connec_type::text AS featurecat_id,
    v_edit_connec.conneccat_id AS arccat_id,
    v_edit_connec.y1 AS depth,
    st_length2d(link.the_geom)::numeric(12,2) AS length,
    v_edit_connec.connec_id AS upstream_id,
    v_edit_connec.code AS upstream_code,
    v_edit_connec.connec_type::text AS upstream_type,
    v_edit_connec.y2 AS upstream_depth,
    v_edit_connec.sys_type,
    st_x(v_edit_connec.the_geom) AS x,
    st_y(v_edit_connec.the_geom) AS y,
    cat_connec.descript,
    value_state.name AS state,
    'v_edit_connec'::text AS sys_table_id
   FROM v_edit_connec
     JOIN link ON link.feature_id::text = v_edit_connec.connec_id::text AND link.feature_type::text = 'CONNEC'::text
     JOIN node ON v_edit_connec.pjoint_id::text = node.node_id::text AND v_edit_connec.pjoint_type::text = 'NODE'::text
     LEFT JOIN cat_connec ON v_edit_connec.conneccat_id::text = cat_connec.id::text
     JOIN value_state ON v_edit_connec.state = value_state.id
UNION
 SELECT DISTINCT ON (v_edit_connec.connec_id) row_number() OVER (ORDER BY node.node_id) + 3000000 AS rid,
    node.node_id,
    v_edit_connec.connec_id AS feature_id,
    v_edit_connec.code::text AS feature_code,
    v_edit_connec.connec_type::text AS featurecat_id,
    v_edit_connec.conneccat_id AS arccat_id,
    v_edit_connec.y1 AS depth,
    st_length2d(link.the_geom)::numeric(12,2) AS length,
    v_edit_connec.connec_id AS upstream_id,
    v_edit_connec.code AS upstream_code,
    v_edit_connec.connec_type::text AS upstream_type,
    v_edit_connec.y2 AS upstream_depth,
    v_edit_connec.sys_type,
    st_x(v_edit_connec.the_geom) AS x,
    st_y(v_edit_connec.the_geom) AS y,
    cat_connec.descript,
    value_state.name AS state,
    'v_edit_connec'::text AS sys_table_id
   FROM v_edit_connec
     JOIN link ON link.feature_id::text = v_edit_connec.connec_id::text AND link.feature_type::text = 'CONNEC'::text AND link.exit_type::text = 'CONNEC'::text
     JOIN connec ON connec.connec_id::text = link.exit_id::text AND connec.pjoint_type::text = 'NODE'::text
     JOIN node ON connec.pjoint_id::text = node.node_id::text
     LEFT JOIN cat_connec ON v_edit_connec.conneccat_id::text = cat_connec.id::text
     JOIN value_state ON v_edit_connec.state = value_state.id
UNION
 SELECT DISTINCT ON (v_edit_gully.gully_id) row_number() OVER (ORDER BY node.node_id) + 4000000 AS rid,
    node.node_id,
    v_edit_gully.gully_id AS feature_id,
    v_edit_gully.code::text AS feature_code,
    v_edit_gully.gully_type AS featurecat_id,
    v_edit_gully.connec_arccat_id AS arccat_id,
    v_edit_gully.ymax - v_edit_gully.sandbox AS depth,
    v_edit_gully.connec_length AS length,
    v_edit_gully.gully_id AS upstream_id,
    v_edit_gully.code AS upstream_code,
    v_edit_gully.gully_type AS upstream_type,
    v_edit_gully.connec_depth AS upstream_depth,
    v_edit_gully.sys_type,
    st_x(v_edit_gully.the_geom) AS x,
    st_y(v_edit_gully.the_geom) AS y,
    cat_connec.descript,
    value_state.name AS state,
    'v_edit_gully'::text AS sys_table_id
   FROM v_edit_gully
     JOIN link ON link.feature_id::text = v_edit_gully.gully_id::text AND link.feature_type::text = 'GULLY'::text
     JOIN node ON v_edit_gully.pjoint_id::text = node.node_id::text AND v_edit_gully.pjoint_type::text = 'NODE'::text
     LEFT JOIN cat_connec ON v_edit_gully.connec_arccat_id::text = cat_connec.id::text
     JOIN value_state ON v_edit_gully.state = value_state.id
UNION
 SELECT DISTINCT ON (v_edit_gully.gully_id) row_number() OVER (ORDER BY node.node_id) + 5000000 AS rid,
    node.node_id,
    v_edit_gully.gully_id AS feature_id,
    v_edit_gully.code::text AS feature_code,
    v_edit_gully.gully_type AS featurecat_id,
    v_edit_gully.connec_arccat_id AS arccat_id,
    v_edit_gully.ymax - v_edit_gully.sandbox AS depth,
    v_edit_gully.connec_length AS length,
    v_edit_gully.gully_id AS upstream_id,
    v_edit_gully.code AS upstream_code,
    v_edit_gully.gully_type AS upstream_type,
    v_edit_gully.connec_depth AS upstream_depth,
    v_edit_gully.sys_type,
    st_x(v_edit_gully.the_geom) AS x,
    st_y(v_edit_gully.the_geom) AS y,
    cat_connec.descript,
    value_state.name AS state,
    'v_edit_gully'::text AS sys_table_id
   FROM v_edit_gully
     JOIN link ON link.feature_id::text = v_edit_gully.gully_id::text AND link.feature_type::text = 'GULLY'::text AND link.exit_type::text = 'GULLY'::text
     JOIN gully ON gully.gully_id::text = link.exit_id::text AND gully.pjoint_type::text = 'NODE'::text
     JOIN node ON gully.pjoint_id::text = node.node_id::text
     LEFT JOIN cat_connec ON v_edit_gully.connec_arccat_id::text = cat_connec.id::text
     JOIN value_state ON v_edit_gully.state = value_state.id;


CREATE OR REPLACE VIEW v_ui_plan_arc_cost
AS WITH p AS (
         SELECT v_plan_arc.arc_id,
            v_plan_arc.node_1,
            v_plan_arc.node_2,
            v_plan_arc.arc_type::text,
            v_plan_arc.arccat_id,
            v_plan_arc.epa_type,
            v_plan_arc.state,
            v_plan_arc.expl_id,
            v_plan_arc.sector_id,
            v_plan_arc.annotation,
            v_plan_arc.soilcat_id,
            v_plan_arc.y1,
            v_plan_arc.y2,
            v_plan_arc.mean_y,
            v_plan_arc.z1,
            v_plan_arc.z2,
            v_plan_arc.thickness,
            v_plan_arc.width,
            v_plan_arc.b,
            v_plan_arc.bulk,
            v_plan_arc.geom1,
            v_plan_arc.area,
            v_plan_arc.y_param,
            v_plan_arc.total_y,
            v_plan_arc.rec_y,
            v_plan_arc.geom1_ext,
            v_plan_arc.calculed_y,
            v_plan_arc.m3mlexc,
            v_plan_arc.m2mltrenchl,
            v_plan_arc.m2mlbottom,
            v_plan_arc.m2mlpav,
            v_plan_arc.m3mlprotec,
            v_plan_arc.m3mlfill,
            v_plan_arc.m3mlexcess,
            v_plan_arc.m3exc_cost,
            v_plan_arc.m2trenchl_cost,
            v_plan_arc.m2bottom_cost,
            v_plan_arc.m2pav_cost,
            v_plan_arc.m3protec_cost,
            v_plan_arc.m3fill_cost,
            v_plan_arc.m3excess_cost,
            v_plan_arc.cost_unit,
            v_plan_arc.pav_cost,
            v_plan_arc.exc_cost,
            v_plan_arc.trenchl_cost,
            v_plan_arc.base_cost,
            v_plan_arc.protec_cost,
            v_plan_arc.fill_cost,
            v_plan_arc.excess_cost,
            v_plan_arc.arc_cost,
            v_plan_arc.cost,
            v_plan_arc.length,
            v_plan_arc.budget,
            v_plan_arc.other_budget,
            v_plan_arc.total_budget,
            v_plan_arc.the_geom,
            a.id,
            a.matcat_id,
            a.shape,
            a.geom1,
            a.geom2,
            a.geom3,
            a.geom4,
            a.geom5,
            a.geom6,
            a.geom7,
            a.geom8,
            a.geom_r,
            a.descript,
            a.link,
            a.brand_id,
            a.model_id,
            a.svg,
            a.z1,
            a.z2,
            a.width,
            a.area,
            a.estimated_depth,
            a.thickness,
            a.cost_unit,
            a.cost,
            a.m2bottom_cost,
            a.m3protec_cost,
            a.active,
            a.label,
            a.tsect_id,
            a.curve_id,
            a.arc_type::text,
            a.acoeff,
            a.connect_cost,
            s.id,
            s.descript,
            s.link,
            s.y_param,
            s.b,
            s.trenchlining,
            s.m3exc_cost,
            s.m3fill_cost,
            s.m3excess_cost,
            s.m2trenchl_cost,
            s.active,
            a.cost AS cat_cost,
            a.m2bottom_cost AS cat_m2bottom_cost,
            a.connect_cost AS cat_connect_cost,
            a.m3protec_cost AS cat_m3_protec_cost,
            s.m3exc_cost AS cat_m3exc_cost,
            s.m3fill_cost AS cat_m3fill_cost,
            s.m3excess_cost AS cat_m3excess_cost,
            s.m2trenchl_cost AS cat_m2trenchl_cost
           FROM v_plan_arc
             JOIN cat_arc a ON a.id::text = v_plan_arc.arccat_id::text
             JOIN cat_soil s ON s.id::text = v_plan_arc.soilcat_id::text
        )
 SELECT p.arc_id,
    1 AS orderby,
    'element'::text AS identif,
    p.arccat_id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    1 AS measurement,
    1::numeric * v_price_compost.price AS total_cost,
    p.length
   FROM p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, expl_id, sector_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, matcat_id, shape, geom1_1, geom2, geom3, geom4, geom5, geom6, geom7, geom8, geom_r, descript, link, brand_id, model_id, svg, z1_1, z2_1, width_1, area_1, estimated_depth, thickness_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, tsect_id, curve_id, arc_type_1, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
     JOIN v_price_compost ON p.cat_cost::text = v_price_compost.id::text
UNION
 SELECT p.arc_id,
    2 AS orderby,
    'm2bottom'::text AS identif,
    p.arccat_id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    p.m2mlbottom AS measurement,
    p.m2mlbottom * v_price_compost.price AS total_cost,
    p.length
   FROM p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, expl_id, sector_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, matcat_id, shape, geom1_1, geom2, geom3, geom4, geom5, geom6, geom7, geom8, geom_r, descript, link, brand_id, model_id, svg, z1_1, z2_1, width_1, area_1, estimated_depth, thickness_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, tsect_id, curve_id, arc_type_1, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
     JOIN v_price_compost ON p.cat_m2bottom_cost::text = v_price_compost.id::text
UNION
 SELECT p.arc_id,
    3 AS orderby,
    'm3protec'::text AS identif,
    p.arccat_id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    p.m3mlprotec AS measurement,
    p.m3mlprotec * v_price_compost.price AS total_cost,
    p.length
   FROM p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, expl_id, sector_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, matcat_id, shape, geom1_1, geom2, geom3, geom4, geom5, geom6, geom7, geom8, geom_r, descript, link, brand_id, model_id, svg, z1_1, z2_1, width_1, area_1, estimated_depth, thickness_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, tsect_id, curve_id, arc_type_1, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
     JOIN v_price_compost ON p.cat_m3_protec_cost::text = v_price_compost.id::text
UNION
 SELECT p.arc_id,
    4 AS orderby,
    'm3exc'::text AS identif,
    p.soilcat_id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    p.m3mlexc AS measurement,
    p.m3mlexc * v_price_compost.price AS total_cost,
    p.length
   FROM p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, expl_id, sector_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, matcat_id, shape, geom1_1, geom2, geom3, geom4, geom5, geom6, geom7, geom8, geom_r, descript, link, brand_id, model_id, svg, z1_1, z2_1, width_1, area_1, estimated_depth, thickness_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, tsect_id, curve_id, arc_type_1, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
     JOIN v_price_compost ON p.cat_m3exc_cost::text = v_price_compost.id::text
UNION
 SELECT p.arc_id,
    5 AS orderby,
    'm3fill'::text AS identif,
    p.soilcat_id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    p.m3mlfill AS measurement,
    p.m3mlfill * v_price_compost.price AS total_cost,
    p.length
   FROM p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, expl_id, sector_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, matcat_id, shape, geom1_1, geom2, geom3, geom4, geom5, geom6, geom7, geom8, geom_r, descript, link, brand_id, model_id, svg, z1_1, z2_1, width_1, area_1, estimated_depth, thickness_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, tsect_id, curve_id, arc_type_1, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
     JOIN v_price_compost ON p.cat_m3fill_cost::text = v_price_compost.id::text
UNION
 SELECT p.arc_id,
    6 AS orderby,
    'm3excess'::text AS identif,
    p.soilcat_id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    p.m3mlexcess AS measurement,
    p.m3mlexcess * v_price_compost.price AS total_cost,
    p.length
   FROM p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, expl_id, sector_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, matcat_id, shape, geom1_1, geom2, geom3, geom4, geom5, geom6, geom7, geom8, geom_r, descript, link, brand_id, model_id, svg, z1_1, z2_1, width_1, area_1, estimated_depth, thickness_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, tsect_id, curve_id, arc_type_1, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
     JOIN v_price_compost ON p.cat_m3excess_cost::text = v_price_compost.id::text
UNION
 SELECT p.arc_id,
    7 AS orderby,
    'm2trenchl'::text AS identif,
    p.soilcat_id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    p.m2mltrenchl AS measurement,
    p.m2mltrenchl * v_price_compost.price AS total_cost,
    p.length
   FROM p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, expl_id, sector_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, matcat_id, shape, geom1_1, geom2, geom3, geom4, geom5, geom6, geom7, geom8, geom_r, descript, link, brand_id, model_id, svg, z1_1, z2_1, width_1, area_1, estimated_depth, thickness_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, tsect_id, curve_id, arc_type_1, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
     JOIN v_price_compost ON p.cat_m2trenchl_cost::text = v_price_compost.id::text
UNION
 SELECT p.arc_id,
    8 AS orderby,
    'pavement'::text AS identif,
        CASE
            WHEN a.price_id IS NULL THEN 'Various pavements'::character varying
            ELSE a.pavcat_id
        END AS catalog_id,
        CASE
            WHEN a.price_id IS NULL THEN 'Various prices'::character varying
            ELSE a.pavcat_id
        END AS price_id,
    'm2'::character varying AS unit,
        CASE
            WHEN a.price_id IS NULL THEN 'Various prices'::character varying
            ELSE a.pavcat_id
        END AS descript,
    a.m2pav_cost AS cost,
    1 AS measurement,
    a.m2pav_cost AS total_cost,
    p.length
   FROM p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, expl_id, sector_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, matcat_id, shape, geom1_1, geom2, geom3, geom4, geom5, geom6, geom7, geom8, geom_r, descript, link, brand_id, model_id, svg, z1_1, z2_1, width_1, area_1, estimated_depth, thickness_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, tsect_id, curve_id, arc_type_1, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
     JOIN v_plan_aux_arc_pavement a ON a.arc_id::text = p.arc_id::text
     JOIN cat_pavement c ON a.pavcat_id::text = c.id::text
     LEFT JOIN v_price_compost r ON a.price_id::text = c.m2_cost::text
UNION
 SELECT p.arc_id,
    9 AS orderby,
    'connec'::text AS identif,
    'Various connecs'::character varying AS catalog_id,
    'VARIOUS'::character varying AS price_id,
    'PP'::character varying AS unit,
    'Proportional cost of connec connections (pjoint cost)'::character varying AS descript,
    min(v.price) AS cost,
    count(v_edit_connec.connec_id) AS measurement,
    (min(v.price) * count(v_edit_connec.connec_id)::numeric / COALESCE(min(p.length), 1::numeric))::numeric(12,2) AS total_cost,
    min(p.length)::numeric(12,2) AS length
   FROM p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, expl_id, sector_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, matcat_id, shape, geom1_1, geom2, geom3, geom4, geom5, geom6, geom7, geom8, geom_r, descript, link, brand_id, model_id, svg, z1_1, z2_1, width_1, area_1, estimated_depth, thickness_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, tsect_id, curve_id, arc_type_1, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
     JOIN v_edit_connec USING (arc_id)
     JOIN v_price_compost v ON p.cat_connect_cost = v.id::text
  GROUP BY p.arc_id
UNION
 SELECT p.arc_id,
    10 AS orderby,
    'connec'::text AS identif,
    'Various connecs'::character varying AS catalog_id,
    'VARIOUS'::character varying AS price_id,
    'PP'::character varying AS unit,
    'Proportional cost of gully connections (pjoint cost)'::character varying AS descript,
    min(v.price) AS cost,
    count(v_edit_gully.gully_id) AS measurement,
    (min(v.price) * count(v_edit_gully.gully_id)::numeric / COALESCE(min(p.length), 1::numeric))::numeric(12,2) AS total_cost,
    min(p.length)::numeric(12,2) AS length
   FROM p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, expl_id, sector_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, matcat_id, shape, geom1_1, geom2, geom3, geom4, geom5, geom6, geom7, geom8, geom_r, descript, link, brand_id, model_id, svg, z1_1, z2_1, width_1, area_1, estimated_depth, thickness_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, tsect_id, curve_id, arc_type_1, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
     JOIN v_edit_gully USING (arc_id)
     JOIN v_price_compost v ON p.cat_connect_cost = v.id::text
  GROUP BY p.arc_id
  ORDER BY 1, 2;

CREATE OR REPLACE VIEW v_plan_result_arc
AS SELECT plan_rec_result_arc.arc_id,
    plan_rec_result_arc.node_1,
    plan_rec_result_arc.node_2,
    plan_rec_result_arc.arc_type::text,
    plan_rec_result_arc.arccat_id,
    plan_rec_result_arc.epa_type,
    plan_rec_result_arc.state,
    plan_rec_result_arc.sector_id,
    plan_rec_result_arc.expl_id,
    plan_rec_result_arc.annotation,
    plan_rec_result_arc.soilcat_id,
    plan_rec_result_arc.y1,
    plan_rec_result_arc.y2,
    plan_rec_result_arc.mean_y,
    plan_rec_result_arc.z1,
    plan_rec_result_arc.z2,
    plan_rec_result_arc.thickness,
    plan_rec_result_arc.width,
    plan_rec_result_arc.b,
    plan_rec_result_arc.bulk,
    plan_rec_result_arc.geom1,
    plan_rec_result_arc.area,
    plan_rec_result_arc.y_param,
    plan_rec_result_arc.total_y,
    plan_rec_result_arc.rec_y,
    plan_rec_result_arc.geom1_ext,
    plan_rec_result_arc.calculed_y,
    plan_rec_result_arc.m3mlexc,
    plan_rec_result_arc.m2mltrenchl,
    plan_rec_result_arc.m2mlbottom,
    plan_rec_result_arc.m2mlpav,
    plan_rec_result_arc.m3mlprotec,
    plan_rec_result_arc.m3mlfill,
    plan_rec_result_arc.m3mlexcess,
    plan_rec_result_arc.m3exc_cost,
    plan_rec_result_arc.m2trenchl_cost,
    plan_rec_result_arc.m2bottom_cost,
    plan_rec_result_arc.m2pav_cost,
    plan_rec_result_arc.m3protec_cost,
    plan_rec_result_arc.m3fill_cost,
    plan_rec_result_arc.m3excess_cost,
    plan_rec_result_arc.cost_unit,
    plan_rec_result_arc.pav_cost,
    plan_rec_result_arc.exc_cost,
    plan_rec_result_arc.trenchl_cost,
    plan_rec_result_arc.base_cost,
    plan_rec_result_arc.protec_cost,
    plan_rec_result_arc.fill_cost,
    plan_rec_result_arc.excess_cost,
    plan_rec_result_arc.arc_cost,
    plan_rec_result_arc.cost,
    plan_rec_result_arc.length,
    plan_rec_result_arc.budget,
    plan_rec_result_arc.other_budget,
    plan_rec_result_arc.total_budget,
    plan_rec_result_arc.the_geom,
    plan_rec_result_arc.builtcost,
    plan_rec_result_arc.builtdate,
    plan_rec_result_arc.age,
    plan_rec_result_arc.acoeff,
    plan_rec_result_arc.aperiod,
    plan_rec_result_arc.arate,
    plan_rec_result_arc.amortized,
    plan_rec_result_arc.pending
   FROM selector_plan_result,
    plan_rec_result_arc
  WHERE plan_rec_result_arc.result_id::text = selector_plan_result.result_id::text AND selector_plan_result.cur_user = "current_user"()::text AND plan_rec_result_arc.state = 1
UNION
 SELECT v_plan_arc.arc_id,
    v_plan_arc.node_1,
    v_plan_arc.node_2,
    v_plan_arc.arc_type::text,
    v_plan_arc.arccat_id,
    v_plan_arc.epa_type,
    v_plan_arc.state,
    v_plan_arc.sector_id,
    v_plan_arc.expl_id,
    v_plan_arc.annotation,
    v_plan_arc.soilcat_id,
    v_plan_arc.y1,
    v_plan_arc.y2,
    v_plan_arc.mean_y,
    v_plan_arc.z1,
    v_plan_arc.z2,
    v_plan_arc.thickness,
    v_plan_arc.width,
    v_plan_arc.b,
    v_plan_arc.bulk,
    v_plan_arc.geom1,
    v_plan_arc.area,
    v_plan_arc.y_param,
    v_plan_arc.total_y,
    v_plan_arc.rec_y,
    v_plan_arc.geom1_ext,
    v_plan_arc.calculed_y,
    v_plan_arc.m3mlexc,
    v_plan_arc.m2mltrenchl,
    v_plan_arc.m2mlbottom,
    v_plan_arc.m2mlpav,
    v_plan_arc.m3mlprotec,
    v_plan_arc.m3mlfill,
    v_plan_arc.m3mlexcess,
    v_plan_arc.m3exc_cost,
    v_plan_arc.m2trenchl_cost,
    v_plan_arc.m2bottom_cost,
    v_plan_arc.m2pav_cost,
    v_plan_arc.m3protec_cost,
    v_plan_arc.m3fill_cost,
    v_plan_arc.m3excess_cost,
    v_plan_arc.cost_unit,
    v_plan_arc.pav_cost,
    v_plan_arc.exc_cost,
    v_plan_arc.trenchl_cost,
    v_plan_arc.base_cost,
    v_plan_arc.protec_cost,
    v_plan_arc.fill_cost,
    v_plan_arc.excess_cost,
    v_plan_arc.arc_cost,
    v_plan_arc.cost,
    v_plan_arc.length,
    v_plan_arc.budget,
    v_plan_arc.other_budget,
    v_plan_arc.total_budget,
    v_plan_arc.the_geom,
    NULL::double precision AS builtcost,
    NULL::timestamp without time zone AS builtdate,
    NULL::double precision AS age,
    NULL::double precision AS acoeff,
    NULL::text AS aperiod,
    NULL::double precision AS arate,
    NULL::double precision AS amortized,
    NULL::double precision AS pending
   FROM v_plan_arc
  WHERE v_plan_arc.state = 2;

CREATE OR REPLACE VIEW v_plan_psector
AS SELECT plan_psector.psector_id,
    plan_psector.name,
    plan_psector.psector_type,
    plan_psector.descript,
    plan_psector.priority,
    a.suma::numeric(14,2) AS total_arc,
    b.suma::numeric(14,2) AS total_node,
    c.suma::numeric(14,2) AS total_other,
    plan_psector.text1,
    plan_psector.text2,
    plan_psector.observ,
    plan_psector.rotation,
    plan_psector.scale,
    plan_psector.active,
    (
        CASE
            WHEN a.suma IS NULL THEN 0::numeric
            ELSE a.suma
        END +
        CASE
            WHEN b.suma IS NULL THEN 0::numeric
            ELSE b.suma
        END +
        CASE
            WHEN c.suma IS NULL THEN 0::numeric
            ELSE c.suma
        END)::numeric(14,2) AS pem,
    plan_psector.gexpenses,
    (((100::numeric + plan_psector.gexpenses) / 100::numeric)::double precision * (
        CASE
            WHEN a.suma IS NULL THEN 0::numeric
            ELSE a.suma
        END +
        CASE
            WHEN b.suma IS NULL THEN 0::numeric
            ELSE b.suma
        END +
        CASE
            WHEN c.suma IS NULL THEN 0::numeric
            ELSE c.suma
        END)::double precision)::numeric(14,2) AS pec,
    plan_psector.vat,
    (((100::numeric + plan_psector.gexpenses) / 100::numeric * ((100::numeric + plan_psector.vat) / 100::numeric))::double precision * (
        CASE
            WHEN a.suma IS NULL THEN 0::numeric
            ELSE a.suma
        END +
        CASE
            WHEN b.suma IS NULL THEN 0::numeric
            ELSE b.suma
        END +
        CASE
            WHEN c.suma IS NULL THEN 0::numeric
            ELSE c.suma
        END)::double precision)::numeric(14,2) AS pec_vat,
    plan_psector.other,
    (((100::numeric + plan_psector.gexpenses) / 100::numeric * ((100::numeric + plan_psector.vat) / 100::numeric) * ((100::numeric + plan_psector.other) / 100::numeric))::numeric(14,2)::double precision * (
        CASE
            WHEN a.suma IS NULL THEN 0::numeric
            ELSE a.suma
        END +
        CASE
            WHEN b.suma IS NULL THEN 0::numeric
            ELSE b.suma
        END +
        CASE
            WHEN c.suma IS NULL THEN 0::numeric
            ELSE c.suma
        END)::double precision)::numeric(14,2) AS pca,
    plan_psector.the_geom
   FROM selector_psector,
    plan_psector
     LEFT JOIN ( SELECT sum(v_plan_psector_x_arc.total_budget) AS suma,
            v_plan_psector_x_arc.psector_id
           FROM ( SELECT row_number() OVER (ORDER BY v_plan_arc.arc_id) AS rid,
                    v_plan_arc.arc_id,
                    v_plan_arc.node_1,
                    v_plan_arc.node_2,
                    v_plan_arc.arc_type::text,
                    v_plan_arc.arccat_id,
                    v_plan_arc.epa_type,
                    v_plan_arc.state,
                    v_plan_arc.sector_id,
                    v_plan_arc.expl_id,
                    v_plan_arc.annotation,
                    v_plan_arc.soilcat_id,
                    v_plan_arc.y1,
                    v_plan_arc.y2,
                    v_plan_arc.mean_y,
                    v_plan_arc.z1,
                    v_plan_arc.z2,
                    v_plan_arc.thickness,
                    v_plan_arc.width,
                    v_plan_arc.b,
                    v_plan_arc.bulk,
                    v_plan_arc.geom1,
                    v_plan_arc.area,
                    v_plan_arc.y_param,
                    v_plan_arc.total_y,
                    v_plan_arc.rec_y,
                    v_plan_arc.geom1_ext,
                    v_plan_arc.calculed_y,
                    v_plan_arc.m3mlexc,
                    v_plan_arc.m2mltrenchl,
                    v_plan_arc.m2mlbottom,
                    v_plan_arc.m2mlpav,
                    v_plan_arc.m3mlprotec,
                    v_plan_arc.m3mlfill,
                    v_plan_arc.m3mlexcess,
                    v_plan_arc.m3exc_cost,
                    v_plan_arc.m2trenchl_cost,
                    v_plan_arc.m2bottom_cost,
                    v_plan_arc.m2pav_cost,
                    v_plan_arc.m3protec_cost,
                    v_plan_arc.m3fill_cost,
                    v_plan_arc.m3excess_cost,
                    v_plan_arc.cost_unit,
                    v_plan_arc.pav_cost,
                    v_plan_arc.exc_cost,
                    v_plan_arc.trenchl_cost,
                    v_plan_arc.base_cost,
                    v_plan_arc.protec_cost,
                    v_plan_arc.fill_cost,
                    v_plan_arc.excess_cost,
                    v_plan_arc.arc_cost,
                    v_plan_arc.cost,
                    v_plan_arc.length,
                    v_plan_arc.budget,
                    v_plan_arc.other_budget,
                    v_plan_arc.total_budget,
                    v_plan_arc.the_geom,
                    plan_psector_x_arc.id,
                    plan_psector_x_arc.arc_id,
                    plan_psector_x_arc.psector_id,
                    plan_psector_x_arc.state,
                    plan_psector_x_arc.doable,
                    plan_psector_x_arc.descript,
                    plan_psector_x_arc.addparam
                   FROM v_plan_arc
                     JOIN plan_psector_x_arc ON plan_psector_x_arc.arc_id::text = v_plan_arc.arc_id::text
                     JOIN plan_psector plan_psector_1 ON plan_psector_1.psector_id = plan_psector_x_arc.psector_id
                  WHERE plan_psector_x_arc.doable IS TRUE
                  ORDER BY plan_psector_x_arc.psector_id) v_plan_psector_x_arc(rid, arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, sector_id, expl_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, arc_id_1, psector_id, state_1, doable, descript, addparam)
          GROUP BY v_plan_psector_x_arc.psector_id) a ON a.psector_id = plan_psector.psector_id
     LEFT JOIN ( SELECT sum(v_plan_psector_x_node.budget) AS suma,
            v_plan_psector_x_node.psector_id
           FROM ( SELECT row_number() OVER (ORDER BY v_plan_node.node_id) AS rid,
                    v_plan_node.node_id,
                    v_plan_node.nodecat_id,
                    v_plan_node.node_type::text,
                    v_plan_node.top_elev,
                    v_plan_node.elev,
                    v_plan_node.epa_type,
                    v_plan_node.state,
                    v_plan_node.sector_id,
                    v_plan_node.expl_id,
                    v_plan_node.annotation,
                    v_plan_node.cost_unit,
                    v_plan_node.descript,
                    v_plan_node.cost,
                    v_plan_node.measurement,
                    v_plan_node.budget,
                    v_plan_node.the_geom,
                    plan_psector_x_node.id,
                    plan_psector_x_node.node_id,
                    plan_psector_x_node.psector_id,
                    plan_psector_x_node.state,
                    plan_psector_x_node.doable,
                    plan_psector_x_node.descript
                   FROM v_plan_node
                     JOIN plan_psector_x_node ON plan_psector_x_node.node_id::text = v_plan_node.node_id::text
                     JOIN plan_psector plan_psector_1 ON plan_psector_1.psector_id = plan_psector_x_node.psector_id
                  WHERE plan_psector_x_node.doable IS TRUE
                  ORDER BY plan_psector_x_node.psector_id) v_plan_psector_x_node(rid, node_id, nodecat_id, node_type, top_elev, elev, epa_type, state, sector_id, expl_id, annotation, cost_unit, descript, cost, measurement, budget, the_geom, id, node_id_1, psector_id, state_1, doable, descript_1)
          GROUP BY v_plan_psector_x_node.psector_id) b ON b.psector_id = plan_psector.psector_id
     LEFT JOIN ( SELECT sum(v_plan_psector_x_other.total_budget) AS suma,
            v_plan_psector_x_other.psector_id
           FROM ( SELECT plan_psector_x_other.id,
                    plan_psector_x_other.psector_id,
                    plan_psector_1.psector_type,
                    v_price_compost.id AS price_id,
                    v_price_compost.descript,
                    v_price_compost.price,
                    plan_psector_x_other.measurement,
                    (plan_psector_x_other.measurement * v_price_compost.price)::numeric(14,2) AS total_budget
                   FROM plan_psector_x_other
                     JOIN v_price_compost ON v_price_compost.id::text = plan_psector_x_other.price_id::text
                     JOIN plan_psector plan_psector_1 ON plan_psector_1.psector_id = plan_psector_x_other.psector_id
                  ORDER BY plan_psector_x_other.psector_id) v_plan_psector_x_other
          GROUP BY v_plan_psector_x_other.psector_id) c ON c.psector_id = plan_psector.psector_id
  WHERE plan_psector.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text;

CREATE OR REPLACE VIEW v_plan_psector_node
AS SELECT row_number() OVER () AS rid,
    node.node_id,
    plan_psector_x_node.psector_id,
    node.code,
    node.nodecat_id,
    node.node_type::text,
    cat_feature.feature_class,
    node.state AS original_state,
    node.state_type AS original_state_type,
    plan_psector_x_node.state AS plan_state,
    plan_psector_x_node.doable,
    plan_psector.priority AS psector_priority,
    node.the_geom
   FROM selector_psector,
    node
     JOIN plan_psector_x_node USING (node_id)
     JOIN plan_psector USING (psector_id)
     JOIN cat_node ON cat_node.id::text = node.nodecat_id::text
     JOIN cat_feature ON cat_feature.id::text = node.node_type::text
  WHERE plan_psector_x_node.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text;

CREATE OR REPLACE VIEW v_plan_psector_connec
AS SELECT row_number() OVER () AS rid,
    connec.connec_id,
    plan_psector_x_connec.psector_id,
    connec.code,
    connec.conneccat_id,
    connec.connec_type::text,
    cat_feature.feature_class,
    connec.state AS original_state,
    connec.state_type AS original_state_type,
    plan_psector_x_connec.state AS plan_state,
    plan_psector_x_connec.doable,
    plan_psector.priority AS psector_priority,
    connec.the_geom
   FROM selector_psector,
    connec
     JOIN plan_psector_x_connec USING (connec_id)
     JOIN plan_psector USING (psector_id)
     JOIN cat_connec ON cat_connec.id::text = connec.conneccat_id::text
     JOIN cat_feature ON cat_feature.id::text = connec.connec_type::text::text
  WHERE plan_psector_x_connec.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW v_plan_psector_arc
AS SELECT row_number() OVER () AS rid,
    arc.arc_id,
    plan_psector_x_arc.psector_id,
    arc.code,
    arc.arccat_id,
    arc.arc_type::text,
    cat_feature.feature_class,
    arc.state AS original_state,
    arc.state_type AS original_state_type,
    plan_psector_x_arc.state AS plan_state,
    plan_psector_x_arc.doable,
    plan_psector_x_arc.addparam::text AS addparam,
    plan_psector.priority AS psector_priority,
    arc.the_geom
   FROM selector_psector,
    arc
     JOIN plan_psector_x_arc USING (arc_id)
     JOIN plan_psector USING (psector_id)
     JOIN cat_arc ON cat_arc.id::text = arc.arccat_id::text
     JOIN cat_feature ON cat_feature.id::text = arc.arc_type::text
  WHERE plan_psector_x_arc.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text;

CREATE OR REPLACE VIEW v_plan_current_psector
AS SELECT plan_psector.psector_id,
    plan_psector.name,
    plan_psector.psector_type,
    plan_psector.descript,
    plan_psector.priority,
    a.suma::numeric(14,2) AS total_arc,
    b.suma::numeric(14,2) AS total_node,
    c.suma::numeric(14,2) AS total_other,
    plan_psector.text1,
    plan_psector.text2,
    plan_psector.observ,
    plan_psector.rotation,
    plan_psector.scale,
    plan_psector.active,
    (
        CASE
            WHEN a.suma IS NULL THEN 0::numeric
            ELSE a.suma
        END +
        CASE
            WHEN b.suma IS NULL THEN 0::numeric
            ELSE b.suma
        END +
        CASE
            WHEN c.suma IS NULL THEN 0::numeric
            ELSE c.suma
        END)::numeric(14,2) AS pem,
    plan_psector.gexpenses,
    ((100::numeric + plan_psector.gexpenses) / 100::numeric)::numeric(14,2) * (
        CASE
            WHEN a.suma IS NULL THEN 0::numeric
            ELSE a.suma
        END +
        CASE
            WHEN b.suma IS NULL THEN 0::numeric
            ELSE b.suma
        END +
        CASE
            WHEN c.suma IS NULL THEN 0::numeric
            ELSE c.suma
        END)::numeric(14,2) AS pec,
    plan_psector.vat,
    ((100::numeric + plan_psector.gexpenses) / 100::numeric * ((100::numeric + plan_psector.vat) / 100::numeric))::numeric(14,2) * (
        CASE
            WHEN a.suma IS NULL THEN 0::numeric
            ELSE a.suma
        END +
        CASE
            WHEN b.suma IS NULL THEN 0::numeric
            ELSE b.suma
        END +
        CASE
            WHEN c.suma IS NULL THEN 0::numeric
            ELSE c.suma
        END)::numeric(14,2) AS pec_vat,
    plan_psector.other,
    ((100::numeric + plan_psector.gexpenses) / 100::numeric * ((100::numeric + plan_psector.vat) / 100::numeric) * ((100::numeric + plan_psector.other) / 100::numeric))::numeric(14,2) * (
        CASE
            WHEN a.suma IS NULL THEN 0::numeric
            ELSE a.suma
        END +
        CASE
            WHEN b.suma IS NULL THEN 0::numeric
            ELSE b.suma
        END +
        CASE
            WHEN c.suma IS NULL THEN 0::numeric
            ELSE c.suma
        END)::numeric(14,2) AS pca,
    plan_psector.the_geom
   FROM config_param_user,
    plan_psector
     LEFT JOIN ( SELECT sum(v_plan_psector_x_arc.total_budget) AS suma,
            v_plan_psector_x_arc.psector_id
           FROM ( SELECT row_number() OVER (ORDER BY v_plan_arc.arc_id) AS rid,
                    v_plan_arc.arc_id,
                    v_plan_arc.node_1,
                    v_plan_arc.node_2,
                    v_plan_arc.arc_type::text,
                    v_plan_arc.arccat_id,
                    v_plan_arc.epa_type,
                    v_plan_arc.state,
                    v_plan_arc.sector_id,
                    v_plan_arc.expl_id,
                    v_plan_arc.annotation,
                    v_plan_arc.soilcat_id,
                    v_plan_arc.y1,
                    v_plan_arc.y2,
                    v_plan_arc.mean_y,
                    v_plan_arc.z1,
                    v_plan_arc.z2,
                    v_plan_arc.thickness,
                    v_plan_arc.width,
                    v_plan_arc.b,
                    v_plan_arc.bulk,
                    v_plan_arc.geom1,
                    v_plan_arc.area,
                    v_plan_arc.y_param,
                    v_plan_arc.total_y,
                    v_plan_arc.rec_y,
                    v_plan_arc.geom1_ext,
                    v_plan_arc.calculed_y,
                    v_plan_arc.m3mlexc,
                    v_plan_arc.m2mltrenchl,
                    v_plan_arc.m2mlbottom,
                    v_plan_arc.m2mlpav,
                    v_plan_arc.m3mlprotec,
                    v_plan_arc.m3mlfill,
                    v_plan_arc.m3mlexcess,
                    v_plan_arc.m3exc_cost,
                    v_plan_arc.m2trenchl_cost,
                    v_plan_arc.m2bottom_cost,
                    v_plan_arc.m2pav_cost,
                    v_plan_arc.m3protec_cost,
                    v_plan_arc.m3fill_cost,
                    v_plan_arc.m3excess_cost,
                    v_plan_arc.cost_unit,
                    v_plan_arc.pav_cost,
                    v_plan_arc.exc_cost,
                    v_plan_arc.trenchl_cost,
                    v_plan_arc.base_cost,
                    v_plan_arc.protec_cost,
                    v_plan_arc.fill_cost,
                    v_plan_arc.excess_cost,
                    v_plan_arc.arc_cost,
                    v_plan_arc.cost,
                    v_plan_arc.length,
                    v_plan_arc.budget,
                    v_plan_arc.other_budget,
                    v_plan_arc.total_budget,
                    v_plan_arc.the_geom,
                    plan_psector_x_arc.id,
                    plan_psector_x_arc.arc_id,
                    plan_psector_x_arc.psector_id,
                    plan_psector_x_arc.state,
                    plan_psector_x_arc.doable,
                    plan_psector_x_arc.descript,
                    plan_psector_x_arc.addparam
                   FROM v_plan_arc
                     JOIN plan_psector_x_arc ON plan_psector_x_arc.arc_id::text = v_plan_arc.arc_id::text
                     JOIN plan_psector plan_psector_1 ON plan_psector_1.psector_id = plan_psector_x_arc.psector_id
                  ORDER BY plan_psector_x_arc.psector_id) v_plan_psector_x_arc(rid, arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, sector_id, expl_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, arc_id_1, psector_id, state_1, doable, descript, addparam)
          GROUP BY v_plan_psector_x_arc.psector_id) a ON a.psector_id = plan_psector.psector_id
     LEFT JOIN ( SELECT sum(v_plan_psector_x_node.budget) AS suma,
            v_plan_psector_x_node.psector_id
           FROM ( SELECT row_number() OVER (ORDER BY v_plan_node.node_id) AS rid,
                    v_plan_node.node_id,
                    v_plan_node.nodecat_id,
                    v_plan_node.node_type::text,
                    v_plan_node.top_elev,
                    v_plan_node.elev,
                    v_plan_node.epa_type,
                    v_plan_node.state,
                    v_plan_node.sector_id,
                    v_plan_node.expl_id,
                    v_plan_node.annotation,
                    v_plan_node.cost_unit,
                    v_plan_node.descript,
                    v_plan_node.cost,
                    v_plan_node.measurement,
                    v_plan_node.budget,
                    v_plan_node.the_geom,
                    plan_psector_x_node.id,
                    plan_psector_x_node.node_id,
                    plan_psector_x_node.psector_id,
                    plan_psector_x_node.state,
                    plan_psector_x_node.doable,
                    plan_psector_x_node.descript
                   FROM v_plan_node
                     JOIN plan_psector_x_node ON plan_psector_x_node.node_id::text = v_plan_node.node_id::text
                     JOIN plan_psector plan_psector_1 ON plan_psector_1.psector_id = plan_psector_x_node.psector_id
                  ORDER BY plan_psector_x_node.psector_id) v_plan_psector_x_node(rid, node_id, nodecat_id, node_type, top_elev, elev, epa_type, state, sector_id, expl_id, annotation, cost_unit, descript, cost, measurement, budget, the_geom, id, node_id_1, psector_id, state_1, doable, descript_1)
          GROUP BY v_plan_psector_x_node.psector_id) b ON b.psector_id = plan_psector.psector_id
     LEFT JOIN ( SELECT sum(v_plan_psector_x_other.total_budget) AS suma,
            v_plan_psector_x_other.psector_id
           FROM ( SELECT plan_psector_x_other.id,
                    plan_psector_x_other.psector_id,
                    plan_psector_1.psector_type,
                    v_price_compost.id AS price_id,
                    v_price_compost.descript,
                    v_price_compost.price,
                    plan_psector_x_other.measurement,
                    (plan_psector_x_other.measurement * v_price_compost.price)::numeric(14,2) AS total_budget
                   FROM plan_psector_x_other
                     JOIN v_price_compost ON v_price_compost.id::text = plan_psector_x_other.price_id::text
                     JOIN plan_psector plan_psector_1 ON plan_psector_1.psector_id = plan_psector_x_other.psector_id
                  ORDER BY plan_psector_x_other.psector_id) v_plan_psector_x_other
          GROUP BY v_plan_psector_x_other.psector_id) c ON c.psector_id = plan_psector.psector_id
  WHERE config_param_user.cur_user::text = "current_user"()::text AND config_param_user.parameter::text = 'plan_psector_vdefault'::text AND config_param_user.value::integer = plan_psector.psector_id;

CREATE OR REPLACE VIEW v_plan_psector_all
AS SELECT plan_psector.psector_id,
    plan_psector.name,
    plan_psector.psector_type,
    plan_psector.descript,
    plan_psector.priority,
    a.suma::numeric(14,2) AS total_arc,
    b.suma::numeric(14,2) AS total_node,
    c.suma::numeric(14,2) AS total_other,
    plan_psector.text1,
    plan_psector.text2,
    plan_psector.observ,
    plan_psector.rotation,
    plan_psector.scale,
    (
        CASE
            WHEN a.suma IS NULL THEN 0::numeric
            ELSE a.suma
        END +
        CASE
            WHEN b.suma IS NULL THEN 0::numeric
            ELSE b.suma
        END +
        CASE
            WHEN c.suma IS NULL THEN 0::numeric
            ELSE c.suma
        END)::numeric(14,2) AS pem,
    plan_psector.gexpenses,
    (((100::numeric + plan_psector.gexpenses) / 100::numeric)::double precision * (
        CASE
            WHEN a.suma IS NULL THEN 0::numeric
            ELSE a.suma
        END +
        CASE
            WHEN b.suma IS NULL THEN 0::numeric
            ELSE b.suma
        END +
        CASE
            WHEN c.suma IS NULL THEN 0::numeric
            ELSE c.suma
        END)::double precision)::numeric(14,2) AS pec,
    plan_psector.vat,
    (((100::numeric + plan_psector.gexpenses) / 100::numeric * ((100::numeric + plan_psector.vat) / 100::numeric))::double precision * (
        CASE
            WHEN a.suma IS NULL THEN 0::numeric
            ELSE a.suma
        END +
        CASE
            WHEN b.suma IS NULL THEN 0::numeric
            ELSE b.suma
        END +
        CASE
            WHEN c.suma IS NULL THEN 0::numeric
            ELSE c.suma
        END)::double precision)::numeric(14,2) AS pec_vat,
    plan_psector.other,
    ((((100::numeric + plan_psector.gexpenses) / 100::numeric * ((100::numeric + plan_psector.vat) / 100::numeric))::double precision * (
        CASE
            WHEN a.suma IS NULL THEN 0::numeric
            ELSE a.suma
        END +
        CASE
            WHEN b.suma IS NULL THEN 0::numeric
            ELSE b.suma
        END +
        CASE
            WHEN c.suma IS NULL THEN 0::numeric
            ELSE c.suma
        END)::double precision)::numeric(14,2)::double precision + ((100::numeric + plan_psector.vat) / 100::numeric * (plan_psector.other / 100::numeric))::double precision * (
        CASE
            WHEN a.suma IS NULL THEN 0::numeric
            ELSE a.suma
        END +
        CASE
            WHEN b.suma IS NULL THEN 0::numeric
            ELSE b.suma
        END +
        CASE
            WHEN c.suma IS NULL THEN 0::numeric
            ELSE c.suma
        END)::double precision)::numeric(14,2) AS pca,
    plan_psector.the_geom
   FROM selector_psector,
    plan_psector
     LEFT JOIN ( SELECT sum(v_plan_psector_x_arc.total_budget) AS suma,
            v_plan_psector_x_arc.psector_id
           FROM ( SELECT row_number() OVER (ORDER BY v_plan_arc.arc_id) AS rid,
                    v_plan_arc.arc_id,
                    v_plan_arc.node_1,
                    v_plan_arc.node_2,
                    v_plan_arc.arc_type::text,
                    v_plan_arc.arccat_id,
                    v_plan_arc.epa_type,
                    v_plan_arc.state,
                    v_plan_arc.expl_id,
                    v_plan_arc.sector_id,
                    v_plan_arc.annotation,
                    v_plan_arc.soilcat_id,
                    v_plan_arc.y1,
                    v_plan_arc.y2,
                    v_plan_arc.mean_y,
                    v_plan_arc.z1,
                    v_plan_arc.z2,
                    v_plan_arc.thickness,
                    v_plan_arc.width,
                    v_plan_arc.b,
                    v_plan_arc.bulk,
                    v_plan_arc.geom1,
                    v_plan_arc.area,
                    v_plan_arc.y_param,
                    v_plan_arc.total_y,
                    v_plan_arc.rec_y,
                    v_plan_arc.geom1_ext,
                    v_plan_arc.calculed_y,
                    v_plan_arc.m3mlexc,
                    v_plan_arc.m2mltrenchl,
                    v_plan_arc.m2mlbottom,
                    v_plan_arc.m2mlpav,
                    v_plan_arc.m3mlprotec,
                    v_plan_arc.m3mlfill,
                    v_plan_arc.m3mlexcess,
                    v_plan_arc.m3exc_cost,
                    v_plan_arc.m2trenchl_cost,
                    v_plan_arc.m2bottom_cost,
                    v_plan_arc.m2pav_cost,
                    v_plan_arc.m3protec_cost,
                    v_plan_arc.m3fill_cost,
                    v_plan_arc.m3excess_cost,
                    v_plan_arc.cost_unit,
                    v_plan_arc.pav_cost,
                    v_plan_arc.exc_cost,
                    v_plan_arc.trenchl_cost,
                    v_plan_arc.base_cost,
                    v_plan_arc.protec_cost,
                    v_plan_arc.fill_cost,
                    v_plan_arc.excess_cost,
                    v_plan_arc.arc_cost,
                    v_plan_arc.cost,
                    v_plan_arc.length,
                    v_plan_arc.budget,
                    v_plan_arc.other_budget,
                    v_plan_arc.total_budget,
                    v_plan_arc.the_geom,
                    plan_psector_x_arc.id,
                    plan_psector_x_arc.arc_id,
                    plan_psector_x_arc.psector_id,
                    plan_psector_x_arc.state,
                    plan_psector_x_arc.doable,
                    plan_psector_x_arc.descript,
                    plan_psector_x_arc.addparam
                   FROM v_plan_arc
                     JOIN plan_psector_x_arc ON plan_psector_x_arc.arc_id::text = v_plan_arc.arc_id::text
                     JOIN plan_psector plan_psector_1 ON plan_psector_1.psector_id = plan_psector_x_arc.psector_id
                  ORDER BY plan_psector_x_arc.psector_id) v_plan_psector_x_arc(rid, arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, expl_id, sector_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, arc_id_1, psector_id, state_1, doable, descript, addparam)
          GROUP BY v_plan_psector_x_arc.psector_id) a ON a.psector_id = plan_psector.psector_id
     LEFT JOIN ( SELECT sum(v_plan_psector_x_node.budget) AS suma,
            v_plan_psector_x_node.psector_id
           FROM ( SELECT row_number() OVER (ORDER BY v_plan_node.node_id) AS rid,
                    v_plan_node.node_id,
                    v_plan_node.nodecat_id,
                    v_plan_node.node_type::text,
                    v_plan_node.top_elev,
                    v_plan_node.elev,
                    v_plan_node.epa_type,
                    v_plan_node.state,
                    v_plan_node.sector_id,
                    v_plan_node.expl_id,
                    v_plan_node.annotation,
                    v_plan_node.cost_unit,
                    v_plan_node.descript,
                    v_plan_node.cost,
                    v_plan_node.measurement,
                    v_plan_node.budget,
                    v_plan_node.the_geom,
                    plan_psector_x_node.id,
                    plan_psector_x_node.node_id,
                    plan_psector_x_node.psector_id,
                    plan_psector_x_node.state,
                    plan_psector_x_node.doable,
                    plan_psector_x_node.descript
                   FROM v_plan_node
                     JOIN plan_psector_x_node ON plan_psector_x_node.node_id::text = v_plan_node.node_id::text
                     JOIN plan_psector plan_psector_1 ON plan_psector_1.psector_id = plan_psector_x_node.psector_id
                  ORDER BY plan_psector_x_node.psector_id) v_plan_psector_x_node(rid, node_id, nodecat_id, node_type, top_elev, elev, epa_type, state, sector_id, expl_id, annotation, cost_unit, descript, cost, measurement, budget, the_geom, id, node_id_1, psector_id, state_1, doable, descript_1)
          GROUP BY v_plan_psector_x_node.psector_id) b ON b.psector_id = plan_psector.psector_id
     LEFT JOIN ( SELECT sum(v_plan_psector_x_other.total_budget) AS suma,
            v_plan_psector_x_other.psector_id
           FROM ( SELECT plan_psector_x_other.id,
                    plan_psector_x_other.psector_id,
                    plan_psector_1.psector_type,
                    v_price_compost.id AS price_id,
                    v_price_compost.descript,
                    v_price_compost.price,
                    plan_psector_x_other.measurement,
                    (plan_psector_x_other.measurement * v_price_compost.price)::numeric(14,2) AS total_budget
                   FROM plan_psector_x_other
                     JOIN v_price_compost ON v_price_compost.id::text = plan_psector_x_other.price_id::text
                     JOIN plan_psector plan_psector_1 ON plan_psector_1.psector_id = plan_psector_x_other.psector_id
                  ORDER BY plan_psector_x_other.psector_id) v_plan_psector_x_other
          GROUP BY v_plan_psector_x_other.psector_id) c ON c.psector_id = plan_psector.psector_id;

CREATE OR REPLACE VIEW v_plan_psector_budget
AS SELECT row_number() OVER (ORDER BY v_plan_arc.arc_id) AS rid,
    plan_psector_x_arc.psector_id,
    'arc'::text AS feature_type,
    v_plan_arc.arccat_id AS featurecat_id,
    v_plan_arc.arc_id AS feature_id,
    v_plan_arc.length,
    (v_plan_arc.total_budget / v_plan_arc.length)::numeric(14,2) AS unitary_cost,
    v_plan_arc.total_budget
   FROM v_plan_arc
     JOIN plan_psector_x_arc ON plan_psector_x_arc.arc_id::text = v_plan_arc.arc_id::text
  WHERE plan_psector_x_arc.doable = true
UNION
 SELECT row_number() OVER (ORDER BY v_plan_node.node_id) + 9999 AS rid,
    plan_psector_x_node.psector_id,
    'node'::text AS feature_type,
    v_plan_node.nodecat_id AS featurecat_id,
    v_plan_node.node_id AS feature_id,
    1 AS length,
    v_plan_node.budget AS unitary_cost,
    v_plan_node.budget AS total_budget
   FROM v_plan_node
     JOIN plan_psector_x_node ON plan_psector_x_node.node_id::text = v_plan_node.node_id::text
  WHERE plan_psector_x_node.doable = true
UNION
 SELECT row_number() OVER (ORDER BY v_edit_plan_psector_x_other.id) + 19999 AS rid,
    v_edit_plan_psector_x_other.psector_id,
    'other'::text AS feature_type,
    v_edit_plan_psector_x_other.price_id AS featurecat_id,
    v_edit_plan_psector_x_other.observ AS feature_id,
    v_edit_plan_psector_x_other.measurement AS length,
    v_edit_plan_psector_x_other.price AS unitary_cost,
    v_edit_plan_psector_x_other.total_budget
   FROM v_edit_plan_psector_x_other
  ORDER BY 1, 2, 4;

CREATE OR REPLACE VIEW v_plan_psector_budget_arc
AS SELECT row_number() OVER (ORDER BY v_plan_arc.arc_id) AS rid,
    plan_psector_x_arc.psector_id,
    plan_psector.psector_type,
    v_plan_arc.arc_id,
    v_plan_arc.arccat_id,
    v_plan_arc.cost_unit,
    v_plan_arc.cost::numeric(14,2) AS cost,
    v_plan_arc.length,
    v_plan_arc.budget,
    v_plan_arc.other_budget,
    v_plan_arc.total_budget,
    v_plan_arc.state,
    plan_psector.expl_id,
    plan_psector.atlas_id,
    plan_psector_x_arc.doable,
    plan_psector.priority,
    v_plan_arc.the_geom
   FROM v_plan_arc
     JOIN plan_psector_x_arc ON plan_psector_x_arc.arc_id::text = v_plan_arc.arc_id::text
     JOIN plan_psector ON plan_psector.psector_id = plan_psector_x_arc.psector_id
  WHERE plan_psector_x_arc.doable = true
  ORDER BY plan_psector_x_arc.psector_id;

CREATE OR REPLACE VIEW v_plan_psector_budget_detail
AS SELECT v_plan_arc.arc_id,
    plan_psector_x_arc.psector_id,
    v_plan_arc.arccat_id,
    v_plan_arc.soilcat_id,
    v_plan_arc.y1,
    v_plan_arc.y2,
    v_plan_arc.arc_cost AS mlarc_cost,
    v_plan_arc.m3mlexc,
    v_plan_arc.exc_cost AS mlexc_cost,
    v_plan_arc.m2mltrenchl,
    v_plan_arc.trenchl_cost AS mltrench_cost,
    v_plan_arc.m2mlbottom AS m2mlbase,
    v_plan_arc.base_cost AS mlbase_cost,
    v_plan_arc.m2mlpav,
    v_plan_arc.pav_cost AS mlpav_cost,
    v_plan_arc.m3mlprotec,
    v_plan_arc.protec_cost AS mlprotec_cost,
    v_plan_arc.m3mlfill,
    v_plan_arc.fill_cost AS mlfill_cost,
    v_plan_arc.m3mlexcess,
    v_plan_arc.excess_cost AS mlexcess_cost,
    v_plan_arc.cost AS mltotal_cost,
    v_plan_arc.length,
    v_plan_arc.budget AS other_budget,
    v_plan_arc.total_budget
   FROM v_plan_arc
     JOIN plan_psector_x_arc ON plan_psector_x_arc.arc_id::text = v_plan_arc.arc_id::text
  WHERE plan_psector_x_arc.doable = true
  ORDER BY plan_psector_x_arc.psector_id, v_plan_arc.soilcat_id, v_plan_arc.arccat_id;


-- gully and link views
CREATE OR REPLACE VIEW v_edit_inp_gully
AS SELECT g.gully_id,
    g.code,
    g.top_elev,
    g.gully_type,
    g.gullycat_id,
    (g.grate_width / 100::numeric)::numeric(12,2) AS grate_width,
    (g.grate_length / 100::numeric)::numeric(12,2) AS grate_length,
    g.arc_id,
    g.sector_id,
    g.expl_id,
    g.state,
    g.state_type,
    g.the_geom,
    g.units,
    g.units_placement,
    g.groove,
    g.groove_height,
    g.groove_length,
    g.pjoint_id,
    g.pjoint_type,
    cat_gully.a_param,
    cat_gully.b_param,
        CASE
            WHEN g.units_placement::text = 'LENGTH-SIDE'::text THEN (COALESCE(g.units::integer, 1)::numeric * g.grate_width / 100::numeric)::numeric(12,3)
            WHEN g.units_placement::text = 'WIDTH-SIDE'::text THEN (COALESCE(g.units::integer, 1)::numeric * g.grate_length / 100::numeric)::numeric(12,3)
            ELSE (cat_gully.width / 100::numeric)::numeric(12,3)
        END AS total_width,
        CASE
            WHEN g.units_placement::text = 'LENGTH-SIDE'::text THEN (COALESCE(g.units::integer, 1)::numeric * g.grate_width / 100::numeric)::numeric(12,3)
            WHEN g.units_placement::text = 'WIDTH-SIDE'::text THEN (COALESCE(g.units::integer, 1)::numeric * g.grate_length / 100::numeric)::numeric(12,3)
            ELSE (cat_gully.length / 100::numeric)::numeric(12,3)
        END AS total_length,
    g.ymax - COALESCE(g.sandbox, 0::numeric) AS depth,
    g.annotation,
    i.outlet_type,
    i.custom_top_elev,
    i.custom_width,
    i.custom_length,
    i.custom_depth,
    i.method,
    i.weir_cd,
    i.orifice_cd,
    i.custom_a_param,
    i.custom_b_param,
    i.efficiency
    FROM v_edit_gully g
    JOIN inp_gully i USING (gully_id)
    JOIN cat_gully ON g.gullycat_id::text = cat_gully.id::text
    WHERE is_operative IS TRUE;

CREATE OR REPLACE VIEW ve_pol_gully
AS SELECT polygon.pol_id,
    polygon.feature_id,
    polygon.featurecat_id,
    polygon.state,
    polygon.sys_type,
    polygon.the_geom,
    gully.fluid_type,
    polygon.trace_featuregeom
    FROM polygon
    JOIN gully ON polygon.feature_id::text = gully.gully_id::text
    JOIN selector_expl se ON (se.cur_user = CURRENT_USER AND se.expl_id = gully.expl_id) or (se.cur_user = CURRENT_USER and se.expl_id = ANY(gully.expl_visibility))
    JOIN selector_sector ss ON (ss.cur_user = CURRENT_USER AND ss.sector_id = gully.sector_id)
    JOIN selector_municipality sm ON (sm.cur_user = CURRENT_USER AND sm.muni_id = gully.muni_id);

CREATE OR REPLACE VIEW v_edit_raingage AS
 SELECT raingage.rg_id,
    raingage.form_type,
    raingage.intvl,
    raingage.scf,
    raingage.rgage_type,
    raingage.timser_id,
    raingage.fname,
    raingage.sta,
    raingage.units,
    raingage.the_geom,
    raingage.expl_id,
	raingage.muni_id
    FROM selector_expl, raingage
    LEFT JOIN selector_municipality m USING (muni_id)
    WHERE raingage.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text
    AND (m.cur_user = current_user or raingage.muni_id is null);


CREATE OR REPLACE VIEW v_plan_psector_gully AS
SELECT row_number() OVER () AS rid,
gully.gully_id,
plan_psector_x_gully.psector_id,
gully.code,
gully.gullycat_id,
gully.gully_type,
cat_feature.feature_class,
gully.state AS original_state,
gully.state_type AS original_state_type,
plan_psector_x_gully.state AS plan_state,
plan_psector_x_gully.doable,
plan_psector.priority AS psector_priority,
gully.the_geom
FROM selector_psector, gully
JOIN plan_psector_x_gully USING (gully_id)
JOIN plan_psector USING (psector_id)
JOIN cat_gully ON cat_gully.id=gully.gullycat_id
JOIN cat_feature ON cat_feature.id=gully.gully_type
WHERE plan_psector_x_gully.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW v_edit_review_gully
AS SELECT review_gully.gully_id,
    review_gully.top_elev,
    review_gully.ymax,
    review_gully.sandbox,
    review_gully.matcat_id,
    review_gully.gully_type,
    review_gully.gullycat_id,
    review_gully.units,
    review_gully.groove,
    review_gully.siphon,
    review_gully.connec_arccat_id,
    review_gully.annotation,
    review_gully.observ,
    review_gully.review_obs,
    review_gully.expl_id,
    review_gully.the_geom,
    review_gully.field_date,
    review_gully.field_checked,
    review_gully.is_validated
   FROM review_gully,
    selector_expl
  WHERE selector_expl.cur_user = "current_user"()::text AND review_gully.expl_id = selector_expl.expl_id;

CREATE OR REPLACE VIEW v_edit_review_connec
AS SELECT review_connec.connec_id,
    review_connec.y1,
    review_connec.y2,
    review_connec.connec_type::text,
    review_connec.matcat_id,
    review_connec.conneccat_id,
    review_connec.annotation,
    review_connec.observ,
    review_connec.review_obs,
    review_connec.expl_id,
    review_connec.the_geom,
    review_connec.field_date,
    review_connec.field_checked,
    review_connec.is_validated
   FROM review_connec,
    selector_expl
  WHERE selector_expl.cur_user = "current_user"()::text AND review_connec.expl_id = selector_expl.expl_id;

-- 02/12/2024
CREATE OR REPLACE VIEW ve_epa_orifice
AS SELECT inp_orifice.arc_id,
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
    rpt_arcflow_sum.max_flow,
    rpt_arcflow_sum.time_days,
    rpt_arcflow_sum.time_hour,
    rpt_arcflow_sum.max_veloc,
    rpt_arcflow_sum.mfull_flow,
    rpt_arcflow_sum.mfull_depth,
    rpt_arcflow_sum.max_shear,
    rpt_arcflow_sum.max_hr,
    rpt_arcflow_sum.max_slope,
    rpt_arcflow_sum.day_max,
    rpt_arcflow_sum.time_max,
    rpt_arcflow_sum.min_shear,
    rpt_arcflow_sum.day_min,
    rpt_arcflow_sum.time_min
   FROM inp_orifice
     LEFT JOIN rpt_arcflow_sum USING (arc_id);


-- 04/12/2024
CREATE OR REPLACE VIEW v_edit_cat_dwf
AS SELECT DISTINCT ON (c.id) c.id,
    c.idval,
    c.startdate,
    c.enddate,
    c.observ,
    c.expl_id,
    c.active,
    c.log
   FROM cat_dwf c,
    selector_expl s
  WHERE s.expl_id = c.expl_id AND s.cur_user = CURRENT_USER OR c.expl_id IS NULL;

CREATE OR REPLACE VIEW ve_epa_storage
AS SELECT inp_storage.node_id,
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
    v_rpt_storagevol_sum.aver_vol,
    v_rpt_storagevol_sum.avg_full,
    v_rpt_storagevol_sum.ei_loss,
    v_rpt_storagevol_sum.max_vol,
    v_rpt_storagevol_sum.max_full,
    v_rpt_storagevol_sum.time_days,
    v_rpt_storagevol_sum.time_hour,
    v_rpt_storagevol_sum.max_out
   FROM inp_storage
    LEFT JOIN v_rpt_storagevol_sum USING (node_id);

--12/12/2024

--v_rpt_comp_nodedepth_sum
CREATE OR REPLACE VIEW v_rpt_comp_nodedepth_sum
AS  WITH main AS (
	SELECT rpt_nodedepth_sum.id,
    rpt_nodedepth_sum.result_id,
    rpt_nodedepth_sum.node_id,
    rpt_inp_node.node_type::text,
    rpt_inp_node.nodecat_id,
    rpt_nodedepth_sum.swnod_type,
    rpt_nodedepth_sum.aver_depth,
    rpt_nodedepth_sum.max_depth,
    rpt_nodedepth_sum.max_hgl,
    rpt_nodedepth_sum.time_days,
    rpt_nodedepth_sum.time_hour,
    rpt_inp_node.sector_id,
    rpt_inp_node.the_geom
	FROM selector_rpt_main,
    rpt_inp_node
	JOIN rpt_nodedepth_sum ON rpt_nodedepth_sum.node_id::text = rpt_inp_node.node_id::text
	WHERE rpt_nodedepth_sum.result_id::text = selector_rpt_main.result_id::text AND selector_rpt_main.cur_user = "current_user"()::text AND rpt_inp_node.result_id::text = selector_rpt_main.result_id::text),
compare AS (
	SELECT rpt_nodedepth_sum.id,
    rpt_nodedepth_sum.result_id,
    rpt_nodedepth_sum.node_id,
    rpt_inp_node.node_type::text,
    rpt_inp_node.nodecat_id,
    rpt_nodedepth_sum.swnod_type,
    rpt_nodedepth_sum.aver_depth,
    rpt_nodedepth_sum.max_depth,
    rpt_nodedepth_sum.max_hgl,
    rpt_nodedepth_sum.time_days,
    rpt_nodedepth_sum.time_hour,
    rpt_inp_node.sector_id,
    rpt_inp_node.the_geom
	FROM selector_rpt_compare,
    rpt_inp_node
    JOIN rpt_nodedepth_sum ON rpt_nodedepth_sum.node_id::text = rpt_inp_node.node_id::text
	WHERE rpt_nodedepth_sum.result_id::text = selector_rpt_compare.result_id::text AND selector_rpt_compare.cur_user = "current_user"()::text AND rpt_inp_node.result_id::text = selector_rpt_compare.result_id::text)

SELECT main.node_id,
    main.sector_id,
    main.node_type::text,
    main.nodecat_id,
    main.swnod_type,
    main.result_id AS result_id_main,
    compare.result_id AS result_id_compare,
    main.aver_depth AS aver_depth_main,
    compare.aver_depth AS aver_depth_compare,
    main.aver_depth - compare.aver_depth AS aver_depth_diff,
    main.max_depth AS max_depth_main,
    compare.max_depth AS max_depth_compare,
    main.max_depth - compare.max_depth AS max_depth_diff,
    main.max_hgl AS max_hgl_main,
    compare.max_hgl AS max_hgl_compare,
    main.max_hgl - compare.max_hgl AS max_hgl_diff,
    main.time_days AS time_days_main,
    compare.time_days AS time_days_compare,
    main.time_hour AS time_hour_main,
    compare.time_hour AS time_hour_compare,
    main.the_geom
	FROM main LEFT JOIN compare ON main.node_id = compare.node_id

	UNION

	SELECT compare.node_id,
    compare.sector_id,
    compare.node_type::text,
    compare.nodecat_id,
    compare.swnod_type,
    main.result_id AS result_id_main,
    compare.result_id AS result_id_compare,
    main.aver_depth AS aver_depth_main,
    compare.aver_depth AS aver_depth_compare,
    main.aver_depth - compare.aver_depth AS aver_depth_diff,
    main.max_depth AS max_depth_main,
    compare.max_depth AS max_depth_compare,
    main.max_depth - compare.max_depth AS max_depth_diff,
    main.max_hgl AS max_hgl_main,
    compare.max_hgl AS max_hgl_compare,
    main.max_hgl - compare.max_hgl AS max_hgl_diff,
    main.time_days AS time_days_main,
    compare.time_days AS time_days_compare,
    main.time_hour AS time_hour_main,
    compare.time_hour AS time_hour_compare,
    compare.the_geom
	FROM main RIGHT JOIN compare ON main.node_id = compare.node_id;

--v_rpt_comp_nodeinflow_sum
CREATE OR REPLACE VIEW v_rpt_comp_nodeinflow_sum
AS
WITH main AS (
	SELECT rpt_inp_node.id,
    rpt_nodeinflow_sum.node_id,
    rpt_nodeinflow_sum.result_id,
    rpt_inp_node.node_type::text,
    rpt_inp_node.nodecat_id,
    rpt_nodeinflow_sum.swnod_type,
    rpt_nodeinflow_sum.max_latinf,
    rpt_nodeinflow_sum.max_totinf,
    rpt_nodeinflow_sum.time_days,
    rpt_nodeinflow_sum.time_hour,
    rpt_nodeinflow_sum.latinf_vol,
    rpt_nodeinflow_sum.totinf_vol,
    rpt_nodeinflow_sum.flow_balance_error,
    rpt_inp_node.sector_id,
    rpt_inp_node.the_geom
   FROM selector_rpt_main,
    rpt_inp_node
     JOIN rpt_nodeinflow_sum ON rpt_nodeinflow_sum.node_id::text = rpt_inp_node.node_id::text
  WHERE rpt_nodeinflow_sum.result_id::text = selector_rpt_main.result_id::text AND selector_rpt_main.cur_user = "current_user"()::text AND rpt_inp_node.result_id::text = selector_rpt_main.result_id::text),

 compare AS (
	SELECT rpt_nodeinflow_sum.id,
    rpt_nodeinflow_sum.result_id,
    rpt_nodeinflow_sum.node_id,
    rpt_inp_node.node_type::text,
    rpt_inp_node.nodecat_id,
    rpt_nodeinflow_sum.swnod_type,
    rpt_nodeinflow_sum.max_latinf,
    rpt_nodeinflow_sum.max_totinf,
    rpt_nodeinflow_sum.time_days,
    rpt_nodeinflow_sum.time_hour,
    rpt_nodeinflow_sum.latinf_vol,
    rpt_nodeinflow_sum.totinf_vol,
    rpt_nodeinflow_sum.flow_balance_error,
    rpt_inp_node.sector_id,
    rpt_inp_node.the_geom
	FROM selector_rpt_compare,
    rpt_inp_node
    JOIN rpt_nodeinflow_sum ON rpt_nodeinflow_sum.node_id::text = rpt_inp_node.node_id::text
	WHERE rpt_nodeinflow_sum.result_id::text = selector_rpt_compare.result_id::text AND selector_rpt_compare.cur_user = "current_user"()::text AND rpt_inp_node.result_id::text = selector_rpt_compare.result_id::text)
 SELECT
    main.node_id,
    main.sector_id,
    main.node_type,
    main.nodecat_id,
    main.swnod_type,
    main.result_id AS result_id_main,
    compare.result_id AS result_id_compare,
    main.max_latinf AS max_latinf_main,
    compare.max_latinf AS max_latinf_compare,
    main.max_latinf - compare.max_latinf AS max_latinf_diff,
    main.max_totinf AS max_totinf_main,
    compare.max_totinf AS max_totinf_compare,
    main.max_totinf - compare.max_totinf AS max_totinf_diff,
    main.latinf_vol AS latinf_vol_main,
    compare.latinf_vol AS latinf_vol_compare,
    main.latinf_vol - compare.latinf_vol AS latinf_vol_diff,
    main.totinf_vol AS totninf_vol_main,
    compare.totinf_vol AS totninf_vol_compare,
    main.totinf_vol - compare.totinf_vol AS totninf_vol_diff,
    main.flow_balance_error AS flow_balance_error_main,
    compare.flow_balance_error AS flow_balance_error_compare,
    main.flow_balance_error - compare.flow_balance_error AS flow_balance_error_diff,
    main.time_days AS time_days_main,
    compare.time_days AS time_days_compare,
    main.time_hour AS time_hour_main,
    compare.time_hour AS time_hour_compare,
    main.the_geom
	FROM main LEFT JOIN compare ON main.node_id = compare.node_id

	UNION

	SELECT
    compare.node_id,
    compare.sector_id,
    compare.node_type,
    compare.nodecat_id,
    compare.swnod_type,
    main.result_id AS result_id_main,
    compare.result_id AS result_id_compare,
    main.max_latinf AS max_latinf_main,
    compare.max_latinf AS max_latinf_compare,
    main.max_latinf - compare.max_latinf AS max_latinf_diff,
    main.max_totinf AS max_totinf_main,
    compare.max_totinf AS max_totinf_compare,
    main.max_totinf - compare.max_totinf AS max_totinf_diff,
    main.latinf_vol AS latinf_vol_main,
    compare.latinf_vol AS latinf_vol_compare,
    main.latinf_vol - compare.latinf_vol AS latinf_vol_diff,
    main.totinf_vol AS totninf_vol_main,
    compare.totinf_vol AS totninf_vol_compare,
    main.totinf_vol - compare.totinf_vol AS totninf_vol_diff,
    main.flow_balance_error AS flow_balance_error_main,
    compare.flow_balance_error AS flow_balance_error_compare,
    main.flow_balance_error - compare.flow_balance_error AS flow_balance_error_diff,
    main.time_days AS time_days_main,
    compare.time_days AS time_days_compare,
    main.time_hour AS time_hour_main,
    compare.time_hour AS time_hour_compare,
    compare.the_geom
	FROM main RIGHT JOIN compare ON main.node_id = compare.node_id;

-- v_rpt_comp_nodeflooding_sum
CREATE OR REPLACE VIEW v_rpt_comp_nodeflooding_sum
AS
WITH main AS (
	SELECT rpt_inp_node.id,
    rpt_nodeflooding_sum.node_id,
    selector_rpt_main.result_id,
    rpt_inp_node.node_type::text,
    rpt_inp_node.nodecat_id,
    rpt_nodeflooding_sum.hour_flood,
    rpt_nodeflooding_sum.max_rate,
    rpt_nodeflooding_sum.time_days,
    rpt_nodeflooding_sum.time_hour,
    rpt_nodeflooding_sum.tot_flood,
    rpt_nodeflooding_sum.max_ponded,
    rpt_inp_node.sector_id,
    rpt_inp_node.the_geom
	FROM selector_rpt_main,
    rpt_inp_node
    JOIN rpt_nodeflooding_sum ON rpt_nodeflooding_sum.node_id::text = rpt_inp_node.node_id::text
	WHERE rpt_nodeflooding_sum.result_id::text = selector_rpt_main.result_id::text AND selector_rpt_main.cur_user = "current_user"()::text AND rpt_inp_node.result_id::text = selector_rpt_main.result_id::TEXT),

 compare AS (
	SELECT rpt_nodeflooding_sum.id,
    selector_rpt_compare.result_id,
    rpt_nodeflooding_sum.node_id,
    rpt_inp_node.node_type::text,
    rpt_inp_node.nodecat_id,
    rpt_nodeflooding_sum.hour_flood,
    rpt_nodeflooding_sum.max_rate,
    rpt_nodeflooding_sum.time_days,
    rpt_nodeflooding_sum.time_hour,
    rpt_nodeflooding_sum.tot_flood,
    rpt_nodeflooding_sum.max_ponded,
    rpt_inp_node.sector_id,
    rpt_inp_node.the_geom
	FROM selector_rpt_compare,
    rpt_inp_node
	JOIN rpt_nodeflooding_sum ON rpt_nodeflooding_sum.node_id::text = rpt_inp_node.node_id::text
	WHERE rpt_nodeflooding_sum.result_id::text = selector_rpt_compare.result_id::text AND selector_rpt_compare.cur_user = "current_user"()::text AND rpt_inp_node.result_id::text = selector_rpt_compare.result_id::text)

 SELECT
    main.node_id,
    main.sector_id,
    main.node_type::text,
    main.nodecat_id,
    main.result_id AS result_id_main,
    compare.result_id AS result_id_compare,
    main.hour_flood AS hour_flood_main,
    compare.hour_flood AS hour_flood_compare,
    main.hour_flood - compare.hour_flood AS hour_flood_diff,
    main.max_rate AS max_rate_main,
    compare.max_rate AS max_rate_compare,
    main.max_rate - compare.max_rate AS max_rate_diff,
    main.tot_flood AS tot_flood_main,
    compare.tot_flood AS tot_flood_compare,
    main.tot_flood - compare.tot_flood AS tot_flood_diff,
    main.max_ponded AS max_ponded_main,
    compare.max_ponded AS max_ponded_compare,
    main.max_ponded - compare.max_ponded AS max_ponded_diff,
    main.time_days AS time_days_main,
    compare.time_days AS time_days_compare,
    main.time_hour AS time_hour_main,
    compare.time_hour AS time_hour_compare,
    main.the_geom
	FROM main LEFT JOIN compare ON main.node_id = compare.node_id

	UNION

	 SELECT
    compare.node_id,
    compare.sector_id,
    compare.node_type::text,
    compare.nodecat_id,
    main.result_id AS result_id_main,
    compare.result_id AS result_id_compare,
    main.hour_flood AS hour_flood_main,
    compare.hour_flood AS hour_flood_compare,
    main.hour_flood - compare.hour_flood AS hour_flood_diff,
    main.max_rate AS max_rate_main,
    compare.max_rate AS max_rate_compare,
    main.max_rate - compare.max_rate AS max_rate_diff,
    main.tot_flood AS tot_flood_main,
    compare.tot_flood AS tot_flood_compare,
    main.tot_flood - compare.tot_flood AS tot_flood_diff,
    main.max_ponded AS max_ponded_main,
    compare.max_ponded AS max_ponded_compare,
    main.max_ponded - compare.max_ponded AS max_ponded_diff,
    main.time_days AS time_days_main,
    compare.time_days AS time_days_compare,
    main.time_hour AS time_hour_main,
    compare.time_hour AS time_hour_compare,
    compare.the_geom
	FROM main RIGHT JOIN compare ON main.node_id = compare.node_id;

--v_rpt_comp_nodesurcharge_sum
CREATE OR REPLACE VIEW v_rpt_comp_nodesurcharge_sum
AS
WITH main AS (
	SELECT rpt_inp_node.id,
    rpt_inp_node.node_id,
    rpt_nodesurcharge_sum.result_id,
    rpt_inp_node.node_type::text,
    rpt_inp_node.nodecat_id,
    rpt_nodesurcharge_sum.swnod_type,
    rpt_nodesurcharge_sum.hour_surch,
    rpt_nodesurcharge_sum.max_height,
    rpt_nodesurcharge_sum.min_depth,
    rpt_inp_node.sector_id,
    rpt_inp_node.the_geom
	FROM selector_rpt_main,
    rpt_inp_node
    JOIN rpt_nodesurcharge_sum ON rpt_nodesurcharge_sum.node_id::text = rpt_inp_node.node_id::text
	WHERE rpt_nodesurcharge_sum.result_id::text = selector_rpt_main.result_id::text AND selector_rpt_main.cur_user = "current_user"()::text AND rpt_inp_node.result_id::text = selector_rpt_main.result_id::TEXT),
 compare AS (
	SELECT rpt_nodesurcharge_sum.id,
    rpt_nodesurcharge_sum.result_id,
    rpt_inp_node.node_id,
    rpt_inp_node.node_type::text,
    rpt_inp_node.nodecat_id,
    rpt_nodesurcharge_sum.swnod_type,
    rpt_nodesurcharge_sum.hour_surch,
    rpt_nodesurcharge_sum.max_height,
    rpt_nodesurcharge_sum.min_depth,
    rpt_inp_node.sector_id,
    rpt_inp_node.the_geom
	FROM selector_rpt_compare,
    rpt_inp_node
    JOIN rpt_nodesurcharge_sum ON rpt_nodesurcharge_sum.node_id::text = rpt_inp_node.node_id::text
	WHERE rpt_nodesurcharge_sum.result_id::text = selector_rpt_compare.result_id::text AND selector_rpt_compare.cur_user = "current_user"()::text AND rpt_inp_node.result_id::text = selector_rpt_compare.result_id::text)

 SELECT
    main.node_id,
    main.sector_id,
    main.node_type::text,
    main.nodecat_id,
    main.swnod_type,
    main.result_id AS result_id_main,
    compare.result_id AS result_id_compare,
    main.hour_surch AS hour_surch_main,
    compare.hour_surch AS hour_surch_compare,
    main.hour_surch - compare.hour_surch AS hour_surch_diff,
    main.max_height AS max_height_main,
    compare.max_height AS max_height_compare,
    main.max_height - compare.max_height AS max_height_diff,
    main.min_depth AS min_depth_main,
    compare.min_depth AS min_depth_compare,
    main.min_depth - compare.min_depth AS min_depth_diff,
    main.the_geom
	FROM main LEFT JOIN compare ON main.node_id = compare.node_id

	UNION

	SELECT
    compare.node_id,
    compare.sector_id,
    compare.node_type::text,
    compare.nodecat_id,
    compare.swnod_type,
    main.result_id AS result_id_main,
    compare.result_id AS result_id_compare,
    main.hour_surch AS hour_surch_main,
    compare.hour_surch AS hour_surch_compare,
    main.hour_surch - compare.hour_surch AS hour_surch_diff,
    main.max_height AS max_height_main,
    compare.max_height AS max_height_compare,
    main.max_height - compare.max_height AS max_height_diff,
    main.min_depth AS min_depth_main,
    compare.min_depth AS min_depth_compare,
    main.min_depth - compare.min_depth AS min_depth_diff,
    compare.the_geom
	FROM main RIGHT JOIN compare ON main.node_id = compare.node_id;

-- v_rpt_comp_arcflow_sum
CREATE OR REPLACE VIEW v_rpt_comp_arcflow_sum
AS
WITH main AS (
	SELECT rpt_inp_arc.id,
    rpt_inp_arc.arc_id,
    rpt_inp_arc.result_id,
    rpt_inp_arc.arc_type,
    rpt_inp_arc.arccat_id,
    rpt_inp_arc.sector_id,
    rpt_inp_arc.the_geom,
    rpt_arcflow_sum.arc_type AS swarc_type,
    rpt_arcflow_sum.max_flow,
    rpt_arcflow_sum.time_days,
    rpt_arcflow_sum.time_hour,
    rpt_arcflow_sum.max_veloc,
    COALESCE(rpt_arcflow_sum.mfull_flow, 0::numeric(12,4)) AS mfull_flow,
    COALESCE(rpt_arcflow_sum.mfull_depth, 0::numeric(12,4)) AS mfull_depth,
    rpt_arcflow_sum.max_shear,
    rpt_arcflow_sum.max_hr,
    rpt_arcflow_sum.max_slope,
    rpt_arcflow_sum.day_max,
    rpt_arcflow_sum.time_max,
    rpt_arcflow_sum.min_shear,
    rpt_arcflow_sum.day_min,
    rpt_arcflow_sum.time_min
   	FROM selector_rpt_main,
    rpt_inp_arc
    JOIN rpt_arcflow_sum ON rpt_arcflow_sum.arc_id::text = rpt_inp_arc.arc_id::TEXT
   	WHERE rpt_arcflow_sum.result_id::text = selector_rpt_main.result_id::text AND
   	selector_rpt_main.cur_user = "current_user"()::text AND rpt_inp_arc.result_id::text = selector_rpt_main.result_id::TEXT),

compare AS (
 	SELECT rpt_arcflow_sum.id,
    selector_rpt_compare.result_id,
    rpt_arcflow_sum.arc_id,
    rpt_inp_arc.arc_type,
    rpt_inp_arc.arccat_id,
	rpt_arcflow_sum.arc_type AS swarc_type,
    rpt_arcflow_sum.max_flow,
    rpt_arcflow_sum.time_days,
    rpt_arcflow_sum.time_hour,
    rpt_arcflow_sum.max_veloc,
    rpt_arcflow_sum.mfull_flow,
    rpt_arcflow_sum.mfull_depth,
    rpt_arcflow_sum.max_shear,
    rpt_arcflow_sum.max_hr,
    rpt_arcflow_sum.max_slope,
    rpt_arcflow_sum.day_max,
    rpt_arcflow_sum.time_max,
    rpt_arcflow_sum.min_shear,
    rpt_arcflow_sum.day_min,
    rpt_arcflow_sum.time_min,
    rpt_inp_arc.sector_id,
    rpt_inp_arc.the_geom
   	FROM selector_rpt_compare,
    rpt_inp_arc
    JOIN rpt_arcflow_sum ON rpt_arcflow_sum.arc_id::text = rpt_inp_arc.arc_id::text
  	WHERE rpt_arcflow_sum.result_id::text = selector_rpt_compare.result_id::text AND selector_rpt_compare.cur_user = "current_user"()::text AND rpt_inp_arc.result_id::text = selector_rpt_compare.result_id::TEXT)

  	SELECT
    main.arc_id,
    main.sector_id,
    main.arc_type,
    main.arccat_id,
    main.swarc_type,
    main.result_id AS result_id_main,
    compare.result_id AS result_id_compare,
    main.max_flow AS max_flow_main,
    compare.max_flow AS max_flow_compare,
    main.max_flow - compare.max_flow AS max_flow_diff,
    main.max_veloc AS max_veloc_main,
    compare.max_veloc AS max_veloc_compare,
    main.max_veloc - compare.max_veloc AS max_veloc_diff,
    main.mfull_flow AS mfull_flow_main,
    compare.mfull_flow AS mfull_flow_compare,
    main.mfull_flow - compare.mfull_flow AS mfull_flow_diff,
    main.mfull_depth AS mfull_depth_main,
    compare.mfull_depth AS mfull_depth_compare,
    main.mfull_depth - compare.mfull_depth AS mfull_depth_diff,
    main.max_shear AS max_shear_main,
    compare.max_shear AS max_shear_compare,
    main.max_shear - compare.max_shear AS max_shear_diff,
    main.max_hr AS max_hr_main,
    compare.max_hr AS max_hr_compare,
    main.max_hr - compare.max_hr AS max_hr_diff,
    main.max_slope AS max_slope_main,
    compare.max_slope AS max_slope_compare,
    main.max_slope - compare.max_slope AS max_slope_diff,
    main.day_max AS day_max_main,
    compare.day_max AS day_max_compare,
    main.time_max AS time_max_main,
    compare.time_max AS time_max_compare,
    main.min_shear AS min_shear_main,
    compare.min_shear AS min_shear_compare,
    main.min_shear - compare.min_shear AS min_shear_diff,
    main.day_min AS day_min_main,
    compare.day_min AS day_min_compare,
    main.time_min AS time_min_main,
    compare.time_min AS time_min_compare,
    main.time_days AS time_days_main,
    compare.time_days AS time_days_compare,
    main.time_hour AS time_hour_main,
    compare.time_hour AS time_hour_compare,
    main.the_geom
    FROM main LEFT JOIN compare ON main.arc_id = compare.arc_id

	UNION

	SELECT
    compare.arc_id,
    compare.sector_id,
    compare.arc_type,
    compare.arccat_id,
    compare.swarc_type,
    main.result_id AS result_id_main,
    compare.result_id AS result_id_compare,
    main.max_flow AS max_flow_main,
    compare.max_flow AS max_flow_compare,
    main.max_flow - compare.max_flow AS max_flow_diff,
    main.max_veloc AS max_veloc_main,
    compare.max_veloc AS max_veloc_compare,
    main.max_veloc - compare.max_veloc AS max_veloc_diff,
    main.mfull_flow AS mfull_flow_main,
    compare.mfull_flow AS mfull_flow_compare,
    main.mfull_flow - compare.mfull_flow AS mfull_flow_diff,
    main.mfull_depth AS mfull_depth_main,
    compare.mfull_depth AS mfull_depth_compare,
    main.mfull_depth - compare.mfull_depth AS mfull_depth_diff,
    main.max_shear AS max_shear_main,
    compare.max_shear AS max_shear_compare,
    main.max_shear - compare.max_shear AS max_shear_diff,
    main.max_hr AS max_hr_main,
    compare.max_hr AS max_hr_compare,
    main.max_hr - compare.max_hr AS max_hr_diff,
    main.max_slope AS max_slope_main,
    compare.max_slope AS max_slope_compare,
    main.max_slope - compare.max_slope AS max_slope_diff,
    main.day_max AS day_max_main,
    compare.day_max AS day_max_compare,
    main.time_max AS time_max_main,
    compare.time_max AS time_max_compare,
    main.min_shear AS min_shear_main,
    compare.min_shear AS min_shear_compare,
    main.min_shear - compare.min_shear AS min_shear_diff,
    main.day_min AS day_min_main,
    compare.day_min AS day_min_compare,
    main.time_min AS time_min_main,
    compare.time_min AS time_min_compare,
    main.time_days AS time_days_main,
    compare.time_days AS time_days_compare,
    main.time_hour AS time_hour_main,
    compare.time_hour AS time_hour_compare,
    compare.the_geom
    FROM main RIGHT JOIN compare ON main.arc_id = compare.arc_id;


----v_rpt_comp_condsurcharge_sum
CREATE OR REPLACE VIEW v_rpt_comp_condsurcharge_sum
AS
WITH main AS (
	SELECT rpt_inp_arc.id,
    rpt_inp_arc.arc_id,
    rpt_inp_arc.result_id,
    rpt_inp_arc.arc_type,
    rpt_inp_arc.arccat_id,
    rpt_inp_arc.sector_id,
    rpt_inp_arc.the_geom,
    rpt_condsurcharge_sum.both_ends,
    rpt_condsurcharge_sum.upstream,
    rpt_condsurcharge_sum.dnstream,
    rpt_condsurcharge_sum.hour_nflow,
    rpt_condsurcharge_sum.hour_limit
   	FROM selector_rpt_main,
    rpt_inp_arc
    JOIN rpt_condsurcharge_sum ON rpt_condsurcharge_sum.arc_id::text = rpt_inp_arc.arc_id::text
  	WHERE rpt_condsurcharge_sum.result_id::text = selector_rpt_main.result_id::text AND selector_rpt_main.cur_user = "current_user"()::text AND rpt_inp_arc.result_id::text = selector_rpt_main.result_id::TEXT),

compare AS (
 	SELECT rpt_condsurcharge_sum.id,
    rpt_condsurcharge_sum.result_id,
    rpt_condsurcharge_sum.arc_id,
    rpt_inp_arc.arc_type,
    rpt_inp_arc.arccat_id,
    rpt_condsurcharge_sum.both_ends,
    rpt_condsurcharge_sum.upstream,
    rpt_condsurcharge_sum.dnstream,
    rpt_condsurcharge_sum.hour_nflow,
    rpt_condsurcharge_sum.hour_limit,
    rpt_inp_arc.sector_id,
    rpt_inp_arc.the_geom
    FROM selector_rpt_compare,
    rpt_inp_arc
    JOIN rpt_condsurcharge_sum ON rpt_condsurcharge_sum.arc_id::text = rpt_inp_arc.arc_id::text
    WHERE rpt_condsurcharge_sum.result_id::text = selector_rpt_compare.result_id::text AND selector_rpt_compare.cur_user = "current_user"()::text AND rpt_inp_arc.result_id::text = selector_rpt_compare.result_id::text)

    SELECT
    main.arc_id,
    main.sector_id,
    main.arc_type,
    main.arccat_id,
    main.result_id AS result_id_main,
    compare.result_id AS result_id_compare,
    main.both_ends AS both_ends_main,
    compare.both_ends AS both_ends_compare,
    main.both_ends - compare.both_ends AS both_ends_diff,
    main.upstream AS upstream_main,
    compare.upstream AS upstream_compare,
    main.upstream - compare.upstream AS upstream_diff,
    main.dnstream AS dnstream_main,
    compare.dnstream AS dnstream_compare,
    main.dnstream - compare.dnstream AS dnstream_diff,
    main.hour_nflow AS hour_nflow_main,
    compare.hour_nflow AS hour_nflow_compare,
    main.hour_nflow - compare.hour_nflow AS hour_nflow_diff,
    main.hour_limit AS hour_limit_main,
    compare.hour_limit AS hour_limit_compare,
    main.hour_limit - compare.hour_limit AS hour_limit_diff,
    main.the_geom
    FROM main LEFT JOIN compare ON main.arc_id = compare.arc_id

    UNION

    SELECT
    compare.arc_id,
    compare.sector_id,
    compare.arc_type,
    compare.arccat_id,
    main.result_id AS result_id_main,
    compare.result_id AS result_id_compare,
    main.both_ends AS both_ends_main,
    compare.both_ends AS both_ends_compare,
    main.both_ends - compare.both_ends AS both_ends_diff,
    main.upstream AS upstream_main,
    compare.upstream AS upstream_compare,
    main.upstream - compare.upstream AS upstream_diff,
    main.dnstream AS dnstream_main,
    compare.dnstream AS dnstream_compare,
    main.dnstream - compare.dnstream AS dnstream_diff,
    main.hour_nflow AS hour_nflow_main,
    compare.hour_nflow AS hour_nflow_compare,
    main.hour_nflow - compare.hour_nflow AS hour_nflow_diff,
    main.hour_limit AS hour_limit_main,
    compare.hour_limit AS hour_limit_compare,
    main.hour_limit - compare.hour_limit AS hour_limit_diff,
    compare.the_geom
    FROM main RIGHT JOIN compare ON main.arc_id = compare.arc_id;


---- v_rpt_comp_pumping_sum
CREATE OR REPLACE VIEW v_rpt_comp_pumping_sum
AS WITH main AS (
	SELECT rpt_pumping_sum.id,
    rpt_pumping_sum.result_id,
    rpt_pumping_sum.arc_id,
    rpt_inp_arc.arc_type,
    rpt_inp_arc.arccat_id,
    rpt_pumping_sum.percent,
    rpt_pumping_sum.num_startup,
    rpt_pumping_sum.min_flow,
    rpt_pumping_sum.avg_flow,
    rpt_pumping_sum.max_flow,
    rpt_pumping_sum.vol_ltr,
    rpt_pumping_sum.powus_kwh,
    rpt_pumping_sum.timoff_min,
    rpt_pumping_sum.timoff_max,
    rpt_inp_arc.sector_id,
    rpt_inp_arc.the_geom
	FROM selector_rpt_main,
    rpt_inp_arc
    JOIN rpt_pumping_sum ON rpt_pumping_sum.arc_id::text = rpt_inp_arc.arc_id::text
	WHERE rpt_pumping_sum.result_id::text = selector_rpt_main.result_id::text AND selector_rpt_main.cur_user = "current_user"()::text AND rpt_inp_arc.result_id::text = selector_rpt_main.result_id::TEXT),

 compare AS (
 	SELECT rpt_pumping_sum.id,
    rpt_pumping_sum.result_id,
    rpt_pumping_sum.arc_id,
    rpt_inp_arc.arc_type,
    rpt_inp_arc.arccat_id,
    rpt_pumping_sum.percent,
    rpt_pumping_sum.num_startup,
    rpt_pumping_sum.min_flow,
    rpt_pumping_sum.avg_flow,
    rpt_pumping_sum.max_flow,
    rpt_pumping_sum.vol_ltr,
    rpt_pumping_sum.powus_kwh,
    rpt_pumping_sum.timoff_min,
    rpt_pumping_sum.timoff_max,
    rpt_inp_arc.sector_id,
    rpt_inp_arc.the_geom
	FROM selector_rpt_compare,
    rpt_inp_arc
    JOIN rpt_pumping_sum ON rpt_pumping_sum.arc_id::text = rpt_inp_arc.arc_id::text
	WHERE rpt_pumping_sum.result_id::text = selector_rpt_compare.result_id::text AND selector_rpt_compare.cur_user = "current_user"()::text AND rpt_inp_arc.result_id::text = selector_rpt_compare.result_id::text)

  SELECT
    main.arc_id,
    main.sector_id,
    main.arc_type,
    main.arccat_id,
    main.result_id AS result_id_main,
    compare.result_id AS result_id_compare,
    main.percent AS percent_main,
    compare.percent AS percent_compare,
    main.percent - compare.percent AS percent_diff,
    main.num_startup AS num_startup_main,
    compare.num_startup AS num_startup_compare,
    main.num_startup - compare.num_startup AS num_startup_diff,
    main.min_flow AS min_flow_main,
    compare.min_flow AS min_flow_compare,
    main.min_flow - compare.min_flow AS min_flow_diff,
    main.avg_flow AS avg_flow_main,
    compare.avg_flow AS avg_flow_compare,
    main.avg_flow - compare.avg_flow AS avg_flow_diff,
    main.max_flow AS max_flow_main,
    compare.max_flow AS max_flow_compare,
    main.max_flow - compare.max_flow AS max_flow_diff,
    main.vol_ltr AS vol_ltr_main,
    compare.vol_ltr AS vol_ltr_compare,
    main.vol_ltr - compare.vol_ltr AS vol_ltr_diff,
    main.powus_kwh AS powus_kwh_main,
    compare.powus_kwh AS powus_kwh_compare,
    main.powus_kwh - compare.powus_kwh AS powus_kwh_diff,
    main.timoff_min AS timoff_min_main,
    compare.timoff_min AS timoff_min_compare,
    main.timoff_min - compare.timoff_min AS timoff_min_diff,
    main.timoff_max AS timoff_max_main,
    compare.timoff_max AS timoff_max_compare,
    main.timoff_max - compare.timoff_max AS timoff_max_diff,
    main.the_geom
    FROM main LEFT JOIN compare ON main.arc_id = compare.arc_id

	UNION

	SELECT
    compare.arc_id,
    compare.sector_id,
    compare.arc_type,
    compare.arccat_id,
    main.result_id AS result_id_main,
    compare.result_id AS result_id_compare,
    main.percent AS percent_main,
    compare.percent AS percent_compare,
    main.percent - compare.percent AS percent_diff,
    main.num_startup AS num_startup_main,
    compare.num_startup AS num_startup_compare,
    main.num_startup - compare.num_startup AS num_startup_diff,
    main.min_flow AS min_flow_main,
    compare.min_flow AS min_flow_compare,
    main.min_flow - compare.min_flow AS min_flow_diff,
    main.avg_flow AS avg_flow_main,
    compare.avg_flow AS avg_flow_compare,
    main.avg_flow - compare.avg_flow AS avg_flow_diff,
    main.max_flow AS max_flow_main,
    compare.max_flow AS max_flow_compare,
    main.max_flow - compare.max_flow AS max_flow_diff,
    main.vol_ltr AS vol_ltr_main,
    compare.vol_ltr AS vol_ltr_compare,
    main.vol_ltr - compare.vol_ltr AS vol_ltr_diff,
    main.powus_kwh AS powus_kwh_main,
    compare.powus_kwh AS powus_kwh_compare,
    main.powus_kwh - compare.powus_kwh AS powus_kwh_diff,
    main.timoff_min AS timoff_min_main,
    compare.timoff_min AS timoff_min_compare,
    main.timoff_min - compare.timoff_min AS timoff_min_diff,
    main.timoff_max AS timoff_max_main,
    compare.timoff_max AS timoff_max_compare,
    main.timoff_max - compare.timoff_max AS timoff_max_diff,
    compare.the_geom
    FROM main RIGHT JOIN compare ON main.arc_id = compare.arc_id; ;

---- v_rpt_comp_flowclass_sum
CREATE OR REPLACE VIEW v_rpt_comp_flowclass_sum
AS WITH main AS (
	SELECT rpt_flowclass_sum.id,
    rpt_flowclass_sum.result_id,
    rpt_flowclass_sum.arc_id,
    rpt_inp_arc.arc_type,
    rpt_inp_arc.arccat_id,
    rpt_flowclass_sum.length,
    rpt_flowclass_sum.dry,
    rpt_flowclass_sum.up_dry,
    rpt_flowclass_sum.down_dry,
    rpt_flowclass_sum.sub_crit,
    rpt_flowclass_sum.sub_crit_1,
    rpt_flowclass_sum.up_crit,
    rpt_inp_arc.sector_id,
    rpt_inp_arc.the_geom
   	FROM selector_rpt_main,
    rpt_inp_arc
    JOIN rpt_flowclass_sum ON rpt_flowclass_sum.arc_id::text = rpt_inp_arc.arc_id::text
	WHERE rpt_flowclass_sum.result_id::text = selector_rpt_main.result_id::text AND selector_rpt_main.cur_user = "current_user"()::text AND rpt_inp_arc.result_id::text = selector_rpt_main.result_id::TEXT),

 compare AS (
 	SELECT rpt_flowclass_sum.id,
    rpt_flowclass_sum.result_id,
    rpt_flowclass_sum.arc_id,
    rpt_inp_arc.arc_type,
    rpt_inp_arc.arccat_id,
    rpt_flowclass_sum.length,
    rpt_flowclass_sum.dry,
    rpt_flowclass_sum.up_dry,
    rpt_flowclass_sum.down_dry,
    rpt_flowclass_sum.sub_crit,
    rpt_flowclass_sum.sub_crit_1,
    rpt_flowclass_sum.up_crit,
    rpt_inp_arc.sector_id,
    rpt_inp_arc.the_geom
   	FROM selector_rpt_compare,
    rpt_inp_arc
    JOIN rpt_flowclass_sum ON rpt_flowclass_sum.arc_id::text = rpt_inp_arc.arc_id::text
  	WHERE rpt_flowclass_sum.result_id::text = selector_rpt_compare.result_id::text AND selector_rpt_compare.cur_user = "current_user"()::text AND rpt_inp_arc.result_id::text = selector_rpt_compare.result_id::text)

SELECT
    main.arc_id,
    main.sector_id,
    main.arc_type,
    main.arccat_id,
    main.result_id AS result_id_main,
    compare.result_id AS result_id_compare,
    main.length AS length_main,
    compare.length AS length_compare,
    main.length - compare.length AS length_diff,
    main.dry AS dry_main,
    compare.dry AS dry_compare,
    main.dry - compare.dry AS dry_diff,
    main.up_dry AS up_dry_main,
    compare.up_dry AS up_dry_compare,
    main.up_dry - compare.up_dry AS up_dry_diff,
    main.down_dry AS down_dry_main,
    compare.down_dry AS down_dry_compare,
    main.down_dry - compare.down_dry AS down_dry_diff,
    main.sub_crit AS sub_crit_main,
    compare.sub_crit AS sub_crit_compare,
    main.sub_crit - compare.sub_crit AS sub_crit_diff,
    main.sub_crit_1 AS sub_crit_1_main,
    compare.sub_crit_1 AS sub_crit_1_compare,
    main.sub_crit_1 - compare.sub_crit_1 AS sub_crit_1_diff,
    main.up_crit AS up_crit_main,
    compare.up_crit AS up_crit_compare,
    main.up_crit - compare.up_crit AS up_crit_diff,
    main.the_geom
	FROM main LEFT JOIN compare ON main.arc_id = compare.arc_id

	UNION

	SELECT
    compare.arc_id,
    compare.sector_id,
    compare.arc_type,
    compare.arccat_id,
    main.result_id AS result_id_main,
    compare.result_id AS result_id_compare,
    main.length AS length_main,
    compare.length AS length_compare,
    main.length - compare.length AS length_diff,
    main.dry AS dry_main,
    compare.dry AS dry_compare,
    main.dry - compare.dry AS dry_diff,
    main.up_dry AS up_dry_main,
    compare.up_dry AS up_dry_compare,
    main.up_dry - compare.up_dry AS up_dry_diff,
    main.down_dry AS down_dry_main,
    compare.down_dry AS down_dry_compare,
    main.down_dry - compare.down_dry AS down_dry_diff,
    main.sub_crit AS sub_crit_main,
    compare.sub_crit AS sub_crit_compare,
    main.sub_crit - compare.sub_crit AS sub_crit_diff,
    main.sub_crit_1 AS sub_crit_1_main,
    compare.sub_crit_1 AS sub_crit_1_compare,
    main.sub_crit_1 - compare.sub_crit_1 AS sub_crit_1_diff,
    main.up_crit AS up_crit_main,
    compare.up_crit AS up_crit_compare,
    main.up_crit - compare.up_crit AS up_crit_diff,
    compare.the_geom
	FROM main RIGHT JOIN compare ON main.arc_id = compare.arc_id;

CREATE OR REPLACE VIEW v_anl_arc
AS SELECT anl_arc.id,
    anl_arc.arc_id,
    anl_arc.arccat_id AS arc_type,
    anl_arc.state,
    anl_arc.arc_id_aux,
    anl_arc.fid AS fprocesscat_id,
    exploitation.name AS expl_name,
    anl_arc.the_geom,
    anl_arc.result_id,
    anl_arc.descript
   FROM selector_audit,
    anl_arc
     JOIN exploitation ON anl_arc.expl_id = exploitation.expl_id
  WHERE anl_arc.fid = selector_audit.fid AND selector_audit.cur_user = "current_user"()::text AND anl_arc.cur_user::name = "current_user"();

CREATE OR REPLACE VIEW v_anl_arc_point
AS SELECT anl_arc.id,
    anl_arc.arc_id,
    anl_arc.arccat_id AS arc_type,
    anl_arc.state,
    anl_arc.arc_id_aux,
    anl_arc.fid AS fprocesscat_id,
    exploitation.name AS expl_name,
    anl_arc.the_geom_p
   FROM selector_audit,
    anl_arc
     JOIN sys_fprocess ON anl_arc.fid = sys_fprocess.fid
     JOIN exploitation ON anl_arc.expl_id = exploitation.expl_id
  WHERE anl_arc.fid = selector_audit.fid AND selector_audit.cur_user = "current_user"()::text AND anl_arc.cur_user::name = "current_user"();

CREATE OR REPLACE VIEW v_anl_arc_x_node
AS SELECT anl_arc_x_node.id,
    anl_arc_x_node.arc_id,
    anl_arc_x_node.arccat_id AS arc_type,
    anl_arc_x_node.state,
    anl_arc_x_node.node_id,
    anl_arc_x_node.fid AS fprocesscat_id,
    exploitation.name AS expl_name,
    anl_arc_x_node.the_geom
   FROM selector_audit,
    anl_arc_x_node
     JOIN exploitation ON anl_arc_x_node.expl_id = exploitation.expl_id
  WHERE anl_arc_x_node.fid = selector_audit.fid AND selector_audit.cur_user = "current_user"()::text AND anl_arc_x_node.cur_user::name = "current_user"();

CREATE OR REPLACE VIEW v_anl_arc_x_node_point
AS SELECT anl_arc_x_node.id,
    anl_arc_x_node.arc_id,
    anl_arc_x_node.arccat_id AS arc_type,
    anl_arc_x_node.node_id,
    anl_arc_x_node.fid AS fprocesscat_id,
    exploitation.name AS expl_name,
    anl_arc_x_node.the_geom_p
   FROM selector_audit,
    anl_arc_x_node
     JOIN exploitation ON anl_arc_x_node.expl_id = exploitation.expl_id
  WHERE anl_arc_x_node.fid = selector_audit.fid AND selector_audit.cur_user = "current_user"()::text AND anl_arc_x_node.cur_user::name = "current_user"();

CREATE OR REPLACE VIEW v_anl_node
AS SELECT anl_node.id,
    anl_node.node_id,
    anl_node.nodecat_id,
    anl_node.state,
    anl_node.node_id_aux,
    anl_node.nodecat_id_aux AS state_aux,
    anl_node.num_arcs,
    anl_node.fid AS fprocesscat_id,
    exploitation.name AS expl_name,
    anl_node.the_geom,
    anl_node.result_id,
    anl_node.descript
   FROM selector_audit,
    anl_node
     JOIN exploitation ON anl_node.expl_id = exploitation.expl_id
  WHERE anl_node.fid = selector_audit.fid AND selector_audit.cur_user = "current_user"()::text AND anl_node.cur_user::name = "current_user"();

CREATE OR REPLACE VIEW v_anl_connec
AS SELECT anl_connec.id,
    anl_connec.connec_id,
    anl_connec.conneccat_id AS connecat_id,
    anl_connec.state,
    anl_connec.connec_id_aux,
    anl_connec.connecat_id_aux AS state_aux,
    anl_connec.fid AS fprocesscat_id,
    exploitation.name AS expl_name,
    anl_connec.the_geom,
    anl_connec.result_id,
    anl_connec.descript
   FROM selector_audit,
    anl_connec
     JOIN exploitation ON anl_connec.expl_id = exploitation.expl_id
  WHERE anl_connec.fid = selector_audit.fid AND selector_audit.cur_user = "current_user"()::text AND anl_connec.cur_user::name = "current_user"();


CREATE OR REPLACE VIEW v_edit_inp_coverage
AS SELECT c.subc_id,
    c.landus_id,
    c.percent,
    c.hydrology_id
   FROM selector_sector,
    config_param_user,
    inp_coverage c
     JOIN inp_subcatchment s USING (subc_id)
  WHERE s.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text AND c.hydrology_id = config_param_user.value::integer AND config_param_user.cur_user::text = "current_user"()::text AND config_param_user.parameter::text = 'inp_options_hydrology_scenario'::text;

CREATE OR REPLACE VIEW v_edit_inp_dscenario_lids
AS SELECT sd.dscenario_id,
    l.subc_id,
    l.lidco_id,
    l.numelem,
    l.area,
    l.width,
    l.initsat,
    l.fromimp,
    l.toperv,
    l.rptfile,
    l.descript,
    s.the_geom
   FROM selector_inp_dscenario sd,
    inp_dscenario_lids l
     JOIN v_edit_inp_subcatchment s USING (subc_id)
  WHERE l.dscenario_id = sd.dscenario_id AND sd.cur_user = CURRENT_USER;

CREATE OR REPLACE VIEW v_edit_inp_subc2outlet
AS SELECT a.subc_id,
    a.outlet_id,
    a.outlet_type,
    st_length2d(a.the_geom) AS length,
    a.hydrology_id,
    a.the_geom
   FROM ( SELECT s1.subc_id,
            s1.outlet_id,
            'JUNCTION'::text AS outlet_type,
            s1.hydrology_id,
            st_makeline(st_centroid(s1.the_geom), node.the_geom)::geometry(LineString,SRID_VALUE) AS the_geom
           FROM v_edit_inp_subcatchment s1
             JOIN node ON node.node_id::text = s1.outlet_id::text
        UNION
         SELECT s1.subc_id,
            s1.outlet_id,
            'SUBCATCHMENT'::text AS outlet_type,
            s1.hydrology_id,
            st_makeline(st_centroid(s1.the_geom), st_centroid(s2.the_geom))::geometry(LineString,SRID_VALUE) AS the_geom
           FROM v_edit_inp_subcatchment s1
             JOIN v_edit_inp_subcatchment s2 ON s1.outlet_id::text = s2.subc_id::text) a;


CREATE OR REPLACE VIEW v_ui_drainzone
AS SELECT DISTINCT ON (d.drainzone_id) d.drainzone_id,
    d.code,
    d.name,
    et.idval AS drainzone_type,
    d.descript,
    d.active,
    d.lock_level,
    d.graphconfig,
    d.stylesheet,
    d.link,
    d.expl_id,
    d.created_at,
    d.created_by,
    d.updated_at,
    d.updated_by
   FROM drainzone d
   LEFT JOIN edit_typevalue et ON et.id::text = d.drainzone_type::text AND et.typevalue::text = 'drainzone_type'::text
  WHERE d.drainzone_id > 0
  ORDER BY d.drainzone_id;

CREATE OR REPLACE VIEW v_ui_dwfzone
AS SELECT DISTINCT ON (d.dwfzone_id) d.dwfzone_id,
    d.code,
    d.name,
    et.idval AS dwfzone_type,
    d.descript,
    d.graphconfig,
    d.stylesheet,
    d.link,
    d.expl_id,
    d.lock_level,
    d.active,
    d.created_at,
    d.created_by,
    d.updated_at,
    d.updated_by
   FROM dwfzone d
   LEFT JOIN edit_typevalue et ON et.id::text = d.dwfzone_type::text AND et.typevalue::text = 'dwfzone_type'::text
  WHERE d.dwfzone_id > 0
  ORDER BY d.dwfzone_id;

CREATE OR REPLACE VIEW v_ui_omzone
AS SELECT DISTINCT ON (o.omzone_id) o.omzone_id,
    o.code,
    o.name,
    o.descript,
    et.idval AS omzone_type,
    o.macroomzone_id,
    o.graphconfig,
    o.stylesheet,
    o.link,
    o.expl_id,
    o.lock_level,
    o.active,
    o.created_at,
    o.created_by,
    o.updated_at,
    o.updated_by
   FROM omzone o
   LEFT JOIN edit_typevalue et ON et.id::text = o.omzone_type::text AND et.typevalue::text = 'omzone_type'::text
  WHERE o.omzone_id > 0
  ORDER BY o.omzone_id;

CREATE OR REPLACE VIEW v_ui_macrosector
AS SELECT DISTINCT ON (m.macrosector_id) m.macrosector_id,
    m.code,
    m.name,
    m.descript,
    m.active,
    m.lock_level,
    m.created_at,
    m.created_by,
    m.updated_at,
    m.updated_by
    FROM macrosector m
    WHERE m.macrosector_id > 0
    ORDER BY m.macrosector_id;

CREATE OR REPLACE VIEW v_ui_macroomzone
AS SELECT DISTINCT ON (m.macroomzone_id) m.macroomzone_id,
    m.code,
    m.name,
    m.expl_id,
    m.descript,
    m.active,
    m.lock_level,
    m.created_at,
    m.created_by,
    m.updated_at,
    m.updated_by
    FROM macroomzone m
    WHERE m.macroomzone_id > 0
    ORDER BY m.macroomzone_id;

CREATE OR REPLACE VIEW v_edit_macrosector AS
 SELECT DISTINCT ON (m.macrosector_id) m.macrosector_id,
    m.code,
    m.name,
    m.descript,
    m.the_geom,
    m.lock_level,
    m.created_at,
    m.created_by,
    m.updated_at,
    m.updated_by
   FROM selector_sector, sector
     JOIN macrosector m ON m.macrosector_id = sector.macrosector_id
  WHERE sector.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text;

CREATE OR REPLACE VIEW v_edit_inp_timeseries
AS SELECT DISTINCT p.id,
    p.timser_type,
    p.times_type,
    p.descript,
    p.fname,
    p.expl_id,
    p.log,
    p.active,
    p.addparam::text
   FROM selector_expl s,
    inp_timeseries p
  WHERE p.expl_id = s.expl_id AND s.cur_user = "current_user"()::text OR p.expl_id IS NULL
  ORDER BY p.id;

CREATE OR REPLACE VIEW v_edit_inp_timeseries_value
AS SELECT DISTINCT p.id,
    p.timser_id,
    t.timser_type,
    t.times_type,
    t.expl_id,
    p.date,
    p.hour,
    p."time",
    p.value
   FROM selector_expl s,
    inp_timeseries t
     JOIN inp_timeseries_value p ON t.id::text = p.timser_id::text
  WHERE t.expl_id = s.expl_id AND s.cur_user = "current_user"()::text OR t.expl_id IS NULL
  ORDER BY p.id;


 -- Drop the view if it already exists
-- CREATE OR REPLACE VIEW v_edit_inp_flwreg AS
-- SELECT
--     f.nodarc_id,
--     f.node_id,
--     f.order_id,
--    	f.to_arc,
--     f.flwreg_length,
--     f.flwregcat_id,
--     -- Orifice Columns
--     o.orifice_type,
--     o.offsetval as orifice_offsetval,
--     o.cd as orifice_cd,
--     o.orate as orifice_orate,
--     o.flap as orifice_flap,
--     o.shape as orifice_shape,
--     o.geom1 as orifice_geom1,
--     o.geom2 as orifice_geom2,
--     o.geom3 as orifice_geom3,
--     o.geom4 as orifice_geom4,
--     -- Outlet Columns
--     ou.outlet_type,
--     ou.offsetval as outlet_offsetval,
--     ou.curve_id as outlet_curve_id,
--     ou.cd1 as outlet_cd1,
--     ou.cd2 as outlet_cd2,
--     ou.flap as outlet_flap,
--     --Pump Columns
--     p.pump_type,
--     p.curve_id as pump_curve_id,
--     p.status as pump_status,
--     p.startup as pump_startup,
--     p.shutoff as pump_shutoff,
--     --Weir Columns
--     w.weir_type,
--     w.offsetval as weir_offsetval,
--     w.cd as weir_cd,
--     w.ec as weir_ec,
--     w.cd2 as weir_cd2,
--     w.flap as weir_flap,
--     w.geom1 as weir_geom1,
--     w.geom2 as weir_geom2,
--     w.geom3 as weir_geom3,
--     w.geom4 as weir_geom4,
--     w.surcharge as weir_surcharge,
--     w.road_width as weir_road_width,
--     w.road_surf as weir_road_surf,
--     w.coef_curve as weir_coef_curve,
--     -- Geometry
--     f.the_geom
-- FROM
--     flwreg f
-- left join inp_frorifice o using (flwreg_id)
-- left join inp_froutlet ou using (flwreg_id)
-- left join inp_frpump p using (flwreg_id)
-- left join inp_frweir w using (flwreg_id);

--10/01/2025
--28/01/2025 [Modified]
--create view for cat_feature_flwreg


CREATE OR REPLACE VIEW v_rpt_node
AS SELECT rpt_node.id,
    node.node_id,
    selector_rpt_main.result_id,
    node.node_type::text,
    node.nodecat_id,
    rpt_node.resultdate,
    rpt_node.resulttime,
    rpt_node.flooding,
    rpt_node.depth,
    rpt_node.head,
    node.the_geom
   FROM selector_rpt_main,
    rpt_inp_node node
     JOIN rpt_node ON rpt_node.node_id::text = node.node_id::text
  WHERE rpt_node.result_id::text = selector_rpt_main.result_id::text AND selector_rpt_main.cur_user = "current_user"()::text AND node.result_id::text = selector_rpt_main.result_id::text
  GROUP BY rpt_node.id, node.node_id, node.node_type, node.nodecat_id, selector_rpt_main.result_id, node.the_geom
  ORDER BY node.node_id;

CREATE OR REPLACE VIEW v_rpt_arc
AS SELECT rpt_arc.id,
    arc.arc_id,
    selector_rpt_main.result_id,
    arc.arc_type,
    arc.arccat_id,
    rpt_arc.flow,
    rpt_arc.velocity,
    rpt_arc.fullpercent,
    rpt_arc.resultdate,
    rpt_arc.resulttime,
    arc.the_geom
   FROM selector_rpt_main,
    rpt_inp_arc arc
     JOIN rpt_arc ON rpt_arc.arc_id::text = arc.arc_id::text
  WHERE rpt_arc.result_id::text = selector_rpt_main.result_id::text AND selector_rpt_main.cur_user = "current_user"()::text AND arc.result_id::text = selector_rpt_main.result_id::text
  ORDER BY arc.arc_id;


CREATE OR REPLACE VIEW ve_epa_junction
AS SELECT inp_junction.node_id,
    inp_junction.y0,
    inp_junction.ysur,
    inp_junction.apond,
    inp_junction.outfallparam,
    d.aver_depth AS depth_average,
    d.max_depth AS depth_max,
    d.time_days AS depth_max_day,
    d.time_hour AS depth_max_hour,
    s.hour_surch AS surcharge_hour,
    s.max_height AS surgarge_max_height,
    f.hour_flood AS flood_hour,
    f.max_rate AS flood_max_rate,
    f.time_days AS time_day,
    f.time_hour,
    f.tot_flood AS flood_total,
    f.max_ponded AS flood_max_ponded
   FROM inp_junction
     LEFT JOIN v_rpt_nodedepth_sum d USING (node_id)
     LEFT JOIN v_rpt_nodesurcharge_sum s USING (node_id)
     LEFT JOIN v_rpt_nodeflooding_sum f USING (node_id);

CREATE OR REPLACE VIEW ve_epa_pump
AS SELECT inp_pump.arc_id,
    inp_pump.curve_id,
    inp_pump.status,
    inp_pump.startup,
    inp_pump.shutoff,
    v_rpt_pumping_sum.percent,
    v_rpt_pumping_sum.num_startup,
    v_rpt_pumping_sum.min_flow,
    v_rpt_pumping_sum.avg_flow,
    v_rpt_pumping_sum.max_flow,
    v_rpt_pumping_sum.vol_ltr,
    v_rpt_pumping_sum.powus_kwh,
    v_rpt_pumping_sum.timoff_min,
    v_rpt_pumping_sum.timoff_max
   FROM inp_pump
     LEFT JOIN v_rpt_pumping_sum USING (arc_id);



CREATE OR REPLACE VIEW v_edit_review_node
AS SELECT review_node.node_id,
    review_node.top_elev,
    review_node.ymax,
    review_node.node_type::text,
    review_node.matcat_id,
    review_node.nodecat_id,
    review_node.annotation,
    review_node.observ,
	review_node.review_obs,
    review_node.expl_id,
    review_node.the_geom,
    review_node.field_date,
    review_node.field_checked,
    review_node.is_validated
   FROM review_node,
    selector_expl
  WHERE selector_expl.cur_user = "current_user"()::text AND review_node.expl_id = selector_expl.expl_id;

-- 10/02/2025
CREATE OR REPLACE VIEW v_ui_doc_x_arc
AS SELECT doc_x_arc.doc_id,
    doc_x_arc.arc_id,
    doc.name AS doc_name,
    doc.doc_type,
    doc.path,
    doc.observ,
    doc.date,
    doc.user_name
   FROM doc_x_arc
     JOIN doc ON doc.id::text = doc_x_arc.doc_id::text;

CREATE OR REPLACE VIEW v_ui_doc_x_connec
AS SELECT doc_x_connec.doc_id,
    doc_x_connec.connec_id,
    doc.name AS doc_name,
    doc.doc_type,
    doc.path,
    doc.observ,
    doc.date,
    doc.user_name
   FROM doc_x_connec
     JOIN doc ON doc.id::text = doc_x_connec.doc_id::text;

CREATE OR REPLACE VIEW v_ui_doc_x_gully
AS SELECT doc_x_gully.doc_id,
    doc_x_gully.gully_id,
    doc.name AS doc_name,
    doc.doc_type,
    doc.path,
    doc.observ,
    doc.date,
    doc.user_name
   FROM doc_x_gully
     JOIN doc ON doc.id::text = doc_x_gully.doc_id::text;


CREATE OR REPLACE VIEW v_ui_doc_x_node
AS SELECT doc_x_node.doc_id,
    doc_x_node.node_id,
    doc.name AS doc_name,
    doc.doc_type,
    doc.path,
    doc.observ,
    doc.date,
    doc.user_name
   FROM doc_x_node
     JOIN doc ON doc.id::text = doc_x_node.doc_id::text;

CREATE OR REPLACE VIEW v_ui_doc_x_psector
AS SELECT doc_x_psector.doc_id,
    plan_psector.name AS psector_name,
    doc.name AS doc_name,
    doc.doc_type,
    doc.path,
    doc.observ,
    doc.date,
    doc.user_name
   FROM doc_x_psector
     JOIN doc ON doc.id::text = doc_x_psector.doc_id::text
     JOIN plan_psector ON plan_psector.psector_id::text = doc_x_psector.psector_id::text;

CREATE OR REPLACE VIEW v_ui_doc_x_visit
AS SELECT doc_x_visit.doc_id,
    doc_x_visit.visit_id,
    doc.name AS doc_name,
    doc.doc_type,
    doc.path,
    doc.observ,
    doc.date,
    doc.user_name
   FROM doc_x_visit
     JOIN doc ON doc.id::text = doc_x_visit.doc_id::text;

CREATE OR REPLACE VIEW v_ui_doc_x_workcat
AS SELECT doc_x_workcat.doc_id,
    doc_x_workcat.workcat_id,
    doc.name,
    doc.doc_type,
    doc.path,
    doc.observ,
    doc.date,
    doc.user_name
   FROM doc_x_workcat
     JOIN doc ON doc.id::text = doc_x_workcat.doc_id::text;

CREATE OR REPLACE VIEW v_ui_om_visit_x_doc
AS SELECT
    doc_x_visit.doc_id,
    doc_x_visit.visit_id
   FROM doc_x_visit;

-- 06/03/2025
CREATE OR REPLACE VIEW v_ui_rpt_cat_result
AS SELECT DISTINCT ON (rpt_cat_result.result_id) rpt_cat_result.result_id,
    rpt_cat_result.expl_id,
    rpt_cat_result.sector_id,
    t2.idval AS network_type,
    t1.idval AS status,
    rpt_cat_result.iscorporate,
    rpt_cat_result.descript,
    rpt_cat_result.exec_date,
    rpt_cat_result.cur_user,
    rpt_cat_result.export_options,
    rpt_cat_result.network_stats,
    rpt_cat_result.inp_options,
    rpt_cat_result.rpt_stats,
    rpt_cat_result.addparam
   FROM selector_expl s,
    rpt_cat_result
     LEFT JOIN inp_typevalue t1 ON rpt_cat_result.status::text = t1.id::text
     LEFT JOIN inp_typevalue t2 ON rpt_cat_result.network_type::text = t2.id::text
  WHERE t1.typevalue::text = 'inp_result_status'::text AND t2.typevalue::text = 'inp_options_networkmode'::text AND ((s.expl_id = ANY (rpt_cat_result.expl_id)) AND s.cur_user = CURRENT_USER OR rpt_cat_result.expl_id = ARRAY[NULL]::INTEGER[]);


-- 18/03/2025
CREATE OR REPLACE VIEW v_om_visit
AS SELECT DISTINCT ON (visit_id) visit_id,
    code,
    visitcat_id,
    name,
    visit_start,
    visit_end,
    user_name,
    is_done,
    feature_id,
    feature_type,
    the_geom::geometry(Point,25831) AS the_geom
   FROM ( SELECT om_visit.id AS visit_id,
            om_visit.ext_code AS code,
            om_visit.visitcat_id,
            om_visit_cat.name,
            om_visit.startdate AS visit_start,
            om_visit.enddate AS visit_end,
            om_visit.user_name,
            om_visit.is_done,
            om_visit_x_node.node_id AS feature_id,
            'NODE'::text AS feature_type,
                CASE
                    WHEN om_visit.the_geom IS NULL THEN node.the_geom
                    ELSE om_visit.the_geom
                END AS the_geom
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
            'ARC'::text AS feature_type,
                CASE
                    WHEN om_visit.the_geom IS NULL THEN st_lineinterpolatepoint(arc.the_geom, 0.5::double precision)
                    ELSE om_visit.the_geom
                END AS the_geom
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
            'CONNEC'::text AS feature_type,
                CASE
                    WHEN om_visit.the_geom IS NULL THEN connec.the_geom
                    ELSE om_visit.the_geom
                END AS the_geom
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
            'GULLY'::text AS feature_type,
                CASE
                    WHEN om_visit.the_geom IS NULL THEN gully.the_geom
                    ELSE om_visit.the_geom
                END AS the_geom
           FROM selector_state,
            om_visit
             JOIN om_visit_x_gully ON om_visit_x_gully.visit_id = om_visit.id
             JOIN gully ON gully.gully_id::text = om_visit_x_gully.gully_id::text
             JOIN om_visit_cat ON om_visit.visitcat_id = om_visit_cat.id
          WHERE selector_state.state_id = gully.state AND selector_state.cur_user = "current_user"()::text) a;


CREATE OR REPLACE VIEW v_edit_review_arc
AS SELECT review_arc.arc_id,
    arc.node_1,
    review_arc.y1,
    arc.node_2,
    review_arc.y2,
    review_arc.arc_type,
    review_arc.matcat_id,
    review_arc.arccat_id,
    review_arc.annotation,
    review_arc.observ,
    review_arc.review_obs,
    review_arc.expl_id,
    review_arc.the_geom,
    review_arc.field_date,
    review_arc.field_checked,
    review_arc.is_validated
   FROM selector_expl,
    review_arc
     JOIN arc ON review_arc.arc_id::text = arc.arc_id::text
  WHERE selector_expl.cur_user = "current_user"()::text AND review_arc.expl_id = selector_expl.expl_id;


CREATE OR REPLACE VIEW v_ui_om_visit_x_arc
AS SELECT om_visit_event.id AS event_id,
    om_visit.id AS visit_id,
    om_visit.ext_code AS code,
    om_visit.visitcat_id,
    om_visit.startdate AS visit_start,
    om_visit.enddate AS visit_end,
    om_visit.user_name,
    om_visit.is_done,
    date_trunc('second'::text, om_visit_event.tstamp) AS tstamp,
    om_visit_x_arc.arc_id,
    om_visit_event.parameter_id,
    config_visit_parameter.parameter_type,
    config_visit_parameter.feature_type,
    config_visit_parameter.form_type,
    config_visit_parameter.descript,
    om_visit_event.value,
    om_visit_event.xcoord,
    om_visit_event.ycoord,
    om_visit_event.compass,
    om_visit_event.event_code,
        CASE
            WHEN a.event_id IS NULL THEN false
            ELSE true
        END AS gallery,
        CASE
            WHEN b.visit_id IS NULL THEN false
            ELSE true
        END AS document,
    om_visit.class_id
   FROM om_visit
     JOIN om_visit_event ON om_visit.id = om_visit_event.visit_id
     JOIN om_visit_x_arc ON om_visit_x_arc.visit_id = om_visit.id
     LEFT JOIN config_visit_parameter ON config_visit_parameter.id::text = om_visit_event.parameter_id::text
     JOIN arc ON arc.arc_id::text = om_visit_x_arc.arc_id::text
     LEFT JOIN ( SELECT DISTINCT om_visit_event_photo.event_id
           FROM om_visit_event_photo) a ON a.event_id = om_visit_event.id
     LEFT JOIN ( SELECT DISTINCT doc_x_visit.visit_id
           FROM doc_x_visit) b ON b.visit_id = om_visit.id
  ORDER BY om_visit_x_arc.arc_id;

CREATE OR REPLACE VIEW v_ui_event_x_arc
AS SELECT om_visit_event.id AS event_id,
    om_visit.id AS visit_id,
    om_visit.ext_code AS code,
    om_visit.visitcat_id,
    om_visit.startdate AS visit_start,
    om_visit.enddate AS visit_end,
    om_visit.user_name,
    om_visit.is_done,
    om_visit.class_id AS visit_class,
    date_trunc('second'::text, om_visit_event.tstamp) AS tstamp,
    om_visit_x_arc.arc_id,
    om_visit_event.parameter_id,
    config_visit_parameter.parameter_type,
    config_visit_parameter.feature_type,
    config_visit_parameter.form_type,
    config_visit_parameter.descript,
    om_visit_event.value,
    om_visit_event.xcoord,
    om_visit_event.ycoord,
    om_visit_event.compass,
    om_visit_event.event_code,
        CASE
            WHEN a.event_id IS NULL THEN false
            ELSE true
        END AS gallery,
        CASE
            WHEN b.visit_id IS NULL THEN false
            ELSE true
        END AS document
   FROM om_visit
     JOIN om_visit_event ON om_visit.id = om_visit_event.visit_id
     JOIN om_visit_x_arc ON om_visit_x_arc.visit_id = om_visit.id
     LEFT JOIN config_visit_parameter ON config_visit_parameter.id::text = om_visit_event.parameter_id::text
     JOIN arc ON arc.arc_id::text = om_visit_x_arc.arc_id::text
     LEFT JOIN ( SELECT DISTINCT om_visit_event_photo.event_id
           FROM om_visit_event_photo) a ON a.event_id = om_visit_event.id
     LEFT JOIN ( SELECT DISTINCT doc_x_visit.visit_id
           FROM doc_x_visit) b ON b.visit_id = om_visit.id
  ORDER BY om_visit_x_arc.arc_id;


CREATE OR REPLACE VIEW v_expl_connec AS
 SELECT connec.connec_id
 FROM selector_expl, connec
 WHERE selector_expl.cur_user = "current_user"()::text AND (connec.expl_id = selector_expl.expl_id);

CREATE OR REPLACE VIEW v_plan_psector_link
AS SELECT row_number() OVER () AS rid,
    a.link_id,
    a.psector_id,
    a.feature_id,
    a.original_state,
    a.original_state_type,
    a.plan_state,
    a.doable,
    a.psector_priority,
    a.the_geom
    FROM
    (
        SELECT
            link.link_id,
            plan_psector_x_connec.psector_id,
            connec.connec_id AS feature_id,
            connec.state AS original_state,
            connec.state_type AS original_state_type,
            plan_psector_x_connec.state AS plan_state,
            plan_psector_x_connec.doable,
            plan_psector.priority AS psector_priority,
            link.the_geom
        FROM selector_psector,connec
        JOIN plan_psector_x_connec USING (connec_id)
        JOIN plan_psector USING (psector_id)
        JOIN link ON link.feature_id=connec.connec_id
        WHERE plan_psector_x_connec.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text
        UNION
        SELECT
            link.link_id,
            plan_psector_x_gully.psector_id,
            gully.gully_id AS feature_id,
            gully.state AS original_state,
            gully.state_type AS original_state_type,
            plan_psector_x_gully.state AS plan_state,
            plan_psector_x_gully.doable,
            plan_psector.priority AS psector_priority,
            link.the_geom
        FROM selector_psector,gully
        JOIN plan_psector_x_gully USING (gully_id)
        JOIN plan_psector USING (psector_id)
        JOIN link ON link.feature_id=gully.gully_id
        WHERE plan_psector_x_gully.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text
    ) a;


CREATE OR REPLACE VIEW v_rtc_hydrometer
 AS
 SELECT ext_rtc_hydrometer.id::text AS hydrometer_id,
    ext_rtc_hydrometer.code AS hydrometer_customer_code,
        CASE
            WHEN connec.connec_id IS NULL THEN 'XXXX'::character varying
            ELSE connec.connec_id
        END AS feature_id,
        'CONNEC' AS feature_type,
        CASE
            WHEN ext_rtc_hydrometer.connec_id::text IS NULL THEN 'XXXX'::text
            ELSE ext_rtc_hydrometer.connec_id::text
        END AS customer_code,
    ext_rtc_hydrometer_state.name AS state,
    ext_municipality.name AS muni_name,
    connec.expl_id,
    exploitation.name AS expl_name,
    ext_rtc_hydrometer.plot_code,
    ext_rtc_hydrometer.priority_id,
    ext_rtc_hydrometer.catalog_id,
    ext_rtc_hydrometer.category_id,
    ext_rtc_hydrometer.hydro_number,
    ext_rtc_hydrometer.hydro_man_date,
    ext_rtc_hydrometer.crm_number,
    ext_rtc_hydrometer.customer_name,
    ext_rtc_hydrometer.address1,
    ext_rtc_hydrometer.address2,
    ext_rtc_hydrometer.address3,
    ext_rtc_hydrometer.address2_1,
    ext_rtc_hydrometer.address2_2,
    ext_rtc_hydrometer.address2_3,
    ext_rtc_hydrometer.m3_volume,
    ext_rtc_hydrometer.start_date,
    ext_rtc_hydrometer.end_date,
    ext_rtc_hydrometer.update_date,
        CASE
            WHEN (( SELECT config_param_system.value
               FROM config_param_system
              WHERE config_param_system.parameter::text = 'edit_hydro_link_absolute_path'::text)) IS NULL THEN rtc_hydrometer.link
            ELSE concat(( SELECT config_param_system.value
               FROM config_param_system
              WHERE config_param_system.parameter::text = 'edit_hydro_link_absolute_path'::text), rtc_hydrometer.link)
        END AS hydrometer_link,
    ext_rtc_hydrometer_state.is_operative,
    ext_rtc_hydrometer.shutdown_date
   FROM selector_hydrometer,
    selector_expl,
    rtc_hydrometer
     LEFT JOIN ext_rtc_hydrometer ON ext_rtc_hydrometer.id::text = rtc_hydrometer.hydrometer_id::text
     JOIN ext_rtc_hydrometer_state ON ext_rtc_hydrometer_state.id = ext_rtc_hydrometer.state_id
     JOIN connec ON connec.customer_code::text = ext_rtc_hydrometer.connec_id::text
     LEFT JOIN ext_municipality ON ext_municipality.muni_id = connec.muni_id
     LEFT JOIN exploitation ON exploitation.expl_id = connec.expl_id
  WHERE selector_hydrometer.state_id = ext_rtc_hydrometer.state_id AND selector_hydrometer.cur_user = "current_user"()::text AND selector_expl.expl_id = connec.expl_id AND selector_expl.cur_user = "current_user"()::text;

CREATE OR REPLACE VIEW v_rtc_hydrometer_x_connec
AS SELECT ext_rtc_hydrometer.id::text AS hydrometer_id,
    ext_rtc_hydrometer.code AS hydrometer_customer_code,
        CASE
            WHEN connec.connec_id IS NULL THEN 'XXXX'::character varying
            ELSE connec.connec_id
        END AS connec_id,
        CASE
            WHEN ext_rtc_hydrometer.connec_id::text IS NULL THEN 'XXXX'::text
            ELSE ext_rtc_hydrometer.connec_id::text
        END AS connec_customer_code,
    ext_rtc_hydrometer_state.name AS state,
    ext_municipality.name AS muni_name,
    connec.expl_id,
    exploitation.name AS expl_name,
    ext_rtc_hydrometer.plot_code,
    ext_rtc_hydrometer.priority_id,
    ext_rtc_hydrometer.catalog_id,
    ext_rtc_hydrometer.category_id,
    ext_rtc_hydrometer.hydro_number,
    ext_rtc_hydrometer.hydro_man_date,
    ext_rtc_hydrometer.crm_number,
    ext_rtc_hydrometer.customer_name,
    ext_rtc_hydrometer.address1,
    ext_rtc_hydrometer.address2,
    ext_rtc_hydrometer.address3,
    ext_rtc_hydrometer.address2_1,
    ext_rtc_hydrometer.address2_2,
    ext_rtc_hydrometer.address2_3,
    ext_rtc_hydrometer.m3_volume,
    ext_rtc_hydrometer.start_date,
    ext_rtc_hydrometer.end_date,
    ext_rtc_hydrometer.update_date,
        CASE
            WHEN (( SELECT config_param_system.value
               FROM config_param_system
              WHERE config_param_system.parameter::text = 'edit_hydro_link_absolute_path'::text)) IS NULL THEN rtc_hydrometer.link
            ELSE concat(( SELECT config_param_system.value
               FROM config_param_system
              WHERE config_param_system.parameter::text = 'edit_hydro_link_absolute_path'::text), rtc_hydrometer.link)
        END AS hydrometer_link
   FROM selector_hydrometer,
    selector_expl,
    rtc_hydrometer
     LEFT JOIN ext_rtc_hydrometer ON ext_rtc_hydrometer.id::text = rtc_hydrometer.hydrometer_id::text
     JOIN ext_rtc_hydrometer_state ON ext_rtc_hydrometer_state.id = ext_rtc_hydrometer.state_id
     JOIN connec ON connec.customer_code::text = ext_rtc_hydrometer.connec_id::text
     LEFT JOIN ext_municipality ON ext_municipality.muni_id = connec.muni_id
     LEFT JOIN exploitation ON exploitation.expl_id = connec.expl_id
  WHERE selector_hydrometer.state_id = ext_rtc_hydrometer.state_id AND selector_hydrometer.cur_user = "current_user"()::text AND selector_expl.expl_id = connec.expl_id AND selector_expl.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW v_ui_hydrometer
 AS
 SELECT hydrometer_id,
    connec_id as feature_id,
    hydrometer_customer_code,
    connec_customer_code AS feature_customer_code,
    state,
    expl_name,
    hydrometer_link
   FROM v_rtc_hydrometer_x_connec;


CREATE OR REPLACE VIEW v_ui_hydroval_x_connec AS
SELECT ext_rtc_hydrometer_x_data.id,
    rtc_hydrometer_x_connec.connec_id,
    connec.arc_id,
    ext_rtc_hydrometer_x_data.hydrometer_id,
    ext_rtc_hydrometer.catalog_id,
    ext_cat_hydrometer.madeby,
    ext_cat_hydrometer.class,
    ext_rtc_hydrometer_x_data.cat_period_id,
    ext_rtc_hydrometer_x_data.sum,
    ext_rtc_hydrometer_x_data.custom_sum,
    crmtype.idval as value_type,
    crmstatus.idval as value_status,
    crmstate.idval as value_state
   FROM ext_rtc_hydrometer_x_data
    JOIN ext_rtc_hydrometer ON ext_rtc_hydrometer_x_data.hydrometer_id::text = ext_rtc_hydrometer.id::text
    LEFT JOIN ext_cat_hydrometer ON ext_cat_hydrometer.id::text = ext_rtc_hydrometer.catalog_id::text
    JOIN rtc_hydrometer_x_connec ON rtc_hydrometer_x_connec.hydrometer_id::text = ext_rtc_hydrometer_x_data.hydrometer_id::text
    JOIN connec ON rtc_hydrometer_x_connec.connec_id::text = connec.connec_id::text
    LEFT JOIN crm_typevalue crmtype ON value_type=crmtype.id::integer AND crmtype.typevalue ='crm_value_type'
    LEFT JOIN crm_typevalue crmstatus ON value_status=crmstatus.id::integer AND crmstatus.typevalue = 'crm_value_status'
    LEFT JOIN crm_typevalue crmstate ON value_state=crmstate.id::integer AND crmstate.typevalue ='crm_value_state'
  ORDER BY ext_rtc_hydrometer_x_data.id;


CREATE OR REPLACE VIEW v_ui_om_visit_x_connec AS
 SELECT om_visit_event.id AS event_id,
    om_visit.id AS visit_id,
    om_visit.ext_code AS code,
    om_visit.visitcat_id,
    om_visit.startdate AS visit_start,
    om_visit.enddate AS visit_end,
    om_visit.user_name,
    om_visit.is_done,
    date_trunc('second'::text, om_visit_event.tstamp) AS tstamp,
    om_visit_x_connec.connec_id,
    om_visit_event.parameter_id,
    config_visit_parameter.parameter_type,
    config_visit_parameter.feature_type,
    config_visit_parameter.form_type,
    config_visit_parameter.descript,
    om_visit_event.value,
    om_visit_event.xcoord,
    om_visit_event.ycoord,
    om_visit_event.compass,
    om_visit_event.event_code,
        CASE
            WHEN a.event_id IS NULL THEN false
            ELSE true
        END AS gallery,
        CASE
            WHEN b.visit_id IS NULL THEN false
            ELSE true
        END AS document,
     om_visit.class_id
   FROM om_visit
     JOIN om_visit_event ON om_visit.id = om_visit_event.visit_id
     JOIN om_visit_x_connec ON om_visit_x_connec.visit_id = om_visit.id
     JOIN config_visit_parameter ON config_visit_parameter.id::text = om_visit_event.parameter_id::text
     LEFT JOIN connec ON connec.connec_id::text = om_visit_x_connec.connec_id::text
     LEFT JOIN ( SELECT DISTINCT om_visit_event_photo.event_id
           FROM om_visit_event_photo) a ON a.event_id = om_visit_event.id
     LEFT JOIN ( SELECT DISTINCT doc_x_visit.visit_id
           FROM doc_x_visit) b ON b.visit_id = om_visit.id
  ORDER BY om_visit_x_connec.connec_id;

CREATE OR REPLACE VIEW v_ui_om_visit_x_link AS
 SELECT om_visit_event.id AS event_id,
    om_visit.id AS visit_id,
    om_visit.ext_code AS code,
    om_visit.visitcat_id,
    om_visit.startdate AS visit_start,
    om_visit.enddate AS visit_end,
    om_visit.user_name,
    om_visit.is_done,
    date_trunc('second'::text, om_visit_event.tstamp) AS tstamp,
    om_visit_x_link.link_id,
    om_visit_event.parameter_id,
    config_visit_parameter.parameter_type,
    config_visit_parameter.feature_type,
    config_visit_parameter.form_type,
    config_visit_parameter.descript,
    om_visit_event.value,
    om_visit_event.xcoord,
    om_visit_event.ycoord,
    om_visit_event.compass,
    om_visit_event.event_code,
        CASE
            WHEN a.event_id IS NULL THEN false
            ELSE true
        END AS gallery,
        CASE
            WHEN b.visit_id IS NULL THEN false
            ELSE true
        END AS document,
     om_visit.class_id
   FROM om_visit
     JOIN om_visit_event ON om_visit.id = om_visit_event.visit_id
     JOIN om_visit_x_link ON om_visit_x_link.visit_id = om_visit.id
     JOIN config_visit_parameter ON config_visit_parameter.id::text = om_visit_event.parameter_id::text
     LEFT JOIN link ON link.link_id::text = om_visit_x_link.link_id::text
     LEFT JOIN ( SELECT DISTINCT om_visit_event_photo.event_id
           FROM om_visit_event_photo) a ON a.event_id = om_visit_event.id
     LEFT JOIN ( SELECT DISTINCT doc_x_visit.visit_id
           FROM doc_x_visit) b ON b.visit_id = om_visit.id
  ORDER BY om_visit_x_link.link_id;

CREATE OR REPLACE VIEW v_ui_hydroval
 AS
 SELECT ext_rtc_hydrometer_x_data.id,
    rtc_hydrometer_x_connec.connec_id  as feature_id,
    connec.arc_id,
    ext_rtc_hydrometer_x_data.hydrometer_id,
    ext_rtc_hydrometer.code AS hydrometer_customer_code,
    ext_rtc_hydrometer.catalog_id,
    ext_cat_hydrometer.madeby,
    ext_cat_hydrometer.class,
    ext_rtc_hydrometer_x_data.cat_period_id,
    ext_rtc_hydrometer_x_data.sum,
    ext_rtc_hydrometer_x_data.custom_sum,
    crmtype.idval AS value_type,
    crmstatus.idval AS value_status,
    crmstate.idval AS value_state
   FROM ext_rtc_hydrometer_x_data
     JOIN ext_rtc_hydrometer ON ext_rtc_hydrometer_x_data.hydrometer_id::text = ext_rtc_hydrometer.id::text
     LEFT JOIN ext_cat_hydrometer ON ext_cat_hydrometer.id::text = ext_rtc_hydrometer.catalog_id::text
     JOIN rtc_hydrometer_x_connec ON rtc_hydrometer_x_connec.hydrometer_id::text = ext_rtc_hydrometer_x_data.hydrometer_id::text
     JOIN connec ON rtc_hydrometer_x_connec.connec_id::text = connec.connec_id::text
     LEFT JOIN crm_typevalue crmtype ON ext_rtc_hydrometer_x_data.value_type = crmtype.id::integer AND crmtype.typevalue::text = 'crm_value_type'::text
     LEFT JOIN crm_typevalue crmstatus ON ext_rtc_hydrometer_x_data.value_status = crmstatus.id::integer AND crmstatus.typevalue::text = 'crm_value_status'::text
     LEFT JOIN crm_typevalue crmstate ON ext_rtc_hydrometer_x_data.value_state = crmstate.id::integer AND crmstate.typevalue::text = 'crm_value_state'::text
  ORDER BY 1;

CREATE OR REPLACE VIEW v_ui_event_x_connec
AS SELECT om_visit_event.id AS event_id,
    om_visit.id AS visit_id,
    om_visit.ext_code AS code,
    om_visit.visitcat_id,
    om_visit.startdate AS visit_start,
    om_visit.enddate AS visit_end,
    om_visit.user_name,
    om_visit.is_done,
    om_visit.class_id AS visit_class,
    date_trunc('second'::text, om_visit_event.tstamp) AS tstamp,
    om_visit_x_connec.connec_id,
    om_visit_event.parameter_id,
    config_visit_parameter.parameter_type,
    config_visit_parameter.feature_type,
    config_visit_parameter.form_type,
    config_visit_parameter.descript,
    om_visit_event.value,
    om_visit_event.xcoord,
    om_visit_event.ycoord,
    om_visit_event.compass,
    om_visit_event.event_code,
        CASE
            WHEN a.event_id IS NULL THEN false
            ELSE true
        END AS gallery,
        CASE
            WHEN b.visit_id IS NULL THEN false
            ELSE true
        END AS document
   FROM om_visit
     JOIN om_visit_event ON om_visit.id = om_visit_event.visit_id
     JOIN om_visit_x_connec ON om_visit_x_connec.visit_id = om_visit.id
     JOIN config_visit_parameter ON config_visit_parameter.id::text = om_visit_event.parameter_id::text
     LEFT JOIN connec ON connec.connec_id::text = om_visit_x_connec.connec_id::text
     LEFT JOIN ( SELECT DISTINCT om_visit_event_photo.event_id
           FROM om_visit_event_photo) a ON a.event_id = om_visit_event.id
     LEFT JOIN ( SELECT DISTINCT doc_x_visit.visit_id
           FROM doc_x_visit) b ON b.visit_id = om_visit.id
  ORDER BY om_visit_x_connec.connec_id;



CREATE OR REPLACE VIEW v_expl_gully
AS SELECT gully.gully_id
   FROM selector_expl,
    gully
  WHERE selector_expl.cur_user = "current_user"()::text AND gully.expl_id = selector_expl.expl_id;

CREATE OR REPLACE VIEW v_man_gully
AS SELECT gully.gully_id,
    gully.the_geom
   FROM gully
     JOIN selector_state ON gully.state = selector_state.state_id;

CREATE OR REPLACE VIEW v_ui_event_x_gully
AS SELECT om_visit_event.id AS event_id,
    om_visit.id AS visit_id,
    om_visit.ext_code AS code,
    om_visit.visitcat_id,
    om_visit.startdate AS visit_start,
    om_visit.enddate AS visit_end,
    om_visit.user_name,
    om_visit.is_done,
    date_trunc('second'::text, om_visit_event.tstamp) AS tstamp,
    om_visit_x_gully.gully_id,
    om_visit_event.parameter_id,
    config_visit_parameter.parameter_type,
    config_visit_parameter.feature_type,
    config_visit_parameter.form_type,
    config_visit_parameter.descript,
    om_visit_event.value,
    om_visit_event.xcoord,
    om_visit_event.ycoord,
    om_visit_event.compass,
    om_visit_event.event_code,
        CASE
            WHEN a.event_id IS NULL THEN false
            ELSE true
        END AS gallery,
        CASE
            WHEN b.visit_id IS NULL THEN false
            ELSE true
        END AS document
   FROM om_visit
     JOIN om_visit_event ON om_visit.id = om_visit_event.visit_id
     JOIN om_visit_x_gully ON om_visit_x_gully.visit_id = om_visit.id
     JOIN config_visit_parameter ON config_visit_parameter.id::text = om_visit_event.parameter_id::text
     LEFT JOIN gully ON gully.gully_id::text = om_visit_x_gully.gully_id::text
     LEFT JOIN ( SELECT DISTINCT om_visit_event_photo.event_id
           FROM om_visit_event_photo) a ON a.event_id = om_visit_event.id
     LEFT JOIN ( SELECT DISTINCT doc_x_visit.visit_id
           FROM doc_x_visit) b ON b.visit_id = om_visit.id
  ORDER BY om_visit_x_gully.gully_id;

-- ve_epa_frweir
CREATE OR REPLACE VIEW ve_epa_frweir
AS SELECT inp_frweir.element_id,
	man_frelem.node_id,
	man_frelem.order_id,
	concat (man_frelem.node_id,'_FR', order_id) as nodarc_id,
    inp_frweir.weir_type,
    inp_frweir.offsetval,
    inp_frweir.cd,
    inp_frweir.ec,
    inp_frweir.cd2,
    inp_frweir.flap,
    inp_frweir.geom1,
    inp_frweir.geom2,
    inp_frweir.geom3,
    inp_frweir.geom4,
    inp_frweir.surcharge,
    inp_frweir.road_width,
    inp_frweir.road_surf,
    inp_frweir.coef_curve,
    rpt_arcflow_sum.max_flow,
    rpt_arcflow_sum.time_days,
    rpt_arcflow_sum.time_hour,
    rpt_arcflow_sum.max_veloc,
    rpt_arcflow_sum.mfull_flow,
    rpt_arcflow_sum.mfull_depth AS mfull_dept,
    rpt_arcflow_sum.max_shear,
    rpt_arcflow_sum.max_hr,
    rpt_arcflow_sum.max_slope,
    rpt_arcflow_sum.day_max,
    rpt_arcflow_sum.time_max,
    rpt_arcflow_sum.min_shear,
    rpt_arcflow_sum.day_min,
    rpt_arcflow_sum.time_min
   FROM inp_frweir
     LEFT JOIN man_frelem USING (element_id)
     LEFT JOIN rpt_arcflow_sum ON rpt_arcflow_sum.arc_id = concat (man_frelem.node_id,'_FR', order_id);


-- ve_epa_frorifice
CREATE OR REPLACE VIEW ve_epa_frorifice
AS SELECT inp_frorifice.element_id,
	man_frelem.node_id,
	man_frelem.order_id,
	concat (man_frelem.node_id,'_FR', order_id) as nodarc_id,
    inp_frorifice.orifice_type,
    inp_frorifice.offsetval,
    inp_frorifice.cd,
    inp_frorifice.orate,
    inp_frorifice.flap,
    inp_frorifice.shape,
    inp_frorifice.geom1,
    inp_frorifice.geom2,
    inp_frorifice.geom3,
    inp_frorifice.geom4,
    rpt_arcflow_sum.max_flow,
    rpt_arcflow_sum.time_days,
    rpt_arcflow_sum.time_hour,
    rpt_arcflow_sum.max_veloc,
    rpt_arcflow_sum.mfull_flow,
    rpt_arcflow_sum.mfull_depth,
    rpt_arcflow_sum.max_shear,
    rpt_arcflow_sum.max_hr,
    rpt_arcflow_sum.max_slope,
    rpt_arcflow_sum.day_max,
    rpt_arcflow_sum.time_max,
    rpt_arcflow_sum.min_shear,
    rpt_arcflow_sum.day_min,
    rpt_arcflow_sum.time_min
   FROM inp_frorifice
     LEFT JOIN man_frelem USING (element_id)
     LEFT JOIN rpt_arcflow_sum ON rpt_arcflow_sum.arc_id = concat (man_frelem.node_id,'_FR', order_id);


-- ve_epa_froutlet
CREATE OR REPLACE VIEW ve_epa_froutlet
AS SELECT inp_froutlet.element_id,
	man_frelem.node_id,
	man_frelem.order_id,
	concat (man_frelem.node_id,'_FR', order_id) as nodarc_id,
    inp_froutlet.outlet_type,
	inp_froutlet.offsetval,
    inp_froutlet.curve_id,
    inp_froutlet.cd1,
    inp_froutlet.cd2,
    inp_froutlet.flap,
    rpt_arcflow_sum.max_flow,
    rpt_arcflow_sum.time_days,
    rpt_arcflow_sum.time_hour,
    rpt_arcflow_sum.max_veloc,
    rpt_arcflow_sum.mfull_flow,
    rpt_arcflow_sum.mfull_depth AS mfull_dept,
    rpt_arcflow_sum.max_shear,
    rpt_arcflow_sum.max_hr,
    rpt_arcflow_sum.max_slope,
    rpt_arcflow_sum.day_max,
    rpt_arcflow_sum.time_max,
    rpt_arcflow_sum.min_shear,
    rpt_arcflow_sum.day_min,
    rpt_arcflow_sum.time_min
   FROM inp_froutlet
     LEFT JOIN man_frelem USING (element_id)
     LEFT JOIN rpt_arcflow_sum ON rpt_arcflow_sum.arc_id = concat (man_frelem.node_id,'_FR', order_id);


-- ve_epa_frpump
CREATE OR REPLACE VIEW ve_epa_frpump
AS SELECT inp_frpump.element_id,
	man_frelem.node_id,
	man_frelem.order_id,
	concat (man_frelem.node_id,'_FR', order_id) as nodarc_id,
    inp_frpump.curve_id,
    inp_frpump.status,
    inp_frpump.startup,
    inp_frpump.shutoff,
    v_rpt_pumping_sum.percent,
    v_rpt_pumping_sum.num_startup,
    v_rpt_pumping_sum.min_flow,
    v_rpt_pumping_sum.avg_flow,
    v_rpt_pumping_sum.max_flow,
    v_rpt_pumping_sum.vol_ltr,
    v_rpt_pumping_sum.powus_kwh,
    v_rpt_pumping_sum.timoff_min,
    v_rpt_pumping_sum.timoff_max
   FROM inp_frpump
     LEFT JOIN man_frelem USING (element_id)
     LEFT JOIN v_rpt_pumping_sum ON v_rpt_pumping_sum.arc_id = concat (man_frelem.node_id,'_FR', order_id);
