/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
*/


-- Function: "SCHEMA_NAME".gw_trg_edit_man_node()

-- DROP FUNCTION "SCHEMA_NAME".gw_trg_edit_man_node();

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_man_node()
  RETURNS trigger AS
$BODY$
DECLARE 
    inp_table varchar;
    v_sql varchar;
    v_sql2 varchar;
    man_table varchar;
	man_table_2 varchar;
    new_man_table varchar;
    old_man_table varchar;
    old_nodetype varchar;
    new_nodetype varchar;
    node_id_seq int8;

BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
	man_table:= TG_ARGV[0];

-- INSERT

    -- Control insertions ID
	IF TG_OP = 'INSERT' THEN
    
    -- Node ID
	IF (NEW.node_id IS NULL) THEN
        SELECT max(node_id) INTO node_id_seq FROM node WHERE node_id ~ '^\d+$';
        PERFORM setval('node_id_seq',node_id_seq,true);
		NEW.node_id:= (SELECT nextval('node_id_seq'));
	END IF;

    -- Epa type
	IF (NEW.epa_type IS NULL) THEN
		NEW.epa_type:= (SELECT epa_default FROM node_type WHERE node_type.id=NEW.node_type)::text;   
	END IF;

    IF (NEW.node_type IS NULL) THEN
            IF ((SELECT COUNT(*) FROM node_type WHERE node_type.man_table=man_table_2) = 0) THEN
                RETURN audit_function(105,430);  
            END IF;
            NEW.node_type:= (SELECT id FROM node_type WHERE node_type.man_table=man_table_2 LIMIT 1);
        END IF;


        -- Node Catalog ID
        IF (NEW.nodecat_id IS NULL) THEN
            IF ((SELECT COUNT(*) FROM cat_node) = 0) THEN
                RETURN audit_function(110,430);  
            END IF;
            NEW.nodecat_id:= (SELECT cat_node.id FROM cat_node JOIN node_type ON cat_node.nodetype_id=node_type.id WHERE node_type.man_table=man_table_2);
        END IF;

     -- Sector ID
        IF (NEW.sector_id IS NULL) THEN
            IF ((SELECT COUNT(*) FROM sector) = 0) THEN
                RETURN audit_function(115,430);  
            END IF;
            NEW.sector_id:= (SELECT sector_id FROM sector WHERE ST_DWithin(NEW.the_geom, sector.the_geom,0.001) LIMIT 1);
            IF (NEW.sector_id IS NULL) THEN
                RETURN audit_function(120,430);          
            END IF;            
        END IF;
        
     -- Dma ID
        IF (NEW.dma_id IS NULL) THEN
            IF ((SELECT COUNT(*) FROM dma) = 0) THEN
                RETURN audit_function(125,430);  
            END IF;
            NEW.dma_id := (SELECT dma_id FROM dma WHERE ST_DWithin(NEW.the_geom, dma.the_geom,0.001) LIMIT 1);
            IF (NEW.dma_id IS NULL) THEN
                RETURN audit_function(130,430);  
            END IF;            
        END IF;

