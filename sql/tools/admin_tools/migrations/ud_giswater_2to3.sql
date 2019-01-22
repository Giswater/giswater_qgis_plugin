/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/



/*
Use this file to migrate data from a version 2 schema to version 3 schema of GISWATER. Replace SCHEMA_NAME_V3 for the name of your database schema in version 3  
and the SCHEMA_NAME_V2 for the name of your database schema version 2. It's important to follow the jerarchy of the rows to make sure that all the rules and foreign keys are accurately replaced.
*/





	-- SYSTEM
--------------------------------------
-- INSERT INTO SCHEMA_NAME_V3.sys_feature_type		(already filled)
-- INSERT INTO SCHEMA_NAME_V3.sys_feature_cat		(already filled)


	-- CONFIG
--------------------------------------
-- INSERT INTO SCHEMA_NAME_V3.config_client_forms	(already filled)
-- INSERT INTO SCHEMA_NAME_V3.config				(already filled)
	



	-- USER CUSTOMED (STUDY ONE BY ONE)
------------------------------------------------------		
-- INSERT INTO SCHEMA_NAME_V3.cat_feature			(already filled)
--if cat_feature different than default insert first node_type,arc_type etc:
	/*truncate ud.cat_feature;
	INSERT INTO ud.cat_feature(id, system_id, feature_type) SELECT id, type,'NODE' from ud.node_type;
	INSERT INTO ud.cat_feature(id, system_id, feature_type) SELECT id, type,'ARC' from ud.arc_type;
	INSERT INTO ud.cat_feature(id, system_id, feature_type) SELECT id, type,'CONNEC' from ud.connec_type;
	INSERT INTO ud.cat_feature(id, system_id, feature_type) SELECT id, type,'GULLY' from ud.gully_type;

-- INSERT INTO node_type							(already filled)

	/*--if different than default values
	TRUNCATE SCHEMA_NAME_V3.node_type;
	INSERT INTO SCHEMA_NAME_V3.node_type(id, type, epa_default, man_table, epa_table) SELECT id, type,epa_default,man_table,epa_table from SCHEMA_NAME_V2.node_type;*/ 

-- INSERT INTO arc_type								(already filled)
	/*--if different than default values
	TRUNCATE SCHEMA_NAME_V3.arc_type;
	INSERT INTO SCHEMA_NAME_V3.arc_type(id, type, epa_default, man_table, epa_table) SELECT id, type,epa_default,man_table,epa_table from SCHEMA_NAME_V2.arc_type;*/ 

-- INSERT INTO connec_type							(already filled)
-- INSERT INTO gully_type							(already filled)
-- INSERT INTO value_state							(already filled)
-- INSERT INTO value_verified						(already filled)
-- INSERT INTO value_yesno							(already filled)
-- INSERT INTO SCHEMA_NAME_V3.value_state_type VALUES (1,0,'OBSOLETE', FALSE);
-- INSERT INTO SCHEMA_NAME_V3.value_state_type VALUES (10,1,'ON SERVICE', TRUE);
-- INSERT INTO SCHEMA_NAME_V3.value_state_type VALUES (11,1,'PROVISIONAL', FALSE);




	-- COST
-------------------------------------
-- INSERT INTO SCHEMA_NAME_V3.price_simple SELECT * FROM SCHEMA_NAME_V2.price_simple;
-- ALTER TABLE SCHEMA_NAME_V3.price_compost ALTER COLUMN price DROP NOT NULL;
-- INSERT INTO SCHEMA_NAME_V3.price_compost SELECT * FROM SCHEMA_NAME_V2.price_compost;
-- INSERT INTO SCHEMA_NAME_V3.price_compost_value SELECT * FROM SCHEMA_NAME_V2.price_compost_value;



	-- CATALOGS
--------------------------------------
-- INSERT INTO SCHEMA_NAME_V3.cat_mat_node SELECT id,descript,link from SCHEMA_NAME_V2.cat_mat_node;
-- INSERT INTO SCHEMA_NAME_V3.cat_node SELECT id,matcat_id,null as shape, geom1, geom2, geom3, value, descript,link,null as brand,null as model,svg,estimated_y,cost_unit,cost,null as active FROM SCHEMA_NAME_V2.cat_node;
-- INSERT INTO SCHEMA_NAME_V3.cat_mat_arc SELECT id,descript,n, link from SCHEMA_NAME_V2.cat_mat_arc;
/*INSERT INTO SCHEMA_NAME_V3.cat_arc 
SELECT 
id, matcat_id, shape, geom1, geom2, geom3, geom4, geom5, geom6, geom7, geom8, geom_r, descript, link, null as brand, null as model, svg, z1, z2, width, area, estimated_depth, bulk, cost_unit, cost, m2bottom_cost, m3protec_cost, null as active
FROM SCHEMA_NAME_V2.cat_arc*/
-- INSERT INTO SCHEMA_NAME_V3.cat_connec SELECT id, matcat_id, shape, geom1, geom2, geom3, geom4, geom_r, descript, link, null as brand, null as model, svg, null as cost_ut, null as cost_ml, null as cost_m3, null as active FROM SCHEMA_NAME_V2.cat_connec;
-- INSERT INTO SCHEMA_NAME_V3.cat_mat_element SELECT id,descript,link FROM SCHEMA_NAME_V2.cat_mat_element;
-- INSERT INTO SCHEMA_NAME_V3.cat_element SELECT id,elementtype_id,matcat_id,geometry, descript,link,null as brand, null as type, null as model,svg,null as active FROM SCHEMA_NAME_V2.cat_element;
-- INSERT INTO SCHEMA_NAME_V3.cat_builder SELECT id,descript,link FROM SCHEMA_NAME_V2.cat_builder;
-- INSERT INTO SCHEMA_NAME_V3.cat_owner SELECT id,descript,link FROM SCHEMA_NAME_V2.cat_owner;
-- INSERT INTO SCHEMA_NAME_V3.cat_work select id,descript,link,null as workid_key1,null as workid_key2,null as builtdate from SCHEMA_NAME_V2.cat_work;
-- INSERT INTO SCHEMA_NAME_V3.cat_soil SELECT id, descript, link, y_param, b, trenchlining, m3exc_cost, m3fill_cost, m3excess_cost, m2trenchl_cost FROM SCHEMA_NAME_V2.cat_soil;
-- INSERT INTO SCHEMA_NAME_V3.cat_pavement SELECT id, descript, link, thickness, m2_cost FROM SCHEMA_NAME_V2.cat_pavement ;
-- INSERT INTO SCHEMA_NAME_V3.cat_grate SELECT id, matcat_id, length, width, total_area, efective_area, n_barr_l, n_barr_w, n_barr_diag, a_param, b_param, descript, link, null as brand, null as model, svg, null as cost_ut, null as active FROM SCHEMA_NAME_V2.cat_grate;


	-- DROP NOT NULLS (REQUIRED)
