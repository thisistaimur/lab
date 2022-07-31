SELECT * FROM public.elections
WHERE rvotes < 3
--AND year = 2013
AND totalvotes =0
LIMIT 100;

SELECT year, na_value, na_name, party_name, party1, rvotes, votes, totalvotes
FROM public.elections
WHERE rvotes < 2
AND year = 2013
ORDER BY year, na_value, na_name, rvotes
LIMIT 100;

SELECT year, prov, party_name, 
SELECT year, prov, na_value, na_name, party_name, rvotes, turn_out, votes, diff_runner_up, 
round(diff_runner_up*100.0/totalvotes, 1) as margin,
winner_percentage, validvotes, rejectedvotes, registered_voters
FROM public.elections
WHERE rvotes = 1
AND totalvotes != 0 AND diff_runner_up IS NOT NULL AND diff_runner_up != 0
AND year = 2013
ORDER BY year, margin
LIMIT 100;