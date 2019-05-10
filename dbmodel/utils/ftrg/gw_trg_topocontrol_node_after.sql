/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2690

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_topocontrol_node_after() RETURNS trigger AS
$BODY$
DECLARE 
    numNodes numeric;
    psector_vdefault_var integer;
    replace_node_aux boolean;
    node_id_var varchar;
    node_rec record;
	querystring Varchar; 
    arcrec Record; 
    nodeRecord1 Record; 
    nodeRecord2 Record; 
    z1 double precision;
    z2 double precision;
    xvar double precision;
    yvar double precision;
    pol_id_var varchar;
    v_psector_id integer;
    v_arc record;
    v_arcrecord "SCHEMA_NAME".v_edit_arc;
    v_plan_statetype_ficticius int2;
    v_querytext text;
	v_node_proximity_control boolean;
	v_node_proximity double precision;
	v_dsbl_error boolean;

BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

	-- Get parameters
	SELECT ((value::json)->>'activated') INTO v_node_proximity_control FROM config_param_system WHERE parameter='node_proximity';
	SELECT ((value::json)->>'value') INTO v_node_proximity FROM config_param_system WHERE parameter='node_proximity';
   	SELECT value::boolean INTO v_dsbl_error FROM config_param_system WHERE parameter='edit_topocontrol_dsbl_error' ;


	v_psector_id := (SELECT value FROM SCHEMA_NAME.config_param_user WHERE cur_user=current_user AND parameter = 'psector_vdefault');


  
	IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE ' THEN

		-- Checking existing nodes 
		SELECT * INTO node_rec FROM node WHERE ST_DWithin(NEW.the_geom, node.the_geom, v_node_proximity) AND node.node_id != NEW.node_id AND node.state!=0;

		IF (node_rec.node_id) IS NOT NULL AND (v_node_proximity_control IS TRUE) THEN
			
			IF (NEW.state=2 AND node_rec.state=1) THEN

				-- inserting on plan_psector_x_node the existing node as state=0
				INSERT INTO plan_psector_x_node (psector_id, node_id, state) VALUES (v_psector_id, node_rec.node_id, 0);

				-- looking for all the arcs (1 and 2) using existing node
				FOR v_arc IN (SELECT arc_id, node_1 as node_id FROM arc WHERE node_1=node_rec.node_id UNION SELECT arc_id, node_2 FROM arc WHERE node_2=node_rec.node_id)
				LOOP
					-- if exists some arc planified on same alternative attached to that existing node
					IF v_arc.arc_id IN (SELECT arc_id FROM plan_psector_x_arc WHERE psector_id=v_psector_id) THEN 
						
						-- reconnect the planified arc to the new planified node in spite of connected to the node state=1
						IF (SELECT node_1 FROM arc WHERE arc_id=v_arc.arc_id)=v_arc.node_id THEN
							UPDATE arc SET node_1=NEW.node_id WHERE arc_id=v_arc.arc_id AND node_1=node_rec.node_id;							
						ELSE
							UPDATE arc SET node_2=NEW.node_id WHERE arc_id=v_arc.arc_id AND node_2=node_rec.node_id;
						END IF;
						
					ELSE
						-- getting values to create new 'fictius' arc
						SELECT * INTO v_arcrecord FROM v_edit_arc WHERE arc_id = v_arc.arc_id::text;
							
						-- refactoring values fo new one
						PERFORM setval('urn_id_seq', gw_fct_setvalurn(),true);
						v_arcrecord.arc_id:= (SELECT nextval('urn_id_seq'));
						v_arcrecord.code = v_arcrecord.arc_id;
						v_arcrecord.state=2;
						v_arcrecord.state_type := (SELECT value::smallint FROM config_param_system WHERE parameter='plan_statetype_ficticius');
						IF (SELECT node_1 FROM arc WHERE arc_id=v_arc.arc_id)=v_arc.node_id THEN
							v_arcrecord.node_1 = NEW.node_id;
						ELSE
							v_arcrecord.node_2 = NEW.node_id;
						END IF;

						UPDATE config_param_system SET value=gw_fct_json_object_set_key(value::json,'activated',false) where parameter='arc_searchnodes';

						-- Insert new records into arc table
						INSERT INTO v_edit_arc SELECT v_arcrecord.*;

						--Copy addfields from old arc to new arcs	
						INSERT INTO man_addfields_value (feature_id, parameter_id, value_param)
						SELECT 
						v_arcrecord.arc_id,
						parameter_id,
						value_param
						FROM man_addfields_value WHERE feature_id=v_arc.arc_id;
																			
						-- Update doability for the new arc (false)
						UPDATE plan_psector_x_arc SET doable=FALSE where arc_id=v_arcrecord.arc_id;

						-- insert old arc on the alternative							
						INSERT INTO plan_psector_x_arc (psector_id, arc_id, state, doable) VALUES (v_psector_id, v_arc.arc_id, 0, FALSE);

						UPDATE config_param_system SET value=gw_fct_json_object_set_key(value::json,'activated',false) where parameter='arc_searchnodes';


					END IF;
				END LOOP;
			END IF;
		END IF;
	END IF;
RETURN NEW;
    
END; 
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