-------------------------------------------------
-- ALTER TABLE SCHEMA_NAME_V3.macrodma ALTER COLUMN expl_id DROP NOT NULL;
-- ALTER TABLE SCHEMA_NAME_V3.dma ALTER COLUMN expl_id DROP NOT NULL;
-- ALTER TABLE SCHEMA_NAME_V3.ext_plot ALTER COLUMN streetaxis_id DROP NOT NULL;



	-- DOMAINS OF VALUE
----------------------------------------

-- INSERT INTO SCHEMA_NAME_V3.man_type_category (category_type,feature_type) SELECT id,'NODE' FROM SCHEMA_NAME_V2.man_type_category;
-- INSERT INTO SCHEMA_NAME_V3.man_type_category (category_type,feature_type) SELECT id,'ARC' FROM SCHEMA_NAME_V2.man_type_category;
-- INSERT INTO SCHEMA_NAME_V3.man_type_category (category_type,feature_type) SELECT id,'CONNEC' FROM SCHEMA_NAME_V2.man_type_category;
-- INSERT INTO SCHEMA_NAME_V3.man_type_category (category_type,feature_type) SELECT id,'GULLY' FROM SCHEMA_NAME_V2.man_type_category;


-- INSERT INTO SCHEMA_NAME_V3.man_type_fluid (fluid_type,feature_type) SELECT id,'NODE' FROM SCHEMA_NAME_V2.man_type_fluid;
-- INSERT INTO SCHEMA_NAME_V3.man_type_fluid (fluid_type,feature_type) SELECT id,'ARC' FROM SCHEMA_NAME_V2.man_type_fluid;
-- INSERT INTO SCHEMA_NAME_V3.man_type_fluid (fluid_type,feature_type) SELECT id,'CONNEC' FROM SCHEMA_NAME_V2.man_type_fluid;
-- INSERT INTO SCHEMA_NAME_V3.man_type_fluid (fluid_type,feature_type) SELECT id,'GULLY' FROM SCHEMA_NAME_V2.man_type_fluid;


-- INSERT INTO SCHEMA_NAME_V3.man_type_location (location_type,feature_type) SELECT id,'NODE' FROM SCHEMA_NAME_V2.man_type_location;
-- INSERT INTO SCHEMA_NAME_V3.man_type_location (location_type,feature_type) SELECT id,'ARC' FROM SCHEMA_NAME_V2.man_type_location;
-- INSERT INTO SCHEMA_NAME_V3.man_type_location (location_type,feature_type) SELECT id,'CONNEC' FROM SCHEMA_NAME_V2.man_type_location;
-- INSERT INTO SCHEMA_NAME_V3.man_type_location (location_type,feature_type) SELECT id,'GULLY' FROM SCHEMA_NAME_V2.man_type_location;




	-- NEW MAP ZONES
------------------------------------------
-- INSERT INTO SCHEMA_NAME_V3.macroexploitation VALUES (1,'Macroexploitation-1','Macroexploitation-1');
-- INSERT INTO SCHEMA_NAME_V3.exploitation (expl_id,name,macroexpl_id,descript,undelete,the_geom) SELECT 1, dma_id, 1, descript,undelete,the_geom FROM SCHEMA_NAME_V2.dma;
-- INSERT INTO SCHEMA_NAME_V3.ext_municipality (muni_id,name,the_geom) SELECT 1, 'Sant Boi del Llobregat', the_geom FROM SCHEMA_NAME_V2.dma;
-- INSERT INTO SCHEMA_NAME_V3.macrodma (name,descript,undelete,the_geom) SELECT concat('macro',dma_id),descript,undelete,(st_dump(the_geom)).geom FROM SCHEMA_NAME_V2.dma;


	-- OLD MAP ZONES
------------------------------------------
-- INSERT INTO SCHEMA_NAME_V3.sector (name,descript,undelete,the_geom) SELECT sector_id,descript,undelete,the_geom FROM SCHEMA_NAME_V2.sector;
-- INSERT INTO SCHEMA_NAME_V3.dma (name,descript,undelete,the_geom) SELECT dma_id,descript,undelete,(st_dump(the_geom)).geom FROM SCHEMA_NAME_V2.dma;



	-- MAIN GEO TABLES
----------------------------------------
/*
INSERT INTO  ud.node(node_id,
            code, top_elev, ymax, elev, custom_top_elev, custom_ymax, 
            custom_elev, sys_elev, node_type, nodecat_id, epa_type, sector_id, 
            state, state_type, annotation, observ, comment, dma_id, soilcat_id, 
            function_type, category_type, fluid_type, location_type, workcat_id, 
            workcat_id_end, buildercat_id, builtdate, enddate, ownercat_id, 
            muni_id, postcode, streetaxis_id, postnumber, postcomplement, 
            streetaxis2_id, postnumber2, postcomplement2, descript, rotation, 
            link, verified, the_geom, undelete, label_x, label_y, label_rotation, 
            publish, inventory, xyz_date, uncertain, unconnected, expl_id, 
            num_value )
SELECT 
node_id,
node_id,
top_elev,
ymax,
null as elev,
null as custom_top_elev,
null as custom_ymax,
null as custom_elev,
null as sys_elev,
node_type,
nodecat_id,
epa_type, 
1 as sector_id,
CASE WHEN state='PLANIFIED ' THEN 2 ELSE 1 END as state,
10 as state_type,
annotation,
observ,
comment,
1 as dma_id,
soilcat_id,
null as function_type,
category_type,
fluid_type,
location_type,
workcat_id,
workcat_id_end,
buildercat_id,
builtdate, 
null as enddate,
ownercat_id,
null as muni_id,
null as postcode,
null as streetaxis_id,
null as postnumber,
null as postcomplement,
null as postcomplement2,
null as streetaxis2_id,
null as postnumber2,
descript,
rotation,
link,
verified,
the_geom,
undelete,
label_x, 
label_y, 
label_rotation,
null as publish,
null as inventory,
null as xyz_date,
null as uncertain,
null as unconnected,
1 as expl_id,
null as num_value
FROM ud_sabemsa.node
*/

