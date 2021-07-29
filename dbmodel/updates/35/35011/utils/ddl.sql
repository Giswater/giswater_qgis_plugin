/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

CREATE TABLE temp_config_form_list AS SELECT * FROM config_form_list;

DROP TABLE config_form_list;

CREATE TABLE IF NOT EXISTS  config_form_list(
listname character varying(50) NOT NULL PRIMARY KEY,
alias text,
query_text text,
device smallint NOT NULL,
listtype character varying(30),
listclass character varying(30),
vdefault json,
filterparam json);

INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault)
SELECT listname, query_text, device, listtype, listclass, vdefault FROM temp_config_form_list;

DROP TABLE temp_config_form_list;