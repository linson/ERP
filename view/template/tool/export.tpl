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
    <div class="buttons">
      <a onclick="$('#form').submit();" class="button"><span><?php echo $button_import; ?></span></a>
      <a onclick="location='<?php echo $export; ?>'" class="button besso"><span><?php echo $button_export; ?>
      <a onclick="$('#export').submit();" class="button"><span><?php echo $button_backup; ?>
      </span></a></div>
  </div>

  <div class="content">
  
    <!-- Restore -->
    <form action="<?php echo $action; ?>" method="post" enctype="multipart/form-data" id="form">
      <table class="form">
        <tr>
          <td colspan="2"><?php echo $entry_description; ?></td>
        </tr>
        <tr>
          <td width="25%"><?php echo $entry_restore; ?></td>
          <td><input type="file" name="upload" /></td>
        </tr>
      </table>
    </form>

    <!-- export -->
    <form action="<?php echo $export_action; ?>" method="post" enctype="multipart/form-data" id="export">
      <table class="form">
        <tr>
          <td colspan="2"><?php echo $export_text; ?></td>
        </tr>
        <tr>
          <td><div class="scrollbox" style="margin-bottom: 5px;">
              <?php $class = 'odd'; ?>
              <?php foreach ($tables as $table) { ?>
              <?php $class = ($class == 'even' ? 'odd' : 'even'); ?>
              <div class="<?php echo $class; ?>">
                <input type="checkbox" name="backup[]" value="<?php echo $table; ?>" />
                <?php echo $table; ?> </div>
              <?php } ?>
            </div>
          </td>
        </tr>
      </table>
    </form>
    
  </div>


</div>
<?php echo $footer; ?>
