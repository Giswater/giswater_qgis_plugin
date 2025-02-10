/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


-----------
-- cat_arc
------------

CREATE OR REPLACE FUNCTION PARENT_SCHEMA.gw_trg_asset_cat_arc()  RETURNS trigger AS
$BODY$

DECLARE

BEGIN

	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

	IF TG_OP = 'INSERT' THEN

		INSERT INTO asset.config_catalog_def (arccat_id, dnom)
		VALUES (NEW.id, NEW.dnom::numeric)
		ON CONFLICT (arccat_id) DO NOTHING;

		RETURN NEW;

	ELSIF TG_OP = 'UPDATE' THEN

		UPDATE asset.config_catalog_def SET dnom = NEW.dnom::numeric
		WHERE arccat_id = OLD.id;

		RETURN NEW;
	END IF;
END;

$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- trigger
drop trigger gw_trg_asset_cat_arc on PARENT_SCHEMA.cat_arc;
CREATE TRIGGER gw_trg_asset_cat_arc AFTER INSERT OR UPDATE OF dnom ON PARENT_SCHEMA.cat_arc
FOR EACH ROW EXECUTE PROCEDURE PARENT_SCHEMA.gw_trg_asset_cat_arc();

-- fk
ALTER TABLE asset.config_catalog_def ADD CONSTRAINT config_catalog_def_fk FOREIGN KEY (arccat_id)
REFERENCES PARENT_SCHEMA.cat_arc (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

-- constraint unique
ALTER TABLE asset.config_catalog_def ADD CONSTRAINT config_catalog_def_arccat_id UNIQUE (arccat_id);

grant all on all functions in schema PARENT_SCHEMA to role_basic;