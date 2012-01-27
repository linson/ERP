<style>
#paidSum{
  border:1px dotted peru;
  width:100%;
  margin-bottom:10px;
}
#paidSum tr{
  height:25px;
}
#paidSum td{
  padding-left:20px;
}
.detailSum{
  width:350px;
  float:left;
  padding-bottom:10px;
}
.ttl{
  font-weight:bold;
  text-align:left;
  padding-left:10px;
  font-size:12px;
  background-color:#eeeeee;
  height:20px;
}
</style>
<table id='paidSum' border='0' cellpadding="0" cellspacing="0">
  <tr>
    <td class='left'>
      Total : $ <?php echo $store_ar_total['tot_order']; ?> / 
      <?php echo $store_ar_total['count']; ?> Order
    </td>
    <td class='left'>
      Paid :<?php echo $store_ar_total['tot_payed']; ?> 
    </td>
    <td class='left'>
      Balance : <font color='red'><b><?php echo $store_ar_total['balance']; ?></b></font>
    </td>
  </tr>
</table>
<div>
<table class='detailSum'>
  <?php
  if(isset($store_history)){
  $a30 = $a60 = $a90 = $a120 = array();
    foreach($store_history as $k => $history){
      if($history['order_diff'] <= 30){
        $history_title = 'less 30';
        $a30[$k] = $history;
      }else if($history['order_diff'] > 30 && $history['order_diff'] <= 60 ){
        $history_title = '30 - 60';
        $a60[$k] = $history;
      }else if($history['order_diff'] > 60 && $history['order_diff'] <= 90 ){
        $history_title = '60 - 90';
        $a90[$k] = $history;
      }else if($history['order_diff'] > 90){
        $history_title = 'over 90';
        $a120[$k] = $history;
      }else{
        echo 'not in scope, weird, call to IT team';
        exit;
      }
    }
  ?>
  <tr>
    <td colspan=4 class='ttl'>Less 30</td>
  </tr>
  <?php
  foreach($a30 as $k => $h){
  ?>
  <tr>
    <td colspan=4>
      <table border=0 cellpadding="0" cellspacing="0">
        <tr>
          <td width=35%>
            <a href='index.php?route=sales/order&token=<?php echo $this->session->data['token']; ?>&txid=<?php echo $k; ?>' >
            <?php echo $k; ?></a>:
          </td>
          <td>
            <?php echo substr($h['order_date'],2); ?>
            ( <?php echo $h['order_price']; ?> =
            <?php echo $h['payed_sum']; ?> +
            <font color=red><b><?php echo $h['balance']; ?></b></font> ) 
            +<?php echo $h['order_diff']; ?> D
          </td>
        </tr>
        <?php 
        if(count($h['pay']) >0){
          foreach($h['pay'] as $hPay){
        ?>
        <?php 
        if($hPay['pay_price']){
        ?> 
        <tr>
          <td></td>
          <td>
            <?php echo substr($hPay['pay_date'],2); ?>&nbsp;&nbsp;
            <?php echo "Paid : ".$hPay['pay_price']." :: +".$hPay['pay_diff']." D"; 
            ?>
          </td>
        </tr>
        <?php } ?>
        <?php
          } // for
        } // if
        ?>
      </table>
    </td>
  </tr>
  <?php
  } // foreach
  ?>
</table>
<table class='detailSum'>
  <tr>
    <td colspan=4 class='ttl'>30 - 60</td>
  </tr>
  <?php
  foreach($a60 as $k => $h){
  ?>
  <tr>
    <td colspan=4>
      <table border=0 cellpadding="0" cellspacing="0">
        <tr>
          <td width=35%>
            <a href='index.php?route=sales/order&token=<?php echo $this->session->data['token']; ?>&txid=<?php echo $k; ?>' >
            <?php echo $k; ?></a>:
          </td>
          <td>
            <?php echo $h['order_date']; ?>
            ( <?php echo $h['order_price']; ?> =
            <?php echo $h['payed_sum']; ?> +
            <font color=red><b><?php echo $h['balance']; ?></b></font> ) 
            +<?php echo $h['order_diff']; ?> day
          </td>
        </tr>
        <?php 
        if(count($h['pay']) >0){
          foreach($h['pay'] as $hPay){
        ?>
        <?php 
        if($hPay['pay_price']){
        ?> 
        <tr>
          <td></td>
          <td>
            <?php echo substr($hPay['pay_date'],2); ?>&nbsp;&nbsp;
            <?php echo "Paid : ".$hPay['pay_price']." :: +".$hPay['pay_diff']." D"; 
            ?>
          </td>
        </tr>
        <?php } ?>

        <?php
          } // for
        } // if
        ?>
      </table>
    </td>
  </tr>
  <?php
  } // foreach
  ?>

  <tr>
    <td colspan=4 class='ttl'>60 - 90</td>
  </tr>
  <?php
  foreach($a90 as $k => $h){
  ?>
  <tr>
    <td colspan=4>
      <table border=0 cellpadding="0" cellspacing="0">
        <tr>
          <td width=35%>
            <a href='index.php?route=sales//order&token=<?php echo $this->session->data['token']; ?>&txid=<?php echo $k; ?>' >
            <?php echo $k; ?></a>:
          </td>
          <td>
            <?php echo $h['order_date']; ?>
            ( <?php echo $h['order_price']; ?> =
            <?php echo $h['payed_sum']; ?> +
            <font color=red><b><?php echo $h['balance']; ?></b></font> ) 
            +<?php echo $h['order_diff']; ?> day
          </td>
        </tr>
        <?php 
        if(count($h['pay']) >0){
          foreach($h['pay'] as $hPay){
        ?>
        <?php 
        if($hPay['pay_price']){
        ?> 
        <tr>
          <td></td>
          <td>
            <?php echo substr($hPay['pay_date'],2); ?>&nbsp;&nbsp;
            <?php echo "Paid : ".$hPay['pay_price']." :: +".$hPay['pay_diff']." D"; 
            ?>
          </td>
        </tr>
        <?php } ?>

        <?php
          } // for
        } // if
        ?>
      </table>
    </td>
  </tr>
  <?php
  } // foreach
  ?>
  <tr>
    <td colspan=4 class='ttl'>Over 90</td>
  </tr>
  <?php
  foreach($a120 as $k => $h){
  ?>
  <tr>
    <td colspan=4>
      <table border=0 cellpadding="0" cellspacing="0">
        <tr>
          <td width=35%>
            <a href='index.php?route=sales/order&token=<?php echo $this->session->data['token']; ?>&txid=<?php echo $k; ?>' >
            <?php echo $k; ?></a>:
          </td>
          <td>
            <?php echo $h['order_date']; ?>
            ( <?php echo $h['order_price']; ?> =
            <?php echo $h['payed_sum']; ?> +
            <font color=red><b><?php echo $h['balance']; ?></b></font> ) 
            +<?php echo $h['order_diff']; ?> day
          </td>
        </tr>
        <?php 
        if(count($h['pay']) >0){
          foreach($h['pay'] as $hPay){
        ?>
        <?php 
        if($hPay['pay_price']){
        ?> 
        <tr>
          <td></td>
          <td>
            <?php echo substr($hPay['pay_date'],2); ?>&nbsp;&nbsp;
            <?php echo "Paid : ".$hPay['pay_price']." :: +".$hPay['pay_diff']." D"; 
            ?>
          </td>
        </tr>
        <?php } ?>

        <?php
          } // for
        } // if
        ?>
      </table>
    </td>
  </tr>
  <?php
  } // foreach
  } // end for
  ?>
</table>
</div>
