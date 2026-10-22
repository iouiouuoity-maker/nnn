# ErrorMap — complete GitHub Pages edition

English learning workspace by Assel Amanzholova, School No. 22, Grade 7.

The site is static and runs on GitHub Pages. Vercel, Node builds and a Python backend are not required. Supabase provides teacher authentication, private teacher data and server grading for class assignments. Independent learning works without Supabase.

Open `dist/SETUP.html` for the Russian setup guide. Upload the complete repository contents, including `.github`, `dist`, `tests`, `supabase` and `scripts`. Select GitHub Actions as the Pages source. The workflow deploys `dist`.

## Pages

- index.html — role entry and introduction.
- student.html — class code, student name and independent practice.
- student-task.html — saved class assignment, shuffled answers, review and submission.
- student-results.html — local receipts, answers and teacher feedback.
- workspace.html — independent learning progress.
- diagnostic.html — baseline and reserved recheck.
- error-map.html — baseline evidence and suggested rules.
- learning-path.html — lessons, four-item practice, reflection and rule checks.
- writing.html — writing draft and limited pattern detection.
- library.html — all 240 questions, search, filters and explanations.
- about.html — method, classroom thresholds and limitations.
- teacher-login.html — real Supabase email/password sign-in.
- teacher-dashboard.html — actual classes, open assignments and submitted work.
- classes.html — create, archive, restore and copy class links.
- assignments.html — drafts, publish, close, reopen, duplicate and copy links.
- task-editor.html — add/edit/reorder questions, import/export JSON, dedicated practice bank, preview, local draft recovery, save to account.
- class-results.html — filters, CSV, individual answers, writing review, feedback and latest-rule evidence.
- teacher-settings.html — display name, optional report recipient, mail queue and backup export.

The older teacher.html and classroom/ entry paths redirect to the new flow.

## Learning content

240 items; 24 rules; six skill groups. Each rule has three matched A/B assessment pairs and four dedicated practice items. The independent learning engine is retained: baseline → targeted practice → reflection → rule check → reserved recheck. A/B topic and difficulty alignment is not statistical equating. The app does not claim validated mastery or measured classroom effectiveness.

Class assignments and independent practice are distinct stores. Independent practice and learner codes stay in the browser. Only class assignments submitted through student-task.html go to the teacher's database. Teachers can link from a submitted error to its independent rule lesson.

## Cloud setup

1. Create a new Supabase project. Execute supabase/schema.sql once.
2. Disable open new-user signups if this is a single-school teacher portal. Create teacher accounts explicitly in Authentication → Users. Use confirmed email accounts.
3. Execute the allowlist SQL in supabase/approve_teacher.sql with the teacher email substituted.
4. Set public URL and publishable key in dist/assets/cloud-config.js. Never put service-role keys or passwords in the repository.
5. Publish GitHub Pages. The teacher signs in, creates a class, creates an assignment, publishes it and shares its link/code.
6. In another browser profile, enter a learner name and complete the assignment. Verify the result, correct answers and teacher feedback. Verify that a different teacher cannot read these records before classroom use.

## Optional email

A recipient can be added later. Setting the address queues subsequent results; it does not by itself send email or queue old results retroactively. Deploy the optional `send-reports` Supabase Edge Function, configure its server secrets, and schedule authenticated POST invocations. See supabase/MAIL_SETUP.md. No email provider or delivery was connected during development.

## Checks

Run `node tests/check.cjs` `node tests/portal_test.cjs` and `node tests/cloud_test.cjs`. The first exercises content, learning-cycle accounting, recheck reservation, persistence, profiles, localisation and local links. The second checks portal validation, output escaping, CSV safety, latest-rule aggregation and SQL access-control contracts. SQL contracts are source checks, not a live Postgres security audit.

Manual UI QA used the separate test adapter in tests/browser-fixture.js, never a production login bypass. `python3 scripts/qa_fixture.py` creates temporary dist/qa pages. Delete dist/qa before packaging/deployment; the workflow rejects them. Tested: editor bank selection, reordering, recovery, saving, publication, learner answers/review/submission, teacher result display/review and student receipt rendering. The database, actual Supabase authentication, Postgres RLS and email delivery still require live integration verification.

## Local preview on Mac

Use `python3 -m http.server 8000 --directory dist`, then open http://localhost:8000. Run through a server so storage has one origin. Teacher functions still require cloud settings.

## Limits

Learners self-report their names and have no account. A new device or new attempt can create another submission. Duplicate names can represent different learners. Local receipts and drafts may be visible to others using the same browser profile. Published class questions are fixed; duplicate an assignment to revise them. Teacher backups are downloadable JSON exports, not automatic database backups or one-click restores. Interface languages are EN/ҚАЗ/РУС; English exercise sentences remain English. Class option shuffling is for presentation, not exam security.
