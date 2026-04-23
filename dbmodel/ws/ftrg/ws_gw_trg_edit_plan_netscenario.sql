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
	v_table text = TG_ARGV[0];
BEGIN

	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
	
	IF TG_OP = 'INSERT' THEN
		
		IF v_table = 'DMA' THEN

			IF NEW.dma_id != (SELECT last_value FROM urn_id_seq) OR NEW.dma_id IS NULL THEN
				NEW.dma_id = (SELECT nextval('urn_id_seq'));
			END IF;

			INSERT INTO plan_netscenario_dma (netscenario_id, dma_id, name, code, descript, pattern_id, graphconfig, the_geom, active, stylesheet, expl_id, muni_id, sector_id)
			VALUES (NEW.netscenario_id, NEW.dma_id, NEW.name, NEW.code, NEW.descript, NEW.pattern_id, NEW.graphconfig::json, NEW.the_geom, NEW.active, NEW.stylesheet::json, COALESCE(NEW.expl_id, '{0}'), COALESCE(NEW.muni_id, '{0}'), COALESCE(NEW.sector_id, '{0}')) ON CONFLICT (netscenario_id, dma_id) DO NOTHING;

		ELSIF v_table = 'PRESSZONE' THEN

			IF NEW.presszone_id != (SELECT last_value FROM urn_id_seq) OR NEW.presszone_id IS NULL THEN
				NEW.presszone_id = (SELECT nextval('urn_id_seq'));
			END IF;

			INSERT INTO plan_netscenario_presszone (netscenario_id, presszone_id, name, code, descript, head, graphconfig, the_geom, active, presszone_type, stylesheet, expl_id, muni_id, sector_id)
			VALUES (NEW.netscenario_id, NEW.presszone_id, NEW.name, NEW.code, NEW.descript, NEW.head, NEW.graphconfig::json, NEW.the_geom, NEW.active, NEW.presszone_type, NEW.stylesheet::json, COALESCE(NEW.expl_id, '{0}'), COALESCE(NEW.muni_id, '{0}'), COALESCE(NEW.sector_id, '{0}')) ON CONFLICT (netscenario_id, presszone_id) DO NOTHING;

		ELSIF v_table = 'VALVE' THEN

			INSERT INTO plan_netscenario_valve (netscenario_id, node_id, closed)
			VALUES (NEW.netscenario_id, NEW.node_id, NEW.closed) ON CONFLICT (netscenario_id, node_id) DO NOTHING;

		END IF;
		RETURN NEW;
		
	ELSIF TG_OP = 'UPDATE' THEN
   	IF v_table = 'DMA' THEN
			UPDATE plan_netscenario_dma 
			SET dma_id=NEW.dma_id, name=NEW.name, code=NEW.code, descript=NEW.descript, the_geom=NEW.the_geom, pattern_id=NEW.pattern_id, graphconfig=NEW.graphconfig::json, active=NEW.active, stylesheet=NEW.stylesheet::json, expl_id=NEW.expl_id, muni_id=NEW.muni_id, sector_id=NEW.sector_id
			WHERE dma_id=OLD.dma_id AND netscenario_id=NEW.netscenario_id;
		
		ELSIF v_table = 'PRESSZONE' THEN
			UPDATE plan_netscenario_presszone 
			SET presszone_id=NEW.presszone_id, name=NEW.name, code=NEW.code, descript=NEW.descript, the_geom=NEW.the_geom, head=NEW.head, graphconfig=NEW.graphconfig::json, active=NEW.active, presszone_type=NEW.presszone_type, stylesheet=NEW.stylesheet::json, expl_id=NEW.expl_id, muni_id=NEW.muni_id, sector_id=NEW.sector_id
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

