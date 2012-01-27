<?php echo $header; ?>
<div class="box">
  <div class="left"></div>
  <div class="right"></div>
  <div class="heading">
    <h1 style="background-image: url('view/image/product.png');">Promotion History</h1>
    <div class="buttons">
      <a onclick="location = '<?php echo $lnk_insert; ?>'" class="button"><span>Insert</span></a>
      <!--a id='batch_ship' class="button"><span>Ship</span></a-->
      <a id='batch_print' class="button"><span>Print</span></a>
      <a onclick="$('#form').submit();" class="button"><span>Delete</span></a></div>
  </div>
  <div class="content">
    <form action="<?php echo $lnk_delete; ?>" method="post" enctype="multipart/form-data" id="form">
      <table class="list">
        <thead>
          <tr style='height:30px'>
            <td align=center>Title</td>
            <td align=center>Price</td>
            <td align=center>Start</td>
            <td align=center>End</td>
            <td align=center>Model</td>
            <td align=center>Type</td>
            <td align=center>Updator</td>
            <td align=center></td>
          </tr>
        </thead>
        <tbody>
          <?php
          if($pr){
          ?>
          <?php 
          foreach ($pr as $row){ 
          ?>
          <tr>
            <td style="text-align: center;">
              <input type="hidden" name="id" value="<?php echo $row['id']; ?>" />
              <?php echo $row['name'] ?>
            </td>
            <td class="center">
              Over <?php echo $row['price'] ?>
            </td>
            <td class="center"><?php echo $row['start_date'] ?></td>
            <td class="center"><?php echo $row['end_date'] ?></td>
            <td class="center">
            <?php 
            $aModel = json_decode( $row['models'] );
            //$this->log->aPrint( $aModel );
            foreach($aModel as $k => $v){
              echo "$k :: $v";
              echo '<br/>';
            }
            ?>
            </td>
            <td class="center"><?php echo $row['storetype'] ?></td>
            <td class="center"><?php echo $row['updator'] ?></td>
            <td class="center"><a id='delete' class='button'><span>delete</span></a></td>
          </tr>
          <?php } ?>
          <?php }else{ ?>
          <tr>
            <td class="center" colspan="8">No Result</td>
          </tr>
          <?php } ?>
        </tbody>
      </table>
    </form>
  </div>
</div>

<script type="text/javascript">
$(document).ready(function(){
  $('#delete').bind('click',function(e){
    $tgt = $(e.target);
    $id = $tgt.parents('tr').find('input[name=id]').val();
    //alert($id);
    $.ajax({
      type:'get',
      url:'/backyard/index.php?route=sales/promotion/delete',
      dataType:'html',
      data:'id=' + $id,
      success:function(html){
        //window.location.reload(true);
      }
    })
  });
});
</script>

<?php echo $footer; ?>