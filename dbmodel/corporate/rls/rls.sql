/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

/*
to COMPLETE: 
	link, connec, gully and all tables with expl_id
	

*/

SET search_path = "SCHEMA_NAME", public;


ALTER TABLE arc ENABLE ROW LEVEL SECURITY;
ALTER TABLE node ENABLE ROW LEVEL SECURITY;
ALTER TABLE connec ENABLE ROW LEVEL SECURITY;
ALTER TABLE gully ENABLE ROW LEVEL SECURITY;
ALTER TABLE link ENABLE ROW LEVEL SECURITY;
ALTER TABLE hydrometer ENABLE ROW LEVEL SECURITY;


DROP POLICY IF EXISTS rls_node_all ON node;
CREATE POLICY rls_node_all
ON node
FOR ALL
USING (
  EXISTS (
    SELECT 1
    FROM cat_manager cue
    WHERE
      EXISTS (
        SELECT 1  FROM unnest(cue.rolename) AS r(role_name)
        WHERE pg_has_role(CURRENT_USER, r.role_name, 'member'))
		AND (
		node.expl_id = ANY (cue.expl_id) or (
		 node.expl_visibility IS NOT NULL  -- Aseguramos que expl_visibility no sea NULL
          AND array_length(array_remove(node.expl_visibility, NULL), 1) > 0  -- Limpiar NULLs de expl_visibility y asegurar que no esté vacío
          AND array_remove(node.expl_visibility, NULL) && cue.expl_id) )
      ))  
WITH CHECK (
  EXISTS (
    SELECT 1
    FROM cat_manager cue
    WHERE
      EXISTS (
        SELECT 1
        FROM unnest(cue.rolename) AS r(role_name)
        WHERE pg_has_role(CURRENT_USER, r.role_name, 'member')
        )
		AND (
		node.expl_id = ANY (cue.expl_id) or (
		 node.expl_visibility IS NOT NULL  -- Aseguramos que expl_visibility no sea NULL
          AND array_length(array_remove(node.expl_visibility, NULL), 1) > 0  -- Limpiar NULLs de expl_visibility y asegurar que no esté vacío
          AND array_remove(node.expl_visibility, NULL) && cue.expl_id) )		
)
);


DROP POLICY IF EXISTS rls_arc_all ON arc;

CREATE POLICY rls_arc_all
ON arc
FOR ALL
USING (
  EXISTS (
    SELECT 1
    FROM cat_manager cue
    WHERE
      EXISTS (
        SELECT 1  FROM unnest(cue.rolename) AS r(role_name)
        WHERE pg_has_role(CURRENT_USER, r.role_name, 'member'))
		AND (
		arc.expl_id = ANY (cue.expl_id) or (
		 arc.expl_visibility IS NOT NULL  -- Aseguramos que expl_visibility no sea NULL
          AND array_length(array_remove(arc.expl_visibility, NULL), 1) > 0  -- Limpiar NULLs de expl_visibility y asegurar que no esté vacío
          AND array_remove(arc.expl_visibility, NULL) && cue.expl_id) )
      ))  
WITH CHECK (
  EXISTS (
    SELECT 1
    FROM cat_manager cue
    WHERE
      EXISTS (
        SELECT 1
        FROM unnest(cue.rolename) AS r(role_name)
        WHERE pg_has_role(CURRENT_USER, r.role_name, 'member')
        )
		AND (
		arc.expl_id = ANY (cue.expl_id) or (
		 arc.expl_visibility IS NOT NULL  -- Aseguramos que expl_visibility no sea NULL
          AND array_length(array_remove(arc.expl_visibility, NULL), 1) > 0  -- Limpiar NULLs de expl_visibility y asegurar que no esté vacío
          AND array_remove(arc.expl_visibility, NULL) && cue.expl_id) )		
)
);