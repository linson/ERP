<?php $today = new DateTime(); $odt = new DateTime($order_date); ?>
<?php echo $header; ?>
<?php if ($error_warning){ ?>
<div class="warning"><?php echo $error_warning; ?></div>
<?php } ?>
<link rel='stylesheet' type='text/css' href='view/template/sales/order.css' />
<script type='text/javascript' src='view/template/sales/atc/jquery/jquery.metadata.js'></script>
<script type='text/javascript' src='view/template/sales/atc/src/jquery.auto-complete.js'></script>
<link rel='stylesheet' type='text/css' href='view/template/sales/atc/src/jquery.auto-complete.css' />
<!--[if IE]>
<script type="text/javascript" src="view/javascript/jquery/flot/excanvas.js"></script>
<![endif]-->
<script type="text/javascript" src="view/javascript/jquery/flot/jquery.flot.js"></script>

<div class="box">
  <div class="left"></div>
  <div class="right">
  </div>
  <div class="heading np">
    <h1></h1>
    <div class="buttons">
      <a class="button save_order"><span>Save</span></a>
      <a id='issue_no' class="button"><span>Issue Invoice.no and Ship</span></a>
      <a id='show_invoice' class="button"><span>Show Invoice</span></a>
      <a onclick="location = '<?php echo $lnk_list; ?>';" class="button"><span>List</span></a>
      <a id='print' onclick='printOrder()' class='button'>
        <span>Print</span>
        <!--img border="0" style='width:20px;height:20px;vertical-align:bottom;' src="image/icon/printtag.jpg"-->
      </a>
    </div>
  </div>
  <!-- todo. temporary for Invoice Order -->
  <style>
    #invoice_hdr{
      margin-top:3px;
    }
    #invoice_hdr td{
      font-size:14px;
      text-align:center;
      height:24px;
      width:50px;
    }
  </style>
  <div id="ubporder">
    <form action='<?php echo $order_action; ?>' method='post' id='form'>
    <div id='base'>
      <div id='brief' style='width:895px'>
        <?php require_once('view/template/sales/approve.tpl'); ?>
        <div style='float:right;'>
        <table id='invoice_hdr' border=1 cellspacing=0 cellpading=1 style='font-size:20px;'>
          <tr>
            <td style='width:65px'>TK/UPS</td>
            <td>BOX/Skid</td>
            <td>Weight(LB)</td>
            <td>Cost</td>
            <td>DATE</td>
            <td>INVOICE</td>
          </tr>
          <tr>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
          </tr>
        </table>
        </div>
      </div>
      <div class='half'>
        <div id='storeinfo'>
          <?php require_once('view/template/sales/storeinfo.tpl'); ?>

          <!-- some nude code for AR -->
          <div>
            <?php
            if( $cur_check > 0 || $cur_cash > 0 || $post_check > 0 ){
            ?>
            <div style='float:left;width:100px;'>
              <table style='width:200px'>
                <tr>
                  <td>PC Date <input type=text name='pc_date' class='date_pick' value='<?php echo $pc_date ?>' style='width:70px' /></td>
                  <td style='border-left:1px dotted #e9e9e9;'>
                    <input type=text name='post_check' style='width:60px' value='<?php echo $post_check ?>' />
                  </td>
                </tr>
                <tr>
                  <td>Current Check</td>
                  <td>
                    <input type=text name='cur_check'  style='width:60px' value='<?php echo $cur_check ?>' />
                  </td>
                </tr>
                <tr>
                  <td>Current Cash</td>
                  <td>
                    <input type=text name='cur_cash'   style='width:60px' value='<?php echo $cur_cash ?>' />
                  </td>
                </tr>
              </table>
            </div>
            <?php } // end of ps check ?>
            <div id='account_history' style='float:right;width:180px;'></div>
          </div>
        </div>
      </div>
      <div style='width:400px;float:left'>
        <!-- ship info : start -->
        <div id='ship'>
          <?php require_once('view/template/sales/ship.tpl'); ?>
        </div>
        <div id='invoice' style='background-color:#e3fcd4;'>
          <table border='1' cellpadding="0" cellspacing="0">
            <tr>
              <td class='label' style='height:20px'>Typed BY</td>
              <td>
                <input type='text' name='shipped_by' value='<?php echo $this->user->getUsername(); ?>' size='3' readonly />
                <input type='hidden' name='approve' value='<?php echo $approve_status; ?>'/>
              </td>
              <td class='label' style='height:20px'>Invoice.No</td>
              <td><input type='text' name='invoice_no' value='<?php echo $invoice_no; ?>' size='5' readonly /></td>
            </tr>
          </table>
        </div>
        <!-- end of ship -->
      </div>
    </div>

    <?php require_once('view/template/sales/payment.tpl'); ?>
    <!-- order info -->
    <div id='order'>
      <?php 
      if( isset($this->request->get['debug']) ){
        require_once('view/template/invoice/sales_oneline.tpl');
      }else{
        require_once('view/template/invoice/sales.tpl');
      }
      ?>
    </div>
  </div>
  </form>
  <div class='footer'>
    <!-- fileupload -->
    <?php require_once('view/template/sales/fileupload.tpl'); ?>
  </div>
