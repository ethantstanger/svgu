const sme = @import("sme");

pub fn main() !void {
    defer sme.deinit();

    const window = try sme.Window.init("Hello, world!");
    defer window.deinit();

    outer: while (true) {
        var event: sme.c.SDL_Event = undefined;
        while (sme.c.SDL_PollEvent(&event)) {
            if (event.type == sme.c.SDL_EVENT_QUIT) break :outer;
        }
    }
}
