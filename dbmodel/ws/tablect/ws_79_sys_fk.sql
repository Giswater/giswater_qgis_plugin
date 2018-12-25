
/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;


/*
------
-- FK 00
------

ALTER TABLE "ext_streetaxis" DROP CONSTRAINT IF EXISTS "ext_streetaxis_type_fkey";
ALTER TABLE "ext_streetaxis" ADD CONSTRAINT "ext_streetaxis_type_fkey" FOREIGN KEY ("type") REFERENCES "ext_type_street" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "ext_urban_plot" DROP CONSTRAINT IF EXISTS "urban_plot_streetaxis_fkey";
ALTER TABLE "ext_urban_plot" ADD CONSTRAINT "urban_plot_streetaxis_fkey" FOREIGN KEY ("streetaxis") REFERENCES "ext_streetaxis" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;


ALTER TABLE "ext_rtc_scada" DROP CONSTRAINT IF EXISTS "ext_rtc_scada_cat_scada_id_fkey";
ALTER TABLE "ext_rtc_scada" ADD CONSTRAINT "ext_rtc_scada_cat_scada_id_fkey" FOREIGN KEY ("cat_scada_id") REFERENCES "ext_cat_scada" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "ext_rtc_scada_x_value" DROP CONSTRAINT IF EXISTS "ext_rtc_scada_x_value_scada_id_fkey";
ALTER TABLE "ext_rtc_scada_x_value" ADD CONSTRAINT "ext_rtc_scada_x_value_scada_id_fkey" FOREIGN KEY ("scada_id") REFERENCES "ext_rtc_scada" ("scada_id") ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE "ext_rtc_scada_x_data" DROP CONSTRAINT IF EXISTS "ext_rtc_scada_x_data_scada_id_fkey";
ALTER TABLE "ext_rtc_scada_x_data" ADD CONSTRAINT "ext_rtc_scada_x_data_scada_id_fkey" FOREIGN KEY ("scada_id") REFERENCES "ext_rtc_scada" ("scada_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "ext_rtc_scada_x_data" DROP CONSTRAINT IF EXISTS "ext_rtc_scada_x_data_cat_period_id_fkey";
ALTER TABLE "ext_rtc_scada_x_data" ADD CONSTRAINT "ext_rtc_scada_x_data_cat_period_id_fkey" FOREIGN KEY ("cat_period_id") REFERENCES "ext_cat_period" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "ext_rtc_hydrometer" DROP CONSTRAINT IF EXISTS "ext_rtc_hydrometer_cat_hydrometer_id_fkey";
ALTER TABLE "ext_rtc_hydrometer" ADD CONSTRAINT "ext_rtc_hydrometer_cat_hydrometer_id_fkey" FOREIGN KEY ("cat_hydrometer_id") REFERENCES "ext_cat_hydrometer" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "ext_rtc_hydrometer_x_data" DROP CONSTRAINT IF EXISTS "ext_rtc_hydrometer_x_data_cat_period_id_fkey";
ALTER TABLE "ext_rtc_hydrometer_x_data" ADD CONSTRAINT "ext_rtc_hydrometer_x_data_cat_period_id_fkey" FOREIGN KEY ("cat_period_id") REFERENCES "ext_cat_period" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

------
-- FK 10
------


ALTER TABLE "connec" DROP CONSTRAINT IF EXISTS "connec_streetaxis_id_fkey";
ALTER TABLE "connec" ADD CONSTRAINT "connec_streetaxis_id_fkey" FOREIGN KEY ("streetaxis_id") REFERENCES "ext_streetaxis" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

------
-- FK 60
------
ALTER TABLE "anl_mincut_result_hydrometer" DROP CONSTRAINT IF EXISTS "anl_mincut_result_hydrometer_hydrometer_id_fkey";
ALTER TABLE "anl_mincut_result_hydrometer" ADD CONSTRAINT "anl_mincut_result_hydrometer_hydrometer_id_fkey" FOREIGN KEY ("hydrometer_id") REFERENCES "ext_rtc_hydrometer" ("hydrometer_id") ON DELETE CASCADE ON UPDATE CASCADE;
*/
