<style>
#tab_transfer,#tab_history{
  display:none;
}
#form .form{
  width:400px;
}
table.form tr td:first-child {
  width: 100px;
  background-color:white;
}
</style>
<div class="box" style='background-color:white;'>
  <div class="left" colspan=2></div>
  <div class="right"></div>
  <div class="heading">
    <h1 style="background-image: url('view/image/product.png');">Product Update</h1>
    <div class="buttons">
      <a class="button save">
        <span>Save</span></a>
      <a onclick="$('#detail').html(); $('#detail').css('visibility','hidden');" class="button">
        <span>Cancel</span></a>
    </div>
  </div>
  <div id='xxxxx' class="content">
    <!--div id="tabs" class="htabs">
      <a tab="#tab_general">Base Info</a>
    </div-->
    <form action="<?php echo $action; ?>" id="updateForm">
      <div id="tab_general">
        <?php
          //$this->log->aPrint( $data );
          if('update' == $ddl){
            $product_id = $data['product_id'];
            $model      = $data['model'];
            $sku        = $data['sku'];
            $quantity   = $data['quantity'];
            $image      = $data['image'];
            $ws_price   = $data['ws_price'];
            $rt_price   = $data['rt_price'];
            $pc         = $data['pc'];
            $ups_weight = $data['ups_weight'];
            $thres      = $data['thres'];
            $dc         = $data['dc'];
            $dc2        = $data['dc2'];
            $status     = $data['status'];
            $name = $data['name'];
            $name_for_sales = $data['name_for_sales'];
          }else{
            $product_id = '';
            $model      = '';
            $sku        = '';
            $quantity   = '';
            $image      = 'data/Salon-Pro/Hair-Bonding-Glue/Salon-Pro-Hair-Bond-Remover-Lotion-2oz.jpg';
            $ws_price   = '';
            $rt_price   = '';
            $pc         = '';
            $ups_weight = '';
            $thres      = '';
            $dc         = '';
            $dc2        = '';
            $status     = '1';
            $name = '';
            $name_for_sales = '';
          }
        ?>
        <table class="form" border=0>
          <tr>
            <td class='label'>Code</td>
            <td>
              <input type="hidden" name="product_id" size="50" value="<?php echo $product_id; ?>" readonly />
              <input type="text" name="model" size="5" value="<?php echo $model; ?>" />
              <p> SKU is Model catalog ex. VN, SP, OEM, SAMPLE
              <input type="text" name="sku" size="5" value="<?php echo $sku; ?>" />
            </td>
            <td rowspan=4>
                  <?php
                  if('' != $image){
                    $preview = HTTP_IMAGE.$image;
                  }
                  ?>
                  <input type="hidden" name="image" value="<?php echo $image; ?>" id="image" />
                  <img src="<?php echo $preview; ?>" alt="" id="preview" class="image" onclick="image_upload('image', 'preview');" width='125px' height='150px' />
            </td>
          </tr>
          <tr>
            <td class='label'>Status</td>
            <td>
              <select name="status">
                <option value="0" <?php if('0'==$status) echo 'selected'; ?>>Unuse</option>
                <option value="1" <?php if('1'==$status) echo 'selected'; ?>>IN USE</option>
              </select>   
            </td>
          </tr>
          <tr>
            <td class='label'>quantity</td>
            <td><input type="text" name="quantity" value="<?php echo $quantity; ?>" size=5 /></td>
          </tr>
          <tr>
            <td class='label'>Full Name</td>
            <td colspan=2><input type="text" name="name" size="50" value="<?php echo $name; ?>" style='width:180px'/></td>
          </tr>
          <tr>
            <td class='label'>Alias</td>
            <td colspan=2><input type="text" name="name_for_sales" size="50" value="<?php echo $name_for_sales; ?>" /></td>
          </tr>
          <tr>
            <td class='label'>WS Price</td>
            <td colspan=2>
              <input type="text" name="ws_price" size="50" value="<?php echo $ws_price; ?>" />
            </td>
          </tr>
          <tr>
            <td class='label'>RT Price</td>
            <td colspan=2>
              <input type="text" name="rt_price" size="50" value="<?php echo $rt_price; ?>" />
            </td>
          </tr>
          <tr>
            <td class='label'>thres</td>
            <td colspan=2><input type="text" name="thres" size="50" value="<?php echo $thres; ?>" /></td>
          </tr>
          <tr>
            <td class='label'>piece</td>
            <td colspan=2><input type="text" name="pc" size="5" value="<?php echo $pc; ?>" /></td>
          </tr>
          <tr>
            <td class='label'>Weight</td>
            <td colspan=2><input type="text" name="ups_weight" size="50" value="<?php echo $ups_weight; ?>" /></td>
          </tr>
          <tr>
            <td class='label'>Discount1</td>
            <td colspan=2><input type="text" name="dc" size="50" value="<?php echo $dc; ?>" /></td>
          </tr>
          <tr>
            <td class='label'>Discount2</td>
            <td colspan=2><input type="text" name="dc2" size="50" value="<?php echo $dc2; ?>" /></td>
          </tr>
        </table>
      </div>
		</form>
  </div>
</div>

<style>
#dialog{
  height:500px;
}
</style>
<script type="text/javascript" src="http://salonpro30sec.com/beautypro24/admin/view/javascript/jquery/ui/ui.draggable.js"></script>
<script type="text/javascript" src="http://salonpro30sec.com/beautypro24/admin/view/javascript/jquery/ui/ui.resizable.js"></script>
<!--script type="text/javascript" src="http://salonpro30sec.com/beautypro24/admin/view/javascript/jquery/ui/ui.dialog.js"></script-->
<script type="text/javascript" src="view/javascript/ui.dialog.js"></script>
<script type="text/javascript" src="http://salonpro30sec.com/beautypro24/admin/view/javascript/jquery/ui/external/bgiframe/jquery.bgiframe.js"></script>
<script type="text/javascript">
<!--
function image_upload(field, preview){
	$('#dialog').remove();
	path = '';
	$('#detail').prepend('<div id="dialog" style="padding: 3px 0px 0px 0px;"><iframe src="index.php?route=common/filemanager&token=<?php echo $token; ?>&path=' + encodeURIComponent(path) + '&field=' + encodeURIComponent(field) + '" style="padding:0; margin: 0; display: block; width: 100%; height: 100%;" frameborder="no" scrolling="auto"></iframe></div>');

	$('#dialog').dialog({
		title: 'upload image',
		closeText:'close',
		close: function (event,ui){
			if($('#image').attr('value')){
				$.ajax({
					url: 'index.php?route=common/filemanager/image&token=<?php echo $token; ?>',
					type: 'POST',
					data: 'image=' + encodeURIComponent($('#image').attr('value')),
					dataType: 'text',
					success: function(data) {
						$('#preview').replaceWith('<img src="' + data + '" alt="" id="' + preview + '" class="image" onclick="image_upload(\'' + field + '\', \'' + preview + '\');" />');
					}
				});
			}
		},
		bgiframe: false,
		width: 700,
		height: 400,
		resizable: false,
		modal: false
	});
};

$('.save').bind('click',function(e){
  var url = $('form#updateForm').attr('action');
  var data= $('form#updateForm').serialize();
  $.post(url,data);
  setTimeout("window.location.reload();",1000);
});

//-->
</script>