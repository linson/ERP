<?php echo $header; ?>
<div class="box" style="width: 325px; min-height: 300px; margin-top: 40px; margin-left: auto; margin-right: auto;">
  <div class="left"></div>
  <div class="right"></div>
  <div class="heading">
    <h1 style="background-image: url('view/image/lockscreen.png');"><?php echo $text_login; ?></h1>
  </div>
  <div class="content" style="min-height: 150px;">
    <?php if ($error_warning) { ?>
    <div class="warning" style="padding: 3px;"><?php echo $error_warning; ?></div>
    <?php } ?>
    <form action="<?php echo $action; ?>" method="post" enctype="multipart/form-data" id="form">
      <table style="width: 100%;">
        <tr>
          <td style="text-align: center;" rowspan="4"><img src="view/image/login.png" alt="<?php echo $text_login; ?>" /></td>
        </tr>
        <tr>
          <td><?php echo $entry_username; ?><br />
            <!-- php echo $username; -->
            <input type="text" id='username' name="username" value="<?php echo $username;?>" style="margin-top: 4px;" />
            <br />
            <br />
            <?php echo $entry_password; ?><br />
            <input type="password" id='password' name="password" value="<?php echo $password; ?>" style="margin-top: 4px;" /></td>
        </tr>
        <tr>
          <td>&nbsp;</td>
        </tr>
        <tr>
          <td style="text-align: right;"><a onclick="$('#form').submit(); return false;" href="#" class="button"><span><?php echo $button_login; ?></span></a></td>
        </tr>
      </table>
      <?php if ($redirect) { ?>
      <input type="hidden" name="redirect" value="<?php echo $redirect; ?>" />
      <?php } ?>
    </form>
  </div>
  <div style='margin-top:20px'>
    <h2> Account 메뉴, 오더 나올곳을 예측 </h2>
    <p>
    <br/>
    상점 메뉴에 새로이 회색 Bar 가 생긴것을 아실겁니다.<br/>
    빨간 점들은 현재 시점으로 부터 오더가 나온 지점입니다.<br/>
    Good AR 로 상점인데 오더가 없다면 유심히 보셔요<br/>
    <b>잘 관리된 Account 는 order 지점을 쉽게 합니다</b>
    </p>
  </div>

  <div style='margin-top:20px'>
    <h2></h2>
    <p>
    </p>
  </div>

</div>
<?php echo $footer; ?> 

<script type="text/javascript"><!--
$('document').ready(
  function(){
    $('#username').focus();
  }
);
	$('#password').keydown(function(e) {
		if (e.keyCode == 13) {
			$('#form').submit();
		}
	});
//--></script> 

