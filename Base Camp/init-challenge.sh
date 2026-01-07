#!/bin/bash

# Usage: ./init-challenge.sh S1 Week-05 my-new-project
SEASON=$1
WEEK=$2
PROJECT_NAME=$3

if [ -z "$PROJECT_NAME" ]; then
    echo "Usage: ./init-challenge.sh [Season] [Week] [Project-Name]"
    echo "Example: ./init-challenge.sh S1-Mastery Week-05 task-tracker"
    exit 1
fi

TARGET_DIR="./$SEASON/$WEEK-$PROJECT_NAME"

# 1. Create the directory structure
echo "🚀 Creating challenge folder at $TARGET_DIR..."
mkdir -p "$TARGET_DIR"

# 2. Copy the boilerplate from January templates
echo "📦 Copying Django + Vue boilerplate..."
cp -r ./templates/django-vue-base/. "$TARGET_DIR"

# 3. Create a project-specific README
echo "📝 Generating Week README..."
cat <<EOT > "$TARGET_DIR/README.md"
# $WEEK: $PROJECT_NAME
> **Season:** $SEASON
> **Status:** 🟡 In Progress

## 🎯 Goal
[Describe what you are building this week]

## 🛠️ Tech Used
- Django (Backend)
- Vue.js (Frontend)
- PostgreSQL (Database)

## 🚀 Quick Start
\`\`\`bash
docker-compose up --build
\`\`\`
EOT

echo "✅ Done! Your workspace is ready at $TARGET_DIR"
echo "🔥 Happy Coding!"