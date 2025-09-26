-- STANDARDIZE DATA

SELECT 
	TRIM(company),
    TRIM(location),
    TRIM(industry),
    TRIM(total_laid_off),
    TRIM(percentage_laid_off),
    TRIM(`date`),
    TRIM(stage),
    TRIM(country),
    TRIM(funds_raised_millions)
FROM layoffs_stages_dup;

UPDATE layoffs_stages_dup
SET total_laid_off = TRIM(total_laid_off),
    percentage_laid_off = TRIM(percentage_laid_off),
    `date` = TRIM(`date`),
    stage = TRIM(stage),
    country = TRIM(country),
    funds_raised_millions = TRIM(funds_raised_millions); 

-- 11 rows has white spaces on the data
-- did all of the other column no white spaces

SELECT *
FROM layoffs_stages_dup;

ALTER TABLE layoffs_stages_dup
RENAME TO layoffs_stages_updated; -- renamed the old table from layoffs_stages_dup to layoffs_stages_updated since this is the updated table

SELECT DISTINCT industry
FROM layoffs_stages_updated
ORDER BY 1; -- found that there's Crypto Currency & CryptoCurrency which is the same

SELECT *
FROM layoffs_stages_updated
WHERE industry LIKE 'Crypto%';

UPDATE layoffs_stages_updated
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

SELECT DISTINCT country
FROM layoffs_stages_updated
ORDER BY 1; -- found United States & United States. 

SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_stages_updated
ORDER BY 1;

UPDATE layoffs_stages_updated
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

SELECT `date`,
STR_TO_DATE(`date`, '%m/%d/%Y') 
FROM layoffs_stages_updated; 

UPDATE layoffs_stages_updated
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');-- updating column type from text to date

ALTER TABLE layoffs_stages_updated
MODIFY COLUMN `date` DATE;

SELECT * 
FROM layoffs_stages_updated;
