 /*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


UPDATE audit_cat_param_user SET description='DMA patterns has different options. With non SCADA values (unique pattern for whole dma) or using SCADA or import csv file. This variable only works with non SCADA values. In case of work with CRM values, pattern values will be used from ext_rtc_scada_dma_period table' WHERE id='inp_options_use_dma_pattern';
