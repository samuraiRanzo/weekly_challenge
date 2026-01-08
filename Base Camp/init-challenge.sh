#!/bin/bash

# --- Configuration ---
# These variables define where the boilerplate lives and where the knowledge base is.
SEASON=$1
WEEK=$2
PROJECT_NAME=$3
TEMPLATE_DIR="./templates/django-vue-base"
KB_CHECKLIST="../../Base Camp/knowledge-base/django-postgres-checklist.md"

# --- Validation ---
# Ensure all required arguments are provided before proceeding.
if [ -z "$PROJECT_NAME" ]; then
    echo "❌ Error: Missing arguments."
    echo "Usage: ./init-challenge.sh [Season] [Week] [Project-Name]"
    echo "Example: ./init-challenge.sh S1-Mastery Week-05 task-tracker"
    exit 1
fi

TARGET_DIR="../$SEASON/$WEEK-$PROJECT_NAME"

# --- Interactive Goal Setting ---
# Prompting for a goal ensures your weekly README is specific to the task at hand.
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

# 2. Copy the Clean Slate Boilerplate
# This copies your Auth-only backend, Vite frontend, and docker-compose setup while excluding local junk.
echo "📦 Injecting Clean Slate Boilerplate (Auth-Only + Docker Compose)..."
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

# Convert kebab-case to Title Case (e.g., task-tracker -> Task Tracker)
FORMATTED_NAME=$(echo "$PROJECT_NAME" | sed -E 's/-/ /g; s/\b([a-z])/\U\1/g')

# Path to App.vue and index.html
APP_VUE_PATH="$TARGET_DIR/frontend/src/App.vue"
INDEX_HTML_PATH="$TARGET_DIR/frontend/index.html"

# Update App.vue navigation brand
if [ -f "$APP_VUE_PATH" ]; then
    sed -i "s|Vue 3 + Vite + Django|$FORMATTED_NAME|g" "$APP_VUE_PATH"
    echo "✅ App.vue brand set to: $FORMATTED_NAME"
fi

# Update index.html browser tab title
if [ -f "$INDEX_HTML_PATH" ]; then
    # This targets the <title> tag specifically
    sed -i "s|<title>Vue 3 + Vite</title>|<title>$FORMATTED_NAME</title>|g" "$INDEX_HTML_PATH"
    echo "✅ index.html title set to: $FORMATTED_NAME"
fi

# 3. Setup Environment Files
# Copies the template .env.example to a live .env file for local use.
if [ -f "$TARGET_DIR/.env.example" ]; then
    cp "$TARGET_DIR/.env.example" "$TARGET_DIR/.env"
    echo "✅ Created .env from .env.example"
fi

# 4. Generate the Weekly README
# This creates a tailored guide including your goal and a link to your optimization checklist.
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
- **Database:** PostgreSQL
- **Orchestration:** Docker Compose

## 📅 Refactor Schedule
- **Monday-Wednesday:** Feature implementation.
- **Thursday:** Use the [Optimization Checklist]($KB_CHECKLIST) to refactor and optimize.
- **Friday:** Final testing and Launch.

## 🚦 Getting Started
1. \`cd $SEASON/$WEEK-$PROJECT_NAME\`
2. \`docker-compose up --build\`
3. **Backend/API:** http://localhost:8000 | **Docs:** http://localhost:8000/api/docs/
4. **Frontend:** http://localhost:5173
EOT

# 5. Success Message
echo "--------------------------------------------------------"
echo "✨ Setup Complete!"
echo "📍 Location: $TARGET_DIR"
echo "💻 Next Steps:"
echo "   1. cd \"$TARGET_DIR\""
echo "   2. docker-compose up"
echo "   3. Open the API docs to verify your Clean Slate setup!"
echo "--------------------------------------------------------"
