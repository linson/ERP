<div style='float:left;'>
<table border=0>
  <tr>
    <td>
      <span style='font-size:20px;font-weight:bold;' id='txid_header'><?php if($txid){ echo $txid; }else{ /*echo '<font color=red>New Order</font>';*/ } ?></span>
    </td>
    <td>

      <a class="button"><span>Order for </span></a>
      <select name='for_who'>
        <?php
        // test
        // $executor = 'YK';
        // $order_user = 'BJ';
        if( !$executor ){
          echo "<option value='' >----------</option>";
        }
        $aSales = $this->user->getSales();
        foreach($aSales as $row){
          $for_who = $row;
          $selected = ( $executor && ( $salesrep == $for_who ) ) ? 'selected' : '' ;
          echo "<option value='$for_who' $selected>$for_who</option>";
        }
        ?>
      </select>
      <?php
        if($executor && ($executor != $salesrep)){
          echo "&nbsp;&nbsp;<font color=red><b>By $executor at $order_date</b></font>";
        }
      ?>

      <span style='margin-left:30px'>
        Status :
        &nbsp;
        <select name='hold'>
          <option value='0'  <?php if($status == '0') echo 'selected' ?> >Before Submit</option>
          <option value='1'  <?php if($status == '1') echo 'selected' ?> >Submit</option>
          <option value='2'  <?php if($status == '2') echo 'selected' ?> >Hold Request</option>
          <option value='3'  <?php if($status == '3') echo 'selected' ?> >Invoice Only</option>
        </select>
      </span>

    
    </td>
    <?php if($txid){ ?>
    <td style='border:0px dotted peru'>
      <?php echo $approved_user; ?>
    </td>
    <td style='border:0px dotted peru'>
      <?php echo $approved_date; ?>
    </td>
    <td style='border:0px dotted peru;text-align:center;'>
      <span id='approve'>
        <?php if('approve' == $approve_status ){ echo '<font size=3 color=blue><b>approve</b></font>'; }else{ 
          if( true == $bApprove ){
        ?>
        <a class="button"><span class='approve'>Approve</span></a>
        <?php }} ?>
      </span>
    </td>
    <td style='border:0px dotted peru;text-align:center;'>
      <span id='pending'>
        <?php if('pending' == $approve_status){ echo '<font size=3 color=blue><b>Pending</b></font>'; }else{ 
        if( true == $bApprove ){
        ?>
        <a class="button"><span class='pending'>Pending</span></a>
        <?php }} ?>
      </span>
    </td>
  </tr>
  <?php } ?>
</table>
</div>