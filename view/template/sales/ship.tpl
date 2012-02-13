          <table border='1' cellpadding="0" cellspacing="0">
            <tr>
              <td class='label' style='width:50px'>
                SHIP
              </td>
              <td class='context' style='width:50px'>
                <input type=text name='shipped_yn' value='<?php echo $shipped_yn; ?>' size='1' readonly />
              </td>
              <td class='label'>
                WEIGHT
              </td>
              <td class='context'>
                <input type='text' name='weight_sum' value='<?php echo $weight_sum; ?>' size='5' />
              </td>
              <td class='context' colspan='2'>
                <!--p class='del' style='float:left;margin:0px;margin-left:2px;'></p-->
                <input type='hidden' name='ship_id' value='' />
                <input type='hidden' name='ship_user' value='' />
                <select name='ship_method'>
                  <option value='ups' <?php if(strtolower($ship_method) == 'ups') echo "selected"; ?>>ups</option>
                  <option value='trk' <?php if(strtolower($ship_method) == 'trk') echo "selected"; ?>>truck</option>
                  <option value='del' <?php if(strtolower($ship_method) == 'del') echo "selected"; ?>>delivery</option>
                  <option value='pck' <?php if(strtolower($ship_method) == 'pck') echo "selected"; ?>>pickup</option>
                  <!--option value='ins' <?php if(strtolower($ship_method) == 'ins') echo "selected"; ?>>invoice only</option-->
                </select>
              </td>
            </tr>
            <tr>
              <td class='label' style='' colspan='2'>
                <select name='payment'>
                  <option value="n3" <?php if(strtolower($term) == 'n3') echo "selected"; ?>>Net30 </option>
                  <option value='cc' <?php if(strtolower($term) == 'cc') echo "selected"; ?>>cod-check</option>
                  <option value='cm' <?php if(strtolower($term) == 'cm') echo "selected"; ?>>cod-m.order</option>
                  <option value='cd' <?php if(strtolower($term) == 'cd') echo "selected"; ?>>card</option>
                  <option value='pp' <?php if(strtolower($term) == 'pp') echo "selected"; ?>>prepaid</option>
                  <option value='pd' <?php if(strtolower($term) == 'pd') echo "selected"; ?>>paid</option>
                </select>
              </td>
              <td class='label'>
                Cod/Lft
              </td>
              <td class='context'>
                <input type='number' name='ship_cod' value='<?php echo $ship_cod; ?>'   style='width:30px;'/>
                &nbsp;
                <input type='number' name='ship_lift' value='<?php echo $ship_lift; ?>' style='width:30px;'/>
              </td>
              <td class='label'>
                DATE
              </td>
              <td class='context'>
                <input type='text' class='date_pick' name='ship_appointment' value='<?php if($ship_appointment) { echo $ship_appointment; }else{ echo date('Y-m-d'); } ?>' size='8' />
                <!--p class='plus' style='float:right;margin:0px;margin-right:2px;' /-->
              </td>
          </tr>
          <tr>
            <td colspan=2 style='text-align:center;'>
              Shipto
            </td>
            <td colspan=4>
              <textarea name='shipto' style='width:250px;height:60px;'><?php echo str_replace('\n',chr(13),$shipto); ?></textarea>
            </td>
          </tr>
        </table>
        <!--span id='ship_history' class='small_btn'>Shipping History</span-->



<script>
$(document).ready(function(){
  var $el_ship = $('#ship'),
      $el_ship_method = $el_ship.find('select[name=ship_method]'),
      $el_ship_lift = $el_ship.find('input[name=ship_lift]'),
      $el_ship_cod  = $el_ship.find('input[name=ship_cod]'),
      $el_payment = $el_ship.find('select[name=payment]');
  
  $.fn.addAmountBalance = function($add){
    var $el_order_price = $('input[name="order_price"]'),
        $el_balance     = $('input[name="balance"]');

    $order_price = parseFloat($el_order_price.val()) + parseFloat($add);
    $order_price = $order_price.toFixed(2);
    $el_order_price.val( $order_price );

    $balance = parseFloat($el_order_price.val()) - parseFloat($('input[name=payed_sum]').val());
    $balance = $balance.toFixed(2);
    $el_balance.val( $balance );
    $('#floatmenu').find('input[name=float_order_price]').val($order_price);

    $.fn.showOthersInPayment($add);
  }

  $.fn.showOthersInPayment = function($add){
    $('p.added_amount').html( '(' + $add + ')' );
  }
  
  // change Lift value on change of method and update Amount/Balance
  $el_payment.bind('change',function(e){
    $this = $(this);
    $add = 0;
    $payment = $this.val();
    if( $el_ship_cod.val() > 0 ){
      alert('COD value already exist \'' + $el_ship_cod.val() + '\' , Edit COD forcely');
      $el_ship_cod.css('background-color','#00FFFF');
      $el_ship_cod.focus();
      return false;
    }
    if('cc' == $payment || 'cm' == $payment){
      $add = 10;
      $el_ship_cod.val($add);
      $.fn.addAmountBalance($add);
    }
  });

  // todo. thinking up JS event. i mapped only focusout for event-driven
  // exactly there are no way to remember just previous value so decided not to use change event
  // todo. reported sometimes error !
  // todo. IE focusing error , not focus well in sales items but cod still . so blocked all .select()
  $el_ship_cod
  .bind('focusin',function(){
    $prev = $(this).val();
    $(this).select();
  })
  .bind('keydown',function(e){
    if('13' == e.which){
      $existVal = $prev;
      $val = $(this).val();
      $ptn = /\d/;
      if( !$ptn.test($val) ){
        $(this).val('0'); return;
      }
      $add = parseFloat($val) - parseFloat($existVal);
      $add = $add.toFixed(2);
      $.fn.addAmountBalance($add);
      //$(this).select();
      $prev = $val;
    }
  })
  .bind('focusout',function(e){
    $existVal = $prev;
    $val = $(this).val();
    $ptn = /\d/;
    if( !$ptn.test($val) ){
        $(this).val('0'); return;
    }
    $add = parseFloat($val) - parseFloat($existVal);
    $add = $add.toFixed(2);
    $.fn.addAmountBalance($add);
    //$(this).select();
    $prev = $val;
  });

  $el_ship_lift
  .bind('focusin',function(){
    $prev = $(this).val();
    $(this).select();
  })
  .bind('keydown',function(e){
    if('13' == e.which){
      $existVal = $prev;
      $val = $(this).val();
      $ptn = /\d/;
      if( !$ptn.test($val) ){
        $(this).val('0'); return;
      }
      $add = parseFloat($val) - parseFloat($existVal);
      $add = $add.toFixed(2);
      $.fn.addAmountBalance($add);
      //$(this).select();
      $prev = $val;
    }
  })
  .bind('focusout',function(e){
    $existVal = $prev;
    $val = $(this).val();
    $ptn = /\d/;
    if( !$ptn.test($val) ){
      $(this).val('0'); return;
    }
    $add = parseFloat($val) - parseFloat($existVal);
    $add = $add.toFixed(2);
    $.fn.addAmountBalance($add);
    //$(this).select();
    $prev = $val;
  });
});
</script>