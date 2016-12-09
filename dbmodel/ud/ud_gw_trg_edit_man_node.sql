/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


   

-- Function: "SCHEMA_NAME".gw_trg_edit_man_node()

-- DROP FUNCTION "SCHEMA_NAME".gw_trg_edit_man_node();

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_man_node()
  RETURNS trigger AS
$BODY$
DECLARE 
    inp_table varchar;
    man_table varchar;
    new_man_table varchar;
    old_man_table varchar;
    v_sql varchar;
    v_sql2 varchar;
    old_nodetype varchar;
    new_nodetype varchar;
    man_table_2 varchar;
	rec Record;


BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
    man_table:= TG_ARGV[0];
    man_table_2:=man_table;

	--Get data from config table
	SELECT * INTO rec FROM config;	
	
    -- Control insertions ID
    IF TG_OP = 'INSERT' THEN

        -- Node ID
        IF (NEW.node_id IS NULL) THEN
            NEW.node_id:= (SELECT nextval('node_id_seq'));
        END IF;

      
        -- Node type
        IF (NEW.node_type IS NULL) THEN
            IF ((SELECT COUNT(*) FROM node_type WHERE node_type.man_table=man_table_2) = 0) THEN
                RETURN audit_function(105,830);  
            END IF;
            NEW.node_type:= (SELECT id FROM node_type WHERE node_type.man_table=man_table_2 LIMIT 1);
        END IF;

         -- Epa type
        IF (NEW.epa_type IS NULL) THEN
			NEW.epa_type:= (SELECT epa_default FROM node_type WHERE node_type.id=NEW.node_type)::text;   
		END IF;

        -- Node Catalog ID
        IF (NEW.nodecat_id IS NULL) THEN
            IF ((SELECT COUNT(*) FROM cat_node) = 0) THEN
                RETURN audit_function(110,830);  
            END IF;      
        END IF;

        -- Sector ID
        IF (NEW.sector_id IS NULL) THEN
            IF ((SELECT COUNT(*) FROM sector) = 0) THEN
                RETURN audit_function(115,830);  
            END IF;
            NEW.sector_id:= (SELECT sector_id FROM sector WHERE ST_DWithin(NEW.the_geom, sector.the_geom,0.001) LIMIT 1);
            IF (NEW.sector_id IS NULL) THEN
                RETURN audit_function(120,830);          
            END IF;            
        END IF;
        
        -- Dma ID
        IF (NEW.dma_id IS NULL) THEN
            IF ((SELECT COUNT(*) FROM dma) = 0) THEN
                RETURN audit_function(125,830);  
            END IF;
            NEW.dma_id := (SELECT dma_id FROM dma WHERE ST_DWithin(NEW.the_geom, dma.the_geom,0.001) LIMIT 1);
            IF (NEW.dma_id IS NULL) THEN
                RETURN audit_function(130,830);  
            END IF;            
        END IF;
		
		
		
		IF man_table='man_junction' THEN
			INSERT INTO node (node_id,top_elev,ymax,sander,node_type,nodecat_id,epa_type,sector_id,"state",annotation,observ,"comment",dma_id,soilcat_id,category_type,fluid_type,location_type,workcat_id,buildercat_id,
			builtdate,ownercat_id,adress_01,adress_02,adress_03,descript,est_top_elev,est_ymax,rotation,link,verified,workcat_id_end,undelete,label_x,label_y,label_rotation,the_geom)
			VALUES (NEW.node_id,NEW.junction_top_elev,NEW.junction_ymax,NEW.junction_sander,NEW.node_type,NEW.nodecat_id,NEW.epa_type,NEW.sector_id,NEW.junction_state,NEW.junction_annotation,NEW.junction_observ,
			NEW.junction_comment,NEW.dma_id,NEW.junction_soilcat_id,NEW.junction_category_type,NEW.junction_fluid_type,NEW.junction_location_type,NEW.junction_workcat_id,NEW.junction_buildercat_id,NEW.junction_builtdate,
			NEW.junction_ownercat_id,NEW.junction_adress_01,NEW.junction_adress_02,NEW.junction_adress_03,NEW.junction_descript,NEW.junction_est_top_elev,NEW.junction_est_ymax,NEW.junction_rotation,NEW.junction_link,
			NEW.verified,NEW.junction_workcat_id_end,NEW.undelete,NEW.junction_label_x,NEW.junction_label_y,NEW.junction_label_rotation,NEW.the_geom);	

			INSERT INTO man_junction (node_id,add_info) VALUES (NEW.node_id,NEW.junction_add_info);

			        
		ELSIF man_table='man_outfall' THEN
			INSERT INTO node (node_id,top_elev,ymax,sander,node_type,nodecat_id,epa_type,sector_id,"state",annotation,observ,"comment",dma_id,soilcat_id,category_type,fluid_type,location_type,workcat_id,buildercat_id,
			builtdate,ownercat_id,	adress_01,adress_02,adress_03,descript,est_top_elev,est_ymax,rotation,link,verified,workcat_id_end,undelete,label_x,label_y,label_rotation,the_geom) 
			VALUES (NEW.node_id,NEW.outfall_top_elev,NEW.outfall_ymax,NEW.outfall_sander,NEW.node_type,NEW.nodecat_id,NEW.epa_type,NEW.sector_id,NEW.outfall_state,NEW.outfall_annotation,NEW.outfall_observ,
			NEW.outfall_comment,NEW.dma_id,NEW.outfall_soilcat_id,NEW.outfall_category_type,NEW.outfall_fluid_type,NEW.outfall_location_type,NEW.outfall_workcat_id,NEW.outfall_buildercat_id,NEW.outfall_builtdate,
			NEW.outfall_ownercat_id,NEW.outfall_adress_01,NEW.outfall_adress_02,NEW.outfall_adress_03,NEW.outfall_descript,NEW.outfall_est_top_elev,NEW.outfall_est_ymax,NEW.outfall_rotation,NEW.outfall_link,
			NEW.verified,NEW.outfall_workcat_id_end,NEW.undelete,NEW.outfall_label_x,NEW.outfall_label_y,NEW.outfall_label_rotation,NEW.the_geom);

			INSERT INTO man_outfall (node_id,add_info,outfall_name) VALUES (NEW.node_id,NEW.outfall_add_info,NEW.outfall_name);
        
		ELSIF man_table='man_valve' THEN
			INSERT INTO node (node_id,top_elev,ymax,sander,node_type,nodecat_id,epa_type,sector_id,"state",annotation,observ,"comment",dma_id,soilcat_id,category_type,fluid_type,location_type,workcat_id,buildercat_id,
			builtdate,ownercat_id,	adress_01,adress_02,adress_03,descript,est_top_elev,est_ymax,rotation,link,verified,workcat_id_end,undelete,label_x,label_y,label_rotation,the_geom) 
			VALUES (NEW.node_id,NEW.valve_top_elev,NEW.valve_ymax,NEW.valve_sander,NEW.node_type,NEW.nodecat_id,NEW.epa_type,NEW.sector_id,NEW.valve_state,NEW.valve_annotation,NEW.valve_observ,NEW.valve_comment,NEW.dma_id,
			NEW.valve_soilcat_id,NEW.valve_category_type,NEW.valve_fluid_type,NEW.valve_location_type,NEW.valve_workcat_id,NEW.valve_buildercat_id,NEW.valve_builtdate,NEW.valve_ownercat_id,NEW.valve_adress_01,
			NEW.valve_adress_02,NEW.valve_adress_03,NEW.valve_descript,NEW.valve_est_top_elev,NEW.valve_est_ymax,NEW.valve_rotation,NEW.valve_link,NEW.verified,NEW.valve_workcat_id_end,NEW.undelete,NEW.valve_label_x,
			NEW.valve_label_y,NEW.valve_label_rotation,NEW.the_geom);

			INSERT INTO man_valve (node_id,add_info,valve_name) VALUES (NEW.node_id,NEW.valve_add_info,NEW.valve_name);	
		
		ELSIF man_table='man_storage' THEN
			INSERT INTO node (node_id,top_elev,ymax,sander,node_type,nodecat_id,epa_type,sector_id,"state",annotation,observ,"comment",dma_id,soilcat_id,category_type,fluid_type,location_type,workcat_id,buildercat_id,
			builtdate,ownercat_id,	adress_01,adress_02,adress_03,descript,est_top_elev,est_ymax,rotation,link,verified,workcat_id_end,undelete,label_x,label_y,label_rotation,the_geom) 
			VALUES (NEW.node_id,NEW.storage_top_elev,NEW.storage_ymax,NEW.storage_sander,NEW.node_type,NEW.nodecat_id,NEW.epa_type,NEW.sector_id,NEW.storage_state,NEW.storage_annotation,NEW.storage_observ,
			NEW.storage_comment,NEW.dma_id,NEW.storage_soilcat_id,NEW.storage_category_type,NEW.storage_fluid_type,NEW.storage_location_type,NEW.storage_workcat_id,NEW.storage_buildercat_id,NEW.storage_builtdate,
			NEW.storage_ownercat_id,NEW.storage_adress_01,NEW.storage_adress_02,NEW.storage_adress_03,NEW.storage_descript,NEW.storage_est_top_elev,NEW.storage_est_ymax,NEW.storage_rotation,NEW.storage_link,
			NEW.verified,NEW.storage_workcat_id_end,NEW.undelete,NEW.storage_label_x,NEW.storage_label_y,NEW.storage_label_rotation,NEW.the_geom);
			
			IF (rec.insert_double_geometry IS TRUE) THEN
				IF (NEW.pol_id IS NULL) THEN
					NEW.pol_id:= (SELECT nextval('pol_id_seq'));
				END IF;
				
				INSERT INTO man_storage (node_id,pol_id,add_info,total_volume,util_volume,min_height,total_height,total_length,total_width,storage_name) VALUES(NEW.node_id, NEW.pol_id,NEW.storage_add_info,
				NEW.storage_total_volume,NEW.storage_util_volume,NEW.storage_min_height,NEW.storage_total_height,NEW.storage_total_length,NEW.storage_total_width,NEW.storage_name);
				INSERT INTO polygon(pol_id,the_geom) VALUES (NEW.pol_id,(SELECT ST_Envelope(ST_Buffer(node.the_geom,rec.buffer_value)) from "SCHEMA_NAME".node where node_id=NEW.node_id));
			
			ELSE
				INSERT INTO man_storage (node_id,pol_id,add_info,total_volume,util_volume,min_height,total_height,total_length,total_width,storage_name) VALUES(NEW.node_id, NEW.pol_id,NEW.storage_add_info,
				NEW.storage_total_volume,NEW.storage_util_volume,NEW.storage_min_height,NEW.storage_total_height,NEW.storage_total_length,NEW.storage_total_width,NEW.storage_name);
			END IF;
	
		ELSIF man_table='man_netgully' THEN
			INSERT INTO node (node_id,top_elev,ymax,sander,node_type,nodecat_id,epa_type,sector_id,"state",annotation,observ,"comment",dma_id,soilcat_id,category_type,fluid_type,location_type,workcat_id,buildercat_id,
			builtdate,ownercat_id,	adress_01,adress_02,adress_03,descript,est_top_elev,est_ymax,rotation,link,verified,workcat_id_end,undelete,label_x,label_y,label_rotation,the_geom) 
			VALUES (NEW.node_id,NEW.netgully_top_elev,NEW.netgully_ymax,NEW.netgully_sander,NEW.node_type,NEW.nodecat_id,NEW.epa_type,NEW.sector_id,NEW.netgully_state,NEW.netgully_annotation,NEW.netgully_observ,
			NEW.netgully_comment,NEW.dma_id,NEW.netgully_soilcat_id,NEW.netgully_category_type,NEW.netgully_fluid_type,NEW.netgully_location_type,NEW.netgully_workcat_id,NEW.netgully_buildercat_id,NEW.netgully_builtdate,
			NEW.netgully_ownercat_id,NEW.netgully_adress_01,NEW.netgully_adress_02,NEW.netgully_adress_03,NEW.netgully_descript,NEW.netgully_est_top_elev,NEW.netgully_est_ymax,NEW.netgully_rotation,NEW.netgully_link,
			NEW.verified,NEW.netgully_workcat_id_end,NEW.undelete,NEW.netgully_label_x,NEW.netgully_label_y,NEW.netgully_label_rotation,NEW.the_geom);
				
			IF (rec.insert_double_geometry IS TRUE) THEN
				IF (NEW.pol_id IS NULL) THEN
					NEW.pol_id:= (SELECT nextval('pol_id_seq'));
				END IF;
				
				INSERT INTO man_netgully (node_id,pol_id,add_info) VALUES(NEW.node_id, NEW.pol_id,NEW.netgully_add_info);
				INSERT INTO polygon(pol_id,the_geom) VALUES (NEW.pol_id,(SELECT ST_Envelope(ST_Buffer(node.the_geom,rec.buffer_value)) from "SCHEMA_NAME".node where node_id=NEW.node_id));
			
			ELSE
				INSERT INTO man_netgully (node_id,add_info) VALUES(NEW.node_id,NEW.netgully_add_info);
			END IF;	

			
		ELSIF man_table='man_storage_pol' THEN
			INSERT INTO node (node_id,top_elev,ymax,sander,node_type,nodecat_id,epa_type,sector_id,"state",annotation,observ,"comment",dma_id,soilcat_id,category_type,fluid_type,location_type,workcat_id,buildercat_id,
			builtdate,ownercat_id,	adress_01,adress_02,adress_03,descript,est_top_elev,est_ymax,rotation,link,verified,workcat_id_end,undelete,label_x,label_y,label_rotation)
			VALUES (NEW.node_id,NEW.storage_top_elev,NEW.storage_ymax,NEW.storage_sander,NEW.node_type,NEW.nodecat_id,NEW.epa_type,NEW.sector_id,NEW.storage_state,NEW.storage_annotation,NEW.storage_observ,
			NEW.storage_comment,NEW.dma_id,NEW.storage_soilcat_id,NEW.storage_category_type,NEW.storage_fluid_type,NEW.storage_location_type,NEW.storage_workcat_id,NEW.storage_buildercat_id,NEW.storage_builtdate,
			NEW.storage_ownercat_id,NEW.storage_adress_01,NEW.storage_adress_02,NEW.storage_adress_03,NEW.storage_descript,NEW.storage_est_top_elev,NEW.storage_est_ymax,NEW.storage_rotation,NEW.storage_link,NEW.verified,
			NEW.storage_workcat_id_end,NEW.undelete,NEW.storage_label_x,NEW.storage_label_y,NEW.storage_label_rotation);
			
			
			IF (rec.insert_double_geometry IS TRUE) THEN
				IF (NEW.pol_id IS NULL) THEN
					NEW.pol_id:= (SELECT nextval('pol_id_seq'));
				END IF;
				
				INSERT INTO man_storage (node_id,pol_id,add_info,total_volume,util_volume,min_height,total_height,total_length,total_width,storage_name) VALUES(NEW.node_id, NEW.pol_id,NEW.storage_add_info,
				NEW.storage_total_volume,NEW.storage_util_volume,NEW.storage_min_height,NEW.storage_total_height,NEW.storage_total_length,NEW.storage_total_width,NEW.storage_name);
				INSERT INTO polygon(pol_id,the_geom) VALUES (NEW.pol_id,NEW.the_geom);
				UPDATE node SET the_geom =(SELECT ST_Centroid(polygon.the_geom) FROM "SCHEMA_NAME".polygon where pol_id=NEW.pol_id) WHERE node_id=NEW.node_id;
			END IF;
			 
		ELSIF man_table='man_netgully_pol' THEN
			INSERT INTO node (node_id,top_elev,ymax,sander,node_type,nodecat_id,epa_type,sector_id,"state",annotation,observ,"comment",dma_id,soilcat_id,category_type,fluid_type,location_type,workcat_id,buildercat_id,
			builtdate,ownercat_id,	adress_01,adress_02,adress_03,descript,est_top_elev,est_ymax,rotation,link,verified,workcat_id_end,undelete,label_x,label_y,label_rotation) 
			VALUES (NEW.node_id,NEW.netgully_top_elev,NEW.netgully_ymax,NEW.netgully_sander,NEW.node_type,NEW.nodecat_id,NEW.epa_type,NEW.sector_id,NEW.netgully_state,NEW.netgully_annotation,NEW.netgully_observ,
			NEW.netgully_comment,NEW.dma_id,NEW.netgully_soilcat_id,NEW.netgully_category_type,NEW.netgully_fluid_type,NEW.netgully_location_type,NEW.netgully_workcat_id,NEW.netgully_buildercat_id,NEW.netgully_builtdate,
			NEW.netgully_ownercat_id,NEW.netgully_adress_01,NEW.netgully_adress_02,NEW.netgully_adress_03,NEW.netgully_descript,NEW.netgully_est_top_elev,NEW.netgully_est_ymax,NEW.netgully_rotation,NEW.netgully_link,
			NEW.verified,NEW.netgully_workcat_id_end,NEW.undelete,NEW.netgully_label_x,NEW.netgully_label_y,NEW.netgully_label_rotation);

			
			IF (rec.insert_double_geometry IS TRUE) THEN
				IF (NEW.pol_id IS NULL) THEN
					NEW.pol_id:= (SELECT nextval('pol_id_seq'));
				END IF;
				
				INSERT INTO man_netgully (node_id,pol_id,add_info) VALUES(NEW.node_id, NEW.pol_id,NEW.netgully_add_info);
				INSERT INTO polygon(pol_id,the_geom) VALUES (NEW.pol_id,NEW.the_geom);
				UPDATE node SET the_geom =(SELECT ST_Centroid(polygon.the_geom) FROM "SCHEMA_NAME".polygon where pol_id=NEW.pol_id) WHERE node_id=NEW.node_id;
				
			END IF;
			
		ELSIF man_table='man_chamber' THEN
			INSERT INTO node (node_id,top_elev,ymax,sander,node_type,nodecat_id,epa_type,sector_id,"state",annotation,observ,"comment",dma_id,soilcat_id,category_type,fluid_type,location_type,workcat_id,buildercat_id,
			builtdate,ownercat_id,	adress_01,adress_02,adress_03,descript,est_top_elev,est_ymax,rotation,link,verified,workcat_id_end,undelete,label_x,label_y,label_rotation,the_geom) 
			VALUES (NEW.node_id,NEW.chamber_top_elev,NEW.chamber_ymax,NEW.chamber_sander,NEW.node_type,NEW.nodecat_id,NEW.epa_type,NEW.sector_id,NEW.chamber_state,NEW.chamber_annotation,NEW.chamber_observ,
			NEW.chamber_comment,NEW.dma_id,NEW.chamber_soilcat_id,NEW.chamber_category_type,NEW.chamber_fluid_type,NEW.chamber_location_type,NEW.chamber_workcat_id,NEW.chamber_buildercat_id,NEW.chamber_builtdate,
			NEW.chamber_ownercat_id,NEW.chamber_adress_01,NEW.chamber_adress_02,NEW.chamber_adress_03,NEW.chamber_descript,NEW.chamber_est_top_elev,NEW.chamber_est_ymax,NEW.chamber_rotation,NEW.chamber_link,NEW.verified,
			NEW.chamber_workcat_id_end,NEW.undelete,NEW.chamber_label_x,NEW.chamber_label_y,NEW.chamber_label_rotation,NEW.the_geom);
					
			IF (rec.insert_double_geometry IS TRUE) THEN
				IF (NEW.pol_id IS NULL) THEN
					NEW.pol_id:= (SELECT nextval('pol_id_seq'));
				END IF;
				
				INSERT INTO man_chamber (node_id,add_info,pol_id,total_volume,total_height,total_length,total_width,chamber_name) VALUES (NEW.node_id,NEW.chamber_add_info,NEW.pol_id,NEW.chamber_total_volume,
				NEW.chamber_total_height,NEW.chamber_total_length,NEW.chamber_total_width,NEW.chamber_name);
				INSERT INTO polygon(pol_id,the_geom) VALUES (NEW.pol_id,(SELECT ST_Envelope(ST_Buffer(node.the_geom,rec.buffer_value)) from "SCHEMA_NAME".node where node_id=NEW.node_id));
			
			ELSE
				INSERT INTO man_chamber (node_id,add_info,pol_id,total_volume,total_height,total_length,total_width,chamber_name) VALUES (NEW.node_id,NEW.chamber_add_info,NEW.pol_id,NEW.chamber_total_volume,
				NEW.chamber_total_height,NEW.chamber_total_length,NEW.chamber_total_width,NEW.chamber_name);
			END IF;	
			
		ELSIF man_table='man_chamber_pol' THEN
			INSERT INTO node (node_id,top_elev,ymax,sander,node_type,nodecat_id,epa_type,sector_id,"state",annotation,observ,"comment",dma_id,soilcat_id,category_type,fluid_type,location_type,workcat_id,buildercat_id,
			builtdate,ownercat_id,	adress_01,adress_02,adress_03,descript,est_top_elev,est_ymax,rotation,link,verified,workcat_id_end,undelete,label_x,label_y,label_rotation) 
			VALUES (NEW.node_id,NEW.chamber_top_elev,NEW.chamber_ymax,NEW.chamber_sander,NEW.node_type,NEW.nodecat_id,NEW.epa_type,NEW.sector_id,NEW.chamber_state,NEW.chamber_annotation,NEW.chamber_observ,
			NEW.chamber_comment,NEW.dma_id,NEW.chamber_soilcat_id,NEW.chamber_category_type,NEW.chamber_fluid_type,NEW.chamber_location_type,NEW.chamber_workcat_id,NEW.chamber_buildercat_id,NEW.chamber_builtdate,
			NEW.chamber_ownercat_id,NEW.chamber_adress_01,NEW.chamber_adress_02,NEW.chamber_adress_03,NEW.chamber_descript,NEW.chamber_est_top_elev,NEW.chamber_est_ymax,NEW.chamber_rotation,NEW.chamber_link,
			NEW.verified,NEW.chamber_workcat_id_end,NEW.undelete,NEW.chamber_label_x,NEW.chamber_label_y,NEW.chamber_label_rotation);
			
			IF (rec.insert_double_geometry IS TRUE) THEN
				IF (NEW.pol_id IS NULL) THEN
					NEW.pol_id:= (SELECT nextval('pol_id_seq'));
				END IF;
				
				INSERT INTO man_chamber (node_id,add_info,pol_id,total_volume,total_height,total_length,total_width,chamber_name) VALUES (NEW.node_id,NEW.chamber_add_info,NEW.pol_id,NEW.chamber_total_volume,
				NEW.chamber_total_height,NEW.chamber_total_length,NEW.chamber_total_width,NEW.chamber_name);
				INSERT INTO polygon(pol_id,the_geom) VALUES (NEW.pol_id,NEW.the_geom);
				UPDATE node SET the_geom =(SELECT ST_Centroid(polygon.the_geom) FROM "SCHEMA_NAME".polygon where pol_id=NEW.pol_id) WHERE node_id=NEW.node_id;
			END IF;
			
		ELSIF man_table='man_manhole' THEN
			INSERT INTO node (node_id,top_elev,ymax,sander,node_type,nodecat_id,epa_type,sector_id,"state",annotation,observ,"comment",dma_id,soilcat_id,category_type,fluid_type,location_type,workcat_id,buildercat_id,
			builtdate,ownercat_id,	adress_01,adress_02,adress_03,descript,est_top_elev,est_ymax,rotation,link,verified,workcat_id_end,undelete,label_x,label_y,label_rotation,the_geom) 
			VALUES (NEW.node_id,NEW.manhole_top_elev,NEW.manhole_ymax,NEW.manhole_sander,NEW.node_type,NEW.nodecat_id,NEW.epa_type,NEW.sector_id,NEW.manhole_state,NEW.manhole_annotation,NEW.manhole_observ,
			NEW.manhole_comment,NEW.dma_id,NEW.manhole_soilcat_id,NEW.manhole_category_type,NEW.manhole_fluid_type,NEW.manhole_location_type,NEW.manhole_workcat_id,NEW.manhole_buildercat_id,NEW.manhole_builtdate,
			NEW.manhole_ownercat_id,NEW.manhole_adress_01,NEW.manhole_adress_02,NEW.manhole_adress_03,NEW.manhole_descript,NEW.manhole_est_top_elev,NEW.manhole_est_ymax,NEW.manhole_rotation,NEW.manhole_link,
			NEW.verified,NEW.manhole_workcat_id_end,NEW.undelete,NEW.manhole_label_x,NEW.manhole_label_y,NEW.manhole_label_rotation,NEW.the_geom);

			INSERT INTO man_manhole (node_id,add_info,sander_depth,prot_surface) VALUES (NEW.node_id,NEW.manhole_add_info,NEW.manhole_sander_depth,NEW.manhole_prot_surface);	
		
		ELSIF man_table='man_netinit' THEN
			INSERT INTO node (node_id,top_elev,ymax,sander,node_type,nodecat_id,epa_type,sector_id,"state",annotation,observ,"comment",dma_id,soilcat_id,category_type,fluid_type,location_type,workcat_id,buildercat_id,
			builtdate,ownercat_id,	adress_01,adress_02,adress_03,descript,est_top_elev,est_ymax,rotation,link,verified,workcat_id_end,undelete,label_x,label_y,label_rotation,the_geom) 
			VALUES (NEW.node_id,NEW.netinit_top_elev,NEW.netinit_ymax,NEW.netinit_sander,NEW.node_type,NEW.nodecat_id,NEW.epa_type,NEW.sector_id,NEW.netinit_state,NEW.netinit_annotation,NEW.netinit_observ,
			NEW.netinit_comment,NEW.dma_id,NEW.netinit_soilcat_id,NEW.netinit_category_type,NEW.netinit_fluid_type,NEW.netinit_location_type,NEW.netinit_workcat_id,NEW.netinit_buildercat_id,NEW.netinit_builtdate,
			NEW.netinit_ownercat_id,NEW.netinit_adress_01,NEW.netinit_adress_02,NEW.netinit_adress_03,NEW.netinit_descript,NEW.netinit_est_top_elev,NEW.netinit_est_ymax,NEW.netinit_rotation,NEW.netinit_link,
			NEW.verified,NEW.netinit_workcat_id_end,NEW.undelete,NEW.netinit_label_x,NEW.netinit_label_y,NEW.netinit_label_rotation,NEW.the_geom); 

			INSERT INTO man_netinit (node_id,add_info,mheight,mlength,mwidth,netinit_name) VALUES (NEW.node_id,NEW.add_info,NEW.mheight,NEW.mlength,NEW.mwidth,NEW.netinit_name);	
			
		ELSIF man_table='man_wjump' THEN
			INSERT INTO node (node_id,top_elev,ymax,sander,node_type,nodecat_id,epa_type,sector_id,"state",annotation,observ,"comment",dma_id,soilcat_id,category_type,fluid_type,location_type,workcat_id,buildercat_id,
			builtdate,ownercat_id,	adress_01,adress_02,adress_03,descript,est_top_elev,est_ymax,rotation,link,verified,workcat_id_end,undelete,label_x,label_y,label_rotation,the_geom) 
			VALUES (NEW.node_id,NEW.wjump_top_elev,NEW.wjump_ymax,NEW.wjump_sander,NEW.node_type,NEW.nodecat_id,NEW.epa_type,NEW.sector_id,NEW.wjump_state,NEW.wjump_annotation,NEW.wjump_observ,NEW.wjump_comment,
			NEW.dma_id,NEW.wjump_soilcat_id,NEW.wjump_category_type,NEW.wjump_fluid_type,NEW.wjump_location_type,NEW.wjump_workcat_id,NEW.wjump_buildercat_id,NEW.wjump_builtdate,NEW.wjump_ownercat_id,
			NEW.wjump_adress_01,NEW.wjump_adress_02,NEW.wjump_adress_03,NEW.wjump_descript,NEW.wjump_est_top_elev,NEW.wjump_est_ymax,NEW.wjump_rotation,NEW.wjump_link,NEW.verified,NEW.wjump_workcat_id_end,NEW.undelete,
			NEW.wjump_label_x,NEW.wjump_label_y,NEW.wjump_label_rotation,NEW.the_geom);

			INSERT INTO man_wjump (node_id,add_info,mheight,mlength,mwidth,sander_length,sander_depth,security_bar,steps,prot_surface,wjump_name) VALUES (NEW.node_id,NEW.wjump_add_info,NEW.wjump_mheight,
			NEW.wjump_mlength,NEW.wjump_mwidth,NEW.wjump_sander_length,NEW.wjump_sander_depth,NEW.wjump_security_bar,NEW.wjump_steps,NEW.wjump_prot_surface,NEW.wjump_name);	
		
		ELSIF man_table='man_wwtp' THEN
			INSERT INTO node (node_id,top_elev,ymax,sander,node_type,nodecat_id,epa_type,sector_id,"state",annotation,observ,"comment",dma_id,soilcat_id,category_type,fluid_type,location_type,workcat_id,buildercat_id,
			builtdate,ownercat_id,	adress_01,adress_02,adress_03,descript,est_top_elev,est_ymax,rotation,link,verified,workcat_id_end,undelete,label_x,label_y,label_rotation,the_geom) 
			VALUES (NEW.node_id,NEW.wwtp_top_elev,NEW.wwtp_ymax,NEW.wwtp_sander,NEW.node_type,NEW.nodecat_id,NEW.epa_type,NEW.sector_id,NEW.wwtp_state,NEW.wwtp_annotation,NEW.wwtp_observ,NEW.wwtp_comment,NEW.dma_id,
			NEW.wwtp_soilcat_id,NEW.wwtp_category_type,NEW.wwtp_fluid_type,NEW.wwtp_location_type,NEW.wwtp_workcat_id,NEW.wwtp_buildercat_id,NEW.wwtp_builtdate,NEW.wwtp_ownercat_id,NEW.wwtp_adress_01,NEW.wwtp_adress_02,
			NEW.wwtp_adress_03,NEW.wwtp_descript,NEW.wwtp_est_top_elev,NEW.wwtp_est_ymax,NEW.wwtp_rotation,NEW.wwtp_link,NEW.verified,NEW.wwtp_workcat_id_end,NEW.undelete,NEW.wwtp_label_x,NEW.wwtp_label_y,
			NEW.wwtp_label_rotation,NEW.the_geom);

			IF (rec.insert_double_geometry IS TRUE) THEN
				IF (NEW.pol_id IS NULL) THEN
					NEW.pol_id:= (SELECT nextval('pol_id_seq'));
				END IF;
				
				INSERT INTO man_wwtp (node_id,add_info,pol_id,wwtp_name) VALUES (NEW.node_id,NEW.wwtp_add_info,NEW.pol_id,NEW.wwtp_name);
				INSERT INTO polygon(pol_id,the_geom) VALUES (NEW.pol_id,(SELECT ST_Envelope(ST_Buffer(node.the_geom,rec.buffer_value)) from "SCHEMA_NAME".node where node_id=NEW.node_id));
			
			ELSE
				INSERT INTO man_wwtp (node_id,add_info,wwtp_name) VALUES (NEW.node_id,NEW.wwtp_add_info,NEW.wwtp_name);
			END IF;	
			
		ELSIF man_table='man_wwtp_pol' THEN
			INSERT INTO node (node_id,top_elev,ymax,sander,node_type,nodecat_id,epa_type,sector_id,"state",annotation,observ,"comment",dma_id,soilcat_id,category_type,fluid_type,location_type,workcat_id,buildercat_id,
			builtdate,ownercat_id,	adress_01,adress_02,adress_03,descript,est_top_elev,est_ymax,rotation,link,verified,workcat_id_end,undelete,label_x,label_y,label_rotation) 
			VALUES (NEW.node_id,NEW.wwtp_top_elev,NEW.wwtp_ymax,NEW.wwtp_sander,NEW.node_type,NEW.nodecat_id,NEW.epa_type,NEW.sector_id,NEW.wwtp_state,NEW.wwtp_annotation,NEW.wwtp_observ,NEW.wwtp_comment,NEW.dma_id,
			NEW.wwtp_soilcat_id,NEW.wwtp_category_type,NEW.wwtp_fluid_type,NEW.wwtp_location_type,NEW.wwtp_workcat_id,NEW.wwtp_buildercat_id,NEW.wwtp_builtdate,NEW.wwtp_ownercat_id,NEW.wwtp_adress_01,NEW.wwtp_adress_02,
			NEW.wwtp_adress_03,NEW.wwtp_descript,NEW.wwtp_est_top_elev,NEW.wwtp_est_ymax,NEW.wwtp_rotation,NEW.wwtp_link,NEW.verified,NEW.wwtp_workcat_id_end,NEW.undelete,NEW.wwtp_label_x,NEW.wwtp_label_y,
			NEW.wwtp_label_rotation);
			
			IF (rec.insert_double_geometry IS TRUE) THEN
				IF (NEW.pol_id IS NULL) THEN
					NEW.pol_id:= (SELECT nextval('pol_id_seq'));
				END IF;
				
				INSERT INTO man_wwtp (node_id,add_info,pol_id,wwtp_name) VALUES (NEW.node_id,NEW.wwtp_add_info,NEW.pol_id,NEW.wwtp_name);
				INSERT INTO polygon(pol_id,the_geom) VALUES (NEW.pol_id,NEW.the_geom);
				UPDATE node SET the_geom =(SELECT ST_Centroid(polygon.the_geom) FROM "SCHEMA_NAME".polygon where pol_id=NEW.pol_id) WHERE node_id=NEW.node_id;
			END IF;
			
		END IF;
		
		-- EPA INSERT
        IF (NEW.epa_type = 'JUNCTION') THEN inp_table:= 'inp_junction';
        ELSIF (NEW.epa_type = 'DIVIDER') THEN inp_table:= 'inp_divider';
        ELSIF (NEW.epa_type = 'OUTFALL') THEN inp_table:= 'inp_outfall';
        ELSIF (NEW.epa_type = 'STORAGE') THEN inp_table:= 'inp_storage';
        END IF;
        v_sql:= 'INSERT INTO '||inp_table||' (node_id) VALUES ('||quote_literal(NEW.node_id)||')';
        EXECUTE v_sql;

          
        --PERFORM audit_function (1,830);
        RETURN NEW;


    ELSIF TG_OP = 'UPDATE' THEN