</div>
<?php //echo $footer; ?>

<!-- common detail div -->
<div id='detail' class='ui-widget-content'></div>

<style>
#floatmenu{
  top:300px;
  left:700px;
  width:70px;
  position:absolute;
  border:1px solid red;
  background-color:orange;
  visibility:hidden;
}
#floatmenu div{
  text-align:left;
  margin:1px;
}
#floatmenu div input{
  width:60px;
  color:red;
}
#floatmenu button{
  width:60px;
}
</style>

<div id='floatmenu' class='np'>
  <div>
    <input type='text' name='float_order_price' value='' readonly/>
  </div>
  <div>
    <input type='text' name='float_freegood_percent' value='' readonly/>
  </div>
  <div>
    <button type="button" id='show'>Show</button>
    <!--button type="button" id='edit'>Edit</button-->
  </div>
</div>

<style>
.tipsy{ padding:5px; font-size:10px; position: absolute; z-index: 100000; }
.tipsy-inner{
  padding: 5px 8px 4px 8px; background-color: black; color: white; max-width: 200px; text-align: center; 
  font-size:14px;
}
.tipsy-inner { border-radius: 3px; -moz-border-radius:3px; -webkit-border-radius:3px; }
.tipsy-arrow { position: absolute; background: url('../images/tipsy.gif') no-repeat top left; width: 9px; height: 5px; }
.tipsy-n .tipsy-arrow { top: 0; left: 50%; margin-left: -4px; }
.tipsy-nw .tipsy-arrow { top: 0; left: 10px; }
.tipsy-ne .tipsy-arrow { top: 0; right: 10px; }
.tipsy-s .tipsy-arrow { bottom: 0; left: 50%; margin-left: -4px; background-position: bottom left; }
.tipsy-sw .tipsy-arrow { bottom: 0; left: 10px; background-position: bottom left; }
.tipsy-se .tipsy-arrow { bottom: 0; right: 10px; background-position: bottom left; }
.tipsy-e .tipsy-arrow { top: 50%; margin-top: -4px; right: 0; width: 5px; height: 9px; background-position: top right; }
.tipsy-w .tipsy-arrow { top: 50%; margin-top: -4px; left: 0; width: 5px; height: 9px; }
</style>

<!--external link for google map--> 
<script type="text/javascript" src="view/javascript/jquery/jquery.tipsy.js"></script>
<!--script type="text/javascript" src="view/template/sales/order.js"></script-->

