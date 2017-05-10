/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;


CREATE SEQUENCE doc_x_tag_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

	
CREATE SEQUENCE pol_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
  
  
CREATE SEQUENCE pond_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
	
CREATE SEQUENCE pool_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

CREATE SEQUENCE sample_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

CREATE SEQUENCE point_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

CREATE SEQUENCE polygon_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

  
CREATE TABLE polygon(
  pol_id character varying(16) NOT NULL PRIMARY KEY,
  text character varying(254),
  the_geom geometry(POLYGON,SRID_VALUE),
  undelete boolean
);


CREATE TABLE macrodma(
macrodma_id character varying(50) NOT NULL PRIMARY KEY,
descript character varying(100),
the_geom geometry(POLYGON,SRID_VALUE),
undelete boolean
);


CREATE TABLE doc_x_tag(
  id bigint NOT NULL DEFAULT nextval('doc_x_tag_seq'::regclass) PRIMARY KEY,
  doc_id character varying(30),
  tag_id character varying(16)
);


 -- fotos
 
 
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

    


ALTER TABLE ws_sample.anl_mincut_result_cat ADD COLUMN anl_cause character varying (30);
ALTER TABLE ws_sample.anl_mincut_result_cat ADD COLUMN anl_the_geom public.geometry(POINT, SRID_VALUE);
ALTER TABLE ws_sample.anl_mincut_result_cat ADD COLUMN exec_the_geom public.geometry(POINT, SRID_VALUE);
ALTER TABLE ws_sample.anl_mincut_result_cat ADD COLUMN exec_depth float;
ALTER TABLE ws_sample.anl_mincut_result_cat ADD COLUMN exec_limit_distance float;
ALTER TABLE ws_sample.anl_mincut_result_cat ADD COLUMN exec_appropiate boolean;	

ALTER TABLE arc ADD COLUMN expl_id integer;
ALTER TABLE node ADD COLUMN expl_id integer;
ALTER TABLE connec ADD COLUMN expl_id integer;

ALTER TABLE polygon ADD COLUMN expl_id integer;
ALTER TABLE vnode ADD COLUMN expl_id integer;
ALTER TABLE link ADD COLUMN expl_id integer;
ALTER TABLE point ADD COLUMN expl_id integer;
ALTER TABLE pond ADD COLUMN expl_id integer;
ALTER TABLE pool ADD COLUMN expl_id integer;
ALTER TABLE samplepoint ADD COLUMN expl_id integer;
ALTER TABLE om_visit ADD COLUMN expl_id integer;
ALTER TABLE plan_psector ADD COLUMN expl_id integer;
ALTER TABLE element ADD COLUMN expl_id integer;

ALTER TABLE sector ADD COLUMN expl_id integer;
ALTER TABLE dma ADD COLUMN expl_id integer;
ALTER TABLE macrodma ADD COLUMN expl_id integer;
ALTER TABLE presszone ADD COLUMN expl_id integer;

ALTER TABLE node ADD COLUMN code varchar(30);
ALTER TABLE arc ADD COLUMN code varchar(30);
ALTER TABLE element ADD COLUMN code varchar(30);

ALTER TABLE node ADD COLUMN publish boolean;
ALTER TABLE arc ADD COLUMN publish boolean;
ALTER TABLE connec ADD COLUMN publish boolean;
ALTER TABLE element ADD COLUMN publish boolean;

ALTER TABLE node ADD COLUMN inventory boolean;
ALTER TABLE arc ADD COLUMN inventory boolean;
ALTER TABLE connec ADD COLUMN inventory boolean;
ALTER TABLE element ADD COLUMN inventory boolean;

ALTER TABLE node ADD COLUMN end_date date;
ALTER TABLE arc ADD COLUMN end_date date;
ALTER TABLE connec ADD COLUMN end_date date;

ALTER TABLE element ADD COLUMN the_geom geometry(POINT,SRID_VALUE);

ALTER TABLE man_pump ADD COLUMN elev_height numeric(12,4);

ALTER TABLE man_valve ADD COLUMN cat_valve2 character varying(30);
ALTER TABLE man_tap ADD COLUMN cat_valve2 character varying(30);
ALTER TABLE man_wjoin ADD COLUMN cat_valve2 character varying(30);

