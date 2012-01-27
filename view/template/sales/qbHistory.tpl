<?php
if(!isset($store_history)){
  echo 'No AR history';
}else{
?>
<table style='width:180px'>
  <?php if($store_history['current'] > 0){ ?>
  <tr><td> Current : </td><td style='color:red'><?php echo $this->util->formatMoney($store_history['current']); ?></td></tr>
  <?php } ?>
  
  <?php if($store_history['c30'] > 0){ ?>
  <tr><td> 30 : </td>     <td style='color:red'><?php echo $this->util->formatMoney($store_history['c30']); ?></td></tr>
  <?php } ?>
  
  <?php if($store_history['c60'] > 0){ ?>
  <tr><td> 60 : </td>     <td style='color:red'><?php echo $this->util->formatMoney($store_history['c60']); ?></td></tr>
  <?php } ?>
    
  <?php if($store_history['c90'] > 0){ ?>
  <tr><td> 90 : </td>     <td style='color:red'><?php echo $this->util->formatMoney($store_history['c90']); ?></td></tr>
  <?php } ?>
  
  <?php if($store_history['c120'] > 0){ ?>
  <tr><td> 120 : </td>    <td style='color:red'><?php echo $this->util->formatMoney($store_history['c120']); ?></td></tr>
  <?php } ?>

  <tr><td> total : </td>  <td style='color:red;font-weight:bold;'><?php echo $this->util->formatMoney($store_history['total']); ?></td></tr>

  
</table>
<?php
}
?>