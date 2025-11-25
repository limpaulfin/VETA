---
title: "Textor - Mermaid Examples (Advanced Part 1)"
subtitle: "Gantt, Git, Pie Charts"
version: "3.0.0"
updated: "2025-11-15"
---


# Mermaid Examples - Advanced Part 1


**Breadcrumb**: [Main Index](./00-instructions-textor-doc-converter-mermaid-plantuml.md) > [Mermaid Guide](./03-mermaid-guide.md) > Advanced Part 1


---



---



#### 6. Gantt Chart (Biểu đồ tiến độ)

```mermaid
gantt
    title A Gantt Diagram
    dateFormat  YYYY-MM-DD
    section Section
    A task           :a1, 2014-01-01, 30d
    Another task     :after a1  , 20d
    section Another
    Task in sec      :2014-01-12  , 12d
    another task      : 24d
```

**Use Cases:**
- Project timeline planning
- Task scheduling
- Resource allocation

**Syntax:**
- `section Name` = Group tasks
- `Task : id, start, duration` = Task definition
- `after id` = Dependency

---

#### 7. Git Graph (Sơ đồ Git)

```mermaid
gitGraph
    commit
    branch develop
    checkout develop
    commit
    commit
    checkout main
    merge develop
    commit
    branch feature
    checkout feature
    commit
    commit
    checkout main
    merge feature
```

**Use Cases:**
- Git workflow visualization
- Branch strategy documentation
- Release planning

---

#### 8. Pie Chart (Biểu đồ tròn)

```mermaid
pie title Pets adopted by volunteers
    "Dogs" : 386
    "Cats" : 85
    "Rats" : 15
```

**Use Cases:**
- Data distribution visualization
- Percentage breakdown
- Statistics reporting

---

#### 9. Mindmap (Sơ đồ tư duy)

```mermaid

---

**Next Step**: [Advanced Part 2](./05b-mermaid-mindmap-timeline.md) →
