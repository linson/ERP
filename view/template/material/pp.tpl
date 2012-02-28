<?php echo $header; ?>
<?php if($error_warning){ ?><div class="warning"><?php echo $error_warning; ?></div><?php } ?>
<?php if($success){ ?><div class="success"><?php echo $success; ?></div><?php } ?>
<div class="box">
  <div class="left"></div><div class="right"></div>
  <div class="heading">
    <h1 style="background-image: url('view/image/product.png');">Metarial - Package</h1>
    <div class="buttons">
      <!--a class="button btn_insert"><span><?php echo $button_insert; ?></span></a-->
      <!--a onclick="$('#form').attr('action', '<?php echo $copy; ?>'); $('#form').submit();" class="button"><span><?php echo $button_copy; ?></span></a-->
      <!--a onclick="$('form').submit();" class="button"><span><?php echo $button_delete; ?></span></a-->
    </div>
  </div>
  <div class="content">
    <form action="<?php echo $delete; ?>" method="post" enctype="multipart/form-data" id="form">
      <table class="list">
        <thead>
          <tr>
            <td width="1" style="text-align: center;"><input type="checkbox" onclick="$('input[name*=\'selected\']').attr('checked', this.checked);" /></td>
            <td></td>
            <td class="center">Model</td>
            <td class="center"><?php if($sort == 'name'){ ?>
              <a href="<?php echo $sort_name; ?>" class="<?php echo strtolower($order); ?>">Name</a>
              <?php } else { ?>
              <a href="<?php echo $sort_name; ?>">Name</a>
              <?php } ?></td>
            <!--td class="left"><?php if($sort == 'cat'){ ?>
              <a href="<?php echo $sort_cat; ?>" class="<?php echo strtolower($order); ?>">Category</a>
              <?php } else { ?>
              <a href="<?php echo $sort_cat; ?>">Category</a>
              <?php } ?></td-->
            <!--td class="left"><?php if($sort == 'price'){ ?>
              <a href="<?php echo $sort_price; ?>" class="<?php echo strtolower($order); ?>">Price</a>
              <?php } else { ?>
              <a href="<?php echo $sort_price; ?>">Price</a>
              <?php } ?></td-->
            <td class="center"><?php if($sort == 'quantity'){ ?>
              <a href="<?php echo $sort_quantity; ?>" class="<?php echo strtolower($order); ?>">Quantity</a>
              <?php } else { ?>
              <a href="<?php echo $sort_quantity; ?>">Quantity</a>
              <?php } ?></td>
            <td class="center"><?php if($sort == 'thres'){ ?>
              <a href="<?php echo $sort_thres; ?>" class="<?php echo strtolower($order); ?>">Thres</a>
              <?php } else { ?>
              <a href="<?php echo $sort_thres; ?>">Thres</a>
              <?php } ?></td>
            <td class="center">Action</td>
          </tr>
        </thead>
        <tbody>
        <?php
        //echo 'f :' . $filter_cat;
        ?>
          <tr class="filter">
            <td></td>
            <td></td>
            <td class="center"><input type="text" name="filter_model" value="<?php echo $filter_model; ?>" size=5 /></td>
            <td class="center"><input type="text" name="filter_name" value="<?php echo $filter_name; ?>" size=30 /></td>
            <!--td>
              <select name="filter_cat">
                <option value="" <?php if(''==$filter_cat) echo 'selected'; ?>>---</option>
                <option value="BOTTLE" <?php if('BOTTLE'==$filter_cat) echo 'selected'; ?>>BOTTLE</option>
                <option value="JAR" <?php if('JAR'==$filter_cat) echo 'selected'; ?>>JAR</option>
                <option value="CAP" <?php if('CAP'==$filter_cat) echo 'selected'; ?>>CAP</option>
                <option value="LABEL" <?php if('LABEL'==$filter_cat) echo 'selected'; ?>>LABEL</option>
                <option value="BOX" <?php if('BOX'==$filter_cat) echo 'selected'; ?>>BOX</option>
                <option value="DIV" <?php if('DIV'==$filter_cat) echo 'selected'; ?>>DIV</option>
                <option value="DISPLAY" <?php if('DISPLAY'==$filter_cat) echo 'selected'; ?>>DISPLAY</option>
                <option value="PUMP" <?php if('PUMP'==$filter_cat) echo 'selected'; ?>>PUMP</option>
                <option value="RACK" <?php if('RACK'==$filter_cat) echo 'selected'; ?>>RACK</option>
                <option value="SPRAY" <?php if('SPRAY'==$filter_cat) echo 'selected'; ?>>SPRAY</option>
                <option value="PAD" <?php if('PAD'==$filter_cat) echo 'selected'; ?>>PAD</option>
                <option value="LACE" <?php if('LACE'==$filter_cat) echo 'selected'; ?>>LACE</option>
                <option value="MISC" <?php if('MISC'==$filter_cat) echo 'selected'; ?>>MISC</option>
              </select>
            </td-->
            <!--td>
              > <input type="text" name="filter_price" value="<?php echo $filter_price; ?>" size='3' /></td-->
            <td align="center">
              < <input type="text" name="filter_quantity" value="<?php echo $filter_quantity; ?>" size='3' /></td>
            <td align="center">
              < <input type="text" name="filter_thres" value="<?php echo $filter_thres; ?>" size='3' /></td>
            <td align="center"><a class="button btn_filter"><span>filter</span></a></td>
          </tr>
          <?php 
          if( isset($packages) ){
          ?>
          <?php foreach ($packages as $package){ ?>
          <tr>
            <td style="text-align: center;"><?php if($package['selected']){ ?>
              <input type="checkbox" class='id_in_list' name="selected[]" value="<?php echo $package['id']; ?>" checked="checked" />
              <?php } else { ?>
              <input type="checkbox" class='id_in_list' name="selected[]" value="<?php echo $package['id']; ?>" />
              <?php } ?></td>
            <td class="center">
              <img src="<?php echo $package['image']; ?>" alt="<?php echo $package['name']; ?>" style="padding: 1px; border: 1px solid #DDDDDD;" class='img_code' />
            </td>
            <td class="center"><?php echo $package['model']; ?></td>
            <td class="center"><?php echo $package['name']; ?></td>
            <!--td class="left"><?php echo $package['cat']; ?></td-->
            <!--td class="center"><input type=text name='price' value='<?php echo $package['price']; ?>' size='5' /></td-->
            <td class="center">
              <a class='quick_update button'><span>UP</span></a>
              <input type=text name='quantity' value='<?php echo $package['quantity']; ?>' size='5' style='background-color:#e2e2e2' />
              <input type="number" size="4" value="" class="plus" name="plus">
            </td>
            <td class="center"><?php echo $package['thres']; ?></td>
            <td class="center"><?php foreach ($package['action'] as $action){ ?>
              <a class='button edit'><span>Edit</span></a>
              <?php } ?></td>
          </tr>
          <?php } ?>
          <?php } else { ?>
          <tr>
            <td class="center" colspan="7"><?php echo $text_no_results; ?></td>
          </tr>
          <?php } ?>
        </tbody>
      </table>
    </form>
    <div class="pagination"><?php echo $pagination; ?></div>
  </div>
