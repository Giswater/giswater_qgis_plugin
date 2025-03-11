/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

drop view IF EXISTS v_edit_drainzone;

CREATE OR REPLACE VIEW v_edit_drainzone
AS SELECT drainzone.drainzone_id,
    drainzone.name,
    drainzone.expl_id,
    drainzone.descript,
    drainzone.undelete,
    drainzone.link,
    drainzone.graphconfig::text,
    drainzone.stylesheet::text,
    drainzone.active,
    drainzone.the_geom
   FROM selector_expl,
    drainzone
  WHERE drainzone.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text;

create trigger gw_trg_edit_drainzone instead of
insert
    or
delete
    or
update
    on
    v_edit_drainzone for each row execute function gw_trg_edit_drainzone();