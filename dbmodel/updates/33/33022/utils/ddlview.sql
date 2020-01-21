/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

DROP VIEW IF EXISTS v_ext_streetaxis;

CREATE OR REPLACE VIEW v_ext_streetaxis AS 
SELECT ext_streetaxis.id,
ext_streetaxis.code,
ext_streetaxis.type,
ext_streetaxis.name,
ext_streetaxis.text,
ext_streetaxis.the_geom::geometry(MultiLinestring,SRID_VALUE),
ext_streetaxis.expl_id,
ext_streetaxis.muni_id,
CASE
WHEN ext_streetaxis.type IS NULL THEN ext_streetaxis.name::text
WHEN ext_streetaxis.text IS NULL THEN ((ext_streetaxis.name::text || ', '::text) || ext_streetaxis.type::text) || '.'::text
WHEN ext_streetaxis.type IS NULL AND ext_streetaxis.text IS NULL THEN ext_streetaxis.name::text
ELSE (((ext_streetaxis.name::text || ', '::text) || ext_streetaxis.type::text) || '. '::text) || ext_streetaxis.text
END AS descript
FROM selector_expl, ext_streetaxis
WHERE ext_streetaxis.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text;