/*
	IF (NEW.elev <> OLD.elev) THEN
                RETURN audit_function(200,830);  
	END IF;

        NEW.elev=NEW.top_elev-NEW.ymax;
 */

        IF (NEW.epa_type <> OLD.epa_type) THEN    
         
            IF (OLD.epa_type = 'JUNCTION') THEN
                inp_table:= 'inp_junction';            
            ELSIF (OLD.epa_type = 'DIVIDER') THEN
                inp_table:= 'inp_divider';                
            ELSIF (OLD.epa_type = 'OUTFALL') THEN
                inp_table:= 'inp_outfall';    
            ELSIF (OLD.epa_type = 'STORAGE') THEN
                inp_table:= 'inp_storage';    
			END IF;
            v_sql:= 'DELETE FROM '||inp_table||' WHERE node_id = '||quote_literal(OLD.node_id);
            EXECUTE v_sql;

            IF (NEW.epa_type = 'JUNCTION') THEN
                inp_table:= 'inp_junction';   
            ELSIF (NEW.epa_type = 'DIVIDER') THEN
                inp_table:= 'inp_divider';     
            ELSIF (NEW.epa_type = 'OUTFALL') THEN
                inp_table:= 'inp_outfall';  
            ELSIF (NEW.epa_type = 'STORAGE') THEN
                inp_table:= 'inp_storage';
            END IF;
            v_sql:= 'INSERT INTO '||inp_table||' (node_id) VALUES ('||quote_literal(NEW.node_id)||')';
            EXECUTE v_sql;

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

		
        
		IF man_table ='man_junction' THEN
			
			UPDATE node 
			SET node_id=NEW.node_id, top_elev=NEW.junction_top_elev, ymax=NEW.junction_ymax, sander=NEW.junction_sander, node_type=NEW.node_type, nodecat_id=NEW.nodecat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, 
			"state"=NEW.junction_state, annotation=NEW.junction_annotation, "observ"=NEW.junction_observ, "comment"=NEW.junction_comment, dma_id=NEW.dma_id, soilcat_id=NEW.junction_soilcat_id, 
			category_type=NEW.junction_category_type,fluid_type=NEW.junction_fluid_type, location_type=NEW.junction_location_type, workcat_id=NEW.junction_workcat_id, buildercat_id=NEW.junction_buildercat_id, 
			builtdate=NEW.junction_builtdate,ownercat_id=NEW.junction_ownercat_id, adress_01=NEW.junction_adress_01,adress_02=NEW.junction_adress_02, adress_03=NEW.junction_adress_03, descript=NEW.junction_descript,
			est_top_elev=NEW.junction_est_top_elev, est_ymax=NEW.junction_est_ymax, rotation=NEW.junction_rotation, link=NEW.junction_link, verified=NEW.verified, the_geom=NEW.the_geom
			WHERE node_id = OLD.node_id;
			
            UPDATE man_junction SET node_id=NEW.node_id, add_info=NEW.junction_add_info
			WHERE node_id=OLD.node_id;
			
		ELSIF man_table='man_netgully' THEN
		
			UPDATE node 
			SET node_id=NEW.node_id, top_elev=NEW.netgully_top_elev, ymax=NEW.netgully_ymax, sander=NEW.netgully_sander, node_type=NEW.node_type, nodecat_id=NEW.nodecat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, 
			"state"=NEW.netgully_state, annotation=NEW.netgully_annotation, "observ"=NEW.netgully_observ, "comment"=NEW.netgully_comment, dma_id=NEW.dma_id, soilcat_id=NEW.netgully_soilcat_id, 
			category_type=NEW.netgully_category_type,fluid_type=NEW.netgully_fluid_type, location_type=NEW.netgully_location_type, workcat_id=NEW.netgully_workcat_id, buildercat_id=NEW.netgully_buildercat_id, 
			builtdate=NEW.netgully_builtdate,ownercat_id=NEW.netgully_ownercat_id, adress_01=NEW.netgully_adress_01,adress_02=NEW.netgully_adress_02, adress_03=NEW.netgully_adress_03, descript=NEW.netgully_descript,
			est_top_elev=NEW.netgully_est_top_elev, est_ymax=NEW.netgully_est_ymax, rotation=NEW.netgully_rotation, link=NEW.netgully_link, verified=NEW.verified, the_geom=NEW.the_geom	
			WHERE node_id = OLD.node_id;
		
			UPDATE man_netgully SET node_id=NEW.node_id, pol_id=NEW.pol_id, add_info=NEW.netgully_add_info
			WHERE node_id=OLD.node_id;

			
		ELSIF man_table='man_netgully_pol' THEN
			
			UPDATE node 
			SET node_id=NEW.node_id, top_elev=NEW.netgully_top_elev, ymax=NEW.netgully_ymax, sander=NEW.netgully_sander, node_type=NEW.node_type, nodecat_id=NEW.nodecat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id,
			"state"=NEW.netgully_state, annotation=NEW.netgully_annotation, "observ"=NEW.netgully_observ, "comment"=NEW.netgully_comment, dma_id=NEW.dma_id, soilcat_id=NEW.netgully_soilcat_id,
			category_type=NEW.netgully_category_type,fluid_type=NEW.netgully_fluid_type, location_type=NEW.netgully_location_type, workcat_id=NEW.netgully_workcat_id, buildercat_id=NEW.netgully_buildercat_id, 
			builtdate=NEW.netgully_builtdate,ownercat_id=NEW.netgully_ownercat_id, adress_01=NEW.netgully_adress_01,adress_02=NEW.netgully_adress_02, adress_03=NEW.netgully_adress_03, 
			descript=NEW.netgully_descript,est_top_elev=NEW.netgully_est_top_elev, est_ymax=NEW.netgully_est_ymax, rotation=NEW.netgully_rotation, link=NEW.netgully_link, verified=NEW.verified
			WHERE node_id = OLD.node_id;
			
			IF (NEW.pol_id IS NULL) THEN
				UPDATE man_netgully SET node_id=NEW.node_id, pol_id=NEW.pol_id,add_info=NEW.netgully_add_info
				WHERE node_id=OLD.node_id;
				UPDATE polygon SET the_geom=NEW.the_geom
				WHERE pol_id=OLD.pol_id;
			ELSE
				UPDATE man_netgully SET node_id=NEW.node_id, pol_id=NEW.pol_id,add_info=NEW.netgully_add_info
				WHERE node_id=OLD.node_id;
				UPDATE polygon SET the_geom=NEW.the_geom,pol_id=NEW.pol_id
				WHERE pol_id=OLD.pol_id;
			END IF;
			
		ELSIF man_table='man_outfall' THEN
			
			UPDATE node 
			SET node_id=NEW.node_id, top_elev=NEW.outfall_top_elev, ymax=NEW.outfall_ymax, sander=NEW.outfall_sander, node_type=NEW.node_type, nodecat_id=NEW.nodecat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id,
			"state"=NEW.outfall_state, annotation=NEW.outfall_annotation, "observ"=NEW.outfall_observ, "comment"=NEW.outfall_comment, dma_id=NEW.dma_id, soilcat_id=NEW.outfall_soilcat_id, 
			category_type=NEW.outfall_category_type,fluid_type=NEW.outfall_fluid_type, location_type=NEW.outfall_location_type, workcat_id=NEW.outfall_workcat_id, buildercat_id=NEW.outfall_buildercat_id, 
			builtdate=NEW.outfall_builtdate,ownercat_id=NEW.outfall_ownercat_id, adress_01=NEW.outfall_adress_01,adress_02=NEW.outfall_adress_02, adress_03=NEW.outfall_adress_03, 
			descript=NEW.outfall_descript,est_top_elev=NEW.outfall_est_top_elev, est_ymax=NEW.outfall_est_ymax, rotation=NEW.outfall_rotation, link=NEW.outfall_link, verified=NEW.verified, the_geom=NEW.the_geom
			WHERE node_id = OLD.node_id;
			
			UPDATE man_outfall SET node_id=NEW.node_id, add_info=NEW.outfall_add_info, outfall_name=NEW.outfall_name
			WHERE node_id=OLD.node_id;
			
		ELSIF man_table='man_storage' THEN
			
			UPDATE node 
			SET node_id=NEW.node_id, top_elev=NEW.storage_top_elev, ymax=NEW.storage_ymax, sander=NEW.storage_sander, node_type=NEW.node_type, nodecat_id=NEW.nodecat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, 
			"state"=NEW.storage_state, annotation=NEW.storage_annotation, "observ"=NEW.storage_observ, "comment"=NEW.storage_comment, dma_id=NEW.dma_id, soilcat_id=NEW.storage_soilcat_id, 
			category_type=NEW.storage_category_type,fluid_type=NEW.storage_fluid_type, location_type=NEW.storage_location_type, workcat_id=NEW.storage_workcat_id, buildercat_id=NEW.storage_buildercat_id, 
			builtdate=NEW.storage_builtdate,ownercat_id=NEW.storage_ownercat_id, adress_01=NEW.storage_adress_01,adress_02=NEW.storage_adress_02, adress_03=NEW.storage_adress_03, descript=NEW.storage_descript,
			est_top_elev=NEW.storage_est_top_elev, est_ymax=NEW.storage_est_ymax, rotation=NEW.storage_rotation, link=NEW.storage_link, verified=NEW.verified, the_geom=NEW.the_geom
			WHERE node_id = OLD.node_id;
		
			UPDATE man_storage SET node_id=NEW.node_id, pol_id=NEW.pol_id, add_info=NEW.storage_add_info,total_volume=NEW.storage_total_volume,util_volume=NEW.storage_util_volume,min_height=NEW.storage_min_height,
			total_height=NEW.storage_total_height,total_length=NEW.storage_total_length,total_width=NEW.storage_total_width,storage_name=NEW.storage_storage_name
			WHERE node_id=OLD.node_id;

			
		ELSIF man_table='man_storage_pol' THEN
			
			UPDATE node 
			SET node_id=NEW.node_id, top_elev=NEW.storage_top_elev, ymax=NEW.storage_ymax, sander=NEW.storage_sander, node_type=NEW.node_type, nodecat_id=NEW.nodecat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, 
			"state"=NEW.storage_state, annotation=NEW.storage_annotation, "observ"=NEW.storage_observ, "comment"=NEW.storage_comment, dma_id=NEW.dma_id, soilcat_id=NEW.storage_soilcat_id, 
			category_type=NEW.storage_category_type,fluid_type=NEW.storage_fluid_type, location_type=NEW.storage_location_type, workcat_id=NEW.storage_workcat_id, buildercat_id=NEW.storage_buildercat_id, 
			builtdate=NEW.storage_builtdate,ownercat_id=NEW.storage_ownercat_id, adress_01=NEW.storage_adress_01,adress_02=NEW.storage_adress_02, adress_03=NEW.storage_adress_03, descript=NEW.storage_descript,
			est_top_elev=NEW.storage_est_top_elev, est_ymax=NEW.storage_est_ymax, rotation=NEW.storage_rotation, link=NEW.storage_link, verified=NEW.verified
			WHERE node_id = OLD.node_id;
		
			IF (NEW.pol_id IS NULL) THEN
				UPDATE man_storage SET node_id=NEW.node_id, pol_id=NEW.pol_id, add_info=NEW.storage_add_info,total_volume=NEW.storage_total_volume,util_volume=NEW.storage_util_volume,min_height=NEW.storage_min_height,
				total_height=NEW.storage_total_height,total_length=NEW.storage_total_length,total_width=NEW.storage_total_width,storage_name=NEW.storage_storage_name
				WHERE node_id=OLD.node_id;
				UPDATE polygon SET the_geom=NEW.the_geom
				WHERE pol_id=OLD.pol_id;
			ELSE
				UPDATE man_storage SET node_id=NEW.node_id, pol_id=NEW.pol_id, add_info=NEW.storage_add_info,total_volume=NEW.storage_total_volume,util_volume=NEW.storage_util_volume,min_height=NEW.storage_min_height,
				total_height=NEW.storage_total_height,total_length=NEW.storage_total_length,total_width=NEW.storage_total_width,storage_name=NEW.storage_storage_name
				WHERE node_id=OLD.node_id;
				UPDATE polygon SET the_geom=NEW.the_geom,pol_id=NEW.pol_id
				WHERE pol_id=OLD.pol_id;
			END IF;

		ELSIF man_table='man_valve' THEN
			
			UPDATE node 
			SET node_id=NEW.node_id, top_elev=NEW.valve_top_elev, ymax=NEW.valve_ymax, sander=NEW.valve_sander, node_type=NEW.node_type, nodecat_id=NEW.nodecat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, 
			"state"=NEW.valve_state, annotation=NEW.valve_annotation, "observ"=NEW.valve_observ, "comment"=NEW.valve_comment, dma_id=NEW.dma_id, soilcat_id=NEW.valve_soilcat_id, 
			category_type=NEW.valve_category_type,fluid_type=NEW.valve_fluid_type, location_type=NEW.valve_location_type, workcat_id=NEW.valve_workcat_id, buildercat_id=NEW.valve_buildercat_id, 
			builtdate=NEW.valve_builtdate,ownercat_id=NEW.valve_ownercat_id, adress_01=NEW.valve_adress_01,adress_02=NEW.valve_adress_02, adress_03=NEW.valve_adress_03, descript=NEW.valve_descript,
			est_top_elev=NEW.valve_est_top_elev, est_ymax=NEW.valve_est_ymax, rotation=NEW.valve_rotation, link=NEW.valve_link, verified=NEW.verified
			WHERE node_id = OLD.node_id;
		
			UPDATE man_valve SET node_id=NEW.node_id,add_info=NEW.valve_add_info, valve_name=NEW.valve_name
			WHERE node_id=OLD.node_id;

		
		ELSIF man_table='man_chamber' THEN
			
			UPDATE node 
			SET node_id=NEW.node_id, top_elev=NEW.chamber_top_elev, ymax=NEW.chamber_ymax, sander=NEW.chamber_sander, node_type=NEW.node_type, nodecat_id=NEW.nodecat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, 
			"state"=NEW.chamber_state, annotation=NEW.chamber_annotation, "observ"=NEW.chamber_observ, "comment"=NEW.chamber_comment, dma_id=NEW.dma_id, soilcat_id=NEW.chamber_soilcat_id, 
			category_type=NEW.chamber_category_type,fluid_type=NEW.chamber_fluid_type, location_type=NEW.chamber_location_type, workcat_id=NEW.chamber_workcat_id, buildercat_id=NEW.chamber_buildercat_id, 
			builtdate=NEW.chamber_builtdate,ownercat_id=NEW.chamber_ownercat_id, adress_01=NEW.chamber_adress_01,adress_02=NEW.chamber_adress_02, adress_03=NEW.chamber_adress_03, descript=NEW.chamber_descript,
			est_top_elev=NEW.chamber_est_top_elev, est_ymax=NEW.chamber_est_ymax, rotation=NEW.chamber_rotation, link=NEW.chamber_link, verified=NEW.verified, the_geom=NEW.the_geom
			WHERE node_id = OLD.node_id;
			
			UPDATE man_chamber SET node_id=NEW.node_id, pol_id=NEW.pol_id, add_info=NEW.chamber_add_info,total_volume=NEW.chamber_total_volume,total_height=NEW.chamber_total_height,total_length=NEW.chamber_total_length,
			total_width=NEW.chamber_total_width,chamber_name=NEW.chamber_name
			WHERE node_id=OLD.node_id;

			
		ELSIF man_table='man_chamber_pol' THEN
		
			UPDATE node 
			SET node_id=NEW.node_id, top_elev=NEW.chamber_top_elev, ymax=NEW.chamber_ymax, sander=NEW.chamber_sander, node_type=NEW.node_type, nodecat_id=NEW.nodecat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id,
			"state"=NEW.chamber_state, annotation=NEW.chamber_annotation, "observ"=NEW.chamber_observ, "comment"=NEW.chamber_comment, dma_id=NEW.dma_id, soilcat_id=NEW.chamber_soilcat_id, 
			category_type=NEW.chamber_category_type,fluid_type=NEW.chamber_fluid_type, location_type=NEW.chamber_location_type, workcat_id=NEW.chamber_workcat_id, buildercat_id=NEW.chamber_buildercat_id, 
			builtdate=NEW.chamber_builtdate,ownercat_id=NEW.chamber_ownercat_id, adress_01=NEW.chamber_adress_01,adress_02=NEW.chamber_adress_02, adress_03=NEW.chamber_adress_03, descript=NEW.chamber_descript,
			est_top_elev=NEW.chamber_est_top_elev, est_ymax=NEW.chamber_est_ymax, rotation=NEW.chamber_rotation, link=NEW.chamber_link, verified=NEW.verified
			WHERE node_id = OLD.node_id;
		
			IF (NEW.pol_id IS NULL) THEN
				UPDATE man_chamber SET node_id=NEW.node_id, pol_id=NEW.pol_id, add_info=NEW.chamber_add_info,total_volume=NEW.chamber_total_volume,total_height=NEW.chamber_total_height,
				total_length=NEW.chamber_total_length,total_width=NEW.chamber_total_width,chamber_name=NEW.chamber_name
				WHERE node_id=OLD.node_id;
				UPDATE polygon SET the_geom=NEW.the_geom
				WHERE pol_id=OLD.pol_id;
			ELSE
				UPDATE man_chamber SET node_id=NEW.node_id, pol_id=NEW.pol_id, add_info=NEW.chamber_add_info,total_volume=NEW.chamber_total_volume,total_height=NEW.chamber_total_height,
				total_length=NEW.chamber_total_length,total_width=NEW.chamber_total_width,chamber_name=NEW.chamber_name
				WHERE node_id=OLD.node_id;
				UPDATE polygon SET the_geom=NEW.the_geom,pol_id=NEW.pol_id
				WHERE pol_id=OLD.pol_id;
			END IF;	
			
		ELSIF man_table='man_manhole' THEN
		
			UPDATE node 
			SET node_id=NEW.node_id, top_elev=NEW.manhole_top_elev, ymax=NEW.manhole_ymax, sander=NEW.manhole_sander, node_type=NEW.node_type, nodecat_id=NEW.nodecat_id, epa_type=NEW.epa_type, 
			sector_id=NEW.sector_id, "state"=NEW.manhole_state, annotation=NEW.manhole_annotation, "observ"=NEW.manhole_observ, "comment"=NEW.manhole_comment, dma_id=NEW.dma_id, soilcat_id=NEW.manhole_soilcat_id, 
			category_type=NEW.manhole_category_type,fluid_type=NEW.manhole_fluid_type, location_type=NEW.manhole_location_type, workcat_id=NEW.manhole_workcat_id, buildercat_id=NEW.manhole_buildercat_id, 
			builtdate=NEW.manhole_builtdate,ownercat_id=NEW.manhole_ownercat_id, adress_01=NEW.manhole_adress_01,adress_02=NEW.manhole_adress_02, adress_03=NEW.manhole_adress_03, descript=NEW.manhole_descript,
			est_top_elev=NEW.manhole_est_top_elev, est_ymax=NEW.manhole_est_ymax, rotation=NEW.manhole_rotation, link=NEW.manhole_link, verified=NEW.verified, the_geom=NEW.the_geom
			WHERE node_id = OLD.node_id;
			
			UPDATE man_manhole SET node_id=NEW.node_id,add_info=NEW.manhole_add_info, sander_depth=NEW.manhole_sander_depth, prot_surface=NEW.manhole_prot_surface
			WHERE node_id=OLD.node_id;

			
		ELSIF man_table='man_netinit' THEN
			
			UPDATE node 
			SET node_id=NEW.node_id, top_elev=NEW.netinit_top_elev, ymax=NEW.netinit_ymax, sander=NEW.netinit_sander, node_type=NEW.node_type, nodecat_id=NEW.nodecat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id,
			"state"=NEW.netinit_state, annotation=NEW.netinit_annotation, "observ"=NEW.netinit_observ, "comment"=NEW.netinit_comment, dma_id=NEW.dma_id, soilcat_id=NEW.netinit_soilcat_id, 
			category_type=NEW.netinit_category_type,fluid_type=NEW.netinit_fluid_type, location_type=NEW.netinit_location_type, workcat_id=NEW.netinit_workcat_id, buildercat_id=NEW.netinit_buildercat_id, 
			builtdate=NEW.netinit_builtdate,ownercat_id=NEW.netinit_ownercat_id, adress_01=NEW.netinit_adress_01,adress_02=NEW.netinit_adress_02, adress_03=NEW.netinit_adress_03, descript=NEW.netinit_descript,
			est_top_elev=NEW.netinit_est_top_elev, est_ymax=NEW.netinit_est_ymax, rotation=NEW.netinit_rotation, link=NEW.netinit_link, verified=NEW.verified, the_geom=NEW.the_geom
			WHERE node_id = OLD.node_id;
		
			UPDATE man_netinit SET node_id=NEW.node_id,add_info=NEW.netinit_add_info, mheight=NEW.netinit_mheight,mlength=NEW.netinit_mlength,mwidth=NEW.netinit_mwidth,netinit_name=NEW.netinit_netinit_name
			WHERE node_id=OLD.node_id;

			
		ELSIF man_table='man_wjump' THEN
		
			UPDATE node 
			SET node_id=NEW.node_id, top_elev=NEW.wjump_top_elev, ymax=NEW.wjump_ymax, sander=NEW.wjump_sander, node_type=NEW.node_type, nodecat_id=NEW.nodecat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, 
			"state"=NEW.wjump_state, annotation=NEW.wjump_annotation, "observ"=NEW.wjump_observ, "comment"=NEW.wjump_comment, dma_id=NEW.dma_id, soilcat_id=NEW.wjump_soilcat_id, category_type=NEW.wjump_category_type,
			fluid_type=NEW.wjump_fluid_type, location_type=NEW.wjump_location_type, workcat_id=NEW.wjump_workcat_id, buildercat_id=NEW.wjump_buildercat_id, builtdate=NEW.wjump_builtdate,ownercat_id=NEW.wjump_ownercat_id, 
			adress_01=NEW.wjump_adress_01,adress_02=NEW.wjump_adress_02, adress_03=NEW.wjump_adress_03, descript=NEW.wjump_descript,est_top_elev=NEW.wjump_est_top_elev, est_ymax=NEW.wjump_est_ymax,
			rotation=NEW.wjump_rotation, link=NEW.wjump_link, verified=NEW.verified, the_geom=NEW.the_geom
			WHERE node_id = OLD.node_id;
		
			UPDATE man_wjump SET node_id=NEW.node_id,add_info=NEW.wjump_add_info, mheight=NEW.wjump_mheight,mlength=NEW.wjump_mlength,mwidth=NEW.wjump_mwidth,sander_length=NEW.wjump_sander_length,
			sander_depth=NEW.wjump_sander_depth,security_bar=NEW.wjump_security_bar, steps=NEW.wjump_steps,prot_surface=NEW.wjump_prot_surface,wjump_name=NEW.wjump_name
			WHERE node_id=OLD.node_id;

			
		ELSIF man_table='man_wwtp' THEN
		
			UPDATE node 
			SET node_id=NEW.node_id, top_elev=NEW.wwtp_top_elev, ymax=NEW.wwtp_ymax, sander=NEW.wwtp_sander, node_type=NEW.node_type, nodecat_id=NEW.nodecat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, 
			"state"=NEW.wwtp_state, annotation=NEW.wwtp_annotation, "observ"=NEW.wwtp_observ, "comment"=NEW.wwtp_comment, dma_id=NEW.dma_id, soilcat_id=NEW.wwtp_soilcat_id, category_type=NEW.wwtp_category_type,
			fluid_type=NEW.wwtp_fluid_type, location_type=NEW.wwtp_location_type, workcat_id=NEW.wwtp_workcat_id, buildercat_id=NEW.wwtp_buildercat_id, builtdate=NEW.wwtp_builtdate,ownercat_id=NEW.wwtp_ownercat_id,
			adress_01=NEW.wwtp_adress_01,adress_02=NEW.wwtp_adress_02, adress_03=NEW.wwtp_adress_03, descript=NEW.wwtp_descript,est_top_elev=NEW.wwtp_est_top_elev, est_ymax=NEW.wwtp_est_ymax, rotation=NEW.wwtp_rotation, 
			link=NEW.wwtp_link, verified=NEW.verified, the_geom=NEW.the_geom
			WHERE node_id = OLD.node_id;
		
			UPDATE man_wwtp SET node_id=NEW.node_id, pol_id=NEW.pol_id, add_info=NEW.wwtp_add_info,wwtp_name=NEW.wwtp_name
			WHERE node_id=OLD.node_id;

			
		ELSIF man_table='man_wwtp_pol' THEN
		
			UPDATE node 
			SET node_id=NEW.node_id, top_elev=NEW.wwtp_top_elev, ymax=NEW.wwtp_ymax, sander=NEW.wwtp_sander, node_type=NEW.node_type, nodecat_id=NEW.nodecat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id,
			"state"=NEW.wwtp_state, annotation=NEW.wwtp_annotation, "observ"=NEW.wwtp_observ, "comment"=NEW.wwtp_comment, dma_id=NEW.dma_id, soilcat_id=NEW.wwtp_soilcat_id, category_type=NEW.wwtp_category_type,
			fluid_type=NEW.wwtp_fluid_type, location_type=NEW.wwtp_location_type, workcat_id=NEW.wwtp_workcat_id, buildercat_id=NEW.wwtp_buildercat_id, builtdate=NEW.wwtp_builtdate,ownercat_id=NEW.wwtp_ownercat_id,
			adress_01=NEW.wwtp_adress_01,adress_02=NEW.wwtp_adress_02, adress_03=NEW.wwtp_adress_03, descript=NEW.wwtp_descript,est_top_elev=NEW.wwtp_est_top_elev, est_ymax=NEW.wwtp_est_ymax, rotation=NEW.wwtp_rotation,
			link=NEW.wwtp_link, verified=NEW.verified
			WHERE node_id = OLD.node_id;
		
		
			IF (NEW.pol_id IS NULL) THEN
				UPDATE man_wwtp SET node_id=NEW.node_id, pol_id=NEW.pol_id, add_info=NEW.wwtp_add_info,wwtp_name=NEW.wwtp_name
				WHERE node_id=OLD.node_id;
				UPDATE polygon SET the_geom=NEW.the_geom
				WHERE pol_id=OLD.pol_id;
			ELSE
				UPDATE man_wwtp SET node_id=NEW.node_id, pol_id=NEW.pol_id, add_info=NEW.wwtp_add_info,wwtp_name=NEW.wwtp_name
				WHERE node_id=OLD.node_id;
				UPDATE polygon SET the_geom=NEW.the_geom,pol_id=NEW.pol_id
				WHERE pol_id=OLD.pol_id;
			END IF;	
		
		
		END IF;
		--PERFORM audit_function (2,830);
        RETURN NEW;
		
		
	
    ELSIF TG_OP = 'DELETE' THEN

	IF man_table ='man_storage' OR man_table ='man_chamber' OR man_table ='man_wwtp' OR man_table ='man_netgully' THEN
		IF OLD.pol_id IS NOT NULL THEN
			DELETE FROM polygon WHERE pol_id = OLD.pol_id;
			DELETE FROM node WHERE node_id = OLD.node_id;
		ELSE
			DELETE FROM node WHERE node_id = OLD.node_id;
		END IF;
	ELSE
		DELETE FROM node WHERE node_id = OLD.node_id;
	END IF;

		--PERFORM audit_function (3,830);
        RETURN NULL;
   
    END IF;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

