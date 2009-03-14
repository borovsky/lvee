function ie6SetCookie(){
var today = new Date();
var expire = new Date();
expire.setTime(today.getTime() + 2592000000);
document.cookie = "ie6suxxblocked=crap;expires="+expire.toGMTString();}
var ie6working=1;
if (document.cookie.length>0){
c_start=document.cookie.indexOf("ie6suxxblocked=");
if (c_start!=-1){
c_start=c_start + 15;
c_end=document.cookie.indexOf(";",c_start);
if (c_end==-1) c_end=document.cookie.length;
if (unescape(document.cookie.substring(c_start,c_end)) =='crap')
ie6working=0;}}
function ie6move(dx,top,disp){
for (var i=0; i<document.all.length; i++){
if (document.all[i].id == 'i6sux') continue;
if (document.all[i].style.position == 'absolute'){
t = parseInt(document.all[i].style.top);
if (!isNaN(t))
document.all[i].style.top = (t + dx) + 'px';}}
if (parseInt(document.body.runtimeStyle.paddingTop) == 0)
document.body.style.paddingTop = top+"px";
else
document.body.style.marginTop = top+"px";
document.getElementById('i6sux').style.display = disp;}
function ie6(){
ie6move(25,25,'block');}
function ie6suxxblock(){
ie6SetCookie();
ie6move(-25,0,'none');}
if (ie6working){
window.attachEvent("onload", ie6);
document.write('<div id="i6sux" style="padding: 0; margin: 0;\
text-align: center; font:12px arial bold; color:black;\
border-bottom: 1px solid #aca899; display:none;\
background-color:#ffffe1; z-index:100; position:absolute;\
left:0px; top: 0;\
width: expression(((document.documentElement.clientWidth==0)?document.body.clientWidth:document.documentElement.clientWidth)+\'px\');\
height:25px;">\
<div style="padding: 4px;">&#1063;&#1077;&#1088;&#1077;&#1079; &#1074;&#1072;&#1096; &#1091;&#1089;&#1090;&#1072;&#1088;&#1077;&#1074;&#1096;&#1080;&#1081; &#1080; &#1085;&#1077;&#1073;&#1077;&#1079;&#1086;&#1087;&#1072;&#1089;&#1085;&#1099;&#1081; &#1073;&#1088;&#1072;&#1091;&#1079;&#1077;&#1088; &#1082; &#1074;&#1072;&#1084; &#1084;&#1086;&#1075;&#1091;&#1090; &#1087;&#1086;&#1087;&#1072;&#1089;&#1090;&#1100; &#1074;&#1080;&#1088;&#1091;&#1089;&#1099; &#1089; &#1089;&#1072;&#1081;&#1090;&#1086;&#1074;.\
<a style="color:red; font-weight: bold; font: inherit;" href=http://upgradebrowser.org/x target=_blank>&#1054;&#1073;&#1085;&#1086;&#1074;&#1080;&#1090;&#1077; &#1077;&#1075;&#1086;!</a>\
<a style="position:absolute; top:-22px; right:10px;color:black;text-decoration:none;font:12px Tahoma bold;"\
href="javascript:ie6suxxblock()">x</a></div></div>');}
