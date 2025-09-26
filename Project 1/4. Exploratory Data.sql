SELECT *
FROM layoffs_stages_updated;

-- TOTAL LAID OFF EMPLOYEES PER YEAR

SELECT 
    YEAR(`date`) AS `year`,
    SUM(total_laid_off) as Laid_off_year,
    ROUND((SUM(total_laid_off) * 100.0 / (SELECT SUM(total_laid_off) FROM layoffs_stages_updated) * 1),2) AS Percentage_Of_Total
FROM layoffs_stages_updated
WHERE YEAR(`date`) IS NOT NULL
GROUP BY `year`
ORDER BY 3 DESC;

-- TOP 5 COMPANIES THAT HAS LAID OFF EMPLOYEE PER YEAR

SELECT
	company,
    SUM(total_laid_off)
FROM layoffs_stages_updated
GROUP BY company
ORDER BY 2 DESC;

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

-- TOP 5 INDUSTRY THAT HAS LAID OFF EMPLOYEE PER YEAR

SELECT
	industry,
    YEAR(`date`),
    SUM(total_laid_off)
FROM layoffs_stages_updated
GROUP BY industry, YEAR(`date`)
ORDER BY 2 ASC;

WITH industry_year (industry, `years`, total_laid_off) AS
(
SELECT
	industry,
    YEAR(`date`),
    SUM(total_laid_off)
FROM layoffs_stages_updated
GROUP BY industry, YEAR(`date`)
ORDER BY 2 DESC
), industry_rank AS
(
SELECT *,
	DENSE_RANK() OVER(PARTITION BY `years` ORDER BY total_laid_off DESC) AS ranking
FROM industry_year
WHERE `years` IS NOT NULL
GROUP BY industry, years
)
SELECT *
FROM industry_rank
WHERE ranking <= 5;

-- TOP 5 INDUSTRY THAT RAISED FUNDS PER YEAR

SELECT DISTINCT
	industry,
    YEAR(`date`),
    SUM(funds_raised_millions) AS raised_funds
FROM layoffs_stages_updated
WHERE funds_raised_millions IS NOT NULL
GROUP BY industry, YEAR(`date`)
ORDER BY 3 DESC;

WITH industry_funds_year (industry, `years`, funds_raised_millions, PercentageOfTotal) AS
(
SELECT
	industry,
    YEAR(`date`),
    SUM(funds_raised_millions),
    ROUND((SUM(funds_raised_millions) * 100.0 / (SELECT SUM(funds_raised_millions) FROM layoffs_stages_updated) * 1),2) AS PercentageOfTotal
FROM layoffs_stages_updated
GROUP BY industry, YEAR(`date`)
ORDER BY 2 DESC
), industry_funds_rank AS
(
SELECT *,
	DENSE_RANK() OVER(PARTITION BY `years` ORDER BY funds_raised_millions DESC) AS ranking
FROM industry_funds_year
WHERE `years` IS NOT NULL
GROUP BY industry, years
)
SELECT *
FROM industry_funds_rank
WHERE ranking <= 5;

-- PERCENTAGE OF RAISED FUNDS BY INDUSTRIES

SELECT
	industry,
    SUM(funds_raised_millions) AS raised_funds,
	ROUND((SUM(funds_raised_millions) * 100.0 / (SELECT SUM(funds_raised_millions) FROM layoffs_stages_updated) * 1),2) AS PercentageOfTotal
FROM layoffs_stages_updated
WHERE funds_raised_millions IS NOT NULL
GROUP BY industry
ORDER BY 3 DESC;

-- PERCENTAGE OF LAID OFF EMPLOYEES BY INDUSTRIES

SELECT
	industry,
    SUM(total_laid_off) AS total_off,
	ROUND((SUM(total_laid_off) * 100.0 / (SELECT SUM(total_laid_off) FROM layoffs_stages_updated) * 1),2) AS PercentageOfTotal
FROM layoffs_stages_updated
WHERE funds_raised_millions IS NOT NULL
GROUP BY industry
ORDER BY 3 DESC;

-- NUMBER OF COMPANIES WHO WENT BANKRUPT 100% LAID OFF

SELECT
	COUNT(company),
    percentage_laid_off
FROM layoffs_stages_updated
WHERE percentage_laid_off = 1;

SELECT industry, country, SUM(funds_raised_millions)
FROM layoffs_stages_updated
GROUP BY industry, country
ORDER BY 3 DESC;






