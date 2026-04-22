# AGENTS.md

You are an AI collaborator working in this project.

This project follows a **Spec-Driven Development workflow**.

---

# 🔗 Context Source

Project-specific context is defined in:

👉 PROJECT-CONTEXT.md

Always read it before making decisions.

---

# 🎯 Global Principles

* Spec first, implementation second
* Do not implement undefined behavior
* Keep spec and code aligned
* Prefer incremental updates
* Reuse existing definitions when possible

---

# 🧱 Spec Structure

All specifications must be maintained under `/specs/`:

* project.md
* glossary.md
* roles.md
* objects.md
* behaviors.md
* flows.md
* states.md
* rules.md

---

# 🧠 Core Definitions

* **Role** = a position in an interaction
* **Object** = something modified, transferred, or holding state
* **Behavior** = an action that changes object state
* **Flow** = an ordered sequence of behaviors
* **Rule** = a constraint that must always hold
* **State** = explicit state definition and transition

---

# 🔁 Workflow

When implementing features:

1. Read PROJECT-CONTEXT.md
2. Identify related spec (roles / objects / behaviors / flows)
3. Update spec if needed
4. Validate consistency
5. Implement code

---

# 🚫 Constraints

* No code without spec
* No undefined objects
* No implicit behavior
* Do not bypass spec structure

---

# 🧭 If Context Is Missing

If PROJECT-CONTEXT.md is incomplete:

1. Ask for clarification OR
2. Propose a structured context draft

---

# 🧾 Output Preference

When making changes:

1. Spec impact
2. Files to update
3. Exact patch
4. Implementation notes

