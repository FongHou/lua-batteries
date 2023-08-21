local fennel = require("fennel")
local unpack = (table.unpack or _G.unpack)
local now
local function _1_()
  local t = package.loaded.posix.gettimeofday()
  return (t.sec + (t.usec / 1000000))
end
now = ((pcall(require, "socket") and package.loaded.socket.gettime) or (pcall(require, "posix") and package.loaded.posix.gettimeofday and _1_) or os.time)
local function result_table(name)
  return {["started-at"] = now(), err = {}, fail = {}, name = name, pass = {}, skip = {}, ran = 0, tests = {}}
end
local function combine_results(to, from)
  for _, s in ipairs({"pass", "fail", "skip", "err"}) do
    for name, val in pairs(from[s]) do
      to[s][name] = val
    end
  end
  return nil
end
local function fn_3f(v)
  return (type(v) == "function")
end
local function count(t)
  local c = 0
  for _ in pairs(t) do
    c = (c + 1)
  end
  return c
end
local function fail__3estring(_2_, name)
  local _arg_3_ = _2_
  local where = _arg_3_["where"]
  local reason = _arg_3_["reason"]
  local msg = _arg_3_["msg"]
  return string.format("FAIL: %s: %s\n  %s%s\n", where, name, (reason or ""), ((msg and (" - " .. tostring(msg))) or ""))
end
local function err__3estring(_4_, name)
  local _arg_5_ = _4_
  local msg = _arg_5_["msg"]
  return (msg or string.format("ERROR (in %s, couldn't get traceback)", (name or "(unknown)")))
end
local function get_where(start)
  local traceback = fennel.traceback(nil, start)
  local _, _0, where = traceback:find("\n *([^:]+:[0-9]+):")
  return (where or "?")
end
local checked = nil
local function pass()
  return {char = ".", type = "pass"}
end
local function error_result(msg)
  return {char = "E", type = "err", tostring = err__3estring, msg = msg}
end
local function skip()
  return error({char = "s", type = "skip"})
end
local function is(got, _3fmsg)
  checked = (checked + 1)
  if not got then
    return error({char = "F", msg = _3fmsg, reason = string.format("Expected truthy value"), tostring = fail__3estring, type = "fail", where = get_where(4)})
  else
    return nil
  end
end
local function error_2a(f, _3fmsg)
  local _7_, _8_ = pcall(f)
  if ((_7_ == true) and (nil ~= _8_)) then
    local val = _8_
    checked = (checked + 1)
    if not false then
      return error({char = "F", msg = _3fmsg, reason = string.format("Expected an error, got %s", fennel.view(val)), tostring = fail__3estring, type = "fail", where = get_where(4)})
    else
      return nil
    end
  else
    return nil
  end
end
local function error_match(pat, f, _3fmsg)
  local _11_, _12_ = pcall(f)
  if ((_11_ == true) and (nil ~= _12_)) then
    local val = _12_
    checked = (checked + 1)
    if not false then
      return error({char = "F", msg = _3fmsg, reason = string.format("Expected an error, got %s", fennel.view(val)), tostring = fail__3estring, type = "fail", where = get_where(4)})
    else
      return nil
    end
  elseif (true and (nil ~= _12_)) then
    local _ = _11_
    local err = _12_
    local err_string
    if (type(err) == "string") then
      err_string = err
    else
      err_string = fennel.view(err)
    end
    checked = (checked + 1)
    if not err_string:match(pat) then
      return error({char = "F", msg = _3fmsg, reason = string.format("Expected error to match pattern %s, was %s", pat, err_string), tostring = fail__3estring, type = "fail", where = get_where(4)})
    else
      return nil
    end
  else
    return nil
  end
end
local function extra_fields_3f(t, keys)
  local function _17_()
    local extra_3f = false
    for k in pairs(t) do
      if extra_3f then break end
      if (nil == keys[k]) then
        extra_3f = true
      else
        keys[k] = nil
        extra_3f = nil
      end
    end
    return extra_3f
  end
  return (_17_() or next(keys))
end
local function table_3d(x, y, equal_3f)
  local keys = {}
  local function _19_()
    local same_3f = true
    for k, v in pairs(x) do
      if not same_3f then break end
      keys[k] = true
      same_3f = equal_3f(v, y[k])
    end
    return same_3f
  end
  return (_19_() and not extra_fields_3f(y, keys))
end
local function equal_3f(x, y)
  return ((x == y) or ((function(_20_,_21_,_22_) return (_20_ == _21_) and (_21_ == _22_) end)(type(x),"table",type(y)) and table_3d(x, y, equal_3f)))
end
local function _3d_2a(exp, got, _3fmsg)
  checked = (checked + 1)
  if not equal_3f(exp, got) then
    return error({char = "F", msg = _3fmsg, reason = string.format("Expected %s, got %s", fennel.view(exp), fennel.view(got)), tostring = fail__3estring, type = "fail", where = get_where(4)})
  else
    return nil
  end
