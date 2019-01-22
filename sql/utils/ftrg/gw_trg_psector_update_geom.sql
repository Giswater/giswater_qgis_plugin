/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_plan_psector_geom()
  RETURNS trigger AS
$BODY$

DECLARE 
    
polygon_aux geometry;
epsg_val integer;
collect_aux geometry;
x1 double precision;
y1 double precision;
x2 double precision;
y2 double precision;
xm double precision;
ym double precision;
xd double precision;
yd double precision;
wfactor_vdefault double precision;
wfactor_real  double precision;
psector_type_aux text;


BEGIN 

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
	psector_type_aux:= TG_ARGV[0];

	SELECT epsg INTO epsg_val FROM version LIMIT 1;
	
	IF TG_OP='INSERT' OR TG_OP='UPDATE' THEN

		-- Looking for new feature and calculating the aggregated geom
		IF psector_type_aux='plan' THEN
			SELECT st_collect(f.the_geom) INTO collect_aux 
			FROM ( select the_geom from arc join plan_psector_x_arc ON plan_psector_x_arc.arc_id=arc.arc_id where psector_id=NEW.psector_id UNION
			select the_geom from node join plan_psector_x_node ON plan_psector_x_node.node_id=node.node_id where psector_id=NEW.psector_id) f;
		
		ELSIF psector_type_aux='om' THEN
			SELECT st_collect(f.the_geom) INTO collect_aux 
			FROM ( select the_geom from arc join om_psector_x_arc ON om_psector_x_arc.arc_id=arc.arc_id where psector_id=NEW.psector_id UNION
			select the_geom from node join om_psector_x_node ON om_psector_x_node.node_id=node.node_id where psector_id=NEW.psector_id) f;

		END IF;
		
		x1=st_xmax(collect_aux)+5;
		y1=st_ymax(collect_aux)+5;
		x2=st_xmin(collect_aux)-5;
		y2=st_ymin(collect_aux)-5;
		ym=(y1+y2)/2;
		yd=(y1-y2)/2;
		xm=(x1+x2)/2;
		xd=(x1-x2)/2;
		
		-- armonize the boundary box of aggregated geom using wfactor parameter
		IF (x1-x2)>0 THEN
			wfactor_vdefault:=(SELECT "value" FROM config_param_user WHERE "parameter"='psector_wfactor_vdefault' AND "cur_user"="current_user"() LIMIT 1);
			wfactor_real=xd/yd;
			IF (wfactor_real>wfactor_vdefault) THEN
				y1=ym+yd*wfactor_real/wfactor_vdefault;
				y2=ym-yd*wfactor_real/wfactor_vdefault;
				
			ELSIF (wfactor_real<wfactor_vdefault AND xd>yd) THEN
				x1=xm-xd*wfactor_vdefault/wfactor_real;
				x2=xm+xd*wfactor_vdefault/wfactor_real;

			ELSIF (wfactor_real<wfactor_vdefault AND xd<yd AND (1/wfactor_real)<wfactor_vdefault) THEN
				y1=ym+yd*wfactor_real*wfactor_vdefault;
				y2=ym-yd*wfactor_real*wfactor_vdefault;

			ELSIF (wfactor_real<wfactor_vdefault AND xd<yd AND (1/wfactor_real)>wfactor_vdefault) THEN
				x1=xm-xd/(wfactor_real*wfactor_vdefault);
				x2=xm+xd/(wfactor_real*wfactor_vdefault);
			END IF;
		END IF;

		-- Calculate boundary box of aggregated geom
		polygon_aux=st_collect(ST_MakeEnvelope(x1,y1,x2,y2, epsg_val));
		

		-- update values on psector tables
		IF psector_type_aux='plan' THEN
			
			--update rotation field
			IF (x1-x2)<(y1-y2) then 
				UPDATE plan_psector SET rotation=90 where psector_id=NEW.psector_id;
			ELSE 
				UPDATE plan_psector SET rotation=0 where psector_id=NEW.psector_id;
			END IF;
			
			-- Update geometry field
			UPDATE plan_psector SET the_geom=polygon_aux WHERE psector_id=NEW.psector_id;
		
		ELSIF psector_type_aux='om' THEN
			
			--update rotation field
			IF (x1-x2)<(y1-y2) then 
				UPDATE om_psector SET rotation=90 where psector_id=NEW.psector_id;
			ELSE 
				UPDATE om_psector SET rotation=0 where psector_id=NEW.psector_id;
			END IF;
			
			-- Update geometry field
			UPDATE om_psector SET the_geom=polygon_aux WHERE psector_id=NEW.psector_id;
		
		END IF;

		RETURN NEW;
		
	ELSE 

		-- Looking for new feature and calculating the aggregated geom
		IF psector_type_aux='plan' THEN
			SELECT st_collect(f.the_geom) INTO collect_aux 
			FROM ( select the_geom from arc join plan_psector_x_arc ON plan_psector_x_arc.arc_id=arc.arc_id where psector_id=OLD.psector_id UNION
			select the_geom from node join plan_psector_x_node ON plan_psector_x_node.node_id=node.node_id where psector_id=OLD.psector_id) f;
		
		ELSIF psector_type_aux='om' THEN
			SELECT st_collect(f.the_geom) INTO collect_aux 
			FROM ( select the_geom from arc join om_psector_x_arc ON om_psector_x_arc.arc_id=arc.arc_id where psector_id=OLD.psector_id UNION
			select the_geom from node join om_psector_x_node ON om_psector_x_node.node_id=node.node_id where psector_id=OLD.psector_id) f;

		END IF;
		
		x1=st_xmax(collect_aux)+5;
		y1=st_ymax(collect_aux)+5;
		x2=st_xmin(collect_aux)-5;
		y2=st_ymin(collect_aux)-5;
		ym=(y1+y2)/2;
		yd=(y1-y2)/2;
		xm=(x1+x2)/2;
		xd=(x1-x2)/2;
		
		-- armonize the boundary box of aggregated geom using wfactor parameter
		IF (x1-x2)>0 THEN
			wfactor_vdefault:=(SELECT "value" FROM config_param_user WHERE "parameter"='psector_wfactor_vdefault' AND "cur_user"="current_user"() LIMIT 1);
			wfactor_real=xd/yd;
			IF (wfactor_real>wfactor_vdefault) THEN
				y1=ym+yd*wfactor_real/wfactor_vdefault;
				y2=ym-yd*wfactor_real/wfactor_vdefault;
				
			ELSIF (wfactor_real<wfactor_vdefault AND xd>yd) THEN
				x1=xm-xd*wfactor_vdefault/wfactor_real;
				x2=xm+xd*wfactor_vdefault/wfactor_real;

			ELSIF (wfactor_real<wfactor_vdefault AND xd<yd AND (1/wfactor_real)<wfactor_vdefault) THEN
				y1=ym+yd*wfactor_real*wfactor_vdefault;
				y2=ym-yd*wfactor_real*wfactor_vdefault;

			ELSIF (wfactor_real<wfactor_vdefault AND xd<yd AND (1/wfactor_real)>wfactor_vdefault) THEN
				x1=xm-xd/(wfactor_real*wfactor_vdefault);
				x2=xm+xd/(wfactor_real*wfactor_vdefault);
			END IF;
		END IF;

		-- Calculate boundary box of aggregated geom
		polygon_aux=st_collect(ST_MakeEnvelope(x1,y1,x2,y2, epsg_val));
		

		-- update values on psector tables
		IF psector_type_aux='plan' THEN
			
			--update rotation field
			IF (x1-x2)<(y1-y2) then 
				UPDATE plan_psector SET rotation=90 where psector_id=OLD.psector_id;
			ELSE 
				UPDATE plan_psector SET rotation=0 where psector_id=OLD.psector_id;
			END IF;
			
			-- Update geometry field
			UPDATE plan_psector SET the_geom=polygon_aux WHERE psector_id=OLD.psector_id;
		
		ELSIF psector_type_aux='om' THEN
			
			--update rotation field
			IF (x1-x2)<(y1-y2) then 
				UPDATE om_psector SET rotation=90 where psector_id=OLD.psector_id;
			ELSE 
				UPDATE om_psector SET rotation=0 where psector_id=OLD.psector_id;
			END IF;
			
			-- Update geometry field
			UPDATE om_psector SET the_geom=polygon_aux WHERE psector_id=OLD.psector_id;
		
		END IF;

		RETURN OLD;
	END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
  
