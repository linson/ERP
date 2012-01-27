<?php
$descLen = explode(chr(13),$description);
if( count($descLen) > 1 ){
    $descHeight = count( $descLen ) * 25;
    $descHeight = 'height:'.$descHeight.'px';
}
?>
          <table border='1' cellpadding="0" cellspacing="0">
            <tr>
              <td class='label'>Acc.No</td>
              <td class='context'>
                <input type='text' name='accountno' value='<?php echo $accountno; ?>' size='10' />
                <input type='hidden' name='salesrep' value='<?php echo $salesrep; ?>' />
                <input type='text' name='storetype' value='<?php echo $storetype; ?>' size='1' readonly />
                <a id='history_account'>
                  [H]
                </a>
              </td>
              <td class='label'>Biz Name</td>
              <td class='context'>
                <input type='hidden' name='store_id' value='<?php echo $store_id; ?>' />
                <input type='hidden' name='txid' value='<?php echo $txid; ?>' />
                <input type='hidden' name='ddl' value='<?php echo $ddl; ?>' />
                <input type='hidden' name='async' value='false' />
                <input type='hidden' name='mode' value='<?php echo $mode; ?>' />
                <input type='hidden' name='status' value='<?php echo $status; ?>' />
                <input type='text' name='store_name' value="<?php echo $store_name; ?>" style='15' />
              </td>
            </tr>
            <tr class='no_print_invoice'>
              <td colspan=2>
                <input type='text' name='address1' value='<?php echo $address1; ?>'  style='width:96%' />
              </td>
              <td class='context' colspan=2>
                <input type='text' name='city' value='<?php echo $city; ?>' style='width:36%' /> / 
                <input type='text' name='state' value='<?php echo $state; ?>' style='width:10%' /> / 
                <input type='text' name='zipcode' value='<?php echo $zipcode; ?>' style='width:24%' /> 
              </td>
            </tr>
            <tr class='no_print_invoice'>
              <td class='label'>
                O-date
              </td>
              <td class='context'>
                <input type='text' class='date_pick' name='order_date' value='<?php echo $order_date; ?>' />
              </td>
              <td class='label'>
                Ph/Fax
              </td>
              <td class='context'>
                <input type='text' name='phone1' value='<?php echo $phone1; ?>' style='width:51%' />
                / <input type='text' name='fax' value='<?php echo $fax; ?>'  style='width:30%' />
              </td>
            </tr>

            <!-- show store level dc -->
            <?php
            /**
            // todo. it's exception code , besso 201108
            if(isset($sales['AE St GEL'])){
              $gelCount = count($sales['AE St GEL']);
              if( $gelCount > 0 ){
                if( strpos(trim($description),'DAMAGE DISCOUNT') === false ){
                  $description .= chr(13);
                  $description .= "[ DAMAGE DISCOUNT ] : 2 % " . chr(13);
                  $description .= "[ SPECIAL DISCOUNT ] : 5 % " . chr(13);
                }
              }
            }
            **/

            if($store_dc != ''){
              $aDC = json_decode($store_dc);
              if( count($aDC) == 1) $aDC[1] = '0|';
//              $this->log->aPrint( $aDC ); exit;
              $i = 1;
              echo '<tr>';
              foreach($aDC as $k => $v){
                $aT1 = explode('|',$v);
                $dc = isset($aT1[0]) ? $aT1[0] : 0;
                $k  = isset($aT1[1]) ? $aT1[1] : '';

                if($i == 1) $dc1 = $dc;
                if($i == 2) $dc2 = $dc;

                /**
                // todo. not-necessary to show the store discount in order. move to invoice
                // description add tuning
                $add2Desc = '';
                if($description != '') $add2Desc .= chr(13);
                $add2Desc .= "[ Store Discount $i  ] $dc % $k";
                //$this->log->aPrint( $description ); $this->log->aPrint( $add2Desc ); exit;
                if( strpos(trim($description),trim($add2Desc)) === false ){
                  $description .= $add2Desc;
                }
                **/

                $css = 'border:2px red solid';
            ?>
              <td class='label'>
                DC . <?php echo $i; ?>
              </td>
              <td align='left' style='<?php if($dc > 0) echo $css; ?>'>
                <input type='text' name='dc<?php echo $i; ?>' value='<?php echo $dc; ?>' size=2/>% 
                <input type='text' name='dc<?php echo $i; ?>_desc' value='<?php echo $k; ?>' size=10/>
              </td>
            <?php
                $i++;
              } // foreach
              echo '</tr>';
            }else{
            ?>
            
            <tr class='no_print_invoice'>
              <td class='label'>
                DC . 1
              </td>
              <td align='left'>
                <input type='text' name='dc1' value='0' size=2/>% 
                <input type='text' name='dc1_desc' value='' size=10 />
              </td>
              <td class='label'>
                DC . 2
              </td>
              <td align='left'>
                <input type='text' name='dc2' value='0' size=2/>% 
                <input type='text' name='dc2_desc' value='' size=10 />
              </td>
            </tr>
            <?php
            }
            ?>
            <tr>
              <td colspan=4>
                <textarea name='description' style='min-height:50px;width:98%;<?php echo $descHeight; ?>;scroll-y:auto;'><?php echo $description; ?></textarea>
              </td>
            </tr>
          </table>
          <?php
          // todo. block on service. , besso-201103 
          if('update' != $ddl){
          ?>
          <!--span class='small_btn' id='findstore'>Find Store</span-->
          <?php
          }
          ?>
          <!--span class='small_btn'>Update Store</span-->
          <!--span id='googlemap' class='small_btn'>Google map</span-->
