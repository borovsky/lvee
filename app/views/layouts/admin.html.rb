<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
  <%= render(:partial => 'layouts/partials/head') %>
  <body>
    <div class="all">
      <%= render(:partial => 'layouts/partials/top') %>

      <div class="content">
        <div class="common">
          <%= yield %>

          <div class="clear"></div>
        </div> <!-- common layout -->
      </div><!-- content -->

      <%= render :partial => "/layouts/partials/footer"%>
    </div> <!-- all -->
  </body>
</html>
