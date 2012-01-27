<?php echo '<?xml version="1.0" encoding="UTF-8"?>' . "\n"; ?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" dir="<?php echo $direction; ?>" lang="<?php echo $lang; ?>" xml:lang="<?php echo $lang; ?>">
<head>
<title>
<?php echo $title; ?>
</title>
<base href="<?php echo $base; ?>" />
<?php foreach ($links as $link) { ?>
<link href="<?php echo $link['href']; ?>" rel="<?php echo $link['rel']; ?>" />
<?php } ?>
<link rel="stylesheet" type="text/css" href="view/stylesheet/stylesheet.css" />
<link rel="stylesheet" type="text/css" href="view/javascript/jquery/ui/themes/ui-lightness/ui.all.css" />
<?php foreach ($styles as $style) { ?>
<link rel="<?php echo $style['rel']; ?>" type="text/css" href="<?php echo $style['href']; ?>" media="<?php echo $style['media']; ?>" />
<?php } ?>
<link href="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8/themes/base/jquery-ui.css" rel="stylesheet" type="text/css"/>

<!--script type="text/javascript" src="http://jqueryui.com/jquery-1.5.1.js"></script-->
<!--script type="text/javascript" src="view/javascript/jquery/jquery-1.5.1.js"></script-->
<script type="text/javascript" src="view/javascript/jquery/jquery.min.js"></script>

<!--script type="text/javascript" src="view/javascript/jquery/ui/ui.core.js"></script-->
<script type="text/javascript" src="http://jqueryui.com/ui/jquery.ui.core.js"></script>

<script type="text/javascript" src="http://jqueryui.com/ui/jquery.ui.widget.js"></script>
<script type="text/javascript" src="view/javascript/jquery/jquery.ui.mouse.js"></script>

<script type="text/javascript" src="view/javascript/jquery/superfish/js/superfish.js"></script>
<script type="text/javascript" src="view/javascript/jquery/tab.js"></script>
<script src="http://maps.google.com/maps/api/js?sensor=false&libraries=geometry"></script>

<script type="text/javascript" src="http://jqueryui.com/ui/jquery.ui.draggable.js"></script>
<script type="text/javascript" src="http://jqueryui.com/ui/jquery.ui.droppable.js"></script>

<script type="text/javascript" src="view/javascript/jquery/autoresize.jquery.js"></script>

<script type="text/javascript" src="view/javascript/thickbox-compressed.js"></script>
<link rel="stylesheet" type="text/css" media="screen" href="http://jquery.com/demo/thickbox/thickbox-code/thickbox.css">

<script type="text/javascript" src="view/javascript/datePicker/date.js"></script>
<script src="view/javascript/datePicker/jquery.datePicker.js"></script>
<link rel="stylesheet" type="text/css" media="screen" href="view/javascript/datePicker/datePicker.css">

<script src="view/javascript/jquery/jquery.fancybox-1.3.4.pack.js"></script>
<link rel="stylesheet" type="text/css" href="view/stylesheet/jquery.fancybox-1.3.4.css" />

<style>
.datepicker {
  position:absolute;
  z-index:99;
}

#menu{
  min-width:100%;
  padding:0;
  height:42px;
  background:none;
  background-color:black;
}

#menu a{
  font-size:18px;
}

.nav .selected .top{
  background:none;
}

</style>
<?php foreach ($scripts as $script) { ?>
<script type="text/javascript" src="<?php echo $script; ?>"></script>
<?php } ?>
<script type="text/javascript">
//-----------------------------------------
// Confirm Actions (delete, uninstall)
//-----------------------------------------
$(document).ready(function(){
    // Confirm Delete
    $('#form').submit(function(){
      if($(this).attr('action').indexOf('delete',1) != -1) {
        if(!confirm ('<?php echo $text_confirm; ?>')) {
          return false;
        }
      }
    });
    // Confirm Uninstall
    $('a').click(function(){
      if($(this).attr('href') != null && $(this).attr('href').indexOf('uninstall',1) != -1) {
        if(!confirm ('<?php echo $text_confirm; ?>')) {
          return false;
        }
      }
    });
});
</script>
<script type="text/javascript">
$(document).ready(function(){
    $(".scrollbox").each(function(i) {
    	$(this).attr('id', 'scrollbox_' + i);
		sbox = '#' + $(this).attr('id');
    	$(this).after('<span><a onclick="$(\'' + sbox + ' :checkbox\').attr(\'checked\', \'checked\');"><u><?php echo $text_select_all; ?></u></a> / <a onclick="$(\'' + sbox + ' :checkbox\').attr(\'checked\', \'\');"><u><?php echo $text_unselect_all; ?></u></a></span>');
	});
});
</script>

