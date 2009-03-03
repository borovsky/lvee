var timeout         = 500;
var closetimer		= 0;
var ddmenuitem      = 0;

function jsddm_open(ev) {
  jsddm_canceltimer();
	jsddm_close();
  l = ev.element().up().select('ul');
  ddmenuitem = l[0];
  if(ddmenuitem)
    ddmenuitem.style.visibility="visible";
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
    l = $$('#sub-menu > li > a');
    l.each(function(i) {
        Event.observe(i, 'mouseover', jsddm_open);
        Event.observe(i, 'mouseout',  jsddm_timer);
      })
  });

document.onclick = jsddm_close;
