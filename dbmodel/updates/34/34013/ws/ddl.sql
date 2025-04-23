/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2020/06/05
ALTER TABLE minsector RENAME presszonecat_id TO presszone_id;


ALTER TABLE inp_cat_mat_roughness RENAME TO cat_mat_roughness;