SELECT 
  -- Basic metadata
  JSON_VALUE(work, '$.id') AS id,
  JSON_VALUE(work, '$.doi') AS doi,
  JSON_VALUE(work, '$.title') AS title,
  JSON_VALUE(work, '$.display_name') AS display_name,
  JSON_VALUE(work, '$.publication_year') AS publication_year,
  JSON_VALUE(work, '$.publication_date') AS publication_date,
  JSON_QUERY(work, '$.ids') AS ids,  -- Nested JSON for additional IDs
  JSON_VALUE(work, '$.language') AS language,
  JSON_QUERY(work, '$.primary_location') AS primary_location,  -- Nested JSON for primary location
  JSON_VALUE(work, '$.type') AS type,
  JSON_VALUE(work, '$.type_crossref') AS type_crossref,

  -- Timestamp fields
  JSON_VALUE(work, '$.updated_date') AS updated_date,
  JSON_VALUE(work, '$.created_date') AS created_date,

  -- Open access and laicense information
  JSON_QUERY(work, '$.open_access') AS open_access,  -- Nested JSON for OA details
  JSON_QUERY(work, '$.best_oa_location') AS best_oa_location,  -- Nested JSON for best OA location

  -- List fields
  JSON_EXTRACT_ARRAY(work, '$.indexed_in') AS indexed_in,
  JSON_EXTRACT_ARRAY(work, '$.authorships') AS authorships,
  JSON_EXTRACT_ARRAY(work, '$.institution_assertions') AS institution_assertions,
  JSON_EXTRACT_ARRAY(work, '$.keywords') AS keywords,
  JSON_EXTRACT_ARRAY(work, '$.concepts') AS concepts,
  JSON_EXTRACT_ARRAY(work, '$.topics') AS topics,
  JSON_EXTRACT_ARRAY(work, '$.related_works') AS related_works,
  JSON_EXTRACT_ARRAY(work, '$.referenced_works') AS referenced_works,
  JSON_EXTRACT_ARRAY(work, '$.locations') AS locations,

  -- Citation metrics
  JSON_VALUE(work, '$.cited_by_count') AS cited_by_count,
  JSON_VALUE(work, '$.fwci') AS fwci,  -- Field-weighted citation impact
  JSON_QUERY(work, '$.citation_normalized_percentile') AS citation_normalized_percentile,
  JSON_QUERY(work, '$.cited_by_percentile_year') AS cited_by_percentile_year,
  JSON_EXTRACT_ARRAY(work, '$.counts_by_year') AS counts_by_year,

  -- APC information
  JSON_QUERY(work, '$.apc_list') AS apc_list,
  JSON_QUERY(work, '$.apc_paid') AS apc_paid,

  -- Biblio information
  JSON_QUERY(work, '$.biblio') AS biblio,

  -- -- Primary topic
  JSON_QUERY(work, '$.primary_topic') AS primary_topic,

  -- Additional metadata
  JSON_VALUE(work, '$.has_fulltext') AS has_fulltext,
  JSON_VALUE(work, '$.fulltext_origin') AS fulltext_origin,
  JSON_VALUE(work, '$.is_retracted') AS is_retracted,
  JSON_VALUE(work, '$.is_paratext') AS is_paratext,

  -- abstract_inverted_index
  JSON_QUERY(work, '$.abstract_inverted_index') AS abstract_inverted_index,

FROM 
  `openalex_202407.works_sample100`  -- change here to the table you want to query