DROP TRIGGER IF EXISTS gw_trg_edit_man_chamber ON "SCHEMA_NAME".v_edit_man_chamber;
CREATE TRIGGER gw_trg_edit_man_chamber INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_chamber FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_chamber');     

DROP TRIGGER IF EXISTS gw_trg_edit_man_chamber_pol ON "SCHEMA_NAME".v_edit_man_chamber_pol;
CREATE TRIGGER gw_trg_edit_man_chamber_pol INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_chamber_pol FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_chamber_pol');  
  
DROP TRIGGER IF EXISTS gw_trg_edit_man_junction ON "SCHEMA_NAME".v_edit_man_junction;
CREATE TRIGGER gw_trg_edit_man_junction INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_junction FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_junction');

DROP TRIGGER IF EXISTS gw_trg_edit_man_manhole ON "SCHEMA_NAME".v_edit_man_manhole;
CREATE TRIGGER gw_trg_edit_man_manhole INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_manhole FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_manhole');

DROP TRIGGER IF EXISTS gw_trg_edit_man_netgully ON "SCHEMA_NAME".v_edit_man_netgully;
CREATE TRIGGER gw_trg_edit_man_netgully INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_netgully FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_netgully');  

DROP TRIGGER IF EXISTS gw_trg_edit_man_netgully_pol ON "SCHEMA_NAME".v_edit_man_netgully_pol;
CREATE TRIGGER gw_trg_edit_man_netgully_pol INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_netgully_pol FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_netgully_pol');  

