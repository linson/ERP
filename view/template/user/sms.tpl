<?php echo $header; ?>
<?php if($success){ ?>
<div class="success"><?php echo $success; ?></div>
<?php } ?>
<div class="box">
  <div class="left"></div>
  <div class="right"></div>
  <div class="heading">
    <h1 style="background-image: url('view/image/product.png');"><font color=red>Use english Only</font> - Korean not work now. Difficult to solve tied with Verizon</h1>
    <div class="buttons">
      <a class="button send_sms"><span>Send SMS</span></a>
    </div>
  </div>
  <div class="content">
    <form action="<?php echo $lnk_sms; ?>" method="post" enctype="multipart/form-data" id="form">
      <table>
        <textarea name='sms_content' style='width:800px;height:100px;font-family:arial;'><?php echo $sms_content ?></textarea>
      </table>
      <table class="list">
        <thead>
          <tr>
            <td width="1" style="text-align: center;">
              <input type="checkbox" onclick="$('input[name*=\'selected\']').attr('checked', this.checked);" /></td>
            <td class="center">Sales</td>
            <td class="center">Email</td>
            <td class="center">phone</td>
          </tr>
        </thead>
        <tbody>
          <?php
          if( isset($sales) ){
          ?>
          <?php
          $total = 0;
//          $this->log->aPrint( $sales );
          foreach ($sales as $row){ 
          ?>
          <tr>
            <td style="text-align: center;">
              <?php if( isset($row['selected']) ){ ?>
              <input type="checkbox" name="selected[]" value="<?php echo $row['telephone']; ?>" checked="checked" />
              <?php }else{ ?>
              <input type="checkbox" name="selected[]" value="<?php echo $row['telephone']; ?>" />
              <?php } ?>
            </td>
            <td style="text-align: center;">
              <?php echo $row['username']; ?> ( <?php echo $row['firstname']; ?> &nbsp; <?php echo $row['lastname']; ?> )
            </td>
            <td class="center">
              <?php echo $row['email']; ?>
            </td>
            <td class="left"><?php echo $row['telephone']; ?></td>
          </tr>
          <?php } ?>
          <?php }else{ ?>
          <tr>
            <td class="center" colspan="4">No Result</td>
          </tr>
          <?php } ?>
        </tbody>
      </table>
    </form>
  </div>
</div>

<script type="text/javascript">
$(document).ready(function(){
  // batch_ship
  $('.send_sms').click(function(){
    $('#form').submit();
  });
});
</script>

<?php echo $footer; ?>