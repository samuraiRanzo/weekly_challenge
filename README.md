# 🚀 Polyglot Engineer Roadmap (2026)

> **Status:** Base Camp Completed. Infrastructure Live. 🛠️

This repository is my professional engineering workspace. It is built around a **"Project Factory"** philosophy—using a modular, Docker-first architecture to rapidly scaffold, build, and deploy full-stack applications.



---

## 🏗️ Architectural Philosophy: The "Lego" Approach
Instead of building monolithic apps, I use a decoupled system where the "Engine" (Backend) and the "Shell" (Frontend) are interchangeable parts.

### 🧩 The Core Components:
* **The Engine (Backend):** A shared Django REST Framework template with PostgreSQL, JWT Auth, and Swagger/OpenAPI documentation.
* **The Shells (Frontends):**
    * **Minimalist:** Focused on raw logic and speed.
    * **Dashboard:** Tailored for data-rich administrative systems.
    * **Terminal:** A retro-CLI aesthetic for system-level and security challenges.
* **The Bridge:** A centralized Axios `apiClient` with intelligent interceptors for dual-token management (User & Admin).

---

## 🛠️ Tech Stack & Standards
| Layer | Technology | Engineering Standard |
| :--- | :--- | :--- |
| **Frontend** | Vue 3 + Vite | Pinia state management, individual key token persistence. |
| **Backend** | Django 5.x | Custom User models, DRF Serializers, SimpleJWT. |
| **Database** | PostgreSQL | Relational integrity and Dockerized persistence. |
| **Networking** | Vite Proxy | Zero-CORS development and `ALLOWED_HOSTS` isolation. |
| **DevOps** | Docker | Automated scaffolding with `init-challenge.sh`. |

---

## 🚀 Execution Guide

### 1. Initialize a Challenge
Use the automation script to spawn a new environment:
```bash
# Usage: ./init-challenge.sh [Season] [Week] [Name]
./init-challenge.sh S1 Week-01 my-task-app
```

### 2. Boot the Infrastructure
cd to the created folder:
```bash
    docker compose up --build
```
### 3. Access Points
* **Frontend UI**: `http://localhost:5173`
* **API Root**: `http://localhost:8000/api/`
* **Intractive Docs**: `http://localhost:8000/api/docs/`


