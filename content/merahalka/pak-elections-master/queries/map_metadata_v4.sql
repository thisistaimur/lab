SELECT * FROM public.elections_v2
WHERE year IN (2008, 2013)
AND rvotes = 1
LIMIT 100;


SELECT * FROM public.na_lookup;


SELECT * FROM public.elections_v2
WHERE (valid_votes < 1 OR valid_votes IS NULL)
AND year IN (2002, 2008, 2013)
LIMIT 100;

SELECT year, max(rejected_votes*1.0/total_votes) as max_value, min(rejected_votes*1.0/total_votes) as min_value
FROM elections_v2
WHERE year IN (2002, 2008, 2013)
GROUP BY year
;

SELECT na_value, na_name, (rejected_votes*1.0/total_votes) as val
FROM public.elections_v2
WHERE year IN (2002, 2008, 2013) AND (rejected_votes*1.0/total_votes) > 0.15
;

SELECT * FROM elections_v2
WHERE year = 2013 AND na_value = '201';


SELECT * FROM elections_v2
WHERE year = 2013 AND rvotes = 1
AND total_votes - rejected_votes = 0;

SELECT * FROM (
SELECT year, party1, party, count(*) as won_seats 
FROM elections_v2
WHERE year > 1979 AND rvotes = 1
GROUP BY year, party1, party) a
WHERE won_seats > 3
ORDER BY year DESC, won_seats DESC
;

SELECT * FROM (
SELECT year, party1, party, count(*) as won_seats 
FROM elections_v2
WHERE year = 2013 AND rvotes = 1
GROUP BY year, party1, party) a
--WHERE won_seats > 3
ORDER BY year DESC, won_seats DESC
;

SELECT * FROM (
SELECT year, party1, party, count(*) as seats 
FROM elections_v2
WHERE year = 2002 --AND rvotes = 1
GROUP BY year, party1, party) a
--WHERE won_seats > 3
ORDER BY year DESC, seats DESC
;

SELECT * FROM elections_v2
WHERE (party = 'JI' or party LIKE 'Jamaat-e-Islami%')
AND year NOT IN (2013)
LIMIT 100;

SELECT * FROM elections_v2
WHERE lower(candidate_name) LIKE 'qazi hussain ah%'
AND year NOT IN (2013)
LIMIT 100;

--UPDATE elections_v2
--SET party1 = CASE WHEN party = 'Pakistan Muslim League (N)' THEN 121 WHEN party = 'Pakistan Peoples Party Parliamentarians' THEN 124
--WHEN party = 'Independent' THEN 39 WHEN party = 'Muttahidda Qaumi Movement' THEN 87 WHEN party = 'Jamiat Ulama-e-Islam (F)' THEN 55
--WHEN party = 'Pakistan Muslim League (Q)' THEN 119 WHEN party = 'Awami National Party' THEN 5
--WHEN party = 'Pakistan Tehreek-e-Insaf' THEN 132
--WHEN party = 'Pakistan Muslim League (F)' THEN 120 WHEN party = 'Pukhtoonkhwa Milli Awami Party' THEN 123
--WHEN party = 'National Party' THEN 197 WHEN party = 'Pakistan Muslim League(Z)' THEN 122
--WHEN party = 'Qaumi Watan Party (Sherpao)' THEN 126 WHEN party = 'Balochistan National Party' THEN 17
--WHEN party = 'National Peoples Party' THEN 95 ELSE party1 END
--WHERE year = 2013
--;
--4456 records updated

--DROP TABLE metadata_2013;
--CREATE TABLE metadata_2013 AS
SELECT a.year, 'NA-'||a.na_value as na_number, CAST(a.na_value as int) as na_value, a.na_name, candidate_name as winner, party as winner_party, 
runnerup, runnerup_party, diff_runner_up*100.0/(total_votes-rejected_votes) as victory_margin, turn_out,
CASE WHEN party IN ('Pakistan Muslim League (N)', 'Pakistan Peoples Party Parliamentarians',  'Pakistan Tehreek-e-Insaf', 
                    'Independent', 'Muttahidda Qaumi Movement', 'Jamiat Ulama-e-Islam (F)') THEN party 
                    ELSE 'Other' END as winner_party_cat,
CASE WHEN runnerup_party IN ('Pakistan Muslim League (N)', 'Pakistan Peoples Party Parliamentarians',  'Pakistan Tehreek-e-Insaf', 
                    'Independent', 'Muttahidda Qaumi Movement', 'Jamiat Ulama-e-Islam (F)') THEN runnerup_party 
                    ELSE 'Other' END as runnerup_party_cat,
party1 as winner_party_num, runnerup_party_num
FROM public.elections_v2 a
LEFT JOIN (SELECT year, na_value, candidate_name as runnerup, party as runnerup_party, party1 as runnerup_party_num
          FROM public.elections_v2 WHERE year IN (2013) AND rvotes = 2) b
          ON a.year = b.year AND a.na_value = b.na_value AND a.year = 2013 AND a.rvotes = 1
WHERE a.year IN (2013) AND rvotes = 1
;
--271 records

--INSERT INTO metadata_2013 (na_value, na_number, na_name, year)
SELECT *, 2013 FROM na_lookup
WHERE na_number NOT IN (SELECT na_number FROM metadata_2013);

SELECT * FROM metadata_2013;


