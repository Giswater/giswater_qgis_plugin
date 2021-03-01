SET SEARCH_PATH = 'SCHEMA_NAME';
SELECT setval('SCHEMA_NAME.inp_curve_id_seq', (SELECT max(id) FROM inp_curve_value), true);


INSERT INTO inp_curve VALUES ('GP20', 'PUMP', 'Pressure grup curve type for 20 wmc');
INSERT INTO inp_curve VALUES ('GP30', 'PUMP', 'Pressure grup curve type for 30 wmc');
INSERT INTO inp_curve VALUES ('GP40', 'PUMP', 'Pressure grup curve type for 40 wmc');
INSERT INTO inp_curve VALUES ('GP50', 'PUMP', 'Pressure grup curve type for 50 wmc');
INSERT INTO inp_curve VALUES ('GP60', 'PUMP', 'Pressure grup curve type for 60 wmc');
INSERT INTO inp_curve VALUES ('GP80', 'PUMP', 'Pressure grup curve type for 80 wmc');
INSERT INTO inp_curve VALUES ('GP100', 'PUMP', 'Pressure grup curve type for 100 wmc');

INSERT INTO inp_curve_value (curve_id, x_value, y_value) VALUES ('GP20',1,20.005);
INSERT INTO inp_curve_value (curve_id, x_value, y_value) VALUES ('GP20',10,20.004);
INSERT INTO inp_curve_value (curve_id, x_value, y_value) VALUES ('GP20',100,20.003);
INSERT INTO inp_curve_value (curve_id, x_value, y_value) VALUES ('GP20',1000,20.002);
INSERT INTO inp_curve_value (curve_id, x_value, y_value) VALUES ('GP20',10000,20.001);

INSERT INTO inp_curve_value (curve_id, x_value, y_value) VALUES ('GP30',1,30.005);
INSERT INTO inp_curve_value (curve_id, x_value, y_value) VALUES ('GP30',10,30.004);
INSERT INTO inp_curve_value (curve_id, x_value, y_value) VALUES ('GP30',100,30.003);
INSERT INTO inp_curve_value (curve_id, x_value, y_value) VALUES ('GP30',1000,30.002);
INSERT INTO inp_curve_value (curve_id, x_value, y_value) VALUES ('GP30',10000,30.001);

INSERT INTO inp_curve_value (curve_id, x_value, y_value) VALUES ('GP40',1,40.005);
INSERT INTO inp_curve_value (curve_id, x_value, y_value) VALUES ('GP40',10,40.004);
INSERT INTO inp_curve_value (curve_id, x_value, y_value) VALUES ('GP40',100,40.003);
INSERT INTO inp_curve_value (curve_id, x_value, y_value) VALUES ('GP40',1000,40.002);
INSERT INTO inp_curve_value (curve_id, x_value, y_value) VALUES ('GP40',10000,40.001);

INSERT INTO inp_curve_value (curve_id, x_value, y_value) VALUES ('GP50',1,50.005);
INSERT INTO inp_curve_value (curve_id, x_value, y_value) VALUES ('GP50',10,50.004);
INSERT INTO inp_curve_value (curve_id, x_value, y_value) VALUES ('GP50',100,50.003);
INSERT INTO inp_curve_value (curve_id, x_value, y_value) VALUES ('GP50',1000,50.002);
INSERT INTO inp_curve_value (curve_id, x_value, y_value) VALUES ('GP50',10000,50.001);

INSERT INTO inp_curve_value (curve_id, x_value, y_value) VALUES ('GP60',1,60.005);
INSERT INTO inp_curve_value (curve_id, x_value, y_value) VALUES ('GP60',10,60.004);
INSERT INTO inp_curve_value (curve_id, x_value, y_value) VALUES ('GP60',100,60.003);
INSERT INTO inp_curve_value (curve_id, x_value, y_value) VALUES ('GP60',1000,60.002);
INSERT INTO inp_curve_value (curve_id, x_value, y_value) VALUES ('GP60',10000,60.001);

INSERT INTO inp_curve_value (curve_id, x_value, y_value) VALUES ('GP80',1,80.005);
INSERT INTO inp_curve_value (curve_id, x_value, y_value) VALUES ('GP80',10,80.004);
INSERT INTO inp_curve_value (curve_id, x_value, y_value) VALUES ('GP80',100,80.003);
INSERT INTO inp_curve_value (curve_id, x_value, y_value) VALUES ('GP80',1000,80.002);
INSERT INTO inp_curve_value (curve_id, x_value, y_value) VALUES ('GP80',10000,80.001);

INSERT INTO inp_curve_value (curve_id, x_value, y_value) VALUES ('GP100',1,100.005);
INSERT INTO inp_curve_value (curve_id, x_value, y_value) VALUES ('GP100',10,100.004);
INSERT INTO inp_curve_value (curve_id, x_value, y_value) VALUES ('GP100',100,100.003);
INSERT INTO inp_curve_value (curve_id, x_value, y_value) VALUES ('GP100',1000,100.002);
INSERT INTO inp_curve_value (curve_id, x_value, y_value) VALUES ('GP100',10000,100.001);