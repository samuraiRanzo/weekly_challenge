# 🍔 Snippet: Fat Model
> **Purpose:** Encapsulating behavior, status logic, and data transitions directly within the model instance to ensure data integrity and reusability.

---

## 🏗️ 1. The Model (`core/models.py`)
```python
from django.db import models
from django.utils import timezone

class Order(models.Model):
    total_amount = models.DecimalField(max_digits=10, decimal_places=2)
    status = models.CharField(max_length=20, default='pending')
    paid_at = models.DateTimeField(null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)

    # Property for status logic
    @property
    def is_overdue(self) -> bool:
        return self.status == 'pending' and self.created_at < timezone.now()

    # Method for encapsulated behavior
    def mark_as_paid(self):
        self.status = 'paid'
        self.paid_at = timezone.now()
        self.save()

    # Overriding save for intrinsic logic
    def save(self, *args, **kwargs):
        if self.total_amount < 0:
            raise ValueError("Total amount cannot be negative")
        super().save(*args, **kwargs)
```
---

## 🛠️ 2. The Usage (`View/Logic`)
>Instead of manual updates, call the model's behavior directly
```python
order = Order.objects.get(id=1)
order.mark_as_paid()
```

# 💡 Implementation Note
> **Best Practice:** Use Fat Models for logic that is intrinsic to the data itself, such as state transitions. Avoid placing logic that triggers side effects—like sending emails or calling external APIs—inside the model; those concerns belong in a Service Layer.