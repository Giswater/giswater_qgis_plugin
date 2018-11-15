/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2444


CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_audit_log_feature()
  RETURNS trigger AS
$BODY$
DECLARE
project_type_aux varchar;

BEGIN

	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
	
	SELECT wsoftware INTO project_type_aux FROM version LIMIT 1;

	-- ARC
		
	IF OLD.feature_type = 'ARC' THEN
		IF TG_OP = 'DELETE' THEN
			INSERT INTO audit_log_feature (fprocesscat_id,feature_type,log_message,feature_id,code,state ,state_type ,observ ,comment ,function_type,category_type ,fluid_type ,location_type,workcat_id,workcat_id_end ,buildercat_id ,builtdate ,enddate,
							ownercat_id ,link ,verified,the_geom_line,undelete,label_x,label_y,label_rotation,publish,inventory,expl_id)
			SELECT 17,OLD.feature_type,'DELETED',OLD.arc_id,OLD.code,OLD.state ,OLD.state_type ,OLD.observ ,OLD.comment ,OLD.function_type,OLD.category_type ,OLD.fluid_type,OLD.location_type,OLD.workcat_id,OLD.workcat_id_end ,OLD.buildercat_id ,OLD.builtdate,
							OLD.enddate ,OLD.ownercat_id,OLD.link,OLD.verified,OLD.the_geom,OLD.undelete,OLD.label_x,OLD.label_y,OLD.label_rotation,OLD.publish,OLD.inventory,OLD.expl_id
			FROM arc WHERE arc_id=OLD.arc_id;
			RETURN OLD;
			
		ELSIF TG_OP = 'UPDATE' THEN
			INSERT INTO audit_log_feature (fprocesscat_id,feature_type,log_message,feature_id,code,state ,state_type ,observ ,comment ,function_type,category_type ,fluid_type ,location_type,workcat_id,workcat_id_end ,buildercat_id ,builtdate ,enddate,
							ownercat_id ,link ,verified,the_geom_line,undelete,label_x,label_y,label_rotation,publish,inventory,expl_id)
			SELECT 17,OLD.feature_type,'UPDATED',OLD.arc_id,OLD.code,OLD.state ,OLD.state_type ,OLD.observ ,OLD.comment ,OLD.function_type,OLD.category_type ,OLD.fluid_type,OLD.location_type,OLD.workcat_id,OLD.workcat_id_end ,OLD.buildercat_id ,OLD.builtdate,
							OLD.enddate ,OLD.ownercat_id,OLD.link,OLD.verified,OLD.the_geom,OLD.undelete,OLD.label_x,OLD.label_y,OLD.label_rotation,OLD.publish,OLD.inventory,OLD.expl_id
			FROM arc WHERE OLD.arc_id = arc_id;
			RETURN OLD;
		END IF;
	

	-- NODE
	
	ELSIF OLD.feature_type = 'NODE' THEN
		IF TG_OP = 'DELETE' THEN
			INSERT INTO audit_log_feature (fprocesscat_id,feature_type,log_message,feature_id,code,state ,state_type ,observ ,comment ,function_type,category_type ,fluid_type ,location_type,workcat_id,workcat_id_end ,buildercat_id ,builtdate ,enddate,
							ownercat_id ,link ,verified,the_geom_point,undelete,label_x,label_y,label_rotation,publish,inventory,expl_id)
			SELECT 17,OLD.feature_type,'DELETED',OLD.node_id,OLD.code,OLD.state ,OLD.state_type ,OLD.observ ,OLD.comment ,OLD.function_type,OLD.category_type ,OLD.fluid_type,OLD.location_type,OLD.workcat_id,OLD.workcat_id_end ,OLD.buildercat_id ,OLD.builtdate,
							OLD.enddate ,OLD.ownercat_id,OLD.link,OLD.verified,OLD.the_geom,OLD.undelete,OLD.label_x,OLD.label_y,OLD.label_rotation,OLD.publish,OLD.inventory,OLD.expl_id	
			FROM node WHERE node_id=OLD.node_id;
			RETURN OLD;

		ELSIF TG_OP = 'UPDATE' THEN
			INSERT INTO audit_log_feature (fprocesscat_id,feature_type,log_message,feature_id,code,state ,state_type ,observ ,comment ,function_type,category_type ,fluid_type ,location_type,workcat_id,workcat_id_end ,buildercat_id ,builtdate ,enddate,
							ownercat_id ,link ,verified,the_geom_point,undelete,label_x,label_y,label_rotation,publish,inventory,expl_id)
			SELECT 17,OLD.feature_type,'UPDATED',OLD.node_id,OLD.code,OLD.state ,OLD.state_type ,OLD.observ ,OLD.comment ,OLD.function_type,OLD.category_type ,OLD.fluid_type,OLD.location_type,OLD.workcat_id,OLD.workcat_id_end ,OLD.buildercat_id ,OLD.builtdate,
							OLD.enddate ,OLD.ownercat_id,OLD.link,OLD.verified,OLD.the_geom,OLD.undelete,OLD.label_x,OLD.label_y,OLD.label_rotation,OLD.publish,OLD.inventory,OLD.expl_id
			FROM node WHERE node_id=OLD.node_id;
			RETURN OLD;
		END IF;
		

	-- CONNEC
	
	ELSIF OLD.feature_type = 'CONNEC' THEN
		IF TG_OP = 'DELETE' THEN
			INSERT INTO audit_log_feature (fprocesscat_id,feature_type,log_message,feature_id,code,state ,state_type ,observ ,comment ,function_type,category_type ,fluid_type ,location_type,workcat_id,workcat_id_end ,buildercat_id ,builtdate ,enddate,
							ownercat_id ,link ,verified,the_geom_point,undelete,label_x,label_y,label_rotation,publish,inventory,expl_id)
			SELECT 17,OLD.feature_type,'DELETED',OLD.connec_id,OLD.code,OLD.state ,OLD.state_type ,OLD.observ ,OLD.comment ,OLD.function_type,OLD.category_type ,OLD.fluid_type,OLD.location_type,OLD.workcat_id,OLD.workcat_id_end ,OLD.buildercat_id ,OLD.builtdate,
							OLD.enddate ,OLD.ownercat_id,OLD.link,OLD.verified,OLD.the_geom,OLD.undelete,OLD.label_x,OLD.label_y,OLD.label_rotation,OLD.publish,OLD.inventory,OLD.expl_id
			FROM connec WHERE connec_id=OLD.connec_id;
			RETURN OLD;

		ELSIF TG_OP = 'UPDATE' THEN
			INSERT INTO audit_log_feature (fprocesscat_id,feature_type,log_message,feature_id,code,state ,state_type ,observ ,comment ,function_type,category_type ,fluid_type ,location_type,workcat_id,workcat_id_end ,buildercat_id ,builtdate ,enddate,
							ownercat_id ,link ,verified,the_geom_point,undelete,label_x,label_y,label_rotation,publish,inventory,expl_id)
			SELECT 17,OLD.feature_type,'UPDATED',OLD.connec_id,OLD.code,OLD.state ,OLD.state_type ,OLD.observ ,OLD.comment ,OLD.function_type,OLD.category_type ,OLD.fluid_type,OLD.location_type,OLD.workcat_id,OLD.workcat_id_end ,OLD.buildercat_id ,OLD.builtdate,
							OLD.enddate ,OLD.ownercat_id,OLD.link,OLD.verified,OLD.the_geom,OLD.undelete,OLD.label_x,OLD.label_y,OLD.label_rotation,OLD.publish,OLD.inventory,OLD.expl_id
			FROM connec WHERE connec_id=OLD.connec_id;
			RETURN OLD;
		END IF;
		

	-- ELEMENT
	
	ELSIF OLD.feature_type = 'ELEMENT' THEN
		IF TG_OP = 'DELETE' THEN
			INSERT INTO audit_log_feature (fprocesscat_id,feature_type,log_message,feature_id,code,state ,state_type ,observ ,comment ,function_type,category_type ,fluid_type ,location_type,workcat_id,workcat_id_end ,buildercat_id ,builtdate ,enddate,
							ownercat_id ,link ,verified,the_geom_point,undelete,label_x,label_y,label_rotation,publish,inventory,expl_id)
			SELECT 17,OLD.feature_type,'DELETED',OLD.element_id,OLD.code,OLD.state ,OLD.state_type ,OLD.observ ,OLD.comment ,OLD.function_type,OLD.category_type ,OLD.fluid_type,OLD.location_type,OLD.workcat_id,OLD.workcat_id_end ,OLD.buildercat_id ,OLD.builtdate,
							OLD.enddate ,OLD.ownercat_id,OLD.link,OLD.verified,OLD.the_geom,OLD.undelete,OLD.label_x,OLD.label_y,OLD.label_rotation,OLD.publish,OLD.inventory,OLD.expl_id
			FROM element WHERE element_id=OLD.element_id;
			RETURN OLD;

		ELSIF TG_OP = 'UPDATE' THEN
			INSERT INTO audit_log_feature (fprocesscat_id,feature_type,log_message,feature_id,code,state ,state_type ,observ ,comment ,function_type,category_type ,fluid_type ,location_type,workcat_id,workcat_id_end ,buildercat_id ,builtdate ,enddate,
							ownercat_id ,link ,verified,the_geom_point,undelete,label_x,label_y,label_rotation,publish,inventory,expl_id)
			SELECT 17,OLD.feature_type,'UPDATED',OLD.element_id,OLD.code,OLD.state ,OLD.state_type ,OLD.observ ,OLD.comment ,OLD.function_type,OLD.category_type ,OLD.fluid_type,OLD.location_type,OLD.workcat_id,OLD.workcat_id_end ,OLD.buildercat_id ,OLD.builtdate,
							OLD.enddate ,OLD.ownercat_id,OLD.link,OLD.verified,OLD.the_geom,OLD.undelete,OLD.label_x,OLD.label_y,OLD.label_rotation,OLD.publish,OLD.inventory,OLD.expl_id
			FROM element WHERE element_id=OLD.element_id;
			RETURN OLD;
		END IF;
	
	END IF;
	
	IF project_type_aux='UD' AND OLD.feature_type = 'GULLY' THEN
		IF TG_OP = 'DELETE' THEN
			INSERT INTO audit_log_feature (fprocesscat_id,feature_type,log_message,feature_id,code,state ,state_type ,observ ,comment ,function_type,category_type ,fluid_type ,location_type,workcat_id,workcat_id_end ,buildercat_id ,builtdate ,enddate,
						ownercat_id ,link ,verified,the_geom_point,undelete,label_x,label_y,label_rotation,publish,inventory,expl_id)
			SELECT 17,OLD.feature_type,'DELETED',OLD.gully_id,OLD.code,OLD.state ,OLD.state_type ,OLD.observ ,OLD.comment ,OLD.function_type,OLD.category_type ,OLD.fluid_type,OLD.location_type,OLD.workcat_id,OLD.workcat_id_end ,OLD.buildercat_id ,OLD.builtdate,
							OLD.enddate ,OLD.ownercat_id,OLD.link,OLD.verified,OLD.the_geom,OLD.undelete,OLD.label_x,OLD.label_y,OLD.label_rotation,OLD.publish,OLD.inventory,OLD.expl_id
			FROM gully WHERE gully_id=OLD.gully_id;
			RETURN OLD;

		ELSIF TG_OP = 'UPDATE' THEN
			INSERT INTO audit_log_feature (fprocesscat_id,feature_type,log_message,feature_id,code,state ,state_type ,observ ,comment ,function_type,category_type ,fluid_type ,location_type,workcat_id,workcat_id_end ,buildercat_id ,builtdate ,enddate,
							ownercat_id ,link ,verified,the_geom_point,undelete,label_x,label_y,label_rotation,publish,inventory,expl_id)
			SELECT 17,OLD.feature_type,'UPDATED',OLD.gully_id,OLD.code,OLD.state ,OLD.state_type ,OLD.observ ,OLD.comment ,OLD.function_type,OLD.category_type ,OLD.fluid_type,OLD.location_type,OLD.workcat_id,OLD.workcat_id_end ,OLD.buildercat_id ,OLD.builtdate,
							OLD.enddate ,OLD.ownercat_id,OLD.link,OLD.verified,OLD.the_geom,OLD.undelete,OLD.label_x,OLD.label_y,OLD.label_rotation,OLD.publish,OLD.inventory,OLD.expl_id
			FROM gully WHERE gully_id=OLD.gully_id;
			RETURN OLD;
		END IF;
	END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION "SCHEMA_NAME".gw_trg_audit_log_feature()
  OWNER TO postgres;
  
