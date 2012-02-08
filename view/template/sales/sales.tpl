<style>
.header{
  color:white;
  font-size:16px;
  background:black;
  padding-left:20px;
  line-height:30px;
  height:30px;
  width:900px;
  margin-bottom:1px;
}
.sales_tbl{
  display:none;
}
td{
  padding:2px;
}
.rborder{
  border-right:1px dotted black;
}
.item{
  width:430px;
  margin: 2px 5px 2px 5px;
}
.item div{
  float:left;
  padding:1px;
  line-height:20px;
}
.fl{
  float:left;
}
</style>
<script>
  // define freeorder check method before DOM
  $.fn.showBackorder = function(node){
    $el_backorder  = node.find('input[name="backorder[]"]');
    $el_backfree   = node.find('input[name="backfree[]"]');
    $el_backdamage = node.find('input[name="backdamage[]"]');
    if( $el_backorder.val() > 0 || $el_backfree.val() > 0 || $el_backdamage.val() > 0 ){
      node.find('.backorder').css('display','block')
      .css('background-color','#e2e2e2')
      .css('width','400px');
      node.find('.backorder input').css('width','30px');
    }
  }
</script>
<?php 
  $today = date("Y-m-d"); 
  function subval_sort($a,$subkey) {
  	foreach($a as $k=>$v) {
  		$b[$k] = strtolower($v[$subkey]);
  	}
  	asort($b);
    $i = 0;
    $aLeft = $aRight = array();
    foreach( $b as $k => $v ){
  		$prefix = substr($v,2,2);
  		$suffix = substr($v,4,2);
  		if( $prefix == '08' ){
  		  $aLeft[] = $v;
  		}
   		if( $prefix == '09' ){
  		  $aRight[] = $v;
  		}
      $i++;
    }
    //print_r($aLeft);print_r($aRight);
    $aSort = array();
    $i = 0;
    $lflag = $rflag = true;
    while(true){
      $k = ceil(($i+1)/2);
      $k = $k -1;
      if( isset($aLeft[$k]) && $i%2 == 0 ){
        $aSort[$i] = $aLeft[$k];
      }
      if( isset($aRight[$k]) && $i%2 == 1 ){
        $aSort[$i] = $aRight[$k];
      }
      if( !isset($aLeft[$k]) ){
        $lflag = false;
      }
      if( !isset($aRight[$k]) ){
        $rflag = false;
      }
      $i++;
      if( $lflag == false && $rflag == false ) break;
    }

    $i = 0;    $t1 = array();
    foreach($aSort as $v){
      $t1[$i] = $v; $i++;
    }
    //echo '<pre>';    print_r($t1);    echo '</pre>';
    $aRtn = array();
  	foreach($t1 as $key=>$val) {
  	  foreach($a as $k => $v){
  	    //print_r($v[$subkey]);
  	    if( strtolower($v[$subkey]) == $val ){
  	    
  	      $aRtn[$key] = $a[$k];
    		  //$c[] = $a[$key];
  		  }
  		}
  	}
  	return $aRtn;
  }
