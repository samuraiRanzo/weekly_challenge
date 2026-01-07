#!/bin/bash

# --- Configuration ---
SEASON=$1
WEEK=$2
PROJECT_NAME=$3
TEMPLATE_DIR="./templates/django-vue-base"

# --- Validation ---
if [ -z "$PROJECT_NAME" ]; then
    echo "❌ Error: Missing arguments."
    echo "Usage: ./init-challenge.sh [Season] [Week] [Project-Name]"
    echo "Example: ./init-challenge.sh S1-Mastery Week-05 task-tracker"
    exit 1
fi

TARGET_DIR="./$SEASON/$WEEK-$PROJECT_NAME"

# --- Execution ---
echo "🚀 Initializing: $WEEK | $PROJECT_NAME..."

# 1. Create Season/Week directory
if [ -d "$TARGET_DIR" ]; then
    echo "⚠️  Warning: $TARGET_DIR already exists. Skipping creation."
else
    mkdir -p "$TARGET_DIR"
    echo "📁 Created folder: $TARGET_DIR"
fi

# 2. Copy the Clean Boilerplate (excluding git/node_modules)
echo "📦 Injecting Clean Boilerplate (Vue + Django + Docker)..."
rsync -av --progress "$TEMPLATE_DIR/" "$TARGET_DIR" \
    --exclude .git \
    --exclude node_modules \
    --exclude .venv \
    --exclude __pycache__ \
    --exclude db.sqlite3

# 3. Setup Environment Files
echo "🔐 Configuring environment variables..."
if [ -f "$TARGET_DIR/.env.example" ]; then
    cp "$TARGET_DIR/.env.example" "$TARGET_DIR/.env"
    echo "✅ Created .env from .env.example"
fi

# 4. Generate the Weekly README
echo "📝 Customizing Weekly README..."
cat <<EOT > "$TARGET_DIR/README.md"
# $WEEK: ${PROJECT_NAME//-/ }
> **Season:** $SEASON
> **Status:** 🟡 In Progress

## 🎯 Weekly Challenge Goal
[Enter the specific goal for this challenge here]

## 🛠️ Stack
- **Frontend:** Vue 3 (Vite)
- **Backend:** Django REST Framework
- **Database:** PostgreSQL
- **Auth:** JWT (SimpleJWT) + Custom User Model

## 🚦 Getting Started
1. \`cd $SEASON/$WEEK-$PROJECT_NAME\`
2. \`docker-compose up --build\`
3. Backend: http://localhost:8000 | Frontend: http://localhost:5173
EOT

# 5. Success Message
echo "--------------------------------------------------------"
echo "✨ Setup Complete!"
echo "📍 Location: $TARGET_DIR"
echo "💻 Next Steps:"
echo "   1. cd $TARGET_DIR"
echo "   2. docker-compose up"
echo "   3. Create your first app logic inside the backend/ folder!"
echo "--------------------------------------------------------"