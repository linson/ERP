<?php echo $header; ?>
<?php if ($error_warning){ ?><div class="warning"><?php echo $error_warning; ?></div><?php } ?>
<link rel='stylesheet' type='text/css' href='view/template/sales/order.css' />
<div class="box">
  <div class="left"></div><div class="right"></div>
  <div class="heading np">
    <h1 style='font-size:14px;padding:7px 10px 5px 2px;'></h1>
    <div class="buttons" style='float:right'>
      <a class="button save_order"><span>Save</span></a>
      <a id='show_invoice' class="button"><span>Preview</span></a>
      <?php if($mode == 'show'){ ?>
        <a href="index.php?route=sales/order&txid=<?php echo $txid; ?>" class="button"><span>Edit</span></a>
        <a onclick="location = '<?php echo $lnk_list; ?>';" class="button"><span>List</span></a>
        <a id='print' onclick='printOrder()' class='button'><span>Print</span></a>
      <?php } ?>
    </div>
  </div>
  <div id="ubporder">
    <form action='<?php echo $order_action; ?>' method='post' id='form' autocomplete="off">
    <div id='base'>
      <div id='brief'><?php require_once('view/template/sales/approve.tpl'); ?></div>
      <div class='half' style='clear:both'>
        <div id='storeinfo'><?php require_once('view/template/sales/storeinfo.tpl'); ?></div>
      </div>
      <div style='width:400px;float:left'>
        <div id='ship'><?php require_once('view/template/sales/ship.tpl'); ?></div>
        <div>
          <div style='float:left;width:100px;'>
            <table style='width:200px' id='cpay'>
              <tr>
                <td>PC Date <input type=text name='pc_date' class='date_pick' value='<?php echo $pc_date ?>' style='width:70px' /></td>
                <td style='border-left:1px dotted #e9e9e9;'>
                  <input type=text name='post_check' style='width:60px' value='<?php echo $post_check ?>' />
                </td>
              </tr>
              <tr>
                <td>Current Check</td>
                <td><input type=text name='cur_check'  style='width:60px' value='<?php echo $cur_check ?>' /></td>
              </tr>
              <tr>
                <td>Current Cash</td>
                <td><input type=text name='cur_cash'   style='width:60px' value='<?php echo $cur_cash ?>' /></td>
              </tr>
            </table>
          </div>
          <div id='account_history' style='float:right;width:180px;'></div>
        </div>
      </div>
    </div>

    <?php require_once('view/template/sales/payment.tpl'); ?>
    <!-- order info -->
    <div id='order'>
      <?php require_once('view/template/sales/sales.tpl'); ?>
    </div>
  </div>
  </form>
  <div class='footer'>
    <!-- fileupload -->
    <?php require_once('view/template/sales/fileupload.tpl'); ?>
  </div>
</div>
<?php echo $footer; ?>

<!-- common detail div -->
<div id='detail' class='ui-widget-content'></div>

<style>
#floatmenu{
  top:300px;  left:900px; width:70px; position:absolute;
  border:1px solid red; background-color:orange;  visibility:hidden;
}
#floatmenu div{ text-align:left;  margin:1px; }
#floatmenu div input{ width:60px; color:red;  }
#floatmenu button{  width:60px; }
</style>
<div id='floatmenu' class='np'>
  <div>
    <input type='text' name='float_order_price' value='' readonly/>
  </div>
  <div>
    <input type='text' name='float_freegood_percent' value='' readonly/>
  </div>
  <div>
    <button type="button" id='show'>Confirm</button>
    <!--button type="button" id='edit'>Edit</button-->
  </div>
</div>

