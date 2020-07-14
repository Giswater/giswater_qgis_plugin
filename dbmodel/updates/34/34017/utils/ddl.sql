/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 2020/07/08


CREATE TABLE SCHEMA_NAME.config_function
(
  id integer NOT NULL,
  function_name text NOT NULL,
  returnmanager json,
  layermanager json,
  actions json,
  CONSTRAINT config_function_pkey PRIMARY KEY (id)
);
