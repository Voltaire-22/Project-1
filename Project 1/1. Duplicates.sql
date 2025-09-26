-- DATA Cleaning in MySQL

-- OVERVIEW PROCESS --
-- Remove Duplicates
-- Standardize Data
-- Null & Blank Values
-- Remove unnecessary column/rows

SELECT *
FROM layoffs_stages;

/*-----------------------------------------------------------------------*/
-- Create table to avoid errors on the Original/Raw Table/Data
-- will only edit from layoffs_stages table

CREATE TABLE layoffs_stages
LIKE layoffs;

INSERT layoffs_stages
SELECT *
FROM layoffs;

/*-----------------------------------------------------------------------*/

-- DUPLICATES

SELECT *,
ROW_NUMBER() OVER(
				PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_stages;

WITH cte_dup AS
(
SELECT *,
ROW_NUMBER() OVER(
				PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_stages
)
SELECT *
FROM cte_dup
WHERE row_num > 1;

-- added row num to be able to distinguish duplicates
-- created temp table to add temp column
-- found that Casper, Cazoo, Hibob, Wildlife Studios & Yahoo has a duplicate values

SELECT *
FROM layoffs_stages
WHERE company = 'Casper';

SELECT *
FROM layoffs_stages
WHERE company = 'Cazoo';

SELECT *
FROM layoffs_stages
WHERE company = 'Hibob';

SELECT *
FROM layoffs_stages
WHERE company = 'Wildlife Studios';

SELECT *
FROM layoffs_stages
WHERE company = 'Yahoo';

-- validating/ double checking duplicates data too see if this is actually a duplicate data

CREATE TABLE `layoffs_stages_dup` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO layoffs_stages_dup
SELECT *,
ROW_NUMBER() OVER(
				PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_stages;

SELECT *
FROM layoffs_stages_dup;

-- Created another table since cte is not an updatable table

DELETE
FROM layoffs_stages_dup
WHERE row_num > 1;

SELECT *
FROM layoffs_stages_dup;

-- confirmed that there are no more duplicate values in this 

/*-----------------------------------------------------------------------*/