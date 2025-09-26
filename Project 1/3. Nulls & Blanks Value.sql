-- BLANKS & NULL VALUES

SELECT *
FROM layoffs_stages_updated
WHERE industry IS NULL 
OR industry = '';

SELECT *
FROM layoffs_stages_updated
WHERE company = 'Airbnb'; 
-- in this case Airbnb has a row that has "Travel" in the industry column

SELECT t1.industry, t2.industry
FROM layoffs_stages_updated t1
JOIN layoffs_stages_updated t2
	ON t1.company = t2.company
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL; -- were able to see here what type of industry of the company that has missing/blank/null values

UPDATE layoffs_stages_updated t1
JOIN layoffs_stages_updated t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL; 
-- 0 affected rows, didnt change anything
-- upon further analyzing it seems like the missing cell is a BLANK cell NOT NULL which is why it didnt work

UPDATE layoffs_stages_updated
SET industry = NULL
WHERE industry = ''; -- did this so that BLANK cell will become NULL cell, then i can use above query

SELECT *
FROM layoffs_stages_updated
WHERE company LIKE 'Bally%'; 
-- it worked! but there's 1 company that still has missing industry 'Bally's Interactive'
-- there's only 1 row of data for 'Bally's Interactive', which is why it has still null cell for this firm

SELECT *
FROM layoffs_stages_updated
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL; 
-- in this case there's no other way i can get any data regarding about the null columns for these 2 column (no change)
-- debating wether i should delete the data for total_laid_off & percentage_laid_off that has NULL values in it

DELETE 
FROM layoffs_stages_updated
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL; 
-- 361 Rows (company) that has missing data for 2 columns (total_laid_off & percentage_laid_off)
-- Opted to delete this data since this holds no value to the final analaysis
-- this might also cause for inaccurate analysis in the end

SELECT *
FROM layoffs_stages_updated;

ALTER TABLE layoffs_stages_updated
DROP COLUMN row_num; -- drop this row_num column since this was only used to check for duplicates