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
