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
    old_nodetype varchar;
    new_nodetype varchar;
	rec Record;


BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
    man_table:= TG_ARGV[0];
	
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
            IF ((SELECT COUNT(*) FROM node_type) = 0) THEN
                RETURN audit_function(105,810);  
            END IF;
            NEW.node_type:= (SELECT id FROM node_type LIMIT 1);
        END IF;

         -- Epa type
        IF (NEW.epa_type IS NULL) THEN
			NEW.epa_type:= (SELECT epa_default FROM node_type WHERE node_type.id=NEW.node_type)::text;   
		END IF;

        -- Node Catalog ID
        IF (NEW.nodecat_id IS NULL) THEN
            IF ((SELECT COUNT(*) FROM cat_node) = 0) THEN
                RETURN audit_function(110,810);  
            END IF;      
        END IF;

        -- Sector ID
        IF (NEW.sector_id IS NULL) THEN
            IF ((SELECT COUNT(*) FROM sector) = 0) THEN
                RETURN audit_function(115,810);  
            END IF;
            NEW.sector_id:= (SELECT sector_id FROM sector WHERE ST_DWithin(NEW.the_geom, sector.the_geom,0.001) LIMIT 1);
            IF (NEW.sector_id IS NULL) THEN
                RETURN audit_function(120,810);          
            END IF;            
        END IF;
        
        -- Dma ID
        IF (NEW.dma_id IS NULL) THEN
            IF ((SELECT COUNT(*) FROM dma) = 0) THEN
                RETURN audit_function(125,810);  
            END IF;
            NEW.dma_id := (SELECT dma_id FROM dma WHERE ST_DWithin(NEW.the_geom, dma.the_geom,0.001) LIMIT 1);
            IF (NEW.dma_id IS NULL) THEN
                RETURN audit_function(130,810);  
            END IF;            
        END IF;
		
		
		
		IF man_table='man_junction' THEN
			INSERT INTO node (node_id,top_elev,ymax,sander,node_type,nodecat_id,epa_type,sector_id,"state",annotation,observ,"comment",dma_id,soilcat_id,category_type,fluid_type,location_type,workcat_id,buildercat_id,builtdate,ownercat_id,adress_01,adress_02,adress_03,descript,est_top_elev,est_ymax,rotation,link,verified,workcat_id_end,undelete,label_x,label_y,label_rotation,the_geom)
			VALUES (NEW.node_id,NEW.top_elev,NEW.ymax,NEW.sander,NEW.node_type,NEW.nodecat_id,NEW.epa_type,NEW.sector_id,NEW."state",NEW.annotation,NEW.observ,NEW."comment",NEW.dma_id,NEW.soilcat_id,NEW.category_type,NEW.fluid_type,NEW.location_type,NEW.workcat_id,NEW.buildercat_id,NEW.builtdate,NEW.ownercat_id,NEW.adress_01,NEW.adress_02,NEW.adress_03,NEW.descript,NEW.est_top_elev,NEW.est_ymax,NEW.rotation,NEW.link,NEW.verified,NEW.workcat_id_end,NEW.undelete,NEW.label_x,NEW.label_y,NEW.label_rotation,NEW.the_geom);	

			INSERT INTO man_junction (node_id,add_info) VALUES (NEW.node_id,NEW.add_info);

			        
		ELSIF man_table='man_outfall' THEN
			INSERT INTO node (node_id,top_elev,ymax,sander,node_type,nodecat_id,epa_type,sector_id,"state",annotation,observ,"comment",dma_id,soilcat_id,category_type,fluid_type,location_type,workcat_id,buildercat_id,builtdate,ownercat_id,	adress_01,adress_02,adress_03,descript,est_top_elev,est_ymax,rotation,link,verified,workcat_id_end,undelete,label_x,label_y,label_rotation,the_geom) 
			VALUES (NEW.node_id,NEW.top_elev,NEW.ymax,NEW.sander,NEW.node_type,NEW.nodecat_id, NEW.epa_type,NEW.sector_id,NEW."state",NEW.annotation,NEW.observ,NEW."comment",NEW.dma_id,NEW.soilcat_id,NEW.category_type,NEW.fluid_type,NEW.location_type,NEW.workcat_id,NEW.buildercat_id,NEW.builtdate,NEW.ownercat_id,NEW.adress_01, NEW.adress_02,NEW.adress_03,NEW.descript,NEW.est_top_elev,NEW.est_ymax,NEW.rotation,NEW.link,NEW.verified,NEW.workcat_id_end,NEW.undelete,NEW.label_x,NEW.label_y,NEW.label_rotation,NEW.the_geom);

			INSERT INTO man_outfall (node_id,add_info,outfall_name) VALUES (NEW.node_id,NEW.add_info,NEW.outfall_name);	
        
		ELSIF man_table='man_valve' THEN
			INSERT INTO node (node_id,top_elev,ymax,sander,node_type,nodecat_id,epa_type,sector_id,"state",annotation,observ,"comment",dma_id,soilcat_id,category_type,fluid_type,location_type,workcat_id,buildercat_id,builtdate,ownercat_id,	adress_01,adress_02,adress_03,descript,est_top_elev,est_ymax,rotation,link,verified,workcat_id_end,undelete,label_x,label_y,label_rotation,the_geom) VALUES (NEW.node_id,NEW.top_elev,NEW.ymax,NEW.sander,NEW.node_type,NEW.nodecat_id,	NEW.epa_type,NEW.sector_id,NEW."state",NEW.annotation,NEW.observ,NEW."comment",NEW.dma_id,NEW.soilcat_id,NEW.category_type,NEW.fluid_type,NEW.location_type,NEW.workcat_id,NEW.buildercat_id,NEW.builtdate,NEW.ownercat_id,NEW.adress_01,NEW.adress_02,NEW.adress_03,NEW.descript,NEW.est_top_elev,NEW.est_ymax,NEW.rotation,NEW.link,NEW.verified,NEW.workcat_id_end,NEW.undelete,NEW.label_x,NEW.label_y,NEW.label_rotation,NEW.the_geom);

			INSERT INTO man_valve (node_id,add_info,valve_name) VALUES (NEW.node_id,NEW.add_info,NEW.valve_name);	
		
		ELSIF man_table='man_storage' THEN
			INSERT INTO node (node_id,top_elev,ymax,sander,node_type,nodecat_id,epa_type,sector_id,"state",annotation,observ,"comment",dma_id,soilcat_id,category_type,fluid_type,location_type,workcat_id,buildercat_id,builtdate,ownercat_id,	adress_01,adress_02,adress_03,descript,est_top_elev,est_ymax,rotation,link,verified,workcat_id_end,undelete,label_x,label_y,label_rotation,the_geom) VALUES (NEW.node_id,NEW.top_elev,NEW.ymax,NEW.sander,NEW.node_type,NEW.nodecat_id,NEW.epa_type, NEW.sector_id,NEW."state",NEW.annotation,NEW.observ,NEW."comment",NEW.dma_id,NEW.soilcat_id,NEW.category_type,NEW.fluid_type,NEW.location_type,NEW.workcat_id,NEW.buildercat_id,NEW.builtdate,NEW.ownercat_id,NEW.adress_01,NEW.adress_02, NEW.adress_03,NEW.descript,NEW.est_top_elev,NEW.est_ymax,NEW.rotation,NEW.link,NEW.verified,NEW.workcat_id_end,NEW.undelete,NEW.label_x,NEW.label_y,NEW.label_rotation,NEW.the_geom);
			
			IF (rec.insert_double_geometry IS TRUE) THEN
				IF (NEW.pol_id IS NULL) THEN
					NEW.pol_id:= (SELECT nextval('pol_id_seq'));
				END IF;
				
				INSERT INTO man_storage (node_id,pol_id,add_info,total_volumen,util_volumen,min_height,total_height,total_length,total_width,storage_name) VALUES(NEW.node_id, NEW.pol_id,NEW.add_info,NEW.total_volumen,NEW.util_volumen,NEW.min_height,NEW.total_height,NEW.total_length,NEW.total_width,NEW.storage_name);
				INSERT INTO polygon(pol_id,the_geom) VALUES (NEW.pol_id,(SELECT ST_Envelope(ST_Buffer(node.the_geom,rec.buffer_value)) from "SCHEMA_NAME".node where node_id=NEW.node_id));
			
			ELSE
				INSERT INTO man_storage (node_id,pol_id,add_info,total_volumen,util_volumen,min_height,total_height,total_length,total_width,storage_name) VALUES(NEW.node_id, NEW.pol_id,NEW.add_info,NEW.total_volumen,NEW.util_volumen,NEW.min_height,NEW.total_height,NEW.total_length,NEW.total_width,NEW.storage_name);
			END IF;
	
		ELSIF man_table='man_netgully' THEN
			INSERT INTO node (node_id,top_elev,ymax,sander,node_type,nodecat_id,epa_type,sector_id,"state",annotation,observ,"comment",dma_id,soilcat_id,category_type,fluid_type,location_type,workcat_id,buildercat_id,builtdate,ownercat_id,	adress_01,adress_02,adress_03,descript,est_top_elev,est_ymax,rotation,link,verified,workcat_id_end,undelete,label_x,label_y,label_rotation,the_geom) VALUES (NEW.node_id,NEW.top_elev,NEW.ymax,NEW.sander,NEW.node_type,NEW.nodecat_id,NEW.epa_type, NEW.sector_id,NEW."state",NEW.annotation,NEW.observ,NEW."comment",NEW.dma_id,NEW.soilcat_id,NEW.category_type,NEW.fluid_type,NEW.location_type,NEW.workcat_id,NEW.buildercat_id,NEW.builtdate,NEW.ownercat_id,NEW.adress_01,NEW.adress_02, NEW.adress_03,NEW.descript,NEW.est_top_elev,NEW.est_ymax,NEW.rotation,NEW.link,NEW.verified,NEW.workcat_id_end,NEW.undelete,NEW.label_x,NEW.label_y,NEW.label_rotation,NEW.the_geom);
				
			IF (rec.insert_double_geometry IS TRUE) THEN
				IF (NEW.pol_id IS NULL) THEN
					NEW.pol_id:= (SELECT nextval('pol_id_seq'));
				END IF;
				
				INSERT INTO man_netgully (node_id,pol_id,add_info) VALUES(NEW.node_id, NEW.pol_id,NEW.add_info);
				INSERT INTO polygon(pol_id,the_geom) VALUES (NEW.pol_id,(SELECT ST_Envelope(ST_Buffer(node.the_geom,rec.buffer_value)) from "SCHEMA_NAME".node where node_id=NEW.node_id));
			
			ELSE
				INSERT INTO man_netgully (node_id,add_info) VALUES(NEW.node_id,NEW.add_info);
			END IF;	

			
		ELSIF man_table='man_storage_pol' THEN
			INSERT INTO node (node_id,top_elev,ymax,sander,node_type,nodecat_id,epa_type,sector_id,"state",annotation,observ,"comment",dma_id,soilcat_id,category_type,fluid_type,location_type,workcat_id,buildercat_id,builtdate,ownercat_id,	adress_01,adress_02,adress_03,descript,est_top_elev,est_ymax,rotation,link,verified,workcat_id_end,undelete,label_x,label_y,label_rotation) VALUES (NEW.node_id,NEW.top_elev,NEW.ymax,NEW.sander,NEW.node_type,NEW.nodecat_id,NEW.epa_type, NEW.sector_id,NEW."state",NEW.annotation,NEW.observ,NEW."comment",NEW.dma_id,NEW.soilcat_id,NEW.category_type,NEW.fluid_type,NEW.location_type,NEW.workcat_id,NEW.buildercat_id,NEW.builtdate,NEW.ownercat_id,NEW.adress_01,NEW.adress_02, NEW.adress_03,NEW.descript,NEW.est_top_elev,NEW.est_ymax,NEW.rotation,NEW.link,NEW.verified,NEW.workcat_id_end,NEW.undelete,NEW.label_x,NEW.label_y,NEW.label_rotation);						
			
			IF (rec.insert_double_geometry IS TRUE) THEN
				IF (NEW.pol_id IS NULL) THEN
					NEW.pol_id:= (SELECT nextval('pol_id_seq'));
				END IF;
				
				INSERT INTO man_storage (node_id,pol_id,add_info,total_volumen,util_volumen,min_height,total_height,total_length,total_width,storage_name) VALUES(NEW.node_id, NEW.pol_id,NEW.add_info,NEW.total_volumen,NEW.util_volumen,NEW.min_height,NEW.total_height,NEW.total_length,NEW.total_width,NEW.storage_name);
				INSERT INTO polygon(pol_id,the_geom) VALUES (NEW.pol_id,NEW.the_geom);
				UPDATE node SET the_geom =(SELECT ST_Centroid(polygon.the_geom) FROM "SCHEMA_NAME".polygon where pol_id=NEW.pol_id) WHERE node_id=NEW.node_id;
			END IF;
			 
		ELSIF man_table='man_netgully_pol' THEN
			INSERT INTO node (node_id,top_elev,ymax,sander,node_type,nodecat_id,epa_type,sector_id,"state",annotation,observ,"comment",dma_id,soilcat_id,category_type,fluid_type,location_type,workcat_id,buildercat_id,builtdate,ownercat_id,	adress_01,adress_02,adress_03,descript,est_top_elev,est_ymax,rotation,link,verified,workcat_id_end,undelete,label_x,label_y,label_rotation) VALUES (NEW.node_id,NEW.top_elev,NEW.ymax,NEW.sander,NEW.node_type,NEW.nodecat_id,NEW.epa_type, NEW.sector_id,NEW."state",NEW.annotation,NEW.observ,NEW."comment",NEW.dma_id,NEW.soilcat_id,NEW.category_type,NEW.fluid_type,NEW.location_type,NEW.workcat_id,NEW.buildercat_id,NEW.builtdate,NEW.ownercat_id,NEW.adress_01,NEW.adress_02, NEW.adress_03,NEW.descript,NEW.est_top_elev,NEW.est_ymax,NEW.rotation,NEW.link,NEW.verified,NEW.workcat_id_end,NEW.undelete,NEW.label_x,NEW.label_y,NEW.label_rotation);

			
			IF (rec.insert_double_geometry IS TRUE) THEN
				IF (NEW.pol_id IS NULL) THEN
					NEW.pol_id:= (SELECT nextval('pol_id_seq'));
				END IF;
				
				INSERT INTO man_netgully (node_id,pol_id,add_info) VALUES(NEW.node_id, NEW.pol_id,NEW.add_info);
				INSERT INTO polygon(pol_id,the_geom) VALUES (NEW.pol_id,NEW.the_geom);
				UPDATE node SET the_geom =(SELECT ST_Centroid(polygon.the_geom) FROM "SCHEMA_NAME".polygon where pol_id=NEW.pol_id) WHERE node_id=NEW.node_id;
				
			END IF;
			
		ELSIF man_table='man_chamber' THEN
			INSERT INTO node (node_id,top_elev,ymax,sander,node_type,nodecat_id,epa_type,sector_id,"state",annotation,observ,"comment",dma_id,soilcat_id,category_type,fluid_type,location_type,workcat_id,buildercat_id,builtdate,ownercat_id,	adress_01,adress_02,adress_03,descript,est_top_elev,est_ymax,rotation,link,verified,workcat_id_end,undelete,label_x,label_y,label_rotation,the_geom) VALUES (NEW.node_id,NEW.top_elev,NEW.ymax,NEW.sander,NEW.node_type,NEW.nodecat_id,NEW.epa_type, NEW.sector_id,NEW."state",NEW.annotation,NEW.observ,NEW."comment",NEW.dma_id,NEW.soilcat_id,NEW.category_type,NEW.fluid_type,NEW.location_type,NEW.workcat_id,NEW.buildercat_id,NEW.builtdate,NEW.ownercat_id,NEW.adress_01,NEW.adress_02, NEW.adress_03,NEW.descript,NEW.est_top_elev,NEW.est_ymax,NEW.rotation,NEW.link,NEW.verified,NEW.workcat_id_end,NEW.undelete,NEW.label_x,NEW.label_y,NEW.label_rotation,NEW.the_geom);	
					
			IF (rec.insert_double_geometry IS TRUE) THEN
				IF (NEW.pol_id IS NULL) THEN
					NEW.pol_id:= (SELECT nextval('pol_id_seq'));
				END IF;
				
				INSERT INTO man_chamber (node_id,add_info,pol_id,total_volumen,total_height,total_length,total_width,chamber_name) VALUES (NEW.node_id,NEW.add_info,NEW.pol_id,NEW.total_volumen,NEW.total_height,NEW.total_length,NEW.total_width,NEW.chamber_name);
				INSERT INTO polygon(pol_id,the_geom) VALUES (NEW.pol_id,(SELECT ST_Envelope(ST_Buffer(node.the_geom,rec.buffer_value)) from "SCHEMA_NAME".node where node_id=NEW.node_id));
			
			ELSE
				INSERT INTO man_chamber (node_id,add_info,pol_id,total_volumen,total_height,total_length,total_width,chamber_name) VALUES (NEW.node_id,NEW.add_info,NEW.pol_id,NEW.total_volumen,NEW.total_height,NEW.total_length,NEW.total_width,NEW.chamber_name);
			END IF;	
			
		ELSIF man_table='man_chamber_pol' THEN
			INSERT INTO node (node_id,top_elev,ymax,sander,node_type,nodecat_id,epa_type,sector_id,"state",annotation,observ,"comment",dma_id,soilcat_id,category_type,fluid_type,location_type,workcat_id,buildercat_id,builtdate,ownercat_id,	adress_01,adress_02,adress_03,descript,est_top_elev,est_ymax,rotation,link,verified,workcat_id_end,undelete,label_x,label_y,label_rotation) VALUES (NEW.node_id,NEW.top_elev,NEW.ymax,NEW.sander,NEW.node_type,NEW.nodecat_id,NEW.epa_type, NEW.sector_id,NEW."state",NEW.annotation,NEW.observ,NEW."comment",NEW.dma_id,NEW.soilcat_id,NEW.category_type,NEW.fluid_type,NEW.location_type,NEW.workcat_id,NEW.buildercat_id,NEW.builtdate,NEW.ownercat_id,NEW.adress_01,NEW.adress_02, NEW.adress_03,NEW.descript,NEW.est_top_elev,NEW.est_ymax,NEW.rotation,NEW.link,NEW.verified,NEW.workcat_id_end,NEW.undelete,NEW.label_x,NEW.label_y,NEW.label_rotation);	
			
			IF (rec.insert_double_geometry IS TRUE) THEN
				IF (NEW.pol_id IS NULL) THEN
					NEW.pol_id:= (SELECT nextval('pol_id_seq'));
				END IF;
				
				INSERT INTO man_chamber (node_id,add_info,pol_id,total_volumen,total_height,total_length,total_width,chamber_name) VALUES (NEW.node_id,NEW.add_info,NEW.pol_id,NEW.total_volumen,NEW.total_height,NEW.total_length,NEW.total_width,NEW.chamber_name);
				INSERT INTO polygon(pol_id,the_geom) VALUES (NEW.pol_id,NEW.the_geom);
				UPDATE node SET the_geom =(SELECT ST_Centroid(polygon.the_geom) FROM "SCHEMA_NAME".polygon where pol_id=NEW.pol_id) WHERE node_id=NEW.node_id;
			END IF;
			
		ELSIF man_table='man_manhole' THEN
			INSERT INTO node (node_id,top_elev,ymax,sander,node_type,nodecat_id,epa_type,sector_id,"state",annotation,observ,"comment",dma_id,soilcat_id,category_type,fluid_type,location_type,workcat_id,buildercat_id,builtdate,ownercat_id,	adress_01,adress_02,adress_03,descript,est_top_elev,est_ymax,rotation,link,verified,workcat_id_end,undelete,label_x,label_y,label_rotation,the_geom) 
			VALUES (NEW.node_id,NEW.top_elev,NEW.ymax,NEW.sander,NEW.node_type,NEW.nodecat_id, NEW.epa_type,NEW.sector_id,NEW."state",NEW.annotation,NEW.observ,NEW."comment",NEW.dma_id,NEW.soilcat_id,NEW.category_type,NEW.fluid_type,NEW.location_type,NEW.workcat_id,NEW.buildercat_id,NEW.builtdate,NEW.ownercat_id,NEW.adress_01, NEW.adress_02,NEW.adress_03,NEW.descript,NEW.est_top_elev,NEW.est_ymax,NEW.rotation,NEW.link,NEW.verified,NEW.workcat_id_end,NEW.undelete,NEW.label_x,NEW.label_y,NEW.label_rotation,NEW.the_geom);

			INSERT INTO man_manhole (node_id,add_info,sander_depth,prot_surface) VALUES (NEW.node_id,NEW.add_info,NEW.sander_depth,NEW.prot_surface);	
		
		ELSIF man_table='man_netinit' THEN
			INSERT INTO node (node_id,top_elev,ymax,sander,node_type,nodecat_id,epa_type,sector_id,"state",annotation,observ,"comment",dma_id,soilcat_id,category_type,fluid_type,location_type,workcat_id,buildercat_id,builtdate,ownercat_id,	adress_01,adress_02,adress_03,descript,est_top_elev,est_ymax,rotation,link,verified,workcat_id_end,undelete,label_x,label_y,label_rotation,the_geom) 
			VALUES (NEW.node_id,NEW.top_elev,NEW.ymax,NEW.sander,NEW.node_type,NEW.nodecat_id, NEW.epa_type,NEW.sector_id,NEW."state",NEW.annotation,NEW.observ,NEW."comment",NEW.dma_id,NEW.soilcat_id,NEW.category_type,NEW.fluid_type,NEW.location_type,NEW.workcat_id,NEW.buildercat_id,NEW.builtdate,NEW.ownercat_id,NEW.adress_01, NEW.adress_02,NEW.adress_03,NEW.descript,NEW.est_top_elev,NEW.est_ymax,NEW.rotation,NEW.link,NEW.verified,NEW.workcat_id_end,NEW.undelete,NEW.label_x,NEW.label_y,NEW.label_rotation,NEW.the_geom);

			INSERT INTO man_netinit (node_id,add_info,mheight,mlength,mwidth,netinit_name) VALUES (NEW.node_id,NEW.add_info,NEW.mheight,NEW.mlength,NEW.mwidth,NEW.netinit_name);	
			
		ELSIF man_table='man_wjump' THEN
			INSERT INTO node (node_id,top_elev,ymax,sander,node_type,nodecat_id,epa_type,sector_id,"state",annotation,observ,"comment",dma_id,soilcat_id,category_type,fluid_type,location_type,workcat_id,buildercat_id,builtdate,ownercat_id,	adress_01,adress_02,adress_03,descript,est_top_elev,est_ymax,rotation,link,verified,workcat_id_end,undelete,label_x,label_y,label_rotation,the_geom) 
			VALUES (NEW.node_id,NEW.top_elev,NEW.ymax,NEW.sander,NEW.node_type,NEW.nodecat_id, NEW.epa_type,NEW.sector_id,NEW."state",NEW.annotation,NEW.observ,NEW."comment",NEW.dma_id,NEW.soilcat_id,NEW.category_type,NEW.fluid_type,NEW.location_type,NEW.workcat_id,NEW.buildercat_id,NEW.builtdate,NEW.ownercat_id,NEW.adress_01, NEW.adress_02,NEW.adress_03,NEW.descript,NEW.est_top_elev,NEW.est_ymax,NEW.rotation,NEW.link,NEW.verified,NEW.workcat_id_end,NEW.undelete,NEW.label_x,NEW.label_y,NEW.label_rotation,NEW.the_geom);

			INSERT INTO man_wjump (node_id,add_info,mheight,mlength,mwidth,sander_length,sander_depth,security_bar,steps,prot_surface,wjump_name) VALUES (NEW.node_id,NEW.add_info,NEW.mheight,NEW.mlength,NEW.mwidth,NEW.sander_length,NEW.sander_depth,NEW.security_bar,NEW.steps,NEW.prot_surface,NEW.wjump_name);	
		
		ELSIF man_table='man_wwtp' THEN
			INSERT INTO node (node_id,top_elev,ymax,sander,node_type,nodecat_id,epa_type,sector_id,"state",annotation,observ,"comment",dma_id,soilcat_id,category_type,fluid_type,location_type,workcat_id,buildercat_id,builtdate,ownercat_id,	adress_01,adress_02,adress_03,descript,est_top_elev,est_ymax,rotation,link,verified,workcat_id_end,undelete,label_x,label_y,label_rotation,the_geom) 
			VALUES (NEW.node_id,NEW.top_elev,NEW.ymax,NEW.sander,NEW.node_type,NEW.nodecat_id, NEW.epa_type,NEW.sector_id,NEW."state",NEW.annotation,NEW.observ,NEW."comment",NEW.dma_id,NEW.soilcat_id,NEW.category_type,NEW.fluid_type,NEW.location_type,NEW.workcat_id,NEW.buildercat_id,NEW.builtdate,NEW.ownercat_id,NEW.adress_01, NEW.adress_02,NEW.adress_03,NEW.descript,NEW.est_top_elev,NEW.est_ymax,NEW.rotation,NEW.link,NEW.verified,NEW.workcat_id_end,NEW.undelete,NEW.label_x,NEW.label_y,NEW.label_rotation,NEW.the_geom);

			IF (rec.insert_double_geometry IS TRUE) THEN
				IF (NEW.pol_id IS NULL) THEN
					NEW.pol_id:= (SELECT nextval('pol_id_seq'));
				END IF;
				
				INSERT INTO man_wwtp (node_id,add_info,pol_id,wwtp_name) VALUES (NEW.node_id,NEW.add_info,NEW.pol_id,NEW.wwtp_name);
				INSERT INTO polygon(pol_id,the_geom) VALUES (NEW.pol_id,(SELECT ST_Envelope(ST_Buffer(node.the_geom,rec.buffer_value)) from "SCHEMA_NAME".node where node_id=NEW.node_id));
			
			ELSE
				INSERT INTO man_wwtp (node_id,add_info,wwtp_name) VALUES (NEW.node_id,NEW.add_info,NEW.wwtp_name);
			END IF;	
			
		ELSIF man_table='man_wwtp_pol' THEN
			INSERT INTO node (node_id,top_elev,ymax,sander,node_type,nodecat_id,epa_type,sector_id,"state",annotation,observ,"comment",dma_id,soilcat_id,category_type,fluid_type,location_type,workcat_id,buildercat_id,builtdate,ownercat_id,	adress_01,adress_02,adress_03,descript,est_top_elev,est_ymax,rotation,link,verified,workcat_id_end,undelete,label_x,label_y,label_rotation) 
			VALUES (NEW.node_id,NEW.top_elev,NEW.ymax,NEW.sander,NEW.node_type,NEW.nodecat_id, NEW.epa_type,NEW.sector_id,NEW."state",NEW.annotation,NEW.observ,NEW."comment",NEW.dma_id,NEW.soilcat_id,NEW.category_type,NEW.fluid_type,NEW.location_type,NEW.workcat_id,NEW.buildercat_id,NEW.builtdate,NEW.ownercat_id,NEW.adress_01, NEW.adress_02,NEW.adress_03,NEW.descript,NEW.est_top_elev,NEW.est_ymax,NEW.rotation,NEW.link,NEW.verified,NEW.workcat_id_end,NEW.undelete,NEW.label_x,NEW.label_y,NEW.label_rotation);	
			
			IF (rec.insert_double_geometry IS TRUE) THEN
				IF (NEW.pol_id IS NULL) THEN
					NEW.pol_id:= (SELECT nextval('pol_id_seq'));
				END IF;
				
				INSERT INTO man_wwtp (node_id,add_info,pol_id,wwtp_name) VALUES (NEW.node_id,NEW.add_info,NEW.pol_id,NEW.wwtp_name);
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

          
        --PERFORM audit_function (1,810);
        RETURN NEW;


    ELSIF TG_OP = 'UPDATE' THEN

