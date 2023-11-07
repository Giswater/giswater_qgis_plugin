/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 7/11/2023
CREATE TABLE rpt_arc_stats (
  arc_id character varying(16),
  result_id character varying(30) NOT NULL,
  arc_type varchar (30),
  sector_id integer,
  arccat_id varchar (30),
  flow_max numeric,
  flow_min numeric,
  flow_avg numeric(12,2),
  vel_max numeric,
  vel_min numeric,
  vel_avg numeric(12,2),
  headloss_max numeric,
  headloss_min numeric,
  setting_max numeric,
  setting_min numeric,
  reaction_max numeric,
  reaction_min numeric,
  ffactor_max numeric,
  ffactor_min numeric,
  the_geom geometry(LINESTRING, 25831),
  CONSTRAINT rpt_arc_stats_pkey PRIMARY KEY (arc_id, result_id),
  CONSTRAINT rpt_arc_stats_result_id_fkey FOREIGN KEY (result_id)
      REFERENCES rpt_cat_result (result_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE);

CREATE TABLE rpt_node_stats (
  node_id character varying(16),
  result_id character varying(30) NOT NULL,
  node_type varchar (30),
  sector_id integer,
  nodecat_id varchar (30),
  elevation numeric,
  demand_max numeric,
  demand_min numeric,
  demand_avg numeric(12,2),
  head_max numeric,
  head_min numeric,
  head_avg numeric(12,2),
  press_max numeric,
  press_min numeric,
  press_avg numeric(12,2),
  quality_max numeric,
  quality_min numeric,
  quality_avg numeric(12,2),
  the_geom geometry(POINT, 25831),
  CONSTRAINT rpt_node_stats_pkey PRIMARY KEY (node_id, result_id),
  CONSTRAINT rpt_node_stats_result_id_fkey FOREIGN KEY (result_id)
      REFERENCES rpt_cat_result (result_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE);


CREATE INDEX rpt_arc_stats_geom ON rpt_arc_stats USING gist(the_geom);
CREATE INDEX rpt_arc_stats_flow_max ON rpt_arc_stats USING btree(flow_max);
CREATE INDEX rpt_arc_stats_flow_avg ON rpt_arc_stats USING btree(flow_avg);
CREATE INDEX rpt_arc_stats_flow_min ON rpt_arc_stats USING btree(flow_min);
CREATE INDEX rpt_arc_stats_vel_max ON rpt_arc_stats USING btree(vel_max);
CREATE INDEX rpt_arc_stats_vel_avg ON rpt_arc_stats USING btree(vel_avg);
CREATE INDEX rpt_arc_stats_vel_min ON rpt_arc_stats USING btree(vel_min);  


CREATE INDEX rpt_node_stats_geom ON rpt_node_stats USING gist(the_geom);
CREATE INDEX rpt_node_stats_head_max ON rpt_node_stats USING btree(head_max);
CREATE INDEX rpt_node_stats_head_avg ON rpt_node_stats USING btree(head_avg);
CREATE INDEX rpt_node_stats_head_min ON rpt_node_stats USING btree(head_min);
CREATE INDEX rpt_node_stats_press_max ON rpt_node_stats USING btree(press_max);
CREATE INDEX rpt_node_stats_press_avg ON rpt_node_stats USING btree(press_avg);
CREATE INDEX rpt_node_stats_press_min ON rpt_node_stats USING btree(press_min);  
CREATE INDEX rpt_node_stats_quality_max ON rpt_node_stats USING btree(quality_max);
CREATE INDEX rpt_node_stats_quality_avg ON rpt_node_stats USING btree(quality_avg);
CREATE INDEX rpt_node_stats_quality_min ON rpt_node_stats USING btree(quality_min);
CREATE INDEX rpt_node_stats_demand_max ON rpt_node_stats USING btree(demand_max);
CREATE INDEX rpt_node_stats_demand_avg ON rpt_node_stats USING btree(demand_avg);
CREATE INDEX rpt_node_stats_demand_min ON rpt_node_stats USING btree(demand_min);  