<script>
$('document').ready(function(){
  $('input[name=dc1],input[name=dc2]').bind('click',function(e){
    $this = $(this);
    $this.select();
  });

  $.fn.discount = function($total,$dc){
    $discount = $total * ( (100-$dc) / 100 );
    $discount = $discount.toFixed(2);
    return $discount;
  }
  
  /*
  store level discount
  event : before all submit X -> all input change event
  deprecated : should controll all each one.
  */

  $('input[name=dc1],input[name=dc2]').bind('change',function(e){
    $el_order_price = $('input[name=order_price]');
    if($el_order_price.val() >0){
      alert('You should set Store Discount before ordering');
      return false;
    }

    // Store Description 
    $added = '';
    $msg = '';

    $el_desc = $('textarea[name=description]');

    $dc1 = $('input[name=dc1]').val();
    $dc1_desc = $('input[name=dc1_desc]').val();
    if($dc1 > 0){
      $msg1 = '[ Store Discount 1 ] ' + $dc1 + ' % ' + $dc1_desc +'\n';
      $ptn1 = /(\[ Store Discount 1 \].+\n?)/;
      if( $el_desc.val().match($ptn1) )  $el_desc.val( $el_desc.val().replace($ptn1,'') );
      $added = $added + $msg1;
    }

    $dc2 = $('input[name=dc2]').val();
    $dc2_desc = $('input[name=dc2_desc]').val();
    if($dc2 > 0){
      $msg2 = '[ Store Discount 2 ] ' + $dc2 + ' % ' + $dc2_desc +'\n';
      $ptn2 = /(\[ Store Discount 2 \].+\n?)/;
      if( $el_desc.val().match($ptn2) )  $el_desc.val( $el_desc.val().replace($ptn2,'') );
      $added = $added + $msg2;
    }

    if($added != ''){
      if($el_desc.html() != ''){
        $el_desc.val( $added + $('textarea[name=description]').val() );
      }else{
        $el_desc.val( $added );
      }
    }
  });

  /***
  $.fn.storeDiscount = function(){
    $dc1 = $('input[name=dc1]').val();
    $dc2 = $('input[name=dc2]').val();
    $el_order_price = $('input[name=order_price]');
    $el_balance = $('input[name=balance]');
    $order_price = $el_order_price.val();
    
    if($dc1 > 0){
      $discounted1 = $.fn.discount($('input[name=order_price]').val(),$dc1);
      //$dc1_diff  = parseFloat($('input[name=order_price]').val() - $discounted1);
      //$dc1_diff = $dc1_diff.toFixed(2);
      $el_order_price.val($discounted1);
      $el_balance.val($discounted1);
    }
    if($dc2 > 0){
      $discounted2 = $.fn.discount($('input[name=order_price]').val(),$dc2);
      //$dc2_diff  = parseFloat($('input[name=order_price]').val() - $discounted2);
      //$dc2_diff = $dc2_diff.toFixed(2);
      $el_order_price.val($discounted2);
      $el_balance.val($discounted2);
    }
  }
  ***/

  /*
  $('textarea').autoResize({
    // On resize:
    onResize : function() {
        $(this).css({
          opacity:0.8
        });
    },
    // After resize:
    animateCallback : function() {
        $(this).css({
          opacity:1
        });
    },
    // Quite slow animation:
    animateDuration : 300,
    // More extra space:
    extraSpace :40
  });
  */
  
  /*
  $('textarea[name=description]')
  .css('min-height','50px')
  .css('overflow-y','auto');
  */
  
  $('#history_account').bind('click',function(e){
    accountno = $('#storeinfo').find('input[name=accountno]').val();
    url = 'index.php?route=report/account&accountno=' + accountno;
    window.open(url);
  });
});
</script>