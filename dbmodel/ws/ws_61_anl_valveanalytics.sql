/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


-- ----------------------------
-- VALVE ANALYTICS
-- ----------------------------


CREATE TABLE IF NOT EXISTS "SCHEMA_NAME"."anl_valveanaytics_connec" (
connec_id character varying(16) NOT NULL,
the_geom public.geometry (POINT, SRID_VALUE),
CONSTRAINT anl_valveanaytics_connec_pkey PRIMARY KEY (connec_id)
);

CREATE INDEX valveanalytics_connec_index ON "SCHEMA_NAME"."anl_valveanaytics_connec" USING GIST (the_geom)