-- FEATURE INSERT      
	IF man_table='man_tank' THEN
		INSERT INTO node (node_id, elevation, depth, node_type, nodecat_id, epa_type, sector_id, state, annotation, observ,comment, dma_id, soilcat_id, category_type, fluid_type, location_type, workcat_id, 
		buildercat_id, builtdate,ownercat_id, adress_01,adress_02, adress_03, descript, rotation, link, verified, the_geom,workcat_id_end,undelete,label_x,label_y,label_rotation) 
		VALUES (NEW.node_id, NEW.tank_elevation, NEW.tank_depth, NEW.node_type, NEW.nodecat_id, NEW.epa_type, NEW.sector_id, NEW.tank_state, NEW.tank_annotation, NEW.tank_observ, NEW.tank_comment,NEW.dma_id, 
		NEW.tank_soilcat_id, NEW.tank_category_type, NEW.tank_fluid_type, NEW.tank_location_type,NEW.tank_workcat_id, NEW.tank_buildercat_id, NEW.tank_builtdate,NEW.tank_ownercat_id, NEW.tank_adress_01, 
		NEW.tank_adress_02, NEW.tank_adress_03, NEW.tank_descript, NEW.tank_rotation, NEW.tank_link, NEW.verified, NEW.the_geom,NEW.tank_workcat_id_end,NEW.undelete,NEW.tank_label_x,NEW.tank_label_y,NEW.tank_label_rotation);

	ELSIF man_table='man_hydrant' THEN
		INSERT INTO node (node_id, elevation, depth, node_type, nodecat_id, epa_type, sector_id, state, annotation, observ,comment, dma_id, soilcat_id, category_type, fluid_type, location_type, workcat_id, 
		buildercat_id, builtdate,ownercat_id, adress_01, adress_02, adress_03, descript, rotation, link, verified, the_geom,workcat_id_end, undelete,label_x,label_y,label_rotation) 
		VALUES (NEW.node_id, NEW.hydrant_elevation, NEW.hydrant_depth, NEW.node_type, NEW.nodecat_id, NEW.epa_type, NEW.sector_id,	NEW.hydrant_state, NEW.hydrant_annotation, NEW.hydrant_observ, NEW.hydrant_comment, 
		NEW.dma_id, NEW.hydrant_soilcat_id, NEW.hydrant_category_type, NEW.hydrant_fluid_type, NEW.hydrant_location_type, NEW.hydrant_workcat_id, NEW.hydrant_buildercat_id, NEW.hydrant_builtdate,NEW.hydrant_ownercat_id,
		NEW.hydrant_adress_01, NEW.hydrant_adress_02, NEW.hydrant_adress_03, NEW.hydrant_descript, NEW.hydrant_rotation, NEW.hydrant_link, NEW.verified, NEW.the_geom,NEW.hydrant_workcat_id_end,NEW.undelete,
		NEW.hydrant_label_x,NEW.hydrant_label_y,NEW.hydrant_label_rotation);
		
	ELSIF man_table='man_junction' THEN
		INSERT INTO node (node_id, elevation, depth, node_type, nodecat_id, epa_type, sector_id, state, annotation, observ,comment, dma_id, soilcat_id, category_type, fluid_type, location_type, workcat_id, 
		buildercat_id, builtdate,ownercat_id, adress_01, adress_02, adress_03, descript, rotation, link, verified, the_geom,workcat_id_end, undelete,label_x,label_y,label_rotation)
		VALUES (NEW.node_id, NEW.junction_elevation, NEW.junction_depth, NEW.node_type, NEW.nodecat_id, NEW.epa_type, NEW.sector_id,	NEW.junction_state, NEW.junction_annotation, NEW.junction_observ, 
		NEW.junction_comment, NEW.dma_id, NEW.junction_soilcat_id, NEW.junction_category_type, NEW.junction_fluid_type, NEW.junction_location_type, NEW.junction_workcat_id, NEW.junction_buildercat_id, 
		NEW.junction_builtdate,NEW.junction_ownercat_id, NEW.junction_adress_01, NEW.junction_adress_02, NEW.junction_adress_03, NEW.junction_descript, NEW.junction_rotation, NEW.junction_link, NEW.verified, 
		NEW.the_geom,NEW.junction_workcat_id_end, NEW.undelete,NEW.junction_label_x,NEW.junction_label_y,NEW.junction_label_rotation);
	
	ELSIF man_table='man_pump' THEN
		INSERT INTO node (node_id, elevation, depth, node_type, nodecat_id, epa_type, sector_id, state, annotation, observ,comment, dma_id, soilcat_id, category_type, fluid_type, location_type, workcat_id, 
		buildercat_id, builtdate,ownercat_id, adress_01, adress_02, adress_03, descript, rotation, link, verified, the_geom,workcat_id_end, undelete,label_x,label_y,label_rotation) 
		VALUES (NEW.node_id, NEW.pump_elevation, NEW.pump_depth, NEW.node_type, NEW.nodecat_id, NEW.epa_type, NEW.sector_id,	NEW.pump_state, NEW.pump_annotation, NEW.pump_observ, NEW.pump_comment, NEW.dma_id, 
		NEW.pump_soilcat_id, NEW.pump_category_type, NEW.pump_fluid_type, NEW.pump_location_type, NEW.pump_workcat_id, NEW.pump_buildercat_id, NEW.pump_builtdate,NEW.pump_ownercat_id, NEW.pump_adress_01,NEW.pump_adress_02, 
		NEW.pump_adress_03, NEW.pump_descript, NEW.pump_rotation, NEW.pump_link, NEW.verified, NEW.the_geom,NEW.pump_workcat_id_end, NEW.undelete,NEW.pump_label_x,NEW.pump_label_y,NEW.pump_label_rotation);
		
	ELSIF man_table='man_reduction' THEN
		INSERT INTO node (node_id, elevation, depth, node_type, nodecat_id, epa_type, sector_id, state, annotation, observ,comment, dma_id, soilcat_id, category_type, fluid_type, location_type, workcat_id,
		buildercat_id, builtdate,ownercat_id, adress_01, adress_02, adress_03, descript, rotation, link, verified, the_geom,workcat_id_end,undelete,label_x,label_y,label_rotation) 
		VALUES (NEW.node_id, NEW.reduction_elevation, NEW.reduction_depth, NEW.node_type, NEW.nodecat_id, NEW.epa_type, NEW.sector_id,	NEW.reduction_state, NEW.reduction_annotation, NEW.reduction_observ, 
		NEW.reduction_comment, NEW.dma_id, NEW.reduction_soilcat_id, NEW.reduction_category_type, NEW.reduction_fluid_type, NEW.reduction_location_type, NEW.reduction_workcat_id, NEW.reduction_buildercat_id,
		NEW.reduction_builtdate,NEW.reduction_ownercat_id, NEW.reduction_adress_01, NEW.reduction_adress_02, NEW.reduction_adress_03, NEW.reduction_descript, NEW.reduction_rotation, NEW.reduction_link, 
		NEW.verified, NEW.the_geom,NEW.reduction_workcat_id_end, NEW.undelete,NEW.reduction_label_x,NEW.reduction_label_y,NEW.reduction_label_rotation);
		
	ELSIF man_table='man_valve' THEN	
		INSERT INTO node (node_id, elevation, depth, node_type, nodecat_id, epa_type, sector_id, state, annotation, observ,comment, dma_id, soilcat_id, category_type, fluid_type, location_type, workcat_id, 
		buildercat_id, builtdate,ownercat_id, adress_01, adress_02, adress_03, descript, rotation, link, verified, the_geom,workcat_id_end,undelete,label_x,label_y,label_rotation)
		VALUES (NEW.node_id, NEW.valve_elevation, NEW.valve_depth, NEW.node_type, NEW.nodecat_id, NEW.epa_type, NEW.sector_id,	NEW.valve_state, NEW.valve_annotation, NEW.valve_observ, NEW.valve_comment, 
		NEW.dma_id, NEW.valve_soilcat_id, NEW.valve_category_type, NEW.valve_fluid_type, NEW.valve_location_type, NEW.valve_workcat_id, NEW.valve_buildercat_id, NEW.valve_builtdate,NEW.valve_ownercat_id, 
		NEW.valve_adress_01, NEW.valve_adress_02, NEW.valve_adress_03, NEW.valve_descript, NEW.valve_rotation, NEW.valve_link, NEW.verified, NEW.the_geom,NEW.valve_workcat_id_end, NEW.undelete,NEW.valve_label_x,
		NEW.valve_label_y,NEW.valve_label_rotation);
		
	ELSIF man_table='man_manhole' THEN	
		INSERT INTO node (node_id, elevation, depth, node_type, nodecat_id, epa_type, sector_id, state, annotation, observ,comment, dma_id, soilcat_id, category_type, fluid_type, location_type, workcat_id, 
		buildercat_id, builtdate,ownercat_id, adress_01, adress_02, adress_03, descript, rotation, link, verified, the_geom,workcat_id_end, undelete,label_x,label_y,label_rotation) VALUES (NEW.node_id, 
		NEW.manhole_elevation, NEW.manhole_depth, NEW.node_type, NEW.nodecat_id, NEW.epa_type, NEW.sector_id,	NEW.manhole_state, NEW.manhole_annotation, NEW.manhole_observ, NEW.manhole_comment, NEW.dma_id, 
		NEW.manhole_soilcat_id, NEW.manhole_category_type, NEW.manhole_fluid_type, NEW.manhole_location_type, NEW.manhole_workcat_id, NEW.manhole_buildercat_id, NEW.manhole_builtdate,NEW.manhole_ownercat_id, 
		NEW.manhole_adress_01, NEW.manhole_adress_02, NEW.manhole_adress_03, NEW.manhole_descript, NEW.manhole_rotation, NEW.manhole_link, NEW.verified, NEW.the_geom,NEW.manhole_workcat_id_end, NEW.undelete,
		NEW.manhole_label_x,NEW.manhole_label_y,NEW.manhole_label_rotation);
		
	ELSIF man_table='man_meter' THEN
		INSERT INTO node (node_id, elevation, depth, node_type, nodecat_id, epa_type, sector_id, state, annotation, observ,comment, dma_id, soilcat_id, category_type, fluid_type, location_type, workcat_id, 
		buildercat_id, builtdate,ownercat_id, adress_01, adress_02, adress_03, descript, rotation, link, verified, the_geom,workcat_id_end, undelete,label_x,label_y,label_rotation) VALUES (NEW.node_id, 
		NEW.meter_elevation, NEW.meter_depth, NEW.node_type, NEW.nodecat_id, NEW.epa_type, NEW.sector_id,	NEW.meter_state, NEW.meter_annotation, NEW.meter_observ, NEW.meter_comment, NEW.dma_id, 
		NEW.meter_soilcat_id, NEW.meter_category_type, NEW.meter_fluid_type, NEW.meter_location_type, NEW.meter_workcat_id, NEW.meter_buildercat_id, NEW.meter_builtdate,NEW.meter_ownercat_id, NEW.meter_adress_01, 
		NEW.meter_adress_02, NEW.meter_adress_03, NEW.meter_descript, NEW.meter_rotation, NEW.meter_link, NEW.verified, NEW.the_geom,NEW.meter_workcat_id_end, NEW.undelete,NEW.meter_label_x,NEW.meter_label_y,
		NEW.meter_label_rotation);
		
	ELSIF man_table='man_source' THEN	
		INSERT INTO node (node_id, elevation, depth, node_type, nodecat_id, epa_type, sector_id, state, annotation, observ,comment, dma_id, soilcat_id, category_type, fluid_type, location_type, workcat_id, 
		buildercat_id, builtdate,ownercat_id, adress_01, adress_02, adress_03, descript, rotation, link, verified, the_geom,workcat_id_end,undelete,label_x,label_y,label_rotation) VALUES (NEW.node_id, 
		NEW.source_elevation, NEW.source_depth, NEW.node_type, NEW.nodecat_id, NEW.epa_type, NEW.sector_id,	NEW.source_state, NEW.source_annotation, NEW.source_observ, NEW.source_comment, NEW.dma_id, 
		NEW.source_soilcat_id, NEW.source_category_type, NEW.source_fluid_type, NEW.source_location_type, NEW.source_workcat_id, NEW.source_buildercat_id, NEW.source_builtdate,NEW.source_ownercat_id, 
		NEW.source_adress_01, NEW.source_adress_02, NEW.source_adress_03, NEW.source_descript, NEW.source_rotation, NEW.source_link, NEW.verified, NEW.the_geom,NEW.source_workcat_id_end, NEW.undelete,
		NEW.source_label_x,NEW.source_label_y,NEW.source_label_rotation);
		
	ELSIF man_table='man_waterwell' THEN
		INSERT INTO node (node_id, elevation, depth, node_type, nodecat_id, epa_type, sector_id, state, annotation, observ,comment, dma_id, soilcat_id, category_type, fluid_type, location_type, workcat_id, 
		buildercat_id, builtdate,ownercat_id, adress_01, adress_02, adress_03, descript, rotation, link, verified, the_geom,workcat_id_end, undelete,label_x,label_y,label_rotation) VALUES (NEW.node_id, 
		NEW.waterwell_elevation, NEW.waterwell_depth, NEW.node_type, NEW.nodecat_id, NEW.epa_type, NEW.sector_id,	NEW.waterwell_state, NEW.waterwell_annotation, NEW.waterwell_observ, NEW.waterwell_comment,
		NEW.dma_id, NEW.waterwell_soilcat_id, NEW.waterwell_category_type, NEW.waterwell_fluid_type, NEW.waterwell_location_type, NEW.waterwell_workcat_id, NEW.waterwell_buildercat_id, NEW.waterwell_builtdate,
		NEW.waterwell_ownercat_id, NEW.waterwell_adress_01, NEW.waterwell_adress_02, NEW.waterwell_adress_03, NEW.waterwell_descript, NEW.waterwell_rotation, NEW.waterwell_link, NEW.verified, NEW.the_geom,
		NEW.waterwell_workcat_id_end, NEW.undelete,NEW.waterwell_label_x,NEW.waterwell_label_y,NEW.waterwell_label_rotation);
	
	ELSIF man_table='man_filter' THEN
		INSERT INTO node (node_id, elevation, depth, node_type, nodecat_id, epa_type, sector_id, state, annotation, observ,comment, dma_id, soilcat_id, category_type, fluid_type, location_type, workcat_id, 
		buildercat_id, builtdate,ownercat_id, adress_01, adress_02, adress_03, descript, rotation, link, verified, the_geom,workcat_id_end, undelete,label_x,label_y,label_rotation)
		VALUES (NEW.node_id, NEW.filter_elevation, NEW.filter_depth, NEW.node_type, NEW.nodecat_id, NEW.epa_type, NEW.sector_id,	NEW.filter_state, NEW.filter_annotation, NEW.filter_observ, 
		NEW.filter_comment, NEW.dma_id, NEW.filter_soilcat_id, NEW.filter_category_type, NEW.filter_fluid_type, NEW.filter_location_type, NEW.filter_workcat_id, NEW.filter_buildercat_id, 
		NEW.filter_builtdate,NEW.filter_ownercat_id, NEW.filter_adress_01, NEW.filter_adress_02, NEW.filter_adress_03, NEW.filter_descript, NEW.filter_rotation, NEW.filter_link, NEW.verified, 
		NEW.the_geom,NEW.filter_workcat_id_end, NEW.undelete,NEW.filter_label_x,NEW.filter_label_y,NEW.filter_label_rotation);
		
	END IF;

								