<script type="text/javascript">
$(document).ready(function(){
  // use name as amount instead of order_price used in #order
  var $ele_amount = $('#payment').find('input[name=order_price]'),
      $ele_balance = $('#payment').find('input[name=balance]'),
      $ele_payed_sum = $('#payment').find('input[name=payed_sum]'),
      $ele_order_date = $('#storeinfo').find('input[name=order_date]'),
      $el_txid = $txid = $('#form').find('input[name=txid]'),
      $el_freegood_amount = $('#freegood_amount'),
      $el_freegood_percent = $('#freegood_percent'),
      $aProductLocked = new Array(),
      $aInventoryReleased = new Array();

  $('input[readonly]').css('background-color','#e3e3e3');
  $('select[disabled]').css('background-color','#e3e3e3');

  // approve
  $('#brief').bind('click',function(e){
    $tgt = $(e.target);
    if($tgt.is('span.approve')){
      $.fn.updateApprove('approve');
    }
    if($tgt.is('span.pending')){
      $.fn.updateApprove('pending');
    }
  });

  $.fn.updateApprove = function(status){
    $txid = $el_txid.val();
    $.ajax({
      type:'get',
      url:'index.php?route=sales/order/updateApprove&token=<?php echo $token; ?>',
      dataType:'text',
      data:'status=' + status + '&txid=' + $txid,
      success:function(text){
        $html = "<font size=3 color=blue><b>" + status + "</b></font>";
        $('#' + status).html($html);
        if('approve' == status){
          $pendingHtml = '<a class="button"><span class="pending">Pending</span></a>';
          $('#pending').html($pendingHtml);
        }else if('pending' == status){
          $approveHtml = '<a class="button"><span class="approve">Approve</span></a>';
          $('#approve').html($approveHtml);        
        }
      }
    });
  }

  /////////////////////////////////////////////////////////////////////////////
  // executor
  /////////////////////////////////////////////////////////////////////////////
  $('select[name=for_who]').bind('change',function(e){
    var for_who = $('select[name=for_who]').attr('value');
  	if(for_who) $('input[name=salesrep]').val(for_who);
  });

  /////////////////////////////////////////////////////////////////////////////
  // storeinfo
  /////////////////////////////////////////////////////////////////////////////
  // todo. i found the ajax storeSubmit (store/lookup/callback) be called so many times
  // there could be some looping problem , besso 201105
  // after event keydown completed , we need to release the binding
  $('#storeinfo #findstore').click(function(e){
    $.fn.storeSubmit();
  });
  $('#storeinfo input[name=\'accountno\']').bind('keydown',function(e){
    if(e.keyCode == 13) $.fn.storeSubmit(e);
  });
  $('#storeinfo input[name=\'store_name\']').bind('keydown',function(e){
    if(e.keyCode == 13) $.fn.storeSubmit(e);
  });

  $.fn.storeSubmit = function(e){
    var param = '';
  	var store_name = $('input[name=\'store_name\']').attr('value');
  	if(store_name)  param += '&filter_name=' + encodeURIComponent(store_name);
  	var accountno = $('input[name=\'accountno\']').attr('value');
  	if(accountno)		param += '&filter_accountno=' + encodeURIComponent(accountno);
  	var salesrep = $('input[name=\'salesrep\']').attr('value');
  	if(salesrep)  param += '&filter_salesrep=' + encodeURIComponent(salesrep);
    $.ajax({
      type:'get',
      url:'<?php echo HTTP_SERVER; ?>/index.php?route=store/lookup/callback&token=<?php echo $token; ?>',
      dataType:'html',
      data:param,
      success:function(html){
        $cssMap = {
          'visibility':'visible',
          'left':'50px'
        }
        $('#detail').css($cssMap);
        $('#detail').html(html);
        $('#detail').draggable();
      }
    });
  }

  // date picker binding
  $('#form').bind('focusin',function(event){
    var $tgt = $(event.target);
    if($tgt.is('input.date_pick')){
      $(".date_pick").datePicker({
        clickInput:true,
        createButton:false,
        startDate:'2000-01-01'
      });
    }
  });

  // automatically show how many days be passed from order_date
  $('#payment').bind('change',function(event){
    var $tgt = $(event.target);
    if($tgt.is('#payment input.date_pick')){
      order_date = $ele_order_date.val();
      pay_date = $tgt.val();
      $diff_days = $.fn.calculateDiffDays(order_date,pay_date);
      $tgt.parent('td').find('span').css('color','red');      
      $tgt.parent('td').find('span').html( '+' + $diff_days );
    }
    // bind for DC change
    if( $tgt.is('input[name=dc1]') || $tgt.is('input[name=dc2]') || $tgt.is('input[name=dc3]') ){
      $.fn.verifyCorePayment();
    }
  });

  // this start from total_price for all valid rows. we must confirm the one line verification.
  $.fn.verifyCorePayment = function(){
    var $aTotalPrice = $('#order').find('input[name="total_price[]"]'),
        $orderSum = 0;
    $.each($aTotalPrice,function(idx,object){
      if(object.name == 'total_price[]' && object.value > 0){
        $orderSum += parseFloat($aTotalPrice[idx].value);
      }
    });
    $ele_amount.val($orderSum);
    $ele_balance.val($orderSum);
    $.fn.storeDiscount();
  }

  // todo. move to lib. common lib to calculate date difference
  $.fn.calculateDiffDays = function(day1,day2){
    d1 = $.fn.parseDate(day1);
    d2 = $.fn.parseDate(day2);
    dd = (d2-d1)/(1000*60*60*24); 
    return parseInt(dd);
  };

  $.fn.parseDate = function(date){
    var Ymd = date.split('-');
    return new Date(Ymd[0],Ymd[1],Ymd[2]);
  };

  // Dynamic row binding , shipment
  $('#ship>table').mouseover(function(event){
    var $tgt = $(event.target),
        $pnt = $tgt.parents('tr');
    if($tgt.is('p.plus') && $pnt.is('tr') ){
      $tgt.css('background', 'url(\'view/image/plus_icn.jpg\') no-repeat');
    }
    if($tgt.is('p.del') && $pnt.is('tr')){
      if($pnt[0].rowIndex != 2){
        $tgt.css('background', 'url(\'view/image/del_icn.jpg\') no-repeat');
      }
    }
  });

  $('#ship>table').mouseout(function(event){
    var $tgt = $(event.target),
        $pnt = $tgt.parents('tr');
    if($tgt.is('p.plus')){
      $tgt.css('background', 'url(\'\') no-repeat');
    }
    if($tgt.is('p.del') && $pnt.is('tr')){
      if($pnt[0].rowIndex != 2){
        $tgt.css('background', 'url(\'\') no-repeat');
      }else{
        $tgt.css('cursor','default');
      }
    }
  });

  // todo. border-bottom not work correctly , besso-201103 
  var $newShipRow = "<tr><td class='label' style='width:50px'><p class='del' style='float:left;margin:0px;margin-left:2px;'></p><input type='hidden' name='ship_id[]' value='' /><input type='hidden' name='ship_user[]' value='' />M</td><td class='context' style='width:50px'><select name='method[]'><option value='truck'>truck</option><option value='ups' selected>ups</option><option value='delivery'>delivery</option><option value='pickup'>pickup</option></select></td><td class='label'>LFT/COD</td><td class='context'><input type='number' name='lift[]' value='0' size='2' /> / <input type='number' name='cod[]' value='0' size='2' /></td><td class='label'>DATE</td><td class='context'><input type='text' class='date_pick' name='ship_date[]' value='' size='8' /><p class='plus' style='float:right;margin:0px;margin-right:2px;' /></td></tr>";
  $('#ship').click(function(event){
    var $tgt = $(event.target),
        $pnt = $tgt.parents('tr');
    if($tgt.is('p.plus') && $pnt.is('tr') ){
      $tgt.parent().parent().after($newShipRow);
      $tgt.parent().parent().next().css('border-top','2px solid orange');
    }
    if( $tgt.is('p.del') && $pnt.is('tr') ){
      if($pnt[0].rowIndex != 2){
        $tgt.parent().parent().remove();
      }else{
        $tgt.css('cursor','default');
      }
    }
  });

  // #order section
  $('#order').bind('mousedown',function(event){
    var $tgt = $(event.target),
        $mama = $tgt.parents('table'),
        $cat = $mama.attr('id'),
        $atcObject = $mama.find('input.atc'),
        $ele_store = $('#storeinfo').find('input[name=store_id]');
    if($atcObject.is('input.atc')){
      if(false == $.fn.validateNull($ele_store)) return;
      $atcObject.autoComplete({cat:$cat});
    }
  });
  // atc-end

  // Dynamic row binding , order
  $('#order').mouseover(function(event){
    var $tgt = $(event.target);
    if($tgt.is('td.plus')){
      $tgt.css('background', 'url(\'view/image/plus_icn.jpg\') no-repeat');
    }
    $trCnt = $tgt.parent().parent().children().length;
    //if($tgt.is('td.del') && $trCnt > 1){
    // todo. temporarily release first row distriction, , besso-201103 
    if($tgt.is('td.del')){
      $tgt.css('background', 'url(\'view/image/del_icn.jpg\') no-repeat');
    }

    /*** todo. no problem and need to make manually. tipsy heavy
    // tooltip.show each price
    if($tgt.is('input[name="price[]"]')){
      $count = $tgt.parents('tr').find('.pc').html();
      $price = $tgt.val();
      if( '' != $count && '' != $price){
        $eaPrice = parseFloat( ( parseFloat($price) / parseInt($count) ) , 2 ); 
        $tgt.attr('original-title',$eaPrice);
        $tgt.tipsy();
      }
    }
    ***/
  });

  $('#order').mouseout(function(event){
    var $tgt = $(event.target);
    if($tgt.is('td.plus')){
      $tgt.css('background', 'url(\'\') no-repeat');
    }
    if($tgt.is('td.del')){
      $tgt.css('background', 'url(\'\') no-repeat');
    }
  });

  var $newRow = "<tr><td class=\"del nostyle\"></td><td style=text-align:left;><input type=text class=atc name=model[] style=width:60px; />";
      $newRow+= "<input type=hidden name=image[] value='' /><input type=hidden name=product_id[] value='' /><input type=hidden name=weight[] value='' />";
      $newRow+= "<img class='preview' title='' src='view/image/preview.jpg' style='diplay:none;' /></td><td class='product_name'></td><td class='pc'></td>";
      $newRow+= "<td style='width:70px'><input type=text name=stock[] size=2 />&nbsp;<img class='check_locked' src='image/data/package/locked.gif' style='display:none;'/></td>";
      $newRow+= "<td><input type=text name=cnt[] value=0 size=2 /></td><td><input type=text name=free[] value=0 size=2 /></td><td><input type=text name=damage[] value=0 size=2 /></td><td><input type=text name=price[] value=0 size=3/></td><td><input type=text name=discount[] value=0 size=2 />% </td><td><input type=text name=discount2[] value=0 size=2 />% </td><td><input type=text name=total_price[] value=0 class=total_price size=4 /><input type=hidden name=weight_row[] value='' /></td><td class=\"plus nostyle\"></td></tr>";
  var $clickNode = $('#order table tr');

  $('#order').bind('click',function(event){
    var $tgt = $(event.target),
        $pnt = $tgt.parents('td');
    // todo. why dont use jquery library, , besso 201108
    if($tgt.is('img.preview')){
      var $imgUrl = $tgt.attr('title').trim();
      var html  = "<a onclick=\"$('#detail').html();$('#detail').css('visibility','hidden');\" class=\"button\"><span>Close</span></a><br/>";
          html += '<img src=' + $imgUrl + ' />';  
      $p = $tgt.position();
      $imgCss = {
        'visibility':'visible',
        'width':'500px',
        'height':'520px',
        'top':$p.top,
        'left':$p.left
      }
      $('#detail').css($imgCss);
      $('#detail').html(html);
      $('#detail').draggable();
    }

    if($tgt.is('input.check_locked')){
      $model = $pnt.find('input[name="model[]"]').val();
      $.ajax({
        type:'get',
        // this just return json
        url:'index.php?route=sales/order/callLockedPannel',
        dataType:'html',
        data:'token=<?php echo $token; ?>&model=' + $model,
        success:function(html){
          if(html){
            $p = $tgt.position();
            $cssMap = {
              'visibility':'visible',
              'height':'30px',
              'width':'300px',
              'border':'0',
              'top':$p.top + 300,
              'left':$p.left - 400
            }
            $('#detail').css($cssMap);
            $('#detail').html(html);
          } // success
        }
      });
    }

    if($tgt.is('td.plus')){
      $tgt.parents('tr').after($newRow);
    }

    // $trCnt = $tgt.parent().parent().children().length;
    // To remove invoke to each all object loop
    if($tgt.is('td.del')){
      $.fn.deleteOneRow($tgt);
      $tgt.parent().remove();
      // tune balance 
      if(false == $.fn.validateAR()){
        alert('AR Problem, all stop and ask IT team');
      }
    }
    if($tgt.is('input')){
      $tgt.select();
    }
  });

  // this start from total_price for all valid rows. we must confirm the one line verification.
  $.fn.deleteOneRow = function($tgt){
    var $aTotalPrice = $('#order').find('input[name="total_price[]"]'),
        $node = $tgt.parents('tr'),
        $thisTotalPrice = $node.find('input[name="total_price[]"]').val(),
        $orderSum = 0;
    $.each($aTotalPrice,function(idx,object){
      if(object.name == 'total_price[]' && object.value > 0){
        //console.log($aFree[idx].value + '::' + $aPrice[idx].value);
        $orderSum += parseFloat($aTotalPrice[idx].value);
      }
    });
    $orderSum = $orderSum - parseFloat($thisTotalPrice);
    $ele_amount.val($orderSum);
    $ele_balance.val($orderSum);
    $.fn.storeDiscount();
  }

  $.fn.validateNull = function(obj){
    if(obj.attr('value') == ''){
      alert('fill value : ' + obj.attr('name'));
      obj.css('background-color','red');
      return false;
    }
  }

  $('#save').bind('click',function(e){
    var $ddl = $('#form').find('input[name=ddl]');
    var $salesrep = $('#storeinfo').find('input[name=salesrep]'),
        $store_id = $('#form').find('input[name=store_id]'),
        $accountno = $('#storeinfo').find('input[name=accountno]'),
        $txid = $('#form').find('input[name=txid]'),
        $weight_sum = $('#form').find('input[name=weight_sum]');

    if(false == $.fn.validateNull($accountno)) return;
    if(false == $.fn.validateNull($ele_order_date)) return;
    if(false == $.fn.validateNull($salesrep)) return;
    if(false == $.fn.validateNull($store_id)) return;

    if($el_freegood_percent.val() > 20){
      alert('freegood exceed 10%');
      return;
    }

    if('insert' == $ddl.attr('value')){
      // saveOrder - txid : JH20110323-IL0004-01
      // same variable mapping >.,<
      $salesrep = $salesrep.attr('value').substring(0,2).toUpperCase();
      $ymd = $ele_order_date.attr('value').substring(0,4) + $ele_order_date.attr('value').substring(5,7) + $ele_order_date.attr('value').substring(8,10);
      $accountno = $accountno.attr('value');

      // create TXID
      /* change TXID structure for kim
      select substr(txid,1,10),substr(txid,12,6),substr(txid,19,1),txid from pay;
      select concat(substr(txid,12,6),'-',substr(txid,1,10),'-',substr(txid,19,1)), txid from pay;
      update transaction set txid = concat(substr(txid,12,6),'-',substr(txid,1,10),'-',substr(txid,19,1));
      update sales set txid = concat(substr(txid,12,6),'-',substr(txid,1,10),'-',substr(txid,19,1));
      update ship set txid = concat(substr(txid,12,6),'-',substr(txid,1,10),'-',substr(txid,19,1));
      update pay set txid = concat(substr(txid,12,6),'-',substr(txid,1,10),'-',substr(txid,19,1));
      */
      $vTxid = $accountno + '-' + $salesrep + $ymd;
      $txid.val($vTxid);  // todo. it not work under below if case. crop

      // insert, firstly check already exsit txid
      $ddl.val('insert');
      // console.log('txid : ' + $vTxid);  

      // todo. twice order not permitted for one day or make next sequence automatically
      $.ajax({
        type:'get',
        url:'/backyard/index.php?route=sales/order/verify_txid',
        dataType:'json',
        data:'token=<?php echo $token; ?>&txid=' + $vTxid,
        success:function(list){
          // var list = ['BE20110324-FL4545-01','BE20110324-FL4545-02'];
          // hack for malformed json
          // console.log('success : ' + list);
          if(list != null){
            $('#detail').html('');
            $('#detail').css('visibility','visible');
            $('#detail').css('background','orange');
            $('#detail').css('padding','10px');
            $('#detail').css('list-style','none');
            $('#detail').append('<font color=red>Update below or ...</font>');
            $('#detail').append('You need to check these txid before saving !!');
            $.each(list,function(idx,val){
              $url = '/backyard/index.php?route=sales/order&token=<?php echo $token; ?>&txid=' + val['txid'];
              $html = '<li><a href=' + $url + '>' + val['txid'] + '</a></li>';
              $('#detail').append($html);
            });
            $('#detail').append('<a onclick="$(\'#detail\').css(\'visibility\',\'hidden\'); $(\'#detail\').html(\'\'); $(\'#form\').submit();"><strong>CLOSE</strong></a>');
            $('#detail strong').css('float','right');
            $('#detail').draggable(); 
          }else{
            // todo. strongly need to exclude any gabage post, , besso-201103 
            //console.log('form submit for no existing txid');
            $('#form').submit();
            return false;
          }

          // basic code done, need to test with real DB later , besso-201103 
        },
        fail:function(){
          //console.log('fail : no response from proxy');
        }
      });
    }else{
      $ddl.val('update');
      $('#form').submit();
    }
  });

  // payed sum and balace process
  $('#payment').bind('focusout',function(event){
    var $tgt = $(event.target);
    if($tgt.is('input.pay_price')){
      //$default_val = $tgt['context'].defaultValue;
      $default_val = $tgt['context'].defaultValue;

      // init , default val , besso-201103 
      if('' == $default_val) $before_val = 0;

      // JS do not support value history except defaultValue, custom go , besso-201103 
      if(typeof $before_val != 'undefined'){
        $default_val = $before_val;
      }
      $changed_val = $tgt['context'].value;
      $added_val = ( parseFloat($changed_val) - parseFloat($default_val) );
      $added_val.toFixed(2);

      // JS do not support value history except defaultValue, custom go , besso-201103 
      $before_val = $changed_val;

      if($default_val != $changed_val){
        var $payed_sum =  $ele_payed_sum.val();
        $sum = parseFloat($payed_sum) + parseFloat($added_val);
        $sum.toFixed(2);

        if( parseFloat($sum) > $ele_amount.val()){
          alert('Paid-Price cannot over Order-Price');
          $tgt.val($tgt[0].defaultValue);
          $tgt.focus();
          return;
        }
        $ele_payed_sum.val($sum);
        $balance = $ele_amount.val() - $sum;
        $balance = $balance.toFixed(2);
        $ele_balance.val($balance);
     }
    }
  });

  /*** block. arHistory for shipping
  $.fn.arHistory = function(store_id){
    if(!store_id) store_id = $('#form').find('input[name=store_id]').val();
    $.ajax({
      type:'get',
      url:'index.php?route=sales/order/arHistory',
      dataType:'html',
      data:'store_id=' + store_id,
      success:function(html){
        //$('#account_history').html(html);
        document.getElementById('account_history').innerHTML = html;
      }
    });
  }

  $txid = $('#form').find('input[name=txid]');
  if('' != $txid.val()){
    $.fn.arHistory();
  }
  ***/
  $('#detail').bind('click',function(e){
    $tgt = $(e.target);
    if($tgt.is('div.rep_locked')){
      $('#detail').css('visibility','hidden');
    }
  });
});

