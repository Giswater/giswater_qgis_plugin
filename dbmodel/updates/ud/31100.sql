/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

  
SET search_path = "SCHEMA_NAME", public, pg_catalog;


  
   
-------------
--01/06/2018
-------------
ALTER TABLE cat_grate ADD COLUMN label varchar(255);


-------------
--28/06/2018
-------------
DROP TABLE IF EXISTS om_reh_cat_location;
CREATE TABLE om_reh_cat_location(
  id serial NOT NULL,
  from_value integer,
  to_value integer,
  location_id text,
  percent double precision,
  CONSTRAINT om_reh_cat_location_pkey PRIMARY KEY (id)
);


DROP TABLE om_reh_result_arc cascade;
CREATE TABLE om_reh_result_arc(
  id serial NOT NULL,
  result_id integer NOT NULL,
  arc_id character varying(16) NOT NULL,
  node_1 character varying(16),
  node_2 character varying(16),
  arc_type character varying(18) NOT NULL,
  arccat_id character varying(30) NOT NULL,
  sector_id integer NOT NULL,
  state smallint NOT NULL,
  expl_id integer,
  parameter_id character varying(30),
  work_id character varying(30),
  pcompost_id character varying(16),
  geom1 double precision,
  geom2 double precision,
  geom3 double precision,
  position_value double precision,
  value1 double precision,
  value2 double precision,
  measurement double precision,
  pcompost_price double precision,
  total_cost double precision,
  the_geom geometry(LineString,25831),
  CONSTRAINT om_reh_result_arc_pkey PRIMARY KEY (id),
  CONSTRAINT om_reh_result_arc_result_id_fkey FOREIGN KEY (result_id)
      REFERENCES vpat.om_result_cat (result_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE
);

DROP TABLE om_reh_parameter_x_works;
CREATE TABLE om_reh_parameter_x_works(
  id serial NOT NULL,
  parameter_id character varying(50),
  arcclass_id integer,
  location_id character varying(30),
  work_id character varying(30),
  CONSTRAINT om_reh_parameter_x_works_pkey PRIMARY KEY (id)
);