/*
INSERT INTO SCHEMA_NAME_V3.arc
SELECT
arc_id,
arc_id,
node_1,
node_2,
y1,
y2,
null as elev1,
null as elev2,
est_y1 as custom_y1,
est_y2 as custom_y2,
null as custom_elev1,
null as custom_elev2,
null as sys_elev1,
null as sys_elev2,
arc_type,
arccat_id,
epa_type,
1 as sector_id,
CASE WHEN state='PLANIFIED' THEN 2 ELSE 1 END as state,
10 as state_type,
annotation,
observ,
comment,
null as sys_slope,
inverted_slope,
null as sys_length,
custom_length,
1 as dma_id,
soilcat_id,
null as function_type,
category_type,
fluid_type,
location_type,
workcat_id,
workcat_id_end,
buildercat_id, 
builtdate,
null as enddate,
ownercat_id,
null as muni_id,
null as postcode,
null as streetaxis_id,
null as postnumber,
null as postcomplement,
null as postcomplement2,
null as streetaxis2_id,
null as postnumber2,
null as descript,
link,
verified,
the_geom,
undelete,
label_x, 
label_y, 
label_rotation,
null as publish,
null as inventory,
null as uncertain,
1 as expl_id,
null as num_value,
null as feature_type,
null as tstamp
FROM SCHEMA_NAME_V2.arc
*/

/*
INSERT INTO SCHEMA_NAME_V3.connec
SELECT
connec_id,
connec_id,
top_elev,
y1,
y2,
connec_type,
connecat_id,
1 as sector_id,
code,
private_connecat_id,
demand,
CASE WHEN state='PLANIFIED' THEN 2 ELSE 1 END as state,
10 as state_type,
null as connec_depth,
null as connec_length,
null as arc_id,
annotation,
observ,
comment,
1 as dma_id,
soilcat_id,
null as function_type,
category_type,
fluid_type,
location_type,
workcat_id,
workcat_id_end,
buildercat_id,
builtdate,
null as enddate,
ownercat_id,
null as muni_id,
null as postcode,
null as streetaxis_id,
null as postnumber,
null as postcomplement,
null as postcomplement2,
null as streetaxis2_id,
null as postnumber2,
descript,
link,
verified,
rotation,
the_geom,
undelete,
featurecat_id,
feature_id,
label_x,
label_y,
label_rotation,
accessibility,
diagonal,
null as publish,
null as inventory,
null as uncertain,
1 as expl_id,
null as num_value,
null as feature_type,
null as tstamp
FROM SCHEMA_NAME_V2.connec
*/

/*
INSERT INTO SCHEMA_NAME_V3.gully
SELECT 
gully_id,
gully_id,
top_elev,
ymax,
sandbox,
matcat_id,
'GULLY' as gully_type,
gratecat_id,
units,
cast(groove as bool),
cast(siphon as bool),
arccat_id,
null as connec_length,
null as connec_depth,
arc_id,
1 as sector_id,
CASE WHEN state='PLANIFIED' THEN 2 ELSE 1 END as state,
10 as state_type,
annotation,
observ,
comment,
1 as dma_id,
soilcat_id,
null as function_type,
category_type,
fluid_type,
location_type,
workcat_id,
workcat_id_end,
buildercat_id,
builtdate,
null as enddate,
ownercat_id,
null as muni_id,
null as postcode,
null as streetaxis_id,
null as postnumber,
null as postcomplement,
null as postcomplement2,
null as streetaxis2_id,
null as postnumber2,
descript,
link,
verified,
rotation,
the_geom,
the_geom_pol,
undelete,
featurecat_id,
feature_id,
label_x,
label_y,
label_rotation,
null as publish,
null as inventory,
null as uncertain,
1 as expl_id,
null as num_value,
null as feature_type,
null as tstamp
FROM SCHEMA_NAME_V2.gully
*/


	-- ANOTHER GEO TABLES
----------------------------------------
-- INSERT INTO SCHEMA_NAME_V3.link SELECT cast(link_id as int),connec_id, null as feature_type, null as exit_id, null as exit_type, null as userdefined_geom, 1 as state, 1 as expl_id, the_geom, null as tstamp FROM SCHEMA_NAME_V2.link
-- INSERT INTO SCHEMA_NAME_V3.vnode SELECT cast(vnode_id as int), vnode_type, annotation, 1 as sector_id, 1 as dma_id, 1 as state,1 as expl_id, the_geom, null as tstamp FROM SCHEMA_NAME_V2.vnode
-- INSERT INTO SCHEMA_NAME_V3.polygon SELECT pol_id, null as sys_feature_cat, text, ST_Multi(the_geom), undelete, null as tstamp FROM SCHEMA_NAME_V2.polygon


	-- DOC TABLES
-----------------------------------------
-- doc
-- doc_type		(already filled)
-- doc_x_arc
-- doc_x_connec
-- doc_x_node


	-- ELEMENT TABLES
-----------------------------------------
/*
INSERT INTO SCHEMA_NAME_V3.element 
SELECT
element_id,
null as code,
elementcat_id,
null as serial_number,
units,
1 as state,
null as state_type,
observ,
comment,
null as function_type,
null as category_type,
null as fluid_id,
location_type,
workcat_id,
workcat_id_end,
buildercat_id,
builtdate,
enddate,
ownercat_id,
rotation,
link,
verified,
null as the_geom,
null as label_x,
null as label_y,
null as label_rotation,
null as undelete,
null as publish,
null as inventory,
1 as expl_id,
null as feature_type,
null as tstamp
FROM SCHEMA_NAME_V2.element
*/


-- element_type			(already filled)
-- INSERT INTO SCHEMA_NAME_V3.element_x_arc SELECT cast(id as int), element_id, arc_id FROM SCHEMA_NAME_V2.element_x_arc;
-- INSERT INTO SCHEMA_NAME_V3.element_x_connec SELECT cast(id as int), element_id, connec_id FROM SCHEMA_NAME_V2.element_x_connec;
-- INSERT INTO SCHEMA_NAME_V3.element_x_node SELECT cast (id as int), element_id, node_id FROM SCHEMA_NAME_V2.element_x_node;




	-- EXT TABLES
