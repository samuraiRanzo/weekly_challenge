#!/bin/bash

# --- Configuration ---
SEASON=$1
WEEK=$2
PROJECT_NAME=$3
KB_CHECKLIST="../../Base Camp/knowledge-base/django-postgres-checklist.md"
PORT_REGISTRY="port_registry.txt"

# Modular Lego Pieces Paths
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

# --- 1. SMART PORT CALCULATION ---
# This ensures every project has unique ports in your homelab
touch "$PORT_REGISTRY"
LAST_OFFSET=$(tail -n 1 "$PORT_REGISTRY" | cut -d':' -f1)
if [ -z "$LAST_OFFSET" ]; then
    CURRENT_OFFSET=1
else
    CURRENT_OFFSET=$((LAST_OFFSET + 1))
fi

FE_PORT=$((5000 + CURRENT_OFFSET))
BE_PORT=$((8000 + CURRENT_OFFSET))

# --- Template Selection ---
echo "🎨 Choose your Frontend Style:"
echo "1) Base  2) Dashboard  3) Terminal  4) Minimalist"
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
echo "🚀 Initializing: $WEEK | $PROJECT_NAME (Ports: FE:$FE_PORT, BE:$BE_PORT)..."

# Create Target Directory
mkdir -p "$TARGET_DIR"

# 2. Modular Assembly
rsync -av --quiet "$BACKEND_SRC/" "$TARGET_DIR/backend" --exclude .venv --exclude __pycache__
rsync -av --quiet "$FE_SRC/" "$TARGET_DIR/frontend" --exclude node_modules --exclude .idea
rsync -av --quiet "$INFRA_SRC/" "$TARGET_DIR/"

# --- 3. INFRASTRUCTURE ORCHESTRATION (The Magic Part) ---
SAFE_NAME=$(echo "$PROJECT_NAME" | tr '-' '_')
sed -i "s/postgres_data/${SAFE_NAME}_db_data/g" "$TARGET_DIR/docker-compose.yml"

# Update Docker Compose with unique ports
if [ -f "$TARGET_DIR/docker-compose.yml" ]; then
    sed -i "s/5173:5173/$FE_PORT:5173/g" "$TARGET_DIR/docker-compose.yml"
    sed -i "s/8000:8000/$BE_PORT:8000/g" "$TARGET_DIR/docker-compose.yml"
    echo "✅ Ports remapped in docker-compose.yml"
fi

# Update Frontend .env to point to the unique Backend port
if [ -f "$TARGET_DIR/.env.example" ]; then
    cp "$TARGET_DIR/.env.example" "$TARGET_DIR/.env"

    # Injection: Replace the default 8000 with the NEW unique BE_PORT
    # We use | as a delimiter in sed because the URL contains slashes /
    sed -i "s|VITE_API_URL=.*|VITE_API_URL=http://localhost:$BE_PORT/|g" "$TARGET_DIR/.env"

    echo "✅ Created .env and injected Port: $BE_PORT"
fi

# --- 4. SUCCESS LOGGING ---
# Update the Registry for Mission Control
echo "$CURRENT_OFFSET:$FE_PORT:$BE_PORT:$SEASON/$WEEK/$PROJECT_NAME" >> "$PORT_REGISTRY"
# --- 5. CUSTOMIZATION OF BRANDING ---
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

echo "--------------------------------------------------------"
echo "✨ $STYLE_NAME Project Ready with Unique Ports!"
echo "📍 FE: http://localhost:$FE_PORT"
echo "📍 BE: http://localhost:$BE_PORT"
echo "--------------------------------------------------------"