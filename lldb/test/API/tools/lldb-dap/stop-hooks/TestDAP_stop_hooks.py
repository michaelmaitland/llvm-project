"""
Test stop hooks
"""

from lldbsuite.test.decorators import *
from lldbsuite.test.lldbtest import *
import lldbdap_testcase


class TestDAP_stop_hooks(lldbdap_testcase.DAPTestCaseBase):
    def test_stop_hooks_before_run(self):
        """
        Test that there is no race condition between lldb-dap and
        stop hooks executor
        """
        program = self.getBuildArtifact("a.out")
        preRunCommands = ["target stop-hook add -o help"]
        self.build_and_launch(program, preRunCommands=preRunCommands)
        breakpoint_ids = self.set_function_breakpoints(["main"])
        # This request hangs if the race happens, because, in that case, the
        # command interpreter is in synchronous mode while lldb-dap expects
        # it to be in asynchronous mode, so, the process doesn't send the stop
        # event to "lldb.Debugger" listener (which is monitored by lldb-dap).
        self.continue_to_breakpoints(breakpoint_ids)

        self.continue_to_exit()
