# AGENTS.md

You are an AI collaborator maintaining `vibe-starter`.

`vibe-starter` is a reusable starter tool. It generates baseline files for product projects, but product projects use `templates/AGENTS.md` after initialization.

---

# 🔗 Context Sources

Before making substantive changes to starter behavior, read the relevant source-of-truth context:

* repository root `../AGENTS.md`
* repository root specs under `../specs/`
* `README.md`
* `templates/AGENTS.md`
* related files under `templates/`
* related launchers under `scripts/`

---

# 🎯 Global Principles

* Spec first, implementation second
* Do not implement undefined behavior
* Keep spec and code aligned
* Prefer incremental updates
* Reuse existing definitions when possible

---

# 🧭 Working Habits

* Read this `AGENTS.md`, the repository root spec, and the relevant starter README/templates/scripts before planning work
* Treat `templates/AGENTS.md` as the baseline AGENTS content generated for product projects
* Do not assume product projects read this file; this file only governs maintenance of `vibe-starter`
* Keep generated path-resolution guidance consistent across `templates/AGENTS.md`, README, and generated support files
* Start with planning, then execution, and structure work as `milestone` and `tasks in milestone`
* Reusable milestone support belongs under `vibe-coding/milestones/index.md` and `vibe-coding/milestones/tasks/` in generated product projects
* Keep generated milestone guidance consistent across `templates/AGENTS.md`, `templates/vibe-coding/milestones/`, README, and all `generate` launchers
* Reusable feature discussion support belongs under `vibe-coding/features/` in generated product projects
* Keep generated feature guidance consistent across `templates/AGENTS.md`, `templates/vibe-coding/features/`, README, and all `generate` launchers
* Reusable prototype exploration support belongs under `vibe-coding/prototypes/` in generated product projects
* Keep generated prototype guidance consistent across `templates/AGENTS.md`, `templates/vibe-coding/prototypes/`, README, and all `generate` launchers
* Treat human-maintained docs, specs, templates, and handoff files as Chinese-first unless the project explicitly requires another language
* Assume the primary users are internal company colleagues unless the repository root spec says otherwise
* Make focused incremental edits instead of broad rewrites
* Distinguish facts, inference, and missing context; never present inference as confirmed truth
* Cite the source basis before project-specific conclusions, and verify high-risk details such as paths, commands, versions, and integrations before relying on them
* Call out spec / docs / implementation mismatches before extending behavior
* Keep product-project artifacts inside the product project; only change `vibe-starter` when adjusting reusable starter capability
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

1. Read the relevant repository root spec under `../specs/`
2. Read the affected starter files under `README.md`, `templates/`, and `scripts/`
3. Create a focused plan using the starter behavior being changed
4. Judge whether the change affects generated behavior, generated files, launcher parity, rules, states, or object responsibility
5. If it is a technical-only small change with no generated behavior change, implementation may proceed directly after consistency checks
6. If it affects generated behavior, add or confirm the minimum necessary root spec first, then validate consistency
7. Implement focused changes across every affected launcher and template, including prototype-layer structure when the change affects visual exploration workflow
8. Validate shell launchers and generated output where possible

---

# 🚫 Constraints

* No code without spec
* No undefined objects
* No implicit behavior
* Do not bypass spec structure

---

# 🧭 If Starter Context Is Missing

If starter context is incomplete:

1. Offer these starting options first:
   - `我有明確的計畫。` -> `請說明您的工作計畫。`
   - `我還沒有完整計畫，但我知道想做的工作項目。` -> `請說明您想完成的事項。`
   - `我不知道該怎麼開始。` -> `我會先檢查相關檔案，並提供您一些建議。`
2. If the user selects the third option, inspect relevant project files for context
3. Otherwise, proceed according to the selected option
4. Provide suggested starting points when useful
5. Ask for clarification OR
6. Propose a minimal starter spec or README/template clarification

---

# 🧾 Output Preference

When making changes:

1. Spec impact
2. Files to update
3. Exact patch
4. Implementation notes
