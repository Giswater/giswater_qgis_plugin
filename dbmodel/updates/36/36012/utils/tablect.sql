/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


ALTER TABLE sys_style ADD CONSTRAINT sys_style_styleconfig_id_fk FOREIGN KEY (styleconfig_id) REFERENCES config_style(id);

ALTER TABLE samplepoint ADD CONSTRAINT samplepoint_sector_id FOREIGN KEY (sector_id) REFERENCES sector(sector_id);

ALTER TABLE element ADD CONSTRAINT element_sector_id FOREIGN KEY (sector_id) REFERENCES sector(sector_id);

ALTER TABLE link ADD CONSTRAINT link_sector_id FOREIGN KEY (sector_id) REFERENCES sector(sector_id);

ALTER TABLE dimensions ADD CONSTRAINT dimensions_sector_id FOREIGN KEY (sector_id) REFERENCES sector(sector_id);


DO $$
DECLARE
    v_utils boolean;
BEGIN

	SELECT value::boolean INTO v_utils FROM config_param_system WHERE parameter='admin_utils_schema';

	IF v_utils IS true THEN

        ALTER TABLE samplepoint ADD CONSTRAINT samplepoint_muni_id FOREIGN KEY (muni_id) REFERENCES utils.municipality(muni_id);
        ALTER TABLE element ADD CONSTRAINT element_muni_id FOREIGN KEY (muni_id) REFERENCES utils.municipality(muni_id);
        ALTER TABLE link ADD CONSTRAINT link_muni_id FOREIGN KEY (muni_id) REFERENCES utils.municipality(muni_id);
        ALTER TABLE dimensions ADD CONSTRAINT dimensions_muni_id FOREIGN KEY (muni_id) REFERENCES utils.municipality(muni_id);

    ELSE

        ALTER TABLE samplepoint ADD CONSTRAINT samplepoint_muni_id FOREIGN KEY (muni_id) REFERENCES ext_municipality(muni_id);
        ALTER TABLE element ADD CONSTRAINT element_muni_id FOREIGN KEY (muni_id) REFERENCES ext_municipality(muni_id);
        ALTER TABLE link ADD CONSTRAINT link_muni_id FOREIGN KEY (muni_id) REFERENCES ext_municipality(muni_id);
        ALTER TABLE dimensions ADD CONSTRAINT dimensions_muni_id FOREIGN KEY (muni_id) REFERENCES ext_municipality(muni_id);

    END IF;
END; $$;



ALTER TABLE element ALTER COLUMN sector_id set not null;
ALTER TABLE samplepoint ALTER COLUMN sector_id set not null;
ALTER TABLE om_visit ALTER COLUMN sector_id set not null;
ALTER TABLE dimensions ALTER COLUMN sector_id set not null;