$.fn.qbHistory = function(store_id){
  if(!store_id) store_id = $('#form').find('input[name=store_id]').val();
  $.ajax({
    type:'get',
    url:'index.php?route=sales/order/qbHistory',
    dataType:'html',
    data:'store_id=' + store_id,
    success:function(html){
      //$('#account_history').html(html);
      document.getElementById('account_history').innerHTML = html;
    }
  });
}

$txid = $('#form').find('input[name=txid]');
if('' != $txid.val()){
  //$.fn.arHistory();
  $.fn.qbHistory();
}

function printOrder(){
  self.focus();
  self.print();
}
</script>

<script type='text/javascript' src='view/template/sales/order.js'></script>

<script>
/*** most of ship custom be controlled by JS ***/
$('#storeinfo input').attr('readonly','true');
$('#ship input').attr('readonly','true');
$('#payment input').attr('readonly','true');
//$('#storeinfo textarea').css('height','120px');

// todo. unbind not work well so remove class
$('#order h1').removeClass('header');
$cssMap = {
    'background':'none repeat scroll 0 0 black',
    'color':'white',
    'font-size':'16px',
    'height':'30px',
    'line-height':'30px',
    'margin-bottom':'1px',
    'padding-left':'20px',
    'width':'900px'
}

$('#storeinfo').find('tr.no_print_invoice').css('display','none');
$('#storeinfo').find('input[name=accountno]').css('font-size','20px').css('font-weight','bold').css('width','90px');
$('#storeinfo').find('input[name=storetype]').css('width','20px');
$('#storeinfo').find('input[name=store_name]').css('font-size','20px').css('font-weight','bold').css('width','220px');
$('#storeinfo').find('textarea[name=description]').css('font-size','14px').css('font-weight','bold');
$('#storeinfo').find('#history_account').css('display','none');

