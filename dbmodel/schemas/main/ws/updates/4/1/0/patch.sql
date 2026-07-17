/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;

CREATE TABLE inp_frvalve (
	element_id int4 NOT NULL,
	valve_type varchar(18) NULL,
	custom_dint numeric(12, 4) NULL,
	setting numeric(12, 4) NULL,
	curve_id varchar(16) NULL,
	minorloss numeric(12, 4) DEFAULT 0 NULL,
	add_settings float8 NULL,
	init_quality float8 NULL,
	CONSTRAINT inp_frvalve_pkey PRIMARY KEY (element_id),
	CONSTRAINT inp_frvalve_valve_type_check CHECK (((valve_type)::text = ANY (ARRAY[('FCV'::character varying)::text, ('GPV'::character varying)::text, ('PBV'::character varying)::text, ('PRV'::character varying)::text, ('PSV'::character varying)::text, ('TCV'::character varying)::text, ('PSRV'::character varying)::text]))),
	CONSTRAINT inp_frvalve_curve_id_fkey FOREIGN KEY (curve_id) REFERENCES inp_curve(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT inp_frvalve_node_id_fkey FOREIGN KEY (element_id) REFERENCES element(element_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE inp_dscenario_frvalve (
    dscenario_id int4 NOT NULL,
	element_id int4 NOT NULL,
	valve_type varchar(18) NULL,
	status varchar(3) NULL,
	custom_dint numeric(12, 4) NULL,
	setting numeric(12, 4) NULL,
	curve_id varchar(16) NULL,
	minorloss numeric(12, 4) DEFAULT 0 NULL,
	add_settings float8 NULL,
	init_quality float8 NULL,
    CONSTRAINT inp_dscenario_frvalve_pkey PRIMARY KEY (element_id, dscenario_id),
	CONSTRAINT inp_dscenario_frvalve_check_valve_type_ CHECK (((valve_type)::text = ANY (ARRAY[('FCV'::character varying)::text, ('GPV'::character varying)::text, ('PBV'::character varying)::text, ('PRV'::character varying)::text, ('PSV'::character varying)::text, ('TCV'::character varying)::text, ('PSRV'::character varying)::text]))),
	CONSTRAINT inp_dscenario_frvalve_check_status CHECK (status::text = ANY (ARRAY['ON'::text, 'OFF'::text])),
	CONSTRAINT inp_dscenario_frvalve_fkey_curve_id FOREIGN KEY (curve_id) REFERENCES inp_curve(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT inp_dscenario_frvalve_fkey_element_id FOREIGN KEY (element_id) REFERENCES element(element_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE inp_frpump (
    element_id int4 NOT NULL,
    curve_id varchar(16) NULL,
    status varchar(3) NULL,
    startup numeric(12, 4) NULL,
    shutoff numeric(12, 4) NULL,
    CONSTRAINT inp_frpump_pk PRIMARY KEY (element_id),
	CONSTRAINT inp_frpump_fk_element_id FOREIGN KEY (element_id) REFERENCES element(element_id),
    CONSTRAINT inp_frpump_chk_status CHECK (status::text = ANY (ARRAY['ON'::text, 'OFF'::text])),
    CONSTRAINT inp_frpump_fk_curve_id FOREIGN KEY (curve_id) REFERENCES inp_curve(id) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE inp_dscenario_frpump (
    dscenario_id int4 NOT NULL,
    element_id int4 NOT NULL,
    pump_type varchar(18) NOT NULL,
    curve_id varchar(16) NOT NULL,
    status varchar(3) NULL,
    startup numeric(12, 4) NULL,
    shutoff numeric(12, 4) NULL,
    CONSTRAINT inp_dscenario_frpump_pk PRIMARY KEY (element_id, dscenario_id),
    CONSTRAINT inp_dscenario_frpump_chk_status CHECK (status::text = ANY (ARRAY['ON'::text, 'OFF'::text])),
    CONSTRAINT inp_dscenario_frpump_fk_curve_id FOREIGN KEY (curve_id) REFERENCES inp_curve(id) ON DELETE RESTRICT ON UPDATE CASCADE
);


DROP FUNCTION IF EXISTS gw_trg_vi();

SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"inp_dscenario_valve", "column":"valv_type", "newName":"valve_type"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"inp_dscenario_virtualvalve", "column":"valv_type", "newName":"valve_type"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"inp_valve", "column":"valv_type", "newName":"valve_type"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"inp_virtualvalve", "column":"valv_type", "newName":"valve_type"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"v_edit_inp_dscenario_valve", "column":"valv_type", "newName":"valve_type"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"v_edit_inp_dscenario_virtualvalve", "column":"valv_type", "newName":"valve_type"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"v_edit_inp_valve", "column":"valv_type", "newName":"valve_type"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"v_edit_inp_virtualvalve", "column":"valv_type", "newName":"valve_type"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"ve_epa_valve", "column":"valv_type", "newName":"valve_type"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"ve_epa_virtualvalve", "column":"valv_type", "newName":"valve_type"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"vi_valves", "column":"valv_type", "newName":"valve_type"}}$$);



ALTER TABLE man_valve DROP CONSTRAINT IF EXISTS man_valve_to_arc_fky;
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"man_valve", "column":"to_arc", "dataType":"int4"}}$$);
ALTER TABLE man_pump DROP CONSTRAINT IF EXISTS man_pump_to_arc_fkey;
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"man_pump", "column":"to_arc", "dataType":"int4"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_source", "column":"inlet_arc", "dataType":"integer[]", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_tank", "column":"inlet_arc", "dataType":"integer[]", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_wtp", "column":"inlet_arc", "dataType":"integer[]", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_waterwell", "column":"inlet_arc", "dataType":"integer[]", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_meter", "column":"to_arc", "dataType":"int4", "isUtils":"False"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_register", "column":"length", "dataType":"numeric(12,3)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_register", "column":"width", "dataType":"numeric(12,3)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_register", "column":"height", "dataType":"numeric(12,3)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_register", "column":"max_volume", "dataType":"numeric(12,3)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_register", "column":"util_volume", "dataType":"numeric(12,3)", "isUtils":"False"}}$$);

ALTER TABLE inp_pump ALTER COLUMN pump_type SET DEFAULT 'POWERPUMP';
ALTER TABLE inp_virtualpump ALTER COLUMN pump_type SET DEFAULT 'POWERPUMP';
ALTER TABLE inp_dscenario_virtualpump ALTER COLUMN pump_type SET DEFAULT 'POWERPUMP';


ALTER TABLE connec_add ALTER COLUMN connec_id TYPE int4 USING connec_id::int4;
ALTER TABLE connec_add ADD CONSTRAINT connec_add_connec_id_fkey FOREIGN KEY (connec_id) REFERENCES connec(connec_id) ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE cat_feature_node ALTER COLUMN graph_delimiter DROP DEFAULT;
DROP VIEW IF EXISTS v_edit_cat_feature_node;
ALTER TABLE cat_feature_node DROP CONSTRAINT node_type_graph_delimiter_check;
ALTER TABLE cat_feature_node ALTER COLUMN graph_delimiter TYPE _text USING ARRAY[graph_delimiter];



SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"arc_add", "column":"pipe_capacity", "dataType":"float", "isUtils":"False"}}$$);



SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"arc_add", "column":"mincut_impact", "dataType":"json", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"arc_add", "column":"mincut_affectation", "dataType":"json", "isUtils":"False"}}$$);


-- Convert dma_id, dqa_id, presszone_id, expl_id, sector_id, muni_id to arrays in minsector
ALTER TABLE minsector DROP CONSTRAINT minsector_dma_id_fkey;
ALTER TABLE minsector ALTER COLUMN dma_id TYPE _int4 USING ARRAY[dma_id::int4];
ALTER TABLE minsector DROP CONSTRAINT minsector_dqa_id_fkey;
ALTER TABLE minsector ALTER COLUMN dqa_id TYPE _int4 USING ARRAY[dqa_id::int4];
ALTER TABLE minsector DROP CONSTRAINT minsector_presszonecat_id_fkey;
ALTER TABLE minsector ALTER COLUMN presszone_id TYPE _int4 USING ARRAY[presszone_id::int4];
ALTER TABLE minsector DROP CONSTRAINT minsector_expl_id_fkey;
ALTER TABLE minsector ALTER COLUMN expl_id TYPE _int4 USING ARRAY[expl_id::int4];
ALTER TABLE minsector ALTER COLUMN sector_id TYPE _int4 USING ARRAY[sector_id::int4];
ALTER TABLE minsector DROP CONSTRAINT minsectormuni_id_fkey;
ALTER TABLE minsector ALTER COLUMN muni_id TYPE _int4 USING ARRAY[muni_id::int4];

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"minsector", "column":"supplyzone_id", "dataType":"integer[]", "isUtils":"False"}}$$);


SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"minsector_graph", "column":"macrominsector_id"}}$$);
ALTER TABLE minsector_graph ADD CONSTRAINT minsector_graph_minsector_1_fk FOREIGN KEY (minsector_1) REFERENCES minsector(minsector_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE minsector_graph ADD CONSTRAINT minsector_graph_minsector_2_fk FOREIGN KEY (minsector_2) REFERENCES minsector(minsector_id) ON DELETE CASCADE ON UPDATE CASCADE;

CREATE TABLE man_pipelink (
	link_id int4 NOT NULL,
	CONSTRAINT man_pipelink_pkey PRIMARY KEY (link_id),
	CONSTRAINT man_pipelink_link_id_fkey FOREIGN KEY (link_id) REFERENCES link(link_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE man_vconnec (
	connec_id int4 NOT NULL,
	CONSTRAINT man_vconnec_pkey PRIMARY KEY (connec_id),
	CONSTRAINT man_vconnec_connec_id_fkey FOREIGN KEY (connec_id) REFERENCES connec(connec_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE man_vlink (
	link_id int4 NOT NULL,
	CONSTRAINT man_vlink_pkey PRIMARY KEY (link_id),
	CONSTRAINT man_vlink_link_id_fkey FOREIGN KEY (link_id) REFERENCES link(link_id) ON DELETE CASCADE ON UPDATE CASCADE
);


SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"om_mincut_valve", "column":"to_arc", "dataType":"int4", "isUtils":"False"}}$$);


DROP VIEW IF EXISTS v_ext_plot;
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"ext_plot", "column":"plot_code", "dataType":"varchar(100)", "isUtils":"True"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"ext_rtc_hydrometer", "column":"plot_code", "dataType":"varchar(100)", "isUtils":"False"}}$$);

DROP VIEW IF EXISTS v_rpt_comp_node;
DROP VIEW IF EXISTS v_rpt_comp_node_hourly;
DROP VIEW IF EXISTS v_rpt_comp_arc_hourly;

DROP VIEW IF EXISTS v_edit_inp_pattern;
DROP VIEW IF EXISTS v_edit_inp_pattern_value;
DROP VIEW IF EXISTS ve_link_link;

DROP VIEW IF EXISTS v_price_x_arc;

DO $$
DECLARE
    v_utils boolean;
BEGIN
     SELECT value::boolean INTO v_utils FROM config_param_system WHERE parameter='admin_utils_schema';

     IF v_utils THEN
        CREATE OR REPLACE VIEW ext_address
        AS SELECT id,
            muni_id,
            postcode,
            streetaxis_id,
            postnumber,
            plot_id,
            the_geom,
            ws_expl_id AS expl_id,
            postcomplement,
            ext_code,
            source
        FROM utils.address;

        CREATE OR REPLACE VIEW ext_streetaxis
        AS SELECT id,
          code,
          type,
          name,
          text,
          the_geom,
          ws_expl_id AS expl_id,
          muni_id,
          source
          FROM utils.streetaxis;
     END IF;
END $$;

CREATE OR REPLACE VIEW v_ext_address
AS SELECT ext_address.id,
    ext_address.muni_id,
    ext_address.postcode,
    ext_address.streetaxis_id,
    ext_address.postnumber,
    ext_address.plot_id,
    ext_address.expl_id,
    ext_streetaxis.name,
    ext_address.the_geom,
    ext_address.postcomplement,
    ext_address.ext_code,
    ext_address.source
   FROM selector_municipality s,
    ext_address
     LEFT JOIN ext_streetaxis ON ext_streetaxis.id::text = ext_address.streetaxis_id::text
  WHERE ext_address.muni_id = s.muni_id AND s.cur_user = "current_user"()::text;


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
   FROM selector_municipality,
    ext_streetaxis
  WHERE ext_streetaxis.muni_id = selector_municipality.muni_id AND selector_municipality.cur_user = "current_user"()::text;

-- ====

CREATE OR REPLACE VIEW v_edit_arc
AS WITH
  typevalue AS
    (
      SELECT edit_typevalue.typevalue, edit_typevalue.id, edit_typevalue.idval
      FROM edit_typevalue
      WHERE edit_typevalue.typevalue::text = ANY (ARRAY['sector_type'::text, 'presszone_type'::text, 'dma_type'::text, 'dqa_type'::text, 'supplyzone_type'::text, 'omzone_type'::text])
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
	presszone_table AS
		(
      SELECT presszone_id, head AS presszone_head, stylesheet, id::varchar(16) AS presszone_type
      FROM presszone
      LEFT JOIN typevalue t ON t.id::text = presszone.presszone_type AND t.typevalue::text = 'presszone_type'::text
		),
	dqa_table AS
		(
      SELECT dqa_id, stylesheet, id::varchar(16) AS dqa_type, macrodqa_id
      FROM dqa
      LEFT JOIN typevalue t ON t.id::text = dqa.dqa_type AND t.typevalue::text = 'dqa_type'::text
		),
  supplyzone_table AS
    (
      SELECT supplyzone_id, stylesheet, id::varchar(16) AS supplyzone_type
      FROM supplyzone
      LEFT JOIN typevalue t ON t.id::text = supplyzone.supplyzone_type AND t.typevalue::text = 'supplyzone_type'::text
    ),
  omzone_table AS
    (
      SELECT omzone_id, id::varchar(16) AS omzone_type, macroomzone_id
      FROM omzone
      LEFT JOIN typevalue t ON t.id::text = omzone.omzone_type AND t.typevalue::text = 'omzone_type'::text
    ),
	arc_psector AS
		(
      SELECT pp.arc_id, pp.state AS p_state
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
        AND se.expl_id = ANY (array_append(expl_visibility, arc.expl_id))
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
	  SELECT
      arc.arc_id,
      arc.code,
      arc.sys_code,
      arc.node_1,
      arc.nodetype_1,
      arc.elevation1,
      arc.depth1,
      arc.staticpress1,
      arc.node_2,
      arc.nodetype_2,
      arc.staticpress2,
      arc.elevation2,
      arc.depth2,
      ((COALESCE(arc.depth1) + COALESCE(arc.depth2)) / 2::numeric)::numeric(12,2) AS depth,
      cat_arc.arc_type,
      arc.arccat_id,
      cat_feature.feature_class AS sys_type,
      cat_arc.matcat_id AS cat_matcat_id,
      cat_arc.pnom AS cat_pnom,
      cat_arc.dnom AS cat_dnom,
      cat_arc.dint AS cat_dint,
      cat_arc.dr AS cat_dr,
      arc.epa_type,
      arc.state,
      arc.state_type,
      arc.parent_id,
      arc.expl_id,
      exploitation.macroexpl_id,
      arc.muni_id,
      arc.sector_id,
      sector_table.macrosector_id,
      sector_table.sector_type,
      arc.supplyzone_id,
      supplyzone_table.supplyzone_type,
      arc.presszone_id,
      presszone_table.presszone_type,
      presszone_table.presszone_head,
      arc.dma_id,
      dma_table.macrodma_id,
      dma_table.dma_type,
      arc.dqa_id,
      dqa_table.macrodqa_id,
      dqa_table.dqa_type,
      arc.omzone_id,
      omzone_table.macroomzone_id,
      omzone_table.omzone_type,
      arc.minsector_id,
      arc.pavcat_id,
      arc.soilcat_id,
      arc.function_type,
      arc.category_type,
      arc.location_type,
      arc.fluid_type,
      arc.descript,
      st_length2d(arc.the_geom)::numeric(12,2) AS gis_length,
      arc.custom_length,
      arc.annotation,
      arc.observ,
      arc.comment,
      concat(cat_feature.link_path, arc.link) AS link,
      arc.num_value,
      arc.district_id,
      arc.postcode,
      arc.streetaxis_id,
      arc.postnumber,
      arc.postcomplement,
      arc.streetaxis2_id,
      arc.postnumber2,
      arc.postcomplement2,
      mu.region_id,
      mu.province_id,
      arc.workcat_id,
      arc.workcat_id_end,
      arc.workcat_id_plan,
      arc.builtdate,
      arc.enddate,
      arc.ownercat_id,
      arc.om_state,
      arc.conserv_state,
      CASE
        WHEN arc.brand_id IS NULL THEN cat_arc.brand_id
        ELSE arc.brand_id
      END AS brand_id,
      CASE
        WHEN arc.model_id IS NULL THEN cat_arc.model_id
        ELSE arc.model_id
      END AS model_id,
      arc.serial_number,
      arc.asset_id,
      arc.adate,
      arc.adescript,
      arc.verified,
      arc.datasource,
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
        WHEN arc.sector_id > 0 AND vst.is_operative = true AND arc.epa_type::text <> 'UNDEFINED'::text THEN arc.epa_type
        ELSE NULL::text
      END AS inp_type,
      arc_add.result_id,
      arc_add.flow_max,
      arc_add.flow_min,
      arc_add.flow_avg,
      arc_add.vel_max,
      arc_add.vel_min,
      arc_add.vel_avg,
      arc_add.tot_headloss_max,
      arc_add.tot_headloss_min,
      arc_add.mincut_connecs,
      arc_add.mincut_hydrometers,
      arc_add.mincut_length,
      arc_add.mincut_watervol,
      arc_add.mincut_criticality,
      arc_add.hydraulic_criticality,
      arc_add.pipe_capacity,
      arc_add.mincut_impact,
      arc_add.mincut_affectation,
      sector_table.stylesheet ->> 'featureColor'::text AS sector_style,
      dma_table.stylesheet ->> 'featureColor'::text AS dma_style,
      presszone_table.stylesheet ->> 'featureColor'::text AS presszone_style,
      dqa_table.stylesheet ->> 'featureColor'::text AS dqa_style,
      supplyzone_table.stylesheet ->> 'featureColor'::text AS supplyzone_style,
      arc.lock_level,
      arc.expl_visibility,
      date_trunc('second'::text, arc.created_at) AS created_at,
      arc.created_by,
      date_trunc('second'::text, arc.updated_at) AS updated_at,
      arc.updated_by,
      arc.the_geom
      FROM arc_selector
      JOIN arc ON arc.arc_id = arc_selector.arc_id
      JOIN cat_arc ON cat_arc.id::text = arc.arccat_id::text
      JOIN cat_feature ON cat_feature.id::text = cat_arc.arc_type::text
      JOIN exploitation ON arc.expl_id = exploitation.expl_id
      JOIN ext_municipality mu ON arc.muni_id = mu.muni_id
      JOIN sector_table ON sector_table.sector_id = arc.sector_id
      LEFT JOIN presszone_table ON presszone_table.presszone_id = arc.presszone_id
      LEFT JOIN dma_table ON dma_table.dma_id = arc.dma_id
      LEFT JOIN dqa_table ON dqa_table.dqa_id = arc.dqa_id
      LEFT JOIN supplyzone_table ON supplyzone_table.supplyzone_id = arc.supplyzone_id
      LEFT JOIN omzone_table ON omzone_table.omzone_id = arc.omzone_id
      LEFT JOIN arc_add ON arc_add.arc_id = arc.arc_id
      LEFT JOIN value_state_type vst ON vst.id = arc.state_type
    )
  SELECT arc_selected.*
  FROM arc_selected;

CREATE OR REPLACE VIEW v_edit_node
AS WITH
    typevalue AS
      (
        SELECT edit_typevalue.typevalue, edit_typevalue.id, edit_typevalue.idval
        FROM edit_typevalue
        WHERE edit_typevalue.typevalue::text = ANY (ARRAY['sector_type'::text, 'presszone_type'::text, 'dma_type'::text, 'dqa_type'::text, 'supplyzone_type'::text, 'omzone_type'::text])
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
    presszone_table AS
      (
        SELECT presszone_id, head AS presszone_head, stylesheet, id::varchar(16) AS presszone_type
        FROM presszone
        LEFT JOIN typevalue t ON t.id::text = presszone.presszone_type AND t.typevalue::text = 'presszone_type'::text
      ),
    dqa_table AS
      (
        SELECT dqa_id, stylesheet, id::varchar(16) AS dqa_type, macrodqa_id
        FROM dqa
        LEFT JOIN typevalue t ON t.id::text = dqa.dqa_type AND t.typevalue::text = 'dqa_type'::text
      ),
    supplyzone_table AS
      (
        SELECT supplyzone_id, stylesheet, id::varchar(16) AS supplyzone_type
        FROM supplyzone
        LEFT JOIN typevalue t ON t.id::text = supplyzone.supplyzone_type AND t.typevalue::text = 'supplyzone_type'::text
      ),
    omzone_table AS
      (
        SELECT omzone_id, id::varchar(16) AS omzone_type, macroomzone_id
        FROM omzone
        LEFT JOIN typevalue t ON t.id::text = omzone.omzone_type AND t.typevalue::text = 'omzone_type'::text
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
          AND se.expl_id = ANY (array_append(expl_visibility, node.expl_id))
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
		SELECT
        node.node_id,
        node.code,
        node.sys_code,
        node.top_elev,
        node.custom_top_elev,
        CASE
            WHEN node.custom_top_elev IS NOT NULL THEN node.custom_top_elev
            ELSE node.top_elev
        END AS sys_top_elev,
        node.depth,
        cat_node.node_type,
        cat_feature.feature_class AS sys_type,
        node.nodecat_id,
        cat_node.matcat_id AS cat_matcat_id,
        cat_node.pnom AS cat_pnom,
        cat_node.dnom AS cat_dnom,
        cat_node.dint AS cat_dint,
        node.epa_type,
        node.state,
        node.state_type,
        node.arc_id,
        node.parent_id,
        node.expl_id,
        exploitation.macroexpl_id,
        node.muni_id,
        node.sector_id,
        sector_table.macrosector_id,
        sector_table.sector_type,
        node.supplyzone_id,
        supplyzone_table.supplyzone_type,
        node.presszone_id,
        presszone_table.presszone_type,
        presszone_table.presszone_head,
        node.dma_id,
        dma_table.macrodma_id,
        dma_table.dma_type,
        node.dqa_id,
        dqa_table.macrodqa_id,
        dqa_table.dqa_type,
        node.omzone_id,
        omzone_table.macroomzone_id,
        omzone_table.omzone_type,
        node.minsector_id,
        node.pavcat_id,
        node.soilcat_id,
        node.function_type,
        node.category_type,
        node.location_type,
        node.fluid_type,
        node.staticpressure,
        node.annotation,
        node.observ,
        node.comment,
        node.descript,
        concat(cat_feature.link_path, node.link) AS link,
        node.num_value,
        node.district_id,
        streetaxis_id,
        node.postcode,
        node.postnumber,
        node.postcomplement,
        streetaxis2_id,
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
        node.accessibility,
        node.om_state,
        node.conserv_state,
        node.access_type,
        node.placement_type,
        CASE
          WHEN node.brand_id IS NULL THEN cat_node.brand_id
          ELSE node.brand_id
        END AS brand_id,
        CASE
          WHEN node.model_id IS NULL THEN cat_node.model_id
          ELSE node.model_id
        END AS model_id,
        node.serial_number,
        node.asset_id,
        node.adate,
        node.adescript,
        node.verified,
        node.datasource,
        node.hemisphere,
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
          WHEN node.sector_id > 0 AND vst.is_operative = true AND node.epa_type::text <> 'UNDEFINED'::text THEN node.epa_type
          ELSE NULL::text
        END AS inp_type,
        node_add.demand_max,
        node_add.demand_min,
        node_add.demand_avg,
        node_add.press_max,
        node_add.press_min,
        node_add.press_avg,
        node_add.head_max,
        node_add.head_min,
        node_add.head_avg,
        node_add.quality_max,
        node_add.quality_min,
        node_add.quality_avg,
        node_add.result_id,
        sector_table.stylesheet ->> 'featureColor'::text AS sector_style,
        dma_table.stylesheet ->> 'featureColor'::text AS dma_style,
        presszone_table.stylesheet ->> 'featureColor'::text AS presszone_style,
        dqa_table.stylesheet ->> 'featureColor'::text AS dqa_style,
        supplyzone_table.stylesheet ->> 'featureColor'::text AS supplyzone_style,
        node.lock_level,
        node.expl_visibility,
        (SELECT ST_X(node.the_geom)) AS xcoord,
        (SELECT ST_Y(node.the_geom)) AS ycoord,
        (SELECT ST_Y(ST_Transform(node.the_geom, 4326))) AS lat,
        (SELECT ST_X(ST_Transform(node.the_geom, 4326))) AS long,
        m.closed as closed_valve,
        m.broken as broken_valve,
        date_trunc('second'::text, node.created_at) AS created_at,
        node.created_by,
        date_trunc('second'::text, node.updated_at) AS updated_at,
        node.updated_by,
        node.the_geom
        FROM node_selector
        JOIN node ON node.node_id = node_selector.node_id
        JOIN cat_node ON cat_node.id::text = node.nodecat_id::text
        JOIN cat_feature ON cat_feature.id::text = cat_node.node_type::text
        JOIN value_state_type vst ON vst.id = node.state_type
        JOIN exploitation ON node.expl_id = exploitation.expl_id
        JOIN ext_municipality mu ON node.muni_id = mu.muni_id
        JOIN sector_table ON sector_table.sector_id = node.sector_id
        LEFT JOIN presszone_table ON presszone_table.presszone_id = node.presszone_id
        LEFT JOIN dma_table ON dma_table.dma_id = node.dma_id
        LEFT JOIN dqa_table ON dqa_table.dqa_id = node.dqa_id
        LEFT JOIN supplyzone_table ON supplyzone_table.supplyzone_id = node.supplyzone_id
        LEFT JOIN omzone_table ON omzone_table.omzone_id = node.omzone_id
        LEFT JOIN node_add ON node_add.node_id = node.node_id
        LEFT JOIN man_valve m ON m.node_id = node.node_id
      )
    SELECT n.*
    FROM node_selected n;


CREATE OR REPLACE VIEW v_edit_link
AS WITH
    typevalue AS
      (
        SELECT edit_typevalue.typevalue, edit_typevalue.id, edit_typevalue.idval
        FROM edit_typevalue
        WHERE edit_typevalue.typevalue::text = ANY (ARRAY['sector_type'::text, 'presszone_type'::text, 'dma_type'::text, 'dqa_type'::text, 'supplyzone_type'::text, 'omzone_type'::text])
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
    presszone_table AS
      (
        SELECT presszone_id, head AS presszone_head, stylesheet, id::varchar(16) AS presszone_type
        FROM presszone
        LEFT JOIN typevalue t ON t.id::text = presszone.presszone_type AND t.typevalue::text = 'presszone_type'::text
      ),
    dqa_table AS
      (
        SELECT dqa_id, stylesheet, id::varchar(16) AS dqa_type, macrodqa_id
        FROM dqa
        LEFT JOIN typevalue t ON t.id::text = dqa.dqa_type AND t.typevalue::text = 'dqa_type'::text
      ),
    supplyzone_table AS
      (
        SELECT supplyzone_id, stylesheet, id::varchar(16) AS supplyzone_type
        FROM supplyzone
        LEFT JOIN typevalue t ON t.id::text = supplyzone.supplyzone_type AND t.typevalue::text = 'supplyzone_type'::text
      ),
    omzone_table AS
      (
        SELECT omzone_id, id::varchar(16) AS omzone_type, macroomzone_id
        FROM omzone
        LEFT JOIN typevalue t ON t.id::text = omzone.omzone_type AND t.typevalue::text = 'omzone_type'::text
      ),
    inp_network_mode AS
      (
        SELECT value FROM config_param_user WHERE parameter::text = 'inp_options_networkmode'::text AND config_param_user.cur_user::text = CURRENT_USER
      ),
    link_psector AS
      (
        SELECT DISTINCT ON (pp.connec_id, pp.state) 'CONNEC' AS feature_type, pp.connec_id AS feature_id, pp.state AS p_state, pp.psector_id, pp.link_id
        FROM plan_psector_x_connec pp
        JOIN selector_psector sp ON sp.cur_user = current_user AND sp.psector_id = pp.psector_id
        ORDER BY pp.connec_id, pp.state, pp.link_id DESC NULLS LAST
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
          AND se.expl_id = ANY (array_append(expl_visibility, l.expl_id))
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
    link_selected AS
      (
        SELECT
        l.link_id,
        l.code,
        l.sys_code,
        l.top_elev1,
        l.depth1,
        CASE
          WHEN l.top_elev1 IS NULL OR l.depth1 IS NULL THEN NULL
          ELSE (l.top_elev1 - l.depth1)
        END AS elevation1,
        l.exit_id,
        l.exit_type,
        l.top_elev2,
        l.depth2,
        CASE
          WHEN l.top_elev2 IS NULL OR l.depth2 IS NULL THEN NULL
          ELSE (l.top_elev2 - l.depth2)
        END AS elevation2,
        l.feature_type,
        l.feature_id,
        cat_link.link_type,
        cat_feature.feature_class AS sys_type,
        l.linkcat_id,
        l.epa_type,
        l.state,
        l.state_type,
        l.expl_id,
        exploitation.macroexpl_id,
        l.muni_id,
        l.sector_id,
        sector_table.macrosector_id,
        sector_table.sector_type,
        l.supplyzone_id,
        supplyzone_table.supplyzone_type,
        l.presszone_id,
        presszone_table.presszone_type,
        presszone_table.presszone_head,
        l.dma_id,
        dma_table.macrodma_id,
        dma_table.dma_type,
        l.dqa_id,
        dqa_table.macrodqa_id,
        dqa_table.dqa_type,
        l.omzone_id,
        omzone_table.macroomzone_id,
        omzone_table.omzone_type,
        l.minsector_id,
        l.location_type,
        l.fluid_type,
        l.custom_length,
        st_length(l.the_geom)::numeric(12,3) AS gis_length,
        l.staticpressure,
        l.annotation,
        l.observ,
        l.comment,
        l.descript,
        l.link,
        l.num_value,
        l.workcat_id,
        l.workcat_id_end,
        l.builtdate,
        l.enddate,
        l.brand_id,
        l.model_id,
        l.verified,
        l.uncertain,
        l.userdefined_geom,
        l.datasource,
        l.is_operative,
        CASE
          WHEN l.sector_id > 0 AND l.is_operative = true AND l.epa_type = 'JUNCTION'::text AND inp_network_mode.value = '4'::text
          THEN l.epa_type::text
          ELSE NULL::text
        END AS inp_type,
        l.lock_level,
        l.expl_visibility,
        l.created_at,
        l.created_by,
        l.updated_at,
        l.updated_by,
        l.the_geom
        FROM link_selector
        JOIN link l ON l.link_id = link_selector.link_id
        LEFT JOIN connec c ON c.connec_id = l.feature_id
        JOIN sector_table ON sector_table.sector_id = l.sector_id
        JOIN cat_link ON cat_link.id::text = l.linkcat_id::text
        JOIN cat_feature ON cat_feature.id::text = cat_link.link_type::text
        JOIN exploitation ON l.expl_id = exploitation.expl_id
        LEFT JOIN presszone_table ON presszone_table.presszone_id = l.presszone_id
        LEFT JOIN dma_table ON dma_table.dma_id = l.dma_id
        LEFT JOIN dqa_table ON dqa_table.dqa_id = l.dqa_id
        LEFT JOIN supplyzone_table ON supplyzone_table.supplyzone_id = l.supplyzone_id
        LEFT JOIN omzone_table ON omzone_table.omzone_id = l.omzone_id
        LEFT JOIN inp_network_mode ON true
      )
    SELECT l.*
    FROM link_selected l;

CREATE OR REPLACE VIEW v_edit_connec
AS WITH
    typevalue AS
      (
        SELECT edit_typevalue.typevalue, edit_typevalue.id, edit_typevalue.idval
        FROM edit_typevalue
        WHERE edit_typevalue.typevalue::text = ANY (ARRAY['sector_type'::text, 'presszone_type'::text, 'dma_type'::text, 'dqa_type'::text, 'supplyzone_type'::text, 'omzone_type'::text])
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
    presszone_table AS
      (
        SELECT presszone_id, head AS presszone_head, stylesheet, id::varchar(16) AS presszone_type
        FROM presszone
        LEFT JOIN typevalue t ON t.id::text = presszone.presszone_type AND t.typevalue::text = 'presszone_type'::text
      ),
    dqa_table AS
      (
        SELECT dqa_id, stylesheet, id::varchar(16) AS dqa_type, macrodqa_id
        FROM dqa
        LEFT JOIN typevalue t ON t.id::text = dqa.dqa_type AND t.typevalue::text = 'dqa_type'::text
      ),
    supplyzone_table AS
      (
        SELECT supplyzone_id, stylesheet, id::varchar(16) AS supplyzone_type
        FROM supplyzone
        LEFT JOIN typevalue t ON t.id::text = supplyzone.supplyzone_type AND t.typevalue::text = 'supplyzone_type'::text
      ),
    omzone_table AS
      (
        SELECT omzone_id, id::varchar(16) AS omzone_type, macroomzone_id
        FROM omzone
        LEFT JOIN typevalue t ON t.id::text = omzone.omzone_type AND t.typevalue::text = 'omzone_type'::text
      ),
    inp_network_mode AS
      (
        SELECT value FROM config_param_user WHERE parameter::text = 'inp_options_networkmode'::text AND config_param_user.cur_user::text = CURRENT_USER
      ),
    link_planned as
      (
        SELECT link_id, feature_id, feature_type, exit_id, exit_type, l.expl_id, macroexpl_id, l.sector_id, sector_type, macrosector_id,
        l.dma_id, dma_type, l.omzone_id, omzone_type, macrodma_id, l.presszone_id, presszone_type, presszone_head, l.dqa_id, dqa_type, dqa_table.macrodqa_id,
        l.supplyzone_id, supplyzone_type, fluid_type,
        minsector_id, staticpressure
        FROM link l
        JOIN exploitation USING (expl_id)
        JOIN sector_table ON sector_table.sector_id = l.sector_id
        LEFT JOIN presszone_table ON presszone_table.presszone_id = l.presszone_id
        LEFT JOIN dma_table ON dma_table.dma_id = l.dma_id
        LEFT JOIN dqa_table ON dqa_table.dqa_id = l.dqa_id
        LEFT JOIN supplyzone_table ON supplyzone_table.supplyzone_id = l.supplyzone_id
        LEFT JOIN omzone_table ON omzone_table.omzone_id = l.omzone_id
        WHERE l.state = 2
      ),
    connec_psector AS
      (
        SELECT DISTINCT ON (pp.connec_id, pp.state) pp.connec_id, pp.state AS p_state, pp.psector_id, pp.arc_id, pp.link_id
        FROM plan_psector_x_connec pp
        JOIN selector_psector sp ON sp.cur_user = current_user AND sp.psector_id = pp.psector_id
        ORDER BY pp.connec_id, pp.state, pp.link_id desc nulls last
      ),
    connec_selector AS
      (
        SELECT connec.connec_id, arc_id, null::integer AS link_id
        FROM connec
        JOIN selector_state s ON s.cur_user = CURRENT_USER AND connec.state = s.state_id
        LEFT JOIN (
          SELECT connec_id FROM connec_psector WHERE p_state = 0
        ) a USING (connec_id)
        WHERE a.connec_id IS NULL
        AND EXISTS (
          SELECT 1 FROM selector_expl se
          WHERE s.cur_user = current_user
          AND se.expl_id = ANY (array_append(expl_visibility, connec.expl_id))
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
        SELECT connec_id, connec_psector.arc_id, link_id FROM connec_psector
        WHERE p_state = 1
      ),
    connec_selected AS
      (
        SELECT
          connec.connec_id,
          connec.code,
          connec.sys_code,
          connec.top_elev,
          connec.depth,
          cat_connec.connec_type,
          cat_feature.feature_class AS sys_type,
          connec.conneccat_id,
          cat_connec.matcat_id AS cat_matcat_id,
          cat_connec.pnom AS cat_pnom,
          cat_connec.dnom AS cat_dnom,
          cat_connec.dint AS cat_dint,
          connec.customer_code,
          connec.connec_length,
          connec.epa_type,
          connec.state,
          connec.state_type,
          connec_selector.arc_id,
          connec.expl_id,
          exploitation.macroexpl_id,
          connec.muni_id,
          CASE
            WHEN link_planned.sector_id IS NULL THEN connec.sector_id
            ELSE link_planned.sector_id
          END AS sector_id,
          CASE
            WHEN link_planned.macrosector_id IS NULL THEN sector_table.macrosector_id
            ELSE link_planned.macrosector_id
          END AS macrosector_id,
          CASE
            WHEN link_planned.sector_type IS NULL THEN sector_table.sector_type
            ELSE link_planned.sector_type
          END AS sector_type,
          CASE
            WHEN link_planned.supplyzone_id IS NULL THEN supplyzone_table.supplyzone_id
            ELSE link_planned.supplyzone_id
          END AS supplyzone_id,
          CASE
            WHEN link_planned.supplyzone_type IS NULL THEN supplyzone_table.supplyzone_type
            ELSE link_planned.supplyzone_type
          END AS supplyzone_type,
          CASE
            WHEN link_planned.presszone_id IS NULL THEN presszone_table.presszone_id
            ELSE link_planned.presszone_id
          END AS presszone_id,
          CASE
            WHEN link_planned.presszone_type IS NULL THEN presszone_table.presszone_type
            ELSE link_planned.presszone_type
          END AS presszone_type,
          CASE
            WHEN link_planned.presszone_head IS NULL THEN presszone_table.presszone_head
            ELSE link_planned.presszone_head
          END AS presszone_head,
          CASE
            WHEN link_planned.dma_id IS NULL THEN dma_table.dma_id
            ELSE link_planned.dma_id
          END AS dma_id,
          CASE
            WHEN link_planned.macrodma_id IS NULL THEN dma_table.macrodma_id
            ELSE link_planned.macrodma_id
          END AS macrodma_id,
          CASE
            WHEN link_planned.dma_type IS NULL then dma_table.dma_type
            ELSE link_planned.dma_type::varchar
          END AS dma_type,
          CASE
            WHEN link_planned.dqa_id IS NULL THEN dqa_table.dqa_id
            ELSE link_planned.dqa_id
          END AS dqa_id,
          CASE
            WHEN link_planned.macrodqa_id IS NULL THEN dqa_table.macrodqa_id
            ELSE link_planned.macrodqa_id
          END AS macrodqa_id,
          CASE
            WHEN link_planned.dqa_type IS NULL THEN dqa_table.dqa_type
            ELSE link_planned.dqa_type
          END AS dqa_type,
          CASE
            WHEN link_planned.omzone_id IS NULL THEN omzone_table.omzone_id
            ELSE link_planned.omzone_id
          END AS omzone_id,
          CASE
            WHEN link_planned.omzone_type IS NULL THEN omzone_table.omzone_type
            ELSE link_planned.omzone_type
          END AS omzone_type,
          connec.crmzone_id,
          crmzone.macrocrmzone_id,
          crmzone.name AS crmzone_name,
          CASE
            WHEN link_planned.minsector_id IS NULL THEN connec.minsector_id
            ELSE link_planned.minsector_id
          END AS minsector_id,
          connec.soilcat_id,
          connec.function_type,
          connec.category_type,
          connec.location_type,
          CASE
            WHEN link_planned.fluid_type IS NULL THEN connec.fluid_type
            ELSE link_planned.fluid_type::character varying(50)
          END AS fluid_type,
          connec.n_hydrometer,
          connec.n_inhabitants,
          CASE
            WHEN link_planned.staticpressure IS NULL THEN connec.staticpressure
            ELSE link_planned.staticpressure
          END AS staticpressure,
          connec.descript,
          connec.annotation,
          connec.observ,
          connec.comment,
          concat(cat_feature.link_path, connec.link) AS link,
          connec.num_value,
          connec.district_id,
          connec.postcode,
          streetaxis_id,
          connec.postnumber,
          connec.postcomplement,
          streetaxis2_id,
          connec.postnumber2,
          connec.postcomplement2,
          mu.region_id,
          mu.province_id,
          connec.block_code,
          connec.plot_code,
          connec.workcat_id,
          connec.workcat_id_end,
          connec.workcat_id_plan,
          connec.builtdate,
          connec.enddate,
          connec.ownercat_id,
          CASE
            WHEN link_planned.link_id IS NULL THEN connec.pjoint_id
            ELSE link_planned.exit_id
          END AS pjoint_id,
          CASE
            WHEN link_planned.link_id IS NULL THEN connec.pjoint_type
            ELSE link_planned.exit_type
          END AS pjoint_type,
          connec.om_state,
          connec.conserv_state,
          connec.accessibility,
          connec.access_type,
          connec.placement_type,
          connec.priority,
          CASE
            WHEN connec.brand_id IS NULL THEN cat_connec.brand_id
            ELSE connec.brand_id
          END AS brand_id,
          CASE
            WHEN connec.model_id IS NULL THEN cat_connec.model_id
            ELSE connec.model_id
          END AS model_id,
          connec.serial_number,
          connec.asset_id,
          connec.adate,
          connec.adescript,
          connec.verified,
          connec.datasource,
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
          CASE
            WHEN connec.sector_id > 0 AND vst.is_operative = true AND connec.epa_type = 'JUNCTION'::text AND inp_network_mode.value = '4'::text THEN connec.epa_type::character varying
            ELSE NULL::text
          END AS inp_type,
          connec_add.demand_base,
          connec_add.demand_max,
          connec_add.demand_min,
          connec_add.demand_avg,
          connec_add.press_max,
          connec_add.press_min,
          connec_add.press_avg,
          connec_add.quality_max,
          connec_add.quality_min,
          connec_add.quality_avg,
          connec_add.flow_max,
          connec_add.flow_min,
          connec_add.flow_avg,
          connec_add.vel_max,
          connec_add.vel_min,
          connec_add.vel_avg,
          connec_add.result_id,
          sector_table.stylesheet ->> 'featureColor'::text AS sector_style,
          dma_table.stylesheet ->> 'featureColor'::text AS dma_style,
          presszone_table.stylesheet ->> 'featureColor'::text AS presszone_style,
          dqa_table.stylesheet ->> 'featureColor'::text AS dqa_style,
          supplyzone_table.stylesheet ->> 'featureColor'::text AS supplyzone_style,
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
          connec.the_geom
        FROM connec_selector
        JOIN connec ON connec.connec_id = connec_selector.connec_id
        JOIN cat_connec ON cat_connec.id::text = connec.conneccat_id::text
        JOIN cat_feature ON cat_feature.id::text = cat_connec.connec_type::text
        JOIN exploitation ON connec.expl_id = exploitation.expl_id
        JOIN ext_municipality mu ON connec.muni_id = mu.muni_id
        JOIN sector_table ON sector_table.sector_id = connec.sector_id
        LEFT JOIN presszone_table ON presszone_table.presszone_id = connec.presszone_id
        LEFT JOIN dma_table ON dma_table.dma_id = connec.dma_id
        LEFT JOIN dqa_table ON dqa_table.dqa_id = connec.dqa_id
        LEFT JOIN supplyzone_table ON supplyzone_table.supplyzone_id = connec.supplyzone_id
        LEFT JOIN omzone_table ON omzone_table.omzone_id = connec.omzone_id
        LEFT JOIN crmzone ON crmzone.id::text = connec.crmzone_id::text
        LEFT JOIN link_planned USING (link_id)
        LEFT JOIN connec_add ON connec_add.connec_id = connec.connec_id
        LEFT JOIN value_state_type vst ON vst.id = connec.state_type
        LEFT JOIN inp_network_mode ON true
      )
    SELECT c.*
    FROM connec_selected c;

CREATE OR REPLACE VIEW v_edit_minsector
AS WITH sel_expl AS (
	SELECT selector_expl.expl_id FROM selector_expl WHERE selector_expl.cur_user = CURRENT_USER
)
SELECT m.minsector_id,
    m.code,
    m.dma_id,
    m.dqa_id,
    m.presszone_id,
    m.supplyzone_id,
    m.expl_id,
    m.num_border,
    m.num_connec,
    m.num_hydro,
    m.length,
    m.descript,
    m.addparam::text AS addparam,
    m.the_geom
FROM minsector m
WHERE EXISTS (
  	SELECT 1
  	FROM sel_expl
  	WHERE sel_expl.expl_id = ANY (m.expl_id)
);

CREATE OR REPLACE VIEW v_edit_minsector_mincut AS
WITH sel_expl AS (
	SELECT selector_expl.expl_id FROM selector_expl WHERE selector_expl.cur_user = CURRENT_USER
), minsector_mapzones AS (
  SELECT
    t.mincut_minsector_id AS minsector_id,
    array_agg(DISTINCT t.dma_id) AS dma_id,
    array_agg(DISTINCT t.dqa_id) AS dqa_id,
    array_agg(DISTINCT t.presszone_id) AS presszone_id,
    array_agg(DISTINCT t.expl_id) AS expl_id,
    array_agg(DISTINCT t.sector_id) AS sector_id,
    array_agg(DISTINCT t.muni_id) AS muni_id,
    array_agg(DISTINCT t.supplyzone_id) AS supplyzone_id,
    ST_Union(t.the_geom) AS the_geom
  FROM (
    SELECT
      m.minsector_id,
      mm.minsector_id AS mincut_minsector_id,
      unnest(m.dma_id) AS dma_id,
      unnest(m.dqa_id) AS dqa_id,
      unnest(m.presszone_id) AS presszone_id,
      unnest(m.expl_id) AS expl_id,
      unnest(m.sector_id) AS sector_id,
      unnest(m.muni_id) AS muni_id,
      unnest(m.supplyzone_id) AS supplyzone_id,
      m.the_geom
    FROM minsector m
    JOIN minsector_mincut mm ON mm.mincut_minsector_id = m.minsector_id
  ) t
  GROUP BY t.mincut_minsector_id
),
minsector_sums AS (
  SELECT
    mm.minsector_id,
    SUM(m.num_border) AS num_border,
    SUM(m.num_connec) AS num_connec,
    SUM(m.num_hydro) AS num_hydro,
    SUM(m.length) AS length
  FROM minsector_mincut mm
  JOIN minsector m ON m.minsector_id = mm.mincut_minsector_id
  GROUP BY mm.minsector_id
)
SELECT
	m.minsector_id,
	dma_id,
	dqa_id,
	presszone_id,
	expl_id,
	sector_id,
	muni_id,
	supplyzone_id,
	num_border,
	num_connec,
	num_hydro,
	length,
	the_geom
FROM minsector_mapzones m
JOIN minsector_sums s ON s.minsector_id = m.minsector_id
WHERE EXISTS (
  SELECT 1
  FROM sel_expl
  WHERE sel_expl.expl_id = ANY (m.expl_id)
);

CREATE OR REPLACE VIEW v_edit_samplepoint
AS SELECT sm.sample_id,
    sm.code,
    sm.lab_code,
    sm.feature_id,
    sm.featurecat_id,
    sm.dma_id,
    sm.macrodma_id,
    sm.presszone_id,
    sm.state,
    sm.builtdate,
    sm.enddate,
    sm.workcat_id,
    sm.workcat_id_end,
    sm.rotation,
    sm.muni_id,
    sm.streetaxis_id,
    sm.postnumber,
    sm.postcode,
    sm.district_id,
    sm.streetaxis2_id,
    sm.postnumber2,
    sm.postcomplement,
    sm.postcomplement2,
    sm.place_name,
    sm.cabinet,
    sm.observations,
    sm.verified,
    sm.the_geom,
    sm.expl_id,
    sm.link,
    sm.sector_id
   FROM ( SELECT samplepoint.sample_id,
            samplepoint.code,
            samplepoint.lab_code,
            samplepoint.feature_id,
            samplepoint.featurecat_id,
            samplepoint.dma_id,
            dma.macrodma_id,
            samplepoint.presszone_id,
            samplepoint.state,
            samplepoint.builtdate,
            samplepoint.enddate,
            samplepoint.workcat_id,
            samplepoint.workcat_id_end,
            samplepoint.rotation,
            samplepoint.muni_id,
            samplepoint.streetaxis_id,
            samplepoint.postnumber,
            samplepoint.postcode,
            samplepoint.district_id,
            samplepoint.streetaxis2_id,
            samplepoint.postnumber2,
            samplepoint.postcomplement,
            samplepoint.postcomplement2,
            samplepoint.place_name,
            samplepoint.cabinet,
            samplepoint.observations,
            samplepoint.verified,
            samplepoint.the_geom,
            samplepoint.expl_id,
            samplepoint.link,
            samplepoint.sector_id
           FROM selector_expl,
            samplepoint
             JOIN v_state_samplepoint ON samplepoint.sample_id::text = v_state_samplepoint.sample_id::text
             LEFT JOIN dma ON dma.dma_id = samplepoint.dma_id
          WHERE samplepoint.expl_id = selector_expl.expl_id AND selector_expl.cur_user = CURRENT_USER) sm
     JOIN selector_sector s USING (sector_id)
     LEFT JOIN selector_municipality m USING (muni_id)
  WHERE s.cur_user = CURRENT_USER AND (m.cur_user = CURRENT_USER OR sm.muni_id IS NULL);

-- dependent views
CREATE OR REPLACE VIEW v_plan_netscenario_arc
AS SELECT n.netscenario_id,
    n.arc_id,
    n.presszone_id,
    n.dma_id,
    n.the_geom,
    a.arccat_id,
    a.epa_type,
    a.state,
    a.state_type
   FROM config_param_user,
    plan_netscenario_arc n
   LEFT JOIN arc a USING (arc_id)
  WHERE config_param_user.cur_user::text = CURRENT_USER
  AND config_param_user.parameter::text = 'plan_netscenario_current'::text
  AND config_param_user.value::integer = n.netscenario_id;

CREATE OR REPLACE VIEW v_plan_netscenario_node
AS SELECT n.netscenario_id,
    n.node_id,
    n.presszone_id,
    n.staticpressure,
    n.dma_id,
    n.pattern_id,
    n.the_geom,
    nd.nodecat_id,
    cn.node_type,
    nd.epa_type,
    nd.state,
    nd.state_type
   FROM config_param_user,
   plan_netscenario_node n
     LEFT JOIN node nd USING (node_id)
     LEFT JOIN cat_node cn ON nd.nodecat_id::text = cn.id::text
  WHERE config_param_user.cur_user::text = CURRENT_USER
  AND config_param_user.parameter::text = 'plan_netscenario_current'::text
  AND config_param_user.value::integer = n.netscenario_id;

CREATE OR REPLACE VIEW v_plan_netscenario_connec
AS SELECT n.netscenario_id,
    n.connec_id,
    n.presszone_id,
    n.staticpressure,
    n.dma_id,
    n.pattern_id,
    n.the_geom,
    c.conneccat_id,
    cc.connec_type,
    c.epa_type,
    c.state,
    c.state_type
   FROM config_param_user,
   plan_netscenario_connec n
     LEFT JOIN connec c USING (connec_id)
     LEFT JOIN cat_connec cc ON cc.id::text = c.conneccat_id::text
  WHERE config_param_user.cur_user::text = CURRENT_USER
  AND config_param_user.parameter::text = 'plan_netscenario_current'::text
  AND config_param_user.value::integer = n.netscenario_id;

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

CREATE OR REPLACE VIEW v_price_x_catarc AS
  SELECT cat_arc.id,
    cat_arc.dint,
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
    d.arc_type,
    d.arccat_id,
    d.epa_type,
    d.state,
    d.sector_id,
    d.expl_id,
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
    d.total_budget,
    d.the_geom
   FROM ( WITH v_plan_aux_arc_cost AS (
                 WITH v_plan_aux_arc_ml AS (
                         SELECT v_edit_arc.arc_id,
                            v_edit_arc.depth1,
                            v_edit_arc.depth2,
                                CASE
                                    WHEN (v_edit_arc.depth1 * v_edit_arc.depth2) = 0::numeric OR (v_edit_arc.depth1 * v_edit_arc.depth2) IS NULL THEN v_price_x_catarc.estimated_depth
                                    ELSE ((v_edit_arc.depth1 + v_edit_arc.depth2) / 2::numeric)::numeric(12,2)
                                END AS mean_depth,
                            v_edit_arc.arccat_id,
                            COALESCE(v_price_x_catarc.dint / 1000::numeric, 0::numeric)::numeric(12,4) AS dint,
                            COALESCE(v_price_x_catarc.z1, 0::numeric)::numeric(12,2) AS z1,
                            COALESCE(v_price_x_catarc.z2, 0::numeric)::numeric(12,2) AS z2,
                            COALESCE(v_price_x_catarc.area, 0::numeric)::numeric(12,4) AS area,
                            COALESCE(v_price_x_catarc.width, 0::numeric)::numeric(12,2) AS width,
                            COALESCE(v_price_x_catarc.thickness / 1000::numeric, 0::numeric)::numeric(12,4) AS bulk,
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
                             LEFT JOIN v_plan_aux_arc_pavement ON v_plan_aux_arc_pavement.arc_id = v_edit_arc.arc_id
                          WHERE v_plan_aux_arc_pavement.arc_id IS NOT NULL
                        )
                 SELECT v_plan_aux_arc_ml.arc_id,
                    v_plan_aux_arc_ml.depth1,
                    v_plan_aux_arc_ml.depth2,
                    v_plan_aux_arc_ml.mean_depth,
                    v_plan_aux_arc_ml.arccat_id,
                    v_plan_aux_arc_ml.dint,
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
                    (2::numeric * ((v_plan_aux_arc_ml.mean_depth + v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.bulk) / v_plan_aux_arc_ml.y_param) + v_plan_aux_arc_ml.width + v_plan_aux_arc_ml.b * 2::numeric)::numeric(12,3) AS m2mlpavement,
                    (2::numeric * v_plan_aux_arc_ml.b + v_plan_aux_arc_ml.width)::numeric(12,3) AS m2mlbase,
                    (v_plan_aux_arc_ml.mean_depth + v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.bulk - v_plan_aux_arc_ml.thickness)::numeric(12,3) AS calculed_depth,
                    (v_plan_aux_arc_ml.trenchlining * 2::numeric * (v_plan_aux_arc_ml.mean_depth + v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.bulk - v_plan_aux_arc_ml.thickness))::numeric(12,3) AS m2mltrenchl,
                    ((v_plan_aux_arc_ml.mean_depth + v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.bulk - v_plan_aux_arc_ml.thickness) * (2::numeric * ((v_plan_aux_arc_ml.mean_depth + v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.bulk - v_plan_aux_arc_ml.thickness) / v_plan_aux_arc_ml.y_param) + v_plan_aux_arc_ml.width + v_plan_aux_arc_ml.b * 2::numeric + v_plan_aux_arc_ml.b * 2::numeric + v_plan_aux_arc_ml.width) / 2::numeric)::numeric(12,3) AS m3mlexc,
                    ((v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.dint + v_plan_aux_arc_ml.bulk * 2::numeric + v_plan_aux_arc_ml.z2) * ((2::numeric * ((v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.dint + v_plan_aux_arc_ml.bulk * 2::numeric + v_plan_aux_arc_ml.z2) / v_plan_aux_arc_ml.y_param) + v_plan_aux_arc_ml.width + v_plan_aux_arc_ml.b * 2::numeric + (v_plan_aux_arc_ml.b * 2::numeric + v_plan_aux_arc_ml.width)) / 2::numeric) - v_plan_aux_arc_ml.area)::numeric(12,3) AS m3mlprotec,
                    ((v_plan_aux_arc_ml.mean_depth + v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.bulk - v_plan_aux_arc_ml.thickness) * (2::numeric * ((v_plan_aux_arc_ml.mean_depth + v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.bulk - v_plan_aux_arc_ml.thickness) / v_plan_aux_arc_ml.y_param) + v_plan_aux_arc_ml.width + v_plan_aux_arc_ml.b * 2::numeric + v_plan_aux_arc_ml.b * 2::numeric + v_plan_aux_arc_ml.width) / 2::numeric - (v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.dint + v_plan_aux_arc_ml.bulk * 2::numeric + v_plan_aux_arc_ml.z2) * ((2::numeric * ((v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.dint + v_plan_aux_arc_ml.bulk * 2::numeric + v_plan_aux_arc_ml.z2) / v_plan_aux_arc_ml.y_param) + v_plan_aux_arc_ml.width + v_plan_aux_arc_ml.b * 2::numeric + (v_plan_aux_arc_ml.b * 2::numeric + v_plan_aux_arc_ml.width)) / 2::numeric))::numeric(12,3) AS m3mlfill,
                    ((v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.dint + v_plan_aux_arc_ml.bulk * 2::numeric + v_plan_aux_arc_ml.z2) * ((2::numeric * ((v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.dint + v_plan_aux_arc_ml.bulk * 2::numeric + v_plan_aux_arc_ml.z2) / v_plan_aux_arc_ml.y_param) + v_plan_aux_arc_ml.width + v_plan_aux_arc_ml.b * 2::numeric + (v_plan_aux_arc_ml.b * 2::numeric + v_plan_aux_arc_ml.width)) / 2::numeric))::numeric(12,3) AS m3mlexcess,
                    v_plan_aux_arc_ml.the_geom
                   FROM v_plan_aux_arc_ml
                  WHERE v_plan_aux_arc_ml.arc_id IS NOT NULL
                )
         SELECT v_plan_aux_arc_cost.arc_id,
            arc.node_1,
            arc.node_2,
            v_plan_aux_arc_cost.arccat_id AS arc_type,
            v_plan_aux_arc_cost.arccat_id,
            arc.epa_type,
            v_plan_aux_arc_cost.state,
            arc.sector_id,
            v_plan_aux_arc_cost.expl_id,
            arc.annotation,
            v_plan_aux_arc_cost.soilcat_id,
            v_plan_aux_arc_cost.depth1 AS y1,
            v_plan_aux_arc_cost.depth2 AS y2,
            v_plan_aux_arc_cost.mean_depth AS mean_y,
            v_plan_aux_arc_cost.z1,
            v_plan_aux_arc_cost.z2,
            v_plan_aux_arc_cost.thickness,
            v_plan_aux_arc_cost.width,
            v_plan_aux_arc_cost.b,
            v_plan_aux_arc_cost.bulk,
            v_plan_aux_arc_cost.dint AS geom1,
            v_plan_aux_arc_cost.area,
            v_plan_aux_arc_cost.y_param,
            (v_plan_aux_arc_cost.calculed_depth + v_plan_aux_arc_cost.thickness)::numeric(12,2) AS total_y,
            (v_plan_aux_arc_cost.calculed_depth - 2::numeric * v_plan_aux_arc_cost.bulk - v_plan_aux_arc_cost.z1 - v_plan_aux_arc_cost.z2 - v_plan_aux_arc_cost.dint)::numeric(12,2) AS rec_y,
            (v_plan_aux_arc_cost.dint + 2::numeric * v_plan_aux_arc_cost.bulk)::numeric(12,2) AS geom1_ext,
            v_plan_aux_arc_cost.calculed_depth AS calculed_y,
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
            v_plan_aux_arc_connec.connec_total_cost AS other_budget,
                CASE
                    WHEN v_plan_aux_arc_cost.cost_unit::text = 'u'::text THEN v_plan_aux_arc_cost.arc_cost +
                    CASE
                        WHEN v_plan_aux_arc_connec.connec_total_cost IS NULL THEN 0::numeric
                        ELSE v_plan_aux_arc_connec.connec_total_cost
                    END
                    ELSE st_length2d(v_plan_aux_arc_cost.the_geom)::numeric(12,2) * (v_plan_aux_arc_cost.m3mlexc * v_plan_aux_arc_cost.m3exc_cost + v_plan_aux_arc_cost.m2mlbase * v_plan_aux_arc_cost.m2bottom_cost + v_plan_aux_arc_cost.m2mltrenchl * v_plan_aux_arc_cost.m2trenchl_cost + v_plan_aux_arc_cost.m3mlprotec * v_plan_aux_arc_cost.m3protec_cost + v_plan_aux_arc_cost.m3mlfill * v_plan_aux_arc_cost.m3fill_cost + v_plan_aux_arc_cost.m3mlexcess * v_plan_aux_arc_cost.m3excess_cost + v_plan_aux_arc_cost.m2mlpavement * v_plan_aux_arc_cost.m2pav_cost + v_plan_aux_arc_cost.arc_cost)::numeric(14,2) +
                    CASE
                        WHEN v_plan_aux_arc_connec.connec_total_cost IS NULL THEN 0::numeric
                        ELSE v_plan_aux_arc_connec.connec_total_cost
                    END
                END::numeric(14,2) AS total_budget,
            v_plan_aux_arc_cost.the_geom
           FROM v_plan_aux_arc_cost
             JOIN arc ON arc.arc_id = v_plan_aux_arc_cost.arc_id
             LEFT JOIN ( SELECT DISTINCT ON (c.arc_id) c.arc_id,
                    (p.price * count(*)::numeric)::numeric(12,2) AS connec_total_cost
                   FROM v_edit_connec c
                     JOIN arc arc_1 USING (arc_id)
                     JOIN cat_arc ON cat_arc.id::text = arc_1.arccat_id::text
                     LEFT JOIN v_price_compost p ON cat_arc.connect_cost = p.id::text
                  WHERE c.arc_id IS NOT NULL
                  GROUP BY c.arc_id, p.price) v_plan_aux_arc_connec ON v_plan_aux_arc_connec.arc_id = v_plan_aux_arc_cost.arc_id) d
  WHERE d.arc_id IS NOT NULL;

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
    element.created_at,
    element.created_by,
    element.updated_at,
    element.updated_by
   FROM element_x_arc
     JOIN element ON element.element_id = element_x_arc.element_id
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
    element.created_at,
    element.created_by,
    element.updated_at,
    element.updated_by
   FROM element_x_connec
     JOIN element ON element.element_id = element_x_connec.element_id
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
    element.created_at,
    element.created_by,
    element.updated_at,
    element.updated_by
   FROM element_x_node
     JOIN element ON element.element_id = element_x_node.element_id
     JOIN value_state ON element.state = value_state.id
     LEFT JOIN value_state_type ON element.state_type = value_state_type.id
     LEFT JOIN man_type_location ON man_type_location.location_type::text = element.location_type::text AND man_type_location.feature_type::text = 'ELEMENT'::text
     LEFT JOIN cat_element ON cat_element.id::text = element.elementcat_id::text;

CREATE OR REPLACE VIEW vu_element_x_link
AS SELECT
    element_x_link.link_id,
    element_x_link.element_id,
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
    element.created_at,
    element.created_by,
    element.updated_at,
    element.updated_by
   FROM element_x_link
     JOIN element ON element.element_id = element_x_link.element_id
     JOIN value_state ON element.state = value_state.id
     LEFT JOIN value_state_type ON element.state_type = value_state_type.id
     LEFT JOIN man_type_location ON man_type_location.location_type::text = element.location_type::text AND man_type_location.feature_type::text = 'ELEMENT'::text
     LEFT JOIN cat_element ON cat_element.id::text = element.elementcat_id::text;

CREATE OR REPLACE VIEW v_ui_arc_x_relations
AS WITH links_node AS (
         SELECT n.node_id,
            l.feature_id,
            l.exit_type AS proceed_from,
            l.exit_id AS proceed_from_id,
            l.state AS l_state,
            n.state AS n_state
           FROM node n
             JOIN link l ON n.node_id = l.exit_id
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
     JOIN link l ON v_edit_connec.connec_id = l.feature_id
     JOIN arc a ON a.arc_id = v_edit_connec.arc_id
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
     JOIN links_node n ON a.node_1 = n.node_id
     JOIN v_edit_connec c ON c.connec_id = n.feature_id;

CREATE OR REPLACE VIEW v_ui_arc_x_node
AS SELECT v_edit_arc.arc_id,
    v_edit_arc.node_1,
    st_x(a.the_geom) AS x1,
    st_y(a.the_geom) AS y1,
    v_edit_arc.node_2,
    st_x(b.the_geom) AS x2,
    st_y(b.the_geom) AS y2
   FROM v_edit_arc
     LEFT JOIN node a ON a.node_id = v_edit_arc.node_1
     LEFT JOIN node b ON b.node_id = v_edit_arc.node_2;

CREATE OR REPLACE VIEW v_ui_node_x_relations AS
SELECT row_number() OVER (ORDER BY v_edit_node.node_id) AS rid,
    v_edit_node.parent_id AS node_id,
    v_edit_node.node_type,
    v_edit_node.nodecat_id,
    v_edit_node.node_id AS child_id,
    v_edit_node.code,
    v_edit_node.sys_type,
    'v_edit_node'::text AS sys_table_id
   FROM v_edit_node
  WHERE v_edit_node.parent_id IS NOT NULL;

CREATE OR REPLACE VIEW v_rtc_period_hydrometer
AS SELECT ext_rtc_hydrometer.id AS hydrometer_id,
    v_edit_connec.connec_id,
    NULL::int4 AS pjoint_id,
    temp_arc.node_1::int4,
    temp_arc.node_2::int4,
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
     JOIN v_edit_connec ON v_edit_connec.connec_id = rtc_hydrometer_x_connec.connec_id
     JOIN temp_arc ON v_edit_connec.arc_id::text = temp_arc.arc_id
     JOIN ext_rtc_dma_period c ON c.cat_period_id::text = ext_cat_period.id::text AND c.dma_id::integer = v_edit_connec.dma_id
  WHERE ext_cat_period.id::text = (( SELECT config_param_user.value
           FROM config_param_user
          WHERE config_param_user.cur_user::name = "current_user"() AND config_param_user.parameter::text = 'inp_options_rtc_period_id'::text))
UNION
 SELECT ext_rtc_hydrometer.id AS hydrometer_id,
    v_edit_connec.connec_id,
    temp_node.node_id::int4 AS pjoint_id,
    NULL::int4 AS node_1,
    NULL::int4 AS node_2,
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
     LEFT JOIN v_edit_connec ON v_edit_connec.connec_id = rtc_hydrometer_x_connec.connec_id
     JOIN temp_node ON concat('VN', v_edit_connec.pjoint_id) = temp_node.node_id::text
     JOIN ext_rtc_dma_period c ON c.cat_period_id::text = ext_cat_period.id::text AND v_edit_connec.dma_id::text = c.dma_id::text
  WHERE v_edit_connec.pjoint_type::text = 'VNODE'::text AND ext_cat_period.id::text = (( SELECT config_param_user.value
           FROM config_param_user
          WHERE config_param_user.cur_user::name = "current_user"() AND config_param_user.parameter::text = 'inp_options_rtc_period_id'::text))
UNION
 SELECT ext_rtc_hydrometer.id AS hydrometer_id,
    v_edit_connec.connec_id,
    temp_node.node_id::int4 AS pjoint_id,
    NULL::int4 AS node_1,
    NULL::int4 AS node_2,
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
     LEFT JOIN v_edit_connec ON v_edit_connec.connec_id = rtc_hydrometer_x_connec.connec_id
     JOIN temp_node ON v_edit_connec.pjoint_id::text = temp_node.node_id::text
     JOIN ext_rtc_dma_period c ON c.cat_period_id::text = ext_cat_period.id::text AND v_edit_connec.dma_id::text = c.dma_id::text
  WHERE v_edit_connec.pjoint_type::text = 'NODE'::text AND ext_cat_period.id::text = (( SELECT config_param_user.value
           FROM config_param_user
          WHERE config_param_user.cur_user::name = "current_user"() AND config_param_user.parameter::text = 'inp_options_rtc_period_id'::text));

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
            v_edit_node.custom_top_elev,
            v_edit_node.top_elev - v_edit_node.depth AS elev,
            v_edit_node.epa_type,
            v_edit_node.state,
            v_edit_node.sector_id,
            v_edit_node.expl_id,
            v_edit_node.annotation,
            v_price_x_catnode.cost_unit,
            v_price_compost.descript,
            v_price_compost.price AS cost,
                CASE
                    WHEN v_price_x_catnode.cost_unit::text = 'u'::text THEN
                    CASE
                        WHEN v_edit_node.sys_type::text = 'PUMP'::text THEN
                        CASE
                            WHEN man_pump.pump_number IS NOT NULL THEN man_pump.pump_number
                            ELSE 1
                        END
                        ELSE 1
                    END::numeric
                    WHEN v_price_x_catnode.cost_unit::text = 'm3'::text THEN
                    CASE
                        WHEN v_edit_node.sys_type::text = 'TANK'::text THEN man_tank.vmax
                        ELSE NULL::numeric
                    END
                    WHEN v_price_x_catnode.cost_unit::text = 'm'::text THEN
                    CASE
                        WHEN v_edit_node.depth = 0::numeric THEN v_price_x_catnode.estimated_depth
                        WHEN v_edit_node.depth IS NULL THEN v_price_x_catnode.estimated_depth
                        ELSE v_edit_node.depth
                    END
                    ELSE NULL::numeric
                END::numeric(12,2) AS measurement,
                CASE
                    WHEN v_price_x_catnode.cost_unit::text = 'u'::text THEN
                    CASE
                        WHEN v_edit_node.sys_type::text = 'PUMP'::text THEN
                        CASE
                            WHEN man_pump.pump_number IS NOT NULL THEN man_pump.pump_number
                            ELSE 1
                        END
                        ELSE 1
                    END::numeric * v_price_x_catnode.cost
                    WHEN v_price_x_catnode.cost_unit::text = 'm3'::text THEN
                    CASE
                        WHEN v_edit_node.sys_type::text = 'TANK'::text THEN man_tank.vmax
                        ELSE NULL::numeric
                    END * v_price_x_catnode.cost
                    WHEN v_price_x_catnode.cost_unit::text = 'm'::text THEN
                    CASE
                        WHEN v_edit_node.depth = 0::numeric THEN v_price_x_catnode.estimated_depth
                        WHEN v_edit_node.depth IS NULL THEN v_price_x_catnode.estimated_depth
                        ELSE v_edit_node.depth
                    END * v_price_x_catnode.cost
                    ELSE NULL::numeric
                END::numeric(12,2) AS budget,
            v_edit_node.the_geom
           FROM v_edit_node
             LEFT JOIN v_price_x_catnode ON v_edit_node.nodecat_id::text = v_price_x_catnode.id::text
             LEFT JOIN man_tank ON man_tank.node_id = v_edit_node.node_id
             LEFT JOIN man_pump ON man_pump.node_id = v_edit_node.node_id
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
     JOIN v_plan_node ON node.node_id = v_plan_node.node_id;

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
  WHERE plan_rec_result_node.expl_id = selector_expl.expl_id AND selector_expl.cur_user = CURRENT_USER AND plan_rec_result_node.result_id::text = selector_plan_result.result_id::text AND selector_plan_result.cur_user = CURRENT_USER AND plan_rec_result_node.state = 1
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


CREATE OR REPLACE VIEW v_edit_inp_junction
AS SELECT n.node_id,
    n.top_elev,
    n.custom_top_elev,
    n.depth,
    n.nodecat_id,
    n.expl_id,
    n.sector_id,
    n.dma_id,
    n.state,
    n.state_type,
    n.annotation,
    inp_junction.demand,
    inp_junction.pattern_id,
    inp_junction.peak_factor,
    inp_junction.emitter_coeff,
    inp_junction.init_quality,
    inp_junction.source_type,
    inp_junction.source_quality,
    inp_junction.source_pattern_id,
    n.the_geom
   FROM v_edit_node n
   JOIN inp_junction USING (node_id)
   WHERE n.is_operative IS TRUE;

CREATE OR REPLACE VIEW v_edit_inp_dscenario_junction
AS SELECT p.dscenario_id,
    p.node_id,
    p.demand,
    p.pattern_id,
    p.emitter_coeff,
    p.init_quality,
    p.source_type,
    p.source_quality,
    p.source_pattern_id,
    n.the_geom
    FROM selector_inp_dscenario, v_edit_node n
    JOIN inp_dscenario_junction p USING (node_id)
    JOIN cat_dscenario d USING (dscenario_id)
    WHERE p.dscenario_id = selector_inp_dscenario.dscenario_id AND selector_inp_dscenario.cur_user = CURRENT_USER
	AND n.is_operative IS TRUE;

CREATE OR REPLACE VIEW v_edit_inp_pump
AS SELECT n.node_id,
    n.top_elev,
    n.custom_top_elev,
    n.depth,
    n.nodecat_id,
    n.expl_id,
    n.sector_id,
    n.dma_id,
    n.state,
    n.state_type,
    n.annotation,
    concat(n.node_id, '_n2a') AS nodarc_id,
    inp_pump.power,
    inp_pump.curve_id,
    inp_pump.speed,
    inp_pump.pattern_id,
    man_pump.to_arc,
    inp_pump.status,
    inp_pump.pump_type,
    inp_pump.effic_curve_id,
    inp_pump.energy_price,
    inp_pump.energy_pattern_id,
    n.the_geom
	FROM v_edit_node n
	JOIN inp_pump USING (node_id)
	JOIN man_pump USING (node_id)
	WHERE n.is_operative IS TRUE;

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
    a.builtdate,
    inp_pipe.custom_roughness,
    a.cat_dint,
    inp_pipe.custom_dint,
    inp_pipe.bulk_coeff,
    inp_pipe.wall_coeff,
    a.the_geom
   FROM v_edit_arc a
     JOIN inp_pipe USING (arc_id)
  WHERE a.is_operative IS TRUE;

CREATE OR REPLACE VIEW v_rpt_node_stats
AS SELECT r.node_id,
    r.result_id,
    r.node_type,
    r.sector_id,
    r.nodecat_id,
    r.top_elev,
    r.demand_max,
    r.demand_min,
    r.demand_avg,
    r.head_max,
    r.head_min,
    r.head_avg,
    r.press_max,
    r.press_min,
    r.press_avg,
    r.quality_max,
    r.quality_min,
    r.quality_avg,
    r.the_geom
   FROM rpt_node_stats r,
    selector_rpt_main s
  WHERE r.result_id::text = s.result_id::text AND s.cur_user = CURRENT_USER;

CREATE OR REPLACE VIEW v_rpt_node
AS SELECT rpt_node.id,
    node.node_id,
    node.node_type,
    node.sector_id,
    node.nodecat_id,
    selector_rpt_main.result_id,
    rpt_node.top_elev,
    rpt_node.demand,
    rpt_node.head,
    rpt_node.press,
    rpt_node.quality,
    '2001-01-01'::date + rpt_node."time"::interval AS "time",
    node.the_geom
   FROM selector_rpt_main,
    rpt_inp_node node
     JOIN rpt_node ON rpt_node.node_id::text = node.node_id
  WHERE rpt_node.result_id::text = selector_rpt_main.result_id::text AND selector_rpt_main.cur_user = CURRENT_USER AND node.result_id::text = selector_rpt_main.result_id::text
  ORDER BY rpt_node.press, node.node_id;

CREATE OR REPLACE VIEW v_rpt_arc_stats
AS SELECT r.arc_id,
    r.result_id,
    r.arc_type,
    r.sector_id,
    r.arccat_id,
    r.flow_max,
    r.flow_min,
    r.flow_avg,
    r.vel_max,
    r.vel_min,
    r.vel_avg,
    r.headloss_max,
    r.headloss_min,
    r.setting_max,
    r.setting_min,
    r.reaction_max,
    r.reaction_min,
    r.ffactor_max,
    r.ffactor_min,
    r.length,
    r.tot_headloss_max,
    r.tot_headloss_min,
    r.the_geom
   FROM rpt_arc_stats r,
    selector_rpt_main s
  WHERE r.result_id::text = s.result_id::text AND s.cur_user = CURRENT_USER;

CREATE OR REPLACE VIEW v_rpt_arc
AS SELECT rpt_arc.id,
    arc.arc_id,
    selector_rpt_main.result_id,
    arc.arc_type,
    arc.sector_id,
    arc.arccat_id,
    rpt_arc.flow,
    rpt_arc.vel,
    rpt_arc.headloss,
    rpt_arc.setting,
    rpt_arc.ffactor,
    now()::date + rpt_arc."time"::interval AS "time",
    rpt_arc.length,
    rpt_arc.headloss * rpt_arc.length / 1000 AS tot_headloss,
    arc.the_geom
   FROM selector_rpt_main,
   rpt_inp_arc arc
   JOIN rpt_arc ON rpt_arc.arc_id::text = arc.arc_id
   WHERE rpt_arc.result_id::text = selector_rpt_main.result_id::text AND selector_rpt_main.cur_user = CURRENT_USER AND arc.result_id::text = selector_rpt_main.result_id::text
   ORDER BY rpt_arc.setting, arc.arc_id;


CREATE OR REPLACE VIEW ve_epa_junction
AS SELECT inp_junction.node_id,
    inp_junction.demand,
    inp_junction.pattern_id,
    inp_junction.peak_factor,
    inp_junction.emitter_coeff,
    inp_junction.init_quality,
    inp_junction.source_type,
    inp_junction.source_quality,
    inp_junction.source_pattern_id,
    v_rpt_node_stats.result_id,
    v_rpt_node_stats.demand_max AS demandmax,
    v_rpt_node_stats.demand_min AS demandmin,
    v_rpt_node_stats.demand_avg AS demandavg,
    v_rpt_node_stats.head_max AS headmax,
    v_rpt_node_stats.head_min AS headmin,
    v_rpt_node_stats.head_avg AS headavg,
    v_rpt_node_stats.press_max AS pressmax,
    v_rpt_node_stats.press_min AS pressmin,
    v_rpt_node_stats.press_avg AS pressavg,
    v_rpt_node_stats.quality_max AS qualmax,
    v_rpt_node_stats.quality_min AS qualmin,
    v_rpt_node_stats.quality_avg AS qualavg
   FROM inp_junction
     LEFT JOIN v_rpt_node_stats ON inp_junction.node_id::text = v_rpt_node_stats.node_id;

CREATE OR REPLACE VIEW ve_epa_tank
AS SELECT inp_tank.node_id,
    inp_tank.initlevel,
    inp_tank.minlevel,
    inp_tank.maxlevel,
    inp_tank.diameter,
    inp_tank.minvol,
    inp_tank.curve_id,
    inp_tank.overflow,
    inp_tank.mixing_model,
    inp_tank.mixing_fraction,
    inp_tank.reaction_coeff,
    inp_tank.init_quality,
    inp_tank.source_type,
    inp_tank.source_quality,
    inp_tank.source_pattern_id,
    v_rpt_node_stats.result_id,
    v_rpt_node_stats.demand_max AS demandmax,
    v_rpt_node_stats.demand_min AS demandmin,
    v_rpt_node_stats.demand_avg AS demandavg,
    v_rpt_node_stats.head_max AS headmax,
    v_rpt_node_stats.head_min AS headmin,
    v_rpt_node_stats.head_avg AS headavg,
    v_rpt_node_stats.press_max AS pressmax,
    v_rpt_node_stats.press_min AS pressmin,
    v_rpt_node_stats.press_avg AS pressavg,
    v_rpt_node_stats.quality_max AS qualmax,
    v_rpt_node_stats.quality_min AS qualmin,
    v_rpt_node_stats.quality_avg AS qualavg
   FROM inp_tank
     LEFT JOIN v_rpt_node_stats ON inp_tank.node_id::text = v_rpt_node_stats.node_id;

CREATE OR REPLACE VIEW ve_epa_reservoir
AS SELECT inp_reservoir.node_id,
    inp_reservoir.pattern_id,
    inp_reservoir.head,
    inp_reservoir.init_quality,
    inp_reservoir.source_type,
    inp_reservoir.source_quality,
    inp_reservoir.source_pattern_id,
    v_rpt_node_stats.result_id,
    v_rpt_node_stats.demand_max AS demandmax,
    v_rpt_node_stats.demand_min AS demandmin,
    v_rpt_node_stats.demand_avg AS demandavg,
    v_rpt_node_stats.head_max AS headmax,
    v_rpt_node_stats.head_min AS headmin,
    v_rpt_node_stats.head_avg AS headavg,
    v_rpt_node_stats.press_max AS pressmax,
    v_rpt_node_stats.press_min AS pressmin,
    v_rpt_node_stats.press_avg AS pressavg,
    v_rpt_node_stats.quality_max AS qualmax,
    v_rpt_node_stats.quality_min AS qualmin,
    v_rpt_node_stats.quality_avg AS qualavg
   FROM inp_reservoir
     LEFT JOIN v_rpt_node_stats ON inp_reservoir.node_id::text = v_rpt_node_stats.node_id;

CREATE OR REPLACE VIEW ve_epa_connec
AS SELECT inp_connec.connec_id,
    inp_connec.demand,
    inp_connec.pattern_id,
    inp_connec.peak_factor,
    inp_connec.custom_roughness,
    inp_connec.custom_length,
    inp_connec.custom_dint,
    inp_connec.status,
    inp_connec.minorloss,
    inp_connec.emitter_coeff,
    inp_connec.init_quality,
    inp_connec.source_type,
    inp_connec.source_quality,
    inp_connec.source_pattern_id,
    v_rpt_node_stats.result_id,
    v_rpt_node_stats.demand_max AS demandmax,
    v_rpt_node_stats.demand_min AS demandmin,
    v_rpt_node_stats.demand_avg AS demandavg,
    v_rpt_node_stats.head_max AS headmax,
    v_rpt_node_stats.head_min AS headmin,
    v_rpt_node_stats.head_avg AS headavg,
    v_rpt_node_stats.press_max AS pressmax,
    v_rpt_node_stats.press_min AS pressmin,
    v_rpt_node_stats.press_avg AS pressavg,
    v_rpt_node_stats.quality_max AS qualmax,
    v_rpt_node_stats.quality_min AS qualmin,
    v_rpt_node_stats.quality_avg AS qualavg
   FROM inp_connec
     LEFT JOIN v_rpt_node_stats ON inp_connec.connec_id::text = v_rpt_node_stats.node_id;

CREATE OR REPLACE VIEW ve_epa_inlet
AS SELECT inp_inlet.node_id,
    inp_inlet.initlevel,
    inp_inlet.minlevel,
    inp_inlet.maxlevel,
    inp_inlet.diameter,
    inp_inlet.minvol,
    inp_inlet.curve_id,
    inp_inlet.pattern_id,
    inp_inlet.overflow,
    inp_inlet.head,
    inp_inlet.mixing_model,
    inp_inlet.mixing_fraction,
    inp_inlet.reaction_coeff,
    inp_inlet.init_quality,
    inp_inlet.source_type,
    inp_inlet.source_quality,
    inp_inlet.source_pattern_id,
    inp_inlet.demand,
    inp_inlet.demand_pattern_id,
    inp_inlet.emitter_coeff,
    v_rpt_node_stats.result_id,
    v_rpt_node_stats.demand_max AS demandmax,
    v_rpt_node_stats.demand_min AS demandmin,
    v_rpt_node_stats.demand_avg AS demandavg,
    v_rpt_node_stats.head_max AS headmax,
    v_rpt_node_stats.head_min AS headmin,
    v_rpt_node_stats.head_avg AS headavg,
    v_rpt_node_stats.press_max AS pressmax,
    v_rpt_node_stats.press_min AS pressmin,
    v_rpt_node_stats.press_avg AS pressavg,
    v_rpt_node_stats.quality_max AS qualmax,
    v_rpt_node_stats.quality_min AS qualmin,
    v_rpt_node_stats.quality_avg AS qualavg
   FROM inp_inlet
     LEFT JOIN v_rpt_node_stats ON inp_inlet.node_id::text = v_rpt_node_stats.node_id;

CREATE OR REPLACE VIEW ve_epa_pump
AS SELECT inp_pump.node_id,
    inp_pump.power,
    inp_pump.curve_id,
    inp_pump.speed,
    inp_pump.pattern_id,
    inp_pump.status,
    p.to_arc,
    inp_pump.energyparam,
    inp_pump.energyvalue,
    inp_pump.pump_type,
    inp_pump.effic_curve_id,
    inp_pump.energy_price,
    inp_pump.energy_pattern_id,
    concat(inp_pump.node_id, '_n2a') AS nodarc_id,
    v_rpt_arc_stats.result_id,
    v_rpt_arc_stats.flow_max AS flowmax,
    v_rpt_arc_stats.flow_min AS flowmin,
    v_rpt_arc_stats.flow_avg AS flowavg,
    v_rpt_arc_stats.vel_max AS velmax,
    v_rpt_arc_stats.vel_min AS velmin,
    v_rpt_arc_stats.vel_avg AS velavg,
    v_rpt_arc_stats.headloss_max,
    v_rpt_arc_stats.headloss_min,
    v_rpt_arc_stats.setting_max,
    v_rpt_arc_stats.setting_min,
    v_rpt_arc_stats.reaction_max,
    v_rpt_arc_stats.reaction_min,
    v_rpt_arc_stats.ffactor_max,
    v_rpt_arc_stats.ffactor_min
   FROM inp_pump
     LEFT JOIN v_rpt_arc_stats ON concat(inp_pump.node_id, '_n2a') = v_rpt_arc_stats.arc_id::text
     LEFT JOIN man_pump p ON p.node_id = inp_pump.node_id;

CREATE OR REPLACE VIEW ve_epa_pump_additional
AS SELECT inp_pump_additional.id,
    inp_pump_additional.node_id,
    inp_pump_additional.order_id,
    inp_pump_additional.power,
    inp_pump_additional.curve_id,
    inp_pump_additional.speed,
    inp_pump_additional.pattern_id,
    inp_pump_additional.status,
    inp_pump_additional.energyparam,
    inp_pump_additional.energyvalue,
    inp_pump_additional.effic_curve_id,
    inp_pump_additional.energy_price,
    inp_pump_additional.energy_pattern_id,
    concat(inp_pump_additional.node_id, '_n2a') AS nodarc_id,
    v_rpt_arc_stats.result_id,
    v_rpt_arc_stats.flow_max AS flowmax,
    v_rpt_arc_stats.flow_min AS flowmin,
    v_rpt_arc_stats.flow_avg AS flowavg,
    v_rpt_arc_stats.vel_max AS velmax,
    v_rpt_arc_stats.vel_min AS velmin,
    v_rpt_arc_stats.vel_avg AS velavg,
    v_rpt_arc_stats.headloss_max,
    v_rpt_arc_stats.headloss_min,
    v_rpt_arc_stats.setting_max,
    v_rpt_arc_stats.setting_min,
    v_rpt_arc_stats.reaction_max,
    v_rpt_arc_stats.reaction_min,
    v_rpt_arc_stats.ffactor_max,
    v_rpt_arc_stats.ffactor_min
   FROM inp_pump_additional
     LEFT JOIN v_rpt_arc_stats ON concat(inp_pump_additional.node_id, '_n2a', inp_pump_additional.order_id) = v_rpt_arc_stats.arc_id::text;

CREATE OR REPLACE VIEW ve_epa_valve
AS SELECT inp_valve.node_id,
    inp_valve.valve_type,
    cat_node.dint,
    inp_valve.custom_dint,
    inp_valve.setting,
    inp_valve.curve_id,
    inp_valve.minorloss,
    v.to_arc,
    CASE
      WHEN v.to_arc IS NOT NULL AND v.closed IS FALSE THEN 'ACTIVE'::character varying(12)
      WHEN v.closed IS TRUE THEN 'CLOSED'::character varying(12)
      WHEN v.closed IS FALSE THEN 'OPEN'::character varying(12)
      ELSE NULL::character varying(12)
    END AS status,
    inp_valve.add_settings,
    inp_valve.init_quality,
    concat(inp_valve.node_id, '_n2a') AS nodarc_id,
    v_rpt_arc_stats.result_id,
    v_rpt_arc_stats.flow_max AS flowmax,
    v_rpt_arc_stats.flow_min AS flowmin,
    v_rpt_arc_stats.flow_avg AS flowavg,
    v_rpt_arc_stats.vel_max AS velmax,
    v_rpt_arc_stats.vel_min AS velmin,
    v_rpt_arc_stats.vel_avg AS velavg,
    v_rpt_arc_stats.headloss_max,
    v_rpt_arc_stats.headloss_min,
    v_rpt_arc_stats.setting_max,
    v_rpt_arc_stats.setting_min,
    v_rpt_arc_stats.reaction_max,
    v_rpt_arc_stats.reaction_min,
    v_rpt_arc_stats.ffactor_max,
    v_rpt_arc_stats.ffactor_min
   FROM node
     JOIN inp_valve USING (node_id)
      LEFT JOIN cat_node ON cat_node.id = node.nodecat_id
     LEFT JOIN v_rpt_arc_stats ON concat(inp_valve.node_id, '_n2a') = v_rpt_arc_stats.arc_id::text
     LEFT JOIN man_valve v ON v.node_id = inp_valve.node_id;

CREATE OR REPLACE VIEW ve_epa_shortpipe
AS SELECT inp_shortpipe.node_id,
    inp_shortpipe.minorloss,
    cat_node.dint,
    inp_shortpipe.custom_dint,
    v.to_arc,
    CASE
      WHEN v.to_arc IS NOT NULL AND v.closed IS FALSE THEN 'CV'::character varying(12)
      WHEN v.closed IS TRUE THEN 'CLOSED'::character varying(12)
      WHEN v.closed IS FALSE THEN 'OPEN'::character varying(12)
      ELSE NULL::character varying(12)
    END AS status,
    inp_shortpipe.bulk_coeff,
    inp_shortpipe.wall_coeff,
    concat(inp_shortpipe.node_id, '_n2a') AS nodarc_id,
    v_rpt_arc_stats.result_id,
    v_rpt_arc_stats.flow_max AS flowmax,
    v_rpt_arc_stats.flow_min AS flowmin,
    v_rpt_arc_stats.flow_avg AS flowavg,
    v_rpt_arc_stats.vel_max AS velmax,
    v_rpt_arc_stats.vel_min AS velmin,
    v_rpt_arc_stats.vel_avg AS velavg,
    v_rpt_arc_stats.headloss_max,
    v_rpt_arc_stats.headloss_min,
    v_rpt_arc_stats.setting_max,
    v_rpt_arc_stats.setting_min,
    v_rpt_arc_stats.reaction_max,
    v_rpt_arc_stats.reaction_min,
    v_rpt_arc_stats.ffactor_max,
    v_rpt_arc_stats.ffactor_min
   FROM node
    LEFT JOIN cat_node ON cat_node.id = node.nodecat_id
     JOIN inp_shortpipe USING (node_id)
     LEFT JOIN v_rpt_arc_stats ON concat(inp_shortpipe.node_id, '_n2a') = v_rpt_arc_stats.arc_id::text
     LEFT JOIN man_valve v ON v.node_id = inp_shortpipe.node_id;

CREATE OR REPLACE VIEW ve_epa_pipe AS
 SELECT inp_pipe.arc_id,
    inp_pipe.minorloss,
    inp_pipe.status,
    cat_arc.matcat_id,
    a.builtdate,
    r.roughness AS cat_roughness,
    inp_pipe.custom_roughness,
	  cat_arc.dint,
    inp_pipe.custom_dint,
    inp_pipe.reactionparam,
    inp_pipe.reactionvalue,
    inp_pipe.bulk_coeff,
    inp_pipe.wall_coeff,
    v_rpt_arc_stats.result_id,
    v_rpt_arc_stats.flow_max,
    v_rpt_arc_stats.flow_min,
    v_rpt_arc_stats.flow_avg,
    v_rpt_arc_stats.vel_max,
    v_rpt_arc_stats.vel_min,
    v_rpt_arc_stats.vel_avg,
    v_rpt_arc_stats.headloss_max,
    v_rpt_arc_stats.headloss_min,
    v_rpt_arc_stats.setting_max,
    v_rpt_arc_stats.setting_min,
    v_rpt_arc_stats.reaction_max,
    v_rpt_arc_stats.reaction_min,
    v_rpt_arc_stats.ffactor_max,
    v_rpt_arc_stats.ffactor_min,
    v_rpt_arc_stats.tot_headloss_max,
    v_rpt_arc_stats.tot_headloss_min
   FROM arc a
      LEFT JOIN cat_arc ON cat_arc.id = a.arccat_id
     JOIN inp_pipe USING (arc_id)
     LEFT JOIN v_rpt_arc_stats ON split_part(v_rpt_arc_stats.arc_id::text, 'P'::text, 1) = inp_pipe.arc_id::text
  LEFT JOIN cat_mat_roughness r ON cat_arc.matcat_id::text = r.matcat_id::text
  WHERE ((now()::date -
        CASE
            WHEN a.builtdate IS NULL THEN '1900-01-01'::date
            ELSE a.builtdate
        END) / 365) >= r.init_age AND ((now()::date -
        CASE
            WHEN a.builtdate IS NULL THEN '1900-01-01'::date
            ELSE a.builtdate
        END) / 365) < r.end_age AND r.active IS TRUE;

CREATE OR REPLACE VIEW v_edit_inp_dscenario_demand
AS SELECT inp_dscenario_demand.id,
    inp_dscenario_demand.dscenario_id,
    inp_dscenario_demand.feature_id,
    inp_dscenario_demand.feature_type,
    inp_dscenario_demand.demand,
    inp_dscenario_demand.pattern_id,
    inp_dscenario_demand.demand_type,
    inp_dscenario_demand.source,
    node.sector_id,
    node.expl_id,
    node.presszone_id,
    node.dma_id,
    node.the_geom
   FROM inp_dscenario_demand
     JOIN node ON node.node_id = inp_dscenario_demand.feature_id
     JOIN selector_sector s ON s.sector_id = node.sector_id
     JOIN selector_inp_dscenario d USING (dscenario_id)
  WHERE s.cur_user = CURRENT_USER AND d.cur_user = CURRENT_USER
UNION
 SELECT inp_dscenario_demand.id,
    inp_dscenario_demand.dscenario_id,
    inp_dscenario_demand.feature_id,
    inp_dscenario_demand.feature_type,
    inp_dscenario_demand.demand,
    inp_dscenario_demand.pattern_id,
    inp_dscenario_demand.demand_type,
    inp_dscenario_demand.source,
    connec.sector_id,
    connec.expl_id,
    connec.presszone_id,
    connec.dma_id,
    connec.the_geom
   FROM inp_dscenario_demand
     JOIN connec ON connec.connec_id = inp_dscenario_demand.feature_id
     JOIN selector_sector s ON s.sector_id = connec.sector_id
     JOIN selector_inp_dscenario d USING (dscenario_id)
  WHERE s.cur_user = CURRENT_USER AND d.cur_user = CURRENT_USER;

CREATE OR REPLACE VIEW v_edit_inp_virtualpump
AS SELECT a.arc_id,
    a.node_1,
    a.node_2,
    a.arccat_id,
    a.sector_id,
    a.state,
    a.state_type,
    a.annotation,
    a.expl_id,
    a.dma_id,
    p.power,
    p.curve_id,
    p.speed,
    p.pattern_id,
    p.status,
    p.effic_curve_id,
    p.energy_price,
    p.energy_pattern_id,
    p.pump_type,
    a.the_geom
    FROM v_edit_arc a
    JOIN inp_virtualpump p USING (arc_id)
	WHERE a.is_operative IS TRUE;

CREATE OR REPLACE VIEW v_edit_inp_virtualvalve
AS SELECT v_edit_arc.arc_id,
    v_edit_arc.node_1,
    v_edit_arc.node_2,
    v_edit_arc.arccat_id,
    v_edit_arc.expl_id,
    v_edit_arc.sector_id,
    v_edit_arc.dma_id,
    v_edit_arc.state,
    v_edit_arc.state_type,
    v_edit_arc.custom_length,
    v_edit_arc.annotation,
    v.valve_type,
    v.setting,
    v.curve_id,
    v.minorloss,
    v.status,
    v.init_quality,
    v_edit_arc.the_geom
	FROM v_edit_arc
	JOIN inp_virtualvalve v USING (arc_id)
	WHERE v_edit_arc.is_operative IS TRUE;

CREATE OR REPLACE VIEW ve_epa_virtualvalve AS
 SELECT inp_virtualvalve.arc_id,
    inp_virtualvalve.valve_type,
    inp_virtualvalve.diameter,
    inp_virtualvalve.setting,
    inp_virtualvalve.curve_id,
    inp_virtualvalve.minorloss,
    inp_virtualvalve.status,
    inp_virtualvalve.init_quality,
    v_rpt_arc_stats.result_id,
    v_rpt_arc_stats.flow_max AS flowmax,
    v_rpt_arc_stats.flow_min AS flowmin,
    v_rpt_arc_stats.flow_avg AS flowavg,
    v_rpt_arc_stats.vel_max AS velmax,
    v_rpt_arc_stats.vel_min AS velmin,
    v_rpt_arc_stats.vel_avg AS velavg,
    v_rpt_arc_stats.headloss_max,
    v_rpt_arc_stats.headloss_min,
    v_rpt_arc_stats.setting_max,
    v_rpt_arc_stats.setting_min,
    v_rpt_arc_stats.reaction_max,
    v_rpt_arc_stats.reaction_min,
    v_rpt_arc_stats.ffactor_max,
    v_rpt_arc_stats.ffactor_min
    FROM inp_virtualvalve
    LEFT JOIN v_rpt_arc_stats ON inp_virtualvalve.arc_id::text = v_rpt_arc_stats.arc_id;

CREATE OR REPLACE VIEW ve_epa_virtualpump
AS SELECT p.arc_id,
    p.power,
    p.curve_id,
    p.speed,
    p.pattern_id,
    p.status,
    p.pump_type,
    p.effic_curve_id,
    p.energy_price,
    p.energy_pattern_id,
    v_rpt_arc_stats.result_id,
    v_rpt_arc_stats.flow_max AS flowmax,
    v_rpt_arc_stats.flow_min AS flowmin,
    v_rpt_arc_stats.flow_avg AS flowavg,
    v_rpt_arc_stats.vel_max AS velmax,
    v_rpt_arc_stats.vel_min AS velmin,
    v_rpt_arc_stats.vel_avg AS velavg,
    v_rpt_arc_stats.headloss_max,
    v_rpt_arc_stats.headloss_min,
    v_rpt_arc_stats.setting_max,
    v_rpt_arc_stats.setting_min,
    v_rpt_arc_stats.reaction_max,
    v_rpt_arc_stats.reaction_min,
    v_rpt_arc_stats.ffactor_max,
    v_rpt_arc_stats.ffactor_min
   FROM inp_virtualpump p
     LEFT JOIN v_rpt_arc_stats ON p.arc_id::text = v_rpt_arc_stats.arc_id;

CREATE OR REPLACE VIEW v_edit_inp_dscenario_pipe
AS SELECT d.dscenario_id,
    p.arc_id,
    p.minorloss,
    p.status,
    p.roughness,
    p.dint,
    p.bulk_coeff,
    p.wall_coeff,
    a.the_geom
	FROM selector_inp_dscenario, v_edit_arc a
    JOIN inp_dscenario_pipe p USING (arc_id)
	JOIN cat_dscenario d USING (dscenario_id)
	WHERE p.dscenario_id = selector_inp_dscenario.dscenario_id AND selector_inp_dscenario.cur_user = CURRENT_USER
	AND a.is_operative IS TRUE;

CREATE OR REPLACE VIEW v_edit_inp_dscenario_virtualvalve
AS SELECT d.dscenario_id,
    p.arc_id,
    p.valve_type,
    p.diameter,
    p.setting,
    p.curve_id,
    p.minorloss,
    p.status,
    p.init_quality,
    a.the_geom
    FROM selector_inp_dscenario, v_edit_arc a
    JOIN inp_dscenario_virtualvalve p USING (arc_id)
    JOIN cat_dscenario d USING (dscenario_id)
	WHERE p.dscenario_id = selector_inp_dscenario.dscenario_id AND selector_inp_dscenario.cur_user = CURRENT_USER
	AND a.is_operative IS TRUE;

CREATE OR REPLACE VIEW v_edit_inp_dscenario_virtualpump
AS SELECT v.dscenario_id,
    p.arc_id,
    v.power,
    v.curve_id,
    v.speed,
    v.pattern_id,
    v.status,
    v.pump_type,
    v.effic_curve_id,
    v.energy_price,
    v.energy_pattern_id,
    p.the_geom
    FROM selector_inp_dscenario s, v_edit_inp_virtualpump p
    JOIN inp_dscenario_virtualpump v USING (arc_id)
    WHERE v.dscenario_id = s.dscenario_id AND s.cur_user = CURRENT_USER;

CREATE OR REPLACE VIEW v_edit_inp_connec
AS SELECT v_edit_connec.connec_id,
    v_edit_connec.top_elev,
    v_edit_connec.depth,
    v_edit_connec.conneccat_id,
    v_edit_connec.arc_id,
    v_edit_connec.expl_id,
    v_edit_connec.sector_id,
    v_edit_connec.dma_id,
    v_edit_connec.state,
    v_edit_connec.state_type,
    v_edit_connec.pjoint_type,
    v_edit_connec.pjoint_id,
    v_edit_connec.annotation,
    inp_connec.demand,
    inp_connec.pattern_id,
    inp_connec.peak_factor,
    inp_connec.status,
    inp_connec.minorloss,
    inp_connec.custom_roughness,
    inp_connec.custom_length,
    inp_connec.custom_dint,
    inp_connec.emitter_coeff,
    inp_connec.init_quality,
    inp_connec.source_type,
    inp_connec.source_quality,
    inp_connec.source_pattern_id,
    v_edit_connec.the_geom
    FROM v_edit_connec
    JOIN inp_connec USING (connec_id)
	WHERE v_edit_connec.is_operative IS TRUE;


CREATE OR REPLACE VIEW ve_pol_register
AS SELECT polygon.pol_id,
    polygon.feature_id AS node_id,
    polygon.the_geom
    FROM polygon
    WHERE polygon.sys_type::text = 'REGISTER'::text;

CREATE OR REPLACE VIEW ve_pol_fountain
AS SELECT polygon.pol_id,
    polygon.feature_id AS connec_id,
    polygon.the_geom
    FROM polygon
    WHERE polygon.sys_type::text = 'FOUNTAIN'::text;

CREATE OR REPLACE VIEW ve_pol_tank
AS SELECT polygon.pol_id,
    polygon.feature_id AS node_id,
    polygon.the_geom
    FROM polygon
    WHERE polygon.sys_type::text = 'TANK'::text;

CREATE OR REPLACE VIEW v_edit_inp_dscenario_pump as
SELECT d.dscenario_id,
    p.node_id,
    p.power,
    p.curve_id,
    p.speed,
    p.pattern_id,
    p.status,
    p.effic_curve_id,
    p.energy_price,
    p.energy_pattern_id,
    n.the_geom
    FROM selector_inp_dscenario, v_edit_node n
    JOIN inp_dscenario_pump p USING (node_id)
    JOIN cat_dscenario d USING (dscenario_id)
	WHERE p.dscenario_id = selector_inp_dscenario.dscenario_id AND selector_inp_dscenario.cur_user = CURRENT_USER
	AND n.is_operative IS TRUE;

CREATE OR REPLACE VIEW v_edit_inp_pump_additional
AS SELECT n.node_id,
    n.top_elev,
    n.custom_top_elev,
    n.depth,
    n.nodecat_id,
    n.expl_id,
    n.sector_id,
    n.state,
    n.state_type,
    n.annotation,
    n.dma_id,
    p.order_id,
    p.power,
    p.curve_id,
    p.speed,
    p.pattern_id,
    p.status,
    p.effic_curve_id,
    p.energy_price,
    p.energy_pattern_id,
    n.the_geom
    FROM v_edit_node n
    JOIN inp_pump_additional p USING (node_id)
	WHERE n.is_operative IS TRUE;

CREATE OR REPLACE VIEW v_edit_inp_dscenario_pump_additional
AS SELECT d.dscenario_id,
    p.node_id,
    p.order_id,
    p.power,
    p.curve_id,
    p.speed,
    p.pattern_id,
    p.status,
    p.effic_curve_id,
    p.energy_price,
    p.energy_pattern_id,
    n.the_geom
	FROM selector_inp_dscenario, v_edit_node n
	JOIN inp_dscenario_pump_additional p USING (node_id)
    JOIN cat_dscenario d USING (dscenario_id)
	WHERE p.dscenario_id = selector_inp_dscenario.dscenario_id AND selector_inp_dscenario.cur_user = CURRENT_USER
	AND n.is_operative IS TRUE;

CREATE OR REPLACE VIEW v_edit_inp_dscenario_shortpipe
AS SELECT d.dscenario_id,
    p.node_id,
    p.minorloss,
    p.status,
    p.bulk_coeff,
    p.wall_coeff,
    n.the_geom
    FROM selector_inp_dscenario, v_edit_node n
    JOIN inp_dscenario_shortpipe p USING (node_id)
    JOIN cat_dscenario d USING (dscenario_id)
	WHERE p.dscenario_id = selector_inp_dscenario.dscenario_id AND selector_inp_dscenario.cur_user = CURRENT_USER
	AND n.is_operative IS TRUE;

CREATE OR REPLACE VIEW v_edit_inp_dscenario_connec
AS SELECT d.dscenario_id,
    connec.connec_id,
    connec.pjoint_type,
    connec.pjoint_id,
    c.demand,
    c.pattern_id,
    c.peak_factor,
    c.status,
    c.minorloss,
    c.custom_roughness,
    c.custom_length,
    c.custom_dint,
    c.emitter_coeff,
    c.init_quality,
    c.source_type,
    c.source_quality,
    c.source_pattern_id,
    connec.the_geom
    FROM selector_inp_dscenario, v_edit_inp_connec connec
    JOIN inp_dscenario_connec c USING (connec_id)
    JOIN cat_dscenario d USING (dscenario_id)
	WHERE c.dscenario_id = selector_inp_dscenario.dscenario_id AND selector_inp_dscenario.cur_user = CURRENT_USER;

CREATE OR REPLACE VIEW v_edit_inp_shortpipe
AS SELECT n.node_id,
    n.top_elev,
    n.custom_top_elev,
    n.depth,
    n.nodecat_id,
    n.expl_id,
    n.sector_id,
    n.dma_id,
    n.state,
    n.state_type,
    n.annotation,
    concat(n.node_id, '_n2a') AS nodarc_id,
    inp_shortpipe.minorloss,
    CASE
      WHEN v.to_arc IS NOT NULL AND v.closed IS FALSE THEN 'CV'::character varying(12)
      WHEN v.closed IS TRUE THEN 'CLOSED'::character varying(12)
      WHEN v.closed IS FALSE THEN 'OPEN'::character varying(12)
      ELSE NULL::character varying(12)
    END AS status,
    inp_shortpipe.bulk_coeff,
    inp_shortpipe.wall_coeff,
    n.the_geom
    FROM v_edit_node n
    JOIN inp_shortpipe using (node_id)
    LEFT JOIN man_valve v ON v.node_id = n.node_id
	WHERE n.is_operative IS TRUE;


CREATE OR REPLACE VIEW v_edit_inp_dscenario_tank
AS SELECT d.dscenario_id,
    p.node_id,
    p.initlevel,
    p.minlevel,
    p.maxlevel,
    p.diameter,
    p.minvol,
    p.curve_id,
    p.overflow,
    p.mixing_model,
    p.mixing_fraction,
    p.reaction_coeff,
    p.init_quality,
    p.source_type,
    p.source_quality,
    p.source_pattern_id,
    n.the_geom
    FROM selector_inp_dscenario, v_edit_node n
    JOIN inp_dscenario_tank p USING (node_id)
    JOIN cat_dscenario d USING (dscenario_id)
    WHERE p.dscenario_id = selector_inp_dscenario.dscenario_id AND selector_inp_dscenario.cur_user = CURRENT_USER AND n.is_operative IS TRUE;

CREATE OR REPLACE VIEW v_edit_inp_tank
AS SELECT n.node_id,
    n.top_elev,
    n.custom_top_elev,
    n.depth,
    n.nodecat_id,
    n.expl_id,
    n.sector_id,
    n.dma_id,
    n.state,
    n.state_type,
    n.annotation,
    inp_tank.initlevel,
    inp_tank.minlevel,
    inp_tank.maxlevel,
    inp_tank.diameter,
    inp_tank.minvol,
    inp_tank.curve_id,
    inp_tank.overflow,
    inp_tank.mixing_model,
    inp_tank.mixing_fraction,
    inp_tank.reaction_coeff,
    inp_tank.init_quality,
    inp_tank.source_type,
    inp_tank.source_quality,
    inp_tank.source_pattern_id,
    n.the_geom
    FROM v_edit_node n
    JOIN inp_tank USING (node_id)
    WHERE n.is_operative IS TRUE;


CREATE OR REPLACE VIEW v_edit_inp_dscenario_reservoir
AS SELECT d.dscenario_id,
    p.node_id,
    p.pattern_id,
    p.head,
    p.init_quality,
    p.source_type,
    p.source_quality,
    p.source_pattern_id,
    n.the_geom
    FROM selector_inp_dscenario, v_edit_node n
    JOIN inp_dscenario_reservoir p USING (node_id)
    JOIN cat_dscenario d USING (dscenario_id)
	WHERE p.dscenario_id = selector_inp_dscenario.dscenario_id AND selector_inp_dscenario.cur_user = CURRENT_USER
	AND n.is_operative IS TRUE;


CREATE OR REPLACE VIEW v_edit_inp_reservoir
AS SELECT n.node_id,
    n.top_elev,
    n.custom_top_elev,
    n.depth,
    n.nodecat_id,
    n.expl_id,
    n.sector_id,
    n.dma_id,
    n.state,
    n.state_type,
    n.annotation,
    inp_reservoir.pattern_id,
    inp_reservoir.head,
    inp_reservoir.init_quality,
    inp_reservoir.source_type,
    inp_reservoir.source_quality,
    inp_reservoir.source_pattern_id,
    n.the_geom
    FROM v_edit_node n
    JOIN inp_reservoir USING (node_id)
	WHERE n.is_operative IS TRUE;

CREATE OR REPLACE VIEW v_edit_inp_dscenario_valve
AS SELECT d.dscenario_id,
    p.node_id,
    concat(p.node_id, '_n2a') AS nodarc_id,
    p.valve_type,
    p.setting,
    p.curve_id,
    p.minorloss,
    p.status,
    p.add_settings,
    p.init_quality,
    n.the_geom
	FROM selector_inp_dscenario, v_edit_node n
	JOIN inp_dscenario_valve p USING (node_id)
	JOIN cat_dscenario d USING (dscenario_id)
	WHERE p.dscenario_id = selector_inp_dscenario.dscenario_id AND selector_inp_dscenario.cur_user = CURRENT_USER
	AND n.is_operative IS TRUE;

CREATE OR REPLACE VIEW v_edit_inp_valve
AS SELECT n.node_id,
    n.top_elev,
    n.custom_top_elev,
    n.depth,
    n.nodecat_id,
    n.expl_id,
    n.sector_id,
    n.dma_id,
    n.state,
    n.state_type,
    n.annotation,
    concat(n.node_id, '_n2a') AS nodarc_id,
    inp_valve.valve_type,
    inp_valve.setting,
    inp_valve.curve_id,
    inp_valve.minorloss,
    v.to_arc,
    CASE
      WHEN v.to_arc IS NOT NULL AND v.closed IS FALSE THEN 'ACTIVE'::character varying(12)
      WHEN v.closed IS TRUE THEN 'CLOSED'::character varying(12)
      WHEN v.closed IS FALSE THEN 'OPEN'::character varying(12)
      ELSE NULL::character varying(12)
    END AS status,
	  n.cat_dint,
    inp_valve.custom_dint,
    inp_valve.add_settings,
    inp_valve.init_quality,
    n.the_geom
	FROM v_edit_node n
	JOIN inp_valve USING (node_id)
	JOIN man_valve v USING (node_id)
	WHERE n.is_operative IS TRUE;

CREATE OR REPLACE VIEW v_edit_inp_dscenario_inlet
AS SELECT p.dscenario_id,
    n.node_id,
    p.initlevel,
    p.minlevel,
    p.maxlevel,
    p.diameter,
    p.minvol,
    p.curve_id,
    p.overflow,
    p.mixing_model,
    p.mixing_fraction,
    p.reaction_coeff,
    p.init_quality,
    p.source_type,
    p.source_quality,
    p.source_pattern_id,
	p.head,
    p.pattern_id,
	p.demand,
	p.demand_pattern_id,
	p.emitter_coeff,
    n.the_geom
	FROM selector_inp_dscenario, v_edit_node n
	JOIN inp_dscenario_inlet p USING (node_id)
	JOIN cat_dscenario d USING (dscenario_id)
	WHERE p.dscenario_id = selector_inp_dscenario.dscenario_id AND selector_inp_dscenario.cur_user = CURRENT_USER AND n.is_operative IS TRUE;

CREATE OR REPLACE VIEW v_edit_inp_inlet
AS SELECT n.node_id,
    n.top_elev,
    n.custom_top_elev,
    n.depth,
    n.nodecat_id,
    n.expl_id,
    n.sector_id,
    n.dma_id,
    n.state,
    n.state_type,
    n.annotation,
    inp_inlet.initlevel,
    inp_inlet.minlevel,
    inp_inlet.maxlevel,
    inp_inlet.diameter,
    inp_inlet.minvol,
    inp_inlet.curve_id,
    inp_inlet.overflow,
    inp_inlet.mixing_model,
    inp_inlet.mixing_fraction,
    inp_inlet.reaction_coeff,
    inp_inlet.init_quality,
    inp_inlet.source_type,
    inp_inlet.source_quality,
    inp_inlet.source_pattern_id,
	inp_inlet.pattern_id,
    inp_inlet.head,
	inp_inlet.demand,
	inp_inlet.demand_pattern_id,
	inp_inlet.emitter_coeff,
    n.the_geom
	FROM v_edit_node n
    JOIN inp_inlet USING (node_id)
	WHERE n.is_operative IS TRUE;


CREATE OR REPLACE VIEW v_ui_plan_arc_cost
AS WITH p AS (
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
            a.id,
            a.arc_type,
            a.matcat_id,
            a.pnom,
            a.dnom,
            a.dint,
            a.dext,
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
            a.shape,
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
   FROM p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, sector_id, expl_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, arc_type, matcat_id, pnom, dnom, dint, dext, descript, link, brand_id, model_id, svg, z1_1, z2_1, width_1, area_1, estimated_depth, thickness_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, shape, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
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
   FROM p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, sector_id, expl_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, act_type, matcat_id, pnom, dnom, dint, dext, descript, link, brand_id, model_id, svg, z1_1, z2_1, width_1, area_1, estimated_depth, thickness_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, shape, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
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
   FROM p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, sector_id, expl_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, act_type, matcat_id, pnom, dnom, dint, dext, descript, link, brand, model_id, svg, z1_1, z2_1, width_1, area_1, estimated_depth, thickness_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, shape, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
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
   FROM p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, sector_id, expl_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, act_type, matcat_id, pnom, dnom, dint, dext, descript, link, brand, model_id, svg, z1_1, z2_1, width_1, area_1, estimated_depth, thickness_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, shape, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
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
   FROM p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, sector_id, expl_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, act_type, matcat_id, pnom, dnom, dint, dext, descript, link, brand_id, model_id, svg, z1_1, z2_1, width_1, area_1, estimated_depth, thickness_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, shape, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
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
   FROM p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, sector_id, expl_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, act_type, matcat_id, pnom, dnom, dint, dext, descript, link, brand_id, model_id, svg, z1_1, z2_1, width_1, area_1, estimated_depth, thickness_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, shape, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
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
   FROM p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, sector_id, expl_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, act_type, matcat_id, pnom, dnom, dint, dext, descript, link, brand_id, model_id, svg, z1_1, z2_1, width_1, area_1, estimated_depth, thickness_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, shape, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
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
   FROM p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, sector_id, expl_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, act_type, matcat_id, pnom, dnom, dint, dext, descript, link, brand_id, model_id, svg, z1_1, z2_1, width_1, area_1, estimated_depth, thickness_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, shape, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
     JOIN v_plan_aux_arc_pavement a ON a.arc_id = p.arc_id
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
   FROM p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, sector_id, expl_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, act_type, matcat_id, pnom, dnom, dint, dext, descript, link, brand_id, model_id, svg, z1_1, z2_1, width_1, area_1, estimated_depth, thickness_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, shape, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
     JOIN v_edit_connec USING (arc_id)
     JOIN v_price_compost v ON p.cat_connect_cost = v.id::text
  GROUP BY p.arc_id
  ORDER BY 1, 2;

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
  WHERE arc.state = 1 AND arc.workcat_id IS NOT NULL
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
  WHERE node.state = 1 AND node.workcat_id IS NOT NULL
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
  WHERE connec.state = 1 AND connec.workcat_id IS NOT NULL
UNION
 SELECT row_number() OVER (ORDER BY element.element_id) + 4000000 AS rid,
    element.feature_type,
    element.elementcat_id AS featurecat_id,
    element.element_id AS feature_id,
    element.code,
    exploitation.name AS expl_name,
    element.workcat_id,
    exploitation.expl_id
   FROM element
     JOIN exploitation ON exploitation.expl_id = element.expl_id
  WHERE element.state = 1 AND element.workcat_id IS NOT NULL;

CREATE OR REPLACE VIEW v_ui_workcat_x_feature_end as
SELECT row_number() OVER (ORDER BY v_edit_arc.arc_id) + 1000000 AS rid,
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
  WHERE element.state = 0;

CREATE OR REPLACE VIEW v_plan_result_arc
AS SELECT plan_rec_result_arc.arc_id,
    plan_rec_result_arc.node_1,
    plan_rec_result_arc.node_2,
    plan_rec_result_arc.arc_type,
    plan_rec_result_arc.arccat_id,
    plan_rec_result_arc.epa_type,
    plan_rec_result_arc.sector_id,
    plan_rec_result_arc.expl_id,
    plan_rec_result_arc.state,
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
  WHERE plan_rec_result_arc.result_id::text = selector_plan_result.result_id::text AND selector_plan_result.cur_user = CURRENT_USER AND plan_rec_result_arc.state = 1
UNION
 SELECT v_plan_arc.arc_id,
    v_plan_arc.node_1,
    v_plan_arc.node_2,
    v_plan_arc.arc_type,
    v_plan_arc.arccat_id,
    v_plan_arc.epa_type,
    v_plan_arc.sector_id,
    v_plan_arc.expl_id,
    v_plan_arc.state,
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
                     JOIN plan_psector_x_arc ON plan_psector_x_arc.arc_id = v_plan_arc.arc_id
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
                     JOIN plan_psector_x_node ON plan_psector_x_node.node_id = v_plan_node.node_id
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
  WHERE plan_psector.psector_id = selector_psector.psector_id AND selector_psector.cur_user = CURRENT_USER;


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
                     JOIN plan_psector_x_arc ON plan_psector_x_arc.arc_id = v_plan_arc.arc_id
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
                     JOIN plan_psector_x_node ON plan_psector_x_node.node_id = v_plan_node.node_id
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
  WHERE config_param_user.cur_user::text = CURRENT_USER AND config_param_user.parameter::text = 'plan_psector_current'::text AND config_param_user.value::integer = plan_psector.psector_id;

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
                     JOIN plan_psector_x_arc ON plan_psector_x_arc.arc_id = v_plan_arc.arc_id
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
                     JOIN plan_psector_x_node ON plan_psector_x_node.node_id = v_plan_node.node_id
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

CREATE OR REPLACE VIEW v_edit_plan_netscenario_presszone
AS SELECT n.netscenario_id,
    p.name AS netscenario_name,
    n.presszone_id,
    n.presszone_name AS name,
    n.head,
    n.graphconfig,
    n.the_geom,
    n.active,
    n.presszone_type,
    n.stylesheet::text AS stylesheet,
    n.expl_id2
   FROM config_param_user,
    plan_netscenario_presszone n
     JOIN plan_netscenario p USING (netscenario_id)
  WHERE config_param_user.cur_user::text = CURRENT_USER
  AND config_param_user.parameter::text = 'plan_netscenario_current'::text
  AND config_param_user.value::integer = n.netscenario_id;

CREATE OR REPLACE VIEW v_edit_plan_netscenario_valve
AS SELECT v.netscenario_id,
    v.node_id,
    v.closed,
    node.the_geom
   FROM config_param_user,
    plan_netscenario_valve v
     JOIN node USING (node_id)
  WHERE config_param_user.cur_user::text = CURRENT_USER
  AND config_param_user.parameter::text = 'plan_netscenario_current'::text
  AND config_param_user.value::integer = v.netscenario_id;

CREATE OR REPLACE VIEW v_edit_plan_netscenario_dma
AS SELECT n.netscenario_id,
    p.name AS netscenario_name,
    n.dma_id,
    n.dma_name AS name,
    n.pattern_id,
    n.graphconfig,
    n.the_geom,
    n.active,
    n.stylesheet::text AS stylesheet,
    n.expl_id2
   FROM config_param_user,
    plan_netscenario_dma n
     JOIN plan_netscenario p USING (netscenario_id)
  WHERE config_param_user.cur_user::text = CURRENT_USER
  AND config_param_user.parameter::text = 'plan_netscenario_current'::text
  AND config_param_user.value::integer = n.netscenario_id;

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
     JOIN plan_psector_x_arc ON plan_psector_x_arc.arc_id = v_plan_arc.arc_id
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
     JOIN plan_psector_x_node ON plan_psector_x_node.node_id = v_plan_node.node_id
  WHERE plan_psector_x_node.doable = true
UNION
 SELECT row_number() OVER (ORDER BY v_edit_plan_psector_x_other.id) + 19999 AS rid,
    v_edit_plan_psector_x_other.psector_id,
    'other'::text AS feature_type,
    v_edit_plan_psector_x_other.price_id AS featurecat_id,
    NULL AS feature_id,
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
     JOIN plan_psector_x_arc ON plan_psector_x_arc.arc_id = v_plan_arc.arc_id
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
     JOIN plan_psector_x_arc ON plan_psector_x_arc.arc_id = v_plan_arc.arc_id
  WHERE plan_psector_x_arc.doable = true
  ORDER BY plan_psector_x_arc.psector_id, v_plan_arc.soilcat_id, v_plan_arc.arccat_id;


CREATE OR REPLACE VIEW v_om_waterbalance_report
AS WITH expl_data AS (
         SELECT sum(w_1.auth) / sum(w_1.total) AS expl_rw_eff,
            1::double precision - sum(w_1.auth) / sum(w_1.total) AS expl_nrw_eff,
            NULL::text AS expl_nightvol,
                CASE
                    WHEN sum(w_1.arc_length) = 0::double precision THEN NULL::double precision
                    ELSE sum(w_1.nrw) / sum(w_1.arc_length) / (EXTRACT(epoch FROM age(p_1.end_date, p_1.start_date)) / 3600::numeric)::double precision
                END AS expl_m4day,
                CASE
                    WHEN sum(w_1.arc_length) = 0::double precision AND sum(w_1.n_connec) = 0 AND sum(w_1.link_length) = 0::double precision THEN NULL::double precision
                    ELSE sum(w_1.loss) * (365::numeric / EXTRACT(day FROM p_1.end_date - p_1.start_date))::double precision / (6.57::double precision * sum(w_1.arc_length) + 9.13::double precision * sum(w_1.link_length) + (0.256 * sum(w_1.n_connec)::numeric * avg(d_1.avg_press))::double precision)
                END AS expl_ili,
            w_1.expl_id,
            w_1.cat_period_id,
            p_1.start_date
           FROM om_waterbalance w_1
             JOIN ext_cat_period p_1 ON w_1.cat_period_id::text = p_1.id::text
             JOIN dma d_1 ON d_1.dma_id = w_1.dma_id
          GROUP BY w_1.expl_id, w_1.cat_period_id, p_1.end_date, p_1.start_date
        )
 SELECT DISTINCT e.name AS exploitation,
    w.expl_id,
    d.name AS dma,
    w.dma_id,
    w.cat_period_id,
    p.code AS period,
    p.start_date,
    p.end_date,
    w.meters_in,
    w.meters_out,
    w.n_connec,
    w.n_hydro,
    w.arc_length,
    w.link_length,
    w.total_in,
    w.total_out,
    w.total,
    w.auth,
    w.nrw,
        CASE
            WHEN w.total <> 0::double precision THEN w.auth / w.total
            ELSE NULL::double precision
        END AS dma_rw_eff,
        CASE
            WHEN w.total <> 0::double precision THEN 1::double precision - w.auth / w.total
            ELSE NULL::double precision
        END AS dma_nrw_eff,
    w.ili AS dma_ili,
    NULL::text AS dma_nightvol,
    w.nrw / w.arc_length / (EXTRACT(epoch FROM age(p.end_date, p.start_date)) / 3600::numeric)::double precision AS dma_m4day,
    ed.expl_rw_eff,
    ed.expl_nrw_eff,
    ed.expl_nightvol,
    ed.expl_ili,
    ed.expl_m4day,
    w.n_inhabitants,
    w.avg_press
   FROM om_waterbalance w
     JOIN exploitation e USING (expl_id)
     JOIN dma d USING (dma_id)
     JOIN ext_cat_period p ON w.cat_period_id::text = p.id::text
     JOIN expl_data ed ON ed.expl_id = w.expl_id AND w.cat_period_id::text = p.id::text
  WHERE ed.start_date = p.start_date;

CREATE OR REPLACE VIEW v_om_waterbalance
AS SELECT e.name AS exploitation,
    d.name AS dma,
    p.code AS period,
    om_waterbalance.auth_bill,
    om_waterbalance.auth_unbill,
    om_waterbalance.loss_app,
    om_waterbalance.loss_real,
    om_waterbalance.total_in,
    om_waterbalance.total_out,
    om_waterbalance.total,
    p.start_date::date AS crm_startdate,
    p.end_date::date AS crm_enddate,
    om_waterbalance.startdate AS wbal_startdate,
    om_waterbalance.enddate AS wbal_enddate,
    om_waterbalance.ili,
    om_waterbalance.auth,
    om_waterbalance.loss,
        CASE
            WHEN om_waterbalance.total > 0::double precision THEN (100::numeric::double precision * (om_waterbalance.auth_bill + om_waterbalance.auth_unbill) / om_waterbalance.total)::numeric(20,2)
            ELSE 0::numeric(20,2)
        END AS loss_eff,
    om_waterbalance.auth_bill AS rw,
    (om_waterbalance.total - om_waterbalance.auth_bill)::numeric(20,2) AS nrw,
        CASE
            WHEN om_waterbalance.total > 0::double precision THEN (100::numeric::double precision * om_waterbalance.auth_bill / om_waterbalance.total)::numeric(20,2)
            ELSE 0::numeric(20,2)
        END AS nrw_eff,
    d.the_geom,
    om_waterbalance.n_inhabitants,
    om_waterbalance.avg_press
   FROM om_waterbalance
     JOIN exploitation e USING (expl_id)
     JOIN dma d USING (dma_id)
     JOIN ext_cat_period p ON p.id::text = om_waterbalance.cat_period_id::text;

CREATE OR REPLACE VIEW v_value_cat_node
AS SELECT cat_node.id,
    cat_node.node_type,
    cat_feature.feature_class
   FROM cat_node
     JOIN cat_feature_node ON cat_feature_node.id::TEXT = cat_node.node_type::TEXT
     JOIN cat_feature ON cat_feature_node.id::TEXT = cat_feature.id::TEXT;

CREATE OR REPLACE VIEW v_value_cat_connec
AS SELECT cat_connec.id,
    cat_connec.connec_type,
    cat_feature.feature_class
   FROM cat_connec
     JOIN cat_feature_connec ON cat_feature_connec.id::TEXT = cat_connec.connec_type::TEXT
     JOIN cat_feature ON cat_feature_connec.id::TEXT = cat_feature.id::TEXT;

CREATE OR REPLACE VIEW v_edit_review_connec
AS SELECT review_connec.connec_id,
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
  WHERE selector_expl.cur_user = CURRENT_USER AND review_connec.expl_id = selector_expl.expl_id;

-- 30/10//2024
CREATE OR REPLACE VIEW vcp_pipes AS
 SELECT p.arc_id,
    p.minorloss,
    p.dint, p.dscenario_id
   FROM config_param_user c, selector_inp_result r, rpt_inp_arc rpt
   JOIN inp_dscenario_pipe p ON rpt.arc_id = p.arc_id::text
   WHERE c.parameter::text = 'epatools_calibrator_dscenario_id'::text AND c.value = p.dscenario_id::text
   AND c.cur_user = CURRENT_USER AND r.result_id = rpt.result_id AND r.cur_user = CURRENT_USER;

CREATE OR REPLACE VIEW vcv_junction AS
SELECT rpt.node_id,
    rpt.dma_id
   FROM selector_inp_result r,
    rpt_inp_node rpt
  WHERE r.result_id::text = rpt.result_id::text AND r.cur_user = CURRENT_USER AND rpt.epa_type = 'JUNCTION';

CREATE OR REPLACE VIEW vcv_demands AS
 SELECT inp.feature_id, inp.demand, inp.pattern_id, inp.source, dscenario_id
   FROM config_param_user c, inp_dscenario_demand inp
   WHERE c.parameter::text = 'epatools_calibrator_dscenario_id'::text AND c.value = inp.dscenario_id::text
   AND c.cur_user = CURRENT_USER;

CREATE OR REPLACE VIEW vcv_patterns AS
 SELECT patt.*
   FROM selector_inp_result r, rpt_inp_pattern_value patt
   WHERE r.result_id = patt.result_id AND r.cur_user = CURRENT_USER;;

CREATE OR REPLACE VIEW vcv_emitters_log
 AS
 SELECT DISTINCT n.node_id, n.dma_id,
    sum(a.length / 10000::numeric) AS c0_default,
	NULL::numeric AS c0_updated
   FROM selector_inp_result r,
    rpt_inp_arc a
     JOIN rpt_inp_node n USING (result_id)
  WHERE (a.node_1 = n.node_id OR a.node_2 = n.node_id) AND r.result_id::text = n.result_id::text AND r.cur_user = CURRENT_USER
  GROUP BY n.node_id, n.dma_id;

CREATE OR REPLACE VIEW vcv_dma_log
 AS
 SELECT DISTINCT
    n.dma_id,
    NULL::numeric AS coef
   FROM selector_inp_result r,
    rpt_inp_arc a
     JOIN rpt_inp_node n USING (result_id)
  WHERE (a.node_1 = n.node_id OR a.node_2 = n.node_id) AND r.result_id::text = n.result_id::text AND r.cur_user = CURRENT_USER
  GROUP BY n.node_id, n.dma_id;



CREATE OR REPLACE VIEW v_minsector_graph AS
WITH sel_expl AS (
	SELECT selector_expl.expl_id FROM selector_expl WHERE selector_expl.cur_user = CURRENT_USER
)
SELECT
    m.node_id,
    m.nodecat_id,
    m.minsector_1,
    m.minsector_2,
    n.expl_id
FROM minsector_graph m
JOIN node n ON n.node_id = m.node_id
WHERE EXISTS (
	SELECT 1 FROM sel_expl WHERE sel_expl.expl_id = n.expl_id
);




DROP  VIEW IF EXISTS v_rpt_comp_arc;

CREATE OR REPLACE VIEW v_rpt_comp_arc
AS
WITH main AS
	(SELECT r.arc_id,
    r.result_id,
    r.arc_type,
    r.sector_id,
    r.arccat_id,
    r.flow_max,
    r.flow_min,
    r.flow_avg,
    r.vel_max,
    r.vel_min,
    r.vel_avg,
    r.headloss_max,
    r.headloss_min,
    r.setting_max,
    r.setting_min,
    r.reaction_max,
    r.reaction_min,
    r.ffactor_max,
    r.ffactor_min,
    r.the_geom
   FROM rpt_arc_stats r, selector_rpt_main s
	WHERE r.result_id::text = s.result_id::text AND s.cur_user = CURRENT_USER) ,
  compare AS
	(SELECT r.arc_id,
    r.result_id,
    r.arc_type,
    r.sector_id,
    r.arccat_id,
    r.flow_max,
    r.flow_min,
    r.flow_avg,
    r.vel_max,
    r.vel_min,
    r.vel_avg,
    r.headloss_max,
    r.headloss_min,
    r.setting_max,
    r.setting_min,
    r.reaction_max,
    r.reaction_min,
    r.ffactor_max,
    r.ffactor_min,
    r.the_geom
   FROM rpt_arc_stats r, selector_rpt_compare s
  WHERE r.result_id::text = s.result_id::text AND s.cur_user = CURRENT_USER)
	SELECT main.arc_id,
	main.arc_type,
	main.sector_id,
	main.arccat_id,
	main.result_id as main_result,
	compare.result_id as compare_result,
	main.flow_max as flow_max_main,
	compare.flow_max as flow_max_compare,
	main.flow_max - compare.flow_max as flow_max_diff,
	main.flow_min as flow_min_main,
	compare.flow_min as flow_min_compare,
	main.flow_min - compare.flow_min as flow_min_diff,
	main.flow_avg as flow_avg_main,
	compare.flow_avg as flow_avg_compare,
	main.flow_avg - compare.flow_avg as flow_avg_diff,
	main.vel_max as vel_max_main,
	compare.vel_max as vel_max_compare,
	main.vel_max - compare.vel_max as vel_max_diff,
	main.vel_min as vel_min_main,
	compare.vel_min as vel_min_compare,
	main.vel_min - compare.vel_min as vel_min_diff,
	main.vel_avg as vel_avg_main,
	compare.vel_avg as vel_avg_compare,
	main.vel_avg - compare.vel_avg as vel_avg_diff,
	main.headloss_max as headloss_max_main,
	compare.headloss_max as headloss_max_compare,
	main.headloss_max - compare.headloss_max as headloss_max_diff,
	main.headloss_min as headloss_min_main,
	compare.headloss_min as headloss_min_compare,
	main.headloss_min - compare.headloss_min as headloss_min_diff,
	main.setting_max as setting_max_main,
	compare.setting_max as setting_max_compare,
	main.setting_max - compare.setting_max as setting_max_diff,
	main.setting_min as setting_min_main,
	compare.setting_min as setting_min_compare,
	main.setting_min - compare.setting_min as setting_min_diff,
	main.reaction_max as reaction_max_main,
	compare.reaction_max as reaction_max_compare,
	main.reaction_max - compare.reaction_max as reaction_max_diff,
	main.reaction_min as reaction_min_main,
	compare.reaction_min as reaction_min_compare,
	main.reaction_min - compare.reaction_min as reaction_min_diff,
	main.ffactor_max as ffactor_max_main,
	compare.ffactor_max as ffactor_max_compare,
	main.ffactor_max - compare.ffactor_max as ffactor_max_diff,
	main.ffactor_min as ffactor_min_main,
	compare.ffactor_min as ffactor_min_compare,
	main.ffactor_min - compare.ffactor_min as ffactor_min_diff,
	main.the_geom
	FROM main JOIN compare ON main.arc_id = compare.arc_id;



CREATE OR REPLACE VIEW v_rpt_comp_node
AS
WITH main AS (
SELECT r.node_id,
    r.result_id,
    r.node_type,
    r.sector_id,
    r.nodecat_id,
    r.top_elev,
    r.demand_max,
    r.demand_min,
    r.demand_avg,
    r.head_max,
    r.head_min,
    r.head_avg,
    r.press_max,
    r.press_min,
    r.press_avg,
    r.quality_max,
    r.quality_min,
    r.quality_avg,
    r.the_geom
   FROM rpt_node_stats r,
    selector_rpt_main s
    WHERE r.result_id::text = s.result_id::text AND s.cur_user = CURRENT_USER),

compare AS (
SELECT r.node_id,
    r.result_id,
    r.node_type,
    r.sector_id,
    r.nodecat_id,
    r.top_elev,
    r.demand_max,
    r.demand_min,
    r.demand_avg,
    r.head_max,
    r.head_min,
    r.head_avg,
    r.press_max,
    r.press_min,
    r.press_avg,
    r.quality_max,
    r.quality_min,
    r.quality_avg,
    r.the_geom
   FROM rpt_node_stats r,
    selector_rpt_compare s
     WHERE r.result_id::text = s.result_id::text AND s.cur_user = CURRENT_USER)

     SELECT main.node_id,
     main.node_type,
     main.sector_id,
     main.nodecat_id,
     main.result_id AS result_id_main,
     compare.result_id AS result_id_compare,
     main.top_elev,
     main.demand_max AS demand_max_main,
     compare.demand_max AS demand_max_compare,
     main.demand_max - compare.demand_max AS demand_max_diff,
     main.demand_min AS demand_min_main,
     compare.demand_min AS demand_min_compare,
     main.demand_min - compare.demand_min AS demand_min_diff,
     main.demand_avg AS demand_avg_main,
     compare.demand_avg AS demand_avg_compare,
     main.demand_avg - compare.demand_avg AS demand_avg_diff,
     main.head_max AS head_max_main,
     compare.head_max AS head_max_compare,
     main.head_max - compare.head_max AS head_max_diff,
     main.head_min AS head_min_main,
     compare.head_min AS head_min_compare,
     main.head_min - compare.head_min AS head_min_diff,
     main.head_avg AS head_avg_main,
     compare.head_avg AS head_avg_compare,
     main.head_avg - compare.head_avg AS head_avg_diff,
     main.press_max AS press_max_main,
     compare.press_max AS press_max_compare,
     main.press_max - compare.press_max AS press_max_diff,
     main.press_min AS press_min_main,
     compare.press_min AS press_min_compare,
     main.press_min - compare.press_min AS press_min_diff,
     main.press_avg AS press_avg_main,
     compare.press_avg AS press_avg_compare,
     main.press_avg - compare.press_avg AS press_avg_diff,
      main.quality_max AS quality_max_main,
     compare.quality_max AS quality_max_compare,
     main.quality_max - compare.quality_max AS quality_max_diff,
     main.quality_min AS quality_min_main,
     compare.quality_min AS quality_min_compare,
     main.quality_min - compare.quality_min AS quality_min_diff,
     main.quality_avg AS quality_avg_main,
     compare.quality_avg AS quality_avg_compare,
     main.quality_avg - compare.quality_avg AS quality_avg_diff,
     main.the_geom
     FROM main JOIN compare ON main.node_id = compare.node_id;


--v_rpt_comp_node_hourly--
CREATE OR REPLACE VIEW v_rpt_comp_node_hourly  AS
 WITH main AS (
  SELECT rpt_node.id,
         node.node_id,
         node.sector_id,
         selector_rpt_main.result_id,
         rpt_node.top_elev,
         rpt_node.demand,
         rpt_node.head,
         rpt_node.press,
         rpt_node.quality,
         rpt_node."time",
         node.the_geom
    FROM selector_rpt_main,
         selector_rpt_main_tstep,
         rpt_inp_node node
         JOIN rpt_node ON rpt_node.node_id::text = node.node_id
   WHERE rpt_node.result_id::text = selector_rpt_main.result_id::text
     AND rpt_node."time"::text = selector_rpt_main_tstep.timestep::text
     AND selector_rpt_main.cur_user = CURRENT_USER
     AND selector_rpt_main_tstep.cur_user = CURRENT_USER
     AND node.result_id::text = selector_rpt_main.result_id::text
),
compare AS (
  SELECT rpt_node.id,
         node.node_id,
         node.sector_id,
         selector_rpt_compare.result_id,
         rpt_node.top_elev,
         rpt_node.demand,
         rpt_node.head,
         rpt_node.press,
         rpt_node.quality,
         rpt_node."time",
         node.the_geom
    FROM selector_rpt_compare,
         selector_rpt_compare_tstep,
         rpt_inp_node node
         JOIN rpt_node ON rpt_node.node_id::text = node.node_id
   WHERE rpt_node.result_id::text = selector_rpt_compare.result_id::text
     AND rpt_node."time"::text = selector_rpt_compare_tstep.timestep::text
     AND selector_rpt_compare.cur_user = CURRENT_USER
     AND selector_rpt_compare_tstep.cur_user = CURRENT_USER
     AND node.result_id::text = selector_rpt_compare.result_id::text
)
SELECT main.node_id,
       main.sector_id,
       main.top_elev,
       main.result_id AS result_id_main,
       compare.result_id AS result_id_compare,
       main.time AS time_main,
       compare.time AS time_compare,
       main.demand AS demand_main,
       compare.demand AS demand_compare,
       main.demand - compare.demand AS demand_diff,
       main.head AS head_main,
       compare.head AS head_compare,
       main.head - compare.head AS head_diff,
       main.press AS press_main,
       compare.press AS press_compare,
       main.press - compare.press AS press_diff,
       main.quality AS quality_main,
       compare.quality AS quality_compare,
       main.quality - compare.quality AS quality_diff,
       main.the_geom
  FROM main
  JOIN compare ON main.node_id = compare.node_id;


 --v_rpt_comp_arc_hourly--
CREATE OR REPLACE VIEW v_rpt_comp_arc_hourly
AS
WITH main AS (
  SELECT rpt_arc.id,
         arc.arc_id,
         arc.sector_id,
         selector_rpt_main.result_id,
         rpt_arc.flow,
         rpt_arc.vel,
         rpt_arc.headloss,
         rpt_arc.setting,
         rpt_arc.ffactor,
         rpt_arc."time",
         arc.the_geom
    FROM selector_rpt_main,
         selector_rpt_main_tstep,
         rpt_inp_arc arc
         JOIN rpt_arc ON rpt_arc.arc_id::text = arc.arc_id
   WHERE rpt_arc.result_id::text = selector_rpt_main.result_id::text
     AND rpt_arc."time"::text = selector_rpt_main_tstep.timestep::text
     AND selector_rpt_main.cur_user = CURRENT_USER
     AND selector_rpt_main_tstep.cur_user = CURRENT_USER
     AND arc.result_id::text = selector_rpt_main.result_id::TEXT
),
compare AS (
  SELECT rpt_arc.id,
         arc.arc_id,
         arc.sector_id,
         selector_rpt_compare.result_id,
         rpt_arc.flow,
         rpt_arc.vel,
         rpt_arc.headloss,
         rpt_arc.setting,
         rpt_arc.ffactor,
         rpt_arc."time",
         arc.the_geom
    FROM selector_rpt_compare,
         selector_rpt_compare_tstep,
         rpt_inp_arc arc
         JOIN rpt_arc ON rpt_arc.arc_id::text = arc.arc_id
   WHERE rpt_arc.result_id::text = selector_rpt_compare.result_id::text
     AND rpt_arc."time"::text = selector_rpt_compare_tstep.timestep::text
     AND selector_rpt_compare.cur_user = CURRENT_USER
     AND selector_rpt_compare_tstep.cur_user = CURRENT_USER
     AND arc.result_id::text = selector_rpt_compare.result_id::TEXT
)
SELECT main.arc_id,
       main.sector_id,
       main.result_id AS result_id_main,
       compare.result_id AS result_id_compare,
       main.time AS time_main,
       compare.time AS time_compare,
       main.flow AS flow_main,
       compare.flow AS flow_compare,
       main.flow - compare.flow AS flow_diff,
       main.vel AS vel_main,
       compare.vel AS vel_compare,
       main.vel - compare.vel AS vel_diff,
       main.headloss AS headloss_main,
       compare.headloss AS headloss_compare,
       main.headloss - compare.headloss AS headloss_diff,
       main.setting AS setting_main,
       compare.setting AS setting_compare,
       main.setting - compare.setting AS setting_diff,
       main.ffactor AS ffactor_main,
       compare.ffactor AS ffactor_compare,
       main.ffactor - compare.ffactor AS ffactor_diff,
       main.the_geom
  FROM main
  JOIN compare ON main.arc_id = compare.arc_id;

CREATE OR REPLACE VIEW v_ui_mincut
AS SELECT om_mincut.id,
    om_mincut.work_order,
    a.idval AS state,
    b.idval AS class,
    om_mincut.mincut_type,
    om_mincut.received_date,
    exploitation.name AS exploitation,
    ext_municipality.name AS municipality,
    om_mincut.postcode,
    ext_streetaxis.name AS streetaxis,
    om_mincut.postnumber,
    c.idval AS anl_cause,
    om_mincut.anl_tstamp,
    om_mincut.anl_user,
    om_mincut.anl_descript,
    om_mincut.anl_feature_id,
    om_mincut.anl_feature_type,
    om_mincut.forecast_start,
    om_mincut.forecast_end,
    cat_users.name AS assigned_to,
    om_mincut.exec_start,
    om_mincut.exec_end,
    om_mincut.exec_user,
    om_mincut.exec_descript,
    om_mincut.exec_from_plot,
    om_mincut.exec_depth,
    om_mincut.exec_appropiate,
    om_mincut.chlorine,
    om_mincut.turbidity,
    om_mincut.notified,
    om_mincut.output
   FROM om_mincut
     LEFT JOIN om_typevalue a ON a.id::integer = om_mincut.mincut_state AND a.typevalue = 'mincut_state'::text
     LEFT JOIN om_typevalue b ON b.id::integer = om_mincut.mincut_class AND b.typevalue = 'mincut_class'::text
     LEFT JOIN om_typevalue c ON c.id::integer = om_mincut.anl_cause::integer AND c.typevalue = 'mincut_cause'::text
     LEFT JOIN exploitation ON exploitation.expl_id = om_mincut.expl_id
     LEFT JOIN macroexploitation ON macroexploitation.macroexpl_id = om_mincut.macroexpl_id
     LEFT JOIN ext_municipality ON ext_municipality.muni_id = om_mincut.muni_id
     LEFT JOIN ext_streetaxis ON ext_streetaxis.id::text = om_mincut.streetaxis_id::text
     LEFT JOIN cat_users ON cat_users.id::text = om_mincut.assigned_to::text
  WHERE om_mincut.id > 0;

CREATE OR REPLACE VIEW v_om_mincut_hydrometer
AS SELECT om_mincut_hydrometer.id,
    om_mincut_hydrometer.result_id,
    om_mincut.work_order,
    om_mincut_hydrometer.hydrometer_id,
    ext_rtc_hydrometer.code AS hydrometer_customer_code,
    rtc_hydrometer_x_connec.connec_id,
    connec.code AS connec_code
   FROM selector_mincut_result,
    om_mincut_hydrometer
     JOIN ext_rtc_hydrometer ON om_mincut_hydrometer.hydrometer_id::text = ext_rtc_hydrometer.id::text
     JOIN rtc_hydrometer_x_connec ON om_mincut_hydrometer.hydrometer_id::text = rtc_hydrometer_x_connec.hydrometer_id::text
     JOIN connec ON rtc_hydrometer_x_connec.connec_id = connec.connec_id
     JOIN om_mincut ON om_mincut_hydrometer.result_id = om_mincut.id
  WHERE selector_mincut_result.result_id::text = om_mincut_hydrometer.result_id::text AND selector_mincut_result.cur_user = CURRENT_USER;

CREATE OR REPLACE VIEW v_edit_inp_curve
AS SELECT DISTINCT c.id,
    c.curve_type,
    c.descript,
    c.expl_id,
    c.log,
    c.active
   FROM selector_expl s,
    inp_curve c
  WHERE c.expl_id = s.expl_id AND s.cur_user = CURRENT_USER OR c.expl_id IS NULL
  ORDER BY c.id;

CREATE OR REPLACE VIEW v_edit_inp_pattern
AS SELECT DISTINCT
    p.pattern_id,
    p.pattern_type,
    p.observ,
    p.tscode,
    p.tsparameters::text AS tsparameters,
    p.expl_id,
    p.log,
    p.active
   FROM selector_expl s,
    inp_pattern p
  WHERE p.expl_id = s.expl_id AND s.cur_user = CURRENT_USER OR p.expl_id IS NULL
  ORDER BY p.pattern_id;

CREATE OR REPLACE VIEW v_edit_inp_pattern_value
AS SELECT DISTINCT inp_pattern_value.id,
    p.pattern_id,
    p.observ,
    p.tscode,
    p.tsparameters::text AS tsparameters,
    p.expl_id,
    inp_pattern_value.factor_1,
    inp_pattern_value.factor_2,
    inp_pattern_value.factor_3,
    inp_pattern_value.factor_4,
    inp_pattern_value.factor_5,
    inp_pattern_value.factor_6,
    inp_pattern_value.factor_7,
    inp_pattern_value.factor_8,
    inp_pattern_value.factor_9,
    inp_pattern_value.factor_10,
    inp_pattern_value.factor_11,
    inp_pattern_value.factor_12,
    inp_pattern_value.factor_13,
    inp_pattern_value.factor_14,
    inp_pattern_value.factor_15,
    inp_pattern_value.factor_16,
    inp_pattern_value.factor_17,
    inp_pattern_value.factor_18
   FROM selector_expl s,
    inp_pattern p
     JOIN inp_pattern_value USING (pattern_id)
  WHERE p.expl_id = s.expl_id AND s.cur_user = CURRENT_USER OR p.expl_id IS NULL
  ORDER BY inp_pattern_value.id;

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
  WHERE anl_arc.fid = selector_audit.fid AND selector_audit.cur_user = CURRENT_USER AND anl_arc.cur_user::name = "current_user"();

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
  WHERE anl_arc.fid = selector_audit.fid AND selector_audit.cur_user = CURRENT_USER AND anl_arc.cur_user::name = "current_user"();

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
  WHERE anl_arc_x_node.fid = selector_audit.fid AND selector_audit.cur_user = CURRENT_USER AND anl_arc_x_node.cur_user::name = "current_user"();

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
  WHERE anl_arc_x_node.fid = selector_audit.fid AND selector_audit.cur_user = CURRENT_USER AND anl_arc_x_node.cur_user::name = "current_user"();

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
  WHERE anl_connec.fid = selector_audit.fid AND selector_audit.cur_user = CURRENT_USER AND anl_connec.cur_user::name = "current_user"();

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
  WHERE anl_node.fid = selector_audit.fid AND selector_audit.cur_user = CURRENT_USER AND anl_node.cur_user::name = "current_user"();

CREATE OR REPLACE VIEW v_edit_anl_hydrant
AS SELECT anl_node.node_id,
    anl_node.nodecat_id,
    anl_node.expl_id,
    anl_node.the_geom
   FROM anl_node
  WHERE anl_node.fid = 468 AND anl_node.cur_user::name = "current_user"();

CREATE OR REPLACE VIEW vcp_pipes
AS SELECT p.arc_id,
    p.minorloss,
    p.dint,
    p.dscenario_id
   FROM config_param_user c,
    selector_inp_result r,
    rpt_inp_arc rpt
     JOIN inp_dscenario_pipe p ON rpt.arc_id = p.arc_id::text
  WHERE c.parameter::text = 'epatools_calibrator_dscenario_id'::text AND c.value = p.dscenario_id::text AND c.cur_user::text = CURRENT_USER AND r.result_id::text = rpt.result_id::text AND r.cur_user = CURRENT_USER;

CREATE OR REPLACE VIEW vcv_demands
AS SELECT inp.feature_id,
    inp.demand,
    inp.pattern_id,
    inp.source,
    inp.dscenario_id
   FROM config_param_user c,
    inp_dscenario_demand inp
  WHERE c.parameter::text = 'epatools_calibrator_dscenario_id'::text AND c.value = inp.dscenario_id::text AND c.cur_user::text = CURRENT_USER;


CREATE OR REPLACE VIEW v_rtc_hydrometer
AS SELECT ext_rtc_hydrometer.id::text AS hydrometer_id,
    ext_rtc_hydrometer.code AS hydrometer_customer_code,
        CASE
            WHEN connec.connec_id IS NULL THEN NULL::int4
            ELSE connec.connec_id
        END AS feature_id,
    'CONNEC'::text AS feature_type,
        CASE
            WHEN ext_rtc_hydrometer.connec_id IS NULL THEN 'XXXX'::text
            ELSE ext_rtc_hydrometer.connec_id
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
     JOIN connec ON connec.customer_code::text = ext_rtc_hydrometer.connec_id
     LEFT JOIN ext_municipality ON ext_municipality.muni_id = connec.muni_id
     LEFT JOIN exploitation ON exploitation.expl_id = connec.expl_id
  WHERE selector_hydrometer.state_id = ext_rtc_hydrometer.state_id AND selector_hydrometer.cur_user = CURRENT_USER AND selector_expl.expl_id = connec.expl_id AND selector_expl.cur_user = CURRENT_USER
UNION
 SELECT ext_rtc_hydrometer.id::text AS hydrometer_id,
    ext_rtc_hydrometer.code AS hydrometer_customer_code,
        CASE
            WHEN node.node_id IS NULL THEN NULL::int4
            ELSE node.node_id
        END AS feature_id,
    'NODE'::text AS feature_type,
        CASE
            WHEN ext_rtc_hydrometer.connec_id IS NULL THEN 'XXXX'::text
            ELSE ext_rtc_hydrometer.connec_id
        END AS customer_code,
    ext_rtc_hydrometer_state.name AS state,
    ext_municipality.name AS muni_name,
    node.expl_id,
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
     JOIN man_netwjoin ON man_netwjoin.customer_code::text = ext_rtc_hydrometer.connec_id::text
     JOIN node ON node.node_id = man_netwjoin.node_id
     LEFT JOIN ext_municipality ON ext_municipality.muni_id = node.muni_id
     LEFT JOIN exploitation ON exploitation.expl_id = node.expl_id
  WHERE selector_hydrometer.state_id = ext_rtc_hydrometer.state_id AND selector_hydrometer.cur_user = CURRENT_USER AND selector_expl.expl_id = node.expl_id AND selector_expl.cur_user = CURRENT_USER;


CREATE OR REPLACE VIEW v_rtc_hydrometer_x_node
AS SELECT ext_rtc_hydrometer.id::text AS hydrometer_id,
    ext_rtc_hydrometer.code AS hydrometer_customer_code,
        CASE
            WHEN node.node_id IS NULL THEN NULL::int4
            ELSE node.node_id
        END AS node_id,
        CASE
            WHEN ext_rtc_hydrometer.connec_id IS NULL THEN 'XXXX'::text
            ELSE ext_rtc_hydrometer.connec_id
        END AS node_customer_code,
    ext_rtc_hydrometer_state.name AS state,
    ext_municipality.name AS muni_name,
    node.expl_id,
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
     JOIN man_netwjoin ON man_netwjoin.customer_code::text = ext_rtc_hydrometer.connec_id::text
     JOIN node ON node.node_id = man_netwjoin.node_id
     LEFT JOIN ext_municipality ON ext_municipality.muni_id = node.muni_id
     LEFT JOIN exploitation ON exploitation.expl_id = node.expl_id
  WHERE selector_hydrometer.state_id = ext_rtc_hydrometer.state_id AND selector_hydrometer.cur_user = CURRENT_USER AND selector_expl.expl_id = node.expl_id AND selector_expl.cur_user = CURRENT_USER;


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



CREATE OR REPLACE VIEW v_ui_hydroval
 AS
 SELECT ext_rtc_hydrometer_x_data.id,
    rtc_hydrometer_x_node.node_id as feature_id,
    node.arc_id,
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
     JOIN rtc_hydrometer_x_node ON rtc_hydrometer_x_node.hydrometer_id::text = ext_rtc_hydrometer_x_data.hydrometer_id::text
     JOIN node ON rtc_hydrometer_x_node.node_id = node.node_id
     LEFT JOIN crm_typevalue crmtype ON ext_rtc_hydrometer_x_data.value_type = crmtype.id::integer AND crmtype.typevalue::text = 'crm_value_type'::text
     LEFT JOIN crm_typevalue crmstatus ON ext_rtc_hydrometer_x_data.value_status = crmstatus.id::integer AND crmstatus.typevalue::text = 'crm_value_status'::text
     LEFT JOIN crm_typevalue crmstate ON ext_rtc_hydrometer_x_data.value_state = crmstate.id::integer AND crmstate.typevalue::text = 'crm_value_state'::text
UNION
 SELECT ext_rtc_hydrometer_x_data.id,
    rtc_hydrometer_x_connec.connec_id,
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
     JOIN connec ON rtc_hydrometer_x_connec.connec_id = connec.connec_id
     LEFT JOIN crm_typevalue crmtype ON ext_rtc_hydrometer_x_data.value_type = crmtype.id::integer AND crmtype.typevalue::text = 'crm_value_type'::text
     LEFT JOIN crm_typevalue crmstatus ON ext_rtc_hydrometer_x_data.value_status = crmstatus.id::integer AND crmstatus.typevalue::text = 'crm_value_status'::text
     LEFT JOIN crm_typevalue crmstate ON ext_rtc_hydrometer_x_data.value_state = crmstate.id::integer AND crmstate.typevalue::text = 'crm_value_state'::text
  ORDER BY 1;


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
   FROM selector_expl s, rpt_cat_result
     LEFT JOIN inp_typevalue t1 ON rpt_cat_result.status::text = t1.id::text
     LEFT JOIN inp_typevalue t2 ON rpt_cat_result.network_type::text = t2.id::text
  WHERE t1.typevalue::text = 'inp_result_status'::text AND t2.typevalue::text = 'inp_options_networkmode'::text
  AND ((s.expl_id = ANY (rpt_cat_result.expl_id)) AND s.cur_user = CURRENT_USER OR rpt_cat_result.expl_id = ARRAY[NULL]::INTEGER[]);



CREATE VIEW v_price_x_arc AS
 SELECT arc.arc_id,
    cat_arc.id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    'element'::text AS identif
   FROM ((arc
     JOIN cat_arc ON (((cat_arc.id)::text = (arc.arccat_id)::text)))
     JOIN v_price_compost ON (((cat_arc.cost)::text = (v_price_compost.id)::text)))
UNION
 SELECT arc.arc_id,
    cat_arc.id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    'm2bottom'::text AS identif
   FROM ((arc
     JOIN cat_arc ON (((cat_arc.id)::text = (arc.arccat_id)::text)))
     JOIN v_price_compost ON (((cat_arc.m2bottom_cost)::text = (v_price_compost.id)::text)))
UNION
 SELECT arc.arc_id,
    cat_arc.id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    'm3protec'::text AS identif
   FROM ((arc
     JOIN cat_arc ON (((cat_arc.id)::text = (arc.arccat_id)::text)))
     JOIN v_price_compost ON (((cat_arc.m3protec_cost)::text = (v_price_compost.id)::text)))
UNION
 SELECT arc.arc_id,
    cat_soil.id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    'm3exc'::text AS identif
   FROM ((arc
     JOIN cat_soil ON (((cat_soil.id)::text = (arc.soilcat_id)::text)))
     JOIN v_price_compost ON (((cat_soil.m3exc_cost)::text = (v_price_compost.id)::text)))
UNION
 SELECT arc.arc_id,
    cat_soil.id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    'm3fill'::text AS identif
   FROM ((arc
     JOIN cat_soil ON (((cat_soil.id)::text = (arc.soilcat_id)::text)))
     JOIN v_price_compost ON (((cat_soil.m3fill_cost)::text = (v_price_compost.id)::text)))
UNION
 SELECT arc.arc_id,
    cat_soil.id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    'm3excess'::text AS identif
   FROM ((arc
     JOIN cat_soil ON (((cat_soil.id)::text = (arc.soilcat_id)::text)))
     JOIN v_price_compost ON (((cat_soil.m3excess_cost)::text = (v_price_compost.id)::text)))
UNION
 SELECT arc.arc_id,
    cat_soil.id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    'm2trenchl'::text AS identif
   FROM ((arc
     JOIN cat_soil ON (((cat_soil.id)::text = (arc.soilcat_id)::text)))
     JOIN v_price_compost ON (((cat_soil.m2trenchl_cost)::text = (v_price_compost.id)::text)))
UNION
 SELECT arc.arc_id,
    cat_pavement.id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    'pavement'::text AS identif
   FROM (((arc
     JOIN plan_arc_x_pavement ON (((plan_arc_x_pavement.arc_id)::text = (arc.arc_id)::text)))
     JOIN cat_pavement ON (((cat_pavement.id)::text = (plan_arc_x_pavement.pavcat_id)::text)))
     JOIN v_price_compost ON (((cat_pavement.m2_cost)::text = (v_price_compost.id)::text)))
  ORDER BY 1, 2;

CREATE OR REPLACE VIEW v_ui_event_x_arc
AS SELECT om_visit_event.id AS event_id,
    om_visit.id AS visit_id,
    om_visit.ext_code AS code,
    om_visit.visitcat_id,
    om_visit.startdate AS visit_start,
    om_visit.enddate AS visit_end,
    om_visit.user_name,
    om_visit.is_done,
    om_visit.class_id as visit_class,
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
     JOIN arc ON arc.arc_id = om_visit_x_arc.arc_id
     LEFT JOIN ( SELECT DISTINCT om_visit_event_photo.event_id
           FROM om_visit_event_photo) a ON a.event_id = om_visit_event.id
     LEFT JOIN ( SELECT DISTINCT doc_x_visit.visit_id
           FROM doc_x_visit) b ON b.visit_id = om_visit.id
  ORDER BY om_visit_x_arc.arc_id;

CREATE OR REPLACE VIEW v_ui_om_visit_x_arc AS
 SELECT om_visit_event.id AS event_id,
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
     JOIN arc ON arc.arc_id = om_visit_x_arc.arc_id
     LEFT JOIN ( SELECT DISTINCT om_visit_event_photo.event_id
           FROM om_visit_event_photo) a ON a.event_id = om_visit_event.id
     LEFT JOIN ( SELECT DISTINCT doc_x_visit.visit_id
           FROM doc_x_visit) b ON b.visit_id = om_visit.id
  ORDER BY om_visit_x_arc.arc_id;

CREATE OR REPLACE VIEW v_ui_event_x_link
AS SELECT om_visit_event.id AS event_id,
    om_visit.id AS visit_id,
    om_visit.ext_code AS code,
    om_visit.visitcat_id,
    om_visit.startdate AS visit_start,
    om_visit.enddate AS visit_end,
    om_visit.user_name,
    om_visit.is_done,
    om_visit.class_id as visit_class,
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
        END AS document
   FROM om_visit
     JOIN om_visit_event ON om_visit.id = om_visit_event.visit_id
     JOIN om_visit_x_link ON om_visit_x_link.visit_id = om_visit.id
     LEFT JOIN config_visit_parameter ON config_visit_parameter.id::text = om_visit_event.parameter_id::text
     JOIN link ON link.link_id = om_visit_x_link.link_id
     LEFT JOIN ( SELECT DISTINCT om_visit_event_photo.event_id
           FROM om_visit_event_photo) a ON a.event_id = om_visit_event.id
     LEFT JOIN ( SELECT DISTINCT doc_x_visit.visit_id
           FROM doc_x_visit) b ON b.visit_id = om_visit.id
  ORDER BY om_visit_x_link.link_id;

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
     LEFT JOIN config_visit_parameter ON config_visit_parameter.id::text = om_visit_event.parameter_id::text
     JOIN link ON link.link_id = om_visit_x_link.link_id
     LEFT JOIN ( SELECT DISTINCT om_visit_event_photo.event_id
           FROM om_visit_event_photo) a ON a.event_id = om_visit_event.id
     LEFT JOIN ( SELECT DISTINCT doc_x_visit.visit_id
           FROM doc_x_visit) b ON b.visit_id = om_visit.id
  ORDER BY om_visit_x_link.link_id;

CREATE OR REPLACE VIEW v_expl_connec
AS SELECT connec.connec_id
   FROM selector_expl,
    connec
  WHERE selector_expl.cur_user = CURRENT_USER AND connec.expl_id = selector_expl.expl_id;

CREATE OR REPLACE VIEW v_inp_pjointpattern
AS SELECT row_number() OVER (ORDER BY a.pattern_id, idrow) AS id,
    idrow,
        CASE
            WHEN pjoint_type::text = 'VNODE'::text THEN concat('VN', pattern_id)::character varying
            ELSE pattern_id::text
        END AS pattern_id,
    pjoint_type,
    sum(factor_1)::numeric(10,8) AS factor_1,
    sum(factor_2)::numeric(10,8) AS factor_2,
    sum(factor_3)::numeric(10,8) AS factor_3,
    sum(factor_4)::numeric(10,8) AS factor_4,
    sum(factor_5)::numeric(10,8) AS factor_5,
    sum(factor_6)::numeric(10,8) AS factor_6,
    sum(factor_7)::numeric(10,8) AS factor_7,
    sum(factor_8)::numeric(10,8) AS factor_8,
    sum(factor_9)::numeric(10,8) AS factor_9,
    sum(factor_10)::numeric(10,8) AS factor_10,
    sum(factor_11)::numeric(10,8) AS factor_11,
    sum(factor_12)::numeric(10,8) AS factor_12,
    sum(factor_13)::numeric(10,8) AS factor_13,
    sum(factor_14)::numeric(10,8) AS factor_14,
    sum(factor_15)::numeric(10,8) AS factor_15,
    sum(factor_16)::numeric(10,8) AS factor_16,
    sum(factor_17)::numeric(10,8) AS factor_17,
    sum(factor_18)::numeric(10,8) AS factor_18
   FROM ( SELECT c.pjoint_type,
                CASE
                    WHEN b.id = (( SELECT min(sub.id) AS min
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 1
                    WHEN b.id = (( SELECT min(sub.id) + 1
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 2
                    WHEN b.id = (( SELECT min(sub.id) + 2
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 3
                    WHEN b.id = (( SELECT min(sub.id) + 3
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 4
                    WHEN b.id = (( SELECT min(sub.id) + 4
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 5
                    WHEN b.id = (( SELECT min(sub.id) + 5
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 6
                    WHEN b.id = (( SELECT min(sub.id) + 6
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 7
                    WHEN b.id = (( SELECT min(sub.id) + 7
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 8
                    WHEN b.id = (( SELECT min(sub.id) + 8
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 9
                    WHEN b.id = (( SELECT min(sub.id) + 9
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 10
                    WHEN b.id = (( SELECT min(sub.id) + 10
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 11
                    WHEN b.id = (( SELECT min(sub.id) + 11
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 12
                    WHEN b.id = (( SELECT min(sub.id) + 12
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 13
                    WHEN b.id = (( SELECT min(sub.id) + 13
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 14
                    WHEN b.id = (( SELECT min(sub.id) + 14
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 15
                    WHEN b.id = (( SELECT min(sub.id) + 15
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 16
                    WHEN b.id = (( SELECT min(sub.id) + 16
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 17
                    WHEN b.id = (( SELECT min(sub.id) + 17
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 18
                    WHEN b.id = (( SELECT min(sub.id) + 18
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 19
                    WHEN b.id = (( SELECT min(sub.id) + 19
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 20
                    WHEN b.id = (( SELECT min(sub.id) + 20
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 21
                    WHEN b.id = (( SELECT min(sub.id) + 21
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 22
                    WHEN b.id = (( SELECT min(sub.id) + 22
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 23
                    WHEN b.id = (( SELECT min(sub.id) + 23
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 24
                    WHEN b.id = (( SELECT min(sub.id) + 24
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 25
                    WHEN b.id = (( SELECT min(sub.id) + 25
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 26
                    WHEN b.id = (( SELECT min(sub.id) + 26
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 27
                    WHEN b.id = (( SELECT min(sub.id) + 27
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 28
                    WHEN b.id = (( SELECT min(sub.id) + 28
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 29
                    WHEN b.id = (( SELECT min(sub.id) + 29
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 30
                    ELSE NULL::integer
                END AS idrow,
            c.pjoint_id AS pattern_id,
            sum(c.demand::double precision * b.factor_1::double precision) AS factor_1,
            sum(c.demand::double precision * b.factor_2::double precision) AS factor_2,
            sum(c.demand::double precision * b.factor_3::double precision) AS factor_3,
            sum(c.demand::double precision * b.factor_4::double precision) AS factor_4,
            sum(c.demand::double precision * b.factor_5::double precision) AS factor_5,
            sum(c.demand::double precision * b.factor_6::double precision) AS factor_6,
            sum(c.demand::double precision * b.factor_7::double precision) AS factor_7,
            sum(c.demand::double precision * b.factor_8::double precision) AS factor_8,
            sum(c.demand::double precision * b.factor_9::double precision) AS factor_9,
            sum(c.demand::double precision * b.factor_10::double precision) AS factor_10,
            sum(c.demand::double precision * b.factor_11::double precision) AS factor_11,
            sum(c.demand::double precision * b.factor_12::double precision) AS factor_12,
            sum(c.demand::double precision * b.factor_13::double precision) AS factor_13,
            sum(c.demand::double precision * b.factor_14::double precision) AS factor_14,
            sum(c.demand::double precision * b.factor_15::double precision) AS factor_15,
            sum(c.demand::double precision * b.factor_16::double precision) AS factor_16,
            sum(c.demand::double precision * b.factor_17::double precision) AS factor_17,
            sum(c.demand::double precision * b.factor_18::double precision) AS factor_18
           FROM ( SELECT inp_connec.connec_id,
                    inp_connec.demand,
                    inp_connec.pattern_id,
                    connec.pjoint_id,
                    connec.pjoint_type
                   FROM inp_connec
                     JOIN connec USING (connec_id)) c
             JOIN inp_pattern_value b USING (pattern_id)
          GROUP BY c.pjoint_type, c.pjoint_id, (
                CASE
                    WHEN b.id = (( SELECT min(sub.id) AS min
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 1
                    WHEN b.id = (( SELECT min(sub.id) + 1
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 2
                    WHEN b.id = (( SELECT min(sub.id) + 2
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 3
                    WHEN b.id = (( SELECT min(sub.id) + 3
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 4
                    WHEN b.id = (( SELECT min(sub.id) + 4
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 5
                    WHEN b.id = (( SELECT min(sub.id) + 5
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 6
                    WHEN b.id = (( SELECT min(sub.id) + 6
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 7
                    WHEN b.id = (( SELECT min(sub.id) + 7
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 8
                    WHEN b.id = (( SELECT min(sub.id) + 8
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 9
                    WHEN b.id = (( SELECT min(sub.id) + 9
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 10
                    WHEN b.id = (( SELECT min(sub.id) + 10
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 11
                    WHEN b.id = (( SELECT min(sub.id) + 11
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 12
                    WHEN b.id = (( SELECT min(sub.id) + 12
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 13
                    WHEN b.id = (( SELECT min(sub.id) + 13
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 14
                    WHEN b.id = (( SELECT min(sub.id) + 14
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 15
                    WHEN b.id = (( SELECT min(sub.id) + 15
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 16
                    WHEN b.id = (( SELECT min(sub.id) + 16
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 17
                    WHEN b.id = (( SELECT min(sub.id) + 17
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 18
                    WHEN b.id = (( SELECT min(sub.id) + 18
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 19
                    WHEN b.id = (( SELECT min(sub.id) + 19
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 20
                    WHEN b.id = (( SELECT min(sub.id) + 20
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 21
                    WHEN b.id = (( SELECT min(sub.id) + 21
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 22
                    WHEN b.id = (( SELECT min(sub.id) + 22
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 23
                    WHEN b.id = (( SELECT min(sub.id) + 23
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 24
                    WHEN b.id = (( SELECT min(sub.id) + 24
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 25
                    WHEN b.id = (( SELECT min(sub.id) + 25
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 26
                    WHEN b.id = (( SELECT min(sub.id) + 26
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 27
                    WHEN b.id = (( SELECT min(sub.id) + 27
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 28
                    WHEN b.id = (( SELECT min(sub.id) + 28
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 29
                    WHEN b.id = (( SELECT min(sub.id) + 29
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 30
                    ELSE NULL::integer
                END)) a
  GROUP BY idrow, pattern_id, pjoint_type;

CREATE OR REPLACE VIEW v_plan_psector_link
AS SELECT row_number() OVER () AS rid,
    link.link_id,
    plan_psector_x_connec.psector_id,
    connec.connec_id,
    connec.state AS original_state,
    connec.state_type AS original_state_type,
    plan_psector_x_connec.state AS plan_state,
    plan_psector_x_connec.doable,
    plan_psector.priority AS psector_priority,
    link.the_geom
   FROM selector_psector,
    connec
     JOIN plan_psector_x_connec USING (connec_id)
     JOIN plan_psector USING (psector_id)
     JOIN link ON link.feature_id = connec.connec_id
  WHERE plan_psector_x_connec.psector_id = selector_psector.psector_id AND selector_psector.cur_user = CURRENT_USER;


CREATE OR REPLACE VIEW v_rtc_hydrometer_x_connec
AS SELECT ext_rtc_hydrometer.id::text AS hydrometer_id,
    ext_rtc_hydrometer.code AS hydrometer_customer_code,
        CASE
            WHEN connec.connec_id IS NULL THEN NULL::int4
            ELSE connec.connec_id
        END AS connec_id,
        CASE
            WHEN ext_rtc_hydrometer.connec_id IS NULL THEN 'XXXX'::text
            ELSE ext_rtc_hydrometer.connec_id
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
        END AS hydrometer_link,
    ext_rtc_hydrometer_state.is_operative,
    ext_rtc_hydrometer.shutdown_date
   FROM selector_hydrometer,
    selector_expl,
    rtc_hydrometer
     LEFT JOIN ext_rtc_hydrometer ON ext_rtc_hydrometer.id::text = rtc_hydrometer.hydrometer_id::text
     JOIN ext_rtc_hydrometer_state ON ext_rtc_hydrometer_state.id = ext_rtc_hydrometer.state_id
     JOIN connec ON connec.customer_code::text = ext_rtc_hydrometer.connec_id
     LEFT JOIN ext_municipality ON ext_municipality.muni_id = connec.muni_id
     LEFT JOIN exploitation ON exploitation.expl_id = connec.expl_id
  WHERE selector_hydrometer.state_id = ext_rtc_hydrometer.state_id AND selector_hydrometer.cur_user = CURRENT_USER AND selector_expl.expl_id = connec.expl_id AND selector_expl.cur_user = CURRENT_USER;


CREATE OR REPLACE VIEW v_ui_hydroval_x_connec
AS SELECT ext_rtc_hydrometer_x_data.id,
    rtc_hydrometer_x_connec.connec_id,
    connec.arc_id,
    ext_rtc_hydrometer_x_data.hydrometer_id,
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
     JOIN connec ON rtc_hydrometer_x_connec.connec_id = connec.connec_id
     LEFT JOIN crm_typevalue crmtype ON ext_rtc_hydrometer_x_data.value_type = crmtype.id::integer AND crmtype.typevalue::text = 'crm_value_type'::text
     LEFT JOIN crm_typevalue crmstatus ON ext_rtc_hydrometer_x_data.value_status = crmstatus.id::integer AND crmstatus.typevalue::text = 'crm_value_status'::text
     LEFT JOIN crm_typevalue crmstate ON ext_rtc_hydrometer_x_data.value_state = crmstate.id::integer AND crmstate.typevalue::text = 'crm_value_state'::text
  ORDER BY ext_rtc_hydrometer_x_data.id;

CREATE OR REPLACE VIEW v_ui_om_visit_x_connec
AS SELECT om_visit_event.id AS event_id,
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
     LEFT JOIN connec ON connec.connec_id = om_visit_x_connec.connec_id
     LEFT JOIN ( SELECT DISTINCT om_visit_event_photo.event_id
           FROM om_visit_event_photo) a ON a.event_id = om_visit_event.id
     LEFT JOIN ( SELECT DISTINCT doc_x_visit.visit_id
           FROM doc_x_visit) b ON b.visit_id = om_visit.id
  ORDER BY om_visit_x_connec.connec_id;

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
     LEFT JOIN connec ON connec.connec_id = om_visit_x_connec.connec_id
     LEFT JOIN ( SELECT DISTINCT om_visit_event_photo.event_id
           FROM om_visit_event_photo) a ON a.event_id = om_visit_event.id
     LEFT JOIN ( SELECT DISTINCT doc_x_visit.visit_id
           FROM doc_x_visit) b ON b.visit_id = om_visit.id
  ORDER BY om_visit_x_connec.connec_id;

CREATE OR REPLACE VIEW v_om_mincut_current_hydrometer
AS SELECT om_mincut_hydrometer.id,
    om_mincut_hydrometer.result_id,
    om_mincut.work_order,
    om_mincut_hydrometer.hydrometer_id,
    ext_rtc_hydrometer.code AS hydrometer_customer_code,
    rtc_hydrometer_x_connec.connec_id,
    connec.code AS connec_code
   FROM om_mincut_hydrometer
     JOIN ext_rtc_hydrometer ON om_mincut_hydrometer.hydrometer_id::text = ext_rtc_hydrometer.id::text
     JOIN rtc_hydrometer_x_connec ON om_mincut_hydrometer.hydrometer_id::text = rtc_hydrometer_x_connec.hydrometer_id::text
     JOIN connec ON rtc_hydrometer_x_connec.connec_id = connec.connec_id
     JOIN om_mincut ON om_mincut_hydrometer.result_id = om_mincut.id
  WHERE om_mincut.mincut_state = 1;


CREATE OR REPLACE VIEW v_edit_plan_psector_x_connec
AS SELECT plan_psector_x_connec.id,
    plan_psector_x_connec.connec_id,
    plan_psector_x_connec.arc_id,
    plan_psector_x_connec.psector_id,
    plan_psector_x_connec.state,
    plan_psector_x_connec.doable,
    plan_psector_x_connec.descript,
    plan_psector_x_connec.link_id,
    plan_psector_x_connec.active,
    plan_psector_x_connec.insert_tstamp,
    plan_psector_x_connec.insert_user,
    link.exit_type
   FROM plan_psector_x_connec
     LEFT JOIN link USING (link_id);

CREATE OR REPLACE VIEW v_ui_om_visitman_x_link
AS SELECT DISTINCT ON (v_ui_om_visit_x_link.visit_id) v_ui_om_visit_x_link.visit_id,
    v_ui_om_visit_x_link.code,
    om_visit_cat.name AS visitcat_name,
    v_ui_om_visit_x_link.link_id,
    date_trunc('second'::text, v_ui_om_visit_x_link.visit_start) AS visit_start,
    date_trunc('second'::text, v_ui_om_visit_x_link.visit_end) AS visit_end,
    v_ui_om_visit_x_link.user_name,
    v_ui_om_visit_x_link.is_done,
    v_ui_om_visit_x_link.feature_type,
    v_ui_om_visit_x_link.form_type
   FROM v_ui_om_visit_x_link
     LEFT JOIN om_visit_cat ON om_visit_cat.id = v_ui_om_visit_x_link.visitcat_id;

-- 

-- =========================
-- MAPZONES VIEWS: (v_edit_* & v_ui_*)
-- =========================
-- with the_geom and without active
CREATE OR REPLACE VIEW v_edit_presszone
AS SELECT  p.presszone_id,
    p.code,
    p.name,
    p.presszone_type,
    p.descript,
    p.graphconfig,
    p.stylesheet,
    p.head,
    p.avg_press,
    p.link,
    p.muni_id,
    p.expl_id,
    p.sector_id,
    p.lock_level,
    p.the_geom,
    p.created_at,
    p.created_by,
    p.updated_at,
    p.updated_by
   FROM selector_expl se, presszone p
  WHERE se.expl_id = ANY(p.expl_id) AND se.cur_user = CURRENT_USER OR p.expl_id IS NULL
  ORDER BY p.presszone_id;

CREATE OR REPLACE VIEW v_edit_dma
AS SELECT d.dma_id,
    d.code,
    d.name,
    d.dma_type,
    d.macrodma_id,
    d.descript,
    d.graphconfig,
    d.stylesheet,
    d.pattern_id,
    d.minc,
    d.maxc,
    d.effc,
    d.avg_press,
    d.link,
    d.muni_id,
    d.expl_id,
    d.sector_id,
    d.lock_level,
    d.the_geom,
    d.created_at,
    d.created_by,
    d.updated_at,
    d.updated_by
  FROM selector_expl se, dma d
  WHERE se.expl_id = ANY(d.expl_id) AND se.cur_user = CURRENT_USER OR d.expl_id IS NULL
  ORDER BY d.dma_id;

CREATE OR REPLACE VIEW v_edit_dqa
AS SELECT d.dqa_id,
    d.code,
    d.name,
    d.dqa_type,
    d.descript,
    d.macrodqa_id,
    d.graphconfig,
    d.stylesheet,
    d.pattern_id,
    d.avg_press,
    d.link,
    d.muni_id,
    d.expl_id,
    d.sector_id,
    d.lock_level,
    d.the_geom,
    d.created_at,
    d.created_by,
    d.updated_at,
    d.updated_by
   FROM selector_expl se, dqa d
  WHERE se.expl_id = ANY(d.expl_id) AND se.cur_user = CURRENT_USER OR d.expl_id IS NULL
  ORDER BY d.dqa_id;

CREATE OR REPLACE VIEW v_edit_sector
AS SELECT s.sector_id,
    s.code,
    s.name,
    s.descript,
    s.sector_type,
    s.graphconfig,
    s.stylesheet,
    s.avg_press,
    s.link,
    s.muni_id,
    s.expl_id,
    s.macrosector_id,
    s.parent_id,
    s.pattern_id,
    et.idval,
    s.lock_level,
    s.the_geom,
    s.created_at,
    s.created_by,
    s.updated_at,
    s.updated_by
  FROM selector_sector ss, sector s
  LEFT JOIN edit_typevalue et ON et.id::text = s.sector_type::text AND et.typevalue::text = 'sector_type'::text
  WHERE s.sector_id = ss.sector_id AND ss.cur_user = CURRENT_USER;

CREATE OR REPLACE VIEW v_edit_supplyzone
AS SELECT s.supplyzone_id,
    s.name,
    s.descript,
    s.supplyzone_type,
    s.graphconfig::text AS graphconfig,
    s.stylesheet,
    s.parent_id,
    s.pattern_id,
	  s.avg_press,
	  s.link,
    s.muni_id,
    s.expl_id,
    et.idval,
    s.lock_level,
	  s.the_geom,
    s.created_at,
    s.created_by,
    s.updated_at,
    s.updated_by
  FROM supplyzone s
  LEFT JOIN edit_typevalue et ON et.id::text = s.supplyzone_type::text AND et.typevalue::text = 'supplyzone_type'::text
  WHERE s.supplyzone_id > 0;

CREATE OR REPLACE VIEW v_edit_omzone
AS SELECT o.omzone_id,
    o.name,
    o.descript,
    o.omzone_type,
    o.muni_id,
    o.expl_id,
    o.macroomzone_id,
    o.link,
    et.idval,
    o.lock_level,
    o.the_geom,
    o.created_at,
    o.created_by,
    o.updated_at,
    o.updated_by
  FROM omzone o
  LEFT JOIN edit_typevalue et ON et.id::text = o.omzone_type::text AND et.typevalue::text = 'omzone_type'::text
  WHERE o.omzone_id > 0
  AND o.active IS true;

CREATE OR REPLACE VIEW v_edit_exploitation
AS SELECT e.expl_id,
    e.code,
    e.name,
    e.macroexpl_id,
    e.sector_id,
    e.muni_id,
    e.owner_vdefault,
    e.descript,
    e.lock_level,
    e.active,
    e.the_geom,
    e.created_at,
    e.created_by,
    e.updated_at,
    e.updated_by
  FROM selector_expl se, exploitation e
  WHERE (e.expl_id = se.expl_id AND se.cur_user = CURRENT_USER)
  AND e.active IS true;

CREATE OR REPLACE VIEW v_edit_macrodma
AS SELECT DISTINCT ON (macrodma_id) macrodma_id,
    m.code,
    m.name,
    m.descript,
    m.expl_id,
    m.lock_level,
    m.the_geom,
    m.created_at,
    m.created_by,
    m.updated_at,
    m.updated_by
  FROM selector_expl se, macrodma m
  WHERE se.expl_id = ANY(m.expl_id) AND se.cur_user = CURRENT_USER
  AND m.active IS true;

CREATE OR REPLACE VIEW v_edit_macrodqa
AS SELECT DISTINCT ON (macrodqa_id) macrodqa_id,
    m.code,
    m.name,
    m.descript,
    m.expl_id,
    m.lock_level,
    m.the_geom,
    m.created_at,
    m.created_by,
    m.updated_at,
    m.updated_by
  FROM selector_expl se, macrodqa m
  WHERE se.expl_id = ANY(m.expl_id) AND se.cur_user = CURRENT_USER
  AND m.active IS true;

CREATE OR REPLACE VIEW v_edit_macrosector
AS SELECT DISTINCT ON (macrosector_id) macrosector_id,
    m.code,
    m.name,
    m.descript,
    m.lock_level,
    m.the_geom,
    m.created_at,
    m.created_by,
    m.updated_at,
    m.updated_by
  FROM selector_sector ss, macrosector m
  LEFT JOIN sector s USING (macrosector_id)
  WHERE (ss.sector_id = s.sector_id AND ss.cur_user = CURRENT_USER OR s.macrosector_id IS NULL)
  AND m.active IS true;

CREATE OR REPLACE VIEW v_edit_macroomzone
AS SELECT DISTINCT ON (macroomzone_id) macroomzone_id,
    m.code,
    m.name,
    m.descript,
    m.expl_id,
    m.lock_level,
    m.the_geom,
    m.created_at,
    m.created_by,
    m.updated_at,
    m.updated_by
  FROM selector_expl se, macroomzone m
  LEFT JOIN omzone o USING (macroomzone_id)
  WHERE se.expl_id = ANY(m.expl_id) AND se.cur_user = CURRENT_USER OR o.macroomzone_id IS NULL
  AND m.active IS true;

CREATE OR REPLACE VIEW v_edit_macroexploitation
AS SELECT DISTINCT ON (macroexpl_id) macroexpl_id,
    m.code,
    m.name,
    m.descript,
    m.lock_level,
    m.the_geom,
    m.created_at,
    m.created_by,
    m.updated_at,
    m.updated_by
  FROM selector_expl se, macroexploitation m
  JOIN exploitation e USING (macroexpl_id)
  WHERE (e.expl_id = se.expl_id AND se.cur_user = CURRENT_USER)
  AND m.active IS true;

-- with active and without the_geom
CREATE OR REPLACE VIEW v_ui_presszone
AS SELECT DISTINCT ON (p.presszone_id) p.presszone_id,
    p.code,
    p.name,
    p.descript,
    p.presszone_type,
    p.graphconfig,
    p.stylesheet,
    p.head,
    p.avg_press,
    p.link,
    p.muni_id,
    p.expl_id,
    p.sector_id,
    p.lock_level,
    p.active,
    p.created_at,
    p.created_by,
    p.updated_at,
    p.updated_by
  FROM selector_expl se, presszone p
  WHERE p.presszone_id > 0
  ORDER BY p.presszone_id;

CREATE OR REPLACE VIEW v_ui_dma
AS SELECT DISTINCT ON (d.dma_id) d.dma_id,
    d.code,
    d.name,
    d.descript,
    d.dma_type,
    md.name AS macrodma,
    d.graphconfig,
    d.stylesheet,
    d.pattern_id,
    d.minc,
    d.maxc,
    d.effc,
    d.avg_press,
    d.link,
    d.muni_id,
    d.expl_id,
    d.sector_id,
    d.lock_level,
    d.active,
    d.created_at,
    d.created_by,
    d.updated_at,
    d.updated_by
  FROM selector_expl se, dma d
  LEFT JOIN macrodma md USING (macrodma_id)
  WHERE d.dma_id > 0
  ORDER BY d.dma_id;

CREATE OR REPLACE VIEW v_ui_dqa
AS SELECT DISTINCT ON (d.dqa_id) d.dqa_id,
    d.code,
    d.name,
    d.descript,
    d.dqa_type,
    md.name AS macrodqa,
    d.graphconfig,
    d.stylesheet,
    d.pattern_id,
    d.avg_press,
    d.link,
    d.muni_id,
    d.expl_id,
    d.sector_id,
    d.lock_level,
    d.active,
    d.created_at,
    d.created_by,
    d.updated_at,
    d.updated_by
  FROM selector_expl se, dqa d
  LEFT JOIN macrodqa md USING (macrodqa_id)
  WHERE d.dqa_id > 0
  ORDER BY d.dqa_id;

CREATE OR REPLACE VIEW v_ui_sector
AS SELECT DISTINCT ON (s.sector_id) s.sector_id,
    s.code,
    s.name,
    s.descript,
    s.sector_type,
    ms.name AS macrosector,
    s.graphconfig,
    s.stylesheet,
    s.parent_id,
    s.pattern_id,
    s.avg_press,
    s.link,
    s.muni_id,
    s.expl_id,
    s.active,
    s.lock_level,
    s.created_at,
    s.created_by,
    s.updated_at,
    s.updated_by
  FROM selector_sector ss, sector s
  LEFT JOIN macrosector ms USING (macrosector_id)
  WHERE s.sector_id > 0
  ORDER BY s.sector_id;

CREATE OR REPLACE VIEW v_ui_supplyzone
AS SELECT DISTINCT ON (s.supplyzone_id) s.supplyzone_id,
    s.code,
    s.name,
    s.descript,
    s.supplyzone_type,
    s.graphconfig,
    s.stylesheet,
    s.parent_id,
    s.pattern_id,
	  s.avg_press,
	  s.link,
    s.muni_id,
    s.expl_id,
    s.lock_level,
    s.active,
    s.created_at,
    s.created_by,
    s.updated_at,
    s.updated_by
  FROM supplyzone s
  WHERE s.supplyzone_id > 0
  ORDER BY s.supplyzone_id;

CREATE OR REPLACE VIEW v_ui_omzone
AS SELECT DISTINCT ON (o.omzone_id) o.omzone_id,
    o.name,
    o.descript,
    o.omzone_type,
    mo.name AS macroomzone,
    o.muni_id,
    o.expl_id,
    o.link,
    o.lock_level,
    o.active,
    o.created_at,
    o.created_by,
    o.updated_at,
    o.updated_by
  FROM omzone o
  LEFT JOIN macroomzone mo USING (macroomzone_id)
  WHERE o.omzone_id > 0
  ORDER BY o.omzone_id;

CREATE OR REPLACE VIEW v_ui_macrodma
AS SELECT DISTINCT ON (m.macrodma_id) m.macrodma_id,
    m.code,
    m.name,
    m.descript,
    m.expl_id,
    m.active,
    m.lock_level,
    m.created_at,
    m.created_by,
    m.updated_at,
    m.updated_by
  FROM selector_expl se, macrodma m
  WHERE m.macrodma_id > 0
  ORDER BY m.macrodma_id;

CREATE OR REPLACE VIEW v_ui_macrodqa
AS SELECT DISTINCT ON (m.macrodqa_id) m.macrodqa_id,
    m.code,
    m.name,
    m.descript,
    m.expl_id,
    m.active,
    m.lock_level,
    m.created_at,
    m.created_by,
    m.updated_at,
    m.updated_by
  FROM selector_expl se, macrodqa m
  WHERE m.macrodqa_id > 0
  ORDER BY m.macrodqa_id;

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
  FROM selector_sector ss, macrosector m
  WHERE m.macrosector_id > 0
  ORDER BY m.macrosector_id;

CREATE OR REPLACE VIEW v_ui_macroomzone
AS SELECT DISTINCT ON (m.macroomzone_id) m.macroomzone_id,
    m.code,
    m.name,
    m.descript,
    m.expl_id,
    m.active,
    m.lock_level,
    m.created_at,
    m.created_by,
    m.updated_at,
    m.updated_by
  FROM macroomzone m
  WHERE m.macroomzone_id > 0
  ORDER BY m.macroomzone_id;

CREATE OR REPLACE VIEW v_om_mincut
AS SELECT om_mincut.id,
    om_mincut.work_order,
    a.idval AS state,
    b.idval AS class,
    om_mincut.mincut_type,
    om_mincut.received_date,
    om_mincut.expl_id,
    exploitation.name AS expl_name,
    macroexploitation.name AS macroexpl_name,
    om_mincut.macroexpl_id,
    om_mincut.muni_id,
    ext_municipality.name AS muni_name,
    om_mincut.postcode,
    om_mincut.streetaxis_id,
    ext_streetaxis.name AS street_name,
    om_mincut.postnumber,
    c.idval AS anl_cause,
    om_mincut.anl_tstamp,
    om_mincut.anl_user,
    om_mincut.anl_descript,
    om_mincut.anl_feature_id,
    om_mincut.anl_feature_type,
    om_mincut.anl_the_geom,
    om_mincut.forecast_start,
    om_mincut.forecast_end,
    om_mincut.assigned_to,
    om_mincut.exec_start,
    om_mincut.exec_end,
    om_mincut.exec_user,
    om_mincut.exec_descript,
    om_mincut.exec_the_geom,
    om_mincut.exec_from_plot,
    om_mincut.exec_depth,
    om_mincut.exec_appropiate,
    om_mincut.chlorine,
    om_mincut.turbidity,
    om_mincut.notified,
    om_mincut.output
   FROM selector_mincut_result,
    om_mincut
     LEFT JOIN om_typevalue a ON a.id::integer = om_mincut.mincut_state AND a.typevalue = 'mincut_state'::text
     LEFT JOIN om_typevalue b ON b.id::integer = om_mincut.mincut_class AND b.typevalue = 'mincut_class'::text
     LEFT JOIN om_typevalue c ON c.id::integer = om_mincut.anl_cause::integer AND c.typevalue = 'mincut_cause'::text
     LEFT JOIN exploitation ON om_mincut.expl_id = exploitation.expl_id
     LEFT JOIN ext_streetaxis ON om_mincut.streetaxis_id::text = ext_streetaxis.id::text
     LEFT JOIN macroexploitation ON om_mincut.macroexpl_id = macroexploitation.macroexpl_id
     LEFT JOIN ext_municipality ON om_mincut.muni_id = ext_municipality.muni_id
  WHERE selector_mincut_result.result_id = om_mincut.id AND selector_mincut_result.cur_user = "current_user"()::text AND om_mincut.id > 0;

CREATE OR REPLACE VIEW v_om_mincut_initpoint
AS SELECT om_mincut.id,
    om_mincut.work_order,
    a.idval AS state,
    b.idval AS class,
    om_mincut.mincut_type,
    om_mincut.received_date,
    om_mincut.expl_id,
    exploitation.name AS expl_name,
    macroexploitation.name AS macroexpl_name,
    om_mincut.macroexpl_id,
    om_mincut.muni_id,
    ext_municipality.name AS muni_name,
    om_mincut.postcode,
    om_mincut.streetaxis_id,
    ext_streetaxis.name AS street_name,
    om_mincut.postnumber,
    c.idval AS anl_cause,
    om_mincut.anl_tstamp,
    om_mincut.anl_user,
    om_mincut.anl_descript,
    om_mincut.anl_feature_id,
    om_mincut.anl_feature_type,
    om_mincut.anl_the_geom,
    om_mincut.forecast_start,
    om_mincut.forecast_end,
    om_mincut.assigned_to,
    om_mincut.exec_start,
    om_mincut.exec_end,
    om_mincut.exec_user,
    om_mincut.exec_descript,
    om_mincut.exec_from_plot,
    om_mincut.exec_depth,
    om_mincut.exec_appropiate,
    om_mincut.notified,
    om_mincut.output
   FROM selector_mincut_result,
    om_mincut
     LEFT JOIN om_typevalue a ON a.id::integer = om_mincut.mincut_state AND a.typevalue = 'mincut_state'::text
     LEFT JOIN om_typevalue b ON b.id::integer = om_mincut.mincut_class AND b.typevalue = 'mincut_class'::text
     LEFT JOIN om_typevalue c ON c.id::integer = om_mincut.anl_cause::integer AND c.typevalue = 'mincut_cause'::text
     LEFT JOIN exploitation ON om_mincut.expl_id = exploitation.expl_id
     LEFT JOIN ext_streetaxis ON om_mincut.streetaxis_id::text = ext_streetaxis.id::text
     LEFT JOIN macroexploitation ON om_mincut.macroexpl_id = macroexploitation.macroexpl_id
     LEFT JOIN ext_municipality ON om_mincut.muni_id = ext_municipality.muni_id
  WHERE selector_mincut_result.result_id = om_mincut.id AND selector_mincut_result.cur_user = "current_user"()::text AND om_mincut.id > 0;



DROP VIEW IF EXISTS v_om_waterbalance;
DROP VIEW IF EXISTS v_om_waterbalance_report;
ALTER TABLE om_waterbalance DROP CONSTRAINT om_waterbalance_expl_id_fkey;
ALTER TABLE om_waterbalance ALTER COLUMN expl_id TYPE integer[] USING ARRAY[expl_id];

 CREATE OR REPLACE VIEW v_om_waterbalance AS
SELECT e.name AS exploitation,
    d.name AS dma,
    p.code AS period,
    om_waterbalance.auth_bill,
    om_waterbalance.auth_unbill,
    om_waterbalance.loss_app,
    om_waterbalance.loss_real,
    om_waterbalance.total_in,
    om_waterbalance.total_out,
    om_waterbalance.total,
    om_waterbalance.startdate,
    om_waterbalance.enddate,
    om_waterbalance.ili,
    om_waterbalance.auth,
    om_waterbalance.loss,
        CASE
            WHEN om_waterbalance.total > 0::double precision THEN (100::numeric::double precision * (om_waterbalance.auth_bill + om_waterbalance.auth_unbill) / om_waterbalance.total)::numeric(20,2)
            ELSE 0::numeric(20,2)
        END AS loss_eff,
    om_waterbalance.auth_bill AS rw,
    (om_waterbalance.total - om_waterbalance.auth_bill)::numeric(20,2) AS nrw,
        CASE
            WHEN om_waterbalance.total > 0::double precision THEN (100::numeric::double precision * om_waterbalance.auth_bill / om_waterbalance.total)::numeric(20,2)
            ELSE 0::numeric(20,2)
        END AS nrw_eff,
    d.the_geom
   FROM exploitation e, om_waterbalance
     JOIN dma d USING (dma_id)
     LEFT JOIN ext_cat_period p ON p.id::text = om_waterbalance.cat_period_id::text
	 where e.expl_id = any(d.expl_id);



CREATE OR REPLACE VIEW v_om_waterbalance_report
AS WITH expl_data AS (
         SELECT sum(w_1.auth) / sum(w_1.total) AS expl_rw_eff,
            1::double precision - sum(w_1.auth) / sum(w_1.total) AS expl_nrw_eff,
            NULL::text AS expl_nightvol,
                CASE
                    WHEN sum(w_1.arc_length) = 0::double precision THEN NULL::double precision
                    ELSE sum(w_1.nrw) / sum(w_1.arc_length) / (date_part('epoch'::text, age(p_1.end_date, p_1.start_date)) / 3600::numeric::double precision)
                END AS expl_m4day,
                CASE
                    WHEN sum(w_1.arc_length) = 0::double precision AND sum(w_1.n_connec) = 0 AND sum(w_1.link_length) = 0::double precision THEN NULL::double precision
                    ELSE sum(w_1.loss) * (365::numeric::double precision / date_part('day'::text, p_1.end_date - p_1.start_date)) / (6.57::double precision * sum(w_1.arc_length) + 9.13::double precision * sum(w_1.link_length) + (0.256 * sum(w_1.n_connec)::numeric * avg(d_1.avg_press))::double precision)
                END AS expl_ili,
            w_1.expl_id,
            w_1.cat_period_id,
            p_1.start_date
           FROM om_waterbalance w_1
             JOIN ext_cat_period p_1 ON w_1.cat_period_id::text = p_1.id::text
             JOIN dma d_1 ON d_1.dma_id = w_1.dma_id
          GROUP BY w_1.expl_id, w_1.cat_period_id, p_1.end_date, p_1.start_date
        )
 SELECT DISTINCT ex.name AS exploitation,
    ex.expl_id,
    d.name AS dma,
    w.dma_id,
    w.cat_period_id,
    p.code AS period,
    p.start_date,
    p.end_date,
    w.meters_in,
    w.meters_out,
    w.n_connec,
    w.n_hydro,
    w.arc_length,
    w.link_length,
    w.total_in,
    w.total_out,
    w.total,
    w.auth,
    w.nrw,
        CASE
            WHEN w.total <> 0::double precision THEN w.auth / w.total
            ELSE NULL::double precision
        END AS dma_rw_eff,
        CASE
            WHEN w.total <> 0::double precision THEN 1::double precision - w.auth / w.total
            ELSE NULL::double precision
        END AS dma_nrw_eff,
    w.ili AS dma_ili,
    NULL::text AS dma_nightvol,
    w.nrw / w.arc_length / (date_part('epoch'::text, age(p.end_date, p.start_date)) / 3600::numeric::double precision) AS dma_m4day,
    ed.expl_rw_eff,
    ed.expl_nrw_eff,
    ed.expl_nightvol,
    ed.expl_ili,
    ed.expl_m4day
   FROM exploitation ex, om_waterbalance w
     JOIN dma d USING (dma_id)
     LEFT JOIN ext_cat_period p ON w.cat_period_id::text = p.id::text
     JOIN expl_data ed ON ed.expl_id = w.expl_id AND w.cat_period_id::text = p.id::text
  WHERE ed.start_date = p.start_date
  AND ex.expl_id = any(d.expl_id);


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
    JOIN inp_frpump p ON f.element_id = p.element_id;

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


CREATE OR REPLACE VIEW v_edit_inp_frvalve
as select f.element_id,
    f.node_id,
    f.order_id,
    f.nodarc_id,
    f.to_arc,
    f.flwreg_length,
    v.valve_type,
    custom_dint,
    setting,
    curve_id,
    minorloss,
    add_settings,
    init_quality,
    f.the_geom
    FROM ve_frelem f
    JOIN inp_frvalve v ON f.element_id = v.element_id;


CREATE OR REPLACE VIEW v_edit_inp_dscenario_frvalve
AS SELECT s.dscenario_id,
    element_id,
	  v.valve_type,
    v.custom_dint,
    v.setting,
    v.curve_id,
    v.minorloss,
    v.add_settings,
    v.init_quality,
    n.the_geom
    FROM selector_inp_dscenario s, inp_dscenario_frvalve v
    JOIN v_edit_inp_frvalve n USING (element_id)
    WHERE s.dscenario_id = v.dscenario_id AND s.cur_user = CURRENT_USER::text;


CREATE OR REPLACE VIEW ve_epa_frvalve AS
SELECT v.element_id,
	man_frelem.node_id,
	concat (man_frelem.node_id,'_FR', order_id) as nodarc_id,
	to_arc,
	valve_type,
	custom_dint,
	v.setting,
	curve_id,
	minorloss
	status,
	add_settings,
	init_quality,
	flow_max,
	flow_min,
	flow_avg,
	vel_max,
	vel_min,
	vel_avg,
	headloss_max,
	headloss_min,
	setting_max,
	setting_min,
	reaction_max,
	reaction_min,
	ffactor_max,
	ffactor_min
	FROM inp_frvalve v
  LEFT JOIN man_frelem USING (element_id)
  LEFT JOIN v_rpt_arc_stats r ON r.arc_id::text = concat (man_frelem.node_id,'_FR', order_id);  -- TODO: revise this case


CREATE OR REPLACE VIEW ve_epa_frpump as
SELECT p.element_id,
	man_frelem.node_id,
	concat (man_frelem.node_id,'_FR', order_id) as nodarc_id,
	to_arc,
	curve_id,
	status,
	startup,
	shutoff,
	flow_max,
	flow_min,
	flow_avg,
	vel_max,
	vel_min,
	vel_avg,
	headloss_max,
	headloss_min,
	setting_max,
	setting_min,
	reaction_max,
	reaction_min,
	ffactor_max,
	ffactor_min
	FROM inp_frpump p
     LEFT JOIN man_frelem USING (element_id)
     LEFT JOIN v_rpt_arc_stats r ON r.arc_id::text = concat (man_frelem.node_id,'_FR', order_id); -- TODO: revise this case

CREATE OR REPLACE VIEW v_edit_cat_feature_node
AS SELECT cat_feature.id,
    cat_feature.feature_class AS system_id,
    cat_feature_node.epa_default,
    cat_feature_node.isarcdivide,
    cat_feature_node.isprofilesurface,
    cat_feature_node.choose_hemisphere,
    cat_feature.code_autofill,
    cat_feature_node.double_geom::text AS double_geom,
    cat_feature_node.num_arcs,
    cat_feature_node.graph_delimiter,
    cat_feature.shortcut_key,
    cat_feature.link_path,
    cat_feature.descript,
    cat_feature.active
   FROM cat_feature
     JOIN cat_feature_node USING (id);

CREATE OR REPLACE VIEW v_edit_cat_feature_connec
AS SELECT cat_feature.id,
    cat_feature.feature_class AS system_id,
    cat_feature_connec.epa_default,
    cat_feature.code_autofill,
    cat_feature_connec.double_geom::text AS double_geom,
    cat_feature.shortcut_key,
    cat_feature.link_path,
    cat_feature.descript,
    cat_feature.active
   FROM cat_feature
     JOIN cat_feature_connec USING (id);

CREATE OR REPLACE VIEW v_rtc_hydrometer_x_node
AS SELECT ext_rtc_hydrometer.id::text AS hydrometer_id,
    ext_rtc_hydrometer.code AS hydrometer_customer_code,
        CASE
            WHEN node.node_id IS NULL THEN NULL::int4
            ELSE node.node_id
        END AS node_id,
        CASE
            WHEN ext_rtc_hydrometer.connec_id IS NULL THEN 'XXXX'::text
            ELSE ext_rtc_hydrometer.connec_id
        END AS node_customer_code,
    ext_rtc_hydrometer_state.name AS state,
    ext_municipality.name AS muni_name,
    node.expl_id,
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
     JOIN man_netwjoin ON man_netwjoin.customer_code::text = ext_rtc_hydrometer.connec_id
     JOIN node ON node.node_id = man_netwjoin.node_id
     LEFT JOIN ext_municipality ON ext_municipality.muni_id = node.muni_id
     LEFT JOIN exploitation ON exploitation.expl_id = node.expl_id
  WHERE selector_hydrometer.state_id = ext_rtc_hydrometer.state_id AND selector_hydrometer.cur_user = "current_user"()::text AND selector_expl.expl_id = node.expl_id AND selector_expl.cur_user = "current_user"()::text;

CREATE OR REPLACE VIEW v_rtc_hydrometer_x_connec
AS SELECT ext_rtc_hydrometer.id::text AS hydrometer_id,
    ext_rtc_hydrometer.code AS hydrometer_customer_code,
        CASE
            WHEN connec.connec_id IS NULL THEN NULL::int4
            ELSE connec.connec_id
        END AS connec_id,
        CASE
            WHEN ext_rtc_hydrometer.connec_id IS NULL THEN 'XXXX'::text
            ELSE ext_rtc_hydrometer.connec_id
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
        END AS hydrometer_link,
    ext_rtc_hydrometer_state.is_operative,
    ext_rtc_hydrometer.shutdown_date
   FROM selector_hydrometer,
    selector_expl,
    rtc_hydrometer
     LEFT JOIN ext_rtc_hydrometer ON ext_rtc_hydrometer.id::text = rtc_hydrometer.hydrometer_id::text
     JOIN ext_rtc_hydrometer_state ON ext_rtc_hydrometer_state.id = ext_rtc_hydrometer.state_id
     JOIN connec ON connec.customer_code::text = ext_rtc_hydrometer.connec_id
     LEFT JOIN ext_municipality ON ext_municipality.muni_id = connec.muni_id
     LEFT JOIN exploitation ON exploitation.expl_id = connec.expl_id
  WHERE selector_hydrometer.state_id = ext_rtc_hydrometer.state_id AND selector_hydrometer.cur_user = "current_user"()::text AND selector_expl.expl_id = connec.expl_id AND selector_expl.cur_user = "current_user"()::text;

CREATE OR REPLACE VIEW v_ui_hydrometer
AS SELECT v_rtc_hydrometer_x_connec.hydrometer_id,
    v_rtc_hydrometer_x_connec.connec_id AS feature_id,
    v_rtc_hydrometer_x_connec.hydrometer_customer_code,
    v_rtc_hydrometer_x_connec.connec_customer_code AS feature_customer_code,
    v_rtc_hydrometer_x_connec.state,
    v_rtc_hydrometer_x_connec.expl_name,
    v_rtc_hydrometer_x_connec.hydrometer_link
   FROM v_rtc_hydrometer_x_connec
UNION
 SELECT v_rtc_hydrometer_x_node.hydrometer_id,
    v_rtc_hydrometer_x_node.node_id AS feature_id,
    v_rtc_hydrometer_x_node.hydrometer_customer_code,
    v_rtc_hydrometer_x_node.node_customer_code AS feature_customer_code,
    v_rtc_hydrometer_x_node.state,
    v_rtc_hydrometer_x_node.expl_name,
    v_rtc_hydrometer_x_node.hydrometer_link
   FROM v_rtc_hydrometer_x_node;


CREATE OR REPLACE VIEW v_rtc_hydrometer
AS SELECT ext_rtc_hydrometer.id::text AS hydrometer_id,
    ext_rtc_hydrometer.code AS hydrometer_customer_code,
        CASE
            WHEN connec.connec_id IS NULL THEN NULL::int4
            ELSE connec.connec_id
        END AS feature_id,
    'CONNEC'::text AS feature_type,
        CASE
            WHEN ext_rtc_hydrometer.connec_id IS NULL THEN 'XXXX'::text
            ELSE ext_rtc_hydrometer.connec_id
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
     JOIN connec ON connec.customer_code::text = ext_rtc_hydrometer.connec_id
     LEFT JOIN ext_municipality ON ext_municipality.muni_id = connec.muni_id
     LEFT JOIN exploitation ON exploitation.expl_id = connec.expl_id
  WHERE selector_hydrometer.state_id = ext_rtc_hydrometer.state_id AND selector_hydrometer.cur_user = "current_user"()::text AND selector_expl.expl_id = connec.expl_id AND selector_expl.cur_user = "current_user"()::text
UNION
 SELECT ext_rtc_hydrometer.id::text AS hydrometer_id,
    ext_rtc_hydrometer.code AS hydrometer_customer_code,
        CASE
            WHEN node.node_id IS NULL THEN NULL::int4
            ELSE node.node_id
        END AS feature_id,
    'NODE'::text AS feature_type,
        CASE
            WHEN ext_rtc_hydrometer.connec_id IS NULL THEN 'XXXX'::text
            ELSE ext_rtc_hydrometer.connec_id
        END AS customer_code,
    ext_rtc_hydrometer_state.name AS state,
    ext_municipality.name AS muni_name,
    node.expl_id,
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
     JOIN man_netwjoin ON man_netwjoin.customer_code::text = ext_rtc_hydrometer.connec_id
     JOIN node ON node.node_id = man_netwjoin.node_id
     LEFT JOIN ext_municipality ON ext_municipality.muni_id = node.muni_id
     LEFT JOIN exploitation ON exploitation.expl_id = node.expl_id
  WHERE selector_hydrometer.state_id = ext_rtc_hydrometer.state_id AND selector_hydrometer.cur_user = "current_user"()::text AND selector_expl.expl_id = node.expl_id AND selector_expl.cur_user = "current_user"()::text;

CREATE OR REPLACE VIEW v_edit_plan_netscenario_valve
AS SELECT v.netscenario_id,
    v.node_id,
    v.closed,
    node.the_geom
   FROM config_param_user,
    plan_netscenario_valve v
     JOIN node USING (node_id)
  WHERE config_param_user.cur_user::text = CURRENT_USER AND config_param_user.parameter::text = 'plan_netscenario_current'::text AND config_param_user.value::integer = v.netscenario_id;


CREATE OR REPLACE VIEW v_ui_om_visit_x_node
AS SELECT om_visit_event.id AS event_id,
    om_visit.id AS visit_id,
    om_visit.ext_code AS code,
    om_visit.visitcat_id,
    om_visit.startdate AS visit_start,
    om_visit.enddate AS visit_end,
    om_visit.user_name,
    om_visit.is_done,
    date_trunc('second'::text, om_visit_event.tstamp) AS tstamp,
    om_visit_x_node.node_id,
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
     JOIN om_visit_x_node ON om_visit_x_node.visit_id = om_visit.id
     LEFT JOIN config_visit_parameter ON config_visit_parameter.id::text = om_visit_event.parameter_id::text
     LEFT JOIN ( SELECT DISTINCT om_visit_event_photo.event_id
           FROM om_visit_event_photo) a ON a.event_id = om_visit_event.id
     LEFT JOIN ( SELECT DISTINCT doc_x_visit.visit_id
           FROM doc_x_visit) b ON b.visit_id = om_visit.id
  ORDER BY om_visit_x_node.node_id;

CREATE OR REPLACE VIEW v_ui_om_visitman_x_node
AS SELECT DISTINCT ON (v_ui_om_visit_x_node.visit_id) v_ui_om_visit_x_node.visit_id,
    v_ui_om_visit_x_node.code,
    om_visit_cat.name AS visitcat_name,
    v_ui_om_visit_x_node.node_id,
    date_trunc('second'::text, v_ui_om_visit_x_node.visit_start) AS visit_start,
    date_trunc('second'::text, v_ui_om_visit_x_node.visit_end) AS visit_end,
    v_ui_om_visit_x_node.user_name,
    v_ui_om_visit_x_node.is_done,
    v_ui_om_visit_x_node.feature_type,
    v_ui_om_visit_x_node.form_type
   FROM v_ui_om_visit_x_node
     LEFT JOIN om_visit_cat ON om_visit_cat.id = v_ui_om_visit_x_node.visitcat_id;

CREATE OR REPLACE VIEW ve_visit_node_singlevent
AS SELECT om_visit_x_node.visit_id,
    om_visit_x_node.node_id,
    om_visit.visitcat_id,
    om_visit.ext_code,
    "left"(date_trunc('second'::text, om_visit.startdate)::text, 19)::timestamp without time zone AS startdate,
    "left"(date_trunc('second'::text, om_visit.enddate)::text, 19)::timestamp without time zone AS enddate,
    om_visit.user_name,
    om_visit.webclient_id,
    om_visit.expl_id,
    om_visit.the_geom,
    om_visit.descript,
    om_visit.is_done,
    om_visit.class_id,
    om_visit.status,
    om_visit_event.event_code,
    om_visit_event.position_id,
    om_visit_event.position_value,
    om_visit_event.parameter_id,
    om_visit_event.value,
    om_visit_event.value1,
    om_visit_event.value2,
    om_visit_event.geom1,
    om_visit_event.geom2,
    om_visit_event.geom3,
    om_visit_event.xcoord,
    om_visit_event.ycoord,
    om_visit_event.compass,
    om_visit_event.tstamp,
    om_visit_event.text,
    om_visit_event.index_val,
    om_visit_event.is_last
   FROM om_visit
     JOIN om_visit_event ON om_visit.id = om_visit_event.visit_id
     JOIN om_visit_x_node ON om_visit.id = om_visit_x_node.visit_id
     JOIN config_visit_class ON config_visit_class.id = om_visit.class_id
  WHERE config_visit_class.ismultievent = false;

CREATE OR REPLACE VIEW v_om_visit AS
 SELECT DISTINCT ON (a.visit_id) a.visit_id,
    a.code,
    a.visitcat_id,
    a.name,
    a.visit_start,
    a.visit_end,
    a.user_name,
    a.is_done,
    a.feature_id,
    a.feature_type,
    a.the_geom::geometry(POINT, SRID_VALUE)
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
           FROM selector_state, om_visit
             JOIN om_visit_x_node ON om_visit_x_node.visit_id = om_visit.id
             JOIN node ON node.node_id = om_visit_x_node.node_id
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
           FROM selector_state, om_visit
             JOIN om_visit_x_arc ON om_visit_x_arc.visit_id = om_visit.id
             JOIN arc ON arc.arc_id = om_visit_x_arc.arc_id
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
           FROM selector_state, om_visit
             JOIN om_visit_x_connec ON om_visit_x_connec.visit_id = om_visit.id
             JOIN connec ON connec.connec_id = om_visit_x_connec.connec_id
             JOIN om_visit_cat ON om_visit.visitcat_id = om_visit_cat.id
          WHERE selector_state.state_id = connec.state AND selector_state.cur_user = "current_user"()::text) a;

CREATE OR REPLACE VIEW v_ui_event_x_node
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
    om_visit_x_node.node_id,
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
     JOIN om_visit_x_node ON om_visit_x_node.visit_id = om_visit.id
     LEFT JOIN config_visit_parameter ON config_visit_parameter.id::text = om_visit_event.parameter_id::text
     LEFT JOIN ( SELECT DISTINCT om_visit_event_photo.event_id
           FROM om_visit_event_photo) a ON a.event_id = om_visit_event.id
     LEFT JOIN ( SELECT DISTINCT doc_x_visit.visit_id
           FROM doc_x_visit) b ON b.visit_id = om_visit.id
  ORDER BY om_visit_x_node.node_id;


CREATE OR REPLACE VIEW v_ui_hydroval
AS SELECT ext_rtc_hydrometer_x_data.id,
    rtc_hydrometer_x_node.node_id AS feature_id,
    node.arc_id,
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
     JOIN rtc_hydrometer_x_node ON rtc_hydrometer_x_node.hydrometer_id::text = ext_rtc_hydrometer_x_data.hydrometer_id::text
     JOIN node ON rtc_hydrometer_x_node.node_id = node.node_id
     LEFT JOIN crm_typevalue crmtype ON ext_rtc_hydrometer_x_data.value_type = crmtype.id::integer AND crmtype.typevalue::text = 'crm_value_type'::text
     LEFT JOIN crm_typevalue crmstatus ON ext_rtc_hydrometer_x_data.value_status = crmstatus.id::integer AND crmstatus.typevalue::text = 'crm_value_status'::text
     LEFT JOIN crm_typevalue crmstate ON ext_rtc_hydrometer_x_data.value_state = crmstate.id::integer AND crmstate.typevalue::text = 'crm_value_state'::text
UNION
 SELECT ext_rtc_hydrometer_x_data.id,
    rtc_hydrometer_x_connec.connec_id AS feature_id,
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
     JOIN connec ON rtc_hydrometer_x_connec.connec_id = connec.connec_id
     LEFT JOIN crm_typevalue crmtype ON ext_rtc_hydrometer_x_data.value_type = crmtype.id::integer AND crmtype.typevalue::text = 'crm_value_type'::text
     LEFT JOIN crm_typevalue crmstatus ON ext_rtc_hydrometer_x_data.value_status = crmstatus.id::integer AND crmstatus.typevalue::text = 'crm_value_status'::text
     LEFT JOIN crm_typevalue crmstate ON ext_rtc_hydrometer_x_data.value_state = crmstate.id::integer AND crmstate.typevalue::text = 'crm_value_state'::text
  ORDER BY 1;

CREATE OR REPLACE VIEW v_ui_hydroval_x_connec
AS SELECT ext_rtc_hydrometer_x_data.id,
    rtc_hydrometer_x_connec.connec_id,
    connec.arc_id,
    ext_rtc_hydrometer_x_data.hydrometer_id,
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
     JOIN connec ON rtc_hydrometer_x_connec.connec_id = connec.connec_id
     LEFT JOIN crm_typevalue crmtype ON ext_rtc_hydrometer_x_data.value_type = crmtype.id::integer AND crmtype.typevalue::text = 'crm_value_type'::text
     LEFT JOIN crm_typevalue crmstatus ON ext_rtc_hydrometer_x_data.value_status = crmstatus.id::integer AND crmstatus.typevalue::text = 'crm_value_status'::text
     LEFT JOIN crm_typevalue crmstate ON ext_rtc_hydrometer_x_data.value_state = crmstate.id::integer AND crmstate.typevalue::text = 'crm_value_state'::text
  ORDER BY ext_rtc_hydrometer_x_data.id;


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
     JOIN arc ON arc.arc_id = om_visit_x_arc.arc_id
     LEFT JOIN ( SELECT DISTINCT om_visit_event_photo.event_id
           FROM om_visit_event_photo) a ON a.event_id = om_visit_event.id
     LEFT JOIN ( SELECT DISTINCT doc_x_visit.visit_id
           FROM doc_x_visit) b ON b.visit_id = om_visit.id
  ORDER BY om_visit_x_arc.arc_id;

CREATE OR REPLACE VIEW v_ui_om_visitman_x_arc
AS SELECT DISTINCT ON (v_ui_om_visit_x_arc.visit_id) v_ui_om_visit_x_arc.visit_id,
    v_ui_om_visit_x_arc.code,
    om_visit_cat.name AS visitcat_name,
    v_ui_om_visit_x_arc.arc_id,
    date_trunc('second'::text, v_ui_om_visit_x_arc.visit_start) AS visit_start,
    date_trunc('second'::text, v_ui_om_visit_x_arc.visit_end) AS visit_end,
    v_ui_om_visit_x_arc.user_name,
    v_ui_om_visit_x_arc.is_done,
    v_ui_om_visit_x_arc.feature_type,
    v_ui_om_visit_x_arc.form_type
   FROM v_ui_om_visit_x_arc
     LEFT JOIN om_visit_cat ON om_visit_cat.id = v_ui_om_visit_x_arc.visitcat_id;

CREATE OR REPLACE VIEW ve_visit_arc_singlevent
AS SELECT om_visit_x_arc.visit_id,
    om_visit_x_arc.arc_id,
    om_visit.visitcat_id,
    om_visit.ext_code,
    "left"(date_trunc('second'::text, om_visit.startdate)::text, 19)::timestamp without time zone AS startdate,
    "left"(date_trunc('second'::text, om_visit.enddate)::text, 19)::timestamp without time zone AS enddate,
    om_visit.user_name,
    om_visit.webclient_id,
    om_visit.expl_id,
    om_visit.the_geom,
    om_visit.descript,
    om_visit.is_done,
    om_visit.class_id,
    om_visit.status,
    om_visit_event.id AS event_id,
    om_visit_event.event_code,
    om_visit_event.position_id,
    om_visit_event.position_value,
    om_visit_event.parameter_id,
    om_visit_event.value,
    om_visit_event.value1,
    om_visit_event.value2,
    om_visit_event.geom1,
    om_visit_event.geom2,
    om_visit_event.geom3,
    om_visit_event.xcoord,
    om_visit_event.ycoord,
    om_visit_event.compass,
    om_visit_event.tstamp,
    om_visit_event.text,
    om_visit_event.index_val,
    om_visit_event.is_last
   FROM om_visit
     JOIN om_visit_event ON om_visit.id = om_visit_event.visit_id
     JOIN om_visit_x_arc ON om_visit.id = om_visit_x_arc.visit_id
     JOIN config_visit_class ON config_visit_class.id = om_visit.class_id
  WHERE config_visit_class.ismultievent = false;

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
     JOIN arc ON arc.arc_id = om_visit_x_arc.arc_id
     LEFT JOIN ( SELECT DISTINCT om_visit_event_photo.event_id
           FROM om_visit_event_photo) a ON a.event_id = om_visit_event.id
     LEFT JOIN ( SELECT DISTINCT doc_x_visit.visit_id
           FROM doc_x_visit) b ON b.visit_id = om_visit.id
  ORDER BY om_visit_x_arc.arc_id;

CREATE OR REPLACE VIEW v_ui_om_visitman_x_connec
AS SELECT DISTINCT ON (v_ui_om_visit_x_connec.visit_id) v_ui_om_visit_x_connec.visit_id,
    v_ui_om_visit_x_connec.code,
    om_visit_cat.name AS visitcat_name,
    v_ui_om_visit_x_connec.connec_id,
    date_trunc('second'::text, v_ui_om_visit_x_connec.visit_start) AS visit_start,
    date_trunc('second'::text, v_ui_om_visit_x_connec.visit_end) AS visit_end,
    v_ui_om_visit_x_connec.user_name,
    v_ui_om_visit_x_connec.is_done,
    v_ui_om_visit_x_connec.feature_type,
    v_ui_om_visit_x_connec.form_type
   FROM v_ui_om_visit_x_connec
     LEFT JOIN om_visit_cat ON om_visit_cat.id = v_ui_om_visit_x_connec.visitcat_id;

CREATE OR REPLACE VIEW ve_visit_connec_singlevent
AS SELECT om_visit_x_connec.visit_id,
    om_visit_x_connec.connec_id,
    om_visit.visitcat_id,
    om_visit.ext_code,
    "left"(date_trunc('second'::text, om_visit.startdate)::text, 19)::timestamp without time zone AS startdate,
    "left"(date_trunc('second'::text, om_visit.enddate)::text, 19)::timestamp without time zone AS enddate,
    om_visit.user_name,
    om_visit.webclient_id,
    om_visit.expl_id,
    om_visit.the_geom,
    om_visit.descript,
    om_visit.is_done,
    om_visit.class_id,
    om_visit.status,
    om_visit_event.event_code,
    om_visit_event.position_id,
    om_visit_event.position_value,
    om_visit_event.parameter_id,
    om_visit_event.value,
    om_visit_event.value1,
    om_visit_event.value2,
    om_visit_event.geom1,
    om_visit_event.geom2,
    om_visit_event.geom3,
    om_visit_event.xcoord,
    om_visit_event.ycoord,
    om_visit_event.compass,
    om_visit_event.tstamp,
    om_visit_event.text,
    om_visit_event.index_val,
    om_visit_event.is_last
   FROM om_visit
     JOIN om_visit_event ON om_visit.id = om_visit_event.visit_id
     JOIN om_visit_x_connec ON om_visit.id = om_visit_x_connec.visit_id
     JOIN config_visit_class ON config_visit_class.id = om_visit.class_id
  WHERE config_visit_class.ismultievent = false;


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
     LEFT JOIN connec ON connec.connec_id = om_visit_x_connec.connec_id
     LEFT JOIN ( SELECT DISTINCT om_visit_event_photo.event_id
           FROM om_visit_event_photo) a ON a.event_id = om_visit_event.id
     LEFT JOIN ( SELECT DISTINCT doc_x_visit.visit_id
           FROM doc_x_visit) b ON b.visit_id = om_visit.id
  ORDER BY om_visit_x_connec.connec_id;

CREATE OR REPLACE VIEW v_edit_rtc_hydro_data_x_connec
AS SELECT ext_rtc_hydrometer_x_data.id,
    rtc_hydrometer_x_connec.connec_id,
    ext_rtc_hydrometer_x_data.hydrometer_id,
    ext_rtc_hydrometer.code,
    ext_rtc_hydrometer.catalog_id,
    ext_rtc_hydrometer_x_data.cat_period_id,
    ext_cat_period.code AS cat_period_code,
    ext_rtc_hydrometer_x_data.value_date,
    ext_rtc_hydrometer_x_data.sum,
    ext_rtc_hydrometer_x_data.custom_sum
   FROM ext_rtc_hydrometer_x_data
     JOIN ext_rtc_hydrometer ON ext_rtc_hydrometer_x_data.hydrometer_id::bigint = ext_rtc_hydrometer.id::bigint
     LEFT JOIN ext_cat_hydrometer ON ext_cat_hydrometer.id::bigint = ext_rtc_hydrometer.catalog_id::bigint
     JOIN rtc_hydrometer_x_connec ON rtc_hydrometer_x_connec.hydrometer_id::bigint = ext_rtc_hydrometer_x_data.hydrometer_id::bigint
     JOIN ext_cat_period ON ext_rtc_hydrometer_x_data.cat_period_id::text = ext_cat_period.id::text
  ORDER BY ext_rtc_hydrometer_x_data.hydrometer_id, ext_rtc_hydrometer_x_data.cat_period_id DESC;

CREATE OR REPLACE VIEW v_ui_mincut_hydrometer
AS SELECT om_mincut_hydrometer.id,
    om_mincut_hydrometer.hydrometer_id,
    rtc_hydrometer_x_connec.connec_id,
    om_mincut_hydrometer.result_id,
    om_mincut.work_order,
    om_mincut.mincut_state,
    om_mincut.mincut_class,
    om_mincut.mincut_type,
    om_mincut.received_date,
    om_mincut.anl_cause,
    om_mincut.anl_tstamp,
    om_mincut.anl_user,
    om_mincut.anl_descript,
    om_mincut.forecast_start,
    om_mincut.forecast_end,
    om_mincut.exec_start,
    om_mincut.exec_end,
    om_mincut.exec_user,
    om_mincut.exec_descript,
    om_mincut.exec_appropiate,
        CASE
            WHEN om_mincut.mincut_state = 0 THEN om_mincut.forecast_start::timestamp with time zone
            WHEN om_mincut.mincut_state = 1 THEN now()
            WHEN om_mincut.mincut_state = 2 THEN om_mincut.exec_start::timestamp with time zone
            ELSE NULL::timestamp with time zone
        END AS start_date,
        CASE
            WHEN om_mincut.mincut_state = 0 THEN om_mincut.forecast_end::timestamp with time zone
            WHEN om_mincut.mincut_state = 1 THEN now()
            WHEN om_mincut.mincut_state = 2 THEN om_mincut.exec_end::timestamp with time zone
            ELSE NULL::timestamp with time zone
        END AS end_date
   FROM om_mincut_hydrometer
     JOIN om_mincut ON om_mincut_hydrometer.result_id = om_mincut.id
     JOIN rtc_hydrometer_x_connec ON rtc_hydrometer_x_connec.hydrometer_id::bigint = om_mincut_hydrometer.hydrometer_id::bigint;

CREATE OR REPLACE VIEW v_om_mincut_current_hydrometer
AS SELECT om_mincut_hydrometer.id,
    om_mincut_hydrometer.result_id,
    om_mincut.work_order,
    om_mincut_hydrometer.hydrometer_id,
    ext_rtc_hydrometer.code AS hydrometer_customer_code,
    rtc_hydrometer_x_connec.connec_id,
    connec.code AS connec_code
   FROM om_mincut_hydrometer
     JOIN ext_rtc_hydrometer ON om_mincut_hydrometer.hydrometer_id::text = ext_rtc_hydrometer.id::text
     JOIN rtc_hydrometer_x_connec ON om_mincut_hydrometer.hydrometer_id::text = rtc_hydrometer_x_connec.hydrometer_id::text
     JOIN connec ON rtc_hydrometer_x_connec.connec_id = connec.connec_id
     JOIN om_mincut ON om_mincut_hydrometer.result_id = om_mincut.id
  WHERE om_mincut.mincut_state = 1;

CREATE OR REPLACE VIEW v_polygon
AS SELECT p.pol_id,
    p.state,
    p.feature_id,
    p.sys_type,
    p.featurecat_id,
    p.the_geom
   FROM selector_state s,
    polygon p
  WHERE s.state_id = p.state AND s.cur_user = CURRENT_USER;

CREATE OR REPLACE VIEW v_rpt_compare_node
AS SELECT r.node_id,
    r.result_id,
    r.node_type,
    r.sector_id,
    r.nodecat_id,
    r.top_elev AS elevation,
    r.demand_max,
    r.demand_min,
    r.demand_avg,
    r.head_max,
    r.head_min,
    r.head_avg,
    r.press_max,
    r.press_min,
    r.press_avg,
    r.quality_max,
    r.quality_min,
    r.quality_avg,
    r.the_geom
   FROM rpt_node_stats r,
    selector_rpt_compare s
     JOIN selector_rpt_compare USING (result_id);

CREATE OR REPLACE VIEW v_rpt_arc_hourly
AS SELECT rpt_arc.id,
    arc.arc_id,
    arc.sector_id,
    selector_rpt_main.result_id,
    rpt_arc.flow,
    rpt_arc.vel,
    rpt_arc.headloss,
    rpt_arc.setting,
    rpt_arc.ffactor,
    rpt_arc."time",
    arc.the_geom
   FROM selector_rpt_main,
    selector_rpt_main_tstep,
    rpt_inp_arc arc
     JOIN rpt_arc ON rpt_arc.arc_id::text = arc.arc_id
  WHERE rpt_arc.result_id::text = selector_rpt_main.result_id::text AND rpt_arc."time"::text = selector_rpt_main_tstep.timestep::text AND selector_rpt_main.cur_user = "current_user"()::text AND selector_rpt_main_tstep.cur_user = "current_user"()::text AND arc.result_id::text = selector_rpt_main.result_id::text
  ORDER BY rpt_arc."time", arc.arc_id;


CREATE OR REPLACE VIEW v_rpt_comp_arc_hourly
AS WITH main AS (
         SELECT rpt_arc.id,
            arc.arc_id,
            arc.sector_id,
            selector_rpt_main.result_id,
            rpt_arc.flow,
            rpt_arc.vel,
            rpt_arc.headloss,
            rpt_arc.setting,
            rpt_arc.ffactor,
            rpt_arc."time",
            arc.the_geom
           FROM selector_rpt_main,
            selector_rpt_main_tstep,
            rpt_inp_arc arc
             JOIN rpt_arc ON rpt_arc.arc_id::text = arc.arc_id
          WHERE rpt_arc.result_id::text = selector_rpt_main.result_id::text AND rpt_arc."time"::text = selector_rpt_main_tstep.timestep::text AND selector_rpt_main.cur_user = CURRENT_USER AND selector_rpt_main_tstep.cur_user = CURRENT_USER AND arc.result_id::text = selector_rpt_main.result_id::text
        ), compare AS (
         SELECT rpt_arc.id,
            arc.arc_id,
            arc.sector_id,
            selector_rpt_compare.result_id,
            rpt_arc.flow,
            rpt_arc.vel,
            rpt_arc.headloss,
            rpt_arc.setting,
            rpt_arc.ffactor,
            rpt_arc."time",
            arc.the_geom
           FROM selector_rpt_compare,
            selector_rpt_compare_tstep,
            rpt_inp_arc arc
             JOIN rpt_arc ON rpt_arc.arc_id::text = arc.arc_id
          WHERE rpt_arc.result_id::text = selector_rpt_compare.result_id::text AND rpt_arc."time"::text = selector_rpt_compare_tstep.timestep::text AND selector_rpt_compare.cur_user = CURRENT_USER AND selector_rpt_compare_tstep.cur_user = CURRENT_USER AND arc.result_id::text = selector_rpt_compare.result_id::text
        )
 SELECT main.arc_id,
    main.sector_id,
    main.result_id AS result_id_main,
    compare.result_id AS result_id_compare,
    main."time" AS time_main,
    compare."time" AS time_compare,
    main.flow AS flow_main,
    compare.flow AS flow_compare,
    main.flow - compare.flow AS flow_diff,
    main.vel AS vel_main,
    compare.vel AS vel_compare,
    main.vel - compare.vel AS vel_diff,
    main.headloss AS headloss_main,
    compare.headloss AS headloss_compare,
    main.headloss - compare.headloss AS headloss_diff,
    main.setting AS setting_main,
    compare.setting AS setting_compare,
    main.setting - compare.setting AS setting_diff,
    main.ffactor AS ffactor_main,
    compare.ffactor AS ffactor_compare,
    main.ffactor - compare.ffactor AS ffactor_diff,
    main.the_geom
   FROM main
     JOIN compare ON main.arc_id = compare.arc_id;


CREATE OR REPLACE VIEW v_rpt_comp_arc
AS WITH main AS (
         SELECT r.arc_id,
            r.result_id,
            r.arc_type,
            r.sector_id,
            r.arccat_id,
            r.flow_max,
            r.flow_min,
            r.flow_avg,
            r.vel_max,
            r.vel_min,
            r.vel_avg,
            r.headloss_max,
            r.headloss_min,
            r.setting_max,
            r.setting_min,
            r.reaction_max,
            r.reaction_min,
            r.ffactor_max,
            r.ffactor_min,
            r.the_geom
           FROM rpt_arc_stats r,
            selector_rpt_main s
          WHERE r.result_id::text = s.result_id::text AND s.cur_user = CURRENT_USER
        ), compare AS (
         SELECT r.arc_id,
            r.result_id,
            r.arc_type,
            r.sector_id,
            r.arccat_id,
            r.flow_max,
            r.flow_min,
            r.flow_avg,
            r.vel_max,
            r.vel_min,
            r.vel_avg,
            r.headloss_max,
            r.headloss_min,
            r.setting_max,
            r.setting_min,
            r.reaction_max,
            r.reaction_min,
            r.ffactor_max,
            r.ffactor_min,
            r.the_geom
           FROM rpt_arc_stats r,
            selector_rpt_compare s
          WHERE r.result_id::text = s.result_id::text AND s.cur_user = CURRENT_USER
        )
 SELECT main.arc_id,
    main.arc_type,
    main.sector_id,
    main.arccat_id,
    main.result_id AS main_result,
    compare.result_id AS compare_result,
    main.flow_max AS flow_max_main,
    compare.flow_max AS flow_max_compare,
    main.flow_max - compare.flow_max AS flow_max_diff,
    main.flow_min AS flow_min_main,
    compare.flow_min AS flow_min_compare,
    main.flow_min - compare.flow_min AS flow_min_diff,
    main.flow_avg AS flow_avg_main,
    compare.flow_avg AS flow_avg_compare,
    main.flow_avg - compare.flow_avg AS flow_avg_diff,
    main.vel_max AS vel_max_main,
    compare.vel_max AS vel_max_compare,
    main.vel_max - compare.vel_max AS vel_max_diff,
    main.vel_min AS vel_min_main,
    compare.vel_min AS vel_min_compare,
    main.vel_min - compare.vel_min AS vel_min_diff,
    main.vel_avg AS vel_avg_main,
    compare.vel_avg AS vel_avg_compare,
    main.vel_avg - compare.vel_avg AS vel_avg_diff,
    main.headloss_max AS headloss_max_main,
    compare.headloss_max AS headloss_max_compare,
    main.headloss_max - compare.headloss_max AS headloss_max_diff,
    main.headloss_min AS headloss_min_main,
    compare.headloss_min AS headloss_min_compare,
    main.headloss_min - compare.headloss_min AS headloss_min_diff,
    main.setting_max AS setting_max_main,
    compare.setting_max AS setting_max_compare,
    main.setting_max - compare.setting_max AS setting_max_diff,
    main.setting_min AS setting_min_main,
    compare.setting_min AS setting_min_compare,
    main.setting_min - compare.setting_min AS setting_min_diff,
    main.reaction_max AS reaction_max_main,
    compare.reaction_max AS reaction_max_compare,
    main.reaction_max - compare.reaction_max AS reaction_max_diff,
    main.reaction_min AS reaction_min_main,
    compare.reaction_min AS reaction_min_compare,
    main.reaction_min - compare.reaction_min AS reaction_min_diff,
    main.ffactor_max AS ffactor_max_main,
    compare.ffactor_max AS ffactor_max_compare,
    main.ffactor_max - compare.ffactor_max AS ffactor_max_diff,
    main.ffactor_min AS ffactor_min_main,
    compare.ffactor_min AS ffactor_min_compare,
    main.ffactor_min - compare.ffactor_min AS ffactor_min_diff,
    main.the_geom
   FROM main
     JOIN compare ON main.arc_id = compare.arc_id;


CREATE OR REPLACE VIEW v_rpt_comp_node_hourly
AS WITH main AS (
         SELECT rpt_node.id,
            node.node_id,
            node.sector_id,
            selector_rpt_main.result_id,
            rpt_node.top_elev,
            rpt_node.demand,
            rpt_node.head,
            rpt_node.press,
            rpt_node.quality,
            rpt_node."time",
            node.the_geom
           FROM selector_rpt_main,
            selector_rpt_main_tstep,
            rpt_inp_node node
             JOIN rpt_node ON rpt_node.node_id::text = node.node_id
          WHERE rpt_node.result_id::text = selector_rpt_main.result_id::text AND rpt_node."time"::text = selector_rpt_main_tstep.timestep::text AND selector_rpt_main.cur_user = CURRENT_USER AND selector_rpt_main_tstep.cur_user = CURRENT_USER AND node.result_id::text = selector_rpt_main.result_id::text
        ), compare AS (
         SELECT rpt_node.id,
            node.node_id,
            node.sector_id,
            selector_rpt_compare.result_id,
            rpt_node.top_elev,
            rpt_node.demand,
            rpt_node.head,
            rpt_node.press,
            rpt_node.quality,
            rpt_node."time",
            node.the_geom
           FROM selector_rpt_compare,
            selector_rpt_compare_tstep,
            rpt_inp_node node
             JOIN rpt_node ON rpt_node.node_id::text = node.node_id
          WHERE rpt_node.result_id::text = selector_rpt_compare.result_id::text AND rpt_node."time"::text = selector_rpt_compare_tstep.timestep::text AND selector_rpt_compare.cur_user = CURRENT_USER AND selector_rpt_compare_tstep.cur_user = CURRENT_USER AND node.result_id::text = selector_rpt_compare.result_id::text
        )
 SELECT main.node_id,
    main.sector_id,
    main.top_elev,
    main.result_id AS result_id_main,
    compare.result_id AS result_id_compare,
    main."time" AS time_main,
    compare."time" AS time_compare,
    main.demand AS demand_main,
    compare.demand AS demand_compare,
    main.demand - compare.demand AS demand_diff,
    main.head AS head_main,
    compare.head AS head_compare,
    main.head - compare.head AS head_diff,
    main.press AS press_main,
    compare.press AS press_compare,
    main.press - compare.press AS press_diff,
    main.quality AS quality_main,
    compare.quality AS quality_compare,
    main.quality - compare.quality AS quality_diff,
    main.the_geom
   FROM main
     JOIN compare ON main.node_id = compare.node_id;


CREATE OR REPLACE VIEW v_rpt_comp_node
AS WITH main AS (
         SELECT r.node_id,
            r.result_id,
            r.node_type,
            r.sector_id,
            r.nodecat_id,
            r.top_elev,
            r.demand_max,
            r.demand_min,
            r.demand_avg,
            r.head_max,
            r.head_min,
            r.head_avg,
            r.press_max,
            r.press_min,
            r.press_avg,
            r.quality_max,
            r.quality_min,
            r.quality_avg,
            r.the_geom
           FROM rpt_node_stats r,
            selector_rpt_main s
          WHERE r.result_id::text = s.result_id::text AND s.cur_user = CURRENT_USER
        ), compare AS (
         SELECT r.node_id,
            r.result_id,
            r.node_type,
            r.sector_id,
            r.nodecat_id,
            r.top_elev,
            r.demand_max,
            r.demand_min,
            r.demand_avg,
            r.head_max,
            r.head_min,
            r.head_avg,
            r.press_max,
            r.press_min,
            r.press_avg,
            r.quality_max,
            r.quality_min,
            r.quality_avg,
            r.the_geom
           FROM rpt_node_stats r,
            selector_rpt_compare s
          WHERE r.result_id::text = s.result_id::text AND s.cur_user = CURRENT_USER
        )
 SELECT main.node_id,
    main.node_type,
    main.sector_id,
    main.nodecat_id,
    main.result_id AS result_id_main,
    compare.result_id AS result_id_compare,
    main.top_elev,
    main.demand_max AS demand_max_main,
    compare.demand_max AS demand_max_compare,
    main.demand_max - compare.demand_max AS demand_max_diff,
    main.demand_min AS demand_min_main,
    compare.demand_min AS demand_min_compare,
    main.demand_min - compare.demand_min AS demand_min_diff,
    main.demand_avg AS demand_avg_main,
    compare.demand_avg AS demand_avg_compare,
    main.demand_avg - compare.demand_avg AS demand_avg_diff,
    main.head_max AS head_max_main,
    compare.head_max AS head_max_compare,
    main.head_max - compare.head_max AS head_max_diff,
    main.head_min AS head_min_main,
    compare.head_min AS head_min_compare,
    main.head_min - compare.head_min AS head_min_diff,
    main.head_avg AS head_avg_main,
    compare.head_avg AS head_avg_compare,
    main.head_avg - compare.head_avg AS head_avg_diff,
    main.press_max AS press_max_main,
    compare.press_max AS press_max_compare,
    main.press_max - compare.press_max AS press_max_diff,
    main.press_min AS press_min_main,
    compare.press_min AS press_min_compare,
    main.press_min - compare.press_min AS press_min_diff,
    main.press_avg AS press_avg_main,
    compare.press_avg AS press_avg_compare,
    main.press_avg - compare.press_avg AS press_avg_diff,
    main.quality_max AS quality_max_main,
    compare.quality_max AS quality_max_compare,
    main.quality_max - compare.quality_max AS quality_max_diff,
    main.quality_min AS quality_min_main,
    compare.quality_min AS quality_min_compare,
    main.quality_min - compare.quality_min AS quality_min_diff,
    main.quality_avg AS quality_avg_main,
    compare.quality_avg AS quality_avg_compare,
    main.quality_avg - compare.quality_avg AS quality_avg_diff,
    main.the_geom
   FROM main
     JOIN compare ON main.node_id = compare.node_id;

CREATE OR REPLACE VIEW v_rpt_node_hourly
AS SELECT rpt_node.id,
    node.node_id,
    node.sector_id,
    selector_rpt_main.result_id,
    rpt_node.top_elev AS elevation,
    rpt_node.demand,
    rpt_node.head,
    rpt_node.press,
    rpt_node.quality,
    rpt_node."time",
    node.the_geom
   FROM selector_rpt_main,
    selector_rpt_main_tstep,
    rpt_inp_node node
     JOIN rpt_node ON rpt_node.node_id::text = node.node_id
  WHERE rpt_node.result_id::text = selector_rpt_main.result_id::text AND rpt_node."time"::text = selector_rpt_main_tstep.timestep::text AND selector_rpt_main.cur_user = "current_user"()::text AND selector_rpt_main_tstep.cur_user = "current_user"()::text AND node.result_id::text = selector_rpt_main.result_id::text
  ORDER BY rpt_node."time", node.node_id;

CREATE OR REPLACE VIEW v_om_mincut_arc
AS SELECT om_mincut_arc.id,
    om_mincut_arc.result_id,
    om_mincut.work_order,
    om_mincut_arc.arc_id,
    om_mincut_arc.the_geom
   FROM selector_mincut_result,
    om_mincut_arc
     JOIN om_mincut ON om_mincut_arc.result_id = om_mincut.id
  WHERE selector_mincut_result.result_id::text = om_mincut_arc.result_id::text AND selector_mincut_result.cur_user = "current_user"()::text
  ORDER BY om_mincut_arc.arc_id;

CREATE OR REPLACE VIEW v_om_mincut_planned_arc
AS SELECT om_mincut_arc.id,
    om_mincut_arc.result_id,
    om_mincut_arc.arc_id,
    om_mincut.forecast_start,
    om_mincut.forecast_end,
    om_mincut_arc.the_geom
   FROM om_mincut_arc
     JOIN om_mincut ON om_mincut.id = om_mincut_arc.result_id
  WHERE om_mincut.mincut_state < 2;

CREATE OR REPLACE VIEW v_om_mincut_current_arc
AS SELECT om_mincut_arc.id,
    om_mincut_arc.result_id,
    om_mincut.work_order,
    om_mincut_arc.arc_id,
    om_mincut_arc.the_geom
   FROM om_mincut_arc
     JOIN om_mincut ON om_mincut_arc.result_id = om_mincut.id
  WHERE om_mincut.mincut_state = 1;

CREATE OR REPLACE VIEW v_om_mincut_node
AS SELECT om_mincut_node.id,
    om_mincut_node.result_id,
    om_mincut.work_order,
    om_mincut_node.node_id,
    om_mincut_node.node_type,
    om_mincut_node.the_geom
   FROM selector_mincut_result,
    om_mincut_node
     JOIN om_mincut ON om_mincut_node.result_id = om_mincut.id
  WHERE selector_mincut_result.result_id::text = om_mincut_node.result_id::text AND selector_mincut_result.cur_user = "current_user"()::text;

CREATE OR REPLACE VIEW v_om_mincut_current_node
AS SELECT om_mincut_node.id,
    om_mincut_node.result_id,
    om_mincut.work_order,
    om_mincut_node.node_id,
    om_mincut_node.node_type,
    om_mincut_node.the_geom
   FROM om_mincut_node
     JOIN om_mincut ON om_mincut_node.result_id = om_mincut.id
  WHERE om_mincut.mincut_state = 1;

CREATE OR REPLACE VIEW v_om_mincut_connec
AS SELECT om_mincut_connec.id,
    om_mincut_connec.result_id,
    om_mincut.work_order,
    om_mincut_connec.connec_id,
    om_mincut_connec.customer_code,
    om_mincut_connec.the_geom
   FROM selector_mincut_result,
    om_mincut_connec
     JOIN om_mincut ON om_mincut_connec.result_id = om_mincut.id
  WHERE selector_mincut_result.result_id::text = om_mincut_connec.result_id::text AND selector_mincut_result.cur_user = "current_user"()::text;

CREATE OR REPLACE VIEW v_om_mincut_current_connec
AS SELECT om_mincut_connec.id,
    om_mincut_connec.result_id,
    om_mincut.work_order,
    om_mincut_connec.connec_id,
    om_mincut_connec.customer_code,
    om_mincut_connec.the_geom
   FROM om_mincut_connec
     JOIN om_mincut ON om_mincut_connec.result_id = om_mincut.id
  WHERE om_mincut.mincut_state = 1;

CREATE OR REPLACE VIEW v_ui_mincut_connec
AS SELECT om_mincut_connec.id,
    om_mincut_connec.connec_id,
    om_mincut_connec.result_id,
    om_mincut.work_order,
    om_mincut.mincut_state,
    om_mincut.mincut_class,
    om_mincut.mincut_type,
    om_mincut_cat_type.virtual,
    om_mincut.received_date,
    om_mincut.anl_cause,
    om_mincut.anl_tstamp,
    om_mincut.anl_user,
    om_mincut.anl_descript,
    om_mincut.forecast_start,
    om_mincut.forecast_end,
    om_mincut.exec_start,
    om_mincut.exec_end,
    om_mincut.exec_user,
    om_mincut.exec_descript,
    om_mincut.exec_appropiate,
        CASE
            WHEN om_mincut.mincut_state = 0 THEN om_mincut.forecast_start::timestamp with time zone
            WHEN om_mincut.mincut_state = 1 THEN now()
            WHEN om_mincut.mincut_state = 2 THEN om_mincut.exec_start::timestamp with time zone
            ELSE NULL::timestamp with time zone
        END AS start_date,
        CASE
            WHEN om_mincut.mincut_state = 0 THEN om_mincut.forecast_end::timestamp with time zone
            WHEN om_mincut.mincut_state = 1 THEN now()
            WHEN om_mincut.mincut_state = 2 THEN om_mincut.exec_end::timestamp with time zone
            ELSE NULL::timestamp with time zone
        END AS end_date
   FROM om_mincut_connec
     JOIN om_mincut ON om_mincut_connec.result_id = om_mincut.id
     JOIN om_mincut_cat_type ON om_mincut.mincut_type::text = om_mincut_cat_type.id::text;

CREATE OR REPLACE VIEW v_om_mincut_planned_valve
AS SELECT om_mincut_valve.id,
    om_mincut_valve.result_id,
    om_mincut_valve.node_id,
    om_mincut_valve.closed,
    om_mincut_valve.unaccess,
    om_mincut_valve.proposed,
    om_mincut.forecast_start,
    om_mincut.forecast_end,
    om_mincut_valve.the_geom
   FROM om_mincut_valve
     JOIN om_mincut ON om_mincut.id = om_mincut_valve.result_id
  WHERE om_mincut.mincut_state < 2 AND om_mincut_valve.proposed = true;

CREATE OR REPLACE VIEW v_om_mincut_valve
AS SELECT om_mincut_valve.id,
    om_mincut_valve.result_id,
    om_mincut.work_order,
    om_mincut_valve.node_id,
    om_mincut_valve.closed,
    om_mincut_valve.broken,
    om_mincut_valve.unaccess,
    om_mincut_valve.proposed,
    om_mincut_valve.to_arc,
    om_mincut_valve.the_geom
   FROM selector_mincut_result,
    om_mincut_valve
     JOIN om_mincut ON om_mincut_valve.result_id = om_mincut.id
  WHERE selector_mincut_result.result_id::text = om_mincut_valve.result_id::text AND selector_mincut_result.cur_user = "current_user"()::text;

CREATE OR REPLACE VIEW v_om_mincut_planned_valve
AS SELECT om_mincut_valve.id,
    om_mincut_valve.result_id,
    om_mincut_valve.node_id,
    om_mincut_valve.closed,
    om_mincut_valve.unaccess,
    om_mincut_valve.proposed,
    om_mincut.forecast_start,
    om_mincut.forecast_end,
    om_mincut_valve.the_geom
   FROM om_mincut_valve
     JOIN om_mincut ON om_mincut.id = om_mincut_valve.result_id
  WHERE om_mincut.mincut_state < 2 AND om_mincut_valve.proposed = true;


CREATE OR REPLACE VIEW v_edit_review_audit_node
AS SELECT review_audit_node.id,
    review_audit_node.node_id,
    review_audit_node.old_top_elev AS old_elevation,
    review_audit_node.new_top_elev AS new_elevation,
    review_audit_node.old_depth,
    review_audit_node.new_depth,
    review_audit_node.old_nodecat_id,
    review_audit_node.new_nodecat_id,
    review_audit_node.old_annotation,
    review_audit_node.new_annotation,
    review_audit_node.old_observ,
    review_audit_node.new_observ,
    review_audit_node.review_obs,
    review_audit_node.expl_id,
    review_audit_node.the_geom,
    review_audit_node.review_status_id,
    review_audit_node.field_date,
    review_audit_node.field_user,
    review_audit_node.is_validated
   FROM review_audit_node,
    selector_expl
  WHERE selector_expl.cur_user = "current_user"()::text AND review_audit_node.expl_id = selector_expl.expl_id AND review_audit_node.review_status_id <> 0 AND review_audit_node.is_validated IS NULL;

CREATE OR REPLACE VIEW v_edit_review_audit_arc
AS SELECT review_audit_arc.id,
    review_audit_arc.arc_id,
    review_audit_arc.old_arccat_id,
    review_audit_arc.new_arccat_id,
    review_audit_arc.old_annotation,
    review_audit_arc.new_annotation,
    review_audit_arc.old_observ,
    review_audit_arc.new_observ,
    review_audit_arc.review_obs,
    review_audit_arc.expl_id,
    review_audit_arc.the_geom,
    review_audit_arc.review_status_id,
    review_audit_arc.field_date,
    review_audit_arc.field_user,
    review_audit_arc.is_validated
   FROM review_audit_arc,
    selector_expl
  WHERE selector_expl.cur_user = "current_user"()::text AND review_audit_arc.expl_id = selector_expl.expl_id AND review_audit_arc.review_status_id <> 0 AND review_audit_arc.is_validated IS NULL;

CREATE OR REPLACE VIEW v_edit_review_audit_connec
AS SELECT review_audit_connec.id,
    review_audit_connec.connec_id,
    review_audit_connec.old_connecat_id,
    review_audit_connec.new_connecat_id,
    review_audit_connec.old_annotation,
    review_audit_connec.new_annotation,
    review_audit_connec.old_observ,
    review_audit_connec.new_observ,
    review_audit_connec.review_obs,
    review_audit_connec.expl_id,
    review_audit_connec.the_geom,
    review_audit_connec.review_status_id,
    review_audit_connec.field_date,
    review_audit_connec.field_user,
    review_audit_connec.is_validated
   FROM review_audit_connec,
    selector_expl
  WHERE selector_expl.cur_user = "current_user"()::text AND review_audit_connec.expl_id = selector_expl.expl_id AND review_audit_connec.review_status_id <> 0 AND review_audit_connec.is_validated IS NULL;

CREATE OR REPLACE VIEW v_edit_review_node
AS SELECT review_node.node_id,
    review_node.top_elev,
    review_node.depth,
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
  WHERE selector_expl.cur_user = CURRENT_USER AND review_node.expl_id = selector_expl.expl_id;

CREATE OR REPLACE VIEW v_edit_review_arc
AS SELECT review_arc.arc_id,
    review_arc.arccat_id,
    review_arc.annotation,
    review_arc.observ,
    review_arc.review_obs,
    review_arc.expl_id,
    review_arc.the_geom,
    review_arc.field_date,
    review_arc.field_checked,
    review_arc.is_validated
   FROM review_arc,
    selector_expl
  WHERE selector_expl.cur_user = "current_user"()::text AND review_arc.expl_id = selector_expl.expl_id;

CREATE OR REPLACE VIEW v_edit_review_connec
AS SELECT review_connec.connec_id,
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
  WHERE selector_expl.cur_user = CURRENT_USER AND review_connec.expl_id = selector_expl.expl_id;

CREATE OR REPLACE VIEW v_ext_plot
AS SELECT ext_plot.id,
    ext_plot.plot_code,
    ext_plot.muni_id,
    ext_plot.postcode,
    ext_plot.streetaxis_id,
    ext_plot.postnumber,
    ext_plot.complement,
    ext_plot.placement,
    ext_plot.square,
    ext_plot.observ,
    ext_plot.text,
    ext_plot.the_geom,
    ext_plot.expl_id
   FROM selector_municipality s,
    ext_plot
  WHERE ext_plot.muni_id = s.muni_id AND s.cur_user = "current_user"()::text;

UPDATE sys_feature_class SET man_table = 'man_pipelink' WHERE id = 'LINK';
INSERT INTO cat_feature (id, feature_class, feature_type, parent_layer, child_layer, active) VALUES ('EPUMP', 'FRELEM', 'ELEMENT', 've_frelem', 've_frelem_epump', true) ON CONFLICT (id) DO NOTHING;
INSERT INTO cat_feature (id, feature_class, feature_type, parent_layer, child_layer, active) VALUES ('EVALVE', 'FRELEM', 'ELEMENT', 've_frelem', 've_frelem_evalve', true) ON CONFLICT (id) DO NOTHING;

INSERT INTO cat_feature (id, feature_class, feature_type, parent_layer, child_layer)
SELECT concat('E', upper(REPLACE(id, ' ', '_'))), 'GENELEM', 'ELEMENT', 've_genelem', concat('ve_genelem_', concat('e', lower(REPLACE(id, ' ', '_')))) FROM _element_type
ON CONFLICT (id) DO NOTHING;

INSERT INTO cat_feature (id, feature_class, feature_type, shortcut_key, parent_layer, child_layer, descript, link_path, code_autofill, active, addparam)
VALUES('LINK', 'LINK', 'LINK', NULL, 'v_edit_link', 've_link_link', 'Link', NULL, true, true, NULL);

INSERT INTO cat_feature_link (id) VALUES ('LINK') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_param_user (id,formname,descript,sys_role,"label",dv_querytext,isenabled,layoutorder,project_type,isparent,feature_field_id,isautoupdate,"datatype",widgettype,ismandatory,vdefault,layoutname,iseditable)
VALUES ('edit_linkcat_vdefault','config','Value default catalog for link','role_edit','Default catalog for linkcat','SELECT cat_link.id, cat_link.id AS idval FROM cat_link JOIN cat_feature ON cat_feature.id = cat_link.link_type WHERE cat_feature.feature_class = ''LINK''',true,16,'utils',false,'linkcat_id',false,'text','combo',true,'PVC25-PN16-DOM','lyt_connec',true);

INSERT INTO cat_link (id, link_type, matcat_id, descript, link, brand_id, model_id, svg, estimated_depth, active, label)
SELECT id, 'LINK' AS link_type, matcat_id, descript, link, brand_id, model_id, svg, estimated_depth, active, label
FROM cat_connec ON CONFLICT DO NOTHING;

INSERT INTO cat_link (id, link_type) VALUES ('UPDATE_LINK_40','LINK');

INSERT INTO link (link_id, code, feature_id, feature_type, exit_id, exit_type, userdefined_geom, state, state_type, expl_id, the_geom, created_at, sector_id,
dma_id, fluid_type, presszone_id, dqa_id, minsector_id, expl_visibility, epa_type, is_operative, created_by, updated_at, updated_by, staticpressure, linkcat_id,
workcat_id, workcat_id_end, builtdate, enddate, uncertain, muni_id, verified, supplyzone_id, top_elev1, depth1, top_elev2, depth2)
SELECT nextval('SCHEMA_NAME.urn_id_seq'::regclass), link_id::text, feature_id::int4, feature_type, exit_id::int4, exit_type, userdefined_geom, state, 2, expl_id, the_geom, tstamp, sector_id,
dma_id, fluid_type, presszone_id, dqa_id, minsector_id, ARRAY[expl_id2], epa_type, is_operative, insert_user, lastupdate, lastupdate_user, staticpressure,
CASE
  WHEN conneccat_id IS NULL THEN
    CASE
      WHEN feature_type = 'CONNEC' THEN
        (SELECT conneccat_id FROM connec WHERE connec_id = feature_id::int4 LIMIT 1)
      ELSE
        'UPDATE_LINK_40'
    END
  ELSE conneccat_id
END	AS conneccat_id, workcat_id, workcat_id_end, builtdate, enddate, uncertain, muni_id, verified, supplyzone_id,
(SELECT c.top_elev FROM connec c WHERE c.connec_id=feature_id::int4 LIMIT 1) AS top_elev1,
(SELECT c.depth FROM connec c WHERE c.connec_id = feature_id::int4 LIMIT 1) AS depth1,
exit_topelev,
CASE
  WHEN exit_topelev IS NOT NULL AND exit_elev IS NOT NULL THEN
    exit_topelev - exit_elev
  ELSE NULL
END AS depth2
FROM _link;

UPDATE link l
SET state_type = c.state_type
FROM connec c
WHERE l.feature_id = c.connec_id AND l.feature_type = 'CONNEC' AND l.state = 1;

UPDATE link SET state_type = (
  SELECT (value::json->>'plan_statetype_planned')::int2 FROM config_param_system WHERE parameter = 'plan_statetype_vdefault'
)
WHERE state = 2;

DO $func$
DECLARE
  connecr record;
BEGIN
  FOR connecr IN (SELECT c.connec_id, c.conneccat_id FROM connec c LEFT JOIN link l ON l.feature_id = c.connec_id WHERE l.feature_id IS NULL)
  LOOP
    EXECUTE 'SELECT gw_fct_setlinktonetwork($${"client": {"device": 4, "lang": "en_US", "infoType": 1, "epsg": SRID_VALUE}, "form": {}, "feature": {"id": "[' || connecr.connec_id || ']"},
    "data": {"filterFields": {}, "pageInfo": {}, "feature_type": "CONNEC", "linkcatId":"UPDATE_LINK_40"}}$$);';
    UPDATE link SET uncertain=true WHERE feature_id = connecr.connec_id;
  END LOOP;
END $func$;

INSERT INTO sys_feature_epa_type (id, feature_type, epa_table, descript, active) VALUES('FRVALVE', 'ELEMENT', 'inp_frvalve', NULL, true);
INSERT INTO sys_feature_epa_type (id, feature_type, epa_table, descript, active) VALUES('UNDEFINED', 'ELEMENT', NULL, NULL, true);



INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_link', 'form_feature', 'tab_data', 'top_elev1', 'lyt_data_1', 36, 'integer', 'text', 'Top Elev 1', 'top_elev1', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_link', 'form_feature', 'tab_data', 'depth1', 'lyt_data_1', 37, 'integer', 'text', 'Depth1', 'depth1', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_link', 'form_feature', 'tab_data', 'elevation1', 'lyt_data_1', 38, 'integer', 'text', 'Elevation1', 'elevation1', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_link', 'form_feature', 'tab_data', 'top_elev2', 'lyt_data_1', 39, 'integer', 'text', 'Top elev 2', 'top_elev2', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_link', 'form_feature', 'tab_data', 'depth2', 'lyt_data_1', 40, 'integer', 'text', 'Depth2', 'depth2', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_link', 'form_feature', 'tab_data', 'elevation2', 'lyt_data_1', 41, 'integer', 'text', 'Elevation2', 'elevation2', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_link', 'form_feature', 'tab_data', 'dma_id', 'lyt_data_1', 9, 'integer', 'combo', 'Dma ID', 'Dma ID', NULL, false, false, false, false, NULL, 'SELECT dma_id as id, name as idval FROM dma WHERE dma_id = 0 UNION SELECT dma_id as id, name as idval FROM dma WHERE dma_id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "v_edit_dma", "activated": true, "keyColumn": "dma_id", "valueColumn": "name", "filterExpression": null}}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_link', 'form_feature', 'tab_data', 'dma_name', 'lyt_data_1', 19, 'string', 'text', 'dma_name', 'dma_name', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_link', 'form_feature', 'tab_data', 'macrodma_id', 'lyt_data_1', 23, 'integer', 'text', 'Macrodma ID', 'Macrodma ID', NULL, false, false, false, false, NULL, 'SELECT macrodma_id as id, name as idval FROM macrodma WHERE macrodma_id IS NOT NULL', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);


INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_edit_link', 'form_feature', 'tab_data', 'top_elev1', 'lyt_data_1', 36, 'integer', 'text', 'Top Elev 1', 'top_elev1', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_edit_link', 'form_feature', 'tab_data', 'depth1', 'lyt_data_1', 37, 'integer', 'text', 'Depth1', 'depth1', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_edit_link', 'form_feature', 'tab_data', 'elevation1', 'lyt_data_1', 38, 'integer', 'text', 'Elevation1', 'elevation1', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_edit_link', 'form_feature', 'tab_data', 'top_elev2', 'lyt_data_1', 39, 'integer', 'text', 'Top elev 2', 'top_elev2', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_edit_link', 'form_feature', 'tab_data', 'depth2', 'lyt_data_1', 40, 'integer', 'text', 'Depth2', 'depth2', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_edit_link', 'form_feature', 'tab_data', 'elevation2', 'lyt_data_1', 41, 'integer', 'text', 'Elevation2', 'elevation2', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_edit_link', 'form_feature', 'tab_data', 'dma_id', 'lyt_data_1', 9, 'integer', 'combo', 'Dma ID', 'Dma ID', NULL, false, false, false, false, NULL, 'SELECT dma_id as id, name as idval FROM dma WHERE dma_id = 0 UNION SELECT dma_id as id, name as idval FROM dma WHERE dma_id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "v_edit_dma", "activated": true, "keyColumn": "dma_id", "valueColumn": "name", "filterExpression": null}}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_edit_link', 'form_feature', 'tab_data', 'dma_name', 'lyt_data_1', 19, 'string', 'text', 'dma_name', 'dma_name', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_edit_link', 'form_feature', 'tab_data', 'macrodma_id', 'lyt_data_1', 23, 'integer', 'text', 'Macrodma ID', 'Macrodma ID', NULL, false, false, false, false, NULL, 'SELECT macrodma_id as id, name as idval FROM macrodma WHERE macrodma_id IS NOT NULL', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);

INSERT INTO man_pipelink (link_id)
SELECT link_id
FROM link;


UPDATE config_param_system
SET value='{"catfeatureId":["PR_REDUC_VALVE"], "vdefault":{"valve_type":"PRV", "minorloss":0.001, "status":"ACTIVE"}}'
WHERE "parameter"='epa_valve_vdefault_prv';
UPDATE config_param_system
SET value='{"catfeatureId":["SHUTOFF_VALVE", "FL_CONTR_VALVE"], "vdefault":{"valve_type":"TCV", "coef_loss":0.001, "minorloss":0.001, "status":"OPEN"}}'
WHERE "parameter"='epa_valve_vdefault_tcv';

-- Auto-generated SQL script #202504221023
UPDATE sys_foreignkey
	SET target_field='valve_type'
	WHERE typevalue_table='inp_typevalue' AND typevalue_name='inp_typevalue_valve' AND target_table='inp_valve' AND target_field='valv_type';
UPDATE sys_foreignkey
	SET target_field='valve_type'
	WHERE typevalue_table='inp_typevalue' AND typevalue_name='inp_typevalue_valve' AND target_table='inp_dscenario_valve' AND target_field='valv_type';
UPDATE sys_foreignkey
	SET target_field='valve_type'
	WHERE typevalue_table='inp_typevalue' AND typevalue_name='inp_typevalue_valve' AND target_table='inp_virtualvalve' AND target_field='valv_type';
UPDATE sys_foreignkey
	SET target_field='valve_type'
	WHERE typevalue_table='inp_typevalue' AND typevalue_name='inp_typevalue_valve' AND target_table='inp_dscenario_virtualvalve' AND target_field='valv_type';


UPDATE sys_fprocess
SET fprocess_name='Null values on valve_type table'
WHERE fid=273;

UPDATE config_form_list
SET query_text='SELECT dscenario_id, valve_type, pressure, diameter, flow, coef_loss, curve_id, minorloss, status, init_quality FROM v_edit_inp_dscenario_virtualvalve WHERE arc_id IS NOT NULL'
WHERE listname='tbl_inp_dscenario_virtualvalve' AND device=4;
UPDATE config_form_list
SET query_text='SELECT dscenario_id, node_id, nodarc_id, valve_type, pressure, flow, coef_loss, curve_id, minorloss, status, add_settings, init_quality FROM v_edit_inp_dscenario_valve WHERE node_id IS NOT NULL'
WHERE listname='tbl_inp_dscenario_valve' AND device=4;
UPDATE config_form_list
SET query_text='SELECT dscenario_id AS id, arc_id, valve_type, pressure, diameter, flow, coef_loss, curve_id, minorloss, status FROM inp_dscenario_virtualvalve where dscenario_id is not null'
WHERE listname='dscenario_virtualvalve' AND device=5;
UPDATE config_form_list
SET query_text='SELECT dscenario_id AS id, node_id, valve_type, pressure, flow, coef_loss, curve_id, minorloss, status, add_settings, init_quality FROM inp_dscenario_valve where dscenario_id is not null'
WHERE listname='dscenario_valve' AND device=5;


UPDATE sys_fprocess
SET query_text='SELECT * FROM t_inp_valve WHERE valve_type IS NULL',info_msg='Valve valve_type checked. No mandatory values missed.',except_msg='valves with null values on valve_type column.'
WHERE fid=273;
UPDATE sys_fprocess
SET query_text='SELECT * FROM t_inp_valve WHERE ((valve_type=''PBV'' OR valve_type=''PRV'' OR valve_type=''PSV'') AND (setting IS NULL))'
WHERE fid=275;
UPDATE sys_fprocess
SET query_text='SELECT * FROM t_inp_valve WHERE ((valve_type=''GPV'') AND (curve_id IS NULL))'
WHERE fid=276;
UPDATE sys_fprocess
SET query_text='SELECT * FROM t_inp_valve WHERE valve_type=''TCV'' AND setting IS NULL'
WHERE fid=277;
UPDATE sys_fprocess
SET query_text='SELECT * FROM t_inp_valve WHERE ((valve_type=''FCV'') AND (setting IS NULL))'
WHERE fid=278;
UPDATE sys_fprocess
SET info_msg='Virtualvalve valve_type checked. No mandatory values missed.',except_msg='virtualvalves with null values on valve_type column.'
WHERE fid=594;
UPDATE sys_fprocess
SET query_text='SELECT * FROM t_inp_virtualvalve WHERE ((valve_type=''PBV'' OR valve_type=''PRV'' OR valve_type=''PSV'') AND (setting IS NULL))'
WHERE fid=596;
UPDATE sys_fprocess
SET query_text='SELECT * FROM t_inp_virtualvalve WHERE ((valve_type=''GPV'') AND (curve_id IS NULL))'
WHERE fid=597;
UPDATE sys_fprocess
SET query_text='SELECT * FROM t_inp_virtualvalve WHERE valve_type=''TCV'' AND setting IS NULL'
WHERE fid=598;
UPDATE sys_fprocess
SET query_text='SELECT * FROM t_inp_virtualvalve WHERE ((valve_type=''FCV'') AND (setting IS NULL))'
WHERE fid=599;

UPDATE config_form_fields
SET columnname='valve_type'
WHERE formname='ve_epa_valve' AND formtype='form_feature' AND columnname='valv_type' AND tabname='tab_epa';
UPDATE config_form_fields
SET columnname='valve_type'
WHERE formname='ve_epa_virtualvalve' AND formtype='form_feature' AND columnname='valv_type' AND tabname='tab_epa';




-- node
DELETE FROM config_form_tableview WHERE objectname='tbl_element_x_node' AND columnname='sys_id';
DELETE FROM config_form_tableview	WHERE objectname='tbl_element_x_node' AND columnname='id';

INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible,alias)
VALUES ('node form','utils','tbl_element_x_node','feature_class',4,true,'feature_class');
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible,alias)
VALUES ('node form','utils','tbl_element_x_node','element_type',5,true,'element_type');
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible,alias)
VALUES ('node form','utils','tbl_element_x_node','location_type',16,true,'location_type');

UPDATE config_form_tableview SET columnindex=0,visible=false WHERE objectname='tbl_element_x_node' AND columnname='node_id';
UPDATE config_form_tableview SET columnindex=1 WHERE objectname='tbl_element_x_node' AND columnname='element_id';
UPDATE config_form_tableview SET columnindex=2 WHERE objectname='tbl_element_x_node' AND columnname='elementcat_id';
UPDATE config_form_tableview SET columnindex=3 WHERE objectname='tbl_element_x_node' AND columnname='num_elements';


-- arc
DELETE FROM config_form_tableview WHERE objectname='tbl_element_x_arc' AND columnname='sys_id';
DELETE FROM config_form_tableview WHERE objectname='tbl_element_x_arc' AND columnname='id';

INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible,alias)
VALUES ('arc form','utils','tbl_element_x_arc','feature_class',4,true,'feature_class');
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible,alias)
VALUES ('arc form','utils','tbl_element_x_arc','element_type',5,true,'element_type');
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible,alias)
VALUES ('arc form','utils','tbl_element_x_arc','location_type',16,true,'location_type');

UPDATE config_form_tableview SET columnindex=0,visible=false WHERE objectname='tbl_element_x_arc' AND columnname='arc_id';
UPDATE config_form_tableview SET columnindex=1 WHERE objectname='tbl_element_x_arc' AND columnname='element_id';
UPDATE config_form_tableview SET columnindex=2 WHERE objectname='tbl_element_x_arc' AND columnname='elementcat_id';
UPDATE config_form_tableview SET columnindex=3 WHERE objectname='tbl_element_x_arc' AND columnname='num_elements';


-- connec
DELETE FROM config_form_tableview WHERE objectname='tbl_element_x_connec' AND columnname='sys_id';
DELETE FROM config_form_tableview WHERE objectname='tbl_element_x_connec' AND columnname='id';

INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible,alias)
VALUES ('connec form','utils','tbl_element_x_connec','feature_class',4,true,'feature_class');
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible,alias)
VALUES ('connec form','utils','tbl_element_x_connec','element_type',5,true,'element_type');
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible,alias)
VALUES ('connec form','utils','tbl_element_x_connec','location_type',16,true,'location_type');

UPDATE config_form_tableview SET columnindex=0,visible=false WHERE objectname='tbl_element_x_connec' AND columnname='connec_id';
UPDATE config_form_tableview SET columnindex=1 WHERE objectname='tbl_element_x_connec' AND columnname='element_id';
UPDATE config_form_tableview SET columnindex=2 WHERE objectname='tbl_element_x_connec' AND columnname='elementcat_id';
UPDATE config_form_tableview SET columnindex=3 WHERE objectname='tbl_element_x_connec' AND columnname='num_elements';

UPDATE config_toolbox SET inputparams='
[
{"widgetname": "name","label": "Scenario name:","widgettype": "text","datatype": "text","layoutname": "grl_option_parameters", "layoutorder": 1, "value": ""},
{"widgetname": "descript","label": "Scenario descript:","widgettype": "text","datatype": "text","layoutname": "grl_option_parameters","layoutorder": 2,"value": ""},
{"widgetname": "exploitation","label": "Exploitation:","widgettype": "combo","datatype": "text","layoutname": "grl_option_parameters","layoutorder": 4,"dvQueryText":"SELECT expl_id as id, name as idval FROM exploitation where expl_id>0 UNION select 99999 as id, ''ALL'' as idval order by id desc", "selectedId":"0"}, 
{"widgetname": "patternOrDate","label": "Choose time method:","widgettype": "combo","datatype": "text","layoutname": "grl_option_parameters","comboIds": [1,2],"comboNames": ["PERIOD ID","DATE INTERVAL"],"layoutorder": 5,"isMandatory":true},
{"widgetname": "period", "label": "if PERIOD_ID - Period:","widgettype": "combo","datatype": "text","layoutname": "grl_option_parameters","layoutorder": 6,"dvQueryText":"SELECT id, code as idval FROM ext_cat_period", "selectedId":"1"},
{"widgetname": "initDate","label": "[if DATE INTERVAL] Source CRM init date:","widgettype": "datetime","datatype": "text","layoutname": "grl_option_parameters","layoutorder": 7,"value": null},
{"widgetname": "endDate","label": "[if DATE INTERVAL] Source CRM end date:","widgettype": "datetime","datatype": "text","layoutname": "grl_option_parameters","layoutorder": 8,"value":"2015-07-30 00:00:00"},
{"widgetname": "onlyIsWaterBal","label": "Only hydrometers with waterbal true:","widgettype": "check","datatype": "boolean","layoutname": "grl_option_parameters","layoutorder": 9,"value": null},
{"widgetname": "pattern","label": "Feature pattern:","widgettype": "combo","tooltip": "This value will be stored on pattern_id of inp_dscenario_demand table in order to be used on the inp file exportation ONLY with the pattern method FEATURE PATTERN.","datatype": "text","layoutname": "grl_option_parameters","layoutorder": 10,"comboIds": [1,2,3,4,5,6,7],"comboNames": ["NONE","SECTOR-DEFAULT","DMA-DEFAULT","DMA-PERIOD","HYDROMETER-PERIOD","HYDROMETER-CATEGORY","FEATURE-PATTERN"],"selectedId": ""},
{"widgetname": "demandUnits","label": "Demand units:","tooltip": "Choose units to insert volume data on demand column. This value need to be the same that flow units used on EPANET. On the other hand, it is assumed that volume from hydrometer data table is expresed on m3/period and column period_seconds is filled.","widgettype": "combo","datatype": "text","layoutname": "grl_option_parameters","layoutorder": 11,"comboIds": ["LPS","LPM","MLD","CMH","CMD","CFS","GPM","MGD","AFD"],"comboNames": ["LPS","LPM", "MLD","CMH","CMD","CFS","GPM","MGD","AFD"],"selectedId": ""}
]'::json WHERE id=3110;

UPDATE config_toolbox SET inputparams =
'[
{"widgetname":"exploitation", "label":"Exploitation:","widgettype":"combo","datatype":"text", "isMandatory":true, "tooltip":"Dscenario type", "dvQueryText":"WITH aux AS (SELECT ''-9'' as id, ''ALL'' as idval, 0 AS rowid UNION SELECT expl_id::text as id, name as idval, row_number() over()+1 AS  rowid FROM exploitation where expl_id>0) SELECT id, idval FROM aux ORDER BY rowid ASC", "layoutname":"grl_option_parameters","layoutorder":1, "value":""},
{"widgetname":"method", "label":"Method:","widgettype":"combo","datatype":"text","isMandatory":true,"tooltip":"Water balance method", "dvQueryText":"SELECT id, idval FROM om_typevalue WHERE typevalue = ''waterbalance_method''", "layoutname":"grl_option_parameters","layoutorder":2, "value":""},
{"widgetname":"period","label": "    [if PERIOD_ID] Period:","widgettype": "combo","datatype": "text","layoutname": "grl_option_parameters","layoutorder": 4,"dvQueryText":"SELECT id, code as idval FROM ext_cat_period ORDER BY id desc","selectedId": ""},
{"widgetname":"initDate", "label":"    [if DATE INTERVAL] Period (init date):","widgettype":"datetime","datatype":"text", "isMandatory":true, "tooltip":"Start date", "layoutname":"grl_option_parameters","layoutorder":5, "value":null},
{"widgetname":"endDate", "label":"    [if DATE INTERVAL] Period (end date):","widgettype":"datetime","datatype":"text", "isMandatory":true, "tooltip":"End date", "layoutname":"grl_option_parameters","layoutorder":6, "value":"9999-12-12"},
{"widgetname":"executeGraphDma", "label":"Execute DMA:","widgettype":"check","datatype":"boolean","isMandatory":true,"tooltip":"Execute DMA","layoutname":"grl_option_parameters","layoutorder":7, "value":""}
]'
WHERE id = 3142;

UPDATE om_typevalue set typevalue = 'waterbalance_method_' WHERE typevalue = 'waterbalance_method' AND id = 'DCW';


UPDATE config_form_fields SET columnname='streetaxis_id' WHERE formname IN ('v_edit_node', 'v_edit_arc', 'v_edit_connec') AND formtype='form_feature' AND columnname='streetname' AND tabname='tab_data';
UPDATE config_form_fields SET columnname='streetaxis2_id' WHERE formname IN ('v_edit_node', 'v_edit_arc', 'v_edit_connec') AND formtype='form_feature' AND columnname='streetname2' AND tabname='tab_data';
UPDATE config_form_fields SET columnname='streetaxis_id' WHERE formname ILIKE 've_%' AND formtype='form_feature' AND columnname='streetname' AND tabname='tab_data';
UPDATE config_form_fields SET columnname='streetaxis2_id' WHERE formname ILIKE 've_%' AND formtype='form_feature' AND columnname='streetname2' AND tabname='tab_data';


INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_ui_omzone', 'form_feature', 'tab_none', 'omzone_id', 'lyt_data_1', 1, 'integer', 'text', 'omzone_id', 'omzone_id', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"label":"color:red; font-weight:bold"}'::json, '{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "v_edit_omzone", "activated": true, "keyColumn": "omzone_id", "valueColumn": "name", "filterExpression": null}}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_ui_omzone', 'form_feature', 'tab_none', 'name', 'lyt_data_1', 2, 'string', 'text', 'name', 'name', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_ui_omzone', 'form_feature', 'tab_none', 'descript', 'lyt_data_1', 3, 'text', 'text', 'descript', 'descript', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_ui_omzone', 'form_feature', 'tab_none', 'omzone_type', 'lyt_data_1', 4, 'string', 'combo', 'omzone_type', 'omzone_type', NULL, false, false, true, false, NULL, 'SELECT id, idval FROM edit_typevalue WHERE typevalue=''sector_type''', true, true, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_ui_omzone', 'form_feature', 'tab_none', 'macroomzone', 'lyt_data_1', 5, 'string', 'combo', 'macroomzone_id', 'macroomzone_id', NULL, false, false, true, false, NULL, 'SELECT name as id, name as idval FROM macroomzone WHERE macroomzone_id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_ui_omzone', 'form_feature', 'tab_none', 'avg_press', 'lyt_data_1', 6, 'numeric', 'text', 'average pressure', 'avg_press', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_ui_omzone', 'form_feature', 'tab_none', 'muni_id', 'lyt_data_1', 7, 'text', 'text', 'muni_id', 'muni_id', 'Ex: 1,2', false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_ui_omzone', 'form_feature', 'tab_none', 'expl_id', 'lyt_data_2', 8, 'text', 'text', 'expl_id', 'expl_id', 'Ex: 1,2', false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"label":"color:red; font-weight:bold"}'::json, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_ui_omzone', 'form_feature', 'tab_none', 'link', 'lyt_data_3', 9, 'text', 'text', 'link', 'link', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_ui_omzone', 'form_feature', 'tab_none', 'undelete', 'lyt_data_1', 10, 'integer', 'combo', 'lock_level', 'lock_level', NULL, false, false, true, false, NULL, 'SELECT id, idval FROM edit_typevalue WHERE typevalue = ''value_lock_level'' AND id IS NOT NULL', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_ui_omzone', 'form_feature', 'tab_none', 'active', 'lyt_data_1', 11, 'boolean', 'check', 'active', 'active', NULL, false, false, true, false, false, NULL, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);


INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_ui_macroomzone', 'form_feature', 'tab_none', 'macroomzone_id', 'lyt_data_1', 1, 'integer', 'text', 'macroomzone_id', 'macroomzone_id', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false, "valueRelation":{"nullValue":true, "layer": "v_edit_macroomzone", "activated": true, "keyColumn": "macroomzone_id", "valueColumn": "name", "filterExpression": null}}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_ui_macroomzone', 'form_feature', 'tab_none', 'code', 'lyt_data_1', 2, 'string', 'text', 'code', 'code', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_ui_macroomzone', 'form_feature', 'tab_none', 'name', 'lyt_data_1', 3, 'string', 'text', 'name', 'name', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_ui_macroomzone', 'form_feature', 'tab_none', 'descript', 'lyt_data_1', 4, 'text', 'text', 'descript', 'descript', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_ui_macroomzone', 'form_feature', 'tab_none', 'expl_id', 'lyt_data_1', 5, 'text', 'text', 'expl_id', 'expl_id', 'Ex: 1,2', false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"label":"color:red; font-weight:bold"}'::json, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_ui_macroomzone', 'form_feature', 'tab_none', 'active', 'lyt_data_1', 6, 'boolean', 'check', 'active', 'active', NULL, false, false, true, false, false, NULL, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_ui_macroomzone', 'form_feature', 'tab_none', 'lock_level', 'lyt_data_1', 7, 'integer', 'combo', 'lock_level', 'lock_level', NULL, false, false, true, false, NULL, 'SELECT id, idval FROM edit_typevalue WHERE typevalue = ''value_lock_level'' AND id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);



UPDATE config_form_fields SET "label"='Block_code',columnname='block_code',tooltip='block_code' WHERE formname='v_edit_connec' AND formtype='form_feature' AND columnname='block_zone' AND tabname='tab_data';
UPDATE config_form_fields SET "label"='Block_code',columnname='block_code',tooltip='block_code' WHERE formname='ve_connec_wjoin' AND formtype='form_feature' AND columnname='block_zone' AND tabname='tab_data';
UPDATE config_form_fields SET "label"='Block_code',columnname='block_code',tooltip='block_code' WHERE formname='ve_connec_vconnec' AND formtype='form_feature' AND columnname='block_zone' AND tabname='tab_data';
UPDATE config_form_fields SET "label"='Block_code',columnname='block_code',tooltip='block_code' WHERE formname='ve_connec_fountain' AND formtype='form_feature' AND columnname='block_zone' AND tabname='tab_data';
UPDATE config_form_fields SET "label"='Block_code',columnname='block_code',tooltip='block_code' WHERE formname='ve_connec_tap' AND formtype='form_feature' AND columnname='block_zone' AND tabname='tab_data';
UPDATE config_form_fields SET "label"='Block_code',columnname='block_code',tooltip='block_code' WHERE formname='ve_connec_greentap' AND formtype='form_feature' AND columnname='block_zone' AND tabname='tab_data';

UPDATE sys_function SET descript='Function to analyze network as a graph. Multiple analysis is avaliable (SECTOR, DQA, PRESSZONE & DMA). Before start you need to configurate:
- Field graph_delimiter on [cat_feature_node] table. 
- Field graphconfig on [dma, sector, cat_presszone and dqa] tables.
- Enable status for variable utils_graphanalytics_status on [config_param_system] table.
Stop your mouse over labels for more information about input parameters.
This function could be automatic triggered by valve status (open or closed) by configuring utils_graphanalytics_automatic_trigger variable on [config_param_system] table.' WHERE id=2768;


UPDATE config_form_fields SET dv_querytext =  'SELECT id, matcat_id as idval FROM cat_mat_roughness'
WHERE formname='generic' AND formtype='nvo_roughness' AND columnname='matcat_id' AND tabname='tab_none';
UPDATE sys_fprocess SET query_text='SELECT node_id, nodecat_id, n.the_geom, n.expl_id FROM man_valve JOIN t_node n USING (node_id) JOIN t_arc v ON v.arc_id = to_arc WHERE node_id NOT IN (node_1, node_2)' WHERE fid=170;
UPDATE sys_fprocess SET query_text='SELECT node_id, nodecat_id, n.the_geom, n.expl_id FROM man_pump JOIN t_node n USING (node_id) JOIN t_arc v ON v.arc_id = to_arc WHERE node_id NOT IN (node_1, node_2)' WHERE fid=171;

UPDATE inp_typevalue SET idval='HEADPUMP',id='HEADPUMP' WHERE typevalue='inp_typevalue_pumptype' AND id='PRESSPUMP';
UPDATE inp_typevalue SET idval='POWERPUMP',id='POWERPUMP' WHERE typevalue='inp_typevalue_pumptype' AND id='FLOWPUMP';


INSERT INTO connec_add (connec_id) SELECT connec_id FROM connec ON CONFLICT (connec_id) DO NOTHING;


INSERT INTO sys_table (id, descript, sys_role, project_template, context, orderby, alias, notify_action, isaudit, keepauditdays, "source", addparam) VALUES('v_edit_supplyzone', 'Shows editable information about supplyzone.', 'role_basic', '{"template": [1]}', '{"level_1":"INVENTORY","level_2":"MAP ZONES"}', 6, 'Supplyzone', NULL, NULL, NULL, 'core', NULL);

UPDATE sys_table SET project_template = '{"template": [1]}'
WHERE id IN (
	'v_edit_macrodma',
	'v_edit_dma',
	'v_edit_dqa',
	'v_edit_presszone'
);


INSERT INTO sys_table (id, descript, sys_role) VALUES ('archived_psector_arc_traceability', 'archived_psector_arc_traceability', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('archived_psector_connec_traceability', 'archived_psector_connec_traceability', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('archived_psector_link_traceability', 'archived_psector_link_traceability', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('archived_psector_node_traceability', 'archived_psector_node_traceability', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('archived_rpt_arc_stats', 'archived_rpt_arc_stats', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('archived_rpt_inp_arc', 'archived_rpt_inp_arc', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('archived_rpt_inp_node', 'archived_rpt_inp_node', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('archived_rpt_node_stats', 'archived_rpt_node_stats', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('cat_feature_element', 'cat_feature_element', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('cat_feature_link', 'cat_feature_link', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('cat_link', 'cat_link', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('config_form_help', 'config_form_help', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('doc_x_element', 'doc_x_element', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('doc_x_link', 'doc_x_link', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('element_x_link', 'element_x_link', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('ext_region_x_province', 'ext_region_x_province', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('inp_dscenario_frpump', 'inp_dscenario_frpump', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('inp_dscenario_frvalve', 'inp_dscenario_frvalve', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('inp_frpump', 'inp_frpump', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('inp_frvalve', 'inp_frvalve', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('macroomzone', 'macroomzone', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('man_frelem', 'man_frelem', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('man_genelem', 'man_genelem', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('man_pipelink', 'man_pipelink', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('minsector_mincut', 'minsector_mincut', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('om_visit_x_link', 'om_visit_x_link', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('omzone', 'omzone', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('supplyzone', 'supplyzone', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('sys_feature_class', 'sys_feature_class', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('v_edit_cat_feature_link', 'v_edit_cat_feature_link', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('v_edit_inp_dscenario_frpump', 'v_edit_inp_dscenario_frpump', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('v_edit_inp_dscenario_frvalve', 'v_edit_inp_dscenario_frvalve', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('v_edit_inp_frpump', 'v_edit_inp_frpump', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('v_edit_inp_frvalve', 'v_edit_inp_frvalve', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('v_edit_macroexploitation', 'v_edit_macroexploitation', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('v_edit_macroomzone', 'v_edit_macroomzone', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('v_edit_omzone', 'v_edit_omzone', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('v_rpt_arc_stats', 'v_rpt_arc_stats', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('v_rpt_node_stats', 'v_rpt_node_stats', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('v_ui_doc_x_element', 'v_ui_doc_x_element', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('v_ui_doc_x_link', 'v_ui_doc_x_link', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('v_ui_element_x_link', 'v_ui_element_x_link', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('v_ui_event_x_link', 'v_ui_event_x_link', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('v_ui_macrodma', 'v_ui_macrodma', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('v_ui_macrodqa', 'v_ui_macrodqa', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('v_ui_macroomzone', 'v_ui_macroomzone', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('v_ui_macrosector', 'v_ui_macrosector', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('v_ui_om_visit_x_link', 'v_ui_om_visit_x_link', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('v_ui_om_visitman_x_link', 'v_ui_om_visitman_x_link', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('v_ui_omzone', 'v_ui_omzone', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('v_ui_supplyzone', 'v_ui_supplyzone', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('v_ui_sys_style', 'v_ui_sys_style', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('ve_epa_frpump', 've_epa_frpump', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('ve_epa_frvalve', 've_epa_frvalve', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('ve_genelem', 've_genelem', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('vu_element_x_arc', 'vu_element_x_arc', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('vu_element_x_connec', 'vu_element_x_connec', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('vu_element_x_link', 'vu_element_x_link', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('vu_element_x_node', 'vu_element_x_node', 'role_edit');

DELETE FROM sys_table WHERE id = 'audit_psector_arc_traceability';
DELETE FROM sys_table WHERE id = 'audit_psector_connec_traceability';
DELETE FROM sys_table WHERE id = 'audit_psector_node_traceability';
DELETE FROM sys_table WHERE id = 'doc_type';
DELETE FROM sys_table WHERE id = 'inp_backdrop';
DELETE FROM sys_table WHERE id = 'macrominsector';
DELETE FROM sys_table WHERE id = 'selector_netscenario';
DELETE FROM sys_table WHERE id = 'sys_feature_cat';
DELETE FROM sys_table WHERE id = 'v_arc';
DELETE FROM sys_table WHERE id = 'v_connec';
DELETE FROM sys_table WHERE id = 'v_edit_element';
DELETE FROM sys_table WHERE id = 'v_link';
DELETE FROM sys_table WHERE id = 'v_link_connec';
DELETE FROM sys_table WHERE id = 'v_node';
DELETE FROM sys_table WHERE id = 'v_om_mincut_current_initpoint';
DELETE FROM sys_table WHERE id = 'v_om_visit';
DELETE FROM sys_table WHERE id = 'v_plan_psector_budget_node';
DELETE FROM sys_table WHERE id = 'v_rpt_arc_all';
DELETE FROM sys_table WHERE id = 'v_rpt_compare_arc';
DELETE FROM sys_table WHERE id = 'v_rpt_node_all';
DELETE FROM sys_table WHERE id = 'v_state_link_connec';
DELETE FROM sys_table WHERE id = 've_arc';
DELETE FROM sys_table WHERE id = 've_connec';
DELETE FROM sys_table WHERE id = 've_node';
DELETE FROM sys_table WHERE id = 'vi_backdrop';
DELETE FROM sys_table WHERE id = 'vi_controls';
DELETE FROM sys_table WHERE id = 'vi_coordinates';
DELETE FROM sys_table WHERE id = 'vi_curves';
DELETE FROM sys_table WHERE id = 'vi_demands';
DELETE FROM sys_table WHERE id = 'vi_emitters';
DELETE FROM sys_table WHERE id = 'vi_energy';
DELETE FROM sys_table WHERE id = 'vi_junctions';
DELETE FROM sys_table WHERE id = 'vi_labels';
DELETE FROM sys_table WHERE id = 'vi_mixing';
DELETE FROM sys_table WHERE id = 'vi_options';
DELETE FROM sys_table WHERE id = 'vi_parent_dma';
DELETE FROM sys_table WHERE id = 'vi_patterns';
DELETE FROM sys_table WHERE id = 'vi_pipes';
DELETE FROM sys_table WHERE id = 'vi_pjointpattern';
DELETE FROM sys_table WHERE id = 'vi_pumps';
DELETE FROM sys_table WHERE id = 'vi_quality';
DELETE FROM sys_table WHERE id = 'vi_reactions';
DELETE FROM sys_table WHERE id = 'vi_report';
DELETE FROM sys_table WHERE id = 'vi_reservoirs';
DELETE FROM sys_table WHERE id = 'vi_rules';
DELETE FROM sys_table WHERE id = 'vi_sources';
DELETE FROM sys_table WHERE id = 'vi_status';
DELETE FROM sys_table WHERE id = 'vi_tags';
DELETE FROM sys_table WHERE id = 'vi_tanks';
DELETE FROM sys_table WHERE id = 'vi_times';
DELETE FROM sys_table WHERE id = 'vi_title';
DELETE FROM sys_table WHERE id = 'vi_valves';
DELETE FROM sys_table WHERE id = 'vi_vertices';
DELETE FROM sys_table WHERE id = 'vu_arc';
DELETE FROM sys_table WHERE id = 'vu_connec';
DELETE FROM sys_table WHERE id = 'vu_exploitation';
DELETE FROM sys_table WHERE id = 'vu_ext_municipality';
DELETE FROM sys_table WHERE id = 'vu_link';
DELETE FROM sys_table WHERE id = 'vu_macroexploitation';
DELETE FROM sys_table WHERE id = 'vu_macrosector';
DELETE FROM sys_table WHERE id = 'vu_node';
DELETE FROM sys_table WHERE id = 'vu_om_mincut';



UPDATE sys_function SET function_alias = 'CALCULATE THE REACH OF HYDRANTS' WHERE function_name = 'gw_fct_graphanalytics_hydrant';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3514, 'Process executed for hydrant: %rec_hydrant%.', null, 0, true, 'utils', 'core', 'AUDIT');

UPDATE sys_function SET function_alias = 'DATA QUALITY ANALYSIS ACORDING graph ANALYTICS RULES' WHERE function_name = 'gw_fct_graphanalytics_check_data';



UPDATE sys_function SET function_alias = 'CHECK USER DATA' WHERE function_name = 'gw_fct_user_check_data';

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source", function_alias) VALUES
(3390, 'gw_fct_admin_forms_renum_layoutorder', 'ws', 'function', NULL, NULL, NULL, NULL, NULL, 'core', NULL),
(3392, 'gw_fct_audit_manager', 'ws', 'function', NULL, NULL, NULL, NULL, NULL, 'core', NULL),
(3394, 'gw_fct_check_fprocess', 'ws', 'function', NULL, NULL, NULL, NULL, NULL, 'core', NULL),
(3396, 'gw_fct_create_full_network_dscenario', 'ws', 'function', NULL, NULL, NULL, NULL, NULL, 'core', NULL),
(3398, 'gw_fct_execute_foreign_audit', 'ws', 'function', NULL, NULL, NULL, NULL, NULL, 'core', NULL),
(3400, 'gw_fct_graphanalytics_initnetwork', 'ws', 'function', NULL, NULL, NULL, NULL, NULL, 'core', NULL),
(3402, 'gw_fct_graphanalytics_manage_temporary', 'ws', 'function', NULL, NULL, NULL, NULL, NULL, 'core', NULL),
(3404, 'gw_fct_graphanalytics_mapzones_v1', 'ws', 'function', NULL, NULL, NULL, NULL, NULL, 'core', NULL),
(3406, 'gw_fct_manage_temp_tables', 'ws', 'function', NULL, NULL, NULL, NULL, NULL, 'core', NULL),
(3408, 'gw_fct_update_audit_triggers', 'ws', 'function', NULL, NULL, NULL, NULL, NULL, 'core', NULL),
(3410, 'gw_trg_array_fk_array_table', 'ws', 'function', NULL, NULL, NULL, NULL, NULL, 'core', NULL),
(3412, 'gw_trg_array_fk_id_table', 'ws', 'function', NULL, NULL, NULL, NULL, NULL, 'core', NULL),
(3414, 'gw_trg_audit', 'ws', 'function', NULL, NULL, NULL, NULL, NULL, 'core', NULL),
(3416, 'gw_trg_cat_manager', 'ws', 'function', NULL, NULL, NULL, NULL, NULL, 'core', NULL),
(3418, 'gw_trg_edit_macroomzone', 'ws', 'function', NULL, NULL, NULL, NULL, NULL, 'core', NULL),
(3420, 'gw_trg_edit_omzone', 'ws', 'function', NULL, NULL, NULL, NULL, NULL, 'core', NULL),
(3422, 'gw_trg_presszone_check_datatype', 'ws', 'function', NULL, NULL, NULL, NULL, NULL, 'core', NULL);




UPDATE sys_function SET function_alias = 'NODE TOPOLOGICAL CONSISTENCY ANALYSIS' WHERE function_name = 'gw_fct_anl_node_topological_consistency';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3594, 'There are %v_count% nodes with topological inconsistency.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3596, 'There are no nodes with topological inconsistency.', null, 0, true, 'utils', 'core', 'AUDIT');



-- Insert mapzone supplyzones widgets
INSERT INTO config_form_fields VALUES('v_ui_supplyzone', 'form_feature', 'tab_none', 'supplyzone_id', 'lyt_data_1', 1, 'integer', 'text', 'supplyzone_id', 'supplyzone_id', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline": false, "valueRelation":{"nullValue":true, "layer": "v_edit_supplyzone", "activated": true, "keyColumn": "supplyzone_id", "valueColumn": "name", "filterExpression": null}}', NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES('v_ui_supplyzone', 'form_feature', 'tab_none', 'name', 'lyt_data_1', 2, 'string', 'text', 'name', 'name', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}', NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES('v_ui_supplyzone', 'form_feature', 'tab_none', 'supplyzone_type', 'lyt_data_1', 3, 'string', 'combo', 'supplyzone_type', 'supplyzone_type', NULL, false, false, true, false, NULL, 'SELECT id, idval FROM edit_typevalue WHERE typevalue=''supplyzone_type''', true, true, NULL, NULL, NULL, '{"setMultiline":false}', NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES('v_ui_supplyzone', 'form_feature', 'tab_none', 'macrosector', 'lyt_data_1', 4, 'string', 'combo', 'macrosector', 'macrosector', NULL, false, false, true, false, NULL, 'SELECT name as id, name as idval FROM macrosector WHERE macrosector_id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline":false}', NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES('v_ui_supplyzone', 'form_feature', 'tab_none', 'descript', 'lyt_data_1', 5, 'text', 'text', 'descript', 'descript', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}', NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES('v_ui_supplyzone', 'form_feature', 'tab_none', 'active', 'lyt_data_1', 6, 'boolean', 'check', 'active', 'active', NULL, false, false, true, false, false, NULL, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES('v_ui_supplyzone', 'form_feature', 'tab_none', 'lock_level', 'lyt_data_1', 7, 'integer', 'combo', 'lock_level', 'lock_level', NULL, false, false, true, false, NULL, 'SELECT id, idval FROM edit_typevalue WHERE typevalue = ''value_lock_level'' AND id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline":false}', NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES('v_ui_supplyzone', 'form_feature', 'tab_none', 'parent_id', 'lyt_data_1', 8, 'string', 'combo', 'parent_id', 'parent_id', NULL, false, false, true, false, false, 'SELECT supplyzone_id as id,name as idval FROM v_ui_supplyzone WHERE supplyzone_id > -1 AND active IS TRUE', true, true, NULL, NULL, NULL, '{"setMultiline": false, "valueRelation":{"nullValue":true, "layer": "v_edit_supplyzone", "activated": true, "keyColumn": "supplyzone_id", "valueColumn": "name", "filterExpression": "supplyzone_id > -1 AND active IS TRUE"}}', NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES('v_ui_supplyzone', 'form_feature', 'tab_none', 'pattern_id', 'lyt_data_1', 9, 'string', 'combo', 'pattern_id', 'pattern_id', NULL, false, false, true, false, false, 'SELECT DISTINCT (pattern_id) AS id,  pattern_id  AS idval FROM inp_pattern WHERE pattern_id IS NOT NULL', true, true, NULL, NULL, NULL, '{"setMultiline": false, "valueRelation":{"nullValue":true, "layer": "v_edit_inp_pattern", "activated": true, "keyColumn": "pattern_id", "valueColumn": "pattern_id", "filterExpression": null}}', NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES('v_ui_supplyzone', 'form_feature', 'tab_none', 'graphconfig', 'lyt_data_1', 10, 'string', 'text', 'graphconfig', 'graphconfig', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}', NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES('v_ui_supplyzone', 'form_feature', 'tab_none', 'stylesheet', 'lyt_data_1', 11, 'string', 'text', 'stylesheet', 'stylesheet', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}', NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES ('v_ui_supplyzone','form_feature','tab_none','avg_press','lyt_data_1',12,'numeric','text','average pressure','avg_press', NULL,false,false,true,false, NULL, NULL, NULL, NULL, NULL, NULL, NULL,'{"setMultiline":false}'::json, NULL, NULL,false, NULL);
INSERT INTO config_form_fields VALUES ('v_ui_supplyzone','form_feature','tab_none','link','lyt_data_1',13,'text','text','link','link', NULL,false,false,true,false, NULL, NULL, NULL, NULL, NULL, NULL, NULL,'{"setMultiline":false}'::json, NULL, NULL,false, NULL);
INSERT INTO config_form_fields VALUES ('v_ui_supplyzone','form_feature','tab_none','muni_id','lyt_data_1',14,'text','text','muni_id','muni_id', 'Ex: 1,2',false,false,true,false, NULL, NULL, NULL, NULL, NULL, NULL, NULL,'{"setMultiline":false}'::json, NULL, NULL,false, NULL);
INSERT INTO config_form_fields VALUES ('v_ui_supplyzone','form_feature','tab_none','expl_id','lyt_data_1',15,'text','text','expl_id','expl_id', 'Ex: 1,2',false,false,true,false, NULL, NULL, NULL, NULL, NULL, NULL, NULL,'{"setMultiline":false}'::json, NULL, NULL,false, NULL);

-- Insert mapzone macrodma widgets
INSERT INTO config_form_fields VALUES('v_ui_macrodma', 'form_feature', 'tab_none', 'macrodma_id', 'lyt_data_1', 1, 'integer', 'text', 'macrodma_id', 'macrodma_id', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false, "valueRelation":{"nullValue":true, "layer": "v_edit_macrodma", "activated": true, "keyColumn": "macrodma_id", "valueColumn": "name", "filterExpression": null}}', NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES('v_ui_macrodma', 'form_feature', 'tab_none', 'name', 'lyt_data_1', 2, 'string', 'text', 'name', 'name', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}', NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES('v_ui_macrodma', 'form_feature', 'tab_none', 'descript', 'lyt_data_1', 3, 'text', 'text', 'descript', 'descript', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}', NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES('v_ui_macrodma', 'form_feature', 'tab_none', 'active', 'lyt_data_1', 4, 'boolean', 'check', 'active', 'active', NULL, false, false, true, false, false, NULL, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES('v_ui_macrodma', 'form_feature', 'tab_none', 'lock_level', 'lyt_data_1', 5, 'integer', 'combo', 'lock_level', 'lock_level', NULL, false, false, true, false, NULL, 'SELECT id, idval FROM edit_typevalue WHERE typevalue = ''value_lock_level'' AND id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline":false}', NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES('v_ui_macrodma', 'form_feature', 'tab_none', 'expl_id', 'lyt_data_1',6, 'text', 'text', 'expl_id', 'expl_id', 'Ex: 1,2', false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);

-- Insert mapzone macrosector widgets
INSERT INTO config_form_fields VALUES('v_ui_macrosector', 'form_feature', 'tab_none', 'macrosector_id', 'lyt_data_1', 1, 'integer', 'text', 'macrosector_id', 'macrosector_id', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false, "valueRelation":{"NULLValue":true, "layer": "v_edit_macrosector", "activated": true, "keyColumn": "macrosector_id", "valueColumn": "name", "filterExpression": null}}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES('v_ui_macrosector', 'form_feature', 'tab_none', 'name', 'lyt_data_1', 2, 'string', 'text', 'name', 'name', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES('v_ui_macrosector', 'form_feature', 'tab_none', 'descript', 'lyt_data_1', 3, 'text', 'text', 'descript', 'descript', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES('v_ui_macrosector', 'form_feature', 'tab_none', 'active', 'lyt_data_1', 4, 'boolean', 'check', 'active', 'active', NULL, false, false, true, false, false, NULL, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES('v_ui_macrosector', 'form_feature', 'tab_none', 'lock_level', 'lyt_data_1', 5, 'integer', 'combo', 'lock_level', 'lock_level', NULL, false, false, true, false, NULL, 'SELECT id, idval FROM edit_typevalue WHERE typevalue = ''value_lock_level'' AND id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);



INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3542, 'No mincuts are being executed right now: %v_count%.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3544, 'There are: %v_count% mincuts being executed at the moment..', null, 0, true, 'utils', 'core', 'AUDIT');


UPDATE sys_function SET function_alias = 'CREATE DSCENARIO' WHERE function_name = 'gw_fct_create_dscenario_demand';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (3530, 'ERROR: The dscenario ( %v_scenarioid% ) already exists with proposed name %v_name%. Please try another one.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3532, 'New scenario %v_name% have been created with id:%v_scenarioid% .', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3534, 'Feature type: %v_featuretype%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3536, 'Exploitation: %v_expl%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3538, 'Selection mode: %v_selectionmode%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (3540, 'INFO: Process done successfully.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (3722, 'INFO: %v_count% rows with features have been inserted on table %v_table%.', null, 0, true, 'utils', 'core', 'AUDIT');


INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3706, 'INFO: %v_count% features have been inserted on table %v_table%.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3708, 'New scenario %v_name% have been created with id:%v_scenarioid%.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3710, 'Exploitation: %v_expl%.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3712, 'Selection mode: %v_selectionmode%.', null, 0, true, 'utils', 'core', 'AUDIT');

UPDATE sys_function SET function_alias = 'SHOW CURRENTLY EXECUTED MINCUTS' WHERE function_name = 'ws_gw_fct_mincut_show_current';



UPDATE config_toolbox SET inputparams='[
  {
    "widgetname": "exploitation",
    "label": "Exploitation:",
    "widgettype": "combo",
    "datatype": "text",
    "tooltip": "Choose exploitation to work with",
    "layoutname": "grl_option_parameters",
    "layoutorder": 2,
    "dvQueryText": "SELECT id, idval FROM ( SELECT -901 AS id, ''User selected expl'' AS idval, ''a'' AS sort_order UNION SELECT -902 AS id, ''All exploitations'' AS idval, ''b'' AS sort_order UNION SELECT expl_id AS id, name AS idval, ''c'' AS sort_order FROM exploitation WHERE active IS NOT FALSE ) a ORDER BY sort_order ASC, idval ASC",
    "selectedId": ""
  },
  {
    "widgetname": "usePlanPsector",
    "label": "Use masterplan psectors:",
    "widgettype": "check",
    "datatype": "boolean",
    "layoutname": "grl_option_parameters",
    "layoutorder": 6,
    "value": ""
  },
  {
    "widgetname": "commitChanges",
    "label": "Commit changes:",
    "widgettype": "check",
    "datatype": "boolean",
    "layoutname": "grl_option_parameters",
    "layoutorder": 7,
    "value": ""
  },
  {
    "widgetname": "updateMapZone",
    "label": "Update mapzone geometry method:",
    "widgettype": "combo",
    "datatype": "integer",
    "layoutname": "grl_option_parameters",
    "layoutorder": 8,
    "comboIds": [
      0,
      1,
      2,
      3
    ],
    "comboNames": [
      "NONE",
      "CONCAVE POLYGON",
      "PIPE BUFFER",
      "PLOT & PIPE BUFFER"
    ],
    "selectedId": ""
  },
  {
    "widgetname": "geomParamUpdate",
    "label": "Geometry parameter:",
    "widgettype": "text",
    "datatype": "float",
    "layoutname": "grl_option_parameters",
    "layoutorder": 10,
    "isMandatory": false,
    "placeholder": "5-30",
    "value": ""
  }
]'::json WHERE id=2706;



UPDATE sys_function SET function_alias = 'INSERT FEATURES WITH PATTERN INTO DEMAND DSCENARIO' WHERE function_name = 'gw_fct_set_netscenario_pattern';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3756, '%v_count% connecs  were inserted into demand table.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3758, '%v_count% nodes were inserted into demand table.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3760, 'Exists %v_count% mapzones without assigned pattern_id. Fill the data before executing the process.', null, 0, true, 'utils', 'core', 'AUDIT');

UPDATE sys_function SET function_alias = 'CREATE EMPTY NETSCENARIO' WHERE function_name = 'gw_fct_create_netscenario_empty';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3762, 'Type: %v_netscenario_type%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3764, 'The netscenario ( %v_scenarioid% ) already exists with proposed name %v_name%. Please try another one.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3766, 'The new netscenario have been created sucessfully', null, 0, true, 'utils', 'core', 'AUDIT');

UPDATE sys_function SET function_alias = 'CREATE EMPTY NETSCENARIO' WHERE function_name = 'gw_fct_create_netscenario_from_toc';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3768, 'Mapzones configuration (graphconfig) related to selected exploitation has been copied to new netscenario.', null, 0, true, 'utils', 'core', 'AUDIT');


UPDATE sys_function SET function_alias = 'MASSIVE MINCUT ANALYSIS (fid 129 & 149)' WHERE function_name = 'gw_fct_massivemincut';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3770, 'All arcs (state=1) on the selected exploitation(s) have not minsector_id informed. Please check your data before continue', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3772, 'There are %v_count2% arcs (state=1) on the selected exploitation(s) without minsector_id informed. Please check your data before continue', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3774, 'There are %v_count1% arcs (state=1) on the selected exploitation(s) and all of them have minsector_id informed.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3776, 'Massive analysis have been done. %v_count1% mincut''s have been triggered (one by each minsector all of them using the mincut_id = -1). To check results you can query:', null, 0, true, 'utils', 'core', 'AUDIT');


UPDATE sys_function SET function_alias = 'CREATE EMPTY NETSCENARIO' WHERE function_name = 'gw_fct_duplicate_netscenario';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3800, 'Name: %v_name%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3802, 'Descript: %v_descript%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3804, 'Parent: %v_parent_id%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3806, 'Type: %v_netscenario_type%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3808, 'active: %v_active%', null, 0, true, 'utils', 'core', 'AUDIT');



INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (3810, 'ERROR: The netscenario ( %v_scenarioid% ) already exists with proposed name %v_name%. Please try another one.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (3812, 'The new netscenario have been created successfully.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (3814, 'Mapzones configuration (graphconfig) related to selected exploitation has been copied to new netscenario.', null, 0, true, 'utils', 'core', 'AUDIT');

ALTER TABLE cat_feature DISABLE TRIGGER gw_trg_cat_feature_after;

INSERT INTO sys_feature_class (id, type, epa_default, man_table) VALUES ('VLINK', 'LINK', 'VIRTUAL', 'man_vlink');
INSERT INTO sys_feature_class (id, type, epa_default, man_table) VALUES ('VCONNEC', 'CONNEC', 'VIRTUAL', 'man_vconnec');
UPDATE sys_feature_class SET id = 'PIPELINK', man_table = 'man_pipelink' WHERE id = 'LINK';

INSERT INTO cat_feature (id, feature_class, feature_type, parent_layer, child_layer, descript, active) VALUES ('VLINK', 'VLINK', 'LINK', 'v_edit_link', 've_link_vlink', 'Virtual link', true);

UPDATE cat_feature SET id = 'PIPELINK', child_layer = 've_link_pipelink' WHERE id = 'LINK';

INSERT INTO cat_feature_link (id) VALUES ('VLINK');

ALTER TABLE cat_feature ENABLE TRIGGER gw_trg_cat_feature_after;

-- Update sys_table context syntax and update config_typevalue references
DO $$
DECLARE
  level_values text[];
  output_json jsonb;
	layer record;
BEGIN

	FOR layer IN (SELECT * FROM config_typevalue WHERE typevalue = 'sys_table_context')
	LOOP
    -- Extract values of keys starting with 'level_' into an array
    IF layer.id::text NOT LIKE '{"levels":%}' THEN
      level_values := ARRAY(
          SELECT value::text
          FROM jsonb_each_text(layer.id::jsonb)
          WHERE key LIKE 'level_%'
          ORDER BY key
      );

      -- Build the resulting JSON
      output_json := jsonb_build_object('levels', level_values);

    UPDATE config_typevalue SET id = output_json WHERE id = layer.id AND typevalue = 'sys_table_context';
  END IF;

	END LOOP;
END
$$;


UPDATE sys_function SET function_alias = 'SET INITLEVEL VALUES' WHERE function_name = 'gw_fct_pg2epa_setinitvalues';

DO $$
DECLARE
  level_values text[];
  output_json jsonb;
	layer record;
BEGIN

	FOR layer IN (select * from sys_table where context is not null)
	LOOP
    IF layer.context::text NOT LIKE '{"levels":%}' THEN
      -- Extract values of keys starting with 'level_' into an array
      level_values := ARRAY(
          SELECT value::text
          FROM jsonb_each_text(layer.context::jsonb)
          WHERE key LIKE 'level_%'
          ORDER BY key
      );

      -- Build the resulting JSON
      output_json := jsonb_build_object('levels', level_values);

      UPDATE sys_table set context = output_json where id = layer.id;
    END IF;
	END LOOP;
END
$$;

INSERT INTO sys_foreignkey (typevalue_table, typevalue_name, target_table, target_field, parameter_id, active) VALUES('config_typevalue', 'sys_table_context', 'sys_table', 'context', NULL, true);


UPDATE sys_table SET orderBy = 1, alias = 'Municipality', project_template='{"template": [1], "visibility": true, "levels_to_read": 2}'::jsonb,context='{"levels": ["BASEMAP", "ADDRESS"]}' WHERE id='v_ext_municipality';

UPDATE sys_table SET project_template='{"template": [1], "visibility": false, "levels_to_read": 2}'::jsonb WHERE id='v_edit_supplyzone';
UPDATE sys_table SET project_template='{"template": [1], "visibility": false, "levels_to_read": 2}'::jsonb WHERE id='v_edit_presszone';
UPDATE sys_table SET project_template='{"template": [1], "visibility": false, "levels_to_read": 2}'::jsonb WHERE id='v_edit_dqa';
UPDATE sys_table SET project_template='{"template": [1], "visibility": true, "levels_to_read": 2}'::jsonb, alias= 'Link' WHERE id='v_edit_link';
UPDATE sys_table SET project_template='{"template": [1], "visibility": false, "levels_to_read": 2}'::jsonb WHERE id='v_edit_macrodma';
UPDATE sys_table SET project_template='{"template": [1], "visibility": false, "levels_to_read": 2}'::jsonb WHERE id='v_edit_exploitation';
UPDATE sys_table SET project_template='{"template": [1], "visibility": false, "levels_to_read": 2}'::jsonb WHERE id='v_edit_sector';
UPDATE sys_table SET project_template='{"template": [1], "visibility": false, "levels_to_read": 2}'::jsonb WHERE id='v_edit_macrosector';
UPDATE sys_table SET project_template='{"template": [1], "visibility": true, "levels_to_read": 3}'::jsonb WHERE id='ve_pol_node';
UPDATE sys_table SET project_template='{"template": [1], "visibility": true, "levels_to_read": 3}'::jsonb WHERE id='ve_pol_connec';
UPDATE sys_table SET project_template='{"template": [1], "visibility": true, "levels_to_read": 2}'::jsonb WHERE id='v_edit_dimensions';
UPDATE sys_table SET project_template='{"template": [1], "visibility": false, "levels_to_read": 2}'::jsonb WHERE id='v_ext_address';
UPDATE sys_table SET project_template='{"template": [1], "visibility": true, "levels_to_read": 2}'::jsonb WHERE id='v_ext_plot';
UPDATE sys_table SET project_template='{"template": [1], "visibility": true, "levels_to_read": 2}'::jsonb WHERE id='v_ext_streetaxis';
UPDATE sys_table SET project_template='{"template": [1], "visibility": false, "levels_to_read": 2}'::jsonb WHERE id='v_edit_dma';
UPDATE sys_table SET project_template='{"template": [1], "visibility": true, "levels_to_read": 2}'::jsonb WHERE id='v_edit_cat_feature_arc';
UPDATE sys_table SET project_template='{"template": [1], "visibility": true, "levels_to_read": 2}'::jsonb, alias='Connec' WHERE id='v_edit_connec';
UPDATE sys_table SET project_template='{"template": [1], "visibility": true, "levels_to_read": 2}'::jsonb, alias='Arc' WHERE id='v_edit_arc';
UPDATE sys_table SET project_template='{"template": [1], "visibility": true, "levels_to_read": 2}'::jsonb WHERE id='cat_node';
UPDATE sys_table SET project_template='{"template": [1], "visibility": true, "levels_to_read": 2}'::jsonb WHERE id='cat_arc';
UPDATE sys_table SET project_template='{"template": [1], "visibility": true, "levels_to_read": 2}'::jsonb WHERE id='v_edit_cat_feature_node';
UPDATE sys_table SET project_template='{"template": [1], "visibility": true, "levels_to_read": 2}'::jsonb WHERE id='cat_connec';
UPDATE sys_table SET project_template='{"template": [1], "visibility": true, "levels_to_read": 2}'::jsonb WHERE id='v_edit_cat_feature_connec';
UPDATE sys_table SET project_template='{"template": [1], "visibility": true, "levels_to_read": 2}'::jsonb, alias = 'Node' WHERE id='v_edit_node';
UPDATE sys_table SET project_template='{"template": [1], "visibility": true, "levels_to_read": 2}'::jsonb WHERE id='cat_material';

UPDATE sys_table SET context = NULL, orderBy = NULL, alias = NULL WHERE id='ext_municipality';

UPDATE sys_style SET layername='v_ext_municipality' WHERE layername='ext_municipality' AND styleconfig_id=101;

DELETE FROM sys_table WHERE id = 've_link_link';


UPDATE config_typevalue SET addparam='{"orderBy":5}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["INVENTORY", "NETWORK", "POLYGON"]}';
UPDATE config_typevalue SET addparam='{"orderBy":4}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["INVENTORY", "NETWORK", "LINK"]}';
UPDATE config_typevalue SET addparam='{"orderBy":2}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["INVENTORY", "NETWORK", "ARC"]}';
UPDATE config_typevalue SET addparam='{"orderBy":3}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["INVENTORY", "NETWORK", "CONNEC"]}';
UPDATE config_typevalue SET addparam='{"orderBy":7}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["INVENTORY", "NETWORK", "GULLY"]}';
UPDATE config_typevalue SET addparam='{"orderBy":1}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["INVENTORY", "NETWORK", "NODE"]}';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4002, 'Initlevel of %v_count% inlets has been updated.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4004, 'Initlevel of %v_count% tanks has been updated.', null, 0, true, 'utils', 'core', 'AUDIT');


UPDATE sys_function SET function_alias = 'CALCULATE COST OF RECONSTRUCTION' WHERE function_name = 'gw_fct_plan_result_recr';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4006, 'I1ST. STEP Result with this name is already defined on plan_result tables.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4008, '1ST. STEP executed.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4010, 'Snapshot of values form v_plan_arc and v_plan_node have been inserted on plan_result_arc and plan_result_node tables.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4012, 'This proces enables to execute STEP 2 in order to calculate amortized values using age,cost and acoeff (amortized rate per year).', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4014, '2ND STEP executed.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4016, 'Amortized values using age,cost and acoeff have been calculated.', null, 0, true, 'utils', 'core', 'AUDIT');

UPDATE sys_function SET function_alias = 'MINSECTOR DYNAMIC SECTORITZATION' WHERE function_name = 'gw_fct_graphanalytics_minsector';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4018, 'Use psectors: %v_usepsector%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4020, 'Minsector attribute on arc/node/connec/link features have NOT BEEN updated by this process.', null, 0, true, 'utils', 'core', 'AUDIT');

UPDATE sys_function SET function_alias = 'SET PSECTOR COST FOR REMOVED PIPES' WHERE function_name = 'gw_fct_setpsectorcostremovedpipes';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4022, 'Missing node_1 or node_2 on arcs: %v_arc_list%. Please check your data before continue', null, 2, true, 'ws', 'core', 'UI');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4024, 'Minsector attribute on arc/node/connec/link features have been updated by this process.', null, 0, true, 'utils', 'core', 'AUDIT');

UPDATE sys_function SET function_alias = 'IMPORT DSCENARIO DEMAND' WHERE function_name = 'gw_fct_import_dscenario_demands';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3922, 'Reading values from temp_csv table -> Done', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3924, 'Inserting values on inp_dscenario_demand table -> Done', null, 0, true, 'utils', 'core', 'AUDIT');

UPDATE sys_function SET function_alias = 'BUILT MISSING NODES USING START/END VERTICES' WHERE function_name = 'gw_fct_setnodefromarc';



INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4026, 'There are no nodes to be repaired.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4028, '%v_count% nodes have been created to repair topology.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname)
VALUES('ignoreBrokenOnlyMassiveMincut', 'false', 'Ignore broken only on massive mincut', 'Ignore broken only on massive mincut:', NULL, NULL, false, NULL, 'ws', NULL, NULL, 'boolean', 'checkbox', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname)
VALUES('ignoreCheckValvesMincut', 'false', 'Ignore check valves on mincut', 'Ignore check valves on mincut:', NULL, NULL, false, NULL, 'ws', NULL, NULL, 'boolean', 'checkbox', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);



UPDATE sys_function SET function_alias = 'CREATE VALVE DSCENARIO FROM MINCUT' WHERE function_name = 'gw_fct_create_dscenario_from_mincut';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3954, 'New scenario %v_name% have been created with id:%v_scenarioid%.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3956, '%v_count% rows with features have been inserted on table inp_dscenario_shortpipe', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3958, '%v_count% rows with features have been inserted on table inp_dscenario_valve', null, 0, true, 'utils', 'core', 'AUDIT');





VALUES(4024, '%v_count% nodes have been created to repair topology.', null, 0, true, 'utils', 'core', 'AUDIT');

UPDATE sys_function SET function_alias = 'WATER BALANCE BY EXPLOITATION AND PERIOD' WHERE function_name = 'gw_fct_waterbalance';


INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4040, 'Process done succesfully for period: %v_period%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4042, 'Number of DMA processed: %v_count%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4030, 'Number of hydrometer processed: %v_hydrometer%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4032, 'Total System Input: %v_tsi% CMP', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4034, 'Billed metered consumtion: %v_bmc% CMP', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4036, 'Non-revenue water: %v_nrw% CMP', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4038, 'DMAs updated %v_day% days ago.', null, 0, true, 'utils', 'core', 'AUDIT');


UPDATE sys_function SET function_alias = 'IMPORT CLOSED VALVE FOR NETSCENARIO' WHERE function_name = 'gw_fct_import_netscenario_valve_closed';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (3858, 'Nothing to import', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (3860, 'Reading values from temp_csv table -> Done', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (3862, 'Inserting values on cat_dscenario table -> Done', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (3864, 'Inserting values on inp_dscenario_shortpipe table -> Done', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (3868, 'Netscenario doesn''t exist.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (3870, 'Data wasn''t imported.', null, 0, true, 'utils', 'core', 'AUDIT');


INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_data', 'sector_id', 'lyt_bot_1', 2, 'integer', 'combo', 'Sector ID', 'sector_id  - Sector identifier.', NULL, false, false, false, false, NULL, 'SELECT sector_id as id, name as idval FROM sector WHERE sector_id IS NOT NULL', true, false, NULL, NULL, '{"label":"color:red; font-weight:bold"}'::json, '{"setMultiline": false, "labelPosition": "top", "valueRelation": {"layer": "v_edit_sector", "activated": true, "keyColumn": "sector_id", "nullValue": false, "valueColumn": "name", "filterExpression": null}}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_data', 'dqa_id', 'lyt_bot_1', 3, 'integer', 'text', 'Dqa', 'dqa_id', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_data', 'state', 'lyt_bot_1', 4, 'integer', 'combo', 'State:', 'State:', NULL, false, false, true, false, NULL, 'SELECT id, name as idval FROM value_state WHERE id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_data', 'state_type', 'lyt_bot_1', 5, 'integer', 'combo', 'State type', 'state_type - The state type of the element. It allows to obtain more detail of the state. To select from those available depending on the chosen state', NULL, false, false, true, false, NULL, 'SELECT id, name as idval FROM value_state_type WHERE id IS NOT NULL', true, false, 'state', ' AND value_state_type.state', NULL, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_data', 'link_id', 'lyt_data_1', 1, 'integer', 'text', 'Link ID', 'Link ID', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_data', 'feature_type', 'lyt_data_1', 2, 'string', 'combo', 'Feature type', 'Feature type', NULL, false, false, false, false, NULL, 'SELECT id, id as idval FROM sys_feature_type WHERE id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_data', 'feature_id', 'lyt_data_1', 3, 'string', 'text', 'feature_id', 'feature_id', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_data', 'exit_type', 'lyt_data_1', 4, 'string', 'combo', 'Exit type', 'Exit type', NULL, false, false, false, false, NULL, 'SELECT id, idval FROM inp_typevalue WHERE typevalue=''inp_pjoint_type''', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_data', 'exit_id', 'lyt_data_1', 5, 'string', 'text', 'Exit ID', 'Exit ID', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_data', 'dma_id', 'lyt_data_1', 6, 'integer', 'combo', 'Dma ID', 'Dma ID', NULL, false, false, false, false, NULL, 'SELECT dma_id as id, name as idval FROM dma WHERE dma_id = 0 UNION SELECT dma_id as id, name as idval FROM dma WHERE dma_id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "v_edit_dma", "activated": true, "keyColumn": "dma_id", "valueColumn": "name", "filterExpression": null}}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_data', 'presszone_id', 'lyt_data_1', 7, 'integer', 'text', 'Presszone', 'presszone_id', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_data', 'minsector_id', 'lyt_data_1', 8, 'integer', 'text', 'minsector_id', 'minsector_id', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_data', 'fluid_type', 'lyt_data_1', 9, 'string', 'text', 'fluid_type', 'fluid_type', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_data', 'gis_length', 'lyt_data_1', 10, 'double', 'text', 'Gis length', 'Gis length', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_data', 'sector_name', 'lyt_data_1', 11, 'string', 'text', 'sector_name', 'sector_name', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_data', 'dma_name', 'lyt_data_1', 12, 'string', 'text', 'dma_name', 'dma_name', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_data', 'dqa_name', 'lyt_data_1', 13, 'string', 'text', 'dqa_name', 'dqa_name', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_data', 'presszone_name', 'lyt_data_1', 14, 'string', 'text', 'presszone_name', 'presszone_name', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_data', 'macrodma_id', 'lyt_data_1', 15, 'integer', 'text', 'Macrodma ID', 'Macrodma ID', NULL, false, false, false, false, NULL, 'SELECT macrodma_id as id, name as idval FROM macrodma WHERE macrodma_id IS NOT NULL', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_data', 'macrodqa_id', 'lyt_data_2', 1, 'integer', 'text', 'macrodqa_id', 'macrodqa_id', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_data', 'epa_type', 'lyt_data_2', 2, 'string', 'text', 'epa_type', 'epa_type', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_data', 'is_operative', 'lyt_data_2', 3, 'boolean', 'check', 'is_operative', 'is_operative', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_data', 'conneccat_id', 'lyt_data_2', 4, 'string', 'typeahead', 'Connecat ID', 'connecat_id - A seleccionar del catálogo de acometida. Es independiente del tipo de acometida', NULL, false, false, false, false, NULL, 'SELECT id, id as idval FROM cat_connec WHERE id IS NOT NULL AND active IS TRUE ', true, NULL, NULL, NULL, NULL, '{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "cat_connec", "activated": true, "keyColumn": "id", "valueColumn": "id", "filterExpression": null}}'::json, NULL, 'action_catalog', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_data', 'workcat_id', 'lyt_data_2', 5, 'string', 'typeahead', 'Workcat ID', 'workcat_id - Related to the catalog of work files (cat_work). File that registers the element', NULL, false, false, true, false, NULL, 'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE ', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'action_workcat', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_data', 'workcat_id_end', 'lyt_data_2', 6, 'string', 'typeahead', 'Workcat ID end', 'workcat_id_end - ID of the  end of construction work.', 'Only when state is obsolete', false, false, true, false, NULL, 'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE ', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_data', 'builtdate', 'lyt_data_2', 7, 'date', 'datetime', 'Builtdate:', 'builtdate - Date the element was added. In insertion of new elements the date of the day is shown', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_data', 'enddate', 'lyt_data_2', 8, 'date', 'datetime', 'Enddate', 'enddate - End date of the element. It will only be filled in if the element is in a deregistration state.', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_data', 'uncertain', 'lyt_data_2', 9, 'boolean', 'check', 'Uncertain', 'uncertain - To set if the element''s location is uncertain', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, true, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_data', 'top_elev1', 'lyt_data_2', 10, 'integer', 'text', 'Top Elev 1', 'top_elev1', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_data', 'depth1', 'lyt_data_2', 11, 'integer', 'text', 'Depth1', 'depth1', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_data', 'elevation1', 'lyt_data_2', 12, 'integer', 'text', 'Elevation1', 'elevation1', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_data', 'top_elev2', 'lyt_data_2', 13, 'integer', 'text', 'Top elev 2', 'top_elev2', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_data', 'depth2', 'lyt_data_2', 14, 'integer', 'text', 'Depth2', 'depth2', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_data', 'elevation2', 'lyt_data_2', 15, 'integer', 'text', 'Elevation2', 'elevation2', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_data', 'macrosector_id', 'lyt_data_1', 16, 'integer', 'combo', 'Macrosector id', 'Macrosector id', NULL, false, false, false, false, NULL, 'SELECT macrosector_id as id, name as idval FROM macrosector WHERE macrosector_id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_data', 'expl_id', 'lyt_bot_1', 1, 'integer', 'combo', 'Explotation ID', 'expl_id - Exploitation to which the element belongs. If the configuration is not changed, the program automatically selects it based on the geometry', NULL, false, false, false, false, NULL, 'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL', true, false, NULL, NULL, '{"label":"color:red; font-weight:bold"}'::json, '{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "v_edit_exploitation", "activated": true, "keyColumn": "expl_id", "valueColumn": "name", "filterExpression": null}}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_documents', 'date_from', 'lyt_document_1', 1, 'date', 'datetime', 'Date from:', 'Date from:', NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{"labelPosition": "top", "filterSign":">="}'::json, '{"functionName": "filter_table", "parameters":{"columnfind": "date"}}'::json, 'tbl_doc_x_link', false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_documents', 'date_to', 'lyt_document_1', 2, 'date', 'datetime', 'Date to:', 'Date to:', NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{"labelPosition": "top", "filterSign":"<="}'::json, '{"functionName": "filter_table", "parameters":{"columnfind": "date"}}'::json, 'tbl_doc_x_link', false, 2);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_documents', 'doc_type', 'lyt_document_1', 3, 'string', 'combo', 'Doc type:', 'Doc type:', NULL, false, false, true, false, true, 'SELECT id, idval FROM edit_typevalue WHERE typevalue = ''doc_type''', NULL, true, NULL, NULL, NULL, '{"labelPosition": "top"}'::json, '{"functionName": "filter_table", "parameters":{}}'::json, 'tbl_doc_x_link', false, 3);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_documents', 'doc_name', 'lyt_document_2', 1, 'string', 'typeahead', 'Doc id:', 'Doc id:', NULL, false, false, true, false, false, 'SELECT name as id, name as idval FROM doc WHERE name IS NOT NULL', NULL, NULL, NULL, NULL, NULL, '{"saveValue": false, "filterSign":"ILIKE"}'::json, '{"functionName": "filter_table"}'::json, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_documents', 'btn_doc_insert', 'lyt_document_2', 2, NULL, 'button', NULL, 'Insert document', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"113"}'::json, '{"saveValue":false, "filterSign":"="}'::json, '{
  "functionName": "add_object",
  "parameters": {
    "sourcewidget": "tab_documents_doc_name",
    "targetwidget": "tab_documents_tbl_documents",
    "sourceview": "doc"
  }
}'::json, 'tbl_doc_x_link', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_documents', 'btn_doc_delete', 'lyt_document_2', 3, NULL, 'button', NULL, 'Delete document', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"114"}'::json, '{"saveValue":false, "filterSign":"=", "onContextMenu":"Delete document"}'::json, '{"functionName": "delete_object", "parameters": {"columnfind": "doc_id", "targetwidget": "tab_documents_tbl_documents", "sourceview": "doc"}}'::json, 'tbl_doc_x_link', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_documents', 'btn_doc_new', 'lyt_document_2', 4, NULL, 'button', NULL, 'New document', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"143"}'::json, '{"saveValue":false, "filterSign":"="}'::json, '{
  "functionName": "manage_document",
  "parameters": {
    "sourcewidget": "tab_documents_doc_name",
    "targetwidget": "tab_documents_tbl_documents",
    "sourceview": "doc"
  }
}'::json, 'tbl_doc_x_link', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_documents', 'hspacer_document_1', 'lyt_document_2', 5, NULL, 'hspacer', NULL, NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_documents', 'open_doc', 'lyt_document_2', 6, NULL, 'button', NULL, 'Open document', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"147"}'::json, '{"saveValue":false, "filterSign":"=", "onContextMenu":"Open document"}'::json, '{
  "functionName": "open_selected_path",
  "parameters": {
    "columnfind": "path",
    "targetwidget": "tab_documents_tbl_documents",
    "sourceview": "doc"
  }
}'::json, 'tbl_doc_x_link', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_documents', 'tbl_documents', 'lyt_document_3', 1, NULL, 'tableview', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"saveValue": false}'::json, '{
  "functionName": "open_selected_path",
  "parameters": {
    "targetwidget": "tab_documents_tbl_documents",
    "columnfind": "path"
  }
}'::json, 'tbl_doc_x_link', false, 4);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_elements', 'element_id', 'lyt_element_1', 1, 'string', 'typeahead', 'Element id:', 'Element id', NULL, false, false, true, false, false, 'SELECT element_id as id, element_id as idval FROM element WHERE element_id IS NOT NULL ', NULL, NULL, NULL, NULL, NULL, '{"saveValue": false, "filterSign":"ILIKE"}'::json, '{"functionName": "filter_table", "parameters" : { "columnfind": "id"}}'::json, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_elements', 'insert_element', 'lyt_element_1', 2, NULL, 'button', NULL, 'Insert element', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"113"}'::json, '{"saveValue":false, "filterSign":"="}'::json, '{
	  "functionName": "add_object",
	  "parameters": {
	    "sourcewidget": "tab_elements_element_id",
	    "targetwidget": "tab_elements_tbl_elements",
	    "sourceview": "element"
	  }
	}'::json, 'v_edit_link', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_elements', 'delete_element', 'lyt_element_1', 3, NULL, 'button', NULL, 'Delete element', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"114"}'::json, '{"saveValue":false, "filterSign":"=", "onContextMenu":"Delete element"}'::json, '{ "functionName": "delete_object", "parameters": {"columnfind": "element_id", "targetwidget": "tab_elements_tbl_elements", "sourceview": "element"}}'::json, 'tbl_element_x_link', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_elements', 'new_element', 'lyt_element_1', 4, NULL, 'button', NULL, 'New element', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"143"}'::json, '{"saveValue":false, "filterSign":"="}'::json, '{
  "functionName": "manage_element_menu",
  "parameters": {
    "sourcetable": "v_ui_element_x_arc",
    "targetwidget": "tab_elements_tbl_elements",
    "field_object_id": "element_id",
    "sourceview": "element"
  }
}'::json, 'v_edit_link', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_elements', 'hspacer_lyt_element', 'lyt_element_1', 5, NULL, 'hspacer', NULL, NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_elements', 'open_element', 'lyt_element_1', 6, NULL, 'button', NULL, 'Open element', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"144"}'::json, '{"saveValue":false, "filterSign":"=", "onContextMenu":"Open element"}'::json, '{
  "functionName": "open_selected_manager_item",
  "parameters": {
    "columnfind": "element_id",
    "targetwidget": "tab_elements_tbl_elements"
  }
}'::json, 'v_edit_link', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_elements', 'btn_link', 'lyt_element_1', 7, NULL, 'button', NULL, 'Open link', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"173"}'::json, '{"saveValue":false, "filterSign":"=", "onContextMenu":"Open link"}'::json, '{
  "functionName": "open_selected_path",
  "parameters": {
    "targetwidget": "tab_elements_tbl_elements",
    "columnfind": "link_id"
  }
}'::json, 'v_edit_link', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_pipelink', 'form_feature', 'tab_elements', 'tbl_elements', 'lyt_element_3', 1, NULL, 'tableview', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"saveValue": false}'::json, '{
  "functionName": "open_selected_manager_item",
  "parameters": {
    "columnfind": "element_id"
  }
}'::json, 'tbl_element_x_link', false, 1);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'sector_id', 'lyt_bot_1', 2, 'integer', 'combo', 'Sector ID', 'sector_id  - Sector identifier.', NULL, false, false, false, false, NULL, 'SELECT sector_id as id, name as idval FROM sector WHERE sector_id IS NOT NULL', true, false, NULL, NULL, '{"label":"color:red; font-weight:bold"}'::json, '{"setMultiline": false, "labelPosition": "top", "valueRelation": {"layer": "v_edit_sector", "activated": true, "keyColumn": "sector_id", "nullValue": false, "valueColumn": "name", "filterExpression": null}}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'dqa_id', 'lyt_bot_1', 3, 'integer', 'text', 'Dqa', 'dqa_id', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'state', 'lyt_bot_1', 4, 'integer', 'combo', 'State:', 'State:', NULL, false, false, true, false, NULL, 'SELECT id, name as idval FROM value_state WHERE id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'state_type', 'lyt_bot_1', 5, 'integer', 'combo', 'State type', 'state_type - The state type of the element. It allows to obtain more detail of the state. To select from those available depending on the chosen state', NULL, false, false, true, false, NULL, 'SELECT id, name as idval FROM value_state_type WHERE id IS NOT NULL', true, false, 'state', ' AND value_state_type.state', NULL, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'link_id', 'lyt_data_1', 1, 'integer', 'text', 'Link ID', 'Link ID', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'feature_type', 'lyt_data_1', 2, 'string', 'combo', 'Feature type', 'Feature type', NULL, false, false, false, false, NULL, 'SELECT id, id as idval FROM sys_feature_type WHERE id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'feature_id', 'lyt_data_1', 3, 'string', 'text', 'feature_id', 'feature_id', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'exit_type', 'lyt_data_1', 4, 'string', 'combo', 'Exit type', 'Exit type', NULL, false, false, false, false, NULL, 'SELECT id, idval FROM inp_typevalue WHERE typevalue=''inp_pjoint_type''', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'exit_id', 'lyt_data_1', 5, 'string', 'text', 'Exit ID', 'Exit ID', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'dma_id', 'lyt_data_1', 6, 'integer', 'combo', 'Dma ID', 'Dma ID', NULL, false, false, false, false, NULL, 'SELECT dma_id as id, name as idval FROM dma WHERE dma_id = 0 UNION SELECT dma_id as id, name as idval FROM dma WHERE dma_id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "v_edit_dma", "activated": true, "keyColumn": "dma_id", "valueColumn": "name", "filterExpression": null}}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'presszone_id', 'lyt_data_1', 7, 'integer', 'text', 'Presszone', 'presszone_id', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'minsector_id', 'lyt_data_1', 8, 'integer', 'text', 'minsector_id', 'minsector_id', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'fluid_type', 'lyt_data_1', 9, 'string', 'text', 'fluid_type', 'fluid_type', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'gis_length', 'lyt_data_1', 10, 'double', 'text', 'Gis length', 'Gis length', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'sector_name', 'lyt_data_1', 11, 'string', 'text', 'sector_name', 'sector_name', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'dma_name', 'lyt_data_1', 12, 'string', 'text', 'dma_name', 'dma_name', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'dqa_name', 'lyt_data_1', 13, 'string', 'text', 'dqa_name', 'dqa_name', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'presszone_name', 'lyt_data_1', 14, 'string', 'text', 'presszone_name', 'presszone_name', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'macrodma_id', 'lyt_data_1', 15, 'integer', 'text', 'Macrodma ID', 'Macrodma ID', NULL, false, false, false, false, NULL, 'SELECT macrodma_id as id, name as idval FROM macrodma WHERE macrodma_id IS NOT NULL', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'macrodqa_id', 'lyt_data_2', 1, 'integer', 'text', 'macrodqa_id', 'macrodqa_id', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'epa_type', 'lyt_data_2', 2, 'string', 'text', 'epa_type', 'epa_type', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'is_operative', 'lyt_data_2', 3, 'boolean', 'check', 'is_operative', 'is_operative', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'conneccat_id', 'lyt_data_2', 4, 'string', 'typeahead', 'Connecat ID', 'connecat_id - A seleccionar del catálogo de acometida. Es independiente del tipo de acometida', NULL, false, false, false, false, NULL, 'SELECT id, id as idval FROM cat_connec WHERE id IS NOT NULL AND active IS TRUE ', true, NULL, NULL, NULL, NULL, '{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "cat_connec", "activated": true, "keyColumn": "id", "valueColumn": "id", "filterExpression": null}}'::json, NULL, 'action_catalog', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'workcat_id', 'lyt_data_2', 5, 'string', 'typeahead', 'Workcat ID', 'workcat_id - Related to the catalog of work files (cat_work). File that registers the element', NULL, false, false, true, false, NULL, 'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE ', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'action_workcat', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'workcat_id_end', 'lyt_data_2', 6, 'string', 'typeahead', 'Workcat ID end', 'workcat_id_end - ID of the  end of construction work.', 'Only when state is obsolete', false, false, true, false, NULL, 'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE ', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'builtdate', 'lyt_data_2', 7, 'date', 'datetime', 'Builtdate:', 'builtdate - Date the element was added. In insertion of new elements the date of the day is shown', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'enddate', 'lyt_data_2', 8, 'date', 'datetime', 'Enddate', 'enddate - End date of the element. It will only be filled in if the element is in a deregistration state.', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'uncertain', 'lyt_data_2', 9, 'boolean', 'check', 'Uncertain', 'uncertain - To set if the element''s location is uncertain', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, true, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'top_elev1', 'lyt_data_2', 10, 'integer', 'text', 'Top Elev 1', 'top_elev1', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'depth1', 'lyt_data_2', 11, 'integer', 'text', 'Depth1', 'depth1', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'elevation1', 'lyt_data_2', 12, 'integer', 'text', 'Elevation1', 'elevation1', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'top_elev2', 'lyt_data_2', 13, 'integer', 'text', 'Top elev 2', 'top_elev2', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'depth2', 'lyt_data_2', 14, 'integer', 'text', 'Depth2', 'depth2', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'elevation2', 'lyt_data_2', 15, 'integer', 'text', 'Elevation2', 'elevation2', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'macrosector_id', 'lyt_data_1', 16, 'integer', 'combo', 'Macrosector id', 'Macrosector id', NULL, false, false, false, false, NULL, 'SELECT macrosector_id as id, name as idval FROM macrosector WHERE macrosector_id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'expl_id', 'lyt_bot_1', 1, 'integer', 'combo', 'Explotation ID', 'expl_id - Exploitation to which the element belongs. If the configuration is not changed, the program automatically selects it based on the geometry', NULL, false, false, false, false, NULL, 'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL', true, false, NULL, NULL, '{"label":"color:red; font-weight:bold"}'::json, '{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "v_edit_exploitation", "activated": true, "keyColumn": "expl_id", "valueColumn": "name", "filterExpression": null}}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_documents', 'date_from', 'lyt_document_1', 1, 'date', 'datetime', 'Date from:', 'Date from:', NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{"labelPosition": "top", "filterSign":">="}'::json, '{"functionName": "filter_table", "parameters":{"columnfind": "date"}}'::json, 'tbl_doc_x_link', false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_documents', 'date_to', 'lyt_document_1', 2, 'date', 'datetime', 'Date to:', 'Date to:', NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{"labelPosition": "top", "filterSign":"<="}'::json, '{"functionName": "filter_table", "parameters":{"columnfind": "date"}}'::json, 'tbl_doc_x_link', false, 2);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_documents', 'doc_type', 'lyt_document_1', 3, 'string', 'combo', 'Doc type:', 'Doc type:', NULL, false, false, true, false, true, 'SELECT id, idval FROM edit_typevalue WHERE typevalue = ''doc_type''', NULL, true, NULL, NULL, NULL, '{"labelPosition": "top"}'::json, '{"functionName": "filter_table", "parameters":{}}'::json, 'tbl_doc_x_link', false, 3);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_documents', 'doc_name', 'lyt_document_2', 1, 'string', 'typeahead', 'Doc id:', 'Doc id:', NULL, false, false, true, false, false, 'SELECT name as id, name as idval FROM doc WHERE name IS NOT NULL', NULL, NULL, NULL, NULL, NULL, '{"saveValue": false, "filterSign":"ILIKE"}'::json, '{"functionName": "filter_table"}'::json, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_documents', 'btn_doc_insert', 'lyt_document_2', 2, NULL, 'button', NULL, 'Insert document', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"113"}'::json, '{"saveValue":false, "filterSign":"="}'::json, '{
  "functionName": "add_object",
  "parameters": {
    "sourcewidget": "tab_documents_doc_name",
    "targetwidget": "tab_documents_tbl_documents",
    "sourceview": "doc"
  }
}'::json, 'tbl_doc_x_link', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_documents', 'btn_doc_delete', 'lyt_document_2', 3, NULL, 'button', NULL, 'Delete document', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"114"}'::json, '{"saveValue":false, "filterSign":"=", "onContextMenu":"Delete document"}'::json, '{"functionName": "delete_object", "parameters": {"columnfind": "doc_id", "targetwidget": "tab_documents_tbl_documents", "sourceview": "doc"}}'::json, 'tbl_doc_x_link', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_documents', 'btn_doc_new', 'lyt_document_2', 4, NULL, 'button', NULL, 'New document', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"143"}'::json, '{"saveValue":false, "filterSign":"="}'::json, '{
  "functionName": "manage_document",
  "parameters": {
    "sourcewidget": "tab_documents_doc_name",
    "targetwidget": "tab_documents_tbl_documents",
    "sourceview": "doc"
  }
}'::json, 'tbl_doc_x_link', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_documents', 'hspacer_document_1', 'lyt_document_2', 5, NULL, 'hspacer', NULL, NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_documents', 'open_doc', 'lyt_document_2', 6, NULL, 'button', NULL, 'Open document', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"147"}'::json, '{"saveValue":false, "filterSign":"=", "onContextMenu":"Open document"}'::json, '{
  "functionName": "open_selected_path",
  "parameters": {
    "columnfind": "path",
    "targetwidget": "tab_documents_tbl_documents",
    "sourceview": "doc"
  }
}'::json, 'tbl_doc_x_link', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_documents', 'tbl_documents', 'lyt_document_3', 1, NULL, 'tableview', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"saveValue": false}'::json, '{
  "functionName": "open_selected_path",
  "parameters": {
    "targetwidget": "tab_documents_tbl_documents",
    "columnfind": "path"
  }
}'::json, 'tbl_doc_x_link', false, 4);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_elements', 'element_id', 'lyt_element_1', 1, 'string', 'typeahead', 'Element id:', 'Element id', NULL, false, false, true, false, false, 'SELECT element_id as id, element_id as idval FROM element WHERE element_id IS NOT NULL ', NULL, NULL, NULL, NULL, NULL, '{"saveValue": false, "filterSign":"ILIKE"}'::json, '{"functionName": "filter_table", "parameters" : { "columnfind": "id"}}'::json, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_elements', 'insert_element', 'lyt_element_1', 2, NULL, 'button', NULL, 'Insert element', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"113"}'::json, '{"saveValue":false, "filterSign":"="}'::json, '{
	  "functionName": "add_object",
	  "parameters": {
	    "sourcewidget": "tab_elements_element_id",
	    "targetwidget": "tab_elements_tbl_elements",
	    "sourceview": "element"
	  }
	}'::json, 'v_edit_link', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_elements', 'delete_element', 'lyt_element_1', 3, NULL, 'button', NULL, 'Delete element', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"114"}'::json, '{"saveValue":false, "filterSign":"=", "onContextMenu":"Delete element"}'::json, '{ "functionName": "delete_object", "parameters": {"columnfind": "element_id", "targetwidget": "tab_elements_tbl_elements", "sourceview": "element"}}'::json, 'tbl_element_x_link', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_elements', 'new_element', 'lyt_element_1', 4, NULL, 'button', NULL, 'New element', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"143"}'::json, '{"saveValue":false, "filterSign":"="}'::json, '{
  "functionName": "manage_element_menu",
  "parameters": {
    "sourcetable": "v_ui_element_x_arc",
    "targetwidget": "tab_elements_tbl_elements",
    "field_object_id": "element_id",
    "sourceview": "element"
  }
}'::json, 'v_edit_link', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_elements', 'hspacer_lyt_element', 'lyt_element_1', 5, NULL, 'hspacer', NULL, NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_elements', 'open_element', 'lyt_element_1', 6, NULL, 'button', NULL, 'Open element', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"144"}'::json, '{"saveValue":false, "filterSign":"=", "onContextMenu":"Open element"}'::json, '{
  "functionName": "open_selected_manager_item",
  "parameters": {
    "columnfind": "element_id",
    "targetwidget": "tab_elements_tbl_elements"
  }
}'::json, 'v_edit_link', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_elements', 'btn_link', 'lyt_element_1', 7, NULL, 'button', NULL, 'Open link', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"173"}'::json, '{"saveValue":false, "filterSign":"=", "onContextMenu":"Open link"}'::json, '{
  "functionName": "open_selected_path",
  "parameters": {
    "targetwidget": "tab_elements_tbl_elements",
    "columnfind": "link_id"
  }
}'::json, 'v_edit_link', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_elements', 'tbl_elements', 'lyt_element_3', 1, NULL, 'tableview', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"saveValue": false}'::json, '{
  "functionName": "open_selected_manager_item",
  "parameters": {
    "columnfind": "element_id"
  }
}'::json, 'tbl_element_x_link', false, 1);


UPDATE inp_typevalue SET idval='TRIMMED NETWORK' WHERE typevalue='inp_options_networkmode' AND id='3';UPDATE inp_typevalue SET idval='TRIMMED NETWORK' WHERE typevalue='inp_options_networkmode' AND id='3';

UPDATE config_param_system SET value='UPDATE v_table set the_geom = geom FROM
        (SELECT v_field, st_multi(st_buffer(st_collect(geom),0.01)) as geom FROM
        (SELECT v_field, st_buffer(st_collect(the_geom), v_geomparamupdate) as geom 
        FROM v_edit_arc arc
        where arc.state > 0 AND  v_field NOT IN (''0'', ''-1'') AND arc.v_field IN
        (SELECT DISTINCT arc.v_field FROM arc JOIN anl_arc ON anl_arc.arc_id = arc.arc_id::text WHERE fid = v_fid and cur_user = current_user)
        group by v_field
        UNION
        SELECT v_field, st_collect(ext_plot.the_geom) as geom FROM v_edit_connec, ext_plot
        WHERE v_edit_connec.state > 0 AND v_field NOT IN (''0'', ''-1'')
        AND v_edit_connec.v_field IN
        (SELECT DISTINCT arc.v_field FROM arc JOIN anl_arc ON anl_arc.arc_id
         = arc.arc_id::text WHERE fid = v_fid and cur_user = current_user)
        AND st_dwithin(v_edit_connec.the_geom, ext_plot.the_geom, 0.001)
        group by v_field
        )a group by v_field)b 
        WHERE b.v_field::text=v_table.v_fieldmp::text' WHERE "parameter"='utils_graphanalytics_custom_geometry_constructor';


UPDATE sys_function SET project_type = 'utils' WHERE id = 3410;
UPDATE sys_function SET project_type = 'utils' WHERE id = 3412;

INSERT INTO sys_style (layername, styleconfig_id, styletype, stylevalue, active) VALUES('ve_frelem', 101, 'qml', '
<!DOCTYPE qgis PUBLIC ''http://mrcc.com/qgis.dtd'' ''SYSTEM''>
<qgis version="3.40.6-Bratislava" styleCategories="Symbology">
  <renderer-v2 symbollevels="0" forceraster="0" enableorderby="0" referencescale="-1" type="RuleRenderer">
    <rules key="{c31d79d3-80f8-49d6-9341-a3da16a21108}">
      <rule filter=" &quot;symbol_x&quot; is not null and  &quot;epa_type&quot; =  ''FRPUMP'' " symbol="0" key="{c0c8c41a-6811-4c3a-bc61-c6326ab318f0}" scalemaxdenom="5000" label="Flow regulator PUMP"/>
      <rule filter=" &quot;symbol_x&quot; is not null and  &quot;epa_type&quot; = ''FRVALVE'' " symbol="1" key="{796dea96-7bfe-402c-ad07-7ab32bc4c8ae}" scalemaxdenom="5000" label="Flow regulator VALVE"/>
    </rules>
    <symbols>
      <symbol clip_to_extent="1" frame_rate="10" type="marker" name="0" force_rhr="0" alpha="1" is_animated="0">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" type="QString" name="name"/>
            <Option name="properties"/>
            <Option value="collection" type="QString" name="type"/>
          </Option>
        </data_defined_properties>
        <layer pass="0" id="{9ab147dd-db16-4b06-8474-ef3b5863138b}" locked="0" class="GeometryGenerator" enabled="1">
          <Option type="Map">
            <Option value="Line" type="QString" name="SymbolType"/>
            <Option value="make_line(@geometry, make_point( &quot;symbol_x&quot; , &quot;symbol_y&quot;))" type="QString" name="geometryModifier"/>
            <Option value="MapUnit" type="QString" name="units"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" type="QString" name="name"/>
              <Option name="properties"/>
              <Option value="collection" type="QString" name="type"/>
            </Option>
          </data_defined_properties>
          <symbol clip_to_extent="1" frame_rate="10" type="line" name="@0@0" force_rhr="0" alpha="1" is_animated="0">
            <data_defined_properties>
              <Option type="Map">
                <Option value="" type="QString" name="name"/>
                <Option name="properties"/>
                <Option value="collection" type="QString" name="type"/>
              </Option>
            </data_defined_properties>
            <layer pass="0" id="{a1749224-75e1-4d26-b573-67b14e1f1e1c}" locked="0" class="SimpleLine" enabled="1">
              <Option type="Map">
                <Option value="0" type="QString" name="align_dash_pattern"/>
                <Option value="square" type="QString" name="capstyle"/>
                <Option value="5;2" type="QString" name="customdash"/>
                <Option value="3x:0,0,0,0,0,0" type="QString" name="customdash_map_unit_scale"/>
                <Option value="MM" type="QString" name="customdash_unit"/>
                <Option value="0" type="QString" name="dash_pattern_offset"/>
                <Option value="3x:0,0,0,0,0,0" type="QString" name="dash_pattern_offset_map_unit_scale"/>
                <Option value="MM" type="QString" name="dash_pattern_offset_unit"/>
                <Option value="0" type="QString" name="draw_inside_polygon"/>
                <Option value="bevel" type="QString" name="joinstyle"/>
                <Option value="50,87,128,128,rgb:0.19607843137254902,0.3411764705882353,0.50196078431372548,0.50196078431372548" type="QString" name="line_color"/>
                <Option value="solid" type="QString" name="line_style"/>
                <Option value="1.6" type="QString" name="line_width"/>
                <Option value="MM" type="QString" name="line_width_unit"/>
                <Option value="0" type="QString" name="offset"/>
                <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
                <Option value="MM" type="QString" name="offset_unit"/>
                <Option value="0" type="QString" name="ring_filter"/>
                <Option value="0" type="QString" name="trim_distance_end"/>
                <Option value="3x:0,0,0,0,0,0" type="QString" name="trim_distance_end_map_unit_scale"/>
                <Option value="MM" type="QString" name="trim_distance_end_unit"/>
                <Option value="0" type="QString" name="trim_distance_start"/>
                <Option value="3x:0,0,0,0,0,0" type="QString" name="trim_distance_start_map_unit_scale"/>
                <Option value="MM" type="QString" name="trim_distance_start_unit"/>
                <Option value="0" type="QString" name="tweak_dash_pattern_on_corners"/>
                <Option value="0" type="QString" name="use_custom_dash"/>
                <Option value="3x:0,0,0,0,0,0" type="QString" name="width_map_unit_scale"/>
              </Option>
              <data_defined_properties>
                <Option type="Map">
                  <Option value="" type="QString" name="name"/>
                  <Option name="properties"/>
                  <Option value="collection" type="QString" name="type"/>
                </Option>
              </data_defined_properties>
            </layer>
            <layer pass="0" id="{c8b0c536-1226-48b6-b049-34d938d1bc83}" locked="0" class="SimpleLine" enabled="1">
              <Option type="Map">
                <Option value="0" type="QString" name="align_dash_pattern"/>
                <Option value="square" type="QString" name="capstyle"/>
                <Option value="5;2" type="QString" name="customdash"/>
                <Option value="3x:0,0,0,0,0,0" type="QString" name="customdash_map_unit_scale"/>
                <Option value="MM" type="QString" name="customdash_unit"/>
                <Option value="0" type="QString" name="dash_pattern_offset"/>
                <Option value="3x:0,0,0,0,0,0" type="QString" name="dash_pattern_offset_map_unit_scale"/>
                <Option value="MM" type="QString" name="dash_pattern_offset_unit"/>
                <Option value="0" type="QString" name="draw_inside_polygon"/>
                <Option value="bevel" type="QString" name="joinstyle"/>
                <Option value="227,223,80,160,hsv:0.16230555555555556,0.64837109941252768,0.89021133745326919,0.62632181277180132" type="QString" name="line_color"/>
                <Option value="solid" type="QString" name="line_style"/>
                <Option value="1" type="QString" name="line_width"/>
                <Option value="MM" type="QString" name="line_width_unit"/>
                <Option value="0" type="QString" name="offset"/>
                <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
                <Option value="MM" type="QString" name="offset_unit"/>
                <Option value="0" type="QString" name="ring_filter"/>
                <Option value="0" type="QString" name="trim_distance_end"/>
                <Option value="3x:0,0,0,0,0,0" type="QString" name="trim_distance_end_map_unit_scale"/>
                <Option value="MM" type="QString" name="trim_distance_end_unit"/>
                <Option value="0" type="QString" name="trim_distance_start"/>
                <Option value="3x:0,0,0,0,0,0" type="QString" name="trim_distance_start_map_unit_scale"/>
                <Option value="MM" type="QString" name="trim_distance_start_unit"/>
                <Option value="0" type="QString" name="tweak_dash_pattern_on_corners"/>
                <Option value="0" type="QString" name="use_custom_dash"/>
                <Option value="3x:0,0,0,0,0,0" type="QString" name="width_map_unit_scale"/>
              </Option>
              <data_defined_properties>
                <Option type="Map">
                  <Option value="" type="QString" name="name"/>
                  <Option name="properties"/>
                  <Option value="collection" type="QString" name="type"/>
                </Option>
              </data_defined_properties>
            </layer>
          </symbol>
        </layer>
        <layer pass="0" id="{ec288e2d-ee31-4c4d-8d29-c0902d8b367a}" locked="0" class="GeometryGenerator" enabled="1">
          <Option type="Map">
            <Option value="Marker" type="QString" name="SymbolType"/>
            <Option value="line_interpolate_point(make_line(@geometry, make_point( &quot;symbol_x&quot; , &quot;symbol_y&quot;)), length(make_line(@geometry, make_point( &quot;symbol_x&quot; , &quot;symbol_y&quot;)))/2)" type="QString" name="geometryModifier"/>
            <Option value="MapUnit" type="QString" name="units"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" type="QString" name="name"/>
              <Option name="properties"/>
              <Option value="collection" type="QString" name="type"/>
            </Option>
          </data_defined_properties>
          <symbol clip_to_extent="1" frame_rate="10" type="marker" name="@0@1" force_rhr="0" alpha="1" is_animated="0">
            <data_defined_properties>
              <Option type="Map">
                <Option value="" type="QString" name="name"/>
                <Option name="properties"/>
                <Option value="collection" type="QString" name="type"/>
              </Option>
            </data_defined_properties>
            <layer pass="0" id="{cf3a94a6-0a45-41f2-b3d6-464dac2e4ebc}" locked="0" class="SimpleMarker" enabled="1">
              <Option type="Map">
                <Option value="0" type="QString" name="angle"/>
                <Option value="square" type="QString" name="cap_style"/>
                <Option value="227,223,80,255,hsv:0.16230555555555556,0.64837109941252768,0.89021133745326919,1" type="QString" name="color"/>
                <Option value="1" type="QString" name="horizontal_anchor_point"/>
                <Option value="bevel" type="QString" name="joinstyle"/>
                <Option value="circle" type="QString" name="name"/>
                <Option value="0,0" type="QString" name="offset"/>
                <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
                <Option value="MM" type="QString" name="offset_unit"/>
                <Option value="50,87,128,255,rgb:0.19607843137254902,0.3411764705882353,0.50196078431372548,1" type="QString" name="outline_color"/>
                <Option value="solid" type="QString" name="outline_style"/>
                <Option value="0" type="QString" name="outline_width"/>
                <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
                <Option value="MM" type="QString" name="outline_width_unit"/>
                <Option value="diameter" type="QString" name="scale_method"/>
                <Option value="3.8" type="QString" name="size"/>
                <Option value="3x:0,0,0,0,0,0" type="QString" name="size_map_unit_scale"/>
                <Option value="MM" type="QString" name="size_unit"/>
                <Option value="1" type="QString" name="vertical_anchor_point"/>
              </Option>
              <data_defined_properties>
                <Option type="Map">
                  <Option value="" type="QString" name="name"/>
                  <Option name="properties"/>
                  <Option value="collection" type="QString" name="type"/>
                </Option>
              </data_defined_properties>
            </layer>
            <layer pass="0" id="{f86d98df-7635-4b83-b348-3a32d14e95a0}" locked="0" class="FontMarker" enabled="1">
              <Option type="Map">
                <Option value="0" type="QString" name="angle"/>
                <Option value="P" type="QString" name="chr"/>
                <Option value="0,0,0,255,rgb:0,0,0,1" type="QString" name="color"/>
                <Option value="Arial" type="QString" name="font"/>
                <Option value="Normal" type="QString" name="font_style"/>
                <Option value="1" type="QString" name="horizontal_anchor_point"/>
                <Option value="bevel" type="QString" name="joinstyle"/>
                <Option value="0,-0.20000000000000001" type="QString" name="offset"/>
                <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
                <Option value="MM" type="QString" name="offset_unit"/>
                <Option value="35,35,35,255,rgb:0.13725490196078433,0.13725490196078433,0.13725490196078433,1" type="QString" name="outline_color"/>
                <Option value="0" type="QString" name="outline_width"/>
                <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
                <Option value="MM" type="QString" name="outline_width_unit"/>
                <Option value="2.3" type="QString" name="size"/>
                <Option value="3x:0,0,0,0,0,0" type="QString" name="size_map_unit_scale"/>
                <Option value="MM" type="QString" name="size_unit"/>
                <Option value="1" type="QString" name="vertical_anchor_point"/>
              </Option>
              <data_defined_properties>
                <Option type="Map">
                  <Option value="" type="QString" name="name"/>
                  <Option name="properties"/>
                  <Option value="collection" type="QString" name="type"/>
                </Option>
              </data_defined_properties>
            </layer>
          </symbol>
        </layer>
      </symbol>
      <symbol clip_to_extent="1" frame_rate="10" type="marker" name="1" force_rhr="0" alpha="1" is_animated="0">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" type="QString" name="name"/>
            <Option name="properties"/>
            <Option value="collection" type="QString" name="type"/>
          </Option>
        </data_defined_properties>
        <layer pass="0" id="{9ab147dd-db16-4b06-8474-ef3b5863138b}" locked="0" class="GeometryGenerator" enabled="1">
          <Option type="Map">
            <Option value="Line" type="QString" name="SymbolType"/>
            <Option value="make_line(@geometry, make_point( &quot;symbol_x&quot; , &quot;symbol_y&quot;))" type="QString" name="geometryModifier"/>
            <Option value="MapUnit" type="QString" name="units"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" type="QString" name="name"/>
              <Option name="properties"/>
              <Option value="collection" type="QString" name="type"/>
            </Option>
          </data_defined_properties>
          <symbol clip_to_extent="1" frame_rate="10" type="line" name="@1@0" force_rhr="0" alpha="1" is_animated="0">
            <data_defined_properties>
              <Option type="Map">
                <Option value="" type="QString" name="name"/>
                <Option name="properties"/>
                <Option value="collection" type="QString" name="type"/>
              </Option>
            </data_defined_properties>
            <layer pass="0" id="{a1749224-75e1-4d26-b573-67b14e1f1e1c}" locked="0" class="SimpleLine" enabled="1">
              <Option type="Map">
                <Option value="0" type="QString" name="align_dash_pattern"/>
                <Option value="square" type="QString" name="capstyle"/>
                <Option value="5;2" type="QString" name="customdash"/>
                <Option value="3x:0,0,0,0,0,0" type="QString" name="customdash_map_unit_scale"/>
                <Option value="MM" type="QString" name="customdash_unit"/>
                <Option value="0" type="QString" name="dash_pattern_offset"/>
                <Option value="3x:0,0,0,0,0,0" type="QString" name="dash_pattern_offset_map_unit_scale"/>
                <Option value="MM" type="QString" name="dash_pattern_offset_unit"/>
                <Option value="0" type="QString" name="draw_inside_polygon"/>
                <Option value="bevel" type="QString" name="joinstyle"/>
                <Option value="50,87,128,128,rgb:0.19607843137254902,0.3411764705882353,0.50196078431372548,0.50196078431372548" type="QString" name="line_color"/>
                <Option value="solid" type="QString" name="line_style"/>
                <Option value="1.6" type="QString" name="line_width"/>
                <Option value="MM" type="QString" name="line_width_unit"/>
                <Option value="0" type="QString" name="offset"/>
                <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
                <Option value="MM" type="QString" name="offset_unit"/>
                <Option value="0" type="QString" name="ring_filter"/>
                <Option value="0" type="QString" name="trim_distance_end"/>
                <Option value="3x:0,0,0,0,0,0" type="QString" name="trim_distance_end_map_unit_scale"/>
                <Option value="MM" type="QString" name="trim_distance_end_unit"/>
                <Option value="0" type="QString" name="trim_distance_start"/>
                <Option value="3x:0,0,0,0,0,0" type="QString" name="trim_distance_start_map_unit_scale"/>
                <Option value="MM" type="QString" name="trim_distance_start_unit"/>
                <Option value="0" type="QString" name="tweak_dash_pattern_on_corners"/>
                <Option value="0" type="QString" name="use_custom_dash"/>
                <Option value="3x:0,0,0,0,0,0" type="QString" name="width_map_unit_scale"/>
              </Option>
              <data_defined_properties>
                <Option type="Map">
                  <Option value="" type="QString" name="name"/>
                  <Option name="properties"/>
                  <Option value="collection" type="QString" name="type"/>
                </Option>
              </data_defined_properties>
            </layer>
            <layer pass="0" id="{c8b0c536-1226-48b6-b049-34d938d1bc83}" locked="0" class="SimpleLine" enabled="1">
              <Option type="Map">
                <Option value="0" type="QString" name="align_dash_pattern"/>
                <Option value="square" type="QString" name="capstyle"/>
                <Option value="5;2" type="QString" name="customdash"/>
                <Option value="3x:0,0,0,0,0,0" type="QString" name="customdash_map_unit_scale"/>
                <Option value="MM" type="QString" name="customdash_unit"/>
                <Option value="0" type="QString" name="dash_pattern_offset"/>
                <Option value="3x:0,0,0,0,0,0" type="QString" name="dash_pattern_offset_map_unit_scale"/>
                <Option value="MM" type="QString" name="dash_pattern_offset_unit"/>
                <Option value="0" type="QString" name="draw_inside_polygon"/>
                <Option value="bevel" type="QString" name="joinstyle"/>
                <Option value="192,206,213,166,hsv:0.55738888888888893,0.09973296711680782,0.83633173113603421,0.65262836652170597" type="QString" name="line_color"/>
                <Option value="solid" type="QString" name="line_style"/>
                <Option value="1" type="QString" name="line_width"/>
                <Option value="MM" type="QString" name="line_width_unit"/>
                <Option value="0" type="QString" name="offset"/>
                <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
                <Option value="MM" type="QString" name="offset_unit"/>
                <Option value="0" type="QString" name="ring_filter"/>
                <Option value="0" type="QString" name="trim_distance_end"/>
                <Option value="3x:0,0,0,0,0,0" type="QString" name="trim_distance_end_map_unit_scale"/>
                <Option value="MM" type="QString" name="trim_distance_end_unit"/>
                <Option value="0" type="QString" name="trim_distance_start"/>
                <Option value="3x:0,0,0,0,0,0" type="QString" name="trim_distance_start_map_unit_scale"/>
                <Option value="MM" type="QString" name="trim_distance_start_unit"/>
                <Option value="0" type="QString" name="tweak_dash_pattern_on_corners"/>
                <Option value="0" type="QString" name="use_custom_dash"/>
                <Option value="3x:0,0,0,0,0,0" type="QString" name="width_map_unit_scale"/>
              </Option>
              <data_defined_properties>
                <Option type="Map">
                  <Option value="" type="QString" name="name"/>
                  <Option name="properties"/>
                  <Option value="collection" type="QString" name="type"/>
                </Option>
              </data_defined_properties>
            </layer>
          </symbol>
        </layer>
        <layer pass="0" id="{ec288e2d-ee31-4c4d-8d29-c0902d8b367a}" locked="0" class="GeometryGenerator" enabled="1">
          <Option type="Map">
            <Option value="Marker" type="QString" name="SymbolType"/>
            <Option value="line_interpolate_point(make_line(@geometry, make_point( &quot;symbol_x&quot; , &quot;symbol_y&quot;)), length(make_line(@geometry, make_point( &quot;symbol_x&quot; , &quot;symbol_y&quot;)))/2)" type="QString" name="geometryModifier"/>
            <Option value="MapUnit" type="QString" name="units"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" type="QString" name="name"/>
              <Option name="properties"/>
              <Option value="collection" type="QString" name="type"/>
            </Option>
          </data_defined_properties>
          <symbol clip_to_extent="1" frame_rate="10" type="marker" name="@1@1" force_rhr="0" alpha="1" is_animated="0">
            <data_defined_properties>
              <Option type="Map">
                <Option value="" type="QString" name="name"/>
                <Option name="properties"/>
                <Option value="collection" type="QString" name="type"/>
              </Option>
            </data_defined_properties>
            <layer pass="0" id="{cf3a94a6-0a45-41f2-b3d6-464dac2e4ebc}" locked="0" class="SimpleMarker" enabled="1">
              <Option type="Map">
                <Option value="0" type="QString" name="angle"/>
                <Option value="square" type="QString" name="cap_style"/>
                <Option value="234,237,205,255,rgb:0.91764705882352937,0.92941176470588238,0.80392156862745101,1" type="QString" name="color"/>
                <Option value="1" type="QString" name="horizontal_anchor_point"/>
                <Option value="bevel" type="QString" name="joinstyle"/>
                <Option value="circle" type="QString" name="name"/>
                <Option value="0,0" type="QString" name="offset"/>
                <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
                <Option value="MM" type="QString" name="offset_unit"/>
                <Option value="50,87,128,255,rgb:0.19607843137254902,0.3411764705882353,0.50196078431372548,1" type="QString" name="outline_color"/>
                <Option value="solid" type="QString" name="outline_style"/>
                <Option value="0" type="QString" name="outline_width"/>
                <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
                <Option value="MM" type="QString" name="outline_width_unit"/>
                <Option value="diameter" type="QString" name="scale_method"/>
                <Option value="3.8" type="QString" name="size"/>
                <Option value="3x:0,0,0,0,0,0" type="QString" name="size_map_unit_scale"/>
                <Option value="MM" type="QString" name="size_unit"/>
                <Option value="1" type="QString" name="vertical_anchor_point"/>
              </Option>
              <data_defined_properties>
                <Option type="Map">
                  <Option value="" type="QString" name="name"/>
                  <Option name="properties"/>
                  <Option value="collection" type="QString" name="type"/>
                </Option>
              </data_defined_properties>
            </layer>
            <layer pass="0" id="{f86d98df-7635-4b83-b348-3a32d14e95a0}" locked="0" class="FontMarker" enabled="1">
              <Option type="Map">
                <Option value="0" type="QString" name="angle"/>
                <Option value="V" type="QString" name="chr"/>
                <Option value="0,0,0,255,rgb:0,0,0,1" type="QString" name="color"/>
                <Option value="Arial" type="QString" name="font"/>
                <Option value="Normal" type="QString" name="font_style"/>
                <Option value="1" type="QString" name="horizontal_anchor_point"/>
                <Option value="bevel" type="QString" name="joinstyle"/>
                <Option value="0,-0.20000000000000001" type="QString" name="offset"/>
                <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
                <Option value="MM" type="QString" name="offset_unit"/>
                <Option value="35,35,35,255,rgb:0.13725490196078433,0.13725490196078433,0.13725490196078433,1" type="QString" name="outline_color"/>
                <Option value="0" type="QString" name="outline_width"/>
                <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
                <Option value="MM" type="QString" name="outline_width_unit"/>
                <Option value="2.3" type="QString" name="size"/>
                <Option value="3x:0,0,0,0,0,0" type="QString" name="size_map_unit_scale"/>
                <Option value="MM" type="QString" name="size_unit"/>
                <Option value="1" type="QString" name="vertical_anchor_point"/>
              </Option>
              <data_defined_properties>
                <Option type="Map">
                  <Option value="" type="QString" name="name"/>
                  <Option name="properties"/>
                  <Option value="collection" type="QString" name="type"/>
                </Option>
              </data_defined_properties>
            </layer>
          </symbol>
        </layer>
      </symbol>
    </symbols>
    <data-defined-properties>
      <Option type="Map">
        <Option value="" type="QString" name="name"/>
        <Option name="properties"/>
        <Option value="collection" type="QString" name="type"/>
      </Option>
    </data-defined-properties>
  </renderer-v2>
  <selection mode="Default">
    <selectionColor invalid="1"/>
    <selectionSymbol>
      <symbol clip_to_extent="1" frame_rate="10" type="marker" name="" force_rhr="0" alpha="1" is_animated="0">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" type="QString" name="name"/>
            <Option name="properties"/>
            <Option value="collection" type="QString" name="type"/>
          </Option>
        </data_defined_properties>
        <layer pass="0" id="{afeff23a-ae7e-4624-a496-267df3fbf1d3}" locked="0" class="SimpleMarker" enabled="1">
          <Option type="Map">
            <Option value="0" type="QString" name="angle"/>
            <Option value="square" type="QString" name="cap_style"/>
            <Option value="255,0,0,255,rgb:1,0,0,1" type="QString" name="color"/>
            <Option value="1" type="QString" name="horizontal_anchor_point"/>
            <Option value="bevel" type="QString" name="joinstyle"/>
            <Option value="circle" type="QString" name="name"/>
            <Option value="0,0" type="QString" name="offset"/>
            <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
            <Option value="MM" type="QString" name="offset_unit"/>
            <Option value="35,35,35,255,rgb:0.13725490196078433,0.13725490196078433,0.13725490196078433,1" type="QString" name="outline_color"/>
            <Option value="solid" type="QString" name="outline_style"/>
            <Option value="0" type="QString" name="outline_width"/>
            <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
            <Option value="MM" type="QString" name="outline_width_unit"/>
            <Option value="diameter" type="QString" name="scale_method"/>
            <Option value="2" type="QString" name="size"/>
            <Option value="3x:0,0,0,0,0,0" type="QString" name="size_map_unit_scale"/>
            <Option value="MM" type="QString" name="size_unit"/>
            <Option value="1" type="QString" name="vertical_anchor_point"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" type="QString" name="name"/>
              <Option name="properties"/>
              <Option value="collection" type="QString" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </selectionSymbol>
  </selection>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerGeometryType>0</layerGeometryType>
</qgis>', true);

ALTER TABLE sys_feature_class ADD CONSTRAINT sys_feature_cat_check CHECK (id::text = ANY (
    ARRAY['EXPANSIONTANK'::text, 'FILTER'::text, 'FLEXUNION'::text, 'FOUNTAIN'::text, 'GREENTAP'::text, 'HYDRANT'::text, 'JUNCTION'::text, 'MANHOLE'::text, 'METER'::text,
    'NETELEMENT'::text, 'NETSAMPLEPOINT'::text, 'NETWJOIN'::text, 'PIPE'::text, 'PUMP'::text, 'REDUCTION'::text, 'REGISTER'::text, 'SOURCE'::text, 'TANK'::text, 'TAP'::text, 'VALVE'::text,
    'VARC'::text, 'WATERWELL'::text, 'WJOIN'::text, 'WTP'::text, 'PIPELINK'::text, 'VLINK'::text, 'VCONNEC'::text, 'ELEMENT'::text, 'GENELEM'::text, 'FRELEM'::text]));

ALTER TABLE om_waterbalance DROP CONSTRAINT om_waterbalance_pkey;
ALTER TABLE om_waterbalance ADD CONSTRAINT om_waterbalance_pkey PRIMARY KEY (dma_id, startdate, enddate);

ALTER TABLE config_form_fields
ADD CONSTRAINT chk_widgets_requires_dv_querytext
CHECK (
  (widgettype NOT IN ('combo', 'typeahead')) OR dv_querytext IS NOT NULL
);

ALTER TABLE cat_feature_element DROP CONSTRAINT IF EXISTS cat_feature_element_inp_check;
ALTER TABLE cat_feature_element ADD CONSTRAINT cat_feature_element_inp_check CHECK (((epa_default)::text = ANY (ARRAY['FRPUMP'::text,'FRVALVE'::text, 'FRSHORTPIPE'::text,'UNDEFINED'::text])));

CREATE TRIGGER gw_trg_edit_arc INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_arc
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_arc('parent');

CREATE TRIGGER gw_trg_edit_node INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_node
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_node('parent');

CREATE TRIGGER gw_trg_edit_connec INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_connec
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_connec('parent');

CREATE TRIGGER gw_trg_edit_link INSTEAD OF INSERT OR UPDATE OR DELETE ON v_edit_link
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_link('parent');

CREATE TRIGGER gw_trg_edit_element_pol INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_pol_element
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_element_pol();

CREATE TRIGGER gw_trg_ui_element INSTEAD OF INSERT OR DELETE OR UPDATE ON v_ui_element_x_node
FOR EACH ROW EXECUTE FUNCTION gw_trg_ui_element('node');

CREATE TRIGGER gw_trg_ui_element INSTEAD OF INSERT OR DELETE OR UPDATE ON v_ui_element_x_connec
FOR EACH ROW EXECUTE FUNCTION gw_trg_ui_element('connec');

CREATE TRIGGER gw_trg_ui_element INSTEAD OF INSERT OR DELETE OR UPDATE ON v_ui_element_x_arc
FOR EACH ROW EXECUTE FUNCTION gw_trg_ui_element('arc');

CREATE TRIGGER gw_trg_ui_element INSTEAD OF INSERT OR DELETE OR UPDATE ON v_ui_element_x_link
FOR EACH ROW EXECUTE FUNCTION gw_trg_ui_element('link');

CREATE TRIGGER gw_trg_edit_pol_connec INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_pol_connec
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_man_connec_pol();

CREATE TRIGGER gw_trg_edit_pol_node INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_pol_node
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_man_node_pol();

CREATE TRIGGER gw_trg_edit_inp_node_junction INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_junction
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_node('inp_junction');

CREATE TRIGGER gw_trg_edit_inp_dscenario_junction INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_dscenario_junction
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('JUNCTION');

CREATE TRIGGER gw_trg_edit_inp_node_pump INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_pump
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_node('inp_pump');

CREATE TRIGGER gw_trg_edit_inp_arc_pipe INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_pipe
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_arc('inp_pipe');

CREATE TRIGGER gw_trg_edit_inp_arc_pump INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_virtualpump
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_arc('inp_virtualpump');

CREATE TRIGGER gw_trg_edit_inp_arc_virtualvalve INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_virtualvalve
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_arc('inp_virtualvalve');

CREATE TRIGGER gw_trg_edit_inp_dscenario_pipe INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_dscenario_pipe
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('PIPE');

CREATE TRIGGER gw_trg_edit_inp_dscenario_virtualvalve INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_dscenario_virtualvalve
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('VIRTUALVALVE');

CREATE TRIGGER gw_trg_edit_inp_dscenario_virtualpump INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_dscenario_virtualpump
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('VIRTUALPUMP');

CREATE TRIGGER gw_trg_edit_man_register_pol INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_pol_register
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_man_node_pol('man_register_pol');

CREATE TRIGGER gw_trg_edit_man_fountain_pol INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_pol_fountain
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_man_connec_pol('man_fountain_pol');

CREATE TRIGGER gw_trg_edit_man_tank_pol INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_pol_tank
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_man_node_pol('man_tank_pol');

CREATE TRIGGER gw_trg_edit_inp_dscenario_pump INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_dscenario_pump
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('PUMP');

CREATE TRIGGER gw_trg_edit_inp_node_pump INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_pump_additional
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_node('inp_pump_additional');

CREATE TRIGGER gw_trg_edit_inp_dscenario_pump_additional INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_dscenario_pump_additional
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('PUMP_ADDITIONAL');

CREATE TRIGGER gw_trg_edit_inp_dscenario_shortpipe INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_dscenario_shortpipe
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('SHORTPIPE');

CREATE TRIGGER gw_trg_edit_inp_node_shortpipe INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_shortpipe
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_node('inp_shortpipe');

CREATE TRIGGER gw_trg_edit_inp_dscenario_connec INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_dscenario_connec
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('CONNEC');

CREATE TRIGGER gw_trg_edit_inp_connec INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_connec
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_connec();

CREATE TRIGGER gw_trg_edit_inp_dscenario_tank INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_dscenario_tank
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('TANK');

CREATE TRIGGER gw_trg_edit_inp_node_tank INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_tank
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_node('inp_tank');

CREATE TRIGGER gw_trg_edit_inp_dscenario_reservoir INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_dscenario_reservoir
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('RESERVOIR');

CREATE TRIGGER gw_trg_edit_inp_node_reservoir INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_reservoir
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_node('inp_reservoir');

CREATE TRIGGER gw_trg_edit_inp_dscenario_valve INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_dscenario_valve
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('VALVE');

CREATE TRIGGER gw_trg_edit_inp_dscenario_demand INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_dscenario_demand
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario_demand();

CREATE TRIGGER gw_trg_edit_inp_node_valve INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_valve
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_node('inp_valve');

CREATE TRIGGER gw_trg_edit_inp_dscenario_inlet INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_dscenario_inlet
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('INLET');

CREATE TRIGGER gw_trg_edit_inp_node_inlet INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_inlet
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_node('inp_inlet');

CREATE TRIGGER gw_trg_edit_controls BEFORE DELETE OR UPDATE
ON presszone FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_controls('presszone_id');

CREATE TRIGGER gw_trg_edit_controls BEFORE DELETE OR UPDATE
ON dqa FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_controls('dqa_id');

CREATE TRIGGER gw_trg_edit_controls BEFORE DELETE OR UPDATE
ON supplyzone FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_controls('supplyzone_id');

CREATE TRIGGER gw_trg_edit_plan_netscenario INSTEAD OF INSERT OR DELETE OR UPDATE ON
v_edit_plan_netscenario_presszone FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_plan_netscenario('PRESSZONE');

CREATE TRIGGER gw_trg_edit_minsector INSTEAD OF INSERT OR DELETE OR UPDATE ON
v_edit_minsector FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_minsector();

CREATE TRIGGER gw_trg_edit_samplepoint INSTEAD OF INSERT OR DELETE OR UPDATE ON
v_edit_samplepoint FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_samplepoint('samplepoint');

CREATE TRIGGER gw_trg_typevalue_fk AFTER INSERT OR UPDATE ON
dqa FOR EACH ROW EXECUTE FUNCTION gw_trg_typevalue_fk('dqa');

CREATE TRIGGER gw_trg_typevalue_fk AFTER INSERT OR UPDATE ON
sector FOR EACH ROW EXECUTE FUNCTION gw_trg_typevalue_fk('sector');


CREATE TRIGGER gw_trg_dscenario_demand_feature AFTER INSERT ON inp_dscenario_demand
FOR EACH ROW EXECUTE FUNCTION gw_trg_dscenario_demand_feature();

CREATE TRIGGER gw_trg_typevalue_fk AFTER INSERT OR UPDATE ON inp_dscenario_demand
FOR EACH ROW EXECUTE FUNCTION gw_trg_typevalue_fk('inp_dscenario_demand');


CREATE TRIGGER gw_trg_edit_anl_hydrant INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_anl_hydrant
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_anl_hydrant();

CREATE TRIGGER gw_trg_edit_ve_epa_junction INSTEAD OF INSERT OR DELETE OR UPDATE ON
ve_epa_junction FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_ve_epa('junction');

CREATE TRIGGER gw_trg_edit_ve_epa_tank INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_epa_tank
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_ve_epa('tank');

CREATE TRIGGER gw_trg_edit_ve_epa_reservoir INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_epa_reservoir
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_ve_epa('reservoir');

CREATE TRIGGER gw_trg_edit_ve_epa_connec INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_epa_connec
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_ve_epa('connec');

CREATE TRIGGER gw_trg_edit_ve_epa_inlet INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_epa_inlet
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_ve_epa('inlet');


CREATE TRIGGER gw_trg_edit_ve_epa_pump INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_epa_pump
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_ve_epa('pump');

CREATE TRIGGER gw_trg_edit_ve_epa_pump_additional INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_epa_pump_additional
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_ve_epa('pump_additional');

CREATE TRIGGER gw_trg_edit_ve_epa_valve INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_epa_valve
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_ve_epa('valve');

CREATE TRIGGER gw_trg_edit_ve_epa_shortpipe INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_epa_shortpipe
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_ve_epa('shortpipe');

CREATE TRIGGER gw_trg_edit_ve_epa_pipe INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_epa_pipe
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_ve_epa('pipe');

CREATE TRIGGER gw_trg_edit_ve_epa_virtualvalve INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_epa_virtualvalve
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_ve_epa('virtualvalve');

CREATE TRIGGER gw_trg_edit_ve_epa_virtualpump INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_epa_virtualpump
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_ve_epa('virtualpump');

-- EDIT
CREATE TRIGGER gw_trg_v_edit_macrodqa INSTEAD OF INSERT OR DELETE OR UPDATE
ON v_edit_macrodqa FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_macrodqa('EDIT');

CREATE TRIGGER gw_trg_v_edit_macrodma INSTEAD OF INSERT OR DELETE OR UPDATE
ON v_edit_macrodma FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_macrodma('EDIT');

CREATE TRIGGER gw_trg_v_edit_macrosector INSTEAD OF INSERT OR DELETE OR UPDATE
ON v_edit_macrosector FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_macrosector('EDIT');

CREATE TRIGGER gw_trg_v_edit_macroomzone INSTEAD OF INSERT OR DELETE OR UPDATE
ON v_edit_macroomzone FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_macroomzone('EDIT');

CREATE TRIGGER gw_trg_v_edit_dqa INSTEAD OF INSERT OR DELETE OR UPDATE
ON v_edit_dqa FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_dqa('EDIT');

CREATE TRIGGER gw_trg_v_edit_dma INSTEAD OF INSERT OR DELETE OR UPDATE
ON v_edit_dma FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_dma('EDIT');

CREATE TRIGGER gw_trg_v_edit_sector INSTEAD OF INSERT OR DELETE OR UPDATE
ON v_edit_sector FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_sector('EDIT');

CREATE TRIGGER gw_trg_v_edit_omzone INSTEAD OF INSERT OR DELETE OR UPDATE
ON v_edit_omzone FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_omzone('EDIT');

CREATE TRIGGER gw_trg_v_edit_presszone INSTEAD OF INSERT OR DELETE OR UPDATE
ON v_edit_presszone FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_presszone('EDIT');

CREATE TRIGGER gw_trg_v_edit_supplyzone INSTEAD OF INSERT OR DELETE OR UPDATE
ON v_edit_supplyzone FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_supplyzone('EDIT');

-- UI
CREATE TRIGGER gw_trg_v_ui_macrodqa INSTEAD OF INSERT OR DELETE OR UPDATE
ON v_ui_macrodqa FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_macrodqa('UI');

CREATE TRIGGER gw_trg_v_ui_macrodma INSTEAD OF INSERT OR DELETE OR UPDATE
ON v_ui_macrodma FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_macrodma('UI');

CREATE TRIGGER gw_trg_v_ui_macrosector INSTEAD OF INSERT OR DELETE OR UPDATE
ON v_ui_macrosector FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_macrosector('UI');

CREATE TRIGGER gw_trg_v_ui_macroomzone INSTEAD OF INSERT OR DELETE OR UPDATE
ON v_ui_macroomzone FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_macroomzone('UI');

CREATE TRIGGER gw_trg_v_ui_dqa INSTEAD OF INSERT OR DELETE OR UPDATE
ON v_ui_dqa FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_dqa('UI');

CREATE TRIGGER gw_trg_v_ui_dma INSTEAD OF INSERT OR DELETE OR UPDATE
ON v_ui_dma FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_dma('UI');

CREATE TRIGGER gw_trg_v_ui_sector INSTEAD OF INSERT OR DELETE OR UPDATE
ON v_ui_sector FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_sector('UI');

CREATE TRIGGER gw_trg_v_ui_presszone INSTEAD OF INSERT OR DELETE OR UPDATE
ON v_ui_presszone FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_presszone('UI');

CREATE TRIGGER gw_trg_v_ui_omzone INSTEAD OF INSERT OR DELETE OR UPDATE
ON v_ui_omzone FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_omzone('UI');

CREATE TRIGGER gw_trg_v_ui_supplyzone INSTEAD OF INSERT OR DELETE OR UPDATE
ON v_ui_supplyzone FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_supplyzone('UI');

-- delete duplicated triggers
DROP TRIGGER IF EXISTS gw_trg_edit_macrosector ON v_edit_macrosector;
DROP TRIGGER IF EXISTS gw_trg_edit_macrodma ON v_edit_macrodma;

CREATE TRIGGER gw_trg_typevalue_fk_insert AFTER INSERT
ON supplyzone FOR EACH ROW EXECUTE FUNCTION gw_trg_typevalue_fk('supplyzone');

CREATE TRIGGER gw_trg_typevalue_fk_update AFTER UPDATE OF supplyzone_type
ON supplyzone FOR EACH ROW WHEN (((old.supplyzone_type)::TEXT IS DISTINCT
FROM (new.supplyzone_type)::TEXT)) EXECUTE FUNCTION gw_trg_typevalue_fk('supplyzone');


CREATE TRIGGER gw_trg_mantypevalue_fk_insert AFTER INSERT ON node
FOR EACH ROW EXECUTE FUNCTION gw_trg_mantypevalue_fk('node');

CREATE TRIGGER gw_trg_mantypevalue_fk_update AFTER UPDATE OF function_type, category_type, location_type ON node
FOR EACH ROW
WHEN ((((old.function_type)::TEXT IS DISTINCT FROM (new.function_type)::TEXT)
OR ((old.category_type)::TEXT IS DISTINCT FROM (new.category_type)::TEXT)
OR ((old.location_type)::TEXT IS DISTINCT FROM (new.location_type)::TEXT)))
EXECUTE FUNCTION gw_trg_mantypevalue_fk('node');

CREATE TRIGGER gw_trg_node_arc_divide AFTER INSERT ON node
FOR EACH ROW EXECUTE FUNCTION gw_trg_node_arc_divide();

CREATE TRIGGER gw_trg_node_rotation_update AFTER INSERT OR UPDATE OF hemisphere, the_geom ON node
FOR EACH ROW EXECUTE FUNCTION gw_trg_node_rotation_update();

CREATE TRIGGER gw_trg_node_statecontrol BEFORE INSERT OR UPDATE OF state ON node
FOR EACH ROW EXECUTE FUNCTION gw_trg_node_statecontrol();

CREATE TRIGGER gw_trg_topocontrol_node AFTER INSERT OR UPDATE OF the_geom, custom_top_elev, state ON node
FOR EACH ROW EXECUTE FUNCTION gw_trg_topocontrol_node();

CREATE TRIGGER gw_trg_typevalue_fk_insert AFTER INSERT ON node
FOR EACH ROW EXECUTE FUNCTION gw_trg_typevalue_fk('node');

CREATE TRIGGER gw_trg_typevalue_fk_update AFTER UPDATE OF verified ON node
FOR EACH ROW WHEN (((old.verified)::TEXT IS DISTINCT
FROM (new.verified)::TEXT)) EXECUTE FUNCTION gw_trg_typevalue_fk('node');



CREATE TRIGGER gw_trg_ui_doc_x_arc INSTEAD OF INSERT OR DELETE OR UPDATE ON v_ui_doc_x_arc
FOR EACH ROW EXECUTE FUNCTION gw_trg_ui_doc('arc');

CREATE TRIGGER gw_trg_ui_doc_x_connec INSTEAD OF INSERT OR DELETE OR UPDATE ON v_ui_doc_x_connec
FOR EACH ROW EXECUTE FUNCTION gw_trg_ui_doc('connec');

CREATE TRIGGER gw_trg_ui_doc_x_node INSTEAD OF INSERT OR DELETE OR UPDATE ON v_ui_doc_x_node
FOR EACH ROW EXECUTE FUNCTION gw_trg_ui_doc('node');

CREATE TRIGGER gw_trg_ui_doc_x_visit INSTEAD OF INSERT OR DELETE OR UPDATE ON v_ui_doc_x_visit
FOR EACH ROW EXECUTE FUNCTION gw_trg_ui_doc('visit');

DROP TRIGGER IF EXISTS gw_trg_link_data ON connec;
CREATE TRIGGER gw_trg_link_data
AFTER UPDATE OF epa_type, state_type, expl_visibility, conneccat_id, fluid_type, n_hydrometer
ON connec FOR EACH ROW EXECUTE PROCEDURE gw_trg_link_data('connec');

CREATE TRIGGER gw_trg_edit_inp_pattern INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_pattern
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_pattern('inp_pattern');

CREATE TRIGGER gw_trg_edit_inp_pattern_value INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_pattern_value
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_pattern('inp_pattern_value');



CREATE TRIGGER gw_trg_arc_link_update AFTER
UPDATE OF the_geom ON arc FOR EACH ROW EXECUTE FUNCTION gw_trg_arc_link_update();
CREATE TRIGGER gw_trg_arc_node_values AFTER
INSERT OR UPDATE OF node_1, node_2, the_geom ON arc FOR EACH ROW EXECUTE FUNCTION gw_trg_arc_node_values();
CREATE TRIGGER gw_trg_arc_noderotation_update AFTER
INSERT OR DELETE OR UPDATE OF the_geom ON arc FOR EACH ROW EXECUTE FUNCTION gw_trg_arc_noderotation_update();
CREATE TRIGGER gw_trg_topocontrol_arc BEFORE
INSERT OR UPDATE OF the_geom, state ON arc FOR EACH ROW EXECUTE FUNCTION gw_trg_topocontrol_arc();
CREATE TRIGGER gw_trg_edit_controls AFTER
DELETE OR UPDATE ON arc FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_controls('arc_id');
CREATE TRIGGER gw_trg_mantypevalue_fk_insert AFTER
INSERT ON arc FOR EACH ROW EXECUTE FUNCTION gw_trg_mantypevalue_fk('arc');
CREATE TRIGGER gw_trg_mantypevalue_fk_update AFTER UPDATE OF function_type, category_type, location_type ON arc
FOR EACH ROW
WHEN ((((old.function_type)::TEXT IS DISTINCT FROM (new.function_type)::TEXT)
OR ((old.category_type)::TEXT IS DISTINCT FROM (new.category_type)::TEXT)
OR ((old.location_type)::TEXT IS DISTINCT FROM (new.location_type)::TEXT)))
EXECUTE FUNCTION gw_trg_mantypevalue_fk('arc');

CREATE TRIGGER gw_trg_typevalue_fk_insert AFTER
INSERT ON arc FOR EACH ROW EXECUTE FUNCTION gw_trg_typevalue_fk('arc');
CREATE TRIGGER gw_trg_typevalue_fk_update AFTER
UPDATE OF verified, datasource, lock_level ON arc FOR EACH ROW
    WHEN (((old.verified IS DISTINCT
FROM
    new.verified)
    OR (old.datasource IS DISTINCT
FROM
    new.datasource)
    OR (old.lock_level IS DISTINCT
FROM
    new.lock_level))) EXECUTE FUNCTION gw_trg_typevalue_fk('arc');



CREATE TRIGGER gw_trg_connec_proximity_insert BEFORE INSERT ON connec
FOR EACH ROW EXECUTE FUNCTION gw_trg_connec_proximity();
CREATE TRIGGER gw_trg_connec_proximity_update AFTER UPDATE OF the_geom ON connec
FOR EACH ROW EXECUTE FUNCTION gw_trg_connec_proximity();
CREATE TRIGGER gw_trg_connect_update AFTER UPDATE OF arc_id, pjoint_id, pjoint_type, the_geom ON connec
FOR EACH ROW EXECUTE FUNCTION gw_trg_connect_update('connec');
CREATE TRIGGER gw_trg_unique_field AFTER INSERT OR UPDATE OF customer_code, state ON connec
FOR EACH ROW EXECUTE FUNCTION gw_trg_unique_field('connec');
CREATE TRIGGER gw_trg_edit_controls AFTER DELETE OR UPDATE ON connec
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_controls('connec_id');
CREATE TRIGGER gw_trg_mantypevalue_fk_insert AFTER INSERT ON connec
FOR EACH ROW EXECUTE FUNCTION gw_trg_mantypevalue_fk('connec');

CREATE TRIGGER gw_trg_mantypevalue_fk_update AFTER UPDATE OF function_type, category_type, location_type ON connec
FOR EACH ROW
WHEN ((((old.function_type)::TEXT IS DISTINCT FROM (new.function_type)::TEXT)
OR ((old.category_type)::TEXT IS DISTINCT FROM (new.category_type)::TEXT)
OR ((old.location_type)::TEXT IS DISTINCT FROM (new.location_type)::TEXT)))
EXECUTE FUNCTION gw_trg_mantypevalue_fk('connec');

CREATE TRIGGER gw_trg_typevalue_fk_insert AFTER INSERT ON connec
FOR EACH ROW EXECUTE FUNCTION gw_trg_typevalue_fk('connec');
CREATE TRIGGER gw_trg_typevalue_fk_update AFTER UPDATE OF verified, datasource, lock_level ON connec
FOR EACH ROW
    WHEN (((old.verified IS DISTINCT
FROM
    new.verified)
    OR (old.datasource IS DISTINCT
FROM
    new.datasource)
    OR (old.lock_level IS DISTINCT
FROM
    new.lock_level))) EXECUTE FUNCTION gw_trg_typevalue_fk('connec');


CREATE TRIGGER gw_trg_edit_controls AFTER DELETE OR UPDATE ON element
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_controls('element_id');

CREATE TRIGGER gw_trg_typevalue_fk_insert AFTER INSERT ON element
FOR EACH ROW EXECUTE FUNCTION gw_trg_typevalue_fk('element');

CREATE TRIGGER gw_trg_typevalue_fk_update AFTER UPDATE OF datasource, lock_level ON element
FOR EACH ROW
    WHEN (((old.datasource IS DISTINCT
FROM
    new.datasource)
    OR (old.lock_level IS DISTINCT
FROM
    new.lock_level))) EXECUTE FUNCTION gw_trg_typevalue_fk('element');

CREATE TRIGGER gw_trg_mantypevalue_fk_insert AFTER INSERT ON element
FOR EACH ROW EXECUTE FUNCTION gw_trg_mantypevalue_fk('element');

CREATE TRIGGER gw_trg_mantypevalue_fk_update AFTER UPDATE OF function_type, category_type, location_type ON element
FOR EACH ROW
WHEN ((((old.function_type)::TEXT IS DISTINCT FROM (new.function_type)::TEXT)
OR ((old.category_type)::TEXT IS DISTINCT FROM (new.category_type)::TEXT)
OR ((old.location_type)::TEXT IS DISTINCT FROM (new.location_type)::TEXT)))
EXECUTE FUNCTION gw_trg_mantypevalue_fk('element');

CREATE TRIGGER gw_trg_link_connecrotation_update AFTER
INSERT
    OR
UPDATE
    OF the_geom ON
    link FOR EACH ROW EXECUTE FUNCTION gw_trg_link_connecrotation_update();
CREATE TRIGGER gw_trg_link_data AFTER
INSERT
    OR
UPDATE
    OF the_geom ON
    link FOR EACH ROW EXECUTE FUNCTION gw_trg_link_data('link');


CREATE TRIGGER gw_trg_edit_controls BEFORE DELETE OR UPDATE ON macrosector
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_controls('macrosector_id');

CREATE TRIGGER gw_trg_edit_controls BEFORE DELETE OR UPDATE ON macrodma
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_controls('macrodma_id');

CREATE TRIGGER gw_trg_edit_controls BEFORE DELETE OR UPDATE ON macrodqa
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_controls('macrodqa_id');

CREATE TRIGGER gw_trg_edit_exploitation INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_exploitation
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_exploitation();

CREATE TRIGGER gw_trg_edit_controls BEFORE DELETE OR UPDATE ON exploitation
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_controls('expl_id');

CREATE TRIGGER gw_trg_edit_controls BEFORE DELETE OR UPDATE ON macroexploitation
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_controls('macroexpl_id');

CREATE TRIGGER gw_trg_typevalue_fk_insert AFTER INSERT
ON omzone FOR EACH ROW EXECUTE FUNCTION gw_trg_typevalue_fk('omzone');

CREATE TRIGGER gw_trg_typevalue_fk_update AFTER UPDATE OF omzone_type
ON omzone FOR EACH ROW WHEN (((old.omzone_type)::TEXT IS DISTINCT
FROM (new.omzone_type)::TEXT)) EXECUTE FUNCTION gw_trg_typevalue_fk('omzone');


CREATE TRIGGER gw_trg_edit_cat_feature INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_cat_feature_node
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_cat_feature('node');

CREATE TRIGGER gw_trg_edit_cat_feature INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_cat_feature_connec
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_cat_feature('connec');

CREATE TRIGGER gw_trg_edit_plan_netscenario INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_plan_netscenario_valve
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_plan_netscenario('VALVE');

CREATE TRIGGER gw_trg_plan_psector_x_node BEFORE INSERT OR UPDATE OF node_id, state ON plan_psector_x_node
FOR EACH ROW EXECUTE FUNCTION gw_trg_plan_psector_x_node();

CREATE TRIGGER gw_trg_plan_psector_x_arc BEFORE INSERT OR UPDATE OF arc_id, state ON plan_psector_x_arc
FOR EACH ROW EXECUTE FUNCTION gw_trg_plan_psector_x_arc();

CREATE TRIGGER gw_trg_plan_psector_link AFTER INSERT OR UPDATE OF arc_id ON plan_psector_x_connec
FOR EACH ROW EXECUTE FUNCTION gw_trg_plan_psector_link('connec');

CREATE TRIGGER gw_trg_plan_psector_x_connec BEFORE INSERT OR UPDATE OF connec_id, state ON plan_psector_x_connec
FOR EACH ROW EXECUTE FUNCTION gw_trg_plan_psector_x_connec();

CREATE TRIGGER gw_trg_edit_plan_psector_connec INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_plan_psector_x_connec
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_plan_psector_x_connect('plan_psector_x_connec');

CREATE TRIGGER gw_trg_om_visit_singlevent INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_visit_node_singlevent
FOR EACH ROW EXECUTE FUNCTION gw_trg_om_visit_singlevent('node');

CREATE TRIGGER gw_trg_om_visit_singlevent INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_visit_arc_singlevent
FOR EACH ROW EXECUTE FUNCTION gw_trg_om_visit_singlevent('arc');

CREATE TRIGGER gw_trg_om_visit_singlevent INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_visit_connec_singlevent
FOR EACH ROW EXECUTE FUNCTION gw_trg_om_visit_singlevent('connec');


CREATE TRIGGER gw_trg_edit_review_audit_node INSTEAD OF DELETE OR UPDATE ON v_edit_review_audit_node
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_review_audit_node();

CREATE TRIGGER gw_trg_edit_review_audit_arc INSTEAD OF DELETE OR UPDATE ON v_edit_review_audit_arc
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_review_audit_arc();

CREATE TRIGGER gw_trg_edit_review_audit_connec INSTEAD OF DELETE OR UPDATE ON v_edit_review_audit_connec
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_review_audit_connec();

CREATE TRIGGER gw_trg_edit_review_node INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_review_node
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_review_node();

CREATE TRIGGER gw_trg_edit_review_arc INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_review_arc
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_review_arc();

CREATE TRIGGER gw_trg_edit_review_connec INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_review_connec
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_review_connec();



CREATE TRIGGER gw_trg_fk_array_id_table BEFORE DELETE ON arc
FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_id_table('arc_id', '{"man_source":"inlet_arc", "man_tank":"inlet_arc", "man_wtp":"inlet_arc", "man_waterwell":"inlet_arc", "man_valve":"to_arc", "man_pump":"to_arc", "man_meter":"to_arc"}');

CREATE TRIGGER gw_trg_fk_array_id_table_update AFTER UPDATE ON arc
FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_id_table('arc_id', '{"man_source":"inlet_arc", "man_tank":"inlet_arc", "man_wtp":"inlet_arc", "man_waterwell":"inlet_arc", "man_valve":"to_arc", "man_pump":"to_arc", "man_meter":"to_arc"}');

CREATE TRIGGER gw_trg_fk_array_array_table AFTER INSERT OR UPDATE ON man_source
FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('inlet_arc', 'arc', 'arc_id');

CREATE TRIGGER gw_trg_fk_array_array_table AFTER INSERT OR UPDATE ON man_tank
FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('inlet_arc', 'arc', 'arc_id');

CREATE TRIGGER gw_trg_fk_array_array_table AFTER INSERT OR UPDATE ON man_wtp
FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('inlet_arc', 'arc', 'arc_id');

CREATE TRIGGER gw_trg_fk_array_array_table AFTER INSERT OR UPDATE ON man_valve
FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('to_arc', 'arc', 'arc_id');

CREATE TRIGGER gw_trg_fk_array_array_table AFTER INSERT OR UPDATE ON man_pump
FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('to_arc', 'arc', 'arc_id');

CREATE TRIGGER gw_trg_fk_array_array_table AFTER INSERT OR UPDATE ON man_meter
FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('to_arc', 'arc', 'arc_id');

CREATE TRIGGER gw_trg_fk_array_array_table AFTER INSERT OR UPDATE ON man_waterwell
FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('inlet_arc', 'arc', 'arc_id');

CREATE TRIGGER gw_trg_edit_plot INSTEAD OF INSERT OR DELETE OR UPDATE ON v_ext_plot
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_plot();
