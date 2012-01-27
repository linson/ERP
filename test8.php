<script>
var test = 'aaaaa\nbbb';
//alert(test);
//var billto = "<?php echo $store[0]['billto']; ?>",    shipto = "<?php echo $store[0]['shipto']; ?>";
</script>
<?php
$test = "aaaaa\nbbb";
?>
<textarea><?php echo str_replace(PHP_EOL,chr(13),$test); ?></textarea>
