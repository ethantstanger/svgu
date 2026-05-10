const std = @import("std");
const c = @import("c");

pub fn helloWorld() void {
    _ = c.SDL_Init(c.SDL_INIT_VIDEO);
    defer c.SDL_Quit();

    const window = c.SDL_CreateWindow("Hello, world!", 640, 480, 0) orelse return;
    defer c.SDL_DestroyWindow(window);

    outer: while (true) {
        var event: c.SDL_Event = undefined;
        while (c.SDL_PollEvent(&event)) {
            if (event.type == c.SDL_EVENT_QUIT) break :outer;
        }
    }
}
