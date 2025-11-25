---
title: "Textor - Mermaid Examples (ER & State)"
subtitle: "ER Diagram and State Diagram"
version: "3.0.0"
updated: "2025-11-15"
---


# Mermaid Examples - ER & State Diagrams


**Breadcrumb**: [Main Index](./00-instructions-textor-doc-converter-mermaid-plantuml.md) > [Mermaid Guide](./03-mermaid-guide.md) > ER & State Examples


---



```mermaid
sequenceDiagram
    Alice->>+John: Hello John, how are you?
    Alice->>+John: John, can you hear me?
    John-->>-Alice: Hi Alice, I can hear you!
    John-->>-Alice: I feel great!
```

**Use Cases:**
- API interaction flows
- System component communication
- Message passing between objects

**Syntax:**
- `->>` = Solid arrow (synchronous message)
- `-->>` = Dashed arrow (response)
- `+` = Activate lifeline
- `-` = Deactivate lifeline

---

#### 4. ER Diagram (Entity-Relationship)

```mermaid
erDiagram
    CUSTOMER ||--o{ ORDER : places
    ORDER ||--|{ ORDER_ITEM : contains
    PRODUCT ||--o{ ORDER_ITEM : includes
    CUSTOMER {
        string id
        string name
        string email
    }
    ORDER {
        string id
        date orderDate
        string status
    }
    PRODUCT {
        string id
        string name
        float price
    }
    ORDER_ITEM {
        int quantity
        float price
    }
```

**Use Cases:**
- Database schema design
- Data modeling
- Relationship mapping

**Syntax:**
- `||--o{` = One-to-many relationship
- `||--|{` = One-to-one or one-to-many
- `EntityName { type field }` = Entity attributes

---

#### 5. State Diagram (Sơ đồ trạng thái)

```mermaid
stateDiagram-v2
    [*] --> Still
    Still --> [*]
    Still --> Moving
    Moving --> Still
    Moving --> Crash
    Crash --> [*]
```

**Use Cases:**
- State machine design
- Workflow states
- Object lifecycle

**Syntax:**
- `[*]` = Start/End state
- `State1 --> State2` = Transition


---

**Next Step**: [Mermaid Examples - Advanced](./05-mermaid-examples-advanced.md) →
