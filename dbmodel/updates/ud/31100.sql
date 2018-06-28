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
DROP TABLE om_reh_parameter_x_works;
CREATE TABLE om_reh_parameter_x_works
(
  id serial NOT NULL,
  parameter_id character varying(50),
  init_condition integer,
  end_condition integer,
  arcclass_id integer,
  loc_condition_id character varying(30),
  catwork_id character varying(30),
  CONSTRAINT om_reh_parameter_x_works_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);



