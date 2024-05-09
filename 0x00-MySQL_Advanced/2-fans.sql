-- Task Description: Rank country origins of bands by the number of fans
-- Import the metal_bands table dump before executing this script

SELECT origin, SUM(nb_fans) AS nb_fans
FROM metal_bands
GROUP BY origin
ORDER BY nb_fans DESC;