-- EPA INSERT
        IF (NEW.epa_type = 'JUNCTION') THEN 
		inp_table:= 'inp_junction';

        ELSIF (NEW.epa_type = 'TANK') THEN 
		inp_table:= 'inp_tank';

        ELSIF (NEW.epa_type = 'RESERVOIR') 
		THEN inp_table:= 'inp_reservoir';

        ELSIF (NEW.epa_type = 'PUMP') 
		THEN inp_table:= 'inp_pump';

        ELSIF (NEW.epa_type = 'VALVE') 
		THEN inp_table:= 'inp_valve';

        ELSIF (NEW.epa_type = 'SHORTPIPE') 
		THEN inp_table:= 'inp_shortpipe';
        END IF;

        IF inp_table IS NOT NULL THEN        
            v_sql:= 'INSERT INTO '||inp_table||' (node_id) VALUES ('||quote_literal(NEW.node_id)||')';
            EXECUTE v_sql;
        END IF;

 -- MANAGEMENT INSERT		
	IF man_table ='man_junction' THEN
		INSERT INTO man_junction (node_id) VALUES(NEW.node_id);
	
	ELSIF man_table ='man_tank' THEN
		INSERT INTO man_tank (node_id,vmax,chlorination,function,area) VALUES (NEW.node_id, NEW.tank_vmax,NEW.tank_chlorination, NEW.tank_function,NEW.tank_area);
	
	ELSIF man_table='man_pump' THEN
		INSERT INTO man_pump (node_id) VALUES(NEW.node_id);
	
	ELSIF man_table='man_manhole' THEN
		INSERT INTO man_manhole (node_id) VALUES(NEW.node_id);
	
	ELSIF man_table='man_hydrant' THEN	
		INSERT INTO man_hydrant (node_id,communication,valve,valve_diam,distance_left,distance_right,distance_perpendicular, location, location_sign) VALUES (NEW.node_id,NEW.hydrant_communication,NEW.hydrant_valve,
		NEW.hydrant_valve_diam,NEW.hydrant_distance_left,NEW.hydrant_distance_right,NEW.hydrant_distance_perpendicular,NEW.hydrant_location,NEW.hydrant_location_sign);
	
	ELSIF man_table='man_source' THEN
		INSERT INTO man_source (node_id) VALUES(NEW.node_id);
	
	ELSIF man_table='man_meter' THEN
		INSERT INTO man_meter (node_id) VALUES(NEW.node_id);
	
	ELSIF man_table='man_waterwell' THEN
		INSERT INTO man_waterwell (node_id) VALUES(NEW.node_id);
	
	ELSIF man_table ='man_reduction' THEN
		INSERT INTO man_reduction (node_id,diam_initial,diam_final) VALUES(NEW.node_id,NEW.reduction_diam_initial,NEW.reduction_diam_final);
   	
	ELSIF man_table ='man_valve' THEN
		INSERT INTO man_valve (node_id,type,opened,acessibility,broken,mincut_anl,hydraulic_anl,burried,irrigation_indicator,pression_entry, pression_exit, depth_valveshaft,regulator_situation, regulator_location,
		regulator_observ,lin_meters, exit_type,exit_code,valve,valve_diam,drive_type,location) 
		VALUES (NEW.node_id, NEW.valve_type, NEW.valve_opened, NEW.valve_acessibility, NEW.valve_broken, NEW.valve_mincut_anl, NEW.valve_hydraulic_anl, NEW.valve_burried, NEW.valve_irrigation_indicator,
		NEW.valve_pression_entry, NEW.valve_pression_exit, NEW.valve_depth_valveshaft, NEW.valve_regulator_situation, NEW.valve_regulator_location, NEW.valve_regulator_observ, NEW.valve_lin_meters, 
		NEW.valve_exit_type, NEW.valve_exit_code, NEW.valve_valve, NEW.valve_valve_diam, NEW.valve_drive_type,NEW.valve_location);
    
	ELSIF man_table='man_filter' THEN
		INSERT INTO man_filter (node_id) VALUES(NEW.node_id);	
		
	END IF;
        /*IF man_table IS NOT NULL THEN        
            EXECUTE v_sql;
        END IF;	
		*/
        --PERFORM audit_function(XXX,XXX); 
        RETURN NEW;



