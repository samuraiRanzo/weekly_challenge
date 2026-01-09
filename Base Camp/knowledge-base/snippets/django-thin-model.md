# 📄 Snippet: Normal (Thin) Model
> **Purpose:** A clean data structure focused solely on schema definition, designed to be used alongside a Service Layer for business logic.

---

## 🏗️ 1. The Model (`core/models.py`)
```python
from django.db import models
from django.conf import settings

class Task(models.Model):
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_index=True, on_delete=models.CASCADE)
    title = models.CharField(max_length=255)
    description = models.TextField(blank=True)
    due_date = models.DateTimeField()
    is_completed = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ['-created_at']
        verbose_name = "Task"
```

## 🛠️ 2. Service Layer (`core/services.py`)
```python
def complete_task(task_id: int) -> bool:
    # Logic lives here, keeping the model thin
    task = Task.objects.get(id=task_id)
    task.is_completed = True
    task.save()
    return True
```

# 💡 Implementation Note
> **Architecture:** Thin models are highly maintainable as your project scales. They ensure your database schema and business logic remain decoupled, making unit testing significantly easier.