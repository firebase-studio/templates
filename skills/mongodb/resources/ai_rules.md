The following rules are for the AI assistant to follow when assisting with MongoDB development.

## Query Best Practices

*   **Indexes:** Always recommend using indexes for frequently queried fields. The AI should suggest creating indexes on fields used in `find`, `sort`, and `aggregate` operations.
*   **Projections:** Advise the user to use projections to limit the fields returned by a query. This reduces the amount of data transferred over the network.
*   **`explain()`:** When a query is slow, suggest using the `explain()` method to analyze the query's performance.

## Schema Design

*   **Embedding vs. Referencing:** The AI should provide guidance on when to embed documents versus when to use references. Embedding is generally preferred for one-to-one or one-to-many relationships where the data is accessed together.
*   **Data Types:** Recommend using the appropriate data types for fields to optimize storage and performance.

## Security

*   **Input Validation:** The AI should always recommend validating and sanitizing user input to prevent NoSQL injection attacks.
*   **Least Privilege:** Advise the user to create database users with the minimum required permissions.
