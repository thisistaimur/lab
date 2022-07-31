SELECT * FROM public.elections
WHERE year IN (2008, 2013)
AND rvotes = 1
LIMIT 100;

UPDATE public.elections
SET na_name = CASE WHEN na_name LIKE ('%?%') THEN (substring(na_name, 2)) ELSE na_name END
;
--16022 records updated


-- number of seats with voting per year
SELECT count(DISTINCT na_value) as seats, year
FROM public.elections
WHERE year IN (2002, 2008, 2013)
AND rvotes = 1
GROUP BY year
;

SELECT DISTINCT 'NA-'||na_value as na_number, count(*) as records
FROM public.elections
GROUP BY na_number
ORDER BY records DESC
LIMIT 100;

--number of seats that had a runner up by election year
SELECT year, count(DISTINCT na_value) as seats_with_runner_up
FROM public.elections
WHERE rvotes = 2
GROUP BY year
;

SELECT *
FROM public.elections
WHERE year = 2013
AND rvotes = 1
LIMIT 100;

--check which column to use for inputting total_votes and turnout
SELECT votes_polled, valid_votes+rejected_votes, total_votes, registered_voters, percentageofvotespolledtoregisteredvoters,
(valid_votes+rejected_votes)*1.0/registered_voters*100
FROM public.elections
WHERE year = 2013
AND rvotes = 1
LIMIT 100;

SELECT * FROM public.elections
WHERE
percentageofvotespolledtoregisteredvoters = 0
--registered_voters < 1
--votes_polled < 1
AND year = 2013
AND rvotes = 1
LIMIT 100;

--updated 2013 records where total_votes and turn_out columns is NULL
UPDATE public.elections
SET total_votes = votes_polled, turn_out = percentageofvotespolledtoregisteredvoters
WHERE year = 2013
;
--4456 records updated

--updated 2013 results where percentageofvotespolledtoregisteredvoters = 0 even though the ingredient columns are > 0
UPDATE public.elections
SET turn_out = total_votes*1.0/registered_voters
WHERE year = 2013
AND percentageofvotespolledtoregisteredvoters = 0 AND registered_voters > 0
;
--70 records updated

-- Top winning parties in 2013
SELECT party, count(*) as seats 
FROM public.elections
WHERE rvotes <= 2
AND year = 2013
GROUP BY party
ORDER BY seats DESC
;

UPDATE public.elections
SET party = 
CASE WHEN party = 'Pakistan Muslim League' THEN 'Pakistan Muslim League (Q)' END
WHERE year = 2013
AND party IN ('Pakistan Muslim League')
;

-- Top winning parties in 2013
SELECT party, count(*) as seats 
FROM public.elections
WHERE rvotes <= 2
AND year = 2013
GROUP BY party
ORDER BY seats DESC
;
-- 52 records updated


-- Top winning parties in 2008
SELECT party, count(*) as seats 
FROM public.elections
WHERE rvotes <= 2
AND year = 2008
GROUP BY party
ORDER BY seats DESC
;

UPDATE public.elections
SET party = 
CASE WHEN party = 'Pakistan Peoples Party' THEN 'Pakistan Peoples Party Parliamentarians'
WHEN party = 'Pakistan Muslim League' THEN 'Pakistan Muslim League (Q)' END
WHERE year = 2008
AND party IN ('Pakistan Peoples Party', 'Pakistan Muslim League')
;

-- Top winning parties in 2008
SELECT party, count(*) as seats 
FROM public.elections
WHERE rvotes <= 2
AND year = 2008
GROUP BY party
ORDER BY seats DESC
;

-- Top winning parties in 2002
SELECT party, count(*) as seats 
FROM public.elections
WHERE rvotes <= 2
AND year = 2002
GROUP BY party
ORDER BY seats DESC
;

UPDATE public.elections
SET party = 
CASE WHEN party = 'Pakistan Muslim League(QA)' THEN 'Pakistan Muslim League (Q)' 
WHEN party = 'Pakistan peoples Party Parlimentarians' THEN 'Pakistan Peoples Party Parliamentarians'
WHEN party = 'Pakistan Muslim League(N)' THEN 'Pakistan Muslim League (N)'
WHEN party = 'Muttahida Qaumi Moment' THEN 'Muttahida Qaumi Movement'
WHEN party = 'Pakistan Muslim League(F)' THEN 'Pakistan Muslim League (F)'
WHEN party = 'Pakistan Mulim League(QA)' THEN 'Pakistan Muslim League (Q)'
WHEN party = 'Pakistan Muslim League(J)' THEN 'Pakistan Muslim League (J)'
WHEN party = 'Pakistan Peoples party(Sherpao)' THEN 'Pakistan Peoples Party (Sherpao)'
WHEN party = 'Pakistan Muslim League(Z)' THEN 'Pakistan Muslim League (Z)'
WHEN party = 'Pakistan Peoples Party Parlimentarians' THEN 'Pakistan Peoples Party Parliamentarians'
WHEN party = 'Pakistan Peoples Party Parliamentarian' THEN 'Pakistan Peoples Party Parliamentarians'
WHEN party = 'Muthida Qaumi Movement' THEN 'Muttahida Qaumi Movement'
WHEN party = 'Muttahidda Majlis-e-Amal' THEN 'Muttahidda Majlis-e-Amal Pakistan'
END
WHERE year = 2002
AND party IN ('Pakistan Muslim League(QA)', 'Pakistan peoples Party Parlimentarians', 'Pakistan Muslim League(N)', 
             'Muttahida Qaumi Moment', 'Pakistan Muslim League(F)', 'Pakistan Mulim League(QA)', 'Pakistan Muslim League(J)',
             'Pakistan Peoples party(Sherpao)', 'Pakistan Muslim League(Z)', 'Pakistan Peoples Party Parlimentarians', 
             'Pakistan Peoples Party Parliamentarian', 'Muthida Qaumi Movement', 'Muttahidda Majlis-e-Amal')
