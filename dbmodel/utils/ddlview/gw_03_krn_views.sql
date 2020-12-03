/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;

drop view if exists v_ui_workcat_polygon_all cascade;
CREATE OR REPLACE VIEW v_ui_workcat_polygon_all AS 
SELECT v_ui_workcat_polygon_aux.workcat_id,
	descript, 
	link, 
	workid_key1, 
	workid_key2, 
	builtdate,
    v_ui_workcat_polygon_aux.the_geom
   FROM v_ui_workcat_polygon_aux JOIN cat_work ON workcat_id=id;

   
drop view if exists v_ui_workcat_polygon cascade;
CREATE OR REPLACE VIEW v_ui_workcat_polygon AS 
 SELECT v_ui_workcat_polygon_aux.workcat_id,
    cat_work.descript,
    cat_work.link,
    cat_work.workid_key1,
    cat_work.workid_key2,
    cat_work.builtdate,
    v_ui_workcat_polygon_aux.the_geom
   FROM selector_workcat,
    v_ui_workcat_polygon_aux
     JOIN cat_work ON v_ui_workcat_polygon_aux.workcat_id::text = cat_work.id::text
  WHERE selector_workcat.workcat_id = v_ui_workcat_polygon_aux.workcat_id::text AND selector_workcat.cur_user = "current_user"()::text;

 
drop view if exists v_ui_arc_x_node cascade; 
CREATE OR REPLACE VIEW v_ui_arc_x_node AS
SELECT 
v_arc.arc_id,
node_1, 
st_x(a.the_geom) AS x1,
st_y(a.the_geom) AS y1,
node_2,
st_x(b.the_geom) AS x2,
st_y(b.the_geom) AS y2
FROM v_arc
LEFT JOIN node a ON a.node_id::text = v_arc.node_1::text
LEFT JOIN node b ON b.node_id::text = v_arc.node_2::text;

-- definiton updated on 3.1.110
drop view if exists v_ui_element_x_arc cascade; 
CREATE OR REPLACE VIEW v_ui_element_x_arc AS
SELECT
element_x_arc.id,
element_x_arc.arc_id,
element_x_arc.element_id,
element.elementcat_id,
cat_element.descript,
element.num_elements,
element.state,
element.state_type,
element.observ,
element.comment,
element.builtdate,
element.enddate,
element.link,
element.publish,
element.inventory
FROM element_x_arc
JOIN element ON element.element_id = element_x_arc.element_id
LEFT JOIN cat_element ON cat_element.id=element.elementcat_id
JOIN selector_state ON element.state=selector_state.state_id
AND selector_state.cur_user = "current_user"()::text;

-- definiton updated on 3.1.110
drop view if exists v_ui_element_x_node cascade; 
CREATE OR REPLACE VIEW v_ui_element_x_node AS
SELECT
element_x_node.id,
element_x_node.node_id,
element_x_node.element_id,
element.elementcat_id,
cat_element.descript,
element.num_elements,
element.state,
element.state_type,
element.observ,
element.comment,
element.builtdate,
element.enddate,
element.link,
element.publish,
element.inventory
FROM element_x_node
JOIN element ON element.element_id = element_x_node.element_id
LEFT JOIN cat_element ON cat_element.id=element.elementcat_id
JOIN selector_state ON element.state=selector_state.state_id
AND selector_state.cur_user = "current_user"()::text;

-- definiton updated on 3.1.110
drop view if exists v_ui_element_x_connec cascade; 
CREATE OR REPLACE VIEW v_ui_element_x_connec AS
SELECT
element_x_connec.id,
element_x_connec.connec_id,
element_x_connec.element_id,
element.elementcat_id,
cat_element.descript,
element.num_elements,
element.state,
element.state_type,
element.observ,
element.comment,
element.builtdate,
element.enddate,
element.link,
element.publish,
element.inventory
FROM element_x_connec
JOIN element ON element.element_id = element_x_connec.element_id
LEFT JOIN cat_element ON cat_element.id=element.elementcat_id
JOIN selector_state ON element.state=selector_state.state_id
AND selector_state.cur_user = "current_user"()::text;


drop view if exists v_ui_element cascade; 
CREATE VIEW "v_ui_element" AS 
SELECT 
element_id as id,
code,
elementcat_id,
serial_number,
num_elements ,
state,
state_type,
observ ,
comment ,
function_type,
category_type ,
fluid_type ,
location_type ,
workcat_id ,
workcat_id_end ,
buildercat_id ,
builtdate,
enddate ,
ownercat_id ,
rotation ,
link ,
verified,
the_geom ,
label_x ,
label_y ,
label_rotation ,
undelete ,
publish ,
inventory ,
expl_id ,
feature_type ,
tstamp
FROM element;


drop view if exists v_ui_scada_x_node cascade; 
CREATE OR REPLACE VIEW "v_ui_scada_x_node" AS 
 SELECT *
   FROM rtc_scada_node;

   
drop view if exists v_ui_scada_x_node_values cascade; 
CREATE OR REPLACE VIEW v_ui_scada_x_node_values AS 
 SELECT ext_rtc_scada_x_value.id,
    rtc_scada_node.scada_id,
    rtc_scada_node.node_id,
    ext_rtc_scada_x_value.value,
    ext_rtc_scada_x_value.status,
    ext_rtc_scada_x_value."timestamp"
   FROM rtc_scada_node
     JOIN ext_rtc_scada_x_value ON ext_rtc_scada_x_value.scada_id::text = rtc_scada_node.scada_id::text;


   