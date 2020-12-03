/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
SET search_path = "SCHEMA_NAME", public, pg_catalog;


-----------------------
-- create catalogs
-----------------------

CREATE TABLE cat_arc_shape
(
  id character varying(30) NOT NULL,
  epa character varying(30) NOT NULL,
  image character varying(50),
  descript text,
  active boolean,
  CONSTRAINT cat_arc_shape_pkey PRIMARY KEY (id)
);


-----------------------
-- create new fields
-----------------------

ALTER TABLE cat_arc ADD COLUMN  shape character varying(30);

ALTER TABLE connec ADD COLUMN featurecat_id character varying(50);
ALTER TABLE connec ADD COLUMN feature_id character varying(16);