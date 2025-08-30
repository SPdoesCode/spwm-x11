const std: type = @import("std");

const cfg: type = @import("conf.zig");

const token: type = struct {
    vale: []const u8,
};

pub fn ipc_to_conf(conf: *cfg.config, cmd: []const u8) !void {}
