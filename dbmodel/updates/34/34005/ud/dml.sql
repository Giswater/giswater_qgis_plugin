/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2020/03/18
UPDATE audit_cat_table SET isdeprecated = true 
WHERE id IN ('v_arc_dattrib','v_node_dattrib','vi_parent_node','v_connec_dattrib','v_gully_dattrib', 
'vp_epa_node','vp_epa_arc', 'v_node_x_arc', 'v_arc_x_node'
'v_plan_aux_arc_ml','v_plan_aux_arc_cost','v_plan_aux_arc_connec','v_plan_aux_arc_gully','v_plan_aux_arc_pavement');

INSERT INTO audit_cat_table(id, context, descript, sys_role_id, sys_criticity, qgis_role_id, isdeprecated) 
VALUES ('v_connec', 'GIS feature', 'Auxiliar view for connecs', 'role_basic', 0, 'role_basic', false);

INSERT INTO audit_cat_table(id, context, descript, sys_role_id, sys_criticity, qgis_role_id, isdeprecated) 
VALUES ('v_gully', 'GIS feature', 'Auxiliar view for gully', 'role_basic', 0, 'role_basic', false);

update audit_cat_table set isdeprecated = true where id like '%v_inp%';
update audit_cat_table set id = 'vi_subcatch2node' WHERE id = 'v_inp_subcatch2node';
update audit_cat_table set id = 'vi_subcatchcentroid' WHERE id = 'v_inp_subcatchcentroid';


--2020/04/14
UPDATE config_form_fields SET layout_order = 1 WHERE column_id = 'arc_id' and formname in ('v_edit_inp_conduit','v_edit_inp_orifice','v_edit_inp_outlet','v_edit_inp_pump','v_edit_inp_virtual','v_edit_inp_weir');
UPDATE config_form_fields SET layout_order = 2 WHERE column_id = 'node_1' and formname in ('v_edit_inp_conduit','v_edit_inp_orifice','v_edit_inp_outlet','v_edit_inp_pump','v_edit_inp_virtual','v_edit_inp_weir');
UPDATE config_form_fields SET layout_order = 3 WHERE column_id = 'node_2' and formname in ('v_edit_inp_conduit','v_edit_inp_orifice','v_edit_inp_outlet','v_edit_inp_pump','v_edit_inp_virtual','v_edit_inp_weir');
UPDATE config_form_fields SET layout_order = 4 WHERE column_id = 'y1' and formname in ('v_edit_inp_conduit','v_edit_inp_orifice','v_edit_inp_outlet','v_edit_inp_pump','v_edit_inp_weir');
UPDATE config_form_fields SET layout_order = 5 WHERE column_id = 'custom_y1' and formname in ('v_edit_inp_conduit','v_edit_inp_orifice','v_edit_inp_outlet','v_edit_inp_pump','v_edit_inp_weir');
UPDATE config_form_fields SET layout_order = 6 WHERE column_id = 'elev1' and formname in ('v_edit_inp_conduit','v_edit_inp_orifice','v_edit_inp_outlet','v_edit_inp_pump','v_edit_inp_weir');
UPDATE config_form_fields SET layout_order = 7 WHERE column_id = 'custom_elev1' and formname in ('v_edit_inp_conduit','v_edit_inp_orifice','v_edit_inp_outlet','v_edit_inp_pump','v_edit_inp_weir');
UPDATE config_form_fields SET layout_order = 8 WHERE column_id = 'sys_elev1' and formname in ('v_edit_inp_conduit','v_edit_inp_orifice','v_edit_inp_outlet','v_edit_inp_pump','v_edit_inp_weir');
UPDATE config_form_fields SET layout_order = 9 WHERE column_id = 'y2' and formname in ('v_edit_inp_conduit','v_edit_inp_orifice','v_edit_inp_outlet','v_edit_inp_pump','v_edit_inp_weir');
UPDATE config_form_fields SET layout_order = 10 WHERE column_id = 'custom_y2' and formname in ('v_edit_inp_conduit','v_edit_inp_orifice','v_edit_inp_outlet','v_edit_inp_pump','v_edit_inp_weir');
UPDATE config_form_fields SET layout_order = 11 WHERE column_id = 'elev2' and formname in ('v_edit_inp_conduit','v_edit_inp_orifice','v_edit_inp_outlet','v_edit_inp_pump','v_edit_inp_weir');
UPDATE config_form_fields SET layout_order = 12 WHERE column_id = 'custom_elev2' and formname in ('v_edit_inp_conduit','v_edit_inp_orifice','v_edit_inp_outlet','v_edit_inp_pump','v_edit_inp_weir');
UPDATE config_form_fields SET layout_order = 13 WHERE column_id = 'sys_elev2' and formname in ('v_edit_inp_conduit','v_edit_inp_orifice','v_edit_inp_outlet','v_edit_inp_pump','v_edit_inp_weir');
UPDATE config_form_fields SET layout_order = 14 WHERE column_id = 'arccat_id' and formname in ('v_edit_inp_conduit','v_edit_inp_orifice','v_edit_inp_outlet','v_edit_inp_pump','v_edit_inp_weir');

