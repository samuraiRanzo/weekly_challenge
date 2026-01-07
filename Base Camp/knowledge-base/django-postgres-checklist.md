# 🚀 Pro-Level Django + Postgres Checklist
> **Purpose:** Use this checklist every Thursday during the Weekly Challenge to refactor and optimize your code before the "Friday Launch."

---

## 1. Database Efficiency (The "N+1" Killer)
*Stop redundant database hits before they slow down your Vue frontend.*

- [ ] **Use `select_related()`**: Use this for **ForeignKey** or **OneToOne** relationships. It performs a SQL `JOIN` in a single query.
- [ ] **Use `prefetch_related()`**: Use this for **ManyToMany** or **Reverse ForeignKey** relationships. It performs a separate query and joins the data in Python.
- [ ] **Query Count Check**: Use `django-debug-toolbar` or simply print `len(connection.queries)` to ensure one request isn't triggering 50+ database hits.
- [ ] **Use `.only('field1', 'field2')`**: If your model has 20 columns but your Vue list only needs 2, don't fetch the rest.

---

## 2. Model Design & Indexing
*Ensure your Postgres schema is built for speed.*

- [ ] **Indexing (`db_index=True`)**: Add this to any field used in a `.filter()`, `.exclude()`, or `.order_by()`.
- [ ] **Unique Constraints**: Use `models.UniqueConstraint` in the `Meta` class for logic like "A user can only like a post once."
- [ ] **Foreign Key Naming**: Always use `on_delete=models.CASCADE` or `SET_NULL` appropriately to prevent orphaned data.
- [ ] **Search**: Use `SearchVector` or `TrigramSimilarity` if you are building search bars (Postgres specific).

---

## 3. Serializer Optimization (DRF)
*Serializers are the bridge. Don't let them become a bottleneck.*

- [ ] **Avoid `SerializerMethodField`**: These are executed in a loop and are slow. If possible, annotate the data onto the QuerySet instead.
- [ ] **Validation**: Always implement `validate_<field_name>` for custom logic rather than doing it in the View.
- [ ] **Nested Serializers**: Limit nesting to 1-2 levels. If you need more, consider a separate API call from the Vue side.

---

## 4. Security & Permissions
*Never ship an open endpoint.*

- [ ] **Global Permissions**: Ensure `REST_FRAMEWORK` in `settings.py` defaults to `IsAuthenticated`.
- [ ] **Custom Permissions**: If a user should only edit their own data, ensure an `IsOwner` permission class is applied.
- [ ] **JWT Rotation**: Verify that `ROTATE_REFRESH_TOKENS` is `True` in your JWT settings to keep user sessions secure.

---

## 5. Clean Code & 2026 Standards
- [ ] **Environment Variables**: Zero hardcoded credentials. Check your `.env` file.
- [ ] **Type Hinting**: Use Python type hints in your `services.py` or `views.py` (e.g., `def get_user(id: int) -> User:`).
- [ ] **Migrations**: Check that you haven't committed "junk" migrations. Squashing them before a season ends is a pro move.

---

## 💡 Sprint Refactor Rule
**"Make it work, then make it right, then make it fast."**
- **Mon-Wed:** Make it work.
- **Thursday:** Use this checklist to make it right & fast.
- **Friday:** Launch.