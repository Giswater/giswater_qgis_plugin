/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2021/08/19
DROP TABLE IF EXISTS inp_gully;
CREATE TABLE inp_gully(
gully_id character varying(16) PRIMARY KEY,
status int2,
efficiency double precision);

CREATE OR REPLACE VIEW v_edit_inp_gully as
SELECT gully_id, code, top_elev, ymax, sandbox, matcat_id, gully_type, gratecat_id, units, groove, arc_id, s.sector_id, expl_id, state, state_type, the_geom, pjoint_id, pjoint_type, status, efficiency FROM selector_sector s, v_edit_gully g
JOIN inp_gully USING (gully_id)
WHERE g.sector_id  = s.sector_id AND cur_user = current_user;

INSERT INTO inp_gully
SELECT  gully_id FROM gully
ON CONFLICT (gully_id) DO NOTHING;

DROP TABLE IF EXISTS temp_gully;
CREATE TABLE temp_gully (
gully_id character varying(16),
gully_type character varying(30),
gratecat_id character varying(30),
sector_id integer,
state smallint,
state_type smallint,
annotation character varying(254),
the_geom geometry(LineString,25831),
efficiency double precision,
pjoint_id character varying(30),
x1 double precision,
y1 double precision,
z1 double precision,
x2 double precision,
y2 double precision,
z2 double precision,
connec_length double precision,
grate_length double precision,
grate_width double precision,
grate_area double precision,
effarea double precision,
nbarl double precision,
nbarw double precision,
nbard double precision,
aparam double precision,
bparam double precision);

CREATE OR REPLACE VIEW vi_gully AS 
SELECT * FROM temp_gully;
