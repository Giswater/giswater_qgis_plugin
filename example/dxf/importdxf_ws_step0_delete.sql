
SET search_path=SCHEMA_NAME;
--add import dxf to toolbox
UPDATE audit_cat_function  set istoolbox=true where id=2784;
--delete arc
SELECT gw_fct_set_delete_feature($${"client":{"device":9, "infoType":100, "lang":"ES"}, "form":{}, "feature":{"type":"ARC"}, "data":{"filterFields":{}, "pageInfo":{}, "feature_id":"113857"}}$$)::text;
SELECT gw_fct_set_delete_feature($${"client":{"device":9, "infoType":100, "lang":"ES"}, "form":{}, "feature":{"type":"ARC"}, "data":{"filterFields":{}, "pageInfo":{}, "feature_id":"113935"}}$$)::text;
SELECT gw_fct_set_delete_feature($${"client":{"device":9, "infoType":100, "lang":"ES"}, "form":{}, "feature":{"type":"ARC"}, "data":{"filterFields":{}, "pageInfo":{}, "feature_id":"113936"}}$$)::text;
SELECT gw_fct_set_delete_feature($${"client":{"device":9, "infoType":100, "lang":"ES"}, "form":{}, "feature":{"type":"ARC"}, "data":{"filterFields":{}, "pageInfo":{}, "feature_id":"139"}}$$)::text;
SELECT gw_fct_set_delete_feature($${"client":{"device":9, "infoType":100, "lang":"ES"}, "form":{}, "feature":{"type":"ARC"}, "data":{"filterFields":{}, "pageInfo":{}, "feature_id":"2031"}}$$)::text;
SELECT gw_fct_set_delete_feature($${"client":{"device":9, "infoType":100, "lang":"ES"}, "form":{}, "feature":{"type":"ARC"}, "data":{"filterFields":{}, "pageInfo":{}, "feature_id":"2032"}}$$)::text;
SELECT gw_fct_set_delete_feature($${"client":{"device":9, "infoType":100, "lang":"ES"}, "form":{}, "feature":{"type":"ARC"}, "data":{"filterFields":{}, "pageInfo":{}, "feature_id":"2074"}}$$)::text;
SELECT gw_fct_set_delete_feature($${"client":{"device":9, "infoType":100, "lang":"ES"}, "form":{}, "feature":{"type":"ARC"}, "data":{"filterFields":{}, "pageInfo":{}, "feature_id":"2076"}}$$)::text;
SELECT gw_fct_set_delete_feature($${"client":{"device":9, "infoType":100, "lang":"ES"}, "form":{}, "feature":{"type":"ARC"}, "data":{"filterFields":{}, "pageInfo":{}, "feature_id":"2087"}}$$)::text;
SELECT gw_fct_set_delete_feature($${"client":{"device":9, "infoType":100, "lang":"ES"}, "form":{}, "feature":{"type":"ARC"}, "data":{"filterFields":{}, "pageInfo":{}, "feature_id":"2214"}}$$)::text;
SELECT gw_fct_set_delete_feature($${"client":{"device":9, "infoType":100, "lang":"ES"}, "form":{}, "feature":{"type":"ARC"}, "data":{"filterFields":{}, "pageInfo":{}, "feature_id":"2215"}}$$)::text;
SELECT gw_fct_set_delete_feature($${"client":{"device":9, "infoType":100, "lang":"ES"}, "form":{}, "feature":{"type":"ARC"}, "data":{"filterFields":{}, "pageInfo":{}, "feature_id":"2216"}}$$)::text;
SELECT gw_fct_set_delete_feature($${"client":{"device":9, "infoType":100, "lang":"ES"}, "form":{}, "feature":{"type":"ARC"}, "data":{"filterFields":{}, "pageInfo":{}, "feature_id":"2027"}}$$)::text;
SELECT gw_fct_set_delete_feature($${"client":{"device":9, "infoType":100, "lang":"ES"}, "form":{}, "feature":{"type":"ARC"}, "data":{"filterFields":{}, "pageInfo":{}, "feature_id":"2084"}}$$)::text;
SELECT gw_fct_set_delete_feature($${"client":{"device":9, "infoType":100, "lang":"ES"}, "form":{}, "feature":{"type":"ARC"}, "data":{"filterFields":{}, "pageInfo":{}, "feature_id":"140"}}$$)::text;

--delete node

SELECT gw_fct_set_delete_feature($${"client":{"device":9, "infoType":100, "lang":"ES"}, "form":{}, "feature":{"type":"NODE"}, "data":{"filterFields":{}, "pageInfo":{}, "feature_id":"1004"}}$$)::text;
SELECT gw_fct_set_delete_feature($${"client":{"device":9, "infoType":100, "lang":"ES"}, "form":{}, "feature":{"type":"NODE"}, "data":{"filterFields":{}, "pageInfo":{}, "feature_id":"1068"}}$$)::text;
SELECT gw_fct_set_delete_feature($${"client":{"device":9, "infoType":100, "lang":"ES"}, "form":{}, "feature":{"type":"NODE"}, "data":{"filterFields":{}, "pageInfo":{}, "feature_id":"1074"}}$$)::text;	
SELECT gw_fct_set_delete_feature($${"client":{"device":9, "infoType":100, "lang":"ES"}, "form":{}, "feature":{"type":"NODE"}, "data":{"filterFields":{}, "pageInfo":{}, "feature_id":"1075"}}$$)::text;	
SELECT gw_fct_set_delete_feature($${"client":{"device":9, "infoType":100, "lang":"ES"}, "form":{}, "feature":{"type":"NODE"}, "data":{"filterFields":{}, "pageInfo":{}, "feature_id":"1109"}}$$)::text;	
SELECT gw_fct_set_delete_feature($${"client":{"device":9, "infoType":100, "lang":"ES"}, "form":{}, "feature":{"type":"NODE"}, "data":{"filterFields":{}, "pageInfo":{}, "feature_id":"1110"}}$$)::text;	
SELECT gw_fct_set_delete_feature($${"client":{"device":9, "infoType":100, "lang":"ES"}, "form":{}, "feature":{"type":"NODE"}, "data":{"filterFields":{}, "pageInfo":{}, "feature_id":"138"}}$$)::text;	
SELECT gw_fct_set_delete_feature($${"client":{"device":9, "infoType":100, "lang":"ES"}, "form":{}, "feature":{"type":"NODE"}, "data":{"filterFields":{}, "pageInfo":{}, "feature_id":"1111"}}$$)::text;	
SELECT gw_fct_set_delete_feature($${"client":{"device":9, "infoType":100, "lang":"ES"}, "form":{}, "feature":{"type":"NODE"}, "data":{"filterFields":{}, "pageInfo":{}, "feature_id":"41"}}$$)::text;	
