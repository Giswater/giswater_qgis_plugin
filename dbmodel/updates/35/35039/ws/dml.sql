/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME ,public;

UPDATE config_function set style = '{"style": {"polygon": {"style": "categorized","field": "minsector_id",  "transparency": 0.5}}}' WHERE id = 2706;

update sys_function set descript='Dynamic analisys to sectorize network using the flow traceability function and establish Minimum Sectors. 
Before start you need to configure:
- Field graph_delimiter on [cat_feature_node] table to establish which elements will be used to sectorize. 
- Enable status for minsector on utils_graphanalytics_status variable from [config_param_system] table.' where function_name='gw_fct_graphanalytics_minsector';
