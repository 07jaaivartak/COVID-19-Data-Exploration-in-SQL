
# COVID-19 Data Exploration in SQL

This repository contains SQL queries that perform data exploration and analysis on COVID-19 related datasets, specifically focusing on COVID deaths and vaccinations.





## Overview: 

The SQL scripts provided here are designed to explore and analyze two primary datasets:

• CovidDeaths Dataset: Contains information about COVID deaths.

• CovidVaccinations Dataset: Contains information about COVID vaccinations.

## Purpose:

The purpose of these SQL queries is to perform exploratory data analysis (EDA) on the COVID-19 datasets. The scripts perform various analyses, including:

• Basic Data Exploration: Fetching records from the CovidDeaths and CovidVaccinations tables.

• Calculating Total Cases vs Total Deaths: Analyzing the relationship between total cases and total deaths.

• Country-Specific Analysis: Extracting data related to a specific country (e.g., India) for deeper analysis.

• Population vs Vaccinations: Examining the percentage of population vaccinated against COVID-19.

• Summary Statistics by Continent: Aggregating data to understand death counts per population at a continental level.

• Global Numbers: Calculating global statistics such as total cases, total deaths, and death percentages.

• Creating Views: Storing specific query results as views for potential future use in visualizations or further analysis.
    
## Usage:
The SQL scripts can be executed in a SQL environment connected to the CovidDeaths and CovidVaccinations tables in your database.

To execute the scripts:

1. Connect to your SQL environment.
2. Copy the SQL queries from the respective files.
3. Run the queries in sequence to perform the desired data exploration and analysis.
## Views:
The repository includes views created from specific queries:

• PercentPopulationVaccinated: Contains data related to population and vaccinations.

• Death_Percentage: Stores information about death percentages.

• ContinentwiseCovidDeathSummary: Provides summaries of COVID deaths by continent.