$('#order h1').css($cssMap);
//$('#order').find('.product_name').css('width','140px');
$('#order').find('input[name="model_show[]"]').css('width','34px');
$('#order').find('input[name="pkg[]"]').css('display','inline').css('font-size','28px').css('width','80px').css('height','22px').css('font-weight','bold');
$('#order').find('input[name="price[]"]').css('width','45px');
$('#order').find('input[name="discount[]"]').css('width','20px');
$('#order').find('input[name="discount2[]"]').css('width','20px');
$('#order').find('.product_name').css('font-size','18px').css('font-weight','bold');
$('#order').find('input[name="cnt[]"]').css('font-size','18px').css('width','40px');
$('#order').find('input[name="total_price[]"]').css('display','none');
$('#order').find('input[name="stock[]"]').css('display','none');
$('#order').find('input[name="promotion[]"]').css('vertical-align','top');

$('#ship').find('select[name=ship_method]').css('font-size','20px').css('height','30px').css('font-weight','bold');
$('#ship').find('textarea[name=shipto]').css('height','70px').css('font-size','13px').css('font-weight','bold');
$('span#txid_header').css('display','none');
$('#payment').find('input[name=order_price]').css('font-size','20px').css('font-weight','bold');
$('#order').find('td').addClass('invoice');
$('div#invoice').css('display','none');
$('#order').find('.invoice_clear_left').css('clear','left');
$('#order').find('.invoice_float_right').css('float','right');
$('#order').find('.product_name').css('text-align','left');

