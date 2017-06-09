/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;


-------------
-- NEW SEQUENCES
-------------


CREATE SEQUENCE subc_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


CREATE SEQUENCE doc_x_tag_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


-------------
-- NEW TABLES
-------------

-- ADDING MACRODMA

CREATE TABLE macrodma (
macrodma_id character varying(50) NOT NULL PRIMARY KEY,
descript character varying(100),
the_geom geometry(POLYGON,SRID_VALUE),
undelete boolean,
expl_id integer
);


-- ADDING RELATION 1-N BETEEWN DOCS AND TAGS

CREATE TABLE doc_x_tag(
  id bigint NOT NULL DEFAULT nextval('doc_x_tag_seq'::regclass) PRIMARY KEY,
  doc_id character varying(30),
  tag_id character varying(16)
);





 -- PROFILE TOOLS

CREATE TABLE anl_arc_profile_value
(
  id serial NOT NULL,
  profile_id character varying(30) NOT NULL,
  arc_id bigint NOT NULL,
  start_point bigint,
  end_point bigint,
  CONSTRAINT anl_arc_profile_value_pkey PRIMARY KEY (id)
);


 -- ANALYSIS
 
 CREATE TABLE "anl_node_sink" (
node_id varchar (16) NOT NULL,
num_arcs integer,
the_geom public.geometry (POINT, SRID_VALUE),
CONSTRAINT anl_sink_pkey PRIMARY KEY (node_id)
);


CREATE INDEX anl_node_sink_index ON anl_node_sink USING GIST (the_geom);

  
  -- PHOTO
 
 
 CREATE TABLE om_visit_event_photo
(
  id bigserial NOT NULL,
  visit_id bigint NOT NULL,
  event_id bigint NOT NULL,
  tstamp timestamp(6) without time zone DEFAULT now(),
  value text,
  text text,
  compass double precision,
  CONSTRAINT om_visit_event_foto_pkey PRIMARY KEY (id),

);

  
-- ----------------------------
-- REVIEW AND UPDATE DATA ON WEB/MOBILE CLIENT
-- ----------------------------
	
DROP TABLE IF EXISTS review_arc;
CREATE TABLE review_arc
(  arc_id character varying(16) NOT NULL,
  the_geom geometry(LINESTRING,SRID_VALUE),
  y1 numeric(12,3),
  y2 numeric(12,3),
  arc_type character varying(16),
  arccat_id character varying(30),
  annotation character varying(254),
  verified character varying(16),
  field_checked boolean,
  office_checked boolean,
  CONSTRAINT review_arc_pkey PRIMARY KEY (arc_id)
);

DROP TABLE IF EXISTS review_node;
CREATE TABLE review_node
( node_id character varying(16) NOT NULL,
  the_geom geometry(POINT,SRID_VALUE),
  top_elev numeric(12,3),
  ymax numeric(12,3),
  node_type character varying(16),
  cat_matcat character varying(16),
  dimensions character varying(16),
  annotation character varying(254),
  observ character varying(254),
  verified character varying(16),
  field_checked boolean,
  office_checked boolean,
  CONSTRAINT review_node_pkey PRIMARY KEY (node_id)
  );

DROP TABLE IF EXISTS review_connec;
CREATE TABLE review_connec
( connec_id character varying(16) NOT NULL,
  the_geom geometry(POINT,SRID_VALUE),
  top_elev numeric(12,3),
  ymax numeric(12,3),
  connec_type character varying(16),
  connecat_id character varying(16),
  annotation character varying(254),
  observ character varying(254),
  verified character varying(16),
  field_checked boolean,
  office_checked boolean,
  CONSTRAINT review_connec_pkey PRIMARY KEY (node_id)
  );
  
  DROP TABLE IF EXISTS review_gully;
CREATE TABLE review_gully
( gully_id character varying(16) NOT NULL,
  the_geom geometry(POINT,SRID_VALUE),
  top_elev numeric(12,3),
  ymax numeric(12,3),
  matcat_id character varying(18),
  gratecat_id character varying(18),
  units smallint,
  groove character varying(3),
  arccat_id character varying(18),
  arc_id character varying(16),
  siphon character varying(3),
  featurecat_id character varying(50),
  feature_id character varying(16)
  connec_type character varying(16),
  conneccat_id character varying(16),
  annotation character varying(254),
  observ character varying(254),
  verified character varying(16),
  field_checked boolean,
  office_checked boolean,
  CONSTRAINT review_gully_pkey PRIMARY KEY (node_id)
  );
  
DROP TABLE IF EXISTS review_audit_arc;
CREATE TABLE review_audit_arc
(  arc_id character varying(16) NOT NULL,
  the_geom geometry(LINESTRING,SRID_VALUE),
  y1 numeric(12,3),
  y2 numeric(12,3),
  arc_type character varying(16),
  arccat_id character varying(30),
  annotation character varying(254),
  verified character varying(16),
   moved_geom boolean,
  field_checked boolean,
  "operation" character varying(25),
  "user" varchar (50),  
  date_field timestamp (6) without time zone,
  office_checked boolean,
  CONSTRAINT review_audit_arc_pkey PRIMARY KEY (arc_id)
  );
  
