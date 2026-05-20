const svgu = @import("svgu");

pub fn main() !void {
    defer svgu.deinit();

    const window = try svgu.Window.init("Hello, world!");
    defer window.deinit();

    outer: while (true) {
        var event: svgu.c.SDL_Event = undefined;
        while (svgu.c.SDL_PollEvent(&event)) {
            if (event.type == svgu.c.SDL_EVENT_QUIT) break :outer;
        }
    }
}
