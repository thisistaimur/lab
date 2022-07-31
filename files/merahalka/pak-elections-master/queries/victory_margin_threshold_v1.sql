SELECT * FROM metadata_2002
--WHERE winner_party_num = 0 OR winner_party_num IS NULL
LIMIT 100;

SELECT * FROM metadata_2008
WHERE winner_party_num = 0 OR winner_party_num IS NULL
LIMIT 100;

SELECT * FROM metadata_2013
WHERE winner_party_num = 0 OR winner_party_num IS NULL
LIMIT 100;

-- Table comparing 2002 and 2008 results. Goal is to identify which seats were retained signnified by retention_flag = 1
CREATE TEMP TABLE comp_2002_2008 AS
SELECT a.*, b.year as next_year, b.winner as next_winner, b.winner_party as next_winner_party, b.victory_margin as next_victory_margin, 
b.winner_party_num as next_winner_party_num, 0 as retention_flag
FROM metadata_2002 a
INNER JOIN metadata_2008 b
ON a.na_number = b.na_number
;

--Review which seats had the same party winning in both 2002 and 2008 based on party_num
SELECT winner_party, winner_party_num, count(*) as seats 
FROM comp_2002_2008
WHERE winner_party_num = next_winner_party_num
GROUP BY winner_party, winner_party_num;

--Set retention_flag = 1 for seats where prev and next winner_party_num were the same
UPDATE comp_2002_2008
SET retention_flag = 1
WHERE winner_party_num = next_winner_party_num
;
--89

--Review seats where prev winner_party_num and next_winner_party_num were different
SELECT winner_party, winner_party_num, count(*) as seats 
FROM comp_2002_2008
WHERE winner_party_num != next_winner_party_num
GROUP BY winner_party, winner_party_num;



--From seats where winner_party_nums were different, look at seats belonging to PML-Q
SELECT winner_party, winner_party_num, next_winner_party, next_winner_party_num, count(*) as seats 
FROM comp_2002_2008
WHERE winner_party_num != next_winner_party_num
AND winner_party_num = 118
GROUP BY winner_party, winner_party_num, next_winner_party, next_winner_party_num;

--Set retention_flag = 1 for PML-Q seats, since their party_num changed from 118 to 119 when going from 2002 to 2008 elections
UPDATE comp_2002_2008
SET retention_flag = 1
WHERE winner_party_num = 118 AND next_winner_party_num = 119
;
--18 records

SELECT winner_party, winner_party_num, next_winner_party, next_winner_party_num, count(*) as seats 
FROM comp_2002_2008
WHERE winner_party_num != next_winner_party_num
AND winner_party_num = 126
GROUP BY winner_party, winner_party_num, next_winner_party, next_winner_party_num;


SELECT na_number, na_name, winner_party, winner_party_num, next_winner_party, next_winner_party_num, count(*) as seats 
FROM comp_2002_2008
WHERE winner_party_num != next_winner_party_num
AND winner_party_num = 93
GROUP BY na_number, na_name, winner_party, winner_party_num, next_winner_party, next_winner_party_num;

UPDATE comp_2002_2008
SET retention_flag = 1
WHERE winner_party_num = 93 AND next_winner_party_num = 95;
--1 record updated

SELECT winner_party, winner_party_num, next_winner_party, next_winner_party_num, count(*) as seats 
FROM comp_2002_2008
WHERE winner_party_num != next_winner_party_num
AND winner_party_num = 124
GROUP BY winner_party, winner_party_num, next_winner_party, next_winner_party_num;

SELECT count(*) as seats
FROM comp_2002_2008
WHERE retention_flag = 1
;

SELECT * FROM comp_2002_2008
WHERE retention_flag = 1
;

SELECT sum(victory_margin)/count(*)
FROM comp_2002_2008
WHERE retention_flag = 1
;
-- avg victory_margin = 19.8

SELECT * FROM comp_2002_2008
WHERE retention_flag = 1
ORDER BY victory_margin
;
-- median victory_margin = 18.65