UPDATE config_form_fields SET layout_order = 15 WHERE column_id = 'cat_matcat_id' and formname in ('v_edit_inp_conduit');
UPDATE config_form_fields SET layout_order = 16 WHERE column_id = 'cat_shape' and formname in ('v_edit_inp_conduit');
UPDATE config_form_fields SET layout_order = 17 WHERE column_id = 'cat_geom1' and formname in ('v_edit_inp_conduit');
UPDATE config_form_fields SET layout_order = 18 WHERE column_id = 'gis_length' and formname in ('v_edit_inp_conduit');
UPDATE config_form_fields SET layout_order = 19 WHERE column_id = 'sector_id' and formname in ('v_edit_inp_conduit');
UPDATE config_form_fields SET layout_order = 20 WHERE column_id = 'macrosector_id' and formname in ('v_edit_inp_conduit');
UPDATE config_form_fields SET layout_order = 21 WHERE column_id = 'state' and formname in ('v_edit_inp_conduit');
UPDATE config_form_fields SET layout_order = 22 WHERE column_id = 'state_type' and formname in ('v_edit_inp_conduit');
UPDATE config_form_fields SET layout_order = 23 WHERE column_id = 'annotation' and formname in ('v_edit_inp_conduit');
UPDATE config_form_fields SET layout_order = 24 WHERE column_id = 'inverted_slope' and formname in ('v_edit_inp_conduit');
UPDATE config_form_fields SET layout_order = 25 WHERE column_id = 'custom_length' and formname in ('v_edit_inp_conduit');
UPDATE config_form_fields SET layout_order = 26 WHERE column_id = 'expl_id' and formname in ('v_edit_inp_conduit');
UPDATE config_form_fields SET layout_order = 27 WHERE column_id = 'barrels' and formname in ('v_edit_inp_conduit');
UPDATE config_form_fields SET layout_order = 28 WHERE column_id = 'culvert' and formname in ('v_edit_inp_conduit');
UPDATE config_form_fields SET layout_order = 29 WHERE column_id = 'kentry' and formname in ('v_edit_inp_conduit');
UPDATE config_form_fields SET layout_order = 30 WHERE column_id = 'kexit' and formname in ('v_edit_inp_conduit');
UPDATE config_form_fields SET layout_order = 31 WHERE column_id = 'kavg' and formname in ('v_edit_inp_conduit');
UPDATE config_form_fields SET layout_order = 32 WHERE column_id = 'flap' and formname in ('v_edit_inp_conduit');
UPDATE config_form_fields SET layout_order = 33 WHERE column_id = 'q0' and formname in ('v_edit_inp_conduit');
UPDATE config_form_fields SET layout_order = 34 WHERE column_id = 'qmax' and formname in ('v_edit_inp_conduit');
UPDATE config_form_fields SET layout_order = 35 WHERE column_id = 'seepage' and formname in ('v_edit_inp_conduit');
UPDATE config_form_fields SET layout_order = 36 WHERE column_id = 'custom_n' and formname in ('v_edit_inp_conduit');


UPDATE config_form_fields SET layout_order = 15 WHERE column_id = 'gis_length' and formname in ('v_edit_inp_orifice','v_edit_inp_outlet','v_edit_inp_pump','v_edit_inp_weir');
UPDATE config_form_fields SET layout_order = 16 WHERE column_id = 'sector_id' and formname in ('v_edit_inp_orifice','v_edit_inp_outlet','v_edit_inp_pump','v_edit_inp_weir');
UPDATE config_form_fields SET layout_order = 17 WHERE column_id = 'macrosector_id' and formname in ('v_edit_inp_orifice','v_edit_inp_outlet','v_edit_inp_pump','v_edit_inp_weir');
UPDATE config_form_fields SET layout_order = 18 WHERE column_id = 'state' and formname in ('v_edit_inp_orifice','v_edit_inp_outlet','v_edit_inp_pump','v_edit_inp_weir');
UPDATE config_form_fields SET layout_order = 19 WHERE column_id = 'state_type' and formname in ('v_edit_inp_orifice','v_edit_inp_outlet','v_edit_inp_pump','v_edit_inp_weir');
UPDATE config_form_fields SET layout_order = 20 WHERE column_id = 'annotation' and formname in ('v_edit_inp_orifice','v_edit_inp_outlet','v_edit_inp_pump','v_edit_inp_weir');
UPDATE config_form_fields SET layout_order = 21 WHERE column_id = 'inverted_slope' and formname in ('v_edit_inp_orifice','v_edit_inp_outlet','v_edit_inp_pump','v_edit_inp_weir');
UPDATE config_form_fields SET layout_order = 22 WHERE column_id = 'custom_length' and formname in ('v_edit_inp_orifice','v_edit_inp_outlet','v_edit_inp_pump','v_edit_inp_weir');
UPDATE config_form_fields SET layout_order = 23 WHERE column_id = 'expl_id' and formname in ('v_edit_inp_orifice','v_edit_inp_outlet','v_edit_inp_pump','v_edit_inp_weir');

