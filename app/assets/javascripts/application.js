//= require jquery
//= require jquery_ujs
//= require jquery.iframe-post-form
//= require user_select
//= require bootstrap
//= require_self
//= require markitup
//= require jquery.markitup

!function( $ ){
  "use strict"

  function processPopup(data) {
    if(data.status == 200) {
      var t = data.getResponseHeader("Content-Type");
      if(t == "text/javascript") {
        updateFocus();
      } else {
        $("#modal").modal("hide")
        $("#modal").replaceWith('')
        $("body").append(data.responseText)
        $("#modal").modal('show');
      }
    } else {
      if(data.status != 0) {
        alert("Error occured");
      }
    }
  }

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

    $("form[data-remote-upload]").each(function(){
      var form = $(this);
      var update = $("#" + form.data("update"));
      form.iframePostForm({
        complete: function(resp){
          update.html(resp);
          form.trigger("ajax:complete");
        }
      });
      return false;
    });

    $(document.body).on('ajax:success', "a[data-replace]", function(event, data, status){
       var target = $(this).data('replace'); //what id for replace
       $('#' + target).html(data); //replacing elements
    });

    $(document).on('click', 'a[data-modal-popup]', function(e){
      e.preventDefault();
      var href = $(this).attr('href');
      if(href.indexOf("?") >= 0){
        href += "&";
      } else {
        href += "?";
      }
      href += "_ts=" + new Date().getTime();
      $.get(href).complete(processPopup);
      return false;
    });
  });
}(window.jQuery);