?>
<?php
if($mode == 'show'){
  $dc1 = $dc2 = $i = 0;
//  if( isset($sales) ){
  foreach($sales as $key => $sale){
    $sibling = implode('|',$catalog[$key]);
    $total = $cnt = $fre = $dmg = $prm = 0;
    $headerBG = ''; $headerTotal = ''; $fd = false;
    //$this->log->aPrint( $sale );
    if( $key == 'COLOR' ){
      $sale = subval_sort($sale,'model');
    }
    foreach($sale as $row){
      $total += $row['total_price'];
      $cnt += $row['cnt'];
      $fre += $row['free'];
      $dmg += $row['damage'];
      $prm += $row['promotion'];
    }
    if( ( $cnt + $fre + $dmg + $prm ) > 0 ) $fd = true;
    if( $total > 0 || $fd == true ){
      if($dc1 > 0)  $total = $total * ( 100 - $dc1 ) / 100;
      if($dc2 > 0)  $total = $total * ( 100 - $dc2 ) / 100;
      $headerBG = 'style=background-color:#660000';
      $freMsg = '';  if($fre > 0) $freMsg = 'F';
      $dmgMsg = '';  if($dmg > 0) $dmgMsg = 'D';
      $prmMsg = '';  if($prm > 0) $prmMsg = 'P';
      //$total = $this->util->formatMoney( $total );
      $headerTotal = '[ ' . $freMsg . $dmgMsg . $prmMsg . ' ' . round($total,2) . ' ] ';
    }
  ?>
    <h1 class='header' <?php echo $headerBG; ?> ><?php echo $headerTotal; ?><?php echo $key; ?></h1>
    <table id='<?php echo $key; ?>' sibling='<?php echo $sibling; ?>' style='display:block'>
      <?php
        $idx = 0;
        //$this->log->aPrint( $sale );
        foreach($sale as $row){
          //$total += $row['total_price'];
          // if exist rate stored in sales table, we should show that rate
          if( $row['rate'] > 0 ){
            $price = $row['rate'];
          }else{
            ('W' == $storetype) ? $price = $row['ws_price'] : $price = $row['rt_price'];
          }
          $product_name = substr($row['product_name'],0,20);
          if(fmod($idx,2) == 0) echo '<tr>';
          $redbox = '';
          if( $row['cnt'] > 0 || $row['free'] > 0 || $row['damage'] > 0 || $row['promotion'] > 0 || $row['backorder'] > 0  || $row['backfree'] > 0 || $row['backdamage'] > 0 ){
            $redbox = "style='border:2px solid red;'";
          }
          $backorderDisplay = 'display:none';
          if( $row['backorder'] > 0  || $row['backfree'] > 0 || $row['backdamage'] > 0 ){
            $backorderDisplay = 'display:block';
          }
          if( substr($row['model'],0,4) == 'VN08' && $idx%2 == 1 ){
            echo '<td><td></tr><tr>';
          }

          if( substr($row['model'],0,4) == 'VN09' && $idx%2 == 0 ){
            echo '<td></td>'; 
            $idx++;
          }

          // color highlight
          $colorAlign = '';
          if( substr($row['model'],0,4) == 'VN08' || substr($row['model'],0,4) == 'VN09'){
            $product_name = preg_replace('/(#.+)/','<font color=blue><b>${1}</b></font>',$product_name);
            $colorAlign = 'text-align:right';
          }
      ?>
        <td <?php echo $redbox; ?> class='td<?php echo $idx; ?>' >
        <div class='item'>
         <div class='product_name fl' style='width:100px;overflow:hidden;<?php echo $colorAlign ?>'><?php echo $product_name; ?></div>
         <div class='model'>
           <input type='hidden' name='model[]' value='<?php echo $row['model']; ?>'/>
           <input type='hidden' name='product_id[]' value='<?php echo $row['product_id']; ?>'/>
           <input type='hidden' name='weight[]' value='<?php echo $row['ups_weight']; ?>'/>
           <input type='text' name='model_show[]' value='<?php echo substr($row['model'],2,4); ?>' class='model_show' style='width:30px' readonly /></div>
         <div><input type='text' name='price[]' value='<?php echo $price; ?>' style='width:36px' /></div>
         <div><input type='number' name='cnt[]' value='<?php echo $row['cnt']; ?>' style='width:25px;background-color:#66ff00;' /></div>
         <div>
          <input type='text' name='free[]' value='<?php echo $row['free']; ?>' style='width:15px;background-color:#ffcc00;' /></div>
         <div><input type='text' name='damage[]' value='<?php echo $row['damage']; ?>' style='width:15px' /></div>
         <div>
          <input type='text' name='promotion[]' value='<?php echo $row['promotion']; ?>' style='width:15px' />
          <input type='text' name='pkg[]' value='<?php echo ( $row['cnt'] + $row['free'] + $row['damage'] + $row['promotion'] ) ?>' style='display:none;' />
         </div>
         <div style='margin-left:5px'>
          <input type='text' name='discount[]' value='<?php echo $row['dc1']; ?>'  style='width:15px;background-color:#ffff99;' /></div>
         <div><input type='text' name='discount2[]' value='<?php echo $row['dc2']; ?>' style='width:15px;background-color:#ffff99;' /></div>
         <div style='margin-left:5px'>
          <input type='text' class='total_price' name='total_price[]' value='<?php echo $row['total_price']; ?>' style='width:45px;background-color:#e2e2e2;' readonly />
          <input type='hidden' name='weight_row[]' value='<?php echo $row['weight_row']; ?>'/></div>
         <div>
          <input type='text' name='stock[]' value='<?php echo $row['quantity']; ?>' style='width:25px;display:none;' class='check_locked np' readonly/>
         </div>
         <!--div class='backorder np' style='<?php echo $backorderDisplay ?>'>
          <input type='text' name='backorder[]' value='<?php echo $row['backorder']; ?>'         size=2 readonly class='np'/>
          <input type='text' name='backfree[]' value='<?php echo $row['backfree']; ?>'           size=2 readonly class='np'/>
          <input type='text' name='backdamage[]' value='<?php echo $row['backdamage']; ?>'       size=2 readonly class='np'/>
          <input type='text' name='backpromotion[]' value='<?php echo $row['backpromotion']; ?>' size=2 readonly class='np'/>
         </div-->
        </div>
        </td>
      <?php
        if(fmod($idx,2) == 1) echo '</tr>';
        echo '<script>$.fn.showBackorder($(\'.td' . $i . '\'));</script>';
        $idx++;
        $i++; // it's for dynamic show backyard
        // call dhtml to check backorder
        } // foreach sale
      ?>
    </table>
  <?php
  } //end foreach
}else{
  foreach($catalog as $key => $aModel){
    $sibling = implode('|',$aModel);
    $bgcolor = '';
    $prefix = substr($key,0,2);
    if($prefix == 'AE') $bgcolor='#FF0000';
    if($prefix == 'SP') $bgcolor='#CC9900';
    if($prefix == '30') $bgcolor='#9900FF';
    if($prefix == 'VI') $bgcolor='#3333FF';
    if($prefix == 'OE') $bgcolor='#00CC33';

    $hdrHtml = $key;

    if( isset($sales[$key]) ){
      //$this->log->aPrint( $key );
      $groupTotal = 0;
      $fFlag = $dFlag = $pFlag = false;
      foreach( $sales[$key] as $aT1 ){
        $groupTotal += $aT1['total_price'];
        if($aT1['free'] > 0) $fFlag = true;
        if($aT1['damage'] > 0) $dFlag = true;
        if($aT1['promotion'] > 0) $pFlag = true;
      }
      $hdrHtml = '[ ';
      $hdrHtml .= ( $fFlag == true ) ? 'F' : '';
      $hdrHtml .= ( $dFlag == true ) ? 'D' : '';
      $hdrHtml .= ( $pFlag == true ) ? 'P' : '';
      $hdrHtml .= ' ' . $groupTotal . ' ] ';
      $hdrHtml .= ' ' . $key;
    }
  ?>
    <h1 class='header' style='background-color:<?php echo $bgcolor ?>'><?php echo $hdrHtml ?></h1>
    <table id='<?php echo $key; ?>' class='sales_tbl' sibling='<?php echo $sibling; ?>' >
    </table>
  <?php
  } //end foreach
} // mode
?>