-- UPDATE


    ELSIF TG_OP = 'UPDATE' THEN


-- EPA UPDATE
        IF (NEW.epa_type <> OLD.epa_type) THEN    
         
            IF (OLD.epa_type = 'JUNCTION') THEN
                inp_table:= 'inp_junction';            
            ELSIF (OLD.epa_type = 'TANK') THEN
                inp_table:= 'inp_tank';                
            ELSIF (OLD.epa_type = 'RESERVOIR') THEN
                inp_table:= 'inp_reservoir';    
            ELSIF (OLD.epa_type = 'SHORTPIPE') THEN
                inp_table:= 'inp_shortpipe';    
            ELSIF (OLD.epa_type = 'VALVE') THEN
                inp_table:= 'inp_valve';    
            ELSIF (OLD.epa_type = 'PUMP') THEN
                inp_table:= 'inp_pump';  
            END IF;
            IF inp_table IS NOT NULL THEN
                v_sql:= 'DELETE FROM '||inp_table||' WHERE node_id = '||quote_literal(OLD.node_id);
                EXECUTE v_sql;
            END IF;

            IF (NEW.epa_type = 'JUNCTION') THEN
                inp_table:= 'inp_junction';   
            ELSIF (NEW.epa_type = 'TANK') THEN
                inp_table:= 'inp_tank';     
            ELSIF (NEW.epa_type = 'RESERVOIR') THEN
                inp_table:= 'inp_reservoir';  
            ELSIF (NEW.epa_type = 'SHORTPIPE') THEN
                inp_table:= 'inp_shortpipe';    
            ELSIF (NEW.epa_type = 'VALVE') THEN
                inp_table:= 'inp_valve';    
            ELSIF (NEW.epa_type = 'PUMP') THEN
                inp_table:= 'inp_pump';  
            END IF;
            IF inp_table IS NOT NULL THEN
                v_sql:= 'INSERT INTO '||inp_table||' (node_id) VALUES ('||quote_literal(NEW.node_id)||')';
                EXECUTE v_sql;
            END IF;
        END IF;

	-- Node catalog restriction
        IF (OLD.nodecat_id IS NOT NULL) AND (NEW.nodecat_id <> OLD.nodecat_id) AND (NEW.node_type=OLD.node_type) THEN  
            old_nodetype:= (SELECT node_type.type FROM node_type JOIN cat_node ON (((node_type.id) = (cat_node.nodetype_id))) WHERE cat_node.id=OLD.nodecat_id);
            new_nodetype:= (SELECT node_type.type FROM node_type JOIN cat_node ON (((node_type.id) = (cat_node.nodetype_id))) WHERE cat_node.id=NEW.nodecat_id);
            IF (quote_literal(old_nodetype) <> quote_literal(new_nodetype)) THEN
                RETURN audit_function(135,430);  
            END IF;
        END IF;


    -- UPDATE management values
		IF (NEW.node_type <> OLD.node_type) THEN 
			new_man_table:= (SELECT node_type.man_table FROM node_type WHERE node_type.id = NEW.node_type);
			old_man_table:= (SELECT node_type.man_table FROM node_type WHERE node_type.id = OLD.node_type);
			IF new_man_table IS NOT NULL THEN
				v_sql:= 'DELETE FROM '||old_man_table||' WHERE node_id= '||quote_literal(OLD.node_id);
				EXECUTE v_sql;
				v_sql2:= 'INSERT INTO '||new_man_table||' (node_id) VALUES ('||quote_literal(NEW.node_id)||')';
				EXECUTE v_sql2;
			END IF;
		END IF;