UPDATE config_form_fields SET layout_order = 24 WHERE column_id = 'ori_type' and formname in ('v_edit_inp_orifice');
UPDATE config_form_fields SET layout_order = 25 WHERE column_id = 'offset' and formname in ('v_edit_inp_orifice');
UPDATE config_form_fields SET layout_order = 26 WHERE column_id = 'cd' and formname in ('v_edit_inp_orifice');
UPDATE config_form_fields SET layout_order = 27 WHERE column_id = 'orate' and formname in ('v_edit_inp_orifice');
UPDATE config_form_fields SET layout_order = 28 WHERE column_id = 'flap' and formname in ('v_edit_inp_orifice');
UPDATE config_form_fields SET layout_order = 29 WHERE column_id = 'shape' and formname in ('v_edit_inp_orifice');
UPDATE config_form_fields SET layout_order = 30 WHERE column_id = 'geom1' and formname in ('v_edit_inp_orifice');
UPDATE config_form_fields SET layout_order = 31 WHERE column_id = 'geom2' and formname in ('v_edit_inp_orifice');
UPDATE config_form_fields SET layout_order = 32 WHERE column_id = 'geom3' and formname in ('v_edit_inp_orifice');
UPDATE config_form_fields SET layout_order = 33 WHERE column_id = 'geom4' and formname in ('v_edit_inp_orifice');

UPDATE config_form_fields SET layout_order = 24 WHERE column_id = 'outlet_type' and formname in ('v_edit_inp_outlet');
UPDATE config_form_fields SET layout_order = 25 WHERE column_id = 'offset' and formname in ('v_edit_inp_outlet');
UPDATE config_form_fields SET layout_order = 26 WHERE column_id = 'cd1' and formname in ('v_edit_inp_outlet');
UPDATE config_form_fields SET layout_order = 27 WHERE column_id = 'cd2' and formname in ('v_edit_inp_outlet');
UPDATE config_form_fields SET layout_order = 28 WHERE column_id = 'flap' and formname in ('v_edit_inp_outlet');

UPDATE config_form_fields SET layout_order = 24 WHERE column_id = 'curve_id' and formname in ('v_edit_inp_pump');
UPDATE config_form_fields SET layout_order = 25 WHERE column_id = 'status' and formname in ('v_edit_inp_pump');
UPDATE config_form_fields SET layout_order = 26 WHERE column_id = 'startup' and formname in ('v_edit_inp_pump');
UPDATE config_form_fields SET layout_order = 27 WHERE column_id = 'shutoff' and formname in ('v_edit_inp_pump');

UPDATE config_form_fields SET layout_order = 24 WHERE column_id = 'weir_type' and formname in ('v_edit_inp_weir');
UPDATE config_form_fields SET layout_order = 25 WHERE column_id = 'offset' and formname in ('v_edit_inp_weir');
UPDATE config_form_fields SET layout_order = 26 WHERE column_id = 'cd' and formname in ('v_edit_inp_weir');
UPDATE config_form_fields SET layout_order = 27 WHERE column_id = 'ec' and formname in ('v_edit_inp_weir');
UPDATE config_form_fields SET layout_order = 28 WHERE column_id = 'cd2' and formname in ('v_edit_inp_weir');
UPDATE config_form_fields SET layout_order = 29 WHERE column_id = 'flap' and formname in ('v_edit_inp_weir');
UPDATE config_form_fields SET layout_order = 30 WHERE column_id = 'geom1' and formname in ('v_edit_inp_weir');
UPDATE config_form_fields SET layout_order = 31 WHERE column_id = 'geom2' and formname in ('v_edit_inp_weir');
UPDATE config_form_fields SET layout_order = 32 WHERE column_id = 'geom3' and formname in ('v_edit_inp_weir');
UPDATE config_form_fields SET layout_order = 33 WHERE column_id = 'geom4' and formname in ('v_edit_inp_weir');
UPDATE config_form_fields SET layout_order = 34 WHERE column_id = 'surcharge' and formname in ('v_edit_inp_weir');

