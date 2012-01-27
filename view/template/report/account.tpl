<style>
@media print {
  body, td, th, input, select, textarea, option, optgroup {
    font-size: 14px;
  }
  #header,#menu,#footer{
    display:none;
  }
  #content .left,.right{
    display:none;
  }
  #content .heading div.buttons{
    display:none;
  }
  .np{
    display:none;
  }
} 
</style>
<?php
  $heading_title = 'Montly';
  $export = '';
  $lnk_action = '';
?>
<?php echo $header; ?>
<?php if($error_warning){ ?>
<div class="warning"><?php echo $error_warning; ?></div>
<?php } ?>
<?php if ($success){ ?>
<div class="success"><?php echo $success; ?></div>
<?php } ?>

<!-- atc -->
<script type='text/javascript' src='view/template/report/atc/jquery/jquery.metadata.js'></script>
<script type='text/javascript' src='view/template/report/atc/src/jquery.auto-complete.js'></script>
<link rel='stylesheet' type='text/css' href='view/template/report/atc/src/jquery.auto-complete.css' />

<style>
.box {
  z-index:10;
}
.content .name_in_list{
  color:purple;
  cursor:pointer;
}
#detail{
  position : absolute;
  top: 100px;
  left: 100px;
  visibility:hidden;
  border: 1px dotted green;
  z-index:2;
}
#content{
  width:900px;
}
.box .content{
  border:none;
}
</style>

<div class="box">
  <div class="left"></div>
  <div class="right"></div>
  <div class="heading">
    <h1>Account</h1>
    <h1 style='float:right;'>
      <a href="index.php?route=common/home">Basic</a>
      &nbsp;
      <a href="index.php?route=report/product">Product</a>
    </h1>
  </div>

  <div class="content">
    <table class="list">
      <tbody>
        <tr class="filter np">
          <td class="center" colspan='10' style='width:120px'>
            <input type=text name='filter_accountno' style='background-color:peru;' class='atc' /> ( mouse not work )
          </td>
        </tr>
        <tr style='height:20px'><td colspan='10'></td></tr>



          <tr style='height:20px'>
            <td colspan='10'>
              <h2 style='display:inline'><?php echo $accountno ?></h2>
            </td>
          </tr>
          <?php 
          if( count($stat) > 0 ){ 
          ?>
          <tr style='background-color:#e2e2e2;'>
            <td class="center" colspan=8>Txid</td>
            <td class="center" colspan=1>Order Date</td>
            <td class="center" colspan=1>Rate</td>
          </tr>
          <?php
          $total = $order_sum = 0;
          
          foreach ($stat as $txid => $row){
          ?>
          <tr style='background-color:<?php echo $bg_td ?>'>
            <td class='center' colspan=8 style='text-align:left;'>
              <a class='prod_detail'><?php echo $txid ?></a>
              <table id='<?php echo $txid ?>' style='margin-left:40px;display:block;'>
                <?php
                foreach($row as $k => $v){
                  $order_price = $v['order_price'];
                  $order_date = $v['order_date'];
                ?>
                <tr>
                  <td><?php echo $v['model'] ?></td>
                  <td><?php echo $v['name'] ?></td>
                  <td><?php echo $v['sum'] ?></td>
                  <td><?php echo $v['order_quantity'] ?></td>
                </tr>
                <?php
                }
                ?>
              </table>
            </td>
            <td class='center' colspan=1><?php echo $order_date ?></td>
            <td class='center' colspan=1><?php echo $order_price ?></td>
          </tr>
          <?php 
            $total += $order_price;
          } // end foreach 
          ?>
          <tr style='background-color:#e2e2e2;'>
            <td class='center' colspan='8'></td>
            <td class='center' colspan='2'><?php echo $total; ?></td>
          </tr>
          <?php }else{ ?>
          <tr>
            <td class="center" colspan="8">No Result</td>
          </tr>
          <?php } ?>
          <tr style='height:40px'><td colspan='10'></td></tr>
        
        
        
        
      </tbody>
    </table>
        
  </div>
</div>  
        
<script type="text/javascript">
$(document).ready(function(){
  /*    
  $('input[name=filter_accountno]').bind('keydown',function(e){
    $tgt = $(e.target);
    if( e.keyCode == '13' ){  
      url = 'index.php?route=report/account&accountno='+$(this).val();	
      location.href = url;
    }   
  });   
  */    
        
        
  $('input.atc').focus().autoComplete();
  /*    
  .bind('focus',function(e){
    $this = $(this);
    $options = {
      'width':'150px'
    }   
    $this.autoComplete();
  })    
  */    

  $('.prod_detail').bind('click',function(e){
    $tgt = $(e.target);
    $group = $tgt.text();
    $pnt = $tgt.parents('td');
    $display = $pnt.find('table').css('display');
    if($display == 'none'){
      $pnt.find('table').css('display','block');
    }
    if($display == 'block'){
      $pnt.find('table').css('display','none');
    }
  });
});     
</script>
<?php echo $footer; ?>
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
