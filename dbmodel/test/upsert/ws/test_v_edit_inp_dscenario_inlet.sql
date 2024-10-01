/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
BEGIN;

-- Suppress NOTICE messages
SET client_min_messages TO WARNING;

SET search_path = "SCHEMA_NAME", public, pg_catalog;

SELECT plan(6);

INSERT INTO v_edit_inp_dscenario_inlet (dscenario_id, node_id, initlevel, minlevel, maxlevel, diameter, minvol, curve_id, overflow, mixing_model, mixing_fraction, reaction_coeff, init_quality, source_type, source_quality, source_pattern_id, head, pattern_id, demand, demand_pattern_id, emitter_coeff, the_geom)
VALUES(1, '113766', -901, 0, 0, 0, 0, '', '', '', 0, 0, 0, '', 0, '', 0, '', 0, '', 0, null);
SELECT is((SELECT count(*)::integer FROM v_edit_inp_dscenario_inlet WHERE initlevel = -901), 1, 'INSERT: v_edit_inp_dscenario_inlet -901 was inserted');
SELECT is((SELECT count(*)::integer FROM inp_dscenario_inlet WHERE initlevel = -901), 1, 'INSERT: inp_dscenario_inlet -901 was inserted');

UPDATE v_edit_inp_dscenario_inlet SET overflow = 'upd' WHERE initlevel = -901;
SELECT is((SELECT overflow FROM v_edit_inp_dscenario_inlet WHERE initlevel = -901), 'upd', 'UPDATE: v_edit_inp_dscenario_inlet -901 was updated');
SELECT is((SELECT overflow FROM inp_dscenario_inlet WHERE initlevel = -901), 'upd', 'UPDATE: inp_dscenario_inlet -901 was updated');

DELETE FROM v_edit_inp_dscenario_inlet WHERE initlevel = -901;
SELECT is((SELECT count(*)::integer FROM v_edit_inp_dscenario_inlet WHERE initlevel = -901), 0, 'DELETE: v_edit_inp_dscenario_inlet -901 was deleted');
SELECT is((SELECT count(*)::integer FROM inp_dscenario_inlet WHERE initlevel = -901), 0, 'DELETE: inp_dscenario_inlet -901 was deleted');


SELECT * FROM finish();


ROLLBACK;