UPDATE config_form_fields SET layout_order = 4 WHERE column_id = 'gis_length' and formname in ('v_edit_inp_virtual');
UPDATE config_form_fields SET layout_order = 5 WHERE column_id = 'sector_id' and formname in ('v_edit_inp_virtual');
UPDATE config_form_fields SET layout_order = 6 WHERE column_id = 'macrosector_id' and formname in ('v_edit_inp_virtual');
UPDATE config_form_fields SET layout_order = 7 WHERE column_id = 'state' and formname in ('v_edit_inp_virtual');
UPDATE config_form_fields SET layout_order = 8 WHERE column_id = 'state_type' and formname in ('v_edit_inp_virtual');
UPDATE config_form_fields SET layout_order = 9 WHERE column_id = 'expl_id' and formname in ('v_edit_inp_virtual');
UPDATE config_form_fields SET layout_order = 10 WHERE column_id = 'fusion_node' and formname in ('v_edit_inp_virtual');
UPDATE config_form_fields SET layout_order = 11 WHERE column_id = 'add_length' and formname in ('v_edit_inp_virtual');

UPDATE config_form_fields SET layout_order = 1 WHERE column_id = 'node_id' and formname in ('v_edit_inp_divider','v_edit_inp_junction','v_edit_inp_outfall','v_edit_inp_storage');
UPDATE config_form_fields SET layout_order = 2 WHERE column_id = 'top_elev' and formname in ('v_edit_inp_divider','v_edit_inp_junction','v_edit_inp_outfall','v_edit_inp_storage');
UPDATE config_form_fields SET layout_order = 3 WHERE column_id = 'custom_top_elev' and formname in ('v_edit_inp_divider','v_edit_inp_junction','v_edit_inp_outfall','v_edit_inp_storage');
UPDATE config_form_fields SET layout_order = 4 WHERE column_id = 'ymax' and formname in ('v_edit_inp_divider','v_edit_inp_junction','v_edit_inp_outfall','v_edit_inp_storage');
UPDATE config_form_fields SET layout_order = 5 WHERE column_id = 'custom_ymax' and formname in ('v_edit_inp_divider','v_edit_inp_junction','v_edit_inp_outfall','v_edit_inp_storage');
UPDATE config_form_fields SET layout_order = 6 WHERE column_id = 'elev' and formname in ('v_edit_inp_divider','v_edit_inp_junction','v_edit_inp_outfall','v_edit_inp_storage');
UPDATE config_form_fields SET layout_order = 7 WHERE column_id = 'custom_elev' and formname in ('v_edit_inp_divider','v_edit_inp_junction','v_edit_inp_outfall','v_edit_inp_storage');
UPDATE config_form_fields SET layout_order = 8 WHERE column_id = 'sys_elev' and formname in ('v_edit_inp_divider','v_edit_inp_junction','v_edit_inp_outfall','v_edit_inp_storage');
UPDATE config_form_fields SET layout_order = 9 WHERE column_id = 'nodecat_id' and formname in ('v_edit_inp_divider','v_edit_inp_junction','v_edit_inp_outfall','v_edit_inp_storage');
UPDATE config_form_fields SET layout_order = 10 WHERE column_id = 'sector_id' and formname in ('v_edit_inp_divider','v_edit_inp_junction','v_edit_inp_outfall','v_edit_inp_storage');
UPDATE config_form_fields SET layout_order = 11 WHERE column_id = 'macrosector_id' and formname in ('v_edit_inp_divider','v_edit_inp_junction','v_edit_inp_outfall','v_edit_inp_storage');
UPDATE config_form_fields SET layout_order = 12 WHERE column_id = 'state' and formname in ('v_edit_inp_divider','v_edit_inp_junction','v_edit_inp_outfall','v_edit_inp_storage');
UPDATE config_form_fields SET layout_order = 13 WHERE column_id = 'state_type' and formname in ('v_edit_inp_divider','v_edit_inp_junction','v_edit_inp_outfall','v_edit_inp_storage');
UPDATE config_form_fields SET layout_order = 14 WHERE column_id = 'annotation' and formname in ('v_edit_inp_divider','v_edit_inp_junction','v_edit_inp_outfall','v_edit_inp_storage');
UPDATE config_form_fields SET layout_order = 15 WHERE column_id = 'expl_id' and formname in ('v_edit_inp_divider','v_edit_inp_junction','v_edit_inp_outfall','v_edit_inp_storage');

