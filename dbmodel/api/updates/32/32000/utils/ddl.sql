/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


CREATE TABLE config_api_form(
  id serial PRIMARY KEY,
  formname character varying(50),
  projecttype character varying,
  actions json,
  layermanager json);
  


CREATE TABLE config_api_form_tabs(
  id integer NOT NULL,
  formname character varying(50),
  tabname text,
  tablabel text,
  tabtext text,
  sys_role text,
  tooltip text,
  tabfunction json,
  tabactions json,
  device integer,
  CONSTRAINT config_api_form_tabs_pkey PRIMARY KEY (id)
);  


CREATE TABLE config_api_list(
  id serial NOT NULL,
  tablename character varying(50),
  query_text text,
  device smallint,
  actionfields json,
  listtype character varying(30),
  listclass character varying(30),
  vdefault json,
  CONSTRAINT config_api_list_pkey PRIMARY KEY (id)
);




CREATE TABLE config_api_message(
  id integer NOT NULL,
  loglevel integer,
  message text,
  hintmessage text,
  mtype text,
  CONSTRAINT config_api_message_pkey PRIMARY KEY (id)
);



CREATE TABLE config_api_images (
  id serial,
  idval text,
  image bytea,
  CONSTRAINT config_web_images_pkey PRIMARY KEY (id)
);


CREATE TABLE config_api_visit (
  visitclass_id serial NOT NULL,
  formname character varying(30),
  tablename character varying(30),
  CONSTRAINT config_api_visit_pkey PRIMARY KEY (visitclass_id),
--  CONSTRAINT config_api_vist_fkey FOREIGN KEY (visitclass_id)
-- REFERENCES om_visit_class (id) MATCH SIMPLE
  --    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT config_api_visit_formname_key UNIQUE (formname)
);



CREATE TABLE config_api_form_groupbox(
  id SERIAL PRIMARY KEY,
  formname character varying(50) NOT NULL,
  layout_id integer,
  label text
);

CREATE TABLE config_api_visit_x_featuretable(
  tablename character varying(30) NOT NULL,
  visitclass_id integer NOT NULL,
  CONSTRAINT config_api_visit_x_table_pkey PRIMARY KEY (visitclass_id, tablename)
);