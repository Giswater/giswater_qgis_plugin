/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;

 
UPDATE config_param_system SET value='TRUE' WHERE parameter='admin_utils_schema';

INSERT INTO utils.municipality (muni_id, name, observ, the_geom)
SELECT muni_id, name, observ, the_geom FROM ext_municipality_old ON CONFLICT (muni_id) DO NOTHING;

INSERT INTO  utils.type_street (id, observ) SELECT id, observ FROM ext_type_street_old ON CONFLICT (id) DO NOTHING;

INSERT INTO utils.streetaxis (id, code, type, name, text, the_geom, ud_expl_id, muni_id) 
SELECT id, code, type, name, text, the_geom, expl_id, muni_id 
FROM ext_streetaxis_old ON CONFLICT (id) DO NOTHING;

INSERT INTO  utils.plot (id, plot_code, muni_id, postcode, streetaxis_id, postnumber, complement, placement, square, observ,
text, the_geom, ud_expl_id) 
SELECT id, plot_code, muni_id, postcode::integer, streetaxis_id, postnumber, complement, placement, square, observ,
text, the_geom, expl_id FROM ext_plot_old ON CONFLICT (id) DO NOTHING;

INSERT INTO utils.address ( id, muni_id, postcode, streetaxis_id, postnumber, plot_id , the_geom , ud_expl_id)
SELECT id, muni_id, postcode, streetaxis_id, postnumber, plot_id, the_geom, expl_id 
FROM ext_address_old ON CONFLICT (id) DO NOTHING;

UPDATE config_param_system SET value='SCHEMA_NAME' WHERE parameter='ud_current_schema';

UPDATE utils.streetaxis e SET ud_expl_id = a.expl_id FROM ext_streetaxis_old a where e.id=a.id;
UPDATE utils.plot e SET ud_expl_id = a.expl_id FROM ext_plot_old a where e.id=a.id;
UPDATE utils.address e SET ud_expl_id = a.expl_id FROM ext_address_old a where e.id=a.id;