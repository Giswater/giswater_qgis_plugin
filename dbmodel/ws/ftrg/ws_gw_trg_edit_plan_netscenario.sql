/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3274

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_plan_netscenario()  RETURNS trigger AS
$BODY$

DECLARE 
v_newpattern json;
v_status boolean;
v_value text;
v_table text;
BEGIN

	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
	
	v_table = TG_ARGV[0];

	IF TG_OP = 'INSERT' THEN
		
		IF v_table = 'DMA' THEN

			-- dma_id
			IF NEW.dma_id is null THEN
				SELECT max(dma_id) +1 into NEW.dma_id FROM plan_netscenario_dma WHERE netscenario_id = NEW.netscenario_id;
			END IF;

			INSERT INTO plan_netscenario_dma (netscenario_id, dma_id, dma_name, pattern_id, graphconfig, the_geom, active, stylesheet, expl_id, muni_id, sector_id)
			VALUES (NEW.netscenario_id, NEW.dma_id, NEW.name, NEW.pattern_id, NEW.graphconfig::json, NEW.the_geom, NEW.active, NEW.stylesheet::json, NEW.expl_id, NEW.muni_id, NEW.sector_id) ON CONFLICT (netscenario_id, dma_id) DO NOTHING;

		ELSIF v_table = 'PRESSZONE' THEN

			-- presszone_id
			IF NEW.presszone_id is null THEN
				 SELECT max(presszone_id) +1 into NEW.presszone_id FROM plan_netscenario_presszone WHERE netscenario_id = NEW.netscenario_id;
			END IF;

			INSERT INTO plan_netscenario_presszone (netscenario_id, presszone_id, presszone_name, head, graphconfig, the_geom, active, presszone_type, stylesheet, expl_id, muni_id, sector_id)
			VALUES (NEW.netscenario_id, NEW.presszone_id, NEW.name, NEW.head, NEW.graphconfig::json, NEW.the_geom, NEW.active, NEW.presszone_type, NEW.stylesheet::json, NEW.expl_id, NEW.muni_id, NEW.sector_id) ON CONFLICT (netscenario_id, presszone_id) DO NOTHING;

		ELSIF v_table = 'VALVE' THEN

			INSERT INTO plan_netscenario_valve (netscenario_id, node_id, closed)
			VALUES (NEW.netscenario_id, NEW.node_id, NEW.closed) ON CONFLICT (netscenario_id, node_id) DO NOTHING;

		END IF;
		RETURN NEW;
		
	ELSIF TG_OP = 'UPDATE' THEN
   	IF v_table = 'DMA' THEN
			UPDATE plan_netscenario_dma 
			SET dma_id=NEW.dma_id, dma_name=NEW.name,  the_geom=NEW.the_geom, pattern_id=NEW.pattern_id, graphconfig=NEW.graphconfig::json, active=NEW.active, stylesheet=NEW.stylesheet::json, expl_id=NEW.expl_id, muni_id=NEW.muni_id, sector_id=NEW.sector_id
			WHERE dma_id=OLD.dma_id AND netscenario_id=NEW.netscenario_id;
		
		ELSIF v_table = 'PRESSZONE' THEN
			UPDATE plan_netscenario_presszone 
			SET presszone_id=NEW.presszone_id, presszone_name=NEW.name,  the_geom=NEW.the_geom, head=NEW.head, graphconfig=NEW.graphconfig::json, active=NEW.active, presszone_type=NEW.presszone_type, stylesheet=NEW.stylesheet::json, expl_id=NEW.expl_id, muni_id=NEW.muni_id, sector_id=NEW.sector_id
			WHERE presszone_id=OLD.presszone_id AND netscenario_id=NEW.netscenario_id;
		
		ELSIF v_table = 'VALVE' THEN

			UPDATE plan_netscenario_valve SET closed=NEW.closed WHERE netscenario_id = NEW.netscenario_id AND node_id=NEW.node_id;	

		END IF;

		RETURN NEW;
		
	ELSIF TG_OP = 'DELETE' THEN  
	 
	 	IF v_table = 'DMA' THEN
			DELETE FROM plan_netscenario_dma WHERE dma_id = OLD.dma_id;
		ELSIF v_table = 'PRESSZONE' THEN
			DELETE FROM plan_netscenario_presszone WHERE presszone_id = OLD.presszone_id;
		ELSIF v_table = 'VALVE' THEN
			DELETE FROM plan_netscenario_valve WHERE netscenario_id = OLD.netscenario_id AND node_id=OLD.node_id;	
		END IF;

		RETURN NULL;
     
	END IF;

END;
	
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

