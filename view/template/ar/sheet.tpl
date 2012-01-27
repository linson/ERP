<?php
$server_name = getenv('SERVER_NAME');
$request_uri = getenv('REQUEST_URI');
$url = 'http://'.$server_name.$request_uri;
/* todo
Backorder - Not any B/O for overall system.
Damaged, Freegood - need to add to show that after check in Sales
, besso 201105 */
/* todo. move it to lib */
function add_date($givendate,$day=0,$mth=0,$yr=0){
  $givendate = $givendate. ' 00:00:00';
  $cd = strtotime($givendate);
  $newdate = date('Y-m-d', mktime(date('h',$cd),
                  date('i',$cd), date('s',$cd), date('m',$cd)+$mth,
                  date('d',$cd)+$day, date('Y',$cd)+$yr));
  return $newdate;
}
?>
<style>
  table td{
    font-size:20px;
  }
  #sheet{
    width:920px;
    min-height:1024px;
  }
  #top{
    width:100%;
  }
  #ubpinfo,#title{
    width:50%;
  }
  #ubpinfo{
    float:left;
  }
  #ubpinfo .title{
    font-size:26px;
    padding-left:0px;
    padding-bottom:10px;
  }
  #ubpinfo ul{
    padding-left:20px;
  }
  #ubpinfo li{
    list-style:none;
    padding-left:10px;
    font-size:20px;
  }
  #title{
    float:right;
    width:200px;
  }
  #title h1{
    text-align:right;
    padding-right:10px;
  }
  #title table{
    width:200px;
    text-align:center;
  }
  #billinfo{
    clear:both;
  }
  #billto{
    float:left;
    width:49%;
    border-collapse:collapse;
  }
  #billto td{
    border: 1px;
    border-style:solid;
  }
  #shipto{
    float:right;
    width:49%;
  }
  #billinfo ul{
    padding-left:20px;
  }
  #billinfo li{
    list-style:none;
    font-weight:bold;
  }
  #main{
    clear:both;
    padding-top:20px;
  }
  #main table{
    width:920px;
    margin-bottom:3px;
    border-collapse:collapse;
  }
  #main table td {
    text-align:center;
    border:1px;
    border-style:solid;
  }
  #main table.up{
    
  }
  #main table.center{
    height:900px;
  }
</style>


                  <option value="n3">Net30 </option>
                  <option value="cc">cod-check</option>
                  <option value="cm">cod-m.order</option>
                  <option value="cd">card</option>
                  <option value="pp">prepaid</option>
                  <option value="pd">paid</option>
                

<?php
  $last_credit = '';
  switch($payment){
    case 'n3':
      $last_credit = 'NET30';
      break;
    case 'cc':
      $last_credit = 'COD-Check';
      break;
    case 'cm':
      $last_credit = 'COD-M.Order';
      break;
    case 'cd':
      $last_credit = 'Credit Card';
      break;
    case 'pp':
      $last_credit = 'PREPAID';
      break;
  }
  //$this->log->aPrint( $finance );
?>
<div id='sheet'>
  <div id='top'>
    <div id='ubpinfo'>
      <ul>
        <li class='title'>Universal Beauty Products Inc.</li>
        <li>1200 Kirk Street</li>
        <li>Elk Grove Village, IL 60007</li>
        <li>TEL : 847-787-0182 / FAX : 847-787-0191</li>
        <li>TOLL FREE : 800-390-3338</li>
      </ul>
    </div>
    <div id='title'>
      <h1 id='hidden_print'>STATEMENT</h1>
      <table border=1 cellspacing=0 cellpading=1>
        <tr>
          <td>DATE</td>
          <!--td>INVOICE#</td-->
        </tr>
        <tr>
          <td><?php echo date('m/d/Y'); ?></td>
          <!--td><?php echo $invoice_no; ?></td-->
        </tr>
      </table>
    </div>
  </div>
  <?php
    $billto =<<<HTML
      <ul>
        <li>$store_name</li>
        <li>$address1</li>
        <li>$city , $state, $zipcode</li>
        <li>TEL : $phone1</li>
      </ul>
HTML;
  ?>
  <div id='billinfo'>
    <table id='billto' border='0' cellspacing=0 cellpading=1>
      <tr>
        <td style='padding-left:20px;'>BILL TO</td>
      </tr>
      <tr>
        <td>
          <?php echo $billto; ?>
        </td>
      </tr>
    </table>
  </div>
  
  <div id='main'>
    <table class='up' border=0 cellspacing=0 cellpading=1>
      <tr>
        <td style='width:500px;border:none;'> </td>
        <td>Terms</td>
        <td>Rep</td>
        <td>AmountDue</td>
      </tr>
      <tr>
        <td style='width:500px;border:none;'> </td>
        <td><?php echo $last_credit; ?></td>
        <td><?php echo $salesrep; ?></td>
        <td><?php echo $balance; ?></td>
      </tr>
    </table>

    <table class='center' border=0 cellspacing=0 cellpading=1>
      <tr style='height:20px;'>
        <td>Date</td>
        <td>Description</td>
        <td>Amount</td>
        <td>Balance</td>
      </tr>
      <?php
      foreach($finance as $row){
      ?>
      <tr style='height:20px;'>
        <td><?php echo $row['order_date']; ?></td>
        <td>desc</td>
        <td>Amount</td>
        <td>Balance</td>
      </tr>
      <?php
      }
      ?>
    </table>

    <table class='down' border=0 cellspacing=0 cellpading=1>
      <tr>
        <td>Current</td>
        <td>1-30 PAST DUE</td>
        <td>31-60 PAST DUE</td>
        <td>61-90 PAST DUE</td>
        <td>Over 90 PAST DUE</td>
        <td>Amount Due</td>
      </tr>
    </table>

  </div>
</div>
<script>
/***
$('hidden_print').click(function(e){
  $.ajax({
    type:'get',
    url:'index.php?route=invoice/sheet/print&token=<?php echo $token; ?>&url=<?php echo $url; ?>&txid=<?php echo $txid; ?>',
    dataType:'text',
    success:function(text){
    }
  });
});
***/
</script>