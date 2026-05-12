/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/
BEGIN;

-- Suppress NOTICE messages
SET client_min_messages TO WARNING;

SET search_path = "SCHEMA_NAME", public, pg_catalog;

SELECT plan(10);

-- Extract and test the "status" field from the function's JSON response

-- CPW
SELECT is(
    (gw_fct_waterbalance($${"data":{"parameters":{"exploitation":"1", "period":"5", "method":"CPW"}}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_waterbalance with exploitation 1, period 5 and method CPW returns status "Accepted"'
);

SELECT is(
    (gw_fct_waterbalance($${"data":{"parameters":{"exploitation":"2", "period":"5", "method":"CPW"}}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_waterbalance with exploitation 2, period 5 and method CPW returns status "Accepted"'
);

SELECT is(
    (gw_fct_waterbalance($${"data":{"parameters":{"exploitation":"1", "period":"6", "method":"CPW"}}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_waterbalance with exploitation 1, period 6 and method CPW returns status "Accepted"'
);

SELECT is(
    (gw_fct_waterbalance($${"data":{"parameters":{"exploitation":"2", "period":"6", "method":"CPW"}}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_waterbalance with exploitation 2, period 6 and method CPW returns status "Accepted"'
);

SELECT is(
    (gw_fct_waterbalance($${"data":{"parameters":{"exploitation":"1", "period":"7", "method":"CPW"}}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_waterbalance with exploitation 1, period 7 and method CPW returns status "Accepted"'
);

SELECT is(
    (gw_fct_waterbalance($${"data":{"parameters":{"exploitation":"2", "period":"7", "method":"CPW"}}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_waterbalance with exploitation 2, period 7 and method CPW returns status "Accepted"'
);

-- CDI
SELECT is(
    (gw_fct_waterbalance($${ "data":{"parameters":{"exploitation":"1", "method":"CDI", "initDate":"2023/07/13", "endDate":"2025/07/03", "executeGraphDma":"false"}}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_waterbalance with exploitation 1, method CDI with initDate and endDate returns status "Accepted"'
);

SELECT is(
    (gw_fct_waterbalance($${ "data":{"parameters":{"exploitation":"1", "method":"CDI", "initDate":"2023/07/13", "endDate":"2025/07/03", "executeGraphDma":"true"}}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_waterbalance with exploitation 1, method CDI with initDate and endDate and executeGraphDma returns status "Accepted"'
);

SELECT is(
    (gw_fct_waterbalance($${ "data":{"parameters":{"exploitation":"2", "method":"CDI", "initDate":"2023/07/13", "endDate":"2025/07/03", "executeGraphDma":"false"}}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_waterbalance with exploitation 2, method CDI with initDate and endDate returns status "Accepted"'
);

SELECT is(
    (gw_fct_waterbalance($${ "data":{"parameters":{"exploitation":"2", "method":"CDI", "initDate":"2023/07/13", "endDate":"2025/07/03", "executeGraphDma":"true"}}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_waterbalance with exploitation 2, method CDI with initDate and endDate and executeGraphDma returns status "Accepted"'
);

-- Finish the test
SELECT finish();

ROLLBACK;
