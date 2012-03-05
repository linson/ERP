<?php
$server_name = getenv('SERVER_NAME');
$request_uri = getenv('REQUEST_URI');
$url = 'http://'.$server_name.$request_uri;

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
  #metainfo{
    margin-top:20px;
    width:100%;
  }
  #metainfo td{
    text-align:center;
  }
  #detail{
    margin-top:20px;
    width:100%;
  }
  #detail td{
    text-align:center;
    font-weight:bold;
  }
  #detail .label{
    border:1px solid black;
    height:32px;
  }
</style>
<script type="text/javascript" src="view/javascript/jquery/jquery.min.js"></script>
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
      <h1 id='hidden_print'>PREVIEW</h1>
      <table border=1 cellspacing=0 cellpading=1>
        <tr>
          <td>DATE</td>
          <td>INVOICE#</td>
        </tr>
        <tr>
          <td><?php echo date('m/d/Y'); ?></td>
          <td><?php echo $invoice_no; ?></td>
        </tr>
      </table>
    </div>
  </div>
  <?php
    $shipto = nl2br($shipto);
    $address =<<<HTML
      <ul>
        <li>$store_name</li>
        <li>$address1</li>
        <li>$city , $state, $zipcode</li>
        <li>TEL : $phone1</li>
      </ul>
