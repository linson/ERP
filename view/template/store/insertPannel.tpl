<style>
#tab_transfer,#tab_history{
  display:none;
}
#form .form{
  width:400px;
}
table.form tr td:first-child {
  width: 100px;
}
</style>
<div class="box" style='background-color:white;'>
  <div class="left"></div>
  <div class="right"></div>
  <div class="heading">
    <h1 style="background-image: url('view/image/product.png');">Store Insert</h1>
    <div class="buttons">
      <a onclick="$('#updateForm').submit();" class="button">
        <span>Save</span></a>
      <a onclick="$('#detail').html(); $('#detail').css('visibility','hidden');" class="button">
        <span>Cancel</span></a>
    </div>
  </div>
  <div class="content">
    <form action="<?php echo $action; ?>" method="post" enctype="multipart/form-data" id="updateForm">
      <div id="tab_general">
        <table class="form">
          <tr>
            <td class='label'>Acct.no</td>
            <td>
              <input type="hidden" name="id" size="50" value="" readonly />
              Acct.no : <input type="text" name="accountno" size="6" value="" style='background-color:#eeeeee' /> / 
              <select name='storetype'>
                <option value='W'>W</option>
                <option value='R' selected>R</option>
              </select>
              / Rep : <input type="text" name="salesrep" size="2" value="" />
            </td>
          </tr>
          <tr>
            <td class='label'>status</td>
            <td>
              <?php 
                $aStoreCode = $this->config->getStoreStatus(); 
              ?>
              <select name="status">
                <option value="0"><?php echo $aStoreCode['0']; ?></option>
                <option value="1" selected><?php echo $aStoreCode['1']; ?></option>
                <option value="2"><?php echo $aStoreCode['2']; ?></option>
                <option value="3"><?php echo $aStoreCode['3']; ?></option>
                <option value="9"><?php echo $aStoreCode['9']; ?></option>
              </select>
            </td>
          </tr>
          <tr>
            <td class='label'>Name</td>
            <td><input type="text" name="name" size="50" value="" /></td>
          </tr>
          <tr>
            <td class='label'>Address1</td>
            <td><input type="text" name="address1" size="50" value="" /></td>
          </tr>
          <!--tr>
            <td>Address2</td>
            <td><input type="text" name="address2" size="50" value="" /></td>
          </tr-->
          <tr>
            <td class='label'>City/State/Zip</td>
            <td>
              City : <input type="text" name="city" size="20" value="" />/
              St : <input type="text" name="state" size="2" value="" />/
              Zip : <input type="text" name="zipcode" size="5" value="" />
            </td>
          </tr>
          <tr>
            <td class='label'>Phone / Cell</td>
            <td>
              <input type="text" name="phone1" size="12" value="" /> / 
              <input type="text" name="phone2" size="12" value="" />
            </td>
          </tr>
          <tr>
            <td class='label'>fax</td>
            <td><input type="text" name="fax" size="20" value="" /></td>
          </tr>
          <tr>
            <td class='label'>email</td>
            <td><input type="text" name="email" size="20" value="" /></td>
          </tr>
          <tr>
            <td class='label'>Chicago Area</td>
            <td>
              <select name="chrt">
                <option value="0" >Not Chicago retail</option>
                <option value="1" >Chicago Area</option>
              </select>            
            </td>
          </tr>
          <tr>
            <td class='label'>Host account</td>
            <td><input type="text" name="parent" size="20" value="" /></td>
          </tr>
          <tr>
            <td class='label'>DC</td>
            <td>
                <input type="number" name="dc1" size="1" value="" />%
                <input type="text" name="dc1_desc" size="40" value="" /><br/>
                <input type="number" name="dc2" size="1" value="" />%
                <input type="text" name="dc2_desc" size="40" value="" /><br/>
                <input type="number" name="dc3" size="1" value="" />%
                <input type="text" name="dc3_desc" size="40" value="" />
            </td>
          </tr>
        </table>
      </div>
		</form>
  </div>
</div>

<script>
$(document).ready(function(){
  $.tabs('#tabs a'); 

  $.fn.arHistory = function(){
    $.ajax({
      type:'get',
      url:'index.php?route=sales/order/arHistory&token=<?php echo $token; ?>',
      dataType:'html',
      data:'store_id=<?php echo $id; ?>',
      success:function(html){
        $('#tab_ar_history').html(html);
      }
    });
  }
  
  $.fn.arHistory();
});
</script>