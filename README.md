# 🚀 2026 Polyglot Engineering Journey
> **Mastering the Stack, Expanding the Horizon, and Building the Future.**

![Yearly Progress](https://img.shields.io/badge/Progress-Jan_Base_Camp-blueviolet?style=for-the-badge)
![Season](https://img.shields.io/badge/Current_Season-🏕️_Base_Camp-orange?style=for-the-badge)

---

## 🗺️ The Four Seasons Roadmap

### 🏕️ Phase 0: The Base Camp (January)
**Focus:** Infrastructure, boilerplates, and knowledge centralization.
* **Objective:** Build the "Clean Slate" starter kit and automation scripts.
* **Status:** ✅ Core Infrastructure Complete / Optimization in progress.

### 🌸 Season 1: The Mastery Sprint (Feb – April)
**Focus:** Deepening expertise in `Vue.js`, `Django`, and `PostgreSQL`.
* **Objective:** Build complex features including WebSockets, Async Tasks, and Advanced SQL.
* **Stack:** Python (Django 5.0+), JavaScript (Vue 3), Tailwind CSS, PostgreSQL 16.

### ☀️ Season 2: The Language Expansion (May – July)
**Focus:** One new language per month (The "New Horizon" Phase).
* **Month 1:** 🦀 **Rust** (High-performance systems).
* **Month 2:** 🐹 **Go** (Scalable cloud microservices).
* **Month 3:** 🔷 **TypeScript** (Enterprise-grade safety).

### 🍂 Season 3: The Integration Phase (Aug – Oct)
**Focus:** Weekly challenges using the newly acquired Season 2 languages.
* **Objective:** Build focused microservices to test implementation speed.

### ❄️ Season 4: The All-Out Challenge (Nov – Jan)
**Focus:** The "God Stack" Integration.
* **Objective:** One massive project combining all learned technologies into a single ecosystem.

---

## 🏛️ The "Clean Slate" Architecture
Every challenge begins with a production-ready baseline located in `/Base Camp/templates/`:
* **Backend:** Django 5.0+ powered by REST Framework. Features include a `CustomUser` model, JWT Authentication with rotation, and automated OpenAPI/Swagger documentation.
* **Frontend:** Vue 3 (Composition API) with Vite. State management is handled by Pinia, with styling via Tailwind CSS.
* **Infrastructure:** Fully orchestrated via Docker Compose, utilizing PostgreSQL 16-alpine.

---

## 🛠️ Core Automation
This repository uses custom scripts to maintain high velocity and architectural consistency:
* **Challenge Initializer:** A cross-platform tool (`init-challenge.sh` / `.bat`) that automates directory creation, boilerplate injection, and frontend branding.
* **Engineering Standards:** All projects are refactored against the [Pro-Level Django + Postgres Checklist](./Base%20Camp/knowledge-base/django-postgres-checklist.md) every Thursday to ensure production-grade code before the "Friday Launch".

---

## 📊 Season 1: Mastery Tracker (Vue/Django)

| Week | Project | Key Learning | Status |
| :--- | :--- | :--- | :--- |
| **05** | **Smart Task Orchestrator** | Celery & Background Workers | 📅 Feb 01 |
| **06** | **Real-Time Data Dashboard** | Django Channels & WebSockets | 🕒 Upcoming |
| **07** | **AI Content Manager** | OpenAI Integration & RAG | 🕒 Upcoming |
| **08** | **Full-Stack PWA** | Offline Sync & Service Workers | 🕒 Upcoming |

---

## 🚀 Quick Start
To initialize a new weekly challenge using the Base Camp automation:
1.  **Navigate to Base Camp:** `cd "Base Camp"`
2.  **Run the Initialization Script:**
    ```bash
    ./init-challenge.sh S1-Mastery Week-05 task-tracker
    ```
3.  **Launch the Stack:**
    ```bash
    cd ../S1-Mastery/Week-05-task-tracker
    docker-compose up --build
    ```

---

## 📂 Repository Structure
```text
/2026-Engineering-Log
 ┣ 📂 Base Camp/          <-- Current Phase: Boilerplates & Knowledge
 ┃ ┣ 📂 research/         <-- Tech stack audits & comparisons
 ┃ ┣ 📂 templates/        <-- Clean Slate (Django/Vue) Starter Kit
 ┃ ┗ 📂 knowledge-base/   <-- Curated engineering mental models
 ┣ 📂 S1-Mastery/         <-- Feb - April (Vue/Django)
 ┣ 📂 S2-Expansion/       <-- May - July (New Languages)
 ┣ 📂 S3-Sprints/         <-- Aug - Oct (Weekly Integration)
 ┗ 📂 S4-Final-Boss/      <-- Nov - Jan (All-Out Project)