School Directory Buddy

A school management web application built with Vite, React, TypeScript, Supabase, Tailwind CSS, and Shadcn UI.
This project demonstrates handling authentication and security with Email OTP login and protecting sensitive operations such as adding or editing schools.

🚀 Features

Publicly view all schools (no login required).

Email OTP authentication (6-digit code, expires in 10 minutes).

Sign Up / Sign In toggle for new and existing users.

Only authenticated users can add, edit, or manage schools.

Secure route protection using Supabase sessions.

Modern UI built with TailwindCSS and Shadcn UI.

🛠️ Tech Stack

React + Vite
 — Frontend framework

TypeScript
 — Type safety

Supabase
 — Database & Authentication (Email OTP)

TailwindCSS
 — Styling

Shadcn UI
 — UI components

📦 Getting Started
1. Clone the Repository
git clone https://github.com/prajesh-s/School-Directory-Buddy1.git
cd School-Directory-Buddy1

2. Install Dependencies
npm install

3. Run the Project Locally
npm run dev


The app will be available at:
👉 http://localhost:5173

🔐 Authentication Flow

Sign Up with your email → receive a 6-digit OTP.

Enter the OTP within 10 minutes to activate your session.

Sign In works the same way for existing users.

Only logged-in users can access “Add/Edit School” pages.

🌍 Deployment

The project is deployed on Vercel:
👉 Live Demo link:https://school-directory-buddy1.vercel.app/

📖 Assignment Notes

This project is the Step 2 submission for the Web Developer Assignment.
It extends the original School Management App by adding:

Email OTP authentication

Route protection for school management

Clean, user-friendly authentication flow

👨‍💻 Author

Prajesh S
GitHub Profile
