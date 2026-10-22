# Verification record

- PASS node tests/check.cjs — retained independent learning cycle, content, state and localisation tests.
- PASS node tests/portal_test.cjs — question contracts, escaping, CSV, latest-rule aggregation, portal files and SQL source contracts.
- PASS node tests/cloud_test.cjs — mocked teacher allowlist, session refresh, logout and anonymous RPC boundary.
- PASS recursive HTML file links.
- Manual browser QA with a clearly labelled, isolated simulated service: recover and save a draft, bank import, reorder questions, publish an assignment, student option selection, review, writing, submission, displayed 1/2 result, teacher feedback and learner feedback refresh.
- Manual production-page QA: homepage role links, student entry, teacher entry and EN/KK/RU selection.
- Dist/qa is removed from the release. Production pages do not load the test adapter.
- NOT VERIFIED: live Supabase authentication, PostgreSQL execution, RLS across actual teacher accounts, real cloud submissions, GitHub workflow execution, mail provider or scheduler.
- No real classroom effectiveness or validated mastery claim is made.
