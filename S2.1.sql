WITH t1 AS (
  SELECT place, 
   (SELECT max(x) FROM unnest(yearsLived) x) max_year, -- identify the most recent year
   (SELECT min(x) FROM unnest(yearsLived) x) min_year -- identify the oldest year
  FROM `groovy-sky-25.training_data.personsData`as p, unnest(p.citiesLived) 
),

-- I think, you can easily combine t1 and t2 into one query - try it while formatting it nicely!
t2 AS (
  SELECT place, 
    (max_year-min_year) as span -- sum of the time spans across the table
  FROM t1 
),

-- I needed a while to comprehend why you count place as person and add it to the year span
-- If you SELECT * FROM t2 you see that some spans are 0. My idea was to give all spans just +1 to not have 0
--  because they lived there for at least one year
-- Can you try to implement the +1 instead of the "count(place) as person" solution?
t3 AS (
  SELECT place, 
    count(place) as person, -- identify the the number of people have been lived in the specific place
    sum(span) as Yspan -- sum the time spans for the same space
  FROM t2 
  GROUP BY place
) 

SELECT place, (person+Yspan) AS reportedYears 
FROM t3 
ORDER BY reportedYears DESC
