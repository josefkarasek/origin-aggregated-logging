#!/bin/bash
# check if execonly...suspended works when the first action is *not*
# suspended --> file1 must be created, file 2 not
# rgerhards, 2015-05-27
echo =====================================================================================
echo \[execonlywhenprevsuspended-nonsusp\]: test execonly...suspended functionality with non-suspended action

. $srcdir/diag.sh init
generate_conf
add_conf '
main_queue(queue.workerthreads="1") 

# omtesting provides the ability to cause "SUSPENDED" action state
module(load="../plugins/omtesting/.libs/omtesting")

$MainMsgQueueTimeoutShutdown 100000
template(name="outfmt" type="string" string="%msg:F,58:2%\n")

:msg, contains, "msgnum:" {
	action(type="omfile" file=`echo $RSYSLOG_OUT_LOG` template="outfmt")
	action(type="omfile" file=`echo $RSYSLOG2_OUT_LOG` template="outfmt"
	       action.ExecOnlyWhenPreviousIsSuspended="on"
	      )
}
'
startup
. $srcdir/diag.sh injectmsg 0 1000
shutdown_when_empty
wait_shutdown
seq_check 0 999
if [ -e rsyslog2.out.log ]; then
    echo "error: \"suspended\" file exists, first 10 lines:"
    $RS_HEADCMD rsyslog2.out.log
    exit 1
fi
exit_test
