-- EXPLORATORY DATA

SELECT * 
FROM layoffs_stages_updated;

-- Highest & lowest companies raised funds
SELECT DISTINCT
	company,
    industry,
	SUM(funds_raised_millions)
FROM layoffs_stages_updated
GROUP BY company, industry
ORDER BY SUM(funds_raised_millions) DESC;

-- Total number of Laidoff by Industry
SELECT 
	SUM(total_laid_off) AS total, 
    industry
FROM layoffs_stages_updated
GROUP BY industry
ORDER BY total DESC;

SELECT
	country,
    SUM(total_laid_off)
FROM layoffs_stages_updated
GROUP BY country
ORDER BY 2 DESC;

-- total number of laid of employee by Year
SELECT  
	MAX(total_laid_off), 
    MAX(percentage_laid_off)
FROM layoffs_stages_updated;

SELECT 
	company,
    MAX(total_laid_off)
FROM layoffs_stages_updated
GROUP BY company
ORDER BY 2 DESC;

SELECT 
	MIN(`date`),
    MAX(`date`)
FROM layoffs_stages_updated;

SELECT
	SUBSTRING(`date`, 1, 7) as `Month`, 
    SUM(total_laid_off)
FROM layoffs_stages_updated
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `Month`
ORDER BY 1 ASC;

WITH Rolling_Total AS
(
SELECT
	SUBSTRING(`date`, 1, 7) as `Month`, 
    SUM(total_laid_off) AS total
FROM layoffs_stages_updated
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `Month`
ORDER BY `Month` ASC
)
SELECT 
	`Month`, 
    total,
    SUM(total) OVER(ORDER BY `Month` ASC) AS rolling
FROM Rolling_Total;


SELECT
	company,
    YEAR(`date`),
    SUM(total_laid_off)
FROM layoffs_stages_updated
GROUP BY 
	company, 
    YEAR(`date`);

WITH Company_Year (company, `years`, total_laid_off) AS
(
SELECT
	company,
    YEAR(`date`),
    SUM(total_laid_off)
FROM layoffs_stages_updated
GROUP BY 
	company, 
    YEAR(`date`)
), Company_Rank AS
(
SELECT *,
	DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
FROM Company_Year
WHERE years IS NOT NULL
)
SELECT *
FROM Company_Rank
WHERE ranking <= 5;