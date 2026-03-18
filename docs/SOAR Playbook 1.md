flowchart LR
  %% Styles
  classDef start fill:#d1fae5,stroke:#065f46,stroke-width:2px;
  classDef endNode fill:#e0f2fe,stroke:#075985,stroke-width:2px;
  classDef control fill:#fff7ed,stroke:#9a3412,stroke-dasharray: 5 3;
  classDef proc fill:#f8fafc,stroke:#334155;
  classDef table fill:#fef3c7,stroke:#92400e,stroke-width:1.5px;
  classDef note fill:#f1f5f9,stroke:#475569,stroke-dasharray: 3 3;

  S((START<br/>Refresh)):::start

  %% Inputs
  Env[(tbl_EnvelopeResults)]:::table
  Cache[(tblMxCache<br/>persisted)]:::table

  %% Controls
  Cap[/pMaxAPICalls/]:::control
  TTL[/pCacheDays/]:::control
  Delay[/pMinDelayMs/]:::control

  %% Process
  Ingest[Normalize domains<br/>Generate Domain × Command pairs]:::proc
  Lookup[Cached MXToolbox lookups<br/>Only call API on cache miss]:::proc
  Output[LeadershipView<br/>Tier signals + EvidenceSummary]:::proc

  EndLead(((END<br/>Leadership Report))):::endNode

  %% Optional evidence
  subgraph Evidence["Optional Evidence Path<br/>Enable only for investigations"]
    Ev[SOAR4_Evidence<br/>Expanded check details]:::proc
  end
  class Evidence note

  %% Flow
  S --> Env --> Ingest
  Cap -.-> Ingest

  Ingest --> Lookup
  Cache --> Lookup
  TTL -.-> Lookup
  Delay -.-> Lookup

  Lookup --> Output --> EndLead
  Lookup -.-> Ev