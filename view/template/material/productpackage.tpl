<?php echo $header; ?>
<?php if($error_warning){ ?>
<div class="warning"><?php echo $error_warning; ?></div>
<?php } ?>
<?php if($success){ ?>
<div class="success"><?php echo $success; ?></div>
<?php } ?>

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
  left: 200px;
  visibility:hidden;
  border: 1px dotted green;
  z-index:2;
}
</style>

<div class="box">
  <div class="left"></div>
  <div class="right"></div>
  <div class="heading">
    <h1 style="background-image: url('view/image/product.png');">
      Package Mapping <?php if($total) echo "(" . $total . ")";?> </h1>
    <div class="buttons">
      <a class="button"><span id='save'>save</span></a>
      <a class="button"><span id='close'>close</span></a>
    </div>
  </div>
  <?php
    $filter_code = '';
    $filter_name = '';
  ?>

<style>
#lpanel{
  float:left;
  width:400px;
}
#rpanel{
  float:right;
}
#rpanel{
  width:400px;
}
#btripTable{
  width:400px;
  height:60px;
  border:1px solid red;
  background-color:#e2e2e2;
  padding-bottom:40px;
}
#btripTable tr{
  vertical-align:top;
}

</style>
  <div class="content" style='min-height:900px;width:800px;'>
    <div id='lpanel'>
    <?php 
      // no delete or so
      $delete = ''; 
    ?>
    <form action="<?php echo $delete; ?>" method="post" enctype="multipart/form-data" id="form">
      <table class="list" id='storeTable'>
        <thead>
          <tr>
            <td class="left">code</td>
            <td class="left">name</td>
          </tr>
          <!-- it's only for page module , besso-201103 -->
          <tr class="filter">
            <td>
              <input type="text" name="filter_code" value="<?php echo $filter_code; ?>" size='6' />
            </td>
            <td>
              <input type="text" name="filter_name" value="<?php echo $filter_name; ?>" size='15' />
            </td>
          </tr>
        </thead>  
        <tbody>
          <?php if(isset($packagelist)) { ?>
          <?php foreach ($packagelist as $row) { ?>
          <tr>
            <td class='center accountno_in_list'>
              <input type="hidden" name="id" class='id_in_list' value="<?php echo $row['code']; ?>" />
              <input type='hidden' name='view' value='proxy' />
              <?php echo $row['code']; ?>
            </td>
            <!--td class='center name_in_list'-->
            <td>
              <a onclick='' class='edit'>
              <?php echo $row['name']; ?></a>
            </td>
          </tr>
          <?php } // end foreach ?>
          <?php } else { ?>
          <tr>
            <td class="center" colspan="11">No Result</td>
          </tr>
          <?php } ?>
        </tbody>
      </table>
    </form>
    <!--div class="pagination"><?php echo $pagination; ?></div-->
    </div><!-- lpanel -->
    <div id='rpanel'>
	    <div id="startingPoint">
        <!-- start of map -->
        <?php
        //$this->log->aPrint( $product );
        ?>
        <table>
          <tr style='background:peru;'>
            <td colspan=2>
              <p style='color:white;width:16px;width:300px;height:20px;padding-left:20px;font-size:14px;font-wegiht:bold;'>
              Product</p>
            </td></tr>
          <tr>
            <td>
              <input type=hidden name='product_id' id='product_id' value='<?php echo $product['product_id']; ?>'>
              <img src="image/<?php echo $product['image']; ?>" alt="<?php echo $product['name']; ?>" style="margin:0px; padding:0px; border:1px solid #DDDDDD;width:80px;height:80px;" />
            </td>
            <td>
              <ul>
                <li><?php echo $product['model']; ?></li>
                <li><?php echo $product['name']; ?></li>
              </ul>
            <td>
          </tr>
  		  </table>
      </div>
      
<?php
  if(isset($package)){
    $pkgHtml = '<tbody>';
    foreach($package as $exist){
      //$this->log->aPrint( $exist );
      $code = $exist['code'];
      $name = $exist['name'];
      $pkgHtml .=<<<HTML
        <tr class='ui-draggable'>
            <td class='center accountno_in_list'>
              <input name='id' class='id_in_list' value='$code' type='hidden'>
              <input name='view' value='proxy' type='hidden'>
              $code
            </td>
            <!--td class='center name_in_list'-->
            <td>
              <a onclick='' class='edit'>
              $name
              </a>
            </td>
        </tr>
HTML;
    }
    $pkgHtml .= '</tbody>';
  }
?>
      <div>
        <table id='btripTable'>
        <?php   if(isset($package)) echo $pkgHtml; ?>
        </table>
      </div>
    </div>
  </div>
</div>
<!-- common detail div -->
<style>
#detail{
  z-index:10;
}
</style>
<div id='detail'></div>
<style>
#map_canvas{
  visibility:hidden;
  position:absolute;
  top:0px;
  left:0px;
  width:800px;
  height:600px;
  z-index:10;
}
#directions_panel{
  visibility:hidden;
  position:absolute;
  top:0px;
  left:800px;
  width:160px;
  background-color:#FFEE77;
  padding-left:10px;
  z-index:10;
}
</style>
<div id="map_canvas" class="map"></div>
<div id="directions_panel" style=""></div>

<script type="text/javascript">
$('.list').live('click',function(event){
  var $tgt = $(event.target);
  // image click show detail history
  if($tgt.is('a.mapping>span')){
    var $pnt = $tgt.parents('tr'),
        $ele_chkbox = $pnt.find('input[name=product_id]'),
        $product_id = $ele_chkbox.val();
    $.ajax({
      type:'get',
      url:'index.php?route=material/productpackage/callMapping',
      dataType:'html',
      data:'token=<?php echo $token; ?>&product_id=' + $product_id,
      success:function(html){
        //$p = $tgt.position();
        //$('#detail').css('top',$p.top-200);
        //$('#detail').css('left',$p.left);
        $('#detail').css('visibility','visible');
        $('#detail').html(html);
        //$('#detail').draggable();
        //location.href = 'index.php?route=material/productpackage';
      }
    });
  }
  // todo. no null check
  if($tgt.is('a.quick_update>span')){
    $.fn.callQuickUpdate($tgt);
  }
}); // end of click event

function filter(){
	url = 'index.php?route=material/productpackage&token=<?php echo $token; ?>';
	var filter_name = $('input[name=\'filter_name\']').attr('value');
	if(filter_name) url += '&filter_name=' + encodeURIComponent(filter_name);
	var filter_model = $('input[name=\'filter_model\']').attr('value');
	if(filter_model)  url += '&filter_model=' + encodeURIComponent(filter_model);
	var filter_price = $('input[name=\'filter_price\']').attr('value');
	if(filter_price)  url += '&filter_price=' + encodeURIComponent(filter_price);
	var filter_quantity = $('input[name=\'filter_quantity\']').attr('value');
	if(filter_quantity) url += '&filter_quantity=' + encodeURIComponent(filter_quantity);
  var filter_cat = $('select[name=\'filter_cat\']').attr('value');
  if(filter_cat != '*') url += '&filter_cat=' + encodeURIComponent(filter_cat);
	location = url;
}

$('.filter input').keydown(function(e){
	if(e.keyCode == 13) filter();
});
</script>
<?php echo $footer; ?>