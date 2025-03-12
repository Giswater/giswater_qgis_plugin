/*
Copyright © 2023 by BGEO. All rights reserved.
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


DROP  TABLE temp_lot_unit;
CREATE TABLE temp_lot_unit (
arc_id varchar(16) PRIMARY KEY,
sourcenode varchar (16),
targetnode varchar (16),
nodetype varchar(30),
isprofilesurface boolean,
direction text ,
geom1 numeric (12,4),
area  numeric (12,4),
azimuth double precision,
sys_elev numeric (12,4),
f_factor double precision,
best_candidate boolean,
coupled_arc varchar(16),
unit_id integer,
macrounit_id integer);

--- cal posar en sql standard---
ALTER TABLE temp_table ADD COLUMN expl_id integer;
ALTER TABLE temp_table ADD COLUMN sector_id integer;
ALTER TABLE temp_table ADD COLUMN macroexpl_id integer;
ALTER TABLE temp_table ADD COLUMN macrosector_id integer;
--------------------------------

DROP VIEW if exists v_om_visit_lot_x_unit;
DROP VIEW if exists v_edit_om_visit_lot_x_unit;
CREATE VIEW v_edit_om_visit_lot_x_unit AS 
SELECT l.* FROM om_visit_lot_x_unit l, selector_lot s 
WHERE s.lot_id  = l.lot_id and cur_user = current_user;

CREATE VIEW v_edit_om_visit_lot_x_macrounit AS 
SELECT l.* FROM om_visit_lot_x_macrounit l, selector_lot s 
WHERE s.lot_id  = l.lot_id and cur_user = current_user;


 CREATE OR REPLACE VIEW v_anl_grafanalytics_mapzones AS 
 SELECT temp_anlgraf.arc_id,
    temp_anlgraf.node_1,
    temp_anlgraf.node_2,
    temp_anlgraf.flag,
    a2.flag AS flagi,
    a2.value,
    a2.trace
   FROM temp_anlgraf
     JOIN ( SELECT temp_anlgraf_1.arc_id,
            temp_anlgraf_1.node_1,
            temp_anlgraf_1.node_2,
            temp_anlgraf_1.water,
            temp_anlgraf_1.flag,
            temp_anlgraf_1.checkf,
            temp_anlgraf_1.value,
	    temp_anlgraf_1.trace
           FROM temp_anlgraf temp_anlgraf_1
          WHERE temp_anlgraf_1.water = 1) a2 ON temp_anlgraf.node_1::text = a2.node_2::text
  WHERE temp_anlgraf.flag < 2 AND temp_anlgraf.water = 0 AND a2.flag = 0;


ALTER TABLE om_visit_lot_x_unit ADD COLUMN length double precision;
ALTER TABLE om_visit_lot_x_unit ADD COLUMN way_type varchar (30);
ALTER TABLE om_visit_lot_x_unit ADD COLUMN way_in varchar (30);
ALTER TABLE om_visit_lot_x_unit ADD COLUMN way_out varchar (30);
ALTER TABLE om_visit_lot_x_unit ADD COLUMN macrounit_id integer;
ALTER TABLE om_visit_lot_x_unit ADD COLUMN trace_type varchar (30);
ALTER TABLE om_visit_lot_x_unit ADD COLUMN trace_id integer;
ALTER TABLE om_visit_lot_x_unit ADD COLUMN node_1 varchar (16);
ALTER TABLE om_visit_lot_x_unit ADD COLUMN node_2 varchar (16);

ALTER TABLE temp_anlgraf ADD COLUMN orderby integer;

ALTER TABLE om_visit_lot_x_arc ADD COLUMN length double precision;
ALTER TABLE om_visit_lot_x_arc ADD COLUMN macrounit_id integer;

ALTER TABLE om_visit_lot_x_gully ADD COLUMN length double precision;
ALTER TABLE om_visit_lot_x_gully ADD COLUMN macrounit_id integer;

ALTER TABLE om_visit_lot_x_node ADD COLUMN macrounit_id integer;

--DROP TABLE om_visit_lot_x_macrounit
CREATE TABLE om_visit_lot_x_macrounit (
macrounit_id integer PRIMARY KEY,
lot_id integer,
orderby integer,
length double precision,
the_geom GEOMETRY(MULTIPOLYGON, 25831));

DELETE FROM config_param_system where parameter = 'om_lotmanage_units';
INSERT INTO config_param_system VALUES ('om_lotmanage_units', '{"arcBuffer":2, "linkBuffer":1, "nodeBuffer":5, "unitBuffer":2, "areaFactor":1, "azimuthFactor":1, "elevFactor":0}',
'Specific configuration for plugin om_lotmanage, relate to buffer of the units and the weight for choose the best candidate on the intersections with isprofilesurface false', 
NULL, NULL, NULL, FALSE, NULL, 'ud') ON CONFLICT (parameter) DO NOTHING;


------------------------- NO CAL CREAR. M'ha servit per debugar
DROP VIEW v_temp_anlgraf
CREATE or replace VIEW v_temp_anlgraf AS
SELECT DISTINCT ON (arc_id) t.*, the_geom FROM temp_anlgraf t JOIN v_edit_om_visit_lot_x_unit u on arc_id::integer = unit_id
---------------------------------------


---------------------- COMPTE AMB AQUEST, HO HAN DE FER ELLS--
UPDATE cat_arc SET area = geom1*3.14159*geom1/4 WHERE shape = 'CIRCULAR';
UPDATE cat_arc SET area = geom1*geom2 WHERE shape NOT IN('CIRCULAR');
SELECT * from cat_arc_shape
-----------------------------------------