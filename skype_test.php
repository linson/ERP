<?php
$dbus = dbus_bus_get(DBUS_BUS_SESSION);
/*
$dbus->registerObjectPath("/com/Skype/Client",'my_callback');

$m = new DBusMessage(DBUS_MESSAGE_TYPE_METHOD_CALL);
$m->setDestination("com.Skype.API");
$m->setPath("/com/Skype");
$m->setInterface("com.Skype.API");
$m->setMember("Invoke");
$m->setAutoStart(true);
$m->appendArgs("PROTOCOL 7");

$r = $dbus->sendWithReplyAndBlock($m);
$tmp = $r->getArgs();
*/
?>