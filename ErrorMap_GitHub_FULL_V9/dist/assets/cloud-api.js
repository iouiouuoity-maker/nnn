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
