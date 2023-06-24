package main

import (
	glua "github.com/RyouZhang/go-lua"
)

// #cgo LDFLAGS: -static-libgcc -L/usr/local/lib -lluajit-5.1 -L${SRCDIR} -Wl,--whole-archive -lluabatteries -Wl,--no-whole-archive -Wl,-E
import "C"

func init() {
	opts := glua.NewOptions().SetPreloadScripeMethod(func() string {
		return `
		local ok, fennel = pcall(require, 'fennel')
		if ok then
			print(fennel.runtimeVersion())
			fennel.install()
			debug.traceback = fennel.traceback
		end

		ok, JSON = pcall(require, 'rapidjson')
		if not ok then
			JSON = require('json')
			JSON.null = nil
		end

		require('batteries')()
		`
	})
	glua.GlobalOptions(opts)
}
