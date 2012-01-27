<?php
//$this->log->aPrint( $stat );
?>
<?php echo $header; ?>
<div class="box">
  <div class="left"></div>
  <div class="center"></div>
  <div class="right"></div>
  <div class="heading">
    <h1 style="background-image: url('view/image/home.png');"><?php echo date('Y-m-d'); ?></h1>
    <div class="buttons">
      <a class="button btn_insert"><span>set Goal</span></a>
    </div>
  </div>

<style>
.bar{
  width:700px;
  height:30px;
  border:1px dotted black;
  margin-bottom:5px;
  margin:3px;
  font-size:13px;
  line-height:27px;
}
.stat{
  height:24px;
  background-color:peru;
  padding-left:10px;
  margin:3px;
  font-size:13px;
  line-height:27px;
  float:left;
}
</style>

<div class="content">
  <div id='thismonth'>
    <h3 style='padding-left:20px;'> This Month : <?php echo date('Y-m'); ?> </h3>
    <?php 
    if(count($stat) > 0){ // update
    ?>
    <?php
      foreach($stat as $row){
        $msg = $row['order_user'] . " :: " . $row['total'] . " / " . $row['target'] . " ( ". $row['count'] ." ) :: " . $row['percent'] . " %";
        $width = 700 * ( $row['percent'] / 100 );
        $bgColor = '#FFFF33';
        if($row['percent'] > 80){
          $bgColor = '#99FF66';
        }elseif($row['percent'] < 40){
          $bgColor = '#FF3399';
        }
    ?>
    <div class='bar'>
      
      <div class='stat' style='background-color:<?php echo $bgColor; ?>;width:<?php echo $width; ?>px'></div>
      <div style='float:left;margin-left:<?php echo $width * -1; ?>px;'><?php echo $msg; ?></div>
    </div>
    <?php
      } // end foreach
    } // end if
    ?>
  </div>

  <!--/br></br>
  <div id='lastmonth'>
    <h3 style='padding-left:20px;'> Last Month : <?php echo date('Y-m'); ?> </h3>
    <?php 
    if(count($stat) > 0){ // update
      foreach($stat as $row){
    ?>
    <div class='bar'>
      <div class='stat' style='width:<?php echo 700 * ( $row['percent'] / 100 ); ?>px'>
        <?php echo $row['order_user']; ?> :: ( <?php echo $row['total']; ?> / <?php echo $row['target']; ?> ) :: <?php echo $row['percent']; ?> %
      </div>
    </div>
    <?php
      } // end foreach
    } // end if
    ?>
  </div-->
</div>

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

<script type="text/javascript">
  $('.btn_insert').bind('click',function(event){
    $.ajax({
      type:'get',
      url:'index.php?route=sales/stat/callUpdatePannel',
      dataType:'html',
      data:'token=<?php echo $token; ?>&ddl=insert',
      success:function(html){
        $('#detail').css('visibility','visible');
        $('#detail').html(html);
        $('#detail').draggable(); 
      }
    });
  });
</script>
<?php echo $footer; ?>