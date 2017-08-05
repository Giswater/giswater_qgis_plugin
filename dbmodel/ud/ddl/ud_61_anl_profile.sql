/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;


 -- PROFILE TOOLS

CREATE TABLE anl_arc_profile_value
(
  id serial NOT NULL PRIMARY KEY,
  profile_id character varying(30) NOT NULL,
  arc_id varchar NOT NULL,
  start_point varchar,
  end_point varchar
);


