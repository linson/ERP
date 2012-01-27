<?php
//echo date('Ymdhis');
?>

<style>
#historyPackage{
  width:600px;
  background-color:white;
}
</style>
<table id='historyPackage' border='1'>
  <thead>
  <tr style="background-color:#e2e2e2;">
    <td>Code</td>
    <td>Price</td>
    <td>Total</td>
    <td>Change</td>
    <td>date</td>
    <td>company</td>
    <td>Rep</td>
    <td>Comment</td>
    <td>product</td>
  </tr>
  </thead>

  <tbody>
  <?php
  foreach($data as $row){
    $y = substr($row['up_date'],0,4);
    $m = substr($row['up_date'],4,2);
    $d = substr($row['up_date'],6,2);
    $h = substr($row['up_date'],8,2);
    $changeDate = $y . '-' . $m . '-' . $d . '-' . $h;
  ?>
  <tr>
    <td><?php echo $row['code']; ?></td>
    <td><?php echo $row['price']; ?></td>
    <td><?php echo $row['quantity']; ?></td>
    <td><?php echo $row['diff']; ?></td>
    <td><?php echo $changeDate; ?></td>
    <td><?php echo $row['company']; ?></td>
    <td><?php echo $row['rep']; ?></td>
    <td><?php echo $row['comment']; ?></td>
    <td><?php echo $row['model']; ?></td>
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