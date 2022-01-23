namespace go security.dsp.http

// roles

struct RoleUserGrantRequest {
    1: required string role_name (api.path = "role_name")
    2: required i64 node_id (api.body = "node_id")
    3: required string account_type (api.body = "account_type", api.vd = "in($,'service','personal'); msg:sprintf('invalid account_type: %v',$)")
    4: string service_account (api.body = "service_account")
    5: string personal_account (api.body = "personal_account")
    6: i64 duration (api.body = "duration", go.tag="default:\"90\"") // days
}

struct RoleUserGrantResponse {
    1: i32 code
    2: string msg
    3: bool data
}

struct RoleUserRevokeRequest {
    1: required string role_name (api.path = "role_name")
    2: required i64 node_id (api.body = "node_id")
    3: required string account_type (api.body = "account_type", api.vd = "in($,'service','personal'); msg:sprintf('invalid account_type: %v',$)")
    4: string service_account (api.body = "service_account")
    5: string personal_account (api.body = "personal_account")
}

struct RoleUserRevokeResponse {
    1: i32 code
    2: string msg
    3: bool data
}

struct RoleUserVerifyRequest {
    1: required string role_name (api.path = "role_name")
    2: required i64 node_id (api.query = "node_id")
    3: required string account_type (api.query = "account_type", api.vd = "in($,'service','personal'); msg:sprintf('invalid account_type: %v',$)")
    4: string service_account (api.query = "service_account")
    5: string personal_account (api.query = "personal_account")
}

struct RoleUserVerifyResponse {
    1: i32 code
    2: string msg
    3: bool data
}

// tags

struct Tag {
    1: i64 id
    2: string name
    3: string name_en
    4: i32 level
    5: i64 classify_id
    6: string classify
    7: string classify_en
    8: string sub_classify
    9: string sub_classify_en
}

struct TagsResponse {
    1: i32 code
    2: string msg
    3: list<Tag> data
}

struct TagRequest {
    1: required i64 tag_id (api.path = "tag_id", api.vd = "$>0; msg:sprintf('invalid tag_id: %v',$)")
}

struct TagResponse {
    1: i32 code
    2: string msg
    3: Tag data
}

// traffic_aggregation

struct TfcAggPath {
    1: i64 id
    2: string original_path
}

struct TfcAggPattern {
    1: i64 id
    2: string pattern
    3: string status
    4: i32 status_int
    5: string psm
    6: string http_method
    7: optional list<TfcAggPath> paths
}

struct TfcAggPatternsData {
    1: list<TfcAggPattern> patterns
    2: i64 more_data
    3: i64 next_offset
}

struct TfcAggPatternsRequest {
    1: required string psm (api.query = "psm", api.vd = "regexp('^[^.]+\\.[^.]+\\.[^.]+$'); msg:sprintf('invalid psm: %v',$)")
    2: string status (api.query = "status", api.vd = "in($,'potential','system_confirmed','system_ignored','user_confirmed','user_ignored',''); msg:sprintf('invalid status: %v',$)")
    3: string http_method (api.query = "http_method", api.vd = "in($,'GET','HEAD','POST','PUT','DELETE','CONNECT','OPTIONS','TRACE','PATCH',''); msg:sprintf('invalid http_method: %v',$)")
    4: string pattern (api.query = "pattern")
    5: i64 offset (api.query = "offset")
    6: i64 page (api.query = "page")
    6: i64 size (api.query = "size", go.tag="default:\"30\"")
}

struct TfcAggPatternsResponse {
    1: i32 code
    2: string msg
    3: TfcAggPatternsData data
}

struct TfcAggPatternRequest {
    1: required i64 pattern_id (api.path = "pattern_id", api.vd = "$>0; msg:sprintf('invalid pattern_id: %v',$)")
}

struct TfcAggPatternResponse {
    1: i32 code
    2: string msg
    3: TfcAggPattern data
}