<script type="text/javascript">
$(document).ready(function() {
  /*** $(".list tr:even").css("background-color", "#F4F4F8"); ***/
});
</script>
</head>
<body>
<div id="container">
<?php if($logged) { ?>
<div id="menu">
  <ul class="nav left" style="display: none;">

  <?php
    if($this->user->hasPermission('access', 'sales/order')) {
    $lnk_sales_order .= '&mobile=ture';
  ?>
    <li id="sales"><a class="top">SALES</a>
      <ul>
        <li><a href="<?php echo $lnk_sales_lookup; ?>"><?php echo $text_sales_lookup; ?></a></li>
        <li><a href="<?php echo $lnk_sales_order; ?>"><?php echo $text_sales_order; ?></a></li>
        <li><a href="<?php echo $lnk_sales_stat; ?>">Stat</a></li>
        <!--li><a href="<?php echo $lnk_sales_calendar; ?>">Calendar</a></li>
        <li><a href="<?php echo $lnk_update_promotion; ?>">Update Promotion</a></li-->
      </ul>
    </li>
  <?php
    }
  ?>

  <?php
    if($this->user->hasPermission('access', 'store/list')) {
      $lnk_store_list = HTTPS_SERVER . 'index.php?route=store/list&token=' . $this->session->data['token'];
      $lnk_btrip_plan = HTTPS_SERVER . 'index.php?route=store/btrip&token=' . $this->session->data['token'];		
  ?>
    <li id="sales"><a class="top">ACCOUNT</a>
      <ul>
        <li><a href="<?php echo $lnk_store_list; ?>">Store List</a></li>
        <li><a href="<?php echo $lnk_btrip_plan; ?>">B-trip Plan</a></li>
      </ul>
    </li>
  <?php
    }
  ?>

    <?php
    $lnk_send_sms = 'index.php?route=user/sms';
    ?>
    <li id="user"><a class="top">SMS</a>
      <ul>
        <li><a href="<?php echo $lnk_send_sms; ?>">Send SMS</a></li>
      </ul>
    </li>
  </ul>

  <ul class="nav right">
    <li><a class="top" href="<?php echo $logout; ?>"><?php echo $text_logout; ?></a></li>
  </ul>

<script type="text/javascript">
$(document).ready(function() {
	$('.nav').superfish({
		hoverClass	 : 'sfHover',
		pathClass	 : 'overideThisToUse',
		delay		 : 0,
		animation	 : {height: 'show'},
		speed		 : 'normal',
		autoArrows   : false,
		dropShadows  : false, 
		disableHI	 : false, /* set to true to disable hoverIntent detection */
		onInit		 : function(){},
		onBeforeShow : function(){},
		onShow		 : function(){},
		onHide		 : function(){}
	});
	
	$('.nav').css('display', 'block');
});
</script>

<script type="text/javascript"><!-- 
function getURLVar(urlVarName) {
	var urlHalves = String(document.location).toLowerCase().split('?');
	var urlVarValue = '';
	
	if(urlHalves[1]) {
		var urlVars = urlHalves[1].split('&');
		for (var i = 0; i <= (urlVars.length); i++) {
			if(urlVars[i]) {
				var urlVarPair = urlVars[i].split('=');
				
				if(urlVarPair[0] && urlVarPair[0] == urlVarName.toLowerCase()) {
					urlVarValue = urlVarPair[1];
				}
			}
		}
	}

	return urlVarValue;
}

$(document).ready(function(){
	route = getURLVar('route');
	if(!route) {
		$('#dashboard').addClass('selected');
	}else{
		part = route.split('/');
		url = part[0];
		if(part[1]) {
			url += '/' + part[1];
		}
		$('a[href*=\'' + url + '\']').parents('li[id]').addClass('selected');
	}
});
//--></script>
</div>
<?php } ?>
<div id="content">
<?php if($breadcrumbs) { ?>
<div class="breadcrumb">
  <?php foreach ($breadcrumbs as $breadcrumb) { ?>
  <?php echo $breadcrumb['separator']; ?><a href="<?php echo $breadcrumb['href']; ?>"><?php echo $breadcrumb['text']; ?></a>
  <?php } ?>
</div>
<?php } ?>
<?php if(isset($install) && $install) { ?>
<div class="warning"><?php echo $error_install; ?></div>
<?php } ?>

<script>
$('document').ready(function(e){
  $('#change_password').fancybox();
});
</script>