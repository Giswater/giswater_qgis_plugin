/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/



CREATE TABLE utils.audit_log
(
  id serial NOT NULL,
  fprocesscat_id smallint,
  log_message text,
  tstamp timestamp without time zone DEFAULT now(),
  user_name text DEFAULT "current_user"(),
  CONSTRAINT audit_log_project_pkey PRIMARY KEY (id)
);



CREATE TABLE utils.config_param_system
(
  id serial NOT NULL,
  parameter character varying(50) NOT NULL,
  value text,
  data_type character varying(20),
  context character varying(50),
  descript text,
  CONSTRAINT config_param_system_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
