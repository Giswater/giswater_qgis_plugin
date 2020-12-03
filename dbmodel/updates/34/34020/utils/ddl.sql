/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


set search_path = 'SCHEMA_NAME';

ALTER TABLE inp_typevalue ENABLE TRIGGER gw_trg_typevalue_config_fk;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"cat_element", "column":"geom1", "dataType":"numeric(12,3)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"cat_element", "column":"geom2", "dataType":"numeric(12,3)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"cat_element", "column":"isdoublegeom", "dataType":"boolean", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"element", "column":"pol_id", "dataType":"varchar(16)", "isUtils":"False"}}$$);
