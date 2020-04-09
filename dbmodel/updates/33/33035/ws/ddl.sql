/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2020/04/04

CREATE TABLE anl_mincut_checkvalve(
  node_id character varying(16) NOT NULL,
  to_arc character varying(16) NOT NULL,
  CONSTRAINT anl_mincut_checkvalve_pkey PRIMARY KEY (node_id)
);