HTML;
    if('' == $billto) $billto = $address;
    if('' == $shipto) $shipto = $address;
  ?>
  <div id='billinfo'>
    <table id='billto' border='1' cellspacing=0 cellpading=1>
      <tr>
        <td style='padding-left:20px;'>BILL TO</td>
      </tr>
      <tr>
        <td style='padding-left:20px;'>
          <?php echo $billto; ?>
        </td>
      </tr>
    </table>
    <table id='shipto' border='1' cellspacing=0 cellpading=1>
      <tr>
        <td style='padding-left:20px;'>SHIP TO</td>
      </tr>
      <tr>
        <td style='padding-left:20px;'>
          <?php echo $shipto; ?>
        </td>
      </tr>
    </table>
  </div>

  <table id='metainfo' border='1' cellspacing=0 cellpading=1>
    <tr>
      <td>CUST.NO</td>
      <td>TERMS</td>
      <td>DUE DATE</td>
      <td>REP</td>
      <td>SHIP DATE</td>
      <td>SHIP VIA</td>
      <td>FREIGHT TERMS</td>
    </tr>
    <tr>
      <td><?php echo $accountno; ?></td>
      <td>NET<?php echo $term; ?></td>
      <td><?php echo $this->util->date_format_us(add_date(substr($order_date,0,10),30)); ?></td>
      <td><?php echo $salesrep; ?></td>
      <td><?php echo $shipped_date; ?></td>
      <td><?php echo strtoupper($ship_method); ?></td>
      <td>PREPAID</td>
    </tr>
  </table>

  <?php
    //$this->log->aPrint( $sales );      exit;
    $sumTotal = 0;

    //todo. need to check if there are dc or not for product level
    $dcFlag = false;
    foreach($sales as $sale){
      foreach($sale as $row){
        if( $row['dc1'] > 0 || $row['dc2'] > 0 ){
          $dcFlag = true;          break;
        }
      }
    }
    //echo $dcFlag;
  ?>
  <table id='detail' border='0'>
    <tr>
      <td class='label'>ITEM#</td>
      <td class='label'>DESCRIPTION</td>
      <td class='label'>QTY</td>
      <!--td class='label'>Free</td-->
      <td class='label'>B/O</td>
      <td class='label'>RATE</td>
      <?php
        if($dcFlag == true){
          echo "<td class='label'>DC1</td>";
          echo "<td class='label'>DC2</td>";
        }
      ?>
      <td class='label'>ORG</td>
      <?php
        if($dcFlag == true){
          echo "<td class='label'>SALED</td>";
        }
      ?>
    </tr>
    <tr><td colspan=5 style='height:5px;'></td></tr>
    <?php
      $total = $discountTotal = 0;
      foreach($sales as $key => $sale){
        $saledTotal = $dc1 = $dc2 = $store_dc1 = $store_dc2 = 0;
        $countCat = count($sale);
        if($countCat == 0) continue;
        $colCount = ($dcFlag == true) ? '9' : '6';
        $categoryTitle =<<<HTML
          <tr style='background-color:RGB(195,195,195)'>
            <td colspan=$colCount style='text-align:left;padding-left:20px;font-weight:bold;'>$key</td>
          </tr>
HTML;
        echo $categoryTitle;

        $groupTotal = $rawTotal = 0;
        $groupDcFlag = false;
        foreach($sale as $row){
          # backorder count
          $backorder  = $row['backorder'];
          $backfree   = $row['backfree'];
          $backdamage = $row['backdamage'];
          $backtotal  = $backorder + $backfree + $backdamage;
          
          //if('W' == $storetype) $eachPrice = $row['ws_price'];
          //if('R' == $storetype) $eachPrice = $row['rt_price'];
          
          if( $row['rate'] > 0 ){
            $eachPrice = $row['rate'];
          }else{
            ('W' == $storetype) ? $eachPrice = $row['ws_price'] : $eachPrice = $row['rt_price'];
          }
          $rawPrice = $row['cnt'] * $eachPrice;

          $dc1 = $row['dc1'];
          $dc2 = $row['dc2'];

          $saledPrice = $rawPrice;
          if( $dc1 > 0 ){
            $saledPrice = $saledPrice / (1 + $dc1/100) ;
            //$saledPrice = round($saledPrice,2);
            $groupDcFlag = true;
          }
          if( $dc2 > 0 ){
            $saledPrice = $saledPrice / (1 + $dc2/100) ;
            //$saledPrice = round($saledPrice,2);
            $groupDcFlag = true;
          }

          // store dc here
          $aDC = json_decode($store_dc);
          if(isset($aDC)){
            foreach($aDC as $k => $v){
              $aT1 = explode('|',$v);
              $i = $k+1;
              ${'store_dc'.$i} = isset($aT1[0]) ? $aT1[0] : 0;
              if( ${'store_dc'.$i} > 0 ){
                $saledPrice = $saledPrice / ( 1 + ${'store_dc'.$i}/100 );
                //$saledPrice = round($saledPrice,2);
                //$diff = $orgTotal - $total;
                //$orgTotal = $total;
              }
            }
          }
          
          if( $dc1 > 0 || $dc2 > 0 || $store_dc1 > 0 || $store_dc2 > 0 ){
            $saledPrice = round($saledPrice,2);
          }
          $saledDiff = $rawPrice - $saledPrice;
    ?>
    
    <?php
    if($row['cnt'] > 0){
    ?>
        <tr style='padding:0px'>
          <td style='width:100px;border-right:1px dotted black;'><?php echo substr($row['model'],2,4); ?></td>
          <td style='border-right:1px dotted black;text-align:left;'><?php echo $row['product_name']; ?></td>
          <td style='border-right:1px dotted black;'><?php echo $row['cnt']; ?></td>
          <!--td style='border-right:1px dotted black;'><?php echo $row['free']; ?></td-->
          <td style='border-right:1px dotted black;'><?php echo $backtotal; ?></td>
          <td style='border-right:1px dotted black;'><?php echo $eachPrice; ?></td>
        <?php
            if($dcFlag == true){
              echo "<td style=''>$dc1<font size=2>%</font></td>";
              echo "<td style='border-left:1px dotted black;'>$dc2<font size=2>%</font></td>";
              echo "<td style='border-left:1px dotted black;'>$rawPrice</td>";
            }else{
              echo "<td style=''>$rawPrice</td>";
            }
            if($dcFlag == true){
              echo "<td style='border-left:1px dotted black;'>$saledPrice</td>";
            }else{
              echo "<td style='border-left:1px dotted black;'><?php echo $rawPrice; ?></td>";
            }
        ?>
        </tr>
    <?php
    }
    ?>
    
    <!-- Free / Damage / Promotion -->
    <?php
    if($row['free'] > 0){
    ?>
        <tr style='padding:0px'>
        <td style='width:100px;border-right:1px dotted black;'><?php echo substr($row['model'],2,4); ?></td>
        <td style='border-right:1px dotted black;text-align:left;'><?php echo $row['product_name']; ?><span style='float:right'>Freegood &nbsp;</span></td>
        <td style='border-right:1px dotted black;'><?php echo $row['free']; ?></td>
        <td style='border-right:1px dotted black;'>0</td>
        <td style='border-right:1px dotted black;'><?php echo $eachPrice; ?></td>
      <?php
        if($dcFlag == true){
          echo "<td style=''>0</td>";
          echo "<td style='border-left:1px dotted black;'>0</td>";
          echo "<td style='border-left:1px dotted black;'>0</td>";
          echo "<td style='border-left:1px dotted black;'>0</td>";
        }else{
          echo "<td style=''>0</td>";
        }
      ?>
      </tr>
    <?php
    }
    ?>

    <?php
    if($row['damage'] > 0){
    ?>
        <tr style='padding:0px'>
        <td style='width:100px;border-right:1px dotted black;'><?php echo substr($row['model'],2,4); ?></td>
        <td style='border-right:1px dotted black;text-align:left;'><?php echo $row['product_name']; ?><span style='float:right'>Damage Replace &nbsp;</span></td>
        <td style='border-right:1px dotted black;'><?php echo $row['damage']; ?></td>
        <td style='border-right:1px dotted black;'>0</td>
        <td style='border-right:1px dotted black;'><?php echo $eachPrice; ?></td>
      <?php
        if($dcFlag == true){
          echo "<td style=''>0</td>";
          echo "<td style='border-left:1px dotted black;'>0</td>";
          echo "<td style='border-left:1px dotted black;'>0</td>";
          echo "<td style='border-left:1px dotted black;'>0</td>";
        }else{
          echo "<td style=''>0</td>";
        }
      ?>
      </tr>
    <?php
    }
    ?>

    <?php
    if($row['promotion'] > 0){
    ?>
        <tr style='padding:0px'>
        <td style='width:100px;border-right:1px dotted black;'><?php echo substr($row['model'],2,4); ?></td>
        <td style='border-right:1px dotted black;text-align:left;'><?php echo $row['product_name']; ?><span style='float:right'>Promotion &nbsp;</span></td>
        <td style='border-right:1px dotted black;'><?php echo $row['promotion']; ?></td>
        <td style='border-right:1px dotted black;'>0</td>
        <td style='border-right:1px dotted black;'><?php echo $eachPrice; ?></td>
      <?php
        if($dcFlag == true){
          echo "<td style=''>0</td>";
          echo "<td style='border-left:1px dotted black;'>0</td>";
          echo "<td style='border-left:1px dotted black;'>0</td>";
          echo "<td style='border-left:1px dotted black;'>0</td>";
        }else{
          echo "<td style=''>0</td>";
        }
      ?>
      </tr>
    <?php
    }
    ?>


    
    <?php
        $rawTotal   += $rawPrice;
        $groupTotal += $saledPrice;
      } // is it end group for ? 
      
      #### sub total section ###
      $saledText = '';
      if($countCat > 0){
        if($groupTotal > 0){
          if($rawTotal - $groupTotal > 0){
            $saledTotal = $rawTotal - $groupTotal;
            $saledText = '(' . $saledTotal * -1 . ')';
          }
        }
        if($dcFlag == true){
          $colspan1 = 5;
          $colspan2 = 9;
        }else{
          $colspan1 = 2;
          $colspan2 = 5;
        }

        ### groupDCFlag
        if($groupDcFlag == true){
          $subHtml = <<<HTML
            <tr>
              <td colspan=$colspan1></td>
              <td colspan=3>Special DC Inlcuded</td>
              <td></td>
            </tr>
HTML;
          echo $subHtml;
        }

        $subHtml = <<<HTML
          <tr>
            <td colspan=$colspan1></td>
            <td colspan=2>Sub-Total:</td>
            <td colspan=1>$saledText</td>
            <td>$groupTotal</td>
          </tr>
          <tr><td colspan=$colspan2 style='height:10px;'></td></tr>
HTML;
        echo $subHtml;
      }
      $total += $groupTotal;
      $discountTotal += $saledTotal;
    } // end of whole loop
    ?>
  <tr><td colspan=10 style='height:1px;background-color:peru;'></td></tr>

  <!-- just Store DC message -->
  <?php
    $aDC = json_decode($store_dc);
    $orgTotal = $total;
    if(isset($aDC)){
    foreach($aDC as $k => $v){
      $aT1 = explode('|',$v);
      $i = $k+1;
      ${'store_dc'.$i} = isset($aT1[0]) ? $aT1[0] : 0;
      if( ${'store_dc'.$i} > 0 ){
        //$total = $total * ( 100 - ${'store_dc'.$i} ) / 100;
        //$total = round($total,2);
        //$diff = $orgTotal - $total;
        //$orgTotal = $total;
      }
      
  ?>
    <tr>
      <td colspan='<?php echo $colspan1; ?>'></td>
      <td colspan='3' style='font-size:20px;font-weight:bold;'><?php echo ${'store_dc'.$i}; ?>% <?php echo $aT1[1]; ?></td>
      <td></td>
      <td><font color=red></td>
    </tr>
  <?php
    } // end store_dc foreach
    } // end isset aDC
  ?>
  
  <!-- cod -->
  <?php  
  if($cod > 0){  
    $total = $total + $cod;
  ?>
  <tr>
    <td colspan='<?php echo $colspan1; ?>'></td>
    <td colspan='' style='font-size:20px;font-weight:bold;'>
      Cod
    </td>
    <td colspan=2>
    </td>
    <td><?php echo $cod ?></td>
  </tr>
  <?php } ?>

  <!-- lift -->
  <?php  
  if($lift > 0){  
    $total = $total + $lift;
  ?>
  <tr>
    <td colspan='<?php echo $colspan1; ?>'></td>
    <td colspan='' style='font-size:20px;font-weight:bold;'>
      Lift
    </td>
    <td colspan=2>
    </td>
    <td><?php echo $lift ?></td>
  </tr>
  <?php } ?>

  <!-- TOTAL -->
  <tr>
    <td colspan='<?php echo $colspan1; ?>'></td>
    <td colspan='' style='font-size:20px;font-weight:bold;'>Total</td>
    <td colspan=2>
      <?php
      if($discountTotal > 0){
        echo '(-' .  $discountTotal . ')';
      }
      ?>
    </td>
    <td><?php echo $total; ?></td>
  </tr>

    <tr><td colspan=6 style='height:10px;'></td></tr>
    <tr>
      <td colspan='<?php echo $colspan2; ?>'>
<?php
$descLen = explode("\n",$description);
$descHeight = count( $descLen ) * 30;
$descHeight = 'height:'.$descHeight.'px';
?>
<textarea style='<?php echo $descHeight; ?>;margin-top:20px;width:100%;min-height:200px;font-size:20px;font-weight:bold;'>
<?php echo $description; ?>
</textarea>
      </td>
    </tr>
  </table>
</div>

<?php
$btrip = ( isset($this->request->get['btrip']) ) ? true : false;
if( true === $btrip ){
?>
<script>
  $('table#billto').css('display','none');
  $('table#shipto').css('display','none');
  $('textarea').css('display','none');
  setTimeout(function(){
    window.print(); window.close();
  },1000);
</script>
<?php
}
?>