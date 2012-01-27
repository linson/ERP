<?php
$today = new DateTime();
$odt = new DateTime($order_date);
?>
<?php echo $header; ?>
<?php if ($error_warning){ ?>
<div class="warning"><?php echo $error_warning; ?></div>
<?php } ?>

<link rel='stylesheet' type='text/css' href='view/template/ar/order.css' />
<script type='text/javascript' src='view/template/sales/atc/jquery/jquery.metadata.js'></script>
<script type='text/javascript' src='view/template/sales/atc/src/jquery.auto-complete.js'></script>
<link rel='stylesheet' type='text/css' href='view/template/sales/atc/src/jquery.auto-complete.css' />

<div class="box">
  <div class="left"></div>
  <div class="right"></div>
  <div class="heading">
    <h1 style="background-image: url('view/image/product.png');">Order Information</h1>
    <div class="buttons">
      <a class="button" id='save'><span>Order Memo Save</span></a>
      <a onclick="location = '<?php echo $lnk_list; ?>';" class="button"><span>List</span></a>
      <!--a onclick="location = '<?php echo $lnk_cancel; ?>';" class="button"><span><?php echo $button_cancel; ?></span></a-->
      <a id='print' onclick='printOrder()'><img border="0" style='width:20px;height:20px;vertical-align:bottom;' src="image/icon/printtag.jpg"></a>
    </div>
  </div>
  <div id="ubporder">
    <form action='<?php echo $order_action; ?>' method='post' id='form'>
    <div id='base'>
      <div class='half'>
        <div id='brief'>
          <h1><?php if($txid){ echo $txid; }else{ echo '<font color=red>New Order</font>'; } ?></h1> 
        </div>
        <!-- store info : start -->
        <div id='storeinfo'>
          <table border='1' cellpadding="0" cellspacing="0">
            <tr style='border-style:none;'>
              <td colspan='3' style='border-style:none;'></td>
              <td style='border-style:none; text-align:right;'>
                <input type='text' class='date_pick' name='order_date' value='<?php echo $order_date; ?>' />
              </td>
            </tr>
            <tr>
              <td class='label'>Biz Name</td>
              <td class='context'>
                <input type='hidden' name='store_id' value='<?php echo $store_id; ?>' />
                <input type='hidden' name='txid' value='<?php echo $txid; ?>' />
                <input type='hidden' name='ddl' value='<?php echo $ddl; ?>' />
                <!--input type='hidden' name='user_id' value='<?php echo $user_id; ?>' /-->
                <input type='text' name='store_name' value='<?php echo $store_name; ?>'  style='width:96%' />
              </td>
              <td class='label'>Account No</td>
              <td class='context'>
                <input type='text' name='accountno' value='<?php echo $accountno; ?>' size='5' />
                <input type='hidden' name='salesrep' value='<?php echo $salesrep; ?>' />
              </td>
            </tr>
            <tr>
              <td colspan=2>
                <input type='text' name='address1' value='<?php echo $address1; ?>'  style='width:96%' />
              </td>
              <td class='label'>
                City /State/Zip
              </td>
              <td class='context'>
                <input type='text' name='city' value='<?php echo $city; ?>' style='width:36%' /> / 
                <input type='text' name='state' value='<?php echo $state; ?>' style='width:10%' /> / 
                <input type='text' name='zipcode' value='<?php echo $zipcode; ?>' style='width:24%' /> 
              </td>
            </tr>

            <tr>
              <td class='label'>
                Type
              </td>
              <td class='context'>
                <select name='storetype'>
                <?php
                if(strtolower($storetype) == 'w'){
                  echo '<option value="W" selected>W</option>';
                }else{
                  echo '<option value="W">W</option>';
                }
                if(strtolower($storetype) == 'r'){
                  echo '<option value="R" selected>R</option>';
                }else{
                  echo '<option value="R">R</option>';
                }
                if(strtolower($storetype) == ''){
                  echo '<option value="" selected>--</option>';
                }
                ?>
                </select>
              </td>
              <td class='label'>
                Phone / Fax
              </td>
              <td class='context'>
                <input type='text' name='phone1' value='<?php echo $phone1; ?>' style='width:51%' />
                / <input type='text' name='fax' value='<?php echo $fax; ?>'  style='width:30%' />
              </td>
            </tr>
            <tr>
              <td colspan=4>
                <textarea name='description' style='width:460px;height:100px;'><?php echo $description; ?></textarea>
              </td>
            </tr>
          </table>
          <?php
          // todo. block on service. , besso-201103 
          if('update' != $ddl){
          ?>
          <span class='small_btn' id='findstore'>Find Store</span>
          <?php
          }
          ?>
          <!--span class='small_btn'>Update Store</span-->
          <!--span id='googlemap' class='small_btn'>Google map</span-->
        </div>
        
        <?php 
        //todo. check the condition, , besso-201103 
        if(isset($store_ar_total) && $store_ar_total['tot_order'] > 0 ){
        ?>
        <!-- start of account history -->
        <div id='account_history'>
          <?php require_once('view/template/sales/arHistory.tpl'); ?>
        </div>
        <!-- end of account history -->
        <?php
        }   // end isset for ar history 
        ?>
      </div>

      <div class='half'>
        <!-- ship info : start -->
        <div id='ship'>
          <table border='1' cellpadding="0" cellspacing="0">
            <tr>
              <td class='label'>
                TERM
              </td>
              <td class='context'>
                <select name='term'>
                <?php
                if(strtolower($term) == '30'){
                  echo '<option value="30" selected>30</option>';
                }else{
                  echo '<option value="30">30</option>';
                }
                if(strtolower($term) == '60'){
                  echo '<option value="60" selected>60</option>';
                }else{
                  echo '<option value="60">60</option>';
                }
                if(strtolower($term) == '90'){
                  echo '<option value="90" selected>90</option>';
                }else{
                  echo '<option value="90">90</option>';
                }
                if(strtolower($term) == '1'){
                  echo '<option value="1" selected>1</option>';
                }else{
                  echo '<option value="1">1</option>';
                }
                ?>
                </select>
              </td>
              <td class='label'>
                WEIGHT
              </td>
              <td class='context'>
                <input type='text' name='weight_sum' value='<?php echo $weight_sum; ?>' size='5' />
              </td>
            </tr>
        <?php
        if(!isset($ship)){
          $ship = array();
        }
        // todo. need to replace ship_user from order_user
        if(count($ship) == 0):
        ?>
          <tr><td colspan='4' style='background-color:orange; height:3px;'></td></tr><tr><td class='label'><p class='del' style='float:left;margin:0px;margin-left:2px;'></p><p style='margin:0px;'>APP</p></td><td class='context' colspan='3'><input type='hidden' name='ship_id[]' value=''/><input type='text' class='date_pick' name='ship_appointment[]' value='' style='width:40%'/>(ship appointment)</td></tr><tr><td colspan=4><textarea name='ship_comment[]' style='width:95%;height:30px;'/></textarea></td></tr><tr><td class=label>SHIP</td><td class=context><select name=method[]><option value='truck' selected>truck</option><option value='ups'>ups</option><option value='cod'>cod</option><option value='self'>self</option><option value='etc'>etc</option></select></td><td class=label>DATE</td><td class=context><input type=text class='date_pick' name=ship_date[] value='' style='width:40%' /></td></tr><tr><td class=label>LIFT</td><td class=context><input type=text name=lift[] value='' size=5 /></td><td class=label>COD</td><td class=context><input type=text name=cod[] value='' size=5 /><p class=plus style='float:right;margin:0px;margin-right:2px;' /><input type='hidden' name='ship_user[]' value='<?php echo $this->user->getUserName(); ?>' /></td></tr>
        <?php
        else: // aShip
          foreach($ship as $row){
        ?>
            <tr><td colspan='4' style='background-color:orange; height:3px;'></td></tr>
            <tr>
              <td class='label'>
                <p class='del' style='float:left;margin:0px;margin-left:2px;'></p>
                <p style='margin:0px;'>APP</p>
              </td>
              <td class='context' colspan=3>
                <input type='hidden' name='ship_id[]' value='<?php echo $row['id']; ?>'/>
                <input type='text' class='date_pick' name='ship_appointment[]' value='<?php echo $row['ship_appointment']; ?>' style='width:40%'/>
              </td>
            </tr>
            <tr>
              <td colspan=4>
                <textarea name='ship_comment[]' style='width:95%'/><?php echo $row['ship_comment']; ?></textarea>
              </td>
            </tr>
            
            <tr>
              <td class='label'>
                <p style='margin:0px;'>SHIP</p>
              </td>
              <td class='context'>
                <select name='method[]'>
                <?php
                if(strtolower($row['method']) == 'truck'){
                  echo '<option value="truck" selected>truck</option>';
                }else{
                  echo '<option value="truck">truck</option>';
                }
                if(strtolower($row['method']) == 'ups'){
                  echo '<option value="ups" selected>ups</option>';
                }else{
                  echo '<option value="ups">ups</option>';
                }
                if(strtolower($row['method']) == 'cod'){
                  echo '<option value="cod" selected>cod</option>';
                }else{
                  echo '<option value="cod">cod</option>';
                }
                if(strtolower($row['method']) == 'self'){
                  echo '<option value="self" selected>self</option>';
                }else{
                  echo '<option value="self">self</option>';
                }
                if(strtolower($row['method']) == 'etc'){
                  echo '<option value="etc" selected>etc</option>';
                }else{
                  echo '<option value="etc">etc</option>';
                }
                ?>
                </select>
                <input type='hidden' name='ship_user[]' value='<?php echo $row['ship_user']; ?>' />
              </td>

              <td class='label'>
                DATE
              </td>
              <td class='context'>
                <input type='text' class='date_pick' name='ship_date[]' value='<?php echo $row['ship_date']; ?>' style='width:40%' />
              </td>
            </tr>

            <tr>
              <td class='label'>
                LIFT
              </td>
              <td class='context'>
                <input type='text' name='lift[]' value='<?php echo $row['lift']; ?>' size='5' />
              </td>
              <td class='label'>
                COD
              </td>
              <td class='context'>
                <input type='text' name='cod[]' value='<?php echo $row['cod']; ?>' size='5' />
                <p class='plus' style='float:right;margin:0px;margin-right:2px;' />
              </td>
            </tr>
        <?php
          } // end foreach // todo. so weird , need no close brace foreach , besso-201103
        endif;  // count()
        ?>
          </table>
          <!--span id='ship_history' class='small_btn'>Shipping History</span-->
        </div>
        <!-- end of ship -->
        
        <!-- payment info -->
        <div id='payment'>
          <table border='1' cellpadding="0" cellspacing="0">
            <tr>
              <td class='label'>
                Amount
              </td>
              <td class='context'>
                <input type='text' name='order_price' value='<?php echo $order_price; ?>' size=5/>
                <?php
                  $diff = $odt->diff($today);
                  echo "<font color='red'>+" . $diff->format('%d') . "</font>";
                ?>
              </td>
              <td class='label'>
                Paid /
                Balance
              </td>
              <td class='context'>
                <input type='text' name='payed_sum' value='<?php echo $payed_sum; ?>' size=8 />
                <br/>
                <input type='text' name='balance' value='<?php echo $balance; ?>' size=8 style='background-color:yellow' />
              </td>
            </tr>

        <?php
        if(!isset($pay)) $pay = array();
        // todo. need to replace ship_user from order_user
        if(count($pay) < 1){
        ?>
            <tr><td colspan='4' style='background-color:orange; height:3px;'></td></tr>
            <tr>
              <td class='label'>
                <p class='del' style='float:left;margin:0px;margin-left:2px;'></p>
                <p style='margin:0px;'>Paid</p>
              </td>
              <td class='context'>
                <input type='text' name='pay_price[]' class='pay_price'  value=''/>
                <input type='hidden' name='pay_id[]' value=''/>
                <input type='hidden' name='pay_user[]' value='<?php $this->user->getUserName(); ?>'/>            
              </td>
              <td class='label'>
                Pay Date
              </td>
              <td class='context'>
                <input type='text' class='date_pick' name='pay_date[]' value=''/>
                <span></span>
              </td>
            </tr>
            <tr>
              <td class='label'>
                Method
              </td>
              <td class='context'>
                <select name='pay_method[]'>
                  <option value="check" selected>check</option>
                  <option value="card">card</option>
                  <option value="cash">cash</option>
                  <option value="credit">credit</option>
                </select>
              </td>
              <td class='label'>
                chk.no
              </td>
              <td class='context'>
                <input type='text' name='pay_num[]' value=''/>
                <p class='plus' style='float:right;margin:0px;margin-right:2px;' />
              </td>
            </tr>
        <?php
        }else{ // count($pay)
          foreach($pay as $row){
        ?>
            <tr><td colspan='4' style='background-color:orange; height:3px;'></td></tr>
            <tr>
              <td class='label'>
                <p class='del' style='float:left;margin:0px;margin-left:2px;'></p>
                <p style='margin:0px;'>Paid</p>
              </td>
              <td class='context'>
                <input type='hidden' name='pay_id[]' value='<?php echo $row['id']; ?>'/>
                <input type='text' name='pay_price[]' class='pay_price'  value='<?php echo $row['pay_price']; ?>'/>
                <input type='hidden' name='pay_user[]' value='<?php echo $row['pay_user']; ?>'/>
              </td>
              <td class='label'>
                Pay Date
              </td>
              <td class='context'>
                <input type='text' class='date_pick' name='pay_date[]' value='<?php echo $row['pay_date']; ?>'/>
                <?php 
                  $pdt = new DateTime($row['pay_date']);
                  $diff = $odt->diff($pdt);
                  echo "<font color='red'>+" . $diff->format('%d') . "</font>";
                ?>
                <span></span>
              </td>
            </tr>
            <tr>
              <td class='label'>
                Method
              </td>
              <td class='context'>
                <select name='pay_method[]'>
                <?php
                if(strtolower($row['pay_method']) == 'card'){
                  echo '<option value="credit" selected>card</option>';
                }else{
                  echo '<option value="credit">card</option>';
                }
                if(strtolower($row['pay_method']) == 'check'){
                  echo '<option value="check" selected>check</option>';
                }else{
                  echo '<option value="check">check</option>';
                }
                if(strtolower($row['pay_method']) == 'cash'){
                  echo '<option value="cash" selected>cash</option>';
                }else{
                  echo '<option value="cash">cash</option>';
                }
                if(strtolower($row['pay_method']) == 'credit'){
                  echo '<option value="etc" selected>credit</option>';
                }else{
                  echo '<option value="etc">credit</option>';
                }
                ?>
                </select>
              </td>
              <td class='label'>
                chk.no
              </td>
              <td class='context'>
                <input type='text' name='pay_num[]' value='<?php echo $row['pay_num']; ?>'/>
                <p class='plus' style='float:right;margin:0px;margin-right:2px;' />
              </td>
            </tr>

        <?php
          }  // foreach
        } // endif count($pay) == 0 
        ?>
                        
          </table>
          <!--span id='return_history' class='small_btn'>Return History</span>
          <span id='pay_history' class='small_btn'>Payment History</span-->
        </div>
        <!-- end of payment -->
        
        <!-- return info -->
        <!--div id='return'>
          block return history null
        </div-->
        <!-- end of return -->
      </div>
      
    </div>
    

