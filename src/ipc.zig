const std: type = @import("std");

const stat: type = @cImport({
    @cInclude("sys/stat.h");
});

pub const output_type: type = enum { LOG, WARN, ERROR, PLUGIN };
pub const file_type: type = enum {
    OUT,
    IN,
};
pub const file_part: type = enum { FIRST, LAST };

pub fn init() !void {
    const input: []const u8 = "/tmp/spwm_in";
    const output: []const u8 = "/tmp/spwm_out";

    const fs: std.fs.Dir = std.fs.cwd();
    defer fs.close();

    const entry_in = fs.entry(input);
    if (!entry_in.exists()) {
        if (stat.mkfifo(input.ptr, 0o666) != 0) return error.CreationFailed;
    }

    const entry_out = fs.entry(output);
    if (!entry_out.exists()) {
        if (stat.mkfifo(output.ptr, 0o666) != 0) return error.CreationFailed;
    }
}

fn log_message(f: *std.fs.File, msg: []const u8) !void {
    try f.writeAll(msg);
    try f.flush();
}

fn get_path(ft: file_type) []const u8 {
    return switch (ft) {
        .INPUT => "/tmp/spwm_in",
        .OUTPUT => "/tmp/spwm_out",
    };
}

pub fn write(t: output_type, msg: []const u8) !void {
    var out: std.fs.File = try std.fs.cwd().openFile("/tmp/spwm_out", .{ .write = true });
    defer out.close();

    var str: std.ArrayList(u8) = std.ArrayList(u8).init(std.heap.page_allocator);
    defer str.deinit();

    switch (t) {
        output_type.PLUGIN => try str.appendSlice("PLUGIN: "),
        output_type.LOG => try str.appendSlice("DEBUG: "),
        output_type.WARN => try str.appendSlice("WARN: "),
        output_type.ERROR => try str.appendSlice("ERROR: "),
    }

    try str.appendSlice(msg);

    std.debug.print("{s}\n", .{str.items});
    try log_message(&out, str.items);
}

pub fn read(ft: file_type, line_num: usize) !?[]u8 {
    const path: []const u8 = get_path(ft);
    var file: std.fs.File = try std.fs.cwd().openFile(path, .{ .read = true });
    defer file.close();

    var reader: std.fs.File.Reader = file.reader();
    var buf: [1024]u8 = undefined;
    var current_line: usize = 0;

    while (true) {
        const n: ?[]u8 = try reader.readUntilDelimiterOrEof(&buf, '\n');
        if (n == 0) break;

        if (current_line == line_num) {
            return buf[0..n];
        }
        current_line += 1;
    }

    return null;
}
