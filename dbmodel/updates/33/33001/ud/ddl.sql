/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

DROP VIEW IF EXISTS v_rpt_comp_storagevol_sum;
DROP VIEW IF EXISTS v_rpt_comp_outfallload_sum;
DROP VIEW IF EXISTS v_rpt_comp_outfallflow_sum;
DROP VIEW IF EXISTS v_rpt_comp_nodesurcharge_sum;
DROP VIEW IF EXISTS v_rpt_comp_nodeinflow_sum;
DROP VIEW IF EXISTS v_rpt_comp_nodeflooding_sum;
DROP VIEW IF EXISTS v_rpt_comp_nodedepth_sum;
DROP VIEW IF EXISTS v_rpt_storagevol_sum;
DROP VIEW IF EXISTS v_rpt_outfallload_sum;
DROP VIEW IF EXISTS v_rpt_outfallflow_sum;
DROP VIEW IF EXISTS v_rpt_nodesurcharge_sum;
DROP VIEW IF EXISTS v_rpt_nodeinflow_sum;
DROP VIEW IF EXISTS v_rpt_nodeflooding_sum;
DROP VIEW IF EXISTS v_rpt_nodedepth_sum;
ALTER TABLE rpt_inp_node ALTER COLUMN node_type TYPE character varying(30);

DROP VIEW IF EXISTS v_rpt_comp_pumping_sum;
DROP VIEW IF EXISTS v_rpt_comp_arcflow_sum;
DROP VIEW IF EXISTS v_rpt_comp_arcpolload_sum;
DROP VIEW IF EXISTS v_rpt_comp_condsurcharge_sum;
DROP VIEW IF EXISTS v_rpt_comp_flowclass_sum;
DROP VIEW IF EXISTS v_rpt_pumping_sum;
DROP VIEW IF EXISTS v_rpt_arcflow_sum;
DROP VIEW IF EXISTS v_rpt_arcpolload_sum;
DROP VIEW IF EXISTS v_rpt_condsurcharge_sum;
DROP VIEW IF EXISTS v_rpt_flowclass_sum;
ALTER TABLE rpt_inp_arc ALTER COLUMN arc_type TYPE character varying(30);
