--DROP
ALTER TABLE rpt_selector_result ALTER COLUMN result_id DROP NOT NULL;
ALTER TABLE rpt_selector_result ALTER COLUMN cur_user DROP NOT NULL;

ALTER TABLE rpt_selector_compare ALTER COLUMN result_id DROP NOT NULL;
ALTER TABLE rpt_selector_compare ALTER COLUMN cur_user DROP NOT NULL;

ALTER TABLE inp_selector_sector ALTER COLUMN result_id DROP NOT NULL;
ALTER TABLE inp_selector_sector ALTER COLUMN cur_user DROP NOT NULL;

ALTER TABLE inp_selector_result ALTER COLUMN result_id DROP NOT NULL;
ALTER TABLE inp_selector_result ALTER COLUMN cur_user DROP NOT NULL;

--SET
ALTER TABLE rpt_selector_result ALTER COLUMN result_id SET NOT NULL;
ALTER TABLE rpt_selector_result ALTER COLUMN cur_user SET NOT NULL;

ALTER TABLE rpt_selector_compare ALTER COLUMN result_id SET NOT NULL;
ALTER TABLE rpt_selector_compare ALTER COLUMN cur_user SET NOT NULL;

ALTER TABLE inp_selector_sector ALTER COLUMN result_id SET NOT NULL;
ALTER TABLE inp_selector_sector ALTER COLUMN cur_user SET NOT NULL;

ALTER TABLE inp_selector_result ALTER COLUMN result_id SET NOT NULL;
ALTER TABLE inp_selector_result ALTER COLUMN cur_user SET NOT NULL;



