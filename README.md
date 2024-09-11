
# Supply Chain Data Analysis Project

## Project Overview

This project involves a comprehensive analysis of the `supply_chain` dataset to derive insights into the operations of a company's supply chain. The dataset contains detailed information on SKUs, product types, prices, transportation modes, lead times, stock levels, supplier details, and much more. Through SQL queries, this project aims to provide actionable insights that can optimize supply chain performance, reduce costs, improve product quality, and enhance overall efficiency.

Supply chain management plays a crucial role in the success of any business, and this analysis seeks to uncover patterns and trends that can drive data-driven decision-making. By identifying inefficiencies and leveraging key insights, companies can streamline their logistics, refine supplier relations, and ultimately increase profitability.

---

## Key Insights and Benefits

### 1. **Data Integrity and Completeness**
- **Query**: `SELECT * FROM supply_chain;`
- **Missing Data Detection**: This ensures that no critical data is missing, allowing for complete and accurate analysis.
  ```sql
  SELECT SKU FROM supply_chain WHERE ... (various fields are NULL);
  ```

**Benefit**: Ensures the data is clean and reliable, which is essential for making informed decisions based on accurate information. Early detection of incomplete data helps avoid future issues.

---

### 2. **SKU Counts and Popularity**
- **Query**: `SELECT SKU, COUNT(*) as SKU_COUNT FROM supply_chain GROUP BY SKU;`
  
**Benefit**: Knowing how many products are associated with each SKU helps manage inventory effectively. This ensures that popular SKUs are well-stocked and that supply aligns with demand, reducing stockouts or overstocking.

---

### 3. **Product Categorization**
- **Query**: `SELECT SKU FROM supply_chain WHERE Product_type NOT IN ('haircare', 'skincare', 'cosmetics');`
  
**Benefit**: Identifying products that fall outside common categories helps businesses focus on niche markets or optimize strategies for specialized products, ensuring a competitive edge in diverse product offerings.

---

### 4. **Supplier Analysis**
- **Query**: `SELECT Product_type, Supplier_name, COUNT(*) AS Supplier_ProductType FROM supply_chain GROUP BY Product_type, Supplier_name;`

**Benefit**: Understanding the relationship between suppliers and the product types they provide helps businesses identify key suppliers and maintain strong relationships. It also helps in negotiating better terms based on supplier contribution.

---

### 5. **Logistics and Transportation**
- **Query**: `SELECT Product_type, Transportation_modes, COUNT(*) AS TransportationType_ProductType FROM supply_chain GROUP BY Product_type, Transportation_modes;`

**Benefit**: Optimizing transportation modes reduces costs and delivery times, improving overall logistics efficiency. This also provides insights into the environmental impact of the logistics operations.

---

### 6. **Financial Performance**
- **Total Revenue and Costs**: Understanding the financial impact of each product type is critical for profitability.
  ```sql
  WITH REV AS ( ... SELECT Product_type, SUM(Revenue_generated) ... )
  SELECT Product_type, Revenue_EACH_TYPE FROM REV;
  ```

**Benefit**: Insights into revenue, costs, and profitability across product types enable companies to focus on high-margin products while improving or eliminating low-margin ones. This ensures better financial health and growth potential.

---

### 7. **Defect Rate and Quality Control**
- **Query**: `SELECT Product_type, Inspection_results, ROUND(AVG(Defect_rates),2) AS AVG_DEFECT_PRODUCTTYPE FROM supply_chain GROUP BY Product_type, Inspection_results;`

**Benefit**: Monitoring defect rates helps in improving product quality and reducing returns. Businesses can identify underperforming suppliers or products and take corrective actions to enhance customer satisfaction and reduce warranty costs.

---

### 8. **Lead Times and Production Volumes**
- **Query**: `SELECT Supplier_name, AVG(Production_volumes) AS AVERAGE_PRODUCTION FROM supply_chain;`

**Benefit**: Analyzing lead times and production volumes helps businesses optimize their production schedules, reduce bottlenecks, and ensure timely product delivery, which ultimately enhances customer satisfaction and minimizes delays.

---

### 9. **Customer Demographics and Sales**
- **Query**: `SELECT Product_type, Customer_demographics, COUNT(*) AS Gender_Purchase FROM supply_chain GROUP BY Product_type, Customer_demographics;`

**Benefit**: Understanding customer preferences based on demographics helps tailor marketing strategies and product offerings, leading to more effective targeting and increased sales.

---

## Financial Analysis

A comprehensive financial analysis includes creating a table that aggregates **total costs**, **manufacturing costs**, **revenue**, and **profits** for each product type.

### Financial Metrics Calculation
```sql
CREATE TABLE FINANCIALS (
    Product_Type VARCHAR(255),
    COSTS DECIMAL(10,2),
    Manufacturing_Costs DECIMAL(10,2),
    Revenue DECIMAL(10,2),
    Profits DECIMAL(10,2)
);
```
This table helps track the profitability of each product type, allowing businesses to focus on products that drive profits while revisiting strategies for those that do not.

**Benefit**: Financial analysis allows businesses to ensure that they are maximizing profits and strategically managing costs, leading to sustainable growth.

---

## Conclusion

The supply chain analysis project uncovers valuable insights that can significantly enhance the efficiency of supply chain operations. From inventory management and supplier relations to transportation logistics and financial analysis, this project helps businesses streamline operations and improve profitability. The data-driven insights also enable better decision-making in areas like product quality, defect rates, and customer satisfaction.

By leveraging this analysis, businesses can reduce costs, increase efficiency, and ensure they are well-positioned to meet the demands of a dynamic market environment.

---

## How to Use

1. **Requirements**: Ensure MySQL is installed and the `supply_chain` table is available in the database.
2. **Execution**: Run the SQL queries provided to retrieve insights, clean the data, and perform analysis.
3. **Results**: Use the insights generated to optimize supply chain operations, improve product quality, and enhance financial performance.

---

### Author
- **Youssef Alchall**
