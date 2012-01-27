<?php header("Content-Type: text/html; charset=UTF-8") ?>
<?php echo $header; ?>
<?php if ($error_warning) { ?>
<div class="warning"><?php echo $error_warning; ?></div>
<?php } ?>
<?php if ($success) { ?>
<div class="success"><?php echo $success; ?></div>
<?php } ?>
<div class="box">
  <div class="left"></div>
  <div class="right"></div>
  <div class="heading">
    <h1 style="background-image: url('view/image/backup.png');"><?php echo $heading_title; ?></h1>
  </div>
  <div class="content">
    <div id="tabs" class="htabs"><a tab="#tab_general"><?php echo $tab_general; ?></a></div>
    <div id="tab_general">
      <form action="<?php echo $csv_import; ?>" method="post" enctype="multipart/form-data" id="csv_import">
        <table class="form">
          <tr>
            <td><?php echo $entry_import; ?></td>
            <td><input type="file" name="csv_import" /></td>
            <td><a onclick="$('#csv_import').submit();" class="button"><span><?php echo $button_restore; ?></span></a></td>
          </tr>
        </table>
      </form>
      <form action="<?php echo $csv_export; ?>" method="post" enctype="multipart/form-data" id="csv_export">
        <table class="form">
          <tr>
            <td><?php echo $entry_export; ?></td>
            <td><select name="csv_export">
              <?php foreach ($tables as $table) { ?>
              <option value="<?php echo $table; ?>" /><?php echo $table; ?></option>
              <?php } ?>
            </select></td>
            <td><a onclick="$('#csv_export').submit();" class="button"><span><?php echo $button_backup; ?></span></a></td>
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