<?php
// http://www.trirand.net/demophp.aspx
?>
<?php echo $header; ?>
<?php if ($error_warning) { ?>
<div class="warning"><?php echo $error_warning; ?></div>
<?php } ?>

<link rel='stylesheet' type='text/css' href='view/template/ar/detail.css' />
<!--link rel="stylesheet" type="text/css" media="screen" href="view/template/ar/jqgrid/themes/redmond/jquery-ui-1.8.2.custom.css" /-->
<!--link rel="stylesheet" type="text/css" media="screen" href="view/template/ar/jqgrid/themes/ui.jqgrid.css" /-->
<!--script src="view/template/ar/jqgrid/js/jquery.js" type="text/javascript"></script-->
<!--script src="view/template/ar/jqgrid/js/i18n/grid.locale-en.js" type="text/javascript"></script-->
<!--script src="view/template/ar/jqgrid/js/jquery.jqGrid.min.js" type="text/javascript"></script-->

<!-- atc -->
<script type='text/javascript' src='view/template/ar/atc/jquery/jquery.metadata.js'></script>
<script type='text/javascript' src='view/template/ar/atc/src/jquery.auto-complete.js'></script>
<link rel='stylesheet' type='text/css' href='view/template/ar/atc/src/jquery.auto-complete.css' />


<div class="box">
  <div class="left"></div><div class="center"></div><div class="right"></div>
  <div class="heading">
    <h1 style="background-image: url('view/image/product.png');">
      <a href='<?php echo $lnk_list; ?>' style='text-decoration:none;'>
      Back to List
      </a>
    </h1>
    <div class="buttons">
    </div>
  </div>
  <div class="content">
    <div id='storeList'>
      <table border='0' cellpadding="0" cellspacing="0">
        <tr>
          <td>
          <input type=text name='filter_accountno' class='atc' style='background-color:peru;' />
          </td>
        </tr>
        <tr>
          <td class='context'>
            <h2><?php echo $accountno; ?> &nbsp; <?php echo $salesrep; ?></h2>
          </td>
        <tr>
          <td class='context'>
            <input type='hidden' name='store_id' value='<?php echo $store_id; ?>' />
            <?php echo $store_name; ?>
          </td>
        </tr>
        </tr>
        <tr>
          <td colspan=2>
            <?php echo $address1; ?>
          </td>
        </tr>
        <tr>
          <td class='context'>
            <?php echo $city; ?> / <?php echo $state; ?> / <?php echo $zipcode; ?>
          </td>
        </tr>
        <tr>
          <td class='context'>
            <?php if('w' == strtolower($storetype)){ echo 'Wholesale'; }else{ echo 'Retail'; } ?>
          </td>
        </tr>
        <tr>
          <td class='context'>
            <?php echo $phone1; ?> <br/> <?php echo $fax; ?>
          </td>
        </tr>
        <tr>
          <td colspan=4 style='padding:0px;margin:0px;'>
            <textarea name='comment' id='comment' style='width:184px;height:300px;z-index:9'><?php echo $comment; ?></textarea>
          </td>
        </tr>
        <tr>
          <td align='right' style='font-size:14px;'>
            <a class="button memo_update"><span>Update</span></a>
          </td>
        </tr>
      </table>
    </div>
    <div id='storeMain'>
      <div id='storePay'>
        <!--div id='payment'>
          <table>
            <tr>
              <td> Amount : </td>
              <td class='context'>
                <input type='text' name='pay_price' class='pay_price'  value=''/>
                <input type='hidden' name='pay_user' value='<?php $this->user->getUserName(); ?>'/>            
              </td>
            <tr>
            </tr>
              <td> Date : </td>
              <td class='context'>
                <input type='text' class='date_pick' name='pay_date' value=''/>
              </td>
            </tr>
            <tr>
              <td> Method : </td>
              <td class='context'>
                <select name='pay_method[]'>
                  <option value="check" selected>check</option>
                  <option value="card">card</option>
                  <option value="cash">cash</option>
                  <option value="credit">credit</option>
                </select>
              </td>
            <tr>
            </tr>
              <td> Check.no : </td>
              <td class='context'>
                <input type='text' name='pay_num' value=''/>
                <p class='plus' style='float:right;margin:0px;margin-right:2px;' />
              </td>
            </tr>
          </table>
        </div-->
        <div id='account_history'>
        </div>
      </div>
      <div id='storeHistory'>
        <?php include "view/template/ar/finance.tpl"; ?>
      </div>
    </div>
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
  z-index:2;
}
</style>
<div id='detail'></div>

<script type="text/javascript">
$(document).ready(function(){
  <?php //include "view/template/ar/jqgrid/storeHistory.php"; ?>

  $('.memo_update').bind('click',function(e){
    var $el_comment = $('#comment'),
        $comment = $el_comment[0].value;
    $.ajax({
      type:'post',
      url:'<?php echo HTTP_SERVER; ?>/index.php?route=ar/detail/updateComment&token=<?php echo $token; ?>',
      dataType:'text',
      data:'store_id=<?php echo $store_id; ?>&comment=' + $comment,
      success:function(text){
        if('success' == text){
          $p = $('.memo_update').position();
          $imgCss = {
            'visibility':'visible',
            'width':'80px',
            'height':'20px',
            'top':$p.top-30,
            'left':$p.left-30,
            'background-color':'black',
            'color':'white',
            'text-align':'center'
          }
          $('#detail').css($imgCss);
          $('#detail').html('success');
          //$('#detail').draggable(); 
        }
      },
      fail:function(){
      }
    });
  });

  $.fn.arHistory = function(){
    $.ajax({
      type:'get',
      url:'<?php echo HTTP_SERVER; ?>/index.php?route=ar/detail/arHistory&token=<?php echo $token; ?>',
      dataType:'html',
      data:'store_id=<?php echo $store_id; ?>',
      success:function(html){
        $('#account_history').html(html);
      },
      fail:function(){
        //debugger;
        //console.log('fail : no response from proxy');
      }
    });
  }
  $.fn.arHistory();

  // need to check what prevent atc under focus status, besso
  //$('input.atc').focus();

  // quick search
  /***
  $('input[name=filter_accountno]').bind('keydown',function(e){
    $tgt = $(e.target);
    if( e.keyCode == '13' ){  
      location.href = 'index.php?route=ar/detail&token=<?php echo $this->session->data['token']; ?>&accountno='+$(this).val();	
    }
  });
  ***/
  
  $('input.atc').focus().autoComplete();
  /*
  .bind('mousedown',function(e){
    $this = $(this);
    $options = {
      'width':'150px'
    }
    $this.autoComplete();
  })
  **/
});
</script>
<?php echo $footer; ?>