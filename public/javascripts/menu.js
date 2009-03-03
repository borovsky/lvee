var timeout         = 500;
var closetimer		= 0;
var ddmenuitem      = 0;

function jsddm_open(ev) {
  var l = ev.element().up("#sub-menu > li").select("ul");

  var n = l[0];
  jsddm_canceltimer();
  jsddm_close();
  ddmenuitem = n;

  if(n)  n.style.visibility="visible";
}

function jsddm_close() {
  if(ddmenuitem) {
    ddmenuitem.style.visibility="hidden";
    ddmenuitem = null;
  }
}

function jsddm_timer() {
  closetimer = window.setTimeout(jsddm_close, timeout);
}

function jsddm_canceltimer() {
  if(closetimer) {
    window.clearTimeout(closetimer);
		closetimer = null;
  }
}

Event.observe(window, "load", function(){
    var l = $$('#sub-menu a');
    l.each(function(i) {
        Event.observe(i, 'mouseover', jsddm_open);
        Event.observe(i, 'mouseout',  jsddm_timer);
      })
  });

document.onclick = jsddm_close;
