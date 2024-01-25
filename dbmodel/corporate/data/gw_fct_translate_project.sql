/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

ALTER TABLE arc DISABLE TRIGGER gw_trg_arc_link_update;
ALTER TABLE arc DISABLE TRIGGER gw_trg_arc_node_values;
ALTER TABLE arc DISABLE TRIGGER gw_trg_arc_noderotation_update;
ALTER TABLE arc DISABLE TRIGGER gw_trg_topocontrol_arc;
ALTER TABLE arc DISABLE TRIGGER gw_trg_typevalue_fk;

ALTER TABLE node DISABLE TRIGGER gw_trg_node_arc_divide;
ALTER TABLE node DISABLE TRIGGER gw_trg_node_rotation_update;
ALTER TABLE node DISABLE TRIGGER gw_trg_node_statecontrol;
ALTER TABLE node DISABLE TRIGGER gw_trg_topocontrol_node;
ALTER TABLE node DISABLE TRIGGER gw_trg_typevalue_fk;


update arc set the_geom = st_translate(the_geom, 419229, 4576270);
update node set the_geom = st_translate(the_geom, 419229, 4576270); 

update exploitation set the_geom = st_translate(the_geom, 419229, 4576270); 
update sector set the_geom = st_translate(the_geom, 419229, 4576270); 
update dma set the_geom = st_translate(the_geom, 419229, 4576270); 


ALTER TABLE arc ENABLE TRIGGER gw_trg_arc_link_update;
ALTER TABLE arc ENABLE TRIGGER gw_trg_arc_node_values;
ALTER TABLE arc ENABLE TRIGGER gw_trg_arc_noderotation_update;
ALTER TABLE arc ENABLE TRIGGER gw_trg_topocontrol_arc;
ALTER TABLE arc ENABLE TRIGGER gw_trg_typevalue_fk;

ALTER TABLE node ENABLE TRIGGER gw_trg_node_arc_divide;
ALTER TABLE node ENABLE TRIGGER gw_trg_node_rotation_update;
ALTER TABLE node ENABLE TRIGGER gw_trg_node_statecontrol;
ALTER TABLE node ENABLE TRIGGER gw_trg_topocontrol_node;
ALTER TABLE node ENABLE TRIGGER gw_trg_typevalue_fk;