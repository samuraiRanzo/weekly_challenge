## 🛠️ January: The Base Camp (Prep Month)
> *Focus: Building boilerplates and centralizing high-value documentation.*

### 📦 Boilerplates
* [Django + Vue Starter](./templates/django-vue-base) - Pre-configured with Docker & Tailwind.
* [Markdown Sprint Template](./templates/readme-template.md) - For 5-minute documentation.

### 🧠 Knowledge Base
* [Django Advanced Patterns](./knowledge-base/django-pro.md) - Middleware, Custom Managers, Signals.
* [Vue 3 Performance](./knowledge-base/vue-tips.md) - Composition API best practices.
* [Postgres Optimization](./knowledge-base/sql-cheatsheet.md) - Indexes and JSONB.

### 📚 Learning Queue (Season 2 Prep)
1. **Rust:** [The Rust Book](https://doc.rust-lang.org/book/)
2. **Go:** [Go by Example](https://gobyexample.com/)

```ecma script level 4
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

```