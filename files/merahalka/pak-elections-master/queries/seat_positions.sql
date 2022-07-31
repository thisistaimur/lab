SELECT * FROM public.elections_v2
LIMIT 100;

SELECT * FROM public.elections_v2
WHERE year = 2013
ORDER BY na_value
LIMIT 100
;

CREATE TEMP TABLE total_seats AS
SELECT a.party, a.year, count(DISTINCT na_value) as contested_seats, won_seats, runnerup_seats
FROM public.elections_v2 a
LEFT JOIN (SELECT party, year, count(DISTINCT na_value) as won_seats 
           FROM public.elections_v2 WHERE year = 2013 AND rvotes = 1
          GROUP BY party, year) b
          ON a.party = b.party AND a.year = b.year
LEFT JOIN (SELECT party, year, count(DISTINCT na_value) as runnerup_seats
          FROM public.elections_v2 WHERE year = 2013 AND rvotes = 2
          GROUP BY party, year) c
          ON a.party = c.party AND a.year = c.year
WHERE a.year = 2013
GROUP BY a.party, a.year, won_seats, runnerup_seats
ORDER BY contested_seats DESC
;
-- 109 records

CREATE TEMP TABLE seats_by_province AS
SELECT a.party, a.year, a.prov, count(DISTINCT na_value) as contested_seats, won_seats, runnerup_seats
FROM public.elections_v2 a
LEFT JOIN (SELECT party, year, prov, count(DISTINCT na_value) as won_seats 
           FROM public.elections_v2 WHERE year = 2013 AND rvotes = 1
          GROUP BY party, year, prov) b
          ON a.party = b.party AND a.year = b.year AND a.prov = b.prov
LEFT JOIN (SELECT party, year, prov, count(DISTINCT na_value) as runnerup_seats
          FROM public.elections_v2 WHERE year = 2013 AND rvotes = 2
          GROUP BY party, year, prov) c
          ON a.party = c.party AND a.year = c.year AND a.prov = c.prov
WHERE a.year = 2013
GROUP BY a.party, a.year, a.prov, won_seats, runnerup_seats
ORDER BY contested_seats DESC
;
-- 189 records

CREATE TEMP TABLE seats_by_region AS
SELECT a.party, a.year, a.regions_12, count(DISTINCT na_value) as contested_seats, won_seats, runnerup_seats
FROM public.elections_v2 a
LEFT JOIN (SELECT party, year, regions_12, count(DISTINCT na_value) as won_seats 
           FROM public.elections_v2 WHERE year = 2013 AND rvotes = 1
          GROUP BY party, year, regions_12) b
          ON a.party = b.party AND a.year = b.year AND a.regions_12 = b.regions_12
LEFT JOIN (SELECT party, year, regions_12, count(DISTINCT na_value) as runnerup_seats
          FROM public.elections_v2 WHERE year = 2013 AND rvotes = 2
          GROUP BY party, year, regions_12) c
          ON a.party = c.party AND a.year = c.year AND a.regions_12 = c.regions_12
WHERE a.year = 2013
GROUP BY a.party, a.year, a.regions_12, won_seats, runnerup_seats
ORDER BY contested_seats DESC
;
-- 363 records

SELECT * FROM total_seats
LIMIT 100;

SELECT * FROM seats_by_province LIMIT 100;

SELECT count(*) as records FROM total_seats; --109
SELECT count(*) as records FROM seats_by_province; --189
SELECT count(*) as records FROM seats_by_region; --363

SELECT *, 'All' as region FROM total_seats
UNION
SELECT party, year, contested_seats, won_seats, runnerup_seats,
CASE WHEN prov = 1 THEN 'Punjab' WHEN prov = 2 THEN 'Sindh' 
WHEN prov = 3 THEN 'KPK & FATA' WHEN prov = 4 THEN 'Balochistan' END as region
FROM seats_by_province
UNION
SELECT party, year, contested_seats, won_seats, runnerup_seats,
CASE WHEN regions_12 = 1 THEN 'Southern Punjab' WHEN regions_12 = 2 THEN 'Central Punjab'
WHEN regions_12 = 3 THEN 'Western Punjab' WHEN regions_12 = 4 THEN 'Northern Punjab'
WHEN regions_12 = 5 THEN 'Interior Sindh' WHEN regions_12 = 6 THEN 'Karachi Region'
WHEN regions_12 = 14 THEN 'Malakand Region' WHEN regions_12 = 15 THEN 'South KPK'
WHEN regions_12 = 16 THEN 'Peshawar Valley' WHEN regions_12 = 17 THEN 'Hazara Region'
WHEN regions_12 = 18 THEN 'Quetta Region' WHEN regions_12 = 19 THEN 'Kalat & Makran Region'
ELSE 'Unknown Region' END as region
FROM seats_by_region
ORDER BY contested_seats DESC
;

SELECT * FROM public.elections_v2;