DROP TABLE metadata_2008;
--CREATE TABLE metadata_2008 AS
--SELECT a.year, 'NA-'||a.na_value as na_number, a.na_value, a.na_name, candidate_name as winner, party as winner_party, 
runnerup, runnerup_party, diff_runner_up*100.0/total_votes as victory_margin, turn_out,
CASE WHEN party IN ('Pakistan Peoples Party Parliamentarians', 'Pakistan Muslim League (Q)',  'Pakistan Muslim League (N)', 
                    'Independent', 'Muttahida Qaumi Movement Pakistan', 'Awami National Party', 'Mutthida Majlis-e-Amal Pakistan (MMA)') THEN party 
                    ELSE 'Other' END as winner_party_cat,
CASE WHEN runnerup_party IN ('Pakistan Peoples Party Parliamentarians', 'Pakistan Muslim League (Q)',  'Pakistan Muslim League (N)', 
                    'Independent', 'Muttahida Qaumi Movement Pakistan', 'Awami National Party', 'Mutthida Majlis-e-Amal Pakistan (MMA)') THEN runnerup_party 
                    ELSE 'Other' END as runnerup_party_cat,
party1 as winner_party_num, runnerup_party_num
FROM public.elections_v2 a
LEFT JOIN (SELECT year, na_value, candidate_name as runnerup, party as runnerup_party, party1 as runnerup_party_num
          FROM public.elections_v2 WHERE year IN (2008) AND rvotes = 2) b
          ON a.year = b.year AND a.na_value = b.na_value
WHERE a.year IN (2008)
AND rvotes = 1
;
--266

--INSERT INTO metadata_2008 (na_value, na_number, na_name, year)
SELECT *, 2008 FROM na_lookup
WHERE na_number NOT IN (SELECT na_number FROM metadata_2008);

SELECT * FROM metadata_2008;

--DROP TABLE metadata_2002;
--CREATE TABLE metadata_2002 AS
SELECT a.year, 'NA-'||a.na_value as na_number, a.na_value, a.na_name, candidate_name as winner, party as winner_party, 
runnerup, runnerup_party, diff_runner_up*100.0/total_votes as victory_margin, turn_out,
CASE WHEN party IN ('Pakistan Peoples Party Parliamentarians', 'Pakistan Muslim League (Q)', 'Muttahidda Majlis-e-Amal Pakistan', 
                   'Independent', 'Pakistan Muslim League (N)', 'National Alliance', 'Muttahida Qaumi Movement', 
                   'Awami National Party') THEN party ELSE 'Other' END as winner_party_cat,
CASE WHEN runnerup_party IN ('Pakistan Peoples Party Parliamentarians', 'Pakistan Muslim League (Q)', 'Muttahidda Majlis-e-Amal Pakistan', 
                   'Independent', 'Pakistan Muslim League (N)', 'National Alliance', 'Muttahida Qaumi Movement', 
                   'Awami National Party') THEN runnerup_party ELSE 'Other' END as runnerup_party_cat,
party1 as winner_party_num, runnerup_party_num
FROM public.elections_v2 a
LEFT JOIN (SELECT year, na_value, candidate_name as runnerup, party as runnerup_party, party1 as runnerup_party_num
          FROM public.elections_v2 WHERE year IN (2002) AND rvotes = 2) b
          ON a.year = b.year AND a.na_value = b.na_value
WHERE a.year IN (2002)
AND rvotes = 1
;
--272

--INSERT INTO metadata_2002 (na_value, na_number, na_name, year)
SELECT *, 2002 FROM na_lookup
WHERE na_number NOT IN (SELECT na_number FROM metadata_2002);

SELECT * FROM metadata_2002;

--CREATE TABLE metadata_1997 AS
SELECT a.year, 'NA-'||a.na_value as na_number, a.na_value, a.na_name, candidate_name as winner, party as winner_party, 
runnerup, runnerup_party, diff_runner_up*100.0/total_votes as victory_margin, turn_out,
CASE WHEN party IN ('PML-N', 'PPP', 'ANP', 'HPG','IND') THEN party ELSE 'Other' END as winner_party_cat,
CASE WHEN runnerup_party IN ('PML-N', 'PPP', 'ANP', 'HPG','IND') THEN runnerup_party ELSE 'Other' END as runnerup_party_cat,
party1 as winner_party_num, runnerup_party_num
FROM public.elections_v2 a
LEFT JOIN (SELECT year, na_value, candidate_name as runnerup, party as runnerup_party, party1 as runnerup_party_num
          FROM public.elections_v2 WHERE year IN (1997) AND rvotes = 2) b
          ON a.year = b.year AND a.na_value = b.na_value
WHERE a.year IN (1997)
AND rvotes = 1
;

SELECT * FROM metadata_1997;

--CREATE TABLE metadata_1993 AS
SELECT a.year, 'NA-'||a.na_value as na_number, a.na_value, a.na_name, candidate_name as winner, party as winner_party, 
runnerup, runnerup_party, diff_runner_up*100.0/total_votes as victory_margin, turn_out,
CASE WHEN party IN ('PML(N)', 'PPP', 'ANP', 'PML(J)','IND') THEN party ELSE 'Other' END as winner_party_cat,
CASE WHEN runnerup_party IN ('PML(N)', 'PPP', 'ANP', 'PML(J)','IND') THEN runnerup_party ELSE 'Other' END as runnerup_party_cat,
party1 as winner_party_num, runnerup_party_num
FROM public.elections_v2 a
LEFT JOIN (SELECT year, na_value, candidate_name as runnerup, party as runnerup_party, party1 as runnerup_party_num
          FROM public.elections_v2 WHERE year IN (1993) AND rvotes = 2) b
          ON a.year = b.year AND a.na_value = b.na_value
WHERE a.year IN (1993)
AND rvotes = 1
;

SELECT * FROM metadata_1993;

SELECT * FROM public.elections_v2
LIMIT 100
;
