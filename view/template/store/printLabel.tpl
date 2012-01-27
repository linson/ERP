<style>
  table.main{
    width:660px;
    margin-bottom:3px;
    border-collapse:collapse;
  }
  table.main td{
    text-align:center;
    border:2px;
    border-style:solid;
    font-size: 36px;
  }
  table.main td.label{
    width:40%;
    /* background-color:#e9e9e9; */
  }
  table.main td.context{
    width:60%;
    font-weight:bold;
  }

  table.tail{
    margin-left:360px;
    width:300px;
    margin-bottom:3px;
    border-collapse:collapse;
  }
  table.tail td{
    text-align:center;
    border:2px;
    border-style:solid;
    font-size: 24px;
  }
  table.tail td.label{
    width:40%;
  }
  table.tail td.context{
    width:60%;
  }
</style>
<?php
foreach($stores as $store){
$nnn = 'Seven miles discount';
//$this->log->aPrint( $store );
?>
<table class='main' border=0 cellspacing=0 cellpading=1>
  <tr>
    <td class='label'style='font-size:24px;'>Acct NO.</td>
    <td class='context' colspan='3'>
    <?php echo $store['accountno'] ?>
    </td>
  </tr>
  <tr>
    <td class='context' colspan='4' style='align:left;'>
      <span style='font-size:64px;'><?php echo $store['name'] ?></span><br>
      <?php echo $store['address1'] ?> <br>
      <?php echo $store['city'] ?>
      <?php echo $store['state'] ?>
      <?php echo $store['zipcode'] ?>
    </td>
  </tr>
  <tr>
    <td class='label'style='font-size:24px;'>TEL.</td>
    <td class='context' colspan='3' style='background-color:white;font-size:24px;'><?php echo $store['phone1'] ?></td>
  </tr>
   <tr>
    <td class='label'style='font-size:24px;'>FAX.</td>
    <td class='context' colspan='3' style='background-color:white;font-size:24px;'>
    <?php echo $store['fax'] ?></td>
  </tr>
  <tr>
    <td class='label' style='font-size:24px;'>CONTACT PERSON</td>
    <td class='context' colspan='3' style='background-color:white;font-size:24px;'><?php echo $store['owner'] ?></td>
  </tr>
</table>
<?php
}
?>

<br><br>

<?php
foreach($stores as $store){
?>

<table class='tail' border=0 cellspacing=0 cellpading=1>
  <tr>
    <td class='label'><?php echo $store['accountno'] ?></td>
    <td class='context' style='font-size:22px;'><?php echo substr($store['name'],0,12) ?></td>
  </tr>
</table>
<?php
}
?>

<script>
window.print();window.close();
</script>