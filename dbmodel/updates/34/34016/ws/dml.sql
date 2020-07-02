/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 2020/07/02
UPDATE config_toolbox SET inputparams = '[{"widgetname":"grafClass", "label":"Graf class:", "widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layoutorder":1,"comboIds":["DMA","PRESSZONE","SECTOR"],"comboNames":["District Metering Areas (DMA)","PRESSZONE", "SECTOR"], "selectedId":"DMA"}, {"widgetname":"mapzoneField", "label":"Mapzone field name:","widgettype":"text","datatype":"string","layoutname":"grl_option_parameters","layoutorder":2, "value":"c_sector"}]'
WHERE ID = 2970;