struct TfcAggPatternCreateRequest {
    1: required string psm (api.body = "psm", api.vd = "regexp('^[^.]+\\.[^.]+\\.[^.]+$'); msg:sprintf('invalid psm: %v',$)")
    2: required string http_method (api.body = "http_method", api.vd = "in($,'GET','HEAD','POST','PUT','DELETE','CONNECT','OPTIONS','TRACE','PATCH'); msg:sprintf('invalid http_method: %v',$)")
    3: required string pattern (api.body = "pattern", api.vd = "regexp('^\\/[^?#]*$'); msg:sprintf('invalid pattern: %v',$)")
    4: required string original_path (api.body = "original_path", api.vd = "regexp('^\\/[^?#]*$'); msg:sprintf('invalid original_path: %v',$)")
    5: string status (api.body = "status", go.tag="default:\"potential\"", api.vd = "in($,'potential','user_confirmed','user_ignored'); msg:sprintf('invalid status: %v',$)")
}

struct TfcAggPatternCreateResponse {
    1: i32 code
    2: string msg
    3: TfcAggPattern data
}

struct TfcAggPatternUpdateRequest {
    1: required i64 pattern_id (api.path = "pattern_id", api.vd = "$>0; msg:sprintf('invalid pattern_id: %v',$)")
    2: required string status (api.body = "status", api.vd = "in($,'potential','user_confirmed','user_ignored'); msg:sprintf('invalid status: %v',$)")
}

struct TfcAggPatternUpdateResponse {
    1: i32 code
    2: string msg
    3: TfcAggPattern data
}

struct TfcAggPatternDeleteRequest {
    1: required i64 pattern_id (api.path = "pattern_id", api.vd = "$>0; msg:sprintf('invalid pattern_id: %v',$)")
}

struct TfcAggPatternDeleteResponse {
    1: i32 code
    2: string msg
    3: TfcAggPattern data
}

// traffic_service

struct TfcServiceAttributes {
    1: bool store_all_headers
    2: string host
}

struct TfcService {
    1: i64 id
    2: string region
    3: string psm
    4: string protocol
    5: string bytetree
    6: string bytetree_i18n
    7: i64 bytetree_id
    8: list<string> owners
    9: i32 level
    10: i32 level_recommended
    11: string source
    12: TfcServiceAttributes attributes
}

struct TfcServicesData {
    1: list<TfcService> services
    2: i64 more_data
    3: i64 next_offset
}

struct TfcServiceRequest {
    1: required i64 service_id (api.path = "service_id", api.vd = "$>0; msg:sprintf('invalid service_id: %v',$)")
}

struct TfcServiceResponse {
    1: i32 code
    2: string msg
    3: TfcService data
}

struct TfcServicesRequest {
    1: string region (api.query = "region")
    2: string psm (api.query = "psm")
    3: string protocol (api.query = "protocol")
    4: string bytetree (api.query = "bytetree")
    5: string bytetree_i18n (api.query = "bytetree_i18n")
    6: string owner (api.query = "owner")
    7: string level (api.query = "level")
    8: string level_recommended (api.query = "level_recommended")
    9: i64 offset (api.query = "offset")
    10: i64 page (api.query = "page")
    11: i64 size (api.query = "size", go.tag="default:\"30\"")
}

struct TfcServicesResponse {
    1: i32 code
    2: string msg
    3: TfcServicesData data
}

// traffic_api

struct TfcAPIAttributes {
    1: bool store_all_headers
}

struct TfcAPI {
    1: i64 id
    2: i64 service_id
    3: string protocol
    4: string name
    5: string http_method
    6: string path_aggregation
    7: i32 level
    8: i32 level_recommended
    9: string source
    10: TfcAPIAttributes attributes
}

struct TfcAPIsData {
    1: list<TfcAPI> apis
    2: i64 more_data
    3: i64 next_offset
}

