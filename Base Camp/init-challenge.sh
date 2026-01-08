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

TARGET_DIR="./$SEASON/$WEEK-$PROJECT_NAME"

# --- Interactive Input ---
echo "📝 What is the primary goal for $WEEK?"
read -p "> " WEEKLY_GOAL

# --- Execution ---
echo "🚀 Initializing: $WEEK | $PROJECT_NAME..."

# 1. Create Season/Week directory
if [ -d "$TARGET_DIR" ]; then
    echo "⚠️  Warning: $TARGET_DIR already exists. Skipping creation."
else
    mkdir -p "$TARGET_DIR"
    echo "📁 Created folder: $TARGET_DIR"
fi

# 2. Copy the Clean Slate Boilerplate (excluding junk)
# This assumes you have already stripped the Blog logic from TEMPLATE_DIR
echo "📦 Injecting Clean Slate Boilerplate (Auth Only)..."
rsync -av --quiet "$TEMPLATE_DIR/" "$TARGET_DIR" \
    --exclude .git \
    --exclude node_modules \
    --exclude .venv \
    --exclude __pycache__ \
    --exclude db.sqlite3 \
    --exclude "*.pyc"

# 3. Setup Environment Files
if [ -f "$TARGET_DIR/.env.example" ]; then
    cp "$TARGET_DIR/.env.example" "$TARGET_DIR/.env"
    echo "✅ Created .env from .env.example"
fi

# 4. Generate the Weekly README with Knowledge Base Links
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
- **Security:** JWT (SimpleJWT)

## 📅 Refactor Schedule
- **Monday-Wednesday:** Feature implementation.
- **Thursday:** Use the [Optimization Checklist]($KB_CHECKLIST).
- **Friday:** Launch and Demo.

## 🚦 Getting Started
1. \`cd $SEASON/$WEEK-$PROJECT_NAME\`
2. \`docker-compose up --build\`
3. **Backend:** http://localhost:8000 | **Docs:** http://localhost:8000/api/docs/
4. **Frontend:** http://localhost:5173
EOT

# 5. Success Message
echo "--------------------------------------------------------"
echo "✨ Setup Complete!"
echo "📍 Location: $TARGET_DIR"
echo "💻 Next Steps:"
echo "   1. cd \"$TARGET_DIR\""
echo "   2. docker-compose up"
echo "   3. Start coding in $TARGET_DIR/backend/core/models.py"
echo "--------------------------------------------------------"
