/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

CREATE TABLE SCHEMA_NAME.sys_combo_cat
(
  id serial NOT NULL,
  idval text,
  CONSTRAINT sys_combo_cat_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);



CREATE TABLE SCHEMA_NAME.sys_combo_values
(
  sys_combo_cat_id integer NOT NULL,
  id integer NOT NULL,
  idval text,
  descript text,
  CONSTRAINT sys_combo_pkey PRIMARY KEY (sys_combo_cat_id, id)
)
WITH (
  OIDS=FALSE
);
