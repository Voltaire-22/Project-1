SELECT *
FROM layoffs_stages_updated;

SELECT 
    YEAR(`date`) AS `year`,
    SUM(total_laid_off) as Laid_off_year,
    ROUND((SUM(total_laid_off) * 100.0 / (SELECT SUM(total_laid_off) FROM layoffs_stages_updated) * 1),2) AS Percentage_Of_Total
FROM layoffs_stages_updated
WHERE YEAR(`date`) IS NOT NULL
GROUP BY `year`
ORDER BY 3 DESC;

SELECT 
    AVG(total_laid_off)
FROM layoffs_stages_updated
WHERE YEAR(`date`) IS NOT NULL;


WITH company_year (company, `years`, total_laid_off) AS
(
SELECT
	company,
    YEAR(`date`),
    SUM(total_laid_off)
FROM layoffs_stages_updated
GROUP BY company, YEAR(`date`)
ORDER BY 2 DESC
), company_rank AS
(
SELECT *,
	DENSE_RANK() OVER(PARTITION BY `years` ORDER BY total_laid_off DESC) AS ranking
FROM company_year
WHERE `years` IS NOT NULL
GROUP BY company, years
)
SELECT *
FROM company_rank
WHERE ranking <= 5;

WITH industry_funds_year (company, `years`, funds_raised_millions, PercentageOfTotal) AS
(
SELECT
	company,
    YEAR(`date`),
    SUM(funds_raised_millions),
    ROUND((SUM(funds_raised_millions) * 100.0 / (SELECT SUM(funds_raised_millions) FROM layoffs_stages_updated) * 1),2) AS PercentageOfTotal
FROM layoffs_stages_updated
GROUP BY company, YEAR(`date`)
ORDER BY 2 DESC
), industry_funds_rank AS
(
SELECT *,
	DENSE_RANK() OVER(PARTITION BY `years` ORDER BY funds_raised_millions DESC) AS ranking
FROM industry_funds_year
WHERE `years` IS NOT NULL
GROUP BY company, years
)
SELECT *
FROM industry_funds_rank
WHERE ranking <= 5;

SELECT 
	company,
    YEAR(`date`),
    total_laid_off,
    funds_raised_millions
FROM layoffs_stages_updated
WHERE 
	company = 'Uber' AND 
	YEAR(`date`) IN (2020,2021,2022,2023)
ORDER BY 2;

SELECT 
	company,
    YEAR(`date`),
    total_laid_off,
    funds_raised_millions
FROM layoffs_stages_updated
WHERE 
	company = 'Microsoft' AND 
	YEAR(`date`) IN (2020,2021,2022,2023)
ORDER BY 2;
    
SELECT 
	company,
    YEAR(`date`),
    total_laid_off,
    funds_raised_millions
FROM layoffs_stages_updated
WHERE 
	company = 'Meta' AND 
	YEAR(`date`) IN (2020,2021,2022,2023)
ORDER BY 2;

SELECT 
	company,
    YEAR(`date`),
    total_laid_off,
    funds_raised_millions
FROM layoffs_stages_updated
WHERE 
	company = 'Google' AND 
	YEAR(`date`) IN (2020,2021,2022,2023)
ORDER BY 2;

SELECT *
FROM layoffs_stages_updated;

SELECT DISTINCT industry,
SUM(total_laid_off),
SUM(funds_raised_millions)
FROM layoffs_stages_updated
WHERE industry IS NOT NULL
GROUP BY industry
ORDER BY 3 DESC;

SELECT DISTINCT industry,
SUM(total_laid_off),
SUM(funds_raised_millions),
SUM(total_laid_off) / SUM(funds_raised_millions) AS Layoffs per $1M raised
FROM layoffs_stages_updated
WHERE industry IS NOT NULL
GROUP BY industry
ORDER BY 4 DESC;