struct TfcAPIsRequest {
    1: i64 service_id (api.query = "service_id")
    2: string region (api.query = "region")
    3: string psm (api.query = "psm")
    4: string name (api.query = "name")
    5: string http_method (api.query = "http_method")
    6: string path_aggregation (api.query = "path_aggregation", api.vd = "in($,'no_aggregation','potential','system_confirmed','system_ignored','user_confirmed','user_ignored',''); msg:sprintf('invalid path_aggregation: %v',$)")
    7: string level (api.query = "level")
    8: string level_recommended (api.query = "level_recommended")
    9: i64 offset (api.query = "offset")
    10: i64 page (api.query = "page")
    11: i64 size (api.query = "size", go.tag="default:\"30\"")
}

struct TfcAPIsResponse {
    1: i32 code
    2: string msg
    3: TfcAPIsData data
}

struct TfcAPIRequest {
    1: required i64 api_id (api.path = "api_id", api.vd = "$>0; msg:sprintf('invalid api_id: %v',$)")
}

struct TfcAPIResponse {
    1: i32 code
    2: string msg
    3: TfcAPI data
}

struct TfcAPIDeleteRequest {
    1: required i64 api_id (api.path = "api_id", api.vd = "$>0; msg:sprintf('invalid api_id: %v',$)")
}

struct TfcAPIDeleteResponse {
    1: i32 code
    2: string msg
    3: TfcAPI data
}

// traffic_field

struct TfcFieldAttributes {
}

struct TfcFieldSample {
    1: string value
    2: string sampled_at
}

struct TfcFieldRule {
    1: i32 rule_id
    2: i32 version
}

struct TfcFieldTag {
    1: i64 field_id
    2: i64 tag_id
    3: list<TfcFieldRule> rules
    4: i32 level
    5: i32 level_recommended
    6: string operator
    7: string status
    8: i32 status_int
}

struct TfcField {
    1: i64 id
    2: i64 service_id
    3: i64 api_id
    4: i64 scene
    5: string class
    6: list<string> path
    7: string name
    8: string data_type
    9: list<TfcFieldSample> samples
    10: i32 level
    11: i32 level_recommended
    12: TfcFieldAttributes attributes
    13: list<TfcFieldTag> tags
}

struct TfcFieldsData {
    1: list<TfcField> fields
    2: i64 more_data
    3: i64 next_offset
}

struct TfcFieldRequest {
    1: required i64 field_id (api.path = "field_id", api.vd = "$>0; msg:sprintf('invalid field_id: %v',$)")
}

struct TfcFieldResponse {
    1: i32 code
    2: string msg
    3: TfcField data
}

struct TfcFieldsRequest {
    1: required i64 api_id (api.query = "api_id")
    2: i64 scene (api.query = "scene", go.tag="default:\"-1\"")
    3: string class (api.query = "class")
    4: string level (api.query = "level")
    5: string level_recommended (api.query = "level_recommended")
    6: i64 offset (api.query = "offset")
    7: i64 page (api.query = "page")
    8: i64 size (api.query = "size", go.tag="default:\"30\"")
}

struct TfcFieldsResponse {
    1: i32 code
    2: string msg
    3: TfcFieldsData data
}

struct TfcFieldDeleteRequest {
    1: required i64 field_id (api.path = "field_id", api.vd = "$>0; msg:sprintf('invalid field_id: %v',$)")
}

struct TfcFieldDeleteResponse {
    1: i32 code
    2: string msg
    3: TfcField data
}

struct TfcFieldTagCreateRequest {
    1: required i64 field_id (api.path = "field_id", api.vd = "$>0; msg:sprintf('invalid field_id: %v',$)")
    2: required i64 tag_id (api.body = "tag_id", api.vd = "$>0; msg:sprintf('invalid tag_id: %v',$)")
    3: i32 level (api.body = "level", api.vd = "in($,0,1,2,3,4); msg:sprintf('invalid level: %v',$)")
}

struct TfcFieldTagCreateResponse {
    1: i32 code
    2: string msg
    3: TfcFieldTag data
}