UPDATE config_form_fields SET layout_order = 16 WHERE column_id = 'storage_type' and formname in ('v_edit_inp_storage');
UPDATE config_form_fields SET layout_order = 17 WHERE column_id = 'curve_id' and formname in ('v_edit_inp_storage');
UPDATE config_form_fields SET layout_order = 18 WHERE column_id = 'a1' and formname in ('v_edit_inp_storage');
UPDATE config_form_fields SET layout_order = 19 WHERE column_id = 'a2' and formname in ('v_edit_inp_storage');
UPDATE config_form_fields SET layout_order = 20 WHERE column_id = 'a0' and formname in ('v_edit_inp_storage');
UPDATE config_form_fields SET layout_order = 21 WHERE column_id = 'fevap' and formname in ('v_edit_inp_storage');
UPDATE config_form_fields SET layout_order = 22 WHERE column_id = 'sh' and formname in ('v_edit_inp_storage');
UPDATE config_form_fields SET layout_order = 23 WHERE column_id = 'hc' and formname in ('v_edit_inp_storage');
UPDATE config_form_fields SET layout_order = 24 WHERE column_id = 'imd' and formname in ('v_edit_inp_storage');
UPDATE config_form_fields SET layout_order = 25 WHERE column_id = 'y0' and formname in ('v_edit_inp_storage');
UPDATE config_form_fields SET layout_order = 26 WHERE column_id = 'ysur' and formname in ('v_edit_inp_storage');
UPDATE config_form_fields SET layout_order = 27 WHERE column_id = 'apond' and formname in ('v_edit_inp_storage');

UPDATE config_form_fields SET layout_order = 16 WHERE column_id = 'divider_type' and formname in ('v_edit_inp_divider');
UPDATE config_form_fields SET layout_order = 17 WHERE column_id = 'arc_id' and formname in ('v_edit_inp_divider');
UPDATE config_form_fields SET layout_order = 18 WHERE column_id = 'curve_id' and formname in ('v_edit_inp_divider');
UPDATE config_form_fields SET layout_order = 19 WHERE column_id = 'qmin' and formname in ('v_edit_inp_divider');
UPDATE config_form_fields SET layout_order = 20 WHERE column_id = 'ht' and formname in ('v_edit_inp_divider');
UPDATE config_form_fields SET layout_order = 21 WHERE column_id = 'cd' and formname in ('v_edit_inp_divider');
UPDATE config_form_fields SET layout_order = 22 WHERE column_id = 'y0' and formname in ('v_edit_inp_divider');
UPDATE config_form_fields SET layout_order = 23 WHERE column_id = 'ysur' and formname in ('v_edit_inp_divider');
UPDATE config_form_fields SET layout_order = 24 WHERE column_id = 'apond' and formname in ('v_edit_inp_divider');

delete from config_form_fields where formname ilike 'v_edit_inp_junction'and column_id='dma_id';
UPDATE config_form_fields SET layout_order = 16 WHERE column_id = 'y0' and formname in ('v_edit_inp_junction');
UPDATE config_form_fields SET layout_order = 17 WHERE column_id = 'ysur' and formname in ('v_edit_inp_junction');
UPDATE config_form_fields SET layout_order = 18 WHERE column_id = 'apond' and formname in ('v_edit_inp_junction');
UPDATE config_form_fields SET layout_order = 19 WHERE column_id = 'outfallparam' and formname in ('v_edit_inp_junction');

UPDATE config_form_fields SET layout_order = 16 WHERE column_id = 'outfall_type' and formname in ('v_edit_inp_outfall');
UPDATE config_form_fields SET layout_order = 17 WHERE column_id = 'stage' and formname in ('v_edit_inp_outfall');
UPDATE config_form_fields SET layout_order = 18 WHERE column_id = 'curve_id' and formname in ('v_edit_inp_outfall');
UPDATE config_form_fields SET layout_order = 19 WHERE column_id = 'timser_id' and formname in ('v_edit_inp_outfall');
UPDATE config_form_fields SET layout_order = 20 WHERE column_id = 'gate' and formname in ('v_edit_inp_outfall');

delete from config_form_fields where formname ilike 'v_edit_inp_connec'and column_id='dma_id';

UPDATE config_form_fields SET column_id='matcat_id' WHERE column_id='cat_matcat_id';
UPDATE config_form_fields SET label='matcat_id' WHERE label='cat_matcat_id';