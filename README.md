# 📊 Car Dealership Database System

This project provides the SQL scripts necessary for the complete creation and setup of a **car dealership-oriented database system**. It includes schema definitions, initial data inserts, and SQL queries for practice and testing.

---

## 📁 Contents

- `concessionaire_full_setup_sqlServer.sql`: Full setup script encompassing table creation, relationships, and sample data inserts for demonstration purposes.
- `concessionaire_queries_sqlServer.sql`: SQL queries designed for testing and interacting with the car dealership database.

---

## 🛠️ Technologies Used

- Standard SQL
- SQL Server
- SQL Server Management Studio (SSMS)

---

## 🚀 How to Use

1. Open SQL Server Management Studio or your preferred SQL Server client.
2. Execute the `concessionaire_full_setup_sqlServer.sql` file to create the schema and load sample data.
3. Run the `concessionaire_queries_sqlServer.sql` file to test queries and explore the system's functionalities.

---

## 🧠 Key Features

- Relational design with foreign key constraints ensuring referential integrity.
- Realistic test data simulating actual car dealership operations.
- Includes queries to analyze customer behavior, vehicle sales, and maintenance records.
- Features the `ManageCustomerTransaction` stored procedure, which:
  - Manages vehicle sales transactions by validating customer and vehicle data.
  - Updates inventory status upon sales.
  - Schedules maintenance appointments for sold vehicles.
  - Updates salesperson statistics.
  - Logs actions for auditing purposes.
  - Ensures data integrity and applies essential validations, including:
    - Verifying the existence of customers, vehicles, and salespersons.
    - Preventing sales of unavailable vehicles.
    - Handling errors to maintain database consistency.

---

## 🧑‍💻 Author

**Virlis Moreira**  
[Upwork Profile](https://www.upwork.com/freelancers/~01b97b4c669aea29e3?mp_source=share)  
[LinkedIn](http://www.linkedin.com/in/virlis-moreira-vivas)

---

## 📄 License

This project is available under the MIT License.
