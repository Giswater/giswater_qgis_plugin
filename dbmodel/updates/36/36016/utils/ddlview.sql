/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

drop VIEW v_ui_workspace;

CREATE OR REPLACE VIEW v_ui_workspace
AS SELECT cat_workspace.id,
    cat_workspace.name,
    cat_workspace.private,
    cat_workspace.descript,
    cat_workspace.cur_user as insert_user,
    cat_workspace.config
   FROM cat_workspace
  WHERE cat_workspace.private IS FALSE OR cat_workspace.private IS TRUE AND cat_workspace.cur_user = CURRENT_USER::text;
  
