# ErrorMap — полный исходный код

18 основных страниц. GitHub Pages + Supabase. Vercel не требуется.

Сначала прочитай START_HERE.md и dist/SETUP.html. Публичные настройки базы пустые: подключение реального проекта ещё необходимо.

Код ниже приведён полностью по файлам. Каждый блок нужно сохранять в файл с указанным путём. Все 240 вопросов и переводы включены.

## .github/workflows/pages.yml

````yaml
name: Publish ErrorMap
on:
  push:
    branches: [main]
  workflow_dispatch:
permissions:
  contents: read
  pages: write
  id-token: write
concurrency:
  group: pages
  cancel-in-progress: true
jobs:
  deploy:
    runs-on: ubuntu-latest
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    steps:
      - uses: actions/checkout@v7.0.1
      - name: Check learning cycle
        run: node tests/check.cjs
      - name: Check portal contracts
        run: node tests/portal_test.cjs
      - name: Check cloud transport
        run: node tests/cloud_test.cjs
      - name: Reject test fixtures
        run: test ! -d dist/qa
      - uses: actions/configure-pages@v6.0.0
      - uses: actions/upload-pages-artifact@v5.0.0
        with:
          path: dist
      - name: Deploy
        id: deployment
        uses: actions/deploy-pages@v5.0.1

````

## .gitignore

````text
dist/qa/
__pycache__/
.env
.openai/
.DS_Store

````

## README.md

````markdown
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

````

## START_HERE.md

````markdown
# Начни здесь

1. Распакуй архив. В GitHub загружай содержимое папки, а не сам ZIP.
2. Не смешивай этот проект с прежней Python/Vercel-версией. В этой версии сайт публикуется из dist.
3. Открой dist/SETUP.html: там инструкция с последовательностью подключения.
4. Для настоящего входа учителя и общих результатов нужно создать Supabase-проект и заполнить dist/assets/cloud-config.js. Публичные настройки сейчас пустые.
5. Пароль учителя не хранится в коде. Он задаётся при создании пользователя в Supabase.
6. Для локального просмотра на Mac: python3 -m http.server 8000 --directory dist, затем http://localhost:8000.

В проекте 18 основных страниц, 240 вопросов, 24 правила, 3 языка. Полный исходный код также собран в SOURCE_CODE.md.

Проверено локально: логика самостоятельного обучения, интерфейсы и путь задания с тестовым адаптером. Реальное облако, SQL-политики и письма ещё требуют проверки после подключения.

````

## VERIFICATION.md

````markdown
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

````

## dist/.nojekyll

````text

````

## dist/SETUP.html

````html
<!doctype html><html lang="ru"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Подключение — ErrorMap</title><link rel="icon" href="assets/favicon.svg"><link rel="stylesheet" href="assets/portal.css?v=9.1"></head><body><header><a class="brand" href="index.html">Error<span>Map</span></a><a href="teacher-login.html" class="button secondary">Вход учителя</a></header><main class="student"><span class="eyebrow">GITHUB PAGES · БЕЗ VERCEL</span><h1>Подключение кабинета</h1><section class="card"><h2>1. Загрузить весь проект в GitHub</h2><p>В корне репозитория должны быть папки <code>dist</code>, <code>tests</code>, <code>supabase</code>, <code>scripts</code> и <code>.github</code>. Не загружай весь архив одним ZIP-файлом: сначала распакуй его на Mac.</p><p>В Settings → Pages выбери Source → GitHub Actions. Проект использует workflow «Publish ErrorMap».</p></section><section class="card"><h2>2. Создать базу</h2><p>Создай новый проект Supabase. В SQL Editor вставь весь код из <code>supabase/schema.sql</code> и выполни один раз. Это новая схема для данной версии. Старые SQL-фрагменты из переписки повторно выполнять не нужно.</p></section><section class="card"><h2>3. Создать аккаунт учителя</h2><p>В Authentication → Users создай пользователя с подтверждённой почтой и собственным паролем. Email будет логином. Пароль вводи только в Supabase и на своём сайте.</p><p>Для закрытого школьного кабинета отключи свободную регистрацию новых пользователей. Затем выполни <code>supabase/approve_teacher.sql</code>, заменив адрес в кавычках на почту созданного учителя. Одной регистрации без этого разрешения недостаточно.</p></section><section class="card"><h2>4. Соединить сайт с базой</h2><p>В файле <code>dist/assets/cloud-config.js</code> укажи URL своего Supabase-проекта и его Publishable key:</p><pre style="white-space:pre-wrap"><code>window.ERRORMAP_CLOUD = {
  url: "https://YOUR_PROJECT.supabase.co",
  publishableKey: "YOUR_PUBLISHABLE_KEY"
};</code></pre><p>Это публичные настройки. Пароль учителя, secret key и service-role key в GitHub не вставляются.</p><p>Сохрани изменение через Commit changes. Дождись успешного workflow Publish ErrorMap.</p></section><section class="card"><h2>5. Проверить кабинет</h2><p>Открой сайт → Учитель. Войди с созданным email и паролем. Создай класс, затем задание. Добавь вопросы из банка или свои, сохрани черновик и нажми «Опубликовать».</p><p>Скопируй ссылку задания. Открой её в другом браузере, введи тестовое имя и выполни задание. В кабинете учителя проверь результат и оставь комментарий. Вернись к результату ученика и обнови страницу — комментарий должен появиться.</p></section><section class="card"><h2>6. Почта — позже</h2><p>Получателя можно указать в настройках кабинета позже. Для автоматической отправки также нужен почтовый обработчик из <code>supabase/functions/send-reports</code>. Его отдельная инструкция — <code>supabase/MAIL_SETUP.md</code>. Само заполнение почты не включает отправку.</p></section><section class="card"><h2>Что работает без подключения</h2><p>Банк из 240 вопросов, начальный тест, карта ошибок, уроки, практика, рефлексия, проверка правила, повторный тест и письменная работа работают в браузере. Они сохраняются на этом устройстве. Кабинет, общие задания и облачные результаты требуют шагов 2–4.</p><p>В этой сборке интерфейсы проверены на локальном тестовом сервисе. Твою настоящую базу, права доступа и доставку писем ещё нужно проверить после подключения.</p></section><a href="student.html" class="button">Страница ученика ↗</a></main><footer>Assel Amanzholova · School No. 22 · ErrorMap</footer></body></html>
````

## dist/about.html

````html
<!doctype html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><meta name="description" content="ErrorMap: a clear English learning plan. Check 24 rules, practise specific gaps and recheck on new examples."><meta name="theme-color" content="#4b52d4"><title>About — ErrorMap</title><link rel="icon" href="assets/favicon.svg" type="image/svg+xml"><link rel="stylesheet" href="assets/design.css"><link rel="stylesheet" href="assets/lab-workspace.css?v=8.1"></head><body data-page="about"><a class="skip" href="#app">Skip to content</a><aside><a class="brand" href="index.html" aria-label="ErrorMap workspace"><span class="mark" aria-hidden="true">e<span>↗</span></span>ErrorMap<span class="dot" aria-hidden="true">.</span></a><nav aria-label="Main navigation"><a data-page="home" href="index.html">Workspace</a><a data-page="diagnostic" href="diagnostic.html">Check</a><a data-page="map" href="error-map.html">Error map</a><a data-page="route" href="learning-path.html">Learning plan</a><a data-page="studio" href="writing.html">Writing</a><a data-page="bank" href="library.html">Library</a><a data-page="teacher" href="teacher-login.html">Teacher</a><a data-page="about" href="about.html" aria-current="page">About</a></nav></aside><div class="shell"><header><span id="crumb">About</span><div><label class="language-picker"><span class="sr-only">Language</span><select id="languageSelect" class="language-select" aria-label="Interface language" onchange="changeLanguage(this.value)"><option value="en">English</option><option value="kk">Қазақша</option><option value="ru">Русский</option></select></label><span id="saveStatus" class="status" role="status">Local workspace</span><button class="light" id="profileBtn" aria-haspopup="dialog">Learner: <b id="profileCode">LEARNER-01</b></button></div></header><div id="storageWarning" class="storage-warning" role="alert" hidden>Changes are not saved. <button class="light small" onclick="exportBackup()">Download recovery backup</button></div><main id="app" tabindex="-1"></main><footer><div><b>ErrorMap.</b><br>Assel Amanzholova · School No. 22</div><a href="about.html">How it works →</a></footer></div><dialog id="profileDialog" aria-labelledby="profileTitle"><form method="dialog"><h2 id="profileTitle">Learner profile</h2><p>Select a saved code or create a new one. Each learner keeps separate results and unfinished work.</p><label for="codeInput">Learner code<input id="codeInput" list="profileList" maxlength="24" placeholder="Example: LEARNER-02" autocomplete="off"></label><datalist id="profileList"></datalist><small>Use a code, not a real name. Letters, numbers, hyphens and underscores only.</small><div class="row"><button value="cancel" class="light">Cancel</button><button id="saveCode" value="save">Open profile</button></div></form></dialog><div id="toast" role="status" aria-live="polite"></div><script src="assets/question-bank.js"></script><script src="assets/i18n.js"></script><script src="assets/app.js"></script></body></html>
````

## dist/assets/app.js

````javascript
'use strict';
const CONTENT=window.ERRORMAP_CONTENT;
const BANK=CONTENT.questions, UNITS=CONTENT.units;
const GROUPS=[
{id:'agr',name:'Verb agreement',code:'G1',color:'#5f63d8'},
{id:'tense',name:'Verb tenses',code:'G2',color:'#238974'},
{id:'vocab',name:'Words & phrases',code:'L',color:'#b37b42'},
{id:'prep',name:'Prepositions',code:'P',color:'#9562b4'},
{id:'order',name:'Word order',code:'W',color:'#bd6d57'},
{id:'spell',name:'Spelling',code:'S',color:'#3980ab'}];
const FILES={home:'workspace.html',diagnostic:'diagnostic.html',map:'error-map.html',route:'learning-path.html',studio:'writing.html',bank:'library.html',teacher:'teacher.html',about:'about.html'};
const KEY='errormap-v4';
const PAGE_TITLE=document.title||'ErrorMap';
const ask=message=>confirm(I18N.t(message));
const $=s=>document.querySelector(s);
const escapeHTML=v=>String(v??'').replace(/[&<>"']/g,c=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]));
const E=escapeHTML;
const uid=()=>Date.now().toString(36)+'-'+Math.random().toString(36).slice(2,9);
const now=()=>new Date().toISOString();
const group=id=>GROUPS.find(g=>g.id===id);
const unit=id=>UNITS.find(u=>u.id===id);
const question=id=>BANK.find(q=>q.id===id);
const freshLearner=code=>({code,cycles:[],activeCycleId:null,assessment:null,practice:null,practiceHistory:[],checkpoints:[],writingDraft:'',writingHistory:[],legacy:null});
let loadWarning='';
let state;
try{state=JSON.parse(localStorage.getItem(KEY))}catch{}
if(!validState(state)){
 let broken;try{broken=localStorage.getItem(KEY)}catch{}if(broken){try{localStorage.setItem(KEY+'-recovery',broken)}catch{}loadWarning='Saved data could not be opened. A recovery copy was kept on this device.'}
 state={version:4,revision:0,active:'LEARNER-01',learners:{'LEARNER-01':freshLearner('LEARNER-01')}};
 try{const old=JSON.parse(localStorage.getItem('errormap-v2'));if(old?.profiles){for(const [i,[oldCode,record]] of Object.entries(old.profiles).entries()){const code=/^[A-Za-z0-9_-]{2,24}$/.test(oldCode)?oldCode.toUpperCase():'IMPORTED-'+(i+1);state.learners[code]={...freshLearner(code),legacy:record};if(oldCode===old.active)state.active=code}if(state.active!=='LEARNER-01')delete state.learners['LEARNER-01']}}catch{}
}
let learner=state.learners[state.active];
try{const guestText=sessionStorage.getItem('errormap-guest-text');if(guestText&&document.body.dataset.page==='studio'){if(!learner.writingDraft){learner.writingDraft=guestText;sessionStorage.removeItem('errormap-guest-text')}}}catch{}
let bankFilters={group:'all',level:'all',use:'practice',query:'',page:0};
let routeFilter='assigned';
let writingFindings=[],writingCheckedText=null;
let toastTimer;
function toast(text){$('#toast').textContent=I18N.t(text);$('#toast').classList.add('show');clearTimeout(toastTimer);toastTimer=setTimeout(()=>$('#toast').classList.remove('show'),5000)}
function save(){try{state.revision++;localStorage.setItem(KEY,JSON.stringify(state));$('#saveStatus').textContent=I18N.t('Saved on this device');$('#storageWarning').hidden=true;return true}catch{$('#saveStatus').textContent=I18N.t('Not saved');$('#storageWarning').hidden=false;toast('Storage is unavailable or full. Download a backup before leaving this page.');return false}}
function topOfPage(){window.scrollTo({top:0,behavior:'instant'})}
function go(page,params=''){location.href=(FILES[page]||FILES.home)+params}
function date(v){return new Date(v).toLocaleDateString(I18N.language==='en'?'en-GB':I18N.language==='kk'?'kk-KZ':'ru-RU',{day:'numeric',month:I18N.language==='en'?'short':'2-digit',year:'numeric'})}
function shuffle(list){const a=list.slice();for(let i=a.length-1;i>0;i--){const j=Math.floor(Math.random()*(i+1));[a[i],a[j]]=[a[j],a[i]]}return a}
function item(q){return {id:q.id,order:shuffle([0,1,2]),choice:null}}
function optionText(i,position){return question(i.id).options[i.order[position]]}
function isCorrect(i){return i.choice!==null&&i.order[i.choice]===question(i.id).answer}
function cycle(){return learner.cycles.find(c=>c.id===learner.activeCycleId)||null}
function targets(c=cycle()){if(!c)return[];return [...new Set([...c.baseline.answers.filter(a=>!a.correct).map(a=>a.unit),...c.teacherTargets])];}
function records(id,c=cycle()){return c?learner.practiceHistory.filter(r=>r.unit===id&&r.cycleId===c.id):[]}
function checkpoints(id,c=cycle()){return c?learner.checkpoints.filter(r=>r.unit===id&&r.cycleId===c.id):[]}
function status(id,c=cycle()){
 if(!c||!targets(c).includes(id))return {key:'optional',label:'Optional practice'};
 const checks=checkpoints(id,c),check=checks.at(-1),practice=records(id,c).at(-1);
 if(check?.correct===2)return {key:'verified',label:check.repeated?'Rule check complete · reused examples':'Rule check complete'};
 if(practice?.qualified&&(!check||practice.createdAt>check.createdAt))return {key:'ready',label:'Ready for a rule check'};
 if(practice||check)return {key:'review',label:'Review again'};
 return {key:'assigned',label:'Needs practice'};
}
function readiness(c=cycle()){const ids=targets(c);return !!c&&ids.every(id=>status(id,c).key==='verified')}
function nextStep(){
 const a=learner.assessment;
 if(a)return {page:a.type==='checkpoint'?'route':'diagnostic',label:'Resume '+(a.type==='baseline'?'baseline':a.type==='recheck'?'recheck':'rule check'),detail:'Your answers are saved.'};
 if(learner.practice)return {page:'route',label:'Resume practice',detail:unit(learner.practice.unit).title};
 const c=cycle();if(!c)return {page:'diagnostic',label:'Start your baseline',detail:'24 questions · about 15 minutes'};
 if(c.recheck)return {page:'map',label:'View your progress',detail:'Your baseline and recheck are ready to compare.'};
 if(readiness(c))return {page:'diagnostic',label:'Take your recheck',detail:'24 matched questions with different examples.'};
 const id=targets(c).find(id=>status(id,c).key==='ready');
 return {page:'route',label:id?'Check your next rule':'Open your learning plan',detail:id?unit(id).title:targets(c).filter(id=>status(id,c).key!=='verified').length+' rules to work on'};
}
function intro(title,text=''){return `<div class="page-intro"><h1>${title}</h1>${text?`<p>${text}</p>`:''}</div>`}
function badge(u){const g=group(u.skill);return `<span class="skill-code" style="--skill:${g.color}">${g.code}</span>`}
function tag(id){const s=status(id);return `<span class="level ${s.key}">${s.label}</span>`}
function info(title,text){return `<details class="help-note"><summary>${title}</summary><p>${text}</p></details>`}
function empty(title,text,button='Start baseline',page='diagnostic'){return `<section class="panel empty"><span class="empty-symbol">↗</span><h2>${title}</h2><p>${text}</p><button onclick="go('${page}')">${button} →</button></section>`}
function groupScore(result,id){const a=(result?.answers||[]).filter(a=>a.skill===id);return {right:a.filter(a=>a.correct).length,total:a.length}}
function home(){const c=cycle(),n=nextStep(),assigned=targets(c),done=assigned.filter(id=>status(id,c).key==='verified').length;return `<section class="hero"><div class="hero-copy"><span class="eyebrow">ENGLISH · GRADE 7</span><h1>Find the gap.<br><span>Know your next step.</span></h1><p>Check your English. Practise the rules you need. Test them again on new examples.</p><div class="row"><button onclick="go('${n.page}')">${n.label} ↗</button><a class="button light" href="library.html">Explore practice</a></div><div class="hero-meta"><span>24 rules</span><span>240 questions</span></div></div><div class="hero-visual" aria-label="Third-person verb example"><div class="paper-card"><div class="sample-sentence">She <del>go</del><br><strong>goes</strong> to school.</div><div class="paper-bottom"><span class="mini-code">G1</span><p>One person.<br>Add -s or -es.</p></div></div><div class="orbit-ring" aria-hidden="true"></div><div class="visual-dots" aria-hidden="true"></div></div></section><div class="section-head"><h2>Your workspace</h2><span class="muted">${E(state.active)}</span></div><div class="desk-grid"><section class="panel progress-panel"><span class="tag">BASELINE</span><div class="score">${c?c.baseline.correct:'—'}<small> / 24</small></div><p>${c?date(c.baseline.createdAt):'Start with one question for each rule.'}</p><a class="text-link" href="${c?'error-map.html':'diagnostic.html'}">${c?'View your error map':'Start baseline'} →</a></section><section class="panel focus-panel"><span class="tag">NEXT STEP</span><h3>${n.label}</h3><p>${E(n.detail)}</p>${c?`<div class="mini-progress"><span style="width:${assigned.length?done/assigned.length*100:100}%"></span></div><small>${done} / ${assigned.length} assigned rules checked</small>`:''}<a class="text-link" href="${FILES[n.page]}">Continue →</a></section><a class="writing-card" href="writing.html"><div class="writing-lines">Your words.<br><em>Your next draft.</em></div><p>Write and revise</p><span class="round-arrow">↗</span></a></div><div class="section-head"><h2>Six skill areas</h2><span class="muted">Four rules in each area</span></div><div class="skill-grid">${GROUPS.map(g=>`<a class="skill-tile" href="library.html?group=${g.id}"><span class="skill-code" style="--skill:${g.color}">${g.code}</span><div><h3>${g.name}</h3><p>40 questions</p></div><span>↗</span></a>`).join('')}</div>`}
function diagnostic(){const a=learner.assessment;if(a&&a.type!=='checkpoint')return assessmentView();const c=cycle(),ready=readiness(c),remaining=targets(c).filter(id=>status(id,c).key!=='verified').length;return intro('Check your English','Baseline → targeted practice → rule checks → recheck')+`${learner.practice?'<div class="notice">A lesson is saved. <a href="learning-path.html">Resume it</a> before starting a new assessment.</div>':''}${a?.type==='checkpoint'?`<div class="notice">A rule check is in progress. <a href="learning-path.html">Resume it</a> before starting another assessment.</div>`:''}<div class="diagnostic-grid"><section class="test-card"><span class="test-letter">A</span><span class="tag">BASELINE</span><h2>Start with what you know.</h2><p>24 questions. One question for each rule. Answers stay hidden until you submit.</p><div class="test-meta"><span>About 15 minutes</span><span>Autosaved</span></div>${c?`<div class="test-complete"><b>${c.baseline.correct} / 24</b><span>Completed ${date(c.baseline.createdAt)}</span></div><a class="button light" href="error-map.html">View baseline →</a>`:`<button onclick="startBaseline()" ${a?'disabled':''}>Start baseline →</button>`}</section><section class="test-card secondary"><span class="test-letter">B</span><span class="tag">RECHECK</span><h2>Use the rule in a new sentence.</h2><p>The recheck follows your baseline topics and difficulty, using different questions.</p>${!c?'<p class="gate-message">Complete your baseline first.</p>':c.recheck?`<div class="test-complete"><b>${c.recheck.correct} / 24</b><span>Completed ${date(c.recheck.createdAt)}</span></div><a class="button light" href="error-map.html">Compare results →</a>`:ready?`<p class="gate-message success">${targets(c).length?'All assigned rules have been checked.':'No rules were flagged in your baseline.'}</p><button onclick="startRecheck()">Start recheck →</button>`:`<p class="gate-message">${remaining} assigned ${remaining===1?'rule needs':'rules need'} a successful rule check.</p><a class="button light" href="learning-path.html">Continue your plan →</a>`}</section></div>${info('What can these results tell me?','One baseline answer is a starting signal, not proof of a gap or mastery. Your practice and independent rule checks add evidence. Paired questions cover the same rule and difficulty band, but the tests have not been statistically equated.')} ${c?.recheck?`<section class="panel restart-card"><div><h3>Start another learning cycle</h3><p>Keep this cycle in your history and use a fresh baseline.</p></div><button class="light" onclick="newCycle()">New cycle</button></section>`:''}`}
function baselineQuestions(){return UNITS.map((u,index)=>{const used=learner.cycles.map(c=>c.baseline.answers.find(a=>a.unit===u.id)?.pair);const available=shuffle([0,1,2]).sort((a,b)=>used.filter(x=>x===a).length-used.filter(x=>x===b).length);const pair=learner.cycles.length?available[0]:index%3;return item(BANK.find(q=>q.unit===u.id&&q.form==='A'&&q.pair===pair))})}
function seenAssessmentIds(){return new Set([...learner.cycles.flatMap(c=>[...c.baseline.answers,...(c.recheck?.answers||[])].map(a=>a.id)),...learner.checkpoints.flatMap(r=>r.answers.map(a=>a.id))])}
function startAssessment(type,items,unitId=null){if(learner.assessment){toast('Resume or discard your current assessment first.');return false}const seen=seenAssessmentIds();items=items.map(i=>({...i,seenBefore:seen.has(i.id)}));learner.assessment={id:uid(),type,unit:unitId,cycleId:cycle()?.id||null,items,index:0,startedAt:now()};save();return true}
window.startBaseline=()=>{if(learner.practice){toast('Finish or discard your saved lesson before starting a baseline.');return}if(cycle()){toast('Your current cycle already has a baseline.');return}if(startAssessment('baseline',baselineQuestions()))render()};
window.startRecheck=()=>{const c=cycle();if(!c||c.recheck||!readiness(c)){toast('Finish the assigned rule checks first.');return}if(learner.practice){toast('Finish or discard your saved practice first.');return}const items=c.baseline.answers.map(a=>item(BANK.find(q=>q.unit===a.unit&&q.form==='B'&&q.pair===a.pair)));if(startAssessment('recheck',items))render()};
window.newCycle=()=>{if(!cycle()?.recheck){toast('Complete this cycle before starting another one.');return}if(ask('Start a new cycle? Previous results will stay. Any unfinished optional lesson will be discarded.')){learner.activeCycleId=null;learner.assessment=null;learner.practice=null;save();render()}};
function assessmentLabel(a){return a.type==='baseline'?'Baseline':a.type==='recheck'?'Recheck':'Rule check'}
function assessmentView(){const a=learner.assessment,N=a.items.length,label=assessmentLabel(a);if(a.index===N)return intro('Review your answers',label+' · '+N+' questions')+`<section class="panel assessment-review"><p>You can change an answer before submitting. Correct answers are still hidden.</p><div class="answer-index">${a.items.map((i,n)=>`<button class="light ${i.choice===null?'unanswered':''}" onclick="editAnswer(${n})">${n+1}<small>${i.choice===null?'Not answered':String.fromCharCode(65+i.choice)}</small></button>`).join('')}</div><div class="row"><button onclick="submitAssessment()" ${a.items.some(i=>i.choice===null)?'disabled':''}>Submit ${label.toLowerCase()}</button><button class="light" onclick="saveAssessmentExit()">Save & exit</button></div></section>`;const i=a.items[a.index],q=question(i.id);return intro(label,a.items.some(i=>i.seenBefore)?'Some examples appeared in earlier attempts. This is recorded with the result.':'Choose one answer. You can review before submitting.')+`<section class="panel question"><div class="row spread"><span class="row">${badge(unit(q.unit))}<span>${group(q.skill).name}</span></span><b>${a.index+1}<span class="muted"> / ${N}</span></b></div><div class="progress"><span style="width:${a.index/N*100}%"></span></div><h2 class="english">${E(q.prompt)}</h2><div class="answers">${i.order.map((_,pos)=>`<button class="answer ${i.choice===pos?'selected':''}" aria-pressed="${i.choice===pos}" onclick="chooseAnswer(${pos})"><em>${String.fromCharCode(65+pos)}</em>${E(optionText(i,pos))}</button>`).join('')}</div><div class="row spread"><button class="light" onclick="assessmentBack()" ${a.index===0?'disabled':''}>← Back</button><button onclick="assessmentNext()" ${i.choice===null?'disabled':''}>${a.index===N-1?'Review answers':'Next →'}</button></div><div class="assessment-bottom"><button class="text-button" onclick="saveAssessmentExit()">Save & exit</button><button class="text-button" onclick="discardAssessment()">Discard attempt</button></div></section>`}
window.chooseAnswer=pos=>{const a=learner.assessment;if(!a||![0,1,2].includes(pos)||a.index>=a.items.length)return;a.items[a.index].choice=pos;save();render()};
window.assessmentBack=()=>{const a=learner.assessment;if(a)a.index=Math.max(0,a.index-1);save();render()};
window.assessmentNext=()=>{const a=learner.assessment;if(!a||!a.items[a.index]||a.items[a.index].choice===null)return;a.index++;save();render();topOfPage()};
window.editAnswer=n=>{const a=learner.assessment;if(a&&n>=0&&n<a.items.length){a.index=n;save();render()}};
window.saveAssessmentExit=()=>{const a=learner.assessment;if(save())go(a?.type==='checkpoint'?'route':'home')};
window.discardAssessment=()=>{if(ask('Discard this unfinished attempt? Completed results will stay.')){learner.assessment=null;save();render()}};
function resultFrom(a){return {createdAt:now(),repeated:a.items.filter(i=>i.seenBefore).length,answers:a.items.map(i=>{const q=question(i.id);return {id:q.id,unit:q.unit,skill:q.skill,pair:q.pair,level:q.level,selected:optionText(i,i.choice),seenBefore:!!i.seenBefore,correct:isCorrect(i)}}),correct:a.items.filter(isCorrect).length}}
window.submitAssessment=()=>{const a=learner.assessment;if(!a||a.index!==a.items.length||a.items.some(i=>i.choice===null))return;const r=resultFrom(a);if(a.type==='baseline'){if(cycle()){toast('A baseline already exists for this cycle.');return}const c={id:uid(),createdAt:now(),baseline:r,recheck:null,teacherTargets:[],teacherNote:''};learner.cycles.push(c);learner.activeCycleId=c.id}else if(a.type==='recheck'){const c=cycle();if(!c||c.id!==a.cycleId||c.recheck)return;c.recheck=r}else{if(cycle()?.id!==a.cycleId)return;learner.checkpoints.push({...r,unit:a.unit,cycleId:a.cycleId})}learner.assessment=null;if(save())go(a.type==='checkpoint'?'route':'map');else render()};
function mapPage(){const c=cycle();if(!c)return intro('Error map')+empty('No baseline yet','Complete your baseline to build a plan.');const a=c.baseline,b=c.recheck;return intro(b?'Your progress':'Your error map',b?'Compare the same rules using different examples.':'Missed answers become practice suggestions, not permanent labels.')+`<div class="result-banner"><div><small>BASELINE</small><b>${a.correct}<span> / 24</span></b><p>${date(a.createdAt)}</p></div>${b?`<div><small>RECHECK</small><b>${b.correct}<span> / 24</span></b><p>${date(b.createdAt)}</p></div><div><small>CHANGE</small><b>${b.correct-a.correct>0?'+':''}${b.correct-a.correct}<span> ${Math.abs(b.correct-a.correct)===1?'answer':'answers'}</span></b><p>${b.repeated?b.repeated+' examples seen before':'Same topics · different examples'}</p></div>`:`<div><small>ASSIGNED RULES</small><b>${targets(c).length}</b><p>${targets(c).filter(id=>status(id,c).key==='verified').length} rule checks complete</p></div>`}<a class="button" href="${b?'teacher.html':'learning-path.html'}">${b?'View history':'Open learning plan'} ↗</a></div><div class="map-grid">${GROUPS.map(g=>{const x=groupScore(a,g.id),y=groupScore(b,g.id);return `<section class="map-card"><div class="row"><span class="skill-code" style="--skill:${g.color}">${g.code}</span><h3>${g.name}</h3></div><div class="map-comparison"><span>Baseline <b>${x.right} / ${x.total}</b></span>${b?`<span>Recheck <b>${y.right} / ${y.total}</b></span>`:''}</div><div class="mini-progress"><span style="width:${(b?y.right:x.right)/4*100}%;background:${g.color}"></span></div></section>`}).join('')}</div><div class="section-head"><h2>${b?'Rule-by-rule comparison':'Answers and next steps'}</h2></div><div class="review-list">${a.answers.map((r,n)=>{const q=question(r.id),u=unit(r.unit),after=b?.answers.find(x=>x.unit===r.unit);return `<details class="review-item"><summary><span class="review-status ${r.correct?'yes':'no'}">${r.correct?'✓':'!'}</span><span><b>${u.title}</b><small>${b?(r.correct?'Correct':'Missed')+' → '+(after.correct?'Correct':'Missed'):r.correct?'Not flagged in baseline':status(u.id).label}</small></span><span>＋</span></summary><div class="review-body"><p class="english">${E(q.prompt)}</p><p>Your answer: <b>${E(r.selected)}</b><br>Expected: <b>${E(q.options[q.answer])}</b></p><div class="feedback">${E(q.explanation)}</div>${after?`<p class="english">${E(question(after.id).prompt)}</p><p>Recheck answer: <b>${E(after.selected)}</b> · ${after.correct?'Correct':'Needs another look'}</p><div class="feedback">${E(question(after.id).explanation)}</div>`:''}<button class="light small" onclick="openUnit('${u.id}')">Practise this rule →</button></div></details>`}).join('')}</div>${info('How is the plan chosen?','A missed baseline answer flags its specific rule. Four dedicated practice questions are followed by a two-question independent rule check. A clean rule check adds evidence of improvement; it does not prove long-term mastery. Correct baseline rules remain available for optional practice.')}`}
window.openUnit=id=>{go('route','?unit='+encodeURIComponent(id))};
function route(){if(learner.assessment?.type==='checkpoint')return assessmentView();if(learner.practice)return practiceView();const c=cycle(),assigned=targets(c);return intro('Learning plan',c?'Work on one rule at a time. Practise, explain, then check it.':'Try any rule, or take a baseline for a personalised plan.')+`${learner.assessment?`<div class="notice">${assessmentLabel(learner.assessment)} in progress. <a href="diagnostic.html">Resume your assessment</a>.</div>`:''}<div class="plan-toolbar"><div class="segmented"><button class="${routeFilter==='assigned'?'active':''}" onclick="setRouteFilter('assigned')">Assigned ${assigned.length}</button><button class="${routeFilter==='all'?'active':''}" onclick="setRouteFilter('all')">All 24 rules</button></div>${c?`<span class="muted">${assigned.filter(id=>status(id,c).key==='verified').length} / ${assigned.length} checked</span>`:''}</div><div class="route-list">${UNITS.filter(u=>routeFilter==='all'||assigned.includes(u.id)).sort((a,b)=>{const rank={assigned:0,review:1,ready:2,verified:3,optional:4};return rank[status(a.id).key]-rank[status(b.id).key]}).map((u,n)=>{const s=status(u.id),last=records(u.id).at(-1);return `<section class="route-card ${s.key==='verified'?'done':''}"><div class="route-number">${String(n+1).padStart(2,'0')}</div><div><div class="row">${badge(u)}${tag(u.id)}</div><h2>${u.title}</h2><p>${group(u.skill).name} · 4 practice questions</p>${checkpointReview(u.id)}${last?`<small>Last practice: ${last.independent} / 4 independent first answers</small>`:''}</div><div class="route-actions">${s.key==='ready'?`<button onclick="startCheckpoint('${u.id}')">Check this rule ↗</button><button class="text-button" onclick="startPractice('${u.id}')">Review lesson</button>`:`<button class="${s.key==='verified'?'light':''}" onclick="startPractice('${u.id}')">${s.key==='verified'?'Practise again':s.key==='review'?'Review & retry':'Start lesson'} ↗</button>`}</div></section>`}).join('')||empty(c?'No rules assigned':'Build your plan',c?'Your baseline did not flag any rules. You can explore optional practice or take your recheck.':'Complete a baseline to see which rules to work on.',c?'Explore practice':'Start baseline',c?'bank':'diagnostic')}</div>${c&&!c.recheck?`<section class="panel plan-finish"><div><h3>Recheck your English</h3><p>${readiness(c)?'All assigned rule checks are complete.':'Finish the assigned rule checks to unlock your recheck.'}</p></div><a class="button ${readiness(c)?'':'light'}" href="diagnostic.html">${readiness(c)?'Start recheck':'View requirements'} →</a></section>`:''}`}
function checkpointReview(id){const r=checkpoints(id).at(-1);if(!r)return '';return `<details class="checkpoint-review"><summary>Last rule check: ${r.correct} / 2${r.repeated?' · repeated examples':''} · review answers</summary>${r.answers.map(a=>{const q=question(a.id);return `<div class="feedback"><b>${a.correct?'Correct':'Review'}</b><p>${E(q.prompt)}</p><p>Your answer: ${E(a.selected)}<br>Expected: ${E(q.options[q.answer])}</p><p>${E(q.explanation)}</p></div>`}).join('')}</details>`}

window.setRouteFilter=v=>{routeFilter=v;render()};
window.startPractice=id=>{if(!unit(id))return;if(learner.assessment){toast('Finish or discard the current assessment first.');return}if(learner.practice){toast('Resume or discard your saved lesson first.');return}learner.practice={id:uid(),unit:id,cycleId:cycle()?.id||null,stage:'rule',index:0,items:shuffle(BANK.filter(q=>q.unit===id&&q.use==='practice')).map(q=>({...item(q),firstChoice:null,hint:false,checked:false,corrected:false})),explanation:'',example:'',startedAt:now()};save();render();topOfPage()};
function practiceView(){const p=learner.practice,u=unit(p.unit),previous=learner.practiceHistory.some(r=>r.unit===u.id);if(p.stage==='rule')return intro(u.title,group(u.skill).name)+`<section class="panel lesson"><div class="row">${badge(u)}<span class="tag">RULE</span></div><h2>What to notice</h2><p>${u.rule}</p><div class="example">${u.example}</div>${previous?'<p class="muted">This lesson reuses the same four practice examples. The independent rule check uses different questions.</p>':''}<div class="row"><button onclick="beginPractice()">Try 4 questions →</button><button class="light" onclick="savePracticeExit()">Save & exit</button></div></section>`;
if(p.stage==='reflection'){const independent=p.items.filter(i=>i.firstChoice!==null&&i.order[i.firstChoice]===question(i.id).answer&&!i.hint).length;return intro('Explain the rule','Write in your own words. Your teacher can review these examples.')+`<section class="panel question"><div class="score">${independent}<small> / 4 independent</small></div><p>Hints and corrected answers are recorded separately.</p><label for="reflectionRule">What rule did you use?<textarea id="reflectionRule" maxlength="1000" oninput="updateReflection('explanation',this.value)" placeholder="After she, I add -s to the verb.">${E(p.explanation)}</textarea></label><label for="reflectionExample">Write a new sentence<textarea id="reflectionExample" maxlength="500" oninput="updateReflection('example',this.value)" placeholder="My sister reads every evening.">${E(p.example)}</textarea></label><p class="muted">Your writing is saved for teacher review, not automatically marked.</p><div class="row"><button onclick="finishPractice()">Save lesson</button><button class="light" onclick="savePracticeExit()">Save & exit</button></div></section>`}
const i=p.items[p.index],q=question(i.id),rightPos=i.order.indexOf(q.answer),right=isCorrect(i);return intro(u.title,'Practice '+(p.index+1)+' of 4')+`<section class="panel question"><div class="row spread">${badge(u)}<span class="tag">${['','Foundation','Developing','Stretch'][q.level]}</span></div><div class="progress"><span style="width:${p.index/4*100}%"></span></div><h2 class="english">${E(q.prompt)}</h2><div class="answers">${i.order.map((_,pos)=>`<button class="answer ${i.choice===pos?'selected':''} ${i.checked&&pos===rightPos?'right':''} ${i.checked&&i.choice===pos&&pos!==rightPos?'wrong':''}" onclick="practiceChoose(${pos})" ${i.corrected?'disabled':''}><em>${String.fromCharCode(65+pos)}</em>${E(optionText(i,pos))}</button>`).join('')}</div>${i.hint?`<div class="hint"><b>Rule reminder</b><p>${u.rule}</p><small>This answer will be marked as assisted.</small></div>`:''}${i.checked?`<div class="feedback"><b>${i.firstChoice===rightPos?'Correct on your first try.':i.corrected?'Correction complete.':'Read the explanation, then choose the correct answer.'}</b><p>${E(q.explanation)}</p></div>${i.corrected?`<button onclick="practiceNext()">${p.index===3?'Explain the rule':'Next →'}</button>`:'<button onclick="checkCorrection()">Check correction</button>'}`:`<div class="row"><button onclick="practiceCheck()" ${i.choice===null?'disabled':''}>Check answer</button><button class="light" onclick="showHint()">Show rule reminder</button></div>`}<div class="assessment-bottom"><button class="text-button" onclick="savePracticeExit()">Save & exit</button><button class="text-button" onclick="discardPractice()">Discard lesson</button></div></section>`}
window.beginPractice=()=>{if(!learner.practice)return;learner.practice.stage='questions';save();render();topOfPage()};
window.practiceChoose=pos=>{const p=learner.practice,i=p?.items[p.index];if(!i||i.corrected||![0,1,2].includes(pos))return;i.choice=pos;save();render()};
window.showHint=()=>{const p=learner.practice,i=p?.items[p.index];if(!i||i.checked)return;i.hint=true;save();render()};
window.practiceCheck=()=>{const p=learner.practice,i=p?.items[p.index];if(!i||i.checked||i.choice===null)return;i.firstChoice=i.choice;i.checked=true;i.corrected=isCorrect(i);save();render()};
window.checkCorrection=()=>{const p=learner.practice,i=p?.items[p.index];if(!i||!i.checked||i.corrected)return;if(!isCorrect(i)){toast('Compare the options with the explanation and try again.');return}i.corrected=true;save();render()};
window.practiceNext=()=>{const p=learner.practice;if(!p||!p.items[p.index]?.corrected)return;if(p.index===3)p.stage='reflection';else p.index++;save();render();topOfPage()};
window.updateReflection=(key,value)=>{if(learner.practice&&['explanation','example'].includes(key)){learner.practice[key]=value;save()}};
window.savePracticeExit=()=>{if(save())go('home')};
window.discardPractice=()=>{if(ask('Discard this unfinished lesson? Completed lessons will stay.')){learner.practice=null;save();render()}};
window.finishPractice=()=>{const p=learner.practice;if(!p||p.stage!=='reflection'||p.items.some(i=>!i.corrected))return;const explanation=p.explanation.trim(),example=p.example.trim();if(explanation.split(/\s+/).length<4||example.split(/\s+/).length<3||!/[A-Za-z]/.test(explanation)||!/[A-Za-z]/.test(example)){toast('Write a short explanation and a new sentence before saving.');return}const independent=p.items.filter(i=>i.order[i.firstChoice]===question(i.id).answer&&!i.hint).length;learner.practiceHistory.push({id:p.id,unit:p.unit,cycleId:p.cycleId,createdAt:now(),independent,firstCorrect:p.items.filter(i=>i.order[i.firstChoice]===question(i.id).answer).length,assisted:p.items.filter(i=>i.hint).length,items:p.items,explanation,example,qualified:independent>=3,reviewed:false});learner.practice=null;save();render();topOfPage();toast(independent>=3?'Lesson saved. If this rule is assigned, you can now check it on new examples.':'Lesson saved. Review the rule and retry before the independent check.')};
window.startCheckpoint=id=>{const c=cycle();if(!c||status(id,c).key!=='ready'){toast('Complete practice with at least 3 of 4 independent first answers and a new example first.');return}const reserved=c.baseline.answers.find(a=>a.unit===id)?.pair;const items=shuffle(BANK.filter(q=>q.unit===id&&q.form==='B'&&q.pair!==reserved)).map(item);if(items.length!==2)return;if(startAssessment('checkpoint',items,id))render()};
function bankView(){const f=bankFilters,filtered=BANK.filter(q=>(f.group==='all'||q.skill===f.group)&&(f.level==='all'||String(q.level)===f.level)&&(f.use==='all'||q.use===f.use)&&(!f.query||[q.prompt,...q.options,unit(q.unit).title,I18N.t(unit(q.unit).title),group(q.skill).name,I18N.t(group(q.skill).name)].join(' ').toLowerCase().includes(f.query.toLowerCase())));const pages=Math.ceil(filtered.length/12);f.page=Math.max(0,Math.min(f.page,pages-1));return intro('Question library',f.use==='practice'?'96 practice questions across 24 rules. Open a lesson to practise a complete rule.':'Teacher resource: answer keys are available here. Viewing assessment answers can affect later test results.')+`<section class="filter-bar"><label for="bankSearch">Search<input id="bankSearch" value="${E(f.query)}" placeholder="A rule or a word…" oninput="searchBank(this.value)"></label><label for="bankGroup">Skill area<select id="bankGroup" onchange="filterBank('group',this.value)"><option value="all">All skills</option>${GROUPS.map(g=>`<option value="${g.id}" ${g.id===f.group?'selected':''}>${g.name}</option>`).join('')}</select></label><label for="bankLevel">Level<select id="bankLevel" onchange="filterBank('level',this.value)">${[['all','All levels'],['1','Foundation'],['2','Developing'],['3','Stretch']].map(x=>`<option value="${x[0]}" ${x[0]===f.level?'selected':''}>${x[1]}</option>`).join('')}</select></label><label for="bankUse">Question type<select id="bankUse" onchange="filterBank('use',this.value)">${[['practice','Practice'],['diagnostic','Assessment keys'],['all','All questions']].map(x=>`<option value="${x[0]}" ${x[0]===f.use?'selected':''}>${x[1]}</option>`).join('')}</select></label></section><div class="row spread page-tools"><span class="muted">${filtered.length} questions</span><a class="text-link" href="assets/question-bank.json" download>Download content ↓</a></div><div class="bank-grid">${filtered.slice(f.page*12,(f.page+1)*12).map(q=>`<article class="bank-card"><div class="row spread">${badge(unit(q.unit))}<span class="tag">${['','Foundation','Developing','Stretch'][q.level]}</span></div><small class="bank-topic">${unit(q.unit).title}</small><h3 class="question-prompt">${E(q.prompt)}</h3><ol type="A">${q.options.map(o=>`<li>${E(o)}</li>`).join('')}</ol><details><summary>Answer & explanation</summary><div class="feedback"><b>${E(q.options[q.answer])}</b><p>${E(q.explanation)}</p></div></details><a class="text-link bank-lesson-link" href="learning-path.html?unit=${q.unit}">Open rule lesson →</a></article>`).join('')||'<section class="panel empty"><h3>No questions found</h3><p>Try another word or clear the filters.</p><button class="light" onclick="resetFilters()">Reset filters</button></section>'}</div><div class="pagination"><button class="light" onclick="bankPage(-1)" ${f.page===0?'disabled':''}>← Previous</button><span>${filtered.length?f.page+1:0} / ${pages}</span><button class="light" onclick="bankPage(1)" ${f.page>=pages-1?'disabled':''}>Next →</button></div>`}
window.filterBank=(k,v)=>{if(!['group','level','use'].includes(k))return;bankFilters[k]=v;bankFilters.page=0;render()};let searchTimer;window.searchBank=v=>{clearTimeout(searchTimer);searchTimer=setTimeout(()=>{bankFilters.query=v;bankFilters.page=0;const pos=$('#bankSearch').selectionStart;render();$('#bankSearch').focus();$('#bankSearch').setSelectionRange(pos,pos)},250)};window.resetFilters=()=>{bankFilters={group:'all',level:'all',use:'practice',query:'',page:0};render()};window.bankPage=n=>{bankFilters.page+=n;render();window.scrollTo({top:100,behavior:'smooth'})};
const WRITING_RULES=[
{unit:'third-person',rx:/\b(she|he|it)\s+(go|play|like|work|study|read|live|watch|teach)\b/gi,fix:m=>m.replace(/\b(go|play|like|work|study|read|live|watch|teach)$/i,w=>({go:'goes',study:'studies',watch:'watches',teach:'teaches'}[w.toLowerCase()]||w+'s')),why:'If this is a present-simple statement, check the third-person ending.',guard:(text,m)=>!/(?:does|did|can|will|should|would|must|may|might|to)\s+$/i.test(text.slice(Math.max(0,m.index-20),m.index))&&!/\b(yesterday|ago|last\s+(?:week|month|year|night))\b/i.test(text.slice(m.index).split(/[.!?]/)[0])},
{unit:'auxiliary-base',rx:/\bdoes\s+(?:she|he|it|your sister|your brother)\s+(goes|plays|likes|works|studies|reads|lives)\b/gi,fix:m=>m.replace(/(goes|plays|likes|works|studies|reads|lives)$/i,w=>({goes:'go',studies:'study'}[w.toLowerCase()]||w.slice(0,-1))),why:'After does, use the base form of the main verb.'},
{unit:'make-do',rx:/\bmake\s+(?:my|your|his|her|our|their|the)\s+homework\b/gi,fix:m=>m.replace(/^make/i,'do'),why:'Use the phrase do homework.'},
{unit:'take-get',rx:/\bmake\s+a\s+photo\b/gi,fix:m=>m.replace(/^make/i,'take'),why:'Use the phrase take a photo.'},
{unit:'time-prepositions',rx:/\bin\s+(Monday|Tuesday|Wednesday|Thursday|Friday|Saturday|Sunday)\b/gi,fix:m=>m.replace(/^in/i,'on'),why:'Use on with days of the week.'},
{unit:'time-prepositions',rx:/\bon\s+(\d{1,2}(?::\d{2})?\s*o[’']clock)\b/gi,fix:m=>m.replace(/^on/i,'at'),why:'Use at with a clock time.'},
{unit:'common-spelling',rx:/\b(becouse|becaus|beutiful|beautifull)\b/gi,fix:m=>({becouse:'because',becaus:'because',beutiful:'beautiful',beautifull:'beautiful'}[m.toLowerCase()]),why:'Compare the spelling with the suggested word.'},
{unit:'double-letters',rx:/\b(tommorow|tomorow|neccessary|necesary)\b/gi,fix:m=>({tommorow:'tomorrow',tomorow:'tomorrow',neccessary:'necessary',necesary:'necessary'}[m.toLowerCase()]),why:'Check the single and double letters.'},
{unit:'capital-letters',rx:/\bi\b/g,fix:()=> 'I',why:'The pronoun I is always capitalised.'},
{unit:'capital-letters',rx:/\benglish\b/g,fix:()=> 'English',why:'Language names begin with a capital letter.'}
];
function detect(text){const hits=[];for(const rule of WRITING_RULES){rule.rx.lastIndex=0;for(const match of text.matchAll(rule.rx)){if(rule.guard&&!rule.guard(text,match))continue;hits.push({unit:rule.unit,original:match[0],suggestion:rule.fix(match[0]),why:rule.why,index:match.index})}}return hits.sort((a,b)=>a.index-b.index)}
function studio(){const stale=writingCheckedText!==null&&writingCheckedText!==learner.writingDraft;return intro('Write. Notice. Revise.','Write 3–6 sentences. Use the suggestions to make your own revision.')+`<div class="writing-layout"><section class="panel editor-panel"><div class="row spread"><h2>Your draft</h2><button class="light small" onclick="fillSample()">Try an example</button></div><label for="writingText">English text<textarea id="writingText" maxlength="3000" placeholder="Write about your school, family or hobbies…" oninput="updateWriting(this.value)">${E(learner.writingDraft)}</textarea></label><div class="row"><button onclick="analyseWriting()">Check draft ↗</button><button class="light" onclick="saveWriting()">Save revision</button></div><small class="editor-note">Use a learner code, not a real name or personal details.</small></section><section class="panel findings-panel"><h2>Things to review</h2><p id="writingState" class="muted">${stale?'Draft changed. Check it again.':writingCheckedText===null?'Check your draft to see suggestions.':writingFindings.length+' suggestions — review the meaning before changing anything.'}</p><div id="writingResults">${!stale&&writingCheckedText!==null?(writingFindings.length?writingFindings.map(f=>`<article class="finding">${badge(unit(f.unit))}<p class="english"><del>${E(f.original)}</del> → <b>${E(f.suggestion)}</b></p><p>${f.why}</p><a class="text-link" href="learning-path.html?unit=${f.unit}">Review ${unit(f.unit).title.toLowerCase()} →</a></article>`).join(''):'<div class="finding-empty"><span>✎</span><h3>No covered patterns found</h3><p>This is not a full grammar check. Ask your teacher to review meaning, word order and other errors.</p></div>'):'<div class="finding-empty"><span>✎</span><p>Your suggestions will appear here.</p></div>'}</div></section></div>${info('What does the checker cover?','Ten small pattern checks look for selected verb endings, fixed phrases, prepositions, spelling and capitals. They can miss errors and suggest changes that do not fit your meaning. They do not grade your writing or change your error map. Drafts and saved revisions stay in this browser.')} ${learner.writingHistory.length?`<section class="panel reflection-log"><h2>Saved revisions</h2>${learner.writingHistory.slice().reverse().map(r=>`<details class="review-item"><summary><span>${date(r.createdAt)}</span><span>${r.text.split(/\s+/).length} words ＋</span></summary><div class="review-body"><p class="preserve-lines">${E(r.text)}</p></div></details>`).join('')}</section>`:''}`}
window.updateWriting=text=>{learner.writingDraft=text;save();if(writingCheckedText!==null&&writingCheckedText!==text){$('#writingState').textContent=I18N.t('Draft changed. Check it again.');$('#writingResults').innerHTML='<p class="muted">'+I18N.t('Previous suggestions are hidden until you check this draft.')+'</p>'}};
window.fillSample=()=>{if(learner.writingDraft.trim()&&!ask('Replace your current draft with the example? Saved revisions will stay.'))return;learner.writingDraft='She go to school every day. I make my homework in Monday. i like english becouse it is interesting.';writingCheckedText=null;writingFindings=[];save();render()};
window.analyseWriting=()=>{const text=learner.writingDraft.trim();if(!text){toast('Write a few sentences first.');return}writingCheckedText=learner.writingDraft;writingFindings=detect(writingCheckedText);render()};
window.saveWriting=()=>{const text=learner.writingDraft.trim();if(!text){toast('Write a draft first.');return}if(learner.writingHistory.at(-1)?.text===text){toast('This revision is already saved.');return}learner.writingHistory.push({id:uid(),text,createdAt:now()});save();render();toast('Revision saved for teacher review.')};
function teacher(){const c=cycle();return intro('Teacher workspace','Learner '+E(state.active)+' · local device workspace')+`<section class="teacher-stats"><div class="panel"><small>CYCLES</small><b>${learner.cycles.length}</b></div><div class="panel"><small>BASELINE</small><b>${c?c.baseline.correct+' / 24':'—'}</b></div><div class="panel"><small>RECHECK</small><b>${c?.recheck?c.recheck.correct+' / 24':'—'}</b></div><div class="panel"><small>RULES CHECKED</small><b>${targets(c).filter(id=>status(id,c).key==='verified').length} / ${targets(c).length}</b></div></section><div class="columns"><section class="panel"><h2>Assign a rule</h2><p>A teacher assignment adds practice without changing the learner’s test scores.</p><label for="assignUnit">Rule<select id="assignUnit">${UNITS.map(u=>`<option value="${u.id}">${u.title}</option>`).join('')}</select></label><button class="small" onclick="assignRule()" ${!c||c.recheck?'disabled':''}>Assign practice</button><small class="editor-note">${!c?'A baseline is needed first.':c.recheck?'This cycle is complete. Start a new cycle for new assignments.':'Assignments apply to the current cycle.'}</small>${c?.teacherTargets.length?`<div class="teacher-assignments">${c.teacherTargets.map(id=>`<div><span>${unit(id).title}</span><button class="text-button" onclick="removeAssignment('${id}')" ${c.recheck?'disabled':''}>Remove assignment</button></div>`).join('')}</div>`:''}<h3 class="teacher-note-title">Teacher note</h3><label for="teacherNote">Observation (autosaved)<textarea id="teacherNote" oninput="updateTeacherNote(this.value)" maxlength="1500" ${!c?'disabled':''} placeholder="Record a misconception or a next step…">${E(c?.teacherNote||'')}</textarea></label></section><section class="panel"><h2>Cycle history</h2>${learner.cycles.slice().reverse().map(x=>`<div class="history-item"><div><b>${date(x.createdAt)}</b><small>${x.id===learner.activeCycleId?'Current cycle':'Previous cycle'}</small></div><div><strong>${x.baseline.correct} / 24 → ${x.recheck?x.recheck.correct+' / 24':'Pending'}</strong></div></div>`).join('')||'<p class="muted">No completed baseline yet.</p>'}<div class="row report-buttons"><button class="small" onclick="exportCSV()">Export answers (.csv)</button><button class="light small" onclick="window.print()">Print report</button></div>${learner.legacy?'<p class="muted legacy-note">An earlier site version is archived in your backup. Its questions differ, so old scores are not compared with this cycle.</p>':''}</section></div><section class="panel reflection-log"><h2>Practice evidence</h2>${learner.practiceHistory.slice().reverse().map(r=>`<details class="review-item"><summary><span>${unit(r.unit).title}<small>${date(r.createdAt)} · ${r.independent} / 4 independent · ${r.assisted} assisted</small></span><span>${r.reviewed?'Reviewed':'Needs teacher review'} ＋</span></summary><div class="review-body"><p><b>Rule explanation</b><br><span data-no-translate>${E(r.explanation)}</span></p><p><b>New sentence</b><br><span data-no-translate>${E(r.example)}</span></p><label class="checkline"><input type="checkbox" onchange="reviewPractice('${r.id}',this.checked)" ${r.reviewed?'checked':''}>I reviewed the explanation and example</label></div></details>`).join('')||'<p class="muted">Completed lessons will appear here.</p>'}</section><section class="panel data-tools"><h2>Profiles & backups</h2><p>${Object.keys(state.learners).length} learners saved on this device. Use the learner button to switch profiles.</p><div class="row"><button class="light small" onclick="exportBackup()">Download backup</button><label class="file-button">Restore backup<input type="file" accept=".json,application/json" onchange="importBackup(this.files[0])"></label><button class="danger small" onclick="clearLearner()">Clear this learner’s data</button></div><p class="local-note">This is a shared local workspace, not a password-protected teacher account. Anyone using this browser can open its learner profiles. No server sync is connected.</p></section>${info('How to read progress','Independent means a correct first answer without a hint. Corrected answers do not add independent points. A lesson needs at least 3 of 4 independent answers plus an explanation and new sentence before a rule check opens. A rule check needs 2 of 2 correct answers. Rechecks use the reserved matched question for every baseline rule. These are classroom support signals, not validated mastery scores.')}`}
window.assignRule=()=>{const c=cycle(),id=$('#assignUnit').value;if(!c||c.recheck||!unit(id))return;if(targets(c).includes(id)){toast('This rule is already in the plan.');return}c.teacherTargets.push(id);save();render();toast('Rule added to this learning plan.')};
window.removeAssignment=id=>{const c=cycle();if(!c||c.recheck)return;c.teacherTargets=c.teacherTargets.filter(x=>x!==id);save();render();toast('Teacher assignment removed. Test results are unchanged.')};
window.updateTeacherNote=text=>{const c=cycle();if(c){c.teacherNote=text;save()}};
window.saveTeacherNote=()=>{const c=cycle();if(c){c.teacherNote=$('#teacherNote').value.trim();save();toast('Teacher note saved.')}};
window.reviewPractice=(id,checked)=>{const r=learner.practiceHistory.find(r=>r.id===id);if(r){r.reviewed=checked;save()}};
function about(){return intro('About ErrorMap','English · Grade 7 · School No. 22')+`<div class="about-lead"><span class="large-mark">e↗</span><div><h2>Assel Amanzholova</h2><p>Turning language errors into a personal learning path.</p></div></div><section class="panel paper"><h2>How the learning cycle works</h2><ol class="about-steps"><li><b>Baseline.</b> One question for each of 24 rules. Missed answers suggest where to begin.</li><li><b>Practice.</b> Four separate examples, a rule explanation and a learner-written sentence.</li><li><b>Rule check.</b> Two different examples, answered independently.</li><li><b>Recheck.</b> A reserved question matched to each baseline topic and difficulty band.</li></ol><h2>What is in the question bank?</h2><p>240 questions: 144 assessment items and 96 practice items. Every rule has three A/B assessment pairs and four dedicated practice questions. Practice questions never appear in assessments.</p><h2>What is saved?</h2><p>Learner codes, unfinished attempts, results, hints, first answers, corrections, reflections and writing revisions are stored in this browser. Backups can be downloaded and restored. There is no shared server database or sign-in system.</p><h2>What still needs teacher judgement?</h2><p>A short test cannot establish mastery. New sentences and rule explanations need teacher review. The small writing checker does not understand every sentence. The paired assessments have not been statistically equated, and no classroom effectiveness study is claimed.</p></section>`}
function download(name,text,type){const url=URL.createObjectURL(new Blob(['\ufeff'+text],{type:type+';charset=utf-8'})),a=document.createElement('a');a.href=url;a.download=name;a.click();setTimeout(()=>URL.revokeObjectURL(url),1000)}
window.exportBackup=()=>download('ErrorMap-backup.json',JSON.stringify(state,null,2),'application/json');
function csvCell(value){let s=String(value??'');if(/^[=+@\-\t\r]/.test(s))s="'"+s;return '"'+s.replace(/"/g,'""')+'"'}
window.exportCSV=()=>{const rows=[['learner','cycle','assessment','date','question','rule','selected','expected','correct','seen_before']];for(const c of learner.cycles)for(const type of ['baseline','recheck'])if(c[type])for(const a of c[type].answers){const q=question(a.id);rows.push([state.active,c.id,type,c[type].createdAt,q.prompt,unit(a.unit).title,a.selected,q.options[q.answer],a.correct?1:0,a.seenBefore?1:0])}for(const r of learner.checkpoints)for(const a of r.answers){const q=question(a.id);rows.push([state.active,r.cycleId,'rule check',r.createdAt,q.prompt,unit(a.unit).title,a.selected,q.options[q.answer],a.correct?1:0,a.seenBefore?1:0])}download('ErrorMap-answers.csv',rows.map(r=>r.map(csvCell).join(',')).join('\n'),'text/csv')};
window.importBackup=async file=>{if(!file)return;if(file.size>5000000){toast('Choose a backup smaller than 5 MB.');return}try{const s=JSON.parse((await file.text()).replace(/^\ufeff/,''));if(!validState(s))throw Error();if(!ask('Restore this backup? It will replace all learner profiles on this device. Download the current backup first if you need it.'))return;state=s;learner=state.learners[state.active];writingFindings=[];writingCheckedText=null;save();render();toast('Backup restored.')}catch{toast('This file is not a valid ErrorMap English backup.')}};
window.clearLearner=()=>{if(ask('Clear all results and drafts for '+state.active+'? Other learners will stay. Download a backup first if needed.')){state.learners[state.active]=freshLearner(state.active);learner=state.learners[state.active];writingFindings=[];writingCheckedText=null;save();render();toast('Learner data cleared.')}};
function validState(s){
 try{
 const text=v=>typeof v==='string',safeId=v=>typeof v==='string'&&v.length<=40&&/^[a-z0-9]+-[a-z0-9]+$/.test(v),num=(v,min,max)=>Number.isInteger(v)&&v>=min&&v<=max,plain=v=>v&&typeof v==='object'&&!Array.isArray(v),has=(o,k)=>Object.hasOwn(o,k),array=(v,max=10000)=>Array.isArray(v)&&v.length<=max;
 const validItem=i=>plain(i)&&!!question(i.id)&&array(i.order,3)&&i.order.length===3&&i.order.every(n=>num(n,0,2))&&new Set(i.order).size===3&&(i.choice===null||num(i.choice,0,2));
 const result=r=>plain(r)&&text(r.createdAt)&&array(r.answers,24)&&r.answers.length>0&&num(r.correct,0,r.answers.length)&&r.answers.every(a=>question(a.id)&&a.unit===question(a.id).unit&&a.skill===question(a.id).skill&&a.pair===question(a.id).pair&&a.level===question(a.id).level&&text(a.selected)&&question(a.id).options.includes(a.selected)&&typeof a.correct==='boolean'&&a.correct===(a.selected===question(a.id).options[question(a.id).answer]))&&r.correct===r.answers.filter(a=>a.correct).length;
 if(!plain(s)||s.version!==4||!num(s.revision,0,Number.MAX_SAFE_INTEGER)||!plain(s.learners)||!text(s.active)||!has(s.learners,s.active))return false;
 const entries=Object.entries(s.learners);if(!entries.length||entries.length>100)return false;
 return entries.every(([code,l])=>{
 if(!/^[A-Z0-9_-]{2,24}$/.test(code)||['__PROTO__','CONSTRUCTOR','PROTOTYPE'].includes(code)||!plain(l)||l.code!==code||!array(l.cycles)||!array(l.practiceHistory)||!array(l.checkpoints)||!array(l.writingHistory)||!text(l.writingDraft))return false;
 if(l.cycles.some(c=>!safeId(c.id)||!result(c.baseline)||c.baseline.answers.length!==24||new Set(c.baseline.answers.map(a=>a.unit)).size!==24||c.baseline.answers.some(a=>question(a.id).form!=='A')||!array(c.teacherTargets,24)||c.teacherTargets.some(id=>!unit(id))||!text(c.teacherNote)||(c.recheck!==null&&(!result(c.recheck)||c.recheck.answers.length!==24||c.recheck.answers.some(a=>question(a.id).form!=='B'||c.baseline.answers.find(b=>b.unit===a.unit)?.pair!==a.pair)))))return false;
 if(new Set(l.cycles.map(c=>c.id)).size!==l.cycles.length)return false;
 if(l.activeCycleId!==null&&!l.cycles.some(c=>c.id===l.activeCycleId))return false;
 if(l.assessment!==null){const a=l.assessment;if((a.type==='baseline'&&(a.cycleId!==null||l.activeCycleId!==null))||(a.type!=='baseline'&&a.cycleId!==l.activeCycleId))return false;if(!plain(a)||!['baseline','recheck','checkpoint'].includes(a.type)||!safeId(a.id)||!text(a.startedAt)||!array(a.items,24)||a.items.length!==(a.type==='checkpoint'?2:24)||!a.items.every(validItem)||!num(a.index,0,a.items.length)||a.items.some(i=>question(i.id).form!==(a.type==='baseline'?'A':'B'))||(a.type==='checkpoint'&&!unit(a.unit)))return false}
 if(l.practice!==null){const p=l.practice;if(p.cycleId!==null&&p.cycleId!==l.activeCycleId)return false;if(!plain(p)||!safeId(p.id)||!unit(p.unit)||!['rule','questions','reflection'].includes(p.stage)||!num(p.index,0,3)||!array(p.items,4)||p.items.length!==4||p.items.some(i=>!validItem(i)||question(i.id).unit!==p.unit||question(i.id).use!=='practice'||(i.firstChoice!==null&&!num(i.firstChoice,0,2))||typeof i.hint!=='boolean'||typeof i.checked!=='boolean'||typeof i.corrected!=='boolean')||!text(p.explanation)||!text(p.example))return false}
 if(l.practiceHistory.some(r=>!safeId(r.id)||!unit(r.unit)||!text(r.createdAt)||!num(r.independent,0,4)||!num(r.firstCorrect,0,4)||!num(r.assisted,0,4)||!text(r.explanation)||!text(r.example)||typeof r.qualified!=='boolean'||r.qualified!==(r.independent>=3)||typeof r.reviewed!=='boolean'||!array(r.items,4)||r.items.length!==4||r.items.some(i=>!validItem(i)||question(i.id).use!=='practice'||question(i.id).unit!==r.unit||!num(i.firstChoice,0,2)||typeof i.hint!=='boolean'||!i.checked||!i.corrected||!isCorrect(i))||r.independent!==r.items.filter(i=>i.order[i.firstChoice]===question(i.id).answer&&!i.hint).length||r.firstCorrect!==r.items.filter(i=>i.order[i.firstChoice]===question(i.id).answer).length||r.assisted!==r.items.filter(i=>i.hint).length))return false;
 if(l.checkpoints.some(r=>!l.cycles.some(c=>c.id===r.cycleId)||!result(r)||!unit(r.unit)||r.answers.length!==2||r.answers.some(a=>a.unit!==r.unit||question(a.id).form!=='B')))return false;
 if(l.writingHistory.some(r=>!safeId(r.id)||!text(r.text)||!text(r.createdAt)))return false;
 return true;
 });
 }catch{return false}
}
function render(){const page=document.body.dataset.page||'home',pages={home,diagnostic,map:mapPage,route,studio,bank:bankView,teacher,about};$('#app').innerHTML=(pages[page]||home)();$('#profileCode').textContent=state.active;document.querySelectorAll('nav a').forEach(a=>{const active=a.dataset.page===page;a.classList.toggle('active',active);if(active)a.setAttribute('aria-current','page');else a.removeAttribute('aria-current')});$('#crumb').textContent={home:'Workspace',diagnostic:'Assessments',map:'Error map',route:'Learning plan',studio:'Writing',bank:'Library',teacher:'Teacher',about:'About'}[page]||'ErrorMap';I18N.apply(document.body);document.title=I18N.t(PAGE_TITLE.replace(' — ErrorMap',''))+' — ErrorMap';if(loadWarning){toast(loadWarning);loadWarning=''}}
$('#profileBtn').onclick=()=>{$('#codeInput').value=state.active;$('#profileList').innerHTML=Object.keys(state.learners).map(code=>`<option value="${code}">`).join('');$('#profileDialog').showModal()};
$('#saveCode').onclick=e=>{const code=$('#codeInput').value.trim().toUpperCase();if(!/^[A-Z0-9_-]{2,24}$/.test(code)||['__PROTO__','CONSTRUCTOR','PROTOTYPE'].includes(code)){e.preventDefault();toast('Use 2–24 letters, numbers, hyphens or underscores.');return}if(!Object.hasOwn(state.learners,code)&&Object.keys(state.learners).length>=100){e.preventDefault();toast('This workspace holds up to 100 learner profiles. Export a backup before clearing unused profiles.');return}state.learners[code]??=freshLearner(code);state.active=code;learner=state.learners[code];writingCheckedText=null;writingFindings=[];save();render()};
const pageParams=new URLSearchParams(location.search);
if(document.body.dataset.page==='bank'&&GROUPS.some(g=>g.id===pageParams.get('group')))bankFilters.group=pageParams.get('group');
if(document.body.dataset.page==='route'&&unit(pageParams.get('unit'))&&!learner.practice&&!learner.assessment){const id=pageParams.get('unit');routeFilter='all';window.startPractice(id)}else render();
window.addEventListener('storage',event=>{if(event.key===KEY&&event.newValue){try{const updated=JSON.parse(event.newValue);if(validState(updated)&&updated.revision>state.revision){state=updated;learner=state.learners[state.active];writingCheckedText=null;writingFindings=[];render();toast('Workspace updated from another tab.')}}catch{}}});

window.changeLanguage=value=>{const search=$('#bankSearch');if(document.body.dataset.page==='bank'&&search)bankFilters.query=search.value;I18N.set(value);render()};

````

## dist/assets/cloud-api.js

````javascript
(function(){
'use strict';
window.EMRandomId=()=>{if(crypto.randomUUID)return crypto.randomUUID();const b=new Uint8Array(16);crypto.getRandomValues(b);b[6]=(b[6]&15)|64;b[8]=(b[8]&63)|128;const h=Array.from(b,n=>n.toString(16).padStart(2,'0')).join('');return [h.slice(0,8),h.slice(8,12),h.slice(12,16),h.slice(16,20),h.slice(20)].join('-')};
const SESSION='errormap-teacher-cloud';let refreshing=null;
function config(){const c=window.ERRORMAP_CLOUD||{};if(!/^https:\/\/[^/]+\.supabase\.co$/.test(c.url||'')||!c.publishableKey)throw Error('cloudMissing');return c}
function session(){try{return JSON.parse(sessionStorage.getItem(SESSION))}catch{return null}}
function remember(s){const value={token:s.access_token,refresh:s.refresh_token,uid:s.user.id,email:s.user.email,expires:Date.now()+s.expires_in*1000};sessionStorage.setItem(SESSION,JSON.stringify(value));return value}
function forget(){sessionStorage.removeItem(SESSION)}
async function raw(path,options={},token=''){
 const c=config();const response=await fetch(c.url+path,{...options,headers:{apikey:c.publishableKey,'Content-Type':'application/json',...(token?{Authorization:'Bearer '+token}:{}),...options.headers}});
 const body=await response.text();let data;try{data=body?JSON.parse(body):null}catch{throw Error('connection')}
 if(!response.ok){const e=Error(data?.message||data?.error_description||'connection');e.status=response.status;throw e}return data;
}
async function token(){let s=session();if(!s)throw Error('signInRequired');if(s.expires>Date.now()+60000)return s.token;
 if(!refreshing)refreshing=raw('/auth/v1/token?grant_type=refresh_token',{method:'POST',body:JSON.stringify({refresh_token:s.refresh})}).then(remember).catch(e=>{if(e.status===400||e.status===401)forget();throw e}).finally(()=>{refreshing=null});return (await refreshing).token;
}
async function api(path,options={}){return raw('/rest/v1/'+path,options,await token())}
async function login(email,password){const data=await raw('/auth/v1/token?grant_type=password',{method:'POST',body:JSON.stringify({email,password})});remember(data);try{const p=await api('em_teachers?select=*');if(!p?.length)throw Error('teacherOnly');return p[0]}catch(e){await logout();throw e}}
async function logout(){const s=session();forget();if(s)await raw('/auth/v1/logout',{method:'POST'},s.token).catch(()=>{})}
async function rpc(name,args){return raw('/rest/v1/rpc/'+name,{method:'POST',body:JSON.stringify(args)})}
window.EMCloud={config,session,api,login,logout,rpc};
})();

````

## dist/assets/cloud-config.js

````javascript
/* Public project settings only. Never put a service-role/secret key here. */
window.ERRORMAP_CLOUD = {
  url: '',
  publishableKey: ''
};

````

## dist/assets/design.css

````css
@import url('https://fonts.googleapis.com/css2?family=Golos+Text:wght@400;500;600;700;800;900&display=swap');
:root{--ink:#20263b;--muted:#777e8e;--bg:#f8f8fc;--line:#e6e8f0;--brand:#4b52d4;--soft:#eeedff;--yellow:#f6e899;--green:#268774;--red:#b34b50}*{box-sizing:border-box}body{margin:0;background:var(--bg);color:var(--ink);font:14px 'Golos Text','DejaVu Sans',sans-serif}button,input,textarea,select{font:inherit}button,a{touch-action:manipulation}button{border:0;background:var(--brand);color:white;font-weight:600;padding:14px 21px;border-radius:10px;cursor:pointer;transition:background .2s,transform .2s}button:hover{background:#3d43b8;transform:translateY(-1px)}button:disabled{opacity:.5;cursor:default;transform:none}.light{background:white;color:var(--ink);border:1px solid #dfe1ed}.light:hover{background:#f0f0fa}.small{font-size:12px;padding:10px 14px}.danger{background:#fff0f0;color:#a3444d}a{color:var(--brand);text-decoration:none}a:hover{text-decoration:none}button:focus-visible,a:focus-visible,summary:focus-visible{outline:3px solid #8a83ed;outline-offset:4px}.row{display:flex;align-items:center;gap:12px;flex-wrap:wrap}.spread{justify-content:space-between}.muted{color:var(--muted)}.eyebrow{font-size:10px;letter-spacing:1.6px;font-weight:700;color:var(--brand);display:inline-block}.eyebrow i{display:inline-block;width:7px;height:7px;background:#6f70dd;border-radius:50%;margin-right:7px}.tag{display:inline-block;padding:6px 9px;border-radius:5px;background:#f0f0f8;color:#74768c;font-size:9px;font-weight:600;letter-spacing:.4px}h1,h2,h3,p{margin:0}h1{font-size:44px;line-height:1.15;letter-spacing:-1.7px;font-weight:800}h2{font-size:23px;letter-spacing:-.7px;line-height:1.3;margin-bottom:15px}h3{font-size:16px;line-height:1.45;letter-spacing:-.3px}p{line-height:1.85;margin-bottom:16px}small{font-size:11px}aside{background:white;padding:24px 4%;display:flex;align-items:center;justify-content:space-between;gap:28px;border-bottom:1px solid var(--line)}.brand{display:flex;align-items:center;gap:10px;color:var(--ink);font-size:26px;font-weight:800;letter-spacing:-1.3px;white-space:nowrap}.mark{background:var(--brand);color:white;width:36px;height:38px;display:flex;align-items:center;justify-content:center;font-size:29px;border-radius:11px}.mark span{font-size:13px;align-self:flex-start;margin-top:5px}.dot{color:var(--brand);margin-left:-10px}nav{display:flex;align-items:center;gap:5px}nav a{color:#73788c;padding:10px 11px;font-size:11px;font-weight:600;border-radius:7px;white-space:nowrap}nav a.active{background:var(--soft);color:var(--brand)}nav a:hover{background:#f3f3fb}header{display:flex;justify-content:space-between;align-items:center;max-width:1440px;margin:auto;height:73px;padding:0 5%;color:#8a8fa0;font-size:11px}header>div{display:flex;gap:17px;align-items:center}header button{font-size:10px;padding:9px 13px}.status{font-size:10px}main{padding:9px 5% 75px;max-width:1440px;margin:auto}main:focus{outline:0}.hero{background:#eeedff;border-radius:22px;display:grid;grid-template-columns:1.1fr 1fr;gap:30px;padding:52px 48px 45px;overflow:hidden;position:relative}.hero h1{font-size:clamp(40px,4.1vw,59px);line-height:1.12;letter-spacing:-2.3px;margin:22px 0}.hero h1>span{color:var(--brand)}.hero-copy>p{font-size:13px;color:#6e7293;max-width:435px;line-height:1.9}.hero .row{margin-top:27px}.hero .row button{font-size:12px}.hero button span{margin-left:22px;font-size:18px}.hero-meta{display:flex;gap:23px;font-size:10px;color:#8785a1;margin-top:27px}.hero-meta span+span:before{content:'·';margin-right:18px}.hero-visual{position:relative;min-height:335px;display:grid;place-items:center}.paper-card{position:relative;z-index:2;background:#fffefa;width:310px;max-width:90%;padding:28px 26px 24px;border-radius:5px;transform:rotate(-6deg);box-shadow:0 18px 35px #5451831a}.paper-top{display:flex;justify-content:space-between;color:#9897ac;font-size:9px;letter-spacing:1px}.hand-mark{font-size:27px;color:#38a08a}.sample-sentence{font-size:33px;line-height:1.5;font-weight:500;letter-spacing:-1px;margin:22px 0}.sample-sentence del{color:#cb7b74;text-decoration-color:#cb7b74;text-decoration-thickness:2px}.sample-sentence strong{display:inline-block;font-weight:500;background:#e4efda;color:#548345;padding:0 8px;transform:rotate(-2deg)}.paper-bottom{display:flex;align-items:center;gap:13px;border-top:1px dashed #dddde5;padding-top:18px}.paper-bottom p{font-size:11px;line-height:1.65;color:#828390;margin:0}.mini-code{background:var(--soft);color:var(--brand);padding:8px;border-radius:8px;font-size:10px;font-weight:700}.sticker{position:absolute;z-index:3;top:2px;right:-8px;background:var(--yellow);padding:17px 22px;font-size:10px;font-weight:800;line-height:1.6;letter-spacing:.6px;transform:rotate(9deg);border-radius:2px}.floating-label{position:absolute;bottom:0;right:0;z-index:3;display:flex;align-items:center;gap:13px;background:white;border-radius:13px;padding:16px 22px;box-shadow:0 10px 25px #4a45801a}.floating-label b{font-size:12px}.floating-label small{display:block;font-size:9px;color:#9194a3;margin-top:4px}.check-icon{display:grid;place-items:center;background:#e5f3ec;color:#388a71;width:31px;height:31px;border-radius:50%}.orbit-ring{position:absolute;border:1px dashed #bbb7e8;width:360px;height:330px;border-radius:50%;transform:rotate(25deg)}.visual-dots{position:absolute;bottom:33px;left:8px;width:65px;height:65px;background-image:radial-gradient(#a9a4da 1.5px,transparent 1.5px);background-size:10px 10px}.stats-strip{display:grid;grid-template-columns:repeat(4,1fr);gap:22px;padding:30px 18px;border-bottom:1px solid var(--line);margin-bottom:38px}.stats-strip>div{display:flex;align-items:center;gap:13px}.stats-strip b{font-size:29px;letter-spacing:-1px}.stats-strip span{font-size:10px;color:var(--muted);max-width:105px;line-height:1.7}.section-head{display:flex;align-items:flex-end;justify-content:space-between;margin:38px 0 20px;gap:15px}.section-head h2{margin:7px 0 0;font-size:23px}.section-head>.muted{font-size:11px}.text-link{font-size:11px;font-weight:600}.panel{background:white;border:1px solid var(--line);border-radius:15px;padding:27px}.desk-grid{display:grid;grid-template-columns:1fr 1.05fr .85fr;gap:20px}.desk-grid p{font-size:11px;color:var(--muted);line-height:1.85}.score{font-size:67px;font-weight:700;letter-spacing:-3px;color:var(--brand);margin:19px 0 13px;line-height:1.2}.score small{font-size:20px;letter-spacing:-1px;color:#9fa1b2;font-weight:400}.progress-panel .light{font-size:11px;padding:10px 14px}.focus-panel{background:#f0f5ed;border-color:#e3eadf}.focus-panel .tag{background:#e3ebdc;color:#729064}.focus-panel h3{font-size:24px;line-height:1.4;margin:23px 0 12px;color:#4c6942}.focus-panel small{color:#8a9b80}.mini-progress{height:6px;background:#e6e9df;border-radius:8px;overflow:hidden;margin:20px 0 10px}.mini-progress span{display:block;height:100%;background:#7b9e69;border-radius:8px}.writing-card{background:#faf1df;border:1px solid #efe3cc;border-radius:15px;padding:28px;position:relative;color:var(--ink);overflow:hidden}.writing-card .eyebrow{color:#ad8b51}.writing-lines{font-family:Georgia,serif;font-size:43px;line-height:1.3;margin:27px 0 23px;letter-spacing:-2px;color:#9d793b}.writing-lines em{font-weight:400}.writing-card p{font-size:11px;color:#a6906c}.round-arrow{display:grid;place-items:center;width:32px;height:32px;border-radius:50%;background:white;font-size:19px;color:#aa8c5e;position:absolute;bottom:20px;right:20px}.skill-grid{display:grid;grid-template-columns:repeat(3,1fr);gap:14px}.skill-tile{background:white;border:1px solid var(--line);padding:23px 19px;border-radius:12px;display:flex;align-items:center;gap:14px;color:var(--ink);transition:transform .2s,box-shadow .2s}.skill-tile:hover{transform:translateY(-3px);box-shadow:0 10px 20px #25254508}.skill-tile>span:last-child{margin-left:auto;color:#b7b9c9}.skill-tile h3{font-size:12px}.skill-tile p{font-size:9px;color:#9a9dac;margin:5px 0 0}.skill-code{display:inline-grid;place-items:center;min-width:36px;height:36px;border-radius:10px;background:color-mix(in srgb,var(--skill) 11%,white);color:var(--skill);font-size:12px;font-weight:700;flex-shrink:0}.method-band{margin-top:40px;padding:30px 34px;border-radius:16px;background:#272b44;color:white}.method-band>.eyebrow{color:#a6aad0}.method-band>div{display:grid;grid-template-columns:repeat(4,1fr);gap:25px;margin-top:25px}.method-band>div>div{border-left:1px solid #52566d;padding-left:20px}.method-band>div>div>span{font-size:10px;color:#8b91b7}.method-band h3{font-size:18px;margin:8px 0}.method-band p{font-size:10px;color:#a6acc4;margin:0}.page-intro{margin:10px 0 30px}.page-intro h1{margin:13px 0 15px;font-size:38px;max-width:900px}.page-intro p{font-size:12px;color:var(--muted);max-width:850px}.diagnostic-grid{display:grid;grid-template-columns:1fr 1fr;gap:23px}.test-card{position:relative;padding:36px;background:var(--soft);border-radius:18px;overflow:hidden}.test-card.secondary{background:#edf4e9}.test-card .test-letter{position:absolute;font-size:170px;font-weight:800;right:18px;top:-12px;color:#d9d6f7;line-height:1;z-index:0}.test-card.secondary .test-letter{color:#dce8d4}.test-card>*:not(.test-letter){position:relative;z-index:1}.test-card h2{max-width:340px;margin:25px 0 15px;font-size:27px}.test-card p{font-size:12px;max-width:390px;color:#777691}.secondary p{color:#75816c}.test-card button{margin-top:15px}.check-list{padding:0;list-style:none;font-size:12px;line-height:2.4;color:#737487}.check-list li:before{content:'✓';margin-right:12px;color:var(--brand)}.notice{padding:17px 21px;border-left:3px solid #a7a7cf;background:#efeff8;color:#73758b;font-size:11px;line-height:1.9;margin:23px 0;border-radius:0 8px 8px 0}.columns{display:grid;grid-template-columns:1.1fr 1fr;gap:22px}.question{max-width:820px;margin:auto;padding:35px}.english{font-size:25px;line-height:1.6;font-weight:500;letter-spacing:-.5px}.progress{height:5px;background:#efeff7;margin:23px 0 34px;border-radius:10px;overflow:hidden}.progress span{height:100%;display:block;background:var(--brand);transition:width .2s}.answers{display:grid;gap:12px;margin:25px 0}.answer{display:flex;align-items:center;gap:15px;text-align:left;background:white;color:var(--ink);border:1px solid var(--line);padding:17px 18px;font-weight:400}.answer:hover{background:#f6f5ff}.answer em{font-style:normal;width:27px;height:27px;display:grid;place-items:center;background:#f1f1f8;font-size:10px;border-radius:6px;flex-shrink:0}.answer.selected{border-color:#7778e0;background:#f1efff}.answer.right{background:#e9f4e9;border-color:#6b9e6f;opacity:1}.answer.wrong{background:#fff0ed;border-color:#d48d85;opacity:1}.text-button{background:none;color:var(--muted);font-size:11px;padding:18px 0 0}.text-button:hover{background:none;color:var(--brand)}.feedback{background:#f1f3f8;border-radius:10px;padding:18px;font-size:12px;line-height:1.9;margin:18px 0}.feedback p{margin:8px 0 0}.level{padding:6px 9px;border-radius:5px;font-size:9px;background:#f0f1f5}.high{background:#fbe9e5;color:#bc745e}.mid{background:#faf2d8;color:#a18a4d}.low{background:#eaf2e5;color:#6e925c}.map-grid{display:grid;grid-template-columns:repeat(3,1fr);gap:17px}.map-card{border:1px solid var(--line);background:white;border-radius:13px;padding:25px}.map-card h3{margin:20px 0 18px}.map-num{font-size:33px;font-weight:600;letter-spacing:-1px}.map-num small{font-size:15px;color:#b4b5c0;font-weight:400}.map-card .muted{font-size:11px}.page-tools{margin:0 0 22px}.page-tools p{margin:0;font-size:12px}.review-list{display:grid;gap:10px}.review-item{background:white;border:1px solid var(--line);border-radius:10px;overflow:hidden}.review-item summary{list-style:none;display:flex;align-items:center;gap:16px;padding:18px 20px;font-size:12px;cursor:pointer}.review-item summary::-webkit-details-marker{display:none}.review-item summary>span:last-child{margin-left:auto;white-space:nowrap;font-size:10px}.review-status{width:25px;height:25px;border-radius:50%;display:grid;place-items:center;flex-shrink:0}.review-status.yes{background:#e8f4e8;color:#5a9864}.review-status.no{background:#fcebe6;color:#bd7b67}.review-body{padding:0 25px 20px;font-size:12px}.route-list{display:grid;gap:16px}.route-card{display:grid;grid-template-columns:55px 1fr auto;gap:23px;align-items:center;padding:30px;background:white;border:1px solid var(--line);border-radius:15px}.route-number{font-size:33px;color:#d1d3e4;letter-spacing:-1px}.route-card h2{font-size:21px;margin:13px 0 7px}.route-card p{font-size:11px;color:var(--muted);margin:0}.route-card small{display:block;margin-top:10px;color:#78a06a}.route-card button{font-size:12px}.route-card.done{border-color:#b6d0ae}.lesson{max-width:820px;margin:auto;padding:38px}.lesson-label{color:#a5a3bb;font-size:10px;letter-spacing:2px}.lesson h2{margin:15px 0}.lesson>p{font-size:15px}.example{padding:27px;border-left:3px solid #8984da;background:#f1effd;font-size:21px;line-height:1.8;margin:25px 0}.empty{text-align:center;padding:65px 25px}.empty p{color:var(--muted);font-size:12px}.empty-symbol{display:inline-grid;place-items:center;width:65px;height:65px;border-radius:18px;background:var(--soft);color:var(--brand);font-size:35px;margin-bottom:25px}.bank-summary{display:flex;gap:35px;margin:0 0 25px;padding-bottom:25px;border-bottom:1px solid var(--line);color:var(--muted);font-size:12px}.bank-summary b{font-size:22px;color:var(--brand);margin-right:5px}.filter-bar{display:grid;grid-template-columns:1.5fr 1.4fr 1fr 1fr;gap:15px;padding:22px;background:white;border:1px solid var(--line);border-radius:13px;margin-bottom:25px}label{display:block;font-size:11px;font-weight:500}input,textarea,select{display:block;width:100%;border:1px solid #dfe1ed;background:white;padding:12px 13px;border-radius:8px;margin-top:9px;color:var(--ink)}input:focus,textarea:focus,select:focus{outline:2px solid #a3a0e9;outline-offset:2px}textarea{min-height:200px;resize:vertical;font-size:15px;line-height:1.9}.bank-grid{display:grid;grid-template-columns:repeat(3,1fr);gap:18px}.bank-card{background:white;border:1px solid var(--line);border-radius:13px;padding:23px;display:flex;flex-direction:column}.bank-topic{font-size:8px;letter-spacing:.8px;color:#a2a4b5;margin:20px 0 13px}.bank-card h3{font-size:14px;line-height:1.7}.bank-card ol{padding-left:20px;color:#7b8192;font-size:12px;line-height:2}.bank-card details{margin-top:auto;padding-top:15px;border-top:1px solid var(--line)}.bank-card summary{font-size:10px;color:var(--brand);cursor:pointer}.bank-card .feedback{padding:14px;font-size:11px}.pagination{display:flex;justify-content:center;gap:25px;align-items:center;margin:30px 0;font-size:12px}.writing-layout{display:grid;grid-template-columns:1.05fr 1fr;gap:24px;align-items:start}.editor-panel label{margin:25px 0 20px}.editor-panel textarea{min-height:320px;background:repeating-linear-gradient(white,white 35px,#f0eff7 36px,white 37px);line-height:37px;padding-top:11px}.findings-panel h2{margin-top:18px}.finding{padding:20px 0;border-bottom:1px solid var(--line)}.finding p{font-size:12px;color:var(--muted);margin:12px 0}.finding .english{font-size:19px;color:var(--ink)}.finding .english b{color:var(--green);font-weight:500}.finding .english del{color:#bb776b}.finding-empty{text-align:center;padding:45px 12px}.finding-empty>span{font-size:45px;color:#c2bddf}.finding-empty h3{margin:20px 0 12px}.finding-empty p{font-size:12px;color:var(--muted)}.checkline{display:flex;gap:10px;align-items:center;font-size:10px;color:var(--muted)}.checkline input{width:auto;margin:0;accent-color:var(--brand)}.teacher-stats{display:grid;grid-template-columns:repeat(4,1fr);gap:15px;margin-bottom:25px}.teacher-stats small{font-size:9px;color:var(--muted)}.teacher-stats b{display:block;font-size:29px;margin-top:12px;color:var(--brand);font-weight:600}.columns>.panel>p{font-size:12px;color:var(--muted)}.teacher-controls{display:grid;grid-template-columns:1fr 1fr;gap:18px;margin-top:25px}.history-item{display:flex;justify-content:space-between;align-items:center;padding:18px 0;border-bottom:1px solid var(--line);font-size:12px}.history-item small{display:block;margin-top:6px;color:var(--muted);font-size:10px}.history-item strong{color:var(--brand)}.report-buttons{margin-top:25px}.reflection-log,.data-tools{margin-top:25px}.reflection-log>.review-item{margin-top:12px}.data-tools p{font-size:12px;color:var(--muted)}.file-button{display:inline-block;padding:10px 14px;border:1px solid var(--line);border-radius:8px;background:#f8f8fc;cursor:pointer;font-size:12px}.file-button input{display:none}.about-lead{display:flex;align-items:center;gap:45px;background:var(--soft);padding:45px;border-radius:18px;margin-bottom:27px}.large-mark{font-size:90px;letter-spacing:-8px;color:var(--brand);font-weight:800}.about-lead h2{font-size:32px;margin:14px 0}.about-lead p{font-size:12px;color:#83809b;max-width:550px}.paper{max-width:940px;margin:auto;padding:38px}.paper h2{margin-top:30px}.paper h2:first-child{margin-top:0}.paper>p{font-size:13px;color:#747a8c}.achievement{display:grid;grid-template-columns:1fr 1fr;gap:22px;margin:22px 0}.achievement figure{margin:0}.achievement img{width:100%;height:245px;object-fit:contain;background:#f7f7fb;padding:10px}.achievement figcaption{font-size:10px;color:var(--muted);line-height:1.8;margin-top:12px}footer{border-top:1px solid var(--line);padding:35px 5%;display:flex;justify-content:space-between;align-items:center;font-size:10px;color:#a4a7b6;background:white;line-height:2}footer b{font-size:23px;color:#515673;letter-spacing:-1px}footer>span{font-size:15px;color:#9293ad}dialog{border:1px solid var(--line);border-radius:17px;padding:32px;max-width:480px;width:90%;color:var(--ink)}dialog::backdrop{background:#24234360}dialog p{font-size:12px;color:var(--muted)}dialog .row{margin-top:23px}#toast{position:fixed;bottom:25px;right:25px;max-width:480px;padding:17px 23px;border-radius:12px;color:white;background:#30344f;z-index:100;opacity:0;pointer-events:none;font-size:12px;line-height:1.8;transition:opacity .2s}#toast.show{opacity:1}.skip{position:absolute;left:-9999px;top:0;z-index:101;padding:12px;background:white}.skip:focus{left:10px}.mobile-nav-label{display:none}
@media(min-width:1600px){main{padding-top:20px}.hero{padding:65px}.hero h1{font-size:62px}}
@media(max-width:1200px){aside{display:block;padding:20px 4%}.brand{font-size:25px}nav{margin-top:18px;overflow:auto}nav a{font-size:11px;padding:9px 12px}main{padding-left:4%;padding-right:4%}.hero{padding:39px 32px}.hero h1{font-size:45px}.paper-card{width:275px;padding:23px}.sample-sentence{font-size:29px}.sticker{right:-2px;font-size:9px}.floating-label{right:-8px}.skill-tile{padding:20px 14px;gap:10px}.skill-tile h3{font-size:11px}.desk-grid{grid-template-columns:1fr 1fr}.writing-card{grid-column:1/-1;display:flex;align-items:center;gap:35px;padding:25px}.writing-lines{font-size:30px;margin:0;line-height:1.2}.writing-card .round-arrow{bottom:25px}.writing-card p{margin:0}.bank-grid{grid-template-columns:repeat(2,1fr)}}
@media(max-width:740px){aside{padding:19px 20px 12px}nav{margin-top:15px;gap:4px;padding-bottom:7px}nav a{padding:9px 10px;font-size:10px}header{height:61px;padding:0 20px}.status{display:none}header button{font-size:10px}main{padding:0 18px 45px}.hero{display:block;padding:31px 25px 30px;border-radius:17px}.hero h1{font-size:40px;letter-spacing:-1.7px;margin:20px 0}.hero-copy>p{font-size:12px;max-width:100%}.hero .row{gap:9px;margin-top:23px}.hero .row button{font-size:11px;padding:12px 14px}.hero button span{margin-left:12px}.hero-meta{font-size:8px;gap:13px;margin-top:22px}.hero-meta span+span:before{margin-right:11px}.hero-visual{min-height:315px;margin-top:35px}.paper-card{width:250px;padding:25px;max-width:88%;transform:rotate(-5deg)}.sample-sentence{font-size:29px}.sticker{top:0;right:-5px;font-size:8px;padding:13px 17px}.floating-label{bottom:0;right:-4px;padding:12px 16px}.floating-label b{font-size:10px}.floating-label small{font-size:8px}.orbit-ring{width:270px;height:275px}.visual-dots{left:-5px;bottom:30px;width:48px;height:48px}.stats-strip{grid-template-columns:1fr 1fr;padding:23px 7px;gap:24px;margin-bottom:28px}.stats-strip b{font-size:27px}.stats-strip span{font-size:9px;max-width:95px}.section-head{margin-top:28px;align-items:flex-start}.section-head h2{font-size:21px}.section-head>.muted{font-size:9px}.text-link{font-size:10px}.desk-grid{grid-template-columns:1fr;gap:15px}.writing-card{grid-column:auto;display:block;min-height:200px;padding:25px}.writing-lines{font-size:37px;margin:20px 0}.writing-card p{font-size:11px}.skill-grid{grid-template-columns:1fr 1fr;gap:10px}.skill-tile{display:block;padding:18px 14px;position:relative}.skill-tile .skill-code{margin-bottom:14px}.skill-tile h3{font-size:11px;min-height:31px}.skill-tile p{font-size:8px}.skill-tile>span:last-child{position:absolute;right:15px;top:22px}.method-band{padding:26px 23px;margin-top:28px}.method-band>div{grid-template-columns:1fr 1fr;gap:25px 15px}.method-band>div>div{padding-left:14px}.method-band h3{font-size:17px}.method-band p{font-size:9px}.page-intro{margin:7px 0 25px}.page-intro h1{font-size:30px;letter-spacing:-1.1px}.page-intro p{font-size:11px}.diagnostic-grid,.columns,.writing-layout{grid-template-columns:1fr}.test-card{padding:28px}.test-card h2{font-size:24px}.test-card .test-letter{font-size:145px}.panel{padding:23px}.question{padding:25px 20px}.question .row>.row{font-size:10px}.english{font-size:21px}.answer{font-size:13px;padding:14px}.map-grid{grid-template-columns:1fr 1fr;gap:10px}.map-card{padding:18px 14px}.map-card h3{font-size:12px;margin:15px 0}.map-card .row{gap:8px}.map-card .level{font-size:7px;padding:5px}.map-card .skill-code{width:28px;min-width:28px;height:28px;font-size:10px}.map-num{font-size:26px}.map-card .muted{font-size:9px}.review-item summary{padding:16px 13px;font-size:11px;gap:9px}.review-item summary>span:last-child{font-size:8px;white-space:normal;min-width:45px}.review-body{padding:0 15px 15px}.route-card{padding:23px 18px;grid-template-columns:35px 1fr;gap:14px}.route-card h2{font-size:19px}.route-card button{grid-column:2;justify-self:start;font-size:11px}.route-number{font-size:26px}.lesson{padding:26px 22px}.lesson>p{font-size:13px}.example{padding:20px;font-size:18px}.bank-summary{gap:15px;flex-wrap:wrap;font-size:10px}.bank-summary b{font-size:19px}.filter-bar{grid-template-columns:1fr 1fr;gap:16px 10px;padding:18px}.filter-bar label:first-child{grid-column:1/-1}.filter-bar label:nth-child(2){grid-column:1/-1}input,select{padding:11px;font-size:12px}.bank-grid{grid-template-columns:1fr;gap:14px}.bank-card{padding:23px}.bank-card h3{font-size:15px}.bank-card ol{font-size:13px}.bank-card summary{font-size:11px}.teacher-stats{grid-template-columns:1fr 1fr;gap:10px}.teacher-stats .panel{padding:21px 16px}.teacher-stats b{font-size:25px}.teacher-controls{grid-template-columns:1fr}.editor-panel textarea{min-height:250px;font-size:14px}.editor-panel .row>small{font-size:9px}.about-lead{padding:28px;gap:20px;align-items:flex-start}.large-mark{font-size:55px;letter-spacing:-5px}.about-lead h2{font-size:23px}.about-lead p{font-size:11px}.achievement{grid-template-columns:1fr}.paper{padding:25px}.paper>p{font-size:12px}.paper h2{font-size:21px}footer{padding:25px 22px;font-size:9px}footer>span{font-size:11px;max-width:80px;line-height:1.8}#toast{bottom:15px;right:15px;left:15px;font-size:11px;max-width:none}dialog{padding:25px}.notice{font-size:10px;padding:16px 18px}}
@media(prefers-reduced-motion:reduce){*{scroll-behavior:auto!important;transition:none!important}}
@media print{aside,header,footer,button,.skip,.file-button,.page-tools,.filter-bar{display:none!important}body{background:white;color:#111}main{padding:0}.panel,.map-card{break-inside:avoid;border-color:#bbb}h1{font-size:28px}.map-grid{grid-template-columns:repeat(3,1fr)}.columns{display:block}.columns>.panel{margin-bottom:20px}.review-item{break-inside:avoid}.review-body{display:block}.teacher-stats{grid-template-columns:repeat(4,1fr)}.data-tools{display:none}.notice{background:white}}
/* Concise interface */
.hero{padding-top:43px;padding-bottom:43px}.hero h1{font-size:clamp(35px,3.7vw,53px);margin:22px 0}.hero-visual{min-height:265px}.sample-sentence{margin:8px 0 25px}.hero-meta{margin-top:24px}.hero-meta span+span:before{content:'·'}.desk-grid{margin-bottom:12px}.focus-panel h3{font-size:22px}.writing-lines{font-size:35px;margin:10px 0 23px}.page-intro>h1{margin-top:0}.test-card h2{margin-top:12px}.test-card .tag{display:none}.test-card button{margin-top:5px}.test-card{padding-bottom:30px}.editor-panel .row.spread:first-child{justify-content:flex-end}.help-note{margin:23px 0;padding:16px 20px;border:1px solid var(--line);border-radius:10px;color:var(--muted);font-size:11px}.help-note summary{cursor:pointer;line-height:1.7}.help-note p{margin:14px 0 0;max-width:900px}.about-lead h2{margin-top:0}header #crumb{visibility:hidden}header{height:62px}.section-head{align-items:center}.section-head h2{margin-top:0}.focus-panel .text-link{display:inline-block;margin-top:13px}
@media(max-width:740px){.hero{padding:29px 24px}.hero h1{font-size:34px;letter-spacing:-1.3px}.hero-visual{min-height:260px;margin-top:26px}.hero .row button{font-size:10px}.paper-card{width:235px}.orbit-ring{width:255px;height:255px}.writing-lines{font-size:32px}.writing-card{min-height:175px}.help-note{padding:14px 17px;font-size:10px}header{height:55px}}
/* English learning workflow */
.button{display:inline-flex;align-items:center;justify-content:center;gap:10px;background:var(--brand);color:white;border:1px solid transparent;padding:14px 21px;border-radius:10px;font-size:12px;font-weight:600;line-height:1.4}.button:hover{background:#3d43b8}.button.light{background:white;border-color:#dfe1ed;color:var(--ink)}.button.light:hover{background:#f1f0fb}header #crumb{visibility:visible}.hero-copy>p{max-width:390px}.hero h1{font-size:clamp(37px,3.9vw,56px);letter-spacing:-2px}.desk-grid h3{overflow-wrap:anywhere}.focus-panel h3{font-size:24px;margin-top:20px}.focus-panel p{margin-top:12px}.progress-panel .text-link,.focus-panel .text-link{margin-top:17px;display:inline-block}.skill-tile h3{font-size:13px}.skill-tile p{font-size:10px}.test-card .tag{display:inline-block}.test-card h2{margin-top:25px}.test-meta{display:flex;gap:20px;font-size:10px;color:var(--muted);margin:25px 0}.gate-message{padding:14px 0;color:#78816f!important;font-size:12px!important}.gate-message.success{color:#3a815b!important}.test-complete{display:flex;align-items:center;gap:18px;margin:25px 0}.test-complete b{font-size:28px;color:var(--brand)}.test-complete span{font-size:10px;color:var(--muted)}.assessment-review{max-width:850px;margin:auto}.assessment-review>p{font-size:12px;color:var(--muted)}.answer-index{display:grid;grid-template-columns:repeat(8,1fr);gap:10px;margin:25px 0 30px}.answer-index button{padding:13px 8px}.answer-index small{display:block;font-size:10px;margin-top:7px;color:#85869e}.answer-index .unanswered{border-color:#d8a39c;background:#fff4f2}.assessment-bottom{display:flex;gap:25px;justify-content:space-between;margin-top:5px}.result-banner{display:flex;align-items:center;gap:45px;background:#eeedfb;border-radius:15px;padding:28px 32px;margin-bottom:25px}.result-banner>div{min-width:110px}.result-banner small{font-size:9px;color:#9390b2;letter-spacing:.8px}.result-banner b{display:block;font-size:36px;letter-spacing:-1px;margin:8px 0;color:var(--brand)}.result-banner b span{font-size:13px;color:#9091aa;font-weight:400;letter-spacing:0}.result-banner p{font-size:10px;color:#88879d;margin:0}.result-banner .button{margin-left:auto}.map-card .row h3{font-size:15px;margin:0}.map-comparison{display:flex;flex-direction:column;gap:12px;font-size:11px;margin-top:25px;color:var(--muted)}.map-comparison>span{display:flex;justify-content:space-between}.map-comparison b{color:var(--ink)}.review-item summary small{display:block;font-weight:400;color:var(--muted);font-size:10px;margin-top:5px}.review-body .english{font-size:18px;margin:12px 0 17px}.plan-toolbar{display:flex;align-items:center;justify-content:space-between;gap:20px;margin:0 0 23px}.plan-toolbar>.muted{font-size:11px}.segmented{display:flex;gap:4px;padding:4px;border:1px solid var(--line);background:#eeeef6;border-radius:9px}.segmented button{background:none;color:var(--muted);font-size:11px;padding:10px 16px}.segmented button.active{background:white;color:var(--brand);box-shadow:0 2px 5px #23234308}.level.assigned{background:#f9ede5;color:#af785a}.level.review{background:#fbe9e5;color:#b66c57}.level.ready{background:#f5f0d7;color:#9e8a3c}.level.verified{background:#e8f3e9;color:#6a9667}.level.optional{background:#efeff5;color:#9193a5}.route-actions{display:flex;flex-direction:column;align-items:flex-start;gap:3px}.route-actions .text-button{padding-top:10px}.route-card h2{margin-top:14px}.route-card>div:nth-child(2){min-width:0}.route-card small{font-size:10px}.checkpoint-review{font-size:10px;margin-top:16px;color:var(--muted)}.checkpoint-review summary{cursor:pointer;color:var(--brand)}.checkpoint-review .feedback{font-size:11px;max-width:590px}.plan-finish,.restart-card{display:flex;align-items:center;justify-content:space-between;gap:25px;margin-top:25px}.plan-finish h3,.restart-card h3{margin-bottom:7px}.plan-finish p,.restart-card p{font-size:11px;color:var(--muted);margin:0}.lesson h2{margin-top:25px}.hint{padding:17px;background:#fff8e2;border:1px solid #eee2b9;border-radius:10px;margin:20px 0;font-size:12px;color:#938352}.hint p{margin:8px 0}.hint small{font-size:10px}.question label{margin:20px 0}.question label textarea{min-height:105px}.question>.muted{font-size:11px}.question>.score{font-size:57px}.question>.score small{font-size:16px}.bank-lesson-link{margin-top:17px;display:inline-block;font-size:10px}.bank-topic{min-height:15px}.editor-panel .row.spread:first-child{justify-content:space-between}.editor-panel h2{margin:0;font-size:20px}.editor-panel>label{margin-top:25px}.editor-note{display:block;font-size:10px;color:var(--muted);line-height:1.8;margin-top:17px}.preserve-lines{white-space:pre-wrap;overflow-wrap:anywhere}.teacher-note-title{margin-top:30px}.teacher-note-title+label{margin:15px 0}.teacher-note-title+label textarea{min-height:120px}.local-note{margin:22px 0 0!important;font-size:10px!important;line-height:1.8}.legacy-note{font-size:10px!important;line-height:1.8;margin-top:24px}.data-tools h2{margin-bottom:12px}.about-steps{padding-left:23px;margin:20px 0 28px;color:var(--muted);font-size:13px;line-height:1.9}.about-steps li{margin-bottom:15px}.about-lead h2{margin:0 0 15px}.about-lead p{margin:0}.page-intro>p{max-width:800px}button,select,input,textarea{max-width:100%}.help-note p{overflow-wrap:anywhere}
@media(max-width:1100px){.result-banner{gap:24px;flex-wrap:wrap}.result-banner .button{margin-left:0}.route-card{grid-template-columns:40px 1fr auto}.hero .row{align-items:flex-start}.hero .row .button{font-size:11px}.map-card .row h3{font-size:13px}}
@media(max-width:740px){.hero h1{font-size:35px;letter-spacing:-1.5px}.hero-copy>p{font-size:12px}.hero-visual{margin-top:30px}.hero .row{gap:9px}.hero .row button,.hero .row .button{font-size:10px;padding:12px 14px}.answer-index{grid-template-columns:repeat(4,1fr);gap:8px}.answer-index button{padding:12px 7px}.result-banner{gap:22px;padding:24px}.result-banner>div{min-width:105px}.result-banner b{font-size:30px}.result-banner .button{width:100%;margin-top:4px}.map-card .row h3{font-size:11px}.map-comparison{font-size:10px;gap:8px}.map-card .row{flex-wrap:nowrap}.map-card{padding:19px 13px}.review-item summary{font-size:11px}.review-item summary small{font-size:9px}.route-card{grid-template-columns:30px 1fr}.route-actions{grid-column:2}.route-actions button{grid-column:auto}.route-card h2{font-size:18px;letter-spacing:-.5px}.route-card p{font-size:10px}.route-card .row{gap:8px}.level{font-size:8px}.plan-toolbar{flex-wrap:wrap;gap:13px}.segmented button{font-size:10px;padding:10px 13px}.plan-finish,.restart-card{display:block}.plan-finish .button,.restart-card button{margin-top:20px}.test-card h2{font-size:24px;max-width:250px}.test-meta{gap:15px;font-size:9px}.test-complete{flex-wrap:wrap}.question .row>span.row{max-width:73%;font-size:10px}.question>.score{font-size:45px}.question>.score small{font-size:13px}.bank-card .bank-lesson-link{font-size:11px}.teacher-stats b{font-size:24px}.local-note{font-size:9px!important}.about-steps{font-size:12px}.about-lead h2{font-size:23px}.skill-tile h3{font-size:12px}.skill-tile p{font-size:9px}footer a{font-size:10px}}
@media print{.button,.assessment-bottom,.segmented,.plan-toolbar,.text-button{display:none!important}.review-item[open]>.review-body{display:block}.result-banner{background:white;border:1px solid #ccc}.teacher-stats b{font-size:22px}}
.storage-warning{margin:0 5% 20px;padding:15px 20px;background:#fff1e9;border:1px solid #e1bda7;border-radius:10px;font-size:12px;color:#8e5944}.storage-warning[hidden]{display:none}.storage-warning button{margin-left:15px}
.teacher-assignments{margin-top:23px;display:grid;gap:10px}.teacher-assignments>div{padding:12px 14px;border:1px solid var(--line);border-radius:8px;font-size:11px}.teacher-assignments button{font-size:10px;display:block;padding-top:8px;color:#ab6765}
.language-picker{margin:0;display:inline-flex;align-items:center}.language-select{width:auto;min-width:105px;margin:0;padding:8px 26px 8px 11px;background:white;font-size:11px;border-radius:8px}.sr-only{position:absolute;width:1px;height:1px;padding:0;margin:-1px;overflow:hidden;clip:rect(0,0,0,0);white-space:nowrap;border:0}html[lang=kk] .hero h1,html[lang=ru] .hero h1{font-size:clamp(32px,3.5vw,48px);letter-spacing:-1.4px}html[lang=kk] nav a,html[lang=ru] nav a{font-size:10px;padding-left:9px;padding-right:9px}
@media(max-width:740px){header #crumb{display:none}header>div{width:100%;justify-content:space-between;gap:10px}header .status{display:none}.language-select{font-size:11px;min-width:105px}html[lang=kk] .hero h1,html[lang=ru] .hero h1{font-size:32px}html[lang=kk] .hero .row,html[lang=ru] .hero .row{gap:10px}.hero .row button{white-space:normal}html[lang=kk] .route-actions button,html[lang=ru] .route-actions button{font-size:10px}}

````

## dist/assets/favicon.svg

````xml
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 40 40"><rect width="40" height="40" rx="11" fill="#4b52d4"/><text x="10" y="30" font-family="Georgia" font-size="32" fill="white">e</text></svg>
````

## dist/assets/home-pages.js

````javascript
'use strict';
const homeCopy={en:{studentEntry:'Student',teacherEntry:'Teacher',studentAction:'Open your workspace',teacherAction:'Sign in to your dashboard',guestEntry:'Explore as a guest',guestNote:'No student password needed.',demoLabel:'ONE SENTENCE. ONE RULE.',demoTitle:'Small change. Clear meaning.',demoBefore:'Before',demoAfter:'After',demoRule:'In the present simple, add -s or -es with he, she and it.',demoTry:'Practise this rule'},kk:{studentEntry:'Оқушы',teacherEntry:'Мұғалім',studentAction:'Оқу аймағын ашу',teacherAction:'Жеке кабинетке кіру',guestEntry:'Қонақ ретінде қарау',guestNote:'Оқушыға құпиясөз қажет емес.',demoLabel:'БІР СӨЙЛЕМ. БІР ЕРЕЖЕ.',demoTitle:'Шағын түзету. Түсінікті ереже.',demoBefore:'Бұрын',demoAfter:'Кейін',demoRule:'Present Simple шағында he, she, it есімдіктерімен етістікке -s немесе -es жалғанады.',demoTry:'Ережені жаттықтыру'},ru:{studentEntry:'Ученик',teacherEntry:'Учитель',studentAction:'Открыть учебную страницу',teacherAction:'Войти в свой кабинет',guestEntry:'Посмотреть как гость',guestNote:'Ученику пароль не нужен.',demoLabel:'ОДНО ПРЕДЛОЖЕНИЕ. ОДНО ПРАВИЛО.',demoTitle:'Небольшая правка. Понятное правило.',demoBefore:'До',demoAfter:'После',demoRule:'В Present Simple с he, she и it добавляем к глаголу -s или -es.',demoTry:'Потренировать правило'}};
for(const l of ['en','kk','ru'])Object.assign(words[l],homeCopy[l]);
document.querySelector('#guestButton').onclick=()=>{const section=document.querySelector('#guestWorkspace');section.hidden=false;section.scrollIntoView({behavior:'smooth',block:'start'})};
document.querySelector('#quickWriting').onsubmit=e=>{e.preventDefault();const text=document.querySelector('#quickText').value.trim();if(!text)return;try{sessionStorage.setItem('errormap-guest-text',text)}catch{}location.href='writing.html'};
update();

````

## dist/assets/i18n.js

````javascript
(function(){
'use strict';
const dictionary={"Workspace": {"kk": "Жұмыс аймағы", "ru": "Рабочая область"}, "Check": {"kk": "Тексеру", "ru": "Проверка"}, "Error map": {"kk": "Қателер картасы", "ru": "Карта ошибок"}, "Learning plan": {"kk": "Оқу бағыты", "ru": "Учебный маршрут"}, "Writing": {"kk": "Жазылым", "ru": "Письмо"}, "Library": {"kk": "Тапсырмалар", "ru": "Задания"}, "Teacher": {"kk": "Мұғалімге", "ru": "Учителю"}, "About": {"kk": "Жоба туралы", "ru": "О проекте"}, "Language": {"kk": "Тіл", "ru": "Язык"}, "Interface language": {"kk": "Интерфейс тілі", "ru": "Язык интерфейса"}, "Skip to content": {"kk": "Мазмұнға өту", "ru": "Перейти к содержанию"}, "Main navigation": {"kk": "Негізгі бөлімдер", "ru": "Основные разделы"}, "Local workspace": {"kk": "Осы құрылғыдағы жұмыс аймағы", "ru": "Работа на этом устройстве"}, "Saved on this device": {"kk": "Осы құрылғыда сақталды", "ru": "Сохранено на этом устройстве"}, "Not saved": {"kk": "Сақталмады", "ru": "Не сохранено"}, "Learner:": {"kk": "Оқушы:", "ru": "Ученик:"}, "Learner profile": {"kk": "Оқушы профилі", "ru": "Профиль ученика"}, "Learner code": {"kk": "Оқушы коды", "ru": "Код ученика"}, "Select a saved code or create a new one. Each learner keeps separate results and unfinished work.": {"kk": "Сақталған кодты таңда немесе жаңа код жаса. Әр оқушының нәтижесі мен аяқталмаған жұмысы бөлек сақталады.", "ru": "Выберите сохранённый код или создайте новый. Результаты и незаконченная работа каждого ученика сохраняются отдельно."}, "Example: LEARNER-02": {"kk": "Мысалы: LEARNER-02", "ru": "Например: LEARNER-02"}, "Use a code, not a real name. Letters, numbers, hyphens and underscores only.": {"kk": "Аты-жөніңнің орнына код қолдан. Әріптер, сандар, дефис және төменгі сызық рұқсат етіледі.", "ru": "Используйте код вместо имени. Допустимы буквы, цифры, дефисы и подчёркивания."}, "Cancel": {"kk": "Бас тарту", "ru": "Отмена"}, "Open profile": {"kk": "Профильді ашу", "ru": "Открыть профиль"}, "How it works": {"kk": "Қалай жұмыс істейді", "ru": "Как это работает"}, "ENGLISH · GRADE 7": {"kk": "АҒЫЛШЫН ТІЛІ · 7-СЫНЫП", "ru": "АНГЛИЙСКИЙ ЯЗЫК · 7 КЛАСС"}, "Find the gap.": {"kk": "Қиындықты анықта.", "ru": "Найди пробел."}, "Know your next step.": {"kk": "Келесі қадамыңды біл.", "ru": "Узнай свой следующий шаг."}, "Check your English. Practise the rules you need. Test them again on new examples.": {"kk": "Ағылшын тіліңді тексер. Қажет ережелерді қайтала. Жаңа мысалдармен қайта тексер.", "ru": "Проверь свой английский. Отработай нужные правила и проверь их на новых примерах."}, "Explore practice": {"kk": "Жаттығуларды қарау", "ru": "Посмотреть упражнения"}, "Your workspace": {"kk": "Жұмыс аймағың", "ru": "Твоя рабочая область"}, "BASELINE": {"kk": "БАСТАПҚЫ ТЕКСЕРУ", "ru": "НАЧАЛЬНАЯ ПРОВЕРКА"}, "NEXT STEP": {"kk": "КЕЛЕСІ ҚАДАМ", "ru": "СЛЕДУЮЩИЙ ШАГ"}, "RECHECK": {"kk": "ҚАЙТА ТЕКСЕРУ", "ru": "ПОВТОРНАЯ ПРОВЕРКА"}, "Start with one question for each rule.": {"kk": "Әр ереже бойынша бір сұрақтан баста.", "ru": "Начни с одного вопроса по каждому правилу."}, "Start baseline": {"kk": "Бастапқы тексеруді бастау", "ru": "Начать проверку"}, "Start your baseline": {"kk": "Бастапқы тексеруді баста", "ru": "Начни начальную проверку"}, "View your error map": {"kk": "Қателер картасын ашу", "ru": "Открыть карту ошибок"}, "View your progress": {"kk": "Нәтижелерді қарау", "ru": "Посмотреть прогресс"}, "Your baseline and recheck are ready to compare.": {"kk": "Бастапқы және қайта тексеру нәтижелерін салыстыруға болады.", "ru": "Результаты начальной и повторной проверки готовы к сравнению."}, "Your answers are saved.": {"kk": "Жауаптарың сақталды.", "ru": "Твои ответы сохранены."}, "Continue": {"kk": "Жалғастыру", "ru": "Продолжить"}, "Your words.": {"kk": "Сенің сөздерің.", "ru": "Твои слова."}, "Your next draft.": {"kk": "Келесі нұсқаң.", "ru": "Твой следующий черновик."}, "Write and revise": {"kk": "Жазу және түзету", "ru": "Написать и исправить"}, "Six skill areas": {"kk": "Алты дағды бағыты", "ru": "Шесть направлений"}, "Four rules in each area": {"kk": "Әр бағытта төрт ереже", "ru": "По четыре правила в каждом направлении"}, "Verb agreement": {"kk": "Бастауыш пен етістіктің қиысуы", "ru": "Согласование глагола"}, "Verb tenses": {"kk": "Етістік шақтары", "ru": "Времена глагола"}, "Words & phrases": {"kk": "Сөздер мен тіркестер", "ru": "Слова и сочетания"}, "Prepositions": {"kk": "Предлогтар", "ru": "Предлоги"}, "Word order": {"kk": "Сөз реті", "ru": "Порядок слов"}, "Spelling": {"kk": "Емле", "ru": "Правописание"}, "Check your English": {"kk": "Ағылшын тіліңді тексер", "ru": "Проверь свой английский"}, "Baseline → targeted practice → rule checks → recheck": {"kk": "Бастапқы тексеру → жеке жаттығу → ережені тексеру → қайта тексеру", "ru": "Начальная проверка → практика → проверка правила → повторный тест"}, "Start with what you know.": {"kk": "Алдымен біліміңді тексер.", "ru": "Начни с того, что знаешь."}, "24 questions. One question for each rule. Answers stay hidden until you submit.": {"kk": "24 сұрақ. Әр ережеге бір сұрақ. Дұрыс жауаптар тексеруді аяқтағанда ашылады.", "ru": "24 вопроса: по одному на каждое правило. Правильные ответы откроются после отправки."}, "About 15 minutes": {"kk": "Шамамен 15 минут", "ru": "Около 15 минут"}, "Autosaved": {"kk": "Автоматты сақталады", "ru": "Автосохранение"}, "View baseline": {"kk": "Бастапқы нәтижені қарау", "ru": "Посмотреть начальный результат"}, "Use the rule in a new sentence.": {"kk": "Ережені жаңа сөйлемде қолдан.", "ru": "Примени правило в новом предложении."}, "The recheck follows your baseline topics and difficulty, using different questions.": {"kk": "Қайта тексеруде сол тақырыптар мен деңгейге сай басқа сұрақтар беріледі.", "ru": "Повторная проверка охватывает те же темы и уровень сложности, но содержит другие вопросы."}, "Complete your baseline first.": {"kk": "Алдымен бастапқы тексеруден өт.", "ru": "Сначала пройди начальную проверку."}, "Compare results": {"kk": "Нәтижелерді салыстыру", "ru": "Сравнить результаты"}, "All assigned rules have been checked.": {"kk": "Барлық берілген ереже тексерілді.", "ru": "Все назначенные правила проверены."}, "No rules were flagged in your baseline.": {"kk": "Бастапқы тексеруде қате анықталмады.", "ru": "Начальная проверка не выявила ошибок."}, "Start recheck": {"kk": "Қайта тексеруді бастау", "ru": "Начать повторную проверку"}, "Take your recheck": {"kk": "Қайта тексеруден өт", "ru": "Пройди повторную проверку"}, "Continue your plan": {"kk": "Оқу бағытын жалғастыру", "ru": "Продолжить маршрут"}, "What can these results tell me?": {"kk": "Бұл нәтижелер нені көрсетеді?", "ru": "О чём говорят результаты?"}, "One baseline answer is a starting signal, not proof of a gap or mastery. Your practice and independent rule checks add evidence. Paired questions cover the same rule and difficulty band, but the tests have not been statistically equated.": {"kk": "Бір жауап — бастапқы бағдар. Ол ережені толық меңгеру немесе білмеу туралы қорытындыға жеткіліксіз. Жаттығулар мен өздік тексеру қосымша дерек береді. Жұп сұрақтар бір ережеге және деңгейге арналған, бірақ тесттердің тең қиындығы статистикалық расталмаған.", "ru": "Один ответ — лишь начальный сигнал. Он не доказывает наличие пробела или владение правилом. Практика и самостоятельные проверки дополняют картину. Парные вопросы совпадают по правилу и уровню, но тесты статистически не уравнивались."}, "Start another learning cycle": {"kk": "Жаңа оқу кезеңін бастау", "ru": "Начать новый учебный цикл"}, "Keep this cycle in your history and use a fresh baseline.": {"kk": "Осы кезеңді тарихта сақтап, жаңа бастапқы тексеруден өт.", "ru": "Сохрани этот цикл в истории и пройди новую начальную проверку."}, "New cycle": {"kk": "Жаңа кезең", "ru": "Новый цикл"}, "Review your answers": {"kk": "Жауаптарыңды қарап шық", "ru": "Проверь свои ответы"}, "You can change an answer before submitting. Correct answers are still hidden.": {"kk": "Жібермес бұрын жауапты өзгертуге болады. Дұрыс жауаптар әзірге көрсетілмейді.", "ru": "До отправки можно изменить ответ. Правильные ответы пока скрыты."}, "Not answered": {"kk": "Жауап жоқ", "ru": "Нет ответа"}, "Save & exit": {"kk": "Сақтап, шығу", "ru": "Сохранить и выйти"}, "Baseline": {"kk": "Бастапқы тексеру", "ru": "Начальная проверка"}, "Recheck": {"kk": "Қайта тексеру", "ru": "Повторная проверка"}, "Rule check": {"kk": "Ережені тексеру", "ru": "Проверка правила"}, "Choose one answer. You can review before submitting.": {"kk": "Бір жауапты таңда. Жібермес бұрын тексеруге болады.", "ru": "Выбери один ответ. Перед отправкой их можно проверить."}, "Some examples appeared in earlier attempts. This is recorded with the result.": {"kk": "Кей мысалдар бұрынғы әрекеттерде кездескен. Бұл нәтижеде белгіленеді.", "ru": "Некоторые примеры встречались раньше. Это будет отмечено в результате."}, "Back": {"kk": "Артқа", "ru": "Назад"}, "Next": {"kk": "Келесі", "ru": "Далее"}, "Review answers": {"kk": "Жауаптарды қарау", "ru": "Проверить ответы"}, "Discard attempt": {"kk": "Әрекетті жою", "ru": "Удалить попытку"}, "Submit baseline": {"kk": "Бастапқы жауаптарды жіберу", "ru": "Отправить начальный тест"}, "Submit recheck": {"kk": "Қайта тексеруді жіберу", "ru": "Отправить повторный тест"}, "Submit rule check": {"kk": "Ереже тексеруін жіберу", "ru": "Отправить проверку правила"}, "Your error map": {"kk": "Сенің қателер картаң", "ru": "Твоя карта ошибок"}, "Your progress": {"kk": "Сенің нәтижелерің", "ru": "Твой прогресс"}, "Compare the same rules using different examples.": {"kk": "Бір ережені әртүрлі мысалдағы нәтижелермен салыстыр.", "ru": "Сравни результаты по одним правилам на разных примерах."}, "Missed answers become practice suggestions, not permanent labels.": {"kk": "Қате жауаптар жаттығу бағытын таңдауға көмектеседі.", "ru": "Ошибки помогают выбрать, что отработать дальше."}, "ASSIGNED RULES": {"kk": "БЕРІЛГЕН ЕРЕЖЕЛЕР", "ru": "НАЗНАЧЕННЫЕ ПРАВИЛА"}, "CHANGE": {"kk": "ӨЗГЕРІС", "ru": "ИЗМЕНЕНИЕ"}, "Same topics · different examples": {"kk": "Сол тақырыптар · басқа мысалдар", "ru": "Те же темы · другие примеры"}, "Open learning plan": {"kk": "Оқу бағытын ашу", "ru": "Открыть учебный маршрут"}, "View history": {"kk": "Тарихты қарау", "ru": "Посмотреть историю"}, "Rule-by-rule comparison": {"kk": "Ережелер бойынша салыстыру", "ru": "Сравнение по правилам"}, "Answers and next steps": {"kk": "Жауаптар және келесі қадам", "ru": "Ответы и следующие шаги"}, "Correct": {"kk": "Дұрыс", "ru": "Правильно"}, "Missed": {"kk": "Қате", "ru": "Ошибка"}, "Not flagged in baseline": {"kk": "Бастапқы тексеруде дұрыс", "ru": "Верно в начальной проверке"}, "Your answer:": {"kk": "Сенің жауабың:", "ru": "Твой ответ:"}, "Expected:": {"kk": "Дұрыс жауап:", "ru": "Правильный ответ:"}, "Recheck answer:": {"kk": "Қайта тест жауабы:", "ru": "Ответ повторного теста:"}, "Needs another look": {"kk": "Қайта қарау қажет", "ru": "Нужно повторить"}, "Practise this rule": {"kk": "Ережені жаттықтыру", "ru": "Отработать правило"}, "How is the plan chosen?": {"kk": "Оқу бағыты қалай таңдалады?", "ru": "Как выбирается маршрут?"}, "A missed baseline answer flags its specific rule. Four dedicated practice questions are followed by a two-question independent rule check. A clean rule check adds evidence of improvement; it does not prove long-term mastery. Correct baseline rules remain available for optional practice.": {"kk": "Бастапқы қатеге сәйкес ереже белгіленеді. Төрт жаттығудан кейін екі сұрақтық өздік тексеру беріледі. Дұрыс нәтиже ілгерілеуді көрсетеді, бірақ ұзақ мерзімді меңгеруді дәлелдемейді. Қалған ережелерді де жаттықтыруға болады.", "ru": "Ошибка начального теста отмечает конкретное правило. После четырёх упражнений следуют два самостоятельных вопроса. Успешная проверка показывает улучшение, но не доказывает долгосрочное владение. Остальные правила тоже доступны для практики."}, "Work on one rule at a time. Practise, explain, then check it.": {"kk": "Бір ережеден баста. Жаттығып, түсіндіріп, кейін тексер.", "ru": "Работай над одним правилом: практика, объяснение, затем проверка."}, "Try any rule, or take a baseline for a personalised plan.": {"kk": "Кез келген ережені таңда немесе жеке бағыт үшін бастапқы тексеруден өт.", "ru": "Выбери любое правило или пройди начальный тест для личного маршрута."}, "All 24 rules": {"kk": "Барлық 24 ереже", "ru": "Все 24 правила"}, "Optional practice": {"kk": "Қосымша жаттығу", "ru": "Практика по желанию"}, "Needs practice": {"kk": "Жаттығу қажет", "ru": "Нужна практика"}, "Review again": {"kk": "Қайта қарау", "ru": "Повторить ещё раз"}, "Ready for a rule check": {"kk": "Ережені тексеруге дайын", "ru": "Готово к проверке правила"}, "Rule check complete": {"kk": "Ереже тексерілді", "ru": "Правило проверено"}, "Rule check complete · reused examples": {"kk": "Ереже тексерілді · қайталанған мысалдар", "ru": "Правило проверено · повторные примеры"}, "Check your next rule": {"kk": "Келесі ережені тексер", "ru": "Проверь следующее правило"}, "Open your learning plan": {"kk": "Оқу бағытыңды аш", "ru": "Открой учебный маршрут"}, "Check this rule": {"kk": "Ережені тексеру", "ru": "Проверить правило"}, "Review lesson": {"kk": "Сабақты қайталау", "ru": "Повторить урок"}, "Practise again": {"kk": "Қайта жаттығу", "ru": "Потренироваться снова"}, "Review & retry": {"kk": "Қайталау және қайта орындау", "ru": "Повторить и попробовать снова"}, "Start lesson": {"kk": "Сабақты бастау", "ru": "Начать урок"}, "Recheck your English": {"kk": "Ағылшын тіліңді қайта тексер", "ru": "Проверь английский повторно"}, "All assigned rule checks are complete.": {"kk": "Барлық берілген ереже тексерілді.", "ru": "Все назначенные проверки правил завершены."}, "Finish the assigned rule checks to unlock your recheck.": {"kk": "Қайта тесті ашу үшін берілген ережелерді тексеріп аяқта.", "ru": "Заверши назначенные проверки правил, чтобы открыть повторный тест."}, "View requirements": {"kk": "Талаптарды қарау", "ru": "Посмотреть условия"}, "No rules assigned": {"kk": "Ереже тағайындалмаған", "ru": "Нет назначенных правил"}, "Build your plan": {"kk": "Оқу бағытыңды құр", "ru": "Создай свой маршрут"}, "Your baseline did not flag any rules. You can explore optional practice or take your recheck.": {"kk": "Бастапқы тексеруде қате болмады. Қосымша жаттығуды немесе қайта тексеруді таңда.", "ru": "В начальном тесте не было ошибок. Можно выбрать дополнительную практику или повторный тест."}, "Complete a baseline to see which rules to work on.": {"kk": "Қай ережені қайталау керегін білу үшін бастапқы тексеруден өт.", "ru": "Пройди начальную проверку, чтобы узнать, какие правила повторить."}, "RULE": {"kk": "ЕРЕЖЕ", "ru": "ПРАВИЛО"}, "What to notice": {"kk": "Неге назар аудару керек", "ru": "На что обратить внимание"}, "This lesson reuses the same four practice examples. The independent rule check uses different questions.": {"kk": "Бұл сабақта сол төрт жаттығу қайталанады. Өздік тексеруде басқа сұрақтар болады.", "ru": "В уроке повторяются те же четыре упражнения. Самостоятельная проверка содержит другие вопросы."}, "Try 4 questions": {"kk": "4 тапсырманы орындау", "ru": "Выполнить 4 задания"}, "Explain the rule": {"kk": "Ережені түсіндір", "ru": "Объясни правило"}, "Write in your own words. Your teacher can review these examples.": {"kk": "Өз сөзіңмен жаз. Мысалдарды мұғалім тексере алады.", "ru": "Напиши своими словами. Учитель сможет проверить примеры."}, "Hints and corrected answers are recorded separately.": {"kk": "Көмек пен түзетілген жауаптар бөлек тіркеледі.", "ru": "Подсказки и исправления учитываются отдельно."}, "What rule did you use?": {"kk": "Қай ережені қолдандың?", "ru": "Какое правило ты применил?"}, "Write a new sentence": {"kk": "Жаңа сөйлем жаз", "ru": "Напиши новое предложение"}, "Your writing is saved for teacher review, not automatically marked.": {"kk": "Жазғаның мұғалім тексеруі үшін сақталады. Автоматты баға қойылмайды.", "ru": "Текст сохраняется для проверки учителем и не оценивается автоматически."}, "Save lesson": {"kk": "Сабақты сақтау", "ru": "Сохранить урок"}, "Foundation": {"kk": "Бастапқы", "ru": "Базовый"}, "Developing": {"kk": "Орта", "ru": "Средний"}, "Stretch": {"kk": "Күрделі", "ru": "Сложный"}, "Rule reminder": {"kk": "Ережені еске түсіру", "ru": "Напоминание правила"}, "This answer will be marked as assisted.": {"kk": "Бұл жауап көмекпен орындалған деп белгіленеді.", "ru": "Этот ответ будет отмечен как выполненный с подсказкой."}, "Correct on your first try.": {"kk": "Алғашқы жауап дұрыс.", "ru": "Правильно с первой попытки."}, "Correction complete.": {"kk": "Қате түзетілді.", "ru": "Ошибка исправлена."}, "Read the explanation, then choose the correct answer.": {"kk": "Түсіндірмені оқып, дұрыс жауапты таңда.", "ru": "Прочитай объяснение и выбери правильный ответ."}, "Check correction": {"kk": "Түзетуді тексеру", "ru": "Проверить исправление"}, "Check answer": {"kk": "Жауапты тексеру", "ru": "Проверить ответ"}, "Show rule reminder": {"kk": "Ережені көрсету", "ru": "Показать правило"}, "Discard lesson": {"kk": "Сабақты жою", "ru": "Удалить урок"}, "Question library": {"kk": "Тапсырмалар қоры", "ru": "Банк заданий"}, "96 practice questions across 24 rules. Open a lesson to practise a complete rule.": {"kk": "24 ережеге арналған 96 жаттығу. Толық жаттығу үшін сабақты аш.", "ru": "96 упражнений по 24 правилам. Открой урок, чтобы отработать правило полностью."}, "Teacher resource: answer keys are available here. Viewing assessment answers can affect later test results.": {"kk": "Мұғалімге арналған бөлім: жауап кілттері бар. Оларды алдын ала қарау кейінгі тест нәтижесіне әсер етуі мүмкін.", "ru": "Материалы учителя с ключами ответов. Просмотр ответов может повлиять на результаты последующих тестов."}, "Search": {"kk": "Іздеу", "ru": "Поиск"}, "A rule or a word…": {"kk": "Ереже немесе сөз…", "ru": "Правило или слово…"}, "Skill area": {"kk": "Дағды бағыты", "ru": "Направление"}, "All skills": {"kk": "Барлық дағды", "ru": "Все направления"}, "Level": {"kk": "Деңгей", "ru": "Уровень"}, "All levels": {"kk": "Барлық деңгей", "ru": "Все уровни"}, "Question type": {"kk": "Тапсырма түрі", "ru": "Тип задания"}, "Practice": {"kk": "Жаттығу", "ru": "Практика"}, "Assessment keys": {"kk": "Тест жауаптары", "ru": "Ключи тестов"}, "All questions": {"kk": "Барлық сұрақ", "ru": "Все вопросы"}, "Download content": {"kk": "Қорды жүктеу", "ru": "Скачать задания"}, "Answer & explanation": {"kk": "Жауап пен түсіндірме", "ru": "Ответ и объяснение"}, "Open rule lesson": {"kk": "Ереже сабағын ашу", "ru": "Открыть урок по правилу"}, "No questions found": {"kk": "Сұрақ табылмады", "ru": "Вопросы не найдены"}, "Try another word or clear the filters.": {"kk": "Басқа сөзді енгіз немесе сүзгілерді тазала.", "ru": "Попробуй другое слово или сбрось фильтры."}, "Reset filters": {"kk": "Сүзгілерді тазалау", "ru": "Сбросить фильтры"}, "Previous": {"kk": "Алдыңғы", "ru": "Назад"}, "Write. Notice. Revise.": {"kk": "Жаз. Байқа. Түзет.", "ru": "Напиши. Заметь. Исправь."}, "Write 3–6 sentences. Use the suggestions to make your own revision.": {"kk": "3–6 сөйлем жаз. Ұсыныстарды пайдаланып, мәтінді өзің түзет.", "ru": "Напиши 3–6 предложений и исправь текст с помощью рекомендаций."}, "Your draft": {"kk": "Сенің мәтінің", "ru": "Твой черновик"}, "Try an example": {"kk": "Үлгі мәтін", "ru": "Попробовать пример"}, "English text": {"kk": "Ағылшынша мәтін", "ru": "Текст на английском"}, "Write about your school, family or hobbies…": {"kk": "Мектебің, отбасың немесе хоббиің туралы ағылшынша жаз…", "ru": "Напиши по-английски о школе, семье или увлечениях…"}, "Check draft": {"kk": "Мәтінді тексеру", "ru": "Проверить черновик"}, "Save revision": {"kk": "Нұсқаны сақтау", "ru": "Сохранить версию"}, "Use a learner code, not a real name or personal details.": {"kk": "Аты-жөн мен жеке деректің орнына оқушы кодын қолдан.", "ru": "Используй код ученика вместо имени и личных данных."}, "Things to review": {"kk": "Тексеретін тұстар", "ru": "Что стоит проверить"}, "Draft changed. Check it again.": {"kk": "Мәтін өзгерді. Қайта тексер.", "ru": "Текст изменён. Проверь его снова."}, "Check your draft to see suggestions.": {"kk": "Ұсыныстарды көру үшін мәтінді тексер.", "ru": "Проверь черновик, чтобы увидеть рекомендации."}, "No covered patterns found": {"kk": "Тексерілетін үлгілер бойынша қате табылмады", "ru": "Ошибок по доступным шаблонам не найдено"}, "This is not a full grammar check. Ask your teacher to review meaning, word order and other errors.": {"kk": "Бұл толық грамматикалық тексеру емес. Мағынаны, сөз ретін және басқа қателерді мұғаліммен тексер.", "ru": "Это не полная проверка грамматики. Попроси учителя проверить смысл, порядок слов и другие ошибки."}, "Your suggestions will appear here.": {"kk": "Ұсыныстар осы жерде көрсетіледі.", "ru": "Рекомендации появятся здесь."}, "Previous suggestions are hidden until you check this draft.": {"kk": "Мәтінді қайта тексергенше бұрынғы ұсыныстар жасырылды.", "ru": "Предыдущие рекомендации скрыты до новой проверки."}, "Saved revisions": {"kk": "Сақталған нұсқалар", "ru": "Сохранённые версии"}, "What does the checker cover?": {"kk": "Талдағыш нені тексереді?", "ru": "Что проверяет анализатор?"}, "Teacher workspace": {"kk": "Мұғалімнің жұмыс аймағы", "ru": "Рабочая область учителя"}, "CYCLES": {"kk": "КЕЗЕҢДЕР", "ru": "ЦИКЛЫ"}, "RULES CHECKED": {"kk": "ТЕКСЕРІЛГЕН ЕРЕЖЕЛЕР", "ru": "ПРОВЕРЕНО ПРАВИЛ"}, "Assign a rule": {"kk": "Ереже тағайындау", "ru": "Назначить правило"}, "A teacher assignment adds practice without changing the learner’s test scores.": {"kk": "Мұғалім тапсырмасы жаттығу қосады. Тест ұпайы өзгермейді.", "ru": "Назначение добавляет практику и не меняет баллы теста."}, "Rule": {"kk": "Ереже", "ru": "Правило"}, "Assign practice": {"kk": "Жаттығу тағайындау", "ru": "Назначить практику"}, "A baseline is needed first.": {"kk": "Алдымен бастапқы тексеру қажет.", "ru": "Сначала нужна начальная проверка."}, "This cycle is complete. Start a new cycle for new assignments.": {"kk": "Бұл кезең аяқталды. Жаңа тапсырма үшін жаңа кезеңді баста.", "ru": "Цикл завершён. Для новых назначений начни новый цикл."}, "Assignments apply to the current cycle.": {"kk": "Тапсырмалар ағымдағы кезеңге беріледі.", "ru": "Назначения относятся к текущему циклу."}, "Remove assignment": {"kk": "Тапсырманы алып тастау", "ru": "Убрать назначение"}, "Teacher note": {"kk": "Мұғалім жазбасы", "ru": "Заметка учителя"}, "Observation (autosaved)": {"kk": "Бақылау жазбасы (автоматты сақталады)", "ru": "Наблюдение (автосохранение)"}, "Record a misconception or a next step…": {"kk": "Қате түсінікті немесе келесі қадамды жаз…", "ru": "Запишите затруднение или следующий шаг…"}, "Cycle history": {"kk": "Кезеңдер тарихы", "ru": "История циклов"}, "Current cycle": {"kk": "Ағымдағы кезең", "ru": "Текущий цикл"}, "Previous cycle": {"kk": "Алдыңғы кезең", "ru": "Предыдущий цикл"}, "Pending": {"kk": "Күтілуде", "ru": "Ожидается"}, "No completed baseline yet.": {"kk": "Бастапқы тексеру әлі аяқталмаған.", "ru": "Начальная проверка ещё не завершена."}, "Export answers (.csv)": {"kk": "Жауаптарды жүктеу (.csv)", "ru": "Скачать ответы (.csv)"}, "Print report": {"kk": "Есепті басып шығару", "ru": "Распечатать отчёт"}, "Practice evidence": {"kk": "Жаттығу нәтижелері", "ru": "Результаты практики"}, "Reviewed": {"kk": "Тексерілді", "ru": "Проверено"}, "Needs teacher review": {"kk": "Мұғалім тексеруі қажет", "ru": "Нужна проверка учителем"}, "Rule explanation": {"kk": "Ережені түсіндіру", "ru": "Объяснение правила"}, "New sentence": {"kk": "Жаңа сөйлем", "ru": "Новое предложение"}, "I reviewed the explanation and example": {"kk": "Түсіндірме мен мысалды тексердім", "ru": "Я проверил объяснение и пример"}, "Completed lessons will appear here.": {"kk": "Аяқталған сабақтар осында көрсетіледі.", "ru": "Завершённые уроки появятся здесь."}, "Profiles & backups": {"kk": "Профильдер мен сақтық көшірмелер", "ru": "Профили и резервные копии"}, "Download backup": {"kk": "Сақтық көшірмені жүктеу", "ru": "Скачать резервную копию"}, "Restore backup": {"kk": "Көшірмеден қалпына келтіру", "ru": "Восстановить копию"}, "Clear this learner’s data": {"kk": "Осы оқушының деректерін тазалау", "ru": "Очистить данные этого ученика"}, "How to read progress": {"kk": "Нәтижені қалай түсінеміз?", "ru": "Как читать результаты?"}, "About ErrorMap": {"kk": "ErrorMap туралы", "ru": "Об ErrorMap"}, "English · Grade 7 · School No. 22": {"kk": "Ағылшын тілі · 7-сынып · №22 мектеп", "ru": "Английский язык · 7 класс · Школа №22"}, "Turning language errors into a personal learning path.": {"kk": "Тілдік қателерден жеке оқу бағытын құру.", "ru": "Индивидуальный маршрут на основе языковых ошибок."}, "How the learning cycle works": {"kk": "Оқу кезеңі қалай өтеді?", "ru": "Как устроен учебный цикл?"}, "Baseline.": {"kk": "Бастапқы тексеру.", "ru": "Начальная проверка."}, "Practice.": {"kk": "Жаттығу.", "ru": "Практика."}, "Rule check.": {"kk": "Ережені тексеру.", "ru": "Проверка правила."}, "Recheck.": {"kk": "Қайта тексеру.", "ru": "Повторная проверка."}, "What is in the question bank?": {"kk": "Тапсырмалар қорында не бар?", "ru": "Что входит в банк заданий?"}, "What is saved?": {"kk": "Не сақталады?", "ru": "Что сохраняется?"}, "What still needs teacher judgement?": {"kk": "Мұғалім нені бағалайды?", "ru": "Что оценивает учитель?"}, "One baseline question is a starting signal, not a mastery judgement.": {"kk": "Бір сұрақ тек бастапқы бағдар береді.", "ru": "Один вопрос даёт лишь начальный ориентир."}, "No baseline yet": {"kk": "Бастапқы нәтиже жоқ", "ru": "Начального результата пока нет"}, "Complete your baseline to build a plan.": {"kk": "Оқу бағытын құру үшін бастапқы тексеруден өт.", "ru": "Пройди начальную проверку, чтобы построить маршрут."}, "Resume baseline": {"kk": "Бастапқы тексеруді жалғастыру", "ru": "Продолжить начальную проверку"}, "Resume recheck": {"kk": "Қайта тексеруді жалғастыру", "ru": "Продолжить повторную проверку"}, "Resume rule check": {"kk": "Ереже тексеруін жалғастыру", "ru": "Продолжить проверку правила"}, "Resume practice": {"kk": "Жаттығуды жалғастыру", "ru": "Продолжить практику"}, "Third-person -s / -es": {"kk": "Үшінші жақтағы -s / -es", "ru": "-s / -es в третьем лице"}, "In the present simple, add -s or -es after he, she, it or a singular subject. Change consonant + y to -ies.": {"kk": "Present Simple шағында he, she, it және жекеше бастауышпен етістікке -s/-es жалғанады. Дауыссыздан кейінгі y әрпі -ies болып өзгереді.", "ru": "В Present Simple после he, she, it и подлежащего в единственном числе добавляется -s/-es. После согласной y меняется на -ies."}, "My sister is one person. Study changes to studies after a singular third-person subject.": {"kk": "Дұрыс жауап: «studies». Present Simple шағында he, she, it және жекеше бастауышпен етістікке -s/-es жалғанады. Дауыссыздан кейінгі y әрпі -ies болып өзгереді.", "ru": "Правильный ответ: «studies». В Present Simple после he, she, it и подлежащего в единственном числе добавляется -s/-es. После согласной y меняется на -ies."}, "My brother is one person. Add -s: plays.": {"kk": "Дұрыс жауап: «plays». Present Simple шағында he, she, it және жекеше бастауышпен етістікке -s/-es жалғанады. Дауыссыздан кейінгі y әрпі -ies болып өзгереді.", "ru": "Правильный ответ: «plays». В Present Simple после he, she, it и подлежащего в единственном числе добавляется -s/-es. После согласной y меняется на -ies."}, "Our teacher is singular, so the present-simple form is explains.": {"kk": "Дұрыс жауап: «explains». Present Simple шағында he, she, it және жекеше бастауышпен етістікке -s/-es жалғанады. Дауыссыздан кейінгі y әрпі -ies болып өзгереді.", "ru": "Правильный ответ: «explains». В Present Simple после he, she, it и подлежащего в единственном числе добавляется -s/-es. После согласной y меняется на -ies."}, "The bus is singular. Add -s: arrives.": {"kk": "Дұрыс жауап: «arrives». Present Simple шағында he, she, it және жекеше бастауышпен етістікке -s/-es жалғанады. Дауыссыздан кейінгі y әрпі -ies болып өзгереді.", "ru": "Правильный ответ: «arrives». В Present Simple после he, she, it и подлежащего в единственном числе добавляется -s/-es. После согласной y меняется на -ies."}, "Watch ends in -ch. Add -es after a singular subject: watches.": {"kk": "Дұрыс жауап: «watches». Present Simple шағында he, she, it және жекеше бастауышпен етістікке -s/-es жалғанады. Дауыссыздан кейінгі y әрпі -ies болып өзгереді.", "ru": "Правильный ответ: «watches». В Present Simple после he, she, it и подлежащего в единственном числе добавляется -s/-es. После согласной y меняется на -ies."}, "Fly ends in consonant + y. Change y to -ies: flies.": {"kk": "Дұрыс жауап: «flies». Present Simple шағында he, she, it және жекеше бастауышпен етістікке -s/-es жалғанады. Дауыссыздан кейінгі y әрпі -ies болып өзгереді.", "ru": "Правильный ответ: «flies». В Present Simple после he, she, it и подлежащего в единственном числе добавляется -s/-es. После согласной y меняется на -ies."}, "My father is singular. The correct form is works.": {"kk": "Дұрыс жауап: «works». Present Simple шағында he, she, it және жекеше бастауышпен етістікке -s/-es жалғанады. Дауыссыздан кейінгі y әрпі -ies болып өзгереді.", "ru": "Правильный ответ: «works». В Present Simple после he, she, it и подлежащего в единственном числе добавляется -s/-es. После согласной y меняется на -ies."}, "Brush ends in -sh, so add -es: brushes.": {"kk": "Дұрыс жауап: «brushes». Present Simple шағында he, she, it және жекеше бастауышпен етістікке -s/-es жалғанады. Дауыссыздан кейінгі y әрпі -ies болып өзгереді.", "ru": "Правильный ответ: «brushes». В Present Simple после he, she, it и подлежащего в единственном числе добавляется -s/-es. После согласной y меняется на -ies."}, "Catch ends in -ch, so add -es after a singular subject.": {"kk": "Дұрыс жауап: «catches». Present Simple шағында he, she, it және жекеше бастауышпен етістікке -s/-es жалғанады. Дауыссыздан кейінгі y әрпі -ies болып өзгереді.", "ru": "Правильный ответ: «catches». В Present Simple после he, she, it и подлежащего в единственном числе добавляется -s/-es. После согласной y меняется на -ies."}, "Change consonant + y to -ies: cry becomes cries.": {"kk": "Дұрыс жауап: «cries». Present Simple шағында he, she, it және жекеше бастауышпен етістікке -s/-es жалғанады. Дауыссыздан кейінгі y әрпі -ies болып өзгереді.", "ru": "Правильный ответ: «cries». В Present Simple после he, she, it и подлежащего в единственном числе добавляется -s/-es. После согласной y меняется на -ies."}, "Base verbs after auxiliaries": {"kk": "Көмекші етістіктен кейінгі бастапқы тұлға", "ru": "Начальная форма после вспомогательных глаголов"}, "After do, does, did, do not, does not or did not, use the base form of the main verb.": {"kk": "Do, does, did және олардың болымсыз түрлерінен кейін негізгі етістік бастапқы тұлғада тұрады.", "ru": "После do, does, did и их отрицательных форм основной глагол употребляется в начальной форме."}, "Does already marks the question. Use the base form speak.": {"kk": "Дұрыс жауап: «speak». Do, does, did және олардың болымсыз түрлерінен кейін негізгі етістік бастапқы тұлғада тұрады.", "ru": "Правильный ответ: «speak». После do, does, did и их отрицательных форм основной глагол употребляется в начальной форме."}, "Use the base form play after does.": {"kk": "Дұрыс жауап: «play». Do, does, did және олардың болымсыз түрлерінен кейін негізгі етістік бастапқы тұлғада тұрады.", "ru": "Правильный ответ: «play». После do, does, did и их отрицательных форм основной глагол употребляется в начальной форме."}, "After does not, the main verb stays in its base form: drink.": {"kk": "Дұрыс жауап: «drink». Do, does, did және олардың болымсыз түрлерінен кейін негізгі етістік бастапқы тұлғада тұрады.", "ru": "Правильный ответ: «drink». После do, does, did и их отрицательных форм основной глагол употребляется в начальной форме."}, "Use give, not gives, after does not.": {"kk": "Дұрыс жауап: «give». Do, does, did және олардың болымсыз түрлерінен кейін негізгі етістік бастапқы тұлғада тұрады.", "ru": "Правильный ответ: «give». После do, does, did и их отрицательных форм основной глагол употребляется в начальной форме."}, "Did marks the past tense. The main verb must be see.": {"kk": "Дұрыс жауап: «see». Do, does, did және олардың болымсыз түрлерінен кейін негізгі етістік бастапқы тұлғада тұрады.", "ru": "Правильный ответ: «see». После do, does, did и их отрицательных форм основной глагол употребляется в начальной форме."}, "Use the base form go after did.": {"kk": "Дұрыс жауап: «go». Do, does, did және олардың болымсыз түрлерінен кейін негізгі етістік бастапқы тұлғада тұрады.", "ru": "Правильный ответ: «go». После do, does, did и их отрицательных форм основной глагол употребляется в начальной форме."}, "Use the base form enjoy after do.": {"kk": "Дұрыс жауап: «enjoy». Do, does, did және олардың болымсыз түрлерінен кейін негізгі етістік бастапқы тұлғада тұрады.", "ru": "Правильный ответ: «enjoy». После do, does, did и их отрицательных форм основной глагол употребляется в начальной форме."}, "Use open after did not.": {"kk": "Дұрыс жауап: «open». Do, does, did және олардың болымсыз түрлерінен кейін негізгі етістік бастапқы тұлғада тұрады.", "ru": "Правильный ответ: «open». После do, does, did и их отрицательных форм основной глагол употребляется в начальной форме."}, "Does is followed by have, not has.": {"kk": "Дұрыс жауап: «have». Do, does, did және олардың болымсыз түрлерінен кейін негізгі етістік бастапқы тұлғада тұрады.", "ru": "Правильный ответ: «have». После do, does, did и их отрицательных форм основной глагол употребляется в начальной форме."}, "Use the base form wear after do not.": {"kk": "Дұрыс жауап: «wear». Do, does, did және олардың болымсыз түрлерінен кейін негізгі етістік бастапқы тұлғада тұрады.", "ru": "Правильный ответ: «wear». После do, does, did и их отрицательных форм основной глагол употребляется в начальной форме."}, "Forms of be": {"kk": "Be етістігінің тұлғалары", "ru": "Формы глагола be"}, "Match be to the subject and time: I am; he/she/it is; we/you/they are. In the past, use was with I/he/she/it and were with we/you/they.": {"kk": "Осы шақта: I am; he/she/it is; we/you/they are. Өткен шақта I/he/she/it үшін was, we/you/they үшін were қолданылады.", "ru": "В настоящем: I am; he/she/it is; we/you/they are. В прошлом: was с I/he/she/it и were с we/you/they."}, "The present form of be after I is am.": {"kk": "Дұрыс жауап: «am». Осы шақта: I am; he/she/it is; we/you/they are. Өткен шақта I/he/she/it үшін was, we/you/they үшін were қолданылады.", "ru": "Правильный ответ: «am». В настоящем: I am; he/she/it is; we/you/they are. В прошлом: was с I/he/she/it и were с we/you/they."}, "Use is with she in the present.": {"kk": "Дұрыс жауап: «is». Осы шақта: I am; he/she/it is; we/you/they are. Өткен шақта I/he/she/it үшін was, we/you/they үшін were қолданылады.", "ru": "Правильный ответ: «is». В настоящем: I am; he/she/it is; we/you/they are. В прошлом: was с I/he/she/it и were с we/you/they."}, "The students is plural, so use are.": {"kk": "Дұрыс жауап: «are». Осы шақта: I am; he/she/it is; we/you/they are. Өткен шақта I/he/she/it үшін was, we/you/they үшін were қолданылады.", "ru": "Правильный ответ: «are». В настоящем: I am; he/she/it is; we/you/they are. В прошлом: was с I/he/she/it и were с we/you/they."}, "My brother and I means we. Use are.": {"kk": "Дұрыс жауап: «are». Осы шақта: I am; he/she/it is; we/you/they are. Өткен шақта I/he/she/it үшін was, we/you/they үшін were қолданылады.", "ru": "Правильный ответ: «are». В настоящем: I am; he/she/it is; we/you/they are. В прошлом: was с I/he/she/it и were с we/you/they."}, "Last Sunday is past time. The past form with we is were.": {"kk": "Дұрыс жауап: «were». Осы шақта: I am; he/she/it is; we/you/they are. Өткен шақта I/he/she/it үшін was, we/you/they үшін were қолданылады.", "ru": "Правильный ответ: «were». В настоящем: I am; he/she/it is; we/you/they are. В прошлом: was с I/he/she/it и were с we/you/they."}, "Use was with he for a completed past situation.": {"kk": "Дұрыс жауап: «was». Осы шақта: I am; he/she/it is; we/you/they are. Өткен шақта I/he/she/it үшін was, we/you/they үшін were қолданылады.", "ru": "Правильный ответ: «was». В настоящем: I am; he/she/it is; we/you/they are. В прошлом: was с I/he/she/it и were с we/you/they."}, "These shoes is plural. Use are.": {"kk": "Дұрыс жауап: «are». Осы шақта: I am; he/she/it is; we/you/they are. Өткен шақта I/he/she/it үшін was, we/you/they үшін were қолданылады.", "ru": "Правильный ответ: «are». В настоящем: I am; he/she/it is; we/you/they are. В прошлом: was с I/he/she/it и were с we/you/they."}, "Yesterday requires past tense. Use were with the boys.": {"kk": "Дұрыс жауап: «were». Осы шақта: I am; he/she/it is; we/you/they are. Өткен шақта I/he/she/it үшін was, we/you/they үшін were қолданылады.", "ru": "Правильный ответ: «were». В настоящем: I am; he/she/it is; we/you/they are. В прошлом: was с I/he/she/it и were с we/you/they."}, "Everyone takes a singular verb: is.": {"kk": "Дұрыс жауап: «is». Осы шақта: I am; he/she/it is; we/you/they are. Өткен шақта I/he/she/it үшін was, we/you/they үшін were қолданылады.", "ru": "Правильный ответ: «is». В настоящем: I am; he/she/it is; we/you/they are. В прошлом: was с I/he/she/it и were с we/you/they."}, "Neither answer refers to each answer separately and takes is.": {"kk": "Дұрыс жауап: «is». Осы шақта: I am; he/she/it is; we/you/they are. Өткен шақта I/he/she/it үшін was, we/you/they үшін were қолданылады.", "ru": "Правильный ответ: «is». В настоящем: I am; he/she/it is; we/you/they are. В прошлом: was с I/he/she/it и were с we/you/they."}, "Have, has and there is / are": {"kk": "Have, has және there is / are", "ru": "Have, has и there is / are"}, "Use has with he/she/it or a singular subject; use have with I/you/we/they. Use there is for one thing and there are for more than one.": {"kk": "He/she/it және жекеше бастауышпен has, қалғандарымен have қолданылады. Бір затпен there is, бірнеше затпен there are болады.", "ru": "С he/she/it и единственным числом используется has, с остальными — have. There is употребляется с одним предметом, there are — с несколькими."}, "My dog is singular. Use has.": {"kk": "Дұрыс жауап: «has». He/she/it және жекеше бастауышпен has, қалғандарымен have қолданылады. Бір затпен there is, бірнеше затпен there are болады.", "ru": "Правильный ответ: «has». С he/she/it и единственным числом используется has, с остальными — have. There is употребляется с одним предметом, there are — с несколькими."}, "My sister is singular. Use has.": {"kk": "Дұрыс жауап: «has». He/she/it және жекеше бастауышпен has, қалғандарымен have қолданылады. Бір затпен there is, бірнеше затпен there are болады.", "ru": "Правильный ответ: «has». С he/she/it и единственным числом используется has, с остальными — have. There is употребляется с одним предметом, there are — с несколькими."}, "The students is plural. Use have.": {"kk": "Дұрыс жауап: «have». He/she/it және жекеше бастауышпен has, қалғандарымен have қолданылады. Бір затпен there is, бірнеше затпен there are болады.", "ru": "Правильный ответ: «have». С he/she/it и единственным числом используется has, с остальными — have. There is употребляется с одним предметом, there are — с несколькими."}, "My parents is plural. Use have.": {"kk": "Дұрыс жауап: «have». He/she/it және жекеше бастауышпен has, қалғандарымен have қолданылады. Бір затпен there is, бірнеше затпен there are болады.", "ru": "Правильный ответ: «have». С he/she/it и единственным числом используется has, с остальными — have. There is употребляется с одним предметом, there are — с несколькими."}, "A book is one thing. Use there is.": {"kk": "Дұрыс жауап: «is». He/she/it және жекеше бастауышпен has, қалғандарымен have қолданылады. Бір затпен there is, бірнеше затпен there are болады.", "ru": "Правильный ответ: «is». С he/she/it и единственным числом используется has, с остальными — have. There is употребляется с одним предметом, there are — с несколькими."}, "Two windows is plural. Use there are.": {"kk": "Дұрыс жауап: «are». He/she/it және жекеше бастауышпен has, қалғандарымен have қолданылады. Бір затпен there is, бірнеше затпен there are болады.", "ru": "Правильный ответ: «are». С he/she/it и единственным числом используется has, с остальными — have. There is употребляется с одним предметом, there are — с несколькими."}, "Use have with I.": {"kk": "Дұрыс жауап: «have». He/she/it және жекеше бастауышпен has, қалғандарымен have қолданылады. Бір затпен there is, бірнеше затпен there are болады.", "ru": "Правильный ответ: «have». С he/she/it и единственным числом используется has, с остальными — have. There is употребляется с одним предметом, there are — с несколькими."}, "The classroom is one room. Use has.": {"kk": "Дұрыс жауап: «has». He/she/it және жекеше бастауышпен has, қалғандарымен have қолданылады. Бір затпен there is, бірнеше затпен there are болады.", "ru": "Правильный ответ: «has». С he/she/it и единственным числом используется has, с остальными — have. There is употребляется с одним предметом, there are — с несколькими."}, "Milk is uncountable. Use there is.": {"kk": "Дұрыс жауап: «is». He/she/it және жекеше бастауышпен has, қалғандарымен have қолданылады. Бір затпен there is, бірнеше затпен there are болады.", "ru": "Правильный ответ: «is». С he/she/it и единственным числом используется has, с остальными — have. There is употребляется с одним предметом, there are — с несколькими."}, "People is plural. Use there are.": {"kk": "Дұрыс жауап: «are». He/she/it және жекеше бастауышпен has, қалғандарымен have қолданылады. Бір затпен there is, бірнеше затпен there are болады.", "ru": "Правильный ответ: «are». С he/she/it и единственным числом используется has, с остальными — have. There is употребляется с одним предметом, there are — с несколькими."}, "Completed past actions": {"kk": "Аяқталған өткен әрекет", "ru": "Завершённые действия в прошлом"}, "Use the past simple for completed actions at a past time. Regular verbs end in -ed; some verbs have irregular past forms.": {"kk": "Аяқталған өткен әрекет үшін Past Simple қолданылады. Дұрыс етістіктерге -ed жалғанады, бұрыс етістіктердің тұлғасын есте сақтау қажет.", "ru": "Для завершённых действий в прошлом используется Past Simple. К правильным глаголам добавляется -ed, формы неправильных нужно запомнить."}, "Yesterday is a finished past time. Use visited.": {"kk": "Дұрыс жауап: «visited». Аяқталған өткен әрекет үшін Past Simple қолданылады. Дұрыс етістіктерге -ed жалғанады, бұрыс етістіктердің тұлғасын есте сақтау қажет.", "ru": "Правильный ответ: «visited». Для завершённых действий в прошлом используется Past Simple. К правильным глаголам добавляется -ed, формы неправильных нужно запомнить."}, "Last night is finished. Use the past form watched.": {"kk": "Дұрыс жауап: «watched». Аяқталған өткен әрекет үшін Past Simple қолданылады. Дұрыс етістіктерге -ed жалғанады, бұрыс етістіктердің тұлғасын есте сақтау қажет.", "ru": "Правильный ответ: «watched». Для завершённых действий в прошлом используется Past Simple. К правильным глаголам добавляется -ed, формы неправильных нужно запомнить."}, "Last week is past time. The past of write is wrote.": {"kk": "Дұрыс жауап: «wrote». Аяқталған өткен әрекет үшін Past Simple қолданылады. Дұрыс етістіктерге -ed жалғанады, бұрыс етістіктердің тұлғасын есте сақтау қажет.", "ru": "Правильный ответ: «wrote». Для завершённых действий в прошлом используется Past Simple. К правильным глаголам добавляется -ed, формы неправильных нужно запомнить."}, "Last summer is past time. The past of go is went.": {"kk": "Дұрыс жауап: «went». Аяқталған өткен әрекет үшін Past Simple қолданылады. Дұрыс етістіктерге -ed жалғанады, бұрыс етістіктердің тұлғасын есте сақтау қажет.", "ru": "Правильный ответ: «went». Для завершённых действий в прошлом используется Past Simple. К правильным глаголам добавляется -ed, формы неправильных нужно запомнить."}, "Ago refers to a completed past time. Find becomes found.": {"kk": "Дұрыс жауап: «found». Аяқталған өткен әрекет үшін Past Simple қолданылады. Дұрыс етістіктерге -ed жалғанады, бұрыс етістіктердің тұлғасын есте сақтау қажет.", "ru": "Правильный ответ: «found». Для завершённых действий в прошлом используется Past Simple. К правильным глаголам добавляется -ed, формы неправильных нужно запомнить."}, "Last winter is past time. Break becomes broke.": {"kk": "Дұрыс жауап: «broke». Аяқталған өткен әрекет үшін Past Simple қолданылады. Дұрыс етістіктерге -ed жалғанады, бұрыс етістіктердің тұлғасын есте сақтау қажет.", "ru": "Правильный ответ: «broke». Для завершённых действий в прошлом используется Past Simple. К правильным глаголам добавляется -ed, формы неправильных нужно запомнить."}, "Use the past form started with yesterday.": {"kk": "Дұрыс жауап: «started». Аяқталған өткен әрекет үшін Past Simple қолданылады. Дұрыс етістіктерге -ed жалғанады, бұрыс етістіктердің тұлғасын есте сақтау қажет.", "ru": "Правильный ответ: «started». Для завершённых действий в прошлом используется Past Simple. К правильным глаголам добавляется -ed, формы неправильных нужно запомнить."}, "The completed past time needs bought, the past of buy.": {"kk": "Дұрыс жауап: «bought». Аяқталған өткен әрекет үшін Past Simple қолданылады. Дұрыс етістіктерге -ed жалғанады, бұрыс етістіктердің тұлғасын есте сақтау қажет.", "ru": "Правильный ответ: «bought». Для завершённых действий в прошлом используется Past Simple. К правильным глаголам добавляется -ed, формы неправильных нужно запомнить."}, "The past form of have is had.": {"kk": "Дұрыс жауап: «had». Аяқталған өткен әрекет үшін Past Simple қолданылады. Дұрыс етістіктерге -ed жалғанады, бұрыс етістіктердің тұлғасын есте сақтау қажет.", "ru": "Правильный ответ: «had». Для завершённых действий в прошлом используется Past Simple. К правильным глаголам добавляется -ed, формы неправильных нужно запомнить."}, "A finished year calls for the past simple: moved.": {"kk": "Дұрыс жауап: «moved». Аяқталған өткен әрекет үшін Past Simple қолданылады. Дұрыс етістіктерге -ed жалғанады, бұрыс етістіктердің тұлғасын есте сақтау қажет.", "ru": "Правильный ответ: «moved». Для завершённых действий в прошлом используется Past Simple. К правильным глаголам добавляется -ed, формы неправильных нужно запомнить."}, "Actions happening now": {"kk": "Қазір жүріп жатқан әрекет", "ru": "Действия прямо сейчас"}, "For an action happening now, use am/is/are + verb-ing. Match the auxiliary to the subject.": {"kk": "Қазір жүріп жатқан әрекет үшін am/is/are + етістік-ing қолданылады. Көмекші етістікті бастауышқа сәйкестендір.", "ru": "Для действия прямо сейчас используется am/is/are + глагол-ing. Форма вспомогательного глагола зависит от подлежащего."}, "Look points to an action happening now. Use are playing.": {"kk": "Дұрыс жауап: «are playing». Қазір жүріп жатқан әрекет үшін am/is/are + етістік-ing қолданылады. Көмекші етістікті бастауышқа сәйкестендір.", "ru": "Правильный ответ: «are playing». Для действия прямо сейчас используется am/is/are + глагол-ing. Форма вспомогательного глагола зависит от подлежащего."}, "Now needs is sleeping for this ongoing action.": {"kk": "Дұрыс жауап: «is sleeping». Қазір жүріп жатқан әрекет үшін am/is/are + етістік-ing қолданылады. Көмекші етістікті бастауышқа сәйкестендір.", "ru": "Правильный ответ: «is sleeping». Для действия прямо сейчас используется am/is/are + глагол-ing. Форма вспомогательного глагола зависит от подлежащего."}, "At the moment describes an ongoing action: are writing.": {"kk": "Дұрыс жауап: «are writing». Қазір жүріп жатқан әрекет үшін am/is/are + етістік-ing қолданылады. Көмекші етістікті бастауышқа сәйкестендір.", "ru": "Правильный ответ: «are writing». Для действия прямо сейчас используется am/is/are + глагол-ing. Форма вспомогательного глагола зависит от подлежащего."}, "Listen points to what is happening now: is playing.": {"kk": "Дұрыс жауап: «is playing». Қазір жүріп жатқан әрекет үшін am/is/are + етістік-ing қолданылады. Көмекші етістікті бастауышқа сәйкестендір.", "ru": "Правильный ответ: «is playing». Для действия прямо сейчас используется am/is/are + глагол-ing. Форма вспомогательного глагола зависит от подлежащего."}, "Right now refers to an action in progress: is leaving.": {"kk": "Дұрыс жауап: «is leaving». Қазір жүріп жатқан әрекет үшін am/is/are + етістік-ing қолданылады. Көмекші етістікті бастауышқа сәйкестендір.", "ru": "Правильный ответ: «is leaving». Для действия прямо сейчас используется am/is/are + глагол-ing. Форма вспомогательного глагола зависит от подлежащего."}, "The action is happening in front of us: is drawing.": {"kk": "Дұрыс жауап: «is drawing». Қазір жүріп жатқан әрекет үшін am/is/are + етістік-ing қолданылады. Көмекші етістікті бастауышқа сәйкестендір.", "ru": "Правильный ответ: «is drawing». Для действия прямо сейчас используется am/is/are + глагол-ing. Форма вспомогательного глагола зависит от подлежащего."}, "Use am with I, followed by doing.": {"kk": "Дұрыс жауап: «am doing». Қазір жүріп жатқан әрекет үшін am/is/are + етістік-ing қолданылады. Көмекші етістікті бастауышқа сәйкестендір.", "ru": "Правильный ответ: «am doing». Для действия прямо сейчас используется am/is/are + глагол-ing. Форма вспомогательного глагола зависит от подлежащего."}, "The children is plural. Use are making.": {"kk": "Дұрыс жауап: «are making». Қазір жүріп жатқан әрекет үшін am/is/are + етістік-ing қолданылады. Көмекші етістікті бастауышқа сәйкестендір.", "ru": "Правильный ответ: «are making». Для действия прямо сейчас используется am/is/are + глагол-ing. Форма вспомогательного глагола зависит от подлежащего."}, "Now identifies the ongoing action: am talking.": {"kk": "Дұрыс жауап: «am talking». Қазір жүріп жатқан әрекет үшін am/is/are + етістік-ing қолданылады. Көмекші етістікті бастауышқа сәйкестендір.", "ru": "Правильный ответ: «am talking». Для действия прямо сейчас используется am/is/are + глагол-ing. Форма вспомогательного глагола зависит от подлежащего."}, "For the action she is doing now, use is cooking.": {"kk": "Дұрыс жауап: «is cooking». Қазір жүріп жатқан әрекет үшін am/is/are + етістік-ing қолданылады. Көмекші етістікті бастауышқа сәйкестендір.", "ru": "Правильный ответ: «is cooking». Для действия прямо сейчас используется am/is/are + глагол-ing. Форма вспомогательного глагола зависит от подлежащего."}, "Actions in progress in the past": {"kk": "Өткен сәтте жүріп жатқан әрекет", "ru": "Действие в процессе в прошлом"}, "Use was/were + verb-ing for an action in progress at a past moment. A shorter event can interrupt it.": {"kk": "Өткен уақыттың белгілі сәтінде жүріп жатқан әрекет was/were + етістік-ing арқылы беріледі. Қысқа оқиға оны бөлуі мүмкін.", "ru": "Действие в процессе в определённый момент прошлого выражается через was/were + глагол-ing. Его может прерывать короткое событие."}, "At a specific past moment, use were playing.": {"kk": "Дұрыс жауап: «were playing». Өткен уақыттың белгілі сәтінде жүріп жатқан әрекет was/were + етістік-ing арқылы беріледі. Қысқа оқиға оны бөлуі мүмкін.", "ru": "Правильный ответ: «were playing». Действие в процессе в определённый момент прошлого выражается через was/were + глагол-ing. Его может прерывать короткое событие."}, "At a past moment, use was cooking with she.": {"kk": "Дұрыс жауап: «was cooking». Өткен уақыттың белгілі сәтінде жүріп жатқан әрекет was/were + етістік-ing арқылы беріледі. Қысқа оқиға оны бөлуі мүмкін.", "ru": "Правильный ответ: «was cooking». Действие в процессе в определённый момент прошлого выражается через was/were + глагол-ing. Его может прерывать короткое событие."}, "The shower was in progress when the phone rang.": {"kk": "Дұрыс жауап: «was taking». Өткен уақыттың белгілі сәтінде жүріп жатқан әрекет was/were + етістік-ing арқылы беріледі. Қысқа оқиға оны бөлуі мүмкін.", "ru": "Правильный ответ: «was taking». Действие в процессе в определённый момент прошлого выражается через was/were + глагол-ing. Его может прерывать короткое событие."}, "The homework was in progress when the lights went out.": {"kk": "Дұрыс жауап: «was doing». Өткен уақыттың белгілі сәтінде жүріп жатқан әрекет was/were + етістік-ing арқылы беріледі. Қысқа оқиға оны бөлуі мүмкін.", "ru": "Правильный ответ: «was doing». Действие в процессе в определённый момент прошлого выражается через was/were + глагол-ing. Его может прерывать короткое событие."}, "Two ongoing past actions can use the past continuous.": {"kk": "Дұрыс жауап: «was watching». Өткен уақыттың белгілі сәтінде жүріп жатқан әрекет was/were + етістік-ing арқылы беріледі. Қысқа оқиға оны бөлуі мүмкін.", "ru": "Правильный ответ: «was watching». Действие в процессе в определённый момент прошлого выражается через was/were + глагол-ing. Его может прерывать короткое событие."}, "The actions were happening together in the past. Use were setting.": {"kk": "Дұрыс жауап: «were setting». Өткен уақыттың белгілі сәтінде жүріп жатқан әрекет was/were + етістік-ing арқылы беріледі. Қысқа оқиға оны бөлуі мүмкін.", "ru": "Правильный ответ: «were setting». Действие в процессе в определённый момент прошлого выражается через was/were + глагол-ing. Его может прерывать короткое событие."}, "Use was studying for an action in progress at that past time.": {"kk": "Дұрыс жауап: «was studying». Өткен уақыттың белгілі сәтінде жүріп жатқан әрекет was/were + етістік-ing арқылы беріледі. Қысқа оқиға оны бөлуі мүмкін.", "ru": "Правильный ответ: «was studying». Действие в процессе в определённый момент прошлого выражается через was/were + глагол-ing. Его может прерывать короткое событие."}, "The walk was in progress when the rain started.": {"kk": "Дұрыс жауап: «were walking». Өткен уақыттың белгілі сәтінде жүріп жатқан әрекет was/were + етістік-ing арқылы беріледі. Қысқа оқиға оны бөлуі мүмкін.", "ru": "Правильный ответ: «were walking». Действие в процессе в определённый момент прошлого выражается через was/were + глагол-ing. Его может прерывать короткое событие."}, "The listening was in progress at the time of the doorbell.": {"kk": "Дұрыс жауап: «was listening to». Өткен уақыттың белгілі сәтінде жүріп жатқан әрекет was/were + етістік-ing арқылы беріледі. Қысқа оқиға оны бөлуі мүмкін.", "ru": "Правильный ответ: «was listening to». Действие в процессе в определённый момент прошлого выражается через was/were + глагол-ing. Его может прерывать короткое событие."}, "At this time yesterday calls for the past continuous.": {"kk": "Дұрыс жауап: «were sitting». Өткен уақыттың белгілі сәтінде жүріп жатқан әрекет was/were + етістік-ing арқылы беріледі. Қысқа оқиға оны бөлуі мүмкін.", "ru": "Правильный ответ: «were sitting». Действие в процессе в определённый момент прошлого выражается через was/were + глагол-ing. Его может прерывать короткое событие."}, "Experience and recent results": {"kk": "Тәжірибе және қазіргі нәтиже", "ru": "Опыт и результат к настоящему"}, "Use have/has + past participle for experiences or past actions linked to now. Words such as ever, never, just, already and yet often help.": {"kk": "Тәжірибе немесе қазіргі уақытпен байланысты өткен әрекет have/has + past participle арқылы беріледі. Ever, never, just, already, yet сөздеріне назар аудар.", "ru": "Для опыта или прошлого действия, связанного с настоящим, используется have/has + третья форма глагола. Обращай внимание на ever, never, just, already, yet."}, "Has needs the past participle been.": {"kk": "Дұрыс жауап: «been». Тәжірибе немесе қазіргі уақытпен байланысты өткен әрекет have/has + past participle арқылы беріледі. Ever, never, just, already, yet сөздеріне назар аудар.", "ru": "Правильный ответ: «been». Для опыта или прошлого действия, связанного с настоящим, используется have/has + третья форма глагола. Обращай внимание на ever, never, just, already, yet."}, "Have needs the past participle seen.": {"kk": "Дұрыс жауап: «seen». Тәжірибе немесе қазіргі уақытпен байланысты өткен әрекет have/has + past participle арқылы беріледі. Ever, never, just, already, yet сөздеріне назар аудар.", "ru": "Правильный ответ: «seen». Для опыта или прошлого действия, связанного с настоящим, используется have/has + третья форма глагола. Обращай внимание на ever, never, just, already, yet."}, "Use have + past participle: finished.": {"kk": "Дұрыс жауап: «finished». Тәжірибе немесе қазіргі уақытпен байланысты өткен әрекет have/has + past participle арқылы беріледі. Ever, never, just, already, yet сөздеріне назар аудар.", "ru": "Правильный ответ: «finished». Для опыта или прошлого действия, связанного с настоящим, используется have/has + третья форма глагола. Обращай внимание на ever, never, just, already, yet."}, "Have not needs the past participle done.": {"kk": "Дұрыс жауап: «done». Тәжірибе немесе қазіргі уақытпен байланысты өткен әрекет have/has + past participle арқылы беріледі. Ever, never, just, already, yet сөздеріне назар аудар.", "ru": "Правильный ответ: «done». Для опыта или прошлого действия, связанного с настоящим, используется have/has + третья форма глагола. Обращай внимание на ever, never, just, already, yet."}, "The past participle of come is also come.": {"kk": "Дұрыс жауап: «come». Тәжірибе немесе қазіргі уақытпен байланысты өткен әрекет have/has + past participle арқылы беріледі. Ever, never, just, already, yet сөздеріне назар аудар.", "ru": "Правильный ответ: «come». Для опыта или прошлого действия, связанного с настоящим, используется have/has + третья форма глагола. Обращай внимание на ever, never, just, already, yet."}, "Has needs the past participle sent.": {"kk": "Дұрыс жауап: «sent». Тәжірибе немесе қазіргі уақытпен байланысты өткен әрекет have/has + past participle арқылы беріледі. Ever, never, just, already, yet сөздеріне назар аудар.", "ru": "Правильный ответ: «sent». Для опыта или прошлого действия, связанного с настоящим, используется have/has + третья форма глагола. Обращай внимание на ever, never, just, already, yet."}, "The past participle of ride is ridden.": {"kk": "Дұрыс жауап: «ridden». Тәжірибе немесе қазіргі уақытпен байланысты өткен әрекет have/has + past participle арқылы беріледі. Ever, never, just, already, yet сөздеріне назар аудар.", "ru": "Правильный ответ: «ridden». Для опыта или прошлого действия, связанного с настоящим, используется have/has + третья форма глагола. Обращай внимание на ever, never, just, already, yet."}, "Have never is followed by the past participle played.": {"kk": "Дұрыс жауап: «played». Тәжірибе немесе қазіргі уақытпен байланысты өткен әрекет have/has + past participle арқылы беріледі. Ever, never, just, already, yet сөздеріне назар аудар.", "ru": "Правильный ответ: «played». Для опыта или прошлого действия, связанного с настоящим, используется have/has + третья форма глагола. Обращай внимание на ever, never, just, already, yet."}, "The past participle of find is found.": {"kk": "Дұрыс жауап: «found». Тәжірибе немесе қазіргі уақытпен байланысты өткен әрекет have/has + past participle арқылы беріледі. Ever, never, just, already, yet сөздеріне назар аудар.", "ru": "Правильный ответ: «found». Для опыта или прошлого действия, связанного с настоящим, используется have/has + третья форма глагола. Обращай внимание на ever, never, just, already, yet."}, "Has needs the past participle lost.": {"kk": "Дұрыс жауап: «lost». Тәжірибе немесе қазіргі уақытпен байланысты өткен әрекет have/has + past participle арқылы беріледі. Ever, never, just, already, yet сөздеріне назар аудар.", "ru": "Правильный ответ: «lost». Для опыта или прошлого действия, связанного с настоящим, используется have/has + третья форма глагола. Обращай внимание на ever, never, just, already, yet."}, "Make and do": {"kk": "Make және do", "ru": "Make и do"}, "Learn these combinations as whole phrases: do homework, do your best, make a decision, make a mistake, make your bed and make friends.": {"kk": "Тіркестерді тұтас үйрен: do homework, do your best, make a decision, make a mistake, make your bed, make friends.", "ru": "Запоминай сочетания целиком: do homework, do your best, make a decision, make a mistake, make your bed, make friends."}, "The fixed combination is do homework.": {"kk": "Дұрыс жауап: «do». Тіркестерді тұтас үйрен: do homework, do your best, make a decision, make a mistake, make your bed, make friends.", "ru": "Правильный ответ: «do». Запоминай сочетания целиком: do homework, do your best, make a decision, make a mistake, make your bed, make friends."}, "Use do with homework.": {"kk": "Дұрыс жауап: «do». Тіркестерді тұтас үйрен: do homework, do your best, make a decision, make a mistake, make your bed, make friends.", "ru": "Правильный ответ: «do». Запоминай сочетания целиком: do homework, do your best, make a decision, make a mistake, make your bed, make friends."}, "The standard combination here is make a decision.": {"kk": "Дұрыс жауап: «make». Тіркестерді тұтас үйрен: do homework, do your best, make a decision, make a mistake, make your bed, make friends.", "ru": "Правильный ответ: «make». Запоминай сочетания целиком: do homework, do your best, make a decision, make a mistake, make your bed, make friends."}, "Use make with a mistake.": {"kk": "Дұрыс жауап: «make». Тіркестерді тұтас үйрен: do homework, do your best, make a decision, make a mistake, make your bed, make friends.", "ru": "Правильный ответ: «make». Запоминай сочетания целиком: do homework, do your best, make a decision, make a mistake, make your bed, make friends."}, "Make friends means form friendships.": {"kk": "Дұрыс жауап: «make». Тіркестерді тұтас үйрен: do homework, do your best, make a decision, make a mistake, make your bed, make friends.", "ru": "Правильный ответ: «make». Запоминай сочетания целиком: do homework, do your best, make a decision, make a mistake, make your bed, make friends."}, "Make your bed means arrange the bedding neatly.": {"kk": "Дұрыс жауап: «make». Тіркестерді тұтас үйрен: do homework, do your best, make a decision, make a mistake, make your bed, make friends.", "ru": "Правильный ответ: «make». Запоминай сочетания целиком: do homework, do your best, make a decision, make a mistake, make your bed, make friends."}, "The fixed phrase is do your best.": {"kk": "Дұрыс жауап: «do». Тіркестерді тұтас үйрен: do homework, do your best, make a decision, make a mistake, make your bed, make friends.", "ru": "Правильный ответ: «do». Запоминай сочетания целиком: do homework, do your best, make a decision, make a mistake, make your bed, make friends."}, "Use make a plan.": {"kk": "Дұрыс жауап: «make». Тіркестерді тұтас үйрен: do homework, do your best, make a decision, make a mistake, make your bed, make friends.", "ru": "Правильный ответ: «make». Запоминай сочетания целиком: do homework, do your best, make a decision, make a mistake, make your bed, make friends."}, "The fixed phrase is do the washing-up.": {"kk": "Дұрыс жауап: «do». Тіркестерді тұтас үйрен: do homework, do your best, make a decision, make a mistake, make your bed, make friends.", "ru": "Правильный ответ: «do». Запоминай сочетания целиком: do homework, do your best, make a decision, make a mistake, make your bed, make friends."}, "The fixed combination is make noise.": {"kk": "Дұрыс жауап: «make». Тіркестерді тұтас үйрен: do homework, do your best, make a decision, make a mistake, make your bed, make friends.", "ru": "Правильный ответ: «make». Запоминай сочетания целиком: do homework, do your best, make a decision, make a mistake, make your bed, make friends."}, "Take and get": {"kk": "Take және get", "ru": "Take и get"}, "Learn action phrases together: take a photo, take a break, take notes, take part and get enough sleep.": {"kk": "Тіркестерді тұтас үйрен: take a photo, take a break, take notes, take part, get enough sleep.", "ru": "Запоминай сочетания: take a photo, take a break, take notes, take part, get enough sleep."}, "The fixed phrase is take a photo.": {"kk": "Дұрыс жауап: «take». Тіркестерді тұтас үйрен: take a photo, take a break, take notes, take part, get enough sleep.", "ru": "Правильный ответ: «take». Запоминай сочетания: take a photo, take a break, take notes, take part, get enough sleep."}, "Use take with a photo.": {"kk": "Дұрыс жауап: «take». Тіркестерді тұтас үйрен: take a photo, take a break, take notes, take part, get enough sleep.", "ru": "Правильный ответ: «take». Запоминай сочетания: take a photo, take a break, take notes, take part, get enough sleep."}, "The fixed phrase is take a break.": {"kk": "Дұрыс жауап: «take». Тіркестерді тұтас үйрен: take a photo, take a break, take notes, take part, get enough sleep.", "ru": "Правильный ответ: «take». Запоминай сочетания: take a photo, take a break, take notes, take part, get enough sleep."}, "Take notes means write down the main points.": {"kk": "Дұрыс жауап: «take». Тіркестерді тұтас үйрен: take a photo, take a break, take notes, take part, get enough sleep.", "ru": "Правильный ответ: «take». Запоминай сочетания: take a photo, take a break, take notes, take part, get enough sleep."}, "The fixed phrase is take part in.": {"kk": "Дұрыс жауап: «take». Тіркестерді тұтас үйрен: take a photo, take a break, take notes, take part, get enough sleep.", "ru": "Правильный ответ: «take». Запоминай сочетания: take a photo, take a break, take notes, take part, get enough sleep."}, "Use get enough sleep.": {"kk": "Дұрыс жауап: «get». Тіркестерді тұтас үйрен: take a photo, take a break, take notes, take part, get enough sleep.", "ru": "Правильный ответ: «get». Запоминай сочетания: take a photo, take a break, take notes, take part, get enough sleep."}, "Take the bus means travel on it.": {"kk": "Дұрыс жауап: «take». Тіркестерді тұтас үйрен: take a photo, take a break, take notes, take part, get enough sleep.", "ru": "Правильный ответ: «take». Запоминай сочетания: take a photo, take a break, take notes, take part, get enough sleep."}, "Get a cold means become ill with a cold.": {"kk": "Дұрыс жауап: «get». Тіркестерді тұтас үйрен: take a photo, take a break, take notes, take part, get enough sleep.", "ru": "Правильный ответ: «get». Запоминай сочетания: take a photo, take a break, take notes, take part, get enough sleep."}, "The fixed phrase is get some rest.": {"kk": "Дұрыс жауап: «get». Тіркестерді тұтас үйрен: take a photo, take a break, take notes, take part, get enough sleep.", "ru": "Правильный ответ: «get». Запоминай сочетания: take a photo, take a break, take notes, take part, get enough sleep."}, "Take a seat is a polite way to ask someone to sit down.": {"kk": "Дұрыс жауап: «take». Тіркестерді тұтас үйрен: take a photo, take a break, take notes, take part, get enough sleep.", "ru": "Правильный ответ: «take». Запоминай сочетания: take a photo, take a break, take notes, take part, get enough sleep."}, "Communication phrases": {"kk": "Қарым-қатынас тіркестері", "ru": "Сочетания для общения"}, "Use tell the truth, ask a question, give advice, send an email, pay attention and keep a promise.": {"kk": "Tell the truth, ask a question, give advice, send an email, pay attention, keep a promise тіркестерін есте сақта.", "ru": "Запомни сочетания tell the truth, ask a question, give advice, send an email, pay attention, keep a promise."}, "The fixed phrase is tell the truth.": {"kk": "Дұрыс жауап: «tell». Tell the truth, ask a question, give advice, send an email, pay attention, keep a promise тіркестерін есте сақта.", "ru": "Правильный ответ: «tell». Запомни сочетания tell the truth, ask a question, give advice, send an email, pay attention, keep a promise."}, "Use ask with a question.": {"kk": "Дұрыс жауап: «ask». Tell the truth, ask a question, give advice, send an email, pay attention, keep a promise тіркестерін есте сақта.", "ru": "Правильный ответ: «ask». Запомни сочетания tell the truth, ask a question, give advice, send an email, pay attention, keep a promise."}, "The fixed phrase is give someone advice.": {"kk": "Дұрыс жауап: «give». Tell the truth, ask a question, give advice, send an email, pay attention, keep a promise тіркестерін есте сақта.", "ru": "Правильный ответ: «give». Запомни сочетания tell the truth, ask a question, give advice, send an email, pay attention, keep a promise."}, "Use send with an email.": {"kk": "Дұрыс жауап: «send». Tell the truth, ask a question, give advice, send an email, pay attention, keep a promise тіркестерін есте сақта.", "ru": "Правильный ответ: «send». Запомни сочетания tell the truth, ask a question, give advice, send an email, pay attention, keep a promise."}, "The fixed phrase is pay attention to.": {"kk": "Дұрыс жауап: «pay». Tell the truth, ask a question, give advice, send an email, pay attention, keep a promise тіркестерін есте сақта.", "ru": "Правильный ответ: «pay». Запомни сочетания tell the truth, ask a question, give advice, send an email, pay attention, keep a promise."}, "Keep a promise means do what you promised.": {"kk": "Дұрыс жауап: «keep». Tell the truth, ask a question, give advice, send an email, pay attention, keep a promise тіркестерін есте сақта.", "ru": "Правильный ответ: «keep». Запомни сочетания tell the truth, ask a question, give advice, send an email, pay attention, keep a promise."}, "Give someone a hand means help them.": {"kk": "Дұрыс жауап: «give». Tell the truth, ask a question, give advice, send an email, pay attention, keep a promise тіркестерін есте сақта.", "ru": "Правильный ответ: «give». Запомни сочетания tell the truth, ask a question, give advice, send an email, pay attention, keep a promise."}, "Use show someone the way.": {"kk": "Дұрыс жауап: «show». Tell the truth, ask a question, give advice, send an email, pay attention, keep a promise тіркестерін есте сақта.", "ru": "Правильный ответ: «show». Запомни сочетания tell the truth, ask a question, give advice, send an email, pay attention, keep a promise."}, "Tell can be followed by a person directly: tell me.": {"kk": "Дұрыс жауап: «tell». Tell the truth, ask a question, give advice, send an email, pay attention, keep a promise тіркестерін есте сақта.", "ru": "Правильный ответ: «tell». Запомни сочетания tell the truth, ask a question, give advice, send an email, pay attention, keep a promise."}, "Discuss takes the topic directly: discuss this problem.": {"kk": "Дұрыс жауап: «discuss». Tell the truth, ask a question, give advice, send an email, pay attention, keep a promise тіркестерін есте сақта.", "ru": "Правильный ответ: «discuss». Запомни сочетания tell the truth, ask a question, give advice, send an email, pay attention, keep a promise."}, "Study and everyday phrases": {"kk": "Оқу және күнделікті тіркестер", "ru": "Учебные и повседневные сочетания"}, "Learn common combinations: solve a problem, follow the rules, save money, protect the environment and win a match.": {"kk": "Solve a problem, follow the rules, save money, protect the environment, win a match тіркестерін үйрен.", "ru": "Изучи сочетания solve a problem, follow the rules, save money, protect the environment, win a match."}, "Use solve with a problem.": {"kk": "Дұрыс жауап: «solve». Solve a problem, follow the rules, save money, protect the environment, win a match тіркестерін үйрен.", "ru": "Правильный ответ: «solve». Изучи сочетания solve a problem, follow the rules, save money, protect the environment, win a match."}, "Follow the rules means act according to them.": {"kk": "Дұрыс жауап: «follow». Solve a problem, follow the rules, save money, protect the environment, win a match тіркестерін үйрен.", "ru": "Правильный ответ: «follow». Изучи сочетания solve a problem, follow the rules, save money, protect the environment, win a match."}, "Win a match; beat an opponent.": {"kk": "Дұрыс жауап: «win». Solve a problem, follow the rules, save money, protect the environment, win a match тіркестерін үйрен.", "ru": "Правильный ответ: «win». Изучи сочетания solve a problem, follow the rules, save money, protect the environment, win a match."}, "The fixed phrase is break a record.": {"kk": "Дұрыс жауап: «break». Solve a problem, follow the rules, save money, protect the environment, win a match тіркестерін үйрен.", "ru": "Правильный ответ: «break». Изучи сочетания solve a problem, follow the rules, save money, protect the environment, win a match."}, "Save energy means avoid wasting it.": {"kk": "Дұрыс жауап: «save». Solve a problem, follow the rules, save money, protect the environment, win a match тіркестерін үйрен.", "ru": "Правильный ответ: «save». Изучи сочетания solve a problem, follow the rules, save money, protect the environment, win a match."}, "Protect the environment means keep it safe from harm.": {"kk": "Дұрыс жауап: «protect». Solve a problem, follow the rules, save money, protect the environment, win a match тіркестерін үйрен.", "ru": "Правильный ответ: «protect». Изучи сочетания solve a problem, follow the rules, save money, protect the environment, win a match."}, "Putting money aside means saving it.": {"kk": "Дұрыс жауап: «save». Solve a problem, follow the rules, save money, protect the environment, win a match тіркестерін үйрен.", "ru": "Правильный ответ: «save». Изучи сочетания solve a problem, follow the rules, save money, protect the environment, win a match."}, "Use a dictionary means look up information in it.": {"kk": "Дұрыс жауап: «use». Solve a problem, follow the rules, save money, protect the environment, win a match тіркестерін үйрен.", "ru": "Правильный ответ: «use». Изучи сочетания solve a problem, follow the rules, save money, protect the environment, win a match."}, "The fixed phrase is fasten your seat belt.": {"kk": "Дұрыс жауап: «fasten». Solve a problem, follow the rules, save money, protect the environment, win a match тіркестерін үйрен.", "ru": "Правильный ответ: «fasten». Изучи сочетания solve a problem, follow the rules, save money, protect the environment, win a match."}, "Use improve with pronunciation.": {"kk": "Дұрыс жауап: «improve». Solve a problem, follow the rules, save money, protect the environment, win a match тіркестерін үйрен.", "ru": "Правильный ответ: «improve». Изучи сочетания solve a problem, follow the rules, save money, protect the environment, win a match."}, "At, on and in for time": {"kk": "Уақытпен at, on және in", "ru": "At, on и in для времени"}, "Use at with clock times, on with days and dates, and in with months and years. Learn at night and in the morning as phrases.": {"kk": "At — нақты сағатпен, on — күндер мен даталармен, in — айлар мен жылдармен қолданылады. At night, in the morning тіркестерін есте сақта.", "ru": "At используется со временем на часах, on — с днями и датами, in — с месяцами и годами. Запомни at night и in the morning."}, "Use at with a clock time.": {"kk": "Нақты сағатпен at қолданылады.", "ru": "Со временем на часах используется at."}, "Use on with a day of the week.": {"kk": "Дұрыс жауап: «on». At — нақты сағатпен, on — күндер мен даталармен, in — айлар мен жылдармен қолданылады. At night, in the morning тіркестерін есте сақта.", "ru": "Правильный ответ: «on». At используется со временем на часах, on — с днями и датами, in — с месяцами и годами. Запомни at night и in the morning."}, "Use on with a particular day or its evening.": {"kk": "Дұрыс жауап: «on». At — нақты сағатпен, on — күндер мен даталармен, in — айлар мен жылдармен қолданылады. At night, in the morning тіркестерін есте сақта.", "ru": "Правильный ответ: «on». At используется со временем на часах, on — с днями и датами, in — с месяцами и годами. Запомни at night и in the morning."}, "Use in with a month.": {"kk": "Дұрыс жауап: «in». At — нақты сағатпен, on — күндер мен даталармен, in — айлар мен жылдармен қолданылады. At night, in the morning тіркестерін есте сақта.", "ru": "Правильный ответ: «in». At используется со временем на часах, on — с днями и датами, in — с месяцами и годами. Запомни at night и in the morning."}, "Use in with a year.": {"kk": "Дұрыс жауап: «in». At — нақты сағатпен, on — күндер мен даталармен, in — айлар мен жылдармен қолданылады. At night, in the morning тіркестерін есте сақта.", "ru": "Правильный ответ: «in». At используется со временем на часах, on — с днями и датами, in — с месяцами и годами. Запомни at night и in the morning."}, "The fixed time phrase is in the evening.": {"kk": "Дұрыс жауап: «in». At — нақты сағатпен, on — күндер мен даталармен, in — айлар мен жылдармен қолданылады. At night, in the morning тіркестерін есте сақта.", "ru": "Правильный ответ: «in». At используется со временем на часах, on — с днями и датами, in — с месяцами и годами. Запомни at night и in the morning."}, "The fixed time phrase is at night.": {"kk": "Дұрыс жауап: «at». At — нақты сағатпен, on — күндер мен даталармен, in — айлар мен жылдармен қолданылады. At night, in the morning тіркестерін есте сақта.", "ru": "Правильный ответ: «at». At используется со временем на часах, on — с днями и датами, in — с месяцами и годами. Запомни at night и in the morning."}, "Use on with a full date.": {"kk": "Дұрыс жауап: «on». At — нақты сағатпен, on — күндер мен даталармен, in — айлар мен жылдармен қолданылады. At night, in the morning тіркестерін есте сақта.", "ru": "Правильный ответ: «on». At используется со временем на часах, on — с днями и датами, in — с месяцами и годами. Запомни at night и in the morning."}, "Place and movement": {"kk": "Орын және қозғалыс", "ru": "Место и движение"}, "Use in for something inside, on for a surface, to for a destination and across for movement from one side to the other. Learn arrive at a place and arrive in a city or country.": {"kk": "In — ішінде, on — бетінде, to — бағыт, across — бір шетінен екіншісіне. Arrive at нақты орынмен, arrive in қала не елмен қолданылады.", "ru": "In — внутри, on — на поверхности, to — направление, across — с одной стороны на другую. Arrive at — с конкретным местом, arrive in — с городом или страной."}, "A schoolbag contains the books. Use in.": {"kk": "Дұрыс жауап: «in». In — ішінде, on — бетінде, to — бағыт, across — бір шетінен екіншісіне. Arrive at нақты орынмен, arrive in қала не елмен қолданылады.", "ru": "Правильный ответ: «in». In — внутри, on — на поверхности, to — направление, across — с одной стороны на другую. Arrive at — с конкретным местом, arrive in — с городом или страной."}, "A picture is on the surface of the wall.": {"kk": "Дұрыс жауап: «on». In — ішінде, on — бетінде, to — бағыт, across — бір шетінен екіншісіне. Arrive at нақты орынмен, arrive in қала не елмен қолданылады.", "ru": "Правильный ответ: «on». In — внутри, on — на поверхности, to — направление, across — с одной стороны на другую. Arrive at — с конкретным местом, arrive in — с городом или страной."}, "Use arrive at with a specific place such as an airport.": {"kk": "Дұрыс жауап: «at». In — ішінде, on — бетінде, to — бағыт, across — бір шетінен екіншісіне. Arrive at нақты орынмен, arrive in қала не елмен қолданылады.", "ru": "Правильный ответ: «at». In — внутри, on — на поверхности, to — направление, across — с одной стороны на другую. Arrive at — с конкретным местом, arrive in — с городом или страной."}, "Use arrive in with a country or city.": {"kk": "Дұрыс жауап: «in». In — ішінде, on — бетінде, to — бағыт, across — бір шетінен екіншісіне. Arrive at нақты орынмен, arrive in қала не елмен қолданылады.", "ru": "Правильный ответ: «in». In — внутри, on — на поверхности, to — направление, across — с одной стороны на другую. Arrive at — с конкретным местом, arrive in — с городом или страной."}, "Across means from one side to the other.": {"kk": "Дұрыс жауап: «across». In — ішінде, on — бетінде, to — бағыт, across — бір шетінен екіншісіне. Arrive at нақты орынмен, arrive in қала не елмен қолданылады.", "ru": "Правильный ответ: «across». In — внутри, on — на поверхности, to — направление, across — с одной стороны на другую. Arrive at — с конкретным местом, arrive in — с городом или страной."}, "Use divide into for the resulting parts.": {"kk": "Дұрыс жауап: «into». In — ішінде, on — бетінде, to — бағыт, across — бір шетінен екіншісіне. Arrive at нақты орынмен, arrive in қала не елмен қолданылады.", "ru": "Правильный ответ: «into». In — внутри, on — на поверхности, to — направление, across — с одной стороны на другую. Arrive at — с конкретным местом, arrive in — с городом или страной."}, "By train describes the means of transport.": {"kk": "Дұрыс жауап: «by». In — ішінде, on — бетінде, to — бағыт, across — бір шетінен екіншісіне. Arrive at нақты орынмен, arrive in қала не елмен қолданылады.", "ru": "Правильный ответ: «by». In — внутри, on — на поверхности, to — направление, across — с одной стороны на другую. Arrive at — с конкретным местом, arrive in — с городом или страной."}, "The fixed phrase is on foot.": {"kk": "Дұрыс жауап: «on». In — ішінде, on — бетінде, to — бағыт, across — бір шетінен екіншісіне. Arrive at нақты орынмен, arrive in қала не елмен қолданылады.", "ru": "Правильный ответ: «on». In — внутри, on — на поверхности, to — направление, across — с одной стороны на другую. Arrive at — с конкретным местом, arrive in — с городом или страной."}, "Use from one place to another.": {"kk": "Дұрыс жауап: «to». In — ішінде, on — бетінде, to — бағыт, across — бір шетінен екіншісіне. Arrive at нақты орынмен, arrive in қала не елмен қолданылады.", "ru": "Правильный ответ: «to». In — внутри, on — на поверхности, to — направление, across — с одной стороны на другую. Arrive at — с конкретным местом, arrive in — с городом или страной."}, "Use between with the two places linked by and.": {"kk": "Дұрыс жауап: «between». In — ішінде, on — бетінде, to — бағыт, across — бір шетінен екіншісіне. Arrive at нақты орынмен, arrive in қала не елмен қолданылады.", "ru": "Правильный ответ: «between». In — внутри, on — на поверхности, to — направление, across — с одной стороны на другую. Arrive at — с конкретным местом, arrive in — с городом или страной."}, "Prepositions in fixed phrases": {"kk": "Тұрақты тіркестегі предлогтар", "ru": "Предлоги в устойчивых сочетаниях"}, "Learn the preposition with its phrase: good at, interested in, afraid of, listen to, wait for, agree with and belong to.": {"kk": "Предлогты тіркесімен үйрен: good at, interested in, afraid of, listen to, wait for, agree with, belong to.", "ru": "Учи предлог вместе с выражением: good at, interested in, afraid of, listen to, wait for, agree with, belong to."}, "The fixed phrase is good at.": {"kk": "Дұрыс жауап: «at». Предлогты тіркесімен үйрен: good at, interested in, afraid of, listen to, wait for, agree with, belong to.", "ru": "Правильный ответ: «at». Учи предлог вместе с выражением: good at, interested in, afraid of, listen to, wait for, agree with, belong to."}, "The fixed phrase is interested in.": {"kk": "Дұрыс жауап: «in». Предлогты тіркесімен үйрен: good at, interested in, afraid of, listen to, wait for, agree with, belong to.", "ru": "Правильный ответ: «in». Учи предлог вместе с выражением: good at, interested in, afraid of, listen to, wait for, agree with, belong to."}, "The fixed phrase is afraid of.": {"kk": "Дұрыс жауап: «of». Предлогты тіркесімен үйрен: good at, interested in, afraid of, listen to, wait for, agree with, belong to.", "ru": "Правильный ответ: «of». Учи предлог вместе с выражением: good at, interested in, afraid of, listen to, wait for, agree with, belong to."}, "The verb listen is followed by to.": {"kk": "Дұрыс жауап: «to». Предлогты тіркесімен үйрен: good at, interested in, afraid of, listen to, wait for, agree with, belong to.", "ru": "Правильный ответ: «to». Учи предлог вместе с выражением: good at, interested in, afraid of, listen to, wait for, agree with, belong to."}, "Use wait for when you name the person or thing being waited for.": {"kk": "Дұрыс жауап: «for». Предлогты тіркесімен үйрен: good at, interested in, afraid of, listen to, wait for, agree with, belong to.", "ru": "Правильный ответ: «for». Учи предлог вместе с выражением: good at, interested in, afraid of, listen to, wait for, agree with, belong to."}, "Use agree with a person.": {"kk": "Дұрыс жауап: «with». Предлогты тіркесімен үйрен: good at, interested in, afraid of, listen to, wait for, agree with, belong to.", "ru": "Правильный ответ: «with». Учи предлог вместе с выражением: good at, interested in, afraid of, listen to, wait for, agree with, belong to."}, "The fixed phrase is belong to.": {"kk": "Дұрыс жауап: «to». Предлогты тіркесімен үйрен: good at, interested in, afraid of, listen to, wait for, agree with, belong to.", "ru": "Правильный ответ: «to». Учи предлог вместе с выражением: good at, interested in, afraid of, listen to, wait for, agree with, belong to."}, "Use thank you for to name the reason.": {"kk": "Дұрыс жауап: «for». Предлогты тіркесімен үйрен: good at, interested in, afraid of, listen to, wait for, agree with, belong to.", "ru": "Правильный ответ: «for». Учи предлог вместе с выражением: good at, interested in, afraid of, listen to, wait for, agree with, belong to."}, "The fixed phrase is worried about.": {"kk": "Дұрыс жауап: «about». Предлогты тіркесімен үйрен: good at, interested in, afraid of, listen to, wait for, agree with, belong to.", "ru": "Правильный ответ: «about». Учи предлог вместе с выражением: good at, interested in, afraid of, listen to, wait for, agree with, belong to."}, "The fixed phrase is responsible for.": {"kk": "Дұрыс жауап: «for». Предлогты тіркесімен үйрен: good at, interested in, afraid of, listen to, wait for, agree with, belong to.", "ru": "Правильный ответ: «for». Учи предлог вместе с выражением: good at, interested in, afraid of, listen to, wait for, agree with, belong to."}, "For and since": {"kk": "For және since", "ru": "For и since"}, "Use for with a length of time and since with the point when something began.": {"kk": "For уақыттың ұзақтығын, since әрекеттің басталған сәтін көрсетеді.", "ru": "For обозначает длительность, since — момент начала действия."}, "Three years is a duration, so use for.": {"kk": "Дұрыс жауап: «for». For уақыттың ұзақтығын, since әрекеттің басталған сәтін көрсетеді.", "ru": "Правильный ответ: «for». For обозначает длительность, since — момент начала действия."}, "2020 is a starting point, so use since.": {"kk": "Дұрыс жауап: «since». For уақыттың ұзақтығын, since әрекеттің басталған сәтін көрсетеді.", "ru": "Правильный ответ: «since». For обозначает длительность, since — момент начала действия."}, "Twenty minutes is a length of time. Use for.": {"kk": "Дұрыс жауап: «for». For уақыттың ұзақтығын, since әрекеттің басталған сәтін көрсетеді.", "ru": "Правильный ответ: «for». For обозначает длительность, since — момент начала действия."}, "Monday identifies when the illness started. Use since.": {"kk": "Дұрыс жауап: «since». For уақыттың ұзақтығын, since әрекеттің басталған сәтін көрсетеді.", "ru": "Правильный ответ: «since». For обозначает длительность, since — момент начала действия."}, "A long time is a duration. Use for.": {"kk": "Дұрыс жауап: «for». For уақыттың ұзақтығын, since әрекеттің басталған сәтін көрсетеді.", "ru": "Правильный ответ: «for». For обозначает длительность, since — момент начала действия."}, "Last summer is a starting point. Use since.": {"kk": "Дұрыс жауап: «since». For уақыттың ұзақтығын, since әрекеттің басталған сәтін көрсетеді.", "ru": "Правильный ответ: «since». For обозначает длительность, since — момент начала действия."}, "Use for with a duration: two years.": {"kk": "Дұрыс жауап: «for». For уақыттың ұзақтығын, since әрекеттің басталған сәтін көрсетеді.", "ru": "Правильный ответ: «for». For обозначает длительность, since — момент начала действия."}, "January is the starting point. Use since.": {"kk": "Дұрыс жауап: «since». For уақыттың ұзақтығын, since әрекеттің басталған сәтін көрсетеді.", "ru": "Правильный ответ: «since». For обозначает длительность, since — момент начала действия."}, "Six months is a duration. Use for.": {"kk": "Дұрыс жауап: «for». For уақыттың ұзақтығын, since әрекеттің басталған сәтін көрсетеді.", "ru": "Правильный ответ: «for». For обозначает длительность, since — момент начала действия."}, "Six o’clock is the starting time. Use since.": {"kk": "Дұрыс жауап: «since». For уақыттың ұзақтығын, since әрекеттің басталған сәтін көрсетеді.", "ru": "Правильный ответ: «since». For обозначает длительность, since — момент начала действия."}, "Statements and noun phrases": {"kk": "Хабарлы сөйлем және сөз тіркесі", "ru": "Утверждения и именные группы"}, "In a simple statement, put the subject before the verb, then the object. Put an adjective before the noun it describes.": {"kk": "Хабарлы сөйлемнің реті: бастауыш + баяндауыш + толықтауыш. Сын есім зат есімнен бұрын тұрады.", "ru": "В утверждении: подлежащее + сказуемое + дополнение. Прилагательное ставится перед существительным."}, "The subject she comes before the verb reads, followed by the object books.": {"kk": "Дұрыс жауап: «She reads books.». Хабарлы сөйлемнің реті: бастауыш + баяндауыш + толықтауыш. Сын есім зат есімнен бұрын тұрады.", "ru": "Правильный ответ: «She reads books.». В утверждении: подлежащее + сказуемое + дополнение. Прилагательное ставится перед существительным."}, "Use subject + verb + object: they play tennis.": {"kk": "Дұрыс жауап: «They play tennis.». Хабарлы сөйлемнің реті: бастауыш + баяндауыш + толықтауыш. Сын есім зат есімнен бұрын тұрады.", "ru": "Правильный ответ: «They play tennis.». В утверждении: подлежащее + сказуемое + дополнение. Прилагательное ставится перед существительным."}, "Put red before bicycle and the object after have.": {"kk": "Дұрыс жауап: «I have a red bicycle.». Хабарлы сөйлемнің реті: бастауыш + баяндауыш + толықтауыш. Сын есім зат есімнен бұрын тұрады.", "ru": "Правильный ответ: «I have a red bicycle.». В утверждении: подлежащее + сказуемое + дополнение. Прилагательное ставится перед существительным."}, "Keep is wearing together and put blue before jacket.": {"kk": "Дұрыс жауап: «She is wearing a blue jacket.». Хабарлы сөйлемнің реті: бастауыш + баяндауыш + толықтауыш. Сын есім зат есімнен бұрын тұрады.", "ru": "Правильный ответ: «She is wearing a blue jacket.». В утверждении: подлежащее + сказуемое + дополнение. Прилагательное ставится перед существительным."}, "The whole subject the students comes before are.": {"kk": "Дұрыс жауап: «The students are in the library.». Хабарлы сөйлемнің реті: бастауыш + баяндауыш + толықтауыш. Сын есім зат есімнен бұрын тұрады.", "ru": "Правильный ответ: «The students are in the library.». В утверждении: подлежащее + сказуемое + дополнение. Прилагательное ставится перед существительным."}, "Keep my friend together, followed by has and the object.": {"kk": "Дұрыс жауап: «My friend has a small dog.». Хабарлы сөйлемнің реті: бастауыш + баяндауыш + толықтауыш. Сын есім зат есімнен бұрын тұрады.", "ru": "Правильный ответ: «My friend has a small dog.». В утверждении: подлежащее + сказуемое + дополнение. Прилагательное ставится перед существительным."}, "Enjoy is followed by reading stories.": {"kk": "Дұрыс жауап: «We enjoy reading stories.». Хабарлы сөйлемнің реті: бастауыш + баяндауыш + толықтауыш. Сын есім зат есімнен бұрын тұрады.", "ru": "Правильный ответ: «We enjoy reading stories.». В утверждении: подлежащее + сказуемое + дополнение. Прилагательное ставится перед существительным."}, "Keep the subject our teacher and object the rule together.": {"kk": "Дұрыс жауап: «Our teacher explains the rule.». Хабарлы сөйлемнің реті: бастауыш + баяндауыш + толықтауыш. Сын есім зат есімнен бұрын тұрады.", "ru": "Правильный ответ: «Our teacher explains the rule.». В утверждении: подлежащее + сказуемое + дополнение. Прилагательное ставится перед существительным."}, "Use there is + noun phrase + place.": {"kk": "Дұрыс жауап: «There is a cat in the garden.». Хабарлы сөйлемнің реті: бастауыш + баяндауыш + толықтауыш. Сын есім зат есімнен бұрын тұрады.", "ru": "Правильный ответ: «There is a cat in the garden.». В утверждении: подлежащее + сказуемое + дополнение. Прилагательное ставится перед существительным."}, "In this instruction, the verb open comes before your books.": {"kk": "Дұрыс жауап: «Please open your books.». Хабарлы сөйлемнің реті: бастауыш + баяндауыш + толықтауыш. Сын есім зат есімнен бұрын тұрады.", "ru": "Правильный ответ: «Please open your books.». В утверждении: подлежащее + сказуемое + дополнение. Прилагательное ставится перед существительным."}, "Question word order": {"kk": "Сұрақтағы сөз реті", "ru": "Порядок слов в вопросах"}, "In questions, put the auxiliary before the subject. With a question word, use question word + auxiliary + subject + main verb.": {"kk": "Сұрақта көмекші етістік бастауыштан бұрын келеді: сұрау сөзі + көмекші етістік + бастауыш + негізгі етістік.", "ru": "В вопросе вспомогательный глагол стоит перед подлежащим: вопросительное слово + вспомогательный глагол + подлежащее + основной глагол."}, "Use where + does + he + live.": {"kk": "Дұрыс жауап: «Where does he live?». Сұрақта көмекші етістік бастауыштан бұрын келеді: сұрау сөзі + көмекші етістік + бастауыш + негізгі етістік.", "ru": "Правильный ответ: «Where does he live?». В вопросе вспомогательный глагол стоит перед подлежащим: вопросительное слово + вспомогательный глагол + подлежащее + основной глагол."}, "Use when + does + she + study.": {"kk": "Дұрыс жауап: «When does she study?». Сұрақта көмекші етістік бастауыштан бұрын келеді: сұрау сөзі + көмекші етістік + бастауыш + негізгі етістік.", "ru": "Правильный ответ: «When does she study?». В вопросе вспомогательный глагол стоит перед подлежащим: вопросительное слово + вспомогательный глагол + подлежащее + основной глагол."}, "Put did before they, followed by watch.": {"kk": "Дұрыс жауап: «Did they watch the film?». Сұрақта көмекші етістік бастауыштан бұрын келеді: сұрау сөзі + көмекші етістік + бастауыш + негізгі етістік.", "ru": "Правильный ответ: «Did they watch the film?». В вопросе вспомогательный глагол стоит перед подлежащим: вопросительное слово + вспомогательный глагол + подлежащее + основной глагол."}, "Use what + did + you + eat.": {"kk": "Дұрыс жауап: «What did you eat for lunch?». Сұрақта көмекші етістік бастауыштан бұрын келеді: сұрау сөзі + көмекші етістік + бастауыш + негізгі етістік.", "ru": "Правильный ответ: «What did you eat for lunch?». В вопросе вспомогательный глагол стоит перед подлежащим: вопросительное слово + вспомогательный глагол + подлежащее + основной глагол."}, "Keep how many books together before do you have.": {"kk": "Дұрыс жауап: «How many books do you have?». Сұрақта көмекші етістік бастауыштан бұрын келеді: сұрау сөзі + көмекші етістік + бастауыш + негізгі етістік.", "ru": "Правильный ответ: «How many books do you have?». В вопросе вспомогательный глагол стоит перед подлежащим: вопросительное слово + вспомогательный глагол + подлежащее + основной глагол."}, "Keep what time together, then does + school + start.": {"kk": "Дұрыс жауап: «What time does school start?». Сұрақта көмекші етістік бастауыштан бұрын келеді: сұрау сөзі + көмекші етістік + бастауыш + негізгі етістік.", "ru": "Правильный ответ: «What time does school start?». В вопросе вспомогательный глагол стоит перед подлежащим: вопросительное слово + вспомогательный глагол + подлежащее + основной глагол."}, "Use why + are + the children + laughing.": {"kk": "Дұрыс жауап: «Why are the children laughing?». Сұрақта көмекші етістік бастауыштан бұрын келеді: сұрау сөзі + көмекші етістік + бастауыш + негізгі етістік.", "ru": "Правильный ответ: «Why are the children laughing?». В вопросе вспомогательный глагол стоит перед подлежащим: вопросительное слово + вспомогательный глагол + подлежащее + основной глагол."}, "Use where + is + your schoolbag.": {"kk": "Дұрыс жауап: «Where is your schoolbag?». Сұрақта көмекші етістік бастауыштан бұрын келеді: сұрау сөзі + көмекші етістік + бастауыш + негізгі етістік.", "ru": "Правильный ответ: «Where is your schoolbag?». В вопросе вспомогательный глагол стоит перед подлежащим: вопросительное слово + вспомогательный глагол + подлежащее + основной глагол."}, "Keep how much water together, then do + we + need.": {"kk": "Дұрыс жауап: «How much water do we need?». Сұрақта көмекші етістік бастауыштан бұрын келеді: сұрау сөзі + көмекші етістік + бастауыш + негізгі етістік.", "ru": "Правильный ответ: «How much water do we need?». В вопросе вспомогательный глагол стоит перед подлежащим: вопросительное слово + вспомогательный глагол + подлежащее + основной глагол."}, "Use when + will + the lesson + start.": {"kk": "Дұрыс жауап: «When will the lesson start?». Сұрақта көмекші етістік бастауыштан бұрын келеді: сұрау сөзі + көмекші етістік + бастауыш + негізгі етістік.", "ru": "Правильный ответ: «When will the lesson start?». В вопросе вспомогательный глагол стоит перед подлежащим: вопросительное слово + вспомогательный глагол + подлежащее + основной глагол."}, "Frequency adverbs": {"kk": "Жиілік үстеулерінің орны", "ru": "Место наречий частотности"}, "Frequency adverbs usually come before a main verb and after be. Keep noun phrases together.": {"kk": "Жиілік үстеуі әдетте негізгі етістіктен бұрын, ал be етістігінен кейін келеді. Сөз тіркесін бөлме.", "ru": "Наречие частотности обычно стоит перед основным глаголом и после be. Не разделяй слова внутри именной группы."}, "Usually goes before the main verb walk.": {"kk": "Дұрыс жауап: «I usually walk to school.». Жиілік үстеуі әдетте негізгі етістіктен бұрын, ал be етістігінен кейін келеді. Сөз тіркесін бөлме.", "ru": "Правильный ответ: «I usually walk to school.». Наречие частотности обычно стоит перед основным глаголом и после be. Не разделяй слова внутри именной группы."}, "Never goes before goes; keep to bed together.": {"kk": "Дұрыс жауап: «He never goes to bed late.». Жиілік үстеуі әдетте негізгі етістіктен бұрын, ал be етістігінен кейін келеді. Сөз тіркесін бөлме.", "ru": "Правильный ответ: «He never goes to bed late.». Наречие частотности обычно стоит перед основным глаголом и после be. Не разделяй слова внутри именной группы."}, "Often comes before visit; do not split our grandparents.": {"kk": "Дұрыс жауап: «We often visit our grandparents.». Жиілік үстеуі әдетте негізгі етістіктен бұрын, ал be етістігінен кейін келеді. Сөз тіркесін бөлме.", "ru": "Правильный ответ: «We often visit our grandparents.». Наречие частотности обычно стоит перед основным глаголом и после be. Не разделяй слова внутри именной группы."}, "Sometimes comes before the main verb plays.": {"kk": "Дұрыс жауап: «She sometimes plays chess.». Жиілік үстеуі әдетте негізгі етістіктен бұрын, ал be етістігінен кейін келеді. Сөз тіркесін бөлме.", "ru": "Правильный ответ: «She sometimes plays chess.». Наречие частотности обычно стоит перед основным глаголом и после be. Не разделяй слова внутри именной группы."}, "With be, put always after is and before friendly.": {"kk": "Дұрыс жауап: «She is always friendly.». Жиілік үстеуі әдетте негізгі етістіктен бұрын, ал be етістігінен кейін келеді. Сөз тіркесін бөлме.", "ru": "Правильный ответ: «She is always friendly.». Наречие частотности обычно стоит перед основным глаголом и после be. Не разделяй слова внутри именной группы."}, "Put usually after are and before ready.": {"kk": "Дұрыс жауап: «They are usually ready.». Жиілік үстеуі әдетте негізгі етістіктен бұрын, ал be етістігінен кейін келеді. Сөз тіркесін бөлме.", "ru": "Правильный ответ: «They are usually ready.». Наречие частотности обычно стоит перед основным глаголом и после be. Не разделяй слова внутри именной группы."}, "Rarely goes before eat; keep fast food together.": {"kk": "Дұрыс жауап: «We rarely eat fast food.». Жиілік үстеуі әдетте негізгі етістіктен бұрын, ал be етістігінен кейін келеді. Сөз тіркесін бөлме.", "ru": "Правильный ответ: «We rarely eat fast food.». Наречие частотности обычно стоит перед основным глаголом и после be. Не разделяй слова внутри именной группы."}, "Often goes after is.": {"kk": "Дұрыс жауап: «He is often late.». Жиілік үстеуі әдетте негізгі етістіктен бұрын, ал be етістігінен кейін келеді. Сөз тіркесін бөлме.", "ru": "Правильный ответ: «He is often late.». Наречие частотности обычно стоит перед основным глаголом и после be. Не разделяй слова внутри именной группы."}, "Always goes before check; keep my answers together.": {"kk": "Дұрыс жауап: «I always check my answers.». Жиілік үстеуі әдетте негізгі етістіктен бұрын, ал be етістігінен кейін келеді. Сөз тіркесін бөлме.", "ru": "Правильный ответ: «I always check my answers.». Наречие частотности обычно стоит перед основным глаголом и после be. Не разделяй слова внутри именной группы."}, "With be, never follows are and comes before rude.": {"kk": "Дұрыс жауап: «My friends are never rude.». Жиілік үстеуі әдетте негізгі етістіктен бұрын, ал be етістігінен кейін келеді. Сөз тіркесін бөлме.", "ru": "Правильный ответ: «My friends are never rude.». Наречие частотности обычно стоит перед основным глаголом и после be. Не разделяй слова внутри именной группы."}, "Auxiliaries and verb groups": {"kk": "Көмекші етістіктердің реті", "ru": "Порядок глаголов и вспомогательных форм"}, "Keep auxiliaries and main verbs in order. Use subject + modal + base verb, have/has + past participle, or be + going to + base verb.": {"kk": "Ретті сақта: бастауыш + модаль етістік + бастапқы етістік; have/has + past participle; be + going to + бастапқы етістік.", "ru": "Соблюдай порядок: подлежащее + модальный глагол + начальная форма; have/has + третья форма; be + going to + начальная форма."}, "Use subject + can + base verb + object.": {"kk": "Дұрыс жауап: «She can speak English.». Ретті сақта: бастауыш + модаль етістік + бастапқы етістік; have/has + past participle; be + going to + бастапқы етістік.", "ru": "Правильный ответ: «She can speak English.». Соблюдай порядок: подлежащее + модальный глагол + начальная форма; have/has + третья форма; be + going to + начальная форма."}, "Can comes before the base verb ride.": {"kk": "Дұрыс жауап: «He can ride a bike.». Ретті сақта: бастауыш + модаль етістік + бастапқы етістік; have/has + past participle; be + going to + бастапқы етістік.", "ru": "Правильный ответ: «He can ride a bike.». Соблюдай порядок: подлежащее + модальный глагол + начальная форма; have/has + третья форма; be + going to + начальная форма."}, "Use has + already + finished, then the object.": {"kk": "Дұрыс жауап: «He has already finished his work.». Ретті сақта: бастауыш + модаль етістік + бастапқы етістік; have/has + past participle; be + going to + бастапқы етістік.", "ru": "Правильный ответ: «He has already finished his work.». Соблюдай порядок: подлежащее + модальный глагол + начальная форма; have/has + третья форма; be + going to + начальная форма."}, "Use have + just + arrived, followed by the place.": {"kk": "Дұрыс жауап: «They have just arrived at the station.». Ретті сақта: бастауыш + модаль етістік + бастапқы етістік; have/has + past participle; be + going to + бастапқы етістік.", "ru": "Правильный ответ: «They have just arrived at the station.». Соблюдай порядок: подлежащее + модальный глагол + начальная форма; have/has + третья форма; be + going to + начальная форма."}, "Use have + subject + ever + past participle.": {"kk": "Дұрыс жауап: «Have you ever visited London?». Ретті сақта: бастауыш + модаль етістік + бастапқы етістік; have/has + past participle; be + going to + бастапқы етістік.", "ru": "Правильный ответ: «Have you ever visited London?». Соблюдай порядок: подлежащее + модальный глагол + начальная форма; have/has + третья форма; be + going to + начальная форма."}, "Use could + you + tell, followed by the objects.": {"kk": "Дұрыс жауап: «Could you tell me the time?». Ретті сақта: бастауыш + модаль етістік + бастапқы етістік; have/has + past participle; be + going to + бастапқы етістік.", "ru": "Правильный ответ: «Could you tell me the time?». Соблюдай порядок: подлежащее + модальный глагол + начальная форма; have/has + третья форма; be + going to + начальная форма."}, "Keep am going to together before the base verb read.": {"kk": "Дұрыс жауап: «I am going to read this book.». Ретті сақта: бастауыш + модаль етістік + бастапқы етістік; have/has + past participle; be + going to + бастапқы етістік.", "ru": "Правильный ответ: «I am going to read this book.». Соблюдай порядок: подлежащее + модальный глагол + начальная форма; have/has + третья форма; be + going to + начальная форма."}, "Put not after are and before watching.": {"kk": "Дұрыс жауап: «We are not watching TV.». Ретті сақта: бастауыш + модаль етістік + бастапқы етістік; have/has + past participle; be + going to + бастапқы етістік.", "ru": "Правильный ответ: «We are not watching TV.». Соблюдай порядок: подлежащее + модальный глагол + начальная форма; have/has + третья форма; be + going to + начальная форма."}, "Use do not + base verb understand.": {"kk": "Дұрыс жауап: «I do not understand this word.». Ретті сақта: бастауыш + модаль етістік + бастапқы етістік; have/has + past participle; be + going to + бастапқы етістік.", "ru": "Правильный ответ: «I do not understand this word.». Соблюдай порядок: подлежащее + модальный глагол + начальная форма; have/has + третья форма; be + going to + начальная форма."}, "Keep would like together, followed by the object.": {"kk": "Дұрыс жауап: «I would like a glass of water.». Ретті сақта: бастауыш + модаль етістік + бастапқы етістік; have/has + past participle; be + going to + бастапқы етістік.", "ru": "Правильный ответ: «I would like a glass of water.». Соблюдай порядок: подлежащее + модальный глагол + начальная форма; have/has + третья форма; be + going to + начальная форма."}, "Common word spellings": {"kk": "Жиі қолданылатын сөздердің емлесі", "ru": "Правописание частых слов"}, "Check the whole word, not only how it sounds. Notice the letter sequence in because, beautiful, science, subject and information.": {"kk": "Сөзді толық тексер. Because, beautiful, science, subject, information сөздеріндегі әріп ретіне назар аудар.", "ru": "Проверяй слово целиком. Обращай внимание на порядок букв в because, beautiful, science, subject, information."}, "The correct spelling is because.": {"kk": "Дұрыс жауап: «because». Сөзді толық тексер. Because, beautiful, science, subject, information сөздеріндегі әріп ретіне назар аудар.", "ru": "Правильный ответ: «because». Проверяй слово целиком. Обращай внимание на порядок букв в because, beautiful, science, subject, information."}, "The correct spelling is beautiful: beau-ti-ful.": {"kk": "Дұрыс жауап: «beautiful». Сөзді толық тексер. Because, beautiful, science, subject, information сөздеріндегі әріп ретіне назар аудар.", "ru": "Правильный ответ: «beautiful». Проверяй слово целиком. Обращай внимание на порядок букв в because, beautiful, science, subject, information."}, "Science begins with sc and ends in -ence.": {"kk": "Дұрыс жауап: «science». Сөзді толық тексер. Because, beautiful, science, subject, information сөздеріндегі әріп ретіне назар аудар.", "ru": "Правильный ответ: «science». Проверяй слово целиком. Обращай внимание на порядок букв в because, beautiful, science, subject, information."}, "The correct spelling is subject.": {"kk": "Дұрыс жауап: «subject». Сөзді толық тексер. Because, beautiful, science, subject, information сөздеріндегі әріп ретіне назар аудар.", "ru": "Правильный ответ: «subject». Проверяй слово целиком. Обращай внимание на порядок букв в because, beautiful, science, subject, information."}, "The correct spelling is information.": {"kk": "Дұрыс жауап: «information». Сөзді толық тексер. Because, beautiful, science, subject, information сөздеріндегі әріп ретіне назар аудар.", "ru": "Правильный ответ: «information». Проверяй слово целиком. Обращай внимание на порядок букв в because, beautiful, science, subject, information."}, "The correct spelling is weather.": {"kk": "Дұрыс жауап: «weather». Сөзді толық тексер. Because, beautiful, science, subject, information сөздеріндегі әріп ретіне назар аудар.", "ru": "Правильный ответ: «weather». Проверяй слово целиком. Обращай внимание на порядок букв в because, beautiful, science, subject, information."}, "The correct spelling is museum.": {"kk": "Дұрыс жауап: «museum». Сөзді толық тексер. Because, beautiful, science, subject, information сөздеріндегі әріп ретіне назар аудар.", "ru": "Правильный ответ: «museum». Проверяй слово целиком. Обращай внимание на порядок букв в because, beautiful, science, subject, information."}, "The correct spelling is birthday.": {"kk": "Дұрыс жауап: «birthday». Сөзді толық тексер. Because, beautiful, science, subject, information сөздеріндегі әріп ретіне назар аудар.", "ru": "Правильный ответ: «birthday». Проверяй слово целиком. Обращай внимание на порядок букв в because, beautiful, science, subject, information."}, "The correct spelling is name.": {"kk": "Дұрыс жауап: «name». Сөзді толық тексер. Because, beautiful, science, subject, information сөздеріндегі әріп ретіне назар аудар.", "ru": "Правильный ответ: «name». Проверяй слово целиком. Обращай внимание на порядок букв в because, beautiful, science, subject, information."}, "Pronunciation has nun, not noun, after pro-.": {"kk": "Дұрыс жауап: «pronunciation». Сөзді толық тексер. Because, beautiful, science, subject, information сөздеріндегі әріп ретіне назар аудар.", "ru": "Правильный ответ: «pronunciation». Проверяй слово целиком. Обращай внимание на порядок букв в because, beautiful, science, subject, information."}, "Single and double letters": {"kk": "Бір және қос әріптер", "ru": "Одинарные и двойные буквы"}, "Notice which consonants are doubled: address has dd and ss; tomorrow has rr; necessary has one c and two s.": {"kk": "Address сөзінде dd және ss, tomorrow сөзінде rr, necessary сөзінде бір c және екі s жазылады.", "ru": "В address пишутся dd и ss, в tomorrow — rr, в necessary — одна c и две s."}, "Address has two d letters and two s letters.": {"kk": "Дұрыс жауап: «address». Address сөзінде dd және ss, tomorrow сөзінде rr, necessary сөзінде бір c және екі s жазылады.", "ru": "Правильный ответ: «address». В address пишутся dd и ss, в tomorrow — rr, в necessary — одна c и две s."}, "Tomorrow has one m and two r letters.": {"kk": "Дұрыс жауап: «tomorrow». Address сөзінде dd және ss, tomorrow сөзінде rr, necessary сөзінде бір c және екі s жазылады.", "ru": "Правильный ответ: «tomorrow». В address пишутся dd и ss, в tomorrow — rr, в necessary — одна c и две s."}, "Difficult has two f letters.": {"kk": "Дұрыс жауап: «difficult». Address сөзінде dd және ss, tomorrow сөзінде rr, necessary сөзінде бір c және екі s жазылады.", "ru": "Правильный ответ: «difficult». В address пишутся dd и ss, в tomorrow — rr, в necessary — одна c и две s."}, "Village has two l letters.": {"kk": "Дұрыс жауап: «village». Address сөзінде dd және ss, tomorrow сөзінде rr, necessary сөзінде бір c және екі s жазылады.", "ru": "Правильный ответ: «village». В address пишутся dd и ss, в tomorrow — rr, в necessary — одна c и две s."}, "Necessary has one c and two s letters.": {"kk": "Дұрыс жауап: «necessary». Address сөзінде dd және ss, tomorrow сөзінде rr, necessary сөзінде бір c және екі s жазылады.", "ru": "Правильный ответ: «necessary». В address пишутся dd и ss, в tomorrow — rr, в necessary — одна c и две s."}, "Correct has two r letters and ends in -ect.": {"kk": "Дұрыс жауап: «correct». Address сөзінде dd және ss, tomorrow сөзінде rr, necessary сөзінде бір c және екі s жазылады.", "ru": "Правильный ответ: «correct». В address пишутся dd и ss, в tomorrow — rr, в necessary — одна c и две s."}, "Funny has two n letters and ends in y.": {"kk": "Дұрыс жауап: «funny». Address сөзінде dd және ss, tomorrow сөзінде rr, necessary сөзінде бір c және екі s жазылады.", "ru": "Правильный ответ: «funny». В address пишутся dd и ss, в tomorrow — rr, в necessary — одна c и две s."}, "Small ends in two l letters.": {"kk": "Дұрыс жауап: «small». Address сөзінде dd және ss, tomorrow сөзінде rr, necessary сөзінде бір c және екі s жазылады.", "ru": "Правильный ответ: «small». В address пишутся dd и ss, в tomorrow — rr, в necessary — одна c и две s."}, "Happy has two p letters and ends in y.": {"kk": "Дұрыс жауап: «happy». Address сөзінде dd және ss, tomorrow сөзінде rr, necessary сөзінде бір c және екі s жазылады.", "ru": "Правильный ответ: «happy». В address пишутся dd и ss, в tomorrow — rr, в necessary — одна c и две s."}, "Swimmer has two m letters and ends in -er.": {"kk": "Дұрыс жауап: «swimmer». Address сөзінде dd және ss, tomorrow сөзінде rr, necessary сөзінде бір c және екі s жазылады.", "ru": "Правильный ответ: «swimmer». В address пишутся dd и ss, в tomorrow — rr, в necessary — одна c и две s."}, "Silent letters and letter order": {"kk": "Оқылмайтын әріптер және әріп реті", "ru": "Непроизносимые буквы и порядок букв"}, "Some letters are written but not heard. Check listen, answer and Wednesday. In friend, i comes before e.": {"kk": "Кей әріптер жазылғанымен оқылмайды: listen, answer, Wednesday. Friend сөзінде i әрпі e әрпінен бұрын тұрады.", "ru": "Некоторые буквы пишутся, но не произносятся: listen, answer, Wednesday. В friend буква i стоит перед e."}, "Listen has a written t that is not pronounced.": {"kk": "Дұрыс жауап: «listen». Кей әріптер жазылғанымен оқылмайды: listen, answer, Wednesday. Friend сөзінде i әрпі e әрпінен бұрын тұрады.", "ru": "Правильный ответ: «listen». Некоторые буквы пишутся, но не произносятся: listen, answer, Wednesday. В friend буква i стоит перед e."}, "Answer has a written w that is not pronounced.": {"kk": "Дұрыс жауап: «answer». Кей әріптер жазылғанымен оқылмайды: listen, answer, Wednesday. Friend сөзінде i әрпі e әрпінен бұрын тұрады.", "ru": "Правильный ответ: «answer». Некоторые буквы пишутся, но не произносятся: listen, answer, Wednesday. В friend буква i стоит перед e."}, "In friend, i comes before e.": {"kk": "Дұрыс жауап: «friend». Кей әріптер жазылғанымен оқылмайды: listen, answer, Wednesday. Friend сөзінде i әрпі e әрпінен бұрын тұрады.", "ru": "Правильный ответ: «friend». Некоторые буквы пишутся, но не произносятся: listen, answer, Wednesday. В friend буква i стоит перед e."}, "The correct spelling is Wednesday.": {"kk": "Дұрыс жауап: «Wednesday». Кей әріптер жазылғанымен оқылмайды: listen, answer, Wednesday. Friend сөзінде i әрпі e әрпінен бұрын тұрады.", "ru": "Правильный ответ: «Wednesday». Некоторые буквы пишутся, но не произносятся: listen, answer, Wednesday. В friend буква i стоит перед e."}, "The correct spelling is enough.": {"kk": "Дұрыс жауап: «enough». Кей әріптер жазылғанымен оқылмайды: listen, answer, Wednesday. Friend сөзінде i әрпі e әрпінен бұрын тұрады.", "ru": "Правильный ответ: «enough». Некоторые буквы пишутся, но не произносятся: listen, answer, Wednesday. В friend буква i стоит перед e."}, "Remember has one m after re- and another in -member.": {"kk": "Дұрыс жауап: «remember». Кей әріптер жазылғанымен оқылмайды: listen, answer, Wednesday. Friend сөзінде i әрпі e әрпінен бұрын тұрады.", "ru": "Правильный ответ: «remember». Некоторые буквы пишутся, но не произносятся: listen, answer, Wednesday. В friend буква i стоит перед e."}, "Answer includes the sequence -nsw-.": {"kk": "Дұрыс жауап: «answer». Кей әріптер жазылғанымен оқылмайды: listen, answer, Wednesday. Friend сөзінде i әрпі e әрпінен бұрын тұрады.", "ru": "Правильный ответ: «answer». Некоторые буквы пишутся, но не произносятся: listen, answer, Wednesday. В friend буква i стоит перед e."}, "Knee starts with a silent k.": {"kk": "Дұрыс жауап: «knee». Кей әріптер жазылғанымен оқылмайды: listen, answer, Wednesday. Friend сөзінде i әрпі e әрпінен бұрын тұрады.", "ru": "Правильный ответ: «knee». Некоторые буквы пишутся, но не произносятся: listen, answer, Wednesday. В friend буква i стоит перед e."}, "Knife begins with a silent k and ends in e.": {"kk": "Дұрыс жауап: «knife». Кей әріптер жазылғанымен оқылмайды: listen, answer, Wednesday. Friend сөзінде i әрпі e әрпінен бұрын тұрады.", "ru": "Правильный ответ: «knife». Некоторые буквы пишутся, но не произносятся: listen, answer, Wednesday. В friend буква i стоит перед e."}, "Write begins with a silent w and ends in e.": {"kk": "Дұрыс жауап: «write». Кей әріптер жазылғанымен оқылмайды: listen, answer, Wednesday. Friend сөзінде i әрпі e әрпінен бұрын тұрады.", "ru": "Правильный ответ: «write». Некоторые буквы пишутся, но не произносятся: listen, answer, Wednesday. В friend буква i стоит перед e."}, "Capital letters": {"kk": "Бас әріптер", "ru": "Заглавные буквы"}, "Use capitals for I, names, languages, countries, months and days. Begin a sentence with a capital letter.": {"kk": "I есімдігі, есімдер, тілдер, елдер, айлар және апта күндері бас әріппен жазылады. Сөйлем де бас әріптен басталады.", "ru": "С заглавной буквы пишутся I, имена, языки, страны, месяцы и дни недели. Предложение тоже начинается с заглавной буквы."}, "Language names begin with a capital letter: English.": {"kk": "Дұрыс жауап: «English». I есімдігі, есімдер, тілдер, елдер, айлар және апта күндері бас әріппен жазылады. Сөйлем де бас әріптен басталады.", "ru": "Правильный ответ: «English». С заглавной буквы пишутся I, имена, языки, страны, месяцы и дни недели. Предложение тоже начинается с заглавной буквы."}, "Language names begin with a capital letter: Kazakh.": {"kk": "Дұрыс жауап: «Kazakh». I есімдігі, есімдер, тілдер, елдер, айлар және апта күндері бас әріппен жазылады. Сөйлем де бас әріптен басталады.", "ru": "Правильный ответ: «Kazakh». С заглавной буквы пишутся I, имена, языки, страны, месяцы и дни недели. Предложение тоже начинается с заглавной буквы."}, "Month names begin with a capital letter.": {"kk": "Дұрыс жауап: «June». I есімдігі, есімдер, тілдер, елдер, айлар және апта күндері бас әріппен жазылады. Сөйлем де бас әріптен басталады.", "ru": "Правильный ответ: «June». С заглавной буквы пишутся I, имена, языки, страны, месяцы и дни недели. Предложение тоже начинается с заглавной буквы."}, "Day names begin with a capital letter.": {"kk": "Дұрыс жауап: «Friday». I есімдігі, есімдер, тілдер, елдер, айлар және апта күндері бас әріппен жазылады. Сөйлем де бас әріптен басталады.", "ru": "Правильный ответ: «Friday». С заглавной буквы пишутся I, имена, языки, страны, месяцы и дни недели. Предложение тоже начинается с заглавной буквы."}, "Country names begin with a capital letter.": {"kk": "Дұрыс жауап: «Kazakhstan». I есімдігі, есімдер, тілдер, елдер, айлар және апта күндері бас әріппен жазылады. Сөйлем де бас әріптен басталады.", "ru": "Правильный ответ: «Kazakhstan». С заглавной буквы пишутся I, имена, языки, страны, месяцы и дни недели. Предложение тоже начинается с заглавной буквы."}, "The pronoun I is always a capital letter.": {"kk": "Дұрыс жауап: «I». I есімдігі, есімдер, тілдер, елдер, айлар және апта күндері бас әріппен жазылады. Сөйлем де бас әріптен басталады.", "ru": "Правильный ответ: «I». С заглавной буквы пишутся I, имена, языки, страны, месяцы и дни недели. Предложение тоже начинается с заглавной буквы."}, "A person’s name begins with a capital letter.": {"kk": "Дұрыс жауап: «Aida». I есімдігі, есімдер, тілдер, елдер, айлар және апта күндері бас әріппен жазылады. Сөйлем де бас әріптен басталады.", "ru": "Правильный ответ: «Aida». С заглавной буквы пишутся I, имена, языки, страны, месяцы и дни недели. Предложение тоже начинается с заглавной буквы."}, "City names begin with a capital letter.": {"kk": "Дұрыс жауап: «London». I есімдігі, есімдер, тілдер, елдер, айлар және апта күндері бас әріппен жазылады. Сөйлем де бас әріптен басталады.", "ru": "Правильный ответ: «London». С заглавной буквы пишутся I, имена, языки, страны, месяцы и дни недели. Предложение тоже начинается с заглавной буквы."}, "Capitalise the first word of the sentence and the language name.": {"kk": "Дұрыс жауап: «She likes English.». I есімдігі, есімдер, тілдер, елдер, айлар және апта күндері бас әріппен жазылады. Сөйлем де бас әріптен басталады.", "ru": "Правильный ответ: «She likes English.». С заглавной буквы пишутся I, имена, языки, страны, месяцы и дни недели. Предложение тоже начинается с заглавной буквы."}, "24 questions · about 15 minutes": {"kk": "24 сұрақ · шамамен 15 минут", "ru": "24 вопроса · около 15 минут"}, "One person.": {"kk": "Бір адам.", "ru": "Один человек."}, "Add -s or -es.": {"kk": "-s немесе -es қос.", "ru": "Добавь -s или -es."}, "Assel Amanzholova": {"kk": "Әсел Аманжолова", "ru": "Асель Аманжолова"}, "Assel Amanzholova · School No. 22": {"kk": "Әсел Аманжолова · №22 мектеп", "ru": "Асель Аманжолова · Школа №22"}, "Ten small pattern checks look for selected verb endings, fixed phrases, prepositions, spelling and capitals. They can miss errors and suggest changes that do not fit your meaning. They do not grade your writing or change your error map. Drafts and saved revisions stay in this browser.": {"kk": "Он ереже үлгісі етістік жалғауын, тұрақты тіркесті, предлогты, емле мен бас әріпті тексереді. Кей қатені өткізіп алуы немесе мағынаға сай емес түзету ұсынуы мүмкін. Мәтінге баға қойылмайды, қателер картасы өзгермейді. Мәтіндер осы браузерде сақталады.", "ru": "Десять шаблонов проверяют отдельные окончания, устойчивые сочетания, предлоги, орфографию и заглавные буквы. Анализатор может пропустить ошибку или предложить неуместную правку. Он не оценивает текст и не меняет карту ошибок. Черновики и версии сохраняются в этом браузере."}, "This is a shared local workspace, not a password-protected teacher account. Anyone using this browser can open its learner profiles. No server sync is connected.": {"kk": "Бұл осы құрылғыдағы ортақ жұмыс аймағы. Мұғалім профилі құпиясөзбен қорғалмаған. Осы браузерді қолданатын адам оқушы профильдерін аша алады. Сервермен синхрондау жоқ.", "ru": "Это общая локальная рабочая область без пароля учителя. Любой пользователь этого браузера может открыть профили учеников. Серверная синхронизация не подключена."}, "Independent means a correct first answer without a hint. Corrected answers do not add independent points. A lesson needs at least 3 of 4 independent answers plus an explanation and new sentence before a rule check opens. A rule check needs 2 of 2 correct answers. Rechecks use the reserved matched question for every baseline rule. These are classroom support signals, not validated mastery scores.": {"kk": "Өздік нәтиже — алғашқы әрекетте көмексіз берілген дұрыс жауап. Түзетілген жауап оған қосылмайды. Ереже тексеруі ашылуы үшін төрт сұрақтың кемінде үшеуіне көмексіз жауап беріп, түсіндірме мен жаңа сөйлем жазу қажет. Ереже тексеруінде 2/2 қажет. Қайта тестке әр ереженің бөлек жұп сұрағы сақталады. Бұлар сабаққа арналған бағдар, меңгерудің расталған өлшемі емес.", "ru": "Самостоятельный результат — верный первый ответ без подсказки. Исправления не добавляют самостоятельных баллов. Для открытия проверки нужны минимум 3/4 таких ответов, объяснение и новое предложение. Проверка правила требует 2/2. В итоговом тесте используются отдельные парные вопросы. Это учебные ориентиры, а не подтверждённая оценка владения."}, "One question for each of 24 rules. Missed answers suggest where to begin.": {"kk": "24 ереженің әрқайсысына бір сұрақ беріледі. Қате жауаптар неден бастау керегін көрсетеді.", "ru": "По одному вопросу на каждое из 24 правил. Ошибки подсказывают, с чего начать."}, "Four separate examples, a rule explanation and a learner-written sentence.": {"kk": "Төрт бөлек мысал, ережені түсіндіру және оқушы жазған сөйлем.", "ru": "Четыре отдельных примера, объяснение правила и предложение ученика."}, "Two different examples, answered independently.": {"kk": "Екі басқа мысалға өздігінен жауап беру.", "ru": "Два других примера для самостоятельного ответа."}, "A reserved question matched to each baseline topic and difficulty band.": {"kk": "Әр бастапқы тақырып пен деңгейге сәйкес бөлек сұрақ.", "ru": "Отдельный вопрос, соответствующий теме и уровню начальной проверки."}, "240 questions: 144 assessment items and 96 practice items. Every rule has three A/B assessment pairs and four dedicated practice questions. Practice questions never appear in assessments.": {"kk": "240 тапсырма: 144 тексеру сұрағы және 96 жаттығу. Әр ережеде үш A/B жұбы және төрт бөлек жаттығу бар. Жаттығу сұрақтары тестке кірмейді.", "ru": "240 заданий: 144 вопроса проверок и 96 упражнений. У каждого правила три пары A/B и четыре отдельных упражнения. Упражнения не используются в тестах."}, "Learner codes, unfinished attempts, results, hints, first answers, corrections, reflections and writing revisions are stored in this browser. Backups can be downloaded and restored. There is no shared server database or sign-in system.": {"kk": "Оқушы кодтары, аяқталмаған әрекеттер, нәтижелер, көмек, алғашқы жауаптар, түзетулер, түсіндірмелер мен мәтін нұсқалары осы браузерде сақталады. Сақтық көшірмені жүктеп, қалпына келтіруге болады. Ортақ серверлік база мен тіркелу жүйесі жоқ.", "ru": "Коды учеников, незаконченные попытки, результаты, подсказки, первые ответы, исправления, объяснения и версии текстов сохраняются в этом браузере. Резервную копию можно скачать и восстановить. Общей серверной базы и системы входа нет."}, "A short test cannot establish mastery. New sentences and rule explanations need teacher review. The small writing checker does not understand every sentence. The paired assessments have not been statistically equated, and no classroom effectiveness study is claimed.": {"kk": "Қысқа тест толық меңгеруді дәлелдемейді. Жаңа сөйлемдер мен түсіндірмелерді мұғалім тексереді. Мәтін талдағышы әр сөйлемді толық түсінбейді. Тест жұптары статистикалық теңестірілмеген, сабақтағы тиімділік зерттеуі жарияланбаған.", "ru": "Короткий тест не доказывает владение правилом. Предложения и объяснения проверяет учитель. Анализатор не понимает каждый текст полностью. Тесты статистически не уравнивались; исследование эффективности в классе не заявляется."}, "If this is a present-simple statement, check the third-person ending.": {"kk": "Бұл Present Simple хабарлы сөйлемі болса, үшінші жақ жалғауын тексер.", "ru": "Если это утверждение в Present Simple, проверь окончание третьего лица."}, "After does, use the base form of the main verb.": {"kk": "Does сөзінен кейін негізгі етістіктің бастапқы тұлғасын қолдан.", "ru": "После does используй начальную форму основного глагола."}, "Use the phrase do homework.": {"kk": "Do homework тіркесін қолдан.", "ru": "Используй сочетание do homework."}, "Use the phrase take a photo.": {"kk": "Take a photo тіркесін қолдан.", "ru": "Используй сочетание take a photo."}, "Use on with days of the week.": {"kk": "Апта күндерімен on қолданылады.", "ru": "С днями недели используется on."}, "Compare the spelling with the suggested word.": {"kk": "Сөздің жазылуын ұсынылған нұсқамен салыстыр.", "ru": "Сравни написание с предложенным словом."}, "Check the single and double letters.": {"kk": "Бір және қос әріптерді тексер.", "ru": "Проверь одинарные и двойные буквы."}, "The pronoun I is always capitalised.": {"kk": "I есімдігі әрқашан бас әріппен жазылады.", "ru": "Местоимение I всегда пишется с заглавной буквы."}, "Language names begin with a capital letter.": {"kk": "Тіл атаулары бас әріппен жазылады.", "ru": "Названия языков пишутся с заглавной буквы."}, "Storage is unavailable or full. Download a backup before leaving this page.": {"kk": "Сақтау орны толған немесе қолжетімсіз. Шықпас бұрын сақтық көшірмені жүкте.", "ru": "Хранилище недоступно или заполнено. Перед выходом скачай резервную копию."}, "Changes are not saved.": {"kk": "Өзгерістер сақталмады.", "ru": "Изменения не сохранены."}, "Download recovery backup": {"kk": "Қалпына келтіру көшірмесін жүктеу", "ru": "Скачать копию для восстановления"}, "Resume or discard your current assessment first.": {"kk": "Алдымен ағымдағы тексеруді жалғастыр немесе жой.", "ru": "Сначала продолжи или удали текущую проверку."}, "Finish or discard your saved lesson before starting a baseline.": {"kk": "Бастапқы тест алдында сақталған сабақты аяқта немесе жой.", "ru": "Перед начальной проверкой заверши или удали сохранённый урок."}, "Your current cycle already has a baseline.": {"kk": "Ағымдағы кезеңде бастапқы нәтиже бар.", "ru": "В текущем цикле уже есть начальный результат."}, "Finish the assigned rule checks first.": {"kk": "Алдымен берілген ережелерді тексеріп аяқта.", "ru": "Сначала заверши назначенные проверки правил."}, "Finish or discard your saved practice first.": {"kk": "Алдымен сақталған жаттығуды аяқта немесе жой.", "ru": "Сначала заверши или удали сохранённую практику."}, "Complete this cycle before starting another one.": {"kk": "Жаңа кезеңді бастамас бұрын осы кезеңді аяқта.", "ru": "Заверши текущий цикл перед началом нового."}, "Start a new cycle? Previous results will stay. Any unfinished optional lesson will be discarded.": {"kk": "Жаңа кезеңді бастау керек пе? Бұрынғы нәтижелер сақталады. Аяқталмаған қосымша сабақ жойылады.", "ru": "Начать новый цикл? Предыдущие результаты сохранятся. Незаконченный дополнительный урок будет удалён."}, "Discard this unfinished attempt? Completed results will stay.": {"kk": "Аяқталмаған әрекетті жою керек пе? Аяқталған нәтижелер сақталады.", "ru": "Удалить незавершённую попытку? Завершённые результаты сохранятся."}, "A baseline already exists for this cycle.": {"kk": "Бұл кезеңде бастапқы нәтиже бар.", "ru": "В этом цикле уже есть начальный результат."}, "Finish or discard the current assessment first.": {"kk": "Алдымен ағымдағы тексеруді аяқта немесе жой.", "ru": "Сначала заверши или удали текущую проверку."}, "Resume or discard your saved lesson first.": {"kk": "Алдымен сақталған сабақты жалғастыр немесе жой.", "ru": "Сначала продолжи или удали сохранённый урок."}, "Compare the options with the explanation and try again.": {"kk": "Нұсқаларды түсіндірмемен салыстырып, қайта орында.", "ru": "Сравни варианты с объяснением и попробуй снова."}, "Discard this unfinished lesson? Completed lessons will stay.": {"kk": "Аяқталмаған сабақты жою керек пе? Аяқталған сабақтар сақталады.", "ru": "Удалить незавершённый урок? Завершённые уроки сохранятся."}, "Write a short explanation and a new sentence before saving.": {"kk": "Сақтамас бұрын қысқа түсіндірме мен жаңа сөйлем жаз.", "ru": "Перед сохранением напиши короткое объяснение и новое предложение."}, "Complete practice with at least 3 of 4 independent first answers and a new example first.": {"kk": "Алдымен 4 сұрақтың кемінде үшеуіне көмексіз жауап беріп, жаңа мысал жаз.", "ru": "Сначала ответь самостоятельно минимум на 3 из 4 вопросов и напиши новый пример."}, "Lesson saved. If this rule is assigned, you can now check it on new examples.": {"kk": "Сабақ сақталды. Бұл ереже берілген болса, оны басқа мысалдармен тексеруге болады.", "ru": "Урок сохранён. Если правило назначено, его можно проверить на других примерах."}, "Lesson saved. Review the rule and retry before the independent check.": {"kk": "Сабақ сақталды. Өздік тексеру алдында ережені қайталап, жаттығуды қайта орында.", "ru": "Урок сохранён. Перед самостоятельной проверкой повтори правило и упражнения."}, "Replace your current draft with the example? Saved revisions will stay.": {"kk": "Ағымдағы мәтінді үлгімен ауыстыру керек пе? Сақталған нұсқалар қалады.", "ru": "Заменить черновик примером? Сохранённые версии останутся."}, "Write a few sentences first.": {"kk": "Алдымен бірнеше сөйлем жаз.", "ru": "Сначала напиши несколько предложений."}, "Write a draft first.": {"kk": "Алдымен мәтін жаз.", "ru": "Сначала напиши черновик."}, "This revision is already saved.": {"kk": "Бұл нұсқа сақталған.", "ru": "Эта версия уже сохранена."}, "Revision saved for teacher review.": {"kk": "Нұсқа мұғалім тексеруі үшін сақталды.", "ru": "Версия сохранена для проверки учителем."}, "This rule is already in the plan.": {"kk": "Бұл ереже оқу бағытына қосылған.", "ru": "Это правило уже есть в маршруте."}, "Rule added to this learning plan.": {"kk": "Ереже оқу бағытына қосылды.", "ru": "Правило добавлено в маршрут."}, "Teacher assignment removed. Test results are unchanged.": {"kk": "Мұғалім тапсырмасы алынды. Тест нәтижелері өзгермеді.", "ru": "Назначение убрано. Результаты теста не изменились."}, "Teacher note saved.": {"kk": "Мұғалім жазбасы сақталды.", "ru": "Заметка учителя сохранена."}, "Choose a backup smaller than 5 MB.": {"kk": "5 МБ-тан кіші көшірмені таңда.", "ru": "Выбери копию размером меньше 5 МБ."}, "Restore this backup? It will replace all learner profiles on this device. Download the current backup first if you need it.": {"kk": "Осы көшірмені қалпына келтіру керек пе? Құрылғыдағы барлық профиль ауыстырылады. Қажет болса, алдымен ағымдағы көшірмені жүкте.", "ru": "Восстановить копию? Она заменит все профили на устройстве. При необходимости сначала скачай текущую копию."}, "Backup restored.": {"kk": "Көшірме қалпына келтірілді.", "ru": "Резервная копия восстановлена."}, "This file is not a valid ErrorMap English backup.": {"kk": "Бұл файл ErrorMap сақтық көшірмесіне сәйкес емес.", "ru": "Этот файл не является корректной резервной копией ErrorMap."}, "Learner data cleared.": {"kk": "Оқушы деректері тазаланды.", "ru": "Данные ученика очищены."}, "Use 2–24 letters, numbers, hyphens or underscores.": {"kk": "2–24 әріп, сан, дефис немесе төменгі сызық қолдан.", "ru": "Используй 2–24 буквы, цифры, дефисы или подчёркивания."}, "This workspace holds up to 100 learner profiles. Export a backup before clearing unused profiles.": {"kk": "Бұл аймақта 100 профильге дейін сақталады. Пайдаланылмайтын деректерді тазаламас бұрын көшірме жүкте.", "ru": "В области помещается до 100 профилей. Перед очисткой неиспользуемых данных скачай копию."}, "Workspace updated from another tab.": {"kk": "Жұмыс аймағы басқа қойындыдан жаңартылды.", "ru": "Рабочая область обновлена из другой вкладки."}, "24 matched questions with different examples.": {"kk": "Басқа мысалдармен 24 жұп сұрақ.", "ru": "24 парных вопроса с другими примерами."}, "Resume it": {"kk": "Жалғастыру", "ru": "Продолжить"}, "A lesson is saved.": {"kk": "Сабақ сақталған.", "ru": "Есть сохранённый урок."}, "before starting a new assessment.": {"kk": "жаңа тексеруді бастамас бұрын.", "ru": "перед началом новой проверки."}, "A rule check is in progress.": {"kk": "Ереже тексеруі аяқталмаған.", "ru": "Есть незаконченная проверка правила."}, "before starting another assessment.": {"kk": "басқа тексеруді бастамас бұрын.", "ru": "перед началом другой проверки."}, "Assessments": {"kk": "Тексерулер", "ru": "Проверки"}, "An earlier site version is archived in your backup. Its questions differ, so old scores are not compared with this cycle.": {"kk": "Сайттың бұрынғы нұсқасы сақтық көшірмеге енгізілген. Сұрақтары басқа болғандықтан, ескі ұпайлар осы кезеңмен салыстырылмайды.", "ru": "Предыдущая версия сайта сохранена в резервной копии. Её вопросы отличаются, поэтому старые баллы не сравниваются с этим циклом."}, "Saved data could not be opened. A recovery copy was kept on this device.": {"kk": "Сақталған деректер ашылмады. Қалпына келтіру көшірмесі осы құрылғыда сақталды.", "ru": "Не удалось открыть сохранённые данные. На устройстве оставлена копия для восстановления."}, "Third-person verb example": {"kk": "Үшінші жақ етістігінің мысалы", "ru": "Пример глагола в третьем лице"}, "ErrorMap workspace": {"kk": "ErrorMap жұмыс аймағы", "ru": "Рабочая область ErrorMap"}};
let language='en';try{const saved=localStorage.getItem('errormap-language');if(['en','kk','ru'].includes(saved))language=saved}catch{}
const originals=new WeakMap();
const reverse=new Map();for(const [en,values] of Object.entries(dictionary))for(const value of Object.values(values))if(!reverse.has(value))reverse.set(value,en);
const names={en:'English',kk:'Қазақша',ru:'Русский'};
function translate(input){const raw=String(input),core=raw.trim();if(!core)return raw;const canonical=dictionary[core]?core:(reverse.get(core)||core);if(language==='en')return raw.replace(core,canonical);
const exact=dictionary[canonical]?.[language];if(exact)return raw.replace(core,exact);
const arrow=core.match(/^([←↗→↓]?[ ]*)(.*?)([ ]*[←↗→↓])?$/);if(arrow&&dictionary[arrow[2]]?.[language])return raw.replace(core,arrow[1]+dictionary[arrow[2]][language]+(arrow[3]||''));
const k=language==='kk';
const patterns=[
[/^(Correct|Missed) → (Correct|Missed)$/,m=>(m[1]==='Correct'?(k?'Дұрыс':'Верно'):(k?'Қате':'Ошибка'))+' → '+(m[2]==='Correct'?(k?'Дұрыс':'Верно'):(k?'Қате':'Ошибка'))],
[/^(.+) · (\d+) \/ 4 independent · (\d+) assisted$/,m=>m[1]+' · '+m[2]+' / 4 '+(k?'көмексіз':'самостоятельно')+' · '+m[3]+(k?' көмекпен':' с подсказкой')],
[/^Clear all results and drafts for (.+)\? Other learners will stay\. Download a backup first if needed\.$/,m=>(k?'Осы оқушының нәтижелері мен мәтіндерін тазалау керек пе: ':'Очистить все результаты и черновики ученика ')+m[1]+(k?'? Басқа оқушылардың деректері сақталады. Қажет болса, алдымен көшірме жүкте.':'? Данные других учеников сохранятся. При необходимости сначала скачай копию.')],
[/^(\d+) rules$/,m=>m[1]+(k?' ереже':' правил')],
[/^(\d+) questions$/,m=>m[1]+(k?' сұрақ':' вопросов')],
[/^Assigned (\d+)$/,m=>(k?'Берілген: ':'Назначено: ')+m[1]],
[/^(\d+) \/ (\d+) assigned rules checked$/,m=>m[1]+' / '+m[2]+(k?' ереже тексерілді':' назначенных правил проверено')],
[/^(\d+) \/ (\d+) checked$/,m=>m[1]+' / '+m[2]+(k?' тексерілді':' проверено')],
[/^Practice (\d+) of (\d+)$/,m=>(k?'Жаттығу ':'Практика ')+m[1]+' / '+m[2]],
[/^Last practice: (\d+) \/ 4 independent first answers$/,m=>(k?'Соңғы жаттығу: ':'Последняя практика: ')+m[1]+' / 4 '+(k?'көмексіз алғашқы жауап':'самостоятельных первых ответа')],
[/^Last rule check: (\d+) \/ 2(.*?) · review answers$/,m=>(k?'Соңғы тексеру: ':'Последняя проверка: ')+m[1]+' / 2'+(m[2]?(k?' · қайталанған мысалдар':' · повторные примеры'):'')+(k?' · жауаптарды қарау':' · посмотреть ответы')],
[/^Completed (.+)$/,m=>(k?'Аяқталған күн: ':'Завершено: ')+m[1]],
[/^(\d+) rule checks complete$/,m=>m[1]+(k?' ереже тексерілді':' проверок завершено')],
[/^(\d+) examples seen before$/,m=>m[1]+(k?' мысал бұрын кездескен':' примеров встречались раньше')],
[/^(\d+) words$/,m=>m[1]+(k?' сөз':' слов')],
[/^(\d+) rules to work on$/,m=>m[1]+(k?' ережені жаттықтыру керек':' правил для практики')],
[/^Learner (.+) · local device workspace$/,m=>(k?'Оқушы ':'Ученик ')+m[1]+(k?' · осы құрылғыдағы жұмыс аймағы':' · работа на этом устройстве')],
[/^(\d+) assigned rules? needs? a successful rule check\.$/,m=>m[1]+(k?' берілген ережені тексеру қажет.':' назначенных правил нужно проверить.')],
[/^(\d+) learners saved on this device\. Use the learner button to switch profiles\.$/,m=>m[1]+(k?' оқушы осы құрылғыда сақталған. Профильді ауыстыру үшін оқушы кодын таңдаңыз.':' учеников сохранено на устройстве. Для смены профиля нажмите на код ученика.')],
[/^(\d+) suggestions — review the meaning before changing anything\.$/,m=>m[1]+(k?' ұсыныс. Түзетпес бұрын сөйлем мағынасын тексер.':' рекомендаций. Перед исправлением проверь смысл предложения.')]
];
for(const [rx,fn] of patterns){const m=core.match(rx);if(m)return raw.replace(core,fn(m))}
const fragments={'/ 4 independent':k?'/ 4 көмексіз':'/ 4 самостоятельно',' / 4 independent':k?' / 4 көмексіз':' / 4 самостоятельно','answer':k?'жауап':'ответ','answers':k?'жауап':'ответов'};if(fragments[core])return raw.replace(core,fragments[core]);
return raw;
}
function apply(root){if(!root||!document.createTreeWalker)return;const walker=document.createTreeWalker(root,NodeFilter.SHOW_TEXT),nodes=[];let node;
while(node=walker.nextNode()){const parent=node.parentElement;if(!parent||parent.closest('script,style,textarea,.answers,.english,.question-prompt,.sample-sentence,.example,.preserve-lines,[data-no-translate],.language-select'))continue;nodes.push(node)}
for(const n of nodes){if(!originals.has(n))originals.set(n,n.nodeValue);n.nodeValue=translate(originals.get(n))}
for(const el of root.querySelectorAll('[placeholder],[aria-label]')){if(el.closest('[data-no-translate]'))continue;for(const attr of ['placeholder','aria-label']){if(!el.hasAttribute(attr))continue;const key='data-i18n-'+attr;if(!el.hasAttribute(key))el.setAttribute(key,el.getAttribute(attr));el.setAttribute(attr,translate(el.getAttribute(key)))}}
document.documentElement.lang=language;const select=document.getElementById('languageSelect');if(select)select.value=language;
}
function set(value){if(!['en','kk','ru'].includes(value))return;language=value;try{localStorage.setItem('errormap-language',value)}catch{}document.documentElement.lang=value}
window.I18N={t:translate,apply,set,get language(){return language},names};
})();

````

## dist/assets/lab-workspace.css

````css
/* Shared laboratory identity for the independent and classroom workspaces. */
@import url('https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700;800&display=swap');
:root{--bg:#faf8ff;--paper:#faf8ff;--ink:#3e334d;--muted:#9a86aa;--line:#e8dff0;--brand:#9560cf;--purple:#9760d3;--soft:#f0e5fb;--green:#04b38e}body{font-family:'Manrope',system-ui,sans-serif;background:radial-gradient(ellipse at 0 5%,#f9d9ed66,transparent 40%),radial-gradient(ellipse at 100% 15%,#e9ddff88,transparent 45%),radial-gradient(ellipse at 50% 75%,#d8f6ed55,transparent 45%),#faf8ff}.card,.panel,.stat,.bank-item,.question-card{background:#ffffffbd;border-color:#ece2f5;box-shadow:0 7px 30px #ac8bc207;border-radius:20px}.hero{background:linear-gradient(120deg,#f7eafa,#e8f9f4)}button.primary,.primary{background:linear-gradient(110deg,#05c99b,#0db48e);border-color:#a8e8d2;color:#fff}.side-nav nav button{background:transparent!important;color:#9a85ab!important}.side-nav nav button.active{background:#f1e5fc!important;color:#a06fcd!important}.side-nav,.side-bottom,aside{background:#ffffffa6;border-color:#ece2f5}.app-layout .side-nav{backdrop-filter:blur(15px)}header{background:#ffffffac;border-color:#ece2f5;backdrop-filter:blur(15px)}.brand .mark,.mark{background:linear-gradient(135deg,#d455bc,#af5cd7);color:white}.brand .dot{color:#06b992}.auth-story{background:linear-gradient(140deg,#f2dcf9,#e1f9ee);color:#6a4080;border:1px solid #e6c9f0}.auth-story:after{border-color:#ba97d324;box-shadow:0 0 0 65px #ba97d307,0 0 0 130px #ba97d305}.auth-story .back-link,.auth-story p{color:#a389b3}.auth-story h1{background:linear-gradient(110deg,#dc5ba7,#8963b2,#07b590);background-clip:text;-webkit-background-clip:text;color:transparent}.auth-story .eyebrow{color:#ae7ec5}.auth-art span{border-color:#c9b0de;color:#a77cbd}.auth-art strong{background:#c7f0e1;color:#4aab89}.auth-art i{background:#c5b2d9}.auth-panel{background:#ffffffb3;border-color:#e8def1}.auth-panel input,textarea,select{border-color:#e6d9ef;background:#fffc}.next-card{background:linear-gradient(130deg,#f4e6fc,#e6f8f0);border-color:#e9d5f3}.next-art{color:#c5a3dd}.badge{background:#f1e3fa;color:#a174bd}.badge.good,.good{background:#ddf6ec;color:#49a889}.badge.bad,.bad{background:#fce8f1;color:#ca82a5}.map-center{border-color:#e3d2f0;box-shadow:0 0 30px #d9c4ee25}.map-logo{color:#b074ce}.skill-node{background:#ffffffcb;border-color:#e9dcf3}.skill-map path{stroke:#d5bfe8}.needs-review:after{background:#e5a5c7}.has-evidence:after{background:#71cdb0}.english-example{background:#f6ebfb;border-color:#ca9de2}.title-symbol{color:#bd84d7;border-color:#e1c9f1}.page-title p{color:#a18db0}.avatar{background:linear-gradient(135deg,#efcef0,#dccbf3);color:#aa6bc3;border-color:#e6c9f1}.stats-grid .stat{background:#fff9}.live-indicator:before{background:#64d3b1}.option:has(input:checked){background:#f2e7fc;border-color:#cea4e7}footer{background:#fefbff9e;border-color:#ece0f5}#notice{background:#ac76c6}.side-nav nav button:hover{background:#f7eefc!important}.tabs button{background:#faf4ff!important;color:#a383b8!important;border-color:#e7d6f1!important}.tabs button.active{background:#eddbfc!important;color:#a36bcd!important}.skill-node{color:var(--ink)!important;background:#fffc!important}.question-row button{font-size:11px}.next-card button{background:linear-gradient(110deg,#06c89c,#11b58f)!important}

/* Answer states must remain distinct from action buttons. */
.answers .answer{background:#fff;color:#3e334d;border:2px solid #e3d9ec;position:relative;padding-right:48px;cursor:pointer;text-align:left;min-height:58px}
.answers .answer:hover{background:#f7f1fc;border-color:#b391ce}
.answers .answer.selected{background:#eee2fb;border-color:#8550ba;color:#452662;box-shadow:0 0 0 2px #8550ba18}
.answers .answer.selected:after{content:'✓';position:absolute;right:18px;top:50%;transform:translateY(-50%);font-size:20px;font-weight:800;color:#7540a9}
.answers .answer em{color:#765493;background:#f0e9f7}
.answers .answer.selected em{background:#8550ba;color:#fff}
.answers .answer.right{background:#e1f6ed;border-color:#20805e;color:#175c45}
.answers .answer.wrong{background:#fff0f2;border-color:#bc4a63;color:#8c3045}
.answers .answer:focus-visible{outline:3px solid #7143a3;outline-offset:4px}

````

## dist/assets/lab.css

````css
@import url('https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700;800&display=swap');
:root{--paper:#f9f8ff;--ink:#222239;--purple:#8a47e8;--mint:#00b58d;--pink:#ef389a;--line:#e7e0f3}body{font-family:'Manrope',system-ui,sans-serif;background:radial-gradient(ellipse at 1% 11%,#ffd1e94d 0,transparent 35%),radial-gradient(ellipse at 97% 18%,#d4c2fb61 0,transparent 40%),radial-gradient(ellipse at 60% 48%,#bcf8ee52 0,transparent 35%),#faf9ff;position:relative}body:before{content:'';position:fixed;inset:0;pointer-events:none;background:repeating-linear-gradient(0deg,transparent,transparent 3px,#bfa9d508 4px);z-index:-1}header{position:sticky;top:0;max-width:none;padding:18px max(5%,calc((100vw - 1320px)/2));background:#fcfbffcf;backdrop-filter:blur(22px);border-bottom:1px solid #eae4f3;z-index:10;min-height:75px}.brand{font-size:24px;letter-spacing:-.7px}.brand-map{color:#09b993;font-weight:500}.brand-icon{background:transparent;color:#ef4ba2;border:1px solid #d9caef;font-size:26px;width:34px;height:34px;border-radius:10px;box-shadow:5px 5px 0 #adf1de52;padding-right:2px}.brand-icon>span{color:#08b58d;top:-8px;right:-4px;font-size:17px}.brand-tag{background:#efecff;border:1px solid #ddd4f7;color:#8d6cb7;font-size:8px;padding:5px 7px;border-radius:5px;margin-left:0;letter-spacing:1px}header nav{color:#7c738f;font-size:12px}.button{border-radius:24px}.dark,.login-submit{background:linear-gradient(110deg,#00c69c,#03b892);color:white;border-color:#8fe9cc;box-shadow:0 4px 18px #00bd9426}.dark:hover{background:linear-gradient(110deg,#03b991,#0ba78a)}main{max-width:1320px;padding:0 3%}.hero{grid-template-columns:.88fr 1.25fr;gap:48px;align-items:center;padding:75px 0 60px;min-height:810px}.hero-copy>.eyebrow{font-size:9px;letter-spacing:3px;color:#a076c0}.eyebrow-line{height:1px;width:27px;background:#a26ad5}.hero-copy h1.lab-title{font-size:clamp(70px,7.8vw,106px);line-height:1.02;margin:26px 0 24px;letter-spacing:-7px;font-weight:800;background:linear-gradient(110deg,#f338a0 3%,#d84b9e 35%,#07b98e 80%);background-clip:text;-webkit-background-clip:text;color:transparent;position:relative;overflow:visible;padding-right:6px}.title-spark{font-size:47px;font-weight:400;position:absolute;right:0;top:-19px;color:#b598e7}.lab-motto{font-size:23px;font-weight:500;line-height:1.6;letter-spacing:-.6px;max-width:440px;margin:0 0 15px}.lab-motto>span:last-child{color:#00b68e;font-weight:700}.hero-description{font-size:14px;line-height:1.9;color:#867b95;max-width:405px;margin-bottom:28px}.login-glass{background:linear-gradient(140deg,#ffffffd6,#ffffff8a);border:1px solid #fff;outline:1px solid #e4daf080;box-shadow:0 15px 50px #9671bd0b,inset 0 0 25px #fff;border-radius:23px;padding:24px;max-width:450px;position:relative;backdrop-filter:blur(20px)}.login-glass:before{content:'';width:21px;height:21px;position:absolute;top:-2px;left:-2px;border-left:1px solid #ae80dc;border-top:1px solid #ae80dc;border-radius:22px 0 0 0}.role-toggle{display:flex;padding:5px;background:#fcfaff85;border:1px solid #e1d7ee;border-radius:17px;gap:5px;margin-bottom:20px}.role-toggle button{background:transparent;border:0;flex:1;padding:12px 8px;border-radius:12px;font-size:12px;color:#8e80a0;display:flex;align-items:center;justify-content:center;gap:9px;font-weight:600}.role-toggle button>span:first-child{font-size:18px;font-weight:400}.role-toggle button[aria-checked=true]{background:linear-gradient(110deg,#f0e3ff,#ece4ff);box-shadow:0 3px 12px #a676df1f,inset 0 1px #fff;color:#8a49cb}#homeLogin label{display:block;font-size:10px;color:#8c7a9e;margin-bottom:14px;font-weight:600}#homeLogin input{width:100%;padding:13px 15px;border:1px solid #e4d9ee;border-radius:12px;background:#fff9;font:13px 'Manrope',system-ui;color:#3b3050;display:block;margin-top:6px;outline-offset:3px}#homeLogin input:focus{outline:2px solid #c9b0ed;border-color:#c9b0ed}.password-wrap{display:block;position:relative}.password-wrap input{padding-right:45px!important}#passwordEye{position:absolute;right:9px;top:8px;width:30px;height:30px;border:0;background:transparent;color:#ae9ac3;font-size:15px;border-radius:50%}.login-submit{width:100%;border:1px solid #83e7c7;border-radius:13px;display:flex;align-items:center;justify-content:center;gap:18px;padding:14px;font:600 12px 'Manrope',system-ui;cursor:pointer;margin-top:20px;transition:transform .2s,filter .2s}.login-submit:hover{filter:brightness(1.03);transform:translateY(-1px)}.login-submit:disabled{opacity:.6;cursor:wait}.login-bottom{display:flex;align-items:center;justify-content:space-between;margin-top:17px;font-size:10px;gap:12px;color:#aa8abe}.login-bottom>button{border:0;background:transparent;font:inherit;color:#87659f;padding:5px;cursor:pointer}.guest-note{font-size:9px;color:#aa9eb7;line-height:1.6;margin:12px 0 0;text-align:center}.login-message{font-size:11px;background:#fff5fa;color:#b76d91;border:1px solid #edd3e5;padding:10px;border-radius:8px;margin:12px 0 0}.hero-visual{padding:0;margin-top:90px;max-width:none;animation:arrive .9s .15s both}.holo-stage{height:590px;border-radius:24px;background:linear-gradient(135deg,#ffffffc7,#f8ffffaa);border:1px solid #fff;outline:1px solid #ded5ed;box-shadow:0 0 60px #c2b3ea14,inset 0 0 45px #fff;position:relative;overflow:hidden;perspective:1000px}.holo-stage:before,.holo-stage:after{content:'';position:absolute;width:26px;height:26px;z-index:2;pointer-events:none}.holo-stage:before{top:8px;left:8px;border-top:1px solid #bb91df;border-left:1px solid #bb91df}.holo-stage:after{bottom:8px;right:8px;border-bottom:1px solid #bb91df;border-right:1px solid #bb91df}.holo-top{display:flex;align-items:center;gap:7px;font-family:monospace;font-size:8px;letter-spacing:1.7px;color:#ab85c6;padding:23px}.live-dot{height:5px;width:5px;border-radius:50%;background:#63dcbd;box-shadow:0 0 12px #63dcbd}.holo-coordinates{margin-left:auto;color:#c2add0;font-size:7px;letter-spacing:1px}.holo-object{position:absolute;top:100px;left:0;right:0;height:330px;transform-style:preserve-3d;transition:transform .3s ease-out}.crystal{position:absolute;height:290px;width:220px;left:50%;top:5px;transform:translateX(-50%);filter:drop-shadow(0 0 25px #d6b2f44d);animation:crystalFloat 7s ease-in-out infinite;transform-origin:50% 65%}.crystal-word{position:absolute;font-size:29px;font-weight:650;letter-spacing:-.9px;white-space:nowrap;transition:opacity .35s,translate .35s}.crystal-word.wrong{color:#ed4f9c;left:9%;top:70px;text-shadow:0 4px 28px #ef60a426;animation:wordFloat 6s ease-in-out infinite}.crystal-word.corrected{color:#0ab891;right:6%;top:174px;animation:wordFloat 6s 1s ease-in-out infinite;text-shadow:0 4px 28px #00c49e1c}.floating-code{position:absolute;color:#c2a4dc;font-size:16px;font-weight:500;font-family:monospace}.c1{right:15%;top:20px;color:#bea6dd}.c2{left:12%;top:225px;color:#ed9ec3}.c3{right:9%;top:270px;color:#85d9c2}.c4{left:30%;top:8px;font-size:10px;color:#d3c2e3}.holo-rings{position:absolute;top:365px;left:12%;width:76%;height:120px}.holo-rings i{border:1px solid #d3c8e7;border-radius:50%;height:86px;width:100%;position:absolute;top:0;opacity:.7;box-shadow:0 0 20px #c7b6eb09}.holo-rings i:nth-child(2){inset:14px 9%;width:82%;height:58px;border-color:#c6eee3;opacity:.65}.holo-rings i:nth-child(3){inset:28px 22%;width:56%;height:30px;border-color:#e1d4f0;opacity:.5}.morph-pill{position:absolute;bottom:74px;left:50%;transform:translateX(-50%);display:flex;align-items:center;gap:17px;padding:13px 20px;border:1px solid #dfd1ed;background:#ffffffc9;border-radius:30px;white-space:nowrap;box-shadow:0 6px 18px #ad8dcd1a;font-size:12px}.morph-pill>span:first-child{color:#e777ac}.morph-pill>span:nth-child(2){color:#a493b2}.morph-pill>strong{color:#0ab68e;font-weight:550}.holo-hint{position:absolute;bottom:39px;left:0;right:0;text-align:center;font-size:8px;letter-spacing:1.8px;text-transform:uppercase;color:#b6a0c7}.holo-footer{position:absolute;bottom:13px;left:23px;right:23px;display:flex;justify-content:space-between;font-size:6px;letter-spacing:1.2px;color:#c3b3d0}.scan-line{position:absolute;width:100%;height:1px;background:linear-gradient(90deg,transparent,#a6e5d42e,transparent);top:20%;animation:scan 13s linear infinite;pointer-events:none}.number-strip{padding:25px 20px;border-radius:16px;background:#ffffff60;border:1px solid #eee6f5;gap:40px;margin-bottom:10px;box-shadow:0 3px 30px #ba9ac309}.number-strip strong{background:linear-gradient(110deg,#b86acb,#12bfa1);background-clip:text;-webkit-background-clip:text;color:transparent;font-weight:700}.number-strip span{color:#9b85ab}.section-heading h2{font-weight:700;letter-spacing:-1.1px;color:#50405f}.section-heading .eyebrow{color:#b28acb;font-size:8px;letter-spacing:2px}.method-grid article{background:#ffffff85;border:1px solid #fff;outline:1px solid #eee4f4;box-shadow:0 8px 35px #a17ca80b;backdrop-filter:blur(12px);border-radius:20px}.method-grid h3{color:#715081;font-size:17px}.method-grid p{color:#a08aad;font-size:12px}.step-no{color:#bba1ce}.mini-check,.mini-route,.mini-compare{background:#f4eefa85}.mini-check>div>strong{background:#f7eaff;border-color:#dab6ed;color:#a16abb}.mini-check>div>strong i{color:#00b58d}.route-item.done{background:#ddf6ec;border-color:#afe3d1;color:#38ac85}.route-item.current{background:#f0dcff;border-color:#d2acec;color:#b275cf}.after-bar{background:linear-gradient(90deg,#d0ede2,#8ed9c1)}.before-bar{background:#efcadf}.guest-workspace{margin:10px 0 50px;scroll-margin-top:100px}.guest-welcome{display:flex;align-items:center;gap:18px;background:#ffffffab;padding:26px;border:1px solid #fff;outline:1px solid #e7d6f2;border-radius:23px;backdrop-filter:blur(20px)}.guest-avatar{width:52px;height:52px;background:linear-gradient(130deg,#bd61ec,#e948a8);color:white;border-radius:17px;display:grid;place-items:center;font-size:29px;box-shadow:0 5px 20px #b462cd35}.guest-welcome h2{font-size:22px;letter-spacing:-.7px;margin:0;font-weight:700}.guest-welcome p{font-size:11px;color:#a086b0;margin:5px 0 0}.guest-welcome .button{margin-left:auto;font-size:11px}.quick-writing{padding:26px;background:#ffffffa1;border:1px solid #eee0f5;border-radius:20px;margin-top:20px}.quick-writing>label{font-size:13px;font-weight:600;color:#8e659f;display:block;margin-bottom:15px}.quick-writing>div{display:flex;gap:12px}.quick-writing input{font:14px 'Manrope',system-ui;border:1px solid #e5d5f0;border-radius:12px;background:#fff8;padding:14px;flex:1;min-width:0;color:#766381}.quick-writing button{border:1px solid #c8eedf;border-radius:12px;background:#def5ec;color:#42a786;padding:10px 20px;font-size:11px}.guest-feature-grid{display:grid;grid-template-columns:repeat(4,1fr);gap:18px;margin-top:20px}.guest-feature-grid>a{position:relative;display:block;background:#ffffffa1;border:1px solid #fff;outline:1px solid #e8dbf3;border-radius:20px;padding:26px;transition:translate .2s,box-shadow .2s}.guest-feature-grid>a:hover{translate:0 -5px;box-shadow:0 10px 30px #be9acf22}.feature-icon{width:39px;height:39px;border-radius:12px;background:#f2e2ff;color:#b278d2;display:grid;place-items:center;font-size:22px}.guest-feature-grid>a:nth-child(2) .feature-icon{background:#def8ef;color:#68b59c}.guest-feature-grid>a:nth-child(3) .feature-icon{background:#fce2ef;color:#d68eae}.guest-feature-grid>a:nth-child(4) .feature-icon{background:#e8e6ff;color:#a59ad8}.guest-feature-grid h3{font-size:14px;margin:20px 0 10px;color:#886898;font-weight:650}.guest-feature-grid p{font-size:11px;color:#a38ab2;line-height:1.9}.feature-arrow{position:absolute;right:22px;top:24px;color:#be9cce;font-size:17px}.skills-lab{margin:0 0 65px}.lab-skills{display:grid;grid-template-columns:repeat(6,1fr);gap:14px}.lab-skills>button{border:1px solid #e9dcf5;background:#ffffffa8;border-radius:17px;padding:23px 10px;display:flex;flex-direction:column;align-items:center;gap:12px;position:relative}.lab-skills>button>span{font-size:24px;color:#bc7bd4;background:#f3e6ff80;width:44px;height:44px;display:grid;place-items:center;border-radius:13px}.lab-skills>button>strong{font-size:10px;font-weight:550;color:#a182b3}.lab-skills>button>small{font-size:8px;color:#d0bada;position:absolute;right:9px;top:8px}.lab-skills>button.active,.lab-skills>button:hover{background:#f9f1ff;border-color:#d9b5ed}.explore{scroll-margin-top:100px;background:#ffffffaa;border-color:#ecdef6;backdrop-filter:blur(15px)}.explore-rule{background:#fff7;border-color:#eee1f7}.explore-rule .example{background:#f2e8fb;color:#a47bb8}footer{max-width:none;padding:30px max(5%,calc((100vw - 1220px)/2));background:#fdfbff9e;border-color:#eae1f4}.footer-brand>span{color:#b27cd2}footer p{color:#ad92bb}footer a{color:#a17ab7}.footer-note{color:#b7a3c4}@keyframes crystalFloat{0%,100%{translate:0 -6px;rotate:0deg}50%{translate:0 10px;rotate:4deg}}@keyframes wordFloat{0%,100%{translate:0 0}50%{translate:0 -9px}}@keyframes scan{to{top:95%}}@media(max-width:1100px){.hero{gap:30px;grid-template-columns:1fr 1.15fr}.hero-copy h1.lab-title{font-size:84px;letter-spacing:-6px}.lab-motto{font-size:21px}.holo-stage{height:570px}.crystal-word{font-size:25px}.holo-object{top:100px}.hero-description{font-size:13px}.number-strip{gap:25px}.guest-feature-grid{grid-template-columns:repeat(2,1fr)}.lab-skills{grid-template-columns:repeat(3,1fr)}}@media(max-width:780px){header{padding:17px 5%;min-height:69px}.brand{font-size:22px}.brand-tag{display:none}.hero{grid-template-columns:1fr;gap:32px;padding:43px 0;min-height:0}.hero-copy h1.lab-title{font-size:clamp(66px,14vw,102px);letter-spacing:-5px;max-width:520px}.hero-copy>.eyebrow{font-size:8px;letter-spacing:2px}.lab-motto{font-size:22px;max-width:460px}.hero-description{font-size:13px;max-width:450px}.hero-visual{margin:0 auto;width:100%;max-width:550px}.holo-stage{height:500px}.holo-object{top:65px}.holo-rings{top:305px}.holo-top{font-size:7px;padding:21px}.holo-coordinates{font-size:6px}.crystal-word{font-size:27px}.crystal-word.wrong{left:6%;top:73px}.crystal-word.corrected{right:5%;top:210px}.crystal{height:255px;width:190px;top:20px}.floating-code.c2{top:242px;left:10%}.floating-code.c3{top:282px;right:12%}.morph-pill{bottom:63px;padding:12px 18px;font-size:11px}.holo-hint{bottom:30px;font-size:7px}.login-glass{max-width:none;padding:22px}.hero-copy{max-width:550px;margin:auto;width:100%}.title-spark{right:8px;font-size:40px}.number-strip{margin-top:6px;padding:22px 18px;gap:18px}.method{padding:45px 0}.guest-welcome{padding:20px;gap:14px;flex-wrap:wrap}.guest-welcome h2{font-size:19px}.guest-welcome p{font-size:9px}.guest-welcome .button{margin:7px 0 0;width:100%;justify-content:center}.quick-writing{padding:20px}.quick-writing>div{flex-direction:column}.quick-writing button{padding:13px}.guest-feature-grid{grid-template-columns:repeat(2,minmax(0,1fr));gap:13px}.guest-feature-grid>a{padding:20px}.guest-feature-grid h3{font-size:12px}.guest-feature-grid p{font-size:10px}.feature-icon{width:34px;height:34px;font-size:19px}.lab-skills{gap:10px;grid-template-columns:repeat(2,minmax(0,1fr))}.lab-skills>button{padding:22px 10px}.lab-skills>button>strong{font-size:10px}.section-heading h2{font-size:27px}.skills-lab{margin-bottom:45px}}@media(max-width:380px){.hero-copy h1.lab-title{font-size:64px;letter-spacing:-5px}.holo-stage{height:450px}.holo-object{top:50px}.holo-rings{top:275px}.crystal-word{font-size:23px}.crystal-word.corrected{right:4%;top:200px}.holo-top{padding:20px 15px;font-size:6px}.login-glass{padding:18px}.login-bottom{font-size:9px}.guest-note{font-size:8px}.guest-welcome h2{font-size:17px}.guest-welcome p{font-size:8px}.quick-writing>label{font-size:12px}}@media(prefers-reduced-motion:reduce){*,*:before,*:after{animation:none!important;transition:none!important}}

.sentence-demo{background:#ffffffc9;border:1px solid #dfd2ee;border-radius:28px;padding:38px;box-shadow:0 24px 70px #8450b211}.demo-label{font-size:10px;letter-spacing:2px;color:#8755a7;font-weight:700}.sentence-demo h2{font-size:30px;line-height:1.3;margin:20px 0 30px;letter-spacing:-1px}.sentence-before,.sentence-after{border-radius:16px;padding:20px;margin:12px 0;border:1px solid #ecdae4;background:#fff8fb}.sentence-demo span:not(.button span){font-size:11px}.sentence-before>span,.sentence-after>span{color:#766581}.sentence-demo p{font-size:20px;line-height:1.6;margin:10px 0 0;color:#3e334d}.sentence-before del{color:#ad466a;text-decoration-thickness:2px}.sentence-after{background:#edf9f3;border-color:#bfe5d2}.sentence-after strong{color:#167351;border-bottom:2px solid #59b78e}.sentence-rule{padding:20px 0 26px}.sentence-rule b{font-size:16px;color:#7544a0}.sentence-rule p{font-size:13px;color:#736080}.sentence-demo .button{font-size:13px}.hero-visual{margin-top:0}@media(max-width:740px){.sentence-demo{padding:24px}.sentence-demo h2{font-size:25px}.sentence-demo p{font-size:17px}.sentence-rule p{font-size:13px}}
.role-entry-grid{display:grid;gap:12px}.role-entry{display:grid;grid-template-columns:1fr auto;gap:4px 15px;padding:20px;background:#faf6ff;border:1px solid #ded0ec;border-radius:16px;color:#53366c}.role-entry .entry-label{font-size:11px;color:#866697;grid-column:1}.role-entry strong{font-size:14px;grid-column:1}.role-entry>span:last-child{grid-column:2;grid-row:1/3;align-self:center;font-size:24px}.student-entry{background:#e9f8f0;border-color:#bce3d0;color:#1d6c50}.student-entry .entry-label{color:#498369}.guest-entry{width:100%;border:0;background:transparent;color:#79568e;padding:15px 8px 4px;font:600 12px Manrope,system-ui;cursor:pointer}.hero{min-height:700px}.hero-copy .login-glass{max-width:460px}.hero-visual{margin-top:0}

````

## dist/assets/portal-locale.js

````javascript
(function(){
'use strict';
const rows={
'Overview':['Шолу','Обзор'], 'Classes':['Сыныптар','Классы'], 'Assignments':['Тапсырмалар','Задания'], 'Editor':['Редактор','Редактор'], 'Results':['Нәтижелер','Результаты'], 'Settings':['Баптаулар','Настройки'], 'Teacher workspace':['Мұғалім кабинеті','Кабинет учителя'], 'Student workspace':['Оқушы беті','Страница ученика'], 'Sign in':['Кіру','Войти'], 'Sign out':['Шығу','Выйти'], 'Email':['Электрондық пошта','Электронная почта'], 'Password':['Құпиясөз','Пароль'], 'Show password':['Құпиясөзді көрсету','Показать пароль'], 'Hide password':['Құпиясөзді жасыру','Скрыть пароль'], 'Display name':['Аты-жөні','Имя и фамилия'], 'Save':['Сақтау','Сохранить'], 'Saved':['Сақталды','Сохранено'], 'Create class':['Сынып құру','Создать класс'], 'Class name':['Сынып атауы','Название класса'], 'Class':['Сынып','Класс'], 'Class code':['Сынып коды','Код класса'], 'Assignment code':['Тапсырма коды','Код задания'], 'Create assignment':['Тапсырма құру','Создать задание'], 'Title':['Атауы','Название'], 'Instructions':['Нұсқаулық','Инструкция'], 'Due date':['Соңғы мерзім','Срок сдачи'], 'Optional':['Міндетті емес','Необязательно'], 'Open':['Ашық','Открыто'], 'Closed':['Жабық','Закрыто'], 'Draft':['Жоба','Черновик'], 'Published':['Жарияланды','Опубликовано'], 'Publish':['Жариялау','Опубликовать'], 'Close assignment':['Тапсырманы жабу','Закрыть задание'], 'Reopen':['Қайта ашу','Открыть снова'], 'Duplicate':['Көшірме жасау','Создать копию'], 'Copy link':['Сілтемені көшіру','Скопировать ссылку'], 'Copied':['Көшірілді','Скопировано'], 'Archive':['Мұрағатқа жіберу','В архив'], 'Restore':['Қалпына келтіру','Восстановить'], 'Archived':['Мұрағатта','В архиве'], 'Show archived':['Мұрағатты көрсету','Показать архив'], 'No classes yet':['Әзірге сынып жоқ','Классов пока нет'], 'No assignments yet':['Әзірге тапсырма жоқ','Заданий пока нет'], 'No submissions yet':['Әзірге нәтиже жоқ','Результатов пока нет'], 'Submissions':['Жіберілген жұмыстар','Сданные работы'], 'Awaiting review':['Тексеруді күтеді','Ожидают проверки'], 'Reviewed':['Тексерілді','Проверено'], 'Search':['Іздеу','Поиск'], 'All classes':['Барлық сыныптар','Все классы'], 'All assignments':['Барлық тапсырмалар','Все задания'], 'Score':['Ұпай','Баллы'], 'Submitted':['Жіберілді','Отправлено'], 'Details':['Толығырақ','Подробнее'], 'Download CSV':['CSV жүктеу','Скачать CSV'], 'Download backup':['Сақтық көшірмені жүктеу','Скачать резервную копию'], 'Print report':['Есепті басып шығару','Распечатать отчёт'], 'Student name':['Оқушының аты-жөні','Имя и фамилия ученика'], 'Teacher feedback':['Мұғалімнің пікірі','Комментарий учителя'], 'Writing':['Жазылым','Письменная работа'], 'Your answer':['Сенің жауабың','Твой ответ'], 'Correct answer':['Дұрыс жауап','Правильный ответ'], 'Explanation':['Түсіндірме','Объяснение'], 'Question':['Сұрақ','Вопрос'], 'Add question':['Сұрақ қосу','Добавить вопрос'], 'Question bank':['Тапсырмалар қоры','Банк заданий'], 'Add from bank':['Қордан қосу','Добавить из банка'], 'Remove':['Алып тастау','Убрать'], 'Move up':['Жоғары жылжыту','Выше'], 'Move down':['Төмен жылжыту','Ниже'], 'Preview':['Алдын ала қарау','Предпросмотр'], 'Save draft':['Жобаны сақтау','Сохранить черновик'], 'Build 24-question draft':['24 сұрақтық жоба құру','Собрать черновик из 24 вопросов'], 'Import questions':['Сұрақтарды импорттау','Импортировать вопросы'], 'Export questions':['Сұрақтарды экспорттау','Экспортировать вопросы'], 'All skills':['Барлық дағдылар','Все навыки'], 'All levels':['Барлық деңгейлер','Все уровни'], 'Add':['Қосу','Добавить'], 'Read the rule':['Ережені оқу','Прочитать правило'], 'Rule':['Ереже','Правило'], 'Start':['Бастау','Начать'], 'Continue':['Жалғастыру','Продолжить'], 'Back':['Артқа','Назад'], 'Next':['Келесі','Далее'], 'Review answers':['Жауаптарды қарап шығу','Проверить ответы'], 'Submit assignment':['Тапсырманы тапсыру','Отправить задание'], 'Change answer':['Жауапты өзгерту','Изменить ответ'], 'Answered':['Жауап берілді','Отвечено'], 'Not answered':['Жауап берілмеді','Нет ответа'], 'Saved on this device':['Осы құрылғыда сақталды','Сохранено на этом устройстве'], 'Independent practice':['Өз бетімен жаттығу','Самостоятельная практика'], 'Open class':['Сыныпты ашу','Открыть класс'], 'Open assignment':['Тапсырманы ашу','Открыть задание'], 'Enter a code':['Кодты енгіз','Введи код'], 'Class or assignment code':['Сынып немесе тапсырма коды','Код класса или задания'], 'Code type':['Код түрі','Тип кода'], 'Welcome back':['Қайта қош келдіңіз','С возвращением'], 'Questions':['Сұрақтар','Вопросы'], 'Report email':['Есеп жіберілетін пошта','Почта для отчётов'], 'Queued email reports':['Кезектегі пошта есептері','Отчёты в очереди отправки'], 'Mail delivery':['Поштаға жіберу','Отправка почты'], 'Setup guide':['Қосу нұсқаулығы','Инструкция подключения'], 'Loading…':['Жүктелуде…','Загрузка…'], 'Retry':['Қайта көру','Повторить'],
'cloudMissing':['Мұғалім кабинеті әлі қосылмаған. Алдымен қосу нұсқаулығын орындаңыз.','Кабинет учителя ещё не подключён. Сначала выполните инструкцию подключения.'],
'connection':['Байланыс үзілді. Жұмысың осы құрылғыда сақталды. Қайта көр.','Нет соединения. Работа сохранена на этом устройстве. Повтори попытку.'],
'signInRequired':['Кіру қажет.','Нужно войти в кабинет.'],
'Wrong login or teacher access not granted':['Пошта немесе құпиясөз қате, не мұғалімге рұқсат берілмеген.','Неверная почта или пароль, либо учителю не предоставлен доступ.'],
'Answer every question':['Барлық сұраққа жауап бер.','Ответь на все вопросы.'],
'Published content is fixed. Duplicate the assignment to edit it.':['Жарияланған тапсырма өзгермейді. Өзгерту үшін көшірме жасаңыз.','Опубликованное задание зафиксировано. Для изменений создайте копию.'],
'Create a class first':['Алдымен сынып құрыңыз.','Сначала создайте класс.'],
'Writing is reviewed by your teacher; it does not change the test score.':['Жазылымды мұғалім тексереді; ол тест ұпайын өзгертпейді.','Письменную работу проверяет учитель; она не меняет балл за тест.'],
'Explain one rule and write your own example.':['Бір ережені түсіндіріп, өз мысалыңды жаз.','Объясни одно правило и напиши свой пример.'],
'Latest answer evidence by rule':['Ереже бойынша соңғы жауаптар','Последние ответы по правилам'],
'No data yet':['Әзірге дерек жоқ','Данных пока нет'],
'The name is self-reported. This is a classroom workflow, not a protected exam.':['Аты-жөнін оқушы өзі енгізеді. Бұл — сыныптағы оқу құралы, қорғалған емтихан жүйесі емес.','Имя вводит сам ученик. Это учебный инструмент для класса, а не защищённая экзаменационная система.'],
'Independent practice is stored on this browser; class submissions are stored in the teacher workspace.':['Жеке жаттығулар осы браузерде, ал сынып тапсырмалары мұғалім кабинетінде сақталады.','Самостоятельная практика хранится в этом браузере, сданные задания — в кабинете учителя.'],
'Email reports are queued after submission when a recipient is set. Delivery needs the optional mail worker.':['Алушы көрсетілсе, есеп кезекке қосылады. Жіберу үшін қосымша пошта қызметін қосу керек.','Если указан получатель, отчёт попадает в очередь. Для отправки нужно подключить дополнительный почтовый обработчик.'],
'Use a teacher-created account. Students do not need passwords.':['Мұғалімге арнайы ашылған аккаунтты қолданыңыз. Оқушыларға құпиясөз қажет емес.','Используйте заранее созданный аккаунт учителя. Ученикам пароль не нужен.'],
'This draft is saved on this device. Save draft to sync it to your account.':['Жоба осы құрылғыда сақталған. Аккаунтқа сақтау үшін «Жобаны сақтау» батырмасын басыңыз.','Черновик сохранён на этом устройстве. Нажмите «Сохранить черновик», чтобы записать его в аккаунт.'],
'Question limit: 50':['Шектеу: 50 сұрақ','Лимит: 50 вопросов'],
'Duplicate names may represent different learners.':['Бірдей аттар әртүрлі оқушыға тиесілі болуы мүмкін.','Одинаковые имена могут принадлежать разным ученикам.'],
'No automatic language grade':['Тілдік сапа автоматты бағаланбайды','Языковое качество автоматически не оценивается'],
'Class not found':['Сынып табылмады','Класс не найден'],
'Invalid class code':['Сынып коды қате','Неверный код класса'],
'Invalid assignment code':['Тапсырма коды қате','Неверный код задания'],
'Assignment not found, closed or overdue':['Тапсырма табылмады, жабық немесе мерзімі өтті.','Задание не найдено, закрыто или срок сдачи истёк.'],
'Assignment closed or overdue':['Тапсырма жабық немесе мерзімі өтті.','Задание закрыто или срок сдачи истёк.'],
'Waiting for configuration':['Қосылмаған','Ожидает подключения'],
'Discard local draft':['Осы құрылғыдағы жобаны өшіру','Удалить локальный черновик'],
'Discard this local draft?':['Осы құрылғыдағы жобаны өшіру керек пе?','Удалить этот локальный черновик?'],
'Leave with unsaved changes?':['Сақталмаған өзгерістер бар. Шығу керек пе?','Есть несохранённые изменения. Уйти?']
};
window.EMLocale={language:localStorage.getItem('errormap-language')||'en',t(key){const lang=this.language;const aliases={cloudMissing:'Connect Supabase first. Open the setup guide to enable teacher accounts.',connection:'Connection failed. Please try again.',signInRequired:'Sign in to your teacher account.',teacherOnly:'Teacher access has not been granted.'};return lang==='en'?(aliases[key]||key):(rows[key]?.[lang==='kk'?0:1]||window.I18N?.t(key)||key)},set(lang){this.language=['en','kk','ru'].includes(lang)?lang:'en';localStorage.setItem('errormap-language',this.language);window.I18N?.set(this.language);document.documentElement.lang=this.language}};
window.EMLocale.set(window.EMLocale.language);
})();

````

## dist/assets/portal.css

````css
@import url('https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700;800&display=swap');
:root{--bg:#faf8ff;--paper:#fff;--ink:#30283e;--muted:#776584;--line:#e4d9ef;--brand:#8350b2;--soft:#f0e5fb;--green:#137b5d;--red:#ac3655}*{box-sizing:border-box}body{margin:0;color:var(--ink);background:radial-gradient(ellipse at 0 0,#fae5f3,transparent 50%),radial-gradient(ellipse at 100% 20%,#e6dcfb,transparent 45%),var(--bg);font:14px/1.65 Manrope,system-ui,sans-serif}button,input,select,textarea{font:inherit}button,a,input,select,textarea{-webkit-tap-highlight-color:transparent}a{color:var(--brand);text-decoration:none}button,.button{display:inline-flex;align-items:center;justify-content:center;gap:9px;min-height:44px;padding:11px 17px;border:1px solid transparent;border-radius:12px;background:var(--brand);color:white;cursor:pointer;font-weight:700}button:hover:not(:disabled),.button:hover{filter:brightness(.96)}button:disabled{opacity:.4;cursor:not-allowed}.secondary{background:white;border-color:var(--line);color:var(--ink)}.danger{color:var(--red);background:#fff0f4;border-color:#edc6d2}:focus-visible{outline:3px solid #aa7bd2;outline-offset:4px}header{height:78px;display:flex;align-items:center;justify-content:space-between;gap:20px;padding:15px 4%;background:#ffffffe0;border-bottom:1px solid var(--line)}.brand{font-weight:800;font-size:25px;letter-spacing:-1px;color:var(--ink)}.brand span{color:var(--green)}.header-tools,.actions{display:flex;align-items:center;flex-wrap:wrap;gap:10px}header select{width:auto;margin:0}.shell{display:grid;grid-template-columns:220px minmax(0,1fr);min-height:calc(100vh - 78px)}.sidebar{padding:25px 15px;border-right:1px solid var(--line);background:#ffffff85}.sidebar nav{display:grid;gap:6px;position:sticky;top:20px}.sidebar a{padding:12px 16px;border-radius:12px;color:var(--muted)}.sidebar a.active{background:var(--soft);color:var(--brand);font-weight:800}.sidebar small{padding:12px 16px;font-size:11px}main{width:100%;max-width:1280px;margin:auto;padding:36px 40px 70px;align-self:start}main.student{max-width:1100px;min-height:75vh}main.login{max-width:540px;min-height:75vh;padding-top:60px}.page-top{display:flex;justify-content:space-between;align-items:center;gap:20px;margin-bottom:26px}.eyebrow{font-size:10px;letter-spacing:2.5px;color:var(--brand);font-weight:800}h1{font-size:clamp(27px,3.7vw,39px);letter-spacing:-1.2px;line-height:1.25;margin:8px 0 10px}h2{font-size:21px;letter-spacing:-.5px;margin:0 0 14px}h3{font-size:16px;margin:0 0 8px}p{margin:9px 0}.muted,small{color:var(--muted)}.card{padding:25px;border:1px solid var(--line);border-radius:20px;background:#ffffffde;box-shadow:0 12px 35px #8660a308;margin-bottom:20px}.grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(245px,1fr));gap:18px}.grid .card{margin:0}.stat b{font-size:35px;display:block;line-height:1.5;letter-spacing:-1px}.stat span{color:var(--muted);font-size:12px}.score{font-size:52px;font-weight:800;letter-spacing:-2px;color:var(--brand)}label{display:block;font-size:12px;font-weight:700;margin-bottom:16px}input,select,textarea{display:block;width:100%;padding:12px 13px;border:1px solid var(--line);border-radius:10px;background:white;color:var(--ink);margin-top:7px}textarea{min-height:100px;resize:vertical}input[type=checkbox],input[type=radio]{width:auto;margin:0;accent-color:var(--brand)}.inline{display:flex;align-items:center;gap:10px}.badge{display:inline-block;padding:4px 9px;border-radius:7px;background:var(--soft);color:var(--brand);font-size:11px;font-weight:800}.badge.green{color:var(--green);background:#e1f4eb}.badge.red{color:var(--red);background:#fff0f4}.filters{display:flex;gap:12px;flex-wrap:wrap;margin:22px 0}.filters>*{flex:1;min-width:160px;margin:0}.table-wrap{overflow-x:auto}table{width:100%;border-collapse:collapse;font-size:12px}th,td{text-align:left;padding:13px 10px;border-bottom:1px solid var(--line);vertical-align:top;white-space:normal}th{font-weight:700;color:var(--muted)}td button{min-height:36px;padding:7px 12px;font-size:11px}.question-edit,.review-item{padding:22px 0;border-top:1px solid var(--line)}.question-edit:first-child{border-top:0}.question-edit .options{display:grid;grid-template-columns:repeat(3,1fr);gap:12px}.bank-list{max-height:560px;overflow:auto}.bank-row{border-bottom:1px solid var(--line);padding:15px 0;display:flex;align-items:flex-start;justify-content:space-between;gap:14px}.bank-row p{font-size:13px}.bank-row small{font-size:11px}.answer{display:flex;align-items:center;gap:13px;cursor:pointer;border:2px solid var(--line);border-radius:12px;background:white;padding:16px;margin:10px 0;font-size:15px;font-weight:500;min-height:58px}.answer:has(input:checked){background:var(--soft);border-color:var(--brand)}.answer:has(input:checked):after{content:'✓';margin-left:auto;color:var(--brand);font-weight:800}.answer-index{display:grid;grid-template-columns:repeat(6,1fr);gap:9px;margin:24px 0}.answer-index button{background:white;border-color:var(--line);color:var(--ink)}.answer-index button.answered{background:var(--soft);border-color:#c8a6e4;color:var(--brand)}.progress{height:5px;border-radius:10px;background:#eee6f5;margin:18px 0 28px;overflow:hidden}.progress span{display:block;height:100%;background:var(--brand)}.test-question{font-size:24px;margin:20px 0 25px}.correct{color:var(--green)}.incorrect{color:var(--red)}.empty{text-align:center;padding:50px 25px}.empty p{color:var(--muted);margin-bottom:20px}#notice{max-width:1130px;margin:16px auto 0;padding:13px 18px;border:1px solid #dcc9ed;border-radius:12px;background:#f2e9fb;color:var(--brand)}#notice.error{color:var(--red);border-color:#ecc4d0;background:#fff1f5}[hidden]{display:none!important}code{background:#f4edf9;border-radius:7px;padding:5px 8px;overflow-wrap:anywhere;display:inline-block;font-size:12px}.links{display:grid;gap:12px}.links a{padding:16px;border:1px solid var(--line);border-radius:12px;background:white}.auth-foot{margin-top:18px;font-size:12px;color:var(--muted)}footer{padding:22px;text-align:center;color:var(--muted);font-size:11px;border-top:1px solid var(--line)}dialog{border:1px solid var(--line);border-radius:22px;padding:26px;max-width:780px;width:calc(100% - 36px);max-height:85vh;overflow:auto;box-shadow:0 20px 80px #48285825}dialog::backdrop{background:#36204570;backdrop-filter:blur(3px)}.result-writing{white-space:pre-wrap;overflow-wrap:anywhere}.mobile-title{display:none}.print-only{display:none}
@media(max-width:900px){.shell{grid-template-columns:1fr}.sidebar{padding:10px;border-right:0;border-bottom:1px solid var(--line)}.sidebar nav{display:flex;overflow-x:auto;position:static;white-space:nowrap}.sidebar a{padding:10px 13px;font-size:12px}.sidebar small{display:none}main{padding:27px 20px 60px}.question-edit .options{grid-template-columns:1fr}.page-top{align-items:flex-start;flex-wrap:wrap}.answer-index{grid-template-columns:repeat(4,1fr)}}@media(max-width:550px){header{height:auto;min-height:74px;padding:14px 18px;flex-wrap:wrap}.header-tools .button,.header-tools button{font-size:11px;min-height:38px;padding:8px 12px}.brand{font-size:22px}.card{padding:20px}.actions>button,.actions>.button{font-size:12px}.test-question{font-size:21px}.grid{grid-template-columns:1fr}main.login{padding-top:30px}}@media print{header,.sidebar,footer,#notice,.no-print,form,.actions,.filters,.page-top .button,.page-top button{display:none!important}.shell{display:block}body{background:white;color:black}.card{box-shadow:none;background:white;border:1px solid #ddd;break-inside:avoid}main{padding:0;max-width:none}.print-only{display:block}}

````

## dist/assets/portal.js

````javascript
(function(){
'use strict';
const $=s=>document.querySelector(s), L=window.EMLocale, C=window.EMCloud;
const E=v=>String(v??'').replace(/[&<>"']/g,c=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]));
const T=k=>L.t(k), tr=k=>`<span data-i="${E(k)}">${E(T(k))}</span>`;
const PAGE=document.body.dataset.portal;
const TEACHER_PAGES=['teacher-dashboard','classes','assignments','task-editor','class-results','teacher-settings'];
let data={profile:{},classes:[],tasks:[],results:[],mail:[]}, editor=null,dirty=false, currentTask=null,attempt=null,loading=false;
function read(key,fallback=null){try{return JSON.parse(localStorage.getItem(key))??fallback}catch{return fallback}}
function store(key,value){try{localStorage.setItem(key,JSON.stringify(value));return true}catch{message(T('Not saved'),true);return false}}
function message(text='',error=false){const n=$('#notice');n.textContent=text;n.classList.toggle('error',error);n.hidden=!text}
function failure(e){message(T(e.message||'connection'),true)}
function translate(){document.documentElement.lang=L.language;$('#languageSelect').value=L.language;document.querySelectorAll('[data-i]').forEach(n=>n.textContent=T(n.dataset.i));document.querySelectorAll('[data-placeholder]').forEach(n=>n.placeholder=T(n.dataset.placeholder));document.querySelectorAll('[data-aria]').forEach(n=>n.setAttribute('aria-label',T(n.dataset.aria)));document.title=T(document.body.dataset.title)+' — ErrorMap'}
function mount(html){$('#app').innerHTML=html;translate()}
function button(text,action,extra=''){return `<button type="button" data-action="${action}" ${extra}>${tr(text)}</button>`}
function link(text,href,cls='button secondary'){return `<a class="${cls}" href="${E(href)}">${tr(text)} ↗</a>`}
function top(title,actions=''){return `<div class="page-top"><div><span class="eyebrow">ERRORMAP · ${(TEACHER_PAGES.includes(PAGE)||PAGE==='teacher-login')?'TEACHER':'STUDENT'}</span><h1>${tr(title)}</h1></div><div class="actions">${actions}</div></div>`}
function empty(title,action=''){return `<section class="card empty"><h2>${tr(title)}</h2>${action}</section>`}
function status(t){return !t.published_at?'Draft':t.is_open?'Open':'Closed'}
function badge(text,green=false){return `<span class="badge ${green?'green':''}">${tr(text)}</span>`}
function formatDate(v){return v?new Date(v).toLocaleString(L.language==='kk'?'kk-KZ':L.language==='ru'?'ru-RU':'en-GB'):'—'}
function taskLink(t){return new URL('student-task.html?code='+t.code,location.href).href}
function classLink(c){return new URL('student.html?class='+c.code,location.href).href}
async function copy(value){try{await navigator.clipboard.writeText(value);message(T('Copied'))}catch{message(value)}}
function download(name,body,type='application/json'){const url=URL.createObjectURL(new Blob([body],{type}));const a=document.createElement('a');a.href=url;a.download=name;a.click();setTimeout(()=>URL.revokeObjectURL(url),1500)}
function csvCell(v){let s=String(v??'');if(/^[=+\-@\t\r]/.test(s))s="'"+s;return '"'+s.replace(/"/g,'""')+'"'}
function exportResults(rows){download('ErrorMap-results.csv','\uFEFF'+[['Name','Class','Assignment','Score','Total','Submitted','Reviewed','Writing','Feedback'],...rows.map(r=>[r.student_name,r.class_name,data.tasks.find(t=>t.id===r.task_id)?.title,r.score,r.total,r.submitted_at,r.reviewed,r.writing,r.teacher_feedback])].map(row=>row.map(csvCell).join(',')).join('\r\n'),'text/csv;charset=utf-8')}
function qs(){return new URLSearchParams(location.search)}
function formObject(form){return Object.fromEntries(new FormData(form))}
async function withForm(form,fn){const controls=[...form.querySelectorAll('button[type=submit]')];controls.forEach(b=>b.disabled=true);message('');try{await fn()}catch(e){failure(e)}finally{controls.forEach(b=>b.disabled=false)}}
async function all(table){let rows=[],offset=0;while(true){const part=await C.api(`${table}?select=*&order=created_at.desc&limit=500&offset=${offset}`.replace(table==='em_results'?'created_at':'__NONE__','submitted_at'));rows.push(...part);if(part.length<500)break;offset+=500}return rows}
async function loadTeacher(){
 const results=await Promise.all([C.api('em_teachers?select=*'),all('em_classes'),all('em_tasks'),all('em_results'),all('em_mail_queue')]);
 if(!results[0].length)throw Error('teacherOnly');
 [data.profile,data.classes,data.tasks,data.results,data.mail]=[results[0][0],...results.slice(1)];return data;
}
function renderLogin(){
 mount(top('Teacher workspace')+`<section class="card"><h2>${tr('Sign in')}</h2><form id="loginForm"><label>${tr('Email')}<input type="email" name="email" autocomplete="username" required maxlength="254"></label><label>${tr('Password')}<input id="loginPassword" type="password" name="password" autocomplete="current-password" required></label><label class="inline"><input id="showPassword" type="checkbox">${tr('Show password')}</label><button type="submit">${tr('Sign in')} ↗</button></form><p class="auth-foot">${tr('Use a teacher-created account. Students do not need passwords.')}</p></section>`+link('Setup guide','SETUP.html'));
 $('#showPassword').onchange=e=>{$('#loginPassword').type=e.target.checked?'text':'password'};
 $('#loginForm').onsubmit=e=>{e.preventDefault();withForm(e.currentTarget,async()=>{const v=formObject(e.currentTarget);try{await C.login(v.email.trim(),v.password)}catch(err){if(err.message==='cloudMissing')throw err;throw Error('Wrong login or teacher access not granted')}location.href='teacher-dashboard.html'})};
}
function renderDashboard(){
 const stats=[['Classes',data.classes.filter(c=>!c.archived).length],['Open',data.tasks.filter(t=>t.is_open).length],['Submissions',data.results.length],['Awaiting review',data.results.filter(r=>!r.reviewed).length]];
 mount(top('Overview',link('Create assignment','task-editor.html','button'))+`<div class="grid">${stats.map(([name,value])=>`<section class="card stat"><span>${tr(name)}</span><b>${value}</b></section>`).join('')}</div><section class="card" style="margin-top:24px"><h2>${tr('Welcome back')}${data.profile.display_name?', '+E(data.profile.display_name):''}</h2><div class="links">${link('Classes','classes.html')}${link('Assignments','assignments.html')}${link('Results','class-results.html')}</div></section><section class="card"><h2>${tr('Submissions')}</h2>${resultTable(data.results.slice(0,5))}</section>`);
}
function renderClasses(){
 const archived=qs().get('archived')==='1';const classes=data.classes.filter(c=>c.archived===archived);
 mount(top('Classes',link(archived?'Classes':'Show archived','classes.html'+(archived?'':'?archived=1')))+`<section class="card"><form id="classForm" class="actions"><label style="flex:1;margin:0">${tr('Class name')}<input name="name" required maxlength="60" placeholder="7 A"></label><button type="submit">${tr('Create class')} +</button></form></section><div class="grid">${classes.map(c=>{const tasks=data.tasks.filter(t=>t.class_id===c.id);const ids=new Set(tasks.map(t=>t.id));const results=data.results.filter(r=>ids.has(r.task_id));return `<article class="card"><span class="badge">${tr(c.archived?'Archived':'Class')}</span><h2 style="margin-top:14px">${E(c.name)}</h2><p>${tr('Assignments')}: ${tasks.length} · ${tr('Submissions')}: ${results.length}</p><p>${tr('Class code')}<br><code>${E(c.code)}</code></p><div class="actions">${button('Copy link','copy-class',`data-id="${c.id}" class="secondary"`)}${link('Results','class-results.html?class='+c.id)}${button(c.archived?'Restore':'Archive','archive-class',`data-id="${c.id}" class="secondary"`)}</div></article>`}).join('')}</div>${classes.length?'':empty('No classes yet')}`);
 $('#classForm').onsubmit=e=>{e.preventDefault();withForm(e.currentTarget,async()=>{const v=formObject(e.currentTarget);await C.api('em_classes',{method:'POST',body:JSON.stringify({teacher_id:C.session().uid,name:v.name.trim()})});await loadTeacher();renderClasses();message(T('Saved'))})};
}
function renderAssignments(){
 const filter=qs().get('class')||'';const tasks=data.tasks.filter(t=>!filter||t.class_id===filter);
 mount(top('Assignments',link('Create assignment','task-editor.html','button'))+`<div class="filters"><select id="taskClass" aria-label="${E(T('Class'))}"><option value="" data-i="All classes">${E(T('All classes'))}</option>${data.classes.map(c=>`<option value="${c.id}" ${filter===c.id?'selected':''}>${E(c.name)}</option>`).join('')}</select></div><div class="grid">${tasks.map(t=>`<article class="card">${badge(status(t),t.is_open)}<h2 style="margin-top:14px">${E(t.title)}</h2><p class="muted">${E(data.classes.find(c=>c.id===t.class_id)?.name)} · ${t.questions.length} ${tr('Questions')}</p><p>${tr('Due date')}: ${E(formatDate(t.due_at))}</p><p>${tr('Submissions')}: ${data.results.filter(r=>r.task_id===t.id).length}</p>${t.published_at?`<p><code>${E(t.code)}</code></p>`:''}<div class="actions">${link(t.published_at?'Preview':'Editor','task-editor.html?id='+t.id)}${button('Duplicate','duplicate',`data-id="${t.id}" class="secondary"`)}${t.published_at?button('Copy link','copy-task',`data-id="${t.id}" class="secondary"`):''}${button(!t.published_at?'Publish':t.is_open?'Close assignment':'Reopen','toggle-task',`data-id="${t.id}"`)}${link('Results','class-results.html?task='+t.id)}</div></article>`).join('')}</div>${tasks.length?'':empty('No assignments yet')}`);
 $('#taskClass').onchange=e=>location.href='assignments.html'+(e.target.value?'?class='+e.target.value:'');
}
function draftKey(id='new'){return 'errormap-cloud-draft:'+C.session().uid+':'+id}
function validateQuestions(questions){
 if(!Array.isArray(questions)||questions.length<1||questions.length>50)throw Error('Use 1 to 50 questions');
 for(const q of questions){if(typeof q.prompt!=='string'||!q.prompt.trim()||q.prompt.length>1000||!Array.isArray(q.options)||q.options.length!==3||q.options.some(o=>typeof o!=='string'||!o.trim()||o.length>300)||new Set(q.options.map(o=>o.trim().toLowerCase())).size!==3||![0,1,2].includes(q.answer)||typeof q.explanation!=='string'||!q.explanation.trim()||q.explanation.length>2000)throw Error('Invalid question');}
 return true;
}
function captureEditor(){if(!editor||!$('#taskForm'))return;const f=$('#taskForm');editor.title=f.elements.title.value;editor.instructions=f.elements.instructions.value;editor.class_id=f.elements.class_id.value;editor.due_at=f.elements.due_at.value||'';
 document.querySelectorAll('[data-question]').forEach(n=>{const q=editor.questions[Number(n.dataset.question)];q.prompt=n.querySelector('[name=prompt]').value;q.options=[0,1,2].map(i=>n.querySelector('[name=option'+i+']').value);q.answer=Number(n.querySelector('[name=answer]').value);q.explanation=n.querySelector('[name=explanation]').value});
}
function persistEditor(){captureEditor();dirty=true;store(draftKey(editor.id||'new'),editor);$('#draftStatus').textContent=T('This draft is saved on this device. Save draft to sync it to your account.')}
function renderEditor(){
 if(!data.classes.some(c=>!c.archived)){mount(top('Editor')+empty('Create a class first',link('Create class','classes.html','button')));return}
 const id=qs().get('id');const existing=data.tasks.find(t=>t.id===id);if(id&&!existing)throw Error('Assignment not found');
 const local=read(draftKey(id||'new'));const base=existing?structuredClone(existing):{title:'',instructions:'',class_id:data.classes.find(c=>!c.archived).id,questions:[],due_at:''};
 editor=existing?.published_at?base:(local&&local.id===base.id?local:base);dirty=Boolean(local&&!existing?.published_at);
 mount(top('Editor')+`<section class="card"><form id="taskForm"><div class="grid"><label>${tr('Title')}<input name="title" required maxlength="120" value="${E(editor.title)}"></label><label>${tr('Class')}<select name="class_id">${data.classes.filter(c=>!c.archived||c.id===editor.class_id).map(c=>`<option value="${c.id}" ${c.id===editor.class_id?'selected':''}>${E(c.name)}</option>`).join('')}</select></label><label>${tr('Due date')} · ${tr('Optional')}<input name="due_at" type="datetime-local" value="${E(editor.due_at?localDate(editor.due_at):'')}"></label></div><label>${tr('Instructions')}<textarea name="instructions" maxlength="2000">${E(editor.instructions)}</textarea></label><p id="draftStatus" class="muted">${editor.published_at?tr('Published content is fixed. Duplicate the assignment to edit it.'):dirty?tr('This draft is saved on this device. Save draft to sync it to your account.'):''}</p><div id="questionEditor"></div><div class="actions no-print">${editor.published_at?'':`${button('Add question','add-question','class="secondary"')}${button('Question bank','bank','class="secondary"')}${button('Build 24-question draft','build-test','class="secondary"')}${button('Import questions','import','class="secondary"')}`}${button('Preview','preview','class="secondary"')}${button('Export questions','export-questions','class="secondary"')}${editor.published_at?'':`<button type="submit">${tr('Save draft')}</button>${button('Discard local draft','discard-draft','class="danger"')}`}</div><input type="file" id="importFile" accept="application/json,.json" hidden></form></section>`);
 drawEditor();const f=$('#taskForm');
 if(editor.published_at){f.querySelectorAll('input:not([type=file]),textarea,select').forEach(n=>n.disabled=true)}else{f.addEventListener('input',persistEditor);f.addEventListener('change',persistEditor)}
 f.onsubmit=e=>{e.preventDefault();withForm(f,async()=>{captureEditor();validateQuestions(editor.questions);const payload={title:editor.title.trim(),instructions:editor.instructions.trim(),class_id:editor.class_id,questions:editor.questions,due_at:editor.due_at?new Date(editor.due_at).toISOString():null};if(!payload.title)throw Error('Title');await C.api('em_tasks'+(editor.id?'?id=eq.'+editor.id:''),{method:editor.id?'PATCH':'POST',body:JSON.stringify(editor.id?payload:{...payload,teacher_id:C.session().uid})});localStorage.removeItem(draftKey(editor.id||'new'));dirty=false;location.href='assignments.html'})};
 $('#importFile').onchange=async e=>{const file=e.target.files[0];if(!file)return;try{if(file.size>500000)throw Error('Question limit: 50');const list=JSON.parse(await file.text());validateQuestions(list);captureEditor();if(editor.questions.length+list.length>50)throw Error('Question limit: 50');editor.questions.push(...list.map(q=>({prompt:q.prompt,options:q.options.slice(),answer:q.answer,explanation:q.explanation,unit:typeof q.unit==='string'?q.unit:'custom'})));drawEditor();persistEditor()}catch(err){failure(err)}e.target.value=''};
}
function localDate(value){const d=new Date(value);if(Number.isNaN(d.valueOf()))return '';return new Date(d.getTime()-d.getTimezoneOffset()*60000).toISOString().slice(0,16)}
function drawEditor(){const locked=Boolean(editor.published_at);$('#questionEditor').innerHTML=editor.questions.map((q,i)=>`<article class="question-edit" data-question="${i}"><div class="actions"><h3>${i+1}. ${E(window.ERRORMAP_CONTENT.units.find(u=>u.id===q.unit)?.title||T('Question'))}</h3>${locked?'':`${button('Move up','move-up',`data-index="${i}" class="secondary" ${i===0?'disabled':''}`)}${button('Move down','move-down',`data-index="${i}" class="secondary" ${i===editor.questions.length-1?'disabled':''}`)}${button('Remove','remove-question',`data-index="${i}" class="danger"`)}`}</div><label>${tr('Question')}<textarea name="prompt" required maxlength="1000" ${locked?'disabled':''}>${E(q.prompt)}</textarea></label><div class="options">${q.options.map((o,n)=>`<label>${String.fromCharCode(65+n)}<input name="option${n}" required maxlength="300" value="${E(o)}" ${locked?'disabled':''}></label>`).join('')}</div><label>${tr('Correct answer')}<select name="answer" ${locked?'disabled':''}>${[0,1,2].map(n=>`<option value="${n}" ${q.answer===n?'selected':''}>${String.fromCharCode(65+n)}</option>`).join('')}</select></label><label>${tr('Explanation')}<textarea name="explanation" required maxlength="2000" ${locked?'disabled':''}>${E(q.explanation)}</textarea></label></article>`).join('');translate()}
function appendQuestion(q){captureEditor();if(editor.questions.length>=50)throw Error('Question limit: 50');editor.questions.push(structuredClone(q));drawEditor();persistEditor()}
function showBank(){captureEditor();const groups=[...new Set(window.ERRORMAP_CONTENT.units.map(u=>u.skill))];$('#modalBody').innerHTML=`<h2>${tr('Question bank')}</h2><div class="filters"><input id="bankQuery" data-placeholder="Search" placeholder="${E(T('Search'))}"><select id="bankSkill"><option value="" data-i="All skills">${E(T('All skills'))}</option>${groups.map(g=>{const name={agr:'Verb agreement',tense:'Verb tenses',vocab:'Words & phrases',prep:'Prepositions',order:'Word order',spell:'Spelling'}[g];return `<option value="${g}" data-i="${name}">${E(T(name))}</option>`}).join('')}</select><select id="bankLevel"><option value="" data-i="All levels">${E(T('All levels'))}</option><option>1</option><option>2</option><option>3</option></select></div><div class="bank-list" id="portalBank"></div>`;const render=()=>{const query=$('#bankQuery').value.toLowerCase();const rows=window.ERRORMAP_CONTENT.questions.filter(q=>q.use==='practice'&&(!$('#bankSkill').value||q.skill===$('#bankSkill').value)&&(!$('#bankLevel').value||String(q.level)===$('#bankLevel').value)&&(!query||[q.prompt,...q.options].join(' ').toLowerCase().includes(query)));$('#portalBank').innerHTML=rows.map(q=>`<div class="bank-row"><div><small>${E(T(window.ERRORMAP_CONTENT.units.find(u=>u.id===q.unit)?.title||q.unit))} · ${q.level}</small><p>${E(q.prompt)}</p><small>${E(q.options.join(' / '))}</small></div>${button('Add','bank-add',`data-id="${E(q.id)}" class="secondary"`)}</div>`).join('');translate()};['bankQuery','bankSkill','bankLevel'].forEach(id=>$('#'+id).oninput=render);render();$('#modal').showModal()}
function preview(){captureEditor();$('#modalBody').innerHTML=`<h2>${E(editor.title||T('Preview'))}</h2>${editor.questions.map((q,i)=>`<section class="review-item"><h3>${i+1}. ${E(q.prompt)}</h3><ol type="A">${q.options.map(o=>`<li>${E(o)}</li>`).join('')}</ol></section>`).join('')}`;$('#modal').showModal()}
function resultTable(rows){if(!rows.length)return `<p class="muted">${tr('No submissions yet')}</p>`;return `<div class="table-wrap"><table><thead><tr>${['Student name','Class','Assignments','Score','Submitted','Reviewed','Details'].map(k=>`<th>${tr(k)}</th>`).join('')}</tr></thead><tbody>${rows.map(r=>`<tr><td>${E(r.student_name)}</td><td>${E(r.class_name)}</td><td>${E(data.tasks.find(t=>t.id===r.task_id)?.title)}</td><td>${r.score} / ${r.total}</td><td>${E(formatDate(r.submitted_at))}</td><td>${r.reviewed?'✓':'—'}</td><td>${link('Details','class-results.html?result='+r.id,'button secondary')}</td></tr>`).join('')}</tbody></table></div>`}
function filteredResults(){const cid=$('#resultClass')?.value||qs().get('class')||'';const tid=$('#resultTask')?.value||qs().get('task')||'';const query=($('#resultSearch')?.value||'').toLowerCase();const review=$('#resultReview')?.value||'';return data.results.filter(r=>{const t=data.tasks.find(t=>t.id===r.task_id);return(!cid||t?.class_id===cid)&&(!tid||r.task_id===tid)&&(!query||r.student_name.toLowerCase().includes(query))&&(!review||String(r.reviewed)===review)})}
function evidence(rows){const seen=new Set(),units={};for(const r of [...rows].sort((a,b)=>Date.parse(b.submitted_at)-Date.parse(a.submitted_at))){const perRule={};for(const d of r.result.details){perRule[d.unit]??={total:0,correct:0};perRule[d.unit].total++;perRule[d.unit].correct+=Number(d.correct)}for(const [unit,v] of Object.entries(perRule)){const key=r.class_name+'|'+r.student_name.trim().toLowerCase()+'|'+unit;if(seen.has(key))continue;seen.add(key);units[unit]??={total:0,correct:0};units[unit].total+=v.total;units[unit].correct+=v.correct}}return units}
function renderResults(){const result=data.results.find(r=>r.id===qs().get('result'));if(result){mount(top('Details',button('Print report','print','class="secondary"'))+resultHTML(result.result)+`<section class="card"><h2>${tr('Teacher feedback')}</h2><form id="feedbackForm"><label>${tr('Teacher feedback')}<textarea name="feedback" maxlength="5000">${E(result.teacher_feedback)}</textarea></label><label class="inline"><input name="reviewed" type="checkbox" ${result.reviewed?'checked':''}>${tr('Reviewed')}</label><button type="submit">${tr('Save')}</button></form></section>`);$('#feedbackForm').onsubmit=e=>{e.preventDefault();withForm(e.currentTarget,async()=>{const f=e.currentTarget;await C.api('em_results?id=eq.'+result.id,{method:'PATCH',body:JSON.stringify({teacher_feedback:f.elements.feedback.value,reviewed:f.elements.reviewed.checked})});message(T('Saved'))})};return}
 mount(top('Results',button('Download CSV','export-results','class="secondary"'))+`<div class="filters"><input id="resultSearch" data-placeholder="Student name" placeholder="${E(T('Student name'))}"><select id="resultClass"><option value="" data-i="All classes">${E(T('All classes'))}</option>${data.classes.map(c=>`<option value="${c.id}" ${qs().get('class')===c.id?'selected':''}>${E(c.name)}</option>`).join('')}</select><select id="resultTask"><option value="" data-i="All assignments">${E(T('All assignments'))}</option>${data.tasks.map(t=>`<option value="${t.id}" ${qs().get('task')===t.id?'selected':''}>${E(t.title)}</option>`).join('')}</select><select id="resultReview"><option value="">${E(T('Reviewed'))}: —</option><option value="false">${E(T('Awaiting review'))}</option><option value="true">${E(T('Reviewed'))}</option></select></div><section class="card" id="resultsTable"></section><section class="card"><h2>${tr('Latest answer evidence by rule')}</h2><p class="muted">${tr('Duplicate names may represent different learners.')}</p><div id="evidence"></div></section>`);
 const render=()=>{const rows=filteredResults();$('#resultsTable').innerHTML=resultTable(rows);const ev=evidence(rows);$('#evidence').innerHTML=Object.entries(ev).map(([id,v])=>`<div class="bank-row"><span>${E(L.t(window.ERRORMAP_CONTENT.units.find(u=>u.id===id)?.title||id))}</span><strong>${v.correct} / ${v.total}</strong></div>`).join('')||tr('No data yet');translate()};['resultSearch','resultClass','resultTask','resultReview'].forEach(id=>$('#'+id).oninput=render);render();
}
function resultHTML(r){return `<article class="card"><h2>${E(r.title||T('Results'))}</h2><p>${E(r.student_name)} · ${E(r.class_name)}</p><div class="score">${r.score} / ${r.total}</div>${r.details.map((d,i)=>`<section class="review-item"><h3><span class="${d.correct?'correct':'incorrect'}">${d.correct?'✓':'✕'}</span> ${i+1}. ${E(d.prompt)}</h3><p>${tr('Your answer')}: ${E(d.chosen)}</p><p>${tr('Correct answer')}: ${E(d.expected)}</p><p class="muted" data-i="${E(d.explanation)}">${E(L.t(d.explanation))}</p>${window.ERRORMAP_CONTENT.units.some(u=>u.id===d.unit)?link('Read the rule','learning-path.html?unit='+encodeURIComponent(d.unit),'no-print'):''}</section>`).join('')}${r.writing?`<section class="review-item"><h3>${tr('Writing')}</h3><p class="result-writing">${E(r.writing)}</p><small>${tr('No automatic language grade')}</small></section>`:''}</article>`}
function renderSettings(){mount(top('Settings')+`<section class="card"><form id="settingsForm"><label>${tr('Display name')}<input name="display_name" maxlength="100" value="${E(data.profile.display_name)}"></label><label>${tr('Report email')} · ${tr('Optional')}<input name="report_email" type="email" maxlength="254" value="${E(data.profile.report_email)}"></label><button type="submit">${tr('Save')}</button></form></section><section class="card"><h2>${tr('Mail delivery')}</h2><p>${tr('Email reports are queued after submission when a recipient is set. Delivery needs the optional mail worker.')}</p><p>${tr('Queued email reports')}: <strong>${data.mail.filter(m=>m.status==='pending').length}</strong></p><p>${tr('Submitted')}: ${data.mail.filter(m=>m.status==='sent').length}</p>${link('Setup guide','SETUP.html')}</section><section class="card"><h2>${tr('Download backup')}</h2>${button('Download backup','backup','class="secondary"')}</section>`);$('#settingsForm').onsubmit=e=>{e.preventDefault();withForm(e.currentTarget,async()=>{const v=formObject(e.currentTarget);await C.api('em_teachers?user_id=eq.'+C.session().uid,{method:'PATCH',body:JSON.stringify({display_name:v.display_name.trim(),report_email:v.report_email.trim()})});message(T('Saved'))})}}
function renderTeacherPage(){({'teacher-dashboard':renderDashboard,classes:renderClasses,assignments:renderAssignments,'task-editor':renderEditor,'class-results':renderResults,'teacher-settings':renderSettings}[PAGE]||renderDashboard)()}
function renderStudent(){const saved=read('errormap-class-identity',{});const classCode=qs().get('class')||'';
 mount(top('Student workspace')+`<div class="grid"><section class="card"><h2>${tr('Open class')}</h2><form id="studentClassForm"><label>${tr('Student name')}<input name="student_name" autocomplete="name" required maxlength="100" value="${E(saved.name||'')}"></label><label>${tr('Class code')}<input name="code" required maxlength="64" value="${E(classCode)}" autocomplete="off"></label><button type="submit">${tr('Open class')} ↗</button></form><p class="muted">${tr('The name is self-reported. This is a classroom workflow, not a protected exam.')}</p></section><section class="card"><h2>${tr('Independent practice')}</h2><p class="muted">${tr('Independent practice is stored on this browser; class submissions are stored in the teacher workspace.')}</p><div class="links">${link('Independent practice','workspace.html')}${link('Open assignment','student-task.html')}${link('Results','student-results.html')}</div></section></div><section id="classTasks"></section>`);
 $('#studentClassForm').onsubmit=e=>{e.preventDefault();withForm(e.currentTarget,async()=>{const v=formObject(e.currentTarget);const c=await C.rpc('em_get_class',{p_code:v.code.trim().toLowerCase()});store('errormap-class-identity',{name:v.student_name.trim()});$('#classTasks').innerHTML=`<section class="card"><h2>${E(c.name)}</h2>${c.tasks.length?`<div class="links">${c.tasks.map(t=>`<a href="student-task.html?code=${E(t.code)}"><strong>${E(t.title)}</strong><br><small>${tr('Due date')}: ${E(formatDate(t.due_at))}</small></a>`).join('')}</div>`:tr('No assignments yet')}</section>`;translate();$('#classTasks').scrollIntoView({behavior:'smooth'})})};
}
function attemptKey(code){return 'errormap-cloud-attempt:'+code}
function saveAttempt(){if(!currentTask||!attempt)return;store(attemptKey(currentTask.code),attempt);const keys=read('errormap-cloud-attempts',[]);if(!keys.includes(currentTask.code)){keys.push(currentTask.code);store('errormap-cloud-attempts',keys)}}
function shuffle(values){const a=[...values];for(let i=a.length-1;i>0;i--){const j=Math.floor(Math.random()*(i+1));[a[i],a[j]]=[a[j],a[i]]}return a}
function renderTaskEntry(){const name=read('errormap-class-identity',{}).name||'';mount(top('Open assignment')+`<section class="card" style="max-width:600px"><form id="taskEntry"><label>${tr('Student name')}<input name="name" required maxlength="100" value="${E(name)}" autocomplete="name"></label><label>${tr('Assignment code')}<input name="code" required maxlength="64" value="${E(qs().get('code')||'')}" autocomplete="off"></label><button type="submit">${tr('Start')} ↗</button></form></section>`);$('#taskEntry').onsubmit=e=>{e.preventDefault();withForm(e.currentTarget,async()=>{const v=formObject(e.currentTarget);const code=v.code.trim().toLowerCase();const old=read(attemptKey(code));if(old?.result&&old.name===v.name.trim()){location.href='student-results.html?code='+encodeURIComponent(code);return}currentTask=await C.rpc('em_get_task',{p_code:code});attempt=old&&old.name===v.name.trim()&&Array.isArray(old.answers)&&old.answers.length===currentTask.questions.length?old:{id:window.EMRandomId(),name:v.name.trim(),answers:currentTask.questions.map(()=>null),orders:currentTask.questions.map(()=>shuffle([0,1,2])),index:0,writing:'',review:false,task:currentTask};store('errormap-class-identity',{name:attempt.name});saveAttempt();renderQuestion()})}}
function renderQuestion(){if(attempt.review){renderReview();return}const i=attempt.index,q=currentTask.questions[i],total=currentTask.questions.length;mount(top('Assignments')+`<section class="card"><div class="actions"><h2>${E(currentTask.title)}</h2><span class="badge">${i+1} / ${total}</span></div><p class="muted">${E(attempt.name)} · ${E(currentTask.class_name)}</p>${currentTask.instructions?`<p>${E(currentTask.instructions)}</p>`:''}<div class="progress"><span style="width:${100*(i+1)/total}%"></span></div><h2 class="test-question">${E(q.prompt)}</h2><form id="answerForm">${attempt.orders[i].map((n,pos)=>`<label class="answer"><input type="radio" name="answer" value="${n}" ${attempt.answers[i]===n?'checked':''} required><span>${String.fromCharCode(65+pos)}. ${E(q.options[n])}</span></label>`).join('')}<div class="actions" style="margin-top:24px">${button('Back','previous-question',`class="secondary" ${i===0?'disabled':''}`)}<button type="submit">${tr(i===total-1?'Review answers':'Next')} →</button></div></form><p class="muted">${tr('Saved on this device')}</p></section>`);document.querySelectorAll('[name=answer]').forEach(n=>n.onchange=()=>{attempt.answers[i]=Number(n.value);saveAttempt()});$('#answerForm').onsubmit=e=>{e.preventDefault();if(attempt.answers[i]===null)return;if(i===total-1)attempt.review=true;else attempt.index++;saveAttempt();renderQuestion()}}
function renderReview(){mount(top('Review answers')+`<section class="card"><h2>${E(currentTask.title)}</h2><div class="answer-index">${attempt.answers.map((a,i)=>`<button type="button" class="${a!==null?'answered':''}" data-action="jump-question" data-index="${i}">${i+1} · ${a===null?'—':String.fromCharCode(65+attempt.orders[i].indexOf(a))}</button>`).join('')}</div><form id="submitTask"><label>${tr('Writing')} · ${tr('Optional')}<textarea name="writing" maxlength="5000" placeholder="${E(T('Explain one rule and write your own example.'))}">${E(attempt.writing)}</textarea></label><p class="muted">${tr('Writing is reviewed by your teacher; it does not change the test score.')}</p><button type="submit">${tr('Submit assignment')} ↗</button></form></section>`);$('#submitTask').elements.writing.oninput=e=>{attempt.writing=e.target.value;saveAttempt()};$('#submitTask').onsubmit=e=>{e.preventDefault();withForm(e.currentTarget,async()=>{if(attempt.answers.some(a=>a===null))throw Error('Answer every question');const result=await C.rpc('em_submit_task',{p_code:currentTask.code,p_attempt_id:attempt.id,p_student_name:attempt.name,p_answers:attempt.answers,p_writing:attempt.writing});attempt.result=result;attempt.submitted_at=new Date().toISOString();saveAttempt();location.href='student-results.html?code='+encodeURIComponent(currentTask.code)})}}
function renderStudentResults(){const code=qs().get('code');const a=code?read(attemptKey(code)):null;if(a?.result){mount(top('Results',button('Print report','print','class="secondary"'))+resultHTML(a.result)+`<section class="card"><h2>${tr('Teacher feedback')}</h2><p id="studentFeedback">${E(a.feedback||T('Awaiting review'))}</p><p class="muted">${tr('Independent practice is stored on this browser; class submissions are stored in the teacher workspace.')}</p></section>`);C.rpc('em_get_result',{p_code:code,p_attempt_id:a.id}).then(r=>{a.feedback=r.teacher_feedback;store(attemptKey(code),a);$('#studentFeedback').textContent=r.teacher_feedback||T(r.reviewed?'Reviewed':'Awaiting review')}).catch(()=>{});return}
 const rows=read('errormap-cloud-attempts',[]).map(code=>({code,...read(attemptKey(code),{})}));mount(top('Results')+`<div class="links">${rows.map(a=>`<a href="${a.result?'student-results.html':'student-task.html'}?code=${E(a.code)}"><strong>${E(a.task?.title||'ErrorMap')}</strong><p>${E(a.name)} · ${a.result?a.result.score+' / '+a.result.total:T('Continue')}</p></a>`).join('')}</div>${rows.length?'':empty('No submissions yet',link('Open assignment','student-task.html'))}`)}
async function action(name,b){
 if(name==='print'){window.print();return}if(name==='close-modal'){$('#modal').close();return}
 if(name==='previous-question'){attempt.index--;saveAttempt();renderQuestion();return}
 if(name==='jump-question'){attempt.index=Number(b.dataset.index);attempt.review=false;saveAttempt();renderQuestion();return}
 if(name==='copy-class'){await copy(classLink(data.classes.find(c=>c.id===b.dataset.id)));return}
 if(name==='copy-task'){await copy(taskLink(data.tasks.find(t=>t.id===b.dataset.id)));return}
 if(name==='archive-class'){const c=data.classes.find(c=>c.id===b.dataset.id);await C.api('em_classes?id=eq.'+c.id,{method:'PATCH',body:JSON.stringify({archived:!c.archived})});await loadTeacher();renderClasses();return}
 if(name==='toggle-task'){const t=data.tasks.find(t=>t.id===b.dataset.id);await C.api('em_tasks?id=eq.'+t.id,{method:'PATCH',body:JSON.stringify({is_open:!t.is_open,...(!t.published_at?{published_at:new Date().toISOString()}:{} )})});await loadTeacher();renderAssignments();return}
 if(name==='duplicate'){const t=data.tasks.find(t=>t.id===b.dataset.id);await C.api('em_tasks',{method:'POST',body:JSON.stringify({teacher_id:C.session().uid,class_id:t.class_id,title:(t.title+' · copy').slice(0,120),instructions:t.instructions,questions:t.questions})});await loadTeacher();renderAssignments();return}
 if(name==='backup'){download('ErrorMap-teacher-backup.json',JSON.stringify({exported_at:new Date().toISOString(),classes:data.classes,tasks:data.tasks,results:data.results},null,2));return}
 if(name==='export-results'){exportResults(filteredResults());return}
 if(name==='add-question'){appendQuestion({prompt:'',options:['','',''],answer:0,explanation:'',unit:'custom'});return}
 if(name==='bank'){showBank();return}
 if(name==='bank-add'){const q=window.ERRORMAP_CONTENT.questions.find(q=>q.id===b.dataset.id);appendQuestion({source_id:q.id,prompt:q.prompt,options:q.options,answer:q.answer,explanation:q.explanation,unit:q.unit});b.textContent='✓';return}
 if(name==='build-test'){captureEditor();if(editor.questions.length+24>50)throw Error('Question limit: 50');for(const u of window.ERRORMAP_CONTENT.units){const bank=window.ERRORMAP_CONTENT.questions.filter(q=>q.unit===u.id&&q.use==='practice');const q=bank[Math.floor(Math.random()*bank.length)];editor.questions.push({source_id:q.id,unit:q.unit,prompt:q.prompt,options:q.options.slice(),answer:q.answer,explanation:q.explanation})}drawEditor();persistEditor();return}
 if(name==='remove-question'||name==='move-up'||name==='move-down'){captureEditor();const i=Number(b.dataset.index);if(name==='remove-question')editor.questions.splice(i,1);else{const j=i+(name==='move-up'?-1:1);[editor.questions[i],editor.questions[j]]=[editor.questions[j],editor.questions[i]]}drawEditor();persistEditor();return}
 if(name==='preview'){preview();return}if(name==='import'){$('#importFile').click();return}
 if(name==='export-questions'){captureEditor();download('ErrorMap-questions.json',JSON.stringify(editor.questions,null,2));return}
 if(name==='discard-draft'){if(!confirm(T('Discard this local draft?')))return;localStorage.removeItem(draftKey(editor.id||'new'));dirty=false;renderEditor();return}
}
document.addEventListener('click',async e=>{const b=e.target.closest('[data-action]');if(!b||b.disabled)return;b.disabled=true;try{await action(b.dataset.action,b)}catch(err){failure(err)}finally{b.disabled=false}});
$('#languageSelect').onchange=e=>{L.set(e.target.value);translate()};
window.addEventListener('beforeunload',e=>{if(dirty){e.preventDefault();e.returnValue=''}});
async function boot(){translate();$('#logout')?.addEventListener('click',async()=>{if(dirty&&!confirm(T('Leave with unsaved changes?')))return;dirty=false;await C.logout();location.href='teacher-login.html'});
 if(PAGE==='teacher-login'){renderLogin();return}if(PAGE==='student'){renderStudent();return}if(PAGE==='student-task'){renderTaskEntry();return}if(PAGE==='student-results'){renderStudentResults();return}
 if(TEACHER_PAGES.includes(PAGE)){if(!C.session()){location.replace('teacher-login.html');return}mount(`<p>${tr('Loading…')}</p>`);try{await loadTeacher();renderTeacherPage()}catch(e){if(e.message==='signInRequired'||e.message==='teacherOnly'||e.status===401){await C.logout();location.replace('teacher-login.html');return}failure(e);mount(empty('Waiting for configuration',link('Setup guide','SETUP.html')))}}
}
window.EMPortalTest={validateQuestions,csvCell,evidence,escapeHTML:E};
boot().catch(failure);
})();

````

## dist/assets/question-bank.js

````javascript
window.ERRORMAP_CONTENT = {"version": 4, "language": "en", "units": [{"id": "third-person", "skill": "agr", "title": "Third-person -s / -es", "rule": "In the present simple, add -s or -es after he, she, it or a singular subject. Change consonant + y to -ies.", "example": "She reads. He watches. My sister studies."}, {"id": "auxiliary-base", "skill": "agr", "title": "Base verbs after auxiliaries", "rule": "After do, does, did, do not, does not or did not, use the base form of the main verb.", "example": "Does she play? He does not play. Did they go?"}, {"id": "be-agreement", "skill": "agr", "title": "Forms of be", "rule": "Match be to the subject and time: I am; he/she/it is; we/you/they are. In the past, use was with I/he/she/it and were with we/you/they.", "example": "I am ready. They are ready. We were tired yesterday."}, {"id": "have-there", "skill": "agr", "title": "Have, has and there is / are", "rule": "Use has with he/she/it or a singular subject; use have with I/you/we/they. Use there is for one thing and there are for more than one.", "example": "She has a notebook. They have notebooks. There are two books."}, {"id": "past-simple", "skill": "tense", "title": "Completed past actions", "rule": "Use the past simple for completed actions at a past time. Regular verbs end in -ed; some verbs have irregular past forms.", "example": "We visited the museum yesterday. She went home."}, {"id": "present-continuous", "skill": "tense", "title": "Actions happening now", "rule": "For an action happening now, use am/is/are + verb-ing. Match the auxiliary to the subject.", "example": "I am reading. She is writing. They are playing."}, {"id": "past-continuous", "skill": "tense", "title": "Actions in progress in the past", "rule": "Use was/were + verb-ing for an action in progress at a past moment. A shorter event can interrupt it.", "example": "I was reading when the phone rang."}, {"id": "present-perfect", "skill": "tense", "title": "Experience and recent results", "rule": "Use have/has + past participle for experiences or past actions linked to now. Words such as ever, never, just, already and yet often help.", "example": "I have seen this film. She has just arrived."}, {"id": "make-do", "skill": "vocab", "title": "Make and do", "rule": "Learn these combinations as whole phrases: do homework, do your best, make a decision, make a mistake, make your bed and make friends.", "example": "Do your homework. Make a decision."}, {"id": "take-get", "skill": "vocab", "title": "Take and get", "rule": "Learn action phrases together: take a photo, take a break, take notes, take part and get enough sleep.", "example": "Take a photo. Get enough sleep."}, {"id": "communication", "skill": "vocab", "title": "Communication phrases", "rule": "Use tell the truth, ask a question, give advice, send an email, pay attention and keep a promise.", "example": "Ask a question. Give advice. Tell the truth."}, {"id": "daily-collocations", "skill": "vocab", "title": "Study and everyday phrases", "rule": "Learn common combinations: solve a problem, follow the rules, save money, protect the environment and win a match.", "example": "Solve a problem. Follow the rules."}, {"id": "time-prepositions", "skill": "prep", "title": "At, on and in for time", "rule": "Use at with clock times, on with days and dates, and in with months and years. Learn at night and in the morning as phrases.", "example": "At nine. On Monday. In September."}, {"id": "place-movement", "skill": "prep", "title": "Place and movement", "rule": "Use in for something inside, on for a surface, to for a destination and across for movement from one side to the other. Learn arrive at a place and arrive in a city or country.", "example": "In a bag. On a wall. Walk across a bridge."}, {"id": "fixed-prepositions", "skill": "prep", "title": "Prepositions in fixed phrases", "rule": "Learn the preposition with its phrase: good at, interested in, afraid of, listen to, wait for, agree with and belong to.", "example": "Good at maths. Interested in science."}, {"id": "for-since", "skill": "prep", "title": "For and since", "rule": "Use for with a length of time and since with the point when something began.", "example": "For three years. Since 2020."}, {"id": "statement-order", "skill": "order", "title": "Statements and noun phrases", "rule": "In a simple statement, put the subject before the verb, then the object. Put an adjective before the noun it describes.", "example": "She reads books. I have a blue bag."}, {"id": "question-order", "skill": "order", "title": "Question word order", "rule": "In questions, put the auxiliary before the subject. With a question word, use question word + auxiliary + subject + main verb.", "example": "Where does she live? Did you see it?"}, {"id": "adverb-order", "skill": "order", "title": "Frequency adverbs", "rule": "Frequency adverbs usually come before a main verb and after be. Keep noun phrases together.", "example": "She often reads. He is always polite."}, {"id": "verb-group-order", "skill": "order", "title": "Auxiliaries and verb groups", "rule": "Keep auxiliaries and main verbs in order. Use subject + modal + base verb, have/has + past participle, or be + going to + base verb.", "example": "She can swim. He has just arrived."}, {"id": "common-spelling", "skill": "spell", "title": "Common word spellings", "rule": "Check the whole word, not only how it sounds. Notice the letter sequence in because, beautiful, science, subject and information.", "example": "because · beautiful · science"}, {"id": "double-letters", "skill": "spell", "title": "Single and double letters", "rule": "Notice which consonants are doubled: address has dd and ss; tomorrow has rr; necessary has one c and two s.", "example": "address · tomorrow · necessary"}, {"id": "letter-patterns", "skill": "spell", "title": "Silent letters and letter order", "rule": "Some letters are written but not heard. Check listen, answer and Wednesday. In friend, i comes before e.", "example": "listen · answer · Wednesday · friend"}, {"id": "capital-letters", "skill": "spell", "title": "Capital letters", "rule": "Use capitals for I, names, languages, countries, months and days. Begin a sentence with a capital letter.", "example": "I study English in Kazakhstan on Monday."}], "questions": [{"id": "third-person-01", "unit": "third-person", "skill": "agr", "prompt": "My sister ___ English every day.", "options": ["study", "studies", "studying"], "answer": 1, "explanation": "My sister is one person. Study changes to studies after a singular third-person subject.", "level": 1, "use": "diagnostic", "form": "A", "pair": 0}, {"id": "third-person-02", "unit": "third-person", "skill": "agr", "prompt": "My brother ___ football every Saturday.", "options": ["playing", "plays", "play"], "answer": 1, "explanation": "My brother is one person. Add -s: plays.", "level": 1, "use": "diagnostic", "form": "B", "pair": 0}, {"id": "third-person-03", "unit": "third-person", "skill": "agr", "prompt": "Our teacher ___ the answer clearly.", "options": ["explaining", "explains", "explain"], "answer": 1, "explanation": "Our teacher is singular, so the present-simple form is explains.", "level": 2, "use": "diagnostic", "form": "A", "pair": 1}, {"id": "third-person-04", "unit": "third-person", "skill": "agr", "prompt": "The school bus ___ at eight.", "options": ["arriving", "arrive", "arrives"], "answer": 2, "explanation": "The bus is singular. Add -s: arrives.", "level": 2, "use": "diagnostic", "form": "B", "pair": 1}, {"id": "third-person-05", "unit": "third-person", "skill": "agr", "prompt": "My cousin ___ TV after dinner.", "options": ["watching", "watch", "watches"], "answer": 2, "explanation": "Watch ends in -ch. Add -es after a singular subject: watches.", "level": 3, "use": "diagnostic", "form": "A", "pair": 2}, {"id": "third-person-06", "unit": "third-person", "skill": "agr", "prompt": "The little bird ___ over the lake every morning.", "options": ["flies", "flying", "fly"], "answer": 0, "explanation": "Fly ends in consonant + y. Change y to -ies: flies.", "level": 3, "use": "diagnostic", "form": "B", "pair": 2}, {"id": "third-person-07", "unit": "third-person", "skill": "agr", "prompt": "My father ___ in a hospital.", "options": ["works", "work", "working"], "answer": 0, "explanation": "My father is singular. The correct form is works.", "level": 1, "use": "practice", "form": null, "pair": null}, {"id": "third-person-08", "unit": "third-person", "skill": "agr", "prompt": "She ___ her teeth twice a day.", "options": ["brushes", "brushing", "brush"], "answer": 0, "explanation": "Brush ends in -sh, so add -es: brushes.", "level": 2, "use": "practice", "form": null, "pair": null}, {"id": "third-person-09", "unit": "third-person", "skill": "agr", "prompt": "A cat ___ mice.", "options": ["catch", "catching", "catches"], "answer": 2, "explanation": "Catch ends in -ch, so add -es after a singular subject.", "level": 2, "use": "practice", "form": null, "pair": null}, {"id": "third-person-10", "unit": "third-person", "skill": "agr", "prompt": "The baby often ___ when he is hungry.", "options": ["cry", "crying", "cries"], "answer": 2, "explanation": "Change consonant + y to -ies: cry becomes cries.", "level": 3, "use": "practice", "form": null, "pair": null}, {"id": "auxiliary-base-01", "unit": "auxiliary-base", "skill": "agr", "prompt": "Does your sister ___ English?", "options": ["speaks", "speak", "speaking"], "answer": 1, "explanation": "Does already marks the question. Use the base form speak.", "level": 1, "use": "diagnostic", "form": "A", "pair": 0}, {"id": "auxiliary-base-02", "unit": "auxiliary-base", "skill": "agr", "prompt": "Does your brother ___ chess?", "options": ["play", "playing", "plays"], "answer": 0, "explanation": "Use the base form play after does.", "level": 1, "use": "diagnostic", "form": "B", "pair": 0}, {"id": "auxiliary-base-03", "unit": "auxiliary-base", "skill": "agr", "prompt": "She does not ___ coffee.", "options": ["drinking", "drink", "drinks"], "answer": 1, "explanation": "After does not, the main verb stays in its base form: drink.", "level": 2, "use": "diagnostic", "form": "A", "pair": 1}, {"id": "auxiliary-base-04", "unit": "auxiliary-base", "skill": "agr", "prompt": "My teacher does not ___ homework on Fridays.", "options": ["giving", "gives", "give"], "answer": 2, "explanation": "Use give, not gives, after does not.", "level": 2, "use": "diagnostic", "form": "B", "pair": 1}, {"id": "auxiliary-base-05", "unit": "auxiliary-base", "skill": "agr", "prompt": "Did you ___ the match yesterday?", "options": ["see", "saw", "seeing"], "answer": 0, "explanation": "Did marks the past tense. The main verb must be see.", "level": 3, "use": "diagnostic", "form": "A", "pair": 2}, {"id": "auxiliary-base-06", "unit": "auxiliary-base", "skill": "agr", "prompt": "Did they ___ to the museum?", "options": ["go", "went", "going"], "answer": 0, "explanation": "Use the base form go after did.", "level": 3, "use": "diagnostic", "form": "B", "pair": 2}, {"id": "auxiliary-base-07", "unit": "auxiliary-base", "skill": "agr", "prompt": "Do your friends ___ reading?", "options": ["enjoys", "enjoy", "enjoying"], "answer": 1, "explanation": "Use the base form enjoy after do.", "level": 1, "use": "practice", "form": null, "pair": null}, {"id": "auxiliary-base-08", "unit": "auxiliary-base", "skill": "agr", "prompt": "He did not ___ the window.", "options": ["opened", "open", "opening"], "answer": 1, "explanation": "Use open after did not.", "level": 2, "use": "practice", "form": null, "pair": null}, {"id": "auxiliary-base-09", "unit": "auxiliary-base", "skill": "agr", "prompt": "Does Aida ___ a bicycle?", "options": ["have", "has", "having"], "answer": 0, "explanation": "Does is followed by have, not has.", "level": 2, "use": "practice", "form": null, "pair": null}, {"id": "auxiliary-base-10", "unit": "auxiliary-base", "skill": "agr", "prompt": "We do not ___ uniforms on Sundays.", "options": ["wear", "wearing", "wears"], "answer": 0, "explanation": "Use the base form wear after do not.", "level": 3, "use": "practice", "form": null, "pair": null}, {"id": "be-agreement-01", "unit": "be-agreement", "skill": "agr", "prompt": "I ___ ready for the lesson.", "options": ["are", "am", "is"], "answer": 1, "explanation": "The present form of be after I is am.", "level": 1, "use": "diagnostic", "form": "A", "pair": 0}, {"id": "be-agreement-02", "unit": "be-agreement", "skill": "agr", "prompt": "She ___ ready for the lesson.", "options": ["am", "is", "are"], "answer": 1, "explanation": "Use is with she in the present.", "level": 1, "use": "diagnostic", "form": "B", "pair": 0}, {"id": "be-agreement-03", "unit": "be-agreement", "skill": "agr", "prompt": "The students ___ in the library now.", "options": ["are", "am", "is"], "answer": 0, "explanation": "The students is plural, so use are.", "level": 2, "use": "diagnostic", "form": "A", "pair": 1}, {"id": "be-agreement-04", "unit": "be-agreement", "skill": "agr", "prompt": "My brother and I ___ in Grade 7.", "options": ["are", "is", "am"], "answer": 0, "explanation": "My brother and I means we. Use are.", "level": 2, "use": "diagnostic", "form": "B", "pair": 1}, {"id": "be-agreement-05", "unit": "be-agreement", "skill": "agr", "prompt": "We ___ at home last Sunday.", "options": ["were", "are", "was"], "answer": 0, "explanation": "Last Sunday is past time. The past form with we is were.", "level": 3, "use": "diagnostic", "form": "A", "pair": 2}, {"id": "be-agreement-06", "unit": "be-agreement", "skill": "agr", "prompt": "He ___ tired after the trip yesterday.", "options": ["is", "were", "was"], "answer": 2, "explanation": "Use was with he for a completed past situation.", "level": 3, "use": "diagnostic", "form": "B", "pair": 2}, {"id": "be-agreement-07", "unit": "be-agreement", "skill": "agr", "prompt": "These shoes ___ comfortable.", "options": ["am", "is", "are"], "answer": 2, "explanation": "These shoes is plural. Use are.", "level": 1, "use": "practice", "form": null, "pair": null}, {"id": "be-agreement-08", "unit": "be-agreement", "skill": "agr", "prompt": "The boys ___ tired yesterday.", "options": ["were", "was", "are"], "answer": 0, "explanation": "Yesterday requires past tense. Use were with the boys.", "level": 2, "use": "practice", "form": null, "pair": null}, {"id": "be-agreement-09", "unit": "be-agreement", "skill": "agr", "prompt": "Everyone ___ here now.", "options": ["am", "is", "are"], "answer": 1, "explanation": "Everyone takes a singular verb: is.", "level": 2, "use": "practice", "form": null, "pair": null}, {"id": "be-agreement-10", "unit": "be-agreement", "skill": "agr", "prompt": "Neither answer ___ correct.", "options": ["am", "are", "is"], "answer": 2, "explanation": "Neither answer refers to each answer separately and takes is.", "level": 3, "use": "practice", "form": null, "pair": null}, {"id": "have-there-01", "unit": "have-there", "skill": "agr", "prompt": "My dog ___ a long tail.", "options": ["have", "has", "having"], "answer": 1, "explanation": "My dog is singular. Use has.", "level": 1, "use": "diagnostic", "form": "A", "pair": 0}, {"id": "have-there-02", "unit": "have-there", "skill": "agr", "prompt": "My sister ___ a new schoolbag.", "options": ["have", "having", "has"], "answer": 2, "explanation": "My sister is singular. Use has.", "level": 1, "use": "diagnostic", "form": "B", "pair": 0}, {"id": "have-there-03", "unit": "have-there", "skill": "agr", "prompt": "The students ___ new notebooks.", "options": ["has", "having", "have"], "answer": 2, "explanation": "The students is plural. Use have.", "level": 2, "use": "diagnostic", "form": "A", "pair": 1}, {"id": "have-there-04", "unit": "have-there", "skill": "agr", "prompt": "My parents ___ a small car.", "options": ["have", "has", "having"], "answer": 0, "explanation": "My parents is plural. Use have.", "level": 2, "use": "diagnostic", "form": "B", "pair": 1}, {"id": "have-there-05", "unit": "have-there", "skill": "agr", "prompt": "There ___ a book on the desk.", "options": ["am", "is", "are"], "answer": 1, "explanation": "A book is one thing. Use there is.", "level": 3, "use": "diagnostic", "form": "A", "pair": 2}, {"id": "have-there-06", "unit": "have-there", "skill": "agr", "prompt": "There ___ two windows in this room.", "options": ["am", "is", "are"], "answer": 2, "explanation": "Two windows is plural. Use there are.", "level": 3, "use": "diagnostic", "form": "B", "pair": 2}, {"id": "have-there-07", "unit": "have-there", "skill": "agr", "prompt": "I ___ a question.", "options": ["have", "having", "has"], "answer": 0, "explanation": "Use have with I.", "level": 1, "use": "practice", "form": null, "pair": null}, {"id": "have-there-08", "unit": "have-there", "skill": "agr", "prompt": "The classroom ___ four large windows.", "options": ["having", "have", "has"], "answer": 2, "explanation": "The classroom is one room. Use has.", "level": 2, "use": "practice", "form": null, "pair": null}, {"id": "have-there-09", "unit": "have-there", "skill": "agr", "prompt": "There ___ some milk in the fridge.", "options": ["is", "are", "am"], "answer": 0, "explanation": "Milk is uncountable. Use there is.", "level": 2, "use": "practice", "form": null, "pair": null}, {"id": "have-there-10", "unit": "have-there", "skill": "agr", "prompt": "There ___ many people at the station.", "options": ["are", "am", "is"], "answer": 0, "explanation": "People is plural. Use there are.", "level": 3, "use": "practice", "form": null, "pair": null}, {"id": "past-simple-01", "unit": "past-simple", "skill": "tense", "prompt": "We ___ the museum yesterday.", "options": ["are visiting", "visited", "visit"], "answer": 1, "explanation": "Yesterday is a finished past time. Use visited.", "level": 1, "use": "diagnostic", "form": "A", "pair": 0}, {"id": "past-simple-02", "unit": "past-simple", "skill": "tense", "prompt": "They ___ a film last night.", "options": ["are watching", "watch", "watched"], "answer": 2, "explanation": "Last night is finished. Use the past form watched.", "level": 1, "use": "diagnostic", "form": "B", "pair": 0}, {"id": "past-simple-03", "unit": "past-simple", "skill": "tense", "prompt": "She ___ a letter last week.", "options": ["wrote", "is writing", "writes"], "answer": 0, "explanation": "Last week is past time. The past of write is wrote.", "level": 2, "use": "diagnostic", "form": "A", "pair": 1}, {"id": "past-simple-04", "unit": "past-simple", "skill": "tense", "prompt": "My family ___ to Almaty last summer.", "options": ["are going", "goes", "went"], "answer": 2, "explanation": "Last summer is past time. The past of go is went.", "level": 2, "use": "diagnostic", "form": "B", "pair": 1}, {"id": "past-simple-05", "unit": "past-simple", "skill": "tense", "prompt": "I ___ my keys two hours ago.", "options": ["am finding", "find", "found"], "answer": 2, "explanation": "Ago refers to a completed past time. Find becomes found.", "level": 3, "use": "diagnostic", "form": "A", "pair": 2}, {"id": "past-simple-06", "unit": "past-simple", "skill": "tense", "prompt": "He ___ his leg last winter.", "options": ["is breaking", "broke", "breaks"], "answer": 1, "explanation": "Last winter is past time. Break becomes broke.", "level": 3, "use": "diagnostic", "form": "B", "pair": 2}, {"id": "past-simple-07", "unit": "past-simple", "skill": "tense", "prompt": "Yesterday, we ___ a new topic.", "options": ["started", "start", "are starting"], "answer": 0, "explanation": "Use the past form started with yesterday.", "level": 1, "use": "practice", "form": null, "pair": null}, {"id": "past-simple-08", "unit": "past-simple", "skill": "tense", "prompt": "She ___ a book on Monday last week.", "options": ["buys", "is buying", "bought"], "answer": 2, "explanation": "The completed past time needs bought, the past of buy.", "level": 2, "use": "practice", "form": null, "pair": null}, {"id": "past-simple-09", "unit": "past-simple", "skill": "tense", "prompt": "We ___ lunch at school yesterday.", "options": ["are having", "have", "had"], "answer": 2, "explanation": "The past form of have is had.", "level": 2, "use": "practice", "form": null, "pair": null}, {"id": "past-simple-10", "unit": "past-simple", "skill": "tense", "prompt": "They ___ to Astana in 2022.", "options": ["move", "moved", "are moving"], "answer": 1, "explanation": "A finished year calls for the past simple: moved.", "level": 3, "use": "practice", "form": null, "pair": null}, {"id": "present-continuous-01", "unit": "present-continuous", "skill": "tense", "prompt": "Look! The children ___ in the park.", "options": ["are playing", "plays", "played"], "answer": 0, "explanation": "Look points to an action happening now. Use are playing.", "level": 1, "use": "diagnostic", "form": "A", "pair": 0}, {"id": "present-continuous-02", "unit": "present-continuous", "skill": "tense", "prompt": "Be quiet! The baby ___ now.", "options": ["is sleeping", "sleep", "slept"], "answer": 0, "explanation": "Now needs is sleeping for this ongoing action.", "level": 1, "use": "diagnostic", "form": "B", "pair": 0}, {"id": "present-continuous-03", "unit": "present-continuous", "skill": "tense", "prompt": "At the moment, we ___ a test.", "options": ["writes", "are writing", "wrote"], "answer": 1, "explanation": "At the moment describes an ongoing action: are writing.", "level": 2, "use": "diagnostic", "form": "A", "pair": 1}, {"id": "present-continuous-04", "unit": "present-continuous", "skill": "tense", "prompt": "Listen! Someone ___ the piano.", "options": ["is playing", "played", "plays"], "answer": 0, "explanation": "Listen points to what is happening now: is playing.", "level": 2, "use": "diagnostic", "form": "B", "pair": 1}, {"id": "present-continuous-05", "unit": "present-continuous", "skill": "tense", "prompt": "Hurry up! The bus ___ right now.", "options": ["left", "leave", "is leaving"], "answer": 2, "explanation": "Right now refers to an action in progress: is leaving.", "level": 3, "use": "diagnostic", "form": "A", "pair": 2}, {"id": "present-continuous-06", "unit": "present-continuous", "skill": "tense", "prompt": "Look at Aida! She ___ a picture.", "options": ["drew", "is drawing", "draw"], "answer": 1, "explanation": "The action is happening in front of us: is drawing.", "level": 3, "use": "diagnostic", "form": "B", "pair": 2}, {"id": "present-continuous-07", "unit": "present-continuous", "skill": "tense", "prompt": "I ___ my homework right now.", "options": ["am doing", "doing", "did"], "answer": 0, "explanation": "Use am with I, followed by doing.", "level": 1, "use": "practice", "form": null, "pair": null}, {"id": "present-continuous-08", "unit": "present-continuous", "skill": "tense", "prompt": "The children ___ a snowman at the moment.", "options": ["making", "made", "are making"], "answer": 2, "explanation": "The children is plural. Use are making.", "level": 2, "use": "practice", "form": null, "pair": null}, {"id": "present-continuous-09", "unit": "present-continuous", "skill": "tense", "prompt": "Please wait. I ___ to the teacher now.", "options": ["am talking", "talking", "talked"], "answer": 0, "explanation": "Now identifies the ongoing action: am talking.", "level": 2, "use": "practice", "form": null, "pair": null}, {"id": "present-continuous-10", "unit": "present-continuous", "skill": "tense", "prompt": "Where is Mum? She ___ dinner in the kitchen now.", "options": ["cooked", "cooking", "is cooking"], "answer": 2, "explanation": "For the action she is doing now, use is cooking.", "level": 3, "use": "practice", "form": null, "pair": null}, {"id": "past-continuous-01", "unit": "past-continuous", "skill": "tense", "prompt": "At five yesterday, they ___ football.", "options": ["were playing", "play", "are playing"], "answer": 0, "explanation": "At a specific past moment, use were playing.", "level": 1, "use": "diagnostic", "form": "A", "pair": 0}, {"id": "past-continuous-02", "unit": "past-continuous", "skill": "tense", "prompt": "At eight last night, she ___ dinner.", "options": ["cooks", "is cooking", "was cooking"], "answer": 2, "explanation": "At a past moment, use was cooking with she.", "level": 1, "use": "diagnostic", "form": "B", "pair": 0}, {"id": "past-continuous-03", "unit": "past-continuous", "skill": "tense", "prompt": "When the phone rang, I ___ a shower.", "options": ["am taking", "take", "was taking"], "answer": 2, "explanation": "The shower was in progress when the phone rang.", "level": 2, "use": "diagnostic", "form": "A", "pair": 1}, {"id": "past-continuous-04", "unit": "past-continuous", "skill": "tense", "prompt": "He ___ his homework when the lights went out.", "options": ["was doing", "does", "is doing"], "answer": 0, "explanation": "The homework was in progress when the lights went out.", "level": 2, "use": "diagnostic", "form": "B", "pair": 1}, {"id": "past-continuous-05", "unit": "past-continuous", "skill": "tense", "prompt": "While I was reading, my brother ___ TV.", "options": ["watches", "is watching", "was watching"], "answer": 2, "explanation": "Two ongoing past actions can use the past continuous.", "level": 3, "use": "diagnostic", "form": "A", "pair": 2}, {"id": "past-continuous-06", "unit": "past-continuous", "skill": "tense", "prompt": "While Mum was cooking, we ___ the table.", "options": ["are setting", "were setting", "set every day"], "answer": 1, "explanation": "The actions were happening together in the past. Use were setting.", "level": 3, "use": "diagnostic", "form": "B", "pair": 2}, {"id": "past-continuous-07", "unit": "past-continuous", "skill": "tense", "prompt": "At ten yesterday morning, I ___ in the library.", "options": ["was studying", "study", "am studying"], "answer": 0, "explanation": "Use was studying for an action in progress at that past time.", "level": 1, "use": "practice", "form": null, "pair": null}, {"id": "past-continuous-08", "unit": "past-continuous", "skill": "tense", "prompt": "They ___ home when it started to rain.", "options": ["walk every day", "were walking", "are walking"], "answer": 1, "explanation": "The walk was in progress when the rain started.", "level": 2, "use": "practice", "form": null, "pair": null}, {"id": "past-continuous-09", "unit": "past-continuous", "skill": "tense", "prompt": "She ___ music when the doorbell rang.", "options": ["listens to", "was listening to", "is listening to"], "answer": 1, "explanation": "The listening was in progress at the time of the doorbell.", "level": 2, "use": "practice", "form": null, "pair": null}, {"id": "past-continuous-10", "unit": "past-continuous", "skill": "tense", "prompt": "We ___ on the bus at this time yesterday.", "options": ["were sitting", "are sitting", "sit"], "answer": 0, "explanation": "At this time yesterday calls for the past continuous.", "level": 3, "use": "practice", "form": null, "pair": null}, {"id": "present-perfect-01", "unit": "present-perfect", "skill": "tense", "prompt": "She has never ___ to London.", "options": ["been", "go", "was"], "answer": 0, "explanation": "Has needs the past participle been.", "level": 1, "use": "diagnostic", "form": "A", "pair": 0}, {"id": "present-perfect-02", "unit": "present-perfect", "skill": "tense", "prompt": "I have already ___ this film.", "options": ["see", "seen", "saw"], "answer": 1, "explanation": "Have needs the past participle seen.", "level": 1, "use": "diagnostic", "form": "B", "pair": 0}, {"id": "present-perfect-03", "unit": "present-perfect", "skill": "tense", "prompt": "We have just ___ the project.", "options": ["finishing", "finish", "finished"], "answer": 2, "explanation": "Use have + past participle: finished.", "level": 2, "use": "diagnostic", "form": "A", "pair": 1}, {"id": "present-perfect-04", "unit": "present-perfect", "skill": "tense", "prompt": "They have not ___ their homework yet.", "options": ["do", "done", "did"], "answer": 1, "explanation": "Have not needs the past participle done.", "level": 2, "use": "diagnostic", "form": "B", "pair": 1}, {"id": "present-perfect-05", "unit": "present-perfect", "skill": "tense", "prompt": "He has just ___ home.", "options": ["come", "came", "coming"], "answer": 0, "explanation": "The past participle of come is also come.", "level": 3, "use": "diagnostic", "form": "A", "pair": 2}, {"id": "present-perfect-06", "unit": "present-perfect", "skill": "tense", "prompt": "She has already ___ the email.", "options": ["send", "sent", "sending"], "answer": 1, "explanation": "Has needs the past participle sent.", "level": 3, "use": "diagnostic", "form": "B", "pair": 2}, {"id": "present-perfect-07", "unit": "present-perfect", "skill": "tense", "prompt": "Have you ever ___ a horse?", "options": ["ride", "ridden", "rode"], "answer": 1, "explanation": "The past participle of ride is ridden.", "level": 1, "use": "practice", "form": null, "pair": null}, {"id": "present-perfect-08", "unit": "present-perfect", "skill": "tense", "prompt": "We have never ___ this game before.", "options": ["played", "playing", "play"], "answer": 0, "explanation": "Have never is followed by the past participle played.", "level": 2, "use": "practice", "form": null, "pair": null}, {"id": "present-perfect-09", "unit": "present-perfect", "skill": "tense", "prompt": "I have just ___ my keys.", "options": ["found", "finding", "find"], "answer": 0, "explanation": "The past participle of find is found.", "level": 2, "use": "practice", "form": null, "pair": null}, {"id": "present-perfect-10", "unit": "present-perfect", "skill": "tense", "prompt": "My brother has ___ his phone.", "options": ["lose", "lost", "losing"], "answer": 1, "explanation": "Has needs the past participle lost.", "level": 3, "use": "practice", "form": null, "pair": null}, {"id": "make-do-01", "unit": "make-do", "skill": "vocab", "prompt": "I need to ___ my homework.", "options": ["do", "make", "take"], "answer": 0, "explanation": "The fixed combination is do homework.", "level": 1, "use": "diagnostic", "form": "A", "pair": 0}, {"id": "make-do-02", "unit": "make-do", "skill": "vocab", "prompt": "Please ___ your homework before dinner.", "options": ["make", "give", "do"], "answer": 2, "explanation": "Use do with homework.", "level": 1, "use": "diagnostic", "form": "B", "pair": 0}, {"id": "make-do-03", "unit": "make-do", "skill": "vocab", "prompt": "We must ___ a decision today.", "options": ["make", "get", "do"], "answer": 0, "explanation": "The standard combination here is make a decision.", "level": 2, "use": "diagnostic", "form": "A", "pair": 1}, {"id": "make-do-04", "unit": "make-do", "skill": "vocab", "prompt": "Try not to ___ a mistake.", "options": ["make", "do", "give"], "answer": 0, "explanation": "Use make with a mistake.", "level": 2, "use": "diagnostic", "form": "B", "pair": 1}, {"id": "make-do-05", "unit": "make-do", "skill": "vocab", "prompt": "I want to ___ friends at my new school.", "options": ["do", "make", "take"], "answer": 1, "explanation": "Make friends means form friendships.", "level": 3, "use": "diagnostic", "form": "A", "pair": 2}, {"id": "make-do-06", "unit": "make-do", "skill": "vocab", "prompt": "Please ___ your bed before school.", "options": ["make", "do", "take"], "answer": 0, "explanation": "Make your bed means arrange the bedding neatly.", "level": 3, "use": "diagnostic", "form": "B", "pair": 2}, {"id": "make-do-07", "unit": "make-do", "skill": "vocab", "prompt": "Always ___ your best.", "options": ["do", "make", "take"], "answer": 0, "explanation": "The fixed phrase is do your best.", "level": 1, "use": "practice", "form": null, "pair": null}, {"id": "make-do-08", "unit": "make-do", "skill": "vocab", "prompt": "We need to ___ a plan.", "options": ["do", "give", "make"], "answer": 2, "explanation": "Use make a plan.", "level": 2, "use": "practice", "form": null, "pair": null}, {"id": "make-do-09", "unit": "make-do", "skill": "vocab", "prompt": "It is your turn to ___ the washing-up.", "options": ["take", "do", "make"], "answer": 1, "explanation": "The fixed phrase is do the washing-up.", "level": 2, "use": "practice", "form": null, "pair": null}, {"id": "make-do-10", "unit": "make-do", "skill": "vocab", "prompt": "Please do not ___ so much noise.", "options": ["make", "take", "do"], "answer": 0, "explanation": "The fixed combination is make noise.", "level": 3, "use": "practice", "form": null, "pair": null}, {"id": "take-get-01", "unit": "take-get", "skill": "vocab", "prompt": "Can you ___ a photo of us?", "options": ["do", "give", "take"], "answer": 2, "explanation": "The fixed phrase is take a photo.", "level": 1, "use": "diagnostic", "form": "A", "pair": 0}, {"id": "take-get-02", "unit": "take-get", "skill": "vocab", "prompt": "Please ___ a photo of the team.", "options": ["do", "take", "give"], "answer": 1, "explanation": "Use take with a photo.", "level": 1, "use": "diagnostic", "form": "B", "pair": 0}, {"id": "take-get-03", "unit": "take-get", "skill": "vocab", "prompt": "Let us ___ a break now.", "options": ["make", "do", "take"], "answer": 2, "explanation": "The fixed phrase is take a break.", "level": 2, "use": "diagnostic", "form": "A", "pair": 1}, {"id": "take-get-04", "unit": "take-get", "skill": "vocab", "prompt": "You should ___ notes during the lesson.", "options": ["say", "do", "take"], "answer": 2, "explanation": "Take notes means write down the main points.", "level": 2, "use": "diagnostic", "form": "B", "pair": 1}, {"id": "take-get-05", "unit": "take-get", "skill": "vocab", "prompt": "Our class will ___ part in the festival.", "options": ["take", "do", "make"], "answer": 0, "explanation": "The fixed phrase is take part in.", "level": 3, "use": "diagnostic", "form": "A", "pair": 2}, {"id": "take-get-06", "unit": "take-get", "skill": "vocab", "prompt": "You should ___ enough sleep before a test.", "options": ["do", "make", "get"], "answer": 2, "explanation": "Use get enough sleep.", "level": 3, "use": "diagnostic", "form": "B", "pair": 2}, {"id": "take-get-07", "unit": "take-get", "skill": "vocab", "prompt": "We ___ the bus to school every day.", "options": ["take", "do", "make"], "answer": 0, "explanation": "Take the bus means travel on it.", "level": 1, "use": "practice", "form": null, "pair": null}, {"id": "take-get-08", "unit": "take-get", "skill": "vocab", "prompt": "It is cold. I might ___ a cold.", "options": ["make", "do", "get"], "answer": 2, "explanation": "Get a cold means become ill with a cold.", "level": 2, "use": "practice", "form": null, "pair": null}, {"id": "take-get-09", "unit": "take-get", "skill": "vocab", "prompt": "After the long trip, we need to ___ some rest.", "options": ["make", "do", "get"], "answer": 2, "explanation": "The fixed phrase is get some rest.", "level": 2, "use": "practice", "form": null, "pair": null}, {"id": "take-get-10", "unit": "take-get", "skill": "vocab", "prompt": "Please ___ a seat while you wait.", "options": ["do", "take", "make"], "answer": 1, "explanation": "Take a seat is a polite way to ask someone to sit down.", "level": 3, "use": "practice", "form": null, "pair": null}, {"id": "communication-01", "unit": "communication", "skill": "vocab", "prompt": "Please ___ the truth.", "options": ["say", "speak", "tell"], "answer": 2, "explanation": "The fixed phrase is tell the truth.", "level": 1, "use": "diagnostic", "form": "A", "pair": 0}, {"id": "communication-02", "unit": "communication", "skill": "vocab", "prompt": "I would like to ___ a question.", "options": ["ask", "say", "tell"], "answer": 0, "explanation": "Use ask with a question.", "level": 1, "use": "diagnostic", "form": "B", "pair": 0}, {"id": "communication-03", "unit": "communication", "skill": "vocab", "prompt": "Could you ___ me some advice?", "options": ["give", "tell", "say"], "answer": 0, "explanation": "The fixed phrase is give someone advice.", "level": 2, "use": "diagnostic", "form": "A", "pair": 1}, {"id": "communication-04", "unit": "communication", "skill": "vocab", "prompt": "I need to ___ an email to my teacher.", "options": ["say", "tell", "send"], "answer": 2, "explanation": "Use send with an email.", "level": 2, "use": "diagnostic", "form": "B", "pair": 1}, {"id": "communication-05", "unit": "communication", "skill": "vocab", "prompt": "Please ___ attention to the instructions.", "options": ["pay", "do", "make"], "answer": 0, "explanation": "The fixed phrase is pay attention to.", "level": 3, "use": "diagnostic", "form": "A", "pair": 2}, {"id": "communication-06", "unit": "communication", "skill": "vocab", "prompt": "It is important to ___ a promise.", "options": ["take", "do", "keep"], "answer": 2, "explanation": "Keep a promise means do what you promised.", "level": 3, "use": "diagnostic", "form": "B", "pair": 2}, {"id": "communication-07", "unit": "communication", "skill": "vocab", "prompt": "Can you ___ me a hand with this box?", "options": ["give", "make", "do"], "answer": 0, "explanation": "Give someone a hand means help them.", "level": 1, "use": "practice", "form": null, "pair": null}, {"id": "communication-08", "unit": "communication", "skill": "vocab", "prompt": "Can you ___ me the way to the station?", "options": ["show", "speak", "say"], "answer": 0, "explanation": "Use show someone the way.", "level": 2, "use": "practice", "form": null, "pair": null}, {"id": "communication-09", "unit": "communication", "skill": "vocab", "prompt": "Please ___ me your name.", "options": ["tell", "say", "speak"], "answer": 0, "explanation": "Tell can be followed by a person directly: tell me.", "level": 2, "use": "practice", "form": null, "pair": null}, {"id": "communication-10", "unit": "communication", "skill": "vocab", "prompt": "We need to ___ this problem together.", "options": ["say", "discuss", "speak"], "answer": 1, "explanation": "Discuss takes the topic directly: discuss this problem.", "level": 3, "use": "practice", "form": null, "pair": null}, {"id": "daily-collocations-01", "unit": "daily-collocations", "skill": "vocab", "prompt": "Can you ___ this maths problem?", "options": ["solve", "build", "invent"], "answer": 0, "explanation": "Use solve with a problem.", "level": 1, "use": "diagnostic", "form": "A", "pair": 0}, {"id": "daily-collocations-02", "unit": "daily-collocations", "skill": "vocab", "prompt": "Please ___ the rules of the game.", "options": ["listen", "speak", "follow"], "answer": 2, "explanation": "Follow the rules means act according to them.", "level": 1, "use": "diagnostic", "form": "B", "pair": 0}, {"id": "daily-collocations-03", "unit": "daily-collocations", "skill": "vocab", "prompt": "Our team hopes to ___ the match.", "options": ["beat", "win", "earn"], "answer": 1, "explanation": "Win a match; beat an opponent.", "level": 2, "use": "diagnostic", "form": "A", "pair": 1}, {"id": "daily-collocations-04", "unit": "daily-collocations", "skill": "vocab", "prompt": "My brother wants to ___ a swimming record.", "options": ["take", "break", "do"], "answer": 1, "explanation": "The fixed phrase is break a record.", "level": 2, "use": "diagnostic", "form": "B", "pair": 1}, {"id": "daily-collocations-05", "unit": "daily-collocations", "skill": "vocab", "prompt": "Switch off unused lights to ___ energy.", "options": ["earn", "lend", "save"], "answer": 2, "explanation": "Save energy means avoid wasting it.", "level": 3, "use": "diagnostic", "form": "A", "pair": 2}, {"id": "daily-collocations-06", "unit": "daily-collocations", "skill": "vocab", "prompt": "We must ___ the environment from pollution.", "options": ["solve", "protect", "recycle"], "answer": 1, "explanation": "Protect the environment means keep it safe from harm.", "level": 3, "use": "diagnostic", "form": "B", "pair": 2}, {"id": "daily-collocations-07", "unit": "daily-collocations", "skill": "vocab", "prompt": "I put some money aside each week to ___ for a bicycle.", "options": ["save", "borrow", "lend"], "answer": 0, "explanation": "Putting money aside means saving it.", "level": 1, "use": "practice", "form": null, "pair": null}, {"id": "daily-collocations-08", "unit": "daily-collocations", "skill": "vocab", "prompt": "I need to ___ a dictionary to check this word.", "options": ["use", "do", "make"], "answer": 0, "explanation": "Use a dictionary means look up information in it.", "level": 2, "use": "practice", "form": null, "pair": null}, {"id": "daily-collocations-09", "unit": "daily-collocations", "skill": "vocab", "prompt": "Please ___ your seat belt.", "options": ["fasten", "fold", "make"], "answer": 0, "explanation": "The fixed phrase is fasten your seat belt.", "level": 2, "use": "practice", "form": null, "pair": null}, {"id": "daily-collocations-10", "unit": "daily-collocations", "skill": "vocab", "prompt": "I want to ___ my pronunciation.", "options": ["grow", "improve", "raise"], "answer": 1, "explanation": "Use improve with pronunciation.", "level": 3, "use": "practice", "form": null, "pair": null}, {"id": "time-prepositions-01", "unit": "time-prepositions", "skill": "prep", "prompt": "The lesson begins ___ nine o’clock.", "options": ["in", "at", "on"], "answer": 1, "explanation": "Use at with a clock time.", "level": 1, "use": "diagnostic", "form": "A", "pair": 0}, {"id": "time-prepositions-02", "unit": "time-prepositions", "skill": "prep", "prompt": "The film begins ___ six o’clock.", "options": ["in", "at", "on"], "answer": 1, "explanation": "Use at with a clock time.", "level": 1, "use": "diagnostic", "form": "B", "pair": 0}, {"id": "time-prepositions-03", "unit": "time-prepositions", "skill": "prep", "prompt": "Our club meets ___ Monday.", "options": ["at", "on", "in"], "answer": 1, "explanation": "Use on with a day of the week.", "level": 2, "use": "diagnostic", "form": "A", "pair": 1}, {"id": "time-prepositions-04", "unit": "time-prepositions", "skill": "prep", "prompt": "The concert is ___ Friday evening.", "options": ["in", "on", "at"], "answer": 1, "explanation": "Use on with a particular day or its evening.", "level": 2, "use": "diagnostic", "form": "B", "pair": 1}, {"id": "time-prepositions-05", "unit": "time-prepositions", "skill": "prep", "prompt": "My birthday is ___ May.", "options": ["at", "in", "on"], "answer": 1, "explanation": "Use in with a month.", "level": 3, "use": "diagnostic", "form": "A", "pair": 2}, {"id": "time-prepositions-06", "unit": "time-prepositions", "skill": "prep", "prompt": "We moved here ___ 2021.", "options": ["on", "at", "in"], "answer": 2, "explanation": "Use in with a year.", "level": 3, "use": "diagnostic", "form": "B", "pair": 2}, {"id": "time-prepositions-07", "unit": "time-prepositions", "skill": "prep", "prompt": "I do homework ___ the evening.", "options": ["in", "on", "at"], "answer": 0, "explanation": "The fixed time phrase is in the evening.", "level": 1, "use": "practice", "form": null, "pair": null}, {"id": "time-prepositions-08", "unit": "time-prepositions", "skill": "prep", "prompt": "The stars are bright ___ night.", "options": ["on", "in", "at"], "answer": 2, "explanation": "The fixed time phrase is at night.", "level": 2, "use": "practice", "form": null, "pair": null}, {"id": "time-prepositions-09", "unit": "time-prepositions", "skill": "prep", "prompt": "The event is ___ 15 April.", "options": ["at", "on", "in"], "answer": 1, "explanation": "Use on with a full date.", "level": 2, "use": "practice", "form": null, "pair": null}, {"id": "time-prepositions-10", "unit": "time-prepositions", "skill": "prep", "prompt": "School starts ___ September.", "options": ["in", "on", "at"], "answer": 0, "explanation": "Use in with a month.", "level": 3, "use": "practice", "form": null, "pair": null}, {"id": "place-movement-01", "unit": "place-movement", "skill": "prep", "prompt": "The books are ___ my schoolbag.", "options": ["between", "during", "in"], "answer": 2, "explanation": "A schoolbag contains the books. Use in.", "level": 1, "use": "diagnostic", "form": "A", "pair": 0}, {"id": "place-movement-02", "unit": "place-movement", "skill": "prep", "prompt": "There is a picture ___ the wall.", "options": ["on", "during", "between"], "answer": 0, "explanation": "A picture is on the surface of the wall.", "level": 1, "use": "diagnostic", "form": "B", "pair": 0}, {"id": "place-movement-03", "unit": "place-movement", "skill": "prep", "prompt": "We arrived ___ the airport early.", "options": ["to", "at", "on"], "answer": 1, "explanation": "Use arrive at with a specific place such as an airport.", "level": 2, "use": "diagnostic", "form": "A", "pair": 1}, {"id": "place-movement-04", "unit": "place-movement", "skill": "prep", "prompt": "We arrived ___ Kazakhstan yesterday.", "options": ["on", "in", "at"], "answer": 1, "explanation": "Use arrive in with a country or city.", "level": 2, "use": "diagnostic", "form": "B", "pair": 1}, {"id": "place-movement-05", "unit": "place-movement", "skill": "prep", "prompt": "We walked ___ the bridge to reach the other side.", "options": ["across", "between", "during"], "answer": 0, "explanation": "Across means from one side to the other.", "level": 3, "use": "diagnostic", "form": "A", "pair": 2}, {"id": "place-movement-06", "unit": "place-movement", "skill": "prep", "prompt": "He divided the cake ___ four equal pieces.", "options": ["at", "onto", "into"], "answer": 2, "explanation": "Use divide into for the resulting parts.", "level": 3, "use": "diagnostic", "form": "B", "pair": 2}, {"id": "place-movement-07", "unit": "place-movement", "skill": "prep", "prompt": "We travelled ___ train.", "options": ["at", "by", "from"], "answer": 1, "explanation": "By train describes the means of transport.", "level": 1, "use": "practice", "form": null, "pair": null}, {"id": "place-movement-08", "unit": "place-movement", "skill": "prep", "prompt": "He goes to school ___ foot.", "options": ["on", "in", "by"], "answer": 0, "explanation": "The fixed phrase is on foot.", "level": 2, "use": "practice", "form": null, "pair": null}, {"id": "place-movement-09", "unit": "place-movement", "skill": "prep", "prompt": "She walked from the library ___ the station.", "options": ["at", "to", "during"], "answer": 1, "explanation": "Use from one place to another.", "level": 2, "use": "practice", "form": null, "pair": null}, {"id": "place-movement-10", "unit": "place-movement", "skill": "prep", "prompt": "The shop is ___ the bank and the café.", "options": ["during", "until", "between"], "answer": 2, "explanation": "Use between with the two places linked by and.", "level": 3, "use": "practice", "form": null, "pair": null}, {"id": "fixed-prepositions-01", "unit": "fixed-prepositions", "skill": "prep", "prompt": "She is good ___ maths.", "options": ["in", "at", "on"], "answer": 1, "explanation": "The fixed phrase is good at.", "level": 1, "use": "diagnostic", "form": "A", "pair": 0}, {"id": "fixed-prepositions-02", "unit": "fixed-prepositions", "skill": "prep", "prompt": "I am interested ___ science.", "options": ["on", "in", "at"], "answer": 1, "explanation": "The fixed phrase is interested in.", "level": 1, "use": "diagnostic", "form": "B", "pair": 0}, {"id": "fixed-prepositions-03", "unit": "fixed-prepositions", "skill": "prep", "prompt": "The child is afraid ___ spiders.", "options": ["of", "at", "on"], "answer": 0, "explanation": "The fixed phrase is afraid of.", "level": 2, "use": "diagnostic", "form": "A", "pair": 1}, {"id": "fixed-prepositions-04", "unit": "fixed-prepositions", "skill": "prep", "prompt": "Please listen ___ the teacher.", "options": ["on", "to", "at"], "answer": 1, "explanation": "The verb listen is followed by to.", "level": 2, "use": "diagnostic", "form": "B", "pair": 1}, {"id": "fixed-prepositions-05", "unit": "fixed-prepositions", "skill": "prep", "prompt": "We are waiting ___ the bus.", "options": ["to", "on", "for"], "answer": 2, "explanation": "Use wait for when you name the person or thing being waited for.", "level": 3, "use": "diagnostic", "form": "A", "pair": 2}, {"id": "fixed-prepositions-06", "unit": "fixed-prepositions", "skill": "prep", "prompt": "I agree ___ you.", "options": ["to", "at", "with"], "answer": 2, "explanation": "Use agree with a person.", "level": 3, "use": "diagnostic", "form": "B", "pair": 2}, {"id": "fixed-prepositions-07", "unit": "fixed-prepositions", "skill": "prep", "prompt": "This book belongs ___ me.", "options": ["to", "for", "at"], "answer": 0, "explanation": "The fixed phrase is belong to.", "level": 1, "use": "practice", "form": null, "pair": null}, {"id": "fixed-prepositions-08", "unit": "fixed-prepositions", "skill": "prep", "prompt": "Thank you ___ your help.", "options": ["at", "to", "for"], "answer": 2, "explanation": "Use thank you for to name the reason.", "level": 2, "use": "practice", "form": null, "pair": null}, {"id": "fixed-prepositions-09", "unit": "fixed-prepositions", "skill": "prep", "prompt": "He is worried ___ the test.", "options": ["at", "about", "on"], "answer": 1, "explanation": "The fixed phrase is worried about.", "level": 2, "use": "practice", "form": null, "pair": null}, {"id": "fixed-prepositions-10", "unit": "fixed-prepositions", "skill": "prep", "prompt": "She is responsible ___ feeding the cat.", "options": ["for", "at", "to"], "answer": 0, "explanation": "The fixed phrase is responsible for.", "level": 3, "use": "practice", "form": null, "pair": null}, {"id": "for-since-01", "unit": "for-since", "skill": "prep", "prompt": "I have lived here ___ three years.", "options": ["for", "at", "since"], "answer": 0, "explanation": "Three years is a duration, so use for.", "level": 1, "use": "diagnostic", "form": "A", "pair": 0}, {"id": "for-since-02", "unit": "for-since", "skill": "prep", "prompt": "She has lived here ___ 2020.", "options": ["since", "during", "for"], "answer": 0, "explanation": "2020 is a starting point, so use since.", "level": 1, "use": "diagnostic", "form": "B", "pair": 0}, {"id": "for-since-03", "unit": "for-since", "skill": "prep", "prompt": "We have waited ___ twenty minutes.", "options": ["since", "in", "for"], "answer": 2, "explanation": "Twenty minutes is a length of time. Use for.", "level": 2, "use": "diagnostic", "form": "A", "pair": 1}, {"id": "for-since-04", "unit": "for-since", "skill": "prep", "prompt": "He has been ill ___ Monday.", "options": ["since", "for", "at"], "answer": 0, "explanation": "Monday identifies when the illness started. Use since.", "level": 2, "use": "diagnostic", "form": "B", "pair": 1}, {"id": "for-since-05", "unit": "for-since", "skill": "prep", "prompt": "They have known each other ___ a long time.", "options": ["since", "on", "for"], "answer": 2, "explanation": "A long time is a duration. Use for.", "level": 3, "use": "diagnostic", "form": "A", "pair": 2}, {"id": "for-since-06", "unit": "for-since", "skill": "prep", "prompt": "I have not seen her ___ last summer.", "options": ["for", "since", "during"], "answer": 1, "explanation": "Last summer is a starting point. Use since.", "level": 3, "use": "diagnostic", "form": "B", "pair": 2}, {"id": "for-since-07", "unit": "for-since", "skill": "prep", "prompt": "We have studied English ___ two years.", "options": ["for", "at", "since"], "answer": 0, "explanation": "Use for with a duration: two years.", "level": 1, "use": "practice", "form": null, "pair": null}, {"id": "for-since-08", "unit": "for-since", "skill": "prep", "prompt": "She has worked here ___ January.", "options": ["since", "on", "for"], "answer": 0, "explanation": "January is the starting point. Use since.", "level": 2, "use": "practice", "form": null, "pair": null}, {"id": "for-since-09", "unit": "for-since", "skill": "prep", "prompt": "He has played the guitar ___ six months.", "options": ["for", "in", "since"], "answer": 0, "explanation": "Six months is a duration. Use for.", "level": 2, "use": "practice", "form": null, "pair": null}, {"id": "for-since-10", "unit": "for-since", "skill": "prep", "prompt": "I have been awake ___ six o’clock.", "options": ["since", "on", "for"], "answer": 0, "explanation": "Six o’clock is the starting time. Use since.", "level": 3, "use": "practice", "form": null, "pair": null}, {"id": "statement-order-01", "unit": "statement-order", "skill": "order", "prompt": "Choose the sentence with standard written word order.", "options": ["She books reads.", "Reads books she.", "She reads books."], "answer": 2, "explanation": "The subject she comes before the verb reads, followed by the object books.", "level": 1, "use": "diagnostic", "form": "A", "pair": 0}, {"id": "statement-order-02", "unit": "statement-order", "skill": "order", "prompt": "Choose the sentence with standard written word order.", "options": ["Play tennis they.", "They tennis play.", "They play tennis."], "answer": 2, "explanation": "Use subject + verb + object: they play tennis.", "level": 1, "use": "diagnostic", "form": "B", "pair": 0}, {"id": "statement-order-03", "unit": "statement-order", "skill": "order", "prompt": "Choose the sentence with standard written word order.", "options": ["I a red bicycle have.", "I have a bicycle red.", "I have a red bicycle."], "answer": 2, "explanation": "Put red before bicycle and the object after have.", "level": 2, "use": "diagnostic", "form": "A", "pair": 1}, {"id": "statement-order-04", "unit": "statement-order", "skill": "order", "prompt": "Choose the sentence with standard written word order.", "options": ["She wearing is a blue jacket.", "She is wearing a blue jacket.", "She is a blue wearing jacket."], "answer": 1, "explanation": "Keep is wearing together and put blue before jacket.", "level": 2, "use": "diagnostic", "form": "B", "pair": 1}, {"id": "statement-order-05", "unit": "statement-order", "skill": "order", "prompt": "Choose the sentence with standard written word order.", "options": ["The students in are the library.", "The students are in the library.", "The are students in the library."], "answer": 1, "explanation": "The whole subject the students comes before are.", "level": 3, "use": "diagnostic", "form": "A", "pair": 2}, {"id": "statement-order-06", "unit": "statement-order", "skill": "order", "prompt": "Choose the sentence with standard written word order.", "options": ["My has friend a small dog.", "My friend has a small dog.", "My friend a small dog has."], "answer": 1, "explanation": "Keep my friend together, followed by has and the object.", "level": 3, "use": "diagnostic", "form": "B", "pair": 2}, {"id": "statement-order-07", "unit": "statement-order", "skill": "order", "prompt": "Choose the sentence with standard written word order.", "options": ["We reading enjoy stories.", "We enjoy reading stories.", "Enjoy stories we reading."], "answer": 1, "explanation": "Enjoy is followed by reading stories.", "level": 1, "use": "practice", "form": null, "pair": null}, {"id": "statement-order-08", "unit": "statement-order", "skill": "order", "prompt": "Choose the sentence with standard written word order.", "options": ["Our explains teacher the rule.", "Our teacher the explains rule.", "Our teacher explains the rule."], "answer": 2, "explanation": "Keep the subject our teacher and object the rule together.", "level": 2, "use": "practice", "form": null, "pair": null}, {"id": "statement-order-09", "unit": "statement-order", "skill": "order", "prompt": "Choose the sentence with standard written word order.", "options": ["There is in a cat the garden.", "There is a cat in the garden.", "There a cat is in the garden."], "answer": 1, "explanation": "Use there is + noun phrase + place.", "level": 2, "use": "practice", "form": null, "pair": null}, {"id": "statement-order-10", "unit": "statement-order", "skill": "order", "prompt": "Choose the sentence with standard written word order.", "options": ["Please open your books.", "Open books your please.", "Please your open books."], "answer": 0, "explanation": "In this instruction, the verb open comes before your books.", "level": 3, "use": "practice", "form": null, "pair": null}, {"id": "question-order-01", "unit": "question-order", "skill": "order", "prompt": "Choose the sentence with standard written word order.", "options": ["Where he does live?", "Where does live he?", "Where does he live?"], "answer": 2, "explanation": "Use where + does + he + live.", "level": 1, "use": "diagnostic", "form": "A", "pair": 0}, {"id": "question-order-02", "unit": "question-order", "skill": "order", "prompt": "Choose the sentence with standard written word order.", "options": ["When does she study?", "When does study she?", "When she does study?"], "answer": 0, "explanation": "Use when + does + she + study.", "level": 1, "use": "diagnostic", "form": "B", "pair": 0}, {"id": "question-order-03", "unit": "question-order", "skill": "order", "prompt": "Choose the sentence with standard written word order.", "options": ["They the did watch film?", "Did watch they the film?", "Did they watch the film?"], "answer": 2, "explanation": "Put did before they, followed by watch.", "level": 2, "use": "diagnostic", "form": "A", "pair": 1}, {"id": "question-order-04", "unit": "question-order", "skill": "order", "prompt": "Choose the sentence with standard written word order.", "options": ["What you did eat for lunch?", "What did you eat for lunch?", "What did eat you for lunch?"], "answer": 1, "explanation": "Use what + did + you + eat.", "level": 2, "use": "diagnostic", "form": "B", "pair": 1}, {"id": "question-order-05", "unit": "question-order", "skill": "order", "prompt": "Choose the sentence with standard written word order.", "options": ["How many books do you have?", "How many do books you have?", "How books many do you have?"], "answer": 0, "explanation": "Keep how many books together before do you have.", "level": 3, "use": "diagnostic", "form": "A", "pair": 2}, {"id": "question-order-06", "unit": "question-order", "skill": "order", "prompt": "Choose the sentence with standard written word order.", "options": ["What does time school start?", "What time does school start?", "What time school does start?"], "answer": 1, "explanation": "Keep what time together, then does + school + start.", "level": 3, "use": "diagnostic", "form": "B", "pair": 2}, {"id": "question-order-07", "unit": "question-order", "skill": "order", "prompt": "Choose the sentence with standard written word order.", "options": ["Why the children are laughing?", "Why are the children laughing?", "Why laughing are the children?"], "answer": 1, "explanation": "Use why + are + the children + laughing.", "level": 1, "use": "practice", "form": null, "pair": null}, {"id": "question-order-08", "unit": "question-order", "skill": "order", "prompt": "Choose the sentence with standard written word order.", "options": ["Your where schoolbag is?", "Where your is schoolbag?", "Where is your schoolbag?"], "answer": 2, "explanation": "Use where + is + your schoolbag.", "level": 2, "use": "practice", "form": null, "pair": null}, {"id": "question-order-09", "unit": "question-order", "skill": "order", "prompt": "Choose the sentence with standard written word order.", "options": ["How water much do we need?", "How much do water we need?", "How much water do we need?"], "answer": 2, "explanation": "Keep how much water together, then do + we + need.", "level": 2, "use": "practice", "form": null, "pair": null}, {"id": "question-order-10", "unit": "question-order", "skill": "order", "prompt": "Choose the sentence with standard written word order.", "options": ["When the lesson will start?", "When will the lesson start?", "When will start the lesson?"], "answer": 1, "explanation": "Use when + will + the lesson + start.", "level": 3, "use": "practice", "form": null, "pair": null}, {"id": "adverb-order-01", "unit": "adverb-order", "skill": "order", "prompt": "Choose the sentence with standard written word order.", "options": ["I usually walk to school.", "I walk to usually school.", "I usually to school walk."], "answer": 0, "explanation": "Usually goes before the main verb walk.", "level": 1, "use": "diagnostic", "form": "A", "pair": 0}, {"id": "adverb-order-02", "unit": "adverb-order", "skill": "order", "prompt": "Choose the sentence with standard written word order.", "options": ["He never to bed goes late.", "He never goes to bed late.", "He goes to never bed late."], "answer": 1, "explanation": "Never goes before goes; keep to bed together.", "level": 1, "use": "diagnostic", "form": "B", "pair": 0}, {"id": "adverb-order-03", "unit": "adverb-order", "skill": "order", "prompt": "Choose the sentence with standard written word order.", "options": ["We often our visit grandparents.", "We visit our often grandparents.", "We often visit our grandparents."], "answer": 2, "explanation": "Often comes before visit; do not split our grandparents.", "level": 2, "use": "diagnostic", "form": "A", "pair": 1}, {"id": "adverb-order-04", "unit": "adverb-order", "skill": "order", "prompt": "Choose the sentence with standard written word order.", "options": ["She sometimes chess plays.", "She plays sometimes chess she.", "She sometimes plays chess."], "answer": 2, "explanation": "Sometimes comes before the main verb plays.", "level": 2, "use": "diagnostic", "form": "B", "pair": 1}, {"id": "adverb-order-05", "unit": "adverb-order", "skill": "order", "prompt": "Choose the sentence with standard written word order.", "options": ["She friendly is always.", "She is always friendly.", "She always friendly is."], "answer": 1, "explanation": "With be, put always after is and before friendly.", "level": 3, "use": "diagnostic", "form": "A", "pair": 2}, {"id": "adverb-order-06", "unit": "adverb-order", "skill": "order", "prompt": "Choose the sentence with standard written word order.", "options": ["They ready are usually.", "They are usually ready.", "They usually ready are."], "answer": 1, "explanation": "Put usually after are and before ready.", "level": 3, "use": "diagnostic", "form": "B", "pair": 2}, {"id": "adverb-order-07", "unit": "adverb-order", "skill": "order", "prompt": "Choose the sentence with standard written word order.", "options": ["We eat fast rarely food.", "We rarely eat fast food.", "We rarely fast eat food."], "answer": 1, "explanation": "Rarely goes before eat; keep fast food together.", "level": 1, "use": "practice", "form": null, "pair": null}, {"id": "adverb-order-08", "unit": "adverb-order", "skill": "order", "prompt": "Choose the sentence with standard written word order.", "options": ["He is often late.", "He late is often.", "He often late is."], "answer": 0, "explanation": "Often goes after is.", "level": 2, "use": "practice", "form": null, "pair": null}, {"id": "adverb-order-09", "unit": "adverb-order", "skill": "order", "prompt": "Choose the sentence with standard written word order.", "options": ["I always my answers check.", "I check my always answers.", "I always check my answers."], "answer": 2, "explanation": "Always goes before check; keep my answers together.", "level": 2, "use": "practice", "form": null, "pair": null}, {"id": "adverb-order-10", "unit": "adverb-order", "skill": "order", "prompt": "Choose the sentence with standard written word order.", "options": ["My friends never rude are.", "My friends are never rude.", "My friends rude are never."], "answer": 1, "explanation": "With be, never follows are and comes before rude.", "level": 3, "use": "practice", "form": null, "pair": null}, {"id": "verb-group-order-01", "unit": "verb-group-order", "skill": "order", "prompt": "Choose the sentence with standard written word order.", "options": ["She can English speak.", "She speak can English.", "She can speak English."], "answer": 2, "explanation": "Use subject + can + base verb + object.", "level": 1, "use": "diagnostic", "form": "A", "pair": 0}, {"id": "verb-group-order-02", "unit": "verb-group-order", "skill": "order", "prompt": "Choose the sentence with standard written word order.", "options": ["He ride can a bike.", "He can a bike ride.", "He can ride a bike."], "answer": 2, "explanation": "Can comes before the base verb ride.", "level": 1, "use": "diagnostic", "form": "B", "pair": 0}, {"id": "verb-group-order-03", "unit": "verb-group-order", "skill": "order", "prompt": "Choose the sentence with standard written word order.", "options": ["He finished has already his work.", "He has already finished his work.", "He has already his work finished."], "answer": 1, "explanation": "Use has + already + finished, then the object.", "level": 2, "use": "diagnostic", "form": "A", "pair": 1}, {"id": "verb-group-order-04", "unit": "verb-group-order", "skill": "order", "prompt": "Choose the sentence with standard written word order.", "options": ["They have just arrived at the station.", "They have just at the station arrived to.", "They arrived have just at the station."], "answer": 0, "explanation": "Use have + just + arrived, followed by the place.", "level": 2, "use": "diagnostic", "form": "B", "pair": 1}, {"id": "verb-group-order-05", "unit": "verb-group-order", "skill": "order", "prompt": "Choose the sentence with standard written word order.", "options": ["Have you ever visited London?", "Have ever you visited London?", "Have visited you ever London?"], "answer": 0, "explanation": "Use have + subject + ever + past participle.", "level": 3, "use": "diagnostic", "form": "A", "pair": 2}, {"id": "verb-group-order-06", "unit": "verb-group-order", "skill": "order", "prompt": "Choose the sentence with standard written word order.", "options": ["Could tell you me the time?", "Could you me the time tell?", "Could you tell me the time?"], "answer": 2, "explanation": "Use could + you + tell, followed by the objects.", "level": 3, "use": "diagnostic", "form": "B", "pair": 2}, {"id": "verb-group-order-07", "unit": "verb-group-order", "skill": "order", "prompt": "Choose the sentence with standard written word order.", "options": ["I am to going read this book.", "I going am to read this book.", "I am going to read this book."], "answer": 2, "explanation": "Keep am going to together before the base verb read.", "level": 1, "use": "practice", "form": null, "pair": null}, {"id": "verb-group-order-08", "unit": "verb-group-order", "skill": "order", "prompt": "Choose the sentence with standard written word order.", "options": ["We not are watching TV.", "We are not watching TV.", "We are watching not TV."], "answer": 1, "explanation": "Put not after are and before watching.", "level": 2, "use": "practice", "form": null, "pair": null}, {"id": "verb-group-order-09", "unit": "verb-group-order", "skill": "order", "prompt": "Choose the sentence with standard written word order.", "options": ["I not do understand this word.", "I do understand not this word.", "I do not understand this word."], "answer": 2, "explanation": "Use do not + base verb understand.", "level": 2, "use": "practice", "form": null, "pair": null}, {"id": "verb-group-order-10", "unit": "verb-group-order", "skill": "order", "prompt": "Choose the sentence with standard written word order.", "options": ["I like would a glass of water.", "I would like a glass of water.", "I would a glass of water like."], "answer": 1, "explanation": "Keep would like together, followed by the object.", "level": 3, "use": "practice", "form": null, "pair": null}, {"id": "common-spelling-01", "unit": "common-spelling", "skill": "spell", "prompt": "I stayed home ___ I was ill.", "options": ["because", "becouse", "becaus"], "answer": 0, "explanation": "The correct spelling is because.", "level": 1, "use": "diagnostic", "form": "A", "pair": 0}, {"id": "common-spelling-02", "unit": "common-spelling", "skill": "spell", "prompt": "The garden is very ___.", "options": ["beautifal", "beutiful", "beautiful"], "answer": 2, "explanation": "The correct spelling is beautiful: beau-ti-ful.", "level": 1, "use": "diagnostic", "form": "B", "pair": 0}, {"id": "common-spelling-03", "unit": "common-spelling", "skill": "spell", "prompt": "We have a ___ lesson.", "options": ["sience", "sciense", "science"], "answer": 2, "explanation": "Science begins with sc and ends in -ence.", "level": 2, "use": "diagnostic", "form": "A", "pair": 1}, {"id": "common-spelling-04", "unit": "common-spelling", "skill": "spell", "prompt": "English is my favourite ___.", "options": ["subjekt", "subgect", "subject"], "answer": 2, "explanation": "The correct spelling is subject.", "level": 2, "use": "diagnostic", "form": "B", "pair": 1}, {"id": "common-spelling-05", "unit": "common-spelling", "skill": "spell", "prompt": "We need more ___ about the trip.", "options": ["infermation", "information", "informasion"], "answer": 1, "explanation": "The correct spelling is information.", "level": 3, "use": "diagnostic", "form": "A", "pair": 2}, {"id": "common-spelling-06", "unit": "common-spelling", "skill": "spell", "prompt": "The ___ is sunny today.", "options": ["wether", "weather", "wheather"], "answer": 1, "explanation": "The correct spelling is weather.", "level": 3, "use": "diagnostic", "form": "B", "pair": 2}, {"id": "common-spelling-07", "unit": "common-spelling", "skill": "spell", "prompt": "We visited a ___ yesterday.", "options": ["museum", "muzeum", "musem"], "answer": 0, "explanation": "The correct spelling is museum.", "level": 1, "use": "practice", "form": null, "pair": null}, {"id": "common-spelling-08", "unit": "common-spelling", "skill": "spell", "prompt": "I celebrate my ___ every year.", "options": ["birthdy", "berthday", "birthday"], "answer": 2, "explanation": "The correct spelling is birthday.", "level": 2, "use": "practice", "form": null, "pair": null}, {"id": "common-spelling-09", "unit": "common-spelling", "skill": "spell", "prompt": "Please write your ___ here.", "options": ["naim", "name", "neme"], "answer": 1, "explanation": "The correct spelling is name.", "level": 2, "use": "practice", "form": null, "pair": null}, {"id": "common-spelling-10", "unit": "common-spelling", "skill": "spell", "prompt": "Her ___ is excellent.", "options": ["pronunciation", "pronounciation", "pronuncation"], "answer": 0, "explanation": "Pronunciation has nun, not noun, after pro-.", "level": 3, "use": "practice", "form": null, "pair": null}, {"id": "double-letters-01", "unit": "double-letters", "skill": "spell", "prompt": "Please write your ___ here.", "options": ["addres", "address", "adress"], "answer": 1, "explanation": "Address has two d letters and two s letters.", "level": 1, "use": "diagnostic", "form": "A", "pair": 0}, {"id": "double-letters-02", "unit": "double-letters", "skill": "spell", "prompt": "Let us meet ___.", "options": ["tommorow", "tomorrow", "tomorow"], "answer": 1, "explanation": "Tomorrow has one m and two r letters.", "level": 1, "use": "diagnostic", "form": "B", "pair": 0}, {"id": "double-letters-03", "unit": "double-letters", "skill": "spell", "prompt": "This exercise is ___.", "options": ["difficult", "difficalt", "dificult"], "answer": 0, "explanation": "Difficult has two f letters.", "level": 2, "use": "diagnostic", "form": "A", "pair": 1}, {"id": "double-letters-04", "unit": "double-letters", "skill": "spell", "prompt": "They live in a small ___.", "options": ["village", "vilage", "villige"], "answer": 0, "explanation": "Village has two l letters.", "level": 2, "use": "diagnostic", "form": "B", "pair": 1}, {"id": "double-letters-05", "unit": "double-letters", "skill": "spell", "prompt": "It is ___ to wear a seat belt.", "options": ["neccessary", "necessary", "necesary"], "answer": 1, "explanation": "Necessary has one c and two s letters.", "level": 3, "use": "diagnostic", "form": "A", "pair": 2}, {"id": "double-letters-06", "unit": "double-letters", "skill": "spell", "prompt": "The answer is ___.", "options": ["correkt", "corect", "correct"], "answer": 2, "explanation": "Correct has two r letters and ends in -ect.", "level": 3, "use": "diagnostic", "form": "B", "pair": 2}, {"id": "double-letters-07", "unit": "double-letters", "skill": "spell", "prompt": "The story is very ___.", "options": ["funy", "funnie", "funny"], "answer": 2, "explanation": "Funny has two n letters and ends in y.", "level": 1, "use": "practice", "form": null, "pair": null}, {"id": "double-letters-08", "unit": "double-letters", "skill": "spell", "prompt": "We live near a ___ lake.", "options": ["smaul", "smal", "small"], "answer": 2, "explanation": "Small ends in two l letters.", "level": 2, "use": "practice", "form": null, "pair": null}, {"id": "double-letters-09", "unit": "double-letters", "skill": "spell", "prompt": "I feel ___ after the good news.", "options": ["happie", "happy", "hapy"], "answer": 1, "explanation": "Happy has two p letters and ends in y.", "level": 2, "use": "practice", "form": null, "pair": null}, {"id": "double-letters-10", "unit": "double-letters", "skill": "spell", "prompt": "She is a great ___.", "options": ["swimmar", "swimmer", "swimer"], "answer": 1, "explanation": "Swimmer has two m letters and ends in -er.", "level": 3, "use": "practice", "form": null, "pair": null}, {"id": "letter-patterns-01", "unit": "letter-patterns", "skill": "spell", "prompt": "Please ___ to the teacher.", "options": ["lisen", "listten", "listen"], "answer": 2, "explanation": "Listen has a written t that is not pronounced.", "level": 1, "use": "diagnostic", "form": "A", "pair": 0}, {"id": "letter-patterns-02", "unit": "letter-patterns", "skill": "spell", "prompt": "Please check your ___.", "options": ["answer", "anser", "answar"], "answer": 0, "explanation": "Answer has a written w that is not pronounced.", "level": 1, "use": "diagnostic", "form": "B", "pair": 0}, {"id": "letter-patterns-03", "unit": "letter-patterns", "skill": "spell", "prompt": "She is my best ___.", "options": ["friend", "freind", "frend"], "answer": 0, "explanation": "In friend, i comes before e.", "level": 2, "use": "diagnostic", "form": "A", "pair": 1}, {"id": "letter-patterns-04", "unit": "letter-patterns", "skill": "spell", "prompt": "Our test is on ___.", "options": ["Wensday", "Wendesday", "Wednesday"], "answer": 2, "explanation": "The correct spelling is Wednesday.", "level": 2, "use": "diagnostic", "form": "B", "pair": 1}, {"id": "letter-patterns-05", "unit": "letter-patterns", "skill": "spell", "prompt": "We have ___ time to finish.", "options": ["enough", "enouph", "enogh"], "answer": 0, "explanation": "The correct spelling is enough.", "level": 3, "use": "diagnostic", "form": "A", "pair": 2}, {"id": "letter-patterns-06", "unit": "letter-patterns", "skill": "spell", "prompt": "Please ___ the new words.", "options": ["remmember", "remember", "remeber"], "answer": 1, "explanation": "Remember has one m after re- and another in -member.", "level": 3, "use": "diagnostic", "form": "B", "pair": 2}, {"id": "letter-patterns-07", "unit": "letter-patterns", "skill": "spell", "prompt": "I know the ___ to the question.", "options": ["anwser", "answer", "ansver"], "answer": 1, "explanation": "Answer includes the sequence -nsw-.", "level": 1, "use": "practice", "form": null, "pair": null}, {"id": "letter-patterns-08", "unit": "letter-patterns", "skill": "spell", "prompt": "She hurt her left ___.", "options": ["knee", "kneei", "nee"], "answer": 0, "explanation": "Knee starts with a silent k.", "level": 2, "use": "practice", "form": null, "pair": null}, {"id": "letter-patterns-09", "unit": "letter-patterns", "skill": "spell", "prompt": "Please use a ___ to cut the bread.", "options": ["knif", "nife", "knife"], "answer": 2, "explanation": "Knife begins with a silent k and ends in e.", "level": 2, "use": "practice", "form": null, "pair": null}, {"id": "letter-patterns-10", "unit": "letter-patterns", "skill": "spell", "prompt": "I will ___ a letter.", "options": ["rite", "write", "writ"], "answer": 1, "explanation": "Write begins with a silent w and ends in e.", "level": 3, "use": "practice", "form": null, "pair": null}, {"id": "capital-letters-01", "unit": "capital-letters", "skill": "spell", "prompt": "We study ___ at school.", "options": ["English", "EngLish", "english"], "answer": 0, "explanation": "Language names begin with a capital letter: English.", "level": 1, "use": "diagnostic", "form": "A", "pair": 0}, {"id": "capital-letters-02", "unit": "capital-letters", "skill": "spell", "prompt": "She speaks ___ with her family.", "options": ["kazakh", "Kazakh", "kaZakh"], "answer": 1, "explanation": "Language names begin with a capital letter: Kazakh.", "level": 1, "use": "diagnostic", "form": "B", "pair": 0}, {"id": "capital-letters-03", "unit": "capital-letters", "skill": "spell", "prompt": "We celebrate Nauryz in ___.", "options": ["March", "march", "MarCh"], "answer": 0, "explanation": "Month names begin with a capital letter.", "level": 2, "use": "diagnostic", "form": "A", "pair": 1}, {"id": "capital-letters-04", "unit": "capital-letters", "skill": "spell", "prompt": "The club meets on ___.", "options": ["friday", "friDay", "Friday"], "answer": 2, "explanation": "Day names begin with a capital letter.", "level": 2, "use": "diagnostic", "form": "B", "pair": 1}, {"id": "capital-letters-05", "unit": "capital-letters", "skill": "spell", "prompt": "I was born in ___.", "options": ["kazakhstan", "Kazakhstan", "kazaKhstan"], "answer": 1, "explanation": "Country names begin with a capital letter.", "level": 3, "use": "diagnostic", "form": "A", "pair": 2}, {"id": "capital-letters-06", "unit": "capital-letters", "skill": "spell", "prompt": "___ enjoy reading books.", "options": ["I", "i", "ı"], "answer": 0, "explanation": "The pronoun I is always a capital letter.", "level": 3, "use": "diagnostic", "form": "B", "pair": 2}, {"id": "capital-letters-07", "unit": "capital-letters", "skill": "spell", "prompt": "Our teacher is called ___.", "options": ["Aida", "aiDa", "aida"], "answer": 0, "explanation": "A person’s name begins with a capital letter.", "level": 1, "use": "practice", "form": null, "pair": null}, {"id": "capital-letters-08", "unit": "capital-letters", "skill": "spell", "prompt": "The holiday starts in ___.", "options": ["June", "juNe", "june"], "answer": 0, "explanation": "Month names begin with a capital letter.", "level": 2, "use": "practice", "form": null, "pair": null}, {"id": "capital-letters-09", "unit": "capital-letters", "skill": "spell", "prompt": "We visited ___ last summer.", "options": ["london", "lonDon", "London"], "answer": 2, "explanation": "City names begin with a capital letter.", "level": 2, "use": "practice", "form": null, "pair": null}, {"id": "capital-letters-10", "unit": "capital-letters", "skill": "spell", "prompt": "Choose the correctly capitalised sentence.", "options": ["She likes english.", "She likes English.", "she likes English."], "answer": 1, "explanation": "Capitalise the first word of the sentence and the language name.", "level": 3, "use": "practice", "form": null, "pair": null}]};

````

## dist/assets/question-bank.json

````json
{
  "version": 4,
  "language": "en",
  "units": [
    {
      "id": "third-person",
      "skill": "agr",
      "title": "Third-person -s / -es",
      "rule": "In the present simple, add -s or -es after he, she, it or a singular subject. Change consonant + y to -ies.",
      "example": "She reads. He watches. My sister studies."
    },
    {
      "id": "auxiliary-base",
      "skill": "agr",
      "title": "Base verbs after auxiliaries",
      "rule": "After do, does, did, do not, does not or did not, use the base form of the main verb.",
      "example": "Does she play? He does not play. Did they go?"
    },
    {
      "id": "be-agreement",
      "skill": "agr",
      "title": "Forms of be",
      "rule": "Match be to the subject and time: I am; he/she/it is; we/you/they are. In the past, use was with I/he/she/it and were with we/you/they.",
      "example": "I am ready. They are ready. We were tired yesterday."
    },
    {
      "id": "have-there",
      "skill": "agr",
      "title": "Have, has and there is / are",
      "rule": "Use has with he/she/it or a singular subject; use have with I/you/we/they. Use there is for one thing and there are for more than one.",
      "example": "She has a notebook. They have notebooks. There are two books."
    },
    {
      "id": "past-simple",
      "skill": "tense",
      "title": "Completed past actions",
      "rule": "Use the past simple for completed actions at a past time. Regular verbs end in -ed; some verbs have irregular past forms.",
      "example": "We visited the museum yesterday. She went home."
    },
    {
      "id": "present-continuous",
      "skill": "tense",
      "title": "Actions happening now",
      "rule": "For an action happening now, use am/is/are + verb-ing. Match the auxiliary to the subject.",
      "example": "I am reading. She is writing. They are playing."
    },
    {
      "id": "past-continuous",
      "skill": "tense",
      "title": "Actions in progress in the past",
      "rule": "Use was/were + verb-ing for an action in progress at a past moment. A shorter event can interrupt it.",
      "example": "I was reading when the phone rang."
    },
    {
      "id": "present-perfect",
      "skill": "tense",
      "title": "Experience and recent results",
      "rule": "Use have/has + past participle for experiences or past actions linked to now. Words such as ever, never, just, already and yet often help.",
      "example": "I have seen this film. She has just arrived."
    },
    {
      "id": "make-do",
      "skill": "vocab",
      "title": "Make and do",
      "rule": "Learn these combinations as whole phrases: do homework, do your best, make a decision, make a mistake, make your bed and make friends.",
      "example": "Do your homework. Make a decision."
    },
    {
      "id": "take-get",
      "skill": "vocab",
      "title": "Take and get",
      "rule": "Learn action phrases together: take a photo, take a break, take notes, take part and get enough sleep.",
      "example": "Take a photo. Get enough sleep."
    },
    {
      "id": "communication",
      "skill": "vocab",
      "title": "Communication phrases",
      "rule": "Use tell the truth, ask a question, give advice, send an email, pay attention and keep a promise.",
      "example": "Ask a question. Give advice. Tell the truth."
    },
    {
      "id": "daily-collocations",
      "skill": "vocab",
      "title": "Study and everyday phrases",
      "rule": "Learn common combinations: solve a problem, follow the rules, save money, protect the environment and win a match.",
      "example": "Solve a problem. Follow the rules."
    },
    {
      "id": "time-prepositions",
      "skill": "prep",
      "title": "At, on and in for time",
      "rule": "Use at with clock times, on with days and dates, and in with months and years. Learn at night and in the morning as phrases.",
      "example": "At nine. On Monday. In September."
    },
    {
      "id": "place-movement",
      "skill": "prep",
      "title": "Place and movement",
      "rule": "Use in for something inside, on for a surface, to for a destination and across for movement from one side to the other. Learn arrive at a place and arrive in a city or country.",
      "example": "In a bag. On a wall. Walk across a bridge."
    },
    {
      "id": "fixed-prepositions",
      "skill": "prep",
      "title": "Prepositions in fixed phrases",
      "rule": "Learn the preposition with its phrase: good at, interested in, afraid of, listen to, wait for, agree with and belong to.",
      "example": "Good at maths. Interested in science."
    },
    {
      "id": "for-since",
      "skill": "prep",
      "title": "For and since",
      "rule": "Use for with a length of time and since with the point when something began.",
      "example": "For three years. Since 2020."
    },
    {
      "id": "statement-order",
      "skill": "order",
      "title": "Statements and noun phrases",
      "rule": "In a simple statement, put the subject before the verb, then the object. Put an adjective before the noun it describes.",
      "example": "She reads books. I have a blue bag."
    },
    {
      "id": "question-order",
      "skill": "order",
      "title": "Question word order",
      "rule": "In questions, put the auxiliary before the subject. With a question word, use question word + auxiliary + subject + main verb.",
      "example": "Where does she live? Did you see it?"
    },
    {
      "id": "adverb-order",
      "skill": "order",
      "title": "Frequency adverbs",
      "rule": "Frequency adverbs usually come before a main verb and after be. Keep noun phrases together.",
      "example": "She often reads. He is always polite."
    },
    {
      "id": "verb-group-order",
      "skill": "order",
      "title": "Auxiliaries and verb groups",
      "rule": "Keep auxiliaries and main verbs in order. Use subject + modal + base verb, have/has + past participle, or be + going to + base verb.",
      "example": "She can swim. He has just arrived."
    },
    {
      "id": "common-spelling",
      "skill": "spell",
      "title": "Common word spellings",
      "rule": "Check the whole word, not only how it sounds. Notice the letter sequence in because, beautiful, science, subject and information.",
      "example": "because · beautiful · science"
    },
    {
      "id": "double-letters",
      "skill": "spell",
      "title": "Single and double letters",
      "rule": "Notice which consonants are doubled: address has dd and ss; tomorrow has rr; necessary has one c and two s.",
      "example": "address · tomorrow · necessary"
    },
    {
      "id": "letter-patterns",
      "skill": "spell",
      "title": "Silent letters and letter order",
      "rule": "Some letters are written but not heard. Check listen, answer and Wednesday. In friend, i comes before e.",
      "example": "listen · answer · Wednesday · friend"
    },
    {
      "id": "capital-letters",
      "skill": "spell",
      "title": "Capital letters",
      "rule": "Use capitals for I, names, languages, countries, months and days. Begin a sentence with a capital letter.",
      "example": "I study English in Kazakhstan on Monday."
    }
  ],
  "questions": [
    {
      "id": "third-person-01",
      "unit": "third-person",
      "skill": "agr",
      "prompt": "My sister ___ English every day.",
      "options": [
        "study",
        "studies",
        "studying"
      ],
      "answer": 1,
      "explanation": "My sister is one person. Study changes to studies after a singular third-person subject.",
      "level": 1,
      "use": "diagnostic",
      "form": "A",
      "pair": 0
    },
    {
      "id": "third-person-02",
      "unit": "third-person",
      "skill": "agr",
      "prompt": "My brother ___ football every Saturday.",
      "options": [
        "playing",
        "plays",
        "play"
      ],
      "answer": 1,
      "explanation": "My brother is one person. Add -s: plays.",
      "level": 1,
      "use": "diagnostic",
      "form": "B",
      "pair": 0
    },
    {
      "id": "third-person-03",
      "unit": "third-person",
      "skill": "agr",
      "prompt": "Our teacher ___ the answer clearly.",
      "options": [
        "explaining",
        "explains",
        "explain"
      ],
      "answer": 1,
      "explanation": "Our teacher is singular, so the present-simple form is explains.",
      "level": 2,
      "use": "diagnostic",
      "form": "A",
      "pair": 1
    },
    {
      "id": "third-person-04",
      "unit": "third-person",
      "skill": "agr",
      "prompt": "The school bus ___ at eight.",
      "options": [
        "arriving",
        "arrive",
        "arrives"
      ],
      "answer": 2,
      "explanation": "The bus is singular. Add -s: arrives.",
      "level": 2,
      "use": "diagnostic",
      "form": "B",
      "pair": 1
    },
    {
      "id": "third-person-05",
      "unit": "third-person",
      "skill": "agr",
      "prompt": "My cousin ___ TV after dinner.",
      "options": [
        "watching",
        "watch",
        "watches"
      ],
      "answer": 2,
      "explanation": "Watch ends in -ch. Add -es after a singular subject: watches.",
      "level": 3,
      "use": "diagnostic",
      "form": "A",
      "pair": 2
    },
    {
      "id": "third-person-06",
      "unit": "third-person",
      "skill": "agr",
      "prompt": "The little bird ___ over the lake every morning.",
      "options": [
        "flies",
        "flying",
        "fly"
      ],
      "answer": 0,
      "explanation": "Fly ends in consonant + y. Change y to -ies: flies.",
      "level": 3,
      "use": "diagnostic",
      "form": "B",
      "pair": 2
    },
    {
      "id": "third-person-07",
      "unit": "third-person",
      "skill": "agr",
      "prompt": "My father ___ in a hospital.",
      "options": [
        "works",
        "work",
        "working"
      ],
      "answer": 0,
      "explanation": "My father is singular. The correct form is works.",
      "level": 1,
      "use": "practice",
      "form": null,
      "pair": null
    },
    {
      "id": "third-person-08",
      "unit": "third-person",
      "skill": "agr",
      "prompt": "She ___ her teeth twice a day.",
      "options": [
        "brushes",
        "brushing",
        "brush"
      ],
      "answer": 0,
      "explanation": "Brush ends in -sh, so add -es: brushes.",
      "level": 2,
      "use": "practice",
      "form": null,
      "pair": null
    },
    {
      "id": "third-person-09",
      "unit": "third-person",
      "skill": "agr",
      "prompt": "A cat ___ mice.",
      "options": [
        "catch",
        "catching",
        "catches"
      ],
      "answer": 2,
      "explanation": "Catch ends in -ch, so add -es after a singular subject.",
      "level": 2,
      "use": "practice",
      "form": null,
      "pair": null
    },
    {
      "id": "third-person-10",
      "unit": "third-person",
      "skill": "agr",
      "prompt": "The baby often ___ when he is hungry.",
      "options": [
        "cry",
        "crying",
        "cries"
      ],
      "answer": 2,
      "explanation": "Change consonant + y to -ies: cry becomes cries.",
      "level": 3,
      "use": "practice",
      "form": null,
      "pair": null
    },
    {
      "id": "auxiliary-base-01",
      "unit": "auxiliary-base",
      "skill": "agr",
      "prompt": "Does your sister ___ English?",
      "options": [
        "speaks",
        "speak",
        "speaking"
      ],
      "answer": 1,
      "explanation": "Does already marks the question. Use the base form speak.",
      "level": 1,
      "use": "diagnostic",
      "form": "A",
      "pair": 0
    },
    {
      "id": "auxiliary-base-02",
      "unit": "auxiliary-base",
      "skill": "agr",
      "prompt": "Does your brother ___ chess?",
      "options": [
        "play",
        "playing",
        "plays"
      ],
      "answer": 0,
      "explanation": "Use the base form play after does.",
      "level": 1,
      "use": "diagnostic",
      "form": "B",
      "pair": 0
    },
    {
      "id": "auxiliary-base-03",
      "unit": "auxiliary-base",
      "skill": "agr",
      "prompt": "She does not ___ coffee.",
      "options": [
        "drinking",
        "drink",
        "drinks"
      ],
      "answer": 1,
      "explanation": "After does not, the main verb stays in its base form: drink.",
      "level": 2,
      "use": "diagnostic",
      "form": "A",
      "pair": 1
    },
    {
      "id": "auxiliary-base-04",
      "unit": "auxiliary-base",
      "skill": "agr",
      "prompt": "My teacher does not ___ homework on Fridays.",
      "options": [
        "giving",
        "gives",
        "give"
      ],
      "answer": 2,
      "explanation": "Use give, not gives, after does not.",
      "level": 2,
      "use": "diagnostic",
      "form": "B",
      "pair": 1
    },
    {
      "id": "auxiliary-base-05",
      "unit": "auxiliary-base",
      "skill": "agr",
      "prompt": "Did you ___ the match yesterday?",
      "options": [
        "see",
        "saw",
        "seeing"
      ],
      "answer": 0,
      "explanation": "Did marks the past tense. The main verb must be see.",
      "level": 3,
      "use": "diagnostic",
      "form": "A",
      "pair": 2
    },
    {
      "id": "auxiliary-base-06",
      "unit": "auxiliary-base",
      "skill": "agr",
      "prompt": "Did they ___ to the museum?",
      "options": [
        "go",
        "went",
        "going"
      ],
      "answer": 0,
      "explanation": "Use the base form go after did.",
      "level": 3,
      "use": "diagnostic",
      "form": "B",
      "pair": 2
    },
    {
      "id": "auxiliary-base-07",
      "unit": "auxiliary-base",
      "skill": "agr",
      "prompt": "Do your friends ___ reading?",
      "options": [
        "enjoys",
        "enjoy",
        "enjoying"
      ],
      "answer": 1,
      "explanation": "Use the base form enjoy after do.",
      "level": 1,
      "use": "practice",
      "form": null,
      "pair": null
    },
    {
      "id": "auxiliary-base-08",
      "unit": "auxiliary-base",
      "skill": "agr",
      "prompt": "He did not ___ the window.",
      "options": [
        "opened",
        "open",
        "opening"
      ],
      "answer": 1,
      "explanation": "Use open after did not.",
      "level": 2,
      "use": "practice",
      "form": null,
      "pair": null
    },
    {
      "id": "auxiliary-base-09",
      "unit": "auxiliary-base",
      "skill": "agr",
      "prompt": "Does Aida ___ a bicycle?",
      "options": [
        "have",
        "has",
        "having"
      ],
      "answer": 0,
      "explanation": "Does is followed by have, not has.",
      "level": 2,
      "use": "practice",
      "form": null,
      "pair": null
    },
    {
      "id": "auxiliary-base-10",
      "unit": "auxiliary-base",
      "skill": "agr",
      "prompt": "We do not ___ uniforms on Sundays.",
      "options": [
        "wear",
        "wearing",
        "wears"
      ],
      "answer": 0,
      "explanation": "Use the base form wear after do not.",
      "level": 3,
      "use": "practice",
      "form": null,
      "pair": null
    },
    {
      "id": "be-agreement-01",
      "unit": "be-agreement",
      "skill": "agr",
      "prompt": "I ___ ready for the lesson.",
      "options": [
        "are",
        "am",
        "is"
      ],
      "answer": 1,
      "explanation": "The present form of be after I is am.",
      "level": 1,
      "use": "diagnostic",
      "form": "A",
      "pair": 0
    },
    {
      "id": "be-agreement-02",
      "unit": "be-agreement",
      "skill": "agr",
      "prompt": "She ___ ready for the lesson.",
      "options": [
        "am",
        "is",
        "are"
      ],
      "answer": 1,
      "explanation": "Use is with she in the present.",
      "level": 1,
      "use": "diagnostic",
      "form": "B",
      "pair": 0
    },
    {
      "id": "be-agreement-03",
      "unit": "be-agreement",
      "skill": "agr",
      "prompt": "The students ___ in the library now.",
      "options": [
        "are",
        "am",
        "is"
      ],
      "answer": 0,
      "explanation": "The students is plural, so use are.",
      "level": 2,
      "use": "diagnostic",
      "form": "A",
      "pair": 1
    },
    {
      "id": "be-agreement-04",
      "unit": "be-agreement",
      "skill": "agr",
      "prompt": "My brother and I ___ in Grade 7.",
      "options": [
        "are",
        "is",
        "am"
      ],
      "answer": 0,
      "explanation": "My brother and I means we. Use are.",
      "level": 2,
      "use": "diagnostic",
      "form": "B",
      "pair": 1
    },
    {
      "id": "be-agreement-05",
      "unit": "be-agreement",
      "skill": "agr",
      "prompt": "We ___ at home last Sunday.",
      "options": [
        "were",
        "are",
        "was"
      ],
      "answer": 0,
      "explanation": "Last Sunday is past time. The past form with we is were.",
      "level": 3,
      "use": "diagnostic",
      "form": "A",
      "pair": 2
    },
    {
      "id": "be-agreement-06",
      "unit": "be-agreement",
      "skill": "agr",
      "prompt": "He ___ tired after the trip yesterday.",
      "options": [
        "is",
        "were",
        "was"
      ],
      "answer": 2,
      "explanation": "Use was with he for a completed past situation.",
      "level": 3,
      "use": "diagnostic",
      "form": "B",
      "pair": 2
    },
    {
      "id": "be-agreement-07",
      "unit": "be-agreement",
      "skill": "agr",
      "prompt": "These shoes ___ comfortable.",
      "options": [
        "am",
        "is",
        "are"
      ],
      "answer": 2,
      "explanation": "These shoes is plural. Use are.",
      "level": 1,
      "use": "practice",
      "form": null,
      "pair": null
    },
    {
      "id": "be-agreement-08",
      "unit": "be-agreement",
      "skill": "agr",
      "prompt": "The boys ___ tired yesterday.",
      "options": [
        "were",
        "was",
        "are"
      ],
      "answer": 0,
      "explanation": "Yesterday requires past tense. Use were with the boys.",
      "level": 2,
      "use": "practice",
      "form": null,
      "pair": null
    },
    {
      "id": "be-agreement-09",
      "unit": "be-agreement",
      "skill": "agr",
      "prompt": "Everyone ___ here now.",
      "options": [
        "am",
        "is",
        "are"
      ],
      "answer": 1,
      "explanation": "Everyone takes a singular verb: is.",
      "level": 2,
      "use": "practice",
      "form": null,
      "pair": null
    },
    {
      "id": "be-agreement-10",
      "unit": "be-agreement",
      "skill": "agr",
      "prompt": "Neither answer ___ correct.",
      "options": [
        "am",
        "are",
        "is"
      ],
      "answer": 2,
      "explanation": "Neither answer refers to each answer separately and takes is.",
      "level": 3,
      "use": "practice",
      "form": null,
      "pair": null
    },
    {
      "id": "have-there-01",
      "unit": "have-there",
      "skill": "agr",
      "prompt": "My dog ___ a long tail.",
      "options": [
        "have",
        "has",
        "having"
      ],
      "answer": 1,
      "explanation": "My dog is singular. Use has.",
      "level": 1,
      "use": "diagnostic",
      "form": "A",
      "pair": 0
    },
    {
      "id": "have-there-02",
      "unit": "have-there",
      "skill": "agr",
      "prompt": "My sister ___ a new schoolbag.",
      "options": [
        "have",
        "having",
        "has"
      ],
      "answer": 2,
      "explanation": "My sister is singular. Use has.",
      "level": 1,
      "use": "diagnostic",
      "form": "B",
      "pair": 0
    },
    {
      "id": "have-there-03",
      "unit": "have-there",
      "skill": "agr",
      "prompt": "The students ___ new notebooks.",
      "options": [
        "has",
        "having",
        "have"
      ],
      "answer": 2,
      "explanation": "The students is plural. Use have.",
      "level": 2,
      "use": "diagnostic",
      "form": "A",
      "pair": 1
    },
    {
      "id": "have-there-04",
      "unit": "have-there",
      "skill": "agr",
      "prompt": "My parents ___ a small car.",
      "options": [
        "have",
        "has",
        "having"
      ],
      "answer": 0,
      "explanation": "My parents is plural. Use have.",
      "level": 2,
      "use": "diagnostic",
      "form": "B",
      "pair": 1
    },
    {
      "id": "have-there-05",
      "unit": "have-there",
      "skill": "agr",
      "prompt": "There ___ a book on the desk.",
      "options": [
        "am",
        "is",
        "are"
      ],
      "answer": 1,
      "explanation": "A book is one thing. Use there is.",
      "level": 3,
      "use": "diagnostic",
      "form": "A",
      "pair": 2
    },
    {
      "id": "have-there-06",
      "unit": "have-there",
      "skill": "agr",
      "prompt": "There ___ two windows in this room.",
      "options": [
        "am",
        "is",
        "are"
      ],
      "answer": 2,
      "explanation": "Two windows is plural. Use there are.",
      "level": 3,
      "use": "diagnostic",
      "form": "B",
      "pair": 2
    },
    {
      "id": "have-there-07",
      "unit": "have-there",
      "skill": "agr",
      "prompt": "I ___ a question.",
      "options": [
        "have",
        "having",
        "has"
      ],
      "answer": 0,
      "explanation": "Use have with I.",
      "level": 1,
      "use": "practice",
      "form": null,
      "pair": null
    },
    {
      "id": "have-there-08",
      "unit": "have-there",
      "skill": "agr",
      "prompt": "The classroom ___ four large windows.",
      "options": [
        "having",
        "have",
        "has"
      ],
      "answer": 2,
      "explanation": "The classroom is one room. Use has.",
      "level": 2,
      "use": "practice",
      "form": null,
      "pair": null
    },
    {
      "id": "have-there-09",
      "unit": "have-there",
      "skill": "agr",
      "prompt": "There ___ some milk in the fridge.",
      "options": [
        "is",
        "are",
        "am"
      ],
      "answer": 0,
      "explanation": "Milk is uncountable. Use there is.",
      "level": 2,
      "use": "practice",
      "form": null,
      "pair": null
    },
    {
      "id": "have-there-10",
      "unit": "have-there",
      "skill": "agr",
      "prompt": "There ___ many people at the station.",
      "options": [
        "are",
        "am",
        "is"
      ],
      "answer": 0,
      "explanation": "People is plural. Use there are.",
      "level": 3,
      "use": "practice",
      "form": null,
      "pair": null
    },
    {
      "id": "past-simple-01",
      "unit": "past-simple",
      "skill": "tense",
      "prompt": "We ___ the museum yesterday.",
      "options": [
        "are visiting",
        "visited",
        "visit"
      ],
      "answer": 1,
      "explanation": "Yesterday is a finished past time. Use visited.",
      "level": 1,
      "use": "diagnostic",
      "form": "A",
      "pair": 0
    },
    {
      "id": "past-simple-02",
      "unit": "past-simple",
      "skill": "tense",
      "prompt": "They ___ a film last night.",
      "options": [
        "are watching",
        "watch",
        "watched"
      ],
      "answer": 2,
      "explanation": "Last night is finished. Use the past form watched.",
      "level": 1,
      "use": "diagnostic",
      "form": "B",
      "pair": 0
    },
    {
      "id": "past-simple-03",
      "unit": "past-simple",
      "skill": "tense",
      "prompt": "She ___ a letter last week.",
      "options": [
        "wrote",
        "is writing",
        "writes"
      ],
      "answer": 0,
      "explanation": "Last week is past time. The past of write is wrote.",
      "level": 2,
      "use": "diagnostic",
      "form": "A",
      "pair": 1
    },
    {
      "id": "past-simple-04",
      "unit": "past-simple",
      "skill": "tense",
      "prompt": "My family ___ to Almaty last summer.",
      "options": [
        "are going",
        "goes",
        "went"
      ],
      "answer": 2,
      "explanation": "Last summer is past time. The past of go is went.",
      "level": 2,
      "use": "diagnostic",
      "form": "B",
      "pair": 1
    },
    {
      "id": "past-simple-05",
      "unit": "past-simple",
      "skill": "tense",
      "prompt": "I ___ my keys two hours ago.",
      "options": [
        "am finding",
        "find",
        "found"
      ],
      "answer": 2,
      "explanation": "Ago refers to a completed past time. Find becomes found.",
      "level": 3,
      "use": "diagnostic",
      "form": "A",
      "pair": 2
    },
    {
      "id": "past-simple-06",
      "unit": "past-simple",
      "skill": "tense",
      "prompt": "He ___ his leg last winter.",
      "options": [
        "is breaking",
        "broke",
        "breaks"
      ],
      "answer": 1,
      "explanation": "Last winter is past time. Break becomes broke.",
      "level": 3,
      "use": "diagnostic",
      "form": "B",
      "pair": 2
    },
    {
      "id": "past-simple-07",
      "unit": "past-simple",
      "skill": "tense",
      "prompt": "Yesterday, we ___ a new topic.",
      "options": [
        "started",
        "start",
        "are starting"
      ],
      "answer": 0,
      "explanation": "Use the past form started with yesterday.",
      "level": 1,
      "use": "practice",
      "form": null,
      "pair": null
    },
    {
      "id": "past-simple-08",
      "unit": "past-simple",
      "skill": "tense",
      "prompt": "She ___ a book on Monday last week.",
      "options": [
        "buys",
        "is buying",
        "bought"
      ],
      "answer": 2,
      "explanation": "The completed past time needs bought, the past of buy.",
      "level": 2,
      "use": "practice",
      "form": null,
      "pair": null
    },
    {
      "id": "past-simple-09",
      "unit": "past-simple",
      "skill": "tense",
      "prompt": "We ___ lunch at school yesterday.",
      "options": [
        "are having",
        "have",
        "had"
      ],
      "answer": 2,
      "explanation": "The past form of have is had.",
      "level": 2,
      "use": "practice",
      "form": null,
      "pair": null
    },
    {
      "id": "past-simple-10",
      "unit": "past-simple",
      "skill": "tense",
      "prompt": "They ___ to Astana in 2022.",
      "options": [
        "move",
        "moved",
        "are moving"
      ],
      "answer": 1,
      "explanation": "A finished year calls for the past simple: moved.",
      "level": 3,
      "use": "practice",
      "form": null,
      "pair": null
    },
    {
      "id": "present-continuous-01",
      "unit": "present-continuous",
      "skill": "tense",
      "prompt": "Look! The children ___ in the park.",
      "options": [
        "are playing",
        "plays",
        "played"
      ],
      "answer": 0,
      "explanation": "Look points to an action happening now. Use are playing.",
      "level": 1,
      "use": "diagnostic",
      "form": "A",
      "pair": 0
    },
    {
      "id": "present-continuous-02",
      "unit": "present-continuous",
      "skill": "tense",
      "prompt": "Be quiet! The baby ___ now.",
      "options": [
        "is sleeping",
        "sleep",
        "slept"
      ],
      "answer": 0,
      "explanation": "Now needs is sleeping for this ongoing action.",
      "level": 1,
      "use": "diagnostic",
      "form": "B",
      "pair": 0
    },
    {
      "id": "present-continuous-03",
      "unit": "present-continuous",
      "skill": "tense",
      "prompt": "At the moment, we ___ a test.",
      "options": [
        "writes",
        "are writing",
        "wrote"
      ],
      "answer": 1,
      "explanation": "At the moment describes an ongoing action: are writing.",
      "level": 2,
      "use": "diagnostic",
      "form": "A",
      "pair": 1
    },
    {
      "id": "present-continuous-04",
      "unit": "present-continuous",
      "skill": "tense",
      "prompt": "Listen! Someone ___ the piano.",
      "options": [
        "is playing",
        "played",
        "plays"
      ],
      "answer": 0,
      "explanation": "Listen points to what is happening now: is playing.",
      "level": 2,
      "use": "diagnostic",
      "form": "B",
      "pair": 1
    },
    {
      "id": "present-continuous-05",
      "unit": "present-continuous",
      "skill": "tense",
      "prompt": "Hurry up! The bus ___ right now.",
      "options": [
        "left",
        "leave",
        "is leaving"
      ],
      "answer": 2,
      "explanation": "Right now refers to an action in progress: is leaving.",
      "level": 3,
      "use": "diagnostic",
      "form": "A",
      "pair": 2
    },
    {
      "id": "present-continuous-06",
      "unit": "present-continuous",
      "skill": "tense",
      "prompt": "Look at Aida! She ___ a picture.",
      "options": [
        "drew",
        "is drawing",
        "draw"
      ],
      "answer": 1,
      "explanation": "The action is happening in front of us: is drawing.",
      "level": 3,
      "use": "diagnostic",
      "form": "B",
      "pair": 2
    },
    {
      "id": "present-continuous-07",
      "unit": "present-continuous",
      "skill": "tense",
      "prompt": "I ___ my homework right now.",
      "options": [
        "am doing",
        "doing",
        "did"
      ],
      "answer": 0,
      "explanation": "Use am with I, followed by doing.",
      "level": 1,
      "use": "practice",
      "form": null,
      "pair": null
    },
    {
      "id": "present-continuous-08",
      "unit": "present-continuous",
      "skill": "tense",
      "prompt": "The children ___ a snowman at the moment.",
      "options": [
        "making",
        "made",
        "are making"
      ],
      "answer": 2,
      "explanation": "The children is plural. Use are making.",
      "level": 2,
      "use": "practice",
      "form": null,
      "pair": null
    },
    {
      "id": "present-continuous-09",
      "unit": "present-continuous",
      "skill": "tense",
      "prompt": "Please wait. I ___ to the teacher now.",
      "options": [
        "am talking",
        "talking",
        "talked"
      ],
      "answer": 0,
      "explanation": "Now identifies the ongoing action: am talking.",
      "level": 2,
      "use": "practice",
      "form": null,
      "pair": null
    },
    {
      "id": "present-continuous-10",
      "unit": "present-continuous",
      "skill": "tense",
      "prompt": "Where is Mum? She ___ dinner in the kitchen now.",
      "options": [
        "cooked",
        "cooking",
        "is cooking"
      ],
      "answer": 2,
      "explanation": "For the action she is doing now, use is cooking.",
      "level": 3,
      "use": "practice",
      "form": null,
      "pair": null
    },
    {
      "id": "past-continuous-01",
      "unit": "past-continuous",
      "skill": "tense",
      "prompt": "At five yesterday, they ___ football.",
      "options": [
        "were playing",
        "play",
        "are playing"
      ],
      "answer": 0,
      "explanation": "At a specific past moment, use were playing.",
      "level": 1,
      "use": "diagnostic",
      "form": "A",
      "pair": 0
    },
    {
      "id": "past-continuous-02",
      "unit": "past-continuous",
      "skill": "tense",
      "prompt": "At eight last night, she ___ dinner.",
      "options": [
        "cooks",
        "is cooking",
        "was cooking"
      ],
      "answer": 2,
      "explanation": "At a past moment, use was cooking with she.",
      "level": 1,
      "use": "diagnostic",
      "form": "B",
      "pair": 0
    },
    {
      "id": "past-continuous-03",
      "unit": "past-continuous",
      "skill": "tense",
      "prompt": "When the phone rang, I ___ a shower.",
      "options": [
        "am taking",
        "take",
        "was taking"
      ],
      "answer": 2,
      "explanation": "The shower was in progress when the phone rang.",
      "level": 2,
      "use": "diagnostic",
      "form": "A",
      "pair": 1
    },
    {
      "id": "past-continuous-04",
      "unit": "past-continuous",
      "skill": "tense",
      "prompt": "He ___ his homework when the lights went out.",
      "options": [
        "was doing",
        "does",
        "is doing"
      ],
      "answer": 0,
      "explanation": "The homework was in progress when the lights went out.",
      "level": 2,
      "use": "diagnostic",
      "form": "B",
      "pair": 1
    },
    {
      "id": "past-continuous-05",
      "unit": "past-continuous",
      "skill": "tense",
      "prompt": "While I was reading, my brother ___ TV.",
      "options": [
        "watches",
        "is watching",
        "was watching"
      ],
      "answer": 2,
      "explanation": "Two ongoing past actions can use the past continuous.",
      "level": 3,
      "use": "diagnostic",
      "form": "A",
      "pair": 2
    },
    {
      "id": "past-continuous-06",
      "unit": "past-continuous",
      "skill": "tense",
      "prompt": "While Mum was cooking, we ___ the table.",
      "options": [
        "are setting",
        "were setting",
        "set every day"
      ],
      "answer": 1,
      "explanation": "The actions were happening together in the past. Use were setting.",
      "level": 3,
      "use": "diagnostic",
      "form": "B",
      "pair": 2
    },
    {
      "id": "past-continuous-07",
      "unit": "past-continuous",
      "skill": "tense",
      "prompt": "At ten yesterday morning, I ___ in the library.",
      "options": [
        "was studying",
        "study",
        "am studying"
      ],
      "answer": 0,
      "explanation": "Use was studying for an action in progress at that past time.",
      "level": 1,
      "use": "practice",
      "form": null,
      "pair": null
    },
    {
      "id": "past-continuous-08",
      "unit": "past-continuous",
      "skill": "tense",
      "prompt": "They ___ home when it started to rain.",
      "options": [
        "walk every day",
        "were walking",
        "are walking"
      ],
      "answer": 1,
      "explanation": "The walk was in progress when the rain started.",
      "level": 2,
      "use": "practice",
      "form": null,
      "pair": null
    },
    {
      "id": "past-continuous-09",
      "unit": "past-continuous",
      "skill": "tense",
      "prompt": "She ___ music when the doorbell rang.",
      "options": [
        "listens to",
        "was listening to",
        "is listening to"
      ],
      "answer": 1,
      "explanation": "The listening was in progress at the time of the doorbell.",
      "level": 2,
      "use": "practice",
      "form": null,
      "pair": null
    },
    {
      "id": "past-continuous-10",
      "unit": "past-continuous",
      "skill": "tense",
      "prompt": "We ___ on the bus at this time yesterday.",
      "options": [
        "were sitting",
        "are sitting",
        "sit"
      ],
      "answer": 0,
      "explanation": "At this time yesterday calls for the past continuous.",
      "level": 3,
      "use": "practice",
      "form": null,
      "pair": null
    },
    {
      "id": "present-perfect-01",
      "unit": "present-perfect",
      "skill": "tense",
      "prompt": "She has never ___ to London.",
      "options": [
        "been",
        "go",
        "was"
      ],
      "answer": 0,
      "explanation": "Has needs the past participle been.",
      "level": 1,
      "use": "diagnostic",
      "form": "A",
      "pair": 0
    },
    {
      "id": "present-perfect-02",
      "unit": "present-perfect",
      "skill": "tense",
      "prompt": "I have already ___ this film.",
      "options": [
        "see",
        "seen",
        "saw"
      ],
      "answer": 1,
      "explanation": "Have needs the past participle seen.",
      "level": 1,
      "use": "diagnostic",
      "form": "B",
      "pair": 0
    },
    {
      "id": "present-perfect-03",
      "unit": "present-perfect",
      "skill": "tense",
      "prompt": "We have just ___ the project.",
      "options": [
        "finishing",
        "finish",
        "finished"
      ],
      "answer": 2,
      "explanation": "Use have + past participle: finished.",
      "level": 2,
      "use": "diagnostic",
      "form": "A",
      "pair": 1
    },
    {
      "id": "present-perfect-04",
      "unit": "present-perfect",
      "skill": "tense",
      "prompt": "They have not ___ their homework yet.",
      "options": [
        "do",
        "done",
        "did"
      ],
      "answer": 1,
      "explanation": "Have not needs the past participle done.",
      "level": 2,
      "use": "diagnostic",
      "form": "B",
      "pair": 1
    },
    {
      "id": "present-perfect-05",
      "unit": "present-perfect",
      "skill": "tense",
      "prompt": "He has just ___ home.",
      "options": [
        "come",
        "came",
        "coming"
      ],
      "answer": 0,
      "explanation": "The past participle of come is also come.",
      "level": 3,
      "use": "diagnostic",
      "form": "A",
      "pair": 2
    },
    {
      "id": "present-perfect-06",
      "unit": "present-perfect",
      "skill": "tense",
      "prompt": "She has already ___ the email.",
      "options": [
        "send",
        "sent",
        "sending"
      ],
      "answer": 1,
      "explanation": "Has needs the past participle sent.",
      "level": 3,
      "use": "diagnostic",
      "form": "B",
      "pair": 2
    },
    {
      "id": "present-perfect-07",
      "unit": "present-perfect",
      "skill": "tense",
      "prompt": "Have you ever ___ a horse?",
      "options": [
        "ride",
        "ridden",
        "rode"
      ],
      "answer": 1,
      "explanation": "The past participle of ride is ridden.",
      "level": 1,
      "use": "practice",
      "form": null,
      "pair": null
    },
    {
      "id": "present-perfect-08",
      "unit": "present-perfect",
      "skill": "tense",
      "prompt": "We have never ___ this game before.",
      "options": [
        "played",
        "playing",
        "play"
      ],
      "answer": 0,
      "explanation": "Have never is followed by the past participle played.",
      "level": 2,
      "use": "practice",
      "form": null,
      "pair": null
    },
    {
      "id": "present-perfect-09",
      "unit": "present-perfect",
      "skill": "tense",
      "prompt": "I have just ___ my keys.",
      "options": [
        "found",
        "finding",
        "find"
      ],
      "answer": 0,
      "explanation": "The past participle of find is found.",
      "level": 2,
      "use": "practice",
      "form": null,
      "pair": null
    },
    {
      "id": "present-perfect-10",
      "unit": "present-perfect",
      "skill": "tense",
      "prompt": "My brother has ___ his phone.",
      "options": [
        "lose",
        "lost",
        "losing"
      ],
      "answer": 1,
      "explanation": "Has needs the past participle lost.",
      "level": 3,
      "use": "practice",
      "form": null,
      "pair": null
    },
    {
      "id": "make-do-01",
      "unit": "make-do",
      "skill": "vocab",
      "prompt": "I need to ___ my homework.",
      "options": [
        "do",
        "make",
        "take"
      ],
      "answer": 0,
      "explanation": "The fixed combination is do homework.",
      "level": 1,
      "use": "diagnostic",
      "form": "A",
      "pair": 0
    },
    {
      "id": "make-do-02",
      "unit": "make-do",
      "skill": "vocab",
      "prompt": "Please ___ your homework before dinner.",
      "options": [
        "make",
        "give",
        "do"
      ],
      "answer": 2,
      "explanation": "Use do with homework.",
      "level": 1,
      "use": "diagnostic",
      "form": "B",
      "pair": 0
    },
    {
      "id": "make-do-03",
      "unit": "make-do",
      "skill": "vocab",
      "prompt": "We must ___ a decision today.",
      "options": [
        "make",
        "get",
        "do"
      ],
      "answer": 0,
      "explanation": "The standard combination here is make a decision.",
      "level": 2,
      "use": "diagnostic",
      "form": "A",
      "pair": 1
    },
    {
      "id": "make-do-04",
      "unit": "make-do",
      "skill": "vocab",
      "prompt": "Try not to ___ a mistake.",
      "options": [
        "make",
        "do",
        "give"
      ],
      "answer": 0,
      "explanation": "Use make with a mistake.",
      "level": 2,
      "use": "diagnostic",
      "form": "B",
      "pair": 1
    },
    {
      "id": "make-do-05",
      "unit": "make-do",
      "skill": "vocab",
      "prompt": "I want to ___ friends at my new school.",
      "options": [
        "do",
        "make",
        "take"
      ],
      "answer": 1,
      "explanation": "Make friends means form friendships.",
      "level": 3,
      "use": "diagnostic",
      "form": "A",
      "pair": 2
    },
    {
      "id": "make-do-06",
      "unit": "make-do",
      "skill": "vocab",
      "prompt": "Please ___ your bed before school.",
      "options": [
        "make",
        "do",
        "take"
      ],
      "answer": 0,
      "explanation": "Make your bed means arrange the bedding neatly.",
      "level": 3,
      "use": "diagnostic",
      "form": "B",
      "pair": 2
    },
    {
      "id": "make-do-07",
      "unit": "make-do",
      "skill": "vocab",
      "prompt": "Always ___ your best.",
      "options": [
        "do",
        "make",
        "take"
      ],
      "answer": 0,
      "explanation": "The fixed phrase is do your best.",
      "level": 1,
      "use": "practice",
      "form": null,
      "pair": null
    },
    {
      "id": "make-do-08",
      "unit": "make-do",
      "skill": "vocab",
      "prompt": "We need to ___ a plan.",
      "options": [
        "do",
        "give",
        "make"
      ],
      "answer": 2,
      "explanation": "Use make a plan.",
      "level": 2,
      "use": "practice",
      "form": null,
      "pair": null
    },
    {
      "id": "make-do-09",
      "unit": "make-do",
      "skill": "vocab",
      "prompt": "It is your turn to ___ the washing-up.",
      "options": [
        "take",
        "do",
        "make"
      ],
      "answer": 1,
      "explanation": "The fixed phrase is do the washing-up.",
      "level": 2,
      "use": "practice",
      "form": null,
      "pair": null
    },
    {
      "id": "make-do-10",
      "unit": "make-do",
      "skill": "vocab",
      "prompt": "Please do not ___ so much noise.",
      "options": [
        "make",
        "take",
        "do"
      ],
      "answer": 0,
      "explanation": "The fixed combination is make noise.",
      "level": 3,
      "use": "practice",
      "form": null,
      "pair": null
    },
    {
      "id": "take-get-01",
      "unit": "take-get",
      "skill": "vocab",
      "prompt": "Can you ___ a photo of us?",
      "options": [
        "do",
        "give",
        "take"
      ],
      "answer": 2,
      "explanation": "The fixed phrase is take a photo.",
      "level": 1,
      "use": "diagnostic",
      "form": "A",
      "pair": 0
    },
    {
      "id": "take-get-02",
      "unit": "take-get",
      "skill": "vocab",
      "prompt": "Please ___ a photo of the team.",
      "options": [
        "do",
        "take",
        "give"
      ],
      "answer": 1,
      "explanation": "Use take with a photo.",
      "level": 1,
      "use": "diagnostic",
      "form": "B",
      "pair": 0
    },
    {
      "id": "take-get-03",
      "unit": "take-get",
      "skill": "vocab",
      "prompt": "Let us ___ a break now.",
      "options": [
        "make",
        "do",
        "take"
      ],
      "answer": 2,
      "explanation": "The fixed phrase is take a break.",
      "level": 2,
      "use": "diagnostic",
      "form": "A",
      "pair": 1
    },
    {
      "id": "take-get-04",
      "unit": "take-get",
      "skill": "vocab",
      "prompt": "You should ___ notes during the lesson.",
      "options": [
        "say",
        "do",
        "take"
      ],
      "answer": 2,
      "explanation": "Take notes means write down the main points.",
      "level": 2,
      "use": "diagnostic",
      "form": "B",
      "pair": 1
    },
    {
      "id": "take-get-05",
      "unit": "take-get",
      "skill": "vocab",
      "prompt": "Our class will ___ part in the festival.",
      "options": [
        "take",
        "do",
        "make"
      ],
      "answer": 0,
      "explanation": "The fixed phrase is take part in.",
      "level": 3,
      "use": "diagnostic",
      "form": "A",
      "pair": 2
    },
    {
      "id": "take-get-06",
      "unit": "take-get",
      "skill": "vocab",
      "prompt": "You should ___ enough sleep before a test.",
      "options": [
        "do",
        "make",
        "get"
      ],
      "answer": 2,
      "explanation": "Use get enough sleep.",
      "level": 3,
      "use": "diagnostic",
      "form": "B",
      "pair": 2
    },
    {
      "id": "take-get-07",
      "unit": "take-get",
      "skill": "vocab",
      "prompt": "We ___ the bus to school every day.",
      "options": [
        "take",
        "do",
        "make"
      ],
      "answer": 0,
      "explanation": "Take the bus means travel on it.",
      "level": 1,
      "use": "practice",
      "form": null,
      "pair": null
    },
    {
      "id": "take-get-08",
      "unit": "take-get",
      "skill": "vocab",
      "prompt": "It is cold. I might ___ a cold.",
      "options": [
        "make",
        "do",
        "get"
      ],
      "answer": 2,
      "explanation": "Get a cold means become ill with a cold.",
      "level": 2,
      "use": "practice",
      "form": null,
      "pair": null
    },
    {
      "id": "take-get-09",
      "unit": "take-get",
      "skill": "vocab",
      "prompt": "After the long trip, we need to ___ some rest.",
      "options": [
        "make",
        "do",
        "get"
      ],
      "answer": 2,
      "explanation": "The fixed phrase is get some rest.",
      "level": 2,
      "use": "practice",
      "form": null,
      "pair": null
    },
    {
      "id": "take-get-10",
      "unit": "take-get",
      "skill": "vocab",
      "prompt": "Please ___ a seat while you wait.",
      "options": [
        "do",
        "take",
        "make"
      ],
      "answer": 1,
      "explanation": "Take a seat is a polite way to ask someone to sit down.",
      "level": 3,
      "use": "practice",
      "form": null,
      "pair": null
    },
    {
      "id": "communication-01",
      "unit": "communication",
      "skill": "vocab",
      "prompt": "Please ___ the truth.",
      "options": [
        "say",
        "speak",
        "tell"
      ],
      "answer": 2,
      "explanation": "The fixed phrase is tell the truth.",
      "level": 1,
      "use": "diagnostic",
      "form": "A",
      "pair": 0
    },
    {
      "id": "communication-02",
      "unit": "communication",
      "skill": "vocab",
      "prompt": "I would like to ___ a question.",
      "options": [
        "ask",
        "say",
        "tell"
      ],
      "answer": 0,
      "explanation": "Use ask with a question.",
      "level": 1,
      "use": "diagnostic",
      "form": "B",
      "pair": 0
    },
    {
      "id": "communication-03",
      "unit": "communication",
      "skill": "vocab",
      "prompt": "Could you ___ me some advice?",
      "options": [
        "give",
        "tell",
        "say"
      ],
      "answer": 0,
      "explanation": "The fixed phrase is give someone advice.",
      "level": 2,
      "use": "diagnostic",
      "form": "A",
      "pair": 1
    },
    {
      "id": "communication-04",
      "unit": "communication",
      "skill": "vocab",
      "prompt": "I need to ___ an email to my teacher.",
      "options": [
        "say",
        "tell",
        "send"
      ],
      "answer": 2,
      "explanation": "Use send with an email.",
      "level": 2,
      "use": "diagnostic",
      "form": "B",
      "pair": 1
    },
    {
      "id": "communication-05",
      "unit": "communication",
      "skill": "vocab",
      "prompt": "Please ___ attention to the instructions.",
      "options": [
        "pay",
        "do",
        "make"
      ],
      "answer": 0,
      "explanation": "The fixed phrase is pay attention to.",
      "level": 3,
      "use": "diagnostic",
      "form": "A",
      "pair": 2
    },
    {
      "id": "communication-06",
      "unit": "communication",
      "skill": "vocab",
      "prompt": "It is important to ___ a promise.",
      "options": [
        "take",
        "do",
        "keep"
      ],
      "answer": 2,
      "explanation": "Keep a promise means do what you promised.",
      "level": 3,
      "use": "diagnostic",
      "form": "B",
      "pair": 2
    },
    {
      "id": "communication-07",
      "unit": "communication",
      "skill": "vocab",
      "prompt": "Can you ___ me a hand with this box?",
      "options": [
        "give",
        "make",
        "do"
      ],
      "answer": 0,
      "explanation": "Give someone a hand means help them.",
      "level": 1,
      "use": "practice",
      "form": null,
      "pair": null
    },
    {
      "id": "communication-08",
      "unit": "communication",
      "skill": "vocab",
      "prompt": "Can you ___ me the way to the station?",
      "options": [
        "show",
        "speak",
        "say"
      ],
      "answer": 0,
      "explanation": "Use show someone the way.",
      "level": 2,
      "use": "practice",
      "form": null,
      "pair": null
    },
    {
      "id": "communication-09",
      "unit": "communication",
      "skill": "vocab",
      "prompt": "Please ___ me your name.",
      "options": [
        "tell",
        "say",
        "speak"
      ],
      "answer": 0,
      "explanation": "Tell can be followed by a person directly: tell me.",
      "level": 2,
      "use": "practice",
      "form": null,
      "pair": null
    },
    {
      "id": "communication-10",
      "unit": "communication",
      "skill": "vocab",
      "prompt": "We need to ___ this problem together.",
      "options": [
        "say",
        "discuss",
        "speak"
      ],
      "answer": 1,
      "explanation": "Discuss takes the topic directly: discuss this problem.",
      "level": 3,
      "use": "practice",
      "form": null,
      "pair": null
    },
    {
      "id": "daily-collocations-01",
      "unit": "daily-collocations",
      "skill": "vocab",
      "prompt": "Can you ___ this maths problem?",
      "options": [
        "solve",
        "build",
        "invent"
      ],
      "answer": 0,
      "explanation": "Use solve with a problem.",
      "level": 1,
      "use": "diagnostic",
      "form": "A",
      "pair": 0
    },
    {
      "id": "daily-collocations-02",
      "unit": "daily-collocations",
      "skill": "vocab",
      "prompt": "Please ___ the rules of the game.",
      "options": [
        "listen",
        "speak",
        "follow"
      ],
      "answer": 2,
      "explanation": "Follow the rules means act according to them.",
      "level": 1,
      "use": "diagnostic",
      "form": "B",
      "pair": 0
    },
    {
      "id": "daily-collocations-03",
      "unit": "daily-collocations",
      "skill": "vocab",
      "prompt": "Our team hopes to ___ the match.",
      "options": [
        "beat",
        "win",
        "earn"
      ],
      "answer": 1,
      "explanation": "Win a match; beat an opponent.",
      "level": 2,
      "use": "diagnostic",
      "form": "A",
      "pair": 1
    },
    {
      "id": "daily-collocations-04",
      "unit": "daily-collocations",
      "skill": "vocab",
      "prompt": "My brother wants to ___ a swimming record.",
      "options": [
        "take",
        "break",
        "do"
      ],
      "answer": 1,
      "explanation": "The fixed phrase is break a record.",
      "level": 2,
      "use": "diagnostic",
      "form": "B",
      "pair": 1
    },
    {
      "id": "daily-collocations-05",
      "unit": "daily-collocations",
      "skill": "vocab",
      "prompt": "Switch off unused lights to ___ energy.",
      "options": [
        "earn",
        "lend",
        "save"
      ],
      "answer": 2,
      "explanation": "Save energy means avoid wasting it.",
      "level": 3,
      "use": "diagnostic",
      "form": "A",
      "pair": 2
    },
    {
      "id": "daily-collocations-06",
      "unit": "daily-collocations",
      "skill": "vocab",
      "prompt": "We must ___ the environment from pollution.",
      "options": [
        "solve",
        "protect",
        "recycle"
      ],
      "answer": 1,
      "explanation": "Protect the environment means keep it safe from harm.",
      "level": 3,
      "use": "diagnostic",
      "form": "B",
      "pair": 2
    },
    {
      "id": "daily-collocations-07",
      "unit": "daily-collocations",
      "skill": "vocab",
      "prompt": "I put some money aside each week to ___ for a bicycle.",
      "options": [
        "save",
        "borrow",
        "lend"
      ],
      "answer": 0,
      "explanation": "Putting money aside means saving it.",
      "level": 1,
      "use": "practice",
      "form": null,
      "pair": null
    },
    {
      "id": "daily-collocations-08",
      "unit": "daily-collocations",
      "skill": "vocab",
      "prompt": "I need to ___ a dictionary to check this word.",
      "options": [
        "use",
        "do",
        "make"
      ],
      "answer": 0,
      "explanation": "Use a dictionary means look up information in it.",
      "level": 2,
      "use": "practice",
      "form": null,
      "pair": null
    },
    {
      "id": "daily-collocations-09",
      "unit": "daily-collocations",
      "skill": "vocab",
      "prompt": "Please ___ your seat belt.",
      "options": [
        "fasten",
        "fold",
        "make"
      ],
      "answer": 0,
      "explanation": "The fixed phrase is fasten your seat belt.",
      "level": 2,
      "use": "practice",
      "form": null,
      "pair": null
    },
    {
      "id": "daily-collocations-10",
      "unit": "daily-collocations",
      "skill": "vocab",
      "prompt": "I want to ___ my pronunciation.",
      "options": [
        "grow",
        "improve",
        "raise"
      ],
      "answer": 1,
      "explanation": "Use improve with pronunciation.",
      "level": 3,
      "use": "practice",
      "form": null,
      "pair": null
    },
    {
      "id": "time-prepositions-01",
      "unit": "time-prepositions",
      "skill": "prep",
      "prompt": "The lesson begins ___ nine o’clock.",
      "options": [
        "in",
        "at",
        "on"
      ],
      "answer": 1,
      "explanation": "Use at with a clock time.",
      "level": 1,
      "use": "diagnostic",
      "form": "A",
      "pair": 0
    },
    {
      "id": "time-prepositions-02",
      "unit": "time-prepositions",
      "skill": "prep",
      "prompt": "The film begins ___ six o’clock.",
      "options": [
        "in",
        "at",
        "on"
      ],
      "answer": 1,
      "explanation": "Use at with a clock time.",
      "level": 1,
      "use": "diagnostic",
      "form": "B",
      "pair": 0
    },
    {
      "id": "time-prepositions-03",
      "unit": "time-prepositions",
      "skill": "prep",
      "prompt": "Our club meets ___ Monday.",
      "options": [
        "at",
        "on",
        "in"
      ],
      "answer": 1,
      "explanation": "Use on with a day of the week.",
      "level": 2,
      "use": "diagnostic",
      "form": "A",
      "pair": 1
    },
    {
      "id": "time-prepositions-04",
      "unit": "time-prepositions",
      "skill": "prep",
      "prompt": "The concert is ___ Friday evening.",
      "options": [
        "in",
        "on",
        "at"
      ],
      "answer": 1,
      "explanation": "Use on with a particular day or its evening.",
      "level": 2,
      "use": "diagnostic",
      "form": "B",
      "pair": 1
    },
    {
      "id": "time-prepositions-05",
      "unit": "time-prepositions",
      "skill": "prep",
      "prompt": "My birthday is ___ May.",
      "options": [
        "at",
        "in",
        "on"
      ],
      "answer": 1,
      "explanation": "Use in with a month.",
      "level": 3,
      "use": "diagnostic",
      "form": "A",
      "pair": 2
    },
    {
      "id": "time-prepositions-06",
      "unit": "time-prepositions",
      "skill": "prep",
      "prompt": "We moved here ___ 2021.",
      "options": [
        "on",
        "at",
        "in"
      ],
      "answer": 2,
      "explanation": "Use in with a year.",
      "level": 3,
      "use": "diagnostic",
      "form": "B",
      "pair": 2
    },
    {
      "id": "time-prepositions-07",
      "unit": "time-prepositions",
      "skill": "prep",
      "prompt": "I do homework ___ the evening.",
      "options": [
        "in",
        "on",
        "at"
      ],
      "answer": 0,
      "explanation": "The fixed time phrase is in the evening.",
      "level": 1,
      "use": "practice",
      "form": null,
      "pair": null
    },
    {
      "id": "time-prepositions-08",
      "unit": "time-prepositions",
      "skill": "prep",
      "prompt": "The stars are bright ___ night.",
      "options": [
        "on",
        "in",
        "at"
      ],
      "answer": 2,
      "explanation": "The fixed time phrase is at night.",
      "level": 2,
      "use": "practice",
      "form": null,
      "pair": null
    },
    {
      "id": "time-prepositions-09",
      "unit": "time-prepositions",
      "skill": "prep",
      "prompt": "The event is ___ 15 April.",
      "options": [
        "at",
        "on",
        "in"
      ],
      "answer": 1,
      "explanation": "Use on with a full date.",
      "level": 2,
      "use": "practice",
      "form": null,
      "pair": null
    },
    {
      "id": "time-prepositions-10",
      "unit": "time-prepositions",
      "skill": "prep",
      "prompt": "School starts ___ September.",
      "options": [
        "in",
        "on",
        "at"
      ],
      "answer": 0,
      "explanation": "Use in with a month.",
      "level": 3,
      "use": "practice",
      "form": null,
      "pair": null
    },
    {
      "id": "place-movement-01",
      "unit": "place-movement",
      "skill": "prep",
      "prompt": "The books are ___ my schoolbag.",
      "options": [
        "between",
        "during",
        "in"
      ],
      "answer": 2,
      "explanation": "A schoolbag contains the books. Use in.",
      "level": 1,
      "use": "diagnostic",
      "form": "A",
      "pair": 0
    },
    {
      "id": "place-movement-02",
      "unit": "place-movement",
      "skill": "prep",
      "prompt": "There is a picture ___ the wall.",
      "options": [
        "on",
        "during",
        "between"
      ],
      "answer": 0,
      "explanation": "A picture is on the surface of the wall.",
      "level": 1,
      "use": "diagnostic",
      "form": "B",
      "pair": 0
    },
    {
      "id": "place-movement-03",
      "unit": "place-movement",
      "skill": "prep",
      "prompt": "We arrived ___ the airport early.",
      "options": [
        "to",
        "at",
        "on"
      ],
      "answer": 1,
      "explanation": "Use arrive at with a specific place such as an airport.",
      "level": 2,
      "use": "diagnostic",
      "form": "A",
      "pair": 1
    },
    {
      "id": "place-movement-04",
      "unit": "place-movement",
      "skill": "prep",
      "prompt": "We arrived ___ Kazakhstan yesterday.",
      "options": [
        "on",
        "in",
        "at"
      ],
      "answer": 1,
      "explanation": "Use arrive in with a country or city.",
      "level": 2,
      "use": "diagnostic",
      "form": "B",
      "pair": 1
    },
    {
      "id": "place-movement-05",
      "unit": "place-movement",
      "skill": "prep",
      "prompt": "We walked ___ the bridge to reach the other side.",
      "options": [
        "across",
        "between",
        "during"
      ],
      "answer": 0,
      "explanation": "Across means from one side to the other.",
      "level": 3,
      "use": "diagnostic",
      "form": "A",
      "pair": 2
    },
    {
      "id": "place-movement-06",
      "unit": "place-movement",
      "skill": "prep",
      "prompt": "He divided the cake ___ four equal pieces.",
      "options": [
        "at",
        "onto",
        "into"
      ],
      "answer": 2,
      "explanation": "Use divide into for the resulting parts.",
      "level": 3,
      "use": "diagnostic",
      "form": "B",
      "pair": 2
    },
    {
      "id": "place-movement-07",
      "unit": "place-movement",
      "skill": "prep",
      "prompt": "We travelled ___ train.",
      "options": [
        "at",
        "by",
        "from"
      ],
      "answer": 1,
      "explanation": "By train describes the means of transport.",
      "level": 1,
      "use": "practice",
      "form": null,
      "pair": null
    },
    {
      "id": "place-movement-08",
      "unit": "place-movement",
      "skill": "prep",
      "prompt": "He goes to school ___ foot.",
      "options": [
        "on",
        "in",
        "by"
      ],
      "answer": 0,
      "explanation": "The fixed phrase is on foot.",
      "level": 2,
      "use": "practice",
      "form": null,
      "pair": null
    },
    {
      "id": "place-movement-09",
      "unit": "place-movement",
      "skill": "prep",
      "prompt": "She walked from the library ___ the station.",
      "options": [
        "at",
        "to",
        "during"
      ],
      "answer": 1,
      "explanation": "Use from one place to another.",
      "level": 2,
      "use": "practice",
      "form": null,
      "pair": null
    },
    {
      "id": "place-movement-10",
      "unit": "place-movement",
      "skill": "prep",
      "prompt": "The shop is ___ the bank and the café.",
      "options": [
        "during",
        "until",
        "between"
      ],
      "answer": 2,
      "explanation": "Use between with the two places linked by and.",
      "level": 3,
      "use": "practice",
      "form": null,
      "pair": null
    },
    {
      "id": "fixed-prepositions-01",
      "unit": "fixed-prepositions",
      "skill": "prep",
      "prompt": "She is good ___ maths.",
      "options": [
        "in",
        "at",
        "on"
      ],
      "answer": 1,
      "explanation": "The fixed phrase is good at.",
      "level": 1,
      "use": "diagnostic",
      "form": "A",
      "pair": 0
    },
    {
      "id": "fixed-prepositions-02",
      "unit": "fixed-prepositions",
      "skill": "prep",
      "prompt": "I am interested ___ science.",
      "options": [
        "on",
        "in",
        "at"
      ],
      "answer": 1,
      "explanation": "The fixed phrase is interested in.",
      "level": 1,
      "use": "diagnostic",
      "form": "B",
      "pair": 0
    },
    {
      "id": "fixed-prepositions-03",
      "unit": "fixed-prepositions",
      "skill": "prep",
      "prompt": "The child is afraid ___ spiders.",
      "options": [
        "of",
        "at",
        "on"
      ],
      "answer": 0,
      "explanation": "The fixed phrase is afraid of.",
      "level": 2,
      "use": "diagnostic",
      "form": "A",
      "pair": 1
    },
    {
      "id": "fixed-prepositions-04",
      "unit": "fixed-prepositions",
      "skill": "prep",
      "prompt": "Please listen ___ the teacher.",
      "options": [
        "on",
        "to",
        "at"
      ],
      "answer": 1,
      "explanation": "The verb listen is followed by to.",
      "level": 2,
      "use": "diagnostic",
      "form": "B",
      "pair": 1
    },
    {
      "id": "fixed-prepositions-05",
      "unit": "fixed-prepositions",
      "skill": "prep",
      "prompt": "We are waiting ___ the bus.",
      "options": [
        "to",
        "on",
        "for"
      ],
      "answer": 2,
      "explanation": "Use wait for when you name the person or thing being waited for.",
      "level": 3,
      "use": "diagnostic",
      "form": "A",
      "pair": 2
    },
    {
      "id": "fixed-prepositions-06",
      "unit": "fixed-prepositions",
      "skill": "prep",
      "prompt": "I agree ___ you.",
      "options": [
        "to",
        "at",
        "with"
      ],
      "answer": 2,
      "explanation": "Use agree with a person.",
      "level": 3,
      "use": "diagnostic",
      "form": "B",
      "pair": 2
    },
    {
      "id": "fixed-prepositions-07",
      "unit": "fixed-prepositions",
      "skill": "prep",
      "prompt": "This book belongs ___ me.",
      "options": [
        "to",
        "for",
        "at"
      ],
      "answer": 0,
      "explanation": "The fixed phrase is belong to.",
      "level": 1,
      "use": "practice",
      "form": null,
      "pair": null
    },
    {
      "id": "fixed-prepositions-08",
      "unit": "fixed-prepositions",
      "skill": "prep",
      "prompt": "Thank you ___ your help.",
      "options": [
        "at",
        "to",
        "for"
      ],
      "answer": 2,
      "explanation": "Use thank you for to name the reason.",
      "level": 2,
      "use": "practice",
      "form": null,
      "pair": null
    },
    {
      "id": "fixed-prepositions-09",
      "unit": "fixed-prepositions",
      "skill": "prep",
      "prompt": "He is worried ___ the test.",
      "options": [
        "at",
        "about",
        "on"
      ],
      "answer": 1,
      "explanation": "The fixed phrase is worried about.",
      "level": 2,
      "use": "practice",
      "form": null,
      "pair": null
    },
    {
      "id": "fixed-prepositions-10",
      "unit": "fixed-prepositions",
      "skill": "prep",
      "prompt": "She is responsible ___ feeding the cat.",
      "options": [
        "for",
        "at",
        "to"
      ],
      "answer": 0,
      "explanation": "The fixed phrase is responsible for.",
      "level": 3,
      "use": "practice",
      "form": null,
      "pair": null
    },
    {
      "id": "for-since-01",
      "unit": "for-since",
      "skill": "prep",
      "prompt": "I have lived here ___ three years.",
      "options": [
        "for",
        "at",
        "since"
      ],
      "answer": 0,
      "explanation": "Three years is a duration, so use for.",
      "level": 1,
      "use": "diagnostic",
      "form": "A",
      "pair": 0
    },
    {
      "id": "for-since-02",
      "unit": "for-since",
      "skill": "prep",
      "prompt": "She has lived here ___ 2020.",
      "options": [
        "since",
        "during",
        "for"
      ],
      "answer": 0,
      "explanation": "2020 is a starting point, so use since.",
      "level": 1,
      "use": "diagnostic",
      "form": "B",
      "pair": 0
    },
    {
      "id": "for-since-03",
      "unit": "for-since",
      "skill": "prep",
      "prompt": "We have waited ___ twenty minutes.",
      "options": [
        "since",
        "in",
        "for"
      ],
      "answer": 2,
      "explanation": "Twenty minutes is a length of time. Use for.",
      "level": 2,
      "use": "diagnostic",
      "form": "A",
      "pair": 1
    },
    {
      "id": "for-since-04",
      "unit": "for-since",
      "skill": "prep",
      "prompt": "He has been ill ___ Monday.",
      "options": [
        "since",
        "for",
        "at"
      ],
      "answer": 0,
      "explanation": "Monday identifies when the illness started. Use since.",
      "level": 2,
      "use": "diagnostic",
      "form": "B",
      "pair": 1
    },
    {
      "id": "for-since-05",
      "unit": "for-since",
      "skill": "prep",
      "prompt": "They have known each other ___ a long time.",
      "options": [
        "since",
        "on",
        "for"
      ],
      "answer": 2,
      "explanation": "A long time is a duration. Use for.",
      "level": 3,
      "use": "diagnostic",
      "form": "A",
      "pair": 2
    },
    {
      "id": "for-since-06",
      "unit": "for-since",
      "skill": "prep",
      "prompt": "I have not seen her ___ last summer.",
      "options": [
        "for",
        "since",
        "during"
      ],
      "answer": 1,
      "explanation": "Last summer is a starting point. Use since.",
      "level": 3,
      "use": "diagnostic",
      "form": "B",
      "pair": 2
    },
    {
      "id": "for-since-07",
      "unit": "for-since",
      "skill": "prep",
      "prompt": "We have studied English ___ two years.",
      "options": [
        "for",
        "at",
        "since"
      ],
      "answer": 0,
      "explanation": "Use for with a duration: two years.",
      "level": 1,
      "use": "practice",
      "form": null,
      "pair": null
    },
    {
      "id": "for-since-08",
      "unit": "for-since",
      "skill": "prep",
      "prompt": "She has worked here ___ January.",
      "options": [
        "since",
        "on",
        "for"
      ],
      "answer": 0,
      "explanation": "January is the starting point. Use since.",
      "level": 2,
      "use": "practice",
      "form": null,
      "pair": null
    },
    {
      "id": "for-since-09",
      "unit": "for-since",
      "skill": "prep",
      "prompt": "He has played the guitar ___ six months.",
      "options": [
        "for",
        "in",
        "since"
      ],
      "answer": 0,
      "explanation": "Six months is a duration. Use for.",
      "level": 2,
      "use": "practice",
      "form": null,
      "pair": null
    },
    {
      "id": "for-since-10",
      "unit": "for-since",
      "skill": "prep",
      "prompt": "I have been awake ___ six o’clock.",
      "options": [
        "since",
        "on",
        "for"
      ],
      "answer": 0,
      "explanation": "Six o’clock is the starting time. Use since.",
      "level": 3,
      "use": "practice",
      "form": null,
      "pair": null
    },
    {
      "id": "statement-order-01",
      "unit": "statement-order",
      "skill": "order",
      "prompt": "Choose the sentence with standard written word order.",
      "options": [
        "She books reads.",
        "Reads books she.",
        "She reads books."
      ],
      "answer": 2,
      "explanation": "The subject she comes before the verb reads, followed by the object books.",
      "level": 1,
      "use": "diagnostic",
      "form": "A",
      "pair": 0
    },
    {
      "id": "statement-order-02",
      "unit": "statement-order",
      "skill": "order",
      "prompt": "Choose the sentence with standard written word order.",
      "options": [
        "Play tennis they.",
        "They tennis play.",
        "They play tennis."
      ],
      "answer": 2,
      "explanation": "Use subject + verb + object: they play tennis.",
      "level": 1,
      "use": "diagnostic",
      "form": "B",
      "pair": 0
    },
    {
      "id": "statement-order-03",
      "unit": "statement-order",
      "skill": "order",
      "prompt": "Choose the sentence with standard written word order.",
      "options": [
        "I a red bicycle have.",
        "I have a bicycle red.",
        "I have a red bicycle."
      ],
      "answer": 2,
      "explanation": "Put red before bicycle and the object after have.",
      "level": 2,
      "use": "diagnostic",
      "form": "A",
      "pair": 1
    },
    {
      "id": "statement-order-04",
      "unit": "statement-order",
      "skill": "order",
      "prompt": "Choose the sentence with standard written word order.",
      "options": [
        "She wearing is a blue jacket.",
        "She is wearing a blue jacket.",
        "She is a blue wearing jacket."
      ],
      "answer": 1,
      "explanation": "Keep is wearing together and put blue before jacket.",
      "level": 2,
      "use": "diagnostic",
      "form": "B",
      "pair": 1
    },
    {
      "id": "statement-order-05",
      "unit": "statement-order",
      "skill": "order",
      "prompt": "Choose the sentence with standard written word order.",
      "options": [
        "The students in are the library.",
        "The students are in the library.",
        "The are students in the library."
      ],
      "answer": 1,
      "explanation": "The whole subject the students comes before are.",
      "level": 3,
      "use": "diagnostic",
      "form": "A",
      "pair": 2
    },
    {
      "id": "statement-order-06",
      "unit": "statement-order",
      "skill": "order",
      "prompt": "Choose the sentence with standard written word order.",
      "options": [
        "My has friend a small dog.",
        "My friend has a small dog.",
        "My friend a small dog has."
      ],
      "answer": 1,
      "explanation": "Keep my friend together, followed by has and the object.",
      "level": 3,
      "use": "diagnostic",
      "form": "B",
      "pair": 2
    },
    {
      "id": "statement-order-07",
      "unit": "statement-order",
      "skill": "order",
      "prompt": "Choose the sentence with standard written word order.",
      "options": [
        "We reading enjoy stories.",
        "We enjoy reading stories.",
        "Enjoy stories we reading."
      ],
      "answer": 1,
      "explanation": "Enjoy is followed by reading stories.",
      "level": 1,
      "use": "practice",
      "form": null,
      "pair": null
    },
    {
      "id": "statement-order-08",
      "unit": "statement-order",
      "skill": "order",
      "prompt": "Choose the sentence with standard written word order.",
      "options": [
        "Our explains teacher the rule.",
        "Our teacher the explains rule.",
        "Our teacher explains the rule."
      ],
      "answer": 2,
      "explanation": "Keep the subject our teacher and object the rule together.",
      "level": 2,
      "use": "practice",
      "form": null,
      "pair": null
    },
    {
      "id": "statement-order-09",
      "unit": "statement-order",
      "skill": "order",
      "prompt": "Choose the sentence with standard written word order.",
      "options": [
        "There is in a cat the garden.",
        "There is a cat in the garden.",
        "There a cat is in the garden."
      ],
      "answer": 1,
      "explanation": "Use there is + noun phrase + place.",
      "level": 2,
      "use": "practice",
      "form": null,
      "pair": null
    },
    {
      "id": "statement-order-10",
      "unit": "statement-order",
      "skill": "order",
      "prompt": "Choose the sentence with standard written word order.",
      "options": [
        "Please open your books.",
        "Open books your please.",
        "Please your open books."
      ],
      "answer": 0,
      "explanation": "In this instruction, the verb open comes before your books.",
      "level": 3,
      "use": "practice",
      "form": null,
      "pair": null
    },
    {
      "id": "question-order-01",
      "unit": "question-order",
      "skill": "order",
      "prompt": "Choose the sentence with standard written word order.",
      "options": [
        "Where he does live?",
        "Where does live he?",
        "Where does he live?"
      ],
      "answer": 2,
      "explanation": "Use where + does + he + live.",
      "level": 1,
      "use": "diagnostic",
      "form": "A",
      "pair": 0
    },
    {
      "id": "question-order-02",
      "unit": "question-order",
      "skill": "order",
      "prompt": "Choose the sentence with standard written word order.",
      "options": [
        "When does she study?",
        "When does study she?",
        "When she does study?"
      ],
      "answer": 0,
      "explanation": "Use when + does + she + study.",
      "level": 1,
      "use": "diagnostic",
      "form": "B",
      "pair": 0
    },
    {
      "id": "question-order-03",
      "unit": "question-order",
      "skill": "order",
      "prompt": "Choose the sentence with standard written word order.",
      "options": [
        "They the did watch film?",
        "Did watch they the film?",
        "Did they watch the film?"
      ],
      "answer": 2,
      "explanation": "Put did before they, followed by watch.",
      "level": 2,
      "use": "diagnostic",
      "form": "A",
      "pair": 1
    },
    {
      "id": "question-order-04",
      "unit": "question-order",
      "skill": "order",
      "prompt": "Choose the sentence with standard written word order.",
      "options": [
        "What you did eat for lunch?",
        "What did you eat for lunch?",
        "What did eat you for lunch?"
      ],
      "answer": 1,
      "explanation": "Use what + did + you + eat.",
      "level": 2,
      "use": "diagnostic",
      "form": "B",
      "pair": 1
    },
    {
      "id": "question-order-05",
      "unit": "question-order",
      "skill": "order",
      "prompt": "Choose the sentence with standard written word order.",
      "options": [
        "How many books do you have?",
        "How many do books you have?",
        "How books many do you have?"
      ],
      "answer": 0,
      "explanation": "Keep how many books together before do you have.",
      "level": 3,
      "use": "diagnostic",
      "form": "A",
      "pair": 2
    },
    {
      "id": "question-order-06",
      "unit": "question-order",
      "skill": "order",
      "prompt": "Choose the sentence with standard written word order.",
      "options": [
        "What does time school start?",
        "What time does school start?",
        "What time school does start?"
      ],
      "answer": 1,
      "explanation": "Keep what time together, then does + school + start.",
      "level": 3,
      "use": "diagnostic",
      "form": "B",
      "pair": 2
    },
    {
      "id": "question-order-07",
      "unit": "question-order",
      "skill": "order",
      "prompt": "Choose the sentence with standard written word order.",
      "options": [
        "Why the children are laughing?",
        "Why are the children laughing?",
        "Why laughing are the children?"
      ],
      "answer": 1,
      "explanation": "Use why + are + the children + laughing.",
      "level": 1,
      "use": "practice",
      "form": null,
      "pair": null
    },
    {
      "id": "question-order-08",
      "unit": "question-order",
      "skill": "order",
      "prompt": "Choose the sentence with standard written word order.",
      "options": [
        "Your where schoolbag is?",
        "Where your is schoolbag?",
        "Where is your schoolbag?"
      ],
      "answer": 2,
      "explanation": "Use where + is + your schoolbag.",
      "level": 2,
      "use": "practice",
      "form": null,
      "pair": null
    },
    {
      "id": "question-order-09",
      "unit": "question-order",
      "skill": "order",
      "prompt": "Choose the sentence with standard written word order.",
      "options": [
        "How water much do we need?",
        "How much do water we need?",
        "How much water do we need?"
      ],
      "answer": 2,
      "explanation": "Keep how much water together, then do + we + need.",
      "level": 2,
      "use": "practice",
      "form": null,
      "pair": null
    },
    {
      "id": "question-order-10",
      "unit": "question-order",
      "skill": "order",
      "prompt": "Choose the sentence with standard written word order.",
      "options": [
        "When the lesson will start?",
        "When will the lesson start?",
        "When will start the lesson?"
      ],
      "answer": 1,
      "explanation": "Use when + will + the lesson + start.",
      "level": 3,
      "use": "practice",
      "form": null,
      "pair": null
    },
    {
      "id": "adverb-order-01",
      "unit": "adverb-order",
      "skill": "order",
      "prompt": "Choose the sentence with standard written word order.",
      "options": [
        "I usually walk to school.",
        "I walk to usually school.",
        "I usually to school walk."
      ],
      "answer": 0,
      "explanation": "Usually goes before the main verb walk.",
      "level": 1,
      "use": "diagnostic",
      "form": "A",
      "pair": 0
    },
    {
      "id": "adverb-order-02",
      "unit": "adverb-order",
      "skill": "order",
      "prompt": "Choose the sentence with standard written word order.",
      "options": [
        "He never to bed goes late.",
        "He never goes to bed late.",
        "He goes to never bed late."
      ],
      "answer": 1,
      "explanation": "Never goes before goes; keep to bed together.",
      "level": 1,
      "use": "diagnostic",
      "form": "B",
      "pair": 0
    },
    {
      "id": "adverb-order-03",
      "unit": "adverb-order",
      "skill": "order",
      "prompt": "Choose the sentence with standard written word order.",
      "options": [
        "We often our visit grandparents.",
        "We visit our often grandparents.",
        "We often visit our grandparents."
      ],
      "answer": 2,
      "explanation": "Often comes before visit; do not split our grandparents.",
      "level": 2,
      "use": "diagnostic",
      "form": "A",
      "pair": 1
    },
    {
      "id": "adverb-order-04",
      "unit": "adverb-order",
      "skill": "order",
      "prompt": "Choose the sentence with standard written word order.",
      "options": [
        "She sometimes chess plays.",
        "She plays sometimes chess she.",
        "She sometimes plays chess."
      ],
      "answer": 2,
      "explanation": "Sometimes comes before the main verb plays.",
      "level": 2,
      "use": "diagnostic",
      "form": "B",
      "pair": 1
    },
    {
      "id": "adverb-order-05",
      "unit": "adverb-order",
      "skill": "order",
      "prompt": "Choose the sentence with standard written word order.",
      "options": [
        "She friendly is always.",
        "She is always friendly.",
        "She always friendly is."
      ],
      "answer": 1,
      "explanation": "With be, put always after is and before friendly.",
      "level": 3,
      "use": "diagnostic",
      "form": "A",
      "pair": 2
    },
    {
      "id": "adverb-order-06",
      "unit": "adverb-order",
      "skill": "order",
      "prompt": "Choose the sentence with standard written word order.",
      "options": [
        "They ready are usually.",
        "They are usually ready.",
        "They usually ready are."
      ],
      "answer": 1,
      "explanation": "Put usually after are and before ready.",
      "level": 3,
      "use": "diagnostic",
      "form": "B",
      "pair": 2
    },
    {
      "id": "adverb-order-07",
      "unit": "adverb-order",
      "skill": "order",
      "prompt": "Choose the sentence with standard written word order.",
      "options": [
        "We eat fast rarely food.",
        "We rarely eat fast food.",
        "We rarely fast eat food."
      ],
      "answer": 1,
      "explanation": "Rarely goes before eat; keep fast food together.",
      "level": 1,
      "use": "practice",
      "form": null,
      "pair": null
    },
    {
      "id": "adverb-order-08",
      "unit": "adverb-order",
      "skill": "order",
      "prompt": "Choose the sentence with standard written word order.",
      "options": [
        "He is often late.",
        "He late is often.",
        "He often late is."
      ],
      "answer": 0,
      "explanation": "Often goes after is.",
      "level": 2,
      "use": "practice",
      "form": null,
      "pair": null
    },
    {
      "id": "adverb-order-09",
      "unit": "adverb-order",
      "skill": "order",
      "prompt": "Choose the sentence with standard written word order.",
      "options": [
        "I always my answers check.",
        "I check my always answers.",
        "I always check my answers."
      ],
      "answer": 2,
      "explanation": "Always goes before check; keep my answers together.",
      "level": 2,
      "use": "practice",
      "form": null,
      "pair": null
    },
    {
      "id": "adverb-order-10",
      "unit": "adverb-order",
      "skill": "order",
      "prompt": "Choose the sentence with standard written word order.",
      "options": [
        "My friends never rude are.",
        "My friends are never rude.",
        "My friends rude are never."
      ],
      "answer": 1,
      "explanation": "With be, never follows are and comes before rude.",
      "level": 3,
      "use": "practice",
      "form": null,
      "pair": null
    },
    {
      "id": "verb-group-order-01",
      "unit": "verb-group-order",
      "skill": "order",
      "prompt": "Choose the sentence with standard written word order.",
      "options": [
        "She can English speak.",
        "She speak can English.",
        "She can speak English."
      ],
      "answer": 2,
      "explanation": "Use subject + can + base verb + object.",
      "level": 1,
      "use": "diagnostic",
      "form": "A",
      "pair": 0
    },
    {
      "id": "verb-group-order-02",
      "unit": "verb-group-order",
      "skill": "order",
      "prompt": "Choose the sentence with standard written word order.",
      "options": [
        "He ride can a bike.",
        "He can a bike ride.",
        "He can ride a bike."
      ],
      "answer": 2,
      "explanation": "Can comes before the base verb ride.",
      "level": 1,
      "use": "diagnostic",
      "form": "B",
      "pair": 0
    },
    {
      "id": "verb-group-order-03",
      "unit": "verb-group-order",
      "skill": "order",
      "prompt": "Choose the sentence with standard written word order.",
      "options": [
        "He finished has already his work.",
        "He has already finished his work.",
        "He has already his work finished."
      ],
      "answer": 1,
      "explanation": "Use has + already + finished, then the object.",
      "level": 2,
      "use": "diagnostic",
      "form": "A",
      "pair": 1
    },
    {
      "id": "verb-group-order-04",
      "unit": "verb-group-order",
      "skill": "order",
      "prompt": "Choose the sentence with standard written word order.",
      "options": [
        "They have just arrived at the station.",
        "They have just at the station arrived to.",
        "They arrived have just at the station."
      ],
      "answer": 0,
      "explanation": "Use have + just + arrived, followed by the place.",
      "level": 2,
      "use": "diagnostic",
      "form": "B",
      "pair": 1
    },
    {
      "id": "verb-group-order-05",
      "unit": "verb-group-order",
      "skill": "order",
      "prompt": "Choose the sentence with standard written word order.",
      "options": [
        "Have you ever visited London?",
        "Have ever you visited London?",
        "Have visited you ever London?"
      ],
      "answer": 0,
      "explanation": "Use have + subject + ever + past participle.",
      "level": 3,
      "use": "diagnostic",
      "form": "A",
      "pair": 2
    },
    {
      "id": "verb-group-order-06",
      "unit": "verb-group-order",
      "skill": "order",
      "prompt": "Choose the sentence with standard written word order.",
      "options": [
        "Could tell you me the time?",
        "Could you me the time tell?",
        "Could you tell me the time?"
      ],
      "answer": 2,
      "explanation": "Use could + you + tell, followed by the objects.",
      "level": 3,
      "use": "diagnostic",
      "form": "B",
      "pair": 2
    },
    {
      "id": "verb-group-order-07",
      "unit": "verb-group-order",
      "skill": "order",
      "prompt": "Choose the sentence with standard written word order.",
      "options": [
        "I am to going read this book.",
        "I going am to read this book.",
        "I am going to read this book."
      ],
      "answer": 2,
      "explanation": "Keep am going to together before the base verb read.",
      "level": 1,
      "use": "practice",
      "form": null,
      "pair": null
    },
    {
      "id": "verb-group-order-08",
      "unit": "verb-group-order",
      "skill": "order",
      "prompt": "Choose the sentence with standard written word order.",
      "options": [
        "We not are watching TV.",
        "We are not watching TV.",
        "We are watching not TV."
      ],
      "answer": 1,
      "explanation": "Put not after are and before watching.",
      "level": 2,
      "use": "practice",
      "form": null,
      "pair": null
    },
    {
      "id": "verb-group-order-09",
      "unit": "verb-group-order",
      "skill": "order",
      "prompt": "Choose the sentence with standard written word order.",
      "options": [
        "I not do understand this word.",
        "I do understand not this word.",
        "I do not understand this word."
      ],
      "answer": 2,
      "explanation": "Use do not + base verb understand.",
      "level": 2,
      "use": "practice",
      "form": null,
      "pair": null
    },
    {
      "id": "verb-group-order-10",
      "unit": "verb-group-order",
      "skill": "order",
      "prompt": "Choose the sentence with standard written word order.",
      "options": [
        "I like would a glass of water.",
        "I would like a glass of water.",
        "I would a glass of water like."
      ],
      "answer": 1,
      "explanation": "Keep would like together, followed by the object.",
      "level": 3,
      "use": "practice",
      "form": null,
      "pair": null
    },
    {
      "id": "common-spelling-01",
      "unit": "common-spelling",
      "skill": "spell",
      "prompt": "I stayed home ___ I was ill.",
      "options": [
        "because",
        "becouse",
        "becaus"
      ],
      "answer": 0,
      "explanation": "The correct spelling is because.",
      "level": 1,
      "use": "diagnostic",
      "form": "A",
      "pair": 0
    },
    {
      "id": "common-spelling-02",
      "unit": "common-spelling",
      "skill": "spell",
      "prompt": "The garden is very ___.",
      "options": [
        "beautifal",
        "beutiful",
        "beautiful"
      ],
      "answer": 2,
      "explanation": "The correct spelling is beautiful: beau-ti-ful.",
      "level": 1,
      "use": "diagnostic",
      "form": "B",
      "pair": 0
    },
    {
      "id": "common-spelling-03",
      "unit": "common-spelling",
      "skill": "spell",
      "prompt": "We have a ___ lesson.",
      "options": [
        "sience",
        "sciense",
        "science"
      ],
      "answer": 2,
      "explanation": "Science begins with sc and ends in -ence.",
      "level": 2,
      "use": "diagnostic",
      "form": "A",
      "pair": 1
    },
    {
      "id": "common-spelling-04",
      "unit": "common-spelling",
      "skill": "spell",
      "prompt": "English is my favourite ___.",
      "options": [
        "subjekt",
        "subgect",
        "subject"
      ],
      "answer": 2,
      "explanation": "The correct spelling is subject.",
      "level": 2,
      "use": "diagnostic",
      "form": "B",
      "pair": 1
    },
    {
      "id": "common-spelling-05",
      "unit": "common-spelling",
      "skill": "spell",
      "prompt": "We need more ___ about the trip.",
      "options": [
        "infermation",
        "information",
        "informasion"
      ],
      "answer": 1,
      "explanation": "The correct spelling is information.",
      "level": 3,
      "use": "diagnostic",
      "form": "A",
      "pair": 2
    },
    {
      "id": "common-spelling-06",
      "unit": "common-spelling",
      "skill": "spell",
      "prompt": "The ___ is sunny today.",
      "options": [
        "wether",
        "weather",
        "wheather"
      ],
      "answer": 1,
      "explanation": "The correct spelling is weather.",
      "level": 3,
      "use": "diagnostic",
      "form": "B",
      "pair": 2
    },
    {
      "id": "common-spelling-07",
      "unit": "common-spelling",
      "skill": "spell",
      "prompt": "We visited a ___ yesterday.",
      "options": [
        "museum",
        "muzeum",
        "musem"
      ],
      "answer": 0,
      "explanation": "The correct spelling is museum.",
      "level": 1,
      "use": "practice",
      "form": null,
      "pair": null
    },
    {
      "id": "common-spelling-08",
      "unit": "common-spelling",
      "skill": "spell",
      "prompt": "I celebrate my ___ every year.",
      "options": [
        "birthdy",
        "berthday",
        "birthday"
      ],
      "answer": 2,
      "explanation": "The correct spelling is birthday.",
      "level": 2,
      "use": "practice",
      "form": null,
      "pair": null
    },
    {
      "id": "common-spelling-09",
      "unit": "common-spelling",
      "skill": "spell",
      "prompt": "Please write your ___ here.",
      "options": [
        "naim",
        "name",
        "neme"
      ],
      "answer": 1,
      "explanation": "The correct spelling is name.",
      "level": 2,
      "use": "practice",
      "form": null,
      "pair": null
    },
    {
      "id": "common-spelling-10",
      "unit": "common-spelling",
      "skill": "spell",
      "prompt": "Her ___ is excellent.",
      "options": [
        "pronunciation",
        "pronounciation",
        "pronuncation"
      ],
      "answer": 0,
      "explanation": "Pronunciation has nun, not noun, after pro-.",
      "level": 3,
      "use": "practice",
      "form": null,
      "pair": null
    },
    {
      "id": "double-letters-01",
      "unit": "double-letters",
      "skill": "spell",
      "prompt": "Please write your ___ here.",
      "options": [
        "addres",
        "address",
        "adress"
      ],
      "answer": 1,
      "explanation": "Address has two d letters and two s letters.",
      "level": 1,
      "use": "diagnostic",
      "form": "A",
      "pair": 0
    },
    {
      "id": "double-letters-02",
      "unit": "double-letters",
      "skill": "spell",
      "prompt": "Let us meet ___.",
      "options": [
        "tommorow",
        "tomorrow",
        "tomorow"
      ],
      "answer": 1,
      "explanation": "Tomorrow has one m and two r letters.",
      "level": 1,
      "use": "diagnostic",
      "form": "B",
      "pair": 0
    },
    {
      "id": "double-letters-03",
      "unit": "double-letters",
      "skill": "spell",
      "prompt": "This exercise is ___.",
      "options": [
        "difficult",
        "difficalt",
        "dificult"
      ],
      "answer": 0,
      "explanation": "Difficult has two f letters.",
      "level": 2,
      "use": "diagnostic",
      "form": "A",
      "pair": 1
    },
    {
      "id": "double-letters-04",
      "unit": "double-letters",
      "skill": "spell",
      "prompt": "They live in a small ___.",
      "options": [
        "village",
        "vilage",
        "villige"
      ],
      "answer": 0,
      "explanation": "Village has two l letters.",
      "level": 2,
      "use": "diagnostic",
      "form": "B",
      "pair": 1
    },
    {
      "id": "double-letters-05",
      "unit": "double-letters",
      "skill": "spell",
      "prompt": "It is ___ to wear a seat belt.",
      "options": [
        "neccessary",
        "necessary",
        "necesary"
      ],
      "answer": 1,
      "explanation": "Necessary has one c and two s letters.",
      "level": 3,
      "use": "diagnostic",
      "form": "A",
      "pair": 2
    },
    {
      "id": "double-letters-06",
      "unit": "double-letters",
      "skill": "spell",
      "prompt": "The answer is ___.",
      "options": [
        "correkt",
        "corect",
        "correct"
      ],
      "answer": 2,
      "explanation": "Correct has two r letters and ends in -ect.",
      "level": 3,
      "use": "diagnostic",
      "form": "B",
      "pair": 2
    },
    {
      "id": "double-letters-07",
      "unit": "double-letters",
      "skill": "spell",
      "prompt": "The story is very ___.",
      "options": [
        "funy",
        "funnie",
        "funny"
      ],
      "answer": 2,
      "explanation": "Funny has two n letters and ends in y.",
      "level": 1,
      "use": "practice",
      "form": null,
      "pair": null
    },
    {
      "id": "double-letters-08",
      "unit": "double-letters",
      "skill": "spell",
      "prompt": "We live near a ___ lake.",
      "options": [
        "smaul",
        "smal",
        "small"
      ],
      "answer": 2,
      "explanation": "Small ends in two l letters.",
      "level": 2,
      "use": "practice",
      "form": null,
      "pair": null
    },
    {
      "id": "double-letters-09",
      "unit": "double-letters",
      "skill": "spell",
      "prompt": "I feel ___ after the good news.",
      "options": [
        "happie",
        "happy",
        "hapy"
      ],
      "answer": 1,
      "explanation": "Happy has two p letters and ends in y.",
      "level": 2,
      "use": "practice",
      "form": null,
      "pair": null
    },
    {
      "id": "double-letters-10",
      "unit": "double-letters",
      "skill": "spell",
      "prompt": "She is a great ___.",
      "options": [
        "swimmar",
        "swimmer",
        "swimer"
      ],
      "answer": 1,
      "explanation": "Swimmer has two m letters and ends in -er.",
      "level": 3,
      "use": "practice",
      "form": null,
      "pair": null
    },
    {
      "id": "letter-patterns-01",
      "unit": "letter-patterns",
      "skill": "spell",
      "prompt": "Please ___ to the teacher.",
      "options": [
        "lisen",
        "listten",
        "listen"
      ],
      "answer": 2,
      "explanation": "Listen has a written t that is not pronounced.",
      "level": 1,
      "use": "diagnostic",
      "form": "A",
      "pair": 0
    },
    {
      "id": "letter-patterns-02",
      "unit": "letter-patterns",
      "skill": "spell",
      "prompt": "Please check your ___.",
      "options": [
        "answer",
        "anser",
        "answar"
      ],
      "answer": 0,
      "explanation": "Answer has a written w that is not pronounced.",
      "level": 1,
      "use": "diagnostic",
      "form": "B",
      "pair": 0
    },
    {
      "id": "letter-patterns-03",
      "unit": "letter-patterns",
      "skill": "spell",
      "prompt": "She is my best ___.",
      "options": [
        "friend",
        "freind",
        "frend"
      ],
      "answer": 0,
      "explanation": "In friend, i comes before e.",
      "level": 2,
      "use": "diagnostic",
      "form": "A",
      "pair": 1
    },
    {
      "id": "letter-patterns-04",
      "unit": "letter-patterns",
      "skill": "spell",
      "prompt": "Our test is on ___.",
      "options": [
        "Wensday",
        "Wendesday",
        "Wednesday"
      ],
      "answer": 2,
      "explanation": "The correct spelling is Wednesday.",
      "level": 2,
      "use": "diagnostic",
      "form": "B",
      "pair": 1
    },
    {
      "id": "letter-patterns-05",
      "unit": "letter-patterns",
      "skill": "spell",
      "prompt": "We have ___ time to finish.",
      "options": [
        "enough",
        "enouph",
        "enogh"
      ],
      "answer": 0,
      "explanation": "The correct spelling is enough.",
      "level": 3,
      "use": "diagnostic",
      "form": "A",
      "pair": 2
    },
    {
      "id": "letter-patterns-06",
      "unit": "letter-patterns",
      "skill": "spell",
      "prompt": "Please ___ the new words.",
      "options": [
        "remmember",
        "remember",
        "remeber"
      ],
      "answer": 1,
      "explanation": "Remember has one m after re- and another in -member.",
      "level": 3,
      "use": "diagnostic",
      "form": "B",
      "pair": 2
    },
    {
      "id": "letter-patterns-07",
      "unit": "letter-patterns",
      "skill": "spell",
      "prompt": "I know the ___ to the question.",
      "options": [
        "anwser",
        "answer",
        "ansver"
      ],
      "answer": 1,
      "explanation": "Answer includes the sequence -nsw-.",
      "level": 1,
      "use": "practice",
      "form": null,
      "pair": null
    },
    {
      "id": "letter-patterns-08",
      "unit": "letter-patterns",
      "skill": "spell",
      "prompt": "She hurt her left ___.",
      "options": [
        "knee",
        "kneei",
        "nee"
      ],
      "answer": 0,
      "explanation": "Knee starts with a silent k.",
      "level": 2,
      "use": "practice",
      "form": null,
      "pair": null
    },
    {
      "id": "letter-patterns-09",
      "unit": "letter-patterns",
      "skill": "spell",
      "prompt": "Please use a ___ to cut the bread.",
      "options": [
        "knif",
        "nife",
        "knife"
      ],
      "answer": 2,
      "explanation": "Knife begins with a silent k and ends in e.",
      "level": 2,
      "use": "practice",
      "form": null,
      "pair": null
    },
    {
      "id": "letter-patterns-10",
      "unit": "letter-patterns",
      "skill": "spell",
      "prompt": "I will ___ a letter.",
      "options": [
        "rite",
        "write",
        "writ"
      ],
      "answer": 1,
      "explanation": "Write begins with a silent w and ends in e.",
      "level": 3,
      "use": "practice",
      "form": null,
      "pair": null
    },
    {
      "id": "capital-letters-01",
      "unit": "capital-letters",
      "skill": "spell",
      "prompt": "We study ___ at school.",
      "options": [
        "English",
        "EngLish",
        "english"
      ],
      "answer": 0,
      "explanation": "Language names begin with a capital letter: English.",
      "level": 1,
      "use": "diagnostic",
      "form": "A",
      "pair": 0
    },
    {
      "id": "capital-letters-02",
      "unit": "capital-letters",
      "skill": "spell",
      "prompt": "She speaks ___ with her family.",
      "options": [
        "kazakh",
        "Kazakh",
        "kaZakh"
      ],
      "answer": 1,
      "explanation": "Language names begin with a capital letter: Kazakh.",
      "level": 1,
      "use": "diagnostic",
      "form": "B",
      "pair": 0
    },
    {
      "id": "capital-letters-03",
      "unit": "capital-letters",
      "skill": "spell",
      "prompt": "We celebrate Nauryz in ___.",
      "options": [
        "March",
        "march",
        "MarCh"
      ],
      "answer": 0,
      "explanation": "Month names begin with a capital letter.",
      "level": 2,
      "use": "diagnostic",
      "form": "A",
      "pair": 1
    },
    {
      "id": "capital-letters-04",
      "unit": "capital-letters",
      "skill": "spell",
      "prompt": "The club meets on ___.",
      "options": [
        "friday",
        "friDay",
        "Friday"
      ],
      "answer": 2,
      "explanation": "Day names begin with a capital letter.",
      "level": 2,
      "use": "diagnostic",
      "form": "B",
      "pair": 1
    },
    {
      "id": "capital-letters-05",
      "unit": "capital-letters",
      "skill": "spell",
      "prompt": "I was born in ___.",
      "options": [
        "kazakhstan",
        "Kazakhstan",
        "kazaKhstan"
      ],
      "answer": 1,
      "explanation": "Country names begin with a capital letter.",
      "level": 3,
      "use": "diagnostic",
      "form": "A",
      "pair": 2
    },
    {
      "id": "capital-letters-06",
      "unit": "capital-letters",
      "skill": "spell",
      "prompt": "___ enjoy reading books.",
      "options": [
        "I",
        "i",
        "ı"
      ],
      "answer": 0,
      "explanation": "The pronoun I is always a capital letter.",
      "level": 3,
      "use": "diagnostic",
      "form": "B",
      "pair": 2
    },
    {
      "id": "capital-letters-07",
      "unit": "capital-letters",
      "skill": "spell",
      "prompt": "Our teacher is called ___.",
      "options": [
        "Aida",
        "aiDa",
        "aida"
      ],
      "answer": 0,
      "explanation": "A person’s name begins with a capital letter.",
      "level": 1,
      "use": "practice",
      "form": null,
      "pair": null
    },
    {
      "id": "capital-letters-08",
      "unit": "capital-letters",
      "skill": "spell",
      "prompt": "The holiday starts in ___.",
      "options": [
        "June",
        "juNe",
        "june"
      ],
      "answer": 0,
      "explanation": "Month names begin with a capital letter.",
      "level": 2,
      "use": "practice",
      "form": null,
      "pair": null
    },
    {
      "id": "capital-letters-09",
      "unit": "capital-letters",
      "skill": "spell",
      "prompt": "We visited ___ last summer.",
      "options": [
        "london",
        "lonDon",
        "London"
      ],
      "answer": 2,
      "explanation": "City names begin with a capital letter.",
      "level": 2,
      "use": "practice",
      "form": null,
      "pair": null
    },
    {
      "id": "capital-letters-10",
      "unit": "capital-letters",
      "skill": "spell",
      "prompt": "Choose the correctly capitalised sentence.",
      "options": [
        "She likes english.",
        "She likes English.",
        "she likes English."
      ],
      "answer": 1,
      "explanation": "Capitalise the first word of the sentence and the language name.",
      "level": 3,
      "use": "practice",
      "form": null,
      "pair": null
    }
  ]
}
````

## dist/assets/translations.json

````json
{
  "Workspace": {
    "kk": "Жұмыс аймағы",
    "ru": "Рабочая область"
  },
  "Check": {
    "kk": "Тексеру",
    "ru": "Проверка"
  },
  "Error map": {
    "kk": "Қателер картасы",
    "ru": "Карта ошибок"
  },
  "Learning plan": {
    "kk": "Оқу бағыты",
    "ru": "Учебный маршрут"
  },
  "Writing": {
    "kk": "Жазылым",
    "ru": "Письмо"
  },
  "Library": {
    "kk": "Тапсырмалар",
    "ru": "Задания"
  },
  "Teacher": {
    "kk": "Мұғалімге",
    "ru": "Учителю"
  },
  "About": {
    "kk": "Жоба туралы",
    "ru": "О проекте"
  },
  "Language": {
    "kk": "Тіл",
    "ru": "Язык"
  },
  "Interface language": {
    "kk": "Интерфейс тілі",
    "ru": "Язык интерфейса"
  },
  "Skip to content": {
    "kk": "Мазмұнға өту",
    "ru": "Перейти к содержанию"
  },
  "Main navigation": {
    "kk": "Негізгі бөлімдер",
    "ru": "Основные разделы"
  },
  "Local workspace": {
    "kk": "Осы құрылғыдағы жұмыс аймағы",
    "ru": "Работа на этом устройстве"
  },
  "Saved on this device": {
    "kk": "Осы құрылғыда сақталды",
    "ru": "Сохранено на этом устройстве"
  },
  "Not saved": {
    "kk": "Сақталмады",
    "ru": "Не сохранено"
  },
  "Learner:": {
    "kk": "Оқушы:",
    "ru": "Ученик:"
  },
  "Learner profile": {
    "kk": "Оқушы профилі",
    "ru": "Профиль ученика"
  },
  "Learner code": {
    "kk": "Оқушы коды",
    "ru": "Код ученика"
  },
  "Select a saved code or create a new one. Each learner keeps separate results and unfinished work.": {
    "kk": "Сақталған кодты таңда немесе жаңа код жаса. Әр оқушының нәтижесі мен аяқталмаған жұмысы бөлек сақталады.",
    "ru": "Выберите сохранённый код или создайте новый. Результаты и незаконченная работа каждого ученика сохраняются отдельно."
  },
  "Example: LEARNER-02": {
    "kk": "Мысалы: LEARNER-02",
    "ru": "Например: LEARNER-02"
  },
  "Use a code, not a real name. Letters, numbers, hyphens and underscores only.": {
    "kk": "Аты-жөніңнің орнына код қолдан. Әріптер, сандар, дефис және төменгі сызық рұқсат етіледі.",
    "ru": "Используйте код вместо имени. Допустимы буквы, цифры, дефисы и подчёркивания."
  },
  "Cancel": {
    "kk": "Бас тарту",
    "ru": "Отмена"
  },
  "Open profile": {
    "kk": "Профильді ашу",
    "ru": "Открыть профиль"
  },
  "How it works": {
    "kk": "Қалай жұмыс істейді",
    "ru": "Как это работает"
  },
  "ENGLISH · GRADE 7": {
    "kk": "АҒЫЛШЫН ТІЛІ · 7-СЫНЫП",
    "ru": "АНГЛИЙСКИЙ ЯЗЫК · 7 КЛАСС"
  },
  "Find the gap.": {
    "kk": "Қиындықты анықта.",
    "ru": "Найди пробел."
  },
  "Know your next step.": {
    "kk": "Келесі қадамыңды біл.",
    "ru": "Узнай свой следующий шаг."
  },
  "Check your English. Practise the rules you need. Test them again on new examples.": {
    "kk": "Ағылшын тіліңді тексер. Қажет ережелерді қайтала. Жаңа мысалдармен қайта тексер.",
    "ru": "Проверь свой английский. Отработай нужные правила и проверь их на новых примерах."
  },
  "Explore practice": {
    "kk": "Жаттығуларды қарау",
    "ru": "Посмотреть упражнения"
  },
  "Your workspace": {
    "kk": "Жұмыс аймағың",
    "ru": "Твоя рабочая область"
  },
  "BASELINE": {
    "kk": "БАСТАПҚЫ ТЕКСЕРУ",
    "ru": "НАЧАЛЬНАЯ ПРОВЕРКА"
  },
  "NEXT STEP": {
    "kk": "КЕЛЕСІ ҚАДАМ",
    "ru": "СЛЕДУЮЩИЙ ШАГ"
  },
  "RECHECK": {
    "kk": "ҚАЙТА ТЕКСЕРУ",
    "ru": "ПОВТОРНАЯ ПРОВЕРКА"
  },
  "Start with one question for each rule.": {
    "kk": "Әр ереже бойынша бір сұрақтан баста.",
    "ru": "Начни с одного вопроса по каждому правилу."
  },
  "Start baseline": {
    "kk": "Бастапқы тексеруді бастау",
    "ru": "Начать проверку"
  },
  "Start your baseline": {
    "kk": "Бастапқы тексеруді баста",
    "ru": "Начни начальную проверку"
  },
  "View your error map": {
    "kk": "Қателер картасын ашу",
    "ru": "Открыть карту ошибок"
  },
  "View your progress": {
    "kk": "Нәтижелерді қарау",
    "ru": "Посмотреть прогресс"
  },
  "Your baseline and recheck are ready to compare.": {
    "kk": "Бастапқы және қайта тексеру нәтижелерін салыстыруға болады.",
    "ru": "Результаты начальной и повторной проверки готовы к сравнению."
  },
  "Your answers are saved.": {
    "kk": "Жауаптарың сақталды.",
    "ru": "Твои ответы сохранены."
  },
  "Continue": {
    "kk": "Жалғастыру",
    "ru": "Продолжить"
  },
  "Your words.": {
    "kk": "Сенің сөздерің.",
    "ru": "Твои слова."
  },
  "Your next draft.": {
    "kk": "Келесі нұсқаң.",
    "ru": "Твой следующий черновик."
  },
  "Write and revise": {
    "kk": "Жазу және түзету",
    "ru": "Написать и исправить"
  },
  "Six skill areas": {
    "kk": "Алты дағды бағыты",
    "ru": "Шесть направлений"
  },
  "Four rules in each area": {
    "kk": "Әр бағытта төрт ереже",
    "ru": "По четыре правила в каждом направлении"
  },
  "Verb agreement": {
    "kk": "Бастауыш пен етістіктің қиысуы",
    "ru": "Согласование глагола"
  },
  "Verb tenses": {
    "kk": "Етістік шақтары",
    "ru": "Времена глагола"
  },
  "Words & phrases": {
    "kk": "Сөздер мен тіркестер",
    "ru": "Слова и сочетания"
  },
  "Prepositions": {
    "kk": "Предлогтар",
    "ru": "Предлоги"
  },
  "Word order": {
    "kk": "Сөз реті",
    "ru": "Порядок слов"
  },
  "Spelling": {
    "kk": "Емле",
    "ru": "Правописание"
  },
  "Check your English": {
    "kk": "Ағылшын тіліңді тексер",
    "ru": "Проверь свой английский"
  },
  "Baseline → targeted practice → rule checks → recheck": {
    "kk": "Бастапқы тексеру → жеке жаттығу → ережені тексеру → қайта тексеру",
    "ru": "Начальная проверка → практика → проверка правила → повторный тест"
  },
  "Start with what you know.": {
    "kk": "Алдымен біліміңді тексер.",
    "ru": "Начни с того, что знаешь."
  },
  "24 questions. One question for each rule. Answers stay hidden until you submit.": {
    "kk": "24 сұрақ. Әр ережеге бір сұрақ. Дұрыс жауаптар тексеруді аяқтағанда ашылады.",
    "ru": "24 вопроса: по одному на каждое правило. Правильные ответы откроются после отправки."
  },
  "About 15 minutes": {
    "kk": "Шамамен 15 минут",
    "ru": "Около 15 минут"
  },
  "Autosaved": {
    "kk": "Автоматты сақталады",
    "ru": "Автосохранение"
  },
  "View baseline": {
    "kk": "Бастапқы нәтижені қарау",
    "ru": "Посмотреть начальный результат"
  },
  "Use the rule in a new sentence.": {
    "kk": "Ережені жаңа сөйлемде қолдан.",
    "ru": "Примени правило в новом предложении."
  },
  "The recheck follows your baseline topics and difficulty, using different questions.": {
    "kk": "Қайта тексеруде сол тақырыптар мен деңгейге сай басқа сұрақтар беріледі.",
    "ru": "Повторная проверка охватывает те же темы и уровень сложности, но содержит другие вопросы."
  },
  "Complete your baseline first.": {
    "kk": "Алдымен бастапқы тексеруден өт.",
    "ru": "Сначала пройди начальную проверку."
  },
  "Compare results": {
    "kk": "Нәтижелерді салыстыру",
    "ru": "Сравнить результаты"
  },
  "All assigned rules have been checked.": {
    "kk": "Барлық берілген ереже тексерілді.",
    "ru": "Все назначенные правила проверены."
  },
  "No rules were flagged in your baseline.": {
    "kk": "Бастапқы тексеруде қате анықталмады.",
    "ru": "Начальная проверка не выявила ошибок."
  },
  "Start recheck": {
    "kk": "Қайта тексеруді бастау",
    "ru": "Начать повторную проверку"
  },
  "Take your recheck": {
    "kk": "Қайта тексеруден өт",
    "ru": "Пройди повторную проверку"
  },
  "Continue your plan": {
    "kk": "Оқу бағытын жалғастыру",
    "ru": "Продолжить маршрут"
  },
  "What can these results tell me?": {
    "kk": "Бұл нәтижелер нені көрсетеді?",
    "ru": "О чём говорят результаты?"
  },
  "One baseline answer is a starting signal, not proof of a gap or mastery. Your practice and independent rule checks add evidence. Paired questions cover the same rule and difficulty band, but the tests have not been statistically equated.": {
    "kk": "Бір жауап — бастапқы бағдар. Ол ережені толық меңгеру немесе білмеу туралы қорытындыға жеткіліксіз. Жаттығулар мен өздік тексеру қосымша дерек береді. Жұп сұрақтар бір ережеге және деңгейге арналған, бірақ тесттердің тең қиындығы статистикалық расталмаған.",
    "ru": "Один ответ — лишь начальный сигнал. Он не доказывает наличие пробела или владение правилом. Практика и самостоятельные проверки дополняют картину. Парные вопросы совпадают по правилу и уровню, но тесты статистически не уравнивались."
  },
  "Start another learning cycle": {
    "kk": "Жаңа оқу кезеңін бастау",
    "ru": "Начать новый учебный цикл"
  },
  "Keep this cycle in your history and use a fresh baseline.": {
    "kk": "Осы кезеңді тарихта сақтап, жаңа бастапқы тексеруден өт.",
    "ru": "Сохрани этот цикл в истории и пройди новую начальную проверку."
  },
  "New cycle": {
    "kk": "Жаңа кезең",
    "ru": "Новый цикл"
  },
  "Review your answers": {
    "kk": "Жауаптарыңды қарап шық",
    "ru": "Проверь свои ответы"
  },
  "You can change an answer before submitting. Correct answers are still hidden.": {
    "kk": "Жібермес бұрын жауапты өзгертуге болады. Дұрыс жауаптар әзірге көрсетілмейді.",
    "ru": "До отправки можно изменить ответ. Правильные ответы пока скрыты."
  },
  "Not answered": {
    "kk": "Жауап жоқ",
    "ru": "Нет ответа"
  },
  "Save & exit": {
    "kk": "Сақтап, шығу",
    "ru": "Сохранить и выйти"
  },
  "Baseline": {
    "kk": "Бастапқы тексеру",
    "ru": "Начальная проверка"
  },
  "Recheck": {
    "kk": "Қайта тексеру",
    "ru": "Повторная проверка"
  },
  "Rule check": {
    "kk": "Ережені тексеру",
    "ru": "Проверка правила"
  },
  "Choose one answer. You can review before submitting.": {
    "kk": "Бір жауапты таңда. Жібермес бұрын тексеруге болады.",
    "ru": "Выбери один ответ. Перед отправкой их можно проверить."
  },
  "Some examples appeared in earlier attempts. This is recorded with the result.": {
    "kk": "Кей мысалдар бұрынғы әрекеттерде кездескен. Бұл нәтижеде белгіленеді.",
    "ru": "Некоторые примеры встречались раньше. Это будет отмечено в результате."
  },
  "Back": {
    "kk": "Артқа",
    "ru": "Назад"
  },
  "Next": {
    "kk": "Келесі",
    "ru": "Далее"
  },
  "Review answers": {
    "kk": "Жауаптарды қарау",
    "ru": "Проверить ответы"
  },
  "Discard attempt": {
    "kk": "Әрекетті жою",
    "ru": "Удалить попытку"
  },
  "Submit baseline": {
    "kk": "Бастапқы жауаптарды жіберу",
    "ru": "Отправить начальный тест"
  },
  "Submit recheck": {
    "kk": "Қайта тексеруді жіберу",
    "ru": "Отправить повторный тест"
  },
  "Submit rule check": {
    "kk": "Ереже тексеруін жіберу",
    "ru": "Отправить проверку правила"
  },
  "Your error map": {
    "kk": "Сенің қателер картаң",
    "ru": "Твоя карта ошибок"
  },
  "Your progress": {
    "kk": "Сенің нәтижелерің",
    "ru": "Твой прогресс"
  },
  "Compare the same rules using different examples.": {
    "kk": "Бір ережені әртүрлі мысалдағы нәтижелермен салыстыр.",
    "ru": "Сравни результаты по одним правилам на разных примерах."
  },
  "Missed answers become practice suggestions, not permanent labels.": {
    "kk": "Қате жауаптар жаттығу бағытын таңдауға көмектеседі.",
    "ru": "Ошибки помогают выбрать, что отработать дальше."
  },
  "ASSIGNED RULES": {
    "kk": "БЕРІЛГЕН ЕРЕЖЕЛЕР",
    "ru": "НАЗНАЧЕННЫЕ ПРАВИЛА"
  },
  "CHANGE": {
    "kk": "ӨЗГЕРІС",
    "ru": "ИЗМЕНЕНИЕ"
  },
  "Same topics · different examples": {
    "kk": "Сол тақырыптар · басқа мысалдар",
    "ru": "Те же темы · другие примеры"
  },
  "Open learning plan": {
    "kk": "Оқу бағытын ашу",
    "ru": "Открыть учебный маршрут"
  },
  "View history": {
    "kk": "Тарихты қарау",
    "ru": "Посмотреть историю"
  },
  "Rule-by-rule comparison": {
    "kk": "Ережелер бойынша салыстыру",
    "ru": "Сравнение по правилам"
  },
  "Answers and next steps": {
    "kk": "Жауаптар және келесі қадам",
    "ru": "Ответы и следующие шаги"
  },
  "Correct": {
    "kk": "Дұрыс",
    "ru": "Правильно"
  },
  "Missed": {
    "kk": "Қате",
    "ru": "Ошибка"
  },
  "Not flagged in baseline": {
    "kk": "Бастапқы тексеруде дұрыс",
    "ru": "Верно в начальной проверке"
  },
  "Your answer:": {
    "kk": "Сенің жауабың:",
    "ru": "Твой ответ:"
  },
  "Expected:": {
    "kk": "Дұрыс жауап:",
    "ru": "Правильный ответ:"
  },
  "Recheck answer:": {
    "kk": "Қайта тест жауабы:",
    "ru": "Ответ повторного теста:"
  },
  "Needs another look": {
    "kk": "Қайта қарау қажет",
    "ru": "Нужно повторить"
  },
  "Practise this rule": {
    "kk": "Ережені жаттықтыру",
    "ru": "Отработать правило"
  },
  "How is the plan chosen?": {
    "kk": "Оқу бағыты қалай таңдалады?",
    "ru": "Как выбирается маршрут?"
  },
  "A missed baseline answer flags its specific rule. Four dedicated practice questions are followed by a two-question independent rule check. A clean rule check adds evidence of improvement; it does not prove long-term mastery. Correct baseline rules remain available for optional practice.": {
    "kk": "Бастапқы қатеге сәйкес ереже белгіленеді. Төрт жаттығудан кейін екі сұрақтық өздік тексеру беріледі. Дұрыс нәтиже ілгерілеуді көрсетеді, бірақ ұзақ мерзімді меңгеруді дәлелдемейді. Қалған ережелерді де жаттықтыруға болады.",
    "ru": "Ошибка начального теста отмечает конкретное правило. После четырёх упражнений следуют два самостоятельных вопроса. Успешная проверка показывает улучшение, но не доказывает долгосрочное владение. Остальные правила тоже доступны для практики."
  },
  "Work on one rule at a time. Practise, explain, then check it.": {
    "kk": "Бір ережеден баста. Жаттығып, түсіндіріп, кейін тексер.",
    "ru": "Работай над одним правилом: практика, объяснение, затем проверка."
  },
  "Try any rule, or take a baseline for a personalised plan.": {
    "kk": "Кез келген ережені таңда немесе жеке бағыт үшін бастапқы тексеруден өт.",
    "ru": "Выбери любое правило или пройди начальный тест для личного маршрута."
  },
  "All 24 rules": {
    "kk": "Барлық 24 ереже",
    "ru": "Все 24 правила"
  },
  "Optional practice": {
    "kk": "Қосымша жаттығу",
    "ru": "Практика по желанию"
  },
  "Needs practice": {
    "kk": "Жаттығу қажет",
    "ru": "Нужна практика"
  },
  "Review again": {
    "kk": "Қайта қарау",
    "ru": "Повторить ещё раз"
  },
  "Ready for a rule check": {
    "kk": "Ережені тексеруге дайын",
    "ru": "Готово к проверке правила"
  },
  "Rule check complete": {
    "kk": "Ереже тексерілді",
    "ru": "Правило проверено"
  },
  "Rule check complete · reused examples": {
    "kk": "Ереже тексерілді · қайталанған мысалдар",
    "ru": "Правило проверено · повторные примеры"
  },
  "Check your next rule": {
    "kk": "Келесі ережені тексер",
    "ru": "Проверь следующее правило"
  },
  "Open your learning plan": {
    "kk": "Оқу бағытыңды аш",
    "ru": "Открой учебный маршрут"
  },
  "Check this rule": {
    "kk": "Ережені тексеру",
    "ru": "Проверить правило"
  },
  "Review lesson": {
    "kk": "Сабақты қайталау",
    "ru": "Повторить урок"
  },
  "Practise again": {
    "kk": "Қайта жаттығу",
    "ru": "Потренироваться снова"
  },
  "Review & retry": {
    "kk": "Қайталау және қайта орындау",
    "ru": "Повторить и попробовать снова"
  },
  "Start lesson": {
    "kk": "Сабақты бастау",
    "ru": "Начать урок"
  },
  "Recheck your English": {
    "kk": "Ағылшын тіліңді қайта тексер",
    "ru": "Проверь английский повторно"
  },
  "All assigned rule checks are complete.": {
    "kk": "Барлық берілген ереже тексерілді.",
    "ru": "Все назначенные проверки правил завершены."
  },
  "Finish the assigned rule checks to unlock your recheck.": {
    "kk": "Қайта тесті ашу үшін берілген ережелерді тексеріп аяқта.",
    "ru": "Заверши назначенные проверки правил, чтобы открыть повторный тест."
  },
  "View requirements": {
    "kk": "Талаптарды қарау",
    "ru": "Посмотреть условия"
  },
  "No rules assigned": {
    "kk": "Ереже тағайындалмаған",
    "ru": "Нет назначенных правил"
  },
  "Build your plan": {
    "kk": "Оқу бағытыңды құр",
    "ru": "Создай свой маршрут"
  },
  "Your baseline did not flag any rules. You can explore optional practice or take your recheck.": {
    "kk": "Бастапқы тексеруде қате болмады. Қосымша жаттығуды немесе қайта тексеруді таңда.",
    "ru": "В начальном тесте не было ошибок. Можно выбрать дополнительную практику или повторный тест."
  },
  "Complete a baseline to see which rules to work on.": {
    "kk": "Қай ережені қайталау керегін білу үшін бастапқы тексеруден өт.",
    "ru": "Пройди начальную проверку, чтобы узнать, какие правила повторить."
  },
  "RULE": {
    "kk": "ЕРЕЖЕ",
    "ru": "ПРАВИЛО"
  },
  "What to notice": {
    "kk": "Неге назар аудару керек",
    "ru": "На что обратить внимание"
  },
  "This lesson reuses the same four practice examples. The independent rule check uses different questions.": {
    "kk": "Бұл сабақта сол төрт жаттығу қайталанады. Өздік тексеруде басқа сұрақтар болады.",
    "ru": "В уроке повторяются те же четыре упражнения. Самостоятельная проверка содержит другие вопросы."
  },
  "Try 4 questions": {
    "kk": "4 тапсырманы орындау",
    "ru": "Выполнить 4 задания"
  },
  "Explain the rule": {
    "kk": "Ережені түсіндір",
    "ru": "Объясни правило"
  },
  "Write in your own words. Your teacher can review these examples.": {
    "kk": "Өз сөзіңмен жаз. Мысалдарды мұғалім тексере алады.",
    "ru": "Напиши своими словами. Учитель сможет проверить примеры."
  },
  "Hints and corrected answers are recorded separately.": {
    "kk": "Көмек пен түзетілген жауаптар бөлек тіркеледі.",
    "ru": "Подсказки и исправления учитываются отдельно."
  },
  "What rule did you use?": {
    "kk": "Қай ережені қолдандың?",
    "ru": "Какое правило ты применил?"
  },
  "Write a new sentence": {
    "kk": "Жаңа сөйлем жаз",
    "ru": "Напиши новое предложение"
  },
  "Your writing is saved for teacher review, not automatically marked.": {
    "kk": "Жазғаның мұғалім тексеруі үшін сақталады. Автоматты баға қойылмайды.",
    "ru": "Текст сохраняется для проверки учителем и не оценивается автоматически."
  },
  "Save lesson": {
    "kk": "Сабақты сақтау",
    "ru": "Сохранить урок"
  },
  "Foundation": {
    "kk": "Бастапқы",
    "ru": "Базовый"
  },
  "Developing": {
    "kk": "Орта",
    "ru": "Средний"
  },
  "Stretch": {
    "kk": "Күрделі",
    "ru": "Сложный"
  },
  "Rule reminder": {
    "kk": "Ережені еске түсіру",
    "ru": "Напоминание правила"
  },
  "This answer will be marked as assisted.": {
    "kk": "Бұл жауап көмекпен орындалған деп белгіленеді.",
    "ru": "Этот ответ будет отмечен как выполненный с подсказкой."
  },
  "Correct on your first try.": {
    "kk": "Алғашқы жауап дұрыс.",
    "ru": "Правильно с первой попытки."
  },
  "Correction complete.": {
    "kk": "Қате түзетілді.",
    "ru": "Ошибка исправлена."
  },
  "Read the explanation, then choose the correct answer.": {
    "kk": "Түсіндірмені оқып, дұрыс жауапты таңда.",
    "ru": "Прочитай объяснение и выбери правильный ответ."
  },
  "Check correction": {
    "kk": "Түзетуді тексеру",
    "ru": "Проверить исправление"
  },
  "Check answer": {
    "kk": "Жауапты тексеру",
    "ru": "Проверить ответ"
  },
  "Show rule reminder": {
    "kk": "Ережені көрсету",
    "ru": "Показать правило"
  },
  "Discard lesson": {
    "kk": "Сабақты жою",
    "ru": "Удалить урок"
  },
  "Question library": {
    "kk": "Тапсырмалар қоры",
    "ru": "Банк заданий"
  },
  "96 practice questions across 24 rules. Open a lesson to practise a complete rule.": {
    "kk": "24 ережеге арналған 96 жаттығу. Толық жаттығу үшін сабақты аш.",
    "ru": "96 упражнений по 24 правилам. Открой урок, чтобы отработать правило полностью."
  },
  "Teacher resource: answer keys are available here. Viewing assessment answers can affect later test results.": {
    "kk": "Мұғалімге арналған бөлім: жауап кілттері бар. Оларды алдын ала қарау кейінгі тест нәтижесіне әсер етуі мүмкін.",
    "ru": "Материалы учителя с ключами ответов. Просмотр ответов может повлиять на результаты последующих тестов."
  },
  "Search": {
    "kk": "Іздеу",
    "ru": "Поиск"
  },
  "A rule or a word…": {
    "kk": "Ереже немесе сөз…",
    "ru": "Правило или слово…"
  },
  "Skill area": {
    "kk": "Дағды бағыты",
    "ru": "Направление"
  },
  "All skills": {
    "kk": "Барлық дағды",
    "ru": "Все направления"
  },
  "Level": {
    "kk": "Деңгей",
    "ru": "Уровень"
  },
  "All levels": {
    "kk": "Барлық деңгей",
    "ru": "Все уровни"
  },
  "Question type": {
    "kk": "Тапсырма түрі",
    "ru": "Тип задания"
  },
  "Practice": {
    "kk": "Жаттығу",
    "ru": "Практика"
  },
  "Assessment keys": {
    "kk": "Тест жауаптары",
    "ru": "Ключи тестов"
  },
  "All questions": {
    "kk": "Барлық сұрақ",
    "ru": "Все вопросы"
  },
  "Download content": {
    "kk": "Қорды жүктеу",
    "ru": "Скачать задания"
  },
  "Answer & explanation": {
    "kk": "Жауап пен түсіндірме",
    "ru": "Ответ и объяснение"
  },
  "Open rule lesson": {
    "kk": "Ереже сабағын ашу",
    "ru": "Открыть урок по правилу"
  },
  "No questions found": {
    "kk": "Сұрақ табылмады",
    "ru": "Вопросы не найдены"
  },
  "Try another word or clear the filters.": {
    "kk": "Басқа сөзді енгіз немесе сүзгілерді тазала.",
    "ru": "Попробуй другое слово или сбрось фильтры."
  },
  "Reset filters": {
    "kk": "Сүзгілерді тазалау",
    "ru": "Сбросить фильтры"
  },
  "Previous": {
    "kk": "Алдыңғы",
    "ru": "Назад"
  },
  "Write. Notice. Revise.": {
    "kk": "Жаз. Байқа. Түзет.",
    "ru": "Напиши. Заметь. Исправь."
  },
  "Write 3–6 sentences. Use the suggestions to make your own revision.": {
    "kk": "3–6 сөйлем жаз. Ұсыныстарды пайдаланып, мәтінді өзің түзет.",
    "ru": "Напиши 3–6 предложений и исправь текст с помощью рекомендаций."
  },
  "Your draft": {
    "kk": "Сенің мәтінің",
    "ru": "Твой черновик"
  },
  "Try an example": {
    "kk": "Үлгі мәтін",
    "ru": "Попробовать пример"
  },
  "English text": {
    "kk": "Ағылшынша мәтін",
    "ru": "Текст на английском"
  },
  "Write about your school, family or hobbies…": {
    "kk": "Мектебің, отбасың немесе хоббиің туралы ағылшынша жаз…",
    "ru": "Напиши по-английски о школе, семье или увлечениях…"
  },
  "Check draft": {
    "kk": "Мәтінді тексеру",
    "ru": "Проверить черновик"
  },
  "Save revision": {
    "kk": "Нұсқаны сақтау",
    "ru": "Сохранить версию"
  },
  "Use a learner code, not a real name or personal details.": {
    "kk": "Аты-жөн мен жеке деректің орнына оқушы кодын қолдан.",
    "ru": "Используй код ученика вместо имени и личных данных."
  },
  "Things to review": {
    "kk": "Тексеретін тұстар",
    "ru": "Что стоит проверить"
  },
  "Draft changed. Check it again.": {
    "kk": "Мәтін өзгерді. Қайта тексер.",
    "ru": "Текст изменён. Проверь его снова."
  },
  "Check your draft to see suggestions.": {
    "kk": "Ұсыныстарды көру үшін мәтінді тексер.",
    "ru": "Проверь черновик, чтобы увидеть рекомендации."
  },
  "No covered patterns found": {
    "kk": "Тексерілетін үлгілер бойынша қате табылмады",
    "ru": "Ошибок по доступным шаблонам не найдено"
  },
  "This is not a full grammar check. Ask your teacher to review meaning, word order and other errors.": {
    "kk": "Бұл толық грамматикалық тексеру емес. Мағынаны, сөз ретін және басқа қателерді мұғаліммен тексер.",
    "ru": "Это не полная проверка грамматики. Попроси учителя проверить смысл, порядок слов и другие ошибки."
  },
  "Your suggestions will appear here.": {
    "kk": "Ұсыныстар осы жерде көрсетіледі.",
    "ru": "Рекомендации появятся здесь."
  },
  "Previous suggestions are hidden until you check this draft.": {
    "kk": "Мәтінді қайта тексергенше бұрынғы ұсыныстар жасырылды.",
    "ru": "Предыдущие рекомендации скрыты до новой проверки."
  },
  "Saved revisions": {
    "kk": "Сақталған нұсқалар",
    "ru": "Сохранённые версии"
  },
  "What does the checker cover?": {
    "kk": "Талдағыш нені тексереді?",
    "ru": "Что проверяет анализатор?"
  },
  "Teacher workspace": {
    "kk": "Мұғалімнің жұмыс аймағы",
    "ru": "Рабочая область учителя"
  },
  "CYCLES": {
    "kk": "КЕЗЕҢДЕР",
    "ru": "ЦИКЛЫ"
  },
  "RULES CHECKED": {
    "kk": "ТЕКСЕРІЛГЕН ЕРЕЖЕЛЕР",
    "ru": "ПРОВЕРЕНО ПРАВИЛ"
  },
  "Assign a rule": {
    "kk": "Ереже тағайындау",
    "ru": "Назначить правило"
  },
  "A teacher assignment adds practice without changing the learner’s test scores.": {
    "kk": "Мұғалім тапсырмасы жаттығу қосады. Тест ұпайы өзгермейді.",
    "ru": "Назначение добавляет практику и не меняет баллы теста."
  },
  "Rule": {
    "kk": "Ереже",
    "ru": "Правило"
  },
  "Assign practice": {
    "kk": "Жаттығу тағайындау",
    "ru": "Назначить практику"
  },
  "A baseline is needed first.": {
    "kk": "Алдымен бастапқы тексеру қажет.",
    "ru": "Сначала нужна начальная проверка."
  },
  "This cycle is complete. Start a new cycle for new assignments.": {
    "kk": "Бұл кезең аяқталды. Жаңа тапсырма үшін жаңа кезеңді баста.",
    "ru": "Цикл завершён. Для новых назначений начни новый цикл."
  },
  "Assignments apply to the current cycle.": {
    "kk": "Тапсырмалар ағымдағы кезеңге беріледі.",
    "ru": "Назначения относятся к текущему циклу."
  },
  "Remove assignment": {
    "kk": "Тапсырманы алып тастау",
    "ru": "Убрать назначение"
  },
  "Teacher note": {
    "kk": "Мұғалім жазбасы",
    "ru": "Заметка учителя"
  },
  "Observation (autosaved)": {
    "kk": "Бақылау жазбасы (автоматты сақталады)",
    "ru": "Наблюдение (автосохранение)"
  },
  "Record a misconception or a next step…": {
    "kk": "Қате түсінікті немесе келесі қадамды жаз…",
    "ru": "Запишите затруднение или следующий шаг…"
  },
  "Cycle history": {
    "kk": "Кезеңдер тарихы",
    "ru": "История циклов"
  },
  "Current cycle": {
    "kk": "Ағымдағы кезең",
    "ru": "Текущий цикл"
  },
  "Previous cycle": {
    "kk": "Алдыңғы кезең",
    "ru": "Предыдущий цикл"
  },
  "Pending": {
    "kk": "Күтілуде",
    "ru": "Ожидается"
  },
  "No completed baseline yet.": {
    "kk": "Бастапқы тексеру әлі аяқталмаған.",
    "ru": "Начальная проверка ещё не завершена."
  },
  "Export answers (.csv)": {
    "kk": "Жауаптарды жүктеу (.csv)",
    "ru": "Скачать ответы (.csv)"
  },
  "Print report": {
    "kk": "Есепті басып шығару",
    "ru": "Распечатать отчёт"
  },
  "Practice evidence": {
    "kk": "Жаттығу нәтижелері",
    "ru": "Результаты практики"
  },
  "Reviewed": {
    "kk": "Тексерілді",
    "ru": "Проверено"
  },
  "Needs teacher review": {
    "kk": "Мұғалім тексеруі қажет",
    "ru": "Нужна проверка учителем"
  },
  "Rule explanation": {
    "kk": "Ережені түсіндіру",
    "ru": "Объяснение правила"
  },
  "New sentence": {
    "kk": "Жаңа сөйлем",
    "ru": "Новое предложение"
  },
  "I reviewed the explanation and example": {
    "kk": "Түсіндірме мен мысалды тексердім",
    "ru": "Я проверил объяснение и пример"
  },
  "Completed lessons will appear here.": {
    "kk": "Аяқталған сабақтар осында көрсетіледі.",
    "ru": "Завершённые уроки появятся здесь."
  },
  "Profiles & backups": {
    "kk": "Профильдер мен сақтық көшірмелер",
    "ru": "Профили и резервные копии"
  },
  "Download backup": {
    "kk": "Сақтық көшірмені жүктеу",
    "ru": "Скачать резервную копию"
  },
  "Restore backup": {
    "kk": "Көшірмеден қалпына келтіру",
    "ru": "Восстановить копию"
  },
  "Clear this learner’s data": {
    "kk": "Осы оқушының деректерін тазалау",
    "ru": "Очистить данные этого ученика"
  },
  "How to read progress": {
    "kk": "Нәтижені қалай түсінеміз?",
    "ru": "Как читать результаты?"
  },
  "About ErrorMap": {
    "kk": "ErrorMap туралы",
    "ru": "Об ErrorMap"
  },
  "English · Grade 7 · School No. 22": {
    "kk": "Ағылшын тілі · 7-сынып · №22 мектеп",
    "ru": "Английский язык · 7 класс · Школа №22"
  },
  "Turning language errors into a personal learning path.": {
    "kk": "Тілдік қателерден жеке оқу бағытын құру.",
    "ru": "Индивидуальный маршрут на основе языковых ошибок."
  },
  "How the learning cycle works": {
    "kk": "Оқу кезеңі қалай өтеді?",
    "ru": "Как устроен учебный цикл?"
  },
  "Baseline.": {
    "kk": "Бастапқы тексеру.",
    "ru": "Начальная проверка."
  },
  "Practice.": {
    "kk": "Жаттығу.",
    "ru": "Практика."
  },
  "Rule check.": {
    "kk": "Ережені тексеру.",
    "ru": "Проверка правила."
  },
  "Recheck.": {
    "kk": "Қайта тексеру.",
    "ru": "Повторная проверка."
  },
  "What is in the question bank?": {
    "kk": "Тапсырмалар қорында не бар?",
    "ru": "Что входит в банк заданий?"
  },
  "What is saved?": {
    "kk": "Не сақталады?",
    "ru": "Что сохраняется?"
  },
  "What still needs teacher judgement?": {
    "kk": "Мұғалім нені бағалайды?",
    "ru": "Что оценивает учитель?"
  },
  "One baseline question is a starting signal, not a mastery judgement.": {
    "kk": "Бір сұрақ тек бастапқы бағдар береді.",
    "ru": "Один вопрос даёт лишь начальный ориентир."
  },
  "No baseline yet": {
    "kk": "Бастапқы нәтиже жоқ",
    "ru": "Начального результата пока нет"
  },
  "Complete your baseline to build a plan.": {
    "kk": "Оқу бағытын құру үшін бастапқы тексеруден өт.",
    "ru": "Пройди начальную проверку, чтобы построить маршрут."
  },
  "Resume baseline": {
    "kk": "Бастапқы тексеруді жалғастыру",
    "ru": "Продолжить начальную проверку"
  },
  "Resume recheck": {
    "kk": "Қайта тексеруді жалғастыру",
    "ru": "Продолжить повторную проверку"
  },
  "Resume rule check": {
    "kk": "Ереже тексеруін жалғастыру",
    "ru": "Продолжить проверку правила"
  },
  "Resume practice": {
    "kk": "Жаттығуды жалғастыру",
    "ru": "Продолжить практику"
  },
  "Third-person -s / -es": {
    "kk": "Үшінші жақтағы -s / -es",
    "ru": "-s / -es в третьем лице"
  },
  "In the present simple, add -s or -es after he, she, it or a singular subject. Change consonant + y to -ies.": {
    "kk": "Present Simple шағында he, she, it және жекеше бастауышпен етістікке -s/-es жалғанады. Дауыссыздан кейінгі y әрпі -ies болып өзгереді.",
    "ru": "В Present Simple после he, she, it и подлежащего в единственном числе добавляется -s/-es. После согласной y меняется на -ies."
  },
  "My sister is one person. Study changes to studies after a singular third-person subject.": {
    "kk": "Дұрыс жауап: «studies». Present Simple шағында he, she, it және жекеше бастауышпен етістікке -s/-es жалғанады. Дауыссыздан кейінгі y әрпі -ies болып өзгереді.",
    "ru": "Правильный ответ: «studies». В Present Simple после he, she, it и подлежащего в единственном числе добавляется -s/-es. После согласной y меняется на -ies."
  },
  "My brother is one person. Add -s: plays.": {
    "kk": "Дұрыс жауап: «plays». Present Simple шағында he, she, it және жекеше бастауышпен етістікке -s/-es жалғанады. Дауыссыздан кейінгі y әрпі -ies болып өзгереді.",
    "ru": "Правильный ответ: «plays». В Present Simple после he, she, it и подлежащего в единственном числе добавляется -s/-es. После согласной y меняется на -ies."
  },
  "Our teacher is singular, so the present-simple form is explains.": {
    "kk": "Дұрыс жауап: «explains». Present Simple шағында he, she, it және жекеше бастауышпен етістікке -s/-es жалғанады. Дауыссыздан кейінгі y әрпі -ies болып өзгереді.",
    "ru": "Правильный ответ: «explains». В Present Simple после he, she, it и подлежащего в единственном числе добавляется -s/-es. После согласной y меняется на -ies."
  },
  "The bus is singular. Add -s: arrives.": {
    "kk": "Дұрыс жауап: «arrives». Present Simple шағында he, she, it және жекеше бастауышпен етістікке -s/-es жалғанады. Дауыссыздан кейінгі y әрпі -ies болып өзгереді.",
    "ru": "Правильный ответ: «arrives». В Present Simple после he, she, it и подлежащего в единственном числе добавляется -s/-es. После согласной y меняется на -ies."
  },
  "Watch ends in -ch. Add -es after a singular subject: watches.": {
    "kk": "Дұрыс жауап: «watches». Present Simple шағында he, she, it және жекеше бастауышпен етістікке -s/-es жалғанады. Дауыссыздан кейінгі y әрпі -ies болып өзгереді.",
    "ru": "Правильный ответ: «watches». В Present Simple после he, she, it и подлежащего в единственном числе добавляется -s/-es. После согласной y меняется на -ies."
  },
  "Fly ends in consonant + y. Change y to -ies: flies.": {
    "kk": "Дұрыс жауап: «flies». Present Simple шағында he, she, it және жекеше бастауышпен етістікке -s/-es жалғанады. Дауыссыздан кейінгі y әрпі -ies болып өзгереді.",
    "ru": "Правильный ответ: «flies». В Present Simple после he, she, it и подлежащего в единственном числе добавляется -s/-es. После согласной y меняется на -ies."
  },
  "My father is singular. The correct form is works.": {
    "kk": "Дұрыс жауап: «works». Present Simple шағында he, she, it және жекеше бастауышпен етістікке -s/-es жалғанады. Дауыссыздан кейінгі y әрпі -ies болып өзгереді.",
    "ru": "Правильный ответ: «works». В Present Simple после he, she, it и подлежащего в единственном числе добавляется -s/-es. После согласной y меняется на -ies."
  },
  "Brush ends in -sh, so add -es: brushes.": {
    "kk": "Дұрыс жауап: «brushes». Present Simple шағында he, she, it және жекеше бастауышпен етістікке -s/-es жалғанады. Дауыссыздан кейінгі y әрпі -ies болып өзгереді.",
    "ru": "Правильный ответ: «brushes». В Present Simple после he, she, it и подлежащего в единственном числе добавляется -s/-es. После согласной y меняется на -ies."
  },
  "Catch ends in -ch, so add -es after a singular subject.": {
    "kk": "Дұрыс жауап: «catches». Present Simple шағында he, she, it және жекеше бастауышпен етістікке -s/-es жалғанады. Дауыссыздан кейінгі y әрпі -ies болып өзгереді.",
    "ru": "Правильный ответ: «catches». В Present Simple после he, she, it и подлежащего в единственном числе добавляется -s/-es. После согласной y меняется на -ies."
  },
  "Change consonant + y to -ies: cry becomes cries.": {
    "kk": "Дұрыс жауап: «cries». Present Simple шағында he, she, it және жекеше бастауышпен етістікке -s/-es жалғанады. Дауыссыздан кейінгі y әрпі -ies болып өзгереді.",
    "ru": "Правильный ответ: «cries». В Present Simple после he, she, it и подлежащего в единственном числе добавляется -s/-es. После согласной y меняется на -ies."
  },
  "Base verbs after auxiliaries": {
    "kk": "Көмекші етістіктен кейінгі бастапқы тұлға",
    "ru": "Начальная форма после вспомогательных глаголов"
  },
  "After do, does, did, do not, does not or did not, use the base form of the main verb.": {
    "kk": "Do, does, did және олардың болымсыз түрлерінен кейін негізгі етістік бастапқы тұлғада тұрады.",
    "ru": "После do, does, did и их отрицательных форм основной глагол употребляется в начальной форме."
  },
  "Does already marks the question. Use the base form speak.": {
    "kk": "Дұрыс жауап: «speak». Do, does, did және олардың болымсыз түрлерінен кейін негізгі етістік бастапқы тұлғада тұрады.",
    "ru": "Правильный ответ: «speak». После do, does, did и их отрицательных форм основной глагол употребляется в начальной форме."
  },
  "Use the base form play after does.": {
    "kk": "Дұрыс жауап: «play». Do, does, did және олардың болымсыз түрлерінен кейін негізгі етістік бастапқы тұлғада тұрады.",
    "ru": "Правильный ответ: «play». После do, does, did и их отрицательных форм основной глагол употребляется в начальной форме."
  },
  "After does not, the main verb stays in its base form: drink.": {
    "kk": "Дұрыс жауап: «drink». Do, does, did және олардың болымсыз түрлерінен кейін негізгі етістік бастапқы тұлғада тұрады.",
    "ru": "Правильный ответ: «drink». После do, does, did и их отрицательных форм основной глагол употребляется в начальной форме."
  },
  "Use give, not gives, after does not.": {
    "kk": "Дұрыс жауап: «give». Do, does, did және олардың болымсыз түрлерінен кейін негізгі етістік бастапқы тұлғада тұрады.",
    "ru": "Правильный ответ: «give». После do, does, did и их отрицательных форм основной глагол употребляется в начальной форме."
  },
  "Did marks the past tense. The main verb must be see.": {
    "kk": "Дұрыс жауап: «see». Do, does, did және олардың болымсыз түрлерінен кейін негізгі етістік бастапқы тұлғада тұрады.",
    "ru": "Правильный ответ: «see». После do, does, did и их отрицательных форм основной глагол употребляется в начальной форме."
  },
  "Use the base form go after did.": {
    "kk": "Дұрыс жауап: «go». Do, does, did және олардың болымсыз түрлерінен кейін негізгі етістік бастапқы тұлғада тұрады.",
    "ru": "Правильный ответ: «go». После do, does, did и их отрицательных форм основной глагол употребляется в начальной форме."
  },
  "Use the base form enjoy after do.": {
    "kk": "Дұрыс жауап: «enjoy». Do, does, did және олардың болымсыз түрлерінен кейін негізгі етістік бастапқы тұлғада тұрады.",
    "ru": "Правильный ответ: «enjoy». После do, does, did и их отрицательных форм основной глагол употребляется в начальной форме."
  },
  "Use open after did not.": {
    "kk": "Дұрыс жауап: «open». Do, does, did және олардың болымсыз түрлерінен кейін негізгі етістік бастапқы тұлғада тұрады.",
    "ru": "Правильный ответ: «open». После do, does, did и их отрицательных форм основной глагол употребляется в начальной форме."
  },
  "Does is followed by have, not has.": {
    "kk": "Дұрыс жауап: «have». Do, does, did және олардың болымсыз түрлерінен кейін негізгі етістік бастапқы тұлғада тұрады.",
    "ru": "Правильный ответ: «have». После do, does, did и их отрицательных форм основной глагол употребляется в начальной форме."
  },
  "Use the base form wear after do not.": {
    "kk": "Дұрыс жауап: «wear». Do, does, did және олардың болымсыз түрлерінен кейін негізгі етістік бастапқы тұлғада тұрады.",
    "ru": "Правильный ответ: «wear». После do, does, did и их отрицательных форм основной глагол употребляется в начальной форме."
  },
  "Forms of be": {
    "kk": "Be етістігінің тұлғалары",
    "ru": "Формы глагола be"
  },
  "Match be to the subject and time: I am; he/she/it is; we/you/they are. In the past, use was with I/he/she/it and were with we/you/they.": {
    "kk": "Осы шақта: I am; he/she/it is; we/you/they are. Өткен шақта I/he/she/it үшін was, we/you/they үшін were қолданылады.",
    "ru": "В настоящем: I am; he/she/it is; we/you/they are. В прошлом: was с I/he/she/it и were с we/you/they."
  },
  "The present form of be after I is am.": {
    "kk": "Дұрыс жауап: «am». Осы шақта: I am; he/she/it is; we/you/they are. Өткен шақта I/he/she/it үшін was, we/you/they үшін were қолданылады.",
    "ru": "Правильный ответ: «am». В настоящем: I am; he/she/it is; we/you/they are. В прошлом: was с I/he/she/it и were с we/you/they."
  },
  "Use is with she in the present.": {
    "kk": "Дұрыс жауап: «is». Осы шақта: I am; he/she/it is; we/you/they are. Өткен шақта I/he/she/it үшін was, we/you/they үшін were қолданылады.",
    "ru": "Правильный ответ: «is». В настоящем: I am; he/she/it is; we/you/they are. В прошлом: was с I/he/she/it и were с we/you/they."
  },
  "The students is plural, so use are.": {
    "kk": "Дұрыс жауап: «are». Осы шақта: I am; he/she/it is; we/you/they are. Өткен шақта I/he/she/it үшін was, we/you/they үшін were қолданылады.",
    "ru": "Правильный ответ: «are». В настоящем: I am; he/she/it is; we/you/they are. В прошлом: was с I/he/she/it и were с we/you/they."
  },
  "My brother and I means we. Use are.": {
    "kk": "Дұрыс жауап: «are». Осы шақта: I am; he/she/it is; we/you/they are. Өткен шақта I/he/she/it үшін was, we/you/they үшін were қолданылады.",
    "ru": "Правильный ответ: «are». В настоящем: I am; he/she/it is; we/you/they are. В прошлом: was с I/he/she/it и were с we/you/they."
  },
  "Last Sunday is past time. The past form with we is were.": {
    "kk": "Дұрыс жауап: «were». Осы шақта: I am; he/she/it is; we/you/they are. Өткен шақта I/he/she/it үшін was, we/you/they үшін were қолданылады.",
    "ru": "Правильный ответ: «were». В настоящем: I am; he/she/it is; we/you/they are. В прошлом: was с I/he/she/it и were с we/you/they."
  },
  "Use was with he for a completed past situation.": {
    "kk": "Дұрыс жауап: «was». Осы шақта: I am; he/she/it is; we/you/they are. Өткен шақта I/he/she/it үшін was, we/you/they үшін were қолданылады.",
    "ru": "Правильный ответ: «was». В настоящем: I am; he/she/it is; we/you/they are. В прошлом: was с I/he/she/it и were с we/you/they."
  },
  "These shoes is plural. Use are.": {
    "kk": "Дұрыс жауап: «are». Осы шақта: I am; he/she/it is; we/you/they are. Өткен шақта I/he/she/it үшін was, we/you/they үшін were қолданылады.",
    "ru": "Правильный ответ: «are». В настоящем: I am; he/she/it is; we/you/they are. В прошлом: was с I/he/she/it и were с we/you/they."
  },
  "Yesterday requires past tense. Use were with the boys.": {
    "kk": "Дұрыс жауап: «were». Осы шақта: I am; he/she/it is; we/you/they are. Өткен шақта I/he/she/it үшін was, we/you/they үшін were қолданылады.",
    "ru": "Правильный ответ: «were». В настоящем: I am; he/she/it is; we/you/they are. В прошлом: was с I/he/she/it и were с we/you/they."
  },
  "Everyone takes a singular verb: is.": {
    "kk": "Дұрыс жауап: «is». Осы шақта: I am; he/she/it is; we/you/they are. Өткен шақта I/he/she/it үшін was, we/you/they үшін were қолданылады.",
    "ru": "Правильный ответ: «is». В настоящем: I am; he/she/it is; we/you/they are. В прошлом: was с I/he/she/it и were с we/you/they."
  },
  "Neither answer refers to each answer separately and takes is.": {
    "kk": "Дұрыс жауап: «is». Осы шақта: I am; he/she/it is; we/you/they are. Өткен шақта I/he/she/it үшін was, we/you/they үшін were қолданылады.",
    "ru": "Правильный ответ: «is». В настоящем: I am; he/she/it is; we/you/they are. В прошлом: was с I/he/she/it и were с we/you/they."
  },
  "Have, has and there is / are": {
    "kk": "Have, has және there is / are",
    "ru": "Have, has и there is / are"
  },
  "Use has with he/she/it or a singular subject; use have with I/you/we/they. Use there is for one thing and there are for more than one.": {
    "kk": "He/she/it және жекеше бастауышпен has, қалғандарымен have қолданылады. Бір затпен there is, бірнеше затпен there are болады.",
    "ru": "С he/she/it и единственным числом используется has, с остальными — have. There is употребляется с одним предметом, there are — с несколькими."
  },
  "My dog is singular. Use has.": {
    "kk": "Дұрыс жауап: «has». He/she/it және жекеше бастауышпен has, қалғандарымен have қолданылады. Бір затпен there is, бірнеше затпен there are болады.",
    "ru": "Правильный ответ: «has». С he/she/it и единственным числом используется has, с остальными — have. There is употребляется с одним предметом, there are — с несколькими."
  },
  "My sister is singular. Use has.": {
    "kk": "Дұрыс жауап: «has». He/she/it және жекеше бастауышпен has, қалғандарымен have қолданылады. Бір затпен there is, бірнеше затпен there are болады.",
    "ru": "Правильный ответ: «has». С he/she/it и единственным числом используется has, с остальными — have. There is употребляется с одним предметом, there are — с несколькими."
  },
  "The students is plural. Use have.": {
    "kk": "Дұрыс жауап: «have». He/she/it және жекеше бастауышпен has, қалғандарымен have қолданылады. Бір затпен there is, бірнеше затпен there are болады.",
    "ru": "Правильный ответ: «have». С he/she/it и единственным числом используется has, с остальными — have. There is употребляется с одним предметом, there are — с несколькими."
  },
  "My parents is plural. Use have.": {
    "kk": "Дұрыс жауап: «have». He/she/it және жекеше бастауышпен has, қалғандарымен have қолданылады. Бір затпен there is, бірнеше затпен there are болады.",
    "ru": "Правильный ответ: «have». С he/she/it и единственным числом используется has, с остальными — have. There is употребляется с одним предметом, there are — с несколькими."
  },
  "A book is one thing. Use there is.": {
    "kk": "Дұрыс жауап: «is». He/she/it және жекеше бастауышпен has, қалғандарымен have қолданылады. Бір затпен there is, бірнеше затпен there are болады.",
    "ru": "Правильный ответ: «is». С he/she/it и единственным числом используется has, с остальными — have. There is употребляется с одним предметом, there are — с несколькими."
  },
  "Two windows is plural. Use there are.": {
    "kk": "Дұрыс жауап: «are». He/she/it және жекеше бастауышпен has, қалғандарымен have қолданылады. Бір затпен there is, бірнеше затпен there are болады.",
    "ru": "Правильный ответ: «are». С he/she/it и единственным числом используется has, с остальными — have. There is употребляется с одним предметом, there are — с несколькими."
  },
  "Use have with I.": {
    "kk": "Дұрыс жауап: «have». He/she/it және жекеше бастауышпен has, қалғандарымен have қолданылады. Бір затпен there is, бірнеше затпен there are болады.",
    "ru": "Правильный ответ: «have». С he/she/it и единственным числом используется has, с остальными — have. There is употребляется с одним предметом, there are — с несколькими."
  },
  "The classroom is one room. Use has.": {
    "kk": "Дұрыс жауап: «has». He/she/it және жекеше бастауышпен has, қалғандарымен have қолданылады. Бір затпен there is, бірнеше затпен there are болады.",
    "ru": "Правильный ответ: «has». С he/she/it и единственным числом используется has, с остальными — have. There is употребляется с одним предметом, there are — с несколькими."
  },
  "Milk is uncountable. Use there is.": {
    "kk": "Дұрыс жауап: «is». He/she/it және жекеше бастауышпен has, қалғандарымен have қолданылады. Бір затпен there is, бірнеше затпен there are болады.",
    "ru": "Правильный ответ: «is». С he/she/it и единственным числом используется has, с остальными — have. There is употребляется с одним предметом, there are — с несколькими."
  },
  "People is plural. Use there are.": {
    "kk": "Дұрыс жауап: «are». He/she/it және жекеше бастауышпен has, қалғандарымен have қолданылады. Бір затпен there is, бірнеше затпен there are болады.",
    "ru": "Правильный ответ: «are». С he/she/it и единственным числом используется has, с остальными — have. There is употребляется с одним предметом, there are — с несколькими."
  },
  "Completed past actions": {
    "kk": "Аяқталған өткен әрекет",
    "ru": "Завершённые действия в прошлом"
  },
  "Use the past simple for completed actions at a past time. Regular verbs end in -ed; some verbs have irregular past forms.": {
    "kk": "Аяқталған өткен әрекет үшін Past Simple қолданылады. Дұрыс етістіктерге -ed жалғанады, бұрыс етістіктердің тұлғасын есте сақтау қажет.",
    "ru": "Для завершённых действий в прошлом используется Past Simple. К правильным глаголам добавляется -ed, формы неправильных нужно запомнить."
  },
  "Yesterday is a finished past time. Use visited.": {
    "kk": "Дұрыс жауап: «visited». Аяқталған өткен әрекет үшін Past Simple қолданылады. Дұрыс етістіктерге -ed жалғанады, бұрыс етістіктердің тұлғасын есте сақтау қажет.",
    "ru": "Правильный ответ: «visited». Для завершённых действий в прошлом используется Past Simple. К правильным глаголам добавляется -ed, формы неправильных нужно запомнить."
  },
  "Last night is finished. Use the past form watched.": {
    "kk": "Дұрыс жауап: «watched». Аяқталған өткен әрекет үшін Past Simple қолданылады. Дұрыс етістіктерге -ed жалғанады, бұрыс етістіктердің тұлғасын есте сақтау қажет.",
    "ru": "Правильный ответ: «watched». Для завершённых действий в прошлом используется Past Simple. К правильным глаголам добавляется -ed, формы неправильных нужно запомнить."
  },
  "Last week is past time. The past of write is wrote.": {
    "kk": "Дұрыс жауап: «wrote». Аяқталған өткен әрекет үшін Past Simple қолданылады. Дұрыс етістіктерге -ed жалғанады, бұрыс етістіктердің тұлғасын есте сақтау қажет.",
    "ru": "Правильный ответ: «wrote». Для завершённых действий в прошлом используется Past Simple. К правильным глаголам добавляется -ed, формы неправильных нужно запомнить."
  },
  "Last summer is past time. The past of go is went.": {
    "kk": "Дұрыс жауап: «went». Аяқталған өткен әрекет үшін Past Simple қолданылады. Дұрыс етістіктерге -ed жалғанады, бұрыс етістіктердің тұлғасын есте сақтау қажет.",
    "ru": "Правильный ответ: «went». Для завершённых действий в прошлом используется Past Simple. К правильным глаголам добавляется -ed, формы неправильных нужно запомнить."
  },
  "Ago refers to a completed past time. Find becomes found.": {
    "kk": "Дұрыс жауап: «found». Аяқталған өткен әрекет үшін Past Simple қолданылады. Дұрыс етістіктерге -ed жалғанады, бұрыс етістіктердің тұлғасын есте сақтау қажет.",
    "ru": "Правильный ответ: «found». Для завершённых действий в прошлом используется Past Simple. К правильным глаголам добавляется -ed, формы неправильных нужно запомнить."
  },
  "Last winter is past time. Break becomes broke.": {
    "kk": "Дұрыс жауап: «broke». Аяқталған өткен әрекет үшін Past Simple қолданылады. Дұрыс етістіктерге -ed жалғанады, бұрыс етістіктердің тұлғасын есте сақтау қажет.",
    "ru": "Правильный ответ: «broke». Для завершённых действий в прошлом используется Past Simple. К правильным глаголам добавляется -ed, формы неправильных нужно запомнить."
  },
  "Use the past form started with yesterday.": {
    "kk": "Дұрыс жауап: «started». Аяқталған өткен әрекет үшін Past Simple қолданылады. Дұрыс етістіктерге -ed жалғанады, бұрыс етістіктердің тұлғасын есте сақтау қажет.",
    "ru": "Правильный ответ: «started». Для завершённых действий в прошлом используется Past Simple. К правильным глаголам добавляется -ed, формы неправильных нужно запомнить."
  },
  "The completed past time needs bought, the past of buy.": {
    "kk": "Дұрыс жауап: «bought». Аяқталған өткен әрекет үшін Past Simple қолданылады. Дұрыс етістіктерге -ed жалғанады, бұрыс етістіктердің тұлғасын есте сақтау қажет.",
    "ru": "Правильный ответ: «bought». Для завершённых действий в прошлом используется Past Simple. К правильным глаголам добавляется -ed, формы неправильных нужно запомнить."
  },
  "The past form of have is had.": {
    "kk": "Дұрыс жауап: «had». Аяқталған өткен әрекет үшін Past Simple қолданылады. Дұрыс етістіктерге -ed жалғанады, бұрыс етістіктердің тұлғасын есте сақтау қажет.",
    "ru": "Правильный ответ: «had». Для завершённых действий в прошлом используется Past Simple. К правильным глаголам добавляется -ed, формы неправильных нужно запомнить."
  },
  "A finished year calls for the past simple: moved.": {
    "kk": "Дұрыс жауап: «moved». Аяқталған өткен әрекет үшін Past Simple қолданылады. Дұрыс етістіктерге -ed жалғанады, бұрыс етістіктердің тұлғасын есте сақтау қажет.",
    "ru": "Правильный ответ: «moved». Для завершённых действий в прошлом используется Past Simple. К правильным глаголам добавляется -ed, формы неправильных нужно запомнить."
  },
  "Actions happening now": {
    "kk": "Қазір жүріп жатқан әрекет",
    "ru": "Действия прямо сейчас"
  },
  "For an action happening now, use am/is/are + verb-ing. Match the auxiliary to the subject.": {
    "kk": "Қазір жүріп жатқан әрекет үшін am/is/are + етістік-ing қолданылады. Көмекші етістікті бастауышқа сәйкестендір.",
    "ru": "Для действия прямо сейчас используется am/is/are + глагол-ing. Форма вспомогательного глагола зависит от подлежащего."
  },
  "Look points to an action happening now. Use are playing.": {
    "kk": "Дұрыс жауап: «are playing». Қазір жүріп жатқан әрекет үшін am/is/are + етістік-ing қолданылады. Көмекші етістікті бастауышқа сәйкестендір.",
    "ru": "Правильный ответ: «are playing». Для действия прямо сейчас используется am/is/are + глагол-ing. Форма вспомогательного глагола зависит от подлежащего."
  },
  "Now needs is sleeping for this ongoing action.": {
    "kk": "Дұрыс жауап: «is sleeping». Қазір жүріп жатқан әрекет үшін am/is/are + етістік-ing қолданылады. Көмекші етістікті бастауышқа сәйкестендір.",
    "ru": "Правильный ответ: «is sleeping». Для действия прямо сейчас используется am/is/are + глагол-ing. Форма вспомогательного глагола зависит от подлежащего."
  },
  "At the moment describes an ongoing action: are writing.": {
    "kk": "Дұрыс жауап: «are writing». Қазір жүріп жатқан әрекет үшін am/is/are + етістік-ing қолданылады. Көмекші етістікті бастауышқа сәйкестендір.",
    "ru": "Правильный ответ: «are writing». Для действия прямо сейчас используется am/is/are + глагол-ing. Форма вспомогательного глагола зависит от подлежащего."
  },
  "Listen points to what is happening now: is playing.": {
    "kk": "Дұрыс жауап: «is playing». Қазір жүріп жатқан әрекет үшін am/is/are + етістік-ing қолданылады. Көмекші етістікті бастауышқа сәйкестендір.",
    "ru": "Правильный ответ: «is playing». Для действия прямо сейчас используется am/is/are + глагол-ing. Форма вспомогательного глагола зависит от подлежащего."
  },
  "Right now refers to an action in progress: is leaving.": {
    "kk": "Дұрыс жауап: «is leaving». Қазір жүріп жатқан әрекет үшін am/is/are + етістік-ing қолданылады. Көмекші етістікті бастауышқа сәйкестендір.",
    "ru": "Правильный ответ: «is leaving». Для действия прямо сейчас используется am/is/are + глагол-ing. Форма вспомогательного глагола зависит от подлежащего."
  },
  "The action is happening in front of us: is drawing.": {
    "kk": "Дұрыс жауап: «is drawing». Қазір жүріп жатқан әрекет үшін am/is/are + етістік-ing қолданылады. Көмекші етістікті бастауышқа сәйкестендір.",
    "ru": "Правильный ответ: «is drawing». Для действия прямо сейчас используется am/is/are + глагол-ing. Форма вспомогательного глагола зависит от подлежащего."
  },
  "Use am with I, followed by doing.": {
    "kk": "Дұрыс жауап: «am doing». Қазір жүріп жатқан әрекет үшін am/is/are + етістік-ing қолданылады. Көмекші етістікті бастауышқа сәйкестендір.",
    "ru": "Правильный ответ: «am doing». Для действия прямо сейчас используется am/is/are + глагол-ing. Форма вспомогательного глагола зависит от подлежащего."
  },
  "The children is plural. Use are making.": {
    "kk": "Дұрыс жауап: «are making». Қазір жүріп жатқан әрекет үшін am/is/are + етістік-ing қолданылады. Көмекші етістікті бастауышқа сәйкестендір.",
    "ru": "Правильный ответ: «are making». Для действия прямо сейчас используется am/is/are + глагол-ing. Форма вспомогательного глагола зависит от подлежащего."
  },
  "Now identifies the ongoing action: am talking.": {
    "kk": "Дұрыс жауап: «am talking». Қазір жүріп жатқан әрекет үшін am/is/are + етістік-ing қолданылады. Көмекші етістікті бастауышқа сәйкестендір.",
    "ru": "Правильный ответ: «am talking». Для действия прямо сейчас используется am/is/are + глагол-ing. Форма вспомогательного глагола зависит от подлежащего."
  },
  "For the action she is doing now, use is cooking.": {
    "kk": "Дұрыс жауап: «is cooking». Қазір жүріп жатқан әрекет үшін am/is/are + етістік-ing қолданылады. Көмекші етістікті бастауышқа сәйкестендір.",
    "ru": "Правильный ответ: «is cooking». Для действия прямо сейчас используется am/is/are + глагол-ing. Форма вспомогательного глагола зависит от подлежащего."
  },
  "Actions in progress in the past": {
    "kk": "Өткен сәтте жүріп жатқан әрекет",
    "ru": "Действие в процессе в прошлом"
  },
  "Use was/were + verb-ing for an action in progress at a past moment. A shorter event can interrupt it.": {
    "kk": "Өткен уақыттың белгілі сәтінде жүріп жатқан әрекет was/were + етістік-ing арқылы беріледі. Қысқа оқиға оны бөлуі мүмкін.",
    "ru": "Действие в процессе в определённый момент прошлого выражается через was/were + глагол-ing. Его может прерывать короткое событие."
  },
  "At a specific past moment, use were playing.": {
    "kk": "Дұрыс жауап: «were playing». Өткен уақыттың белгілі сәтінде жүріп жатқан әрекет was/were + етістік-ing арқылы беріледі. Қысқа оқиға оны бөлуі мүмкін.",
    "ru": "Правильный ответ: «were playing». Действие в процессе в определённый момент прошлого выражается через was/were + глагол-ing. Его может прерывать короткое событие."
  },
  "At a past moment, use was cooking with she.": {
    "kk": "Дұрыс жауап: «was cooking». Өткен уақыттың белгілі сәтінде жүріп жатқан әрекет was/were + етістік-ing арқылы беріледі. Қысқа оқиға оны бөлуі мүмкін.",
    "ru": "Правильный ответ: «was cooking». Действие в процессе в определённый момент прошлого выражается через was/were + глагол-ing. Его может прерывать короткое событие."
  },
  "The shower was in progress when the phone rang.": {
    "kk": "Дұрыс жауап: «was taking». Өткен уақыттың белгілі сәтінде жүріп жатқан әрекет was/were + етістік-ing арқылы беріледі. Қысқа оқиға оны бөлуі мүмкін.",
    "ru": "Правильный ответ: «was taking». Действие в процессе в определённый момент прошлого выражается через was/were + глагол-ing. Его может прерывать короткое событие."
  },
  "The homework was in progress when the lights went out.": {
    "kk": "Дұрыс жауап: «was doing». Өткен уақыттың белгілі сәтінде жүріп жатқан әрекет was/were + етістік-ing арқылы беріледі. Қысқа оқиға оны бөлуі мүмкін.",
    "ru": "Правильный ответ: «was doing». Действие в процессе в определённый момент прошлого выражается через was/were + глагол-ing. Его может прерывать короткое событие."
  },
  "Two ongoing past actions can use the past continuous.": {
    "kk": "Дұрыс жауап: «was watching». Өткен уақыттың белгілі сәтінде жүріп жатқан әрекет was/were + етістік-ing арқылы беріледі. Қысқа оқиға оны бөлуі мүмкін.",
    "ru": "Правильный ответ: «was watching». Действие в процессе в определённый момент прошлого выражается через was/were + глагол-ing. Его может прерывать короткое событие."
  },
  "The actions were happening together in the past. Use were setting.": {
    "kk": "Дұрыс жауап: «were setting». Өткен уақыттың белгілі сәтінде жүріп жатқан әрекет was/were + етістік-ing арқылы беріледі. Қысқа оқиға оны бөлуі мүмкін.",
    "ru": "Правильный ответ: «were setting». Действие в процессе в определённый момент прошлого выражается через was/were + глагол-ing. Его может прерывать короткое событие."
  },
  "Use was studying for an action in progress at that past time.": {
    "kk": "Дұрыс жауап: «was studying». Өткен уақыттың белгілі сәтінде жүріп жатқан әрекет was/were + етістік-ing арқылы беріледі. Қысқа оқиға оны бөлуі мүмкін.",
    "ru": "Правильный ответ: «was studying». Действие в процессе в определённый момент прошлого выражается через was/were + глагол-ing. Его может прерывать короткое событие."
  },
  "The walk was in progress when the rain started.": {
    "kk": "Дұрыс жауап: «were walking». Өткен уақыттың белгілі сәтінде жүріп жатқан әрекет was/were + етістік-ing арқылы беріледі. Қысқа оқиға оны бөлуі мүмкін.",
    "ru": "Правильный ответ: «were walking». Действие в процессе в определённый момент прошлого выражается через was/were + глагол-ing. Его может прерывать короткое событие."
  },
  "The listening was in progress at the time of the doorbell.": {
    "kk": "Дұрыс жауап: «was listening to». Өткен уақыттың белгілі сәтінде жүріп жатқан әрекет was/were + етістік-ing арқылы беріледі. Қысқа оқиға оны бөлуі мүмкін.",
    "ru": "Правильный ответ: «was listening to». Действие в процессе в определённый момент прошлого выражается через was/were + глагол-ing. Его может прерывать короткое событие."
  },
  "At this time yesterday calls for the past continuous.": {
    "kk": "Дұрыс жауап: «were sitting». Өткен уақыттың белгілі сәтінде жүріп жатқан әрекет was/were + етістік-ing арқылы беріледі. Қысқа оқиға оны бөлуі мүмкін.",
    "ru": "Правильный ответ: «were sitting». Действие в процессе в определённый момент прошлого выражается через was/were + глагол-ing. Его может прерывать короткое событие."
  },
  "Experience and recent results": {
    "kk": "Тәжірибе және қазіргі нәтиже",
    "ru": "Опыт и результат к настоящему"
  },
  "Use have/has + past participle for experiences or past actions linked to now. Words such as ever, never, just, already and yet often help.": {
    "kk": "Тәжірибе немесе қазіргі уақытпен байланысты өткен әрекет have/has + past participle арқылы беріледі. Ever, never, just, already, yet сөздеріне назар аудар.",
    "ru": "Для опыта или прошлого действия, связанного с настоящим, используется have/has + третья форма глагола. Обращай внимание на ever, never, just, already, yet."
  },
  "Has needs the past participle been.": {
    "kk": "Дұрыс жауап: «been». Тәжірибе немесе қазіргі уақытпен байланысты өткен әрекет have/has + past participle арқылы беріледі. Ever, never, just, already, yet сөздеріне назар аудар.",
    "ru": "Правильный ответ: «been». Для опыта или прошлого действия, связанного с настоящим, используется have/has + третья форма глагола. Обращай внимание на ever, never, just, already, yet."
  },
  "Have needs the past participle seen.": {
    "kk": "Дұрыс жауап: «seen». Тәжірибе немесе қазіргі уақытпен байланысты өткен әрекет have/has + past participle арқылы беріледі. Ever, never, just, already, yet сөздеріне назар аудар.",
    "ru": "Правильный ответ: «seen». Для опыта или прошлого действия, связанного с настоящим, используется have/has + третья форма глагола. Обращай внимание на ever, never, just, already, yet."
  },
  "Use have + past participle: finished.": {
    "kk": "Дұрыс жауап: «finished». Тәжірибе немесе қазіргі уақытпен байланысты өткен әрекет have/has + past participle арқылы беріледі. Ever, never, just, already, yet сөздеріне назар аудар.",
    "ru": "Правильный ответ: «finished». Для опыта или прошлого действия, связанного с настоящим, используется have/has + третья форма глагола. Обращай внимание на ever, never, just, already, yet."
  },
  "Have not needs the past participle done.": {
    "kk": "Дұрыс жауап: «done». Тәжірибе немесе қазіргі уақытпен байланысты өткен әрекет have/has + past participle арқылы беріледі. Ever, never, just, already, yet сөздеріне назар аудар.",
    "ru": "Правильный ответ: «done». Для опыта или прошлого действия, связанного с настоящим, используется have/has + третья форма глагола. Обращай внимание на ever, never, just, already, yet."
  },
  "The past participle of come is also come.": {
    "kk": "Дұрыс жауап: «come». Тәжірибе немесе қазіргі уақытпен байланысты өткен әрекет have/has + past participle арқылы беріледі. Ever, never, just, already, yet сөздеріне назар аудар.",
    "ru": "Правильный ответ: «come». Для опыта или прошлого действия, связанного с настоящим, используется have/has + третья форма глагола. Обращай внимание на ever, never, just, already, yet."
  },
  "Has needs the past participle sent.": {
    "kk": "Дұрыс жауап: «sent». Тәжірибе немесе қазіргі уақытпен байланысты өткен әрекет have/has + past participle арқылы беріледі. Ever, never, just, already, yet сөздеріне назар аудар.",
    "ru": "Правильный ответ: «sent». Для опыта или прошлого действия, связанного с настоящим, используется have/has + третья форма глагола. Обращай внимание на ever, never, just, already, yet."
  },
  "The past participle of ride is ridden.": {
    "kk": "Дұрыс жауап: «ridden». Тәжірибе немесе қазіргі уақытпен байланысты өткен әрекет have/has + past participle арқылы беріледі. Ever, never, just, already, yet сөздеріне назар аудар.",
    "ru": "Правильный ответ: «ridden». Для опыта или прошлого действия, связанного с настоящим, используется have/has + третья форма глагола. Обращай внимание на ever, never, just, already, yet."
  },
  "Have never is followed by the past participle played.": {
    "kk": "Дұрыс жауап: «played». Тәжірибе немесе қазіргі уақытпен байланысты өткен әрекет have/has + past participle арқылы беріледі. Ever, never, just, already, yet сөздеріне назар аудар.",
    "ru": "Правильный ответ: «played». Для опыта или прошлого действия, связанного с настоящим, используется have/has + третья форма глагола. Обращай внимание на ever, never, just, already, yet."
  },
  "The past participle of find is found.": {
    "kk": "Дұрыс жауап: «found». Тәжірибе немесе қазіргі уақытпен байланысты өткен әрекет have/has + past participle арқылы беріледі. Ever, never, just, already, yet сөздеріне назар аудар.",
    "ru": "Правильный ответ: «found». Для опыта или прошлого действия, связанного с настоящим, используется have/has + третья форма глагола. Обращай внимание на ever, never, just, already, yet."
  },
  "Has needs the past participle lost.": {
    "kk": "Дұрыс жауап: «lost». Тәжірибе немесе қазіргі уақытпен байланысты өткен әрекет have/has + past participle арқылы беріледі. Ever, never, just, already, yet сөздеріне назар аудар.",
    "ru": "Правильный ответ: «lost». Для опыта или прошлого действия, связанного с настоящим, используется have/has + третья форма глагола. Обращай внимание на ever, never, just, already, yet."
  },
  "Make and do": {
    "kk": "Make және do",
    "ru": "Make и do"
  },
  "Learn these combinations as whole phrases: do homework, do your best, make a decision, make a mistake, make your bed and make friends.": {
    "kk": "Тіркестерді тұтас үйрен: do homework, do your best, make a decision, make a mistake, make your bed, make friends.",
    "ru": "Запоминай сочетания целиком: do homework, do your best, make a decision, make a mistake, make your bed, make friends."
  },
  "The fixed combination is do homework.": {
    "kk": "Дұрыс жауап: «do». Тіркестерді тұтас үйрен: do homework, do your best, make a decision, make a mistake, make your bed, make friends.",
    "ru": "Правильный ответ: «do». Запоминай сочетания целиком: do homework, do your best, make a decision, make a mistake, make your bed, make friends."
  },
  "Use do with homework.": {
    "kk": "Дұрыс жауап: «do». Тіркестерді тұтас үйрен: do homework, do your best, make a decision, make a mistake, make your bed, make friends.",
    "ru": "Правильный ответ: «do». Запоминай сочетания целиком: do homework, do your best, make a decision, make a mistake, make your bed, make friends."
  },
  "The standard combination here is make a decision.": {
    "kk": "Дұрыс жауап: «make». Тіркестерді тұтас үйрен: do homework, do your best, make a decision, make a mistake, make your bed, make friends.",
    "ru": "Правильный ответ: «make». Запоминай сочетания целиком: do homework, do your best, make a decision, make a mistake, make your bed, make friends."
  },
  "Use make with a mistake.": {
    "kk": "Дұрыс жауап: «make». Тіркестерді тұтас үйрен: do homework, do your best, make a decision, make a mistake, make your bed, make friends.",
    "ru": "Правильный ответ: «make». Запоминай сочетания целиком: do homework, do your best, make a decision, make a mistake, make your bed, make friends."
  },
  "Make friends means form friendships.": {
    "kk": "Дұрыс жауап: «make». Тіркестерді тұтас үйрен: do homework, do your best, make a decision, make a mistake, make your bed, make friends.",
    "ru": "Правильный ответ: «make». Запоминай сочетания целиком: do homework, do your best, make a decision, make a mistake, make your bed, make friends."
  },
  "Make your bed means arrange the bedding neatly.": {
    "kk": "Дұрыс жауап: «make». Тіркестерді тұтас үйрен: do homework, do your best, make a decision, make a mistake, make your bed, make friends.",
    "ru": "Правильный ответ: «make». Запоминай сочетания целиком: do homework, do your best, make a decision, make a mistake, make your bed, make friends."
  },
  "The fixed phrase is do your best.": {
    "kk": "Дұрыс жауап: «do». Тіркестерді тұтас үйрен: do homework, do your best, make a decision, make a mistake, make your bed, make friends.",
    "ru": "Правильный ответ: «do». Запоминай сочетания целиком: do homework, do your best, make a decision, make a mistake, make your bed, make friends."
  },
  "Use make a plan.": {
    "kk": "Дұрыс жауап: «make». Тіркестерді тұтас үйрен: do homework, do your best, make a decision, make a mistake, make your bed, make friends.",
    "ru": "Правильный ответ: «make». Запоминай сочетания целиком: do homework, do your best, make a decision, make a mistake, make your bed, make friends."
  },
  "The fixed phrase is do the washing-up.": {
    "kk": "Дұрыс жауап: «do». Тіркестерді тұтас үйрен: do homework, do your best, make a decision, make a mistake, make your bed, make friends.",
    "ru": "Правильный ответ: «do». Запоминай сочетания целиком: do homework, do your best, make a decision, make a mistake, make your bed, make friends."
  },
  "The fixed combination is make noise.": {
    "kk": "Дұрыс жауап: «make». Тіркестерді тұтас үйрен: do homework, do your best, make a decision, make a mistake, make your bed, make friends.",
    "ru": "Правильный ответ: «make». Запоминай сочетания целиком: do homework, do your best, make a decision, make a mistake, make your bed, make friends."
  },
  "Take and get": {
    "kk": "Take және get",
    "ru": "Take и get"
  },
  "Learn action phrases together: take a photo, take a break, take notes, take part and get enough sleep.": {
    "kk": "Тіркестерді тұтас үйрен: take a photo, take a break, take notes, take part, get enough sleep.",
    "ru": "Запоминай сочетания: take a photo, take a break, take notes, take part, get enough sleep."
  },
  "The fixed phrase is take a photo.": {
    "kk": "Дұрыс жауап: «take». Тіркестерді тұтас үйрен: take a photo, take a break, take notes, take part, get enough sleep.",
    "ru": "Правильный ответ: «take». Запоминай сочетания: take a photo, take a break, take notes, take part, get enough sleep."
  },
  "Use take with a photo.": {
    "kk": "Дұрыс жауап: «take». Тіркестерді тұтас үйрен: take a photo, take a break, take notes, take part, get enough sleep.",
    "ru": "Правильный ответ: «take». Запоминай сочетания: take a photo, take a break, take notes, take part, get enough sleep."
  },
  "The fixed phrase is take a break.": {
    "kk": "Дұрыс жауап: «take». Тіркестерді тұтас үйрен: take a photo, take a break, take notes, take part, get enough sleep.",
    "ru": "Правильный ответ: «take». Запоминай сочетания: take a photo, take a break, take notes, take part, get enough sleep."
  },
  "Take notes means write down the main points.": {
    "kk": "Дұрыс жауап: «take». Тіркестерді тұтас үйрен: take a photo, take a break, take notes, take part, get enough sleep.",
    "ru": "Правильный ответ: «take». Запоминай сочетания: take a photo, take a break, take notes, take part, get enough sleep."
  },
  "The fixed phrase is take part in.": {
    "kk": "Дұрыс жауап: «take». Тіркестерді тұтас үйрен: take a photo, take a break, take notes, take part, get enough sleep.",
    "ru": "Правильный ответ: «take». Запоминай сочетания: take a photo, take a break, take notes, take part, get enough sleep."
  },
  "Use get enough sleep.": {
    "kk": "Дұрыс жауап: «get». Тіркестерді тұтас үйрен: take a photo, take a break, take notes, take part, get enough sleep.",
    "ru": "Правильный ответ: «get». Запоминай сочетания: take a photo, take a break, take notes, take part, get enough sleep."
  },
  "Take the bus means travel on it.": {
    "kk": "Дұрыс жауап: «take». Тіркестерді тұтас үйрен: take a photo, take a break, take notes, take part, get enough sleep.",
    "ru": "Правильный ответ: «take». Запоминай сочетания: take a photo, take a break, take notes, take part, get enough sleep."
  },
  "Get a cold means become ill with a cold.": {
    "kk": "Дұрыс жауап: «get». Тіркестерді тұтас үйрен: take a photo, take a break, take notes, take part, get enough sleep.",
    "ru": "Правильный ответ: «get». Запоминай сочетания: take a photo, take a break, take notes, take part, get enough sleep."
  },
  "The fixed phrase is get some rest.": {
    "kk": "Дұрыс жауап: «get». Тіркестерді тұтас үйрен: take a photo, take a break, take notes, take part, get enough sleep.",
    "ru": "Правильный ответ: «get». Запоминай сочетания: take a photo, take a break, take notes, take part, get enough sleep."
  },
  "Take a seat is a polite way to ask someone to sit down.": {
    "kk": "Дұрыс жауап: «take». Тіркестерді тұтас үйрен: take a photo, take a break, take notes, take part, get enough sleep.",
    "ru": "Правильный ответ: «take». Запоминай сочетания: take a photo, take a break, take notes, take part, get enough sleep."
  },
  "Communication phrases": {
    "kk": "Қарым-қатынас тіркестері",
    "ru": "Сочетания для общения"
  },
  "Use tell the truth, ask a question, give advice, send an email, pay attention and keep a promise.": {
    "kk": "Tell the truth, ask a question, give advice, send an email, pay attention, keep a promise тіркестерін есте сақта.",
    "ru": "Запомни сочетания tell the truth, ask a question, give advice, send an email, pay attention, keep a promise."
  },
  "The fixed phrase is tell the truth.": {
    "kk": "Дұрыс жауап: «tell». Tell the truth, ask a question, give advice, send an email, pay attention, keep a promise тіркестерін есте сақта.",
    "ru": "Правильный ответ: «tell». Запомни сочетания tell the truth, ask a question, give advice, send an email, pay attention, keep a promise."
  },
  "Use ask with a question.": {
    "kk": "Дұрыс жауап: «ask». Tell the truth, ask a question, give advice, send an email, pay attention, keep a promise тіркестерін есте сақта.",
    "ru": "Правильный ответ: «ask». Запомни сочетания tell the truth, ask a question, give advice, send an email, pay attention, keep a promise."
  },
  "The fixed phrase is give someone advice.": {
    "kk": "Дұрыс жауап: «give». Tell the truth, ask a question, give advice, send an email, pay attention, keep a promise тіркестерін есте сақта.",
    "ru": "Правильный ответ: «give». Запомни сочетания tell the truth, ask a question, give advice, send an email, pay attention, keep a promise."
  },
  "Use send with an email.": {
    "kk": "Дұрыс жауап: «send». Tell the truth, ask a question, give advice, send an email, pay attention, keep a promise тіркестерін есте сақта.",
    "ru": "Правильный ответ: «send». Запомни сочетания tell the truth, ask a question, give advice, send an email, pay attention, keep a promise."
  },
  "The fixed phrase is pay attention to.": {
    "kk": "Дұрыс жауап: «pay». Tell the truth, ask a question, give advice, send an email, pay attention, keep a promise тіркестерін есте сақта.",
    "ru": "Правильный ответ: «pay». Запомни сочетания tell the truth, ask a question, give advice, send an email, pay attention, keep a promise."
  },
  "Keep a promise means do what you promised.": {
    "kk": "Дұрыс жауап: «keep». Tell the truth, ask a question, give advice, send an email, pay attention, keep a promise тіркестерін есте сақта.",
    "ru": "Правильный ответ: «keep». Запомни сочетания tell the truth, ask a question, give advice, send an email, pay attention, keep a promise."
  },
  "Give someone a hand means help them.": {
    "kk": "Дұрыс жауап: «give». Tell the truth, ask a question, give advice, send an email, pay attention, keep a promise тіркестерін есте сақта.",
    "ru": "Правильный ответ: «give». Запомни сочетания tell the truth, ask a question, give advice, send an email, pay attention, keep a promise."
  },
  "Use show someone the way.": {
    "kk": "Дұрыс жауап: «show». Tell the truth, ask a question, give advice, send an email, pay attention, keep a promise тіркестерін есте сақта.",
    "ru": "Правильный ответ: «show». Запомни сочетания tell the truth, ask a question, give advice, send an email, pay attention, keep a promise."
  },
  "Tell can be followed by a person directly: tell me.": {
    "kk": "Дұрыс жауап: «tell». Tell the truth, ask a question, give advice, send an email, pay attention, keep a promise тіркестерін есте сақта.",
    "ru": "Правильный ответ: «tell». Запомни сочетания tell the truth, ask a question, give advice, send an email, pay attention, keep a promise."
  },
  "Discuss takes the topic directly: discuss this problem.": {
    "kk": "Дұрыс жауап: «discuss». Tell the truth, ask a question, give advice, send an email, pay attention, keep a promise тіркестерін есте сақта.",
    "ru": "Правильный ответ: «discuss». Запомни сочетания tell the truth, ask a question, give advice, send an email, pay attention, keep a promise."
  },
  "Study and everyday phrases": {
    "kk": "Оқу және күнделікті тіркестер",
    "ru": "Учебные и повседневные сочетания"
  },
  "Learn common combinations: solve a problem, follow the rules, save money, protect the environment and win a match.": {
    "kk": "Solve a problem, follow the rules, save money, protect the environment, win a match тіркестерін үйрен.",
    "ru": "Изучи сочетания solve a problem, follow the rules, save money, protect the environment, win a match."
  },
  "Use solve with a problem.": {
    "kk": "Дұрыс жауап: «solve». Solve a problem, follow the rules, save money, protect the environment, win a match тіркестерін үйрен.",
    "ru": "Правильный ответ: «solve». Изучи сочетания solve a problem, follow the rules, save money, protect the environment, win a match."
  },
  "Follow the rules means act according to them.": {
    "kk": "Дұрыс жауап: «follow». Solve a problem, follow the rules, save money, protect the environment, win a match тіркестерін үйрен.",
    "ru": "Правильный ответ: «follow». Изучи сочетания solve a problem, follow the rules, save money, protect the environment, win a match."
  },
  "Win a match; beat an opponent.": {
    "kk": "Дұрыс жауап: «win». Solve a problem, follow the rules, save money, protect the environment, win a match тіркестерін үйрен.",
    "ru": "Правильный ответ: «win». Изучи сочетания solve a problem, follow the rules, save money, protect the environment, win a match."
  },
  "The fixed phrase is break a record.": {
    "kk": "Дұрыс жауап: «break». Solve a problem, follow the rules, save money, protect the environment, win a match тіркестерін үйрен.",
    "ru": "Правильный ответ: «break». Изучи сочетания solve a problem, follow the rules, save money, protect the environment, win a match."
  },
  "Save energy means avoid wasting it.": {
    "kk": "Дұрыс жауап: «save». Solve a problem, follow the rules, save money, protect the environment, win a match тіркестерін үйрен.",
    "ru": "Правильный ответ: «save». Изучи сочетания solve a problem, follow the rules, save money, protect the environment, win a match."
  },
  "Protect the environment means keep it safe from harm.": {
    "kk": "Дұрыс жауап: «protect». Solve a problem, follow the rules, save money, protect the environment, win a match тіркестерін үйрен.",
    "ru": "Правильный ответ: «protect». Изучи сочетания solve a problem, follow the rules, save money, protect the environment, win a match."
  },
  "Putting money aside means saving it.": {
    "kk": "Дұрыс жауап: «save». Solve a problem, follow the rules, save money, protect the environment, win a match тіркестерін үйрен.",
    "ru": "Правильный ответ: «save». Изучи сочетания solve a problem, follow the rules, save money, protect the environment, win a match."
  },
  "Use a dictionary means look up information in it.": {
    "kk": "Дұрыс жауап: «use». Solve a problem, follow the rules, save money, protect the environment, win a match тіркестерін үйрен.",
    "ru": "Правильный ответ: «use». Изучи сочетания solve a problem, follow the rules, save money, protect the environment, win a match."
  },
  "The fixed phrase is fasten your seat belt.": {
    "kk": "Дұрыс жауап: «fasten». Solve a problem, follow the rules, save money, protect the environment, win a match тіркестерін үйрен.",
    "ru": "Правильный ответ: «fasten». Изучи сочетания solve a problem, follow the rules, save money, protect the environment, win a match."
  },
  "Use improve with pronunciation.": {
    "kk": "Дұрыс жауап: «improve». Solve a problem, follow the rules, save money, protect the environment, win a match тіркестерін үйрен.",
    "ru": "Правильный ответ: «improve». Изучи сочетания solve a problem, follow the rules, save money, protect the environment, win a match."
  },
  "At, on and in for time": {
    "kk": "Уақытпен at, on және in",
    "ru": "At, on и in для времени"
  },
  "Use at with clock times, on with days and dates, and in with months and years. Learn at night and in the morning as phrases.": {
    "kk": "At — нақты сағатпен, on — күндер мен даталармен, in — айлар мен жылдармен қолданылады. At night, in the morning тіркестерін есте сақта.",
    "ru": "At используется со временем на часах, on — с днями и датами, in — с месяцами и годами. Запомни at night и in the morning."
  },
  "Use at with a clock time.": {
    "kk": "Нақты сағатпен at қолданылады.",
    "ru": "Со временем на часах используется at."
  },
  "Use on with a day of the week.": {
    "kk": "Дұрыс жауап: «on». At — нақты сағатпен, on — күндер мен даталармен, in — айлар мен жылдармен қолданылады. At night, in the morning тіркестерін есте сақта.",
    "ru": "Правильный ответ: «on». At используется со временем на часах, on — с днями и датами, in — с месяцами и годами. Запомни at night и in the morning."
  },
  "Use on with a particular day or its evening.": {
    "kk": "Дұрыс жауап: «on». At — нақты сағатпен, on — күндер мен даталармен, in — айлар мен жылдармен қолданылады. At night, in the morning тіркестерін есте сақта.",
    "ru": "Правильный ответ: «on». At используется со временем на часах, on — с днями и датами, in — с месяцами и годами. Запомни at night и in the morning."
  },
  "Use in with a month.": {
    "kk": "Дұрыс жауап: «in». At — нақты сағатпен, on — күндер мен даталармен, in — айлар мен жылдармен қолданылады. At night, in the morning тіркестерін есте сақта.",
    "ru": "Правильный ответ: «in». At используется со временем на часах, on — с днями и датами, in — с месяцами и годами. Запомни at night и in the morning."
  },
  "Use in with a year.": {
    "kk": "Дұрыс жауап: «in». At — нақты сағатпен, on — күндер мен даталармен, in — айлар мен жылдармен қолданылады. At night, in the morning тіркестерін есте сақта.",
    "ru": "Правильный ответ: «in». At используется со временем на часах, on — с днями и датами, in — с месяцами и годами. Запомни at night и in the morning."
  },
  "The fixed time phrase is in the evening.": {
    "kk": "Дұрыс жауап: «in». At — нақты сағатпен, on — күндер мен даталармен, in — айлар мен жылдармен қолданылады. At night, in the morning тіркестерін есте сақта.",
    "ru": "Правильный ответ: «in». At используется со временем на часах, on — с днями и датами, in — с месяцами и годами. Запомни at night и in the morning."
  },
  "The fixed time phrase is at night.": {
    "kk": "Дұрыс жауап: «at». At — нақты сағатпен, on — күндер мен даталармен, in — айлар мен жылдармен қолданылады. At night, in the morning тіркестерін есте сақта.",
    "ru": "Правильный ответ: «at». At используется со временем на часах, on — с днями и датами, in — с месяцами и годами. Запомни at night и in the morning."
  },
  "Use on with a full date.": {
    "kk": "Дұрыс жауап: «on». At — нақты сағатпен, on — күндер мен даталармен, in — айлар мен жылдармен қолданылады. At night, in the morning тіркестерін есте сақта.",
    "ru": "Правильный ответ: «on». At используется со временем на часах, on — с днями и датами, in — с месяцами и годами. Запомни at night и in the morning."
  },
  "Place and movement": {
    "kk": "Орын және қозғалыс",
    "ru": "Место и движение"
  },
  "Use in for something inside, on for a surface, to for a destination and across for movement from one side to the other. Learn arrive at a place and arrive in a city or country.": {
    "kk": "In — ішінде, on — бетінде, to — бағыт, across — бір шетінен екіншісіне. Arrive at нақты орынмен, arrive in қала не елмен қолданылады.",
    "ru": "In — внутри, on — на поверхности, to — направление, across — с одной стороны на другую. Arrive at — с конкретным местом, arrive in — с городом или страной."
  },
  "A schoolbag contains the books. Use in.": {
    "kk": "Дұрыс жауап: «in». In — ішінде, on — бетінде, to — бағыт, across — бір шетінен екіншісіне. Arrive at нақты орынмен, arrive in қала не елмен қолданылады.",
    "ru": "Правильный ответ: «in». In — внутри, on — на поверхности, to — направление, across — с одной стороны на другую. Arrive at — с конкретным местом, arrive in — с городом или страной."
  },
  "A picture is on the surface of the wall.": {
    "kk": "Дұрыс жауап: «on». In — ішінде, on — бетінде, to — бағыт, across — бір шетінен екіншісіне. Arrive at нақты орынмен, arrive in қала не елмен қолданылады.",
    "ru": "Правильный ответ: «on». In — внутри, on — на поверхности, to — направление, across — с одной стороны на другую. Arrive at — с конкретным местом, arrive in — с городом или страной."
  },
  "Use arrive at with a specific place such as an airport.": {
    "kk": "Дұрыс жауап: «at». In — ішінде, on — бетінде, to — бағыт, across — бір шетінен екіншісіне. Arrive at нақты орынмен, arrive in қала не елмен қолданылады.",
    "ru": "Правильный ответ: «at». In — внутри, on — на поверхности, to — направление, across — с одной стороны на другую. Arrive at — с конкретным местом, arrive in — с городом или страной."
  },
  "Use arrive in with a country or city.": {
    "kk": "Дұрыс жауап: «in». In — ішінде, on — бетінде, to — бағыт, across — бір шетінен екіншісіне. Arrive at нақты орынмен, arrive in қала не елмен қолданылады.",
    "ru": "Правильный ответ: «in». In — внутри, on — на поверхности, to — направление, across — с одной стороны на другую. Arrive at — с конкретным местом, arrive in — с городом или страной."
  },
  "Across means from one side to the other.": {
    "kk": "Дұрыс жауап: «across». In — ішінде, on — бетінде, to — бағыт, across — бір шетінен екіншісіне. Arrive at нақты орынмен, arrive in қала не елмен қолданылады.",
    "ru": "Правильный ответ: «across». In — внутри, on — на поверхности, to — направление, across — с одной стороны на другую. Arrive at — с конкретным местом, arrive in — с городом или страной."
  },
  "Use divide into for the resulting parts.": {
    "kk": "Дұрыс жауап: «into». In — ішінде, on — бетінде, to — бағыт, across — бір шетінен екіншісіне. Arrive at нақты орынмен, arrive in қала не елмен қолданылады.",
    "ru": "Правильный ответ: «into». In — внутри, on — на поверхности, to — направление, across — с одной стороны на другую. Arrive at — с конкретным местом, arrive in — с городом или страной."
  },
  "By train describes the means of transport.": {
    "kk": "Дұрыс жауап: «by». In — ішінде, on — бетінде, to — бағыт, across — бір шетінен екіншісіне. Arrive at нақты орынмен, arrive in қала не елмен қолданылады.",
    "ru": "Правильный ответ: «by». In — внутри, on — на поверхности, to — направление, across — с одной стороны на другую. Arrive at — с конкретным местом, arrive in — с городом или страной."
  },
  "The fixed phrase is on foot.": {
    "kk": "Дұрыс жауап: «on». In — ішінде, on — бетінде, to — бағыт, across — бір шетінен екіншісіне. Arrive at нақты орынмен, arrive in қала не елмен қолданылады.",
    "ru": "Правильный ответ: «on». In — внутри, on — на поверхности, to — направление, across — с одной стороны на другую. Arrive at — с конкретным местом, arrive in — с городом или страной."
  },
  "Use from one place to another.": {
    "kk": "Дұрыс жауап: «to». In — ішінде, on — бетінде, to — бағыт, across — бір шетінен екіншісіне. Arrive at нақты орынмен, arrive in қала не елмен қолданылады.",
    "ru": "Правильный ответ: «to». In — внутри, on — на поверхности, to — направление, across — с одной стороны на другую. Arrive at — с конкретным местом, arrive in — с городом или страной."
  },
  "Use between with the two places linked by and.": {
    "kk": "Дұрыс жауап: «between». In — ішінде, on — бетінде, to — бағыт, across — бір шетінен екіншісіне. Arrive at нақты орынмен, arrive in қала не елмен қолданылады.",
    "ru": "Правильный ответ: «between». In — внутри, on — на поверхности, to — направление, across — с одной стороны на другую. Arrive at — с конкретным местом, arrive in — с городом или страной."
  },
  "Prepositions in fixed phrases": {
    "kk": "Тұрақты тіркестегі предлогтар",
    "ru": "Предлоги в устойчивых сочетаниях"
  },
  "Learn the preposition with its phrase: good at, interested in, afraid of, listen to, wait for, agree with and belong to.": {
    "kk": "Предлогты тіркесімен үйрен: good at, interested in, afraid of, listen to, wait for, agree with, belong to.",
    "ru": "Учи предлог вместе с выражением: good at, interested in, afraid of, listen to, wait for, agree with, belong to."
  },
  "The fixed phrase is good at.": {
    "kk": "Дұрыс жауап: «at». Предлогты тіркесімен үйрен: good at, interested in, afraid of, listen to, wait for, agree with, belong to.",
    "ru": "Правильный ответ: «at». Учи предлог вместе с выражением: good at, interested in, afraid of, listen to, wait for, agree with, belong to."
  },
  "The fixed phrase is interested in.": {
    "kk": "Дұрыс жауап: «in». Предлогты тіркесімен үйрен: good at, interested in, afraid of, listen to, wait for, agree with, belong to.",
    "ru": "Правильный ответ: «in». Учи предлог вместе с выражением: good at, interested in, afraid of, listen to, wait for, agree with, belong to."
  },
  "The fixed phrase is afraid of.": {
    "kk": "Дұрыс жауап: «of». Предлогты тіркесімен үйрен: good at, interested in, afraid of, listen to, wait for, agree with, belong to.",
    "ru": "Правильный ответ: «of». Учи предлог вместе с выражением: good at, interested in, afraid of, listen to, wait for, agree with, belong to."
  },
  "The verb listen is followed by to.": {
    "kk": "Дұрыс жауап: «to». Предлогты тіркесімен үйрен: good at, interested in, afraid of, listen to, wait for, agree with, belong to.",
    "ru": "Правильный ответ: «to». Учи предлог вместе с выражением: good at, interested in, afraid of, listen to, wait for, agree with, belong to."
  },
  "Use wait for when you name the person or thing being waited for.": {
    "kk": "Дұрыс жауап: «for». Предлогты тіркесімен үйрен: good at, interested in, afraid of, listen to, wait for, agree with, belong to.",
    "ru": "Правильный ответ: «for». Учи предлог вместе с выражением: good at, interested in, afraid of, listen to, wait for, agree with, belong to."
  },
  "Use agree with a person.": {
    "kk": "Дұрыс жауап: «with». Предлогты тіркесімен үйрен: good at, interested in, afraid of, listen to, wait for, agree with, belong to.",
    "ru": "Правильный ответ: «with». Учи предлог вместе с выражением: good at, interested in, afraid of, listen to, wait for, agree with, belong to."
  },
  "The fixed phrase is belong to.": {
    "kk": "Дұрыс жауап: «to». Предлогты тіркесімен үйрен: good at, interested in, afraid of, listen to, wait for, agree with, belong to.",
    "ru": "Правильный ответ: «to». Учи предлог вместе с выражением: good at, interested in, afraid of, listen to, wait for, agree with, belong to."
  },
  "Use thank you for to name the reason.": {
    "kk": "Дұрыс жауап: «for». Предлогты тіркесімен үйрен: good at, interested in, afraid of, listen to, wait for, agree with, belong to.",
    "ru": "Правильный ответ: «for». Учи предлог вместе с выражением: good at, interested in, afraid of, listen to, wait for, agree with, belong to."
  },
  "The fixed phrase is worried about.": {
    "kk": "Дұрыс жауап: «about». Предлогты тіркесімен үйрен: good at, interested in, afraid of, listen to, wait for, agree with, belong to.",
    "ru": "Правильный ответ: «about». Учи предлог вместе с выражением: good at, interested in, afraid of, listen to, wait for, agree with, belong to."
  },
  "The fixed phrase is responsible for.": {
    "kk": "Дұрыс жауап: «for». Предлогты тіркесімен үйрен: good at, interested in, afraid of, listen to, wait for, agree with, belong to.",
    "ru": "Правильный ответ: «for». Учи предлог вместе с выражением: good at, interested in, afraid of, listen to, wait for, agree with, belong to."
  },
  "For and since": {
    "kk": "For және since",
    "ru": "For и since"
  },
  "Use for with a length of time and since with the point when something began.": {
    "kk": "For уақыттың ұзақтығын, since әрекеттің басталған сәтін көрсетеді.",
    "ru": "For обозначает длительность, since — момент начала действия."
  },
  "Three years is a duration, so use for.": {
    "kk": "Дұрыс жауап: «for». For уақыттың ұзақтығын, since әрекеттің басталған сәтін көрсетеді.",
    "ru": "Правильный ответ: «for». For обозначает длительность, since — момент начала действия."
  },
  "2020 is a starting point, so use since.": {
    "kk": "Дұрыс жауап: «since». For уақыттың ұзақтығын, since әрекеттің басталған сәтін көрсетеді.",
    "ru": "Правильный ответ: «since». For обозначает длительность, since — момент начала действия."
  },
  "Twenty minutes is a length of time. Use for.": {
    "kk": "Дұрыс жауап: «for». For уақыттың ұзақтығын, since әрекеттің басталған сәтін көрсетеді.",
    "ru": "Правильный ответ: «for». For обозначает длительность, since — момент начала действия."
  },
  "Monday identifies when the illness started. Use since.": {
    "kk": "Дұрыс жауап: «since». For уақыттың ұзақтығын, since әрекеттің басталған сәтін көрсетеді.",
    "ru": "Правильный ответ: «since». For обозначает длительность, since — момент начала действия."
  },
  "A long time is a duration. Use for.": {
    "kk": "Дұрыс жауап: «for». For уақыттың ұзақтығын, since әрекеттің басталған сәтін көрсетеді.",
    "ru": "Правильный ответ: «for». For обозначает длительность, since — момент начала действия."
  },
  "Last summer is a starting point. Use since.": {
    "kk": "Дұрыс жауап: «since». For уақыттың ұзақтығын, since әрекеттің басталған сәтін көрсетеді.",
    "ru": "Правильный ответ: «since». For обозначает длительность, since — момент начала действия."
  },
  "Use for with a duration: two years.": {
    "kk": "Дұрыс жауап: «for». For уақыттың ұзақтығын, since әрекеттің басталған сәтін көрсетеді.",
    "ru": "Правильный ответ: «for». For обозначает длительность, since — момент начала действия."
  },
  "January is the starting point. Use since.": {
    "kk": "Дұрыс жауап: «since». For уақыттың ұзақтығын, since әрекеттің басталған сәтін көрсетеді.",
    "ru": "Правильный ответ: «since». For обозначает длительность, since — момент начала действия."
  },
  "Six months is a duration. Use for.": {
    "kk": "Дұрыс жауап: «for». For уақыттың ұзақтығын, since әрекеттің басталған сәтін көрсетеді.",
    "ru": "Правильный ответ: «for». For обозначает длительность, since — момент начала действия."
  },
  "Six o’clock is the starting time. Use since.": {
    "kk": "Дұрыс жауап: «since». For уақыттың ұзақтығын, since әрекеттің басталған сәтін көрсетеді.",
    "ru": "Правильный ответ: «since». For обозначает длительность, since — момент начала действия."
  },
  "Statements and noun phrases": {
    "kk": "Хабарлы сөйлем және сөз тіркесі",
    "ru": "Утверждения и именные группы"
  },
  "In a simple statement, put the subject before the verb, then the object. Put an adjective before the noun it describes.": {
    "kk": "Хабарлы сөйлемнің реті: бастауыш + баяндауыш + толықтауыш. Сын есім зат есімнен бұрын тұрады.",
    "ru": "В утверждении: подлежащее + сказуемое + дополнение. Прилагательное ставится перед существительным."
  },
  "The subject she comes before the verb reads, followed by the object books.": {
    "kk": "Дұрыс жауап: «She reads books.». Хабарлы сөйлемнің реті: бастауыш + баяндауыш + толықтауыш. Сын есім зат есімнен бұрын тұрады.",
    "ru": "Правильный ответ: «She reads books.». В утверждении: подлежащее + сказуемое + дополнение. Прилагательное ставится перед существительным."
  },
  "Use subject + verb + object: they play tennis.": {
    "kk": "Дұрыс жауап: «They play tennis.». Хабарлы сөйлемнің реті: бастауыш + баяндауыш + толықтауыш. Сын есім зат есімнен бұрын тұрады.",
    "ru": "Правильный ответ: «They play tennis.». В утверждении: подлежащее + сказуемое + дополнение. Прилагательное ставится перед существительным."
  },
  "Put red before bicycle and the object after have.": {
    "kk": "Дұрыс жауап: «I have a red bicycle.». Хабарлы сөйлемнің реті: бастауыш + баяндауыш + толықтауыш. Сын есім зат есімнен бұрын тұрады.",
    "ru": "Правильный ответ: «I have a red bicycle.». В утверждении: подлежащее + сказуемое + дополнение. Прилагательное ставится перед существительным."
  },
  "Keep is wearing together and put blue before jacket.": {
    "kk": "Дұрыс жауап: «She is wearing a blue jacket.». Хабарлы сөйлемнің реті: бастауыш + баяндауыш + толықтауыш. Сын есім зат есімнен бұрын тұрады.",
    "ru": "Правильный ответ: «She is wearing a blue jacket.». В утверждении: подлежащее + сказуемое + дополнение. Прилагательное ставится перед существительным."
  },
  "The whole subject the students comes before are.": {
    "kk": "Дұрыс жауап: «The students are in the library.». Хабарлы сөйлемнің реті: бастауыш + баяндауыш + толықтауыш. Сын есім зат есімнен бұрын тұрады.",
    "ru": "Правильный ответ: «The students are in the library.». В утверждении: подлежащее + сказуемое + дополнение. Прилагательное ставится перед существительным."
  },
  "Keep my friend together, followed by has and the object.": {
    "kk": "Дұрыс жауап: «My friend has a small dog.». Хабарлы сөйлемнің реті: бастауыш + баяндауыш + толықтауыш. Сын есім зат есімнен бұрын тұрады.",
    "ru": "Правильный ответ: «My friend has a small dog.». В утверждении: подлежащее + сказуемое + дополнение. Прилагательное ставится перед существительным."
  },
  "Enjoy is followed by reading stories.": {
    "kk": "Дұрыс жауап: «We enjoy reading stories.». Хабарлы сөйлемнің реті: бастауыш + баяндауыш + толықтауыш. Сын есім зат есімнен бұрын тұрады.",
    "ru": "Правильный ответ: «We enjoy reading stories.». В утверждении: подлежащее + сказуемое + дополнение. Прилагательное ставится перед существительным."
  },
  "Keep the subject our teacher and object the rule together.": {
    "kk": "Дұрыс жауап: «Our teacher explains the rule.». Хабарлы сөйлемнің реті: бастауыш + баяндауыш + толықтауыш. Сын есім зат есімнен бұрын тұрады.",
    "ru": "Правильный ответ: «Our teacher explains the rule.». В утверждении: подлежащее + сказуемое + дополнение. Прилагательное ставится перед существительным."
  },
  "Use there is + noun phrase + place.": {
    "kk": "Дұрыс жауап: «There is a cat in the garden.». Хабарлы сөйлемнің реті: бастауыш + баяндауыш + толықтауыш. Сын есім зат есімнен бұрын тұрады.",
    "ru": "Правильный ответ: «There is a cat in the garden.». В утверждении: подлежащее + сказуемое + дополнение. Прилагательное ставится перед существительным."
  },
  "In this instruction, the verb open comes before your books.": {
    "kk": "Дұрыс жауап: «Please open your books.». Хабарлы сөйлемнің реті: бастауыш + баяндауыш + толықтауыш. Сын есім зат есімнен бұрын тұрады.",
    "ru": "Правильный ответ: «Please open your books.». В утверждении: подлежащее + сказуемое + дополнение. Прилагательное ставится перед существительным."
  },
  "Question word order": {
    "kk": "Сұрақтағы сөз реті",
    "ru": "Порядок слов в вопросах"
  },
  "In questions, put the auxiliary before the subject. With a question word, use question word + auxiliary + subject + main verb.": {
    "kk": "Сұрақта көмекші етістік бастауыштан бұрын келеді: сұрау сөзі + көмекші етістік + бастауыш + негізгі етістік.",
    "ru": "В вопросе вспомогательный глагол стоит перед подлежащим: вопросительное слово + вспомогательный глагол + подлежащее + основной глагол."
  },
  "Use where + does + he + live.": {
    "kk": "Дұрыс жауап: «Where does he live?». Сұрақта көмекші етістік бастауыштан бұрын келеді: сұрау сөзі + көмекші етістік + бастауыш + негізгі етістік.",
    "ru": "Правильный ответ: «Where does he live?». В вопросе вспомогательный глагол стоит перед подлежащим: вопросительное слово + вспомогательный глагол + подлежащее + основной глагол."
  },
  "Use when + does + she + study.": {
    "kk": "Дұрыс жауап: «When does she study?». Сұрақта көмекші етістік бастауыштан бұрын келеді: сұрау сөзі + көмекші етістік + бастауыш + негізгі етістік.",
    "ru": "Правильный ответ: «When does she study?». В вопросе вспомогательный глагол стоит перед подлежащим: вопросительное слово + вспомогательный глагол + подлежащее + основной глагол."
  },
  "Put did before they, followed by watch.": {
    "kk": "Дұрыс жауап: «Did they watch the film?». Сұрақта көмекші етістік бастауыштан бұрын келеді: сұрау сөзі + көмекші етістік + бастауыш + негізгі етістік.",
    "ru": "Правильный ответ: «Did they watch the film?». В вопросе вспомогательный глагол стоит перед подлежащим: вопросительное слово + вспомогательный глагол + подлежащее + основной глагол."
  },
  "Use what + did + you + eat.": {
    "kk": "Дұрыс жауап: «What did you eat for lunch?». Сұрақта көмекші етістік бастауыштан бұрын келеді: сұрау сөзі + көмекші етістік + бастауыш + негізгі етістік.",
    "ru": "Правильный ответ: «What did you eat for lunch?». В вопросе вспомогательный глагол стоит перед подлежащим: вопросительное слово + вспомогательный глагол + подлежащее + основной глагол."
  },
  "Keep how many books together before do you have.": {
    "kk": "Дұрыс жауап: «How many books do you have?». Сұрақта көмекші етістік бастауыштан бұрын келеді: сұрау сөзі + көмекші етістік + бастауыш + негізгі етістік.",
    "ru": "Правильный ответ: «How many books do you have?». В вопросе вспомогательный глагол стоит перед подлежащим: вопросительное слово + вспомогательный глагол + подлежащее + основной глагол."
  },
  "Keep what time together, then does + school + start.": {
    "kk": "Дұрыс жауап: «What time does school start?». Сұрақта көмекші етістік бастауыштан бұрын келеді: сұрау сөзі + көмекші етістік + бастауыш + негізгі етістік.",
    "ru": "Правильный ответ: «What time does school start?». В вопросе вспомогательный глагол стоит перед подлежащим: вопросительное слово + вспомогательный глагол + подлежащее + основной глагол."
  },
  "Use why + are + the children + laughing.": {
    "kk": "Дұрыс жауап: «Why are the children laughing?». Сұрақта көмекші етістік бастауыштан бұрын келеді: сұрау сөзі + көмекші етістік + бастауыш + негізгі етістік.",
    "ru": "Правильный ответ: «Why are the children laughing?». В вопросе вспомогательный глагол стоит перед подлежащим: вопросительное слово + вспомогательный глагол + подлежащее + основной глагол."
  },
  "Use where + is + your schoolbag.": {
    "kk": "Дұрыс жауап: «Where is your schoolbag?». Сұрақта көмекші етістік бастауыштан бұрын келеді: сұрау сөзі + көмекші етістік + бастауыш + негізгі етістік.",
    "ru": "Правильный ответ: «Where is your schoolbag?». В вопросе вспомогательный глагол стоит перед подлежащим: вопросительное слово + вспомогательный глагол + подлежащее + основной глагол."
  },
  "Keep how much water together, then do + we + need.": {
    "kk": "Дұрыс жауап: «How much water do we need?». Сұрақта көмекші етістік бастауыштан бұрын келеді: сұрау сөзі + көмекші етістік + бастауыш + негізгі етістік.",
    "ru": "Правильный ответ: «How much water do we need?». В вопросе вспомогательный глагол стоит перед подлежащим: вопросительное слово + вспомогательный глагол + подлежащее + основной глагол."
  },
  "Use when + will + the lesson + start.": {
    "kk": "Дұрыс жауап: «When will the lesson start?». Сұрақта көмекші етістік бастауыштан бұрын келеді: сұрау сөзі + көмекші етістік + бастауыш + негізгі етістік.",
    "ru": "Правильный ответ: «When will the lesson start?». В вопросе вспомогательный глагол стоит перед подлежащим: вопросительное слово + вспомогательный глагол + подлежащее + основной глагол."
  },
  "Frequency adverbs": {
    "kk": "Жиілік үстеулерінің орны",
    "ru": "Место наречий частотности"
  },
  "Frequency adverbs usually come before a main verb and after be. Keep noun phrases together.": {
    "kk": "Жиілік үстеуі әдетте негізгі етістіктен бұрын, ал be етістігінен кейін келеді. Сөз тіркесін бөлме.",
    "ru": "Наречие частотности обычно стоит перед основным глаголом и после be. Не разделяй слова внутри именной группы."
  },
  "Usually goes before the main verb walk.": {
    "kk": "Дұрыс жауап: «I usually walk to school.». Жиілік үстеуі әдетте негізгі етістіктен бұрын, ал be етістігінен кейін келеді. Сөз тіркесін бөлме.",
    "ru": "Правильный ответ: «I usually walk to school.». Наречие частотности обычно стоит перед основным глаголом и после be. Не разделяй слова внутри именной группы."
  },
  "Never goes before goes; keep to bed together.": {
    "kk": "Дұрыс жауап: «He never goes to bed late.». Жиілік үстеуі әдетте негізгі етістіктен бұрын, ал be етістігінен кейін келеді. Сөз тіркесін бөлме.",
    "ru": "Правильный ответ: «He never goes to bed late.». Наречие частотности обычно стоит перед основным глаголом и после be. Не разделяй слова внутри именной группы."
  },
  "Often comes before visit; do not split our grandparents.": {
    "kk": "Дұрыс жауап: «We often visit our grandparents.». Жиілік үстеуі әдетте негізгі етістіктен бұрын, ал be етістігінен кейін келеді. Сөз тіркесін бөлме.",
    "ru": "Правильный ответ: «We often visit our grandparents.». Наречие частотности обычно стоит перед основным глаголом и после be. Не разделяй слова внутри именной группы."
  },
  "Sometimes comes before the main verb plays.": {
    "kk": "Дұрыс жауап: «She sometimes plays chess.». Жиілік үстеуі әдетте негізгі етістіктен бұрын, ал be етістігінен кейін келеді. Сөз тіркесін бөлме.",
    "ru": "Правильный ответ: «She sometimes plays chess.». Наречие частотности обычно стоит перед основным глаголом и после be. Не разделяй слова внутри именной группы."
  },
  "With be, put always after is and before friendly.": {
    "kk": "Дұрыс жауап: «She is always friendly.». Жиілік үстеуі әдетте негізгі етістіктен бұрын, ал be етістігінен кейін келеді. Сөз тіркесін бөлме.",
    "ru": "Правильный ответ: «She is always friendly.». Наречие частотности обычно стоит перед основным глаголом и после be. Не разделяй слова внутри именной группы."
  },
  "Put usually after are and before ready.": {
    "kk": "Дұрыс жауап: «They are usually ready.». Жиілік үстеуі әдетте негізгі етістіктен бұрын, ал be етістігінен кейін келеді. Сөз тіркесін бөлме.",
    "ru": "Правильный ответ: «They are usually ready.». Наречие частотности обычно стоит перед основным глаголом и после be. Не разделяй слова внутри именной группы."
  },
  "Rarely goes before eat; keep fast food together.": {
    "kk": "Дұрыс жауап: «We rarely eat fast food.». Жиілік үстеуі әдетте негізгі етістіктен бұрын, ал be етістігінен кейін келеді. Сөз тіркесін бөлме.",
    "ru": "Правильный ответ: «We rarely eat fast food.». Наречие частотности обычно стоит перед основным глаголом и после be. Не разделяй слова внутри именной группы."
  },
  "Often goes after is.": {
    "kk": "Дұрыс жауап: «He is often late.». Жиілік үстеуі әдетте негізгі етістіктен бұрын, ал be етістігінен кейін келеді. Сөз тіркесін бөлме.",
    "ru": "Правильный ответ: «He is often late.». Наречие частотности обычно стоит перед основным глаголом и после be. Не разделяй слова внутри именной группы."
  },
  "Always goes before check; keep my answers together.": {
    "kk": "Дұрыс жауап: «I always check my answers.». Жиілік үстеуі әдетте негізгі етістіктен бұрын, ал be етістігінен кейін келеді. Сөз тіркесін бөлме.",
    "ru": "Правильный ответ: «I always check my answers.». Наречие частотности обычно стоит перед основным глаголом и после be. Не разделяй слова внутри именной группы."
  },
  "With be, never follows are and comes before rude.": {
    "kk": "Дұрыс жауап: «My friends are never rude.». Жиілік үстеуі әдетте негізгі етістіктен бұрын, ал be етістігінен кейін келеді. Сөз тіркесін бөлме.",
    "ru": "Правильный ответ: «My friends are never rude.». Наречие частотности обычно стоит перед основным глаголом и после be. Не разделяй слова внутри именной группы."
  },
  "Auxiliaries and verb groups": {
    "kk": "Көмекші етістіктердің реті",
    "ru": "Порядок глаголов и вспомогательных форм"
  },
  "Keep auxiliaries and main verbs in order. Use subject + modal + base verb, have/has + past participle, or be + going to + base verb.": {
    "kk": "Ретті сақта: бастауыш + модаль етістік + бастапқы етістік; have/has + past participle; be + going to + бастапқы етістік.",
    "ru": "Соблюдай порядок: подлежащее + модальный глагол + начальная форма; have/has + третья форма; be + going to + начальная форма."
  },
  "Use subject + can + base verb + object.": {
    "kk": "Дұрыс жауап: «She can speak English.». Ретті сақта: бастауыш + модаль етістік + бастапқы етістік; have/has + past participle; be + going to + бастапқы етістік.",
    "ru": "Правильный ответ: «She can speak English.». Соблюдай порядок: подлежащее + модальный глагол + начальная форма; have/has + третья форма; be + going to + начальная форма."
  },
  "Can comes before the base verb ride.": {
    "kk": "Дұрыс жауап: «He can ride a bike.». Ретті сақта: бастауыш + модаль етістік + бастапқы етістік; have/has + past participle; be + going to + бастапқы етістік.",
    "ru": "Правильный ответ: «He can ride a bike.». Соблюдай порядок: подлежащее + модальный глагол + начальная форма; have/has + третья форма; be + going to + начальная форма."
  },
  "Use has + already + finished, then the object.": {
    "kk": "Дұрыс жауап: «He has already finished his work.». Ретті сақта: бастауыш + модаль етістік + бастапқы етістік; have/has + past participle; be + going to + бастапқы етістік.",
    "ru": "Правильный ответ: «He has already finished his work.». Соблюдай порядок: подлежащее + модальный глагол + начальная форма; have/has + третья форма; be + going to + начальная форма."
  },
  "Use have + just + arrived, followed by the place.": {
    "kk": "Дұрыс жауап: «They have just arrived at the station.». Ретті сақта: бастауыш + модаль етістік + бастапқы етістік; have/has + past participle; be + going to + бастапқы етістік.",
    "ru": "Правильный ответ: «They have just arrived at the station.». Соблюдай порядок: подлежащее + модальный глагол + начальная форма; have/has + третья форма; be + going to + начальная форма."
  },
  "Use have + subject + ever + past participle.": {
    "kk": "Дұрыс жауап: «Have you ever visited London?». Ретті сақта: бастауыш + модаль етістік + бастапқы етістік; have/has + past participle; be + going to + бастапқы етістік.",
    "ru": "Правильный ответ: «Have you ever visited London?». Соблюдай порядок: подлежащее + модальный глагол + начальная форма; have/has + третья форма; be + going to + начальная форма."
  },
  "Use could + you + tell, followed by the objects.": {
    "kk": "Дұрыс жауап: «Could you tell me the time?». Ретті сақта: бастауыш + модаль етістік + бастапқы етістік; have/has + past participle; be + going to + бастапқы етістік.",
    "ru": "Правильный ответ: «Could you tell me the time?». Соблюдай порядок: подлежащее + модальный глагол + начальная форма; have/has + третья форма; be + going to + начальная форма."
  },
  "Keep am going to together before the base verb read.": {
    "kk": "Дұрыс жауап: «I am going to read this book.». Ретті сақта: бастауыш + модаль етістік + бастапқы етістік; have/has + past participle; be + going to + бастапқы етістік.",
    "ru": "Правильный ответ: «I am going to read this book.». Соблюдай порядок: подлежащее + модальный глагол + начальная форма; have/has + третья форма; be + going to + начальная форма."
  },
  "Put not after are and before watching.": {
    "kk": "Дұрыс жауап: «We are not watching TV.». Ретті сақта: бастауыш + модаль етістік + бастапқы етістік; have/has + past participle; be + going to + бастапқы етістік.",
    "ru": "Правильный ответ: «We are not watching TV.». Соблюдай порядок: подлежащее + модальный глагол + начальная форма; have/has + третья форма; be + going to + начальная форма."
  },
  "Use do not + base verb understand.": {
    "kk": "Дұрыс жауап: «I do not understand this word.». Ретті сақта: бастауыш + модаль етістік + бастапқы етістік; have/has + past participle; be + going to + бастапқы етістік.",
    "ru": "Правильный ответ: «I do not understand this word.». Соблюдай порядок: подлежащее + модальный глагол + начальная форма; have/has + третья форма; be + going to + начальная форма."
  },
  "Keep would like together, followed by the object.": {
    "kk": "Дұрыс жауап: «I would like a glass of water.». Ретті сақта: бастауыш + модаль етістік + бастапқы етістік; have/has + past participle; be + going to + бастапқы етістік.",
    "ru": "Правильный ответ: «I would like a glass of water.». Соблюдай порядок: подлежащее + модальный глагол + начальная форма; have/has + третья форма; be + going to + начальная форма."
  },
  "Common word spellings": {
    "kk": "Жиі қолданылатын сөздердің емлесі",
    "ru": "Правописание частых слов"
  },
  "Check the whole word, not only how it sounds. Notice the letter sequence in because, beautiful, science, subject and information.": {
    "kk": "Сөзді толық тексер. Because, beautiful, science, subject, information сөздеріндегі әріп ретіне назар аудар.",
    "ru": "Проверяй слово целиком. Обращай внимание на порядок букв в because, beautiful, science, subject, information."
  },
  "The correct spelling is because.": {
    "kk": "Дұрыс жауап: «because». Сөзді толық тексер. Because, beautiful, science, subject, information сөздеріндегі әріп ретіне назар аудар.",
    "ru": "Правильный ответ: «because». Проверяй слово целиком. Обращай внимание на порядок букв в because, beautiful, science, subject, information."
  },
  "The correct spelling is beautiful: beau-ti-ful.": {
    "kk": "Дұрыс жауап: «beautiful». Сөзді толық тексер. Because, beautiful, science, subject, information сөздеріндегі әріп ретіне назар аудар.",
    "ru": "Правильный ответ: «beautiful». Проверяй слово целиком. Обращай внимание на порядок букв в because, beautiful, science, subject, information."
  },
  "Science begins with sc and ends in -ence.": {
    "kk": "Дұрыс жауап: «science». Сөзді толық тексер. Because, beautiful, science, subject, information сөздеріндегі әріп ретіне назар аудар.",
    "ru": "Правильный ответ: «science». Проверяй слово целиком. Обращай внимание на порядок букв в because, beautiful, science, subject, information."
  },
  "The correct spelling is subject.": {
    "kk": "Дұрыс жауап: «subject». Сөзді толық тексер. Because, beautiful, science, subject, information сөздеріндегі әріп ретіне назар аудар.",
    "ru": "Правильный ответ: «subject». Проверяй слово целиком. Обращай внимание на порядок букв в because, beautiful, science, subject, information."
  },
  "The correct spelling is information.": {
    "kk": "Дұрыс жауап: «information». Сөзді толық тексер. Because, beautiful, science, subject, information сөздеріндегі әріп ретіне назар аудар.",
    "ru": "Правильный ответ: «information». Проверяй слово целиком. Обращай внимание на порядок букв в because, beautiful, science, subject, information."
  },
  "The correct spelling is weather.": {
    "kk": "Дұрыс жауап: «weather». Сөзді толық тексер. Because, beautiful, science, subject, information сөздеріндегі әріп ретіне назар аудар.",
    "ru": "Правильный ответ: «weather». Проверяй слово целиком. Обращай внимание на порядок букв в because, beautiful, science, subject, information."
  },
  "The correct spelling is museum.": {
    "kk": "Дұрыс жауап: «museum». Сөзді толық тексер. Because, beautiful, science, subject, information сөздеріндегі әріп ретіне назар аудар.",
    "ru": "Правильный ответ: «museum». Проверяй слово целиком. Обращай внимание на порядок букв в because, beautiful, science, subject, information."
  },
  "The correct spelling is birthday.": {
    "kk": "Дұрыс жауап: «birthday». Сөзді толық тексер. Because, beautiful, science, subject, information сөздеріндегі әріп ретіне назар аудар.",
    "ru": "Правильный ответ: «birthday». Проверяй слово целиком. Обращай внимание на порядок букв в because, beautiful, science, subject, information."
  },
  "The correct spelling is name.": {
    "kk": "Дұрыс жауап: «name». Сөзді толық тексер. Because, beautiful, science, subject, information сөздеріндегі әріп ретіне назар аудар.",
    "ru": "Правильный ответ: «name». Проверяй слово целиком. Обращай внимание на порядок букв в because, beautiful, science, subject, information."
  },
  "Pronunciation has nun, not noun, after pro-.": {
    "kk": "Дұрыс жауап: «pronunciation». Сөзді толық тексер. Because, beautiful, science, subject, information сөздеріндегі әріп ретіне назар аудар.",
    "ru": "Правильный ответ: «pronunciation». Проверяй слово целиком. Обращай внимание на порядок букв в because, beautiful, science, subject, information."
  },
  "Single and double letters": {
    "kk": "Бір және қос әріптер",
    "ru": "Одинарные и двойные буквы"
  },
  "Notice which consonants are doubled: address has dd and ss; tomorrow has rr; necessary has one c and two s.": {
    "kk": "Address сөзінде dd және ss, tomorrow сөзінде rr, necessary сөзінде бір c және екі s жазылады.",
    "ru": "В address пишутся dd и ss, в tomorrow — rr, в necessary — одна c и две s."
  },
  "Address has two d letters and two s letters.": {
    "kk": "Дұрыс жауап: «address». Address сөзінде dd және ss, tomorrow сөзінде rr, necessary сөзінде бір c және екі s жазылады.",
    "ru": "Правильный ответ: «address». В address пишутся dd и ss, в tomorrow — rr, в necessary — одна c и две s."
  },
  "Tomorrow has one m and two r letters.": {
    "kk": "Дұрыс жауап: «tomorrow». Address сөзінде dd және ss, tomorrow сөзінде rr, necessary сөзінде бір c және екі s жазылады.",
    "ru": "Правильный ответ: «tomorrow». В address пишутся dd и ss, в tomorrow — rr, в necessary — одна c и две s."
  },
  "Difficult has two f letters.": {
    "kk": "Дұрыс жауап: «difficult». Address сөзінде dd және ss, tomorrow сөзінде rr, necessary сөзінде бір c және екі s жазылады.",
    "ru": "Правильный ответ: «difficult». В address пишутся dd и ss, в tomorrow — rr, в necessary — одна c и две s."
  },
  "Village has two l letters.": {
    "kk": "Дұрыс жауап: «village». Address сөзінде dd және ss, tomorrow сөзінде rr, necessary сөзінде бір c және екі s жазылады.",
    "ru": "Правильный ответ: «village». В address пишутся dd и ss, в tomorrow — rr, в necessary — одна c и две s."
  },
  "Necessary has one c and two s letters.": {
    "kk": "Дұрыс жауап: «necessary». Address сөзінде dd және ss, tomorrow сөзінде rr, necessary сөзінде бір c және екі s жазылады.",
    "ru": "Правильный ответ: «necessary». В address пишутся dd и ss, в tomorrow — rr, в necessary — одна c и две s."
  },
  "Correct has two r letters and ends in -ect.": {
    "kk": "Дұрыс жауап: «correct». Address сөзінде dd және ss, tomorrow сөзінде rr, necessary сөзінде бір c және екі s жазылады.",
    "ru": "Правильный ответ: «correct». В address пишутся dd и ss, в tomorrow — rr, в necessary — одна c и две s."
  },
  "Funny has two n letters and ends in y.": {
    "kk": "Дұрыс жауап: «funny». Address сөзінде dd және ss, tomorrow сөзінде rr, necessary сөзінде бір c және екі s жазылады.",
    "ru": "Правильный ответ: «funny». В address пишутся dd и ss, в tomorrow — rr, в necessary — одна c и две s."
  },
  "Small ends in two l letters.": {
    "kk": "Дұрыс жауап: «small». Address сөзінде dd және ss, tomorrow сөзінде rr, necessary сөзінде бір c және екі s жазылады.",
    "ru": "Правильный ответ: «small». В address пишутся dd и ss, в tomorrow — rr, в necessary — одна c и две s."
  },
  "Happy has two p letters and ends in y.": {
    "kk": "Дұрыс жауап: «happy». Address сөзінде dd және ss, tomorrow сөзінде rr, necessary сөзінде бір c және екі s жазылады.",
    "ru": "Правильный ответ: «happy». В address пишутся dd и ss, в tomorrow — rr, в necessary — одна c и две s."
  },
  "Swimmer has two m letters and ends in -er.": {
    "kk": "Дұрыс жауап: «swimmer». Address сөзінде dd және ss, tomorrow сөзінде rr, necessary сөзінде бір c және екі s жазылады.",
    "ru": "Правильный ответ: «swimmer». В address пишутся dd и ss, в tomorrow — rr, в necessary — одна c и две s."
  },
  "Silent letters and letter order": {
    "kk": "Оқылмайтын әріптер және әріп реті",
    "ru": "Непроизносимые буквы и порядок букв"
  },
  "Some letters are written but not heard. Check listen, answer and Wednesday. In friend, i comes before e.": {
    "kk": "Кей әріптер жазылғанымен оқылмайды: listen, answer, Wednesday. Friend сөзінде i әрпі e әрпінен бұрын тұрады.",
    "ru": "Некоторые буквы пишутся, но не произносятся: listen, answer, Wednesday. В friend буква i стоит перед e."
  },
  "Listen has a written t that is not pronounced.": {
    "kk": "Дұрыс жауап: «listen». Кей әріптер жазылғанымен оқылмайды: listen, answer, Wednesday. Friend сөзінде i әрпі e әрпінен бұрын тұрады.",
    "ru": "Правильный ответ: «listen». Некоторые буквы пишутся, но не произносятся: listen, answer, Wednesday. В friend буква i стоит перед e."
  },
  "Answer has a written w that is not pronounced.": {
    "kk": "Дұрыс жауап: «answer». Кей әріптер жазылғанымен оқылмайды: listen, answer, Wednesday. Friend сөзінде i әрпі e әрпінен бұрын тұрады.",
    "ru": "Правильный ответ: «answer». Некоторые буквы пишутся, но не произносятся: listen, answer, Wednesday. В friend буква i стоит перед e."
  },
  "In friend, i comes before e.": {
    "kk": "Дұрыс жауап: «friend». Кей әріптер жазылғанымен оқылмайды: listen, answer, Wednesday. Friend сөзінде i әрпі e әрпінен бұрын тұрады.",
    "ru": "Правильный ответ: «friend». Некоторые буквы пишутся, но не произносятся: listen, answer, Wednesday. В friend буква i стоит перед e."
  },
  "The correct spelling is Wednesday.": {
    "kk": "Дұрыс жауап: «Wednesday». Кей әріптер жазылғанымен оқылмайды: listen, answer, Wednesday. Friend сөзінде i әрпі e әрпінен бұрын тұрады.",
    "ru": "Правильный ответ: «Wednesday». Некоторые буквы пишутся, но не произносятся: listen, answer, Wednesday. В friend буква i стоит перед e."
  },
  "The correct spelling is enough.": {
    "kk": "Дұрыс жауап: «enough». Кей әріптер жазылғанымен оқылмайды: listen, answer, Wednesday. Friend сөзінде i әрпі e әрпінен бұрын тұрады.",
    "ru": "Правильный ответ: «enough». Некоторые буквы пишутся, но не произносятся: listen, answer, Wednesday. В friend буква i стоит перед e."
  },
  "Remember has one m after re- and another in -member.": {
    "kk": "Дұрыс жауап: «remember». Кей әріптер жазылғанымен оқылмайды: listen, answer, Wednesday. Friend сөзінде i әрпі e әрпінен бұрын тұрады.",
    "ru": "Правильный ответ: «remember». Некоторые буквы пишутся, но не произносятся: listen, answer, Wednesday. В friend буква i стоит перед e."
  },
  "Answer includes the sequence -nsw-.": {
    "kk": "Дұрыс жауап: «answer». Кей әріптер жазылғанымен оқылмайды: listen, answer, Wednesday. Friend сөзінде i әрпі e әрпінен бұрын тұрады.",
    "ru": "Правильный ответ: «answer». Некоторые буквы пишутся, но не произносятся: listen, answer, Wednesday. В friend буква i стоит перед e."
  },
  "Knee starts with a silent k.": {
    "kk": "Дұрыс жауап: «knee». Кей әріптер жазылғанымен оқылмайды: listen, answer, Wednesday. Friend сөзінде i әрпі e әрпінен бұрын тұрады.",
    "ru": "Правильный ответ: «knee». Некоторые буквы пишутся, но не произносятся: listen, answer, Wednesday. В friend буква i стоит перед e."
  },
  "Knife begins with a silent k and ends in e.": {
    "kk": "Дұрыс жауап: «knife». Кей әріптер жазылғанымен оқылмайды: listen, answer, Wednesday. Friend сөзінде i әрпі e әрпінен бұрын тұрады.",
    "ru": "Правильный ответ: «knife». Некоторые буквы пишутся, но не произносятся: listen, answer, Wednesday. В friend буква i стоит перед e."
  },
  "Write begins with a silent w and ends in e.": {
    "kk": "Дұрыс жауап: «write». Кей әріптер жазылғанымен оқылмайды: listen, answer, Wednesday. Friend сөзінде i әрпі e әрпінен бұрын тұрады.",
    "ru": "Правильный ответ: «write». Некоторые буквы пишутся, но не произносятся: listen, answer, Wednesday. В friend буква i стоит перед e."
  },
  "Capital letters": {
    "kk": "Бас әріптер",
    "ru": "Заглавные буквы"
  },
  "Use capitals for I, names, languages, countries, months and days. Begin a sentence with a capital letter.": {
    "kk": "I есімдігі, есімдер, тілдер, елдер, айлар және апта күндері бас әріппен жазылады. Сөйлем де бас әріптен басталады.",
    "ru": "С заглавной буквы пишутся I, имена, языки, страны, месяцы и дни недели. Предложение тоже начинается с заглавной буквы."
  },
  "Language names begin with a capital letter: English.": {
    "kk": "Дұрыс жауап: «English». I есімдігі, есімдер, тілдер, елдер, айлар және апта күндері бас әріппен жазылады. Сөйлем де бас әріптен басталады.",
    "ru": "Правильный ответ: «English». С заглавной буквы пишутся I, имена, языки, страны, месяцы и дни недели. Предложение тоже начинается с заглавной буквы."
  },
  "Language names begin with a capital letter: Kazakh.": {
    "kk": "Дұрыс жауап: «Kazakh». I есімдігі, есімдер, тілдер, елдер, айлар және апта күндері бас әріппен жазылады. Сөйлем де бас әріптен басталады.",
    "ru": "Правильный ответ: «Kazakh». С заглавной буквы пишутся I, имена, языки, страны, месяцы и дни недели. Предложение тоже начинается с заглавной буквы."
  },
  "Month names begin with a capital letter.": {
    "kk": "Дұрыс жауап: «June». I есімдігі, есімдер, тілдер, елдер, айлар және апта күндері бас әріппен жазылады. Сөйлем де бас әріптен басталады.",
    "ru": "Правильный ответ: «June». С заглавной буквы пишутся I, имена, языки, страны, месяцы и дни недели. Предложение тоже начинается с заглавной буквы."
  },
  "Day names begin with a capital letter.": {
    "kk": "Дұрыс жауап: «Friday». I есімдігі, есімдер, тілдер, елдер, айлар және апта күндері бас әріппен жазылады. Сөйлем де бас әріптен басталады.",
    "ru": "Правильный ответ: «Friday». С заглавной буквы пишутся I, имена, языки, страны, месяцы и дни недели. Предложение тоже начинается с заглавной буквы."
  },
  "Country names begin with a capital letter.": {
    "kk": "Дұрыс жауап: «Kazakhstan». I есімдігі, есімдер, тілдер, елдер, айлар және апта күндері бас әріппен жазылады. Сөйлем де бас әріптен басталады.",
    "ru": "Правильный ответ: «Kazakhstan». С заглавной буквы пишутся I, имена, языки, страны, месяцы и дни недели. Предложение тоже начинается с заглавной буквы."
  },
  "The pronoun I is always a capital letter.": {
    "kk": "Дұрыс жауап: «I». I есімдігі, есімдер, тілдер, елдер, айлар және апта күндері бас әріппен жазылады. Сөйлем де бас әріптен басталады.",
    "ru": "Правильный ответ: «I». С заглавной буквы пишутся I, имена, языки, страны, месяцы и дни недели. Предложение тоже начинается с заглавной буквы."
  },
  "A person’s name begins with a capital letter.": {
    "kk": "Дұрыс жауап: «Aida». I есімдігі, есімдер, тілдер, елдер, айлар және апта күндері бас әріппен жазылады. Сөйлем де бас әріптен басталады.",
    "ru": "Правильный ответ: «Aida». С заглавной буквы пишутся I, имена, языки, страны, месяцы и дни недели. Предложение тоже начинается с заглавной буквы."
  },
  "City names begin with a capital letter.": {
    "kk": "Дұрыс жауап: «London». I есімдігі, есімдер, тілдер, елдер, айлар және апта күндері бас әріппен жазылады. Сөйлем де бас әріптен басталады.",
    "ru": "Правильный ответ: «London». С заглавной буквы пишутся I, имена, языки, страны, месяцы и дни недели. Предложение тоже начинается с заглавной буквы."
  },
  "Capitalise the first word of the sentence and the language name.": {
    "kk": "Дұрыс жауап: «She likes English.». I есімдігі, есімдер, тілдер, елдер, айлар және апта күндері бас әріппен жазылады. Сөйлем де бас әріптен басталады.",
    "ru": "Правильный ответ: «She likes English.». С заглавной буквы пишутся I, имена, языки, страны, месяцы и дни недели. Предложение тоже начинается с заглавной буквы."
  },
  "24 questions · about 15 minutes": {
    "kk": "24 сұрақ · шамамен 15 минут",
    "ru": "24 вопроса · около 15 минут"
  },
  "One person.": {
    "kk": "Бір адам.",
    "ru": "Один человек."
  },
  "Add -s or -es.": {
    "kk": "-s немесе -es қос.",
    "ru": "Добавь -s или -es."
  },
  "Assel Amanzholova": {
    "kk": "Әсел Аманжолова",
    "ru": "Асель Аманжолова"
  },
  "Assel Amanzholova · School No. 22": {
    "kk": "Әсел Аманжолова · №22 мектеп",
    "ru": "Асель Аманжолова · Школа №22"
  },
  "Ten small pattern checks look for selected verb endings, fixed phrases, prepositions, spelling and capitals. They can miss errors and suggest changes that do not fit your meaning. They do not grade your writing or change your error map. Drafts and saved revisions stay in this browser.": {
    "kk": "Он ереже үлгісі етістік жалғауын, тұрақты тіркесті, предлогты, емле мен бас әріпті тексереді. Кей қатені өткізіп алуы немесе мағынаға сай емес түзету ұсынуы мүмкін. Мәтінге баға қойылмайды, қателер картасы өзгермейді. Мәтіндер осы браузерде сақталады.",
    "ru": "Десять шаблонов проверяют отдельные окончания, устойчивые сочетания, предлоги, орфографию и заглавные буквы. Анализатор может пропустить ошибку или предложить неуместную правку. Он не оценивает текст и не меняет карту ошибок. Черновики и версии сохраняются в этом браузере."
  },
  "This is a shared local workspace, not a password-protected teacher account. Anyone using this browser can open its learner profiles. No server sync is connected.": {
    "kk": "Бұл осы құрылғыдағы ортақ жұмыс аймағы. Мұғалім профилі құпиясөзбен қорғалмаған. Осы браузерді қолданатын адам оқушы профильдерін аша алады. Сервермен синхрондау жоқ.",
    "ru": "Это общая локальная рабочая область без пароля учителя. Любой пользователь этого браузера может открыть профили учеников. Серверная синхронизация не подключена."
  },
  "Independent means a correct first answer without a hint. Corrected answers do not add independent points. A lesson needs at least 3 of 4 independent answers plus an explanation and new sentence before a rule check opens. A rule check needs 2 of 2 correct answers. Rechecks use the reserved matched question for every baseline rule. These are classroom support signals, not validated mastery scores.": {
    "kk": "Өздік нәтиже — алғашқы әрекетте көмексіз берілген дұрыс жауап. Түзетілген жауап оған қосылмайды. Ереже тексеруі ашылуы үшін төрт сұрақтың кемінде үшеуіне көмексіз жауап беріп, түсіндірме мен жаңа сөйлем жазу қажет. Ереже тексеруінде 2/2 қажет. Қайта тестке әр ереженің бөлек жұп сұрағы сақталады. Бұлар сабаққа арналған бағдар, меңгерудің расталған өлшемі емес.",
    "ru": "Самостоятельный результат — верный первый ответ без подсказки. Исправления не добавляют самостоятельных баллов. Для открытия проверки нужны минимум 3/4 таких ответов, объяснение и новое предложение. Проверка правила требует 2/2. В итоговом тесте используются отдельные парные вопросы. Это учебные ориентиры, а не подтверждённая оценка владения."
  },
  "One question for each of 24 rules. Missed answers suggest where to begin.": {
    "kk": "24 ереженің әрқайсысына бір сұрақ беріледі. Қате жауаптар неден бастау керегін көрсетеді.",
    "ru": "По одному вопросу на каждое из 24 правил. Ошибки подсказывают, с чего начать."
  },
  "Four separate examples, a rule explanation and a learner-written sentence.": {
    "kk": "Төрт бөлек мысал, ережені түсіндіру және оқушы жазған сөйлем.",
    "ru": "Четыре отдельных примера, объяснение правила и предложение ученика."
  },
  "Two different examples, answered independently.": {
    "kk": "Екі басқа мысалға өздігінен жауап беру.",
    "ru": "Два других примера для самостоятельного ответа."
  },
  "A reserved question matched to each baseline topic and difficulty band.": {
    "kk": "Әр бастапқы тақырып пен деңгейге сәйкес бөлек сұрақ.",
    "ru": "Отдельный вопрос, соответствующий теме и уровню начальной проверки."
  },
  "240 questions: 144 assessment items and 96 practice items. Every rule has three A/B assessment pairs and four dedicated practice questions. Practice questions never appear in assessments.": {
    "kk": "240 тапсырма: 144 тексеру сұрағы және 96 жаттығу. Әр ережеде үш A/B жұбы және төрт бөлек жаттығу бар. Жаттығу сұрақтары тестке кірмейді.",
    "ru": "240 заданий: 144 вопроса проверок и 96 упражнений. У каждого правила три пары A/B и четыре отдельных упражнения. Упражнения не используются в тестах."
  },
  "Learner codes, unfinished attempts, results, hints, first answers, corrections, reflections and writing revisions are stored in this browser. Backups can be downloaded and restored. There is no shared server database or sign-in system.": {
    "kk": "Оқушы кодтары, аяқталмаған әрекеттер, нәтижелер, көмек, алғашқы жауаптар, түзетулер, түсіндірмелер мен мәтін нұсқалары осы браузерде сақталады. Сақтық көшірмені жүктеп, қалпына келтіруге болады. Ортақ серверлік база мен тіркелу жүйесі жоқ.",
    "ru": "Коды учеников, незаконченные попытки, результаты, подсказки, первые ответы, исправления, объяснения и версии текстов сохраняются в этом браузере. Резервную копию можно скачать и восстановить. Общей серверной базы и системы входа нет."
  },
  "A short test cannot establish mastery. New sentences and rule explanations need teacher review. The small writing checker does not understand every sentence. The paired assessments have not been statistically equated, and no classroom effectiveness study is claimed.": {
    "kk": "Қысқа тест толық меңгеруді дәлелдемейді. Жаңа сөйлемдер мен түсіндірмелерді мұғалім тексереді. Мәтін талдағышы әр сөйлемді толық түсінбейді. Тест жұптары статистикалық теңестірілмеген, сабақтағы тиімділік зерттеуі жарияланбаған.",
    "ru": "Короткий тест не доказывает владение правилом. Предложения и объяснения проверяет учитель. Анализатор не понимает каждый текст полностью. Тесты статистически не уравнивались; исследование эффективности в классе не заявляется."
  },
  "If this is a present-simple statement, check the third-person ending.": {
    "kk": "Бұл Present Simple хабарлы сөйлемі болса, үшінші жақ жалғауын тексер.",
    "ru": "Если это утверждение в Present Simple, проверь окончание третьего лица."
  },
  "After does, use the base form of the main verb.": {
    "kk": "Does сөзінен кейін негізгі етістіктің бастапқы тұлғасын қолдан.",
    "ru": "После does используй начальную форму основного глагола."
  },
  "Use the phrase do homework.": {
    "kk": "Do homework тіркесін қолдан.",
    "ru": "Используй сочетание do homework."
  },
  "Use the phrase take a photo.": {
    "kk": "Take a photo тіркесін қолдан.",
    "ru": "Используй сочетание take a photo."
  },
  "Use on with days of the week.": {
    "kk": "Апта күндерімен on қолданылады.",
    "ru": "С днями недели используется on."
  },
  "Compare the spelling with the suggested word.": {
    "kk": "Сөздің жазылуын ұсынылған нұсқамен салыстыр.",
    "ru": "Сравни написание с предложенным словом."
  },
  "Check the single and double letters.": {
    "kk": "Бір және қос әріптерді тексер.",
    "ru": "Проверь одинарные и двойные буквы."
  },
  "The pronoun I is always capitalised.": {
    "kk": "I есімдігі әрқашан бас әріппен жазылады.",
    "ru": "Местоимение I всегда пишется с заглавной буквы."
  },
  "Language names begin with a capital letter.": {
    "kk": "Тіл атаулары бас әріппен жазылады.",
    "ru": "Названия языков пишутся с заглавной буквы."
  },
  "Storage is unavailable or full. Download a backup before leaving this page.": {
    "kk": "Сақтау орны толған немесе қолжетімсіз. Шықпас бұрын сақтық көшірмені жүкте.",
    "ru": "Хранилище недоступно или заполнено. Перед выходом скачай резервную копию."
  },
  "Changes are not saved.": {
    "kk": "Өзгерістер сақталмады.",
    "ru": "Изменения не сохранены."
  },
  "Download recovery backup": {
    "kk": "Қалпына келтіру көшірмесін жүктеу",
    "ru": "Скачать копию для восстановления"
  },
  "Resume or discard your current assessment first.": {
    "kk": "Алдымен ағымдағы тексеруді жалғастыр немесе жой.",
    "ru": "Сначала продолжи или удали текущую проверку."
  },
  "Finish or discard your saved lesson before starting a baseline.": {
    "kk": "Бастапқы тест алдында сақталған сабақты аяқта немесе жой.",
    "ru": "Перед начальной проверкой заверши или удали сохранённый урок."
  },
  "Your current cycle already has a baseline.": {
    "kk": "Ағымдағы кезеңде бастапқы нәтиже бар.",
    "ru": "В текущем цикле уже есть начальный результат."
  },
  "Finish the assigned rule checks first.": {
    "kk": "Алдымен берілген ережелерді тексеріп аяқта.",
    "ru": "Сначала заверши назначенные проверки правил."
  },
  "Finish or discard your saved practice first.": {
    "kk": "Алдымен сақталған жаттығуды аяқта немесе жой.",
    "ru": "Сначала заверши или удали сохранённую практику."
  },
  "Complete this cycle before starting another one.": {
    "kk": "Жаңа кезеңді бастамас бұрын осы кезеңді аяқта.",
    "ru": "Заверши текущий цикл перед началом нового."
  },
  "Start a new cycle? Previous results will stay. Any unfinished optional lesson will be discarded.": {
    "kk": "Жаңа кезеңді бастау керек пе? Бұрынғы нәтижелер сақталады. Аяқталмаған қосымша сабақ жойылады.",
    "ru": "Начать новый цикл? Предыдущие результаты сохранятся. Незаконченный дополнительный урок будет удалён."
  },
  "Discard this unfinished attempt? Completed results will stay.": {
    "kk": "Аяқталмаған әрекетті жою керек пе? Аяқталған нәтижелер сақталады.",
    "ru": "Удалить незавершённую попытку? Завершённые результаты сохранятся."
  },
  "A baseline already exists for this cycle.": {
    "kk": "Бұл кезеңде бастапқы нәтиже бар.",
    "ru": "В этом цикле уже есть начальный результат."
  },
  "Finish or discard the current assessment first.": {
    "kk": "Алдымен ағымдағы тексеруді аяқта немесе жой.",
    "ru": "Сначала заверши или удали текущую проверку."
  },
  "Resume or discard your saved lesson first.": {
    "kk": "Алдымен сақталған сабақты жалғастыр немесе жой.",
    "ru": "Сначала продолжи или удали сохранённый урок."
  },
  "Compare the options with the explanation and try again.": {
    "kk": "Нұсқаларды түсіндірмемен салыстырып, қайта орында.",
    "ru": "Сравни варианты с объяснением и попробуй снова."
  },
  "Discard this unfinished lesson? Completed lessons will stay.": {
    "kk": "Аяқталмаған сабақты жою керек пе? Аяқталған сабақтар сақталады.",
    "ru": "Удалить незавершённый урок? Завершённые уроки сохранятся."
  },
  "Write a short explanation and a new sentence before saving.": {
    "kk": "Сақтамас бұрын қысқа түсіндірме мен жаңа сөйлем жаз.",
    "ru": "Перед сохранением напиши короткое объяснение и новое предложение."
  },
  "Complete practice with at least 3 of 4 independent first answers and a new example first.": {
    "kk": "Алдымен 4 сұрақтың кемінде үшеуіне көмексіз жауап беріп, жаңа мысал жаз.",
    "ru": "Сначала ответь самостоятельно минимум на 3 из 4 вопросов и напиши новый пример."
  },
  "Lesson saved. If this rule is assigned, you can now check it on new examples.": {
    "kk": "Сабақ сақталды. Бұл ереже берілген болса, оны басқа мысалдармен тексеруге болады.",
    "ru": "Урок сохранён. Если правило назначено, его можно проверить на других примерах."
  },
  "Lesson saved. Review the rule and retry before the independent check.": {
    "kk": "Сабақ сақталды. Өздік тексеру алдында ережені қайталап, жаттығуды қайта орында.",
    "ru": "Урок сохранён. Перед самостоятельной проверкой повтори правило и упражнения."
  },
  "Replace your current draft with the example? Saved revisions will stay.": {
    "kk": "Ағымдағы мәтінді үлгімен ауыстыру керек пе? Сақталған нұсқалар қалады.",
    "ru": "Заменить черновик примером? Сохранённые версии останутся."
  },
  "Write a few sentences first.": {
    "kk": "Алдымен бірнеше сөйлем жаз.",
    "ru": "Сначала напиши несколько предложений."
  },
  "Write a draft first.": {
    "kk": "Алдымен мәтін жаз.",
    "ru": "Сначала напиши черновик."
  },
  "This revision is already saved.": {
    "kk": "Бұл нұсқа сақталған.",
    "ru": "Эта версия уже сохранена."
  },
  "Revision saved for teacher review.": {
    "kk": "Нұсқа мұғалім тексеруі үшін сақталды.",
    "ru": "Версия сохранена для проверки учителем."
  },
  "This rule is already in the plan.": {
    "kk": "Бұл ереже оқу бағытына қосылған.",
    "ru": "Это правило уже есть в маршруте."
  },
  "Rule added to this learning plan.": {
    "kk": "Ереже оқу бағытына қосылды.",
    "ru": "Правило добавлено в маршрут."
  },
  "Teacher assignment removed. Test results are unchanged.": {
    "kk": "Мұғалім тапсырмасы алынды. Тест нәтижелері өзгермеді.",
    "ru": "Назначение убрано. Результаты теста не изменились."
  },
  "Teacher note saved.": {
    "kk": "Мұғалім жазбасы сақталды.",
    "ru": "Заметка учителя сохранена."
  },
  "Choose a backup smaller than 5 MB.": {
    "kk": "5 МБ-тан кіші көшірмені таңда.",
    "ru": "Выбери копию размером меньше 5 МБ."
  },
  "Restore this backup? It will replace all learner profiles on this device. Download the current backup first if you need it.": {
    "kk": "Осы көшірмені қалпына келтіру керек пе? Құрылғыдағы барлық профиль ауыстырылады. Қажет болса, алдымен ағымдағы көшірмені жүкте.",
    "ru": "Восстановить копию? Она заменит все профили на устройстве. При необходимости сначала скачай текущую копию."
  },
  "Backup restored.": {
    "kk": "Көшірме қалпына келтірілді.",
    "ru": "Резервная копия восстановлена."
  },
  "This file is not a valid ErrorMap English backup.": {
    "kk": "Бұл файл ErrorMap сақтық көшірмесіне сәйкес емес.",
    "ru": "Этот файл не является корректной резервной копией ErrorMap."
  },
  "Learner data cleared.": {
    "kk": "Оқушы деректері тазаланды.",
    "ru": "Данные ученика очищены."
  },
  "Use 2–24 letters, numbers, hyphens or underscores.": {
    "kk": "2–24 әріп, сан, дефис немесе төменгі сызық қолдан.",
    "ru": "Используй 2–24 буквы, цифры, дефисы или подчёркивания."
  },
  "This workspace holds up to 100 learner profiles. Export a backup before clearing unused profiles.": {
    "kk": "Бұл аймақта 100 профильге дейін сақталады. Пайдаланылмайтын деректерді тазаламас бұрын көшірме жүкте.",
    "ru": "В области помещается до 100 профилей. Перед очисткой неиспользуемых данных скачай копию."
  },
  "Workspace updated from another tab.": {
    "kk": "Жұмыс аймағы басқа қойындыдан жаңартылды.",
    "ru": "Рабочая область обновлена из другой вкладки."
  },
  "24 matched questions with different examples.": {
    "kk": "Басқа мысалдармен 24 жұп сұрақ.",
    "ru": "24 парных вопроса с другими примерами."
  },
  "Resume it": {
    "kk": "Жалғастыру",
    "ru": "Продолжить"
  },
  "A lesson is saved.": {
    "kk": "Сабақ сақталған.",
    "ru": "Есть сохранённый урок."
  },
  "before starting a new assessment.": {
    "kk": "жаңа тексеруді бастамас бұрын.",
    "ru": "перед началом новой проверки."
  },
  "A rule check is in progress.": {
    "kk": "Ереже тексеруі аяқталмаған.",
    "ru": "Есть незаконченная проверка правила."
  },
  "before starting another assessment.": {
    "kk": "басқа тексеруді бастамас бұрын.",
    "ru": "перед началом другой проверки."
  },
  "Assessments": {
    "kk": "Тексерулер",
    "ru": "Проверки"
  },
  "An earlier site version is archived in your backup. Its questions differ, so old scores are not compared with this cycle.": {
    "kk": "Сайттың бұрынғы нұсқасы сақтық көшірмеге енгізілген. Сұрақтары басқа болғандықтан, ескі ұпайлар осы кезеңмен салыстырылмайды.",
    "ru": "Предыдущая версия сайта сохранена в резервной копии. Её вопросы отличаются, поэтому старые баллы не сравниваются с этим циклом."
  },
  "Saved data could not be opened. A recovery copy was kept on this device.": {
    "kk": "Сақталған деректер ашылмады. Қалпына келтіру көшірмесі осы құрылғыда сақталды.",
    "ru": "Не удалось открыть сохранённые данные. На устройстве оставлена копия для восстановления."
  },
  "Third-person verb example": {
    "kk": "Үшінші жақ етістігінің мысалы",
    "ru": "Пример глагола в третьем лице"
  },
  "ErrorMap workspace": {
    "kk": "ErrorMap жұмыс аймағы",
    "ru": "Рабочая область ErrorMap"
  }
}
````

## dist/assets/welcome.css

````css
:root{--paper:#f8f8f4;--ink:#252738;--muted:#93929b;--line:#e5e5e0;--purple:#6d5acb;--green:#d7ecb7}*{box-sizing:border-box}html{scroll-behavior:smooth}body{margin:0;background:var(--paper);color:var(--ink);font:14px/1.6 'Arial',system-ui,sans-serif}a{color:inherit;text-decoration:none}button,select{font:inherit}button,a,select{touch-action:manipulation}button{cursor:pointer}a:focus-visible,button:focus-visible,select:focus-visible{outline:3px solid #bca9ec;outline-offset:5px}[hidden]{display:none!important}.skip{position:absolute;top:-70px;left:25px;padding:15px;background:white;z-index:20}.skip:focus{top:10px}header{display:flex;justify-content:space-between;align-items:center;gap:28px;max-width:1440px;margin:auto;padding:28px 5%;border-bottom:1px solid var(--line)}.brand{font-size:22px;letter-spacing:-.8px;font-weight:750;display:flex;align-items:center;gap:11px}.brand-icon{font-size:30px;background:var(--ink);color:#fff;width:40px;height:40px;display:flex;align-items:center;justify-content:center;border-radius:12px;font-weight:700;letter-spacing:-3px;position:relative;padding-right:4px}.brand-icon>span{font-size:14px;position:absolute;right:4px;top:1px;color:#d9edba;letter-spacing:0}.brand-tag{font-size:8px;letter-spacing:1.9px;color:#a3a2aa;border-left:1px solid #d5d4d9;margin-left:8px;padding-left:17px;font-weight:500}header nav{display:flex;gap:29px;font-size:11px;color:#8c8a94}header nav a:hover{color:var(--purple)}.header-end{display:flex;align-items:center;gap:22px}select{background:transparent;border:0;color:#77737e;font-size:10px;padding:8px;cursor:pointer}.button{display:inline-flex;align-items:center;justify-content:space-between;gap:36px;padding:16px 23px;border:1px solid transparent;border-radius:8px;font-size:11px;font-weight:550;line-height:1.3;transition:background .2s,transform .2s}.button:hover{transform:translateY(-2px)}.dark{background:var(--ink);color:white}.dark:hover{background:#403c58}.outline{border-color:#dcd9e4;background:transparent}.outline:hover{background:#f0edf7}.white{background:#fff;color:var(--ink)}.small{padding:12px 16px;gap:23px;font-size:10px}main{max-width:1440px;margin:auto;padding:0 5%}.hero{display:grid;grid-template-columns:1.05fr 1fr;gap:42px;min-height:610px;align-items:center;padding:64px 0 70px}.eyebrow{font-size:8px;font-weight:600;letter-spacing:2.2px;display:flex;align-items:center;gap:9px;color:#8c879b}.green-dot{width:6px;height:6px;background:#75a171;border-radius:50%}.hero-copy h1{font-size:clamp(43px,4.5vw,68px);line-height:1.09;letter-spacing:-3px;font-weight:600;margin:29px 0 27px;position:relative}.underlined{color:#6957c6}.hero-copy h1>svg{width:84%;height:18px;display:block;margin-top:-1px}.hero-copy h1>svg path{stroke:#bfb3e8;stroke-width:2;fill:none;stroke-linecap:round;stroke-dasharray:500;stroke-dashoffset:500;animation:draw 1.4s .5s forwards}.hero-description{font-size:14px;line-height:1.9;color:#9b97a4;margin-bottom:28px;max-width:340px}.hero-actions{display:flex;gap:12px;flex-wrap:wrap}.hero-footnote{display:flex;gap:10px;align-items:center;font-size:9px;color:#a09ba9;margin-top:32px}.mini-orbit{width:22px;height:22px;display:grid;place-items:center;background:#eceadf;color:#a7a080;border-radius:50%;font-size:14px}.hero-visual{position:relative;padding:5px 0 35px}.map-window{background:#fff;border:1px solid #e3e0e9;border-radius:16px;transform:rotate(-2deg);box-shadow:0 20px 60px #3c305e08;overflow:hidden;position:relative;z-index:1}.window-bar{display:flex;justify-content:space-between;align-items:center;padding:19px 20px;border-bottom:1px solid #f1eff5;font-size:7px;letter-spacing:1.6px;color:#aba4ba}.window-bar>span:first-child{display:flex;gap:5px}.window-bar i{width:5px;height:5px;border-radius:50%;background:#e5e1ed}.map-stage{height:350px;position:relative;background-image:radial-gradient(#e9e5ed .7px,transparent .7px);background-size:15px 15px;margin:15px 14px}.map-stage>svg{position:absolute;width:100%;height:100%;inset:0}.map-line{fill:none;stroke:#d7d0e6;stroke-width:1.3;stroke-dasharray:5 4;animation:flow 20s linear infinite}.map-hub{width:88px;height:88px;position:absolute;left:50%;top:50%;transform:translate(-50%,-50%);display:flex;align-items:center;justify-content:center;flex-direction:column;background:#fff;border:1px solid #ddd7eb;box-shadow:0 5px 20px #69617609;border-radius:50%;z-index:2}.map-hub>span{font-size:38px;font-weight:750;color:var(--purple);letter-spacing:-4px;padding-right:5px;line-height:1.3}.map-hub small{font-size:5px;letter-spacing:.9px;color:#9d94b1}.map-node{position:absolute;transform:translate(-50%,-50%);width:110px;height:89px;border:1px solid #e4dfed;background:#fff;border-radius:11px;display:flex;align-items:center;justify-content:center;flex-direction:column;box-shadow:0 4px 16px #35294304;transition:transform .2s,border-color .2s;z-index:2}.map-node:hover,.map-node.active{transform:translate(-50%,-56%);border-color:var(--skill)}.map-node>span{background:color-mix(in srgb,var(--skill) 9%,white);color:var(--skill);height:29px;width:29px;border-radius:8px;display:grid;place-items:center;font-size:14px;font-weight:500;margin-bottom:7px}.map-node>strong{font-size:8px;font-weight:500;color:#80768f}.map-node>small{font-size:6px;color:#bbb3c5;position:absolute;top:7px;right:8px}.n0{left:17%;top:24%}.n1{left:50%;top:15%}.n2{left:83%;top:24%}.n3{left:17%;top:76%}.n4{left:50%;top:85%}.n5{left:83%;top:76%}.window-caption{display:flex;align-items:center;gap:7px;margin:0 22px;padding:15px 0 20px;border-top:1px solid #f1eff5;font-size:8px;color:#a69cb6}.cursor-icon{font-size:14px;color:var(--purple)}.preview-label{margin-left:auto;font-size:6px;letter-spacing:1px}.floating-rule{position:absolute;bottom:0;left:-25px;z-index:3;background:#fffefa;padding:16px 23px;display:flex;align-items:center;gap:15px;border:1px solid #e7e4da;border-radius:12px;box-shadow:0 12px 26px #342c4210;transform:rotate(2deg)}.rule-icon{height:32px;width:32px;background:#edf3e6;color:#70975b;border:1px solid #dce8d0;border-radius:50%;display:grid;place-items:center;font-size:17px}.rule-title{font-size:6px;letter-spacing:1.4px;color:#b2a997}.floating-rule p{font-size:14px;margin:4px 0 0;letter-spacing:-.3px}.floating-rule del{color:#c18c7d;text-decoration-thickness:1px}.floating-rule strong{font-weight:500;background:#e1edcf;color:#6d8c50;padding:2px 4px;border-radius:2px}.hand-star{position:absolute;font-size:75px;line-height:1;right:-21px;top:-19px;transform:rotate(16deg);color:#d3b870;z-index:3;font-family:serif}.number-strip{border-top:1px solid var(--line);border-bottom:1px solid var(--line);padding:29px 0;display:flex;gap:45px;align-items:center}.number-strip>div{display:flex;align-items:center;gap:11px}.number-strip strong{font-size:28px;font-weight:500;letter-spacing:-1px}.number-strip span{font-size:9px;color:#a19aa8;max-width:80px;line-height:1.7}.number-strip .strip-note{margin-left:auto;max-width:none;letter-spacing:1.5px;font-size:7px;white-space:nowrap}.section-heading{display:flex;justify-content:space-between;align-items:flex-end;gap:25px;margin-bottom:30px}.section-heading h2{font-size:33px;font-weight:500;letter-spacing:-1.2px;line-height:1.2;margin:14px 0 0}.section-heading>p{font-size:11px;color:#a39aa9;margin:0}.method{padding:74px 0}.method-grid{display:grid;grid-template-columns:repeat(3,1fr);gap:20px}.method-grid article{background:#fff;border:1px solid var(--line);border-radius:14px;padding:25px;overflow:hidden}.step-no{display:flex;justify-content:space-between;font-family:monospace;color:#b0a6bd;font-size:11px}.step-no>span{color:#a294b3;font-size:16px}.method-grid h3{font-size:17px;font-weight:500;letter-spacing:-.4px;margin:28px 0 10px}.method-grid p{font-size:11px;color:#a096ad;max-width:250px;line-height:1.9;margin:0}.mini-check{font-size:10px;background:#f8f7fb;padding:18px;margin-top:25px;border-radius:9px;color:#a398b2}.mini-check>div{display:flex;gap:7px;margin-top:15px}.mini-check>div>span,.mini-check>div>strong{padding:6px 9px;border:1px solid #e7e2ee;border-radius:5px;font-weight:400;background:#fff;font-size:8px}.mini-check strong{color:#77649e}.mini-check strong i{font-style:normal;color:#8a7aa5;margin-left:5px}.mini-route{display:flex;align-items:center;justify-content:center;gap:7px;background:#f8f7fb;border-radius:9px;padding:25px 12px;margin-top:25px;height:108px}.route-item{width:34px;height:34px;display:grid;place-items:center;border:1px solid #e0dbea;color:#c4bace;border-radius:9px;font-size:9px}.route-item.done{background:#f0ede0;border-color:#e7dfcb;color:#b49b6f}.route-item.current{background:#eee8f7;border-color:#c2b3dd;color:#8d78aa}.mini-route i{width:17px;height:1px;background:#ded7e7}.mini-compare{background:#f8f7fb;padding:18px 20px;border-radius:9px;margin-top:25px;height:108px}.mini-compare>div{display:flex;align-items:center;gap:15px;margin-bottom:10px}.mini-compare span{font-size:6px;letter-spacing:1px;color:#b0a2bf;width:35px}.mini-compare i{height:10px;border-radius:2px}.before-bar{width:33%;background:#e7d8c7}.after-bar{width:65%;background:#d3dfc1}.mini-compare small{font-size:6px;color:#b4a9bd}.role-section{display:grid;grid-template-columns:1fr 1fr;gap:22px;margin:0 0 75px}.role-card{padding:31px 33px 35px;border-radius:16px;position:relative;overflow:hidden}.student-card{background:#edeaf8;border:1px solid #e0d9f3}.teacher-card{background:#28293a;color:#fff}.role-top{display:flex;justify-content:space-between;align-items:center;color:#a69bbf}.role-top>span:last-child{font-size:11px}.role-top .eyebrow{font-size:7px;letter-spacing:2px}.teacher-card .eyebrow{color:#aaa0c1}.role-card h2{font-size:32px;letter-spacing:-1px;font-weight:500;line-height:1.2;margin:32px 0 16px;position:relative;z-index:1;max-width:330px}.role-card p{font-size:11px;color:#a49ab7;max-width:280px;position:relative;z-index:1;margin-bottom:27px}.teacher-card p{color:#a8a1ba}.role-card .button{position:relative;z-index:1;font-size:10px;padding:14px 18px;gap:40px}.role-decor{position:absolute;right:-22px;bottom:-74px;font-size:240px;color:#ded8f0;line-height:1;transform:rotate(-7deg);pointer-events:none}.teacher-card .role-decor{color:#37364b;font-size:230px;right:-5px;bottom:-60px;transform:rotate(10deg)}footer{max-width:1440px;margin:auto;padding:32px 5%;border-top:1px solid var(--line);display:flex;justify-content:space-between;align-items:center;gap:25px}.footer-brand{font-size:20px}.footer-brand>span{font-size:24px;color:var(--purple)}footer p{font-size:9px;color:#a49ba9;line-height:1.8;margin:0}footer p span{color:#b9b2be}footer>div:last-child{text-align:right;font-size:9px;color:#8d819d}.footer-note{display:block;font-size:8px;color:#bcb3c2;margin-top:9px}.explore{margin-top:40px;padding:30px;background:#fff;border:1px solid var(--line);border-radius:16px}.explore h2{font-size:27px}.explore button#closeExplore{border:0;background:#f4f1f8;color:#8f81a0;width:34px;height:34px;border-radius:50%;font-size:23px}.explore-grid{display:grid;grid-template-columns:repeat(2,1fr);gap:15px}.explore-rule{padding:20px;background:#faf9fc;border:1px solid #eeeaf4;border-radius:10px}.explore-rule h3{font-size:14px;font-weight:500;margin:0 0 10px}.explore-rule p{font-size:11px;color:#a497ad;line-height:1.9}.explore-rule .example{color:#8c7ba0;background:#f0ecf6;padding:12px;border-radius:7px}.explore-rule a{font-size:10px;color:#80699d;display:inline-block;margin-top:7px}.hero-copy{animation:arrive .7s both}.hero-visual{animation:arrive .9s .15s both}@keyframes draw{to{stroke-dashoffset:0}}@keyframes flow{to{stroke-dashoffset:-180}}@keyframes arrive{from{opacity:0;translate:0 15px}to{opacity:1;translate:0 0}}@media(max-width:1100px){.brand-tag{display:none}header nav{gap:20px}.hero{gap:30px;min-height:570px}.hero-copy h1{font-size:52px}.map-node{width:95px}.number-strip{gap:25px}.method-grid article{padding:23px 20px}.hand-star{right:-12px;top:-15px;font-size:60px}}@media(max-width:780px){header{padding:20px 5%;gap:12px}header nav{display:none}.brand{font-size:20px}.brand-icon{width:35px;height:35px;font-size:26px}.brand-icon>span{font-size:12px}.header-end{gap:8px}.header-end .small{font-size:9px;padding:11px 13px;gap:10px}main{padding:0 6%}.hero{grid-template-columns:1fr;gap:40px;padding:44px 0 46px}.hero-copy h1{font-size:clamp(42px,8vw,66px);max-width:580px;letter-spacing:-2px}.hero-copy h1>svg{width:300px;max-width:85%}.hero-description{font-size:13px}.hero-visual{max-width:550px;width:94%;margin:0 auto}.map-stage{height:330px}.floating-rule{left:-12px;padding:13px 16px}.hero-footnote{margin-top:22px}.number-strip{display:grid;grid-template-columns:repeat(2,1fr);gap:20px;padding:26px 0}.number-strip>div{gap:15px}.number-strip strong{font-size:27px;width:42px}.number-strip span{font-size:9px;max-width:none}.number-strip .strip-note{display:none}.method{padding:49px 0}.section-heading h2{font-size:28px}.section-heading>p{display:none}.method-grid{grid-template-columns:1fr;gap:14px}.method-grid article{padding:23px}.method-grid h3{margin-top:20px}.method-grid p{max-width:none}.mini-check,.mini-route,.mini-compare{margin-top:20px}.role-section{grid-template-columns:1fr;margin-bottom:45px;gap:16px}.role-card{padding:27px}.role-card h2{font-size:31px}.role-decor{font-size:230px;right:0}.teacher-card .role-decor{right:5px}.explore{padding:23px}.explore-grid{grid-template-columns:1fr}footer{align-items:flex-start;flex-wrap:wrap;padding:25px 6%}.footer-brand{width:100%;font-size:19px}footer p{font-size:8px}footer>div:last-child{font-size:8px}.eyebrow{font-size:7px}}@media(max-width:380px){.header-end .small{font-size:8px;padding:10px}.map-node{width:85px}.map-node strong{font-size:7px}.hero-actions .button{gap:19px;padding:15px 19px}.hero-copy h1{font-size:40px}.hero .eyebrow{font-size:6px;letter-spacing:1.5px}.map-stage{margin-left:8px;margin-right:8px}.window-caption{font-size:7px;margin:0 14px}.preview-label{font-size:5px}}@media(prefers-reduced-motion:reduce){html{scroll-behavior:auto}*,*:before,*:after{animation:none!important;transition:none!important}.hero-copy h1>svg path{stroke-dashoffset:0}}
/* Readable supporting type and stronger text contrast. */
header nav{font-size:12px;color:#77707e}.brand-tag{font-size:9px;color:#817889}.hero .eyebrow{font-size:9px;color:#807487}.hero-description{color:#7e7588}.hero-footnote{font-size:10px;color:#857a90}.map-node>strong{font-size:10px;line-height:1.25;color:#786b88}.map-node>small{font-size:7px}.window-bar{font-size:8px;color:#9386a2}.window-caption{font-size:9px;color:#8a7d99}.preview-label{font-size:7px}.rule-title{font-size:8px;color:#9a8d76}.number-strip span{font-size:10px;color:#827589}.method-grid p{font-size:12px;color:#85768f}.role-card p{font-size:12px;color:#877598}.teacher-card p{color:#bdb2cb}.method-grid h3{font-size:18px}.section-heading>.eyebrow{font-size:9px}.explore-rule p{font-size:12px;color:#81718d}.button{font-size:12px}.role-card .button{font-size:11px}.footer-note{color:#8e8198}.mini-check{font-size:11px}.mini-check>div>span,.mini-check>div>strong{font-size:10px}.mini-compare small{font-size:8px}.mini-compare span{font-size:8px}.mini-compare{height:112px}@media(max-width:780px){.map-node>strong{font-size:9px}.hero .eyebrow{font-size:8px}.button{font-size:11px}.number-strip span{font-size:10px}.preview-label{font-size:6px}.window-caption{font-size:8px}}

````

## dist/assets/welcome.js

````javascript
'use strict';
const words={
en:{},
kk:{method:'Әдіс',practice:'Жаттығу',teacher:'Мұғалімге',enter:'Кабинетке кіру',eyebrow:'АҒЫЛШЫН ТІЛІН ҮЙРЕНУДІҢ ЖЕКЕ БАҒЫТЫ',headline1:'Әр қателік —',headline2:'келесі қадам.',description:'Қатені байқа. Ережені түсін.<br>Келесі қадамыңды жаса.',studentCTA:'Мен оқушымын',teacherCTA:'Мен мұғаліммін',footnote:'Жауаптарың оқу бағытыңды қалыптастырады.',mapTitle:'СЕНІҢ ОҚУ КАРТАҢ',tap:'Дағдыны таңдап, қарап көр.',example:'КАРТА ҮЛГІСІ',g0:'Етістіктің қиысуы',g1:'Етістік шақтары',g2:'Сөздер мен тіркестер',g3:'Предлогтар',g4:'Сөз тәртібі',g5:'Емле',ruleExample:'АЙЫРМАШЫЛЫҚТЫ БАЙҚА',questions:'мазмұнды сұрақ',rules:'нақты ереже',skills:'дағды бағыты',languages:'интерфейс тілі',level:'7-СЫНЫПҚА АРНАЛҒАН',closer:'ЖАҚЫНЫРАҚ ТАНЫС',methodTag:'ОҚУ ЦИКЛІ',methodTitle:'Қателіктен — жеке жоспарға.',methodNote:'Әр қадам түсінікті.',step1:'Қатені анықта',step1body:'Бастапқы тексеру қай ережеге назар аудару керегін көрсетеді.',step2:'Ережеңді жаттықтыр',step2body:'Оқы, жаттық және ережені өз сөзіңмен түсіндір.',step3:'Өзгерісті көр',step3body:'Ережеге қайта оралып, жауаптарыңды салыстыр.',before:'БҰРЫН',after:'КЕЙІН',illustration:'Оқу циклінің көрнекі үлгісі',learnerLabel:'ОҚУШЫҒА',studentTitle:'Өз қарқының.<br>Өз бағытың.',studentBody:'Тапсырмалар, кері байланыс және жеке дағдылар картасы.',studentEntry:'Оқушы кабинеті',educatorLabel:'МҰҒАЛІМГЕ',teacherTitle:'Сыныпты таны.<br>Әр оқушыға бағыт бер.',teacherBody:'Тапсырмаларды өңдеңіз. Нәтижені бақылаңыз. Оқуды бағыттаңыз.',teacherEntry:'Мұғалім кабинеті',school:'№22 мектеп · 7-сынып',independent:'Өз бетімен жаттығу',footerNote:'Түсінік айқынырақ. Қадам сенімдірек.',practiceRule:'Ережені жаттықтыру'},
ru:{method:'Метод',practice:'Практика',teacher:'Учителям',enter:'Войти в кабинет',eyebrow:'ЛИЧНЫЙ МАРШРУТ В ИЗУЧЕНИИ АНГЛИЙСКОГО',headline1:'Каждая ошибка —',headline2:'шаг вперёд.',description:'Заметь закономерность. Пойми правило.<br>Сделай следующий шаг.',studentCTA:'Я ученик',teacherCTA:'Я учитель',footnote:'Твои ответы формируют твой учебный маршрут.',mapTitle:'ТВОЯ УЧЕБНАЯ КАРТА',tap:'Выбери навык и посмотри подробнее.',example:'ПРИМЕР КАРТЫ',g0:'Согласование',g1:'Времена глаголов',g2:'Слова и выражения',g3:'Предлоги',g4:'Порядок слов',g5:'Правописание',ruleExample:'ЗАМЕТЬ РАЗНИЦУ',questions:'содержательных вопросов',rules:'конкретных правила',skills:'областей навыков',languages:'языка интерфейса',level:'ДЛЯ 7 КЛАССА',closer:'ПОСМОТРИ БЛИЖЕ',methodTag:'УЧЕБНЫЙ ЦИКЛ',methodTitle:'Из ошибки — в личный план.',methodNote:'Один понятный шаг за другим.',step1:'Найди закономерность',step1body:'Начальная проверка покажет, каким правилам уделить внимание.',step2:'Поработай с правилом',step2body:'Прочитай, потренируйся и объясни правило своими словами.',step3:'Увидь изменения',step3body:'Вернись к правилу и сравни свои ответы.',before:'ДО',after:'ПОСЛЕ',illustration:'Иллюстрация учебного цикла',learnerLabel:'УЧЕНИКУ',studentTitle:'Твой темп.<br>Твой следующий шаг.',studentBody:'Задания, обратная связь и личная карта навыков.',studentEntry:'Кабинет ученика',educatorLabel:'УЧИТЕЛЮ',teacherTitle:'Увидеть класс.<br>Помочь каждому.',teacherBody:'Редактируйте задания. Анализируйте ответы. Направляйте обучение.',teacherEntry:'Кабинет учителя',school:'Школа №22 · 7 класс',independent:'Самостоятельная практика',footerNote:'Чуть понятнее. На шаг дальше.',practiceRule:'Практика правила'}};
let locale=localStorage.getItem('errormap-language')||'en';if(!words[locale])locale='en';const originals=new Map();document.querySelectorAll('[data-i]').forEach(el=>originals.set(el,el.innerHTML));let activeSkill=null;
const escape=v=>String(v).replace(/[&<>"']/g,c=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]));
function update(){if(window.I18N)window.I18N.set(locale);document.documentElement.lang=locale;document.querySelectorAll('[data-i]').forEach(el=>el.innerHTML=words[locale][el.dataset.i]||originals.get(el));if(activeSkill)showSkill(activeSkill,false)}
function showSkill(id,scroll=true){activeSkill=id;const groups=['agr','tense','vocab','prep','order','spell'],index=groups.indexOf(id);document.querySelectorAll('[data-skill]').forEach(b=>b.classList.toggle('active',b.dataset.skill===id));document.querySelector('#explore').hidden=false;document.querySelector('#exploreTitle').textContent=document.querySelector('[data-i="g'+index+'"]').textContent;const us=window.ERRORMAP_CONTENT.units.filter(u=>u.skill===id);document.querySelector('#exploreRules').innerHTML='<div class="explore-grid">'+us.map(u=>`<article class="explore-rule"><h3>${escape(window.I18N?.t(u.title)||u.title)}</h3><p>${escape(window.I18N?.t(u.rule)||u.rule)}</p><p class="example">${escape(u.example)}</p><a href="learning-path.html?unit=${encodeURIComponent(u.id)}">${escape(words[locale].practiceRule||'Practice rule')} ↗</a></article>`).join('')+'</div>';if(scroll)document.querySelector('#explore').scrollIntoView({behavior:'smooth',block:'start'})}
document.querySelectorAll('[data-skill]').forEach(b=>b.onclick=()=>showSkill(b.dataset.skill));document.querySelector('#closeExplore').onclick=()=>{document.querySelector('#explore').hidden=true;activeSkill=null;document.querySelectorAll('[data-skill]').forEach(b=>b.classList.remove('active'))};document.querySelector('#language').value=locale;document.querySelector('#language').onchange=e=>{locale=e.target.value;localStorage.setItem('errormap-language',locale);update()};update();

````

## dist/assignments.html

````html
<!doctype html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><meta name="description" content="ErrorMap English learning workspace. Student tasks and teacher dashboard."><title>Assignments — ErrorMap</title><link rel="icon" href="assets/favicon.svg"><link rel="stylesheet" href="assets/portal.css?v=9.1"><script defer src="assets/cloud-config.js?v=9.1"></script><script defer src="assets/question-bank.js"></script><script defer src="assets/i18n.js"></script><script defer src="assets/portal-locale.js?v=9.1"></script><script defer src="assets/cloud-api.js?v=9.1"></script><script defer src="assets/portal.js?v=9.1"></script></head><body data-portal="assignments" data-title="Assignments"><header><a class="brand" href="index.html">Error<span>Map</span></a><div class="header-tools"><select id="languageSelect" aria-label="Language"><option value="en">EN</option><option value="kk">ҚАЗ</option><option value="ru">РУС</option></select><button class="secondary" id="logout" type="button" data-i="Sign out">Sign out</button></div></header><div id="notice" role="status" hidden></div><div class="shell"><aside class="sidebar"><nav aria-label="Teacher navigation"><a href="teacher-dashboard.html" class="" data-i="Overview">Overview</a><a href="classes.html" class="" data-i="Classes">Classes</a><a href="assignments.html" class="active" aria-current="page" data-i="Assignments">Assignments</a><a href="task-editor.html" class="" data-i="Editor">Editor</a><a href="class-results.html" class="" data-i="Results">Results</a><a href="teacher-settings.html" class="" data-i="Settings">Settings</a><small>ErrorMap · School No. 22</small></nav></aside><main id="app" class=""></main></div><dialog id="modal"><div class="actions" style="justify-content:flex-end"><button type="button" class="secondary" data-action="close-modal" aria-label="Close">×</button></div><div id="modalBody"></div></dialog><footer>Assel Amanzholova · School No. 22 · Grade 7</footer></body></html>
````

## dist/class-results.html

````html
<!doctype html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><meta name="description" content="ErrorMap English learning workspace. Student tasks and teacher dashboard."><title>Results — ErrorMap</title><link rel="icon" href="assets/favicon.svg"><link rel="stylesheet" href="assets/portal.css?v=9.1"><script defer src="assets/cloud-config.js?v=9.1"></script><script defer src="assets/question-bank.js"></script><script defer src="assets/i18n.js"></script><script defer src="assets/portal-locale.js?v=9.1"></script><script defer src="assets/cloud-api.js?v=9.1"></script><script defer src="assets/portal.js?v=9.1"></script></head><body data-portal="class-results" data-title="Results"><header><a class="brand" href="index.html">Error<span>Map</span></a><div class="header-tools"><select id="languageSelect" aria-label="Language"><option value="en">EN</option><option value="kk">ҚАЗ</option><option value="ru">РУС</option></select><button class="secondary" id="logout" type="button" data-i="Sign out">Sign out</button></div></header><div id="notice" role="status" hidden></div><div class="shell"><aside class="sidebar"><nav aria-label="Teacher navigation"><a href="teacher-dashboard.html" class="" data-i="Overview">Overview</a><a href="classes.html" class="" data-i="Classes">Classes</a><a href="assignments.html" class="" data-i="Assignments">Assignments</a><a href="task-editor.html" class="" data-i="Editor">Editor</a><a href="class-results.html" class="active" aria-current="page" data-i="Results">Results</a><a href="teacher-settings.html" class="" data-i="Settings">Settings</a><small>ErrorMap · School No. 22</small></nav></aside><main id="app" class=""></main></div><dialog id="modal"><div class="actions" style="justify-content:flex-end"><button type="button" class="secondary" data-action="close-modal" aria-label="Close">×</button></div><div id="modalBody"></div></dialog><footer>Assel Amanzholova · School No. 22 · Grade 7</footer></body></html>
````

## dist/classes.html

````html
<!doctype html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><meta name="description" content="ErrorMap English learning workspace. Student tasks and teacher dashboard."><title>Classes — ErrorMap</title><link rel="icon" href="assets/favicon.svg"><link rel="stylesheet" href="assets/portal.css?v=9.1"><script defer src="assets/cloud-config.js?v=9.1"></script><script defer src="assets/question-bank.js"></script><script defer src="assets/i18n.js"></script><script defer src="assets/portal-locale.js?v=9.1"></script><script defer src="assets/cloud-api.js?v=9.1"></script><script defer src="assets/portal.js?v=9.1"></script></head><body data-portal="classes" data-title="Classes"><header><a class="brand" href="index.html">Error<span>Map</span></a><div class="header-tools"><select id="languageSelect" aria-label="Language"><option value="en">EN</option><option value="kk">ҚАЗ</option><option value="ru">РУС</option></select><button class="secondary" id="logout" type="button" data-i="Sign out">Sign out</button></div></header><div id="notice" role="status" hidden></div><div class="shell"><aside class="sidebar"><nav aria-label="Teacher navigation"><a href="teacher-dashboard.html" class="" data-i="Overview">Overview</a><a href="classes.html" class="active" aria-current="page" data-i="Classes">Classes</a><a href="assignments.html" class="" data-i="Assignments">Assignments</a><a href="task-editor.html" class="" data-i="Editor">Editor</a><a href="class-results.html" class="" data-i="Results">Results</a><a href="teacher-settings.html" class="" data-i="Settings">Settings</a><small>ErrorMap · School No. 22</small></nav></aside><main id="app" class=""></main></div><dialog id="modal"><div class="actions" style="justify-content:flex-end"><button type="button" class="secondary" data-action="close-modal" aria-label="Close">×</button></div><div id="modalBody"></div></dialog><footer>Assel Amanzholova · School No. 22 · Grade 7</footer></body></html>
````

## dist/classroom/index.html

````html
<!doctype html><html lang="en"><head><meta charset="utf-8"><meta http-equiv="refresh" content="0;url=../student.html"><title>ErrorMap</title></head><body><a href="../student.html">Open workspace →</a></body></html>
````

## dist/classroom/student.html

````html
<!doctype html><html lang="en"><head><meta charset="utf-8"><meta http-equiv="refresh" content="0;url=../student.html"><title>ErrorMap</title></head><body><a href="../student.html">Open workspace →</a></body></html>
````

## dist/classroom/teacher.html

````html
<!doctype html><html lang="en"><head><meta charset="utf-8"><meta http-equiv="refresh" content="0;url=../teacher-login.html"><title>ErrorMap</title></head><body><a href="../teacher-login.html">Open workspace →</a></body></html>
````

## dist/diagnostic.html

````html
<!doctype html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><meta name="description" content="ErrorMap: a clear English learning plan. Check 24 rules, practise specific gaps and recheck on new examples."><meta name="theme-color" content="#4b52d4"><title>Check — ErrorMap</title><link rel="icon" href="assets/favicon.svg" type="image/svg+xml"><link rel="stylesheet" href="assets/design.css"><link rel="stylesheet" href="assets/lab-workspace.css?v=8.1"></head><body data-page="diagnostic"><a class="skip" href="#app">Skip to content</a><aside><a class="brand" href="index.html" aria-label="ErrorMap workspace"><span class="mark" aria-hidden="true">e<span>↗</span></span>ErrorMap<span class="dot" aria-hidden="true">.</span></a><nav aria-label="Main navigation"><a data-page="home" href="index.html">Workspace</a><a data-page="diagnostic" href="diagnostic.html" aria-current="page">Check</a><a data-page="map" href="error-map.html">Error map</a><a data-page="route" href="learning-path.html">Learning plan</a><a data-page="studio" href="writing.html">Writing</a><a data-page="bank" href="library.html">Library</a><a data-page="teacher" href="teacher-login.html">Teacher</a><a data-page="about" href="about.html">About</a></nav></aside><div class="shell"><header><span id="crumb">Check</span><div><label class="language-picker"><span class="sr-only">Language</span><select id="languageSelect" class="language-select" aria-label="Interface language" onchange="changeLanguage(this.value)"><option value="en">English</option><option value="kk">Қазақша</option><option value="ru">Русский</option></select></label><span id="saveStatus" class="status" role="status">Local workspace</span><button class="light" id="profileBtn" aria-haspopup="dialog">Learner: <b id="profileCode">LEARNER-01</b></button></div></header><div id="storageWarning" class="storage-warning" role="alert" hidden>Changes are not saved. <button class="light small" onclick="exportBackup()">Download recovery backup</button></div><main id="app" tabindex="-1"></main><footer><div><b>ErrorMap.</b><br>Assel Amanzholova · School No. 22</div><a href="about.html">How it works →</a></footer></div><dialog id="profileDialog" aria-labelledby="profileTitle"><form method="dialog"><h2 id="profileTitle">Learner profile</h2><p>Select a saved code or create a new one. Each learner keeps separate results and unfinished work.</p><label for="codeInput">Learner code<input id="codeInput" list="profileList" maxlength="24" placeholder="Example: LEARNER-02" autocomplete="off"></label><datalist id="profileList"></datalist><small>Use a code, not a real name. Letters, numbers, hyphens and underscores only.</small><div class="row"><button value="cancel" class="light">Cancel</button><button id="saveCode" value="save">Open profile</button></div></form></dialog><div id="toast" role="status" aria-live="polite"></div><script src="assets/question-bank.js"></script><script src="assets/i18n.js"></script><script src="assets/app.js"></script></body></html>
````

## dist/error-map.html

````html
<!doctype html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><meta name="description" content="ErrorMap: a clear English learning plan. Check 24 rules, practise specific gaps and recheck on new examples."><meta name="theme-color" content="#4b52d4"><title>Error map — ErrorMap</title><link rel="icon" href="assets/favicon.svg" type="image/svg+xml"><link rel="stylesheet" href="assets/design.css"><link rel="stylesheet" href="assets/lab-workspace.css?v=8.1"></head><body data-page="map"><a class="skip" href="#app">Skip to content</a><aside><a class="brand" href="index.html" aria-label="ErrorMap workspace"><span class="mark" aria-hidden="true">e<span>↗</span></span>ErrorMap<span class="dot" aria-hidden="true">.</span></a><nav aria-label="Main navigation"><a data-page="home" href="index.html">Workspace</a><a data-page="diagnostic" href="diagnostic.html">Check</a><a data-page="map" href="error-map.html" aria-current="page">Error map</a><a data-page="route" href="learning-path.html">Learning plan</a><a data-page="studio" href="writing.html">Writing</a><a data-page="bank" href="library.html">Library</a><a data-page="teacher" href="teacher-login.html">Teacher</a><a data-page="about" href="about.html">About</a></nav></aside><div class="shell"><header><span id="crumb">Error map</span><div><label class="language-picker"><span class="sr-only">Language</span><select id="languageSelect" class="language-select" aria-label="Interface language" onchange="changeLanguage(this.value)"><option value="en">English</option><option value="kk">Қазақша</option><option value="ru">Русский</option></select></label><span id="saveStatus" class="status" role="status">Local workspace</span><button class="light" id="profileBtn" aria-haspopup="dialog">Learner: <b id="profileCode">LEARNER-01</b></button></div></header><div id="storageWarning" class="storage-warning" role="alert" hidden>Changes are not saved. <button class="light small" onclick="exportBackup()">Download recovery backup</button></div><main id="app" tabindex="-1"></main><footer><div><b>ErrorMap.</b><br>Assel Amanzholova · School No. 22</div><a href="about.html">How it works →</a></footer></div><dialog id="profileDialog" aria-labelledby="profileTitle"><form method="dialog"><h2 id="profileTitle">Learner profile</h2><p>Select a saved code or create a new one. Each learner keeps separate results and unfinished work.</p><label for="codeInput">Learner code<input id="codeInput" list="profileList" maxlength="24" placeholder="Example: LEARNER-02" autocomplete="off"></label><datalist id="profileList"></datalist><small>Use a code, not a real name. Letters, numbers, hyphens and underscores only.</small><div class="row"><button value="cancel" class="light">Cancel</button><button id="saveCode" value="save">Open profile</button></div></form></dialog><div id="toast" role="status" aria-live="polite"></div><script src="assets/question-bank.js"></script><script src="assets/i18n.js"></script><script src="assets/app.js"></script></body></html>
````

## dist/index.html

````html
<!doctype html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><meta name="description" content="ErrorMap — a personal route through Grade 7 English. Student and teacher workspaces by Assel Amanzholova, School No. 22."><meta name="theme-color" content="#f8f8f4"><title>ErrorMap — Find your next step.</title><link rel="icon" href="assets/favicon.svg"><link rel="stylesheet" href="assets/welcome.css"><link rel="stylesheet" href="assets/lab.css?v=9"><script defer src="assets/question-bank.js"></script><script defer src="assets/i18n.js"></script><script defer src="assets/welcome.js"></script><script defer src="assets/home-pages.js?v=9"></script></head><body><a class="skip" href="#main">Skip to content</a><header><a href="index.html" class="brand"><span class="brand-icon">e<span>↗</span></span><span>Error<span class="brand-map">Map</span></span><span class="brand-tag">ENGLISH LAB</span></a><nav aria-label="Main navigation"><a href="#method" data-i="method">The method</a><a href="library.html" data-i="practice">Practice</a><a href="teacher-login.html" data-i="teacher">For teachers</a></nav><div class="header-end"><select id="language" aria-label="Language"><option value="en">EN</option><option value="kk">ҚАЗ</option><option value="ru">РУС</option></select><a class="button dark small" href="student.html"><span data-i="enter">Enter workspace</span> ↗</a></div></header><main id="main"><section class="hero"><div class="hero-copy"><div class="eyebrow"><span class="eyebrow-line"></span><span data-i="eyebrow">YOUR ENGLISH LEARNING LAB</span></div><h1 class="lab-title">ErrorMap<span class="title-spark" aria-hidden="true">✧</span></h1><h2 class="lab-motto"><span data-i="headline1">Find the pattern.</span> <span data-i="headline2">Take the next step.</span></h2><p class="hero-description" data-i="description">See your mistakes, understand the rules and build your personal route through English.</p><div class="login-glass"><div class="role-entry-grid"><a class="role-entry student-entry" href="student.html"><span class="entry-label" data-i="studentEntry">Student</span><strong data-i="studentAction">Open your workspace</strong><span aria-hidden="true">↗</span></a><a class="role-entry" href="teacher-login.html"><span class="entry-label" data-i="teacherEntry">Teacher</span><strong data-i="teacherAction">Sign in to your dashboard</strong><span aria-hidden="true">↗</span></a></div><button type="button" class="guest-entry" id="guestButton"><span data-i="guestEntry">Explore as a guest</span> →</button><p class="guest-note" data-i="guestNote">Explore the learning tools without an account.</p></div></div><div class="hero-visual"><article class="sentence-demo" aria-labelledby="sentenceTitle"><div class="demo-label" data-i="demoLabel">ONE SENTENCE. ONE RULE.</div><h2 id="sentenceTitle" data-i="demoTitle">Small change. Clear meaning.</h2><div class="sentence-before"><span data-i="demoBefore">Before</span><p>She <del>go</del> to school every day.</p></div><div class="sentence-after"><span data-i="demoAfter">After</span><p>She <strong>goes</strong> to school every day.</p></div><div class="sentence-rule"><b>He / She / It + verb + s</b><p data-i="demoRule">In the present simple, add -s or -es with he, she and it.</p></div><a class="button dark" href="learning-path.html?unit=third-person"><span data-i="demoTry">Practise this rule</span> ↗</a></article></div></section><section class="guest-workspace" id="guestWorkspace" hidden><div class="guest-welcome"><span class="guest-avatar">↗</span><div><h2 data-i="guestHello">Welcome, explorer.</h2><p data-i="guestInfo">Independent practice · class results need sign-in.</p></div><a class="button dark" href="workspace.html"><span data-i="startPractice">Start learning</span> ↗</a></div><form class="quick-writing" id="quickWriting"><label for="quickText" data-i="quickLabel">Bring a sentence. Find your next step.</label><div><input id="quickText" placeholder="She go to school every day." maxlength="500" required><button type="submit"><span data-i="checkSentence">Open writing studio</span> ↗</button></div></form><div class="guest-feature-grid"><a href="diagnostic.html"><span class="feature-icon">◎</span><h3 data-i="featureCheck">Diagnostic</h3><p data-i="featureCheckBody">24 questions. Find the rules to work on.</p><span class="feature-arrow">↗</span></a><a href="library.html"><span class="feature-icon">▤</span><h3 data-i="featureLibrary">Question library</h3><p data-i="featureLibraryBody">240 examples, explanations and practice.</p><span class="feature-arrow">↗</span></a><a href="learning-path.html"><span class="feature-icon">⌘</span><h3 data-i="featurePlan">Learning route</h3><p data-i="featurePlanBody">Rule by rule. Practice, reflect and recheck.</p><span class="feature-arrow">↗</span></a><a href="writing.html"><span class="feature-icon">✎</span><h3 data-i="featureWriting">Writing studio</h3><p data-i="featureWritingBody">Notice patterns in your own sentences.</p><span class="feature-arrow">↗</span></a></div></section><section class="number-strip"><div><strong>240</strong><span data-i="questions">purposeful questions</span></div><div><strong>24</strong><span data-i="rules">specific rules</span></div><div><strong>6</strong><span data-i="skills">skill areas</span></div><div><strong>3</strong><span data-i="languages">interface languages</span></div><span class="strip-note" data-i="level">BUILT FOR GRADE 7</span></section><section class="explore" id="explore" hidden><div class="section-heading"><div><span class="eyebrow" data-i="closer">A CLOSER LOOK</span><h2 id="exploreTitle"></h2></div><button id="closeExplore" aria-label="Close">×</button></div><div id="exploreRules"></div></section><section class="method" id="method"><div class="section-heading"><div><span class="eyebrow" data-i="methodTag">THE LEARNING CYCLE</span><h2 data-i="methodTitle">A mistake becomes a plan.</h2></div><p data-i="methodNote">One clear step at a time.</p></div><div class="method-grid"><article><span class="step-no">01 <span>↗</span></span><h3 data-i="step1">Find the pattern</h3><p data-i="step1body">A short check reveals which rules need attention.</p><div class="mini-check"><span>She ___ every day.</span><div><span>read</span><strong>reads <i>✓</i></strong><span>reading</span></div></div></article><article><span class="step-no">02 <span>↗</span></span><h3 data-i="step2">Work on your rules</h3><p data-i="step2body">Read, practise and explain the rule in your own words.</p><div class="mini-route"><span class="route-item done">01</span><i></i><span class="route-item current">02</span><i></i><span class="route-item">03</span><i></i><span class="route-item">04</span></div></article><article><span class="step-no">03 <span>↗</span></span><h3 data-i="step3">See what changed</h3><p data-i="step3body">Return to the rule and compare your answers.</p><div class="mini-compare"><div><span data-i="before">BEFORE</span><i class="before-bar"></i></div><div><span data-i="after">AFTER</span><i class="after-bar"></i></div><small data-i="illustration">Illustration of the learning cycle</small></div></article></div></section><section class="skills-lab"><div class="section-heading"><div><span class="eyebrow" data-i="closer">LOOK CLOSER</span><h2 data-i="skillsTitle">Six skills. Your own route.</h2></div><p data-i="tap">Choose a skill to explore.</p></div><div class="lab-skills"><button data-skill="agr"><span>V₁</span><strong data-i="g0">Verb agreement</strong><small>01 ↗</small></button><button data-skill="tense"><span>V₂</span><strong data-i="g1">Verb tenses</strong><small>02 ↗</small></button><button data-skill="vocab"><span>L</span><strong data-i="g2">Words & phrases</strong><small>03 ↗</small></button><button data-skill="prep"><span>P</span><strong data-i="g3">Prepositions</strong><small>04 ↗</small></button><button data-skill="order"><span>W</span><strong data-i="g4">Word order</strong><small>05 ↗</small></button><button data-skill="spell"><span>S</span><strong data-i="g5">Spelling</strong><small>06 ↗</small></button></div></section></main><footer><div class="brand footer-brand">ErrorMap<span>↗</span></div><p>Assel Amanzholova<br><span data-i="school">School No. 22 · Grade 7</span></p><div><a href="workspace.html" data-i="independent">Independent practice</a><span class="footer-note" data-i="footerNote">A little clearer. A step further.</span></div></footer></body></html>

````

## dist/learning-path.html

````html
<!doctype html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><meta name="description" content="ErrorMap: a clear English learning plan. Check 24 rules, practise specific gaps and recheck on new examples."><meta name="theme-color" content="#4b52d4"><title>Learning plan — ErrorMap</title><link rel="icon" href="assets/favicon.svg" type="image/svg+xml"><link rel="stylesheet" href="assets/design.css"><link rel="stylesheet" href="assets/lab-workspace.css?v=8.1"></head><body data-page="route"><a class="skip" href="#app">Skip to content</a><aside><a class="brand" href="index.html" aria-label="ErrorMap workspace"><span class="mark" aria-hidden="true">e<span>↗</span></span>ErrorMap<span class="dot" aria-hidden="true">.</span></a><nav aria-label="Main navigation"><a data-page="home" href="index.html">Workspace</a><a data-page="diagnostic" href="diagnostic.html">Check</a><a data-page="map" href="error-map.html">Error map</a><a data-page="route" href="learning-path.html" aria-current="page">Learning plan</a><a data-page="studio" href="writing.html">Writing</a><a data-page="bank" href="library.html">Library</a><a data-page="teacher" href="teacher-login.html">Teacher</a><a data-page="about" href="about.html">About</a></nav></aside><div class="shell"><header><span id="crumb">Learning plan</span><div><label class="language-picker"><span class="sr-only">Language</span><select id="languageSelect" class="language-select" aria-label="Interface language" onchange="changeLanguage(this.value)"><option value="en">English</option><option value="kk">Қазақша</option><option value="ru">Русский</option></select></label><span id="saveStatus" class="status" role="status">Local workspace</span><button class="light" id="profileBtn" aria-haspopup="dialog">Learner: <b id="profileCode">LEARNER-01</b></button></div></header><div id="storageWarning" class="storage-warning" role="alert" hidden>Changes are not saved. <button class="light small" onclick="exportBackup()">Download recovery backup</button></div><main id="app" tabindex="-1"></main><footer><div><b>ErrorMap.</b><br>Assel Amanzholova · School No. 22</div><a href="about.html">How it works →</a></footer></div><dialog id="profileDialog" aria-labelledby="profileTitle"><form method="dialog"><h2 id="profileTitle">Learner profile</h2><p>Select a saved code or create a new one. Each learner keeps separate results and unfinished work.</p><label for="codeInput">Learner code<input id="codeInput" list="profileList" maxlength="24" placeholder="Example: LEARNER-02" autocomplete="off"></label><datalist id="profileList"></datalist><small>Use a code, not a real name. Letters, numbers, hyphens and underscores only.</small><div class="row"><button value="cancel" class="light">Cancel</button><button id="saveCode" value="save">Open profile</button></div></form></dialog><div id="toast" role="status" aria-live="polite"></div><script src="assets/question-bank.js"></script><script src="assets/i18n.js"></script><script src="assets/app.js"></script></body></html>
````

## dist/library.html

````html
<!doctype html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><meta name="description" content="ErrorMap: a clear English learning plan. Check 24 rules, practise specific gaps and recheck on new examples."><meta name="theme-color" content="#4b52d4"><title>Library — ErrorMap</title><link rel="icon" href="assets/favicon.svg" type="image/svg+xml"><link rel="stylesheet" href="assets/design.css"><link rel="stylesheet" href="assets/lab-workspace.css?v=8.1"></head><body data-page="bank"><a class="skip" href="#app">Skip to content</a><aside><a class="brand" href="index.html" aria-label="ErrorMap workspace"><span class="mark" aria-hidden="true">e<span>↗</span></span>ErrorMap<span class="dot" aria-hidden="true">.</span></a><nav aria-label="Main navigation"><a data-page="home" href="index.html">Workspace</a><a data-page="diagnostic" href="diagnostic.html">Check</a><a data-page="map" href="error-map.html">Error map</a><a data-page="route" href="learning-path.html">Learning plan</a><a data-page="studio" href="writing.html">Writing</a><a data-page="bank" href="library.html" aria-current="page">Library</a><a data-page="teacher" href="teacher-login.html">Teacher</a><a data-page="about" href="about.html">About</a></nav></aside><div class="shell"><header><span id="crumb">Library</span><div><label class="language-picker"><span class="sr-only">Language</span><select id="languageSelect" class="language-select" aria-label="Interface language" onchange="changeLanguage(this.value)"><option value="en">English</option><option value="kk">Қазақша</option><option value="ru">Русский</option></select></label><span id="saveStatus" class="status" role="status">Local workspace</span><button class="light" id="profileBtn" aria-haspopup="dialog">Learner: <b id="profileCode">LEARNER-01</b></button></div></header><div id="storageWarning" class="storage-warning" role="alert" hidden>Changes are not saved. <button class="light small" onclick="exportBackup()">Download recovery backup</button></div><main id="app" tabindex="-1"></main><footer><div><b>ErrorMap.</b><br>Assel Amanzholova · School No. 22</div><a href="about.html">How it works →</a></footer></div><dialog id="profileDialog" aria-labelledby="profileTitle"><form method="dialog"><h2 id="profileTitle">Learner profile</h2><p>Select a saved code or create a new one. Each learner keeps separate results and unfinished work.</p><label for="codeInput">Learner code<input id="codeInput" list="profileList" maxlength="24" placeholder="Example: LEARNER-02" autocomplete="off"></label><datalist id="profileList"></datalist><small>Use a code, not a real name. Letters, numbers, hyphens and underscores only.</small><div class="row"><button value="cancel" class="light">Cancel</button><button id="saveCode" value="save">Open profile</button></div></form></dialog><div id="toast" role="status" aria-live="polite"></div><script src="assets/question-bank.js"></script><script src="assets/i18n.js"></script><script src="assets/app.js"></script></body></html>
````

## dist/student-results.html

````html
<!doctype html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><meta name="description" content="ErrorMap English learning workspace. Student tasks and teacher dashboard."><title>Results — ErrorMap</title><link rel="icon" href="assets/favicon.svg"><link rel="stylesheet" href="assets/portal.css?v=9.1"><script defer src="assets/cloud-config.js?v=9.1"></script><script defer src="assets/question-bank.js"></script><script defer src="assets/i18n.js"></script><script defer src="assets/portal-locale.js?v=9.1"></script><script defer src="assets/cloud-api.js?v=9.1"></script><script defer src="assets/portal.js?v=9.1"></script></head><body data-portal="student-results" data-title="Results"><header><a class="brand" href="index.html">Error<span>Map</span></a><div class="header-tools"><select id="languageSelect" aria-label="Language"><option value="en">EN</option><option value="kk">ҚАЗ</option><option value="ru">РУС</option></select><a class="button secondary" href="teacher-login.html" data-i="Teacher workspace">Teacher workspace</a></div></header><div id="notice" role="status" hidden></div><main id="app" class="student"></main><dialog id="modal"><div class="actions" style="justify-content:flex-end"><button type="button" class="secondary" data-action="close-modal" aria-label="Close">×</button></div><div id="modalBody"></div></dialog><footer>Assel Amanzholova · School No. 22 · Grade 7</footer></body></html>
````

## dist/student-task.html

````html
<!doctype html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><meta name="description" content="ErrorMap English learning workspace. Student tasks and teacher dashboard."><title>Open assignment — ErrorMap</title><link rel="icon" href="assets/favicon.svg"><link rel="stylesheet" href="assets/portal.css?v=9.1"><script defer src="assets/cloud-config.js?v=9.1"></script><script defer src="assets/question-bank.js"></script><script defer src="assets/i18n.js"></script><script defer src="assets/portal-locale.js?v=9.1"></script><script defer src="assets/cloud-api.js?v=9.1"></script><script defer src="assets/portal.js?v=9.1"></script></head><body data-portal="student-task" data-title="Open assignment"><header><a class="brand" href="index.html">Error<span>Map</span></a><div class="header-tools"><select id="languageSelect" aria-label="Language"><option value="en">EN</option><option value="kk">ҚАЗ</option><option value="ru">РУС</option></select><a class="button secondary" href="teacher-login.html" data-i="Teacher workspace">Teacher workspace</a></div></header><div id="notice" role="status" hidden></div><main id="app" class="student"></main><dialog id="modal"><div class="actions" style="justify-content:flex-end"><button type="button" class="secondary" data-action="close-modal" aria-label="Close">×</button></div><div id="modalBody"></div></dialog><footer>Assel Amanzholova · School No. 22 · Grade 7</footer></body></html>
````

## dist/student.html

````html
<!doctype html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><meta name="description" content="ErrorMap English learning workspace. Student tasks and teacher dashboard."><title>Student workspace — ErrorMap</title><link rel="icon" href="assets/favicon.svg"><link rel="stylesheet" href="assets/portal.css?v=9.1"><script defer src="assets/cloud-config.js?v=9.1"></script><script defer src="assets/question-bank.js"></script><script defer src="assets/i18n.js"></script><script defer src="assets/portal-locale.js?v=9.1"></script><script defer src="assets/cloud-api.js?v=9.1"></script><script defer src="assets/portal.js?v=9.1"></script></head><body data-portal="student" data-title="Student workspace"><header><a class="brand" href="index.html">Error<span>Map</span></a><div class="header-tools"><select id="languageSelect" aria-label="Language"><option value="en">EN</option><option value="kk">ҚАЗ</option><option value="ru">РУС</option></select><a class="button secondary" href="teacher-login.html" data-i="Teacher workspace">Teacher workspace</a></div></header><div id="notice" role="status" hidden></div><main id="app" class="student"></main><dialog id="modal"><div class="actions" style="justify-content:flex-end"><button type="button" class="secondary" data-action="close-modal" aria-label="Close">×</button></div><div id="modalBody"></div></dialog><footer>Assel Amanzholova · School No. 22 · Grade 7</footer></body></html>
````

## dist/task-editor.html

````html
<!doctype html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><meta name="description" content="ErrorMap English learning workspace. Student tasks and teacher dashboard."><title>Editor — ErrorMap</title><link rel="icon" href="assets/favicon.svg"><link rel="stylesheet" href="assets/portal.css?v=9.1"><script defer src="assets/cloud-config.js?v=9.1"></script><script defer src="assets/question-bank.js"></script><script defer src="assets/i18n.js"></script><script defer src="assets/portal-locale.js?v=9.1"></script><script defer src="assets/cloud-api.js?v=9.1"></script><script defer src="assets/portal.js?v=9.1"></script></head><body data-portal="task-editor" data-title="Editor"><header><a class="brand" href="index.html">Error<span>Map</span></a><div class="header-tools"><select id="languageSelect" aria-label="Language"><option value="en">EN</option><option value="kk">ҚАЗ</option><option value="ru">РУС</option></select><button class="secondary" id="logout" type="button" data-i="Sign out">Sign out</button></div></header><div id="notice" role="status" hidden></div><div class="shell"><aside class="sidebar"><nav aria-label="Teacher navigation"><a href="teacher-dashboard.html" class="" data-i="Overview">Overview</a><a href="classes.html" class="" data-i="Classes">Classes</a><a href="assignments.html" class="" data-i="Assignments">Assignments</a><a href="task-editor.html" class="active" aria-current="page" data-i="Editor">Editor</a><a href="class-results.html" class="" data-i="Results">Results</a><a href="teacher-settings.html" class="" data-i="Settings">Settings</a><small>ErrorMap · School No. 22</small></nav></aside><main id="app" class=""></main></div><dialog id="modal"><div class="actions" style="justify-content:flex-end"><button type="button" class="secondary" data-action="close-modal" aria-label="Close">×</button></div><div id="modalBody"></div></dialog><footer>Assel Amanzholova · School No. 22 · Grade 7</footer></body></html>
````

## dist/teacher-dashboard.html

````html
<!doctype html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><meta name="description" content="ErrorMap English learning workspace. Student tasks and teacher dashboard."><title>Overview — ErrorMap</title><link rel="icon" href="assets/favicon.svg"><link rel="stylesheet" href="assets/portal.css?v=9.1"><script defer src="assets/cloud-config.js?v=9.1"></script><script defer src="assets/question-bank.js"></script><script defer src="assets/i18n.js"></script><script defer src="assets/portal-locale.js?v=9.1"></script><script defer src="assets/cloud-api.js?v=9.1"></script><script defer src="assets/portal.js?v=9.1"></script></head><body data-portal="teacher-dashboard" data-title="Overview"><header><a class="brand" href="index.html">Error<span>Map</span></a><div class="header-tools"><select id="languageSelect" aria-label="Language"><option value="en">EN</option><option value="kk">ҚАЗ</option><option value="ru">РУС</option></select><button class="secondary" id="logout" type="button" data-i="Sign out">Sign out</button></div></header><div id="notice" role="status" hidden></div><div class="shell"><aside class="sidebar"><nav aria-label="Teacher navigation"><a href="teacher-dashboard.html" class="active" aria-current="page" data-i="Overview">Overview</a><a href="classes.html" class="" data-i="Classes">Classes</a><a href="assignments.html" class="" data-i="Assignments">Assignments</a><a href="task-editor.html" class="" data-i="Editor">Editor</a><a href="class-results.html" class="" data-i="Results">Results</a><a href="teacher-settings.html" class="" data-i="Settings">Settings</a><small>ErrorMap · School No. 22</small></nav></aside><main id="app" class=""></main></div><dialog id="modal"><div class="actions" style="justify-content:flex-end"><button type="button" class="secondary" data-action="close-modal" aria-label="Close">×</button></div><div id="modalBody"></div></dialog><footer>Assel Amanzholova · School No. 22 · Grade 7</footer></body></html>
````

## dist/teacher-login.html

````html
<!doctype html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><meta name="description" content="ErrorMap English learning workspace. Student tasks and teacher dashboard."><title>Teacher workspace — ErrorMap</title><link rel="icon" href="assets/favicon.svg"><link rel="stylesheet" href="assets/portal.css?v=9.1"><script defer src="assets/cloud-config.js?v=9.1"></script><script defer src="assets/question-bank.js"></script><script defer src="assets/i18n.js"></script><script defer src="assets/portal-locale.js?v=9.1"></script><script defer src="assets/cloud-api.js?v=9.1"></script><script defer src="assets/portal.js?v=9.1"></script></head><body data-portal="teacher-login" data-title="Teacher workspace"><header><a class="brand" href="index.html">Error<span>Map</span></a><div class="header-tools"><select id="languageSelect" aria-label="Language"><option value="en">EN</option><option value="kk">ҚАЗ</option><option value="ru">РУС</option></select><a class="button secondary" href="student.html" data-i="Student workspace">Student workspace</a></div></header><div id="notice" role="status" hidden></div><main id="app" class="login"></main><dialog id="modal"><div class="actions" style="justify-content:flex-end"><button type="button" class="secondary" data-action="close-modal" aria-label="Close">×</button></div><div id="modalBody"></div></dialog><footer>Assel Amanzholova · School No. 22 · Grade 7</footer></body></html>
````

## dist/teacher-settings.html

````html
<!doctype html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><meta name="description" content="ErrorMap English learning workspace. Student tasks and teacher dashboard."><title>Settings — ErrorMap</title><link rel="icon" href="assets/favicon.svg"><link rel="stylesheet" href="assets/portal.css?v=9.1"><script defer src="assets/cloud-config.js?v=9.1"></script><script defer src="assets/question-bank.js"></script><script defer src="assets/i18n.js"></script><script defer src="assets/portal-locale.js?v=9.1"></script><script defer src="assets/cloud-api.js?v=9.1"></script><script defer src="assets/portal.js?v=9.1"></script></head><body data-portal="teacher-settings" data-title="Settings"><header><a class="brand" href="index.html">Error<span>Map</span></a><div class="header-tools"><select id="languageSelect" aria-label="Language"><option value="en">EN</option><option value="kk">ҚАЗ</option><option value="ru">РУС</option></select><button class="secondary" id="logout" type="button" data-i="Sign out">Sign out</button></div></header><div id="notice" role="status" hidden></div><div class="shell"><aside class="sidebar"><nav aria-label="Teacher navigation"><a href="teacher-dashboard.html" class="" data-i="Overview">Overview</a><a href="classes.html" class="" data-i="Classes">Classes</a><a href="assignments.html" class="" data-i="Assignments">Assignments</a><a href="task-editor.html" class="" data-i="Editor">Editor</a><a href="class-results.html" class="" data-i="Results">Results</a><a href="teacher-settings.html" class="active" aria-current="page" data-i="Settings">Settings</a><small>ErrorMap · School No. 22</small></nav></aside><main id="app" class=""></main></div><dialog id="modal"><div class="actions" style="justify-content:flex-end"><button type="button" class="secondary" data-action="close-modal" aria-label="Close">×</button></div><div id="modalBody"></div></dialog><footer>Assel Amanzholova · School No. 22 · Grade 7</footer></body></html>
````

## dist/teacher.html

````html
<!doctype html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><meta http-equiv="refresh" content="0;url=teacher-login.html"><title>Teacher — ErrorMap</title></head><body><select id="languageSelect" hidden><option>EN</option></select><a href="teacher-login.html">Teacher workspace →</a></body></html>
````

## dist/workspace.html

````html
<!doctype html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><meta name="description" content="ErrorMap: a clear English learning plan. Check 24 rules, practise specific gaps and recheck on new examples."><meta name="theme-color" content="#4b52d4"><title>Workspace — ErrorMap</title><link rel="icon" href="assets/favicon.svg" type="image/svg+xml"><link rel="stylesheet" href="assets/design.css"><link rel="stylesheet" href="assets/lab-workspace.css?v=8.1"></head><body data-page="home"><a class="skip" href="#app">Skip to content</a><aside><a class="brand" href="index.html" aria-label="ErrorMap workspace"><span class="mark" aria-hidden="true">e<span>↗</span></span>ErrorMap<span class="dot" aria-hidden="true">.</span></a><nav aria-label="Main navigation"><a data-page="home" href="index.html" aria-current="page">Workspace</a><a data-page="diagnostic" href="diagnostic.html">Check</a><a data-page="map" href="error-map.html">Error map</a><a data-page="route" href="learning-path.html">Learning plan</a><a data-page="studio" href="writing.html">Writing</a><a data-page="bank" href="library.html">Library</a><a data-page="teacher" href="teacher-login.html">Teacher</a><a data-page="about" href="about.html">About</a></nav></aside><div class="shell"><header><span id="crumb">Workspace</span><div><label class="language-picker"><span class="sr-only">Language</span><select id="languageSelect" class="language-select" aria-label="Interface language" onchange="changeLanguage(this.value)"><option value="en">English</option><option value="kk">Қазақша</option><option value="ru">Русский</option></select></label><span id="saveStatus" class="status" role="status">Local workspace</span><button class="light" id="profileBtn" aria-haspopup="dialog">Learner: <b id="profileCode">LEARNER-01</b></button></div></header><div id="storageWarning" class="storage-warning" role="alert" hidden>Changes are not saved. <button class="light small" onclick="exportBackup()">Download recovery backup</button></div><main id="app" tabindex="-1"></main><footer><div><b>ErrorMap.</b><br>Assel Amanzholova · School No. 22</div><a href="about.html">How it works →</a></footer></div><dialog id="profileDialog" aria-labelledby="profileTitle"><form method="dialog"><h2 id="profileTitle">Learner profile</h2><p>Select a saved code or create a new one. Each learner keeps separate results and unfinished work.</p><label for="codeInput">Learner code<input id="codeInput" list="profileList" maxlength="24" placeholder="Example: LEARNER-02" autocomplete="off"></label><datalist id="profileList"></datalist><small>Use a code, not a real name. Letters, numbers, hyphens and underscores only.</small><div class="row"><button value="cancel" class="light">Cancel</button><button id="saveCode" value="save">Open profile</button></div></form></dialog><div id="toast" role="status" aria-live="polite"></div><script src="assets/question-bank.js"></script><script src="assets/i18n.js"></script><script src="assets/app.js"></script></body></html>
````

## dist/writing.html

````html
<!doctype html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><meta name="description" content="ErrorMap: a clear English learning plan. Check 24 rules, practise specific gaps and recheck on new examples."><meta name="theme-color" content="#4b52d4"><title>Writing — ErrorMap</title><link rel="icon" href="assets/favicon.svg" type="image/svg+xml"><link rel="stylesheet" href="assets/design.css"><link rel="stylesheet" href="assets/lab-workspace.css?v=8.1"></head><body data-page="studio"><a class="skip" href="#app">Skip to content</a><aside><a class="brand" href="index.html" aria-label="ErrorMap workspace"><span class="mark" aria-hidden="true">e<span>↗</span></span>ErrorMap<span class="dot" aria-hidden="true">.</span></a><nav aria-label="Main navigation"><a data-page="home" href="index.html">Workspace</a><a data-page="diagnostic" href="diagnostic.html">Check</a><a data-page="map" href="error-map.html">Error map</a><a data-page="route" href="learning-path.html">Learning plan</a><a data-page="studio" href="writing.html" aria-current="page">Writing</a><a data-page="bank" href="library.html">Library</a><a data-page="teacher" href="teacher-login.html">Teacher</a><a data-page="about" href="about.html">About</a></nav></aside><div class="shell"><header><span id="crumb">Writing</span><div><label class="language-picker"><span class="sr-only">Language</span><select id="languageSelect" class="language-select" aria-label="Interface language" onchange="changeLanguage(this.value)"><option value="en">English</option><option value="kk">Қазақша</option><option value="ru">Русский</option></select></label><span id="saveStatus" class="status" role="status">Local workspace</span><button class="light" id="profileBtn" aria-haspopup="dialog">Learner: <b id="profileCode">LEARNER-01</b></button></div></header><div id="storageWarning" class="storage-warning" role="alert" hidden>Changes are not saved. <button class="light small" onclick="exportBackup()">Download recovery backup</button></div><main id="app" tabindex="-1"></main><footer><div><b>ErrorMap.</b><br>Assel Amanzholova · School No. 22</div><a href="about.html">How it works →</a></footer></div><dialog id="profileDialog" aria-labelledby="profileTitle"><form method="dialog"><h2 id="profileTitle">Learner profile</h2><p>Select a saved code or create a new one. Each learner keeps separate results and unfinished work.</p><label for="codeInput">Learner code<input id="codeInput" list="profileList" maxlength="24" placeholder="Example: LEARNER-02" autocomplete="off"></label><datalist id="profileList"></datalist><small>Use a code, not a real name. Letters, numbers, hyphens and underscores only.</small><div class="row"><button value="cancel" class="light">Cancel</button><button id="saveCode" value="save">Open profile</button></div></form></dialog><div id="toast" role="status" aria-live="polite"></div><script src="assets/question-bank.js"></script><script src="assets/i18n.js"></script><script src="assets/app.js"></script></body></html>
````

## package.json

````json
{
  "name": "errormap-github-pages",
  "private": true,
  "scripts": {
    "dev": "python3 scripts/preview.py",
    "test": "node tests/check.cjs && node tests/portal_test.cjs && node tests/cloud_test.cjs"
  }
}
````

## pages.yml

````yaml
name: Publish ErrorMap
on:
  push:
    branches: [main]
  workflow_dispatch:
permissions:
  contents: read
  pages: write
  id-token: write
concurrency:
  group: pages
  cancel-in-progress: true
jobs:
  deploy:
    runs-on: ubuntu-latest
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    steps:
      - uses: actions/checkout@v7.0.1
      - name: Check learning cycle
        run: node tests/check.cjs
      - name: Check portal contracts
        run: node tests/portal_test.cjs
      - name: Check cloud transport
        run: node tests/cloud_test.cjs
      - name: Reject test fixtures
        run: test ! -d dist/qa
      - uses: actions/configure-pages@v6.0.0
      - uses: actions/upload-pages-artifact@v5.0.0
        with:
          path: dist
      - name: Deploy
        id: deployment
        uses: actions/deploy-pages@v5.0.1

````

## scripts/build_pages.py

````python
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1];D=ROOT/'dist'
pages={'teacher-login':('Teacher workspace',False),'teacher-dashboard':('Overview',True),'classes':('Classes',True),'assignments':('Assignments',True),'task-editor':('Editor',True),'class-results':('Results',True),'teacher-settings':('Settings',True),'student':('Student workspace',False),'student-task':('Open assignment',False),'student-results':('Results',False)}
nav=[('teacher-dashboard','Overview'),('classes','Classes'),('assignments','Assignments'),('task-editor','Editor'),('class-results','Results'),('teacher-settings','Settings')]
for page,(title,teacher) in pages.items():
 side='<aside class="sidebar"><nav aria-label="Teacher navigation">'+''.join(f'<a href="{p}.html" class="{"active" if p==page else ""}"'+(' aria-current="page"' if p==page else '')+f' data-i="{t}">{t}</a>' for p,t in nav)+'<small>ErrorMap · School No. 22</small></nav></aside>' if teacher else ''
 tools='<button class="secondary" id="logout" type="button" data-i="Sign out">Sign out</button>' if teacher else '<a class="button secondary" href="'+('student.html' if page=='teacher-login' else 'teacher-login.html')+'" data-i="'+('Student workspace' if page=='teacher-login' else 'Teacher workspace')+'">'+('Student workspace' if page=='teacher-login' else 'Teacher workspace')+'</a>'
 html=f'''<!doctype html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><meta name="description" content="ErrorMap English learning workspace. Student tasks and teacher dashboard."><title>{title} — ErrorMap</title><link rel="icon" href="assets/favicon.svg"><link rel="stylesheet" href="assets/portal.css?v=9.1"><script defer src="assets/cloud-config.js?v=9.1"></script><script defer src="assets/question-bank.js"></script><script defer src="assets/i18n.js"></script><script defer src="assets/portal-locale.js?v=9.1"></script><script defer src="assets/cloud-api.js?v=9.1"></script><script defer src="assets/portal.js?v=9.1"></script></head><body data-portal="{page}" data-title="{title}"><header><a class="brand" href="index.html">Error<span>Map</span></a><div class="header-tools"><select id="languageSelect" aria-label="Language"><option value="en">EN</option><option value="kk">ҚАЗ</option><option value="ru">РУС</option></select>{tools}</div></header><div id="notice" role="status" hidden></div>{'<div class="shell">' if teacher else ''}{side}<main id="app" class="{'login' if page=='teacher-login' else 'student' if not teacher else ''}"></main>{'</div>' if teacher else ''}<dialog id="modal"><div class="actions" style="justify-content:flex-end"><button type="button" class="secondary" data-action="close-modal" aria-label="Close">×</button></div><div id="modalBody"></div></dialog><footer>Assel Amanzholova · School No. 22 · Grade 7</footer></body></html>'''
 (D/(page+'.html')).write_text(html)
(D/'teacher.html').write_text('''<!doctype html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><meta http-equiv="refresh" content="0;url=teacher-login.html"><title>Teacher — ErrorMap</title></head><body><select id="languageSelect" hidden><option>EN</option></select><a href="teacher-login.html">Teacher workspace →</a></body></html>''')
for name in ['index.html','workspace.html','diagnostic.html','error-map.html','learning-path.html','writing.html','library.html','about.html']:
 p=D/name;s=p.read_text().replace('classroom/student.html','student.html').replace('classroom/teacher.html','teacher-login.html')
 if name!='index.html':s=s.replace('href="teacher.html"','href="teacher-login.html"').replace('href="index.html" data-page="home"','href="workspace.html" data-page="home"')
 p.write_text(s)
p=D/'index.html';s=p.read_text();start=s.index('<div class="login-glass">');end=s.index('<div class="hero-visual">',start)
s=s[:start]+'''<div class="login-glass"><div class="role-entry-grid"><a class="role-entry student-entry" href="student.html"><span class="entry-label" data-i="studentEntry">Student</span><strong data-i="studentAction">Open your workspace</strong><span aria-hidden="true">↗</span></a><a class="role-entry" href="teacher-login.html"><span class="entry-label" data-i="teacherEntry">Teacher</span><strong data-i="teacherAction">Sign in to your dashboard</strong><span aria-hidden="true">↗</span></a></div><button type="button" class="guest-entry" id="guestButton"><span data-i="guestEntry">Explore as a guest</span> →</button><p class="guest-note" data-i="guestNote">Explore the learning tools without an account.</p></div></div>'''+s[end:]
s=s.replace('assets/lab.js?v=8.1','assets/home-pages.js?v=9.1').replace('assets/lab.css?v=8.1','assets/lab.css?v=9.1')
p.write_text(s)
legacy=D/'classroom'
if legacy.exists():
 for name,target in [('index.html','student.html'),('student.html','student.html'),('teacher.html','teacher-login.html')]:
  (legacy/name).write_text(f'<!doctype html><html lang="en"><head><meta charset="utf-8"><meta http-equiv="refresh" content="0;url=../{target}"><title>ErrorMap</title></head><body><a href="../{target}">Open workspace →</a></body></html>')
 for name in ['classroom.js','experience.js','classroom.css']:(legacy/name).unlink(missing_ok=True)

````

## scripts/preview.py

````python
import argparse
from functools import partial
from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path
p=argparse.ArgumentParser()
p.add_argument('--host',default='0.0.0.0')
p.add_argument('--port',type=int,default=4173)
p.add_argument('--strictPort',action='store_true')
a=p.parse_args()
root=Path(__file__).resolve().parents[1]/'dist'
ThreadingHTTPServer((a.host,a.port),partial(SimpleHTTPRequestHandler,directory=str(root))).serve_forever()

````

## scripts/qa_fixture.py

````python
from pathlib import Path
root=Path(__file__).resolve().parents[1];q=root/'dist/qa';q.mkdir(exist_ok=True)
for name in ['teacher-dashboard','classes','assignments','task-editor','class-results','teacher-settings','student','student-task','student-results']:
 s=(root/'dist'/f'{name}.html').read_text().replace('href="assets/','href="../assets/').replace('src="assets/','src="../assets/')
 s=s.replace('<script defer src="../assets/portal.js?v=9.1"></script>','<script defer src="fixture.js?v=9.1"></script><script defer src="../assets/portal.js?v=9.1"></script>')
 s=s.replace('<header>','<div style="background:#fff2a8;padding:10px;text-align:center;font:12px system-ui">QA FIXTURE · SIMULATED SERVICE · NOT A LIVE ACCOUNT</div><header>')
 (q/f'{name}.html').write_text(s)
(q/'fixture.js').write_text((root/'tests/browser-fixture.js').read_text())

````

## supabase/MAIL_SETUP.md

````markdown
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

````

## supabase/approve_teacher.sql

````sql
-- Replace the address below after creating the teacher in Authentication → Users.
insert into public.em_teachers(user_id,display_name)
select id,'Assel Amanzholova' from auth.users
where lower(email)=lower('REPLACE_WITH_TEACHER_EMAIL')
on conflict(user_id) do nothing;

````

## supabase/config.toml

````toml
[functions.send-reports]
# The function verifies REPORT_WORKER_SECRET itself. It must never be public without that check.
verify_jwt = false

````

## supabase/functions/send-reports/index.ts

````typescript
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

````

## supabase/schema.sql

````sql
-- ErrorMap GitHub Pages edition. Run once in a new Supabase project.
begin;
create table public.em_teachers (
 user_id uuid primary key references auth.users(id) on delete cascade,
 display_name text not null default '', report_email text not null default '',
 created_at timestamptz not null default now()
);
create table public.em_classes (
 id uuid primary key default gen_random_uuid(),
 teacher_id uuid not null references public.em_teachers(user_id),
 name text not null check(length(trim(name)) between 1 and 60),
 code text not null unique default replace(gen_random_uuid()::text,'-',''),
 archived boolean not null default false, created_at timestamptz not null default now()
);
create table public.em_tasks (
 id uuid primary key default gen_random_uuid(),
 teacher_id uuid not null references public.em_teachers(user_id),
 class_id uuid not null references public.em_classes(id),
 title text not null check(length(trim(title)) between 1 and 120),
 instructions text not null default '' check(length(instructions)<=2000),
 code text not null unique default replace(gen_random_uuid()::text,'-',''),
 questions jsonb not null, is_open boolean not null default false,
 published_at timestamptz, due_at timestamptz,
 created_at timestamptz not null default now()
);
create table public.em_results (
 id uuid primary key default gen_random_uuid(),
 task_id uuid not null references public.em_tasks(id), attempt_id uuid not null,
 student_name text not null check(length(trim(student_name)) between 1 and 100),
 class_name text not null, answers jsonb not null, score integer not null,
 total integer not null, result jsonb not null, writing text not null default '',
 teacher_feedback text not null default '' check(length(teacher_feedback)<=5000),
 reviewed boolean not null default false, submitted_at timestamptz not null default now(),
 unique(task_id,attempt_id)
);
create table public.em_mail_queue (
 id uuid primary key default gen_random_uuid(),
 result_id uuid not null unique references public.em_results(id),
 teacher_id uuid not null references public.em_teachers(user_id),
 recipient text not null, status text not null default 'pending'
 check(status in ('pending','sent','failed')),
 attempts integer not null default 0, last_error text not null default '',
 created_at timestamptz not null default now(), sent_at timestamptz
);
create index on public.em_classes(teacher_id);
create index on public.em_tasks(teacher_id,class_id);
create index on public.em_results(task_id,submitted_at);
create index on public.em_mail_queue(status,created_at);

alter table public.em_teachers enable row level security;
alter table public.em_classes enable row level security;
alter table public.em_tasks enable row level security;
alter table public.em_results enable row level security;
alter table public.em_mail_queue enable row level security;
revoke all on public.em_teachers,public.em_classes,public.em_tasks,
 public.em_results,public.em_mail_queue from anon,authenticated;
grant select on public.em_teachers,public.em_classes,public.em_tasks,
 public.em_results,public.em_mail_queue to authenticated;
grant update(display_name,report_email) on public.em_teachers to authenticated;
grant insert on public.em_classes,public.em_tasks to authenticated;
grant update(name,archived) on public.em_classes to authenticated;
grant update(title,instructions,class_id,questions,is_open,published_at,due_at)
 on public.em_tasks to authenticated;
grant update(teacher_feedback,reviewed) on public.em_results to authenticated;
create policy teacher_self on public.em_teachers for select to authenticated
 using(user_id=(select auth.uid()));
create policy teacher_settings on public.em_teachers for update to authenticated
 using(user_id=(select auth.uid())) with check(user_id=(select auth.uid()));
create policy classes_own on public.em_classes for select to authenticated
 using(teacher_id=(select auth.uid()));
create policy classes_insert on public.em_classes for insert to authenticated
 with check(teacher_id=(select auth.uid()) and exists(
 select 1 from public.em_teachers where user_id=(select auth.uid())));
create policy classes_update on public.em_classes for update to authenticated
 using(teacher_id=(select auth.uid())) with check(teacher_id=(select auth.uid()));
create policy tasks_own on public.em_tasks for select to authenticated
 using(teacher_id=(select auth.uid()));
create policy tasks_insert on public.em_tasks for insert to authenticated
 with check(teacher_id=(select auth.uid()) and exists(
 select 1 from public.em_classes c where c.id=class_id and c.teacher_id=(select auth.uid())));
create policy tasks_update on public.em_tasks for update to authenticated
 using(teacher_id=(select auth.uid())) with check(teacher_id=(select auth.uid()) and exists(
 select 1 from public.em_classes c where c.id=class_id and c.teacher_id=(select auth.uid())));
create policy results_own on public.em_results for select to authenticated
 using(exists(select 1 from public.em_tasks t where t.id=task_id and t.teacher_id=(select auth.uid())));
create policy results_review on public.em_results for update to authenticated
 using(exists(select 1 from public.em_tasks t where t.id=task_id and t.teacher_id=(select auth.uid())))
 with check(exists(select 1 from public.em_tasks t where t.id=task_id and t.teacher_id=(select auth.uid())));
create policy mail_own on public.em_mail_queue for select to authenticated
 using(teacher_id=(select auth.uid()));

create function public.em_validate_task() returns trigger language plpgsql
set search_path=pg_catalog,public as $$
declare q jsonb; o jsonb;
begin
 if not exists(select 1 from public.em_classes c where c.id=new.class_id
 and c.teacher_id=new.teacher_id and not c.archived) then
 raise exception 'Choose an active class'; end if;
 if tg_op='UPDATE' and old.published_at is not null then
 if new.questions is distinct from old.questions or new.class_id is distinct from old.class_id
 or new.title is distinct from old.title or new.published_at is distinct from old.published_at
 or new.instructions is distinct from old.instructions then
 raise exception 'Published content is fixed. Duplicate the assignment to edit it.'; end if;
 end if;
 if jsonb_typeof(new.questions) is distinct from 'array' then raise exception 'Invalid questions'; end if;
 if jsonb_array_length(new.questions) not between 1 and 50 then raise exception 'Use 1 to 50 questions'; end if;
 for q in select value from jsonb_array_elements(new.questions) loop
 if jsonb_typeof(q->'prompt') is distinct from 'string'
 or length(trim(q->>'prompt')) not between 1 and 1000 then raise exception 'Invalid question'; end if;
 if jsonb_typeof(q->'options') is distinct from 'array' then raise exception 'Invalid options'; end if;
 if jsonb_array_length(q->'options')<>3 then raise exception 'Use three answer options'; end if;
 for o in select value from jsonb_array_elements(q->'options') loop
 if jsonb_typeof(o) is distinct from 'string' or length(trim(o#>>'{}')) not between 1 and 300
 then raise exception 'Invalid answer option'; end if; end loop;
 if (select count(distinct lower(trim(value))) from jsonb_array_elements_text(q->'options'))<>3
 then raise exception 'Answer options must be different'; end if;
 if jsonb_typeof(q->'answer') is distinct from 'number' or (q->>'answer') not in ('0','1','2')
 then raise exception 'Invalid answer key'; end if;
 if jsonb_typeof(q->'explanation') is distinct from 'string'
 or length(trim(q->>'explanation')) not between 1 and 2000 then raise exception 'Add an explanation'; end if;
 end loop;
 if new.is_open and new.published_at is null then raise exception 'Publish first'; end if;
 return new;
end $$;
create trigger em_task_check before insert or update on public.em_tasks
 for each row execute function public.em_validate_task();

create function public.em_get_class(p_code text) returns jsonb language plpgsql
security definer set search_path=pg_catalog,public as $$
declare c public.em_classes%rowtype; ts jsonb;
begin
 if p_code is null or length(trim(p_code))<>32 then raise exception 'Invalid class code'; end if;
 select * into c from public.em_classes where code=lower(trim(p_code)) and not archived;
 if not found then raise exception 'Class not found'; end if;
 select coalesce(jsonb_agg(jsonb_build_object('title',title,'code',code,'due_at',due_at)
 order by created_at desc),'[]') into ts from public.em_tasks where class_id=c.id
 and is_open and published_at is not null and (due_at is null or due_at>now());
 return jsonb_build_object('name',c.name,'tasks',ts);
end $$;
create function public.em_get_task(p_code text) returns jsonb language plpgsql
security definer set search_path=pg_catalog,public as $$
declare t public.em_tasks%rowtype; qs jsonb; cn text;
begin
 if p_code is null or length(trim(p_code))<>32 then raise exception 'Invalid assignment code'; end if;
 select t0.* into t from public.em_tasks t0 join public.em_classes c on c.id=t0.class_id
 where t0.code=lower(trim(p_code)) and t0.is_open and t0.published_at is not null
 and (t0.due_at is null or t0.due_at>now()) and not c.archived;
 if not found then raise exception 'Assignment not found, closed or overdue'; end if;
 select name into cn from public.em_classes where id=t.class_id;
 select jsonb_agg(jsonb_build_object('prompt',value->'prompt','options',value->'options') order by ord)
 into qs from jsonb_array_elements(t.questions) with ordinality as x(value,ord);
 return jsonb_build_object('id',t.id,'code',t.code,'title',t.title,'class_name',cn,
 'instructions',t.instructions,'due_at',t.due_at,'questions',qs);
end $$;
create function public.em_submit_task(p_code text,p_attempt_id uuid,p_student_name text,
 p_answers jsonb,p_writing text default '') returns jsonb language plpgsql
security definer set search_path=pg_catalog,public as $$
declare t public.em_tasks%rowtype; old_result jsonb; details jsonb:='[]'; q jsonb;
 a jsonb; choice integer; expected integer; points integer:=0; total integer;
 i integer; final_result jsonb; cn text;
begin
 if p_code is null or length(trim(p_code))<>32 or p_attempt_id is null then raise exception 'Invalid attempt'; end if;
 if p_student_name is null or length(trim(p_student_name)) not between 1 and 100
 then raise exception 'Enter your name'; end if;
 if length(coalesce(p_writing,''))>5000 then raise exception 'Writing is too long'; end if;
 select * into t from public.em_tasks where code=lower(trim(p_code)) and published_at is not null for update;
 if not found then raise exception 'Assignment not found'; end if;
 select result into old_result from public.em_results where task_id=t.id and attempt_id=p_attempt_id;
 if found then return old_result; end if;
 select name into cn from public.em_classes where id=t.class_id and not archived;
 if not found or not t.is_open or (t.due_at is not null and t.due_at<=now())
 then raise exception 'Assignment closed or overdue'; end if;
 if jsonb_typeof(p_answers) is distinct from 'array' then raise exception 'Invalid answers'; end if;
 total:=jsonb_array_length(t.questions);
 if jsonb_array_length(p_answers)<>total then raise exception 'Answer every question'; end if;
 for i in 0..total-1 loop
 a:=p_answers->i;
 if jsonb_typeof(a) is distinct from 'number' or (a#>>'{}') not in ('0','1','2')
 then raise exception 'Answer every question'; end if;
 q:=t.questions->i; choice:=(a#>>'{}')::integer; expected:=(q->>'answer')::integer;
 if choice=expected then points:=points+1; end if;
 details:=details||jsonb_build_array(jsonb_build_object('prompt',q->>'prompt',
 'unit',coalesce(q->>'unit','custom'),'chosen',q->'options'->>choice,
 'expected',q->'options'->>expected,'correct',choice=expected,'explanation',q->>'explanation'));
 end loop;
 final_result:=jsonb_build_object('student_name',trim(p_student_name),'class_name',cn,
 'title',t.title,'score',points,'total',total,'details',details,'writing',coalesce(p_writing,''));
 insert into public.em_results(task_id,attempt_id,student_name,class_name,answers,score,total,result,writing)
 values(t.id,p_attempt_id,trim(p_student_name),cn,p_answers,points,total,final_result,coalesce(p_writing,''));
 return final_result;
end $$;
create function public.em_queue_report() returns trigger language plpgsql
security definer set search_path=pg_catalog,public as $$
declare owner_id uuid; addr text;
begin
 select t.teacher_id,p.report_email into owner_id,addr from public.em_tasks t
 join public.em_teachers p on p.user_id=t.teacher_id where t.id=new.task_id;
 if coalesce(trim(addr),'')<>'' then
 insert into public.em_mail_queue(result_id,teacher_id,recipient) values(new.id,owner_id,addr);
 end if; return new;
end $$;
create trigger em_report_queue after insert on public.em_results
 for each row execute function public.em_queue_report();
revoke all on function public.em_get_class(text),public.em_get_task(text),
 public.em_submit_task(text,uuid,text,jsonb,text) from public;
grant execute on function public.em_get_class(text),public.em_get_task(text),
 public.em_submit_task(text,uuid,text,jsonb,text) to anon,authenticated;
commit;

-- An attempt UUID acts as the learner's receipt. It is never listed publicly.
create function public.em_get_result(p_code text,p_attempt_id uuid) returns jsonb
language plpgsql security definer set search_path=pg_catalog,public as $$
declare r public.em_results%rowtype;
begin
 if p_code is null or length(trim(p_code))<>32 or p_attempt_id is null then raise exception 'Invalid receipt'; end if;
 select r0.* into r from public.em_results r0 join public.em_tasks t on t.id=r0.task_id
 where t.code=lower(trim(p_code)) and r0.attempt_id=p_attempt_id;
 if not found then raise exception 'Result not found'; end if;
 return jsonb_build_object('teacher_feedback',r.teacher_feedback,'reviewed',r.reviewed);
end $$;
revoke all on function public.em_get_result(text,uuid) from public;
grant execute on function public.em_get_result(text,uuid) to anon,authenticated;

-- Optional mail worker. No browser role can claim or modify mail jobs.
alter table public.em_mail_queue add column lease_until timestamptz;
create function public.em_claim_mail(p_limit integer default 5) returns setof public.em_mail_queue
language sql security definer set search_path=pg_catalog,public as $$
 update public.em_mail_queue q set lease_until=now()+interval '5 minutes',attempts=attempts+1
 where q.id in(select id from public.em_mail_queue where status='pending'
 and (lease_until is null or lease_until<now()) order by created_at
 for update skip locked limit greatest(1,least(coalesce(p_limit,5),10))) returning q.*;
$$;
revoke all on function public.em_claim_mail(integer) from public,anon,authenticated;
grant execute on function public.em_claim_mail(integer) to service_role;
grant select,update on public.em_mail_queue to service_role;
grant select on public.em_results to service_role;

````

## tests/browser-fixture.js

````javascript
/* Test-only adapter. Never ship this file in dist. */
(function(){
const KEY='errormap-qa-fixture';
const empty={profile:{user_id:'teacher-qa',display_name:'QA Teacher',report_email:''},classes:[{id:'class-qa',teacher_id:'teacher-qa',name:'7A · QA',code:'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',archived:false,created_at:'2026-10-20T00:00:00Z'}],tasks:[],results:[],mail:[]};
let db;try{db=JSON.parse(localStorage.getItem(KEY))||empty}catch{db=empty}
const save=()=>localStorage.setItem(KEY,JSON.stringify(db));const copy=x=>JSON.parse(JSON.stringify(x));
const tables={em_teachers:'profile',em_classes:'classes',em_tasks:'tasks',em_results:'results',em_mail_queue:'mail'};
const uid=()=>window.EMRandomId();
window.EMCloud={session:()=>({uid:'teacher-qa',email:'qa@example.invalid'}),logout:async()=>{},config:()=>({}),login:async()=>db.profile,
api:async(path,opts={})=>{const [table,search='']=path.split('?');const key=tables[table];if(!key)throw Error('QA table missing');if(!opts.method)return copy(key==='profile'?[db.profile]:db[key]);const p=JSON.parse(opts.body||'{}');if(opts.method==='POST'){const row={...p,id:uid(),code:uid().replaceAll('-',''),created_at:new Date().toISOString(),published_at:null,is_open:false,archived:false};db[key].unshift(row);save();return null}const query=new URLSearchParams(search);const id=query.get('id')?.replace('eq.','');const row=key==='profile'?db.profile:db[key].find(r=>r.id===id);Object.assign(row,p);save();return null},
rpc:async(name,p)=>{if(name==='em_get_class'){const c=db.classes.find(c=>c.code===p.p_code&&!c.archived);if(!c)throw Error('Class not found');return {name:c.name,tasks:db.tasks.filter(t=>t.class_id===c.id&&t.is_open)}}const task=db.tasks.find(t=>t.code===p.p_code);if(!task)throw Error('Assignment not found');if(name==='em_get_result'){const r=db.results.find(r=>r.task_id===task.id&&r.attempt_id===p.p_attempt_id);return {teacher_feedback:r.teacher_feedback,reviewed:r.reviewed}}if(name==='em_get_task'){if(!task.is_open)throw Error('Assignment closed or overdue');return {id:task.id,code:task.code,title:task.title,class_name:db.classes.find(c=>c.id===task.class_id).name,instructions:task.instructions,questions:task.questions.map(q=>({prompt:q.prompt,options:q.options}))}}if(name==='em_submit_task'){const old=db.results.find(r=>r.task_id===task.id&&r.attempt_id===p.p_attempt_id);if(old)return old.result;const details=task.questions.map((q,i)=>({prompt:q.prompt,unit:q.unit,chosen:q.options[p.p_answers[i]],expected:q.options[q.answer],correct:p.p_answers[i]===q.answer,explanation:q.explanation}));const result={title:task.title,student_name:p.p_student_name,class_name:db.classes.find(c=>c.id===task.class_id).name,score:details.filter(q=>q.correct).length,total:details.length,details,writing:p.p_writing};db.results.unshift({id:uid(),task_id:task.id,attempt_id:p.p_attempt_id,student_name:result.student_name,class_name:result.class_name,score:result.score,total:result.total,result,writing:p.p_writing,teacher_feedback:'',reviewed:false,submitted_at:new Date().toISOString()});save();return copy(result)}throw Error('QA RPC missing')}
};
})();

````

## tests/check.cjs

````javascript
const fs=require('fs'),vm=require('vm'),assert=require('assert'),path=require('path');
const root=path.resolve(__dirname,'../dist'),source=fs.readFileSync(path.join(root,'assets/app.js'),'utf8'),loader=fs.readFileSync(path.join(root,'assets/question-bank.js'),'utf8'),content=JSON.parse(fs.readFileSync(path.join(root,'assets/question-bank.json'),'utf8'));
const {questions:bank,units}=content;
assert.equal(units.length,24);assert.equal(bank.length,240);assert.equal(new Set(bank.map(q=>q.id)).size,240);assert.equal(new Set(bank.map(q=>q.prompt+'|'+q.options.join('|'))).size,240);
for(const u of units){const qs=bank.filter(q=>q.unit===u.id);assert.equal(qs.length,10,u.id);assert.equal(qs.filter(q=>q.use==='practice').length,4);for(const pair of [0,1,2]){const a=qs.find(q=>q.form==='A'&&q.pair===pair),b=qs.find(q=>q.form==='B'&&q.pair===pair);assert(a&&b);assert.equal(a.level,b.level);assert.notEqual(a.id,b.id)}}
for(const q of bank){assert.equal(q.options.length,3);assert.equal(new Set(q.options).size,3,q.id);assert(q.options[q.answer]);assert(q.explanation.length>15,q.id);assert(!/[\u0400-\u052f]/.test(JSON.stringify(q)),q.id)}
assert.deepEqual(JSON.parse(loader.replace('window.ERRORMAP_CONTENT = ','').trim().replace(/;$/,'')),content);
let memory={},ticks=1760000000000;
class Clock extends Date{constructor(...args){super(...(args.length?args:[++ticks]))}static now(){return ++ticks}}
function env(page='home',search=''){
 const els={};const get=s=>els[s]??={value:'',textContent:'',innerHTML:'',classList:{add(){},remove(){},toggle(){}},showModal(){},focus(){},setSelectionRange(){},setAttribute(){},removeAttribute(){}};
 const ctx={document:{body:{dataset:{page}},querySelector:get,querySelectorAll:()=>[]},window:{addEventListener(){},scrollTo(){}},localStorage:{getItem:k=>memory[k]||null,setItem:(k,v)=>{memory[k]=v}},location:{href:'',search},setTimeout(){},clearTimeout(){},console,I18N:{t:v=>v,apply(){},set(){},language:'en'},confirm:()=>true,URL,URLSearchParams,Blob,Date:Clock,Math};
 vm.createContext(ctx);vm.runInContext(loader,ctx);vm.runInContext(source,ctx);return {ctx,get,run:s=>vm.runInContext(s,ctx)};
}
for(const page of ['home','diagnostic','map','route','studio','bank','teacher','about']){const e=env(page);assert(e.get('#app').innerHTML.length>100);assert(!/[\u0400-\u052f]/.test(e.get('#app').innerHTML),page);console.log('English page:',page,'OK')}
// Baseline is balanced, persistent and scored only after review and submission.
let e=env('diagnostic');e.run('window.startBaseline()');assert.equal(e.run('learner.assessment.items.length'),24);assert.equal(new Set(e.run('learner.assessment.items.map(i=>question(i.id).unit)')).size,24);assert.equal(e.run('learner.assessment.items.filter(i=>question(i.id).level===1).length'),8);
e.run('window.assessmentNext()');assert.equal(e.run('learner.assessment.index'),0,'no empty answer');e.run('window.chooseAnswer(1)');e=env('diagnostic');assert.equal(e.run('learner.assessment.items[0].choice'),1,'answer resumes after reload');
const failedUnit=e.run('question(learner.assessment.items[0].id).unit');
e.run("for(let n=0;n<24;n++){const a=learner.assessment,i=a.items[n],correct=i.order.indexOf(question(i.id).answer);window.chooseAnswer(n===0?(correct+1)%3:correct);window.assessmentNext()}");assert.equal(e.run('learner.cycles.length'),0,'review before submit');assert.equal(e.run('learner.assessment.index'),24);assert(e.run('validState(state)'));e=env('diagnostic');assert(e.get('#app').innerHTML.includes('Review your answers'));e.run('window.submitAssessment()');assert.equal(e.ctx.location.href,'error-map.html');assert.equal(e.run('cycle().baseline.correct'),23);assert.equal(e.run('targets().length'),1);assert.equal(e.run('targets()[0]'),failedUnit);assert.equal(e.run('status(targets()[0]).key'),'assigned');assert(e.run('validState(state)'));
// Recheck cannot start before targeted rule evidence exists.
e=env('diagnostic');e.run('window.startRecheck()');assert.equal(e.run('learner.assessment'),null);
// Hints cannot be converted into independent points. Duplicate clicks do not score twice.
e=env('route');e.run("window.startPractice(targets()[0]);window.beginPractice()");e.run("for(let n=0;n<4;n++){window.showHint();const p=learner.practice,i=p.items[p.index];window.practiceChoose(i.order.indexOf(question(i.id).answer));window.practiceCheck();window.practiceCheck();window.practiceNext()}");assert.equal(e.run('learner.practice.stage'),'reflection');e.run("window.updateReflection('explanation','I used the ending for one person.');window.updateReflection('example','My sister reads every day.');window.finishPractice()");assert.equal(e.run('learner.practiceHistory[0].independent'),0);assert.equal(e.run('learner.practiceHistory[0].assisted'),4);assert.equal(e.run('status(targets()[0]).key'),'review');e.run('window.startCheckpoint(targets()[0])');assert.equal(e.run('learner.assessment'),null);
// A wrong first answer stays wrong after correction; practice resumes mid-lesson.
e.run('window.startPractice(targets()[0]);window.beginPractice()');e.run("{const i=learner.practice.items[0],pos=i.order.indexOf(question(i.id).answer);window.practiceChoose((pos+1)%3);window.practiceCheck();window.practiceNext()}");assert.equal(e.run('learner.practice.index'),0,'cannot skip correction');e=env('route');assert.equal(e.run('learner.practice.items[0].checked'),true);e.run("{const i=learner.practice.items[0];window.practiceChoose(i.order.indexOf(question(i.id).answer));window.checkCorrection();window.practiceNext()}");e.run("for(let n=1;n<4;n++){const i=learner.practice.items[n];window.practiceChoose(i.order.indexOf(question(i.id).answer));window.practiceCheck();window.practiceNext()}");e.run("window.updateReflection('explanation','I use this ending with a singular subject.');window.updateReflection('example','My brother plays chess after school.');window.finishPractice();window.finishPractice()");assert.equal(e.run('learner.practiceHistory.length'),2);assert.equal(e.run('learner.practiceHistory.at(-1).independent'),3);assert.equal(e.run('status(targets()[0]).key'),'ready');assert(e.run('validState(state)'));
// A failed rule check sends the learner back to practice, with visible feedback.
e.run('window.startCheckpoint(targets()[0])');e.run("for(let n=0;n<2;n++){const i=learner.assessment.items[n],pos=i.order.indexOf(question(i.id).answer);window.chooseAnswer(n===0?(pos+1)%3:pos);window.assessmentNext()}window.submitAssessment()");assert.equal(e.run('status(targets()[0]).key'),'review');e=env('route');assert(e.get('#app').innerHTML.includes('Last rule check: 1 / 2'));
e.run("window.startPractice(targets()[0]);window.beginPractice();for(let n=0;n<4;n++){const i=learner.practice.items[n];window.practiceChoose(i.order.indexOf(question(i.id).answer));window.practiceCheck();window.practiceNext()}window.updateReflection('explanation','I add an ending for a singular subject.');window.updateReflection('example','My cousin watches a film every Friday.');window.finishPractice()");assert.equal(e.run('status(targets()[0]).key'),'ready');
// Checkpoints are new examples, exclude the final reserved pair, and require 2/2.
e.run('window.startCheckpoint(targets()[0])');let cpIds=e.run('learner.assessment.items.map(i=>i.id)');const reserved=e.run('cycle().baseline.answers[0].pair');assert(e.run('learner.assessment.items.every(i=>question(i.id).pair!==cycle().baseline.answers[0].pair)'));e.run("for(let n=0;n<2;n++){const i=learner.assessment.items[n];window.chooseAnswer(i.order.indexOf(question(i.id).answer));window.assessmentNext()}window.submitAssessment()");assert.equal(e.run('learner.checkpoints.at(-1).repeated'),2,'repeated checkpoint examples are disclosed');assert.equal(e.run('status(targets()[0]).key'),'verified');assert(e.run('readiness()'));assert(e.run('validState(state)'));
// Teacher assignment changes the plan, never the baseline score.
e=env('teacher');const optionalRule=e.run('UNITS.find(u=>!targets().includes(u.id)).id');e.get('#assignUnit').value=optionalRule;e.run('window.assignRule()');assert.equal(e.run('targets().length'),2);assert.equal(e.run('cycle().baseline.correct'),23);assert(!e.run('readiness()'));e.run('window.removeAssignment('+JSON.stringify(optionalRule)+')');assert.equal(e.run('targets().length'),1);assert(e.run('readiness()'));
// Recheck matches each baseline rule/difficulty and never reuses checkpoint items.
e=env('diagnostic');e.run('window.startRecheck()');let finalIds=e.run('learner.assessment.items.map(i=>i.id)');assert(finalIds.every(id=>!cpIds.includes(id)));assert(e.run('learner.assessment.items.every(i=>{const q=question(i.id),b=cycle().baseline.answers.find(a=>a.unit===q.unit);return q.form===\'B\'&&q.pair===b.pair&&q.level===b.level})'));e.run("for(let n=0;n<24;n++){const i=learner.assessment.items[n];window.chooseAnswer(i.order.indexOf(question(i.id).answer));window.assessmentNext()}window.submitAssessment()");assert.equal(e.run('cycle().recheck.correct'),24);assert(e.run('validState(state)'));e=env('map');assert(e.get('#app').innerHTML.includes('Your progress'));
// New cycles preserve history and select previously unused pairs.
const oldIds=e.run('cycle().baseline.answers.map(a=>a.id)');e=env('diagnostic');e.run('window.newCycle();window.startBaseline()');assert.equal(e.run('learner.cycles.length'),1);assert(e.run('learner.assessment.items.map(i=>i.id)').every(id=>!oldIds.includes(id)));
// Switching learners preserves each unfinished draft and never mixes results.
e.get('#codeInput').value='learner-02';e.run("document.querySelector('#saveCode').onclick({preventDefault(){throw Error('unexpected')}})");assert.equal(e.run('state.active'),'LEARNER-02');assert.equal(e.run('learner.cycles.length'),0);assert.equal(e.run('learner.assessment'),null);e.get('#codeInput').value='LEARNER-01';e.run("document.querySelector('#saveCode').onclick({preventDefault(){throw Error('unexpected')}})");assert(e.run('learner.assessment!==null'));assert.equal(e.run('learner.cycles.length'),1);
// Known false positive: questions and past-time statements must not suggest -s.
e=env('studio');assert.equal(e.run("detect('Does she go to school?').length"),0);assert.equal(e.run("detect('Can he play chess?').length"),0);assert.equal(e.run("detect('She go to school yesterday.').length"),0);assert.equal(e.run("detect('She go to school every day. I make my homework in Monday. i like english becouse it is interesting.').length"),6);assert.equal(e.run("E('<img src=x onerror=1>')"),'&lt;img src=x onerror=1&gt;');assert.equal(e.run("csvCell('=1+1')"),'"\'=1+1"');
// Malformed backups do not enter the data model.
assert(e.run('validState(state)'));assert(!e.run("validState({...state,active:'__proto__'})"));assert(!e.run("validState({...state,version:2})"));assert(!e.run("(()=>{let s=JSON.parse(JSON.stringify(state));s.learners[s.active].assessment.items[0].order=[0,0,1];return validState(s)})()"));
// Imported record IDs cannot inject code into button handlers.
assert(!e.run("(()=>{let s=JSON.parse(JSON.stringify(state));s.learners[s.active].practiceHistory[0].id=\"');alert(1);//\";return validState(s)})()"));
// Failed local storage does not navigate away from the unfinished assessment.
e=env('diagnostic');e.ctx.localStorage.setItem=()=>{throw Error('quota')};e.run('window.saveAssessmentExit()');assert.equal(e.ctx.location.href,'');assert.equal(e.get('#storageWarning').hidden,false);
for(const file of fs.readdirSync(root).filter(f=>f.endsWith('.html'))){const html=fs.readFileSync(path.join(root,file),'utf8');assert(/lang="(?:en|kk|ru)"/.test(html));if(file!=='SETUP.html')assert(html.includes(file==='index.html'?'id="language"':'id="languageSelect"'),file);for(const m of html.matchAll(/(?:href|src)="([^"]+)"/g)){const link=m[1];if(!link.startsWith('http')&&!link.startsWith('#'))assert(fs.existsSync(path.join(root,link.split('?')[0])),link)}}
console.log('PASS: 24-rule bank, 240 English questions, 3 matched pairs per rule, review-before-submit, reload recovery, score integrity, hint/correction accounting, targeted plans, reserved recheck items, cycle history, profile isolation, writing guards, HTML escaping, CSV safety, backup validation and local links.');

// Locale selection persists without changing the assessment content.
const localeContext={window:{},localStorage:{getItem:k=>memory[k]||null,setItem:(k,v)=>memory[k]=v},document:{documentElement:{lang:'en'}}};vm.createContext(localeContext);vm.runInContext(fs.readFileSync(path.join(root,'assets/i18n.js'),'utf8'),localeContext);const loc=localeContext.window.I18N;loc.set('kk');assert.equal(loc.t('Learning plan'),'Оқу бағыты');assert.equal(loc.t('Next →'),'Келесі →');loc.set('ru');assert.equal(loc.t('Learning plan'),'Учебный маршрут');assert.equal(loc.t('Practice 2 of 4'),'Практика 2 / 4');assert.equal(memory['errormap-language'],'ru');loc.set('en');assert.equal(loc.t('Learning plan'),'Learning plan');const translations=JSON.parse(fs.readFileSync(path.join(root,'assets/translations.json'),'utf8'));for(const u of units){assert(translations[u.title].kk&&translations[u.title].ru);assert(translations[u.rule].kk&&translations[u.rule].ru)}for(const q of bank)assert(translations[q.explanation].kk&&translations[q.explanation].ru);console.log('PASS: three languages, saved preference, dynamic labels and translated rule/explanation coverage.');

loc.set('kk');assert.equal(loc.t('Сохранено на этом устройстве'),'Осы құрылғыда сақталды');loc.set('en');assert.equal(loc.t('Осы құрылғыда сақталды'),'Saved on this device');console.log('PASS: locale round-trip also refreshes already-localised save messages.');

````

## tests/cloud_test.cjs

````javascript
const fs=require('fs'),vm=require('vm'),assert=require('assert');
const source=fs.readFileSync(require('path').join(__dirname,'../dist/assets/cloud-api.js'),'utf8');
function env(){const memory={},calls=[];let allowed=true;let now=1000;let refreshes=0;
 const response=(data,status=200)=>({ok:status<300,status,text:async()=>JSON.stringify(data)});
 const ctx={window:{ERRORMAP_CLOUD:{url:'https://example.supabase.co',publishableKey:'sb_publishable_qa'}},crypto:require('crypto').webcrypto,Uint8Array,Date:{now:()=>now},sessionStorage:{getItem:k=>memory[k]??null,setItem:(k,v)=>memory[k]=v,removeItem:k=>delete memory[k]},fetch:async(url,options)=>{calls.push({url,options});if(url.includes('grant_type=refresh_token')){refreshes++;return response({access_token:'qa-renewed',refresh_token:'qa-refresh',expires_in:3600,user:{id:'qa-user',email:'qa@example.invalid'}})}if(url.includes('grant_type=password'))return response({access_token:'qa-access',refresh_token:'qa-refresh',expires_in:3600,user:{id:'qa-user',email:'qa@example.invalid'}});if(url.endsWith('/auth/v1/logout'))return response(null);if(url.includes('em_teachers'))return response(allowed?[{user_id:'qa-user'}]:[]);return response({ok:true})}};
 vm.createContext(ctx);vm.runInContext(source,ctx);return {api:ctx.window.EMCloud,calls,ctx,deny:()=>allowed=false,expire:()=>now+=3600001,refreshes:()=>refreshes};}
(async()=>{let e=env();await e.api.login('qa@example.invalid','synthetic-test-value');assert(e.api.session());await e.api.rpc('em_get_task',{p_code:'a'.repeat(32)});assert(!e.calls.at(-1).options.headers.Authorization,'public RPC must not send a teacher session');e.expire();await Promise.all([e.api.api('em_tasks'),e.api.api('em_classes')]);assert.equal(e.refreshes(),1,'concurrent requests share refresh');await e.api.logout();assert.equal(e.api.session(),null);e=env();e.deny();await assert.rejects(e.api.login('qa@example.invalid','synthetic-test-value'),/teacherOnly/);assert.equal(e.api.session(),null,'non-allowlisted user cannot retain teacher session');e=env();e.ctx.window.ERRORMAP_CLOUD.url='';assert.throws(()=>e.api.config(),/cloudMissing/);console.log('PASS: teacher allowlist gate, session removal, single-flight refresh, explicit cloud config and anonymous student RPC separation (mock transport).')})().catch(e=>{console.error(e);process.exitCode=1});

````

## tests/portal_test.cjs

````javascript
'use strict';
const fs=require('fs'),vm=require('vm'),assert=require('assert'),path=require('path');
const root=path.resolve(__dirname,'..'),dist=path.join(root,'dist');
function node(){return {value:'en',hidden:true,textContent:'',innerHTML:'',disabled:false,dataset:{},classList:{toggle(){}},addEventListener(){},querySelectorAll(){return []},showModal(){},close(){}}}
const els=new Map();const el=s=>{if(!els.has(s))els.set(s,node());return els.get(s)};
const memory={};let redirected='';
const ctx={console,URL,URLSearchParams,Blob,structuredClone,Date,Math,confirm:()=>true,setTimeout(){},clearTimeout(){},crypto:require('crypto').webcrypto,
localStorage:{getItem:k=>memory[k]??null,setItem:(k,v)=>memory[k]=v,removeItem:k=>delete memory[k]},sessionStorage:{getItem(){return null},setItem(){},removeItem(){}},
location:{href:'https://example.invalid/repo/student.html',search:'',replace(v){redirected=v}},
document:{documentElement:{},body:{dataset:{portal:'qa',title:'Results'}},querySelector:el,querySelectorAll:()=>[],addEventListener(){}},
window:{addEventListener(){},I18N:{set(){},t:k=>k},EMCloud:{session:()=>null},ERRORMAP_CONTENT:JSON.parse(fs.readFileSync(dist+'/assets/question-bank.json'))}}
ctx.window.EMLocale={language:'en',t:k=>k,set(){}};vm.createContext(ctx);vm.runInContext(fs.readFileSync(dist+'/assets/portal.js','utf8'),ctx);
const helpers=ctx.window.EMPortalTest;
const good={prompt:'She ___ every day.',options:['reads','read','reading'],answer:0,explanation:'Add -s with she.',unit:'third-person'};
assert(helpers.validateQuestions([good]));
for(const bad of [{...good,answer:3},{...good,options:['read','READ','read ']},{...good,prompt:''},{...good,explanation:''},{...good,options:['a','b']},null])assert.throws(()=>helpers.validateQuestions([bad]));
assert.throws(()=>helpers.validateQuestions([]));assert.throws(()=>helpers.validateQuestions(Array(51).fill(good)));
assert(helpers.escapeHTML('<script>').includes('&lt;'));assert.equal(helpers.csvCell('=1+1'),'"\'=1+1"');
const evidence=helpers.evidence([{submitted_at:'2026-01-01',class_name:'7A',student_name:'QA',result:{details:[{unit:'u',correct:false}]}},{submitted_at:'2026-01-02',class_name:'7A',student_name:'QA',result:{details:[{unit:'u',correct:true},{unit:'u',correct:false}]}},{submitted_at:'2026-01-02',class_name:'7B',student_name:'QA',result:{details:[{unit:'u',correct:true}]}}]);
assert.equal(evidence.u.total,3);assert.equal(evidence.u.correct,2);
const sql=fs.readFileSync(root+'/supabase/schema.sql','utf8');
for(const table of ['em_teachers','em_classes','em_tasks','em_results','em_mail_queue']){assert(sql.includes(`alter table public.${table} enable row level security`));}
assert(sql.includes('unique(task_id,attempt_id)'));assert(sql.includes('for update'));assert(sql.includes('Published content is fixed'));assert(sql.includes("'prompt',value->'prompt','options',value->'options'"));
for(const p of ['teacher-login','teacher-dashboard','classes','assignments','task-editor','class-results','teacher-settings','student','student-task','student-results']){const h=fs.readFileSync(dist+'/'+p+'.html','utf8');assert(h.includes('data-portal="'+p+'"'));assert(h.includes('portal.js'));assert(!h.includes('fixture.js'))}
assert(!fs.readFileSync(dist+'/assets/cloud-config.js','utf8').includes('service_role'));
console.log('PASS: 10 portal entry pages, question validation, escaped output, CSV safety, latest-rule aggregation and SQL security contract checks. SQL contract checks are not live PostgreSQL tests.');

````
