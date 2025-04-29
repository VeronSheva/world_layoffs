# Layoffs EDA Project

## 📊 Overview

This project explores and analyzes data on global layoffs from 2020 to early 2023 using SQL. 
The goal is to uncover trends in workforce reductions across companies,
industries, countries, and funding stages.

Data was cleaned and explored using SQL (MySQL) in phpMyAdmin,
and insights were drawn using aggregation, filtering, ranking, and window functions.

---

## 🧹 Data Cleaning Summary

The dataset was cleaned prior to analysis:
- Handled missing and null values
- Standardized date formats
- Removed duplicates
- Verified data types

---

## 📈 Key Insights from EDA

### 🕓 Dates
- The data spans from **2020 to early 2023**
- Layoffs peaked in **2022**, with **160,661 layoffs**
- In just the **first 3 months of 2023**, layoffs already reached **125,677**

---

### 💼 Companies with the Most Layoffs
- **Amazon**: 18,150
- **Google**: 12,000
- **Meta**: 11,000
- **Salesforce**: 10,090
- **Philips** & **Microsoft**: 10,000

**116 companies** reported 100% layoffs (73 of them in the USA).

---

### 🏭 Top 5 Affected Industries
| Industry        | Total Laid Off |
|----------------|----------------|
| Consumer        | 45,182         |
| Retail          | 43,613         |
| Other           | 36,289         |
| Transportation  | 33,748         |
| Finance         | 28,344         |

---

### 🌍 Layoffs by Country
- **USA**: 256,559
- **India**: 35,993
- **Netherlands**: 17,220
- **Sweden**: 11,264
- **Brazil**: 10,391

---

### 📈 Ratio of Total Layoffs to Total Funds
A higher ratio suggests that companies in that country may have been 
less efficient with funding, potentially overhiring

Top - 5 most efficient countries: 

| Country       | Layoffs to Funds Ratio |
|---------------|------------------------|
| Lithuania     | 0.002                  |
| Netherlands   | 0.025                  |
| Romania       | 0.107                  |
| United Kingdom| 0.143                  |
| Norway        | 0.146                  |`

Top 5 least efficient countries are:

| Country    | Layoffs to Funds Ratio |
|------------|------------------------|
| Russia     | 6.667                  |
| Japan      | 3.269                  |
| Finland    | 1.479                  |
| Kenya      | 1.39                   |
| Denmark    | 1.111                  |`

### 🚀 Layoffs by Company Stage
| Stage        | Total Laid Off |
|--------------|----------------|
| Post-IPO     | 204,132        |
| Unknown      | 40,716         |
| Acquired     | 27,576         |
| Series C     | 20,017         |
| Series D     | 19,225         |

Startups and post-IPO companies were hit hardest, indicating market pressure at all growth stages.

---

### 🏆 Top Companies per Year by Layoffs

**2020**
- Uber, Booking.com, Groupon, Swiggy, Airbnb

**2021**
- Bytedance, Katerra, Zillow, Instacart, WhiteHat Jr

**2022**
- Meta, Amazon, Cisco, Peloton, Carvana, Philips

**2023 (Q1 Only)**
- Google, Microsoft, Ericsson, Amazon, Salesforce, Dell

---

## 🛠️ Tools & Skills Used
- **SQL** (MySQL)
- **Window Functions** (`RANK`, `SUM OVER`)
- **Aggregate Functions**
- **Joins & CTEs**
- **Data Cleaning Techniques**
- **phpMyAdmin**
