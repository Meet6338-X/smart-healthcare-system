# 🔄 State Transition Diagram

## 🎯 Appointment Lifecycle State Transitions

This diagram illustrates the state transitions for appointments in the Smart Healthcare Management System.

```mermaid
stateDiagram-v2
    [*] --> Scheduled: Appointment booked
    Scheduled --> Completed: Appointment attended
    Scheduled --> Cancelled: Appointment cancelled
    Completed --> [*]: Final state
    Cancelled --> [*]: Final state

    state Scheduled {
        [*] --> PendingConfirmation
        PendingConfirmation --> Confirmed: Patient confirms
        PendingConfirmation --> Scheduled: Auto-confirmed after 24h
        Confirmed --> [*]: Final confirmed state
    }

    state Completed {
        [*] --> Billed: Bill generated
        Billed --> Paid: Payment received
        Billed --> Partial: Partial payment received
        Paid --> [*]: Fully paid
        Partial --> Paid: Remaining payment received
        Partial --> [*]: Partially paid (final)
    }

    state Cancelled {
        [*] --> RefundInitiated: Refund requested
        RefundInitiated --> Refunded: Refund processed
        RefundInitiated --> Rejected: Refund denied
        Refunded --> [*]: Refund completed
        Rejected --> [*]: Refund rejected
    }

    %% Transition labels
    Scheduled --> Completed: Mark as attended
    Scheduled --> Cancelled: Patient/cancelled
    Completed --> Scheduled: Reopen appointment (admin)
    Cancelled --> Scheduled: Reschedule request
```

## 💰 Billing and Payment State Transitions

```mermaid
stateDiagram-v2
    [*] --> Pending: Bill generated
    Pending --> Paid: Full payment received
    Pending --> Partial: Partial payment received
    Partial --> Paid: Remaining payment received
    Paid --> [*]: Payment complete
    Partial --> [*]: Partial payment (final)

    %% Transition details
    Pending --> Paid: Payment >= bill amount
    Pending --> Partial: Payment < bill amount
    Partial --> Paid: Additional payment completes bill
```

## 🔄 Transaction State Transitions

Based on the ACID properties documentation:

```mermaid
stateDiagram-v2
    [*] --> Active: Transaction begins
    Active --> PartiallyCommitted: All operations executed
    Active --> Failed: Error detected
    PartiallyCommitted --> Committed: COMMIT successful
    PartiallyCommitted --> Failed: COMMIT failed
    Failed --> Aborted: ROLLBACK executed
    Committed --> [*]: Transaction complete
    Aborted --> [*]: Transaction rolled back

    %% Additional states for savepoints
    Active --> Active: Savepoint set
    Active --> Active: Rollback to savepoint
```

## 🏥 Medical Record State Transitions

```mermaid
stateDiagram-v2
    [*] --> Draft: Record created
    Draft --> Finalized: Doctor signs off
    Finalized --> Archived: Record moved to archive
    Archived --> [*]: Long-term storage

    %% Alternative paths
    Draft --> [*]: Discarded (invalid record)
    Finalized --> Draft: Reopened for correction
```

## 📋 State Transition Summary

| Entity             | States                                                                                                                      | Key Transitions                       |
| ------------------ | --------------------------------------------------------------------------------------------------------------------------- | ------------------------------------- |
| **Appointment**    | Scheduled, PendingConfirmation, Confirmed, Completed, Billed, Paid, Partial, Cancelled, RefundInitiated, Refunded, Rejected | Book → Confirm → Attend → Bill → Pay  |
| **Bill**           | Pending, Paid, Partial                                                                                                      | Generate → Receive Payment → Complete |
| **Transaction**    | Active, PartiallyCommitted, Failed, Committed, Aborted                                                                      | Begin → Execute → Commit/Rollback     |
| **Medical Record** | Draft, Finalized, Archived                                                                                                  | Create → Review → Archive             |

## 🔗 Integration Points

```mermaid
flowchart LR
    A[Appointment Booking] --> B[State: Scheduled]
    B --> C{Patient Action}
    C -->|Confirm| D[State: Confirmed]
    C -->|Attend| E[State: Completed]
    C -->|Cancel| F[State: Cancelled]
    E --> G[Generate Bill]
    G --> H[State: Pending]
    H --> I{Payment}
    I -->|Full| J[State: Paid]
    I -->|Partial| K[State: Partial]
    K --> L{Additional Payment}
    L -->|Completes| J
    L -->|Incomplete| K
```

> **📝 DBMS Concept:** State transitions are crucial for tracking the lifecycle of entities in a database system. They help maintain data integrity by ensuring that entities can only transition through valid states based on business rules.
