/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

ALTER TABLE inp_curve_id ADD column descript text;


DROP TABLE IF EXISTS inp_rules_importinp;
CREATE TABLE inp_rules_importinp
(id serial NOT NULL PRIMARY KEY,
text text);





