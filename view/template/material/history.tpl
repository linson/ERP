<?php echo $header; ?>
<?php if($error_warning){ ?><div class="warning"><?php echo $error_warning; ?></div><?php } ?>
<?php if($success){ ?><div class="success"><?php echo $success; ?></div><?php } ?>
<div class="box">
  <div class="left"></div>
  <div class="right"></div>
  <div class="heading">
    <h1 style="background-image: url('view/image/product.png');">Metarial - History</h1>
    <div class="buttons">
      <a class="button btn_search"><span>Search</span></a>
      <!--a onclick="$('#form').attr('action', '<?php echo $copy; ?>'); $('#form').submit();" class="button"><span><?php echo $button_copy; ?></span></a-->
      <!--a onclick="$('form').submit();" class="button"><span><?php echo $button_delete; ?></span></a-->
    </div>
  </div>
  <div class="content">
    <form action="<?php echo $delete; ?>" method="post" enctype="multipart/form-data" id="form">
      <table class="list">
        <thead>
          <tr>
            <!--td>Image</td-->
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
            <td class='center'>Product</td>
            <td class='center'>Update Date</td>
            <td class='center'>Quantity</td>
            <td class='center'>Change</td>
            <td class='center'>Rep</td>
            <td class='center'>comment</td>
          </tr>
        </thead>
        <tbody>
        <?php
        //echo 'f :' . $filter_cat;
        ?>
          <tr class="filter">
            <!--td></td-->
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
            <td><input type="text" name="filter_product" value="<?php echo $filter_product; ?>" style='width:70px;' /></td>
            <td class='center' colspan=2>
              <input type="text" class='date_pick' name="filter_history_from" value="<?php echo $filter_history_from; ?>" style='width:70px;' />
              -
              <input type="text" class='date_pick' name="filter_history_to" value="<?php echo $filter_history_to; ?>" style='width:70px;' />
            </td>
            <td colspan='4'></td>
          </tr>
          <?php 
          if($packages){ 
          ?>
          <?php foreach ($packages as $package){ ?>
          <tr>
            <!--td class="center">
              <img src="<?php echo $package['image']; ?>" alt="<?php echo $package['name']; ?>" style="padding: 1px; border: 1px solid #DDDDDD;" class='img_code' />
            </td-->
            <td class="left">
              <a href="index.php?route=material/lookup&token=<?php echo $this->session->data['token'] ; ?>&filter_code=<?php echo $package['code']; ?>" target="new" >
              <?php echo $package['code']; ?>
              </a>
            </td>
            <td class="left"><?php echo $package['name']; ?></td>
            <td class="left"><?php echo $package['cat']; ?></td>
            <td class="left">
              <a href="index.php?route=product/price&filter_pid=<?php echo $package['final']; ?>" target="new">
              <?php echo $package['model']; ?>
              </a>
            </td>
            <td class="left"><?php echo $package['up_date']; ?></td>
            <td class='center'><?php echo $package['quantity']; ?></td>
            <td class='center'><?php echo $package['diff']; ?></td>
            <td class='center'><?php echo $package['rep']; ?></td>
            <td class='center'><?php echo $package['comment']; ?></td>
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
  background-color:white;
  z-index:99;
}
</style>
<div id='detail'></div>

<script>
$(document).ready(function(){
  $('.btn_search').bind('click',function(){
    $.fn.filter();
  });

  $.fn.filter = function(){
  	url = 'index.php?route=material/history&token=<?php echo $token; ?>';
  	var filter_code = $('input[name=\'filter_code\']').attr('value');
  	if(filter_code)  url += '&filter_code=' + encodeURIComponent(filter_code);
  	var filter_name = $('input[name=\'filter_name\']').attr('value');
  	if(filter_name) url += '&filter_name=' + encodeURIComponent(filter_name);
  	var filter_product = $('input[name=\'filter_product\']').attr('value');
  	if(filter_product) url += '&filter_product=' + encodeURIComponent(filter_product);
  	var filter_cat = $('select[name=\'filter_cat\']').attr('value');
  	if(filter_cat){
  		url += '&filter_cat=' + encodeURIComponent(filter_cat);
  	}
  	var filter_history_from = $('input[name=\'filter_history_from\']').attr('value');
  	if(filter_history_from != '*'){
  		url += '&filter_history_from=' + encodeURIComponent(filter_history_from);
  	}
  	var filter_history_to = $('input[name=\'filter_history_to\']').attr('value');
  	if(filter_history_to != '*'){
  		url += '&filter_history_to=' + encodeURIComponent(filter_history_to);
  	}
  	location = url;
  }

  $('.filter input').keydown(function(e){
  	if(e.keyCode == 13){
      $.fn.filter();
  	}
  });

  // date picker binding
  $('#form').bind('focusin',function(event){
    var $tgt = $(event.target);
    if($tgt.is('input.date_pick')){
      //$(".date-pick").datePicker({startDate:'01/01/1996'});
      $(".date_pick").datepicker({
        clickInput:true,
        createButton:false,
        startDate:'2000-01-01'
      });
    }
  });

});
</script>
<?php echo $footer; ?>