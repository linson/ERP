<?php echo $header; ?>
<?php if($error_warning){ ?><div class="warning"><?php echo $error_warning; ?></div><?php } ?>
<?php if($success){ ?><div class="success"><?php echo $success; ?></div><?php } ?>
<div class="box">
  <div class="left"></div>
  <div class="right"></div>
  <div class="heading">
    <h1 style="background-image: url('view/image/product.png');">Metarial - Package</h1>
    <div class="buttons">
      <a class="button btn_insert"><span><?php echo $button_insert; ?></span></a>
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
            <td class="center">Code</td>
            <td class="left"><?php if($sort == 'name'){ ?>
              <a href="<?php echo $sort_name; ?>" class="<?php echo strtolower($order); ?>">Name</a>
              <?php } else { ?>
              <a href="<?php echo $sort_name; ?>">Name</a>
              <?php } ?></td>
            <td class="left"><?php if($sort == 'cat'){ ?>
              <a href="<?php echo $sort_cat; ?>" class="<?php echo strtolower($order); ?>">Category</a>
              <?php } else { ?>
              <a href="<?php echo $sort_cat; ?>">Category</a>
              <?php } ?></td>
            <td class="left"><?php if($sort == 'price'){ ?>
              <a href="<?php echo $sort_price; ?>" class="<?php echo strtolower($order); ?>">Price</a>
              <?php } else { ?>
              <a href="<?php echo $sort_price; ?>">Price</a>
              <?php } ?></td>
            <td class="right"><?php if($sort == 'quantity'){ ?>
              <a href="<?php echo $sort_quantity; ?>" class="<?php echo strtolower($order); ?>">Quantity</a>
              <?php } else { ?>
              <a href="<?php echo $sort_quantity; ?>">Quantity</a>
              <?php } ?></td>
            <td class="right"><?php if($sort == 'thres'){ ?>
              <a href="<?php echo $sort_thres; ?>" class="<?php echo strtolower($order); ?>">Thres</a>
              <?php } else { ?>
              <a href="<?php echo $sort_thres; ?>">Thres</a>
              <?php } ?></td>
            <td class="left"><?php if($sort == 'p.status'){ ?>
              <a href="<?php echo $sort_status; ?>" class="<?php echo strtolower($order); ?>">Status</a>
              <?php } else { ?>
              <a href="<?php echo $sort_status; ?>">Status</a>
              <?php } ?></td>
            <td class="right">Action</td>
          </tr>
        </thead>
        <tbody>
        <?php
        //echo 'f :' . $filter_cat;
        ?>
          <tr class="filter">
            <td></td>
            <td class="center"><input type="text" name="filter_code" value="<?php echo $filter_code; ?>" size=5 /></td>
            <td class="center"><input type="text" name="filter_name" value="<?php echo $filter_name; ?>" size=30 /></td>
            <td>
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
            </td>
            <td>
              > <input type="text" name="filter_price" value="<?php echo $filter_price; ?>" size='3' /></td>
            <td align="right">
              < <input type="text" name="filter_quantity" value="<?php echo $filter_quantity; ?>" size='3' /></td>
            <td align="right"><input type="text" name="filter_thres" value="<?php echo $filter_thres; ?>" size='3' /></td>
            <td>
              <select name="filter_status">
                <option value="0" <?php if('0'==$filter_status) echo 'selected'; ?>>Unuse</option>
                <option value="1" <?php if('1'==$filter_status) echo 'selected'; ?>>IN USE</option>
              </select>
            </td>
            <td align="right"><a class="button btn_filter"><span>filter</span></a></td>
          </tr>
          <?php 
          if($packages){ 
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
            <td class="left"><?php echo $package['name']; ?></td>
            <td class="left"><?php echo $package['cat']; ?></td>
            <td class="center"><input type=text name='price' value='<?php echo $package['price']; ?>' size='5' /></td>
            <td class="right">
              <a class='quick_update button'><span>UP</span></a>
              <input type=text name='quantity' value='<?php echo $package['quantity']; ?>' size='5' />
            </td>
            <td class="left"><?php echo $package['thres']; ?></td>
            <td class="left"><?php echo $package['status']; ?></td>
            <td class="right"><?php foreach ($package['action'] as $action){ ?>
              <a class='button edit'><span>Edit</span></a>
              <?php } ?></td>
          </tr>
          <?php } ?>
          <?php } else { ?>
          <tr>
            <td class="center" colspan="9"><?php echo $text_no_results; ?></td>
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
  $('.btn_filter').bind('click',function(){
    $.fn.filter();
  });
  
  $.fn.filter = function(){
  	url = 'index.php?route=material/lookup&token=<?php echo $token; ?>';
  	var filter_code = $('input[name=\'filter_code\']').attr('value');
  	if(filter_code)  url += '&filter_code=' + encodeURIComponent(filter_code);
  	var filter_name = $('input[name=\'filter_name\']').attr('value');
  	if(filter_name) url += '&filter_name=' + encodeURIComponent(filter_name);
  	var filter_cat = $('select[name=\'filter_cat\']').attr('value');
  	if(filter_cat){
  		url += '&filter_cat=' + encodeURIComponent(filter_cat);
  	}
  	var filter_price = $('input[name=\'filter_price\']').attr('value');
  	if(filter_price){
  		url += '&filter_price=' + encodeURIComponent(filter_price);
  	}
  	var filter_quantity = $('input[name=\'filter_quantity\']').attr('value');
  	if(filter_quantity){
  		url += '&filter_quantity=' + encodeURIComponent(filter_quantity);
  	}
  	var filter_status = $('select[name=\'filter_status\']').attr('value');
  	if(filter_status != '*'){
  		url += '&filter_status=' + encodeURIComponent(filter_status);
  	}
  	location = url;
  }

  $('.btn_insert').bind('click',function(event){
    $.ajax({
      type:'get',
      url:'index.php?route=material/lookup/callUpdatePannel',
      dataType:'html',
      data:'token=<?php echo $token; ?>&ddl=insert',
      beforesend:function(){
        //console.log('beforesend');
      },
      complete:function(){
        //console.log('complete');
      },
      success:function(html){
        $('#detail').css('visibility','visible');
        $('#detail').html(html);
        //$('#detail').draggable(); 
      },
      fail:function(){
        //console.log('fail : no response from proxy');
      }
    });
  });

  // todo. tune the blocking later
  /*
  $('.list').bind('focuson',function(event){
    var $tgt = $(event.target);
    if($tgt.is('input')){
      $tgt.select();
    }
  });
  */

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
      var $pnt = $tgt.parents('tr'),
          $ele_chkbox = $pnt.find('.id_in_list'),
          $id = $ele_chkbox.val();
      $.ajax({
        type:'get',
        url:'index.php?route=material/lookup/callUpdatePannel',
        dataType:'html',
        data:'token=<?php echo $token; ?>&ddl=update&id=' + $id,
        beforesend:function(){
          //console.log('beforesend');
        },
        complete:function(){
          //console.log('complete');
        },
        success:function(html){
          $p = $tgt.position();
          $('#detail').css('top',$p.top-200);
          $('#detail').css('visibility','visible');
          $('#detail').html(html);
          //$('#detail').draggable(); 
        },
        fail:function(){
          //console.log('fail : no response from proxy');
        }
      });
    }
    // todo. no null check
    if($tgt.is('a.quick_update>span')){
      $.fn.callQuickUpdate($tgt);
    }
  }); // end of click event

  $.fn.callQuickUpdate = function($tgt){
        var $pnt = $tgt.parents('tr'),
          $ele_chkbox = $pnt.find('.id_in_list'),
          $id = $ele_chkbox.val(),
          $quantity = $pnt.find('input[name=quantity]').val();
          $price = $pnt.find('input[name=price]').val();
      $.ajax({
        type:'get',
        url:'index.php?route=material/lookup/callQuickUpdate',
        dataType:'html',
        data:'token=<?php echo $token; ?>&id=' + $id + '&quantity=' + $quantity + '&price=' + $price,
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
  
  $('.filter input').keydown(function(e){
  	if(e.keyCode == 13){
      $.fn.filter();
  	}
  });
});
</script>
<?php echo $footer; ?>