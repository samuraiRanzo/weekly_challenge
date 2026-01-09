# 🐳 Professional Docker: Optimization & Security
> **Purpose:** Refining container orchestration for production-grade performance and secure deployment.

---

## 🏗️ 1. Multi-Stage Builds
Your current "Clean Slate" uses simple Dockerfiles for development. For production, transition to multi-stage builds to minimize image size.

* **Frontend Pattern:** Use a `node` stage to build the Vue assets, then copy only the `/dist` folder into a lightweight `nginx:alpine` stage. This reduces image size from ~500MB to ~20MB.
* **Backend Pattern:** Use a build stage to install compilers and dependencies, then copy the installed Python packages into a clean `python:slim` runtime stage.
* **Benefit:** Smaller images lead to faster deployments, reduced storage costs, and a significantly smaller attack surface.

## ⚡ 2. Layer Caching & Image Optimization
Docker builds images in layers. Optimize your Dockerfiles to leverage the build cache effectively.

* **Order Matters:** Copy dependency files (`package.json` or `requirements.txt`) and run install commands *before* copying the rest of your source code. This prevents re-installing dependencies every time you change a single line of code.
* **Specific Base Images:** Always use specific tags (e.g., `python:3.13-slim` or `node:20-alpine`) rather than `latest` to ensure build reproducibility across different environments.
* **Minimize Layers:** Combine related commands using `&&` (e.g., `apt-get update && apt-get install -y ... && rm -rf /var/lib/apt/lists/*`) to keep the layer count low.

## 🛡️ 3. Container Security Best Practices
Containers are not secure by default. Implement these "Hardening" steps:

* **Non-Root User:** Never run your application as `root`. Create a dedicated user inside the Dockerfile (e.g., `RUN useradd -m appuser && USER appuser`) to mitigate potential container breakout exploits.
* **Read-Only Filesystems:** Where possible, run containers with a read-only root filesystem using the `read_only: true` flag in Docker Compose to prevent unauthorized file modifications.
* **No Secrets in Images:** Never use `ENV` to store sensitive keys (like your Django `SECRET_KEY`). Use `.env` files (excluded from Git) or Docker Secrets.

## ⚙️ 4. Advanced Compose Workflows
Move beyond basic service starting to professional orchestration.

* **Healthchecks:** Define `healthcheck` in your `docker-compose.yml` so the frontend service only starts once the backend API is actually ready to receive traffic, not just when the container starts.
* **Profiles:** Use `profiles` to separate services. For example, assign `profile: debug` to a `pgadmin` or `redis-insight` container so they only run when explicitly called.
* **Resource Limits:** Define `deploy.resources.limits` (CPU and Memory) to prevent a single leaking container from crashing your entire development machine or server.

## 🧹 5. The .dockerignore Discipline
Just like `.gitignore`, a robust `.dockerignore` is mandatory for professional builds.

* **Exclude Everything:** Exclude `node_modules`, `.venv`, `__pycache__`, `.git`, and local log files.
* **Impact:** This prevents local junk from bloating the build context, significantly speeding up the "Sending build context to Docker daemon" phase.

---

## 💡 Sprint Refactor Tip
> "If your production image contains a compiler (like `gcc`), you haven't finished your multi-stage build. Runtime images should only contain the bare essentials required to execute the code."