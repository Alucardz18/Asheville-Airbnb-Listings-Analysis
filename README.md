# 🏡 Asheville Airbnb Listings Analysis
**Tools Used:** SQL · Excel · Python (for cleaning)

---

## 📘 Introduction
This project analyzes **Airbnb listings in Asheville, North Carolina**, to uncover patterns in **pricing**, **host activity**, and **guest demand**.  
Using SQL, Excel, and Python, this analysis connects listing data with review activity to understand what drives Airbnb performance across neighborhoods.

The dataset comes from **Analyst Builder**, with analysis performed using **MySQL**, **Excel PivotTables**, and **Python (pandas, numpy)** for data cleaning and preparation.

---

## 📈 Key Insights Summary

| Metric | Value | Insight |
|--------|--------|----------|
| **Average Nightly Price** | **$169.00** | Median price is $128.00, showing right-skewed premium listings. |
| **Most Expensive Neighborhood** | **28732 ($213.95 avg)** | Likely luxury listings with fewer total properties. |
| **Cheapest Neighborhood** | **28806 ($164.14 avg)** | Most competitive ZIP code with 640+ listings. |
| **Dominant Room Type** | **Entire home/apartment (90.6%)** | Reflects Asheville’s tourism preference for private stays. |
| **Top Host Portfolio** | **104 listings (Host ID 167186184)** | Indicates market concentration by a few large hosts. |
| **Peak Guest Activity** | **July (Summer)** | Highest review activity; dips in winter months. |
| **Top ZIPs for Demand** | **28806, 28801, 28803** | These areas attract the most guests and reviews. |

---

## 🎯 Objectives
The main goals of this analysis are:

1. To explore the distribution and characteristics of Airbnb listings across Asheville.  
2. To examine **pricing trends** by neighborhood and minimum stay requirements.  
3. To analyze **host behavior** and market concentration.  
4. To uncover **guest demand patterns** using review data.  
5. To provide **recommendations** for hosts, investors, and tourism marketers.

---

## 🧰 Tools and Libraries Used

### 🧮 SQL (MySQL Workbench)
Used for querying, aggregating, and transforming datasets.  
Key techniques: **CTEs**, **window functions**, **joins**, and **ranking**.

### 📊 Excel
Used for data exploration, **PivotTables**, and building the **interactive dashboard** summarizing pricing, host activity, and reviews.

### 🐍 Python
Used primarily for data cleaning (`CleaningCharacters.py`):  
- **pandas** – data wrangling  
- **numpy** – numerical operations  
- **matplotlib / seaborn** – exploratory visuals (optional)  

---

## 🧹 Data Cleaning
**Performed in Python and SQL**

Steps:
- Removed irrelevant columns and standardized names.  
- Checked for duplicates — none found.  
- Filled missing `price` values with **median** to reduce skew from luxury listings.  
- Winsorized extreme outliers in `price` and `minimum_nights`.  
- Converted date columns to `datetime` format.  
- Merged `listings.csv` and `reviews.csv` to link listing details with review data.  
- Filtered reviews between **2021–2025** to focus on recent activity.
---

## ⚠️ Problems Faced and Solutions

### Problem:
During import, the original `listings.csv` file **could not be loaded into MySQL Workbench** due to **special or invalid UTF-8 characters** within text fields (e.g., description, name).

### Diagnosis:
MySQL threw an encoding error (“incorrect string value”) when reading the file, preventing full table creation.

### Solution:
A **Python-based text cleaning script** (`CleaningCharacters.py`) was used to identify and remove these invalid characters.  
Using `pandas`, the file was re-encoded in UTF-8 and saved as a clean version (`Listing-Analysis-Clean1.csv` → `Listing-Analysis-Clean2.csv`), which successfully loaded into MySQL.

### Outcome:
- The cleaned dataset imported **without errors**.  
- All text fields remained intact and analysis-ready.  
- This ensured full compatibility between **Python preprocessing** and **SQL querying** workflows.
---

## 🧾 SQL Analysis Overview

