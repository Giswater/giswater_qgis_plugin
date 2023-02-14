/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


--FUNCTION CODE: 3190

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_feature_border()
  RETURNS trigger AS
$BODY$
DECLARE 
	v_count integer;
	rec text;
	v_final_nodes text[];
	v_feature_type text;
	v_node_id text;
BEGIN

  EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

	v_feature_type:= upper(TG_ARGV[0]);

  -- Control insertions ID
  IF TG_OP = 'INSERT' THEN

		INSERT INTO node_border_expl
		WITH 
		arcs AS (SELECT arc_id, node_1, node_2, expl_id FROM arc WHERE state=1 AND arc_id = NEW.arc_id)
		SELECT node_id, a1.expl_id
		FROM node 
		JOIN arcs a1 ON node_id=node_1 
		where a1.expl_id != node.expl_id
		UNION 
		SELECT node_id, a2.expl_id
		FROM node 
		JOIN arcs a2 ON node_id=node_2 
		where a2.expl_id != node.expl_id ON CONFLICT (node_id, expl_id) DO NOTHING RETURNING node_id INTO v_node_id;	

		INSERT INTO node_border_expl
		SELECT n.node_id, e.expl_id
		FROM node  n
		JOIN node_border_expl e ON parent_id = e.node_id
		WHERE parent_id = v_node_id AND n.expl_id != e.expl_id ON CONFLICT (node_id, expl_id) DO NOTHING;

		INSERT INTO arc_border_expl
		SELECT arc_id, e.expl_id
		FROM arc a
		JOIN node_border_expl e ON a.parent_id = e.node_id
		WHERE parent_id = v_node_id AND a.expl_id != e.expl_id ON CONFLICT (arc_id, expl_id) DO NOTHING;

    RETURN NEW;

  ELSIF TG_OP = 'UPDATE' AND v_feature_type = 'ARC' THEN
	raise notice 'arc';
		INSERT INTO node_border_expl
		WITH 
		arcs AS (SELECT arc_id, node_1, node_2, expl_id FROM arc WHERE state=1 AND arc_id = NEW.arc_id)
		SELECT node_id, a1.expl_id
		FROM node 
		JOIN arcs a1 ON node_id=node_1 
		where a1.expl_id != node.expl_id
		UNION 
		SELECT node_id, a2.expl_id
		FROM node 
		JOIN arcs a2 ON node_id=node_2 
		where a2.expl_id != node.expl_id ON CONFLICT (node_id, expl_id) DO NOTHING RETURNING node_id INTO v_node_id;	
		
		INSERT INTO node_border_expl
		SELECT n.node_id,e.expl_id
		FROM node  n
		JOIN node_border_expl e ON parent_id = e.node_id
		WHERE parent_id = v_node_id AND n.expl_id != e.expl_id ON CONFLICT (node_id, expl_id) DO NOTHING;

		INSERT INTO arc_border_expl
		SELECT arc_id, e.expl_id
		FROM arc a
		JOIN node_border_expl e ON a.parent_id = e.node_id
		WHERE parent_id = v_node_id AND a.expl_id != e.expl_id ON CONFLICT (arc_id, expl_id) DO NOTHING;


		v_final_nodes = string_to_array(OLD.node_1,'') ||string_to_array(OLD.node_2,'');
			raise notice 'arcv_final_nodes,%',v_final_nodes;
		IF v_final_nodes IS NOT NULL THEN

			FOREACH rec IN ARRAY (v_final_nodes) LOOP
			raise notice 'arc-rec,%',rec;
				EXECUTE 'WITH 
					arcs AS (SELECT arc_id, node_1, node_2, expl_id FROM arc WHERE state=1 AND  expl_id='||OLD.expl_id||')
					select count(*) from
					(SELECT node_id, a1.expl_id
					FROM node 
					JOIN arcs a1 ON node_id=node_1 
					where a1.expl_id != node.expl_id AND node_id='||quote_literal(rec)||'
					UNION all
					SELECT node_id, a2.expl_id
					FROM node 
					JOIN arcs a2 ON node_id=node_2 
					where a2.expl_id != node.expl_id AND node_id='||quote_literal(rec)||' )a'
					INTO v_count;