-----------------------------------------
-- INSERT INTO SCHEMA_NAME_V3.ext_streetaxis SELECT id, type, name, text, the_geom, 1 as expl_id, 1 as muni_id FROM SCHEMA_NAME_V2.ext_streetaxis;
-- INSERT INTO SCHEMA_NAME_V3.ext_plot SELECT id, code, 1, 08830, streetaxis, postnumber, complement, placement, square, observ, text, the_geom, 1 as expl_id  FROM SCHEMA_NAME_V2.ext_urban_propierties;




	-- MAN TABLES
----------------------------------------
-- INSERT INTO SCHEMA_NAME_V3.man_chamber SELECT node_id, pol_id, null as length, null as width, null as sander_depth, null as max_volume, null as util_volume, null as inlet, null as bottom_chanel, null as accessibility, chamber_name FROM SCHEMA_NAME_V2.man_chamber;
-- INSERT INTO SCHEMA_NAME_V3.man_conduit SELECT arc_id FROM SCHEMA_NAME_V2.man_conduit;
-- INSERT INTO SCHEMA_NAME_V3.man_junction SELECT node_id FROM SCHEMA_NAME_V2.man_junction;
-- INSERT INTO SCHEMA_NAME_V3.man_manhole SELECT node_id, null as length, null as width, sander_depth, prot_surface, null as inlet, null as bottom_channel, null as accessibility FROM SCHEMA_NAME_V2.man_manhole;
-- INSERT INTO SCHEMA_NAME_V3.man_netgully SELECT node_id, pol_id, null as sander_depth, null as gratecat_id, null as units, null as groove, null as siphon FROM SCHEMA_NAME_V2.man_netgully;
-- INSERT INTO SCHEMA_NAME_V3.man_netinit SELECT node_id, null as length, null as width, null as inlet, null as bottom_channel, null as accessibility, netinit_name, null as sander_depth FROM SCHEMA_NAME_V2.man_netinit;
-- INSERT INTO SCHEMA_NAME_V3.man_outfall SELECT node_id, outfall_name FROM SCHEMA_NAME_V2.man_outfall;
-- INSERT INTO SCHEMA_NAME_V3.man_siphon SELECT arc_id, siphon_name FROM SCHEMA_NAME_V2.man_siphon;
-- INSERT INTO SCHEMA_NAME_V3.man_storage SELECT node_id, pol_id, null as length, null as width, null as custom_area, null as max_volume, util_volume, null as min_heigth, null as accessibility, storage_name FROM SCHEMA_NAME_V2.man_storage;
-- INSERT INTO SCHEMA_NAME_V3.man_valve SELECT node_id, valve_name FROM SCHEMA_NAME_V2.man_valve;
-- INSERT INTO SCHEMA_NAME_V3.man_varc SELECT arc_id FROM SCHEMA_NAME_V2.man_varc;
-- INSERT INTO SCHEMA_NAME_V3.man_waccel SELECT arc_id, sander_length, sander_depth, prot_surface, null as accessibility, waccel_name FROM SCHEMA_NAME_V2.man_waccel;
-- INSERT INTO SCHEMA_NAME_V3.man_wjump SELECT node_id, null as length, null as width, sander_depth, prot_surface, null as accessibility, wjump_name FROM SCHEMA_NAME_V2.man_wjump;
-- INSERT INTO SCHEMA_NAME_V3.man_wwtp SELECT node_id, pol_id, wwtp_name FROM SCHEMA_NAME_V2.man_wwtp;



	-- INP TABLES
----------------------------------------
-- INSERT INTO SCHEMA_NAME_V3.inp_backdrop SELECT * FROM SCHEMA_NAME_V2.inp_backdrop;
-- INSERT INTO SCHEMA_NAME_V3.inp_conduit SELECT * FROM SCHEMA_NAME_V2.inp_conduit;
-- INSERT INTO SCHEMA_NAME_V3.inp_curve_id SELECT * FROM SCHEMA_NAME_V2.inp_curve_id;
-- INSERT INTO SCHEMA_NAME_V3.inp_curve SELECT * FROM SCHEMA_NAME_V2.inp_curve;
-- INSERT INTO SCHEMA_NAME_V3.inp_pattern SELECT pattern_id, null as observ FROM SCHEMA_NAME_V2.inp_pattern;
-- INSERT INTO SCHEMA_NAME_V3.inp_junction SELECT * FROM SCHEMA_NAME_V2.inp_junction;
-- INSERT INTO SCHEMA_NAME_V3.inp_weir SELECT * FROM SCHEMA_NAME_V2.inp_weir;


	-- ADDFIELDS (TO REVIEW)

------------------------------------------
-- INSERT INTO SCHEMA_NAME_V3.man_addfields_value SELECT id, 'N250',parameter_id, value_param, value, temp_param FROM ud.man_addfields_value;




	-- CONFIG VERSION 3 (TO REVIEW)
----------------------------------------
-- INSERT INTO SCHEMA_NAME_V3.config_param_user SELECT * FROM ud.config_param_user
-- DELETE FROM SCHEMA_NAME_V3.config_param_system
-- INSERT INTO SCHEMA_NAME_V3.config_param_system SELECT * FROM ud.config_param_system

