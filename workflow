#!/usr/bin/env coffee

http = require "http"
shelljs = require "shelljs/global"

url = "http://10.0.0.184:8703"
arr = process.argv.splice(2)
parms = ""

action =
{
    revert: () ->
        request = http.get("#{url}/Revert", (res) =>
            res.setEncoding("utf-8")
            res.on("data", (data) =>
                console.log(data)
            )
        )
        request.on("error", (err) =>
            console.error(err)
        )

    publish: () ->
        if(parms isnt null and parms.length is 2)
            console.log "publish parm"
            request = http.get("#{url}/Publish?cmName=#{parms[0]}&tag=#{parms[1]}", (error, response, body) =>
                console.log(body)
            )
        if(parms is null or parms is "")
            console.log "publish"
            request = http.get("#{url}/Publish", (error, response, body) =>
                console.log(body)
            )
        request.on("error", (err) =>
            console.error(err)
        )

    remove: () ->
        br = exec("git rev-parse --abbrev-ref HEAD", {silent: true})
        br = br.split("\n")
        creator = exec("git log HEAD~1..HEAD --pretty=format:%an", {silent: true})
        request = http.get("#{url}/Remove?creator=#{creator}&branch=#{br}", (error, response, body) =>
            console.log(body)
        )
        request.on("error", (err) =>
            console.error(err)
        )

    push: () ->
        return console.log("输入的参数有误！") if (parms.length isnt 1)
        if (parms.length is 1)
            num = parms[0].split('@~')
            console.log "num", num
            return console.log('请输入正确的头指针') if(num[1] < 0)
            br = exec("git rev-parse --abbrev-ref HEAD", {silent: true})
            creator = exec("git log HEAD~1..HEAD --pretty=format:%an", {silent: true})
            br = br.split('\n')
            base = exec("git rev-parse HEAD~#{num[1]}", {silent: true})
            base = base.split('\n')
            ci = exec("git log HEAD~#{+num[1]+1}..HEAD --pretty=format:%H", {silent: true})
            curCi = ci.split('\n')
            console.log "curci", curCi
            rev = []
            for i in [(curCi.length - 1)..0]
                rev.push(curCi[i])
            console.log "rev", rev
            rev = JSON.stringify(rev)
            console.log "push", rev
            request = http.get("#{url}/Push?creator=#{creator}&branch=#{br}&commit=#{rev}&head=#{base[0]}", (error, response, body) =>
                console.log(body)
            )
            request.on("error", (err) =>
                console.error(err)
            )
}

if(arr.length is 1)
    action[arr[0]]()
if(arr.length > 1)
    parms = arr.slice(1)
    action[arr[0]]()



