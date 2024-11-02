**CMS-Integrated-Healthcare-Insurance-Analysis**

 The Centers for Medicare & Medicaid Services (CMS) has access to a vast amount of
 information about healthcare insurance plans, including information on plan pricing,
 features, provider networks, and other factors. CMS must thoroughly investigate and
 examine this data in order to make wise selections and raise the caliber of healthcare
 insurance services. The issue is figuring out how to get the most useful information out
 of the data that has been provided so that you can use it to guide policy choices,
 optimize plan options, and improve the healthcare insurance system as a whole.
 
 **Business Context:**
 The business goal for CMS is to leverage data analytics and exploration to improve the
 efficiency and effectiveness of healthcare insurance plans. This involves understanding
 the relationships and variations in plan rates, benefits, age groups, and provider
 networks across states. 
 The key components of the business definition include:
 
 **1. State-wise Variation:** Understand how healthcare plan rates and benefits vary
 across different states. Identify states with the highest and lowest plan rates, as
 well as variations in coverage benefits.

 **2. Age Group Analysis:** Explore how plan rates vary by age groups. Identify any
 trends or patterns that can help tailor insurance plans to different age
 demographics.

 **3. Cross-Year Analysis:** Utilize the Crosswalk2023.csv file to join data across
 multiple years (e.g., 2022 and 2023) and identify trends or changes in the
 healthcare insurance landscape over time.

**Data Warehouse & ETL Integration:**
To effectively analyze this complex healthcare data, we will implement a robust data warehouse using a snowflake schema design that enables sophisticated OLAP operations. The data warehouse will support roll-up operations for analyzing data at different aggregation levels (e.g., from individual plan rates to state-level summaries) and drill-down capabilities to examine detailed information (e.g., from regional trends to specific plan characteristics). Talend, as our ETL tool, will handle the extraction of data from various CMS sources, transform it according to business rules (such as age group categorization and rate calculations), and load it into our dimensional model. This integration enables complex analytical queries like "Average premium rates by state and age group over time" or "Provider network size correlation with plan rates across metal levels." The ETL pipeline in Talend will run on a scheduled basis to ensure data freshness, with specific jobs handling incremental loads for rate updates and full loads for reference data, maintaining data quality through built-in validation and error handling mechanisms.




## EER Diagram for Our Structured Database
![EER Diagram for our structured Database](https://github.com/NakulShiledar33/CMS-Integrated-Healthcare-Insurance-Analysis/blob/main/Datasets/relational_model.png)





## Fact Table and Dimensions for CMS Data Warehouse
![Fact Table and Dimensions for CMS Data Warehouse](https://github.com/NakulShiledar33/CMS-Integrated-Healthcare-Insurance-Analysis/blob/main/Datasets/Snowflake_schema.jpeg)





## Tableau Dashboard for Generating Insights from Our CMS Data Warehouse
![Tableau Dashboard for generating insights from our CMS Data Warehouse](https://github.com/NakulShiledar33/CMS-Integrated-Healthcare-Insurance-Analysis/blob/main/Datasets/image.png)


