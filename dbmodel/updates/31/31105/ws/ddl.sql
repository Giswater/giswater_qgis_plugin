/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/



CREATE TABLE anl_mincut_inlet_x_arc(
  node_id character varying(16),
  arc_id character varying(16),
  CONSTRAINT anl_mincut_inlet_x_arc_pkey PRIMARY KEY (node_id, arc_id));
  
ALTER TABLE anl_mincut_inlet_x_arc ADD CONSTRAINT anl_mincut_inlet_x_arc_node_fkey FOREIGN KEY (node_id)
REFERENCES node (node_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE anl_mincut_inlet_x_arc ADD CONSTRAINT anl_mincut_inlet_x_arc_arc_fkey FOREIGN KEY (arc_id)
REFERENCES arc (arc_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;