ALTER TABLE man_fountain ADD COLUMN linked_connec character varying(16);
ALTER TABLE man_tap ADD COLUMN linked_connec character varying(16);
ALTER TABLE man_greentap ADD COLUMN linked_connec character varying(16);

ALTER TABLE man_fountain ADD COLUMN the_geom_pol geometry(POLYGON,SRID_VALUE);

ALTER TABLE cat_work ADD COLUMN workid_key1 character varying(30);
ALTER TABLE cat_work ADD COLUMN workid_key2 character varying(30);
ALTER TABLE cat_work ADD COLUMN builtdate date;

ALTER TABLE dma ADD COLUMN macrodma_id character varying(50);

ALTER TABLE node ADD COLUMN macrodma_id character varying(50);
ALTER TABLE arc ADD COLUMN macrodma_id character varying(50);
ALTER TABLE connec ADD COLUMN macrodma_id character varying(50);

ALTER TABLE om_visit ADD COLUMN  webclient_id character varying(50);

ALTER TABLE om_event ADD COLUMN  picture_id character varying(50);

ALTER TABLE cat_node ADD COLUMN active boolean;
ALTER TABLE cat_arc ADD COLUMN active boolean;
ALTER TABLE cat_connec ADD COLUMN active boolean;
ALTER TABLE cat_element ADD COLUMN active boolean;

ALTER TABLE cat_node ADD COLUMN madeby character varying(100);
ALTER TABLE cat_node ADD COLUMN model character varying(100);

ALTER TABLE cat_element ADD COLUMN madeby character varying(100);
ALTER TABLE cat_element ADD COLUMN model character varying(100);

ALTER TABLE man_tank ADD COLUMN pol_id character varying(16);

ALTER TABLE doc_x_tag ADD CONSTRAINT doc_x_tag_tag_id_fkey FOREIGN KEY (tag_id) REFERENCES cat_tag (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE doc_x_tag ADD CONSTRAINT doc_x_tag_doc_id_fkey FOREIGN KEY (doc_id) REFERENCES doc (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE arc  ADD CONSTRAINT arc_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES expl_selector (expl_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE node  ADD CONSTRAINT node_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES expl_selector (expl_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE connec  ADD CONSTRAINT connec_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES expl_selector (expl_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE polygon  ADD CONSTRAINT polygon_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation (expl_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE vnode  ADD CONSTRAINT vnode_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation (expl_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE link  ADD CONSTRAINT link_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation (expl_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE point  ADD CONSTRAINT point_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation (expl_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE pond  ADD CONSTRAINT pond_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation (expl_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE pool  ADD CONSTRAINT pool_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation (expl_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE samplepoint  ADD CONSTRAINT samplepoint_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation (expl_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE om_visit  ADD CONSTRAINT om_visit_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation (expl_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE plan_psector  ADD CONSTRAINT plan_psector_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation (expl_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE man_valve  ADD CONSTRAINT cat_node_cat_valve2_fkey FOREIGN KEY (cat_valve2) REFERENCES cat_node (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE man_tap  ADD CONSTRAINT cat_node_cat_valve2_fkey FOREIGN KEY (cat_valve2) REFERENCES cat_node (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE man_wjoin  ADD CONSTRAINT cat_node_cat_valve2_fkey FOREIGN KEY (cat_valve2) REFERENCES cat_node (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE man_fountain  ADD CONSTRAINT connec_linked_connec_fkey FOREIGN KEY (linked_connec) REFERENCES connec (connec_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE man_tap  ADD CONSTRAINT connec_linked_connec_fkey FOREIGN KEY (linked_connec) REFERENCES connec (connec_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE man_greentap  ADD CONSTRAINT connec_linked_connec_fkey FOREIGN KEY (linked_connec) REFERENCES connec (connec_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;


 CONSTRAINT om_visit_event_foto_event_id_fkey FOREIGN KEY (event_id)
      REFERENCES om_visit_event (id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT om_visit_event_foto_visit_id_fkey FOREIGN KEY (visit_id)
      REFERENCES om_visit (id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT
  
