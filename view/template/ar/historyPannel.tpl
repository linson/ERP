<?php
//echo date('Ymdhis');
?>

<style>
#historyPackage{
  width:500px;
  background-color:white;
}
</style>
<table id='historyPackage' border='1'>
  <thead>
  <tr style="background-color:#e2e2e2;">
    <td>TXID</td>
    <td>Bankaccount</td>
    <td>Method</td>
    <td>Date</td>
    <td>Paid</td>
    <td>Chk.no</td>
    <td>Rep</td>
  </tr>
  </thead>

  <tbody>
  <?php
  foreach($data as $row){
    $y = substr($row['pay_date'],0,4);
    $m = substr($row['pay_date'],4,2);
    $d = substr($row['pay_date'],6,2);
    $h = substr($row['pay_date'],8,2);
    $changeDate = $y . '-' . $m . '-' . $d . '-' . $h;
  ?>
  <tr>
    <td><?php echo $row['txid']; ?></td>
    <td><?php echo $row['bankaccount']; ?></td>
    <td><?php echo $row['pay_method']; ?></td>
    <td><?php echo $changeDate; ?></td>
    <td><?php echo $row['pay_price']; ?></td>
    <td><?php echo $row['pay_num']; ?></td>
    <td><?php echo $row['pay_user']; ?></td>
  </tr>
  <?php
  }
  ?>
  </tbody>
</table>
<script>
$('#historyPackage').click(function(e){
  $('#detail').css('visibility','hidden');
});
</script>