/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3506

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_insert_psector_x_feature()
  RETURNS trigger AS
$BODY$

/*
	prefix: NODE | ARC | CONNEC | GULLY
	tgt_tab: plan_psector_x_<prefix> -> plan_psector_x_node, plan_psector_x_arc, plan_psector_x_connec, plan_psector_x_gully
	key_col: <prefix>_id -> node_id, arc_id, connec_id, gully_id
	new_id: NEW.<prefix>_id

	Example:

	INSERT INTO node (the_geom, code, node_type, nodecat_id, epa_type,
    expl_id, sector_id, muni_id, state, state_type, workcat_id, elev, ymax)
	VALUES (ST_SetSRID(ST_Point(419272.324, 4576287.71), 25831), '100',
	'CIRC_MANHOLE', 'C_MANHOLE_100', 'JUNCTION', 1, 0, 0, 2, 3, 'test1', 31.33, 2.26);
*/

DECLARE
  prefix   text := TG_ARGV[0];
  tgt_tab  text := format('plan_psector_x_%s', prefix);
  key_col  text := prefix || '_id';
  new_id    int;
BEGIN
  -- extract NEW.<prefix>_id into new_id
  EXECUTE format('SELECT ($1).%I', key_col)
    INTO new_id
    USING NEW;

  -- now insert into plan_psector_x_<prefix>
  EXECUTE format(
    'INSERT INTO %I(%I, psector_id, state, doable)
       VALUES ($1,
               ( SELECT (c.value)::int
                   FROM config_param_user c
                  WHERE c.parameter = %L
                    AND c.cur_user = CURRENT_USER
                  LIMIT 1
               ),
               1,
               TRUE
        )',
    tgt_tab,
    key_col,
    'plan_psector_current'
  )
  USING new_id;

  RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
