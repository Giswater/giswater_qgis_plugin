/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

------------
-- material
------------
CREATE OR REPLACE FUNCTION PARENT_SCHEMA.gw_trg_asset_cat_mat_arc()  RETURNS trigger AS
$BODY$

DECLARE

BEGIN

	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

	IF TG_OP = 'INSERT' THEN

		INSERT INTO asset.config_material_def (material)
		VALUES (NEW.id)
		ON CONFLICT (material) DO NOTHING;

		RETURN NEW;
	END IF;
END;

$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- trigger
drop trigger gw_trg_asset_cat_mat_arc on PARENT_SCHEMA.cat_mat_arc;
CREATE TRIGGER gw_trg_asset_cat_mat_arc AFTER INSERT ON PARENT_SCHEMA.cat_mat_arc
FOR EACH ROW EXECUTE PROCEDURE PARENT_SCHEMA.gw_trg_asset_cat_mat_arc();

-- fk
ALTER TABLE asset.config_material_def ADD CONSTRAINT config_material_def_fk FOREIGN KEY (material)
REFERENCES PARENT_SCHEMA.cat_mat_arc (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;


grant all on all functions in schema PARENT_SCHEMA to role_basic;