</div>

<!-- common detail div -->
<style>
#detail{
  position : absolute;
  top: 100px;
  left: 200px;
  visibility:hidden;
  border: 1px dotted green;
  z-index:99;
}
</style>
<div id='detail'></div>

<script>
$(document).ready(function(){
  $('.list').live('click',function(event){
    var $tgt = $(event.target);
    // image click show detail history
    if($tgt.is('img.img_code')){
      var $pnt = $tgt.parents('tr'),
          $ele_chkbox = $pnt.find('.id_in_list'),
          $id = $ele_chkbox.val();
      $.ajax({
        type:'get',
        url:'index.php?route=material/lookup/callHistoryPannel',
        dataType:'html',
        data:'token=<?php echo $token; ?>&id=' + $id,
        success:function(html){
          $p = $tgt.position();
          $('#detail').css('top',$p.top);
          $('#detail').css('background-color','white');
          $('#detail').css('visibility','visible');
          $('#detail').html(html);
          // todo. some confliction with ui.mouse !
          // $('#detail').draggable();
        }
      });
    }

    if($tgt.is('a.edit>span')){
      var $parent = $tgt.parents('tr'),
          $ele_chkbox = $parent.find('.id_in_list'),
          $id = $ele_chkbox.val();
      $.ajax({
        type:'get',
        url:'index.php?route=material/productpackage/callMapping',
        dataType:'html',
        data:'product_id=' + $id,
        success:function(html){
          //$p = $tgt.position();
          $('#detail').css('left','30px').css('top','50px').css('visibility','visible')
            .css('background-color','white').html(html);
          $('#detail').draggable();
        }
      });
    }

    // todo. no null check
    if($tgt.is('a.quick_update>span')){
      $.fn.updateQuantity($tgt);
    }
  }); // end of click event

  $.fn.updateQuantity = function($tgt){
        var $pnt = $tgt.parents('tr'),
          $ele_chkbox = $pnt.find('.id_in_list'),
          $id = $ele_chkbox.val(),
          $quantity = $pnt.find('input[name=quantity]').val();
      $.ajax({
        type:'get',
        url:'index.php?route=material/lookup/updateQuantity',
        dataType:'html',
        data:'token=<?php echo $token; ?>&id=' + $id + '&quantity=' + $quantity,
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

  $('#form').bind('keydown',function(event){
    if(event.keyCode == '13'){
      var $tgt = $(event.target);
      if($tgt.is('input.plus')){
        $pnt = $tgt.parents('tr'),
               $ele_quantity = $pnt.find('input[name=quantity]'),
               $quantity = $ele_quantity.val(),
               $plus = $tgt.val(),
               $product_id = $pnt.find('.id_in_list').val();
        if('' == $plus){
          alert('No number'); 
          return false;
        }
        $sum = parseInt($quantity) + parseInt($plus);
        $.fn.updateQuantity2($product_id,$sum,$tgt);
        $ele_quantity.val($sum);
        $tgt.val('');
      }
    }
  });
  $.fn.updateQuantity2 = function(id,quantity,$tgt){
    $.ajax({
      type:'get',
      url:'index.php?route=material/lookup/updateQuantity',
      dataType:'html',
      data:'id=' + id + '&quantity=' + quantity,
      success:function(){
        $p = $tgt.position();
        $imgCss = {
          'visibility':'visible',
          'width':'120px',
          'height':'20px',
          'top':$p.top-30,
          'left':$p.left-30,
          'background-color':'black',
          'color':'white',
          'text-align':'center'
        }
        $('#detail').css($imgCss);
        $('#detail').html('success : ' + quantity );
        $('#detail').draggable();
      },
      fail:function(){
      }
    });
  }

  // filter is reserved method so you should not use it
  $.fn.search = function(){
  	url = 'index.php?route=material/productpackage&token=<?php echo $token; ?>';
  	var filter_model = $('input[name=\'filter_model\']').attr('value');
  	if(filter_model)  url += '&filter_model=' + encodeURIComponent(filter_model);
  	var filter_name = $('input[name=\'filter_name\']').attr('value');
  	if(filter_name) url += '&filter_name=' + encodeURIComponent(filter_name);
  	var filter_quantity = $('input[name=\'filter_quantity\']').attr('value');
  	if(filter_quantity) url += '&filter_quantity=' + encodeURIComponent(filter_quantity);
  	var filter_thres = $('input[name=\'filter_thres\']').attr('value');
  	if(filter_thres)  url += '&filter_thres=' + encodeURIComponent(filter_thres);
  	location = url;
  };

  $('.btn_filter').bind('click',function(){
    $.fn.search();
  });
  
  $('.filter input').bind('keydown',function(e){
    if(e.keyCode == 13){
      $.fn.search();
    }
  });

});
</script>
<?php echo $footer; ?>