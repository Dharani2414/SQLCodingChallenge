# 🚘 SQLCoding – Based Vehicle Leasing System

This project showcases a SQL-based Car Rental System, developed as part of a coding challenge. It includes complete database design, data manipulation, and analytical queries for managing vehicles, customers, leases, and payments.

---

## 🗄️ Database Overview

- **Database Name**: `sqlcoding`
- **Purpose**: To manage and analyze car leasing and payment operations.

---

## 📚 Schema Highlights

- **🚗 Vehicle**: Contains car inventory details – make, model, availability, rate, passenger and engine capacity.
- **👤 Customer**: Stores customer information such as name, email, and phone number.
- **📄 Lease**: Tracks leasing transactions between customers and vehicles, including lease duration and type.
- **💰 Payment**: Logs payment details made toward each lease.

---

## 🔧 Notable Updates

- **Renamed Column**:  
  `Payment.paymentDate` → `transactionDate`

- **Updated Dates**:  
  All lease and payment records were shifted from **2023 to 2025** using `DATEADD(YEAR, 2, ...)` to simulate active lease scenarios and enable current-year filtering.

---

## ⚙️ Stored Procedures

- **`GetAvgDailyRateAvailable`**  
  Computes the average `dailyRate` for vehicles where `available = 1`.

---

## ▶️ How to Run

1. Open **SQL Server Management Studio** or any SQL-compatible environment.
2. Run the script in the following order:
   - Create the database and required tables.
   - Insert sample data.
   - Apply updates (date modifications, column rename).
   - Execute stored procedures and queries to validate outputs.

---