/*
	IF (NEW.elev <> OLD.elev) THEN
                RETURN audit_function(200,810);  
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
				v_sql:= 'INSERT INTO '||new_man_table||' (node_id) VALUES ('||quote_literal(NEW.node_id)||')';
				EXECUTE v_sql;
			END IF;
		END IF;

        UPDATE node 
        SET node_id=NEW.node_id, top_elev=NEW.top_elev, ymax=NEW.ymax, sander=NEW.sander, node_type=NEW.node_type, nodecat_id=NEW.nodecat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, "state"=NEW."state", 
            annotation=NEW.annotation, "observ"=NEW."observ", "comment"=NEW."comment", dma_id=NEW.dma_id, soilcat_id=NEW.soilcat_id, category_type=NEW.category_type,fluid_type=NEW.fluid_type, 
            location_type=NEW.location_type, workcat_id=NEW.workcat_id, buildercat_id=NEW.buildercat_id, builtdate=NEW.builtdate,ownercat_id=NEW.ownercat_id, adress_01=NEW.adress_01, 
            adress_02=NEW.adress_02, adress_03=NEW.adress_03, descript=NEW.descript,est_top_elev=NEW.est_top_elev, est_ymax=NEW.est_ymax, rotation=NEW.rotation, link=NEW.link, 
            verified=NEW.verified
        WHERE node_id = OLD.node_id;
		
        
		IF man_table ='man_junction' THEN
            UPDATE man_junction SET node_id=NEW.node_id, add_info=NEW.add_info
			WHERE node_id=OLD.node_id;
			UPDATE node SET the_geom=NEW.the_geom
			WHERE node_id=OLD.node_id;
			
		ELSIF man_table='man_netgully' THEN
			UPDATE man_netgully SET node_id=NEW.node_id, pol_id=NEW.pol_id, add_info=NEW.add_info
			WHERE node_id=OLD.node_id;
			UPDATE node SET the_geom=NEW.the_geom
			WHERE node_id=OLD.node_id;
			
		ELSIF man_table='man_netgully_pol' THEN
			IF (NEW.pol_id IS NULL) THEN
				UPDATE man_netgully SET node_id=NEW.node_id, pol_id=NEW.pol_id,add_info=NEW.add_info
				WHERE node_id=OLD.node_id;
				UPDATE polygon SET the_geom=NEW.the_geom
				WHERE pol_id=OLD.pol_id;
			ELSE
				UPDATE man_netgully SET node_id=NEW.node_id, pol_id=NEW.pol_id,add_info=NEW.add_info
				WHERE node_id=OLD.node_id;
				UPDATE polygon SET the_geom=NEW.the_geom,pol_id=NEW.pol_id
				WHERE pol_id=OLD.pol_id;
			END IF;
			
		ELSIF man_table='man_outfall' THEN
			UPDATE man_outfall SET node_id=NEW.node_id, add_info=NEW.add_info, outfall_name=NEW.outfall_name
			WHERE node_id=OLD.node_id;
			UPDATE node SET the_geom=NEW.the_geom
			WHERE node_id=OLD.node_id;
			
		ELSIF man_table='man_storage' THEN
			UPDATE man_storage SET node_id=NEW.node_id, pol_id=NEW.pol_id, add_info=NEW.add_info,total_volumen=NEW.total_volumen,util_volumen=NEW.util_volumen,min_height=NEW.min_height,total_height=NEW.total_height,total_length=NEW.total_length,total_width=NEW.total_width,storage_name=NEW.storage_name
			WHERE node_id=OLD.node_id;
			UPDATE node SET the_geom=NEW.the_geom
			WHERE node_id=OLD.node_id;
			
		ELSIF man_table='man_storage_pol' THEN
			IF (NEW.pol_id IS NULL) THEN
				UPDATE man_storage SET node_id=NEW.node_id, pol_id=NEW.pol_id, add_info=NEW.add_info,total_volumen=NEW.total_volumen,util_volumen=NEW.util_volumen,min_height=NEW.min_height,total_height=NEW.total_height,total_length=NEW.total_length,total_width=NEW.total_width,storage_name=NEW.storage_name
				WHERE node_id=OLD.node_id;
				UPDATE polygon SET the_geom=NEW.the_geom
				WHERE pol_id=OLD.pol_id;
			ELSE
				UPDATE man_storage SET node_id=NEW.node_id, pol_id=NEW.pol_id, add_info=NEW.add_info,total_volumen=NEW.total_volumen,util_volumen=NEW.util_volumen,min_height=NEW.min_height,total_height=NEW.total_height,total_length=NEW.total_length,total_width=NEW.total_width,storage_name=NEW.storage_name
				WHERE node_id=OLD.node_id;
				UPDATE polygon SET the_geom=NEW.the_geom,pol_id=NEW.pol_id
				WHERE pol_id=OLD.pol_id;
			END IF;

		ELSIF man_table='man_valve' THEN
			UPDATE man_valve SET node_id=NEW.node_id,add_info=NEW.add_info, valve_name=NEW.valve_name
			WHERE node_id=OLD.node_id;
			UPDATE node SET the_geom=NEW.the_geom
			WHERE node_id=OLD.node_id;
		
		ELSIF man_table='man_chamber' THEN
			UPDATE man_chamber SET node_id=NEW.node_id, pol_id=NEW.pol_id, add_info=NEW.add_info,total_volumen=NEW.total_volumen,total_height=NEW.total_height,total_length=NEW.total_length,total_width=NEW.total_width,chamber_name=NEW.chamber_name
			WHERE node_id=OLD.node_id;
			UPDATE node SET the_geom=NEW.the_geom
			WHERE node_id=OLD.node_id;
			
		ELSIF man_table='man_chamber_pol' THEN
			IF (NEW.pol_id IS NULL) THEN
				UPDATE man_chamber SET node_id=NEW.node_id, pol_id=NEW.pol_id, add_info=NEW.add_info,total_volumen=NEW.total_volumen,total_height=NEW.total_height,total_length=NEW.total_length,total_width=NEW.total_width,chamber_name=NEW.chamber_name
				WHERE node_id=OLD.node_id;
				UPDATE polygon SET the_geom=NEW.the_geom
				WHERE pol_id=OLD.pol_id;
			ELSE
				UPDATE man_chamber SET node_id=NEW.node_id, pol_id=NEW.pol_id, add_info=NEW.add_info,total_volumen=NEW.total_volumen,total_height=NEW.total_height,total_length=NEW.total_length,total_width=NEW.total_width,chamber_name=NEW.chamber_name
				WHERE node_id=OLD.node_id;
				UPDATE polygon SET the_geom=NEW.the_geom,pol_id=NEW.pol_id
				WHERE pol_id=OLD.pol_id;
			END IF;	
			
		ELSIF man_table='man_manhole' THEN
			UPDATE man_manhole SET node_id=NEW.node_id,add_info=NEW.add_info, sander_depth=NEW.sander_depth, prot_surface=NEW.prot_surface
			WHERE node_id=OLD.node_id;
			UPDATE node SET the_geom=NEW.the_geom
			WHERE node_id=OLD.node_id;
			
		ELSIF man_table='man_netinit' THEN
			UPDATE man_netinit SET node_id=NEW.node_id,add_info=NEW.add_info, mheight=NEW.mheight,mlength=NEW.mlength,mwidth=NEW.mwidth,netinit_name=NEW.netinit_name
			WHERE node_id=OLD.node_id;
			UPDATE node SET the_geom=NEW.the_geom
			WHERE node_id=OLD.node_id;
			
			
		ELSIF man_table='man_wjump' THEN
			UPDATE man_wjump SET node_id=NEW.node_id,add_info=NEW.add_info, mheight=NEW.mheight,mlength=NEW.mlength,mwidth=NEW.mwidth,sander_length=NEW.sander_length,sander_depth=NEW.sander_depth,security_bar=NEW.security_bar, steps=NEW.steps,prot_surface=NEW.prot_surface,wjump_name=NEW.wjump_name
			WHERE node_id=OLD.node_id;
			UPDATE node SET the_geom=NEW.the_geom
			WHERE node_id=OLD.node_id;
			
		ELSIF man_table='man_wwtp' THEN
			UPDATE man_wwtp SET node_id=NEW.node_id, pol_id=NEW.pol_id, add_info=NEW.add_info,wwtp_name=NEW.wwtp_name
			WHERE node_id=OLD.node_id;
			UPDATE node SET the_geom=NEW.the_geom
			WHERE node_id=OLD.node_id;
			
		ELSIF man_table='man_wwtp_pol' THEN
			IF (NEW.pol_id IS NULL) THEN
				UPDATE man_wwtp SET node_id=NEW.node_id, pol_id=NEW.pol_id, add_info=NEW.add_info,wwtp_name=NEW.wwtp_name
				WHERE node_id=OLD.node_id;
				UPDATE polygon SET the_geom=NEW.the_geom
				WHERE pol_id=OLD.pol_id;
			ELSE
				UPDATE man_wwtp SET node_id=NEW.node_id, pol_id=NEW.pol_id, add_info=NEW.add_info,wwtp_name=NEW.wwtp_name
				WHERE node_id=OLD.node_id;
				UPDATE polygon SET the_geom=NEW.the_geom,pol_id=NEW.pol_id
				WHERE pol_id=OLD.pol_id;
			END IF;	
		
		
		END IF;
		--PERFORM audit_function (2,810);
        RETURN NEW;
		
		
	
    ELSIF TG_OP = 'DELETE' THEN

	IF man_table ='man_storage_pol' OR man_table ='man_sumidero_pol' THEN
		DELETE FROM polygon WHERE pol_id = OLD.pol_id;
	ELSE
		DELETE FROM node WHERE node_id = OLD.node_id;
	END IF;

		--PERFORM audit_function (3,810);
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