-- MANAGEMENT UPDATE
    IF man_table ='man_junction' THEN
		UPDATE node 
		SET node_id=NEW.node_id, elevation=NEW.junction_elevation, "depth"=NEW."junction_depth", node_type=NEW.node_type, nodecat_id=NEW.nodecat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, 
		"state"=NEW."junction_state", annotation=NEW.junction_annotation, "observ"=NEW."junction_observ", "comment"=NEW."junction_comment", dma_id=NEW.dma_id, soilcat_id=NEW.junction_soilcat_id, 
		category_type=NEW.junction_category_type, fluid_type=NEW.junction_fluid_type, location_type=NEW.junction_location_type, workcat_id=NEW.junction_workcat_id, buildercat_id=NEW.junction_buildercat_id,
		builtdate=NEW.junction_builtdate, ownercat_id=NEW.junction_ownercat_id, adress_01=NEW.junction_adress_01, adress_02=NEW.junction_adress_02, adress_03=NEW.junction_adress_03, descript=NEW.junction_descript,
		rotation=NEW.junction_rotation, link=NEW.junction_link, verified=NEW.verified, the_geom=NEW.the_geom, workcat_id_end=NEW.junction_workcat_id_end,  undelete=NEW.undelete, label_x=NEW.junction_label_x, 
		label_y=NEW.junction_label_y, label_rotation=NEW.junction_label_rotation
		WHERE node_id = OLD.node_id;
		
		UPDATE man_junction 
		SET node_id=NEW.node_id
		WHERE node_id=OLD.node_id;

	ELSIF man_table ='man_tank' THEN
		UPDATE node 
		SET node_id=NEW.node_id, elevation=NEW.tank_elevation, "depth"=NEW."tank_depth", node_type=NEW.node_type, nodecat_id=NEW.nodecat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, "state"=NEW."tank_state", 
		annotation=NEW.tank_annotation, "observ"=NEW."tank_observ", "comment"=NEW."tank_comment", dma_id=NEW.dma_id, soilcat_id=NEW.tank_soilcat_id, category_type=NEW.tank_category_type, fluid_type=NEW.tank_fluid_type,
		location_type=NEW.tank_location_type, workcat_id=NEW.tank_workcat_id, buildercat_id=NEW.tank_buildercat_id, builtdate=NEW.tank_builtdate, ownercat_id=NEW.tank_ownercat_id, adress_01=NEW.tank_adress_01, 
		adress_02=NEW.tank_adress_02, adress_03=NEW.tank_adress_03, descript=NEW.tank_descript,rotation=NEW.tank_rotation, link=NEW.tank_link, verified=NEW.verified, the_geom=NEW.the_geom, 
		workcat_id_end=NEW.tank_workcat_id_end, undelete=NEW.undelete, label_x=NEW.tank_label_x, label_y=NEW.tank_label_y, label_rotation=NEW.tank_label_rotation
		WHERE node_id = OLD.node_id;

		UPDATE man_tank 
		SET node_id=NEW.node_id, vmax=NEW.tank_vmax, chlorination=NEW.tank_chlorination, function=NEW.tank_function, area=NEW.tank_area
		WHERE node_id=OLD.node_id;

	ELSIF man_table ='man_pump' THEN
		UPDATE node
		SET node_id=NEW.node_id, elevation=NEW.pump_elevation, "depth"=NEW."pump_depth", node_type=NEW.node_type, nodecat_id=NEW.nodecat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, "state"=NEW."pump_state",
		annotation=NEW.pump_annotation, "observ"=NEW."pump_observ", "comment"=NEW."pump_comment", dma_id=NEW.dma_id, soilcat_id=NEW.pump_soilcat_id, category_type=NEW.pump_category_type, fluid_type=NEW.pump_fluid_type,
		location_type=NEW.pump_location_type, workcat_id=NEW.pump_workcat_id, buildercat_id=NEW.pump_buildercat_id, builtdate=NEW.pump_builtdate, ownercat_id=NEW.pump_ownercat_id, adress_01=NEW.pump_adress_01,
		adress_02=NEW.pump_adress_02, adress_03=NEW.pump_adress_03, descript=NEW.pump_descript,rotation=NEW.pump_rotation, link=NEW.pump_link, verified=NEW.verified, the_geom=NEW.the_geom, 
		workcat_id_end=NEW.pump_workcat_id_end, undelete=NEW.undelete, label_x=NEW.pump_label_x, label_y=NEW.pump_label_y, label_rotation=NEW.pump_label_rotation
		WHERE node_id = OLD.node_id;
	
		UPDATE man_pump 
		SET node_id=NEW.node_id
		WHERE node_id=OLD.node_id;

	ELSIF man_table ='man_manhole' THEN
		UPDATE node
		SET node_id=NEW.node_id, elevation=NEW.manhole_elevation, "depth"=NEW."manhole_depth", node_type=NEW.node_type, nodecat_id=NEW.nodecat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, 
		"state"=NEW."manhole_state", annotation=NEW.manhole_annotation, "observ"=NEW."manhole_observ", "comment"=NEW."manhole_comment", dma_id=NEW.dma_id, soilcat_id=NEW.manhole_soilcat_id, 
		category_type=NEW.manhole_category_type, fluid_type=NEW.manhole_fluid_type, location_type=NEW.manhole_location_type, workcat_id=NEW.manhole_workcat_id, buildercat_id=NEW.manhole_buildercat_id, 
		builtdate=NEW.manhole_builtdate, ownercat_id=NEW.manhole_ownercat_id, adress_01=NEW.manhole_adress_01, adress_02=NEW.manhole_adress_02, adress_03=NEW.manhole_adress_03, descript=NEW.manhole_descript,
		rotation=NEW.manhole_rotation, link=NEW.manhole_link, verified=NEW.verified, the_geom=NEW.the_geom, workcat_id_end=NEW.manhole_workcat_id_end, undelete=NEW.undelete, label_x=NEW.manhole_label_x, 
		label_y=NEW.manhole_label_y, label_rotation=NEW.manhole_label_rotation
		WHERE node_id = OLD.node_id;
		
		UPDATE man_manhole 
		SET node_id=NEW.node_id
		WHERE node_id=OLD.node_id;

	ELSIF man_table ='man_hydrant' THEN
		UPDATE node
		SET node_id=NEW.node_id, elevation=NEW.hydrant_elevation, "depth"=NEW."hydrant_depth", node_type=NEW.node_type, nodecat_id=NEW.nodecat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, 
		"state"=NEW."hydrant_state", annotation=NEW.hydrant_annotation, "observ"=NEW."hydrant_observ", "comment"=NEW."hydrant_comment", dma_id=NEW.dma_id, soilcat_id=NEW.hydrant_soilcat_id, 
		category_type=NEW.hydrant_category_type, fluid_type=NEW.hydrant_fluid_type, location_type=NEW.hydrant_location_type, workcat_id=NEW.hydrant_workcat_id, buildercat_id=NEW.hydrant_buildercat_id,
		builtdate=NEW.hydrant_builtdate, ownercat_id=NEW.hydrant_ownercat_id, adress_01=NEW.hydrant_adress_01, adress_02=NEW.hydrant_adress_02, adress_03=NEW.hydrant_adress_03, descript=NEW.hydrant_descript,
		rotation=NEW.hydrant_rotation, link=NEW.hydrant_link, verified=NEW.verified, the_geom=NEW.the_geom, workcat_id_end=NEW.hydrant_workcat_id_end, undelete=NEW.undelete, label_x=NEW.hydrant_label_x, 
		label_y=NEW.hydrant_label_y, label_rotation=NEW.hydrant_label_rotation
		WHERE node_id = OLD.node_id;
		
		UPDATE man_hydrant 
		SET node_id=NEW.node_id, communication=NEW.hydrant_communication, valve=NEW.hydrant_valve, valve_diam=NEW.hydrant_valve_diam, 
		distance_left=NEW.hydrant_distance_left, distance_right=NEW.hydrant_distance_right, distance_perpendicular=NEW.hydrant_distance_perpendicular, 
		location=NEW.hydrant_location, location_sign=NEW.hydrant_location_sign
		WHERE node_id=OLD.node_id;			

	ELSIF man_table ='man_source' THEN
		UPDATE node
		SET node_id=NEW.node_id, elevation=NEW.source_elevation, "depth"=NEW."source_depth", node_type=NEW.node_type, nodecat_id=NEW.nodecat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, 
		"state"=NEW."source_state", annotation=NEW.source_annotation, "observ"=NEW."source_observ", "comment"=NEW."source_comment", dma_id=NEW.dma_id, soilcat_id=NEW.source_soilcat_id, 
		category_type=NEW.source_category_type, fluid_type=NEW.source_fluid_type, location_type=NEW.source_location_type, workcat_id=NEW.source_workcat_id, buildercat_id=NEW.source_buildercat_id, 
		builtdate=NEW.source_builtdate, ownercat_id=NEW.source_ownercat_id, adress_01=NEW.source_adress_01, adress_02=NEW.source_adress_02, adress_03=NEW.source_adress_03, descript=NEW.source_descript,
		rotation=NEW.source_rotation, link=NEW.source_link, verified=NEW.verified, the_geom=NEW.the_geom, workcat_id_end=NEW.source_workcat_id_end,undelete=NEW.undelete, label_x=NEW.source_label_x, 
		label_y=NEW.source_label_y, label_rotation=NEW.source_label_rotation
		WHERE node_id = OLD.node_id;
		
		UPDATE man_source 
		SET node_id=NEW.node_id
		WHERE node_id=OLD.node_id;

	ELSIF man_table ='man_meter' THEN
		UPDATE node
		SET node_id=NEW.node_id, elevation=NEW.meter_elevation, "depth"=NEW."meter_depth", node_type=NEW.node_type, nodecat_id=NEW.nodecat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, "state"=NEW."meter_state", 
		annotation=NEW.meter_annotation, "observ"=NEW."meter_observ", "comment"=NEW."meter_comment", dma_id=NEW.dma_id, soilcat_id=NEW.meter_soilcat_id, category_type=NEW.meter_category_type, 
		fluid_type=NEW.meter_fluid_type, location_type=NEW.meter_location_type, workcat_id=NEW.meter_workcat_id, buildercat_id=NEW.meter_buildercat_id, builtdate=NEW.meter_builtdate, ownercat_id=NEW.meter_ownercat_id,
		adress_01=NEW.meter_adress_01, adress_02=NEW.meter_adress_02, adress_03=NEW.meter_adress_03, descript=NEW.meter_descript,rotation=NEW.meter_rotation, link=NEW.meter_link, verified=NEW.verified, 
		the_geom=NEW.the_geom, workcat_id_end=NEW.meter_workcat_id_end,undelete=NEW.undelete, label_x=NEW.meter_label_x, label_y=NEW.meter_label_y, label_rotation=NEW.meter_label_rotation
		WHERE node_id = OLD.node_id;
		
		UPDATE man_meter 
		SET node_id=NEW.node_id
		WHERE node_id=OLD.node_id;

	ELSIF man_table ='man_waterwell' THEN
		UPDATE node
		SET node_id=NEW.node_id, elevation=NEW.waterwell_elevation, "depth"=NEW."waterwell_depth", node_type=NEW.node_type, nodecat_id=NEW.nodecat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, 
		"state"=NEW."waterwell_state", annotation=NEW.waterwell_annotation, "observ"=NEW."waterwell_observ", "comment"=NEW."waterwell_comment", dma_id=NEW.dma_id, soilcat_id=NEW.waterwell_soilcat_id, 
		category_type=NEW.waterwell_category_type, fluid_type=NEW.waterwell_fluid_type, location_type=NEW.waterwell_location_type, workcat_id=NEW.waterwell_workcat_id, buildercat_id=NEW.waterwell_buildercat_id,
		builtdate=NEW.waterwell_builtdate, ownercat_id=NEW.waterwell_ownercat_id, adress_01=NEW.waterwell_adress_01, adress_02=NEW.waterwell_adress_02, adress_03=NEW.waterwell_adress_03, 
		descript=NEW.waterwell_descript,rotation=NEW.waterwell_rotation, link=NEW.waterwell_link, verified=NEW.verified, the_geom=NEW.the_geom, workcat_id_end=NEW.waterwell_workcat_id_end, 
		undelete=NEW.undelete, label_x=NEW.waterwell_label_x, label_y=NEW.waterwell_label_y, label_rotation=NEW.waterwell_label_rotation
		WHERE node_id = OLD.node_id;
	
		UPDATE man_waterwell 
		SET node_id=NEW.node_id
		WHERE node_id=OLD.node_id;

	ELSIF man_table ='man_reduction' THEN
		UPDATE node
		SET node_id=NEW.node_id, elevation=NEW.reduction_elevation, "depth"=NEW."reduction_depth", node_type=NEW.node_type, nodecat_id=NEW.nodecat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, 
		"state"=NEW."reduction_state", annotation=NEW.reduction_annotation, "observ"=NEW."reduction_observ", "comment"=NEW."reduction_comment", dma_id=NEW.dma_id, soilcat_id=NEW.reduction_soilcat_id, 
		category_type=NEW.reduction_category_type, fluid_type=NEW.reduction_fluid_type, location_type=NEW.reduction_location_type, workcat_id=NEW.reduction_workcat_id, buildercat_id=NEW.reduction_buildercat_id, 
		builtdate=NEW.reduction_builtdate, ownercat_id=NEW.reduction_ownercat_id, adress_01=NEW.reduction_adress_01, adress_02=NEW.reduction_adress_02, adress_03=NEW.reduction_adress_03, 
		descript=NEW.reduction_descript,rotation=NEW.reduction_rotation, link=NEW.reduction_link, verified=NEW.verified, the_geom=NEW.the_geom, workcat_id_end=NEW.reduction_workcat_id_end, 
		undelete=NEW.undelete, label_x=NEW.reduction_label_x, label_y=NEW.reduction_label_y, label_rotation=NEW.reduction_label_rotation
		WHERE node_id = OLD.node_id;
		
		UPDATE man_reduction 
		SET node_id=NEW.node_id, diam_initial=NEW.reduction_diam_initial, diam_final=NEW.reduction_diam_final
		WHERE node_id=OLD.node_id;

	ELSIF man_table ='man_valve' THEN
		UPDATE node
		SET node_id=NEW.node_id, elevation=NEW.valve_elevation, "depth"=NEW."valve_depth", node_type=NEW.node_type, nodecat_id=NEW.nodecat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, 
		"state"=NEW."valve_state", annotation=NEW.valve_annotation, "observ"=NEW."valve_observ", "comment"=NEW."valve_comment", dma_id=NEW.dma_id, soilcat_id=NEW.valve_soilcat_id, 
		category_type=NEW.valve_category_type, fluid_type=NEW.valve_fluid_type, location_type=NEW.valve_location_type, workcat_id=NEW.valve_workcat_id, buildercat_id=NEW.valve_buildercat_id, 
		builtdate=NEW.valve_builtdate, ownercat_id=NEW.valve_ownercat_id, adress_01=NEW.valve_adress_01, adress_02=NEW.valve_adress_02, adress_03=NEW.valve_adress_03, descript=NEW.valve_descript,
		rotation=NEW.valve_rotation, link=NEW.valve_link, verified=NEW.verified, the_geom=NEW.the_geom, workcat_id_end=NEW.valve_workcat_id_end, undelete=NEW.undelete, label_x=NEW.valve_label_x, 
		label_y=NEW.valve_label_y, label_rotation=NEW.valve_label_rotation
		WHERE node_id = OLD.node_id;
		
		UPDATE man_valve 
		SET node_id=NEW.node_id, type=NEW.valve_type, opened=NEW.valve_opened, acessibility=NEW.valve_acessibility, broken=NEW.valve_broken, mincut_anl=NEW.valve_mincut_anl, hydraulic_anl=NEW.valve_hydraulic_anl,
		burried=NEW.valve_burried, irrigation_indicator=NEW.valve_irrigation_indicator, pression_entry=NEW.valve_pression_entry, pression_exit=NEW.valve_pression_exit, depth_valveshaft=NEW.valve_depth_valveshaft, 
		regulator_situation=NEW.valve_regulator_situation, regulator_location=NEW.valve_regulator_location, regulator_observ=NEW.valve_regulator_observ, lin_meters=NEW.valve_lin_meters, valve=NEW.valve_valve, 
		valve_diam=NEW.valve_valve_diam, exit_type=NEW.valve_exit_type, exit_code=NEW.valve_exit_code, drive_type=NEW.valve_drive_type, location=NEW.valve_location
		WHERE node_id=OLD.node_id;	
	END IF;

            
        PERFORM audit_function(2,430); 
        RETURN NEW;
    