end
local function not_3d_2a(exp, got, _3fmsg)
  checked = (checked + 1)
  if not not equal_3f(exp, got) then
    return error({char = "F", msg = _3fmsg, reason = string.format("Expected something other than %s", fennel.view(exp)), tostring = fail__3estring, type = "fail", where = get_where(4)})
  else
    return nil
  end
end
local function _3c_2a(...)
  local args = {...}
  local msg
  if ("string" == type(args[#args])) then
    msg = table.remove(args)
  else
    msg = nil
  end
  local correct_3f
  do
    local ok_3f = true
    for i = 2, #args do
      if not ok_3f then break end
      ok_3f = (args[(i - 1)] < args[i])
    end
    correct_3f = ok_3f
  end
  checked = (checked + 1)
  if not correct_3f then
    return error({char = "F", msg = msg, reason = string.format("Expected arguments in strictly increasing order, got %s", fennel.view(args)), tostring = fail__3estring, type = "fail", where = get_where(4)})
  else
    return nil
  end
end
local function _3c_3d_2a(...)
  local args = {...}
  local msg
  if ("string" == type(args[#args])) then
    msg = table.remove(args)
  else
    msg = nil
  end
  local correct_3f
  do
    local ok_3f = true
    for i = 2, #args do
      if not ok_3f then break end
      ok_3f = (args[(i - 1)] <= args[i])
    end
    correct_3f = ok_3f
  end
  checked = (checked + 1)
  if not correct_3f then
    return error({char = "F", msg = msg, reason = string.format("Expected arguments in increasing/equal order, got %s", fennel.view(args)), tostring = fail__3estring, type = "fail", where = get_where(4)})
  else
    return nil
  end
end
local function almost_3d(exp, got, tolerance, _3fmsg)
  checked = (checked + 1)
  if not (math.abs((exp - got)) <= tolerance) then
    return error({char = "F", msg = _3fmsg, reason = string.format("Expected %s +/- %s, got %s", exp, tolerance, got), tostring = fail__3estring, type = "fail", where = get_where(4)})
  else
    return nil
  end
end
local function identical(exp, got, _3fmsg)
  checked = (checked + 1)
  if not (exp == got) then
    return error({char = "F", msg = _3fmsg, reason = string.format("Expected %s, got %s", fennel.view(exp), fennel.view(got)), tostring = fail__3estring, type = "fail", where = get_where(4)})
  else
    return nil
  end
end
local function match_2a(pat, s, _3fmsg)
  checked = (checked + 1)
  if not tostring(s):match(pat) then
    return error({char = "F", msg = _3fmsg, reason = string.format("Expected string to match pattern %s, was\n%s", pat, s), tostring = fail__3estring, type = "fail", where = get_where(4)})
  else
    return nil
  end
end
local function not_match(pat, s, _3fmsg)
  checked = (checked + 1)
  if not ((type(s) ~= "string") or not s:match(pat)) then
    return error({char = "F", msg = _3fmsg, reason = string.format("Expected string not to match pattern %s, was\n %s", pat, s), tostring = fail__3estring, type = "fail", where = get_where(4)})
  else
    return nil
  end
end
local function dot(c, ran)
  io.write(c)
  if (0 == math.fmod(ran, 76)) then
    io.write("\n  ")
  else
  end
  return (io.stdout):flush()
end
local function print_totals(_34_)
  local _arg_35_ = _34_
  local pass0 = _arg_35_["pass"]
  local fail = _arg_35_["fail"]
  local skip0 = _arg_35_["skip"]
  local err = _arg_35_["err"]
  local started_at = _arg_35_["started-at"]
  local ended_at = _arg_35_["ended-at"]
  local elapsed = (ended_at - started_at)
  local elapsed_string
  if (elapsed < 1) then
    elapsed_string = string.format(" in %.2f %s", (elapsed * 1000), "ms")
  else
    elapsed_string = string.format(" in %.2f %s", elapsed, "s")
  end
  local buf = {"\n---- Testing finished%s ", "with %d assertion(s) ----\n", "  %d passed, %d failed, ", "%d error(s), %d skipped.\n"}
  return print(table.concat(buf):format(elapsed_string, checked, count(pass0), count(fail), count(err), count(skip0)))
end
local function begin_module(s_env, tests)
  return print(string.format("\n-- Starting module %s, %d test(s)", s_env.name, count(tests)))
end
local function done(results)
  print("\n")
  for _, ts in ipairs({results.fail, results.err, results.skip}) do
    for name, result in pairs(ts) do
      if result.tostring then
        print(result:tostring(name))
      else
      end
    end
  end
  return print_totals(results)
end
local default_hooks
local function _38_(_name, result, ran)
  return dot(result.char, ran)
end
default_hooks = {done = done, ["begin-module"] = begin_module, ["end-test"] = _38_, begin = false, ["begin-test"] = false, ["end-module"] = false}
local function test_key_3f(k)
  return ((type(k) == "string") and k:match("^test.*"))
end
local ok_types = {fail = true, pass = true, skip = true}
local function err_handler(name)
  local function _39_(e)
    if ((type(e) == "table") and ok_types[e.type]) then
      return e
    else
      return error_result(fennel.traceback(string.format("\nERROR in %s():\n  %s\n", name, e), 4))
    end
  end
  return _39_
end
local function run_test(name, _3fsetup, test, _3fteardown, module_result, hooks, context)
  if fn_3f(hooks["begin-test"]) then
    hooks["begin-test"](name)
  else
  end
  local started_at = now()
  local result
  local function _42_(...)
    local _43_, _44_ = ...
    if (_43_ == true) then
      local function _45_(...)
        local _46_, _47_ = ...
        if (_46_ == true) then
          return pass()
        elseif (true and (nil ~= _47_)) then
          local _ = _46_
          local err = _47_
          return err
        else
          return nil
        end
      end
      local function _49_()
        return test(unpack(context))
      end
      return _45_(xpcall(_49_, err_handler(name)))
    elseif (true and (nil ~= _44_)) then
      local _ = _43_
      local err = _44_
      return err
    else
      return nil
    end
  end
  local function _51_()
    if _3fsetup then
      return xpcall(_3fsetup, err_handler(name))
    else
      return true
    end
  end
  result = _42_(_51_())
  if _3fteardown then
    pcall(_3fteardown, unpack(context))
  else
  end
  result.elapsed = (now() - started_at)
  do end (module_result)[result.type][name] = result
  module_result.ran = (module_result.ran + 1)
  if fn_3f(hooks["end-test"]) then
    return hooks["end-test"](name, result, module_result.ran)
  else
    return nil
  end
end
local function run_setup(setup, results, module_name)
  if fn_3f(setup) then
    local _54_ = {pcall(setup)}
    if ((_G.type(_54_) == "table") and (_54_[1] == true)) then
      local context = {select(2, (table.unpack or _G.unpack)(_54_))}
      return context
    elseif ((_G.type(_54_) == "table") and (_54_[1] == false) and (nil ~= _54_[2])) then
      local err = _54_[2]
      local msg = string.format("ERROR in test module %s setup: %s", module_name, err)
      do end (results.err)[module_name] = error_result(msg)
      return nil, err
    else
      return nil
    end
  else
    return {}
  end
end
local function run_module(hooks, results, module_name, test_module)
  assert(("table" == type(test_module)), ("test module must be table: " .. module_name))
  local result = result_table(module_name)
  local _57_ = run_setup(test_module["setup-all"], results, module_name)
  if (nil ~= _57_) then
    local context = _57_
    if hooks["begin-module"] then
      hooks["begin-module"](result, test_module)
    else
    end
    for name, test in pairs(test_module) do
      if test_key_3f(name) then
        table.insert(result.tests, test)
        run_test(name, test_module.setup, test, test_module.teardown, result, hooks, context)
      else
      end
    end
    do
      local _60_ = test_module["teardown-all"]
      if (nil ~= _60_) then
        local teardown = _60_
        pcall(teardown, unpack(context))
      else
      end
    end
    if hooks["end-module"] then
      hooks["end-module"](result)
    else
    end
    return combine_results(results, result)
  else
    return nil
  end
end
local function exit(hooks)
  if hooks.exit then
    return hooks.exit(1)
  elseif _G.___replLocals___ then
    return "failed"
  elseif (os and os.exit) then
    return os.exit(1)
  else
    return nil
  end
end
local function run(module_names, _3fhooks)
  checked = 0
  do end (io.stdout):setvbuf("line")
  for _, m in ipairs(module_names) do
    if not pcall(require, m) then
      package.loaded[m] = nil
    else
    end
  end
  local hooks = setmetatable((_3fhooks or {}), {__index = default_hooks})
  local results = result_table("main")
  if hooks.begin then
    hooks.begin(results, module_names)
  else
  end
  for _, module_name in ipairs(module_names) do
    local _67_, _68_ = pcall(require, module_name)
    if ((_67_ == true) and (nil ~= _68_)) then
      local test_mod = _68_
      run_module(hooks, results, module_name, test_mod)
    elseif ((_67_ == false) and (nil ~= _68_)) then
      local err = _68_
      results.err[module_name] = error_result(("ERROR loading test module %q:\n  %s"):format(module_name, err))
    else
    end
  end
  results["ended-at"] = now()
  if hooks.done then
    hooks.done(results)
  else
  end
  if (next(results.err) or next(results.fail)) then
    return exit(hooks)
  else
    return nil
  end
end
return {run = run, skip = skip, version = "0.1.2-dev", is = is, error = error_2a, ["error-match"] = error_match, ["="] = _3d_2a, ["not="] = not_3d_2a, ["<"] = _3c_2a, ["<="] = _3c_3d_2a, ["almost="] = almost_3d, identical = identical, match = match_2a, ["not-match"] = not_match}