<script type="text/javascript" src="view/javascript/jquery/jquery.tipsy.js"></script>

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
  // executor & Hold Request
  /////////////////////////////////////////////////////////////////////////////
  $('select[name=for_who]').bind('change',function(e){
    var for_who = $('select[name=for_who]').attr('value');
  	if(for_who) $('input[name=salesrep]').val(for_who);
  });

  $('select[name=hold]').bind('change',function(e){
    var hold = $('select[name=hold] option:selected').val();
 	  $('input[name=status]').val(hold);
  });

  /////////////////////////////////////////////////////////////////////////////
  // storeinfo
  /////////////////////////////////////////////////////////////////////////////
  // todo. i found the ajax storeSubmit (store/lookup/callback) be called so many times
  // there could be some looping problem , besso 201105
  // after event keydown completed , we need to release the binding
  $('#storeinfo input[name=accountno]').bind('keydown',function(e){
    if(e.keyCode == 13){  e.preventDefault(); $.fn.storeSubmit(e);  }
  });
  $('#storeinfo input[name=store_name]').bind('keydown',function(e){
    if(e.keyCode == 13){  e.preventDefault(); $.fn.storeSubmit(e);  }
  });

  $.fn.storeSubmit = function(e){
    param = '';
    accountno = $('input[name=\'accountno\']').attr('value');
    if(accountno)		param += 'filter_accountno=' + encodeURIComponent(accountno);
    salesrep = $('input[name=\'salesrep\']').attr('value');
    if(salesrep)  param += '&filter_salesrep=' + encodeURIComponent(salesrep);
    store_name = $('input[name=\'store_name\']').attr('value');
    if(store_name)  param += '&filter_name=' + encodeURIComponent(store_name);
    $.ajax({
      type:'get',
      url:'index.php?route=store/lookup/callback',
      dataType:'html',
      data:param,
      success:function(html){
        $cssMap = {
          'visibility':'visible',
          'left':'50px'
        }
        $('#detail').css($cssMap);
        $('#detail').html(html);
        //$('#detail').draggable();
      },
      error:function(XMLHttpRequest,textStatus, errorThrown) { 
        alert(param);
        alert("Error status :"+XMLHttpRequest.statusText); 
        alert("Error status :"+XMLHttpRequest.status); 
        alert("Error type :"+errorThrown); 
        alert("Error message :"+XMLHttpRequest.responseXML); 
        alert("Error response header: " + XMLHttpRequest.getAllResponseHeaders()); 
      } 
    });
  }

  // date picker binding
  $('input.date_pick')
  .bind('focusin',function(e){  $tgt = $(e.target); $_date = $tgt.val();  })
  .datepicker({
    clickInput:true,createButton:false,startDate:'2000-01-01',dateFormat:'yy-mm-dd'
  })
  .bind('change',function(e){
    var $tgt = $(e.target);
    if($tgt.is('input[name=ship_appointment]')){
      if( $tgt.val() != $_date ){
      $el_desc = $('textarea[name=description]');
      $desc = $el_desc.val();
      if( $desc.indexOf("Shipping Date") == -1 ) {
        if($desc != ''){
          $desc = $desc + '\n' + 'Shipping Date : ' + $tgt.val();
        }else{
          $desc = 'Shipping Date : ' + $(this).val();
        }
        $el_desc.val($desc);
      }
      }
    }
  });

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

  var $clickNode = $('#order table tr');
  $('#order').bind('click',function(event){
    if($tgt.is('input')){
      $tgt.select();
    }
  });

  // this start from total_price for all valid rows. we must confirm the one line verification.
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
    if($el_freegood_percent.val() > 20){  alert('freegood exceed 10%'); return; }
    if('insert' == $ddl.attr('value')){
      // saveOrder - txid : JH20110323-IL0004-01
      // same variable mapping >.,<
      $salesrep = $salesrep.attr('value').substring(0,2).toUpperCase();
      $ymd = $ele_order_date.attr('value').substring(0,4) + $ele_order_date.attr('value').substring(5,7) + $ele_order_date.attr('value').substring(8,10);
      $accountno = $accountno.attr('value');

      // create TXID
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
      if(typeof $before_val != 'undefined'){  $default_val = $before_val; }
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

  $('#detail').bind('click',function(e){
    $tgt = $(e.target);
    if($tgt.is('div.rep_locked')){  $('#detail').css('visibility','hidden');  }
  });

  $('#show_invoice').bind('click',function(e){
    $txid = $('input[name=txid]').val();
    if(!$txid){
      alert('No Txid');
      return;
    }
    if( $('input[name=order_price]').val() > 0 ){
      url = 'index.php?route=invoice/sheet&txid=' + $txid;
      window.open(url);
    }
  });

  // remove all comma from 
  $('#cpay').find('input')
  .bind('focusin',function(e){
    $tgt = $(e.target);
    $tgt.select();
  })
  .bind('focusout',function(e){
    $tgt = $(e.target);
    $v = $tgt.val();
    $v = $v.replace(',','');
    $tgt.val($v);
  });
  document.title = $('input[name=accountno]').val() + '-' + $('input[name=store_name]').val();
});

function printOrder(){
  // todo. to make show by who
  $action = $('#form').attr('action');
  $data = $('#form').serialize();
  $.post( $action, $data, function(e){
    $txid = $('input[name=txid]').val();
    $url='index.php?route=invoice/order&debug=true&mode=show&txid=' + $txid;
    winHdr = window.open($url);
    winHdr.onload = function(){
      //winHdr.print();    winHdr.close();
    }
  });
}
</script>
<script type='text/javascript' src='view/template/sales/order.js'></script>