/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;
/*
DROP TRIGGER IF EXISTS trg_validate_campaign_x_gully_feature ON "SCHEMA_NAME".om_campaign_x_gully;
CREATE TRIGGER trg_validate_campaign_x_gully_feature BEFORE INSERT ON "SCHEMA_NAME".om_campaign_x_gully
FOR EACH ROW EXECUTE FUNCTION SCHEMA_NAME.gw_trg_campaign_x_feature_validate_type('gully');

CREATE TRIGGER trg_edit_view_campaign_gully
AFTER INSERT OR UPDATE ON ve_PARENT_SCHEMA_camp_gully
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_view_campaign('gully');
*/