<style>
#finance{
  width:720px;
}
#finance thead tr td{
  border: 1px dotted black;
  text-align: center;
}
#finance tbody tr td{
  text-align: center;
}
#finance .mod{
  background-color:#FFCCFF;'
}
</style>
<table id="finance" border="0">
  <thead>
  <tr>
    <td colspan=8 style='text-align:left;border:0;'>
      Bank Account : 
      <select name='bankaccount'>
        <option>123456789</option>
        <option>987654321</option>
      </select>
    </td>
  </tr>
  <tr>
    <td>TXID</td>
    <td>Order Date</td>
    <td>Due</td>
    <td>Order</td>
    <td>Method</td>
    <td>Memo</td>
    <td>Paid</td>
    <td>Balance</td>
  </tr>
  </thead>
  <tbody>
<?php 
if(!isset($finance)) echo 'No Transaction <br/>';
if(isset($finance)){
//$this->log->aPrint( $finance );
foreach($finance as $idx => $row){
  //$this->log->aPrint( $row );
  $method = trim($row['pay_method']);
  //todo. last row
  $css = '';
  if($idx == count($finance)-1 ){
    $css = "class=mod";
  }
?>
  <tr>
    <td>
      <a href="index.php?route=ar/order&token=<?php echo $txid; ?>&txid=<?php echo $row['txid']; ?>" target='new'  class="txid">
      <?php echo $row['txid']; ?>
      </a>
    </td>
    <td>
      <?php echo $row['order_date']; ?>
    </td>
    <td>
      <?php echo $row['order_diff']; ?>
    </td>
    <td class="order">
      <a class='detail_pay'>
      <?php echo $row['order_price']; ?>
      </a>
    </td>
    <td>
      <select name="method">
        <option value="check"  <?php if($method == 'check')  echo 'selected'; ?>>Check</option>
        <option value="morder" <?php if($method == 'morder') echo 'selected'; ?>>M.order</option>
        <option value="cash"   <?php if($method == 'cash')   echo 'selected'; ?>>Cash</option>
        <option value="credit" <?php if($method == 'credit') echo 'selected'; ?>>Credit Card</option>
        <option value="bounce" <?php if($method == 'bounce') echo "selected"; ?>>bounce</option>
      </select>
    </td>
    <td>
      <input name="pay_num" value="<?php echo $row['pay_num']; ?>" size="20" type="text" />
    </td>
    <td>
      <input name="paid" value="<?php echo $row['payed_sum']; ?>" size="5" type="number" <?php echo $css; ?>>
    </td>
    <td class="balance" style='color:red;'>
      <?php echo $row['balance']; ?>
    </td>
  </tr>
<?php 
} //foreach
} //if
?>
  </tbody>
</table>

<style>
#detail{
  position : absolute;
  top: 100px;
  left: 100px;
  visibility:hidden;
  border: 1px dotted green;
  z-index:2;
}
</style>
<div id='detail'></div>

<script>
$('#finance').bind('click',function(e){
  // todo. IE dont support trim(), add it
  if(typeof String.prototype.trim !== 'function'){   
    String.prototype.trim = function(){     
      return this.replace(/^\s+|\s+$/g, '');    
    }
  }
  $tgt = $(e.target);
  if( $tgt.is('input[name=paid]') ){
    $tgt.select();
  }
  if($tgt.is('.detail_pay')){
    $prt = $tgt.parents('tr');
    $el_txid = $prt.find('.txid');
    $txid    = $el_txid.html().trim();
    $.ajax({
      type:'get',
      url:'index.php?route=ar/detail/callHistoryPannel',
      dataType:'html',
      data:'token=<?php echo $token; ?>&txid=' + $txid,
      success:function(html){
        $imgCss = {
          'visibility':'visible',
          'top':100,
          'left':100,
          'background-color':'white',
          'text-align':'center',
          'z-index':99
        }
        $('#detail').css($imgCss);
        $('#detail').html(html);
        // $('#detail').draggable();
      }
    });
  }
});

