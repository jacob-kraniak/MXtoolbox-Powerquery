# SOAR Query Annotation Standard
**Version:** 1.0    
**Applies To:** Power Query (Excel / Power BI), API-based data pipelines  
**Audience:** Security Engineering, Threat Management, SOC Automation

---

## 1. Purpose

This standard defines a **lightweight, non‑disruptive annotation method** for documenting the **SOAR stage, intent, and constraints** of each query in a multi‑stage data pipeline.

The goal is to:
- Enforce **clear SOAR boundaries** (e.g., no early-stage expansion)
- Improve **auditability and maintainability**
- Enable **safe scaling** of datasets
- Avoid breaking existing pipelines or dependencies

This standard was developed for an internal SOAR playbook but is designed to be **portable and reusable** by other teams or organizations.

---

## 2. Design Principles

Annotations MUST:
- ✅ Not change query names
- ✅ Not change query outputs
- ✅ Not introduce dependencies
- ✅ Not affect refresh behavior
- ✅ Survive export/import (Excel ↔ GitHub)

Annotations SHOULD:
- Clearly state **SOAR stage**
- Declare whether **expansion is allowed**
- Document **intended consumers**
- Warn against misuse

---

## 3. Approved Annotation Methods

### 3.1 REQUIRED: Structured Header Comment Block

Every query **must** begin with a structured comment header.

#### Template
```m
/*
==============================================================================
 Query Name   : <QueryName>
 SOAR Stage   : SOAR <N> – <Stage Name>
 Load To      : <Connection Only | Loaded>
 Expansion    : <NONE | Scalar Only | Lists/Records Allowed>
 Purpose      : <What this query does>
 Dependencies : <Upstream queries/functions>
 Consumers    : <Downstream queries or outputs>
 Guardrails   : <Explicit constraints or warnings>
==============================================================================
*/
``