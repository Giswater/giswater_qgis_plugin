/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;


-- ----------------------------
-- System tables
-- ----------------------------
 

CREATE TABLE "om_visit_x_gully" (
"id" serial8 NOT NULL,
"visit_id" int8,
"gully_id" varchar (16),
CONSTRAINT om_visit_x_gully_pkey PRIMARY KEY (id)
);

