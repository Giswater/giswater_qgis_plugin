

ALTER TABLE gw_saa.ext_rtc_hydrometer_x_data ADD COLUMN tstamp timestamp without time zone;
ALTER TABLE gw_saa.rtc_hydrometer ADD COLUMN tstamp timestamp without time zone;
ALTER TABLE gw_saa.rtc_hydrometer_x_connec ADD COLUMN tstamp timestamp without time zone;

ALTER TABLE gw_saa.rtc_hydrometer_x_connec ALTER COLUMN tstamp SET DEFAULT now();
ALTER TABLE gw_saa.rtc_hydrometer ALTER COLUMN tstamp SET DEFAULT now();
ALTER TABLE gw_saa.ext_rtc_hydrometer_x_data ALTER COLUMN tstamp SET DEFAULT now();
