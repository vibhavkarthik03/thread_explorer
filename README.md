# Thread Explorer

A high-performance discussion thread viewer supporting:

- Deeply nested comments
- Smooth expand / collapse
- 60 FPS scrolling
- Stable memory usage
- Clean scalable architecture

---

## Demo



https://github.com/user-attachments/assets/7a771b9b-67e9-460b-a320-e838efbc4ac8


---

## Idea/Solution

Note: The comments API doesn't support pagination and fields that highlights deleted or dead comments.

> **Keep the full tree in memory, but render only what is visible.**

| Data Structure | Role |
|---|---|
| **Tree** | Source of truth |
| **Flattened Visible List** | Actually rendered by UI |

Instead of recursively building UI:

Flatten once during initial load  
On **expand** → insert only that subtree  
On **collapse** → remove only that subtree

This gives:

- No recursion at the UI level
- Low rebuild cost

---

## Expand / Collapse Logic

### Expand
Find the parent Comment index in `visible` list  
Flatten only that Comment’s children  
Insert them directly after parent

UI updates *only* the affected segment.

---

### Collapse
Find parent index  
Scan forward  
Stop when `depth ≤ parentDepth`  
Remove that range

Only the subtree disappears.
Rest of list remains intact.

---

## Performance Complexity

- **n** = total comments
- **k** = comments in affected subtree

| Operation | Time | Space |
|---|---|---|
| Initial flatten | O(n) | O(n) |
| Expand | O(k) | O(k) temp |
| Collapse | O(k) | O(1) |
| Visible list memory | O(n) max | |

---

## Architecture

### Feature-based + Clean Architecture

```text
lib/
 └─ features/
     └─ threads/
         ├─ data/
         │   ├─ models/
         │   └─ repository/
         ├─ presentation/
         │   ├─ bloc/
         │   ├─ screens/
         │   └─ widgets/
         └─ utils/
```

---
