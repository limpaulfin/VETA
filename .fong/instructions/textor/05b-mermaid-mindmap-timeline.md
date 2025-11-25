---
title: "Textor - Mermaid Examples (Advanced Part 2)"
subtitle: "Mindmap, Timeline, User Journey"
version: "3.0.0"
updated: "2025-11-15"
---


# Mermaid Examples - Advanced Part 2


**Breadcrumb**: [Main Index](./00-instructions-textor-doc-converter-mermaid-plantuml.md) > [Mermaid Guide](./03-mermaid-guide.md) > Advanced Part 2


---


mindmap
  root((mindmap))
    Origins
      Long history
      ::icon(fa fa-book)
      Popularisation
        British popular psychology author Tony Buzan
    Research
      On effectiveness<br/>and features
      On Automatic creation
        Uses
            Creative techniques
            Strategic planning
            Argument mapping
    Tools
      Pen and paper
      Mermaid
```

**Use Cases:**
- Brainstorming
- Knowledge organization
- Concept mapping

---

#### 10. Timeline (Dòng thời gian)

```mermaid
timeline
    title History of Social Media Platform
    2002 : LinkedIn
    2004 : Facebook
         : Google
    2005 : YouTube
    2006 : Twitter
```

**Use Cases:**
- Historical events
- Product roadmap
- Milestones tracking

---

#### 11. User Journey (Hành trình người dùng)

```mermaid
journey
    title My working day
    section Go to work
      Make tea: 5: Me
      Go upstairs: 3: Me
      Do work: 1: Me, Cat
    section Go home
      Go downstairs: 5: Me
      Sit down: 5: Me
```

**Use Cases:**
- UX design
- Customer experience mapping
- Process satisfaction analysis

**Syntax:**
- `Task: score: Actor` = Journey step with satisfaction score (1-5)

---

---

**Next Step**: [PlantUML Guide](./06-plantuml-guide.md) →

---

**Next Step**: [PlantUML Guide](./06-plantuml-guide.md) →
