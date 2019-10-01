/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


DROP VIEW v_rpt_node;
DROP VIEW v_rpt_node_all;
DROP VIEW v_rpt_comp_node;
ALTER TABLE rpt_inp_node ALTER COLUMN node_type TYPE character varying(30);


DROP VIEW v_rpt_comp_arc ;
DROP VIEW v_rpt_arc_all ;
DROP VIEW v_rpt_arc ;
DROP VIEW vi_pipes;
ALTER TABLE rpt_inp_arc ALTER COLUMN arc_type TYPE character varying(30);