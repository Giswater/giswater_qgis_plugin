/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
 */


CREATE SEQUENCE "SCHEMA_NAME".log_node_seq
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

  CREATE SEQUENCE "SCHEMA_NAME".log_arc_seq
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;


-- ----------------------------
-- Table structure
-- ----------------------------

CREATE TABLE "SCHEMA_NAME"."adm_list_user" (
"id" varchar(16) COLLATE "default" NOT NULL,
"name" varchar(40) COLLATE "default" NOT NULL,
"surname_1" varchar(40) COLLATE "default" NOT NULL,
"surname_2" varchar(40) COLLATE "default" NOT NULL,
"role" varchar(40) COLLATE "default" NOT NULL,
"descript" varchar(50) COLLATE "default",
"email" varchar(50) COLLATE "default",
"comment" varchar(512) COLLATE "default",
CONSTRAINT admin_list_user_pkey PRIMARY KEY (id)
)
WITH (OIDS=FALSE)
;


CREATE TABLE SCHEMA_NAME.adm_log_node(
"id" int8 DEFAULT nextval('"SCHEMA_NAME".log_node_seq'::regclass) NOT NULL,
"node_id" varchar(16),
"elevation" numeric(12,4) DEFAULT 0.00,
"enet_type" varchar(18) COLLATE "default",
"sector_id" varchar(30) COLLATE "default",
"the_geom" public.geometry (POINT, SRID_VALUE),
"node_type" character varying(16),
"depth" numeric(12,3) DEFAULT 0.00,
"link" character varying(254),
"state" character varying(254),
"annotation" character varying(254),
"observ" character varying(254),
"event" character varying(30),
"operation" character varying(6),
"user" varchar (20),
"date" timestamp (6) without time zone
)
WITH (
  OIDS=FALSE);
  
ALTER TABLE "SCHEMA_NAME"."adm_log_node" ADD PRIMARY KEY ("id");



CREATE TABLE SCHEMA_NAME.adm_log_arc(
"id" int8 DEFAULT nextval('"SCHEMA_NAME".log_arc_seq'::regclass) NOT NULL,
"arc_id" varchar(16),
"arccat_id" varchar(16) COLLATE "default",
"enet_type" varchar(18) COLLATE "default",
"sector_id" varchar(30) COLLATE "default",
"the_geom" public.geometry (LINESTRING, SRID_VALUE),
"arc_type" character varying(16),
"link" character varying(254),
"state" character varying(254),
"annotation" character varying(254),
"observ" character varying(254),
"event" character varying(30),
"operation" character varying(6),
"user" varchar (20),
"date" timestamp (6) without time zone

)
WITH (
  OIDS=FALSE);
  
ALTER TABLE "SCHEMA_NAME"."adm_log_arc" ADD PRIMARY KEY ("id");
 




 
CREATE OR REPLACE FUNCTION SCHEMA_NAME.adm_log_node() RETURNS trigger AS
$BODY$BEGIN

	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
	
      IF TG_OP = 'INSERT' THEN
        INSERT INTO adm_log_node VALUES( nextval('log_node_seq'::regclass),NEW.node_id, NEW.elevation, NEW.enet_type, NEW.sector_id, NEW.the_geom, NEW.node_type, NEW."depth", NEW.link, NEW."state", NEW.annotation, NEW.observ, NEW.event, 'INSERT', user, CURRENT_TIMESTAMP);
        RETURN NEW;

      ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO adm_log_node VALUES( nextval('log_node_seq'::regclass),OLD.node_id, OLD.elevation, OLD.enet_type, OLD.sector_id, OLD.the_geom, OLD.node_type, OLD."depth", OLD.link, OLD."state", OLD.annotation, OLD.observ, OLD.event, 'UPDATE', user, CURRENT_TIMESTAMP);
       RETURN NEW;

      ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO adm_log_node VALUES( nextval('log_node_seq'::regclass),OLD.node_id, OLD.elevation, OLD.enet_type, OLD.sector_id, OLD.the_geom, OLD.node_type, OLD."depth", OLD.link, OLD."state", OLD.annotation, OLD.observ, OLD.event, 'DELETE', user, CURRENT_TIMESTAMP);
       RETURN NULL;
      END IF;
     RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

 
  
CREATE OR REPLACE FUNCTION SCHEMA_NAME.adm_log_arc() RETURNS trigger AS
$BODY$BEGIN

	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

	IF TG_OP = 'INSERT' THEN
        INSERT INTO adm_log_arc VALUES( nextval('log_arc_seq'::regclass),NEW.arc_id, NEW.arccat_id, NEW.enet_type, NEW.sector_id, NEW.the_geom, NEW.arc_type, NEW.link, NEW."state", NEW.annotation, NEW.observ, NEW.event, 'INSERT', user, CURRENT_TIMESTAMP);
        RETURN NEW;

      ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO adm_log_arc VALUES( nextval('log_arc_seq'::regclass),OLD.arc_id, OLD.arccat_id, OLD.enet_type, OLD.sector_id, OLD.the_geom, OLD.arc_type, OLD.link, OLD."state", OLD.annotation, OLD.observ, OLD.event, 'UPDATE', user, CURRENT_TIMESTAMP);
       RETURN NEW;

      ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO adm_log_arc VALUES( nextval('log_arc_seq'::regclass),OLD.arc_id, OLD.arccat_id, OLD.enet_type, OLD.sector_id, OLD.the_geom, OLD.arc_type, OLD.link, OLD."state", OLD.annotation, OLD.observ, OLD.event, 'DELETE', user, CURRENT_TIMESTAMP);
       RETURN NULL;
      END IF;
     RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

--DROP TRIGGER adm_log_node; 
 CREATE TRIGGER adm_log_node
  AFTER INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.node FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.adm_log_node();
  
--DROP TRIGGER adm_log_arc;  
CREATE TRIGGER adm_log_arc
  AFTER INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.arc FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.adm_log_arc();
 
 
 