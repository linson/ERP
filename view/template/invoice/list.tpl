<?php echo $header; ?>
<?php if ($error_warning) { ?>
<div class="warning"><?php echo $error_warning; ?></div>
<?php } ?>

<script type="text/javascript" src="view/javascript/jquery/jquery.tipsy.js"></script>
<style>
.tipsy { padding: 5px; font-size: 10px; position: absolute; z-index: 100000; }
.tipsy-inner { padding: 5px 8px 4px 8px; background-color: black; color: white; max-width: 200px; text-align: center; }
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
<div class="box">
  <div class="left"></div>
  <div class="center"></div>
  <div class="right"></div>
  <div class="heading">
    <h1 style="background-image: url('view/image/product.png');">Shipping List</h1>
    <div class="buttons">
      <a id='package_print' class="button"><span>Print Julio</span></a>
      <!--a id='show_invoice' class="button"><span>Show Invoice</span></a-->
      <!--a id='ship_confirm' class="button"><span>Ship Confirm</span></a-->
      <!--a id='batch_print' class="button"><span>Print</span></a-->
      <!--a class="button invoice_sheet"><span>Print Invoice Sheet</span></a-->
    </div>
  </div>
  <div class="content">
    <form action="<?php echo $lnk_delete; ?>" method="post" enctype="multipart/form-data" id="form">
      <table class="list">
        <thead>
          <tr>
            <td width="1" style="text-align: center;">
              <input type="checkbox" onclick="$('input[name*=\'selected\']').attr('checked', this.checked);" /></td>
            <td class="center"><?php if ($sort == 'x.txid') { ?>
              <a href="<?php echo $sort_txid; ?>" class="<?php echo strtolower($order); ?>">TXID</a>
              <?php } else { ?>
              <a href="<?php echo $sort_txid; ?>">TXID</a>
              <?php } ?></td>
            <td class="center">Invoice.no</td>
            <td class="center"><?php if ($sort == 's.name') { ?>
              <a href="<?php echo $sort_store_name; ?>" class="<?php echo strtolower($order); ?>">STORE</a>
              <?php } else { ?>
              <a href="<?php echo $sort_store_name; ?>">STORE</a>
              <?php } ?></td>
            <td class="center">
              <?php if ($sort == 'x.ship_date') { ?>
              <a href="<?php echo $sort_ship_date; ?>" class="<?php echo strtolower($order); ?>">SHIP DATE</a>
              <?php } else { ?>
              <a href="<?php echo $sort_ship_date; ?>">SHIP DATE</a>
              <?php } ?>
            </td>
            <td class="center"><?php if ($sort == 'x.order_price') { ?>
              <a href="<?php echo $sort_order_price; ?>" class="<?php echo strtolower($order); ?>">TOTAL</a>
              <?php } else { ?>
              <a href="<?php echo $sort_order_price; ?>">TOTAL</a>
              <?php } ?></td>
            <td class="right">SHIP</td>

            <td class="center">App'ed</td>

            <td class="center">
              <?php if($sort == 'x.order_user') { ?>
              <a href="<?php echo $sort_order_user; ?>" class="<?php echo strtolower($order); ?>">REP</a>
              <?php } else { ?>
              <a href="<?php echo $sort_order_user; ?>">REP</a>
              <?php } ?>
            </td>
            <td class="right">HOLD</td>
            <td></td>
          </tr>
        </thead>
        <tbody>
          <tr class="filter">
            <td colspan=2>
              <input type="text" name="filter_txid" value="<?php echo $filter_txid; ?>"  style='width:150px;' />
            </td>
            <td class='center'>
              <input name='filter_invoice_no' value='<?php echo $filter_invoice_no; ?>' size='3' />
            </td>
            <td class='right'><input type="text" name="filter_store_name" value="<?php echo $filter_store_name; ?>" /></td>
            <td class='right'>
              <input type="text" name="filter_ship_date" class='date_pick' value="<?php echo $filter_ship_date; ?>" size='6' />
            </td>
            <td></td>
            <td class='center'>
              <select name="filter_shipped_yn">
                <option value="Y" <?php if('Y'==$filter_shipped_yn) echo 'selected'; ?>>Y</option>
                <option value="N" <?php if('N'==$filter_shipped_yn) echo 'selected'; ?>>N</option>
              </select>
            </td>

            <td></td>

            <td class='right'>
              <select name='filter_order_user'>
                <option value='' selected>---</option>
                <?php
                $aSales = $this->user->getSales();
                foreach($aSales as $row){
                  $rep = $row;
                  $selected = ( $filter_order_user == $rep ) ? 'selected' : '' ;
                  echo "<option value='$rep' $selected>$rep</option>";
                }
                ?>
              </select>
            </td>
            </td>
            <td></td>
            <td class="center"><a onclick="$.fn.filter();" class="button"><span>Filter</span></a></td>
          </tr>
          <?php
          if ($txs) { 
          ?>
          <?php 
          foreach($txs as $tx){
            $bgTR = '';
            if($tx['print_ship'] == true){
              $bgTR = 'style="background-color:#e9e9e9"';
            }
            $desc4tooltip = str_replace( "\n" , '&#013;', $tx['description'] );
            //$desc4tooltip = nl2br($tx['description']);
            //echo $desc4tooltip;
            $txid = $tx['txid'];
          ?>
          <tr <?php echo $bgTR ?>>
            <td style="text-align: center;"><?php if ($tx['selected']) { ?>
              <input type="checkbox" name="selected[]" value="<?php echo $tx['txid']; ?>" checked="checked" />
              <?php } else { ?>
              <input type="checkbox" name="selected[]" value="<?php echo $tx['txid']; ?>" />
              <?php } ?></td>
            <td class="center">
              <a href="index.php?route=invoice/order&mode=show&txid=<?php echo $tx['txid']; ?>" id='<?php echo $txid ?>' title="<?php echo $desc4tooltip ?>">
              <?php echo $tx['txid']; ?>
              </a>
            </td>
            <td class="center list_invoice_no"><?php echo $tx['invoice_no']; ?></td>
            <td class="center"><?php echo $tx['store_name']; ?></td>
            <td class="center"><?php echo $tx['ship_date']; ?></td>
            <td class="center"><?php echo $tx['order_price']; ?></td>
            <td class="center list_shipped_yn"><?php echo $tx['shipped_yn']; ?></td>
            <td class="center list_approve"><?php echo $tx['approved_user']; ?></td>
            <td class="center"><?php echo $tx['order_user']; ?></td>
            <td class="center"><?php if(trim($tx['status']) == '2'){ echo "<font color='red'>HOLD</font>"; } ?></td>
            <td class="center"><?php foreach ($tx['action'] as $action) { ?>
              <a href="index.php?route=invoice/order&mode=show&txid=<?php echo $tx['txid']; ?>" class='button'><span>Detail</span></a>
              <?php } ?></td>
          </tr>
          <script>
          /***
            $(function(){
              //todo. tipsy so flickering. suck.
              $('#<?php echo $txid ?>').tipsy();
            })
          ***/
          </script>
          <?php
          } // end foreach 
          }else{ 
          ?>
          <tr>
            <td class="center" colspan="12">All Shipped</td>
          </tr>
          <?php } ?>
        </tbody>
      </table>
    </form>
    <div class="pagination"><?php echo $pagination; ?></div>
  </div>
