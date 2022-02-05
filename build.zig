const std = @import("std");

pub fn build(b: *std.build.Builder) void {
    const lib = b.addSharedLibrary("points", "src/main.zig", .unversioned);
    lib.linkLibC();
    lib.setBuildMode(.ReleaseSafe);
    lib.install();
}