| Category | SQL Query | Insight |
|-----------|------------|----------|
| **Pricing** | `Average Price by Neighborhood.sql` | Average nightly price ranges from **$164–$214**; ZIP `28732` is highest. |
|  | `Does minimum_nights affect average price.sql` | Shorter stays (1–2 nights) have higher average prices. |
|  | `Average & Median Nightly Price.sql` | Mean ($169) > Median ($128), confirming right-skewed pricing. |
| **Supply** | `Active Listings per Neighborhood.sql` | ZIP `28806` has **640 active listings**, the highest in Asheville. |
|  | `Distribution of Room Types.sql` | **Entire home/apartment = 90.6%**, **Private room = 8.9%**, others <1%. |
| **Hosts** | `Top Hosts by Listing Count.sql` | Most hosts manage <3 listings; one host owns 100+ properties. |
|  | `Host Scale vs Price.sql` | Multi-listing hosts tend to keep consistent mid-tier pricing. |
| **Demand** | `Total Number of Reviews per Listing.sql` | Most active listing received **903 total reviews**. |
|  | `Average Reviews per Month.sql` | Reviews increased steadily from 2020–2023, dipped slightly in 2024. |
|  | `Neighborhood Total Reviews.sql` | ZIPs `28806`, `28801`, and `28804` show strongest guest demand. |

---

## 📊 Key Findings

### 🏠 Market Composition
- **Entire homes/apartments** dominate (90.6%), followed by **Private rooms (8.9%)**.  
- Neighborhoods **28806, 28801, and 28804** lead in both listings and guest reviews.

### 💰 Pricing Trends
- **Average price:** $169 | **Median:** $128 → right-skewed distribution.  
- **Short stays (1–2 nights)** are priced highest ($171).  
- **Long-term stays (31+ nights)** average around $109.  
- **ZIP 28732** has the **highest average price ($213.95)**; **28806** is most competitive.

### 👥 Host Behavior
- **Majority:** small hosts (1–3 listings).  
- **Outlier host:** manages **104+ listings** → market concentration.  
- Larger hosts tend to price competitively within the mid-range.

### 💬 Demand & Reviews
- Demand **peaked in 2023**, with steady growth since 2020.  
- **Seasonality:** review activity spikes in **summer (July)** and drops in **winter (Nov–Jan)**.  
- **Sundays** account for **~33.8% of reviews**, likely due to weekend checkouts.  
- ZIPs **28806, 28801, and 28803** generate the highest engagement.

---

## 💬 Conclusion and Insights

The Asheville Airbnb market is **active, competitive, and seasonally influenced**.  
Most properties are **entire homes**, suggesting that travelers prefer private stays, while **a few large hosts dominate supply**.

**Key takeaways:**
- **28806** offers opportunity for budget-conscious travelers and competitive hosts.  
- **28732** and **28801** cater to higher-end travelers seeking premium experiences.  
- **Short stays** yield higher nightly rates — hosts can optimize by allowing flexible minimum nights.  
- **Demand patterns** mirror Asheville’s tourism calendar: strong summers, slow winters.

**Strategic Recommendation:**  
Hosts and investors should focus on **neighborhoods 28806, 28801, and 28803**, maintain **1–4 night minimum stays**, and use **midweek-to-weekend marketing campaigns** to capitalize on booking surges.

---

## 🔍 Opportunities for Further Analysis
Future extensions could include:
- 🧠 **Predictive modeling** for price or occupancy based on location and host metrics.  
- 🌎 **Geospatial analysis** to visualize price clusters by ZIP or neighborhood.  
- 💬 **Sentiment analysis** on review text for guest satisfaction insights.  
- ⭐ **Host performance** evaluation (e.g., Superhost status, response time).  

---

## 🗂️ Project Deliverables

| Category | File | Description |
|-----------|------|-------------|
| **Data** | `/data/raw/` | Original Airbnb datasets (`listings.csv`, `reviews.csv`, `neighbourhoods.csv`). |
|  | `/data/cleaned/Listing-Analysis-Clean2.csv` | Cleaned and merged dataset used for analysis. |
| **SQL** | `/sql/queries/` | All SQL scripts used for pricing, host, and review analyses. |
|  | `/sql/results/` | Query results in CSV format (ready for Excel visualization). |
| **Analysis** | `/analysis/excel/Graphs_and_Pivot_Tables.xlsx` | Interactive Excel dashboard summarizing findings. |
| **Documentation** | `README.md`, `/docs/` | Project overview, summary visuals, and structure. |

---

## 🧾 Credit
Dataset and analytical framework adapted from **Analyst Builder’s Airbnb Market Case Study**.  
All SQL, Excel, and reporting developed by *Nii Oye Kpakpo* (2025).
