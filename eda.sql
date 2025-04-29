-- Lets look at the date range
SELECT MAX(`date`), MIN(`date`)
FROM `layoffs_staging2`;

-- Layoff max : total(12000), percent(1(100%))
SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM `layoffs_staging2`;

-- Lets look at total laid off for companies with percentage laid off equal to 100%
SELECT COUNT(*)
FROM `layoffs_staging2`
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;
--116 companies let go of 100% of their employees

-- Let's the amount of companies with 100% people laid off by country
SELECT country, COUNT(*) as companies_closed
FROM `layoffs_staging2`
WHERE percentage_laid_off = 1
GROUP BY country
ORDER BY 2 DESC;

-- The top 5 are:
-- United States(73), India(9), Australia(8), United Kingdom(5)
-- With the USA being way ahead

-- Lets calculate the ratio of total layoffs to total funds
--raised (in millions) for each country
-- A higher ratio suggests that companies in that country may have been
--less efficient with funding, potentially overhiring
WITH Country_Total AS (
  SELECT
    country,
    SUM(funds_raised_millions) AS total_funds,
    SUM(total_laid_off) AS total_laid_off
  FROM layoffs_staging2
  WHERE funds_raised_millions IS NOT NULL AND total_laid_off IS NOT NULL
  GROUP BY country
)

SELECT
  country,
  total_funds,
  total_laid_off,
  ROUND(total_laid_off / total_funds, 3) AS layoffs_per_million
FROM Country_Total
WHERE total_funds > 0
ORDER BY layoffs_per_million DESC;
-- Top 5 most efficient countries are:
--Lithuania(0.002)
--Netherlands(0.025)
--Romania(0.107)
--United Kingdom(0.143)
--Norway(0.146)

-- Top 5 least efficient countries are:
--Russia(6.667)
--Japan(3.269)
--Finland(1.479)
--Kenya(1.39)
--Denmark(1.111)

--Lets look at total layoffs by company
SELECT company, SUM(total_laid_off)
FROM `layoffs_staging2`
GROUP BY company ORDER BY 2 DESC;

-- Top 6 are:
-- Amazon (18150 people), Google (12000), Meta(11000), Salesforce(10090), Phillips(10000),
-- Microsoft(10000)


--Layoffs by industry
SELECT industry, SUM(total_laid_off)
FROM `layoffs_staging2`
GROUP BY industry ORDER BY 2 DESC;

-- Top 5 are:
-- Consumer(45182), Retail(43613), Other(36289), Transportation(33748), Finance(28344)

-- Layoffs by country
SELECT country, SUM(total_laid_off)
FROM `layoffs_staging2`
GROUP BY country ORDER BY 2 DESC;

-- Top 5 are:
--United States(256559), India(35993), Netherlands(17220), Sweden(11264), Brazil(10391)

-- Layoffs by year
SELECT YEAR(`date`), SUM(total_laid_off)
FROM `layoffs_staging2`
GROUP BY YEAR(`date`) ORDER BY 2 DESC;

-- Year with the highest layoffs is 2022 (160661), and the lowest - 2021 (15823)
-- We only have data for the first 3 month of 2023,
-- but there's already a huge number of layoffs (125677)

-- Layoffs by stage
SELECT stage, SUM(total_laid_off)
FROM `layoffs_staging2`
GROUP BY stage ORDER BY 2 DESC;

-- The most layoffs are coming from Post-IPO companies (204132), then Unknown stage (40716),
-- Acquired(27576), Series C (20017), Series D (19225)

-- Rolling Total of Layoffs by month of the year
WITH Rolling_Total AS
(
SELECT SUBSTRING(`date`, 1, 7) AS `month`,
SUM(total_laid_off) AS total_off
FROM `layoffs_staging2`
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `month` ORDER BY 1 ASC
)

SELECT `month`, total_off,
SUM(total_off) OVER(ORDER BY `month`) AS rolling_total
FROM Rolling_Total;

-- Lets look at Rank companies by layoffs for every year
WITH Company_Year (company, years, total_laid_off) AS
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
),
Company_Year_Rank AS
(SELECT *,
DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM Company_Year
WHERE years IS NOT NULL)

SELECT * FROM Company_Year_Rank
WHERE Ranking <= 5;

--2020 Leaders:
--Uber
--Booking.com
--Groupon
--Swiggy
--Airbnb

--2021:
--Bytedance
--Katerra
--Zillow
--Instacart
--WhiteHat Jr

--2022:
--Meta
--Amazon
--Cisco
--Peloton
--Carvana
--Philips

--2023:
--Google
--Microsoft
--Ericsson
--Amazon
--Salesforce
--Dell
