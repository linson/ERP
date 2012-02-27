<?php
// todo. manually subtract by ship_code and ship_lift
$freegood_percent = 0;
if($order_price > 0){
  $freegood_percent = ( $freegood_amount / ( $order_price - $ship_cod - $ship_lift ) ) * 100 ;
  $freegood_percent = round( $freegood_percent , 2);
}
?>
<div id='payment'>
  <table>
    <tr>
      <td class='label'>
        Amount
      </td>
      <td class='context'>
        <input type='text' name='order_price' value='<?php echo $order_price; ?>' size=7/>
        <!--p class='added_amount' style='color:red;display:inline;'>
        <?php
          // plus add'ed value ( lift / cod )
          //$add = $ship_cod + $ship_lift;
          //if($add > 0) echo '(' . $add . ')';
        ?>
        </p-->
      </td>
      <td class='label no_print_invoice'>
        Promo
      </td>
      <td class='context no_print_invoice'>
        <?php
        if( isset($sales) ){
        $aLast = end($sales); 
        ?>
        <input type='text' name='promotion_sum' value='<?php echo $aLast[count($aLast)-1]['promotion_sum']; ?>' size=6 />
        (<?php echo round($aLast[count($aLast)-1]['promotion_sum']/$order_price*100,1); ?> %)
        <!-- use later -->
        <input type='hidden' name='payed_sum' value='<?php echo $payed_sum; ?>' size=8 />
        <?php
        }
        ?>
      </td>
      <td class='label no_print_invoice'>
        Damage
      </td>
      <td class='context no_print_invoice'>
        <?php
        if( isset($sales) ){
        ?>
        <input type='text' name='damage_sum' value='<?php echo $aLast[count($aLast)-1]['damage_sum']; ?>' size=6 />
        (<?php echo round($aLast[count($aLast)-1]['damage_sum']/$order_price*100,1); ?> %)
        <!-- use later -->
        <input type='hidden' name='balance' value='<?php echo $balance; ?>' size=8 style='background-color:yellow' />
        <?php
        }
        ?>
      </td>
      <td class='label'>
        Free
      </td>
      <td class='context'>
        <input type=text id='freegood_amount' value='<?php echo $freegood_amount; ?>' size=5 readonly />
      </td>
      <td class='label'>
        Percent
      </td>
      <td class='context'>
        <input type=text id='freegood_percent' value='<?php echo $freegood_percent; ?>' readonly style='<?php if($freegood_percent > 10) echo "color:red;"?>' size=5 />
      </td>
    </tr>
  </table>
</div>
