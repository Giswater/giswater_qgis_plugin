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
    curve_id varchar(16) NOT NULL,
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

-- 12/05/2025
DROP TABLE IF EXISTS node_border_sector;


-- 14/05/2025
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
    the_geom public.geometry(multipolygon, 25831) NULL,
	CONSTRAINT subcatchment_pkey PRIMARY KEY (subc_id, hydrology_id),
	CONSTRAINT subcatchment_hydrology_id_fkey FOREIGN KEY (hydrology_id) REFERENCES cat_hydrology(hydrology_id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT subcatchment_rg_id_fkey FOREIGN KEY (rg_id) REFERENCES raingage(rg_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT subcatchment_sector_id_fkey FOREIGN KEY (sector_id) REFERENCES sector(sector_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT subcatchment_snow_id_fkey FOREIGN KEY (snow_id) REFERENCES inp_snowpack(snow_id) ON DELETE RESTRICT ON UPDATE CASCADE
);
CREATE INDEX subcathment_index ON inp_subcatchment USING gist (the_geom);


-- 20/05/2025
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"arc_add", "column":"conduit_capacity", "dataType":"float", "isUtils":"False"}}$$);

-- 10/06/2025
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
