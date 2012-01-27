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
    <h1 style="background-image: url('view/image/product.png');">Goal Update</h1>
    <div class="buttons">
      <a class="button save">
        <span>Save</span></a>
      <a onclick="$('#detail').html(); $('#detail').css('visibility','hidden');" class="button">
        <span>Cancel</span></a>
    </div>
  </div>
  <?php
    if(count($stat) > 0 ){
      $month = $stat[0]['month'];
    }else{
      $month = date('Ym');
    }
  ?>
  <div class="content">
    <form action="<?php echo $action; ?>" id="updateForm">
      <div id="tab_general">
        <table class="form" border=0>
          <tr>
            <td class='label'>Status</td>
            <td>
              <select name="month">
                <option value="201109" <?php if('201109'==$month) echo 'selected'; ?>>201109</option>
                <option value="201110" <?php if('201110'==$month) echo 'selected'; ?>>201110</option>
                <option value="201111" <?php if('201111'==$month) echo 'selected'; ?>>201111</option>
                <option value="201112" <?php if('201112'==$month) echo 'selected'; ?>>201112</option>
                <option value="201201" <?php if('201201'==$month) echo 'selected'; ?>>201201</option>
                <option value="201202" <?php if('201202'==$month) echo 'selected'; ?>>201202</option>
                <option value="201203" <?php if('201203'==$month) echo 'selected'; ?>>201203</option>
                <option value="201204" <?php if('201204'==$month) echo 'selected'; ?>>201204</option>
                <option value="201205" <?php if('201205'==$month) echo 'selected'; ?>>201205</option>
                <option value="201206" <?php if('201206'==$month) echo 'selected'; ?>>201206</option>
                <option value="201207" <?php if('201207'==$month) echo 'selected'; ?>>201207</option>
                <option value="201208" <?php if('201208'==$month) echo 'selected'; ?>>201208</option>
                <option value="201209" <?php if('201209'==$month) echo 'selected'; ?>>201209</option>
                <option value="201210" <?php if('201210'==$month) echo 'selected'; ?>>201210</option>
                <option value="201211" <?php if('201211'==$month) echo 'selected'; ?>>201211</option>
                <option value="201212" <?php if('201212'==$month) echo 'selected'; ?>>201212</option>
              </select>   
            </td>
          </tr>
          <?php 
          if(count($stat) > 0){ // update
            //$this->log->aPrint( $stat );
            foreach($stat as $row){
          ?>
            <tr>
              <td><?php echo $row['rep']; ?></td>
              <td colspan=2>
                <input type='hidden' name='id[]' value='<?php echo $row['id']; ?>' />
                <input type='hidden' name='rep[]' value='<?php echo $row['rep']; ?>' />
                <input type="text" name="target[]" size="40" value="<?php echo $row['target']; ?>" />
              </td>
            </tr>
          <?php
            } // end foreach
          }else{  // insert
            foreach($rep as $row){
          ?>
            <tr>
              <td><?php echo $row['username']; ?> , <?php echo $row['firstname']; ?></td>
              <td colspan=2>
                <input type='hidden' name='rep[]' value='<?php echo $row['username']; ?>' />
                <input type="text" name="target[]" size="20" value="100000" />
              </td>
            </tr>
          <?php
            } // end foreach
          } // end if
          ?>
        </table>
      </div>
		</form>
  </div>
</div>

<script type="text/javascript">
<!--


$('.save').bind('click',function(e){
  var url = $('form#updateForm').attr('action');
  var data= $('form#updateForm').serialize();
  $.post(url,data);
  setTimeout("window.location.reload();",1000);
});

//-->
</script>