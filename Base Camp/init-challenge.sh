#!/bin/bash

# --- Configuration ---
SEASON=$1
WEEK=$2
PROJECT_NAME=$3
KB_CHECKLIST="../../Base Camp/knowledge-base/django-postgres-checklist.md"

# Paths to the Modular Lego Pieces
BACKEND_SRC="./templates/django-vue-base/shared-backend"
INFRA_SRC="./templates/django-vue-base/shared-infra"

# --- Validation ---
if [ -z "$PROJECT_NAME" ]; then
    echo "❌ Error: Missing arguments."
    echo "Usage: ./init-challenge.sh [Season] [Week] [Project-Name]"
    exit 1
fi

if [[ "$PWD" != *"/Base Camp" ]]; then
    echo "❌ Error: Please run this script from inside the 'Base Camp' directory."
    exit 1
fi

# --- Template Selection ---
echo "🎨 Choose your Frontend Style:"
echo "1)Base 2) Dashboard  3) Terminal 4) Minimalist"
read -p "Select [1-4]: " STYLE_CHOICE

case $STYLE_CHOICE in
    2) FE_SRC="./templates/django-vue-base/frontend-dashboard" ; STYLE_NAME="Dashboard" ;;
    3) FE_SRC="./templates/django-vue-base/frontend-terminal" ; STYLE_NAME="Terminal" ;;
    4) FE_SRC="./templates/django-vue-base/frontend-minimal" ; STYLE_NAME="Minimalist" ;;
    *) FE_SRC="./templates/django-vue-base/frontend" ; STYLE_NAME="Base" ;;
esac

TARGET_DIR="../$SEASON/$WEEK/$PROJECT_NAME"

# --- Interactive Goal Setting ---
echo "📝 What is the primary goal for $WEEK?"
read -p "> " WEEKLY_GOAL

# --- Execution ---
echo "🚀 Initializing: $WEEK | $PROJECT_NAME..."

# 1. Create Target Directory
if [ -d "$TARGET_DIR" ]; then
    echo "⚠️  Warning: $TARGET_DIR already exists. Skipping creation."
else
    mkdir -p "$TARGET_DIR"
    echo "📁 Created folder: $TARGET_DIR"
fi

# 2. Modular Assembly (The "Lego" Logic)
echo "🏗️  Assembling pieces from $STYLE_NAME template..."

# Inject Backend
rsync -av --quiet "$BACKEND_SRC/" "$TARGET_DIR/backend" --exclude .venv --exclude __pycache__

# Inject Chosen Frontend
rsync -av --quiet "$FE_SRC/" "$TARGET_DIR/frontend" --exclude node_modules --exclude .idea

# Inject Infrastructure (docker-compose, etc.)
rsync -av --quiet "$INFRA_SRC/" "$TARGET_DIR/"

# 2.5 Personalize Frontend Brand Name
echo "🎨 Personalizing frontend brand..."
# This matches whatever is inside the <h1> or <a> tag more reliably
# Or just search for a simpler string that YOU know is in your template
if [ -f "$APP_VUE_PATH" ]; then
    # Try a more generic replacement or verify the exact text in your App.vue
    sed -i "s|Vue 3 + Vite + Django|$FORMATTED_NAME|g" "$APP_VUE_PATH"
    # Tip: Check if your App.vue actually contains "Vue 3 + Vite + Django"
fi

# Universal Title Update
if [ -f "$INDEX_HTML_PATH" ]; then
    sed -i "s|<title>.*</title>|<title>$FORMATTED_NAME</title>|g" "$INDEX_HTML_PATH"
fi

# 3. Setup Environment Files
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
> **Template:** Modular ($STYLE_NAME)

## 🎯 Weekly Challenge Goal
$WEEKLY_GOAL

## 🛠️ Stack
- **Frontend:** Vue 3 ($STYLE_NAME)
- **Backend:** Shared Django Engine
- **Database:** PostgreSQL 16
- **Orchestration:** Docker Compose V2

## 📅 Refactor Schedule
- **Monday-Wednesday:** Feature implementation.
- **Thursday:** Use the [Optimization Checklist]($KB_CHECKLIST).
- **Friday:** Final testing and Launch.

## 🚦 Getting Started
1. \`cd $SEASON/$WEEK-$PROJECT_NAME\`
2. \`docker compose up --build\`
EOT

# 5. Success Message
echo "--------------------------------------------------------"
echo "✨ $STYLE_NAME Project Ready!"
echo "📍 Location: $TARGET_DIR"
echo "💻 Next Steps:"
echo "   1. cd \"$TARGET_DIR\""
echo "   2. docker compose up"
echo "--------------------------------------------------------"