<style>
  #order table {
    margin-top:10px;
  }
  
  #order thead {
    background-color: #e2e2e2;
  }            
  #order thead td {
    text-align:center;
    font-size:14px;
  }
  #order tbody td {
    text-align:right;
    cellpadding:0px;
    cellspacing:0px;
 }
 
#order table .nolborder{
  border-left : 0px;
  border-top : 0px;
  border-bottom : 0px;
  border-style:none;
  background-color:white;
}

#order .product_name{
  width:300px;
  text-align:center;
}

</style>
    <!-- order info -->
    <div id='order'>
    <?php
      $aCat = $this->config->ubpCategory();
      foreach($aCat as $k => $v){
        if(!isset($sales[$k])){
          $sales[$k] = array();
        }
        
        if(0 == count($sales[$k])){
          $printClass = 'np';
        }else{
          $printClass = 'p';        
        }
    ?>
      <?php
      if(count($sales[$k]) != 0){
      ?>

      <table id='<?php echo $k; ?>' border='1' cellpadding="0" cellspacing="0"  class='<?php echo $printClass; ?>'>
        <thead>
        <tr>
          <td class='nostyle np'></td>
          <td style='color:orange;'><strong><?php echo $v; ?></strong></td>
          <td>Name</td>
          <td>Pcs</td>
          <td>STOCK</td>
          <td>QTY</td>
          <td>FREE</td>
          <td>DMGE</td>
          <td>RATE</td>
          <td>D/C</td>
          <td>TOTAL</td>
          <td class='nostyle np'></td>
        </tr>
        </thead>
        <tbody>
        <?php
          foreach($sales[$k] as $sale){
            if($sale['image']){
              $style = "style='visibility:visible'";
            }else{
              $style = "style='visibility:hidden'";
            }
            /*
            $namePtn = "/([A-Za-z0-9]*) ([A-Za-z0-9]*) (.*)/";
            preg_match_all($namePtn,trim($sale['product_name']),$match);
            if(isset($match[3][0])){
              $sale['product_name'] = $match[3][0];
            }
            */
            $imgUrl = HTTP_SERVER2 . 'image/' . $sale['image'];
          ?>
          <tr>
            <td class='del nostyle'>
            </td>
            <td style='text-align:left;width:120px;'>
              <input type='text' class='atc' name='model[]' value='<?php echo $sale['model']; ?>' style='width:60px;' />
              <input type='hidden' name='product_id[]' value='<?php echo $sale['product_id']; ?>'/>
              <!-- todo. need not to add image[] mightbe , besso-201103 -->
              <input type='hidden' name='image[]' value='<?php echo HTTP_SERVER2 . "image/" .$sale['image']; ?>'/>
              <input type='hidden' name='weight[]' value='<?php echo $sale['ups_weight']; ?>'/>
              <a href='#' title='<?php echo $imgUrl; ?>' id='preview'>
                <img src='view/image/preview.jpg' class='np'/>
              </a>
            </td>
            <td class='product_name' style='text-align:left;padding-left:5px;'>
              <?php echo $sale['product_name']; ?>
            </td>
            <td class='pc'>
              <?php echo $sale['pc']; ?>
            </td>
            <td>
              <input type='text' name='stock[]' value='<?php echo $sale['quantity']; ?>' size=3 />
            </td>
            <td>
              <input type='text' name='cnt[]' value='<?php echo $sale['order_quantity']; ?>' size=2 />
            </td>
            <td>
              <input type='text' name='free[]' value='<?php echo $sale['free']; ?>' size=2 />
            </td>
            <td>
              <input type='text' name='damage[]' value='<?php echo $sale['damage']; ?>' size=2 />
            </td>
            <td>
              <input type='text' name='price[]' value='<?php echo $sale['price1']; ?>' size=5/>
            </td>
            <td>
              <input type='text' class='discount' name='discount[]' value='<?php echo $sale['discount']; ?>'size=2 />%
            </td>
            <td>
              <input type='text' class='total_price' name='total_price[]' value='<?php echo $sale['total_price']; ?>' size=5 />
              <input type='hidden' name='weight_row[]' value='<?php echo $sale['weight_row']; ?>'/>
            </td>
            <td class='plus nostyle'>
            </td>
          </tr>
          <?php
          } // inner roof
        ?>
        </tbody>        
      </table>
      <?php
      } // if case of having contents
      ?>
      <br/>
      <?php 
      } // end foreach
      ?>
    </div>
  </div>
  </form>
  <div class='footer'>
  </div>