</div>

<style>
#ship_detail{
  position:absolute;
  top:200px;
  left:200px;
  width:400px;
  visibility:hidden;
  background-color:white;
  border:1px dotted blue;
  padding:10px;
}
</style>
<div id='ship_detail'>
  <form id='detailForm' action="index.php?route=invoice/list/batchApprove&token=<?php echo $token?>" method="post">
  <table>
    <tr>
      <td class=label>SHIP</td>
      <td class=context>
        <input type='hidden' name=txidList value=''>
        <select name=method[]>
          <option value='truck' selected>truck</option>
          <option value='ups'>ups</option>
          <option value='cod'>cod</option>
          <option value='visit'>visit</option>
          <option value='etc'>etc</option>
        </select>
      </td>
      <td class=label>DATE</td>
      <td class=context>
        <input type=text name=ship_date value='<?php echo date("Y-m-d"); ?>' style='width:40%' /></td></tr>
    <tr>
      <td class=label>LIFT</td><td class=context>
        <input type=text name=lift value='' size=5 /></td>
      <td class=label>COD</td><td class=context>
        <input type=text name=cod value='' size=5 />
        <p class=plus style='float:right;margin:0px;margin-right:2px;' />
        <input type='hidden' name='ship_user[]' value='<?php echo $this->user->getUserName(); ?>' /></td>
    </tr>
    <tr>
      <td colspan=4><textarea name='ship_comment' style='width:300px;height:100px;'/></textarea></td></tr>
    <tr>
      <td colspan=4>
        <input type=submit value='Confirm' />
        <input type=button value='Close' onclick="$('#ship_detail').css('visibility','hidden');"/>
      </td>
    </tr>
  </table>
  </form>
