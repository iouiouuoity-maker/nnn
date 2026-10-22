# Optional report delivery

The website and teacher dashboard do not need this feature. Connect it later when the recipient address is known.

1. Create a Resend account and verify a sender domain you control. Provider limits and any costs depend on your account.
2. Deploy `supabase/functions/send-reports/index.ts` as the Supabase Edge Function `send-reports`. Its config uses `verify_jwt = false` because the function checks a separate bearer secret; do not remove its Authorization check.
3. In Supabase Edge Function secrets, set `RESEND_API_KEY`, `REPORT_FROM` (a verified sender address), and `REPORT_WORKER_SECRET` (a long random value). `SUPABASE_URL` and `SUPABASE_SERVICE_ROLE_KEY` are server-side Supabase function settings. Never copy those secrets into cloud-config.js or GitHub.
4. Add the recipient email in the teacher's Settings page. New submissions will queue a report for that recipient. Existing submissions are not automatically requeued.
5. Configure a server-side scheduler to POST to `https://YOUR_PROJECT.supabase.co/functions/v1/send-reports` with `Authorization: Bearer REPORT_WORKER_SECRET`. Keep the secret in the scheduler's secret store. Do not use a public browser timer. Frequency can be a few minutes or the schedule appropriate for your provider limits.
6. Submit a disposable test assignment. Check em_mail_queue status and the recipient's inbox. A provider accepting a message is not a guarantee that it reached the inbox.

The worker claims up to five jobs with a five-minute lease and uses the queue UUID as the provider idempotency key. It retries failed jobs up to five attempts, then records `failed`. Provider idempotency has finite retention; this is not an exactly-once delivery guarantee. Fix configuration before manually requeuing failed records. Changing a teacher's recipient only affects newly queued jobs.

No real provider or scheduler was configured or tested in this package.