DROP TABLE IF EXISTS review_audit_node;
CREATE TABLE review_audit_node
(  node_id character varying(16) NOT NULL,
  the_geom geometry(POINT,SRID_VALUE),
  top_elev numeric(12,3),
  ymax numeric(12,3),
  node_type character varying(16),
  cat_matcat character varying(16),
  dimensions character varying(16),
  annotation character varying(254),
  observ character varying(254),
  verified character varying(16),
  moved_geom boolean,
  field_checked boolean,
  "operation" character varying(25),
  "user" varchar (50),  
  date_field timestamp (6) without time zone,
  office_checked boolean,
  CONSTRAINT review_audit_node_pkey PRIMARY KEY (node_id)
  );
  
DROP TABLE IF EXISTS review_audit_connec;
CREATE TABLE review_audit_connec
(  connec_id character varying(16) NOT NULL,
  the_geom geometry(POINT,SRID_VALUE),
  top_elev numeric(12,3),
  ymax numeric(12,3),
  connec_type character varying(16),
  connecat_id character varying(16),
  annotation character varying(254),
  observ character varying(254),
  verified character varying(16),
  moved_geom boolean,
  field_checked boolean,
  "operation" character varying(25),
  "user" varchar (50),  
  date_field timestamp (6) without time zone,
  office_checked boolean,
  CONSTRAINT review_audit_connec_pkey PRIMARY KEY (connec_id)
  );
  
  DROP TABLE IF EXISTS review_audit_gully;
CREATE TABLE review_audit_gully
(  gully_id character varying(16) NOT NULL,
  the_geom geometry(POINT,SRID_VALUE),
  top_elev numeric(12,3),
  ymax numeric(12,3),
  matcat_id character varying(18),
  gratecat_id character varying(18),
  units smallint,
  groove character varying(3),
  arccat_id character varying(18),
  arc_id character varying(16),
  siphon character varying(3),
  featurecat_id character varying(50),
  feature_id character varying(16),
  annotation character varying(254),
  observ character varying(254),
  verified character varying(16),
  moved_geom boolean,
  field_checked boolean,
  "operation" character varying(25),
  "user" varchar (50),  
  date_field timestamp (6) without time zone,
  office_checked boolean,
  CONSTRAINT review_audit_gully_pkey PRIMARY KEY (gully_id)
  );
 
-------------
-- ALTER TABLES
-------------

ALTER TABLE point ADD COLUMN link text;

ALTER TABLE samplepoint ADD COLUMN dma_id character varying(30);
ALTER TABLE samplepoint ADD COLUMN sector_id character varying(30);
ALTER TABLE samplepoint ADD COLUMN expl_id integer;
ALTER TABLE samplepoint ADD COLUMN workcat_id character varying(255);
ALTER TABLE samplepoint ADD COLUMN workcat_id_end character varying(255);

ALTER TABLE arc ADD COLUMN expl_id integer;
ALTER TABLE node ADD COLUMN expl_id integer;
ALTER TABLE connec ADD COLUMN expl_id integer;
ALTER TABLE gully ADD COLUMN expl_id integer;
ALTER TABLE raingage ADD COLUMN expl_id integer;
ALTER TABLE subcatchment ADD COLUMN expl_id integer;
ALTER TABLE polygon ADD COLUMN expl_id integer;
ALTER TABLE vnode ADD COLUMN expl_id integer;
ALTER TABLE link ADD COLUMN expl_id integer;
ALTER TABLE point ADD COLUMN expl_id integer;
ALTER TABLE samplepoint ADD COLUMN expl_id integer;
ALTER TABLE om_visit ADD COLUMN expl_id integer;
ALTER TABLE plan_psector ADD COLUMN expl_id integer;
ALTER TABLE element ADD COLUMN expl_id integer;
ALTER TABLE catchment ADD COLUMN expl_id integer;

ALTER TABLE sector ADD COLUMN expl_id integer;
ALTER TABLE dma ADD COLUMN expl_id integer;

ALTER TABLE node ADD COLUMN code varchar(30);
ALTER TABLE arc ADD COLUMN code varchar(30);
ALTER TABLE gully ADD COLUMN code varchar(30);
ALTER TABLE element ADD COLUMN code varchar(30);

ALTER TABLE node ADD COLUMN publish boolean;
ALTER TABLE arc ADD COLUMN publish boolean;
ALTER TABLE connec ADD COLUMN publish boolean;
ALTER TABLE gully ADD COLUMN publish boolean;
ALTER TABLE element ADD COLUMN publish boolean;

ALTER TABLE node ADD COLUMN inventory boolean;
ALTER TABLE arc ADD COLUMN inventory boolean;
ALTER TABLE connec ADD COLUMN inventory boolean;
ALTER TABLE gully ADD COLUMN inventory boolean;
ALTER TABLE element ADD COLUMN inventory boolean;

ALTER TABLE node ADD COLUMN end_date date;
ALTER TABLE arc ADD COLUMN end_date date;
ALTER TABLE connec ADD COLUMN end_date date;
ALTER TABLE gully ADD COLUMN end_date date;

