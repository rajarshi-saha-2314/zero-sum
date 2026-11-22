# ZeroSum

A microservices payment and double-entry ledger system where money is never lost, never created,
and never moved twice, even under retries, partial failures and heavy concurrency.

> Work in progress. The full README (architecture, Saga diagram, design decisions, test results)
> is written in the final phase.

## Prerequisites

- JDK 21 (Maven is not required: use the bundled wrapper `./mvnw` / `mvnw.cmd`)
- Docker Desktop

## Build and test

```bash
./mvnw verify            # Windows: mvnw.cmd verify
./mvnw spotless:apply    # auto-format Java sources (verify fails on formatting drift)
```

## Local infrastructure

```bash
cp .env.example .env     # then set real passwords
docker compose up -d --wait
```

| Component | Host address | Notes |
|---|---|---|
| PostgreSQL 17 | `localhost:5432` | databases `account_db`, `payment_db`, `ledger_db`, `notification_db`, one role each |
| Kafka 4 (KRaft) | `localhost:9094` | containers use `kafka:9092` |
