# AGENTS.md

You are an AI collaborator working in this project.

This project follows a **Spec-Driven Development workflow**.

---

# 🔗 Context Source

Project-specific context is defined in:

👉 PROJECT-CONTEXT.md

Always read it before making decisions.

Also read these before making substantive changes:

* repository root `AGENTS.md`
* latest files under `handoff/`

---

# 🎯 Global Principles

* Spec first, implementation second
* Do not implement undefined behavior
* Keep spec and code aligned
* Prefer incremental updates
* Reuse existing definitions when possible

---

# 🧭 Working Habits

* Read `AGENTS.md`, `PROJECT-CONTEXT.md`, and relevant `handoff/` notes before planning work
* Start with planning, then execution, and structure work as `milestone` and `tasks in milestone`
* Treat human-maintained docs, specs, templates, and handoff files as Chinese-first unless the project explicitly requires another language
* Assume the primary users are internal company colleagues unless the project context says otherwise
* Make focused incremental edits instead of broad rewrites
* Call out spec / docs / implementation mismatches before extending behavior
* Keep product-project artifacts inside the product project; only change `vibe-starter` when adjusting reusable starter capability
* Immediately after finishing each task, record a handoff update; only after that, ask whether to continue or stop
* Treat the user's continue-or-stop choice as the next action after handoff, not as a prerequisite for recording it
* If there is no active `milestone`, or all `tasks in milestone` are already completed, do not force a continue-or-stop question; offer recommended next items if useful, while still preserving a stop option
* If the user does not know how to start, first offer structured starting options before deciding whether project-file inspection is needed

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
2. Create a plan using `milestone` and `tasks in milestone`
3. Identify related spec (roles / objects / behaviors / flows), update spec if needed, and validate consistency
4. Implement one task at a time
5. After each task, update handoff immediately
6. After handoff is recorded, ask whether to continue or stop
7. Exception: if there is no active `milestone`, or all `tasks in milestone` are complete, do not ask to continue by default; instead offer recommended next items if any, and keep stop as an option

---

# 🚫 Constraints

* No code without spec
* No undefined objects
* No implicit behavior
* Do not bypass spec structure

---

# 🧭 If Context Is Missing

If PROJECT-CONTEXT.md is incomplete:

1. Offer these starting options first:
   - `我有明確的計畫。` -> `請說明您的工作計畫。`
   - `我還沒有完整計畫，但我知道想做的工作項目。` -> `請說明您想完成的事項。`
   - `我不知道該怎麼開始。` -> `我會先檢查相關檔案，並提供您一些建議。`
2. If the user selects the third option, inspect relevant project files for context
3. Otherwise, proceed according to the selected option
4. Provide suggested starting points when useful
5. Ask for clarification OR
6. Propose a structured context draft

---

# 🧾 Output Preference

When making changes:

1. Spec impact
2. Files to update
3. Exact patch
4. Implementation notes