$('#finance')
.bind('focusin',function(e){
  // set paid before transaction
  $tgt = $(e.target);
  if( $tgt.is('input.mod')){
    $_paid = $tgt.val();
    $_memo = $tgt.parents('tr').find('input[name=pay_num]').val();
    $_method = $tgt.parents('tr').find('select[name=method]').val();
  }
  if( $tgt.is('input[name=pay_num]')){
    $tgt.select();
  }
})
.bind('keydown',function(e){
  $tgt = $(e.target);
  $bankaccount = $('select[name=bankaccount]').val();

  //if( $tgt.is('input[name=paid]') && e.keyCode == '13' ){
  if( $tgt.is('input.mod') && e.keyCode == '13' ){
//console.log('tgt is input.mod');
    var $row = $('#finance tbody').children('tr'),
        $paid_diff = parseFloat($tgt.val()) - parseFloat($_paid);
    $paid_diff = $paid_diff.toFixed(2);
    ////console.log($paid_diff);;
//console.log($paid_diff +' before process');
    // initialize target's value
    if($_method == 'bounce' && $paid_diff >= 0){
      alert('input minus value(-) under bounce');
      return false;
    }

    /*** PROCESS
    1. check input paid is larger than balance
    2. check if idx row has balance or not, if not next
    3. minus paid - balance if balance exist
      3-1. if paid - balance > 0 , next loop
      3-2. and set that row balance = 0
    4. if remain balance > 0 . stop
    ***/
    if($paid_diff > 0){
      $tgt.val(0);
      for($i=0;$i<$row.length;$i++){
        var $currentRow = $($row[$i]),
            $el_txid    = $currentRow.find('a.txid'),
            $el_order   = $currentRow.find('.detail_pay'),
            $el_balance = $currentRow.find('td.balance'),
            $el_method  = $currentRow.find('select[name=method]'),
            $el_pay_num = $currentRow.find('input[name=pay_num]'),
            $el_paid    = $currentRow.find('input[name=paid]');
        $txid    = $el_txid.html().trim();
        $order   = $el_order.html().trim();
        $balance = $el_balance.html().trim();
        //$method  = $el_method.val();
        $method = $_method;
        //$pay_num = $el_pay_num.val();
        $pay_num = $_memo;
        //debugger;
        $paid = $el_paid.val();

        // check the changed value well
        if($balance == 0) continue;
        
        // if paid is larger than the row balance, all balance is paid
        if( parseFloat($paid_diff) > parseFloat($balance)){
          ////console.log($paid_diff + 'diff is larger than balance' + $balance);
          $el_balance.html(0);
          $paid = parseFloat($paid) + parseFloat($balance);
          $paid = $paid.toFixed(2);
          $el_paid.val($paid);
          $paid_diff = parseFloat($paid_diff) - parseFloat($balance);
          $paid_diff = $paid_diff.toFixed(2);
          $tgt.select();
          // if last row 
          if($i == $row.length-1 ){
            $el_balance.html( -1 * $paid_diff );
            $hdr = $.fn.updateFinance($txid,$paid,-1 * $paid_diff,$method,$pay_num,$bankaccount);
            $hdr.success(function(){
              location.href = "index.php?route=ar/detail&store_id=<?php echo $store_id; ?>";
            });
            break;
          }else{
            $.fn.updateFinance($txid,$balance,'0',$method,$pay_num,$bankaccount);
            //debugger;
            continue;
          }
        }else{
          ////console.log('diff is smaller than balance : ' + $balance);
          //alert($balance);
          $paid = parseFloat($paid_diff) + parseFloat($_paid);
          $paid = $paid.toFixed(2);
          $el_paid.val($paid);
          $balance = parseFloat($balance) - parseFloat($paid_diff);
          $balance = $balance.toFixed(2);
          $el_balance.html($balance);
          $tgt.parents('tr').find('input[name=pay_num]').focus();
          $hdr = $.fn.updateFinance($txid,$paid_diff,$balance,$method,$pay_num,$bankaccount);
          $hdr.success(function(){
            location.href = "index.php?route=ar/detail&store_id=<?php echo $store_id; ?>";
          });
          $paid_diff = 0;
          break;
        }
      } // for each
    }else{  // bounce !!
//console.log('paid_diff < 0 start : ' + $paid_diff);
      // should reverse loop
      $paid_diff = $tgt.val();
      for($i=$row.length-1;$i>=0;$i--){
        var $currentRow = $($row[$i]),
            $el_txid    = $currentRow.find('a.txid'),
            $el_order   = $currentRow.find('.detail_pay'),
            $el_balance = $currentRow.find('td.balance'),
            $el_method  = $currentRow.find('select[name=method]'),
            $el_pay_num = $currentRow.find('input[name=pay_num]'),
            $el_paid    = $currentRow.find('input[name=paid]');
        $txid    = $el_txid.html().trim();
        $order   = $el_order.html().trim();
        $balance = $el_balance.html().trim();
        //$method  = $el_method.val();
        $method = $_method;
        //$pay_num = $el_pay_num.val();
        $pay_num = $_memo;
        $paid = $el_paid.val();
        
        // if diff is 0, we dont need to calculate that row
        if($paid_diff == 0 ){
          continue;
        }
        
        //todo. we have one more business bug
        //todo. if some rollback over the sum(paid), the remain will be disappeared !! -0-
        
        // if remain balance < 0, we need to add the balance value with diff
        if( parseFloat($balance) < 0 ){
          $paid_diff = parseFloat($paid_diff) - parseFloat($balance);
          $paid_diff = $paid_diff.toFixed(2);
        }
        // todo. check it!
        if($i == $row.length-1) $paid = $_paid;
        if( parseFloat($paid_diff) * -1 > parseFloat($paid) ){
          if( $paid == 0 ) continue;
          
          if($el_paid.is('input.mod'))  $paid = $_paid;
          $diff = -1 * parseFloat($paid) + parseFloat($balance);
          $diff = $diff.toFixed(2);
          $paid_diff = parseFloat($paid_diff) + parseFloat($paid);
          $paid_diff = $paid_diff.toFixed(2);
          $el_paid.val(0);
          $balance = parseFloat($order);
          $el_balance.html($balance);

          $hdr = $.fn.updateFinance($txid, parseFloat($paid) * -1 ,$order,$method,$pay_num,$bankaccount,$diff);
          
          if($i == 0){
            if( $paid_diff > 0 ){
              // insert new dummy new order
              // todo. if rollback amount is larger than DB sum, now we lose that remain data
            }
            $hdr.success(function(){
              // call new ajax for insert dummy txid
              if($_method == 'bounce'){
                $bouncehdr = $.fn.insertFinance($txid,$pay_num);
                $bouncehdr.success(function(e){
                  location.href = "index.php?route=ar/detail&store_id=<?php echo $store_id; ?>";
                });
              }
              location.href = "index.php?route=ar/detail&store_id=<?php echo $store_id; ?>";
              //debugger;
            });
            break;
          }else{
            continue;
          }
        }else{
//debugger;
//console.log('bounce task break area start');
          if($balance > 0){
            $paid = parseFloat($paid) + parseFloat($paid_diff);
          }else{
            $paid = parseFloat($paid) + parseFloat($paid_diff) + (parseFloat($balance) * 1) ;
          }
          $paid = $paid.toFixed(2);
          $el_paid.val($paid);
          $balance = parseFloat($balance) + ( parseFloat($paid_diff) * -1 );
          $balance = $balance.toFixed(2);
          $el_balance.html($balance);
          $diff = parseFloat($paid_diff);
          $diff = $diff.toFixed(2);

          $hdr = $.fn.updateFinance($txid,$diff,$balance,$method,$pay_num,$bankaccount,$diff);
          $hdr.success(function(){
            // call new ajax for insert dummy txid
            if($_method == 'bounce'){
               $bouncehdr = $.fn.insertFinance($txid,$pay_num);
               $bouncehdr.success(function(e){
                 location.href = "index.php?route=ar/detail&store_id=<?php echo $store_id; ?>";
               });
            }
            location.href = "index.php?route=ar/detail&store_id=<?php echo $store_id; ?>";
          });
          $paid_diff = 0;

          break;
        }
      } // forloop

    }
    //setTimeout(function(){      location.href = "index.php?route=ar/detail&token=<?php echo $txid; ?>&store_id=<?php echo $store_id; ?>";    },1000);
  }
});

$.fn.insertFinance = function($txid,$memo){
  $hdr = $.ajax({
    type:'get',
    url:'index.php?route=ar/detail/insertFinance&token=<?php echo $token; ?>&txid=' + $txid + '&store_id=<?php echo $store_id ?>&memo=' + $memo,
    dataType:'html'
  });
  return $hdr;
}

$.fn.updateFinance = function($txid,$paid,$balance,$method,$pay_num,$bankaccount,$diff){
  $hdr = $.ajax({
    type:'get',
    url:'index.php?route=ar/detail/updateFinance',
    data: 'txid=' + $txid + '&paid=' + $paid + '&method=' + $method + '&pay_num=' + encodeURIComponent($pay_num) + '&balance=' + $balance + '&bankaccount=' + $bankaccount + '&diff=' + $diff,
    dataType:'html'
  });
  return $hdr;
}
</script>