ALTER TABLE node ADD COLUMN uncertain boolean;
ALTER TABLE arc ADD COLUMN uncertain boolean;
ALTER TABLE connec ADD COLUMN uncertain boolean;

ALTER TABLE node ADD COLUMN xyz_date date;
ALTER TABLE node ADD COLUMN unconnected boolean;

ALTER TABLE gully ADD COLUMN streetaxis_id character varying(16);
ALTER TABLE gully ADD COLUMN postnumber character varying(16);

ALTER TABLE element ADD COLUMN the_geom geometry(Point,25831);

ALTER TABLE cat_work ADD COLUMN workid_key1 character varying(30);
ALTER TABLE cat_work ADD COLUMN workid_key2 character varying(30);
ALTER TABLE cat_work ADD COLUMN builtdate date;

ALTER TABLE dma ADD COLUMN macrodma_id character varying(50);

ALTER TABLE om_visit ADD COLUMN  webclient_id character varying(50);

ALTER TABLE om_event ADD COLUMN  picture_id character varying(50);

ALTER TABLE cat_grate ADD COLUMN madeby character varying(100);
ALTER TABLE cat_grate ADD COLUMN model character varying(100);

ALTER TABLE man_manhole ADD COLUMN inlet boolean;
ALTER TABLE man_manhole ADD COLUMN bottom_channel boolean;
ALTER TABLE man_manhole ADD COLUMN accessibility varchar(16);

ALTER TABLE man_chamber ADD COLUMN inlet boolean;
ALTER TABLE man_chamber ADD COLUMN bottom_channel boolean;
ALTER TABLE man_chamber ADD COLUMN accessibility varchar(16);

ALTER TABLE man_netinit ADD COLUMN inlet boolean;
ALTER TABLE man_netinit ADD COLUMN bottom_channel  boolean;
ALTER TABLE man_netinit ADD COLUMN accessibility varchar(16);

ALTER TABLE cat_node ADD COLUMN shape character varying(16);

ALTER TABLE cat_node ADD COLUMN active boolean;
ALTER TABLE cat_arc ADD COLUMN active boolean;
ALTER TABLE cat_connec ADD COLUMN active boolean;
ALTER TABLE cat_element ADD COLUMN active boolean;
ALTER TABLE cat_grate ADD COLUMN active boolean;

ALTER TABLE cat_element ADD COLUMN madeby character varying(100);
ALTER TABLE cat_element ADD COLUMN model character varying(100);


ALTER TABLE doc_x_tag ADD CONSTRAINT doc_x_tag_tag_id_fkey FOREIGN KEY (tag_id) REFERENCES cat_tag (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE doc_x_tag ADD CONSTRAINT doc_x_tag_doc_id_fkey FOREIGN KEY (doc_id) REFERENCES doc (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE arc  ADD CONSTRAINT arc_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation (expl_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE node  ADD CONSTRAINT node_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation (expl_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE connec  ADD CONSTRAINT connec_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation (expl_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE gully ADD CONSTRAINT gully_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation (expl_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE polygon  ADD CONSTRAINT polygon_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation (expl_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE vnode  ADD CONSTRAINT vnode_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation (expl_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE link  ADD CONSTRAINT link_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation (expl_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE point  ADD CONSTRAINT point_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation (expl_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE samplepoint  ADD CONSTRAINT samplepoint_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation (expl_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE om_visit  ADD CONSTRAINT om_visit_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation (expl_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE plan_psector  ADD CONSTRAINT plan_psector_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation (expl_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE raingage  ADD CONSTRAINT raingage_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation (expl_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE catchment  ADD CONSTRAINT catchment_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation (expl_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE subcatchment  ADD CONSTRAINT subcatchment_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation (expl_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE gully ADD CONSTRAINT gully_streetaxis_id_fkey FOREIGN KEY (streetaxis_id) REFERENCES ext_streetaxis (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE arc  ADD CONSTRAINT arc_macrodma_id_fkey FOREIGN KEY (macrodma_id) REFERENCES macrodma_selector (macrodma_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE node  ADD CONSTRAINT node_macrodma_id_fkey FOREIGN KEY (macrodma_id) REFERENCES macrodma_selector (macrodma_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE connec  ADD CONSTRAINT connec_macrodma_id_fkey FOREIGN KEY (macrodma_id) REFERENCES macrodma_selector (macrodma_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE gully ADD CONSTRAINT gully_macrodma_id_fkey FOREIGN KEY (macrodma_id) REFERENCES macrodma_selector (macrodma_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;


 CONSTRAINT om_visit_event_foto_event_id_fkey FOREIGN KEY (event_id)      REFERENCES om_visit_event (id) MATCH SIMPLE      ON UPDATE CASCADE ON DELETE RESTRICT;
 CONSTRAINT om_visit_event_foto_visit_id_fkey FOREIGN KEY (visit_id)      REFERENCES om_visit (id) MATCH SIMPLE      ON UPDATE CASCADE ON DELETE RESTRICT;
  

