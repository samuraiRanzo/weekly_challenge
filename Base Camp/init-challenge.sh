#!/bin/bash

# --- Configuration ---
SEASON=$1
WEEK=$2
PROJECT_NAME=$3
TEMPLATE_DIR="./templates/django-vue-base"
KB_CHECKLIST="../../Base Camp/knowledge-base/django-postgres-checklist.md"

# --- Validation ---
if [ -z "$PROJECT_NAME" ]; then
    echo "❌ Error: Missing arguments."
    echo "Usage: ./init-challenge.sh [Season] [Week] [Project-Name]"
    echo "Example: ./init-challenge.sh S1-Mastery Week-05 task-tracker"
    exit 1
fi

# Ensure we are in the Base Camp folder to avoid pathing errors
if [[ "$PWD" != *"/Base Camp" ]]; then
    echo "❌ Error: Please run this script from inside the 'Base Camp' directory."
    exit 1
fi

TARGET_DIR="../$SEASON/$WEEK-$PROJECT_NAME"

# --- Interactive Goal Setting ---
echo "📝 What is the primary goal for $WEEK?"
read -p "> " WEEKLY_GOAL

# --- Execution ---
echo "🚀 Initializing: $WEEK | $PROJECT_NAME..."

# 1. Create Season/Week directory if it doesn't already exist.
if [ -d "$TARGET_DIR" ]; then
    echo "⚠️  Warning: $TARGET_DIR already exists. Skipping creation."
else
    mkdir -p "$TARGET_DIR"
    echo "📁 Created folder: $TARGET_DIR"
fi

# 2. Copy the Clean Slate Boilerplate using rsync
echo "📦 Injecting Clean Slate Boilerplate..."
rsync -av --quiet "$TEMPLATE_DIR/" "$TARGET_DIR" \
    --exclude .git \
    --exclude node_modules \
    --exclude .venv \
    --exclude __pycache__ \
    --exclude db.sqlite3 \
    --exclude "*.pyc" \
    --exclude .idea

# 2.5 Customize Frontend Brand Name
echo "🎨 Personalizing frontend brand..."
FORMATTED_NAME=$(echo "$PROJECT_NAME" | sed -E 's/-/ /g; s/\b([a-z])/\U\1/g')

APP_VUE_PATH="$TARGET_DIR/frontend/src/App.vue"
INDEX_HTML_PATH="$TARGET_DIR/frontend/index.html"

if [ -f "$APP_VUE_PATH" ]; then
    sed -i "s|Vue 3 + Vite + Django|$FORMATTED_NAME|g" "$APP_VUE_PATH"
fi

if [ -f "$INDEX_HTML_PATH" ]; then
    sed -i "s|<title>Vue 3 + Vite</title>|<title>$FORMATTED_NAME</title>|g" "$INDEX_HTML_PATH"
fi

# 3. Setup Environment Files
if [ -f "$TARGET_DIR/.env.example" ]; then
    cp "$TARGET_DIR/.env.example" "$TARGET_DIR/.env"
    echo "✅ Created .env from .env.example"
fi

# 4. Generate the Weekly README (Updated for Docker Compose V2)
echo "📝 Customizing Weekly README..."
cat <<EOT > "$TARGET_DIR/README.md"
# $WEEK: ${PROJECT_NAME//-/ }
> **Season:** $SEASON
> **Status:** 🟡 In Progress
> **Template:** Clean Slate (Auth-Only)

## 🎯 Weekly Challenge Goal
$WEEKLY_GOAL

## 🛠️ Stack
- **Frontend:** Vue 3 (Vite + Pinia)
- **Backend:** Django REST Framework (Custom User Auth)
- **Database:** PostgreSQL 16
- **Orchestration:** Docker Compose V2

## 📅 Refactor Schedule
- **Monday-Wednesday:** Feature implementation.
- **Thursday:** Use the [Optimization Checklist]($KB_CHECKLIST) to refactor.
- **Friday:** Final testing and Launch.

## 🚦 Getting Started
1. \`cd $SEASON/$WEEK-$PROJECT_NAME\`
2. \`docker compose up --build\`
3. **Backend/API:** http://localhost:8000
4. **Frontend:** http://localhost:5173
EOT

# 5. Success Message (Updated for Docker Compose V2)
echo "--------------------------------------------------------"
echo "✨ Setup Complete!"
echo "📍 Location: $TARGET_DIR"
echo "💻 Next Steps:"
echo "   1. cd \"$TARGET_DIR\""
echo "   2. docker compose up"
echo "   3. Open the API docs to verify your setup!"
echo "--------------------------------------------------------"