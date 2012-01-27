<?php header("Content-Type: text/html; charset=UTF-8") ?>
<?php echo $header; ?>
<?php if ($error_warning) { ?>
<div class="warning"><?php echo $error_warning; ?></div>
<?php } ?>
<?php if ($success) { ?>
<div class="success">QuickBook Import Done</div>
<?php } ?>
<div class="box">
  <div class="left"></div>
  <div class="right"></div>
  <div class="heading">
    <h1 style="background-image: url('view/image/backup.png');">QuickBook AR import</h1>
  </div>
  <div class="content">
    <div id="tabs" class="htabs"><a tab="#tab_general"><?php echo $tab_general; ?></a></div>
    <div id="tab_general">
      <form action="<?php echo $csv_import; ?>" method="post" enctype="multipart/form-data" id="csv_import">
        <table class="form">
          <tr>
            <td>AR File</td>
            <td><input type="file" name="csv_import" /></td>
            <td><a onclick="$('#csv_import').submit();" class="button"><span><?php echo $button_restore; ?></span></a></td>
          </tr>
        </table>
      </form>
    </div>
  </div>
</div>
<script type="text/javascript"><!--
$.tabs('#tabs a');
//--></script>
<?php echo $footer; ?>