struct TfcFieldTagUpdateRequest {
    1: required i64 field_id (api.path = "field_id", api.vd = "$>0; msg:sprintf('invalid field_id: %v',$)")
    2: required i64 tag_id (api.path = "tag_id", api.vd = "$>0; msg:sprintf('invalid tag_id: %v',$)")
    3: i32 level (api.body = "level", api.vd = "in($,0,1,2,3,4); msg:sprintf('invalid level: %v',$)")
    4: string status (api.body = "status", api.vd = "in($,'','ignored','verified'); msg:sprintf('invalid status: %v',$)")
}

struct TfcFieldTagUpdateResponse {
    1: i32 code
    2: string msg
    3: TfcFieldTag data
}

// storage_db

struct StorageDBsData {
    1: list<StorageDB> dbs
    2: i64 more_data
    3: i64 next_offset
}

struct StorageDBsRequest {
    1: string region (api.query = "region")
    2: string psm (api.query = "psm")
    3: string name (api.query = "name")
    4: string bytetree (api.query = "bytetree")
    5: string bytetree_i18n (api.query = "bytetree_i18n")
    6: string owner (api.query = "owner")
    7: string level (api.query = "level")
    8: string level_recommended (api.query = "level_recommended")
    9: i64 offset (api.query = "offset")
    10: i64 page (api.query = "page")
    11: i64 size (api.query = "size", go.tag="default:\"30\"")
}

struct StorageDBsResponse {
    1: i32 code
    2: string msg
    3: StorageDBsData data
}

struct StorageDB {
    1: i64 id
    2: string region
    3: string psm
    4: string name
    5: string bytetree
    6: string bytetree_i18n
    7: i64 bytetree_id
    8: list<string> owners
    9: i32 level
    10: i32 level_recommended
    11: StorageDBAttributes attributes
}

struct StorageDBAttributes {
    1: bool store_all_headers
}

struct StorageDBRequest {
    1: required i64 db_id (api.path = "db_id", api.vd = "$>0; msg:sprintf('invalid db_id: %v',$)")
}

struct StorageDBResponse {
    1: i32 code
    2: string msg
    3: StorageDB data
}

// storage_table

struct StorageTableAttributes {}

struct StorageTable {
    1: i64 id
    2: i64 db_id
    3: string psm
    4: string name
    5: i32 level
    6: i32 level_recommended
    7: StorageTableAttributes attributes
}

struct StorageTablesData {
    1: list<StorageTable> tables
    2: i64 more_data
    3: i64 next_offset
}

struct StorageTablesRequest {
    1: i64 db_id (api.query = "db_id")
    2: string region (api.query = "region")
    3: string db_psm (api.query = "db_psm")
    4: string name (api.query = "name")
    7: string level (api.query = "level")
    8: string level_recommended (api.query = "level_recommended")
    9: i64 offset (api.query = "offset")
    10: i64 page (api.query = "page")
    11: i64 size (api.query = "size", go.tag="default:\"30\"")
}

struct StorageTablesResponse {
    1: i32 code
    2: string msg
    3: StorageTablesData data
}

struct StorageTableRequest {
    1: required i64 table_id (api.path = "table_id", api.vd = "$>0; msg:sprintf('invalid table_id: %v',$)")
}

struct StorageTableResponse {
    1: i32 code
    2: string msg
    3: StorageTable data
}

// storage_field

struct StorageFieldAttributes {
}

struct StorageFieldSample {
    1: string value
    2: string sampled_at
}

struct StorageField {
    1: i64 id
    2: i64 db_id
    3: i64 table_id
    4: list<string> path
    5: string name
    6: string data_type
    7: list<StorageFieldSample> samples
    8: i32 level
    9: i32 level_recommended
    10: StorageFieldAttributes attributes
}

struct StorageFieldsData {
    1: list<StorageField> fields
    2: i64 more_data
    3: i64 next_offset
}

struct StorageFieldRequest {
    1: required i64 field_id (api.path = "field_id", api.vd = "$>0; msg:sprintf('invalid field_id: %v',$)")
}

struct StorageFieldResponse {
    1: i32 code
    2: string msg
    3: StorageField data
}

