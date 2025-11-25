---
title: "Textor - PlantUML Salt Guide (Part 2)"
subtitle: "Grid Layout & Modifiers"
version: "3.0.0"
updated: "2025-11-15"
---


# PlantUML Salt Guide - Part 2 (Grid Layout)


**Breadcrumb**: [Main Index](./00-instructions-textor-doc-converter-mermaid-plantuml.md) > [PlantUML Guide](./06-plantuml-guide.md) > Salt Guide Part 2


---


| `{!` | Display all outer borders | `{! Login \| "text" }` |
| `{-` | Dash border | `{- Login \| "text" }` |
| `{+` | Opening a new window | `{+ ... }` |

**Example with Borders:**

```plantuml
@startsalt
{+
{# 
  Login    | "MyName   "
  Password | "****     "
  [Cancel] | [  OK   ]
}
}
@endsalt
```

---

### Advanced Features

#### 1. Text Area (Multiline Input)

**Syntax:**
- Use `.` to fill vertical space
- Last line with spaces `"      "` to set width

```plantuml
@startsalt
{+
   This is a long
   text in a textarea
   .
   "                         "
}
@endsalt
```

**With Scroll Bars:**

| Scroll Type | Syntax | Description |
|-------------|--------|-------------|
| Horizontal + Vertical | `{S` | Both scrollbars |
| Horizontal only | `{SI` | Horizontal bar |
| Vertical only | `{S-` | Vertical bar |

```plantuml
@startsalt
{SI
   This is a long
   text in a textarea
   .
   "                         "
}
@endsalt
```

---

#### 2. Group Box `{^"Title"`

Create grouped sections with titles:

```plantuml
@startsalt
{^"My group box"
  Login    | "MyName   "
  Password | "****     "
  [Cancel] | [  OK   ]
}
@endsalt
```

---

#### 3. Separators

Use different separators for visual division:

| Separator | Style |
|-----------|-------|
| `..` | Dotted line |
