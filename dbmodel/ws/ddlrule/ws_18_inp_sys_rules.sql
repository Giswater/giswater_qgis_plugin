/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;

DROP RULE IF EXISTS insert_inp_cat_mat_roughness ON cat_mat_arc;
CREATE OR REPLACE RULE insert_inp_cat_mat_roughness AS ON INSERT TO SCHEMA_NAME.cat_mat_arc
DO ALSO INSERT INTO "SCHEMA_NAME"."inp_cat_mat_roughness" (matcat_id) values (new.id);
