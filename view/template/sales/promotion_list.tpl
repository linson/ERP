          <?php if(isset($products)) { ?>
          <?php foreach ($products as $row) { ?>
          <tr>
            <td class='center accountno_in_list'>
              <input type="hidden" name="id[]" class='id_in_list' value="<?php echo $row['model']; ?>" />
              <input type='hidden' name='view' value='proxy' />
              <?php echo $row['model']; ?>
            </td>
            <!--td class='center name_in_list'-->
            <td>
              <a onclick='' class='edit'>
              <?php echo $row['name']; ?></a>
            </td>
          </tr>
          <?php } // end foreach ?>
          <?php } else { ?>
          <tr>
            <td class="center" colspan="11">No Result</td>
          </tr>
          <?php } ?>
          
<script>
  $('#storeTable tbody tr').draggable({
    revert:'invalid',
    helper:'clone'
  });
  
  $('#btripTable').droppable({
    drop:function(event,ui){
      $('#btripTable')
        .append(ui.draggable)
        .find("tr:last-child td:last-child").append('<input type=text name=cnt[] value=1 size=1/>');
      
    }
  });
  
  $.fn.btripDND = function(){
    $('#btripTable tr').draggable({
      revert:'invalid',
      helper:'clone'
    });
    $('#storeTable').droppable({
      drop:function(event,ui){
        $('#storeTable').append(ui.draggable);
      }
    });
  }
  $.fn.btripDND();
</script>