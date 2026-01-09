# ⚡ Vue 3 Performance & Composition Patterns
> **Purpose:** Advanced mental models for building scalable, high-performance frontends with the Vue 3 Composition API and Pinia.

---

## 🏗️ 1. Architecture: Logic Extraction (Composables)
To keep components thin and readable, extract logic into reusable "Composables."

* **Pattern:** Instead of putting 100 lines of API logic in `HomeView.vue`, move it to a dedicated file like `src/composables/useDataFetching.js`.
* **Benefit:** Shared stateful logic without the overhead of Mixins or the complexity of Scoped Slots.
* **Application:** Use this pattern for the **Smart Task Orchestrator** (Week 05) to handle polling logic outside the UI layer.

## 🍍 2. State Management Strategy (Pinia)
The "Clean Slate" boilerplate already utilizes Pinia for `auth` and `admin` stores.

* **Avoid "God Stores":** Do not consolidate all application logic into a single store. Create domain-specific stores such as `useTaskStore` or `useNotificationStore`.
* **Action Logic:** Keep components "dumb." If a data transformation is required after an API call, perform it inside the Pinia action rather than the component's `onMounted` hook.
* **Subscription:** Use `store.$subscribe()` sparingly for logging or local storage syncing to prevent performance bottlenecks.

## 🚀 3. Performance Optimization
As your "Mission Control" interface grows, follow these rules to maintain a responsive UI:

* **ShallowRef for Large Lists:** When fetching large datasets (1000+ items) for features like the **Real-Time Data Dashboard** (Week 06), use `shallowRef` instead of `ref`. This prevents Vue from making every nested property deeply reactive, saving significant CPU cycles.
* **v-once & v-memo:** Use `v-once` for static content that never changes after the initial render. Use `v-memo` for complex list items to skip re-renders unless specific dependencies change.
* **Async Components:** Lazy-load views that are not part of the critical path, such as `AboutView.vue` or `AdminDashboardView.vue`.

## 🧹 4. Memory Management
* **Manual Clean-up:** While Vue manages most garbage collection, always clear `setInterval`, `setTimeout`, or manual `addEventListener` calls within the `onUnmounted` lifecycle hook.
* **WebSocket Discipline:** For the **Real-Time Data Dashboard** (Week 06), ensure socket connections are explicitly closed when the user navigates away from the dashboard component.

## 🎨 5. Clean Template Standards
* **Logic-less Templates:** If a `v-if` condition exceeds three variables, move it into a `computed` property.
* **Prop Stability:** Pass objects as props only when necessary; passing primitives like `id` or `status` makes it easier for Vue to determine if a component truly needs to re-render.

---

## 💡 Sprint Refactor Tip
> "If you have to scroll more than twice to read a single component, it’s time to extract a child component or a Composable."