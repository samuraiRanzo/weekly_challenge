# 🎸 Advanced Django: Architecture & Patterns
> **Purpose:** Moving beyond standard MVC to build maintainable, testable, and scalable backend logic.

---

## 🏗️ 1. The Service Layer Pattern
To keep `views.py` thin and readable, encapsulate business logic in a dedicated `services.py` module.

* **The Rule:** Views should only handle HTTP concerns (request parsing, response status). Services handle the core business logic.
* **Pattern:** Instead of writing complex logic inside a `POST` method in `core/views.py`, call a function like `services.create_user_with_profile(data)`.
* **Benefit:** Logic becomes easily testable in isolation and can be reused by CLI commands, management tasks, or Celery workers.

## 🔍 2. Custom Managers & QuerySets
Encapsulate common database queries to keep your code DRY (Don't Repeat Yourself).

* **Pattern:** Create a `TaskQuerySet` with specific methods like `.completed()` or `.overdue()`.
* **Usage:** Use `Task.objects.overdue()` in your views instead of filtering manually with `Task.objects.filter(status='pending', due_date__lt=now)`.
* **Benefit:** Centralizes query logic; if the definition of "overdue" changes, you only need to update it in one place.

## ⚡ 3. Signals vs. Overriding save()
Understand when to use Django Signals versus method overrides to manage side effects.

* **Signals (post_save):** Use for decoupled logic, such as sending a welcome email or notifying an external AI service after a model is created.
* **Override save():** Use when the logic is intrinsic to the model itself, such as auto-generating a slug or calculating a field based on other internal data.
* **Pro Tip:** Avoid "Heavy Signals" that trigger further signals, as they make the execution flow difficult to debug.

## 📦 4. Efficient Serialization (DRF)
The "Clean Slate" template uses `drf-spectacular` for automated API documentation. Maintain this standard by:

* **Serializers as Validators:** Use serializers in `core/serializers.py` to strictly validate incoming data before it reaches your service layer or models.
* **Contextual Fields:** Use `SerializerMethodField` only when necessary, as they can trigger N+1 query issues. Prefer database annotations (`.annotate()`) within the QuerySet where possible.

## 🕒 5. Preparing for Async (Celery)
As you prepare for the **Smart Task Orchestrator** in Week 05, adopt an "Async-First" mindset:

* **Idempotency:** Ensure background tasks can be run multiple times without causing duplicate side effects.
* **Atomic Transactions:** Use `transaction.on_commit()` to ensure background tasks are only triggered after the database transaction has successfully closed.

---

## 💡 Sprint Refactor Tip
> "If your `views.py` contains an `if` statement longer than 5 lines, that logic belongs in a Service. If your `filter()` call is used in more than two places, it belongs in a Manager."