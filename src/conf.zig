const std: type = @import("std");

const value_type: type = union(enum) {
    string: []const u8,
    number: usize,
    boolean: bool,
};

pub const variable: type = struct {
    name: []const u8,
    t: type,
    value: value_type,
};

pub const block: type = struct {
    name: []const u8,
    vars: []variable,
};

pub const config: type = struct {
    allow_unsafe: bool,
    use_default_bar: bool,
    colors: []variable,
    blocks: []block,
};
