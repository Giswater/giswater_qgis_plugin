/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "utils", public, pg_catalog;


CREATE TABLE raster_dem(
  id serial NOT NULL PRIMARY KEY,
  rast raster,
  rastercat_id text);


CREATE TABLE cat_raster(
  id text NOT NULL PRIMARY KEY,
  code varchar(30),
  alias varchar(50),
  raster_type varchar(30), 
  descript text, 
  source text,
  provider varchar(30),
  year varchar(4), 
  tstamp timestamp without time zone DEFAULT now(),
  insert_user character varying(50) DEFAULT "current_user"());