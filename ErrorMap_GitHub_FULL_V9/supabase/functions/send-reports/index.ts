// Optional Supabase Edge Function. All secrets stay in server environment variables.
const env = (name: string) => {
  const value = Deno.env.get(name);
  if (!value) throw new Error(`Missing server setting: ${name}`);
  return value;
};
Deno.serve(async (request: Request) => {
  if (request.method !== 'POST') return new Response('Method not allowed', {status: 405});
  const expected = Deno.env.get('REPORT_WORKER_SECRET');
  if (!expected || request.headers.get('Authorization') !== `Bearer ${expected}`) {
    return new Response('Unauthorized', {status: 401});
  }
  try {
    const url = env('SUPABASE_URL');
    const service = env('SUPABASE_SERVICE_ROLE_KEY');
    const providerKey = env('RESEND_API_KEY');
    const sender = env('REPORT_FROM');
    const db = async (path: string, init: RequestInit = {}) => {
      const response = await fetch(`${url}/rest/v1/${path}`, {
        ...init,
        headers: {apikey: service, Authorization: `Bearer ${service}`,
          'Content-Type': 'application/json', ...init.headers}
      });
      if (!response.ok) throw new Error(`Database request failed: ${response.status}`);
      const text = await response.text();
      return text ? JSON.parse(text) : null;
    };
    const jobs = await db('rpc/em_claim_mail', {method: 'POST', body: JSON.stringify({p_limit: 5})});
    let sent = 0;
    for (const job of jobs) {
      try {
        const rows = await db(`em_results?id=eq.${encodeURIComponent(job.result_id)}&select=result`);
        if (!rows?.[0]) throw new Error('Result missing');
        const r = rows[0].result;
        const text = [
          'ErrorMap — English learning report', r.title,
          `Learner: ${r.student_name}`, `Class: ${r.class_name}`,
          `Score: ${r.score}/${r.total}`, '',
          ...r.details.map((d: {prompt: string; chosen: string; expected: string; correct: boolean; explanation: string}, i: number) =>
            `${i + 1}. ${d.prompt}\nAnswer: ${d.chosen}\nExpected: ${d.expected}\n${d.correct ? 'Correct' : 'Needs review'}\n${d.explanation}\n`),
          'Writing (teacher review):', r.writing || '—'
        ].join('\n');
        const response = await fetch('https://api.resend.com/emails', {
          method: 'POST',
          headers: {Authorization: `Bearer ${providerKey}`, 'Content-Type': 'application/json',
            'Idempotency-Key': `errormap-report-${job.id}`},
          body: JSON.stringify({from: sender, to: [job.recipient], subject: `ErrorMap · ${r.class_name} · ${r.student_name}`, text})
        });
        if (!response.ok) throw new Error(`Mail provider: ${response.status}`);
        await db(`em_mail_queue?id=eq.${job.id}`, {method: 'PATCH', body: JSON.stringify({
          status: 'sent', sent_at: new Date().toISOString(), lease_until: null, last_error: ''
        })});
        sent++;
      } catch (error) {
        await db(`em_mail_queue?id=eq.${job.id}`, {method: 'PATCH', body: JSON.stringify({
          status: job.attempts >= 5 ? 'failed' : 'pending',
          last_error: error instanceof Error ? error.message : 'Delivery failed'
          // Lease is retained for five minutes to avoid an immediate retry storm.
        })});
      }
    }
    return Response.json({processed: jobs.length, sent});
  } catch {
    return new Response('Worker configuration or database request failed', {status: 500});
  }
});
