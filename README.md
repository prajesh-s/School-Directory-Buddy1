# School Directory Buddy 🏫

A **School Directory Web Application** built using **React + Vite + TypeScript** with **MySQL** as the database.  
This project is created as part of the **Web Development Assignment**.

---

## 📌 Project Overview

The project is designed to manage and display a list of schools.  
It has **two main pages**:

1. **Add School Page (`addSchool.jsx`)**  
   - A form built using **React Hook Form** to add school details.
   - Stores data into a **MySQL** database.
   - Uploads school images into the **`schoolImages/`** folder.
   - Input validation (e.g., email, contact number).
   - Fully **responsive** (desktop + mobile).

2. **Show Schools Page (`showSchools.jsx`)**  
   - Displays the list of schools stored in the database.
   - Each school card shows **Name, Address, City, and Image**.
   - Layout designed like an **e-commerce product listing**.
   - Fully **responsive**.

---

## 🛠️ Technologies Used

- **Frontend:** React + Vite + TypeScript
- **Styling:** Tailwind CSS + shadcn-ui
- **Database:** MySQL
- **Form Handling:** React Hook Form + Zod
- **Hosting:** Vercel (Frontend) + [Any MySQL-compatible Backend Hosting]
- **Version Control:** Git + GitHub

---

## ⚡ Installation & Setup (Local)

Follow these steps to run the project locally:

### **1. Clone the Repository**
```bash
git clone https://github.com/prajesh-s/School-Directory-Buddy1.git
cd School-Directory-Buddy1

