/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2021/06/25

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_pattern", "column":"sector_id", "dataType":"integer", "isUtils":"False"}}$$);

--2021/07/05
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"anl_arc", "column":"losses", "dataType":"numeric(12,4)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"anl_node", "column":"losses", "dataType":"numeric(12,4)", "isUtils":"False"}}$$);

--2021/07/13
CREATE TABLE IF NOT EXISTS arc_add (
arc_id character varying(16) PRIMARY KEY,
rpt_qmax double precision,
rpt_qmin double precision,
rpt_vmax double precision,
rpt_vmin double precision);

CREATE TABLE IF NOT EXISTS node_add (
node_id character varying(16) PRIMARY KEY,
rpt_prmax numeric(12,4),
rpt_prmin numeric(12,4),
rpt_headmax numeric(12,4),
rpt_headmin numeric(12,4));

CREATE TABLE IF NOT EXISTS connec_add (
connec_id character varying(16) PRIMARY KEY,
rpt_prmax numeric(12,4),
rpt_prmin numeric(12,4),
rpt_headmax numeric(12,4),
rpt_headmin numeric(12,4));

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_junction", "column":"peak_factor", "dataType":"numeric(12,4)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_connec", "column":"peak_factor", "dataType":"numeric(12,4)", "isUtils":"False"}}$$);