raise notice 'arcv_v_count,%',v_count;
		  IF v_count is null OR v_count = 0 THEN
				EXECUTE 'DELETE FROM node_border_expl WHERE node_id='||quote_literal(rec)||' AND expl_id='||OLD.expl_id||'';

				EXECUTE 'DELETE from node_border_expl where node_id in (SELECT node_id FROM node WHERE parent_id='||quote_literal(rec)||') AND expl_id='||OLD.expl_id||'';

				EXECUTE 'DELETE from arc_border_expl where arc_id in (SELECT arc_id FROM arc WHERE parent_id='||quote_literal(rec)||') AND expl_id='||OLD.expl_id||'';

		  END IF;

    	END LOOP;  
	  END IF;
		RETURN NEW;

	ELSIF TG_OP = 'UPDATE' AND v_feature_type = 'NODE' THEN

		DELETE FROM node_border_expl WHERE node_id=OLD.node_id;

		DELETE from node_border_expl where node_id in 
		(SELECT node_id FROM node WHERE parent_id=OLD.node_id);


		INSERT INTO node_border_expl
		WITH 
		arcs AS (SELECT arc_id, node_1, node_2, expl_id FROM arc WHERE state=1)
		SELECT node_id, a1.expl_id
		FROM node 
		JOIN arcs a1 ON node_id=node_1 
		where a1.expl_id != node.expl_id and node_id=NEW.node_id
		UNION 
		SELECT node_id, a2.expl_id
		FROM node 
		JOIN arcs a2 ON node_id=node_2 
		where a2.expl_id != node.expl_id and node_id=NEW.node_id ON CONFLICT (node_id, expl_id) DO NOTHING;	

		INSERT INTO node_border_expl
		SELECT n.node_id,e.expl_id
		FROM node  n
		JOIN node_border_expl e ON parent_id = e.node_id
		WHERE parent_id = v_node_id AND n.expl_id != e.expl_id ON CONFLICT (node_id, expl_id) DO NOTHING;

		INSERT INTO arc_border_expl
		SELECT arc_id, e.expl_id
		FROM arc a
		JOIN node_border_expl e ON a.parent_id = e.node_id
		WHERE parent_id = v_node_id AND a.expl_id != e.expl_id ON CONFLICT (arc_id, expl_id) DO NOTHING;
		
		RETURN NEW;
  ELSIF TG_OP = 'DELETE' THEN
   
		v_final_nodes = string_to_array(OLD.node_1,'') ||string_to_array(OLD.node_2,'');
		
			IF v_final_nodes IS NOT NULL THEN
			FOREACH rec IN ARRAY (v_final_nodes) LOOP

				EXECUTE 'WITH 
					arcs AS (SELECT arc_id, node_1, node_2, expl_id FROM arc WHERE state=1 AND expl_id='||OLD.expl_id||')
					select count(*) from
					(SELECT node_id, a1.expl_id
					FROM node 
					JOIN arcs a1 ON node_id=node_1 
					where a1.expl_id != node.expl_id AND node_id='||quote_literal(rec)||'
					UNION all
					SELECT node_id, a2.expl_id
					FROM node 
					JOIN arcs a2 ON node_id=node_2 
					where a2.expl_id != node.expl_id AND node_id='||quote_literal(rec)||')a'
					INTO v_count;

				IF v_count is null OR v_count = 0 THEN
					EXECUTE 'DELETE FROM node_border_expl WHERE node_id='||quote_literal(rec)||' AND expl_id='||OLD.expl_id||'';
					EXECUTE 'DELETE from node_border_expl where node_id in (SELECT node_id FROM node WHERE parent_id='||quote_literal(rec)||') AND expl_id='||OLD.expl_id||'';
					EXECUTE 'DELETE from arc_border_expl where arc_id in (SELECT arc_id FROM arc WHERE parent_id='||quote_literal(rec)||') AND expl_id='||OLD.expl_id||'';

				END IF;
			END LOOP;
		END IF;
	  RETURN NULL;
	END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