</div>
<?php echo $footer; ?>

<!-- common detail div -->
<div id='detail' class='ui-widget-content'></div>

<!-- Google map showing -->
<style>

#hide_googlemap {
  position:absolute;
  visibility : hidden;
  width:100px;
  height:30px;
  background-color:black;
  color:white;
  font-size:20px;
  font-weight:3px;
  top:100px;
  left:850px;
  cursor:pointer;
  text-align:center;
}
</style>
<div id="map_canvas"></div>
<div id='hide_googlemap'>Close Map</div>

<style>
.tipsy{ padding:5px; font-size:10px; position: absolute; z-index: 100000; }
.tipsy-inner{
  padding: 5px 8px 4px 8px; background-color: black; color: white; max-width: 200px; text-align: center; 
  font-size:14px;
}
.tipsy-inner { border-radius: 3px; -moz-border-radius:3px; -webkit-border-radius:3px; }
.tipsy-arrow { position: absolute; background: url('../images/tipsy.gif') no-repeat top left; width: 9px; height: 5px; }
.tipsy-n .tipsy-arrow { top: 0; left: 50%; margin-left: -4px; }
.tipsy-nw .tipsy-arrow { top: 0; left: 10px; }
.tipsy-ne .tipsy-arrow { top: 0; right: 10px; }
.tipsy-s .tipsy-arrow { bottom: 0; left: 50%; margin-left: -4px; background-position: bottom left; }
.tipsy-sw .tipsy-arrow { bottom: 0; left: 10px; background-position: bottom left; }
.tipsy-se .tipsy-arrow { bottom: 0; right: 10px; background-position: bottom left; }
.tipsy-e .tipsy-arrow { top: 50%; margin-top: -4px; right: 0; width: 5px; height: 9px; background-position: top right; }
.tipsy-w .tipsy-arrow { top: 50%; margin-top: -4px; left: 0; width: 5px; height: 9px; }
</style>

