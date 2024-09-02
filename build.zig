const std = @import("std");

// Although this function looks imperative, note that its job is to
// declaratively construct a build graph that will be executed by an external
// runner.
pub fn build(b: *std.Build) void {
    const arm_target = .{ 
        .cpu_arch = .arm, 
        .os_tag = .freestanding, 
        .abi = .eabi
    };
    const optimize = b.standardOptimizeOption(.{});
    const elf = b.addExecutable(.{
        .name = "kernel8.elf",
        .root_source_file = b.path("src/main.zig"),
        .target = b.resolveTargetQuery(arm_target),
        .optimize = optimize,
    });


    elf.setLinkerScript(b.path("linker.ld"));
    b.installArtifact(elf);

    const img = b.addObjCopy(elf.getEmittedBin(), .{
        .format = .bin
    });
    img.step.dependOn(&elf.step);
    
    const r = b.addSystemCommand(&[_][]const u8{
        "arm-none-eabi-objcopy",
        "zig-out/bin/kernel8.elf",
        "-O",
        "binary",
        "kernel8.img"
    });

    r.step.dependOn(&img.step);
    b.getInstallStep().dependOn(&r.step);
}
