const std = @import("std");

const Example = struct {
    name: []const u8,
    path: []const u8,
    desc: []const u8,
};

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const translate_c = b.addTranslateC(.{
        .root_source_file = b.path("c-dep/dep.c"),
        .target = target,
        .optimize = optimize,
    });
    translate_c.linkSystemLibrary("sdl3", .{});
    const c_dep_mod = translate_c.createModule();

    const window_mod = b.createModule(.{
        .root_source_file = b.path("src/Window.zig"),
        .target = target,
        .optimize = optimize,
    });
    window_mod.addImport("c", c_dep_mod);

    const root_mod = b.addModule("svgu", .{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
    });
    root_mod.addImport("c", c_dep_mod);
    root_mod.addImport("Window", window_mod);

    const examples = [_]Example{
        .{
            .name = "hello-world",
            .path = "examples/hello_world.zig",
            .desc = "A basic Hello, world! program",
        },
    };

    const examples_step = b.step("examples", "Build all the examples");
    for (examples) |it| {
        const mod = b.createModule(.{
            .root_source_file = b.path(it.path),
            .target = target,
            .optimize = optimize,
        });
        mod.addImport("svgu", root_mod);

        const exe = b.addExecutable(.{ .name = it.name, .root_module = mod });
        examples_step.dependOn(&b.addInstallArtifact(exe, .{}).step);

        const run_step = b.step(it.name, it.desc);
        const run_exe = b.addRunArtifact(exe);
        run_step.dependOn(&run_exe.step);
    }
}