<!--external link for google map--> 
<script type="text/javascript" src="view/javascript/jquery/jquery.tipsy.js"></script>
<!--script type="text/javascript" src="view/template/sales/order.js"></script-->

<style>
#help_content{
  position:absolute;
  top:100px;
  left:100px;
  background-color:#999999;
  color:white;
  visibility:hidden;
}
</style>

<script>
$(document).ready(function(){
  // use name as amount instead of order_price used in #order
  var $ele_amount = $('#payment').find('input[name=order_price]'),
      $ele_balance = $('#payment').find('input[name=balance]'),
      $ele_payed_sum = $('#payment').find('input[name=payed_sum]'),
      $ele_order_date = $('#storeinfo').find('input[name=order_date]'),
      $aProductLocked = new Array(),
      $aInventoryReleased = new Array();
  // define locked product_id as array

  $('input[readonly]').css('background-color','#e3e3e3');
  $('select[disabled]').css('background-color','#e3e3e3');

  $('#save').bind('click',function(e){
    alert('To be done Later');
  });
  
  /************* block all js control
  $('#storeinfo #findstore').click(function(){
    $.fn.storeSubmit();
  });
  $('#storeinfo input[name=\'store_name\']').keydown(function(e){
    if(e.keyCode == 13){
      $.fn.storeSubmit();
    }
  });
  $('#storeinfo input[name=\'accountno\']').keydown(function(e){
    if(e.keyCode == 13){
      $.fn.storeSubmit();
    }
  });
  $.fn.storeSubmit = function(){
    var param = '&foo=var';
  	var store_name = $('input[name=\'store_name\']').attr('value');
  	if(store_name){
  		param += '&filter_name=' + encodeURIComponent(store_name);
  	}      
  	var accountno = $('input[name=\'accountno\']').attr('value');
  	if(accountno){
  		param += '&filter_accountno=' + encodeURIComponent(accountno);
  	}      
  	var address1 = $('input[name=\'address1\']').attr('value');
  	if(address1){
  		param += '&filter_address1=' + encodeURIComponent(address1);
  	}      
  	var city = $('input[name=\'city\']').attr('value');
  	if(city){
  		param += '&filter_city=' + encodeURIComponent(city);
  	} 
  	var state = $('input[name=\'state\']').attr('value');
  	if(state){
  		param += '&filter_state=' + encodeURIComponent(state);
  	}  
  	var zipcode = $('input[name=\'zipcode\']').attr('value');
  	if(zipcode){
  		param += '&filter_zipcode=' + encodeURIComponent(zipcode);
  	}
    var storetype = $('select[name=\'storetype\']').attr('value');
  	if (storetype != ''){
	    param += '&filter_storetype=' + encodeURIComponent(storetype);
  	}    	
  	var phone1 = $('input[name=\'phone1\']').attr('value');
  	if(phone1){
  		param += '&filter_phone1=' + encodeURIComponent(phone1);
  	}
  	var phone2 = $('input[name=\'phone2\']').attr('value');
  	if(phone2){
  		param += '&filter_phone2=' + encodeURIComponent(phone2);
  	}
  	var salesrep = $('input[name=\'salesrep\']').attr('value');
  	if(salesrep){
  		param += '&filter_salesrep=' + encodeURIComponent(salesrep);
  	}
    $.ajax({
      type:'get',
      url:'<?php echo HTTP_SERVER; ?>/index.php?route=store/lookup/callback&token=<?php echo $token; ?>',
      dataType:'html',
      data:param,
      success:function(html){
        //console.log('success : ' + html);
        $cssMap = {
          'visibility':'visible',
          'left':'50px'
        }
        $('#detail').css($cssMap);
        $('#detail').html(html);
        $('#detail').draggable(); 
      },
      fail:function(){
        //console.log('fail : no response from proxy');
      }
    });
  }
  ***/  // find store
  
  /*** block google map for performance issue temporarily, besso    
  $("#googlemap").click(
    function(){
      // Google map
      if($('input[name=\'address1\']').attr('value') != ''){
        var addr4map = $('input[name=\'address1\']').attr('value') + ' ' + $('input[name=\'city\']').attr('value') + ' ' + $('input[name=\'state\']').attr('value');
        var mapList = [addr4map];
        if(mapList.length > 0){
          
          var mapCssMap = { 
            "visibility":"visible",
            "position":"absolute",
            "width":'750px',
            "height":"500px",
            "top":'100px',
            "left":"100px",
            "z-index":"30"
          } 
  
          $("#map_canvas").css(
            mapCssMap
          );
          $("#hide_googlemap").css('visibility','visible');
          $("#map_canvas").simplemap({ 
        		classModifier: "simplemaps",
        		addressList: mapList,
        		zoom: 11
          });
  
          $('#hide_googlemap').bind('click',function(e){ 
            $('#map_canvas').css('visibility','hidden');
            $('#hide_googlemap').css('visibility','hidden');
          });   
  
        }
      }
  });
  // Google map
  ***/


  // date picker binding
  $('#form').bind('focusin',function(event){
    var $tgt = $(event.target);
    if($tgt.is('input.date_pick')){
      $(".date_pick").datePicker({
        clickInput:true,
        createButton:false,
        startDate:'2000-01-01'
      });
    }
  });

  /****
  // automatically show how many days be passed from order_date
  $('#payment').bind('change',function(event){
    var $tgt = $(event.target);
    if($tgt.is('#payment input.date_pick')){
      order_date = $ele_order_date.val();
      pay_date = $tgt.val();
      $diff_days = $.fn.calculateDiffDays(order_date,pay_date);
      $tgt.parent('td').find('span').css('color','red');      
      $tgt.parent('td').find('span').html( '+' + $diff_days );
    }
  });

  // todo. move to lib. common lib to calculate date difference
  $.fn.calculateDiffDays = function(day1,day2){
    d1 = $.fn.parseDate(day1);
    d2 = $.fn.parseDate(day2);
    dd = (d2-d1)/(1000*60*60*24); 
    return parseInt(dd);
  };
  
  $.fn.parseDate = function(date){
    var Ymd = date.split('-');
    return new Date(Ymd[0],Ymd[1],Ymd[2]);
  };

  // Dynamic row binding , shipment
  $('#ship>table').mouseover(function(event){
    var $tgt = $(event.target),
        $pnt = $tgt.parents('tr');
    if($tgt.is('p.plus') && $pnt.is('tr') ){
      $tgt.css('background', 'url(\'view/image/plus_icn.jpg\') no-repeat');
    }
    if($tgt.is('p.del') && $pnt.is('tr')){
      if($pnt[0].rowIndex != 2){
        $tgt.css('background', 'url(\'view/image/del_icn.jpg\') no-repeat');
      }
    }
  });

  $('#ship>table').mouseout(function(event){
    var $tgt = $(event.target),
        $pnt = $tgt.parents('tr');
    if($tgt.is('p.plus')){
      $tgt.css('background', 'url(\'\') no-repeat');
    }
    if($tgt.is('p.del') && $pnt.is('tr')){
      if($pnt[0].rowIndex != 2){
        $tgt.css('background', 'url(\'\') no-repeat');
      }else{
        $tgt.css('cursor','default');
      }
    }
  });

  // todo. border-bottom not work correctly , besso-201103 
  var $newShipRow = "<tr><td colspan='4' style='background-color:orange; height:3px;'></td></tr><tr><td class='label'><p class='del' style='float:left;margin:0px;margin-left:2px;'></p><p style='margin:0px;'>APP</p></td><td class='context' colspan='3'><input type='hidden' name='ship_id[]' value=''/><input type='text' class='date_pick' name='ship_appointment[]' value='' style='width:40%'/></td></tr><tr><td colspan=4><textarea name='ship_comment[]' value='' style='width:95%;height:30px;'/></textarea></td></tr><tr><td class=label>SHIP</td><td class=context><select name=method[]><option value='truck' selected>truck</option><option value='ups'>ups</option><option value='cod'>cod</option><option value='self'>self</option><option value='etc'>etc</option></select></td><td class=label>DATE</td><td class=context><input type=text class='date_pick' name=ship_date[] value='' style='width:40%' /></tr><tr><td class=label>LIFT</td><td class=context><input type=text name=lift[] value='' size=5 /></td><td class=label>COD</td><td class=context><input type=text name=cod[] value='' size=5 /><p class=plus style='float:right;margin:0px;margin-right:2px;' /><input type='hidden' name='ship_user[]' value='<?php echo $this->user->getUserName(); ?>' /></td></tr>";  
  $('#ship').click(function(event){
    var $tgt = $(event.target),
        $pnt = $tgt.parents('tr');
    if($tgt.is('p.plus') && $pnt.is('tr') ){
      $tgt.parent().parent().after($newShipRow);
      $tgt.parent().parent().next().css('border-top','2px solid orange');
    }
    if( $tgt.is('p.del') && $pnt.is('tr') ){
      if($pnt[0].rowIndex != 2){
        $tgt.parent().parent().prev().prev().prev().prev().remove();
        $tgt.parent().parent().prev().prev().prev().remove();
        $tgt.parent().parent().prev().prev().remove();
        $tgt.parent().parent().prev().remove();
        $tgt.parent().parent().remove();
      }else{
        $tgt.css('cursor','default');
      }
    }
  });

  // payment dhtml
  $('#payment').mouseover(function(event){
    var $tgt = $(event.target),
        $pnt = $tgt.parents('tr');
    if($tgt.is('p.plus') && $pnt.is('tr') ){
      $tgt.css('background', 'url(\'view/image/plus_icn.jpg\') no-repeat');
    }
    if($tgt.is('p.del') && $pnt.is('tr') ){
      if($pnt[0].rowIndex != 2){
        $tgt.css('background', 'url(\'view/image/del_icn.jpg\') no-repeat');
      }else{
        $tgt.css('cursor','default');
      }
    }
  });

  $('#payment').mouseout(function(event){
    var $tgt = $(event.target),$pnt = $tgt.parents('tr');
    if($tgt.is('p.plus') && $pnt.is('tr') ){
      $tgt.css('background', 'url(\'\') no-repeat');
    }
    if($tgt.is('p.del') && $pnt.is('tr') ){
      if($pnt[0].rowIndex != 2){
        $tgt.css('background', 'url(\'\') no-repeat');
      }else{
        $tgt.css('cursor','default');
      }
    }
  });

  // todo. border-bottom not work correctly , besso-201103 
  var $newPayRow = "<tr><td colspan='4' style='background-color:orange; height:3px;'></td></tr><tr><td class='label'><p class='del' style='float:left;margin:0px;margin-left:2px;'></p><p style='margin:0px;'>Paid</p></td><td class='context'><input type='hidden' name='pay_id[]' value=''/><input type='text' name='pay_price[]' class='pay_price'  value=''/><input type='hidden' name='pay_user[]' value='besso'/></td><td class='label'>Pay Date</td><td class='context'><input type='text' class='date_pick' name='pay_date[]' value=''/></td></tr><tr><td class='label'>Method</td><td class='context'><select name='pay_method[]'><option value='card'>card</option><option value='check' selected>check</option><option value='cash'>cash</option><option value='credit'>credit</option></select></td><td class='label'>chk.no</td><td class='context'><input type='text' name='pay_num[]' value=''/><p class='plus' style='float:right;margin:0px;margin-right:2px;' /></td></tr>";
  $('#payment').click(function(event){
    var $tgt = $(event.target),$pnt = $tgt.parents('tr');
    if($tgt.is('p.plus') && $pnt.is('tr') ){
      $tgt.parent().parent().after($newPayRow);
      $tgt.parent().parent().next().css('border-top','2px solid orange');
    }

    if($tgt.is('p.del') && $pnt.is('tr') ){
      if($pnt[0].rowIndex != 2){
        $tgt.parent().parent().prev().prev().remove();
        $tgt.parent().parent().prev().remove();
        $tgt.parent().parent().remove();

        $payed = $tgt.parents('tr').find('.pay_price').val();
        $payed_sum = parseFloat($ele_payed_sum.val()) - parseFloat($payed);

        $ele_payed_sum.val($payed_sum);
        $balance = parseFloat($ele_amount.val()) - parseFloat($ele_payed_sum.val());
        $ele_balance.val($balance);
        
        // tune balance 
        if(false == $.fn.validateAR()){
          alert('AR Problem, all stop and ask IT team');
        }
      }
    }
  });
  // end of payment binding

  $.fn.validateAR = function(){
    // check Amount correct
    var $orderNode = $('#order').find("input[name='total_price[]']"),
        $order_price = 0;
    for($i=0; $i<$orderNode.length; $i++){
      if("" == $orderNode[$i].value){
        $orderNode[$i].value = 0;
      }
      $order_price += parseFloat($orderNode[$i].value);
    }
    if( $order_price != parseFloat($ele_amount.attr('value')) ){
      return false;
    }
    
    if(parseFloat($ele_amount.val()) != ( parseFloat($ele_balance.val()) + parseFloat($ele_payed_sum.val()) ) ){
      return false;    
    }
    return true;
  }

  // #order section
  // atc
  $('#order').bind('mousedown',function(event){
    var $tgt = $(event.target),
        $mama = $tgt.parents('table'),
        $cat = $mama.attr('id'),
        $atcObject = $mama.find('input.atc'),
        $ele_store = $('#storeinfo').find('input[name=store_id]');

    if($atcObject.is('input.atc')){
      if(false == $.fn.validateNull($ele_store)) return;
      $atcObject.autoComplete({cat:$cat});
    }
  });
  // atc-end

  // Dynamic row binding , order
  $('#order').mouseover(function(event){
    var $tgt = $(event.target);
    if($tgt.is('td.plus')){
      $tgt.css('background', 'url(\'view/image/plus_icn.jpg\') no-repeat');
    }
    $trCnt = $tgt.parent().parent().children().length;
    //if($tgt.is('td.del') && $trCnt > 1){
    // todo. temporarily release first row distriction, , besso-201103 
    if($tgt.is('td.del')){
      $tgt.css('background', 'url(\'view/image/del_icn.jpg\') no-repeat');
    }

    // tooltip.show each price
    if($tgt.is('input[name="price[]"]')){
      $count = $tgt.parents('tr').find('.pc').html();
      $price = $tgt.val();
      
      if( '' != $count && '' != $price){
        $eaPrice = parseFloat( ( parseFloat($price) / parseInt($count) ) , 2 ); 
        $tgt.attr('original-title',$eaPrice);
        $tgt.tipsy();
      }
    }
  });

  $('#order').mouseout(function(event){
    var $tgt = $(event.target);
    
    if($tgt.is('td.plus')){
      $tgt.css('background', 'url(\'\') no-repeat');
    }
    if($tgt.is('td.del')){
      $tgt.css('background', 'url(\'\') no-repeat');
    }
  });

  var $newRow = "<tr><td class=\"del nostyle\"></td><td style=text-align:left;><input type=text class=atc name=model[] style=width:60px; /><input type=hidden name=image[] value='' /><input type=hidden name=product_id[] value='' /><input type=hidden name=weight[] value='' /><a href='#' title='' id='preview' style='visibility:hidden;'><img src=view/image/preview.jpg id='preview' class='np'/></a></td><td class='product_name'></td><td class='pc'></td><td><input type=text name=stock[] size=3 /></td><td><input type=text name=cnt[] value=0 size=2 /></td><td><input type=text name=free[] value=0 size=2 /></td><td><input type=text name=damage[] value=0 size=2 /></td><td><input type=text name=price[] value=0 size=5/></td><td><input type=text name=discount[] value=0 size=2 />% </td><td><input type=text name=total_price[] value=0 class=total_price size=4 /><input type=hidden name=weight_row[] value='' /></td><td class=\"plus nostyle\"></td></tr>";
  //var $clickNode = $('#order table .plus').parent();   // it can be used for both plus / del
  var $clickNode = $('#order table tr');   // it can be used for both plus / del

  $('#order').click(function(event){
    var $tgt = $(event.target);

    // tooltip.display image
    if($tgt.is('img')){
      event.preventDefault();
      $imgUrl = $tgt.parents('#preview').attr('title');
      html  = "<a onclick=\"$('#detail').html();$('#detail').css('visibility','hidden');\" class=\"button\"><span>Close</span></a><br/>";
      html += '<img src=' + $imgUrl + ' />';  

      $p = $tgt.position();
      $imgCss = {
        'visibility':'visible',
        'width':'500px',
        'height':'520px',
        'top':$p.top - 200,
        'left':$p.left
      }
      $('#detail').css($imgCss);
      $('#detail').html(html);
      $('#detail').draggable();
    }

    if($tgt.is('td.plus')){
      $tgt.parent().after($newRow);
    }

    $trCnt = $tgt.parent().parent().children().length;
    if( $tgt.is('td.del') && $trCnt > 1 ){
      // minus calculation
      var $node = $tgt.parents('tr');
      
      // inventory consistency
      $product_id = $node.find('input[name="product_id[]"]').val();
      $stock = parseInt($node.find('input[name="stock[]"]').val());
      if($product_id && $stock) $aInventoryReleased.push(new Array($product_id,$stock));
      
      //debugger;
      
      $total_price= parseFloat($node.find('input[name="total_price[]"]').attr('value'));

      // weight
      $weight_row = $node.find('input[name="weight_row[]"]').attr('value');
      $weight_sum = parseFloat( $('#ship').find('input[name="weight_sum"]').attr('value') ) - parseFloat($weight_row);
      $('#ship').find('input[name="weight_sum"]').val($weight_sum);

      // amount
      $order_price = parseFloat( $ele_amount.attr('value') ) - parseFloat($total_price);
      $ele_amount.val($order_price);

      $balance = parseFloat($order_price) - parseFloat($ele_payed_sum.val());
      $ele_balance.val($balance);

      $tgt.parent().remove();

      // tune balance 
      if(false == $.fn.validateAR()){
        alert('AR Problem, all stop and ask IT team');
      }
    }

    if($tgt.is('input')){
      $tgt.select();
    }
  });
  *********/
  
  /***** todo . comment out . free good should be calculated for whole sum
  // freegood blur 
  // todo. it's not restricted strongly, wicked input can make it thru , besso-201103 
  $('#order').bind('change',function(event){
    var $tgt = $(event.target);
    if($tgt.is('input[name="free[]"]')){
      var $node = $tgt.parents('tr'),
          $countObj = $node.find('input[name="cnt[]"]'),
          $cnt = $countObj.attr('value'),
          $freeLimit = 10;
      if( ($freeLimit * parseInt($tgt.attr('value'))) > parseInt($cnt) ){
        alert('freegood must not over ' + $freeLimit + ' %');
        return;
      }
    }
  });
  *****/
  
  /*******
  // generate total price
  $('#order').bind('focusin',function(event){
    var $tgt = $(event.target);
    if($tgt.is('input.total_price')){
      var $node = $tgt.parents('tr'),
      $stock = $node.find('input[name="stock[]"]').attr('value'),
      $countObj = $node.find('input[name="cnt[]"]'),
      $price = parseFloat($node.find('input[name="price[]"]').attr('value')),
      $weight= $node.find('input[name="weight[]"]').attr('value'),
      $freeObj= $node.find('input[name="free[]"]'),
      $damageObj= $node.find('input[name="damage[]"]'),
      $discountObj = $node.find('input[name="discount[]"]');

      var $free = '0',
          $damage = '0',
          $count = '0',
          $discount = '0',
          $weight_row = '0';

      if("" == $freeObj.attr('value')) $freeObj.val('0');
      $free = $freeObj.attr('value');

      if("" == $damageObj.attr('value')) $damageObj.val('0');
      $damage = $damageObj.attr('value');


      // todo. it's ok to change with verifyNull , besso-201103 
      if( ("" == $countObj.attr('value') || "0" == $countObj.attr('value')) && 
          ("" == $freeObj.attr('value') || "0" == $freeObj.attr('value')) && 
          ("" == $damageObj.attr('value') || "0" == $damageObj.attr('value'))
      ){
        
        alert('Quantity to sell !');
        return;
      }else{
        $count = $countObj.attr('value');
      }

      // computer bad math problem make weird precision !! , besso-201103 
      if("" == $discountObj.attr('value')) $discountObj.val('0');
      $discount = $discountObj.attr('value');
      if("0.00" == $discount){
        var $total = parseFloat( ($price * $count));
      }else{
        var $total = parseFloat( $price * $count * ((100-$discount) / 100) );
      }
      $total = $total.toFixed(2);
      var $quantity = $stock - $count;
      $node.find('input[name="total_price[]"]').val($total);
      $node.find('input[name="stock[]"]').val($quantity);

      // weight
      $weight_row = parseFloat($count) * parseFloat($weight); 
      $weight_row += parseFloat($free) * parseFloat($weight); 
      $weight_row += parseFloat($damage) * parseFloat($weight); 
      $node.find('input[name="weight_row[]"]').val($weight_row);
      
      // todo. need to test severely later , besso-201103
      var $orderNode = $('#order').find("input[name='total_price[]']");
      $order_price = 0;
      for($i=0; $i<$orderNode.length; $i++){
        if("" == $orderNode[$i].value){
          $orderNode[$i].value = 0;
        }
        $order_price += parseFloat($orderNode[$i].value);
      }
      $ele_amount.val($order_price);
      
      $balance = parseFloat($order_price) - parseFloat($ele_payed_sum.val());
      $ele_balance.val($balance);

      // todo. weight need to test severely later , besso-201103
      var $weightNode = $('#order').find("input[name='weight_row[]']");
      $weight_sum = 0;
      for($i=0; $i<$weightNode.length; $i++){
        if("" == $weightNode[$i].value){
          $weightNode[$i].value = 0;
        }
        $weight_sum += parseFloat($weightNode[$i].value);
      }
      $('#ship').find('input[name="weight_sum"]').val($weight_sum);

      $tgt.removeClass('total_price');
      $tgt.addClass('done');

      // tune balance 
      if(false == $.fn.validateAR()){
        alert('AR Problem, all stop and ask IT team');
      }
    }
  });

  // make key move like excel
  $('#order').keydown(function(event){
  //$('#order>table>tbody>tr input').keydown(function(event){ 
    var $tgt = $(event.target);
    // 38 up, 40 down, 37 left, 39 right
    if((('37' == event.which) || ('39' == event.which) ||
        ('38' == event.which) || ('40' == event.which) )
        && $tgt.is('input')){
//        && 'cnt[]' == $tgt.attr('name')){

      //console.log(event.which);
      var $tgtName = 'input[name="' + $tgt.attr('name') + '"]',
          $pntTR = $tgt.parents('tr'),
          $pntTD = $tgt.parents('td'),
          //$downTgt = $pntTR.next().find($tgtName),
          // todo. keep the cnt only for keydown one , besso-201103 
          $downTgt = $pntTR.next().find('input[name="cnt[]"]'),
          $upTgt = $pntTR.prev().find($tgtName),
          $rightTgt = $pntTD.next().find('input'),
          $leftTgt = $pntTD.prev().find('input');

      if('37' == event.which){
        $leftTgt.select();
      }
      if('39' == event.which){
        $rightTgt.select();
      }
      if('38' == event.which){
        $upTgt.select();
      }
      if('40' == event.which){
        $downTgt.select();
      }
    }

  });

  $.fn.validateNull = function(obj){
    if(obj.attr('value') == ''){
      alert('fill value : ' + obj.attr('name'));
      obj.css('background-color','red');
      return false;
    }
  }
  
  // 
  $('#save').bind('click',function(e){
    var $ddl = $('#form').find('input[name=ddl]');

    var $salesrep = $('#storeinfo').find('input[name=salesrep]'),
        $store_id = $('#form').find('input[name=store_id]'),
        $accountno = $('#storeinfo').find('input[name=accountno]'),
        $txid = $('#form').find('input[name=txid]'),
        $weight_sum = $('#form').find('input[name=weight_sum]');
    
    if(false == $.fn.validateNull($accountno)) return;
    if(false == $.fn.validateNull($ele_order_date)) return;
    if(false == $.fn.validateNull($salesrep)) return;
    if(false == $.fn.validateNull($store_id)) return;

    if('insert' == $ddl.attr('value')){
      // saveOrder - txid : JH20110323-IL0004-01
      // same variable mapping >.,<
      $salesrep = $salesrep.attr('value').substring(0,2).toUpperCase();
      $ymd = $ele_order_date.attr('value').substring(0,4) + $ele_order_date.attr('value').substring(5,7) + $ele_order_date.attr('value').substring(8,10);
      $accountno = $accountno.attr('value');

      $vTxid = $salesrep + $ymd + '-' + $accountno;
      $txid.val($vTxid);  // todo. it not work under below if case. crop

      // insert, firstly check already exsit txid
      $ddl.val('insert');
      //console.log('txid : ' + $vTxid);  

      $.ajax({
        type:'get',
        url:'/backyard/index.php?route=sales/order/verify_txid',
        dataType:'json',
        data:'token=<?php echo $token; ?>&txid=' + $vTxid,
        success:function(list){
          // var list = ['BE20110324-FL4545-01','BE20110324-FL4545-02'];
          // hack for malformed json
          // console.log('success : ' + list);
          if(list != null){
            $('#detail').html('');
            $('#detail').css('visibility','visible');
            $('#detail').css('background','orange');
            $('#detail').css('padding','10px');
            $('#detail').css('list-style','none');
            $('#detail').append('<font color=red>Update below or ...</font>');
            $('#detail').append('You need to check these txid before saving !!');
            $.each(list,function(idx,val){
              $url = '/backyard/index.php?route=sales/order&token=<?php echo $token; ?>&txid=' + val['txid'];
              $html = '<li><a href=' + $url + '>' + val['txid'] + '</a></li>';
              $('#detail').append($html);
            });
            $('#detail').append('<a onclick="$(\'#detail\').css(\'visibility\',\'hidden\'); $(\'#detail\').html(\'\'); $(\'#form\').submit();"><strong>CLOSE</strong></a>');
            $('#detail strong').css('float','right');
            $('#detail').draggable(); 
          }else{
            // todo. strongly need to exclude any gabage post, , besso-201103 
            //console.log('form submit for no existing txid');
            $('#form').submit();
            return false;
          }
          
          // basic code done, need to test with real DB later , besso-201103 
        },
        fail:function(){
          //console.log('fail : no response from proxy');
        }
      });

    }else{
      $ddl.val('update');      
      $('#form').submit();
    }
  });

  // payed sum and balace process
  $('#payment').bind('focusout',function(event){
    var $tgt = $(event.target);
    if($tgt.is('input.pay_price')){

      //$default_val = $tgt['context'].defaultValue;
      $default_val = $tgt['context'].defaultValue;

      // init , default val , besso-201103 
      if('' == $default_val) $before_val = 0;
      
      // JS do not support value history except defaultValue, custom go , besso-201103 
      if(typeof $before_val != 'undefined'){
        $default_val = $before_val;
      }
      $changed_val = $tgt['context'].value;
      $added_val = ( parseFloat($changed_val) - parseFloat($default_val) );
      $added_val.toFixed(2);

      // JS do not support value history except defaultValue, custom go , besso-201103 
      $before_val = $changed_val;
      
      if($default_val != $changed_val){
        var $payed_sum =  $ele_payed_sum.val();

        $sum = parseFloat($payed_sum) + parseFloat($added_val);
        $sum.toFixed(2);
        
        if( parseFloat($sum) > $ele_amount.val()){
          alert('Paid-Price cannot over Order-Price');
          $tgt.val($tgt[0].defaultValue);
          $tgt.focus();
          return;
        }
        $ele_payed_sum.val($sum);

        $balance = $ele_amount.val() - $sum;
        $balance = $balance.toFixed(2);
        $ele_balance.val($balance);
     }
    }
  });
  *********/
  
});

function printOrder(){
  self.focus();
  self.print();
}
</script>