/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;


CREATE OR REPLACE VIEW v_state_arc AS
WITH
p AS (SELECT arc_id, psector_id, state FROM plan_psector_x_arc WHERE active),
cf AS (SELECT value::boolean FROM config_param_user WHERE parameter = 'utils_psector_strategy' AND cur_user = current_user),
s AS (SELECT * FROM selector_psector WHERE cur_user = current_user),
a as (SELECT arc_id, state FROM arc)
SELECT arc.arc_id FROM selector_state,arc WHERE arc.state = selector_state.state_id AND selector_state.cur_user = "current_user"()::text
	EXCEPT ALL
SELECT p.arc_id FROM s, p WHERE p.psector_id = s.psector_id AND p.state = 0
	UNION ALL
SELECT DISTINCT p.arc_id FROM s, p WHERE p.psector_id = s.psector_id AND p.state = 1;


CREATE OR REPLACE VIEW v_state_node AS
WITH
p AS (SELECT node_id, psector_id, state FROM plan_psector_x_node WHERE active),
cf AS (SELECT value::boolean FROM config_param_user WHERE parameter = 'utils_psector_strategy' AND cur_user = current_user),
s AS (SELECT * FROM selector_psector WHERE cur_user = current_user),
n AS (SELECT node_id, state FROM node)
SELECT n.node_id FROM selector_state,n WHERE n.state = selector_state.state_id AND selector_state.cur_user = "current_user"()::text
	EXCEPT ALL
SELECT p.node_id FROM s, p, cf WHERE p.psector_id = s.psector_id AND p.state = 0 AND cf.value is TRUE
	UNION ALL
SELECT DISTINCT p.node_id FROM s, p, cf WHERE p.psector_id = s.psector_id AND p.state = 1 AND cf.value is TRUE;

CREATE OR REPLACE VIEW v_state_connec AS
WITH
p AS (SELECT connec_id, psector_id, state, arc_id FROM plan_psector_x_connec WHERE active),
cf AS (SELECT value::boolean FROM config_param_user WHERE parameter = 'utils_psector_strategy' AND cur_user = current_user),
s AS (SELECT * FROM selector_psector WHERE cur_user = current_user),
c as (SELECT connec_id, state, arc_id FROM connec)
SELECT c.connec_id::varchar(30), c.arc_id FROM selector_state,c WHERE c.state = selector_state.state_id AND selector_state.cur_user = "current_user"()::text
	EXCEPT ALL
SELECT p.connec_id::varchar(30), p.arc_id FROM s, p, cf WHERE p.psector_id = s.psector_id AND s.cur_user = "current_user"()::text
AND p.state = 0 AND cf.value is TRUE
	UNION ALL
SELECT DISTINCT ON (p.connec_id) p.connec_id::varchar(30), p.arc_id FROM s, p, cf WHERE p.psector_id = s.psector_id AND s.cur_user = "current_user"()::text
AND p.state = 1 AND cf.value is TRUE;

CREATE OR REPLACE VIEW v_state_gully AS
WITH
p AS (SELECT gully_id, psector_id, state, arc_id FROM plan_psector_x_gully WHERE active),
cf AS (SELECT value::boolean FROM config_param_user WHERE parameter = 'utils_psector_strategy' AND cur_user = current_user),
s AS (SELECT * FROM selector_psector WHERE cur_user = current_user),
c as (SELECT gully_id, state, arc_id FROM gully)
SELECT c.gully_id, c.arc_id FROM selector_state,c WHERE c.state = selector_state.state_id AND selector_state.cur_user = "current_user"()::text
	EXCEPT ALL
SELECT p.gully_id, p.arc_id FROM s, p, cf WHERE p.psector_id = s.psector_id AND s.cur_user = "current_user"()::text
AND p.state = 0 AND cf.value is TRUE
	UNION ALL
SELECT DISTINCT ON (p.gully_id) p.gully_id, p.arc_id FROM s, p, cf WHERE p.psector_id = s.psector_id AND s.cur_user = "current_user"()::text
AND p.state = 1 AND cf.value is TRUE;

CREATE OR REPLACE VIEW v_state_link_connec AS
WITH
p AS (SELECT connec_id, psector_id, state, link_id FROM plan_psector_x_connec WHERE active),
cf AS (SELECT value::boolean FROM config_param_user WHERE parameter = 'utils_psector_strategy' AND cur_user = current_user),
sp AS (SELECT * FROM selector_psector WHERE cur_user = current_user),
se AS (SELECT * FROM selector_expl WHERE cur_user = current_user),
l AS (SELECT link_id, state, expl_id, expl_id2 FROM link)
SELECT l.link_id  FROM selector_state, se, l WHERE l.state = selector_state.state_id AND (l.expl_id = se.expl_id OR l.expl_id2 = se.expl_id)
AND selector_state.cur_user = "current_user"()::text AND se.cur_user = "current_user"()::text
	EXCEPT ALL
SELECT p.link_id FROM sp, se, cf, p JOIN l USING (link_id) WHERE p.psector_id = sp.psector_id AND sp.cur_user = "current_user"()::text AND p.state = 0
AND l.expl_id = se.expl_id AND se.cur_user = CURRENT_USER::text AND cf.value is TRUE
	UNION ALL
SELECT p.link_id FROM sp, se, cf, p JOIN l USING (link_id) WHERE p.psector_id = sp.psector_id AND sp.cur_user = "current_user"()::text AND p.state = 1
AND l.expl_id = se.expl_id AND se.cur_user = CURRENT_USER::text AND cf.value is TRUE;

CREATE OR REPLACE VIEW v_state_link_gully AS
WITH
p AS (SELECT gully_id, psector_id, state, link_id FROM plan_psector_x_gully WHERE active),
sp AS (SELECT * FROM selector_psector WHERE cur_user = current_user),
cf AS (SELECT value::boolean FROM config_param_user WHERE parameter = 'utils_psector_strategy' AND cur_user = current_user),
se AS (SELECT * FROM selector_expl WHERE cur_user = current_user),
l AS (SELECT link_id, state, expl_id, expl_id2 FROM link)
SELECT l.link_id  FROM selector_state, se, l WHERE l.state = selector_state.state_id AND (l.expl_id = se.expl_id OR l.expl_id2 = se.expl_id)
AND selector_state.cur_user = "current_user"()::text AND se.cur_user = "current_user"()::text
	EXCEPT ALL
SELECT p.link_id FROM sp, se, cf, p JOIN l USING (link_id) WHERE p.psector_id = sp.psector_id AND sp.cur_user = "current_user"()::text AND p.state = 0
AND l.expl_id = se.expl_id AND se.cur_user = CURRENT_USER::text AND cf.value is TRUE
	UNION ALL
SELECT p.link_id FROM sp, se, cf, p JOIN l USING (link_id) WHERE p.psector_id = sp.psector_id AND sp.cur_user = "current_user"()::text AND p.state = 1
AND l.expl_id = se.expl_id AND se.cur_user = CURRENT_USER::text AND cf.value is TRUE;

CREATE OR REPLACE VIEW v_state_link AS
WITH
c AS (SELECT connec_id, psector_id, state, link_id FROM plan_psector_x_connec WHERE active),
cf AS (SELECT value::boolean FROM config_param_user WHERE parameter = 'utils_psector_strategy' AND cur_user = current_user),
g AS (SELECT gully_id, psector_id, state, link_id FROM plan_psector_x_gully WHERE active),
sp AS (SELECT * FROM selector_psector WHERE cur_user = current_user),
se AS (SELECT * FROM selector_expl WHERE cur_user = current_user),
l AS (SELECT link_id, state, expl_id, expl_id2 FROM link)
SELECT l.link_id  FROM selector_state, se, l WHERE l.state = selector_state.state_id AND (l.expl_id = se.expl_id OR l.expl_id2 = se.expl_id)
AND selector_state.cur_user = "current_user"()::text AND se.cur_user = "current_user"()::text
	EXCEPT ALL
SELECT c.link_id FROM sp, se, cf, c JOIN l USING (link_id) WHERE c.psector_id = sp.psector_id AND sp.cur_user = "current_user"()::text AND c.state = 0
AND l.expl_id = se.expl_id AND se.cur_user = CURRENT_USER::text AND cf.value is TRUE
	EXCEPT ALL
SELECT g.link_id FROM sp, se, cf, g JOIN l USING (link_id) WHERE g.psector_id = sp.psector_id AND sp.cur_user = "current_user"()::text AND g.state = 0
AND l.expl_id = se.expl_id AND se.cur_user = CURRENT_USER::text AND cf.value is TRUE
	UNION ALL
SELECT c.link_id FROM sp, se, cf, c JOIN l USING (link_id) WHERE c.psector_id = sp.psector_id AND sp.cur_user = "current_user"()::text AND c.state = 1
AND l.expl_id = se.expl_id AND se.cur_user = CURRENT_USER::text AND cf.value is TRUE
	UNION ALL
SELECT g.link_id FROM sp, se, cf, g JOIN l USING (link_id) WHERE g.psector_id = sp.psector_id AND sp.cur_user = "current_user"()::text AND g.state = 1
AND l.expl_id = se.expl_id AND se.cur_user = CURRENT_USER::text AND cf.value is TRUE;


CREATE OR REPLACE VIEW vu_dma
AS SELECT
    dma.dma_id,
    dma.name,
    dma.macrodma_id,
    dma.dma_type,
    dma.expl_id,
    e.name as expl_name,
    dma.descript,
    dma.undelete,
    dma.link,
    dma.graphconfig::text,
    dma.active,
    dma.stylesheet,
    dma.the_geom
    FROM dma
    LEFT JOIN exploitation e USING (expl_id)
    ORDER BY 1;

CREATE OR REPLACE VIEW v_edit_dma AS
select vu_dma.* from vu_dma, selector_expl
WHERE ((vu_dma.expl_id = selector_expl.expl_id) AND selector_expl.cur_user = "current_user"()::text) OR vu_dma.expl_id is null
order by 1 asc;

CREATE OR REPLACE VIEW v_edit_sector
AS SELECT s.sector_id,
    s.name,
    s.sector_type,
    s.macrosector_id,
    s.descript,
    s.undelete,
    s.graphconfig::text,
    s.stylesheet,
    s.parent_id,
    s.tstamp,
    s.insert_user,
    s.lastupdate,
    s.lastupdate_user,
    s.link,
    s.the_geom
   FROM selector_sector,
    sector s
  WHERE s.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text;

CREATE OR REPLACE VIEW v_ui_sector
AS SELECT s.sector_id,
    s.name,
    s.sector_type,
    ms.name AS macrosector,
    s.descript,
    s.active,
    s.undelete,
    s.graphconfig,
    s.stylesheet,
    s.parent_id,
    s.tstamp,
    s.insert_user,
    s.lastupdate,
    s.lastupdate_user,
    s.link
    FROM selector_sector ss,
    sector s
     LEFT JOIN macrosector ms ON ms.macrosector_id = s.macrosector_id
  WHERE s.sector_id > 0 AND ss.sector_id = s.sector_id AND ss.cur_user = CURRENT_USER
  ORDER BY s.sector_id;



-- recreate v_edit_element, v_edit_samplepoint, v_ext_streetaxis, v_ext_municipality views
-----------------------------------
CREATE OR REPLACE VIEW v_edit_element AS
SELECT e.* FROM (
SELECT element.element_id,
    element.code,
    element.elementcat_id,
    cat_element.element_type,
    element.brand_id,
    element.model_id,
    element.serial_number,
    element.state,
    element.state_type,
    element.num_elements,
    element.observ,
    element.comment,
    element.function_type,
    element.category_type,
    element.location_type,
    element.fluid_type,
    element.workcat_id,
    element.workcat_id_end,
    element.buildercat_id,
    element.builtdate,
    element.enddate,
    element.ownercat_id,
    element.rotation,
    concat(element_type.link_path, element.link) AS link,
    element.verified,
    element.the_geom,
    element.label_x,
    element.label_y,
    element.label_rotation,
    element.publish,
    element.inventory,
    element.undelete,
    element.expl_id,
    element.pol_id,
    element.lastupdate,
    element.lastupdate_user,
    element.top_elev,
    element.expl_id2,
    element.trace_featuregeom,
	element.muni_id,
	element.sector_id,
    element.lock_level
   FROM selector_expl, element
     JOIN v_state_element ON element.element_id::text = v_state_element.element_id::text
     JOIN cat_element ON element.elementcat_id::text = cat_element.id::text
     JOIN element_type ON element_type.id::text = cat_element.element_type::text
  WHERE element.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text) e
  LEFT JOIN selector_sector s USING (sector_id)
  LEFT JOIN selector_municipality m USING (muni_id)
  WHERE (s.cur_user = current_user OR s.sector_id IS NULL)
  AND (m.cur_user = current_user OR e.muni_id IS NULL);

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
    samplepoint.dma_id,
    dma.macrodma_id,
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
    JOIN v_state_samplepoint ON samplepoint.sample_id::text = v_state_samplepoint.sample_id::text
    LEFT JOIN dma ON dma.dma_id = samplepoint.dma_id
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


CREATE OR REPLACE VIEW vu_link
AS SELECT DISTINCT ON (link_id)
	l.link_id,
    l.feature_type,
    l.feature_id,
    l.exit_type,
    l.exit_id,
    l.state,
    l.expl_id,
	e.macroexpl_id,
    l.sector_id,
    s.sector_type,
	s.macrosector_id,
	l.muni_id,
	l.drainzone_id,
    drainzone.drainzone_type,
    l.dma_id,
	d.macrodma_id,
    l.exit_topelev,
    l.exit_elev,
    l.fluid_type,
    st_length2d(l.the_geom)::numeric(12,3) AS gis_length,
    l.the_geom,
	s.name as sector_name,
	d.name as dma_name,
    l.expl_id2,
    l.epa_type,
    l.is_operative,
    l.conneccat_id,
    l.workcat_id,
    l.workcat_id_end,
    l.builtdate,
    l.enddate,
    date_trunc('second'::text, l.lastupdate) AS lastupdate,
    l.lastupdate_user,
    l.uncertain,
    l.verified
   FROM link l
	 LEFT JOIN exploitation e USING (expl_id)
     LEFT JOIN sector s USING (sector_id)
     LEFT JOIN dma d USING (dma_id)
	 LEFT JOIN ext_municipality m USING (muni_id)
     LEFT JOIN drainzone USING (drainzone_id);

CREATE OR REPLACE VIEW vu_link_connec AS
	SELECT l.*
	FROM link l
	WHERE l.feature_type::text = 'CONNEC'::text;

