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
    <h1 style="background-image: url('view/image/product.png');">Package Update</h1>
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
            $id =          $data['id'];
            $code =        $data['code'];
            $name =        htmlentities($data['name']);
            $cat =         $data['cat'];
            $image =       $data['image'];
            $quantity =    $data['quantity'];
            $thres =       $data['thres'];
            $warehouse =   $data['warehouse'];
            $company =     $data['company'];
            $description = htmlentities($data['description']);
            $up_date =     $data['up_date'];
            $status =      $data['status'];
            //$size = $data['size'];
            //$color = $data['color'];
            $term = $data['term'];
            //$material = $data['material'];
            ('' != $data['price'])     ? $price      = $data['price']     : $price      = '0';
            //('' != $data['last_price'])? $last_price = $data['last_price']: $last_price = '0';
            //('' != $data['dprice'])    ? $dprice     = $data['dprice']    : $dprice     = '0';
            //('' != $data['iprice'])    ? $iprice     = $data['iprice']    : $iprice     = '0';
          }else{
            $id =          '';
            $code =        '';
            $name =        '';
            $cat =         '';
            $image =       '';
            $quantity =    '';
            $thres =       '';
            $warehouse =   '';
            $company =     '';
            $description = '';
            $up_date =     '';
            $status =      '1';
            //$size = '';
            //$color = '';
            //$material = '';
            $price      = '0';
            //$last_price = '0';
            //$dprice     = '0';
            //$iprice     = '0';
          }
        ?>
        <table class="form" border=0>
          <tr>
            <td class='label'>Code</td>
            <td>
              <input type="hidden" name="id" size="50" value="<?php echo $id; ?>" readonly />
              <input type="text" name="code" size="5" value="<?php echo $code; ?>" />
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
                <option value="2" <?php if('2'==$status) echo 'selected'; ?>>INACTIVE</option>
              </select>   
            </td>
          </tr>
          <tr>
            <td class='label'>Cat</td>
            <td>
              <select name="cat">
                <option value="" <?php if(''==$cat) echo 'selected'; ?>>---</option>
                <option value="BOTTLE" <?php if('BOTTLE'==$cat) echo 'selected'; ?>>BOTTLE</option>
                <option value="JAR" <?php if('JAR'==$cat) echo 'selected'; ?>>JAR</option>
                <option value="CAP" <?php if('CAP'==$cat) echo 'selected'; ?>>CAP</option>
                <option value="LABEL" <?php if('LABEL'==$cat) echo 'selected'; ?>>LABEL</option>
                <option value="BOX" <?php if('BOX'==$cat) echo 'selected'; ?>>BOX</option>
                <option value="DIV" <?php if('DIV'==$cat) echo 'selected'; ?>>DIV</option>
                <option value="DISPLAY" <?php if('DISPLAY'==$cat) echo 'selected'; ?>>DISPLAY</option>
                <option value="PUMP" <?php if('PUMP'==$cat) echo 'selected'; ?>>PUMP</option>
                <option value="RACK" <?php if('RACK'==$cat) echo 'selected'; ?>>RACK</option>
                <option value="SPRAY" <?php if('SPRAY'==$cat) echo 'selected'; ?>>SPRAY</option>
                <option value="PAD" <?php if('PAD'==$cat) echo 'selected'; ?>>PAD</option>
                <option value="LACE" <?php if('LACE'==$cat) echo 'selected'; ?>>LACE</option>
                <option value="MISC" <?php if('MISC'==$cat) echo 'selected'; ?>>MISC</option>
              </select>
            </td>
          </tr>
          <tr>
            <td class='label'>quantity</td>
            <td><input type="text" name="quantity" value="<?php echo $quantity; ?>" size=5 /></td>
          </tr>
          <tr>
            <td class='label'>Name</td>
            <td colspan=2><input type="text" name="name" size="50" value="<?php echo $name; ?>" /></td>
          </tr>
          <tr>
            <td class='label'>Price</td>
            <td colspan=2>
              <input type="text" name="price" size="50" value="<?php echo $price; ?>" />
                
                <!--ul style='align:right;'>
                  <li style='list-style:none;'> Last Price : <input type="text" name="last_price" size="5" value="<?php echo $last_price; ?>" /> </li>
                  <li style='list-style:none;'> Domestic Price : <input type="text" name="dprice" size="5" value="<?php echo $dprice; ?>" /> </li>
                  <li style='list-style:none;'> International Price : <input type="text" name="iprice" size="5" value="<?php echo $iprice; ?>" /> </li>
                </ul-->
            </td>
          </tr>
          <tr>
            <td class='label'>thres</td>
            <td colspan=2><input type="text" name="thres" size="50" value="<?php echo $thres; ?>" /></td>
          </tr>
          <!--tr>
            <td class='label'>size</td>
            <td colspan=2><input type="text" name="size" size="50" value="<?php echo $size; ?>" /></td>
          </tr>
          <tr>
            <td class='label'>color</td>
            <td colspan=2><input type="text" name="color" size="50" value="<?php echo $color; ?>" /></td>
          </tr>
          <tr>
            <td class='label'>material</td>
            <td colspan=2><input type="text" name="material" size="50" value="<?php echo $material; ?>" /></td>
          </tr-->
          <tr>
            <td class='label'>company</td>
            <td colspan=2><input type="text" name="company" size="50" value="<?php echo $company; ?>" /></td>
          </tr>
          <tr>
            <td class='label'>warehouse</td>
            <td colspan=2><input type="text" name="warehouse" size="50" value="<?php echo $warehouse; ?>" /></td>
          </tr>
          <tr>
            <td class='label'>Term</td>
            <td colspan=2>
              <?php if(!isset($term)) $term = 'w'; ?>
              <select name='term'>
                <option value='w' <?php if($term=='w') echo 'selected'; ?>>every week</option>
                <option value='m' <?php if($term=='m') echo 'selected'; ?>>every month</option>
                <option value='y' <?php if($term=='y') echo 'selected'; ?>>every day</option>
              </select>
            </td>
          </tr>
          <tr>
            <td class='label'>description</td>
            <td colspan=2><textarea name="description" style="width:284px;height:133px;"><?php echo $description; ?></textarea></td>
          </tr>
          <tr><td colspan=3> History comment </td></tr>
          <tr>
            <td class='label'>history</td>
            <td colspan=2><textarea name="comment" style="width:284px;height:20px;"></textarea></td>
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
function image_upload(field, preview) {
	$('#dialog').remove();
	path = 'package';
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

/*
  $.post(url,function(data){
    var form= $('#updateForm');
    debugger;
    alert(data);
  });
  */
  //$('#updateForm').submit();
  /***
  $('#updateForm').submit(data,function(e){
    e.preventDefault();
    alert('submit');
    alert(data);
    //var url = $('#updateForm').attr('action'),
        //data= $('#updateForm').serialize();
    //alert(data);
    //$.post(url);
    //$.post(url,$('#updateForm').serialize());
    //$.post(url,function(data){
    //alert();
  });
  ***/
});

/*** todo. dont need it !!
$.fn.callQuickUpdate = function(){
    var $id = $('form').find('input[name=id]').val(),
        $quantity = $('form').find('input[name=quantity]').val(),
        $price = $('form').find('input[name=price]').val()
        $desc = $('form').find('textarea[name=comment]').val();
    $.ajax({
      type:'get',
      url:'index.php?route=material/lookup/callQuickUpdate',
      dataType:'html',
      data:'token=<?php echo $token; ?>&id=' + $id + '&quantity=' + $quantity + '&price=' + $price + '&desc=' + $desc,
      success:function(html){
        $p = $tgt.position();
        $imgCss = {
          'visibility':'visible',
          'width':'150px',
          'height':'20px',
          'top':$p.top-30,
          'left':$p.left-30,
          'background-color':'black',
          'color':'white',
          'text-align':'center'
        }
        $('#detail').css($imgCss);
        $('#detail').html('success : ' + $quantity );
        setTimeout("$('#detail').css('visibility','hidden');",1000);
      },
    });
}
*****/
//-->
</script>