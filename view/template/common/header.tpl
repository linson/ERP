<?php echo '<?xml version="1.0" encoding="UTF-8"?>' . "\n"; ?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" dir="<?php echo $direction; ?>" lang="<?php echo $lang; ?>" xml:lang="<?php echo $lang; ?>">
<head>
<title><?php echo $title; ?></title>
<base href="<?php echo $base; ?>" />
<?php foreach ($links as $link){ ?>
<link href="<?php echo $link['href']; ?>" rel="<?php echo $link['rel']; ?>" />
<?php } ?>
<link rel="stylesheet" type="text/css" href="view/stylesheet/stylesheet.css" />
<link rel="stylesheet" type="text/css" href="view/javascript/jquery/ui/themes/ui-lightness/ui.all.css" />
<?php foreach ($styles as $style){ ?>
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
</style>
<?php foreach ($scripts as $script){ ?>
<script type="text/javascript" src="<?php echo $script; ?>"></script>
<?php } ?>
<script type="text/javascript">
//-----------------------------------------
// Confirm Actions (delete, uninstall)
//-----------------------------------------
$(document).ready(function(){
  // Confirm Delete
  $('#form').submit(function(){
    if($(this).attr('action').indexOf('delete',1) != -1){
      if(!confirm ('<?php echo $text_confirm; ?>')){
        return false;
      }
    }
  });
  // Confirm Uninstall
  $('a').click(function(){
    if($(this).attr('href') != null && $(this).attr('href').indexOf('uninstall',1) != -1){
      if(!confirm ('<?php echo $text_confirm; ?>')){
        return false;
      }
    }
  });
});
</script>
<script type="text/javascript">
$(document).ready(function(){
  $(".scrollbox").each(function(i){
  	$(this).attr('id', 'scrollbox_' + i);
		sbox = '#' + $(this).attr('id');
  	$(this).after('<span><a onclick="$(\'' + sbox + ' :checkbox\').attr(\'checked\', \'checked\');"><u><?php echo $text_select_all; ?></u></a> / <a onclick="$(\'' + sbox + ' :checkbox\').attr(\'checked\', \'\');"><u><?php echo $text_unselect_all; ?></u></a></span>');
	});
});
</script>

<script type="text/javascript">
$(document).ready(function(){
  /*** $(".list tr:even").css("background-color", "#F4F4F8"); ***/
});
</script>
</head>
<body>
<div id="container">
<div id="header">
  <div class="logo">
    <a href='/backyard' style='text-decoration:none;color:white;'>
    UBP Backyard</a>
  </div>
  <?php if($logged){ ?>
  <div class="div2"><img src="view/image/lock.png" alt="" style="position: relative; top: 3px;" />&nbsp;<?php echo $logged; ?></div>
  <?php } ?>
</div>
<?php if($logged){ ?>
<div id="menu">
  <ul class="nav left" style="display: none;">
    <!--report is common-->
    <li id="reports"><a class="top"><?php echo $text_reports; ?></a>
      <ul>
        <li><a href="index.php?route=common/home">Basic</a></li>
        <li><a href="index.php?route=report/product">Product</a></li>
        <li><a href="index.php?route=report/account">Account</a></li>
      </ul>
    </li>
  <?php
    if($this->user->hasPermission('access', 'material/lookup')){
  ?>
    <!-- add Backyard menu , besso-201103 -->
    <li id="material"><a class="top">PACKAGE</a>
      <ul>
        <li><a href="<?php echo $lnk_material_lookup; ?>"><?php echo $text_material_lookup; ?></a></li>
        <li><a href="<?php echo $lnk_material_productpackage; ?>">Product Map</a></li>
        <li><a href="<?php echo $lnk_material_history; ?>">History</a></li>
      </ul>
    </li>
  <?php
    }
  ?>

  <?php
    if($this->user->hasPermission('access', 'product/inventory')){
  ?>
    <li id="product"><a class="top">PRODUCT</a>
      <ul>
        <!--li><a href="<?php echo $lnk_product; ?>">Base Info</a></li-->
        <!--li><a href="<?php echo $lnk_product_inventory; ?>">Inventory</a></li-->
        <li><a href="<?php echo $lnk_product_price; ?>">Inventory</a></li>
        <li><a href="<?php echo $lnk_product_oem; ?>">OEM</a></li>
      </ul>
    </li>
  <?php
    }
  ?>

  <?php
    if($this->user->hasPermission('access', 'sales/order')){
  ?>
    <li id="sales"><a class="top">SALES</a>
      <ul>
        <li><a href="<?php echo $lnk_sales_lookup; ?>"><?php echo $text_sales_lookup; ?></a></li>
        <li><a href="<?php echo $lnk_sales_order; ?>"><?php echo $text_sales_order; ?></a></li>
        <li><a href="<?php echo $lnk_sales_stat; ?>">Stat</a></li>
        <li><a href="<?php echo $lnk_sales_calendar; ?>">Calendar</a></li>
        <!--li><a href="<?php echo $lnk_update_promotion; ?>">Update Promotion</a></li-->
      </ul>
    </li>
  <?php
    }
  ?>

  <?php
    if($this->user->hasPermission('access', 'invoice/list')){
      $lnk_invoice_list   = HTTPS_SERVER . 'index.php?route=invoice/list&token='  . $this->session->data['token'];	
      $lnk_invoice_search = HTTPS_SERVER . 'index.php?route=invoice/search&token='. $this->session->data['token'];	
  ?>
    <!--li id="invoice"><a class="top">INVOICE</a>
      <ul>
        <li><a href="<?php echo $lnk_invoice_list; ?>">Invoice List</a></li>
        <li><a href="<?php echo $lnk_invoice_search; ?>">Invoice Search</a></li>
      </ul>
    </li-->
  <?php
    }
  ?>

  <?php
    if($this->user->hasPermission('access', 'ar/list')){
      $lnk_ar_list   = HTTPS_SERVER . 'index.php?route=ar/list&token=' . $this->session->data['token'];
      $lnk_ar_statement = HTTPS_SERVER . 'index.php?route=ar/statement&token=' . $this->session->data['token'];
      $lnk_ar_pay = HTTPS_SERVER . 'index.php?route=ar/detail&token=' . $this->session->data['token'];	
      $lnk_ar_report = HTTPS_SERVER . 'index.php?route=ar/report&token=' . $this->session->data['token'];	
      $lnk_quickbook = HTTPS_SERVER . 'index.php?route=ar/quickbook&token=' . $this->session->data['token'];	
  ?>
    <li id="ar"><a class="top">AR</a>
      <ul>
        <!--li><a href="<?php echo $lnk_ar_list; ?>">AR List</a></li>
        <li><a href="<?php echo $lnk_ar_statement; ?>">Account Statement</a></li>
        <li><a href="<?php echo $lnk_ar_pay; ?>">AR Pay</a></li-->
        <li><a href="<?php echo $lnk_quickbook; ?>">Quickbook Update</a></li>
      </ul>
    </li>
  <?php
    }
  ?>

  <?php
    if($this->user->hasPermission('access', 'store/list')){
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
    if($this->user->hasPermission('access', 'setting/setting')){
  ?>
    <li id="system"><a class="top"><?php echo $text_system; ?></a>
      <ul>
        <li><a href="<?php echo $setting; ?>"><?php echo $text_setting; ?></a></li>
        <li><a class="parent"><?php echo $text_users; ?></a>
          <ul>
            <li><a href="<?php echo $user; ?>"><?php echo $text_user; ?></a></li>
            <li><a href="<?php echo $user_group; ?>"><?php echo $text_user_group; ?></a></li>
          </ul>
        </li>
        <li><a class="parent"><?php echo $text_localisation; ?></a>
          <ul>
            <li><a href="<?php echo $language; ?>"><?php echo $text_language; ?></a></li>
            <li><a href="<?php echo $currency; ?>"><?php echo $text_currency; ?></a></li>
            <li><a href="<?php echo $stock_status; ?>"><?php echo $text_stock_status; ?></a></li>
            <li><a href="<?php echo $order_status; ?>"><?php echo $text_order_status; ?></a></li>
            <li><a href="<?php echo $country; ?>"><?php echo $text_country; ?></a></li>
            <li><a href="<?php echo $zone; ?>"><?php echo $text_zone; ?></a></li>
            <li><a href="<?php echo $geo_zone; ?>"><?php echo $text_geo_zone; ?></a></li>
            <li><a href="<?php echo $tax_class; ?>"><?php echo $text_tax_class; ?></a></li>
            <li><a href="<?php echo $length_class; ?>"><?php echo $text_length_class; ?></a></li>
            <li><a href="<?php echo $weight_class; ?>"><?php echo $text_weight_class; ?></a></li>
          </ul>
        </li>
        <li><a href="<?php echo $error_log; ?>"><?php echo $text_error_log; ?></a></li>
        <li><a href="<?php echo $backup; ?>"><?php echo $text_backup; ?></a></li>
        <?php @$this->load->language('tool/csv'); ?>
          <?php if(@$this->language->get('text_csvmenu') != NULL){ ?>
            <li><a href="<?php echo (((HTTPS_SERVER) ? HTTPS_SERVER : HTTP_SERVER) . 'index.php?route=tool/csv&token=' . $this->session->data['token']); ?>"><?php echo $this->language->get('text_csvmenu'); ?></a></li>
          <?php } ?>

      </ul>
    </li>
  <?php } ?>
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
    <!--li id="store"><a onclick="window.open('<?php echo $store; ?>');" class="top"><?php echo $text_front; ?></a>
      <ul>
        <?php foreach ($stores as $stores){ ?>
        <li><a onclick="window.open('<?php echo $stores['href']; ?>');"><?php echo $stores['name']; ?></a></li>
        <?php } ?>
      </ul>
    </li-->
    <li id="ubpboard">
      <a href='index.php?route=report/ubpboard' target='new' class='top'>UBP Board</a>
    </li>

    <li><a class="top" id='change_password' href='index.php?route=user/user/changepassword'>Password</a></li>
    <li><a class="top" href="<?php echo $logout; ?>"><?php echo $text_logout; ?></a></li>
  </ul>
  <!--ul class="nav right">
    <li id="excel"><a class="top">Report</a>
      <ul>
        <li><a href="#" onclick="alert('blocked for security');">CSV</a></li>
      </ul>
    </li>
  </ul-->

<script type="text/javascript">
$(document).ready(function(){
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
function getURLVar(urlVarName){
	var urlHalves = String(document.location).toLowerCase().split('?');
	var urlVarValue = '';
	if(urlHalves[1]){
		var urlVars = urlHalves[1].split('&');
		for (var i = 0; i <= (urlVars.length); i++){
			if(urlVars[i]){
				var urlVarPair = urlVars[i].split('=');
				if(urlVarPair[0] && urlVarPair[0] == urlVarName.toLowerCase()){
					urlVarValue = urlVarPair[1];
				}
			}
		}
	}

	return urlVarValue;
}

$(document).ready(function(){
	route = getURLVar('route');

	if(!route){
		$('#dashboard').addClass('selected');
	}else{
		part = route.split('/');
		url = part[0];
		if(part[1]){
			url += '/' + part[1];
		}
		$('a[href*=\'' + url + '\']').parents('li[id]').addClass('selected');
	}
});
//--></script>
</div>
<?php } ?>
<div id="content">
<?php if($breadcrumbs){ ?>
<div class="breadcrumb">
  <?php foreach ($breadcrumbs as $breadcrumb){ ?>
  <?php echo $breadcrumb['separator']; ?><a href="<?php echo $breadcrumb['href']; ?>"><?php echo $breadcrumb['text']; ?></a>
  <?php } ?>
</div>
<?php } ?>
<?php if(isset($install) && $install){ ?>
<div class="warning"><?php echo $error_install; ?></div>
<?php } ?>

<script>
$('document').ready(function(e){
  $('#change_password').fancybox();
});
</script>