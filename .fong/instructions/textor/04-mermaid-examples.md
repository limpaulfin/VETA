---
title: "Textor - Mermaid Examples (Basic)"
subtitle: "Flowchart, Class, Sequence Diagrams"
version: "3.0.0"
updated: "2025-11-15"
---


# Mermaid Examples - Basic


**Breadcrumb**: [Main Index](./00-instructions-textor-doc-converter-mermaid-plantuml.md) > [Mermaid Guide](./03-mermaid-guide.md) > Basic Examples


---


#### 1. Flowchart (Sơ đồ luồng)

```mermaid
flowchart TD
    A[Christmas] -->|Get money| B(Go shopping)
    B --> C{Let me think}
    C -->|One| D[Laptop]
    C -->|Two| E[iPhone]
    C -->|Three| F[fa:fa-car Car]
```

**Use Cases:**
- Quy trình nghiệp vụ (Business process flow)
- Thuật toán (Algorithm steps)
- Decision making flow

**Syntax:**
- `flowchart TD` = Top-Down direction
- `flowchart LR` = Left-Right direction
- `A[Text]` = Rectangle node
- `B(Text)` = Rounded node
- `C{Text}` = Diamond (decision)
- `-->` = Arrow connection
- `-->|Label|` = Labeled arrow

---

#### 2. Class Diagram (Sơ đồ lớp OOP)

```mermaid
classDiagram
    Animal <|-- Duck
    Animal <|-- Fish
    Animal <|-- Zebra
    Animal : +int age
    Animal : +String gender
    Animal: +isMammal()
    Animal: +mate()
    class Duck{
      +String beakColor
      +swim()
      +quack()
    }
    class Fish{
      -int sizeInFeet
      -canEat()
    }
    class Zebra{
      +bool is_wild
      +run()
    }
```

**Use Cases:**
- OOP design documentation
- Class relationships (inheritance, aggregation)
- System architecture

**Syntax:**
- `<|--` = Inheritance
- `+` = Public member
- `-` = Private member
- `ClassName : +type field` = Property
- `ClassName: +method()` = Method

---

#### 3. Sequence Diagram (Sơ đồ tuần tự)

---

**Next Step**: [Mermaid Examples - Advanced](./05-mermaid-examples-advanced.md) →
