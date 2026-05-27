/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;


ALTER TABLE inp_froutlet RENAME TO _inp_froutlet;
ALTER TABLE inp_frorifice RENAME TO _inp_frorifice;
ALTER TABLE inp_frweir RENAME TO _inp_frweir;
ALTER TABLE inp_frpump RENAME TO _inp_frpump;

ALTER TABLE inp_dscenario_frpump RENAME TO _inp_dscenario_frpump;
ALTER TABLE inp_dscenario_froutlet RENAME TO _inp_dscenario_froutlet;
ALTER TABLE inp_dscenario_frorifice RENAME TO _inp_dscenario_frorifice;
ALTER TABLE inp_dscenario_frweir RENAME TO _inp_dscenario_frweir;

CREATE TABLE inp_froutlet (
    element_id int4 NOT NULL,
    outlet_type character varying(16) NOT NULL,
    offsetval numeric(12,4),
    curve_id character varying(16),
    cd1 numeric(12,4),
    cd2 numeric(12,4),
    flap character varying(3),
    CONSTRAINT inp_froutlet_pk PRIMARY KEY (element_id),
    CONSTRAINT inp_froutlet_chk_outlet_type CHECK (((outlet_type)::text = ANY ((ARRAY['FUNCTIONAL/DEPTH'::character varying, 'FUNCTIONAL/HEAD'::character varying, 'TABULAR/DEPTH'::character varying, 'TABULAR/HEAD'::character varying])::text[])))
);

CREATE TABLE inp_frorifice(
    element_id int4 NOT NULL,
    orifice_type varchar(18) NOT NULL,
    offsetval numeric(12, 4) NULL,
    cd numeric(12, 4) NOT NULL,
    orate numeric(12, 4) NULL,
    flap varchar(3) NOT NULL,
    shape varchar(18) NOT NULL,
    geom1 numeric(12, 4) NOT NULL,
    geom2 numeric(12, 4) DEFAULT 0.00 NOT NULL,
    geom3 numeric(12, 4) DEFAULT 0.00 NULL,
    geom4 numeric(12, 4) DEFAULT 0.00 NULL,
    CONSTRAINT inp_frorifice_pk PRIMARY KEY (element_id),
    CONSTRAINT inp_frorifice_fk_element_id FOREIGN KEY (element_id) REFERENCES element(element_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT inp_frorifice_chk_orifice_type CHECK (((orifice_type)::text = ANY (ARRAY[('SIDE'::character varying)::text, ('BOTTOM'::character varying)::text]))),
    CONSTRAINT inp_frorifice_chk_shape CHECK (((shape)::text = ANY (ARRAY[('CIRCULAR'::character varying)::text, ('RECT_CLOSED'::character varying)::text])))
);

CREATE TABLE inp_frweir(
    element_id int4 NOT NULL,
    weir_type varchar(18) NOT NULL,
    offsetval numeric(12, 4) NULL,
    cd numeric(12, 4) NULL,
    ec numeric(12, 4) NULL,
    cd2 numeric(12, 4) NULL,
    flap varchar(3) NULL,
    geom1 numeric(12, 4) NULL,
    geom2 numeric(12, 4) DEFAULT 0.00 NULL,
    geom3 numeric(12, 4) DEFAULT 0.00 NULL,
    geom4 numeric(12, 4) DEFAULT 0.00 NULL,
    surcharge varchar(3) NULL,
    road_width float8 NULL,
    road_surf varchar(16) NULL,
    coef_curve float8 NULL,
    CONSTRAINT inp_frweir_pk PRIMARY KEY (element_id),
    CONSTRAINT inp_frweir_fk_element_id_fkey FOREIGN KEY (element_id) REFERENCES element(element_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT inp_frweir_chk_weir_type CHECK (((weir_type)::text = ANY (ARRAY['ROADWAY'::text, 'SIDEFLOW'::text, 'TRANSVERSE'::text, 'V-NOTCH'::text, 'TRAPEZOIDAL_WEIR'::text])))
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

CREATE TABLE inp_dscenario_froutlet (
    dscenario_id int4 NOT NULL,
    element_id int4 NOT NULL,
    outlet_type character varying(16) NOT NULL,
    offsetval numeric(12,4),
    curve_id character varying(16),
    cd1 numeric(12,4),
    cd2 numeric(12,4),
    flap character varying(3),
    CONSTRAINT inp_dscenario_froutlet_pk PRIMARY KEY (element_id, dscenario_id),
    CONSTRAINT inp_dscenario_froutlet_fk_dscenario_id FOREIGN KEY (dscenario_id) REFERENCES cat_dscenario(dscenario_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT inp_dscenario_froutlet_chk_outlet_type CHECK (((outlet_type)::text = ANY ((ARRAY['FUNCTIONAL/DEPTH'::character varying, 'FUNCTIONAL/HEAD'::character varying, 'TABULAR/DEPTH'::character varying, 'TABULAR/HEAD'::character varying])::text[])))
);

CREATE TABLE inp_dscenario_frorifice (
    dscenario_id int4 NOT NULL,
    element_id int4 NOT NULL,
    orifice_type varchar(18) NOT NULL,
    offsetval numeric(12, 4) NULL,
    cd numeric(12, 4) NOT NULL,
    orate numeric(12, 4) NULL,
    flap varchar(3) NOT NULL,
    shape varchar(18) NOT NULL,
    geom1 numeric(12, 4) NOT NULL,
    geom2 numeric(12, 4) DEFAULT 0.00 NOT NULL,
    geom3 numeric(12, 4) DEFAULT 0.00 NULL,
    geom4 numeric(12, 4) DEFAULT 0.00 NULL,
    CONSTRAINT inp_dscenario_frorifice_py PRIMARY KEY (element_id, dscenario_id),
    CONSTRAINT inp_dscenario_frorifice_fy_dscenario_id FOREIGN KEY (dscenario_id) REFERENCES cat_dscenario(dscenario_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT inp_dscenario_frorifice_fy_element_id FOREIGN KEY (element_id) REFERENCES element(element_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT inp_dscenario_frorifice_chk_orifice_type CHECK (((orifice_type)::text = ANY (ARRAY[('SIDE'::character varying)::text, ('BOTTOM'::character varying)::text]))),
    CONSTRAINT inp_dscenario_frorifice_chk_shape CHECK (((shape)::text = ANY (ARRAY[('CIRCULAR'::character varying)::text, ('RECT_CLOSED'::character varying)::text])))
);

CREATE TABLE inp_dscenario_frweir (
    dscenario_id int4 NOT NULL,
    element_id int4 NOT NULL,
    weir_type varchar(18) NOT NULL,
    offsetval numeric(12, 4) NULL,
    cd numeric(12, 4) NULL,
    ec numeric(12, 4) NULL,
    cd2 numeric(12, 4) NULL,
    flap varchar(3) NULL,
    geom1 numeric(12, 4) NULL,
    geom2 numeric(12, 4) DEFAULT 0.00 NULL,
    geom3 numeric(12, 4) DEFAULT 0.00 NULL,
    geom4 numeric(12, 4) DEFAULT 0.00 NULL,
    surcharge varchar(3) NULL,
    road_width float8 NULL,
    road_surf varchar(16) NULL,
    coef_curve float8 NULL,
    CONSTRAINT inp_dscenario_frweir_pk PRIMARY KEY (element_id, dscenario_id),
    CONSTRAINT inp_dscenario_frweir_fk_dscenario_id FOREIGN KEY (dscenario_id) REFERENCES cat_dscenario(dscenario_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT inp_dscenario_frweir_fk_element_id_fkey FOREIGN KEY (element_id) REFERENCES element(element_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT inp_dscenario_frweir_chk_weir_type CHECK (((weir_type)::text = ANY (ARRAY['ROADWAY'::text, 'SIDEFLOW'::text, 'TRANSVERSE'::text, 'V-NOTCH'::text, 'TRAPEZOIDAL_WEIR'::text])))
);

DROP TABLE IF EXISTS ext_rtc_dma_period CASCADE;


SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"archived_psector_gully_traceability", "column":"expl_visibility", "dataType":"int[]"}}$$);
UPDATE archived_psector_gully_traceability SET expl_visibility = ARRAY[expl_id];
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"archived_psector_gully_traceability", "column":"expl_id2"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"anl_node", "column":"dwfzone_id", "dataType":"int4"}}$$);
ALTER TABLE anl_node ADD CONSTRAINT anl_node_dwfzone_id_fkey FOREIGN KEY (dwfzone_id) REFERENCES dwfzone(dwfzone_id);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"anl_arc", "column":"dwfzone_id", "dataType":"int4"}}$$);
ALTER TABLE anl_arc ADD CONSTRAINT anl_arc_dwfzone_id_fkey FOREIGN KEY (dwfzone_id) REFERENCES dwfzone(dwfzone_id);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"anl_connec", "column":"dwfzone_id", "dataType":"int4"}}$$);
ALTER TABLE anl_connec ADD CONSTRAINT anl_connec_dwfzone_id_fkey FOREIGN KEY (dwfzone_id) REFERENCES dwfzone(dwfzone_id);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"anl_gully", "column":"dwfzone_id", "dataType":"int4"}}$$);
ALTER TABLE anl_gully ADD CONSTRAINT anl_gully_dwfzone_id_fkey FOREIGN KEY (dwfzone_id) REFERENCES dwfzone(dwfzone_id);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"anl_connec", "column":"drainzone_id", "dataType":"int4"}}$$);
ALTER TABLE anl_connec ADD CONSTRAINT anl_connec_drainzone_id_fkey FOREIGN KEY (drainzone_id) REFERENCES drainzone(drainzone_id);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"anl_gully", "column":"drainzone_id", "dataType":"int4"}}$$);
ALTER TABLE anl_gully ADD CONSTRAINT anl_gully_drainzone_id_fkey FOREIGN KEY (drainzone_id) REFERENCES drainzone(drainzone_id);

ALTER TABLE anl_node ADD CONSTRAINT anl_node_drainzone_id_fkey FOREIGN KEY (drainzone_id) REFERENCES drainzone(drainzone_id);
ALTER TABLE anl_arc ADD CONSTRAINT anl_arc_drainzone_id_fkey FOREIGN KEY (drainzone_id) REFERENCES drainzone(drainzone_id);

ALTER TABLE inp_subcatchment ALTER COLUMN muni_id SET DEFAULT 0;
ALTER TABLE inp_subcatchment ALTER COLUMN muni_id SET NOT NULL;


DROP TABLE IF EXISTS node_border_sector;



-- inp_subcatchment
ALTER TABLE inp_subcatchment RENAME TO _inp_subcatchment;


-- Drop foreign keys that reference inp_subcatchment
ALTER TABLE inp_groundwater DROP CONSTRAINT inp_groundwater_subc_id_fkey;
ALTER TABLE inp_coverage DROP CONSTRAINT inp_coverage_land_x_subc_subc_id_fkey;
ALTER TABLE inp_loadings DROP CONSTRAINT inp_loadings_pol_x_subc_subc_id_fkey;

-- Drop foreign keys from table inp_subcatchment

ALTER TABLE _inp_subcatchment DROP CONSTRAINT subcatchment_hydrology_id_fkey;
ALTER TABLE _inp_subcatchment DROP CONSTRAINT subcatchment_rg_id_fkey;
ALTER TABLE _inp_subcatchment DROP CONSTRAINT subcatchment_sector_id_fkey;
ALTER TABLE _inp_subcatchment DROP CONSTRAINT subcatchment_snow_id_fkey;

-- Drop restrictions from table inp_subcatchment
ALTER TABLE _inp_subcatchment DROP CONSTRAINT subcatchment_pkey;


-- Drop indexes from table inp_subcatchment
DROP INDEX IF EXISTS subcatchment_pkey;
DROP INDEX IF EXISTS subcathment_index;


-- New order to table inp_subcatchment
CREATE TABLE inp_subcatchment (
	hydrology_id int4 NOT NULL DEFAULT 1,
    subc_id varchar(16) NOT NULL,
    sector_id int4 NULL,
    minelev float8 NULL,
    outlet_id varchar(100) NULL,
    rg_id varchar(16) NULL,
    area numeric(16, 6) NULL,
    imperv numeric(12, 4) NULL DEFAULT 90,
    width numeric(12, 4) NULL,
    slope numeric(12, 4) NULL,
    clength numeric(12, 4) NULL,
    snow_id varchar(16) NULL,
    nimp numeric(12, 4) NULL DEFAULT 0.01,
    nperv numeric(12, 4) NULL DEFAULT 0.1,
    simp numeric(12, 4) NULL DEFAULT 0.05,
    sperv numeric(12, 4) NULL DEFAULT 0.05,
    zero numeric(12, 4) NULL DEFAULT 25,
    routeto varchar(20) NULL,
    rted numeric(12, 4) NULL DEFAULT 100,
    maxrate numeric(12, 4) NULL,
    minrate numeric(12, 4) NULL,
    decay numeric(12, 4) NULL,
    drytime numeric(12, 4) NULL,
    maxinfil numeric(12, 4) NULL,
    suction numeric(12, 4) NULL,
    conduct numeric(12, 4) NULL,
    initdef numeric(12, 4) NULL,
    curveno numeric(12, 4) NULL,
    conduct_2 numeric(12, 4) NULL DEFAULT 0,
    drytime_2 numeric(12, 4) NULL DEFAULT 10,
    nperv_pattern_id varchar(16) NULL,
    dstore_pattern_id varchar(16) NULL,
    infil_pattern_id varchar(16) NULL,
    muni_id int4 NULL,
    descript text NULL,
    the_geom public.geometry(multipolygon, SRID_VALUE) NULL,
	CONSTRAINT subcatchment_pkey PRIMARY KEY (subc_id, hydrology_id),
	CONSTRAINT subcatchment_hydrology_id_fkey FOREIGN KEY (hydrology_id) REFERENCES cat_hydrology(hydrology_id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT subcatchment_rg_id_fkey FOREIGN KEY (rg_id) REFERENCES raingage(rg_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT subcatchment_sector_id_fkey FOREIGN KEY (sector_id) REFERENCES sector(sector_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT subcatchment_snow_id_fkey FOREIGN KEY (snow_id) REFERENCES inp_snowpack(snow_id) ON DELETE RESTRICT ON UPDATE CASCADE
);
CREATE INDEX subcathment_index ON inp_subcatchment USING gist (the_geom);



SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"arc_add", "column":"conduit_capacity", "dataType":"float", "isUtils":"False"}}$$);


CREATE TABLE man_vlink (
	link_id int4 NOT NULL,
	CONSTRAINT man_vlink_pkey PRIMARY KEY (link_id),
	CONSTRAINT man_vlink_link_id_fkey FOREIGN KEY (link_id) REFERENCES link(link_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE man_vgully (
	gully_id int4 NOT NULL,
	CONSTRAINT man_vgully_pkey PRIMARY KEY (gully_id),
	CONSTRAINT man_vgully_gully_id_fkey FOREIGN KEY (gully_id) REFERENCES gully(gully_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE man_vconnec (
	connec_id int4 NOT NULL,
	CONSTRAINT man_vconnec_pkey PRIMARY KEY (connec_id),
	CONSTRAINT man_vconnec_connec_id_fkey FOREIGN KEY (connec_id) REFERENCES connec(connec_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE man_conduitlink (
	link_id int4 NOT NULL,
	CONSTRAINT man_conduitlink_pkey PRIMARY KEY (link_id),
	CONSTRAINT man_conduitlink_link_id_fkey FOREIGN KEY (link_id) REFERENCES link(link_id) ON DELETE CASCADE ON UPDATE CASCADE
);

DROP VIEW IF EXISTS v_edit_cat_feature_flwreg;

DROP VIEW IF EXISTS v_edit_inp_dscenario_frorifice;
DROP VIEW IF EXISTS v_edit_inp_dscenario_froutlet;
DROP VIEW IF EXISTS v_edit_inp_dscenario_frweir;

DROP VIEW IF EXISTS v_edit_inp_frorifice;
DROP VIEW IF EXISTS v_edit_inp_froutlet;
DROP VIEW IF EXISTS v_edit_inp_frweir;


DROP VIEW IF EXISTS v_edit_drainzone;

DROP VIEW IF EXISTS v_edit_macrosector;

DROP VIEW IF EXISTS v_expl_connec;
DROP VIEW IF EXISTS v_rtc_hydrometer;

DROP VIEW IF EXISTS v_ui_hydroval;
DROP VIEW IF EXISTS v_ui_hydrometer;
DROP VIEW IF EXISTS v_ui_hydroval_x_connec;

DROP VIEW IF EXISTS ve_elem_cover;
DROP VIEW IF EXISTS ve_elem_frpump;
DROP VIEW IF EXISTS ve_elem_gate;
DROP VIEW IF EXISTS ve_elem_iot_sensor;
DROP VIEW IF EXISTS ve_elem_protector;
DROP VIEW IF EXISTS ve_elem_pump;
DROP VIEW IF EXISTS ve_elem_step;
DROP VIEW IF EXISTS v_edit_element;
DROP VIEW IF EXISTS v_edit_link_connec;
DROP VIEW IF EXISTS v_edit_link_gully;
DROP VIEW IF EXISTS ve_link_link;

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
            ud_expl_id AS expl_id,
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
            ud_expl_id AS expl_id,
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
   FROM selector_municipality s, ext_streetaxis
   WHERE ext_streetaxis.muni_id = s.muni_id AND s.cur_user = "current_user"()::text;

DO $$
DECLARE
    v_utils boolean;
BEGIN
     SELECT value::boolean INTO v_utils FROM config_param_system WHERE parameter='admin_utils_schema';

     IF v_utils THEN
        CREATE OR REPLACE VIEW ext_raster_dem
        AS SELECT id,
            rast,
            rastercat_id,
            envelope
        FROM utils.raster_dem;

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
        FROM v_ext_municipality a, utils.raster_dem r
        JOIN utils.cat_raster c ON c.id = r.rastercat_id
        WHERE st_dwithin(r.envelope, a.the_geom, 0::double precision);
     ELSE
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
     END IF;
END $$;

CREATE OR REPLACE VIEW v_edit_exploitation
AS SELECT exploitation.expl_id,
    exploitation.code,
    exploitation.name,
    exploitation.macroexpl_id,
    exploitation.sector_id,
    exploitation.muni_id,
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
  WHERE selector_expl.expl_id = ANY(macroomzone.expl_id) AND selector_expl.cur_user = "current_user"()::text;


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
    s.expl_id,
    s.muni_id,
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
    s.expl_id,
    s.muni_id,
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



-- recreate v_edit_samplepoint view
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
            l.state_type,
			l.expl_id,
			macroexpl_id,
			l.muni_id,
			l.sector_id,
			macrosector_id,
			sector_table.sector_type,
			l.drainzone_id,
			drainzone_table.drainzone_type,
			l.drainzone_outfall,
			l.dwfzone_id,
			dwfzone_table.dwfzone_type,
			l.dwfzone_outfall,
			l.omzone_id,
			omzone_table.macroomzone_id,
            l.location_type,
			l.fluid_type,
            l.custom_length,
			st_length2d(l.the_geom)::numeric(12,3) AS gis_length,
            l.sys_slope,
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
            l.private_linkcat_id,
            l.verified,
			l.uncertain,
            l.userdefined_geom,
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
			l.the_geom
			FROM link_selector
			JOIN link l using (link_id)
			JOIN exploitation ON l.expl_id = exploitation.expl_id
			JOIN ext_municipality mu ON l.muni_id = mu.muni_id
			JOIN sector_table ON l.sector_id = sector_table.sector_id
            JOIN cat_link ON cat_link.id::text = l.linkcat_id::text
            JOIN cat_feature ON cat_feature.id::text = l.link_type::text
			LEFT JOIN omzone_table ON l.omzone_id = omzone_table.omzone_id
			LEFT JOIN drainzone_table ON l.omzone_id = drainzone_table.drainzone_id
			LEFT JOIN dwfzone_table ON l.dwfzone_id = dwfzone_table.dwfzone_id
            LEFT JOIN inp_network_mode ON true
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
    d.sector_id,
    d.muni_id,
    d.lock_level,
    d.the_geom,
    d.created_at,
    d.created_by,
    d.updated_at,
    d.updated_by
   FROM selector_expl,
    drainzone d
    LEFT JOIN edit_typevalue et ON et.id::text = d.drainzone_type::text AND et.typevalue::text = 'drainzone_type'::text
  WHERE selector_expl.expl_id = ANY(d.expl_id) AND selector_expl.cur_user = "current_user"()::text;

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
    d.sector_id,
    d.muni_id,
    d.lock_level,
    d.the_geom,
    d.created_at,
    d.created_by,
    d.updated_at,
    d.updated_by
   FROM selector_expl e,
    dwfzone d
    LEFT JOIN edit_typevalue et ON et.id::text = d.dwfzone_type::text AND et.typevalue::text = 'dwfzone_type'::text
  WHERE e.expl_id = ANY(d.expl_id) AND e.cur_user = "current_user"()::text;


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
			arc.epa_type,
			arc.state,
			arc.state_type,
			arc.parent_id,
			arc.expl_id,
			e.macroexpl_id,
			arc.muni_id,
			arc.sector_id,
			sector_table.macrosector_id,
			sector_table.sector_type,
			arc.drainzone_id,
			drainzone_table.drainzone_type,
			arc.drainzone_outfall,
			arc.dwfzone_id,
			dwfzone_table.dwfzone_type,
			arc.dwfzone_outfall,
			arc.omzone_id,
			omzone_table.macroomzone_id,
			omzone_table.omzone_type,
            arc.omunit_id,
			arc.minsector_id,
			arc.pavcat_id,
			arc.soilcat_id,
			arc.function_type,
			arc.category_type,
			arc.location_type,
			arc.fluid_type,
			arc.custom_length,
			st_length(arc.the_geom)::numeric(12,2) AS gis_length,
			arc.sys_slope AS slope,
			arc.descript,
			arc.annotation,
			arc.observ,
			arc.comment,
			concat(cat_feature.link_path, arc.link) AS link,
			arc.num_value,
			arc.district_id,
			arc.postcode,
			streetaxis_id,
			arc.postnumber,
			arc.postcomplement,
			streetaxis2_id,
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
	            WHEN arc.sector_id > 0 AND vst.is_operative = true AND arc.epa_type::text <> 'UNDEFINED'::character varying(16)::text THEN arc.epa_type
	            ELSE NULL::character varying(16)
	        END AS inp_type,
            arc_add.result_id,
            arc_add.max_flow,
            arc_add.max_veloc,
            arc_add.mfull_flow,
            arc_add.mfull_depth,
            arc_add.manning_veloc,
            arc_add.manning_flow,
            arc_add.dwf_minflow,
            arc_add.dwf_maxflow,
            arc_add.dwf_minvel,
            arc_add.dwf_maxvel,
            arc_add.conduit_capacity,
			sector_table.stylesheet ->> 'featureColor'::text AS sector_style,
			drainzone_table.stylesheet ->> 'featureColor'::text AS drainzone_style,
			dwfzone_table.stylesheet ->> 'featureColor'::text AS dwfzone_style,
			omzone_table.stylesheet ->> 'featureColor'::text AS omzone_style,
            arc.lock_level,
            arc.initoverflowpath,
			arc.inverted_slope,
            arc.negative_offset,
			arc.expl_visibility,
            date_trunc('second'::text, arc.created_at) AS created_at,
			arc.created_by,
			date_trunc('second'::text, arc.updated_at) AS updated_at,
			arc.updated_by,
			arc.the_geom,
            -- extra we don't know the order
            arc.meandering
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
            LEFT JOIN arc_add ON arc_add.arc_id = arc.arc_id
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
			node.muni_id,
			node.sector_id,
			sector_table.macrosector_id,
			sector_table.sector_type,
			node.drainzone_id,
			drainzone_table.drainzone_type,
			node.drainzone_outfall,
			node.dwfzone_id,
			dwfzone_table.dwfzone_type,
			node.dwfzone_outfall,
			node.omzone_id,
			omzone_table.macroomzone_id,
            node.omunit_id,
            node.omstate,
			node.minsector_id,
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
			streetaxis_id,
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
			node.conserv_state,
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
            node.datasource,
			node.unconnected,
			cat_node.label,
			node.label_x,
			node.label_y,
			node.label_rotation,
			node.rotation,
			node.label_quadrant,
            node.hemisphere,
			cat_node.svg,
			node.inventory,
			node.publish,
			vst.is_operative,
            node.is_scadamap,
			CASE
			  WHEN node.sector_id > 0 AND vst.is_operative = true AND node.epa_type::text <> 'UNDEFINED'::character varying(16)::text THEN node.epa_type
			  ELSE NULL::character varying(16)
			END AS inp_type,
            node_add.result_id,
            node_add.max_depth,
            node_add.max_height,
            node_add.flooding_rate,
            node_add.flooding_vol,
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
			node.the_geom
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
            LEFT JOIN node_add ON node_add.node_id = node.node_id
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
			matcat_id,
			nodecat_id,
			epa_type,
			state,
			state_type,
			arc_id,
			parent_id,
			expl_id,
			macroexpl_id,
			muni_id,
			sector_id,
			macrosector_id,
			sector_type,
			drainzone_id,
			drainzone_type,
            drainzone_outfall,
			dwfzone_id,
			dwfzone_type,
			dwfzone_outfall,
			omzone_id,
			macroomzone_id,
            omunit_id,
            omstate,
			minsector_id,
            pavcat_id,
			soilcat_id,
			function_type,
			category_type,
			location_type,
			fluid_type,
			annotation,
			observ,
			comment,
			descript,
			link,
			num_value,
			district_id,
			postcode,
			streetaxis_id,
			postnumber,
			postcomplement,
			streetaxis2_id,
			postnumber2,
			postcomplement2,
			region_id,
			province_id,
			workcat_id,
			workcat_id_end,
			workcat_id_plan,
			builtdate,
			enddate,
			ownercat_id,
			conserv_state,
			access_type,
			placement_type,
			brand_id,
			model_id,
			serial_number,
			asset_id,
			adate,
			adescript,
			verified,
			xyz_date,
			uncertain,
            datasource,
			unconnected,
			label,
			label_x,
			label_y,
			label_rotation,
			rotation,
			label_quadrant,
            hemisphere,
			svg,
			inventory,
			publish,
			is_operative,
            is_scadamap,
			inp_type,
            result_id,
            max_depth,
            max_height,
            flooding_rate,
            flooding_vol,
			sector_style,
			omzone_style,
			drainzone_style,
			dwfzone_style,
            lock_level,
			expl_visibility,
            xcoord,
            ycoord,
            lat,
            long,
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
            SELECT connec.connec_id, arc_id, null::integer as link_id
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
            SELECT connec_id, connec_psector.arc_id, link_id FROM connec_psector
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
			connec.muni_id,
			CASE
				WHEN link_planned.sector_id IS NULL THEN connec.sector_id
				ELSE link_planned.sector_id
			END AS sector_id,
			CASE
				WHEN link_planned.macrosector_id IS NULL THEN sector_table.macrosector_id
				ELSE link_planned.macrosector_id
			END AS macrosector_id,
			sector_table.sector_type,
			CASE
				WHEN link_planned.drainzone_id IS NULL THEN connec.drainzone_id
				ELSE link_planned.drainzone_id
			END AS drainzone_id,
			CASE
				WHEN link_planned.drainzone_type IS NULL THEN drainzone_table.drainzone_type
				ELSE link_planned.drainzone_type
			END AS drainzone_type,
            connec.drainzone_outfall,
            CASE
				WHEN link_planned.dwfzone_id IS NULL THEN connec.dwfzone_id
				ELSE link_planned.dwfzone_id
			END AS dwfzone_id,
			CASE
				WHEN link_planned.dwfzone_type IS NULL THEN dwfzone_table.dwfzone_type
				ELSE link_planned.dwfzone_type
			END AS dwfzone_type,
            connec.dwfzone_outfall,
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
            connec.omunit_id,
			connec.minsector_id,
			connec.soilcat_id,
			connec.function_type,
			connec.category_type,
			connec.location_type,
			connec.fluid_type,
            connec.n_hydrometer,
            connec.n_inhabitants,
			connec.demand,
			connec.descript,
			connec.annotation,
			connec.observ,
			connec.comment,
			connec.link::text,
			connec.num_value,
			connec.district_id,
			connec.postcode,
			connec.streetaxis_id,
			connec.postnumber,
			connec.postcomplement,
			connec.streetaxis2_id,
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
				WHEN link_planned.exit_id IS NULL THEN connec.pjoint_id
				ELSE link_planned.exit_id
			END AS pjoint_id,
			CASE
				WHEN link_planned.exit_type IS NULL THEN connec.pjoint_type
				ELSE link_planned.exit_type
			END AS pjoint_type,
			connec.access_type,
			connec.placement_type,
			connec.accessibility,
            connec.brand_id,
            connec.model_id,
			connec.asset_id,
			connec.adate,
			connec.adescript,
			connec.verified,
			connec.uncertain,
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
			connec.diagonal
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
            SELECT gully.gully_id, arc_id, null::integer as link_id
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
            SELECT gully_id, gully_psector.arc_id, link_id FROM gully_psector
            WHERE p_state = 1
        ),
    gully_selected AS
    	(
			SELECT gully.gully_id,
			gully.code,
            gully.sys_code,
			gully.top_elev,
            CASE
                WHEN gully.width IS NULL THEN cat_gully.width
                ELSE gully.width
            END AS width,
            CASE
                WHEN gully.length IS NULL THEN cat_gully.length
                ELSE gully.length
            END AS length,
			CASE
                WHEN gully.ymax IS NULL THEN cat_gully.ymax
                ELSE gully.ymax
            END AS ymax,
			gully.sandbox,
			gully.matcat_id,
			gully.gully_type,
			cat_feature.feature_class AS sys_type,
			gully.gullycat_id,
			cat_gully.matcat_id AS cat_gully_matcat,
			gully.units,
			gully.units_placement,
			gully.groove,
			gully.groove_height,
			gully.groove_length,
			gully.siphon,
			gully.siphon_type,
			gully.odorflap,
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
			gully.arc_id,
			gully.epa_type,
			gully.state,
			gully.state_type,
			gully.expl_id,
			exploitation.macroexpl_id,
			gully.muni_id,
			CASE
				WHEN link_planned.sector_id IS NULL THEN sector_table.sector_id
				ELSE link_planned.sector_id
			END AS sector_id,
			CASE
				WHEN link_planned.macrosector_id IS NULL THEN sector_table.macrosector_id
				ELSE link_planned.macrosector_id
			END AS macrosector_id,
			CASE
				WHEN link_planned.sector_id IS NULL THEN sector_table.sector_type
				ELSE link_planned.sector_type
			END AS sector_type,
			CASE
				WHEN link_planned.drainzone_id IS NULL THEN drainzone_table.drainzone_id
				ELSE link_planned.drainzone_id
			END AS drainzone_id,
			CASE
				WHEN link_planned.drainzone_type IS NULL THEN drainzone_table.drainzone_type
				ELSE link_planned.drainzone_type
			END AS drainzone_type,
            gully.drainzone_outfall,
			CASE
				WHEN link_planned.dwfzone_id IS NULL THEN dwfzone_table.dwfzone_id
				ELSE link_planned.dwfzone_id
			END AS dwfzone_id,
			CASE
				WHEN link_planned.dwfzone_type IS NULL THEN dwfzone_table.dwfzone_type
				ELSE link_planned.dwfzone_type
			END AS dwfzone_type,
			gully.dwfzone_outfall,
			CASE
				WHEN link_planned.omzone_id IS NULL THEN omzone_table.omzone_id
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
            gully.omunit_id,
			gully.minsector_id,
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
			streetaxis_id,
			gully.postnumber,
			gully.postcomplement,
			streetaxis2_id,
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
            CASE
				WHEN link_planned.exit_id IS NULL THEN gully.pjoint_id
				ELSE link_planned.exit_id
			END AS pjoint_id,
			CASE
				WHEN link_planned.exit_type IS NULL THEN gully.pjoint_type
				ELSE link_planned.exit_type
			END AS pjoint_type,
			gully.placement_type,
			gully.access_type,
			gully.brand_id,
			gully.model_id,
			gully.asset_id,
			gully.adate,
			gully.adescript,
			gully.verified,
			gully.uncertain,
            gully.datasource,
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
			gully.the_geom
			FROM gully_selector
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
			LEFT JOIN inp_network_mode ON true
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
                             LEFT JOIN v_plan_aux_arc_pavement ON v_plan_aux_arc_pavement.arc_id = v_edit_arc.arc_id
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
             JOIN arc ON v_plan_aux_arc_cost.arc_id = arc.arc_id
             LEFT JOIN ( SELECT DISTINCT ON (c.arc_id) c.arc_id,
                    (min(p.price) * count(*)::numeric)::numeric(12,2) AS connec_total_cost
                   FROM v_edit_connec c
                     JOIN arc arc_1 USING (arc_id)
                     JOIN cat_arc ON cat_arc.id::text = arc_1.arccat_id::text
                     LEFT JOIN v_price_compost p ON cat_arc.connect_cost = p.id::text
                  WHERE c.arc_id IS NOT NULL
                  GROUP BY c.arc_id) v_plan_aux_arc_connec ON v_plan_aux_arc_connec.arc_id = v_plan_aux_arc_cost.arc_id
             LEFT JOIN ( SELECT DISTINCT ON (c.arc_id) c.arc_id,
                    (min(p.price) * count(*)::numeric)::numeric(12,2) AS gully_total_cost
                   FROM v_edit_gully c
                     JOIN arc arc_1 USING (arc_id)
                     JOIN cat_arc ON cat_arc.id::text = arc_1.arccat_id::text
                     LEFT JOIN v_price_compost p ON cat_arc.connect_cost = p.id::text
                  WHERE c.arc_id IS NOT NULL
                  GROUP BY c.arc_id) v_plan_aux_arc_gully ON v_plan_aux_arc_gully.arc_id = v_plan_aux_arc_cost.arc_id) d;




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
     JOIN element ON element.element_id = element_x_gully.element_id
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
             JOIN link l ON n.node_id = l.exit_id
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
     JOIN link l ON v_edit_connec.connec_id = l.feature_id
     JOIN arc a ON a.arc_id = v_edit_connec.arc_id
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
     JOIN links_node n ON a.node_1 = n.node_id
     JOIN v_edit_connec c ON c.connec_id = n.feature_id
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
     JOIN link l ON v_edit_gully.gully_id = l.feature_id
     JOIN arc a ON a.arc_id = v_edit_gully.arc_id
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
     JOIN links_node n ON a.node_1 = n.node_id
     JOIN v_edit_gully g ON g.gully_id = n.feature_id;



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
    JOIN v_edit_node ON polygon.feature_id = v_edit_node.node_id
	WHERE polygon.sys_type::text = 'STORAGE'::text;

CREATE OR REPLACE VIEW ve_pol_wwtp
AS SELECT polygon.pol_id,
    polygon.feature_id AS node_id,
    polygon.the_geom
    FROM polygon
    JOIN v_edit_node ON polygon.feature_id = v_edit_node.node_id
   WHERE polygon.sys_type::text = 'WWTP'::text;


CREATE OR REPLACE VIEW v_edit_inp_subcatchment
AS SELECT inp_subcatchment.hydrology_id,
    inp_subcatchment.subc_id,
    inp_subcatchment.sector_id,
    inp_subcatchment.minelev,
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
    inp_subcatchment.nperv_pattern_id,
    inp_subcatchment.dstore_pattern_id,
    inp_subcatchment.infil_pattern_id,
    inp_subcatchment.muni_id,
    inp_subcatchment.descript,
    inp_subcatchment.the_geom
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
	JOIN v_edit_node ON polygon.feature_id = v_edit_node.node_id
    WHERE polygon.sys_type::text = 'CHAMBER'::text;

CREATE OR REPLACE VIEW ve_pol_netgully
AS SELECT polygon.pol_id,
    polygon.feature_id AS node_id,
    polygon.the_geom
    FROM polygon
	JOIN v_edit_node ON polygon.feature_id = v_edit_node.node_id
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
             LEFT JOIN man_chamber ON man_chamber.node_id = v_edit_node.node_id
             LEFT JOIN man_storage ON man_storage.node_id = v_edit_node.node_id
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
     JOIN plan_psector_x_node ON plan_psector_x_node.node_id = v_plan_node.node_id
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
    JOIN inp_divider ON v_edit_node.node_id = inp_divider.node_id
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
     JOIN node ON v_edit_arc.node_2 = node.node_id
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
     JOIN node ON v_edit_arc.node_1 = node.node_id
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
     JOIN link ON link.feature_id = v_edit_connec.connec_id AND link.feature_type::text = 'CONNEC'::text
     JOIN node ON v_edit_connec.pjoint_id = node.node_id AND v_edit_connec.pjoint_type::text = 'NODE'::text
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
     JOIN link ON link.feature_id = v_edit_connec.connec_id AND link.feature_type::text = 'CONNEC'::text AND link.exit_type::text = 'CONNEC'::text
     JOIN connec ON connec.connec_id = link.exit_id AND connec.pjoint_type::text = 'NODE'::text
     JOIN node ON connec.pjoint_id = node.node_id
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
     JOIN link ON link.feature_id = v_edit_gully.gully_id AND link.feature_type::text = 'GULLY'::text
     JOIN node ON v_edit_gully.pjoint_id = node.node_id AND v_edit_gully.pjoint_type::text = 'NODE'::text
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
     JOIN link ON link.feature_id = v_edit_gully.gully_id AND link.feature_type::text = 'GULLY'::text AND link.exit_type::text = 'GULLY'::text
     JOIN gully ON gully.gully_id = link.exit_id AND gully.pjoint_type::text = 'NODE'::text
     JOIN node ON gully.pjoint_id = node.node_id
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
                     JOIN plan_psector_x_arc ON plan_psector_x_arc.arc_id = v_plan_arc.arc_id
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
                     JOIN plan_psector_x_arc ON plan_psector_x_arc.arc_id = v_plan_arc.arc_id
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


-- gully and link views
CREATE OR REPLACE VIEW v_edit_inp_gully
AS SELECT g.gully_id,
    g.code,
    g.top_elev,
    g.gully_type,
    g.gullycat_id,
    (g.width / 100::numeric)::numeric(12,2) AS grate_width,
    (g.length / 100::numeric)::numeric(12,2) AS grate_length,
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
        CASE
            WHEN g.units_placement::text = 'LENGTH-SIDE'::text THEN (COALESCE(g.units::integer, 1)::numeric * g.width / 100::numeric)::numeric(12,3)
            WHEN g.units_placement::text = 'WIDTH-SIDE'::text THEN (COALESCE(g.units::integer, 1)::numeric * g.length / 100::numeric)::numeric(12,3)
            ELSE (cat_gully.width / 100::numeric)::numeric(12,3)
        END AS total_width,
        CASE
            WHEN g.units_placement::text = 'LENGTH-SIDE'::text THEN (COALESCE(g.units::integer, 1)::numeric * g.width / 100::numeric)::numeric(12,3)
            WHEN g.units_placement::text = 'WIDTH-SIDE'::text THEN (COALESCE(g.units::integer, 1)::numeric * g.length / 100::numeric)::numeric(12,3)
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
    JOIN gully ON polygon.feature_id = gully.gully_id
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
     LEFT JOIN rpt_arcflow_sum ON inp_orifice.arc_id::text = rpt_arcflow_sum.arc_id::text;



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
             JOIN node ON node.node_id::text = s1.outlet_id
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
    d.sector_id,
    d.muni_id,
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
    d.sector_id,
    d.muni_id,
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


-- [Modified]
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
     JOIN rpt_arc ON rpt_arc.arc_id::text = arc.arc_id
  WHERE rpt_arc.result_id::text = selector_rpt_main.result_id::text AND selector_rpt_main.cur_user = "current_user"()::text AND arc.result_id::text = selector_rpt_main.result_id::text
  ORDER BY arc.arc_id;








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
    the_geom::geometry(Point,SRID_VALUE) AS the_geom
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
           FROM selector_state,
            om_visit
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
           FROM selector_state,
            om_visit
             JOIN om_visit_x_connec ON om_visit_x_connec.visit_id = om_visit.id
             JOIN connec ON connec.connec_id = om_visit_x_connec.connec_id
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
             JOIN gully ON gully.gully_id = om_visit_x_gully.gully_id
             JOIN om_visit_cat ON om_visit.visitcat_id = om_visit_cat.id
          WHERE selector_state.state_id = gully.state AND selector_state.cur_user = "current_user"()::text) a;




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
            WHEN connec.connec_id IS NULL THEN NULL::int4
            ELSE connec.connec_id
        END AS feature_id,
        'CONNEC' AS feature_type,
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
     JOIN connec ON connec.customer_code::text = ext_rtc_hydrometer.connec_id::text
     LEFT JOIN ext_municipality ON ext_municipality.muni_id = connec.muni_id
     LEFT JOIN exploitation ON exploitation.expl_id = connec.expl_id
  WHERE selector_hydrometer.state_id = ext_rtc_hydrometer.state_id AND selector_hydrometer.cur_user = "current_user"()::text AND selector_expl.expl_id = connec.expl_id AND selector_expl.cur_user = "current_user"()::text;

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
        END AS hydrometer_link
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
    JOIN connec ON rtc_hydrometer_x_connec.connec_id = connec.connec_id
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
     LEFT JOIN connec ON connec.connec_id = om_visit_x_connec.connec_id
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
     LEFT JOIN link ON link.link_id = om_visit_x_link.link_id
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
     JOIN connec ON rtc_hydrometer_x_connec.connec_id = connec.connec_id
     LEFT JOIN crm_typevalue crmtype ON ext_rtc_hydrometer_x_data.value_type = crmtype.id::integer AND crmtype.typevalue::text = 'crm_value_type'::text
     LEFT JOIN crm_typevalue crmstatus ON ext_rtc_hydrometer_x_data.value_status = crmstatus.id::integer AND crmstatus.typevalue::text = 'crm_value_status'::text
     LEFT JOIN crm_typevalue crmstate ON ext_rtc_hydrometer_x_data.value_state = crmstate.id::integer AND crmstate.typevalue::text = 'crm_value_state'::text
  ORDER BY 1;


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
     LEFT JOIN gully ON gully.gully_id = om_visit_x_gully.gully_id
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
     LEFT JOIN rpt_arcflow_sum ON rpt_arcflow_sum.arc_id::text = concat (man_frelem.node_id,'_FR', order_id); -- TODO: revise this case


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
     LEFT JOIN rpt_arcflow_sum ON rpt_arcflow_sum.arc_id::text = concat (man_frelem.node_id,'_FR', order_id); -- TODO: revise this case


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
     LEFT JOIN rpt_arcflow_sum ON rpt_arcflow_sum.arc_id::text = concat (man_frelem.node_id,'_FR', order_id); -- TODO: revise this case




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

CREATE OR REPLACE VIEW v_ui_hydroval
AS SELECT ext_rtc_hydrometer_x_data.id,
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

CREATE OR REPLACE VIEW v_edit_review_audit_arc
AS SELECT review_audit_arc.id,
    review_audit_arc.arc_id,
    review_audit_arc.old_y1,
    review_audit_arc.new_y1,
    review_audit_arc.old_y2,
    review_audit_arc.new_y2,
    review_audit_arc.old_arc_type,
    review_audit_arc.new_arc_type,
    review_audit_arc.old_matcat_id,
    review_audit_arc.new_matcat_id,
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
    review_audit_connec.old_y1,
    review_audit_connec.new_y1,
    review_audit_connec.old_y2,
    review_audit_connec.new_y2,
    review_audit_connec.old_connec_type,
    review_audit_connec.new_connec_type,
    review_audit_connec.old_matcat_id,
    review_audit_connec.new_matcat_id,
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


CREATE OR REPLACE VIEW v_edit_review_audit_gully
AS SELECT review_audit_gully.id,
    review_audit_gully.gully_id,
    review_audit_gully.old_top_elev,
    review_audit_gully.new_top_elev,
    review_audit_gully.old_ymax,
    review_audit_gully.new_ymax,
    review_audit_gully.old_sandbox,
    review_audit_gully.new_sandbox,
    review_audit_gully.old_matcat_id,
    review_audit_gully.new_matcat_id,
    review_audit_gully.old_gully_type,
    review_audit_gully.new_gully_type,
    review_audit_gully.old_gratecat_id,
    review_audit_gully.new_gratecat_id,
    review_audit_gully.old_units,
    review_audit_gully.new_units,
    review_audit_gully.old_groove,
    review_audit_gully.new_groove,
    review_audit_gully.old_siphon,
    review_audit_gully.new_siphon,
    review_audit_gully.old_connec_arccat_id,
    review_audit_gully.new_connec_arccat_id,
    review_audit_gully.old_annotation,
    review_audit_gully.new_annotation,
    review_audit_gully.old_observ,
    review_audit_gully.new_observ,
    review_audit_gully.review_obs,
    review_audit_gully.expl_id,
    review_audit_gully.the_geom,
    review_audit_gully.review_status_id,
    review_audit_gully.field_date,
    review_audit_gully.field_user,
    review_audit_gully.is_validated
   FROM review_audit_gully,
    selector_expl
  WHERE selector_expl.cur_user = "current_user"()::text AND review_audit_gully.expl_id = selector_expl.expl_id AND review_audit_gully.review_status_id <> 0 AND review_audit_gully.is_validated IS NULL;

CREATE OR REPLACE VIEW v_edit_review_audit_node
AS SELECT review_audit_node.id,
    review_audit_node.node_id,
    review_audit_node.old_top_elev,
    review_audit_node.new_top_elev,
    review_audit_node.old_ymax,
    review_audit_node.new_ymax,
    review_audit_node.old_node_type,
    review_audit_node.new_node_type,
    review_audit_node.old_matcat_id,
    review_audit_node.new_matcat_id,
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
     JOIN arc ON review_arc.arc_id = arc.arc_id
  WHERE selector_expl.cur_user = "current_user"()::text AND review_arc.expl_id = selector_expl.expl_id;


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


CREATE OR REPLACE VIEW ve_visit_gully_singlevent
AS SELECT om_visit_x_gully.visit_id,
    om_visit_x_gully.gully_id,
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
     JOIN om_visit_x_gully ON om_visit.id = om_visit_x_gully.visit_id
     JOIN config_visit_class ON config_visit_class.id = om_visit.class_id
  WHERE config_visit_class.ismultievent = false;

CREATE OR REPLACE VIEW v_ui_om_visit_x_gully
AS SELECT om_visit_event.id AS event_id,
    om_visit.id AS visit_id,
    om_visit.ext_code,
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
        END AS document,
    om_visit.class_id
   FROM om_visit
     JOIN om_visit_event ON om_visit.id = om_visit_event.visit_id
     JOIN om_visit_x_gully ON om_visit_x_gully.visit_id = om_visit.id
     LEFT JOIN config_visit_parameter ON config_visit_parameter.id::text = om_visit_event.parameter_id::text
     LEFT JOIN ( SELECT DISTINCT om_visit_event_photo.event_id
           FROM om_visit_event_photo) a ON a.event_id = om_visit_event.id
     LEFT JOIN ( SELECT DISTINCT doc_x_visit.visit_id
           FROM doc_x_visit) b ON b.visit_id = om_visit.id
  ORDER BY om_visit_x_gully.gully_id;

CREATE OR REPLACE VIEW v_ui_om_visitman_x_gully
AS SELECT DISTINCT ON (v_ui_om_visit_x_gully.visit_id) v_ui_om_visit_x_gully.visit_id,
    v_ui_om_visit_x_gully.ext_code,
    om_visit_cat.name AS visitcat_name,
    v_ui_om_visit_x_gully.gully_id,
    date_trunc('second'::text, v_ui_om_visit_x_gully.visit_start) AS visit_start,
    date_trunc('second'::text, v_ui_om_visit_x_gully.visit_end) AS visit_end,
    v_ui_om_visit_x_gully.user_name,
    v_ui_om_visit_x_gully.is_done,
    v_ui_om_visit_x_gully.feature_type,
    v_ui_om_visit_x_gully.form_type
   FROM v_ui_om_visit_x_gully
     LEFT JOIN om_visit_cat ON om_visit_cat.id = v_ui_om_visit_x_gully.visitcat_id;

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
     LEFT JOIN gully ON gully.gully_id = om_visit_x_gully.gully_id
     LEFT JOIN ( SELECT DISTINCT om_visit_event_photo.event_id
           FROM om_visit_event_photo) a ON a.event_id = om_visit_event.id
     LEFT JOIN ( SELECT DISTINCT doc_x_visit.visit_id
           FROM doc_x_visit) b ON b.visit_id = om_visit.id
  ORDER BY om_visit_x_gully.gully_id;



CREATE OR REPLACE VIEW ve_epa_outlet
AS SELECT inp_outlet.arc_id,
    inp_outlet.outlet_type,
    inp_outlet.offsetval,
    inp_outlet.curve_id,
    inp_outlet.cd1,
    inp_outlet.cd2,
    inp_outlet.flap,
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
   FROM inp_outlet
     LEFT JOIN rpt_arcflow_sum ON inp_outlet.arc_id::text = rpt_arcflow_sum.arc_id::text;

CREATE OR REPLACE VIEW ve_epa_weir
AS SELECT inp_weir.arc_id,
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
    inp_weir.road_width,
    inp_weir.road_surf,
    inp_weir.coef_curve,
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
   FROM inp_weir
     LEFT JOIN rpt_arcflow_sum ON inp_weir.arc_id::text = rpt_arcflow_sum.arc_id::text;

CREATE OR REPLACE VIEW ve_epa_gully
AS SELECT gully_id,
    outlet_type,
    custom_top_elev,
    custom_width,
    custom_length,
    custom_depth,
    method,
    weir_cd,
    orifice_cd,
    custom_a_param,
    custom_b_param,
    efficiency
   FROM inp_gully;


CREATE OR REPLACE VIEW v_edit_plan_psector_x_gully
AS SELECT plan_psector_x_gully.id,
    plan_psector_x_gully.gully_id,
    plan_psector_x_gully.arc_id,
    plan_psector_x_gully.psector_id,
    plan_psector_x_gully.state,
    plan_psector_x_gully.doable,
    plan_psector_x_gully.descript,
    plan_psector_x_gully.link_id,
    plan_psector_x_gully.active,
    plan_psector_x_gully.insert_tstamp,
    plan_psector_x_gully.insert_user,
    link.exit_type
   FROM plan_psector_x_gully
     LEFT JOIN link USING (link_id);

CREATE OR REPLACE VIEW v_state_gully
AS WITH p AS (
         SELECT plan_psector_x_gully.gully_id,
            plan_psector_x_gully.psector_id,
            plan_psector_x_gully.state,
            plan_psector_x_gully.arc_id
           FROM plan_psector_x_gully
          WHERE plan_psector_x_gully.active
        ), s AS (
         SELECT selector_psector.psector_id,
            selector_psector.cur_user
           FROM selector_psector
          WHERE selector_psector.cur_user = CURRENT_USER
        ), c AS (
         SELECT gully.gully_id,
            gully.state,
            gully.arc_id
           FROM gully
        )
(
         SELECT c.gully_id,
            c.arc_id
           FROM selector_state,
            c
          WHERE c.state = selector_state.state_id AND selector_state.cur_user = "current_user"()::text
        EXCEPT ALL
         SELECT p.gully_id,
            p.arc_id
           FROM s,
            p
          WHERE p.psector_id = s.psector_id AND s.cur_user = "current_user"()::text AND p.state = 0
) UNION ALL
 SELECT DISTINCT ON (p.gully_id) p.gully_id,
    p.arc_id
   FROM s,
    p
  WHERE p.psector_id = s.psector_id AND s.cur_user = "current_user"()::text AND p.state = 1;

CREATE OR REPLACE VIEW v_state_link_connec
AS WITH p AS (
         SELECT plan_psector_x_connec.connec_id,
            plan_psector_x_connec.psector_id,
            plan_psector_x_connec.state,
            plan_psector_x_connec.link_id
           FROM plan_psector_x_connec
          WHERE plan_psector_x_connec.active
        ), sp AS (
         SELECT selector_psector.psector_id,
            selector_psector.cur_user
           FROM selector_psector
          WHERE selector_psector.cur_user = CURRENT_USER
        ), se AS (
         SELECT selector_expl.expl_id,
            selector_expl.cur_user
           FROM selector_expl
          WHERE selector_expl.cur_user = CURRENT_USER
        ), l AS (
         SELECT link.link_id,
            link.state,
            link.expl_id,
            link.expl_id2
           FROM link
        )
(
         SELECT l.link_id
           FROM selector_state,
            se,
            l
          WHERE l.state = selector_state.state_id AND (l.expl_id = se.expl_id OR l.expl_id2 = se.expl_id) AND selector_state.cur_user = "current_user"()::text AND se.cur_user = "current_user"()::text
        EXCEPT ALL
         SELECT p.link_id
           FROM sp,
            se,
            p
             JOIN l USING (link_id)
          WHERE p.psector_id = sp.psector_id AND sp.cur_user = "current_user"()::text AND p.state = 0 AND l.expl_id = se.expl_id AND se.cur_user = CURRENT_USER::text
) UNION ALL
 SELECT DISTINCT p.link_id
   FROM sp,
    se,
    p
     JOIN l USING (link_id)
  WHERE p.psector_id = sp.psector_id AND sp.cur_user = "current_user"()::text AND p.state = 1 AND l.expl_id = se.expl_id AND se.cur_user = CURRENT_USER::text;


CREATE OR REPLACE VIEW v_state_link_gully
AS WITH p AS (
         SELECT plan_psector_x_gully.gully_id,
            plan_psector_x_gully.psector_id,
            plan_psector_x_gully.state,
            plan_psector_x_gully.link_id
           FROM plan_psector_x_gully
          WHERE plan_psector_x_gully.active
        ), sp AS (
         SELECT selector_psector.psector_id,
            selector_psector.cur_user
           FROM selector_psector
          WHERE selector_psector.cur_user = CURRENT_USER
        ), se AS (
         SELECT selector_expl.expl_id,
            selector_expl.cur_user
           FROM selector_expl
          WHERE selector_expl.cur_user = CURRENT_USER
        ), l AS (
         SELECT link.link_id,
            link.state,
            link.expl_id,
            link.expl_id2
           FROM link
        )
(
         SELECT l.link_id
           FROM selector_state,
            se,
            l
          WHERE l.state = selector_state.state_id AND (l.expl_id = se.expl_id OR l.expl_id2 = se.expl_id) AND selector_state.cur_user = "current_user"()::text AND se.cur_user = "current_user"()::text
        EXCEPT ALL
         SELECT p.link_id
           FROM sp,
            se,
            p
             JOIN l USING (link_id)
          WHERE p.psector_id = sp.psector_id AND sp.cur_user = "current_user"()::text AND p.state = 0 AND l.expl_id = se.expl_id AND se.cur_user = CURRENT_USER::text
) UNION ALL
 SELECT DISTINCT p.link_id
   FROM sp,
    se,
    p
     JOIN l USING (link_id)
  WHERE p.psector_id = sp.psector_id AND sp.cur_user = "current_user"()::text AND p.state = 1 AND l.expl_id = se.expl_id AND se.cur_user = CURRENT_USER::text;


CREATE OR REPLACE VIEW ve_epa_virtual
AS SELECT arc_id,
    fusion_node,
    add_length
   FROM inp_virtual;

CREATE OR REPLACE VIEW v_rpt_arc_compare_all
AS SELECT rpt_arc.id,
    arc.arc_id,
    selector_rpt_compare.result_id,
    arc.arc_type,
    arc.arccat_id,
    rpt_arc.flow,
    rpt_arc.velocity,
    rpt_arc.fullpercent,
    rpt_arc.resultdate,
    rpt_arc.resulttime,
    arc.the_geom
   FROM selector_rpt_compare,
    rpt_inp_arc arc
     JOIN rpt_arc ON rpt_arc.arc_id::text = arc.arc_id::text
  WHERE rpt_arc.result_id::text = selector_rpt_compare.result_id::text AND selector_rpt_compare.cur_user = "current_user"()::text AND arc.result_id::text = selector_rpt_compare.result_id::text
  ORDER BY arc.arc_id;

CREATE OR REPLACE VIEW v_rpt_arc_compare_timestep
AS SELECT rpt_arc.id,
    arc.arc_id,
    selector_rpt_compare.result_id,
    rpt_arc.flow,
    rpt_arc.velocity,
    rpt_arc.fullpercent,
    rpt_arc.resultdate,
    rpt_arc.resulttime,
    arc.the_geom
   FROM selector_rpt_compare,
    selector_rpt_compare_tstep,
    rpt_inp_arc arc
     JOIN rpt_arc ON rpt_arc.arc_id::text = arc.arc_id::text
  WHERE rpt_arc.result_id::text = selector_rpt_compare.result_id::text AND rpt_arc.resulttime::text = selector_rpt_compare_tstep.resulttime::text AND selector_rpt_compare.cur_user = "current_user"()::text AND selector_rpt_compare_tstep.cur_user = "current_user"()::text AND arc.result_id::text = selector_rpt_compare.result_id::text
  ORDER BY rpt_arc.resulttime, arc.arc_id;


CREATE OR REPLACE VIEW v_rpt_arc_timestep
AS SELECT rpt_arc.id,
    arc.arc_id,
    selector_rpt_main.result_id,
    rpt_arc.flow,
    rpt_arc.velocity,
    rpt_arc.fullpercent,
    rpt_arc.resultdate,
    rpt_arc.resulttime,
    arc.the_geom
   FROM selector_rpt_main,
    selector_rpt_main_tstep,
    rpt_inp_arc arc
     JOIN rpt_arc ON rpt_arc.arc_id::text = arc.arc_id::text
  WHERE rpt_arc.result_id::text = selector_rpt_main.result_id::text AND rpt_arc.resulttime::text = selector_rpt_main_tstep.resulttime::text AND selector_rpt_main.cur_user = "current_user"()::text AND selector_rpt_main_tstep.cur_user = "current_user"()::text AND arc.result_id::text = selector_rpt_main.result_id::text
  ORDER BY rpt_arc.resulttime, arc.arc_id;

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
	JOIN rpt_nodedepth_sum ON rpt_nodedepth_sum.node_id::text = rpt_inp_node.node_id
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
    JOIN rpt_nodedepth_sum ON rpt_nodedepth_sum.node_id::text = rpt_inp_node.node_id
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
	FROM main RIGHT JOIN compare ON main.node_id::text = compare.node_id::text;

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
     JOIN rpt_nodeinflow_sum ON rpt_nodeinflow_sum.node_id::text = rpt_inp_node.node_id
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
    JOIN rpt_nodeinflow_sum ON rpt_nodeinflow_sum.node_id::text = rpt_inp_node.node_id
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
	FROM main RIGHT JOIN compare ON main.node_id::text = compare.node_id::text;

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
    JOIN rpt_nodeflooding_sum ON rpt_nodeflooding_sum.node_id::text = rpt_inp_node.node_id
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
	JOIN rpt_nodeflooding_sum ON rpt_nodeflooding_sum.node_id::text = rpt_inp_node.node_id
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
	FROM main RIGHT JOIN compare ON main.node_id::text = compare.node_id::text;

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
    JOIN rpt_nodesurcharge_sum ON rpt_nodesurcharge_sum.node_id::text = rpt_inp_node.node_id
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
    JOIN rpt_nodesurcharge_sum ON rpt_nodesurcharge_sum.node_id::text = rpt_inp_node.node_id
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
	FROM main RIGHT JOIN compare ON main.node_id::text = compare.node_id::text;

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
    JOIN rpt_arcflow_sum ON rpt_arcflow_sum.arc_id::text = rpt_inp_arc.arc_id
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
    JOIN rpt_arcflow_sum ON rpt_arcflow_sum.arc_id::text = rpt_inp_arc.arc_id
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
    FROM main LEFT JOIN compare ON main.arc_id = compare.arc_id::text

	UNION

	SELECT
    compare.arc_id::text,
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
    FROM main RIGHT JOIN compare ON main.arc_id::text = compare.arc_id::text;


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
    JOIN rpt_condsurcharge_sum ON rpt_condsurcharge_sum.arc_id::text = rpt_inp_arc.arc_id
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
    JOIN rpt_condsurcharge_sum ON rpt_condsurcharge_sum.arc_id::text = rpt_inp_arc.arc_id
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
    FROM main LEFT JOIN compare ON main.arc_id = compare.arc_id::text

    UNION

    SELECT
    compare.arc_id::text,
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
    FROM main RIGHT JOIN compare ON main.arc_id::text = compare.arc_id::text;


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
    JOIN rpt_pumping_sum ON rpt_pumping_sum.arc_id::text = rpt_inp_arc.arc_id
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
    JOIN rpt_pumping_sum ON rpt_pumping_sum.arc_id::text = rpt_inp_arc.arc_id
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
    FROM main RIGHT JOIN compare ON main.arc_id::text = compare.arc_id::text; ;

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
    JOIN rpt_flowclass_sum ON rpt_flowclass_sum.arc_id::text = rpt_inp_arc.arc_id
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
    JOIN rpt_flowclass_sum ON rpt_flowclass_sum.arc_id::text = rpt_inp_arc.arc_id
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
	FROM main RIGHT JOIN compare ON main.arc_id::text = compare.arc_id::text;


CREATE OR REPLACE VIEW v_rpt_arcflow_sum
AS SELECT rpt_inp_arc.id,
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
    COALESCE(rpt_arcflow_sum.mfull_depth, 0::numeric(12,4)) AS mfull_dept,
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
     JOIN rpt_arcflow_sum ON rpt_arcflow_sum.arc_id::text = rpt_inp_arc.arc_id::text
  WHERE rpt_arcflow_sum.result_id::text = selector_rpt_main.result_id::text AND selector_rpt_main.cur_user = "current_user"()::text AND rpt_inp_arc.result_id::text = selector_rpt_main.result_id::text;



CREATE OR REPLACE VIEW ve_epa_conduit
AS SELECT inp_conduit.arc_id,
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
    v_rpt_arcflow_sum.max_flow,
    v_rpt_arcflow_sum.time_days,
    v_rpt_arcflow_sum.time_hour,
    v_rpt_arcflow_sum.max_veloc,
    v_rpt_arcflow_sum.mfull_flow,
    v_rpt_arcflow_sum.mfull_dept,
    v_rpt_arcflow_sum.max_shear,
    v_rpt_arcflow_sum.max_hr,
    v_rpt_arcflow_sum.max_slope,
    v_rpt_arcflow_sum.day_max,
    v_rpt_arcflow_sum.time_max,
    v_rpt_arcflow_sum.min_shear,
    v_rpt_arcflow_sum.day_min,
    v_rpt_arcflow_sum.time_min
   FROM inp_conduit
     LEFT JOIN v_rpt_arcflow_sum ON inp_conduit.arc_id::text = v_rpt_arcflow_sum.arc_id::text;

CREATE OR REPLACE VIEW v_rpt_arcpolload_sum
AS SELECT rpt_inp_arc.id,
    rpt_inp_arc.arc_id,
    rpt_inp_arc.result_id,
    rpt_inp_arc.arc_type,
    rpt_inp_arc.arccat_id,
    rpt_inp_arc.sector_id,
    rpt_inp_arc.the_geom,
    rpt_arcpolload_sum.poll_id
   FROM selector_rpt_main,
    rpt_inp_arc
     JOIN rpt_arcpolload_sum ON rpt_arcpolload_sum.arc_id::text = rpt_inp_arc.arc_id::text
  WHERE rpt_arcpolload_sum.result_id::text = selector_rpt_main.result_id::text AND selector_rpt_main.cur_user = "current_user"()::text AND rpt_inp_arc.result_id::text = selector_rpt_main.result_id::text;


CREATE OR REPLACE VIEW v_rpt_condsurcharge_sum
AS SELECT rpt_inp_arc.id,
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
  WHERE rpt_condsurcharge_sum.result_id::text = selector_rpt_main.result_id::text AND selector_rpt_main.cur_user = "current_user"()::text AND rpt_inp_arc.result_id::text = selector_rpt_main.result_id::text;

CREATE OR REPLACE VIEW v_rpt_flowclass_sum
AS SELECT rpt_flowclass_sum.id,
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
  WHERE rpt_flowclass_sum.result_id::text = selector_rpt_main.result_id::text AND selector_rpt_main.cur_user = "current_user"()::text AND rpt_inp_arc.result_id::text = selector_rpt_main.result_id::text;

CREATE OR REPLACE VIEW v_rpt_pumping_sum
AS SELECT rpt_pumping_sum.id,
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
  WHERE rpt_pumping_sum.result_id::text = selector_rpt_main.result_id::text AND selector_rpt_main.cur_user = "current_user"()::text AND rpt_inp_arc.result_id::text = selector_rpt_main.result_id::text;

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
     LEFT JOIN v_rpt_pumping_sum ON inp_pump.arc_id::text = v_rpt_pumping_sum.arc_id::text;

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
     LEFT JOIN v_rpt_pumping_sum ON v_rpt_pumping_sum.arc_id::text = concat (man_frelem.node_id,'_FR', order_id);  -- TODO: revise this case

CREATE OR REPLACE VIEW v_rpt_nodedepth_sum
AS SELECT rpt_nodedepth_sum.id,
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
  WHERE rpt_nodedepth_sum.result_id::text = selector_rpt_main.result_id::text AND selector_rpt_main.cur_user = "current_user"()::text AND rpt_inp_node.result_id::text = selector_rpt_main.result_id::text;

CREATE OR REPLACE VIEW v_rpt_nodesurcharge_sum
AS SELECT rpt_inp_node.id,
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
  WHERE rpt_nodesurcharge_sum.result_id::text = selector_rpt_main.result_id::text AND selector_rpt_main.cur_user = "current_user"()::text AND rpt_inp_node.result_id::text = selector_rpt_main.result_id::text;



CREATE OR REPLACE VIEW v_rpt_nodeflooding_sum
AS SELECT rpt_inp_node.id,
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
  WHERE rpt_nodeflooding_sum.result_id::text = selector_rpt_main.result_id::text AND selector_rpt_main.cur_user = "current_user"()::text AND rpt_inp_node.result_id::text = selector_rpt_main.result_id::text;

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
     LEFT JOIN v_rpt_nodedepth_sum d ON inp_junction.node_id::text = d.node_id::text
     LEFT JOIN v_rpt_nodesurcharge_sum s ON d.node_id::text = s.node_id::text
     LEFT JOIN v_rpt_nodeflooding_sum f ON s.node_id::text = f.node_id::text;

CREATE OR REPLACE VIEW ve_epa_netgully
AS SELECT inp_netgully.node_id,
    inp_netgully.y0,
    inp_netgully.ysur,
    inp_netgully.apond,
    inp_netgully.outlet_type,
    inp_netgully.custom_width,
    inp_netgully.custom_length,
    inp_netgully.custom_depth,
    inp_netgully.method,
    inp_netgully.weir_cd,
    inp_netgully.orifice_cd,
    inp_netgully.custom_a_param,
    inp_netgully.custom_b_param,
    inp_netgully.efficiency,
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
   FROM inp_netgully
     LEFT JOIN v_rpt_nodedepth_sum d ON inp_netgully.node_id::text = d.node_id::text
     LEFT JOIN v_rpt_nodesurcharge_sum s ON d.node_id::text = s.node_id::text
     LEFT JOIN v_rpt_nodeflooding_sum f ON s.node_id::text = f.node_id::text;

CREATE OR REPLACE VIEW v_rpt_nodeinflow_sum
AS SELECT rpt_inp_node.id,
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
  WHERE rpt_nodeinflow_sum.result_id::text = selector_rpt_main.result_id::text AND selector_rpt_main.cur_user = "current_user"()::text AND rpt_inp_node.result_id::text = selector_rpt_main.result_id::text;




CREATE OR REPLACE VIEW v_rpt_comp_outfallflow_sum
AS SELECT rpt_outfallflow_sum.id,
    rpt_outfallflow_sum.result_id,
    rpt_outfallflow_sum.node_id,
    rpt_inp_node.node_type,
    rpt_inp_node.nodecat_id,
    rpt_outfallflow_sum.flow_freq,
    rpt_outfallflow_sum.avg_flow,
    rpt_outfallflow_sum.max_flow,
    rpt_outfallflow_sum.total_vol,
    rpt_inp_node.the_geom,
    rpt_inp_node.sector_id
   FROM selector_rpt_compare,
    rpt_inp_node
     JOIN rpt_outfallflow_sum ON rpt_outfallflow_sum.node_id::text = rpt_inp_node.node_id::text
  WHERE rpt_outfallflow_sum.result_id::text = selector_rpt_compare.result_id::text AND selector_rpt_compare.cur_user = "current_user"()::text AND rpt_inp_node.result_id::text = selector_rpt_compare.result_id::text;


CREATE OR REPLACE VIEW v_rpt_outfallflow_sum
AS SELECT rpt_inp_node.id,
    rpt_outfallflow_sum.node_id,
    rpt_outfallflow_sum.result_id,
    rpt_inp_node.node_type,
    rpt_inp_node.nodecat_id,
    rpt_outfallflow_sum.flow_freq,
    rpt_outfallflow_sum.avg_flow,
    rpt_outfallflow_sum.max_flow,
    rpt_outfallflow_sum.total_vol,
    rpt_inp_node.the_geom,
    rpt_inp_node.sector_id
   FROM selector_rpt_main,
    rpt_inp_node
     JOIN rpt_outfallflow_sum ON rpt_outfallflow_sum.node_id::text = rpt_inp_node.node_id::text
  WHERE rpt_outfallflow_sum.result_id::text = selector_rpt_main.result_id::text AND selector_rpt_main.cur_user = "current_user"()::text AND rpt_inp_node.result_id::text = selector_rpt_main.result_id::text;


CREATE OR REPLACE VIEW ve_epa_outfall
AS SELECT inp_outfall.node_id,
    inp_outfall.outfall_type,
    inp_outfall.stage,
    inp_outfall.curve_id,
    inp_outfall.timser_id,
    inp_outfall.gate,
    v_rpt_outfallflow_sum.flow_freq,
    v_rpt_outfallflow_sum.avg_flow,
    v_rpt_outfallflow_sum.max_flow,
    v_rpt_outfallflow_sum.total_vol
   FROM inp_outfall
     LEFT JOIN v_rpt_outfallflow_sum ON inp_outfall.node_id::text = v_rpt_outfallflow_sum.node_id::text;

CREATE OR REPLACE VIEW v_rpt_comp_outfallload_sum
AS SELECT rpt_outfallload_sum.id,
    rpt_outfallload_sum.result_id,
    rpt_outfallload_sum.poll_id,
    rpt_outfallload_sum.node_id,
    rpt_inp_node.node_type,
    rpt_inp_node.nodecat_id,
    rpt_outfallload_sum.value,
    rpt_inp_node.sector_id,
    rpt_inp_node.the_geom
   FROM selector_rpt_compare,
    rpt_inp_node
     JOIN rpt_outfallload_sum ON rpt_outfallload_sum.node_id::text = rpt_inp_node.node_id::text
  WHERE rpt_outfallload_sum.result_id::text = selector_rpt_compare.result_id::text AND selector_rpt_compare.cur_user = "current_user"()::text AND rpt_inp_node.result_id::text = selector_rpt_compare.result_id::text;


CREATE OR REPLACE VIEW v_rpt_outfallload_sum
AS SELECT rpt_inp_node.id,
    rpt_outfallload_sum.node_id,
    rpt_outfallload_sum.result_id,
    rpt_outfallload_sum.poll_id,
    rpt_inp_node.node_type,
    rpt_inp_node.nodecat_id,
    rpt_outfallload_sum.value,
    rpt_inp_node.sector_id,
    rpt_inp_node.the_geom
   FROM selector_rpt_main,
    rpt_inp_node
     JOIN rpt_outfallload_sum ON rpt_outfallload_sum.node_id::text = rpt_inp_node.node_id::text
  WHERE rpt_outfallload_sum.result_id::text = selector_rpt_main.result_id::text AND selector_rpt_main.cur_user = "current_user"()::text AND rpt_inp_node.result_id::text = selector_rpt_main.result_id::text;


CREATE OR REPLACE VIEW v_rpt_node_compare_timestep
AS SELECT rpt_node.id,
    node.node_id,
    selector_rpt_compare.result_id,
    node.node_type,
    node.nodecat_id,
    rpt_node.resultdate,
    rpt_node.resulttime,
    rpt_node.flooding,
    rpt_node.depth,
    rpt_node.head,
    node.the_geom
   FROM selector_rpt_compare,
    selector_rpt_compare_tstep,
    rpt_inp_node node
     JOIN rpt_node ON rpt_node.node_id::text = node.node_id::text
  WHERE rpt_node.result_id::text = selector_rpt_compare.result_id::text AND rpt_node.resulttime::text = selector_rpt_compare_tstep.resulttime::text AND selector_rpt_compare.cur_user = "current_user"()::text AND selector_rpt_compare_tstep.cur_user = "current_user"()::text AND node.result_id::text = selector_rpt_compare.result_id::text
  ORDER BY rpt_node.resulttime, node.node_id;



CREATE OR REPLACE VIEW v_rpt_node_timestep
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
    selector_rpt_main_tstep,
    rpt_inp_node node
     JOIN rpt_node ON rpt_node.node_id::text = node.node_id::text
  WHERE rpt_node.result_id::text = selector_rpt_main.result_id::text AND rpt_node.resulttime::text = selector_rpt_main_tstep.resulttime::text AND selector_rpt_main.cur_user = "current_user"()::text AND selector_rpt_main_tstep.cur_user = "current_user"()::text AND node.result_id::text = selector_rpt_main.result_id::text
  ORDER BY rpt_node.resulttime, node.node_id;


CREATE OR REPLACE VIEW v_rpt_storagevol_sum
AS SELECT rpt_storagevol_sum.id,
    rpt_storagevol_sum.result_id,
    rpt_storagevol_sum.node_id,
    rpt_inp_node.node_type,
    rpt_inp_node.nodecat_id,
    rpt_storagevol_sum.aver_vol,
    rpt_storagevol_sum.avg_full,
    rpt_storagevol_sum.ei_loss,
    rpt_storagevol_sum.max_vol,
    rpt_storagevol_sum.max_full,
    rpt_storagevol_sum.time_days,
    rpt_storagevol_sum.time_hour,
    rpt_storagevol_sum.max_out,
    rpt_inp_node.sector_id,
    rpt_inp_node.the_geom
   FROM selector_rpt_main,
    rpt_inp_node
     JOIN rpt_storagevol_sum ON rpt_storagevol_sum.node_id::text = rpt_inp_node.node_id::text
  WHERE rpt_storagevol_sum.result_id::text = selector_rpt_main.result_id::text AND selector_rpt_main.cur_user = "current_user"()::text AND rpt_inp_node.result_id::text = selector_rpt_main.result_id::text;


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
     LEFT JOIN v_rpt_storagevol_sum ON inp_storage.node_id::text = v_rpt_storagevol_sum.node_id::text;


CREATE OR REPLACE VIEW v_rpt_node_compare_all
AS SELECT rpt_node.id,
    node.node_id,
    selector_rpt_compare.result_id,
    node.node_type,
    node.nodecat_id,
    rpt_node.resultdate,
    rpt_node.resulttime,
    rpt_node.flooding,
    rpt_node.depth,
    rpt_node.head,
    node.the_geom
   FROM selector_rpt_compare,
    rpt_inp_node node
     JOIN rpt_node ON rpt_node.node_id::text = node.node_id::text
  WHERE rpt_node.result_id::text = selector_rpt_compare.result_id::text AND selector_rpt_compare.cur_user = "current_user"()::text AND node.result_id::text = selector_rpt_compare.result_id::text
  GROUP BY rpt_node.id, node.node_id, node.node_type, node.nodecat_id, selector_rpt_compare.result_id, node.the_geom
  ORDER BY node.node_id;


CREATE OR REPLACE VIEW v_rpt_comp_storagevol_sum
AS SELECT rpt_storagevol_sum.id,
    rpt_storagevol_sum.result_id,
    rpt_storagevol_sum.node_id,
    node.node_type,
    node.nodecat_id,
    rpt_storagevol_sum.aver_vol,
    rpt_storagevol_sum.avg_full,
    rpt_storagevol_sum.ei_loss,
    rpt_storagevol_sum.max_vol,
    rpt_storagevol_sum.max_full,
    rpt_storagevol_sum.time_days,
    rpt_storagevol_sum.time_hour,
    rpt_storagevol_sum.max_out,
    node.sector_id,
    node.the_geom
   FROM selector_rpt_compare,
    rpt_inp_node node
     JOIN rpt_storagevol_sum ON rpt_storagevol_sum.node_id::text = node.node_id::text
  WHERE rpt_storagevol_sum.result_id::text = selector_rpt_compare.result_id::text AND selector_rpt_compare.cur_user = "current_user"()::text AND node.result_id::text = selector_rpt_compare.result_id::text;

CREATE OR REPLACE VIEW ve_epa_virtual
AS SELECT arc_id,
    fusion_node,
    add_length
   FROM inp_virtual;

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
     JOIN inp_virtual ON v_edit_arc.arc_id::text = inp_virtual.arc_id::text
  WHERE v_edit_arc.is_operative IS TRUE;

CREATE OR REPLACE VIEW v_edit_cat_feature_connec
AS SELECT cat_feature.id,
    cat_feature.feature_class AS system_id,
    cat_feature.code_autofill,
    cat_feature_connec.double_geom::text AS double_geom,
    cat_feature.shortcut_key,
    cat_feature.link_path,
    cat_feature.descript,
    cat_feature.active
   FROM cat_feature
     JOIN cat_feature_connec USING (id);

-- Insert into sys_feature_epa_type
INSERT INTO sys_feature_epa_type (id, feature_type, epa_table, descript, active) VALUES('FRWEIR', 'ELEMENT', 'inp_frweir', NULL, true);
INSERT INTO sys_feature_epa_type (id, feature_type, epa_table, descript, active) VALUES('FRORIFICE', 'ELEMENT', 'inp_frorifice', NULL, true);
INSERT INTO sys_feature_epa_type (id, feature_type, epa_table, descript, active) VALUES('FROUTLET', 'ELEMENT', 'inp_froutlet', NULL, true);
INSERT INTO sys_feature_epa_type (id, feature_type, epa_table, descript, active) VALUES('UNDEFINED', 'ELEMENT', NULL, NULL, true);

-- Adding flowregulator objects on cat_feature [Modified from first version]
INSERT INTO cat_feature (id, feature_class, feature_type, parent_layer, child_layer, active) VALUES ('EPUMP', 'FRELEM', 'ELEMENT', 've_frelem', 've_frelem_epump', true) ON CONFLICT (id) DO NOTHING;

INSERT INTO cat_feature (id, feature_class, feature_type, parent_layer, child_layer)
SELECT concat('E', upper(REPLACE(id, ' ', '_'))), 'GENELEM', 'ELEMENT', 've_genelem', concat('ve_genelem_', concat('e', lower(REPLACE(id, ' ', '_')))) FROM _element_type ON CONFLICT (id) DO NOTHING;

INSERT INTO cat_feature (id, feature_class, feature_type, parent_layer, child_layer, active) VALUES ('EORIFICE', 'FRELEM', 'ELEMENT', 've_frelem', 've_frelem_eorifice', true) ON CONFLICT (id) DO NOTHING;
INSERT INTO cat_feature (id, feature_class, feature_type, parent_layer, child_layer, active) VALUES ('EOUTLET', 'FRELEM', 'ELEMENT', 've_frelem', 've_frelem_eoutlet', true) ON CONFLICT (id) DO NOTHING;
INSERT INTO cat_feature (id, feature_class, feature_type, parent_layer, child_layer, active) VALUES ('EWEIR', 'FRELEM', 'ELEMENT', 've_frelem', 've_frelem_eweir', true) ON CONFLICT (id) DO NOTHING;
-- Adding objects on config_info_layer and config_info_layer_x_type (this both tables controls the button info)

INSERT INTO cat_feature (id, feature_class, feature_type, shortcut_key, parent_layer, child_layer, descript, link_path, code_autofill, active, addparam)
VALUES('LINK', 'LINK', 'LINK', NULL, 'v_edit_link', 've_link_link', 'Link', NULL, true, true, NULL);

INSERT INTO cat_feature_link (id) VALUES ('LINK') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_param_user (id, formname, descript, sys_role, idval, "label", dv_querytext, dv_parent_id, isenabled, layoutorder, project_type, isparent, dv_querytext_filterc, feature_field_id, feature_dv_parent_value, isautoupdate, "datatype", widgettype, ismandatory, widgetcontrols, vdefault, layoutname, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, placeholder, "source")
VALUES('edit_gully_linkcat_vdefault', 'config', 'Value default catalog for link connected to gully', 'role_edit', NULL, 'Default catalog for linkcat:', 'SELECT DISTINCT ON (cl.id) cl.id, cl.id AS idval FROM link l JOIN cat_link cl ON l.linkcat_id = cl.id WHERE l.link_type = ''LINK''', NULL, true, 20, 'ud', false, NULL, 'linkcat_id', NULL, false, 'text', 'combo', true, NULL, 'CC020', 'lyt_gully', true, true, false, NULL, NULL, NULL);

UPDATE sys_param_user
SET vdefault='CC040_I',"label"='Default catalog for linkcat:', dv_querytext='SELECT cat_link.id, cat_link.id AS idval FROM cat_link JOIN cat_feature ON cat_feature.id = cat_link.link_type WHERE cat_link.link_type = ''CONDUITLINK''', descript='Value default catalog for link', feature_field_id='linkcat_id', ismandatory=true, dv_isnullvalue=false, project_type='ud'
WHERE id='edit_gully_linkcat_vdefault';


INSERT INTO cat_link (id, link_type, matcat_id, descript, link, brand_id, model_id, svg, estimated_depth, active, label)
SELECT id, 'LINK' as link_type, matcat_id, descript, link, brand_id, model_id, svg, estimated_depth, active, label
FROM cat_connec ON CONFLICT DO NOTHING;

ALTER TABLE link ADD CONSTRAINT link_link_type_fkey FOREIGN KEY (link_type) REFERENCES cat_feature_link(id) ON DELETE RESTRICT ON UPDATE CASCADE;

INSERT INTO cat_link (id, link_type) VALUES ('UPDATE_LINK_40', 'LINK');

INSERT INTO link (link_id, code, feature_id, feature_type, exit_id, exit_type, userdefined_geom, state, state_type, expl_id, the_geom,
created_at, sector_id, omzone_id, _fluid_type, expl_visibility, epa_type, is_operative, created_by, updated_at,
updated_by, linkcat_id, workcat_id, workcat_id_end, builtdate, enddate, drainzone_id, uncertain, muni_id, verified,
top_elev1, top_elev2, y2, link_type)
SELECT nextval('SCHEMA_NAME.urn_id_seq'::regclass), link_id::text, feature_id::integer, feature_type, exit_id::integer, exit_type, userdefined_geom, state, 2, expl_id, the_geom,
tstamp, sector_id, dma_id, fluid_type, ARRAY[expl_id2], epa_type, is_operative, insert_user, lastupdate, lastupdate_user,
CASE
  WHEN conneccat_id IS NULL THEN
    CASE
      WHEN feature_type = 'GULLY' THEN
        (SELECT _connec_arccat_id FROM gully WHERE gully_id = feature_id::int4 LIMIT 1)
      WHEN feature_type = 'CONNEC' THEN
        (SELECT conneccat_id FROM connec WHERE connec_id = feature_id::int4 LIMIT 1)
      ELSE
        'UPDATE_LINK_40'
    END
  ELSE conneccat_id
END AS conneccat_id, workcat_id, workcat_id_end, builtdate, enddate, drainzone_id, uncertain, muni_id, verified,
CASE
  WHEN feature_type = 'GULLY' THEN
    (SELECT g.top_elev FROM gully g WHERE g.gully_id = feature_id::int4 LIMIT 1)
  WHEN feature_type = 'CONNEC' THEN
    (SELECT c.top_elev FROM connec c WHERE c.connec_id = feature_id::int4 LIMIT 1)
  ELSE NULL
END AS top_elev1, exit_topelev,
CASE
  WHEN exit_topelev IS NOT NULL AND exit_elev IS NOT NULL THEN
    exit_topelev - exit_elev
  ELSE NULL
END AS y2,
'LINK' AS link_type
FROM _link;

UPDATE link l
SET state_type = c.state_type
FROM connec c
WHERE l.feature_id = c.connec_id AND l.feature_type = 'CONNEC' AND l.state = 1;

UPDATE link l
SET state_type = g.state_type
FROM gully g
WHERE l.feature_id = g.gully_id AND l.feature_type = 'GULLY' AND l.state = 1;

UPDATE link SET state_type = (
  SELECT (value::json->>'plan_statetype_planned')::int2 FROM config_param_system WHERE parameter = 'plan_statetype_vdefault'
)
WHERE state = 2;


-- DO $func$
-- DECLARE
--   gullyr record;
--   connecr record;
-- BEGIN
--   FOR gullyr IN (SELECT g.gully_id, g._connec_arccat_id FROM gully g LEFT JOIN link l ON l.feature_id = g.gully_id WHERE l.feature_id IS NULL)
--   LOOP
--     EXECUTE 'SELECT gw_fct_setlinktonetwork($${"client": {"device": 4, "lang": "en_US", "infoType": 1, "epsg": SRID_VALUE}, "form": {}, "feature": {"id": "[' || gullyr.gully_id || ']"},
--     "data": {"filterFields": {}, "pageInfo": {}, "feature_type": "GULLY", "linkcatId":"UPDATE_LINK_40"}}$$);';
--     UPDATE link SET uncertain=true WHERE feature_id = gullyr.gully_id;
--   END LOOP;

--   FOR connecr IN (SELECT c.connec_id, c.conneccat_id FROM connec c LEFT JOIN link l ON l.feature_id = c.connec_id WHERE l.feature_id IS NULL)
--   LOOP
--     EXECUTE 'SELECT gw_fct_setlinktonetwork($${"client": {"device": 4, "lang": "en_US", "infoType": 1, "epsg": SRID_VALUE}, "form": {}, "feature": {"id": "[' || connecr.connec_id || ']"},
--     "data": {"filterFields": {}, "pageInfo": {}, "feature_type": "CONNEC", "linkcatId":"UPDATE_LINK_40"}}$$);';
--     UPDATE link SET uncertain=true WHERE feature_id = connecr.connec_id;
--   END LOOP;
-- END $func$;



INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_link', 'form_feature', 'tab_data', 'top_elev1', 'lyt_data_1', 36, 'integer', 'text', 'Top Elev 1', 'top_elev1', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_link', 'form_feature', 'tab_data', 'y1', 'lyt_data_1', 37, 'integer', 'text', 'Y1', 'y1', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_link', 'form_feature', 'tab_data', 'elevation1', 'lyt_data_1', 38, 'integer', 'text', 'Elevation1', 'elevation1', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_link', 'form_feature', 'tab_data', 'top_elev2', 'lyt_data_1', 39, 'integer', 'text', 'Top elev 2', 'top_elev2', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_link', 'form_feature', 'tab_data', 'y2', 'lyt_data_1', 40, 'integer', 'text', 'Y2', 'y2', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_link', 'form_feature', 'tab_data', 'elevation2', 'lyt_data_1', 41, 'integer', 'text', 'Elevation2', 'elevation2', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_link', 'form_feature', 'tab_data', 'omzone_id', 'lyt_data_1', 9, 'integer', 'combo', 'Omzone ID', 'Omzone ID', NULL, false, false, false, false, NULL, 'SELECT omzone_id as id, name as idval FROM omzone WHERE omzone_id = 0 UNION SELECT omzone_id as id, name as idval FROM omzone WHERE omzone_id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "v_edit_omzone", "activated": true, "keyColumn": "omzone_id", "valueColumn": "name", "filterExpression": null}}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_link', 'form_feature', 'tab_data', 'omzone_name', 'lyt_data_1', 19, 'string', 'text', 'omzone_name', 'omzone_name', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_link', 'form_feature', 'tab_data', 'macroomzone_id', 'lyt_data_1', 23, 'integer', 'text', 'Macroomzone ID', 'Macroomzone ID', NULL, false, false, false, false, NULL, 'SELECT macroomzone_id as id, name as idval FROM macroomzone WHERE macroomzone_id IS NOT NULL', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);

INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_edit_link', 'form_feature', 'tab_data', 'top_elev1', 'lyt_data_1', 36, 'integer', 'text', 'Top Elev 1', 'top_elev1', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_edit_link', 'form_feature', 'tab_data', 'y1', 'lyt_data_1', 37, 'integer', 'text', 'Y1', 'y1', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_edit_link', 'form_feature', 'tab_data', 'elevation1', 'lyt_data_1', 38, 'integer', 'text', 'Elevation1', 'elevation1', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_edit_link', 'form_feature', 'tab_data', 'top_elev2', 'lyt_data_1', 39, 'integer', 'text', 'Top elev 2', 'top_elev2', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_edit_link', 'form_feature', 'tab_data', 'y2', 'lyt_data_1', 40, 'integer', 'text', 'Y2', 'y2', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_edit_link', 'form_feature', 'tab_data', 'elevation2', 'lyt_data_1', 41, 'integer', 'text', 'Elevation2', 'elevation2', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_edit_link', 'form_feature', 'tab_data', 'omzone_id', 'lyt_data_1', 9, 'integer', 'combo', 'Omzone ID', 'Omzone ID', NULL, false, false, false, false, NULL, 'SELECT omzone_id as id, name as idval FROM omzone WHERE omzone_id = 0 UNION SELECT omzone_id as id, name as idval FROM omzone WHERE omzone_id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "v_edit_omzone", "activated": true, "keyColumn": "omzone_id", "valueColumn": "name", "filterExpression": null}}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_edit_link', 'form_feature', 'tab_data', 'omzone_name', 'lyt_data_1', 19, 'string', 'text', 'omzone_name', 'omzone_name', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_edit_link', 'form_feature', 'tab_data', 'macroomzone_id', 'lyt_data_1', 23, 'integer', 'text', 'Macroomzone ID', 'Macroomzone ID', NULL, false, false, false, false, NULL, 'SELECT macroomzone_id as id, name as idval FROM macroomzone WHERE macroomzone_id IS NOT NULL', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);


INSERT INTO man_conduitlink SELECT link_id FROM link;

--- WEIR: insert man table
INSERT INTO ve_frelem_eweir (elementcat_id, state, state_type, num_elements, expl_id, sector_id, muni_id, the_geom, epa_type, node_id, order_id, to_arc, flwreg_length )
SELECT 'EWEIR-01', state, state_type, 1, expl_id, sector_id, muni_id, the_geom, 'WEIR', n.node_id, order_id, to_arc::int4, flwreg_length
FROM _inp_frweir
JOIN node n ON n.node_id = _inp_frweir.node_id::int4;

--- WEIR: insert epa table
INSERT INTO inp_frweir
SELECT element_id, weir_type, offsetval, cd, ec, cd2, flap, geom1, geom2, geom3, geom4, surcharge, road_width, road_surf, coef_curve
FROM _inp_frweir w JOIN ve_frelem_eweir r ON w.node_id::int4=r.node_id AND w.to_arc::int4 = r.to_arc::int4 AND w.order_id = r.order_id;

--- PUMP: insert man table
INSERT INTO ve_frelem_epump (elementcat_id, state, state_type, num_elements, expl_id, sector_id, muni_id, the_geom, epa_type, node_id, order_id, to_arc, flwreg_length )
SELECT 'EPUMP-01', state, state_type, 1, expl_id, sector_id, muni_id, the_geom, 'PUMP', n.node_id, order_id, to_arc::int4, flwreg_length
FROM _inp_frpump
JOIN node n ON n.node_id = _inp_frpump.node_id::int4;

--- PUMP: insert epa table
INSERT INTO inp_frpump (element_id, curve_id, status, startup, shutoff)
SELECT element_id, curve_id, status, startup, shutoff
FROM _inp_frpump w JOIN ve_frelem_epump r ON w.node_id::int4=r.node_id AND w.to_arc::int4 = r.to_arc::int4 AND w.order_id = r.order_id;

--- ORIFICE: insert man table
INSERT INTO ve_frelem_eorifice (elementcat_id, state, state_type, num_elements, expl_id, sector_id, muni_id, the_geom, epa_type, node_id, order_id, to_arc, flwreg_length )
SELECT 'EORIFICE-01', state, state_type, 1, expl_id, sector_id, muni_id, the_geom, 'ORIFICE', n.node_id, order_id, to_arc::int4, flwreg_length
FROM _inp_frorifice
JOIN node n ON n.node_id = _inp_frorifice.node_id::int4;

--- ORIFICE: insert epa table
INSERT INTO inp_frorifice
SELECT element_id, ori_type, offsetval, cd, orate, flap, shape, geom1, geom2, geom3, geom4
FROM _inp_frorifice w JOIN ve_frelem_eorifice r ON w.node_id::int4=r.node_id AND w.to_arc::int4 = r.to_arc::int4 AND w.order_id = r.order_id;

--- OUTLET: insert man table
INSERT INTO ve_frelem_eoutlet (elementcat_id, state, state_type, num_elements, expl_id, sector_id, muni_id, the_geom, epa_type, node_id, order_id, to_arc, flwreg_length )
SELECT 'EOUTLET-01', state, state_type, 1, expl_id, sector_id, muni_id, the_geom, 'OUTLET', n.node_id, order_id, to_arc::int4, flwreg_length
FROM _inp_froutlet
JOIN node n ON n.node_id = _inp_froutlet.node_id::int4;

--- OUTLET: insert epa table
INSERT INTO inp_froutlet
SELECT element_id, outlet_type, offsetval, curve_id, cd1, cd2, flap
FROM _inp_froutlet w JOIN ve_frelem_eoutlet r ON w.node_id::int4=r.node_id AND w.to_arc::int4 = r.to_arc::int4 AND w.order_id = r.order_id;

INSERT INTO element_x_node
SELECT element_id, node_id FROM man_frelem;

UPDATE config_form_fields SET isparent = false WHERE formname = 'v_edit_inp_netgully' AND columnname = 'node_type';
UPDATE config_form_fields SET dv_querytext = 'SELECT id, id as idval FROM inp_hydrograph WHERE id IS NOT NULL ' WHERE formname = 'inp_rdii' AND columnname = 'hydro_id';
UPDATE config_form_fields SET dv_querytext = 'SELECT snow_id as id, snow_id as idval FROM inp_snowpack WHERE snow_id IS NOT NULL ' WHERE formname = 'inp_snowpack' AND columnname = 'snow_id';
UPDATE config_form_fields SET dv_querytext = 'SELECT DISTINCT (lidco_id) AS id,  lidco_id  AS idval FROM inp_lid WHERE lidco_id IS NOT NULL ' WHERE formname = 'v_edit_inp_lid_usage' AND columnname = 'lidco_id';

UPDATE cat_feature SET child_layer='ve_node_overflow_storage' WHERE id='OVERFLOW_STORAGE';

-- CONFIG_FORM_TABS
DELETE FROM config_form_tabs WHERE formname = 've_frelem' AND tabname = 'tab_none';
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device)
VALUES('ve_frelem', 'tab_data', 'Data', 'Data', 'role_basic', NULL, '[
  {"actionName": "actionEdit", "disabled": false}
]'::json, 0, '{4}');

INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device)
VALUES('ve_frelem', 'tab_epa', 'EPA', 'Epa', 'role_basic', NULL, '[
  {"actionName": "actionEdit", "disabled": false}
]'::json, 1, '{4}');

INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device)
VALUES('ve_frelem', 'tab_documents', 'Documents', 'List of documents', 'role_basic', NULL, '[
  {"actionName": "actionEdit", "disabled": false}
]'::json, 2, '{4}');

INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('ve_frelem', 'tab_features', 'Features', 'Manage features', 'role_basic', NULL, '[
  {"actionName": "actionEdit", "disabled": false}
]'::json, 3, '{4}');





-- tab documents
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('element', 'form_feature', 'tab_documents', 'date_from', 'lyt_document_1', 1, 'date', 'datetime', 'Date from:', 'Date from:', NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{"labelPosition": "top", "filterSign":">="}'::json, '{"functionName": "filter_table", "parameters":{"columnfind": "date"}}'::json, 'tbl_doc_x_element', false, 1);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('element', 'form_feature', 'tab_documents', 'date_to', 'lyt_document_1', 2, 'date', 'datetime', 'Date to:', 'Date to:', NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{"labelPosition": "top", "filterSign":"<="}'::json, '{"functionName": "filter_table", "parameters":{"columnfind": "date"}}'::json, 'tbl_doc_x_element', false, 2);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('element', 'form_feature', 'tab_documents', 'doc_type', 'lyt_document_1', 3, 'string', 'combo', 'Doc type:', 'Doc type:', NULL, false, false, true, false, true, 'SELECT id as id, idval as idval FROM edit_typevalue WHERE typevalue = ''doc_type''', NULL, true, NULL, NULL, NULL, '{"labelPosition": "top"}'::json, '{"functionName": "filter_table", "parameters":{}}'::json, 'tbl_doc_x_element', false, 3);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('element', 'form_feature', 'tab_documents', 'doc_name', 'lyt_document_2', 0, 'string', 'typeahead', 'Doc id:', 'Doc id:', NULL, false, false, true, false, false, 'SELECT name as id, name as idval FROM doc WHERE name IS NOT NULL', NULL, NULL, NULL, NULL, NULL, '{"saveValue": false, "filterSign":"ILIKE"}'::json, '{"functionName": "filter_table"}'::json, NULL, false, NULL);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('element', 'form_feature', 'tab_documents', 'btn_doc_insert', 'lyt_document_2', 2, NULL, 'button', '', 'Insert document', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"113"}'::json, '{"saveValue":false, "filterSign":"="}'::json, '{
  "functionName": "add_object",
  "parameters": {
    "sourcewidget": "tab_documents_doc_name",
    "targetwidget": "tab_documents_tbl_documents",
    "sourceview": "doc"
  }
}'::json, 'tbl_doc_x_element', false, NULL);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('element', 'form_feature', 'tab_documents', 'btn_doc_delete', 'lyt_document_2', 3, NULL, 'button', '', 'Delete document', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"114"}'::json, '{"saveValue":false, "filterSign":"=", "onContextMenu":"Delete document"}'::json, '{"functionName": "delete_object", "parameters": {"columnfind": "doc_id", "targetwidget": "tab_documents_tbl_documents", "sourceview": "doc"}}'::json, 'tbl_doc_x_element', false, NULL);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('element', 'form_feature', 'tab_documents', 'btn_doc_new', 'lyt_document_2', 4, NULL, 'button', '', 'New document', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"143"}'::json, '{"saveValue":false, "filterSign":"="}'::json, '{
  "functionName": "manage_document",
  "parameters": {
    "sourcewidget": "tab_documents_doc_name",
    "targetwidget": "tab_documents_tbl_documents",
    "sourceview": "doc"
  }
}'::json, 'tbl_doc_x_element', false, NULL);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('element', 'form_feature', 'tab_documents', 'hspacer_document_1', 'lyt_document_2', 10, NULL, 'hspacer', '', '', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('element', 'form_feature', 'tab_documents', 'open_doc', 'lyt_document_2', 11, NULL, 'button', '', 'Open document', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"147"}'::json, '{"saveValue":false, "filterSign":"=", "onContextMenu":"Open document"}'::json, '{
  "functionName": "open_selected_path",
  "parameters": {
    "columnfind": "path",
    "targetwidget": "tab_documents_tbl_documents",
    "sourceview": "doc"
  }
}'::json, 'tbl_doc_x_element', false, NULL);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('element', 'form_feature', 'tab_documents', 'tbl_documents', 'lyt_document_3', 1, NULL, 'tableview', '', '', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"saveValue": false}'::json, '{
  "functionName": "open_selected_path",
  "parameters": {
    "targetwidget": "tab_documents_tbl_documents",
    "columnfind": "path"
  }
}'::json, 'tbl_doc_x_element', false, 4);




-- node
DELETE FROM config_form_tableview WHERE objectname='tbl_element_x_node' AND columnname='sys_id';
DELETE FROM config_form_tableview WHERE objectname='tbl_element_x_node' AND columnname='id';

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


-- gully
DELETE FROM config_form_tableview WHERE objectname='tbl_element_x_gully' AND columnname='sys_id';
DELETE FROM config_form_tableview WHERE objectname='tbl_element_x_gully' AND columnname='id';

INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible,alias)
VALUES ('gully form','ud','tbl_element_x_gully','feature_class',4,true,'feature_class');
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible,alias)
VALUES ('gully form','ud','tbl_element_x_gully','element_type',5,true,'element_type');
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible,alias)
VALUES ('gully form','ud','tbl_element_x_gully','state_type',7,true,'state_type');
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible,alias)
VALUES ('gully form','ud','tbl_element_x_gully','location_type',13,true,'location_type');

UPDATE config_form_tableview SET columnindex=0,visible=false WHERE objectname='tbl_element_x_gully' AND columnname='gully_id';
UPDATE config_form_tableview SET columnindex=1 WHERE objectname='tbl_element_x_gully' AND columnname='element_id';
UPDATE config_form_tableview SET columnindex=2 WHERE objectname='tbl_element_x_gully' AND columnname='elementcat_id';
UPDATE config_form_tableview SET columnindex=3 WHERE objectname='tbl_element_x_gully' AND columnname='num_elements';
UPDATE config_form_tableview SET columnindex=8 WHERE objectname='tbl_element_x_gully' AND columnname='observ';
UPDATE config_form_tableview SET columnindex=9 WHERE objectname='tbl_element_x_gully' AND columnname='comment';
UPDATE config_form_tableview SET columnindex=10 WHERE objectname='tbl_element_x_gully' AND columnname='builtdate';
UPDATE config_form_tableview SET columnindex=11 WHERE objectname='tbl_element_x_gully' AND columnname='enddate';
UPDATE config_form_tableview SET columnindex=12 WHERE objectname='tbl_element_x_gully' AND columnname='descript';

UPDATE sys_table SET id='cat_gully', descript='Catalog of gullys.', sys_role='role_edit', context='{"level_1":"INVENTORY","level_2":"CATALOGS"}', orderby=10, alias='Gully catalog', notify_action=NULL, isaudit=NULL, keepauditdays=NULL, "source"='core', addparam=NULL WHERE id='cat_grate';


INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_ui_omzone', 'form_feature', 'tab_none', 'omzone_id', 'lyt_data_1', 1, 'integer', 'text', 'omzone_id', 'omzone_id', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"label":"color:red; font-weight:bold"}'::json, '{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "v_edit_omzone", "activated": true, "keyColumn": "omzone_id", "valueColumn": "name", "filterExpression": null}}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_ui_omzone', 'form_feature', 'tab_none', 'code', 'lyt_data_1', 2, 'string', 'text', 'code', 'code', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_ui_omzone', 'form_feature', 'tab_none', 'name', 'lyt_data_1', 3, 'string', 'text', 'name', 'name', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_ui_omzone', 'form_feature', 'tab_none', 'descript', 'lyt_data_1', 4, 'text', 'text', 'descript', 'descript', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_ui_omzone', 'form_feature', 'tab_none', 'omzone_type', 'lyt_data_1', 5, 'string', 'combo', 'omzone_type', 'omzone_type', NULL, false, false, true, false, NULL, 'SELECT id, idval FROM edit_typevalue WHERE typevalue=''sector_type''', true, true, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_ui_omzone', 'form_feature', 'tab_none', 'macroomzone', 'lyt_data_1', 6, 'string', 'combo', 'macroomzone_id', 'macroomzone_id', NULL, false, false, true, false, NULL, 'SELECT name as id, name as idval FROM macroomzone WHERE macroomzone_id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_ui_omzone', 'form_feature', 'tab_none', 'graphconfig', 'lyt_data_1', 7, 'string', 'text', 'graphconfig', 'graphconfig', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_ui_omzone', 'form_feature', 'tab_none', 'stylesheet', 'lyt_data_1', 8, 'string', 'text', 'stylesheet', 'stylesheet', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_ui_omzone', 'form_feature', 'tab_none', 'expl_id', 'lyt_data_2', 9, 'text', 'text', 'expl_id', 'expl_id', 'Ex: 1,2', false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"label":"color:red; font-weight:bold"}'::json, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_ui_omzone', 'form_feature', 'tab_none', 'link', 'lyt_data_3', 10, 'text', 'text', 'link', 'link', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_ui_omzone', 'form_feature', 'tab_none', 'undelete', 'lyt_data_1', 11, 'integer', 'combo', 'lock_level', 'lock_level', NULL, false, false, true, false, NULL, 'SELECT id, idval FROM edit_typevalue WHERE typevalue = ''value_lock_level'' AND id IS NOT NULL', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_ui_omzone', 'form_feature', 'tab_none', 'active', 'lyt_data_1', 12, 'boolean', 'check', 'active', 'active', NULL, false, false, true, false, false, NULL, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_ui_macroomzone', 'form_feature', 'tab_none', 'macroomzone_id', 'lyt_data_1', 1, 'integer', 'text', 'macroomzone_id', 'macroomzone_id', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false, "valueRelation":{"nullValue":true, "layer": "v_edit_macroomzone", "activated": true, "keyColumn": "macroomzone_id", "valueColumn": "name", "filterExpression": null}}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_ui_macroomzone', 'form_feature', 'tab_none', 'code', 'lyt_data_1', 2, 'string', 'text', 'code', 'code', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_ui_macroomzone', 'form_feature', 'tab_none', 'name', 'lyt_data_1', 3, 'string', 'text', 'name', 'name', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_ui_macroomzone', 'form_feature', 'tab_none', 'descript', 'lyt_data_1', 4, 'text', 'text', 'descript', 'descript', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_ui_macroomzone', 'form_feature', 'tab_none', 'expl_id', 'lyt_data_1', 5, 'text', 'text', 'expl_id', 'expl_id', 'Ex: 1,2', false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"label":"color:red; font-weight:bold"}'::json, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_ui_macroomzone', 'form_feature', 'tab_none', 'active', 'lyt_data_1', 6, 'boolean', 'check', 'active', 'active', NULL, false, false, true, false, false, NULL, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_ui_macroomzone', 'form_feature', 'tab_none', 'lock_level', 'lyt_data_1', 7, 'integer', 'combo', 'lock_level', 'lock_level', NULL, false, false, true, false, NULL, 'SELECT id, idval FROM edit_typevalue WHERE typevalue = ''value_lock_level'' AND id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);


-- TODO: revise if this is needed
-- INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam, except_level, except_msg, except_table, except_table_msg, query_text, info_msg, function_name, active)
-- VALUES(644, 'Gully which id is not an integer', 'ud', NULL, 'core', true, 'Check om-data', NULL, 3, 'gully which id is not an integer. Please, check your data before continue', NULL, NULL, 'SELECT CASE WHEN gully_id~E''^\\d+$'' THEN CAST (gully_id AS INTEGER)  ELSE 0 END  as feature_id, ''GULLY'' as type, gullycat_id, expl_id FROM t_gully', 'All gullies features with id integer.', '[gw_fct_om_check_data, gw_fct_admin_check_data]', true);

UPDATE config_form_fields SET widgetcontrols='{
  "setMultiline": false,
  "valueRelation": {
    "layer": "v_edit_exploitation",
    "activated": true,
    "keyColumn": "expl_id",
    "nullValue": false,
    "valueColumn": "name",
    "filterExpression": null
  }
}'::json WHERE formname IN ('v_edit_gully', 've_gully') AND formtype='form_feature' AND columnname='expl_id' AND tabname='tab_data';


UPDATE config_form_fields SET dv_querytext =  'SELECT id, resultdate AS idval FROM rpt_arc'
WHERE formname='generic' AND formtype='epa_selector' AND columnname='selector_date' AND tabname='tab_time';

UPDATE config_form_fields SET dv_querytext =  'SELECT id, resultdate AS idval FROM rpt_arc'
WHERE formname='generic' AND formtype='epa_selector' AND columnname='compare_date' AND tabname='tab_time';

UPDATE config_form_fields SET dv_querytext =  'SELECT id, resulttime AS idval FROM rpt_arc'
WHERE formname='generic' AND formtype='epa_selector' AND columnname='selector_time' AND tabname='tab_time';

UPDATE config_form_fields SET dv_querytext =  'SELECT id, resulttime AS idval FROM rpt_arc'
WHERE formname='generic' AND formtype='epa_selector' AND columnname='compare_time' AND tabname='tab_time';


UPDATE config_form_fields SET columnname = 'negative_offset' WHERE columnname = 'negativeoffset';

UPDATE config_csv SET descript='Function to assist the import of timeseries for inp models. The csv file must containts next columns on same position: timseries, timser_type, times_type, descript, expl_id, date, hour, time, value (fill date/hour for ABSOLUTE or time for RELATIVE)' WHERE fid=385;


INSERT INTO inp_subcatchment (subc_id, outlet_id, rg_id, area, imperv, width, slope, clength, snow_id, nimp, nperv, simp, sperv, zero, routeto, rted, maxrate, minrate, decay,
drytime, maxinfil, suction, conduct, initdef, curveno, conduct_2, drytime_2, sector_id, hydrology_id, the_geom, descript, nperv_pattern_id, dstore_pattern_id, infil_pattern_id,
minelev, muni_id)
SELECT subc_id, outlet_id::int4, rg_id, area, imperv, width, slope, clength, snow_id, nimp, nperv, simp, sperv, zero, routeto, rted, maxrate, minrate, decay,
drytime, maxinfil, suction, conduct, initdef, curveno, conduct_2, drytime_2, sector_id, hydrology_id, the_geom, descript, nperv_pattern_id, dstore_pattern_id, infil_pattern_id,
minelev, muni_id
FROM _inp_subcatchment;


DELETE FROM edit_typevalue WHERE typevalue IN('dwfzone_type', 'drainzone_type') AND id='UNDEFINED';

INSERT INTO edit_typevalue (typevalue, id, idval, descript, addparam) VALUES('value_dwf_drain_type', '0', 'UNDEFINED', NULL, NULL) ON CONFLICT DO NOTHING;
INSERT INTO edit_typevalue (typevalue, id, idval, descript, addparam) VALUES('value_dwf_drain_type', '1', 'TREATED', NULL, NULL) ON CONFLICT DO NOTHING;
INSERT INTO edit_typevalue (typevalue, id, idval, descript, addparam) VALUES('value_dwf_drain_type', '2', 'UNTREATED', NULL, NULL) ON CONFLICT DO NOTHING;
INSERT INTO edit_typevalue (typevalue, id, idval, descript, addparam) VALUES('value_dwf_drain_type', '3', 'MIXED', NULL, NULL) ON CONFLICT DO NOTHING;

INSERT INTO sys_foreignkey (typevalue_table, typevalue_name, target_table, target_field, parameter_id, active) VALUES('edit_typevalue', 'value_dwf_drain_type', 'dwfzone', 'dwfzone_type', NULL, true) ON CONFLICT DO NOTHING;
INSERT INTO sys_foreignkey (typevalue_table, typevalue_name, target_table, target_field, parameter_id, active) VALUES('edit_typevalue', 'value_dwf_drain_type', 'drainzone', 'drainzone_type', NULL, true) ON CONFLICT DO NOTHING;


INSERT INTO sys_table (id, descript, sys_role, project_template, context, orderby, alias, notify_action, isaudit, keepauditdays, "source", addparam) VALUES('v_edit_dwfzone', 'Shows editable information about dwfzone.', 'role_edit', '{"template": [1]}', '{"level_1":"INVENTORY","level_2":"MAP ZONES"}', 1, 'Dwfzone', NULL, NULL, NULL, 'core', NULL);

UPDATE sys_table SET project_template = '{"template": [1]}'
WHERE id IN (
	'v_edit_cat_feature_gully',
	'cat_gully',
	'v_edit_drainzone',
	'v_edit_gully',
	've_pol_gully'
);


INSERT INTO sys_table (id, descript, sys_role) VALUES ('arc_add', 'arc_add', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('archived_psector_arc_traceability', 'archived_psector_arc_traceability', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('archived_psector_connec_traceability', 'archived_psector_connec_traceability', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('archived_psector_gully_traceability', 'archived_psector_gully_traceability', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('archived_psector_link_traceability', 'archived_psector_link_traceability', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('archived_psector_node_traceability', 'archived_psector_node_traceability', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('archived_rpt_inp_arc', 'archived_rpt_inp_arc', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('archived_rpt_inp_node', 'archived_rpt_inp_node', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('archived_rpt_inp_raingage', 'archived_rpt_inp_raingage', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('archived_rpt_lidperformance_sum', 'archived_rpt_lidperformance_sum', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('archived_rpt_subcatchment', 'archived_rpt_subcatchment', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('archived_rpt_subcatchrunoff_sum', 'archived_rpt_subcatchrunoff_sum', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('archived_rpt_subcatchwashoff_sum', 'archived_rpt_subcatchwashoff_sum', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('cat_feature_element', 'cat_feature_element', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('cat_feature_link', 'cat_feature_link', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('cat_link', 'cat_link', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('config_form_help', 'config_form_help', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('doc_x_element', 'doc_x_element', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('doc_x_link', 'doc_x_link', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('dwfzone', 'dwfzone', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('element_x_link', 'element_x_link', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('ext_region_x_province', 'ext_region_x_province', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('inp_dscenario_frorifice', 'inp_dscenario_frorifice', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('inp_dscenario_froutlet', 'inp_dscenario_froutlet', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('inp_dscenario_frpump', 'inp_dscenario_frpump', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('inp_dscenario_frweir', 'inp_dscenario_frweir', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('inp_dscenario_lids', 'inp_dscenario_lids', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('inp_frorifice', 'inp_frorifice', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('inp_froutlet', 'inp_froutlet', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('inp_frpump', 'inp_frpump', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('inp_frweir', 'inp_frweir', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('macroomzone', 'macroomzone', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('man_frelem', 'man_frelem', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('man_genelem', 'man_genelem', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('man_conduitlink', 'man_conduitlink', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('minsector_mincut', 'minsector_mincut', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('node_add', 'node_add', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('om_visit_x_link', 'om_visit_x_link', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('omzone', 'omzone', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('sys_feature_class', 'sys_feature_class', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('v_edit_cat_dwf', 'v_edit_cat_dwf', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('v_edit_cat_feature_link', 'v_edit_cat_feature_link', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('v_edit_inp_dscenario_frorifice', 'v_edit_inp_dscenario_frorifice', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('v_edit_inp_dscenario_froutlet', 'v_edit_inp_dscenario_froutlet', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('v_edit_inp_dscenario_frpump', 'v_edit_inp_dscenario_frpump', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('v_edit_inp_dscenario_frweir', 'v_edit_inp_dscenario_frweir', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('v_edit_inp_dscenario_lids', 'v_edit_inp_dscenario_lids', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('v_edit_inp_frorifice', 'v_edit_inp_frorifice', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('v_edit_inp_froutlet', 'v_edit_inp_froutlet', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('v_edit_inp_frpump', 'v_edit_inp_frpump', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('v_edit_inp_frweir', 'v_edit_inp_frweir', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('v_edit_macroomzone', 'v_edit_macroomzone', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('v_edit_omzone', 'v_edit_omzone', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('v_rpt_arc', 'v_rpt_arc', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('v_rpt_node', 'v_rpt_node', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('v_ui_doc_x_element', 'v_ui_doc_x_element', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('v_ui_doc_x_link', 'v_ui_doc_x_link', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('v_ui_dwfzone', 'v_ui_dwfzone', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('v_ui_element_x_link', 'v_ui_element_x_link', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('v_ui_macroomzone', 'v_ui_macroomzone', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('v_ui_macrosector', 'v_ui_macrosector', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('v_ui_om_visit_x_link', 'v_ui_om_visit_x_link', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('v_ui_omzone', 'v_ui_omzone', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('v_ui_sector', 'v_ui_sector', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('v_ui_sys_style', 'v_ui_sys_style', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('ve_epa_frorifice', 've_epa_frorifice', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('ve_epa_froutlet', 've_epa_froutlet', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('ve_epa_frpump', 've_epa_frpump', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('ve_epa_frweir', 've_epa_frweir', 'role_edit');
INSERT INTO sys_table (id, descript, sys_role, context, alias, orderby, "source") VALUES('ve_genelem', 'Specific view for general elements', 'role_basic', '{"level_1":"INVENTORY","level_2":"NETWORK","level_3":"ELEMENT"}', 'General elements', 1, 'core');
INSERT INTO sys_table (id, descript, sys_role) VALUES ('ve_visit_gully_singlevent', 've_visit_gully_singlevent', 'role_edit');

DELETE FROM sys_table WHERE id = 'audit_psector_arc_traceability';
DELETE FROM sys_table WHERE id = 'audit_psector_connec_traceability';
DELETE FROM sys_table WHERE id = 'audit_psector_gully_traceability';
DELETE FROM sys_table WHERE id = 'audit_psector_node_traceability';
DELETE FROM sys_table WHERE id = 'dma';
DELETE FROM sys_table WHERE id = 'doc_type';
DELETE FROM sys_table WHERE id = 'ext_rtc_dma_period';
DELETE FROM sys_table WHERE id = 'inp_backdrop';
DELETE FROM sys_table WHERE id = 'inp_dscenario_flwreg_orifice';
DELETE FROM sys_table WHERE id = 'inp_dscenario_flwreg_outlet';
DELETE FROM sys_table WHERE id = 'inp_dscenario_flwreg_pump';
DELETE FROM sys_table WHERE id = 'inp_dscenario_flwreg_weir';
DELETE FROM sys_table WHERE id = 'inp_dscenario_lid_usage';
DELETE FROM sys_table WHERE id = 'inp_flwreg_orifice';
DELETE FROM sys_table WHERE id = 'inp_flwreg_outlet';
DELETE FROM sys_table WHERE id = 'inp_flwreg_pump';
DELETE FROM sys_table WHERE id = 'inp_flwreg_weir';
DELETE FROM sys_table WHERE id = 'macrodma';
DELETE FROM sys_table WHERE id = 'man_type_fluid';
DELETE FROM sys_table WHERE id = 'om_reh_cat_works';
DELETE FROM sys_table WHERE id = 'om_reh_parameter_x_works';
DELETE FROM sys_table WHERE id = 'om_reh_value_loc_condition';
DELETE FROM sys_table WHERE id = 'om_reh_works_x_pcompost';
DELETE FROM sys_table WHERE id = 'rtc_scada_x_dma';
DELETE FROM sys_table WHERE id = 'rtc_scada_x_sector';
DELETE FROM sys_table WHERE id = 'sys_feature_cat';
DELETE FROM sys_table WHERE id = 'test';
DELETE FROM sys_table WHERE id = 'v_arc';
DELETE FROM sys_table WHERE id = 'v_connec';
DELETE FROM sys_table WHERE id = 'v_edit_cat_dwf_scenario';
DELETE FROM sys_table WHERE id = 'v_edit_dma';
DELETE FROM sys_table WHERE id = 'v_edit_element';
DELETE FROM sys_table WHERE id = 'v_edit_inp_dscenario_flwreg_orifice';
DELETE FROM sys_table WHERE id = 'v_edit_inp_dscenario_flwreg_outlet';
DELETE FROM sys_table WHERE id = 'v_edit_inp_dscenario_flwreg_pump';
DELETE FROM sys_table WHERE id = 'v_edit_inp_dscenario_flwreg_weir';
DELETE FROM sys_table WHERE id = 'v_edit_inp_dscenario_lid_usage';
DELETE FROM sys_table WHERE id = 'v_edit_inp_flwreg_orifice';
DELETE FROM sys_table WHERE id = 'v_edit_inp_flwreg_outlet';
DELETE FROM sys_table WHERE id = 'v_edit_inp_flwreg_pump';
DELETE FROM sys_table WHERE id = 'v_edit_inp_flwreg_weir';
DELETE FROM sys_table WHERE id = 'v_edit_macrodma';
DELETE FROM sys_table WHERE id = 'v_edit_plan_psector_x_connec';
DELETE FROM sys_table WHERE id = 'v_edit_plan_psector_x_gully';
DELETE FROM sys_table WHERE id = 'v_edit_review_audit_node';
DELETE FROM sys_table WHERE id = 'v_gully';
DELETE FROM sys_table WHERE id = 'v_link';
DELETE FROM sys_table WHERE id = 'v_link_connec';
DELETE FROM sys_table WHERE id = 'v_link_gully';
DELETE FROM sys_table WHERE id = 'v_node';
DELETE FROM sys_table WHERE id = 'v_price_x_arc';
DELETE FROM sys_table WHERE id = 'v_rpt_arc_all';
DELETE FROM sys_table WHERE id = 'v_rpt_comp_lidperformance_sum';
DELETE FROM sys_table WHERE id = 'v_rpt_comp_subcatchrunoff_sum';
DELETE FROM sys_table WHERE id = 'v_rpt_comp_subcatchwashoff_sum';
DELETE FROM sys_table WHERE id = 'v_rpt_lidperformance_sum';
DELETE FROM sys_table WHERE id = 'v_rpt_node_all';
DELETE FROM sys_table WHERE id = 'v_rpt_subcatchrunoff_sum';
DELETE FROM sys_table WHERE id = 'v_rpt_subcatchwashoff_sum';
DELETE FROM sys_table WHERE id = 'v_rtc_period_dma';
DELETE FROM sys_table WHERE id = 'v_rtc_period_hydrometer';
DELETE FROM sys_table WHERE id = 'v_rtc_period_node';
DELETE FROM sys_table WHERE id = 'v_rtc_period_pjoint';
DELETE FROM sys_table WHERE id = 'v_state_gully';
DELETE FROM sys_table WHERE id = 'v_state_link_connec';
DELETE FROM sys_table WHERE id = 'v_state_link_gully';
DELETE FROM sys_table WHERE id = 'v_ui_om_visitman_x_connec';
DELETE FROM sys_table WHERE id = 'vcv_dma';
DELETE FROM sys_table WHERE id = 've_arc';
DELETE FROM sys_table WHERE id = 've_connec';
DELETE FROM sys_table WHERE id = 've_gully';
DELETE FROM sys_table WHERE id = 've_node';
DELETE FROM sys_table WHERE id = 'vi_adjustments';
DELETE FROM sys_table WHERE id = 'vi_aquifers';
DELETE FROM sys_table WHERE id = 'vi_backdrop';
DELETE FROM sys_table WHERE id = 'vi_buildup';
DELETE FROM sys_table WHERE id = 'vi_conduits';
DELETE FROM sys_table WHERE id = 'vi_controls';
DELETE FROM sys_table WHERE id = 'vi_coordinates';
DELETE FROM sys_table WHERE id = 'vi_coverages';
DELETE FROM sys_table WHERE id = 'vi_curves';
DELETE FROM sys_table WHERE id = 'vi_dividers';
DELETE FROM sys_table WHERE id = 'vi_dwf';
DELETE FROM sys_table WHERE id = 'vi_evaporation';
DELETE FROM sys_table WHERE id = 'vi_files';
DELETE FROM sys_table WHERE id = 'vi_groundwater';
DELETE FROM sys_table WHERE id = 'vi_gully';
DELETE FROM sys_table WHERE id = 'vi_gully2node';
DELETE FROM sys_table WHERE id = 'vi_gwf';
DELETE FROM sys_table WHERE id = 'vi_hydrographs';
DELETE FROM sys_table WHERE id = 'vi_infiltration';
DELETE FROM sys_table WHERE id = 'vi_inflows';
DELETE FROM sys_table WHERE id = 'vi_junctions';
DELETE FROM sys_table WHERE id = 'vi_labels';
DELETE FROM sys_table WHERE id = 'vi_landuses';
DELETE FROM sys_table WHERE id = 'vi_lid_controls';
DELETE FROM sys_table WHERE id = 'vi_lid_usage';
DELETE FROM sys_table WHERE id = 'vi_loadings';
DELETE FROM sys_table WHERE id = 'vi_losses';
DELETE FROM sys_table WHERE id = 'vi_map';
DELETE FROM sys_table WHERE id = 'vi_options';
DELETE FROM sys_table WHERE id = 'vi_orifices';
DELETE FROM sys_table WHERE id = 'vi_outfalls';
DELETE FROM sys_table WHERE id = 'vi_outlets';
DELETE FROM sys_table WHERE id = 'vi_patterns';
DELETE FROM sys_table WHERE id = 'vi_polygons';
DELETE FROM sys_table WHERE id = 'vi_pumps';
DELETE FROM sys_table WHERE id = 'vi_raingages';
DELETE FROM sys_table WHERE id = 'vi_rdii';
DELETE FROM sys_table WHERE id = 'vi_report';
DELETE FROM sys_table WHERE id = 'vi_snowpacks';
DELETE FROM sys_table WHERE id = 'vi_storage';
DELETE FROM sys_table WHERE id = 'vi_subareas';
DELETE FROM sys_table WHERE id = 'vi_subcatchcentroid';
DELETE FROM sys_table WHERE id = 'vi_subcatchments';
DELETE FROM sys_table WHERE id = 'vi_symbols';
DELETE FROM sys_table WHERE id = 'vi_temperature';
DELETE FROM sys_table WHERE id = 'vi_timeseries';
DELETE FROM sys_table WHERE id = 'vi_transects';
DELETE FROM sys_table WHERE id = 'vi_treatment';
DELETE FROM sys_table WHERE id = 'vi_vertices';
DELETE FROM sys_table WHERE id = 'vi_washoff';
DELETE FROM sys_table WHERE id = 'vi_weirs';
DELETE FROM sys_table WHERE id = 'vi_xsections';
DELETE FROM sys_table WHERE id = 'vu_arc';
DELETE FROM sys_table WHERE id = 'vu_connec';
DELETE FROM sys_table WHERE id = 'vu_exploitation';
DELETE FROM sys_table WHERE id = 'vu_ext_municipality';
DELETE FROM sys_table WHERE id = 'vu_gully';
DELETE FROM sys_table WHERE id = 'vu_link';
DELETE FROM sys_table WHERE id = 'vu_link_connec';
DELETE FROM sys_table WHERE id = 'vu_link_gully';
DELETE FROM sys_table WHERE id = 'vu_macroexploitation';
DELETE FROM sys_table WHERE id = 'vu_macrosector';
DELETE FROM sys_table WHERE id = 'vu_node';
DELETE FROM sys_table WHERE id = 'vu_om_mincut';

UPDATE sys_table SET addparam='{
  "pkey": "element_id"
}'::json WHERE id='ve_frelem_eweir';
UPDATE sys_table SET addparam='{
  "pkey": "element_id"
}'::json WHERE id='ve_frelem_epump';
UPDATE sys_table SET addparam='{
  "pkey": "element_id"
}'::json WHERE id='ve_frelem_eoutlet';
UPDATE sys_table SET addparam='{
  "pkey": "element_id"
}'::json WHERE id='ve_frelem_eorifice';
UPDATE sys_table SET addparam='{
  "pkey": "element_id"
}'::json WHERE id='ve_frelem';


UPDATE config_param_system SET value='{"DRAINZONE":{"mode":"Random", "column":"name"},"SECTOR":{"mode":"Random", "column":"name"},"DMA":{"mode":"Random", "column":"name"}, "DWFZONE" :{"mode":"Random", "column":"name"}}'
WHERE "parameter"='utils_graphanalytics_style';

UPDATE config_toolbox SET inputparams='[{"widgetname":"graphClass", "label":"Graph class:", "widgettype":"combo","datatype":"text","tooltip": "Graphanalytics method used", "layoutname":"grl_option_parameters","layoutorder":1,"comboIds":["DWFZONE","MACROSECTOR","SECTOR"],
"comboNames":["Drainage area (DWFZONE + DRAINZONE)","(MACROSECTOR)","(SECTOR)"], "selectedId":""},{"widgetname":"exploitation", "label":"Exploitation:","widgettype":"combo","datatype":"text","tooltip": "Choose exploitation to work with", "layoutname":"grl_option_parameters","layoutorder":2, "dvQueryText":"SELECT id, idval FROM ( SELECT -901 AS id, ''User selected expl'' AS idval, ''a'' AS sort_order UNION SELECT -902 AS id, ''All exploitations'' AS idval, ''b'' AS sort_order UNION SELECT expl_id AS id, name AS idval, ''c'' AS sort_order FROM exploitation WHERE active IS NOT FALSE ) a ORDER BY sort_order ASC, idval ASC", "selectedId":""}, {"widgetname":"floodOnlyMapzone", "label":"Flood only one mapzone: (*)","widgettype":"linetext","datatype":"text", "isMandatory":false, "tooltip":"Flood only identified mapzones. The purpose of this is update only network elements affected by this flooding keeping rest of network as is. Recommended to gain performance when mapzones ecosystem is under work", "placeholder":"1001", "layoutname":"grl_option_parameters","layoutorder":3, "value":""}, {"widgetname":"forceOpen", "label":"Force open nodes: (*)","widgettype":"linetext","datatype":"text", "isMandatory":false, "tooltip":"Optative node id(s) to temporary open closed node(s) in order to force algorithm to continue there", "placeholder":"1015,2231,3123", "layoutname":"grl_option_parameters","layoutorder":5, "value":""}, {"widgetname":"forceClosed", "label":"Force closed nodes: (*)","widgettype":"text","datatype":"text", "isMandatory":false, "tooltip":"Optative node id(s) to temporary close open node(s) to force algorithm to stop there","placeholder":"1015,2231,3123", "layoutname":"grl_option_parameters","layoutorder":6,"value":""}, {"widgetname":"usePlanPsector", "label":"Use selected psectors:", "widgettype":"check","datatype":"boolean","tooltip":"If true, use selected psectors. If false ignore selected psectors and only works with on-service network" , "layoutname":"grl_option_parameters","layoutorder":7,"value":""}, {"widgetname":"commitChanges", "label":"Commit changes:", "widgettype":"check","datatype":"boolean","tooltip":"If true, changes will be applied to DB. If false, algorithm results will be saved in anl tables" , "layoutname":"grl_option_parameters","layoutorder":8,"value":""}, {"widgetname":"valueForDisconnected", "label":"Value for disconn. and conflict: (*)","widgettype":"linetext","datatype":"text", "isMandatory":false, "tooltip":"Value to use for disconnected features. Usefull for work in progress with dynamic mpzonesnode" , "placeholder":"", "layoutname":"grl_option_parameters","layoutorder":9, "value":""}, {"widgetname":"updateMapZone", "label":"Mapzone constructor method:","widgettype":"combo","datatype":"integer","layoutname":"grl_option_parameters","layoutorder":10,"comboIds":[0,1,2,6], "comboNames":["NONE", "CONCAVE POLYGON", "PIPE BUFFER", "PLOT + PIPE BUFFER", "LINK + PIPE BUFFER", "EPA SUBCATCH"], "selectedId":""}, {"widgetname":"geomParamUpdate", "label":"Pipe buffer","widgettype":"text","datatype":"float","tooltip":"Buffer from arcs to create mapzone geometry using [PIPE BUFFER] options. Normal values maybe between 3-20 mts.", "layoutname":"grl_option_parameters","layoutorder":11, "isMandatory":false, "placeholder":"5-30", "value":""}]'::json WHERE id=2768;


INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source", function_alias)
VALUES(3424, 'gw_fct_graphanalytics_fluid_type', 'ud', 'function', 'json', 'json',
'Function to generate fluid_type of your arcs and nodes. Stop your mouse over labels for more information about input parameters.', 'role_plan', NULL, 'core', NULL);

INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam, except_level, except_msg, except_table, except_table_msg, query_text, info_msg, function_name, active)
VALUES(637, 'Fluid type calculation	', 'ud	', NULL, 'core', true, 'Function process', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, true);

INSERT INTO config_toolbox (id, alias, functionparams, inputparams, observ, active, device)
VALUES(3424, 'Fluid type analysis', '{"featureType":[]}'::json, '[
{
  "label": "Process name:", 
  "value": null, 
  "tooltip": "Process name", 
  "comboIds": ["FLUIDTYPE"], 
  "datatype": "text", 
  "comboNames": ["Fluid type"], 
  "layoutname": "grl_option_parameters", 
  "selectedId": null,
  "widgetname": "processName", 
  "widgettype": "combo", 
  "layoutorder": 1
}, 
{
  "label": "Exploitation:", 
  "value": null, 
  "tooltip": "Choose exploitation to work with", 
  "datatype": "text", 
  "layoutname": "grl_option_parameters", 
  "selectedId": null, 
  "widgetname": "exploitation", 
  "widgettype": "combo", 
  "dvQueryText": "SELECT id, idval FROM ( SELECT -901 AS id, ''User selected expl'' AS idval, ''a'' AS sort_order UNION SELECT -902 AS id, ''All exploitations'' AS idval, ''b'' AS sort_order UNION SELECT expl_id AS id, name AS idval, ''c'' AS sort_order FROM exploitation WHERE active IS NOT FALSE ) a ORDER BY sort_order ASC, idval ASC", 
  "layoutorder": 2
}, 
{
  "label": "Use selected psectors:", 
  "value": null, 
  "tooltip": "If true, use selected psectors. If false ignore selected psectors and only works with on-service network", 
  "datatype": "boolean",
  "layoutname": "grl_option_parameters", 
  "selectedId": null, 
  "widgetname": "usePlanPsector", 
  "widgettype": "check", 
  "layoutorder": 3}, 
{
  "label": "Commit changes:", 
  "value": null, 
  "tooltip": "If true, changes will be applied to DB. If false, algorithm results will be saved in anl tables", 
  "datatype": "boolean", "layoutname": "grl_option_parameters", 
  "selectedId": null, 
  "widgetname": "commitChanges", 
  "widgettype": "check", 
  "layoutorder": 4}
]'::json, NULL, true, '{4}');

UPDATE config_form_tableview SET visible=true WHERE objectname='tbl_element_x_gully' AND columnname='gully_id';


INSERT INTO cat_element (id, element_type, matcat_id, geometry, descript, link, brand, "type", model, svg, active, geom1, geom2, isdoublegeom) VALUES('GATE-01', 'EGATE', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, true, NULL, NULL, NULL);

-- CONFIG_FORM_FIELDS

-- ve_genelem_egate
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES
('ve_genelem_egate', 'form_feature', 'tab_data', 'elementcat_id', 'lyt_top_1', 0, 'string', 'combo', 'Element Catalog', 'Element Catalog', NULL, true, false, true, false, NULL, 'SELECT id, id as idval FROM cat_element WHERE element_type = ''EGATE''', true, false, NULL, NULL, NULL, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_genelem_egate', 'form_feature', 'tab_data', 'expl_id', 'lyt_bot_1', 0, 'integer', 'combo', 'Exploitation ID', 'Exploitation ID', NULL, false, false, true, false, NULL, 'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL', true, false, NULL, NULL, '{"label":"color:red; font-weight:bold"}'::json, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_genelem_egate', 'form_feature', 'tab_data', 'sector_id', 'lyt_bot_1', 1, 'integer', 'combo', 'Sector ID', 'Sector ID', NULL, false, false, true, false, NULL, 'SELECT sector_id as id, name as idval FROM sector WHERE sector_id IS NOT NULL', true, false, NULL, NULL, '{"label":"color:red; font-weight:bold"}'::json, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_genelem_egate', 'form_feature', 'tab_data', 'state_type', 'lyt_bot_1', 4, 'integer', 'combo', 'State Type', 'State Type', NULL, false, false, true, false, NULL, 'SELECT id, name as idval FROM value_state_type WHERE id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_genelem_egate', 'form_feature', 'tab_data', 'state', 'lyt_bot_1', 3, 'integer', 'combo', 'State', 'State', NULL, false, false, true, false, NULL, 'SELECT id, name as idval FROM value_state WHERE id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_genelem_egate', 'form_feature', 'tab_data', 'workcat_id_end', 'lyt_data_1', 14, 'string', 'typeahead', 'Workcat ID End', 'Workcat ID End', 'Only when state is obsolete', false, false, true, false, NULL, 'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_genelem_egate', 'form_feature', 'tab_data', 'category_type', 'lyt_data_1', 10, 'string', 'combo', 'Category Type', 'Category Type', NULL, false, false, true, false, NULL, 'SELECT category_type as id, category_type as idval FROM man_type_category WHERE feature_type = ''ELEMENT'' OR ''EORIFICE'' = ANY(featurecat_id::text[])', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_genelem_egate', 'form_feature', 'tab_data', 'function_type', 'lyt_data_1', 9, 'string', 'combo', 'Function Type', 'Function Type', NULL, false, false, true, false, NULL, 'SELECT function_type as id, function_type as idval FROM man_type_function WHERE feature_type = ''ELEMENT'' OR ''EORIFICE'' = ANY(featurecat_id::text[])', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_genelem_egate', 'form_feature', 'tab_data', 'num_elements', 'lyt_data_1', 6, 'integer', 'text', 'Number of Elements', 'Number of Elements', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_genelem_egate', 'form_feature', 'tab_data', 'code', 'lyt_data_1', 2, 'string', 'text', 'Code', 'Code', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_genelem_egate', 'form_feature', 'tab_data', 'builtdate', 'lyt_data_1', 15, 'date', 'datetime', 'Built Date', 'Built Date', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_genelem_egate', 'form_feature', 'tab_data', 'workcat_id', 'lyt_data_1', 13, 'string', 'typeahead', 'Workcat ID', 'Workcat ID', NULL, false, false, true, false, NULL, 'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'action_workcat', false, NULL),
('ve_genelem_egate', 'form_feature', 'tab_data', 'comment', 'lyt_data_1', 8, 'string', 'text', 'Comments', 'Comments', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":true}'::json, NULL, NULL, true, NULL),
('ve_genelem_egate', 'form_feature', 'tab_data', 'top_elev', 'lyt_data_1', 21, 'double', 'text', 'Top Elevation', 'Top Elevation', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_genelem_egate', 'form_feature', 'tab_data', 'rotation', 'lyt_data_1', 18, 'double', 'text', 'Rotation', 'Rotation', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_genelem_egate', 'form_feature', 'tab_data', 'ownercat_id', 'lyt_data_1', 17, 'string', 'combo', 'Owner Catalog', 'Owner Catalog', NULL, false, false, true, false, NULL, 'SELECT id, id as idval FROM cat_owner WHERE id IS NOT NULL AND active IS TRUE', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_genelem_egate', 'form_feature', 'tab_data', 'enddate', 'lyt_data_1', 16, 'date', 'datetime', 'End Date', 'End Date', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_genelem_egate', 'form_feature', 'tab_data', 'location_type', 'lyt_data_1', 11, 'string', 'combo', 'Location Type', 'Location Type', NULL, false, false, true, false, NULL, 'SELECT location_type as id, location_type as idval FROM man_type_location WHERE feature_type = ''ELEMENT'' OR ''EORIFICE'' = ANY(featurecat_id::text[])', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_genelem_egate', 'form_feature', 'tab_data', 'muni_id', 'lyt_data_3', 1, 'string', 'combo', 'Municipality id:', 'muni_id - Identifier of the municipality', NULL, false, false, true, NULL, NULL, 'SELECT muni_id as id, name as idval from v_ext_municipality WHERE muni_id IS NOT NULL', true, false, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL),
('ve_genelem_egate', 'form_feature', 'tab_data', 'observ', 'lyt_data_3', 0, 'string', 'text', 'Observations', 'Observations', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":true}'::json, NULL, NULL, false, NULL),
('ve_genelem_egate', 'form_feature', 'tab_data', 'element_id', 'lyt_top_1', 1, 'string', 'text', 'Element ID', 'Element ID', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_genelem_egate', 'form_feature', 'tab_data', 'epa_type', 'lyt_top_1', 2, 'string', 'combo', 'EPA Type', 'EPA Type', NULL, false, false, true, false, NULL, 'SELECT id, id as idval FROM sys_feature_epa_type WHERE active AND feature_type = ''ELEMENT''', NULL, NULL, NULL, NULL, NULL, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_genelem_egate', 'form_feature', 'tab_features', 'btn_delete', 'lyt_features_1', 2, NULL, 'button', NULL, NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{
  "icon": "112"
}'::json, '{
  "saveValue": false
}'::json,
'{
  "functionName": "delete_object",
  "parameters": {
    "columnfind": "element_id",
    "targetwidget": "tab_features_tbl_element",
    "sourceview": "element"
  }
}'::json, NULL, false, NULL),
('ve_genelem_egate', 'form_feature', 'tab_features', 'btn_expr_select', 'lyt_features_1', 4, NULL, 'button', NULL, NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{
  "icon": "178"
}'::json, '{
  "saveValue": false
}'::json, NULL, NULL, false, NULL),
('ve_genelem_egate', 'form_feature', 'tab_features', 'feature_id', 'lyt_features_1', 0, 'text', 'text', NULL, NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL),
('ve_genelem_egate', 'form_feature', 'tab_features', 'btn_snapping', 'lyt_features_1', 3, NULL, 'button', NULL, NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{
  "icon": "137"
}'::json, '{
  "saveValue": false
}'::json, '{
  "functionName": "selection_init"
}'::json, NULL, false, NULL),
('ve_genelem_egate', 'form_feature', 'tab_features', 'tbl_element_x_arc', 'lyt_features_2_arc', 0, NULL, 'tableview', '', '', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_arc",
  "featureType": "arc"
}'::json, NULL, 'tbl_element_x_arc', false, NULL),
('ve_genelem_egate', 'form_feature', 'tab_features', 'tbl_element_x_connec', 'lyt_features_2_connec', 0, NULL, 'tableview', '', '', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_connec",
  "featureType": "connec"
}'::json, NULL, 'tbl_element_x_connec', false, NULL),
('ve_genelem_egate', 'form_feature', 'tab_features', 'tbl_element_x_gully', 'lyt_features_2_gully', 0, NULL, 'tableview', '', '', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_gully",
  "featureType": "gully"
}'::json, NULL, 'tbl_element_x_gully', false, NULL),
('ve_genelem_egate', 'form_feature', 'tab_features', 'tbl_element_x_link', 'lyt_features_2_link', 0, NULL, 'tableview', '', '', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_link",
  "featureType": "link"
}'::json, NULL, 'tbl_element_x_link', false, NULL),
('ve_genelem_egate', 'form_feature', 'tab_features', 'tbl_element_x_node', 'lyt_features_2_node', 0, NULL, 'tableview', '', '', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_node",
  "featureType": "node"
}'::json, NULL, 'tbl_element_x_node', false, NULL),
('ve_genelem_egate', 'form_feature', 'tab_features', 'btn_insert', 'lyt_features_1', 1, NULL, 'button', NULL, NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{
  "icon": "111"
}'::json, '{
  "saveValue": false
}'::json,
'{
  "functionName": "insert_feature",
  "parameters": {
    "targetwidget": "tab_features_feature_id"
  }
}'::json, NULL, false, NULL)
ON CONFLICT (formname, formtype, tabname, columnname) DO UPDATE SET
  layoutname = EXCLUDED.layoutname,
  layoutorder = EXCLUDED.layoutorder,
  datatype = EXCLUDED.datatype,
  widgettype = EXCLUDED.widgettype,
  label = EXCLUDED.label,
  tooltip = EXCLUDED.tooltip,
  placeholder = EXCLUDED.placeholder,
  ismandatory = EXCLUDED.ismandatory,
  isparent = EXCLUDED.isparent,
  iseditable = EXCLUDED.iseditable,
  isautoupdate = EXCLUDED.isautoupdate,
  isfilter = EXCLUDED.isfilter,
  dv_querytext = EXCLUDED.dv_querytext,
  dv_orderby_id = EXCLUDED.dv_orderby_id,
  dv_isnullvalue = EXCLUDED.dv_isnullvalue,
  dv_parent_id = EXCLUDED.dv_parent_id,
  stylesheet = EXCLUDED.stylesheet,
  widgetcontrols = EXCLUDED.widgetcontrols,
  widgetfunction = EXCLUDED.widgetfunction,
  linkedobject = EXCLUDED.linkedobject,
  hidden = EXCLUDED.hidden,
  web_layoutorder = EXCLUDED.web_layoutorder;


-- ve_genelem_eiot_sensor
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES
('ve_genelem_eiot_sensor', 'form_feature', 'tab_data', 'top_elev', 'lyt_data_1', 21, 'double', 'text', 'Top Elevation', 'Top Elevation', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_genelem_eiot_sensor', 'form_feature', 'tab_data', 'expl_id', 'lyt_bot_1', 0, 'integer', 'combo', 'Exploitation ID', 'Exploitation ID', NULL, false, false, true, false, NULL, 'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL', true, false, NULL, NULL, '{"label":"color:red; font-weight:bold"}'::json, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_genelem_eiot_sensor', 'form_feature', 'tab_data', 'sector_id', 'lyt_bot_1', 1, 'integer', 'combo', 'Sector ID', 'Sector ID', NULL, false, false, true, false, NULL, 'SELECT sector_id as id, name as idval FROM sector WHERE sector_id IS NOT NULL', true, false, NULL, NULL, '{"label":"color:red; font-weight:bold"}'::json, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_genelem_eiot_sensor', 'form_feature', 'tab_data', 'state_type', 'lyt_bot_1', 4, 'integer', 'combo', 'State Type', 'State Type', NULL, false, false, true, false, NULL, 'SELECT id, name as idval FROM value_state_type WHERE id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_genelem_eiot_sensor', 'form_feature', 'tab_data', 'state', 'lyt_bot_1', 3, 'integer', 'combo', 'State', 'State', NULL, false, false, true, false, NULL, 'SELECT id, name as idval FROM value_state WHERE id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_genelem_eiot_sensor', 'form_feature', 'tab_data', 'workcat_id_end', 'lyt_data_1', 14, 'string', 'typeahead', 'Workcat ID End', 'Workcat ID End', 'Only when state is obsolete', false, false, true, false, NULL, 'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_genelem_eiot_sensor', 'form_feature', 'tab_data', 'category_type', 'lyt_data_1', 10, 'string', 'combo', 'Category Type', 'Category Type', NULL, false, false, true, false, NULL, 'SELECT category_type as id, category_type as idval FROM man_type_category WHERE feature_type = ''ELEMENT'' OR ''EORIFICE'' = ANY(featurecat_id::text[])', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_genelem_eiot_sensor', 'form_feature', 'tab_data', 'function_type', 'lyt_data_1', 9, 'string', 'combo', 'Function Type', 'Function Type', NULL, false, false, true, false, NULL, 'SELECT function_type as id, function_type as idval FROM man_type_function WHERE feature_type = ''ELEMENT'' OR ''EORIFICE'' = ANY(featurecat_id::text[])', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_genelem_eiot_sensor', 'form_feature', 'tab_data', 'num_elements', 'lyt_data_1', 6, 'integer', 'text', 'Number of Elements', 'Number of Elements', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_genelem_eiot_sensor', 'form_feature', 'tab_data', 'code', 'lyt_data_1', 2, 'string', 'text', 'Code', 'Code', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_genelem_eiot_sensor', 'form_feature', 'tab_data', 'builtdate', 'lyt_data_1', 15, 'date', 'datetime', 'Built Date', 'Built Date', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_genelem_eiot_sensor', 'form_feature', 'tab_data', 'workcat_id', 'lyt_data_1', 13, 'string', 'typeahead', 'Workcat ID', 'Workcat ID', NULL, false, false, true, false, NULL, 'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'action_workcat', false, NULL),
('ve_genelem_eiot_sensor', 'form_feature', 'tab_data', 'comment', 'lyt_data_1', 8, 'string', 'text', 'Comments', 'Comments', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":true}'::json, NULL, NULL, true, NULL),
('ve_genelem_eiot_sensor', 'form_feature', 'tab_data', 'rotation', 'lyt_data_1', 18, 'double', 'text', 'Rotation', 'Rotation', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_genelem_eiot_sensor', 'form_feature', 'tab_data', 'ownercat_id', 'lyt_data_1', 17, 'string', 'combo', 'Owner Catalog', 'Owner Catalog', NULL, false, false, true, false, NULL, 'SELECT id, id as idval FROM cat_owner WHERE id IS NOT NULL AND active IS TRUE', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_genelem_eiot_sensor', 'form_feature', 'tab_data', 'enddate', 'lyt_data_1', 16, 'date', 'datetime', 'End Date', 'End Date', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_genelem_eiot_sensor', 'form_feature', 'tab_data', 'location_type', 'lyt_data_1', 11, 'string', 'combo', 'Location Type', 'Location Type', NULL, false, false, true, false, NULL, 'SELECT location_type as id, location_type as idval FROM man_type_location WHERE feature_type = ''ELEMENT'' OR ''EORIFICE'' = ANY(featurecat_id::text[])', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_genelem_eiot_sensor', 'form_feature', 'tab_data', 'muni_id', 'lyt_data_3', 1, 'string', 'combo', 'Municipality id:', 'muni_id - Identifier of the municipality', NULL, false, false, true, NULL, NULL, 'SELECT muni_id as id, name as idval from v_ext_municipality WHERE muni_id IS NOT NULL', true, false, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL),
('ve_genelem_eiot_sensor', 'form_feature', 'tab_data', 'observ', 'lyt_data_3', 0, 'string', 'text', 'Observations', 'Observations', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":true}'::json, NULL, NULL, false, NULL),
('ve_genelem_eiot_sensor', 'form_feature', 'tab_data', 'element_id', 'lyt_top_1', 1, 'string', 'text', 'Element ID', 'Element ID', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_genelem_eiot_sensor', 'form_feature', 'tab_data', 'elementcat_id', 'lyt_top_1', 0, 'string', 'combo', 'Element Catalog', 'Element Catalog', NULL, true, false, true, false, NULL, 'SELECT id, id as idval FROM cat_element WHERE element_type = ''EIOT_SENSOR''', true, false, NULL, NULL, NULL, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_genelem_eiot_sensor', 'form_feature', 'tab_data', 'epa_type', 'lyt_top_1', 2, 'string', 'combo', 'EPA Type', 'EPA Type', NULL, false, false, true, false, NULL, 'SELECT id, id as idval FROM sys_feature_epa_type WHERE active AND feature_type = ''ELEMENT''', NULL, NULL, NULL, NULL, NULL, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_genelem_eiot_sensor', 'form_feature', 'tab_features', 'btn_delete', 'lyt_features_1', 2, NULL, 'button', NULL, NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{
  "icon": "112"
}'::json, '{
  "saveValue": false
}'::json,
'{
  "functionName": "delete_object",
  "parameters": {
    "columnfind": "element_id",
    "targetwidget": "tab_features_tbl_element",
    "sourceview": "element"
  }
}'::json, NULL, false, NULL),
('ve_genelem_eiot_sensor', 'form_feature', 'tab_features', 'btn_expr_select', 'lyt_features_1', 4, NULL, 'button', NULL, NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{
  "icon": "178"
}'::json, '{
  "saveValue": false
}'::json, NULL, NULL, false, NULL),
('ve_genelem_eiot_sensor', 'form_feature', 'tab_features', 'feature_id', 'lyt_features_1', 0, 'text', 'text', NULL, NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL),
('ve_genelem_eiot_sensor', 'form_feature', 'tab_features', 'btn_snapping', 'lyt_features_1', 3, NULL, 'button', NULL, NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{
  "icon": "137"
}'::json, '{
  "saveValue": false
}'::json, '{
  "functionName": "selection_init"
}'::json, NULL, false, NULL),
('ve_genelem_eiot_sensor', 'form_feature', 'tab_features', 'tbl_element_x_arc', 'lyt_features_2_arc', 0, NULL, 'tableview', '', '', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_arc",
  "featureType": "arc"
}'::json, NULL, 'tbl_element_x_arc', false, NULL),
('ve_genelem_eiot_sensor', 'form_feature', 'tab_features', 'tbl_element_x_connec', 'lyt_features_2_connec', 0, NULL, 'tableview', '', '', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_connec",
  "featureType": "connec"
}'::json, NULL, 'tbl_element_x_connec', false, NULL),
('ve_genelem_eiot_sensor', 'form_feature', 'tab_features', 'tbl_element_x_gully', 'lyt_features_2_gully', 0, NULL, 'tableview', '', '', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_gully",
  "featureType": "gully"
}'::json, NULL, 'tbl_element_x_gully', false, NULL),
('ve_genelem_eiot_sensor', 'form_feature', 'tab_features', 'tbl_element_x_link', 'lyt_features_2_link', 0, NULL, 'tableview', '', '', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_link",
  "featureType": "link"
}'::json, NULL, 'tbl_element_x_link', false, NULL),
('ve_genelem_eiot_sensor', 'form_feature', 'tab_features', 'tbl_element_x_node', 'lyt_features_2_node', 0, NULL, 'tableview', '', '', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_node",
  "featureType": "node"
}'::json, NULL, 'tbl_element_x_node', false, NULL),
('ve_genelem_eiot_sensor', 'form_feature', 'tab_features', 'btn_insert', 'lyt_features_1', 1, NULL, 'button', NULL, NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{
  "icon": "111"
}'::json, '{
  "saveValue": false
}'::json,
'{
  "functionName": "insert_feature",
  "parameters": {
    "targetwidget": "tab_features_feature_id"
  }
}'::json, NULL, false, NULL)
ON CONFLICT (formname, formtype, tabname, columnname) DO UPDATE SET
  layoutname = EXCLUDED.layoutname,
  layoutorder = EXCLUDED.layoutorder,
  datatype = EXCLUDED.datatype,
  widgettype = EXCLUDED.widgettype,
  label = EXCLUDED.label,
  tooltip = EXCLUDED.tooltip,
  placeholder = EXCLUDED.placeholder,
  ismandatory = EXCLUDED.ismandatory,
  isparent = EXCLUDED.isparent,
  iseditable = EXCLUDED.iseditable,
  isautoupdate = EXCLUDED.isautoupdate,
  isfilter = EXCLUDED.isfilter,
  dv_querytext = EXCLUDED.dv_querytext,
  dv_orderby_id = EXCLUDED.dv_orderby_id,
  dv_isnullvalue = EXCLUDED.dv_isnullvalue,
  dv_parent_id = EXCLUDED.dv_parent_id,
  stylesheet = EXCLUDED.stylesheet,
  widgetcontrols = EXCLUDED.widgetcontrols,
  widgetfunction = EXCLUDED.widgetfunction,
  linkedobject = EXCLUDED.linkedobject,
  hidden = EXCLUDED.hidden,
  web_layoutorder = EXCLUDED.web_layoutorder;


-- ve_genelem_eprotector
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES
('ve_genelem_eprotector', 'form_feature', 'tab_data', 'workcat_id_end', 'lyt_data_1', 14, 'string', 'typeahead', 'Workcat ID End', 'Workcat ID End', 'Only when state is obsolete', false, false, true, false, NULL, 'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_genelem_eprotector', 'form_feature', 'tab_data', 'category_type', 'lyt_data_1', 10, 'string', 'combo', 'Category Type', 'Category Type', NULL, false, false, true, false, NULL, 'SELECT category_type as id, category_type as idval FROM man_type_category WHERE feature_type = ''ELEMENT'' OR ''EORIFICE'' = ANY(featurecat_id::text[])', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_genelem_eprotector', 'form_feature', 'tab_data', 'function_type', 'lyt_data_1', 9, 'string', 'combo', 'Function Type', 'Function Type', NULL, false, false, true, false, NULL, 'SELECT function_type as id, function_type as idval FROM man_type_function WHERE feature_type = ''ELEMENT'' OR ''EORIFICE'' = ANY(featurecat_id::text[])', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_genelem_eprotector', 'form_feature', 'tab_data', 'num_elements', 'lyt_data_1', 6, 'integer', 'text', 'Number of Elements', 'Number of Elements', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_genelem_eprotector', 'form_feature', 'tab_data', 'code', 'lyt_data_1', 2, 'string', 'text', 'Code', 'Code', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_genelem_eprotector', 'form_feature', 'tab_data', 'builtdate', 'lyt_data_1', 15, 'date', 'datetime', 'Built Date', 'Built Date', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_genelem_eprotector', 'form_feature', 'tab_data', 'workcat_id', 'lyt_data_1', 13, 'string', 'typeahead', 'Workcat ID', 'Workcat ID', NULL, false, false, true, false, NULL, 'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'action_workcat', false, NULL),
('ve_genelem_eprotector', 'form_feature', 'tab_data', 'comment', 'lyt_data_1', 8, 'string', 'text', 'Comments', 'Comments', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":true}'::json, NULL, NULL, true, NULL),
('ve_genelem_eprotector', 'form_feature', 'tab_data', 'top_elev', 'lyt_data_1', 21, 'double', 'text', 'Top Elevation', 'Top Elevation', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_genelem_eprotector', 'form_feature', 'tab_data', 'rotation', 'lyt_data_1', 18, 'double', 'text', 'Rotation', 'Rotation', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_genelem_eprotector', 'form_feature', 'tab_data', 'ownercat_id', 'lyt_data_1', 17, 'string', 'combo', 'Owner Catalog', 'Owner Catalog', NULL, false, false, true, false, NULL, 'SELECT id, id as idval FROM cat_owner WHERE id IS NOT NULL AND active IS TRUE', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_genelem_eprotector', 'form_feature', 'tab_data', 'enddate', 'lyt_data_1', 16, 'date', 'datetime', 'End Date', 'End Date', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_genelem_eprotector', 'form_feature', 'tab_data', 'location_type', 'lyt_data_1', 11, 'string', 'combo', 'Location Type', 'Location Type', NULL, false, false, true, false, NULL, 'SELECT location_type as id, location_type as idval FROM man_type_location WHERE feature_type = ''ELEMENT'' OR ''EORIFICE'' = ANY(featurecat_id::text[])', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_genelem_eprotector', 'form_feature', 'tab_data', 'muni_id', 'lyt_data_3', 1, 'string', 'combo', 'Municipality id:', 'muni_id - Identifier of the municipality', NULL, false, false, true, NULL, NULL, 'SELECT muni_id as id, name as idval from v_ext_municipality WHERE muni_id IS NOT NULL', true, false, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL),
('ve_genelem_eprotector', 'form_feature', 'tab_data', 'observ', 'lyt_data_3', 0, 'string', 'text', 'Observations', 'Observations', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":true}'::json, NULL, NULL, false, NULL),
('ve_genelem_eprotector', 'form_feature', 'tab_data', 'element_id', 'lyt_top_1', 1, 'string', 'text', 'Element ID', 'Element ID', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_genelem_eprotector', 'form_feature', 'tab_data', 'epa_type', 'lyt_top_1', 2, 'string', 'combo', 'EPA Type', 'EPA Type', NULL, false, false, true, false, NULL, 'SELECT id, id as idval FROM sys_feature_epa_type WHERE active AND feature_type = ''ELEMENT''', NULL, NULL, NULL, NULL, NULL, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_genelem_eprotector', 'form_feature', 'tab_data', 'state_type', 'lyt_bot_1', 4, 'integer', 'combo', 'State Type', 'State Type', NULL, false, false, true, false, NULL, 'SELECT id, name as idval FROM value_state_type WHERE id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_genelem_eprotector', 'form_feature', 'tab_data', 'state', 'lyt_bot_1', 3, 'integer', 'combo', 'State', 'State', NULL, false, false, true, false, NULL, 'SELECT id, name as idval FROM value_state WHERE id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_genelem_eprotector', 'form_feature', 'tab_data', 'expl_id', 'lyt_bot_1', 0, 'integer', 'combo', 'Exploitation ID', 'Exploitation ID', NULL, false, false, true, false, NULL, 'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL', true, false, NULL, NULL, '{"label":"color:red; font-weight:bold"}'::json, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_genelem_eprotector', 'form_feature', 'tab_data', 'elementcat_id', 'lyt_top_1', 0, 'string', 'combo', 'Element Catalog', 'Element Catalog', NULL, true, false, true, false, NULL, 'SELECT id, id as idval FROM cat_element WHERE element_type = ''EPROTECTOR''', true, false, NULL, NULL, NULL, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_genelem_eprotector', 'form_feature', 'tab_data', 'sector_id', 'lyt_bot_1', 1, 'integer', 'combo', 'Sector ID', 'Sector ID', NULL, false, false, true, false, NULL, 'SELECT sector_id as id, name as idval FROM sector WHERE sector_id IS NOT NULL', true, false, NULL, NULL, '{"label":"color:red; font-weight:bold"}'::json, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_genelem_eprotector', 'form_feature', 'tab_features', 'btn_delete', 'lyt_features_1', 2, NULL, 'button', NULL, NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{
  "icon": "112"
}'::json, '{
  "saveValue": false
}'::json,
'{
  "functionName": "delete_object",
  "parameters": {
    "columnfind": "element_id",
    "targetwidget": "tab_features_tbl_element",
    "sourceview": "element"
  }
}'::json, NULL, false, NULL),
('ve_genelem_eprotector', 'form_feature', 'tab_features', 'btn_expr_select', 'lyt_features_1', 4, NULL, 'button', NULL, NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{
  "icon": "178"
}'::json, '{
  "saveValue": false
}'::json, NULL, NULL, false, NULL),
('ve_genelem_eprotector', 'form_feature', 'tab_features', 'feature_id', 'lyt_features_1', 0, 'text', 'text', NULL, NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL),
('ve_genelem_eprotector', 'form_feature', 'tab_features', 'btn_snapping', 'lyt_features_1', 3, NULL, 'button', NULL, NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{
  "icon": "137"
}'::json, '{
  "saveValue": false
}'::json, '{
  "functionName": "selection_init"
}'::json, NULL, false, NULL),
('ve_genelem_eprotector', 'form_feature', 'tab_features', 'tbl_element_x_arc', 'lyt_features_2_arc', 0, NULL, 'tableview', '', '', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_arc",
  "featureType": "arc"
}'::json, NULL, 'tbl_element_x_arc', false, NULL),
('ve_genelem_eprotector', 'form_feature', 'tab_features', 'tbl_element_x_connec', 'lyt_features_2_connec', 0, NULL, 'tableview', '', '', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_connec",
  "featureType": "connec"
}'::json, NULL, 'tbl_element_x_connec', false, NULL),
('ve_genelem_eprotector', 'form_feature', 'tab_features', 'tbl_element_x_gully', 'lyt_features_2_gully', 0, NULL, 'tableview', '', '', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_gully",
  "featureType": "gully"
}'::json, NULL, 'tbl_element_x_gully', false, NULL),
('ve_genelem_eprotector', 'form_feature', 'tab_features', 'tbl_element_x_link', 'lyt_features_2_link', 0, NULL, 'tableview', '', '', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_link",
  "featureType": "link"
}'::json, NULL, 'tbl_element_x_link', false, NULL),
('ve_genelem_eprotector', 'form_feature', 'tab_features', 'tbl_element_x_node', 'lyt_features_2_node', 0, NULL, 'tableview', '', '', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_node",
  "featureType": "node"
}'::json, NULL, 'tbl_element_x_node', false, NULL),
('ve_genelem_eprotector', 'form_feature', 'tab_features', 'btn_insert', 'lyt_features_1', 1, NULL, 'button', NULL, NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{
  "icon": "111"
}'::json, '{
  "saveValue": false
}'::json,
'{
  "functionName": "insert_feature",
  "parameters": {
    "targetwidget": "tab_features_feature_id"
  }
}'::json, NULL, false, NULL)
ON CONFLICT (formname, formtype, tabname, columnname) DO UPDATE SET
  layoutname = EXCLUDED.layoutname,
  layoutorder = EXCLUDED.layoutorder,
  datatype = EXCLUDED.datatype,
  widgettype = EXCLUDED.widgettype,
  label = EXCLUDED.label,
  tooltip = EXCLUDED.tooltip,
  placeholder = EXCLUDED.placeholder,
  ismandatory = EXCLUDED.ismandatory,
  isparent = EXCLUDED.isparent,
  iseditable = EXCLUDED.iseditable,
  isautoupdate = EXCLUDED.isautoupdate,
  isfilter = EXCLUDED.isfilter,
  dv_querytext = EXCLUDED.dv_querytext,
  dv_orderby_id = EXCLUDED.dv_orderby_id,
  dv_isnullvalue = EXCLUDED.dv_isnullvalue,
  dv_parent_id = EXCLUDED.dv_parent_id,
  stylesheet = EXCLUDED.stylesheet,
  widgetcontrols = EXCLUDED.widgetcontrols,
  widgetfunction = EXCLUDED.widgetfunction,
  linkedobject = EXCLUDED.linkedobject,
  hidden = EXCLUDED.hidden,
  web_layoutorder = EXCLUDED.web_layoutorder;


-- ve_frelem_eorifice
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES
('ve_frelem_eorifice', 'form_feature', 'tab_data', 'epa_type', 'lyt_top_1', 2, 'string', 'combo', 'EPA Type', 'EPA Type', NULL, false, false, true, false, NULL, 'SELECT id, id as idval FROM sys_feature_epa_type WHERE active AND feature_type = ''ELEMENT''', NULL, NULL, NULL, NULL, NULL, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_frelem_eorifice', 'form_feature', 'tab_data', 'muni_id', 'lyt_data_3', 1, 'integer', 'combo', 'municipality', 'muni_id', NULL, false, false, true, false, NULL, 'SELECT muni_id as id, name as idval from v_ext_municipality WHERE muni_id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 56),
('ve_frelem_eorifice', 'form_feature', 'tab_data', 'to_arc', 'lyt_data_2', 1, 'string', 'text', 'to_arc', 'to_arc', NULL, true, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL),
('ve_frelem_eorifice', 'form_feature', 'tab_data', 'observ', 'lyt_data_3', 0, 'string', 'text', 'Observations', 'Observations', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":true}'::json, NULL, NULL, false, NULL),
('ve_frelem_eorifice', 'form_feature', 'tab_data', 'workcat_id_end', 'lyt_data_1', 14, 'string', 'typeahead', 'Workcat ID End', 'Workcat ID End', 'Only when state is obsolete', false, false, true, false, NULL, 'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_frelem_eorifice', 'form_feature', 'tab_data', 'state', 'lyt_bot_1', 3, 'integer', 'combo', 'State', 'State', NULL, false, false, true, false, NULL, 'SELECT id, name as idval FROM value_state WHERE id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_frelem_eorifice', 'form_feature', 'tab_data', 'state_type', 'lyt_bot_1', 4, 'integer', 'combo', 'State Type', 'State Type', NULL, false, false, true, false, NULL, 'SELECT id, name as idval FROM value_state_type WHERE id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_frelem_eorifice', 'form_feature', 'tab_data', 'sector_id', 'lyt_bot_1', 1, 'integer', 'combo', 'Sector ID', 'Sector ID', NULL, false, false, true, false, NULL, 'SELECT sector_id as id, name as idval FROM sector WHERE sector_id IS NOT NULL', true, false, NULL, NULL, '{"label":"color:red; font-weight:bold"}'::json, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_frelem_eorifice', 'form_feature', 'tab_data', 'elementcat_id', 'lyt_top_1', 0, 'string', 'combo', 'Element Catalog', 'Element Catalog', NULL, true, false, true, false, NULL, 'SELECT id, id as idval FROM cat_element WHERE element_type = ''EORIFICE''', true, false, NULL, NULL, NULL, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_frelem_eorifice', 'form_feature', 'tab_data', 'element_id', 'lyt_top_1', 1, 'string', 'text', 'Element ID', 'Element ID', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_frelem_eorifice', 'form_feature', 'tab_data', 'expl_id', 'lyt_bot_1', 0, 'integer', 'combo', 'Exploitation ID', 'Exploitation ID', NULL, false, false, true, false, NULL, 'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL', true, false, NULL, NULL, '{"label":"color:red; font-weight:bold"}'::json, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_frelem_eorifice', 'form_feature', 'tab_data', 'flwreg_length', 'lyt_data_2', 2, 'double', 'text', 'flwreg_length', 'flwreg_length', NULL, true, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL),
('ve_frelem_eorifice', 'form_feature', 'tab_data', 'order_id', 'lyt_data_2', 3, 'double', 'text', 'order_id', 'order_id', NULL, true, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL),
('ve_frelem_eorifice', 'form_feature', 'tab_data', 'node_id', 'lyt_data_1', 1, 'string', 'text', 'node_id', NULL, NULL, true, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL),
('ve_frelem_eorifice', 'form_feature', 'tab_data', 'code', 'lyt_data_1', 2, 'string', 'text', 'Code', 'Code', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_frelem_eorifice', 'form_feature', 'tab_data', 'num_elements', 'lyt_data_1', 6, 'integer', 'text', 'Number of Elements', 'Number of Elements', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_frelem_eorifice', 'form_feature', 'tab_data', 'comment', 'lyt_data_1', 8, 'string', 'text', 'Comments', 'Comments', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":true}'::json, NULL, NULL, true, NULL),
('ve_frelem_eorifice', 'form_feature', 'tab_data', 'workcat_id', 'lyt_data_1', 13, 'string', 'typeahead', 'Workcat ID', 'Workcat ID', NULL, false, false, true, false, NULL, 'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'action_workcat', false, NULL),
('ve_frelem_eorifice', 'form_feature', 'tab_data', 'builtdate', 'lyt_data_1', 15, 'date', 'datetime', 'Built Date', 'Built Date', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_frelem_eorifice', 'form_feature', 'tab_data', 'enddate', 'lyt_data_1', 16, 'date', 'datetime', 'End Date', 'End Date', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_frelem_eorifice', 'form_feature', 'tab_data', 'ownercat_id', 'lyt_data_1', 17, 'string', 'combo', 'Owner Catalog', 'Owner Catalog', NULL, false, false, true, false, NULL, 'SELECT id, id as idval FROM cat_owner WHERE id IS NOT NULL AND active IS TRUE', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_frelem_eorifice', 'form_feature', 'tab_data', 'rotation', 'lyt_data_1', 18, 'double', 'text', 'Rotation', 'Rotation', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_frelem_eorifice', 'form_feature', 'tab_data', 'top_elev', 'lyt_data_1', 21, 'double', 'text', 'Top Elevation', 'Top Elevation', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_frelem_eorifice', 'form_feature', 'tab_data', 'nodarc_id', 'lyt_data_2', 0, 'string', 'text', 'nodarc_id', 'nodarc_id', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL),
('ve_frelem_eorifice', 'form_feature', 'tab_data', 'function_type', 'lyt_data_1', 9, 'string', 'combo', 'Function Type', 'Function Type', NULL, false, false, true, false, NULL, 'SELECT function_type as id, function_type as idval FROM man_type_function WHERE feature_type = ''ELEMENT'' OR ''EORIFICE'' = ANY(featurecat_id::text[])', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_frelem_eorifice', 'form_feature', 'tab_data', 'category_type', 'lyt_data_1', 10, 'string', 'combo', 'Category Type', 'Category Type', NULL, false, false, true, false, NULL, 'SELECT category_type as id, category_type as idval FROM man_type_category WHERE feature_type = ''ELEMENT'' OR ''EORIFICE'' = ANY(featurecat_id::text[])', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_frelem_eorifice', 'form_feature', 'tab_data', 'location_type', 'lyt_data_1', 11, 'string', 'combo', 'Location Type', 'Location Type', NULL, false, false, true, false, NULL, 'SELECT location_type as id, location_type as idval FROM man_type_location WHERE feature_type = ''ELEMENT'' OR ''EORIFICE'' = ANY(featurecat_id::text[])', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_frelem_eorifice', 'form_feature', 'tab_features', 'btn_delete', 'lyt_features_1', 2, NULL, 'button', NULL, NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{
  "icon": "112"
}'::json, '{
  "saveValue": false
}'::json,
'{
  "functionName": "delete_object",
  "parameters": {
    "columnfind": "element_id",
    "targetwidget": "tab_features_tbl_element",
    "sourceview": "element"
  }
}'::json, NULL, false, NULL),
('ve_frelem_eorifice', 'form_feature', 'tab_features', 'btn_expr_select', 'lyt_features_1', 4, NULL, 'button', NULL, NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{
  "icon": "178"
}'::json, '{
  "saveValue": false
}'::json, NULL, NULL, false, NULL),
('ve_frelem_eorifice', 'form_feature', 'tab_features', 'feature_id', 'lyt_features_1', 0, 'text', 'text', NULL, NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL),
('ve_frelem_eorifice', 'form_feature', 'tab_features', 'btn_snapping', 'lyt_features_1', 3, NULL, 'button', NULL, NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{
  "icon": "137"
}'::json, '{
  "saveValue": false
}'::json, '{
  "functionName": "selection_init"
}'::json, NULL, false, NULL),
('ve_frelem_eorifice', 'form_feature', 'tab_features', 'tbl_element_x_arc', 'lyt_features_2_arc', 0, NULL, 'tableview', '', '', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_arc",
  "featureType": "arc"
}'::json, NULL, 'tbl_element_x_arc', false, NULL),
('ve_frelem_eorifice', 'form_feature', 'tab_features', 'tbl_element_x_connec', 'lyt_features_2_connec', 0, NULL, 'tableview', '', '', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_connec",
  "featureType": "connec"
}'::json, NULL, 'tbl_element_x_connec', false, NULL),
('ve_frelem_eorifice', 'form_feature', 'tab_features', 'tbl_element_x_gully', 'lyt_features_2_gully', 0, NULL, 'tableview', '', '', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_gully",
  "featureType": "gully"
}'::json, NULL, 'tbl_element_x_gully', false, NULL),
('ve_frelem_eorifice', 'form_feature', 'tab_features', 'tbl_element_x_link', 'lyt_features_2_link', 0, NULL, 'tableview', '', '', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_link",
  "featureType": "link"
}'::json, NULL, 'tbl_element_x_link', false, NULL),
('ve_frelem_eorifice', 'form_feature', 'tab_features', 'tbl_element_x_node', 'lyt_features_2_node', 0, NULL, 'tableview', '', '', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_node",
  "featureType": "node"
}'::json, NULL, 'tbl_element_x_node', false, NULL),
('ve_frelem_eorifice', 'form_feature', 'tab_features', 'btn_insert', 'lyt_features_1', 1, NULL, 'button', NULL, NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{
  "icon": "111"
}'::json, '{
  "saveValue": false
}'::json,
'{
  "functionName": "insert_feature",
  "parameters": {
    "targetwidget": "tab_features_feature_id"
  }
}'::json, NULL, false, NULL)
ON CONFLICT (formname, formtype, tabname, columnname) DO UPDATE SET
  layoutname = EXCLUDED.layoutname,
  layoutorder = EXCLUDED.layoutorder,
  datatype = EXCLUDED.datatype,
  widgettype = EXCLUDED.widgettype,
  label = EXCLUDED.label,
  tooltip = EXCLUDED.tooltip,
  placeholder = EXCLUDED.placeholder,
  ismandatory = EXCLUDED.ismandatory,
  isparent = EXCLUDED.isparent,
  iseditable = EXCLUDED.iseditable,
  isautoupdate = EXCLUDED.isautoupdate,
  isfilter = EXCLUDED.isfilter,
  dv_querytext = EXCLUDED.dv_querytext,
  dv_orderby_id = EXCLUDED.dv_orderby_id,
  dv_isnullvalue = EXCLUDED.dv_isnullvalue,
  dv_parent_id = EXCLUDED.dv_parent_id,
  stylesheet = EXCLUDED.stylesheet,
  widgetcontrols = EXCLUDED.widgetcontrols,
  widgetfunction = EXCLUDED.widgetfunction,
  linkedobject = EXCLUDED.linkedobject,
  hidden = EXCLUDED.hidden,
  web_layoutorder = EXCLUDED.web_layoutorder;

-- ve_epa_frorifice
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES
('ve_epa_frorifice', 'form_feature', 'tab_epa', 'orifice_type', 'lyt_epa_data_1', 0, 'string', 'combo', 'Orifice Type', 'Orifice Type', NULL, false, false, true, false, NULL, 'SELECT id, id as idval FROM sys_feature_epa_type WHERE active AND feature_type = ''ELEMENT''', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frorifice', 'form_feature', 'tab_epa', 'offsetval', 'lyt_epa_data_1', 1, 'double', 'text', 'Offset Value', 'Offset Value', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frorifice', 'form_feature', 'tab_epa', 'cd', 'lyt_epa_data_1', 2, 'double', 'text', 'Discharge Coefficient', 'Discharge Coefficient', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frorifice', 'form_feature', 'tab_epa', 'orate', 'lyt_epa_data_1', 3, 'double', 'text', 'Orifice Rate', 'Orifice Rate', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frorifice', 'form_feature', 'tab_epa', 'flap', 'lyt_epa_data_1', 4, 'boolean', 'check', 'Flap', 'Flap', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frorifice', 'form_feature', 'tab_epa', 'shape', 'lyt_epa_data_1', 5, 'string', 'text', 'Shape', 'Shape', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frorifice', 'form_feature', 'tab_epa', 'geom1', 'lyt_epa_data_1', 6, 'double', 'text', 'Geom1', 'Geom1', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frorifice', 'form_feature', 'tab_epa', 'geom2', 'lyt_epa_data_1', 7, 'double', 'text', 'Geom2', 'Geom2', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frorifice', 'form_feature', 'tab_epa', 'geom3', 'lyt_epa_data_1', 8, 'double', 'text', 'Geom3', 'Geom3', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frorifice', 'form_feature', 'tab_epa', 'geom4', 'lyt_epa_data_1', 9, 'double', 'text', 'Geom4', 'Geom4', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frorifice', 'form_feature', 'tab_epa', 'max_flow', 'lyt_epa_data_2', 0, 'double', 'text', 'Maximum Flow', 'Maximum Flow', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frorifice', 'form_feature', 'tab_epa', 'time_days', 'lyt_epa_data_2', 1, 'integer', 'text', 'Time Days', 'Time Days', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frorifice', 'form_feature', 'tab_epa', 'time_hour', 'lyt_epa_data_2', 2, 'integer', 'text', 'Time Hour', 'Time Hour', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frorifice', 'form_feature', 'tab_epa', 'max_veloc', 'lyt_epa_data_2', 3, 'double', 'text', 'Maximum Velocity', 'Maximum Velocity', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frorifice', 'form_feature', 'tab_epa', 'mfull_flow', 'lyt_epa_data_2', 4, 'double', 'text', 'Full Flow', 'Full Flow', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frorifice', 'form_feature', 'tab_epa', 'mfull_depth', 'lyt_epa_data_2', 5, 'double', 'text', 'Full Depth', 'Full Depth', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frorifice', 'form_feature', 'tab_epa', 'max_shear', 'lyt_epa_data_2', 6, 'double', 'text', 'Maximum Shear', 'Maximum Shear', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frorifice', 'form_feature', 'tab_epa', 'max_hr', 'lyt_epa_data_2', 7, 'double', 'text', 'Maximum Hydraulic Radius', 'Maximum Hydraulic Radius', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frorifice', 'form_feature', 'tab_epa', 'max_slope', 'lyt_epa_data_2', 8, 'double', 'text', 'Maximum Slope', 'Maximum Slope', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frorifice', 'form_feature', 'tab_epa', 'day_max', 'lyt_epa_data_2', 9, 'integer', 'text', 'Day Maximum', 'Day Maximum', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frorifice', 'form_feature', 'tab_epa', 'time_max', 'lyt_epa_data_2', 10, 'integer', 'text', 'Time Maximum', 'Time Maximum', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frorifice', 'form_feature', 'tab_epa', 'min_shear', 'lyt_epa_data_2', 11, 'double', 'text', 'Minimum Shear', 'Minimum Shear', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frorifice', 'form_feature', 'tab_epa', 'day_min', 'lyt_epa_data_2', 12, 'integer', 'text', 'Day Minimum', 'Day Minimum', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frorifice', 'form_feature', 'tab_epa', 'time_min', 'lyt_epa_data_2', 13, 'integer', 'text', 'Time Minimum', 'Time Minimum', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);


-- ve_frelem_eoutlet
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES
('ve_frelem_eoutlet', 'form_feature', 'tab_data', 'muni_id', 'lyt_data_3', 1, 'integer', 'combo', 'municipality', 'muni_id', NULL, false, false, true, false, NULL, 'SELECT muni_id as id, name as idval from v_ext_municipality WHERE muni_id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 56),
('ve_frelem_eoutlet', 'form_feature', 'tab_data', 'state', 'lyt_bot_1', 3, 'integer', 'combo', 'State', 'State', NULL, false, false, true, false, NULL, 'SELECT id, name as idval FROM value_state WHERE id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_frelem_eoutlet', 'form_feature', 'tab_data', 'state_type', 'lyt_bot_1', 4, 'integer', 'combo', 'State Type', 'State Type', NULL, false, false, true, false, NULL, 'SELECT id, name as idval FROM value_state_type WHERE id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_frelem_eoutlet', 'form_feature', 'tab_data', 'sector_id', 'lyt_bot_1', 1, 'integer', 'combo', 'Sector ID', 'Sector ID', NULL, false, false, true, false, NULL, 'SELECT sector_id as id, name as idval FROM sector WHERE sector_id IS NOT NULL', true, false, NULL, NULL, '{"label":"color:red; font-weight:bold"}'::json, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_frelem_eoutlet', 'form_feature', 'tab_data', 'expl_id', 'lyt_bot_1', 0, 'integer', 'combo', 'Exploitation ID', 'Exploitation ID', NULL, false, false, true, false, NULL, 'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL', true, false, NULL, NULL, '{"label":"color:red; font-weight:bold"}'::json, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_frelem_eoutlet', 'form_feature', 'tab_data', 'epa_type', 'lyt_top_1', 2, 'string', 'combo', 'EPA Type', 'EPA Type', NULL, false, false, true, false, NULL, 'SELECT id, id as idval FROM sys_feature_epa_type WHERE active AND feature_type = ''ELEMENT''', NULL, NULL, NULL, NULL, NULL, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_frelem_eoutlet', 'form_feature', 'tab_data', 'flwreg_length', 'lyt_data_2', 2, 'double', 'text', 'flwreg_length', 'flwreg_length', NULL, true, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL),
('ve_frelem_eoutlet', 'form_feature', 'tab_data', 'order_id', 'lyt_data_2', 3, 'double', 'text', 'order_id', 'order_id', NULL, true, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL),
('ve_frelem_eoutlet', 'form_feature', 'tab_data', 'to_arc', 'lyt_data_2', 1, 'string', 'text', 'to_arc', 'to_arc', NULL, true, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL),
('ve_frelem_eoutlet', 'form_feature', 'tab_data', 'node_id', 'lyt_data_1', 1, 'string', 'text', 'node_id', NULL, NULL, true, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL),
('ve_frelem_eoutlet', 'form_feature', 'tab_data', 'observ', 'lyt_data_3', 0, 'string', 'text', 'Observations', 'Observations', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":true}'::json, NULL, NULL, false, NULL),
('ve_frelem_eoutlet', 'form_feature', 'tab_data', 'code', 'lyt_data_1', 2, 'string', 'text', 'Code', 'Code', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_frelem_eoutlet', 'form_feature', 'tab_data', 'num_elements', 'lyt_data_1', 6, 'integer', 'text', 'Number of Elements', 'Number of Elements', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_frelem_eoutlet', 'form_feature', 'tab_data', 'comment', 'lyt_data_1', 8, 'string', 'text', 'Comments', 'Comments', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":true}'::json, NULL, NULL, true, NULL),
('ve_frelem_eoutlet', 'form_feature', 'tab_data', 'workcat_id_end', 'lyt_data_1', 14, 'string', 'typeahead', 'Workcat ID End', 'Workcat ID End', 'Only when state is obsolete', false, false, true, false, NULL, 'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_frelem_eoutlet', 'form_feature', 'tab_data', 'elementcat_id', 'lyt_top_1', 0, 'string', 'combo', 'Element Catalog', 'Element Catalog', NULL, true, false, true, false, NULL, 'SELECT id, id as idval FROM cat_element WHERE element_type = ''EOUTLET''', true, false, NULL, NULL, NULL, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_frelem_eoutlet', 'form_feature', 'tab_data', 'workcat_id', 'lyt_data_1', 13, 'string', 'typeahead', 'Workcat ID', 'Workcat ID', NULL, false, false, true, false, NULL, 'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'action_workcat', false, NULL),
('ve_frelem_eoutlet', 'form_feature', 'tab_data', 'builtdate', 'lyt_data_1', 15, 'date', 'datetime', 'Built Date', 'Built Date', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_frelem_eoutlet', 'form_feature', 'tab_data', 'enddate', 'lyt_data_1', 16, 'date', 'datetime', 'End Date', 'End Date', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_frelem_eoutlet', 'form_feature', 'tab_data', 'ownercat_id', 'lyt_data_1', 17, 'string', 'combo', 'Owner Catalog', 'Owner Catalog', NULL, false, false, true, false, NULL, 'SELECT id, id as idval FROM cat_owner WHERE id IS NOT NULL AND active IS TRUE', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_frelem_eoutlet', 'form_feature', 'tab_data', 'rotation', 'lyt_data_1', 18, 'double', 'text', 'Rotation', 'Rotation', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_frelem_eoutlet', 'form_feature', 'tab_data', 'top_elev', 'lyt_data_1', 21, 'double', 'text', 'Top Elevation', 'Top Elevation', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_frelem_eoutlet', 'form_feature', 'tab_data', 'element_id', 'lyt_top_1', 1, 'string', 'text', 'Element ID', 'Element ID', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_frelem_eoutlet', 'form_feature', 'tab_data', 'nodarc_id', 'lyt_data_2', 0, 'string', 'text', 'nodarc_id', 'nodarc_id', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL),
('ve_frelem_eoutlet', 'form_feature', 'tab_data', 'function_type', 'lyt_data_1', 9, 'string', 'combo', 'Function Type', 'Function Type', NULL, false, false, true, false, NULL, 'SELECT function_type as id, function_type as idval FROM man_type_function WHERE feature_type = ''ELEMENT'' OR ''EOUTLET'' = ANY(featurecat_id::text[])', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_frelem_eoutlet', 'form_feature', 'tab_data', 'category_type', 'lyt_data_1', 10, 'string', 'combo', 'Category Type', 'Category Type', NULL, false, false, true, false, NULL, 'SELECT category_type as id, category_type as idval FROM man_type_category WHERE feature_type = ''ELEMENT'' OR ''EOUTLET'' = ANY(featurecat_id::text[])', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_frelem_eoutlet', 'form_feature', 'tab_data', 'location_type', 'lyt_data_1', 11, 'string', 'combo', 'Location Type', 'Location Type', NULL, false, false, true, false, NULL, 'SELECT location_type as id, location_type as idval FROM man_type_location WHERE feature_type = ''ELEMENT'' OR ''EOUTLET'' = ANY(featurecat_id::text[])', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_frelem_eoutlet', 'form_feature', 'tab_features', 'btn_delete', 'lyt_features_1', 2, NULL, 'button', NULL, NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{
  "icon": "112"
}'::json, '{
  "saveValue": false
}'::json,
'{
  "functionName": "delete_object",
  "parameters": {
    "columnfind": "element_id",
    "targetwidget": "tab_features_tbl_element",
    "sourceview": "element"
  }
}'::json, NULL, false, NULL),
('ve_frelem_eoutlet', 'form_feature', 'tab_features', 'btn_expr_select', 'lyt_features_1', 4, NULL, 'button', NULL, NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{
  "icon": "178"
}'::json, '{
  "saveValue": false
}'::json, NULL, NULL, false, NULL),
('ve_frelem_eoutlet', 'form_feature', 'tab_features', 'feature_id', 'lyt_features_1', 0, 'text', 'text', NULL, NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL),
('ve_frelem_eoutlet', 'form_feature', 'tab_features', 'btn_snapping', 'lyt_features_1', 3, NULL, 'button', NULL, NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{
  "icon": "137"
}'::json, '{
  "saveValue": false
}'::json, '{
  "functionName": "selection_init"
}'::json, NULL, false, NULL),
('ve_frelem_eoutlet', 'form_feature', 'tab_features', 'tbl_element_x_arc', 'lyt_features_2_arc', 0, NULL, 'tableview', '', '', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_arc",
  "featureType": "arc"
}'::json, NULL, 'tbl_element_x_arc', false, NULL),
('ve_frelem_eoutlet', 'form_feature', 'tab_features', 'tbl_element_x_connec', 'lyt_features_2_connec', 0, NULL, 'tableview', '', '', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_connec",
  "featureType": "connec"
}'::json, NULL, 'tbl_element_x_connec', false, NULL),
('ve_frelem_eoutlet', 'form_feature', 'tab_features', 'tbl_element_x_gully', 'lyt_features_2_gully', 0, NULL, 'tableview', '', '', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_gully",
  "featureType": "gully"
}'::json, NULL, 'tbl_element_x_gully', false, NULL),
('ve_frelem_eoutlet', 'form_feature', 'tab_features', 'tbl_element_x_link', 'lyt_features_2_link', 0, NULL, 'tableview', '', '', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_link",
  "featureType": "link"
}'::json, NULL, 'tbl_element_x_link', false, NULL),
('ve_frelem_eoutlet', 'form_feature', 'tab_features', 'tbl_element_x_node', 'lyt_features_2_node', 0, NULL, 'tableview', '', '', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_node",
  "featureType": "node"
}'::json, NULL, 'tbl_element_x_node', false, NULL),
('ve_frelem_eoutlet', 'form_feature', 'tab_features', 'btn_insert', 'lyt_features_1', 1, NULL, 'button', NULL, NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{
  "icon": "111"
}'::json, '{
  "saveValue": false
}'::json,
'{
  "functionName": "insert_feature",
  "parameters": {
    "targetwidget": "tab_features_feature_id"
  }
}'::json, NULL, false, NULL)
ON CONFLICT (formname, formtype, tabname, columnname) DO UPDATE SET
  layoutname = EXCLUDED.layoutname,
  layoutorder = EXCLUDED.layoutorder,
  datatype = EXCLUDED.datatype,
  widgettype = EXCLUDED.widgettype,
  label = EXCLUDED.label,
  tooltip = EXCLUDED.tooltip,
  placeholder = EXCLUDED.placeholder,
  ismandatory = EXCLUDED.ismandatory,
  isparent = EXCLUDED.isparent,
  iseditable = EXCLUDED.iseditable,
  isautoupdate = EXCLUDED.isautoupdate,
  isfilter = EXCLUDED.isfilter,
  dv_querytext = EXCLUDED.dv_querytext,
  dv_orderby_id = EXCLUDED.dv_orderby_id,
  dv_isnullvalue = EXCLUDED.dv_isnullvalue,
  dv_parent_id = EXCLUDED.dv_parent_id,
  stylesheet = EXCLUDED.stylesheet,
  widgetcontrols = EXCLUDED.widgetcontrols,
  widgetfunction = EXCLUDED.widgetfunction,
  linkedobject = EXCLUDED.linkedobject,
  hidden = EXCLUDED.hidden,
  web_layoutorder = EXCLUDED.web_layoutorder;

-- ve_epa_froutlet
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES
('ve_epa_froutlet', 'form_feature', 'tab_epa', 'outlet_type', 'lyt_epa_data_1', 0, 'string', 'combo', 'Outlet Type', 'Outlet Type', NULL, false, false, true, false, NULL, 'SELECT id, id as idval FROM sys_feature_epa_type WHERE active AND feature_type = ''ELEMENT''', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_froutlet', 'form_feature', 'tab_epa', 'offsetval', 'lyt_epa_data_1', 1, 'double', 'text', 'Offset Value', 'Offset Value', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_froutlet', 'form_feature', 'tab_epa', 'curve_id', 'lyt_epa_data_1', 2, 'string', 'text', 'Curve ID', 'Curve ID', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_froutlet', 'form_feature', 'tab_epa', 'cd1', 'lyt_epa_data_1', 3, 'double', 'text', 'Discharge Coefficient 1', 'Discharge Coefficient 1', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_froutlet', 'form_feature', 'tab_epa', 'cd2', 'lyt_epa_data_1', 4, 'double', 'text', 'Discharge Coefficient 2', 'Discharge Coefficient 2', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_froutlet', 'form_feature', 'tab_epa', 'flap', 'lyt_epa_data_1', 5, 'boolean', 'check', 'Flap', 'Flap', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_froutlet', 'form_feature', 'tab_epa', 'max_flow', 'lyt_epa_data_2', 0, 'double', 'text', 'Maximum Flow', 'Maximum Flow', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_froutlet', 'form_feature', 'tab_epa', 'time_days', 'lyt_epa_data_2', 1, 'integer', 'text', 'Time Days', 'Time Days', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_froutlet', 'form_feature', 'tab_epa', 'time_hour', 'lyt_epa_data_2', 2, 'integer', 'text', 'Time Hour', 'Time Hour', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_froutlet', 'form_feature', 'tab_epa', 'max_veloc', 'lyt_epa_data_2', 3, 'double', 'text', 'Maximum Velocity', 'Maximum Velocity', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_froutlet', 'form_feature', 'tab_epa', 'mfull_flow', 'lyt_epa_data_2', 4, 'double', 'text', 'Full Flow', 'Full Flow', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_froutlet', 'form_feature', 'tab_epa', 'mfull_dept', 'lyt_epa_data_2', 5, 'double', 'text', 'Full Depth', 'Full Depth', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_froutlet', 'form_feature', 'tab_epa', 'max_shear', 'lyt_epa_data_2', 6, 'double', 'text', 'Maximum Shear', 'Maximum Shear', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_froutlet', 'form_feature', 'tab_epa', 'max_hr', 'lyt_epa_data_2', 7, 'double', 'text', 'Maximum Hydraulic Radius', 'Maximum Hydraulic Radius', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_froutlet', 'form_feature', 'tab_epa', 'max_slope', 'lyt_epa_data_2', 8, 'double', 'text', 'Maximum Slope', 'Maximum Slope', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_froutlet', 'form_feature', 'tab_epa', 'day_max', 'lyt_epa_data_2', 9, 'integer', 'text', 'Day Maximum', 'Day Maximum', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_froutlet', 'form_feature', 'tab_epa', 'time_max', 'lyt_epa_data_2', 10, 'integer', 'text', 'Time Maximum', 'Time Maximum', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_froutlet', 'form_feature', 'tab_epa', 'min_shear', 'lyt_epa_data_2', 11, 'double', 'text', 'Minimum Shear', 'Minimum Shear', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_froutlet', 'form_feature', 'tab_epa', 'day_min', 'lyt_epa_data_2', 12, 'integer', 'text', 'Day Minimum', 'Day Minimum', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_froutlet', 'form_feature', 'tab_epa', 'time_min', 'lyt_epa_data_2', 13, 'integer', 'text', 'Time Minimum', 'Time Minimum', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);

-- ve_frelem_eweir
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES
('ve_frelem_eweir', 'form_feature', 'tab_data', 'epa_type', 'lyt_top_1', 2, 'string', 'combo', 'EPA Type', 'EPA Type', NULL, false, false, true, false, NULL, 'SELECT id, id as idval FROM sys_feature_epa_type WHERE active AND feature_type = ''ELEMENT''', NULL, NULL, NULL, NULL, NULL, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_frelem_eweir', 'form_feature', 'tab_data', 'muni_id', 'lyt_data_3', 1, 'integer', 'combo', 'municipality', 'muni_id', NULL, false, false, true, false, NULL, 'SELECT muni_id as id, name as idval from v_ext_municipality WHERE muni_id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 56),
('ve_frelem_eweir', 'form_feature', 'tab_data', 'workcat_id_end', 'lyt_data_1', 14, 'string', 'typeahead', 'Workcat ID End', 'Workcat ID End', 'Only when state is obsolete', false, false, true, false, NULL, 'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_frelem_eweir', 'form_feature', 'tab_data', 'state', 'lyt_bot_1', 3, 'integer', 'combo', 'State', 'State', NULL, false, false, true, false, NULL, 'SELECT id, name as idval FROM value_state WHERE id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_frelem_eweir', 'form_feature', 'tab_data', 'state_type', 'lyt_bot_1', 4, 'integer', 'combo', 'State Type', 'State Type', NULL, false, false, true, false, NULL, 'SELECT id, name as idval FROM value_state_type WHERE id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_frelem_eweir', 'form_feature', 'tab_data', 'sector_id', 'lyt_bot_1', 1, 'integer', 'combo', 'Sector ID', 'Sector ID', NULL, false, false, true, false, NULL, 'SELECT sector_id as id, name as idval FROM sector WHERE sector_id IS NOT NULL', true, false, NULL, NULL, '{"label":"color:red; font-weight:bold"}'::json, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_frelem_eweir', 'form_feature', 'tab_data', 'element_id', 'lyt_top_1', 1, 'string', 'text', 'Element ID', 'Element ID', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_frelem_eweir', 'form_feature', 'tab_data', 'expl_id', 'lyt_bot_1', 0, 'integer', 'combo', 'Exploitation ID', 'Exploitation ID', NULL, false, false, true, false, NULL, 'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL', true, false, NULL, NULL, '{"label":"color:red; font-weight:bold"}'::json, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_frelem_eweir', 'form_feature', 'tab_data', 'flwreg_length', 'lyt_data_2', 2, 'double', 'text', 'flwreg_length', 'flwreg_length', NULL, true, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL),
('ve_frelem_eweir', 'form_feature', 'tab_data', 'order_id', 'lyt_data_2', 3, 'double', 'text', 'order_id', 'order_id', NULL, true, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL),
('ve_frelem_eweir', 'form_feature', 'tab_data', 'to_arc', 'lyt_data_2', 1, 'string', 'text', 'to_arc', 'to_arc', NULL, true, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL),
('ve_frelem_eweir', 'form_feature', 'tab_data', 'node_id', 'lyt_data_1', 1, 'string', 'text', 'node_id', NULL, NULL, true, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL),
('ve_frelem_eweir', 'form_feature', 'tab_data', 'elementcat_id', 'lyt_top_1', 0, 'string', 'combo', 'Element Catalog', 'Element Catalog', NULL, true, false, true, false, NULL, 'SELECT id, id as idval FROM cat_element WHERE element_type = ''EWEIR''', true, false, NULL, NULL, NULL, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL),
('ve_frelem_eweir', 'form_feature', 'tab_data', 'observ', 'lyt_data_3', 0, 'string', 'text', 'Observations', 'Observations', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":true}'::json, NULL, NULL, false, NULL),
('ve_frelem_eweir', 'form_feature', 'tab_data', 'code', 'lyt_data_1', 2, 'string', 'text', 'Code', 'Code', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_frelem_eweir', 'form_feature', 'tab_data', 'num_elements', 'lyt_data_1', 6, 'integer', 'text', 'Number of Elements', 'Number of Elements', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_frelem_eweir', 'form_feature', 'tab_data', 'comment', 'lyt_data_1', 8, 'string', 'text', 'Comments', 'Comments', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":true}'::json, NULL, NULL, true, NULL),
('ve_frelem_eweir', 'form_feature', 'tab_data', 'workcat_id', 'lyt_data_1', 13, 'string', 'typeahead', 'Workcat ID', 'Workcat ID', NULL, false, false, true, false, NULL, 'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'action_workcat', false, NULL),
('ve_frelem_eweir', 'form_feature', 'tab_data', 'builtdate', 'lyt_data_1', 15, 'date', 'datetime', 'Built Date', 'Built Date', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_frelem_eweir', 'form_feature', 'tab_data', 'enddate', 'lyt_data_1', 16, 'date', 'datetime', 'End Date', 'End Date', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_frelem_eweir', 'form_feature', 'tab_data', 'ownercat_id', 'lyt_data_1', 17, 'string', 'combo', 'Owner Catalog', 'Owner Catalog', NULL, false, false, true, false, NULL, 'SELECT id, id as idval FROM cat_owner WHERE id IS NOT NULL AND active IS TRUE', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_frelem_eweir', 'form_feature', 'tab_data', 'rotation', 'lyt_data_1', 18, 'double', 'text', 'Rotation', 'Rotation', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_frelem_eweir', 'form_feature', 'tab_data', 'top_elev', 'lyt_data_1', 21, 'double', 'text', 'Top Elevation', 'Top Elevation', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_frelem_eweir', 'form_feature', 'tab_data', 'nodarc_id', 'lyt_data_2', 0, 'string', 'text', 'nodarc_id', 'nodarc_id', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL),
('ve_frelem_eweir', 'form_feature', 'tab_data', 'function_type', 'lyt_data_1', 9, 'string', 'combo', 'Function Type', 'Function Type', NULL, false, false, true, false, NULL, 'SELECT function_type as id, function_type as idval FROM man_type_function WHERE feature_type = ''ELEMENT'' OR ''EWEIR'' = ANY(featurecat_id::text[])', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_frelem_eweir', 'form_feature', 'tab_data', 'category_type', 'lyt_data_1', 10, 'string', 'combo', 'Category Type', 'Category Type', NULL, false, false, true, false, NULL, 'SELECT category_type as id, category_type as idval FROM man_type_category WHERE feature_type = ''ELEMENT'' OR ''EWEIR'' = ANY(featurecat_id::text[])', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_frelem_eweir', 'form_feature', 'tab_data', 'location_type', 'lyt_data_1', 11, 'string', 'combo', 'Location Type', 'Location Type', NULL, false, false, true, false, NULL, 'SELECT location_type as id, location_type as idval FROM man_type_location WHERE feature_type = ''ELEMENT'' OR ''EWEIR'' = ANY(featurecat_id::text[])', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_frelem_eweir', 'form_feature', 'tab_features', 'btn_delete', 'lyt_features_1', 2, NULL, 'button', NULL, NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{
  "icon": "112"
}'::json, '{
  "saveValue": false
}'::json,
'{
  "functionName": "delete_object",
  "parameters": {
    "columnfind": "element_id",
    "targetwidget": "tab_features_tbl_element",
    "sourceview": "element"
  }
}'::json, NULL, false, NULL),
('ve_frelem_eweir', 'form_feature', 'tab_features', 'btn_expr_select', 'lyt_features_1', 4, NULL, 'button', NULL, NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{
  "icon": "178"
}'::json, '{
  "saveValue": false
}'::json, NULL, NULL, false, NULL),
('ve_frelem_eweir', 'form_feature', 'tab_features', 'feature_id', 'lyt_features_1', 0, 'text', 'text', NULL, NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL),
('ve_frelem_eweir', 'form_feature', 'tab_features', 'btn_snapping', 'lyt_features_1', 3, NULL, 'button', NULL, NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{
  "icon": "137"
}'::json, '{
  "saveValue": false
}'::json, '{
  "functionName": "selection_init"
}'::json, NULL, false, NULL),
('ve_frelem_eweir', 'form_feature', 'tab_features', 'tbl_element_x_arc', 'lyt_features_2_arc', 0, NULL, 'tableview', '', '', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_arc",
  "featureType": "arc"
}'::json, NULL, 'tbl_element_x_arc', false, NULL),
('ve_frelem_eweir', 'form_feature', 'tab_features', 'tbl_element_x_connec', 'lyt_features_2_connec', 0, NULL, 'tableview', '', '', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_connec",
  "featureType": "connec"
}'::json, NULL, 'tbl_element_x_connec', false, NULL),
('ve_frelem_eweir', 'form_feature', 'tab_features', 'tbl_element_x_gully', 'lyt_features_2_gully', 0, NULL, 'tableview', '', '', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_gully",
  "featureType": "gully"
}'::json, NULL, 'tbl_element_x_gully', false, NULL),
('ve_frelem_eweir', 'form_feature', 'tab_features', 'tbl_element_x_link', 'lyt_features_2_link', 0, NULL, 'tableview', '', '', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_link",
  "featureType": "link"
}'::json, NULL, 'tbl_element_x_link', false, NULL),
('ve_frelem_eweir', 'form_feature', 'tab_features', 'tbl_element_x_node', 'lyt_features_2_node', 0, NULL, 'tableview', '', '', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_node",
  "featureType": "node"
}'::json, NULL, 'tbl_element_x_node', false, NULL),
('ve_frelem_eweir', 'form_feature', 'tab_features', 'btn_insert', 'lyt_features_1', 1, NULL, 'button', NULL, NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{
  "icon": "111"
}'::json, '{
  "saveValue": false
}'::json,
'{
  "functionName": "insert_feature",
  "parameters": {
    "targetwidget": "tab_features_feature_id"
  }
}'::json, NULL, false, NULL)
ON CONFLICT (formname, formtype, tabname, columnname) DO UPDATE SET
  layoutname = EXCLUDED.layoutname,
  layoutorder = EXCLUDED.layoutorder,
  datatype = EXCLUDED.datatype,
  widgettype = EXCLUDED.widgettype,
  label = EXCLUDED.label,
  tooltip = EXCLUDED.tooltip,
  placeholder = EXCLUDED.placeholder,
  ismandatory = EXCLUDED.ismandatory,
  isparent = EXCLUDED.isparent,
  iseditable = EXCLUDED.iseditable,
  isautoupdate = EXCLUDED.isautoupdate,
  isfilter = EXCLUDED.isfilter,
  dv_querytext = EXCLUDED.dv_querytext,
  dv_orderby_id = EXCLUDED.dv_orderby_id,
  dv_isnullvalue = EXCLUDED.dv_isnullvalue,
  dv_parent_id = EXCLUDED.dv_parent_id,
  stylesheet = EXCLUDED.stylesheet,
  widgetcontrols = EXCLUDED.widgetcontrols,
  widgetfunction = EXCLUDED.widgetfunction,
  linkedobject = EXCLUDED.linkedobject,
  hidden = EXCLUDED.hidden,
  web_layoutorder = EXCLUDED.web_layoutorder;

-- ve_epa_frweir
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES
('ve_epa_frweir', 'form_feature', 'tab_epa', 'weir_type', 'lyt_epa_data_1', 0, 'string', 'combo', 'Weir Type', 'Weir Type', NULL, false, false, true, false, NULL, 'SELECT id, id as idval FROM sys_feature_epa_type WHERE active AND feature_type = ''ELEMENT''', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frweir', 'form_feature', 'tab_epa', 'offsetval', 'lyt_epa_data_1', 1, 'double', 'text', 'Offset Value', 'Offset Value', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frweir', 'form_feature', 'tab_epa', 'cd', 'lyt_epa_data_1', 2, 'double', 'text', 'Discharge Coefficient', 'Discharge Coefficient', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frweir', 'form_feature', 'tab_epa', 'ec', 'lyt_epa_data_1', 3, 'double', 'text', 'End Contractions', 'End Contractions', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frweir', 'form_feature', 'tab_epa', 'cd2', 'lyt_epa_data_1', 4, 'double', 'text', 'Discharge Coefficient 2', 'Discharge Coefficient 2', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frweir', 'form_feature', 'tab_epa', 'flap', 'lyt_epa_data_1', 5, 'boolean', 'check', 'Flap', 'Flap', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frweir', 'form_feature', 'tab_epa', 'geom1', 'lyt_epa_data_1', 6, 'double', 'text', 'Geom1', 'Geom1', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frweir', 'form_feature', 'tab_epa', 'geom2', 'lyt_epa_data_1', 7, 'double', 'text', 'Geom2', 'Geom2', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frweir', 'form_feature', 'tab_epa', 'geom3', 'lyt_epa_data_1', 8, 'double', 'text', 'Geom3', 'Geom3', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frweir', 'form_feature', 'tab_epa', 'geom4', 'lyt_epa_data_1', 9, 'double', 'text', 'Geom4', 'Geom4', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frweir', 'form_feature', 'tab_epa', 'surcharge', 'lyt_epa_data_1', 10, 'double', 'text', 'Surcharge', 'Surcharge', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frweir', 'form_feature', 'tab_epa', 'road_width', 'lyt_epa_data_1', 11, 'double', 'text', 'Road Width', 'Road Width', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frweir', 'form_feature', 'tab_epa', 'road_surf', 'lyt_epa_data_1', 12, 'string', 'text', 'Road Surface', 'Road Surface', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frweir', 'form_feature', 'tab_epa', 'coef_curve', 'lyt_epa_data_1', 13, 'string', 'text', 'Coefficient Curve', 'Coefficient Curve', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frweir', 'form_feature', 'tab_epa', 'max_flow', 'lyt_epa_data_2', 0, 'double', 'text', 'Maximum Flow', 'Maximum Flow', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frweir', 'form_feature', 'tab_epa', 'time_days', 'lyt_epa_data_2', 1, 'integer', 'text', 'Time Days', 'Time Days', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frweir', 'form_feature', 'tab_epa', 'time_hour', 'lyt_epa_data_2', 2, 'integer', 'text', 'Time Hour', 'Time Hour', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frweir', 'form_feature', 'tab_epa', 'max_veloc', 'lyt_epa_data_2', 3, 'double', 'text', 'Maximum Velocity', 'Maximum Velocity', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frweir', 'form_feature', 'tab_epa', 'mfull_flow', 'lyt_epa_data_2', 4, 'double', 'text', 'Full Flow', 'Full Flow', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frweir', 'form_feature', 'tab_epa', 'mfull_dept', 'lyt_epa_data_2', 5, 'double', 'text', 'Full Depth', 'Full Depth', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frweir', 'form_feature', 'tab_epa', 'max_shear', 'lyt_epa_data_2', 6, 'double', 'text', 'Maximum Shear', 'Maximum Shear', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frweir', 'form_feature', 'tab_epa', 'max_hr', 'lyt_epa_data_2', 7, 'double', 'text', 'Maximum Hydraulic Radius', 'Maximum Hydraulic Radius', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frweir', 'form_feature', 'tab_epa', 'max_slope', 'lyt_epa_data_2', 8, 'double', 'text', 'Maximum Slope', 'Maximum Slope', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frweir', 'form_feature', 'tab_epa', 'day_max', 'lyt_epa_data_2', 9, 'integer', 'text', 'Day Maximum', 'Day Maximum', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frweir', 'form_feature', 'tab_epa', 'time_max', 'lyt_epa_data_2', 10, 'integer', 'text', 'Time Maximum', 'Time Maximum', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frweir', 'form_feature', 'tab_epa', 'min_shear', 'lyt_epa_data_2', 11, 'double', 'text', 'Minimum Shear', 'Minimum Shear', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frweir', 'form_feature', 'tab_epa', 'day_min', 'lyt_epa_data_2', 12, 'integer', 'text', 'Day Minimum', 'Day Minimum', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL),
('ve_epa_frweir', 'form_feature', 'tab_epa', 'time_min', 'lyt_epa_data_2', 13, 'integer', 'text', 'Time Minimum', 'Time Minimum', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);

UPDATE config_form_fields SET widgetfunction='{
  "functionName": "open_selected_manager_item",
  "parameters": {
    "columnfind": "element_id"
  }
}'::json WHERE formname='gully' AND formtype='form_feature' AND columnname='tbl_elements' AND tabname='tab_elements';

UPDATE config_form_fields SET widgetfunction='{
  "functionName": "open_selected_manager_item",
  "parameters": {
    "columnfind": "element_id",
    "targetwidget": "tab_elements_tbl_elements"
  }
}'::json WHERE formname='gully' AND formtype='form_feature' AND columnname='open_element' AND tabname='tab_elements';


UPDATE config_form_fields SET "label"='Maximum Pipe diameter:', tooltip='Maximum Pipe diameter' WHERE formname='generic' AND formtype='link_to_gully' AND columnname='pipe_diameter' AND tabname='tab_none';

-- Massive update cause dma_id dissapears on ud projects
UPDATE config_form_fields SET columnname = 'omzone_id', label = 'omzone', tooltip = 'omzone_id' WHERE columnname = 'dma_id';

UPDATE config_form_tabs SET tabactions='[
  {
    "actionName": "actionEdit",
    "disabled": false
  },
  {
    "actionName": "actionSetToArc",
    "disabled": false
  },
  {
    "actionName": "actionSetGeom",
    "disabled": false
  }
]'::json WHERE formname='ve_frelem' AND tabname='tab_data';

UPDATE config_form_fields SET widgetfunction='{
  "functionName": "manage_element_menu",
  "parameters": {}
}'::json WHERE formname='gully' AND formtype='form_feature' AND columnname='new_element' AND tabname='tab_elements';


INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3702, 'New scenario type %v_type% with name ''%v_name%'' and id ''%v_scenarioid%'' have been created.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3704, 'INFO: %v_count% features have been inserted on table %v_targettable%.', null, 0, true, 'utils', 'core', 'AUDIT');




ALTER TABLE cat_feature DISABLE TRIGGER gw_trg_cat_feature_after;

INSERT INTO sys_feature_class (id, type, epa_default, man_table) VALUES ('VLINK', 'LINK', 'VIRTUAL', 'man_vlink');
INSERT INTO sys_feature_class (id, type, epa_default, man_table) VALUES ('VGULLY', 'GULLY', 'VIRTUAL', 'man_vgully');
INSERT INTO sys_feature_class (id, type, epa_default, man_table) VALUES ('VCONNEC', 'CONNEC', 'VIRTUAL', 'man_vconnec');
UPDATE sys_feature_class SET id = 'CONDUITLINK', man_table = 'man_conduitlink' WHERE id = 'LINK';
UPDATE sys_feature_class SET id = 'CJOIN', man_table = 'man_cjoin' WHERE id = 'CONNEC';
UPDATE sys_feature_class SET id = 'GINLET', man_table = 'man_ginlet' WHERE id = 'GULLY';

INSERT INTO cat_feature (id, feature_class, feature_type, parent_layer, child_layer, descript, active) VALUES ('VLINK', 'VLINK', 'LINK', 'v_edit_link', 've_link_vlink', 'Virtual link', true);

UPDATE cat_feature SET id = 'CONDUITLINK', child_layer = 've_link_conduitlink' WHERE id = 'LINK';
UPDATE cat_feature SET id = 'CJOIN', child_layer = 've_connec_cjoin' WHERE id = 'CONNEC';
UPDATE cat_feature SET id = 'GINLET', child_layer = 've_gully_ginlet' WHERE id = 'GULLY';

INSERT INTO cat_feature_link (id) VALUES ('VLINK');

UPDATE cat_feature SET feature_class = 'VCONNEC', feature_type = 'CONNEC', id = 'VCONNEC' WHERE id = 'VCONNEC';
UPDATE cat_feature SET feature_class = 'VGULLY', feature_type = 'GULLY', id = 'VGULLY' WHERE id = 'VGULLY';


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

UPDATE sys_table SET project_template='{"template": [1], "visibility": true, "levels_to_read": 2}'::jsonb WHERE id='v_edit_cat_feature_gully';
UPDATE sys_table SET project_template='{"template": [1], "visibility": false, "levels_to_read": 2}'::jsonb WHERE id='v_edit_drainzone';
UPDATE sys_table SET project_template='{"template": [1], "visibility": false, "levels_to_read": 2}'::jsonb WHERE id='v_edit_exploitation';
UPDATE sys_table SET project_template='{"template": [1], "visibility": true, "levels_to_read": 3}'::jsonb WHERE id='ve_pol_node';
UPDATE sys_table SET project_template='{"template": [1], "visibility": true, "levels_to_read": 2}'::jsonb WHERE id='v_ext_streetaxis';
UPDATE sys_table SET project_template='{"template": [1], "visibility": true, "levels_to_read": 2}'::jsonb WHERE id='v_edit_cat_feature_arc';
UPDATE sys_table SET project_template='{"template": [1], "visibility": true, "levels_to_read": 2}'::jsonb WHERE id='cat_node';
UPDATE sys_table SET project_template='{"template": [1], "visibility": true, "levels_to_read": 2}'::jsonb WHERE id='v_edit_cat_feature_connec';
UPDATE sys_table SET project_template='{"template": [1], "visibility": true, "levels_to_read": 2}'::jsonb, alias='Node' WHERE id='v_edit_node';
UPDATE sys_table SET project_template='{"template": [1], "visibility": true, "levels_to_read": 2}'::jsonb WHERE id='cat_material';
UPDATE sys_table SET project_template='{"template": [1], "visibility": true, "levels_to_read": 2}'::jsonb, alias='Municipality', orderBy = 1, context='{"levels": ["BASEMAP", "ADDRESS"]}' WHERE id='v_ext_municipality';
UPDATE sys_table SET project_template='{"template": [1], "visibility": true, "levels_to_read": 3}'::jsonb WHERE id='ve_pol_gully';
UPDATE sys_table SET project_template='{"template": [1], "visibility": true, "levels_to_read": 2}'::jsonb WHERE id='cat_gully';
UPDATE sys_table SET project_template='{"template": [1], "visibility": true, "levels_to_read": 2}'::jsonb, alias='Link' WHERE id='v_edit_link';
UPDATE sys_table SET project_template='{"template": [1], "visibility": false, "levels_to_read": 2}'::jsonb WHERE id='v_edit_dwfzone';
UPDATE sys_table SET project_template='{"template": [1], "visibility": true, "levels_to_read": 2}'::jsonb, alias='Gully' WHERE id='v_edit_gully';
UPDATE sys_table SET project_template='{"template": [1], "visibility": false, "levels_to_read": 2}'::jsonb WHERE id='v_edit_sector';
UPDATE sys_table SET project_template='{"template": [1], "visibility": false, "levels_to_read": 2}'::jsonb WHERE id='v_edit_macrosector';
UPDATE sys_table SET project_template='{"template": [1], "visibility": true, "levels_to_read": 3}'::jsonb WHERE id='ve_pol_connec';
UPDATE sys_table SET project_template='{"template": [1], "visibility": true, "levels_to_read": 2}'::jsonb WHERE id='v_edit_dimensions';
UPDATE sys_table SET project_template='{"template": [1], "visibility": false, "levels_to_read": 2}'::jsonb WHERE id='v_ext_address';
UPDATE sys_table SET project_template='{"template": [1], "visibility": true, "levels_to_read": 2}'::jsonb WHERE id='v_ext_plot';
UPDATE sys_table SET project_template='{"template": [1], "visibility": true, "levels_to_read": 2}'::jsonb, alias='Connec' WHERE id='v_edit_connec';
UPDATE sys_table SET project_template='{"template": [1], "visibility": true, "levels_to_read": 2}'::jsonb, alias='Arc' WHERE id='v_edit_arc';
UPDATE sys_table SET project_template='{"template": [1], "visibility": true, "levels_to_read": 2}'::jsonb WHERE id='cat_arc';
UPDATE sys_table SET project_template='{"template": [1], "visibility": true, "levels_to_read": 2}'::jsonb WHERE id='v_edit_cat_feature_node';
UPDATE sys_table SET project_template='{"template": [1], "visibility": true, "levels_to_read": 2}'::jsonb WHERE id='cat_connec';

UPDATE sys_style SET layername='v_ext_municipality' WHERE layername='ext_municipality' AND styleconfig_id=101;

DELETE FROM sys_table WHERE id = 'v_edit_link_connec';
DELETE FROM sys_table WHERE id = 'v_edit_link_gully';
DELETE FROM sys_table WHERE id = 've_link_link';

UPDATE config_typevalue SET addparam='{"orderBy":6}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["INVENTORY", "NETWORK", "POLYGON"]}';
UPDATE config_typevalue SET addparam='{"orderBy":5}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["INVENTORY", "NETWORK", "LINK"]}';
UPDATE config_typevalue SET addparam='{"orderBy":2}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["INVENTORY", "NETWORK", "ARC"]}';
UPDATE config_typevalue SET addparam='{"orderBy":3}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["INVENTORY", "NETWORK", "CONNEC"]}';
UPDATE config_typevalue SET addparam='{"orderBy":4}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["INVENTORY", "NETWORK", "GULLY"]}';
UPDATE config_typevalue SET addparam='{"orderBy":1}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["INVENTORY", "NETWORK", "NODE"]}';


UPDATE config_form_fields SET ismandatory=false, iseditable=false WHERE formname = 'v_edit_arc' AND formtype='form_feature' AND columnname='fluid_type' AND tabname='tab_data';
UPDATE config_form_fields SET ismandatory=false, iseditable=false WHERE formname ILIKE 've_arc%' AND formtype='form_feature' AND columnname='fluid_type' AND tabname='tab_data';
UPDATE config_form_fields SET ismandatory=false, iseditable=false WHERE formname = 'v_edit_node' AND formtype='form_feature' AND columnname='fluid_type' AND tabname='tab_data';
UPDATE config_form_fields SET ismandatory=false, iseditable=false WHERE formname ILIKE 've_node%' AND formtype='form_feature' AND columnname='fluid_type' AND tabname='tab_data';
UPDATE config_form_fields SET ismandatory=true, iseditable=true WHERE formname = 'v_edit_connec' AND formtype='form_feature' AND columnname='fluid_type' AND tabname='tab_data';
UPDATE config_form_fields SET ismandatory=true, iseditable=true WHERE formname ILIKE 've_connec%' AND formtype='form_feature' AND columnname='fluid_type' AND tabname='tab_data';
UPDATE config_form_fields SET ismandatory=true, iseditable=true WHERE formname='v_edit_gully' AND formtype='form_feature' AND columnname='fluid_type' AND tabname='tab_data';
UPDATE config_form_fields SET ismandatory=true, iseditable=true WHERE formname ILIKE 've_gully%' AND formtype='form_feature' AND columnname='fluid_type' AND tabname='tab_data';


INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_data', 'expl_id', 'lyt_bot_1', 1, 'integer', 'combo', 'Explotation ID', 'expl_id - Exploitation to which the element belongs. If the configuration is not changed, the program automatically selects it based on the geometry', NULL, false, false, false, false, NULL, 'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL', true, false, NULL, NULL, '{"label":"color:red; font-weight:bold"}'::json, '{
  "setMultiline": false,
  "labelPosition": "top",
  "valueRelation": {
    "nullValue": false,
    "layer": "v_edit_exploitation",
    "activated": true,
    "keyColumn": "expl_id",
    "valueColumn": "name",
    "filterExpression": null
  }
}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_data', 'sector_id', 'lyt_bot_1', 2, 'integer', 'combo', 'Sector ID', 'sector_id  - Sector identifier.', NULL, false, false, false, false, NULL, 'SELECT sector_id as id, name as idval FROM sector WHERE sector_id IS NOT NULL', true, false, NULL, NULL, '{"label":"color:red; font-weight:bold"}'::json, '{"setMultiline": false, "labelPosition": "top", "valueRelation": {"layer": "v_edit_sector", "activated": true, "keyColumn": "sector_id", "nullValue": false, "valueColumn": "name", "filterExpression": null}}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_data', 'dqa_id', 'lyt_bot_1', 3, 'integer', 'text', 'Dqa', 'dqa_id', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_data', 'state', 'lyt_bot_1', 4, 'integer', 'combo', 'State:', 'State:', NULL, false, false, true, false, NULL, 'SELECT id, name as idval FROM value_state WHERE id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_data', 'state_type', 'lyt_bot_1', 5, 'integer', 'combo', 'State type', 'state_type - The state type of the element. It allows to obtain more detail of the state. To select from those available depending on the chosen state', NULL, false, false, true, false, NULL, 'SELECT id, name as idval FROM value_state_type WHERE id IS NOT NULL', true, false, 'state', ' AND value_state_type.state', NULL, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_data', 'link_id', 'lyt_data_1', 1, 'integer', 'text', 'Link ID', 'Link ID', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_data', 'feature_type', 'lyt_data_1', 2, 'string', 'combo', 'Feature type', 'Feature type', NULL, false, false, false, false, NULL, 'SELECT id, id as idval FROM sys_feature_type WHERE id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_data', 'feature_id', 'lyt_data_1', 3, 'string', 'text', 'feature_id', 'feature_id', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_data', 'exit_type', 'lyt_data_1', 4, 'string', 'combo', 'Exit type', 'Exit type', NULL, false, false, false, false, NULL, 'SELECT id, idval FROM inp_typevalue WHERE typevalue=''inp_pjoint_type''', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_data', 'exit_id', 'lyt_data_1', 5, 'string', 'text', 'Exit ID', 'Exit ID', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_data', 'omzone_id', 'lyt_data_1', 6, 'integer', 'combo', 'Omzone ID', 'Omzone ID', NULL, false, false, false, false, NULL, 'SELECT omzone_id as id, name as idval FROM omzone WHERE omzone_id = 0 UNION SELECT omzone_id as id, name as idval FROM omzone WHERE omzone_id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "v_edit_dma", "activated": true, "keyColumn": "dma_id", "valueColumn": "name", "filterExpression": null}}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_data', 'presszone_id', 'lyt_data_1', 7, 'integer', 'text', 'Presszone', 'presszone_id', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_data', 'minsector_id', 'lyt_data_1', 8, 'integer', 'text', 'minsector_id', 'minsector_id', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_data', 'fluid_type', 'lyt_data_1', 9, 'string', 'text', 'fluid_type', 'fluid_type', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_data', 'gis_length', 'lyt_data_1', 10, 'double', 'text', 'Gis length', 'Gis length', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_data', 'sector_name', 'lyt_data_1', 11, 'string', 'text', 'sector_name', 'sector_name', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_data', 'dma_name', 'lyt_data_1', 12, 'string', 'text', 'dma_name', 'dma_name', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_data', 'dqa_name', 'lyt_data_1', 13, 'string', 'text', 'dqa_name', 'dqa_name', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_data', 'presszone_name', 'lyt_data_1', 14, 'string', 'text', 'presszone_name', 'presszone_name', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_data', 'macroomzone_id', 'lyt_data_1', 15, 'integer', 'text', 'Macroomzone ID', 'Macroomzone ID', NULL, false, false, false, false, NULL, 'SELECT macroomzone_id as id, name as idval FROM macroomzone WHERE macroomzone_id IS NOT NULL', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_data', 'macrosector_id', 'lyt_data_1', 16, 'integer', 'combo', 'Macrosector id', 'Macrosector id', NULL, false, false, false, false, NULL, 'SELECT macrosector_id as id, name as idval FROM macrosector WHERE macrosector_id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_data', 'macrodqa_id', 'lyt_data_2', 1, 'integer', 'text', 'macrodqa_id', 'macrodqa_id', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_data', 'epa_type', 'lyt_data_2', 2, 'string', 'text', 'epa_type', 'epa_type', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_data', 'is_operative', 'lyt_data_2', 3, 'boolean', 'check', 'is_operative', 'is_operative', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_data', 'conneccat_id', 'lyt_data_2', 4, 'string', 'typeahead', 'Connecat ID', 'connecat_id - A seleccionar del catálogo de acometida. Es independiente del tipo de acometida', NULL, false, false, false, false, NULL, 'SELECT id, id as idval FROM cat_connec WHERE id IS NOT NULL AND active IS TRUE ', true, NULL, NULL, NULL, NULL, '{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "cat_connec", "activated": true, "keyColumn": "id", "valueColumn": "id", "filterExpression": null}}'::json, NULL, 'action_catalog', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_data', 'workcat_id', 'lyt_data_2', 5, 'string', 'typeahead', 'Workcat ID', 'workcat_id - Related to the catalog of work files (cat_work). File that registers the element', NULL, false, false, true, false, NULL, 'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE ', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'action_workcat', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_data', 'workcat_id_end', 'lyt_data_2', 6, 'string', 'typeahead', 'Workcat ID end', 'workcat_id_end - ID of the  end of construction work.', 'Only when state is obsolete', false, false, true, false, NULL, 'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE ', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_data', 'builtdate', 'lyt_data_2', 7, 'date', 'datetime', 'Builtdate:', 'builtdate - Date the element was added. In insertion of new elements the date of the day is shown', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_data', 'enddate', 'lyt_data_2', 8, 'date', 'datetime', 'Enddate', 'enddate - End date of the element. It will only be filled in if the element is in a deregistration state.', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_data', 'uncertain', 'lyt_data_2', 9, 'boolean', 'check', 'Uncertain', 'uncertain - To set if the element''s location is uncertain', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, true, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_data', 'top_elev1', 'lyt_data_2', 10, 'integer', 'text', 'Top Elev 1', 'top_elev1', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_data', 'depth1', 'lyt_data_2', 11, 'integer', 'text', 'Depth1', 'depth1', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_data', 'elevation1', 'lyt_data_2', 12, 'integer', 'text', 'Elevation1', 'elevation1', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_data', 'top_elev2', 'lyt_data_2', 13, 'integer', 'text', 'Top elev 2', 'top_elev2', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_data', 'depth2', 'lyt_data_2', 14, 'integer', 'text', 'Depth2', 'depth2', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_data', 'elevation2', 'lyt_data_2', 15, 'integer', 'text', 'Elevation2', 'elevation2', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_documents', 'date_to', 'lyt_document_1', 2, 'date', 'datetime', 'Date to:', 'Date to:', NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{"labelPosition": "top", "filterSign":"<="}'::json, '{"functionName": "filter_table", "parameters":{"columnfind": "date"}}'::json, 'tbl_doc_x_link', false, 2);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_documents', 'doc_type', 'lyt_document_1', 3, 'string', 'combo', 'Doc type:', 'Doc type:', NULL, false, false, true, false, true, 'SELECT id, idval FROM edit_typevalue WHERE typevalue = ''doc_type''', NULL, true, NULL, NULL, NULL, '{"labelPosition": "top"}'::json, '{"functionName": "filter_table", "parameters":{}}'::json, 'tbl_doc_x_link', false, 3);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_documents', 'doc_name', 'lyt_document_2', 1, 'string', 'typeahead', 'Doc id:', 'Doc id:', NULL, false, false, true, false, false, 'SELECT name as id, name as idval FROM doc WHERE name IS NOT NULL', NULL, NULL, NULL, NULL, NULL, '{"saveValue": false, "filterSign":"ILIKE"}'::json, '{"functionName": "filter_table"}'::json, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_documents', 'btn_doc_insert', 'lyt_document_2', 2, NULL, 'button', NULL, 'Insert document', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"113"}'::json, '{"saveValue":false, "filterSign":"="}'::json, '{
  "functionName": "add_object",
  "parameters": {
    "sourcewidget": "tab_documents_doc_name",
    "targetwidget": "tab_documents_tbl_documents",
    "sourceview": "doc"
  }
}'::json, 'tbl_doc_x_link', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_documents', 'btn_doc_delete', 'lyt_document_2', 3, NULL, 'button', NULL, 'Delete document', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"114"}'::json, '{"saveValue":false, "filterSign":"=", "onContextMenu":"Delete document"}'::json, '{"functionName": "delete_object", "parameters": {"columnfind": "doc_id", "targetwidget": "tab_documents_tbl_documents", "sourceview": "doc"}}'::json, 'tbl_doc_x_link', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_documents', 'btn_doc_new', 'lyt_document_2', 4, NULL, 'button', NULL, 'New document', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"143"}'::json, '{"saveValue":false, "filterSign":"="}'::json, '{
  "functionName": "manage_document",
  "parameters": {
    "sourcewidget": "tab_documents_doc_name",
    "targetwidget": "tab_documents_tbl_documents",
    "sourceview": "doc"
  }
}'::json, 'tbl_doc_x_link', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_documents', 'hspacer_document_1', 'lyt_document_2', 5, NULL, 'hspacer', NULL, NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_documents', 'open_doc', 'lyt_document_2', 6, NULL, 'button', NULL, 'Open document', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"147"}'::json, '{"saveValue":false, "filterSign":"=", "onContextMenu":"Open document"}'::json, '{
  "functionName": "open_selected_path",
  "parameters": {
    "columnfind": "path",
    "targetwidget": "tab_documents_tbl_documents",
    "sourceview": "doc"
  }
}'::json, 'tbl_doc_x_link', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_documents', 'tbl_documents', 'lyt_document_3', 1, NULL, 'tableview', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"saveValue": false}'::json, '{
  "functionName": "open_selected_path",
  "parameters": {
    "targetwidget": "tab_documents_tbl_documents",
    "columnfind": "path"
  }
}'::json, 'tbl_doc_x_link', false, 4);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_elements', 'element_id', 'lyt_element_1', 1, 'string', 'typeahead', 'Element id:', 'Element id', NULL, false, false, true, false, false, 'SELECT element_id as id, element_id as idval FROM element WHERE element_id IS NOT NULL ', NULL, NULL, NULL, NULL, NULL, '{"saveValue": false, "filterSign":"ILIKE"}'::json, '{"functionName": "filter_table", "parameters" : { "columnfind": "id"}}'::json, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_elements', 'insert_element', 'lyt_element_1', 2, NULL, 'button', NULL, 'Insert element', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"113"}'::json, '{"saveValue":false, "filterSign":"="}'::json, '{
	  "functionName": "add_object",
	  "parameters": {
	    "sourcewidget": "tab_elements_element_id",
	    "targetwidget": "tab_elements_tbl_elements",
	    "sourceview": "element"
	  }
	}'::json, 'v_edit_link', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_elements', 'delete_element', 'lyt_element_1', 3, NULL, 'button', NULL, 'Delete element', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"114"}'::json, '{"saveValue":false, "filterSign":"=", "onContextMenu":"Delete element"}'::json, '{ "functionName": "delete_object", "parameters": {"columnfind": "element_id", "targetwidget": "tab_elements_tbl_elements", "sourceview": "element"}}'::json, 'tbl_element_x_link', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_elements', 'new_element', 'lyt_element_1', 4, NULL, 'button', NULL, 'New element', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"143"}'::json, '{"saveValue":false, "filterSign":"="}'::json, '{
  "functionName": "manage_element_menu",
  "parameters": {
    "sourcetable": "v_ui_element_x_arc",
    "targetwidget": "tab_elements_tbl_elements",
    "field_object_id": "element_id",
    "sourceview": "element"
  }
}'::json, 'v_edit_link', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_elements', 'hspacer_lyt_element', 'lyt_element_1', 5, NULL, 'hspacer', NULL, NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_elements', 'open_element', 'lyt_element_1', 6, NULL, 'button', NULL, 'Open element', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"144"}'::json, '{"saveValue":false, "filterSign":"=", "onContextMenu":"Open element"}'::json, '{
  "functionName": "open_selected_manager_item",
  "parameters": {
    "columnfind": "element_id",
    "targetwidget": "tab_elements_tbl_elements"
  }
}'::json, 'v_edit_link', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_elements', 'btn_link', 'lyt_element_1', 7, NULL, 'button', NULL, 'Open link', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"173"}'::json, '{"saveValue":false, "filterSign":"=", "onContextMenu":"Open link"}'::json, '{
  "functionName": "open_selected_path",
  "parameters": {
    "targetwidget": "tab_elements_tbl_elements",
    "columnfind": "link_id"
  }
}'::json, 'v_edit_link', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_elements', 'tbl_elements', 'lyt_element_3', 1, NULL, 'tableview', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"saveValue": false}'::json, '{
  "functionName": "open_selected_manager_item",
  "parameters": {
    "columnfind": "element_id"
  }
}'::json, 'tbl_element_x_link', false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_data', 'linkcat_id', 'lyt_top_1', 2, 'string', 'typeahead', 'Linkcat ID', 'linkcat_id - To be selected from the catalog of arcs. It is independent of the type of arch', NULL, true, false, true, false, NULL, 'SELECT id, id as idval FROM cat_link WHERE id IS NOT NULL AND active IS TRUE ', NULL, NULL, 'link_type', ' AND cat_link.link_type IS NULL OR cat_link.link_type', NULL, '{
  "setMultiline": false,
  "labelPosition": "top",
  "valueRelation": {
    "layer": "cat_link",
    "activated": true,
    "keyColumn": "id",
    "nullValue": false,
    "valueColumn": "id",
    "filterExpression": null
  }
}'::json, NULL, NULL, false, 3);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_conduitlink', 'form_feature', 'tab_data', 'link_type', 'lyt_top_1', 1, 'string', 'combo', 'Link Type', 'Type of link. It is auto-populated based on the linkcat_id', NULL, true, true, false, false, NULL, 'SELECT id, id as idval FROM cat_feature_link WHERE id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline": false, "labelPosition": "top", "valueRelation": {"layer": "v_edit_cat_feature_link", "activated": true, "keyColumn": "id", "nullValue": false, "valueColumn": "id", "filterExpression": null}}'::json, NULL, NULL, false, 2);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'expl_id', 'lyt_bot_1', 1, 'integer', 'combo', 'Explotation ID', 'expl_id - Exploitation to which the element belongs. If the configuration is not changed, the program automatically selects it based on the geometry', NULL, false, false, false, false, NULL, 'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL', true, false, NULL, NULL, '{"label":"color:red; font-weight:bold"}'::json, '{
  "setMultiline": false,
  "labelPosition": "top",
  "valueRelation": {
    "nullValue": false,
    "layer": "v_edit_exploitation",
    "activated": true,
    "keyColumn": "expl_id",
    "valueColumn": "name",
    "filterExpression": null
  }
}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'sector_id', 'lyt_bot_1', 2, 'integer', 'combo', 'Sector ID', 'sector_id  - Sector identifier.', NULL, false, false, false, false, NULL, 'SELECT sector_id as id, name as idval FROM sector WHERE sector_id IS NOT NULL', true, false, NULL, NULL, '{"label":"color:red; font-weight:bold"}'::json, '{"setMultiline": false, "labelPosition": "top", "valueRelation": {"layer": "v_edit_sector", "activated": true, "keyColumn": "sector_id", "nullValue": false, "valueColumn": "name", "filterExpression": null}}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'dqa_id', 'lyt_bot_1', 3, 'integer', 'text', 'Dqa', 'dqa_id', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'state', 'lyt_bot_1', 4, 'integer', 'combo', 'State:', 'State:', NULL, false, false, true, false, NULL, 'SELECT id, name as idval FROM value_state WHERE id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'state_type', 'lyt_bot_1', 5, 'integer', 'combo', 'State type', 'state_type - The state type of the element. It allows to obtain more detail of the state. To select from those available depending on the chosen state', NULL, false, false, true, false, NULL, 'SELECT id, name as idval FROM value_state_type WHERE id IS NOT NULL', true, false, 'state', ' AND value_state_type.state', NULL, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'link_id', 'lyt_data_1', 1, 'integer', 'text', 'Link ID', 'Link ID', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'feature_type', 'lyt_data_1', 2, 'string', 'combo', 'Feature type', 'Feature type', NULL, false, false, false, false, NULL, 'SELECT id, id as idval FROM sys_feature_type WHERE id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'feature_id', 'lyt_data_1', 3, 'string', 'text', 'feature_id', 'feature_id', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'exit_type', 'lyt_data_1', 4, 'string', 'combo', 'Exit type', 'Exit type', NULL, false, false, false, false, NULL, 'SELECT id, idval FROM inp_typevalue WHERE typevalue=''inp_pjoint_type''', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'exit_id', 'lyt_data_1', 5, 'string', 'text', 'Exit ID', 'Exit ID', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'omzone_id', 'lyt_data_1', 6, 'integer', 'combo', 'Omzone ID', 'Omzone ID', NULL, false, false, false, false, NULL, 'SELECT omzone_id as id, name as idval FROM omzone WHERE omzone_id = 0 UNION SELECT omzone_id as id, name as idval FROM omzone WHERE omzone_id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "v_edit_dma", "activated": true, "keyColumn": "dma_id", "valueColumn": "name", "filterExpression": null}}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'presszone_id', 'lyt_data_1', 7, 'integer', 'text', 'Presszone', 'presszone_id', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'minsector_id', 'lyt_data_1', 8, 'integer', 'text', 'minsector_id', 'minsector_id', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'fluid_type', 'lyt_data_1', 9, 'string', 'text', 'fluid_type', 'fluid_type', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'gis_length', 'lyt_data_1', 10, 'double', 'text', 'Gis length', 'Gis length', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'sector_name', 'lyt_data_1', 11, 'string', 'text', 'sector_name', 'sector_name', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'dma_name', 'lyt_data_1', 12, 'string', 'text', 'dma_name', 'dma_name', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'dqa_name', 'lyt_data_1', 13, 'string', 'text', 'dqa_name', 'dqa_name', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'presszone_name', 'lyt_data_1', 14, 'string', 'text', 'presszone_name', 'presszone_name', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'macroomzone_id', 'lyt_data_1', 15, 'integer', 'text', 'Macroomzone ID', 'Macroomzone ID', NULL, false, false, false, false, NULL, 'SELECT macroomzone_id as id, name as idval FROM macroomzone WHERE macroomzone_id IS NOT NULL', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'macrosector_id', 'lyt_data_1', 16, 'integer', 'combo', 'Macrosector id', 'Macrosector id', NULL, false, false, false, false, NULL, 'SELECT macrosector_id as id, name as idval FROM macrosector WHERE macrosector_id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
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
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'linkcat_id', 'lyt_top_1', 2, 'string', 'typeahead', 'Linkcat ID', 'linkcat_id - To be selected from the catalog of arcs. It is independent of the type of arch', NULL, true, false, true, false, NULL, 'SELECT id, id as idval FROM cat_link WHERE id IS NOT NULL AND active IS TRUE ', NULL, NULL, 'link_type', ' AND cat_link.link_type IS NULL OR cat_link.link_type', NULL, '{
  "setMultiline": false,
  "labelPosition": "top",
  "valueRelation": {
    "layer": "cat_link",
    "activated": true,
    "keyColumn": "id",
    "nullValue": false,
    "valueColumn": "id",
    "filterExpression": null
  }
}'::json, NULL, NULL, false, 3);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'link_type', 'lyt_top_1', 1, 'string', 'combo', 'Link Type', 'Type of link. It is auto-populated based on the linkcat_id', NULL, true, true, false, false, NULL, 'SELECT id, id as idval FROM cat_feature_link WHERE id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline": false, "labelPosition": "top", "valueRelation": {"layer": "v_edit_cat_feature_link", "activated": true, "keyColumn": "id", "nullValue": false, "valueColumn": "id", "filterExpression": null}}'::json, NULL, NULL, false, 2);



UPDATE sys_function SET function_alias = 'ARC ELEVATION ANALYSIS' WHERE function_name = 'gw_fct_anl_arc_elev';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3960, 'There are no arcs with both values of y and elev inserted.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3962, 'There are %v_count% arcs with both values of y and elev inserted.', null, 0, true, 'utils', 'core', 'AUDIT');

UPDATE sys_function SET function_alias = 'ARC INTERSECTION ANALYSIS' WHERE function_name = 'gw_fct_anl_arc_intersection';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3964, 'There are no intersected arcs.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3966, 'There are %v_count% intersected arcs.', null, 0, true, 'utils', 'core', 'AUDIT');

UPDATE sys_function SET function_alias = 'ARC INVERTED ANALYSIS' WHERE function_name = 'gw_fct_anl_arc_inverted';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3968, 'The analysis have been executed skipping arcs with TRUE value on ''inverted_slope'' column', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3970, 'If some resultant arc is really an arc with inverted slope, please set this value to TRUE', null, 0, true, 'utils', 'core', 'AUDIT');

UPDATE sys_function SET function_alias = 'OUTFALL NODE ANALYSIS' WHERE function_name = 'gw_fct_anl_node_sink';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3972, 'The analysis have been executed skipping nodes with ''VERIFIED'' on colum verified', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3974, 'If you are looking to remove results please set column verified with this value', null, 0, true, 'utils', 'core', 'AUDIT');

UPDATE sys_function SET function_alias = 'NODE ELEVATION ANALYSIS' WHERE function_name = 'gw_fct_anl_node_elev';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3976, 'There are no nodes with all values of top_elev, ymax and elev inserted.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3978, 'There are %v_count% nodes with all values of top_elev, ymax and elev inserted.', null, 0, true, 'utils', 'core', 'AUDIT');



UPDATE sys_function SET function_alias = 'NODE FLOW REGULATOR ANALYSIS' WHERE function_name = 'gw_fct_anl_node_flowregulator';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3980, 'The analysis have been executed skipping nodes with ''VERIFIED'' on colum verified', null, 0, true, 'utils', 'core', 'AUDIT');

UPDATE sys_function SET function_alias = 'NODE WITH EXIT ARC OVER ENTRY ARC ANALYSIS' WHERE function_name = 'gw_fct_anl_node_exit_upper_intro';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3982, 'There are no flow regulator nodes.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3984, 'There are %v_count% flow regulator nodes.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3986, 'There are no nodes with exit arc over entry arc.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3988, 'There are %v_count% nodes with exit arc over entry arc.', null, 0, true, 'utils', 'core', 'AUDIT');

UPDATE sys_function SET function_alias = 'SECTION CONTROL ANALYSIS' WHERE function_name = 'gw_graphanalytics_upstream_section_control';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3990, 'In order to execute the process you need to specify starting node_id.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3992, 'You can use outfalls without doing it and execute the process for the entire layer.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3994, 'Node %v_node_id% does''t exist in the selected layer.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3996, 'Choose another node to continue.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3998, 'There are no arcs with unconsistent sections.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4000, 'There are %v_count% arcs with section (geom1) bigger than the section of the following arc.', null, 0, true, 'utils', 'core', 'AUDIT');

UPDATE sys_function SET function_alias = 'SLOPE CONSISTENCY ANALYSIS' WHERE function_name = 'gw_fct_anl_slope_consistency';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4002, 'There are no slope inconsistencies.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4004, 'There are %v_count% arcs with slope inconsistency.', null, 0, true, 'utils', 'core', 'AUDIT');

UPDATE sys_function SET function_alias = 'HYDRAULIC PERFORMANCE FOR SPECIFIC RESULT' WHERE function_name = 'gw_fct_epa_hydraulic_performance';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4006, 'Result_id: %v_eparesult%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4008, 'WWTP outfall_id''s: %v_wwtpoutfalls%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4010, 'Total precipitation volume: %v_rain%  10^6 LTS', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4012, 'Total DWF volume: %v_dwf%  10^6 LTS', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4014, 'Total infil.losses volume: %v_inf%  10^6 LTS', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4016, 'Total WWTP volume: %v_wwtp%  10^6 LTS', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4018, 'Hydraulic performance for this result: %(100*v_performance)::numeric(12,2)% %', null, 0, true, 'utils', 'core', 'AUDIT');

--flowexit/flowtrace arc
UPDATE sys_style SET stylevalue='<!DOCTYPE qgis PUBLIC ''http://mrcc.com/qgis.dtd'' ''SYSTEM''>
<qgis styleCategories="Symbology" version="3.40.6-Bratislava">
  <renderer-v2 enableorderby="0" type="categorizedSymbol" referencescale="-1" attr="stream_type" forceraster="0" symbollevels="0">
    <categories>
      <category label="Mainstrem" render="true" value="mainstream" type="string" uuid="{97c88725-dc02-4a55-ad72-9315f4e7ff90}" symbol="0"/>
      <category label="Diverted flow" render="true" value="diverted flow" type="string" uuid="{5a3292b6-2305-4b89-a81a-2fb6eab28113}" symbol="1"/>
    </categories>
    <symbols>
      <symbol alpha="1" type="line" clip_to_extent="1" is_animated="0" name="0" frame_rate="10" force_rhr="0">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" type="QString" name="name"/>
            <Option name="properties"/>
            <Option value="collection" type="QString" name="type"/>
          </Option>
        </data_defined_properties>
        <layer id="{606db9a4-f11f-4d4f-ab44-db52cc28779e}" class="SimpleLine" locked="0" enabled="1" pass="0">
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
            <Option value="255,120,79,255,hsv:0.03888888888888889,0.69019607843137254,1,1" type="QString" name="line_color"/>
            <Option value="solid" type="QString" name="line_style"/>
            <Option value="0.86" type="QString" name="line_width"/>
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
      <symbol alpha="1" type="line" clip_to_extent="1" is_animated="0" name="1" frame_rate="10" force_rhr="0">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" type="QString" name="name"/>
            <Option name="properties"/>
            <Option value="collection" type="QString" name="type"/>
          </Option>
        </data_defined_properties>
        <layer id="{606db9a4-f11f-4d4f-ab44-db52cc28779e}" class="SimpleLine" locked="0" enabled="1" pass="0">
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
            <Option value="0,211,46,255,hsv:0.36969444444444444,1,0.82893110551613647,1" type="QString" name="line_color"/>
            <Option value="solid" type="QString" name="line_style"/>
            <Option value="0.86" type="QString" name="line_width"/>
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
    </symbols>
    <source-symbol>
      <symbol alpha="1" type="line" clip_to_extent="1" is_animated="0" name="0" frame_rate="10" force_rhr="0">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" type="QString" name="name"/>
            <Option name="properties"/>
            <Option value="collection" type="QString" name="type"/>
          </Option>
        </data_defined_properties>
        <layer id="{606db9a4-f11f-4d4f-ab44-db52cc28779e}" class="SimpleLine" locked="0" enabled="1" pass="0">
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
            <Option value="255,120,79,255,hsv:0.03888888888888889,0.69019607843137254,1,1" type="QString" name="line_color"/>
            <Option value="solid" type="QString" name="line_style"/>
            <Option value="0.86" type="QString" name="line_width"/>
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
    </source-symbol>
    <rotation/>
    <sizescale/>
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
      <symbol alpha="1" type="line" clip_to_extent="1" is_animated="0" name="" frame_rate="10" force_rhr="0">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" type="QString" name="name"/>
            <Option name="properties"/>
            <Option value="collection" type="QString" name="type"/>
          </Option>
        </data_defined_properties>
        <layer id="{50b9a837-2d81-443d-bd5e-f67b68309369}" class="SimpleLine" locked="0" enabled="1" pass="0">
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
            <Option value="35,35,35,255,rgb:0.13725490196078433,0.13725490196078433,0.13725490196078433,1" type="QString" name="line_color"/>
            <Option value="solid" type="QString" name="line_style"/>
            <Option value="0.26" type="QString" name="line_width"/>
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
    </selectionSymbol>
  </selection>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerGeometryType>1</layerGeometryType>
</qgis>' WHERE layername='line' AND styleconfig_id in (105,106);


--flowexit/flowtrace node
UPDATE sys_style SET stylevalue='<!DOCTYPE qgis PUBLIC ''http://mrcc.com/qgis.dtd'' ''SYSTEM''>
<qgis styleCategories="Symbology" version="3.40.6-Bratislava">
  <renderer-v2 enableorderby="0" type="RuleRenderer" referencescale="-1" forceraster="0" symbollevels="0">
    <rules key="{e4d87f5e-3fd2-4d97-8962-998d1cba9adf}">
      <rule label="Connec mainstream" filter="&quot;feature_type&quot; = ''CONNEC'' and  &quot;stream_type&quot;  =  ''mainstream'' " key="{9c94b1b8-8153-4cce-b198-b2bda93a93d6}" symbol="0"/>
      <rule label="Gully mainstream" filter=" &quot;feature_type&quot;  = ''GULLY'' and  &quot;stream_type&quot;  =  ''mainstream'' " key="{979e0699-2e15-403a-9c69-e30227975796}" symbol="1"/>
      <rule label="Node mainstream" filter=" &quot;feature_type&quot;  = ''NODE'' and  &quot;stream_type&quot;  =  ''mainstream'' " key="{a38e0b7e-b58a-4a05-baab-8018a82d3727}" symbol="2"/>
      <rule label="Connec diverted flow" filter="&quot;feature_type&quot; = ''CONNEC'' and  &quot;stream_type&quot; = ''diverted flow''" key="{b32d9276-a77a-4179-8d27-2b2015c5b2f1}" symbol="3"/>
      <rule label="Gully diverted flow" filter=" &quot;feature_type&quot;  = ''GULLY'' and  &quot;stream_type&quot;  =  ''diverted flow''" key="{10fed0c0-d299-4d2f-b388-0722768847f0}" symbol="4"/>
      <rule label="Node diverted flow" filter=" &quot;feature_type&quot;  = ''NODE'' and  &quot;stream_type&quot;  =  ''diverted flow''" key="{26c49b63-1fab-4676-afc2-37a7b531592c}" symbol="5"/>
    </rules>
    <symbols>
      <symbol alpha="1" type="marker" clip_to_extent="1" is_animated="0" name="0" frame_rate="10" force_rhr="0">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" type="QString" name="name"/>
            <Option name="properties"/>
            <Option value="collection" type="QString" name="type"/>
          </Option>
        </data_defined_properties>
        <layer id="{b59dc6ec-7c58-4c2a-9fc3-28518bed91a3}" class="SimpleMarker" locked="0" enabled="1" pass="0">
          <Option type="Map">
            <Option value="45" type="QString" name="angle"/>
            <Option value="square" type="QString" name="cap_style"/>
            <Option value="255,120,79,255,hsv:0.03888888888888889,0.69019607843137254,1,1" type="QString" name="color"/>
            <Option value="1" type="QString" name="horizontal_anchor_point"/>
            <Option value="bevel" type="QString" name="joinstyle"/>
            <Option value="cross_fill" type="QString" name="name"/>
            <Option value="0,0" type="QString" name="offset"/>
            <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
            <Option value="MM" type="QString" name="offset_unit"/>
            <Option value="255,60,0,255,hsv:0.03888888888888889,1,1,1" type="QString" name="outline_color"/>
            <Option value="solid" type="QString" name="outline_style"/>
            <Option value="0" type="QString" name="outline_width"/>
            <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
            <Option value="MM" type="QString" name="outline_width_unit"/>
            <Option value="diameter" type="QString" name="scale_method"/>
            <Option value="1.6" type="QString" name="size"/>
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
      <symbol alpha="1" type="marker" clip_to_extent="1" is_animated="0" name="1" frame_rate="10" force_rhr="0">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" type="QString" name="name"/>
            <Option name="properties"/>
            <Option value="collection" type="QString" name="type"/>
          </Option>
        </data_defined_properties>
        <layer id="{b59dc6ec-7c58-4c2a-9fc3-28518bed91a3}" class="SimpleMarker" locked="0" enabled="1" pass="0">
          <Option type="Map">
            <Option value="0" type="QString" name="angle"/>
            <Option value="square" type="QString" name="cap_style"/>
            <Option value="255,120,79,255,hsv:0.03888888888888889,0.69019607843137254,1,1" type="QString" name="color"/>
            <Option value="1" type="QString" name="horizontal_anchor_point"/>
            <Option value="bevel" type="QString" name="joinstyle"/>
            <Option value="square" type="QString" name="name"/>
            <Option value="0,0" type="QString" name="offset"/>
            <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
            <Option value="MM" type="QString" name="offset_unit"/>
            <Option value="255,60,0,255,hsv:0.03888888888888889,1,1,1" type="QString" name="outline_color"/>
            <Option value="solid" type="QString" name="outline_style"/>
            <Option value="0" type="QString" name="outline_width"/>
            <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
            <Option value="MM" type="QString" name="outline_width_unit"/>
            <Option value="diameter" type="QString" name="scale_method"/>
            <Option value="1.4" type="QString" name="size"/>
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
      <symbol alpha="1" type="marker" clip_to_extent="1" is_animated="0" name="2" frame_rate="10" force_rhr="0">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" type="QString" name="name"/>
            <Option name="properties"/>
            <Option value="collection" type="QString" name="type"/>
          </Option>
        </data_defined_properties>
        <layer id="{b59dc6ec-7c58-4c2a-9fc3-28518bed91a3}" class="SimpleMarker" locked="0" enabled="1" pass="0">
          <Option type="Map">
            <Option value="0" type="QString" name="angle"/>
            <Option value="square" type="QString" name="cap_style"/>
            <Option value="255,120,79,255,hsv:0.03888888888888889,0.69019607843137254,1,1" type="QString" name="color"/>
            <Option value="1" type="QString" name="horizontal_anchor_point"/>
            <Option value="bevel" type="QString" name="joinstyle"/>
            <Option value="circle" type="QString" name="name"/>
            <Option value="0,0" type="QString" name="offset"/>
            <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
            <Option value="MM" type="QString" name="offset_unit"/>
            <Option value="255,60,0,255,hsv:0.03888888888888889,1,1,1" type="QString" name="outline_color"/>
            <Option value="solid" type="QString" name="outline_style"/>
            <Option value="0" type="QString" name="outline_width"/>
            <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
            <Option value="MM" type="QString" name="outline_width_unit"/>
            <Option value="diameter" type="QString" name="scale_method"/>
            <Option value="2.6" type="QString" name="size"/>
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
      <symbol alpha="1" type="marker" clip_to_extent="1" is_animated="0" name="3" frame_rate="10" force_rhr="0">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" type="QString" name="name"/>
            <Option name="properties"/>
            <Option value="collection" type="QString" name="type"/>
          </Option>
        </data_defined_properties>
        <layer id="{b59dc6ec-7c58-4c2a-9fc3-28518bed91a3}" class="SimpleMarker" locked="0" enabled="1" pass="0">
          <Option type="Map">
            <Option value="45" type="QString" name="angle"/>
            <Option value="square" type="QString" name="cap_style"/>
            <Option value="0,211,46,255,hsv:0.36969444444444444,1,0.82893110551613647,1" type="QString" name="color"/>
            <Option value="1" type="QString" name="horizontal_anchor_point"/>
            <Option value="bevel" type="QString" name="joinstyle"/>
            <Option value="cross_fill" type="QString" name="name"/>
            <Option value="0,0" type="QString" name="offset"/>
            <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
            <Option value="MM" type="QString" name="offset_unit"/>
            <Option value="2,141,32,255,hsv:0.36969444444444444,0.98834210727092398,0.55385671778439005,1" type="QString" name="outline_color"/>
            <Option value="solid" type="QString" name="outline_style"/>
            <Option value="0" type="QString" name="outline_width"/>
            <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
            <Option value="MM" type="QString" name="outline_width_unit"/>
            <Option value="diameter" type="QString" name="scale_method"/>
            <Option value="1.6" type="QString" name="size"/>
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
      <symbol alpha="1" type="marker" clip_to_extent="1" is_animated="0" name="4" frame_rate="10" force_rhr="0">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" type="QString" name="name"/>
            <Option name="properties"/>
            <Option value="collection" type="QString" name="type"/>
          </Option>
        </data_defined_properties>
        <layer id="{b59dc6ec-7c58-4c2a-9fc3-28518bed91a3}" class="SimpleMarker" locked="0" enabled="1" pass="0">
          <Option type="Map">
            <Option value="0" type="QString" name="angle"/>
            <Option value="square" type="QString" name="cap_style"/>
            <Option value="0,211,46,255,hsv:0.36969444444444444,1,0.82893110551613647,1" type="QString" name="color"/>
            <Option value="1" type="QString" name="horizontal_anchor_point"/>
            <Option value="bevel" type="QString" name="joinstyle"/>
            <Option value="square" type="QString" name="name"/>
            <Option value="0,0" type="QString" name="offset"/>
            <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
            <Option value="MM" type="QString" name="offset_unit"/>
            <Option value="2,141,32,255,hsv:0.36969444444444444,0.98834210727092398,0.55385671778439005,1" type="QString" name="outline_color"/>
            <Option value="solid" type="QString" name="outline_style"/>
            <Option value="0" type="QString" name="outline_width"/>
            <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
            <Option value="MM" type="QString" name="outline_width_unit"/>
            <Option value="diameter" type="QString" name="scale_method"/>
            <Option value="1.4" type="QString" name="size"/>
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
      <symbol alpha="1" type="marker" clip_to_extent="1" is_animated="0" name="5" frame_rate="10" force_rhr="0">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" type="QString" name="name"/>
            <Option name="properties"/>
            <Option value="collection" type="QString" name="type"/>
          </Option>
        </data_defined_properties>
        <layer id="{b59dc6ec-7c58-4c2a-9fc3-28518bed91a3}" class="SimpleMarker" locked="0" enabled="1" pass="0">
          <Option type="Map">
            <Option value="0" type="QString" name="angle"/>
            <Option value="square" type="QString" name="cap_style"/>
            <Option value="0,211,46,255,hsv:0.36969444444444444,1,0.82893110551613647,1" type="QString" name="color"/>
            <Option value="1" type="QString" name="horizontal_anchor_point"/>
            <Option value="bevel" type="QString" name="joinstyle"/>
            <Option value="circle" type="QString" name="name"/>
            <Option value="0,0" type="QString" name="offset"/>
            <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
            <Option value="MM" type="QString" name="offset_unit"/>
            <Option value="2,141,32,255,hsv:0.36969444444444444,0.98834210727092398,0.55385671778439005,1" type="QString" name="outline_color"/>
            <Option value="solid" type="QString" name="outline_style"/>
            <Option value="0" type="QString" name="outline_width"/>
            <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
            <Option value="MM" type="QString" name="outline_width_unit"/>
            <Option value="diameter" type="QString" name="scale_method"/>
            <Option value="2.6" type="QString" name="size"/>
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
      <symbol alpha="1" type="marker" clip_to_extent="1" is_animated="0" name="" frame_rate="10" force_rhr="0">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" type="QString" name="name"/>
            <Option name="properties"/>
            <Option value="collection" type="QString" name="type"/>
          </Option>
        </data_defined_properties>
        <layer id="{7ed4929a-7cce-4761-af88-aa2a8b1c9a42}" class="SimpleMarker" locked="0" enabled="1" pass="0">
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
</qgis>' WHERE layername='point' AND styleconfig_id in (105,106);


INSERT INTO sys_style (layername, styleconfig_id, styletype, stylevalue, active) VALUES('ve_frelem', 101, 'qml', '<!DOCTYPE qgis PUBLIC ''http://mrcc.com/qgis.dtd'' ''SYSTEM''>
<qgis version="3.40.6-Bratislava" styleCategories="Symbology">
  <renderer-v2 enableorderby="0" symbollevels="0" type="RuleRenderer" forceraster="0" referencescale="-1">
    <rules key="{c31d79d3-80f8-49d6-9341-a3da16a21108}">
      <rule filter=" &quot;symbol_x&quot; is not null and  &quot;epa_type&quot; =  ''FRPUMP'' " scalemaxdenom="5000" symbol="0" key="{c0c8c41a-6811-4c3a-bc61-c6326ab318f0}" label="Flow regulator PUMP"/>
      <rule filter=" &quot;symbol_x&quot; is not null and  &quot;epa_type&quot; = ''FRWEIR'' " scalemaxdenom="5000" symbol="1" key="{796dea96-7bfe-402c-ad07-7ab32bc4c8ae}" label="Flow regulator WEIR"/>
      <rule filter=" &quot;symbol_x&quot; is not null and  &quot;epa_type&quot; = ''FROUTLET'' " scalemaxdenom="5000" symbol="2" key="{1ff474c2-83d8-4b86-921f-0748265d3d8c}" label="Flow regulator OUTLET"/>
      <rule filter=" &quot;symbol_x&quot; is not null and  &quot;epa_type&quot; = ''FRORIFICE'' " scalemaxdenom="5000" symbol="3" key="{d4056474-62c3-4d65-9862-052fbfdf3fc4}" label="Flow regulator ORIFICE"/>
    </rules>
    <symbols>
      <symbol force_rhr="0" frame_rate="10" alpha="1" clip_to_extent="1" name="0" type="marker" is_animated="0">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer pass="0" id="{9ab147dd-db16-4b06-8474-ef3b5863138b}" class="GeometryGenerator" locked="0" enabled="1">
          <Option type="Map">
            <Option value="Line" name="SymbolType" type="QString"/>
            <Option value="make_line(@geometry, make_point( &quot;symbol_x&quot; , &quot;symbol_y&quot;))" name="geometryModifier" type="QString"/>
            <Option value="MapUnit" name="units" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
          <symbol force_rhr="0" frame_rate="10" alpha="1" clip_to_extent="1" name="@0@0" type="line" is_animated="0">
            <data_defined_properties>
              <Option type="Map">
                <Option value="" name="name" type="QString"/>
                <Option name="properties"/>
                <Option value="collection" name="type" type="QString"/>
              </Option>
            </data_defined_properties>
            <layer pass="0" id="{a1749224-75e1-4d26-b573-67b14e1f1e1c}" class="SimpleLine" locked="0" enabled="1">
              <Option type="Map">
                <Option value="0" name="align_dash_pattern" type="QString"/>
                <Option value="square" name="capstyle" type="QString"/>
                <Option value="5;2" name="customdash" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="customdash_map_unit_scale" type="QString"/>
                <Option value="MM" name="customdash_unit" type="QString"/>
                <Option value="0" name="dash_pattern_offset" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="dash_pattern_offset_map_unit_scale" type="QString"/>
                <Option value="MM" name="dash_pattern_offset_unit" type="QString"/>
                <Option value="0" name="draw_inside_polygon" type="QString"/>
                <Option value="bevel" name="joinstyle" type="QString"/>
                <Option value="50,87,128,128,rgb:0.19607843137254902,0.3411764705882353,0.50196078431372548,0.50196078431372548" name="line_color" type="QString"/>
                <Option value="solid" name="line_style" type="QString"/>
                <Option value="1.6" name="line_width" type="QString"/>
                <Option value="MM" name="line_width_unit" type="QString"/>
                <Option value="0" name="offset" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
                <Option value="MM" name="offset_unit" type="QString"/>
                <Option value="0" name="ring_filter" type="QString"/>
                <Option value="0" name="trim_distance_end" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="trim_distance_end_map_unit_scale" type="QString"/>
                <Option value="MM" name="trim_distance_end_unit" type="QString"/>
                <Option value="0" name="trim_distance_start" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="trim_distance_start_map_unit_scale" type="QString"/>
                <Option value="MM" name="trim_distance_start_unit" type="QString"/>
                <Option value="0" name="tweak_dash_pattern_on_corners" type="QString"/>
                <Option value="0" name="use_custom_dash" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="width_map_unit_scale" type="QString"/>
              </Option>
              <data_defined_properties>
                <Option type="Map">
                  <Option value="" name="name" type="QString"/>
                  <Option name="properties"/>
                  <Option value="collection" name="type" type="QString"/>
                </Option>
              </data_defined_properties>
            </layer>
            <layer pass="0" id="{c8b0c536-1226-48b6-b049-34d938d1bc83}" class="SimpleLine" locked="0" enabled="1">
              <Option type="Map">
                <Option value="0" name="align_dash_pattern" type="QString"/>
                <Option value="square" name="capstyle" type="QString"/>
                <Option value="5;2" name="customdash" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="customdash_map_unit_scale" type="QString"/>
                <Option value="MM" name="customdash_unit" type="QString"/>
                <Option value="0" name="dash_pattern_offset" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="dash_pattern_offset_map_unit_scale" type="QString"/>
                <Option value="MM" name="dash_pattern_offset_unit" type="QString"/>
                <Option value="0" name="draw_inside_polygon" type="QString"/>
                <Option value="bevel" name="joinstyle" type="QString"/>
                <Option value="237,124,89,179,rgb:0.92941176470588238,0.48627450980392156,0.34901960784313724,0.70196078431372544" name="line_color" type="QString"/>
                <Option value="solid" name="line_style" type="QString"/>
                <Option value="1" name="line_width" type="QString"/>
                <Option value="MM" name="line_width_unit" type="QString"/>
                <Option value="0" name="offset" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
                <Option value="MM" name="offset_unit" type="QString"/>
                <Option value="0" name="ring_filter" type="QString"/>
                <Option value="0" name="trim_distance_end" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="trim_distance_end_map_unit_scale" type="QString"/>
                <Option value="MM" name="trim_distance_end_unit" type="QString"/>
                <Option value="0" name="trim_distance_start" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="trim_distance_start_map_unit_scale" type="QString"/>
                <Option value="MM" name="trim_distance_start_unit" type="QString"/>
                <Option value="0" name="tweak_dash_pattern_on_corners" type="QString"/>
                <Option value="0" name="use_custom_dash" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="width_map_unit_scale" type="QString"/>
              </Option>
              <data_defined_properties>
                <Option type="Map">
                  <Option value="" name="name" type="QString"/>
                  <Option name="properties"/>
                  <Option value="collection" name="type" type="QString"/>
                </Option>
              </data_defined_properties>
            </layer>
          </symbol>
        </layer>
        <layer pass="0" id="{ec288e2d-ee31-4c4d-8d29-c0902d8b367a}" class="GeometryGenerator" locked="0" enabled="1">
          <Option type="Map">
            <Option value="Marker" name="SymbolType" type="QString"/>
            <Option value="line_interpolate_point(make_line(@geometry, make_point( &quot;symbol_x&quot; , &quot;symbol_y&quot;)), length(make_line(@geometry, make_point( &quot;symbol_x&quot; , &quot;symbol_y&quot;)))/2)" name="geometryModifier" type="QString"/>
            <Option value="MapUnit" name="units" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
          <symbol force_rhr="0" frame_rate="10" alpha="1" clip_to_extent="1" name="@0@1" type="marker" is_animated="0">
            <data_defined_properties>
              <Option type="Map">
                <Option value="" name="name" type="QString"/>
                <Option name="properties"/>
                <Option value="collection" name="type" type="QString"/>
              </Option>
            </data_defined_properties>
            <layer pass="0" id="{cf3a94a6-0a45-41f2-b3d6-464dac2e4ebc}" class="SimpleMarker" locked="0" enabled="1">
              <Option type="Map">
                <Option value="0" name="angle" type="QString"/>
                <Option value="square" name="cap_style" type="QString"/>
                <Option value="237,124,89,255,rgb:0.92941176470588238,0.48627450980392156,0.34901960784313724,1" name="color" type="QString"/>
                <Option value="1" name="horizontal_anchor_point" type="QString"/>
                <Option value="bevel" name="joinstyle" type="QString"/>
                <Option value="circle" name="name" type="QString"/>
                <Option value="0,0" name="offset" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
                <Option value="MM" name="offset_unit" type="QString"/>
                <Option value="50,87,128,255,rgb:0.19607843137254902,0.3411764705882353,0.50196078431372548,1" name="outline_color" type="QString"/>
                <Option value="solid" name="outline_style" type="QString"/>
                <Option value="0" name="outline_width" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
                <Option value="MM" name="outline_width_unit" type="QString"/>
                <Option value="diameter" name="scale_method" type="QString"/>
                <Option value="3.8" name="size" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
                <Option value="MM" name="size_unit" type="QString"/>
                <Option value="1" name="vertical_anchor_point" type="QString"/>
              </Option>
              <data_defined_properties>
                <Option type="Map">
                  <Option value="" name="name" type="QString"/>
                  <Option name="properties"/>
                  <Option value="collection" name="type" type="QString"/>
                </Option>
              </data_defined_properties>
            </layer>
            <layer pass="0" id="{f86d98df-7635-4b83-b348-3a32d14e95a0}" class="FontMarker" locked="0" enabled="1">
              <Option type="Map">
                <Option value="0" name="angle" type="QString"/>
                <Option value="P" name="chr" type="QString"/>
                <Option value="0,0,0,255,rgb:0,0,0,1" name="color" type="QString"/>
                <Option value="Arial" name="font" type="QString"/>
                <Option value="Normal" name="font_style" type="QString"/>
                <Option value="1" name="horizontal_anchor_point" type="QString"/>
                <Option value="bevel" name="joinstyle" type="QString"/>
                <Option value="0,-0.20000000000000001" name="offset" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
                <Option value="MM" name="offset_unit" type="QString"/>
                <Option value="35,35,35,255,rgb:0.13725490196078433,0.13725490196078433,0.13725490196078433,1" name="outline_color" type="QString"/>
                <Option value="0" name="outline_width" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
                <Option value="MM" name="outline_width_unit" type="QString"/>
                <Option value="2.3" name="size" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
                <Option value="MM" name="size_unit" type="QString"/>
                <Option value="1" name="vertical_anchor_point" type="QString"/>
              </Option>
              <data_defined_properties>
                <Option type="Map">
                  <Option value="" name="name" type="QString"/>
                  <Option name="properties"/>
                  <Option value="collection" name="type" type="QString"/>
                </Option>
              </data_defined_properties>
            </layer>
          </symbol>
        </layer>
      </symbol>
      <symbol force_rhr="0" frame_rate="10" alpha="1" clip_to_extent="1" name="1" type="marker" is_animated="0">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer pass="0" id="{9ab147dd-db16-4b06-8474-ef3b5863138b}" class="GeometryGenerator" locked="0" enabled="1">
          <Option type="Map">
            <Option value="Line" name="SymbolType" type="QString"/>
            <Option value="make_line(@geometry, make_point( &quot;symbol_x&quot; , &quot;symbol_y&quot;))" name="geometryModifier" type="QString"/>
            <Option value="MapUnit" name="units" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
          <symbol force_rhr="0" frame_rate="10" alpha="1" clip_to_extent="1" name="@1@0" type="line" is_animated="0">
            <data_defined_properties>
              <Option type="Map">
                <Option value="" name="name" type="QString"/>
                <Option name="properties"/>
                <Option value="collection" name="type" type="QString"/>
              </Option>
            </data_defined_properties>
            <layer pass="0" id="{a1749224-75e1-4d26-b573-67b14e1f1e1c}" class="SimpleLine" locked="0" enabled="1">
              <Option type="Map">
                <Option value="0" name="align_dash_pattern" type="QString"/>
                <Option value="square" name="capstyle" type="QString"/>
                <Option value="5;2" name="customdash" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="customdash_map_unit_scale" type="QString"/>
                <Option value="MM" name="customdash_unit" type="QString"/>
                <Option value="0" name="dash_pattern_offset" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="dash_pattern_offset_map_unit_scale" type="QString"/>
                <Option value="MM" name="dash_pattern_offset_unit" type="QString"/>
                <Option value="0" name="draw_inside_polygon" type="QString"/>
                <Option value="bevel" name="joinstyle" type="QString"/>
                <Option value="50,87,128,128,rgb:0.19607843137254902,0.3411764705882353,0.50196078431372548,0.50196078431372548" name="line_color" type="QString"/>
                <Option value="solid" name="line_style" type="QString"/>
                <Option value="1.6" name="line_width" type="QString"/>
                <Option value="MM" name="line_width_unit" type="QString"/>
                <Option value="0" name="offset" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
                <Option value="MM" name="offset_unit" type="QString"/>
                <Option value="0" name="ring_filter" type="QString"/>
                <Option value="0" name="trim_distance_end" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="trim_distance_end_map_unit_scale" type="QString"/>
                <Option value="MM" name="trim_distance_end_unit" type="QString"/>
                <Option value="0" name="trim_distance_start" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="trim_distance_start_map_unit_scale" type="QString"/>
                <Option value="MM" name="trim_distance_start_unit" type="QString"/>
                <Option value="0" name="tweak_dash_pattern_on_corners" type="QString"/>
                <Option value="0" name="use_custom_dash" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="width_map_unit_scale" type="QString"/>
              </Option>
              <data_defined_properties>
                <Option type="Map">
                  <Option value="" name="name" type="QString"/>
                  <Option name="properties"/>
                  <Option value="collection" name="type" type="QString"/>
                </Option>
              </data_defined_properties>
            </layer>
            <layer pass="0" id="{c8b0c536-1226-48b6-b049-34d938d1bc83}" class="SimpleLine" locked="0" enabled="1">
              <Option type="Map">
                <Option value="0" name="align_dash_pattern" type="QString"/>
                <Option value="square" name="capstyle" type="QString"/>
                <Option value="5;2" name="customdash" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="customdash_map_unit_scale" type="QString"/>
                <Option value="MM" name="customdash_unit" type="QString"/>
                <Option value="0" name="dash_pattern_offset" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="dash_pattern_offset_map_unit_scale" type="QString"/>
                <Option value="MM" name="dash_pattern_offset_unit" type="QString"/>
                <Option value="0" name="draw_inside_polygon" type="QString"/>
                <Option value="bevel" name="joinstyle" type="QString"/>
                <Option value="234,237,205,179,rgb:0.91764705882352937,0.92941176470588238,0.80392156862745101,0.70196078431372544" name="line_color" type="QString"/>
                <Option value="solid" name="line_style" type="QString"/>
                <Option value="1" name="line_width" type="QString"/>
                <Option value="MM" name="line_width_unit" type="QString"/>
                <Option value="0" name="offset" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
                <Option value="MM" name="offset_unit" type="QString"/>
                <Option value="0" name="ring_filter" type="QString"/>
                <Option value="0" name="trim_distance_end" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="trim_distance_end_map_unit_scale" type="QString"/>
                <Option value="MM" name="trim_distance_end_unit" type="QString"/>
                <Option value="0" name="trim_distance_start" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="trim_distance_start_map_unit_scale" type="QString"/>
                <Option value="MM" name="trim_distance_start_unit" type="QString"/>
                <Option value="0" name="tweak_dash_pattern_on_corners" type="QString"/>
                <Option value="0" name="use_custom_dash" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="width_map_unit_scale" type="QString"/>
              </Option>
              <data_defined_properties>
                <Option type="Map">
                  <Option value="" name="name" type="QString"/>
                  <Option name="properties"/>
                  <Option value="collection" name="type" type="QString"/>
                </Option>
              </data_defined_properties>
            </layer>
          </symbol>
        </layer>
        <layer pass="0" id="{ec288e2d-ee31-4c4d-8d29-c0902d8b367a}" class="GeometryGenerator" locked="0" enabled="1">
          <Option type="Map">
            <Option value="Marker" name="SymbolType" type="QString"/>
            <Option value="line_interpolate_point(make_line(@geometry, make_point( &quot;symbol_x&quot; , &quot;symbol_y&quot;)), length(make_line(@geometry, make_point( &quot;symbol_x&quot; , &quot;symbol_y&quot;)))/2)" name="geometryModifier" type="QString"/>
            <Option value="MapUnit" name="units" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
          <symbol force_rhr="0" frame_rate="10" alpha="1" clip_to_extent="1" name="@1@1" type="marker" is_animated="0">
            <data_defined_properties>
              <Option type="Map">
                <Option value="" name="name" type="QString"/>
                <Option name="properties"/>
                <Option value="collection" name="type" type="QString"/>
              </Option>
            </data_defined_properties>
            <layer pass="0" id="{cf3a94a6-0a45-41f2-b3d6-464dac2e4ebc}" class="SimpleMarker" locked="0" enabled="1">
              <Option type="Map">
                <Option value="0" name="angle" type="QString"/>
                <Option value="square" name="cap_style" type="QString"/>
                <Option value="234,237,205,255,rgb:0.91764705882352937,0.92941176470588238,0.80392156862745101,1" name="color" type="QString"/>
                <Option value="1" name="horizontal_anchor_point" type="QString"/>
                <Option value="bevel" name="joinstyle" type="QString"/>
                <Option value="circle" name="name" type="QString"/>
                <Option value="0,0" name="offset" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
                <Option value="MM" name="offset_unit" type="QString"/>
                <Option value="50,87,128,255,rgb:0.19607843137254902,0.3411764705882353,0.50196078431372548,1" name="outline_color" type="QString"/>
                <Option value="solid" name="outline_style" type="QString"/>
                <Option value="0" name="outline_width" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
                <Option value="MM" name="outline_width_unit" type="QString"/>
                <Option value="diameter" name="scale_method" type="QString"/>
                <Option value="3.8" name="size" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
                <Option value="MM" name="size_unit" type="QString"/>
                <Option value="1" name="vertical_anchor_point" type="QString"/>
              </Option>
              <data_defined_properties>
                <Option type="Map">
                  <Option value="" name="name" type="QString"/>
                  <Option name="properties"/>
                  <Option value="collection" name="type" type="QString"/>
                </Option>
              </data_defined_properties>
            </layer>
            <layer pass="0" id="{f86d98df-7635-4b83-b348-3a32d14e95a0}" class="FontMarker" locked="0" enabled="1">
              <Option type="Map">
                <Option value="0" name="angle" type="QString"/>
                <Option value="W" name="chr" type="QString"/>
                <Option value="0,0,0,255,rgb:0,0,0,1" name="color" type="QString"/>
                <Option value="Arial" name="font" type="QString"/>
                <Option value="Normal" name="font_style" type="QString"/>
                <Option value="1" name="horizontal_anchor_point" type="QString"/>
                <Option value="bevel" name="joinstyle" type="QString"/>
                <Option value="0,-0.20000000000000001" name="offset" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
                <Option value="MM" name="offset_unit" type="QString"/>
                <Option value="35,35,35,255,rgb:0.13725490196078433,0.13725490196078433,0.13725490196078433,1" name="outline_color" type="QString"/>
                <Option value="0" name="outline_width" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
                <Option value="MM" name="outline_width_unit" type="QString"/>
                <Option value="2.3" name="size" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
                <Option value="MM" name="size_unit" type="QString"/>
                <Option value="1" name="vertical_anchor_point" type="QString"/>
              </Option>
              <data_defined_properties>
                <Option type="Map">
                  <Option value="" name="name" type="QString"/>
                  <Option name="properties"/>
                  <Option value="collection" name="type" type="QString"/>
                </Option>
              </data_defined_properties>
            </layer>
          </symbol>
        </layer>
      </symbol>
      <symbol force_rhr="0" frame_rate="10" alpha="1" clip_to_extent="1" name="2" type="marker" is_animated="0">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer pass="0" id="{9ab147dd-db16-4b06-8474-ef3b5863138b}" class="GeometryGenerator" locked="0" enabled="1">
          <Option type="Map">
            <Option value="Line" name="SymbolType" type="QString"/>
            <Option value="make_line(@geometry, make_point( &quot;symbol_x&quot; , &quot;symbol_y&quot;))" name="geometryModifier" type="QString"/>
            <Option value="MapUnit" name="units" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
          <symbol force_rhr="0" frame_rate="10" alpha="1" clip_to_extent="1" name="@2@0" type="line" is_animated="0">
            <data_defined_properties>
              <Option type="Map">
                <Option value="" name="name" type="QString"/>
                <Option name="properties"/>
                <Option value="collection" name="type" type="QString"/>
              </Option>
            </data_defined_properties>
            <layer pass="0" id="{a1749224-75e1-4d26-b573-67b14e1f1e1c}" class="SimpleLine" locked="0" enabled="1">
              <Option type="Map">
                <Option value="0" name="align_dash_pattern" type="QString"/>
                <Option value="square" name="capstyle" type="QString"/>
                <Option value="5;2" name="customdash" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="customdash_map_unit_scale" type="QString"/>
                <Option value="MM" name="customdash_unit" type="QString"/>
                <Option value="0" name="dash_pattern_offset" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="dash_pattern_offset_map_unit_scale" type="QString"/>
                <Option value="MM" name="dash_pattern_offset_unit" type="QString"/>
                <Option value="0" name="draw_inside_polygon" type="QString"/>
                <Option value="bevel" name="joinstyle" type="QString"/>
                <Option value="50,87,128,128,rgb:0.19607843137254902,0.3411764705882353,0.50196078431372548,0.50196078431372548" name="line_color" type="QString"/>
                <Option value="solid" name="line_style" type="QString"/>
                <Option value="1.6" name="line_width" type="QString"/>
                <Option value="MM" name="line_width_unit" type="QString"/>
                <Option value="0" name="offset" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
                <Option value="MM" name="offset_unit" type="QString"/>
                <Option value="0" name="ring_filter" type="QString"/>
                <Option value="0" name="trim_distance_end" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="trim_distance_end_map_unit_scale" type="QString"/>
                <Option value="MM" name="trim_distance_end_unit" type="QString"/>
                <Option value="0" name="trim_distance_start" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="trim_distance_start_map_unit_scale" type="QString"/>
                <Option value="MM" name="trim_distance_start_unit" type="QString"/>
                <Option value="0" name="tweak_dash_pattern_on_corners" type="QString"/>
                <Option value="0" name="use_custom_dash" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="width_map_unit_scale" type="QString"/>
              </Option>
              <data_defined_properties>
                <Option type="Map">
                  <Option value="" name="name" type="QString"/>
                  <Option name="properties"/>
                  <Option value="collection" name="type" type="QString"/>
                </Option>
              </data_defined_properties>
            </layer>
            <layer pass="0" id="{c8b0c536-1226-48b6-b049-34d938d1bc83}" class="SimpleLine" locked="0" enabled="1">
              <Option type="Map">
                <Option value="0" name="align_dash_pattern" type="QString"/>
                <Option value="square" name="capstyle" type="QString"/>
                <Option value="5;2" name="customdash" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="customdash_map_unit_scale" type="QString"/>
                <Option value="MM" name="customdash_unit" type="QString"/>
                <Option value="0" name="dash_pattern_offset" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="dash_pattern_offset_map_unit_scale" type="QString"/>
                <Option value="MM" name="dash_pattern_offset_unit" type="QString"/>
                <Option value="0" name="draw_inside_polygon" type="QString"/>
                <Option value="bevel" name="joinstyle" type="QString"/>
                <Option value="175,186,23,183,rgb:0.68627450980392157,0.72941176470588232,0.09019607843137255,0.71578545815213246" name="line_color" type="QString"/>
                <Option value="solid" name="line_style" type="QString"/>
                <Option value="1" name="line_width" type="QString"/>
                <Option value="MM" name="line_width_unit" type="QString"/>
                <Option value="0" name="offset" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
                <Option value="MM" name="offset_unit" type="QString"/>
                <Option value="0" name="ring_filter" type="QString"/>
                <Option value="0" name="trim_distance_end" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="trim_distance_end_map_unit_scale" type="QString"/>
                <Option value="MM" name="trim_distance_end_unit" type="QString"/>
                <Option value="0" name="trim_distance_start" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="trim_distance_start_map_unit_scale" type="QString"/>
                <Option value="MM" name="trim_distance_start_unit" type="QString"/>
                <Option value="0" name="tweak_dash_pattern_on_corners" type="QString"/>
                <Option value="0" name="use_custom_dash" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="width_map_unit_scale" type="QString"/>
              </Option>
              <data_defined_properties>
                <Option type="Map">
                  <Option value="" name="name" type="QString"/>
                  <Option name="properties"/>
                  <Option value="collection" name="type" type="QString"/>
                </Option>
              </data_defined_properties>
            </layer>
          </symbol>
        </layer>
        <layer pass="0" id="{ec288e2d-ee31-4c4d-8d29-c0902d8b367a}" class="GeometryGenerator" locked="0" enabled="1">
          <Option type="Map">
            <Option value="Marker" name="SymbolType" type="QString"/>
            <Option value="line_interpolate_point(make_line(@geometry, make_point( &quot;symbol_x&quot; , &quot;symbol_y&quot;)), length(make_line(@geometry, make_point( &quot;symbol_x&quot; , &quot;symbol_y&quot;)))/2)" name="geometryModifier" type="QString"/>
            <Option value="MapUnit" name="units" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
          <symbol force_rhr="0" frame_rate="10" alpha="1" clip_to_extent="1" name="@2@1" type="marker" is_animated="0">
            <data_defined_properties>
              <Option type="Map">
                <Option value="" name="name" type="QString"/>
                <Option name="properties"/>
                <Option value="collection" name="type" type="QString"/>
              </Option>
            </data_defined_properties>
            <layer pass="0" id="{cf3a94a6-0a45-41f2-b3d6-464dac2e4ebc}" class="SimpleMarker" locked="0" enabled="1">
              <Option type="Map">
                <Option value="0" name="angle" type="QString"/>
                <Option value="square" name="cap_style" type="QString"/>
                <Option value="175,186,23,255,rgb:0.68627450980392157,0.72941176470588232,0.09019607843137255,1" name="color" type="QString"/>
                <Option value="1" name="horizontal_anchor_point" type="QString"/>
                <Option value="bevel" name="joinstyle" type="QString"/>
                <Option value="circle" name="name" type="QString"/>
                <Option value="0,0" name="offset" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
                <Option value="MM" name="offset_unit" type="QString"/>
                <Option value="50,87,128,255,rgb:0.19607843137254902,0.3411764705882353,0.50196078431372548,1" name="outline_color" type="QString"/>
                <Option value="solid" name="outline_style" type="QString"/>
                <Option value="0" name="outline_width" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
                <Option value="MM" name="outline_width_unit" type="QString"/>
                <Option value="diameter" name="scale_method" type="QString"/>
                <Option value="3.8" name="size" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
                <Option value="MM" name="size_unit" type="QString"/>
                <Option value="1" name="vertical_anchor_point" type="QString"/>
              </Option>
              <data_defined_properties>
                <Option type="Map">
                  <Option value="" name="name" type="QString"/>
                  <Option name="properties"/>
                  <Option value="collection" name="type" type="QString"/>
                </Option>
              </data_defined_properties>
            </layer>
            <layer pass="0" id="{f86d98df-7635-4b83-b348-3a32d14e95a0}" class="FontMarker" locked="0" enabled="1">
              <Option type="Map">
                <Option value="0" name="angle" type="QString"/>
                <Option value="O" name="chr" type="QString"/>
                <Option value="0,0,0,255,rgb:0,0,0,1" name="color" type="QString"/>
                <Option value="Arial" name="font" type="QString"/>
                <Option value="Normal" name="font_style" type="QString"/>
                <Option value="1" name="horizontal_anchor_point" type="QString"/>
                <Option value="bevel" name="joinstyle" type="QString"/>
                <Option value="0,-0.20000000000000001" name="offset" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
                <Option value="MM" name="offset_unit" type="QString"/>
                <Option value="35,35,35,255,rgb:0.13725490196078433,0.13725490196078433,0.13725490196078433,1" name="outline_color" type="QString"/>
                <Option value="0" name="outline_width" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
                <Option value="MM" name="outline_width_unit" type="QString"/>
                <Option value="2.3" name="size" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
                <Option value="MM" name="size_unit" type="QString"/>
                <Option value="1" name="vertical_anchor_point" type="QString"/>
              </Option>
              <data_defined_properties>
                <Option type="Map">
                  <Option value="" name="name" type="QString"/>
                  <Option name="properties"/>
                  <Option value="collection" name="type" type="QString"/>
                </Option>
              </data_defined_properties>
            </layer>
          </symbol>
        </layer>
      </symbol>
      <symbol force_rhr="0" frame_rate="10" alpha="1" clip_to_extent="1" name="3" type="marker" is_animated="0">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer pass="0" id="{9ab147dd-db16-4b06-8474-ef3b5863138b}" class="GeometryGenerator" locked="0" enabled="1">
          <Option type="Map">
            <Option value="Line" name="SymbolType" type="QString"/>
            <Option value="make_line(@geometry, make_point( &quot;symbol_x&quot; , &quot;symbol_y&quot;))" name="geometryModifier" type="QString"/>
            <Option value="MapUnit" name="units" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
          <symbol force_rhr="0" frame_rate="10" alpha="1" clip_to_extent="1" name="@3@0" type="line" is_animated="0">
            <data_defined_properties>
              <Option type="Map">
                <Option value="" name="name" type="QString"/>
                <Option name="properties"/>
                <Option value="collection" name="type" type="QString"/>
              </Option>
            </data_defined_properties>
            <layer pass="0" id="{a1749224-75e1-4d26-b573-67b14e1f1e1c}" class="SimpleLine" locked="0" enabled="1">
              <Option type="Map">
                <Option value="0" name="align_dash_pattern" type="QString"/>
                <Option value="square" name="capstyle" type="QString"/>
                <Option value="5;2" name="customdash" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="customdash_map_unit_scale" type="QString"/>
                <Option value="MM" name="customdash_unit" type="QString"/>
                <Option value="0" name="dash_pattern_offset" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="dash_pattern_offset_map_unit_scale" type="QString"/>
                <Option value="MM" name="dash_pattern_offset_unit" type="QString"/>
                <Option value="0" name="draw_inside_polygon" type="QString"/>
                <Option value="bevel" name="joinstyle" type="QString"/>
                <Option value="50,87,128,128,rgb:0.19607843137254902,0.3411764705882353,0.50196078431372548,0.50196078431372548" name="line_color" type="QString"/>
                <Option value="solid" name="line_style" type="QString"/>
                <Option value="1.6" name="line_width" type="QString"/>
                <Option value="MM" name="line_width_unit" type="QString"/>
                <Option value="0" name="offset" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
                <Option value="MM" name="offset_unit" type="QString"/>
                <Option value="0" name="ring_filter" type="QString"/>
                <Option value="0" name="trim_distance_end" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="trim_distance_end_map_unit_scale" type="QString"/>
                <Option value="MM" name="trim_distance_end_unit" type="QString"/>
                <Option value="0" name="trim_distance_start" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="trim_distance_start_map_unit_scale" type="QString"/>
                <Option value="MM" name="trim_distance_start_unit" type="QString"/>
                <Option value="0" name="tweak_dash_pattern_on_corners" type="QString"/>
                <Option value="0" name="use_custom_dash" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="width_map_unit_scale" type="QString"/>
              </Option>
              <data_defined_properties>
                <Option type="Map">
                  <Option value="" name="name" type="QString"/>
                  <Option name="properties"/>
                  <Option value="collection" name="type" type="QString"/>
                </Option>
              </data_defined_properties>
            </layer>
            <layer pass="0" id="{c8b0c536-1226-48b6-b049-34d938d1bc83}" class="SimpleLine" locked="0" enabled="1">
              <Option type="Map">
                <Option value="0" name="align_dash_pattern" type="QString"/>
                <Option value="square" name="capstyle" type="QString"/>
                <Option value="5;2" name="customdash" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="customdash_map_unit_scale" type="QString"/>
                <Option value="MM" name="customdash_unit" type="QString"/>
                <Option value="0" name="dash_pattern_offset" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="dash_pattern_offset_map_unit_scale" type="QString"/>
                <Option value="MM" name="dash_pattern_offset_unit" type="QString"/>
                <Option value="0" name="draw_inside_polygon" type="QString"/>
                <Option value="bevel" name="joinstyle" type="QString"/>
                <Option value="175,186,23,183,rgb:0.68627450980392157,0.72941176470588232,0.09019607843137255,0.71578545815213246" name="line_color" type="QString"/>
                <Option value="solid" name="line_style" type="QString"/>
                <Option value="1" name="line_width" type="QString"/>
                <Option value="MM" name="line_width_unit" type="QString"/>
                <Option value="0" name="offset" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
                <Option value="MM" name="offset_unit" type="QString"/>
                <Option value="0" name="ring_filter" type="QString"/>
                <Option value="0" name="trim_distance_end" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="trim_distance_end_map_unit_scale" type="QString"/>
                <Option value="MM" name="trim_distance_end_unit" type="QString"/>
                <Option value="0" name="trim_distance_start" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="trim_distance_start_map_unit_scale" type="QString"/>
                <Option value="MM" name="trim_distance_start_unit" type="QString"/>
                <Option value="0" name="tweak_dash_pattern_on_corners" type="QString"/>
                <Option value="0" name="use_custom_dash" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="width_map_unit_scale" type="QString"/>
              </Option>
              <data_defined_properties>
                <Option type="Map">
                  <Option value="" name="name" type="QString"/>
                  <Option name="properties"/>
                  <Option value="collection" name="type" type="QString"/>
                </Option>
              </data_defined_properties>
            </layer>
          </symbol>
        </layer>
        <layer pass="0" id="{ec288e2d-ee31-4c4d-8d29-c0902d8b367a}" class="GeometryGenerator" locked="0" enabled="1">
          <Option type="Map">
            <Option value="Marker" name="SymbolType" type="QString"/>
            <Option value="line_interpolate_point(make_line(@geometry, make_point( &quot;symbol_x&quot; , &quot;symbol_y&quot;)), length(make_line(@geometry, make_point( &quot;symbol_x&quot; , &quot;symbol_y&quot;)))/2)" name="geometryModifier" type="QString"/>
            <Option value="MapUnit" name="units" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
          <symbol force_rhr="0" frame_rate="10" alpha="1" clip_to_extent="1" name="@3@1" type="marker" is_animated="0">
            <data_defined_properties>
              <Option type="Map">
                <Option value="" name="name" type="QString"/>
                <Option name="properties"/>
                <Option value="collection" name="type" type="QString"/>
              </Option>
            </data_defined_properties>
            <layer pass="0" id="{cf3a94a6-0a45-41f2-b3d6-464dac2e4ebc}" class="SimpleMarker" locked="0" enabled="1">
              <Option type="Map">
                <Option value="0" name="angle" type="QString"/>
                <Option value="square" name="cap_style" type="QString"/>
                <Option value="175,186,23,255,rgb:0.68627450980392157,0.72941176470588232,0.09019607843137255,1" name="color" type="QString"/>
                <Option value="1" name="horizontal_anchor_point" type="QString"/>
                <Option value="bevel" name="joinstyle" type="QString"/>
                <Option value="circle" name="name" type="QString"/>
                <Option value="0,0" name="offset" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
                <Option value="MM" name="offset_unit" type="QString"/>
                <Option value="50,87,128,255,rgb:0.19607843137254902,0.3411764705882353,0.50196078431372548,1" name="outline_color" type="QString"/>
                <Option value="solid" name="outline_style" type="QString"/>
                <Option value="0" name="outline_width" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
                <Option value="MM" name="outline_width_unit" type="QString"/>
                <Option value="diameter" name="scale_method" type="QString"/>
                <Option value="3.8" name="size" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
                <Option value="MM" name="size_unit" type="QString"/>
                <Option value="1" name="vertical_anchor_point" type="QString"/>
              </Option>
              <data_defined_properties>
                <Option type="Map">
                  <Option value="" name="name" type="QString"/>
                  <Option name="properties"/>
                  <Option value="collection" name="type" type="QString"/>
                </Option>
              </data_defined_properties>
            </layer>
            <layer pass="0" id="{f86d98df-7635-4b83-b348-3a32d14e95a0}" class="FontMarker" locked="0" enabled="1">
              <Option type="Map">
                <Option value="0" name="angle" type="QString"/>
                <Option value="L" name="chr" type="QString"/>
                <Option value="0,0,0,255,rgb:0,0,0,1" name="color" type="QString"/>
                <Option value="Arial" name="font" type="QString"/>
                <Option value="Normal" name="font_style" type="QString"/>
                <Option value="1" name="horizontal_anchor_point" type="QString"/>
                <Option value="bevel" name="joinstyle" type="QString"/>
                <Option value="0,-0.20000000000000001" name="offset" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
                <Option value="MM" name="offset_unit" type="QString"/>
                <Option value="35,35,35,255,rgb:0.13725490196078433,0.13725490196078433,0.13725490196078433,1" name="outline_color" type="QString"/>
                <Option value="0" name="outline_width" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
                <Option value="MM" name="outline_width_unit" type="QString"/>
                <Option value="2.3" name="size" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
                <Option value="MM" name="size_unit" type="QString"/>
                <Option value="1" name="vertical_anchor_point" type="QString"/>
              </Option>
              <data_defined_properties>
                <Option type="Map">
                  <Option value="" name="name" type="QString"/>
                  <Option name="properties"/>
                  <Option value="collection" name="type" type="QString"/>
                </Option>
              </data_defined_properties>
            </layer>
          </symbol>
        </layer>
      </symbol>
    </symbols>
    <data-defined-properties>
      <Option type="Map">
        <Option value="" name="name" type="QString"/>
        <Option name="properties"/>
        <Option value="collection" name="type" type="QString"/>
      </Option>
    </data-defined-properties>
  </renderer-v2>
  <selection mode="Default">
    <selectionColor invalid="1"/>
    <selectionSymbol>
      <symbol force_rhr="0" frame_rate="10" alpha="1" clip_to_extent="1" name="" type="marker" is_animated="0">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer pass="0" id="{afeff23a-ae7e-4624-a496-267df3fbf1d3}" class="SimpleMarker" locked="0" enabled="1">
          <Option type="Map">
            <Option value="0" name="angle" type="QString"/>
            <Option value="square" name="cap_style" type="QString"/>
            <Option value="255,0,0,255,rgb:1,0,0,1" name="color" type="QString"/>
            <Option value="1" name="horizontal_anchor_point" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="circle" name="name" type="QString"/>
            <Option value="0,0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="35,35,35,255,rgb:0.13725490196078433,0.13725490196078433,0.13725490196078433,1" name="outline_color" type="QString"/>
            <Option value="solid" name="outline_style" type="QString"/>
            <Option value="0" name="outline_width" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
            <Option value="MM" name="outline_width_unit" type="QString"/>
            <Option value="diameter" name="scale_method" type="QString"/>
            <Option value="2" name="size" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
            <Option value="MM" name="size_unit" type="QString"/>
            <Option value="1" name="vertical_anchor_point" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
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

ALTER TABLE sys_feature_class ADD CONSTRAINT sys_feature_cat_check CHECK
(((id)::text = ANY (ARRAY['CHAMBER'::text, 'CONDUIT'::text, 'CJOIN'::text, 'CONDUITLINK'::text, 'VLINK'::text, 'VCONNEC'::text, 'GINLET'::text, 'VGULLY'::text, 'JUNCTION'::text, 'MANHOLE'::text, 'NETELEMENT'::text, 'NETGULLY'::text, 'NETINIT'::text,
'OUTFALL'::text, 'SIPHON'::text, 'STORAGE'::text, 'VALVE'::text, 'VARC'::text, 'WACCEL'::text, 'WJUMP'::text, 'WWTP'::text,
'GENELEM'::text, 'FRELEM'::TEXT])));

ALTER TABLE config_form_fields
ADD CONSTRAINT chk_widgets_requires_dv_querytext
CHECK (
    (widgettype NOT IN ('combo', 'typeahead')) OR dv_querytext IS NOT NULL
);

ALTER TABLE cat_feature_element DROP CONSTRAINT IF EXISTS cat_feature_element_inp_check;
ALTER TABLE cat_feature_element ADD CONSTRAINT cat_feature_element_inp_check CHECK (((epa_default)::text = ANY (ARRAY['FRPUMP'::text,'FRWEIR'::text, 'FRORIFICE'::text, 'FROUTLET'::text,'UNDEFINED'::text])));

CREATE TRIGGER gw_trg_edit_samplepoint INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_samplepoint
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_samplepoint('samplepoint');

CREATE TRIGGER gw_trg_edit_arc INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_arc
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_arc('parent');

CREATE TRIGGER gw_trg_edit_node INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_node
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_node('parent');

CREATE TRIGGER gw_trg_edit_connec INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_connec
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_connec('parent');

CREATE TRIGGER gw_trg_edit_gully INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_gully
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_gully('parent');

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

CREATE TRIGGER gw_trg_ui_element INSTEAD OF INSERT OR DELETE OR UPDATE ON v_ui_element_x_gully
FOR EACH ROW EXECUTE FUNCTION gw_trg_ui_element('gully');

CREATE TRIGGER gw_trg_ui_element INSTEAD OF INSERT OR DELETE OR UPDATE ON v_ui_element_x_link
FOR EACH ROW EXECUTE FUNCTION gw_trg_ui_element('link');

CREATE TRIGGER gw_trg_edit_inp_node_storage INSTEAD OF INSERT OR UPDATE OR DELETE
ON v_edit_inp_storage FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_inp_node('inp_storage');

CREATE TRIGGER gw_trg_edit_inp_dscenario INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_dscenario_storage
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('STORAGE');

CREATE TRIGGER gw_trg_edit_inp_dscenario INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_dscenario_outfall
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('OUTFALL');

CREATE TRIGGER gw_trg_edit_inp_node_junction INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_junction
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_node('inp_junction');

CREATE TRIGGER gw_trg_edit_inp_node_junction INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_outfall
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_node('inp_outfall');

CREATE TRIGGER gw_trg_edit_inp_treatment INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_treatment
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_treatment();

CREATE TRIGGER gw_trg_edit_inp_inflows INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_inflows_poll
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_inflows('INFLOWS-POLL');

CREATE TRIGGER gw_trg_edit_inp_inflows INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_inflows
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_inflows('INFLOWS');

CREATE TRIGGER gw_trg_edit_inp_dwf INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_dwf
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dwf();

CREATE TRIGGER gw_trg_edit_inp_dscenario INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_dscenario_treatment
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('TREATMENT');

CREATE TRIGGER gw_trg_edit_inp_dscenario INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_dscenario_junction
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('JUNCTION');

CREATE TRIGGER gw_trg_edit_inp_dscenario INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_dscenario_inflows_poll
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('INFLOWS-POLL');

CREATE TRIGGER gw_trg_edit_inp_dscenario INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_dscenario_inflows
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('INFLOWS');

CREATE TRIGGER gw_trg_edit_inp_flwreg INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_froutlet
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_flwreg('FLWREG-OUTLET');

CREATE TRIGGER gw_trg_edit_inp_flwreg INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_frweir
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_flwreg('FLWREG-WEIR');

CREATE TRIGGER gw_trg_edit_inp_flwreg INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_frpump
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_flwreg('FLWREG-PUMP');

CREATE TRIGGER gw_trg_edit_inp_flwreg INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_frorifice
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_flwreg('FLWREG-ORIFICE');

CREATE TRIGGER gw_trg_edit_inp_dscenario INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_dscenario_froutlet
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('FLWREG-OUTLET');

CREATE TRIGGER gw_trg_edit_inp_dscenario INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_dscenario_frweir
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('FLWREG-WEIR');

CREATE TRIGGER gw_trg_edit_inp_dscenario INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_dscenario_frpump
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('FLWREG-PUMP');

CREATE TRIGGER gw_trg_edit_inp_dscenario INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_dscenario_frorifice
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('FLWREG-ORIFICE');

CREATE TRIGGER gw_trg_edit_inp_arc_orifice INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_orifice
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_arc('inp_orifice');

CREATE TRIGGER gw_trg_edit_inp_arc_outlet INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_outlet
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_arc('inp_outlet');

CREATE TRIGGER gw_trg_edit_inp_arc_pump INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_pump
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_arc('inp_pump');

CREATE TRIGGER gw_trg_edit_inp_arc_weir INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_weir
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_arc('inp_weir');

CREATE TRIGGER gw_trg_edit_inp_dscenario INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_dscenario_conduit
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('CONDUIT');

CREATE TRIGGER gw_trg_edit_inp_arc_conduit INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_conduit
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_arc('inp_conduit');

CREATE TRIGGER gw_trg_edit_pol_gully INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_pol_gully
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_man_gully_pol();

CREATE TRIGGER gw_trg_edit_omzone INSTEAD OF INSERT OR UPDATE OR DELETE ON v_edit_omzone
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_omzone('omzone');

CREATE trigger gw_trg_edit_drainzone INSTEAD OF INSERT OR UPDATE OR DELETE ON v_edit_drainzone
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_drainzone('EDIT');

CREATE trigger gw_trg_edit_sector INSTEAD OF INSERT OR UPDATE OR DELETE ON v_edit_sector
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_sector('EDIT');

CREATE TRIGGER gw_trg_v_edit_dwfzone INSTEAD OF INSERT OR DELETE OR UPDATE
ON v_edit_dwfzone FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_dwfzone('EDIT');


DROP TRIGGER IF EXISTS gw_trg_typevalue_fk ON arc;
CREATE TRIGGER gw_trg_typevalue_fk AFTER INSERT OR UPDATE OF verified, function_type, category_type, fluid_type, location_type
ON arc FOR EACH ROW EXECUTE FUNCTION gw_trg_typevalue_fk('arc');

DROP TRIGGER IF EXISTS gw_trg_typevalue_fk ON node;
CREATE TRIGGER gw_trg_typevalue_fk AFTER INSERT OR UPDATE OF verified, function_type, category_type, fluid_type, location_type
ON node FOR EACH ROW EXECUTE FUNCTION gw_trg_typevalue_fk('node');

DROP TRIGGER IF EXISTS gw_trg_typevalue_fk ON connec;
CREATE TRIGGER gw_trg_typevalue_fk AFTER INSERT OR UPDATE OF verified, function_type, category_type, fluid_type, location_type
ON connec FOR EACH ROW EXECUTE FUNCTION gw_trg_typevalue_fk('connec');

DROP TRIGGER IF EXISTS gw_trg_typevalue_fk ON gully;
CREATE TRIGGER gw_trg_typevalue_fk AFTER INSERT OR UPDATE OF verified, units_placement, function_type, category_type, fluid_type, location_type
ON gully FOR EACH ROW EXECUTE FUNCTION gw_trg_typevalue_fk('gully');


CREATE TRIGGER gw_trg_edit_inp_dscenario INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_dscenario_lids
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('LIDS');


CREATE TRIGGER gw_trg_mantypevalue_fk_insert AFTER
INSERT
    ON
    gully FOR EACH ROW EXECUTE FUNCTION gw_trg_mantypevalue_fk('gully');
CREATE TRIGGER gw_trg_mantypevalue_fk_update AFTER
UPDATE
    OF function_type,
    category_type,
    location_type ON
    gully FOR EACH ROW
    WHEN (((old.function_type)::TEXT IS DISTINCT FROM (new.function_type)::TEXT)
    OR ((OLD.category_type)::TEXT IS DISTINCT FROM (NEW.category_type)::TEXT)
    OR ((OLD.location_type)::TEXT IS DISTINCT FROM (NEW.location_type)::TEXT))
    EXECUTE FUNCTION gw_trg_mantypevalue_fk('gully');


CREATE TRIGGER gw_trg_edit_ve_epa_orifice INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_epa_orifice FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_ve_epa('orifice');


CREATE TRIGGER gw_trg_edit_inp_dwf INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_cat_dwf
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dwf('cat_dwf');


CREATE TRIGGER gw_trg_cat_material_fk_insert AFTER INSERT ON cat_gully
FOR EACH ROW EXECUTE FUNCTION gw_trg_cat_material_fk('gully');

CREATE TRIGGER gw_trg_cat_material_fk_update AFTER UPDATE OF matcat_id ON cat_gully
FOR EACH ROW WHEN (((old.matcat_id)::TEXT IS DISTINCT FROM (new.matcat_id)::TEXT)) EXECUTE FUNCTION gw_trg_cat_material_fk('gully');

CREATE TRIGGER gw_trg_cat_material_fk_insert AFTER INSERT ON arc
FOR EACH ROW EXECUTE FUNCTION gw_trg_cat_material_fk('arc');
CREATE TRIGGER gw_trg_cat_material_fk_update AFTER UPDATE OF matcat_id ON arc
FOR EACH ROW WHEN (((old.matcat_id)::TEXT IS DISTINCT FROM (new.matcat_id)::TEXT)) EXECUTE FUNCTION gw_trg_cat_material_fk('arc');

CREATE TRIGGER gw_trg_cat_material_fk_insert AFTER INSERT ON node
FOR EACH ROW EXECUTE FUNCTION gw_trg_cat_material_fk('node');
CREATE TRIGGER gw_trg_cat_material_fk_update AFTER UPDATE OF matcat_id ON node
FOR EACH ROW WHEN (((old.matcat_id)::TEXT IS DISTINCT FROM (new.matcat_id)::TEXT)) EXECUTE FUNCTION gw_trg_cat_material_fk('node');

CREATE TRIGGER gw_trg_cat_material_fk_insert AFTER INSERT ON connec
FOR EACH ROW EXECUTE FUNCTION gw_trg_cat_material_fk('connec');
CREATE TRIGGER gw_trg_cat_material_fk_update AFTER UPDATE OF matcat_id ON connec
FOR EACH ROW WHEN (((old.matcat_id)::TEXT IS DISTINCT FROM (new.matcat_id)::TEXT)) EXECUTE FUNCTION gw_trg_cat_material_fk('connec');

CREATE TRIGGER gw_trg_cat_material_fk_insert AFTER INSERT ON gully
FOR EACH ROW EXECUTE FUNCTION gw_trg_cat_material_fk('gully');

CREATE TRIGGER gw_trg_cat_material_fk_update AFTER UPDATE OF matcat_id ON gully
FOR EACH ROW WHEN (((old.matcat_id)::TEXT IS DISTINCT FROM (new.matcat_id)::TEXT)) EXECUTE FUNCTION gw_trg_cat_material_fk('gully');

CREATE TRIGGER gw_trg_edit_inp_coverage INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_coverage
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_coverage();

CREATE TRIGGER gw_trg_edit_inp_subcatchment INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_subcatchment
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_subcatchment('subcatchment');

CREATE TRIGGER gw_trg_edit_inp_subc2outlet INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_subc2outlet
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_subc2outlet();

CREATE TRIGGER gw_trg_edit_inp_timeseries INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_timeseries
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_timeseries('inp_timeseries');

CREATE TRIGGER gw_trg_edit_inp_timeseries INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_timeseries_value
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_timeseries('inp_timeseries_value');





CREATE TRIGGER gw_trg_edit_ve_epa_junction INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_epa_junction
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_ve_epa('junction');

CREATE TRIGGER gw_trg_edit_ve_epa_pump INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_epa_pump
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_ve_epa('pump');


--CREATE TRIGGER for parent view by passing parameter 'parent'
CREATE TRIGGER gw_trg_typevalue_fk_insert AFTER INSERT ON inp_frweir
FOR EACH ROW EXECUTE FUNCTION gw_trg_typevalue_fk('inp_frweir');

CREATE TRIGGER gw_trg_typevalue_fk_update AFTER UPDATE of weir_type, flap on inp_frweir
FOR EACH ROW WHEN (((old.weir_type)::TEXT IS DISTINCT FROM (new.weir_type)::text OR ((old.flap)::TEXT IS DISTINCT FROM (new.flap)::text))) EXECUTE FUNCTION gw_trg_typevalue_fk('inp_frweir');

CREATE TRIGGER gw_trg_typevalue_fk_insert AFTER INSERT ON inp_frpump
FOR EACH ROW EXECUTE FUNCTION gw_trg_typevalue_fk('inp_frpump');

CREATE TRIGGER gw_trg_typevalue_fk_update AFTER UPDATE of status ON inp_frpump
FOR EACH ROW WHEN (((old.status)::TEXT IS DISTINCT FROM (new.status)::text)) EXECUTE FUNCTION gw_trg_typevalue_fk('inp_frpump');

CREATE TRIGGER gw_trg_typevalue_fk_insert AFTER INSERT ON inp_froutlet
FOR EACH ROW EXECUTE FUNCTION gw_trg_typevalue_fk('inp_froutlet');

CREATE TRIGGER gw_trg_typevalue_fk_update AFTER UPDATE of outlet_type, flap on inp_froutlet
FOR EACH ROW WHEN ((((old.outlet_type)::TEXT IS DISTINCT FROM (new.outlet_type)::text) or ((old.flap)::TEXT IS DISTINCT FROM (new.flap)::text))) EXECUTE FUNCTION gw_trg_typevalue_fk('inp_froutlet');

CREATE trigger gw_trg_v_ui_drainzone INSTEAD OF INSERT OR UPDATE OR DELETE ON v_ui_drainzone
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_drainzone('UI');

CREATE TRIGGER gw_trg_edit_controls BEFORE DELETE OR UPDATE
ON dwfzone FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_controls('dwfzone_id');

CREATE trigger gw_trg_v_ui_sector INSTEAD OF INSERT OR UPDATE OR DELETE ON v_ui_sector
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_sector('UI');

CREATE trigger gw_trg_v_ui_macrosector INSTEAD OF INSERT OR UPDATE OR DELETE ON v_ui_macrosector
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_macrosector('UI');

CREATE trigger gw_trg_v_ui_dwfzone INSTEAD OF INSERT OR UPDATE OR DELETE ON v_ui_dwfzone
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_dwfzone('UI');

-- delete duplicated triggers
DROP TRIGGER IF EXISTS gw_trg_edit_macrosector ON v_edit_macrosector;

CREATE TRIGGER gw_trg_v_edit_macroomzone INSTEAD OF INSERT OR DELETE OR UPDATE
ON v_edit_macroomzone
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_macroomzone('EDIT');

CREATE TRIGGER gw_trg_v_edit_macrosector INSTEAD OF INSERT OR DELETE OR UPDATE
ON v_edit_macrosector
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_macrosector('EDIT');

CREATE TRIGGER gw_trg_typevalue_fk_insert AFTER INSERT
ON dwfzone FOR EACH ROW EXECUTE FUNCTION gw_trg_typevalue_fk('dwfzone');

CREATE TRIGGER gw_trg_typevalue_fk_update AFTER UPDATE OF dwfzone_type
ON dwfzone FOR EACH ROW WHEN (((old.dwfzone_type)::TEXT IS DISTINCT
FROM (new.dwfzone_type)::TEXT)) EXECUTE FUNCTION gw_trg_typevalue_fk('dwfzone');


CREATE TRIGGER gw_trg_ui_doc_x_arc INSTEAD OF INSERT OR DELETE OR UPDATE ON v_ui_doc_x_arc
FOR EACH ROW EXECUTE FUNCTION gw_trg_ui_doc('arc');

CREATE TRIGGER gw_trg_ui_doc_x_connec INSTEAD OF INSERT OR DELETE OR UPDATE ON v_ui_doc_x_connec
FOR EACH ROW EXECUTE FUNCTION gw_trg_ui_doc('connec');

CREATE TRIGGER gw_trg_ui_doc_x_gully INSTEAD OF INSERT OR DELETE OR UPDATE ON v_ui_doc_x_gully
FOR EACH ROW EXECUTE FUNCTION gw_trg_ui_doc('gully');

CREATE TRIGGER gw_trg_ui_doc_x_node INSTEAD OF INSERT OR DELETE OR UPDATE ON v_ui_doc_x_node
FOR EACH ROW EXECUTE FUNCTION gw_trg_ui_doc('node');

CREATE TRIGGER gw_trg_ui_doc_x_visit INSTEAD OF INSERT OR DELETE OR UPDATE ON v_ui_doc_x_visit
FOR EACH ROW EXECUTE FUNCTION gw_trg_ui_doc('visit');



CREATE TRIGGER gw_trg_edit_controls AFTER DELETE OR UPDATE ON node
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_controls('node_id');

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

CREATE TRIGGER gw_trg_topocontrol_node AFTER INSERT OR UPDATE OF the_geom, state, top_elev, ymax, elev, custom_top_elev, custom_ymax, custom_elev ON node
FOR EACH ROW EXECUTE FUNCTION gw_trg_topocontrol_node();

CREATE TRIGGER gw_trg_typevalue_fk_insert AFTER INSERT ON node
FOR EACH ROW EXECUTE FUNCTION gw_trg_typevalue_fk('node');

CREATE TRIGGER gw_trg_typevalue_fk_update AFTER UPDATE OF verified, datasource, lock_level ON node
FOR EACH ROW
    WHEN (((old.verified IS DISTINCT
FROM
    new.verified)
    OR (old.datasource IS DISTINCT
FROM
    new.datasource)
    OR (old.lock_level IS DISTINCT
FROM
    new.lock_level))) EXECUTE FUNCTION gw_trg_typevalue_fk('node');




CREATE TRIGGER gw_trg_arc_link_update AFTER UPDATE OF the_geom ON arc
FOR EACH ROW EXECUTE FUNCTION gw_trg_arc_link_update();

CREATE TRIGGER gw_trg_arc_node_values AFTER INSERT OR UPDATE OF node_1, node_2, the_geom ON arc
FOR EACH ROW EXECUTE FUNCTION gw_trg_arc_node_values();

CREATE TRIGGER gw_trg_arc_noderotation_update AFTER INSERT OR DELETE OR UPDATE OF the_geom ON arc
FOR EACH ROW EXECUTE FUNCTION gw_trg_arc_noderotation_update();

CREATE TRIGGER gw_trg_edit_controls AFTER DELETE OR UPDATE ON arc
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_controls('arc_id');

CREATE TRIGGER gw_trg_mantypevalue_fk_insert AFTER INSERT ON arc
FOR EACH ROW EXECUTE FUNCTION gw_trg_mantypevalue_fk('arc');

CREATE TRIGGER gw_trg_mantypevalue_fk_update AFTER UPDATE OF function_type, category_type, location_type ON arc
FOR EACH ROW
WHEN ((((old.function_type)::TEXT IS DISTINCT FROM (new.function_type)::TEXT)
OR ((old.category_type)::TEXT IS DISTINCT FROM (new.category_type)::TEXT)
OR ((old.location_type)::TEXT IS DISTINCT FROM (new.location_type)::TEXT)))
EXECUTE FUNCTION gw_trg_mantypevalue_fk('arc');

CREATE TRIGGER gw_trg_topocontrol_arc BEFORE INSERT OR UPDATE OF the_geom, y1, y2, elev1, elev2, custom_y1, custom_y2, custom_elev1, custom_elev2, state, inverted_slope ON arc
FOR EACH ROW EXECUTE FUNCTION gw_trg_topocontrol_arc();

CREATE TRIGGER gw_trg_typevalue_fk_insert AFTER INSERT ON arc
FOR EACH ROW EXECUTE FUNCTION gw_trg_typevalue_fk('arc');

CREATE TRIGGER gw_trg_typevalue_fk_update AFTER UPDATE OF verified, datasource, lock_level ON arc
FOR EACH ROW
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

CREATE TRIGGER gw_trg_edit_controls AFTER DELETE OR UPDATE ON connec
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_controls('connec_id');

CREATE TRIGGER gw_trg_link_data AFTER UPDATE OF state_type, expl_visibility, conneccat_id, fluid_type ON connec
FOR EACH ROW EXECUTE FUNCTION gw_trg_link_data('connec');

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

CREATE TRIGGER gw_trg_unique_field AFTER INSERT OR UPDATE OF customer_code, state ON connec
FOR EACH ROW EXECUTE FUNCTION gw_trg_unique_field('connec');




CREATE TRIGGER gw_trg_connect_update AFTER UPDATE OF arc_id, pjoint_id, pjoint_type, the_geom ON gully
FOR EACH ROW EXECUTE FUNCTION gw_trg_connect_update('gully');

CREATE TRIGGER gw_trg_edit_controls AFTER DELETE OR UPDATE ON gully
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_controls('gully_id');

CREATE TRIGGER gw_trg_gully_proximity_insert BEFORE INSERT ON gully
FOR EACH ROW EXECUTE FUNCTION gw_trg_gully_proximity();

CREATE TRIGGER gw_trg_gully_proximity_update AFTER UPDATE OF the_geom ON gully
FOR EACH ROW EXECUTE FUNCTION gw_trg_gully_proximity();

CREATE TRIGGER gw_trg_link_data AFTER UPDATE OF epa_type, state_type, expl_visibility, _connec_arccat_id, fluid_type ON gully
FOR EACH ROW EXECUTE FUNCTION gw_trg_link_data('gully');

CREATE TRIGGER gw_trg_typevalue_fk_insert AFTER INSERT ON gully
FOR EACH ROW EXECUTE FUNCTION gw_trg_typevalue_fk('gully');

CREATE TRIGGER gw_trg_typevalue_fk_update AFTER UPDATE OF verified, units_placement, datasource, lock_level ON gully
FOR EACH ROW
    WHEN (((old.verified IS DISTINCT
FROM
    new.verified)
    OR ((old.units_placement)::TEXT IS DISTINCT
FROM
    (new.units_placement)::TEXT)
        OR (old.datasource IS DISTINCT
    FROM
        new.datasource)
        OR (old.lock_level IS DISTINCT
    FROM
        new.lock_level))) EXECUTE FUNCTION gw_trg_typevalue_fk('gully');



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

CREATE TRIGGER gw_trg_edit_exploitation INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_exploitation
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_exploitation();



CREATE TRIGGER gw_trg_edit_review_audit_arc INSTEAD OF DELETE OR UPDATE ON v_edit_review_audit_arc
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_review_audit_arc();

CREATE TRIGGER gw_trg_edit_review_audit_connec INSTEAD OF DELETE OR UPDATE ON v_edit_review_audit_connec
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_review_audit_connec();

CREATE TRIGGER gw_trg_edit_review_audit_gully INSTEAD OF DELETE OR UPDATE ON v_edit_review_audit_gully
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_review_audit_gully();

CREATE TRIGGER gw_trg_edit_review_audit_node INSTEAD OF DELETE OR UPDATE ON v_edit_review_audit_node
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_review_audit_node();

CREATE TRIGGER gw_trg_edit_review_node INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_review_node
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_review_node();

CREATE TRIGGER gw_trg_edit_review_arc INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_review_arc
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_review_arc();

CREATE TRIGGER gw_trg_edit_review_gully INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_review_gully
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_review_gully();

CREATE TRIGGER gw_trg_edit_review_connec INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_review_connec
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_review_connec();

CREATE TRIGGER gw_trg_om_visit_singlevent INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_visit_node_singlevent
FOR EACH ROW EXECUTE FUNCTION gw_trg_om_visit_singlevent('node');

CREATE TRIGGER gw_trg_om_visit_singlevent INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_visit_arc_singlevent
FOR EACH ROW EXECUTE FUNCTION gw_trg_om_visit_singlevent('arc');

CREATE TRIGGER gw_trg_om_visit_singlevent INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_visit_connec_singlevent
FOR EACH ROW EXECUTE FUNCTION gw_trg_om_visit_singlevent('connec');

CREATE TRIGGER gw_trg_om_visit_singlevent INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_visit_gully_singlevent
FOR EACH ROW EXECUTE FUNCTION gw_trg_om_visit_singlevent('gully');

CREATE TRIGGER gw_trg_edit_visitman_x_gully INSTEAD OF DELETE ON v_ui_om_visitman_x_gully
FOR EACH ROW EXECUTE FUNCTION gw_trg_ui_visitman();

CREATE TRIGGER gw_trg_ui_event_x_gully INSTEAD OF INSERT OR DELETE OR UPDATE ON v_ui_event_x_gully
FOR EACH ROW EXECUTE FUNCTION gw_trg_ui_event('om_visit_event');

CREATE TRIGGER gw_trg_edit_ve_epa_netgully INSTEAD OF
INSERT
    OR
DELETE
    OR
UPDATE
    ON
    ve_epa_netgully FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_ve_epa('netgully');



CREATE TRIGGER gw_trg_edit_ve_epa_outfall INSTEAD OF
INSERT
    OR
DELETE
    OR
UPDATE
    ON
    ve_epa_outfall FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_ve_epa('outfall');

CREATE TRIGGER gw_trg_edit_ve_epa_conduit INSTEAD OF
INSERT
    OR
DELETE
    OR
UPDATE
    ON
    ve_epa_conduit FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_ve_epa('conduit');



CREATE TRIGGER gw_trg_edit_ve_epa_outlet INSTEAD OF
INSERT
    OR
DELETE
    OR
UPDATE
    ON
    ve_epa_outlet FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_ve_epa('outlet');



CREATE TRIGGER gw_trg_edit_ve_epa_weir INSTEAD OF
INSERT
    OR
DELETE
    OR
UPDATE
    ON
    ve_epa_weir FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_ve_epa('weir');


CREATE TRIGGER gw_trg_edit_ve_epa_gully INSTEAD OF
INSERT
    OR
DELETE
    OR
UPDATE
    ON
    ve_epa_gully FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_ve_epa('gully');

CREATE TRIGGER gw_trg_plan_psector_x_arc BEFORE
INSERT
    OR
UPDATE
    OF arc_id,
    state ON
    plan_psector_x_arc FOR EACH ROW EXECUTE FUNCTION gw_trg_plan_psector_x_arc();

CREATE TRIGGER gw_trg_plan_psector_link AFTER
INSERT
    OR
UPDATE
    OF arc_id ON
    plan_psector_x_connec FOR EACH ROW EXECUTE FUNCTION gw_trg_plan_psector_link('connec');

CREATE TRIGGER gw_trg_plan_psector_x_connec BEFORE
INSERT
    OR
UPDATE
    OF connec_id,
    state ON
    plan_psector_x_connec FOR EACH ROW EXECUTE FUNCTION gw_trg_plan_psector_x_connec();

CREATE TRIGGER gw_trg_plan_psector_link AFTER
INSERT
    OR
UPDATE
    OF arc_id ON
    plan_psector_x_gully FOR EACH ROW EXECUTE FUNCTION gw_trg_plan_psector_link('gully');

CREATE TRIGGER gw_trg_plan_psector_x_gully BEFORE
INSERT
    OR
UPDATE
    OF gully_id,
    state ON
    plan_psector_x_gully FOR EACH ROW EXECUTE FUNCTION gw_trg_plan_psector_x_gully();

CREATE TRIGGER gw_trg_edit_plan_psector_gully INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_plan_psector_x_gully
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_plan_psector_x_connect('plan_psector_x_gully');


CREATE TRIGGER gw_trg_edit_ve_epa_storage INSTEAD OF
INSERT
    OR
DELETE
    OR
UPDATE
    ON
    ve_epa_storage FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_ve_epa('storage');

CREATE TRIGGER gw_trg_edit_ve_epa_virtual INSTEAD OF
INSERT
    OR
DELETE
    OR
UPDATE
    ON
    ve_epa_virtual FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_ve_epa('virtual');


CREATE TRIGGER gw_trg_edit_inp_arc_virtual INSTEAD OF
INSERT
    OR
DELETE
    OR
UPDATE
    ON
    v_edit_inp_virtual FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_arc('inp_virtual');

CREATE TRIGGER gw_trg_edit_cat_feature INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_cat_feature_connec
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_cat_feature('connec');