<script>
$(document).ready(function(){
  /* not used now
  // todo. it should be whole loop row . try it later , besso 201105 
  $.fn.validateAR = function(){
    var $orderNode = $('#order').find("input[name='total_price[]']"),
        $cod = $('input[name=ship_cod]').val(),
        $lift = $('input[name=ship_lift]').val(),
        $amount = $('input[name=order_price]').val(),
        $order_price = 0;
    for($i=0; $i<$orderNode.length; $i++){
      if("" == $orderNode[$i].value){
        $orderNode[$i].value = 0;
      }
      $order_price += parseFloat($orderNode[$i].value);
    }
    
    $order_price = $order_price + parseFloat($lift) + parseFloat($cod);
    $order_price = $order_price.toFixed(2);
    //alert($order_price);    alert($amount);
    if( $order_price != $amount ){
      return true;
    }
    return true;
  }
  */


  // rollback beforeNode job
  $beforeNode = null;

  if( 'edit' == $('#form').find('input[name=mode]').val() ){
    $('#floatmenu').css('visibility','visible');
    $('#floatmenu').find('input[name=float_order_price]').val($('#form').find('input[name=order_price]').val());
    $('#floatmenu').find('input[name=float_freegood_percent]').val($('#freegood_percent').val());
  }

  // defind window.object global
  var $el_order_date  = $('#form').find('input[name=order_date]'),
      $el_order_price = $('#form').find('input[name=order_price]'),
      $tx = 1;

  $('h1.header').bind('click.hdrEvent',function(e){
    if( 'show' == $('#form').find('input[name=mode]').val() ){
      $tx = 0;
    }
    $('#form').find('input[name=mode]').val('edit');
    $tgt = $(e.target);

    var $tbl_node = $tgt.next('table'),
        $id = $tbl_node.attr('id'),
        $c1 = $c2 = $c3 = $c4 = $c5 = 0;

    if( $beforeNode == null)  $beforeNode = $tbl_node;

    $beforeNode.find('input[name="cnt[]"]').each(function($k,$v){
      if(!isNaN(parseInt($beforeNode.find('input[name="cnt[]"]')[$k].value))){
        $c1   += parseInt($beforeNode.find('input[name="cnt[]"]')[$k].value);
      }
      if(!isNaN(parseInt($beforeNode.find('input[name="free[]"]')[$k].value))){
        $c2   += parseInt($beforeNode.find('input[name="free[]"]')[$k].value);
      }
      if(!isNaN(parseInt($beforeNode.find('input[name="damage[]"]')[$k].value))){
        $c3   += parseInt($beforeNode.find('input[name="damage[]"]')[$k].value);
      }
      if(!isNaN(parseInt($beforeNode.find('input[name="promotion[]"]')[$k].value))){
        $c4   += parseInt($beforeNode.find('input[name="promotion[]"]')[$k].value);
      }
    });
    $c5 = $c1 + $c2 + $c3 + $c4;

    if( $tx > 0 && $c5 > 0 ){
      $.fn.postSubmit($tbl_node);
    }else{
      $.fn.hideGroups($tbl_node);
    }
    $tx++;
  });

  $.fn.postSubmit = function($tbl_node){
    // todo. no validation !!!
    //if($('#freegood_percent').val() > 10)      alert('freegood exceed 10%');  return;
    if( $('#form').find('input[name=txid]').val() == '' ){
      $hdr = $.fn.generateTXID();
      $hdr.success(function($txid){
        $txid = $txid.replace(/\"/g,"");
        $('#form').find('input[name=txid]').val($txid);
        $('#form').find('input[name=ddl]').val('insert');
        $('#form').find('input[name=async]').val('true');
        $.post( $('#form').attr('action') , $('#form').serialize() , function(){
          $('#txid_header').html($txid);
          $.fn.hideGroups($tbl_node);
        });
      });
    }else{
      $('#form').find('input[name=ddl]').val('update');
      $('#form').find('input[name=async]').val('true');
      $.post( $('#form').attr('action') , $('#form').serialize(), function(){
          //if( 'hidden' == $('#floatmenu').css('visibility') ) $.fn.floatingMenu($tgt);
          $.fn.hideGroups($tbl_node);
      });
    }
  }

  $.fn.hideGroups = function($exceptNode){
    var $el_groups = $exceptNode.parents('#order').children('table');
    //if($beforeNode != $exceptNode){
      $total = $c1 = $c2 = $c3 = $c4 = $c5 = 0;
      $beforeNode.find(".item").each(function(){
        $this = $(this);
        $t = $this.find('input.total_price').val();
        $cnt = $this.find('input[name="cnt[]"]').val();
        $free = $this.find('input[name="free[]"]').val();
        $damage = $this.find('input[name="damage[]"]').val();
        $promotion = $this.find('input[name="promotion[]"]').val();
        if( !isNaN($t) )        $total += parseFloat($t);
        if( !isNaN($cnt) )      $c1    += parseInt($cnt);
        if( !isNaN($free) )     $c2    += parseInt($free);
        if( !isNaN($damage) )   $c3    += parseInt($damage);
        if( !isNaN($promotion)) $c4    += parseInt($promotion);
      });
      $total = $total.toFixed(2);
      $c5 = $c1 + $c2 + $c3 + $c4;
      if($c5 > 0){
        var $beforeH1 = $beforeNode.prev('h1.header');
        $beforeH1.css('background-color','#660000');
        $ptn = /\[.+\]/;
        //if($beforeH1.html().indexOf('[') == -1){
        if( $beforeH1.html().match($ptn) ){
          $beforeH1.html( $beforeH1.html().replace($ptn,'') );
        }
        $freMsg = '';  if($c2 > 0) $freMsg = 'F';
        $dmgMsg = '';  if($c3 > 0) $dmgMsg = 'D';
        $prmMsg = '';  if($c4 > 0) $prmMsg = 'P';
        $beforeH1.html( '[ ' + $freMsg + $dmgMsg + $prmMsg + ' ' + $total + ' ] ' + $beforeH1.html());
      }
      $beforeNode = $exceptNode;
    //}

    /* ajax retrieve just data which stored in sales table
       and dynamically show that models under the category */
    //$el_groups.each(function(){

    $.each($el_groups,function(){
      var $group = $(this);
      if( $group.attr('id') == $exceptNode.attr('id') ){
        $models = $exceptNode.attr('sibling');
        $.fn.retrieveGroup($exceptNode,$models);
        $group.css('display','block');
        //$pos = $(this).positon();
//debugger;
      }else{
        $group.css('display','none');
      }
    });
  }

  $.fn.generateTXID = function(){
    var $salesrep = $('#storeinfo').find('input[name=salesrep]'),
        $store_id = $('#form').find('input[name=store_id]'),
        $accountno = $('#storeinfo').find('input[name=accountno]'),
        $weight_sum = $('#form').find('input[name=weight_sum]'),
        $return = '';
    if(false == $.fn.validateNull($accountno)) return;
    if(false == $.fn.validateNull($salesrep)) return;
    if(false == $.fn.validateNull($store_id)) return;

    $salesrep = $salesrep.attr('value').substring(0,2).toUpperCase();
    $ymd = $el_order_date.attr('value').substring(0,4) + $el_order_date.attr('value').substring(5,7) + $el_order_date.attr('value').substring(8,10);
    $accountno = $accountno.attr('value');
    $vTxid = $accountno + '-' + $salesrep + $ymd;

    $hdr = $.ajax({
             type:'get',
             url:'/backyard/index.php?route=sales/order/verify_txid',
             dataType:'text',
             data:'token=<?php echo $token; ?>&txid=' + $vTxid
           });
    // return asysnronous handler
    return $hdr;
  }

  // queryProduct
  // call ajax to query product to fill default value in order
  $.fn.retrieveGroup = function($exceptNode,$model){
    $exceptNode.html('');
    $.ajax({
			type: 'GET',
			url: 'index.php?route=sales/atc/getProductBatchProxy2',
			dataType: 'json',
			data: 'txid=' + $('#form').find('input[name=txid]').val() + '&model=' + $model,
			success: function( list ){
        var node = $exceptNode,
            $itemHtml = "";

			  $.each(list, function(idx,line){
			    if( '' == line ){
			      $itemHtml = "<td></td>";
			    }else{
            $itemHtml = "<td>";
            $itemHtml+= "<div class='item'>";
            $itemHtml+= " <div class='product_name fl' style='width:100px;overflow:hidden;'></div>";
            $itemHtml+= " <div class='model'><input type='hidden' name='model[]' value=''/><input type='hidden' name='product_id[]' value=''/>";
            $itemHtml+= "   <input type='hidden' name='weight[]' value=''/>";
            $itemHtml+= "   <input type='text' name='model_show[]' style='width:30px' value='' readonly /></div>";
            $itemHtml+= " <div><input type='text' name='price[]' value='price' style='width:36px' /></div>";
            $itemHtml+= " <div><input type='number' name='cnt[]' value='0' style='width:25px;background-color:#FFFF99;' /></div>";
            $itemHtml+= " <div><input type='text' name='free[]' value='free' style='width:15px'  /></div>";
            $itemHtml+= " <div><input type='text' name='damage[]' value='dmg' style='width:15px'  /></div>";
            $itemHtml+= " <div><input type='text' name='promotion[]' value='pr' style='width:15px'  /><input type='text' name='pkg[]' value='' style='display:none;' /></div>";
            $itemHtml+= " <div style='margin-left:5px'><input type='text' name='discount[]' value='d1' style='width:15px;' /></div>";
            $itemHtml+= " <div><input type='text' name='discount2[]' value='d2' style='width:15px;' /></div>";
            $itemHtml+= " <div style='margin-left:5px'><input type='text' class='total_price' name='total_price[]' value='0.00' style='width:45px' readonly /><input type='hidden' name='weight_row[]' value=''/></div>";
            $itemHtml+= " <div><input type='text' name='stock[]' value='stock' style='width:25px;display:none;' class='check_locked' readonly/></div>";
            //$itemHtml+= " <div class='backorder' style='display:none'>";
            //$itemHtml+= "   <input type='text' name='backorder[]' value='0' class='np' />";
            //$itemHtml+= "   <input type='text' name='backfree[]' value='0'  class='np'/>";
            //$itemHtml+= "   <input type='text' name='backdamage[]' value='0'  class='np'/>";
            //$itemHtml+= " </div>";
            $itemHtml+= "</div>";
            $itemHtml+= "</td>";
			    }

          if( idx%2 == 0 ){
            if( idx > 0 ){
    			    thisNode = node.find("tr:last-child");
    			    thisNode.after('<tr></tr>');
  			    }else{  // first
  			      node.append('<tr></tr>');
  			    }
  			    thisNode = node.find("tr:last-child");
  			    thisNode.append($itemHtml);
  			    thisNode.find('td').addClass('left');
  			    thisNode = node.find("tr:last-child");
  			  }
 			    if( idx%2 == 1 ){
   			    thisNode = node.find("tr:last-child");
 			      thisNode.append($itemHtml);
 			      thisNode.find('td:last-child').addClass('right');
  			    thisNode = thisNode.find("td:last-child");
 			    }

			    $.each(line, function(key,val){
            if(key == 'pn'){
              pn = val.substring(0,20);
              $ptn1 = /(#.+)/;
              pn = pn.replace($ptn1, function(a,b){
                return '<font color=blue><b>' + b + '</b></font>';
              });
              $ptn2 = /([0-9][.][0-9]+LB|[0-9]+LB)/;
              pn = pn.replace($ptn2, function(a,b){
                return '<font color=blue><b>' + b + '</b></font>';
              });
              $ptn3 = /([0-9][.][0-9]+oz|[0-9]+oz)/;
              pn = pn.replace($ptn3, function(a,b){
                return '<font color=blue><b>' + b + '</b></font>';
              });
              thisNode.find('.product_name').html(pn).css('text-align','right');
            }
            if(key == 'm'){
              thisNode.find('input[name="model[]"]').val(val);
              model_show = val.substring(2,6);
              thisNode.find('input[name="model_show[]"]').val(model_show);
            }
            if(key == 'id'){
              thisNode.find('input[name="product_id[]"]').val(val);
            }
            if(key == 'wt'){
              thisNode.find('input[name="weight[]"]').val(val);
            }
            if(key == 'q'){
              thisNode.find('input[name="stock[]"]').val(val);
            }
            if(key == 'd1'){
              if( val == 0 ) val = 'd1'; 
              thisNode.find('input[name="discount[]"]').val(val);
            }
            if(key == 'd2'){
              if( val == 0 ) val = 'd2';
              thisNode.find('input[name="discount2[]"]').val(val);
            }
            
            var storetype = $('input[name="storetype"]').val();
            // todo. null check , besso-201103 
            if(storetype == 'W'){
              if(key == 'ws'){
                thisNode.find('input[name="price[]"]').val(val);
              }
            }else{
              if(key == 'rt'){
                thisNode.find('input[name="price[]"]').val(val);
              }
            }
            // from sales
            if(key == 'c'){
              thisNode.find('input[name="cnt[]"]').val(val);
              // todo ugly code. tired . let's make custom func, later.
              if( val > 0 ){  if(thisNode.is('tr')){  thisNode.children('td').css( 'border' , '2px solid red' );  }else{  thisNode.css( 'border' , '2px solid red' ); } }
            }
            if(key == 'f'){
              if( val == 0 ) val = 'f'; 
              thisNode.find('input[name="free[]"]').val(val);
              if( val > 0 ){  if(thisNode.is('tr')){  thisNode.children('td').css( 'border' , '2px solid red' );  }else{  thisNode.css( 'border' , '2px solid red' ); } }
            }
            if(key == 'd'){
              if( val == 0 ) val = 'd';
              thisNode.find('input[name="damage[]"]').val(val);
              if( val > 0 ){  if(thisNode.is('tr')){  thisNode.children('td').css( 'border' , '2px solid red' );  }else{  thisNode.css( 'border' , '2px solid red' ); } }
            }

            if(key == 'p'){
              if( val == 0 ) val = 'p';
              thisNode.find('input[name="promotion[]"]').val(val);
              if( val > 0 ){  if(thisNode.is('tr')){  thisNode.children('td').css( 'border' , '2px solid red' );  }else{  thisNode.css( 'border' , '2px solid red' ); } }
            }

            if(key == 'tp'){
              thisNode.find('input[name="total_price[]"]').val(val);
            }
            if(key == 'wr'){
              thisNode.find('input[name="weight_row[]"]').val(val);
            }
            
            /*****
            if(key == 'bo'){
              thisNode.find('input[name="backorder[]"]').val(val);
              if( val > 0 ){
                if(thisNode.is('tr')){
                  thisNode.children('td').css( 'border' , '2px solid red' );
                }else{
                  thisNode.css( 'border' , '2px solid red' );
                }
              }
            }
            if(key == 'bf'){
              thisNode.find('input[name="backfree[]"]').val(val);
            }
            if(key == 'bd'){
              thisNode.find('input[name="backdamage[]"]').val(val);
            }
            if(key == 'bp'){
              thisNode.find('input[name="backpromotion[]"]').val(val);
            }
            *****/
          });
          // show backorder
          $.fn.showBackorder(thisNode);
			  });
      }
   });
  }

  $.fn.floatingMenu = function($tgt){
    var $p = $tgt.offset();
    $cssMap = {
      'top':$p.top,
      'left':$p.left + 850,
      'visibility':'visible'
    };
    $('#floatmenu').find('input[name=float_order_price]').val($('#form').find('input[name=order_price]').val());
    $('#floatmenu').find('input[name=float_freegood_percent]').val($('#freegood_percent').val());
    $('#floatmenu').css($cssMap);
    $('#floatmenu').draggable();
  }
  $('#floatmenu').bind('click',function(e){
    $tgt = $(e.target);
    if($tgt.is('button')){
      $status = $('input[name=status]').val();
      if($status == '0')  $('input[name=status]').val('1');
      $mode = $tgt.attr('id');
      $('#form').find('input[name=mode]').val($mode);
      $order_price = $('#form').find('input[name=order_price]').val();
      $order_price = parseFloat($order_price);
      //todo. allow 0 order for sample else
      //if($order_price == 0){        alert('No Order');        return;      }
      if('edit' == $mode){  //just simple redirect
        location.href = 'index.php?route=sales/order&mode=edit&txid=' + $('#form').find('input[name=txid]').val();
      }else{
        if( $('#form').find('input[name=txid]').val() == '' ){
          $hdr = $.fn.generateTXID();
          $hdr.success(function($txid){
            $txid = $txid.replace("\"","");
            $('#form').find('input[name=txid]').val($txid);
            $('#form').find('input[name=ddl]').val('insert');
            $('#form').find('input[name=async]').val('false');
            $('#txid_header').html($txid);
            $('#form').submit();
          });
        }else{
          $('#form').find('input[name=ddl]').val('update');
          $('#form').find('input[name=async]').val('false');
          $('#form').submit();
        }
      }
    }else{
      //$('#floatmenu').css('visibility','hidden');
    }
  })

  /***
  status 
    0 : before request
    1 : normal request
    2 : hold request
  ***/
  $('.save_order').bind('click',function(e){
    $this = $(this);
    $('#form').find('input[name=mode]').val('show');
    $order_price = $('#form').find('input[name=order_price]').val();
    $order_price = parseFloat($order_price);
    //if($order_price == 0){      alert('No Order');      return;    }
    if( $('#form').find('input[name=txid]').val() == '' ){
      $hdr = $.fn.generateTXID();
      $hdr.success(function($txid){
        // todo. weird . dont know why
        $txid = $txid.replace("\"","");
        //$txid = $txid.substring(1,$txid.length-1);
        $('#form').find('input[name=txid]').val($txid);
        $('#form').find('input[name=ddl]').val('insert');
        $('#form').find('input[name=async]').val('false');
        $('#txid_header').html($txid);
        $('#form').submit();
      });
    }else{
      $('#form').find('input[name=ddl]').val('update');
      $('#form').find('input[name=async]').val('false');
      $('#form').submit();
    }
  });

  $(window).scroll(function () {  
    $p = $('#floatmenu').offset();
    $top = $(window).scrollTop()+200;
    $('#floatmenu').css('top',$top);
  }); 

  //$('input').attr('autocomplete','off');
});
</script>