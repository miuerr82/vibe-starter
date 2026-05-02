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
* If `AGENTS.md` explicitly defines spec or handoff paths, follow those explicit paths first
* If `AGENTS.md` does not explicitly define spec or handoff paths, look for a project-local `vibe-coding/` workspace before assuming any other location
* Check `vibe-coding/` first, then other vibe-coding-related directories, and only create a new `vibe-coding/` workspace when no suitable directory exists
* If fallback discovery determines the effective spec or handoff path, request an `AGENTS.md` update so the resolved path becomes explicit for later work
* Start with planning, then execution, and structure work as `milestone` and `tasks in milestone`
* Reusable milestone support belongs under `vibe-coding/milestones/index.md` and `vibe-coding/milestones/tasks/` in generated product projects
* Keep generated milestone guidance consistent across `templates/AGENTS.md`, `templates/vibe-coding/milestones/`, README, and all `generate` launchers
* Treat human-maintained docs, specs, templates, and handoff files as Chinese-first unless the project explicitly requires another language
* Assume the primary users are internal company colleagues unless the project context says otherwise
* Make focused incremental edits instead of broad rewrites
* Distinguish facts, inference, and missing context; never present inference as confirmed truth
* Cite the source basis before project-specific conclusions, and verify high-risk details such as paths, commands, versions, and integrations before relying on them
* Call out spec / docs / implementation mismatches before extending behavior
* Keep product-project artifacts inside the product project; only change `vibe-starter` when adjusting reusable starter capability
* Immediately after finishing each task, record a handoff update; only after that, ask whether to continue or stop
* Treat the user's continue-or-stop choice as the next action after handoff, not as a prerequisite for recording it
* If there is no active `milestone`, or all `tasks in milestone` are already completed, do not force a continue-or-stop question; offer recommended next items if useful, while still preserving a stop option
* For existing projects, first judge whether the change is a technical-only small change or a behavior-affecting change; only the latter requires minimum necessary spec before implementation
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
3. Judge whether the change affects behavior, flow, rules, state, or object responsibility
4. If it is a technical-only small change with no behavior change, implementation may proceed directly after consistency checks
5. If it affects behavior, flow, rules, state, or object responsibility, add the minimum necessary spec first, then validate consistency
6. Implement one task at a time
7. After each task, update handoff immediately
8. After handoff is recorded, ask whether to continue or stop
9. Exception: if there is no active `milestone`, or all `tasks in milestone` are complete, do not ask to continue by default; instead offer recommended next items if any, and keep stop as an option

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
