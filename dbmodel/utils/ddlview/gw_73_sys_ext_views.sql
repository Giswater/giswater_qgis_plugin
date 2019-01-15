/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;


DROP VIEW IF EXISTS v_ext_streetaxis CASCADE;
CREATE VIEW v_ext_streetaxis AS SELECT
ext_streetaxis.id,
code,
type,
name,
text,
the_geom,
ext_streetaxis.expl_id,
muni_id
FROM selector_expl,ext_streetaxis
WHERE ((ext_streetaxis.expl_id)=(selector_expl.expl_id)
AND selector_expl.cur_user="current_user"());



DROP VIEW IF EXISTS v_ext_address CASCADE;
CREATE VIEW v_ext_address AS SELECT
ext_address.id,
muni_id,
postcode,
streetaxis_id,
postnumber,
plot_id,
the_geom,
ext_address.expl_id
FROM selector_expl,ext_address
WHERE ((ext_address.expl_id)=(selector_expl.expl_id)
AND selector_expl.cur_user="current_user"());



DROP VIEW IF EXISTS v_ext_plot CASCADE;
CREATE VIEW v_ext_plot AS SELECT
ext_plot.id,
plot_code,
muni_id,
postcode,
streetaxis_id,
postnumber,
complement,
placement,
square,
observ,
text,
the_geom,
ext_plot.expl_id
FROM selector_expl,ext_plot
WHERE ((ext_plot.expl_id)=(selector_expl.expl_id)
AND selector_expl.cur_user="current_user"());

  