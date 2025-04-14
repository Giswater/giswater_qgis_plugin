/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = am, public;

GRANT ALL ON TABLE arc_engine_sh TO role_basic;
GRANT ALL ON TABLE arc_engine_wm TO role_basic;
GRANT ALL ON TABLE arc_input TO role_basic;
GRANT ALL ON TABLE arc_output TO role_basic;
GRANT ALL ON TABLE cat_result TO role_basic;
GRANT ALL ON TABLE config_catalog TO role_basic;
GRANT ALL ON TABLE config_catalog_def TO role_basic;
GRANT ALL ON TABLE config_engine TO role_basic;
GRANT ALL ON TABLE config_engine_def TO role_basic;
GRANT ALL ON TABLE config_form_tableview TO role_basic;
GRANT ALL ON TABLE config_material TO role_basic;
GRANT ALL ON TABLE config_material_def TO role_basic;
GRANT ALL ON TABLE dma_nrw TO role_basic;
GRANT ALL ON TABLE leaks TO role_basic;
GRANT ALL ON TABLE selector_result_compare TO role_basic;
GRANT ALL ON TABLE selector_result_main TO role_basic;
GRANT ALL ON TABLE value_result_type TO role_basic;
GRANT ALL ON TABLE value_status TO role_basic;