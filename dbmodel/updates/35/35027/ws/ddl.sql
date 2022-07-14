/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2022/07/11
¡
CREATE TABLE IF NOT EXISTS om_streetaxis
(
  id character varying(16) NOT NULL PRIMARY KEY,
  code character varying(16),
  type character varying(18),
  name character varying(100) NOT NULL,
  text text,
  the_geom geometry(MultiLineString,25831),
  expl_id integer NOT NULL,
  muni_id integer NOT NULL
);