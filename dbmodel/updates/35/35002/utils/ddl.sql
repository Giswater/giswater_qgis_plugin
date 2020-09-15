/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


set search_path = 'SCHEMA_NAME';

DROP TABLE IF EXISTS config_form_groupbox;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"config_fprocess", "column":"fields", "newName":"querytext"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"audit_check_data", "column":"count", "dataType":"integer", "isUtils":"False"}}$$);


CREATE TABLE audit_fid_log
(id serial NOT NULL  PRIMARY KEY,
fid smallint,
count integer,
groupby text,
criticity integer,
tstamp timestamp without time zone DEFAULT now()
);