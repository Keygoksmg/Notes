SELECT
  id,
  JSON_VALUE(authorship, '$.author_position') AS author_position,
  JSON_VALUE(authorship, '$.author.display_name') AS author_display_name,
  JSON_VALUE(authorship, '$.author.id') AS author_id,
  JSON_VALUE(authorship, '$.author.orcid') AS orcid,
  JSON_VALUE(authorship, '$.author.is_corresponding') AS is_corresponding,
  -- select first institution in a list as author's representative institution
  JSON_VALUE(JSON_QUERY_ARRAY(authorship, '$.institutions')[SAFE_OFFSET(0)], '$.id') AS institution_id,
  JSON_VALUE(JSON_QUERY_ARRAY(authorship, '$.institutions')[SAFE_OFFSET(0)], '$.display_name') AS institution_display_name,
  JSON_VALUE(JSON_QUERY_ARRAY(authorship, '$.institutions')[SAFE_OFFSET(0)], '$.ror') AS institution_ror,
  JSON_VALUE(JSON_QUERY_ARRAY(authorship, '$.institutions')[SAFE_OFFSET(0)], '$.country_code') AS institution_country_code,
  JSON_VALUE(JSON_QUERY_ARRAY(authorship, '$.institutions')[SAFE_OFFSET(0)], '$.type') AS institution_type,
  
FROM `science-of-science.openalex_202503.works_flat`,
-- FROM `science-of-science.openalex_202407.test_csv`,
UNNEST(authorships) AS authorship