WITH subset_oawork AS (
  SELECT 
    id,
    referenced_works, 
    JSON_VALUE(primary_topic, '$.subfield.display_name') AS subfieldName
  FROM `science-of-science.openalex_202503.works_flat`
),

paper_refs AS (
  -- Step (A): Explode each paper’s references, trim and clean data
  SELECT
    p.id AS paper_id,
    p.subfieldName AS paper_subfield,    -- Subfield of the citing paper
    TRIM(REPLACE(ref, '"', '')) AS referenced_paper_id
  FROM subset_oawork p,
  UNNEST(p.referenced_works) AS ref
),

paper_refs_with_ref_subfield AS (
  -- Step (B): Join to get subfield of referenced papers
  SELECT
    pr.paper_id,
    pr.paper_subfield,
    r.subfieldName AS ref_subfield
  FROM paper_refs pr
  JOIN subset_oawork r
    ON pr.referenced_paper_id = r.id
),

paper_vec_alpha AS (
  -- Step (C): Compute fraction of citations from subfield_i to subfield_j
  SELECT DISTINCT
    pr.paper_id,
    pr.paper_subfield,
    pr.ref_subfield,
    COUNT(*) AS count_field
  FROM paper_refs_with_ref_subfield pr
  GROUP BY pr.paper_id, pr.paper_subfield, pr.ref_subfield
),

paper_vec_norm AS (
  -- Step (D): Normalize the citation fractions for each paper
  SELECT DISTINCT
    paper_id,
    paper_subfield,
    ref_subfield,
    count_field / SUM(count_field) OVER (PARTITION BY paper_id) AS normalized_fraction
  FROM paper_vec_alpha
),

subfield_vec_v AS (
  -- Step (E): Aggregate citation vectors by subfield
  SELECT
    paper_subfield AS subfield_i,
    ref_subfield AS subfield_j,
    SUM(count_field) AS value
  FROM paper_vec_alpha
  GROUP BY paper_subfield, ref_subfield
),

subfield_norms AS (
  -- Step (F): Compute the norm for each subfield
  SELECT
    subfield_i,
    SQRT(SUM(POWER(value, 2))) AS norm
  FROM subfield_vec_v
  GROUP BY subfield_i
),

pairwise_dot AS (
  -- Step (G): Compute dot product for existing citation pairs (avoid duplicate pairs)
  SELECT
    sp1.subfield_i AS subfield1,
    sp2.subfield_i AS subfield2,
    SUM(sp1.value * sp2.value) AS dot_product
  FROM subfield_vec_v sp1
  JOIN subfield_vec_v sp2
    ON sp1.subfield_j = sp2.subfield_j
   AND sp1.subfield_i < sp2.subfield_i
  GROUP BY sp1.subfield_i, sp2.subfield_i
),

distance AS (
  -- Step (H): Compute cosine distance between subfields
  SELECT
    pd.subfield1,
    pd.subfield2,
    1 - (pd.dot_product / (n1.norm * n2.norm)) AS distance
  FROM pairwise_dot pd
  JOIN subfield_norms n1 ON pd.subfield1 = n1.subfield_i
  JOIN subfield_norms n2 ON pd.subfield2 = n2.subfield_i
  ORDER BY subfield1, subfield2
)

-- Step (I): Final Rao-Stirling Diversity computation for each paper
SELECT
  pa1.paper_id,
  2 * SUM(cd.distance * pa1.normalized_fraction * pa2.normalized_fraction) AS rao_stirling_diversity
FROM paper_vec_norm pa1
JOIN paper_vec_norm pa2
  ON pa1.paper_id = pa2.paper_id
  AND pa1.ref_subfield < pa2.ref_subfield  -- Avoid duplicate pairs
JOIN distance cd
  ON pa1.ref_subfield = cd.subfield1
  AND pa2.ref_subfield = cd.subfield2
GROUP BY pa1.paper_id
