local skynet = require "skynet"
require "skynet.manager"
local db = require "db"


local CMD = {}

function CMD.start()
    db:init()
end

function CMD.load_all_account()
    local ret = db:find_all("account")
    return ret
end

function CMD.new_account(info)
    db:insert("account", info)
end

skynet.start(function ()
    skynet.register("mongo")
    skynet.dispatch("lua", function (_, session, cmd, ...)
        local f = CMD[cmd]
        if not f then
            return
        end

        if session == 0 then
            f(...)
        else
            skynet.ret(skynet.pack(f(...)))
        end
    end)
end)