$('#fileupload').find('.fileupload-buttonbar').css('display','none');
$('#fileupload').find('.fileupload-content').css('border','none');
//$('#fileupload').find('tr.template-download').css('display','block').css('float','left');

$('.invoice')
  .bind('focusin.invoice',function(event){
    $tgt = $(event.target),$node = $tgt.parents('td');
    $_count = $node.find('input[name="cnt[]"]').val();
    $_free = $node.find('input[name="free[]"]').val();
    $_damage = $node.find('input[name="damage[]"]').val();
    $_promotion = $node.find('input[name="promotion[]"]').val();
  })
  .bind('focusout.invoice',function(event){
    var $tgt = $(event.target),$node = $tgt.parents('td');
    //if('13' == event.which){
      if($tgt.is('input[name="cnt[]"]') ){
        var $backorder = $node.find('input[name="backorder[]"]').val();
        $backorder = parseInt($backorder) + parseInt($_count) - parseInt($tgt.val());
        //console.log('backorder : ' + $backorder);
        $node.find('input[name="backorder[]"]').val($backorder);
      }
      if($tgt.is('input[name="free[]"]') ){
        var $backfree = $node.find('input[name="backfree[]"]').val();
        $backfree = parseInt($backfree) + parseInt($_free) - parseInt($tgt.val());
        //console.log('backfree : ' + $backfree);
        $node.find('input[name="backfree[]"]').val($backfree);
      }
      if($tgt.is('input[name="damage[]"]') ){
        var $backdamage = $node.find('input[name="backdamage[]"]').val();
        $backdamage = parseInt($backdamage) + parseInt($_damage) - parseInt($tgt.val());
        //console.log('backdamage : ' + $backdamage);
        $node.find('input[name="backdamage[]"]').val($backdamage);
      }
      if($tgt.is('input[name="promotion[]"]') ){
        var $backpromotion = $node.find('input[name="backpromotion[]"]').val();
        $backpromotion = parseInt($backpromotion) + parseInt($_promotion) - parseInt($tgt.val());
        $node.find('input[name="backpromotion[]"]').val($backpromotion);
      }
    //}
    $pkg = parseInt($node.find('input[name="cnt[]"]').val())+
           parseInt($node.find('input[name="free[]"]').val())+
           parseInt($node.find('input[name="damage[]"]').val())+
           parseInt($node.find('input[name="promotion[]"]').val());
    $node.find('input[name="pkg[]"]').val($pkg);
  });
  $('input[name="promotion[]"]').bind('keydown',function(e){
    $tgt = $(e.target);
    if('13' == e.which){
      $tgt.next().focus();
    }
  });

  /* check the description and store invoice desc in transaction
   * save file physically
   * print
   */
  $('#issue_no').click(function(){
    // set txidList for batch process
    /*
    var $txidList = [],
        $descList = [];
    $txidList.push($('input[name=txid]').val());
    $descList.push(encodeURIComponent($('textarea[name=description]').val()));
    */
    var $invoice = $('input[name=invoice_no]').val(),
        $approve = $('input[name=approve]').val(),
        $shipped_by = $('input[name=shipped_by]').val();
        $txid = $('input[name=txid]').val();
        $desc = encodeURIComponent($('textarea[name=description]').val());
        //debugger;
        if(parseInt($invoice) > 0){
          alert('Already Exist , Invoice Number : ' + $invoice );
          return false;
        }
        if('approve' != $approve){
          alert('Get Approve with Sales Leader first');
          return false;
        }
    $hdr = $.ajax({
      type:'get',
      url:'index.php?route=invoice/list/issueInvoiceNo',
      dataType:'text',
      data:'token=<?php echo $token; ?>&txid=' + $txid + '&desc=' + $desc
    });
    $hdr.success(function(text){
      $url = 'index.php?route=invoice/sheet&token=<?php echo $token; ?>&txid=<?php echo $txid; ?>';
      winHdr = window.open($url);
      winHdr.onload = function(){
        winHdr.print();
        //winHdr.close();
      }
    });
  });

  $('.save_order').bind('click',function(e){
    // store level discount
    //$.fn.storeDiscount();
    //debugger;
    $('#form').find('input[name=mode]').val('show');
    $order_price = $('#form').find('input[name=order_price]').val();
    $order_price = parseFloat($order_price);
    if($order_price == 0){
      alert('No Order');
      return;
    }
    if( $('#form').find('input[name=txid]').val() == '' ){
      $hdr = $.fn.generateTXID();
      $hdr.success(function($txid){
        // todo. weird . dont know why
        $txid = $txid.replace("\"","");
        //$txid = $txid.substring(1,$txid.length-1);
        $('#form').find('input[name=txid]').val($txid);
        $('#form').find('input[name=ddl]').val('insert');
        $('#txid_header').html($txid);
        $('#form').submit();
      });
    }else{
      $('#form').find('input[name=ddl]').val('update');
      $('#form').submit();
    }
  });

  $(window).scroll(function (){
    $p = $('#floatmenu').offset();
    $top = $(window).scrollTop()+200;
    $('#floatmenu').css('top',$top);
  });
  $('#show_invoice').bind('click',function(e){
    url = 'index.php?route=invoice/sheet&txid=<?php echo $txid ?>';
    window.open(url);
  });

  $('document').ready(function(e){
    document.title = $('input[name=accountno]').val() + '-' + $('input[name=store_name]').val();
    //todo. automatic window.print not print image so blcoked
    <?php
    //todo. need to check some id contain double quote
    if( !is_dir('/var/lib/asterisk/backyard/view/javascript/fileupload/example/thumbnails/'.$txid ) ){
    ?>
      $('#fileupload').css('display','none');
    <?php } ?>
    <?php if($txid != 'MI1651A-WH20120222-1'){ ?>
      setTimeout(function(){
        window.print(); window.close();
      },1000);
    <?php } ?>
  });
</script>