CREATE OR REPLACE VIEW vu_link_gully AS
	SELECT l.*
	FROM link l
    WHERE l.feature_type::text = 'GULLY'::text;


CREATE OR REPLACE VIEW v_edit_link
AS WITH
	typevalue AS
       (
			SELECT edit_typevalue.typevalue, edit_typevalue.id, edit_typevalue.idval
			FROM edit_typevalue
			WHERE edit_typevalue.typevalue::text = ANY (ARRAY['sector_type'::character varying::text, 'drainzone_type'::character varying::text, 'dma_type'::character varying::text, 'dwfzone_type'::character varying::text])
        ),
    sector_table AS
		(
			SELECT sector_id, macrosector_id, stylesheet, id::varchar(16) AS sector_type
			FROM sector
			LEFT JOIN typevalue t ON t.id::text = sector.sector_type AND t.typevalue::text = 'sector_type'::text
		),
	dma_table AS
		(
			SELECT dma_id, macrodma_id, stylesheet, id::varchar(16) AS dma_type
			FROM dma
			LEFT JOIN typevalue t ON t.id::text = dma.dma_type AND t.typevalue::text = 'dma_type'::text
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
    link_state AS
        (
			SELECT l.link_id
			FROM link l
			JOIN selector_state s ON s.cur_user = current_user AND l.state = s.state_id
			LEFT JOIN (SELECT link_id FROM link_psector WHERE p_state = 0) a USING (link_id) WHERE a.link_id IS NULL
			UNION ALL
			SELECT link_id FROM link_psector WHERE p_state = 1
        ),
    link_selected as
    	(
			SELECT DISTINCT ON (l.link_id) l.link_id,
			l.feature_type,
			l.feature_id,
			l.exit_type,
			l.exit_id,
			l.state,
			l.expl_id,
			macroexpl_id,
			l.sector_id,
			sector_table.sector_type,
			macrosector_id,
			l.muni_id,
			l.drainzone_id,
			drainzone_table.drainzone_type,
			l.dma_id,
			dma_table.macrodma_id,
			l.dwfzone_id,
			dwfzone_table.dwfzone_type,
			l.exit_topelev,
			l.exit_elev,
			l.fluid_type,
			st_length2d(l.the_geom)::numeric(12,3) AS gis_length,
			l.the_geom,
			l.expl_id2,
			l.epa_type,
			l.is_operative,
			l.conneccat_id,
			l.workcat_id,
			l.workcat_id_end,
			sector_table.stylesheet ->> 'featureColor'::text AS sector_style,
			dma_table.stylesheet ->> 'featureColor'::text AS dma_style,
			drainzone_table.stylesheet ->> 'featureColor'::text AS drainzone_style,
			dwfzone_table.stylesheet ->> 'featureColor'::text AS dwfzone_style,
			l.builtdate,
			l.enddate,
			date_trunc('second'::text, l.lastupdate) AS lastupdate,
			l.lastupdate_user,
			l.uncertain
			from inp_network_mode, link_state
			JOIN link l using (link_id)
			JOIN selector_expl se ON (se.cur_user =current_user AND se.expl_id = l.expl_id) OR (se.cur_user =current_user AND se.expl_id = l.expl_id2)
			JOIN exploitation ON l.expl_id = exploitation.expl_id
			JOIN ext_municipality mu ON l.muni_id = mu.muni_id
			JOIN sector_table ON l.sector_id = sector_table.sector_id
			LEFT JOIN dma_table ON l.dma_id = dma_table.dma_id
			LEFT join drainzone_table ON l.dma_id = drainzone_table.drainzone_id
			LEFT JOIN dwfzone_table ON l.dwfzone_id = dwfzone_table.dwfzone_id
		)
     SELECT link_selected.*
	 FROM link_selected;



CREATE OR REPLACE VIEW v_edit_link_connec
as select * from v_edit_link where feature_type = 'CONNEC';

CREATE OR REPLACE VIEW v_edit_link_gully
as select * from v_edit_link where feature_type = 'GULLY';

DROP VIEW IF EXISTS v_edit_drainzone;

CREATE OR REPLACE VIEW v_edit_drainzone
AS SELECT d.drainzone_id,
    d.name,
    et.idval as drainzone_type,
    d.descript,
    d.undelete,
    d.graphconfig::text AS graphconfig,
    d.stylesheet::text AS stylesheet,
    d.tstamp,
    d.insert_user,
    d.lastupdate,
    d.lastupdate_user,
    d.link,
    d.the_geom,
    d.expl_id
   FROM selector_expl,
    drainzone d
    LEFT JOIN edit_typevalue et ON et.id::text = d.drainzone_type::text AND et.typevalue::text = 'drainzone_type'::text
  WHERE d.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text;

CREATE OR REPLACE VIEW v_edit_dwfzone
AS SELECT d.dwfzone_id,
    d.name,
    et.idval as dwfzone_type,
    d.descript,
    d.undelete,
    d.graphconfig::text AS graphconfig,
    d.stylesheet::text AS stylesheet,
    d.tstamp,
    d.insert_user,
    d.lastupdate,
    d.lastupdate_user,
    d.link,
    d.the_geom,
    d.expl_id
   FROM selector_expl e,
    dwfzone d
    LEFT JOIN edit_typevalue et ON et.id::text = d.dwfzone_type::text AND et.typevalue::text = 'dwfzone_type'::text
  WHERE d.expl_id = e.expl_id AND e.cur_user = "current_user"()::text;


-- recreate all deleted views: arc, node, connec, gully and dependencies
-----------------------------------
CREATE OR REPLACE VIEW vu_arc AS
WITH streetaxis as (SELECT id, descript FROM v_ext_streetaxis)
SELECT arc.arc_id,
    arc.code,
    arc.node_1,
    arc.nodetype_1,
    arc.y1,
    arc.custom_y1,
    arc.elev1,
    arc.custom_elev1,
        CASE
            WHEN arc.sys_elev1 IS NULL THEN arc.node_sys_elev_1
            ELSE arc.sys_elev1
        END AS sys_elev1,
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
    arc.y2,
    arc.custom_y2,
    arc.elev2,
    arc.custom_elev2,
        CASE
            WHEN arc.sys_elev2 IS NULL THEN arc.node_sys_elev_2
            ELSE arc.sys_elev2
        END AS sys_elev2,
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
    arc.sys_slope AS slope,
    arc.arc_type,
    cat_feature.feature_class AS sys_type,
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
    arc.epa_type,
    arc.state,
    arc.state_type,
    arc.expl_id,
    e.macroexpl_id,
    arc.sector_id,
    s.sector_type,
    s.macrosector_id,
    arc.drainzone_id,
    drainzone.drainzone_type,
    arc.annotation,
    st_length(arc.the_geom)::numeric(12,2) AS gis_length,
    arc.custom_length,
    arc.inverted_slope,
    arc.observ,
    arc.comment,
    arc.dma_id,
    m.macrodma_id,
    m.dma_type,
    arc.soilcat_id,
    arc.function_type,
    arc.category_type,
    arc.fluid_type,
    arc.location_type,
    arc.workcat_id,
    arc.workcat_id_end,
    arc.workcat_id_plan,
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
    mu.region_id,
    mu.province_id,
    arc.descript,
    concat(cat_feature.link_path, arc.link) AS link,
    arc.verified,
    arc.undelete,
    cat_arc.label,
    arc.label_x,
    arc.label_y,
    arc.label_rotation,
    arc.label_quadrant,
    arc.publish,
    arc.inventory,
    arc.uncertain,
    arc.num_value,
    arc.asset_id,
    arc.pavcat_id,
    arc.parent_id,
    arc.expl_id2,
    vst.is_operative,
    arc.minsector_id,
    arc.macrominsector_id,
    arc.adate,
    arc.adescript,
    arc.visitability,
	date_trunc('second'::text, arc.tstamp) AS tstamp,
    arc.insert_user,
    date_trunc('second'::text, arc.lastupdate) AS lastupdate,
    arc.lastupdate_user,
    arc.the_geom,
    case when arc.sector_id > 0 and is_operative = true and epa_type !='UNDEFINED'::varchar(16) THEN epa_type else NULL::varchar(16) end as inp_type,
    arc.brand_id,
    arc.model_id,
    arc.serial_number,
    arc.is_scadamap
   FROM arc
     JOIN cat_arc ON arc.arccat_id::text = cat_arc.id::text
     JOIN cat_feature ON arc.arc_type::text = cat_feature.id::text
     JOIN sector s ON s.sector_id = arc.sector_id
     JOIN exploitation e USING (expl_id)
     JOIN dma m USING (dma_id)
     LEFT JOIN streetaxis c ON c.id::text = arc.streetaxis_id::text
     LEFT JOIN streetaxis d ON d.id::text = arc.streetaxis2_id::text
     LEFT JOIN value_state_type vst ON vst.id = arc.state_type
     LEFT JOIN ext_municipality mu ON arc.muni_id = mu.muni_id
     LEFT JOIN drainzone USING (drainzone_id);


CREATE OR REPLACE VIEW v_edit_arc
AS WITH
	typevalue AS
       (
			SELECT edit_typevalue.typevalue, edit_typevalue.id, edit_typevalue.idval
			FROM edit_typevalue
			WHERE edit_typevalue.typevalue::text = ANY (ARRAY['sector_type'::character varying::text, 'drainzone_type'::character varying::text, 'dma_type'::character varying::text, 'dwfzone_type'::character varying::text])
        ),
    sector_table AS
		(
			SELECT sector_id, macrosector_id, stylesheet, id::varchar(16) AS sector_type
			FROM sector
			LEFT JOIN typevalue t ON t.id::text = sector.sector_type AND t.typevalue::text = 'sector_type'::text
		),
	dma_table AS
		(
			SELECT dma_id, macrodma_id, stylesheet, id::varchar(16) AS dma_type
			FROM dma
			LEFT JOIN typevalue t ON t.id::text = dma.dma_type AND t.typevalue::text = 'dma_type'::text
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
			LEFT JOIN (SELECT arc_id FROM arc_psector WHERE p_state = 0) a using (arc_id)  where a.arc_id IS NULL
			UNION ALL
			SELECT arc_id FROM arc_psector WHERE p_state = 1
         ),
    arc_selected AS
		(
			SELECT arc.arc_id,
			arc.code,
			arc.node_1,
			arc.nodetype_1,
			arc.y1,
			arc.custom_y1,
			arc.elev1,
			arc.custom_elev1,
	        CASE
	            WHEN arc.sys_elev1 IS NULL THEN arc.node_sys_elev_1
	            ELSE arc.sys_elev1
	        END AS sys_elev1,
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
			arc.y2,
			arc.custom_y2,
			arc.elev2,
			arc.custom_elev2,
	        CASE
	            WHEN arc.sys_elev2 IS NULL THEN arc.node_sys_elev_2
	            ELSE arc.sys_elev2
	        END AS sys_elev2,
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
			arc.sys_slope AS slope,
			arc.arc_type,
			cat_feature.feature_class AS sys_type,
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
			arc.epa_type,
			arc.state,
			arc.state_type,
			arc.expl_id,
			e.macroexpl_id,
			arc.sector_id,
			sector_table.sector_type,
			sector_table.macrosector_id,
			arc.drainzone_id,
			drainzone_table.drainzone_type,
			arc.annotation,
			st_length(arc.the_geom)::numeric(12,2) AS gis_length,
			arc.custom_length,
			arc.inverted_slope,
			arc.observ,
			arc.comment,
			arc.dma_id,
			dma_table.macrodma_id,
			dma_table.dma_type,
			arc.dwfzone_id,
			dwfzone_table.dwfzone_type,
			arc.soilcat_id,
			arc.function_type,
			arc.category_type,
			arc.fluid_type,
			arc.location_type,
			arc.workcat_id,
			arc.workcat_id_end,
			arc.workcat_id_plan,
			sector_table.stylesheet ->> 'featureColor'::text AS sector_style,
			dma_table.stylesheet ->> 'featureColor'::text AS dma_style,
			drainzone_table.stylesheet ->> 'featureColor'::text AS drainzone_style,
			dwfzone_table.stylesheet ->> 'featureColor'::text AS dwfzone_style,
			arc.builtdate,
			arc.enddate,
			arc.buildercat_id,
			arc.ownercat_id,
			arc.muni_id,
			arc.postcode,
			arc.district_id,
			streetname,
			arc.postnumber,
			arc.postcomplement,
			streetname2,
			arc.postnumber2,
			arc.postcomplement2,
			mu.region_id,
			mu.province_id,
			arc.descript,
			concat(cat_feature.link_path, arc.link) AS link,
			arc.verified,
			arc.undelete,
			cat_arc.label,
			arc.label_x,
			arc.label_y,
			arc.label_rotation,
			arc.label_quadrant,
			arc.publish,
			arc.inventory,
			arc.uncertain,
			arc.num_value,
			arc.asset_id,
			arc.pavcat_id,
			arc.parent_id,
			arc.expl_id2,
			vst.is_operative,
			arc.minsector_id,
			arc.macrominsector_id,
			arc.adate,
			arc.adescript,
			arc.visitability,
			date_trunc('second'::text, arc.tstamp) AS tstamp,
			arc.insert_user,
			date_trunc('second'::text, arc.lastupdate) AS lastupdate,
			arc.lastupdate_user,
			arc.the_geom,
	        CASE
	            WHEN arc.sector_id > 0 AND vst.is_operative = true AND arc.epa_type::text <> 'UNDEFINED'::character varying(16)::text THEN arc.epa_type
	            ELSE NULL::character varying(16)
	        END AS inp_type,
			arc.brand_id,
			arc.model_id,
			arc.serial_number,
            arc.initoverflowpath,
            arc.lock_level,
            arc.is_scadamap
			FROM arc_selector
			JOIN arc using (arc_id)
			JOIN selector_expl se ON (se.cur_user =current_user AND se.expl_id = arc.expl_id) or (se.cur_user = current_user AND se.expl_id = arc.expl_id2)
			JOIN selector_sector sc ON (sc.cur_user = CURRENT_USER AND sc.sector_id = arc.sector_id)
			JOIN cat_arc ON arc.arccat_id::text = cat_arc.id::text
			JOIN cat_feature ON arc.arc_type::text = cat_feature.id::text
			JOIN exploitation e on e.expl_id = arc.expl_id
			JOIN ext_municipality mu ON arc.muni_id = mu.muni_id
			JOIN value_state_type vst ON vst.id = arc.state_type
			JOIN sector_table on sector_table.sector_id = arc.sector_id
			LEFT JOIN dma_table on dma_table.dma_id = arc.dma_id
			LEFT JOIN drainzone_table ON arc.dma_id = drainzone_table.drainzone_id
			LEFT JOIN dwfzone_table ON arc.dwfzone_id = dwfzone_table.dwfzone_id
            LEFT JOIN arc_add a ON a.arc_id::text = arc.arc_id::text
		)
	SELECT arc_selected.*
	FROM arc_selected;


CREATE OR REPLACE VIEW vu_node AS
WITH vu_node AS (SELECT node.node_id,
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
            cat_feature.feature_class AS sys_type,
            node.nodecat_id,
                CASE
                    WHEN node.matcat_id IS NULL THEN cat_node.matcat_id
                    ELSE node.matcat_id
                END AS matcat_id,
            node.epa_type,
            node.expl_id,
            exploitation.macroexpl_id,
            node.sector_id,
            sector.sector_type,
            sector.macrosector_id,
            node.state,
            node.state_type,
            node.annotation,
            node.observ,
            node.comment,
            node.dma_id,
            dma.macrodma_id,
            dma.dma_type,
            node.soilcat_id,
            node.function_type,
            node.category_type,
            node.fluid_type,
            node.location_type,
            node.workcat_id,
            node.workcat_id_end,
            node.workcat_id_plan,
            node.buildercat_id,
            node.builtdate,
            node.enddate,
            node.ownercat_id,
            node.muni_id,
            node.postcode,
            node.district_id,
            c.descript::character varying(100) AS streetname,
            node.postnumber,
            node.postcomplement,
            d.descript::character varying(100) AS streetname2,
            node.postnumber2,
            node.postcomplement2,
			mu.region_id,
            mu.province_id,
            node.descript,
            cat_node.svg,
            node.rotation,
            concat(cat_feature.link_path, node.link) AS link,
            node.verified,
            node.undelete,
            cat_node.label,
            node.label_x,
            node.label_y,
            node.label_rotation,
            node.label_quadrant,
            node.publish,
            node.inventory,
            node.uncertain,
            node.xyz_date,
            node.unconnected,
            node.num_value,
            node.asset_id,
            node.drainzone_id,
            drainzone.drainzone_type,
            node.parent_id,
            node.arc_id,
            node.expl_id2,
            vst.is_operative,
            node.minsector_id,
            node.macrominsector_id,
            node.adate,
            node.adescript,
            node.placement_type,
            node.access_type,
			date_trunc('second'::text, node.tstamp) AS tstamp,
            node.insert_user,
            date_trunc('second'::text, node.lastupdate) AS lastupdate,
            node.lastupdate_user,
            node.the_geom,
            node.brand_id,
            node.model_id,
            node.serial_number,
            node.is_scadamap
           FROM node
             LEFT JOIN cat_node ON node.nodecat_id::text = cat_node.id::text
             LEFT JOIN cat_feature ON cat_feature.id::text = node.node_type::text
             LEFT JOIN dma ON node.dma_id = dma.dma_id
             LEFT JOIN sector ON node.sector_id = sector.sector_id
             LEFT JOIN exploitation ON node.expl_id = exploitation.expl_id
             LEFT JOIN v_ext_streetaxis c ON c.id::text = node.streetaxis_id::text
             LEFT JOIN v_ext_streetaxis d ON d.id::text = node.streetaxis2_id::text
             LEFT JOIN value_state_type vst ON vst.id = node.state_type
             LEFT JOIN ext_municipality mu ON node.muni_id = mu.muni_id
             LEFT JOIN drainzone USING (drainzone_id)
        ),
 streetaxis as (SELECT id, descript FROM v_ext_streetaxis)
 SELECT vu_node.node_id,
    vu_node.code,
    vu_node.top_elev,
    vu_node.custom_top_elev,
    vu_node.sys_top_elev,
    vu_node.ymax,
    vu_node.custom_ymax,
        CASE
            WHEN vu_node.sys_ymax IS NOT NULL THEN vu_node.sys_ymax
            ELSE (vu_node.sys_top_elev - vu_node.sys_elev)::numeric(12,3)
        END AS sys_ymax,
    vu_node.elev,
    vu_node.custom_elev,
        CASE
            WHEN vu_node.sys_elev IS NOT NULL THEN vu_node.sys_elev
            ELSE (vu_node.sys_top_elev - vu_node.sys_ymax)::numeric(12,3)
        END AS sys_elev,
    vu_node.node_type,
    vu_node.sys_type,
    vu_node.nodecat_id,
    vu_node.matcat_id,
    vu_node.epa_type,
    vu_node.state,
    vu_node.state_type,
    vu_node.expl_id,
    vu_node.macroexpl_id,
    vu_node.sector_id,
    vu_node.sector_type,
    vu_node.macrosector_id,
    vu_node.drainzone_id,
    vu_node.drainzone_type,
    vu_node.annotation,
    vu_node.observ,
    vu_node.comment,
    vu_node.dma_id,
    vu_node.macrodma_id,
    vu_node.soilcat_id,
    vu_node.function_type,
    vu_node.category_type,
    vu_node.fluid_type,
    vu_node.location_type,
    vu_node.workcat_id,
    vu_node.workcat_id_end,
    vu_node.buildercat_id,
    vu_node.builtdate,
    vu_node.enddate,
    vu_node.ownercat_id,
    vu_node.muni_id,
    vu_node.postcode,
    vu_node.district_id,
    vu_node.streetname,
    vu_node.postnumber,
    vu_node.postcomplement,
    vu_node.streetname2,
    vu_node.postnumber2,
    vu_node.postcomplement2,
    vu_node.region_id,
    vu_node.province_id,
    vu_node.descript,
    vu_node.svg,
    vu_node.rotation,
    vu_node.link,
    vu_node.verified,
    vu_node.the_geom,
    vu_node.undelete,
    vu_node.label,
    vu_node.label_x,
    vu_node.label_y,
    vu_node.label_rotation,
    vu_node.label_quadrant,
    vu_node.publish,
    vu_node.inventory,
    vu_node.uncertain,
    vu_node.xyz_date,
    vu_node.unconnected,
    vu_node.num_value,
    vu_node.tstamp,
    vu_node.insert_user,
    vu_node.lastupdate,
    vu_node.lastupdate_user,
    vu_node.workcat_id_plan,
    vu_node.asset_id,
    vu_node.parent_id,
    vu_node.arc_id,
    vu_node.expl_id2,
    vu_node.is_operative,
    vu_node.minsector_id,
    vu_node.macrominsector_id,
    vu_node.adate,
    vu_node.adescript,
    vu_node.placement_type,
    vu_node.access_type,
    brand_id,
    model_id,
    serial_number
   FROM vu_node;


CREATE OR REPLACE VIEW v_edit_node
AS WITH
	typevalue AS
       (
			SELECT edit_typevalue.typevalue, edit_typevalue.id, edit_typevalue.idval
			FROM edit_typevalue
			WHERE edit_typevalue.typevalue::text = ANY (ARRAY['sector_type'::character varying::text, 'drainzone_type'::character varying::text, 'dma_type'::character varying::text, 'dwfzone_type'::character varying::text])
        ),
    sector_table AS
		(
			SELECT sector_id, macrosector_id, stylesheet, id::varchar(16) AS sector_type
			FROM sector
			LEFT JOIN typevalue t ON t.id::text = sector.sector_type AND t.typevalue::text = 'sector_type'::text
		),
	dma_table AS
		(
			SELECT dma_id, macrodma_id, stylesheet, id::varchar(16) AS dma_type
			FROM dma
			LEFT JOIN typevalue t ON t.id::text = dma.dma_type AND t.typevalue::text = 'dma_type'::text
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
			JOIN selector_state s ON s.cur_user = current_user AND node.state = s.state_id
			LEFT JOIN (SELECT node_id FROM node_psector WHERE p_state = 0) a USING (node_id) WHERE a.node_id IS NULL
			UNION ALL
			SELECT node_id FROM node_psector WHERE p_state = 1
        ),
    node_selected AS
    	(
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
			cat_feature.feature_class AS sys_type,
			node.nodecat_id,
			CASE
				WHEN node.matcat_id IS NULL THEN cat_node.matcat_id
				ELSE node.matcat_id
			END AS matcat_id,
			node.epa_type,
			node.state,
			node.state_type,
			node.expl_id,
			exploitation.macroexpl_id,
			node.sector_id,
			sector_table.sector_type,
			sector_table.macrosector_id,
			node.drainzone_id,
			drainzone_table.drainzone_type,
			node.annotation,
			node.observ,
			node.comment,
			node.dma_id,
			dma_table.macrodma_id,
			node.dwfzone_id,
			dwfzone_table.dwfzone_type,
			node.soilcat_id,
			node.function_type,
			node.category_type,
			node.fluid_type,
			node.location_type,
			sector_table.stylesheet ->> 'featureColor'::text AS sector_style,
			dma_table.stylesheet ->> 'featureColor'::text AS dma_style,
			drainzone_table.stylesheet ->> 'featureColor'::text AS drainzone_style,
			dwfzone_table.stylesheet ->> 'featureColor'::text AS dwfzone_style,
			node.workcat_id,
			node.workcat_id_end,
			node.buildercat_id,
			node.builtdate,
			node.enddate,
			node.ownercat_id,
			node.muni_id,
			node.postcode,
			node.district_id,
			streetname,
			node.postnumber,
			node.postcomplement,
			streetname2,
			node.postnumber2,
			node.postcomplement2,
			mu.region_id,
			mu.province_id,
			node.descript,
			cat_node.svg,
			node.rotation,
			concat(cat_feature.link_path, node.link) AS link,
			node.verified,
			node.the_geom,
			node.undelete,
			cat_node.label,
			node.label_x,
			node.label_y,
			node.label_rotation,
			node.label_quadrant,
			node.publish,
			node.inventory,
			node.uncertain,
			node.xyz_date,
			node.unconnected,
			node.num_value,
			date_trunc('second'::text, node.tstamp) AS tstamp,
			node.insert_user,
			date_trunc('second'::text, node.lastupdate) AS lastupdate,
			node.lastupdate_user,
			node.workcat_id_plan,
			node.asset_id,
			node.parent_id,
			node.arc_id,
			node.expl_id2,
			vst.is_operative,
			node.minsector_id,
			node.macrominsector_id,
			node.adate,
			node.adescript,
			node.placement_type,
			node.access_type,
			CASE
			  WHEN node.sector_id > 0 AND vst.is_operative = true AND node.epa_type::text <> 'UNDEFINED'::character varying(16)::text THEN node.epa_type
			  ELSE NULL::character varying(16)
			END AS inp_type,
			node.brand_id,
			node.model_id,
			node.serial_number,
            node.lock_level,
            node.is_scadamap
			FROM node_selector
			JOIN node USING (node_id)
			JOIN selector_expl se ON (se.cur_user = current_user AND se.expl_id = node.expl_id) OR (se.cur_user = current_user AND se.expl_id = node.expl_id2)
			JOIN selector_sector sc ON (sc.cur_user = CURRENT_USER AND sc.sector_id = node.sector_id)
			JOIN cat_node ON node.nodecat_id::text = cat_node.id::text
			JOIN cat_feature ON cat_feature.id::text = node.node_type::text
			JOIN exploitation ON node.expl_id = exploitation.expl_id
			JOIN ext_municipality mu ON node.muni_id = mu.muni_id
			JOIN value_state_type vst ON vst.id = node.state_type
			JOIN sector_table ON sector_table.sector_id = node.sector_id
			LEFT JOIN dma_table ON dma_table.dma_id = node.dma_id
			LEFT JOIN drainzone_table ON node.dma_id = drainzone_table.drainzone_id
			LEFT JOIN dwfzone_table ON node.dwfzone_id = dwfzone_table.dwfzone_id
            LEFT JOIN node_add e ON e.node_id::text = node.node_id::text
    	),
    node_base AS
        (
			SELECT
			node_id,
			code,
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
			node_type,
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
			dma_id,
			macrodma_id,
			dwfzone_id,
			dwfzone_type,
			soilcat_id,
			function_type,
			category_type,
			fluid_type,
			location_type,
			sector_style,
			dma_style,
			drainzone_style,
			dwfzone_style,
			workcat_id,
			workcat_id_end,
			buildercat_id,
			builtdate,
			enddate,
			ownercat_id,
			muni_id,
			postcode,
			district_id,
			streetname,
			postnumber,
			postcomplement,
			streetname2,
			postnumber2,
			postcomplement2,
			region_id,
			province_id,
			descript,
			svg,
			rotation,
			link,
			verified,
			the_geom,
			undelete,
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
			tstamp,
			insert_user,
			lastupdate,
			lastupdate_user,
			workcat_id_plan,
			asset_id,
			parent_id,
			arc_id,
			expl_id2,
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
            lock_level
			FROM node_selected
		)
	SELECT node_base.*
	FROM node_base;


CREATE OR REPLACE VIEW vu_connec AS
WITH streetaxis as (SELECT id, descript FROM v_ext_streetaxis)
SELECT connec.connec_id,
    connec.code,
    connec.customer_code,
    connec.top_elev,
    connec.y1,
    connec.y2,
    connec.conneccat_id,
    connec.connec_type,
    cat_feature.feature_class AS sys_type,
    connec.private_conneccat_id,
        CASE
            WHEN connec.matcat_id IS NULL THEN cat_connec.matcat_id
            ELSE connec.matcat_id
        END AS matcat_id,
	connec.state,
    connec.state_type,
    connec.expl_id,
    exploitation.macroexpl_id,
    connec.sector_id,
    sector.sector_type,
    sector.macrosector_id,
	connec.drainzone_id,
    drainzone.drainzone_type,
	connec.dma_id,
    dma.macrodma_id,
    dma.dma_type,
    connec.demand,
        CASE
            WHEN ((connec.y1 + connec.y2) / 2::numeric) IS NOT NULL THEN ((connec.y1 + connec.y2) / 2::numeric)::numeric(12,3)
            ELSE connec.connec_depth
        END AS connec_depth,
    connec.connec_length,
    connec.arc_id,
    connec.annotation,
    connec.observ,
    connec.comment,
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
    d.descript::character varying(100) AS streetname2,
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
    connec.accessibility,
    connec.diagonal,
    connec.publish,
    connec.inventory,
    connec.uncertain,
    connec.num_value,
    connec.pjoint_id,
    connec.pjoint_type,
    connec.asset_id,
    connec.expl_id2,
    vst.is_operative,
    connec.minsector_id,
    connec.macrominsector_id,
    connec.adate,
    connec.adescript,
    connec.plot_code,
    connec.placement_type,
    connec.access_type,
    date_trunc('second'::text, connec.tstamp) AS tstamp,
    connec.insert_user,
    date_trunc('second'::text, connec.lastupdate) AS lastupdate,
    connec.lastupdate_user,
    connec.the_geom
   FROM connec
     JOIN cat_connec ON connec.conneccat_id::text = cat_connec.id::text
     LEFT JOIN ext_streetaxis ON connec.streetaxis_id::text = ext_streetaxis.id::text
     LEFT JOIN dma ON connec.dma_id = dma.dma_id
     LEFT JOIN exploitation ON connec.expl_id = exploitation.expl_id
     LEFT JOIN sector ON connec.sector_id = sector.sector_id
     LEFT JOIN cat_feature ON connec.connec_type::text = cat_feature.id::text
     LEFT JOIN streetaxis c ON c.id::text = connec.streetaxis_id::text
     LEFT JOIN streetaxis d ON d.id::text = connec.streetaxis2_id::text
     LEFT JOIN value_state_type vst ON vst.id = connec.state_type
     LEFT JOIN ext_municipality mu ON connec.muni_id = mu.muni_id
     LEFT JOIN drainzone USING (drainzone_id);

CREATE OR REPLACE VIEW v_edit_connec
AS WITH
	typevalue AS
       (
			SELECT edit_typevalue.typevalue, edit_typevalue.id, edit_typevalue.idval
			FROM edit_typevalue
			WHERE edit_typevalue.typevalue::text = ANY (ARRAY['sector_type'::character varying::text, 'drainzone_type'::character varying::text, 'dma_type'::character varying::text, 'dwfzone_type'::character varying::text])
        ),
    sector_table AS
		(
			SELECT sector_id, macrosector_id, stylesheet, id::varchar(16) AS sector_type
			FROM sector
			LEFT JOIN typevalue t ON t.id::text = sector.sector_type AND t.typevalue::text = 'sector_type'::text
		),
	dma_table AS
		(
			SELECT dma_id, macrodma_id, stylesheet, id::varchar(16) AS dma_type
			FROM dma
			LEFT JOIN typevalue t ON t.id::text = dma.dma_type AND t.typevalue::text = 'dma_type'::text
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
			SELECT link_id, feature_id, feature_type, exit_id, exit_type, l.expl_id, macroexpl_id, l.sector_id, sector_type, macrosector_id, l.dma_id, macrodma_id, dma_type,
			l.drainzone_id, drainzone_type, l.dwfzone_id, dwfzone_type,
		    fluid_type
			FROM link l
			JOIN exploitation USING (expl_id)
			JOIN sector_table ON l.sector_id = sector_table.sector_id
			LEFT JOIN dma_table ON l.dma_id = dma_table.dma_id
			LEFT JOIN drainzone_table ON l.dma_id = drainzone_table.drainzone_id
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
			SELECT connec_id, arc_id::varchar(16), NULL::integer AS link_id
			FROM connec
			JOIN selector_state ss ON ss.cur_user = current_user AND connec.state = ss.state_id
			LEFT JOIN (SELECT connec_id, arc_id::varchar(16) FROM connec_psector WHERE p_state = 0) a USING (connec_id, arc_id) WHERE a.connec_id IS NULL
			UNION ALL
			SELECT connec_id, connec_psector.arc_id::varchar(16), link_id FROM connec_psector
			WHERE p_state = 1
        ),
    connec_selected AS
    	(
			SELECT connec.connec_id,
			connec.code,
			connec.customer_code,
			connec.top_elev,
			connec.y1,
			connec.y2,
			connec.conneccat_id,
			connec.connec_type,
			cat_feature.feature_class as sys_type,
			connec.private_conneccat_id,
			connec.matcat_id,
			connec.state,
			connec.state_type,
			connec.expl_id,
			exploitation.macroexpl_id,
			CASE
				WHEN link_planned.sector_id IS NULL THEN connec.sector_id
				ELSE link_planned.sector_id
			END AS sector_id,
			sector_table.sector_type,
			CASE
				WHEN link_planned.macrosector_id IS NULL THEN sector_table.macrosector_id
				ELSE link_planned.macrosector_id
			END AS macrosector_id,
			CASE
				WHEN link_planned.drainzone_id IS NULL THEN connec.drainzone_id
				ELSE link_planned.drainzone_id
			END AS drainzone_id,
			CASE
				WHEN link_planned.drainzone_type IS NULL THEN drainzone_table.drainzone_type
				ELSE link_planned.drainzone_type
			END AS drainzone_type,
			connec.demand,
			connec.connec_depth,
			connec.connec_length,
			connec_selector.arc_id,
			connec.annotation,
			connec.observ,
			connec.comment,
			CASE
				WHEN link_planned.dma_id IS NULL THEN connec.dma_id
				ELSE link_planned.dma_id
			END AS dma_id,
			CASE
				WHEN link_planned.macrodma_id IS NULL THEN dma_table.macrodma_id
				ELSE link_planned.macrodma_id
			END AS macrodma_id,
			CASE
				WHEN link_planned.dma_type IS NULL THEN dma_table.dma_type
				ELSE link_planned.dma_type
			END AS dma_type,
			CASE
				WHEN link_planned.dwfzone_type IS NULL THEN dwfzone_table.dwfzone_type
				ELSE link_planned.dwfzone_type
			END AS dwfzone_type,
			connec.soilcat_id,
			connec.function_type,
			connec.category_type,
			connec.fluid_type,
			connec.location_type,
			sector_table.stylesheet ->> 'featureColor'::text AS sector_style,
			dma_table.stylesheet ->> 'featureColor'::text AS dma_style,
			drainzone_table.stylesheet ->> 'featureColor'::text AS drainzone_style,
			dwfzone_table.stylesheet ->> 'featureColor'::text AS dwfzone_style,
			connec.workcat_id,
			connec.workcat_id_end,
			connec.buildercat_id,
			connec.builtdate,
			connec.enddate,
			connec.ownercat_id,
			connec.muni_id,
			connec.postcode,
			connec.district_id,
			connec.streetname,
			connec.postnumber,
			connec.postcomplement,
			connec.streetname2,
			connec.postnumber2,
			connec.postcomplement2,
			mu.region_id,
			mu.province_id,
			connec.descript,
			cat_connec.svg,
			connec.rotation,
			connec.link::text,
			connec.verified,
			connec.undelete,
			cat_connec.label,
			connec.label_x,
			connec.label_y,
			connec.label_rotation,
			connec.label_quadrant,
			connec.accessibility,
			connec.diagonal,
			connec.publish,
			connec.inventory,
			connec.uncertain,
			connec.num_value,
			CASE
				WHEN link_planned.exit_id IS NULL THEN connec.pjoint_id
				ELSE link_planned.exit_id
			END AS pjoint_id,
			CASE
				WHEN link_planned.exit_type IS NULL THEN connec.pjoint_type
				ELSE link_planned.exit_type
			END AS pjoint_type,
			connec.tstamp,
			connec.insert_user,
			connec.lastupdate,
			connec.lastupdate_user,
			connec.the_geom,
			connec.workcat_id_plan,
			connec.asset_id,
			connec.expl_id2,
			vst.is_operative,
			connec.minsector_id,
			connec.macrominsector_id,
			connec.adate,
			connec.adescript,
			connec.plot_code,
			connec.placement_type,
			connec.access_type,
			connec.lock_level
			FROM connec_selector
			JOIN connec USING (connec_id)
			JOIN selector_expl se ON (se.cur_user = current_user AND se.expl_id = connec.expl_id) OR (se.cur_user = current_user AND se.expl_id = connec.expl_id2)
			JOIN selector_sector sc ON (sc.cur_user = CURRENT_USER AND sc.sector_id = connec.sector_id)
			JOIN cat_connec ON cat_connec.id::text = connec.conneccat_id::text
			JOIN cat_feature ON cat_feature.id::text = connec.connec_type::text
			JOIN exploitation ON connec.expl_id = exploitation.expl_id
			JOIN ext_municipality mu ON connec.muni_id = mu.muni_id
			JOIN value_state_type vst ON vst.id = connec.state_type
			JOIN sector_table ON sector_table.sector_id = connec.sector_id
			LEFT JOIN dma_table ON dma_table.dma_id = connec.dma_id
			LEFT JOIN drainzone_table ON connec.dma_id = drainzone_table.drainzone_id
			LEFT JOIN dwfzone_table ON connec.dwfzone_id = dwfzone_table.dwfzone_id
			LEFT JOIN link_planned USING (link_id)
	   )
	SELECT connec_selected.*
	FROM connec_selected;

CREATE OR REPLACE VIEW vu_gully AS
 WITH streetaxis AS (
         SELECT v_ext_streetaxis.id,
            v_ext_streetaxis.descript
           FROM v_ext_streetaxis
        ), inp_netw_mode AS (
         WITH inp_netw_mode_aux AS (
                 SELECT count(*) AS t
                   FROM config_param_user
                  WHERE config_param_user.parameter::text = 'inp_options_networkmode'::text AND config_param_user.cur_user::text = CURRENT_USER
                )
         SELECT
                CASE
                    WHEN inp_netw_mode_aux.t > 0 THEN ( SELECT config_param_user.value
                       FROM config_param_user
                      WHERE config_param_user.parameter::text = 'inp_options_networkmode'::text AND config_param_user.cur_user::text = CURRENT_USER)
                    ELSE NULL::text
                END AS value
           FROM inp_netw_mode_aux
        )
 SELECT gully.gully_id,
    gully.code,
    gully.top_elev,
    gully.ymax,
    gully.sandbox,
    gully.matcat_id,
    gully.gully_type,
    cat_feature.feature_class AS sys_type,
    gully.gullycat_id,
    cat_gully.matcat_id AS cat_gully_matcat,
    cat_gully.width AS grate_width,
    cat_gully.length AS grate_length,
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
    cat_gully.svg,
    gully.rotation,
    concat(cat_feature.link_path, gully.link) AS link,
    gully.verified,
    gully.undelete,
    cat_gully.label,
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
    gully.gullycat2_id,
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
   FROM (SELECT inp_netw_mode.value FROM inp_netw_mode) cpu, gully
     LEFT JOIN cat_gully ON gully.gullycat_id::text = cat_gully.id::text
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

CREATE OR REPLACE VIEW v_edit_gully
AS WITH
	typevalue AS
       (
			SELECT edit_typevalue.typevalue, edit_typevalue.id, edit_typevalue.idval
			FROM edit_typevalue
			WHERE edit_typevalue.typevalue::text = ANY (ARRAY['sector_type'::character varying::text, 'drainzone_type'::character varying::text, 'dma_type'::character varying::text, 'dwfzone_type'::character varying::text])
        ),
    sector_table AS
		(
			SELECT sector_id, macrosector_id, stylesheet, id::varchar(16) AS sector_type
			FROM sector
			LEFT JOIN typevalue t ON t.id::text = sector.sector_type AND t.typevalue::text = 'sector_type'::text
		),
	dma_table AS
		(
			SELECT dma_id, macrodma_id, stylesheet, id::varchar(16) AS dma_type
			FROM dma
			LEFT JOIN typevalue t ON t.id::text = dma.dma_type AND t.typevalue::text = 'dma_type'::text
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
			SELECT link_id, feature_id, feature_type, exit_id, exit_type, l.expl_id, macroexpl_id, l.sector_id, sector_type, macrosector_id, l.dma_id, dma_type, macrodma_id,
			l.drainzone_id, drainzone_type, l.dwfzone_id, dwfzone_type,
			fluid_type
			FROM link l
			JOIN exploitation USING (expl_id)
			JOIN sector_table ON l.sector_id = sector_table.sector_id
			LEFT JOIN dma_table ON l.dma_id = dma_table.dma_id
			LEFT JOIN drainzone_table ON l.dma_id = drainzone_table.drainzone_id
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
			SELECT gully_id, arc_id::varchar(16), null::integer as link_id
			FROM gully
			JOIN selector_state ss ON ss.cur_user = current_user AND gully.state = ss.state_id
			LEFT JOIN (SELECT gully_id, arc_id FROM gully_psector WHERE p_state = 0) a USING (gully_id, arc_id) WHERE a.gully_id IS NULL
			UNION ALL
			SELECT gully_id, gully_psector.arc_id::varchar(16), link_id FROM gully_psector
			WHERE p_state = 1
        ),
    gully_selected AS
    	(
			SELECT gully.gully_id,
			gully.code,
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
			gully.connec_arccat_id,
			gully.connec_length,
			CASE
			   WHEN ((gully.top_elev - gully.ymax + gully.sandbox + gully.connec_y2) / 2::numeric) IS NOT NULL THEN ((gully.top_elev - gully.ymax + gully.sandbox + gully.connec_y2) / 2::numeric)::numeric(12,3)
			   ELSE gully.connec_depth
			END AS connec_depth,
			CASE
				WHEN gully.connec_matcat_id IS NULL THEN cc.matcat_id::text
				ELSE gully.connec_matcat_id
			END AS connec_matcat_id,
			gully.top_elev - gully.ymax + gully.sandbox AS connec_y1,
			gully.connec_y2,
			cat_gully.width AS grate_width,
			cat_gully.length AS grate_length,
			gully.arc_id,
			gully.epa_type,
			CASE
			   WHEN gully.sector_id > 0 AND vst.is_operative = true AND gully.epa_type::text = 'GULLY'::character varying(16)::text AND inp_network_mode.value = '2'::text THEN gully.epa_type
			   ELSE NULL::character varying(16)
			END AS inp_type,
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
			CASE
				WHEN link_planned.drainzone_id IS NULL THEN drainzone_table.drainzone_id
				ELSE link_planned.drainzone_id
			END AS drainzone_id,
			CASE
				WHEN link_planned.drainzone_type IS NULL THEN drainzone_table.drainzone_type
				ELSE link_planned.drainzone_type
			END AS drainzone_type,
			CASE
				WHEN link_planned.dma_id IS NULL THEN dma_table.dma_id
				ELSE link_planned.dma_id
			END AS dma_id,
			CASE
				WHEN link_planned.dma_type IS NULL THEN dma_table.dma_type
				ELSE link_planned.dma_type
			END AS dma_type,
			CASE
				WHEN link_planned.macrodma_id IS NULL THEN dma_table.macrodma_id
				ELSE link_planned.macrodma_id
			END AS macrodma_id,
			CASE
				WHEN link_planned.dwfzone_id IS NULL THEN dwfzone_table.dwfzone_id
				ELSE link_planned.dwfzone_id
			END AS dwfzone_id,
			CASE
				WHEN link_planned.dwfzone_type IS NULL THEN dwfzone_table.dwfzone_type
				ELSE link_planned.dwfzone_type
			END AS dwfzone_type,
			gully.annotation,
			gully.observ,
			gully.comment,
			gully.soilcat_id,
			gully.function_type,
			gully.category_type,
			gully.fluid_type,
			gully.location_type,
			gully.workcat_id,
			gully.workcat_id_end,
			gully.workcat_id_plan,
			sector_table.stylesheet ->> 'featureColor'::text AS sector_style,
			dma_table.stylesheet ->> 'featureColor'::text AS dma_style,
			drainzone_table.stylesheet ->> 'featureColor'::text AS drainzone_style,
			dwfzone_table.stylesheet ->> 'featureColor'::text AS dwfzone_style,
			gully.buildercat_id,
			gully.builtdate,
			gully.enddate,
			gully.ownercat_id,
			gully.muni_id,
			gully.postcode,
			gully.district_id,
			streetname,
			gully.postnumber,
			gully.postcomplement,
			streetname2,
			gully.postnumber2,
			gully.postcomplement2,
			mu.region_id,
			mu.province_id,
			gully.descript,
			cat_gully.svg,
			gully.rotation,
			concat(cat_feature.link_path, gully.link) AS link,
			gully.verified,
			gully.undelete,
			cat_gully.label,
			gully.label_x,
			gully.label_y,
			gully.label_rotation,
			gully.label_quadrant,
			gully.publish,
			gully.inventory,
			gully.uncertain,
			gully.num_value,
			CASE
				WHEN link_planned.exit_id IS NULL THEN gully.pjoint_id
				ELSE link_planned.exit_id
			END AS pjoint_id,
			CASE
				WHEN link_planned.exit_type IS NULL THEN gully.pjoint_type
				ELSE link_planned.exit_type
			END AS pjoint_type,
			gully.asset_id,
			gully.gullycat2_id,
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
			gully.lock_level
			FROM inp_network_mode, gully_selector
			JOIN gully using (gully_id)
			JOIN selector_expl se ON (se.cur_user = current_user AND se.expl_id = gully.expl_id) OR (se.cur_user = current_user AND se.expl_id = gully.expl_id2)
			JOIN selector_sector sc ON (sc.cur_user = CURRENT_USER AND sc.sector_id = gully.sector_id)
			JOIN cat_gully ON gully.gullycat_id::text = cat_gully.id::text
			JOIN exploitation ON gully.expl_id = exploitation.expl_id
			JOIN cat_feature ON gully.gully_type::text = cat_feature.id::text
			JOIN cat_connec cc ON cc.id::text = gully.connec_arccat_id::text
			JOIN value_state_type vst ON vst.id = gully.state_type
			JOIN ext_municipality mu ON gully.muni_id = mu.muni_id
			JOIN sector_table ON gully.sector_id = sector_table.sector_id
			LEFT JOIN dma_table ON gully.dma_id = dma_table.dma_id
			LEFT JOIN drainzone_table ON gully.dma_id = drainzone_table.drainzone_id
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
    cat_arc.bulk,
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
    d.arc_type,
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
                            COALESCE(v_price_x_catarc.bulk / 1000::numeric, 0::numeric)::numeric(12,2) AS bulk,
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
            arc.arc_type,
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


CREATE OR REPLACE VIEW ve_pol_element
AS SELECT e.pol_id,
    e.element_id,
    polygon.the_geom,
    polygon.trace_featuregeom
    FROM v_edit_element e
    JOIN polygon USING (pol_id);

CREATE OR REPLACE VIEW vu_element_x_arc
AS SELECT
    element_x_arc.arc_id,
    element_x_arc.element_id,
    element.elementcat_id,
    cat_element.descript,
    element.num_elements,
    value_state.name AS state,
    value_state_type.name AS state_type,
    element.observ,
    element.comment,
    element.location_type,
    element.builtdate,
    element.enddate,
    element.link,
    element.publish,
    element.inventory,
    element.serial_number,
    element.brand_id,
    element.model_id,
    element.lastupdate
   FROM element_x_arc
     JOIN element ON element.element_id::text = element_x_arc.element_id::text
     JOIN value_state ON element.state = value_state.id
     LEFT JOIN value_state_type ON element.state_type = value_state_type.id
     LEFT JOIN man_type_location ON man_type_location.location_type::text = element.location_type::text AND man_type_location.feature_type::text = 'ELEMENT'::text
     LEFT JOIN cat_element ON cat_element.id::text = element.elementcat_id::text;


CREATE OR REPLACE VIEW vu_element_x_connec
AS SELECT
    element_x_connec.connec_id,
    element_x_connec.element_id,
    element.elementcat_id,
    cat_element.descript,
    element.num_elements,
    value_state.name AS state,
    value_state_type.name AS state_type,
    element.observ,
    element.comment,
    element.location_type,
    element.builtdate,
    element.enddate,
    element.link,
    element.publish,
    element.inventory,
    element.serial_number,
    element.brand_id,
    element.model_id,
    element.lastupdate
   FROM element_x_connec
     JOIN element ON element.element_id::text = element_x_connec.element_id::text
     JOIN value_state ON element.state = value_state.id
     LEFT JOIN value_state_type ON element.state_type = value_state_type.id
     LEFT JOIN man_type_location ON man_type_location.location_type::text = element.location_type::text AND man_type_location.feature_type::text = 'ELEMENT'::text
     LEFT JOIN cat_element ON cat_element.id::text = element.elementcat_id::text;


CREATE OR REPLACE VIEW vu_element_x_gully
AS SELECT
    element_x_gully.gully_id,
    element_x_gully.element_id,
    element.elementcat_id,
    cat_element.descript,
    element.num_elements,
    value_state.name AS state,
    value_state_type.name AS state_type,
    element.observ,
    element.comment,
    element.location_type,
    element.builtdate,
    element.enddate,
    element.serial_number,
    element.brand_id,
    element.model_id,
    element.lastupdate
   FROM element_x_gully
     JOIN element ON element.element_id::text = element_x_gully.element_id::text
     JOIN value_state ON element.state = value_state.id
     LEFT JOIN value_state_type ON element.state_type = value_state_type.id
     LEFT JOIN man_type_location ON man_type_location.location_type::text = element.location_type::text AND man_type_location.feature_type::text = 'ELEMENT'::text
     LEFT JOIN cat_element ON cat_element.id::text = element.elementcat_id::text;

CREATE OR REPLACE VIEW vu_element_x_node
AS SELECT
    element_x_node.node_id,
    element_x_node.element_id,
    element.elementcat_id,
    cat_element.descript,
    element.num_elements,
    value_state.name AS state,
    value_state_type.name AS state_type,
    element.observ,
    element.comment,
    element.location_type,
    element.builtdate,
    element.enddate,
    element.link,
    element.publish,
    element.inventory,
    element.serial_number,
    element.brand_id,
    element.model_id,
    element.lastupdate
   FROM element_x_node
     JOIN element ON element.element_id::text = element_x_node.element_id::text
     JOIN value_state ON element.state = value_state.id
     LEFT JOIN value_state_type ON element.state_type = value_state_type.id
     LEFT JOIN man_type_location ON man_type_location.location_type::text = element.location_type::text AND man_type_location.feature_type::text = 'ELEMENT'::text
     LEFT JOIN cat_element ON cat_element.id::text = element.elementcat_id::text;

CREATE OR REPLACE VIEW v_ui_element_x_node
AS SELECT
    element_x_node.node_id,
    element_x_node.element_id,
    v_edit_element.elementcat_id,
    cat_element.descript,
    v_edit_element.num_elements,
    value_state.name AS state,
    value_state_type.name AS state_type,
    v_edit_element.observ,
    v_edit_element.comment,
    v_edit_element.location_type,
    v_edit_element.builtdate,
    v_edit_element.enddate,
    v_edit_element.link,
    v_edit_element.publish,
    v_edit_element.inventory
   FROM element_x_node
     JOIN v_edit_element ON v_edit_element.element_id::text = element_x_node.element_id::text
     JOIN value_state ON v_edit_element.state = value_state.id
     LEFT JOIN value_state_type ON v_edit_element.state_type = value_state_type.id
     LEFT JOIN man_type_location ON man_type_location.location_type::text = v_edit_element.location_type::text AND man_type_location.feature_type::text = 'ELEMENT'::text
     LEFT JOIN cat_element ON cat_element.id::text = v_edit_element.elementcat_id::text;

CREATE OR REPLACE VIEW v_ui_element_x_connec
AS SELECT
    element_x_connec.connec_id,
    element_x_connec.element_id,
    v_edit_element.elementcat_id,
    cat_element.descript,
    v_edit_element.num_elements,
    value_state.name AS state,
    value_state_type.name AS state_type,
    v_edit_element.observ,
    v_edit_element.comment,
    v_edit_element.location_type,
    v_edit_element.builtdate,
    v_edit_element.enddate,
    v_edit_element.link,
    v_edit_element.publish,
    v_edit_element.inventory
   FROM element_x_connec
     JOIN v_edit_element ON v_edit_element.element_id::text = element_x_connec.element_id::text
     JOIN value_state ON v_edit_element.state = value_state.id
     LEFT JOIN value_state_type ON v_edit_element.state_type = value_state_type.id
     LEFT JOIN man_type_location ON man_type_location.location_type::text = v_edit_element.location_type::text AND man_type_location.feature_type::text = 'ELEMENT'::text
     LEFT JOIN cat_element ON cat_element.id::text = v_edit_element.elementcat_id::text;

CREATE OR REPLACE VIEW v_ui_element_x_arc
AS SELECT
    element_x_arc.arc_id,
    element_x_arc.element_id,
    v_edit_element.elementcat_id,
    cat_element.descript,
    v_edit_element.num_elements,
    value_state.name AS state,
    value_state_type.name AS state_type,
    v_edit_element.observ,
    v_edit_element.comment,
    v_edit_element.location_type,
    v_edit_element.builtdate,
    v_edit_element.enddate,
    v_edit_element.link,
    v_edit_element.publish,
    v_edit_element.inventory
   FROM element_x_arc
     JOIN v_edit_element ON v_edit_element.element_id::text = element_x_arc.element_id::text
     JOIN value_state ON v_edit_element.state = value_state.id
     LEFT JOIN value_state_type ON v_edit_element.state_type = value_state_type.id
     LEFT JOIN man_type_location ON man_type_location.location_type::text = v_edit_element.location_type::text AND man_type_location.feature_type::text = 'ELEMENT'::text
     LEFT JOIN cat_element ON cat_element.id::text = v_edit_element.elementcat_id::text;

CREATE OR REPLACE VIEW v_ui_element_x_gully
AS SELECT
    element_x_gully.gully_id,
    element_x_gully.element_id,
    v_edit_element.elementcat_id,
    cat_element.descript,
    v_edit_element.num_elements,
    value_state.name AS state,
    value_state_type.name AS state_type,
    v_edit_element.observ,
    v_edit_element.comment,
    v_edit_element.location_type,
    v_edit_element.builtdate,
    v_edit_element.enddate
   FROM element_x_gully
     JOIN v_edit_element ON v_edit_element.element_id::text = element_x_gully.element_id::text
     JOIN value_state ON v_edit_element.state = value_state.id
     LEFT JOIN value_state_type ON v_edit_element.state_type = value_state_type.id
     LEFT JOIN man_type_location ON man_type_location.location_type::text = v_edit_element.location_type::text AND man_type_location.feature_type::text = 'ELEMENT'::text
     LEFT JOIN cat_element ON cat_element.id::text = v_edit_element.elementcat_id::text;

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
    v_edit_connec.connec_type AS featurecat_id,
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
    c.connec_type AS featurecat_id,
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


CREATE OR REPLACE VIEW ve_pol_connec
AS SELECT polygon.pol_id,
    polygon.feature_id,
    polygon.featurecat_id,
    polygon.state,
    polygon.sys_type,
    polygon.the_geom,
    polygon.trace_featuregeom
    FROM polygon
    JOIN v_edit_connec ON polygon.feature_id::text = v_edit_connec.connec_id::text;


CREATE OR REPLACE VIEW v_rtc_period_hydrometer
AS SELECT ext_rtc_hydrometer.id AS hydrometer_id,
    v_edit_connec.connec_id,
    NULL::character varying(16) AS pjoint_id,
    temp_arc.node_1,
    temp_arc.node_2,
    ext_cat_period.id AS period_id,
    ext_cat_period.period_seconds,
    c.dma_id,
    c.effc::numeric(5,4) AS effc,
    c.minc,
    c.maxc,
        CASE
            WHEN ext_rtc_hydrometer_x_data.custom_sum IS NOT NULL THEN ext_rtc_hydrometer_x_data.custom_sum
            ELSE ext_rtc_hydrometer_x_data.sum
        END AS m3_total_period,
        CASE
            WHEN ext_rtc_hydrometer_x_data.custom_sum IS NOT NULL THEN ext_rtc_hydrometer_x_data.custom_sum * 1000::double precision / ext_cat_period.period_seconds::double precision
            ELSE ext_rtc_hydrometer_x_data.sum * 1000::double precision / ext_cat_period.period_seconds::double precision
        END AS lps_avg,
    ext_rtc_hydrometer_x_data.pattern_id
   FROM ext_rtc_hydrometer
     JOIN ext_rtc_hydrometer_x_data ON ext_rtc_hydrometer_x_data.hydrometer_id::bigint = ext_rtc_hydrometer.id::bigint
     JOIN ext_cat_period ON ext_rtc_hydrometer_x_data.cat_period_id::text = ext_cat_period.id::text
     JOIN rtc_hydrometer_x_connec ON rtc_hydrometer_x_connec.hydrometer_id::bigint = ext_rtc_hydrometer.id::bigint
     JOIN v_edit_connec ON v_edit_connec.connec_id::text = rtc_hydrometer_x_connec.connec_id::text
     JOIN temp_arc ON v_edit_connec.arc_id::text = temp_arc.arc_id::text
     JOIN ext_rtc_dma_period c ON c.cat_period_id::text = ext_cat_period.id::text AND c.dma_id::integer = v_edit_connec.dma_id
  WHERE ext_cat_period.id::text = (( SELECT config_param_user.value
           FROM config_param_user
          WHERE config_param_user.cur_user::name = "current_user"() AND config_param_user.parameter::text = 'inp_options_rtc_period_id'::text))
UNION
 SELECT ext_rtc_hydrometer.id AS hydrometer_id,
    v_edit_connec.connec_id,
    temp_node.node_id AS pjoint_id,
    NULL::character varying AS node_1,
    NULL::character varying AS node_2,
    ext_cat_period.id AS period_id,
    ext_cat_period.period_seconds,
    c.dma_id,
    c.effc::numeric(5,4) AS effc,
    c.minc,
    c.maxc,
        CASE
            WHEN ext_rtc_hydrometer_x_data.custom_sum IS NOT NULL THEN ext_rtc_hydrometer_x_data.custom_sum
            ELSE ext_rtc_hydrometer_x_data.sum
        END AS m3_total_period,
        CASE
            WHEN ext_rtc_hydrometer_x_data.custom_sum IS NOT NULL THEN ext_rtc_hydrometer_x_data.custom_sum * 1000::double precision / ext_cat_period.period_seconds::double precision
            ELSE ext_rtc_hydrometer_x_data.sum * 1000::double precision / ext_cat_period.period_seconds::double precision
        END AS lps_avg,
    ext_rtc_hydrometer_x_data.pattern_id
   FROM ext_rtc_hydrometer
     JOIN ext_rtc_hydrometer_x_data ON ext_rtc_hydrometer_x_data.hydrometer_id::bigint = ext_rtc_hydrometer.id::bigint
     JOIN ext_cat_period ON ext_rtc_hydrometer_x_data.cat_period_id::text = ext_cat_period.id::text
     JOIN rtc_hydrometer_x_connec ON rtc_hydrometer_x_connec.hydrometer_id::bigint = ext_rtc_hydrometer.id::bigint
     LEFT JOIN v_edit_connec ON v_edit_connec.connec_id::text = rtc_hydrometer_x_connec.connec_id::text
     JOIN temp_node ON concat('VN', v_edit_connec.pjoint_id) = temp_node.node_id::text
     JOIN ext_rtc_dma_period c ON c.cat_period_id::text = ext_cat_period.id::text AND v_edit_connec.dma_id::text = c.dma_id::text
  WHERE v_edit_connec.pjoint_type::text = 'VNODE'::text AND ext_cat_period.id::text = (( SELECT config_param_user.value
           FROM config_param_user
          WHERE config_param_user.cur_user::name = "current_user"() AND config_param_user.parameter::text = 'inp_options_rtc_period_id'::text))
UNION
 SELECT ext_rtc_hydrometer.id AS hydrometer_id,
    v_edit_connec.connec_id,
    temp_node.node_id AS pjoint_id,
    NULL::character varying AS node_1,
    NULL::character varying AS node_2,
    ext_cat_period.id AS period_id,
    ext_cat_period.period_seconds,
    c.dma_id,
    c.effc::numeric(5,4) AS effc,
    c.minc,
    c.maxc,
        CASE
            WHEN ext_rtc_hydrometer_x_data.custom_sum IS NOT NULL THEN ext_rtc_hydrometer_x_data.custom_sum
            ELSE ext_rtc_hydrometer_x_data.sum
        END AS m3_total_period,
        CASE
            WHEN ext_rtc_hydrometer_x_data.custom_sum IS NOT NULL THEN ext_rtc_hydrometer_x_data.custom_sum * 1000::double precision / ext_cat_period.period_seconds::double precision
            ELSE ext_rtc_hydrometer_x_data.sum * 1000::double precision / ext_cat_period.period_seconds::double precision
        END AS lps_avg,
    ext_rtc_hydrometer_x_data.pattern_id
   FROM ext_rtc_hydrometer
     JOIN ext_rtc_hydrometer_x_data ON ext_rtc_hydrometer_x_data.hydrometer_id::bigint = ext_rtc_hydrometer.id::bigint
     JOIN ext_cat_period ON ext_rtc_hydrometer_x_data.cat_period_id::text = ext_cat_period.id::text
     JOIN rtc_hydrometer_x_connec ON rtc_hydrometer_x_connec.hydrometer_id::bigint = ext_rtc_hydrometer.id::bigint
     LEFT JOIN v_edit_connec ON v_edit_connec.connec_id::text = rtc_hydrometer_x_connec.connec_id::text
     JOIN temp_node ON v_edit_connec.pjoint_id::text = temp_node.node_id::text
     JOIN ext_rtc_dma_period c ON c.cat_period_id::text = ext_cat_period.id::text AND v_edit_connec.dma_id::text = c.dma_id::text
  WHERE v_edit_connec.pjoint_type::text = 'NODE'::text AND ext_cat_period.id::text = (( SELECT config_param_user.value
           FROM config_param_user
          WHERE config_param_user.cur_user::name = "current_user"() AND config_param_user.parameter::text = 'inp_options_rtc_period_id'::text));

CREATE OR REPLACE VIEW v_rtc_period_node
AS SELECT a.node_id,
    a.dma_id,
    a.period_id,
    sum(a.lps_avg) AS lps_avg,
    a.effc,
    sum(a.lps_avg_real) AS lps_avg_real,
    a.minc,
    sum(a.lps_min) AS lps_min,
    a.maxc,
    sum(a.lps_max) AS lps_max,
    sum(a.m3_total_period) AS m3_total_period
   FROM ( SELECT v_rtc_period_hydrometer.node_1 AS node_id,
            v_rtc_period_hydrometer.dma_id,
            v_rtc_period_hydrometer.period_id,
            sum(v_rtc_period_hydrometer.lps_avg * 0.5::double precision) AS lps_avg,
            v_rtc_period_hydrometer.effc,
            sum(v_rtc_period_hydrometer.lps_avg * 0.5::double precision / v_rtc_period_hydrometer.effc::double precision) AS lps_avg_real,
            v_rtc_period_hydrometer.minc,
            sum(v_rtc_period_hydrometer.lps_avg * 0.5::double precision / v_rtc_period_hydrometer.effc::double precision * v_rtc_period_hydrometer.minc) AS lps_min,
            v_rtc_period_hydrometer.maxc,
            sum(v_rtc_period_hydrometer.lps_avg * 0.5::double precision / v_rtc_period_hydrometer.effc::double precision * v_rtc_period_hydrometer.maxc) AS lps_max,
            sum(v_rtc_period_hydrometer.m3_total_period * 0.5::double precision) AS m3_total_period
           FROM v_rtc_period_hydrometer
          WHERE v_rtc_period_hydrometer.pjoint_id IS NULL
          GROUP BY v_rtc_period_hydrometer.node_1, v_rtc_period_hydrometer.period_id, v_rtc_period_hydrometer.dma_id, v_rtc_period_hydrometer.effc, v_rtc_period_hydrometer.minc, v_rtc_period_hydrometer.maxc
        UNION
         SELECT v_rtc_period_hydrometer.node_2 AS node_id,
            v_rtc_period_hydrometer.dma_id,
            v_rtc_period_hydrometer.period_id,
            sum(v_rtc_period_hydrometer.lps_avg * 0.5::double precision) AS lps_avg,
            v_rtc_period_hydrometer.effc,
            sum(v_rtc_period_hydrometer.lps_avg * 0.5::double precision / v_rtc_period_hydrometer.effc::double precision) AS lps_avg_real,
            v_rtc_period_hydrometer.minc,
            sum(v_rtc_period_hydrometer.lps_avg * 0.5::double precision / v_rtc_period_hydrometer.effc::double precision * v_rtc_period_hydrometer.minc) AS lps_min,
            v_rtc_period_hydrometer.maxc,
            sum(v_rtc_period_hydrometer.lps_avg * 0.5::double precision / v_rtc_period_hydrometer.effc::double precision * v_rtc_period_hydrometer.maxc) AS lps_max,
            sum(v_rtc_period_hydrometer.m3_total_period * 0.5::double precision) AS m3_total_period
           FROM v_rtc_period_hydrometer
          WHERE v_rtc_period_hydrometer.pjoint_id IS NULL
          GROUP BY v_rtc_period_hydrometer.node_2, v_rtc_period_hydrometer.period_id, v_rtc_period_hydrometer.dma_id, v_rtc_period_hydrometer.effc, v_rtc_period_hydrometer.minc, v_rtc_period_hydrometer.maxc) a
  GROUP BY a.node_id, a.period_id, a.dma_id, a.effc, a.minc, a.maxc;

CREATE OR REPLACE VIEW v_rtc_period_dma
AS SELECT v_rtc_period_hydrometer.dma_id::integer AS dma_id,
    v_rtc_period_hydrometer.period_id,
    sum(v_rtc_period_hydrometer.m3_total_period) AS m3_total_period,
    a.pattern_id
   FROM v_rtc_period_hydrometer
     JOIN ext_rtc_dma_period a ON a.dma_id::text = v_rtc_period_hydrometer.dma_id::text AND v_rtc_period_hydrometer.period_id::text = a.cat_period_id::text
  GROUP BY v_rtc_period_hydrometer.dma_id, v_rtc_period_hydrometer.period_id, a.pattern_id;


CREATE OR REPLACE VIEW v_ui_element
AS SELECT element.element_id AS id,
    element.code,
    element.elementcat_id,
    element.brand_id,
    element.model_id,
    element.serial_number,
    element.num_elements,
    element.state,
    element.state_type,
    element.observ,
    element.comment,
    element.function_type,
    element.category_type,
    element.fluid_type,
    element.location_type,
    element.workcat_id,
    element.workcat_id_end,
    element.buildercat_id,
    element.builtdate,
    element.enddate,
    element.ownercat_id,
    element.rotation,
    element.link,
    element.verified,
    element.the_geom,
    element.label_x,
    element.label_y,
    element.label_rotation,
    element.undelete,
    element.publish,
    element.inventory,
    element.expl_id,
    element.feature_type,
    element.tstamp
   FROM element;


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

CREATE OR REPLACE VIEW ve_pol_node
AS SELECT polygon.pol_id,
    polygon.feature_id,
    polygon.featurecat_id,
    polygon.state,
    polygon.sys_type,
    polygon.the_geom,
    polygon.trace_featuregeom
    FROM polygon
    JOIN v_edit_node ON polygon.feature_id::text = v_edit_node.node_id::text;

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


CREATE OR REPLACE VIEW vi_coverages
AS SELECT v_edit_inp_subcatchment.subc_id,
    inp_coverage.landus_id,
    inp_coverage.percent
   FROM inp_coverage
     JOIN v_edit_inp_subcatchment ON inp_coverage.subc_id::text = v_edit_inp_subcatchment.subc_id::text
     LEFT JOIN ( SELECT DISTINCT ON (a.subc_id) a.subc_id,
            v_edit_node.node_id
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
    JOIN v_edit_node ON v_edit_node.node_id::text = a.node_array) b ON v_edit_inp_subcatchment.subc_id::text = b.subc_id::text;

CREATE OR REPLACE VIEW vi_groundwater
AS SELECT inp_groundwater.subc_id,
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
            v_edit_node.node_id
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
         JOIN v_edit_node ON v_edit_node.node_id::text = a.node_array) b ON v_edit_inp_subcatchment.subc_id::text = b.subc_id::text;

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
    a.node_type,
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
    plan_rec_result_node.node_type,
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
    v_plan_node.node_type,
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
    n.node_type,
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


CREATE OR REPLACE VIEW v_edit_inp_flwreg_outlet
AS SELECT f.nodarc_id,
    f.node_id,
    f.order_id,
    f.to_arc,
    f.flwreg_length,
    ou.outlet_type,
    ou.offsetval,
    ou.curve_id,
    ou.cd1,
    ou.cd2,
    ou.flap,
    f.the_geom
    FROM flwreg f
    JOIN inp_flwreg_outlet ou USING (flwreg_id)
    JOIN v_edit_node n USING (node_id)
    JOIN value_state_type vs ON vs.id = n.state_type
    LEFT JOIN arc a ON a.arc_id::text = f.to_arc::text
    WHERE vs.is_operative IS TRUE;

CREATE OR REPLACE VIEW v_edit_inp_flwreg_weir
AS SELECT f.nodarc_id,
    f.node_id,
    f.order_id,
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
    FROM flwreg f
    JOIN inp_flwreg_weir w USING (flwreg_id)
    JOIN v_edit_node n USING (node_id)
    JOIN value_state_type vs ON vs.id = n.state_type
    LEFT JOIN arc a ON a.arc_id::text = f.to_arc::text
    WHERE vs.is_operative IS TRUE;

CREATE OR REPLACE VIEW v_edit_inp_flwreg_pump
AS SELECT f.nodarc_id,
    f.node_id,
    f.order_id,
    f.to_arc,
    f.flwreg_length,
    p.curve_id,
    p.status,
    p.startup,
    p.shutoff,
    f.the_geom
    FROM flwreg f
    JOIN inp_flwreg_pump p USING (flwreg_id)
    JOIN v_edit_node n USING (node_id)
    JOIN value_state_type vs ON vs.id = n.state_type
    LEFT JOIN arc a ON a.arc_id::text = f.to_arc::text
    WHERE vs.is_operative IS TRUE;

CREATE OR REPLACE VIEW v_edit_inp_flwreg_orifice
AS SELECT f.nodarc_id,
    f.node_id,
    f.order_id,
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
    FROM flwreg f
    JOIN inp_flwreg_orifice ori USING (flwreg_id)
    JOIN v_edit_node n USING (node_id)
    JOIN value_state_type vs ON vs.id = n.state_type
    LEFT JOIN arc a ON a.arc_id::text = f.to_arc::text
    WHERE vs.is_operative IS TRUE;


CREATE OR REPLACE VIEW v_edit_inp_dscenario_flwreg_outlet
AS SELECT s.dscenario_id,
    f.nodarc_id,
    n.node_id,
    f.outlet_type,
    f.offsetval,
    f.curve_id,
    f.cd1,
    f.cd2,
    f.flap,
    n.the_geom
    FROM selector_inp_dscenario s, inp_dscenario_flwreg_outlet f
    JOIN v_edit_inp_flwreg_outlet n USING (nodarc_id)
	WHERE s.dscenario_id = f.dscenario_id AND s.cur_user = CURRENT_USER::text;

CREATE OR REPLACE VIEW v_edit_inp_dscenario_flwreg_weir
AS SELECT s.dscenario_id,
    f.nodarc_id,
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
    FROM selector_inp_dscenario s, inp_dscenario_flwreg_weir f
    JOIN v_edit_inp_flwreg_weir n USING (nodarc_id)
	WHERE s.dscenario_id = f.dscenario_id AND s.cur_user = CURRENT_USER::text;

CREATE OR REPLACE VIEW v_edit_inp_dscenario_flwreg_pump
AS SELECT s.dscenario_id,
    f.nodarc_id,
    n.node_id,
    f.curve_id,
    f.status,
    f.startup,
    f.shutoff,
    n.the_geom
    FROM selector_inp_dscenario s, inp_dscenario_flwreg_pump f
    JOIN v_edit_inp_flwreg_pump n USING (nodarc_id)
    WHERE s.dscenario_id = f.dscenario_id AND s.cur_user = CURRENT_USER::text;

CREATE OR REPLACE VIEW v_edit_inp_dscenario_flwreg_orifice
AS SELECT s.dscenario_id,
    f.nodarc_id,
    n.node_id,
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
    n.the_geom
    FROM selector_inp_dscenario s, inp_dscenario_flwreg_orifice f
    JOIN v_edit_inp_flwreg_orifice n USING (nodarc_id)
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
 SELECT row_number() OVER (ORDER BY v_edit_element.element_id) + 4000000 AS rid,
    'ELEMENT'::character varying AS feature_type,
    v_edit_element.elementcat_id AS featurecat_id,
    v_edit_element.element_id AS feature_id,
    v_edit_element.code,
    exploitation.name AS expl_name,
    v_edit_element.workcat_id_end AS workcat_id,
    exploitation.expl_id
   FROM v_edit_element
     JOIN exploitation ON exploitation.expl_id = v_edit_element.expl_id
  WHERE v_edit_element.state = 0
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
    v_edit_arc.arc_type AS featurecat_id,
    v_edit_arc.arccat_id,
    v_edit_arc.y2 AS depth,
    st_length2d(v_edit_arc.the_geom)::numeric(12,2) AS length,
    node.node_id AS downstream_id,
    node.code AS downstream_code,
    node.node_type AS downstream_type,
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
    v_edit_arc.arc_type AS featurecat_id,
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
    v_edit_connec.connec_type AS featurecat_id,
    v_edit_connec.conneccat_id AS arccat_id,
    v_edit_connec.y1 AS depth,
    st_length2d(link.the_geom)::numeric(12,2) AS length,
    v_edit_connec.connec_id AS upstream_id,
    v_edit_connec.code AS upstream_code,
    v_edit_connec.connec_type AS upstream_type,
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
    v_edit_connec.connec_type AS featurecat_id,
    v_edit_connec.conneccat_id AS arccat_id,
    v_edit_connec.y1 AS depth,
    st_length2d(link.the_geom)::numeric(12,2) AS length,
    v_edit_connec.connec_id AS upstream_id,
    v_edit_connec.code AS upstream_code,
    v_edit_connec.connec_type AS upstream_type,
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
            v_plan_arc.arc_type,
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
            a.bulk,
            a.cost_unit,
            a.cost,
            a.m2bottom_cost,
            a.m3protec_cost,
            a.active,
            a.label,
            a.tsect_id,
            a.curve_id,
            a.arc_type,
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
   FROM p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, expl_id, sector_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, matcat_id, shape, geom1_1, geom2, geom3, geom4, geom5, geom6, geom7, geom8, geom_r, descript, link, brand_id, model_id, svg, z1_1, z2_1, width_1, area_1, estimated_depth, bulk_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, tsect_id, curve_id, arc_type_1, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
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
   FROM p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, expl_id, sector_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, matcat_id, shape, geom1_1, geom2, geom3, geom4, geom5, geom6, geom7, geom8, geom_r, descript, link, brand_id, model_id, svg, z1_1, z2_1, width_1, area_1, estimated_depth, bulk_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, tsect_id, curve_id, arc_type_1, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
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
   FROM p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, expl_id, sector_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, matcat_id, shape, geom1_1, geom2, geom3, geom4, geom5, geom6, geom7, geom8, geom_r, descript, link, brand_id, model_id, svg, z1_1, z2_1, width_1, area_1, estimated_depth, bulk_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, tsect_id, curve_id, arc_type_1, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
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
   FROM p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, expl_id, sector_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, matcat_id, shape, geom1_1, geom2, geom3, geom4, geom5, geom6, geom7, geom8, geom_r, descript, link, brand_id, model_id, svg, z1_1, z2_1, width_1, area_1, estimated_depth, bulk_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, tsect_id, curve_id, arc_type_1, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
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
   FROM p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, expl_id, sector_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, matcat_id, shape, geom1_1, geom2, geom3, geom4, geom5, geom6, geom7, geom8, geom_r, descript, link, brand_id, model_id, svg, z1_1, z2_1, width_1, area_1, estimated_depth, bulk_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, tsect_id, curve_id, arc_type_1, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
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
   FROM p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, expl_id, sector_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, matcat_id, shape, geom1_1, geom2, geom3, geom4, geom5, geom6, geom7, geom8, geom_r, descript, link, brand_id, model_id, svg, z1_1, z2_1, width_1, area_1, estimated_depth, bulk_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, tsect_id, curve_id, arc_type_1, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
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
   FROM p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, expl_id, sector_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, matcat_id, shape, geom1_1, geom2, geom3, geom4, geom5, geom6, geom7, geom8, geom_r, descript, link, brand_id, model_id, svg, z1_1, z2_1, width_1, area_1, estimated_depth, bulk_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, tsect_id, curve_id, arc_type_1, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
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
   FROM p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, expl_id, sector_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, matcat_id, shape, geom1_1, geom2, geom3, geom4, geom5, geom6, geom7, geom8, geom_r, descript, link, brand_id, model_id, svg, z1_1, z2_1, width_1, area_1, estimated_depth, bulk_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, tsect_id, curve_id, arc_type_1, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
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
   FROM p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, expl_id, sector_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, matcat_id, shape, geom1_1, geom2, geom3, geom4, geom5, geom6, geom7, geom8, geom_r, descript, link, brand_id, model_id, svg, z1_1, z2_1, width_1, area_1, estimated_depth, bulk_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, tsect_id, curve_id, arc_type_1, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
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
   FROM p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, expl_id, sector_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, matcat_id, shape, geom1_1, geom2, geom3, geom4, geom5, geom6, geom7, geom8, geom_r, descript, link, brand_id, model_id, svg, z1_1, z2_1, width_1, area_1, estimated_depth, bulk_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, tsect_id, curve_id, arc_type_1, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
     JOIN v_edit_gully USING (arc_id)
     JOIN v_price_compost v ON p.cat_connect_cost = v.id::text
  GROUP BY p.arc_id
  ORDER BY 1, 2;

CREATE OR REPLACE VIEW v_plan_result_arc
AS SELECT plan_rec_result_arc.arc_id,
    plan_rec_result_arc.node_1,
    plan_rec_result_arc.node_2,
    plan_rec_result_arc.arc_type,
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
    v_plan_arc.arc_type,
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
                    v_plan_arc.arc_type,
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
                    v_plan_node.node_type,
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
    node.node_type,
    cat_feature.feature_class,
    node.state AS original_state,
    node.state_type AS original_state_type,
    plan_psector_x_node.state AS plan_state,
    plan_psector_x_node.doable,
    node.the_geom
   FROM selector_psector,
    node
     JOIN plan_psector_x_node USING (node_id)
     JOIN cat_node ON cat_node.id::text = node.nodecat_id::text
     JOIN cat_feature ON cat_feature.id::text = node.node_type::text
  WHERE plan_psector_x_node.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text;

CREATE OR REPLACE VIEW v_plan_psector_connec
AS SELECT row_number() OVER () AS rid,
    connec.connec_id,
    plan_psector_x_connec.psector_id,
    connec.code,
    connec.conneccat_id,
    connec.connec_type,
    cat_feature.feature_class,
    connec.state AS original_state,
    connec.state_type AS original_state_type,
    plan_psector_x_connec.state AS plan_state,
    plan_psector_x_connec.doable,
    connec.the_geom
   FROM selector_psector,
    connec
     JOIN plan_psector_x_connec USING (connec_id)
     JOIN cat_connec ON cat_connec.id::text = connec.conneccat_id::text
     JOIN cat_feature ON cat_feature.id::text = connec.connec_type::text
  WHERE plan_psector_x_connec.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW v_plan_psector_arc
AS SELECT row_number() OVER () AS rid,
    arc.arc_id,
    plan_psector_x_arc.psector_id,
    arc.code,
    arc.arccat_id,
    arc.arc_type,
    cat_feature.feature_class,
    arc.state AS original_state,
    arc.state_type AS original_state_type,
    plan_psector_x_arc.state AS plan_state,
    plan_psector_x_arc.doable,
    plan_psector_x_arc.addparam::text AS addparam,
    arc.the_geom
   FROM selector_psector,
    arc
     JOIN plan_psector_x_arc USING (arc_id)
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
                    v_plan_arc.arc_type,
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
                    v_plan_node.node_type,
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
                    v_plan_arc.arc_type,
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
                    v_plan_node.node_type,
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
    v_edit_gully.fluid_type,
    polygon.trace_featuregeom
    FROM polygon
    JOIN v_edit_gully ON polygon.feature_id::text = v_edit_gully.gully_id::text;

CREATE OR REPLACE VIEW vi_gully2node
AS SELECT a.gully_id,
    n.node_id,
    st_makeline(a.the_geom, n.the_geom) AS the_geom
   FROM ( SELECT g.gully_id,
                CASE
                    WHEN g.pjoint_type::text = 'NODE'::text THEN g.pjoint_id
                    ELSE a_1.node_2
                END AS node_id,
            a_1.expl_id,
            g.the_geom
           FROM v_edit_inp_gully g
             LEFT JOIN arc a_1 USING (arc_id)) a
     JOIN node n USING (node_id);


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
gully.the_geom
FROM selector_psector, gully
JOIN plan_psector_x_gully USING (gully_id)
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
    review_connec.connec_type,
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

DROP VIEW IF EXISTS v_sector_node;

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
DROP VIEW IF EXISTS v_rpt_comp_nodedepth_sum;
CREATE OR REPLACE VIEW v_rpt_comp_nodedepth_sum
AS  WITH main AS (
	SELECT rpt_nodedepth_sum.id,
    rpt_nodedepth_sum.result_id,
    rpt_nodedepth_sum.node_id,
    rpt_inp_node.node_type,
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
    rpt_inp_node.node_type,
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
    main.node_type,
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
    compare.node_type,
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
DROP VIEW IF EXISTS v_rpt_comp_nodeinflow_sum;
CREATE OR REPLACE VIEW v_rpt_comp_nodeinflow_sum
AS
WITH main AS (
	SELECT rpt_inp_node.id,
    rpt_nodeinflow_sum.node_id,
    rpt_nodeinflow_sum.result_id,
    rpt_inp_node.node_type,
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
    rpt_inp_node.node_type,
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
DROP VIEW IF EXISTS v_rpt_comp_nodeflooding_sum;
CREATE OR REPLACE VIEW v_rpt_comp_nodeflooding_sum
AS
WITH main AS (
	SELECT rpt_inp_node.id,
    rpt_nodeflooding_sum.node_id,
    selector_rpt_main.result_id,
    rpt_inp_node.node_type,
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
    rpt_inp_node.node_type,
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
    main.node_type,
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
    compare.node_type,
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
DROP VIEW IF EXISTS v_rpt_comp_nodesurcharge_sum;
CREATE OR REPLACE VIEW v_rpt_comp_nodesurcharge_sum
AS
WITH main AS (
	SELECT rpt_inp_node.id,
    rpt_inp_node.node_id,
    rpt_nodesurcharge_sum.result_id,
    rpt_inp_node.node_type,
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
    rpt_inp_node.node_type,
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
    main.node_type,
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
    compare.node_type,
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
DROP VIEW IF EXISTS v_rpt_comp_arcflow_sum;
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
DROP VIEW IF EXISTS v_rpt_comp_condsurcharge_sum;
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
DROP VIEW IF EXISTS v_rpt_comp_pumping_sum;
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
DROP VIEW IF EXISTS v_rpt_comp_flowclass_sum;
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

CREATE OR REPLACE VIEW vi_options
AS SELECT a.parameter,
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

CREATE OR REPLACE VIEW vi_report
AS SELECT a.idval AS parameter,
    b.value
   FROM sys_param_user a
     JOIN config_param_user b ON a.id = b.parameter::text
  WHERE (a.layoutname = ANY (ARRAY['lyt_reports_1'::text, 'lyt_reports_2'::text])) AND b.cur_user::name = "current_user"() AND b.value IS NOT NULL
  ORDER BY a.idval;


CREATE OR REPLACE VIEW vi_timeseries
AS SELECT b.timser_id,
    b.other1,
    b.other2,
    b.other3
   FROM ( SELECT t.id,
            t.timser_id,
            t.other1,
            t.other2,
            t.other3
           FROM selector_expl s,
            ( SELECT a.id,
                    a.timser_id,
                    a.other1,
                    a.other2,
                    a.other3,
                    a.expl_id
                   FROM ( SELECT inp_timeseries_value.id,
                            inp_timeseries_value.timser_id,
                            inp_timeseries_value.date AS other1,
                            inp_timeseries_value.hour AS other2,
                            inp_timeseries_value.value AS other3,
                            inp_timeseries.expl_id
                           FROM inp_timeseries_value
                             JOIN inp_timeseries ON inp_timeseries_value.timser_id::text = inp_timeseries.id::text
                          WHERE inp_timeseries.times_type::text = 'ABSOLUTE'::text AND inp_timeseries.active
                        UNION
                         SELECT inp_timeseries_value.id,
                            inp_timeseries_value.timser_id,
                            concat('FILE', ' ', inp_timeseries.fname) AS other1,
                            NULL::character varying AS other2,
                            NULL::numeric AS other3,
                            inp_timeseries.expl_id
                           FROM inp_timeseries_value
                             JOIN inp_timeseries ON inp_timeseries_value.timser_id::text = inp_timeseries.id::text
                          WHERE inp_timeseries.times_type::text = 'FILE'::text AND inp_timeseries.active
                        UNION
                         SELECT inp_timeseries_value.id,
                            inp_timeseries_value.timser_id,
                            NULL::text AS other1,
                            inp_timeseries_value."time" AS other2,
                            inp_timeseries_value.value::numeric AS other3,
                            inp_timeseries.expl_id
                           FROM inp_timeseries_value
                             JOIN inp_timeseries ON inp_timeseries_value.timser_id::text = inp_timeseries.id::text
                          WHERE inp_timeseries.times_type::text = 'RELATIVE'::text AND inp_timeseries.active) a
                  ORDER BY a.id) t
          WHERE t.expl_id = s.expl_id AND s.cur_user = "current_user"()::text OR t.expl_id IS NULL) b
  ORDER BY b.id;

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

CREATE OR REPLACE VIEW vi_dwf
AS SELECT rpt_inp_node.node_id,
    'FLOW'::text AS type_dwf,
    inp_dwf.value,
    inp_dwf.pat1,
    inp_dwf.pat2,
    inp_dwf.pat3,
    inp_dwf.pat4
   FROM selector_inp_result,
    rpt_inp_node
     JOIN inp_dwf ON inp_dwf.node_id::text = rpt_inp_node.node_id::text
  WHERE rpt_inp_node.result_id::text = selector_inp_result.result_id::text AND selector_inp_result.cur_user = "current_user"()::text AND inp_dwf.dwfscenario_id = (( SELECT config_param_user.value::integer AS value
           FROM config_param_user
          WHERE config_param_user.parameter::text = 'inp_options_dwfscenario'::text AND config_param_user.cur_user::text = CURRENT_USER))
UNION
 SELECT rpt_inp_node.node_id,
    inp_dwf_pol_x_node.poll_id AS type_dwf,
    inp_dwf_pol_x_node.value,
    inp_dwf_pol_x_node.pat1,
    inp_dwf_pol_x_node.pat2,
    inp_dwf_pol_x_node.pat3,
    inp_dwf_pol_x_node.pat4
   FROM selector_inp_result,
    rpt_inp_node
     JOIN inp_dwf_pol_x_node ON inp_dwf_pol_x_node.node_id::text = rpt_inp_node.node_id::text
  WHERE rpt_inp_node.result_id::text = selector_inp_result.result_id::text AND selector_inp_result.cur_user = "current_user"()::text AND inp_dwf_pol_x_node.dwfscenario_id = (( SELECT config_param_user.value::integer AS value
           FROM config_param_user
          WHERE config_param_user.parameter::text = 'inp_options_dwfscenario'::text AND config_param_user.cur_user::text = CURRENT_USER));


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

CREATE OR REPLACE VIEW vi_gwf
AS SELECT inp_groundwater.subc_id,
    ('LATERAL'::text || ' '::text) || inp_groundwater.fl_eq_lat::text AS fl_eq_lat,
    ('DEEP'::text || ' '::text) || inp_groundwater.fl_eq_lat::text AS fl_eq_deep
   FROM v_edit_inp_subcatchment
     JOIN inp_groundwater ON inp_groundwater.subc_id::text = v_edit_inp_subcatchment.subc_id::text;

CREATE OR REPLACE VIEW vi_infiltration
AS SELECT v_edit_inp_subcatchment.subc_id,
    v_edit_inp_subcatchment.curveno AS other1,
    v_edit_inp_subcatchment.conduct_2 AS other2,
    v_edit_inp_subcatchment.drytime_2 AS other3,
    NULL::numeric AS other4,
    NULL::double precision AS other5
   FROM v_edit_inp_subcatchment
     JOIN cat_hydrology ON cat_hydrology.hydrology_id = v_edit_inp_subcatchment.hydrology_id
     JOIN ( SELECT a.subc_id,
            a.outlet_id
           FROM ( SELECT unnest(inp_subcatchment.outlet_id::character varying[]) AS outlet_id,
                    inp_subcatchment.subc_id
                   FROM inp_subcatchment
                     JOIN temp_node ON inp_subcatchment.outlet_id::text = temp_node.node_id::text
                  WHERE "left"(inp_subcatchment.outlet_id::text, 1) = '{'::text
                UNION
                 SELECT inp_subcatchment.outlet_id,
                    inp_subcatchment.subc_id
                   FROM inp_subcatchment
                  WHERE "left"(inp_subcatchment.outlet_id::text, 1) <> '{'::text) a) b USING (outlet_id)
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
     JOIN ( SELECT a.subc_id,
            a.outlet_id
           FROM ( SELECT unnest(inp_subcatchment.outlet_id::character varying[]) AS outlet_id,
                    inp_subcatchment.subc_id
                   FROM inp_subcatchment
                     JOIN temp_node ON inp_subcatchment.outlet_id::text = temp_node.node_id::text
                  WHERE "left"(inp_subcatchment.outlet_id::text, 1) = '{'::text
                UNION
                 SELECT inp_subcatchment.outlet_id,
                    inp_subcatchment.subc_id
                   FROM inp_subcatchment
                  WHERE "left"(inp_subcatchment.outlet_id::text, 1) <> '{'::text) a) b USING (outlet_id)
  WHERE cat_hydrology.infiltration::text = 'GREEN_AMPT'::text
UNION
 SELECT v_edit_inp_subcatchment.subc_id,
    v_edit_inp_subcatchment.curveno AS other1,
    v_edit_inp_subcatchment.conduct_2 AS other2,
    v_edit_inp_subcatchment.drytime_2 AS other3,
    NULL::integer AS other4,
    NULL::double precision AS other5
   FROM v_edit_inp_subcatchment
     JOIN cat_hydrology ON cat_hydrology.hydrology_id = v_edit_inp_subcatchment.hydrology_id
     JOIN ( SELECT a.subc_id,
            a.outlet_id
           FROM ( SELECT unnest(inp_subcatchment.outlet_id::character varying[]) AS outlet_id,
                    inp_subcatchment.subc_id
                   FROM inp_subcatchment
                     JOIN temp_node ON inp_subcatchment.outlet_id::text = temp_node.node_id::text
                  WHERE "left"(inp_subcatchment.outlet_id::text, 1) = '{'::text
                UNION
                 SELECT inp_subcatchment.outlet_id,
                    inp_subcatchment.subc_id
                   FROM inp_subcatchment
                  WHERE "left"(inp_subcatchment.outlet_id::text, 1) <> '{'::text) a) b USING (outlet_id)
  WHERE cat_hydrology.infiltration::text = ANY (ARRAY['MODIFIED_HORTON'::text, 'HORTON'::text]);

CREATE OR REPLACE VIEW vi_lid_usage
AS SELECT temp_lid_usage.subc_id,
    temp_lid_usage.lidco_id,
    temp_lid_usage.numelem::integer AS numelem,
    temp_lid_usage.area,
    temp_lid_usage.width,
    temp_lid_usage.initsat,
    temp_lid_usage.fromimp,
    temp_lid_usage.toperv::integer AS toperv,
    temp_lid_usage.rptfile
   FROM v_edit_inp_subcatchment
     JOIN temp_lid_usage ON temp_lid_usage.subc_id::text = v_edit_inp_subcatchment.subc_id::text;

CREATE OR REPLACE VIEW vi_subareas
AS SELECT DISTINCT v_edit_inp_subcatchment.subc_id,
    v_edit_inp_subcatchment.nimp,
    v_edit_inp_subcatchment.nperv,
    v_edit_inp_subcatchment.simp,
    v_edit_inp_subcatchment.sperv,
    v_edit_inp_subcatchment.zero,
    v_edit_inp_subcatchment.routeto,
    v_edit_inp_subcatchment.rted
   FROM v_edit_inp_subcatchment
     JOIN ( SELECT a.subc_id,
            a.outlet_id
           FROM ( SELECT unnest(inp_subcatchment.outlet_id::character varying[]) AS outlet_id,
                    inp_subcatchment.subc_id
                   FROM inp_subcatchment
                     JOIN temp_node ON inp_subcatchment.outlet_id::text = temp_node.node_id::text
                  WHERE "left"(inp_subcatchment.outlet_id::text, 1) = '{'::text
                UNION
                 SELECT inp_subcatchment.outlet_id,
                    inp_subcatchment.subc_id
                   FROM inp_subcatchment
                  WHERE "left"(inp_subcatchment.outlet_id::text, 1) <> '{'::text) a) b USING (outlet_id);

CREATE OR REPLACE VIEW vi_subcatchcentroid
AS SELECT v_edit_inp_subcatchment.subc_id,
    v_edit_inp_subcatchment.hydrology_id,
    st_centroid(v_edit_inp_subcatchment.the_geom) AS the_geom
   FROM v_edit_inp_subcatchment;

CREATE OR REPLACE VIEW vi_subcatchments
AS SELECT DISTINCT v_edit_inp_subcatchment.subc_id,
    v_edit_inp_subcatchment.rg_id,
    b.outlet_id,
    v_edit_inp_subcatchment.area,
    v_edit_inp_subcatchment.imperv,
    v_edit_inp_subcatchment.width,
    v_edit_inp_subcatchment.slope,
    v_edit_inp_subcatchment.clength,
    v_edit_inp_subcatchment.snow_id
   FROM v_edit_inp_subcatchment
     JOIN ( SELECT a.subc_id,
            a.outlet_id
           FROM ( SELECT unnest(inp_subcatchment.outlet_id::character varying[]) AS outlet_id,
                    inp_subcatchment.subc_id
                   FROM inp_subcatchment
                     JOIN temp_node ON inp_subcatchment.outlet_id::text = temp_node.node_id::text
                  WHERE "left"(inp_subcatchment.outlet_id::text, 1) = '{'::text
                UNION
                 SELECT inp_subcatchment.outlet_id,
                    inp_subcatchment.subc_id
                   FROM inp_subcatchment
                  WHERE "left"(inp_subcatchment.outlet_id::text, 1) <> '{'::text) a) b USING (outlet_id);

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


CREATE OR REPLACE VIEW vi_loadings
AS SELECT inp_loadings.subc_id,
    inp_loadings.poll_id,
    inp_loadings.ibuildup
   FROM v_edit_inp_subcatchment
     JOIN inp_loadings ON inp_loadings.subc_id::text = v_edit_inp_subcatchment.subc_id::text;

CREATE OR REPLACE VIEW v_ui_drainzone
AS SELECT d.drainzone_id,
    d.name,
    et.idval AS drainzone_type,
    d.descript,
    d.active,
    d.undelete,
    d.graphconfig,
    d.stylesheet,
    d.tstamp,
    d.insert_user,
    d.lastupdate,
    d.lastupdate_user,
    d.link,
    d.expl_id
   FROM drainzone d
   LEFT JOIN edit_typevalue et ON et.id::text = d.drainzone_type::text AND et.typevalue::text = 'drainzone_type'::text
  WHERE d.drainzone_id > 0
  ORDER BY d.drainzone_id;

CREATE OR REPLACE VIEW v_ui_dwfzone
AS SELECT d.dwfzone_id,
    d.name,
    et.idval AS dwfzone_type,
    d.descript,
    d.active,
    d.undelete,
    d.graphconfig,
    d.stylesheet,
    d.tstamp,
    d.insert_user,
    d.lastupdate,
    d.lastupdate_user,
    d.link,
    d.expl_id
   FROM dwfzone d
   LEFT JOIN edit_typevalue et ON et.id::text = d.dwfzone_type::text AND et.typevalue::text = 'dwfzone_type'::text
  WHERE d.dwfzone_id > 0
  ORDER BY d.dwfzone_id;

CREATE OR REPLACE VIEW v_ui_macrosector
AS SELECT m.macrosector_id,
    m.name,
    m.descript,
    m.active,
    m.undelete
    FROM macrosector m
    WHERE m.macrosector_id > 0
    ORDER BY m.macrosector_id;

DROP VIEW IF EXISTS v_edit_macrosector;
CREATE OR REPLACE VIEW v_edit_macrosector AS
 SELECT DISTINCT ON (m.macrosector_id) m.macrosector_id,
    m.name,
    m.descript,
    m.the_geom,
    m.undelete
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
CREATE OR REPLACE VIEW v_edit_inp_flwreg AS
SELECT
    f.nodarc_id,
    f.node_id,
    f.order_id,
   	f.to_arc,
    f.flwreg_length,
    f.flwregcat_id,
    -- Orifice Columns
    o.orifice_type,
    o.offsetval as orifice_offsetval,
    o.cd as orifice_cd,
    o.orate as orifice_orate,
    o.flap as orifice_flap,
    o.shape as orifice_shape,
    o.geom1 as orifice_geom1,
    o.geom2 as orifice_geom2,
    o.geom3 as orifice_geom3,
    o.geom4 as orifice_geom4,
    -- Outlet Columns
    ou.outlet_type,
    ou.offsetval as outlet_offsetval,
    ou.curve_id as outlet_curve_id,
    ou.cd1 as outlet_cd1,
    ou.cd2 as outlet_cd2,
    ou.flap as outlet_flap,
    --Pump Columns
    p.pump_type,
    p.curve_id as pump_curve_id,
    p.status as pump_status,
    p.startup as pump_startup,
    p.shutoff as pump_shutoff,
    --Weir Columns
    w.weir_type,
    w.offsetval as weir_offsetval,
    w.cd as weir_cd,
    w.ec as weir_ec,
    w.cd2 as weir_cd2,
    w.flap as weir_flap,
    w.geom1 as weir_geom1,
    w.geom2 as weir_geom2,
    w.geom3 as weir_geom3,
    w.geom4 as weir_geom4,
    w.surcharge as weir_surcharge,
    w.road_width as weir_road_width,
    w.road_surf as weir_road_surf,
    w.coef_curve as weir_coef_curve,
    -- Geometry
    f.the_geom
FROM
    flwreg f
left join inp_flwreg_orifice o using (flwreg_id)
left join inp_flwreg_outlet ou using (flwreg_id)
left join inp_flwreg_pump p using (flwreg_id)
left join inp_flwreg_weir w using (flwreg_id);

--10/01/2025
--28/01/2025 [Modified]
--create view for cat_feature_flwreg
DROP VIEW IF EXISTS v_edit_cat_feature_flwreg;
CREATE OR REPLACE VIEW v_edit_cat_feature_flwreg
AS SELECT
	cat_feature.id,
    cat_feature.feature_class AS system_id,
    cat_feature_flwreg.epa_default,
    cat_feature.code_autofill,
    cat_feature.link_path,
    cat_feature.descript,
    cat_feature.active
   FROM cat_feature
     JOIN cat_feature_flwreg USING (id);

-- Create parent view for flow regulators.
CREATE OR REPLACE VIEW v_edit_flwreg
AS SELECT
	f.flwreg_id,
	f.node_id,
	f.order_id,
	f.to_arc,
	f.nodarc_id,
    f.flwregcat_id,
	cf.flwreg_type,
	round(f.flwreg_length::numeric, 2) as flwreg_length,
	f.epa_type,
	f.state,
	f.state_type,
    n.muni_id,
    n.expl_id,
	f.annotation,
	f.observ,
    f.the_geom
    FROM flwreg f
	LEFT JOIN cat_flwreg cf ON cf.id = f.flwregcat_id
	LEFT JOIN v_edit_node n USING (node_id);

CREATE OR REPLACE VIEW v_rpt_node
AS SELECT rpt_node.id,
    node.node_id,
    selector_rpt_main.result_id,
    node.node_type,
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


DROP VIEW IF EXISTS v_edit_review_node;

CREATE OR REPLACE VIEW v_edit_review_node
AS SELECT review_node.node_id,
    review_node.top_elev,
    review_node.ymax,
    review_node.node_type,
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
AS SELECT
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
AS SELECT
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
AS SELECT
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
AS SELECT
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
AS SELECT
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
AS SELECT
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
AS SELECT
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