;
-- 565 records updated

-- Top winning parties in 2002
SELECT party, count(*) as seats 
FROM public.elections
WHERE rvotes <= 2
AND year = 2002
GROUP BY party
ORDER BY seats DESC
;

SELECT a.year, 'NA-'||a.na_value as na_number, a.na_value, a.na_name, candidate_name as winner, party as winner_party, 
runnerup, runnerup_party, round(diff_runner_up*100.0/total_votes, 1) as victory_margin, turn_out,
CASE WHEN party IN ('Pakistan Muslim League (N)', 'Pakistan Peoples Party Parliamentarians',  'Pakistan Tehreek-e-Insaf', 
                    'Independent', 'Muttahidda Qaumi Movement', 'Jamiat Ulama-e-Islam (F)') THEN party 
                    ELSE 'Other' END as winner_party_cat,
CASE WHEN runnerup_party IN ('Pakistan Muslim League (N)', 'Pakistan Peoples Party Parliamentarians',  'Pakistan Tehreek-e-Insaf', 
                    'Independent', 'Muttahidda Qaumi Movement', 'Jamiat Ulama-e-Islam (F)') THEN runnerup_party 
                    ELSE 'Other' END as runnerup_party_cat
FROM public.elections a
LEFT JOIN (SELECT year, na_value, candidate_name as runnerup, party as runnerup_party
          FROM public.elections WHERE year IN (2013) AND rvotes = 2) b
          ON a.year = b.year AND a.na_value = b.na_value
WHERE a.year IN (2013)
AND rvotes = 1
;

SELECT a.year, 'NA-'||a.na_value as na_number, a.na_value, a.na_name, candidate_name as winner, party as winner_party, 
runnerup, runnerup_party, round(diff_runner_up*100.0/total_votes, 1) as victory_margin, turn_out,
CASE WHEN party IN ('Pakistan Peoples Party Parliamentarians', 'Pakistan Muslim League (Q)',  'Pakistan Muslim League (N)', 
                    'Independent', 'Muttahida Qaumi Movement Pakistan', 'Awami National Party', 'Mutthida Majlis-e-Amal Pakistan (MMA)') THEN party 
                    ELSE 'Other' END as winner_party_cat,
CASE WHEN runnerup_party IN ('Pakistan Peoples Party Parliamentarians', 'Pakistan Muslim League (Q)',  'Pakistan Muslim League (N)', 
                    'Independent', 'Muttahida Qaumi Movement Pakistan', 'Awami National Party', 'Mutthida Majlis-e-Amal Pakistan (MMA)') THEN runnerup_party 
                    ELSE 'Other' END as runnerup_party_cat
FROM public.elections a
LEFT JOIN (SELECT year, na_value, candidate_name as runnerup, party as runnerup_party
          FROM public.elections WHERE year IN (2008) AND rvotes = 2) b
          ON a.year = b.year AND a.na_value = b.na_value
WHERE a.year IN (2008)
AND rvotes = 1
;

SELECT a.year, 'NA-'||a.na_value as na_number, a.na_value, a.na_name, candidate_name as winner, party as winner_party, 
runnerup, runnerup_party, round(diff_runner_up*100.0/total_votes, 1) as victory_margin, turn_out,
CASE WHEN party IN ('Pakistan Peoples Party Parliamentarians', 'Pakistan Muslim League (Q)', 'Muttahidda Majlis-e-Amal Pakistan', 
                   'Independent', 'Pakistan Muslim League (N)', 'National Alliance', 'Muttahida Qaumi Movement', 
                   'Awami National Party') THEN party ELSE 'Other' END as winner_party_cat,
CASE WHEN runnerup_party IN ('Pakistan Peoples Party Parliamentarians', 'Pakistan Muslim League (Q)', 'Muttahidda Majlis-e-Amal Pakistan', 
                   'Independent', 'Pakistan Muslim League (N)', 'National Alliance', 'Muttahida Qaumi Movement', 
                   'Awami National Party') THEN runnerup_party ELSE 'Other' END as runnerup_party_cat
FROM public.elections a
LEFT JOIN (SELECT year, na_value, candidate_name as runnerup, party as runnerup_party
          FROM public.elections WHERE year IN (2002) AND rvotes = 2) b
          ON a.year = b.year AND a.na_value = b.na_value
WHERE a.year IN (2002)
AND rvotes = 1
;

SELECT na_name, strpos(na_name, '?') as posit, substring(na_name, 2)
FROM public.elections
WHERE na_name LIKE ('%?%')
LIMIT 100;

SELECT * FROM public.elections
LIMIT 100
;