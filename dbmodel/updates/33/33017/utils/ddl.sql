/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--25/11/2019

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"dimensions", "column":"comment", "dataType":"text"}}$$);

--26/11/2019
CREATE TABLE ext_district
(
  district_id integer NOT NULL,
  name text,
  muni_id integer NOT NULL,
  observ text,
  active boolean,
  the_geom geometry(MultiPolygon,SRID_VALUE),
  CONSTRAINT district_pkey PRIMARY KEY (district_id)
);