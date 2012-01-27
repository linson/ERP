<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.5.1/jquery.min.js"></script>
<script type="text/javascript" src="view/javascript/jquery/jquery.validate.js"></script>
<script type="text/javascript">
/* <![CDATA[ */
jQuery(function(){
    jQuery("#ValidNumber").validate({
        expression: "if (!isNaN(VAL) && VAL) return true; else return false;",
        message: "Should be a number"
    });
    jQuery("#Email").validate({
        expression: "if (VAL.match(/^[^\\W][a-zA-Z0-9\\_\\-\\.]+([a-zA-Z0-9\\_\\-\\.]+)*\\@[a-zA-Z0-9_]+(\\.[a-zA-Z0-9_]+)*\\.[a-zA-Z]{2,4}$/)) return true; else return false;",
        message: "Should be a valid Email id"
    });
    jQuery("#ValidNumber").validate({
        expression: "if (VAL > 100) return true; else return false;",
        message: "Should be greater than 100"
    });
    jQuery("#Mobile").validate({
        expression: "if (VAL.match(/^[9][0-9]{9}$/)) return true; else return false;",
        message: "Should be a valid Mobile Number"
    });
});
/* ]]> */
</script>

<form action="" method="post">
    <table cellpadding="3" cellspacing="2">
        <tr>
            <td>
                Enter a valid number greater than 100
            </td>
            <td>

                <input type="text" name="ValidNumber" id="ValidNumber" />
            </td>
        </tr>
        <tr>
            <td>
                Enter a valid Email
            </td>
            <td>
                <input type="text" name="Email" id="Email" />

            </td>
        </tr>
        <tr>
            <td>
                Enter a valid Mobile Number 
                <small>
                    (Eg: 9854398543)
                </small>
            </td>
            <td>

                <input type="text" name="Mobile" id="Mobile" />
            </td>
        </tr>
        <tr>
            <td>
            </td>
            <td>
                <input type="submit" value="Submit" style="background: #EFEFEF;"/>
            </td>

        </tr>
    </table>
</form>
