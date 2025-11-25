---
title: "Textor - PlantUML Salt Advanced (Part 1)"
subtitle: "Text Area, Group Box, Separators, Tree"
version: "3.0.0"
updated: "2025-11-15"
---


# PlantUML Salt - Advanced Part 1


**Breadcrumb**: [Main Index](./00-instructions-textor-doc-converter-mermaid-plantuml.md) > [PlantUML Guide](./06-plantuml-guide.md) > [Salt Guide](./08-plantuml-salt-guide.md) > Advanced Part 1


---



---


#### 4. Tree Widget `{T`

Create hierarchical tree structures with `+` notation:

```plantuml
@startsalt
{
{T
 + World
 ++ America
 +++ Canada
 +++ USA
 ++++ New York
 ++++ Boston
 +++ Mexico
 ++ Europe
 +++ Italy
 +++ Germany
 ++++ Berlin
}
}
@endsalt
```

**Levels:**
- `+` = Level 1
- `++` = Level 2
- `+++` = Level 3
- etc.

---

#### 5. Tabs `{/`

**Horizontal Tabs:**

```plantuml
@startsalt
{+
{/ <b>General | Fullscreen | Behavior | Saving }
{
  { Open image in: | ^Smart Mode^ }
  [X] Smooth images when zoomed
  [X] Confirm image deletion
  [ ] Show hidden images
}
[Close]
}
@endsalt
```

**Vertical Tabs:**

```plantuml
@startsalt
{+
{/ <b>General
Fullscreen
Behavior
Saving } |
{
  { Open image in: | ^Smart Mode^ }
  [X] Smooth images when zoomed
  [X] Confirm image deletion
  [ ] Show hidden images
  [Close]
}
}
@endsalt
```

---

#### 6. Menu `{*`

Create menu bars:

```plantuml
@startsalt
{+
{* File | Edit | Source | Refactor }
{/ General | Fullscreen | Behavior | Saving }
{

---

**Next Step**: [Salt Advanced Part 2](./09b-plantuml-salt-tabs-menu.md) →
