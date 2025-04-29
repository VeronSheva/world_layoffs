-- Copy layoffs table into layoffs_staging,
-- where most of the processing will take place

CREATE TABLE layoffs_staging LIKE layoffs;

--Copy over the values

INSERT layoffs_staging
SELECT * FROM layoffs;

--Take care of the duplicates

-- As we don't have an ID column, use Row Number

WITH duplicate_cte AS
(SELECT *, ROW_NUMBER() OVER(
    PARTITION BY company,
    location,
    industry,
    total_laid_off,
    percentage_laid_off,
    `date`,
    stage,
    company,
    funds_raised_millions)
 AS row_num
FROM layoffs_staging
)

SELECT * FROM duplicate_cte WHERE row_num > 1;

--We have 5 duplicates

--Create one more duplicate table

CREATE TABLE layoffs_staging2 LIKE layoffs_staging;

ALTER TABLE layoffs_staging2
ADD row_num INT;

INSERT INTO `layoffs_staging2`
SELECT *, ROW_NUMBER() OVER(
    PARTITION BY company,
    location,
    industry,
    total_laid_off,
    percentage_laid_off,
    `date`,
    stage,
    company,
    funds_raised_millions)
 AS row_num
FROM layoffs_staging;

--Delete duplicates

DELETE FROM layoffs_staging2 WHERE row_num > 1;

--Standardizing Data

UPDATE layoffs_staging2
SET company = TRIM(company);

--Get rid of names like Crypto Currency and name them all Crypto

SELECT DISTINCT industry
FROM layoffs_staging2

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

--Get rid of 'United States.' and name it 'United States'

SELECT DISTINCT country
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

-- Update Date column to Date format
UPDATE layoffs_staging2
SET `date` =  STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

-- Nulls and Blanks

SELECT * FROM `layoffs_staging2`
WHERE industry IS NULL OR industry = '';

-- Set blanks to null

UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';

-- Populate industry nulls with other rows
-- with the same company and not null industry

UPDATE `layoffs_staging2` t1
JOIN `layoffs_staging2` t2
ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL AND t2.industry IS NOT NULL;

-- Data with percentage and total laid off is useless, let's delete it

SELECT COUNT(*) FROM `layoffs_staging2`
WHERE percentage_laid_off IS NULL and total_laid_off IS NULL; -- 361 rows

DELETE FROM `layoffs_staging2`
WHERE percentage_laid_off IS NULL and total_laid_off IS NULL;

-- Drop row_num column

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;