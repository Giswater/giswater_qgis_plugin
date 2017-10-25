--DROP
ALTER TABLE rtc_scada_node ALTER COLUMN node_id DROP NOT NULL;

ALTER TABLE rtc_scada_x_dma ALTER COLUMN scada_id DROP NOT NULL;
ALTER TABLE rtc_scada_x_dma ALTER COLUMN dma_id DROP NOT NULL;

ALTER TABLE rtc_scada_x_sector ALTER COLUMN scada_id DROP NOT NULL;
ALTER TABLE rtc_scada_x_sector ALTER COLUMN sector_id DROP NOT NULL;

ALTER TABLE rtc_hydrometer_x_connec ALTER COLUMN connec_id DROP NOT NULL;



--SET
ALTER TABLE rtc_scada_node ALTER COLUMN node_id SET NOT NULL;

ALTER TABLE rtc_scada_x_dma ALTER COLUMN scada_id SET NOT NULL;
ALTER TABLE rtc_scada_x_dma ALTER COLUMN dma_id SET NOT NULL;

ALTER TABLE rtc_scada_x_sector ALTER COLUMN scada_id SET NOT NULL;
ALTER TABLE rtc_scada_x_sector ALTER COLUMN sector_id SET NOT NULL;

ALTER TABLE rtc_hydrometer_x_connec ALTER COLUMN connec_id SET NOT NULL;