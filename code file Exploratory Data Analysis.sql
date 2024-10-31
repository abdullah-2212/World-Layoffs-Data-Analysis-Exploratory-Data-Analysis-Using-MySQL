-- Exploratory Data Analysis

-- 1) What does the data in the layoffs_staging2 table look like?

SELECT * 
FROM world_layoffs.layoffs_staging2;


-- 2) What is the maximum number of layoffs and the highest percentage of layoffs in the dataset?

SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM world_layoffs.layoffs_staging2;


-- 3) Which companies had a 100% layoff rate, and what were the total layoffs for each?

SELECT *
FROM world_layoffs.layoffs_staging2
WHERE  percentage_laid_off = 1
ORDER BY total_laid_off DESC;


-- 4) Among companies with a 100% layoff rate, which raised the most funds?

SELECT *
FROM world_layoffs.layoffs_staging2
WHERE  percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;


-- 5) What is the total number of layoffs per company, sorted in descending order?

SELECT company, SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;


-- 6) What are the earliest and latest dates of layoffs in the dataset?

SELECT MIN(`date`), MAX(`date`)
FROM world_layoffs.layoffs_staging2;


-- 7) Which industries have the highest total layoffs?

SELECT industry, SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;


-- 8) What is the data in the layoffs_staging2 table?

SELECT * 
FROM world_layoffs.layoffs_staging2;


-- 9) Which countries experienced the most layoffs?

SELECT country, SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;


-- 10) What are the total layoffs by date, in descending order?
 
SELECT `date`, SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY `date`
ORDER BY 1 DESC;


-- 11) What are the total layoffs per year, in descending order?

SELECT YEAR(`date`), SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;


-- 12) How many layoffs occurred at each company stage, sorted by the highest total?

SELECT stage, SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;


-- Rolling total on Layoffs
-- 13) What is the monthly total of layoffs over time?

SELECT SUBSTRING(date,1,7) as `MONTH`, SUM(total_laid_off) 
FROM layoffs_staging2
WHERE SUBSTRING(date,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC;


-- 14) How can we calculate a rolling total of layoffs by month using a Common Table Expression (CTE)?

WITH Rolling_total AS
(
SELECT SUBSTRING(date,1,7) as `MONTH`, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE SUBSTRING(date,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC
)
SELECT `MONTH`, total_off,
SUM(total_off) OVER(ORDER BY `MONTH`) AS rolling_total
FROM Rolling_total;


-- 15) What is the total number of layoffs per company per year, sorted by the highest total layoffs?

SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC;


-- 16) Which companies had the top 5 highest layoffs each year, using two CTEs?

WITH Company_Year (company, years, total_laid_off) AS
(
SELECT company, YEAR(`date`), SUM(total_laid_off)  -- 1st CTE
FROM world_layoffs.layoffs_staging2
GROUP BY company, YEAR(`date`)
), 
Company_Year_Rank AS -- then we give it a rank and filter on that rank as 2nd CTE
(
SELECT *,
DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM Company_Year -- Then we hit of the 1st CTE to make the 2nd CTE
WHERE years IS NOT NULL
)
SELECT * -- then we query off the final CTE
FROM Company_Year_Rank
WHERE Ranking <= 5;
