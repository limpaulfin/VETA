---
title: "Textor - PlantUML Salt Advanced (Part 2)"
subtitle: "Tabs, Menu, Colors"
version: "3.0.0"
updated: "2025-11-15"
---


# PlantUML Salt - Advanced Part 2 (Tabs, Menu, Colors)


**Breadcrumb**: [Main Index](./00-instructions-textor-doc-converter-mermaid-plantuml.md) > [PlantUML Guide](./06-plantuml-guide.md) > [Salt Guide](./08-plantuml-salt-guide.md) > Advanced Part 2


---


  { Open image in: | ^Smart Mode^ }
  [X] Smooth images when zoomed
  [X] Confirm image deletion
  [ ] Show hidden images
}
[Close]
}
@endsalt
```

**Open Menu Items:**

```plantuml
@startsalt
{+
{* File | Edit | Source | Refactor
 Refactor | New | Open | Save }
{/ General | Fullscreen | Behavior | Saving }
{
  { Open image in: | ^Smart Mode^ }
  [X] Smooth images when zoomed
}
[Close]
}
@endsalt
```

---

#### 7. Colors

Add colors to widgets using `<color:ColorName>` or `<color:#HexCode>`:

```plantuml
@startsalt
{
  <color:Blue>Just plain text
  [This is my default button]
  [<color:green>This is my green button]
  [<color:#9a9a9a>This is my disabled button]
  []  <color:red>Unchecked box
  [X] <color:green>Checked box
  "Enter text here   "
  ^This is a droplist^
  ^<color:#9a9a9a>This is a disabled droplist^
  ^<color:red>This is a red droplist^
}
@endsalt
```

**Supported Colors:**
- Named: `Blue`, `Red`, `Green`, `Yellow`, `Orange`, `Purple`
- Hex codes: `#9a9a9a`, `#ff0000`, `#00ff00`

---

### Salt Complete Example - Settings Dialog

```plantuml
@startsalt
{+
{* File | Edit | View | Help }
{/ <b>General | Display | Advanced | About }
==
{^"User Preferences"
  Username     | "admin       "
  Password     | "********    "
  Remember me  | [X]
}
--
{^"Display Options"
  Theme        | ^Dark Mode^^ Light^^ Auto^
  Font Size    | ^Medium^
  []  Enable animations
  [X] Show tooltips
  []  High contrast mode
}
==
{
  [Cancel] | [Apply] | [OK]
}
}
@endsalt
```

---

### Salt Quick Reference

#### Widget Cheat Sheet

---

**Next Step**: [PlantUML Salt Examples](./10-plantuml-salt-examples.md) →

---

**Next Step**: [Salt Examples](./10-plantuml-salt-examples.md) →
