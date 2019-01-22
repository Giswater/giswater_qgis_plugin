/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE TABLE SCHEMA_NAME.config_api_message
(
  id integer NOT NULL,
  loglevel integer,
  message text,
  hintmessage text,
  mtype text,
  CONSTRAINT config_api_message_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);