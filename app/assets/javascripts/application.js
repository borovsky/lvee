//= require jquery
//= require jquery_ujs
//= require_self

(function() {
    var timeout         = 500;
    var closetimer		= 0;
    var ddmenuitem      = 0;

    function jsddm_open() {
        jsddm_canceltimer();
        jsddm_close();
        ddmenuitem = $(this).find('ul').eq(0).css('visibility', 'visible');
    }

    function jsddm_close() {
        if(ddmenuitem) ddmenuitem.css('visibility', 'hidden');
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

    $(document).ready(function() {
        $('#jsddm > li').bind('mouseover', jsddm_open);
        $('#jsddm > li').bind('mouseout',  jsddm_timer);
    });

    document.onclick = jsddm_close;
})();
$(function(){
   $("input[data-remote-preview]").click(function(){
       var btn = $(this);
       var url = btn.data("url");
       var dataType = btn.data("type") || ($.ajaxSetting && $.ajaxSettings.dataType);
       var method = btn.data("method");
       var update = $("#" + btn.data("update"));
       var data = btn.parents("form").serializeArray();
       $.ajax({
            url: url,
            dataType: dataType,
            data: data,
            type: method || "GET",
            success: function(data, status, xhr) {
                update.html(data);
            }
        });
        return false;
   });
});