-- DELETE

    ELSIF TG_OP = 'DELETE' THEN
        DELETE FROM node WHERE node_id = OLD.node_id;
        PERFORM audit_function(3,430); 
        RETURN NULL;
   
    END IF;
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


DROP TRIGGER IF EXISTS gw_trg_edit_man_hydrant ON "SCHEMA_NAME".v_edit_man_hydrant;
CREATE TRIGGER gw_trg_edit_man_hydrant INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_hydrant FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_hydrant');

DROP TRIGGER IF EXISTS gw_trg_edit_man_pump ON "SCHEMA_NAME".v_edit_man_pump;
CREATE TRIGGER gw_trg_edit_man_pump INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_pump FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_pump');

DROP TRIGGER IF EXISTS gw_trg_edit_man_manhole ON "SCHEMA_NAME".v_edit_man_manhole;
CREATE TRIGGER gw_trg_edit_man_manhole INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_manhole FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_manhole');

DROP TRIGGER IF EXISTS gw_trg_edit_man_source ON "SCHEMA_NAME".v_edit_man_source;
CREATE TRIGGER gw_trg_edit_man_source INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_source FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_source');

DROP TRIGGER IF EXISTS gw_trg_edit_man_meter ON "SCHEMA_NAME".v_edit_man_meter;
CREATE TRIGGER gw_trg_edit_man_meter INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_meter FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_meter');

