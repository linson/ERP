<?php
/*
 !! DEPRECATED !!
 PDFlib extension
 so be final class so couldn't inherit
 just wrapping for simple usage
 i found that PDFlib is not automatically html to converto to PDF. 
 and decide to use wkhtmltopdf binary
 besso 201108 
 */
/***
class PDF{

  private $pdf;   // instance of PDFlib
  
  # meta
  private $width  = 595;
  private $height = 842;
  private $font1 = 'Helvetica-Bold';
  private $font2 = 'winansi';
  
  # configuration
  private $creator;   // input php file for creation
  private $author;
  private $title;
  private $filename;

  function __construct($conf){
    try{
      $this->pdf = new PDFlib();
      if ($this->pdf->begin_document("","") == 0){
        die("Error: " . $this->pdf->get_errmsg());
      }
      $this->creator = $conf['creator'];
      $this->author = $conf['author'];
      $this->title = $conf['title'];
      $this->filename = $conf['filename'];
            
      $status = $this->set_meta();
      $status = $this->set_info();
      $status = $this->render();
      
    }catch(PDFlibException $e){
      // error handling
      // $e->get_errnum()
      // $e->get_apiname()
    }
  }

  private function set_meta(){
    $status = true;
    $this->pdf->begin_page_ext($this->width,$this->height,'');
    
    $font = $this->pdf->load_font($this->font1,$this->font2,'');
    $this->pdf->setfont($font,24.0);
    $this->pdf->set_text_pos(50, 700);
    return $status;
      
  }

  private function set_info(){
    $status = true;
    $this->pdf->set_info('Creator',$this->creator);
    $this->pdf->set_info('Author',$this->author);
    $this->pdf->set_info('Title',$this->title);
    return $status;
  }
  
  private function render(){
    $content = file_get_contents($this->creator);
    $this->pdf->show($content);
    $this->pdf->continue_text("(says PHP)");
    $this->pdf->end_page_ext("");

    $this->pdf->end_document("");

    $buf = $this->pdf->get_buffer();
    $len = strlen($buf);

    header("Content-type: application/pdf");
    header("Content-Length: $len");
    header("Content-Disposition: inline; filename=". $this->filename );
    print $buf;
  }
}

$conf = array(
  'creator' => 'hello.html',
  'author'  => 'besso',
  'title'  => 'TITLE',
  'filename' => 'invoice.pdf'
);
$pdf = new PDF($conf);
***/
?>