SELECT stddev_samp(victory_margin)
FROM comp_2002_2008
WHERE retention_flag = 1
;
--15.06 pop, 15.13 samp


---------------------------------------------------------------------
/* Get similar victory_margin metrics when comparing 2008 to 2013 */
---------------------------------------------------------------------

-- Table comparing 2008 and 2013 results. Goal is to identify which seats were retained signnified by retention_flag = 1
CREATE TEMP TABLE comp_2008_2013 AS
SELECT a.*, b.year as next_year, b.winner as next_winner, b.winner_party as next_winner_party, b.victory_margin as next_victory_margin, 
b.winner_party_num as next_winner_party_num, 0 as retention_flag
FROM metadata_2008 a
INNER JOIN metadata_2013 b
ON a.na_number = b.na_number
;

--Review which seats had the same party winning in both 2008 and 2013 based on party_num
SELECT winner_party, winner_party_num, count(*) as seats 
FROM comp_2008_2013
WHERE winner_party_num = next_winner_party_num
GROUP BY winner_party, winner_party_num;

--Set retention_flag = 1 for seats where prev and next winner_party_num were the same
UPDATE comp_2008_2013
SET retention_flag = 1
WHERE winner_party_num = next_winner_party_num
;
--122

--Review seats where prev winner_party_num and next_winner_party_num were different
SELECT winner_party, winner_party_num, count(*) as seats 
FROM comp_2008_2013
WHERE winner_party_num != next_winner_party_num
GROUP BY winner_party, winner_party_num;


--From seats where winner_party_nums were different, look at seats belonging to MMA
SELECT winner_party, winner_party_num, next_winner_party, next_winner_party_num, count(*) as seats 
FROM comp_2008_2013
WHERE winner_party_num != next_winner_party_num
AND winner_party_num = 880
GROUP BY winner_party, winner_party_num, next_winner_party, next_winner_party_num;

SELECT na_number, na_name, winner_party, winner_party_num, next_winner_party, next_winner_party_num, count(*) as seats 
FROM comp_2008_2013
WHERE winner_party_num != next_winner_party_num
AND winner_party_num = 880
GROUP BY na_number, na_name, winner_party, winner_party_num, next_winner_party, next_winner_party_num;

UPDATE comp_2008_2013
SET retention_flag = 1
WHERE winner_party_num = 880 AND next_winner_party_num = 55
;
-- 2 records updated

SELECT winner_party, winner_party_num, next_winner_party, next_winner_party_num, count(*) as seats 
FROM comp_2008_2013
WHERE winner_party_num != next_winner_party_num
AND winner_party_num = 198
GROUP BY winner_party, winner_party_num, next_winner_party, next_winner_party_num;

SELECT na_number, na_name, winner_party, winner_party_num, next_winner_party, next_winner_party_num, count(*) as seats 
FROM comp_2008_2013
WHERE winner_party_num != next_winner_party_num
AND winner_party_num = 198
GROUP BY na_number, na_name, winner_party, winner_party_num, next_winner_party, next_winner_party_num;

SELECT winner_party, winner_party_num, next_winner_party, next_winner_party_num, count(*) as seats 
FROM comp_2008_2013
WHERE winner_party_num != next_winner_party_num
AND winner_party_num = 124
GROUP BY winner_party, winner_party_num, next_winner_party, next_winner_party_num;

SELECT count(*) as seats
FROM comp_2008_2013
WHERE retention_flag = 1
;

SELECT sum(victory_margin)/count(*)
FROM comp_2008_2013
WHERE retention_flag = 1
;
-- avg victory_margin = 27.8

SELECT * FROM comp_2008_2013
WHERE retention_flag = 1
ORDER BY victory_margin
;
-- median victory margin = 23.3

SELECT stddev_pop(victory_margin)
FROM comp_2008_2013
WHERE retention_flag = 1
;
-- pop 22.84, samp 22.93