struct StorageFieldsRequest {
    1: required i64 table_id (api.query = "table_id")
    2: string level (api.query = "level")
    3: string level_recommended (api.query = "level_recommended")
    4: i64 offset (api.query = "offset")
    5: i64 page (api.query = "page")
    6: i64 size (api.query = "size", go.tag="default:\"30\"")
}

struct StorageFieldsResponse {
    1: i32 code
    2: string msg
    3: StorageFieldsData data
}


service DSPService {

    // permission
    RoleUserGrantResponse RoleUserGrant(1:RoleUserGrantRequest req) (api.post="/v1/roles/:role_name/users")
    RoleUserRevokeResponse RoleUserRevoke(1:RoleUserRevokeRequest req) (api.delete="/v1/roles/:role_name/users")
    RoleUserVerifyResponse RoleUserVerify(1:RoleUserVerifyRequest req) (api.get="/v1/roles/:role_name/users")

    // common
    TagsResponse Tags() (api.get="/v1/tags")
    TagResponse Tag(1:TagRequest req) (api.get="/v1/tags/:tag_id")

    // Traffic
    TfcAggPatternsResponse TfcAggPatterns(1:TfcAggPatternsRequest req) (api.get="/v1/traffic/aggregation/patterns")
    TfcAggPatternResponse TfcAggPattern(1:TfcAggPatternRequest req) (api.get="/v1/traffic/aggregation/patterns/:pattern_id")
    TfcAggPatternCreateResponse TfcAggPatternCreate(1:TfcAggPatternCreateRequest req) (api.post="/v1/traffic/aggregation/patterns")
    TfcAggPatternUpdateResponse TfcAggPatternUpdate(1:TfcAggPatternUpdateRequest req) (api.patch="/v1/traffic/aggregation/patterns/:pattern_id")
    TfcAggPatternDeleteResponse TfcAggPatternDelete(1:TfcAggPatternDeleteRequest req) (api.delete="/v1/traffic/aggregation/patterns/:pattern_id")
    TfcServicesResponse TfcServices(1:TfcServicesRequest req) (api.get="/v1/traffic/services")
    TfcServiceResponse TfcService(1:TfcServiceRequest req) (api.get="/v1/traffic/services/:service_id")
    TfcAPIsResponse TfcAPIs(1:TfcAPIsRequest req) (api.get="/v1/traffic/apis")
    TfcAPIResponse TfcAPI(1:TfcAPIRequest req) (api.get="/v1/traffic/apis/:api_id")
    TfcAPIDeleteResponse TfcAPIDelete(1:TfcAPIDeleteRequest req) (api.delete="/v1/traffic/apis/:api_id")
    TfcFieldsResponse TfcFields(1:TfcFieldsRequest req) (api.get="/v1/traffic/fields")
    TfcFieldResponse TfcField(1:TfcFieldRequest req) (api.get="/v1/traffic/fields/:field_id")
    TfcFieldDeleteResponse TfcFieldDelete(1:TfcFieldDeleteRequest req) (api.delete="/v1/traffic/fields/:field_id")
    TfcFieldTagCreateResponse TfcFieldTagCreate(1:TfcFieldTagCreateRequest req) (api.post="/v1/traffic/fields/:field_id/tags")
    TfcFieldTagUpdateResponse TfcFieldTagUpdate(1:TfcFieldTagUpdateRequest req) (api.patch="/v1/traffic/fields/:field_id/tags/:tag_id")

    // Storage
    StorageDBsResponse StorageDBs(1:StorageDBsRequest req) (api.get="/v1/storage/dbs")
    StorageDBResponse StorageDB(1:StorageDBRequest req) (api.get="/v1/storage/db/:db_id")
    StorageTablesResponse StorageTables(1:StorageTablesRequest req) (api.get="/v1/storage/tables")
    StorageTableResponse StorageTable(1:StorageTableRequest req) (api.get="/v1/storage/tables/:table_id")
    StorageFieldsResponse StorageFields(1:StorageFieldsRequest req) (api.get="/v1/storage/fields")
    StorageFieldResponse StorageField(1:StorageFieldRequest req) (api.get="/v1/storage/fields/:field_id")
}