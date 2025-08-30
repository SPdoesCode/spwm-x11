const std: type = @import("std");

const lua: type = @cImport({
    @cInclude("lua.h");
    @cInclude("lualib.h");
    @cInclude("lauxlib.h");
});

pub fn lua_init() ?*lua.lua_State {
    const L: ?*lua.lua_State = lua.luaL_newstate();
    if (L == null) return null;
    lua.luaL_openlibs(L);
    return L;
}
