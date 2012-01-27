<form action="index.php?route=user/user/updatepassword" method="post" enctype="multipart/form-data" id="login">
  <div class="content">
    NEW : 
    <input type="password" name="password" value="" size=10 /> press Enter
    <!--a id='ajaxSubmit' class="button"><span>Change Password</span></a-->
  </div>
</form>

<script type="text/javascript">
$.fn.ajaxSubmit = function($form){
  //todo. weird issue. submit not work under button click
  //alert($form.attr('action'));  alert($form.serialize());
  $.post($form.attr('action'),$form.serialize(),function(data){
    //$.fancybox.close();
  });
}

$('#login input').keydown(function(e){
  if(e.keyCode == 13){
    $form = $('#login');
    $.fn.ajaxSubmit($form);
  }
});

/**
$('#ajaxSubmit').bind('click',function(e){
  $form = $('#login');
  $.fn.ajaxSubmit($form);
});
**/
</script>
