return {
    "quentingruber/pomodoro.nvim",
    cmd = {
        "PomodoroStart",
        "PomodoroStop",
        "PomodoroUI",
        "PomodoroSkipBreak",
        "PomodoroForceBreak",
        "PomodoroDelayBreak",
    },
    opts = {
        start_at_launch = false,
        work_duration = 50,
        break_duration = 10,
        delay_duration = 1, -- The additional work time you get when you delay a break
        long_break_duration = 20,
        breaks_before_long = 2,
    },
}
