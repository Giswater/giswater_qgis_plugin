/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

ALTER TABLE asset.arc_engine_sh
    ADD CONSTRAINT arc_engine_sh_result_id_fkey FOREIGN KEY (result_id)
    REFERENCES asset.cat_result(result_id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE asset.arc_engine_wm
    ADD CONSTRAINT arc_engine_wm_result_id_fkey FOREIGN KEY (result_id)
    REFERENCES asset.cat_result(result_id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE asset.arc_output
    ADD CONSTRAINT arc_output_result_id_fkey FOREIGN KEY (result_id)
    REFERENCES asset.cat_result(result_id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE asset.config_catalog
    ADD CONSTRAINT config_catalog_result_id_fkey FOREIGN KEY (result_id)
    REFERENCES asset.cat_result(result_id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE asset.config_engine
    ADD CONSTRAINT config_engine_result_id_fkey FOREIGN KEY (result_id)
    REFERENCES asset.cat_result(result_id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE asset.config_material
    ADD CONSTRAINT config_material_result_id_fkey FOREIGN KEY (result_id)
    REFERENCES asset.cat_result(result_id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE asset.selector_result_compare
    ADD CONSTRAINT selector_result_compare_result_id_fkey FOREIGN KEY (result_id)
    REFERENCES asset.cat_result(result_id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE asset.selector_result_main
    ADD CONSTRAINT selector_result_main_result_id_fkey FOREIGN KEY (result_id)
    REFERENCES asset.cat_result(result_id) ON UPDATE CASCADE ON DELETE CASCADE;
