const std = @import("std");

const Example = struct {
    name: []const u8,
    path: []const u8,
    desc: []const u8,
};

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const root_mod = b.addModule("sme", .{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
    });

    const examples = [_]Example{
        .{
            .name = "hello_world",
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
        mod.addImport("sme", root_mod);

        const exe = b.addExecutable(.{ .name = it.name, .root_module = mod });
        examples_step.dependOn(&b.addInstallArtifact(exe, .{}).step);

        const run_step = b.step(it.name, it.desc);
        const run_exe = b.addRunArtifact(exe);
        run_step.dependOn(&run_exe.step);
    }
}
