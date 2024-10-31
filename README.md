# World Layoffs Data Analysis Exploratory Data Analysis Using MySQL

**Introduction**

This project delves into global layoff data, focusing on identifying significant trends, high-impact sectors, and time-based patterns in layoffs across various industries and countries. Using SQL, the project examines a range of metrics—from total layoffs to layoff percentages—allowing for a comprehensive exploration of workforce reduction trends worldwide.

**Dataset Description**

The analysis uses data from the **layoffs_staging2** table, containing fields such as:

* **Company:** The name of the organization.

* **Total Employees Laid Off:** Number of layoffs per company.

* **Layoff Percentage:** Proportion of employees laid off relative to the company’s total workforce.

* **Funding Raised (in Millions):** Company’s funding, in millions.

* **Industry:** Sector to which the company belongs.

* **Country:** Country where layoffs occurred.

* **Layoff Date:** Date when layoffs were recorded.

* **Company Growth Stage:** The development stage of the company (e.g., Startup, Public).

**Key Analysis Questions**

The project addresses critical questions to gain insights, such as:

* Which companies and industries reported the highest layoffs?
* Are there companies with a 100% layoff rate?
* Which countries show the largest layoff numbers?
* How do layoffs vary over time (monthly and yearly)?
* What cumulative trends can be observed across industries?

**Analysis Walkthrough**

Below is a summary of the SQL queries used, along with the insights they reveal.

**1) Dataset Preview**

      SELECT * FROM world_layoffs.layoffs_staging2;

Displays the dataset structure and initial data points.

**2) Peak Layoff Totals and Percentages**

      SELECT MAX(total_laid_off), MAX(percentage_laid_off)
      FROM world_layoffs.layoffs_staging2;

Identifies the highest layoffs and layoff rates in a single event.

**3) Companies with Total Workforce Layoffs**

      SELECT * FROM world_layoffs.layoffs_staging2
      WHERE percentage_laid_off = 1
      ORDER BY total_laid_off DESC;

Lists companies with a 100% layoff rate, sorted by total layoffs.

**4) Top-Funded Companies with Full Layoffs**

      SELECT * FROM world_layoffs.layoffs_staging2
      WHERE percentage_laid_off = 1
      ORDER BY funds_raised_millions DESC;

Shows companies with full layoffs, ranked by funds raised.

**5) Company-Specific Layoff Totals**

      SELECT company, SUM(total_laid_off)
      FROM world_layoffs.layoffs_staging2
      GROUP BY company
      ORDER BY 2 DESC;

Aggregates layoffs per company, highlighting the most affected.

**6) Layoff Timeline**

      SELECT MIN(`date`), MAX(`date`)
      FROM world_layoffs.layoffs_staging2;

Determines the date range of layoffs in the dataset.

**7) Layoffs by Industry**

      SELECT industry, SUM(total_laid_off)
      FROM world_layoffs.layoffs_staging2
      GROUP BY industry
      ORDER BY 2 DESC;

Summarizes layoffs per industry, revealing the most impacted sectors.

**8) Geographic Layoff Distribution**

      SELECT country, SUM(total_laid_off)
      FROM world_layoffs.layoffs_staging2
      GROUP BY country
      ORDER BY 2 DESC;

Breaks down layoffs by country, showing regional impacts.

**9) Daily Layoff Tracking**

      SELECT `date`, SUM(total_laid_off)
      FROM world_layoffs.layoffs_staging2
      GROUP BY `date`
      ORDER BY 1 DESC;

Tracks layoffs by date to observe daily trends.

**10) Annual Layoff Summary**

      SELECT YEAR(`date`), SUM(total_laid_off)
      FROM world_layoffs.layoffs_staging2
      GROUP BY YEAR(`date`)
      ORDER BY 1 DESC;

Provides a yearly summary of layoffs for broader economic analysis.

**11) Layoffs by Growth Stage**

      SELECT stage, SUM(total_laid_off)
      FROM world_layoffs.layoffs_staging2
      GROUP BY stage
      ORDER BY 2 DESC;

Analyzes layoffs by company growth stage, such as Startup or Public.

**12) Monthly Layoff Analysis**

      SELECT SUBSTRING(date,1,7) as `MONTH`, SUM(total_laid_off) 
      FROM layoffs_staging2
      WHERE SUBSTRING(date,1,7) IS NOT NULL
      GROUP BY `MONTH`
      ORDER BY 1 ASC;

Examines layoffs month by month to identify seasonal trends.

**13) Cumulative Monthly Layoffs**

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

Displays cumulative layoffs by month for trend analysis.

**14) Top 5 Companies by Yearly Layoffs**

      WITH Company_Year (company, years, total_laid_off) AS
      (
        SELECT company, YEAR(`date`), SUM(total_laid_off)
        FROM world_layoffs.layoffs_staging2
        GROUP BY company, YEAR(`date`)
      ), 
      Company_Year_Rank AS
      (
        SELECT *,
        DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
        FROM Company_Year
        WHERE years IS NOT NULL
      )
      SELECT * 
      FROM Company_Year_Rank
      WHERE Ranking <= 5;

Uses CTEs to identify the top five companies with the most layoffs each year.

**Findings and Insights**

Through this analysis, the project reveals how layoffs vary across industries, countries, and companies. By understanding these patterns, we gain insights into the economic pressures faced by specific sectors and regions, allowing us to draw broader conclusions on workforce reduction trends over time. This dataset serves as a lens into the organizational and economic challenges leading to these layoffs, providing valuable context for market and employment trend analysis.















