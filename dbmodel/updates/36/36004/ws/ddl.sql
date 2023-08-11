/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME ,public;

CREATE TABLE inp_dscenario_mapzone(
dscenario_id integer,
mapzone_type character varying(30),
mapzone_id character varying(30),
pattern_id character varying(16),
arcs integer[],
nodes integer[],
connecs integer[],
the_geom geometry(MultiPolygon,SRID_VALUE),
CONSTRAINT inp_dscenario_zone_pkey PRIMARY KEY (dscenario_id, mapzone_type, mapzone_id)
);
