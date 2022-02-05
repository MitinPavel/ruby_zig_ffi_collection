const std = @import("std");

const Point = extern struct {
    x: i8,
    y: i8,
};

export fn generatePoints(addr_ptr: *usize, len_ptr: *u8) bool {
    var rnd = std.rand.DefaultPrng.init(std.crypto.random.int(u64)).random();
    var len = rnd.int(u8);
    var points = std.heap.c_allocator.alloc(Point, len) catch return false;
    var i: u8 = 0;
    while (i < len) : (i += 1) {
        points[i].x = rnd.int(i8);
        points[i].y = rnd.int(i8);
    }

    addr_ptr.* = @ptrToInt(points.ptr);
    len_ptr.* = len;

    return true;
}

export fn freePoints(points_ptr: [*]Point, len: u8) void {
    std.heap.c_allocator.free(points_ptr[0..len]);
}
