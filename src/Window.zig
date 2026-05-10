const c = @import("c");

const Window = @This();

handle: *c.SDL_Window,

const InitError = error { video_subsystem, window };
pub fn init(title: [*c]const u8) InitError!Window {
    if (!c.SDL_InitSubSystem(c.SDL_INIT_VIDEO)) return InitError.video_subsystem;
    const handle = c.SDL_CreateWindow(title, 640, 480, 0) orelse return InitError.window;
    return .{.handle = handle};
}

pub fn deinit(self: Window) void {
    c.SDL_DestroyWindow(self.handle);
}