DROP TRIGGER IF EXISTS gw_trg_edit_man_netinit ON "SCHEMA_NAME".v_edit_man_netinit;
CREATE TRIGGER gw_trg_edit_man_netinit INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_netinit FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_netinit');  

DROP TRIGGER IF EXISTS gw_trg_edit_man_outfall ON "SCHEMA_NAME".v_edit_man_outfall;
CREATE TRIGGER gw_trg_edit_man_outfall INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_outfall FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_outfall');

DROP TRIGGER IF EXISTS gw_trg_edit_man_storage ON "SCHEMA_NAME".v_edit_man_storage;
CREATE TRIGGER gw_trg_edit_man_storage INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_storage FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_storage');

DROP TRIGGER IF EXISTS gw_trg_edit_man_storage_pol ON "SCHEMA_NAME".v_edit_man_storage_pol;
CREATE TRIGGER gw_trg_edit_man_storage_pol INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_storage_pol FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_storage_pol');

DROP TRIGGER IF EXISTS gw_trg_edit_man_valve ON "SCHEMA_NAME".v_edit_man_valve;
CREATE TRIGGER gw_trg_edit_man_valve INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_valve FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_valve');   

DROP TRIGGER IF EXISTS gw_trg_edit_man_waccel ON "SCHEMA_NAME".v_edit_man_waccel;
CREATE TRIGGER gw_trg_edit_man_waccel INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_waccel FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_waccel');   

DROP TRIGGER IF EXISTS gw_trg_edit_man_wjump ON "SCHEMA_NAME".v_edit_man_wjump;
CREATE TRIGGER gw_trg_edit_man_wjump INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_wjump FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_wjump');   

DROP TRIGGER IF EXISTS gw_trg_edit_man_wwtp ON "SCHEMA_NAME".v_edit_man_wwtp;
CREATE TRIGGER gw_trg_edit_man_wwtp INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_wwtp FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_wwtp');
     
DROP TRIGGER IF EXISTS gw_trg_edit_man_wwtp_pol ON "SCHEMA_NAME".v_edit_man_wwtp_pol;
CREATE TRIGGER gw_trg_edit_man_wwtp_pol INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_wwtp_pol FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_wwtp_pol'); 