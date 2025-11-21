# WorkTracker

## Description
A cross-platform application (Mobile + Web) for tracking working hours. It allows users to select a date on a calendar and record the amount of time worked. Data synchronizes across all user devices in real-time.

## Purpose
I have to manually count my hours every time I work part-time, and a couple of times, when my schedule wasn't as closely monitored, I almost exceeded 28 hours due to the variable counting system. I want to quickly set shifts and check if the hours are correct, and immediately see the count:
- How many hours a week do I work
- How much is my weekly salary
- Salary per month
### Goal
To monitor shifts and be calm about violations.
### Relevant
Currently relevant due to December and the December shifts, busy days, so problems with exceedition may arise.
### This project demonstrates:
### Well-suited for positions in:


## Tech Stack
- Frontend: Flutter (Dart)
- Backend: Firebase (Firestore, Auth, Hosting)
- Architecture: Layered Architecture (MVCS - Model View Controller Service)

## Functional Requirements (MVP)
1.  **Authentication:** Login via Email/Password.
2.  **Calendar:** Monthly calendar view.
3.  **Tracking:** Input work hours (number, supports decimals) for a selected date.
4.  **Synchronization:** Data entered on mobile appears instantly on the web version.
5.  **Indicators:** Days with recorded entries are visually marked on the calendar.

## Features
 -[] 
 -[]
 -[] 
 -[] 
 -[] 
 -[] 

## Database Structure (Cloud Firestore)

The database is NoSQL. Data is stored in collections and documents.

**Collection:** `users`
  └── **Document:** `user_uid` (Unique ID from Firebase Auth)
      └── **Collection:** `work_logs`
          └── **Document:** `YYYY-MM-DD` (e.g., "2023-11-20")
              ├── `hours`: number (e.g., 8.5)
              ├── `updated_at`: timestamp (Last modification time)
              └── `comment`: string (Optional: work description)

## Installation and Setup

1.  **Install dependencies:**
    ```bash
    flutter pub get
    ```

2.  **Run Web version:**
    ```bash
    flutter run -d chrome
    ```

3.  **Run Mobile version (Emulator/Device):**
    ```bash
    flutter run
    ```

##  Demo
(scr)