/*
INSERT INTO SCHEMA_NAME_V3.config_web_fields VALUES (2, 'review_arc', 'y1', NULL, 'numeric', 12, 3, NULL, NULL, 'QLineEdit', NULL, NULL, NULL, NULL, true);
INSERT INTO SCHEMA_NAME_V3.config_web_fields VALUES (14, 'review_node', 'ymax', NULL, 'numeric', 12, 3, NULL, NULL, 'QLineEdit', NULL, NULL, NULL, NULL, true);
INSERT INTO SCHEMA_NAME_V3.config_web_fields VALUES (47, 'review_connec', 'y1', NULL, 'numeric', 12, 3, NULL, NULL, 'QLineEdit', NULL, NULL, NULL, NULL, true);
INSERT INTO SCHEMA_NAME_V3.config_web_fields VALUES (49, 'review_connec', 'matcat_id', NULL, 'text', 30, NULL, NULL, NULL, 'QComboBox', 'cat_mat_arc', 'id', 'id', NULL, true);
INSERT INTO SCHEMA_NAME_V3.config_web_fields VALUES (50, 'review_connec', 'y2', NULL, 'numeric', 12, 3, NULL, NULL, 'QLineEdit', NULL, NULL, NULL, NULL, true);
INSERT INTO SCHEMA_NAME_V3.config_web_fields VALUES (51, 'review_connec', 'arc_type', NULL, 'text', 18, NULL, NULL, NULL, 'QComboBox', 'arc_type', 'id', 'id', NULL, true);
INSERT INTO SCHEMA_NAME_V3.config_web_fields VALUES (1, 'review_arc', 'arc_id', NULL, 'text', 16, NULL, NULL, NULL, 'QLineEdit', NULL, NULL, NULL, NULL, false);
INSERT INTO SCHEMA_NAME_V3.config_web_fields VALUES (52, 'review_connec', 'shape', NULL, 'text', 30, NULL, NULL, NULL, 'QComboBox', 'cat_arc_shape', 'id', 'id', NULL, true);
INSERT INTO SCHEMA_NAME_V3.config_web_fields VALUES (53, 'review_connec', 'geom1', NULL, 'numeric', 12, 3, NULL, NULL, 'QLineEdit', NULL, NULL, NULL, NULL, true);
INSERT INTO SCHEMA_NAME_V3.config_web_fields VALUES (54, 'review_connec', 'geom2', NULL, 'numeric', 12, 3, NULL, NULL, 'QLineEdit', NULL, NULL, NULL, NULL, true);
INSERT INTO SCHEMA_NAME_V3.config_web_fields VALUES (55, 'review_connec', 'annotation', NULL, 'text', 500, NULL, NULL, NULL, 'QLineEdit', NULL, NULL, NULL, NULL, true);
INSERT INTO SCHEMA_NAME_V3.config_web_fields VALUES (56, 'review_connec', 'observ', NULL, 'text', 500, NULL, NULL, NULL, 'QLineEdit', NULL, NULL, NULL, NULL, true);
INSERT INTO SCHEMA_NAME_V3.config_web_fields VALUES (57, 'review_connec', 'field_checked', NULL, 'boolean', NULL, NULL, NULL, NULL, 'QCheckBox', NULL, NULL, NULL, NULL, true);
INSERT INTO SCHEMA_NAME_V3.config_web_fields VALUES (48, 'review_connec', 'connec_id', NULL, 'text', 16, NULL, NULL, NULL, 'QLineEdit', NULL, NULL, NULL, NULL, false);
INSERT INTO SCHEMA_NAME_V3.config_web_fields VALUES (59, 'review_gully', 'arc_id', NULL, 'text', 16, NULL, NULL, NULL, 'QLineEdit', NULL, NULL, NULL, NULL, false);
INSERT INTO SCHEMA_NAME_V3.config_web_fields VALUES (5, 'review_arc', 'matcat_id', NULL, 'text', 30, NULL, NULL, NULL, 'QComboBox', 'cat_mat_arc', 'id', 'id', NULL, true);
INSERT INTO SCHEMA_NAME_V3.config_web_fields VALUES (3, 'review_arc', 'y2', NULL, 'numeric', 12, 3, NULL, NULL, 'QLineEdit', NULL, NULL, NULL, NULL, true);
INSERT INTO SCHEMA_NAME_V3.config_web_fields VALUES (4, 'review_arc', 'arc_type', NULL, 'text', 18, NULL, NULL, NULL, 'QComboBox', 'arc_type', 'id', 'id', NULL, true);
INSERT INTO SCHEMA_NAME_V3.config_web_fields VALUES (62, 'review_gully', 'arc_type', NULL, 'text', 18, NULL, NULL, NULL, 'QComboBox', 'arc_type', 'id', 'id', NULL, true);
INSERT INTO SCHEMA_NAME_V3.config_web_fields VALUES (63, 'review_gully', 'shape', NULL, 'text', 30, NULL, NULL, NULL, 'QComboBox', 'cat_arc_shape', 'id', 'id', NULL, true);
INSERT INTO SCHEMA_NAME_V3.config_web_fields VALUES (6, 'review_arc', 'shape', NULL, 'text', 30, NULL, NULL, NULL, 'QComboBox', 'cat_arc_shape', 'id', 'id', NULL, true);
INSERT INTO SCHEMA_NAME_V3.config_web_fields VALUES (64, 'review_gully', 'geom1', NULL, 'numeric', 12, 3, NULL, NULL, 'QLineEdit', NULL, NULL, NULL, NULL, true);
INSERT INTO SCHEMA_NAME_V3.config_web_fields VALUES (7, 'review_arc', 'geom1', NULL, 'numeric', 12, 3, NULL, NULL, 'QLineEdit', NULL, NULL, NULL, NULL, true);
INSERT INTO SCHEMA_NAME_V3.config_web_fields VALUES (65, 'review_gully', 'geom2', NULL, 'numeric', 12, 3, NULL, NULL, 'QLineEdit', NULL, NULL, NULL, NULL, true);
INSERT INTO SCHEMA_NAME_V3.config_web_fields VALUES (8, 'review_arc', 'geom2', NULL, 'numeric', 12, 3, NULL, NULL, 'QLineEdit', NULL, NULL, NULL, NULL, true);
INSERT INTO SCHEMA_NAME_V3.config_web_fields VALUES (9, 'review_arc', 'annotation', NULL, 'text', 500, NULL, NULL, NULL, 'QLineEdit', NULL, NULL, NULL, NULL, true);
INSERT INTO SCHEMA_NAME_V3.config_web_fields VALUES (10, 'review_arc', 'observ', NULL, 'text', 500, NULL, NULL, NULL, 'QLineEdit', NULL, NULL, NULL, NULL, true);
INSERT INTO SCHEMA_NAME_V3.config_web_fields VALUES (11, 'review_arc', 'field_checked', NULL, 'boolean', NULL, NULL, NULL, NULL, 'QCheckBox', NULL, NULL, NULL, NULL, true);
INSERT INTO SCHEMA_NAME_V3.config_web_fields VALUES (66, 'review_gully', 'annotation', NULL, 'text', 500, NULL, NULL, NULL, 'QLineEdit', NULL, NULL, NULL, NULL, true);
INSERT INTO SCHEMA_NAME_V3.config_web_fields VALUES (67, 'review_gully', 'observ', NULL, 'text', 500, NULL, NULL, NULL, 'QLineEdit', NULL, NULL, NULL, NULL, true);
INSERT INTO SCHEMA_NAME_V3.config_web_fields VALUES (15, 'review_node', 'node_type', NULL, 'text', 18, NULL, NULL, NULL, 'QComboBox', 'node_type', 'id', 'id', NULL, true);
INSERT INTO SCHEMA_NAME_V3.config_web_fields VALUES (16, 'review_node', 'matcat_id', NULL, 'text', 30, NULL, NULL, NULL, 'QComboBox', 'cat_mat_node', 'id', 'id', NULL, true);
INSERT INTO SCHEMA_NAME_V3.config_web_fields VALUES (68, 'review_gully', 'field_checked', NULL, 'boolean', NULL, NULL, NULL, NULL, 'QCheckBox', NULL, NULL, NULL, NULL, true);
INSERT INTO SCHEMA_NAME_V3.config_web_fields VALUES (17, 'review_node', 'shape', NULL, 'text', 30, NULL, NULL, NULL, 'QComboBox', 'cat_node_shape', 'id', 'id', NULL, true);
INSERT INTO SCHEMA_NAME_V3.config_web_fields VALUES (61, 'review_gully', 'ymax', NULL, 'numeric', 12, 3, NULL, NULL, 'QLineEdit', NULL, NULL, NULL, NULL, true);
INSERT INTO SCHEMA_NAME_V3.config_web_fields VALUES (18, 'review_node', 'geom1', NULL, 'numeric', 12, 3, NULL, NULL, 'QLineEdit', NULL, NULL, NULL, NULL, true);
INSERT INTO SCHEMA_NAME_V3.config_web_fields VALUES (19, 'review_node', 'geom2', NULL, 'numeric', 12, 3, NULL, NULL, 'QLineEdit', NULL, NULL, NULL, NULL, true);
INSERT INTO SCHEMA_NAME_V3.config_web_fields VALUES (20, 'review_node', 'annotation', NULL, 'text', 500, NULL, NULL, NULL, 'QLineEdit', NULL, NULL, NULL, NULL, true);
INSERT INTO SCHEMA_NAME_V3.config_web_fields VALUES (21, 'review_node', 'observ', NULL, 'text', 500, NULL, NULL, NULL, 'QLineEdit', NULL, NULL, NULL, NULL, true);
INSERT INTO SCHEMA_NAME_V3.config_web_fields VALUES (22, 'review_node', 'field_checked', NULL, 'boolean', NULL, NULL, NULL, NULL, 'QCheckBox', NULL, NULL, NULL, NULL, true);
INSERT INTO SCHEMA_NAME_V3.config_web_fields VALUES (12, 'review_node', 'node_id', NULL, 'text', 16, NULL, NULL, NULL, 'QLineEdit', NULL, NULL, NULL, NULL, false);
INSERT INTO SCHEMA_NAME_V3.config_web_fields VALUES (60, 'review_gully', 'connec_matcat', NULL, 'text', 30, NULL, NULL, NULL, 'QComboBox', 'cat_mat_arc', 'id', 'id', NULL, true);
INSERT INTO SCHEMA_NAME_V3.config_web_fields VALUES (58, 'review_gully', 'top_elev', NULL, 'numeric', 12, 3, NULL, NULL, 'QLineEdit', NULL, NULL, NULL, NULL, true);
INSERT INTO SCHEMA_NAME_V3.config_web_fields VALUES (69, 'review_gully', 'sandbox', NULL, 'numeric', 12, 3, NULL, NULL, 'QLineEdit', NULL, NULL, NULL, NULL, true);
INSERT INTO SCHEMA_NAME_V3.config_web_fields VALUES (70, 'review_gully', 'groove', NULL, 'boolean', NULL, NULL, NULL, NULL, 'QCheckBox', NULL, NULL, NULL, NULL, true);
INSERT INTO SCHEMA_NAME_V3.config_web_fields VALUES (71, 'review_gully', 'siphon', NULL, 'boolean', NULL, NULL, NULL, NULL, 'QCheckBox', NULL, NULL, NULL, NULL, true);
INSERT INTO SCHEMA_NAME_V3.config_web_fields VALUES (73, 'review_gully', 'featurecat_id', NULL, 'text', 30, NULL, NULL, NULL, 'QComboBox', 'cat_feature', 'id', 'id', NULL, true);
INSERT INTO SCHEMA_NAME_V3.config_web_fields VALUES (74, 'review_gully', 'feature_id', NULL, 'text', 16, NULL, NULL, NULL, 'QLineEdit', NULL, NULL, NULL, NULL, true);
INSERT INTO SCHEMA_NAME_V3.config_web_fields VALUES (13, 'review_node', 'top_elev', NULL, 'numeric', 12, 3, NULL, NULL, 'QLineEdit', NULL, NULL, NULL, NULL, true);


INSERT INTO SCHEMA_NAME_V3.config_web_forms VALUES (47, 'v_ui_node_x_connection_upstream', 'SELECT feature_id, featurecat_id FROM v_ui_node_x_connection_upstream', 1);
INSERT INTO SCHEMA_NAME_V3.config_web_forms VALUES (22, 'v_ui_om_visit_x_gully', 'SELECT event_id, parameter_id, value FROM v_ui_om_visit_x_gully', 1);
INSERT INTO SCHEMA_NAME_V3.config_web_forms VALUES (37, 'v_ui_arc_x_connection', 'SELECT feature_id, feature_type FROM v_ui_arc_x_connection', 1);
INSERT INTO SCHEMA_NAME_V3.config_web_forms VALUES (48, 'v_ui_node_x_connection_upstream', 'SELECT feature_id, featurecat_id FROM v_ui_node_x_connection_upstream', 2);
INSERT INTO SCHEMA_NAME_V3.config_web_forms VALUES (49, 'v_ui_node_x_connection_upstream', 'SELECT feature_id, featurecat_id FROM v_ui_node_x_connection_upstream', 3);
INSERT INTO SCHEMA_NAME_V3.config_web_forms VALUES (38, 'v_ui_arc_x_connection', 'SELECT feature_id, feature_type FROM v_ui_arc_x_connection', 2);
INSERT INTO SCHEMA_NAME_V3.config_web_forms VALUES (39, 'v_ui_arc_x_connection', 'SELECT feature_id, feature_type FROM v_ui_arc_x_connection', 3);
INSERT INTO SCHEMA_NAME_V3.config_web_forms VALUES (30, 'v_ui_doc_x_arc', 'SELECT doc_id, doc_id as doc_name, path  FROM v_ui_doc_x_arc', 3);
INSERT INTO SCHEMA_NAME_V3.config_web_forms VALUES (1, 'v_ui_element_x_node', 'SELECT element_id, elementcat_id, state  FROM v_ui_element_x_node', 1);
INSERT INTO SCHEMA_NAME_V3.config_web_forms VALUES (10, 'v_ui_element_x_gully', 'SELECT element_id, elementcat_id FROM v_ui_element_x_gully', 1);
INSERT INTO SCHEMA_NAME_V3.config_web_forms VALUES (4, 'v_ui_element_x_arc', 'SELECT element_id, elementcat_id, state FROM v_ui_element_x_arc', 1);
INSERT INTO SCHEMA_NAME_V3.config_web_forms VALUES (11, 'v_ui_element_x_gully', 'SELECT element_id, elementcat_id FROM v_ui_element_x_gully', 2);
INSERT INTO SCHEMA_NAME_V3.config_web_forms VALUES (40, 'v_ui_element', 'SELECT element_id, elementcat_id, num_elements, comment, state, observ, function_type, category_type, location_type, fluid_type, ownercat_id, workcat_id, builtdate, enddate, workcat_id_end, link FROM v_ui_element', 1);
INSERT INTO SCHEMA_NAME_V3.config_web_forms VALUES (7, 'v_ui_element_x_connec', 'SELECT element_id, elementcat_id FROM v_ui_element_x_connec', 1);
INSERT INTO SCHEMA_NAME_V3.config_web_forms VALUES (44, 'v_ui_node_x_connection_downstream', 'SELECT feature_id, featurecat_id FROM v_ui_node_x_connection_downstream', 1);
INSERT INTO SCHEMA_NAME_V3.config_web_forms VALUES (16, 'v_ui_om_visit_x_arc', 'SELECT event_id, parameter_id as id, value as valor FROM v_ui_om_visit_x_arc', 1);
INSERT INTO SCHEMA_NAME_V3.config_web_forms VALUES (8, 'v_ui_element_x_connec', 'SELECT element_id, elementcat_id FROM v_ui_element_x_connec', 2);
INSERT INTO SCHEMA_NAME_V3.config_web_forms VALUES (3, 'v_ui_element_x_node', 'SELECT element_id, elementcat_id, state FROM v_ui_element_x_node', 3);
INSERT INTO SCHEMA_NAME_V3.config_web_forms VALUES (9, 'v_ui_element_x_connec', 'SELECT element_id, elementcat_id FROM v_ui_element_x_connec', 3);
INSERT INTO SCHEMA_NAME_V3.config_web_forms VALUES (32, 'v_ui_doc_x_connec', 'SELECT doc_id, doc_id as doc_name  FROM v_ui_doc_x_connec', 2);
INSERT INTO SCHEMA_NAME_V3.config_web_forms VALUES (15, 'v_ui_om_visit_x_node', 'SELECT event_id, parameter_id as id, value as valor, tstamp::date as data FROM v_ui_om_visit_x_node', 3);
INSERT INTO SCHEMA_NAME_V3.config_web_forms VALUES (18, 'v_ui_om_visit_x_arc', 'SELECT event_id, parameter_id as id, value as valor FROM v_ui_om_visit_x_arc', 3);
INSERT INTO SCHEMA_NAME_V3.config_web_forms VALUES (17, 'v_ui_om_visit_x_arc', 'SELECT event_id, parameter_id as id, value as valor FROM v_ui_om_visit_x_arc', 2);
INSERT INTO SCHEMA_NAME_V3.config_web_forms VALUES (323, 'v_ui_om_visitman_x_connec', 'SELECT visit_id, visitcat_name, visit_start, visit_end, user_name FROM v_ui_om_visitman_x_connec', 2);
INSERT INTO SCHEMA_NAME_V3.config_web_forms VALUES (33, 'v_ui_doc_x_connec', 'SELECT doc_id, doc_id as doc_name  FROM v_ui_doc_x_connec', 3);
INSERT INTO SCHEMA_NAME_V3.config_web_forms VALUES (45, 'v_ui_node_x_connection_downstream', 'SELECT feature_id, featurecat_id FROM v_ui_node_x_connection_downstream', 2);
INSERT INTO SCHEMA_NAME_V3.config_web_forms VALUES (23, 'v_ui_om_visit_x_gully', 'SELECT event_id, parameter_id, value FROM v_ui_om_visit_x_gully', 2);
INSERT INTO SCHEMA_NAME_V3.config_web_forms VALUES (46, 'v_ui_node_x_connection_downstream', 'SELECT feature_id, featurecat_id FROM v_ui_node_x_connection_downstream', 3);
INSERT INTO SCHEMA_NAME_V3.config_web_forms VALUES (24, 'v_ui_om_visit_x_gully', 'SELECT event_id, parameter_id, value FROM v_ui_om_visit_x_gully', 3);
INSERT INTO SCHEMA_NAME_V3.config_web_forms VALUES (26, 'v_ui_doc_x_node', 'SELECT doc_id, doc_id as doc_name, path FROM v_ui_doc_x_node', 2);
INSERT INTO SCHEMA_NAME_V3.config_web_forms VALUES (19, 'v_ui_om_visit_x_connec', 'SELECT event_id, parameter_id, value FROM v_ui_om_visit_x_connec', 1);
INSERT INTO SCHEMA_NAME_V3.config_web_forms VALUES (12, 'v_ui_element_x_gully', 'SELECT element_id, elementcat_id FROM v_ui_element_x_gully', 3);
INSERT INTO SCHEMA_NAME_V3.config_web_forms VALUES (6, 'v_ui_element_x_arc', 'SELECT element_id, elementcat_id, state FROM v_ui_element_x_arc', 3);
INSERT INTO SCHEMA_NAME_V3.config_web_forms VALUES (36, 'v_ui_doc_x_gully', 'SELECT doc_id, doc_id as doc_name  FROM v_ui_doc_x_gully', 3);
INSERT INTO SCHEMA_NAME_V3.config_web_forms VALUES (14, 'v_ui_om_visit_x_node', 'SELECT event_id, parameter_id as id, value as valor FROM v_ui_om_visit_x_node', 2);
INSERT INTO SCHEMA_NAME_V3.config_web_forms VALUES (13, 'v_ui_om_visit_x_node', 'SELECT event_id, parameter_id as id, value as valor FROM v_ui_om_visit_x_node', 1);
INSERT INTO SCHEMA_NAME_V3.config_web_forms VALUES (2, 'v_ui_element_x_node', 'SELECT element_id, elementcat_id, state  FROM v_ui_element_x_node', 2);
INSERT INTO SCHEMA_NAME_V3.config_web_forms VALUES (27, 'v_ui_doc_x_node', 'SELECT doc_id, doc_id as doc_name, path FROM v_ui_doc_x_node', 3);
INSERT INTO SCHEMA_NAME_V3.config_web_forms VALUES (28, 'v_ui_doc_x_arc', 'SELECT doc_id, doc_id as doc_name, path  FROM v_ui_doc_x_arc', 1);
INSERT INTO SCHEMA_NAME_V3.config_web_forms VALUES (29, 'v_ui_doc_x_arc', 'SELECT doc_id, doc_id as doc_name, path  FROM v_ui_doc_x_arc', 2);
INSERT INTO SCHEMA_NAME_V3.config_web_forms VALUES (34, 'v_ui_doc_x_gully', 'SELECT doc_id, doc_id as doc_name  FROM v_ui_doc_x_gully', 1);
INSERT INTO SCHEMA_NAME_V3.config_web_forms VALUES (324, 'v_ui_om_visitman_x_connec', 'SELECT visit_id, visitcat_name, visit_start, visit_end, user_name FROM v_ui_om_visitman_x_connec', 3);
INSERT INTO SCHEMA_NAME_V3.config_web_forms VALUES (35, 'v_ui_doc_x_gully', 'SELECT doc_id, doc_id as doc_name  FROM v_ui_doc_x_gully', 2);
INSERT INTO SCHEMA_NAME_V3.config_web_forms VALUES (5, 'v_ui_element_x_arc', 'SELECT element_id, elementcat_id, state FROM v_ui_element_x_arc', 2);
INSERT INTO SCHEMA_NAME_V3.config_web_forms VALUES (20, 'v_ui_om_visit_x_connec', 'SELECT event_id, parameter_id, value FROM v_ui_om_visit_x_connec', 2);
INSERT INTO SCHEMA_NAME_V3.config_web_forms VALUES (21, 'v_ui_om_visit_x_connec', 'SELECT event_id, parameter_id, value FROM v_ui_om_visit_x_connec', 3);
INSERT INTO SCHEMA_NAME_V3.config_web_forms VALUES (318, 'v_ui_om_visitman_x_node', 'SELECT visit_id, visitcat_name, visit_start, visit_end, user_name FROM v_ui_om_visitman_x_node', 3);
INSERT INTO SCHEMA_NAME_V3.config_web_forms VALUES (321, 'v_ui_om_visitman_x_arc', 'SELECT visit_id, visitcat_name, visit_start, visit_end, user_name FROM v_ui_om_visitman_x_arc', 3);
INSERT INTO SCHEMA_NAME_V3.config_web_forms VALUES (322, 'v_ui_om_visitman_x_connec', 'SELECT visit_id, visitcat_name, visit_start, visit_end, user_name FROM v_ui_om_visitman_x_connec', 1);
INSERT INTO SCHEMA_NAME_V3.config_web_forms VALUES (31, 'v_ui_doc_x_connec', 'SELECT doc_id, doc_id as doc_name  FROM v_ui_doc_x_connec', 1);
INSERT INTO SCHEMA_NAME_V3.config_web_forms VALUES (25, 'v_ui_doc_x_node', 'SELECT doc_id, doc_id as doc_name, path FROM v_ui_doc_x_node', 1);
INSERT INTO SCHEMA_NAME_V3.config_web_forms VALUES (316, 'v_ui_om_visitman_x_node', 'SELECT visit_id, visitcat_name, visit_start, visit_end, user_name FROM v_ui_om_visitman_x_node', 1);
INSERT INTO SCHEMA_NAME_V3.config_web_forms VALUES (317, 'v_ui_om_visitman_x_node', 'SELECT visit_id, visitcat_name, visit_start, visit_end, user_name FROM v_ui_om_visitman_x_node', 2);
INSERT INTO SCHEMA_NAME_V3.config_web_forms VALUES (319, 'v_ui_om_visitman_x_arc', 'SELECT visit_id, visitcat_name, visit_start, visit_end, user_name FROM v_ui_om_visitman_x_arc', 1);
INSERT INTO SCHEMA_NAME_V3.config_web_forms VALUES (320, 'v_ui_om_visitman_x_arc', 'SELECT visit_id, visitcat_name, visit_start, visit_end, user_name FROM v_ui_om_visitman_x_arc', 2);
INSERT INTO SCHEMA_NAME_V3.config_web_forms VALUES (325, 'v_ui_om_visitman_x_gully', 'SELECT visit_id, visitcat_name, visit_start, visit_end, user_name FROM v_ui_om_visitman_x_gully', 1);
INSERT INTO SCHEMA_NAME_V3.config_web_forms VALUES (326, 'v_ui_om_visitman_x_gully', 'SELECT visit_id, visitcat_name, visit_start, visit_end, user_name FROM v_ui_om_visitman_x_gully', 2);
INSERT INTO SCHEMA_NAME_V3.config_web_forms VALUES (327, 'v_ui_om_visitman_x_gully', 'SELECT visit_id, visitcat_name, visit_start, visit_end, user_name FROM v_ui_om_visitman_x_gully', 3);
INSERT INTO SCHEMA_NAME_V3.config_web_forms VALUES (42, 'v_ui_element', 'SELECT element_id, elementcat_id, num_elements, comment, state, observ, function_type, category_type, location_type, fluid_type, ownercat_id, workcat_id, builtdate, enddate, workcat_id_end, link    FROM v_ui_element', 2);
INSERT INTO SCHEMA_NAME_V3.config_web_forms VALUES (43, 'v_ui_element', 'SELECT element_id, elementcat_id, num_elements, comment, state, observ, function_type, category_type, location_type, fluid_type, ownercat_id, workcat_id, builtdate, enddate, workcat_id_end, link    FROM v_ui_element', 3);
*/



	-- DO NOT MIGRATE
----------------------------------------
--anl_*
--rpt_*
--audit_function_actions
--temp_*
--point*
--om_*




	-- RESTITUTION
------------------------------------------
-- NOT NULLS
-- RULES ARC (pavement, psector)
