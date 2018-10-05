/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/



SET search_path = "SCHEMA_NAME", public, pg_catalog;


CREATE TABLE audit_log
(
  id serial NOT NULL,
  fprocesscat_id smallint,
  log_message text,
  tstamp timestamp without time zone DEFAULT now(),
  user_name text DEFAULT "current_user"(),
  CONSTRAINT audit_log_project_pkey PRIMARY KEY (id)
)
);


