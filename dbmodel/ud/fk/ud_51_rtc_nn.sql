--DROP

ALTER TABLE rtc_scada_x_dma ALTER COLUMN scada_id DROP NOT NULL;

ALTER TABLE rtc_scada_x_sector ALTER COLUMN scada_id DROP NOT NULL;


--CREATE
ALTER TABLE rtc_scada_x_dma ALTER COLUMN scada_id SET NOT NULL;

ALTER TABLE rtc_scada_x_sector ALTER COLUMN scada_id SET NOT NULL;