DROP TRIGGER IF EXISTS gw_trg_edit_man_tank ON "SCHEMA_NAME".v_edit_man_tank;
CREATE TRIGGER gw_trg_edit_man_tank INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_tank FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_tank');

DROP TRIGGER IF EXISTS gw_trg_edit_man_junction ON "SCHEMA_NAME".v_edit_man_junction;
CREATE TRIGGER gw_trg_edit_man_junction INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_junction FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_junction');

DROP TRIGGER IF EXISTS gw_trg_edit_man_waterwell ON "SCHEMA_NAME".v_edit_man_waterwell;
CREATE TRIGGER gw_trg_edit_man_waterwell INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_waterwell FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_waterwell');

DROP TRIGGER IF EXISTS gw_trg_edit_man_reduction ON "SCHEMA_NAME".v_edit_man_reduction;
CREATE TRIGGER gw_trg_edit_man_reduction INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_reduction FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_reduction');

DROP TRIGGER IF EXISTS gw_trg_edit_man_valve ON "SCHEMA_NAME".v_edit_man_valve;
CREATE TRIGGER gw_trg_edit_man_valve INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_valve FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_valve');

DROP TRIGGER IF EXISTS gw_trg_edit_man_filter ON "SCHEMA_NAME".v_edit_man_filter;
CREATE TRIGGER gw_trg_edit_man_filter INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_filter FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_filter');