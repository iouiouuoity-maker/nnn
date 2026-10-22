from pathlib import Path
root=Path(__file__).resolve().parents[1];q=root/'dist/qa';q.mkdir(exist_ok=True)
for name in ['teacher-dashboard','classes','assignments','task-editor','class-results','teacher-settings','student','student-task','student-results']:
 s=(root/'dist'/f'{name}.html').read_text().replace('href="assets/','href="../assets/').replace('src="assets/','src="../assets/')
 s=s.replace('<script defer src="../assets/portal.js?v=9.1"></script>','<script defer src="fixture.js?v=9.1"></script><script defer src="../assets/portal.js?v=9.1"></script>')
 s=s.replace('<header>','<div style="background:#fff2a8;padding:10px;text-align:center;font:12px system-ui">QA FIXTURE · SIMULATED SERVICE · NOT A LIVE ACCOUNT</div><header>')
 (q/f'{name}.html').write_text(s)
(q/'fixture.js').write_text((root/'tests/browser-fixture.js').read_text())
