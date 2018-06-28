/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

  
SET search_path = "SCHEMA_NAME", public, pg_catalog;


  
   
-------------
--01/06/2018
-------------
ALTER TABLE cat_grate ADD COLUMN label varchar(255);


-------------
--28/06/2018
-------------
-- DROP TABLE vpat.om_reh_value_loc_condition;
CREATE TABLE om_reh_cat_location
(
  id serial PRIMARY KEY,
  idval text,
  from_value integer,
  to_value integer,
  descript text
)