</div>

<!--iframe id='order_detail' name='order_detail' src='' width=500px height=400px></iframe-->

<script type="text/javascript">
$(document).ready(function(){
/*******
  $('#ship_confirm').click(function(){
    // set txidList for batch process
    var $ele_checkbox = $('form tbody input:checkbox:checked');
        $len = $ele_checkbox.length,
        $txidList = [];
    if($len > 0){
      $ele_checkbox.each(function(idx){
        // approval check
        var $pnt = $(this).parents('tr'),
            $invoice = $pnt.find('.list_invoice_no').html(),
            $approve = $pnt.find('.list_approve').html(),
            $shipped_yn = $pnt.find('.list_shipped_yn').html();
            $flag = true;
        if('approve' != $approve){
          alert('Get Approve with Sales Leader first : ' + $(this).val() );
          $flag = false;
        }
        if('' == $invoice){
          alert('Issue invoice Number first : ' + $(this).val() );
          $flag = false;
        }
        if('Y' == $shipped_yn){
          alert('Already Sent : ' + $(this).val() );
          $flag = false;
        }
        if($flag == true){
          $txidList.push($(this).val());
        }
      });
      $.ajax({
        type:'get',
        url:'index.php?route=invoice/list/shipConfirm',
        dataType:'text',
        data:'token=<?php echo $token; ?>&txidList=' + $txidList,
        success:function(text){
          $url = 'index.php?route=invoice/list&token=<?php echo $token; ?>';
          location.href = $url;
        }
      });
    }else{
      alert('check order list');
      return;
    }
  });
*******/

  $('#issue_no').click(function(){
    // set txidList for batch process
    var $ele_checkbox = $('form tbody input:checkbox:checked');
        $len = $ele_checkbox.length,
        $txidList = [];
    if($len > 0){
      $ele_checkbox.each(function(idx){
        // approval check
        var $pnt = $(this).parents('tr'),
            $invoice = $pnt.find('.list_invoice_no').html(),
            $approve = $pnt.find('.list_approve').html()
            $flag = true;
        if('' != $invoice){
          alert('Already Exist , Invoice Number : ' + $(this).val() );
          $flag = false;
        }
        if('approve' != $approve){
          alert('Get Approve with Sales Leader first : ' + $(this).val() );
          $flag = false;
        }
        if($flag == true){
          $txidList.push($(this).val());
        }
      });
      $.ajax({
        type:'get',
        url:'index.php?route=invoice/list/issueInvoiceNo',
        dataType:'text',
        data:'token=<?php echo $token; ?>&txidList=' + $txidList,
        success:function(text){
          $url = 'index.php?route=invoice/list&token=<?php echo $token; ?>';
          location.href = $url;
        }
      });
    }else{
      alert('check order list');
      return;
    }
  });

  // todo. we need make new form for Hulio , besso 201105
  $('#batch_print').click(function(){
    // set txidList for batch process
    var $ele_checkbox = $('form tbody input:checkbox:checked'),
        $len = $ele_checkbox.length,
        $txidList = [];
    $ele_checkbox.each(function(idx){
      var winHdr = null;
      var $txid = $(this).val(),
          $param = '&txid='+$txid,
          $name = 'name' + idx,
          $url='index.php?route=invoice/order&mode=show&token=<?php echo $token; ?>' + $param;
      winHdr = window.open($url,$name);
      /*/
      winHdr.onload = function(){
        winHdr.print();
        winHdr.close();
      }
      /*/
    });
  });

  // todo. we need make new form for Hulio , besso 201105
  $('#package_print').click(function(){
    // set txidList for batch process
    var $ele_checkbox = $('form tbody input:checkbox:checked'),
        $len = $ele_checkbox.length,
        $txidList = [];
    $ele_checkbox.each(function(idx,el){
      var winHdr = null;
      var $txid = $(this).val(),
          $param = '&txid=' + $txid + '&hulio=true',
          $name = 'name' + idx,
          $url='index.php?route=invoice/order&mode=show&token=<?php echo $token; ?>' + $param;

      $.getJSON('index.php?route=invoice/list/print_ship&txid='+$txid,function(data){
        if(data == true){
          $(el).parents('tr').css('background-color','#e9e9e9');
        }
      });
      winHdr = window.open($url,$name);
      winHdr.onload = function(){
        winHdr.print();
        winHdr.close();
      }
    });
  });
  
  // todo. we need make new form for Hulio , besso 201105
  $('.invoice_sheet').bind('click',function(e){
    // set txidList for batch process
    var $ele_checkbox = $('form tbody input:checkbox:checked'),
        $len = $ele_checkbox.length,
        $txidList = [];
    $ele_checkbox.each(function(idx){
      var winHdr = null;
      var $txid = $(this).val(),
          $param = '&txid=' + $txid,
          $name = 'name' + idx,
          $url='index.php?route=invoice/sheet&token=<?php echo $token; ?>' + $param;
      winHdr = window.open($url,$name);
      winHdr.onload = function(){
        winHdr.print();
        winHdr.close();
      }
    });
  });
  
  $.fn.filter = function(){
  	url = 'index.php?route=invoice/list&token=<?php echo $token; ?>';
  	var filter_txid = $('input[name=\'filter_txid\']').attr('value');
  	if(filter_txid){
  		url += '&filter_txid=' + encodeURIComponent(filter_txid);
  	}
  	var filter_invoice_no = $('input[name=\'filter_invoice_no\']').attr('value');
  	if (filter_invoice_no) {
  		url += '&filter_invoice_no=' + encodeURIComponent(filter_invoice_no);
  	}
  	var filter_store_name = $('input[name=\'filter_store_name\']').attr('value');
  	if (filter_store_name) {
  		url += '&filter_store_name=' + encodeURIComponent(filter_store_name);
  	}
  	var filter_ship_date = $('input[name=\'filter_ship_date\']').attr('value');
  	if (filter_ship_date) {
  		url += '&filter_ship_date=' + encodeURIComponent(filter_ship_date);
  	}
  	var filter_shipped_yn = $('select[name=\'filter_shipped_yn\']').attr('value');
  	if(filter_shipped_yn) {
  		url += '&filter_shipped_yn=' + encodeURIComponent(filter_shipped_yn);
  	}
  	var filter_order_user = $('select[name=\'filter_order_user\']').attr('value');
  	if(filter_order_user != '') {
  		url += '&filter_order_user=' + encodeURIComponent(filter_order_user);
  	}
  	location = url;
  }

  $('#form input').keydown(function(e) {
  	if (e.keyCode == 13) {
  		$.fn.filter();
  	}
  });
  
  // date picker binding
  $('#form').bind('focusin',function(event){
    var $tgt = $(event.target);
    if($tgt.is('input.date_pick')){
      //$(".date-pick").datePicker({startDate:'01/01/1996'});
      $(".date_pick").datePicker({
        clickInput:true,
        createButton:false,
        startDate:'2000-01-01'
      });
    }
  });
});
</script>
<?php echo $footer; ?>